//Freeslot block
freeslot("MT_CONFLEGGRATOR",
"MT_CONFLEGGRATOR_AXIS",
"MT_CONFLEGGRATOR_SHELL1",
"MT_CONFLEGGRATOR_SHELL2",
"MT_CONFLEGGRATOR_SHELL3"
)

local pi = FixedDiv(355*FRACUNIT, 113*FRACUNIT) //Pi (fracunit-scale)
local confleggs = {}
local confleggshells = {}

//Gravity/scale multiplier for vertical momentum shifts
local function P_GravAndScale(mobj)
	return P_MobjFlip(mobj)*mobj.scale
end

//Sets whether a specified mobj is vertically flipped
local function P_SetMobjFlip(mobj, flip)
	if flip then
		mobj.flags2 = $|MF2_OBJECTFLIP
		mobj.eflags = $|MFE_VERTICALFLIP
	else
		mobj.flags2 = $ & ~MF2_OBJECTFLIP
		mobj.eflags = $ & ~MFE_VERTICALFLIP
	end
end

//Makes the specified Confleggrator fire a projectile of the specified type and scale at the specified
//vertical angle
local function ConfleggratorFire(mobj, type, scale, van)
	scale = FixedMul($, mobj.scale)
	local info = mobjinfo[type];
	local speed = FixedMul(info.speed, scale)
	local han = mobj.angle
	local hoff = 77*mobj.scale
	local voff = 44*mobj.scale
	//Adjust vertical angle and offset in relation to direction of gravity and projectile size
	if mobj.eflags & MFE_VERTICALFLIP then
		van = -$
		voff = mobj.height - $
	end
	voff = $ - FixedMul(info.height/2, scale)*P_MobjFlip(mobj)
	//Spawn shot mobj
	local shot = P_SpawnMobj(mobj.x + FixedMul(hoff, cos(han)),
							 mobj.y + FixedMul(hoff, sin(han)), mobj.z + voff, type)
	shot.target = mobj //Don't hurt the object that fired you
	if mobj.eflags & MFE_VERTICALFLIP then
		P_SetMobjFlip(shot, true)
		shot.z = $ - FixedMul(shot.height, scale)
	end
	shot.angle = han
	shot.scale = scale
	//Send shot off
	shot.momx = FixedMul(FixedMul(speed, cos(han)), cos(van))
	shot.momy = FixedMul(FixedMul(speed, sin(han)), cos(van))
	shot.momz = FixedMul(speed, sin(van))
end

//Makes the specified Confleggrator shed the specified shell object
local function ConfleggratorShedShell(conflegg, shell)
	if shell.valid then
		shell.momx = conflegg.shedmomx
		shell.momy = conflegg.shedmomy
		shell.flags = $ & ~(MF_NOGRAVITY|MF_BOSS)
		shell.flags2 = $ & ~MF2_FRET
		shell.fuse = 36
		shell.conflegg = nil
	end
end

//Confleggrator spawn actions
addHook("MobjSpawn", function(mobj)
	mobj.healthstate = 0 //0 = normal, 1 = hurt before pinch, 2 = pinch, 3 = dead
	mobj.shedmomx = 0
	mobj.shedmomy = 0
	table.insert(confleggs, mobj)
	//Spawn shell objects
	mobj.shell1 = P_SpawnMobj(mobj.x, mobj.y, mobj.z, MT_CONFLEGGRATOR_SHELL1)
	mobj.shell1.conflegg = mobj
	table.insert(confleggshells, mobj.shell1)
	mobj.shell2 = P_SpawnMobj(mobj.x, mobj.y, mobj.z, MT_CONFLEGGRATOR_SHELL2)
	mobj.shell2.conflegg = mobj
	table.insert(confleggshells, mobj.shell2)
	mobj.shell3 = P_SpawnMobj(mobj.x, mobj.y, mobj.z, MT_CONFLEGGRATOR_SHELL3)
	mobj.shell3.conflegg = mobj
	table.insert(confleggshells, mobj.shell3)
end, MT_CONFLEGGRATOR)

//Confleggrator every-tic thinker
addHook("MobjThinker", function(mobj)
	if not (mobj.health) then //Don't do any of this if you're dead
		return false //Don't override default behavior
	end
	//When transitioning to your pinch phase, record when you've recovered from being hit
	if (mobj.healthstate == 1)
	and not (mobj.flags2 & MF2_FRET) then
		mobj.healthstate = 2
	end
	if mobj.movestate == nil then //Initialize everything
		//Find the nearest Confleggrator axis
		local nearestaxis = nil
		local shortestdist = nil
		for mobj2 in mobjs.iterate()
			if mobj2.type == MT_CONFLEGGRATOR_AXIS then
				local dist = P_AproxDistance(mobj2.x - mobj.x, mobj2.y - mobj.y)
				if (nearestaxis == nil)
				or (dist < shortestdist) then
					nearestaxis = mobj2
					shortestdist = dist
				end
			end
		end
		//If you couldn't find one, just disappear
		if nearestaxis == nil then
			P_RemoveMobj(mobj)
			return false //Don't override default behavior
		end
		mobj.axis = nearestaxis
		mobj.axisdist = shortestdist
		mobj.scaledspeed = FixedMul(mobj.info.speed, mobj.scale)
		local arounddist = FixedMul(FixedMul(FRACUNIT/2, pi), mobj.axisdist)
		mobj.moveangle = FixedMul(FixedDiv(90*mobj.scaledspeed, arounddist), ANG1)
		mobj.acrosstime = (2*mobj.axisdist)/mobj.scaledspeed
		mobj.axisangle = R_PointToAngle2(mobj.axis.x, mobj.axis.y, mobj.x, mobj.y)
		mobj.movedir = 1 //1 = counterclockwise, -1 = clockwise
		//Move vertically toward the axis
		mobj.momz = mobj.scaledspeed
		if mobj.z > mobj.axis.z then
			mobj.momz = -$
		end
		mobj.movestate = 0
	end
	if mobj.movestate == 0 then //Moving vertically toward the axis
		if abs(mobj.axis.z - mobj.z) < abs(mobj.momz) then
			//You're there
			P_MoveOrigin(mobj, mobj.x, mobj.y, mobj.axis.z)
			mobj.momz = 0
			mobj.movestate = 1
		end
	end
	if (mobj.movestate >= 1)
	and (mobj.movestate <= 2) then //Moving around the axis
		if mobj.pinchfiretimer == nil then
			mobj.pinchfiretimer = 0
		end
		mobj.angle = mobj.axisangle + ANGLE_180 //Face the axis
		//Pinch fire attack
		if mobj.healthstate == 2 then
			//Fire bursts of five flames
			if mobj.pinchfiretimer < 5 then
				if mobj.pinchfiretimer == 0 then
					S_StartSound(mobj, sfx_s3k70)
				end
				ConfleggratorFire(mobj, MT_CONFLEGGRATOR_FLAME, 2*FRACUNIT, 0)
			end
			mobj.pinchfiretimer = ($ + 1) % TICRATE //Count up until it's time for the next one
		end
		if mobj.movestate == 1 then //Actually moving
			if mobj.destangle == nil then
				local moveccw //Should you move counterclockwise or clockwise around the circle?
				if P_BossTargetPlayer(mobj, true) then
					//If the nearest player is to your left, move counterclockwise, and vice versa
					local mo = mobj.target
					moveccw = (R_PointToAngle2(mobj.x, mobj.y, mo.x, mo.y) - mobj.angle > 0)
				else //If you couldn't find a player, just pick randomly
					moveccw = P_RandomChance(FRACUNIT/2)
				end
				if moveccw then
					mobj.movedir = 1
				else
					mobj.movedir = -1
				end
				mobj.destangle = mobj.axisangle + mobj.movedir*ANGLE_90
			end
			mobj.axisangle = $ + mobj.movedir*mobj.moveangle //Update desired angle from axis
			//Move to attain that angle
			local newx = mobj.axis.x + FixedMul(mobj.axisdist, cos(mobj.axisangle))
			local newy = mobj.axis.y + FixedMul(mobj.axisdist, sin(mobj.axisangle))
			mobj.momx = newx - mobj.x
			mobj.momy = newy - mobj.y
			//If you've reached your destination angle, stop to wait for any pinch fire bursts to finish
			if abs(mobj.destangle - mobj.axisangle) < mobj.moveangle then
				mobj.axisangle = mobj.destangle
				mobj.destangle = nil
				mobj.momx = 0
				mobj.momy = 0
				mobj.movestate = 2
			end
		end
		if mobj.movestate == 2 then //Stopped to wait for pinch fire bursts
			//If there isn't one happening, prepare to move across the circle
			if not ((mobj.healthstate == 2) and (mobj.pinchfiretimer > 0)
				and (mobj.pinchfiretimer < 5)) then
					mobj.pinchfiretimer = nil
					mobj.preparetimer = 24
					mobj.movestate = 3
			end
		end
	end
	if (mobj.movestate >= 3)
	and (mobj.movestate <= 5) then //Moving across the circle
		mobj.angle = $ - mobj.movedir*ANG15 //Spin
		if mobj.movestate == 3 then //Preparing to move
			//Count down until it's time to start moving
			if mobj.preparetimer > 0 then
				mobj.preparetimer = $ - 1
			else
				mobj.axisangle = $ + ANGLE_180
				mobj.momx = FixedMul(mobj.scaledspeed, cos(mobj.axisangle))
				mobj.momy = FixedMul(mobj.scaledspeed, sin(mobj.axisangle))
				mobj.acrosstimer = mobj.acrosstime
				mobj.movestate = 4
			end
		end
		if mobj.movestate == 4 then //Actually moving
			//Count down until it's time to stop
			if mobj.acrosstimer > 0 then
				mobj.acrosstimer = $ - 1
			else
				mobj.momx = 0
				mobj.momy = 0
				mobj.movestate = 5
			end
		end
		if mobj.movestate == 5 then //Stopped after moving
			//If you're facing toward the axis again, start moving around it
			if abs(mobj.angle - mobj.axisangle + ANGLE_180) < ANG15 then
				mobj.movestate = 1
			end
		end
	end
	//Flamethrower attack
	if (((mobj.healthstate == 0) and (mobj.movestate == 1))
		or (mobj.movestate == 4))
	and (leveltime % 2 == 0) then
		S_StartSound(mobj, sfx_fire)
		ConfleggratorFire(mobj, MT_CYBRAKDEMON_FLAMESHOT, FRACUNIT, -ANGLE_45)
	end
end, MT_CONFLEGGRATOR)

//Confleggrator damage actions
addHook("MobjDamage", function(target, inflictor, source, damage)
	//Determine the momentum of any shells that will be shed from this damage
	if (inflictor) and (inflictor.valid) then
		target.shedmomx = inflictor.momx/2
		target.shedmomy = inflictor.momy/2
		//Account for players bouncing back
		if inflictor.type == MT_PLAYER then
			target.shedmomx = -$
			target.shedmomy = -$
		end
	end
end, MT_CONFLEGGRATOR)

//Global every-tic thinker
addHook("ThinkFrame", do
	//Do stuff here to make sure it happens after everything else
	local remainingshells = {} //Record which Confleggrator shells still exist
	for _, shell in pairs(confleggshells)
		if (shell) and (shell.valid) then
			if shell.conflegg then //Supposed to be following Confleggrator
				if shell.conflegg.valid then //Confleggrator exists
					//Follow it
					P_MoveOrigin(shell, shell.conflegg.x, shell.conflegg.y, shell.conflegg.z)
					shell.angle = shell.conflegg.angle
					shell.scale = shell.conflegg.scale
					P_SetMobjFlip(shell, shell.conflegg.eflags & MFE_VERTICALFLIP)
					//Flash along with it if it's hurt
					if shell.conflegg.flags2 & MF2_FRET then
						shell.flags = $|MF_BOSS
						shell.flags2 = $|MF2_FRET
					else
						shell.flags = $ & ~MF_BOSS
						shell.flags2 = $ & ~MF2_FRET
					end
				else //Confleggrator has been removed; remove yourself too
					P_RemoveMobj(shell)
					continue
				end
			end
			table.insert(remainingshells, shell)
		end
	end
	confleggshells = remainingshells
	local remainingconfleggs = {} //Record which Confleggrators still exist
	for _, conflegg in pairs(confleggs)
		if (conflegg) and (conflegg.valid) then
			//Shed the appropriate shell objects when your health drops low enough
			if (conflegg.health <= conflegg.info.damage)
			and (conflegg.healthstate < 1) then
				S_StartSound(conflegg, sfx_bedeen)
				ConfleggratorShedShell(conflegg, conflegg.shell2)
				conflegg.shell2 = nil
				conflegg.healthstate = 1
			end
			if not (conflegg.health)
			and (conflegg.healthstate < 3) then
				S_StartSound(conflegg, sfx_bedeen)
				ConfleggratorShedShell(conflegg, conflegg.shell1)
				conflegg.shell1 = nil
				ConfleggratorShedShell(conflegg, conflegg.shell3)
				conflegg.shell3 = nil
				conflegg.healthstate = 3
			end
			//Determine hitbox size based on shells
			if conflegg.shell2 then
				conflegg.height = 96*conflegg.scale
			else
				conflegg.height = 76*conflegg.scale
			end
			if conflegg.shell3 then
				conflegg.radius = 48*conflegg.scale
			else
				conflegg.radius = 24*conflegg.scale
			end
			//Reset shed momentum variables so their values only apply on the tic they were set
			conflegg.shedmomx = 0
			conflegg.shedmomy = 0
			table.insert(remainingconfleggs, conflegg)
		end
	end
	confleggs = remainingconfleggs
	for _, shell in pairs(confleggshells)
		if not (shell.conflegg) then //Not supposed to be following Confleggrator
			//If fuse is active, flash by toggling invisibility every 2 tics
			if (shell.fuse > 0)
			and (shell.fuse % 2 == 0) then
				shell.flags2 = $ ^^ MF2_DONTDRAW
			end
		end
	end
end)
