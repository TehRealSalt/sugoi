freeslot(
"sfx_curhor",
"sfx_curver",
"sfx_cursel",
"sfx_aattck",
"sfx_eattck",
"sfx_attckp",
"sfx_asmash",
"sfx_esmash",
"sfx_bash",
"sfx_ahit",
"sfx_mortal",
"sfx_miss",
"sfx_dodge",
"sfx_helpca",
"sfx_adie",
"sfx_edie",
"sfx_psi1",
"sfx_psi2",
"sfx_psi3",
"sfx_ailed",
"sfx_heal",
"sfx_hpheal",
"sfx_statdn",
"sfx_statup",
"sfx_brain1",
"sfx_brain2",
"sfx_fire1",
"sfx_fire2",
"sfx_fire3",
"sfx_fire4",
"sfx_flash1",
"sfx_flash2",
"sfx_flash3",
"sfx_flash4",
"sfx_flash5",
"sfx_flash6",
"sfx_flash7",
"sfx_freez1",
"sfx_freez2",
"sfx_freez3",
"sfx_freez4",
"sfx_storm1",
"sfx_storm2",
"sfx_storm3",
"sfx_storm4",
"sfx_paral1",
"sfx_paral2",
"sfx_magnet",
"sfx_hypnos",
"sfx_talked",
"sfx_thndr1",
"sfx_thndr2",
"sfx_shld1",
"sfx_shld2",
"sfx_rflct1",
"sfx_rflct2",
"MT_REDCRAWLABACK",
"MT_BLUECRAWLABACK",
"MT_BLONICCRAWLA",
"MT_BLONICATTACK",
"MT_TALKCHECK",
"S_TALKCHECK",
"MT_EDGYHEDGY",
"MT_BOINSCHOOLHOUSE",
"MT_TONI",
"SPR_BLOC",
"SPR_EDGY",
"SPR_BOIN",
"SPR_TONI",
"S_BLONICCRAWLA",
"S_EDGYHEDGY",
"S_BOINHELP1",
"S_BOINHELP2",
"S_CHEESEY"
)

states[S_BLONICCRAWLA] = {
	sprite = SPR_BLOC,
	frame = A,
	tics = -1,
	action = nil,
	var1 = 0,
	var2 = 0,
	nextstate = S_NULL
}

mobjinfo[MT_BLONICCRAWLA] = {
	//$Name Blonic Crawla
	//$Sprite BLOCA0
	//$Category SUGOI NPCs
	doomednum = 3754,
	spawnstate = S_BLONICCRAWLA,
	spawnhealth = 1,
	seestate = S_NULL,
	seesound = sfx_None,
	reactiontime = 0,
	attacksound = sfx_None,
	painstate = S_NULL,
	painchance = 0,
	painsound = sfx_None,
	meleestate = S_NULL,
	missilestate = S_NULL,
	deathstate = S_XPLD1,
	xdeathstate = S_NULL,
	deathsound = sfx_pop,
	speed = 0,
	radius = 63*FRACUNIT,
	height = 100*FRACUNIT,
	dispoffset = 0,
	mass = 0,
	damage = 1,
	activesound = sfx_None,
	flags = MF_SOLID,
	raisestate = S_NULL
}

mobjinfo[MT_TALKCHECK] = {
	doomednum = -1,
	spawnstate = S_TALKCHECK,
	spawnhealth = 1,
	seestate = S_NULL,
	seesound = sfx_None,
	reactiontime = 0,
	attacksound = sfx_None,
	painstate = S_NULL,
	painchance = MT_NULL,
	painsound = sfx_None,
	meleestate = S_NULL,
	missilestate = S_NULL,
	deathstate = S_NULL,
	xdeathstate = S_NULL,
	deathsound = sfx_None,
	speed = 0,
	radius = 16*FRACUNIT,
	height = 48*FRACUNIT,
	dispoffset = 0,
	mass = 0,
	damage = 0,
	activesound = sfx_None,
	flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT,
	raisestate = S_NULL
}

states[S_TALKCHECK] = {
	sprite = SPR_NULL,
	frame = A,
	tics = 1,
	action = nil,
	var1 = 0,
	var2 = 0,
	nextstate = S_NULL
}

states[S_EDGYHEDGY] = {
	sprite = SPR_EDGY,
	frame = A,
	tics = -1,
	action = nil,
	var1 = 0,
	var2 = 0,
	nextstate = S_NULL
}

mobjinfo[MT_EDGYHEDGY] = {
	//$Name Edgy Hedgy
	//$Sprite EDGYA0
	//$Category SUGOI Decoration
	doomednum = 3755,
	spawnstate = S_EDGYHEDGY,
	spawnhealth = 1,
	seestate = S_NULL,
	seesound = sfx_None,
	reactiontime = 0,
	attacksound = sfx_None,
	painstate = S_NULL,
	painchance = 0,
	painsound = sfx_None,
	meleestate = S_NULL,
	missilestate = S_NULL,
	deathstate = S_NULL,
	xdeathstate = S_NULL,
	deathsound = sfx_None,
	speed = 0,
	radius = 16*FRACUNIT,
	height = 48*FRACUNIT,
	dispoffset = 0,
	mass = 0,
	damage = 1,
	activesound = sfx_None,
	flags = MF_SOLID,
	raisestate = S_NULL
}

states[S_BOINHELP1] = {
	sprite = SPR_BOIN,
	frame = A,
	tics = 14,
	action = nil,
	var1 = 0,
	var2 = 0,
	nextstate = S_BOINHELP2
}

states[S_BOINHELP2] = {
	sprite = SPR_BOIN,
	frame = B,
	tics = 14,
	action = nil,
	var1 = 0,
	var2 = 0,
	nextstate = S_BOINHELP1
}

mobjinfo[MT_BOINSCHOOLHOUSE] = {
	//$Name Shadow Bother Tutorial
	//$Sprite BOINA0
	//$Category SUGOI NPCs
	doomednum = 3756,
	spawnstate = S_BOINHELP1,
	spawnhealth = 1,
	seestate = S_NULL,
	seesound = sfx_None,
	reactiontime = 0,
	attacksound = sfx_None,
	painstate = S_NULL,
	painchance = 0,
	painsound = sfx_None,
	meleestate = S_NULL,
	missilestate = S_NULL,
	deathstate = S_NULL,
	xdeathstate = S_NULL,
	deathsound = sfx_None,
	speed = 0,
	radius = 45*FRACUNIT,
	height = 120*FRACUNIT,
	dispoffset = 0,
	mass = 0,
	damage = 1,
	activesound = sfx_None,
	flags = MF_SOLID,
	raisestate = S_NULL
}

states[S_CHEESEY] = {
	sprite = SPR_TONI,
	frame = A,
	tics = -1,
	action = nil,
	var1 = 0,
	var2 = 0,
	nextstate = S_NULL
}

mobjinfo[MT_TONI] = {
	//$Name tOni
	//$Sprite TONIA0
	//$Category SUGOI NPCs
	doomednum = 3757,
	spawnstate = S_CHEESEY,
	spawnhealth = 1,
	seestate = S_NULL,
	seesound = sfx_None,
	reactiontime = 0,
	attacksound = sfx_None,
	painstate = S_NULL,
	painchance = 0,
	painsound = sfx_None,
	meleestate = S_NULL,
	missilestate = S_NULL,
	deathstate = S_NULL,
	xdeathstate = S_NULL,
	deathsound = sfx_None,
	speed = 0,
	radius = 87*FRACUNIT,
	height = 174*FRACUNIT,
	dispoffset = 0,
	mass = 0,
	damage = 1,
	activesound = sfx_None,
	flags = MF_SOLID,
	raisestate = S_NULL
}

-- A global constansts table for any constansts that more than one of my scripts need
rawset(_G, "bConst", {})
bConst.SWIRL_DURATION = 3 * TICRATE + 18

-- PSI Animation targets
bConst.ANIMTARGET_ONE = 1
bConst.ANIMTARGET_ROW = 2
bConst.ANIMTARGET_ALL = 3
bConst.ANIMTARGET_THUNDER = 4

-- lower statuses replace higher ones of the same type
-- There are also feeling strange, unable to concentrate, and homesickness that are stored in the party/enemy tables
-- STATUS1 is permanenent statuses
bConst.STATUS1_FAINTED = 1
bConst.STATUS1_DIAMONDIZED = 2
bConst.STATUS1_PARALYSIS = 3
bConst.STATUS1_NAUSEA = 4
bConst.STATUS1_POISON = 5
bConst.STATUS1_SUNSTROKE = 6
bConst.STATUS1_COLD = 7

-- STATUS2 is special statuses
bConst.STATUS2_MASHROOMED = 1
bConst.STATUS2_POSSESSED = 2

--STATUS3 is in-battle only
bConst.STATUS3_SLEEP = 1
bConst.STATUS3_CRYING = 2
bConst.STATUS3_IMMOBILIZED = 3
bConst.STATUS3_SOLIDIFIED = 4

-- attack direction
bConst.ACTIONDIR_ENEMY = 1
bConst.ACTIONDIR_PARTY = 2

-- attack target
bConst.ACTIONTARGET_ONE = 1
bConst.ACTIONTARGET_ROW = 2
bConst.ACTIONTARGET_ALL = 3
bConst.ACTIONTARGET_NONE = 4
