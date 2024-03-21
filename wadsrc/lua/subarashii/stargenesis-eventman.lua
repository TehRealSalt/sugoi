--=================================================================
-- EventMan (event index) was made by me reinamoon (chi.miru)
-- do not use my script without permission from me
--
-- extra assist: Nev3r
-- reinamoon 2016/2017
--=================================================================

--Index:
-- .EVENTMAN SETUP
-- .EVENTMAN BACK-END
-- .MISC FUNCTIONS
-- .EVENTMAN ACTION LIBRARY







------------------------------------------------------------------------------------
-- EVENTMAN SETUP
------------------------------------------------------------------------------------

-- Internal functoins

--Attempts to clone a table and returns it.
table.clone = function(source)
	--local debug = true
	local target = {}
	for key, val in pairs(source) do
		if debug then
			CONS_Printf(players[0], "Copying "+key+"; "+val)
		end
		if type(val) == "table" then
			target[key] = table.clone(val)
		else
			target[key] = val
		end
	end
	return target
end

rawset(_G, "ternary", function( cond , T , F )
    if cond then return T else return F end
end)

rawset(_G, "P_RandomChoice", function(choices)
	local RandomKey = P_RandomRange(1, #choices)
	--print("Key: "..choices[RandomKey])
	--print("Entry: "..RandomKey)
	if type(choices[RandomKey]) == "function" then
		choices[RandomKey]()
	else
		return choices[RandomKey]
	end
end)


-- Attempts to sort keys
local function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

-- EventMan Hud
rawset(_G, "EVM_HUD", {})


-- Index stores events functions and information
-- Exposed globally (unless problems arise)
rawset(_G, "eventIndex", {})
rawset(_G, "events", {})


-- Variable used to call functions or variables within
-- Exposed globally
rawset(_G, "event", {})

-- Set up the structure beforehand (this may fail?)
addHook("MapLoad", do
	for player in players.iterate do
		-- Player draw renders
		player.renders = {}
		-- Player textStorage for use database
		player.rTextStore = {}
		--player.coroutine = {}
		-- Player textStorage default index
		player.textStore = {
			lineTimer = 0,
			speaker = " ",
			text = " ",
			player = player,
			useTextConfig = false,
			textConfig = {},
			textOptions = {auto = false,
							autotime = 3*TICRATE,
							sPos = 0, -- StartPosition
							speed = 1,
							slowspeed = 1,
							ticksfx = sfx_none,
							selection = nil,
							selectNum = 1,
							selectId = nil
							},
		}
		player.hudOptions = {
								disabled = false,
								hidden = false,
								hpHudHidden = false,
								hideValue = 0,
								widescreen = {enabled = false, wideframe = 0},
								wipe = {set = false, pic = "", dest = 10, start = 10, Time = 1, flash = false}
							}
		player.camprocess = nil;
	end
end)

-- Register a new event to the index
event.newevent = function(eventName, coroutineFunction)

	-- Store our content here
	local ret = {lines = {}}

	-- Shove coroutine into the index
	ret.coroutine = coroutineFunction

	-- Index cutevent and return it
	eventIndex[eventName] = ret
	return ret

end

-- Begin a event or function from the index
event.beginEvent = function(eventName, player, storedLocation, ret)

	-- If it's a name string we can search the index
	if type(eventName) == "string" then

		-- warning: Name isn't in the Index
		assert(eventIndex[eventName], "Event (" .. eventName .. ") does not exist.")

		-- Run the function
		--TASK:Run(function() eventIndex[eventName].coroutine(player) end)

		if ret then
			return function(player) eventIndex[eventName].coroutine(player) end
		else
			-- Store in specific area
			if type(storedLocation) == "userdata" or type(storedLocation) == "table" then
				--store[eventName] = TASK:Run(function() eventIndex[eventName].coroutine(player) end)
				storedLocation[eventName] = TASK:Run(function() eventIndex[eventName].coroutine(player) end)
				--print("yes")
			else
				TASK:Run(function() eventIndex[eventName].coroutine(player) end)
			end
		end
	-- If it doesn't have a name, we can
	-- run one right off the bat
	elseif type(eventName) == "function" then
		TASK:Run(eventName)
	end
end





-- Call rendering into the drawing layer
--local renders = {}
rawset(_G, "renders", {}) -- global safe some day?


-- render
-- ---
-- @v - hud hook v
-- @n - name
-- @func - function
-- I guess this would be considered a global render?
-- it creates an entry in the render table to be used in
-- the main draw. the second erases it out of the table
local function render(v, n, func)
	renders[n] = function ( v )
		func(v)
	end
	--TODO: expose c to the draw
end

local function eraseRender(n)
	renders[n] = nil
end
-- the same as above, except creates one in the player struct
-- for players. the second does the same task as the above
local function playerRender(v, n, player, func)
	if (player) then
			player.renders[n] = function ( v )
			func(v)
		end
	end
end

local function erasePlayerRender(n, player)
	if (player) then
		player.renders[n] = nil
	end
end

-- Disable Player Movement (with turn rotation using forceStrafe)
-- @player - userdata player
-- @forceStrafe - modify forceStrafe for turning disable
local function DisablePlayerMovement(player, forceStrafe)
	if (player and player.valid) then
		if (forceStrafe) then
			player.pflags = $1|PF_FORCESTRAFE
		end
		player.powers[pw_nocontrol] = 1
		player.thrustfactor = 0
		player.jumpfactor = 0
		player.charability2 = 0
	end
end

-- Enable Player Movement (with turn rotation using unforceStrafe)
local function EnablePlayerMovement(player, unforceStrafe)
	if (player and player.valid) then
		if (unforceStrafe) then
			player.pflags = $1 & ~PF_FORCESTRAFE
		end
		player.powers[pw_nocontrol] = 0
		player.thrustfactor = skins[player.mo.skin].thrustfactor
		player.jumpfactor = skins[player.mo.skin].jumpfactor
		player.charability2 = skins[player.mo.skin].ability2
	end
end



-- Player text speech calls and functions
-- (store text and things in the player renders)

-- SetTextConfig
-- ---
-- @n - name
-- @player - userdata player
-- @... - table config data
-- Set the text config (options or whatever) for the render used
local function SetTextConfig(n, player, ...)
	-- Temporarily clone the storage (or nothing even happens)
	player.rTextStore[n] = table.clone(player.textStore)
	player.rTextStore[n].useTextConfig = true
	player.rTextStore[n].textConfig = unpack({...})
end


-- This handles the player renders loop for coroutines
-- (can also be used in a couroutine instead of being in main)
local function handlePRTextLoop(n, player, speaker, text, useTextConfig)
	if (player and player.valid) then

		-- Make a copy of the original text storage to reset everything
		-- use custom text config options if wanted
		if (useTextConfig == true) then
			player.rTextStore[n].textOptions = table.clone(player.rTextStore[n].textConfig)
		else
			player.rTextStore[n] = table.clone(player.textStore)
		end

		-- Reset Timer, set strings (and options when made avail)
		player.rTextStore[n].lineTimer = 0
		player.rTextStore[n].speaker = speaker
		player.rTextStore[n].text = text
		--player.rTextStore[n].textOptions = {}

		-- Shortcut keywords
		local cSpeaker = player.rTextStore[n].speaker
		local cText = player.rTextStore[n].text
		local tOptions = player.rTextStore[n].textOptions

		-- Set up options defaults
		tOptions.auto = tOptions.auto or false -- False by default
		tOptions.autotime = tOptions.autotime or 3*TICRATE -- Timesecs 3 by defailt
		tOptions.speed = tOptions.speed or 2 -- 1 by default
		tOptions.sPos = tOptions.sPos or 0	-- 0 by default
		tOptions.ticksfx = tOptions.ticksfx or sfx_none
		tOptions.selectNum = tOptions.selectNum or 1	-- 0 by default

		-- A short local function to clear text and speaker
		-- (is this even allowed inside here?)
		-- (will this error later?)
		local clearText = function()
			player.rTextStore[n].speaker = nil
			player.rTextStore[n].text = nil
		end

		-- Start our loop to stay in (while should work..)
		while true

			--Shortcut lineTimer
			local lineTimer = player.rTextStore[n].lineTimer

			-- (alternate speed formula)
			local rSpeed = lineTimer/tOptions.speed + tOptions.sPos

			-- Sound ticker (can be set in options)
			if (tOptions.ticksfx) then
				if (lineTimer + tOptions.sPos/tOptions.speed <= cText:len()) and not (cText:sub(0,lineTimer + tOptions.sPos/tOptions.speed):byte() == 0)
				and (lineTimer % tOptions.speed == 0) then
					S_StartSound(nil, tOptions.ticksfx or sfx_none) -- (7-26-2017: used to have player, unsure if problematic without)
				end
				--if cText and (rSpeed <= cText:len()) and not (cText:sub(0, rSpeed):byte() == 0)
				--and (lineTimer % tOptions.speed == 0) then
				--	S_StartSound(nil, sfx_thok, player)
				--end
			end

			if (lineTimer >= (cText:len()-tOptions.sPos)*tOptions.speed) then
				-- When automatic is turned on, break the loop after defined time
				if (tOptions.auto and lineTimer >= (cText:len()-tOptions.sPos)*tOptions.speed + tOptions.autotime) then
					clearText()
					break
				-- otherwise we wait for button input
				elseif not tOptions.auto and player.cmd.buttons & BT_JUMP then--(player.buttonstate[BT_JUMP] == 1) then
					clearText()
					break
				-- or we can wait without auto when movement is static
				end
			end

			-- Increment timer
			-- TODO: Slower text speeds
			player.rTextStore[n].lineTimer = player.rTextStore[n].lineTimer + 1*tOptions.speed

			--print("inside pr text loop")
			waitSeconds(0)
		end
	end
end

-- This handles the player renders drawings for text
-- by drawing it out of its own render tables
local function handlePRTextDrawing(v, n, player)

	if (player and player.rTextStore[n]) then

		--TODO: box setting
		-- Shortcut keywords
		local cSpeaker = player.rTextStore[n].speaker
		--TODO: text effects (eg. $player, etc)
		local cText = player.rTextStore[n].text
		local lineTimer = player.rTextStore[n].lineTimer
		local tOptions = player.rTextStore[n].textOptions
		-- Shortcut linetimer feed
		local strCut = player.rTextStore[n].lineTimer + tOptions.sPos/tOptions.speed


		-- Handle speaker and text entries
		if (player.rTextStore[n].text) then

			-- TODO box fade
			-- TODO custom graphic, scaling
			--Draw the box (or entry graphic)
			v.drawScaled(0, 160*FRACUNIT, FRACUNIT/2, v.cachePatch("DLGWIN4"), V_50TRANS) --V_60TRANS

			--Draw the items needed
			if (player.rTextStore[n].speaker) then
				v.drawString(20, 158, cSpeaker, V_ALLOWLOWERCASE|V_MONOSPACE, "left")
			end
			v.drawString( 8, 168, cText:sub(0, strCut):gsub("%z+", ""), V_ALLOWLOWERCASE, "left")
		end

	end
end



-- Drawing Layer: it scans the render tables
-- and draws from their functions
--[[
local function corouHUDLayer(v, player, cam)

	-- To save memory (probably), check for renders when they
	-- exist instead of all the time
	if (player and player.renders) then
		-- Scan renders for any drawing
		for k, fun in pairs(player.renders) do
			if type(fun) == "function" then
				fun( v )
			end
		end
	end

	-- Scan renders for any drawing
	for k, fun in pairs(renders) do
		if type(fun) == "function" then
			fun( v )
		end
	end

end
hud.add(corouHUDLayer, "game")]]

local client = nil

local function clientplayer(v, stplyr, cam)
	client = stplyr
end
hud.add(clientplayer, "game")

-- Drawing Layer: it scans the render tables
-- and draws from their functions
EVM_HUD["evm_HUDlayer"] = {z_index = 50, func =
function(v, player, cam)
	-- To save memory (probably), check for renders when they
	-- exist instead of all the time
	if (player and player.renders) then
		-- Scan renders for any drawing
		for k, fun in pairs(player.renders) do
			if type(fun) == "function" then
				fun( v )
			end
		end
	end

	-- Scan renders for any drawing
	for k, fun in pairs(renders) do
		if type(fun) == "function" then
			fun( v )
		end
	end
end
}


EVM_HUD["widescreen"] = {z_index = -1, func =
function(v, player, cam)
	local scrwidth = v.width() / v.dupx()
	local scrheight = v.height() / v.dupy()
	--local patch = v.cachePatch("PATCH")
	--v.draw(0, 0, patch, V_SNAPTOTOP|V_SNAPTOLEFT) -- draws at top left of the screen
	--v.draw(scrwidth - patch.width, 0, patch, V_SNAPTOTOP|V_SNAPTOLEFT) -- draws at top right of the screen
	--v.draw(0, scrheight - patch.height, patch, V_SNAPTOTOP|V_SNAPTOLEFT) -- draws at bottom left of the screen
	--v.draw(scrwidth - patch.width, scrheight - patch.height, patch, V_SNAPTOTOP|V_SNAPTOLEFT) -- draws at bottom right of the screen
	--print(v.width().."x"..v.height())
	if (player.hudOptions and player.hudOptions.widescreen.enabled == true) then
		if leveltime % 3 == 0 then
			player.hudOptions.widescreen.wideframe = min($1+1, 8)
		end
		--v.drawScaled(scrwidth/2*FRACUNIT, scrheight/2*FRACUNIT, FRACUNIT/2, v.cachePatch("CINEFWD"..player.hudOptions.widescreen.wideframe), 0)
		v.drawScaled(0, 0*FRACUNIT, FRACUNIT/2, v.cachePatch("CINEFWD"..player.hudOptions.widescreen.wideframe), V_SNAPTOTOP|V_SNAPTOLEFT)
	elseif (player.hudOptions.widescreen.enabled == false) and player.hudOptions.widescreen.wideframe > 0 then
		if leveltime % 2 == 0 then
			player.hudOptions.widescreen.wideframe = max($1-1, 0)
		end
		v.drawScaled(0, 0*FRACUNIT, FRACUNIT/2, v.cachePatch("CINEREV"..player.hudOptions.widescreen.wideframe), V_SNAPTOTOP|V_SNAPTOLEFT)
	end
end
}

EVM_HUD["wipefade"] = {z_index = -1, func =
function(v, player, cam)
	if (player.hudOptions.wipe and player.hudOptions.wipe.dest < 10) then
		local wipe = player.hudOptions.wipe
		v.drawScaled(0, 0, 14*FRACUNIT, v.cachePatch((wipe.pic) or "WFILL"), wipe.dest<<V_ALPHASHIFT)
		--print(wipe.dest)
	end
end
}







-- EXPERIMENTAL EVENTMAN HUD
local function evm_zhud(v, stplyr, cam)
	if (mapheaderinfo[gamemap].starzone or mapheaderinfo[gamemap].starzonecut) then
		--for k,huditem in spairs(EVM_HUD, function(t,a,b) return t[b].z_index < t[a].z_index end) do -- desc
		for k,huditem in spairs(EVM_HUD, function(t,a,b) return t[a].z_index < t[b].z_index end) do -- asc
			-- Do not show indexes of -1
			--if (huditem.z_index == -1) then return end
			--if (huditem.func == nil) then return end
			if not (huditem.z_index == -1) or (huditem.func == nil) then huditem.func(v, stplyr, cam) end
			-- Run hud functions in the table
			--huditem.func(v, stplyr, cam)
		end
	end
end
hud.add(evm_zhud, "game")

-- SCORES IS NOT F3, DO NOT TREAT IT LIKE ONE
local function evm_zhud_client_scores(v, stplyr, cam)
	if (mapheaderinfo[gamemap].starzone or mapheaderinfo[gamemap].starzonecut) then
		--for k,huditem in spairs(EVM_HUD, function(t,a,b) return t[b].z_index < t[a].z_index end) do -- desc
		for k,huditem in spairs(EVM_HUD, function(t,a,b) return t[a].z_index < t[b].z_index end) do -- asc
			-- Do not show indexes of -1
			--if (huditem.z_index == -1) then return end
			--if (huditem.func == nil) then return end
			if not (huditem.z_index == -1) or (huditem.func == nil) then huditem.func(v, client, cam) end
			-- Run hud functions in the table
			--huditem.func(v, stplyr, cam)
		end
	end
end
hud.add(evm_zhud_client_scores, "scores")







-- works like renders and playerrenders, but used for adding
-- content into the main game loop through "tagging" it inside
-- of the loop
rawset(_G, "srb2_FunctionTags", {})

local function setFTag(n, func)
	srb2_FunctionTags[n] = function ( )
		func()
	end
end

local function removeFTag(n)
	srb2_FunctionTags[n] = nil
end

addHook("ThinkFrame", do
	for k, fun in pairs(srb2_FunctionTags) do
		if type(fun) == "function" then
			fun( v )
		end
	end
end)




--____________________________________________________
-- External use functions
--____________________________________________________


-- Patch together all three functions to pull together a
-- speaking function (can be used seperately)
-- arg [v]: hud v
-- arg [n]: renders name to create/apply to
-- arg [speaker]: the speaker of the text if available
-- arg [text]: the text to be printed, nil if none
-- arg [useTextConfig]: allows SetTextConfig to apply an options list
local function Speak(v, n, player, speaker, text, useTextConfig)
	if (player) then
		playerRender(v, n, player, function(v)
			handlePRTextDrawing(v, n, player) end)
		handlePRTextLoop(n, player, speaker, text, useTextConfig)
	else
		for p in players.iterate do
			playerRender(v, n, p, function(v)
			handlePRTextDrawing(v, n, p) end)
		end
		handlePRTextLoop(n, server, speaker, text, useTextConfig)
	end
end






local function netgameCamOverride(player, serv, args)
	if (args.enabled == true) then
		CAMERA:override(player, true)
		player.awayviewmobj = serv.mo.cam
		player.awayviewtics = 65535*TICRATE--server.awayviewtics
		player.awayviewaiming = serv.awayviewaiming
	else
		CAMERA:override(player, false)
		player.awayviewmobj = args.awayviewmobj or nil
		player.awayviewtics = 2
		player.awayviewaiming = 0
	end
end

local function syncNetgameText(user, origin)
	user.rTextStore = origin.rTextStore
end

local function animationTimerDisplay(v, user)
	local Time = 0
	playerRender(v, "atd_event", server, function(v)
		Time = $1+1
		local Hours = string.format("%02d", G_TicsToHours(Time))
		local Minutes = string.format("%02d", G_TicsToMinutes(Time))
		local Seconds = string.format("%02d", G_TicsToSeconds(Time))
		local Centiseconds = string.format("%02d", G_TicsToCentiseconds(Time))
		local Milliseconds = string.format("%02d", G_TicsToMilliseconds(Time))
		v.drawString(320/2,5, Hours..":"..Minutes..":"..Seconds..":"..Centiseconds, V_ALLOWLOWERCASE|V_MONOSPACE, "center")
	end)
end

local function end_animationTimerDisplay()
	server.renders["atd_event"] = nil
end

local function forcePlayerReborn(player)
	if (netgame) then
		if (player.playerstate == PST_DEAD) then
			if player.lives > 0 then
				player.playerstate = PST_REBORN
			end
		end
	end
end



----------------------------------------------
-- Scan MAINCFG mapheaderinfo
local hud_is_off = false
addHook("MapChange", function(gamemap)

	for player in players.iterate

		-- Start Map as a fake nondrawn scene on map change
		if mapheaderinfo[gamemap].startempty
			--SCREEN:SetFill(player, 0, "BLK")
		else
			--SCREEN:SetFill(player, 10, "BLK")
		end

		-- Do not clear (public) renders on map change
		if not mapheaderinfo[gamemap].keepRenders_onchange
			renders = {}
		end

		-- Do not clear (public) tags on map change
		--if not mapheaderinfo[gamemap].keepFunctionTags_onchange
		if srb2_FunctionTags["n_musicCheck"] then
			srb2_FunctionTags["n_musicCheck"] = nil
		end
			srb2_FunctionTags = {}

		--end

		-- Disable the hud on map change
		if mapheaderinfo[gamemap].disablehud_onchange
			sugoi.HUDShow("score", false)
			sugoi.HUDShow("time", false)
			sugoi.HUDShow("rings", false)
			sugoi.HUDShow("lives", false)
			-- Failsafe check
			hud_is_off = true
		else
			if (hud_is_off == true or nil) then
				sugoi.HUDShow("score", true)
				sugoi.HUDShow("time", true)
				sugoi.HUDShow("rings", true)
				sugoi.HUDShow("lives", true)
				hud_is_off = false
			end
		end

		clearProcesses()
		--EnablePlayerMovement(player, true)
	end
end)

-- Scan and set on map load
addHook("MapLoad", function(gamemap)

	clearProcesses()
	for player in players.iterate

		--[[for k,v in ipairs(eventIndex) do
			TASK:Destroy(eventIndex[k].coroutine)
		end]]

		-- Start Map as a fake nondrawn scene on map load
		if mapheaderinfo[gamemap].startempty_onload
			--SCREEN:SetFill(player, 0, "BLK")
		else
			--SCREEN:SetFill(player, 10, "BLK")
		end

		--if not mapheaderinfo[gamemap].keepFunctionTags_onload
		if srb2_FunctionTags["n_musicCheck"] then
			srb2_FunctionTags["n_musicCheck"] = nil
		end
			srb2_FunctionTags = {}
		--end

		-- Begin an event on map load from the dictionary
		if (mapheaderinfo[gamemap].loadscene or mapheaderinfo[gamemap].loadEvent) then
			event.beginEvent(mapheaderinfo[gamemap].loadscene:gsub("%z", ""), player)
		end

		-- Disable the hud on load
		if mapheaderinfo[gamemap].disablehud_onload
			sugoi.HUDShow("score", false)
			sugoi.HUDShow("time", false)
			sugoi.HUDShow("rings", false)
			sugoi.HUDShow("lives", false)
			-- Failsafe check
			hud_is_off = true
		else
			if (hud_is_off == true or nil) then
				sugoi.HUDShow("score", true)
				sugoi.HUDShow("time", true)
				sugoi.HUDShow("rings", true)
				sugoi.HUDShow("lives", true)
				hud_is_off = false
			end
		end
	end

	if (mapheaderinfo[gamemap].globalscene or mapheaderinfo[gamemap].globalevent) then
		event.beginEvent(mapheaderinfo[gamemap].globalevent:gsub("%z", ""), server)
	end

end)

--[[
rawset(_G, "PlayerList", {})
	addHook("MobjSpawn", function(mo)
		local player = mo.player
		--if (mapheaderinfo[gamemap].starzone) then
			--if not mo.playerstate == PST_REBORN then
			table.insert(PlayerList, mo)
			--end
			--print("added object type: "..tostring(mo.type).." of "..tostring(mo))
		--end
	end, MT_PLAYER)
	addHook("MobjRemoved", function(mo)
		local player = mo.player
		--if (mapheaderinfo[gamemap].starzone) then
			if not player.deadtimer then
			for i=1, #PlayerList do
				if PlayerList[i] == mo then
					table.remove(PlayerList, i)
					break
				end
			end
			end
		--end
		--print("removed object type: "..tostring(mo.type).." of "..tostring(mo))
	end, MT_PLAYER)
addHook("MapChange", do
	PlayerList = {}
end)
addHook("PlayerJoin", function(num)
	for player in players.iterate do
		table.insert(PlayerList, player[num])
	end
end)]]
----------------------------------------------


----------------------------------------------
-- Expose
rawset(_G, "render", render)
--rawset(_G, "renderGraph", render)
--rawset(_G, "eraseGraph", eraseRender)
rawset(_G, "destroyRender", eraseRender)
rawset(_G, "playerRender", playerRender)
rawset(_G, "renderToPlayerScreen", playerRender)
rawset(_G, "erasePlayerRender", erasePlayerRender)
rawset(_G, "GetSelectionID", GetSelectionID)
rawset(_G, "GetCurrentSelection", GetCurrentSelection)
rawset(_G, "DisablePlayerMovement", DisablePlayerMovement)
rawset(_G, "EnablePlayerMovement", EnablePlayerMovement)
rawset(_G, "SetTextConfig", SetTextConfig)
--[[rawset(_G, "handlePRTextLoop", handlePRTextLoop)
rawset(_G, "handlePRTextDrawing", handlePRTextDrawing)]]
rawset(_G, "Speak", Speak)
rawset(_G, "setFTag", setFTag)
rawset(_G, "removeFTag", removeFTag)
rawset(_G, "attachLoop", setFTag)
rawset(_G, "destroyLoop", removeFTag)
rawset(_G, "netgameCamOverride", netgameCamOverride)
rawset(_G, "syncNetgameText", syncNetgameText)
rawset(_G, "start_animationTimer", animationTimerDisplay)
rawset(_G, "end_animationTimer", end_animationTimerDisplay)
rawset(_G, "forcePlayerReborn", forcePlayerReborn)
----------------------------------------------

















------------------------------------------------------------------------------------
-- EVENTMAN BACK-END
------------------------------------------------------------------------------------


-----------------------------------------------
local function verboseRun(co, ...)
	local table = {coroutine.resume(co, ...)}
	if not table[1] then
		print("\x82WARNING:\x80 " .. table[2])
	end
	return unpack(table)
end

local WAITING_ON_TIME = {}

local WAITING_ON_SIGNAL = {}

local CURRENT_TIME = 0


local function waitSeconds(seconds)

    local co = coroutine.running()

    assert(co ~= nil, "The main thread cannot wait!")

    local wakeupTime = CURRENT_TIME + seconds
	table.insert(WAITING_ON_TIME, {co, wakeupTime})

    return coroutine.yield(co)
end

rawset(_G, "waitSeconds", waitSeconds)
rawset(_G, "wait", waitSeconds)


local function killProcess(co)
    --[[local index = 1
	while index <= #WAITING_ON_TIME do
        if co == WAITING_ON_TIME[index][1] then
			table.remove(WAITING_ON_TIME, index)
			return
		else
			index = $1+1
        end
    end]]
	--local index = 1
	for i, proc in pairs(WAITING_ON_TIME) do
		if co == proc[1] then
			table.remove(WAITING_ON_TIME, i)
			--print("killed")
			return
		end
	end
	--print("didn't kill :(")
end
rawset(_G, "killProcess", killProcess)


local function wakeUpWaitingThreads(deltaTime)
    CURRENT_TIME = CURRENT_TIME + deltaTime

    local index = 1
	while index <= #WAITING_ON_TIME do
		local co, wakeupTime = unpack(WAITING_ON_TIME[index])
        if wakeupTime < CURRENT_TIME then
			table.remove(WAITING_ON_TIME, index)
			verboseRun(co)
		else
			index = $1+1
        end
    end
end

addHook("ThinkFrame", do wakeUpWaitingThreads(1) end)


local function waitSignal(signalName)
    local co = coroutine.running()
    assert(co ~= nil, "The main thread cannot wait!")

    if WAITING_ON_SIGNAL[signalStr] == nil then

        WAITING_ON_SIGNAL[signalName] = { co }
    else
        table.insert(WAITING_ON_SIGNAL[signalName], co)
    end

    return coroutine.yield()
end
rawset(_G, "waitSignal", waitSignal)
rawset(_G, "waitForSignal", waitSignal)


local function signal(signalName)
    local threads = WAITING_ON_SIGNAL[signalName]
    if threads == nil then return end

    WAITING_ON_SIGNAL[signalName] = nil
    for _, co in ipairs(threads) do
        verboseRun(co)
    end
end
rawset(_G, "signal", signal)


local function runProcess(func, ...)

    local co = coroutine.create(func)
    verboseRun(co, ...)
	return co
end
rawset(_G, "runProcess", runProcess)


local function clearProcesses()
	WAITING_ON_TIME = {}
	WAITING_ON_SIGNAL = {}
end
rawset(_G, "clearProcesses", clearProcesses)



rawset(_G, "TASK", {})

function TASK:Run(func, ...)
	local co = coroutine.create(func)
	verboseRun(co, ...)
	return co
	--return ret
end


function TASK:Regist(func, ...)
	return runProcess(func, ...)
end

function TASK:Kill(co)
	killProcess(co)
	return ret
end

function TASK:Destroy(co)
	killProcess(co)
end
-------------------------------------------













------------------------------------------------------------------------------------
-- MISC FUNCTIONS
------------------------------------------------------------------------------------

local function xyzMod(point)

	local point_x, point_y, point_z

	if (point.x%FRACUNIT == 0)
		point_x = point.x
	else
		point_x = point.x*FRACUNIT
	end

	if (point.y%FRACUNIT == 0)
		point_y = point.y
	else
		point_y = point.y*FRACUNIT
	end

	if (point.z%FRACUNIT == 0)
		point_z = point.z
	else
		point_z = point.z*FRACUNIT
	end

	return point_x, point_y, point_z
end
rawset(_G, "xyzMod", xyzMod)



rawset(_G, "FloatFixed", function(src)
	if src == nil then return nil end
	if not src:find("^-?%d+%.%d+$") then -- Not a valid number!
		--print("FAK U THIS NUMBER IS SHITE")
		if tonumber(src) then
			return tonumber(src)*FRACUNIT
		else
			return nil
		end
	end
	local decPlace = src:find("%.")
	local whole = tonumber(src:sub(1, decPlace-1))*FRACUNIT
	--print(whole)
	local dec = src:sub(decPlace+1)
	--print(dec)
	local decNumber = tonumber(dec)*FRACUNIT
	for i=1,dec:len() do
		decNumber = $1/10
	end
	if src:find("^-") then
		return whole-decNumber
	else
		return whole+decNumber
	end
end)

local function AngleToInt(value)
	local angle = AngleFixed(value)/FRACUNIT
	return angle
end
rawset(_G, "AngleToInt", AngleToInt)
-------------------------------------------

















------------------------------------------------------------------------------------
-- EVENTMAN ACTION LIBRARY
------------------------------------------------------------------------------------

-------------------------------------------
rawset(_G, "CONSOLE", {})
rawset(_G, "CHAR", {})
rawset(_G, "ACT", {})
rawset(_G, "SCREEN", {})
rawset(_G, "SOUND", {})
rawset(_G, "CAMERA", {})
rawset(_G, "OBJECT", {})

function CONSOLE:disablejoining(setting)
	if (setting == true) then
		COM_BufInsertText(server, "allowjoin 0")
		print("\x83NOTICE:\x80 server joining temporarily disabled")
	else
		COM_BufInsertText(server, "allowjoin 1")
		print("\x83NOTICE:\x80 server joining re-enabled")
	end
end

function CONSOLE:forceshowhud(player)
	-- Someone will press f3 and it won't be me, get out of here with that
	COM_BufInsertText(player, "showhud 1")
end

function CHAR:GetComponent(player, componentType)
	if (player and player.valid) then
		if (componentType == "camera")
			if (player.mo.cam) then
				return player.mo.cam
			end
		end
	end
end

rawset(_G, "loopFrames", function(mo, sprite, first, last, tics, loop)
	local cur = first
	local wait = 0
	if (mo) then
		while true do
			if mo.spranim_status == nil then break end
			if (mo and mo.valid) then
				mo.frame = cur
				mo.sprite = sprite
				wait = $1+1
				if wait >= tics then
					wait = $1-tics
					cur = $1+1
					if cur > last then
						if (type(loop) == "boolean" and loop) then
							if mo.spranim_status == nil then break end
							cur = first
						elseif (type(loop) == "number" and loop) then
							while true do
								if mo.spranim_status == nil then break end
								if first == last then
									if (wait >= loop) then
										loop = nil
										cur = last
										mo.frame = cur
										mo.sprite = sprite
										ACT:stopSprAnim(mo)
										break
									end
									mo.frame = last
								else
									if (wait >= loop) then
										loop = nil
										cur = last
										mo.frame = cur
										mo.sprite = sprite
										ACT:stopSprAnim(mo)
										break
									end
									if cur > last then
										cur = first
									end

									mo.frame = cur
									if wait % tics == 0 then cur = $1+1 end
								end
								mo.sprite = sprite
								wait = $1+1
								--print(wait..": waiting...")
								waitSeconds(0)
							end
						else
							cur = last
							ACT:stopSprAnim(mo)
							--print("no loop")
							break
						end
					end
				end
			end
			waitSeconds(0)
		end
	end
end)

function ACT:startSprAnim(mo, sprite, first, last, tics, loop, seprate, forceRestart)
	ACT:stopSprAnim(mo)

	if mo.spranimstartmarker == first and not forceRestart then return end

	mo.spranimstartmarker = first
	mo.spranim_status = 1
	if (seprate) then
		--mo.spranimprocess = runProcess(loopFrames, mo, sprite, first, last, tics, loop)
		mo.spranimprocess = TASK:Regist(function()
			loopFrames(mo, sprite, first, last, tics, loop)
		end)
	else
		loopFrames(mo, sprite, first, last, tics, loop)
	end
end

rawset(_G, "loopFrames2", function(mo, sprite2, tics, loop)
	local first = A
	local last = A
	if (sprite2 != SPR2_STND) // remove this when https://git.do.srb2.org/STJr/SRB2/-/issues/1130 is resolved
		last = skins[mo.skin].sprites[sprite2].numframes - 1
	end

	local cur = first
	local wait = 0
	if (mo) then
		while true do
			if mo.spranim_status == nil then break end
			if (mo and mo.valid) then
				mo.frame = cur
				mo.sprite = SPR_PLAY
				mo.sprite2 = sprite2
				wait = $1+1
				if wait >= tics then
					wait = $1-tics
					cur = $1+1
					if cur > last then
						if (type(loop) == "boolean" and loop) then
							if mo.spranim_status == nil then break end
							cur = first
						elseif (type(loop) == "number" and loop) then
							while true do
								if mo.spranim_status == nil then break end
								if first == last then
									if (wait >= loop) then
										loop = nil
										cur = last
										mo.frame = cur
										mo.sprite = SPR_PLAY
										mo.sprite2 = sprite2
										ACT:stopSprAnim(mo)
										break
									end
									mo.frame = last
								else
									if (wait >= loop) then
										loop = nil
										cur = last
										mo.frame = cur
										mo.sprite = SPR_PLAY
										mo.sprite2 = sprite2
										ACT:stopSprAnim(mo)
										break
									end
									if cur > last then
										cur = first
									end

									mo.frame = cur
									if wait % tics == 0 then cur = $1+1 end
								end
								mo.sprite = SPR_PLAY
								mo.sprite2 = sprite2
								wait = $1+1
								--print(wait..": waiting...")
								waitSeconds(0)
							end
						else
							cur = last
							ACT:stopSprAnim(mo)
							--print("no loop")
							break
						end
					end
				end
			end
			waitSeconds(0)
		end
	end
end)

function ACT:startSpr2Anim(mo, sprite2, tics, loop, seprate, forceRestart)
	ACT:stopSprAnim(mo)

	local function GetSkinSprite2(skin, spr2)
		local superFlag = 0
		local i = 0

		if not (skin and skin.valid)
			return 0
		end

		if ((spr2 & ~FF_SPR2SUPER) >= #spr2names)
			return 0
		end

		while (spr2 != SPR2_STND
		and skin.sprites[spr2].numframes == 0
		and (i + 1) < 32) // recursion limiter
			i = $ + 1

			if (spr2 & FF_SPR2SUPER)
				superFlag = FF_SPR2SUPER
				spr2 = $ & ~FF_SPR2SUPER
				continue
			end

			if (spr2 == SPR2_JUMP)
				if (skin.flags & SF_NOJUMPSPIN)
					spr2 = SPR2_SPNG
				else
					spr2 = SPR2_ROLL
				end
			elseif (spr2 == SPR2_TIRE)
				if (skin.ability == CA_SWIM)
					spr2 = SPR2_SWIM
				else
					spr2 = SPR2_FLY
				end
			else
				spr2 = spr2defaults[spr2]
			end

			spr2 = $ | superFlag
		end

		if (i >= 32) // probably an infinite loop...
			return 0
		end

		return spr2
	end
	sprite2 = GetSkinSprite2(skins[mo.skin], sprite2)

	if mo.spranimstartmarker == sprite2 and not forceRestart then return end

	mo.spranimstartmarker = sprite2
	mo.spranim_status = 1
	if (seprate) then
		--mo.spranimprocess = runProcess(loopFrames2, mo, sprite, tics, loop)
		mo.spranimprocess = TASK:Regist(function()
			loopFrames2(mo, sprite2, tics, loop)
		end)
	else
		loopFrames2(mo, sprite2, tics, loop)
	end
end

function ACT:stopSprAnim(mo)
	if mo.spranimprocess then
		killProcess(mo.spranimprocess)
	end
	mo.spranimprocess = nil
	mo.spranim_status = nil
	mo.spranimstartmarker = nil
end

function ACT:swapSprite(mo, spriteN)
	mo.sprite = spriteN
end

function SCREEN:SetWipe(player, Properties)
	player.hudOptions.wipe = Properties
end

-- Map-to-screen coord transform, shitty software mode style
rawset(_G, "R_ScreenTransform", function(x, y, z, p, cam)
	local ang, aim
	if cam.chase then // obtain the differences
		x, y, z = $1-cam.x, $2-cam.y, $3-cam.z
		ang = cam.angle
		aim = cam.aiming
	else
		x, y, z = $1-p.mo.x, $2-p.mo.y, $3-p.viewz
		ang = p.mo.angle
		aim = p.aiming
	end
	local h = FixedHypot(x, y)
	local da = ang - R_PointToAngle2(0, 0, x, y)
	return 160<<FRACBITS + tan(da)*160, //
	100<<FRACBITS + (tan(aim) - FixedDiv(z, 1 + FixedMul(cos(da), h)))*160,
	FixedDiv((160<<FRACBITS), h+1),
	(abs(da) > ANG60) or (abs(aim - R_PointToAngle2(0, 0, h, z)) > ANG30)
end)


function SOUND:PlayBGM(player, BGM, loop, vol, ply)
	if ply == true
		S_ChangeMusic(BGM, loop, player)
		if not (vol == nil) then
			S_SetInternalMusicVolume(vol, player)
		end
	else
		S_ChangeMusic(BGM, loop)
		if not (vol == nil) then
			S_SetInternalMusicVolume(vol, player)
		end
	end
end

function SOUND:PlaySFX(mo, SE, VOL, player)
	if VOL then
		S_StartSoundAtVolume(mo, SE, VOL, player)
	else
		S_StartSound(mo, SE, player)
	end
end

function SOUND:stopEnvSound(mo)
	if mo then
		if mo.envprocess then
			killProcess(mo.envprocess)
		end
		mo.envprocess = nil
		S_StopSound(mo)
	else
		if globalenvprocess then
			killProcess(globalenvprocess)
		end
		globalenvprocess = nil
	end
end

function SOUND:startEnvSound(mo, sfx, player)
	stopEnvSound(mo)

	if mo then
		mo.envprocess = runProcess(function()
			while true do
				if not S_SoundPlaying(mo, sfx) then
					S_StartSound(mo, sfx, player)
				end
				waitSeconds(0)
			end
		end)
	else
		globalenvprocess = runProcess(function()
			while true do
				if not S_IdPlaying(sfx) then
					S_StartSound(nil, sfx, player)
				end
				waitSeconds(0)
			end
		end)
	end
end


function CAMERA:override(player, bool, enableControls)
	if not (player.mo and player.mo.valid) then
		return
	end

	if player.mo.cam and player.mo.cam.valid
		if bool and not player.mo.cam.override then
			player.mo.cam.momz = 0
		end
		player.mo.cam.override = bool

		player.mo.cam.ctrl = enableControls or false
	end
end

function CAMERA:netOverride(player, serv, args, enablecontrols)
	netgameCamOverride(player, serv, args, enablecontrols)
end

function CAMERA:release(player)
	if player.camprocess then
		killProcess(player.camprocess)
		player.camprocess = nil
	end
end

function CAMERA:SetEye(player, position, aiming)

	local pos_x, pos_y, pos_z = xyzMod(position)
	if player.mo.cam
		player.awayviewmobj = player.mo.cam
		player.awayviewaiming = position.aiming or aiming or 0

		CAMERA:release(player)
		player.camprocess = runProcess(function()
			while true do
				if not player.valid then break end
				player.awayviewtics = 9999
				P_MoveOrigin(player.mo.cam, position.x, position.y, position.z)
				--P_MoveOrigin(player.mo.cam, pos_x, pos_y, pos_z)
				--player.mo.cam.angle = position.angle or 0
				player.awayviewmobj.angle = position.angle or 0
				waitSeconds(0)
				if not (player.mo.cam and player.mo.cam.valid and (
					type(position) ~= "userdata" or position.valid
				))
					break
				end
			end
		end)
	end
end

function CAMERA:UnsetEye(player, aiming)
	if (player.valid) then
		player.awayviewmobj = player.mo.cam
		player.awayviewaiming = aiming or 0

		CAMERA:release(player)
		player.camprocess = runProcess(function()
			while player and player.valid and player.health do
				player.awayviewtics = 2
				waitSeconds(0)
				if not ((player.mo and player.mo.valid) and (player.mo.cam and player.mo.cam.valid))
					break
				end
			end
		end)
	end
end

function CAMERA:lookAtZ(player, destination, setangle)
	local x1 = player.mo.cam.x
	local y1 = player.mo.cam.y
	local z1 = player.mo.cam.z
	--local x1 = player.awayviewmobj.x
	--local y1 = player.awayviewmobj.y
	--local z1 = player.awayviewmobj.z

	local x2 = destination.x
	local y2 = destination.y
	local z2 = destination.z

	if (setangle) then
		CAMERA:UnsetEye(player, R_PointToAngle2(0, 0, FixedHypot(x2 - x1, y2 - y1), z2 - z1))
	else
		return R_PointToAngle2(0, 0, FixedHypot(x2 - x1, y2 - y1), z2 - z1)
	end
end

function OBJECT:setAnimState(mo, state)
	if mo and mo.valid
		mo.state = state
	end
end

function OBJECT:setscale(mo, scale, speed)
	if mo and mo.valid
		if speed then
			mo.destscale = scale
			mo.scalespeed = speed
		else
			mo.scale = scale
		end
	end
end

function OBJECT:setgroupscale(mobjs, scale, speed)
	for _,v in pairs(mobjs)
		if v and v.valid
			if speed then
				v.destscale = scale
				v.scalespeed = speed
			else
				v.scale = scale
			end
		end
	end
end

function OBJECT:showobject(mo, setting)
	if mo and mo.valid
		if (setting == true) then
			mo.flags2 = $1&~MF2_DONTDRAW
		else
			mo.flags2 = $1|MF2_DONTDRAW
		end

	end
end
function OBJECT:setPosition(mo, position, noDelay)
	if mo and mo.valid
		P_MoveOrigin(mo, position.x, position.y, position.z)
		if coroutine.running() and not noDelay then waitSeconds(0) end
	end
end


rawset(_G, "TWEENS", {
	["easeIn"] = {0,0},
	["easeOut"] = {FRACUNIT,FRACUNIT},
	["easeInOut"] = {0,FRACUNIT},
})
local tween_meta = {
	__call = function(tween_meta, ent, amount)
		return {
			tween_meta[ent][1] + FixedMul((FRACUNIT*1/3)-tween_meta[ent][1], FRACUNIT-(amount or FRACUNIT)),
			tween_meta[ent][2] + FixedMul((FRACUNIT*2/3)-tween_meta[ent][2], FRACUNIT-(amount or FRACUNIT)),
		}
	end
}
TWEENS = setmetatable(TWEENS, tween_meta)


-- delta, p1, p2 are all fixed point
local function bezier(delta, p1, p2)
	-- first iteration
	local p0 = FixedMul(p1, delta)
	p1 = $ + FixedMul(p2-p1, delta)
	p2 = $ + FixedMul(FRACUNIT-p2, delta)

	-- second iteration
	p0 = $+FixedMul(p1-p0, delta)
	p1 = $+FixedMul(p2-p1, delta)

	-- final pointp
	return p0 + FixedMul(p1-p0, delta)
end
--[[
-- bezier debug stuff
if true then
	local p1 = CV_RegisterVar({"p1", FRACUNIT/3, 0, C_Unsigned})
	local p2 = CV_RegisterVar({"p2", FRACUNIT*2/3, 0, C_Unsigned})

	hud.add(function(v)
		for x = 0, 100 do
			local y = FixedMul(bezier(FixedDiv(x, 100), p1.value, p2.value), 100)
			v.drawFill(x+100, y+50, 1, 1, 160)
		end
	end)
end
]]

function OBJECT:moveTo(mo, point, speed, props)--arc, tween)
	if mo and mo.valid then
	local dx = point.x - mo.x -- Obtain vector.
	local dy = point.y - mo.y
	local dz = point.z - mo.z
	local dm = FixedHypot(dz, FixedHypot(dx, dy))

	local percent_per_frame = FixedDiv(speed, dm)+1
	local move_time = 0
	local move_delta = 0
	local old_move_offset = {x=0,y=0,z=0}
			-- props.rad
			-- props.rotate
	while move_time < FRACUNIT do
		move_time = $+percent_per_frame

		if props and props.tween then
			move_delta = bezier(move_time, props.tween[1], props.tween[2])
		else
			move_delta = move_time
		end

		local move_offset = {
			x = FixedMul(dx, move_delta),
			y = FixedMul(dy, move_delta),
			z = FixedMul(dz, move_delta),
		}

		if props and props.angle then
			mo.angle = props.angle
		else
			--mo.angle = $1
		end

		if props and props.arc then
			local ang = FixedMul(ANGLE_180, move_delta)
			move_offset.x = $-FixedMul(props.arc.x or 0, sin(ang))
			move_offset.y = $-FixedMul(props.arc.y or 0, sin(ang))
			move_offset.z = $-FixedMul(props.arc.z or 0, sin(ang))
		end

		P_MoveOrigin(mo,
			mo.x + move_offset.x - old_move_offset.x,
			mo.y + move_offset.y - old_move_offset.y,
			mo.z + move_offset.z - old_move_offset.z
		)

		old_move_offset = move_offset

		wait(0)
		if not (mo and mo.valid) then
			return
		end
	end

	--[[dx = FixedDiv($, dm) -- Normalize vector.
	dy = FixedDiv($, dm)
	dz = FixedDiv($, dm)

	local arc_angle = 0

	local curdm = dm -- Distance to use as "countdown";
	local curspd = speed

	local interv = curdm
	while curdm > 0 do
		if not (mo and mo.valid) then
			return
		end
		--curspd = min(max(min(curdm, dm-curdm)/4, 1*FRACUNIT), speed) --EaseOutIn
		if arc then
			local angle_delta = ANGLE_180/dm*curspd
			local old_arc_angle = (arc_angle or ANGLE_90) - angle_delta
			--print(AngleFixed(arc_angle)/FRACUNIT)
			dx = $ + FixedDiv(FixedMul(arc.x or 0, cos(arc_angle)) - FixedMul(arc.x or 0, cos(old_arc_angle)), curspd)
			dy = $ + FixedDiv(FixedMul(arc.y or 0, cos(arc_angle)) - FixedMul(arc.y or 0, cos(old_arc_angle)), curspd)
			dz = $ + FixedDiv(FixedMul(arc.z or 0, cos(arc_angle)) - FixedMul(arc.z or 0, cos(old_arc_angle)), curspd)
			arc_angle = $ + ANGLE_180/dm*curspd
		end

		P_MoveOrigin(mo, mo.x + FixedMul(dx, curspd), mo.y + FixedMul(dy, curspd), mo.z + FixedMul(dz, curspd))
		curdm = $ - curspd
		if rotate then
			mo.angle = $
		end
		wait(0)--coroutine.yield()
	end
]]
	if not (mo and mo.valid) or no_lock then
		return
	end
	P_MoveOrigin(mo, point.x, point.y, point.z) -- Teleport one more time to lock the mobj into the target position.
	if rotate then
		mo.angle = point.angle
	end
	--[[
	local point_x, point_y, point_z = xyzMod(point)

	if mo and mo.valid
		while R_PointToDist2(R_PointToDist2(mo.x, mo.y, point_x, point_y), mo.z, 0, point_z) > rad*FRACUNIT do
		end
	end]]
	end
end

function OBJECT:setAnglePoint(mo, dest)
	return R_PointToAngle2(mo.x, mo.y, dest.x, dest.y)
end

function OBJECT:lookAt(mo, dest, setangle)
	if (setangle) then
		mo.angle = R_PointToAngle2(mo.x, mo.y, dest.x, dest.y)
	else
		return R_PointToAngle2(mo.x, mo.y, dest.x, dest.y)
	end
end

function OBJECT:setAngle(mo, angle)
	if (mo and mo.valid) then
		mo.angle = angle
	end
end

function OBJECT:drawbounds(mo)
	--[[local border = P_SpawnMobj(
					mo.x + cos(FixedAngle(leveltime*FRACUNIT)) + mo.radius,
					mo.y + sin(FixedAngle(leveltime*FRACUNIT)) + mo.radius,
					mo.z, MT_THOK)]]
	--[[local border = P_SpawnMobj(
				mo.x + mo.radius*cos(FixedAngle(FullCircle*FRACUNIT)),
				mo.y + mo.radius*sin(FixedAngle(FullCircle*FRACUNIT)),
				mo.z, MT_THOK)]]
end

function OBJECT:Find(objectType, data)
	for mobjs in mobjs.iterate()
		if (data) then
			if (mobjs.type == objectType)
			and ((data.flags == nil) or (mobjs.flags & data.flags))
			and ((data.options == nil) or (mobjs.spawnpoint.options & data.options))
			and ((data.angle == nil) or (mobjs.spawnpoint.angle == data.angle))
			and ((data.id == nil) or (mobjs.extrainfo == data.id))
			and (mobjs.valid)
				return mobjs
			end
		else
			if (mobjs.type == objectType)
			and (mobjs.valid)
				return mobjs
			end
		end
	end
end


function OBJECT:CreateNew(objectType, loc, param)
	local point_x, point_y, point_z
	if (type(loc) == "userdata" and loc.valid) then
		point_x = loc.x
		point_y = loc.y
		point_z = loc.z
	else
		point_x, point_y, point_z = xyzMod(loc)
	end
	--local point_x, point_y, point_z = xyzMod(loc)

	local newspawn = P_SpawnMobj(point_x,point_y,point_z, objectType)
	--local newspawn = P_SpawnMobj(loc.x, loc.y, loc.z, objectType)

	-- Set any kind of extra info on spawn
	newspawn.extrainfo = ((param != nil and param.id != nil) and param.id) or 0
	--newspawn.spawnangle = ((param != nil and param.spawnangle != nil) and param.spawnangle) or 0
	return newspawn
end

function OBJECT:CreateObjects(...)
	local rets = {}
	for k,v in ipairs({...})
		--OBJECT:CreateNew(v.obj, v.loc)
		table.insert(rets, OBJECT:CreateNew(v.obj, v.loc, {v.id} or nil))--unpack(list)
	end
	return unpack(rets)
end

function OBJECT:Destroy(object, Time)
	if object and object.valid then
		object.fuse = Time or 5
	end
end

function OBJECT:DestroyObjects(objects, useFuse)
	for _,v in pairs(objects)
		--if v and v.valid then --[[..]] else break end
		if useFuse then
			v.fuse = 35
		else
			P_RemoveMobj(v)
		end
	end
end
