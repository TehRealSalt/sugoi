freeslot(
	"MT_LEVELSPOT",
	"S_LEVELSPOT",
	"SPR_LVLA",
	"SPR_LVLB",
	"SPR_LVLC",

	"MT_LEVELPORTAL",
	"S_LEVELPORTAL",
	"S_BOSSPORTAL",
	"S_DISABLEDPORTAL",

	"MT_LEVELLIGHT",
	"S_LEVELLIGHT1",
	"S_LEVELLIGHT2",
	"SPR_MAPP",

	"MT_LEVELSPARKLE",
	"S_LEVELSPARKLE1",
	"S_LEVELSPARKLE2",
	"S_LEVELSPARKLE3",
	"S_LEVELSPARKLE4",
	"S_BOSSSPARKLE1",
	"S_BOSSSPARKLE2",
	"S_BOSSSPARKLE3",
	"S_BOSSSPARKLE4",
	"SPR_HSPK",

	"MT_LEVELSPARKLESPAWNER"
)

mobjinfo[MT_LEVELSPOT] = {
	--$Name Level Portal
	--$Sprite LVLAA0
	--$Category SUGOI Hub
	--$AngleText Map Num
	doomednum = 3501,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1000,
	radius = 48*FRACUNIT,
	height = 96*FRACUNIT,
	flags = MF_SPECIAL|MF_NOGRAVITY
}

states[S_LEVELSPOT] = {SPR_LVLA, FF_FULLBRIGHT|FF_TRANS20, -1, nil, 0, 0, S_LEVELSPOT}

mobjinfo[MT_LEVELPORTAL] = {
	spawnstate = S_LEVELPORTAL,
	spawnhealth = 1000,
	radius = 16*FRACUNIT,
	height = 12*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY|MF_SCENERY
}

states[S_LEVELPORTAL] = {SPR_MAPP, FF_FLOORSPRITE|FF_FULLBRIGHT|FF_ANIMATE, -1, nil, 2, 3, S_NULL}
states[S_BOSSPORTAL] = {SPR_MAPP, FF_FLOORSPRITE|FF_FULLBRIGHT|FF_ANIMATE|3, -1, nil, 2, 3, S_NULL}
states[S_DISABLEDPORTAL] = {SPR_MAPP, FF_FLOORSPRITE|FF_SEMIBRIGHT|FF_ANIMATE|6, -1, nil, 2, 3, S_NULL}

mobjinfo[MT_LEVELLIGHT] = {
	spawnstate = S_LEVELLIGHT1,
	spawnhealth = 1000,
	radius = 16*FRACUNIT,
	height = 16*FRACUNIT,
	dispoffset = 1,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY|MF_SCENERY
}

states[S_LEVELLIGHT1] = {SPR_MAPP, FF_ADD|FF_FULLBRIGHT|FF_TRANS80|9, 1, nil, 0, 0, S_LEVELLIGHT2}
states[S_LEVELLIGHT2] = {SPR_MAPP, FF_ADD|FF_FULLBRIGHT|FF_TRANS90|9, 1, nil, 0, 0, S_LEVELLIGHT1}

mobjinfo[MT_LEVELSPARKLE] = {
	spawnstate = S_LEVELSPARKLE1,
	spawnhealth = 1000,
	radius = 16*FRACUNIT,
	height = 16*FRACUNIT,
	dispoffset = 1,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY|MF_SCENERY
}

states[S_LEVELSPARKLE1] = {SPR_HSPK, FF_FULLBRIGHT, 3, nil, 0, 0, S_LEVELSPARKLE2}
states[S_LEVELSPARKLE2] = {SPR_HSPK, FF_FULLBRIGHT|1, 3, nil, 0, 0, S_LEVELSPARKLE3}
states[S_LEVELSPARKLE3] = {SPR_HSPK, FF_FULLBRIGHT|2, 3, nil, 0, 0, S_LEVELSPARKLE4}
states[S_LEVELSPARKLE4] = {SPR_HSPK, FF_FULLBRIGHT, 3, nil, 0, 0, S_NULL}

states[S_BOSSSPARKLE1] = {SPR_HSPK, FF_FULLBRIGHT|3, 3, nil, 0, 0, S_BOSSSPARKLE2}
states[S_BOSSSPARKLE2] = {SPR_HSPK, FF_FULLBRIGHT|4, 3, nil, 0, 0, S_BOSSSPARKLE3}
states[S_BOSSSPARKLE3] = {SPR_HSPK, FF_FULLBRIGHT|5, 3, nil, 0, 0, S_BOSSSPARKLE4}
states[S_BOSSSPARKLE4] = {SPR_HSPK, FF_FULLBRIGHT|3, 3, nil, 0, 0, S_NULL}

mobjinfo[MT_LEVELSPARKLESPAWNER] = {
	--$Name Level Sparkle Spawner
	--$Sprite HSPKA0
	--$Category SUGOI Hub
	--$AngleText Map Num
	doomednum = 3502,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1000,
	radius = 16*FRACUNIT,
	height = 16*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY
}

local PORTALDISABLE_GAMETYPE = 1;
local PORTALDISABLE_LOCKED = 2;

local ADD_HEIGHT = 72*FRACUNIT; -- 64*FRACUNIT;

local function levelPortalSpawn(mo, mt)
	if not (mt and mt.valid)
	or not (gametyperules & GTR_CAMPAIGN)
		P_RemoveMobj(mo);
		return;
	end

	local map = mt.angle;
	local lock = mt.extrainfo;

	local start = 0;
	local sprite = 0;
	if (mapheaderinfo[gamemap])
		if (mapheaderinfo[gamemap].portalstart)
			start = tonumber(mapheaderinfo[gamemap].portalstart)
		end
		if (mapheaderinfo[gamemap].portalsprite)
			sprite = tonumber(mapheaderinfo[gamemap].portalsprite)
		end
		if (lock > 0 and mapheaderinfo[gamemap].portallock)
			lock = $1 + tonumber(mapheaderinfo[gamemap].portallock) - 1;
		end
	end

	map = $1 + start;

	if (map <= 0) or not (mapheaderinfo[map])
		P_RemoveMobj(mo);
		print("Invalid portal map "..G_BuildMapName(map));
		return;
	end

	local base = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_LEVELPORTAL);
	base.renderflags = $1 | RF_NOSPLATBILLBOARD;

	base.destscale = $1 * 3;
	P_SetScale(base, base.destscale);

	if (lock > 0 and not sugoi.Unlocked[lock])
		base.state = S_DISABLEDPORTAL;
		P_RemoveMobj(mo);
		return;
	end

	mo.state = S_LEVELSPOT;

	local m = map - 1 - start;
	mo.sprite = SPR_LVLA + sprite + (m / 26);
	mo.frame = ($1 & ~FF_FRAMEMASK) | (m % 26);

	if not (mapheaderinfo[map].typeoflevel & sugoi.tol(gametype))
		mo.portaldisable = PORTALDISABLE_GAMETYPE;
	end

	mo.lvl = map;

	if (mo.portaldisable)
		base.state = S_DISABLEDPORTAL;
	elseif (mapheaderinfo[mo.lvl].levelflags & LF_WARNINGTITLE)
		base.state = S_BOSSPORTAL;
	end

	P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_LEVELLIGHT);

	if (mo.portaldisable)
		mo.flags2 = $1|MF2_SHADOW;
	elseif not (sugoi.mapChecks[mo.lvl])
		-- Made its own separate object, since we want it for the
		-- sector-based portals in SUGOI and SUBARASHII too!
		local sparks = P_SpawnMobjFromMobj(mo, 0, 0, ADD_HEIGHT, MT_LEVELSPARKLESPAWNER);
		sparks.lvl = mo.lvl;
	end

	mo.portalz = mo.z;
	mo.z = $1 + (FixedMul(ADD_HEIGHT, mo.scale) * P_MobjFlip(mo));
end

--addHook("MapThingSpawn", levelPortalSpawn, MT_LEVELSPOT);

addHook("MobjThinker", function(mo)
	if (mo.lvl == nil)
		-- More OOP weirdness
		if (leveltime >= 2)
			levelPortalSpawn(mo, mo.spawnpoint);
		end

		return;
	end

	if (mo.portalz == nil)
		mo.portalz = mo.floorz;
	end

	local amp = 8;
	local speed = 2*TICRATE;
	local pi = 22*FRACUNIT/7;
	local sine = amp * sin((2*pi*speed) * (leveltime + (mo.lvl^2)));

	mo.z = (mo.portalz + FixedMul(ADD_HEIGHT, mo.scale)) + sine;

	if (mo.reactiontime > 0)
		mo.reactiontime = $1 - 1;
	end
end, MT_LEVELSPOT)

addHook("TouchSpecial", function(mo, toucher)
	if not (mo.lvl)
		return;
	end

	if (mo.portaldisable)
		if (toucher.player and not mo.reactiontime)
			if (mo.portaldisable == PORTALDISABLE_GAMETYPE)
				local gtstr = "Coop"; -- too lazy to add the others
				CONS_Printf(toucher.player, "This level does not support "..gtstr.." mode.");
			elseif (mo.portaldisable == PORTALDISABLE_LOCKED)
				-- Now unused, oh well
				CONS_Printf(toucher.player, "This level needs to be unlocked.");
			end
		end

		mo.reactiontime = TICRATE;
	else
		sugoi.StartVote(toucher.player, mo.lvl, 0);
	end

	return true;
end, MT_LEVELSPOT)

addHook("MobjThinker", function(mo)
	if (mo.lvl == nil)
	and (mo.spawnpoint and mo.spawnpoint.valid)
		mo.lvl = mo.spawnpoint.angle;
	end

	if not (mapheaderinfo[mo.lvl])
	or not (mapheaderinfo[mo.lvl].typeoflevel & sugoi.tol(gametype))
	or ((sugoi.mapChecks[mo.lvl]) and (leveltime >= 2))
		P_RemoveMobj(mo);
		return;
	end

	if (leveltime < 2)
		return;
	end

	if (leveltime % 4 == 0)
		local dist = P_RandomRange(0,80) * FRACUNIT;
		local hang = FixedAngle(P_RandomRange(-180,180) * FRACUNIT);
		local vang = FixedAngle(P_RandomRange(-180,180) * FRACUNIT);

		local sparkle = P_SpawnMobjFromMobj(
			mo,
			FixedMul(FixedMul(dist, cos(hang)), cos(vang)),
			FixedMul(FixedMul(dist, sin(hang)), cos(vang)),
			(64 << FRACBITS) + FixedMul(dist, sin(vang)),
			MT_LEVELSPARKLE
		);

		sparkle.scale = 2*FRACUNIT
		sparkle.destscale = sparkle.scale

		if (mapheaderinfo[mo.lvl].levelflags & LF_WARNINGTITLE)
			sparkle.state = S_BOSSSPARKLE1
		end
	end
end, MT_LEVELSPARKLESPAWNER)
