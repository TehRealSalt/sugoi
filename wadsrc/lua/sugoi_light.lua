freeslot(
	"MT_HUB_GHOST",
	"S_HUB_GHOST",
	"S_HUB_GHOST_DIE",
	"S_HUB_GHOST_DIE2",
	"SPR_HBOO",

	"MT_HUB_WORD",
	"S_HUB_WORD",
	"SPR_HFNT",
	"SPR_HNUM"
);

mobjinfo[MT_HUB_GHOST] = {
	--$Name Shadow of Hyudoro
	--$Sprite HBOOA0
	--$Category SUGOI Hub
	doomednum = 3512,
	spawnstate = S_HUB_GHOST,
	deathstate = S_HUB_GHOST_DIE,
	deathsound = sfx_s3k8a,
	radius = 16*FRACUNIT,
	height = 24*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY|MF_SCENERY
}

states[S_HUB_GHOST] = {SPR_HBOO, A|FF_ANIMATE|FF_RANDOMANIM|FF_FULLBRIGHT, -1, nil, 2, 2, S_HUB_GHOST}
states[S_HUB_GHOST_DIE] = {SPR_HBOO, A|FF_FULLBRIGHT, 24, nil, 0, 0, S_HUB_GHOST_DIE2}
states[S_HUB_GHOST_DIE2] = {SPR_HBOO, D|FF_ANIMATE|FF_FULLBRIGHT, 10, nil, 4, 2, S_NULL}

mobjinfo[MT_HUB_WORD] = {
	spawnstate = S_HUB_WORD,
	radius = 3*FRACUNIT,
	height = 6*FRACUNIT,
	flags = MF_SCENERY|MF_NOBLOCKMAP|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOCLIPTHING|MF_NOGRAVITY
}
states[S_HUB_WORD] = {SPR_HFNT, A|FF_FULLBRIGHT|FF_PAPERSPRITE, -1, nil, 0, 0, S_NULL}

sugoi.LightTags = {6000, 6001, 6002, 6003};

sugoi.SectorBright = {};
sugoi.DarknessGhosts = {};

local DARK_LEVEL = 112;
local FADE_TIME = TICRATE >> 2;
local LIGHT_FREQ = TICRATE >> 1;
local LIGHT_WAIT = TICRATE - FADE_TIME;

local FADE_TEMP_TAG = 5999;

function sugoi.DarkenHub(map)
	sugoi.SectorBright = {};
	sugoi.DarknessGhosts = {};

	if not (mapheaderinfo[map].hubdarken)
		return;
	end

	for _,tag in ipairs(sugoi.LightTags) do
		for sec in sectors.tagged(tag) do
			if not (sec and sec.valid)
				continue;
			end

			if (sugoi.SectorBright[#sec])
				-- Don't double-darken with multi-tags.
				continue;
			end

			sugoi.SectorBright[#sec] = sec.lightlevel;
			sec.lightlevel = DARK_LEVEL;
		end
	end

	for mt in mapthings.iterate do
		if (mt.type == mobjinfo[MT_HUB_GHOST].doomednum)
		and (mt.mobj and mt.mobj.valid)
			local id = mt.angle;
			if (sugoi.DarknessGhosts[id + 1] == nil)
				sugoi.DarknessGhosts[id + 1] = {};
			end

			table.insert(sugoi.DarknessGhosts[id + 1], mt.mobj);
			mt.mobj.cvmem = $1 + id;
		end
	end
end

function sugoi.LightenTag(tag)
	for sec in sectors.tagged(tag) do
		if not (sec and sec.valid)
			continue;
		end

		if not (sugoi.SectorBright[#sec])
			-- Wasn't init.
			continue;
		end

		-- It'd be NICE if we had P_FadeLightBySector ...
		taglist.add(sec.taglist, FADE_TEMP_TAG);
		P_FadeLight(FADE_TEMP_TAG, sugoi.SectorBright[#sec], FADE_TIME, true, true);
		taglist.remove(sec.taglist, FADE_TEMP_TAG);
	end
end

function sugoi.KillHubGhost(id)
	local ghost_list = sugoi.DarknessGhosts[id];
	if (ghost_list == nil)
		return;
	end

	for _,ghost in pairs(ghost_list) do
		if (ghost and ghost.valid and ghost.health > 0)
			S_StartSound(ghost, ghost.info.deathsound);
			P_KillMobj(ghost);
			ghost.health = 0;
		end
	end
end

function sugoi.HubLightThink()
	local t = leveltime - LIGHT_WAIT;
	if (t <= 0)
		return;
	end

	if (t % LIGHT_FREQ != 0)
		return;
	end

	local numTags = #(sugoi.LightTags);
	local i = t / LIGHT_FREQ;
	if (i <= 0 or i > numTags)
		return;
	end

	local lock = 0;
	if (mapheaderinfo[gamemap].portallock)
		lock = tonumber(mapheaderinfo[gamemap].portallock);
	end

	if (sugoi.Unlocked[lock + i - 1])
		sugoi.LightenTag(sugoi.LightTags[i]);
		sugoi.KillHubGhost(i);
	end
end

local HUB_STRINGS = {
	[14] = { "LAKE", 47 },
	[15] = { "ISLANDS", 55 },
	[16] = { "MOUNTAIN", 60 },
	[17] = { "SUMMIT", 65 },
	[18] = { "HIDDEN BASE", 80 },

	[19] = { "ARCHES", 70 },
	[20] = { "TOWERS", 75 },
	[21] = { "FINALE", 80 },
	[22] = { "EXTRA REEL", 140 },
};

local function RegularPolygonInradius(length, n)
	return FixedDiv(length, 2 * tan(ANGLE_180 / n));
end

local function RegularPolygonCircumradius(length, n)
	return FixedDiv(length, 2 * abs(sin(ANGLE_180 / n)));
end

local GHOST_LETTER_SCALE = 3 * 2;

local HUB_FONT_DIST = 32;
local HUB_FONT_WIDTH = 5 * FRACUNIT * GHOST_LETTER_SCALE;
local HUB_FONT_INRADIUS = RegularPolygonInradius(HUB_FONT_WIDTH, HUB_FONT_DIST);
local HUB_FONT_CIRCUM = RegularPolygonCircumradius(HUB_FONT_WIDTH, HUB_FONT_DIST);
local HUB_FONT_ANGLE = FixedAngle(360 * FRACUNIT / HUB_FONT_DIST);

local HUB_NUM_DIST = 20;
local HUB_NUM_WIDTH = 8 * FRACUNIT * GHOST_LETTER_SCALE;
local HUB_NUM_INRADIUS = RegularPolygonInradius(HUB_NUM_WIDTH, HUB_NUM_DIST);
local HUB_NUM_CIRCUM = RegularPolygonCircumradius(HUB_NUM_WIDTH, HUB_NUM_DIST);
local HUB_NUM_ANGLE = FixedAngle(360 * FRACUNIT / HUB_NUM_DIST);

local A_BYTE = string.byte("A");
local Z_BYTE = string.byte("Z");

addHook("MobjSpawn", function(mo)
	if (mapheaderinfo[gamemap].portallock)
		local lock = tonumber(mapheaderinfo[gamemap].portallock);
		mo.cvmem = $1 + lock;
	end

	mo.extravalue1 = mo.z + (96 * FRACUNIT);
	mo.scale = 3 * mo.scale;
end, MT_HUB_GHOST);

addHook("MobjThinker", function(mo)
	if (leveltime < 2)
		return;
	end

	mo.angle = $1 + ANG1;
	mo.z = mo.extravalue1 + (6 * sin(leveltime * ANG10));

	if (mo.state == S_HUB_GHOST_DIE)
		mo.spritexoffset = P_RandomRange(-6, 6) * FRACUNIT;
		mo.spriteyoffset = P_RandomRange(-6, 6) * FRACUNIT;
	else
		mo.spritexoffset = 0;
		mo.spriteyoffset = 0;
	end

	if (mo.health <= 0)
		if (mo.hubLetters != nil)
			if (mo.hubLetters[1] != nil)
				for i,part in pairs(mo.hubLetters[1]) do
					if (part and part.valid)
						P_InstaThrust(part, part.angle - ANGLE_90, 2 + P_RandomRange(0, 8) * FRACUNIT);
						part.momz = (16 + P_RandomRange(0, 8)) * FRACUNIT;
						part.flags = $1 & ~MF_NOGRAVITY;
						part.fuse = 24;
					end
				end
			end

			if (mo.hubLetters[2] != nil)
				for i,part in pairs(mo.hubLetters[2]) do
					if (part and part.valid)
						P_InstaThrust(part, part.angle - ANGLE_90, 2 + P_RandomRange(0, 8) * FRACUNIT);
						part.momz = (16 + P_RandomRange(0, 8)) * FRACUNIT;
						part.flags = $1 & ~MF_NOGRAVITY;
						part.fuse = 24;
					end
				end
			end

			mo.hubLetters = nil;
		end

		return;
	end

	if (mo.cvmem == 0)
		return;
	end

	local lock_info = HUB_STRINGS[mo.cvmem];
	if (lock_info == nil)
		return;
	end

	local lock_string = lock_info[1];
	local lock_count = lock_info[2];

	if (mo.hubLetters == nil)
		mo.hubLetters = {};
	end

	local letter_objs = mo.hubLetters[1];
	if (letter_objs == nil)
		mo.hubLetters[1] = {};
		letter_objs = mo.hubLetters[1];
	end

	local a = mo.angle;
	for i = 1,string.len(lock_string) do
		local i_byte = string.byte(lock_string, i);
		if (i_byte < A_BYTE or i_byte > Z_BYTE)
			a = $1 + HUB_FONT_ANGLE;
			continue;
		end

		local part = letter_objs[i];

		local offset = {
			x = mo.x,
			y = mo.y,
			z = mo.z + (mo.height / 2),
		};

		offset.x = $1 + FixedMul(HUB_FONT_INRADIUS, cos(a));
		offset.y = $1 + FixedMul(HUB_FONT_INRADIUS, sin(a));
		offset.z = $1 - (12 * sin((leveltime + i) * ANG10));

		if not (part and part.valid)
			part = P_SpawnMobj(offset.x, offset.y, offset.z, MT_HUB_WORD);
			part.frame = $1 + (i_byte - A_BYTE);
			part.scale = mo.scale * 2;
			part.target = mo;
			letter_objs[i] = part;
		else
			P_MoveOrigin(part, offset.x, offset.y, offset.z);
		end

		part.angle = a - ANGLE_90;

		a = $1 + HUB_FONT_ANGLE;
	end

	local work = lock_count;
	local numbers = {};
	while (work > 0)
		table.insert(numbers, 1, work % 10);
		work = $1 / 10;
	end

	local number_objs = mo.hubLetters[2];
	if (number_objs == nil)
		mo.hubLetters[2] = {};
		number_objs = mo.hubLetters[2];
	end

	a = mo.angle + ANGLE_180;
	for i = 1,#numbers+1 do
		local new_frame = K;
		if (i > 1)
			new_frame = numbers[i - 1];
		end

		local part = number_objs[i];

		local offset = {
			x = mo.x,
			y = mo.y,
			z = mo.z + (mo.height / 2),
		};

		offset.x = $1 + FixedMul(HUB_NUM_INRADIUS, cos(a));
		offset.y = $1 + FixedMul(HUB_NUM_INRADIUS, sin(a));
		offset.z = $1 - (12 * sin((leveltime + i) * ANG10));

		if not (part and part.valid)
			part = P_SpawnMobj(offset.x, offset.y, offset.z, MT_HUB_WORD);
			part.sprite = SPR_HNUM;
			part.frame = $1 + new_frame;
			part.scale = mo.scale * 2;
			part.target = mo;
			number_objs[i] = part;
		else
			P_MoveOrigin(part, offset.x, offset.y, offset.z);
		end

		part.angle = a - ANGLE_90;

		a = $1 + HUB_NUM_ANGLE;
		if (new_frame == K)
			a = $1 + HUB_NUM_ANGLE;
		end
	end
end, MT_HUB_GHOST);

addHook("MobjThinker", function(mo)
	if (mo.fuse > 0)
		mo.flags2 = $1 ^^ MF2_DONTDRAW;
	end
end, MT_HUB_WORD);
