freeslot(
"MT_EGGLAS",
"S_LASERSHOW_STND",
"S_LASERSHOW_ATT",
"S_LASER_PAIN1",
"S_LASERSHOWPANIC1",
"S_LASERSHOWPANIC2",
"S_LASERSHOWPANIC3",
"S_LASERSHOWPANIC4",
"S_LASERSHOWPANIC5",
"sfx_eggtn1",
"sfx_eggtn2"
)

function A_LaserMove(boss,var1,var2)
	boss.momz = var1*FRACUNIT
end

function A_LaserThink(boss, var1, var2)
	local action = {
		[1] = function (i) boss.chosenatt[i] = 200 boss.attdur[i] = 535 end,
		[2] = function (i) boss.chosenatt[i] = 202 boss.attdur[i] = 345 end,
		[3] = function (i) boss.chosenatt[i] = 203 boss.attdur[i] = 345 end,
		[4] = function (i) boss.chosenatt[i] = 204 boss.attdur[i] = 315 end,
		[5] = function (i) boss.chosenatt[i] = 205 boss.attdur[i] = 315 end,
		[6] = function (i) boss.chosenatt[i] = 206 boss.attdur[i] = 145 end,
		[7] = function (i) boss.chosenatt[i] = 207 boss.attdur[i] = 145 end,
		[8] = function (i) boss.chosenatt[i] = 208 boss.attdur[i] = 145 end,
		[9] = function (i) boss.chosenatt[i] = 209 boss.attdur[i] = 145 end,
		[10] = function (i) boss.chosenatt[i] = 210 boss.attdur[i] = 145 end,
		[11] = function (i) boss.chosenatt[i] = 211 boss.attdur[i] = 145 end,
		[12] = function (i) boss.chosenatt[i] = 212 boss.attdur[i] = 145 end,
		[13] = function (i) boss.chosenatt[i] = 213 boss.attdur[i] = 145 end,
		[14] = function (i) boss.chosenatt[i] = 214 boss.attdur[i] = 145 end,
		[15] = function (i) boss.chosenatt[i] = 215 boss.attdur[i] = 145 end,
		[16] = function (i) boss.chosenatt[i] = 216 boss.attdur[i] = 145 end,
		[17] = function (i) boss.chosenatt[i] = 217 boss.attdur[i] = 145 end,
		[18] = function (i) boss.chosenatt[i] = 218 boss.attdur[i] = 145 end,
		[19] = function (i) boss.chosenatt[i] = 219 boss.attdur[i] = 535 end,
		[20] = function (i) boss.chosenatt[i] = 221 boss.attdur[i] = 145 end,
		[21] = function (i) boss.chosenatt[i] = 222 boss.attdur[i] = 145 end,
		[22] = function (i) boss.chosenatt[i] = 225 boss.attdur[i] = 145 end,
		[23] = function (i) boss.chosenatt[i] = 226 boss.attdur[i] = 145 end,
		[24] = function (i) boss.chosenatt[i] = 227 boss.attdur[i] = 145 end,
		[25] = function (i) boss.chosenatt[i] = 228 boss.attdur[i] = 145 end,
		[26] = function (i) boss.chosenatt[i] = 229 boss.attdur[i] = 145 end,
		[27] = function (i) boss.chosenatt[i] = 230 boss.attdur[i] = 315 end,
		[28] = function (i) boss.chosenatt[i] = 231 boss.attdur[i] = 380 end,
		[29] = function (i) boss.chosenatt[i] = 233 boss.attdur[i] = 295 end,
		--[30] = function (i) boss.chosenatt[i] = 232 boss.attdur[i] = 440 end, --Cruel sweep; removed because of extremely high difficulty.

	}

	if (boss.health > 3)
	boss.lasshots = 3
	else
	boss.lasshots = 5
	end
	boss.chosenatt = {P_RandomRange(1,29),P_RandomRange(1,29),P_RandomRange(1,29),
	P_RandomRange(1,29),P_RandomRange(1,29)}
	for i=1,boss.lasshots,1 do
		action[boss.chosenatt[i]](i)
	end
	if boss.health == 6
	boss.chosenatt = {208,228,206}
	boss.attdur = {145,145,145}
	end
	if boss.health == 2
	S_StartSound(nil,sfx_eggtn1)
	boss.chosenatt = {202,202,202,203,203}
	boss.attdur = {180,180,180,180,180}
	end
	if boss.health == 1
	S_StartSound(nil,sfx_eggtn2)
	boss.chosenatt = {217,218,217,218,217}
	boss.attdur = {85,85,85,85,85}
	end
	for i = 1,boss.lasshots,1 do
	boss.tics = $1+boss.attdur[i]
	end
	if(boss.lasshots == 3)
	boss.totalatt = (boss.attdur[1]+boss.attdur[2]+boss.attdur[3])+5
	else
	boss.totalatt = (boss.attdur[1]+boss.attdur[2]+boss.attdur[3]+boss.attdur[4]+boss.attdur[5])+5
	end
	P_LinedefExecute(boss.chosenatt[1])
end

mobjinfo[MT_EGGLAS] = {
	--$Name Egg Lasershow
	--$Sprite EGGPA1
	--Category SUGOI Bosses
	doomednum= 2511,
	spawnstate = S_LASERSHOW_STND,
	spawnhealth = 6,
	seestate =	S_LASERSHOW_STND,
	seesound = 0,
	reactiontime = 16,
	attacksound = 0,
	painstate = S_LASER_PAIN1,
	painchance = 200,
	painsound = sfx_dmpain,
	meleestate = S_LASERSHOW_STND,
	missilestate = S_LASERSHOW_STND,
	deathstate = S_EGGMOBILE4_DIE1,
	deathsound = sfx_cybdth,
	xdeathstate = S_EGGMOBILE4_FLEE1,
	speed = 0,
	radius = 24*FRACUNIT,
	height = 76*FRACUNIT,
	mass = sfx_none,
	damage = 0,
	activesound = 0,
	raisestate = 0,
	flags = MF_BOSS|MF_SPECIAL|MF_SHOOTABLE|MF_NOGRAVITY
}


states[S_LASERSHOW_STND] = {
	sprite = SPR_EGGP,
	frame = A,
	tics = 35,
	nextstate = S_LASERSHOW_ATT,
	action = None,
	var1 = 0,
	var2 = 0
}
states[S_LASERSHOW_ATT] = {
	sprite = SPR_EGGP,
	frame = A,
	tics = 5,
	nextstate = S_LASERSHOWPANIC1,
	action = A_LaserThink,
	var1 = 0,
	var2 = 0
}
states[S_LASERSHOWPANIC1] = {
	sprite = SPR_EGGP,
	frame = N,
	tics = 5,
	nextstate = S_LASERSHOWPANIC2,
	action = A_FaceTarget,
	var1 = 0,
	var2 = 0
}
states[S_LASERSHOWPANIC2] = {
	sprite = SPR_EGGP,
	frame = N,
	tics = 5,
	nextstate = S_LASERSHOWPANIC3,
	action = A_LinedefExecute,
	var1 = 223,
	var2 = 0
}
states[S_LASERSHOWPANIC3] = {
	sprite = SPR_EGGP,
	frame = P,
	tics = 315,
	nextstate = S_LASERSHOWPANIC4,
	action = A_LaserMove,
	var1 = 4,
	var2 = (1<<16)+1
}
states[S_LASERSHOWPANIC4] = {
	sprite= SPR_EGGP,
	frame = A,
	tics = 35,
	nextstate = S_LASERSHOWPANIC5,
	action = A_LaserMove,
	var1 = -4,
	var2 = (1<<16)+1
}

states[S_LASERSHOWPANIC5] = {
	sprite = SPR_EGGP,
	frame = N,
	tics = 120,
	nextstate = S_LASERSHOW_STND,
	action = None,
	var1 = 221,
	var2 = 0
}

states[S_LASER_PAIN1] = {
	sprite = SPR_EGGP,
	frame = N,
	tics = 24,
	nextstate = S_LASERSHOWPANIC4,
	action = A_PAIN,
	var1 = 223,
	var2 = 0
}


local function changeanim(boss)
	if boss.frame== P
		boss.frame = Q
	else
		boss.frame = P
	end
end

addHook("MobjSpawn", function(boss)
	A_BossJetFume(boss,3,0)
	boss.chosenatt = {0,0,0,0,0}
	boss.attdur = {0,0,0,0,0}
	boss.totalatt = 0
	boss.lasshots = 0
	sugoi.SetBoss(boss, "Egg Lasershow")
end, MT_EGGLAS)

addHook("MobjThinker", function(boss)
  if(boss.state == S_LASERSHOW_ATT)
	--print(boss.chosenatt[1].." "..boss.chosenatt[2].." "..boss.chosenatt[3].." "..boss.chosenatt[4].." "..boss.chosenatt[5])
	if (boss.tics == boss.totalatt - boss.attdur[1])
	P_LinedefExecute(boss.chosenatt[2])
	end
	if (boss.tics == boss.totalatt - (boss.attdur[1]+boss.attdur[2]))
	P_LinedefExecute(boss.chosenatt[3])
	end
	if(boss.health == 8 or boss.health < 4)
	if (boss.tics == boss.totalatt - (boss.attdur[1]+boss.attdur[2]+boss.attdur[3]))
	P_LinedefExecute(boss.chosenatt[4])
	end
	if (boss.tics == boss.totalatt - (boss.attdur[1]+boss.attdur[2]+boss.attdur[3]+boss.attdur[4]))
	P_LinedefExecute(boss.chosenatt[5])
	end
	end
  end
  if(boss.state == S_LASERSHOWPANIC5)
	if (boss.tics == 120 or boss.tics == 85 or boss.tics == 50)
		S_StartSound(nil,sfx_s3k5c)
	end
	if boss.tics == 15
		S_StartSound(nil,sfx_buzz1)
		P_LinedefExecute(224)
	end
  end
  if(boss.state == S_LASERSHOWPANIC3 or boss.state == S_LASER_PAIN1)
	if boss.z/FRACUNIT > 484
			boss.momz = 0
			P_MoveOrigin(boss,boss.x,boss.y,484*FRACUNIT)
		end
	end
  if(boss.state == S_LASERSHOWPANIC3 or boss.state == S_LASERSHOWPANIC4)
	if boss.state == S_LASERSHOWPANIC3
		if (boss.tics % 5 == 0)
			changeanim(boss)
		end
		if (boss.tics == 315)
			S_StartSound(nil,sfx_s3k85)
		end
	elseif boss.state == S_LASERSHOWPANIC4
		if boss.z == -76*FRACUNIT
			boss.momz = 0
			boss.tics = 0
		end
	end
  end
end, MT_EGGLAS)

