/*
Acidic Alpines Zone (v2.2 SUGOI trilogy port)
	by Lach

v1
*/

local function valid(mo)
	return mo and mo.valid
end

local CAPPEDPALETTES = MODID ~= 18 or SUBVERSION < 9 // version of SRB2 older than 2.2.9
local FRACRATE = FRACUNIT/TICRATE
local NUMPALETTES = 20
local PALETTETICS = 3
local SOFTWARETIME = NUMPALETTES*PALETTETICS
local OGLTIME = (FIRSTSUPERCOLOR - SKINCOLOR_RUBY - 1)
local TRIPTIME = 8*TICRATE

local foamcolor = 0
local sounds
local cams = {}
local trippers
local renderer = CV_FindVar("renderer")
local moinfo = mobjinfo // preventing ZB parser stupidity

// Darken flower stems

local function CaveFlower(mo, mt)
	if mt.options & MTF_AMBUSH
		mo.color = SKINCOLOR_FOREST
	end
end

addHook("MapThingSpawn", CaveFlower, MT_AALPFLOWER)
addHook("MapThingSpawn", CaveFlower, MT_AALPROSE)

// General level functions

local function DontUsePalettes()
	return (renderer and renderer.value ~= 1) or splitscreen or CAPPEDPALETTES
end

local function TripPlayer(player)
	local rights = 0
	for i, tripper in ipairs(trippers)
		if tripper.player == player
			tripper.tics = TRIPTIME
			return
		end
	end
	table.insert(trippers,
		{
			player = player,
			tics = TRIPTIME,
			display = 0,
			time = 0,
			swerve = 0,
			angle = 0,
			aiming = 0,
			musicfactor = FRACUNIT,
			trans = rights,
			effectdir = 1
		}
	)
end

local function UntripPlayer(player)
	S_SpeedMusic(FRACUNIT, player)
	player.viewrollangle = 0
end

addHook("MapChange", function(mapnum)
	trippers = nil
	if mapnum ~= gamemap // don't change the color if you died
		foamcolor = 0
	end
	if sounds
		for _, info in ipairs(sounds)
			sfxinfo[info.id].flags = info.flags
		end
		sounds = nil
	end
end)

addHook("LinedefExecute", do
	local soundslist = {
		moinfo[MT_AALPEGGROBO].seesound,
		moinfo[MT_AALPBOSS].activesound,
		moinfo[MT_AALPCANNON].activesound
	}

	if not foamcolor
		foamcolor = P_RandomRange(1, FIRSTSUPERCOLOR - 1)
	end
	trippers = {}
	S_SpeedMusic(FRACUNIT)

	sounds = {}
	for _, sound in ipairs(soundslist)
		table.insert(sounds, {id = sound, flags = sfxinfo[sound].flags})
		sfxinfo[sound].flags = $ | SF_X4AWAYSOUND
	end

	if not (gametyperules & GTR_FRIENDLY) // spawning a boss outside of co-op would be silly
		return
	end

	P_LinedefExecute(999) // lowers the exit fof and raises the boss trigger
end, "AALPLOAD")

addHook("ThinkFrame", do
	if not trippers return end

	local useoverlay = DontUsePalettes()

	for i = #trippers, 1, -1
		local tripper = trippers[i]
		local player = tripper.player
		local mo

		if not player.valid
			table.remove(trippers, i)
			continue
		end

		mo = player.mo

		tripper.tics = max($ - 1, 0)
		tripper.effectdir = tripper.tics <= TICRATE and -1 or 1

		if not tripper.tics
		and not tripper.display
		or not mo
		or player.playerstate ~= PST_LIVE
			UntripPlayer(player)
			table.remove(trippers, i)
			continue
		end

		tripper.time = $ + 1

		// translucency of screen overlay (OGL/splitscreen)
		tripper.trans = min(max($ + tripper.effectdir, 0), 40)

		// camera wobble
		local ang = tripper.time*(ANG10/2)
		local radius = FixedMul(tripper.swerve, 15*FRACUNIT)
		tripper.swerve = min(max($ + tripper.effectdir * FRACRATE, 0), FRACUNIT)
		tripper.angle = FixedAngle(P_ReturnThrustX(mo, ang, radius))
		tripper.aiming = FixedAngle(P_ReturnThrustY(mo, ang, radius))
		player.viewrollangle = tripper.angle

		// slow down music
		tripper.musicfactor = min(max($ - tripper.effectdir * FRACRATE/3, 2*FRACUNIT/3), FRACUNIT)
		S_SpeedMusic(tripper.musicfactor, player)

		// display ticker, chooses a color for the screen overlay in OGL or changes the palette in Software
		if useoverlay
			tripper.display = ($ + 1) % OGLTIME
		else
			local n
			tripper.display = ($ + 1) % SOFTWARETIME
			n = tripper.display / PALETTETICS
			if n
				P_FlashPal(player, n + 5, 1)
			end
		end

		// modify the camera with awayview
		if tripper.tics
			local cam = cams[
				player == displayplayer and 1
				or player == secondarydisplayplayer and 2
				or 0
			]

			local justspawned = false
			if not (player.awayviewmobj and player.awayviewmobj.valid)
				player.awayviewmobj = P_SpawnMobj(0, 0, 0, MT_THOK)
				justspawned = true
			end

			local thok = player.awayviewmobj
			local destX, destY, destZ
			thok.tics = tripper.tics + 2
			thok.flags2 = $ | MF2_DONTDRAW
			thok.scale = mo.scale

			player.awayviewaiming = tripper.aiming
			player.awayviewtics = 2

			if cam
				thok.angle = cam.angle + tripper.angle
				destX = cam.x
				destY = cam.y
				destZ = cam.z - 20*FRACUNIT + (cam.height >> 1) // ????? FUCK awayview, what the fuck
				if cam.chase
					player.awayviewaiming = $1 + cam.aiming
				end
			else // approximate the position to minimize potential for desynchs
				local angle = (player.cmd.angleturn << 16)
				thok.angle = angle + tripper.angle
				destX = mo.x + P_ReturnThrustX(mo, angle, -160*mo.scale)
				destY = mo.y + P_ReturnThrustY(mo, angle, -160*mo.scale)
				if mo.eflags & MFE_VERTICALFLIP
					destZ = mo.z + mo.height - P_GetPlayerHeight(player) - 25*mo.scale
				else
					destZ = mo.z + P_GetPlayerHeight(player) + 25*mo.scale
				end
			end

			if (justspawned)
				P_SetOrigin(thok, destX, destY, destZ)
			else
				P_MoveOrigin(thok, destX, destY, destZ)
			end
		end
	end
end)

hud.add(function(v, player, cam)
	if not trippers return end

	local splitplayer = player == secondarydisplayplayer

	cams[splitplayer and 2 or 1] = cam

	if DontUsePalettes()
		local st_tripper
		for i, tripper in ipairs(trippers)
			if tripper.player == player
				st_tripper = tripper
				break
			end
		end

		if st_tripper
			local height = v.height()*FRACUNIT >> (splitscreen and 1 or 0)
			v.drawStretched(0, splitplayer and height or 0, v.width()*FRACUNIT, height,
				v.cachePatch("AALPTRIP"), V_NOSCALEPATCH|(V_90TRANS - st_tripper.trans/10*V_10TRANS),
				v.getColormap(TC_RAINBOW, SKINCOLOR_RUBY + st_tripper.display))
		end
	end
end)

// Capsule

addHook("MobjSpawn", function(mo)
	mo.tics = P_RandomRange(1, $)
	mo.movedir = P_RandomFixed()*P_RandomFixed()
	mo.shadowscale = FRACUNIT
end, MT_AALPCAPSULE)

addHook("MobjThinker", function(mo)
	if not mo.valid
	or mo.silv_grabbed // don't do anything if Silver is using you as a projectile
	or mo.silv_target
	or mo.health <= 0 // or if dead
		return
	end

	// standard movement
	if mo.flags & MF_NOGRAVITY
		local momangle = R_PointToAngle2(0, 0, mo.momx, mo.momy)
		P_InstaThrust(mo, momangle, FixedMul(mo.info.speed, mo.scale))

		mo.movedir = $ + mo.info.painchance
		P_SetObjectMomZ(mo, sin(mo.movedir))
		return
	end

	// while tossed, end fuse early if near ground
	if mo.eflags & MFE_VERTICALFLIP
		if mo.z + mo.height > mo.ceilingz - mo.height
			mo.fuse = 1
		end
	else
		if mo.z < mo.floorz + mo.height
			mo.fuse = 1
		end
	end
end, MT_AALPCAPSULE)

addHook("MobjFuse", function(mo)
	if not mo.valid
		return
	end

	mo.flags = $ | MF_NOGRAVITY
	return true
end, MT_AALPCAPSULE)

addHook("MobjDamage", function(mo, capsule)
	local player = mo.valid and mo.player

	if not valid(capsule)
	or capsule.type ~= MT_AALPCAPSULE
	or not player
		return
	end

	if not player.powers[pw_shield]
		TripPlayer(player)
	end

	P_DamageMobj(capsule, mo, mo)
end, MT_PLAYER)

addHook("MobjDeath", function(mo)
	if not mo.valid then return end

	mo.momz = 0
	mo.momx = 0
	mo.momy = 0
	S_StartSound(mo, mo.info.deathsound)

	for i = 1, 6
		local dust = P_SpawnMobjFromMobj(mo, 0, 0, 8*FRACUNIT, MT_SPINDUST)
		P_InstaThrust(dust, P_RandomKey(360)*ANG1, 8*dust.scale)
		P_SetObjectMomZ(dust, 2*P_RandomFixed())
		dust.state = S_AALPDUST1
		dust.scale = $ >> 1
		dust.destscale = mo.scale
		dust.color = SKINCOLOR_PURPLE
		dust.colorized = true
	end
end, MT_AALPCAPSULE)

// Eggrobo cannon

addHook("MobjThinker", function(mo)
	local target = mo.valid and mo.target

	if not valid(target)
		P_RemoveMobj(mo)
		return
	end

	mo.scale = target.scale

	local radius = target.radius + mo.radius
	local particle

	mo.z = target.z + FixedMul(mo.info.painchance, mo.scale)
	P_TryMove(mo,
		target.x + P_ReturnThrustX(target, target.angle, -radius),
		target.y + P_ReturnThrustY(target, target.angle, -radius),
		true)

	// jet effect
	radius = FixedDiv(mo.radius, mo.scale)
	particle = P_SpawnMobjFromMobj(mo,
		FixedMul(P_RandomFixed(), radius << 1) - radius,
		FixedMul(P_RandomFixed(), radius << 1) - radius,
		0, MT_PARTICLE)
	particle.state = S_JETFUME1
	particle.scale = $ >> 1
	particle.scalespeed = $ >> 1
	particle.destscale = 0
	particle.fuse = 12
	particle.momz = -P_MobjFlip(particle)*FixedMul(mo.info.speed, mo.scale)
end, MT_AALPCANNON)

// Eggrobo (boss)

local STATE_IDLE = 0
local STATE_FIRING = 1
local STATE_AIMING = 2
local STATE_DASHING = 3
local STATE_COOLDOWN = 4
local STATE_STUNNED = 5

local FIRABLES = {
	MT_AALPCAPSULE,
	MT_FBOMB
}
local NUMFIRABLES = #FIRABLES

local function BossInPain(robo)
	return robo.state == robo.info.painstate
	or robo.state == robo.info.deathstate
end

local function Wham(robo, mo) // edit of MT_EGGROBO1's TouchSpecial case
	if not robo.valid
	or not mo.valid
		return
	end

	local player = mo.player
	local egginfo = moinfo[MT_EGGROBO1]

	if robo.threshold == STATE_STUNNED
	or BossInPain(robo)
		return false
	end

	if P_PlayerInPain(player)
		return true
	end

	robo.angle = R_PointToAngle2(robo.x, robo.y, mo.x, mo.y)
	robo.state = robo.info.meleestate
	robo.momx = 0
	robo.momy = 0

	mo.state = S_PLAY_STUN
	player.pflags = $ & ~PF_AUTOBRAKE
	P_ResetPlayer(player)
	player.drawangle = robo.angle + ANGLE_180
	P_InstaThrust(mo, robo.angle, FixedMul(3*egginfo.speed, robo.scale/2))
	mo.z = $ + P_MobjFlip(mo)
	if mo.eflags & MFE_UNDERWATER
		P_SetObjectMomZ(mo, FixedDiv(10511*FRACUNIT, 2600*FRACUNIT))
	else
		P_SetObjectMomZ(mo, FixedDiv(69*FRACUNIT, 10*FRACUNIT))
	end

	if (player == displayplayer or player == secondarydisplayplayer)
		P_StartQuake(9*FRACUNIT, TICRATE/2)
	end

	S_StartSound(mo, robo.info.attacksound)
	return true // whammed
end

local function EggroboSpawn(mo)
	mo.color = foamcolor
	mo.tracer = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_AALPCANNON)
	mo.tracer.target = mo
	S_StartSound(mo, mo.info.seesound)
end

local function EggroboBob(mo)
	mo.movedir = $ + ANG10
	mo.momz = FixedMul(sin(mo.movedir), mo.scale << 2)
end

local function InArena(robo, mo)
	for fof1 in robo.subsector.sector.ffloors()
		for fof2 in mo.subsector.sector.ffloors()
			if fof1.master == fof2.master
			and P_InsideANonSolidFFloor(mo, fof2)
				return true
			end
		end
	end
	return false
end

local function StartSoundInArena(robo, sound)
	S_StartSound(robo, sound)
	for player in players.iterate
		local mo = player.realmo
		if mo and InArena(robo, mo)
			S_StartSound(nil, sound, player)
		end
	end
end

local function SetBossState(mo, state)
	if state == STATE_IDLE
		S_StopSoundByID(mo, sfx_grind)
		mo.threshold = state
		return
	end

	local statenum = mo.state

	if state == STATE_FIRING
		statenum = mo.info.spawnstate
		mo.reactiontime = mo.info.reactiontime
		mo.momx = 0
		mo.momy = 0
		S_StopSoundByID(mo, sfx_grind)

	elseif state == STATE_AIMING
		statenum = mo.info.seestate
		mo.target = nil // find a fresh target
		mo.reactiontime = 3*TICRATE
		StartSoundInArena(mo, sfx_s3k9d)

	elseif state == STATE_DASHING
		statenum = mo.info.seestate
		mo.reactiontime = 3*TICRATE/2
		StartSoundInArena(mo, sfx_shrpgo)
		P_InstaThrust(mo, mo.angle, 60*mo.scale) // nyoom!

	elseif state == STATE_COOLDOWN
		statenum = mo.info.spawnstate
		S_StopSoundByID(mo, sfx_grind)

	elseif state == STATE_STUNNED
		statenum = mo.info.spawnstate
		if mo.threshold ~= STATE_STUNNED
			StartSoundInArena(mo, sfx_buzz2)
			for i = 0, 2
				local bird = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_AALPCUCKOO)
				bird.target = mo
				bird.angle = mo.angle + i*ANG60*2
			end
		end
		mo.momx = 0
		mo.momy = 0
		mo.momz = 0
		mo.reactiontime = 3*TICRATE
		S_StopSoundByID(mo, sfx_grind)
	end

	if statenum ~= mo.state
		mo.state = statenum
	end
	mo.threshold = state
end

local function SecureBossTarget(robo)
	local target = robo.target

	if valid(target)
	and target.health > 0
	and InArena(robo, target)
		return true
	end

	local targets = {}

	for player in players.iterate
		local mo = player.mo
		if not player.bot
		and mo and mo.health > 0
		and InArena(robo, mo)
			table.insert(targets, mo)
		end
	end

	if #targets == 0
		return false
	end

	robo.target = targets[P_RandomKey(#targets) + 1]
	return true
end

local function RandomAngle()
	return FixedAngle(P_RandomKey(360)*FRACUNIT)
end

local function VibrateBoss(mo)
	mo.momz = (16*mo.scale + mo.floorz - mo.z) / 8
	if leveltime & 1
		mo.z = $ + 5*mo.scale
	else
		mo.z = $ - 5*mo.scale
	end

	// spawn sparks
	if leveltime & 1
		local spark = P_SpawnMobj(mo.x, mo.y, mo.floorz, MT_MINECARTSPARK)
		local angle = RandomAngle()

		spark.flags2 = $ | MF2_DONTDRAW // I think the tips look ugly LOL
		spark.fuse = TICRATE/2
		spark.momx = P_ReturnThrustX(spark, angle, (P_RandomRange(-1, 1) + 12)*spark.scale)
		spark.momx = P_ReturnThrustY(spark, angle, (P_RandomRange(-1, 1) + 12)*spark.scale)
		spark.momz = P_RandomRange(8, 12) * spark.scale
		spark.scale = $ << 1
	end

	// grind sound
	if leveltime % 8 == 0
		S_StartSound(mo, sfx_grind)
	end
end

local function DeflectMissile(robo, mo)
	local player = valid(mo.target) and mo.target.player

	if BossInPain(robo) // ignore projectiles while flashing
	or player and player.charability2 == CA2_MELEE
	and (mo.type == player.revitem or mo.type == player.thokitem) // don't reflect Amy's hearts
		return
	end

	SetBossState(robo, STATE_IDLE)

	robo.momx = 0
	robo.momy = 0
	robo.angle = R_PointToAngle2(robo.x, robo.y, mo.x, mo.y)
	robo.state = robo.info.meleestate
	S_StartSound(robo, robo.info.attacksound)

	mo.target = robo
	if player and player.charability2 == CA2_GUNSLINGER
	and mo.type == player.revitem
		// do the funny swat
		mo.flags = $ & ~MF_NOGRAVITY
		mo.angle = RandomAngle()
		mo.rollangle = RandomAngle()
		P_SetObjectMomZ(mo, 8*FRACUNIT)
		P_InstaThrust(mo, robo.angle - ANGLE_45, 4*robo.scale)
	else// this missile could be anything, respect its gravity and speed
		local speed = FixedHypot(FixedHypot(mo.momx, mo.momy), mo.momz)
		mo.angle = robo.angle - ANGLE_45
		mo.momz = 0
		mo.momx = P_ReturnThrustX(mo, mo.angle, speed)
		mo.momy = P_ReturnThrustY(mo, mo.angle, speed)
	end
end

local function BossCollide(robo, mo)
	if not robo.valid
	or not mo.valid
	or robo.z > mo.z + mo.height
	or mo.z > robo.z + robo.height
		return
	end

	if mo.type == MT_AALPCAPSULE
	and mo.flags & MF_NOGRAVITY
		SetBossState(robo, STATE_STUNNED)
		P_DamageMobj(mo, robo, robo)
	elseif mo.flags & MF_MISSILE
	and mo.target ~= robo // don't deflect your own missiles
	and not (mo.flags & MF_NOCLIPTHING) // if you already exploded, you can't be deflected!
	and not mo.silv_target // if you were thrown by Silver, you're gonna blow up anyway
	and robo.threshold ~= STATE_STUNNED
		DeflectMissile(robo, mo)
		return false
	end
end

local function BossDamage(robo, mo, source, damage, damagetype)
	if not robo.valid
	or robo.threshold == STATE_STUNNED
	or damagetype == DMG_NUKE // allow armageddon damage C:<
	or not mo // allow arbitrary damage?
		return
	end

	if not mo.valid
		return false
	end

	if mo.type == MT_AALPCAPSULE // if Silver throws a capsule at the boss, stun the boss!
		SetBossState(robo, STATE_STUNNED)
		P_DamageMobj(mo, robo, robo)
		return false
	end

	if mo.silv_target // if you were thrown by Silver, you're gonna blow up anyway
		return
	end

	return false
end

addHook("MobjCollide", BossCollide, MT_AALPBOSS)
addHook("MobjMoveCollide", BossCollide, MT_AALPBOSS)

addHook("ShouldDamage", BossDamage, MT_AALPBOSS)

addHook("MobjSpawn", EggroboSpawn, MT_AALPBOSS)

addHook("TouchSpecial", function(robo, mo)
	if Wham(robo, mo)
		return true
	end
end, MT_AALPBOSS)

addHook("MobjRemoved", function()
	P_LinedefExecute(998) // raises the exit fof and lowers the boss trigger
end, MT_AALPBOSS)

addHook("BossThinker", function(mo) // holy shit, I never realized how shitty the default boss thinker is
	if not mo.valid
		return
	end

	// death
	if mo.state == mo.info.deathstate
		if mo.tics & 1
			A_BossScream(mo)
		end
		if mo.tics < states[mo.state].tics / 2
			mo.flags2 = $ ^^ MF2_DONTDRAW
			if valid(mo.tracer)
				mo.tracer.flags2 = $ ^^ MF2_DONTDRAW
			end
		end
		if mo.tics == 1
			A_AcidicAlpinesSignExplode(mo, sfx_pop)
		end
		return
	end

	// painstate
	if mo.flags2 & MF2_FRET
		if mo.tics == 1
			SetBossState(mo, STATE_FIRING)
		end
		if mo.state ~= mo.info.painstate
			mo.flags2 = $ & ~MF2_FRET
		end
		// fallthrough
	end

	// hitting a player, in pain, etc.
	if mo.state ~= mo.info.spawnstate
	and mo.state ~= mo.info.seestate
		SetBossState(mo, STATE_IDLE)
		EggroboBob(mo)
		return true
	end

	// height check! make sure we're not flying at unreachable heights
	if mo.z > mo.floorz + 2*FixedMul(mo.info.painchance, mo.scale)
		mo.flags2 = $ & ~MF2_JUSTATTACKED
	end

	// moving to the floor
	if not (mo.flags2 & MF2_JUSTATTACKED)
		if mo.z < mo.floorz + FixedMul(mo.info.painchance, mo.scale)
			mo.momz = 0
			mo.flags2 = $ | MF2_JUSTATTACKED
		else
			mo.momz = (mo.floorz - mo.z) / 12
		end
		return true
	end

	// attack logic
	if mo.threshold == STATE_IDLE
		EggroboBob(mo)
		if SecureBossTarget(mo)
			SetBossState(mo, STATE_AIMING)
		end

	elseif mo.threshold == STATE_FIRING
		EggroboBob(mo)
		mo.angle = $ + ANG10
		mo.reactiontime = $ - 1

		if mo.reactiontime % 3 == 0
			local tracer = mo.tracer
			local capsule = P_SpawnMobjFromMobj(tracer, 0, 0, tracer.info.height, FIRABLES[P_RandomKey(NUMFIRABLES) + 1])
			capsule.target = mo
			capsule.momz = mo.momz + P_MobjFlip(capsule)*FixedMul(FixedMul(P_RandomFixed(), mo.info.speed), capsule.scale)
			P_InstaThrust(capsule,
				mo.angle + ANGLE_180 + P_RandomRange(-10, 10)*ANG1, FixedMul(mo.info.speed, capsule.scale))
			S_StartSound(tracer, tracer.info.activesound)
		end
		if mo.reactiontime == 0
			SetBossState(mo, STATE_AIMING)
		end

	elseif mo.threshold == STATE_AIMING
		if SecureBossTarget(mo)
			local target = mo.target
			local facetarget = R_PointToAngle2(mo.x, mo.y, mo.target.x, mo.target.y)

			mo.angle = $ + min(max(facetarget - $, -ANG10), ANG10)

			if leveltime % 4 == 0
			and mo.spritexoffset ~= nil // don't do this if spritexoffset/spriteyoffset aren't variables
				local height = FixedDiv(target.height, target.scale)
				for i = 0, 3
					local overlay = P_SpawnMobjFromMobj(target, 0, 0, 0, MT_OVERLAY)
					overlay.state = S_LOCKON4
					overlay.target = target
					overlay.rollangle = i * ANGLE_90
					overlay.renderflags = $ | RF_FULLBRIGHT | RF_NOCOLORMAPS
					overlay.spritexoffset = P_ReturnThrustY(overlay, overlay.rollangle, 32*FRACUNIT)
					overlay.spriteyoffset = P_ReturnThrustX(overlay, overlay.rollangle, 32*FRACUNIT) + 16*FRACUNIT
				end
			end

			VibrateBoss(mo)

			mo.reactiontime = $ - 1

			if mo.reactiontime == 0
				SetBossState(mo, STATE_DASHING)
			end
		else
			SetBossState(mo, STATE_IDLE)
			mo.state = mo.info.spawnstate
		end

	elseif mo.threshold == STATE_DASHING
		mo.reactiontime = $ - 1
		VibrateBoss(mo)
		mo.angle = R_PointToAngle2(0, 0, mo.momx, mo.momy)
		P_InstaThrust(mo, mo.angle, 60*mo.scale)

		if leveltime & 1
			P_SpawnGhostMobj(mo).fuse = 5
			if valid(mo.tracer)
				P_SpawnGhostMobj(mo.tracer).fuse = 5
			end
		end

		if mo.reactiontime == 0
			SetBossState(mo, STATE_COOLDOWN)
		end

	elseif mo.threshold == STATE_COOLDOWN
		EggroboBob(mo)
		if FixedHypot(mo.momx, mo.momy) > mo.scale
			mo.momx = 7*$/8
			mo.momy = 7*$/8
		else
			SetBossState(mo, STATE_FIRING)
		end

	elseif mo.threshold == STATE_STUNNED
		mo.angle = $ + mo.reactiontime*ANG1/3
		mo.reactiontime = $ - 1
		if leveltime % 3 == 0
			local radius = FixedDiv(mo.radius, mo.scale)
			local height = FixedDiv(mo.height, mo.scale)
			local spark = P_SpawnMobjFromMobj(mo,
				FixedMul(2*radius, P_RandomFixed()) - radius,
				FixedMul(2*radius, P_RandomFixed()) - radius,
				FixedMul(height, P_RandomFixed()), MT_MINECARTSPARK)
			local angle = R_PointToAngle2(mo.x, mo.y, spark.x, spark.y)

			spark.flags2 = $ | MF2_DONTDRAW // I think the tips look ugly LOL
			spark.fuse = TICRATE/2
			spark.momx = P_ReturnThrustX(spark, angle, (P_RandomRange(-1, 1) + 8)*spark.scale)
			spark.momx = P_ReturnThrustY(spark, angle, (P_RandomRange(-1, 1) + 8)*spark.scale)
			spark.momz = P_RandomRange(-1, 16) * spark.scale
			spark.scale = $ << 1
		end
		if leveltime % 8 == 0
			StartSoundInArena(mo, mobjinfo[MT_AALPCUCKOO].seesound)
		end
		if mo.reactiontime == 0
			SetBossState(mo, STATE_FIRING)
		end
	end

	return true
end, MT_AALPBOSS)

addHook("LinedefExecute", do
	local signtype = mobjinfo[MT_SIGN].doomednum
	local sign

	for mt in mapthings.iterate
		if mt.type == signtype
		and valid(mt.mobj)
			sign = mt.mobj
			break // there should only be one sign
		end
	end

	if not sign // huh??? somebody's script removed my sign
		P_LinedefExecute(998) // raises the exit fof and lowers the boss trigger
		return
	end

	sign.state = S_AALPSIGNEXPLODE1
end, "AALPBOSS")

addHook("LinedefExecute", function(line) // music change linedefs still fade out music even if it's switching to the same track :V
	if line.frontside.textureoffset == 0 // already executed
		return
	end

	local sector = line.frontsector

	for i = 0, #sector.lines - 1
		local line = sector.lines[i]
		if line.special == 413 // Change Music
			line.frontside.textureoffset = 0 // kill the music fadeout
		end
	end
end, "AALPFADE")

// Eggrobo (spawner)

addHook("MobjSpawn", EggroboSpawn, MT_AALPEGGROBO)

addHook("TouchSpecial", function(robo, mo)
	if Wham(robo, mo)
		return true
	end
end, MT_AALPEGGROBO)

addHook("MobjThinker", function(mo)
	if not mo.valid
		return
	end

	// hitting a player
	if mo.state ~= mo.info.spawnstate
		EggroboBob(mo)
		return
	end

	// finished spitting capsules, fly upwards
	if mo.reactiontime <= 0
		mo.momz = $ + mo.scale
		if mo.z >= mo.ceilingz - mo.height
			P_RemoveMobj(mo)
		end
		return
	end

	// firing
	if mo.flags2 & MF2_JUSTATTACKED
		EggroboBob(mo)
		mo.angle = $ + ANG10
		mo.reactiontime = $ - 1

		if mo.reactiontime % 3 == 0
			local tracer = mo.tracer
			local capsule = P_SpawnMobjFromMobj(tracer, 0, 0, tracer.info.height, MT_AALPCAPSULE)
			capsule.target = mo
			capsule.fuse = capsule.info.raisestate
			capsule.momz = mo.momz + P_MobjFlip(capsule)*FixedMul(FixedMul(P_RandomFixed(), mo.info.speed), capsule.scale)
			P_InstaThrust(capsule,
				mo.angle + ANGLE_180 + P_RandomRange(-10, 10)*ANG1, FixedMul(mo.info.speed, capsule.scale))
			S_StartSound(tracer, tracer.info.activesound)
		end
		if mo.reactiontime == 0
			S_StartSound(mo, mo.info.seesound)
		end
		return
	end

	// moving to the floor
	if mo.z < mo.floorz + FixedMul(mo.info.painchance, mo.scale)
		mo.momz = 0
		mo.flags2 = $ | MF2_JUSTATTACKED
	else
		mo.momz = (mo.floorz - mo.z) / 12
	end
end, MT_AALPEGGROBO)

addHook("LinedefExecute", function(line, mo)
	/*if line.frontside.rowoffset == 69
		return
	end

	line.frontside.rowoffset = 69*/
	// for some reason I had this set up for Each Time? I don't remember why, so I changed it back to Once

	local type = mobjinfo[MT_AALPSPAWNER].doomednum
	for mt in mapthings.iterate
		if mt.type == type
		and mt.angle == line.tag
			local player = mo.player
			local robo = P_SpawnMobjFromMobj(mt.mobj, 0, 0, 0, MT_AALPEGGROBO)
			if player
				S_StartSound(nil, robo.info.seesound, player)
				robo.angle = R_PointToAngle2(robo.x, robo.y, mo.x, mo.y)
			end
			break
		end
	end
end, "AALPCAPS")

// Cuckoo (boss flicky ghost things)

addHook("MobjSpawn", function(mo)
	mo.color = SKINCOLOR_SUPERGOLD3
	mo.frame = $ | FF_FULLBRIGHT
	mo.colorized = true
	mo.blendmode = AST_ADD
end, MT_AALPCUCKOO)

addHook("MobjThinker", function(mo)
	if not mo.valid
		return
	end

	local target = mo.target

	if not valid(target)
	or target.health <= 0
	or target.threshold ~= STATE_STUNNED
		P_RemoveMobj(mo)
		return
	end

	local x, y, z, angle

	mo.angle = $ - mo.info.painchance
	angle = mo.angle + ANGLE_90
	x = target.x + P_ReturnThrustX(mo, angle, 2*(target.radius + mo.radius))
	y = target.y + P_ReturnThrustY(mo, angle, 2*(target.radius + mo.radius))
	if target.eflags & MFE_VERTICALFLIP
		z = target.z - 2*mo.height
	else
		z = target.z + target.height
	end
	z = $ + P_ReturnThrustX(mo, 2*angle, mo.height)
	mo.z = z
	P_TryMove(mo, x, y, true)
end, MT_AALPCUCKOO)

// addon support and easter eggs

local silverloaded = false
local janaloaded = false

addHook("MapChange", do
	if not silverloaded
		if silv_addTKextra
			silverloaded = true
			silv_addTKextra(MT_AALPCAPSULE, {}) // lets Silver grab and throw the capsules
			if silv_addIdleSprite
				silv_addIdleSprite({SPR_AALP, A, FRACUNIT}) // adds capsules to the list of possible idle animation sprites
			end
		end
	end

	if not janaloaded
		if JanaEnergySaber
			janaloaded = true
			JanaEnergySaber.sliceInfo[MT_AALPCAPSULE] = { // lets Jana slice capsules
				sprite = SPR_ALPF, // I put these in ALPF because I presume no one will want to model them
				frames = {Q + 36, R + 36}
			}
		end
	end
end)