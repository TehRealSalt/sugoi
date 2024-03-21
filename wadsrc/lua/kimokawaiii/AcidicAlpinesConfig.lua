/*
Acidic Alpines Zone Object Config
	by Lach

v1
*/

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

SafeFreeslot("SPR_ALPF", "SPR_AALP", "S_AALPCLOUD",
	"S_AALPFLOWER1", "S_AALPFLOWER2", "S_AALPFLOWER3", "S_AALPFLOWER4", "S_AALPFLOWER5", "S_AALPROSE",
	"S_AALPCANNON", "S_AALPCAPSULE1", "S_AALPCAPSULE2", "S_AALPDUST1", "S_AALPDUST2", "S_AALPDUST3",
	"S_AALPSIGNEXPLODE1", "S_AALPSIGNEXPLODE2", "S_AALPBOSS_PAIN", "S_AALPBOSS_DEATH",
	"MT_AALPFLOWER", "MT_AALPROSE",
	"MT_AALPCAPSULE", "MT_AALPSPAWNER", "MT_AALPEGGROBO", "MT_AALPBOSS", "MT_AALPCANNON", "MT_AALPCUCKOO")

// Flower

states[S_AALPFLOWER1] = {
	sprite = SPR_ALPF,
	frame = 12|FF_ANIMATE,
	var1 = 39,
	var2 = 3,
	tics = 9,
	nextstate = S_AALPFLOWER2
}

states[S_AALPFLOWER2] = {
	sprite = SPR_ALPF,
	frame = 15|FF_ANIMATE,
	var1 = 39,
	var2 = 2,
	tics = 10,
	nextstate = S_AALPFLOWER3
}

states[S_AALPFLOWER3] = {
	sprite = SPR_ALPF,
	frame = 20|FF_ANIMATE,
	var1 = 39,
	var2 = 1,
	tics = 23,
	nextstate = S_AALPFLOWER4
}

states[S_AALPFLOWER4] = {
	sprite = SPR_ALPF,
	frame = 43|FF_ANIMATE,
	var1 = 39,
	var2 = 2,
	tics = 10,
	nextstate = S_AALPFLOWER5
}

states[S_AALPFLOWER5] = {
	sprite = SPR_ALPF,
	frame = 48|FF_ANIMATE,
	var1 = 39,
	var2 = 3,
	tics = 12,
	nextstate = S_AALPFLOWER1
}

mobjinfo[MT_AALPFLOWER] = {
	--$Name Acidic Alpines Flower
	--$Sprite ALPFM0
	--$Category SUGOI Decoration
	--$Flags8Text Cave variant
	doomednum = 2780,
	spawnhealth = 1000,
	height = 48*FRACUNIT,
	radius = 16*FRACUNIT,
	flags = MF_SCENERY,
	spawnstate = S_AALPFLOWER1
}

// Rose

states[S_AALPROSE] = {
	sprite = SPR_ALPF,
	frame = E|FF_ANIMATE,
	var1 = 7,
	var2 = 3
}

mobjinfo[MT_AALPROSE] = {
	--$Name Acidic Alpines Rose
	--$Sprite ALPFE0
	--$Category SUGOI Decoration
	--$Flags8Text Cave variant
	doomednum = 2781,
	spawnhealth = 1000,
	height = 16*FRACUNIT,
	radius = 8*FRACUNIT,
	flags = MF_SCENERY,
	spawnstate = S_AALPROSE
}

// Sign states

sfxinfo[sfx_s259].caption = "Bang"

local function valid(mo)
	return mo and mo.valid
end

local function SignScream(mo, var1, var2)
	local radius = FixedDiv(mo.radius, mo.scale) << 1
	local height = FixedDiv(mo.height, mo.scale) << 1

	P_SpawnMobjFromMobj(mo,
		FixedMul(2*radius, P_RandomFixed()) - radius,
		FixedMul(2*radius, P_RandomFixed()) - radius,
		FixedMul(height, P_RandomFixed()), MT_SONIC3KBOSSEXPLODE)

	S_StartSound(mo, sfx_cybdth)

	if mo.extravalue2 == 0
		mo.extravalue2 = var1
	end

	mo.extravalue2 = $ - 1
	if mo.extravalue2 == 0
		mo.state = var2
	end
end

function A_AcidicAlpinesSignExplode(mo, var1)
	local angle = mo.angle
	local cur = mo

	// spawn boss or a sign
	if mo.type == MT_SIGN
		local boss = P_SpawnMobj(mo.x, mo.y, mo.ceilingz - mobjinfo[MT_AALPBOSS].height, MT_AALPBOSS)
		boss.angle = mo.angle
		boss.spawnpoint = mo.spawnpoint
		angle = $ + ANGLE_90
	else
		local sign = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_SIGN)
		sign.angle = mo.angle
		sign.spawnpoint = mo.spawnpoint
		P_SetObjectMomZ(sign, 12*FRACUNIT)
	end

	// spawn invisible thok to play the sound
	local thok = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_THOK)
	thok.tics = $ * 2
	thok.flags2 = $ | MF2_DONTDRAW
	S_StartSound(thok, var1) // bang!

	repeat // spawn cool junks
		local part = P_SpawnMobjFromMobj(cur, 0, 0, 0, MT_BOSSJUNK)
		P_SetMobjStateNF(part, cur.state)
		part.color = cur.color
		part.angle = cur.angle
		P_InstaThrust(part, angle + (cur ~= mo and ANGLE_180 or 0), 4*part.scale)
		P_SetObjectMomZ(part, 8*part.scale)
		part.tics = TICRATE // MT_BOSSJUNK ignores fuse :v but all the states we use this on have S_NULL nextstates, so this should be ok

		part = cur
		cur = cur.tracer
		P_RemoveMobj(part)
	until not valid(cur)
end

states[S_AALPSIGNEXPLODE1] = {
	sprite = SPR_SIGN,
	frame = A,
	tics = 2,
	action = SignScream,
	var1 = 20,
	var2 = S_AALPSIGNEXPLODE2, // A_Repeat, but var2 and nextstate are inverted
	nextstate = S_AALPSIGNEXPLODE1
}

states[S_AALPSIGNEXPLODE2] = {
	sprite = SPR_SIGN,
	frame = A,
	tics = 0,
	action = A_AcidicAlpinesSignExplode,
	var1 = sfx_s259
}

// Capsule

local function AcidicDust(mo, var1, var2)
	mo.frame = $ + P_RandomKey(3) + P_RandomKey(2)*FF_HORIZONTALFLIP
	A_SetRandomTics(mo, var1, var2)
end

states[S_AALPCAPSULE1] = {
	sprite = SPR_AALP,
	tics = 20,
	nextstate = S_AALPCAPSULE2
}

states[S_AALPCAPSULE2] = {
	sprite = SPR_AALP,
	frame = B|FF_FULLBRIGHT,
	tics = 4,
	nextstate = S_AALPCAPSULE1
}

states[S_AALPDUST1] = {
	sprite = SPR_ADST,
	action = AcidicDust,
	var1 = 5,
	var2 = 7,
	nextstate = S_AALPDUST2
}

states[S_AALPDUST2] = {
	sprite = SPR_ADST,
	frame = 3|FF_TRANS40,
	action = AcidicDust,
	var1 = 5,
	var2 = 7,
	nextstate = S_AALPDUST3
}

states[S_AALPDUST3] = {
	sprite = SPR_ADST,
	frame = 6|FF_TRANS80,
	action = AcidicDust,
	var1 = 5,
	var2 = 7
}

mobjinfo[MT_AALPCAPSULE] = {
	height = 32*FRACUNIT,
	radius = 16*FRACUNIT,
	speed = 2*FRACUNIT,
	spawnhealth = 1,
	painchance = ANG2*2,
	flags = MF_PAIN|MF_SPECIAL|MF_SHOOTABLE|MF_BOUNCE,
	spawnstate = S_AALPCAPSULE1,
	deathsound = sfx_cybdth,
	deathstate = S_SONIC3KBOSSEXPLOSION1,
	raisestate = 3*TICRATE/2
}

// Capsule spawner

mobjinfo[MT_AALPSPAWNER] = {
	--$Name Acidic Alpines Capsule Spawner
	--$Sprite AALPB0
	--$Category SUGOI Items & Hazards
	--$AngleText Tag
	doomednum = 2782,
	spawnhealth = 1000,
	spawnstate = S_INVISIBLE,
	flags = MF_SCENERY|MF_NOGRAVITY|MF_SPAWNCEILING
}

// Eggrobo (spawner)

mobjinfo[MT_AALPEGGROBO] = {
	height = mobjinfo[MT_EGGROBO1].height,
	radius = mobjinfo[MT_EGGROBO1].radius,
	speed = 32*FRACUNIT,
	painchance = 128*FRACUNIT,
	spawnhealth = 1000,
	spawnstate = S_EGGROBO1_STND,
	meleestate = S_EGGROBO1_BSLAP1,
	reactiontime = 36*3,
	seesound = sfx_s3ka0,
	activesound = sfx_mspogo,
	attacksound = sfx_bsnipe,
	flags = MF_NOGRAVITY|MF_SPECIAL
}

// Eggrobo (boss)

local function Halt(mo)
	mo.momx = 0
	mo.momy = 0
	mo.momz = 0
end

states[S_AALPBOSS_PAIN] = {
	sprite = SPR_EGR1,
	frame = FF_ANIMATE|D,
	tics = TICRATE,
	action = A_Pain,
	var1 = 1,
	var2 = 2,
	nextstate = S_EGGROBO1_STND
}

states[S_AALPBOSS_DEATH] = {
	sprite = SPR_EGR1,
	frame = FF_ANIMATE|D,
	action = Halt,
	tics = 3*TICRATE/2,
	var1 = 1,
	var2 = 2
}

mobjinfo[MT_AALPBOSS] = {
	height = mobjinfo[MT_EGGROBO1].height,
	radius = mobjinfo[MT_EGGROBO1].radius,
	spawnhealth = 6, // miniboss health!
	speed = 16*FRACUNIT,
	painchance = 48*FRACUNIT,
	spawnstate = S_EGGROBO1_STND,
	seestate = S_EGGROBO1_PISSED,
	painstate = S_AALPBOSS_PAIN,
	deathstate = S_AALPBOSS_DEATH,
	meleestate = S_EGGROBO1_BSLAP1,
	reactiontime = 36,
	seesound = sfx_s3ka0,
	activesound = sfx_mspogo,
	attacksound = sfx_bsnipe,
	painsound = sfx_dmpain,
	deathsound = mobjinfo[MT_EGGMOBILE].deathsound,
	flags = MF_NOGRAVITY|MF_SPECIAL|MF_BOSS|MF_SHOOTABLE|MF_BOUNCE
}

// Eggrobo cannon

states[S_AALPCANNON] = {
	sprite = SPR_AALP,
	frame = C
}

mobjinfo[MT_AALPCANNON] = {
	radius = 20*FRACUNIT,
	height = 80*FRACUNIT,
	speed = 16*FRACUNIT,
	painchance = 16*FRACUNIT,
	spawnhealth = 1000,
	spawnstate = S_AALPCANNON,
	activesound = sfx_s3k4d,
	flags = MF_NOGRAVITY
}

// Cuckoo (boss flicky ghost things)

sfxinfo[sfx_3db09].caption = "Chirp"

mobjinfo[MT_AALPCUCKOO] = {
	spawnhealth = 1000,
	spawnstate = S_FLICKY_01_STAND,
	height = mobjinfo[MT_FLICKY_01].height,
	radius = mobjinfo[MT_FLICKY_01].radius,
	flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_NOCLIPTHING|MF_NOCLIPHEIGHT|MF_SCENERY|MF_NOGRAVITY,
	seesound = sfx_3db09,
	painchance = ANG2*2
}

// Cloud

local function RandomFrame(mo, var1, var2)
	mo.frame = $ & ~FF_FRAMEMASK | P_RandomRange(var1, var2)
end

states[S_AALPCLOUD] = {
	sprite = SPR_ALPF,
	frame = FF_PAPERSPRITE,
	tics = -1,
	action = RandomFrame,
	var1 = A,
	var2 = D
}

