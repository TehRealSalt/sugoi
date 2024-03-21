local psiAnims = {}

-- Brainshock
psiAnims[2] = {
	patchPrefix = "BRAINA",
	speed = 2,
	frames = 29,
	target = bConst.ANIMTARGET_ONE,
	vFlags = 0
}

-- DefenseDown
psiAnims[5] = {
	patchPrefix = "DEFDNA",
	speed = 3,
	frames = 28,
	target = bConst.ANIMTARGET_ONE,
	vFlags = 0
}

-- PK Fire
psiAnims[7] = {
	patchPrefix = "FIREA",
	speed = 3,
	frames = 13,
	target = bConst.ANIMTARGET_ROW,
	vFlags = 0
}

psiAnims[8] = {
	patchPrefix = "FIREB",
	speed = 3,
	frames = 16,
	target = bConst.ANIMTARGET_ROW,
	vFlags = 0
}

-- PK Flash
psiAnims[11] = {
	patchPrefix = "FLASHA",
	speed = 3,
	frames = 5,
	target = bConst.ANIMTARGET_ALL,
	vFlags = 0
}

-- PK Freeze
psiAnims[15] = {
	patchPrefix = "FREEZA",
	speed = 2,
	frames = 23,
	target = bConst.ANIMTARGET_ONE,
	vFlags = 0
}

psiAnims[16] = {
	patchPrefix = "FREEZB",
	speed = 2,
	frames = 22,
	target = bConst.ANIMTARGET_ONE,
	vFlags = 0
}

-- PK Speed
psiAnims[19] = {
	patchPrefix = "SPEEDA",
	speed = 2,
	frames = 31,
	target = bConst.ANIMTARGET_ALL,
	vFlags = 0
}

psiAnims[20] = {
	patchPrefix = "SPEEDB",
	speed = 2,
	frames = 48,
	target = bConst.ANIMTARGET_ALL,
	vFlags = 0
}

-- Paralysis
psiAnims[23] = {
	patchPrefix = "PARALA",
	speed = 3,
	frames = 26,
	target = bConst.ANIMTARGET_ONE,
	vFlags = 0
}

psiAnims[24] = {
	patchPrefix = "PARALO",
	speed = 3,
	frames = 26,
	target = bConst.ANIMTARGET_ALL,
	vFlags = 0
}

-- Magnet
psiAnims[25] = {
	patchPrefix = "MAGNTA",
	speed = 2,
	frames = 34,
	target = bConst.ANIMTARGET_ONE,
	vFlags = 0
}

psiAnims[26] = {
	patchPrefix = "MAGNTO",
	speed = 2,
	frames = 26,
	target = bConst.ANIMTARGET_ALL,
	vFlags = 0
}

-- Paralysis
psiAnims[28] = {
	patchPrefix = "HYPNOA",
	speed = 3,
	frames = 11,
	target = bConst.ANIMTARGET_ONE,
	vFlags = 0
}

psiAnims[29] = {
	patchPrefix = "HYPNOO",
	speed = 3,
	frames = 17,
	target = bConst.ANIMTARGET_ALL,
	vFlags = 0
}

-- PK Thunder
psiAnims[33] = {
	patchPrefix = "THNDRA",
	speed = 2,
	frames = 15,
	target = bConst.ANIMTARGET_THUNDER,
	vFlags = 0
}

-- Enemy PSIs
-- Fire
psiAnims[36] = {
	patchPrefix = "PENEMA",
	speed = 1,
	frames = 28,
	target = bConst.ANIMTARGET_ALL,
	vFlags = V_50TRANS
}

-- Defense Down
psiAnims[39] = {
	patchPrefix = "PENEMB",
	speed = 1,
	frames = 28,
	target = bConst.ANIMTARGET_ALL,
	vFlags = V_50TRANS
}

-- Flash
psiAnims[40] = {
	patchPrefix = "PENEMC",
	speed = 1,
	frames = 28,
	target = bConst.ANIMTARGET_ALL,
	vFlags = V_50TRANS
}

-- Freeze
psiAnims[41] = {
	patchPrefix = "PENEMD",
	speed = 1,
	frames = 28,
	target = bConst.ANIMTARGET_ALL,
	vFlags = V_50TRANS
}

-- Speed
psiAnims[42] = {
	patchPrefix = "PENEME",
	speed = 1,
	frames = 28,
	target = bConst.ANIMTARGET_ALL,
	vFlags = V_50TRANS
}

-- Paralysis
psiAnims[43] = {
	patchPrefix = "PENEMF",
	speed = 1,
	frames = 28,
	target = bConst.ANIMTARGET_ALL,
	vFlags = V_50TRANS
}

-- Magnet
psiAnims[44] = {
	patchPrefix = "PENEMG",
	speed = 1,
	frames = 28,
	target = bConst.ANIMTARGET_ALL,
	vFlags = V_50TRANS
}

-- Thunder
psiAnims[46] = {
	patchPrefix = "PENEMI",
	speed = 1,
	frames = 28,
	target = bConst.ANIMTARGET_ALL,
	vFlags = V_50TRANS
}

-- Shield
psiAnims[50] = {
	patchPrefix = "SHLDA",
	speed = 2,
	frames = 21,
	target = bConst.ANIMTARGET_ALL,
	vFlags = V_50TRANS
}

psiAnims[51] = {
	patchPrefix = "SHLDB",
	speed = 2,
	frames = 21,
	target = bConst.ANIMTARGET_ALL,
	vFlags = V_50TRANS
}

-- PSI Shield
psiAnims[52] = {
	patchPrefix = "PSHLDA",
	speed = 2,
	frames = 21,
	target = bConst.ANIMTARGET_ALL,
	vFlags = V_50TRANS
}


local PSITYPE_OFFENSE = 1
local PSITYPE_RECOVER = 2
local PSITYPE_ASSIST = 3

local STRENGTH_ALPHA = "["
local STRENGTH_BETA = "\\"
local STRENGTH_GAMMA = "]"
local STRENGTH_OMEGA = "_"
local STRENGTH_SIGMA = "^"

local psiTable = {}
-- PK Speed
psiTable[1] = {
	action = 10,
	name = "PK Speed",
	strength = STRENGTH_ALPHA,
	text = nil, -- TODO
	type = PSITYPE_OFFENSE,
	menuX = 1
}

psiTable[2] = {
	action = 11,
	name = "PK Speed",
	strength = STRENGTH_BETA,
	text = nil, -- TODO
	type = PSITYPE_OFFENSE,
	menuX = 2
}

-- PK Fire
psiTable[5] = {
	action = 14,
	name = "PK Fire",
	strength = STRENGTH_ALPHA,
	text = nil, -- TODO
	type = PSITYPE_OFFENSE,
	menuX = 1
}

psiTable[6] = {
	action = 15,
	name = "PK Fire",
	strength = STRENGTH_BETA,
	text = nil, -- TODO
	type = PSITYPE_OFFENSE,
	menuX = 2
}

-- PK Freeze
psiTable[9] = {
	action = 18,
	name = "PK Freeze",
	strength = STRENGTH_ALPHA,
	text = nil, -- TODO
	type = PSITYPE_OFFENSE,
	menuX = 1
}

psiTable[10] = {
	action = 19,
	name = "PK Freeze",
	strength = STRENGTH_BETA,
	text = nil, -- TODO
	type = PSITYPE_OFFENSE,
	menuX = 2
}

-- PK Thunder
psiTable[13] = {
	action = 22,
	name = "PK Thunder",
	strength = STRENGTH_ALPHA,
	text = nil,
	type = PSITYPE_OFFENSE,
	menuX = 1
}

psiTable[14] = {
	action = 23,
	name = "PK Thunder",
	strength = STRENGTH_BETA,
	text = nil,
	type = PSITYPE_OFFENSE,
	menuX = 2
}

-- PK Flash
psiTable[17] = {
	action = 26,
	name = "PK Flash",
	strength = STRENGTH_ALPHA,
	text = nil, -- TODO
	type = PSITYPE_OFFENSE,
	menuX = 1
}

-- Lifeup
psiTable[23] = {
	action = 32,
	name = "Lifeup",
	strength = STRENGTH_ALPHA,
	text = nil, -- TODO
	type = PSITYPE_RECOVER,
	menuX = 1
}

psiTable[24] = {
	action = 33,
	name = "Lifeup",
	strength = STRENGTH_BETA,
	text = nil, -- TODO
	type = PSITYPE_RECOVER,
	menuX = 2
}

-- Healing
psiTable[27] = {
	action = 36,
	name = "Healing",
	strength = STRENGTH_ALPHA,
	text = nil, -- TODO
	type = PSITYPE_RECOVER,
	menuX = 1
}

psiTable[28] = {
	action = 37,
	name = "Healing",
	strength = STRENGTH_BETA,
	text = nil, -- TODO
	type = PSITYPE_RECOVER,
	menuX = 2
}

-- Shield
psiTable[31] = {
	action = 40,
	name = "Shield",
	strength = STRENGTH_ALPHA,
	text = nil,
	type = PSITYPE_ASSIST,
	menuX = 1
}

psiTable[32] = {
	action = 42,
	name = "Shield",
	strength = STRENGTH_SIGMA,
	text = nil,
	type = PSITYPE_ASSIST,
	menuX = 2
}

psiTable[33] = {
	action = 41,
	name = "Shield",
	strength = STRENGTH_BETA,
	text = nil,
	type = PSITYPE_ASSIST,
	menuX = 3
}

-- PSI Shield
psiTable[35] = {
	action = 44,
	name = "PSI Shield",
	strength = STRENGTH_ALPHA,
	text = nil,
	type = PSITYPE_ASSIST,
	menuX = 1
}

psiTable[36] = {
	action = 46,
	name = "PSI Shield",
	strength = STRENGTH_SIGMA,
	text = nil,
	type = PSITYPE_ASSIST,
	menuX = 2
}

psiTable[41] = {
	action = 50,
	name = "Defense down",
	strength = STRENGTH_ALPHA,
	text = nil,
	type = PSITYPE_ASSIST,
	menuX = 1
}

-- Hypnosis
psiTable[43] = {
	action = 52,
	name = "Hypnosis",
	strength = STRENGTH_ALPHA,
	text = nil,
	type = PSITYPE_ASSIST,
	menuX = 1
}

psiTable[44] = {
	action = 53,
	name = "Hypnosis",
	strength = STRENGTH_OMEGA,
	text = nil,
	type = PSITYPE_ASSIST,
	menuX = 2
}

-- PSI Magnet
psiTable[45] = {
	action = 54,
	name = "PSI Magnet",
	strength = STRENGTH_ALPHA,
	text = nil,
	type = PSITYPE_RECOVER,
	menuX = 1
}

psiTable[46] = {
	action = 55,
	name = "PSI Magnet",
	strength = STRENGTH_OMEGA,
	text = nil,
	type = PSITYPE_RECOVER,
	menuX = 2
}

-- Paralysis
psiTable[47] = {
	action = 56,
	name = "Paralysis",
	strength = STRENGTH_ALPHA,
	text = nil,
	type = PSITYPE_ASSIST,
	menuX = 1
}

psiTable[48] = {
	action = 57,
	name = "Paralysis",
	strength = STRENGTH_OMEGA,
	text = nil,
	type = PSITYPE_ASSIST,
	menuX = 2
}

-- Brainshock
psiTable[49] = {
	action = 58,
	name = "Brainshock",
	strength = STRENGTH_ALPHA,
	text = nil,
	type = PSITYPE_ASSIST,
	menuX = 1
}

local function getPsiAnim(animNum)
	if not psiAnims[animNum] then
		print("getPsiAnim(): Invalid Animation number")
		return nil
	end
	return psiAnims[animNum]
end

local function getPsi(psiNum)
	if not psiTable[psiNum] then
		print("getPsi(): Invalid PSI number")
		return nil
	end
	return psiTable[psiNum]
end

rawset(_G, "getPsiAnim", getPsiAnim)
rawset(_G, "getPsi", getPsi)
