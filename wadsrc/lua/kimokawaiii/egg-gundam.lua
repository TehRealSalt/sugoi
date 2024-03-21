local dodevprint = false
local function devprint(t)
	if (dodevprint)
		print(t)
	end
end

freeslot(
	"MT_GUNDAM",
	--"MT_GUNDAM_SHOULDER",
	--"MT_GUNDAM_JOINT",
	"MT_GUNDAM_LAUNCHER",
	"MT_GUNDAM_MISSILE",
	"MT_GUNDAM_SHADOW",
	"MT_MEATYEXPLODE",

	"S_GUNDAM",
	"S_GUNDAM_PAIN",

	--"S_GUNDAM_JOINT",
	--"S_GUNDAM_JOINT2",

	"S_GUNDAM_MISSILE_UP",
	"S_GUNDAM_MISSILE_DOWN",
	"S_GUNDAM_MISSILE_DIE",

	"S_GUNDAM_SHADOW",

	"S_MEATYEXPLODE",

	"SPR_EGDM",
	"SPR_EGDJ",
	"SPR_EGDR",
	"SPR_EGDS",
	"SPR_MSPL"
)

mobjinfo[MT_GUNDAM] = {
	--$Name Egg Gundam Head
	--$Sprite EGDMA1A5
	--$Category SUGOI Bosses
	doomednum = 2634,
	spawnstate = S_GUNDAM,
	painstate = S_GUNDAM_PAIN,
	painsound = sfx_dmpain,
	deathstate = S_GUNDAM,
	deathsound = sfx_cybdth,
	spawnhealth = 12,
	damage = 6,
	radius = 88*FRACUNIT,
	height = 160*FRACUNIT,
	flags = MF_SPECIAL|MF_SHOOTABLE|MF_BOSS|MF_NOGRAVITY
}

--[[
mobjinfo[MT_GUNDAM_SHOULDER] = {
	--$Name Egg Gundam Shoulder Point
	--$Sprite EGDJB0
	--$Category SUGOI Bosses
	doomednum = 2635,
	spawnstate = S_GUNDAM_JOINT2,
	spawnhealth = 1000,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY
}

mobjinfo[MT_GUNDAM_JOINT] = {
	spawnstate = S_GUNDAM_JOINT,
	spawnhealth = 1000,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY
}
]]

mobjinfo[MT_GUNDAM_SHADOW] = {
	spawnstate = S_GUNDAM_SHADOW,
	spawnhealth = 1000,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY
}

mobjinfo[MT_GUNDAM_LAUNCHER] = {
	--$Name Egg Gundam Launcher
	--$Sprite EGDRA0
	--$Category SUGOI Bosses
	doomednum = 2636,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1000,
	radius = 12*FRACUNIT,
	height = 90*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOSECTOR|MF_NOGRAVITY
}

mobjinfo[MT_GUNDAM_MISSILE] = {
	spawnstate = S_GUNDAM_MISSILE_UP,
	spawnhealth = 1,
	deathstate = S_GUNDAM_MISSILE_DIE,
	deathsound = sfx_cybdth,
	speed = 16*FRACUNIT,
	damage = 32*FRACUNIT,
	radius = 12*FRACUNIT,
	height = 90*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_MISSILE|MF_NOGRAVITY|MF_PAIN
}

mobjinfo[MT_MEATYEXPLODE] = {
	spawnstate = S_MEATYEXPLODE,
	spawnhealth = 1000,
	radius = 12*FRACUNIT,
	height = 90*FRACUNIT,
	dispoffset = 1,
	flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_NOGRAVITY|MF_NOCLIPHEIGHT
}

states[S_GUNDAM] = {SPR_EGDM, A, -1, nil, 0, 0, S_GUNDAM}
states[S_GUNDAM_PAIN] = {SPR_EGDM, A, 24, A_Pain, 0, 0, S_GUNDAM}

--states[S_GUNDAM_JOINT] = {SPR_EGDJ, A, -1, nil, 0, 0, S_GUNDAM_JOINT}
--states[S_GUNDAM_JOINT2] = {SPR_EGDJ, B, -1, nil, 0, 0, S_GUNDAM_JOINT2}

function A_GundamMissileDie(mo)
	mo.momx = 0
	mo.momy = 0
	mo.momz = 0
	mo.flags = ($1 & ~MF_PAIN)
	local explode = P_SpawnMobj(mo.x, mo.y, mo.z, MT_MEATYEXPLODE)
	explode.scale = (3*explode.scale)/2
	explode.destscale = explode.scale
end

states[S_GUNDAM_MISSILE_UP] = {SPR_EGDR, A|FF_ANIMATE, -1, nil, 3, 1, S_GUNDAM_MISSILE_UP}
states[S_GUNDAM_MISSILE_DOWN] = {SPR_EGDR, E|FF_ANIMATE, -1, nil, 3, 1, S_GUNDAM_MISSILE_DOWN}
states[S_GUNDAM_MISSILE_DIE] = {SPR_EGDR, I, 10, A_GundamMissileDie, 0, 0, S_NULL}

states[S_GUNDAM_SHADOW] = {SPR_EGDS, A|FF_TRANS50, -1, nil, 0, 0, S_GUNDAM_SHADOW}

states[S_MEATYEXPLODE] = {SPR_MSPL, A|FF_ANIMATE, 13, nil, 12, 1, S_NULL}

-- These sounds are too quiet
sfxinfo[sfx_s3k4d].flags = $1|SF_X2AWAYSOUND
sfxinfo[sfx_s3k5f].flags = $1|SF_X2AWAYSOUND
sfxinfo[sfx_s3k81].flags = $1|SF_X2AWAYSOUND
sfxinfo[sfx_s3k90].flags = $1|SF_X2AWAYSOUND

local moveline = 1000
local moveline2 = 1001
local lrotline = 1002
local rrotline = 1004
local deathline = 2000

-- move by waypoints offsets to the middle for SOME stupid reason
-- instead of the anchor point
-- so let's MANUALLY offset the destination to be where the anchor is...
local centeroffsety = (96<<FRACBITS)
local centeroffsetz = -(40<<FRACBITS)
local armxoffset = (768<<FRACBITS)

local armminx = -(800<<FRACBITS)
local armmaxx = -(224<<FRACBITS)
local armminy = -(480<<FRACBITS) - centeroffsety
local armmaxy = (480<<FRACBITS) - centeroffsety
local armminz = 0 - centeroffsetz
local armmaxz = (512<<FRACBITS) - centeroffsetz

local squishheight = (256<<FRACBITS)
local missileheight = (448<<FRACBITS)
--local numarmjoints = 4

local MODE_SQUISH = 0
local MODE_SHOOT = 1
local MODE_PUNCH = 2
local MODE_SWIPE1 = 3
local MODE_SWIPE2 = 4

local STATE_REST = 0
local STATE_SQUISHAIM = 1
local STATE_SQUISHFIRE = 2
local STATE_SHOOTAIM = 1
local STATE_SHOOTFIRE = 2
local STATE_PUNCHAIM = 1
local STATE_PUNCHFIRE = 2
local STATE_SWIPETOP = 1
local STATE_SWIPEMID = 2
local STATE_SWIPEBOT = 3

local HANDLER_NONE = -1
local HANDLER_RIGHT = 0
local HANDLER_LEFT = 1
local HANDLER_BOTH = 2

local attackpattern = {
	MODE_SQUISH,
	MODE_PUNCH,
	MODE_SHOOT,
	MODE_SQUISH,
	MODE_SHOOT,
	MODE_SWIPE1,
	MODE_SWIPE2,
	MODE_SHOOT,
	MODE_SQUISH,
	MODE_PUNCH,
	MODE_PUNCH,
	MODE_SWIPE1,
	MODE_SHOOT
}

local aplength = #attackpattern

local armwaypoints = nil
--local shoulderpoints = nil

local deathtime = 0

local function moveArm(n, x, y, z, force)
	devprint("moving arm "..n.." to "..x/FRACUNIT..","..y/FRACUNIT..","..z/FRACUNIT)
	local arm = armwaypoints[n]

	-- cap xyz automatically
	local xoff = armxoffset * n
	if (x < armminx + xoff)
		x = armminx + xoff
	end
	if (x > armmaxx + xoff)
		x = armmaxx + xoff
	end

	if (y < armminy)
		y = armminy
	end
	if (y > armmaxy)
		y = armmaxy
	end

	if (z < armminz)
		z = armminz
	end
	if (z > armmaxz)
		z = armmaxz
	end

	if not (force)
	and (arm.aproxpos[0] == x
	and arm.aproxpos[1] == y
	and arm.aproxpos[2] == z)
		-- You're already there
		return
	end

	P_MoveOrigin(arm, x, y, z)

	arm.momx = 0
	arm.momy = 0
	arm.momz = 0

	--[[
	arm.lastpos[0] = x
	arm.lastpos[1] = y
	arm.lastpos[2] = z
	]]

	arm.armmoving = true

	P_LinedefExecute(moveline + n, arm, nil)
end

local function gundamTargetPlayer(mo)
	local midx = -(128<<FRACBITS)
	local available = {}
	local thisside = {}

	for p in players.iterate
		if not (p.mo and p.mo.valid and p.mo.health) continue end
		if not (p.lives) continue end
		if (p.bot or p.spectator or p.exiting) continue end

		table.insert(available, p.mo)

		if (p.mo.z > squishheight) continue end

		if (side == 0)
			if (p.mo.x <= midx)
				table.insert(thisside, p.mo)
			end
		elseif (side == 1)
			if (p.mo.x >= midx)
				table.insert(thisside, p.mo)
			end
		end
	end

	if (#thisside)
		return thisside[P_RandomKey(#thisside)+1]
	elseif (#available)
		return available[P_RandomKey(#available)+1]
	end
end

local function handleArmJoints(arm)
	-- first, let's estimate the arm's positions
	local dist = P_AproxDistance(P_AproxDistance(
		armwaypoints[arm].x - armwaypoints[arm].aproxpos[0],
		armwaypoints[arm].y - armwaypoints[arm].aproxpos[1]),
		armwaypoints[arm].z - armwaypoints[arm].aproxpos[2]
	)

	if (dist < 1)
		dist = 1
	end

	local speed = 24<<FRACBITS -- this is set in the map file

	local momx = FixedMul(FixedDiv(armwaypoints[arm].x - armwaypoints[arm].aproxpos[0], dist), speed)
	local momy = FixedMul(FixedDiv(armwaypoints[arm].y - armwaypoints[arm].aproxpos[1], dist), speed)
	local momz = FixedMul(FixedDiv(armwaypoints[arm].z - armwaypoints[arm].aproxpos[2], dist), speed)

	local prevz = armwaypoints[arm].aproxpos[2]

	if ((dist >> FRACBITS) <= (P_AproxDistance(P_AproxDistance( -- moving by momentum would cause it to overshoot
		armwaypoints[arm].x - armwaypoints[arm].aproxpos[0] - momx,
		armwaypoints[arm].y - armwaypoints[arm].aproxpos[1] - momy),
		armwaypoints[arm].z - armwaypoints[arm].aproxpos[2] - momz) >> FRACBITS))
		armwaypoints[arm].aproxpos[0] = armwaypoints[arm].x
		armwaypoints[arm].aproxpos[1] = armwaypoints[arm].y
		armwaypoints[arm].aproxpos[2] = armwaypoints[arm].z
	else
		armwaypoints[arm].aproxpos[0] = $1 + momx
		armwaypoints[arm].aproxpos[1] = $1 + momy
		armwaypoints[arm].aproxpos[2] = $1 + momz
	end

	-- play crush noise
	if (prevz > armminz and armwaypoints[arm].aproxpos[2] <= armminz)
		S_StartSound(armwaypoints[arm], sfx_s3k5f)
	end

	-- NOW let's start doing stuff with the joints
	--[[
	if not (shoulderpoints[arm] and shoulderpoints[arm].valid)
		devprint("bad shoulder num!")
		return
	end

	if (shoulderpoints[arm].gundamjoints == nil)
		shoulderpoints[arm].gundamjoints = {}
	end

	local newx = armwaypoints[arm].aproxpos[0] - (192 * cos(FixedAngle(armwaypoints[arm].polyobjangle << FRACBITS)))
	local newy = armwaypoints[arm].aproxpos[1] - (192 * sin(FixedAngle(armwaypoints[arm].polyobjangle << FRACBITS)))
	local newz = armwaypoints[arm].aproxpos[2] + (centeroffsetz / 4)

	local stepx = (shoulderpoints[arm].x - newx) / (numarmjoints+1)
	local stepy = (shoulderpoints[arm].y - newy) / (numarmjoints+1)
	local stepz = (shoulderpoints[arm].z - newz) / (numarmjoints+1)

	for i = 1,numarmjoints
		newx = $1 + stepx
		newy = $1 + stepy
		newz = $1 + stepz

		if (shoulderpoints[arm].gundamjoints[i] and shoulderpoints[arm].gundamjoints[i].valid)
			P_TeleportMove(shoulderpoints[arm].gundamjoints[i], newx, newy, newz)
		else
			shoulderpoints[arm].gundamjoints[i] = P_SpawnMobj(newx, newy, newz, MT_GUNDAM_JOINT)
		end
	end
	]]
end

local function handleArmAttack(mo, arm)
	if not (mo.gundaminitalized)
		return
	end

	if (mo.gundam.atkdelay[arm] > 0)
		mo.gundam.atkdelay[arm] = $-1
	end

	local target = nil
	if (mo.gundam.armtarget[arm] and mo.gundam.armtarget[arm].valid)
		target = mo.gundam.armtarget[arm]
	end

	local atkmode = attackpattern[mo.gundam.atkpos[arm]]

	if (mo.gundam.atkstate[arm] == STATE_REST)
		if (mo.gundam.atkdelay[arm] <= 0)
			if (mo.health <= mo.info.damage)
				mo.gundam.atkhandler = HANDLER_BOTH
			elseif (mo.gundam.atkhandler < 2)
				mo.gundam.atkhandler = ($+1) % 2
			end

			--if (mo.gundam.atkhandler == HANDLER_BOTH)
				--mo.gundam.atkpos[arm] = ($+1)
			--else
				mo.gundam.atkpos[arm] = ($+2)
			--end

			if (mo.gundam.atkpos[arm] > aplength)
				mo.gundam.atkpos[arm] = (mo.gundam.atkpos[arm] % aplength) + 1
			end

			atkmode = attackpattern[mo.gundam.atkpos[arm]]

			mo.gundam.atkstate[arm] = 1 -- whatever the first state of the attack is

			if (atkmode == MODE_SWIPE1 or atkmode == MODE_SWIPE2)
				mo.gundam.atkdelay[arm] = TICRATE
				S_StartSound(armwaypoints[arm], sfx_s3k90)
			else
				mo.gundam.atkdelay[arm] = 3*TICRATE
			end

			mo.gundam.armtarget[arm] = nil -- reset target

			devprint("Next attack pos for arm # "..arm..": "..mo.gundam.atkpos[arm])
			devprint("(ID: "..atkmode..", delay: "..mo.gundam.atkdelay[arm]..")")
		end

		moveArm(arm, armwaypoints[arm].restpos[0], armwaypoints[arm].restpos[1], armwaypoints[arm].restpos[2])
		armwaypoints[arm].polyobjdestangle = armwaypoints[arm].restangle
		return
	end

	if (atkmode == MODE_SQUISH)
		armwaypoints[arm].polyobjdestangle = armwaypoints[arm].restangle

		if (mo.gundam.atkstate[arm] == STATE_SQUISHAIM)
			if (mo.gundam.atkdelay[arm] <= 0)
				mo.gundam.atkstate[arm] = STATE_SQUISHFIRE
				mo.gundam.atkdelay[arm] = 3*TICRATE
			end

			if not (target and target.valid and target.health)
				mo.gundam.armtarget[arm] = gundamTargetPlayer(mo, arm+1)
				return
			end

			if (target.z > squishheight) -- squish instantly if your target is above your hand anyway
				mo.gundam.atkstate[arm] = STATE_SQUISHFIRE
				mo.gundam.atkdelay[arm] = 3*TICRATE
				return
			end

			moveArm(arm, target.x, target.y, squishheight + centeroffsetz)
		elseif (mo.gundam.atkstate[arm] == STATE_SQUISHFIRE)
			if (mo.gundam.atkdelay[arm] <= 0)
				mo.gundam.atkstate[arm] = STATE_REST
				mo.gundam.atkdelay[arm] = 3*TICRATE
			end

			moveArm(arm, armwaypoints[arm].aproxpos[0], armwaypoints[arm].aproxpos[1], armminz)
		end
	elseif (atkmode == MODE_SHOOT)
		if (mo.gundam.atkstate[arm] == STATE_SHOOTAIM)
			if (mo.gundam.atkdelay[arm] <= 0)
				mo.gundam.atkstate[arm] = STATE_SHOOTFIRE
				mo.gundam.atkdelay[arm] = 3*TICRATE
			end

			if not (target and target.valid and target.health)
				mo.gundam.armtarget[arm] = gundamTargetPlayer(mo, arm+1)
				return
			end

			moveArm(arm, armwaypoints[arm].restpos[0], armwaypoints[arm].restpos[1], target.z - centeroffsetz)
			armwaypoints[arm].polyobjdestangle = AngleFixed(
				R_PointToAngle2(armwaypoints[arm].x, armwaypoints[arm].y,
				target.x, target.y)) >> FRACBITS
		elseif (mo.gundam.atkstate[arm] == STATE_SHOOTFIRE)
			if (mo.gundam.atkdelay[arm] <= 0)
				mo.gundam.atkstate[arm] = STATE_REST
				mo.gundam.atkdelay[arm] = 3*TICRATE
			end

			-- TRIPLE CHECK that it's in the right spot
			moveArm(arm, armwaypoints[arm].x, armwaypoints[arm].y, armwaypoints[arm].z)

			-- enable flame bombs
			local leftisbomb = false

			local angle = FixedAngle(armwaypoints[arm].polyobjangle << FRACBITS)
			local atkang = angle + FixedAngle(P_RandomRange(-10,10) * FRACUNIT)

			local spawnx = armwaypoints[arm].aproxpos[0] + (224*cos(angle))
			local spawny = armwaypoints[arm].aproxpos[1] + (224*sin(angle))
			local spawnz = armwaypoints[arm].aproxpos[2] + (centeroffsetz / 4)

			if (arm == 0) or not (leftisbomb)
				local cannonnum = (leveltime % 4)
				if (cannonnum == 0)
					spawnz = $1 + (24<<FRACBITS)
				elseif (cannonnum == 1)
					spawnx = $1 + (24 * cos(angle + ANGLE_90))
					spawny = $1 + (24 * sin(angle + ANGLE_90))
				elseif (cannonnum == 2)
					spawnz = $1 - (24<<FRACBITS)
				elseif (cannonnum == 3)
					spawnx = $1 + (24 * cos(angle - ANGLE_90))
					spawny = $1 + (24 * sin(angle - ANGLE_90))
				end
			end

			local destx = spawnx + (192*cos(atkang))
			local desty = spawny + (192*sin(atkang))

			if (leftisbomb and arm == 1)
				local bomb = P_SpawnPointMissile(mo, destx, desty, spawnz + (24<<FRACBITS),
					MT_CYBRAKDEMON_NAPALM_BOMB_LARGE, spawnx, spawny, spawnz)
				mo.gundam.atkdelay[arm] = 0 -- only fire one
			else
				local bullet = P_SpawnPointMissile(mo, destx, desty, spawnz,
					MT_REDBULLET, spawnx, spawny, spawnz) -- see AAZ's lua for MT_REDBULLET
				S_StartSound(bullet, sfx_s3k4d)
			end
		end
	elseif (atkmode == MODE_PUNCH) -- PUNCH
		armwaypoints[arm].polyobjdestangle = armwaypoints[arm].restangle

		if not (target and target.valid and target.health)
			mo.gundam.armtarget[arm] = gundamTargetPlayer(mo, arm+1)
			return
		end

		if (mo.gundam.atkstate[arm] == STATE_PUNCHAIM)
			if (mo.gundam.atkdelay[arm] <= 0)
			or (target.z > squishheight) -- punch instantly if your target is too high
				mo.gundam.atkstate[arm] = STATE_PUNCHFIRE
				mo.gundam.atkdelay[arm] = 2*TICRATE
				S_StartSound(armwaypoints[arm], sfx_s3k90)
			end

			moveArm(arm, target.x, armmaxy, target.z - centeroffsetz)
		elseif (mo.gundam.atkstate[arm] == STATE_PUNCHFIRE)
			if (mo.gundam.atkdelay[arm] <= 0)
				mo.gundam.atkstate[arm] = STATE_REST
				mo.gundam.atkdelay[arm] = 3*TICRATE
			end

			moveArm(arm, armwaypoints[arm].aproxpos[0], armminy, armwaypoints[arm].aproxpos[2])
		end
	elseif (atkmode == MODE_SWIPE1 or atkmode == MODE_SWIPE2) -- SWIPE
		armwaypoints[arm].polyobjdestangle = armwaypoints[arm].restangle

		local x1 = armminx
		local x2 = armmaxx

		if (atkmode == MODE_SWIPE2) -- mirror for other side
			x1 = armmaxx
			x2 = armminx
		end

		if (arm == 1)
			x1 = $1+armxoffset
			x2 = $1+armxoffset
		end

		local midy = (armminy + armmaxy) / 2

		if (mo.gundam.atkstate[arm] == STATE_SWIPETOP)
			if (mo.gundam.atkdelay[arm] <= 0)
				mo.gundam.atkstate[arm] = STATE_SWIPEMID
				mo.gundam.atkdelay[arm] = TICRATE
				S_StartSound(armwaypoints[arm], sfx_s3k90)
			end

			moveArm(arm, x1, armmaxy, armminz)
		elseif (mo.gundam.atkstate[arm] == STATE_SWIPEMID)
			if (mo.gundam.atkdelay[arm] <= 0)
				mo.gundam.atkstate[arm] = STATE_SWIPEBOT
				mo.gundam.atkdelay[arm] = 3*TICRATE
				S_StartSound(armwaypoints[arm], sfx_s3k90)
			end

			moveArm(arm, x2, midy, armminz)
		elseif (mo.gundam.atkstate[arm] == STATE_SWIPEBOT)
			if (mo.gundam.atkdelay[arm] <= 0)
				mo.gundam.atkstate[arm] = STATE_REST
				mo.gundam.atkdelay[arm] = 3*TICRATE
			end

			moveArm(arm, x1, armminy, armminz)
		end
	end
end

addHook("BossThinker", function(mo)
	if not (mo.gundaminitalized)
		armwaypoints = {}
		--shoulderpoints = {}

		for wp in mobjs.iterate()
			if ((armwaypoints[0] and armwaypoints[0].valid)
			and (armwaypoints[1] and armwaypoints[1].valid))
				devprint("got em all, break")
				break
			end

			if not (wp and wp.valid)
				continue
			end

			if (wp.type == MT_TUBEWAYPOINT) -- Waypoints that the polyobjects use for movement
				local n = wp.threshold
				devprint("found waypoint "..n)

				-- set up resting pos
				wp.restpos = {}
				wp.restpos[0] = wp.x
				wp.restpos[1] = wp.y
				wp.restpos[2] = wp.z
				wp.restangle = 270

				-- determine approximate position
				wp.aproxpos = {}
				wp.aproxpos[0] = wp.x
				wp.aproxpos[1] = wp.y
				wp.aproxpos[2] = armminz

				-- set up default faked polyobj ang
				wp.polyobjangle = wp.restangle
				wp.polyobjdestangle = wp.restangle

				if (dodevprint)
					wp.state = S_THOK;
					wp.tics = -1;
					wp.flags = $1 & ~MF_NOSECTOR;
					if (n)
						wp.color = SKINCOLOR_BLUE
					else
						wp.color = SKINCOLOR_RED
					end
				end

				-- lastly, set it in the table
				armwaypoints[n] = wp
			--[[elseif (wp.type == MT_GUNDAM_SHOULDER) -- Shoulder point, for the extra arm segments
				shoulderpoints[AngleFixed(wp.angle)>>FRACBITS] = wp
				wp.flags = $1|MF_NOTHINK -- the only reason it's in the thinker list at all is so we can iterate for it
			]]
			end
		end

		-- initalize movement
		for i=0,1
			moveArm(i, armwaypoints[i].restpos[0], armwaypoints[i].restpos[1], armwaypoints[i].restpos[2])
			S_StartSound(armwaypoints[i], sfx_s3k90) -- play a cool noise
		end

		mo.gundam = {}

		mo.gundam.atkhandler = HANDLER_NONE

		mo.gundam.atkpos = {}
		mo.gundam.atkpos[0] = 1
		mo.gundam.atkpos[1] = 2

		mo.gundam.atkstate = {}
		mo.gundam.atkstate[0] = STATE_SQUISHAIM
		mo.gundam.atkstate[1] = STATE_PUNCHAIM

		mo.gundam.atkdelay = {}
		mo.gundam.atkdelay[0] = 3*TICRATE
		mo.gundam.atkdelay[1] = 3*TICRATE

		mo.gundam.armtarget = {}

		sugoi.SetBoss(mo, "Egg Gundam")
		mo.gundaminitalized = true
	end

	for i=0,1
		if not (armwaypoints[i] and armwaypoints[i].valid)
			P_RemoveMobj(mo)
			devprint("BAD WAYPOINTS?!")
			return
		else
			armwaypoints[i].armmoving = false -- reset moving flag
		end
	end

	if not (mo.health)
		-- Pause timer, increment death animation counter
		stoppedclock = true
		deathtime = $+1
		--devprint("death length: "..deathtime)

		if (deathtime >= 10*TICRATE)
			sugoi.ExitLevel()
		end

		local tint = max(0, NUMTRANSMAPS-((deathtime-TICRATE)/12)+10)
		if (tint < NUMTRANSMAPS)
			for player in players.iterate
				player.exiting = TICRATE -- stop moving, and prevent death
			end
		end

		-- Spawn explosions
		for i=0,4
			local newx = mo.x + (P_RandomRange(-512, 512) << FRACBITS)
			local newy = mo.y + (P_RandomRange(-256, 256) << FRACBITS)
			local newz = mo.z + (P_RandomRange(-768, 0) << FRACBITS)

			local explode = P_SpawnMobj(newx, newy, newz, MT_BOSSEXPLODE)

			explode.scale = explode.scale*4
			explode.destscale = explode.scale

			P_Thrust(explode, FixedAngle(P_RandomRange(0,359)<<FRACBITS), P_RandomRange(0,8)<<FRACBITS)
			explode.momz = P_RandomRange(4,16)<<FRACBITS
			S_StartSound(explode, mo.info.deathsound)
		end

		-- HACK because it doesn't want to stay on top of its falling corpse even when its given gravity
		mo.z = $1-FRACUNIT

		-- Arms fall to the ground
		for i=0,1
			moveArm(i, armwaypoints[i].x, armwaypoints[i].y, armminz, true)
			--shoulderpoints[i].z = $1-FRACUNIT
			handleArmJoints(i)
		end

		return
	end

	-- HACK to get setup like I want it to work
	if (leveltime > 3*TICRATE and mo.gundam.atkhandler == HANDLER_NONE)
		mo.gundam.atkhandler = HANDLER_RIGHT
	end

	if (mo.gundam.atkhandler == HANDLER_RIGHT or mo.gundam.atkhandler == HANDLER_BOTH)
		handleArmAttack(mo, 0) -- right arm
	end
	if (mo.gundam.atkhandler == HANDLER_LEFT or mo.gundam.atkhandler == HANDLER_BOTH)
		handleArmAttack(mo, 1) -- left arm
	end

	for i=0,1
		if not (armwaypoints[i].armmoving) -- can't do multiple polyobj linedef executes at once
			-- auto limit dest angle
			if (armwaypoints[i].polyobjdestangle > 315
			or armwaypoints[i].polyobjdestangle <= 90)
				armwaypoints[i].polyobjdestangle = 315
			elseif (armwaypoints[i].polyobjdestangle < 225)
				armwaypoints[i].polyobjdestangle = 225
			end

			local diff = armwaypoints[i].polyobjdestangle - armwaypoints[i].polyobjangle
			local invert = false
			local dir = 0

			if (diff > 180)
				diff = 360 - $
				invert = true
			end

			if (diff < -180)
				diff = -360 - $
				invert = true
			end

			if (diff != 0)
				if (diff > 0)
					dir = 1
				elseif (diff < 0)
					dir = -1
				end

				if (invert)
					dir = -$
					devprint("invert angle")
				end

				armwaypoints[i].polyobjangle = $+dir
				if (dir > 0)
					--devprint("rotate arm "..i.." left")
					P_LinedefExecute(lrotline+i, nil, nil)
				elseif (dir < 0)
					--devprint("rotate arm "..i.." right")
					P_LinedefExecute(rrotline+i, nil, nil)
				end
			end

			-- make sure these are NEVER above 359 or below 0...
			armwaypoints[i].polyobjangle = ($ % 360)
			armwaypoints[i].polyobjdestangle = ($ % 360)
		end

		-- Finally, estimate polyobject's current position & move shoulder segments
		handleArmJoints(i)
	end
end, MT_GUNDAM)

addHook("MobjSpawn", function(mo)
	P_SetScale(mo, (3*mo.scale)/2)
	mo.destscale = mo.scale
end, MT_GUNDAM)

addHook("MobjDeath", function(mo)
	P_LinedefExecute(deathline, mo, nil)
	S_FadeOutStopMusic(10*MUSICRATE)

	--[[
	-- Pop arms off
	if (shoulderpoints and shoulderpoints.gundamjoints)
		for arm = 0,1
			for i = 1,numarmjoints
				if (shoulderpoints[arm].gundamjoints[i] and shoulderpoints[arm].gundamjoints[i].valid)
					shoulderpoints[arm].gundamjoints[i].flags = ($1|MF_NOCLIPHEIGHT) & ~(MF_NOTHINK|MF_NOGRAVITY)
					P_InstaThrust(shoulderpoints[arm].gundamjoints[i],
						FixedAngle(P_RandomRange(0,359)<<FRACBITS),
						P_RandomRange(4,32) << FRACBITS)
					shoulderpoints[arm].gundamjoints[i].momz = P_RandomRange(4,32) << FRACBITS
					shoulderpoints[arm].gundamjoints[i].fuse = 3*TICRATE
				end
			end
		end
	end
	]]
end, MT_GUNDAM)

addHook("ShouldDamage", function(t,i,s)
	-- only allow damage from player sources
	if ((i and i.valid) and (i.player and i.player.valid))
	or ((s and s.valid) and (s.player and s.player.valid))
		return true
	else
		return false
	end
end, MT_GUNDAM)

addHook("TouchSpecial", function(special, toucher)
	local player = toucher.player

	if not (player and player.valid)
		return
	end

	-- Players should bounce off Gundam, regardless of if he can be hurt or not.
	if (special.flags2 & MF2_FRET)
		if (((player.pflags & PF_NIGHTSMODE) and (player.pflags & PF_DRILLING))
		or (player.pflags & (PF_JUMPED|PF_SPINNING|PF_GLIDING))
		or player.powers[pw_invulnerability] or player.powers[pw_super])
			if (P_MobjFlip(toucher) * toucher.momz < 0)
				toucher.momz = -toucher.momz;
			end
			toucher.momx = -toucher.momx
			toucher.momy = -toucher.momy
		elseif (((toucher.z < special.z and !(toucher.eflags & MFE_VERTICALFLIP))
		or (toucher.z + toucher.height > special.z + special.height and (toucher.eflags & MFE_VERTICALFLIP)))
		and player.charability == CA_FLY
		and (player.powers[pw_tailsfly]
		or (toucher.state >= S_PLAY_SPC1 and toucher.state <= S_PLAY_SPC4)))
			toucher.momz = -toucher.momz/2
		end
	end
end, MT_GUNDAM)

addHook("MobjThinker", function(mo)
	local time = leveltime
	local freq = (3*TICRATE)/2

	if not (mo.target and mo.target.valid) -- look for gundam to pass to the missiles
		for mt in mapthings.iterate
			if (mt and mt.valid and mt.mobj and mt.mobj.valid
			and mt.mobj.type == MT_GUNDAM)
				mo.target = mt.mobj
			end
		end
	else
		if not (mo.target.health)
			P_RemoveMobj(mo)
			return
		elseif (mo.target.health <= mo.target.info.damage)
			freq = $1 / 2
		end
	end

	if (mo.flags2 & MF2_AMBUSH)
		time = $1 + (freq/2)
	end

	if (time % freq != 0)
		return
	end

	local fired = false

	for player in players.iterate
		if not (player.mo and player.mo.valid)
			continue
		end

		if (player.bot == 1)
			continue
		end

		if (player.mo.z > missileheight) -- fire at players who are on the arms!
			local missile = P_SpawnMobj(mo.x, mo.y, mo.z, MT_GUNDAM_MISSILE)
			missile.shadowscale = FRACUNIT*3
			missile.tracer = player.mo
			missile.target = mo.target
			missile.momz = 64<<FRACBITS
			fired = true
		end
	end

	if (fired) -- don't play the sound for EVERY lob, like seesound would
		S_StartSound(mo, sfx_s3k81)
	end
end, MT_GUNDAM_LAUNCHER)

addHook("MobjThinker", function(mo)
	if not (mo.target and mo.target.valid and mo.target.health)
		P_RemoveMobj(mo)
		return
	end

	if not (mo.health)
		-- for the love of god STOP MOVING ON DEATH
		mo.momx = 0
		mo.momy = 0
		return
	end

	if (mo.tracer and mo.tracer.valid and mo.tracer.health)
	and (mo.momz > 0) -- rising
		local a = R_PointToAngle2(mo.x, mo.y, mo.tracer.x, mo.tracer.y);
		local spd = min(mo.info.speed, R_PointToDist2(mo.x, mo.y, mo.tracer.x, mo.tracer.y));
		mo.momx = FixedMul(spd, cos(a));
		mo.momy = FixedMul(spd, sin(a));
	else
		mo.momx = 0
		mo.momy = 0
	end

	P_CheckPosition(mo, mo.x, mo.y, mo.z);

	if (mo.momz > -mo.info.damage)
		mo.momz = $-FRACUNIT
		if (mo.momz < -mo.info.damage)
			mo.momz = -mo.info.damage;
		end
	end

	if (mo.momz > 0 and mo.state == S_GUNDAM_MISSILE_DOWN)
		mo.state = S_GUNDAM_MISSILE_UP
	elseif (mo.momz < 0 and mo.state == S_GUNDAM_MISSILE_UP)
		mo.state = S_GUNDAM_MISSILE_DOWN
	end
end, MT_GUNDAM_MISSILE)

local function reset(map)
	armwaypoints = nil
	--shoulderpoints = nil
	deathtime = 0
end

addHook("MapChange", reset)
--addHook("MapLoad", reset)

addHook("NetVars", function(net)
	armwaypoints = net(armwaypoints)
	--shoulderpoints = net(shoulderpoints)
	deathtime = net(deathtime)
end)

addHook("MobjThinker", function(mo)
	if (armwaypoints != nil) -- quick way of checking you're in egg gundam's stage
		mo.pmomz = 0 -- REMOVE dumb ass platform z
		mo.eflags = $1 & ~MFE_APPLYPMOMZ
	end
end, MT_PLAYER)

local function endtint(v)
	local white = v.cachePatch("WHIPTE")
	local screenscale = max(v.width()/v.dupx(), v.height()/v.dupy())
	local time = deathtime-TICRATE

	if (time < 0) return end

	local tint = max(0, NUMTRANSMAPS-(time/12)+10)
	if (tint >= NUMTRANSMAPS) return end

	v.drawScaled(-1, -1, (screenscale*FRACUNIT)+2, white, V_SNAPTOTOP|V_SNAPTOLEFT|(tint<<FF_TRANSSHIFT))
end

hud.add(endtint)
