freeslot(
	"MT_SOAES",
	"MT_SOAES_BALL",
	"MT_SOAES_PARTICLE",

	"S_SOAES",
	"S_SOAES_INTRO",
	"S_SOAES_PAIN",
	"S_SOAES_FORCETELEPORT",
	"S_SOAES_DEATH",

	"S_SOAES_BALL",
	"S_SOAES_BALL2",
	"S_SOAES_BALL3",
	"S_SOAES_BALLEXPLODE",

	"S_SOAES_CHARGEORB1",
	"S_SOAES_CHARGEORB2",
	"S_SOAES_CHARGEORB3",
	"S_SOAES_CHARGEORB4",
	"S_SOAES_CHARGEORB5",

	"S_SOAES_CRYSTAL",

	"S_SOAES_BALLWARNING1",
	"S_SOAES_BALLWARNING2",

	"SPR_SAES",
	"SPR_SAEB",
	"SPR_SAEO",
	"SPR_SAED",
	"SPR_SAEC",

	"sfx_saestp"
)

mobjinfo[MT_SOAES] = {
	--$Name Shadow of Anime Eyes Sonic
	--$Sprite SAESA1
	--$Category SUGOI Bosses
	doomednum = 2995,
	spawnstate = S_SOAES,
	painstate = S_SOAES_PAIN,
	painsound = sfx_dmpain,
	deathstate = S_SOAES_DEATH,
	deathsound = sfx_cybdth,
	spawnhealth = 16,
	damage = 8,
	speed = 16*FRACUNIT,
	radius = 40*FRACUNIT,
	height = 64*FRACUNIT,
	flags = MF_BOSS|MF_NOGRAVITY|MF_NOCLIPHEIGHT
}

mobjinfo[MT_SOAES_BALL] = {
	spawnstate = S_SOAES_BALL,
	deathstate = S_SOAES_BALLEXPLODE,
	deathsound = sfx_s3k52,
	spawnhealth = 1000,
	damage = 20,
	speed = 24*FRACUNIT,
	radius = 6*FRACUNIT,
	height = 42*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_MISSILE|MF_NOGRAVITY
}

mobjinfo[MT_SOAES_PARTICLE] = {
	spawnstate = S_SOAES_CHARGEORB1,
	spawnhealth = 1000,
	dispoffset = 1,
	radius = 8*FRACUNIT,
	height = 16*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOCLIPHEIGHT|MF_SCENERY|MF_NOGRAVITY
}

-- These need to be defined later
local SOAES_PainFollowup
local SOAES_DoMultiBall

states[S_SOAES] = {SPR_SAES, A|FF_FULLBRIGHT|FF_ANIMATE, -1, nil, 3, 3, S_SOAES}
states[S_SOAES_INTRO] = {SPR_SAES, A|FF_FULLBRIGHT, -1, nil, 0, 0, S_SOAES_INTRO}
states[S_SOAES_PAIN] = {SPR_SAES, A|FF_FULLBRIGHT|FF_ANIMATE, 24, A_Pain, 3, 3, S_SOAES_FORCETELEPORT}
states[S_SOAES_FORCETELEPORT] = {SPR_SAES, A|FF_FULLBRIGHT, 0, function(mo) SOAES_PainFollowup(mo) end, 0, 0, S_SOAES}
states[S_SOAES_DEATH] = {SPR_SAES, A|FF_FULLBRIGHT|FF_ANIMATE, -1, nil, 3, 2, S_SOAES_DEATH}

states[S_SOAES_BALL] = {SPR_SAEB, A|FF_ANIMATE|FF_FULLBRIGHT, -1, nil, 1, 4, S_SOAES_BALL}
states[S_SOAES_BALL2] = {SPR_SAEB, C|FF_ANIMATE|FF_FULLBRIGHT, -1, nil, 1, 4, S_SOAES_BALL2}
states[S_SOAES_BALL3] = {SPR_SAEB, E|FF_ANIMATE|FF_FULLBRIGHT, -1, nil, 1, 4, S_SOAES_BALL3}

states[S_SOAES_BALLEXPLODE] = {SPR_SAED, A|FF_ANIMATE|FF_FULLBRIGHT, 12, function(mo) SOAES_DoMultiBall(mo) end, 5, 2, S_NULL}
--states[S_SOAES_BALLEXPLODE2] = {SPR_SAED, G|FF_ANIMATE|FF_FULLBRIGHT, 12, nil, 5, 2, S_NULL}

states[S_SOAES_CHARGEORB1] = {SPR_SAEO, A|FF_FULLBRIGHT, -1, nil, 0, 0, S_SOAES_CHARGEORB1}
states[S_SOAES_CHARGEORB2] = {SPR_SAEO, B|FF_FULLBRIGHT, -1, nil, 0, 0, S_SOAES_CHARGEORB2}
states[S_SOAES_CHARGEORB3] = {SPR_SAEO, C|FF_FULLBRIGHT, -1, nil, 0, 0, S_SOAES_CHARGEORB3}
states[S_SOAES_CHARGEORB4] = {SPR_SAEO, D|FF_FULLBRIGHT, -1, nil, 0, 0, S_SOAES_CHARGEORB4}
states[S_SOAES_CHARGEORB5] = {SPR_SAEO, E|FF_FULLBRIGHT, -1, nil, 0, 0, S_SOAES_CHARGEORB5}

states[S_SOAES_CRYSTAL] = {SPR_SAEC, A|FF_ANIMATE|FF_FULLBRIGHT, 2*TICRATE, nil, 17, 2, S_NULL}

states[S_SOAES_BALLWARNING1] = {SPR_SAEB, G|FF_FULLBRIGHT|FF_TRANS30, 2, nil, 0, 0, S_SOAES_BALLWARNING2}
states[S_SOAES_BALLWARNING2] = {SPR_SAEB, G|FF_FULLBRIGHT|FF_TRANS70, 2, nil, 0, 0, S_SOAES_BALLWARNING1}

sfxinfo[sfx_saestp].flags = SF_X2AWAYSOUND

--sfxinfo[sfx_s3k81].flags = $1|SF_X2AWAYSOUND -- Already loudened by Egg Gundam
sfxinfo[sfx_s3k8a].flags = $1|SF_X2AWAYSOUND
sfxinfo[sfx_s3k9f].flags = $1|SF_X2AWAYSOUND
sfxinfo[sfx_s3kc6s].flags = $1|SF_X2AWAYSOUND
sfxinfo[sfx_s3kd5l].flags = $1|SF_X4AWAYSOUND

-- Attack IDs
local ATK_WAIT = 0 -- They're just floating there... menacingly!
local ATK_TELEPORT = 1 -- Teleport somewhere else
local ATK_PHSHOT = 2 -- Shoot normally at everyone, reference to SUGOI Purple Heart
local ATK_MULTISHOT = 3 -- Attack in all directions
local ATK_SPREADSHOT = 4 -- Attack in a cone
local ATK_BALLDROP = 5 -- Scatter gravity projectiles everywhere
local ATK_HOMINGSHOT = 6 -- Homing shots that stop & go
local ATK_RAINCLOUD = 7 -- Summon shots from above
local ATK_FINALE = 8 -- Final hell attack

-- Ball types
local BALL_NORMAL = 0
local BALL_BOUNCE = 1
local BALL_HOMING = 2
local BALL_MULTI = 3

-- chargeup lengths for each attack
local chargeup = {
	[ATK_WAIT] = 0,
	[ATK_TELEPORT] = 0,
	[ATK_PHSHOT] = TICRATE/3,
	[ATK_MULTISHOT] = TICRATE/2,
	[ATK_SPREADSHOT] = (2*TICRATE)/3,
	[ATK_BALLDROP] = TICRATE/3,
	[ATK_HOMINGSHOT] = (2*TICRATE)/3,
	[ATK_RAINCLOUD] = 2*TICRATE,
	[ATK_FINALE] = 0
}

local attackpattern = {
	{ATK_WAIT, 2*TICRATE, 0, 0},
	{ATK_PHSHOT, 6, BALL_NORMAL, 0},
	{ATK_WAIT, 2*TICRATE, 0, 0},
	{ATK_MULTISHOT, 6, 8, BALL_NORMAL},
	{ATK_WAIT, TICRATE, 0, 0},
	{ATK_TELEPORT, 0, 0, 0},
	{ATK_PHSHOT, 6, BALL_NORMAL, 0},
	{ATK_WAIT, 2*TICRATE, 0, 0},
	{ATK_MULTISHOT, 4, 8, BALL_NORMAL},
	{ATK_WAIT, TICRATE, 0, 0},
	{ATK_PHSHOT, 6, 1, 0},
	{ATK_WAIT, TICRATE, 0, 0},
	{ATK_TELEPORT, 0, 0, 0},
	{ATK_WAIT, 2*TICRATE, 0, 0},
	{ATK_MULTISHOT, 3, 4, BALL_NORMAL},
	{ATK_MULTISHOT, 3, 9, BALL_NORMAL},
	{ATK_MULTISHOT, 3, 17, BALL_NORMAL},
	{ATK_WAIT, 2*TICRATE, 0, 0},
	{ATK_PHSHOT, 6, BALL_NORMAL, 0},
	{ATK_PHSHOT, 2, BALL_BOUNCE, 0},
	{ATK_WAIT, TICRATE, 0, 0},
	{ATK_SPREADSHOT, 4, 3, BALL_NORMAL},
	{ATK_SPREADSHOT, 4, 4, BALL_NORMAL},
	{ATK_SPREADSHOT, 4, 3, BALL_NORMAL},
	{ATK_SPREADSHOT, 4, 4, BALL_NORMAL},
	{ATK_WAIT, 2*TICRATE, 0, 0},
	{ATK_TELEPORT, 0, 0, 0},
	{ATK_PHSHOT, 6, BALL_BOUNCE, 0},
	{ATK_TELEPORT, 0, 0, 0},
	{ATK_WAIT, 2*TICRATE, 0, 0},
	{ATK_SPREADSHOT, 3, 3, BALL_BOUNCE},
	{ATK_MULTISHOT, 3, 16, BALL_NORMAL},
}

local pinchpattern = {
	{ATK_BALLDROP, 4, 0, 0},
	{ATK_WAIT, TICRATE, 0, 0},
	{ATK_TELEPORT, 0, 0, 0},
	{ATK_HOMINGSHOT, 6, 0, 0},
	{ATK_WAIT, 3*TICRATE, 0, 0},
	{ATK_SPREADSHOT, 2, 4, BALL_BOUNCE},
	{ATK_SPREADSHOT, 2, 3, BALL_BOUNCE},
	{ATK_WAIT, 2*TICRATE, 0, 0},
	{ATK_TELEPORT, 0, 0, 0},
	{ATK_MULTISHOT, 6, 16, BALL_NORMAL},
	{ATK_TELEPORT, 0, 0, 0},
	{ATK_MULTISHOT, 3, 8, BALL_NORMAL},
	{ATK_BALLDROP, 4, 0, 0},
	{ATK_WAIT, 2*TICRATE, 0, 0},
	{ATK_RAINCLOUD, 0, 0, 0},
	{ATK_TELEPORT, 0, 0, 0},
	{ATK_MULTISHOT, 1, 3, BALL_BOUNCE},
	{ATK_MULTISHOT, 1, 5, BALL_BOUNCE},
	{ATK_SPREADSHOT, 6, 6, BALL_NORMAL},
	{ATK_TELEPORT, 0, 0, 0},
	{ATK_TELEPORT, 0, 0, 0},
	{ATK_WAIT, TICRATE, 0, 0},
	{ATK_TELEPORT, 0, 0, 0},
	{ATK_SPREADSHOT, 4, 3, BALL_NORMAL},
	{ATK_MULTISHOT, 3, 3, BALL_BOUNCE},
	{ATK_WAIT, TICRATE, 0, 0},
	{ATK_TELEPORT, 0, 0, 0},
	{ATK_RAINCLOUD, 0, 0, 0},
	{ATK_HOMINGSHOT, 4, 0, 0},
	{ATK_WAIT, TICRATE, 0, 0},
	{ATK_HOMINGSHOT, 8, 0, 0},
	{ATK_WAIT, 3*TICRATE, 0, 0},
}

local patternlen = 32 -- because #attackpattern didn't want to work for unknown reasons

local telefxdist = 32
local telefxtime = 8
local finalatktime = 40*TICRATE

local themusic
local bosscenter

local intro = 0
local death = 0
local deathflash = 0

local floatheight = 24<<FRACBITS

local function ATK_SetBallFlags(ball, type)
	if not (ball and ball.valid)
		return
	end

	-- Give extra knockback
	--ball.flags2 = $1|MF2_EXPLOSION
	-- Make bigger
	ball.scale = (4 * $1) / 3

	-- Set ball type
	ball.extravalue1 = type

	if (type == BALL_BOUNCE) -- bounce
		ball.state = S_SOAES_BALL2
		ball.flags = $1|MF_BOUNCE
		ball.fuse = 7*TICRATE
	elseif (type == BALL_HOMING) -- homing
		ball.cvmem = 0
		ball.extravalue2 = TICRATE/2
		ball.fuse = 4*TICRATE
	end
end

SOAES_DoMultiBall = function(mo)
	if (mo.extravalue1 != BALL_MULTI)
		return
	end

	-- Multi ball
	for i = 0,2
		local ang = mo.angle + FixedAngle((i * (360 / 3))<<FRACBITS)
		local ball = P_SpawnPointMissile(mo,
			mo.x + (24*cos(ang)),
			mo.y + (24*sin(ang)),
			mo.z,
			MT_SOAES_BALL,
			mo.x, mo.y, mo.z
		)
		if (ball and ball.valid)
			ATK_SetBallFlags(ball, BALL_NORMAL)
			ball.target = mo.target
			ball.tracer = mo.tracer
		end
	end
end

local function ATK_RandomTarget()
	local available = {}
	for player in players.iterate
		if not (player.mo and player.mo.valid) continue end
		if not (player.mo.health) continue end
		if not (player.lives) continue end
		if (player.bot or player.spectator or player.exiting) continue end

		table.insert(available, player.mo)
	end

	if (#available > 0)
		return available[P_RandomKey(#available)+1]
	end
end

local function ATK_ClosestTarget(mo)
	local bestmo
	local bestdist = 2048<<FRACBITS

	for player in players.iterate do
		if not (player.mo and player.mo.valid) continue end
		if not (player.mo.health) continue end
		if not (player.lives) continue end
		if (player.bot or player.spectator or player.exiting) continue end

		local distance = R_PointToDist2(mo.x, mo.y, player.mo.x, player.mo.y)

		if (distance < bestdist)
			bestmo = player.mo
			bestdist = distance
		end
	end

	if (bestmo and bestmo.valid)
		return bestmo
	end
end

--[[
local function ATK_CreateRingProjectile(src, destx, desty, x, y, z, num)
	local master = P_SpawnMobj(x, y, z, MT_SOAES_RINGTHINKER)
	master.angle = R_PointToAngle2(x, y, destx, desty)
	P_InstaThrust(master, master.angle, master.info.speed)
	master.target = src

	for i=1,num
		local dist = (num * mobjinfo[MT_SOAES_BALL].radius) >> 1
		local newangle = FixedAngle(((i-1) * (360 / num)) << FRACBITS)

		local seg = P_SpawnMobj(
			x + (dist * cos(newangle)),
			y + (dist * sin(newangle)),
			z, MT_SOAES_BALL
		)
		seg.angle = newangle
		seg.extravalue1 = num

		seg.target = src
		seg.tracer = master
	end
end
]]

local function ATK_SpawnFinaleHexagons(mo, warning)
	local radius = 2048 --1536
	local offset = 192 --128

	local y = (bosscenter.y >> FRACBITS) - radius
	local maxy = (bosscenter.y >> FRACBITS) + radius
	local superaltx = false

	while (y <= maxy)
		local x = (bosscenter.x >> FRACBITS) - radius
		local maxx = (bosscenter.x >> FRACBITS) + radius
		local altx = superaltx

		if (superaltx)
			x = $1 - offset
			maxx = $1 + offset
			superaltx = false
		else
			superaltx = true
		end

		while (x <= maxx)
			if (warning)
				local warn = P_SpawnMobj(
					x<<FRACBITS,
					y<<FRACBITS,
					bosscenter.z + floatheight,
					MT_SOAES_PARTICLE
				)
				if (warn and warn.valid)
					warn.state = S_SOAES_BALLWARNING1
					warn.fuse = 5*TICRATE
					warn.scale = (4*$1)/3
				end
			else
				for i = 0,2 --5
					local offset = 0 --= (360 << FRACBITS) / 3
					local ang = ANGLE_180

					--ang = $1 + FixedAngle((i % 3) * offset)

					if ((i % 3) == 1)
						offset = FixedAngle(244<<FRACBITS)
					elseif ((i % 3) == 2)
						offset = FixedAngle(296<<FRACBITS)
					end

					if (altx)
						ang = 0
					end

					ang = $1 + offset

					local ball = P_SpawnPointMissile(mo,
						x*FRACUNIT + (24*cos(ang)),
						y*FRACUNIT + (24*sin(ang)),
						bosscenter.z + floatheight,
						MT_SOAES_BALL,
						x*FRACUNIT,
						y*FRACUNIT,
						bosscenter.z + floatheight
					)

					if (ball and ball.valid)
						ATK_SetBallFlags(ball, 0)
						--ball.scale = (3*$1)>>1
						ball.flags = $1|MF_NOCLIP|MF_NOCLIPHEIGHT
						ball.cusval = 1 -- disable afterimages
						--ball.fuse = 30*TICRATE

						--[[
						if (i > 2)
							ball.momx = $1 / 12
							ball.momy = $1 / 12
						else
							ball.momx = $1 / 6
							ball.momy = $1 / 6
						end
						]]

						ball.momx = $1 / 9
						ball.momy = $1 / 9
					end
				end
			end

			if (altx)
				x = $1 + (offset<<2)
				altx = false
			else
				x = $1 + (offset<<1)
				altx = true
			end
		end

		y = $1 + (offset<<1)
	end

	if (warning)
		S_StartSound(nil, sfx_s3ka1)
	else
		S_StartSound(nil, sfx_s3k81)
	end
end

local function ATK_WipeBullets()
	for mo in mobjs.iterate()
		if (mo and mo.valid)
		and (mo.type == MT_SOAES_BALL)
			P_KillMobj(mo)
		end
	end
end

local function ATK_AttackStart(mo)
	-- Remove target every new attack -- it should be set in the attack function
	mo.target = nil

	-- Quit moving inbetween attacks
	mo.momx = 0
	mo.momy = 0
	mo.momz = 0

	-- Reset hover
	mo.soaes.hoverval = 0

	-- Charing up tell animation
	mo.soaes.chargeup = chargeup[mo.soaes.attackid]
	if (mo.soaes.chargeup > 0)
		mo.soaes.chargeup = $1+telefxtime
		S_StartSound(mo, sfx_s3kc6s)
	end

	if (mo.soaes.attackid == ATK_RAINCLOUD)
		S_StartSound(nil, sfx_athun1)
	end

	if (mo.soaes.attackid == ATK_WAIT)
		mo.soaes.attackdelay = mo.soaes.attackv1
	elseif (mo.soaes.attackid == ATK_TELEPORT)
		mo.flags = $1 & ~(MF_SPECIAL|MF_SHOOTABLE)
		mo.flags2 = $1|MF2_DONTDRAW

		for i=0,7
			local ghost = P_SpawnGhostMobj(mo)
			ghost.momx = (telefxdist/telefxtime) * cos(ANGLE_45*i)
			ghost.momy = (telefxdist/telefxtime) * sin(ANGLE_45*i)
			ghost.fuse = telefxtime
		end

		S_StartSound(mo, sfx_s3k8a)
		mo.soaes.attackdelay = TICRATE
	elseif (mo.soaes.attackid == ATK_PHSHOT)
		mo.soaes.attackdelay = 5*mo.soaes.attackv1
		if (mo.health >= mo.info.spawnhealth)
			-- First hit is slow
			mo.soaes.attackdelay = $1<<1
		end
	elseif (mo.soaes.attackid == ATK_MULTISHOT)
		mo.soaes.attackdelay = 8*mo.soaes.attackv1
	elseif (mo.soaes.attackid == ATK_SPREADSHOT)
		mo.target = ATK_RandomTarget()
		mo.soaes.attackdelay = 4*mo.soaes.attackv1
	elseif (mo.soaes.attackid == ATK_BALLDROP)
		mo.soaes.attackdelay = 2*TICRATE
	elseif (mo.soaes.attackid == ATK_HOMINGSHOT)
		mo.soaes.attackdelay = 1
	elseif (mo.soaes.attackid == ATK_RAINCLOUD)
		mo.soaes.attackdelay = 64
	elseif (mo.soaes.attackid == ATK_FINALE)
		mo.soaes.attackdelay = finalatktime

		ATK_WipeBullets()
		ATK_SpawnFinaleHexagons(mo, true)

		local spd = R_PointToDist2(mo.x, mo.y, bosscenter.x, bosscenter.y) / TICRATE
		local ang = R_PointToAngle2(mo.x, mo.y, bosscenter.x, bosscenter.y)
		mo.momx = FixedMul(spd, cos(ang))
		mo.momy = FixedMul(spd, sin(ang))
		mo.momz = ((bosscenter.z + floatheight) - mo.z) / TICRATE
	end

	mo.soaes.attackdelay = $1+1 -- buffer tic
end

local function ATK_AttackEnd(mo)
	--mo.soaes.attackdelay = 0
	if (mo.soaes.attackid == ATK_TELEPORT)
		mo.flags = $1|MF_SPECIAL|MF_SHOOTABLE
		mo.flags2 = $1 & ~MF2_DONTDRAW
	end
end

local function ATK_SetUpNext(mo, force)
	-- Run previous attack's end
	ATK_AttackEnd(mo)

	if (force != nil)
		-- Force to a specific attack
		mo.soaes.attackid = force
		mo.soaes.attackv1 = 0
		mo.soaes.attackv2 = 0
		mo.soaes.attackv3 = 0
	else
		-- Table of new attack info
		local atkinfo
		if (mo.health <= mo.info.damage)
			atkinfo = pinchpattern[mo.soaes.attackpos]
		else
			atkinfo = attackpattern[mo.soaes.attackpos]
		end

		-- Set new attack ID
		mo.soaes.attackid = atkinfo[1]
		mo.soaes.attackv1 = atkinfo[2]
		mo.soaes.attackv2 = atkinfo[3]
		mo.soaes.attackv3 = atkinfo[4]

		-- Set pattern position for next call
		mo.soaes.attackpos = $1+1
	end

	if (mo.soaes.attackpos > patternlen) -- Reset if above table length
	or (mo.health >= mo.info.spawnhealth and mo.soaes.attackpos > 2) -- Only use first 2 attacks on the first hit
		mo.soaes.attackpos = 1
	end

	-- Run new attack's start
	ATK_AttackStart(mo)
end

SOAES_PainFollowup = function(mo)
	if (mo.health == 1)
		-- Start final attack at 1 health
		ATK_SetUpNext(mo, ATK_FINALE)
	else
		-- Teleport away after being hit
		ATK_SetUpNext(mo, ATK_TELEPORT)
		mo.flags2 = $1 & ~MF2_FRET
	end
end

--[[
local function SOAES_Hover(mo)
	mo.z = $1 + (16 * sin(FixedAngle((mo.soaes.hoverval % 360) << FRACBITS)))
	mo.soaes.hoverval = $1+1

	local ghost = P_SpawnGhostMobj(mo)
	ghost.fuse = 4
end
]]

local function ATK_Wait(mo)
	-- Float around a bit
	mo.z = bosscenter.z + floatheight
	--SOAES_Hover(mo)

	-- Too close to a player, propel away from them
	local newtarget = ATK_ClosestTarget(mo)
	if (newtarget and newtarget.valid)
		mo.target = newtarget
	end

	if (mo.target and mo.target.valid)
		mo.angle = R_PointToAngle2(mo.x, mo.y, mo.target.x, mo.target.y)

		if (R_PointToDist2(mo.x, mo.y, mo.target.x, mo.target.y) < 256<<FRACBITS)
			P_Thrust(mo, mo.angle + ANGLE_180, mo.info.speed>>4)
		else
			P_InstaThrust(mo, mo.angle, mo.info.speed)
		end
	end
end

local function SOAES_CheckTelePos(soaes, mo)
	if (mo.z > (bosscenter.z + 128<<FRACBITS))
		return -- don't count flying players
	end

	if (mo.player and mo.player.valid)
		return true
	end
end

local function ATK_Teleport(mo)
	-- Spawn afterimage effect before reappearing
	if (mo.soaes.attackdelay == telefxtime)
		-- Find a place that isn't taken up by a player, so you don't cheap hit 'em.
		-- (If nothing's free, then fuck it.)

		local angi = P_RandomRange(0,7) -- Pick random angle

		-- Blockmap iteration returns false if the search was stopped at any point.
		local goodpos = false
		local tries = 8

		while ((not goodpos) and (tries > 0))
			angi = $1+1
			if (angi > 7)
				angi = 0
			end

			-- Move to new position
			P_SetOrigin(mo,
				bosscenter.x + (640 * cos(angi * ANGLE_45)),
				bosscenter.y + (640 * sin(angi * ANGLE_45)),
				bosscenter.z + floatheight
			)

			local radius = mo.info.radius<<2 -- Make sure there's plenty of room for the player to react
			goodpos = searchBlockmap("objects", SOAES_CheckTelePos, mo,
				mo.x - radius, mo.x + radius, mo.y - radius, mo.y + radius)
			tries = $1-1
		end

		-- Point toward the middle.
		mo.angle = R_PointToAngle2(mo.x, mo.y, bosscenter.x, bosscenter.y)

		-- Visual & stuff
		S_StartSound(mo, sfx_saestp)
		for i=0,7
			local ghost = P_SpawnGhostMobj(mo)
			P_SetOrigin(ghost,
				mo.x + (telefxdist * cos(ANGLE_45*i)),
				mo.y + (telefxdist * sin(ANGLE_45*i)),
				mo.z
			)
			ghost.momx = (telefxdist/telefxtime) * cos((ANGLE_45*i) + ANGLE_180)
			ghost.momy = (telefxdist/telefxtime) * sin((ANGLE_45*i) + ANGLE_180)
			ghost.fuse = telefxtime
		end
	end
end

local function ATK_EstimationVal(mo, target)
	local est = R_PointToDist2(mo.x, mo.y, target.x, target.y) / (mobjinfo[MT_SOAES_BALL].speed << 1)
	local ang = R_PointToAngle2(mo.x, mo.y, target.x + (target.momx * est), target.y + (target.momy * est))
	if (abs(mo.angle - ang) > ANGLE_90)
		-- Don't turn stupidly hard because of thok
		-- Might rarely cause an odd projectile to be thrown slightly more to the side
		-- but it'll be corrected near instantly so I'm not too bothered -- better than shooting OPPOSITE from the player
		return 0
	else
		return est
	end
end

local function ATK_PurpleHeartShot(mo)
	mo.z = bosscenter.z + floatheight
	local newtarget = ATK_ClosestTarget(mo)
	if (newtarget and newtarget.valid)
		mo.target = newtarget
		mo.angle = R_PointToAngle2(mo.x, mo.y, mo.target.x, mo.target.y)
	end

	local freq = 5
	if (mo.health >= mo.info.spawnhealth)
		-- First hit is slow, like the original's normal phase
		-- Every hit after is fast, like the original's pinch
		freq = $1<<1
	end

	-- Only fire at the frequency we want
	if (mo.soaes.attackdelay % freq)
		return
	end

	for player in players.iterate do
		if not (player.mo and player.mo.valid)
		or not (player.mo.health)
		or (player.bot == 1)
			continue
		end

		-- Estimate roughly where the player will be when firing
		local estimationval = 0
		if (mo.health < mo.info.spawnhealth)
			-- The first hit does not use prediction, to keep the reference in tact
			estimationval = ATK_EstimationVal(mo, player.mo)
		end

		local ball = P_SpawnPointMissile(mo,
			player.mo.x + (player.mo.momx * estimationval),
			player.mo.y + (player.mo.momy * estimationval),
			mo.z,
			MT_SOAES_BALL,
			mo.x, mo.y, mo.z
		)
		ATK_SetBallFlags(ball, mo.soaes.attackv2)

		S_StartSound(mo, sfx_s3k81)
	end
end

local function ATK_MultiShot(mo)
	mo.z = bosscenter.z + floatheight
	local newtarget = ATK_ClosestTarget(mo)
	if (newtarget and newtarget.valid)
		mo.target = newtarget
		mo.angle = R_PointToAngle2(mo.x, mo.y, mo.target.x, mo.target.y)
	end

	if (mo.soaes.attackdelay % 8)
		return
	end

	for i = 0,(mo.soaes.attackv2-1)
		local ang = FixedAngle((i * (360 / mo.soaes.attackv2))<<FRACBITS)

		-- Offset base angle off of leveltime to make it scarier!
		ang = $1 + FixedAngle((((leveltime / 8) % 8) * ((360 / mo.soaes.attackv2) / 8))<<FRACBITS)

		local ball = P_SpawnPointMissile(mo,
			mo.x + (24*cos(ang)),
			mo.y + (24*sin(ang)),
			mo.z,
			MT_SOAES_BALL,
			mo.x,
			mo.y,
			mo.z
		)
		ATK_SetBallFlags(ball, mo.soaes.attackv3)

		S_StartSound(mo, sfx_s3k81)
	end
end

local function ATK_SpreadShot(mo)
	mo.z = bosscenter.z + floatheight

	if (mo.soaes.attackdelay % 4)
		return
	end

	local amt = mo.soaes.attackv2 >> 1

	for i = -amt,amt
		local ang = FixedAngle((i * (90 / mo.soaes.attackv2))<<FRACBITS)

		local ball = P_SpawnPointMissile(mo,
			mo.x + cos(mo.angle + ang),
			mo.y + sin(mo.angle + ang),
			mo.z,
			MT_SOAES_BALL,
			mo.x, mo.y, mo.z
		)
		ATK_SetBallFlags(ball, mo.soaes.attackv3)

		S_StartSound(mo, sfx_s3k81)
	end
end

local function ATK_BallDrop(mo)
	local ghost = P_SpawnGhostMobj(mo)
	ghost.fuse = 4

	if (mo.soaes.attackdelay == 1)
		mo.momx = 0
		mo.momy = 0
		mo.momz = 0
		P_MoveOrigin(mo, bosscenter.x, bosscenter.y, bosscenter.z + floatheight)

		for layer = 1,mo.soaes.attackv1
			local amt = layer*8
			for i = 0,amt
				local ang = FixedAngle((i * (360 / amt))<<FRACBITS)

				local ball = P_SpawnPointMissile(mo,
					mo.x + (24*cos(ang)), mo.y + (24*sin(ang)), mo.z,
					MT_SOAES_BALL,
					mo.x, mo.y, mo.z
				)

				if (ball and ball.valid)
					ATK_SetBallFlags(ball, 0)
					ball.cusval = 1 -- disable afterimages
					ball.momx = ($1 * layer) / 5
					ball.momy = ($1 * layer) / 5
					ball.momz = (5<<FRACBITS) * layer
					ball.flags = $1 & ~MF_NOGRAVITY
				end

				S_StartSound(mo, sfx_s3k81)
			end
		end
	elseif (mo.soaes.attackdelay == TICRATE)
		mo.momx = 0
		mo.momy = 0
		P_MoveOrigin(mo, bosscenter.x, bosscenter.y, bosscenter.z + (1024<<FRACBITS))
		mo.momz = -(((1024 - (floatheight>>FRACBITS)) / TICRATE) << FRACBITS)
	elseif (mo.soaes.attackdelay == 2*TICRATE)
		local spd = R_PointToDist2(mo.x, mo.y, bosscenter.x, bosscenter.y) / (TICRATE)
		mo.angle = R_PointToAngle2(mo.x, mo.y, bosscenter.x, bosscenter.y)
		mo.momx = FixedMul(spd, cos(mo.angle))
		mo.momy = FixedMul(spd, sin(mo.angle))
		mo.momz = ((1024 - (floatheight>>FRACBITS)) / TICRATE) << FRACBITS
	end
end

local function ATK_HomingShot(mo)
	mo.z = bosscenter.z + floatheight
	local newtarget = ATK_ClosestTarget(mo)
	if (newtarget and newtarget.valid)
		mo.target = newtarget
		mo.angle = R_PointToAngle2(mo.x, mo.y, mo.target.x, mo.target.y)
	end

	for i = 0,(mo.soaes.attackv1-1)
		local ang = FixedAngle((i * (360 / mo.soaes.attackv1))<<FRACBITS)

		local ball = P_SpawnPointMissile(mo,
			mo.x + (24*cos(ang)), mo.y + (24*sin(ang)), mo.z,
			MT_SOAES_BALL,
			mo.x, mo.y, mo.z
		)
		ATK_SetBallFlags(ball, 2)

		S_StartSound(mo, sfx_s3k81)
	end
end

local function ATK_RainCloud(mo)
	mo.z = bosscenter.z + floatheight
	--SOAES_Hover(mo)

	local newtarget = ATK_ClosestTarget(mo)
	if (newtarget and newtarget.valid)
		mo.target = newtarget
		mo.angle = R_PointToAngle2(mo.x, mo.y, mo.target.x, mo.target.y)
	end

	local dist = 256<<FRACBITS

	local ang = (leveltime % 8) * ANGLE_45
	if ((leveltime / 8) & 1)
		dist = $1<<1
	end

	local ball = P_SpawnPointMissile(mo,
		mo.x + FixedMul(dist, cos(ang)),
		mo.y + FixedMul(dist, sin(ang)),
		bosscenter.z,
		MT_SOAES_BALL,
		mo.x + FixedMul(dist, cos(ang)),
		mo.y + FixedMul(dist, sin(ang)),
		bosscenter.z + (2048<<FRACBITS)
	)

	if (ball and ball.valid)
		ATK_SetBallFlags(ball, BALL_MULTI)
		ball.angle = ang + ((leveltime / 8) % 8) * ANGLE_45
		ball.momx = 0
		ball.momy = 0
		ball.momz = -64*FRACUNIT
		ball.flags = $1 & ~MF_NOGRAVITY
	end

	S_StartSound(mo, sfx_s3k81)
end

local function ATK_Finale(mo)
	local timeinto = finalatktime - mo.soaes.attackdelay

	if (timeinto >= TICRATE)
		P_SetOrigin(mo, bosscenter.x, bosscenter.y, bosscenter.z + floatheight)
		--SOAES_Hover(mo)

		local newtarget = ATK_ClosestTarget(mo)
		if (newtarget and newtarget.valid)
			mo.target = newtarget
			mo.angle = R_PointToAngle2(mo.x, mo.y, mo.target.x, mo.target.y)
		end
	end

	if (timeinto == 5*TICRATE)
		ATK_SpawnFinaleHexagons(mo, false)
	end

	local freq = TICRATE

	if (timeinto >= 15*TICRATE)
	and (timeinto <= 25*TICRATE)
	and (mo.soaes.attackdelay % freq == 0)
		local roundnum = ((timeinto / freq) - 15)
		local num = 11+(7*(roundnum/2))
		local angoffset = (360<<FRACBITS) / num

		for i = 0,(num-1)
			local ang = i * angoffset
			if (roundnum & 1)
				ang = $1 + (roundnum * (angoffset>>1))
			end
			ang = FixedAngle(ang)

			local ball = P_SpawnPointMissile(mo,
				mo.x + (24*cos(ang)),
				mo.y + (24*sin(ang)),
				mo.z,
				MT_SOAES_BALL,
				mo.x,
				mo.y,
				mo.z
			)

			if (ball and ball.valid)
				ATK_SetBallFlags(ball, BALL_NORMAL)
				ball.momx = $1 / 4
				ball.momy = $1 / 4
			end

			S_StartSound(mo, sfx_s3k81)
		end
	end

	if (timeinto > 25*TICRATE)
		mo.flags2 = $1 & ~MF2_FRET
	end
end

local function SOAES_ChargeUp(mo, deathfx)
	local scale = FRACUNIT
	if (deathfx != nil)
		scale = deathfx>>1
	else
		deathfx = 4<<FRACBITS
	end

	local dist = FixedMul(deathfx, telefxdist)
	local hang = P_RandomRange(0,7) * ANGLE_45
	local vang = P_RandomRange(0,7) * ANGLE_45

	local orb = P_SpawnMobj(
		mo.x + (dist * cos(hang+ANGLE_180)) + (dist * sin(vang+ANGLE_180)),
		mo.y + (dist * sin(hang+ANGLE_180)) + (dist * sin(vang+ANGLE_180)),
		mo.z + (mo.height>>1) + (dist * cos(vang+ANGLE_180)),
		MT_SOAES_PARTICLE
	)

	orb.scale = scale

	orb.momx = ((dist/telefxtime) * cos(hang)) + ((dist/telefxtime) * sin(vang))
	orb.momy = ((dist/telefxtime) * sin(hang)) + ((dist/telefxtime) * sin(vang))
	orb.momz = (dist/telefxtime) * cos(vang)

	orb.fuse = telefxtime

	orb.state = S_SOAES_CHARGEORB1 + P_RandomKey(3)
end

local function ATK_Handler(mo)
	if (mo.soaes == nil)
		return
	end

	if (mo.soaes.chargeup > 0)
		mo.soaes.chargeup = $1-1

		mo.z = bosscenter.z + floatheight + sin(FixedAngle((leveltime % 720)<<FRACBITS))

		if (mo.target and mo.target.valid)
			local estimationval = ATK_EstimationVal(mo, mo.target)
			mo.angle = R_PointToAngle2(mo.x, mo.y,
				mo.target.x + (mo.target.momx * estimationval),
				mo.target.y + (mo.target.momy * estimationval)
			)
			--P_InstaThrust(mo, mo.angle + ANGLE_180, mo.info.speed>>1)
		else
			mo.target = ATK_RandomTarget()
		end

		if (mo.soaes.chargeup > telefxtime)
			SOAES_ChargeUp(mo)
		end

		return
	end

	if (mo.flags2 & MF2_FRET) and (mo.soaes.attackid != ATK_FINALE)
		return
	end

	if (mo.soaes.attackdelay > 0)
		mo.soaes.attackdelay = $1-1
	end

	if (mo.soaes.attackdelay <= 0)
		ATK_SetUpNext(mo)
		return
	end

	-- nice big ol' elseif
	if (mo.soaes.attackid == ATK_WAIT)
		ATK_Wait(mo)
	elseif (mo.soaes.attackid == ATK_TELEPORT)
		ATK_Teleport(mo)
	elseif (mo.soaes.attackid == ATK_PHSHOT)
		ATK_PurpleHeartShot(mo)
	elseif (mo.soaes.attackid == ATK_MULTISHOT)
		ATK_MultiShot(mo)
	elseif (mo.soaes.attackid == ATK_SPREADSHOT)
		ATK_SpreadShot(mo)
	elseif (mo.soaes.attackid == ATK_BALLDROP)
		ATK_BallDrop(mo)
	elseif (mo.soaes.attackid == ATK_HOMINGSHOT)
		ATK_HomingShot(mo)
	elseif (mo.soaes.attackid == ATK_RAINCLOUD)
		ATK_RainCloud(mo)
	elseif (mo.soaes.attackid == ATK_FINALE)
		ATK_Finale(mo)
	end
end

local function SOAES_IntroHandler(mo)
	local endtime = 5*TICRATE
	intro = $1+1
    mo.z = mo.floorz + (156<<FRACBITS)

	if (intro > endtime)
		-- Shatter effect
		P_LinedefExecute(510) -- Remove crystal FOFs
		S_StartSound(nil, sfx_s3k80)
		for i = 1,32
			local ang = P_RandomRange(0,7) * ANGLE_45
			local shard = P_SpawnMobj(
				mo.x + (32 * cos(ang)),
				mo.y + (32 * sin(ang)),
				mo.z + (P_RandomRange(-48,48) * FRACUNIT),
				MT_SOAES_PARTICLE
			)
			P_Thrust(shard, ang, P_RandomRange(4,12) * FRACUNIT)
			shard.momz = P_RandomRange(0,16) * FRACUNIT
			shard.flags = $1 & ~MF_NOGRAVITY
			shard.state = S_SOAES_CRYSTAL
		end

		-- Set normal properties
		mo.flags = MF_BOSS|MF_NOGRAVITY|MF_SPECIAL|MF_SHOOTABLE
		mo.state = S_SOAES
		sugoi.SetBoss(mo, "Shadow of Anime Eyes Sonic")

		-- Teleport away
		ATK_SetUpNext(mo, ATK_TELEPORT)
	elseif (intro > endtime-TICRATE)
		mo.flags2 = $1 & ~MF2_DONTDRAW
		if (mo.tracer and mo.tracer.valid)
			P_RemoveMobj(mo.tracer)
		end
	else
		if (mo.tracer and mo.tracer.valid)
			P_MoveOrigin(mo.tracer, mo.x, mo.y, mo.z + (mo.height>>1))
		else
			mo.tracer = P_SpawnMobj(mo.x, mo.y, mo.z + (mo.height>>1), MT_SOAES_PARTICLE)
		end

		mo.tracer.scale = (intro<<10)
		if (intro & 2)
			mo.tracer.state = S_SOAES_CHARGEORB5
		else
			mo.tracer.state = S_SOAES_CHARGEORB4
		end

		if (intro > endtime-(3*TICRATE/2))
			mo.flags2 = $1 ^^ MF2_DONTDRAW
			if (mo.tracer and mo.tracer.valid)
				mo.tracer.flags2 = $1 ^^ MF2_DONTDRAW
			end
		else
			if (intro % 15 == 0)
				S_StartSound(mo, sfx_s3kc6s)
			end
			SOAES_ChargeUp(mo)
		end
	end
end

local function SOAES_DeathHandler(mo)
	stoppedclock = true
	death = $1+1
	if (deathflash > 0)
		deathflash = $1-1
	end

	local movestart = 2*TICRATE
	local finish = 15*TICRATE

	if (death >= finish-(2*TICRATE))
		for player in players.iterate
			player.exiting = TICRATE
		end
	end

	if (death >= finish)
		sugoi.ExitLevel()
		return
	end

	-- Screen flashes
	if (death == 1 or death == TICRATE+1)
		deathflash = 10
		S_StartSound(nil, sfx_storm1) -- from bother
	elseif (death == movestart)
		-- Start ambient sound
		S_StartSound(mo, sfx_s3kd5l)
	elseif (death > movestart)
		local t = death-movestart
		mo.momz = FRACUNIT/2

		if (mo.target and mo.target.valid)
			mo.angle = R_PointToAngle2(mo.x, mo.y, mo.target.x, mo.target.y)
		end

		if not (mo.tracer and mo.tracer.valid)
			mo.tracer = P_SpawnMobj(mo.x, mo.y, mo.z + (mo.height>>1), MT_SOAES_PARTICLE)
		end

		mo.tracer.z = mo.z + (mo.height>>1)
		mo.tracer.scale = (t<<10)
		if (t & 2)
			mo.tracer.state = S_SOAES_CHARGEORB5
		else
			mo.tracer.state = S_SOAES_CHARGEORB4
		end

		SOAES_ChargeUp(mo, t<<12)

		if (P_RandomChance(((death - movestart) << FRACBITS) / finish))
			local rad = death>>1
			local explode = P_SpawnMobj(
				mo.x + (P_RandomRange(-rad,rad) * FRACUNIT),
				mo.y + (P_RandomRange(-rad,rad) * FRACUNIT),
				mo.z + (P_RandomRange(-rad,rad) * FRACUNIT),
				MT_SOAES_PARTICLE
			)
			explode.state = S_SOAES_BALLEXPLODE
		end
	end
end

addHook("BossThinker", function(mo)
	if (mo.soaes == nil)
		for mt in mapthings.iterate
			if (mt.type == mobjinfo[MT_BOSS3WAYPOINT].doomednum)
			and (mt.mobj and mt.mobj.valid)
				bosscenter = mt.mobj
				break
			end
		end

		if not (bosscenter and bosscenter.valid)
			print("NO BOSS CENTER!")
			return
		end

		mo.soaes = {}

		-- Set default properties
		mo.soaes.attackpos = 1
		mo.soaes.attackid = ATK_WAIT
		mo.soaes.attackv1 = 0
		mo.soaes.attackv2 = 0
		mo.soaes.attackv3 = 0
		mo.soaes.attackdelay = TICRATE

		mo.soaes.chargeup = 0
		--mo.soaes.hoverval = 0
		--mo.soaes.z = mo.z
		mo.soaes.pinch = false

		-- Setup first attack in the table
		ATK_SetUpNext(mo)

		-- Go to intro
		mo.state = S_SOAES_INTRO
		mo.flags2 = $1|MF2_DONTDRAW
		return
	end

	if (mo.state == S_SOAES_INTRO)
		if (intro > 0)
			SOAES_IntroHandler(mo)
		end
		return
	elseif (mo.state == S_SOAES_DEATH)
		SOAES_DeathHandler(mo)
		return
	end

	ATK_Handler(mo)
end, MT_SOAES)

local function SOAES_SetMusic()
	if (themusic == nil)
		S_FadeOutStopMusic(3*MUSICRATE)
	else
		S_ChangeMusic(themusic, true)
	end
end

addHook("MobjDamage", function(mo, inf, src)
	if (src and src.valid)
		mo.angle = R_PointToAngle2(mo.x, mo.y, src.x, src.y)
	end

	mo.soaes.chargeup = 0
	mo.momx = 0
	mo.momy = 0
	mo.momz = 0

	if not (mo.soaes.pinch) and ((mo.health-1) <= mo.info.damage)
		--themusic = "soaes2"
		--SOAES_SetMusic()
		mo.soaes.attackpos = 1
		mo.soaes.pinch = true
	end
end, MT_SOAES)

addHook("MobjDeath", function(mo, inf, src)
	if (src and src.valid)
		mo.angle = R_PointToAngle2(mo.x, mo.y, src.x, src.y)
		mo.target = src
	end

	themusic = nil
	SOAES_SetMusic()
	ATK_WipeBullets()
end, MT_SOAES)

addHook("MobjSpawn", function(mo)
	mo.shadowscale = 4*FRACUNIT;
end, MT_SOAES_BALL)

addHook("MobjThinker", function(mo)
	if not (mo.health)
		return
	end

	if (mo.flags & MF_NOCLIP) and (bosscenter and bosscenter.valid)
		-- HACK: Remove noclip flag from finale attack projectiles when they get inside of the arena
		local dist = R_PointToDist2(mo.x, mo.y, bosscenter.x, bosscenter.y)
		if (dist <= (1536*FRACUNIT))
			mo.flags = $1 & ~MF_NOCLIP
		end
	end

	if (mo.fuse and mo.fuse < TICRATE)
		mo.flags2 = $1 ^^ MF2_DONTDRAW
	end

	if (mo.extravalue1 == BALL_HOMING)
		-- Homing / stop bullets
		if (mo.extravalue2)
			mo.extravalue2 = $1-1
		else
			if (mo.cvmem)
				mo.cvmem = 0
				mo.state = S_SOAES_BALL
				S_StartSound(mo, sfx_s3k89)

				local newtarget = ATK_ClosestTarget(mo)
				if (newtarget and newtarget.valid)
					local hang = R_PointToAngle2(mo.x, mo.y, newtarget.x, newtarget.y)
					local speed = (3*mo.info.speed)>>1
					mo.momx = FixedMul(speed, cos(hang))
					mo.momy = FixedMul(speed, sin(hang))
				end
			else
				mo.cvmem = 1
				mo.state = S_SOAES_BALL3
				S_StartSound(mo, sfx_s3k89)

				mo.momx = 0
				mo.momy = 0
				mo.momz = 0
			end

			mo.extravalue2 = TICRATE/2
		end
	end

	--[[
	-- disabled for lag
	if not (mo.cusval)
		local ghost = P_SpawnGhostMobj(mo)
		ghost.fuse = 4
	end
	--]]
end, MT_SOAES_BALL)

local function SOAES_SaveTheBalls(ball, pmo)
	-- z collision
	if not ((ball.z + ball.height >= pmo.z)
	and (ball.z <= pmo.z+pmo.height))
		return
	end

	-- is not a player
	if not (pmo and pmo.valid)
	or not (pmo.player and pmo.player.valid)
		return
	end

	-- Don't destroy the projectiles while flashing, to make it less cheesable
	if (pmo.player.powers[pw_flashing])
		return false
	end

	-- Don't bounce off your face, to make it less unpredictable
	if (ball.extravalue1 == BALL_BOUNCE)
		P_DamageMobj(pmo, ball, ball.target, 1)
		return false
	end
end

addHook("MobjCollide", SOAES_SaveTheBalls, MT_SOAES_BALL)
addHook("MobjMoveCollide", SOAES_SaveTheBalls, MT_SOAES_BALL)

addHook("MobjThinker", function(mo)
	if (mo.state != S_SOAES_BALLWARNING1 and mo.state != S_SOAES_BALLWARNING2)
		local ghost = P_SpawnGhostMobj(mo)
		ghost.fuse = 4
	end

	if (mo.state == S_SOAES_CRYSTAL and mo.z < mo.floorz)
		P_RemoveMobj(mo)
	end
end, MT_SOAES_PARTICLE)

addHook("LinedefExecute", function(line, mo, sec)
	if (intro <= 0)
		-- Start the boss fight by setting the intro timer
		intro = 1
		themusic = "soaes" -- "soaes1"
		SOAES_SetMusic()
	end
end, "SOAES")

addHook("LinedefExecute", function(line, mo, sec)
	-- Change to correct music
	SOAES_SetMusic()
	if (mo.player and mo.player.valid)
		mo.player.powers[pw_flashing] = 2*TICRATE
	end
end, "SOAESENT")

local function reset(map)
	intro = 0
	death = 0
	themusic = mapheaderinfo[map].musname
	bosscenter = nil
	deathflash = 0 -- don't sync
end

addHook("MapChange", reset)
--addHook("MapLoad", reset)

addHook("NetVars", function(net)
	intro = net(intro)
	death = net(death)
	themusic = net(themusic)
	bosscenter = net(bosscenter)
end)

hud.add(function(v)
	local white = v.cachePatch("WHIPTE")
	local black = v.cachePatch("BLAPCK")

	local screenscale = max(v.width()/v.dupx(), v.height()/v.dupy())

	if (deathflash > 0)
		v.drawScaled(-1, -1, (screenscale*FRACUNIT)+2, white, V_SNAPTOTOP|V_SNAPTOLEFT|((NUMTRANSMAPS-deathflash) << FF_TRANSSHIFT))
	end

	local time = death-(2*TICRATE)
	if (time < 0) return end

	local tint = max(0, NUMTRANSMAPS-(time/18)+10)
	if (tint >= NUMTRANSMAPS) return end

	v.drawScaled(-1, -1, (screenscale*FRACUNIT)+2, black, V_SNAPTOTOP|V_SNAPTOLEFT|(tint<<FF_TRANSSHIFT))
end)
