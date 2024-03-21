local JUMPPRESS = 1
local SPINPRESS = 2
local UPPRESS = 4
local DOWNPRESS = 8
local LEFTPRESS = 16
local RIGHTPRESS = 32

local function backHandler(player, menu)
	menu.active = false
	if menu.submenu then
		menu.submenu.active = false
		menu.submenu.visible = false
	end
end

local function addBattleAction(battle, user, target, action, arg)
	-- actions has a table of subactions that determine what is done
	table.insert(battle.actions, {action = action, subactions = {{user = user, target = target, func = action.func, arg = arg}}})
end

local function selectEnemyAll(player, menu)
	addBattleAction(player.bother.battle, player.bother.party[menu.owner], "enemies",
		getAction(menu.items[menu.hoverY][menu.hoverX].action), menu.items[menu.hoverY][menu.hoverX].arg)
	
	setupBattleMenu(player, menu.owner+1)
end

local function selectEnemyRow(player, menu)
	addBattleAction(player.bother.battle, player.bother.party[menu.owner], menu.hoverY,
		getAction(menu.items[menu.hoverY][menu.hoverX].action), menu.items[menu.hoverY][menu.hoverX].arg)
	
	setupBattleMenu(player, menu.owner+1)
end

local function selectEnemyOne(player, menu)
	addBattleAction(player.bother.battle, player.bother.party[menu.owner], player.bother.battle.enemies[menu.hoverY][menu.hoverX],
		getAction(menu.items[menu.hoverY][menu.hoverX].action), menu.items[menu.hoverY][menu.hoverX].arg)
	
	setupBattleMenu(player, menu.owner+1)
end

local function selectAllyAll(player, menu)
	addBattleAction(player.bother.battle, player.bother.party[menu.owner], "party",
		getAction(menu.items[menu.hoverY][menu.hoverX].action), menu.items[menu.hoverY][menu.hoverX].arg)
	
	setupBattleMenu(player, menu.owner+1)
end

local function selectAllyOne(player, menu)
	addBattleAction(player.bother.battle, player.bother.party[menu.owner], player.bother.party[menu.hoverX],
		getAction(menu.items[menu.hoverY][menu.hoverX].action), menu.items[menu.hoverY][menu.hoverX].arg)
	
	setupBattleMenu(player, menu.owner+1)
end

local function selectSelf(player, menu)
	addBattleAction(player.bother.battle, player.bother.party[menu.owner], nil,
		getAction(menu.items[menu.hoverY][menu.hoverX].action), menu.items[menu.hoverY][menu.hoverX].arg)
	
	setupBattleMenu(player, menu.owner+1)
end

local function menuEnemyRow(player, menu)
	menu.submenu = {infoX = 80, infoY = 32, items = {}, backHandler = backHandler}
	menu.submenu.owner = menu.owner
	menu.submenu.infoPatch = "BATMEN2"
	menu.submenu.type = "row"
	local numEnemies
	for rowk,rowv in pairs(player.bother.battle.enemies) do
		numEnemies = 0
		for ek,enemy in pairs(rowv) do
			if enemy.status[1] ~= bConst.STATUS1_FAINTED and enemy.status[1] ~= bConst.STATUS1_DIAMONDIZED then
				numEnemies = numEnemies + 1
			end
		end
		if numEnemies > 0 then
			menu.submenu.items[rowk] = {}
			if rowk == 1 then
				menu.submenu.items[rowk][1] = {info = "To the back row",
					handler=selectEnemyRow,
					action = menu.items[menu.hoverY][menu.hoverX].action,
					arg = menu.items[menu.hoverY][menu.hoverX].arg}
			else
				menu.submenu.items[rowk][1] = {info = "To the front row",
					handler=selectEnemyRow,
					action = menu.items[menu.hoverY][menu.hoverX].action,
					arg = menu.items[menu.hoverY][menu.hoverX].arg}
			end
			if not menu.submenu.hoverY then
				menu.submenu.hoverY = rowk
			end
		end
	end
	menu.submenu.hoverX = 1
	menu.submenu.active = true
end

local function menuEnemyOne(player, menu)
	menu.submenu = {infoX = 80, infoY = 32, items = {}, backHandler = backHandler}
	menu.submenu.owner = menu.owner
	menu.submenu.infoPatch = "BATMEN2"
	menu.submenu.type = "enemy"
	for rowk,rowv in pairs(player.bother.battle.enemies) do
		for xk,xv in pairs(rowv) do
			if xv.status[1] ~= bConst.STATUS1_FAINTED and xv.status[1] ~= bConst.STATUS1_DIAMONDIZED then
				if not menu.submenu.items[rowk] then
					menu.submenu.items[rowk] = {}
				end
				menu.submenu.items[rowk][xk] = {info = "To " .. xv.name,
					handler=selectEnemyOne,
					action = menu.items[menu.hoverY][menu.hoverX].action,
					arg = menu.items[menu.hoverY][menu.hoverX].arg}
				if menu.submenu.hoverX == nil and menu.submenu.hoverY == nil then
					menu.submenu.hoverX = xk
					menu.submenu.hoverY = rowk
				end
			end
		end
	end
	menu.submenu.active = true
end

local function menuAllyOne(player, menu)
	menu.submenu = {x = 32, y = 48, items = {}, backHandler = backHandler}
	menu.submenu.owner = menu.owner
	menu.submenu.patch = "BATMEN6"
	menu.submenu.items[1] = {}
	for i=1,#player.bother.party,1 do
		menu.submenu.items[1][i] = {x = 16 + (48*(i-1)), name = player.bother.party[i].name,
			handler = selectAllyOne, 
			action = menu.items[menu.hoverY][menu.hoverX].action,
			arg = menu.items[menu.hoverY][menu.hoverX].arg}
	end
	menu.submenu.hoverX = 1
	menu.submenu.hoverY = 1
	menu.submenu.active = true
end

local function menuTargets(player, menu)
	local action = getAction(menu.items[menu.hoverY][menu.hoverX].action)
	if action.direction == bConst.ACTIONDIR_ENEMY then
		if action.target == bConst.ACTIONTARGET_ONE then
			menuEnemyOne(player, menu)
		elseif action.target == bConst.ACTIONTARGET_ROW then
			menuEnemyRow(player, menu)
		elseif action.target == bConst.ACTIONTARGET_ALL then
			selectEnemyAll(player, menu)
		end
	elseif action.direction == bConst.ACTIONDIR_PARTY then
		if acion.target == bConst.ACTIONTARGET_ONE then
			menuAllyOne(player, menu)
		elseif action.target == bConst.ACTIONTARGET_ROW or action.target == bConst.ACTIONTARGET_ALL then
			selectAllyAll(player, menu)
		end
	end
end

local function activateSubMenu(player, menu)
	menu.submenu.active = true
end

local function menuPsiInfo(player, psi)
	local name = "To "
	local action = getAction(psi.action)
	
	if action.target == bConst.ACTIONTARGET_ONE then
		name = name .. "one "
	elseif action.target == bConst.ACTIONTARGET_ROW then
		name = name .. "row "
	elseif action.target == bConst.ACTIONTARGET_ALL then
		name = name .. "all "
	end
	
	if action.direction == 1 then
		if action.target == 1 then
			name = name .. "enemy"
		elseif action.target == 2 then
			name = name .. "of foes"
		elseif action.target == 3 then
			name = name .. "enemies"
		end
	elseif action.direction == 2 then
		name = name .. "of us"
	end
	
	name = name .. "\nPP Cost: " .. action.pp
	
	return name
end

local function menuPsiSub(player, menu)
	menu.submenu = {x = 96, y = 8, infoX = 8, infoY = 8, items = {}, visible = true, backHandler = backHandler}
	menu.submenu.owner = menu.owner
	menu.submenu.patch = "BATMEN4"
	menu.submenu.infoPatch = "BATMEN5"
	local psiType = menu.items[menu.hoverY][menu.hoverX].arg
	local psiNum
	local psi
	local x
	local inserted = false
	local handler
	local info
	for i=1,#player.bother.party[menu.submenu.owner].psi,1 do
		inserted = false
		psiNum = player.bother.party[menu.submenu.owner].psi[i]
		psi = getPsi(psiNum)
		info = menuPsiInfo(player, psi)
		if getAction(psi.action).direction == 1 then -- enemy
			if getAction(psi.action).target == 1 then -- one
				handler = menuEnemyOne
			elseif getAction(psi.action).target == 2 then -- row
				handler = menuEnemyRow
			elseif getAction(psi.action).target == 3 then -- all
				handler = selectEnemyAll
			end
		elseif getAction(psi.action).direction == 2 then -- ally
			if getAction(psi.action).target == 1 then -- one
				handler = menuAllyOne
			elseif getAction(psi.action).target == 2 or getAction(psi.action).target == 3 then -- row or all
				handler = selectAllyAll
			end
		end
		if psi.type == psiType then
			x = 72 + (16 * psi.menuX)
			for i=1,#menu.submenu.items,1 do
				if menu.submenu.items[i].title == psi.name then
					table.insert(menu.submenu.items[i], psi.menuX, {x = x, name = psi.strength,
						handler = handler, action = psi.action, arg = psiNum,
						info = info})
					inserted = true
				end
			end
			if not inserted then
				table.insert(menu.submenu.items, {title = psi.name, titleX = 8,
					[psi.menuX]={x = x, name = psi.strength, handler = handler,
					action = psi.action, arg = psiNum, info = info}})
			end
			if not menu.submenu.hoverX and not menu.submenu.hoverY then
				menu.submenu.hoverX = 1
				menu.submenu.hoverY = 1
			end
		end
	end
end

local function menuPsi(player, menu)
	menu.submenu = {x = 32, y = 8, items = {}, active = true, backHandler = backHandler}
	menu.submenu.owner = menu.owner
	menu.submenu.patch = "BATMEN3"
	menu.submenu.items[1] = {}
	menu.submenu.items[2] = {}
	menu.submenu.items[3] = {}
	menu.submenu.items[1][1] = {x = 16, name = "Offense", handler = activateSubMenu, hoverHandler = menuPsiSub, arg = 1}
	menu.submenu.items[2][1] = {x = 16, name = "Recover", handler = activateSubMenu, hoverHandler = menuPsiSub, arg = 2}
	menu.submenu.items[3][1] = {x = 16, name = "Assist", handler = activateSubMenu, hoverHandler = menuPsiSub, arg = 3}
	menu.submenu.hoverX = 1
	menu.submenu.hoverY = 1
	menuPsiSub(player, menu.submenu) -- setup the first submenu
end

local function topBackHandle(player, menu)
	local origOwner = menu.owner
	
	menu.owner = menu.owner - 1
	if menu.owner < 1 then
		menu.owner = 1
	end
	while menu.owner > 1 and player.bother.party[menu.owner].currentStats.hp == 0 do
		menu.owner = menu.owner - 1
	end
	while menu.owner < #player.bother.party and player.bother.party[menu.owner].currentStats.hp == 0 do
		menu.owner = menu.owner + 1
	end
	
	if menu.owner < origOwner then
		-- remove the last added action because it isn't wanted anymore
		table.remove(player.bother.battle.actions)
	end
	
	setupBattleMenu(player, menu.owner)
end

local function sortActions(i1, i2)
	if i1.subactions[1].user.currentStats.speed > i2.subactions[1].user.currentStats.speed then
		return true
	end
end

local function setupBattleMenu(player, partyNum)
	player.bother.menu = {x = 8, y = 8, active = true, hoverX = 1, hoverY = 1, items = {},
	backHandler = topBackHandle}
	local menu = player.bother.menu
	menu.owner = partyNum
	while menu.owner <= #player.bother.party and player.bother.party[menu.owner].currentStats.hp == 0 do
		menu.owner = menu.owner + 1
	end
	if menu.owner > #player.bother.party then
		menu.active = false
		player.bother.textBox.curText = ""
		enemyActions(player.bother)
		table.sort(player.bother.battle.actions, sortActions)
		return
	end
	menu.name = player.bother.party[menu.owner].name
	menu.patch = "BATMEN1"
	menu.active = true
	menu.items[1] = {}
	menu.items[2] = {}
	menu.items[1][1] = {x = 16, name = "Bash", handler=menuTargets, action = 4, arg = 2}
	menu.items[2][1] = {x = 16, name = "PSI", handler=menuPsi}
	--menu.items[1][2] = {x = 64, name = "Goods", handler=function() print("Goods") end}
	menu.items[2][2] = {x = 64, name = "Defend", handler=selectSelf, action = 8}
	--menu.items[1][3] = {x = 112, name = "Auto Fight", handler=function() print("Auto Fight") end}
	--menu.items[2][3] = {x = 112, name = "Run Away", handler=function() print("Run Away") end}
end

local function continueDialogueHandle(player, menu)
	player.bother.textBox.pause = false
	menu.active = false
	menu = nil
end

-- For when out of battle dialogue pauses and waits for input
local function setupDialogueWait(player)
	player.bother.textBox.pause = true
	player.bother.menu = {x = 240, y = 47, active = true, hoverX = 1, hoverY = 1, items = {},
		backHandler = continueDialogueHandle, patchAnim = {"TEXTWA1", "TEXTWA2"}, animDuration = 12}
	local menu = player.bother.menu
	menu.type = "dialoguewait"
	menu.items[1] = {}
	menu.items[1][1] = {x = 0, handler=continueDialogueHandle}
end

local function wrap(value, lower, upper)
	local range = upper - lower + 1
	
	if value < lower then
		value = value + range * ((lower - value) / range + 1)
	end
	
	return lower + (value - lower) % range
end

local function playerMenuThink(player, menu)
	if menu.submenu and menu.submenu.active then
		playerMenuThink(player, menu.submenu)
		return
	end
	
	player.mo.momx = 0
	player.mo.momy = 0
	player.mo.momz = 0
	
	local minX = 32768
	local minY = 32768
	local maxX = 0
	local maxY = 0
	
	for yk,yv in pairs(menu.items) do
		for xk,xv in pairs(yv) do
			if type(xk) == "number" then
				minX = min(minX, xk)
				maxX = max(maxX, xk)
			end
		end
		minY = min(minY, yk)
		maxY = max(maxY, yk)
	end
	
	if (player.cmd.forwardmove or player.cmd.sidemove)
	and not (player.bother.bPress & UPPRESS) and not (player.bother.bPress & DOWNPRESS)
	and not (player.bother.bPress & LEFTPRESS) and not (player.bother.bPress & RIGHTPRESS) then
		if player.cmd.forwardmove > 0 and not (player.bother.bPress & UPPRESS) then
			menu.hoverY = wrap(menu.hoverY - 1, minY, maxY)
			local numItems = 0
			while not menu.items[menu.hoverY] or not menu.items[menu.hoverY][menu.hoverX] do
				for yk,yv in pairs(menu.items) do
					for xk,_ in pairs(yv) do
						if type(xk) == "number" then
							if xk == menu.hoverX then
								numItems = numItems + 1
							end
						end
					end
				end
				if numItems > 0 then
					menu.hoverX = wrap(menu.hoverX + 1, minX, maxX)
				else
					menu.hoverY = wrap(menu.hoverY - 1, minY, maxY)
				end
			end
			if menu.items[menu.hoverY][menu.hoverX].hoverHandler then
				menu.items[menu.hoverY][menu.hoverX].hoverHandler(player, menu)
			end
			S_StartSound(nil, sfx_curver, player)
		end
		if player.cmd.forwardmove < 0 and not (player.bother.bPress & DOWNPRESS) then
			menu.hoverY = wrap(menu.hoverY + 1, minY, maxY)
			local numItems = 0
			while not menu.items[menu.hoverY] or not menu.items[menu.hoverY][menu.hoverX] do
				for yk,yv in pairs(menu.items) do
					for xk,_ in pairs(yv) do
						if type(xk) == "number" then
							if xk == menu.hoverX then
								numItems = numItems + 1
							end
						end
					end
				end
				if numItems > 0 then
					menu.hoverX = wrap(menu.hoverX - 1, minX, maxX)
				else
					menu.hoverY = wrap(menu.hoverY + 1, minY, maxY)
				end
			end
			if menu.items[menu.hoverY][menu.hoverX].hoverHandler then
				menu.items[menu.hoverY][menu.hoverX].hoverHandler(player, menu)
			end
			S_StartSound(nil, sfx_curver, player)
		end
		if player.cmd.sidemove < 0 and not (player.bother.bPress & LEFTPRESS) then
			menu.hoverX = wrap(menu.hoverX - 1, minX, maxX)
			while not menu.items[menu.hoverY] or not menu.items[menu.hoverY][menu.hoverX] do
				menu.hoverX = wrap(menu.hoverX - 1, minX, maxX)
			end
			if menu.items[menu.hoverY][menu.hoverX].hoverHandler then
				menu.items[menu.hoverY][menu.hoverX].hoverHandler(player, menu)
			end
			S_StartSound(nil, sfx_curhor, player)
		end
		if player.cmd.sidemove > 0 and not (player.bother.bPress & RIGHTPRESS) then
			menu.hoverX = wrap(menu.hoverX + 1, minX, maxX)
			while not menu.items[menu.hoverY] or not menu.items[menu.hoverY][menu.hoverX] do
				menu.hoverX = wrap(menu.hoverX + 1, minX, maxX)
			end
			if menu.items[menu.hoverY][menu.hoverX].hoverHandler then
				menu.items[menu.hoverY][menu.hoverX].hoverHandler(player, menu)
			end
			S_StartSound(nil, sfx_curhor, player)
		end
	elseif (player.cmd.buttons & BT_USE) and not (player.bother.bPress & SPINPRESS) then
		menu.backHandler(player, menu)
		S_StartSound(nil, sfx_curhor, player)
	elseif (player.cmd.buttons & BT_JUMP) and not (player.bother.bPress & JUMPPRESS) then
		menu.items[menu.hoverY][menu.hoverX].handler(player, menu)
		S_StartSound(nil, sfx_cursel, player)
	end

	player.bother.bPress = 0
	if player.cmd.buttons & BT_JUMP then
		player.bother.bPress = player.bother.bPress | JUMPPRESS
	end
	if player.cmd.buttons & BT_USE then
		player.bother.bPress = player.bother.bPress | SPINPRESS
	end
	if player.cmd.forwardmove > 0 then
		player.bother.bPress = player.bother.bPress | UPPRESS
	end
	if player.cmd.forwardmove < 0 then
		player.bother.bPress = player.bother.bPress | DOWNPRESS
	end
	if player.cmd.sidemove < 0 then
		player.bother.bPress = player.bother.bPress | LEFTPRESS
	end
	if player.cmd.sidemove > 0 then
		player.bother.bPress = player.bother.bPress | RIGHTPRESS
	end
end

rawset(_G, "setupBattleMenu", setupBattleMenu)
rawset(_G, "setupDialogueWait", setupDialogueWait)
rawset(_G, "playerMenuThink", playerMenuThink)
