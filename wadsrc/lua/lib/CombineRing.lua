/*
Combine Ring & Hyper Ring Monitors
	by Lach

beta 2
*/

if CombineRing
	return
end

local CR = {}

rawset(_G, "CombineRing", CR)

// To prevent duplicate freeslots
local function CheckSlot(item) // this function deliberately errors when a freeslot does not exist
	if _G[item] == nil // this will error by itself for states and objects
		error() // this forces an error for sprites, which do actually return nil for some reason
	end
end

local function SafeFreeslot(...)
	local item = ...
	if item == nil
		return
	end

	if pcall(CheckSlot, item)
		print("\131NOTICE:\128 " .. item .. " was not allocated, as it already exists.")
	else
		freeslot(item)
	end

	SafeFreeslot(select(2, ...))
end

// ---------
// constants
// ---------

CR.RINGS = {}
CR.RINGS.NONE = 0
CR.RINGS.COMBINE = 1
CR.RINGS.HYPER = 2

CR.COLORS = setmetatable({
	[CR.RINGS.NONE] = SKINCOLOR_NONE,
	[CR.RINGS.COMBINE] = SKINCOLOR_BLUEBELL,
	[CR.RINGS.HYPER] = SKINCOLOR_SKY
}, {__index = function() return CR.COLORS[CR.RINGS.NONE] end})

CR.HUD_COLORS = setmetatable({
	[CR.RINGS.COMBINE] = SKINCOLOR_BLUE
}, {__index = CR.COLORS})

CR.FLICKER_RATE = TICRATE/2

CR.BURST_FUSE = 5*TICRATE

CR.VALUE_BITS = 14
CR.VALUE_MASK = (1 << CR.VALUE_BITS) - 1
CR.FLAG_SPHERES = 1 << (CR.VALUE_BITS)
CR.TYPE_SHIFT = (CR.VALUE_BITS + 1)

// ---------
// variables
// ---------

CR.cv_timetic = CV_FindVar("timerres")

CR.combineMobjs = {}

// -------
// actions
// -------

function CR.AwardCombineRing(actor)
	local mo = actor.target
	local player = mo and mo.player

	if not player
		return
	end

	local info = actor.info
	local overlay = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_OVERLAY)

	overlay.target = mo
	overlay.spritexscale = 4 * $ / 3
	overlay.spriteyscale = 4 * $ / 3
	overlay.state = S_SPRK1
	overlay.color = actor.color
	overlay.colorized = overlay.color ~= SKINCOLOR_NONE

	player.combineRing = info.painchance
	S_StartSound(mo, info.seesound)
end

// ------
// sounds
// ------

sfxinfo[sfx_cdfm31].caption = "Combine Ring"
sfxinfo[sfx_cdfm66].caption = "Hyper Ring"

// ------
// states
// ------

SafeFreeslot("SPR_TVCR",
	"S_COMBINERING_BOX", "S_COMBINERING_GOLDBOX",
	"S_COMBINERING_ICON1", "S_COMBINERING_ICON2")

states[S_COMBINERING_BOX] = {
	sprite = SPR_TVCR,
	frame = A,
	tics = 2,
	nextstate = S_BOX_FLICKER
}

states[S_COMBINERING_GOLDBOX] = {
	sprite = SPR_TVCR,
	frame = B,
	tics = 2,
	action = A_GoldMonitorSparkle,
	nextstate = S_GOLDBOX_FLICKER
}

states[S_COMBINERING_ICON1] = {
	sprite = SPR_TVCR,
	frame = FF_ANIMATE|C,
	tics = 18,
	var1 = 3,
	var2 = 4,
	nextstate = S_COMBINERING_ICON2
}

states[S_COMBINERING_ICON2] = {
	sprite = SPR_TVCR,
	frame = C,
	tics = 18,
	action = CR.AwardCombineRing
}

// -------
// objects
// -------

SafeFreeslot("MT_COMBINERING_BOX", "MT_COMBINERING_GOLDBOX", "MT_COMBINERING_ICON",
	"MT_HYPERRING_BOX", "MT_HYPERRING_GOLDBOX", "MT_HYPERRING_ICON")

mobjinfo[MT_COMBINERING_BOX] = {
	--$Name Combine Ring
	--$Sprite TVCRA0
	--$Category SUGOI Powerups
	--$Flags1Text Run linedef executor on pop
	--$Flags4Text Random (Strong)
	--$Flags8Text Random (Weak)
	doomednum = 3034,
	spawnstate = S_COMBINERING_BOX,
	painstate = S_COMBINERING_BOX,
	deathstate = S_BOX_POP1,
	deathsound = sfx_pop,
	spawnhealth = 1,
	reactiontime = 8,
	speed = 1,
	radius = 18*FRACUNIT,
	height = 40*FRACUNIT,
	mass = 100,
	damage = MT_COMBINERING_ICON,
	flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR,
	painchance = CR.RINGS.COMBINE
}

mobjinfo[MT_HYPERRING_BOX] = {
	--$Name Hyper Ring
	--$Sprite TVCRA0
	--$Category SUGOI Powerups
	--$Flags1Text Run linedef executor on pop
	--$Flags4Text Random (Strong)
	--$Flags8Text Random (Weak)
	doomednum = 3035,
	spawnstate = S_COMBINERING_BOX,
	painstate = S_COMBINERING_BOX,
	deathstate = S_BOX_POP1,
	deathsound = sfx_pop,
	spawnhealth = 1,
	reactiontime = 8,
	speed = 1,
	radius = 18*FRACUNIT,
	height = 40*FRACUNIT,
	mass = 100,
	damage = MT_HYPERRING_ICON,
	flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR,
	painchance = CR.RINGS.HYPER
}

mobjinfo[MT_COMBINERING_GOLDBOX] = {
	--$Name Combine Ring (Respawn)
	--$Sprite TVCRB0
	--$Category SUGOI Powerups
	--$Flags1Text Run linedef executor on pop
	doomednum = 3036,
	spawnstate = S_COMBINERING_GOLDBOX,
	painstate = S_COMBINERING_GOLDBOX,
	deathstate = S_GOLDBOX_OFF1,
	deathsound = sfx_pop,
	attacksound = sfx_monton,
	spawnhealth = 1,
	reactiontime = 8,
	radius = 20*FRACUNIT,
	height = 44*FRACUNIT,
	mass = 100,
	damage = MT_COMBINERING_ICON,
	flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR|MF_GRENADEBOUNCE,
	painchance = CR.RINGS.COMBINE
}

mobjinfo[MT_HYPERRING_GOLDBOX] = {
	--$Name Hyper Ring (Respawn)
	--$Sprite TVCRB0
	--$Category SUGOI Powerups
	--$Flags1Text Run linedef executor on pop
	doomednum = 3037,
	spawnstate = S_COMBINERING_GOLDBOX,
	painstate = S_COMBINERING_GOLDBOX,
	deathstate = S_GOLDBOX_OFF1,
	deathsound = sfx_pop,
	attacksound = sfx_monton,
	spawnhealth = 1,
	reactiontime = 8,
	radius = 20*FRACUNIT,
	height = 44*FRACUNIT,
	mass = 100,
	damage = MT_HYPERRING_ICON,
	flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR|MF_GRENADEBOUNCE,
	painchance = CR.RINGS.HYPER
}

mobjinfo[MT_COMBINERING_ICON] = {
	spawnstate = S_COMBINERING_ICON1,
	spawnhealth = 1,
	seesound = sfx_cdfm31,
	reactiontime = 8,
	speed = 2*FRACUNIT,
	radius = 8*FRACUNIT,
	height = 14*FRACUNIT,
	mass = 100,
	damage = 62*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY|MF_BOXICON,
	painchance = CR.RINGS.COMBINE
}

mobjinfo[MT_HYPERRING_ICON] = {
	spawnstate = S_COMBINERING_ICON1,
	spawnhealth = 1,
	seesound = sfx_cdfm66,
	reactiontime = 8,
	speed = 2*FRACUNIT,
	radius = 8*FRACUNIT,
	height = 14*FRACUNIT,
	mass = 100,
	damage = 62*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY|MF_BOXICON,
	painchance = CR.RINGS.HYPER
}

// ---------
// functions
// ---------

function CR.ColorMobj(mo)
	mo.color = CR.COLORS[mo.info.painchance] or $
end

function CR.GivePlayerSpheres(player, num_spheres) // I was sort of surprised to see P_GivePlayerSpheres not exposed but I guess I'm probably the first person to ever need it LOL
	if num_spheres == 0
		return
	end

	if player.bot and player.bot ~= BOT_MPAI
		if BOT_MPAI
			if player.botleader
				player = player.botleader
			end
		else
			player = players[0]
		end
	end

	player.spheres = max(min($ + num_spheres, 9999), 0)
end

function CR.OnFlingItemSpawn(mo)
	if CR.flungMobjs
		table.insert(CR.flungMobjs, mo)
	end
end

function CR.OnFlingItemDeath(mo, _, src)
	if not mo.valid
	or not mo.combineRingValue
	or not src
	or not src.valid
	or not src.player
		return
	end

	local value = mo.combineRingValue
	local func

	if value & CR.FLAG_SPHERES
		func = CR.GivePlayerSpheres
	else
		func = P_GivePlayerRings
	end

	func(src.player, (value & CR.VALUE_MASK) - 1) // subtract 1 because the mobj itself will give 1
end

function CR.OnFlingItemFuse(mo)
	local value = mo.combineRingValue or 0

	if (value >> CR.TYPE_SHIFT) ~= CR.RINGS.COMBINE
	or mo.health <= 0
		return
	end

	local numItems = value & CR.VALUE_MASK
	local type = mo.type
	local target = mo.target
	local scale = mo.destscale - mo.scalespeed
	local z = mo.z + (mo.height - FixedMul(mobjinfo[type].height, scale))/2
	local flip = mo.eflags & MFE_VERTICALFLIP
	local angle = mo.angle
	local rotate, threshold

	// cap number of rings spawned
	if not (value & CR.FLAG_SPHERES)
		numItems = min($, 32)
	end

	// calculate rotation angle
	rotate = FixedAngle(360*FRACUNIT/numItems)

	if numItems > 15
		threshold = numItems/2
		rotate = $ * 2
	else
		threshold = INT32_MAX
	end

	// calculate thrust

	for i = 1, numItems
		local item = P_SpawnMobj(mo.x, mo.y, z, type)

		item.target = target
		item.scale = scale

		if value & CR.FLAG_SPHERES
			local ns = FixedMul(((i*FRACUNIT)/16)+2*FRACUNIT, scale)
			P_InstaThrust(item, angle, ns)
			P_SetObjectMomZ(item, 8*FRACUNIT, false)
			item.fuse = 20*TICRATE
			item.state = mo.state
		else
			local momXY, momZ

			if i > threshold
				momXY = 3*scale
				momZ = 4*FRACUNIT
			else
				momXY = 2*scale
				momZ = 3*FRACUNIT
			end

			P_InstaThrust(item, angle, momXY)
			P_SetObjectMomZ(item, momZ, false)

			if i & 1
				P_SetObjectMomZ(item, momZ, true)
			end

			item.fuse = 8*TICRATE
		end

		if flip
			item.momz = -$
		end

		angle = $ + rotate
	end

	local thok = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_THOK)
	thok.state = S_INVISIBLE
	thok.fuse = 2*TICRATE
	P_PlayRinglossSound(thok)
end

function CR.UpdateCombineMobj(mo)
	local value = mo.valid and mo.combineRingValue

	if not value
		return false
	end

	if mo.health <= 0
		mo.flags2 = $ & ~MF2_DONTDRAW
		mo.color = SKINCOLOR_NONE
		mo.colorized = false
		return false
	end

	local flicker = mo.fuse % CR.FLICKER_RATE

	if flicker == 3
		mo.color = CR.COLORS[value >> CR.TYPE_SHIFT]
		mo.colorized = true
	elseif flicker == 1
		mo.color = SKINCOLOR_NONE
		mo.colorized = false
	end

	return true
end

function CR.SpillCombineRings(player, angle)
	local ringType = player.combineRing

	// huh? why are we here
	if not ringType
		return false
	end

	local value
	local flags = ringType << CR.TYPE_SHIFT

	// make sure we have something to spill
	if player.powers[pw_carry] == CR_NIGHTSFALL
		if player.spheres <= 0
			return false
		end
		value = player.spheres
		flags = $ | CR.FLAG_SPHERES
	else
		if player.rings <= 0
			return false
		end
		value = player.rings
	end

	local numToSpawn, scale, fuse
	local mo = player.mo
	local lossThrust = FRACUNIT + FixedDiv(player.losstime << FRACBITS, (10*TICRATE) << FRACBITS)
	local thrustH = FixedMul(3 * lossThrust, mo.scale)
	local thrustZ = P_MobjFlip(mo) * 4 * lossThrust
	local realMomX, realMomY = mo.momx, mo.momy

	// temporarily modify player variables
	mo.momx = 4 * cos(angle)
	mo.momy = 4 * sin(angle)

	// determine how many items to spill
	if ringType == CR.RINGS.HYPER
		numToSpawn = min(max(value >> 2, 1), 8)
		value = $ / numToSpawn
		scale = 2*FRACUNIT
	else
		numToSpawn = 1
		scale = 3*FRACUNIT
		fuse = CR.BURST_FUSE
	end

	value = $ | flags

	// spill the items!
	CR.flungMobjs = {}
	P_PlayerRingBurst(player, numToSpawn)

	for i, mo in ipairs(CR.flungMobjs)
		local noClip = mo.flags & MF_NOCLIP

		table.insert(CR.combineMobjs, mo)
		mo.combineRingValue = value

		mo.spritexscale = FixedMul($, scale)
		mo.spriteyscale = FixedMul($, scale)

		mo.flags = $ | MF_NOCLIP
		mo.radius = FixedMul($, scale)
		mo.height = FixedMul($, scale)
		mo.flags = $ & ~MF_NOCLIP | noClip

		P_InstaThrust(mo, R_PointToAngle2(0, 0, mo.momx, mo.momy), thrustH)
		P_SetObjectMomZ(mo, thrustZ, false)
		if (i & 1)
			P_SetObjectMomZ(mo, thrustZ, true)
		end

		if fuse ~= nil
			mo.fuse = fuse
		end
	end

	CR.flungMobjs = nil

	// reset temporarily modified player variables
	mo.momx, mo.momy = realMomX, realMomY

	return true
end

// call with a player during MobjDamage to set that player as the last damaged player
// call with nil to forget the last damaged player (this may be useful to you if your script conflicts with Combine Ring)
function CR.OnPlayerDamage(player, inf)
	if player == nil // no player? obviously no rings will be dropped
	or not player.combineRing // obviously no need to check anything else if this player doesn't have the powerup
		return
	end

	// The goal at this point is to eliminate as many possible situations where the player would NOT drop rings as we can.
	// The only circumstance we can't feasibly account for is another mod returning true during MobjDamage to override ring spilling

	local powers = player.powers

	if powers[pw_carry] == CR_NIGHTSMODE // rings aren't dropped in NiGHTS mode
	or powers[pw_shield] // presumably no rings will be dropped with any of these powers
	or powers[pw_flashing]
	or powers[pw_super]
	or powers[pw_invulnerability]
	or player.bot and player.bot ~= BOT_MPAI and not ultimatemode // bots don't usually drop rings
		return
	end

	local mo = player.mo
	local angle

	if inf and inf.valid
		if inf.type == MT_WALLSPIKE
			angle = inf.angle
		else
			angle = R_PointToAngle2(inf.x - inf.momx, inf.y - inf.momy, mo.x - mo.momx, mo.y - mo.momy)
		end
	elseif mo.momx or mo.momy
		angle = R_PointToAngle2(mo.momx, mo.momy, 0, 0)
	else
		angle = player.drawangle // I'm just copying from source, but shouldn't this add 180?? lol
	end

	if CR.SpillCombineRings(player, angle)
		// this is a bit of a hack, but this way we can have the game call P_ShieldDamage for us B)
		powers[pw_shield] = ($ & ~SH_NOSTACK) | SH_PITY

		if powers[pw_carry] == CR_NIGHTSFALL
			player.spheres = 0
		else
			player.rings = 0
		end
	end
	player.combineRing = CR.RINGS.NONE
end

function CR.DrawCombineRing(v, player)
	local ringType = player.combineRing

	if not ringType
	or not hud.enabled("rings")
	or not player.mo
	or player.mo.state == S_OBJPLACE_DUMMY
	or (maptol & TOL_NIGHTS) or G_IsSpecialStage(gamemap)
		return
	end

	local mania = CR.cv_timetic.value == 2
	local zero = v.cachePatch("STTNUM0")
	local width, height = zero.width, zero.height
	local colorMap = v.getColormap(TC_DEFAULT, CR.COLORS[ringType])
	local colorizedMap = v.getColormap(TC_RAINBOW, CR.HUD_COLORS[ringType])

	local coords, numRings, x, y, flags

	if CR.cv_timetic.value == 2
		coords = hudinfo[HUD_RINGSNUMTICS]
	else
		coords = hudinfo[HUD_RINGSNUM]
	end

	if player.rings < 0
	or player.playerstate == PST_REBORN
		numRings = 0
	else
		numRings = player.rings
	end

	flags = coords.f|V_PERPLAYER|V_HUDTRANS
	x, y = coords.x, coords.y

	// draw colorized rings value

	repeat
		x = $ - width
		v.draw(x, y, v.cachePatch("STTNUM" .. (numRings % 10)), flags, colorizedMap)
		numRings = $ / 10
	until numRings == 0

	// draw icon
	local patch = v.cachePatch("COMBINERING")

	if mania
		x = $ - patch.width - 2
	else
		x = coords.x + 2
	end

	y = $ + height/2 - patch.height/2

	v.draw(x, y, patch, flags, colorMap)
end

// -----
// hooks
// -----

// level
addHook("MapChange", function()
	CR.combineMobjs = {}
end)

addHook("NetVars", function(net)
	CR.combineMobjs = net(CR.combineMobjs)
end)

addHook("ThinkFrame", function()
	for i = #CR.combineMobjs, 1, -1
		if not CR.UpdateCombineMobj(CR.combineMobjs[i])
			table.remove(CR.combineMobjs, i)
			continue
		end
	end
end)

// monitors
for _, type in ipairs({MT_COMBINERING_BOX, MT_COMBINERING_GOLDBOX, MT_COMBINERING_ICON, MT_HYPERRING_BOX, MT_HYPERRING_GOLDBOX, MT_HYPERRING_ICON})
	addHook("MobjSpawn", CR.ColorMobj, type)
end

// flingitems
for _, type in ipairs({MT_RING, MT_COIN, MT_NIGHTSCHIP, MT_BLUESPHERE})
	type = mobjinfo[$].reactiontime
	if type == MT_NULL then continue end
	addHook("MobjSpawn", CR.OnFlingItemSpawn, type)
	addHook("MobjDeath", CR.OnFlingItemDeath, type)
	addHook("MobjFuse", CR.OnFlingItemFuse, type)
end

// players
addHook("PlayerSpawn", function(player)
	player.combineRing = CR.RINGS.NONE
end)

addHook("MobjDeath", function(mo)
	local player = mo.player
	if player
		player.combineRing = CR.RINGS.NONE
	end
end, MT_PLAYER)

addHook("MobjDamage", function(mo, inf, _, _, damageType)
	// killing players won't drop rings
	// ...EXCEPT in match, but in that situation it occurs before MobjDamage is called, so we still can't detect a combine ring drop :(
	if not (damageType & DMG_DEATHMASK)
		return CR.OnPlayerDamage(mo.player, inf)
	end
end, MT_PLAYER)

hud.add(CR.DrawCombineRing)
