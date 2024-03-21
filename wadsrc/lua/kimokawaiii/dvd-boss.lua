-- LUA_BOSS

-- SRB2DVD boss follow up!
-- This script is kinda messy, the boss is set up in quite a hacky way since the gameplay itself also changes quite a bit.

/*
	IMPORTANT:
	*Everything in this Lua lump is LOL XD! By VincyTM
	*Kanade Tachibana is STILL the best waifu.
*/

-- monitorsplus HU_ library (sorta)
local BASEVIDWIDTH = 320
local BASEVIDHEIGHT = 200
local function drawScreenWidePatch(v, patch, flag, colormap, xoffs, yoffs)
	flag = $ or 0
	-- simplify stuff for green res + make sure it doesnt break w/ transparency flags.
	if (v.width()*10)/v.height() == 16
		v.drawScaled((0+(xoffs or 0)-1)*FRACUNIT, (0+(yoffs or 0)-1)*FRACUNIT, FRACUNIT*10/9, patch, flag, colormap)
		return
	end

	local patchScale = FixedDiv(BASEVIDWIDTH*FRACUNIT, patch.width*FRACUNIT)
	local xOffset = 0
	local yOffset = (BASEVIDHEIGHT*FRACUNIT - FixedMul(patch.height*FRACUNIT, patchScale)) / 2 -- centre it vertically

	-- Scale the patch so that it always fills the entire screen
	local sxf = FixedDiv(v.width()*FRACUNIT, BASEVIDWIDTH*FRACUNIT)
	local syf = FixedDiv(v.height()*FRACUNIT, BASEVIDHEIGHT*FRACUNIT)
	local oldPatchScale,newPatchScale
	if sxf > syf then
		oldPatchScale = (v.height() / BASEVIDHEIGHT)*FRACUNIT
	else
		oldPatchScale = (v.width() / BASEVIDWIDTH)*FRACUNIT
	end
	newPatchScale = sxf
	patchScale = FixedMul(patchScale, FixedDiv(newPatchScale, oldPatchScale))

	-- need to offset if scaled
	-- someone please end my suffering
	local patchRealHeight = FixedMul(FixedMul(patch.height*FRACUNIT, patchScale), oldPatchScale)
	yOffset = (v.height()*FRACUNIT - patchRealHeight) / 2
	yOffset = FixedDiv(yOffset, oldPatchScale)

	v.drawScaled(xOffset+(xoffs or 0)*FRACUNIT, yOffset+(yoffs or 0)*FRACUNIT, patchScale, patch, V_SNAPTOTOP|V_SNAPTOLEFT|flag, colormap)
end

local function HU_explosion(p)
	p.HU_explosion = true
	p.HU_explosiontimer = 0
end

local function HU_fade(p)
	p.HU_fade = true
	p.HU_fadetimer = 0
end

local function HU_explosionHandler(p)
	if p.HU_explosion
		p.HU_explosiontimer = $+1
		if p.HU_explosiontimer >= 40
			p.HU_explosiontimer = nil
			p.HU_explosion = nil
			HU_fade(p)
		end
	end
end

local function HU_fadeHandler(p)
	if p.HU_fade
		p.HU_fadetimer = $+1
		if p.HU_fadetimer >= 16
			p.HU_fadetimer = nil
			p.HU_fade = nil
		end
	end
end

local function HU_handler(p)
	HU_fadeHandler(p)
	HU_explosionHandler(p)
end

local function HU_explosionDrawer(v, p, c)
	if not p.HU_explosion return end
	local t = p.HU_explosiontimer
	local patch = t <= 1 and "MEGIDO1" or t <= 3 and "MEGIDO2" or t <= 5 and "MEGIDO3" or "MEGIDO4"
	drawScreenWidePatch(v, v.cachePatch(patch))
end

local function HU_fadeDrawer(v, p, c)
	if not p.HU_fade return end
	local t = p.HU_fadetimer
	local tflag = t <= 3 and 0 or t <= 6 and V_20TRANS or t <= 9 and V_40TRANS or t <= 12 and V_60TRANS or V_80TRANS
	drawScreenWidePatch(v, v.cachePatch("MEGIDO4"), tflag)
end

freeslot("MT_SUPERDVD", "SPR_DSCN")
mobjinfo[MT_SUPERDVD] = {
	doomednum = -1,
    spawnstate = S_INVISIBLE,
    spawnhealth = 1000,
    radius = 16*FRACUNIT,
    height = 32*FRACUNIT,
    flags = MF_SPECIAL|MF_SOLID
}

-- boss stuff:
freeslot("sfx_khit1", "sfx_khit2")
freeslot("MT_DDBOSS")
mobjinfo[MT_DDBOSS] = {
	doomednum = -1,
    spawnstate = S_DVDSHINE1,
    spawnhealth = 1,
    reactiontime = 8,
    speed = 2*FRACUNIT,
    radius = 32*FRACUNIT,
    height = 64*FRACUNIT,
    mass = 100,
    damage = 62*FRACUNIT,
    flags = MF_SCENERY|MF_NOGRAVITY|MF_NOCLIPHEIGHT
}

-- the rocks:
for i = 1, 3
	freeslot("MT_DVDROCK"..i)
	freeslot("S_DVDROCK"..i)
end
for i = 1, 2
	freeslot("S_DVDSROCK"..i)
end

-- ufos: they're seprate since they don't need as much thinking and whatnot.

freeslot("MT_BUFO1", "MT_BUFO2")
freeslot("S_BUFO1", "S_BUFO2")
for i = 1,2
mobjinfo[MT_BUFO1+(i-1)] = {
	doomednum = -1,
    spawnstate = _G["S_BUFO"..i],
    spawnhealth = 1,
    speed = 6,
    radius = 60*FRACUNIT,
    height = 128*FRACUNIT,
    dispoffset = 0,
    mass = 100,
    flags = MF_SPECIAL|MF_NOGRAVITY
}
end
states[S_BUFO1] = {SPR_FUFO, A, -1, nil, 0, 0, S_BUFO1}
states[S_BUFO2] = {SPR_FUFO, B, -1, nil, 0, 0, S_BUFO2}
freeslot("SPR_DDKN")
for i = 1, 4
	freeslot("S_BOSS_K"..i)
end

freeslot("sfx_kinvinc")
-- do we use distortion to protect from the next attack...?
function A_DistortionCheck(mo)
	if not mo.distortion	-- don't use if we're already protecting
	and mo.preptime == nil
	and mo.health > 1
		if mo.health < 6
			mo.distortion = true
			S_StartSound(mo, sfx_kinvin)
		end
	end
end

-- distortion states
freeslot("S_DISTORTION1", "S_DISTORTION2", "S_DISTORTION3")
states[S_DISTORTION1] = {SPR_DDKN, N|TR_TRANS30, 4, nil, 0, 0, S_DISTORTION2}
states[S_DISTORTION2] = {SPR_DDKN, N|TR_TRANS60, 4, nil, 0, 0, S_DISTORTION3}
states[S_DISTORTION3] = {SPR_DDKN, N|TR_TRANS80, 4, nil, 0, 0, S_NULL}

-- normal idle flying frames
states[S_BOSS_K1] = {SPR_DDKN, C, 70, nil, 0, 0, S_BOSS_K2}
states[S_BOSS_K2] = {SPR_DDKN, D, 3, nil, 0, 0, S_BOSS_K3}
states[S_BOSS_K3] = {SPR_DDKN, A, 2, A_DistortionCheck, 0, 0, S_BOSS_K4}
states[S_BOSS_K4] = {SPR_DDKN, B, 2, nil, 0, 0, S_BOSS_K3}

-- SLASH OBJECTS
freeslot("SPR_HSLS", "MT_KSLASHH", "MT_KSLASHV")
for i = 1, 10
	freeslot("S_KSLASHH"..i)
end
for i = 1, 10
	freeslot("S_KSLASHV"..i)
end
mobjinfo[MT_KSLASHH] = {
	doomednum = -1,
    spawnstate = S_KSLASHH1,
    spawnhealth = 1,
    speed = 6,
    radius = 1000*FRACUNIT,
    height = 24*FRACUNIT,
    dispoffset = 0,
    mass = 100,
    flags = MF_SPECIAL|MF_NOGRAVITY
}

mobjinfo[MT_KSLASHV] = {
	doomednum = -1,
    spawnstate = S_KSLASHV1,
    spawnhealth = 1,
    speed = 6,
    radius = 12*FRACUNIT,
    height = 690*FRACUNIT,
    dispoffset = 0,
    mass = 100,
    flags = MF_SPECIAL|MF_NOGRAVITY
}

local function slashSound(mo)	-- plays slashsound for player, to avoid earrape mostly
	if not S_IdPlaying(sfx_s3k66)
		S_StartSound(mo, sfx_s3k66, mo.target.plyr)
	end
end

function A_SlashSound(mo)
	slashSound(mo)
end

function A_HSlashHack(mo)	-- hack for slash hitbox dont mind me lmao
	slashSound(mo)
	-- spawn some more
	local moreslash = P_SpawnMobj(mo.x - FRACUNIT*128, mo.y, mo.z, MT_KSLASHH)
	moreslash.state = S_KSLASHH7
	moreslash.tics = 4
	moreslash.scale = FRACUNIT*2
	moreslash.flags2 = MF2_DONTDRAW
	moreslash = P_SpawnMobj(mo.x + FRACUNIT*128, mo.y, mo.z, MT_KSLASHH)
	moreslash.state = S_KSLASHH7
	moreslash.tics = 4
	moreslash.scale = FRACUNIT*2
	moreslash.flags2 = MF2_DONTDRAW
end

states[S_KSLASHH1] = {SPR_HSLS, A|FF_FULLBRIGHT, 2, nil, 0, 0, S_KSLASHH2}
states[S_KSLASHH2] = {SPR_HSLS, B|FF_FULLBRIGHT, 2, A_PlaySound, sfx_s3k5c, 0, S_KSLASHH3}
states[S_KSLASHH3] = {SPR_HSLS, C|FF_FULLBRIGHT, 2, nil, 0, 0, S_KSLASHH4}
states[S_KSLASHH4] = {SPR_HSLS, A|FF_FULLBRIGHT|TR_TRANS30, 10, nil, 0, 0, S_KSLASHH5}
states[S_KSLASHH5] = {SPR_HSLS, A|FF_FULLBRIGHT|TR_TRANS60, 10, nil, 0, 0, S_KSLASHH6}
states[S_KSLASHH6] = {SPR_HSLS, D|FF_FULLBRIGHT, 2, A_HSlashHack, 0, 0, S_KSLASHH7}
states[S_KSLASHH7] = {SPR_HSLS, E|FF_FULLBRIGHT, 2, nil, 0, 0, S_KSLASHH8}
states[S_KSLASHH8] = {SPR_HSLS, F|FF_FULLBRIGHT, 2, nil, 0, 0, S_KSLASHH9}
states[S_KSLASHH9] = {SPR_HSLS, A|FF_FULLBRIGHT|TR_TRANS30, 10, nil, 0, 0, S_KSLASHH10}
states[S_KSLASHH10] = {SPR_HSLS, A|FF_FULLBRIGHT|TR_TRANS70, 10, nil, 0, 0, S_NULL}

states[S_KSLASHV1] = {SPR_HSLS, G|FF_FULLBRIGHT, 2, nil, 0, 0, S_KSLASHV2}
states[S_KSLASHV2] = {SPR_HSLS, H|FF_FULLBRIGHT, 2, A_PlaySound, sfx_s3k5c, 0, S_KSLASHV3}
states[S_KSLASHV3] = {SPR_HSLS, I|FF_FULLBRIGHT, 2, nil, 0, 0, S_KSLASHV4}
states[S_KSLASHV4] = {SPR_HSLS, G|FF_FULLBRIGHT|TR_TRANS30, 10, nil, 0, 0, S_KSLASHV5}
states[S_KSLASHV5] = {SPR_HSLS, G|FF_FULLBRIGHT|TR_TRANS60, 10, nil, 0, 0, S_KSLASHV6}
states[S_KSLASHV6] = {SPR_HSLS, J|FF_FULLBRIGHT, 2, A_SlashSound, sfx_s3k66, 0, S_KSLASHV7}
states[S_KSLASHV7] = {SPR_HSLS, K|FF_FULLBRIGHT, 2, nil, 0, 0, S_KSLASHV8}
states[S_KSLASHV8] = {SPR_HSLS, L|FF_FULLBRIGHT, 2, nil, 0, 0, S_KSLASHV9}
states[S_KSLASHV9] = {SPR_HSLS, G|FF_FULLBRIGHT|TR_TRANS30, 10, nil, 0, 0, S_KSLASHV10}
states[S_KSLASHV10] = {SPR_HSLS, G|FF_FULLBRIGHT|TR_TRANS70, 10, nil, 0, 0, S_NULL}


-- SLASH FRAMES
freeslot("S_KANADE_SLASH0", "S_KANADE_SLASH1", "S_KANADE_SLASH2")

function A_KanadeSlash(mo)
	local tgt = mo.target
	if not tgt return end	-- we have a problem, where has our player gone???

	local overdrive = mo.preptime == nil and mo.health < 5

	-- 3 kinds of slash, directly on player, 1 in center or 2 on outer edges of the screen in height
	local stype = P_RandomRange(0,2)
	if not stype		-- directly attack the player:
		local slash = P_SpawnMobj(tgt.basex, tgt.basey, tgt.z, MT_KSLASHH)
		slash.scale = FRACUNIT*2
		slash.angle = tgt.angle
		slash.target = tgt
		if overdrive
			slash = P_SpawnMobj(tgt.basex, tgt.basey+FRACUNIT*64, tgt.z, MT_KSLASHH)
			slash.scale = FRACUNIT*2
			slash.angle = tgt.angle
			slash.target = tgt
			slash = P_SpawnMobj(tgt.basex, tgt.basey-FRACUNIT*64, tgt.z, MT_KSLASHH)
			slash.scale = FRACUNIT*2
			slash.angle = tgt.angle
			slash.target = tgt
		end
	elseif stype == 1	-- one slash in the middle of the screen
		local slash = P_SpawnMobj(tgt.basex, tgt.basey, FRACUNIT*128, MT_KSLASHH)
		slash.scale = FRACUNIT*2
		slash.angle = tgt.angle
		slash.target = tgt
		if overdrive
			slash = P_SpawnMobj(tgt.basex, tgt.basey, FRACUNIT*168, MT_KSLASHH)
			slash.scale = FRACUNIT*2
			slash.angle = tgt.angle
			slash.target = tgt
			slash = P_SpawnMobj(tgt.basex, tgt.basey, FRACUNIT*88, MT_KSLASHH)
			slash.scale = FRACUNIT*2
			slash.angle = tgt.angle
			slash.target = tgt
		end
	elseif stype == 2	-- 2 slashes on screen top/bottom edges
		local slash = P_SpawnMobj(tgt.basex, tgt.basey, FRACUNIT*32, MT_KSLASHH)
		slash.scale = FRACUNIT*2
		slash.angle = tgt.angle
		slash.target = tgt
		slash = P_SpawnMobj(tgt.basex, tgt.basey, FRACUNIT*216, MT_KSLASHH)
		slash.scale = FRACUNIT*2
		slash.angle = tgt.angle
		slash.target = tgt
		if overdrive
			slash = P_SpawnMobj(tgt.basex, tgt.basey, FRACUNIT*64, MT_KSLASHH)
			slash.scale = FRACUNIT*2
			slash.angle = tgt.angle
			slash.target = tgt
			slash = P_SpawnMobj(tgt.basex, tgt.basey, FRACUNIT*184, MT_KSLASHH)
			slash.scale = FRACUNIT*2
			slash.angle = tgt.angle
			slash.target = tgt
		end
	end

end

states[S_KANADE_SLASH0] = {SPR_DDKN, J, 35, nil, 0, 0, S_KANADE_SLASH1}
states[S_KANADE_SLASH1] = {SPR_DDKN, L, 2, A_KanadeSlash, 0, 0, S_KANADE_SLASH2}
states[S_KANADE_SLASH2] = {SPR_DDKN, M, 35, nil, 0, 0, S_BOSS_K3}

-- TAKEOFF + DOWNWARD SLASH:
freeslot("S_KANADE_TAKEOFF1", "S_KANADE_TAKEOFF2", "S_KANADE_DSLASH1", "S_KANADE_DSLASH2", "S_KANADE_DSLASH3")

-- take off for dive slash
function A_TakeOff(mo)
	mo.flags = MF_NOCLIPHEIGHT	-- go beyond intended limits for vertical height
	-- sound + spawn feathers???
	S_StartSound(mo, sfx_beflap)
	P_SetObjectMomZ(mo, FRACUNIT*60)
end

states[S_KANADE_TAKEOFF1] = {SPR_DDKN, G, 2, nil, 0, 0, S_KANADE_TAKEOFF2}
states[S_KANADE_TAKEOFF2] = {SPR_DDKN, H, TICRATE, A_TakeOff, 0, 0, S_KANADE_DSLASH1}

-- Dive Slash: teleport back to correct place, start going down, play a sound
function A_DiveSlashInit(mo)
	P_SetOrigin(mo, mo.x, mo.target.basey, 512*FRACUNIT)
	P_SetObjectMomZ(mo, -FRACUNIT*80)
	S_StartSound(mo.target, sfx_belnch)
end

-- Dive Slash: Spawn the slashes
function A_DiveSlash(mo)
	-- spawn slashes
	local tgt = mo.target
	local overdrive = mo.preptime == nil and mo.health < 5
	local stype = P_RandomRange(0, 1)
	if not stype
		local slash = P_SpawnMobj(tgt.basex+FRACUNIT*80, tgt.basey, 0, MT_KSLASHV)
		slash.scale = FRACUNIT*2
		slash.angle = tgt.angle
		slash.target = tgt
		slash = P_SpawnMobj(tgt.basex-FRACUNIT*80, tgt.basey, 0, MT_KSLASHV)
		slash.scale = FRACUNIT*2
		slash.angle = tgt.angle
		slash.target = tgt
		if overdrive
			slash = P_SpawnMobj(tgt.basex-FRACUNIT*210, tgt.basey, 0, MT_KSLASHV)
			slash.scale = FRACUNIT*2
			slash.angle = tgt.angle
			slash.target = tgt
			slash = P_SpawnMobj(tgt.basex+FRACUNIT*210, tgt.basey, 0, MT_KSLASHV)
			slash.scale = FRACUNIT*2
			slash.angle = tgt.angle
			slash.target = tgt
			slash = P_SpawnMobj(tgt.basex-FRACUNIT*140, tgt.basey, 0, MT_KSLASHV)
			slash.scale = FRACUNIT*2
			slash.angle = tgt.angle
			slash.target = tgt
			slash = P_SpawnMobj(tgt.basex+FRACUNIT*140, tgt.basey, 0, MT_KSLASHV)
			slash.scale = FRACUNIT*2
			slash.angle = tgt.angle
			slash.target = tgt
		end
	else
		local slash = P_SpawnMobj(tgt.x, tgt.basey, 0, MT_KSLASHV)
		slash.scale = FRACUNIT*2
		slash.flags = $|MF_NOCLIPHEIGHT
		slash.angle = tgt.angle
		slash.target = tgt
		if overdrive
			local slash = P_SpawnMobj(tgt.x+FRACUNIT*64, tgt.basey, 0, MT_KSLASHV)
			slash.scale = FRACUNIT*2
			slash.flags = $|MF_NOCLIPHEIGHT
			slash.angle = tgt.angle
			slash.target = tgt
			local slash = P_SpawnMobj(tgt.x-FRACUNIT*64, tgt.basey, 0, MT_KSLASHV)
			slash.scale = FRACUNIT*2
			slash.flags = $|MF_NOCLIPHEIGHT
			slash.angle = tgt.angle
			slash.target = tgt
		end
	end
end

-- Dive Slash: end the attack (snap back to base coords, flash the screen for lazy tp)
function A_DiveSlashEnd(mo)
	mo.flags = mobjinfo[MT_DDBOSS].flags
	P_SetOrigin(mo, mo.basex, mo.basey, mo.basez)
	mo.momz = 0
	P_FlashPal(mo.target.plyr, 1, 4)
	mo.nattacktime = TICRATE*3
end

states[S_KANADE_DSLASH1] = {SPR_DDKN, I, TICRATE/2, A_DiveSlashInit, 0, 0, S_KANADE_DSLASH2}
states[S_KANADE_DSLASH2] = {SPR_DDKN, I, 26, A_DiveSlash, 0, 0, S_KANADE_DSLASH3}
states[S_KANADE_DSLASH3] = {SPR_DDKN, I, 3, A_DiveSlashEnd, 0, 0, S_BOSS_K3}

-- Howling!

freeslot("sfx_howl1", "sfx_howl2", "MT_HOWLING", "SPR_HOWL", "S_HOWLING1", "S_HOWLING2", "S_HOWLING3", "S_HOWLING4", "S_HOWLING5")
mobjinfo[MT_HOWLING] = {
	doomednum = -1,
    spawnstate = S_HOWLING1,
    spawnhealth = 1,
    speed = 6,
    radius = 45*FRACUNIT,
    height = 90*FRACUNIT,
    dispoffset = 0,
    mass = 100,
    flags = MF_SPECIAL|MF_NOGRAVITY
}
states[S_HOWLING1] = {SPR_HOWL, A, TICRATE/4, nil, 0, 0, S_HOWLING2}
states[S_HOWLING2] = {SPR_HOWL, B, TICRATE/4, nil, 0, 0, S_HOWLING3}
states[S_HOWLING3] = {SPR_HOWL, C, TICRATE/4, nil, 0, 0, S_HOWLING4}
states[S_HOWLING4] = {SPR_HOWL, C|TR_TRANS30, TICRATE/4, nil, 0, 0, S_HOWLING5}
states[S_HOWLING5] = {SPR_HOWL, C|TR_TRANS60, TICRATE/4, nil, 0, 0, S_NULL}


-- spawn the soundwaves
function A_Howling(mo)
	mo.nattacktime = mo.preptime == nil and TICRATE*4 or TICRATE*6
	if not mo.howling	-- attack wasn't used yet
		mo.howling = 1
		S_StartSound(mo.target, sfx_howl1)
		P_FlashPal(mo.target.plyr, 1, 4)
		P_StartQuake(FRACUNIT*40, 7)
	end
	mo.target.asteroid_dist = $-mo.target.spd/2
	if mo.howling < TICRATE
		local h = P_SpawnMobj(mo.x, mo.y, mo.z+FRACUNIT*24, MT_HOWLING)
		h.color = SKINCOLOR_AZURE
		h.target = mo.target
		A_HomingChase(h, FRACUNIT*19)
		h.scale = FRACUNIT*3/2
	end
	mo.howling = $+ (mo.preptime~=nil and 2 or 1)
	if mo.howling > 4 and mo.howling%2 and mo.howling < TICRATE
		S_StartSound(mo.target, sfx_howl2)
	elseif mo.howling > TICRATE*3/5
		mo.state = S_BOSS_K3
		mo.howling = nil
	end
end

freeslot("S_KANADE_HOWLING1", "S_KANADE_HOWLING2", "S_KANADE_HOWLING3")
states[S_KANADE_HOWLING1] = {SPR_DDKN, O, TICRATE, nil, 0, 0, S_KANADE_HOWLING2}
states[S_KANADE_HOWLING2] = {SPR_DDKN, P, 2, A_Howling, 0, 0, S_KANADE_HOWLING3}
states[S_KANADE_HOWLING3] = {SPR_DDKN, Q, 2, nil, 0, 0, S_KANADE_HOWLING2}

freeslot("SPR_DDHM", "S_KANADE_HARMONICS")

function A_HarmonicsHandler(mo)
	mo.distortion = true	-- always invincible using distortion
	mo.frame = A + (leveltime%4 /2)	-- cycle between frames A & B
	if not mo.htime
		mo.htime = 0
	end
	mo.htime = $+1

	if not mo.hclones and mo.htime and mo.htime > 0	-- spawn the clones
		mo.hclones = {}

		for i = 1, 2 do
			local c = P_SpawnMobj(mo.x, mo.y, mo.z, MT_DDBOSS)
			c.health = 1
			c.maxhealth = 1
			c.state = S_BOSS_K4
			c.tics = 99999
			c.momx = i == 1 and FRACUNIT*3 or -FRACUNIT*3
			c.preptime = TICRATE*3
			mo.hclones[#mo.hclones+1] = c
		end
	end
	if not mo.hclones return end

	if not #mo.hclones	-- all clones are doieded
		mo.state = S_BOSS_K3
		mo.didharmonics = true	-- don't go back to doing harmonics that'd be retarded
		mo.nattacktime = TICRATE*2
		return
	end

	-- handles what the clones try to do
	local boomcount = 0
	for k,v in ipairs(mo.hclones)
		if mo.target.boosts
		and k == 1
		and v.valid
		and (v.state < S_KANADE_TAKEOFF1 or v.state > S_KANADE_DSLASH3)
		and not v.preptime
			if leveltime%2
				local ret = P_SpawnMobj(v.x, v.y - FRACUNIT*8, v.z, MT_THOK)
				ret.sprite = SPR_TARG
				ret.frame = (leveltime%12)/2 | TR_TRANS50
				ret.fuse = 1
				ret.scale = FRACUNIT*2
			end
		end
		v.sprite = SPR_DDHM
		if v.preptime
			v.frame = R|FF_FULLBRIGHT
			if leveltime%2
				v.flags2 = $|MF2_DONTDRAW
			else
				v.flags2 = $ & ~MF2_DONTDRAW
			end
			v.preptime = $-1
			if v.preptime == 1
				v.momx = 0
				v.state = S_BOSS_K3
				v.sprite = SPR_DDHM
				v.preptime = 0
				v.flags2 = $ & ~MF2_DONTDRAW
				v.target = mo.target
				v.nattacktime = TICRATE*2
				v.basex, v.basey, v.basez = v.x, v.y, v.z
			end
			continue
		end

		if v.nattacktime
			if mo.htime < TICRATE*70
				v.nattacktime = $-1
			else
				-- sonic rotation
				if not v.boomtimer
					P_FlashPal(v.target.plyr, 1, 4)
					P_SetOrigin(v, v.basex, v.basey, v.basez)
					if k == 1
						S_StartSound(v.target, sfx_s3k53)
					end
					v.boomtimer = 1
				end
				v.state = S_BOSS_K3
				v.tics = -1
				v.frame = 4 +leveltime%2
				v.momy = -FRACUNIT*4
				v.momz = 0
				v.boomtimer = $+1
				if v.boomtimer >= TICRATE*5 and k == 1
					HU_explosion(v.target.plyr)
					S_StartSound(v.target, sfx_bkpoof)
					if mo.hclones[2]
						P_RemoveMobj(mo.hclones[2])
					end
					if mo.hclones[1]
						P_RemoveMobj(mo.hclones[1])
					end
					mo.hclones = nil
					local r = P_SpawnMobj(mo.target.x, mo.target.y, mo.target.z, MT_TORPEDO)
					r.flags = MF_NOGRAVITY|MF_MISSILE|MF_SOLID
					r.scale = FRACUNIT*3
					mo.htime = -TICRATE*4
					break
				end
			end
		else
			v.distortion = nil
			local atk = P_RandomRange(0, 2)
			if not atk
				v.state = S_KANADE_SLASH0
			elseif atk == 1
				v.state = S_KANADE_TAKEOFF1
			else
				v.state = S_KANADE_HOWLING1
			end
			v.nattacktime = TICRATE*7
		end
	end
end

states[S_KANADE_HARMONICS] = {SPR_DDKN, A, 1, A_HarmonicsHandler, 0, 0, S_KANADE_HARMONICS}

local function DVD_ufoboom(mo)


	-- explosion particles...?
	for i = 1, 4
		local truc = P_SpawnMobj(mo.x+P_RandomRange(-20, 20)*FRACUNIT, mo.y+P_RandomRange(-20, 20)*FRACUNIT, mo.z+P_RandomRange(0, 60)*FRACUNIT, MT_BOOMPARTICLE)
		truc.scale = FRACUNIT
		truc.destscale = FRACUNIT*3
		truc.momx = P_RandomRange(-20, 20)*FRACUNIT
		truc.momy = P_RandomRange(-20, 20)*FRACUNIT
		truc.momz = P_RandomRange(10, 30)*FRACUNIT
		truc.tics = TICRATE*5
	end

	-- spawn the actual explosion
	for i =1,8
		local truc = P_SpawnMobj(mo.x+P_RandomRange(-20, 20)*FRACUNIT, mo.y+P_RandomRange(-20, 20)*FRACUNIT, mo.z+P_RandomRange(0, 40)*FRACUNIT, MT_BOSSEXPLODE)
		truc.scale = FRACUNIT*3
		truc.destscale = FRACUNIT*5
		truc.state = S_LESS_QUICKBOOM1
		truc.momx = P_RandomRange(-10, 10)*FRACUNIT
		truc.momy = P_RandomRange(-10, 10)*FRACUNIT
		truc.momz = P_RandomRange(0, 20)*FRACUNIT
		if i < 2	-- cool sound effect
			local mobj = P_SpawnMobj(mo.x, mo.y, mo.z, MT_THOK)
			mobj.state = S_INVISIBLE
			mobj.tics = TICRATE*10
			S_StartSound(mobj, sfx_bgxpld)
		end
	end
end

--local sizes = {74, 36, 16}

freeslot("SPR_DDRK")

function A_RockThrow(actor)
	if actor.target
		P_SpawnGhostMobj(actor)
	end
end

for i = 1, 3 do
	states[S_DVDROCK1+(i-1)] = {SPR_DDRK, i-1, 1, A_RockThrow, 0, 0, S_DVDROCK1+(i-1)}
end
states[S_DVDSROCK1] = {SPR_DDRK, D, 2, nil, 0, 0, S_DVDSROCK2}
states[S_DVDSROCK2] = {SPR_DDRK, E, 2, nil, 0, 0, S_DVDSROCK1}

-- Sal: Doing manually so that ZB stops WHINING at me.
mobjinfo[MT_DVDROCK1] = {
	doomednum = -1,
	spawnstate = S_DVDROCK1,
	spawnhealth = 1000,
	radius = 37*FRACUNIT,
	height = 69*FRACUNIT,
	flags = MF_SPECIAL|MF_NOGRAVITY
}

mobjinfo[MT_DVDROCK2] = {
	doomednum = -1,
	spawnstate = S_DVDROCK2,
	spawnhealth = 1000,
	radius = 18*FRACUNIT,
	height = 31*FRACUNIT,
	flags = MF_SPECIAL|MF_NOGRAVITY
}

mobjinfo[MT_DVDROCK3] = {
	doomednum = -1,
	spawnstate = S_DVDROCK3,
	spawnhealth = 1000,
	radius = 8*FRACUNIT,
	height = 11*FRACUNIT,
	flags = MF_SPECIAL|MF_NOGRAVITY
}

local skybox

local player_shift = 1760*FRACUNIT
-- character skin frame info
--[[
local superinfo = {
	["sonic"] = {
					fly = S_PLAY_SUPERFLY1,
					pain = S_PLAY_SUPERHIT,
					color = SKINCOLOR_SUPER1,
				},
	["tails"] = {
					fly = S_PLAY_SPD1,
					pain = S_PLAY_PAIN,
					color = SKINCOLOR_TSUPER1,
				},
	["knuckles"] = {
					fly = S_PLAY_ABL1,
					pain = S_PLAY_PAIN,
					color = SKINCOLOR_KSUPER1,
				}
}
--]]

freeslot(
	"SPR2_DBFL", "S_PLAY_DVDBOSS_FLY",
	"SPR2_DBHT", "S_PLAY_DVDBOSS_HIT"
)

// If we can have conditional SPR2 hook (ala SPR2_JUMP):
// SPR2_DBFL should use SPR2_GLID if valid, else use SPR2_DASH
// This would keep the old Knuckles definition in-tact without copied sprites.

spr2defaults[SPR2_DBFL] = SPR2_DASH
spr2defaults[SPR2_DBHT] = SPR2_STUN

states[S_PLAY_DVDBOSS_FLY] = {SPR_PLAY, SPR2_DBFL|FF_SPR2SUPER, 2, nil, 0, 0, S_PLAY_DVDBOSS_FLY}
states[S_PLAY_DVDBOSS_HIT] = {SPR_PLAY, SPR2_DBHT|FF_SPR2SUPER|FF_ANIMATE, 36, nil, 0, 4, S_PLAY_DVDBOSS_FLY}

local function GetSuperInfo(sk)
	-- Replace the old tables with SPR2 / skincolors system.
	return {
		fly = S_PLAY_DVDBOSS_FLY,
		pain = S_PLAY_DVDBOSS_HIT,
		color = skins[sk].supercolor,
	}
end

local scroll_sectors	-- used for skybox scrolling

local lastmap
addHook("MapLoad", function(n)
	scroll_sectors = {}

	-- Sal: NEVER use hud enables/disables blindly, only when confirmed that you've disabled them before
	if (lastmap != nil and mapheaderinfo[lastmap].dvdboss and not mapheaderinfo[n].dvdboss)
		sugoi.HUDShow("score", true)
		sugoi.HUDShow("time", true)
		sugoi.HUDShow("rings", true)
		return
	end

	if not (mapheaderinfo[n].dvdboss)
		return
	end

	local spawnpoint
	for c in mapthings.iterate
		if not c continue end
		if c.type ~= mobjinfo[MT_SKYBOX].doomednum
		and c.type ~= mobjinfo[MT_TELEPORTMAN].doomednum
			continue -- no
		end
		if c.type == mobjinfo[MT_SKYBOX].doomednum
			skybox = c.mobj
		else
			spawnpoint = c.mobj
		end
	end

	-- get scroll sectors for skybox scrling
	for s in sectors.iterate do
		if s.tag == 69
			table.insert(scroll_sectors, s)
			s.floorheight = FRACUNIT*32
		end
	end

	sugoi.HUDShow("score", false)
	sugoi.HUDShow("time", false)
	sugoi.HUDShow("rings", false)

	assert(spawnpoint, "Where the fuck is the spawnpoint??? (teleport destination)")

	if rawget(_G, "silv_barHUD")
		silv_barHUD = false	-- disable silver's bar HUD
	end

	-- do what's necessary for players:
	for p in players.iterate do
		if not p.mo continue end
		if (p.bot or p.spectator) continue end

		p.pflags = $|PF_FORCESTRAFE	-- yeeepppp
		p.normalspeed = 0
		p.jumpfactor = 0
		p.charability = 0

		-- start by spawning an actual player:
		local mo = P_SpawnMobj(spawnpoint.x + player_shift*#p, spawnpoint.y, spawnpoint.z + FRACUNIT*32, MT_SUPERDVD)
		mo.flags = MF_NOGRAVITY|MF_SPECIAL
		mo.angle = ANGLE_90
		p.mo.DVDmo = mo
		mo.skin = p.mo.skin

		local data = GetSuperInfo(mo.skin)
		mo.state = data.fly
		mo.data = data
		mo.color = data.color
		mo.startcolor = data.color
		mo.health = 51
		mo.basex, mo.basey = mo.x, mo.y
		mo.plyr = p
		mo.spd = FRACUNIT*TICRATE
		-- ^^ this is a fake speed.
		-- this value is used to determine our clientsided skybox scrolling speed
		-- as well as mobj momy :P
		mo.ufo_dist = 0
		mo.skybox_dist = 9999*FRACUNIT
		mo.asteroid_dist = 9999*FRACUNIT	-- used for spawning ufos / asteroids along with speed (leveltime% hacks dont work too well)

		-- now spawn an awayviewmobj etc etc
		local cam = P_SpawnMobj(spawnpoint.x + player_shift*#p + 256*cos(ANGLE_270), spawnpoint.y + 256*sin(ANGLE_270), spawnpoint.z + FRACUNIT*150, MT_THOK)
		cam.state = S_INVISIBLE
		cam.angle = ANGLE_90
		cam.tics = -1
		p.awayviewmobj = cam
		p.awayviewaiming = -ANG1*2
		p.awayviewtics = 9999999
	end
end)

addHook("MapChange", function(n)
	--if not gamemap --[[or not mapheaderinfo[gamemap].dvdboss]] return end
	if (lastmap != nil and mapheaderinfo[lastmap].dvdboss and not mapheaderinfo[n].dvdboss)
		sugoi.HUDShow("score", true)
		sugoi.HUDShow("time", true)
		sugoi.HUDShow("rings", true)
		for p in players.iterate
			p.pflags = $ & ~PF_FORCESTRAFE
			p.normalspeed = skins[p.skin].normalspeed
			p.jumpfactor = skins[p.skin].jumpfactor
			p.charability = skins[p.skin].ability
		end
	end
	if rawget(_G, "silv_barHUD") ~= nil
		silv_barHUD = true
	end
	lastmap = n
end)

addHook("NetVars", function(net)
	skybox = net(skybox)
end)

local skybox_dist = 4000
local ang_range = {250, 290}
local skybox_itms = {}	-- list containing all skybox items. used to slow them down when we get hit since friction's all bugged

local function skyboxhandler(p)
	if p ~= displayplayer return end
	if skybox and skybox.valid
		-- spawn a bunch of objects and pretend they're scenery!
		--local speedfactor = max(1, 105 - ((p.mo.DVDmo.spd/FRACUNIT)*2))
		local mo = p.mo.DVDmo
		mo.skybox_dist = $+ mo.spd

		if mo.skybox_dist >= 768*FRACUNIT
			local an = N_RandomRange(ang_range[1], ang_range[2])*ANG1
			local x = skybox.x + skybox_dist*cos(an)
			local y = skybox.y + skybox_dist*sin(an)
			local m = P_SpawnMobj(x, y, 512*FRACUNIT, MT_GARGOYLE)
			m.tics = TICRATE*10
			m.angle = an + ANGLE_180
			m.sprite = SPR_DSCN
			m.frame = N_RandomRange(0, 7)
			if m.frame < 4
				m.z = -128*FRACUNIT
			else
				m.flags2 = $|MF2_OBJECTFLIP
				m.eflags = $|MFE_VERTICALFLIP
			end
			m.scale = FRACUNIT*2
			m.friction = 0
			m.fuse = TICRATE*16
			skybox_itms[#skybox_itms+1] = m
			mo.skybox_dist = 0
		end

		for i = 1,4
			local rang = N_RandomRange(180, 340)*ANG1	-- random angle
			local randomz = N_RandomRange(10, 512)*FRACUNIT	-- abs z
			local dist = N_RandomRange(2000, 4000)
			local x, y = skybox.x + dist*cos(rang), skybox.y + dist*sin(rang)
			local prt = P_SpawnMobj(x, y, randomz, MT_DVDPARTICLE)
			prt.color = N_RandomRange(1, 24)
			prt.angle = ANGLE_90
			P_InstaThrust(prt, prt.angle, FRACUNIT*256 + ((mo.spd-(TICRATE*FRACUNIT))*2))
			prt.scale = FRACUNIT*6
		end
	end
end

-- spawn msl for mo (fake player)
local function spawnmissiles(mo)
	if not (leveltime%(TICRATE*10)) and leveltime
		-- get coords:
		local y = mo.basey + FRACUNIT*3900
		local x = mo.basex + P_RandomRange(-200, 200)*FRACUNIT
		local z = P_RandomRange(32, 222)*FRACUNIT
		local r = P_SpawnMobj(x, y, z, MT_TORPEDO)
		r.target = mo
		r.flags = MF_NOGRAVITY|MF_MISSILE|MF_SOLID
		A_HomingChase(r, FRACUNIT*64)
		r.scale = FRACUNIT*3
		S_StartSound(mo, sfx_rlaunc)
	end
end

-- spawn ufos for mo (fake player) & handle them
local function spawnufos(mo)
	if mo.ufosp == nil
		mo.ufosp = true
		mo.ufos = {}
	end

	mo.ufo_dist = $+ mo.spd

	local speedfactor = max(1, 105 - ((mo.spd/FRACUNIT)*2))

	-- Sal: I edited these to make the fight faster.
	local distvala = 3950*FRACUNIT --7900*FRACUNIT
	local distvalb = 500*FRACUNIT --1000*FRACUNIT

	--if not (leveltime%(speedfactor*6)) and leveltime
	if mo.ufo_dist >= distvala + (mo.fleeboss.maxhealth and distvalb or 0)
		mo.ufo_dist = 0
		-- get coords:
		local y = mo.basey + FRACUNIT*3900
		local x = mo.basex + P_RandomRange(-200, 200)*FRACUNIT
		local z = P_RandomRange(32, 222)*FRACUNIT
		local r = P_SpawnMobj(x, y, z, mo.ufosp and MT_BUFO1 or MT_BUFO2)
		r.momy = -FRACUNIT*20
		--r.fuse = TICRATE*16
		mo.ufosp = not mo.ufosp
		mo.ufos[#mo.ufos+1] = r
	end

	for i = 1, #mo.ufos
		local v = mo.ufos[i]
		if v and v.valid
			v.momy = -mo.spd/3
		end
		if v and v.valid and v.y <= mo.basey - FRACUNIT*128
			v.fuse = 1
		end
		if not v or not v.valid
			table.remove(mo.ufos, i)
		end
	end

end

-- spawn asteroids for mo (fake player) & handle them
local function spawnasteroids(mo)

	mo.asteroid_dist = $+ mo.spd

	if mo.asteroid_dist >= 1100*FRACUNIT + (mo.fleeboss.maxhealth and 400*FRACUNIT or 0)
		mo.asteroid_dist = 0
		for i = 1, P_RandomRange(1, 3)
			-- get coords:
			local y = mo.basey + FRACUNIT* P_RandomRange(3600, 4000)
			local x = mo.basex + P_RandomRange(-200, 200)*FRACUNIT
			local z = P_RandomRange(32, 222)*FRACUNIT
			local r = P_SpawnMobj(x, y, z, P_RandomRange(MT_DVDROCK1, MT_DVDROCK3))
			r.scale = FRACUNIT*2
			--r.momy = -FRACUNIT*32
			--r.fuse = TICRATE*16
			if not mo.asteroids
				mo.asteroids = {}
			end
			local removed
			for k,v in ipairs(mo.ufos)
				if r.x >= v.x-v.radius
				and r.x <= v.x+v.radius
				and abs(r.z-v.z) < r.height*2
					P_RemoveMobj(r)
					removed = true
					break
				end
			end
			if removed continue end
			mo.asteroids[#mo.asteroids+1] = r
		end
	end

	-- handle asteroids:
	for i = 1, #mo.asteroids
		local v = mo.asteroids[i]
		if v and v.valid and not v.target
			v.momy = -mo.spd
		end
		if v and v.valid and v.y <= mo.basey - FRACUNIT*128
			v.fuse = 1
		end
		if not v or not v.valid
			table.remove(mo.asteroids, i)
		end
	end
end

-- player blocks, slows down
local function playerblock(mo, tics)
	mo.momx, mo.momy, mo.momz = 0, 0, 0
	mo.state = mo.data.pain
	mo.tics = tics or 36
	mo.spd = FRACUNIT*12
	for k,v in ipairs(skybox_itms)
		if v and v.valid
			v.momy = 0
		else
			table.remove(skybox_itms, k)
		end
	end
end

-- block + take damage (prolly unused?)
local function playerpain(mo, tics)
	playerblock(mo, tics)
	if mo.health > 1
		for i = 1, min(mo.health-1, 10)
			local ring = P_SpawnMobj(mo.x, mo.y, mo.z, MT_FLINGRING)
			ring.flags = MF_NOGRAVITY
			ring.fuse = TICRATE/2
			ring.momx = P_RandomRange(-20, 20)*FRACUNIT
			ring.momy = P_RandomRange(-20, 20)*FRACUNIT
			ring.momz = P_RandomRange(-20, 20)*FRACUNIT
		end
	end
	mo.health = max(1, $-10)
	P_PlayRinglossSound(mo)
end

-- used for boost asteroid targetting
local function playertargetasteroids(mo)
	if mo.boosts
		mo.btarget = nil
		local prevdist = 999*FRACUNIT
		for i = 1, #mo.asteroids
			local v = mo.asteroids[i]

			if not v or not v.valid
				table.remove(mo.asteroids, i)
				continue
			end

			local dist = R_PointToDist2(mo.x, mo.y, v.x, v.y)
			if dist < FRACUNIT*1024
			and dist <= prevdist
			and v.y > mo.y
				prevdist = dist
				mo.btarget = v
			end
		end
		-- spawn target reticle on target
		if not mo.btarget return end
		if leveltime%2
			local ret = P_SpawnMobj(mo.btarget.x, mo.btarget.y-FRACUNIT*32, mo.btarget.z - FRACUNIT*8, MT_THOK)
			ret.sprite = SPR_TARG
			ret.frame = (leveltime%12)/2
			ret.fuse = 1
			ret.scale = FRACUNIT + (MT_DVDROCK3 - mo.btarget.type)*FRACUNIT
		end
	end
end

local checkpoints = {
	function(mo)
		P_SetOrigin(mo.fleeboss, mo.fleeboss.x, mo.fleeboss.basey - 2500*FRACUNIT, mo.fleeboss.z)
		mo.fleeboss.tgt_y = mo.fleeboss.y
		mo.fleeboss.health = 0
	end,
}

COM_AddCommand("checkpoint", function(p, arg)
	if tonumber(arg) and checkpoints[tonumber(arg)]
		checkpoints[tonumber(arg)](p.mo.DVDmo)
	end
end)

freeslot("sfx_kpinch")

-- DD_resetplayerpos: Resets player position to basex,basey,64
local function DD_resetplayerpos(mo)
	mo.angle = ANGLE_90
	mo.state = mo.data.fly
	P_SetOrigin(mo, mo.basex, mo.basey, FRACUNIT*64)
	mo.momx = 0
	mo.momy = 0
	mo.momz = 0
end

-- DD_wipeitems: Wipes asteroids and UFOs alike from the screen
local function DD_wipeitems(mo)
	for k,v in ipairs(mo.ufos)
		if v and v.valid
			v.fuse = 1
		end
	end
	for k,v in ipairs(mo.asteroids)
		if v and v.valid
			v.fuse = 1
		end
	end
end

-- boss phase 1: fleeing and not attacking
local function handleboss(mo)
	if not mo.fleeboss
		mo.fleeboss = P_SpawnMobj(mo.x, mo.y + FRACUNIT*3000, FRACUNIT*128, MT_DDBOSS)
		mo.fleeboss.color = SKINCOLOR_WHITE
		mo.fleeboss.scale = FRACUNIT*3
		mo.fleeboss.health = 4
		mo.fleeboss.height = FRACUNIT*128
		mo.fleeboss.radius = FRACUNIT*64
		mo.fleeboss.flags = MF_NOGRAVITY
		mo.fleeboss.tgt_y = mo.fleeboss.y
		mo.fleeboss.basex, mo.fleeboss.basey, mo.fleeboss.basez = mo.fleeboss.x, mo.fleeboss.y, mo.fleeboss.z
		mo.fleeboss.target = mo
	end
	if not mo.fleeboss.maxhealth
		mo.fleeboss.momy = (mo.fleeboss.tgt_y - mo.fleeboss.y)/2
	end

	if not mo.fleeboss.health
		if not mo.fleeboss.t_animtimer
			mo.fleeboss.t_animtimer = 0
			mo.fleeboss.nattacktime = TICRATE*4
			S_StopMusic(mo.plyr)
			P_FlashPal(mo.plyr, 1, 10)
			DD_resetplayerpos(mo)
			DD_wipeitems(mo)

		end
		mo.fleeboss.t_animtimer = $+1

		if mo.fleeboss.t_animtimer == 35
			mo.fleeboss.scale = FRACUNIT
			mo.fleeboss.state = S_BOSS_K1
			mo.fleeboss.basex, mo.fleeboss.basey, mo.fleeboss.basez = mo.fleeboss.x, mo.fleeboss.y, mo.fleeboss.z
			P_FlashPal(mo.plyr, 1, 10)

		elseif mo.fleeboss.state == S_BOSS_K2
		and mo.fleeboss.tics == 1
			P_FlashPal(mo.plyr, 1, 4)
			S_ChangeMusic("MANTRA", true, mo.plyr)
			mo.fleeboss.maxhealth = 6
			mo.fleeboss.health = mo.fleeboss.maxhealth
		end

		return true
	end

	-- actual dumb thinker:
	local boss = mo.fleeboss

	if not boss.maxhealth return end

	-- distortion visual effects
	if boss.distortion
		if not (leveltime%3)
			boss.sprite = SPR_DDHM
			boss.tics = 1
			boss.frame = R
		end
		if not (leveltime%10)			--			VV make OGL happy
			local d = P_SpawnMobj(boss.x, boss.y-FRACUNIT/2, boss.z, MT_THOK)
			d.state = S_DISTORTION1
			d.destscale = FRACUNIT*2
			d.scalespeed = FRACUNIT/64
		end
	end

	if boss.flashtics	-- hurt, ow
		boss.state = S_BOSS_K4
		boss.frame = 4 +leveltime%2
		boss.flashtics = $-1
		return
	end

	if boss.health == 2 and not boss.didharmonics	-- 2 health, use harmonics
		boss.state = S_KANADE_HARMONICS
		return	-- other shit does in fact not matter
	elseif boss.health == 1 and not boss.pinchstarted	-- pinch phase activation:
		if not boss.ptime
			boss.ptime = 0
			boss.hclones = {}
			boss.spawnx = boss.basex - FRACUNIT*192
			boss.spawny = boss.basey + FRACUNIT*128
			boss.spawnz = boss.basez - FRACUNIT*96
			mo.spd = FRACUNIT*TICRATE
			S_StopMusic(mo.plyr)
			P_FlashPal(mo.plyr, 1, 10)
			DD_resetplayerpos(mo)
			DD_wipeitems(mo)
		elseif boss.ptime == 5
			S_StartSound(mo, sfx_kpinch)
		end
		boss.ptime = $+1

		if boss.ptime >= TICRATE*2
		and boss.ptime <= TICRATE*6 + 4
			if not (boss.ptime%4)
				local ol = P_SpawnMobj(boss.spawnx, boss.spawny, boss.spawnz, MT_THOK)
				ol.sprite = SPR_DDHM
				ol.frame = R|FF_FULLBRIGHT
				ol.destscale = FRACUNIT*4
				ol.scalespeed = FRACUNIT/8


				local clone = P_SpawnMobj(boss.spawnx, boss.spawny, boss.spawnz, MT_DDBOSS)
				clone.state = S_BOSS_K3
				clone.maxhealth = 69
				clone.health = 69
				S_StartSoundAtVolume(clone, sfx_kinvin, 50)
				boss.spawnx = $+FRACUNIT*64
				boss.spawny = $-FRACUNIT/2	-- make openGL happy
				boss.hclones[#boss.hclones+1] = clone
				if boss.spawnx >= FRACUNIT*192 + boss.basex
					boss.spawnx = boss.basex-FRACUNIT*192
					boss.spawnz = $+FRACUNIT*64
					boss.spawny = $+FRACUNIT*64
				end
			end
		elseif boss.ptime >= TICRATE*7
		and boss.ptime <= TICRATE*12
			for k,v in ipairs(boss.hclones)

				if boss.ptime == TICRATE*7 + (k-1)*4
					v.state = S_KANADE_TAKEOFF1
				end
				if v.state == S_KANADE_TAKEOFF2
					v.tics = -1
				end
				if boss.ptime == TICRATE*12
					v.momz = 0
					v.flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT
				end
			end
		elseif boss.ptime == TICRATE*12+1
			boss.state = S_KANADE_TAKEOFF1
		elseif boss.ptime == TICRATE*12+12
			boss.state = S_INVISIBLE
			boss.tics = -1
			boss.momz = 0
			boss.flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_SOLID
			mo.spd = FRACUNIT*TICRATE*5
			P_FlashPal(mo.plyr, 1, 4)
			S_StartSound(mo, sfx_zoom)
			S_ChangeMusic("TERROR", true, mo.plyr)
			mo.health = max($, 51)
			boss.pinchstarted = true
		end

		if boss.ptime < TICRATE*12+1
			boss.state = S_BOSS_K3
			boss.frame = A + (leveltime%4/2)
		end

		return true
	end

	if boss.pinchstarted return end

	if boss.nattacktime
		boss.nattacktime = $-1
	else	-- perform a random attack depending on the situation:
		boss.distortion = nil
		boss.state = P_RandomRange(0, 1) and S_KANADE_SLASH0 or S_KANADE_TAKEOFF1
		if boss.health < 5	-- <5 HP: chance of using Howling
		and P_RandomRange(0, 5) < 2
			boss.state = S_KANADE_HOWLING1
		end
		boss.nattacktime = TICRATE*3
	end
end

freeslot("S_K_SLASHD1", "S_K_SLASHD2", "S_K_SLASHV1", "S_K_SLASHV2", "S_K_SLASHDIAG1", "S_K_SLASHDIAG2")

function A_SpawnHSlashRelative(mo)
	local tgt = mo.target
	local slash = P_SpawnMobj(tgt.basex, tgt.basey, mo.z, MT_KSLASHH)
	slash.scale = FRACUNIT*2
	slash.angle = tgt.angle
	slash.target = mo.target
	slash.doublestun = true
end

states[S_K_SLASHD1] = {SPR_DDHM, S, 10, nil, 0, 0, S_K_SLASHD2}
states[S_K_SLASHD2] = {SPR_DDHM, S, 1, A_SpawnHSlashRelative, 0, 0, S_NULL}

function A_SpawnVSlashRelative(mo)
	local tgt = mo.target
	local slash = P_SpawnMobj(mo.x, tgt.basey, 0, MT_KSLASHV)
	slash.scale = FRACUNIT*2
	slash.angle = tgt.angle
	slash.target = mo.target
	slash.doublestun = true
end

states[S_K_SLASHV1] = {SPR_DDHM, I, 10, nil, 0, 0, S_K_SLASHV2}
states[S_K_SLASHV2] = {SPR_DDHM, I, 1, A_SpawnVSlashRelative, 0, 0, S_NULL}

-- functions for spawning slashes in pinch
local function pinch_spawnslashhorizontal(mo, z)
	local s = P_SpawnMobj(mo.basex - FRACUNIT*420, mo.basey, z, MT_THOK)
	s.flags = MF_NOCLIPHEIGHT|MF_NOGRAVITY
	S_StartSound(mo, sfx_belnch)
	s.target = mo
	s.state = S_K_SLASHD1
	s.momx = FRACUNIT*100
	s.fuse = TICRATE*2
end

local function pinch_spawnslashvertical(mo, x)
	local s = P_SpawnMobj(x, mo.basey, FRACUNIT*512, MT_THOK)
	s.flags = MF_NOCLIPHEIGHT|MF_NOGRAVITY
	S_StartSound(mo, sfx_belnch)
	s.target = mo
	s.state = S_K_SLASHV1
	s.momz = -FRACUNIT*64
	s.fuse = TICRATE*2
end

-- diag slashes
for i = 1, 10
	freeslot("S_KSLASHD1_"..i)
end
for i = 1, 10
	freeslot("S_KSLASHD2_"..i)
end

freeslot("MT_DVDPAIN")
mobjinfo[MT_DVDPAIN] = {
	doomednum = -1,
    spawnstate = S_INVISIBLE,
    spawnhealth = 1000,
    radius = 16*FRACUNIT,
    height = 32*FRACUNIT,
    flags = MF_NOGRAVITY|MF_SOLID
}

function A_diagslashhitbox(mo, var1)
	--spawn a bunch of slash hitboxes
	slashSound(mo)
	local slashang = ANG1*30
	if var1
		slashang = $ - ANG1*60
	end
	local x, z = mo.x, mo.z
	for i = 1, 32
		x = $+ 16* cos(slashang)
		z = $+ 16* sin(slashang)
		local a = P_SpawnMobj(x, mo.y, z+FRACUNIT*12, MT_DVDPAIN)
		a.fuse = 6
		a.scale = FRACUNIT*2/3
		a.doublestun = true
	end
	x, z = mo.x, mo.z
	for i = 1,32
		x = $- 16* cos(slashang)
		z = $- 16* sin(slashang)
		local a = P_SpawnMobj(x, mo.y, z+FRACUNIT*12, MT_DVDPAIN)
		a.fuse = 6
		a.scale = FRACUNIT*2/3
		a.doublestun = true
	end
end

freeslot("SPR_D1SH", "SPR_D2SH")
states[S_KSLASHD1_1] = {SPR_D1SH, A|FF_FULLBRIGHT, 2, nil, 0, 0, S_KSLASHD1_2}
states[S_KSLASHD1_2] = {SPR_D1SH, B|FF_FULLBRIGHT, 2, A_PlaySound, sfx_s3k5c, 0, S_KSLASHD1_3}
states[S_KSLASHD1_3] = {SPR_D1SH, C|FF_FULLBRIGHT, 2, nil, 0, 0, S_KSLASHD1_4}
states[S_KSLASHD1_4] = {SPR_D1SH, A|FF_FULLBRIGHT|TR_TRANS30, 10, nil, 0, 0, S_KSLASHD1_5}
states[S_KSLASHD1_5] = {SPR_D1SH, A|FF_FULLBRIGHT|TR_TRANS60, 10, nil, 0, 0, S_KSLASHD1_6}
states[S_KSLASHD1_6] = {SPR_D1SH, D|FF_FULLBRIGHT, 2, A_diagslashhitbox, 0, 0, S_KSLASHD1_7}
states[S_KSLASHD1_7] = {SPR_D1SH, E|FF_FULLBRIGHT, 2, nil, 0, 0, S_KSLASHD1_8}
states[S_KSLASHD1_8] = {SPR_D1SH, F|FF_FULLBRIGHT, 2, nil, 0, 0, S_KSLASHD1_9}
states[S_KSLASHD1_9] = {SPR_D1SH, A|FF_FULLBRIGHT|TR_TRANS30, 10, nil, 0, 0, S_KSLASHD1_10}
states[S_KSLASHD1_10] = {SPR_D1SH, A|FF_FULLBRIGHT|TR_TRANS70, 10, nil, 0, 0, S_NULL}

states[S_KSLASHD2_1] = {SPR_D2SH, A|FF_FULLBRIGHT, 2, nil, 0, 0, S_KSLASHD2_2}
states[S_KSLASHD2_2] = {SPR_D2SH, B|FF_FULLBRIGHT, 2, A_PlaySound, sfx_s3k5c, 0, S_KSLASHD2_3}
states[S_KSLASHD2_3] = {SPR_D2SH, C|FF_FULLBRIGHT, 2, nil, 0, 0, S_KSLASHD2_4}
states[S_KSLASHD2_4] = {SPR_D2SH, A|FF_FULLBRIGHT|TR_TRANS30, 10, nil, 0, 0, S_KSLASHD2_5}
states[S_KSLASHD2_5] = {SPR_D2SH, A|FF_FULLBRIGHT|TR_TRANS60, 10, nil, 0, 0, S_KSLASHD2_6}
states[S_KSLASHD2_6] = {SPR_D2SH, D|FF_FULLBRIGHT, 2, A_diagslashhitbox, 1, 0, S_KSLASHD2_7}
states[S_KSLASHD2_7] = {SPR_D2SH, E|FF_FULLBRIGHT, 2, nil, 0, 0, S_KSLASHD2_8}
states[S_KSLASHD2_8] = {SPR_D2SH, F|FF_FULLBRIGHT, 2, nil, 0, 0, S_KSLASHD2_9}
states[S_KSLASHD2_9] = {SPR_D2SH, A|FF_FULLBRIGHT|TR_TRANS30, 10, nil, 0, 0, S_KSLASHD2_10}
states[S_KSLASHD2_10] = {SPR_D2SH, A|FF_FULLBRIGHT|TR_TRANS70, 10, nil, 0, 0, S_NULL}

function A_SpawnDSlashRelative(mo)
	local type = mo.slashinfo[3] and S_KSLASHD2_1 or S_KSLASHD1_1
	local slash = P_SpawnMobj(mo.slashinfo[1], mo.y, mo.slashinfo[2], MT_THOK)
	slash.state = type
	slash.target = mo.target
	slash.scale = FRACUNIT*2
end

states[S_K_SLASHDIAG1] = {SPR_DDHM, U, 10, nil, 0, 0, S_K_SLASHDIAG2}
states[S_K_SLASHDIAG2] = {SPR_DDHM, U, 1, A_SpawnDSlashRelative, 0, 0, S_NULL}

local function pinch_spawnslashdiagonal(mo, x, z, flip)
	-- spawn the kanade
	local slashang = ANG1*30
	if flip
		slashang = $ - ANG1*60
	end
	local sx, sz = x, z
	if flip
		x = $- 420* cos(slashang)
		z = $- 420* sin(slashang)
	else
		x = $+ 420* cos(slashang)
		z = $+ 420* sin(slashang)
	end
	local a = P_SpawnMobj(x, mo.y, z, MT_THOK)
	a.state = S_K_SLASHDIAG1
	a.frame = $ - (flip and 1 or 0)
	a.momx = 100*cos(slashang)
	a.momz = 100*sin(slashang)
	a.target = mo
	if not flip
		a.momx = -a.momx
		a.momz = -a.momz
	end
	a.slashinfo = {sx, sz, flip}
	S_StartSound(mo, sfx_belnch)
end

-- pinch phase slashes

local function handlepinchslashes(p)
	local mo = p.mo.DVDmo
	if not mo return end

	if mo.slashdist == nil then
		mo.slashdist = 0
		mo.totalsdist = 0
	end

	if mo.totalsdist > 220000
		mo.nocollision = true
		if not mo.bosstp
			P_SetOrigin(mo.fleeboss, mo.basex, mo.basey + FRACUNIT*1000, FRACUNIT*48)
			mo.fleeboss.state = S_BOSS_K3
			mo.fleeboss.distortion = nil
			mo.bosstp = true
		end

		if not (abs(mo.x - mo.basex) < FRACUNIT*16 and abs(mo.z, FRACUNIT*48) < FRACUNIT*16) and mo.spd
			mo.momx = (mo.basex - mo.x)/2
			mo.momz = (FRACUNIT*64 - mo.z)/2
			if abs(mo.x - mo.basex) < FRACUNIT*16 and abs(mo.z, FRACUNIT*48) < FRACUNIT*16
				mo.momx = 0
				mo.momz = 0
			end
		end

		if mo.fleeboss.y <= mo.basey + FRACUNIT*128 and mo.fleeboss.health > 0
			P_SetOrigin(mo.fleeboss, mo.basex, mo.basey + FRACUNIT*64, FRACUNIT*48)
			mo.fleeboss.momy = 0
			mo.fleeboss.health = -1
			mo.fleeboss.deadtime = TICRATE*4
			mo.spd = FRACUNIT*512
			P_FlashPal(mo.plyr, 1, 4)
			S_StartSound(mo.fleeboss, sfx_khit2)
			mo.momy = FRACUNIT*64
		end
		if mo.fleeboss.health < 0 and mo.fleeboss.deadtime
			COM_BufInsertText(mo.plyr, "tunes -none")	-- dont restore music u piece of shit game
			mo.fleeboss.state = S_BOSS_K4
			mo.fleeboss.momy = 0
			mo.fleeboss.frame = 4 +leveltime%2
			if not (leveltime%5) or (mo.fleeboss.deadtime < TICRATE*2 and not (leveltime%2))
				mo.fleeboss.frame = R + P_RandomRange(0, 2)
			end
			mo.fleeboss.deadtime = $-1
			if not mo.fleeboss.deadtime
				mo.fleeboss.flags = MF_NOCLIPHEIGHT
				mo.fleeboss.momz = FRACUNIT*12
				mo.fleeboss.momy = -6*FRACUNIT
				P_DoPlayerExit(mo.plyr)
			end
			return true
		elseif mo.fleeboss.deadtime == 0
			COM_BufInsertText(mo.plyr, "tunes -none")	-- dont restore music u piece of shit game
			mo.fleeboss.frame = U + leveltime%4
			local b = P_SpawnMobj(mo.fleeboss.x + P_RandomRange(-32, 32)*FRACUNIT, mo.fleeboss.y + P_RandomRange(-32, 32)*FRACUNIT, mo.fleeboss.z + P_RandomRange(0, 64)*FRACUNIT, MT_THOK)
			b.state = S_QUICKBOOM1
			if not (leveltime%4)
				S_StartSound(b, sfx_pop)
			end
			return true
		end

		mo.fleeboss.momy = -mo.spd/TICRATE
		if mo.spd
			mo.spd = $+FRACUNIT*16
		end
		return true
	end
	mo.slashdist = $+mo.spd
	mo.totalsdist = $+mo.spd/FRACUNIT

	if mo.slashdist >= TICRATE*300*FRACUNIT

		local pattern = P_RandomRange(0, 9)	-- pick a pattern at random!
		if not pattern	-- 1: straight cross on the player
			pinch_spawnslashhorizontal(mo, mo.z)
			pinch_spawnslashvertical(mo, mo.x)

		elseif pattern == 1	-- 2: diagonal cross on the player
			pinch_spawnslashdiagonal(mo, mo.x, mo.z)
			pinch_spawnslashdiagonal(mo, mo.x, mo.z, true)

		elseif pattern == 2	-- diagonal around the screen
			pinch_spawnslashdiagonal(mo, mo.basex-FRACUNIT*128, 192*FRACUNIT)
			pinch_spawnslashdiagonal(mo, mo.basex-FRACUNIT*128, 64*FRACUNIT, true)
			pinch_spawnslashdiagonal(mo, mo.basex+FRACUNIT*128, 64*FRACUNIT)
			pinch_spawnslashdiagonal(mo, mo.basex+FRACUNIT*128, 192*FRACUNIT, true)

		elseif pattern == 3	-- same as 2 but more centered
			pinch_spawnslashdiagonal(mo, mo.basex-FRACUNIT*64, 160*FRACUNIT)
			pinch_spawnslashdiagonal(mo, mo.basex-FRACUNIT*64, 96*FRACUNIT, true)
			pinch_spawnslashdiagonal(mo, mo.basex+FRACUNIT*64, 96*FRACUNIT)
			pinch_spawnslashdiagonal(mo, mo.basex+FRACUNIT*64, 160*FRACUNIT, true)

		elseif pattern == 4	-- some kind of H
			pinch_spawnslashhorizontal(mo, FRACUNIT*128)
			pinch_spawnslashvertical(mo, mo.basex+FRACUNIT*128)
			pinch_spawnslashvertical(mo, mo.basex-FRACUNIT*128)

		elseif pattern == 5	-- rotated H
			pinch_spawnslashhorizontal(mo, FRACUNIT*160)
			pinch_spawnslashhorizontal(mo, FRACUNIT*96)
			pinch_spawnslashvertical(mo, mo.basex)

		elseif pattern == 6	-- a bunch of H
			pinch_spawnslashhorizontal(mo, FRACUNIT*128)
			pinch_spawnslashvertical(mo, mo.basex+FRACUNIT*64)
			pinch_spawnslashvertical(mo, mo.basex+FRACUNIT*192)
			pinch_spawnslashvertical(mo, mo.basex-FRACUNIT*64)
			pinch_spawnslashvertical(mo, mo.basex-FRACUNIT*192)

		elseif pattern == 7	-- player centered star
			pinch_spawnslashdiagonal(mo, mo.x, mo.z)
			pinch_spawnslashdiagonal(mo, mo.x, mo.z, true)
			pinch_spawnslashhorizontal(mo, mo.z)
			pinch_spawnslashvertical(mo, mo.x)

		elseif pattern == 8	-- screen centered star
			pinch_spawnslashdiagonal(mo, mo.basex, FRACUNIT*128)
			pinch_spawnslashdiagonal(mo, mo.basex, FRACUNIT*128, true)
			pinch_spawnslashhorizontal(mo, FRACUNIT*128)
			pinch_spawnslashvertical(mo, mo.basex)

		elseif pattern == 9	-- Z
			pinch_spawnslashhorizontal(mo, FRACUNIT*224)
			pinch_spawnslashhorizontal(mo, FRACUNIT*48)
			pinch_spawnslashdiagonal(mo, mo.basex, 128*FRACUNIT)

		end
		mo.slashdist = 0
	end

end
freeslot("sfx_dddie")
local function fakeplayerhandler()
	for p in players.iterate do
		if not p.mo or not p.mo.DVDmo continue end
		if (p.bot or p.spectator) continue end
		local mo = p.mo.DVDmo

		HU_handler(p)

		p.awayviewtics = 99

		-- SKYBOX SCROLLER:
		skyboxhandler(p)
		if p == displayplayer
			local spd = FRACUNIT*32 - (TICRATE*FRACUNIT - mo.spd)*2/3
			for i = 1, 2
				scroll_sectors[i].floorheight = spd
			end
		end

		-- out of rings death sequence:
		if mo.health == 1
			if not mo.deathtimer
				mo.state = S_PLAY_WALK
				mo.color = p.mo.color
				mo.momx, mo.momy, mo.momz = 0, 0, 0
				mo.nocollision = true
				mo.deathtimer = 0
				if mo.fleeboss and mo.fleeboss.maxhealth
					if mo.fleeboss.health > 1
						P_SetOrigin(mo.fleeboss, mo.fleeboss.basex, mo.fleeboss.basey, mo.fleeboss.basez)
					end
					mo.fleeboss.state = S_KANADE_TAKEOFF1
					mo.fleeboss.kill = 1
				end
			end
			if mo.spd
				spawnufos(mo)
				spawnasteroids(mo)
			end
			mo.spd = $/2
			mo.tics = mo.tics > 1 and 1 or $
			mo.deathtimer = $+1

			if mo.fleeboss.state == S_KANADE_DSLASH1
			and mo.fleeboss.kill == 1
				P_SetOrigin(mo.fleeboss, mo.x, mo.y, mo.fleeboss.z)
				mo.fleeboss.kill =2
				mo.fleeboss.tics = -1
			end

			if mo.deathtimer > TICRATE and not mo.fleeboss.kill
				if not mo.momz
					p.lives = $-1
				end
				mo.momz = -FRACUNIT*24
				mo.flags = MF_NOCLIPHEIGHT
			elseif mo.fleeboss.kill and mo.fleeboss.z <= mo.z and mo.fleeboss.y <= mo.y
				if not mo.momz
					p.lives = $-1
					S_StartSound(mo,sfx_dddie)
				end
				mo.momz = -FRACUNIT*48
				mo.flags = MF_NOCLIPHEIGHT
			end
			return
		end

		-- SUPER COLOR FLASH + particle effects

		if mo.scolor == nil or mo.scolor >= 16
			mo.scolor = 0
		end
		mo.scolor = $+1
		mo.color = mo.startcolor + abs((mo.scolor/2) - 4)
		local numparts = max(1, 1 + (mo.spd - TICRATE*FRACUNIT)/FRACUNIT / 8)
		for i = 1, numparts
			local prt = P_SpawnMobj(mo.x + P_RandomRange(-32, 32)*FRACUNIT, mo.y + P_RandomRange(min(-32, -mo.spd/FRACUNIT), 32)*FRACUNIT, mo.z + P_RandomRange(0, 64)*FRACUNIT, MT_DVDPARTICLE)
			prt.momy = -mo.spd
			prt.scale = FRACUNIT*3/2
			prt.color = mo.color
		end
		local boss_nofurtherinput

		if handleboss(mo)
			mo.nocollision = true
			boss_nofurtherinput = true
		end

		if not mo.target
			playertargetasteroids(mo)
			if mo.momy	-- ok we have a problem
				mo.target = mo.backto
				if not mo.target and not mo.bosstp
					P_SetOrigin(mo, mo.x, mo.basey, mo.z)
					mo.momy = 0
				end
			end
		elseif mo.goback and mo.backto and mo.backto.valid
			mo.target = mo.backto
			mo.backto.state = S_INVISIBLE
			-- Homincchase does weird things so....
			local dist = max(1, R_PointToDist2(mo.x, mo.y, mo.backto.x, mo.backto.y))
			mo.momx = FixedMul(FixedDiv(mo.backto.x - mo.x, dist), 16*mo.scale)
			mo.momy = FixedMul(FixedDiv(mo.backto.y - mo.y, dist), 16*mo.scale)
			mo.momz = FixedMul(FixedDiv(mo.backto.z - mo.z, dist), 16*mo.scale)
			mo.angle = ANGLE_90

			if R_PointToDist2(mo.x, mo.y, mo.backto.x, mo.backto.y) < 16*FRACUNIT
			and abs(mo.z - mo.backto.z) < 16*FRACUNIT
				P_SetOrigin(mo, mo.backto.x, mo.backto.y, mo.backto.z)
				if mo.backto and mo.backto.valid
					P_RemoveMobj(mo.backto)
				end
				mo.goback = nil
				mo.backto = nil
				mo.target = nil
				mo.btarget = nil
				--mo.flags2 = $ & ~MF2_DONTDRAW
				mo.angle = ANGLE_90
				P_InstaThrust(mo, 0, 0)
				mo.momz = 0	-- important
			end
			return
		else
			if not mo.target.valid	-- oof
				mo.target = mo.backto
				mo.goback = true
				return
			end
			A_HomingChase(mo, FRACUNIT*64)
			local trail = P_SpawnMobj(mo.x, mo.y, mo.z, MT_THOK)
			trail.color = mo.color
		end
		mo.nocollision = nil

		if boss_nofurtherinput
			return
		end

		if not mo.fleeboss.pinchstarted
			spawnufos(mo)
			spawnasteroids(mo)
		else
			if handlepinchslashes(p)
				boss_nofurtherinput = true
			end
		end

		if boss_nofurtherinput
			return
		end

		-- RING CONSUMPTION

		if not mo.pauserings	-- timer to determine for how long we pause the ring consumption
		and mo.health > 1
			if not (leveltime%TICRATE)
				mo.health = $-1
			end
		end
		if mo.health <= 15
			S_SpeedMusic(FRACUNIT*3/2, p)
		else
			S_SpeedMusic(FRACUNIT, p)
		end

		-- """CONTROLS""" (they kinda suck tho)
		-- we directly change momx and momz, we should only move on these axises anyway

		-- very hacky and unoptimized but I CAN'T BE ASSED OK?

		if mo.state == mo.data.pain
			mo.angle = $ + ANG1*30
			if mo.tics == 1
				mo.state = mo.data.fly
				mo.angle = ANGLE_90
			end
			return
		end

		-- BOOST
		if mo.boosts and p.cmd.buttons & BT_JUMP and not mo.target and mo.btarget
			S_StartSound(mo, sfx_zoom)
			mo.boosts = $-1
			mo.target = mo.btarget
			mo.state = S_PLAY_ROLL
			local gb = P_SpawnMobj(mo.x, mo.y, mo.z, MT_THOK)
			--gb.state = S_INVISIBLE
			gb.tics = -1
			mo.backto = gb
		end

		if mo.fleeboss.pinchstarted
			mo.spd = min(FRACUNIT*TICRATE*5, $+FRACUNIT*2)
		else
			mo.spd = min(FRACUNIT*TICRATE, $+FRACUNIT/2)
		end

		if p.cmd.sidemove > 0
			if mo.momx > 0
				mo.momx = min(FRACUNIT*24, $+FRACUNIT*3/4)
			else
				mo.momx = min(FRACUNIT*24, $+FRACUNIT*3/2)
			end
		elseif p.cmd.sidemove < 0
			if mo.momx < 0
				mo.momx = max(-FRACUNIT*24, $-FRACUNIT*3/4)
			else
				mo.momx = max(-FRACUNIT*24, $-FRACUNIT*3/2)
			end
		elseif mo.momx
			if mo.momx < 0
				mo.momx = min(0, $+FRACUNIT)
			else
				mo.momx = max(0, $-FRACUNIT)
			end
		end
		if mo.x > mo.basex + FRACUNIT*230
			P_SetOrigin(mo, mo.basex + FRACUNIT*230, mo.y, mo.z)
			mo.momx = 0
		elseif mo.x < mo.basex - FRACUNIT*230
			P_SetOrigin(mo, mo.basex - FRACUNIT*230, mo.y, mo.z)
			mo.momx = 0
		end

		if p.cmd.forwardmove > 0
			if mo.momz > 0
				mo.momz = min(FRACUNIT*24, $+FRACUNIT*3/4)
			else
				mo.momz = min(FRACUNIT*24, $+FRACUNIT*3/2)
			end
		elseif p.cmd.forwardmove < 0
			if mo.momz < 0
				mo.momz = max(-FRACUNIT*24, $-FRACUNIT*3/4)
			else
				mo.momz = max(-FRACUNIT*24, $-FRACUNIT*3/2)
			end
		elseif mo.momz
			if mo.momz < 0
				mo.momz = min(0, $+FRACUNIT*3/2)
			else
				mo.momz = max(0, $-FRACUNIT*3/2)
			end
		end
		if mo.z < 32*FRACUNIT
			mo.momz = 0
			mo.z = FRACUNIT*32
		elseif mo.z > FRACUNIT*256
			mo.momz = 0
			mo.z = FRACUNIT*256
		end

	end
end

-- handle collision between our fake player and various objects:

addHook("MobjMoveCollide", function(mo, inf)
	if mo.z + mo.height >= inf.z
	and mo.z <= inf.z+inf.height	-- check for z collision
	and inf.valid and inf.health

		if mo.goback or mo.nocollision return false end

		-- asteroids
		if inf.type == MT_DVDROCK1 or inf.type == MT_DVDROCK2 or inf.type == MT_DVDROCK3
			-- collision, oof

			if mo.target	-- boosting (it uses homingchase so that means there's a target, right?)
				local notargetexplode
				inf.target = mo.fleeboss
				if inf.target.hclones and inf.target.hclones[1]
					inf.target = inf.target.hclones[1]
				end
				if inf.target.state >= S_KANADE_TAKEOFF1 and inf.target.state <= S_KANADE_DSLASH3
					for i = 1, 3*(inf.type - (MT_DVDROCK1-1))
						local boom = P_SpawnMobj(inf.x + P_RandomRange(-32, 32)*FRACUNIT, inf.y + P_RandomRange(-32, 32)*FRACUNIT, inf.z + P_RandomRange(0, 64)*FRACUNIT, MT_THOK)
						boom.state = S_DVDSROCK1
						boom.scale = FRACUNIT*2 + P_RandomRange(-FRACUNIT/2, FRACUNIT/2-10)
						boom.momx = P_RandomRange(-10, 10)*FRACUNIT
						boom.momy = inf.momy + P_RandomRange(-10, 10)*FRACUNIT
						boom.momz = P_RandomRange(-10, 10)*FRACUNIT
						boom.fuse = TICRATE*2
					end
					notargetexplode = true
				else
					A_HomingChase(inf, FRACUNIT*64)
				end
				mo.goback = true
				mo.state = mo.data.fly
				inf.fuse = TICRATE*10
				inf.thrownby = mo
				S_StartSound(mo, sfx_s3k9b)
				if notargetexplode
					P_RemoveMobj(inf)
					return true
				end
				for i = 1, 7
					local boom = P_SpawnMobj(inf.x + P_RandomRange(-32, 32)*FRACUNIT, inf.y + P_RandomRange(-32, 32)*FRACUNIT, inf.z + P_RandomRange(0, 64)*FRACUNIT, MT_THOK)
					boom.state = S_SSPK1
					boom.scale = FRACUNIT*2 + P_RandomRange(-FRACUNIT/2, FRACUNIT/2-10)
					boom.momx = P_RandomRange(-10, 10)*FRACUNIT
					boom.momy = inf.momy + P_RandomRange(-10, 10)*FRACUNIT
					boom.momz = P_RandomRange(-10, 10)*FRACUNIT
					boom.fuse = TICRATE*2
				end
			else
				S_StartSound(mo, sfx_s3k59)
				-- shatter the rock:
				for i = 1, 3*(inf.type - (MT_DVDROCK1-1))
					local boom = P_SpawnMobj(inf.x + P_RandomRange(-32, 32)*FRACUNIT, inf.y + P_RandomRange(-32, 32)*FRACUNIT, inf.z + P_RandomRange(0, 64)*FRACUNIT, MT_THOK)
					boom.state = S_DVDSROCK1
					boom.scale = FRACUNIT*2 + P_RandomRange(-FRACUNIT/2, FRACUNIT/2-10)
					boom.momx = P_RandomRange(-10, 10)*FRACUNIT
					boom.momy = inf.momy + P_RandomRange(-10, 10)*FRACUNIT
					boom.momz = P_RandomRange(-10, 10)*FRACUNIT
					boom.fuse = TICRATE*2
				end
				if mo.state ~= mo.data.pain
					playerblock(mo, 31)
					P_StartQuake(FRACUNIT*40, 15)

					if not mo.fleeboss.maxhealth and mo.fleeboss.health < 4
						mo.fleeboss.health = $+1
						mo.fleeboss.tgt_y = $+625*FRACUNIT
					end

				end
				if inf and inf.valid
					P_RemoveMobj(inf)
					return true
				end
			end
		elseif inf.type == MT_BUFO1
			DVD_ufoboom(inf)
			mo.health = $+20
			P_SpawnMobj(inf.x, inf.y, inf.z, MT_RING_ICON)
			S_StartSound(mo, sfx_itemup)
			if inf and inf.valid
				P_RemoveMobj(inf)
			end
		elseif inf.type == MT_BUFO2
			DVD_ufoboom(inf)
			P_SpawnMobj(inf.x, inf.y, inf.z, MT_SNEAKERS_ICON)
			mo.boosts = mo.boosts and $+1 or 1
			mo.boosts = min(3, $)
			if inf and inf.valid
				P_RemoveMobj(inf)
			end
		elseif inf.type == MT_TORPEDO
			playerpain(mo, 90)
			P_StartQuake(FRACUNIT*40, 65)
			P_KillMobj(inf, mo)
		end

		if not inf or not inf.valid return end	-- oooops
		if mo.target return end	-- do not hurt us if we're headed towards an asteroid or whatever

		-- kanade's slashes
		if inf.type == MT_KSLASHH
			if inf.state >= S_KSLASHH6
			and inf.state <= S_KSLASHH8
			and mo.z + mo.height >= inf.z+FRACUNIT*4
			and mo.z <= inf.z+inf.height-FRACUNIT*4
				playerblock(mo, (inf.doublestun and 60 or 45))
				P_StartQuake(FRACUNIT*40, 15)
			end

		elseif inf.type == MT_KSLASHV
			if inf.state >= S_KSLASHV6
			and inf.state <= S_KSLASHV8
				playerblock(mo, (inf.doublestun and 60 or 45))
				P_StartQuake(FRACUNIT*40, 15)
			end

		elseif inf.type == MT_HOWLING
			playerblock(mo, 10)
			P_StartQuake(FRACUNIT*40, 20)

		elseif inf.type == MT_DVDPAIN
			playerblock(mo, (inf.doublestun and 60 or 45))
			P_StartQuake(FRACUNIT*40, 15)
		end
	end
end, MT_SUPERDVD)


-- handle collision between thrown asteroids and our lovely boss

for i = MT_DVDROCK1, MT_DVDROCK3
	addHook("MobjCollide", function(mo, inf)
		if mo.z + mo.height >= inf.z
		and mo.z <= inf.z+inf.height	-- check for z collision
		and mo.target == inf
		and mo.health
			if inf.type == MT_DDBOSS	-- that's a boss I swear

				if inf.preptime ~= nil
					S_StartSound(inf, sfx_s3k7c)
					for i = 1, 32
						local boom = P_SpawnMobj(inf.x + P_RandomRange(-32, 32)*FRACUNIT, inf.y + P_RandomRange(-32, 32)*FRACUNIT, inf.z + P_RandomRange(0, 64)*FRACUNIT, MT_THOK)
						boom.momx = P_RandomRange(-70, 70)*FRACUNIT
						boom.momy = inf.momy + P_RandomRange(-70, 70)*FRACUNIT
						boom.momz = P_RandomRange(-70, 70)*FRACUNIT
						boom.destscale = 1
						boom.flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT
						boom.color = SKINCOLOR_WHITE
					end
					table.remove(mo.thrownby.fleeboss.hclones, 1)
					P_RemoveMobj(mo)
					P_RemoveMobj(inf)
					return
				end

				if not inf.maxhealth	-- maxhealth unitialized -> phase 1:

					for i = 1, 32
						local boom = P_SpawnMobj(inf.x + P_RandomRange(-32, 32)*FRACUNIT, inf.y + P_RandomRange(-32, 32)*FRACUNIT, inf.z + P_RandomRange(0, 64)*FRACUNIT, MT_DVDPARTICLE)
						boom.momx = P_RandomRange(-70, 70)*FRACUNIT
						boom.momy = inf.momy + P_RandomRange(-70, 70)*FRACUNIT
						boom.momz = P_RandomRange(-70, 70)*FRACUNIT
						boom.scale = FRACUNIT*4
						boom.flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT
						boom.color = SKINCOLOR_WHITE
					end
					S_StartSound(mo.thrownby, sfx_bedie1)

					inf.tgt_y = $-625*FRACUNIT
					inf.health = $-1
					if not inf.health	-- boss has no health, go to our origin point
						mo.thrownby.backto = P_SpawnMobj(mo.thrownby.basex, mo.thrownby.basey, 64*FRACUNIT, MT_THOK)
						mo.thrownby.backto.state = S_INVISIBLE
						mo.thrownby.goback = true
					end
				else
					if inf.distortion	-- distortion
						S_StartSound(inf, sfx_kinvin)
						for i = 1, 32
							local boom = P_SpawnMobj(inf.x + P_RandomRange(-32, 32)*FRACUNIT, inf.y + P_RandomRange(-32, 32)*FRACUNIT, inf.z + P_RandomRange(0, 64)*FRACUNIT, MT_THOK)
							boom.momx = P_RandomRange(-70, 70)*FRACUNIT
							boom.momy = inf.momy + P_RandomRange(-70, 70)*FRACUNIT
							boom.momz = P_RandomRange(-70, 70)*FRACUNIT
							boom.destscale = 1
							boom.flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT
							boom.color = SKINCOLOR_WHITE
						end
					else	-- hit landed
						inf.health = $-1
						inf.flashtics = TICRATE
						local sound_tmp = P_SpawnMobj(mo.x, mo.y, mo.z, MT_THOK)
						sound_tmp.state = S_INVISIBLE
						sound_tmp.tics = TICRATE*2
						S_StartSound(sound_tmp, sfx_khit1)
					end
				end
				if mo and mo.valid
					P_RemoveMobj(mo)
				end
			end
		end
	end, i)
end

-- check for dead players we should reset
local function deadreset()
	local deadcount = 0
	local pcount = 0
	local exiting = 0
	for p in players.iterate do
		if p and p.mo and p.mo.DVDmo
			pcount = $+1
			if (p.mo.DVDmo.deathtimer and p.mo.DVDmo.deathtimer >= TICRATE*4)
			or (p.bot or p.spectator)
				deadcount = $+1
				p.failedlevel = true
			end
			if p.exiting == 1
				exiting = $+1
			end
		end
	end

	stagefailed = true

	if exiting > 0 and deadcount+exiting >= pcount
		stagefailed = false
		sugoi.ExitLevel(nil, 0)
	elseif pcount and deadcount and deadcount >= pcount
		sugoi.ExitLevel(gamemap, 1)
	end
end

-- put all our thinkers to good use!

addHook("ThinkFrame", do
	if not mapheaderinfo[gamemap].dvdboss return end
	sugoi.HUDShow("score", false)
	sugoi.HUDShow("time", false)
	sugoi.HUDShow("rings", false)
	fakeplayerhandler()
	deadreset()
end)

local static_bosshealth = 0

hud.add(function(v, p, c)
	if not mapheaderinfo[gamemap].dvdboss return end
	if not p.mo or not p.mo.DVDmo return end

	HU_explosionDrawer(v, p, c)
	HU_fadeDrawer(v, p, c)

	local addx, addy = 0, 0
	if p.mo.DVDmo.state == p.mo.DVDmo.data.pain
		addx = N_RandomRange(-2, 2)
		addy = N_RandomRange(-2, 2)
	end

	-- bootleg rings counter
	local x, y = hudinfo[HUD_SCORE].x, hudinfo[HUD_SCORE].y
	if leveltime%10 < 5 or leveltime >= TICRATE*5
		v.draw(x+addx, y+addy, v.cachePatch(((p.mo.DVDmo.health > 15) or leveltime%10 >= 5) and "STTRINGS" or "STTRRING"), V_SNAPTOTOP|V_SNAPTOLEFT)
	end
	x, y = hudinfo[HUD_RINGSNUM].x, hudinfo[HUD_SCORE].y
	v.drawNum(x+addx, y+addy, p.mo.DVDmo.health-1, V_SNAPTOTOP|V_SNAPTOLEFT)

	v.drawFill(hudinfo[HUD_SCORE].x+addx, hudinfo[HUD_SCORE].y+addy + 26, 124, 4, 26|V_SNAPTOTOP|V_SNAPTOLEFT)
	if p.mo.DVDmo.boosts
		for i = 0, p.mo.DVDmo.boosts-1
			v.drawFill(hudinfo[HUD_SCORE].x+addx + i*41, hudinfo[HUD_SCORE].y+addy + 26, 40, 3, 73|V_SNAPTOTOP|V_SNAPTOLEFT)
		end
	end
	v.draw(hudinfo[HUD_SCORE].x+addx, hudinfo[HUD_SCORE].y + 16+addy, v.cachePatch("BOOSTO"), V_SNAPTOTOP|V_SNAPTOLEFT)

	addx, addy = 0, 0

	-- boss HP hud...
	local boss = p.mo.DVDmo.fleeboss
	if not boss return end
	if boss.maxhealth	-- maxhealth initialized = phase 2

		if boss.flashtics
			addx = N_RandomRange(-2, 2)
			addy = N_RandomRange(-2, 2)
		end

		-- HP back:
		v.drawFill(233+addx, 7+11, 75+addy, 5, 33|V_SNAPTOTOP|V_SNAPTORIGHT)
		v.drawFill(233+5+addx, 5+11+addy, 4, 4, 33|V_SNAPTOTOP|V_SNAPTORIGHT)	-- PLEASE ADD DRAWCROPPEDPATCH TO LUA
		-- HP front:
		local hpl = boss.health*75/boss.maxhealth

		--mo.fleeboss.momy = (mo.fleeboss.tgt_y - mo.fleeboss.y)/2

		static_bosshealth = $+ (hpl - static_bosshealth)/2
		--print(static_bosshealth)

		v.drawFill(233+addx, 7+11+addy, static_bosshealth, 5, 0|V_SNAPTOTOP|V_SNAPTORIGHT)
		if static_bosshealth >= 6
			v.drawFill(233+5+addx, 5+11+addy, 4, 4, 0|V_SNAPTOTOP|V_SNAPTORIGHT)
		end
		-- HP ol:
		v.draw(232+addx, 7+addy, v.cachePatch("ABBAR"), V_SNAPTOTOP|V_SNAPTORIGHT)
	else
		-- distance bar
		-- HP back:
		v.drawFill(233+addx, 7+11, 75+addy, 5, 33|V_SNAPTOTOP|V_SNAPTORIGHT)
		v.drawFill(233+5+addx, 5+11+addy, 4, 4, 33|V_SNAPTOTOP|V_SNAPTORIGHT)	-- PLEASE ADD DRAWCROPPEDPATCH TO LUA
		-- HP front:

		local dist = (boss.y - p.mo.DVDmo.basey)/FRACUNIT - 500

		local hpl = dist*75/2500
		v.drawFill(233+addx, 7+11+addy, hpl, 5, 0|V_SNAPTOTOP|V_SNAPTORIGHT)
		if hpl >= 6
			v.drawFill(233+5+addx, 5+11+addy, 4, 4, 0|V_SNAPTOTOP|V_SNAPTORIGHT)
		end
		-- HP ol:
		v.draw(232+addx, 7+addy, v.cachePatch("ABBAR2"), V_SNAPTOTOP|V_SNAPTORIGHT)

		-- draw arrow: (plyr)
		local pp = v.cachePatch("AARR")
		v.draw(232 - pp.width/2 + addx, 23, pp, V_SNAPTOTOP|V_SNAPTORIGHT)
		local size = v.stringWidth("YOU", 0, "small")/2
		v.drawString(232 - size, 29, "YOU", V_SNAPTOTOP|V_SNAPTORIGHT|V_REDMAP, "small")

		-- draw arrow (boss)
		local maxpos = 232+pp.width/2
		v.draw(max(maxpos, 232 + hpl - pp.width/2 + addx), 23, pp, V_SNAPTOTOP|V_SNAPTORIGHT)
		local size = v.stringWidth("TRGT", 0, "small")/2
		v.drawString(max(maxpos, 232 + hpl - size), 29, "TRGT", V_SNAPTOTOP|V_SNAPTORIGHT|V_REDMAP, "small")

	end

	if p.mo.DVDmo.deathtimer and p.mo.DVDmo.deathtimer > TICRATE*4 and netgame
		v.drawString(160, 95, "YOU HAVE DIED AND WON'T RESPAWN.", nil, "center")
		v.drawString(160, 105, "PRESS F12 TO WATCH ANOTHER PLAYER", nil, "center")
	end

end)
