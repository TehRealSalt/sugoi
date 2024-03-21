//Cyber Deton Boss Script
// - Includes invisible switch setup too
//Note: This should be loaded after CD-HZRD.lua and before CD-PLAY.lua

/*
=================
	CONTENTS
=================

To help with "CRTL + F"'ing sections of the script

1) FREESLOT & STATE SETUP

2) CYBER DETON BEHAVIOUR

3) SWITCH BEHAVIOUR

4) MISCELLANEOUS
*/

/*
Extra Notes:
	Regarding Cyber Deton's Frames
--------------------------------------
1) A - F = IDLE
2) G = HIDE, WAIT, SUMMON
3) H - K = COUNTDOWN
4) L - O = EXPLODING
5) P = TELEPORTING, TELEPORTED, RETURNING, RETURNED
6) Q = DEATH

Reused - A = EXPOSED, L = HURT

	Regarding Cyber Deton's Voice Clips
-------------------------------------------
"sfx_cthrt1" = Summoning Allies
"sfx_cthrt2" = Self-Destruct Program Restriction Overridden
"sfx_cthrt3" = Activating Main Engine
*/


//===========================
//=======================
//FREESLOT & STATE SETUP
//=======================
//===========================


//My eyes can't stand looking at a long list of freeslotted stuff clumped together, so they're separated here

//Cyber Deton Slots
freeslot(
"MT_CYBERDETON",
"MT_CYBERDETONPOINT",
"S_CD_IDLE",
"S_CD_HIDE",
"S_CD_WAIT",
"S_CD_SUMMON",
"S_CD_COUNTDOWN",
"S_CD_EXPLODING",
"S_CD_TELEPORTING",
"S_CD_TELEPORTED",
"S_CD_EXPOSED",
"S_CD_RETURNING",
"S_CD_RETURNED",
"S_CD_HURT",
"S_CD_SUMMONDETONS",
"S_CD_DEFEAT",
"S_CD_ENDLEVEL",
"S_CD_DEATH",
"S_CD_POINT",
"S_DETON_IDLE",
"SPR_CYBD",
"sfx_cthrt1",
"sfx_cthrt2",
"sfx_cthrt3"
)

//Switch Slots
freeslot(
"MT_INVISIBLESWITCHSPAWNER",
"MT_INVISIBLESWITCH",
"MT_INVISIBLESWITCHBORDER",
"S_IS_GREENARROW",
"S_ISBORDER",
"SPR_GNAW",
"SPR_ISBR"
)

//Laser Slots
freeslot(
"MT_CDLASER",
"MT_LASERWAYPOINT",
"S_LASER_INACTIVE",
"S_LASER_ACTIVATE",
"S_LASER_ACTIVE1",
"S_LASER_ACTIVE2",
"SPR_LASE"
)

//Hint Slots
freeslot(
"MT_CDHINT",
"S_CDHINT_SPAWN",
"S_CDHINT_IDLE",
"S_CDHINT_QUESTIONMARK",
"SPR_CHNT"
)

mobjinfo[MT_CYBERDETON] = {
	//$Name Cyber Deton
	//$Sprite CYBDA0
	//$Category SUGOI Bosses
	doomednum = 2510,
	spawnstate = S_CD_IDLE,
	spawnhealth = 5,
	reactiontime = 8,
	painstate = S_CD_HURT,
	painsound = sfx_dmpain,
	deathstate = S_CD_DEFEAT,
	deathsound = sfx_cybdth,
	radius = 48*FRACUNIT,
	height = 128*FRACUNIT,
	dispoffset = 0,
	mass = 100,
	flags = MF_BOSS|MF_NOGRAVITY
}
mobjinfo[MT_CYBERDETONPOINT] = {
	//$Name Cyber Deton Point
	//$Sprite MSCFA0
	//$Category SUGOI Bosses
	doomednum = 3001,
	spawnstate = S_CD_POINT,
	spawnhealth = 1,
	radius = 24*FRACUNIT,
	height = 64*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOCLIP
}
mobjinfo[MT_INVISIBLESWITCHSPAWNER] = {
	//$Name Cyber Deton Switch
	//$Sprite GNAWA0
	//$Category SUGOI Bosses
	doomednum = 3002,
	spawnstate = S_IS_GREENARROW,
	spawnhealth = 1,
	radius = 16*FRACUNIT,
	height = 48*FRACUNIT,
	flags = MF_SCENERY
}
mobjinfo[MT_INVISIBLESWITCH] = {
	doomednum = -1,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	radius = 16*FRACUNIT,
	height = 64*FRACUNIT,
	flags = MF_SPECIAL|MF_SCENERY
}
mobjinfo[MT_INVISIBLESWITCHBORDER] = {
	doomednum = -1,
	spawnstate = S_ISBORDER,
	spawnhealth = 1,
	radius = 16*FRACUNIT,
	height = 64*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_NOTHINK
}
mobjinfo[MT_CDLASER] = {
	//$Name Cyber Deton Laser
	//$Sprite LASEB0
	//$Category SUGOI Bosses
	doomednum = 3003,
	spawnstate = S_LASER_INACTIVE,
	spawnhealth = 1,
	seestate = S_LASER_ACTIVATE,
	deathstate = S_XPLD1,
	radius = 16*FRACUNIT,
	height = 156*FRACUNIT,
	flags = MF_PAIN|MF_SOLID|MF_NOCLIPTHING
}
mobjinfo[MT_LASERWAYPOINT] = {
	//$Name Cyber Deton Laser Waypoint
	//$Sprite LASEA0
	//$Category SUGOI Bosses
	doomednum = 3004,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	radius = 8*FRACUNIT,
	height = 32*FRACUNIT,
	flags = MF_SCENERY|MF_SOLID
}
mobjinfo[MT_CDHINT] = {
	//$Name Cyber Deton Hint
	//$Sprite EMBMA0
	//$Category SUGOI Bosses
	doomednum = 3005,
	spawnstate = S_CDHINT_SPAWN,
	spawnhealth = 1,
	radius = 16*FRACUNIT,
	height = 48*FRACUNIT,
	flags = MF_SCENERY|MF_SPECIAL|MF_NOGRAVITY|MF_RUNSPAWNFUNC
}


//Cyber Deton Teleporting Setup
function A_CyberDetonTeleport(actor, var1)
	if actor.dest and actor.dest.valid
		local x, y, z
		if var1 > 0
			x, y, z = actor.dest.x, actor.dest.y, actor.dest.z
		else
			x, y, z = actor.startx, actor.starty, actor.startz
		end
		P_SetOrigin(actor, x, y, z)
		S_StartSound(actor, sfx_telept)
	end
end

//Deton Summoning Action
function A_SummonDeton()
	for player in players.iterate
		local mo = player.mo
		if not (mo and mo.valid) continue end
		if player.playerstate & PST_DEAD continue end
		local deton = P_SpawnMobj(mo.x + mo.momx, mo.y + mo.momy, mo.z + mo.momz + 96*FRACUNIT, MT_DETON)
		deton.state = S_DETON_IDLE
		deton.target = mo
		deton.InCyberDetonMap = true
	end
end

//Cyber Deton Death Setup
function A_CyberDetonDeath(actor)
	for mobj in mobjs.iterate()
		if not (mobj.flags & (MF_PAIN|MF_ENEMY)) continue end
		P_KillMobj(mobj, actor, actor)
	end
	for player in players.iterate
		P_DoPlayerExit(player)
	end
	S_StartSound(actor, sfx_kc65)
end

//Cyber Deton States
states[S_CD_IDLE] = {SPR_CYBD, FF_ANIMATE|A, 55, nil, 5, 3, S_CD_HIDE}
states[S_CD_HIDE] = {SPR_CYBD, G, 5, A_LinedefExecute, 100, 0, S_CD_WAIT}
states[S_CD_WAIT] = {SPR_CYBD, G, 2*TICRATE, nil, 0, 0, S_CD_SUMMON}
states[S_CD_SUMMON] = {SPR_CYBD, G, 1, A_LinedefExecute, 101, 0, S_CD_COUNTDOWN}
states[S_CD_COUNTDOWN] = {SPR_CYBD, FF_ANIMATE|H, 20*TICRATE, nil, 3, 3, S_CD_EXPLODING}

states[S_CD_EXPLODING] = {SPR_CYBD, FF_ANIMATE|L, 64, nil, 3, 3, S_CD_IDLE} -- extra 1 tic added to avoid conflict with nuke setup

states[S_CD_TELEPORTING] = {SPR_CYBD, TR_TRANS20|P, 20, nil, 0, 0, S_CD_TELEPORTED}
states[S_CD_TELEPORTED] = {SPR_CYBD, TR_TRANS20|P, 20, A_CyberDetonTeleport, 1, 0, S_CD_EXPOSED}

states[S_CD_EXPOSED] = {SPR_CYBD, FF_ANIMATE|A, 4*TICRATE, nil, 5, 5, S_CD_RETURNING}

states[S_CD_RETURNING] = {SPR_CYBD, TR_TRANS20|P, 12, nil, 0, 0, S_CD_RETURNED}
states[S_CD_RETURNED] = {SPR_CYBD, TR_TRANS20|P, 12, A_CyberDetonTeleport, 0, 0, S_CD_IDLE}

states[S_CD_HURT] = {SPR_CYBD, L, 25, nil, 0, 0, S_CD_SUMMONDETONS}
states[S_CD_SUMMONDETONS] = {SPR_CYBD, FF_ANIMATE|H, 46, A_SummonDeton, 3, 3, S_CD_RETURNING}

//Just gonna drop the new deton state here...
states[S_DETON_IDLE] = {SPR_DETN, TR_TRANS30|A, 50, nil, 0, 0, S_DETON2}

states[S_CD_DEFEAT] = {SPR_CYBD, L, 80, nil, 0, 0, S_CD_ENDLEVEL}
states[S_CD_ENDLEVEL] = {SPR_CYBD, Q, 1, A_CyberDetonDeath, 0, 0, S_CD_DEATH}
states[S_CD_DEATH] = {SPR_CYBD, Q, -1, nil, 0, 0, S_NULL}

//Cyber Deton Point State
states[S_CD_POINT] = {SPR_MSCF, FF_ANIMATE|A, -1, nil, 11, 2, S_NULL}

//Invisible Switch State (Arrow & Border only)
states[S_IS_GREENARROW] = {SPR_GNAW, TR_TRANS30|A, -1, nil, 0, 0, S_NULL}
states[S_ISBORDER] = {SPR_ISBR, FF_PAPERSPRITE|A, -1, nil, 5, 3, S_NULL}

//Hint Setup - for grabbing Cyber Deton's mobj userdata
function A_HintSetup(actor)
	for mobj in mobjs.iterate()
		if mobj.type != MT_CYBERDETON continue end
		actor.cd = mobj
	end
	actor.scale = 5*FRACUNIT/2
	actor.Qs = {}
	for i = 1, 2
		local xp = actor.x + FixedMul(cos(ANGLE_180*i), 64*FRACUNIT)
		local yp = actor.y + FixedMul(sin(ANGLE_180*i), 64*FRACUNIT)
		local Q = P_SpawnMobj(xp, yp, actor.x, MT_GFZFLOWER1)
		Q.flags = $|MF_NOCLIPHEIGHT
		Q.state = S_CDHINT_QUESTIONMARK
		Q.ang = ANGLE_180*i
		table.insert(actor.Qs, Q)
	end
end

//Hint States
states[S_CDHINT_SPAWN] = {SPR_EMBM, TR_TRANS20|A, 1, A_HintSetup, 0, 0, S_CDHINT_IDLE}
states[S_CDHINT_IDLE] = {SPR_EMBM, TR_TRANS20|A, -1, nil, 5, 3, S_NULL}
states[S_CDHINT_QUESTIONMARK] = {SPR_CHNT, TR_TRANS20|FF_PAPERSPRITE|A, -1, nil, 0, 0, S_NULL}

//Sound Volume Distance Setup
sfxinfo[sfx_cthrt1] = {flags = SF_X2AWAYSOUND|SF_X4AWAYSOUND|SF_X8AWAYSOUND}
sfxinfo[sfx_cthrt2] = {flags = SF_X2AWAYSOUND|SF_X4AWAYSOUND|SF_X8AWAYSOUND}
sfxinfo[sfx_cthrt3] = {flags = SF_X2AWAYSOUND|SF_X4AWAYSOUND|SF_X8AWAYSOUND}


function A_LaserSetup(actor)
	actor.waypoints, actor.point = {}, 0
	actor.flags = $&~MF_NOCLIPTHING
	for mobj in mobjs.iterate()
		if mobj.type != MT_LASERWAYPOINT continue end
		if mobj.spawnpoint.extrainfo != actor.spawnpoint.extrainfo continue end
		table.insert(actor.waypoints, mobj)

		mobj.point = AngleFixed(mobj.angle)/FRACUNIT
		if mobj.point != actor.point + 1 continue end
		actor.target = mobj -- starting target
	end
	table.sort(actor.waypoints, function(a, b)
		if a.angle < b.angle return true end
	end)
end

function A_LaserMove(actor)
	if actor.point != actor.target.point

		local first, last
		if not (actor.reverse)
			first, last, actor.increment = 1, #actor.waypoints, 1
		else
			first, last, actor.increment = #actor.waypoints, 1, -1
		end
		for i = first, last, actor.increment
			if actor.waypoints[i].point != actor.point continue end
			actor.target = actor.waypoints[i]
		end
	end
	local dest = actor.target
	if dest then P_InstaThrust(actor, R_PointToAngle2(actor.x, actor.y, dest.x, dest.y), 16*FRACUNIT) end
end

//Laser States
states[S_LASER_INACTIVE] = {SPR_LASE, A, -1, nil, 0, 0, S_NULL}
states[S_LASER_ACTIVATE] = {SPR_LASE, TR_TRANS40|B, 15, A_LaserSetup, 0, 0, S_LASER_ACTIVE1}
states[S_LASER_ACTIVE1] = {SPR_LASE, A, 1, A_LaserMove, 0, 0, S_LASER_ACTIVE2}
states[S_LASER_ACTIVE2] = {SPR_LASE, B, 2, A_LaserMove, 0, 0, S_LASER_ACTIVE1}


//=============================
//======================
//CYBER DETON BEHAVIOUR
//======================
//=============================


local function XYPositioning(mobj, angle, distance)
	local x, y
	x = mobj.x + FixedMul(cos(angle), distance)
	y = mobj.y + FixedMul(sin(angle), distance)
	return x, y
end

//Store Switches - for reference
local switches = {}

//Cyber Deton Spawn Setup
addHook("MobjSpawn", function(cd)
	cd.startx, cd.starty, cd.startz = cd.x, cd.y, cd.z
	cd.timer = 0
	switches = {}
	sugoi.SetBoss(cd, "Cyber Deton")
end, MT_CYBERDETON)

//Scale destination point
addHook("MapThingSpawn", function(cdp)
	cdp.scale = 2*FRACUNIT
end, MT_CYBERDETONPOINT)

//Cyber Deton Thinker
addHook("BossThinker", function(cd)
	//Spawn Setup Alternative
	if not (cd.spawned)
		for mobj in mobjs.iterate()
			if mobj.type != MT_INVISIBLESWITCH continue end
			table.insert(switches, mobj)
		end

		for mobj in mobjs.iterate()
			if mobj.type != MT_CYBERDETONPOINT continue end
			cd.dest = mobj
		end
		cd.spawned = true
	end

	//Sounds - Mostly Cyber Deton's threats
	//"Allies"
	if cd.state == S_CD_HIDE or cd.state == S_CD_SUMMONDETONS
		if not (cd.threat1)
			S_StartSound(cd, sfx_cthrt1)
			cd.threat1 = true
		end
	else
		cd.threat1 = false
	end
	//"Override"
	if cd.state == S_CD_COUNTDOWN
		if not (cd.threat2)
			S_StartSound(cd, sfx_cthrt2)
			cd.threat2 = true
		end
	else
		cd.threat2 = false
	end
	//"Activating Main Engine" - I wonder if people will clock what game I'm referencing here...
	if cd.state == S_CD_EXPLODING
		if not (cd.threat3)
			S_StartSound(cd, sfx_cthrt3)
			cd.threat3 = true
		end
	else
		cd.threat3 = false
	end
	//Pain
	if cd.state == S_CD_HURT
		if not (cd.pain)
			S_StartSound(cd, cd.info.painsound)
			cd.pain = true
		end
	else
		cd.pain = false
	end

	//Reset States
	//--------------
	if cd.state != S_CD_EXPLODING then cd.timer = 9 end -- Timer Reset

	//Make invulnerable when not exposed
	if cd.state != S_CD_EXPOSED
		if cd.flags & (MF_SPECIAL|MF_SHOOTABLE) then cd.flags = $&~(MF_SPECIAL|MF_SHOOTABLE) end
	end

	if cd.state != S_CD_HURT
		if cd.flags2 & MF2_FRET then cd.flags2 = $&~MF2_FRET end
	end


	//Misc.
	//---------

	//Activate lasers when low on health
	if cd.health < 4 and not (cd.lasers)
		for mobj in mobjs.iterate()
			if mobj.type != MT_CDLASER continue end
			mobj.state = S_LASER_ACTIVATE
		end
		cd.lasers = true
	end

	//Switches Stuff - reset "v.on" depending on boss' state
	if #switches != 0
		for k, v in ipairs(switches)
			if v.valid
				if cd.state == S_CD_COUNTDOWN
					if #saucerlist > 0 then v.on = false else v.on = true end
				else
					v.on = false
					v.hit = false
				end

				if not (v.hit) continue end
				if cd.state != S_CD_TELEPORTING
					cd.state = S_CD_TELEPORTING
					v.hit = false
				end
			end
		end
	end

	//State stuff
	//------------

	//Summoning
	if cd.state == S_CD_SUMMON
		for i = 1, 7 - cd.health
			local xp, yp = XYPositioning(cd, ANG30*i, 512*FRACUNIT)
			local saucerspawner = P_SpawnMobj(xp, yp, cd.z - 64*FRACUNIT, MT_SAUCERSPAWNER)
			saucerspawner.scale = 2*FRACUNIT
		end

	//Exploding
	elseif cd.state == S_CD_EXPLODING
		if cd.timer > 0
			if leveltime % 7 == 0 then cd.timer = $-1 end
		end

		for player in players.iterate
			if not (player.mo and player.mo.valid) continue end
			if cd.timer == 0 then S_StartSound(player.mo, sfx_bkpoof, player) end
			player.nuketrans = cd.timer
			if cd.timer == 0 and not (player.sheltered)
				P_DamageMobj(player.mo, cd, cd, 1, DMG_INSTAKILL)

				//In case players disable "showhud"
				local cvar = CV_FindVar("showhud")
				if cvar.string != cvar.defaultvalue then P_FlashPal(player, PAL_NUKE, 1) end
			end
		end
		for mobj in mobjs.iterate()
			if not (mobj.flags & MF_ENEMY) continue end
			if cd.timer == 0 then P_KillMobj(mobj, cd, cd) end
		end

	//Exposure
	elseif cd.state == S_CD_EXPOSED
		if not (cd.flags & (MF_SPECIAL|MF_SHOOTABLE)) then cd.flags = $|(MF_SPECIAL|MF_SHOOTABLE) end

	elseif cd.state == S_CD_HURT
		if not (cd.flags2 & MF2_FRET) then cd.flags2 = $|MF2_FRET end
	end

	//Teleporting
	if cd.state == S_CD_TELEPORTING or cd.state == S_CD_TELEPORTED or cd.state == S_CD_RETURNING or cd.state == S_CD_RETURNED
		if leveltime % 2 == 0 then cd.flags2 = $^^MF2_DONTDRAW end
	else
		if cd.flags2 & MF2_DONTDRAW then cd.flags2 = $&~MF2_DONTDRAW end
	end

	//Defeat
	if cd.state == S_CD_DEFEAT
		if leveltime % 8 == 0
			A_BossScream(cd)
			S_StartSound(cd, cd.info.deathsound)
		end
	end
	return true
end, MT_CYBERDETON)


//========================
//=================
//SWITCH BEHAVIOUR
//=================
//========================


//Switch Spawner Setup (+ Hiding Green Arrow Sprite)
addHook("MobjSpawn", function(iss)
	iss.flags2 = $|MF2_DONTDRAW

	iss.slines = {}
	//Spawn border sprites
	for i = 1, 32
		local xp, yp = XYPositioning(iss, iss.angle, 128*FRACUNIT)
		local line = P_SpawnMobj(xp, yp, iss.z, MT_INVISIBLESWITCHBORDER)
		line.color = SKINCOLOR_GREY
		line.angle = R_PointToAngle2(line.x, line.y, iss.x, iss.y) - ANGLE_90
		iss.angle = $+ANGLE_45/4
		table.insert(iss.slines, line)
	end

	//Spawn Invisible Switches
	for i =  1, 33
		if i < 33
			local xp, yp = XYPositioning(iss, iss.angle, 128*FRACUNIT)
			P_SpawnMobj(xp, yp, iss.z, MT_INVISIBLESWITCH)
			iss.angle = $+ANGLE_45/4
		else
			iss.switch = P_SpawnMobj(iss.x, iss.y, iss.z, MT_INVISIBLESWITCH)
			iss.switch.spawner = iss
			iss.switch.big = true
			iss.switch.radius = 96*FRACUNIT
		end
	end
	return true
end, MT_INVISIBLESWITCHSPAWNER)

//Switch Spawner Thinker - for green arrow flashing
addHook("MobjThinker", function(iss)
	if iss.switch.on
		if leveltime % 3 == 0 then iss.flags2 = $^^MF2_DONTDRAW end
	else
		iss.flags2 = $|MF2_DONTDRAW
	end
end, MT_INVISIBLESWITCHSPAWNER)

//Switch Thinker - for manipulating border's colour
addHook("MobjThinker", function(switch)
	local iss = switch.spawner
	if not (switch.big) return end
	for k, line in ipairs(iss.slines)
		if line.valid
			if switch.on then line.color = SKINCOLOR_BLUE else line.color = SKINCOLOR_RED end
		end
	end
end, MT_INVISIBLESWITCH)

//Switch interaction
addHook("TouchSpecial", function(switch, mo)
	if mo and mo.valid and switch and switch.valid
		if switch.on then switch.on, switch.hit = false, true end
	end
	return true
end, MT_INVISIBLESWITCH)



//========================
//==============
//MISCELLANEOUS
//==============
//========================




//Laser Thinker - for sound manipulation
addHook("MobjThinker", function(laser)
	if laser.state != S_LASER_INACTIVE
		if leveltime % 2*TICRATE == 0 then S_StartSoundAtVolume(laser, sfx_laser, 180) end
	end
end, MT_CDLASER)

//Laser Collision Handling - only with waypoints in this function
addHook("MobjCollide", function(waypoint, laser)
	if laser.type != MT_CDLASER return false end
	if waypoint.point != laser.point return false end

	if waypoint.spawnpoint.options & MTF_OBJECTSPECIAL
		laser.reverse = false
		laser.point = waypoint.point + 1
	elseif waypoint.spawnpoint.options & MTF_AMBUSH
		laser.reverse = true
		laser.point = waypoint.point - 1
	else
		if laser.increment != nil then laser.point = $+laser.increment end
	end
end, MT_LASERWAYPOINT)

//Deton Thinker Stuff
addHook("MobjThinker", function(det)
	if det.InCyberDetonMap -- As to not overwrite the behaviour of detons used in another member's maps
		if det.target and det.target.valid
			if det.state == S_DETON_IDLE
				if leveltime % 2 == 0 then det.flags2 = $^^MF2_DONTDRAW end
				P_MoveOrigin(det, det.target.x + det.target.momx, det.target.y + det.target.momy, det.target.z + det.target.momz + 96*FRACUNIT)
			else
				if det.flags2 & MF2_DONTDRAW then det.flags2 = $&~MF2_DONTDRAW end
			end
		else
			det.die = true
		end
		if det.die then P_KillMobj(det, det, det) end
	end
end, MT_DETON)

addHook("MobjThinker", function(hint)
	hint.color = (leveltime%2) and SKINCOLOR_FLAME or SKINCOLOR_AZURE
	for k,v in ipairs(hint.Qs)
		if v.valid
			v.momx = hint.x - v.x + FixedMul(cos(v.ang), 64*FRACUNIT)
			v.momy = hint.y - v.y + FixedMul(sin(v.ang), 64*FRACUNIT)
			v.momz = hint.z - v.z
			v.ang, v.angle = $+ANG2, $+ANG10
		end
	end
end, MT_CDHINT)

//Switch interaction
addHook("TouchSpecial", function(hint, mo)
	if mo and mo.valid and hint and hint.valid
		local cd = hint.cd
		if cd and cd.valid
			local text = "..."
			if cd.health < 1
				text = "HINT: You did it?! Nice Work!"
			else
				if cd.state == S_CD_COUNTDOWN
					if #saucerlist == 0
						text = "HINT: Quick head to the control panel!"
					else
						text = "HINT: If you sense danger then SEEK \n shelter behind the boxes!"
					end
				elseif cd.state >= S_CD_IDLE and cd.state <= S_CD_SUMMON
					text = "HINT: Defeat its allies to activate the \n control panels!"
				elseif cd.state == S_CD_EXPLODING
					text = "HINT: ... ..... ..."
				elseif cd.state >= S_CD_TELEPORTING and cd.state <= S_CD_EXPOSED
					text = "HINT: It's exposed, take caution \n after you strike!"
				else
					text = "HINT: Be careful not to get bombed from \n above as you fight its allies."
				end
			end
			mo.player.cd_hint = text
			mo.player.cd_timer = 3*TICRATE
		end
	end
	return true
end, MT_CDHINT)
