local function ResetPlayerAbilities(player)
	// BAD HACK:
	// I cannot trust any of the entries' Lua scripts to handle some stuff properly
	// So I'm sticking my own resets here

	player.prevpuyo = false;
	player.pflags = $1 & ~PF_FORCESTRAFE;

	player.jumpfactor = skins[player.skin].jumpfactor;
	player.charability = skins[player.skin].ability;
	player.charability2 = skins[player.skin].ability2;
	player.normalspeed = skins[player.skin].normalspeed;
end

addHook("MapChange", function(map)
	sugoi.fullyLoaded = false;
	sugoi.hubSpot = nil;
	sugoi.temptokens = 0;
	sugoi.exitingcheck = false;

	sugoi.creditsData = {
		time = 0,
		day = 0,
		fade = NUMTRANSMAPS,
		fadeout = false,
		camera = nil,
	};
	sugoi.creditsCompiled = {};

	sugoi.currentCecho = {
		text = nil,
		flags = 0,
		timer = 0,
	};

	sugoi.FinishVote(false);

	for player in players.iterate do
		ResetPlayerAbilities(player);
	end

	sugoi.displayboss = nil;
	sugoi.bossHUD = nil;
	sugoi.queueBoss = nil;

	sugoi.LevelHUDdisables(map);
end);

addHook("MapLoad", function(map)
	if (mapheaderinfo[map].sugoiemerald)
		stagefailed = true;
	end

	if (mapheaderinfo[map].creditsmap)
		sugoi.CompileCredits();
	end

	sugoi.DarkenHub(map);

	local panel = nil;
	for thing in mapthings.iterate
		if not ((thing and thing.valid)
		and (thing.mobj and thing.mobj.valid))
			continue;
		end

		if (thing.mobj.type == MT_HUBSPOT)
			sugoi.hubSpot = thing.mobj;
		elseif (thing.mobj.type == MT_HUBPANEL)
			panel = thing.mobj;
		elseif (thing.mobj.type == MT_SHOPKEEPER_SHADOW)
		or (thing.mobj.type == MT_SHOPKEEPER_OWL)
		or (thing.mobj.type == MT_MANEGG)
			sugoi.keeper = thing.mobj;
		end
	end

	if (marathonmode) and (mapheaderinfo[map].marathontag)
		P_LinedefExecute(mapheaderinfo[map].marathontag);
	end

	if (modeattacking) and (mapheaderinfo[map].modeattackingtag)
		P_LinedefExecute(mapheaderinfo[map].modeattackingtag);
	end

	sugoi.LoadLuaSave();

	if (sugoi.hubSpot)
		sugoi.DoUnlockTags(id);

		for i = 1,sugoi.SHOPLISTLEN
			if not (sugoi.shopitemlist[i])
				sugoi.InitShopItemList();
				break;
			end
		end

		sugoi.lastHub = map;
	else
		sugoi.shopitemlist = {};
	end

	local serverisplayer = false;
	local doPinkShield = false;

	sugoi.AdvanceDayCycle(map);
	sugoi.UpdateDayCycleSky();

	for player in players.iterate do
		ResetPlayerAbilities(player);
		player.ui.mode = 0;

		sugoi.DoDayCycle(player);

		if (server == player)
			serverisplayer = true;
		end

		if (sugoi.DoPanelStart == true)
		and (panel and panel.valid)
			-- Make everyone come out of the panel.
			player.mo.panelmobj = panel;

			P_SetOrigin(player.mo,
				panel.x, panel.y,
				panel.z - (128*FRACUNIT) + 1
			);

			player.mo.panelanim = sugoi.PANELANIM_EXIT;
		end

		-- Handle item restores
		if (player.mo and player.mo.valid)
		and not (mapheaderinfo[map].noitemsallowed)
			if (player.restoreShield != nil)
				if (player.restoreShield & SH_FIREFLOWER)
					player.powers[pw_shield] = ($1 & SH_NOSTACK) | SH_FIREFLOWER;
					player.mo.color = SKINCOLOR_WHITE;
				end

				local restore = (player.restoreShield & SH_NOSTACK);

				if (restore & SH_FORCE)
					-- Make sure you get the extra hit point back
					restore = SH_FORCE|1;
				end

				P_SwitchShield(player, restore);
				player.restoreShield = nil;
			end

			if (player.shopitem) and not (sugoi.hubSpot)
				-- Activate your item!
				sugoi.UsePlayerItem(player);
			end

			if (player.activatePinkShield == true)
				-- Must handle pink shield item after the other items fire off
				doPinkShield = true;
				player.activatePinkShield = nil;
			end
		end
	end

	if (doPinkShield == true)
		sugoi.GivePinkShields();
	end

	if (server and server.valid)
		server.isdedicated = (not serverisplayer);
	end

	sugoi.LevelHUDdisables(map);

	local skip_int = 0;
	if (mapheaderinfo[map] and mapheaderinfo[map].skipintermission)
		skip_int = 1;
	end

	G_SetCustomExitVars(
		sugoi.NextLevel(map),
		skip_int
	);

	sugoi.BossLookup();

	sugoi.DoPanelStart = false;
	sugoi.fullyLoaded = true;
end);

addHook("ThinkFrame", function()
	if (sugoi.currentCecho and sugoi.currentCecho.timer)
		sugoi.currentCecho.timer = $1 - 1;
	end

	if (mapheaderinfo[gamemap].creditsmap)
		sugoi.CreditsThinker();
	end

	if (mapheaderinfo[gamemap].hubdarken)
		sugoi.HubLightThink();
	end

	sugoi.CheckQueuedBoss();
end);

addHook("NetVars", function(net)
	sugoi.fullyLoaded = net(sugoi.fullyLoaded);

	sugoi.Unlocked = net(sugoi.Unlocked);
	sugoi.mapChecks = net(sugoi.mapChecks);
	sugoi.exitingcheck = net(sugoi.exitingcheck);

	sugoi.temptokens = net(sugoi.temptokens);
	sugoi.shopitemlist = net(sugoi.shopitemlist);

	sugoi.hubSpot = net(sugoi.hubSpot);
	sugoi.lastHub = net(sugoi.lastHub);

	sugoi.currentVoteInfo = net(sugoi.currentVoteInfo);
	sugoi.playerVotes = net(sugoi.playerVotes);

	sugoi.currentCecho = net(sugoi.currentCecho);
	sugoi.displayboss = net(sugoi.displayboss);
	sugoi.queueBoss = net(sugoi.queueBoss);

	sugoi.DoPanelStart = net(sugoi.DoPanelStart);

	-- this is only synched because
	-- 1.) linedef executor at the end of credits
	-- 2.) mid-game joiners get the same scroll as the host
	-- otherwise would be safe to not sync
	sugoi.creditsData = net(sugoi.creditsData);
	sugoi.creditsCompiled = net(sugoi.creditsCompiled);

	-- Just synced so that everyone can see the same time of day
	sugoi.daycycle = net(sugoi.daycycle);
end);
