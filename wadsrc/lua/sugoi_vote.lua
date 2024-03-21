sugoi.cv_vote = CV_RegisterVar({
	name = "sugoi_votetime",
	defaultvalue = "10",
	flags = CV_SAVE|CV_NETVAR,
	PossibleValue = {MIN = -1, MAX = 3600}
})

sugoi.cv_pick = CV_RegisterVar({
	name = "sugoi_whopicks",
	defaultvalue = "All",
	flags = CV_SAVE|CV_NETVAR|CV_SHOWMODIF,
	PossibleValue = {All = 0, Host = 1}
})

sugoi.currentVoteInfo = {
	voting = false,
	timer = 0,
	map = defaultMap,
	player = nil,
	unlockreset = false,
	emmycost = 0,
	panelStart = false,
}

sugoi.playerVotes = {};

sugoi.failedString = "Vote failed!";
--sugoi.passedString = "Vote passed!";

sugoi.defaultMap = sugoi.hubMaps.sugoi;

function sugoi.GetVoteCount(votetype)
	local yes = 0
	local no = 0
	local total = 0

	for k,v in pairs(sugoi.playerVotes)
		if v == true
			yes = $1 + 1
			total = $1 + 1
		elseif v == false
			no = $1 + 1
			total = $1 + 1
		end
	end

	if (votetype == "yes" or votetype == true)
		return yes
	elseif (votetype == "no" or votetype == false)
		return no
	else
		return total
	end
end

function sugoi.FailVote(cecho)
	if not (cecho) and (multiplayer)
		-- Fall back to the "vote failed" string... but only in multiplayer!!
		cecho = sugoi.failedString;
	end

	if (cecho)
		sugoi.DoCecho(cecho, V_YELLOWMAP|V_RETURN8, 6*TICRATE)
	end

	if (sugoi.currentVoteInfo.player and sugoi.currentVoteInfo.player.valid) and (multiplayer)
		-- Get outta there.
		if (sugoi.hubSpot and sugoi.hubSpot.valid)
			P_SetOrigin(sugoi.currentVoteInfo.player.mo, sugoi.hubSpot.x, sugoi.hubSpot.y, sugoi.hubSpot.z)
			sugoi.currentVoteInfo.player.mo.angle = sugoi.hubSpot.angle
		else
			G_DoReborn(#(sugoi.currentVoteInfo.player))
		end

		S_StartSound(sugoi.currentVoteInfo.player.mo, sfx_mixup, sugoi.currentVoteInfo.player)
		--P_FlashPal(sugoi.currentVoteInfo.player, 1, 5)

		-- Reset hub panel animation
		sugoi.currentVoteInfo.player.mo.panelanim = nil
		sugoi.currentVoteInfo.player.mo.panelmobj = nil
		sugoi.currentVoteInfo.player.mo.flags = $1 & ~(MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY)
	end
end

function sugoi.FinishVote(naturalend)
	if not (sugoi.currentVoteInfo.voting) return; end

	if (naturalend and G_PlatformGametype())
		if ((sugoi.GetVoteCount("yes") > sugoi.GetVoteCount("no"))
		or (sugoi.cv_vote.value == -1))
			if (sugoi.currentVoteInfo.emmycost > 0)
				if (sugoi.currentVoteInfo.player and sugoi.currentVoteInfo.player.valid)
				and (sugoi.currentVoteInfo.player.tokens >= sugoi.currentVoteInfo.emmycost)
					sugoi.currentVoteInfo.player.tokens = $1 - sugoi.currentVoteInfo.emmycost;
					sugoi.DoPanelStart = sugoi.currentVoteInfo.panelStart;
					sugoi.ExitLevel(sugoi.currentVoteInfo.map, 2);
				else
					sugoi.FailVote("Not enough tokens!");
				end
			else
				sugoi.DoPanelStart = sugoi.currentVoteInfo.panelStart;
				sugoi.ExitLevel(sugoi.currentVoteInfo.map, 2);
			end
		else
			sugoi.FailVote();
		end
	end

	sugoi.playerVotes = {};
	sugoi.currentVoteInfo.voting = false;
	sugoi.currentVoteInfo.timer = 0;
	sugoi.currentVoteInfo.map = defaultMap;
	sugoi.currentVoteInfo.player = nil;
	sugoi.currentVoteInfo.emmycost = 0;
	sugoi.currentVoteInfo.hubSwapper = false;
	sugoi.LevelHUDdisables(gamemap, true);
end

function sugoi.StartVote(player, map, emmycost, hubSwapper)
	if not (G_PlatformGametype()) return; end
	if (sugoi.currentVoteInfo.voting) return; end

	if (player.bot or player.spectator) return; end

	if (sugoi.cv_pick.value) and not (IsPlayerAdmin(player))
		CONS_Printf(player, "The host has disallowed others from picking levels.");
		return;
	end

	sugoi.currentVoteInfo.player = player;

	if (sugoi.cv_vote.value > 0)
		sugoi.currentVoteInfo.timer = sugoi.cv_vote.value * TICRATE;
	elseif (sugoi.cv_vote.value == 0)
		sugoi.currentVoteInfo.timer = 12;
	end

	if not (mapheaderinfo[map])
		map = sugoi.defaultMap;
	end

	sugoi.currentVoteInfo.map = map;

	if (sugoi.mapChecks[map])
		-- If this stage was already cleared, make it free to play.
		sugoi.currentVoteInfo.emmycost = 0;
	else
		if (emmycost and emmycost > 0)
			sugoi.currentVoteInfo.emmycost = emmycost;
		else
			sugoi.currentVoteInfo.emmycost = 0;
		end
	end

	sugoi.currentVoteInfo.panelStart = hubSwapper;

	sugoi.currentVoteInfo.voting = true;

	sugoi.HUDShow("score", false);
	sugoi.HUDShow("time", false);
	sugoi.HUDShow("rings", false);
	sugoi.HUDShow("lives", false);
end

function sugoi.StartVoteLine(line, mo, sec)
	if not ((mo and mo.valid) and (mo.player and mo.player.valid))
		return
	end

	local map = sugoi.defaultMap;
	if (line.frontsector.floorheight > 0)
		map = line.frontsector.floorheight / FRACUNIT;
	end

	local emmy = 0;
	if ((line.flags & ML_BLOCKMONSTERS) and (line.frontside.textureoffset > 0))
		emmy = line.frontside.textureoffset / FRACUNIT;
	end

	sugoi.StartVote(mo.player, map, emmy);
end

addHook("LinedefExecute", sugoi.StartVoteLine, "VOTEEXIT");
