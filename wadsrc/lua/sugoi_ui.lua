--
-- Previously some code for sound test also,
-- but now it's simply more shop + generic player think.
--

local UIDefs = {
	[1] = {
		NumEntries = sugoi.SHOPLISTLEN,

		InitFunc = function(player)
			local name = sugoi.KeeperName(sugoi.keeper);
			local keeperstrings = sugoi.KeeperStrings(sugoi.keeper, player.mo);

			local str = keeperstrings[P_RandomRange(1, #keeperstrings)];
			local printplayer = player;

			if (displayplayer and displayplayer.valid)
			and (secondarydisplayplayer and secondarydisplayplayer.valid)
			and (printplayer == secondarydisplayplayer)
				printplayer = displayplayer;
			end

			if (netgame)
				local nameColor = sugoi.KeeperColor(sugoi.keeper);
				local normalColor = "\128";
				chatprintf(printplayer, nameColor.."<"..name..">"..normalColor.." "..str, true);
			else
				-- bruuhhhhh I want chatprint to work in SP :(
				-- You get old chat style.
				CONS_Printf(printplayer, "\3<"..name.."> "..str);
			end

			local mus = sugoi.KeeperMusic(sugoi.keeper);
			P_PlayJingleMusic(printplayer, mus, 0, true, JT_OTHER);
		end,

		MovedFunc = function(player)
			local snd = sugoi.KeeperSoundMove(sugoi.keeper);
			if (snd != nil)
				S_StartSound(nil, snd, player);
			end
		end,

		ExitFunc = function(player)
			local snd = sugoi.KeeperSoundExit(sugoi.keeper);
			if (snd != nil)
				S_StartSound(nil, snd, player);
			end
		end,

		StringFunc = function(player)
			local selItemType = sugoi.shopitemlist[player.ui.cursor];
			local selItem = sugoi.shopitems[selItemType];

			return selItem.description;
		end,

		ConfirmFunc = function(player)
			local selItemType = sugoi.shopitemlist[player.ui.cursor];
			local selItem = sugoi.shopitems[selItemType];

			if (player.tokens >= selItem.price)
				local result = selItem.buyFunc(player);

				if (result == true)
					player.tokens = $1 - selItem.price;
					player.ui.string = sugoi.PurchaseString();
				end

				local snd = sugoi.KeeperSoundBuy(sugoi.keeper);
				if (snd != nil)
					S_StartSound(nil, snd, player);
				end
			else
				player.ui.string = "Not enough tokens!";

				local snd = sugoi.KeeperSoundCantBuy(sugoi.keeper);
				if (snd != nil)
					S_StartSound(nil, snd, player);
				end
			end

			player.ui.cooldown = TICRATE;
		end,
	},

	[2] = {
		NumEntries = #(sugoi.HubPanelMaps),

		InitFunc = function(player)
			for i,map in pairs(sugoi.HubPanelMaps) do
				if (map == gamemap)
					player.ui.cursor = i;
					break;
				end
			end
		end,

		ExitFunc = function(player)
			if (player.mo and player.mo.valid)
			and (player.mo.panelmobj and player.mo.panelmobj.valid)
				player.mo.panelanim = sugoi.PANELANIM_EXIT;
			end
		end,

		StringFunc = function(player)
			local map = sugoi.HubPanelMaps[player.ui.cursor];
			return sugoi.GetMapName(map);
		end,

		ConfirmFunc = function(player)
			local map = sugoi.HubPanelMaps[player.ui.cursor];

			if (map == gamemap)
				-- You're already here.
				player.ui.mode = 0
				player.ui.cooldown = 0
				player.pflags = ($1 & !PF_FORCESTRAFE)
				P_RestoreMusic(player);

				if (player.mo and player.mo.valid)
				and (player.mo.panelmobj and player.mo.panelmobj.valid)
					player.mo.panelanim = sugoi.PANELANIM_EXIT;
				end

				return;
			end

			if (netgame)
				-- Require a vote.
				sugoi.StartVote(player, map, 0, true);
			else
				-- Go there directly.
				sugoi.DoPanelStart = true;
				sugoi.ExitLevel(map, 2);
			end
		end,
	},
};

sugoi.PlayerUI = function(player)
	sugoi.SetupDefaultPVars(player);

	if (player.bot)
		return;
	end

	if (mapheaderinfo[gamemap].creditsmap)
		player.mo.reactiontime = 5;
		player.mo.momx = 0;
		player.mo.momy = 0;
		player.mo.state = S_PLAY_STND;
	else
		sugoi.DoDayCycle(player);
	end

	local UIDef = nil;
	if (player.ui.mode)
		UIDef = UIDefs[player.ui.mode];
	end

	if not (UIDef)
		// Unset UI
		player.ui = {mode = 0, cursor = 1, cooldown = 0, string = ""};

		if (hubSpot and hubSpot.valid)
			player.pflags = ($1 & ~PF_FORCESTRAFE);
		end

		if (mapheaderinfo[gamemap].creditsmap)
			player.mo.reactiontime = 5;
			player.mo.momx = 0;
			player.mo.momy = 0;
			player.mo.state = S_PLAY_STND;
		end

		return;
	end

	player.pflags = $1|PF_FORCESTRAFE;

	local numentries = UIDef.NumEntries;

	if (player.mo and player.mo.valid)
	and not (player.exiting)
	and not (sugoi.currentVoteInfo.voting)
		player.mo.reactiontime = 5;
		player.mo.momx = 0;
		player.mo.momy = 0;

		if (P_IsObjectOnGround(player.mo))
			if (player.mo.state != S_PLAY_STND)
				player.mo.state = S_PLAY_STND;
			end
		end

		if (player.ui.angle != nil)
			local diff = (player.ui.angle - player.mo.angle);
			local factor = 8;
			player.mo.angle = $1 + (diff / factor);
			player.drawangle = player.ui.angle;
		end

		if (player.cmd.buttons & BT_USE)
			player.ui.mode = 0
			player.ui.cooldown = 0
			player.pflags = ($1 & ~PF_FORCESTRAFE)
			P_RestoreMusic(player);

			if (UIDef.ExitFunc != nil)
				UIDef.ExitFunc(player);
			end
		elseif (player.ui.cooldown > 0)
			if (player.cmd.buttons and player.ui.cooldown <= 2)
				player.ui.cooldown = 2
			else
				player.ui.cooldown = $1-1
			end
		else
			if (UIDef.StringFunc != nil)
				player.ui.string = UIDef.StringFunc(player);
			end

			if (player.cmd.buttons & BT_JUMP)
				if (UIDef.ConfirmFunc != nil)
					UIDef.ConfirmFunc(player);
				end
			elseif (player.cmd.sidemove != 0)
				S_StartSound(nil, sfx_ptally, player);
				player.ui.cursor = $1 + sign(player.cmd.sidemove);

				if (player.ui.cursor < 1)
					player.ui.cursor = numentries;
				elseif (player.ui.cursor > numentries)
					player.ui.cursor = 1;
				end

				if (UIDef.MovedFunc != nil)
					UIDef.MovedFunc(player);
				end

				if (UIDef.StringFunc != nil)
					player.ui.string = UIDef.StringFunc(player);
				end

				player.ui.cooldown = 5;
			end
		end

		if (player.ui.cursor < 1)
			player.ui.cursor = numentries;
		elseif (player.ui.cursor > numentries)
			player.ui.cursor = 1;
		end
	end
end

function sugoi.StartUI(player, mode, ang)
	if not (G_PlatformGametype())
		return;
	end

	if (sugoi.currentVoteInfo.voting)
		return;
	end

	if (player.bot or player.spectator)
		return;
	end

	local nummodes = #UIDefs;
	mode = min(max($1, 1), nummodes);

	player.ui.cursor = 1;
	player.ui.cooldown = 2*TICRATE;
	player.ui.mode = mode;
	player.ui.angle = ang;

	local UIDef = UIDefs[mode];
	if (UIDef.InitFunc != nil)
		UIDef.InitFunc(player);
	end

	if (UIDef.StringFunc != nil)
		player.ui.string = UIDef.StringFunc(player);
	end
end

function sugoi.InUI(player)
	if (sugoi.currentVoteInfo.voting)
		return true;
	end

	if not (player and player.valid and player.ui != nil)
		return false;
	end

	return (player.ui.mode != 0);
end

addHook("LinedefExecute", function(line, mo, sec)
	if not (mo and mo.valid) return; end
	if not (mo.player and mo.player.valid) return; end

	local ang = nil;
	if not (line.flags & ML_NOCLIMB)
		ang = FixedAngle(line.frontside.rowoffset);
	end

	sugoi.StartUI(
		mo.player,
		line.frontside.textureoffset / FRACUNIT,
		ang
	);
end, "SHOWUI");

addHook("ThinkFrame", function()
	for player in players.iterate do
		sugoi.PlayerUI(player);
	end
end);

addHook("ShouldJingleContinue", function(player, musname)
	if (musname == "SHOP")
	or (musname == "SHOPB")
	or (musname == "SHOPC")
		return (player and player.valid and player.ui and player.ui.mode == 1);
	end
end);
