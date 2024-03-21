-- LUA_DVDSS

/*							SRB2DVDSS - Core Script

	Naturally this contains the entire thing, be it UFO thinkers, HUDs etc.
	Now supports record attack and competition mode.

	NOTES:
	*Feel free to re-use anything in this script for your own mods as long as proper credit is given.
	*Everything in this Lua lump is LOL XD! By VincyTM
	*Kanade Tachibana is the best waifu.

	-With no love whatsoever, Lat'

*/

local DVD_maxspeed = FRACUNIT*25
local DVD_stime, DVD_sufo, DVD_starttime, DVD_watertime, DVD_timeadd = 0, 0, 0, 0, 0	-- time / ufo count / start timer (for animations etc) / water time (timer decrease)
local DVD_endtimer = 0	-- timer for ending the special stage (both winning OR losing)

local DVD_WATERMERCYTICS = 3
local DVD_BUMPTAG = 100
local DVD_UFOSPD = 18*FRACUNIT

local DVD_BOT_DELAY = TICRATE/12	-- how far behind does the bot lag?
local botcmd = {}	-- inputs the bot follows
local botdelay = 0
local HU_slidex
local HU_slidey
local HU_delays = {}

-- used for HUD drawing, defined here because this needs to be reset on map load:
local sneakers_timer
local prev_sneakers
local prev_ufos
local prev_rings
local prev_mult = 0

local DVD_timeufospawner		-- time UFO spawner
local DVD_timeufo				-- time UFO
local DVD_timeufowaypoints = {} -- time UFO waypoints (precached on level load so that we don't iterate through em everytime the UFO spawns)
local DVD_timeufosbusted = 0	-- # of time UFOs busted

local DVD_comprespawnqueue = {}
local DVD_COMPETITIONRESPAWNTIME = TICRATE*25	-- UFO competition respawn time

-- cache freeslots + states
freeslot(
	"SPR2_DSIA", "S_PLAY_DVDINTRO_START",
	"SPR2_DSIB", "S_PLAY_DVDINTRO_LOOP",
	"SPR2_DSIC", "S_PLAY_DVDINTRO_END",

	"SPR2_DSFN", "S_PLAY_DVDFAN"
)

spr2defaults[SPR2_DSIA] = SPR2_STND
spr2defaults[SPR2_DSIB] = SPR2_STND
spr2defaults[SPR2_DSIC] = SPR2_STND

states[S_PLAY_DVDINTRO_START] = {SPR_PLAY, SPR2_DSIA|FF_SPR2ENDSTATE, 5, nil, S_PLAY_DVDINTRO_LOOP, 0, S_PLAY_DVDINTRO_START}
states[S_PLAY_DVDINTRO_LOOP] = {SPR_PLAY, SPR2_DSIB|FF_ANIMATE, TICRATE*2, nil, 0, 5, S_PLAY_DVDINTRO_END}
states[S_PLAY_DVDINTRO_END] = {SPR_PLAY, SPR2_DSIC|FF_SPR2ENDSTATE, 5, nil, S_PLAY_STND, 0, S_PLAY_DVDINTRO_END}

spr2defaults[SPR2_DSFN] = SPR2_PAIN
states[S_PLAY_DVDFAN] = {SPR_PLAY, SPR2_DSFN|FF_ANIMATE, 350, nil, 0, 5, S_PLAY_FALL}

local function DVD_SetPlayerState(mo, st)
	if (mo.state == st)
		-- Don't interrupt SPR2
		return;
	end

	mo.state = st;

	if (mo.player and mo.player.valid)
		if (st == S_PLAY_DVDFAN)
			mo.player.panim = PA_PAIN;
		end
	end
end

local DVD_bumplines = {}	-- bumper lines.
-- they work this way: {line, bottom, top}
-- bottom & top are only used for fofs.

local DVD_bumpsecs = {}		-- bumper sectors
-- no hacky shit, it's just an array containing sector_t

local DVD_speedlines = {}	-- used for speed pad performance improvement:
-- eg: DVD_speedline[num] line_t (num being the # of the sector)

local DVD_timequeue = {}
-- used to display some small indications about time modification (-10, +30 etc...)

local function queuetimestring(s, shake)
	DVD_timequeue[#DVD_timequeue+1] = {s, TICRATE*3/2, shake}
end

-- water particles
freeslot("SPR_CDSH")
for i = 1, 5
	freeslot("S_DVDWATER1_"..i)
end
for i = 1, 3
	freeslot("S_DVDWATER2_"..i)
end

states[S_DVDWATER2_1] = {SPR_CDSH, A, 3, nil, 0, 0, S_DVDWATER2_2}
states[S_DVDWATER2_2] = {SPR_CDSH, B, 3, nil, 0, 0, S_DVDWATER2_3}
states[S_DVDWATER2_3] = {SPR_CDSH, E, 3, nil, 0, 0, S_NULL}
for i = 1, 5
	states[S_DVDWATER1_1+(i-1)] = {SPR_CDSH, (i-1), 3, nil, 0, 0, i < 5 and S_DVDWATER1_1+i or 0}
end

freeslot("MT_DVDEMERALD", "MT_DVDPARTICLE", "MT_DVDTRUMPET", "SPR_SPRC", "SPR_DVDD", "S_DVDTRUMPET")

states[S_DVDTRUMPET] = {SPR_DVDD, B, -1, nil, 0, 0, 0}
mobjinfo[MT_DVDTRUMPET] = {
	--$Name DVD Trumpet
	--$Sprite DVDDB0
	--$Category SUGOI Decoration
	doomednum = 3181,
    spawnstate = S_DVDTRUMPET,
    spawnhealth = 1000,
    radius = 8*FRACUNIT,
    height = 14*FRACUNIT,
    flags = MF_SCENERY|MF_NOTHINK
}

for i = 1, 5
	freeslot("S_DVDSHINE"..i)
end
for i = 1, 5
	states[S_DVDSHINE1+(i-1)] = {SPR_SPRC, (i+1)|FF_FULLBRIGHT, 3, nil, 0, 0, i < 5 and S_DVDSHINE1+i or S_DVDSHINE1}
end

for i = 1, 3
	freeslot("S_DVDSPARK"..i)
end
local trans = {0, FF_TRANS20, FF_TRANS40}
for i = 1, 3
	states[S_DVDSPARK1+(i-1)] = {SPR_SPRC, G+(i-1)|FF_FULLBRIGHT|trans[i], 3, nil, 0, 0, i < 3 and S_DVDSPARK1+i or S_NULL}
end

mobjinfo[MT_DVDEMERALD] = {
	doomednum = -1,
    spawnstate = S_DVDSHINE1,
    spawnhealth = 1,
    reactiontime = 8,
    speed = 2*FRACUNIT,
    radius = 8*FRACUNIT,
    height = 14*FRACUNIT,
    mass = 100,
    damage = 62*FRACUNIT,
    flags = MF_SCENERY|MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIPTHING|MF_NOBLOCKMAP
}

mobjinfo[MT_DVDPARTICLE] = {
	doomednum = -1,
    spawnstate = S_DVDSPARK1,
    spawnhealth = 1,
    reactiontime = 8,
    speed = 2*FRACUNIT,
    radius = 8*FRACUNIT,
    height = 14*FRACUNIT,
    mass = 100,
    damage = 62*FRACUNIT,
    flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY|MF_NOCLIPTHING
}

freeslot(--"SPR_DUST", -- sally edit, nova shore already has this sprite
	"sfx_frct", "sfx_bumpr", "sfx_ufoded", "sfx_dvdspd", "sfx_tufo", "sfx_dvdgot", "sfx_cdspsh")
for i = 1, 4
	freeslot("S_SSDUST"..i)
end
states[S_SSDUST1] = {SPR_DUST, A, 3,nil,0,0,S_SSDUST2}
states[S_SSDUST2] = {SPR_DUST, B, 3,nil,0,0,S_SSDUST3}
states[S_SSDUST3] = {SPR_DUST, C|TR_TRANS20, 3,nil,0,0,S_SSDUST4}
states[S_SSDUST4] = {SPR_DUST, D|TR_TRANS50, 3,nil,0,0,S_NULL}

freeslot("SPR_DSPW")
for i = 1, 14
	freeslot("S_DVDSPAWNFOG"..i)
end
for i = 1, 14
	states[S_DVDSPAWNFOG1+(i-1)] = {SPR_DSPW, i-1|TR_TRANS40, 1, nil, 0, 0, i < 14 and S_DVDSPAWNFOG1+i or S_NULL}
end
for i = 1, 3
	freeslot("MT_DVDUFO"..i)
	freeslot("S_DVDUFO"..i)
end
freeslot("SPR_FUFO", "MT_UFOWAYPOINT")

freeslot("SPR_KRBM")
for i = 1,10
	freeslot("S_QUICKBOOM"..i)
end
for i = 1, 10
	freeslot("S_LESS_QUICKBOOM"..i)
end

for i = 1, 10
	states[S_QUICKBOOM1+(i-1)] = {SPR_KRBM, i-1, 1, nil, 0, 0, i < 10 and S_QUICKBOOM1+i or S_NULL}
	states[S_LESS_QUICKBOOM1+(i-1)] = {SPR_KRBM, i-1, 3, nil, 0, 0, i < 10 and S_QUICKBOOM1+i or S_NULL}
end
freeslot("MT_SMOLDERING")	--Iceman, I'm not German damnit!

mobjinfo[MT_SMOLDERING] = {
	spawnstate = S_INVISIBLE,
	spawnhealth = 1000,
	radius = 32*FRACUNIT,
	height = 32*FRACUNIT,
	flags = MF_NOBLOCKMAP
}
freeslot("MT_BOOMPARTICLE")
mobjinfo[MT_BOOMPARTICLE] = {
	spawnstate = S_INVISIBLE,
	spawnhealth = 1000,
	radius = 32*FRACUNIT,
	height = 32*FRACUNIT,
	flags = MF_NOBLOCKMAP
}

local function DVD_castShadow(mo, scale, nopriority)	-- cast a shadow on the floor OR water
	-- Sal: SRB2 has this built in now.
	local wantedsize = 16 * scale;
	mo.shadowscale = FixedDiv(mo.info.radius, wantedsize);
end

local function DVD_BlockingWall(mobj)
	for i = 1, 4	-- check for quarter steps! PARALLEL UNIVERSES!? QPUS!??!?!?!? BUILDING SPEED FOR 12 HOURS!?!?!??!?!?!?!?!?!?!?!?!?!?!??!
		mobj.tester = P_SpawnMobj(mobj.x, mobj.y, mobj.z, MT_GARGOYLE) -- Has the best chance of not getting cleared on spawn
		local tester = mobj.tester
		tester.flags = MF_NOGRAVITY|MF_NOCLIPTHING -- Make sure it won't move or block things
		tester.state = S_INVISIBLE -- make sure it fucks off afterwards
		tester.tics = 1
		tester.radius = mobj.radius*10/9
		tester.height = mobj.height
		tester.z = $ + mobj.momz / i
		local angle = R_PointToAngle2(mobj.x, mobj.y, mobj.x+mobj.momx, mobj.y+mobj.momy)
		tester.angle = angle
		local maxdist = (mobj.DVD_spd or FixedHypot(mobj.momx, mobj.momy)) / i	-- that way we check for quarter steps
		P_InstaThrust(tester, angle, maxdist) -- Misuse P_InstaThrust to easily get the distance to move
		if not P_TryMove(tester, tester.momx+mobj.x, tester.momy+mobj.y, true) -- Return the inverse of P_TryMove (since it returns true on successful move, false on blocked)
			return true
		end
	end
end

addHook("MobjThinker", function(mo)
	if leveltime%2
		local x,y,z = P_RandomRange(-20, 20)*mo.scale, P_RandomRange(-20, 20)*mo.scale, P_RandomRange(-20, 20)*mo.scale
		local smoke = P_SpawnMobj(mo.x+x, mo.y+y, mo.z+z, MT_SMOKE)
		smoke.scale = mo.scale*2
		smoke.destscale = mo.scale*6
		smoke.momz = P_RandomRange(4, 9)*FRACUNIT
	end
end, MT_SMOLDERING)

addHook("MobjThinker", function(mo)		-- these leave some nice destructive trail.

	local x,y,z = P_RandomRange(-20, 20)*mo.scale, P_RandomRange(-20, 20)*mo.scale, P_RandomRange(-20, 20)*mo.scale
	if leveltime%2
		local smoke = P_SpawnMobj(mo.x+x, mo.y+y, mo.z+z, MT_BOSSEXPLODE)
		smoke.state = S_QUICKBOOM1
		smoke.scale = mo.scale/2
		smoke.destscale = mo.scale
	else
		local smoke = P_SpawnMobj(mo.x+x, mo.y+y, mo.z+z, MT_SMOKE)
		smoke.scale = mo.scale
		smoke.destscale = mo.scale*2
	end
	if P_IsObjectOnGround(mo) and mo.valid then P_RemoveMobj(mo) end
end, MT_BOOMPARTICLE)

local function DVD_ufoboom(mo)

	local smoldering = P_SpawnMobj(mo.x, mo.y, mo.z, MT_SMOLDERING)
	smoldering.tics = TICRATE*3

	-- start eathquake for nearby players
	for p in players.iterate do
		if p.mo and p.mo.valid and R_PointToDist2(mo.x, mo.y, p.mo.x, p.mo.y) < 1024*FRACUNIT
			P_StartQuake(FRACUNIT*20, 5)
		end
	end

	-- spawn a ring of dust because thats cool
	for i = 1,16
		local dust = P_SpawnMobj(mo.x, mo.y, mo.z+mo.height/5, MT_SMOKE)
		dust.angle = ANGLE_90 + ANG1* (22*(i-1))
		dust.destscale = FRACUNIT*10
		P_InstaThrust(dust, dust.angle, 20*FRACUNIT)
	end

	-- spawn some smoke as remanents of the explosion because thats cool too
	for i = 1,4

		local dust = P_SpawnMobj(mo.x+P_RandomRange(-30, 30)*FRACUNIT, mo.y+P_RandomRange(-30, 30)*FRACUNIT, mo.z+P_RandomRange(0, 30)*FRACUNIT, MT_SMOKE)
		dust.destscale = FRACUNIT*10
		dust.tics = 30
		dust.momz = P_RandomRange(3, 7)*FRACUNIT
	end

	-- explosion particles...?
	for i = 1, 4
		local truc = P_SpawnMobj(mo.x+P_RandomRange(-20, 20)*FRACUNIT, mo.y+P_RandomRange(-20, 20)*FRACUNIT, mo.z+P_RandomRange(0, 60)*FRACUNIT, MT_BOOMPARTICLE)
		truc.scale = FRACUNIT
		truc.destscale = FRACUNIT*5
		truc.momx = P_RandomRange(-20, 20)*FRACUNIT
		truc.momy = P_RandomRange(-20, 20)*FRACUNIT
		truc.momz = P_RandomRange(10, 30)*FRACUNIT
		truc.tics = TICRATE*5
	end

	-- spawn the actual explosion
	for i =1,16
		local truc = P_SpawnMobj(mo.x+P_RandomRange(-20, 20)*FRACUNIT, mo.y+P_RandomRange(-20, 20)*FRACUNIT, mo.z+P_RandomRange(0, 40)*FRACUNIT, MT_BOSSEXPLODE)
		truc.scale = FRACUNIT*3
		truc.destscale = FRACUNIT*8
		truc.state = S_LESS_QUICKBOOM1
		truc.momx = P_RandomRange(-10, 10)*FRACUNIT
		truc.momy = P_RandomRange(-10, 10)*FRACUNIT
		truc.momz = P_RandomRange(0, 20)*FRACUNIT
		if i < 2	-- cool sound effect
			local mobj = P_SpawnMobj(mo.x, mo.y, mo.z, MT_THOK)
			mobj.state = S_INVISIBLE
			mobj.tics = TICRATE*10
			S_StartSound(mobj, sfx_bgxpld)
		end
	end
end

-- UFO thinker
function A_DVDUfoThinker(mo)

	DVD_castShadow(mo, FRACUNIT*4, true)
	if not mo.health
		if not mo.ufo_forcemomz then mo.ufo_forcemomz = 0 end	-- what
		P_SetObjectMomZ(mo, mo.ufo_forcemomz)
		mo.ufo_forcemomz = $-FRACUNIT/30
		mo.ufo_deadtime = mo.ufo_deadtime and ($-1) or 0	-- 5/1: for some reason sometimes this was nil?????
		if leveltime%6 == 0
			local boom = P_SpawnMobj(mo.x+P_RandomRange(-80, 80)*FRACUNIT, mo.y+P_RandomRange(-80, 80)*FRACUNIT, mo.z+P_RandomRange(0, 80)*FRACUNIT, MT_BOOMPARTICLE)
			boom.destscale = 1
			S_StartSound(boom, sfx_ufoded)
			local truc = P_SpawnMobj(mo.x+P_RandomRange(-20, 20)*FRACUNIT, mo.y+P_RandomRange(-20, 20)*FRACUNIT, mo.z+P_RandomRange(0, 40)*FRACUNIT, MT_BOOMPARTICLE)
			truc.scale = FRACUNIT*2
			truc.destscale = 1
			truc.momx = P_RandomRange(-5, 5)*FRACUNIT
			truc.momy = P_RandomRange(-5, 5)*FRACUNIT
			truc.momz = P_RandomRange(-5, 5)*FRACUNIT
		end

		if DVD_BlockingWall(mo) or P_IsObjectOnGround(mo) or not mo.ufo_deadtime
			DVD_ufoboom(mo)
			if mo.valid
				P_RemoveMobj(mo)
			end
		end

		return -- don't continue, we're dead, we don't need no waypoint
	end

	if not mo.waypoints return end	-- no thinker in this case.
	if not mo.currwaypoint then mo.currwaypoint = 1 end
	local wp = mo.waypoints[mo.currwaypoint]
	if not wp return end			-- waypoint does not exist, stop
	-- chase the waypoint
	mo.target = wp
	A_HomingChase(mo, mo.ufospd*FRACUNIT)
	if R_PointToDist2(mo.x, mo.y, wp.x, wp.y) < (mo.ufospd*FRACUNIT)
	and abs(mo.z-wp.z) < (mo.ufospd*FRACUNIT)	-- make sure to check for z height too in case the UFO goes vertically:
		mo.currwaypoint = mo.waypoints[mo.currwaypoint+1] and $+1 or 1	-- if no waypoint go back to the first waypoint
	end
end

-- HIT the UFO!

local UFO_deathfuncs = {
[MT_DVDUFO1] = 	function(mo)
					mo.player.rings = $+20*mo.DVD_ringsmultiplier
					mo.DVD_ringsmultiplier = $+1
					S_StartSound(mo, sfx_itemup)
				end,

[MT_DVDUFO2] = 	function(mo)
					mo.DVD_sneakers = TICRATE*10
					mo.DVD_ringsmultiplier = 1
				end,

[MT_DVDUFO3] =	function(mo)
					queuetimestring("\x83".."+50")
					DVD_timeadd = $+50
					DVD_timeufosbusted = $+1
					mo.DVD_ringsmultiplier = 1
					S_StartSound(nil, sfx_token)
				end,
}

freeslot(
	"MT_TIMEUFO_ICON",
	"S_TIMEUFO_ICON1",
	"S_TIMEUFO_ICON2",
	"MT_TIMEUFOSPAWNER"
)

mobjinfo[MT_TIMEUFO_ICON] = {
	spawnstate = S_TIMEUFO_ICON1,
	spawnhealth = 1,
	reactiontime = 8,
	speed = 2*FRACUNIT,
	radius = 8*FRACUNIT,
	height = 14*FRACUNIT,
	mass = 100,
	damage = 62*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY|MF_BOXICON,
}

states[S_TIMEUFO_ICON1] = {SPR_FUFO, FF_ANIMATE|D, 18, nil, 3, 4, S_TIMEUFO_ICON2}
states[S_TIMEUFO_ICON2] = {SPR_FUFO, D, 18, nil, 0, 0, S_NULL}

local UFO_icons = {[MT_DVDUFO1]=MT_RING_ICON, [MT_DVDUFO2]=MT_SNEAKERS_ICON, [MT_DVDUFO3]=MT_TIMEUFO_ICON}
-- add a thinker for these 3, I know, it's weird but I'm lazy
for k,v in pairs(UFO_icons) do
	addHook("MobjThinker", function(mo)
		if not mapheaderinfo[gamemap].dvdss return end
		if mo.tracer and mo.tracer.valid
			P_MoveOrigin(mo, mo.tracer.x, mo.tracer.y, mo.tracer.z + 60*mo.tracer.scale)
		end
	end, v)
end

for i = MT_DVDUFO1, MT_DVDUFO3
addHook("TouchSpecial", function(mo, touch)

	if DVD_endtimer or touch.player and touch.player.bot
		return false
	end

	if mo.health
		mo.health = 0
		if not mo.timeufo
			if gametype ~= GT_COMPETITION
				DVD_sufo = max(0, $-1)
			end
			if touch.player
				touch.DVD_ufosbusted = $+1
			end
		end
		if gametype == GT_COMPETITION	-- add to our respawn queue
			DVD_comprespawnqueue[#DVD_comprespawnqueue+1] = {mo.spawnpoint, mo.type, mo.waypoints, mo.ufospd, DVD_COMPETITIONRESPAWNTIME}
		end
		mo.flags = $ & ~MF_SPECIAL
		mo.ufo_forcemomz = 0
		mo.ufo_deadtime = TICRATE*5
		UFO_deathfuncs[i](touch)
		local pnl = P_SpawnMobj(mo.x, mo.y, mo.z, UFO_icons[i])
		pnl.tracer = touch
		return true
	end
end, i)

addHook("MobjSpawn", function(mo)
	DVD_sufo = $+1
end,i)

end

states[S_DVDUFO1] = {SPR_FUFO, A, 1, A_DVDUfoThinker, 0, 0, S_DVDUFO1}
states[S_DVDUFO2] = {SPR_FUFO, B, 1, A_DVDUfoThinker, 0, 0, S_DVDUFO2}
states[S_DVDUFO3] = {SPR_FUFO, C, 1, A_DVDUfoThinker, 0, 0, S_DVDUFO3}

-- UFOs object defs
--local UFO_doomednum = 3169

mobjinfo[MT_DVDUFO1] = {
	--$Name DVD Ring UFO
	--$Sprite FUFOA0
	--$Category SUGOI Items & Hazards
	doomednum = 3169,
    spawnstate = S_DVDUFO1,
    spawnhealth = 1,
    speed = 6,
    radius = 60*FRACUNIT,
    height = 128*FRACUNIT,
    dispoffset = 0,
    mass = 100,
    flags = MF_SPECIAL|MF_NOGRAVITY
}

mobjinfo[MT_DVDUFO2] = {
	--$Name DVD Sneaker UFO
	--$Sprite FUFOB0
	--$Category SUGOI Items & Hazards
	doomednum = 3170,
    spawnstate = S_DVDUFO2,
    spawnhealth = 1,
    speed = 6,
    radius = 60*FRACUNIT,
    height = 128*FRACUNIT,
    dispoffset = 0,
    mass = 100,
    flags = MF_SPECIAL|MF_NOGRAVITY
}

mobjinfo[MT_DVDUFO3] = {
	--$Name DVD Time UFO
	--$Sprite FUFOC0
	--$Category SUGOI Items & Hazards
	doomednum = 3171,
    spawnstate = S_DVDUFO3,
    spawnhealth = 1,
    speed = 6,
    radius = 60*FRACUNIT,
    height = 128*FRACUNIT,
    dispoffset = 0,
    mass = 100,
    flags = MF_SPECIAL|MF_NOGRAVITY
}

mobjinfo[MT_TIMEUFOSPAWNER] = {
	--$Name DVD Time UFO Spawner
	--$Sprite FUFOC0
	--$Category SUGOI Items & Hazards
	doomednum = 3172,
    spawnstate = S_INVISIBLE,
    spawnhealth = 1,
    reactiontime = 8,
    speed = 2*FRACUNIT,
    radius = 8*FRACUNIT,
    height = 14*FRACUNIT,
    mass = 100,
    damage = 62*FRACUNIT,
    flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY|MF_BOXICON
}

mobjinfo[MT_UFOWAYPOINT] = {
	--$Name DVD UFO Waypoint
	--$Sprite SPRCA0
	--$Category SUGOI Items & Hazards
	doomednum = 3168,
    spawnstate = S_INVISIBLE,
    spawnhealth = 1000,
    speed = 6,
    radius = 1*FRACUNIT,
    height = 1*FRACUNIT,
    dispoffset = 0,
    mass = 100,
    flags = MF_NOGRAVITY,
    raisestate = S_NULL
}

-- related to DVD_getbumplines:
-- makes sure we don't add unecessary lines from same height FOFs
local function DVD_FOFcheckdupe(s1, s2, ref)
	local checksecs = {}
	-- first get the 2 sectors we actually need:
	local dosecs = {s1, s2}

	for i = 1, 2
		local s = dosecs[i]
		for rover in s.ffloors()
			if rover.sector.floorheight == ref.floorheight and rover.sector.ceilingheight == ref.ceilingheight else continue end
			for i = 1, #rover.sector.lines
				local cl = rover.sector.lines[i]
				if cl and cl.tag == DVD_BUMPTAG
					checksecs[#checksecs+1] = rover.sector
					break
				end
			end
		end
	end
	if #checksecs >= 2 return true end
end

local function DVD_getbumplines()

	-- add all the bumper lines.
	-- for FOFs, make sure we only add those at the exterior.

	for l in lines.iterate do

		if l.tag == 100
			table.insert(DVD_bumplines, {l})
		end
		-- keep going, we might have FOFs

		local gettop,getbottom
		if l and l.frontsector
		local sec = l.frontsector
			for rover in sec.ffloors()
				for i = 1, #rover.sector.lines
				local cl = rover.sector.lines[i]
					if cl and cl.tag == DVD_BUMPTAG
					and not DVD_FOFcheckdupe(l.frontsector, l.backsector, rover.sector)
						gettop = rover.sector.ceilingheight
						getbottom = rover.sector.floorheight
						table.insert(DVD_bumplines, {l, getbottom, gettop})
					end
				end
			end
		end

		if l and l.backsector
		local sec = l.backsector
			for rover in sec.ffloors()
				for i = 1, #rover.sector.lines
				local cl = rover.sector.lines[i]
					if cl and cl.tag == DVD_BUMPTAG
					and not DVD_FOFcheckdupe(l.frontsector, l.backsector, rover.sector)
						gettop = rover.sector.ceilingheight
						getbottom = rover.sector.floorheight
						table.insert(DVD_bumplines, {l, getbottom, gettop})
					end
				end
			end
		end
	end
end

local function DVD_getbumpsecs()
	for s in sectors.iterate do
		if s.special == 13	-- normal sector with nonramp:
			table.insert(DVD_bumpsecs, s)
		end
		-- do the same shit for fofs like w lines......
		for rover in s.ffloors()
			if rover.sector.special == 13
				table.insert(DVD_bumpsecs, rover.sector)
				break	-- because of how this works we don't need to know their height.
			end
		end
	end
end

local function DVD_getspeedlines()
	for s in sectors.iterate do
		if s.special == 1280	-- speed pad (no spin)
			for l in lines.iterate do
				if l.tag == s.tag
					DVD_speedlines[#s] = #l
					break
				end
			end
		end
	end
end

local function closestOnLine(mo, l)
	local dist = 0

	// spawn a dummy mobj
	local nicemo = P_SpawnMobj(l.v1.x, l.v1.y, 0, MT_THOK)
	nicemo.state = S_INVISIBLE
	nicemo.flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY
	nicemo.tics = 1	-- you don't wanna see it do you
	nicemo.angle = R_PointToAngle2(nicemo.x, nicemo.y, l.v2.x, l.v2.y)
	local mo_do_dist = R_PointToDist2(l.v1.x, l.v1.y, l.v2.x, l.v2.y) / 16
	P_InstaThrust(nicemo, nicemo.angle, mo_do_dist)
	for i = 1,16	-- try 16 positions along in the linedef
		if dist and dist < R_PointToDist2(mo.x, mo.y, nicemo.x + nicemo.momx*i, nicemo.y+ nicemo.momy*i) continue end
		dist = R_PointToDist2(mo.x, mo.y, nicemo.x+nicemo.momx*i, nicemo.y + nicemo.momy*i)
	end
	return dist
end

local function nearestLine(mo, t)
	local nearest, dist, lasttag, lastdist = nil, 0, 0, 0

	for i=1, #DVD_bumplines
		local l = DVD_bumplines[i][1]
		if not l continue end
		if DVD_bumplines[i][2]~=nil and mo.z+mo.height < DVD_bumplines[i][2] continue end
		if DVD_bumplines[i][3]~=nil and mo.z >= DVD_bumplines[i][3] continue end

		local tryx, tryy = P_ClosestPointOnLine(mo.x, mo.y, l)
		if R_PointToDist2(mo.x, mo.y, tryx, tryy) > FRACUNIT*64 and l.tag ~= DVD_BUMPTAG continue end	-- save memory
		-- ^^ ClosestPointOnLine is fast but way too approximative to have anything good, remotely, so I prefer to double check:
		local trydist = closestOnLine(mo, l)
		if trydist > 64*FRACUNIT continue end	-- that's too far anyway
		if nearest and trydist > dist continue end

		if lasttag == DVD_BUMPTAG and lasttag ~= l.tag	-- last line was interresting, unlike this new one >:(
			if abs(trydist-lastdist)/FRACUNIT < 64
				continue
			end
		end
		nearest, dist, lasttag, lastdist = l, trydist, l.tag, trydist
	end
	return nearest
end

local function nearestLine_nobump(mo, t)
	local nearest, dist, lasttag, lastdist = nil, 0, 0, 0
	for i=1, #t
		local l = t[i]
		if not l continue end
		local trydist = closestOnLine(mo, l)
		if trydist > 64*FRACUNIT continue end	-- that's too far anyway
		if nearest and trydist > dist continue end
		nearest, dist, lasttag, lastdist = l, trydist, l.tag, trydist
	end
	return nearest
end

-- synch vars in netgames
addHook("NetVars", function(net)
	DVD_stime, DVD_sufo, DVD_starttime, DVD_bumplines, DVD_watertime, DVD_timeadd = net(DVD_stime), net(DVD_sufo), net(DVD_starttime), net(DVD_bumplines), net(DVD_watertime), net(DVD_timeadd)
	DVD_timeufo, DVD_timeufospawner, DVD_timeufowaypoints, DVD_timeufosbusted = net(DVD_timeufo), net(DVD_timeufospawner), net(DVD_timeufowaypoints), net(DVD_timeufosbusted)
	DVD_endtimer = net(DVD_endtimer)
	DVD_comprespawnqueue = net(DVD_comprespawnqueue)
	DVD_bumpsecs = net(DVD_bumpsecs)
	DVD_speedlines = net(DVD_speedlines)
end)

-- count UFOs and give them their waypoints.

local function DVD_generateUFOpath(mo)

	mo.ufospd = mo.spawnpoint.z - (mo.floorz/FRACUNIT)
	local waypointseq = mo.spawnpoint.angle
	mo.waypoints = {}
	for p in mobjs.iterate()
		if p and p.valid and p.type == MT_UFOWAYPOINT
			if not p.spawnpoint or p.spawnpoint.angle < 256*waypointseq or p.spawnpoint.angle >= 256*(waypointseq+1)
				continue
			end
		mo.waypoints[p.spawnpoint.angle-(256*waypointseq)+1] = p
		end
	end
	-- snap UFO to waypoint #1
	if mo.waypoints[1]
		P_SetOrigin(mo, mo.waypoints[1].x, mo.waypoints[1].y, mo.waypoints[1].z)
	end

end

local function DVD_UFOsetup()
	local numUFOs = 0

	for mo in mobjs.iterate()	-- this is really laggy.
		if mo and mo.valid and mo.type >= MT_DVDUFO1 and mo.type <= MT_DVDUFO3
			numUFOs = $+1
			DVD_generateUFOpath(mo)
		elseif mo and mo.valid and mo.type == MT_TIMEUFOSPAWNER	-- build time UFO info
			if DVD_timeufospawner
				print("\x82".."WARNING".."\x82"..": Cannot have more than a single time UFO spawner.")
				break
			end
			DVD_timeufospawner = mo
			DVD_timeufowaypoints = {}
			local waypointseq = mo.spawnpoint.angle
			--print("Generating TIMEUFO with waypoint sequence "..waypointseq..".")
			for p in mobjs.iterate()
				if p and p.valid and p.type == MT_UFOWAYPOINT
					if not p.spawnpoint or p.spawnpoint.angle < 256*waypointseq or p.spawnpoint.angle >= 256*(waypointseq+1)
						continue
					end
					DVD_timeufowaypoints[p.spawnpoint.angle-(256*waypointseq)+1] = p
					--print("TUFO: Added waypoint #"..(p.spawnpoint.angle-(256*waypointseq)+1).."("..(p.spawnpoint.angle.."**)"))
				end
			end
		end
	end
	return numUFOs
end

-- map startup

local function DVD_resetcamera(p, cam)
	if not (cam and cam.valid) return end
	if not (p and p.valid) return end

	local mo = p.mo
	if not (mo and mo.valid) return end

	cam.DVD_camaiming = 0
	cam.DVD_camrotate = 0

	local camspeed = FRACUNIT/4
	local camdist = 256*mo.scale
	local camheight = 48*mo.scale
	local viewheight = 41*mo.scale	-- default viewheight
	local x = mo.x - (camdist/mo.scale)*cos(mo.angle + cam.DVD_camrotate*ANG1)
	local y = mo.y - (camdist/mo.scale)*sin(mo.angle + cam.DVD_camrotate*ANG1)
	local z = mo.z + viewheight + camheight	-- desired coords for our camera
	P_SetOrigin(cam, x, y, z)	-- teleport it at first
	cam.angle = mo.DVD_angle
end

local function DVD_resetplayer(p)
	local mo = p.mo
	if not mo return end
	mo.DVD_angle = mo.angle
	mo.DVD_spd = 0
	mo.DVD_bumpt = 0
	mo.DVD_bumptime = 0
	mo.DVD_ringsmultiplier = 1
	mo.DVD_watertime = 0
	-- score stuff:
	mo.DVD_ufosbusted = 0
end

addHook("PlayerSpawn", function(p)
	local mo = p.mo
	if not mo return end
	if not mapheaderinfo[gamemap].dvdss return end
	--COM_BufInsertText(p, "cam_dist 256; cam_height 64")
	DVD_resetplayer(p)
	DVD_resetcamera()
end)

local lastmap
local function DVD_loadreset(map)	-- reset all vars on mapload AND mapchange
	if (lastmap != nil and mapheaderinfo[lastmap].dvdss and map != lastmap)
		-- reenable huds
		-- sal: BUT ONLY WHEN CHANGING FROM THE MAP!!!
		sugoi.HUDShow("score", true)
		sugoi.HUDShow("time", true)
		sugoi.HUDShow("rings", true)
		sugoi.HUDShow("lives", true)
		-- sal: SAME WITH THESE STATS
		for p in players.iterate do
			p.pflags = $ & ~PF_FORCESTRAFE
			p.normalspeed = skins[p.skin].normalspeed
			p.jumpfactor = skins[p.skin].jumpfactor
			p.charability = skins[p.skin].ability
			p.runspeed = skins[p.skin].runspeed
		end
	end
	if _G["silv_barHUD"] ~= nil
		silv_barHUD = true
	end
	botcmd = {}
	botdelay = 0
	DVD_starttime = 0
	DVD_watertime = 0
	DVD_timeadd = 0
	DVD_endtimer = 0
	DVD_bumplines = {}
	DVD_bumpsecs = {}
	DVD_speedlines = {}
	DVD_timeufosbusted = 0
	prev_rings = nil
	prev_ufos = nil
	prev_mult = nil
	DVD_timequeue = {}
end

local function DVD_gstatepurge()	-- purge local vars by setting em to nil, this lightens our $$$.sav (especially important for bumplines & bumpsecs)
	botcmd = nil
	botdelay = nil
	DVD_starttime = nil
	DVD_watertime = nil
	DVD_timeadd = nil
	DVD_endtimer = nil
	DVD_bumplines = nil
	DVD_bumpsecs = nil
	DVD_timeufospawner = nil
	DVD_timeufo	= nil
	DVD_timeufowaypoints = nil
	DVD_timeufosbusted = nil
	DVD_speedlines = nil
end

addHook("MapChange", function(n)	-- changing from dd, reset all stats etc
	--if not n return end				-- do NOT crash the game!
	DVD_loadreset(n)
	lastmap = n
	if mapheaderinfo[n].dvdss
		DVD_gstatepurge()
	end
end)

addHook("MapLoad", function(n)
	DVD_loadreset(n)		-- reset all variables
	if not mapheaderinfo[n].dvdss then return end	-- map is not a DVD special stage, return.

	stagefailed = true; -- Sal: Fail by default, unset when calling win function.

	DVD_getbumplines()	-- ready bumper lines
	DVD_getbumpsecs()	-- ready bumper sectors
	DVD_getspeedlines()	-- ready speed pad lines / sectors association
	DVD_stime = gametype == GT_COMPETITION and TICRATE*100 or not modeattacking and tonumber(mapheaderinfo[n].dvdtimer or 100)*TICRATE or 0
	-- count UFOS
	DVD_timeufospawner, DVD_timeufo, DVD_timeufowaypoints = nil, nil, {}
	DVD_sufo = 0
	DVD_sufo = DVD_UFOsetup()
	for i = 1, 64
		HU_delays[i] = P_RandomRange(10, 35)
	end
	HU_slidex, HU_slidey = nil, nil

	-- teleport bot to us, else the game's gonna impplode:
	if players[1] and players[1].bot
		--local x, y = players[0].mo.x + 32*cos(players[0].mo.angle + ANGLE_180), players[0].mo.y + 32*sin(players[0].mo.angle + ANGLE_180)
		P_SetOrigin(players[1].mo, players[1].mo.x, players[1].mo.y, players[0].mo.z)
		players[1].mo.angle = players[0].mo.angle
		players[1].drawangle = players[0].drawangle
	end

	--if modeattacking return end	-- do not set start animation in record attack because it breaks ghosts for WHATEVER REASON.

	for p in players.iterate do
		if p.mo and p.mo.valid
			p.mo.state = S_PLAY_DVDINTRO_START
		end
	end

	sugoi.HUDShow("score", false)
	sugoi.HUDShow("time", false)
	sugoi.HUDShow("rings", false)
	sugoi.HUDShow("lives", false)
end)

-- camera handler
local function DVDSS_camerahandler()
	-- Sal: I do NOT trust the old method of giving everyone
	-- the same camera and moving it locally AT ALL, since this
	-- map is desyncing in netgames. The splitscreen code is more sane.
	for p in players.iterate do
		if not (p.DVD_splitcam and p.DVD_splitcam.valid)
			p.DVD_splitcam = P_SpawnMobj(0, 0, 0, MT_THOK)	-- spawn the camera
			p.DVD_splitcam.flags = MF_SLIDEME|MF_NOGRAVITY|MF_NOBLOCKMAP|MF_NOCLIPTHING -- Sal: Added extra flags
			p.DVD_splitcam.state = S_INVISIBLE
			p.DVD_splitcam.fuse = 69 -- Sal: timeout
			DVD_resetcamera(p, p.DVD_splitcam)
			p.awayviewmobj = p.DVD_splitcam
			p.awayviewtics = 69
		else
			p.awayviewtics = 69
			local mo = p.mo
			local camspeed = FRACUNIT/4
			local camdist = 256*mo.scale
			local camheight = 48*mo.scale
			local viewheight = 41*mo.scale	-- default viewheight
			local x = mo.x - (camdist/mo.scale)*cos(mo.DVD_angle + p.DVD_splitcam.DVD_camrotate*ANG1)
			local y = mo.y - (camdist/mo.scale)*sin(mo.DVD_angle + p.DVD_splitcam.DVD_camrotate*ANG1)
			local z = mo.z + viewheight + camheight	-- desired coords for our camera
			-- now make it move for fuck's sake
			p.DVD_splitcam.momx = FixedMul(x - p.DVD_splitcam.x, camspeed)
			p.DVD_splitcam.momy = FixedMul(y - p.DVD_splitcam.y, camspeed)
			p.DVD_splitcam.momz = FixedMul(z - p.DVD_splitcam.z, camspeed)
			p.DVD_splitcam.angle = R_PointToAngle2(p.DVD_splitcam.x, p.DVD_splitcam.y, mo.x, mo.y)
			p.awayviewaiming = p.DVD_splitcam.DVD_camaiming
			p.DVD_splitcam.fuse = 69

			if not P_CheckSight(p.DVD_splitcam, mo)
			or R_PointToDist2(p.mo.x, p.mo.y, p.DVD_splitcam.x, p.DVD_splitcam.y) > FRACUNIT*768
			or abs(p.mo.z - p.DVD_splitcam.z) > FRACUNIT*320
			or p.DVD_splitcam.z == p.DVD_splitcam.ceilingz or p.DVD_splitcam.z == p.DVD_splitcam.floorz
				DVD_resetcamera(p, p.DVD_splitcam)
			end
		end
	end
end

-- time UFO handler
local function DVD_timeUFOhandler()
	if not DVD_starttime return end
	if DVD_starttime < TICRATE*3 return end
	if leveltime < TICRATE return end	-- don't do that on mapload
	if DVD_stime <= (mapheaderinfo[gamemap].dvdcriticaltime or 20)*TICRATE
	and not DVD_timeufo
	and not DVD_timeadd		-- don't spawn one while we're getting / losing time
		S_StartSound(nil, sfx_tufo)
		-- Spawn UFO
		local point = DVD_timeufospawner
		DVD_timeufo = P_SpawnMobj(point.x, point.y, point.z, MT_DVDUFO3)
		DVD_timeufo.timeufo = true	-- do not count towards destroying UFOs
		DVD_sufo = $-1	-- shhh
		DVD_timeufo.waypoints = DVD_timeufowaypoints
		DVD_timeufo.ufospd = point.spawnpoint.z - (DVD_timeufo.floorz/FRACUNIT)
		-- Snap to first waypoint
		P_SetOrigin(DVD_timeufo, DVD_timeufowaypoints[1].x, DVD_timeufowaypoints[1].y, DVD_timeufowaypoints[1].z)
	end

	if not DVD_timeufo or not DVD_timeufo.valid
		DVD_timeufo = nil
	end
end

-- general handlers

local function DVD_scoretally(mo, timer)
	if mo.player.bot return end
	if timer == 1
		-- set up our score: UFO, time, rings, total
		mo.DVD_addscores = {mo.DVD_ufosbusted*1000, (mo.player.rings)*10, ((DVD_stime/TICRATE)*500) / (DVD_timeufosbusted+1), 0}	-- set our scores
		mo.DVD_tallydone = nil
	end

	local addition = 0
	if timer >= 55
		if mo.DVD_addscores[1] or mo.DVD_addscores[2] or mo.DVD_addscores[3]
			for i = 1, 3
				if mo.DVD_addscores[i] else continue end
				mo.DVD_addscores[4] = $+min(500, mo.DVD_addscores[i])	-- add to our score tally
				P_AddPlayerScore(mo.player, min(500, mo.DVD_addscores[i]))	-- and our actual score
				mo.DVD_addscores[i] = max(0, $-500)					-- remove from our visual score thing
			end
			if mo.player.cmd.buttons & BT_USE	-- skip everything
				mo.DVD_addscores[4] = $ + mo.DVD_addscores[1] + mo.DVD_addscores[2] + mo.DVD_addscores[3]
				P_AddPlayerScore(mo.player, mo.DVD_addscores[1] + mo.DVD_addscores[2] + mo.DVD_addscores[3])
				mo.DVD_addscores[1], mo.DVD_addscores[2], mo.DVD_addscores[3] = 0, 0, 0
			end

			S_StartSound(nil, sfx_menu1, p)
		else
			if not mo.DVD_tallydone
				S_StartSound(nil, sfx_chchng, mo.player)
				mo.DVD_tallydone = true
			end
			return true	-- player is done doing their shit
		end
	end
end

/*	-------------------------
	|			|			|
	| _	 *		|	*	 *	|
	|| | |		|	|   -|--|
	|-----------|-----------|
	|			|	*		|
	|	*	*	|	|		|
	|	|	|	|	__---*  |
	-------------------------
*/

local function DVD_loss()
	local finishedplayers, needplayers = 0, 0

	DVD_endtimer = $+1	-- increment timer
	if DVD_endtimer == 22
		S_StartSound(nil, sfx_s3k6a)	-- cool warp sound
		for p in players.iterate
			S_StopMusic(p)
		end
	elseif DVD_endtimer > 40
		if gametype == GT_COMPETITION
			for p in players.iterate do	-- give player their score and end the round
				if not p.mo or p.bot continue end
				p.score = p.mo.DVD_ufosbusted
			end
			if DVD_endtimer > TICRATE*2+TICRATE/2
				if DVD_endtimer == TICRATE*23
					sugoi.ExitLevel(nil, 1)	-- skip stats, we already did them (technically)
					DVD_endtimer = 0	-- fix a bug where comp mode would restart the level like 9 fucking times for whatever reason
				end
				return
			end
		end
		S_ChangeMusic(gametype == GT_COMPETITION and "_inter" or "_clear", false)
	end
	-- handle score tally

	if DVD_endtimer < TICRATE*3 return end
	for p in players.iterate do
		if not p.mo or p.bot continue end
		needplayers = $+1
		if DVD_scoretally(p.mo, DVD_endtimer - TICRATE*3)
			finishedplayers = $+1
		end
	end

	if finishedplayers >= needplayers
		if DVD_endtimer == TICRATE*8
			sugoi.ExitLevel(nil, 1)
		end
	else
		if DVD_endtimer > TICRATE*5
			DVD_endtimer = TICRATE*5
		end
	end
end

-- hey you won that's pretty cool!!!
local function DVD_win()
	DVD_endtimer = $+1

	stagefailed = false; -- Sal: Unset when you won

	local plyrs, plyrsstopped = 0, 0
	local finishedplayers, needplayers = 0, 0
	for p in players.iterate do
		if not p.mo or p.bot continue end
		plyrs = $+1
		if P_IsObjectOnGround(p.mo) and not FixedHypot(p.mo.momx, p.mo.momy)
			plyrsstopped = $+1
		end
	end
	if plyrsstopped >= plyrs

		if modeattacking
			if DVD_endtimer < TICRATE*4
				DVD_endtimer = TICRATE*4
			end
			if DVD_endtimer == TICRATE*6
				sugoi.ExitLevel(nil, 1)
			end
			return
		end

		-- Sal: Do for all players, since this map is desyncing.
		-- Just use the newly added drawonlyforplayer.
		for player in players.iterate do
			local mo = player.mo
			if not (mo and mo.valid)
				continue;
			end

			if not (player.DVD_splitcam and player.DVD_splitcam.valid)
				continue;
			end

			if (player.DVD_splitcam.DVD_camrotate == nil)
			or (player.DVD_splitcam.DVD_camrotate < 180)
				if (player.DVD_splitcam.DVD_camrotate == nil)
					player.DVD_splitcam.DVD_camrotate = 0;
				end
				player.DVD_splitcam.DVD_camrotate = $ + 5
			else	-- we're good, our cam's set!
				if DVD_endtimer == TICRATE*3/2
					local x, y = mo.x + 32*cos(mo.angle), mo.y + 32*sin(mo.angle)
					mo.DVD_emerald = P_SpawnMobj(x, y, mo.z + mo.scale*256, MT_DVDEMERALD)
					mo.DVD_emerald.flags = $|MF_NOCLIPHEIGHT
					mo.DVD_emerald.momz = -mo.scale*3
					mo.DVD_emerald.scale = mo.scale
					mo.DVD_emerald.color = _G[mapheaderinfo[gamemap].dvdemeraldcolor] or 0
					mo.DVD_emerald.drawonlyforplayer = player
				elseif DVD_endtimer == TICRATE*5
					S_StopMusic(player)
					S_StartSound(nil, sfx_s3k6a, player)
				elseif DVD_endtimer > TICRATE*3/2	-- handle emerald
				and mo.DVD_emerald and mo.DVD_emerald.valid
					--spawn particles, those are cool
					for i = 1,2 do
						local part = P_SpawnMobj(
							mo.DVD_emerald.x + P_RandomRange(-15, 15)*mo.scale,
							mo.DVD_emerald.y + P_RandomRange(-15, 15)*mo.scale,
							mo.DVD_emerald.z + P_RandomRange(0, 30)*mo.scale,
							MT_DVDPARTICLE
						)
						part.momx = P_RandomRange(-3, 3)*mo.scale
						part.momy = P_RandomRange(-3, 3)*mo.scale
						part.momz = P_RandomRange(-3, 3)*mo.scale
						part.scale = mo.scale
						part.color = _G[mapheaderinfo[gamemap].dvdemeraldcolor]
					end

					mo.DVD_emerald.momz = mo.DVD_emerald.z > (mo.z+mo.height/2) and -3*mo.scale or 0;

					if not mo.DVD_emerald.momz and not mo.DVD_emerald.soundplayed
						S_StartSound(nil, sfx_dvdgot, player)
						mo.DVD_emerald.soundplayed = true
					end
				end
			end
		end
	else
		DVD_endtimer = min(5, $)
	end

	if DVD_endtimer < TICRATE*7 return end
	for p in players.iterate do
		if not p.mo or p.bot continue end
		needplayers = $+1
		if DVD_endtimer == TICRATE*7
			S_ChangeMusic("_clear", false)
		end
		if DVD_scoretally(p.mo, DVD_endtimer - TICRATE*7)
			finishedplayers = $+1
		end
	end

	if finishedplayers >= needplayers
		if DVD_endtimer == TICRATE*14
			sugoi.ExitLevel(nil, 1)
		end
	else
		if DVD_endtimer > TICRATE*10
			DVD_endtimer = TICRATE*10
		end
	end

end

local function DVDSS_mainhandler()
	if DVD_starttime == nil return end
	DVDSS_camerahandler()
	if gametype == GT_COMPETITION
		-- handle competition respawning
		--{mo.spawnpoint, mo.type, mo.waypoints, mo.ufospd, DVD_COMPETITIONRESPAWNTIME}
		for k,v in ipairs(DVD_comprespawnqueue)
			if v[5]
				v[5] = $-1	-- wait for timer
			else	-- respawn UFO
				local ufo = P_SpawnMobj(v[1].x, v[1].y, v[1].z, v[2])
				ufo.spawnpoint = v[1]	-- save this
				ufo.waypoints = v[3]
				ufo.ufospd = v[4]
				P_SetOrigin(ufo, ufo.waypoints[1].x, ufo.waypoints[1].y ,ufo.waypoints[1].z)	-- snap to first waypoint and go go!
				local t = P_SpawnMobj(ufo.x, ufo.y, ufo.z, MT_THOK)
				t.state = S_DVDSPAWNFOG1
				t.scale = FRACUNIT*3
				table.remove(DVD_comprespawnqueue, k)
			end
		end
	elseif not modeattacking
		DVD_timeUFOhandler()
	else
		players[0].realtime = DVD_stime
	end

	for p in players.iterate do
		p.normalspeed = 0
		p.jumpfactor = FRACUNIT
		p.pflags = $|PF_THOKKED|PF_FORCESTRAFE
		p.charflags = $|SF_NOSKID
		p.charability = 0
	end

	if DVD_watertime then DVD_watertime = $-1 end
	DVD_starttime = $+1
	if DVD_starttime < TICRATE*3 + (gametype == GT_COMPETITION and TICRATE or 0)	-- timer before the special stage begins
		if not netgame
		and (players[1] and players[1].bot)	-- keep the bot next to us if there's one!!!
			--local x, y = players[0].mo.x + 32*cos(players[0].mo.angle + ANGLE_180), players[0].mo.y + 32*sin(players[0].mo.angle + ANGLE_180)
			P_SetOrigin(players[1].mo, players[1].mo.x, players[1].mo.y, players[0].mo.z)
			players[1].mo.angle = players[0].mo.angle
			players[1].drawangle = players[0].drawangle
			if leveltime == 2 and players[1].mo and players[1].mo.valid
				players[1].mo.state = S_PLAY_DVDINTRO_START
			end
		end
		return true
	elseif not DVD_sufo		-- No UFOs in the map, we won!
		DVD_win()
		return true
	elseif DVD_stime or modeattacking	-- for as long as we still have time, let's proceed!

		if DVD_timeadd
			if DVD_timeadd > 0
				DVD_timeadd = $-1
				DVD_stime = $+TICRATE
			elseif DVD_timeadd < 0
				DVD_timeadd = $+1
				DVD_stime = modeattacking and $+TICRATE or max(1, $-TICRATE)
			end
		else
			DVD_stime = $+ (not modeattacking and -1 or 1)
			if DVD_stime <= TICRATE*10
			and not (DVD_stime%TICRATE)
			and not modeattacking
				S_StartSound(nil, DVD_stime and sfx_dwnind or sfx_lose)
			end
		end
	else				-- if there's no time left, then don't do anything!
		DVD_loss()		-- do loss sequence
		return true
	end
end

-- make sure some popular and cool characters won't break:
-- Welsh Dragon BALANCE BREAKER!
local function DVDSS_abilitybreaker(p)
	local skin = p.mo.skin
	local mo = p.mo

	if skin == "shadow"
		p.consecutiveccs = 99	-- can't use chaos control (why doesn't PF_THOKKED block it????)
	elseif skin == "cdsonic"
		mo.cdfire1 = nil
		mo.cdfire2 = nil	-- can't use emerald powers
		mo.currentstone = nil
		mo.emeraldpower = nil
	elseif skin == "silver"
		if rawget(_G, "silv_barHUD")
			silv_barHUD = false	-- disable silver's bar HUD
		end
	end
end

-- returns a sector if we're on the side of a bumper sector but not fully inside of it
local function DVD_onBumpSecEdge(mo)
	local s = mo.subsector.sector
	if P_IsObjectOnGround(mo) and mo.floorz ~= mo.subsector.sector.floorheight
		-- before we do anything else, check for FOFs.......
		for rover in s.ffloors()
			if mo.z == rover.sector.ceilingheight
				if rover.sector.special == 13
					return true
				else
					return
				end
			end
		end
		local l = nearestLine_nobump(mo, s.lines)
		if not l return end
		-- before we do anything stupid, let's check what side we're on:
		if l.frontsector == s	-- do it for backsector...
			if l.backsector.special == 13 then return true end
			for rover in l.backsector.ffloors()
				if mo.z == rover.sector.ceilingheight
					if rover.sector.special == 13
						return true
					else
						return
					end
				end
			end
		else					-- else for frontsector
			if l.frontsector.special == 13 then return true end
			for rover in l.frontsector.ffloors()
				if mo.z == rover.sector.ceilingheight
					if rover.sector.special == 13
						return true
					else
						return
					end
				end
			end
		end
	end
end

-- player control handler
local function DVDSS_playerhandler()
	if DVD_starttime == nil return end
	for p in players.iterate do
		if p.spectator continue end
		if not p.mo continue end
		local mo = p.mo

		DVDSS_abilitybreaker(p)	-- disable abilities etc for some popular characters

		if mo.DVD_angle == nil	-- we may have a problem with the bot fucking off....
			DVD_resetplayer(p)
		end
		mo.angle = mo.DVD_angle
		p.drawangle = mo.DVD_angle

		if #p and p.bot	-- bot starts with a delay
			if DVD_starttime <= TICRATE*3 + DVD_BOT_DELAY
				return
			end
		end

		-- build bot teleport table.
		-- Was previously a bunch of ticcmd but that broke with framerate drops.
		if (botcmd == nil)
			botcmd = {}
		end

		if not #p and players[1] and players[1].bot
			botcmd[#botcmd+1] = {mo.x, mo.y, mo.z, mo.state, mo.DVD_angle, mo.angle}
		elseif p.bot
			P_MoveOrigin(p.mo, botcmd[1][1], botcmd[1][2], botcmd[1][3])
			DVD_SetPlayerState(mo, botcmd[1][4])
			mo.DVD_angle = botcmd[1][5]
			mo.angle = botcmd[1][6]
			p.drawangle = botcmd[1][6]
			table.remove(botcmd, 1)
		end

		if DVD_starttime == TICRATE*3+3 + (gametype == GT_COMPETITION and TICRATE or 0)
			DVD_SetPlayerState(mo, S_PLAY_RUN)
		end
		if p.bot continue end
		local plyrmaxspeed = mo.DVD_sneakers and DVD_maxspeed*5/3 or DVD_maxspeed
		local slopespd = 0
		local slowdown = P_IsObjectOnGround(mo) and p.cmd.forwardmove < 0	-- holding backpedal actually slows you down

		-- make states go slower when you slow down (at least for walking)
		if p.panim == PA_WALK
		and mo.DVD_laststate ~= mo.state
			if slowdown and not mo.DVD_slowstateset
				mo.tics = 3
			end
		end
		mo.DVD_laststate = mo.state

		if P_IsObjectOnGround(mo)
			if mo.DVD_previousz
			and mo.subsector.sector == mo.DVD_previousz[1]	-- same height, assume it's a slope / plane
			and mo.z ~= mo.DVD_previousz[2]		-- different z coordinate, so it's definitely a slope!
				slopespd = (mo.DVD_previousz[2]-mo.z)*3/2
			end
			mo.DVD_previousz = {mo.subsector.sector, mo.z}
		end

		p.runspeed = FRACUNIT*28
		-- I'm a huge fan
		if mo.DVD_fanfly
			P_SetObjectMomZ(mo, gravity*4/5, true)
			--I love you Lach, so have your own special case <3
			DVD_SetPlayerState(mo, S_PLAY_DVDFAN)
			--mo.angle = (leveltime%36)*ANG10
			p.drawangle = (leveltime%36)*ANG10
			-- holy shit my bad I forgot the bot existed!
			if botcmd and #botcmd
				botcmd[#botcmd][6] = mo.angle
			end
			mo.DVD_fanfly = $+1
			p.jumpfactor = 100	-- make sure to reset that
			if P_IsObjectOnGround(mo)
				mo.DVD_fanfly = 0
			end
		end

		-- sneakers are cool
		if mo.DVD_sneakers
			mo.DVD_sneakers = $-1
			local g = P_SpawnGhostMobj(mo.fakemo and mo.fakemo.valid and mo.fakemo or mo)
			g.fuse = 2
			p.runspeed = FRACUNIT*20
		end

		-- check for water
		if mo.DVD_watertime
			if P_IsObjectOnGround(mo) and not (mo.eflags & (MFE_TOUCHWATER|MFE_UNDERWATER))
				mo.DVD_watertime = nil
				continue
			end
			mo.DVD_watertime = $+1
			if mo.DVD_watertime >= DVD_WATERMERCYTICS
			and not (gametype == GT_COMPETITION)
				DVD_watertime = TICRATE*2
				DVD_timeadd = $-10
				queuetimestring("\x84"..(modeattacking and "+" or "-" ).."10", true)
				S_StartSound(nil, sfx_dwnind)
				mo.DVD_watertime = nil
			end
		elseif not mo.player.bot	-- fucking bot
		and not DVD_watertime	-- water timer is global to avoid multiple players literally raping the time limit
		and not mo.DVD_watertime
		and mo.eflags & (MFE_TOUCHWATER|MFE_UNDERWATER)	-- under or touch, same difference!!
			mo.DVD_watertime = 1
			if mo.eflags & MFE_TOUCHWATER
				local wtr = P_SpawnMobj(mo.x, mo.y, mo.z, MT_THOK)
				wtr.state = S_DVDWATER1_1
				wtr.color = _G[mapheaderinfo[gamemap].dvdwatercolor] or SKINCOLOR_BLUE
				S_StartSound(wtr, sfx_cdspsh)
			end
		elseif mo.eflags & MFE_TOUCHWATER
		and p.speed < p.runspeed
		and not (leveltime%10)
			local wtr = P_SpawnMobj(mo.x, mo.y, mo.z, MT_THOK)
			wtr.state = S_DVDWATER2_1
			wtr.color = _G[mapheaderinfo[gamemap].dvdwatercolor] or SKINCOLOR_BLUE
			S_StartSound(wtr, sfx_cdspsh)
		end

		-- check for bumpers:
		if DVD_BlockingWall(mo)
			local l = nearestLine(mo)	-- get nearest line, we'll assume that's the one we entered in contact with.
			if l
				if #l ~= mo.DVD_bline or mo.DVD_bumptime < TICRATE-10	-- prevent bumper spam rape (bumper hitbox is a bit bigger than the player itself)
					mo.DVD_bline = #l
					mo.DVD_bumptime = TICRATE-5
					mo.DVD_bumpt = 1

					-- Really unoptimized, but it does work really well!

					local trymobj = P_SpawnMobj(mo.x, mo.y, mo.z, MT_THOK)
					trymobj.angle = mo.DVD_angle
					trymobj.flags = MF_NOGRAVITY|MF_NOCLIPTHING
					trymobj.state = S_INVISIBLE
					trymobj.tics = 1
					trymobj.height = mo.height
					trymobj.radius = mo.radius*8/6

					local p_angle = R_PointToAngle2(mo.x, mo.y, mo.x+mo.momx, mo.y+mo.momy)

					local get_angle = R_PointToAngle2(l.v1.x, l.v1.y, l.v2.x, l.v2.y)
					local get_fangle = get_angle + (get_angle - p_angle)
					local itworked

					P_InstaThrust(trymobj, get_fangle, FRACUNIT*16)
					if not P_TryMove(trymobj, trymobj.x+trymobj.momx, trymobj.y+trymobj.momy, true)
						get_fangle = $ + 180*ANG1
					else
						itworked = true
					end
					P_InstaThrust(trymobj, get_fangle, FRACUNIT*16)

					if not itworked
					and not P_TryMove(trymobj, trymobj.x+trymobj.momx, trymobj.y+trymobj.momy, true)
						get_fangle = get_angle + ANG1*30
					else
						itworked = true
					end
					P_InstaThrust(trymobj, get_fangle, FRACUNIT*16)
					if not itworked
					and not P_TryMove(trymobj, trymobj.x+trymobj.momx, trymobj.y+trymobj.momy, true)
						get_fangle = get_angle - ANG1*30
					end
					P_InstaThrust(trymobj, get_fangle, mo.DVD_spd)
					S_StartSound(mo, sfx_s3kaa)
					mo.DVD_bumpmx, mo.DVD_bumpmy = trymobj.momx, trymobj.momy
					mo.momx = mo.DVD_bumpmx - (mo.DVD_bumpmx - FixedMul(mo.DVD_spd, cos(mo.DVD_angle))) * (mo.DVD_bumpt) / TICRATE
					mo.momy = mo.DVD_bumpmy - (mo.DVD_bumpmy - FixedMul(mo.DVD_spd, sin(mo.DVD_angle))) * (mo.DVD_bumpt) / TICRATE
				end
			end
		end

		--mo.DVD_spd = min($, plyrmaxspeed+slopespd)
		if mo.DVD_spd > FixedMul((plyrmaxspeed+slopespd)*2 / (slowdown and 3 or 2), mo.scale)
		and P_IsObjectOnGround(mo)
			mo.DVD_spd = max(FixedMul(mo.scale, (plyrmaxspeed+slopespd)*2 / (slowdown and 3 or 2)), $-mo.scale)
		end

		if P_PlayerTouchingSectorSpecial(p, 3, 1)		-- touching slow af grass, go slower!
		and ((P_PlayerTouchingSectorSpecial(p, 3, 1)).floorheight == mo.z or (P_PlayerTouchingSectorSpecial(p, 3, 1)).ceilingheight == mo.z)
			mo.DVD_spd = max(FixedMul(mo.scale, DVD_maxspeed/2), $-mo.scale)

			if leveltime%3 == 0
				local dust = P_SpawnMobj(mo.x+P_RandomRange(-10, 10)*FRACUNIT, mo.y+P_RandomRange(-10, 10)*FRACUNIT, mo.z, MT_THOK)
				dust.state = S_SSDUST1
				S_StartSound(dust, sfx_frct)
				dust.momx = P_RandomRange(-2, 2)*FRACUNIT
				dust.momy = P_RandomRange(-2, 2)*FRACUNIT
				dust.momz = P_RandomRange(4, 8)*FRACUNIT
				dust.scale = mo.scale/3
				dust.destscale = mo.scale*3/2
			end

		elseif P_PlayerTouchingSectorSpecial(p, 3, 5)
		and ((P_PlayerTouchingSectorSpecial(p, 3, 5)).floorheight == mo.z or (P_PlayerTouchingSectorSpecial(p, 3, 5)).ceilingheight == mo.z)		-- speed pad (somewhat)
			local boostsec = P_PlayerTouchingSectorSpecial(p, 3, 5)
			local fakeangle, spd
			local l = lines[DVD_speedlines[#boostsec]]
			assert(l, "No linedef associated with Speed Pad of tag "..boostsec.tag.."!")
			fakeangle = R_PointToAngle2(l.v1.x, l.v1.y, l.v2.x, l.v2.y)
			spd = 64*mo.scale
			-- spawn a dummy mobj to get speed values:
			local fakemo = P_SpawnMobj(0, 0, 0, MT_THOK)
			fakemo.flags2 = $|MF2_DONTDRAW
			fakemo.flags = MF_NOGRAVITY
			P_InstaThrust(fakemo, fakeangle, spd)
			-- length of the linedef will be our speed:
			mo.DVD_bumpmx, mo.DVD_bumpmy = fakemo.momx, fakemo.momy
			mo.DVD_bumptime = TICRATE-5
			mo.DVD_bumpt = 1
			DVD_SetPlayerState(mo, S_PLAY_RUN)	-- set to run frames, because not holding any control won't do it otherwise (this game's weird)
			S_StartSound(mo, sfx_dvdspd)
			if fakemo and fakemo.valid
				P_RemoveMobj(fakemo)
			end

		elseif P_PlayerTouchingSectorSpecial(p, 1, 13)	-- touching bumper top sector, do a small hop
		and ((P_PlayerTouchingSectorSpecial(p, 1, 13)).floorheight == mo.z or (P_PlayerTouchingSectorSpecial(p, 1, 13)).ceilingheight == mo.z)
		or DVD_onBumpSecEdge(mo)
			P_SetObjectMomZ(mo, FRACUNIT*6)
			S_StartSound(mo, sfx_s3kaa)
			DVD_SetPlayerState(mo, S_PLAY_JUMP)
			p.pflags = $|PF_JUMPED
			continue

		elseif P_PlayerTouchingSectorSpecial(p, 1, 14)	-- touching spring sector, jump high!
		and ((P_PlayerTouchingSectorSpecial(p, 1, 14)).floorheight == mo.z or (P_PlayerTouchingSectorSpecial(p, 1, 14)).ceilingheight == mo.z)
			P_SetObjectMomZ(mo, FRACUNIT*23)
			S_StartSound(mo, sfx_spring)
			DVD_SetPlayerState(mo, S_PLAY_JUMP)
			p.pflags = $|PF_JUMPED

		elseif P_PlayerTouchingSectorSpecial(p, 3, 2)	-- touching a fan, go flying!
		and ((P_PlayerTouchingSectorSpecial(p, 3, 2)).floorheight == mo.z or (P_PlayerTouchingSectorSpecial(p, 3, 2)).ceilingheight == mo.z)
			p.jumpfactor = 0
			P_SetObjectMomZ(mo, FRACUNIT*6)
			S_StartSound(mo, sfx_wdjump)
			mo.DVD_fanfly = 1

		elseif mo.DVD_spd < FixedMul((plyrmaxspeed+slopespd)*2 / (slowdown and 3 or 2), mo.scale)
		and P_IsObjectOnGround(mo)
			mo.DVD_spd = $+mo.scale/3
		elseif mo.DVD_spd > FixedMul((plyrmaxspeed+slopespd)*2 / (slowdown and 3 or 2), mo.scale)
		and P_IsObjectOnGround(mo)
			mo.DVD_spd = max(FixedMul((plyrmaxspeed+slopespd)*2 / (slowdown and 3 or 2), mo.scale), $+mo.scale/2)
		end

		if not mo.DVD_bumptime
			P_InstaThrust(mo, mo.DVD_angle, mo.DVD_spd)
		else
			if P_IsObjectOnGround(mo)
				mo.DVD_bumptime = $-1
				mo.DVD_bumpt = $+1

				if leveltime%3 == 0
				and mo.DVD_bumptime > TICRATE/2-TICRATE/5
				and P_IsObjectOnGround(mo)
					if mo.DVD_bumptime > TICRATE/2
						S_StartSound(mo, sfx_s3k36)
					end
					local dust = P_SpawnMobj(mo.x+P_RandomRange(-10, 10)*FRACUNIT, mo.y+P_RandomRange(-10, 10)*FRACUNIT, mo.z, MT_THOK)
					dust.state = S_SSDUST1
					dust.momx = mo.momx/2+P_RandomRange(-2, 2)*FRACUNIT
					dust.momy = mo.momy/2+P_RandomRange(-2, 2)*FRACUNIT
					dust.momz = P_RandomRange(4, 8)*FRACUNIT
					dust.scale = mo.scale/3
					dust.destscale = mo.scale*3/2
				end
			end
			mo.momx = mo.DVD_bumpmx - (mo.DVD_bumpmx - FixedMul(mo.DVD_spd, cos(mo.DVD_angle))) * (mo.DVD_bumpt) / TICRATE
			mo.momy = mo.DVD_bumpmy - (mo.DVD_bumpmy - FixedMul(mo.DVD_spd, sin(mo.DVD_angle))) * (mo.DVD_bumpt) / TICRATE
			-- make sure to go back to walking if we let go off inputs when the effect ends:
			if not mo.DVD_bumptime
				DVD_SetPlayerState(mo, S_PLAY_RUN)
			end
			-- hitting a wall should reset all of those if we're on the floor:
			if DVD_BlockingWall(mo)
				local l = nearestLine(mo)
				if not l or l.tag ~= DVD_BUMPTAG	-- do NOT do it if it's a bumper.
					mo.DVD_bumphitwall = true	-- set this here otherwise the wall might not be detected when we're back on the floor
				end
			end
			if mo.DVD_bumphitwall and P_IsObjectOnGround(mo)	-- we should NOT be able to regain control in mid-air.
				mo.DVD_bumptime = 0
				mo.DVD_bumpt = 0
				DVD_SetPlayerState(mo, S_PLAY_RUN)
				mo.DVD_bumphitwall = nil
			end
		end

		-- controls in SCD are pretty stiff, so it's not too much of a problem if it's the same for us

		if p.cmd.sidemove > 0
			mo.DVD_angle = $-(ANG1*3 + ANG1/3)
		elseif p.cmd.sidemove < 0
			mo.DVD_angle = $+(ANG1*3 + ANG1/3)
		end
	end
end

-- cannot spin in dvd special stages:
addHook("SpinSpecial", function()
	if mapheaderinfo[gamemap].dvdss return true end
end)

-- cannot jump while in starttime / endtime
addHook("JumpSpecial", function()
	if mapheaderinfo[gamemap].dvdss and (DVD_starttime < TICRATE*3 or DVD_endtimer) return true end
end)

addHook("ThinkFrame", do
	if not mapheaderinfo[gamemap].dvdss then return end
	sugoi.HUDShow("score", false)
	sugoi.HUDShow("time", false)
	sugoi.HUDShow("rings", false)
	sugoi.HUDShow("lives", false)
	if DVDSS_mainhandler() -- this will return true if we need to stop running the player thinkers.
		for p in players.iterate do -- sal: update drawangles
			if not (p.mo and p.mo.valid) continue end
			if (p.mo.DVD_angle)
				p.drawangle = p.mo.DVD_angle
			else
				p.drawangle = p.mo.angle
			end
		end
		return
	end
	DVDSS_playerhandler()
end)

/*
	Remember what I said about anime waifus?
	My opinion is a fact and yours is trash.
	And here's my proof https://simg3.gelbooru.com//samples/70/aa/sample_70aa80faa133fcf69e7901391d97db10.jpg
*/

-- HUD drawer
local queue_addy = 0

local function HU_dvdssHUD(v, p, c)

	local basey = splitscreen and 8 or 16
	local y = splitscreen and basey + (100*#p) or basey
	local snapflag = y == basey and V_SNAPTOTOP or 0

	if prev_ufos == nil
		prev_ufos = DVD_sufo
		prev_rings = p.rings
	end

	-- UFO counter:
	v.draw(17, y-6, v.cachePatch("UFOHUD"), V_HUDTRANS|snapflag|V_SNAPTOLEFT)
	v.draw(45, y+3, v.cachePatch("UFOX"), V_HUDTRANS|snapflag|V_SNAPTOLEFT)
	v.drawPaddedNum(69, y + (prev_ufos ~= DVD_sufo and 2 or 0), (gametype == GT_COMPETITION and p.mo.DVD_ufosbusted+1 or DVD_sufo+1)-1, 2, V_HUDTRANS|snapflag|V_SNAPTOLEFT)
	-- 	  ^^^^^^	^^ "Padded", 69. eheheheheheheh
	prev_ufos = DVD_sufo ~= prev_ufos and DVD_sufo or $

	-- TIME counter:
	local timex = modeattacking and 100 or 130
	v.drawString(timex, y+1, "TIME ", V_HUDTRANS|snapflag|((modeattacking or DVD_stime > (mapheaderinfo[gamemap].dvdcriticaltime or 20)*TICRATE or leveltime%10 < 5) and V_YELLOWMAP or V_REDMAP))
	if modeattacking
		v.drawPaddedNum(timex+52, 16, G_TicsToMinutes(DVD_stime), 2, V_SNAPTOTOP)
		v.draw(timex+52, y, v.cachePatch("SBOCOLON"), V_SNAPTOTOP)
		v.drawPaddedNum(timex+76, y, G_TicsToSeconds(DVD_stime), 2, V_SNAPTOTOP)
		v.draw(timex+76, y, v.cachePatch("SBOPERIOD"), V_SNAPTOTOP)
		v.drawPaddedNum(timex+100, y, G_TicsToCentiseconds(DVD_stime), 2, V_SNAPTOTOP)
	else
		v.drawPaddedNum(timex+60, y, DVD_stime/TICRATE, 3, snapflag|V_HUDTRANS)
	end
	-- time queue. this is clientsided, nobody cares if it works or not, so we throw that in the hud rendering
	for k,s in ipairs(DVD_timequeue)
		local timer = ((TICRATE*3/2)-s[2]) - TICRATE*3/2+9	-- timer for messages fading out.
		local transparencyflag = s[2] <= 9 and timer*V_10TRANS or 0	-- transparency for messages fading out
		local addx = (s[2] > TICRATE and s[3] and (leveltime%2 and -1 or 1) or 0)	-- make it shake a bit when it appears, that gives it a dramatic feeling
		v.drawString(160+addx, y+12+queue_addy+10*(k-1), s[1], snapflag|transparencyflag, "center")
		s[2] = $-1
		if not s[2]
			table.remove(DVD_timequeue, k)
			queue_addy = $+10
		end
	end
	queue_addy = $/2

	-- RINGS counter
	v.drawString(230, y+1, "RINGS ", V_HUDTRANS|snapflag|V_SNAPTORIGHT|((p.rings > 0 or leveltime%10 < 5) and V_YELLOWMAP or V_REDMAP))
	v.drawPaddedNum(300, y + (prev_rings ~= p.rings and 2 or 0), p.rings, (p.rings >= 1000 and 4 or 3), V_HUDTRANS|snapflag|V_SNAPTORIGHT)
	prev_rings = p.rings ~= prev_rings and p.rings or $
	if p.mo.DVD_ringsmultiplier and p.mo.DVD_ringsmultiplier > 1
		v.drawString(300, y+14 + (prev_mult ~= p.mo.DVD_ringsmultiplier and 2 or 0), "X"..p.mo.DVD_ringsmultiplier, V_SNAPTOTOP|V_SNAPTORIGHT|V_YELLOWMAP|V_HUDTRANS, "right")
	end
	if prev_mult and prev_mult > p.mo.DVD_ringsmultiplier	-- we lost the multiplier, do some cool shit:
	and HU_delays ~= nil -- sal
		local str = "X"..prev_mult
		local fx = 300 - v.stringWidth(str)
		local fstr = ""
		for i = 1, str:len()
			local s = str:sub(i, i)
			local s3 = phud.create(fx + v.stringWidth(fstr), y+14, s)
			fstr = $..str:sub(i, i)
			s3.flags = V_SNAPTOTOP|V_SNAPTORIGHT|V_YELLOWMAP
			s3.waitphysics = (HU_delays[i]-10)/4
			s3.isstring = true
		end
	end
	prev_mult = p.mo.DVD_ringsmultiplier
	DisplayPhysHUD(v, p, c)

	-- SPEED SHOES?
	if p.mo.DVD_sneakers

		if not prev_sneakers
			prev_sneakers = true
			sneakers_timer = 1
		end

		local w, h = 0, 0
		if sneakers_timer
			w = min(40, 15*sneakers_timer)
			sneakers_timer = sneakers_timer < 4 and $+1 or 0
		end
		if (p.mo.DVD_sneakers > TICRATE*3 or leveltime%2)
			local pp = v.cachePatch("TVSSC0")
			local hoffs = y+24 + pp.height/4
			local voffs = 24 + pp.width/4	-- /4 because we downscale it 2 times
			v.drawScaled(voffs*FRACUNIT, hoffs*FRACUNIT, FRACUNIT/2, pp, V_SNAPTOTOP|V_SNAPTOLEFT)
			v.drawFill(24 + pp.width/2 + 2, hoffs-6, w or 41, h or 6, 26|V_SNAPTOTOP|V_SNAPTOLEFT)
			v.drawFill(24 + pp.width/2 + 2, hoffs-7, w or (p.mo.DVD_sneakers*40 / (TICRATE*10)), h or 6, 73|V_SNAPTOTOP|V_SNAPTOLEFT)
		end
	else
		prev_sneakers = nil
	end
end

-- Map-to-screen coord transform, shitty software mode style
-- Code from RedEnchilada (fickle)

local function faketan(a)	-- tan actually throws a warning if not used with 'true' (which is fucking dumb?)
	return tan(a+ANGLE_90, true)
end

local function R_MapToScreen(p, mx, my, mz)
	if splitscreen return end
	if not (p.DVD_splitcam and p.DVD_splitcam.valid) return end
	if not (p.mo and p.mo.valid) return end
    -- Get camera angle
    local camangle = R_PointToAngle(p.mo.x+FixedMul(cos(p.mo.DVD_angle + p.DVD_splitcam.DVD_camrotate*ANG1), 64<<FRACBITS), p.mo.y+FixedMul(sin(p.mo.DVD_angle + p.DVD_splitcam.DVD_camrotate*ANG1), 64<<FRACBITS))
    local camheight = p.DVD_splitcam.z
    local camaiming = FixedMul(160<<FRACBITS, faketan(p.DVD_splitcam.DVD_camaiming+ANGLE_90))
    if(R_PointToDist(p.mo.x, p.mo.y) > FRACUNIT) then
        camheight = p.DVD_splitcam.DVD_camaiming
        camaiming = p.DVD_splitcam.DVD_camaiming/128
    end

    local x = camangle-R_PointToAngle(mx, my)
    local distfact = FixedMul(FRACUNIT, cos(x))
	local behind
	if x > ANG1*85 or x < ANG1*275
		if x > ANG1*140 or x < ANG1*220 then
			behind = true
		end
		x = -x	-- shift x
	end

	x = FixedMul(faketan(x+ANGLE_90), 160<<FRACBITS)+160<<FRACBITS
    local y = camheight-mz
    y = FixedDiv(y, max(1, FixedMul(distfact, max(1, R_PointToDist(mx, my)))))
    y = (y*160)+100<<FRACBITS
    y = y+camaiming

    local scale = FixedDiv(160*FRACUNIT, max(1, FixedMul(distfact, R_PointToDist(mx, my))))
    return x, y, behind, scale
end

-- TIME UFO HUD DRAWER
local function HU_timeufo(v, p, c)
	if DVD_timeufo and DVD_timeufo.valid and DVD_timeufo.health	-- don't try it for dead ufos lol
		if p.mo
		and R_PointToDist2(c.x, c.y, DVD_timeufo.x, DVD_timeufo.y) < FRACUNIT*1024
		and P_CheckSight(p.mo, DVD_timeufo)
			return
		end
		-- get screen coordinates:
		local x, y, behind, scale = R_MapToScreen(p, DVD_timeufo.x, DVD_timeufo.y, DVD_timeufo.z)
		x = $/FRACUNIT
		y = $/FRACUNIT
		local patch, flags, forcey, ymodif = 0, 0, 0, 0
		if behind
			patch = "TUFO3"
			flags = V_SNAPTOBOTTOM
			forcey = 190
		elseif x < 20
			patch = "TUFO1"
			flags = V_SNAPTOLEFT
			forcey = 100
		elseif x > 300
			patch = "TUFO2"
			flags = V_SNAPTORIGHT
			forcey = 100
		else
			patch = "TUFO4"
			ymodif = scale*DVD_timeufo.height
		end
		x = max(10, $)
		x = min(310, $)
		y = max(10, $)
		y = min(190, $)
		v.draw(x, forcey or y+ymodif, v.cachePatch(patch..((leveltime/2%3) or 1)), V_30TRANS|flags)

	end
end

-- start the stage with DESTROY x UFOs or DESTROY THE MOST UFOs etc
local function HU_dvdss_start(v, p, c)
	local timer = DVD_starttime

	-- black bars with cool stuff in them:

	local basey = splitscreen and 8 or 16
	local y = splitscreen and basey + (100*#p) or basey
	local snapflag = y == basey and V_SNAPTOTOP or 0

	if timer and timer <= TICRATE*3-25 and not (splitscreen and #p)
		local h = timer < TICRATE*2 and min(24, (timer)*3) or max(0, 24 - (timer-TICRATE*2)*3)
		v.drawFill(0, 12 - (h/2), 500, h, 31|V_SNAPTOTOP|V_SNAPTOLEFT)
		v.drawFill(0, 188 - (h/2), 500, h, 31|V_SNAPTOBOTTOM|V_SNAPTOLEFT)

		local str1w = HU_titlecardWidth(v, 0, 0, "Get ready")
		for i = 1, 8
			HU_centeredTitlecardDrawString(v, -str1w*4 + (i-1)*str1w*3/2 + timer*6, 4, "Get ready...", V_SNAPTOTOP)
		end
		local str2w = HU_titlecardWidth(v, 0, 0, mapheaderinfo[gamemap].lvlttl)
		for i = 1, 4
			HU_centeredTitlecardDrawString(v, str2w*4 - (i-1)*str2w*3/2 - timer*6, 182, mapheaderinfo[gamemap].lvlttl, V_SNAPTOBOTTOM)
		end
	end

	local center = gametype == GT_COMPETITION and 160 or 170
	local centerdist = gametype == GT_COMPETITION and 5 or 20
	if not (splitscreen and #p)
		-- DESTROY
		local x1 = DVD_starttime < TICRATE*3 - 25 and min(center-centerdist, 0 + timer*20) or center-centerdist + (timer-(TICRATE*3-25))*30
		v.draw(x1, 96, v.cachePatch(gametype == GT_COMPETITION and "DVDTXT3" or "DVDTXT1"))
		-- UFOS
		local x2 = DVD_starttime < TICRATE*3 - 25 and max(center+centerdist, 320 - timer*20) or center+centerdist - (timer-(TICRATE*3-25))*30
		v.draw(x2, 96, v.cachePatch(gametype == GT_COMPETITION and "DVDTXT4" or "DVDTXT2"))
	end
	-- number number (draw twice in splitscreen too, who cares)
	if DVD_starttime < TICRATE*3 - 25
		if gametype ~= GT_COMPETITION
			v.drawPaddedNum(max(center+8, 320 - timer*20), 96, DVD_sufo, 2)
		end
	else	-- make the # of UFOs slide
		if gametype ~= GT_COMPETITION
			local targetx, targety = 69, y
			if HU_slidex == nil and not (splitscreen and #p)
				HU_slidex = center+8 - targetx
				HU_slidey = 96 - targety
			end
			v.drawPaddedNum(targetx + HU_slidex, targety + (splitscreen and #p and -HU_slidey or HU_slidey), DVD_sufo, 2, snapflag|V_SNAPTOLEFT)
			HU_slidex, HU_slidey = $1/2, $2/2
		end

		-- make the hud fade in: (this is a simplified display)
		local transparency = max(0, V_90TRANS - (((timer-TICRATE*3-25)/3)*V_10TRANS))

		v.draw(17, y-6, v.cachePatch("UFOHUD"), transparency|snapflag|V_SNAPTOLEFT)
		v.draw(45, y+3, v.cachePatch("UFOX"), transparency|snapflag|V_SNAPTOLEFT)
		if gametype == GT_COMPETITION
			v.drawPaddedNum(69, y, p.mo.DVD_ufosbusted, 2, transparency|snapflag|V_SNAPTOLEFT)
		end

		-- TIME counter:
		local timex = modeattacking and 100 or 130
		v.drawString(timex, y+1, "TIME ", transparency|snapflag|((modeattacking or DVD_stime > (mapheaderinfo[gamemap].dvdcriticaltime or 20)*TICRATE or leveltime%10 < 5) and V_YELLOWMAP or V_REDMAP))
		if modeattacking
			v.drawPaddedNum(timex+52, 16, G_TicsToMinutes(DVD_stime), 2, V_SNAPTOTOP|transparency)
			v.draw(timex+52, y, v.cachePatch("SBOCOLON"), V_SNAPTOTOP|transparency)
			v.drawPaddedNum(timex+76, y, G_TicsToSeconds(DVD_stime), 2, V_SNAPTOTOP|transparency)
			v.draw(timex+76, y, v.cachePatch("SBOPERIOD"), V_SNAPTOTOP|transparency)
			v.drawPaddedNum(timex+100, y, G_TicsToCentiseconds(DVD_stime), 2, V_SNAPTOTOP|transparency)
		else
			v.drawPaddedNum(timex+60, y, DVD_stime/TICRATE, 3, snapflag|transparency)
		end

		v.drawString(230, y+1, "RINGS ", transparency|snapflag|V_SNAPTORIGHT|V_YELLOWMAP)
		v.drawPaddedNum(300, y, p.rings, 3, transparency|snapflag|V_SNAPTORIGHT)

	end
end

-- draws a column that fills the screen
local function HU_drawcolumn(v, x, flags)
	local pp = v.cachePatch("COLUMN")
	local h = 0
	while h < 300
		v.draw(x or 0, h, pp, (flags or 0)|V_SNAPTOTOP)
		h = $+pp.height
	end
end

local function HU_drawfademask(v, flags)
	local w = 0
	while w < 400
		HU_drawcolumn(v, 4 + (w/8)*8, V_SNAPTOLEFT|(flags or 0))
		w = $+8
	end
end


local function HU_dvdss_scoretally(v, p, c, timer)
	v.drawFill(0, 0, 999, 999, 0|V_SNAPTOTOP|V_SNAPTOLEFT)	-- fill screen with jizz
	if not p.mo return end
	local bonus_patch = {"YB_UFO", "YB_RING", "YB_TIME"}
	local bonus_patch_time =3	-- yukek is that you!?!?!?!??
	local bonus_defaultval = {p.mo.DVD_ufosbusted*1000, p.rings*50, DVD_stime*1000}

	-- tile up a bunch of spec back
	local w = 0
	local patch = v.cachePatch("SPECTILE")
	local trans = max(0, V_90TRANS - (timer/2)*V_10TRANS)
	while w < 500
		local h = 0
		while h < 350
			v.draw(w, h, patch, V_SNAPTOTOP|V_SNAPTOLEFT|trans)
			h = $+patch.height
		end
		w = $+patch.width
	end

	local y = 90
	for k, b in ipairs(bonus_patch)
		v.draw(min(140, -100 + 30*(timer - (10*(k-1)))), y, v.cachePatch(b), V_SNAPTOLEFT)	-- patch
		v.drawNum(max(230, 420 - 30*(timer - (10*(k-1)))), y+1, p.mo.DVD_addscores[k] * (k == bonus_patch_time and DVD_timeufosbusted+1 or 1))		-- a number
		if k == bonus_patch_time
		and DVD_timeufosbusted and DVD_stime	-- don't show the divide if there's no time left
			v.draw(max(244, 420 - 30*(timer - (10*(k-1)))), y+1, v.cachePatch("STTSLASH"))
			v.drawNum(max(275, 420 - 30*(timer - (10*(k-1)))), y+1, DVD_timeufosbusted+1)
		end
		y = $+18
	end

	v.draw(max(180, 420 - 30*(timer - 10*#bonus_patch)), y+4, v.cachePatch("YB_TOTAL"))	-- patch
	v.drawNum(max(230, 420 - 30*(timer - 10*#bonus_patch)), y+6, p.mo.DVD_addscores[4])		-- a number

end

-- Sorry Prisima I'm stealing a bit of your code :O
local sortfunc = function(a,b)
	return (a[2].mo.DVD_ufosbusted*32)+a[1] > (b[2].mo.DVD_ufosbusted*32)+b[1]
end

-- draw rankings for competition (see HU_dvdss_loss)
local function HU_dvdss_competitionrankings(v, timer, p)
	if splitscreen and #p return end
	-- get all our players:
	local plist = {}
	for p in players.iterate do
		if p.mo
			plist[#plist+1] = {#plist+1, p}
		end
	end
	table.sort(plist, sortfunc)
	local trans = max(0, V_90TRANS - (timer/2)*V_10TRANS)	-- lol traps
	if trans
		v.drawFill(0, 0, 999, 999, 0|V_SNAPTOTOP|V_SNAPTOLEFT)
	end
	-- draw SRB2BACK bg:
	local w = 0
	local patch = v.cachePatch("SRB2BACK")
	while w < 500
		local h = 0
		while h < 350
			v.draw(w, h, patch, V_SNAPTOTOP|V_SNAPTOLEFT|trans)
			h = $+patch.height
		end
		w = $+patch.width
	end

	-- scoreboard line + info

	local result = v.cachePatch("RESULT")
	v.draw(160 - result.width/2, 2, result, trans)
	v.drawString(160, 5 + result.height, "* "..mapheaderinfo[gamemap].lvlttl.." *", trans, "center")
	v.drawFill(4, 42, 312, 1, 1)
	v.drawString(6, 32, "#", trans|V_YELLOWMAP)
	v.drawString(40, 32, "NAME", trans|V_YELLOWMAP)
	v.drawString(316, 32, "UFOS BUSTED", trans|V_YELLOWMAP, "right")

	-- scoreboard players:
	for k,d in ipairs(plist)
		local p = d[2]
		local y = 48 + 16*(k-1)
		if y > 170 break end
		v.drawString(10, y, k, 0, "center")	-- pos
		v.drawScaled(20*FRACUNIT, (y-4)*FRACUNIT, FRACUNIT/2, v.cachePatch(skins[p.mo.skin].face), trans, v.getColormap(p.mo.skin, p.mo.color))	-- face
		v.drawString(40, y, p.name, V_ALLOWLOWERCASE|trans|((not splitscreen and displayplayer == p) and V_YELLOWMAP or 0))	-- name
		v.drawString(316, y, p.mo.DVD_ufosbusted, trans, "right")
	end

	-- START IN.......
	v.drawString(160, 190, "START IN "..((TICRATE*23 - DVD_endtimer)/TICRATE).." SECONDS", V_YELLOWMAP|trans, "center")
end

-- ALSO USED FOR COMPETITION SCOREBOARD!
local function HU_dvdss_loss(v, p, c)
	-- do score tally + manually add the text cuz im lazy

	if gametype == GT_COMPETITION or splitscreen
		HU_dvdssHUD(v, p, c)	-- we didn't lose the competition, and splitscreen makes me lazy
	end

	if splitscreen and not #p return end	-- don't continue from here on out.

	if gametype ~= GT_COMPETITION and DVD_endtimer >= TICRATE*3-10 and p.mo.DVD_addscores
		HU_dvdss_scoretally(v, p, c, DVD_endtimer-TICRATE*3-10)
		HU_centeredTitlecardDrawString(v, min(-40 + 30*(DVD_endtimer-TICRATE*3-10), 160), 40, p.mo.skin.." took the L", V_SNAPTOTOP)
	elseif gametype == GT_COMPETITION and DVD_endtimer >= TICRATE*1 + TICRATE/2
		HU_dvdss_competitionrankings(v, DVD_endtimer-TICRATE*3/2, p)

	-- fade the screen in white
	elseif DVD_endtimer >= 20
		local flag1 = max(0, V_90TRANS - ((DVD_endtimer-20)/2)*V_10TRANS)
		HU_drawcolumn(v, 160, flag1)	-- draw middle column
		-- draw side columns:
		if DVD_endtimer >= 22
			local timer = (DVD_endtimer - 22)
			for i = 1, min(32, timer*2)
				if i > timer continue end
				local flag2 = max(0, V_90TRANS - ((timer - (i-1)))*V_10TRANS)
				HU_drawcolumn(v, 160 - 8*i, flag2)
				HU_drawcolumn(v, 160 + 8*i, flag2)
			end
		end
	elseif DVD_endtimer == 1 and not (gametype == GT_COMPETITION) and not (splitscreen)
		-- create a carbon copy of our HUD in physHUD, it's gonna look cool, I PROMISE!
		-- UFO and UFOX

		local s1 = phud.create(17, 10, "UFOHUD")
		s1.flags = V_SNAPTOTOP|V_SNAPTOLEFT
		s1.waitphysics = HU_delays[1]
		local s2 = phud.create(45, 19, "UFOX")
		s2.flags = V_SNAPTOTOP|V_SNAPTOLEFT
		s1.waitphysics = HU_delays[2]

		-- TIME (iterate through "TIME" and draw each individual character :P)
		local index = 3
		local str = ""
		for i = 1, string.len("TIME")
			local s3 = phud.create(130 + v.stringWidth(str), 17, string.sub("TIME", i, i))
			str = $..string.sub("TIME", i, i)
			s3.flags = V_SNAPTOTOP|V_YELLOWMAP
			s3.isstring = true
			s3.waitphysics = HU_delays[index]
			index = $+1
		end

		-- RINGS
		str = ""
		for i = 1, string.len("RINGS")
			local s3 = phud.create(230 + v.stringWidth(str), 17, string.sub("RINGS", i, i))
			str = $..string.sub("RINGS", i, i)
			s3.flags = V_SNAPTOTOP|V_YELLOWMAP|V_SNAPTORIGHT
			s3.isstring = true
			s3.waitphysics = HU_delays[index]
			index = $+1
		end

		-- numbers:
		local nums = {DVD_sufo, DVD_stime, p.rings}
		local flags = {V_SNAPTOTOP|V_SNAPTOLEFT, V_SNAPTOTOP, V_SNAPTOTOP|V_SNAPTORIGHT}
		local digits = {2, 3, (p.rings >= 1000 and 4 or 3)}
		local coords = {{69, 16}, {190, 16}, {300, 16}}

		for k,n in ipairs(nums)
			n = string.format("%0"..digits[k].."d", tostring(n))
			local i = digits[k]
			while i
				local patch = "STTNUM"..string.sub(tostring(n), i, i)
				local s3 = phud.create(coords[k][1] - 8*digits[k] + 8*(i-1), coords[k][2], patch)
				s3.flags = flags[k]
				s3.waitphysics = HU_delays[index]
				index = $+1
				i = $-1
			end
		end
	end
	DisplayPhysHUD(v, p, c)
end

local function HU_dvdss_win(v, p, c)
	if splitscreen and #p return end
	if DVD_endtimer >= TICRATE*7 and p.mo.DVD_addscores
		HU_dvdss_scoretally(v, p, c, DVD_endtimer-TICRATE*7)
		HU_centeredTitlecardDrawString(v, min(-40 + 30*(DVD_endtimer-TICRATE*6), 160), 30, p.mo.skin.." cleared", V_SNAPTOTOP)
		HU_centeredTitlecardDrawString(v, max(380 - 30*(DVD_endtimer-TICRATE*6), 160), 48, mapheaderinfo[gamemap].lvlttl.."!", V_SNAPTOTOP)

	elseif DVD_endtimer >= TICRATE*5
		local flag1 = max(0, V_90TRANS - ((DVD_endtimer-TICRATE*5)/2)*V_10TRANS)
		HU_drawcolumn(v, 160, flag1)	-- draw middle column
		-- draw side columns:
		if DVD_endtimer >= TICRATE*5 + 2
			local timer = (DVD_endtimer - TICRATE*5 - 2)
			for i = 1, min(32, timer*2)
				if i > timer continue end
				local flag2 = max(0, V_90TRANS - ((timer - (i-1)))*V_10TRANS)
				HU_drawcolumn(v, 160 - 8*i, flag2)
				HU_drawcolumn(v, 160 + 8*i, flag2)
			end
		end
	end
end

hud.add(function(v, p, c)
	if mapheaderinfo[gamemap].dvdss
		if DVD_starttime < TICRATE*3
			HU_dvdss_start(v, p, c)
		elseif DVD_endtimer		-- special stage has ended
			if not DVD_stime	-- no time left, thus, we lost
				HU_dvdss_loss(v, p, c)
			else
				HU_dvdssHUD(v, p, c)	-- run this during the ending sequence too, we won't be doing anything fancy
				HU_dvdss_win(v, p, c)
			end
		else
			HU_dvdssHUD(v, p, c)
			HU_timeufo(v, p, c)
		end
	end
end)

addHook("BotTiccmd", function(p)
	if mapheaderinfo[gamemap].dvdss return true end
end)
