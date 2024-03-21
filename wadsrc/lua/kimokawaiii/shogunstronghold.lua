freeslot(
	"MT_FIREWORK",
	"S_FIREWORK",

	"MT_FIREWORK_MISSLE",
	"S_FIREWORK_MISSILE",

	"MT_FIREWORK_SFX",
	"S_FIREWORK_SPARK",
	"S_FIREWORK_SPARKFADE",
	"S_FIREWORK_SPARKFADE2",
	"S_FIREWORK_SPARKFADE3",
	"S_FIREWORK_SPARKFADE4",
	"S_FIREWORK_SPARKFADE5",
	"S_FIREWORK_SPARKFADE6",
	"S_FIREWORK_SPARKFADE7",
	"S_FIREWORK_SPARKFADE8",
	"S_FIREWORK_SPARKFADE9",

	"MT_FIREWORK_BLAST",
	"S_FIREWORK_BLAST",
	"S_FIREWORK_BLAST2",
	"S_FIREWORK_BLAST3",
	"S_FIREWORK_BLAST4",

	"SPR_FWRK"
)

mobjinfo[MT_FIREWORK] = {
	--$Name Shogun Stronghold Fireworks
	--$Sprite FWRKA0
	--$Category SUGOI Enemies
	doomednum = 2386,
	spawnstate = S_FIREWORK,
	deathstate = S_XPLD1,
	deathsound = sfx_pop,
	radius = 12*FRACUNIT,
	height = 48*FRACUNIT,
	spawnhealth = 1,
	reactiontime = 2*TICRATE,
	dispoffset = 1,
	flags = MF_ENEMY|MF_SPECIAL|MF_SHOOTABLE
}
states[S_FIREWORK] = {SPR_FWRK, A, -1, nil, 0, 0, S_NULL}

mobjinfo[MT_FIREWORK_MISSLE] = {
	spawnstate = S_FIREWORK_MISSILE,
	deathstate = S_NULL,
	seesound = sfx_s3k70,
	deathsound = sfx_s3k77,
	radius = 4*FRACUNIT,
	height = 4*FRACUNIT,
	damage = 512*FRACUNIT,
	speed = 32*FRACUNIT,
	reactiontime = 6,
	flags = MF_NOCLIPTHING|MF_MISSILE|MF_NOGRAVITY
}
states[S_FIREWORK_MISSILE] = {SPR_FWRK, B|FF_FULLBRIGHT|FF_ANIMATE, -1, nil, 1, 7, S_NULL}

mobjinfo[MT_FIREWORK_SFX] = {
	spawnstate = S_FIREWORK_SPARK,
	deathstate = S_FIREWORK_SPARKFADE,
	radius = 8*FRACUNIT,
	height = 8*FRACUNIT,
	flags = MF_NOCLIP|MF_NOCLIPTHING|MF_NOCLIPHEIGHT|MF_NOGRAVITY
}
states[S_FIREWORK_SPARK] = {SPR_FWRK, D|FF_FULLBRIGHT|FF_ANIMATE, -1, nil, 3, 7, S_FIREWORK_SPARK}
states[S_FIREWORK_SPARKFADE] = {SPR_FWRK, D|FF_ADD|FF_FULLBRIGHT|FF_TRANS10, 7, nil, 0, 0, S_FIREWORK_SPARKFADE2}
states[S_FIREWORK_SPARKFADE2] = {SPR_FWRK, E|FF_ADD|FF_FULLBRIGHT|FF_TRANS20, 7, nil, 0, 0, S_FIREWORK_SPARKFADE3}
states[S_FIREWORK_SPARKFADE3] = {SPR_FWRK, F|FF_ADD|FF_FULLBRIGHT|FF_TRANS30, 7, nil, 0, 0, S_FIREWORK_SPARKFADE4}
states[S_FIREWORK_SPARKFADE4] = {SPR_FWRK, G|FF_ADD|FF_FULLBRIGHT|FF_TRANS40, 7, nil, 0, 0, S_FIREWORK_SPARKFADE5}
states[S_FIREWORK_SPARKFADE5] = {SPR_FWRK, D|FF_ADD|FF_FULLBRIGHT|FF_TRANS50, 7, nil, 0, 0, S_FIREWORK_SPARKFADE6}
states[S_FIREWORK_SPARKFADE6] = {SPR_FWRK, E|FF_ADD|FF_FULLBRIGHT|FF_TRANS60, 7, nil, 0, 0, S_FIREWORK_SPARKFADE7}
states[S_FIREWORK_SPARKFADE7] = {SPR_FWRK, F|FF_ADD|FF_FULLBRIGHT|FF_TRANS70, 7, nil, 0, 0, S_FIREWORK_SPARKFADE8}
states[S_FIREWORK_SPARKFADE8] = {SPR_FWRK, G|FF_ADD|FF_FULLBRIGHT|FF_TRANS80, 7, nil, 0, 0, S_FIREWORK_SPARKFADE9}
states[S_FIREWORK_SPARKFADE9] = {SPR_FWRK, D|FF_ADD|FF_FULLBRIGHT|FF_TRANS90, 7, nil, 0, 0, S_NULL}

mobjinfo[MT_FIREWORK_BLAST] = {
	spawnstate = S_FIREWORK_BLAST,
	radius = 28*FRACUNIT,
	height = 56*FRACUNIT,
	flags = MF_PAIN|MF_NOCLIPHEIGHT|MF_NOGRAVITY|MF_RUNSPAWNFUNC
}
states[S_FIREWORK_BLAST] = {SPR_FWRK, H|FF_ADD|FF_FULLBRIGHT|FF_TRANS10, 2, nil, 0, 0, S_FIREWORK_BLAST2}
states[S_FIREWORK_BLAST2] = {SPR_FWRK, H|FF_ADD|FF_FULLBRIGHT|FF_TRANS20, 8, nil, 0, 0, S_FIREWORK_BLAST3}
states[S_FIREWORK_BLAST3] = {SPR_FWRK, H|FF_ADD|FF_FULLBRIGHT|FF_TRANS50, 6, A_SetObjectFlags, MF_PAIN, 1, S_FIREWORK_BLAST4}
states[S_FIREWORK_BLAST4] = {SPR_FWRK, H|FF_ADD|FF_FULLBRIGHT|FF_TRANS80, 4, nil, 0, 0, S_NULL}

local function P_CoolerBossTargetPlayer(actor, type) -- type: 0/nil for first sighted, 1 for closest, 2 for most rings, 3 for random
	local lastdist
	local lastrings
	local targetlist = {}

	for player in players.iterate
		if (player.pflags & PF_INVIS or player.bot or player.spectator) continue end
		if not (player.mo and player.mo.valid) continue end
		if (player.mo.health <= 0) continue end
		if not (P_CheckSight(actor, player.mo)) continue end

		if (type == 1)
			local dist = P_AproxDistance(actor.x - player.mo.x, actor.y - player.mo.y)
			if not (lastdist) or (dist < lastdist)
				lastdist = dist+1
				actor.target = player.mo
			end
			continue
		elseif (type == 2)
			local rings = player.mo.health-1
			if not (lastrings) or (rings < lastrings)
				lastrings = rings+1
				actor.target = player.mo
			end
			continue
		elseif (type == 3)
			table.insert(targetlist, player.mo)
			for k,v in ipairs(targetlist)
				if not (v and v.valid and v.player and v.player.valid)
					table.remove(targetlist, k)
				end
			end
			local key = (P_RandomRange(1, #targetlist))
			actor.target = targetlist[key]
			continue
		end

		actor.target = player.mo
		return true
	end

	return false
end

local function fireworkThinker(mo)
	if not (mo.health) return end

	local flip = 1
	if (mo.eflags & MFE_VERTICALFLIP)
		flip = -1
	end

	if (mo.reactiontime > 0)
		mo.reactiontime = $1-1
		return
	end

	P_CoolerBossTargetPlayer(mo, 1)

	local motop = mo.z + mo.height
	if (flip < 0)
		motop = mo.z
	end
	motop = $+(16*FRACUNIT*flip)
	local newreactiontime = mo.info.reactiontime

	if (mo.spawnpoint and mo.spawnpoint.options & MTF_OBJECTSPECIAL) -- Firing is off of a timer
		local potentialtics = mo.spawnpoint.angle
		if (potentialtics > 0) -- Make sure this is a valid amount of tics before setting it
			newreactiontime = potentialtics
		end
	else -- Firing is off of proximity
		if not (mo.target and mo.target.valid) return end
		local targtop = mo.target.z + mo.target.height
		if (mo.target.eflags & MFE_VERTICALFLIP)
			targtop = mo.target.z
		end
		if (mo.target.eflags & MFE_VERTICALFLIP)
			if (targtop >= motop)
				return
			end
		else
			if (targtop <= motop)
				return
			end
		end
		if (P_AproxDistance(mo.x - mo.target.x, mo.y - mo.target.y) > mo.spawnpoint.angle*FRACUNIT)
			return
		end
	end

	local missile = P_SpawnMobj(mo.x, mo.y, motop, MT_FIREWORK_MISSLE)
	missile.target = mo
	missile.flags2 = $ & (MF2_EXPLOSION)
	if (flip < 0) missile.flags2 = $|MF2_OBJECTFLIP end
	missile.fuse = TICRATE
	missile.destscale = mo.destscale
	P_SetScale(missile, missile.destscale)
	S_StartSoundAtVolume(missile, missile.info.seesound, 255)

	if (mo.spawnpoint and mo.spawnpoint.options & MTF_AMBUSH and (mo.target and mo.target.valid)) -- Aim for target
		local tarz = mo.target.z + (mo.target.height/2)
		local aimhang = R_PointToAngle2(mo.x, mo.y, mo.target.x + mo.target.momx, mo.target.y + mo.target.momy)
		local aimvang = R_PointToAngle2(0, mo.z, FixedHypot((mo.target.x + mo.target.momx) - mo.x, (mo.target.y + mo.target.momy) - mo.y), tarz)
		missile.momx = FixedMul(FixedMul(missile.info.speed, cos(aimhang)), cos(aimvang))
		missile.momy = FixedMul(FixedMul(missile.info.speed, sin(aimhang)), cos(aimvang))
		missile.momz = FixedMul(missile.info.speed, sin(aimvang))
		if (mo.target.player) S_StartSound(mo.target, missile.info.seesound, mo.target.player) end
	else -- Aim upwards
		missile.momz = flip * missile.info.speed
	end

	mo.reactiontime = newreactiontime
end

local function fireworkPretty(mo)
	if (mo.extravalue2 == 0)
		local fwrange = 20
		mo.extravalue1 = P_RandomRange(-fwrange, fwrange)
		mo.extravalue2 = 1
	end

	mo.color = SKINCOLOR_RUBY + ((leveltime + mo.extravalue1) % (FIRSTSUPERCOLOR - SKINCOLOR_RUBY))
	local ghost = P_SpawnGhostMobj(mo)
	ghost.tics = 2
end

local function fireworkMissileThink(mo)
	if not (mo.health) return end
	fireworkPretty(mo)

	if ((abs(mo.momx) < mo.info.speed/4 and abs(mo.momy) < mo.info.speed/4 and abs(mo.momz) < mo.info.speed/4)
	or (mo.z+mo.momz <= mo.floorz or mo.z+mo.momz >= mo.ceilingz)) -- Hit wall/ceiling, so DIE
		P_KillMobj(mo)
		return
	end

	if (mo.reactiontime)
		mo.reactiontime = $-1
	else
		for player in players.iterate
			if (player.mo and player.mo.valid and player.mo.health)
				local dist = P_AproxDistance(P_AproxDistance(player.mo.x - mo.x, player.mo.y - mo.y), player.mo.z - mo.z);
				local active = FixedMul(mo.info.damage/4, mo.scale);

				if (dist <= active)
					P_KillMobj(mo)
					return
				end
			end
		end
	end
end

local function fireworkMissileDie(mo)
	local flip = 1
	if (mo.eflags & MFE_VERTICALFLIP)
		flip = -1
	end

	local blast = P_SpawnMobj(mo.x, mo.y, mo.z, MT_FIREWORK_BLAST)
	blast.flags2 = $ & (MF2_EXPLOSION)
	if (flip < 0) blast.flags2 = $|MF2_OBJECTFLIP end
	blast.destscale = FixedMul(mo.info.damage/64, mo.destscale) -- Get the sprite to the size of the explosion
	P_SetScale(blast, blast.destscale)
	blast.z = $-(32*blast.scale)

	S_StartSoundAtVolume(blast, mo.info.deathsound, 255)

	for i = 1,64
		local spark = P_SpawnMobj(mo.x, mo.y, mo.z, MT_FIREWORK_SFX)
		if (flip < 0) spark.flags2 = $|MF2_OBJECTFLIP end
		spark.fuse = 15
		spark.destscale = mo.destscale
		P_SetScale(spark, spark.destscale)

		local hang = FixedAngle(P_RandomKey(360)*FRACUNIT)
		local vang = FixedAngle(P_RandomRange(90,-45)*FRACUNIT)
		spark.momx = FixedMul(FixedMul(mo.info.damage/spark.fuse, cos(hang)), cos(vang)) / 2
		spark.momy = FixedMul(FixedMul(mo.info.damage/spark.fuse, sin(hang)), cos(vang)) / 2
		spark.momz = (FixedMul(mo.info.damage/spark.fuse, sin(vang)) / 2) - (flip * FRACUNIT)
	end
end

local function justDie(mo)
	if (mo.health)
		P_KillMobj(mo)
	end
	return true
end

local function fireworkSparksHalt(mo)
	if (mo.threshold) return false end
	mo.momx = $/32
	mo.momy = $/32
	mo.momz = -(P_MobjFlip(mo) * 2*FRACUNIT)
	mo.fuse = 3*TICRATE
	mo.threshold = 1 -- Set to know you've already done this
	return true
end

addHook("MobjThinker", fireworkThinker, MT_FIREWORK)

addHook("MobjThinker", fireworkMissileThink, MT_FIREWORK_MISSLE)
addHook("MobjFuse", justDie, MT_FIREWORK_MISSLE)
addHook("MobjDeath", fireworkMissileDie, MT_FIREWORK_MISSLE)

addHook("MobjThinker", fireworkPretty, MT_FIREWORK_SFX)
addHook("MobjFuse", justDie, MT_FIREWORK_SFX)
addHook("MobjFuse", fireworkSparksHalt, MT_FIREWORK_SFX)

freeslot(
	"MT_JLANTERN",
	"S_JLANTERN",
	"S_JLANTERN_LIGHTB",
	"S_JLANTERN_LIGHTB2",
	"S_JLANTERN_LIGHTF",
	"S_JLANTERN_LIGHTF2",
	"SPR_LTRN"
)

mobjinfo[MT_JLANTERN] = {
	--$Name Shogun Stronghold Lantern
	--$Sprite LTRNA0
	--$Category SUGOI Decoration
	doomednum = 2387,
	spawnstate = S_JLANTERN,
	radius = 16*FRACUNIT,
	height = 44*FRACUNIT,
	flags = MF_NOCLIP|MF_NOCLIPTHING|MF_NOGRAVITY
}
states[S_JLANTERN] = {SPR_LTRN, A|FF_FULLBRIGHT|FF_ANIMATE, -1, nil, 1, 3, S_JLANTERN}

states[S_JLANTERN_LIGHTB] = {SPR_LTRN, C|FF_ADD|FF_FULLBRIGHT|FF_TRANS60, 1, nil, 1, 20, S_JLANTERN_LIGHTB2}
states[S_JLANTERN_LIGHTB2] = {SPR_LTRN, C|FF_ADD|FF_FULLBRIGHT|FF_TRANS40, 1, nil, 1, 20, S_JLANTERN_LIGHTB}

states[S_JLANTERN_LIGHTF] = {SPR_LTRN, D|FF_ADD|FF_FULLBRIGHT|FF_TRANS40, 1, nil, 0, 20, S_JLANTERN_LIGHTF2}
states[S_JLANTERN_LIGHTF2] = {SPR_LTRN, D|FF_ADD|FF_FULLBRIGHT|FF_TRANS60, 1, nil, 0, 20, S_JLANTERN_LIGHTF}

local function lanternOverlays(mo)
	local back = P_SpawnMobj(mo.x, mo.y, mo.z, MT_OVERLAY)
	back.target = mo
	back.state = S_JLANTERN_LIGHTB
	local front = P_SpawnMobj(mo.x, mo.y, mo.z, MT_OVERLAY)
	front.target = mo
	front.state = S_JLANTERN_LIGHTF
end

addHook("MobjSpawn", lanternOverlays, MT_JLANTERN)

freeslot(
	"MT_MSSCRUFFIEPAINTDOG",
	"S_MSSCRUFFIEPAINTDOG",
	"MT_ILOVEDOGS",
	"S_ILOVEDOGS",
	"MT_DOGENERGY",
	"S_DOGENERGY",
	"S_DOGENERGY2",
	"S_DOGENERGY3",
	"S_DOGENERGY4",
	"SPR_MSPD"
)

function A_ILoveDogs(mo)
	local particle = P_SpawnMobj(mo.x, mo.y, mo.z, MT_ILOVEDOGS)
	particle.target = mo
end

mobjinfo[MT_MSSCRUFFIEPAINTDOG] = {
	--$Name Ms. "Scruffie" Paintdog
	--$Sprite MSPDA0
	--$Category SUGOI NPCs
	doomednum = 2388,
	spawnstate = S_MSSCRUFFIEPAINTDOG,
	radius = 16*FRACUNIT,
	height = 48*FRACUNIT,
	flags = MF_SOLID|MF_RUNSPAWNFUNC
}
states[S_MSSCRUFFIEPAINTDOG] = {SPR_MSPD, A, -1, A_ILoveDogs, 0, 0, S_MSSCRUFFIEPAINTDOG}

mobjinfo[MT_ILOVEDOGS] = {
	spawnstate = S_ILOVEDOGS,
	radius = 8*FRACUNIT,
	height = 8*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOCLIPHEIGHT|MF_NOGRAVITY
}
states[S_ILOVEDOGS] = {SPR_MSPD, B|FF_ANIMATE, -1, nil, 1, 14, S_ILOVEDOGS}

mobjinfo[MT_DOGENERGY] = {
	spawnstate = S_DOGENERGY,
	radius = 8*FRACUNIT,
	height = 8*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOCLIPHEIGHT|MF_NOGRAVITY
}
states[S_DOGENERGY] = {SPR_MSPD, D|FF_FULLBRIGHT, 5, nil, 0, 0, S_DOGENERGY2}
states[S_DOGENERGY2] = {SPR_MSPD, F|FF_FULLBRIGHT|FF_TRANS10, 5, nil, 0, 0, S_DOGENERGY3}
states[S_DOGENERGY3] = {SPR_MSPD, E|FF_FULLBRIGHT|FF_TRANS20, 5, nil, 0, 0, S_DOGENERGY4}
states[S_DOGENERGY4] = {SPR_MSPD, F|FF_FULLBRIGHT|FF_TRANS30, 5, nil, 0, 0, S_NULL}

local function floatRotate(mo)
	A_Custom3DRotate(mo, 32, 20<<16)
	local amp = 8
	local speed = 4*TICRATE
	local pi = 22*FRACUNIT/7
	local sine = amp * sin((2*pi*speed) * leveltime)
	mo.z = mo.target.z + (mo.target.height/2) + sine
	--[[if (leveltime % 10 == 0) -- nah, no dog energy; the heart just looks plain cuter without anything extra on top of it
		P_SpawnMobj(mo.x + P_RandomRange(-12,12)*FRACUNIT, mo.y + P_RandomRange(-12,12)*FRACUNIT,
			mo.z + P_RandomRange(-8,8)*FRACUNIT, MT_DOGENERGY)
	end]]
end
addHook("MobjThinker", floatRotate, MT_ILOVEDOGS)
