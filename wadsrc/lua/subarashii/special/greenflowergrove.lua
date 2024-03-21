// --------------------------------------
// LUA_ISOM
// The isometric view!
// Contains some code copied from toaster's
// modification of Sky Labyrinth's lua
// (Specifically the bouncing part,
// that was much better than
// the original's version!)
// --------------------------------------
local cam_dist = 600*FRACUNIT
local cam_height = 400*FRACUNIT
local cam_angle = FixedAngle(45*FRACUNIT)
local doublejumpsonic = false

addHook("PlayerSpawn", function(player)
    if(player.mo and player.mo.valid)
        if(mapheaderinfo[gamemap].threedimensionalexplosion)
            player.threedimensionalexplosion = true
        elseif(player.threedimensionalexplosion)
            player.normalspeed = skins[player.mo.skin].normalspeed
            player.jumpfactor = skins[player.mo.skin].jumpfactor
			player.mindash = skins[player.mo.skin].mindash
            player.maxdash = skins[player.mo.skin].maxdash
			player.charability = skins[player.mo.skin].ability // Salt: Dang it, Tripel... :p
			player.thokitem = skins[player.mo.skin].thokitem
			if(player.thokitem < 0)
				player.thokitem = mobjinfo[MT_PLAYER].painchance
			end
			player.spinitem = skins[player.mo.skin].spinitem
			if(player.spinitem < 0)
				player.spinitem = mobjinfo[MT_PLAYER].damage
			end
			player.revitem = skins[player.mo.skin].revitem
			if(player.revitem < 0)
				player.revitem = mobjinfo[MT_PLAYER].raisestate
			end
            player.threedimensionalexplosion = false
        end
    end
end)

// This uses a mobj thinker instead of think frame so the camera keeps up better! (not 1 frame behind)
addHook("MobjThinker", function(mobj)
	if not(mapheaderinfo[gamemap].threedimensionalexplosion)
		return
	end

	if (mobj.flags2 & MF2_TWOD) return end // Salt, almost 5 months later: A

	if(mobj.player and mobj.player.valid)		// This is an actual player!
		mobj.player.threedimensionalexplosion = true
		// --------------------------------------------------
		// Isometric camera
		// --------------------------------------------------
		// Get the target location!
		local targx = mobj.x+FixedMul(-cos(cam_angle), cam_dist)
		local targy = mobj.y+FixedMul(-sin(cam_angle), cam_dist)
		local targz = mobj.z+(cam_height*P_MobjFlip(mobj))

		if(mobj.exithacktimer)
			targx = mobj.stupidfakecamerax+FixedMul(-cos(cam_angle), cam_dist)
			targy = mobj.stupidfakecameray+FixedMul(-sin(cam_angle), cam_dist)
			targz = mobj.stupidfakecameraz+(cam_height*P_MobjFlip(mobj))
		end

		// Spawn the camera object!
		if not(mobj.isometriccamera and mobj.isometriccamera.valid)
			mobj.isometriccamera = P_SpawnMobj(targx, targy, targz, MT_GARGOYLE)
		end
		mobj.isometriccamera.momx = 0
		mobj.isometriccamera.momy = 0
		mobj.isometriccamera.momz = 0
		mobj.isometriccamera.flags = $1 & ~(MF_SOLID|MF_PUSHABLE)
		mobj.isometriccamera.flags = $1|MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT
		mobj.isometriccamera.flags2 = $1|MF2_DONTDRAW
		mobj.isometriccamera.angle = cam_angle
		P_MoveOrigin(mobj.isometriccamera, targx, targy, targz)

		// Set the view!
		mobj.player.awayviewmobj = mobj.isometriccamera
		mobj.player.awayviewtics = 2
		mobj.player.awayviewaiming = R_PointToAngle2(0, targz, R_PointToDist2(mobj.x, mobj.y, targx, targy), mobj.z)

		// --------------------------------------------------
		// Stat changes
		// --------------------------------------------------
		// Force analog mode!
		//COM_BufInsertText(mobj.player, "sessionanalog on")		// Forcing PF_ANALOGMODE doesn't work properly
		//mobj.player.pflags = $1 | PF_ANALOGMODE
		// sal: neither work now, so I guess you don't get any!
		if(leveltime <= 1)	// HACK, 2.2
	//		mobj.angle = ANGLE_270
			mobj.player.drawangle = ANGLE_270
		end
		mobj.angle = ANGLE_45	// HACK, 2.2.1

		// Reduce the player's speed!
		mobj.player.normalspeed = skins[mobj.skin].normalspeed*2/3
		mobj.player.runspeed = skins[mobj.skin].runspeed*2/3

		// Ability nerfs!
		if(mobj.player.charability == CA_THOK)
			or(mobj.player.charability == CA_HOMINGTHOK)
			or(mobj.player.charability == CA_GLIDEANDCLIMB)
			mobj.player.actionspd = skins[mobj.skin].actionspd*2/3
		end

		// a
		if(mobj.player.climbing)
			mobj.player.climbing = 0
			mobj.player.pflags = $1|PF_JUMPED|PF_THOKKED
			if(mobj.player.charflags & SF_NOJUMPDAMAGE)
				mobj.player.pflags = $1|PF_NOJUMPDAMAGE
			else
				mobj.player.pflags = $1 & !PF_NOJUMPDAMAGE
			end
			mobj.player.state = S_PLAY_JUMP
		end

		if(mobj.player.powers[pw_tailsfly] > 2*TICRATE)
			mobj.player.powers[pw_tailsfly] = 2*TICRATE
		end

		// Cosmetic changes
		mobj.player.spinitem = MT_NULL

		// Bouncing!
		if(mobj.player.pflags & PF_SPINNING)
			and not(mobj.player.pflags & PF_JUMPED)
			local wallchecker = P_SpawnMobj(mobj.x, mobj.y, mobj.z, MT_GARGOYLE)
			wallchecker.radius = mobj.radius
			wallchecker.height = mobj.height
			wallchecker.flags = ($1|MF_NOCLIPTHING) & !(MF_SOLID|MF_PUSHABLE)
			local hit = P_TryMove(wallchecker, mobj.x+mobj.momx, mobj.y+mobj.momy, true)
			P_RemoveMobj(wallchecker)
			if not(hit)
				mobj.momx = $1 - mobj.player.cmomx
				mobj.momy = $1 - mobj.player.cmomy
				local speed = R_PointToDist2(0, 0, mobj.momx, mobj.momy)
				P_BounceMove(mobj)
				local angle = R_PointToAngle2(0, 0, mobj.momx, mobj.momy)
				P_InstaThrust(mobj, angle, speed)
				mobj.momx = $1 + mobj.player.cmomx
				mobj.momy = $1 + mobj.player.cmomy
				if(mobj.player.pflags & PF_ANALOGMODE)
					mobj.player.drawangle = angle
					mobj.angle = angle
				end
			end
		end

		// END HACK!
		if(mobj.exitingthreedee)
			mobj.player.powers[pw_nocontrol] = 500*TICRATE
		end

		if(mobj.player.exiting) and not (mobj.player.failedlevel)
			mobj.momx = 0
			mobj.momy = 0
			if(mobj.exithacktimer == nil)
				mobj.exithacktimer = 0
				mobj.stupidfakecamerax = mobj.x
				mobj.stupidfakecameray = mobj.y
				mobj.stupidfakecameraz = mobj.z
			end
			mobj.exithacktimer = $1 + 1
			if(mobj.exithacktimer == 1)
				S_StartSound(nil, sfx_s3k6a, mobj.player)	// Warp sound

				if(gametype == GT_COMPETITION)
					local num = 0
					while(mobj.flickies and mobj.flickies[num] and mobj.flickies[num].valid)
						P_RemoveMobj(mobj.flickies[num])
						P_AddPlayerScore(mobj.player, 10000)	// Competition score!
						num = $1 + 1
					end
				elseif (gametyperules & GTR_CAMPAIGN)
					sugoi.AwardEmerald(true)
				end
			end
			mobj.momz = 10*FRACUNIT
			// Animation
			mobj.player.drawangle = $1 + FixedAngle(FRACUNIT*23)
			mobj.angle = $1 + FixedAngle(FRACUNIT*23)
			mobj.state = S_PLAY_SPRING
		end

		if(mobj.stupidthing)
			mobj.stupidthing = $1 - 1
		end
	end
end, MT_PLAYER)

// --------------------------------------
// LUA_FLKY
// Flickies! Everyone's (least) favorite part
// of Sonic 3D Blast/Flickies' island
// --------------------------------------
freeslot("MT_THREEDBLASTFLICKY", "MT_THREEDBLASTRING", "S_TDBFLICKY1", "S_TDBFLICKY2", "S_TDBFLICKY3", "S_TDBRING",
"SPR_FLKY", "SPR_WRNG", "SPR_FSHD",
"sfx_fget", "sfx_fhurt1", "sfx_fhurt2")

local flickytypes = 4
local flickyspeed = FRACUNIT/4
local numflickiesfreed = 0	// Reset every level
local flickiessaved = 0		// Ditto
local area = 1				// Ditto 2

local function flickyCollide(flicky, playermo)
	if not(flicky.collected)
		and not(flicky.flickytimer)
		and(playermo.player and playermo.player.valid)
		and(playermo and playermo.valid)
		and not(playermo.player.bot)
		and not(P_PlayerInPain(playermo.player))
		// Check for Z collision!
		and(flicky.z+flicky.height >= playermo.z)
		and(flicky.z <= playermo.z+playermo.height)
		flicky.collected = true
		flicky.target = playermo
		if(flicky.target.numflickies == nil)
			flicky.target.numflickies = 0
		end
		if(playermo.flickies == nil)
			playermo.flickies = {}
		end
		playermo.flickies[flicky.target.numflickies] = flicky
		flicky.target.numflickies = $1 + 1
		S_StartSound(flicky, sfx_fget)
	end
	if(playermo and playermo.valid)
	and(playermo.type == MT_TOKEN)
	and(flicky.target and flicky.target.valid)
	and(flicky.target.player and flicky.target.player.valid)
	and(flicky.z+flicky.height >= playermo.z) // Check for Z collision!
	and(flicky.z <= playermo.z+playermo.height)
		//S_StartSound(flicky.target, sfx_chchng)
		//P_AddPlayerScore(flicky.target.player, 10000)
		sugoi.AddToken(1, flicky.target.player)

		P_KillMobj(playermo)
	end
end

local function flickySpawn(enemy)
	if not(mapheaderinfo[gamemap].threedimensionalexplosion)
		or(gametype == GT_RACE)
		return
	end

	if(enemy and enemy.valid)
		and(enemy.flags & MF_ENEMY)
		local ftype
		if(enemy.type == MT_BLUECRAWLA)
			ftype = 0
		elseif(enemy.type == MT_GFZFISH)
			ftype = 1
		elseif(enemy.type == MT_REDCRAWLA)
			or(enemy.type == MT_POPUPTURRET)
			ftype = 2
		elseif(enemy.type == MT_GOLDBUZZ)
			ftype = 3
		else
			ftype = (enemy.type-MT_BLUECRAWLA)%flickytypes
		end

		if(ftype == nil)
			return
		end

		local flicky = P_SpawnMobj(enemy.x, enemy.y, enemy.z, MT_THREEDBLASTFLICKY)
		flicky.angle = enemy.angle
		flicky.ftype = ftype
		flicky.flickytimer = TICRATE/2
		flicky.collected = false
		numflickiesfreed = $1 + 1
	end
end

addHook("MobjMoveCollide", flickyCollide, MT_THREEDBLASTFLICKY)
addHook("MobjCollide", flickyCollide, MT_THREEDBLASTFLICKY)
addHook("MobjDeath", flickySpawn)

local function removeAnimal(bird)
	if not(mapheaderinfo[gamemap].threedimensionalexplosion)
		return
	end

	if(bird and bird.valid)
		P_RemoveMobj(bird)
		return
	end
end

local flicky = 0
while(flicky < 16)
	addHook("MobjThinker", removeAnimal, MT_FLICKY_01+(flicky*2))	// Between each flicky type, MT_FLICKY_xx_CENTER exists
	flicky = $1 + 1
end

addHook("MobjThinker", function(flicky)
	if(flicky.flickytimer)
		flicky.flickytimer = $1 - 1
	end
	if not(flicky.target and flicky.target)
		flicky.collected = false
	end
	if(flicky.collected)
		// Chase our target!
		// First, find our index in the list
		local targx = 0
		local targy = 0
		local targz = 0
		local index = 0
		while(flicky.target.flickies[index])
			and not(flicky.target.flickies[index] == flicky)
			index = $1 + 1
		end
		if((R_PointToDist2(0, 0, flicky.target.momx, flicky.target.momy) < flicky.target.scale) and(P_IsObjectOnGround(flicky.target)))
			or(flicky.target.stupidthing)
			local angle = FixedAngle((360*FRACUNIT/flicky.target.numflickies*index)-(leveltime*FRACUNIT*5))
			targx = FixedMul(cos(angle), flicky.radius+flicky.target.radius*2)+flicky.target.x
			targy = FixedMul(sin(angle), flicky.radius+flicky.target.radius*2)+flicky.target.y
		else
			if(index == 0)
				targx = flicky.target.x
				targy = flicky.target.y
			else
				targx = flicky.target.flickies[index-1].x
				targy = flicky.target.flickies[index-1].y
			end
		end
		targz = flicky.target.z+(flicky.target.height/2)-(flicky.target.momz*(index+1)*5)-(flicky.height/2)

		// Now that we have the target position, go towards it!
		flicky.angle = R_PointToAngle2(flicky.x, flicky.y, targx, targy)
		P_InstaThrust(flicky, flicky.angle, FixedMul(R_PointToDist2(flicky.x, flicky.y, targx, targy), flickyspeed))
		P_SetObjectMomZ(flicky, FixedMul(targz-flicky.z, flickyspeed*5/(index+1)))
		// Don't stick to the ground!
		if(P_IsObjectOnGround(flicky))
			P_MoveOrigin(flicky, flicky.x, flicky.y, flicky.z+P_MobjFlip(flicky))
		end
		// Float above the floor!
		if(P_MobjFlip(flicky) > 0)
			local targznew = flicky.floorz+(flicky.target.height/2)-(flicky.height/2)
			if(flicky.z+flicky.momz < targznew)
				P_SetObjectMomZ(flicky, -flicky.z+targznew)
			end
		else
			local targznew = flicky.ceilingz-(flicky.target.height/2)-(flicky.height/2)
			if(flicky.z+flicky.momz > targznew)
				P_SetObjectMomZ(flicky, -flicky.z+targznew)
			end
		end
	//	if(P_IsObjectOnGround(flicky.target))
	//		P_SetObjectMomZ(flicky, FixedMul(targz-flicky.z, flickyspeed/2))
	//	end
		if(R_PointToDist2(flicky.x, flicky.y, targx, targy) > 700*FRACUNIT)
			P_MoveOrigin(flicky, targx-flicky.momx, targy-flicky.momy, flicky.z)
		end
	else
		if(flicky.ftype == nil)
			or not(flicky.ftype == 2)
			// Don't stick to the ground!
			if(P_IsObjectOnGround(flicky))
				P_MoveOrigin(flicky, flicky.x, flicky.y, flicky.z+P_MobjFlip(flicky))
			end
			// Float above the floor!
			if(P_MobjFlip(flicky) > 0)
				local targznew = flicky.floorz+(FixedMul(mobjinfo[MT_PLAYER].height, flicky.scale)/2)-(flicky.height/2)
				if(flicky.z+flicky.momz < targznew)
					P_SetObjectMomZ(flicky, -flicky.z+targznew)
				end
			else
				local targznew = flicky.ceilingz-(FixedMul(mobjinfo[MT_PLAYER].height, flicky.scale)/2)-(flicky.height/2)
				if(flicky.z+flicky.momz > targznew)
					P_SetObjectMomZ(flicky, -flicky.z+targznew)
				end
			end
		end
		if(flicky.ftype == nil)
			or(flicky.ftype == 0)
			or(flicky.ftype >= 4)
			flicky.color = SKINCOLOR_BLUE
			if(P_LookForPlayers(flicky, 4000*FRACUNIT, true, true))
				P_Thrust(flicky, R_PointToAngle2(flicky.x, flicky.y, flicky.tracer.x, flicky.tracer.y), FRACUNIT/4)
				flicky.angle = R_PointToAngle2(flicky.x, flicky.y, flicky.tracer.x, flicky.tracer.y)
			end
			flicky.momx = $1*30/31
			flicky.momy = $1*30/31
		elseif(flicky.ftype == 1)
			flicky.color = SKINCOLOR_MAGENTA
			flicky.momx = $1*40/41
			flicky.momy = $1*40/41
			if(P_LookForPlayers(flicky, 500*FRACUNIT, false, true))
				flicky.angle = R_PointToAngle2(flicky.x, flicky.y, flicky.tracer.x, flicky.tracer.y)
				P_Thrust(flicky, flicky.angle, FRACUNIT/4)
			else
				flicky.angle = $1 + FixedAngle(3*FRACUNIT)
				P_Thrust(flicky, flicky.angle, FRACUNIT/4)
			end
		elseif(flicky.ftype == 2)
			flicky.color = SKINCOLOR_RED
			if(P_IsObjectOnGround(flicky))
				flicky.angle = $1 + FixedAngle(180*FRACUNIT)
				P_MoveOrigin(flicky, flicky.x, flicky.y, flicky.z+P_MobjFlip(flicky))
				P_SetObjectMomZ(flicky, 10*FRACUNIT)
				P_InstaThrust(flicky, flicky.angle, 5*FRACUNIT)
			end
		elseif(flicky.ftype == 3)
			flicky.color = SKINCOLOR_EMERALD
			flicky.momx = $1*40/41
			flicky.momy = $1*40/41
			flicky.angle = $1 + FixedAngle(3*FRACUNIT)
			P_Thrust(flicky, flicky.angle, FRACUNIT/4)
		end
	end
	flicky.shadowscale = FRACUNIT
end, MT_THREEDBLASTFLICKY)

addHook("MobjDamage", function(playermo)
	if(playermo.flickies)
		local index = 0
		while(playermo.flickies[index] and playermo.flickies[index].valid)
			playermo.flickies[index].flickytimer = TICRATE/2
			playermo.flickies[index].collected = false
			playermo.flickies[index] = nil
			index = $1 + 1
		end
	end
	if(playermo.numflickies)
		S_StartSound(playermo, sfx_fhurt2)
	end
	playermo.numflickies = 0

	if not (mapheaderinfo[gamemap].threedimensionalexplosion) return end // Salt: SS-style eject instead of death
	if not (playermo.player) return end

	local player = playermo.player
	if (player.bot) return end

	if (player.powers[pw_shield]) return end
	if (player.powers[pw_invulnerability]) return end
	if (player.powers[pw_super]) return end
	if (player.rings > 0) return end

	P_DoPlayerPain(player)
	P_DoPlayerExit(player)
	return true
end, MT_PLAYER)

// Warp ring

// Setup the ring's values!
local function ringSpawn(ring)
	if(ring.spawnpoint == nil)
		ring.flickiesleft = 5
		ring.last = true
		ring.tag = AngleFixed(ring.angle)/FRACUNIT
	else
		ring.flickiesleft = ring.spawnpoint.extrainfo	// Paramater in Zone Builder
		ring.last = false
		if(ring.flickiesleft == 5)	// EW
			ring.last = true
		end
		ring.tag = ring.spawnpoint.angle
	end
	ring.angle = 0
end

//addHook("MobjSpawn", ringSpawn, MT_THREEDBLASTRING)

addHook("MobjMoveCollide", function(ring, playermo)
	// The object has to exist!
	if not(playermo and playermo.valid)
		return
	end

	// Check for Z collision!
	if not((ring.z+ring.height >= playermo.z) and(ring.z <= playermo.z+playermo.height))
		return
	end

	// Must be a player!
	if not(playermo.type == MT_PLAYER)
		return
	end

	// Not multiple players at a time!
	if(ring.target and ring.target.valid)	// Already have a target?
		return
	end

	ring.target = playermo
end, MT_THREEDBLASTRING)

addHook("MobjThinker", function(ring)
	if(ring.flickiesleft == nil)
		ringSpawn(ring)
	end

	if(gametype == GT_COMPETITION or gametype == GT_RACE)	// Why is there no race gametype function
		P_LinedefExecute(ring.tag)
		P_RemoveMobj(ring)
		return
	end

	local playermo = ring.target
	if not(playermo and playermo.valid)
		return
	end

	if(playermo.flickies)
		and(playermo.numflickies)
		and(ring.flickiesleft)
		playermo.stupidthing = 2

		// This wasn't in the right place before oops
		if not(playermo.state == S_PLAY_ROLL)
			playermo.state = S_PLAY_ROLL
		end
		if(playermo.tics > 1)
			playermo.tics = 1
		end

		playermo.player.pflags = $1|PF_THOKKED	// Can't use your jump abilities!

		if not(ring.flickytimer)
			ring.target = playermo
			P_RemoveMobj(playermo.flickies[0])
		//	print("Removed!")
			playermo.flickies[0] = nil
			playermo.numflickies = $1 - 1
			ring.flickiesleft = $1 - 1
			S_StartSound(nil, sfx_s3kb3)
			// Move the rest of the flickies down!
			local index = 1
			while(playermo.flickies[index] and playermo.flickies[index].valid)
				playermo.flickies[index-1] = playermo.flickies[index]
				if not(playermo.flickies[index+1] and playermo.flickies[index+1].valid)
					playermo.flickies[index] = nil
				end
				index = $1 + 1
			end
			flickiessaved = $1 + 1
			ring.flickytimer = TICRATE/2
		else
			ring.flickytimer = $1 - 1
		end
		playermo.momx = (ring.x-playermo.x)/2
		playermo.momy = (ring.y-playermo.y)/2
		playermo.momz = (ring.z-playermo.z)/2
	else
		ring.target = nil
		return
	end

	// Remove the ring once we've saved all the flickies!
	if not(ring.flickiesleft)
	//	print("Tag is: "+ring.tag+"\nShould be executed!")
		P_LinedefExecute(ring.tag)
		S_StartSound(nil, mobjinfo[ring.type].activesound)
		if(playermo and playermo.valid)
			and(ring.last)
			playermo.player.powers[pw_nocontrol] = 500*TICRATE
			playermo.exitingthreedee = true
		else
			numflickiesfreed = 0
			flickiessaved = 0
			area = $1 + 1
		end
		P_RemoveMobj(ring)
		return
	end
end, MT_THREEDBLASTRING)

addHook("TouchSpecial", function()
	return true
end, MT_THREEDBLASTFLICKY)
addHook("TouchSpecial", function()
	return true
end, MT_THREEDBLASTRING)

addHook("MapChange", function()
	numflickiesfreed = 0
	flickiessaved = 0
	area = 1
end)

local function drawhud(v, player, camera)
	if not(mapheaderinfo[gamemap].threedimensionalexplosion)
		or(gametype == GT_RACE)
		return
	end
	local num = 0
	if(player.mo and player.mo.valid)
		while(player.mo.flickies and player.mo.flickies[num] and player.mo.flickies[num].valid)
			num = $1 + 1
		end
	end

	if(gametype == GT_COMPETITION)
		v.drawString(320-80, 200-16, "Flickies Saved:", V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_YELLOWMAP, "thin")
		v.drawString(320-4, 200-8, num, V_SNAPTOBOTTOM|V_SNAPTORIGHT, "right")
	else
		local num2 = mapheaderinfo[gamemap].area1flickies
		if(area == 2)
			num2 = mapheaderinfo[gamemap].area2flickies
		elseif(area == 3)
			num2 = mapheaderinfo[gamemap].area3flickies
		elseif(area == 4)
			num2 = mapheaderinfo[gamemap].area4flickies
		elseif(area == 5)
			num2 = mapheaderinfo[gamemap].area5flickies
		end
		v.drawString(320-80, 200-16, "Flickies Saved:", V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_YELLOWMAP, "thin")
		v.drawString(320-4, 200-8, num+" / "+(numflickiesfreed-flickiessaved)+" / "+(num2-flickiessaved), V_SNAPTOBOTTOM|V_SNAPTORIGHT, "right")
	end
end
hud.add(drawhud, "game")

