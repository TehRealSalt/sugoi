freeslot(
	"MT_EGGLAS2",
	"MT_EGGOPTIONA",
	"MT_EGGOPTIONB",
	"MT_EGGOPTIONC",
	"SPR_ELV2",
	"SPR_LSOP",
	"S_OPTIONIDLE",
	"S_OPTIONFIRE_1",
	"S_OPTIONFIRE_2",
	"S_OPTIONDEATH",
	"S_OPTION_EXPLODE1",
	"S_OPTION_EXPLODE2",
	"S_OPTION_EXPLODE3",
	"S_ELMK2_IDLE",
	"S_ELMK2_IDLE2",
	"S_ELMK2_ATT",
	"S_ELMK2_ATT2",
	"S_ELMK2_PAIN",
	"S_ELMK2DIE"
)

local function atkcall(num) //Triggers lasers to fire.
	if num == 1
		P_LinedefExecute(1006)
	elseif num == 2
		P_LinedefExecute(1016)
	elseif num == 3
		P_LinedefExecute(1026)
	elseif num == 4
		P_LinedefExecute(1026)
		P_LinedefExecute(1006)
	elseif num == 5
		P_LinedefExecute(1006)
		P_LinedefExecute(1016)
	elseif num == 6
		P_LinedefExecute(1026)
		P_LinedefExecute(1016)
	else
		print("Invalid Call.")
	end
end


function A_MK2Think(boss, var1, var2)
		if boss.eggpoints > 0
		boss.lasatk = P_RandomRange(1,10)
			if (boss.oldatk == boss.lasatk)
				if boss.oldatk == 8
					boss.lasatk = 7
				elseif boss.oldatk == 7
					boss.lasatk = 8
				elseif (boss.oldatk == 9 or boss.oldatk == 10)
					if boss.oldatk == 9 boss.lasatk = 9 end
					if boss.oldatk == 10 boss.lasatk = 10 end
					boss.oldatk = 0
				else
					boss.lasatk = P_RandomRange(1,8)
				end
			end
		end
		if boss.eggpoints <= 0
			boss.lasatk = 0
		end
		if (boss.lasatk >=1 and boss.lasatk <=3)
			if (P_RandomChance(3*FRACUNIT/5) == true)
				boss.lasatk = P_RandomRange(4,6)
			end
		end
		if boss.eggpoints >0
			if (boss.lasatk >=1 and boss.lasatk <= 6 and boss.eggpoints >=boss.wkdelay)
				boss.eggpoints = boss.eggpoints - boss.wkdelay
				boss.attlimit = boss.wkdelay +1
			elseif (boss.lasatk == 7 or boss.lasatk == 8 and boss.eggpoints >=boss.strdelay)
				boss.eggpoints = boss.eggpoints-boss.strdelay
				boss.attlimit = boss.strdelay + 1
			elseif (boss.lasatk == 9 or boss.lasatk == 10 and boss.eggpoints >=boss.strdelay2)
				boss.eggpoints = boss.eggpoints-boss.strdelay2
				boss.attlimit = boss.strdelay2 + 1
			elseif (boss.lasatk >= 7 and boss.lasatk <=10 and (boss.eggpoints < boss.strdelay) and boss.eggpoints>boss.wkdelay and boss.eggpoints - boss.wkdelay>=0)
				boss.lasatk = P_RandomRange(1,6)
				boss.eggpoints= $ -boss.wkdelay
				boss.attlimit = boss.wkdelay+1
			else
			 boss.lasatk = 0
		end
		boss.oldatk = boss.lasatk
		if(boss.attlimit != nil)
		end
	end
end

mobjinfo[MT_EGGLAS2] = {
	--$Name Egg Lasershow Mk.II
	--$Sprite ELV2A0
	--Category SUGOI Bosses
	doomednum= 2512,
	spawnstate = S_ELMK2_IDLE,
	spawnhealth = 100,
	seestate = S_ELMK2_IDLE2,
	seesound = 0,
	reactiontime = 16,
	attacksound = 0,
	painstate = S_ELMK2_PAIN,
	painchance = 200,
	painsound = sfx_dmpain,
	meleestate = S_ELMK2_IDLE,
	missilestate = S_ELMK2_IDLE,
	deathstate = S_ELMK2DIE,
	deathsound = sfx_cybdth,
	xdeathstate = S_NULL,
	speed = 0,
	radius = 60*FRACUNIT,
	height = 76*FRACUNIT,
	mass = sfx_none,
	damage = 0,
	activesound = 0,
	raisestate = 0,
	flags = MF_PAIN|MF_SPECIAL|MF_SHOOTABLE|MF_NOGRAVITY|MF_RUNSPAWNFUNC
}


states[S_ELMK2_IDLE] = {
	sprite = SPR_ELV2,
	frame = A,
	tics = 5,
	nextstate = S_ELMK2_IDLE,
	action = A_Look,
	var1 =  262140000,
	var2 = 1
}
states[S_ELMK2_IDLE2] = {
	sprite = SPR_ELV2,
	frame = A,
	tics = 45,
	nextstate = S_ELMK2_ATT,
	action = none,
	var1 = 65535001,
	var2 = 1
}
states[S_ELMK2_ATT]={
	sprite = SPR_ELV2,
	frame = A,
	tics = 500,
	nextstate = S_ELMK2_ATT2,
	action = A_MK2Think,
	var1 = 5,
	var2 = 6
}

states[S_ELMK2_ATT2]={
	sprite = SPR_ELV2,
	frame = A,
	tics = 0,
	nextstate = S_ELMK2_ATT,
	action = None,
	var1 = 0,
	var2 = 0
}
states[S_ELMK2_PAIN]={
	sprite = SPR_ELV2,
	frame = A,
	tics = 24,
	nextstate = S_ELMK2_IDLE,
	action = A_PAIN,
	var1 = 223,
	var2 = 0
}
states[S_ELMK2DIE]={
	sprite = SPR_EGGP,
	frame = M,
	tics = 5,
	nextstate = S_OPTION_EXPLODE1,
	action = A_FALL,
	var1 = 0,
	var2 = 0
}
local function bleh(boss)

end
addHook("MapThingSpawn", function(boss)
	local b = P_SpawnMobj(boss.x, boss.y, boss.z-384*FRACUNIT, MT_EGGOPTIONB)
	local a = P_SpawnMobj(boss.x-FixedMul(448*FRACUNIT, cos(boss.angle+FixedAngle(180*FRACUNIT))),
	boss.y-FixedMul(448*FRACUNIT, sin(boss.angle+FixedAngle(180*FRACUNIT))), boss.z-384*FRACUNIT, MT_EGGOPTIONC)
	local c = P_SpawnMobj(boss.x+FixedMul(448*FRACUNIT, cos(boss.angle+FixedAngle(180*FRACUNIT))),
	boss.y+FixedMul(448*FRACUNIT, sin(boss.angle+FixedAngle(180*FRACUNIT))), boss.z-384*FRACUNIT, MT_EGGOPTIONA)

	b.target = boss
	a.target = boss
	c.target = boss

	boss.eggpoints = 2100
	boss.acttime= 2100
	boss.lasatk = 0
	boss.frame = A
	boss.lasstart=20
	boss.str1interval = 84
	boss.wkdelay = 100
	boss.strdelay = boss.str1interval*3 + (boss.wkdelay-boss.str1interval+1)
	boss.strdelay2= boss.wkdelay*3
	boss.gloat = false
	boss.extravalue1 = 7*TICRATE
	boss.scale = 5*FRACUNIT
	A_BossJetFume(boss,3,0)
	P_LinedefExecute(1099)

	sugoi.queueBoss = {
		boss = boss,
		name = "Egg Lasershow MKII",
	};
end, MT_EGGLAS2)

//Animation Handler

local function startanim(x,frame,boss) //Generic eye flash.
	if (boss.state == S_ELMK2_ATT)
		if boss.tics <= x and boss.tics >x-3
			boss.frame = frame
		elseif boss.tics <= x- 3 and boss.tics >x-7
			boss.frame = frame+1
		elseif boss.tics <= x-7 and boss.tics >x-15
			boss.frame = frame+2
		elseif boss.tics <= x-15 and boss.tics >x-17
			boss.frame = frame+3
		elseif boss.tics <= x-17 and boss.tics >x-19
			boss.frame = frame+4
		else
			boss.frame = A
		end
	end
end

local function startanim2(x,frame,boss) //Eye flash for sweep attacks.
	if (boss.state == S_ELMK2_ATT)
		if boss.tics <= x and boss.tics >x-3
			boss.frame = frame
		elseif boss.tics <= x- 3 and boss.tics >x-7
			boss.frame = frame+1
		elseif boss.tics <= x-7 and boss.tics >5
			boss.frame = frame+2
		elseif boss.tics <= 5 and boss.tics >3
			boss.frame = frame+3
		elseif boss.tics <= 3 and boss.tics >1
			boss.frame = frame+4
		else
			boss.frame = A
		end
	end
end

addHook("MobjThinker", function(boss)
	if (boss.state == S_ELMK2_ATT and boss.lasatk != 0)
		if(boss.lasatk <=6)
			startanim(boss.wkdelay,B,boss)
		end
		if(boss.lasatk >=7 and boss.lasatk <= 10)
			if boss.lasatk == 7 or boss.lasatk == 8
				if (boss.tics <= boss.strdelay and boss.tics >= boss.strdelay - boss.str1interval)
					startanim(boss.strdelay,G,boss)
				end
				if (boss.tics <= boss.strdelay - boss.str1interval and boss.tics >= boss.strdelay - boss.str1interval*2)
					startanim(boss.strdelay - boss.str1interval,G,boss)
				end
				if (boss.tics <= boss.strdelay- boss.str1interval*2)
					startanim(boss.strdelay - boss.str1interval*2,G,boss)
				end
			else
				startanim2(boss.strdelay2,G,boss)
			end
		end
	end
end, MT_EGGLAS2)


//Attack Handler
addHook("MobjThinker",function(boss)

	if boss.acttime == 0 and boss.acttime != nil and boss.health !=0
		P_KillMobj(boss)
	end
	if boss.state == S_ELMK2_ATT
		if boss.gloat == false
			S_StartSound(nil,sfx_eggtn1)
			boss.gloat = true
		end
		boss.acttime = $ - 1
		boss.attlimit = $-1
		boss.tics = boss.attlimit
		if (boss.acttime != 1050)
			if boss.attlimit == boss.wkdelay
				if boss.lasatk == 1 atkcall(1)
				elseif boss.lasatk == 2 atkcall(2)
				elseif boss.lasatk == 3 atkcall(3)
				elseif boss.lasatk == 4 atkcall(4)
				elseif boss.lasatk == 5 atkcall(5)
				elseif boss.lasatk == 6 atkcall(6)
				else
				end
			end
			if boss.attlimit == boss.strdelay
				if boss.lasatk == 7 atkcall(4)
				elseif boss.lasatk == 8 atkcall(2)
				else
				end
			end
			if boss.attlimit == boss.strdelay - boss.str1interval
				if boss.lasatk == 7 atkcall(2)
				elseif boss.lasatk == 8 atkcall(4)
				end
			end
			if boss.attlimit == boss.strdelay - boss.str1interval*2
				if boss.lasatk == 7 atkcall(4)
				elseif boss.lasatk == 8 atkcall(2)
				else
				end
			end

			if boss.attlimit == boss.strdelay2
				if boss.lasatk == 9 atkcall(1)
				elseif boss.lasatk == 10 atkcall(3)
				else
				end
			end
			if boss.attlimit == boss.wkdelay*2
				if boss.lasatk == 9 atkcall(5)
				elseif boss.lasatk == 10 atkcall(6)
				else
				end
			end
			if boss.attlimit == boss.wkdelay
				if boss.lasatk == 9 atkcall(6)
				elseif boss.lasatk == 10 atkcall(5)
				else
				end
			end
		end
	end
end, MT_EGGLAS2)


//Panic handler
local function lasercancel(boss) //Stops lasers from firing if part of a combo attack when transitioning to panic mode.
	if (boss.lasatk == 7 or boss.lasatk == 8)
		boss.lasatk = 0
		if (boss.attlimit <= boss.strdelay and boss.attlimit > boss.strdelay - boss.str1interval)
			boss.attlimit = boss.attlimit - (boss.strdelay - boss.str1interval) + (boss.wkdelay-boss.str1interval)
		elseif (boss.attlimit <= boss.strdelay - boss.str1interval and boss.attlimit > boss.strdelay - boss.str1interval*2)
			boss.attlimit = boss.attlimit -(boss.strdelay - boss.str1interval*2) + (boss.wkdelay-boss.str1interval)
		else
		end
	else
		if (boss.attlimit <= boss.strdelay2 and boss.attlimit > boss.wkdelay*2)
			boss.attlimit = boss.attlimit- boss.wkdelay*2
		elseif (boss.attlimit <= boss.wkdelay*2 and boss.attlimit > boss.wkdelay)
			boss.attlimit = boss.attlimit- boss.wkdelay
		else
		end
	end
end

//Boss Reset Handler
addHook("MobjThinker",function(boss)
	if boss.extravalue1 <= 0
		boss.state = S_ELMK2_IDLE
		boss.eggpoints = 2100
		boss.acttime= 2100
		boss.lasatk = 0
		boss.frame = A
		boss.lasstart=20
		boss.str1interval = 84
		boss.wkdelay = 100
		boss.strdelay = boss.str1interval*3 + (boss.wkdelay-boss.str1interval+1)
		boss.strdelay2= boss.wkdelay*3
		boss.gloat = false
		P_LinedefExecute(1099)
		lasercancel(boss)
		if boss.acttime < 1050
			P_LinedefExecute(1100)
		end
		boss.extravalue1 = 7*TICRATE
	end
	if (boss.state == S_ELMK2_ATT or boss.state == S_ELMK2_ATT2 or boss.state == S_ELMK2_IDLE2)
	and (P_LookForPlayers(boss,0,true,false) == false)
		boss.extravalue1 = $ - 1
	else
		boss.extravalue1 = 7*TICRATE
	end
end, MT_EGGLAS2)


addHook("MobjThinker",function(boss)
	local actstore = 0
	if (boss.acttime == 1051)
		if(boss.lasatk >= 7 and boss.lasatk <=10)
			boss.attlimit = $ + 2
			lasercancel(boss)
			actstore = boss.tics
		end
	end
	if (boss.acttime == 1050)
		boss.lasatk = 0
		boss.frame = A
		S_StartSound(nil,sfx_eggtn2)
		boss.eggpoints = 0
		boss.eggpoints = 1050
		boss.str1interval = 42
		boss.wkdelay = 50
		boss.strdelay = boss.str1interval*3 + (boss.wkdelay-boss.str1interval+1)
		boss.strdelay2= boss.wkdelay*3
		P_LinedefExecute(1041)
		boss.lasstart=20
		states[S_OPTIONFIRE_1].tics = 3
		states[S_OPTIONFIRE_2].tics = 3
	end
	if (boss.acttime <= 1050 and boss.tics%8 == 0)
		A_BossScream(boss,1,MT_EXPLODE)
	end
	if (boss.acttime <= 700 and boss.tics%4 == 0)
		A_BossScream(boss,1,MT_SONIC3KBOSSEXPLODE)
	end
	if (boss.acttime <= 350 and boss.tics%2 == 0)
		A_BossScream(boss)
	end
end, MT_EGGLAS2)


addHook("MobjDeath", function(boss)
	local a = P_SpawnMobj(boss.x, boss.y, boss.z, MT_EGGMOBILE4)
	A_BossJetFume(a,3,0)
	a.scale = 1*FRACUNIT
	a.angle = boss.angle
	P_KillMobj(a)
	P_LinedefExecute(1078)
end, MT_EGGLAS2)

//Option exclusive handlers and functions
//Option A, B, and C are left, middle and right options, respectively.
states[S_OPTIONIDLE]={
	sprite = SPR_LSOP,
	frame = A,
	tics = 1,
	nextstate = S_OPTIONIDLE,
	action = None,
	var1 = 0,
	var2 = 0
}

states[S_OPTIONFIRE_1]={
	sprite = SPR_LSOP,
	frame = B,
	tics = 4,
	nextstate = S_OPTIONFIRE_2,
	action = None,
	var1 = 0,
	var2 = 0
}

states[S_OPTIONFIRE_2]={
	sprite = SPR_LSOP,
	frame = C,
	tics = 4,
	nextstate = S_OPTIONFIRE_1,
	action = None,
	var1 = 0,
	var2 = 0
}

states[S_OPTIONDEATH]={
	sprite = SPR_LSOP,
	frame = A,
	tics = 5,
	nextstate = S_OPTION_EXPLODE1,
	action = A_NapalmScatter,
	var1 = 	MT_SONIC3KBOSSEXPLODE+(12<<16),
	var2 = 128+(40<<16)
}

states[S_OPTION_EXPLODE1]={
	sprite = SPR_RCKT,
	frame = B,
	tics = 8,
	nextstate = S_OPTION_EXPLODE2,
	action = None,
	var1 = 	0,
	var2 = 0
}

states[S_OPTION_EXPLODE2]={
	sprite = SPR_RCKT,
	frame = C,
	tics = 6,
	nextstate = S_OPTION_EXPLODE3,
	action = None,
	var1 = 	0,
	var2 = 0
}

states[S_OPTION_EXPLODE3]={
	sprite = SPR_RCKT,
	frame = D,
	tics = 4,
	nextstate = S_NULL,
	action = None,
	var1 = 	0,
	var2 = 0
}

mobjinfo[MT_EGGOPTIONA] = {

	doomednum= -1,
	spawnstate = S_OPTIONIDLE,
	spawnhealth = 100,
	seestate = S_NULL,
	seesound = 0,
	reactiontime = 16,
	attacksound = 0,
	painstate = S_NULL,
	painchance = 200,
	painsound = sfx_dmpain,
	meleestate = S_NULL,
	missilestate = S_NULL,
	deathstate = S_OPTIONDEATH,
	deathsound = sfx_None,
	xdeathstate = S_NULL,
	speed = 4*FRACUNIT,
	radius = 24*FRACUNIT,
	height = 76*FRACUNIT,
	mass = sfx_none,
	damage = 0,
	activesound = 0,
	raisestate = 0,
	flags = MF_PAIN|MF_NOGRAVITY|MF_RUNSPAWNFUNC
}

mobjinfo[MT_EGGOPTIONB] = {

	doomednum= -1,
	spawnstate = S_OPTIONIDLE,
	spawnhealth = 100,
	seestate = S_NULL,
	seesound = 0,
	reactiontime = 16,
	attacksound = 0,
	painstate = S_NULL,
	painchance = 200,
	painsound = sfx_dmpain,
	meleestate = S_NULL,
	missilestate = S_NULL,
	deathstate = S_OPTIONDEATH,
	deathsound = sfx_None,
	xdeathstate = S_NULL,
	speed = 4*FRACUNIT,
	radius = 24*FRACUNIT,
	height = 76*FRACUNIT,
	mass = sfx_none,
	damage = 0,
	activesound = 0,
	raisestate = 0,
	flags = MF_PAIN|MF_NOGRAVITY|MF_RUNSPAWNFUNC
}

mobjinfo[MT_EGGOPTIONC] = {

	doomednum= -1,
	spawnstate = S_OPTIONIDLE,
	spawnhealth = 100,
	seestate = S_NULL,
	seesound = 0,
	reactiontime = 16,
	attacksound = 0,
	painstate = S_NULL,
	painchance = 200,
	painsound = sfx_dmpain,
	meleestate = S_NULL,
	missilestate = S_NULL,
	deathstate = S_OPTIONDEATH,
	deathsound = sfx_None,
	xdeathstate = S_NULL,
	speed = 4*FRACUNIT,
	radius = 24*FRACUNIT,
	height = 76*FRACUNIT,
	mass = sfx_none,
	damage = 0,
	activesound = 0,
	raisestate = 0,
	flags = MF_PAIN|MF_NOGRAVITY|MF_RUNSPAWNFUNC
}

local function attanim(option) //Begins animation if option is in chosen lane.
	if (option.target.attlimit > 0 and option.target.state == S_ELMK2_ATT and option.state != S_OPTIONFIRE_1 and option.state != S_OPTIONFIRE_2)
		option.state = S_OPTIONFIRE_1
	end
	if (option.target.attlimit == 0 or option.target.lasatk == 0)
		option.state = S_OPTIONIDLE
	end
end

local function optionhandler(option,on1,on2,on3,off1,off2,off3) //Determines active lanes for options.
	if (option.target != nil)
	if (option.target.health <= 0 and option.health != 0)
		P_KillMobj(option)
	end
	if (option.valid  and option.health != 0)
	option.angle = option.target.angle
	if (option.target.acttime == 1050 or (option.target.lasatk == 0 and option.target.eggpoints < option.target.wkdelay) )
		option.state = S_OPTIONIDLE
	end
	if (option.target.lasatk == on1 or option.target.lasatk == on2 or option.target.lasatk == on3)
		attanim(option)
	end
	if (option.target.lasatk == off1 or option.target.lasatk == off2 or option.target.lasatk == off3)
		option.state = S_OPTIONIDLE
	end
	end
	end
end

local function optionspawn(option)
	option.scale = 7*FRACUNIT
	P_SetOrigin(option,option.x-FixedMul(256*FRACUNIT, cos(option.angle+FixedAngle(90*FRACUNIT))),
	option.y-FixedMul(256*FRACUNIT, sin(option.angle+FixedAngle(90*FRACUNIT))), option.z)
end

addHook("MobjSpawn", function(option)
	optionspawn(option)
end, MT_EGGOPTIONA)

addHook("MobjSpawn", function(option)
	optionspawn(option)
end, MT_EGGOPTIONB)

addHook("MobjSpawn", function(option)
	optionspawn(option)
end, MT_EGGOPTIONC)


addHook("MobjThinker", function(option)
	optionhandler(option,1,4,5,2,3,6)
end, MT_EGGOPTIONA)


addHook("MobjThinker", function(option)
	optionhandler(option,2,5,6,1,3,4)
end, MT_EGGOPTIONB)


addHook("MobjThinker", function(option)
	optionhandler(option,3,4,6,1,2,5)
end, MT_EGGOPTIONC)

local function compatkswitch(option, var) //Switches to active/inactive animation.
	if (var == S_OPTIONIDLE)
		option.state = var
	else
		attanim(option)
	end

end

local function compatk1(option,var) //Animation handler for checkerboard attacks.
		local off
		local on
		if (var == 1)
			on = S_OPTIONFIRE_1
			off = S_OPTIONIDLE
		else
			off = S_OPTIONFIRE_1
			on = S_OPTIONIDLE
		end
		if option.target.tics <= option.target.strdelay and option.target.tics > option.target.strdelay- option.target.str1interval
			compatkswitch(option, on)
		end
		if option.target.tics <= option.target.strdelay- option.target.str1interval and option.target.tics > option.target.strdelay- option.target.str1interval*2
			compatkswitch(option, off)
		end
		if option.target.tics <= option.target.strdelay- option.target.str1interval*2 and option.target.tics > 0
			compatkswitch(option, on)
		end
end

local function compatk2(option,var) //Animation Handler for sweep attacks.
		local off
		local on
		if (var == 1)
			on = S_OPTIONFIRE_1
			off = S_OPTIONIDLE
		else
			off = S_OPTIONFIRE_1
			on = S_OPTIONIDLE
		end
		if option.target.tics <= option.target.strdelay2 and option.target.tics > option.target.strdelay2- option.target.wkdelay
			if option.type == MT_EGGOPTIONB compatkswitch(option, off)
			else
				compatkswitch(option, on)
			end
		end
		if option.target.tics <= option.target.strdelay2- option.target.wkdelay and option.target.tics > option.target.strdelay2- option.target.wkdelay*2
			if option.type == MT_EGGOPTIONB compatkswitch(option, on)
			else
				compatkswitch(option, on)
			end
		end
		if option.target.tics <= option.target.strdelay2- option.target.wkdelay*2 and option.target.tics > 0
			if option.type == MT_EGGOPTIONB compatkswitch(option, on)
			else
				compatkswitch(option, off)
			end
		end
end
addHook("MobjThinker", function(option)
		//Checkerboard attack
		if (option.valid  and option.health != 0)
			if (option.target.lasatk == 7)
				compatk1(option,1)
			end
			if (option.target.lasatk == 8)
				compatk1(option,0)
			end
			//Swipe attack
			if (option.target.lasatk == 9)
				compatk2(option,1)
			end
			if (option.target.lasatk == 10)
				compatk2(option,0)
			end
			if (option.target.tics == 0)
				option.state = S_OPTIONIDLE
			end
		end
end, MT_EGGOPTIONA)

addHook("MobjThinker", function(option)
		//Checkerboard attack
		if (option.valid  and option.health != 0)
			if (option.target.lasatk == 7)
				compatk1(option,0)
			end
			if (option.target.lasatk == 8)
				compatk1(option,1)
			end
			//Swipe attack
			if (option.target.lasatk == 9)
				compatk2(option,1)
			end
			if (option.target.lasatk == 10)
				compatk2(option,1)
			end
			if (option.target.tics == 0)
				option.state = S_OPTIONIDLE
			end
		end
end, MT_EGGOPTIONB)

addHook("MobjThinker", function(option)
		//Checkerboard attack
		if (option.valid  and option.health != 0)
			if (option.target.lasatk == 7)
				compatk1(option,1)
			end
			if (option.target.lasatk == 8)
				compatk1(option,0)
			end
			//Swipe attack
			if (option.target.lasatk == 9)
				compatk2(option,0)
			end
			if (option.target.lasatk == 10)
				compatk2(option,1)
			end
			if (option.target.tics == 0)
				option.state = S_OPTIONIDLE
			end
		end
end, MT_EGGOPTIONC)

