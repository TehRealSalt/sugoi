--
-- HYPER HOGAN HEAD
-- Unlocks Area X
--
freeslot(
	"MT_SUGOIHYPERHOGAN",
	"S_SUGOIHYPERHOGAN",
	"SPR_HHGN"
);

mobjinfo[MT_SUGOIHYPERHOGAN] = {
	--$Name Hyper Hogan Head
	--$Sprite HHGNA0
	--$Category SUGOI Powerups
	doomednum = 2041,
	spawnstate = S_SUGOIHYPERHOGAN,
	deathstate = S_SPRK1,
	deathsound = sfx_token,
	radius = 21*FRACUNIT,
	height = 42*FRACUNIT,
	flags = MF_SPECIAL|MF_NOGRAVITY|MF_NOCLIPHEIGHT
}

states[S_SUGOIHYPERHOGAN] = {SPR_HHGN, A|FF_ANIMATE, -1, nil, 9, 2, S_SUGOIHYPERHOGAN}

addHook("MobjDeath", function(mo, no, pmo)
	-- solely for activating a condition set trigger
	-- i wish i could just set these via lua directly...
	local hogantag = 8000;
	P_LinedefExecute(hogantag, pmo);
end, MT_SUGOIHYPERHOGAN)

--
-- TINY TOILET
-- Because toilet humor.
--
freeslot(
	"MT_SUGOITOILET",
	"S_SUGOITOILET",
	"SPR_TOIL"
);

mobjinfo[MT_SUGOITOILET] = {
	--$Name Tiny Toilet
	--$Sprite TOILA0
	--$Category SUGOI Decoration
	doomednum = 2042,
	spawnstate = S_SUGOITOILET,
	radius = 9*FRACUNIT,
	height = 27*FRACUNIT,
	flags = MF_SOLID
}

states[S_SUGOITOILET] = {SPR_TOIL, A, -1, nil, 0, 0, S_SUGOITOILET}

--
-- WATERFALL DROP SPAWNER
-- From KIMOKAWAIII
--
freeslot(
	"MT_WATERFALLDROPSPAWNER",
	"MT_WATERFALLDROP",
	"S_WATERFALLDROP",
	"S_WATERFALLDROPSPLISH1",
	"S_WATERFALLDROPSPLISH2",
	"S_WATERFALLDROPSPLISH3",
	"S_WATERFALLDROPSPLISH4",
	"S_WATERFALLDROPSPLISH5",
	"S_WATERFALLDROPSPLISH6",
	"S_WATERFALLDROPSPLISH7",
	"S_WATERFALLDROPSPLISH8",
	"S_WATERFALLDROPSPLISH9",
	"SPR_WFDP"
);

mobjinfo[MT_WATERFALLDROPSPAWNER] = {
	--$Name Gateway Waterfall Spot
	--$Sprite SPLHB0
	--$Category SUGOI Decoration
	doomednum = 3511,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1000,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY|MF_SCENERY
}

mobjinfo[MT_WATERFALLDROP] = {
	spawnstate = S_WATERFALLDROP,
	deathstate = S_WATERFALLDROPSPLISH1,
	spawnhealth = 1,
	radius = FRACUNIT,
	height = FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOCLIPHEIGHT|MF_SCENERY
}

states[S_WATERFALLDROP] = {SPR_WFDP, FF_ADD|FF_FULLBRIGHT|FF_TRANS80, -1, nil, 0, 0, S_NULL}
states[S_WATERFALLDROPSPLISH1] = {SPR_WFDP, FF_ADD|FF_FULLBRIGHT|FF_TRANS80|1, 2, nil, 0, 0, S_WATERFALLDROPSPLISH2}
states[S_WATERFALLDROPSPLISH2] = {SPR_WFDP, FF_ADD|FF_FULLBRIGHT|FF_TRANS80|2, 2, nil, 0, 0, S_WATERFALLDROPSPLISH3}
states[S_WATERFALLDROPSPLISH3] = {SPR_WFDP, FF_ADD|FF_FULLBRIGHT|FF_TRANS80|3, 2, nil, 0, 0, S_WATERFALLDROPSPLISH4}
states[S_WATERFALLDROPSPLISH4] = {SPR_WFDP, FF_ADD|FF_FULLBRIGHT|FF_TRANS80|4, 2, nil, 0, 0, S_WATERFALLDROPSPLISH5}
states[S_WATERFALLDROPSPLISH5] = {SPR_WFDP, FF_ADD|FF_FULLBRIGHT|FF_TRANS80|5, 2, nil, 0, 0, S_WATERFALLDROPSPLISH6}
states[S_WATERFALLDROPSPLISH6] = {SPR_WFDP, FF_ADD|FF_FULLBRIGHT|FF_TRANS80|6, 2, nil, 0, 0, S_WATERFALLDROPSPLISH7}
states[S_WATERFALLDROPSPLISH7] = {SPR_WFDP, FF_ADD|FF_FULLBRIGHT|FF_TRANS80|7, 2, nil, 0, 0, S_WATERFALLDROPSPLISH8}
states[S_WATERFALLDROPSPLISH8] = {SPR_WFDP, FF_ADD|FF_FULLBRIGHT|FF_TRANS80|8, 2, nil, 0, 0, S_WATERFALLDROPSPLISH9}
states[S_WATERFALLDROPSPLISH9] = {SPR_WFDP, FF_ADD|FF_FULLBRIGHT|FF_TRANS80|9, 2, nil, 0, 0, S_NULL}

addHook("MobjThinker", function(mo)
	if (mapheaderinfo[gamemap].creditsmap)
		mo.scale = FRACUNIT/2
	end

	if not (leveltime % 3 == 0) return end
	local spawnoffset = P_RandomRange(-96,96) * mo.scale
	local offx = FixedMul(spawnoffset, cos(mo.angle+ANGLE_90))
	local offy = FixedMul(spawnoffset, sin(mo.angle+ANGLE_90))
	local droplet = P_SpawnMobj(mo.x + offx, mo.y + offy, mo.z+1, MT_WATERFALLDROP)
	P_SetScale(droplet, 4 * mo.scale)
	droplet.destscale = droplet.scale
	P_Thrust(droplet, FixedAngle(P_RandomRange(0,359)<<FRACBITS), (P_RandomRange(1,48)*mo.scale)/8)
	P_SetObjectMomZ(droplet, (P_RandomRange(1,48)*mo.scale)/8, true)
	droplet.movefactor = mo.z
end, MT_WATERFALLDROPSPAWNER)

addHook("MobjThinker", function(mo)
	if not (mo.health) return end
	if (mo.z <= mo.movefactor or P_IsObjectOnGround(mo))
		mo.flags = $|MF_NOGRAVITY
		mo.momx = 0
		mo.momy = 0
		mo.momz = 0
		mo.health = 0
		mo.state = mo.info.deathstate
	end
end, MT_WATERFALLDROP)

--
-- SKINCOLOR_DOGGIE
-- For Shogun Stronghold emblem, but also just for fun.
--
freeslot("SKINCOLOR_DOGGIE");
skincolors[SKINCOLOR_DOGGIE] = {
    name = "Doggie",
    ramp = {0,252,176,200,201,202,193,194,195,196,196,197,197,198,199,253},
    invcolor = SKINCOLOR_SAPPHIRE,
    invshade = 5,
    chatcolor = V_ROSYMAP,
    accessible = true -- false
}
