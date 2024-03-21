//thonkframes list:

addHook("ThinkFrame", function()
	// Sal: Only run on DWZ & DS
	if (mapheaderinfo[gamemap].darkstabot)
	or (mapheaderinfo[gamemap].dwz)
		P_Activate1()
		P_Activate2()
		P_Activate4()
	end
end)

//Desolate Woods Stuff
//...Contains anime meterial.

local cutscene = true
local cutscenemode = false
local cutscenetimer = 0
local playerCam = nil

addHook("NetVars", function(network)
	cutscene = network(cutscene)
	cutscenetimer = network(cutscenetimer)
	cutscenemode = network(cutscenemode)
	playerCam = network(playerCam)
end)

freeslot(
	"MT_LEAF", "S_LEAF", "SPR_LEAF",
	"MT_STEALFACESSHARK",
	"MT_XEYE",
	"S_SFSHARKSHOT2",
	"S_XEYETEC",
	"MT_XEYECUTSCENE",
	"MT_STEALFACESSHARKCUTSCENE",
	"MT_CARTOONSWEAT"
)
freeslot("S_CARTOONSWEAT1","S_CARTOONSWEAT2")
freeslot("SPR_DRIC")
freeslot("sfx_shock", "sfx_yell", "sfx_runaw", "sfx_xyzro", "sfx_sfshy", "O_RTIO")

mobjinfo[MT_CARTOONSWEAT] = {
	doomednum = -1,
	spawnstate = S_CARTOONSWEAT1,
	seestate = S_CARTOONSWEAT1,
	deathstate = S_CARTOONSWEAT1,
	spawnhealth = 1000,
	radius = 5*FRACUNIT,
	height = 5*FRACUNIT,
	flags = MF_SPECIAL|MF_NOGRAVITY|MF_FLOAT
}

states[S_CARTOONSWEAT1] = {SPR_DRIC, A, 30, nil, 0, 0, S_CARTOONSWEAT2}
states[S_CARTOONSWEAT2] = {SPR_DRIC, A, 15, A_ZThrust, -1, 1, S_NULL}

mobjinfo[MT_LEAF] = {
	doomednum = -1,
	spawnstate = S_LEAF,
	seestate = S_LEAF,
	deathstate = S_LEAF,
	spawnhealth = 1000,
	radius = 5*FRACUNIT,
	height = 5*FRACUNIT,
	flags = MF_SPECIAL|MF_NOGRAVITY|MF_FLOAT
}

states[S_LEAF] = {SPR_LEAF, A, 1, nil, 0, 0, S_LEAF}

//Fast Spin Animation:

freeslot("S_PLAY_FASTROLL")
states[S_PLAY_FASTROLL] = {SPR_PLAY, SPR2_ROLL, 1, nil, 0, 0, S_PLAY_FASTROLL}

local function InAtkState(target)
	if not (target and target.valid)
	or not (target.player and target.player.valid)
		return false;
	end

	local player = target.player;
	if ((player.pflags & PF_JUMPED) and not (player.pflags & PF_NOJUMPDAMAGE))
	or (player.pflags & PF_SPINNING)
		return true;
	end

	return false;
end

//Cutscene Trigger:

local function CheckIf(line, mo)
	if cutscene == true //if the cutscene option is true
		cutscenemode = true //the cutscene begins
		mo.player.cutscenemode = true //the player object is inside the cutscene.
	end
end
addHook("LinedefExecute", CheckIf, "CUTSCENE")

//Leaves Trigger:

local function LeavesFallen(line, mo)

	S_StartSound(mo,sfx_s3k42) //lil' sound effect for the leaves

    local z = (mo.z) //we'll set the z as the object's

		for i = 1, 20 //20 leaves will be spawned

			P_SpawnMobj(P_RandomRange(16895, 17920)*FRACUNIT,P_RandomRange(-3936, 2840)*FRACUNIT,z,MT_LEAF) //the leaves themselves

	    end
end
addHook("LinedefExecute", LeavesFallen, "LEAVES")

//Mushroom Trigger:

local function MushroomJump(line, mo)
	if (mo and mo.player) //if the object is valid and the object is a player

		mo.state = S_PLAY_FASTROLL //set the object state to spin frames

			mo.momz = 22*FRACUNIT //gain height
			mo.momx = 0 // force stop x and y movement
			mo.momy = 0
			mo.player.mush = true //the player will get the mushroom effect
			mo.player.mushtics = 0 //reset the tics of the effect

		    S_StartSound(mo,sfx_s3k87) //fitting sound effect
    end
end
addHook("LinedefExecute", MushroomJump, "MUSH")

//No Control Alt Trigger:

local function NoControl(line, mo)
	if (mo and mo.player) //if the object is valid and the object is a player

		mo.player.pflags = ($1|PF_FULLSTASIS) //that's it... just the linedef execute "Disable Player Control" fails its job :P
		mo.momx = $1 + 5*FRACUNIT //gain speed!
		mo.angle = FixedAngle(0*FRACUNIT) //LOOK OVER THERE!

    end
end
addHook("LinedefExecute", NoControl, "CTRLOFF")

//Innocent Angle Trigger:

local function AAA(line, mo)
	if (mo and mo.player) //if the object is valid and the object is a player

		mo.angle = FixedAngle(0*FRACUNIT) //woaw

    end
end
addHook("LinedefExecute", AAA, "ANGLE")

rawset(_G, "P_Activate1", function()

		if cutscenemode == true //if the cutscene is now playing
			if cutscene == true //and the cutscene option is true
				cutscenetimer = $1 + 1 //start counting tics
		    else               //else if the cutscene option is false
		        cutscenetimer = 0 //resets the timer.
		    end
	    end

	for player in players.iterate //all-players iteration

		if player.cutscenemode == nil
			player.cutscenemode = false //the player's cutscene trigger will be false as a default
		end

		if player.cutscenemode == true //if the player is inside the cutscene
			player.powers[pw_nocontrol] = 1 //can't move.
		end

		if player.spawntimer == nil
		    player.spawntimer = 0 //the player's spawn timer
		end

		if player.playerstate == PST_LIVE //if the player is alive
		and player.spawntimer <= 200 //and the spawn timer is <= 200 tics:
		    player.spawntimer = $1 + 1 //starts counting tics
		end

		if (mapheaderinfo[gamemap].dwz) //if the map is desolate woods zone
		and player.spawntimer == 1 //and the spawn timer is 1
		and not (player.starposttime) //and the player haven't touched any checkpoints yet
		    player.differentcam = P_SpawnMobj(player.mo.x+120*FRACUNIT,player.mo.y+600*FRACUNIT,player.mo.z-400*FRACUNIT,MT_CAMERA) //spawn an alternative camera for the first scene
		    player.differentcam.angle = FixedAngle(230*FRACUNIT) //specific angle inside the map
				player.mo.state = S_PLAY_FALL //the player will start the level by falling
		end

		if (mapheaderinfo[gamemap].dwz) //if the map is desolate woods zone
		and player.spawntimer >= 0 //and the player's spawn timer >= 0 tics
		and player.spawntimer < 100 //and also < 100 tics
		and not (player.starposttime) //and the player haven't touched any checkpoints yet

			player.mo.angle = FixedAngle(90*FRACUNIT) //specific angle inside the map
			player.powers[pw_nocontrol] = 1 //can't move.

				if player.differentcam ~= nil //if the player's first scene alt cam exists in the map
					player.awayviewmobj = player.differentcam //set the player's view as the alt cam's
					player.awayviewtics = -1 //it will be the player's view until the script will make it stop
		        end
		end

		if (mapheaderinfo[gamemap].dwz) //if the map is desolate woods zone
		and player.spawntimer >= 100 //and the player's spawn timer >= 100 tics
		and not (player.starposttime) //and the player haven't touched any checkpoints yet
			player.awayviewtics = 0 //reset the player's current view
		end

		if player.mush == nil
			player.mush = false //the player's mushroom effect will be false as a default
		end

	    if player.mushtics == nil
			player.mushtics = 0 //tics as an addon for the mushroom effect
		end

		if player.mush == true //if the player's mushroom effect is true
			player.mushtics = $1 + 1 //count tics
		else
		    player.mushtics = 0 //don't, reset them instead.
		end

	    if (player.mo and player.mo.valid) //if the player's mobj exists

			if (player.mush == true) //if the player has the mushroom effect
		    and (P_IsObjectOnGround(player.mo)) //and they touch the ground
				player.mush = false //turn it off
		        player.mushtics = 0 //reset the effect's tics
		    end

		    if (player.mushtics == 1) //if the mush's tics on 1
				player.mo.momx = 0 //stop the object from x and y movement
		        player.mo.momy = 0
		    end

	        if (player.mush == true) //if the player has the mushroom effect
				local sparkle = P_SpawnMobj(P_RandomRange(player.mo.x/FRACUNIT-20,player.mo.x/FRACUNIT+20)*FRACUNIT,P_RandomRange(player.mo.y/FRACUNIT-20,player.mo.y/FRACUNIT+20)*FRACUNIT,P_RandomRange(player.mo.z/FRACUNIT, (player.mo.z + player.mo.height)/FRACUNIT)*FRACUNIT,MT_SNIGHTSPARKLE) //spawn sparkles
				sparkle.color = SKINCOLOR_PURPLE //color them sparkles!
				P_SetObjectMomZ(player.mo, gravity/2, true) //lat' hi
	        end

		    if (player.mush == true) //if the player has the mushroom effect
		    and (player.mo.state == S_PLAY_PAIN) //me irl (if the player is in their pain state)
				player.mush = false //stop the mushroom effect
				player.mushtics = 0 //reset its tics
		    end

		    if (player.mush == true) //if the player has the mushroom effect
		    and (player.mo.state == S_PLAY_DEAD) // die (if the player is in their death state)
				player.mush = false //stop the mushroom effect
				player.mushtics = 0 //reset its tics
		    end
	    end
    end


    if (mapheaderinfo[gamemap].dwz) //if the map is desolate woods zone
	and (leveltime % 7 == 0) //~every 7 seconds in this specific level~
		local sparkle = P_SpawnMobj(P_RandomRange(8164,8488)*FRACUNIT,P_RandomRange(17739,18005)*FRACUNIT,P_RandomRange(300,340)*FRACUNIT,MT_SNIGHTSPARKLE) //make the mushroom spawn beautiful sparkles
	    sparkle.color = SKINCOLOR_PURPLE //color them
	end

end)

addHook("MobjThinker", function(xeye)
	if not xeye return end

	if xeye.charge == nil
		xeye.charge = false
	end

	if xeye.chargetics == nil
		xeye.chargetics = 0
	end

	if xeye.charge == true
		xeye.chargetics = $1 + 1
	else
		xeye.chargetics = 0
	end

	if xeye.chargetics >= 80
		xeye.chargetics = 0
		xeye.charge = false
	end

	if (xeye.chargetics >= 1)
	and (xeye.chargetics < 25)
	and (xeye.overlay == nil)
	    xeye.overlay = P_SpawnMobj(xeye.x,xeye.y,xeye.z,MT_THOK) //thanks for the thok lat'
		xeye.overlay.state = S_XEYECUTSCENELOOK
	end

	if (xeye.chargetics >= 1)
	and (xeye.chargetics < 25)
	and (xeye.overlay and xeye.overlay.valid)
	    P_MoveOrigin(xeye.overlay,xeye.x,xeye.y,xeye.z)
		xeye.overlay.angle = ($1 + FixedAngle(60*FRACUNIT))
		P_SpawnGhostMobj(xeye.overlay)
		xeye.overlay.state = S_XEYECUTSCENELOOK
		xeye.flags2 = ($1|MF2_DONTDRAW)
	end

		if xeye and xeye.valid
		and xeye.target ~= nil
		and R_PointToDist2(xeye.x, xeye.y, xeye.target.x, xeye.target.y)<= 250*FRACUNIT
	    and abs(xeye.z - xeye.target.z)<= 250*FRACUNIT
		and (xeye.charge == false)
	    and not (xeye.state == S_XEYETEC)
	    and not (InAtkState(xeye.target))
			xeye.charge = true
			S_StartSound(xeye,sfx_mswarp)
	    end

		if xeye and xeye.valid
		and xeye.target ~= nil
		and not (xeye.state == S_XEYETEC)
		and (xeye.chargetics >= 25)
		and (xeye.chargetics < 55)
			local factor = FRACUNIT>>7
			local zdist = xeye.target.z-xeye.z
			zdist = FixedMul($1, factor)
			S_StartSound(xeye, sfx_buzz4)
			P_SpawnGhostMobj(xeye)
			P_Thrust(xeye, xeye.angle, 8*FRACUNIT)
			xeye.momz = $1+zdist

			if (xeye.overlay and xeye.overlay.valid)
				P_RemoveMobj(xeye.overlay)
				xeye.overlay = nil
				xeye.flags2 = ($1 &~ MF2_DONTDRAW)
			end

	    end
		    if xeye and xeye.valid
		    and xeye.target ~= nil
			and R_PointToDist2(xeye.x, xeye.y, xeye.target.x, xeye.target.y)<= 120*FRACUNIT
			and abs(xeye.z - xeye.target.z)<= 120*FRACUNIT
			and not (xeye.state == S_XEYETEC)
			and (InAtkState(xeye.target))
				S_StartSound(xeye, sfx_buzz4)
				P_SpawnGhostMobj(xeye)
				P_Thrust(xeye, xeye.angle, -3*FRACUNIT)
			end

end, MT_XEYE)

addHook("MobjThinker", function(xeye)
	if not xeye return end
	if (xeye and xeye.spawnpoint.angle == 270) return end



		if xeye and xeye.valid
			for player in players.iterate
				if player.cutscenemode == true
					if cutscenetimer == 1
						P_SetOrigin(player.mo, 17439*FRACUNIT, -3357*FRACUNIT, player.mo.z)
		                player.mo.momx = 0
						player.mo.momy = 0
						playerCam = P_SpawnMobj(16992*FRACUNIT,-3360*FRACUNIT,-1776*FRACUNIT,MT_CAMERA)
						playerCam.angle = FixedAngle(0*FRACUNIT)
						player.awayviewmobj = playerCam
						player.awayviewtics = 5
						S_ChangeMusic("treasu", true, player)
						COM_BufInsertText(player, "showhud 0")
					end

					if cutscenetimer >= 2
					and cutscenetimer < 590
						player.mo.momx = 0
						player.mo.momy = 0
						player.awayviewmobj = playerCam
						player.awayviewtics = 5
						player.mo.angle = FixedAngle(0*FRACUNIT)
					end

					if cutscenetimer >= 140
					and cutscenetimer < 590
						S_StopMusic(player)
					end

					if cutscenetimer == 20
						P_SetOrigin(playerCam, 17984*FRACUNIT, -3360*FRACUNIT, -1856*FRACUNIT)
					end

					if cutscenetimer == 40
						P_SetOrigin(playerCam, 18272*FRACUNIT, -3456*FRACUNIT, -1840*FRACUNIT)
					end

					if cutscenetimer == 60
						P_SetOrigin(playerCam, 18240*FRACUNIT, -3360*FRACUNIT, -1972*FRACUNIT)
					end

					if cutscenetimer == 80
						P_SetOrigin(playerCam, 17856*FRACUNIT, -3360*FRACUNIT, -1832*FRACUNIT)
						playerCam.angle = FixedAngle(180*FRACUNIT)
					end

					if cutscenetimer == 130
						P_SetOrigin(playerCam, 17984*FRACUNIT, -3360*FRACUNIT, -1856*FRACUNIT)
						playerCam.angle = FixedAngle(0*FRACUNIT)
						S_StartSoundAtVolume(nil, sfx_sfshy, 30, player)
					end

					if cutscenetimer == 135
						S_StartSoundAtVolume(nil, sfx_shock, 40, player)
					end

					if cutscenetimer == 140
						P_SetMobjStateNF(xeye, S_XEYECUTSCENE_SHOCK1)
						S_StopMusic(player)
					end

					if cutscenetimer == 165
						P_SetMobjStateNF(xeye, S_XEYECUTSCENE_SHOCK2)
					end

					if cutscenetimer == 180
						P_SetMobjStateNF(xeye, S_XEYECUTSCENELOOK)
						xeye.angle = FixedAngle(90*FRACUNIT)
						P_SetOrigin(playerCam, 17984*FRACUNIT, -3648*FRACUNIT, -1856*FRACUNIT)
						playerCam.angle = FixedAngle(60*FRACUNIT)
					end

					if cutscenetimer == 200
						P_StartQuake(5*FRACUNIT, 6*TICRATE)
						S_StartSoundAtVolume(nil, sfx_yell, 15, player)
					end

					if cutscenetimer == 430
						S_StartSoundAtVolume(nil, sfx_runaw, 25, player)
						xeye.angle = FixedAngle(270*FRACUNIT)
					end

					if cutscenetimer == 525
						P_SetOrigin(playerCam, 16992*FRACUNIT, -3360*FRACUNIT, -1776*FRACUNIT)
						playerCam.angle = FixedAngle(0*FRACUNIT)
					end

					if cutscenetimer == 540
						P_SpawnMobj(player.mo.x+FixedMul(-5*FRACUNIT, cos(player.mo.angle)), player.mo.y+FixedMul(-5*FRACUNIT, sin(player.mo.angle)), player.mo.z+player.mo.height-10*FRACUNIT, MT_CARTOONSWEAT)
					end

					if cutscenetimer >= 590
						player.cutscenemode = false
						COM_BufInsertText(player, "showhud 1")
						P_LinedefExecute(1007, player.mo)
						player.awayviewtics = 0
					end
				end

				if cutscenetimer >= 595
					cutscene = false
					cutscenetimer = 0
					cutscenemode = false
				end
			end

			if cutscenetimer >= 430
			and cutscenetimer < 529
				P_Thrust(xeye,xeye.angle,FRACUNIT/2)
			end
		end
end, MT_XEYECUTSCENE)


addHook("MobjThinker", function(shark)
	if not shark return end



    if shark and shark.valid
	and shark.state == S_SFSHARKSHOT2
		P_SpawnGhostMobj(shark)

			for player in players.iterate
				if R_PointToDist2(shark.x, shark.y, player.mo.x, player.mo.y)<= 250*FRACUNIT
				and abs(shark.z - player.mo.z)<= 250*FRACUNIT
					local factor = FRACUNIT>>4
					local xdist = player.mo.x-shark.x
					local ydist = player.mo.y-shark.y
					local zdist = player.mo.z-shark.z
					xdist = FixedMul($1, factor)
					ydist = FixedMul($1, factor)
					zdist = FixedMul($1, factor)
					shark.momx = $1+xdist
					shark.momy = $1+ydist
					shark.momz = $1+ydist
				end
			end
    end
end, MT_STEALFACESSHARK)

addHook("MobjThinker", function(shark)
	if not shark return end



		if shark and shark.valid
			for player in players.iterate
				if cutscenetimer == 140
				and player.cutscenemode == true
					P_SetMobjStateNF(shark, S_STEALFACESSHARKCUTSCENE_SHOCK1)
				end

				if cutscenetimer == 165
				and player.cutscenemode == true
					P_SetMobjStateNF(shark, S_STEALFACESSHARKCUTSCENE_SHOCK2)
				end

				if cutscenetimer == 180
				and player.cutscenemode == true
					P_SetMobjStateNF(shark, S_SFSHARKCUTSCENE)
					shark.angle = FixedAngle(90*FRACUNIT)
				end

				if cutscenetimer == 430
				and player.cutscenemode == true
					shark.angle = FixedAngle(270*FRACUNIT)
				end

				if cutscenetimer >= 529
				and player.cutscenemode == true
					P_SetMobjStateNF(shark, S_SFSHARKCUTSCENETWO)
				end
			end

			if cutscenetimer >= 430
			and cutscenetimer < 529
				P_Thrust(shark,shark.angle,1*FRACUNIT)
			end
		end
end, MT_STEALFACESSHARKCUTSCENE)

addHook("MapLoad", do
	for player in players.iterate
		if (mapheaderinfo[gamemap].dwz)
			cutscene = true
			cutscenemode = false
			cutscenetimer = 0
			player.cutscenemode = false
		end
	end
end)

addHook("MobjThinker", function(leaf)
	if not leaf return end



		if (leaf and leaf.valid)
			if (leaf.validness == nil)
				leaf.validness = 0
	        end

			if (leaf.validness ~= nil)
				leaf.validness = $1 + 1
			end

			if (leaf.validness == 1)
				leaf.momz = 2*FRACUNIT*(-1)
			end

			if (leaf.groundness == nil)
				leaf.groundness = 0
			end

			if (P_IsObjectOnGround(leaf))
				leaf.momz = 0
				leaf.groundness = $1 + 1
			end

			if (leaf.groundness == 100)
				P_RemoveMobj(leaf)
			end
		end
end,MT_LEAF)

addHook("PlayerSpawn", function(player)
	if player
		player.spawntimer = 0
		player.mush = false
		player.mushtics = 0
	end
end)

freeslot(
	"MT_DESOLATELIGHT",
	"S_DESOLATELIGHT1","S_DESOLATELIGHT2","S_DESOLATELIGHT3",
	"S_DESOLATELIGHT4","S_DESOLATELIGHT5","S_DESOLATELIGHT6",
	"S_DESOLATELIGHT7","S_DESOLATELIGHT8","SPR_GLIT"
)
freeslot(
	"S_DESOLATELIGHT9","S_DESOLATELIGHT10","S_DESOLATELIGHT11",
	"S_DESOLATELIGHT12","S_DESOLATELIGHT13","S_DESOLATELIGHT14",
	"S_DESOLATELIGHT15","S_DESOLATELIGHT16"
)

mobjinfo[MT_DESOLATELIGHT] = {
	//$Sprite GLITA0
	//$Name Desolate Light
	//$Category SUGOI Decoration
	doomednum = 2508,
	spawnstate = S_DESOLATELIGHT1,
	seestate = S_DESOLATELIGHT1,
	deathstate = S_DESOLATELIGHT1,
	spawnhealth = 1000,
	radius = 10*FRACUNIT,
	height = 25*FRACUNIT,
	flags = MF_SPECIAL|MF_NOGRAVITY|MF_FLOAT
}

states[S_DESOLATELIGHT1] = {SPR_GLIT, A|FF_FULLBRIGHT, 3, nil, 0, 0, S_DESOLATELIGHT2}
states[S_DESOLATELIGHT2] = {SPR_GLIT, B|FF_FULLBRIGHT, 3, nil, 0, 0, S_DESOLATELIGHT3}
states[S_DESOLATELIGHT3] = {SPR_GLIT, C|FF_FULLBRIGHT, 3, nil, 0, 0, S_DESOLATELIGHT14}
states[S_DESOLATELIGHT4] = {SPR_GLIT, D|FF_FULLBRIGHT, 3, nil, 0, 0, S_DESOLATELIGHT5}
states[S_DESOLATELIGHT5] = {SPR_GLIT, E|FF_FULLBRIGHT, 3, nil, 0, 0, S_DESOLATELIGHT6}
states[S_DESOLATELIGHT6] = {SPR_GLIT, F|FF_FULLBRIGHT, 3, nil, 0, 0, S_DESOLATELIGHT7}
states[S_DESOLATELIGHT7] = {SPR_GLIT, G|FF_FULLBRIGHT, 3, nil, 0, 0, S_DESOLATELIGHT8}
states[S_DESOLATELIGHT8] = {SPR_GLIT, H|FF_FULLBRIGHT, 3, nil, 0, 0, S_DESOLATELIGHT9}
states[S_DESOLATELIGHT9] = {SPR_GLIT, H|FF_FULLBRIGHT, 3, nil, 0, 0, S_DESOLATELIGHT10}
states[S_DESOLATELIGHT10] = {SPR_GLIT, G|FF_FULLBRIGHT, 3, nil, 0, 0, S_DESOLATELIGHT11}
states[S_DESOLATELIGHT11] = {SPR_GLIT, F|FF_FULLBRIGHT, 3, nil, 0, 0, S_DESOLATELIGHT12}
states[S_DESOLATELIGHT12] = {SPR_GLIT, E|FF_FULLBRIGHT, 3, nil, 0, 0, S_DESOLATELIGHT13}
states[S_DESOLATELIGHT13] = {SPR_GLIT, D|FF_FULLBRIGHT, 3, nil, 0, 0, S_DESOLATELIGHT14}
states[S_DESOLATELIGHT14] = {SPR_GLIT, C|FF_FULLBRIGHT, 3, nil, 0, 0, S_DESOLATELIGHT15}
states[S_DESOLATELIGHT15] = {SPR_GLIT, B|FF_FULLBRIGHT, 3, nil, 0, 0, S_DESOLATELIGHT16}
states[S_DESOLATELIGHT16] = {SPR_GLIT, A|FF_FULLBRIGHT, 3, nil, 0, 0, S_DESOLATELIGHT1}

freeslot("MT_SNIGHTSPARKLE", "S_SNIGHTSPARKLE1", "S_SNIGHTSPARKLE2", "S_SNIGHTSPARKLE3", "S_SNIGHTSPARKLE4", "SPR_SNIT")

mobjinfo[MT_SNIGHTSPARKLE] = {
	doomednum = -1,
	spawnhealth = 1000,
	spawnstate = S_SNIGHTSPARKLE1,
	seestate = S_SNIGHTSPARKLE1,
	meleestate = S_SNIGHTSPARKLE1,
	missilestate = S_SNIGHTSPARKLE1,
	painstate = S_SNIGHTSPARKLE1,
	deathstate = S_SNIGHTSPARKLE1,
	xdeathstate = S_SNIGHTSPARKLE1,
	radius = 5*FRACUNIT,
	height = 5*FRACUNIT,
	flags = MF_NOGRAVITY|MF_FLOAT
}

states[S_SNIGHTSPARKLE1] = {SPR_SNIT, A|FF_FULLBRIGHT, 3, nil, 0, 0, S_SNIGHTSPARKLE2}
states[S_SNIGHTSPARKLE2] = {SPR_SNIT, B|FF_FULLBRIGHT, 3, nil, 0, 0, S_SNIGHTSPARKLE3}
states[S_SNIGHTSPARKLE3] = {SPR_SNIT, C|FF_FULLBRIGHT, 3, nil, 0, 0, S_SNIGHTSPARKLE4}
states[S_SNIGHTSPARKLE4] = {SPR_SNIT, D|FF_FULLBRIGHT, 3, nil, 0, 0, S_NULL}

addHook("MobjThinker", function(light)
	if not light return end

		if (light and light.valid)
			if ((light.momx < 5*FRACUNIT) and (light.momx > -5*FRACUNIT) and (light.x <= 18944*FRACUNIT))
				light.momx = $1 + (P_RandomRange(-5500,5500))
	        end

			if (light.momx >= 5*FRACUNIT)
				light.momx = $1 + (P_RandomRange(-5500,0))
			elseif (light.momx <= -5*FRACUNIT)
				light.momx = $1 + (P_RandomRange(0,5500))
			end

			if ((light.momy < 5*FRACUNIT) and (light.momy > -5*FRACUNIT))
				light.momy = $1 + (P_RandomRange(-5500,5500))
			end

			if (light.momy >= 5*FRACUNIT)
				light.momy = $1 + (P_RandomRange(-5500,0))
			elseif (light.momy <= -5*FRACUNIT)
				light.momy = $1 + (P_RandomRange(0,5500))
			end

			if ((light.momz < 5*FRACUNIT) and (light.momz > -5*FRACUNIT))
				light.momz = $1 + (P_RandomRange(-5500,5500))
			end

			if (light.momz >= 5*FRACUNIT)
				light.momz = $1 + (P_RandomRange(-5500,0))
			elseif (light.momz <= -5*FRACUNIT)
				light.momz = $1 + (P_RandomRange(0,5500))
			end

			if (light.z < light.floorz)
				light.momz = 1
			end

			if (light.x > 18944*FRACUNIT)
			and (light.y < -2864*FRACUNIT)
				light.momx = (3)*(FRACUNIT)*(-1)
			end

			if (light.validness == nil)
				light.validness = 0
			end

			if (light.validness ~= nil)
				light.validness = $1 + 1
			end

			if (light.validness % 8 == 0)
				local sparkle = P_SpawnMobj(P_RandomRange(light.x/FRACUNIT-10,light.x/FRACUNIT+10)*FRACUNIT,P_RandomRange(light.y/FRACUNIT-10,light.y/FRACUNIT+10)*FRACUNIT,P_RandomRange(light.z/FRACUNIT, (light.z + light.height)/FRACUNIT)*FRACUNIT,MT_SNIGHTSPARKLE)
				sparkle.color = light.color
			end

			if (light.spawnpoint ~= nil)
				if ((light.spawnpoint.angle > 15) or (light.spawnpoint.angle < 1))
					light.color = SKINCOLOR_GREEN
				end

			//Desolate Lights' Colors list:

				if (light.spawnpoint.angle == 1)
					light.color = SKINCOLOR_GREEN //Green.
				end

				if (light.spawnpoint.angle == 2)
					light.color = SKINCOLOR_YELLOW //Yellow.
				end

				if (light.spawnpoint.angle == 3)
					light.color = SKINCOLOR_ORANGE //Orange.
				end

				if (light.spawnpoint.angle == 4)
					light.color = SKINCOLOR_RED //Red.
				end

				if (light.spawnpoint.angle == 5)
					light.color = SKINCOLOR_PINK //Pink.
				end

				if (light.spawnpoint.angle == 6)
					light.color = SKINCOLOR_PURPLE //Purple.
				end

				if (light.spawnpoint.angle == 7)
					light.color = SKINCOLOR_BLUE //Blue.
				end

				if (light.spawnpoint.angle == 8)
					light.color = SKINCOLOR_TEAL //Teal.
				end

				if (light.spawnpoint.angle == 9)
					light.color = SKINCOLOR_CYAN //Cyan.
				end

				if (light.spawnpoint.angle == 10)
					light.color = SKINCOLOR_EMERALD //Neon Green.
				end

				if (light.spawnpoint.angle == 11)
					light.color = SKINCOLOR_AZURE //Steel Blue.
				end

				if (light.spawnpoint.angle == 12)
					light.color = SKINCOLOR_LAVENDER //Lavender.
				end

				if (light.spawnpoint.angle == 13)
					light.color = SKINCOLOR_MOSS //Zim.
				end

				if (light.spawnpoint.angle == 14)
					light.color = SKINCOLOR_GOLD //Gold.
				end

				if (light.spawnpoint.angle == 15)
					light.color = SKINCOLOR_CRIMSON //Dark Red.
				end
			end
		end

end,MT_DESOLATELIGHT)