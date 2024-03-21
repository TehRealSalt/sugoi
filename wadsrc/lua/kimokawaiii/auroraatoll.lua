-- Stuff from other objects or files that I don't want to include ALL of...

freeslot(
	"MT_REDBULLET",
	"S_REDBULLET1",
	"S_REDBULLET2",
	"SPR_RBUL"
)

mobjinfo[MT_REDBULLET] = {
	spawnstate = S_REDBULLET1,
	deathstate = S_XPLD1,
	speed = 20*FRACUNIT,
	radius = 4*FRACUNIT,
	height = 8*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_MISSILE|MF_NOGRAVITY
}
states[S_REDBULLET1] = {SPR_RBUL, A|FF_FULLBRIGHT, 1, nil, 0, 0, S_REDBULLET2}
states[S_REDBULLET2] = {SPR_RBUL, B|FF_FULLBRIGHT, 1, nil, 0, 0, S_REDBULLET1}

local function afterimages(mo)
	mo.shadowscale = FRACUNIT
	if (leveltime % 2 == 0)
		local ghost = P_SpawnGhostMobj(mo)
		ghost.fuse = 3
	end
end

addHook("MobjThinker", afterimages, MT_REDBULLET)

local function setBossNum()
	if not (mapheaderinfo[gamemap].aazboss) return end
	for thing in mapthings.iterate
		if not (thing.valid) continue end
		if not (thing.mobj and thing.mobj.valid) continue end
		if not (thing.mobj.flags & MF_BOSS) continue end
		thing.mobj.bossnum = (thing.angle / 360)
		if (thing.mobj.bossnum > 0)
			thing.mobj.bossdeactive = true
		else
			thing.mobj.bossdeactive = false
		end
	end
end

local function activateBosses(line, pmo, sec)
	if not (mapheaderinfo[gamemap].aazboss) return end
	local num = line.frontside.textureoffset/FRACUNIT
	for mo in mobjs.iterate()
		if not (mo and mo.valid) continue end
		if not (mo.flags & MF_BOSS) continue end

		if ((num == 0) or (mo.bossnum == num))
			if (mo.bossdeactive)
				mo.bossdeactive = false
				sugoi.SetBoss(mo, "Egg Gunner")
			end
		end
	end
end

local function bossDisable(mo)
	if not (mapheaderinfo[gamemap].aazboss) return end
	if not (mo and mo.valid) return end
	if (mo.flags & MF_BOSS) and (mo.bossdeactive)
		return true
	end
end

addHook("MapLoad", setBossNum)
--addHook("MobjThinker", bossDisable)
addHook("LinedefExecute", activateBosses, "BOSSACTI")

freeslot(
	"MT_EXPLODEY",
	"S_EXPLODEY",

	"MT_EXPLODEHURT",
	"S_EXPLODEHURT",
	"S_EXPLODEHURT2",
	"S_EXPLODEHURT3",
	"S_EXPLODEHURT4",

	"MT_EXPLODEDUST",
	"S_EXPLODEDUST",
	"S_EXPLODEDUST2",
	"S_EXPLODEDUST3",
	"S_EXPLODEDUST4"
)

mobjinfo[MT_EXPLODEY] = {
	spawnstate = S_INVISIBLE,
	deathsound = sfx_s3k4e,
	spawnhealth = 1000,
	radius = 48*FRACUNIT,
	height = 96*FRACUNIT,
	damage = 48*FRACUNIT,
	mass = TICRATE,
	speed = 8*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT
}

mobjinfo[MT_EXPLODEHURT] = {
	spawnstate = S_EXPLODEHURT,
	spawnhealth = 1000,
	radius = 12*FRACUNIT,
	height = 24*FRACUNIT,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_PAIN
}

states[S_EXPLODEHURT] = {SPR_BOM2, A|FF_FULLBRIGHT, 3, nil, 0, 0, S_EXPLODEHURT2}
states[S_EXPLODEHURT2] = {SPR_BOM2, B|FF_FULLBRIGHT, 3, nil, 0, 0, S_EXPLODEHURT3}
states[S_EXPLODEHURT3] = {SPR_BOM2, C|FF_FULLBRIGHT, 3, nil, 0, 0, S_EXPLODEHURT4}
states[S_EXPLODEHURT4] = {SPR_BOM2, D|FF_FULLBRIGHT, 3, nil, 0, 0, S_NULL}

mobjinfo[MT_EXPLODEDUST] = {
	spawnstate = S_EXPLODEDUST,
	spawnhealth = 1,
	radius = 12*FRACUNIT,
	height = 24*FRACUNIT,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT
}

states[S_EXPLODEDUST] = {SPR_BOM1, A|FF_FULLBRIGHT|FF_TRANS20, 3, nil, 0, 0, S_EXPLODEDUST2}
states[S_EXPLODEDUST2] = {SPR_BOM1, B|FF_FULLBRIGHT|FF_TRANS30, 3, nil, 0, 0, S_EXPLODEDUST3}
states[S_EXPLODEDUST3] = {SPR_BOM1, C|FF_FULLBRIGHT|FF_TRANS40, 3, nil, 0, 0, S_EXPLODEDUST4}
states[S_EXPLODEDUST4] = {SPR_BOM1, D|FF_FULLBRIGHT|FF_TRANS50, 3, nil, 0, 0, S_NULL}

local function massFuse(mo)
	mo.fuse = mo.info.mass
end

local function objectExplode(mo, inf, src)
	P_SpawnMobj(mo.x, mo.y, mo.z, MT_EXPLODEY)
end

local function explodey(mo)
	if not (mo.extrainfo)
		mo.extrainfo = {}
	end

	if not (mo.extravalue1)
		mo.extravalue1 = mo.info.mass/4 + 1
	end

	local size = 3*FRACUNIT/2
	local speed = FixedMul(size, mo.info.speed)

	if (mo.fuse % 3 == 0)
		local prev = mo.extravalue1
		mo.extravalue1 = $1/2
		local num = max(1, abs(prev - mo.extravalue1))

		for i = 1,num
			table.insert(mo.extrainfo, P_SpawnMobj(mo.x, mo.y, mo.z, MT_EXPLODEHURT))

			local dust = P_SpawnMobj(mo.x, mo.y, mo.z, MT_EXPLODEDUST)
			--dust.scale = size
			P_InstaThrust(dust, FixedAngle(P_RandomRange(0, 360)*FRACUNIT), speed)
			dust.momz = P_RandomRange(0, 3)*FRACUNIT

			S_StartSound(mo, sfx_s3kb4)
		end
	end

	if (#mo.extrainfo >= 1)
		for i = 1,#mo.extrainfo
			if not (mo.extrainfo[i] and mo.extrainfo[i].valid) continue end
			mo.extrainfo[i].scale = size

			if not (mo.extrainfo[i].extravalue1)
				mo.extrainfo[i].angle = FixedAngle(P_RandomRange(0, 360)*FRACUNIT)
				mo.extrainfo[i].momz = P_RandomRange(-2, 4)*FRACUNIT
				mo.extrainfo[i].extravalue1 = 1
			end

			P_Thrust(mo.extrainfo[i], mo.extrainfo[i].angle, speed/8)
			mo.extrainfo[i].angle = $1 + FixedAngle(speed)
		end
	end
end

addHook("MobjSpawn", massFuse, MT_EXPLODEY)
addHook("MobjThinker", explodey, MT_EXPLODEY)

-- == BOSS: Egg Gunner ==
freeslot(
	"MT_EGGGUNNER",
	"S_EGGGUNNER",
	"S_EGGGUNNER_HEATUP",
	"S_EGGGUNNER_FIRING",
	"S_EGGGUNNER_COOLDOWN",
	"S_EGGGUNNER_PAIN",
	"S_EGGGUNNER_DEATH",
	"S_EGGGUNNER_DEATH2",
	"S_EGGGUNNER_DEATH3",
	"S_EGGGUNNER_DEATH4",
	"S_EGGGUNNER_DEATH5",
	"S_EGGGUNNER_DEATH6",
	"S_EGGGUNNER_DEATH7",
	"S_EGGGUNNER_DEATH8",
	"S_EGGGUNNER_DEATH9",
	"S_EGGGUNNER_DEATH10",
	"S_EGGGUNNER_DEATH11",
	"S_EGGGUNNER_DEATH12",
	"S_EGGGUNNER_DEATH13",
	"S_EGGGUNNER_DEATH14",
	"S_EGGGUNNER_FLEE",
	"S_EGGGUNNER_FLEE2",
	"SPR_EGUN",
	"SPR_EGU2",

	"MT_EGGGUNNER_ROCKET",
	"S_EGGGUNNER_ROCKET",

	"MT_EGGGUNNER_CHAIN",
	"S_EGGGUNNER_CHAIN",

	"MT_EGGGUNNER_GUN",
	"S_EGGGUNNER_GUN"
)

mobjinfo[MT_EGGGUNNER] = {
	//$Sprite EGGMA1
	//$Name Egg Gunner
	//$Category SUGOI Bosses
	doomednum = 3760,
	spawnstate = S_EGGGUNNER,
	painstate = S_EGGGUNNER_PAIN,
	deathstate = S_EGGGUNNER_DEATH,
	xdeathstate = S_EGGGUNNER_FLEE,
	painsound = sfx_dmpain,
	deathsound = sfx_cybdth,
	spawnhealth = 8,
	damage = 3,
	speed = 3*FRACUNIT/4,
	radius = 38*FRACUNIT,
	height = 72*FRACUNIT,
	reactiontime = 4*TICRATE,
	flags = MF_SPECIAL|MF_SHOOTABLE|MF_BOSS|MF_NOGRAVITY --MF_BOUNCE
}

states[S_EGGGUNNER] = {SPR_EGUN, A, -1, nil, 0, 0, S_EGGGUNNER}
states[S_EGGGUNNER_HEATUP] = {SPR_EGUN, A, TICRATE, nil, 0, 0, S_EGGGUNNER_FIRING}
states[S_EGGGUNNER_FIRING] = {SPR_EGUN, A, 2*TICRATE, nil, 0, 0, S_EGGGUNNER_COOLDOWN}
states[S_EGGGUNNER_COOLDOWN] = {SPR_EGUN, A, TICRATE, nil, 0, 0, S_EGGGUNNER}
states[S_EGGGUNNER_PAIN] = {SPR_EGUN, A, 24, A_Pain, 0, 0, S_EGGGUNNER}
states[S_EGGGUNNER_DEATH] = {SPR_EGUN, A, 8, A_Fall, 0, 0, S_EGGGUNNER_DEATH2}
states[S_EGGGUNNER_DEATH2] = {SPR_EGUN, A, 8, A_BossScream, 0, 0, S_EGGGUNNER_DEATH3}
states[S_EGGGUNNER_DEATH3] = {SPR_EGUN, A, 8, A_BossScream, 0, 0, S_EGGGUNNER_DEATH4}
states[S_EGGGUNNER_DEATH4] = {SPR_EGUN, A, 8, A_BossScream, 0, 0, S_EGGGUNNER_DEATH5}
states[S_EGGGUNNER_DEATH5] = {SPR_EGUN, A, 8, A_BossScream, 0, 0, S_EGGGUNNER_DEATH6}
states[S_EGGGUNNER_DEATH6] = {SPR_EGUN, A, 8, A_BossScream, 0, 0, S_EGGGUNNER_DEATH7}
states[S_EGGGUNNER_DEATH7] = {SPR_EGUN, A, 8, A_BossScream, 0, 0, S_EGGGUNNER_DEATH8}
states[S_EGGGUNNER_DEATH8] = {SPR_EGUN, A, 8, A_BossScream, 0, 0, S_EGGGUNNER_DEATH9}
states[S_EGGGUNNER_DEATH9] = {SPR_EGUN, A, 8, A_BossScream, 0, 0, S_EGGGUNNER_DEATH10}
states[S_EGGGUNNER_DEATH10] = {SPR_EGUN, A, 8, A_BossScream, 0, 0, S_EGGGUNNER_DEATH11}
states[S_EGGGUNNER_DEATH11] = {SPR_EGUN, A, 8, A_BossScream, 0, 0, S_EGGGUNNER_DEATH12}
states[S_EGGGUNNER_DEATH12] = {SPR_EGUN, A, 8, A_BossScream, 0, 0, S_EGGGUNNER_DEATH13}
states[S_EGGGUNNER_DEATH13] = {SPR_EGUN, A, 8, A_BossScream, 0, 0, S_EGGGUNNER_DEATH14}
states[S_EGGGUNNER_DEATH14] = {SPR_EGUN, A, -1, A_BossDeath, 0, 0, S_NULL}
states[S_EGGGUNNER_FLEE] = {SPR_EGUN, A, 5, nil, 0, 0, S_EGGGUNNER_FLEE2}
states[S_EGGGUNNER_FLEE2] = {SPR_EGUN, A, 5, nil, 0, 0, S_EGGGUNNER_FLEE}

mobjinfo[MT_EGGGUNNER_ROCKET] = {
	spawnstate = S_EGGGUNNER_ROCKET,
	deathstate = S_NULL,
	deathsound = sfx_s3k4e,
	activesound = sfx_s3k5d,
	spawnhealth = 1000,
	radius = 12*FRACUNIT,
	height = 24*FRACUNIT,
	speed = 32*FRACUNIT,
	flags = MF_MISSILE|MF_NOGRAVITY
}
states[S_EGGGUNNER_ROCKET] = {SPR_RCKT, A, -1, nil, 0, 0, S_EGGGUNNER_ROCKET}

mobjinfo[MT_EGGGUNNER_CHAIN] = {
	spawnstate = S_EGGGUNNER_CHAIN,
	spawnhealth = 1000,
	radius = 12*FRACUNIT,
	height = 24*FRACUNIT,
	dispoffset = -1,
	flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT
}
states[S_EGGGUNNER_CHAIN] = {SPR_SMCH, A, -1, nil, 0, 0, S_EGGGUNNER_CHAIN}

mobjinfo[MT_EGGGUNNER_GUN] = {
	spawnstate = S_EGGGUNNER_GUN,
	spawnhealth = 1000,
	radius = 12*FRACUNIT,
	height = 24*FRACUNIT,
	flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT
}
states[S_EGGGUNNER_GUN] = {SPR_EGUN, C, -1, nil, 0, 0, S_EGGGUNNER_GUN}

local function aazBossThinker(mo)
	if not (mo and mo.valid) return end

	if not (mo.extrainfo)
		mo.extrainfo = {}
	end

	if not (mo.extrainfo[1])
		mo.extrainfo[1] = {}
	end

	if not (mo.extrainfo[1][1])
		mo.extrainfo[1][1] = mo.x
	end

	if not (mo.extrainfo[1][2])
		mo.extrainfo[1][2] = mo.y
	end

	if not (mo.extrainfo[2])
		mo.extrainfo[2] = {}
	end

	if not (mo.extrainfo[3])
		mo.extrainfo[3] = {}
	end

	mo.target = P_GetClosestAxis(mo)

	if not (mo.target and mo.target.valid) -- duuude, you forgot the nights axis!
		error("AAZ boss could not find an axis!")
		A_BossDeath(mo)
		return
	end

	--[[if (mo.v2boss)
		mo.sprite = SPR_EGU2
	end]]

	local rad = mo.target.radius

	local wantedspeed = mo.info.speed
	if not (wantedspeed)
		wantedspeed = FRACUNIT/2
	end

	local divhealth = max(1, mo.health)
	wantedspeed = $1 + ($1 * (mo.info.spawnhealth / max(1, mo.health + (mo.info.spawnhealth - mo.info.damage))))

	local fc = FixedMul(cos(mo.target.angle), rad)
	local fs = FixedMul(sin(mo.target.angle), rad)

	if (mo.health > 0)
		A_FaceTarget(mo)
	end

	if (mo.state == S_EGGGUNNER)
		mo.frame = 0

		if not (mo.reactiontime)
			for player in players.iterate
				if not (player and player.valid) continue end
				if not (player.mo and player.mo.valid) continue end
				if (player.bot) continue end
				if (P_AproxDistance(mo.target.x - player.mo.x, mo.target.y - player.mo.y) <= 5*rad/8)
					mo.state = S_EGGGUNNER_HEATUP
					break
				end
			end
		end
	elseif (mo.state == S_EGGGUNNER_HEATUP) or (mo.state == S_EGGGUNNER_FIRING) or (mo.state == S_EGGGUNNER_COOLDOWN)
		mo.frame = 0

		if (mo.extrainfo[3][1] and mo.extrainfo[3][1].valid)
		and (mo.extrainfo[3][2] and mo.extrainfo[3][2].valid)
			if (leveltime % 4 <= 1)
				mo.extrainfo[3][1].frame = 3
				mo.extrainfo[3][2].frame = 3
			else
				mo.extrainfo[3][1].frame = 2
				mo.extrainfo[3][2].frame = 2
			end
		end

		if (leveltime % 3 == 0)
			if (mo.state == S_EGGGUNNER_FIRING)
				if (mo.health <= mo.info.damage)
					if (leveltime % 6 == 0)
						local missile = P_SpawnPointMissile(mo,
							mo.x + (P_RandomRange((rad/8)/FRACUNIT, (7*rad/4)/FRACUNIT) * cos(mo.angle + FixedAngle(P_RandomRange(-20, 20)*FRACUNIT))),
							mo.y + (P_RandomRange((rad/8)/FRACUNIT, (7*rad/4)/FRACUNIT) * sin(mo.angle + FixedAngle(P_RandomRange(-20, 20)*FRACUNIT))),
							mo.target.floorz,
							MT_EGGGUNNER_ROCKET,
							mo.x,
							mo.y,
							mo.z + (mo.height/2)
						)

						if (missile and missile.valid)
							missile.scale = 3*FRACUNIT/2
						end

						mo.frame = 1

						S_StartSound(mo, sfx_s3k4d)
					end
				else
					mo.frame = 0

					for i = 1,2
						if not (mo.extrainfo[3][i] and mo.extrainfo[3][i].valid) continue end

						--for a = 1,4
							local missile = P_SpawnPointMissile(mo,
								mo.x + (P_RandomRange((rad/8)/FRACUNIT, (7*rad/4)/FRACUNIT) * cos(mo.angle + FixedAngle(P_RandomRange(-20, 20)*FRACUNIT))),
								mo.y + (P_RandomRange((rad/8)/FRACUNIT, (7*rad/4)/FRACUNIT) * sin(mo.angle + FixedAngle(P_RandomRange(-20, 20)*FRACUNIT))),
								mo.target.floorz,
								MT_REDBULLET,
								mo.extrainfo[3][i].x,
								mo.extrainfo[3][i].y,
								mo.extrainfo[3][i].z + (mo.extrainfo[3][i].height/2)
							)

							if (missile and missile.valid)
								missile.scale = 3*FRACUNIT/2
							end

							S_StartSound(mo, sfx_s3k4d)
						--end

						mo.extrainfo[3][i].frame = $1+2
					end
				end
			elseif (mo.state == S_EGGGUNNER_HEATUP)
				S_StartSound(mo, sfx_s3k42)
			end
		end

		mo.reactiontime = mo.info.reactiontime

		if (mo.health <= mo.info.damage*2)
			wantedspeed = $1/4 -- Don't like this speed, but it's the only one slow enough for fang to still shoot...
		else
			wantedspeed = 0
		end
	elseif (mo.state == S_EGGGUNNER_PAIN)
		mo.reactiontime = max($1 - (mo.info.reactiontime / 8), TICRATE)
		mo.extravalue1 = 0
		wantedspeed = 0
	end

	if (mo.reactiontime)
		mo.reactiontime = $1-1
	end

	if (mo.extravalue1 == 0)
		if (P_RandomChance(FRACUNIT/50))
			mo.extravalue1 = -1
		else
			mo.extravalue1 = 1
		end
	end

	if (wantedspeed != 0) and (mo.health > 0)
		P_TryMove(mo, mo.target.x + fc, mo.target.y + fs, true)
		mo.target.angle = $1 + FixedAngle(mo.extravalue1 * wantedspeed)
		fc = FixedMul(cos(mo.target.angle), rad)
		fs = FixedMul(sin(mo.target.angle), rad)
		mo.extrainfo[1][1] = mo.target.x + fc
		mo.extrainfo[1][2] = mo.target.y + fs
	else
		mo.extrainfo[1][1] = mo.x
		mo.extrainfo[1][2] = mo.y
	end

	if not ((mo.flags2 & MF2_BOSSDEAD) or (mo.flags2 & MF2_BOSSFLEE))
		local numsegs = max(1, abs(mo.ceilingz - (mo.z + mo.height)) / 24 / FRACUNIT)

		local loopnum = numsegs
		if (#mo.extrainfo[2] > numsegs)
			loopnum = #mo.extrainfo[2]
		end

		for i = 1,loopnum
			if (i > numsegs)
				if (mo.extrainfo[2][i] and mo.extrainfo[2][i].valid)
					P_RemoveMobj(mo.extrainfo[2][i])
				end
			else
				local xpos = mo.extrainfo[1][1] + (i*(mo.x - mo.extrainfo[1][1])/(numsegs+1))
				local ypos = mo.extrainfo[1][2] + (i*(mo.y - mo.extrainfo[1][2])/(numsegs+1))
				local zpos = mo.ceilingz - (i*(mo.ceilingz - (mo.z + mo.height))/(numsegs+1))

				if (mo.extrainfo[2][i] and mo.extrainfo[2][i].valid)
					P_MoveOrigin(mo.extrainfo[2][i], xpos, ypos, zpos)
				else
					mo.extrainfo[2][i] = P_SpawnMobj(xpos, ypos, zpos, MT_EGGGUNNER_CHAIN)
				end
			end
		end
	end

	local guns = max(2, #mo.extrainfo[3])
	for i = 1,guns
		if (i > 2)
			if (mo.extrainfo[3][i] and mo.extrainfo[3][i].valid)
				P_RemoveMobj(mo.extrainfo[3][i])
			end
			mo.extrainfo[3][i] = nil
			continue
		end

		if (mo.health <= mo.info.damage)
			if not (mo.extrainfo[3][i] and mo.extrainfo[3][i].valid) continue end

			if not (mo.extrainfo[3][i].extravalue1)
				P_InstaThrust(mo.extrainfo[3][i], FixedAngle(P_RandomRange(0,360)*FRACUNIT), P_RandomRange(4,16)*FRACUNIT)
				mo.extrainfo[3][i].momz = P_RandomRange(1,4)*FRACUNIT
				mo.extrainfo[3][i].fuse = TICRATE
				mo.extrainfo[3][i].flags = $1 & !MF_NOGRAVITY
				mo.extrainfo[3][i].extravalue1 = 1
				S_StartSound(mo.extrainfo[3][i], sfx_s3kb4)
			end

			if (leveltime % 2 == 0)
				mo.extrainfo[3][i].flags2 = $1|MF2_DONTDRAW
			else
				mo.extrainfo[3][i].flags2 = $1 & !MF2_DONTDRAW
			end

			if (leveltime % 8 == 0)
				A_BossScream(mo.extrainfo[3][i], 0, 0)
			end
		else
			local sign = 1
			if (i == 2)
				sign = -1
			end

			if (mo.extrainfo[3][i] and mo.extrainfo[3][i].valid)
				P_MoveOrigin(mo.extrainfo[3][i],
					mo.x + (64 * cos(mo.angle + ANGLE_90) * sign),
					mo.y + (64 * sin(mo.angle + ANGLE_90) * sign),
					mo.z + 64*FRACUNIT
				)
			else
				mo.extrainfo[3][i] = P_SpawnMobj(mo.x + (64 * cos(mo.angle + ANGLE_90) * sign),
					mo.y + (64 * sin(mo.angle + ANGLE_90) * sign),
					mo.z + 64*FRACUNIT,
					MT_EGGGUNNER_GUN
				)
			end

			mo.extrainfo[3][i].angle = R_PointToAngle2(mo.extrainfo[3][i].x, mo.extrainfo[3][i].y, mo.target.x, mo.target.y)
			mo.extrainfo[3][i].scale = 3*FRACUNIT/2
		end
	end

	if (mo.health <= 0)
		mo.extrainfo[1][1] = mo.x
		mo.extrainfo[1][2] = mo.y

		if ((mo.flags2 & MF2_BOSSDEAD) or (mo.flags2 & MF2_BOSSFLEE))
			if (#mo.extrainfo[2])
				for i = 1,#mo.extrainfo[2]
					if not (mo.extrainfo[2][i] and mo.extrainfo[2][i].valid) continue end

					if not (mo.extrainfo[2][i].extravalue1)
						P_InstaThrust(mo.extrainfo[2][i], FixedAngle(P_RandomRange(0,360)*FRACUNIT), P_RandomRange(1,4)*FRACUNIT)
						mo.extrainfo[2][i].momz = P_RandomRange(1,4)*FRACUNIT
						mo.extrainfo[2][i].fuse = TICRATE
						mo.extrainfo[2][i].flags = $1 & !MF_NOGRAVITY
						mo.extrainfo[2][i].extravalue1 = 1
					end

					if (leveltime % 2 == 0)
						mo.extrainfo[2][i].flags2 = $1|MF2_DONTDRAW
					else
						mo.extrainfo[2][i].flags2 = $1 & !MF2_DONTDRAW
					end
				end
			end

			if (mo.flags2 & MF2_BOSSFLEE)
				if not (mo.tracer and mo.tracer.valid)
					A_BossJetFume(mo, 0, 0)
				end
				if (mo.z < 768*FRACUNIT) -- REALLY BAD LAST MINUTE HACK, please stop going into the floor
					mo.momz = 0
					mo.z = $+(8*FRACUNIT)
				end
			end
		end
	end
end

addHook("BossThinker", aazBossThinker, MT_EGGGUNNER)
addHook("MobjRemoved", objectExplode, MT_EGGGUNNER_ROCKET)

addHook("MobjThinker", bossDisable, MT_EGGGUNNER) -- Let's not add this to ALL objects.
