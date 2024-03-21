sugoi.currentCecho = {
	text = nil,
	flags = 0,
	timer = 0,
};

sugoi.clientrenderer = "none";

function sugoi.ShouldShowHUD()
	if (sugoi.currentVoteInfo.voting and sugoi.hubSpot)
	or (mapheaderinfo[gamemap].creditsmap)
	or (mapheaderinfo[gamemap].sugoicutscene)
		return false;
	end

	return true;
end

function sugoi.HUDShow(item, e)
	if (e)
		customhud.enable(item)
	else
		customhud.disable(item)
	end
end

local lastmap
function sugoi.LevelHUDdisables(m, midlevel)
	if (mapheaderinfo[m].creditsmap)
		sugoi.HUDShow("score", false)
		sugoi.HUDShow("time", false)
		sugoi.HUDShow("rings", false)
		sugoi.HUDShow("lives", false)
	elseif (midlevel) or (lastmap and mapheaderinfo[lastmap].creditsmap)
		sugoi.HUDShow("score", true)
		sugoi.HUDShow("time", true)
		sugoi.HUDShow("rings", true)
		sugoi.HUDShow("lives", true)
	end

	lastmap = m
end

function sugoi.DoCecho(text, flags, timer)
	if not (text) return end
	sugoi.currentCecho.text = text

	if (flags)
		sugoi.currentCecho.flags = flags
	else
		sugoi.currentCecho.flags = 0
	end

	if (timer)
		sugoi.currentCecho.timer = timer
	else
		sugoi.currentCecho.timer = 6*TICRATE
	end
end

local HUDBGColor = 159

function sugoi.GetMapName(map)
	if not (map)
		if (sugoi.currentVoteInfo.map)
			map = sugoi.currentVoteInfo.map
		else
			map = sugoi.defaultMap
		end
	end

	local name = mapheaderinfo[map].lvlttl

	if not (mapheaderinfo[map].levelflags & LF_NOZONE)
		name = $1.." Zone"
	end

	if mapheaderinfo[map].actnum
		name = $1.." "..mapheaderinfo[map].actnum
	end

	return name
end

local function getVoteString(p)
	if sugoi.playerVotes[#p] == true
		return "You have voted \131YES\128."
	elseif sugoi.playerVotes[#p] == false
		return "You have voted \133NO\128."
	else
		return "You have not voted yet."
	end
end

local function drawMapBadges(vid, map, x, y)
	local nextx = x

	if (mapheaderinfo[map].sugoiaward)
		vid.drawScaled(
			nextx*FRACUNIT, y*FRACUNIT,
			FRACUNIT/2,
			vid.cachePatch("MAPRIBN"..mapheaderinfo[sugoi.currentVoteInfo.map].sugoiaward)
		);
		nextx = $1 - 16;
	end

	if (mapheaderinfo[map].sugoiemerald)
		vid.drawScaled(
			nextx*FRACUNIT, y*FRACUNIT,
			FRACUNIT,
			vid.cachePatch("EMBDG"..mapheaderinfo[map].sugoiemerald)
		);
		nextx = $1 - 16;
	end

	if (sugoi.mapChecks[map])
		vid.drawScaled(
			nextx*FRACUNIT, y*FRACUNIT,
			FRACUNIT,
			vid.cachePatch("MAPSIGN")
		);
		nextx = $1 - 16;
	end
end

local function drawMapRating(vid, map, x, y)
	local difficulty = tonumber(mapheaderinfo[map].difficulty);
	local length = tonumber(mapheaderinfo[map].length);

	if (difficulty == nil)
		difficulty = 0;
	end

	if (length == nil)
		length = 0;
	end

	if not (difficulty or length)
		return;
	end

	local curX = x;
	local curY = y;

	local difficultyPatch = vid.cachePatch("RATEDIFF");
	local veryRudePatch = vid.cachePatch("RATEEVIL");
	local timePatch = vid.cachePatch("RATETIME");
	local blankPatch = vid.cachePatch("RATENONE");
	local minesweeperPatch = vid.cachePatch("RATEMS");

	for i = 1,5
		local p = blankPatch;

		if (i <= length)
			p = timePatch;
		end

		vid.draw(curX, curY, p, 0);
		curX = $1 + 8;
	end

	curX = x;
	curY = $1 - 8;

	for i = 1,5
		local p = blankPatch;

		if (difficulty == -1)
			-- Minesweeper gag
			p = minesweeperPatch;
		elseif (i <= difficulty)
			if (difficulty >= 5)
				-- This level is very scary!
				p = veryRudePatch;
			else
				p = difficultyPatch;
			end
		end

		vid.draw(curX, curY, p, 0);
		curX = $1 + 8;
	end
end

local function creditsFontWidth(v, string)
	if (string == "")
		return 0
	end

	local strwidth = 0

	local str = string:upper()
	local nextx = x

	for i = 1,str:len()
		local nextbyte = str:byte(i,i)
		local pname = "CRFNT"..string.format("%03d", nextbyte)
		local p = v.cachePatch(pname)

		if (v.patchExists(pname)) then
			strwidth = $1 + p.width
		else
			strwidth = $1 + 8
		end
	end

	return strwidth
end

local function drawCredits(vid, player)
	if not (sugoi.creditsCompiled and sugoi.creditsCompiled[1]) return end

	local p1 = players[0]
	local p2 = players[1]

	local width = vid.width() / vid.dupx()
	local height = vid.height() / vid.dupy()
	local splitcoords = 0
	if (vid.renderer() == "opengl") -- HACK because ogl hud stuff just gets stretched anyway
		width = 320
		height = 200
	end
	if (player == p2)
		splitcoords = (height/2) - 6
	end

	local numstrings = (height/8) + 2
	local length = #sugoi.creditsCompiled
	local totaltime = (length*16) - (8*numstrings) + (24)
	local time = min(sugoi.creditsData.time, totaltime)

	local startstring = time/16
	local voffset = (time/2) % 8

	if (sugoi.creditsData.fade != 0)
		local blapckscale = max(vid.width() / vid.dupx(), vid.height() / vid.dupy())
		local fadeflag = 0

		if (sugoi.creditsData.fade < NUMTRANSMAPS)
			fadeflag = ((NUMTRANSMAPS-sugoi.creditsData.fade) << FF_TRANSSHIFT)
		end

		vid.drawScaled(-1, -1, (blapckscale*FRACUNIT)+2, vid.cachePatch("BLAPCK"), V_SNAPTOTOP|V_SNAPTOLEFT|fadeflag)
	end

	for i = -4,numstrings+3
		local table = sugoi.creditsCompiled[startstring+i]
		if not (table and table[2]) continue end

		local spacing = 12
		local x = (width-80-spacing)
		if (table[5] == "L")
			x = $1-80-spacing
		end
		vid.drawScaled(x*FRACUNIT, (i*8-voffset-16)*FRACUNIT, FRACUNIT/2, vid.cachePatch(G_BuildMapName(table[2]).."P"), V_SNAPTOTOP|V_SNAPTOLEFT|V_20TRANS)
	end

	for i = 0,numstrings-1
		local table = sugoi.creditsCompiled[startstring+i]
		if not (table) continue end

		if (table[3] == "header")
			if (table[1] == "") continue end

			local nextx = ((vid.width() / vid.dupx()) / 2) - (creditsFontWidth(vid, table[1]) / 2)
			local str = table[1]:upper()

			for x = 1,str:len() do
				local nextbyte = str:byte(x,x)
				local pname = "CRFNT"..string.format("%03d", nextbyte)
				local patch = vid.cachePatch(pname)

				if (vid.patchExists(pname))
					vid.draw(nextx, ((i-1)*8 - voffset) + 4, patch, V_SNAPTOTOP|V_SNAPTOLEFT)
					nextx = $1 + patch.width
				else
					nextx = $1+8
				end
			end

			continue
		elseif (table[3] == "center")
			if (table[1] == "") continue end

			local flags = V_ALLOWLOWERCASE
			vid.drawString(160, i*8 - voffset, table[1], V_SNAPTOTOP|V_SNAPTOLEFT|flags, "center")

			continue
		else
			if (table[1] == "") continue end

			local flags = 0
			if (type(table[3]) == "number")
				flags = table[3]
			end

			vid.drawString(8, i*8 - voffset, table[1], V_SNAPTOTOP|V_SNAPTOLEFT|flags, "left")
		end
	end
end

local function drawShop(vid, player)
	local blapckscale = max(vid.width(), vid.height());
	vid.drawScaled(
		-1, -1,
		(blapckscale*FRACUNIT) + 2,
		vid.cachePatch("BLAPCK"),
		V_SNAPTOTOP|V_SNAPTOLEFT|V_50TRANS|V_PERPLAYER
	);

	local controlstring = "[\130STRAFE\128] Select - [\130JUMP\128] Buy - [\130SPIN\128] Exit";
	local controllen = vid.stringWidth(controlstring, V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_PERPLAYER);

	vid.drawFill(
		160 - (controllen / 2) - 4,
		180,
		controllen + 8, 16, V_SNAPTOBOTTOM|V_PERPLAYER|HUDBGColor
	);
	vid.drawString(
		160, 184,
		controlstring,
		V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_PERPLAYER, "center"
	);

	for i = 1,sugoi.SHOPLISTLEN
		local iconX = (32 + ((i-1) * 64)) * FRACUNIT;
		local iconY = 48*FRACUNIT;

		vid.drawScaled(
			iconX, iconY,
			2*FRACUNIT,
			vid.cachePatch(sugoi.shopitems[sugoi.shopitemlist[i]].shopIcon),
			V_PERPLAYER
		);

		if (sugoi.shopitemlist[i] == "emerald")
			local emX = iconX - 16*FRACUNIT;
			local emY = iconY - 32*FRACUNIT;
			local emNum = sugoi.NextEmeraldNum();
			local soldOut = false;

			if (emNum == 0)
				emNum = 7;
				soldOut = true;
			end

			vid.drawScaled(
				emX, emY,
				2*FRACUNIT,
				vid.cachePatch("EMBDG"..emNum),
				V_PERPLAYER
			);

			if (soldOut == true)
				local darkX = iconX - 24*FRACUNIT;
				local darkY = iconY - 40*FRACUNIT;
				vid.drawScaled(
					darkX, darkY,
					48*FRACUNIT,
					vid.cachePatch("BLAPCK"),
					V_50TRANS|V_PERPLAYER
				);

				local soldString = "Sold out!";
				local soldwidth = vid.stringWidth("Sold out!", V_PERPLAYER, "thin");
				vid.drawString(
					(iconX / FRACUNIT) - (soldwidth/2),
					iconY/FRACUNIT,
					"Sold out!",
					V_PERPLAYER, "thin"
				);
			end
		end
	end

	local selecteditem = sugoi.shopitems[sugoi.shopitemlist[player.ui.cursor]];
	if (selecteditem == nil)
		selecteditem = sugoi.shopitems["eggman"];
	end

	local curs = "SHOPCUR"..((leveltime % 2) + 1);
	vid.draw((7 + ((player.ui.cursor-1) * 64)), 7, vid.cachePatch(curs), V_PERPLAYER);

	vid.drawFill(32, 64, 262, 88, HUDBGColor|V_PERPLAYER);

	local adds = "s";
	if (selecteditem.price == 1)
		adds = "";
	end

	vid.drawString(40, 72, "\130"..selecteditem.name.."\128 - Costs "..selecteditem.price.." token"..adds, V_ALLOWLOWERCASE|V_PERPLAYER);
	vid.drawString(40, 88, player.ui.string, V_ALLOWLOWERCASE|V_PERPLAYER);

	if (player.shopitem)
		vid.drawScaled(16*FRACUNIT, 158*FRACUNIT, FRACUNIT/2, vid.cachePatch(sugoi.shopitems[player.shopitem].livesIcon), V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER);
		vid.drawString(36, 162, sugoi.shopitems[player.shopitem].name, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_YELLOWMAP|V_PERPLAYER);
	end

	local tokens = min(player.tokens + sugoi.temptokens, 99);
	vid.draw(272, 158, vid.cachePatch("HUBTOKEN"), V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER);
	vid.drawString(296, 162, tokens, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER, "center");
end

local function drawHubSelect(vid, player)
	local blapckscale = max(vid.width(), vid.height());
	vid.drawScaled(
		-1, -1,
		(blapckscale*FRACUNIT) + 2,
		vid.cachePatch("BLAPCK"),
		V_SNAPTOTOP|V_SNAPTOLEFT|V_50TRANS|V_PERPLAYER
	);

	local controlstring = "[\130STRAFE\128] Select - [\130JUMP\128] Goto - [\130SPIN\128] Exit";
	local controllen = vid.stringWidth(controlstring, V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_PERPLAYER);

	vid.drawFill(
		160 - (controllen / 2) - 4,
		180,
		controllen + 8, 16, V_SNAPTOBOTTOM|V_PERPLAYER|HUDBGColor
	);
	vid.drawString(
		160, 184,
		controlstring,
		V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_PERPLAYER, "center"
	);

	local pic = G_BuildMapName(sugoi.HubPanelMaps[player.ui.cursor]).."P";
	local string = player.ui.string;

	local stringx = 160 - (vid.stringWidth(string, V_ALLOWLOWERCASE|V_PERPLAYER, "thin") / 2);

	vid.drawFill(116, 40, 88, 56, HUDBGColor);
	vid.drawScaled(120*FRACUNIT, 43*FRACUNIT, FRACUNIT/2, vid.cachePatch(pic), V_PERPLAYER);
	vid.drawString(stringx, 100, string, V_ALLOWLOWERCASE|V_PERPLAYER, "thin");
end

local function drawVoting(vid, player)
	local blapckscale = max(vid.width() / vid.dupx(), vid.height() / vid.dupy())
	vid.drawScaled(-1, -1, (blapckscale*FRACUNIT)+2, vid.cachePatch("BLAPCK"), V_SNAPTOTOP|V_SNAPTOLEFT|V_50TRANS)

	local controlstring = "[\130JUMP\128] Vote \131YES\128 - [\130SPIN\128] Vote \133NO\128"
	local controllen = vid.stringWidth(controlstring, V_SNAPTOBOTTOM|V_ALLOWLOWERCASE)
	vid.drawFill(
		160 - (controllen / 2) - 4,
		180,
		controllen + 8, 16, V_SNAPTOBOTTOM|HUDBGColor
	)
	vid.drawString(160, 184, controlstring, V_SNAPTOBOTTOM|V_ALLOWLOWERCASE, "center")

	local startedname
	if (sugoi.currentVoteInfo.player and sugoi.currentVoteInfo.player.valid)
		startedname = sugoi.currentVoteInfo.player.name
	elseif not startedname
		startedname = "ANIME EYES SONIC"
	end

	local author = mapheaderinfo[sugoi.currentVoteInfo.map].author;

	if (multiplayer)
		vid.drawString(160, 8, "A vote was started by \130"..startedname, V_ALLOWLOWERCASE, "center")

		if (author != nil)
			vid.drawString(160, 16, "for \130"..sugoi.GetMapName(sugoi.currentVoteInfo.map).."\128", V_ALLOWLOWERCASE, "center")
			vid.drawString(160, 24, "by \130"..mapheaderinfo[sugoi.currentVoteInfo.map].author.."\128.", V_ALLOWLOWERCASE, "center")
		else
			vid.drawString(160, 16, "for \130"..sugoi.GetMapName(sugoi.currentVoteInfo.map).."\128.", V_ALLOWLOWERCASE, "center")
		end

		vid.drawString(16, 144, "\130"..sugoi.GetVoteCount("yes").."\128 have voted \131YES\128.", V_ALLOWLOWERCASE, "left")
		vid.drawString(304, 144, "\130"..sugoi.GetVoteCount("no").."\128 have voted \133NO\128.", V_ALLOWLOWERCASE, "right")
	else
		vid.drawString(160, 8, "Are you sure you want to go", V_ALLOWLOWERCASE, "center")

		if (author != nil)
			vid.drawString(160, 16, "to \130"..sugoi.GetMapName(sugoi.currentVoteInfo.map).."\128", V_ALLOWLOWERCASE, "center")
			vid.drawString(160, 24, "by \130"..mapheaderinfo[sugoi.currentVoteInfo.map].author.."\128?", V_ALLOWLOWERCASE, "center")
		else
			vid.drawString(160, 16, "to \130"..sugoi.GetMapName(sugoi.currentVoteInfo.map).."\128?", V_ALLOWLOWERCASE, "center")
		end
	end

	vid.drawFill(116, 44, 88, 56, HUDBGColor)

	if (mapheaderinfo[sugoi.currentVoteInfo.map].hubimage)
		vid.drawScaled(120*FRACUNIT, 47*FRACUNIT, FRACUNIT/2, vid.cachePatch(mapheaderinfo[sugoi.currentVoteInfo.map].hubimage))
	elseif (sugoi.currentVoteInfo.map)
		vid.drawScaled(120*FRACUNIT, 47*FRACUNIT, FRACUNIT/2, vid.cachePatch(G_BuildMapName(sugoi.currentVoteInfo.map).."P"))
	else
		vid.drawScaled(120*FRACUNIT, 47*FRACUNIT, FRACUNIT/2, vid.cachePatch(G_BuildMapName(defaultMap).."P"))
	end

	if (mapheaderinfo[sugoi.currentVoteInfo.map].staticoverlay)
	and not (sugoi.mapChecks[sugoi.currentVoteInfo.map])
		vid.draw(120, 47, vid.cachePatch("MSTATIC"..((leveltime % 4)+1)), V_30TRANS)
	end

	drawMapBadges(vid, sugoi.currentVoteInfo.map, 192, 89);
	drawMapRating(vid, sugoi.currentVoteInfo.map, 121, 88);

	if (sugoi.currentVoteInfo.emmycost > 0)
		local flags = V_ALLOWLOWERCASE|V_YELLOWMAP;

		local leftStr = "* ";
		local rightStr = " IS NEEDED TO PLAY *";

		if (sugoi.currentVoteInfo.emmycost > 1)
			rightStr = " x" + sugoi.currentVoteInfo.emmycost + $1;
		end

		local tokenWidth = 16;
		local leftWidth = vid.stringWidth(leftStr, flags);
		local totalWidth = leftWidth + tokenWidth + vid.stringWidth(rightStr, flags);

		local emX = 160 - (totalWidth / 2);

		vid.drawString(emX, 112, leftStr, flags, "left");
		emX = $1 + leftWidth;

		vid.draw(emX, 108, vid.cachePatch("HUBTOKEN"), 0);
		emX = $1 + tokenWidth;

		vid.drawString(emX, 112, rightStr, flags, "left");
	end

	vid.drawString(160, 128, getVoteString(player), V_ALLOWLOWERCASE, "center")

	if (sugoi.cv_vote.value > 0)
		vid.drawString(160, 164, "Voting ends in "..sugoi.currentVoteInfo.timer/TICRATE.." seconds", V_YELLOWMAP, "center")
	end
end

local function drawOpenGLBadDayCycle(v, pal)
	if (sugoi.InUI(displayplayer))
		-- Make it easier to see graphics in UIs
		return;
	end

	local pal = mapheaderinfo[gamemap].palette;
	if not (sugoi.dayCycles[pal])
		return;
	end

	local letter = sugoi.dayCycles[pal].ogl
	if (letter == nil)
		return;
	end

	local strength = V_80TRANS;
	if (type == 100)
		local str = {
			[0] = V_90TRANS,
			[1] = V_80TRANS,
			[2] = V_50TRANS,
			[3] = V_30TRANS,
			[4] = V_70TRANS,
			[5] = V_70TRANS,
		}

		strength = str[sugoi.daycycle];
	end

	local patch = v.cachePatch("GLTINT"..letter..sugoi.daycycle)

	local blapckscale = max(v.width() / v.dupx(), v.height() / v.dupy());
	v.drawScaled(-1, -1, (blapckscale*FRACUNIT)+2, patch, V_SNAPTOTOP|V_SNAPTOLEFT|strength);
end

local function drawExits(vid, player)
	if (modeattacking)
		return;
	end

	local x = 272;
	local y = 176;
	local flags = V_PERPLAYER|V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_HUDTRANS;
	local spacing = 40;

	local tokens = 0;
	local beaten = 0;
	local signIcon = "MAPSIGN";

	if not (player and player.valid)
		player = displayplayer;
	end

	tokens = min(player.tokens + sugoi.temptokens, 99);

	vid.draw(x, y, vid.cachePatch("HUBTOKEN"), flags);
	vid.drawString(x + 24, y + 4, tokens, flags, "center");
	x = $1 - spacing;

	if (splitscreen)
		if (player.ssnumbeaten != nil)
			beaten = player.ssnumbeaten;

			if (player == displayplayer)
				signIcon = "MAPSIGN1"
			elseif (player == secondarydisplayplayer)
				signIcon = "MAPSIGN2"
			end
		end

		vid.draw(x, y, vid.cachePatch(signIcon), flags);
		vid.drawString(x + 24, y + 4, beaten, flags, "center");
	end
end

local function drawHud(vid, player)
	sugoi.clientrenderer = vid.renderer()

	if (G_PlatformGametype())
		if (mapheaderinfo[gamemap].sugoicutscene)
			vid.drawFill()
			return
		end

		local p1 = players[0]
		local p2 = players[1]

		if (mapheaderinfo[gamemap].creditsmap)
			if (splitscreen) and not (player == p1) return end
			drawCredits(vid, player)
		elseif (sugoi.currentVoteInfo.voting and sugoi.hubSpot)
			if (sugoi.cv_vote.value == -1) return end
			if (splitscreen) and not (player == p1) return end
			drawVoting(vid, player)
		elseif (player.ui and player.ui.mode)
			if (player.ui.mode == 1)
				drawShop(vid, player)
			elseif (player.ui.mode == 2)
				drawHubSelect(vid, player)
			end
		else
			if (sugoi.hubSpot)
				if (player.shopitem)
					vid.drawScaled(
						16*FRACUNIT, 176*FRACUNIT,
						FRACUNIT/2,
						vid.cachePatch(sugoi.shopitems[player.shopitem].livesIcon),
						V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER
					);
				end
				drawExits(vid, player)
			end

			if (sugoi.currentCecho.timer and sugoi.currentCecho.text)
				vid.drawString(160, 176, sugoi.currentCecho.text, sugoi.currentCecho.flags, "center")
			end
		end
	end

	if (sugoi.clientrenderer == "opengl" and sugoi.daycycle >= 0)
		drawOpenGLBadDayCycle(vid, mapheaderinfo[gamemap].palette)
	end
end

local function drawScoreHud(vid)
	if (G_PlatformGametype())
		if (mapheaderinfo[gamemap].sugoicutscene)
			vid.drawFill()
			return
		end

		drawExits(vid, nil)
	end

	if (multiplayer)
		if (sugoi.clientrenderer == "opengl" and sugoi.daycycle >= 0)
			drawOpenGLBadDayCycle(vid, mapheaderinfo[gamemap].palette)
		end
	end
end

hud.add(drawHud, "game")
hud.add(drawScoreHud, "scores")
