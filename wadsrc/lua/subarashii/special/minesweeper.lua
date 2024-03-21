--[[
wHAT ARE YOU DOIN G HERE SHOO
DON 'T STEAL MY FUCKIG NSHIT
]]

--freeslut
freeslot(
	"sfx_msbeep",
	"sfx_msboom",
	"sfx_mswin"
)

local ms = {}
ms.sectorList = {}
ms.fList = {} -- Formatted, row|column style with sector and data
ms.fListRef = {} -- The same list as above but with numbers instead and uses references
--ms.curfList = {}
--ms.curfListRef = {}
ms.fieldData = {} -- Field data, like height, width and amount of mines, probably other stuff
--ms.emeraldToAward = MT_EMERALD3

-- The following two functions check that value is in field bounds
local function gY(n)
	if n >= 1 and n <= ms.fieldData.height then return true else return false end
end
local function gX(n)
	if n >= 1 and n <= ms.fieldData.width then return true else return false end
end

local function copy(origin)
    local new
    new = {}
    for key, value in pairs(origin) do
        new[key] = value
    end
    return new
end

local function resetMinefield()
if mapheaderinfo[gamemap].minesweeper == "1" then
	for player in players.iterate do
		if player.mo and player.mo.valid then
			P_SetOrigin(player.mo, 64*FRACUNIT, (20*128*FRACUNIT)-(64*FRACUNIT), 0)
			player.mo.angle = ANGLE_315
		end
	end
	ms.fList = {} -- Empty this
	ms.fListRef = {} -- Same
	--ms.curfList = {} -- Guess, Sherlock
	--ms.curfListRef = {} -- Elementary, u lil piece of sTEAK
	ms.fieldData = {} -- A NUU CHEEKI BREEKI

	for i = 1,600 do table.insert(ms.sectorList, sectors[i]) end
	local am = 1

	for i = 1,20 do -- Amount of rows
	for j = 1,30 do -- Amount of columns

		if ms.fList[i] == nil then
			ms.fList[i] = {}
		end -- Initialize row if it doesn't exist
		local k = ms.fList[i] -- 'cause

		if k[j] == nil then k[j] = {} end -- Initialize column if it doesn't exist
		local l = k[j] -- shut the fuck up
		l.sector = sectors[am]
		l.sector.floorheight = 0
		l.sector.ceilingheight = 2048*FRACUNIT
		l.myX = j
		l.myY = i
		-- Initialize some variables with defaults
		l.contents = "none" -- 'mine' or 'none'
		l.minesAround = 0 -- from 0 to 8, mines around the cell
		l.status = "uncovered" -- 'wall', 'covered', 'uncovered', 'flagged' or 'exploded' (mine)

		ms.fListRef[am] = l -- Add reference to reference list

		am = $ + 1

	end
	end

	ms.fieldData.height = 20
	ms.fieldData.width = 30
	ms.fieldData.mines = 20
	--ms.fieldData.wrapAround = 0
	ms.fieldData.noFirstTileDeath = 0

	ms.fieldData.inGame = 0
	ms.fieldData.timeElapsed = 0
	ms.fieldData.clicks = 0
	ms.fieldData.gameEnded = 0
	ms.fieldData.timeElapsedSinceEnd = 0
	ms.fieldData.gameLost = 0
	ms.fieldData.gameWon = 0
	ms.fieldData.obituary = "Oh no!"
	ms.fieldData.timeLimit = 0
	ms.fieldData.runningTimeLimit = 0
	ms.fieldData.turnTimeLimit = 0
	ms.fieldData.runningTurnTimeLimit = 0

	ms.fieldData.numCoveredTiles = 0
	ms.fieldData.numFlaggedTiles = 0
	ms.fieldData.exploded = 0
	ms.fieldData.numNoneTiles = 0

	ms.fieldData.heightFrac = 20*128*FRACUNIT
	--ms.fieldData.maxHeightFracFTC = 0
	ms.fieldData.widthFrac = 30*128*FRACUNIT

	ms.winFOF = sectors[601]
	ms.loseFOF = sectors[602]

end
end

local function newMinefield(fieldHeight, fieldWidth, fieldMines, fieldNoFirstTileDeath)
	local mh = mapheaderinfo[gamemap]
if fieldMines ~= nil and server and mh.minesweeper then
	resetMinefield()
	ms.fieldData.inGame = 1
	ms.fieldData.noFirstTileDeath = 1 -- not yet
	fieldHeight,fieldWidth,fieldMines = tonumber($1),tonumber($2),tonumber($3)

	if tonumber(mh.msheight) then fieldHeight = tonumber(mh.msheight) end
	if tonumber(mh.mswidth) then fieldWidth = tonumber(mh.mswidth) end
	if tonumber(mh.msmines) then fieldMines = tonumber(mh.msmines) end


	--[[
	Lua.MSHeight = 8
	Lua.MSWidth = 8
	Lua.MSMines = 10
	]]
	local function m(msg)
		print(msg)
	end

	if fieldHeight == nil then fieldHeight = 5;m("Something's wrong with that height number, so I reset it to 5.") end
	if fieldWidth == nil then fieldWidth = 5;m("Something's wrong with that width number, so I reset it to 5.") end
	if fieldMines == nil then fieldMines = 5;m("Something's wrong with that mine number, so I reset it to 5.") end

	if fieldHeight < 2 then fieldHeight = 2;m("The minimum height for the board is 2.") end
	if fieldWidth < 2 then fieldWidth = 2;m("The minimum width for the board is 2.") end

	if fieldHeight > 20 then fieldHeight = 20;m("The maximum height for the board is 20.") end
	if fieldWidth > 30 then fieldWidth = 30;m("The maximum width for the board is 30.") end

	ms.fieldData.height = fieldHeight
	ms.fieldData.width = fieldWidth

	if fieldMines < 1 then fieldMines = 1;m("Why would you want a minefield with less than 1 mine? (Reset to 1)") end
	if fieldMines > (fieldWidth * fieldHeight) - 1 then fieldMines = (fieldWidth * fieldHeight) - 1;m("The maximum amount of mines for a board of this size is "..((fieldWidth * fieldHeight) - 1)..".") end
	ms.fieldData.mines = fieldMines -- Never exceed tile amount - 1

	local nt = {}
	for curY = 1,ms.fieldData.height do
	for curX = 1,ms.fieldData.width do
		local a = ms.fList[curY][curX]
		table.insert(nt, a)
		a.status = "covered"
		a.minesAround = 0
	end
	end

	for i = 1,ms.fieldData.mines do
		local a = table.remove(nt, P_RandomRange(1, #nt))
		a.contents = "mine"
	end

	ms.fieldData.heightFrac = ms.fieldData.height*128*FRACUNIT
	ms.fieldData.widthFrac = ms.fieldData.width*128*FRACUNIT

	ms.fieldData.noFirstTileDeath = tonumber(fieldNoFirstTileDeath) ~= nil and tonumber(fieldNoFirstTileDeath) or 1

end
end

local function floodUncover(x, y)
--print("Checking for floodUncover in X"..x.." Y"..y)
if ms.fList[y][x].status == "covered" then
	--print("Covered! Executing floodUncover in X"..x.." Y"..y)
	if gY(y)
	and gX(x)
	and ms.fList[y][x].status == "covered"
	then ms.fList[y][x].status = "uncovered" end
	-- First, uncover this field

	--print("Mines around this cell: "..ms.fList[y][x].minesAround)
	if ms.fList[y][x].minesAround == 0 and ms.fList[y][x].contents ~= "mine" then -- Did this cell have any mines around (and is not a mine)?
		-- No? Alright, uncover those around this one!

		for yFor = -1,1 do
		for xFor = -1,1 do
			if not (yFor == 0 and xFor == 0) then
				if gY(y+yFor)
				and gX(x+xFor)
				and ms.fList[y+yFor][x+xFor].status == "covered"
				then floodUncover(x+xFor, y+yFor) end -- Do the same with this cell
			end
		end
		end

	end
else
	--print("Not executing floodUncover in X"..x.." Y"..y.." - Field not in covered status")
end -- did it run fam
end

COM_AddCommand("ms_newboard", function(p, fieldHeight, fieldWidth, fieldMines)
	local mh = mapheaderinfo[gamemap]
	if fieldMines ~= nil and server and mh.minesweeper and mh.customboard == "1" then
		newMinefield(fieldHeight, fieldWidth, fieldMines, fieldNoFirstTileDeath)
	else
		if fieldMines == nil then
			print("Not enough arguments specified. Enter <height> <width> <mines>.")
		elseif not server then
			print("Error: Minesweeper is unable to run in a dedicated server! (Nor in the title screen)")
		elseif not mh.minesweeper then
			print("Can't create board: Map is not a minesweeper field.")
		elseif not mh.customboard then
			print("Can't create board: Map doesn't allow custom boards.")
		else
			//wuss BoBBin jimBo
			print("Error: Unknown error, report ASAP, send help, call 911, inform FBI, capture &")
		end
	end
end, 1)

addHook("NetVars", function(n)
	ms = n(ms)
end)

addHook("MapLoad", function(mapto)
	local header = mapheaderinfo[mapto]
	if leveltime == 0 and header.minesweeper == "1" then
		resetMinefield()
	end
end)

addHook("MobjThinker", function(pm)
if mapheaderinfo[gamemap].minesweeper == "1" then
	if pm and pm.valid then
		local player = pm.player
		if not player.awayviewmobj then player.awayviewmobj = P_SpawnMobj(pm.x,pm.y,pm.z,MT_ALTVIEWMAN) end
		if player.awayviewmobj and player.playerstate ~= PST_DEAD then
			local k = player.awayviewmobj
			player.awayviewtics = 666*TICRATE
			player.awayviewaiming = -ANG30
			local SPD = -128-64-16
			local xSPD = cos(pm.angle)*SPD
			local ySPD = sin(pm.angle)*SPD

			local function normalizeX(x)
				local s = ms.fieldData.widthFrac or 0
				--print(s/FRACUNIT)
				if x > s then x = s end
				if x < 0 then x = 0 end
				return x
			end
			local function normalizeY(y)
				local s = ms.fieldData.heightFrac or 0
				local k = 20*128*FRACUNIT
				--print(s/FRACUNIT)
				if y > k then y = k end
				if y < k-s then y = k-s end
				return y
			end

			P_MoveOrigin(k, normalizeX(pm.x+xSPD), normalizeY(pm.y+ySPD), pm.z+160*FRACUNIT)
			k.angle = pm.angle
			--P_InstaThrust(m, p.angle, 32*FRACUNIT)
		end
	end
end
end, MT_PLAYER)



addHook("SpinSpecial", function(p)
	if mapheaderinfo[gamemap].minesweeper == "1" and ms.fieldData.inGame and not (p.pflags & PF_USEDOWN) then
	--print("SpinSpecial")
	local a = p.mo.subsector.sector.tag
	a = ms.fListRef[a]

	if ms.fieldData.noFirstTileDeath and ms.fieldData.clicks == 0 then -- Prevent first tile death
		--print("First tile advanced check")
		if a.contents == "mine" and a.status ~= "flagged" then
			--print("FIRST TILE DEATH!")
			local noneTiles = {}
			for curY = 1,ms.fieldData.height do
			for curX = 1,ms.fieldData.width do
				local b = ms.fList[curY][curX]
				if b.contents == "none" then table.insert(noneTiles, b) end
			end
			end
			a.contents = "none"

			local c = P_RandomRange(1, #noneTiles)
			local d = table.remove(noneTiles, c)
			d.contents = "mine"
		end
	end

	floodUncover(a.myX, a.myY)
	if a.contents == "mine" and a.status ~= "flagged" then
		a.status = "exploded"
		--a.sector.floorpic = "TILEMINB"
		ms.fieldData.gameLost = 1
		ms.fieldData.exploded = 1
	end
	ms.fieldData.clicks = $ + 1
	if ms.fieldData.turnTimeLimit then
		ms.fieldData.runningTurnTimeLimit = ms.fieldData.turnTimeLimit
	end
	--if a.status == "covered" then a.status = "uncovered" end
	return true
	end
end)

addHook("JumpSpecial", function(p)
	if mapheaderinfo[gamemap].minesweeper == "1" and ms.fieldData.inGame and not (p.pflags & PF_JUMPDOWN) then
	--print("JumpSpecial")
	local a = p.mo.subsector.sector.tag
	a = ms.fListRef[a]
	if a.status == "covered" then a.status = "flagged" elseif a.status == "flagged" then a.status = "covered" end
	return true
	end
end)

addHook("ThinkFrame", function()
if leveltime > 5 and mapheaderinfo[gamemap].minesweeper == "1" then
if (not mapheaderinfo[gamemap].customboard or mapheaderinfo[gamemap].customboard == "0")
and not ms.fieldData.inGame and not ms.fieldData.gameEnded then
	local mh = mapheaderinfo[gamemap]
	newMinefield(mh.msheight, mh.mswidth, mh.msmines, 1)
end

for player in players.iterate do //synch timer with actual timer
	player.realtime = ms.fieldData.timeElapsed
end

if ms.fieldData.inGame then
	--[[
	ms.fieldData.inGame = 0
	ms.fieldData.gameEnded = 0
	ms.fieldData.timeElapsedSinceEnd = 0
	ms.fieldData.gameLost = 0
	ms.fieldData.gameWon = 0
	]]

	if ms.fieldData.gameWon	or ms.fieldData.gameLost
	then ms.fieldData.gameEnded = 1 end

	if ms.fieldData.gameEnded then ms.fieldData.inGame = 0 end

	ms.fieldData.numCoveredTiles = 0
	ms.fieldData.numFlaggedTiles = 0
	local function getMinesAround(a)
		local temp1 = 0
		for yFor = -1,1 do
		for xFor = -1,1 do
			if not (yFor == 0 and xFor == 0) then
				if gY(a.myY+yFor)
				and gX(a.myX+xFor)
				and ms.fList[a.myY+yFor][a.myX+xFor].contents == "mine"
				then temp1 = $ + 1 end
			end
		end
		end
		return temp1
	end

	for curY = 1,ms.fieldData.height do
	for curX = 1,ms.fieldData.width do
		local a = ms.fList[curY][curX]

		local temp1 = getMinesAround(a)
		a.minesAround = temp1 -- Set our "mines around" value

		if a.status == "covered" and ms.fieldData.gameLost then
			a.status = "uncovered"
		end

		if a.contents == "none" then
			ms.fieldData.numNoneTiles = $ + 1
		end -- This must execute first so we can then use the next if to change texture

		if a.status == "uncovered" then
			a.sector.floorheight = 0
			a.sector.ceilingheight = 2048*FRACUNIT
			if a.contents == "none" then
				a.sector.floorpic = "TILE"..tostring(a.minesAround)
			end -- End if the tile is just an empty tile
			if a.contents == "mine" then
				a.sector.floorpic = "TILEMINE"
			end
		end

		if a.status == "covered" then
			a.sector.floorpic = "TILECLSD"
			ms.fieldData.numCoveredTiles = $ + 1
		end
		if a.status == "flagged" then
			a.sector.floorpic = "TILEFLAG"
			ms.fieldData.numFlaggedTiles = $ + 1
			if ms.fieldData.gameLost then
				if a.contents == "mine" then --[[There was a mine]] end
				if a.contents == "none" then a.sector.floorpic = "TILEFLAB" end
			end
		end
		if a.status == "exploded" then
			a.sector.floorpic = "TILEMINB"
		end

		--if a.status == "wall" then
		--	a.sector.floorheight = 128*FRACUNIT
		--	--a.sector.ceilingheight = 128*FRACUNIT
		--end
	end
	end -- End grid iterate

	local function makeWall(a)
		a.sector.floorheight = 128*FRACUNIT
		a.sector.ceilingheight = 128*FRACUNIT
		a.status = "wall"
		a.sector.floorpic = "GREYFLR"
	end

	if ms.fieldData.width < 30 then
	for curY = 1,ms.fieldData.height do
		local a = ms.fList[curY][ms.fieldData.width+1]
		makeWall(a)
	end
	end
	if ms.fieldData.height < 20 then
	for curX = 1,ms.fieldData.width do
		local a = ms.fList[ms.fieldData.height+1][curX]
		makeWall(a)
	end
	end

	--print("Non-mine tiles left "..ms.fieldData.numNoneTiles)

	--print("Running!")
	if ms.fieldData.clicks > 0 then
		if ms.fieldData.timeElapsed % 35 == 0 then S_StartSound(nil, sfx_msbeep) end
		ms.fieldData.timeElapsed = $ + 1
		if ms.fieldData.timeLimit and ms.fieldData.runningTimeLimit > 0 then ms.fieldData.runningTimeLimit = $ - 1 end
		if ms.fieldData.turnTimeLimit and ms.fieldData.runningTurnTimeLimit > 0 then ms.fieldData.runningTurnTimeLimit = $ - 1 end
	end
	if ms.fieldData.clicks == 0 then
		if ms.fieldData.timeLimit then ms.fieldData.runningTimeLimit = ms.fieldData.timeLimit end
		if ms.fieldData.turnTimeLimit then ms.fieldData.runningTurnTimeLimit = ms.fieldData.turnTimeLimit end
	end

	if (ms.fieldData.numCoveredTiles + ms.fieldData.numFlaggedTiles) == ms.fieldData.mines and not ms.fieldData.exploded and not ms.fieldData.gameLost then ms.fieldData.gameWon = 1 end

	sugoi.HUDShow("score", false)
	sugoi.HUDShow("time", false)
	sugoi.HUDShow("rings", false)
	sugoi.HUDShow("lives", false)
elseif not ms.fieldData.inGame and ms.fieldData.gameEnded then
	ms.fieldData.timeElapsedSinceEnd = $ + 1
	-- play some sounds while we're at it
	if ms.fieldData.timeElapsedSinceEnd == 1 then
		local q = mapheaderinfo[gamemap]
		if ms.fieldData.exploded then ms.fieldData.gameWon = 0 end
		if ms.fieldData.gameWon and not ms.fieldData.exploded then
			--print("YOU WON YAY")
			S_StartSound(nil, sfx_mswin)
			P_StartQuake(2*FRACUNIT, 35)
			if q.endfof == "1" then
				ms.winFOF.ceilingheight = 2048
				if q.msemmy == "1" then
					sugoi.AwardEmerald(false);
				end
			end
		end
		if ms.fieldData.gameLost then
			--print("YOU LOSE CYKA BLYAT")
			S_StartSound(nil, sfx_msboom)
			P_StartQuake(25*FRACUNIT, 22)
			if modeattacking then
				for player in players.iterate do
				if player and player.valid and player.mo and player.mo.valid then
					P_DamageMobj(player.mo, nil, nil, 10000)
				end
				end
			end
			if q.endfof == "1" then ms.loseFOF.ceilingheight = 2048 end
		end
	end
	sugoi.HUDShow("score", true)
	sugoi.HUDShow("time", true)
	sugoi.HUDShow("rings", true)
	sugoi.HUDShow("lives", true)
end

end -- in map
end)

hud.add(function(v, p)
if mapheaderinfo[gamemap].minesweeper == "1" then
	local header = mapheaderinfo[gamemap]
	if (ms.fieldData.timeElapsed ~= nil) -- Salt: aaaaa
		v.drawString(12, 60, string.format("\130T - \128%03d \130-", ((ms.fieldData.timeElapsed+34)/TICRATE)), V_SNAPTOLEFT|V_MONOSPACE)
	end
	-- Start at 1 like Minesweeper!
	if ms.fieldData.inGame then
		v.drawString(12, 68, string.format("\130M \128%3d\130/\128%3d", ms.fieldData.mines, ms.fieldData.numFlaggedTiles), V_SNAPTOLEFT|V_MONOSPACE)

		if ms.fieldData.timeLimit then
			v.drawString(4, 44, string.format("\133TL - \128%03d \133-", ((ms.fieldData.runningTimeLimit)/TICRATE)), V_SNAPTOLEFT|V_MONOSPACE)
		end
		if ms.fieldData.turnTimeLimit then
			v.drawString(4, 52, string.format("\133TT - \128%03d \133-", ((ms.fieldData.runningTurnTimeLimit)/TICRATE)), V_SNAPTOLEFT|V_MONOSPACE)
		else
            v.drawString(12, 84, "SPIN - Dig", V_SNAPTOLEFT|V_BLUEMAP|V_50TRANS|V_ALLOWLOWERCASE|V_MONOSPACE, "small")
            v.drawString(12, 88, "JUMP - Flag", V_SNAPTOLEFT|V_BLUEMAP|V_50TRANS|V_ALLOWLOWERCASE|V_MONOSPACE, "small")
        end
	end
	if not ms.fieldData.inGame then
		if header.customboard == "1" then v.drawString(12, 96, "Use ms_newboard to make a new board", V_SNAPTOLEFT|V_BLUEMAP|V_ALLOWLOWERCASE|V_MONOSPACE, "small") end
	end
	if ms.fieldData.gameEnded then
		if ms.fieldData.gameWon then
			v.drawString(12, 68, "Clear!", V_SNAPTOLEFT|V_GREENMAP|V_MONOSPACE)
		end
		if ms.fieldData.gameLost then
			v.drawString(12, 68, ms.fieldData.obituary, V_SNAPTOLEFT|V_REDMAP|V_MONOSPACE)
		end
	end
end
end, "game")
