local BASEVIDWIDTH = 320
local BASEVIDHEIGHT = 200

-- Byoutiful
-- 127 and 127 are SMAAAASH!! and YOU WON!
local textWidth = {[" "]=2, ["!"]=3, ["\""]=4, ["#"]=3, ["$"]=6, ["%"]=10, ["&"]=8,
				["'"]=3, ["("]=4, [")"]=4, ["*"]=4, ["+"]=6, [","]=3, ["-"]=3,
				["."]=3, ["/"]=5, ["0"]=6, ["1"]=6, ["2"]=6, ["3"]=6, ["4"]=6,
				["5"]=6, ["6"]=6, ["7"]=6, ["8"]=6, ["9"]=6, [":"]=3, [";"]=4,
				["<"]=4, ["="]=6, [">"]=4, ["?"]=5, ["@"]=6, ["A"]=7, ["B"]=6,
				["C"]=6, ["D"]=6, ["E"]=5, ["F"]=5, ["G"]=6, ["H"]=6, ["I"]=2,
				["J"]=5, ["K"]=6, ["L"]=5, ["M"]=8, ["N"]=6, ["O"]=6, ["P"]=6,
				["Q"]=6, ["R"]=6, ["S"]=6, ["T"]=6, ["U"]=6, ["V"]=7, ["W"]=8,
				["X"]=6, ["Y"]=6, ["Z"]=5, ["["]=6, ["\\"]=5, ["]"]=7, ["^"]=5,
				["_"]=6, ["`"]=6, ["a"]=5, ["b"]=5, ["c"]=5, ["d"]=5, ["e"]=5,
				["f"]=4, ["g"]=5, ["h"]=5, ["i"]=2, ["j"]=3, ["k"]=5, ["l"]=2,
				["m"]=8, ["n"]=5, ["o"]=5, ["p"]=5, ["q"]=5, ["r"]=4, ["s"]=5,
				["t"]=4, ["u"]=5, ["v"]=6, ["w"]=8, ["x"]=5, ["y"]=5, ["z"]=5,
				["{"]=3, ["|"]=6, ["}"]=3, ["~"]=7, ["\127"]=8, ["\128"]=72, ["\129"]=72}

local function drawAnimations(v, stplyr)
	local bother = stplyr.bother
	
	if not bother or not bother.animations or #bother.animations < 1 then
		return
	end
	
	local patch
	local patchSuffix
	local patchScale
	local animation
	local psiAnim
	
	local xOffset = 0
	local yOffset = 0
	local sxf
	local syf
	local oldPatchScale, newPatchScale
	local patchRealHeight, patchRealWidth
	for i=1,#bother.animations,1 do
		if bother.animations[i].psiAnim or not bother.animations[i].ticker then
			animation = bother.animations[i]
			psiAnim = animation.psiAnim
			patchSuffix = (((psiAnim.speed * psiAnim.frames) - animation.ticker) / psiAnim.speed) + 1
			patch = v.cachePatch(psiAnim.patchPrefix .. patchSuffix)
			
			-- for GL use the default because it scales with it anyway
			patchScale = FixedDiv(BASEVIDWIDTH*FRACUNIT, patch.width*FRACUNIT)
			xOffset = 0
			yOffset = (BASEVIDHEIGHT*FRACUNIT - FixedMul(patch.height*FRACUNIT, patchScale)) / 2 -- centre it vertically
			if psiAnim.target == bConst.ANIMTARGET_ONE or psiAnim.target == bConst.ANIMTARGET_THUNDER then
				xOffset = animation.xOffset*FRACUNIT
			end
			if psiAnim.target == bConst.ANIMTARGET_ONE or psiAnim.target == bConst.ANIMTARGET_ROW
			or psiAnim.target == bConst.ANIMTARGET_THUNDER then
				yOffset = yOffset + FixedMul(animation.yOffset*FRACUNIT, patchScale)
			end
			-- Scale the patch so that it always fills the entire screen
			sxf = FixedDiv(v.width()*FRACUNIT, BASEVIDWIDTH*FRACUNIT)
			syf = FixedDiv(v.height()*FRACUNIT, BASEVIDHEIGHT*FRACUNIT)
			if sxf > syf then
				oldPatchScale = (v.height() / BASEVIDHEIGHT)*FRACUNIT
			else
				oldPatchScale = (v.width() / BASEVIDWIDTH)*FRACUNIT
			end
			newPatchScale = sxf
			patchScale = FixedMul(patchScale, FixedDiv(newPatchScale, oldPatchScale))
			
			-- need to offset if scaled
			-- someone please end my suffering
			if psiAnim.target == bConst.ANIMTARGET_ONE or psiAnim.target == bConst.ANIMTARGET_ROW
			or psiAnim.target == bConst.ANIMTARGET_THUNDER then
				xOffset = animation.xOffset*FRACUNIT
			end
			patchRealHeight = FixedMul(FixedMul(patch.height*FRACUNIT, patchScale), oldPatchScale)
			yOffset = (v.height()*FRACUNIT - patchRealHeight) / 2
			yOffset = FixedDiv(yOffset, oldPatchScale)
			yOffset = yOffset + animation.yOffset*FRACUNIT
			if psiAnim.target == bConst.ANIMTARGET_THUNDER then
				-- Thunder draws flipped patches to the sides
				-- (although I believe it only really shows on gamma and omega)
				patchRealWidth = FixedMul(FixedMul(patch.width*FRACUNIT, patchScale), oldPatchScale)
				
				if xOffset > 0 then
					v.drawScaled(xOffset, yOffset, patchScale, patch, V_FLIP|V_SNAPTOTOP|V_SNAPTOLEFT|psiAnim.vFlags)
				elseif xOffset + patchRealWidth < v.width()*FRACUNIT then
					v.drawScaled(xOffset+(BASEVIDWIDTH*2*FRACUNIT), yOffset, patchScale, patch, V_FLIP|V_SNAPTOTOP|V_SNAPTOLEFT|psiAnim.vFlags)
				end
			end
			v.drawScaled(xOffset, yOffset, patchScale, patch, V_SNAPTOTOP|V_SNAPTOLEFT|psiAnim.vFlags)
		end
	end
end

local function drawEncounterSwirl(v, stplyr)
	local bother = stplyr.bother
	
	if not bother or not bother.battleStart or not bother.encounterEnemy then
		return
	end
	
	local pPrefix
	local interval
	
	if not getEnemy(bother.encounterEnemy.type).boss then
		pPrefix = "RENCTR"
		interval = 1
	else
		pPrefix = "BENCTR"
		interval = 2
	end
	
	local time = bConst.SWIRL_DURATION + 17 - bother.battleStart
	local graphicNum = max(min((time - 17)/interval, 22), 0)
	local patch = v.cachePatch(pPrefix .. graphicNum)
	-- fade out and fade in stuff
	local transFlag = V_50TRANS
	if bother.battleStart == 1 then
		transFlag = V_90TRANS
	elseif bother.battleStart == 2 then
		transFlag = V_80TRANS
	elseif bother.battleStart == 3 then
		transFlag = V_70TRANS
	elseif bother.battleStart == 4 then
		transFlag = V_60TRANS
	elseif bother.battleStart == 6 or bother.battleStart == 14 then
		transFlag = V_40TRANS
	elseif bother.battleStart == 7 or bother.battleStart == 13 then
		transFlag = V_30TRANS
	elseif bother.battleStart == 8 or bother.battleStart == 12 then
		transFlag = V_20TRANS
	elseif bother.battleStart == 9 or bother.battleStart == 11 then
		transFlag = V_10TRANS
	elseif bother.battleStart == 10 then
		transFlag = 0
	end
	
	-- for GL use the default because it scales with it anyway
	local patchScale = FixedDiv(200*FRACUNIT, 224*FRACUNIT)
	local xOffset = 0
	local yOffset = 0
	-- Scale the patch so that it always fills the entire screen
	local sxf = FixedDiv(v.width()*FRACUNIT, BASEVIDWIDTH*FRACUNIT)
	local syf = FixedDiv(v.height()*FRACUNIT, BASEVIDHEIGHT*FRACUNIT)
	local oldPatchScale, newPatchScale
	if sxf > syf then
		oldPatchScale = v.height() / BASEVIDHEIGHT
		newPatchScale = sxf
	else
		oldPatchScale = v.width() / BASEVIDWIDTH
		newPatchScale = syf
	end
	patchScale = FixedMul(patchScale, FixedDiv(newPatchScale, oldPatchScale*FRACUNIT))
	
	-- need to offset if scaled
	-- someone please end my suffering
	yOffset = FixedDiv((v.height()*FRACUNIT - FixedMul(FixedMul(patch.height*FRACUNIT, patchScale), oldPatchScale*FRACUNIT)) / 2, syf)
	xOffset = FixedDiv((v.width()*FRACUNIT - FixedMul(FixedMul(patch.width*FRACUNIT, patchScale), oldPatchScale*FRACUNIT)) / 2, sxf)
	v.drawScaled(xOffset, yOffset, patchScale, patch, V_SNAPTOTOP|V_SNAPTOLEFT|transFlag)
	
end

-- Searches menus and submenus for a menu type
-- returns the menu if it exists
local function searchMenus(menu, ...)
	if not menu or not menu.active then
		return
	end
	
	for i,v in pairs({...}) do
		if menu.type == v then
			return menu
		end
	end
	
	if menu.submenu and menu.submenu.active then
		return searchMenus(menu.submenu, ...)
	end
end

local function drawBattleEnemies(v, stplyr)
	local bother = stplyr.bother
	if not bother
	or bother.inBattle == nil or not bother.encounterEnemy or not bother.battle.enemies then
		return
	end
	
	local battleEnemies = bother.battle.enemies
	local patch
	local x = 60+bother.xScreenOff
	local y = 95+bother.screenShake
	local enemyMenu
	local patchFlags = 0
	
	if bother.menu and bother.menu.active then
		enemyMenu = searchMenus(bother.menu, "enemy", "row")
	end
	
	for i=1,#battleEnemies,1 do
		for j=1,7,1 do
			patchFlags = 0
			if battleEnemies[i][j] and battleEnemies[i][j].type then
				if (battleEnemies[i][j].status[1] ~= bConst.STATUS1_FAINTED or battleEnemies[i][j].dying)
				and (not battleEnemies[i][j].flashing
				or (battleEnemies[i][j].flashing and battleEnemies[i][j].flashing % 2 ~= 0)) then
					if (enemyMenu and enemyMenu.type == "enemy"
					and ((enemyMenu.hoverX == j and enemyMenu.hoverY == i and leveltime % 16 < 8)
					or (enemyMenu.hoverX ~= j or enemyMenu.hoverY ~= i)))
					or (enemyMenu and enemyMenu.type == "row"
					and ((enemyMenu.hoverY == i and leveltime % 16 < 8)
					or enemyMenu.hoverY ~= i)) then
						patchFlags = V_40TRANS
					end
					if battleEnemies[i][j].status[1] == bConst.STATUS1_FAINTED and battleEnemies[i][j].dying then
						if battleEnemies[i][j].dying >= 0 then
							if battleEnemies[i][j].dying <= 2 then
								patchFlags = V_90TRANS
							elseif battleEnemies[i][j].dying <= 4 then
								patchFlags = V_80TRANS
							elseif battleEnemies[i][j].dying <= 6 then
								patchFlags = V_70TRANS
							elseif battleEnemies[i][j].dying <= 8 then
								patchFlags = V_60TRANS
							elseif battleEnemies[i][j].dying <= 10 then
								patchFlags = V_50TRANS
							elseif battleEnemies[i][j].dying <= 12 then
								patchFlags = V_40TRANS
							elseif battleEnemies[i][j].dying <= 14 then
								patchFlags = V_30TRANS
							elseif battleEnemies[i][j].dying <= 16 then
								patchFlags = V_20TRANS
							elseif battleEnemies[i][j].dying <= 18 then
								patchFlags = V_10TRANS
							end
						end
					end				
					patch = v.cachePatch(getEnemy(battleEnemies[i][j].type).image)
					v.drawScaled((x-patch.width/4)*FRACUNIT, (y-patch.height/2)*FRACUNIT, FRACUNIT/2, patch, patchFlags)
				end
			end
			x = x + 35
		end
		x = 55 + bother.xScreenOff
		y = y + 30
	end
end

local function drawRollingMeter(v, window, x, y, scale, number, flags)
	-- integer number of the value
	local intNum = number/FRACUNIT
	local decimal = number - intNum*FRACUNIT
	-- table of what each digit is from the integer
	local digits = {intNum/(10^2) % 10, intNum/(10^1) % 10, intNum/(10^0) % 10}
	local patch = v.cachePatch(window .. "HPPP-_0") -- Just a default
	
	for i=1,3,1 do
		local prefix = "-"
		local suffix = 0
		local turn = true
		
		-- if itself and the numbers to the left of it are not 0 we don't use
		-- the blank version
		-- the last number always uses the number however
		for j=i,1,-1 do
			if digits[j] != 0 or j == 3 then
				prefix = digits[i]
				break
			end
		end
		
		-- If any of the numbers to the right of it are not 9 then this number
		-- is not flipping over
		for j=i,2,1 do
			if (digits[j+1] != 9) then
				turn = false
				break
			end
		end
		
		-- If the number is turning then we set the suffix to be the correct one
		if turn then
			suffix = (decimal * 4) / FRACUNIT
		end
		
		patch = v.cachePatch(window .. "HPPP" .. prefix .. "_" .. suffix)
		
		v.drawScaled(x+(i-1)*8*FRACUNIT, y, scale, patch, flags)
	end
end

local function drawFontEB(v, window, x, y, text, prefix, flags)
	local charCode
	local patch
	local startX = x
	for i=1,#text,1 do
		charCode = string.byte(text, i)
		charCode = string.format("%03d", charCode)
		if charCode == "127" then
			patch = v.cachePatch(window .. "SMAAASH")
			v.drawScaled(x*FRACUNIT, y*FRACUNIT, FRACUNIT, patch, flags)
		elseif charCode == "128" then
			patch = v.cachePatch(window .. "YOUWON")
			v.drawScaled(x*FRACUNIT, y*FRACUNIT, FRACUNIT, patch, flags)
		elseif v.patchExists(prefix .. charCode) then
			-- Only draw if we have a patch, avoids the issue of spaces
			-- and other bad characters we don't have
			patch = v.cachePatch(prefix .. charCode)
			v.drawScaled(x*FRACUNIT, y*FRACUNIT, FRACUNIT, patch, flags)
		end
		if prefix == "EBBFN" or prefix == "EBSFN" then
			x = x + (textWidth[string.sub(text, i, i)] and 6 or 0)
		elseif prefix == "EBRFN" then
			x = x + (textWidth[string.sub(text, i, i)] or 0)
		end
		if charCode == "010" then
			x = startX
			y = y + 16
		end
	end
end

local function drawBattleStatus(v, stplyr)
	local bother = stplyr.bother
	if not bother or bother.inBattle == nil then
		return
	end
	local patch = v.cachePatch(stplyr.bother.window .. "BSTATUS")
	
	local x = 160-#bother.party*(patch.width/2)+bother.xScreenOff
	
	local letterbox = getFormation(bother.encounterFormation).letterbox
	
	if letterbox then
		local barsize = 61 - (61/3)*(3-letterbox)
		-- hack drawing across the entire screen in non-green with 2 drawfills...
		-- Someone needs to fix this in both software and hardware
		v.drawFill(0, 0, 320, barsize, 31+V_SNAPTOTOP|V_SNAPTOLEFT)
		v.drawFill(0, 0, 320, barsize, 31+V_SNAPTOTOP|V_SNAPTORIGHT)
		v.drawFill(0, 200-barsize, 320, barsize, 31+V_SNAPTOBOTTOM|V_SNAPTOLEFT)
		v.drawFill(0, 200-barsize, 320, barsize, 31+V_SNAPTOBOTTOM|V_SNAPTORIGHT)
	end
	
	local party
	local statusPatch
	
	local y = 128 + bother.screenShake
	for i=1,#bother.party,1 do
		party = bother.party[i]
		y = 128 + bother.screenShake
		if (bother.menu and bother.menu.active and bother.menu.owner == i)
		or ((not bother.menu or not bother.menu.active)
		and bother.battle.actions and bother.battle.actions[1] and bother.battle.actions[1].subactions
		and bother.battle.actions[1].subactions[1] and bother.battle.actions[1].subactions[1].user == party) then
			y = y - 8
		end
		
		v.drawScaled(x*FRACUNIT, (y)*FRACUNIT, FRACUNIT, patch, V_SNAPTOBOTTOM)
		
		if party.status[1] or party.status[2] or party.status[3]
		or party.feelStrange then
			if party.status[1] == bConst.STATUS1_FAINTED then
				statusPatch = stplyr.bother.window .. "STATUB1"
			else
				statusPatch = stplyr.bother.window .. "STATUB2"
			end
			if v.patchExists(statusPatch) then
				statusPatch = v.cachePatch(statusPatch)
				v.drawScaled((x+8)*FRACUNIT, (y+8)*FRACUNIT, FRACUNIT, statusPatch, V_SNAPTOBOTTOM)
			end
			if party.feelStrange then
				statusPatch = v.cachePatch(stplyr.bother.window .. "STATU41")
				v.drawScaled((x+40)*FRACUNIT, (y+8)*FRACUNIT, FRACUNIT, statusPatch, V_SNAPTOBOTTOM)
			else
				for i=#party.status,1,-1 do
					if i == 4 then -- This will always be just this
						statusPatch = stplyr.bother.window .. "STATU" .. i .. 1
					else
						statusPatch = stplyr.bother.window .. "STATU" .. i .. party.status[i]
					end
					if party.status[i] and v.patchExists(statusPatch) then
						statusPatch = v.cachePatch(statusPatch)
						v.drawScaled((x+40)*FRACUNIT, (y+8)*FRACUNIT, FRACUNIT, statusPatch, V_SNAPTOBOTTOM)
						break
					end
				end
			end
		end
		
		drawRollingMeter(v, stplyr.bother.window, (x+24)*FRACUNIT, (y+24)*FRACUNIT, FRACUNIT, party.currentStats.hp, V_SNAPTOBOTTOM)
		if party.cantConcentrate then
			statusPatch = v.cachePatch(stplyr.bother.window .. "HPPPCON")
			v.drawScaled((x+24)*FRACUNIT, (y+40)*FRACUNIT, FRACUNIT, statusPatch, V_SNAPTOBOTTOM)
		else
			drawRollingMeter(v, stplyr.bother.window, (x+24)*FRACUNIT, (y+40)*FRACUNIT, FRACUNIT, party.currentStats.pp, V_SNAPTOBOTTOM)
		end
		
		drawFontEB(v, stplyr.bother.window, x+10, y+8, string.sub(party.name, 1, 5), "EBBFN", V_SNAPTOBOTTOM)
		
		x = x + patch.width
	end
end

local function drawTextWindow(v, stplyr)
	if not stplyr.bother
	or not stplyr.bother.textBox or not stplyr.bother.textBox.active then
		return
	end
	
	local patch = v.cachePatch(stplyr.bother.window .. "TEXTWIN")
	v.drawScaled((64+stplyr.bother.xScreenOff)*FRACUNIT, (7+stplyr.bother.screenShake)*FRACUNIT, FRACUNIT, patch, V_SNAPTOTOP)
	
	drawFontEB(v, stplyr.bother.window, 72+stplyr.bother.xScreenOff, 15+stplyr.bother.screenShake, stplyr.bother.textBox.curText, "EBRFN", V_SNAPTOTOP)
end

local function drawMenu(v, bother, menu)
	if not menu or (not menu.active and not menu.visible) then
		return
	end
	
	if menu.patch then
		local patch = v.cachePatch(bother.window .. menu.patch)
		v.drawScaled(menu.x*FRACUNIT, menu.y*FRACUNIT, FRACUNIT, patch, V_SNAPTOTOP)
	end
	
	local drawX, drawY
	local selectPatch = "SELECTR"
	
	if leveltime % 18 < 9 then
		selectPatch = "SELECT2"
	end
	
	if menu.patch then
		local patch = v.cachePatch(bother.window .. menu.patch)
		v.drawScaled(menu.x*FRACUNIT, menu.y*FRACUNIT, FRACUNIT, patch, V_SNAPTOTOP)
		if menu.name then
			drawFontEB(v, bother.window, menu.x+16, menu.y, menu.name, "EBSFN", V_SNAPTOTOP)
		end
		for yk,yv in pairs(menu.items) do
			drawY = menu.y + 8 + (yk-1)*16
			if yv.title then
				drawFontEB(v, bother.window, menu.x + yv.titleX, drawY, yv.title, "EBRFN", V_SNAPTOTOP)
			end
			for xk,xv in pairs(yv) do
				if type(xk) == "number" then
					drawX = menu.x + xv.x
					if xv.name then
						drawFontEB(v, window, drawX, drawY, xv.name, "EBRFN", V_SNAPTOTOP)
					end
					if menu.type ~= "dialoguewait" and menu.active and (not menu.submenu or not menu.submenu.active)
					and menu.hoverX == xk and menu.hoverY == yk then
						v.drawScaled((drawX-8)*FRACUNIT, drawY*FRACUNIT, FRACUNIT, v.cachePatch(bother.window .. selectPatch), V_SNAPTOTOP)
					end
				end
			end
		end
	end
	if menu.patchAnim and menu.animDuration then
		local animNum = ((leveltime / menu.animDuration) % #menu.patchAnim) + 1
		local thisPatch = v.cachePatch(bother.window .. menu.patchAnim[animNum])
		v.drawScaled(menu.x*FRACUNIT, menu.y*FRACUNIT, FRACUNIT, thisPatch, V_SNAPTOTOP)
	end
	if menu.active and menu.infoPatch and menu.items[menu.hoverY][menu.hoverX].info
	and menu.items[menu.hoverY] and menu.items[menu.hoverY][menu.hoverX] then
		local patch = v.cachePatch(bother.window .. menu.infoPatch)
		v.drawScaled(menu.infoX*FRACUNIT, menu.infoY*FRACUNIT, FRACUNIT, patch, V_SNAPTOTOP)
		drawFontEB(v, window, menu.infoX+8, menu.infoY+8, menu.items[menu.hoverY][menu.hoverX].info, "EBRFN", V_SNAPTOTOP)
		if menu.type == "enemy" then
			local enemy = bother.battle.enemies[menu.hoverY][menu.hoverX]
			if enemy.status[1] or enemy.status[2] or enemy.status[3]
			or enemy.feelStrange then
				local statusPatch
				if enemy.feelStrange then
					statusPatch = v.cachePatch(bother.window .. "STATU41")
					v.drawScaled((menu.infoX+144)*FRACUNIT, (menu.infoY+8)*FRACUNIT, FRACUNIT, statusPatch, V_SNAPTOTOP)
				else
					for i=#enemy.status,1,-1 do
						if i == 4 then -- This will always be just this
							statusPatch = bother.window .. "STATU" .. i .. 1
						else
							statusPatch = bother.window .. "STATU" .. i .. enemy.status[i]
						end
						if enemy.status[i] and v.patchExists(statusPatch) then
							statusPatch = v.cachePatch(statusPatch)
							v.drawScaled((menu.infoX+144)*FRACUNIT, (menu.infoY+8)*FRACUNIT, FRACUNIT, statusPatch, V_SNAPTOTOP)
							break
						end
					end
				end
			end
		end
	end
	
	if menu.submenu and (menu.submenu.active or menu.submenu.visible) then
		drawMenu(v, bother, menu.submenu)
	end
end

local function menuDrawer(v, stplyr)
	if not stplyr or not stplyr.bother or not stplyr.bother.menu then
		return
	end
	drawMenu(v, stplyr.bother, stplyr.bother.menu)
end

-- returns the total width of the string, and where it becomes too long
local function getFontWidthEB(text, prefix, startingWidth)
	local patch
	local width = startingWidth
	local tooLongLocation = #text
	for i=1,#text,1 do
		if prefix == "EBBFN" then
			width = width + (textWidth[string.sub(text, i, i)] and 6 or 0)
		elseif prefix == "EBRFN" then
			width = width + (textWidth[string.sub(text, i, i)] or 0)
		end
		if string.sub(text, i, i) == "\n" then
			width = 0
		end
		if width > 168 and tooLongLocation == #text then
			tooLongLocation = i-1
		end
	end
	return width, tooLongLocation
end

rawset(_G, "getFontWidthEB", getFontWidthEB)

hud.add(drawBattleEnemies, "game")
hud.add(drawBattleStatus, "game")
hud.add(drawEncounterSwirl, "game")
hud.add(drawTextWindow, "game")
hud.add(menuDrawer, "game")
hud.add(drawAnimations, "game")

local function debugStats(v, stplyr)
	if not stplyr.bother or not stplyr.bother.party then
		return
	end
	
	local y = 50
	local x = 0
	for i=1,#stplyr.bother.party,1 do
		v.drawString(x, y, stplyr.bother.party[i].name, V_REDMAP)
		y = y + 10
		for k,s in pairs(stplyr.bother.party[i].stats) do
			v.drawString(x, y, k .. ": " .. s)
			y = y + 10
		end
		x = x + 100
		y = 50
	end
end

--hud.add(debugStats, "game")
