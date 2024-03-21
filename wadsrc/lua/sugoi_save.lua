sugoi.maxBank = 15;
sugoi.maxBit = 31;

sugoi.tokenBank = 0;
sugoi.mapStartBank = sugoi.tokenBank+1;

sugoi.LuaSaveData = reserveLuabanks();

function sugoi.LoadLuaSave()
	if (netgame or multiplayer)
		return;
	end

	if not (consoleplayer and consoleplayer.valid)
		return;
	end

	if (consoleplayer.LuaBanksInit == true)
		return;
	end

	sugoi.IterateMapChecks(function(map, bank, flag)
		if (sugoi.LuaSaveData[bank] & flag)
			sugoi.mapChecks[map] = true;
		else
			sugoi.mapChecks[map] = false;
		end
	end);

	consoleplayer.tokens = sugoi.LuaSaveData[sugoi.tokenBank];
	consoleplayer.LuaBanksInit = true;
end

function sugoi.DoLuaSave()
	if (netgame or multiplayer)
		return;
	end

	if not (consoleplayer and consoleplayer.valid)
		return;
	end

	sugoi.IterateMapChecks(function(map, bank, flag)
		if (sugoi.mapChecks[map])
			sugoi.LuaSaveData[bank] = $1 | flag;
		end
	end);

	local tokens = 0;
	if (consoleplayer and consoleplayer.valid)
		tokens = consoleplayer.tokens;
	end

	sugoi.LuaSaveData[sugoi.tokenBank] = tokens;
end
