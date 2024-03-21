sugoi.UseTitle = true; -- I guess if something else wants to disable it?

-- Scrambles the value of an inputted seed.
-- Just a very simplistic form of a Tausworthe generator.
local function scramble(input)
	-- Initial constant XOR, prevents seed 0 from always outputting 0
	-- This value basically means nothing and could be changed to anything
	local output = input ^^ 1064338584;

	-- XOR and shift around to get a random-feeling value
	output = $1 ^^ (input >> 13);
	output = $1 ^^ (input << 25);
	output = $1 ^^ (input >> 11);

	-- AND with max value
	output = (abs(output) & INT32_MAX);
	return output;
end

local titleRNG = scramble(0xC547FCBD);

local titlePatches = {
	sugoi = {
		ttbanner = "AESBANER",
		ttwing = "AESWING",
		ttsonic = "AESSONIC",
		ttswave1 = "AESWAVE1",
		ttswave2 = "AESWAVE2",
		ttswip1 = "AESWIP1",
		ttsprep1 = "AESPREP1",
		ttsprep2 = "AESPREP2",
		ttspop1 = "AESPOP1",
		ttspop2 = "AESPOP2",
		ttspop3 = "AESPOP3",
		ttspop4 = "AESPOP4",
		ttspop5 = "AESPOP5",
		ttspop6 = "AESPOP6",
		ttspop7 = "AESPOP7",
	},
	subarashii = {
		ttbanner = "JJSBANER",
		ttwing = "JJSWING",
		ttsonic = "JJSSONIC",
		ttswave1 = "JJSWAVE1",
		ttswave2 = "JJSWAVE2",
		ttswip1 = "JJSWIP1",
		ttsprep1 = "JJSPREP1",
		ttsprep2 = "JJSPREP2",
		ttspop1 = "JJSPOP1",
		ttspop2 = "JJSPOP2",
		ttspop3 = "JJSPOP3",
		ttspop4 = "JJSPOP4",
		ttspop5 = "JJSPOP5",
		ttspop6 = "JJSPOP6",
		ttspop7 = "JJSPOP7",
	},
	kimokawaiii = {
		ttbanner = "HMBANNER",
		ttwing = "HMWING",
		ttsonic = "HMSONIC",
		ttswave1 = "HMSWAVE1",
		ttswave2 = "HMSWAVE2",
		ttswip1 = "HMSWIP1",
		ttsprep1 = "HMSPREP1",
		ttsprep2 = "HMSPREP2",
		ttspop1 = "HMSPOP1",
		ttspop2 = "HMSPOP2",
		ttspop3 = "HMSPOP3",
		ttspop4 = "HMSPOP4",
		ttspop5 = "HMSPOP5",
		ttspop6 = "HMSPOP6",
		ttspop7 = "HMSPOP7",
	},
};

-- Scary is a copy of SUGOI's
titlePatches.scary = titlePatches.sugoi;

local TitleFinishLoading = false;

local titleType = "sugoi";
local function SetTitleType(t)
	t = string.lower($1);
	if (titlePatches[t])
		titleType = t;
	end
end

local titleProgress = 0;
local titleProgressTypes = {
	[0] = "scary", -- Scary SUGOI (fresh gamedata)
	[1] = "sugoi", -- SUGOI (loaded Teleport Station)
	[2] = "subarashii", -- SUBARASHII (loaded Joestar Manor)
	[3] = "kimokawaiii", -- KIMOKAWAIII (loaded Gateway Sanctuary)
	[4] = nil, -- Randomized (loaded Credits)
};

local titleCameras = {};

local function SetTitleProgress(t)
	if (t < 0)
		t = 0;
	end
	if (t > 4)
		t = 4;
	end
	titleProgress = t;
end

local function UpdateTitleFile(cv)
	if not (TitleFinishLoading)
		-- Prevent weird OOP
		return;
	end

	local f = io.openlocal("client/sugoi_tt.txt", "w+");
	if (f == nil)
		return;
	end

	local pref = string.lower(cv.string);
	f:write(
		pref, "\n",
		titleProgress, "\n",
		titleRNG
	);

	io.close(f);
end

local cv_titlepref = CV_RegisterVar({
	name = "sugoi_title",
	defaultvalue = "Default",
	flags = CV_SAVE|CV_CALL,
	PossibleValue = {
		Default = -1,
		Random = 0,
		Scary = 1,
		SUGOI = 2,
		SUBARASHII = 3,
		KIMOKAWAIII = 4,
	},
	func = function(cv)
		/*
		if (cv.value > 0)
			SetTitleType(cv.string);
		end
		*/
		UpdateTitleFile(cv);
	end
})

local function LoadTitleFile()
	local f = io.openlocal("client/sugoi_tt.txt", "r");
	if (f)
		local pref = f:read("*l");
		CV_StealthSet(cv_titlepref, pref);

		local progress = tonumber(f:read("*l"));
		if (progress)
			SetTitleProgress(progress);
		end

		-- Reload a saved RNG state,
		-- because SRB2's initalizes to a single value.
		local rng = tonumber(f:read("*l"));
		if (rng)
			titleRNG = scramble(rng);
		end

		io.close(f);
	end
	TitleFinishLoading = true;
end

addHook("MusicChange", function(oldname, newname, mflags, looping, position, prefadems, fadeinms)
	if (newname == "_title")
		if (leveltime < 2 and not TitleFinishLoading)
			return true;
		end

		if (titleType == "scary") // This breaks sound test, siiiigh
		//and not (gamestate == GS_TITLESCREEN and menuactive)
			return "_sugoi";
		end
	end
end)

local titleCameraRotate = (-16 * ANG1 / 64);
addHook("ThinkFrame", function()
	if not (mapheaderinfo[gamemap].sugoititle)
		return;
	end

	-- Title Screens don't draw their patches for a few tics on load.
	-- So instead of putting the default camera in the room...
	-- We have to put the default camera in a black box,
	-- switch to a specific camera, and then fade in.
	-- And because of THAT, we have to manually rotate our cameras...
	local rot = titleCameraRotate;

	if (titleType == "scary")
		rot = -rot/2;
	end

	for _,mo in pairs(titleCameras) do
		if (mo and mo.valid)
			mo.angle = $1 + rot;
		end
	end
end);

addHook("MapLoad", function(map)
	LoadTitleFile();

	-- Pick our new title type.
	local header = mapheaderinfo[map];
	if (header and header.sugoiprogress)
		-- This is a hub, so it updates our title screen.
		local newProgress = tonumber(header.sugoiprogress);
		if (newProgress > titleProgress)
			SetTitleProgress(newProgress);
		end
	end

	local try = "sugoi";
	if (cv_titlepref.value == -1)
		-- DEFAULT: Picked based on progress in the game.
		try = titleProgressTypes[titleProgress];
	elseif (cv_titlepref.value == 0)
		-- RANDOM: Pick whatever.
		try = nil;
	else
		-- User preference.
		try = cv_titlepref.string;
	end

	if (try == nil)
		-- Pick whatever.
		local choice = {"sugoi", "subarashii", "kimokawaiii"};
		try = choice[(titleRNG % #choice) + 1];
	end

	-- Update the title gfx we want to use.
	SetTitleType(try);

	-- Scramble RNG
	titleRNG = scramble($1);

	-- Progress was updated, write to the file.
	UpdateTitleFile(cv_titlepref);

	titleCameras = {};

	local header = mapheaderinfo[map];
	if not (header and header.sugoititle)
		return;
	end

	for mt in mapthings.iterate do
		if (mt.type == mobjinfo[MT_ALTVIEWMAN].doomednum)
		and (mt.mobj and mt.mobj.valid)
			table.insert(titleCameras, mt.mobj);
		end
	end

	if (titleType == "scary")
		P_LinedefExecute(500);
	else
		P_LinedefExecute(501);
	end

	S_ChangeMusic("_title", true);
end);

local function TitleFade(v, offset)
	local fadeIn = min(max(31 - (leveltime - (offset + 2)), 0), 31);
	if (fadeIn > 0)
		v.fadeScreen(0xfa00, fadeIn);
	end
end

hud.add(function(v)
	if not (sugoi.UseTitle)
		return;
	end

	-- Replicate old vanilla title screen,
	-- but we can slot in whatever graphics we want :p

	-- Fade just the BG
	TitleFade(v, 3*TICRATE/2);

	local gfx = titlePatches[titleType];
	if (gfx)
		v.draw(30, 14, v.cachePatch(gfx.ttwing));

		if (leveltime < 57)
			if (leveltime == 35)
				v.draw(115, 15, v.cachePatch(gfx.ttspop1));
			elseif (leveltime == 36)
				v.draw(114, 15, v.cachePatch(gfx.ttspop2));
			elseif (leveltime == 37)
				v.draw(113, 15, v.cachePatch(gfx.ttspop3));
			elseif (leveltime == 38)
				v.draw(112, 15, v.cachePatch(gfx.ttspop4));
			elseif (leveltime == 39)
				v.draw(111, 15, v.cachePatch(gfx.ttspop5));
			elseif (leveltime == 40)
				v.draw(110, 15, v.cachePatch(gfx.ttspop6));
			elseif (leveltime >= 41 and leveltime <= 44)
				v.draw(109, 15, v.cachePatch(gfx.ttspop7));
			elseif (leveltime >= 45 and leveltime <= 48)
				v.draw(108, 12, v.cachePatch(gfx.ttsprep1));
			elseif (leveltime >= 49 and leveltime <= 52)
				v.draw(107, 9, v.cachePatch(gfx.ttsprep2));
			elseif (leveltime >= 53 and leveltime <= 56)
				v.draw(106, 6, v.cachePatch(gfx.ttswip1));
			end

			v.draw(93, 106, v.cachePatch(gfx.ttsonic));
		else
			v.draw(93, 106, v.cachePatch(gfx.ttsonic));

			if ((leveltime / 5) & 1)
				v.draw(100, 3, v.cachePatch(gfx.ttswave1));
			else
				v.draw(100, 3, v.cachePatch(gfx.ttswave2));
			end
		end

		v.draw(48, 142, v.cachePatch(gfx.ttbanner));
	end

	-- Fade everything
	TitleFade(v, 0);
end, "title");

freeslot(
	"SPR_STSS",
	"MT_TITLE_SANCTUARY",
	"S_TITLE_SANCTUARY",
	"MT_TITLE_DIMENSION",
	"S_TITLE_DIMENSION",
	"MT_TITLE_SHADOW",
	"S_TITLE_SHADOW"
);

mobjinfo[MT_TITLE_SANCTUARY] = {
	--$Name Titlemap Gateway Sanctuary
	--$Sprite STSSA0
	--$Category SUGOI Decoration
	doomednum = 3506,
	spawnstate = S_TITLE_SANCTUARY,
	spawnhealth = 1000,
	radius = 16*FRACUNIT,
	height = 48*FRACUNIT,
	flags = MF_NOTHINK|MF_NOBLOCKMAP|MF_NOGRAVITY
}
states[S_TITLE_SANCTUARY] = {SPR_STSS, A, -1, nil, 0, 0, S_NULL}

mobjinfo[MT_TITLE_DIMENSION] = {
	--$Name Titlemap Gateway Dimension
	--$Sprite STSSB0
	--$Category SUGOI Decoration
	doomednum = 3507,
	spawnstate = S_TITLE_DIMENSION,
	spawnhealth = 1000,
	radius = 16*FRACUNIT,
	height = 48*FRACUNIT,
	flags = MF_NOTHINK|MF_NOBLOCKMAP|MF_NOGRAVITY
}
states[S_TITLE_DIMENSION] = {SPR_STSS, B, -1, nil, 0, 0, S_NULL}

mobjinfo[MT_TITLE_SHADOW] = {
	--$Name Titlemap Shadow Realm
	--$Sprite STSSC0
	--$Category SUGOI Decoration
	doomednum = 3508,
	spawnstate = S_TITLE_SHADOW,
	spawnhealth = 1000,
	radius = 16*FRACUNIT,
	height = 48*FRACUNIT,
	flags = MF_NOTHINK|MF_NOBLOCKMAP|MF_NOGRAVITY
}
states[S_TITLE_SHADOW] = {SPR_STSS, C|FF_ADD, -1, nil, 0, 0, S_NULL}

local function biggify(mo)
	mo.destscale = $1 << 1;
	P_SetScale(mo, mo.scale << 1);

	if (mapheaderinfo[gamemap].creditsmap and mo.type != MT_TITLE_SHADOW)
		mo.destscale = $1 << 1;
		P_SetScale(mo, mo.scale << 1);
	end
end

addHook("MobjSpawn", biggify, MT_TITLE_SANCTUARY);
addHook("MobjSpawn", biggify, MT_TITLE_DIMENSION);
addHook("MobjSpawn", biggify, MT_TITLE_SHADOW);
