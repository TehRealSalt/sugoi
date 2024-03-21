local function sign(num)
	if num == 0 then
		return 0
	end
	return num / abs(num)
end

local function stopDamage(player)
	local damageNum
	local party
	for i=1,#player.bother.party,1 do
		party = player.bother.party[i]
		if party.status[1] ~= bConst.STATUS1_FAINTED
		and party.currentStats.hp <= 1*FRACUNIT then
			party.damage = -(1*FRACUNIT-party.currentStats.hp)
		elseif party.damage > 0 then
			damageNum = party.damage
			party.damage = damageNum - (damageNum/FRACUNIT)*FRACUNIT
		end
	end
end

local function endBattle(player)
	player.bother.inBattle = nil
	player.bother.battle = {}
	player.bother.menu = {}
	player.awayviewtics = 0
	P_KillMobj(player.bother.encounterEnemy, nil, player.mo)

	for mobj in mobjs.iterate() do
		if not mobj.player and (mobj.flags & (MF_ENEMY|MF_BOSS)) then
			mobj.flags = mobj.flags & ~MF_NOTHINK
		end
	end
end

local function loseBattle(player)
	player.bother.inBattle = nil
	player.bother.battle = {}
	player.bother.menu = {}
	player.awayviewtics = 0
	P_KillMobj(player.mo, nil, player.bother.encounterEnemy)
end

local function partyDie(player, user, party)
	party.status[1] = bConst.STATUS1_FAINTED
	party.status[2] = 0
	party.status[3] = 0
	party.feelStrange = false
	party.cantConcentrate = 0
	party.currentStats.hp = 0
	local battleLose = true
	player.bother.window = 5
	for i=1,#player.bother.party,1 do
		if player.bother.party[i].status[1] ~= bConst.STATUS1_FAINTED and player.bother.party[i].status[1] ~= bConst.STATUS1_DIAMONDIZED then
			battleLose = false
			break
		end
	end

	for k,v in pairs(player.bother.battle.actions) do
		for sk,sv in pairs(v.subactions) do
			if sv.user == party then
				table.remove(player.bother.battle.actions[k].subactions, sk)
			end
		end
		if #player.bother.battle.actions[k].subactions <= 0 then
			table.remove(player.bother.battle.actions, k)
		end
	end

	if battleLose then
		for i=2,#player.bother.battle.actions,1 do
			-- remove the remaining actions
			table.remove(player.bother.battle.actions)
		end
		table.insert(player.bother.battle.actions, {subactions = {{textEvent = getTextEvent("die", "lostbattle")}}})
		table.insert(player.bother.battle.actions[#player.bother.battle.actions].subactions, {func = loseBattle})
	end
end

local function enemyDie(player, user, enemy)
	enemy.status[1] = bConst.STATUS1_FAINTED
	enemy.dying = -1
	enemy.currentStats.hp = 0
	for k,v in pairs(player.bother.battle.actions) do
		for sk,sv in pairs(v.subactions) do
			if sv.user == enemy then
				table.remove(player.bother.battle.actions[k].subactions, sk)
			end
		end
		if #player.bother.battle.actions[k].subactions <= 0 then
			table.remove(player.bother.battle.actions, k)
		end
	end

	local enemyNum = 0

	for rowk,rowv in pairs(player.bother.battle.enemies) do
		for enemyk,enemy in pairs(rowv) do
			if enemy.status[1] ~= bConst.STATUS1_FAINTED and enemy.status[1] ~= bConst.STATUS1_DIAMONDIZED then
				enemyNum = enemyNum + 1
			end
		end
	end

	if enemyNum == 0 then
		for i=2,#player.bother.battle.actions,1 do
			-- remove the remaining actions
			table.remove(player.bother.battle.actions)
		end
		stopDamage(player) -- this is done immediately
		if getEnemy(player.bother.encounterEnemy.type).boss then
			table.insert(player.bother.battle.actions, {subactions={{textEvent = getTextEvent("action", "bosswon")}}})
		else
			table.insert(player.bother.battle.actions, {subactions={{textEvent = getTextEvent("action", "youwon")}}})
		end
		table.insert(player.bother.battle.actions[#player.bother.battle.actions].subactions, {func = endBattle})
	end
end

local function resetCurrentStats(partyMember)
	partyMember.currentStats.offense = partyMember.stats.offense
	partyMember.currentStats.defense = partyMember.stats.defense
	partyMember.currentStats.speed = partyMember.stats.speed
	partyMember.currentStats.guts = partyMember.stats.guts
	partyMember.currentStats.vitality = partyMember.stats.vitality
	partyMember.currentStats.iq = partyMember.stats.iq
	partyMember.currentStats.luck = partyMember.stats.luck
end

local sceneAiming = {}
sceneAiming[10000] = false
sceneAiming[10001] = false
sceneAiming[10002] = true
sceneAiming[10099] = true

local function battleInitiate(player)
	local bother = player.bother
	bother.inBattle = #player
	S_ChangeMusic(getEnemy(bother.encounterEnemy.type).music, true, player)

	bother.battle = {}
	bother.battle.actions = {}

	bother.battle.enemies = {}
	bother.battle.enemies[1] = {} -- row 1 enemies
	bother.battle.enemies[2] = {} -- row 2 enemies

	local formation
	local formationEnemies
	local row

	-- Store a list of the enemy numbers that are wanted for each row
	-- I do this so I can place them correctly for the start of the battle
	local tempEnemies
	tempEnemies = {}
	tempEnemies[1] = {}
	tempEnemies[2] = {}

	local enemy

	formation = getFormation(bother.encounterFormation)
	for i=1,#formation.enemies,1 do
		formationEnemies = formation.enemies[i]
		for j=1,formationEnemies.amount,1 do
			row = getEnemy(formationEnemies.enemy).row
			if #tempEnemies[row] < 7 then -- max 7 per row!
				-- set the enemy in the temporary table

				tempEnemies[row][#tempEnemies[row]+1] = {}
				enemy = tempEnemies[row][#tempEnemies[row]]
				enemy.type = formationEnemies.enemy
				if formationEnemies.amount > 1 then
					enemy.name = getEnemy(enemy.type).name .. " " .. string.char(64 + j)
				elseif getEnemy(enemy.type).theFlag then
					enemy.name = "The " .. getEnemy(enemy.type).name
				else
					enemy.name = getEnemy(enemy.type).name
				end
				enemy.currentStats = {} -- copy all of the stats from the enemy definition
				for k,v in pairs(getEnemy(enemy.type).stats) do
					enemy.currentStats[k] = v
				end
				enemy.status = {0, 0, 0}
				enemy.takeDamage = enemyTakeDamage
			end
		end
	end

	local initGap
	local enemyPos


	local thisEnemy = {}

	for i=1,#tempEnemies,1 do
		initGap = (7-#tempEnemies[i])/2
		for j=1,#tempEnemies[i],1 do
			-- whyyyyyy
			-- Okay, this gives me the position the enemy will be in based on
			-- how many enemies are in row
			enemyPos = initGap + FixedRealRound(FixedDiv((7-(initGap*2)+1)*FRACUNIT, (#tempEnemies[i]+1)*FRACUNIT)*j)/FRACUNIT
			bother.battle.enemies[i][enemyPos] = tempEnemies[i][j]
		end
	end

	for sector in sectors.iterate do
		if sector.tag == getFormation(bother.encounterFormation).scene then
			for thing in sector.thinglist() do
				if thing.type == MT_ALTVIEWMAN then
					player.awayviewmobj = thing
					player.awayviewtics = 1
					if sceneAiming[getFormation(bother.encounterFormation).scene] then
						player.awayviewaiming = FixedAngle(-59*FRACUNIT)
					else
						player.awayviewaiming = 0
					end
					break
				end
			end
		end
	end

	-- text events...
	bother.battle.actions = {}
	table.insert(bother.battle.actions, 1, {subactions={{textEvent = getEnemy(bother.encounterEnemy.type).encounterText}}})
end

local function playerBattleThink(player)
	local bother = player.bother
	local party
	player.mo.momx = 0
	player.mo.momy = 0
	player.mo.momz = 0
	player.awayviewtics = 1

	for i=1,#bother.party,1 do
		party = bother.party[i]
		if party.damage then
			-- 7 health lost per second (0.2 per tic)
			-- TODO: doubled during the turn when not guarding
			local meterSpeed = FixedDiv(7*FRACUNIT, TICRATE*FRACUNIT)

			if (bother.battle.actions and #bother.battle.actions > 0
			and bother.textBox and bother.textBox.active
			and not party.defending)
			or party.damage < 0 then
				meterSpeed = meterSpeed * 2
			end

			if abs(party.damage) - meterSpeed < 0 then
				party.currentStats.hp = party.currentStats.hp - party.damage
				party.damage = 0
			else
				party.currentStats.hp = party.currentStats.hp - sign(party.damage) * meterSpeed
				party.damage = party.damage - sign(party.damage) * meterSpeed
			end

			if party.currentStats.hp == 0 then
				if bother.menu and bother.menu.active then
					-- if we're in a battle menu, immediately kill the menu and tell you they died
					-- Also removes all currently queued actions because I can't
					-- think of how I want to just run the event then go back to the menu
					bother.battle.actions = {}
					bother.menu.active = false
					table.insert(player.bother.battle.actions, 1, {subactions={{target = party, textEvent = getTextEvent("die", "allydie")}}})
					table.insert(player.bother.battle.actions[1].subactions, {target = party, func = partyDie})
				else
					table.insert(player.bother.battle.actions, 2, {subactions={{target = party, textEvent = getTextEvent("die", "allydie")}}})
					table.insert(player.bother.battle.actions[2].subactions, {target = party, func = partyDie})
				end
			else
				-- This is hacky, if the player has health, search for the death
				-- action and remove it so there's no cases of healing yourself
				-- and then dying
				for k,v in pairs(player.bother.battle.actions) do
					if v.subactions[1].textEvent == getTextEvent("die", "allydie") and v.subactions[1].target == party then
						table.remove(player.bother.battle.actions, k)
						table.remove(player.bother.battle.actions, k) -- remove the 2nd event that does the dying
					end
				end
			end
		end
		if party.ppUsed then
			-- PP doesn't work with the rolling counter, this is purely cosmetic
			-- 14 PP change per second
			local meterSpeed = FixedDiv(14*FRACUNIT, TICRATE*FRACUNIT)

			if abs(party.ppUsed) - meterSpeed < 0 then
				party.currentStats.pp = party.currentStats.pp - party.ppUsed
				party.ppUsed = 0
			else
				party.currentStats.pp = party.currentStats.pp - sign(party.ppUsed) * meterSpeed
				party.ppUsed = party.ppUsed - sign(party.ppUsed) * meterSpeed
			end
		end
	end

	for rowk,rowv in pairs(player.bother.battle.enemies) do
		for enemyk,enemy in pairs(rowv) do
			if enemy.status[1] == bConst.STATUS1_FAINTED and enemy.dying then
				player.bother.battle.enemies[rowk][enemyk].dying = enemy.dying - 1
			end
			if enemy.flashing then
				enemy.flashing = enemy.flashing - 1
			end
		end
	end

	if bother.battle.actions and #bother.battle.actions > 0
	and not (bother.menu and bother.menu.active)
	and not (bother.textBox and bother.textBox.active and bother.textBox.textEvent) then
		activateAction(player)
	elseif (not bother.textBox or bother.textBox.active == false)
	and (not bother.menu or bother.menu.active == false) then
		setupBattleMenu(player, 1)
	end
end

local function partyTakeDamage(player, user, party)
	local damage = player.bother.battle.actions[1].subactions[1].number
	if damage*FRACUNIT + party.damage > party.currentStats.hp then
		party.damage = party.currentStats.hp
		if damage > 0 then
			player.bother.screenShakeIntensity = 16
		end
	else
		party.damage = party.damage + damage*FRACUNIT;
		if damage > 0 then
			player.bother.screenShakeIntensity = 8
		end
	end

	if party.damage < 0 then
		if abs(party.damage) + party.currentStats.hp > party.stats.hp*FRACUNIT then
			party.damage = -(party.stats.hp*FRACUNIT - party.currentStats.hp)
		end
	end
end

local function enemyTakeDamage(player, user, enemy)
	local damage = player.bother.battle.actions[1].subactions[1].number
	enemy.currentStats.hp = enemy.currentStats.hp - damage;
	if damage > 0 then
		enemy.flashing = 18
	end
	if enemy.currentStats.hp <= 0 then
		enemy.currentStats.hp = 0;
		if getEnemy(enemy.type).finalAction then
			local enemyInfo = getEnemy(enemy.type)
			local fAction = getAction(enemyInfo.finalAction.action)
			local whotarget
			if fAction.direction == bConst.ACTIONDIR_PARTY then
				if fAction.target == bConst.ACTIONTARGET_ALL then
					whotarget = "enemies"
				elseif fAction.target == bConst.ACTIONTARGET_ROW then
					-- TO DO
				end
			elseif fAction.direction == bConst.ACTIONDIR_ENEMY then
				if fAction.target == bConst.ACTIONTARGET_ALL or fAction.target == bConst.ACTIONTARGET_ROW then
					whotarget = "party"
				end
			end
			-- TODO: HACK the normal action has already taken place, I'm just
			-- hijacking the normal action's subactions for this action, so I'll
			-- just replace what action was used
			player.bother.battle.actions[1].action = fAction
			table.insert(player.bother.battle.actions[1].subactions, 2, {user = enemy, target = whotarget,
				textEvent = fAction.textEvent, func = fAction.func, arg = enemyInfo.finalAction.arg})
			table.insert(player.bother.battle.actions[1].subactions, 3, {target = enemy,
				textEvent = getEnemy(enemy.type).deathText, func = enemyDie})
		else
			-- This specifically does NOT have the user as the user COULD be the one who dies!
			-- That would cause this action to be removed too!
			table.insert(player.bother.battle.actions[1].subactions, 2, {target = enemy,
				textEvent = getEnemy(enemy.type).deathText, func = enemyDie})
		end
	elseif enemy.currentStats.hp > getEnemy(enemy.type).stats.hp then
		enemy.currentStats.hp = getEnemy(enemy.type).stats.hp
	end
end

rawset(_G, "resetCurrentStats", resetCurrentStats)
rawset(_G, "battleInitiate", battleInitiate)
rawset(_G, "playerBattleThink", playerBattleThink)
rawset(_G, "partyTakeDamage", partyTakeDamage) -- party is set in BOTH when first spawned
rawset(_G, "enemyTakeDamage", enemyTakeDamage) -- enemies are added in actions
