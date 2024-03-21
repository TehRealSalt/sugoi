/*
Boulder Shield (v2.2 SUGOI trilogy port)
	by Lach

You may use this shield in your own levels if you wish. Please do not edit it!
You will need to copy the TVBD sprites and the TVBDICON graphic from wherever you found this.
This script uses Rapdidgame7's vector3/quaternion library (vecquat.lua), and must be bundled with it to work.
I have been given permission to use an indev version for SUGOI, based on commit 5fddeb1.
I suggest you grab the latest version if it has since been updated: https://github.com/Rapidgame7/srb2utils

v1
*/

if SH_BOULDER
	return
end

rawset(_G, "SH_BOULDER", 88)

local MIN_RADIUS = 32*FRACUNIT
local MAX_RADIUS = 64*FRACUNIT

local function valid(mo)
	return mo and mo.valid
end

// To prevent duplicate freeslots
local function SafeFreeslot(...)
	local function CheckSlot(item) // this function deliberately errors when a freeslot does not exist
		if _G[item] == nil // this will error by itself for states and objects
			error() // this forces an error for sprites, which do actually return nil for some reason
		end
	end
	for _, item in ipairs({...})
		if pcall(CheckSlot, item)
			print("\131NOTICE:\128 " .. item .. " was not allocated, as it already exists.")
		else
			freeslot(item)
		end
	end
end

SafeFreeslot("SPR_TVBD", "S_BOULDER_BOX", "S_BOULDER_GOLDBOX", "S_BOULDER_ICON1", "S_BOULDER_ICON2",
	"MT_BOULDER_BOX", "MT_BOULDER_GOLDBOX", "MT_BOULDER_ICON", "MT_BOULDER_ORB", "MT_BOULDER_COLLIDER")

sfxinfo[sfx_kc40].caption = "Boulder Shield"

states[S_BOULDER_BOX] = {
	sprite = SPR_TVBD,
	frame = A,
	tics = 2,
	nextstate = S_BOX_FLICKER
}

states[S_BOULDER_GOLDBOX] = {
	sprite = SPR_TVBD,
	frame = B,
	tics = 2,
	action = A_GoldMonitorSparkle,
	nextstate = S_GOLDBOX_FLICKER
}

states[S_BOULDER_ICON1] = {
	sprite = SPR_TVBD,
	frame = C|FF_ANIMATE,
	tics = 18,
	var1 = 3,
	var2 = 4,
	nextstate = S_BOULDER_ICON2
}

states[S_BOULDER_ICON2] = {
	sprite = SPR_TVBD,
	frame = C,
	tics = 18,
	action = A_GiveShield,
	var1 = SH_BOULDER
}

mobjinfo[MT_BOULDER_BOX] = {
	--$Name Boulder Shield
	--$Sprite TVBDA0
	--$Category boxes
	doomednum = 488,
	spawnstate = S_BOULDER_BOX,
	spawnhealth = 1,
	reactiontime = 8,
	painstate = S_BOULDER_BOX,
	deathstate = S_BOX_POP1,
	deathsound = sfx_pop,
	speed = 1,
	radius = 18*FRACUNIT,
	height = 40*FRACUNIT,
	mass = 100,
	damage = MT_BOULDER_ICON,
	flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR
}

mobjinfo[MT_BOULDER_GOLDBOX] = {
	--$Name Boulder Shield (Respawn)
	--$Sprite TVBDB0
	--$Category boxes2
	doomednum = 489,
	spawnstate = S_BOULDER_GOLDBOX,
	spawnhealth = 1,
	reactiontime = 8,
	attacksound = sfx_monton,
	painstate = S_BOULDER_GOLDBOX,
	deathstate = S_GOLDBOX_OFF1,
	deathsound = sfx_pop,
	radius = 20*FRACUNIT,
	height = 44*FRACUNIT,
	mass = 100,
	damage = MT_BOULDER_ICON,
	flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR|MF_GRENADEBOUNCE
}

mobjinfo[MT_BOULDER_ICON] = {
	spawnstate = S_BOULDER_ICON1,
	spawnhealth = 1,
	seesound = sfx_kc40,
	reactiontime = 8,
	speed = 2*FRACUNIT,
	radius = 8*FRACUNIT,
	height = 14*FRACUNIT,
	mass = 100,
	damage = 62*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY|MF_BOXICON
}

mobjinfo[MT_BOULDER_ORB] = {
	spawnstate = S_INVISIBLE,
	spawnhealth = 1000,
	reactiontime = 8,
	painchance = SKINCOLOR_BEIGE,
	speed = SH_BOULDER,
	radius = 64*FRACUNIT,
	height = 64*FRACUNIT,
	dispoffset = 4,
	mass = 16,
	flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY|MF_SCENERY
}

mobjinfo[MT_BOULDER_COLLIDER] = {
	spawnstate = S_INVISIBLE,
	spawnhealth = 1000,
	radius = 32*FRACUNIT, --MAX_RADIUS/2
	height = 64*FRACUNIT, --MAX_RADIUS
	activesound = sfx_s3k5d,
	attacksound = sfx_s3k9e,
	flags = MF_SOLID|MF_BOUNCE|MF_NOCLIP
}

// powerupdisplay icon

local cv_renderer = CV_FindVar("renderer")
local cv_powerupdisplay = CV_FindVar("powerupdisplay")
local cv_exitmove = CV_FindVar("exitmove")

hud.add(function(v, player, cam)
	if (player.powers[pw_shield] & SH_NOSTACK) == SH_BOULDER
	and (cv_powerupdisplay.value == 2 or not cam.chase and cv_powerupdisplay.value)
		v.drawScaled(
			((player.pflags & PF_FINISHED and cv_exitmove.value and multiplayer and -20 or 0) + hudinfo[HUD_POWERUPS].x) * FRACUNIT,
			hudinfo[HUD_POWERUPS].y * FRACUNIT,
			FRACUNIT >> 1, v.cachePatch("TVBDICON"), V_PERPLAYER|hudinfo[HUD_POWERUPS].f|V_HUDTRANS)
	// not bothered to do the slidey thing - for shields it only ever happens if you lose PF_FINISHED, and that's not a likely occurence
	end
end)

// Collider hooks

local function CheckPlayerBoulderActive(player)
	if player.pflags & (PF_JUMPED|PF_SHIELDABILITY|PF_USEDOWN) ~= (PF_JUMPED|PF_SHIELDABILITY|PF_USEDOWN)
		local boulder = player.bouldershield
		local collider = boulder.collider
		if valid(collider)
			P_RemoveMobj(collider)
		end
		boulder.collider = nil
		player.pflags = $ & ~PF_SHIELDABILITY
		return false
	end
	return true
end

local function TeleportBoulderPlayer(player)
	local mo = player.mo
	local collider = player.bouldershield.collider

	local followoffs
	if valid(player.followmobj)
		followoffs = {
			x = player.followmobj.x - mo.x,
			y = player.followmobj.y - mo.y,
			z = player.followmobj.z - mo.z
		}
	end
	P_MoveOrigin(mo, collider.x, collider.y, collider.z + (collider.height >> 1) - (mo.height >> 1)) // I'm sorry, I know this probably breaks your custom character. :(
	if followoffs
		P_MoveOrigin(player.followmobj,
			mo.x + followoffs.x,
			mo.y + followoffs.y,
			mo.z + followoffs.z)
	end
end

local function BoulderCollide(collider, mo)
	if not (collider.valid and mo.valid) return end

	if mo.player
		return false
	end

	// pop enemies and monitors
	if mo.flags & MF_SHOOTABLE
	and mo.flags & (MF_MONITOR|MF_SPECIAL)
	and mo.z <= collider.z + collider.height
	and collider.z <= mo.z + mo.height
		P_DamageMobj(mo, collider, collider.target)
	end

	// get bounced by springs
	if mo.flags & MF_SPRING
	and not (collider.eflags & MFE_SPRUNG)
	and mo.z <= collider.z + collider.height
	and collider.z <= mo.z + mo.height
		local target = collider.target
		local player = valid(target) and target.player
		if player
		and collider.scale >= FixedMul(FixedDiv(MAX_RADIUS, collider.info.radius), target.scale) // don't spring until the collider is at full scale
			// spring the collider and transfer properties to the player
			if mo.state < mo.info.raisestate
				S_StartSound(target, sfx_sprong)
			end
			P_DoSpring(mo, collider)
			target.momx = collider.momx
			target.momy = collider.momy
			target.momz = collider.momz
			TeleportBoulderPlayer(player)
			if mo.info.damage
				target.angle = mo.angle
				player.drawangle = target.angle
			end
		end
	end

	// use vanilla collision for colliding with other boulder shields
	if mo.type == collider.type
	and not (collider.flags2 & MF2_JUSTATTACKED)
		return
	end

	// don't collide with solid objects, it's kind of jank because of the scale difference
	if mo.flags & MF_SOLID
		return false
	end
end

addHook("MobjMoveCollide", BoulderCollide, MT_BOULDER_COLLIDER)
addHook("MobjCollide", BoulderCollide, MT_BOULDER_COLLIDER)

addHook("MobjThinker", function(collider)
	local target = collider.target
	local player = valid(target) and target.player

	// remove self if player despawns or loses shield
	if not player
	or (player.powers[pw_shield] & SH_NOSTACK) ~= SH_BOULDER
		P_RemoveMobj(collider)
		return
	end

	collider.friction = FRACUNIT
end, MT_BOULDER_COLLIDER)

// Initialize stuff on shield spawn

local function DoBoulderVisuals(player)
	local mo = player.mo
	local boulder = player.bouldershield
	local pebbles = boulder.pebbles
	local vec = boulder.rotation_vec
	local orb = boulder.orb.valid and boulder.orb
	local sector = mo.subsector.sector

	local RotateFunc = vec3.rotate or vec3.rotate_test

	for j = -2, 2
		for i = 1, 6
			local rock = pebbles[j][i]
			local z = i*ANG60
			local a = j*ANG30
			local zdist = FixedMul(cos(a), FixedMul(mo.scale, sin(z)))
			local hdist = FixedMul(cos(a), FixedMul(mo.scale, cos(z)))

			vec.x = FixedMul(boulder.radius, hdist)
			vec.y = 2*j*FixedMul(boulder.radius, mo.scale)/5
			vec.z = FixedMul(boulder.radius, zdist)

			RotateFunc(vec, boulder.rotation)

			if valid(rock)
				P_MoveOrigin(rock,
					mo.x + vec.x,
					mo.y + vec.y,
					mo.z + (mo.height >> 1) + vec.z)
			else
				rock = P_SpawnMobj(
					mo.x + vec.x,
					mo.y + vec.y,
					mo.z + (mo.height >> 1) + vec.z,
					MT_PARTICLE)
				rock.target = mo
				rock.state = S_ROCKCRUMBLEB
				rock.anim_duration = -1
				rock.frame = (i + j + 2) % 8
				pebbles[j][i] = rock
			end

			rock.scale = FixedDiv(FixedMul(boulder.radius, mo.scale), MAX_RADIUS)
			rock.fuse = 2
			if orb
				rock.flags2 = orb.flags2 & ~MF2_SHIELD
				rock.eflags = orb.eflags
			end

			// cull rocks on FOFs so the player doesn't turn invisible
			if cv_renderer.value == 1
				if rock.z < rock.floorz
				and (rock.floorrover or rock.subsector.sector ~= sector)
				or rock.z + rock.height > rock.ceilingz
				and (rock.ceilingrover or rock.subsector.sector ~= sector)
					rock.flags2 = $ | MF2_DONTDRAW
				end
			end
		end
	end
end

addHook("ShieldSpawn", function(player)
	local mo = player.mo
	if (player.powers[pw_shield] & SH_NOSTACK) == SH_BOULDER
		local boulder
		local orb
		local toRemove = {}

		// remove existing boulder shield orbs
		for item in mobjs.iterate()
			if item.type == MT_BOULDER_ORB
			and item.target == mo
				table.insert(toRemove, item)
			end
		end

		for i, item in ipairs(toRemove)
			P_RemoveMobj(item)
		end

		// create boulder shield data
		boulder = {
			flags = 0,
			jump = INT32_MIN,
			radius = MIN_RADIUS,
			rotation = quat(),
			rotation_vec = vec3(),
			pebbles = {}
		}
		player.bouldershield = boulder

		// spawn shield orb - Boulder Shield's is invisible, but its flags2/eflags are copied to the pebbles
		orb = P_SpawnMobj(0, 0, 0, MT_BOULDER_ORB)
		orb.flags2 = $ | MF2_SHIELD
		orb.target = mo
		orb.threshold = (player.powers[pw_shield] & SH_NOSTACK)
		boulder.orb = orb

		// instantiate pebble tables (with magic numbers because I'm lazy)
		for i = -2, 2
			boulder.pebbles[i] = {}
		end
		DoBoulderVisuals(player)
	end
end)

// Remove boulder data when the shield orb is removed

addHook("MobjRemoved", function(orb)
	local target = orb.target
	local player = valid(target) and target.player

	if not player then return end

	local boulder = player.bouldershield

	if valid(boulder.collider)
		P_RemoveMobj(boulder.collider)
	end

	for i = -2, 2
		for j = 1, 6
			local pebble = boulder.pebbles[i][j]
			if valid(pebble)
				P_RemoveMobj(pebble)
			end
		end
	end

	player.bouldershield = nil
end, MT_BOULDER_ORB)

// Spawn collider on use

addHook("ShieldSpecial", function(player)
	local boulder = player.bouldershield
	local mo = player.mo

	if (player.powers[pw_shield] & SH_NOSTACK) == SH_BOULDER
	and not (player.pflags & PF_USEDOWN)
	and boulder
		local collider = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_BOULDER_COLLIDER)
		collider.scale = FixedDiv(mo.radius, collider.info.radius)
		collider.target = mo
		collider.z = mo.z + (mo.height >> 1) - (collider.height >> 1)
		collider.flags = $ & ~MF_NOCLIP
		S_StartSound(mo, collider.info.attacksound)
		player.pflags = $ & ~(PF_SPINNING|PF_NOJUMPDAMAGE) | (PF_JUMPED|PF_THOKKED|PF_SHIELDABILITY)
		mo.state = S_PLAY_ROLL
		boulder.collider = collider
		boulder.jump = INT32_MIN
		boulder.slope = collider.standingslope
		boulder.grounded = P_IsObjectOnGround(collider)
		boulder.momz = mo.momz
		boulder.coords = vec3(collider.x, collider.y, collider.z)
		mo.skipdove = false // minimal Skip support
	end
end)

// hook 1: PlayerThink runs after player movement code and before P_MobjThinker, so transfer momentum to collider now.

addHook("PlayerThink", function(player)
	local mo = player.mo
	local boulder = player.bouldershield
	local collider = boulder and boulder.collider

	if (player.powers[pw_shield] & SH_NOSTACK) ~= SH_BOULDER
	or not mo
	or not valid(collider)
		return
	end

	// deactivate the shield when no longer holding spin
	if not CheckPlayerBoulderActive(player)
		return
	end

	// sync gravflip
	collider.flags2 = $ & ~MF2_OBJECTFLIP | (mo.flags2 & MF2_OBJECTFLIP)
	collider.eflags = $ & ~MFE_VERTICALFLIP | (mo.eflags & MFE_VERTICALFLIP)

	local grounded = P_IsObjectOnGround(collider)
	local oldscale = collider.scale
	local maxscale = FixedMul(FixedDiv(MAX_RADIUS, collider.info.radius), mo.scale)

	// detect jump press
	boulder.jump = player.cmd.buttons & BT_JUMP and $ + 1 or 0

	// scale the collider--if it can't fit, revert to previous scale
	if collider.scale ~= maxscale
		collider.scale = min(maxscale, $ + FixedDiv(8*mo.scale, collider.info.radius))
		if not P_TryMove(collider, collider.x, collider.y, true)
			/*for _, var in ipairs({"x", "y", "z"})
				local str = "mom"..var
				mo[str] = 0
				collider[str] = 0
			end*/
			collider.scale = $ - FixedDiv(8*mo.scale, collider.info.radius)
		end
	end

	// collider movement - copy player momentum and also jump if needed
	collider.flags = $ | MF_NOCLIPTHING
	collider.momx = mo.momx
	collider.momy = mo.momy
	if grounded
		local flip = P_MobjFlip(collider)

		if not boulder.grounded
			S_StartSound(mo, collider.info.activesound)
		end

		if flip*boulder.momz <= -5*mo.scale // bounce
			collider.momz = -boulder.momz/2
			grounded = false
			boulder.flags = $ | 1
			P_MoveOrigin(collider, mo.x, mo.y, mo.z + (mo.height >> 1) - (collider.height >> 1))
		elseif boulder.jump == 1 // pressed jump?
			S_StartSound(mo, sfx_jump)
			collider.momz = flip*10*mo.scale
			if collider.eflags & MFE_UNDERWATER
				collider.momz = FixedMul($, FixedDiv(117*FRACUNIT, 200*FRACUNIT))
			end
			grounded = false
			boulder.flags = $ | 1
			P_MoveOrigin(collider, mo.x, mo.y, mo.z + (mo.height >> 1) - (collider.height >> 1))
		else // on the ground
			local slope = collider.standingslope
			if slope // slope physics?
			and not (slope.flags & SL_NOPHYSICS)
				local factor
				local hangle = slope.xydirection
				local zangle = slope.zangle
				if zangle > 0
					zangle = -$
					hangle = $ + ANGLE_180
				end
				factor = cos(hangle - R_PointToAngle2(0, 0, collider.momx, collider.momy))
				factor = 2*($ + FRACUNIT)
				P_Thrust(collider, hangle, FixedMul(FixedMul(sin(zangle), P_GetMobjGravity(mo)), factor))
			end
			mo.momz = 0
			P_MoveOrigin(collider, mo.x, mo.y, collider.z)
		end
	elseif boulder.grounded
	and boulder.slope // just launched?
		local coords = boulder.coords
		local momang = R_PointToAngle2(0, 0, collider.momx, collider.momy)
		P_MoveOrigin(collider, mo.x, mo.y, mo.z + (mo.height >> 1) - (collider.height >> 1))
		P_InstaThrust(collider, momang, FixedHypot(collider.x - coords.x, collider.y - coords.y))
		collider.momz = collider.z - coords.z
		boulder.flags = $ | 1
	else // in the air
		if collider.z + collider.height >= collider.ceilingz
		and P_MobjFlip(mo)*mo.momz > 0
			collider.momz = 0
			mo.momz = 0
		else
			collider.momz = mo.momz
		end
		P_MoveOrigin(collider, mo.x, mo.y, mo.z + (mo.height >> 1) - (collider.height >> 1))
	end
	collider.flags = $ & ~MF_NOCLIPTHING

	if not P_TryMove(collider, collider.x, collider.y, true) // safeguard for getting stuck in a wall after a teleport, such as via P_DoSpring
		collider.scale = FixedDiv(mo.radius, collider.info.radius)
	end

	player.pflags = $ | PF_JUMPSTASIS

	boulder.coords.x = collider.x
	boulder.coords.y = collider.y
	boulder.coords.z = collider.z
	boulder.momz = collider.momz
	boulder.grounded = grounded
	boulder.slope = collider.standingslope
end)

// hook 2: ThinkFrame occurs after all thinkers, so the collider has moved and bounced off any surfaces it needs to. Transfer momentum back to the player for next frame, and handle the visuals!

addHook("ThinkFrame", do
	for player in players.iterate
		local mo = player.mo
		local boulder = player.bouldershield

		if (player.powers[pw_shield] & SH_NOSTACK) ~= SH_BOULDER
		or not mo
		or not boulder
			continue
		end

		CheckPlayerBoulderActive(player) // deactivate the shield if needed

		local vec = boulder.rotation_vec
		local collider = boulder.collider
		local orb = boulder.orb

		// grow/shrink the shield radius
		if valid(collider)
			orb.flags2 = $ & ~MF2_DONTDRAW
			boulder.radius = max(FixedMul(MIN_RADIUS, player.shieldscale), FixedDiv(collider.radius, mo.scale))
			mo.momx = collider.momx
			mo.momy = collider.momy
			if boulder.flags & 1
				mo.momz = collider.momz
				boulder.flags = $ & ~1
			end

			// teleport the player to its position if active
			TeleportBoulderPlayer(player)

			// spawn particles if wallbounced
			/*if boulder.blockedangle ~= nil
				SpawnHorizontalParticles(player)
				boulder.blockedangle = nil
			end*/
		else
			boulder.radius = max($ - 6*FRACUNIT, FixedMul(MIN_RADIUS, player.shieldscale))
			if boulder.radius == 0
				orb.flags2 = $ | MF2_DONTDRAW
			end
		end

		// rotates the shield
		if (mo.momx or mo.momy)
		and boulder.radius // div0 prevention
			local velocity = FixedDiv(FixedHypot(mo.momx, mo.momy), mo.scale)
			local velocity_angle = R_PointToAngle2(0, 0, mo.momx, mo.momy)
			vec.x = -sin(velocity_angle)
			vec.y = cos(velocity_angle)
			vec.z = 0
			boulder.rotation = (quat.rotate or quat.rotate_test)($, vec,
				FixedAngle(min(15*FRACUNIT, FixedMul(FixedDiv(velocity, boulder.radius), 50*FRACUNIT))) * P_MobjFlip(mo)
			)
		end

		// pebble visuals
		DoBoulderVisuals(player)
	end
end)

// Protect against the only damaging rock in the game (which isn't even used in vanilla anymore LOL)

addHook("ShouldDamage", function(mo, item)
	local player = valid(item) and mo.valid and mo.player

	if not player
	or (player.powers[pw_shield] & SH_NOSTACK) ~= SH_BOULDER
		return
	end

	if item.type == MT_FALLINGROCK
	or item.damagetype_boulder // a custom variable, in the extremely niche case people want to support this shield
		return false
	end
end)

// Kirby support

if not(kirbyabilitytable)
	rawset(_G, "kirbyabilitytable", {})
end
kirbyabilitytable[MT_BOULDER_BOX] = 3 // I know Force Shield also gives this, but come on... stone... OBVIOUSLY

// Tails Doll support

if not TailsDollShieldColors
    rawset(_G, "TailsDollShieldColors", {})
end
TailsDollShieldColors[SH_BOULDER] = mobjinfo[MT_BOULDER_ORB].painchance

// ChrispyChars & Skip support (Skip devs please feel free to override with something more substantial)

local ccloaded = false
local skiploaded = false
addHook("MapChange", do
	if not skiploaded
	and AddSkipMonitor
		skiploaded = true
		AddSkipMonitor(MT_BOULDER_BOX,
			70, // this is just the highest value I can see for a shield in Skip 1.1, I don't actually know what the cost should be
			"\x84 Passive:\x80 It's 3D",
			"\x83 Active:\x80 Boulder Dive"
		)
	end
	if not ccloaded
	and ChrispyChars
		ccloaded = true
		ChrispyChars.shieldProperties[SH_BOULDER] = ChrispyChars.SHIELDFLAGS.NOABILITYCOMBO
	end
end)