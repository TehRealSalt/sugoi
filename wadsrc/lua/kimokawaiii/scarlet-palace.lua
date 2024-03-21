-- Sal: KIMOKAWAIII Scarlet Palace could freely replace
-- the Snow because no other map ended up using snow.

-- However, we can't anymore after the merging, because
-- a lot of SUBARASHII maps use snow.

-- So instead of killing the effect entirely, here's a Lua
-- script to modify snow per level!

freeslot("SPR_LEF1");

local UseLeafWeather = false;

local function UpdateLeaves()
	if (UseLeafWeather)
		states[S_SNOW1].sprite = SPR_LEF1;
		states[S_SNOW2].sprite = SPR_LEF1;
		states[S_SNOW3].sprite = SPR_LEF1;
	else
		states[S_SNOW1].sprite = SPR_SNO1;
		states[S_SNOW2].sprite = SPR_SNO1;
		states[S_SNOW3].sprite = SPR_SNO1;
	end
end

addHook("MapChange", function(map)
	if (mapheaderinfo[map] and mapheaderinfo[map].scarletleaves)
		UseLeafWeather = true;
	else
		UseLeafWeather = false;
	end

	UpdateLeaves();
end);

addHook("NetVars", function(net)
	UseLeafWeather = net(UseLeafWeather);
	UpdateLeaves();
end);
