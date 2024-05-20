//thonkframes list:

addHook("ThinkFrame", function()
	// Sal: Only run on DWZ & DS
	if (mapheaderinfo[gamemap].darkstabot)
	or (mapheaderinfo[gamemap].dwz)
		P_Activate8()
		P_Activate9()
		//P_Activate10()
		P_Activate18()
	end
end)

//Dark stabot main script

freeslot(
	"S_RLIT1",
	"S_RLIT2",
	"S_RLIT3",
	"S_RLIT4",
	"S_RLIT5",
	"S_RLIT6",
	"S_RLIT7",
	"S_RLIT8",
	"SPR_LIGH"
)

states[S_RLIT1] = {SPR_NULL, A, 35, nil, 0, 0, S_RLIT2}
states[S_RLIT2] = {SPR_LIGH, A, 1, A_SetObjectFlags, MF_PAIN, 0, S_RLIT3}
states[S_RLIT3] = {SPR_LIGH, B, 1, A_PlaySound, sfx_litng1, 1, S_RLIT4}
states[S_RLIT4] = {SPR_LIGH, C, 1, nil, 0, 0, S_RLIT5}
states[S_RLIT5] = {SPR_LIGH, D, 1, nil, 0, 0, S_RLIT6}
states[S_RLIT6] = {SPR_LIGH, E, 1, nil, 0, 0, S_RLIT7}
states[S_RLIT7] = {SPR_LIGH, F, 1, nil, 0, 0, S_RLIT8}
states[S_RLIT8] = {SPR_LIGH, G, 1, nil, 0, 0, S_NULL}

-- Sal: Moved from intro script
freeslot(
	"S_LIT1",
	"S_LIT2",
	"S_LIT3",
	"S_LIT4",
	"S_LIT5",
	"S_LIT6",
	"S_LIT7"
)

freeslot("S_CHEESEBASH1")

states[S_LIT1] = {SPR_LIGH, A, 1, nil, 0, 0, S_LIT2}
states[S_LIT2] = {SPR_LIGH, B, 1, nil, 0, 0, S_LIT3}
states[S_LIT3] = {SPR_LIGH, C, 1, nil, 0, 0, S_LIT4}
states[S_LIT4] = {SPR_LIGH, D, 1, nil, 0, 0, S_LIT5}
states[S_LIT5] = {SPR_LIGH, E, 1, nil, 0, 0, S_LIT6}
states[S_LIT6] = {SPR_LIGH, F, 1, nil, 0, 0, S_LIT7}
states[S_LIT7] = {SPR_LIGH, G, 1, nil, 0, 0, S_NULL}

freeslot(
	"S_ROLLMEBABY1",
	"S_ROLLMEBABY2",
	"S_ROLLMEBABY3",
	"S_ROLLMEBABY4"
)

states[S_ROLLMEBABY1] = {SPR_NULL, A, 1, nil, 322, 0, S_ROLLMEBABY2}
states[S_ROLLMEBABY2] = {SPR_NULL, A, 1, nil, 0, 0, S_ROLLMEBABY3}
states[S_ROLLMEBABY3] = {SPR_NULL, A, 1, A_RotateSpikeBall, 0, 0, S_ROLLMEBABY4}
states[S_ROLLMEBABY4] = {SPR_NULL, A, 0, A_CheckBuddy, 0, 0, S_ROLLMEBABY3}

freeslot(
	"S_EXPLOSION1",
	"S_EXPLOSION2",
	"S_EXPLOSION3",
	"S_EXPLOSION4",
	"S_EXPLOSION5",
	"S_EXPLOSION6",
	"S_EXPLOSION7",
	"S_EXPLOSION8"
)

freeslot(
	"S_2EXPLOSION1",
	"S_2EXPLOSION2",
	"S_2EXPLOSION3",
	"S_2EXPLOSION4",
	"S_2EXPLOSION5",
	"S_2EXPLOSION6",
	"S_2EXPLOSION7",
	"S_2EXPLOSION8"
)

states[S_2EXPLOSION1] = {SPR_NULL, A, 1, A_NapalmScatter, MT_BOSSEXPLODE+(1<<16), 24<<16, S_2EXPLOSION2}
states[S_2EXPLOSION2] = {SPR_NULL, A, 1, A_NapalmScatter, MT_BOSSEXPLODE+(4<<16), 64+(32<<16), S_2EXPLOSION3}
states[S_2EXPLOSION3] = {SPR_NULL, A, 1, A_NapalmScatter, MT_BOSSEXPLODE+(6<<16), 128+(40<<16), S_2EXPLOSION4}
states[S_2EXPLOSION4] = {SPR_NULL, A, 1, A_NapalmScatter, MT_BOSSEXPLODE+(8<<16), 192+(48<<16), S_2EXPLOSION5}
states[S_2EXPLOSION5] = {SPR_NULL, A, 1, A_NapalmScatter, MT_BOSSEXPLODE+(1<<16), 40<<16, S_2EXPLOSION6}
states[S_2EXPLOSION6] = {SPR_NULL, A, 1, A_NapalmScatter, MT_BOSSEXPLODE+(4<<16), 74+(32<<16), S_2EXPLOSION7}
states[S_2EXPLOSION7] = {SPR_NULL, A, 1, A_NapalmScatter, MT_BOSSEXPLODE+(6<<16), 138+(40<<16), S_2EXPLOSION8}
states[S_2EXPLOSION8] = {SPR_NULL, A, 1, A_NapalmScatter, MT_BOSSEXPLODE+(8<<16), 202+(48<<16), S_NULL}

freeslot(
	"MT_CRAWLAFIRE",
	"S_CRAWLAFIRE1",
	"S_CRAWLAFIRE2",
	"S_CRAWLAFIRE3"
)

mobjinfo[MT_CRAWLAFIRE] = {
	doomednum = -1,
	spawnstate = S_CRAWLAFIRE1,
	seestate = S_CRAWLAFIRE1,
	deathstate = S_EXPLOSION1,
	spawnhealth = 1,
	radius = 30*FRACUNIT,
	height = 30*FRACUNIT,
	flags = MF_SPECIAL|MF_NOGRAVITY|MF_FLOAT|MF_MISSILE
}

states[S_CRAWLAFIRE1] = {SPR_FLME, A|FF_FULLBRIGHT, 4, nil, 0, 0, S_CRAWLAFIRE2}
states[S_CRAWLAFIRE2] = {SPR_FLME, B|FF_FULLBRIGHT, 5, nil, 0, 0, S_CRAWLAFIRE3}
states[S_CRAWLAFIRE3] = {SPR_FLME, C|FF_FULLBRIGHT, 1, nil, 0, 0, S_CRAWLAFIRE3}

states[S_EXPLOSION1] = {SPR_NULL, A, 1, A_NapalmScatter, MT_SMOKE+(1<<16), 24<<16, S_EXPLOSION2}
states[S_EXPLOSION2] = {SPR_NULL, A, 1, A_NapalmScatter, MT_SMOKE+(4<<16), 64+(32<<16), S_EXPLOSION3}
states[S_EXPLOSION3] = {SPR_NULL, A, 1, A_NapalmScatter, MT_SMOKE+(6<<16), 128+(40<<16), S_EXPLOSION4}
states[S_EXPLOSION4] = {SPR_NULL, A, 1, A_NapalmScatter, MT_SMOKE+(8<<16), 192+(48<<16), S_EXPLOSION5}
states[S_EXPLOSION5] = {SPR_NULL, A, 1, A_NapalmScatter, MT_SMOKE+(1<<16), 40<<16, S_EXPLOSION6}
states[S_EXPLOSION6] = {SPR_NULL, A, 1, A_NapalmScatter, MT_SMOKE+(4<<16), 74+(32<<16), S_EXPLOSION7}
states[S_EXPLOSION7] = {SPR_NULL, A, 1, A_NapalmScatter, MT_SMOKE+(6<<16), 138+(40<<16), S_EXPLOSION8}
states[S_EXPLOSION8] = {SPR_NULL, A, 1, A_NapalmScatter, MT_SMOKE+(8<<16), 202+(48<<16), S_NULL}

addHook("MobjThinker", function(fire)
if not fire return end

	if fire.timer == nil
		fire.timer = 0
	end

	if fire.pity == nil
		fire.pity = false
	end

	if fire and fire.valid
		P_SpawnGhostMobj(fire)
		fire.timer = $1 + 1

		if (fire.timer == 25)
		and (fire.target and fire.target.valid)
		and ((fire.target.state == S_DARKSTABOT_ATK2_4) or (fire.target.state == S_DARKSTABOT_ATK2_7) or (fire.target.state == S_DARKSTABOT_ATK2_10))
		and (fire.target.shieldbreak == true)
		and (fire.target.target and fire.target.target.valid)
			fire.target = fire.target.target
			fire.pity = true
			A_FireShot(fire, MT_CRAWLAFIRE, -35)
		end
	end

	if (fire and fire.valid)
	and (fire.pity == false)
	and (fire.target and fire.target.valid)
	and ((fire.target.state == S_DARKSTABOT_ATK2_4) or (fire.target.state == S_DARKSTABOT_ATK2_7) or (fire.target.state == S_DARKSTABOT_ATK2_10))
	and (fire.target.tics == 8)
	and (fire.target.shieldbreak == true)
	and (fire.target.target and fire.target.target.valid)
		local yay = R_PointToAngle2(fire.target.x,fire.target.y,fire.target.target.x,fire.target.target.y) + FixedAngle(P_RandomRange(-90,90)*FRACUNIT)
		P_Thrust(fire,yay,7*FRACUNIT)
		fire.momz = $1 + FRACUNIT
	end

end,MT_CRAWLAFIRE)

freeslot(
	"S_EFFECT1",
	"S_EFFECT2",
	"S_EFFECT3",
	"S_EFFECT4",
	"S_EFFECT5",
	"S_EFFECT6",
	"MT_EFFECT",
	"SPR_EFFT"
)

mobjinfo[MT_EFFECT] = {
	doomednum = -1,
	//$Sprite EFFTA0
	//$Name Effect
	spawnstate = S_EFFECT1,
	radius = 20*FRACUNIT,
	height = 40*FRACUNIT,
	flags = MF_FLOAT|MF_NOGRAVITY
}

states[S_EFFECT1] = {SPR_EFFT, A, 1, nil, 0, 0, S_EFFECT2}
states[S_EFFECT2] = {SPR_EFFT, B, 1, nil, 0, 0, S_EFFECT3}
states[S_EFFECT3] = {SPR_EFFT, C, 1, nil, 0, 0, S_EFFECT4}
states[S_EFFECT4] = {SPR_EFFT, D, 1, nil, 0, 0, S_EFFECT5}
states[S_EFFECT5] = {SPR_EFFT, E, 1, nil, 0, 0, S_EFFECT6}
states[S_EFFECT6] = {SPR_EFFT, F, 1, nil, 0, 0, S_NULL}

freeslot(
	"S_DARK_STABOT_INTRO1",
	"S_DARK_STABOT_INTRO2",
	"MT_DARK_STABOT_INTRO",
	"SPR_DCBF"
)

mobjinfo[MT_DARK_STABOT_INTRO] = {
	//$Sprite DCBFA1
	//$Name Dark Stabot Intro
	//$Category SUGOI NPCs
	doomednum = 2118,
	spawnstate = S_DARK_STABOT_INTRO1,
	seestate = S_DARK_STABOT_INTRO1,
	deathstate = S_DARK_STABOT_INTRO1,
	deathsound = sfx_dmpain,
	spawnhealth = 1000,
	radius = 30*FRACUNIT,
	height = 50*FRACUNIT
}

states[S_DARK_STABOT_INTRO1] = {SPR_DCBF, K, 1, nil, 0, 0, S_DARK_STABOT_INTRO1}
states[S_DARK_STABOT_INTRO2] = {SPR_DCBF, L, 1, nil, 0, 0, S_DARK_STABOT_INTRO2}

local cutscene5 = true
local cutscenemode5 = false
local cutscenetimer5 = 0
local playerCam = nil

addHook("NetVars", function(network)
	cutscene5 = network(cutscene5)
	cutscenetimer5 = network(cutscenetimer5)
	cutscenemode5 = network(cutscenemode5)
	playerCam = network(playerCam)
end)


local function CheckBot(line, mo)

	if cutscene5 == true
		cutscenemode5 = true
		mo.player.cutscenemode5 = true
	end

	if cutscenetimer5 >= 150
		P_DoPlayerExit(mo.player)
	end

end
addHook("LinedefExecute", CheckBot, "HHZ1C")

rawset(_G, "P_Activate8", function()

	if cutscenemode5 == true
		if cutscene5 == true
			cutscenetimer5 = $1 + 1
		else
			cutscenetimer5 = 0
		end
	end

    for player in players.iterate

		if player.cutscenemode5 == nil
			player.cutscenemode5 = false
		end

		if player.cutscenemode5 == true
			player.powers[pw_nocontrol] = 1
		end

		if player.mo and player.mo.valid
		and player.mo.animationrun2 == nil
			player.mo.animationrun2 = false
		end

		if player.mo and player.mo.valid
		and player.mo.animationrun2timer == nil
			player.mo.animationrun2timer = 0
		end

	    if player.mo and player.mo.valid
			if player.mo.animationrun2 == true
				if (player.mo.state != S_PLAY_RUN)
					player.mo.state = S_PLAY_RUN
				end
			end
		end
	end
end)

addHook("MobjThinker", function(stabber)

if not stabber return end

	for player in players.iterate
		if player.cutscenemode5 == true
        and cutscenetimer5 == 1

			sugoi.HUDShow("time", false)
			sugoi.HUDShow("lives", false)
			sugoi.HUDShow("score", false)
			sugoi.HUDShow("rings", false)

			playerCam = P_SpawnMobj(2880*FRACUNIT,3744*FRACUNIT,568*FRACUNIT,MT_CAMERA)
			playerCam.angle = FixedAngle(90*FRACUNIT)
			player.awayviewmobj = playerCam
			player.awayviewtics = 5
			player.dialog = true
			player.dialogtimer = 1
			player.dialogoption = 9
			player.dialogskipdelay = 75

		end
	end

	if cutscenetimer5 == 150
		P_SetMobjStateNF(stabber, S_DARK_STABOT_INTRO2)
		stabber.momz = $1 + 8*FRACUNIT
		S_StartSound(nil,sfx_cannon)
		P_Thrust(stabber,stabber.angle,9*FRACUNIT)
	end
end, MT_DARK_STABOT_INTRO)

addHook("MapLoad", do
	for player in players.iterate

		cutscenemode5 = false
		cutscenetimer5 = 0
		player.cutscenemode5 = false

		if (mapheaderinfo[gamemap].darkstabot) //if the boss arena is dark stabot's
			P_LinedefExecute(1012)
		end
	end
end)

local lastmap
addHook("MapChange", do
	-- sal: NO, you do not do hud changes EVERY time, you should do them when NEEDED
	if (lastmap != nil and mapheaderinfo[lastmap].darkstabot and gamemap != lastmap)
		sugoi.HUDShow("time", true)
		sugoi.HUDShow("lives", true)
		sugoi.HUDShow("score", true)
		sugoi.HUDShow("rings", true)
	end
	lastmap = gamemap
end)

freeslot(
	"sfx_swrd1",
	"sfx_swrd2",
	"sfx_boil",
	"sfx_aroar",
	"sfx_nani",
	"sfx_combt"
)

freeslot(
	"MT_DARKSTABOT",
	"S_DARKSTABOT_WALK1",
	"S_DARKSTABOT_WALK2",
	"S_DARKSTABOT_WALK3",
	"S_DARKSTABOT_WALK4",
	"S_DARKSTABOT_WALK5",
	"S_DARKSTABOT_WALK6",

	"S_DARKSTABOT1",
	"S_DARKSTABOT12",
	"S_DARKSTABOT2",
	"S_DARKSTABOT_PAIN1",

	"S_DARKSTABOT_ATK1_05",
	"S_DARKSTABOT_ATK1_1",
	"S_DARKSTABOT_ATK1_2",
	"S_DARKSTABOT_ATK1_3",
	"S_DARKSTABOT_ATK1_4",
	"S_DARKSTABOT_ATK1_5",

	"S_DARKSTABOT_ATK2_05",
	"S_DARKSTABOT_ATK2_1",
	"S_DARKSTABOT_ATK2_2",
	"S_DARKSTABOT_ATK2_3",
	"S_DARKSTABOT_ATK2_4",
	"S_DARKSTABOT_ATK2_5",
	"S_DARKSTABOT_ATK2_6",
	"S_DARKSTABOT_ATK2_7",
	"S_DARKSTABOT_ATK2_8",
	"S_DARKSTABOT_ATK2_9",
	"S_DARKSTABOT_ATK2_10",
	"S_DARKSTABOT_ATK2_11",

	"S_DARKSTABOT_ATK3_05",
	"S_DARKSTABOT_ATK3_1",
	"S_DARKSTABOT_ATK3_2",
	"S_DARKSTABOT_ATK3_3",
	"S_DARKSTABOT_ATK3_4",
	"S_DARKSTABOT_ATK3_5",

	"S_DARKSTABOT_PHASE2_RAGE1",
	"S_DARKSTABOT_PHASE2_RAGE2",
	"S_DARKSTABOT_PHASE2_RAGE3",
	"S_DARKSTABOT_PHASE2_RAGE4",
	"S_DARKSTABOT_PHASE2_RAGE5",
	"S_DARKSTABOT_PHASE2_RAGE6",
	"S_DARKSTABOT_PHASE2_RAGE7",
	"S_DARKSTABOT_PHASE2_RAGE8",

	"S_DARKSTABOT_PHASE3_RAGE1",
	"S_DARKSTABOT_PHASE3_RAGE2",
	"S_DARKSTABOT_PHASE3_RAGE3",
	"S_DARKSTABOT_PHASE3_RAGE4",
	"S_DARKSTABOT_PHASE3_RAGE5",
	"S_DARKSTABOT_PHASE3_RAGE6",
	"S_DARKSTABOT_PHASE3_RAGE7",
	"S_DARKSTABOT_PHASE3_RAGE8",

	"S_DARKSTABOT_CUTS1",

	"S_DARKSTABOT_BOIL",
	"S_DARKSTABOT_BLUR"
)

freeslot(
	"MT_RSNAPPER",

	"S_RSNAPPER_FORCE1",
	"S_RSNAPPER_FORCE2",
	"S_RSNAPPER_FORCE3",
	"S_RSNAPPER_FORCE4",
	"S_RSNAPPER_FORCE5",
	"S_RSNAPPER_FORCE6",

	"S_RSNAPPER_IDLE1",
	"S_RSNAPPER_IDLE2",
	"S_RSNAPPER_IDLE3",
	"S_RSNAPPER_IDLE4",
	"S_RSNAPPER_IDLE5",
	"S_RSNAPPER_BEFORECHOOSE",
	"S_RSNAPPER_CHOOSE",

	"S_RSNAPPER_ATK1_1",
	"S_RSNAPPER_ATK1_2",
	"S_RSNAPPER_ATK1_3",
	"S_RSNAPPER_ATK1_4",
	"S_RSNAPPER_ATK1_5",

	"S_RSNAPPER_ATK2_1",
	"S_RSNAPPER_ATK2_2",
	"S_RSNAPPER_ATK2_3",
	"S_RSNAPPER_ATK2_4",
	"S_RSNAPPER_ATK2_5",

	"S_RSNAPPER_ATK3_1",
	"S_RSNAPPER_ATK3_2",
	"S_RSNAPPER_ATK3_3",
	"S_RSNAPPER_ATK3_4",
	"S_RSNAPPER_ATK3_5",

	"S_RSNAPPER_PHASE3_1"
)

mobjinfo[MT_RSNAPPER] = {
	doomednum = -1,
	spawnstate = S_RSNAPPER_IDLE1,
	spawnhealth = 1,
	reactiontime = 32,
	painchance = 200,
	deathstate = S_XPLD1,
	deathsound = sfx_pop,
	speed = 3,
	radius = 24*FRACUNIT,
	height = 24*FRACUNIT,
	mass = 100,
	flags = MF_ENEMY|MF_SPECIAL|MF_SHOOTABLE,
};

freeslot(
	"SPR_DCBP",
	"SPR_RSNP",
	"S_SHIELD_PAIN",
	"S_SHIELD_PAIN2",
	"S_SHIELD_DEATH",
	"S_SHIELD_DEATH2",
	"S_SHIELD_DEATH3",
	"S_SHIELD_DEATH4",
	"SPR_DCPP"
)

states[S_SHIELD_PAIN] = {SPR_ESHI, A, 1, nil, 0, 0, S_SHIELD_PAIN2}
states[S_SHIELD_PAIN2] = {SPR_ESHI, B, 1, nil, 0, 0, S_SHIELD_PAIN}
states[S_SHIELD_DEATH] = {SPR_ESHI, C, 2, nil, 1, 1, S_SHIELD_DEATH2}
states[S_SHIELD_DEATH2] = {SPR_ESHI, D, 2, nil, 0, 0, S_SHIELD_DEATH3}
states[S_SHIELD_DEATH3] = {SPR_ESHI, E, 2, nil, 0, 0, S_SHIELD_DEATH4}
states[S_SHIELD_DEATH4] = {SPR_ESHI, F, 2, nil, 0, 0, S_NULL}

local cutscene6 = true
local cutscenemode6 = false
local cutscenetimer6 = 0

addHook("NetVars", function(network)
	cutscene6 = network(cutscene6)
	cutscenetimer6 = network(cutscenetimer6)
	cutscenemode6 = network(cutscenemode6)
end)

rawset(_G, "P_Activate9", function()
	if cutscenemode6 == true
		if cutscene6 == true
			cutscenetimer6 = $1 + 1
		else
			cutscenetimer6 = 0
		end
	end

    for player in players.iterate

		if player.cutscenemode6 == nil
			player.cutscenemode6 = false
		end

		if player.cutscenemode6 == true
			player.powers[pw_nocontrol] = 1
		end

		if player.mo and player.mo.valid
			if player.mo.animationcombat == nil
				player.mo.animationcombat = false
		    end

		    if player.mo.animationcombattimer == nil
				player.mo.animationcombattimer = 0
			end

			if player.mo.animationcombat == true
				if (player.mo.state != S_PLAY_ROLL)
					player.mo.state = S_PLAY_ROLL
				end
			end
		end
	end
end)

addHook("MapLoad", do
	for player in players.iterate

		if (mapheaderinfo[gamemap].darkstabot) //if the boss arena is dark stabot's
			cutscene6 = true
		end

		cutscenemode6 = false
		cutscenetimer6 = 0
		player.cutscenemode6 = false

	end
end)

addHook("MapChange", do
	for player in players.iterate

		if (mapheaderinfo[gamemap].darkstabot) //if the boss arena is dark stabot's
			cutscene6 = true
		end

		cutscenemode6 = false
		cutscenetimer6 = 0
		player.cutscenemode6 = false

	end
end)

function A_SpawnCharge(stabber,var1)
	local effect = P_SpawnMobj(stabber.x+FixedMul(70*FRACUNIT, sin(stabber.angle)),stabber.y+FixedMul(1*FRACUNIT, sin(stabber.angle)),stabber.z+125*FRACUNIT,MT_EFFECT)
	effect.color = var1
	S_StartSound(stabber,sfx_swrd1)
end

function A_SpawnChargeR(stabber,var1)
	local effect = P_SpawnMobj(stabber.x+FixedMul(50*FRACUNIT, sin(stabber.angle)),stabber.y+FixedMul(40*FRACUNIT, sin(stabber.angle)),stabber.z+10*FRACUNIT,MT_EFFECT)
	effect.color = var1
	S_StartSound(stabber,sfx_swrd2)
end

function A_Shake()
	P_StartQuake(10*FRACUNIT, 70)
	S_StartSound(nil,sfx_aroar)
end

function A_LongShake()
	P_StartQuake(10*FRACUNIT, 120)
	S_StartSound(nil,sfx_aroar)
end

function A_KnightHop(mo)
	mo.momz = $1 + 13*FRACUNIT
	P_Thrust(mo,mo.angle,50*FRACUNIT)
end

function A_TacticalJump(mo)
	if (mo.hang == false)
		mo.momz = $1 + 13*FRACUNIT
		P_Thrust(mo,mo.angle,20*FRACUNIT)
	end

	if (mo.hang == true)
	and (mo.tracer and mo.tracer.valid)
		mo.tracer.momz = $1 + 40*FRACUNIT
		P_Thrust(mo.tracer,mo.angle,50*FRACUNIT)
		mo.tracer.letitout = true
	end
end

function A_KnightDash(mo)
	if (mo and mo.valid)
	and (mo.hang == false)
		if (mo.shieldbreak == false)
			A_Thrust(mo,90,1)
		elseif (mo.shieldbreak == true)
			A_Thrust(mo,150,1)
		end
	end

	if (mo and mo.valid)
	and (mo.hang == true)
		if (mo.shieldbreak == false)
			A_Thrust(mo.tracer,20,1)
			mo.tracer.letitout = true
		elseif (mo.shieldbreak == true)
			A_Thrust(mo.tracer,45,1)
			mo.tracer.letitout = true
		end
	end
end

function A_SpawnThunderBlast(stabber,var1)
	local effect = P_SpawnMobj(stabber.x+FixedMul(50*FRACUNIT, sin(stabber.angle)),stabber.y+FixedMul(40*FRACUNIT, sin(stabber.angle)),stabber.z+10*FRACUNIT,MT_EFFECT)
	effect.state = S_LIT1
	effect.scale = 2*FRACUNIT
	S_StartSound(stabber,sfx_litng1)
end

mobjinfo[MT_DARKSTABOT] = {
	//$Sprite DCBFH1
	//$Name Dark Stabot
	//$Category SUGOI Bosses
	doomednum = 2119,
	spawnstate = S_DARKSTABOT_WALK1,
	seestate = S_DARKSTABOT_WALK1,
	painstate = S_DARKSTABOT_PAIN1,
	activesound = sfx_swrd2,
	attacksound = sfx_swrd1,
	deathstate = S_DARKSTABOT_CUTS1,
	deathsound = sfx_dmpain,
	spawnhealth = 8, -- Sal: Nerfed health. It already has the shield health mechanic, so it doesn't NEED more health than your typical boss.
	reactiontime = 50,
	painchance = 8,
	painsound = sfx_dmpain,
	speed = 5,
	radius = 50*FRACUNIT,
	height = 90*FRACUNIT,
	mass = 100,
	damage = 0,
	flags = MF_BOSS|MF_SHOOTABLE|MF_SPECIAL
}
states[S_DARKSTABOT_CUTS1] = {SPR_DCBF, A, 1, nil, 0, 0, S_DARKSTABOT_CUTS1}

states[S_DARKSTABOT1] = {SPR_DCBF, I, 1, nil, 0, 0, S_DARKSTABOT12}
states[S_DARKSTABOT12] = {SPR_DCBF, I, 15, A_PlaySound, sfx_swrd1, 0, S_DARKSTABOT2}
states[S_DARKSTABOT2] = {SPR_DCBF, H, 15, A_PlaySound, sfx_swrd2, 0, S_DARKSTABOT_WALK1}

states[S_DARKSTABOT_BOIL] = {SPR_DCBF, A, 40, nil, 0, 0, S_DARKSTABOT_ATK1_05}

states[S_DARKSTABOT_BLUR] = {SPR_DCBF, J|TR_TRANS50, 1, nil, 0, 0, S_DARKSTABOT_BLUR}

states[S_DARKSTABOT_PHASE2_RAGE1] = {SPR_DCBF, A, 40, A_PlaySound, sfx_boil, 0, S_DARKSTABOT_PHASE2_RAGE2}
states[S_DARKSTABOT_PHASE2_RAGE2] = {SPR_DCBF, I, 40, A_PlaySound, sfx_s3kbes, 0, S_DARKSTABOT_PHASE2_RAGE3}
states[S_DARKSTABOT_PHASE2_RAGE3] = {SPR_DCBF, H, 1, nil, 0, 0, S_DARKSTABOT_PHASE2_RAGE4}
states[S_DARKSTABOT_PHASE2_RAGE4] = {SPR_DCBF, H, 10, A_FindTarget, MT_RSNAPPER, 0, S_DARKSTABOT_PHASE2_RAGE5}
states[S_DARKSTABOT_PHASE2_RAGE5] = {SPR_DCBF, A, 1, A_FindTarget, MT_RSNAPPER, 0, S_DARKSTABOT_PHASE2_RAGE6}
states[S_DARKSTABOT_PHASE2_RAGE6] = {SPR_DCBF, I, 100, nil, 0, 0, S_DARKSTABOT_PHASE2_RAGE7}
states[S_DARKSTABOT_PHASE2_RAGE7] = {SPR_DCBF, H, 20, A_FaceTarget, 0, 0, S_DARKSTABOT_ATK1_05}

states[S_DARKSTABOT_PHASE3_RAGE1] = {SPR_DCBF, A, 40, A_PlaySound, sfx_boil, 0, S_DARKSTABOT_PHASE3_RAGE2}
states[S_DARKSTABOT_PHASE3_RAGE2] = {SPR_DCBF, I, 40, A_PlaySound, sfx_s3kbes, 0, S_DARKSTABOT_PHASE3_RAGE3}
states[S_DARKSTABOT_PHASE3_RAGE3] = {SPR_DCBF, H, 1, nil, 0, 0, S_DARKSTABOT_PHASE3_RAGE4}
states[S_DARKSTABOT_PHASE3_RAGE4] = {SPR_DCBF, H, 1, A_FindTarget, MT_RSNAPPER, 0, S_DARKSTABOT_PHASE3_RAGE5}
states[S_DARKSTABOT_PHASE3_RAGE5] = {SPR_DCBF, A, 1, A_FindTarget, MT_RSNAPPER, 0, S_DARKSTABOT_PHASE3_RAGE6}
states[S_DARKSTABOT_PHASE3_RAGE6] = {SPR_DCBF, H, 50, A_KnightHop, 0, 0, S_DARKSTABOT_PHASE3_RAGE7}
states[S_DARKSTABOT_PHASE3_RAGE7] = {SPR_DCBF, I, 20, A_SpawnCharge, SKINCOLOR_WHITE, 0, S_DARKSTABOT_PHASE3_RAGE8}
states[S_DARKSTABOT_PHASE3_RAGE8] = {SPR_DCBF, H, 20, A_FaceTarget, 0, 0, S_DARKSTABOT_ATK1_05}

states[S_RSNAPPER_FORCE1] = {SPR_GSNP, A, 15, nil, 0, 0, S_RSNAPPER_FORCE2}
states[S_RSNAPPER_FORCE2] = {SPR_GSNP, A, 90, A_FaceTracer, 0, 0, S_RSNAPPER_FORCE3}
states[S_RSNAPPER_FORCE3] = {SPR_RSNP, D, 47, nil, 0, 0, S_RSNAPPER_FORCE4}
states[S_RSNAPPER_FORCE4] = {SPR_RSNP, B, 70, A_Shake, 0, 0, S_RSNAPPER_FORCE5}
states[S_RSNAPPER_FORCE5] = {SPR_RSNP, A, 10, nil, 0, 0, S_RSNAPPER_IDLE1}

states[S_RSNAPPER_BEFORECHOOSE] = {SPR_RSNP, B, 70, A_Shake, 0, 0, S_RSNAPPER_CHOOSE}

states[S_RSNAPPER_IDLE1] = {SPR_RSNP, A, 2, A_Chase, 0, 0, S_RSNAPPER_IDLE2}
states[S_RSNAPPER_IDLE2] = {SPR_RSNP, B, 2, A_Chase, 0, 0, S_RSNAPPER_IDLE3}
states[S_RSNAPPER_IDLE3] = {SPR_RSNP, C, 2, A_Chase, 0, 0, S_RSNAPPER_IDLE4}
states[S_RSNAPPER_IDLE4] = {SPR_RSNP, D, 2, A_Chase, 0, 0, S_RSNAPPER_IDLE5}
states[S_RSNAPPER_IDLE5] = {SPR_RSNP, A, 0, A_Repeat, 8, S_RSNAPPER_IDLE1, S_RSNAPPER_BEFORECHOOSE}

states[S_RSNAPPER_CHOOSE] = {SPR_RSNP, A, 1, A_FaceTarget, 0, 0, S_RSNAPPER_CHOOSE}

states[S_RSNAPPER_ATK1_1] = {SPR_RSNP, D, 50, A_FaceTarget, 0, 0, S_RSNAPPER_ATK1_2}
states[S_RSNAPPER_ATK1_2] = {SPR_RSNP, B, 70, nil, 0, 0, S_RSNAPPER_IDLE1}

states[S_RSNAPPER_ATK2_1] = {SPR_RSNP, D, 50, A_FaceTarget, 0, 0, S_RSNAPPER_ATK2_2}
states[S_RSNAPPER_ATK2_2] = {SPR_RSNP, B, 120, nil, 0, 0, S_RSNAPPER_IDLE1}

states[S_RSNAPPER_ATK3_1] = {SPR_RSNP, D, 50, A_FaceTarget, 0, 0, S_RSNAPPER_ATK3_2}
states[S_RSNAPPER_ATK3_2] = {SPR_RSNP, B, 30, A_BunnyHop, 6, 6, S_RSNAPPER_ATK3_3}
states[S_RSNAPPER_ATK3_3] = {SPR_RSNP, D, 30, A_FaceTarget, 0, 0, S_RSNAPPER_ATK3_4}
states[S_RSNAPPER_ATK3_4] = {SPR_RSNP, A, 0, A_Repeat, 4, S_RSNAPPER_ATK3_2, S_RSNAPPER_IDLE1}

states[S_RSNAPPER_PHASE3_1] = {SPR_RSNP, A, 100, A_FaceTracer, 0, 0, S_RSNAPPER_IDLE1}

states[S_DARKSTABOT_WALK1] = {SPR_DCBF, A, 1, A_FaceStabChase, 0, 0, S_DARKSTABOT_WALK2}
states[S_DARKSTABOT_WALK2] = {SPR_DCBF, B, 1, A_FaceStabChase, 0, 0, S_DARKSTABOT_WALK3}
states[S_DARKSTABOT_WALK3] = {SPR_DCBF, C, 1, A_FaceStabChase, 0, 0, S_DARKSTABOT_WALK4}
states[S_DARKSTABOT_WALK4] = {SPR_DCBF, D, 1, A_FaceStabChase, 0, 0, S_DARKSTABOT_WALK5}
states[S_DARKSTABOT_WALK5] = {SPR_DCBF, E, 1, A_FaceStabChase, 0, 0, S_DARKSTABOT_WALK6}
states[S_DARKSTABOT_WALK6] = {SPR_DCBF, F, 1, A_FaceStabChase, 0, 0, S_DARKSTABOT_WALK1}

states[S_DARKSTABOT_PAIN1] = {SPR_DCPP, A|FF_ANIMATE, 30, A_Pain, 1, 1, S_DARKSTABOT1}

states[S_DARKSTABOT_ATK1_05] = {SPR_DCBF, I, 50, A_SpawnCharge, SKINCOLOR_BLUE, 0, S_DARKSTABOT_ATK1_1}
states[S_DARKSTABOT_ATK1_1] = {SPR_DCBF, I, 1, A_SetObjectFlags, MF_SPECIAL|MF_PAIN|MF_BOSS, 0, S_DARKSTABOT_ATK1_2}
states[S_DARKSTABOT_ATK1_2] = {SPR_DCBF, G, 0, A_PlayActiveSound, 0, 0, S_DARKSTABOT_ATK1_3}
states[S_DARKSTABOT_ATK1_3] = {SPR_DCBF, G, 0, A_FaceTarget, 0, 0, S_DARKSTABOT_ATK1_4}
states[S_DARKSTABOT_ATK1_4] = {SPR_DCBF, H, 20, A_KnightDash, 0, 0, S_DARKSTABOT_ATK1_5}
states[S_DARKSTABOT_ATK1_5] = {SPR_DCBF, A, 1, A_SetObjectFlags, MF_SPECIAL|MF_BOSS|MF_SHOOTABLE, 0, S_DARKSTABOT_WALK1}

states[S_DARKSTABOT_ATK2_05] = {SPR_DCBF, I, 25, A_SpawnCharge, SKINCOLOR_RED, 0, S_DARKSTABOT_ATK2_1}
states[S_DARKSTABOT_ATK2_1] = {SPR_DCBF, I, 5, A_FocusTarget, 0, 0, S_DARKSTABOT_ATK2_2}
states[S_DARKSTABOT_ATK2_2] = {SPR_DCBF, G, 0, A_PlayActiveSound, 0, 0, S_DARKSTABOT_ATK2_3}
states[S_DARKSTABOT_ATK2_3] = {SPR_DCBF, G, 0, A_FaceTarget, 0, 0, S_DARKSTABOT_ATK2_4}
states[S_DARKSTABOT_ATK2_4] = {SPR_DCBF, H, 10, A_FireShot, MT_CRAWLAFIRE, -35, S_DARKSTABOT_ATK2_5}
states[S_DARKSTABOT_ATK2_5] = {SPR_DCBF, A, 4, A_FaceTarget, 0, 0, S_DARKSTABOT_ATK2_6}
states[S_DARKSTABOT_ATK2_6] = {SPR_DCBF, G, 0, A_PlayActiveSound, 0, 0, S_DARKSTABOT_ATK2_7}
states[S_DARKSTABOT_ATK2_7] = {SPR_DCBF, H, 10, A_FireShot, MT_CRAWLAFIRE, -35, S_DARKSTABOT_ATK2_8}
states[S_DARKSTABOT_ATK2_8] = {SPR_DCBF, A, 4, A_FaceTarget, 0, 0, S_DARKSTABOT_ATK2_9}
states[S_DARKSTABOT_ATK2_9] = {SPR_DCBF, G, 0, A_PlayActiveSound, 0, 0, S_DARKSTABOT_ATK2_10}
states[S_DARKSTABOT_ATK2_10] = {SPR_DCBF, H, 20, A_FireShot, MT_CRAWLAFIRE, -35, S_DARKSTABOT_ATK2_11}
states[S_DARKSTABOT_ATK2_11] = {SPR_DCBF, A, 1, nil, 0, 0, S_DARKSTABOT_WALK1}

states[S_DARKSTABOT_ATK3_05] = {SPR_DCBF, H, 50, A_SpawnChargeR, SKINCOLOR_YELLOW, 0, S_DARKSTABOT_ATK3_1}
states[S_DARKSTABOT_ATK3_1] = {SPR_DCBF, H, 1, A_FocusTarget, 0, 0, S_DARKSTABOT_ATK3_2}
states[S_DARKSTABOT_ATK3_2] = {SPR_DCBF, G, 0, A_PlayActiveSound, 0, 0, S_DARKSTABOT_ATK3_3}
states[S_DARKSTABOT_ATK3_3] = {SPR_DCBF, I, 20, A_SpawnThunderBlast, 0, 0, S_DARKSTABOT_ATK3_4}
states[S_DARKSTABOT_ATK3_4] = {SPR_DCBF, I, 90, A_FaceTarget, 0, 0, S_DARKSTABOT_ATK3_5}
states[S_DARKSTABOT_ATK3_5] = {SPR_DCBF, A, 1, nil, 0, 0, S_DARKSTABOT_WALK1}

-- sal: A bunch of this code used to be TouchSpecial, but that's janky as hell & doesn't function with projectiles...
-- so now it had to be split into a bunch of different hooks that make more sense
addHook("MobjDamage", function(stabber, mo, source, dmg, dmgtype)
	if not (stabber and stabber.valid)
		return false
	end

	if (stabber.offguard == true)
	and (stabber.health > 1)
		stabber.target = source

		A_FaceTarget(stabber)
		stabber.offguard = false
		return false
	end

	if (stabber.defense == false)
	and (stabber.shieldbreak == false)
		if (stabber.shieldhealth > 1)
			stabber.target = source

			stabber.shield = P_SpawnMobj(mo.x,mo.y,mo.z,MT_EFFECT)
			stabber.shieldhealth = $1 - 1
			stabber.shield.state = S_SHIELD_PAIN
			stabber.defense = true
			local effect = P_SpawnMobj(mo.x,mo.y,mo.z,MT_THOK)
			effect.color = mo.color
			S_StartSound(stabber.shield,sfx_dmpain)
			A_FaceTarget(stabber)
			stabber.shield.angle = stabber.angle
			P_InstaThrust(mo,stabber.angle,20*FRACUNIT)
			P_Thrust(stabber,mo.angle,5*FRACUNIT)
			P_Thrust(stabber.shield,mo.angle,5*FRACUNIT)

			return true
		elseif (stabber.shieldhealth == 1)
			stabber.target = source

			P_SetMobjStateNF(stabber,S_DARKSTABOT_BOIL)
			stabber.shield = P_SpawnMobj(mo.x,mo.y,mo.z,MT_EFFECT)
			stabber.shieldhealth = $1 - 1
			stabber.shield.state = S_SHIELD_DEATH
			stabber.defense = true
			local effect = P_SpawnMobj(mo.x,mo.y,mo.z,MT_THOK)
			effect.color = mo.color
			S_StartSound(stabber.shield,sfx_wbreak)
			S_StartSound(stabber,sfx_boil)
			stabber.shieldbreak = true
			A_FaceTarget(stabber)
			stabber.shield.angle = stabber.angle
			P_InstaThrust(mo,stabber.angle,20*FRACUNIT)
			P_Thrust(stabber,mo.angle,5*FRACUNIT)

			return true
		end
	end

	if (stabber.health == 1)
	and (stabber.offguard == true)
	and (cutscenetimer6 == 0)
		if (source and source.valid)
		and (source.player and source.player.valid)
			source.player.cutscenemode6 = true
			cutscenemode6 = true
			A_SetObjectFlags(stabber, MF_BOUNCE)
			A_SetObjectFlags(stabber.tracer, MF_BOUNCE)
			stabber.target = source
		end

		return true
	end

	return false
end, MT_DARKSTABOT)

addHook("ShouldDamage", function(stabber, mo, source, dmg, dmgType)
	if not (stabber and stabber.valid)
		return
	end

	if (stabber.defense == true)
		return false
	end

	if (stabber.state != S_DARKSTABOT_ATK1_4)
	and (stabber.shieldbreak == true)
	and (stabber.offguard == false)
		return false
	end

	if (mo and mo.valid)
		if (mo.type == MT_TURRETLASER)
			return false
		end

		if (mo.player and mo.player.valid)
		and (mo.cheese ~= nil and mo.cheese.state == S_CHEESEBASH1) //No cheesing on my grass!
			return false
		end
	end
end, MT_DARKSTABOT)

addHook("TouchSpecial", function(snapper,mo) //-----------------------------------------------------------------
	if (mo and mo.valid)
	and (mo.player)
	and (snapper and snapper.valid)
		if (snapper.letitout == false)
			S_StartSound(snapper,sfx_s3k7b)
			local angle = R_PointToAngle2(snapper.x,snapper.y,mo.x,mo.y)
			P_InstaThrust(mo,angle,15*FRACUNIT)
			mo.state = S_PLAY_PAIN
			mo.player.pflags = ($1 & ~PF_SPINNING & ~PF_JUMPED)

			return true
		else
			P_DamageMobj(mo, snapper, snapper)

			return true
		end
	end
end,MT_RSNAPPER)

addHook("ShouldDamage", function(stabber,mo)
	if (stabber and stabber.valid)
    and (mo and mo.valid and mo.type == MT_TURRETLASER)
		return false
	end

	if (stabber and stabber.valid)
	and (mo and mo.valid and mo.player and mo.cheese ~= nil and mo.cheese.state == S_CHEESEBASH1) //No cheesing on my grass!
		return false
	end
end, MT_DARKSTABOT)

addHook("MobjThinker", function(stabber)
	if not stabber return end

		if stabber and stabber.valid
		and (stabber.shieldbreak == true)
		and (stabber.state == S_DARKSTABOT_ATK1_4)
			stabber.offguard = true
		end

		if stabber and stabber.valid
		and (stabber.shieldbreak == true)
		and (stabber.state == S_DARKSTABOT2)
			stabber.shieldbreak = false
			stabber.shieldhealth = 3
		end

        if stabber and stabber.valid
		and stabber.tracer and stabber.tracer.valid
		and stabber.health == 2
		and abs(stabber.z - stabber.tracer.z)>= stabber.tracer.z
		and R_PointToDist2(stabber.x,stabber.y,stabber.tracer.x,stabber.tracer.y)<= 60*FRACUNIT
			stabber.hang = true
		end

		if (stabber and stabber.valid)
		and (stabber.state == S_DARKSTABOT_ATK1_05)
		and (stabber.target and stabber.target.valid)
			A_FaceTarget(stabber)
		end

		if (stabber and stabber.valid)
		and (stabber.state == S_DARKSTABOT_ATK1_05)
		and (stabber.shieldbreak == true)
		and (stabber.target and stabber.target.valid)
			local thok = P_SpawnMobj(stabber.x+FixedMul(50*FRACUNIT, sin(stabber.angle)),stabber.y+FixedMul(-50*FRACUNIT, cos(stabber.angle)),stabber.z+125*FRACUNIT,MT_THOK)
			thok.color = SKINCOLOR_BLUE
			P_SpawnGhostMobj(stabber)
		end

		if (stabber and stabber.valid)
		and (stabber.state == S_DARKSTABOT_ATK2_05)
		and (stabber.shieldbreak == true)
		and (stabber.target and stabber.target.valid)
			local thok = P_SpawnMobj(stabber.x+FixedMul(50*FRACUNIT, sin(stabber.angle)),stabber.y+FixedMul(-50*FRACUNIT, cos(stabber.angle)),stabber.z+125*FRACUNIT,MT_THOK)
			thok.color = SKINCOLOR_RED
		end

		if (stabber and stabber.valid)
		and (stabber.state == S_DARKSTABOT_ATK3_4)
		and (leveltime % 2 == 0)
			local x = P_RandomRange(stabber.target.x/FRACUNIT-300,stabber.target.x/FRACUNIT+300)*FRACUNIT
			local y = P_RandomRange(stabber.target.y/FRACUNIT-300,stabber.target.y/FRACUNIT+300)*FRACUNIT
			P_SpawnMobj(x,y,0,MT_CYBRAKDEMON_TARGET_RETICULE)
				local thunder = P_SpawnMobj(x,y,0,MT_EFFECT)
				thunder.state = S_RLIT1
		end

		if (stabber.defense == nil)
			stabber.defense = false
		end

		if (stabber.defensetimer == nil)
			stabber.defensetimer = 0
		end

		if (stabber.defense == true)
			stabber.defensetimer = $1 + 1
		else
			stabber.defensetimer = 0
		end

		if (stabber.defensetimer > 30)
			stabber.defense = false
			stabber.defensetimer = 0
		end

		if stabber.offguard == nil
			stabber.offguard = false
		end

		if stabber.shieldbreak == nil
			stabber.shieldbreak = false
		end

		if stabber.shieldhealth == nil
			stabber.shieldhealth = 3
		end

		if (stabber.shield and stabber.shield.valid)
		and (stabber.defense == false)
		and not (stabber.shield.state == S_SHIELD_DEATH)
		and not (stabber.shield.state == S_SHIELD_DEATH2)
		and not (stabber.shield.state == S_SHIELD_DEATH3)
		and not (stabber.shield.state == S_SHIELD_DEATH4)
			P_RemoveMobj(stabber.shield)
			stabber.shield = nil
		end

		if (stabber.shield and stabber.shield.valid)
		and (stabber.defense == true)
		and (stabber.defensetimer == 28)
			P_RemoveMobj(stabber.shield)
			stabber.shield = nil
		end

		if (stabber.shield and stabber.shield.valid)
		and (stabber.defense == true)
		and (stabber.defensetimer < 28)
			stabber.shield.angle = stabber.angle
			stabber.shield.momx = stabber.momx
			stabber.shield.momy = stabber.momy
			stabber.shield.momz = stabber.momz
		end

		if (stabber and stabber.valid)
		and (stabber.defense == true)
		and (stabber.target and stabber.target.valid)
			A_FaceTarget(stabber)
		end

		if (stabber and stabber.valid)
		and ((stabber.state == S_DARKSTABOT1) or (stabber.state == S_DARKSTABOT12) or (stabber.state == S_DARKSTABOT2))
		and (stabber.target and stabber.target.valid)
			A_FaceTarget(stabber)
		end

		if (stabber and stabber.valid)
		and (stabber.state == S_DARKSTABOT_BOIL)
		and (stabber.tics == 2)
			A_TacticalJump(stabber)
		end

		if stabber.memorialx == nil
			stabber.memorialx = 0
		end

		if stabber.memorialy == nil
			stabber.memorialy = 0
		end

		if stabber.memorialz == nil
			stabber.memorialz = 0
		end

		if stabber.rage == nil
			stabber.rage = false
		end

		if stabber.hang == nil
			stabber.hang = false
		end

		if stabber.ragetimer == nil
			stabber.ragetimer = 0
		end

		if stabber.rage == true
			stabber.ragetimer = $1 + 1
		else
			stabber.ragetimer = 0
		end

		if stabber.exrage == nil
			stabber.exrage = false
		end

		if stabber.exragetimer == nil
			stabber.exragetimer = 0
		end

		if stabber.exrage == true
			stabber.exragetimer = $1 + 1
		else
			stabber.exragetimer = 0
		end

		if (stabber.health == 5)
			stabber.rage = true
				if (stabber.ragetimer == 29)
					stabber.state = S_DARKSTABOT_PHASE2_RAGE1
				end
		end

		if (stabber.health == 2)
			stabber.exrage = true
				if (stabber.exragetimer == 29)
					stabber.state = S_DARKSTABOT_PHASE3_RAGE1
					stabber.tracer.state = S_RSNAPPER_PHASE3_1
					P_LinedefExecute(1008)
				end
		end

		if stabber.state == S_DARKSTABOT_BOIL
		and leveltime % 5 == 0
			local smoke = P_SpawnMobj(stabber.x,stabber.y,stabber.z+100*FRACUNIT,MT_SMOKE)
			smoke.info.speed = 5*FRACUNIT
			smoke.momz = $1 + 2*FRACUNIT
		end

		if stabber.state == S_DARKSTABOT_PHASE2_RAGE1
		and leveltime % 5 == 0
			local smoke = P_SpawnMobj(stabber.x,stabber.y,stabber.z+100*FRACUNIT,MT_SMOKE)
			smoke.info.speed = 5*FRACUNIT
			smoke.momz = $1 + 2*FRACUNIT
		end

		if stabber.state == S_DARKSTABOT_PHASE3_RAGE1
		and leveltime % 5 == 0
			local smoke = P_SpawnMobj(stabber.x,stabber.y,stabber.z+100*FRACUNIT,MT_SMOKE)
			smoke.info.speed = 5*FRACUNIT
			smoke.momz = $1 + 2*FRACUNIT
		end

		if stabber.tracer and stabber.tracer.state == S_RSNAPPER_FORCE1
			stabber.tracer.tracer = stabber
		end

		if (stabber.state == S_DARKSTABOT_ATK1_4)
		and (stabber.shieldbreak == false)
			P_SpawnGhostMobj(stabber)
		end

		if (stabber.state == S_DARKSTABOT_ATK1_4)
		and (stabber.shieldbreak == true)
			local ghost = P_SpawnGhostMobj(stabber)
			ghost.state = S_DARKSTABOT_BLUR
		end

		if stabber.state == S_DARKSTABOT_WALK6
		and stabber.rage == false
			local hmm = {1, 2, 3, 4, 5, 6, 7, 8, 9}
			hmm = hmm[P_RandomKey(#hmm)+1]
				if hmm == 8
					P_SetMobjStateNF(stabber, S_DARKSTABOT_ATK1_05)
					A_SpawnCharge(stabber,SKINCOLOR_BLUE)
				end

				if hmm == 9
					P_SetMobjStateNF(stabber, S_DARKSTABOT_ATK2_05)
					A_SpawnCharge(stabber,SKINCOLOR_RED)
				end
		end

		if stabber.state == S_DARKSTABOT_WALK6
		and stabber.rage == true
			local hmm = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
			hmm = hmm[P_RandomKey(#hmm)+1]
				if hmm == 8
					P_SetMobjStateNF(stabber, S_DARKSTABOT_ATK1_05)
					A_SpawnCharge(stabber,SKINCOLOR_BLUE)
				end

				if hmm == 9
					P_SetMobjStateNF(stabber, S_DARKSTABOT_ATK2_05)
					A_SpawnCharge(stabber,SKINCOLOR_RED)
				end

				if hmm == 10
					P_SetMobjStateNF(stabber, S_DARKSTABOT_ATK3_05)
					A_SpawnChargeR(stabber,SKINCOLOR_YELLOW)
				end
		end

        if leveltime == 1
			S_ChangeMusic("DEPEC",true)
			stabber.tracer = P_SpawnMobj(4984*FRACUNIT, 372*FRACUNIT, 500*FRACUNIT, MT_RSNAPPER)
			stabber.tracer.tracer = stabber
			A_SetObjectFlags(stabber.tracer,MF_PAIN)
		end

        if leveltime == 1
			P_SetMobjStateNF(stabber,S_DARKSTABOT1)
			stabber.angle = FixedAngle(270*FRACUNIT)
		end

		if (stabber.state == S_DARKSTABOT12)
		and (stabber.tics == 14)
			local effect = P_SpawnMobj(stabber.x+FixedMul(50*FRACUNIT, sin(stabber.angle)),stabber.y,stabber.z+125*FRACUNIT,MT_EFFECT)
			effect.color = SKINCOLOR_WHITE
		end

		if (stabber.state == S_DARKSTABOT2)
		and (stabber.tics == 14)
			local effect = P_SpawnMobj(stabber.x+FixedMul(50*FRACUNIT, sin(stabber.angle)),stabber.y+FixedMul(40*FRACUNIT, sin(stabber.angle)),stabber.z+10*FRACUNIT,MT_EFFECT)
			effect.color = SKINCOLOR_WHITE
		end

		if (mapheaderinfo[gamemap].darkstabot) and stabber.tracer and stabber.ragetimer < 120
			A_FindTracer(stabber.tracer,MT_DARKSTABOT)
			A_FindTarget(stabber.tracer,MT_DARKSTABOT)
			stabber.tracer.tracer = stabber
		end

		if (mapheaderinfo[gamemap].darkstabot) and stabber.tracer and stabber.ragetimer >= 120
			A_FindTracer(stabber.tracer,MT_PLAYER)
			A_FindTarget(stabber.tracer,MT_PLAYER)
		end

		if (mapheaderinfo[gamemap].darkstabot) and stabber.health == 2 and stabber.exragetimer <= 200
			A_FindTracer(stabber,MT_RSNAPPER)
			A_FindTarget(stabber,MT_RSNAPPER)
		end

		if (mapheaderinfo[gamemap].darkstabot) and stabber.tracer
		and stabber.ragetimer == 0
			stabber.tracer.color = SKINCOLOR_BLACK
			A_SetObjectFlags(stabber.tracer, MF_SPECIAL|MF_NOCLIPTHING|MF_BOSS)
			stabber.tracer.state = S_RSNAPPER_FORCE2
		end

		if (mapheaderinfo[gamemap].darkstabot) and stabber.tracer
		and stabber.ragetimer == 1
			stabber.tracer.state = S_RSNAPPER_FORCE1
		end

		if stabber.tracer and stabber.ragetimer > 0 and stabber.ragetimer < 120
			A_FindTracer(stabber,MT_RSNAPPER)
			A_FindTarget(stabber,MT_RSNAPPER)
		end

		if stabber.tracer and stabber.ragetimer >= 120
			A_FindTracer(stabber.tracer,MT_PLAYER)
			A_FindTarget(stabber.tracer,MT_PLAYER)
		end

		if stabber.tracer and stabber.ragetimer == 160
			A_SetObjectFlags(stabber.tracer, MF_SPECIAL|MF_BOSS)
		end

		if stabber.ragetimer == 81 and stabber.tracer
			stabber.tracer.angle = FixedAngle(90*FRACUNIT)
			A_BunnyHop(stabber.tracer,20,10)
			A_SetObjectFlags(stabber.tracer, MF_SPECIAL|MF_NOCLIP|MF_NOCLIPTHING|MF_BOSS)
		end

		if stabber.tracer and stabber.ragetimer >= 90 and stabber.ragetimer < 125
			stabber.tracer.angle = stabber.tracer.angle+ANG10
			stabber.tracer.scale = $1 + 5135
			stabber.tracer.info.speed = 1
		end

		if stabber.hang == true
		and stabber.tracer and stabber.tracer.valid
			P_MoveOrigin(stabber,stabber.tracer.x,stabber.tracer.y,stabber.tracer.z+stabber.tracer.height+10*FRACUNIT)
			stabber.momz = 0
			stabber.momx = 0
			stabber.momy = 0
			if (stabber.tracer.state != S_RSNAPPER_ATK2_2)
				A_FaceTarget(stabber.tracer)
			end
		end

		if stabber.hang == true
		and stabber.tracer and stabber.tracer.valid
		and stabber.health ~= 1
			P_MoveOrigin(stabber,stabber.tracer.x,stabber.tracer.y,stabber.tracer.z+stabber.tracer.height+10*FRACUNIT)
			stabber.memorialx = stabber.x
			stabber.memorialy = stabber.y
			stabber.memorialz = stabber.z
		end

		if stabber.state == S_DARKSTABOT_PHASE3_RAGE6
		and stabber.hang == false
			A_FaceTracer(stabber)
		end

		if stabber.state == S_DARKSTABOT_PHASE3_RAGE2
			A_FaceTracer(stabber)
		end

		if stabber.state == S_DARKSTABOT_PHASE3_RAGE3
			A_FaceTracer(stabber)
		end

		if stabber.state == S_DARKSTABOT_PHASE3_RAGE4
			A_FaceTracer(stabber)
		end

		if stabber.state == S_DARKSTABOT_PHASE3_RAGE5
			A_FaceTracer(stabber)
		end

		if cutscenetimer6 == 1
			P_SetMobjStateNF(stabber,S_DARKSTABOT_WALK1)
		end

		if cutscenetimer6 > 1
		and cutscenetimer6 < 250
			P_SetMobjStateNF(stabber,S_DARKSTABOT_CUTS1)
		end

		for player in players.iterate
			if cutscenetimer6 > 1
			and playerCam and playerCam.valid
				player.awayviewmobj = playerCam
				player.awayviewtics = 5
			end

			if player.cutscenemode6 == true
			and cutscenetimer6 == 1
				P_SetOrigin(player.mo,13216*FRACUNIT,1472*FRACUNIT,700*FRACUNIT)
				playerCam = P_SpawnMobj(player.mo.x-90*FRACUNIT,player.mo.y,player.mo.z,MT_CAMERA)
				playerCam.target = player.mo
				A_FaceTarget(playerCam)
				player.mo.animationrun2 = true
				player.mo.momx = 0
				stabber.momx = 0
				stabber.momy = 0
				stabber.momz = 0
				S_StopMusic()
				S_StartSound(nil,sfx_s3ka4)
			end

			if player.cutscenemode6 == true
			and cutscenetimer6 >= 1
			and cutscenetimer6 < 90
				player.mo.momy = 0
				player.mo.angle = FixedAngle(180*FRACUNIT)
				P_Thrust(player.mo,FixedAngle(180*FRACUNIT),3*FRACUNIT)
				P_SetOrigin(playerCam,player.mo.x-110*FRACUNIT,player.mo.y,player.mo.z)
			end

			if player.cutscenemode6 == true
			and cutscenetimer6 == 90
				P_SetOrigin(playerCam,stabber.x-100*FRACUNIT,stabber.y+100*FRACUNIT,stabber.z)
				playerCam.target = stabber
				A_FaceTarget(playerCam)
				stabber.target = playerCam
				player.mo.target = stabber
				A_FaceTarget(stabber)
				player.mo.animationrun2 = false
				S_StartSound(nil,sfx_s3k9e)
			end

			if player.cutscenemode6 == true
			and cutscenetimer6 == 120
				S_StartSound(nil,sfx_combt)
				P_SetOrigin(player.mo,stabber.x+40*FRACUNIT,stabber.y+40*FRACUNIT,stabber.z+40*FRACUNIT)
				player.mo.momx = 0
				player.mo.momy = 0
				player.mo.animationcombat = true
				stabber.target = player.mo
				playerCam.tracer = stabber
				stabber.shieldd = P_SpawnMobj(stabber.x+FixedMul(5*FRACUNIT, sin(stabber.angle)), stabber.y+FixedMul(5*FRACUNIT, sin(stabber.angle)), stabber.z+30*FRACUNIT, MT_EGGSHIELD)
			end

			if player.cutscenemode6 == true
			and cutscenetimer6 >= 120
			and cutscenetimer6 < 200
				player.mo.momz = 0
				stabber.target = player.mo
				A_FaceTarget(playerCam)
				A_FaceTarget(stabber)
				A_FaceTarget(player.mo)
				P_SetMobjStateNF(stabber.shieldd,S_EGGSHIELD)
				P_SetOrigin(stabber.shieldd,stabber.x+FixedMul(5*FRACUNIT, sin(stabber.angle)), stabber.y+FixedMul(5*FRACUNIT, sin(stabber.angle)), stabber.z+30*FRACUNIT)
			end

			if player.cutscenemode6 == true
			and cutscenetimer6 >= 120
			and cutscenetimer6 % 10 == 0
			and cutscenetimer6 < 200
				local effect = P_SpawnMobj(stabber.x,stabber.y,stabber.z+50*FRACUNIT,MT_EFFECT)
				effect.color = SKINCOLOR_WHITE
			end

			if player.cutscenemode6 == true
			and cutscenetimer6 % 5 == 0
			and cutscenetimer6 > 200
			and cutscenetimer6 < 250
				A_BossScream(stabber)
			end
		end

        if cutscenetimer6 == 200
			P_Thrust(stabber,playerCam.angle,10*FRACUNIT)
			stabber.hang = false
			S_StartSound(nil,sfx_wbreak)
			P_RemoveMobj(stabber.shieldd)
		end

		if cutscenetimer6 >= 200
		and cutscenetimer6 < 250
			stabber.angle = stabber.angle+ANG20
		end

		if cutscenetimer6 == 250
			local explosion = P_SpawnMobj(stabber.x,stabber.y,stabber.z,MT_EFFECT)
			P_SetMobjStateNF(explosion,S_2EXPLOSION1)
			S_StartSound(nil,sfx_bebomb)
		end

		if cutscenetimer6 >= 250
		and cutscenetimer6 < 401
		and cutscenetimer6 % 5 == 0
			local smoke = P_SpawnMobj(stabber.x,stabber.y,stabber.z+100*FRACUNIT,MT_SMOKE)
			smoke.info.speed = 5*FRACUNIT
			smoke.momz = $1 + 2*FRACUNIT
		end

		for player in players.iterate
			if player.cutscenemode6 == true
			and cutscenetimer6 == 200
				player.mo.momx = 0
				player.mo.momy = 0
				player.mo.target = stabber
				A_FaceTarget(player.mo)
				P_Thrust(player.mo,player.mo.angle,7*FRACUNIT)
				local effect = P_SpawnMobj(stabber.x,stabber.y,stabber.z,MT_EFFECT)
				effect.color = SKINCOLOR_WHITE
			end

			if player.cutscenemode6 == true
			and cutscenetimer6 == 201
				player.mo.momx = 0
				player.mo.momy = 0
				P_Thrust(player.mo,player.mo.angle,7*FRACUNIT)
			end

			if player.cutscenemode6 == true
			and cutscenetimer6 >= 200
			and cutscenetimer6 < 210
				A_FaceTarget(player.mo)
			end

			if player.cutscenemode6 == true
			and cutscenetimer6 >= 210
				player.mo.animationcombat = false
				player.mo.momx = 0
				player.mo.momy = 0
				player.mo.momz = 0
				player.mo.state = S_PLAY_STND
			end

			if cutscenetimer6 == 250
			and player.cutscenemode6 == true
				player.dialog = true
				player.dialogoption = 10
				player.dialogtimer = 1
				player.dialogskipdelay = 150
				P_AddPlayerScore(player,1000)
			end

			if player.cutscenemode6 == true
			and cutscenetimer6 == 401
				sugoi.ExitLevel()
			end
		end
end, MT_DARKSTABOT)

addHook("MobjThinker", function(stabber)
	if not stabber return end

	if (stabber.letitout == nil)
		stabber.letitout = false
	end

	if (stabber.letitout == true)
	and (stabber.state == S_RSNAPPER_IDLE1)
		stabber.letitout = false
	end

	if (stabber.state == S_RSNAPPER_ATK3_1)
		stabber.letitout = true
	end

	if stabber.state == S_RSNAPPER_CHOOSE
		local hmm = {1, 2, 3}
		hmm = hmm[P_RandomKey(#hmm)+1]

			if hmm == 1
				P_SetMobjStateNF(stabber, S_RSNAPPER_ATK1_1)
			end

			if hmm == 2
				P_SetMobjStateNF(stabber, S_RSNAPPER_ATK2_1)
			end

			if hmm == 3
				P_SetMobjStateNF(stabber, S_RSNAPPER_ATK3_1)
			end
	end

	if stabber.state == S_RSNAPPER_ATK1_1
		if leveltime % 5 == 0
			local smoke = P_SpawnMobj(stabber.x,stabber.y,stabber.z+100*FRACUNIT,MT_SMOKE)
			smoke.info.speed = 5*FRACUNIT
			smoke.momz = $1 + 2*FRACUNIT
			smoke.momx = P_RandomRange(-5,5)*FRACUNIT
			smoke.momy = P_RandomRange(-5,5)*FRACUNIT
		end
	end

	if stabber.state == S_RSNAPPER_ATK2_1
		if leveltime % 5 == 0
			local smoke = P_SpawnMobj(stabber.x,stabber.y,stabber.z+100*FRACUNIT,MT_SMOKE)
			smoke.info.speed = 5*FRACUNIT
			smoke.momz = $1 + 2*FRACUNIT
			smoke.momx = P_RandomRange(-5,5)*FRACUNIT
			smoke.momy = P_RandomRange(-5,5)*FRACUNIT
		end
	end

	if stabber.state == S_RSNAPPER_ATK3_1
		if leveltime % 5 == 0
			local smoke = P_SpawnMobj(stabber.x,stabber.y,stabber.z+100*FRACUNIT,MT_PARTICLE)
			smoke.info.speed = 5*FRACUNIT
			smoke.momz = $1 + 2*FRACUNIT
			smoke.momx = P_RandomRange(-5,5)*FRACUNIT
			smoke.momy = P_RandomRange(-5,5)*FRACUNIT
		end
	end

	if stabber.state == S_RSNAPPER_ATK1_2
	and stabber.target and stabber.target.valid
		A_FaceTarget(stabber)
		stabber.tracer.target = P_SpawnMobj(stabber.x+FixedMul(30*FRACUNIT, cos(stabber.angle)), stabber.y+FixedMul(30*FRACUNIT, sin(stabber.angle)), stabber.z+30*FRACUNIT, MT_TURRETLASER)
		P_Thrust(stabber.tracer.target,stabber.angle,40*FRACUNIT)
	end

	if stabber.state == S_RSNAPPER_ATK2_2
		stabber.angle = stabber.angle+ANG10
		stabber.tracer.target = P_SpawnMobj(stabber.x+FixedMul(30*FRACUNIT, cos(stabber.angle)), stabber.y+FixedMul(30*FRACUNIT, sin(stabber.angle)), stabber.z+30*FRACUNIT, MT_TURRETLASER)
		P_Thrust(stabber.tracer.target,stabber.angle,40*FRACUNIT)
	end

	if (mapheaderinfo[gamemap].darkstabot)
	and stabber.eflags & MFE_JUSTHITFLOOR
		P_StartQuake(8*FRACUNIT, 10)
		S_StartSound(nil,sfx_pstop)
	end

	if cutscenetimer6 >= 1
		P_SetMobjStateNF(stabber,S_RSNAPPER_FORCE3)
	end
end, MT_RSNAPPER)
