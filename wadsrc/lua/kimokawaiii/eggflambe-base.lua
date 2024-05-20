freeslot(
	"MT_EGGOFLAMER",
	"S_EGGOFLAMER_HOVER0",
	"S_EGGOFLAMER_HOVER1",
	"S_EGGOFLAMER_HOVER2",
	"S_EGGOFLAMER_FLAME",
	"S_EGGOFLAMER_FLAME1",
	"S_EGGOFLAMER_FLAME2",
	"S_EGGOFLAMER_FLAME6",
	"S_EGGOFLAMER_FLAME7",
	"S_EGGOFLAMER_FLAME8",
	"S_EGGOFLAMER_BOMB",
	"S_EGGOFLAMER_BOMB1",
	"S_EGGOFLAMER_BOMB2",
	"S_EGGOFLAMER_BOMB3",
	"S_EGGOFLAMER_BOMB4",
	"S_EGGOFLAMER_BOMB5",
	"S_EGGOFLAMER_BOMB6",
	"S_EGGOFLAMER_BOMB7",
	"S_EGGOFLAMER_BOMB8",
	"S_EGGOFLAMER_COMBO",
	"S_EGGOFLAMER_COMBO1",
	"S_EGGOFLAMER_COMBO2",
	"S_EGGOFLAMER_COMBO3",
	"S_EGGOFLAMER_COMBO4",
	"S_EGGOFLAMER_COMBO5",
	"S_EGGOFLAMER_COMBO6",
	"S_EGGOFLAMER_COMBO7",
	"S_EGGOFLAMER_COMBO8",
	"S_EGGOFLAMER_COMBO9",
	"S_EGGOFLAMER_COMBO10",
	"S_EGGOFLAMER_COMBO11",
	"S_EGGOFLAMER_COMBO12",
	"S_EGGOFLAMER_COMBO13",
	"S_EGGOFLAMER_COMBO14",
	"S_EGGOFLAMER_COMBOM",
	"S_EGGOFLAMER_HIT",
	"S_EGGOFLAMER_HIT2",
	"S_EGGOFLAMER_KABOOM",
	"S_EGGOFLAMER_KABOOM1",
	"S_EGGOFLAMER_KABOOM2",
	"S_EGGOFLAMER_KABOOM3",
	"S_EGGOFLAMER_KABOOM4",
	"S_EGGOFLAMER_KABOOM5",
	"S_EGGOFLAMER_KABOOM6",
	"S_EGGOFLAMER_KABOOM7",
	"S_EGGOFLAMER_KABOOM8",
	"S_EGGOFLAMER_KABOOM9",
	"S_EGGOFLAMER_KABOOM10",
	"S_EGGOFLAMER_KABOOM11",
	"S_EGGOFLAMER_KABOOM12",
	"S_EGGOFLAMER_KABOOM13",
	"S_EGGOFLAMER_RUNAWAY",
	"S_EGGOFLAMER_RUNAWAY1",
	"S_EGGOFLAMER_BOMB_HAULT",
	"S_EGGOFLAMER_FLAME_HAULT",
	"S_EGGOCALMDOWN",
	"S_EGGOFLAMER_PANICATTACK1",
	"S_EGGOFLAMER_PANICATTACK2",
	"S_EGGOFLAMER_PANICATTACK3",
	"S_EGGOFLAMER_PANICATTACK4",
	-- Sal: more because there was a weird beta version causing conflicts that I removed...
	"SPR_EGGF",
	"MT_FLAMETHROWERFLAME",
	"S_THROWNFLAME1",
	"S_THROWNFLAME2",
	"S_THROWNFLAME3"
)

//Special Thanks to Monster Iestyn, Flare, Flame, and anyone else on #scripting who helped make this possible.

addHook("MobjSpawn", function(mo)
    mo.jetfume1 = P_SpawnMobj(mo.x, mo.y, mo.z, MT_JETFUMEC2)
	mo.jetfume2 = P_SpawnMobj(mo.x, mo.y, mo.z, MT_JETFUMEC2)
	mo.jetfume3 = P_SpawnMobj(mo.x, mo.y, mo.z, MT_JETFUMEC2)
	mo.jetfume1.target = mo
	mo.jetfume2.target = mo
	mo.jetfume3.target = mo
end, MT_EGGOFLAMER)

-- Sal: something about the state logic is preventing MF2_FRET from getting removed.
-- I could not find the issue, so just fix it if it happens for too long.

-- This boss has a variable number of FRET frames, even without the bug.
-- So the following value is just based on vibes:
local fretSoftLock = 4*TICRATE;

local function FretSoftLockHack(mo)
	if (mo.fretTime == nil)
		mo.fretTime = 0;
	end

	if (mo.flags2 & MF2_FRET)
		if (mo.fretTime == 0)
			mo.fretTime = fretSoftLock + 1;
		else
			mo.fretTime = $1 - 1;

			if (mo.fretTime <= 1)
				mo.flags2 = ($1 & ~MF2_FRET);
				mo.fretTime = 0;
			end
		end
	else
		mo.fretTime = 0;
	end
end

addHook("MobjThinker", function(mo)
    if mo.jetfume1 and mo.jetfume1.valid then
		P_MoveOrigin(mo.jetfume1, mo.x - 54 * cos(mo.angle), mo.y - 54 * sin(mo.angle), mo.z + (40*FRACUNIT))
    end
    if mo.jetfume2 and mo.jetfume2.valid then
		P_MoveOrigin(mo.jetfume2, mo.x - 54 * cos(mo.angle) - 22*cos(mo.angle-ANGLE_90), mo.y - 54 * sin(mo.angle) - 22*sin(mo.angle-ANGLE_90), mo.z + (12*FRACUNIT))
    end
    if mo.jetfume3 and mo.jetfume3.valid then
		P_MoveOrigin(mo.jetfume3, mo.x - 54 * cos(mo.angle) - 22*cos(mo.angle+ANGLE_90), mo.y - 54 * sin(mo.angle) - 22*sin(mo.angle+ANGLE_90), mo.z + (12*FRACUNIT))
    end

	FretSoftLockHack(mo)
end, MT_EGGOFLAMER)
