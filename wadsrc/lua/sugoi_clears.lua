sugoi.mapChecks = {};
sugoi.exitingcheck = false;

function sugoi.AwardEmerald(doSound)
	if not (mapheaderinfo[gamemap])
		return;
	end

	if not (mapheaderinfo[gamemap].sugoiemerald)
		return;
	end

	stagefailed = false;

	local emNum = tonumber(mapheaderinfo[gamemap].sugoiemerald);
	if (emNum <= 0 or emNum > 7)
		return;
	end

	local emFlag = 1 << (emNum - 1);
	if (doSound == true) and not (emeralds & emFlag)
		S_StartSound(nil, sfx_cgot);
	end

	emeralds = $1 | emFlag;
end

function sugoi.ExitLevel(v1, v2)
	if (sugoi.exitingcheck)
		return;
	end

	if (v1 != nil or v2 != nil)
		G_SetCustomExitVars(v1, v2);
	end

	sugoi.GiveCredit(nil);

	G_ExitLevel();
	sugoi.exitingcheck = true;
end

function sugoi.GetTotalBeaten()
	local total = 0;

	for _,v in pairs(sugoi.mapChecks) do
		if (v)
			total = $1 + 1;
		end
	end

	return total;
end

function sugoi.IterateMapChecks(func)
	local curBank = sugoi.mapStartBank;
	local curBit = 0;

	for i = 1,#mapheaderinfo
		if (mapheaderinfo[i] == nil)
			continue;
		end

		if (i == tutorialmap or i == titlemap)
			continue;
		end

		if (G_IsSpecialStage(i))
			continue;
		end

		if (mapheaderinfo[i].countmap)
			local flag = 1 << curBit;

			func(i, curBank, flag);

			curBit = $1 + 1;

			if (curBit > sugoi.maxBit)
				curBank = $1 + 1;
				curBit = 0;
			end

			assert(curBank <= sugoi.maxBank, "TOO MANY MAP CHECKS!!!!! How are you gonna get outta this one...");
		end
	end
end

function sugoi.GiveCredit(player)
	if (stagefailed) or (sugoi.exitingcheck)
		return;
	end

	sugoi.LoadLuaSave();

	if (mapheaderinfo[gamemap].countmap)
		if (splitscreen) and not (sugoi.mapChecks[gamemap])
			if (player and player.valid)
				player.ssnumbeaten = $1 + 1;
			else
				for p in players.iterate do
					p.ssnumbeaten = $1 + 1;
				end
			end
		end

		sugoi.mapChecks[gamemap] = true;
	end

	sugoi.UpdateTokens();
	sugoi.DoLuaSave();
end

function sugoi.tol(gt)
	if not (multiplayer or netgame)
		return TOL_SP;
	end

	if (gt == GT_COOP)
		return TOL_COOP;
	elseif (gt == GT_COMPETITION)
		return TOL_COMPETITION;
	elseif (gt == GT_RACE)
		return TOL_RACE;
	elseif (gt == GT_MATCH or gt == GT_TEAMMATCH)
		return TOL_MATCH;
	elseif (gt == GT_TAG or gt == GT_HIDEANDSEEK)
		return TOL_TAG;
	elseif (gt == GT_CTF)
		return TOL_CTF;
	end
end

function sugoi.NextLevel(map)
	local nextlevel = defaultMap;

	nextlevel = mapheaderinfo[map].nextlevel;

	if (modeattacking)
		return nextlevel;
	end

	if (mapheaderinfo[nextlevel])
		-- Find next level of multiplayer gametype
		local n = nextlevel;
		local t = sugoi.tol(gametype);
		local type = mapheaderinfo[n].typeoflevel;
		local l = 0;

		while not (type & t)
			if (l > 9)
				break;
			end

			n = $1+1;
			if not (mapheaderinfo[n])
				n = 1; -- Go back to map01
			end

			type = mapheaderinfo[n].typeoflevel;
			l = $1+1;
		end

		if (type & t)
			nextlevel = n;
		end
	end

	return nextlevel;
end
