local function enemyStats(hp, pp, offense, defense, speed, guts, luck)
	local stats = {}
	stats.hp = hp
	stats.pp = pp
	stats.offense = offense
	stats.defense = defense
	stats.speed = speed
	stats.guts = guts
	stats.luck = luck
	return stats
end

-- resistances work like this:
-- Fire, and Freeze 0 = 0%, 1 = 30%, 2 = 60%, 3 = 95%
-- Flash, Hypnosis, and Paralysis: 0 = 1%, 1 = 50%, 2 = 90%, 3 = 100%
-- Brainshock resistance is 3 - hypnosisResist

local enemies = {}
enemies[MT_BLUECRAWLA] = {
	theFlag = false,
	actions = {{action=120,arg=4}, {action=120,arg=4}, {action=121}, {action=123}},
	name = "Front Blue Crawla",
	gender = 0,
	encounterText = getTextEvent("encounter", "came"),
	deathText = getTextEvent("die", "destroyed"),
	finalAction = {action=118},
	stats = enemyStats(400, 0, 50, 25, 12, 0, 30),
	image = "BCRAWLA",
	music = "RBATL3",
	row = 2,
	boss = false,
	formations = {1},
	fireResist = 1,
	freezeResist = 3,
	flashResist = 2,
	hypnosisResist = 2,
	paralysisResist = 1
}

enemies[MT_BLUECRAWLABACK] = {
	theFlag = false,
	actions = {{action=120,arg=4}, {action=120,arg=4}, {action=121}, {action=123}},
	name = "Back Blue Crawla",
	gender = 0,
	encounterText = getTextEvent("encounter", "came"),
	deathText = getTextEvent("die", "destroyed"),
	finalAction = {action=118},
	stats = enemyStats(400, 0, 50, 25, 12, 0, 30),
	image = "BCRAWLA",
	music = "RBATL3",
	row = 1,
	boss = false,
	formations = {1},
	fireResist = 1,
	freezeResist = 3,
	flashResist = 2,
	hypnosisResist = 2,
	paralysisResist = 1
}

enemies[MT_REDCRAWLA] = {
	theFlag = false,
	actions = {{action=124,arg=5}, {action=124,arg=5}, {action=125,arg=45}, {action=127}},
	name = "Front Red Crawla",
	gender = 0,
	encounterText = getTextEvent("encounter", "came"),
	deathText = getTextEvent("die", "broken"),
	finalAction = {action=119},
	stats = enemyStats(275, 0, 50, 30, 18, 0, 15),
	image = "RCRAWLA",
	music = "RBATL3",
	row = 2,
	boss = false,
	formations = {1},
	fireResist = 3,
	freezeResist = 1,
	flashResist = 2,
	hypnosisResist = 1,
	paralysisResist = 2
}

enemies[MT_REDCRAWLABACK] = {
	theFlag = false,
	actions = {{action=124,arg=5}, {action=124,arg=5}, {action=125,arg=45}, {action=127}},
	name = "Back Red Crawla",
	gender = 0,
	encounterText = getTextEvent("encounter", "came"),
	deathText = getTextEvent("die", "broken"),
	finalAction = {action=119},
	stats = enemyStats(275, 0, 50, 30, 18, 0, 15),
	image = "RCRAWLA",
	music = "RBATL3",
	row = 1,
	boss = false,
	formations = {1},
	fireResist = 3,
	freezeResist = 1,
	flashResist = 2,
	hypnosisResist = 1,
	paralysisResist = 2
}

enemies[MT_BLONICCRAWLA] = {
	theFlag = true,
	actions = {{action=128,arg=MT_BLONICATTACK},{action=128,arg=MT_BLONICATTACK},{action=128,arg=MT_BLONICATTACK},{action=3,arg=2}},
	name = "Blonic Crawla",
	gender = 0,
	encounterText = getTextEvent("encounter", "came"),
	deathText = getTextEvent("die", "memory"),
	finalAction = nil,
	stats = enemyStats(1100, 0, 50, 100, 10, 400, 2),
	image = "BLCRAWLA",
	music = "BBATL1",
	row = 1,
	boss = true,
	formations = {1},
	fireResist = 3,
	freezeResist = 3,
	flashResist = 0,
	hypnosisResist = 3,
	paralysisResist = 3
}

enemies[MT_BLONICATTACK] = {
	theFlag = true,
	actions = {{action=132,arg=MT_BLONICCRAWLA}},
	name = "Blonic Crawla",
	gender = 0,
	encounterText = getTextEvent("encounter", "came"),
	deathText = getTextEvent("die", "memory"),
	finalAction = nil,
	stats = enemyStats(1100, 0, 50, 100, 10, 400, 2),
	image = "BLCRAWLA",
	music = "BBATL1",
	row = 1,
	boss = true,
	formations = {1},
	fireResist = 3,
	freezeResist = 3,
	flashResist = 0,
	hypnosisResist = 3,
	paralysisResist = 3
}

local formations = {}
formations[1] = {
	scene = 10099,
	letterbox = 1,
	enemies = {
		{
			amount = 1,
			enemy = MT_BLUECRAWLABACK
		},
		{
			amount = 1,
			enemy = MT_BLONICCRAWLA
		},
		{
			amount = 1,
			enemy = MT_REDCRAWLABACK
		},
		{
			amount = 2,
			enemy = MT_BLUECRAWLA
		},
		{
			amount = 1,
			enemy = MT_REDCRAWLA
		},
	}
}

local function getEnemy(enemyNum)
	if not enemies[enemyNum] then
		print("getEnemy(): Invalid Enemy number")
	end
	
	return enemies[enemyNum]
end

local function getFormation(formationNum)
	if not formations[formationNum] then
		print("getFormation(): Invalid Formation numer")
	end
	return formations[formationNum]
end

local function numEnemies(enemies)
	local n = 0
	for rowk,rowv in pairs(enemies) do
		for ek,enemy in pairs(rowv) do
			if enemy.status[1] ~= bConst.STATUS1_FAINTED and enemy.status[1] ~= bConst.STATUS1_DIAMONDIZED then
				n = n + 1
			end
		end
	end
	return n
end

rawset(_G, "getEnemy", getEnemy)
rawset(_G, "getFormation", getFormation)
rawset(_G, "numEnemies", numEnemies)
