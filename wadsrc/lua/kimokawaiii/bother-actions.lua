-- attack types
local ACTIONTYPE_PHYSICAL1 = 1 -- affected by shields and defending
local ACTIONTYPE_PHYSICAL2 = 2 -- unaffected by shields and defending
local ACTIONTYPE_PSI = 3
local ACTIONTYPE_OTHER = 4

-- shields, one at a time, new ones replace old ones
local SHIELD_PHYSICAL = 1
local SHIELD_POWERPHYSICAL = 2
local SHIELD_PSI = 3
local SHIELD_POWERPSI = 4

-- gets a random, alive, party member
local function randomParty(party)
	local totalAlive = 0
	for i=1,#party,1 do
		if party[i].status[1] ~= bConst.STATUS1_FAINTED and party[i].status[1] ~= bConst.STATUS1_DIAMONDIZED then
			totalAlive = totalAlive + 1
		end
	end
	local r = P_RandomKey(totalAlive) + 1
	local aliveNum = 0
	for i=1,#party,1 do
		if party[i].status[1] ~= bConst.STATUS1_FAINTED and party[i].status[1] ~= bConst.STATUS1_DIAMONDIZED then
			aliveNum = aliveNum + 1
		end
		if aliveNum == r then
			return party[i]
		end
	end
end

local function randomEnemy(enemies)
	local totalAlive = 0
	for rowk,rowv in pairs(enemies) do
		for enemyk,enemy in pairs(rowv) do
			if enemy.status[1] ~= bConst.STATUS1_FAINTED and enemy.status[1] ~= bConst.STATUS1_DIAMONDIZED then
				totalAlive = totalAlive + 1
			end
		end
	end
	local r = P_RandomKey(totalAlive) + 1
	local aliveNum = 0
	for rowk,rowv in pairs(enemies) do
		for enemyk,enemy in pairs(rowv) do
			if enemy.status[1] ~= bConst.STATUS1_FAINTED and enemy.status[1] ~= bConst.STATUS1_DIAMONDIZED then
				aliveNum = aliveNum + 1
			end
			if aliveNum == r then
				return enemies[rowk][enemyk]
			end
		end
	end
end

local function randomAll(bother)
	local totalAlive = 0
	for i=1,#bother.party,1 do
		if bother.party[i].status[1] ~= bConst.STATUS1_FAINTED and bother.party[i].status[1] ~= bConst.STATUS1_DIAMONDIZED then
			totalAlive = totalAlive + 1
		end
	end
	for rowk,rowv in pairs(bother.battle.enemies) do
		for enemyk,enemy in pairs(rowv) do
			if enemy.status[1] ~= bConst.STATUS1_FAINTED and enemy.status[1] ~= bConst.STATUS1_DIAMONDIZED then
				totalAlive = totalAlive + 1
			end
		end
	end
	local r = P_RandomKey(totalAlive) + 1
	local aliveNum = 0
	for i=1,#bother.party,1 do
		if bother.party[i].status[1] ~= bConst.STATUS1_FAINTED and bother.party[i].status[1] ~= bConst.STATUS1_DIAMONDIZED then
			aliveNum = aliveNum + 1
		end
		if aliveNum == r then
			
			return bother.party[i]
		end
	end
	for rowk,rowv in pairs(bother.battle.enemies) do
		for enemyk,enemy in pairs(rowv) do
			if enemy.status[1] ~= bConst.STATUS1_FAINTED and enemy.status[1] ~= bConst.STATUS1_DIAMONDIZED then
				aliveNum = aliveNum + 1
			end
			if aliveNum == r then
				return bother.battle.enemies[rowk][enemyk]
			end
		end
	end
end



local function stopDefending(user)
	user.defending = false
end

local function nauseaRecover(player, user, target)
	if target.status[1] == bConst.STATUS1_NAUSEA then
		target.status[1] = 0
	end
end

local function poisonRecover(player, user, target)
	if target.status[1] == bConst.STATUS1_POISON then
		target.status[1] = 0
	end
end

local function sunstrokeRecover(player, user, target)
	if target.status[1] == bConst.STATUS1_SUNSTROKE then
		target.status[1] = 0
	end
end

local function coldRecover(player, user, target)
	if target.status[1] == bConst.STATUS1_COLD then
		target.status[1] = 0
	end
end

local function sleepRecover(player, user, target)
	if target.status[3] == bConst.STATUS3_SLEEP
		target.status[3] = 0
	end
end

local function cryingRecover(player, user, target)
	if target.status[3] == bConst.STATUS3_CRYING then
		target.status[3] = 0
	end
end

local function immobilizeRecover(player, user, target)
	if target.status[3] == bConst.STATUS3_IMMOBILIZED
		target.status[3] = 0
	end
end

local function solidifyRecover(player, user, target)
	if target.status[3] == bConst.STATUS3_SOLIDIFIED
		target.status[3] = 0
	end
end

local function feelingStrangeRecover(player, user, target)
	if target.feelStrange then
		target.feelStrange = false
	end
end

-- check to see if the user can act that turn based on status
-- if they can, do any of the other status related things first
local function statusCheck(player, user, target)
	if user.status[1] == bConst.STATUS1_PARALYSIS then
		local action = player.bother.battle.actions[1].action
		if action.type == ACTIONTYPE_PHYSICAL1 or action.type == ACTIONTYPE_PHYSICAL2 then
			table.insert(player.bother.battle.actions[1].subactions, {user = user,
				textEvent = getTextEvent("status", "numbcantmove")})
			return false
		end
	elseif user.status[1] == bConst.STATUS1_POISON then
		local damage = 20*FRACUNIT
		local damageRange = FixedRealRound(FixedMul(damage, P_RandomRange(-FRACUNIT/4, FRACUNIT/4)))
		damage = (damage + damageRange)/FRACUNIT
		table.insert(player.bother.battle.actions[1].subactions, {user = user,
			number = damage, textEvent = getTextEvent("status", "poisondamage"), func = user.takeDamage})
	elseif user.status[1] == bConst.STATUS1_NAUSEA then
		local damage = 20*FRACUNIT
		local damageRange = FixedRealRound(FixedMul(damage, P_RandomRange(-FRACUNIT/4, FRACUNIT/4)))
		damage = (damage + damageRange)/FRACUNIT
		table.insert(player.bother.battle.actions[1].subactions, {user = user,
			number = damage, textEvent = getTextEvent("status", "nauseadamage"), func = user.takeDamage})
	elseif user.status[1] == bConst.STATUS1_SUNSTROKE then
		local damage = 4*FRACUNIT
		local damageRange = FixedRealRound(FixedMul(damage, P_RandomRange(-FRACUNIT/4, FRACUNIT/4)))
		damage = (damage + damageRange)/FRACUNIT
		table.insert(player.bother.battle.actions[1].subactions, {user = user,
			number = damage, textEvent = getTextEvent("status", "sunstrokedmg"), func = user.takeDamage})
	elseif user.status[1] == bConst.STATUS1_COLD then
		local damage = 4*FRACUNIT
		local damageRange = FixedRealRound(FixedMul(damage, P_RandomRange(-FRACUNIT/4, FRACUNIT/4)))
		damage = (damage + damageRange)/FRACUNIT
		table.insert(player.bother.battle.actions[1].subactions, {user = user,
			number = damage, textEvent = getTextEvent("status", "colddamage"), func = user.takeDamage})
	end
	
	if user.status[3] == bConst.STATUS3_SLEEP then
		if target then
			table.insert(player.bother.battle.actions[1].subactions, {user = user,
				textEvent = getTextEvent("status", "fallenasleep")})
		end
		return false
	elseif user.status[3] == bConst.STATUS3_IMMOBILIZED then	
		local action = player.bother.battle.actions[1].action
		if action.type == ACTIONTYPE_PHYSICAL1 or action.type == ACTIONTYPE_PHYSICAL2 then
			table.insert(player.bother.battle.actions[1].subactions, {user = user,
				textEvent = getTextEvent("status", "cantmovearound")})
			return false
		end
	elseif user.status[3] == bConst.STATUS3_SOLIDIFIED then
		return false
	end
	if user.feelStrange then
		if P_RandomChance(FRACUNIT/2) then
			if target == "enemies" or target == "party" then
				if P_RandomRange(0, 1) then
					target = "enemies"
				else
					target = "party"
				end
			elseif target == "enemythunder" or target == "partythunder" then
				if P_RandomRange(0, 1) then
					target = "enemythunder"
				else
					target = "partythunder"
				end
			elseif target == 1 or target == 2 then
				target = P_RandomRange(1, 3)
			elseif target ~= nil
				target = randomAll(player.bother)
			end
			player.bother.battle.actions[1].subactions[1].target = target
			table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
				textEvent = getTextEvent("status", "actunusual")})
		end
	end
	return true
end

local function ppCheck(player, user, amount)
	if (user.skin and user.currentStats.pp < amount*FRACUNIT)
	or (not user.skin and user.currentStats.pp < amount) then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("action", "nopp")})
		return false
	end
	return true
end

local function useActionPP(player, user, target)
	if user.skin then
		user.ppUsed = player.bother.battle.actions[1].action.pp*FRACUNIT
	else
		user.currentStats.pp = user.currentStats.pp - player.bother.battle.actions[1].action.pp
	end
end

local function deadCheck(player, target, silent)
	-- make sure the target is actually alive...
	if target == "enemythunder" or target == "partythunder" then
		return false
	end
	if target.status[1] == bConst.STATUS1_FAINTED or target.status[1] == bConst.STATUS1_DIAMONDIZED then
		if not silent then
			table.insert(player.bother.battle.actions[1].subactions, {target = target,
				textEvent = getTextEvent("action", "alreadygone")})
		end
		return true
	end
	return false
end

local function postActionStuff(player, user)
	if user.status[3] == bConst.STATUS3_SLEEP then
		if P_RandomChance(FRACUNIT/4) then
			table.insert(player.bother.battle.actions[1].subactions, {user = user, target = user,
				textEvent = getTextEvent("status", "wokeup")})
			table.insert(player.bother.battle.actions[1].subactions, {user = user, target = user,
				func = sleepRecover})
		end
	elseif user.status[3] == bConst.STATUS3_IMMOBILIZED then
		local action = player.bother.battle.actions[1].action
		if P_RandomChance((85*FRACUNIT) / 100) then
			table.insert(player.bother.battle.actions[1].subactions, {user = user, target = user,
				textEvent = getTextEvent("status", "movedfreely")})
			table.insert(player.bother.battle.actions[1].subactions, {user = user, target = user,
				func = immobilizeRecover})
		end
	elseif user.status[3] == bConst.STATUS3_SOLIDIFIED then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = user,
			textEvent = getTextEvent("status", "abletomove")})
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = user,
			func = solidifyRecover})
	end
end

local function doAction(player, user, target, preAction, func, ...)
	stopDefending(user)
	
	-- StatusCheck returning false means that the user was unable to perform their action
	if statusCheck(player, user, target) then
		-- target might have been changed in statusCheck
		target = player.bother.battle.actions[1].subactions[1].target
		if not ppCheck(player, user, player.bother.battle.actions[1].action.pp) then
			return
		end
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = player.bother.battle.actions[1].action.textEvent, func = useActionPP,
			arg = player.bother.battle.actions[1].subactions[1].arg})
		
		if preAction then
			preAction.target = target
			table.insert(player.bother.battle.actions[1].subactions, preAction)
		end
		
		if func then
			if not target then -- should be just a self action...
				func(player, user, ...)
			elseif target == "enemies" then -- all enemies
				for rowk,rowv in pairs(player.bother.battle.enemies) do
					for ek, enemy in pairs(rowv) do
						if not deadCheck(player, enemy, true)
							func(player, user, player.bother.battle.enemies[rowk][ek], ...)
						end
					end
				end
			elseif target == "party" or target == 3 then -- all allies
				for i=1,#player.bother.party,1 do
					if not deadCheck(player, player.bother.party[i], true)
						func(player, user, player.bother.party[i], ...)
					end
				end
			elseif type(target) == "number" then -- row of enemies
				for ek, enemy in pairs(player.bother.battle.enemies[target]) do
					if not deadCheck(player, enemy, true)
						func(player, user, player.bother.battle.enemies[target][ek], ...)
					end
				end
			else -- one enemy or party member (or thunder)
				if not deadCheck(player, target, false)
					func(player, user, target, ...)
				end
			end
		end
	end
	postActionStuff(player, user, target)
end

-- dLevel = level of attack
-- offense = user offense
-- defense = target defense
-- range = range of the damage to be done (FRACUNIT/4) is +-25%
local function physicalDamage(dLevel, offense, defense, range)
	local damage = ((dLevel * offense) - defense)*FRACUNIT
	local damageRange = P_RandomRange(-range, range)
	damage = damage + FixedMul(damage, damageRange)
	return max(FixedRealRound(damage)/FRACUNIT, 1)
end

local function doDamage(player, user, target, damage)
	if target.skin ~= nil then -- It's a party member
		if target.damage + damage*FRACUNIT >= target.currentStats.hp then
			table.insert(player.bother.battle.actions[1].subactions, {target = target, user = user,
				number = damage, textEvent = getTextEvent("action", "mortaldamage"), func = target.takeDamage})
		else
			table.insert(player.bother.battle.actions[1].subactions, {target = target, user = user, 
				number = damage, textEvent = getTextEvent("action", "allydamage"), func = target.takeDamage})
		end
	else
		table.insert(player.bother.battle.actions[1].subactions, {target = target, user = user,
			number = damage, textEvent = getTextEvent("action", "enemydamage"), func = target.takeDamage})
	end
	
	if target.status[3] == bConst.STATUS3_SLEEP then
		if P_RandomChance(FRACUNIT/2) then
			table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
				textEvent = getTextEvent("status", "wokeup")})
			table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
				func = sleepRecover})
		end
	end
end

local function shieldDisappearPerform(player, user, target)
	target.shield = 0
	target.shieldDuration = 0
end

local function shieldDisappear(player, target)
	table.insert(player.bother.battle.actions[1].subactions, 2, {textEvent = getTextEvent("action", "shielddis"), func = shieldDisappearPerform, target = target})
end

local function shieldDeplete(player, user, target)
	local amount = player.bother.battle.actions[1].subactions[1].arg
	if amount > target.shieldDuration then
		amount = target.shieldDuration
	end
	if target.shieldDuration > 0 then
		target.shieldDuration = target.shieldDuration - amount
		if target.shieldDuration == 0 then
			shieldDisappear(player, target)
		end
	end
end

local function bash(player, user, target, ...)
	local dLevel = ...
	-- first check if they'll miss
	local probability = FRACUNIT/16
	if user.status[3] == bConst.STATUS3_CRYING then
		probability = probability + FRACUNIT/2
	end
	if P_RandomChance(probability) then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
		textEvent = getTextEvent("action", "missed")})
		return false
	end
	if player.bother.battle.actions[1].action.type == ACTIONTYPE_PHYSICAL1 then
		probability = FixedDiv(user.currentStats.guts*FRACUNIT, 500*FRACUNIT)
		if FRACUNIT/20 > probability then
			probability = FRACUNIT/20
		end
		if P_RandomChance(min(probability, FRACUNIT)) then
			local damage = physicalDamage(4, user.currentStats.offense, target.currentStats.defense, 0)
			
			if target.defending then
				damage = damage / 2
			end
			if target.shield == SHIELD_PHYSICAL or target.shield == SHIELD_POWERPHYSICAL then
				damage = damage / 2
			end
			damage = max(damage, 1)
			
			if user.skin ~= nil then
				table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
				textEvent = getTextEvent("action", "allysmash")})
			else
				table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
				textEvent = getTextEvent("action", "enemysmash")})
			end
			
			doDamage(player, user, target, damage)
			
			if target.shield == SHIELD_PHYSICAL or target.shield == SHIELD_POWERPHYSICAL then
				if target.shield == SHIELD_POWERPHYSICAL then
					table.insert(player.bother.battle.actions[1].subactions, {textEvent = getTextEvent("action", "shielddef")})
					doDamage(player, user, user, damage/2)
				end
				table.insert(player.bother.battle.actions[1].subactions, {func = shieldDeplete, target = target, arg = 3})
			end
			return true
		end
	end
	probability = FixedDiv((2*target.currentStats.speed - user.currentStats.speed)*FRACUNIT, 500*FRACUNIT)
	if P_RandomChance(min(probability, FRACUNIT)) then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
		textEvent = getTextEvent("action", "dodged")})
		return false
	end
	
	-- damage
	local damage = physicalDamage(dLevel, user.currentStats.offense, target.currentStats.defense, FRACUNIT/4)
	if player.bother.battle.actions[1].action.type == ACTIONTYPE_PHYSICAL1 then
		if target.defending then
			damage = damage / 2
		end
		if target.shield == SHIELD_PHYSICAL or target.shield == SHIELD_POWERPHYSICAL then
			damage = damage / 2
		end
	end
	damage = max(damage, 1)
	
	doDamage(player, user, target, damage)
	
	if target.shield == SHIELD_PHYSICAL or target.shield == SHIELD_POWERPHYSICAL then
		if target.shield == SHIELD_POWERPHYSICAL then
			table.insert(player.bother.battle.actions[1].subactions, {textEvent = getTextEvent("action", "shielddef")})
			doDamage(player, user, user, damage/2)
		end
		table.insert(player.bother.battle.actions[1].subactions, {func = shieldDeplete, target = target, arg = 1})
	end
	
	-- status
	-- Bash (not shoots) stop the target from feeling strange
	if player.bother.battle.actions[1].action.type == ACTIONTYPE_PHYSICAL1 and target.feelStrange then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("status", "backtonormal")})
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			func = feelingStrangeRecover})
	end
	return true
end

local function bashAction(player, user, target)
	doAction(player, user, target, nil, bash, player.bother.battle.actions[1].subactions[1].arg)
end

local function defend(player, user)
	user.defending = true
end

local function defendAction(player, user)
	doAction(player, user, nil, nil, defend)
end

local function paralysisPerform(player, user, target)
	if not target.status[1] or target.status[1] > bConst.STATUS1_PARALYSIS then
		target.status[1] = bConst.STATUS1_PARALYSIS
	end
end

local function paralysis(player, user, target, silentFail)
	if not target.status[1] or target.status[1] > bConst.STATUS1_PARALYSIS then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("status", "paralysis")})
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			func = paralysisPerform})
	elseif not silentFail then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("action", "didnotwork")})
	end
end

local function paralysisAction(player, user, target)
	doAction(player, user, target, nil, paralysis, false)
end

local function sleepPerform(player, user, target)
	if not target.status[3] or target.status[3] > bConst.STATUS3_SLEEP then
		target.status[3] = bConst.STATUS3_SLEEP
	end
end

local function sleep(player, user, target, silentFail)
	if not target.status[3] or target.status[3] > bConst.STATUS3_SLEEP then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("status", "sleep")})
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			func = sleepPerform})
	elseif not silentFail then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("action", "didnotwork")})
	end
end

local function cryingPerform(player, user, target)
	if not target.status[3] or target.status[3] > bConst.STATUS3_CRYING then
		target.status[3] = bConst.STATUS3_CRYING
	end
end

local function crying(player, user, target, silentFail)
	if not target.status[3] or target.status[3] > bConst.STATUS3_CRYING then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("status", "crying")})
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			func = cryingPerform})
	elseif not silentFail then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("action", "didnotwork")})
	end
end

local function cryingAction(player, user, target)
	doAction(player, user, target, nil, crying, false)
end

local function immobilizePerform(player, user, target)
	if not target.status[3] or target.status[3] > bConst.STATUS3_IMMOBILIZED then
		target.status[3] = bConst.STATUS3_IMMOBILIZED
	end
end

local function immobilize(player, user, target, silentFail)
	if not target.status[3] or target.status[3] > bConst.STATUS3_IMMOBILIZED then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("status", "immobilized")})
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			func = immobilizePerform})
	elseif not silentFail then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("action", "didnotwork")})
	end
end

local function immobilizeAction(player, user, target)
	doAction(player, user, target, nil, immobilize, false)
end

local function solidifyPerform(player, user, target)
	if not target.status[3] or target.status[3] > bConst.STATUS3_SOLIDIFIED then
		target.status[3] = bConst.STATUS3_SOLIDIFIED
	end
end

local function solidify(player, user, target, silentFail)
	if not target.status[3] or target.status[3] > bConst.STATUS3_SOLIDIFIED then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("status", "solidified")})
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			func = solidifyPerform})
	elseif not silentFail then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("action", "didnotwork")})
	end
end

local function solidifyAction(player, user, target)
	doAction(player, user, target, nil, solidify, false)
end

local function feelingStrangePerform(player, user, target)
	target.feelStrange = true
end

local function feelingStrange(player, user, target, silentFail)
	if not target.feelStrange then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("status", "feelstrange")})
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			func = feelingStrangePerform})
	elseif not silentFail then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("action", "didnotwork")})
	end
end

local function feelingStrangeAction(player, user, target)
	doAction(player, user, target, nil, feelingStrange, false)
end

local function PKSpeedPerform(player, user, target, ...)
	local minDamage, maxDamage = ...
	
	if target.shield == SHIELD_PSI or target.shield == SHIELD_POWERPSI then
		if target.shield == SHIELD_PSI then
			table.insert(player.bother.battle.actions[1].subactions, {textEvent = getTextEvent("action", "psyshielddis"),
				user = user, target = target, arg = player.bother.battle.actions[1].subactions[1].arg})
			table.insert(player.bother.battle.actions[1].subactions, {func = shieldDeplete, user = user, target = target, arg = 1})
			return
		elseif target.shield == SHIELD_POWERPSI then
			table.insert(player.bother.battle.actions[1].subactions, {textEvent = getTextEvent("action", "psyshielddef"),
				user = user, target = target, arg = player.bother.battle.actions[1].subactions[1].arg})
			target = user
		end
		table.insert(player.bother.battle.actions[1].subactions, {func = shieldDeplete, user = user, target = target, arg = 1})
	end
	
	local probability = FixedDiv((target.currentStats.speed*2 - user.currentStats.speed)*FRACUNIT, 5*FRACUNIT)
	probability = probability / 100
	if P_RandomChance(probability) then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("action", "didnotwork")})
	else
		doDamage(player, user, target, P_RandomRange(minDamage, maxDamage))
	end
end

local function resistFromNumAssist(num)
	if num == 0 then
		return FRACUNIT/100 -- 1% chance of failing
	elseif num == 1 then
		return FRACUNIT/2 -- 50% chance of failing
	elseif num == 2 then
		return (FRACUNIT*9)/10 -- 90% chance of failing
	elseif num == 3 then
		return FRACUNIT -- 100% chance of failing
	end
end

local function vulnFromNumOffense(num)
	if num == 0 then
		return FRACUNIT -- Take 100% damage
	elseif num == 1 then
		return (FRACUNIT*7)/10 -- 70% damage
	elseif num == 2 then
		return (FRACUNIT*4)/10 -- 40% damage
	elseif num == 3 then
		return FRACUNIT/20 -- 5% damage
	end
end

local function pkSpeedA(player, user, target)
	local preAction = {textEvent = getTextEvent("psi", "speedA"), user = user, target = target}
	doAction(player, user, target, preAction, PKSpeedPerform, 40, 120)
end

local function pkSpeedB(player, user, target)
	local preAction = {textEvent = getTextEvent("psi", "speedB"), user = user, target = target}
	doAction(player, user, target, preAction, PKSpeedPerform, 90, 270)
end

local function firePerform(player, user, target, ...)
	local minDamage, maxDamage = ...
	
	if target.shield == SHIELD_PSI or target.shield == SHIELD_POWERPSI then
		if target.shield == SHIELD_PSI then
			table.insert(player.bother.battle.actions[1].subactions, {textEvent = getTextEvent("action", "psyshielddis"),
				user = user, target = target, arg = player.bother.battle.actions[1].subactions[1].arg})
			table.insert(player.bother.battle.actions[1].subactions, {func = shieldDeplete, user = user, target = target, arg = 1})
			return
		elseif target.shield == SHIELD_POWERPSI then
			table.insert(player.bother.battle.actions[1].subactions, {textEvent = getTextEvent("action", "psyshielddef"),
				user = user, target = target, arg = player.bother.battle.actions[1].subactions[1].arg})
			target = user
		end
		table.insert(player.bother.battle.actions[1].subactions, {func = shieldDeplete, user = user, target = target, arg = 1})
	end
	
	local damage = P_RandomRange(minDamage, maxDamage)
	local vulnerability
	if target.skin then
		vulnerability = 0
	else
		vulnerability = getEnemy(target.type).fireResist
	end
	vulnerability = vulnFromNumOffense(vulnerability)
	damage = FixedMul(damage, vulnerability)
	doDamage(player, user, target, damage)
end

local function pkFireA(player, user, target)
	local preAction = {textEvent = getTextEvent("psi", "fireA"), user = user, target = target}
	doAction(player, user, target, preAction, firePerform, 60, 100)
end

local function pkFireB(player, user, target)
	local preAction = {textEvent = getTextEvent("psi", "fireB"), user = user, target = target}
	doAction(player, user, target, preAction, firePerform, 120, 200)
end

local function freezeSolidify(player, user, target)
	if not deadCheck(player, target, true)
		solidify(player, user, target, true)
	end
end

local function freezePerform(player, user, target, ...)
	local minDamage, maxDamage = ...
	local damage = P_RandomRange(minDamage, maxDamage)
	local vulnerability
	
	if target.shield == SHIELD_PSI or target.shield == SHIELD_POWERPSI then
		if target.shield == SHIELD_PSI then
			table.insert(player.bother.battle.actions[1].subactions, {textEvent = getTextEvent("action", "psyshielddis"),
				user = user, target = target, arg = player.bother.battle.actions[1].subactions[1].arg})
			table.insert(player.bother.battle.actions[1].subactions, {func = shieldDeplete, user = user, target = target, arg = 1})
			return
		elseif target.shield == SHIELD_POWERPSI then
			table.insert(player.bother.battle.actions[1].subactions, {textEvent = getTextEvent("action", "psyshielddef"),
				user = user, target = target, arg = player.bother.battle.actions[1].subactions[1].arg})
			target = user
		end
		table.insert(player.bother.battle.actions[1].subactions, {func = shieldDeplete, target = target, arg = 1})
	end
	
	if target.skin then
		vulnerability = 0
	else
		vulnerability = getEnemy(target.type).freezeResist
	end
	vulnerability = vulnFromNumOffense(vulnerability)
	damage = FixedMul(damage*FRACUNIT, vulnerability)/FRACUNIT
	doDamage(player, user, target, damage)
	if P_RandomChance(FRACUNIT/4) then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target, func = freezeSolidify})
	end
end

local function pkFreezeA(player, user, target)
	local preAction = {textEvent = getTextEvent("psi", "freezeA"), user = user, target = target}
	doAction(player, user, target, preAction, freezePerform, 135, 255)
end

local function pkFreezeB(player, user, target)
	local preAction = {textEvent = getTextEvent("psi", "freezeB"), user = user, target = target}
	doAction(player, user, target, preAction, freezePerform, 270, 450)
end

local function thunderHit(player, user, target)
	local damage = player.bother.battle.actions[1].subactions[1].number
	if target == "enemythunder" then
		target = randomEnemy(player.bother.battle.enemies)
	elseif target == "partythunder" then
		target = randomParty(player.bother.party)
	end
	
	if not target then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, textEvent = getTextEvent("action", "didnthit")})
		return
	end
	
	-- EW
	local textEvent = player.bother.battle.actions[1].subactions[1].textEvent
	player.bother.battle.actions[1].subactions[1].textEvent = nil
	
	table.insert(player.bother.battle.actions[1].subactions, 2, {textEvent = textEvent, user = user, target = target})
	
	if target.skin ~= nil then -- It's a party member
		if target.damage + damage*FRACUNIT >= target.currentStats.hp then
			table.insert(player.bother.battle.actions[1].subactions, 3, {user = user, target = target,
			number = damage, textEvent = getTextEvent("action", "mortaldamage"), func = target.takeDamage})
		else
			table.insert(player.bother.battle.actions[1].subactions, 3, {user = user, target = target,
			number = damage, textEvent = getTextEvent("action", "allydamage"), func = target.takeDamage})
		end
	else
		table.insert(player.bother.battle.actions[1].subactions, 3, {user = user, target = target,
		number = damage, textEvent = getTextEvent("action", "enemydamage"), func = target.takeDamage})
	end
	
	if target.shield == SHIELD_PSI or target.shield == SHIELD_POWERPSI then
		table.insert(player.bother.battle.actions[1].subactions, {func = shieldDeplete, target = target, arg = 3})
	end
end

local function thunderPerform(player, user, target, ...)
	local minDamage, maxDamage, strikes, textEvent = ...
	local damage
	local hitChance
	
	if target == "enemythunder" then
		hitChance = FixedDiv(numEnemies(player.bother.battle.enemies)*FRACUNIT, 4*FRACUNIT)
	elseif target == "partythunder" then
		hitChance = FixedDiv(#player.bother.party*FRACUNIT, 4*FRACUNIT)
	end
	for i=1,strikes,1 do
		if P_RandomChance(hitChance) then
			damage = P_RandomRange(minDamage, maxDamage)
			table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
				number = damage, func = thunderHit, textEvent = textEvent})
		else
			table.insert(player.bother.battle.actions[1].subactions, {user = user, textEvent = getTextEvent("action", "didnthit")})
		end
	end
end

-- PK Thunder is a tricksy one, it doesn't effect all, it selects a random target
local function pkThunderA(player, user, target)
	if target == "enemies" then
		target = "enemythunder"
	elseif target == "party" then
		target = "partythunder"
	end
	-- need to actually change this too
	player.bother.battle.actions[1].subactions[1].target = target
	doAction(player, user, target, nil, thunderPerform, 60, 180, 1, getTextEvent("psi", "thunderA"))
end

local function pkThunderB(player, user, target)
	if target == "enemies" then
		target = "enemythunder"
	elseif target == "party" then
		target = "partythunder"
	end
	player.bother.battle.actions[1].subactions[1].target = target
	doAction(player, user, target, nil, thunderPerform, 60, 180, 2, getTextEvent("psi", "thunderA"))
end

local function flashPerform(player, user, target, ...)
	local resistance
	if target.skin then
		resistance = 0
	else
		resistance = getEnemy(target.type).flashResist
	end
	resistance = resistFromNumAssist(resistance)
	
	if P_RandomFixed() < resistance then
		-- did not work
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("action", "didnotwork")})
		return
	end
	
	local cryingProb, strangeProb, paralysisProb, deathProb = ...
	local totalProb = cryingProb + strangeProb + paralysisProb + deathProb
	local r = P_RandomRange(1, totalProb)
	if cryingProb > 0 and r <= cryingProb then
		crying(player, user, target, false)
	elseif strangeProb > 0 and r <= cryingProb + strangeProb then
		feelingStrange(player, user, target, false)
	elseif paralysisProb > 0 and r <= cryingProb + strangeProb + paralysisProb then
		paralysis(player, user, target, false)
	elseif deathProb > 0 and r <= cryingProb + strangeProb + paralysisProb then
		-- TODO
	end
end

local function pkFlashA(player, user, target)
	local preAction = {textEvent = getTextEvent("psi", "flashA"), user = user, target = target}
	doAction(player, user, target, preAction, flashPerform, 7, 1, 0, 0)
end

local function lifeupPerform(player, user, target, ...)
	local minHeal, maxHeal = ...
	local heal
	heal = P_RandomRange(minHeal, maxHeal)
	if (target.skin and target.currentStats.hp - target.damage + heal*FRACUNIT >= target.stats.hp*FRACUNIT)
	or (not target.skin and target.currentStats.hp + heal > getEnemy(target.type).stats.hp) then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			number = -heal, textEvent = getTextEvent("action", "maxedout"), func = target.takeDamage})
	else
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			number = -heal, textEvent = getTextEvent("action", "heal"), func = target.takeDamage})
	end
end

local function lifeupA(player, user, target)
	doAction(player, user, target, nil, lifeupPerform, 75, 125)
end

local function lifeupB(player, user, target)
	doAction(player, user, target, nil, lifeupPerform, 225, 375)
end



local function healingAPerform(player, user, target, ...)
	local nested = ...
	local effective = false
	
	if target.status[1] == bConst.STATUS1_COLD then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("status", "coldcured")})
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			func = coldRecover})
		effective = true
	elseif target.status[1] == bConst.STATUS1_SUNSTROKE then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("status", "sunstrokecure")})
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			func = sunstrokeRecover})
		effective = true
	end
	
	if target.status[3] == bConst.STATUS3_SLEEP then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("status", "wokeup")})
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			func = sleepRecover})
		effective = true
	end
	
	if not nested and not effective then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("action", "noviseffect")})
	end
	
	return effective
end

local function healingBPerform(player, user, target, ...)
	local nested = ...
	local effective = healingAPerform(player, user, target, true)
	
	if target.status[1] == bConst.STATUS1_POISON then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("status", "poisoncured")})
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			func = poisonRecover})
		effective = true
	elseif target.status[1] == bConst.STATUS1_NAUSEA then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("status", "nauseacured")})
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			func = nauseaRecover})
		effective = true
	end
	
	if target.status[3] == bConst.STATUS3_CRYING then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("status", "stopcrying")})
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			func = cryingRecover})
		effective = true
	end
	
	if target.feelStrange then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("status", "backtonormal")})
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			func = feelingStrangeRecover})
		effective = true
	end
	
	if not nested and not effective then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("action", "noviseffect")})
	end
	
	return effective
end

local function healingA(player, user, target)
	doAction(player, user, target, nil, healingAPerform, false)
end

local function healingB(player, user, target)
	doAction(player, user, target, nil, healingBPerform, false)
end

local function shield(player, user, target)
	target.shield = SHIELD_PHYSICAL
	target.shieldDuration = 3
end

local function powerShield(player, user, target)
	target.shield = SHIELD_POWERPHYSICAL
	target.shieldDuration = 3
end

local function psiShield(player, user, target)
	target.shield = SHIELD_PSI
	target.shieldDuration = 3
end

local function psiPowerShield(player, user, target)
	target.shield = SHIELD_POWERPSI
	target.shieldDuration = 3
end

local function shieldPerform(player, user, target, shieldType)
	if shieldType == SHIELD_PHYSICAL then
		if target.shield == shieldType then
			table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
				textEvent = getTextEvent("action", "shieldstr"), func = shield})
		else
			table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
				textEvent = getTextEvent("action", "shield"), func = shield})
		end
	elseif shieldType == SHIELD_POWERPHYSICAL
		if target.shield == shieldType then
			table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
				textEvent = getTextEvent("action", "pshieldstr"), func = powerShield})
		else
			table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
				textEvent = getTextEvent("action", "pshield"), func = powerShield})
		end
	elseif shieldType == SHIELD_PSI then
		if target.shield == shieldType then
			table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
				textEvent = getTextEvent("action", "psyshieldstr"), func = psiShield})
		else
			table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
				textEvent = getTextEvent("action", "psyshield"), func = psiShield})
		end
	elseif shieldType == SHIELD_POWERPSI then
		if target.shield == shieldType then
			table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
				textEvent = getTextEvent("action", "ppsyshieldstr"), func = psiPowerShield})
		else
			table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
				textEvent = getTextEvent("action", "ppsyshield"), func = psiPowerShield})
		end
	end
end

local function shieldA(player, user, target)
	local preAction = {textEvent = getTextEvent("psi", "shieldA"), user = user, target = target}
	doAction(player, user, target, preAction, shieldPerform, SHIELD_PHYSICAL)
end

local function shieldB(player, user, target)
	local preAction = {textEvent = getTextEvent("psi", "shieldB"), user = user, target = target}
	doAction(player, user, target, preAction, shieldPerform, SHIELD_POWERPHYSICAL)
end

local function psiShieldA(player, user, target)
	local preAction = {textEvent = getTextEvent("psi", "psishieldA"), user = user, target = target}
	doAction(player, user, target, preAction, shieldPerform, SHIELD_PSI)
end

local function defDownPerform(player, user, target)
	target.currentStats.defense = target.currentStats.defense - player.bother.battle.actions[1].subactions[1].number
end

local function defDown(player, user, target)
	local probability = FixedDiv(target.currentStats.luck*FRACUNIT, 80*FRACUNIT)
	if P_RandomChance(probability) then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("action", "didnotwork")})
	else
		local defenseLower = max(target.currentStats.defense / 16, 1)
		local baseDefense
		local lowestDef
		
		if target.skin then
			baseDefense = target.stats.defense
		else
			baseDefense = getEnemy(target.type).stats.defense
		end
		lowestDef = FixedRealRound(FixedMul(FixedDiv(baseDefense*FRACUNIT, 4*FRACUNIT), 3*FRACUNIT)) / FRACUNIT
		if target.currentStats.defense - defenseLower < lowestDef then
			defenseLower = target.currentStats.defense - lowestDef
		end
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("action", "defdown"), func = defDownPerform, number = defenseLower})
	end
end

local function defenseDownA(player, user, target)
	local preAction = {textEvent = getTextEvent("psi", "defdownA"), user = user, target = target}
	doAction(player, user, target, preAction, defDown)
end

local function hypnosisPerform(player, user, target)
	local resistance
	if target.skin then
		resistance = 0
	else
		resistance = getEnemy(target.type).hypnosisResist
	end
	resistance = resistFromNumAssist(resistance)
	
	if P_RandomFixed() < resistance then
		-- did not work
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("action", "didnotwork")})
		return
	end
	
	sleep(player, user, target, false)
end

local function hypnosisA(player, user, target)
	local preAction = {textEvent = getTextEvent("psi", "hypnosisA"), user = user, target = target}
	doAction(player, user, target, preAction, hypnosisPerform)
end

local function hypnosisO(player, user, target)
	local preAction = {textEvent = getTextEvent("psi", "hypnosisO"), user = user, target = target}
	doAction(player, user, target, preAction, hypnosisPerform)
end

local function randomTriangleDist(minNum, maxNum, median)
	local U = P_RandomFixed()
	local F = FixedDiv(median - minNum, maxNum - minNum)
	if U <= F then
		return minNum + FixedSqrt(FixedMul(FixedMul(U, maxNum - minNum), median - minNum))
	else
		return maxNum - FixedSqrt(FixedMul(FixedMul(FRACUNIT-U, maxNum - minNum), maxNum - median))
	end
end

local function magnetPerform(player, user, target)
	local drainPP = player.bother.battle.actions[1].subactions[1].number
	if target.skin then
		target.ppUsed = target.ppUsed + drainPP*FRACUNIT
	else
		target.currentStats.pp = target.currentStats.pp - drainPP
	end
	
	if user.skin then
		user.ppUsed = user.ppUsed - drainPP*FRACUNIT
		if user.currentStats.pp - user.ppUsed > user.stats.pp*FRACUNIT then
			user.ppUsed = user.currentStats.pp - user.stats.pp*FRACUNIT
		end
	else
		user.currentStats.pp = user.currentStats.pp + drainPP
		if user.currentStats.pp > getEnemy(user.type).stats.pp then
			user.currentStats.pp = getEnemy(user.type).stats.pp
		end
	end
end

local function magnet(player, user, target, ...)
	local minPP, maxPP = ...
	local drainPP = FixedRealRound(randomTriangleDist(minPP*FRACUNIT, maxPP*FRACUNIT, minPP*FRACUNIT))/FRACUNIT
	-- most likely to be 2PP, least likely to be 8PP
	if target.skin then
		if drainPP*FRACUNIT > target.currentStats.pp - target.ppUsed then
			drainPP = (target.currentStats.pp - target.ppUsed)/FRACUNIT
		end
	else
		if drainPP > target.currentStats.pp then
			drainPP = target.currentStats.pp
		end
	end
	table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
		textEvent = getTextEvent("action", "ppdrain"), func = magnetPerform, number = drainPP})
end

local function magnetA(player, user, target)
	local preAction = {textEvent = getTextEvent("psi", "magnetA"), user = user, target = target}
	doAction(player, user, target, preAction, magnet, 2, 8)
end

local function magnetO(player, user, target)
	local preAction = {textEvent = getTextEvent("psi", "magnetO"), user = user, target = target}
	doAction(player, user, target, preAction, magnet, 2, 8)
end

local function paralysisPerform(player, user, target)
	local resistance
	if target.skin then
		resistance = 0
	else
		resistance = getEnemy(target.type).paralysisResist
	end
	resistance = resistFromNumAssist(resistance)
	
	if P_RandomFixed() < resistance then
		-- did not work
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("action", "didnotwork")})
		return
	end
	
	paralysis(player, user, target, false)
end

local function paralysisA(player, user, target)
	local preAction = {textEvent = getTextEvent("psi", "paralysisA"), user = user, target = target}
	doAction(player, user, target, preAction, paralysisPerform)
end

local function paralysisO(player, user, target)
	local preAction = {textEvent = getTextEvent("psi", "paralysisO"), user = user, target = target}
	doAction(player, user, target, preAction, paralysisPerform)
end

local function brainshockPerform(player, user, target)
	local resistance
	if target.skin then
		resistance = 0
	else
		resistance = 3 - getEnemy(target.type).hypnosisResist
	end
	resistance = resistFromNumAssist(resistance)
	
	if P_RandomFixed() < resistance then
		-- did not work
		table.insert(player.bother.battle.actions[1].subactions, {user = user, target = target,
			textEvent = getTextEvent("action", "didnotwork")})
		return
	end
	
	feelingStrange(player, user, target, false)
end

local function brainshockA(player, user, target)
	local preAction = {textEvent = getTextEvent("psi", "brainshockA"), user = user, target = target}
	doAction(player, user, target, preAction, brainshockPerform)
end

local function helpCall(player, user, target)
	local enemyNum = player.bother.battle.actions[1].subactions[1].arg
	local enemy = getEnemy(enemyNum)
	local checkEnemy
	local xPos = 0
	local suffix = ""
	local lastChar = 0
	for x=1,7,1 do
		if not player.bother.battle.enemies[enemy.row][x] and not xPos then
			-- this is where the enemy will be placed for simplicity
			-- only if the row isn't already full
			xPos = x
		elseif player.bother.battle.enemies[enemy.row][x] then
			checkEnemy = player.bother.battle.enemies[enemy.row][x]
			if checkEnemy.type == enemyNum then
				-- find out what suffix it has, if any, and give us that +1
				-- Loopback at G, because max 7 per row
				if (enemy.theFlag and checkEnemy.name == "The " .. enemy.name
				or not enemy.theFlag and checkEnemy.name == enemy.name) then
					local thisChar = 65
					if thisChar > lastChar then
						lastChar = 65
					end
				else
					local thisChar = string.sub(checkEnemy.name, -1)
					thisChar = string.byte(thisChar)
					if thisChar > lastChar then
						lastChar = thisChar
					end
				end
			end
		end
	end
	
	if not xPos then -- quick check for dead enemies if we still don't have xPos
		for x=1,7,1 do
			if player.bother.battle.enemies[enemy.row][x].status[1] == bConst.STATUS1_FAINTED then
				xPos = x
				break
			end
		end
	end
	
	if xPos then
		if lastChar then
			if lastChar + 1 > 71 then
				lastChar = 64
			end
			suffix = " " .. string.char(lastChar+1)
		end
		local newEnemy
		player.bother.battle.enemies[enemy.row][xPos] = {}
		newEnemy = player.bother.battle.enemies[enemy.row][xPos]
		newEnemy.type = enemyNum
		if suffix ~= "" then
			newEnemy.name = enemy.name .. suffix
		elseif enemy.theFlag then
			newEnemy.name = "The " .. enemy.name
		else
			newEnemy.name = enemy.name
		end
		
		for i=1,7,1 do
			if player.bother.battle.enemies[enemy.row][i] then
				if player.bother.battle.enemies[enemy.row][i].name == enemy.name
				or player.bother.battle.enemies[enemy.row][i].name == "The " .. enemy.name then
					player.bother.battle.enemies[enemy.row][i].name = enemy.name .. " A"
				end
			end
		end
		newEnemy.currentStats = {} -- copy all of the stats from the enemy definition
		for k,v in pairs(enemy.stats) do
			newEnemy.currentStats[k] = v
		end
		newEnemy.status = {0, 0, 0}
		newEnemy.takeDamage = enemyTakeDamage
		table.insert(player.bother.battle.actions[1].subactions, {user = user, textEvent = getTextEvent("action", "joinedbattle"),
			target = newEnemy})
	else
		table.insert(player.bother.battle.actions[1].subactions, {user = user, textEvent = getTextEvent("action", "noonecame")})
	end
end

local function helpCallPerform(player, user, target)
	local enemyNum = player.bother.battle.actions[1].subactions[1].arg
	local probability = FixedDiv(4*FRACUNIT, 5*FRACUNIT)
	if not P_RandomChance(probability) then
		table.insert(player.bother.battle.actions[1].subactions, {user = user, textEvent = getTextEvent("action", "noonecame")})
	else
		table.insert(player.bother.battle.actions[1].subactions, {user = user, func = helpCall, arg = enemyNum})
		--helpCall(player, user, enemyNum)
	end
end

local function helpCallAction(player, user, target)
	doAction(player, user, target, nil, helpCallPerform)
end

local function changeUserEnemyType(player, user, target)
	local newType = player.bother.battle.actions[1].subactions[1].arg
	user.type = newType
end

local function changeUserEnemyTypePerform(player, user, ...)
	local newType = ...
	if user.skin then
		print("changeUserEnemyTypePerform(): Attempt to change a party member enemy type")
		return
	end
	table.insert(player.bother.battle.actions[1].subactions, {user = user, func = changeUserEnemyType, arg = newType})
end

local function changeUserEnemyTypeAction(player, user, target)
	doAction(player, user, target, nil, changeUserEnemyTypePerform, player.bother.battle.actions[1].subactions[1].arg)
end

local function blonicBounce(player, user, target, ...)
	if bash(player, user, target, ...) then
		immobilize(player, user, target, true)
	end
	changeUserEnemyTypePerform(player, user, player.bother.battle.actions[1].subactions[1].arg)
end

local function blonicBounceAction(player, user, target)
	doAction(player, user, target, nil, blonicBounce, 4)
end

local function spdUpPerform(player, user, target)
	target.currentStats.speed = target.currentStats.speed + player.bother.battle.actions[1].subactions[1].number
end

local function offUpPerform(player, user, target)
	target.currentStats.offense = target.currentStats.offense + player.bother.battle.actions[1].subactions[1].number
end

local function lastResort(player, user, target)
	local speedUp = target.currentStats.speed*FRACUNIT / 8
	local offenseUp = target.currentStats.offense*FRACUNIT / 8
	speedUp = FixedRealRound(speedUp)/FRACUNIT
	offenseUp = FixedRealRound(offenseUp)/FRACUNIT
	table.insert(player.bother.battle.actions[1].subactions, 2, {user = user, target = target,
		textEvent = getTextEvent("action", "spdup"), func = spdUpPerform, number = speedUp})
	table.insert(player.bother.battle.actions[1].subactions, 3, {user = user, target = target,
		textEvent = getTextEvent("action", "offup"), func = offUpPerform, number = offenseUp})
end

local function lastResortAction(player, user, target)
	doAction(player, user, target, nil, lastResort)
end

local function nothingAction(player, user, target)
	doAction(player, user, target, nil, nil)
end

local actions = {}

-- Bash
-- (this one is an enemy one for a different textEvent
actions[3] = {
	type = ACTIONTYPE_PHYSICAL1,
	func = bashAction,
	direction = bConst.ACTIONDIR_ENEMY,
	pp = 0,
	target = bConst.ACTIONTARGET_ONE,
	textEvent = getTextEvent("action", "abash")
}

actions[4] = {
	type = ACTIONTYPE_PHYSICAL1,
	func = bashAction,
	direction = bConst.ACTIONDIR_ENEMY,
	pp = 0,
	target = bConst.ACTIONTARGET_ONE,
	textEvent = getTextEvent("action", "bash")
}

-- Defend
actions[8] = {
	type = ACTIONTYPE_OTHER,
	func = defendAction,
	direction = bConst.ACTIONDIR_PARTY,
	pp = 0,
	target = bConst.ACTIONTARGET_NONE,
	textEvent = getTextEvent("action", "adefend")
}

-- PK Speed
actions[10] = {
	type = ACTIONTYPE_PSI,
	func = pkSpeedA,
	direction = bConst.ACTIONDIR_ENEMY,
	pp = 10,
	target = bConst.ACTIONTARGET_ALL,
	textEvent = getTextEvent("action", "PSI2"),
}

actions[11] = {
	type = ACTIONTYPE_PSI,
	func = pkSpeedB,
	direction = bConst.ACTIONDIR_ENEMY,
	pp = 14,
	target = bConst.ACTIONTARGET_ALL,
	textEvent = getTextEvent("action", "PSI2")
}

-- PK Fire
actions[14] = {
	type = ACTIONTYPE_PSI,
	func = pkFireA,
	direction = bConst.ACTIONDIR_ENEMY,
	pp = 6,
	target = bConst.ACTIONTARGET_ROW,
	textEvent = getTextEvent("action", "PSI2")
}

actions[15] = {
	type = ACTIONTYPE_PSI,
	func = pkFireB,
	direction = bConst.ACTIONDIR_ENEMY,
	pp = 12,
	target = bConst.ACTIONTARGET_ROW,
	textEvent = getTextEvent("action", "PSI2")
}

-- PK Freeze
actions[18] = {
	type = ACTIONTYPE_PSI,
	func = pkFreezeA,
	direction = bConst.ACTIONDIR_ENEMY,
	pp = 4,
	target = bConst.ACTIONTARGET_ONE,
	textEvent = getTextEvent("action", "PSI2")
}

actions[19] = {
	type = ACTIONTYPE_PSI,
	func = pkFreezeB,
	direction = bConst.ACTIONDIR_ENEMY,
	pp = 9,
	target = bConst.ACTIONTARGET_ONE,
	textEvent = getTextEvent("action", "PSI2")
}

-- PK Thunder
actions[22] = {
	type = ACTIONTYPE_PSI,
	func = pkThunderA,
	direction = bConst.ACTIONDIR_ENEMY,
	pp = 3,
	target = bConst.ACTIONTARGET_ALL,
	textEvent = getTextEvent("action", "PSI2")
}

actions[23] = {
	type = ACTIONTYPE_PSI,
	func = pkThunderB,
	direction = bConst.ACTIONDIR_ENEMY,
	pp = 7,
	target = bConst.ACTIONTARGET_ALL,
	textEvent = getTextEvent("action", "PSI2")
}

-- PK Flash
actions[26] = {
	type = ACTIONTYPE_PSI,
	func = pkFlashA,
	direction = bConst.ACTIONDIR_ENEMY,
	pp = 8,
	target = bConst.ACTIONTARGET_ALL,
	textEvent = getTextEvent("action", "PSI2")
}

-- Lifeup
actions[32] = {
	type = ACTIONTYPE_PSI,
	func = lifeupA,
	direction = bConst.ACTIONDIR_PARTY,
	pp = 5,
	target = bConst.ACTIONTARGET_ONE,
	textEvent = getTextEvent("action", "PSI2")
}

actions[33] = {
	type = ACTIONTYPE_PSI,
	func = lifeupB,
	direction = bConst.ACTIONDIR_PARTY,
	pp = 8,
	target = bConst.ACTIONTARGET_ONE,
	textEvent = getTextEvent("action", "PSI2")
}

-- Healing
actions[36] = {
	type = ACTIONTYPE_PSI,
	func = healingA,
	direction = bConst.ACTIONDIR_PARTY,
	pp = 5,
	target = bConst.ACTIONTARGET_ONE,
	textEvent = getTextEvent("action", "PSI2")
}

actions[37] = {
	type = ACTIONTYPE_PSI,
	func = healingB,
	direction = bConst.ACTIONDIR_PARTY,
	pp = 8,
	target = bConst.ACTIONTARGET_ONE,
	textEvent = getTextEvent("action", "PSI2")
}

-- Shield
actions[40] = {
	type = ACTIONTYPE_PSI,
	func = shieldA,
	direction = bConst.ACTIONDIR_PARTY,
	pp = 6,
	target = bConst.ACTIONTARGET_ONE,
	textEvent = getTextEvent("action", "PSI2")
}

actions[41] = {
	type = ACTIONTYPE_PSI,
	func = shieldB,
	direction = bConst.ACTIONDIR_PARTY,
	pp = 14,
	target = bConst.ACTIONTARGET_ONE,
	textEvent = getTextEvent("action", "PSI2")
}

actions[42] = {
	type = ACTIONTYPE_PSI,
	func = shieldA,
	direction = bConst.ACTIONDIR_PARTY,
	pp = 18,
	target = bConst.ACTIONTARGET_ALL,
	textEvent = getTextEvent("action", "PSI2")
}

-- PSI Shield
actions[44] = {
	type = ACTIONTYPE_PSI,
	func = psiShieldA,
	direction = bConst.ACTIONDIR_PARTY,
	pp = 8,
	target = bConst.ACTIONTARGET_ONE,
	textEvent = getTextEvent("action", "PSI2")
}

actions[46] = {
	type = ACTIONTYPE_PSI,
	func = psiShieldA,
	direction = bConst.ACTIONDIR_PARTY,
	pp = 24,
	target = bConst.ACTIONTARGET_ALL,
	textEvent = getTextEvent("action", "PSI2")
}

-- Defense down
actions[50] = {
	type = ACTIONTYPE_PSI,
	func = defenseDownA,
	direction = bConst.ACTIONDIR_ENEMY,
	pp = 6,
	target = bConst.ACTIONTARGET_ONE,
	textEvent = getTextEvent("action", "PSI2")
}

-- Hypnosis
actions[52] = {
	type = ACTIONTYPE_PSI,
	func = hypnosisA,
	direction = bConst.ACTIONDIR_ENEMY,
	pp = 6,
	target = bConst.ACTIONTARGET_ONE,
	textEvent = getTextEvent("action", "PSI2")
}

actions[53] = {
	type = ACTIONTYPE_PSI,
	func = hypnosisO,
	direction = bConst.ACTIONDIR_ENEMY,
	pp = 18,
	target = bConst.ACTIONTARGET_ALL,
	textEvent = getTextEvent("action", "PSI2")
}

-- PSI Magnet
actions[54] = {
	type = ACTIONTYPE_PSI,
	func = magnetA,
	direction = bConst.ACTIONDIR_ENEMY,
	pp = 0,
	target = bConst.ACTIONTARGET_ONE,
	textEvent = getTextEvent("action", "PSI2")
}

actions[55] = {
	type = ACTIONTYPE_PSI,
	func = magnetO,
	direction = bConst.ACTIONDIR_ENEMY,
	pp = 0,
	target = bConst.ACTIONTARGET_ALL,
	textEvent = getTextEvent("action", "PSI2")
}

-- Paralysis
actions[56] = {
	type = ACTIONTYPE_PSI,
	func = paralysisA,
	direction = bConst.ACTIONDIR_ENEMY,
	pp = 8,
	target = bConst.ACTIONTARGET_ONE,
	textEvent = getTextEvent("action", "PSI2")
}

actions[57] = {
	type = ACTIONTYPE_PSI,
	func = paralysisO,
	direction = bConst.ACTIONDIR_ENEMY,
	pp = 24,
	target = bConst.ACTIONTARGET_ALL,
	textEvent = getTextEvent("action", "PSI2")
}

-- Brainshock
actions[58] = {
	type = ACTIONTYPE_PSI,
	func = brainshockA,
	direction = bConst.ACTIONDIR_ENEMY,
	pp = 10,
	target = bConst.ACTIONTARGET_ONE,
	textEvent = getTextEvent("action", "PSI2")
}

-- Enemy Attacks
actions[62] = {
	type = ACTIONTYPE_OTHER,
	func = helpCallAction,
	direction = bConst.ACTIONDIR_PARTY,
	pp = 0,
	target = bConst.ACTIONTARGET_NONE,
	textEvent = getTextEvent("action", "helpcall")
}

actions[118] = {
	type = ACTIONTYPE_OTHER,
	func = lastResortAction,
	direction = bConst.ACTIONDIR_PARTY,
	pp = 0,
	target = bConst.ACTIONTARGET_ALL,
	textEvent = getTextEvent("action", "reassure")
}

actions[119] = {
	type = ACTIONTYPE_OTHER,
	func = lastResortAction,
	direction = bConst.ACTIONDIR_PARTY,
	pp = 0,
	target = bConst.ACTIONTARGET_ALL,
	textEvent = getTextEvent("action", "cashgrab")
}

actions[120] = {
	type = ACTIONTYPE_PHYSICAL1,
	func = bashAction,
	direction = bConst.ACTIONDIR_ENEMY,
	pp = 0,
	target = bConst.ACTIONTARGET_ONE,
	textEvent = getTextEvent("action", "crawled")
}

actions[121] = {
	type = ACTIONTYPE_OTHER,
	func = cryingAction,
	direction = bConst.ACTIONDIR_ENEMY,
	pp = 0,
	target = bConst.ACTIONTARGET_ONE,
	textEvent = getTextEvent("action", "anime")
}

actions[123] = {
	type = ACTIONTYPE_OTHER,
	func = nothingAction,
	direction = bConst.ACTIONDIR_PARTY,
	pp = 0,
	target = bConst.ACTIONTARGET_NONE,
	textEvent = getTextEvent("action", "stairfail")
}

actions[124] = {
	type = ACTIONTYPE_OTHER,
	func = pkFireA,
	direction = bConst.ACTIONDIR_ENEMY,
	pp = 0,
	target = bConst.ACTIONTARGET_ROW,
	textEvent = getTextEvent("action", "nosefire")
}

actions[125] = {
	type = ACTIONTYPE_OTHER,
	func = magnetA,
	direction = bConst.ACTIONDIR_ENEMY,
	pp = 0,
	target = bConst.ACTIONTARGET_ONE,
	textEvent = getTextEvent("action", "succ")
}

actions[127] = {
	type = ACTIONTYPE_OTHER,
	func = nothingAction,
	direction = bConst.ACTIONDIR_PARTY,
	pp = 0,
	target = bConst.ACTIONTARGET_NONE,
	textEvent = getTextEvent("action", "sharpturn")
}

actions[128] = {
	type = ACTIONTYPE_OTHER,
	func = changeUserEnemyTypeAction,
	direction = bConst.ACTIONDIR_PARTY,
	pp = 0,
	target = bConst.ACTIONTARGET_NONE,
	textEvent = getTextEvent("action", "preparing")
}

actions[132] = {
	type = ACTIONTYPE_PHYSICAL1,
	func = blonicBounceAction,
	direction = bConst.ACTIONDIR_ENEMY,
	pp = 0,
	target = bConst.ACTIONTARGET_ONE,
	textEvent = getTextEvent("action", "blonicbounce")
}

local function getAction(actionNum)
	if not actions[actionNum] then
		print("getAction(): Invalid Action number")
		return nil
	end
	return actions[actionNum]
end

-- Initiates the latest action
local function activateAction(player)
	local bother = player.bother
	
	if not bother.battle.actions or not bother.battle.actions[1] then
		return
	end
	
	local action = bother.battle.actions[1]
	
	if action.subactions[1].func then
		action.subactions[1].func(player, action.subactions[1].user, action.subactions[1].target)
		if not action.subactions[1].textEvent then
			-- This is JUST a function, so remove the subaction immediately after running it
			table.remove(action.subactions, 1)
			if bother.battle.actions and bother.battle.actions[1] and #action.subactions < 1 then
				table.remove(bother.battle.actions, 1)
				bother.textBox.curText = ""
			end
			-- activate the next action or subaction to begin
			activateAction(player)
			return
		end
	end
	if action.subactions[1].textEvent then
		bother.textBox.textEvent = {}
		playerGenerateText(player, action.subactions[1].textEvent)
		bother.textBox.textEventPos = 0
		bother.textBox.active = true
	end
end

local function enemyActions(bother)
	local action
	local arg
	local aliveNum = 0
	local target
	
	-- I've used pairs because it ends up semi-random when there are speed ties
	for rowk,rowv in pairs(bother.battle.enemies) do
		for enemyk,enemy in pairs(rowv) do
			if enemy.currentStats.hp > 0 then
				action = P_RandomKey(#getEnemy(enemy.type).actions) + 1
				arg = getEnemy(enemy.type).actions[action].arg
				action = getAction(getEnemy(enemy.type).actions[action].action)
				
				if action.direction == bConst.ACTIONDIR_ENEMY then
					if action.target == bConst.ACTIONTARGET_ROW or action.target == bConst.ACTIONTARGET_ALL then
						target = "party"
					elseif action.target == bConst.ACTIONTARGET_ONE then
						target = randomParty(bother.party)
					else
						target = nil
					end
				else
					if action.target == bConst.ACTIONTARGET_ALL then
						target = "enemies"
					elseif action.target == bConst.ACTIONTARGET_ROW then
						target = P_RandomRange(1, #bother.battle.enemies)
					elseif action.target == bConst.ACTIONTARGET_ONE then
						target = randomEnemy(bother.battle.enemies)
					else
						target = nil
					end
				end
				
				table.insert(bother.battle.actions, {action = action,
					subactions = {{user = bother.battle.enemies[rowk][enemyk],
					target = target, func = action.func, arg=arg}}})
			end
		end
	end
end

rawset(_G, "getAction", getAction)
rawset(_G, "activateAction", activateAction)
rawset(_G, "enemyActions", enemyActions)
