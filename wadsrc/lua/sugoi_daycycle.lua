sugoi.dayCycles = {
	[100] = {cycles = 6, sky = 7401, ogl = "A"},
	[101] = {cycles = 8, sky = nil, ogl = "B"},
};

sugoi.daycycle = -1;

function sugoi.AdvanceDayCycle(map)
	if (mapheaderinfo[map].creditsmap)
		return;
	end

	local pal = mapheaderinfo[map].palette;
	local numCycles = 0;

	if (sugoi.dayCycles[pal])
		numCycles = sugoi.dayCycles[pal].cycles;
	end

	if (map == sugoi.lastHub)
		-- Returning to the hub, advance the day cycle.
		if (numCycles)
			sugoi.daycycle = ($1 + 1) % numCycles;
		end
	elseif (sugoi.hubSpot)
		-- Entered a new hub, reset the day cycle.
		sugoi.daycycle = 0;
	elseif (sugoi.daycycle == -1 or mapheaderinfo[map].randomday)
		if (numCycles)
			-- Randomize the daycycle for egg gundam, if you warped to it.
			sugoi.daycycle = P_RandomKey(numCycles);
		end
	end
end

function sugoi.DoDayCycle(player)
	if (sugoi.InUI(player))
		-- Make it easier to see graphics in UIs
		return;
	end

	if (mapheaderinfo[gamemap].credits)
		return;
	end

	local pal = mapheaderinfo[gamemap].palette;
	if not (sugoi.dayCycles[pal])
		return;
	end

	if (sugoi.daycycle >= 0 and sugoi.clientrenderer == "software")
		player.flashpal = 6 + sugoi.daycycle;
		player.flashcount = 2;
	end
end

function sugoi.UpdateDayCycleSky()
	if (mapheaderinfo[gamemap].credits)
		return;
	end

	local pal = mapheaderinfo[gamemap].palette;
	if not (sugoi.dayCycles[pal])
		return;
	end

	local skyNum = sugoi.dayCycles[pal].sky;
	if (skyNum and sugoi.daycycle >= 0)
		P_SetupLevelSky(skyNum + sugoi.daycycle);
	end
end
