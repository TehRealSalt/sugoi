-- Clawguy
-- Also rewritten partially by Sal, also due to a mysterious crash

freeslot(
	"MT_CLAWGUY",
	"S_CLAWGUY_IDLE",
	"S_CLAWGUY_AWARE",
	"S_CLAWGUY_HEADDOWN",

	"MT_CLAWGUYHEAD",
	"S_CLAWGUYHEAD_IDLE1",
	"S_CLAWGUYHEAD_IDLE2",
	"S_CLAWGUYHEAD_IDLE3",
	"S_CLAWGUYHEAD_IDLE4",
	"S_CLAWGUYHEAD_LOWER",
	"S_CLAWGUYHEAD_SHOOT1",
	"S_CLAWGUYHEAD_SHOOT2",
	"S_CLAWGUYHEAD_SHOOT3",
	"S_CLAWGUYHEAD_RAISE",

	"MT_CLAWGUY_CHAIN",
	"S_CLAWGUY_CHAIN",

	"SPR_CLGY"
)

function A_ClawguyCheck(actor, var1, var2)
	if not (actor.target and actor.target.valid)
		return
	end

	if (R_PointToDist2(actor.x, actor.y, actor.target.x, actor.target.y) <= 1000*FRACUNIT)
	and (actor.target.z > actor.z - 512*FRACUNIT)
		-- Within range, so tell the head to start doing things!
		actor.state = S_CLAWGUY_HEADDOWN

		if (actor.tracer and actor.tracer.valid) -- Can never be too safe!
			actor.tracer.state = S_CLAWGUYHEAD_LOWER
		end

		actor.momx = 0
		actor.momy = 0
	end
end

function A_ClawguyHeadAim(actor, var1, var2)
	S_StartSound(actor, sfx_s3k6f)
	if (actor.tracer and actor.tracer.valid)
	and (actor.tracer.target and actor.tracer.target.valid)
		actor.angle = R_PointToAngle2(actor.x, actor.y, actor.tracer.target.x, actor.tracer.target.y)
	end
end

function A_ClawguyHeadFire(actor, var1, var2)
	A_TrapShot(actor, MT_ROCKET, 0)
	A_PlaySound(actor, sfx_fire, 1)
end

mobjinfo[MT_CLAWGUY] = {
	--$Name Gunneck
	--$Sprite CLGYA0
	--$Category SUGOI Enemies
	doomednum = 3145,
	spawnhealth = 1000,
	spawnstate = S_CLAWGUY_IDLE,
	seestate = S_CLAWGUY_AWARE,
	deathstate = S_XPLD1,
	deathsound = sfx_pop,
	attacksound = sfx_s3kd8s,
	activesound = sfx_s3kaa,
	radius = 20*FRACUNIT,
	height = 14*FRACUNIT,
	speed = 8,
	reactiontime = 10,
	flags = MF_SPECIAL|MF_SHOOTABLE|MF_ENEMY|MF_PAIN|MF_NOGRAVITY|MF_SPAWNCEILING
}

states[S_CLAWGUY_IDLE] = {SPR_CLGY, A|FF_FULLBRIGHT, 4, A_Look, 1, 0, S_CLAWGUY_IDLE}
states[S_CLAWGUY_AWARE] = {SPR_CLGY, A|FF_FULLBRIGHT, 6, A_ClawguyCheck, 0, 0, S_CLAWGUY_AWARE}
states[S_CLAWGUY_HEADDOWN] = {SPR_CLGY, A|FF_FULLBRIGHT, -1, nil, 0, 0, S_CLAWGUY_AWARE}

mobjinfo[MT_CLAWGUYHEAD] = {
	doomednum = -1,
	spawnhealth = 1,
	spawnstate = S_CLAWGUYHEAD_IDLE1,
	deathstate = S_XPLD1,
	deathsound = sfx_pop,
	radius = 16*FRACUNIT,
	height = 24*FRACUNIT,
	speed = 0,
	reactiontime = 10,
	flags = MF_SPECIAL|MF_SHOOTABLE|MF_ENEMY|MF_NOGRAVITY
}

states[S_CLAWGUYHEAD_IDLE1] = {SPR_CLGY, C|FF_FULLBRIGHT, 4, nil, 0, 0, S_CLAWGUYHEAD_IDLE2}
states[S_CLAWGUYHEAD_IDLE2] = {SPR_CLGY, D|FF_FULLBRIGHT, 4, nil, 0, 0, S_CLAWGUYHEAD_IDLE3}
states[S_CLAWGUYHEAD_IDLE3] = {SPR_CLGY, E|FF_FULLBRIGHT, 4, nil, 0, 0, S_CLAWGUYHEAD_IDLE4}
states[S_CLAWGUYHEAD_IDLE4] = {SPR_CLGY, D|FF_FULLBRIGHT, 4, nil, 0, 0, S_CLAWGUYHEAD_IDLE1}

states[S_CLAWGUYHEAD_LOWER] = {SPR_CLGY, C|FF_FULLBRIGHT, 4, A_PlaySound, sfx_s3kd2s, 1, S_CLAWGUYHEAD_LOWER}

states[S_CLAWGUYHEAD_SHOOT1] = {SPR_CLGY, C|FF_FULLBRIGHT, 10, A_ClawguyHeadAim, 0, 0, S_CLAWGUYHEAD_SHOOT2}
states[S_CLAWGUYHEAD_SHOOT2] = {SPR_CLGY, C|FF_FULLBRIGHT, 2, A_ClawguyHeadFire, 0, 0, S_CLAWGUYHEAD_SHOOT3}
states[S_CLAWGUYHEAD_SHOOT3] = {SPR_CLGY, C|FF_FULLBRIGHT, 10, nil, 0, 0, S_CLAWGUYHEAD_RAISE}

states[S_CLAWGUYHEAD_RAISE] = {SPR_CLGY, C|FF_FULLBRIGHT, -1, nil, 0, 0, S_CLAWGUYHEAD_RAISE}

mobjinfo[MT_CLAWGUY_CHAIN] = {
	spawnstate = S_CLAWGUY_CHAIN,
	spawnhealth = 1000,
	flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY
}

states[S_CLAWGUY_CHAIN] = {SPR_CLGY, H|FF_FULLBRIGHT, -1, nil, 0, 0, S_CLAWGUY_CHAIN}

addHook("MobjThinker", function(mo)
	if not (mo.tracer and mo.tracer.valid)
		-- Ensure that you got your head
		mo.tracer = P_SpawnMobj(mo.x, mo.y, mo.z - 62*FRACUNIT, MT_CLAWGUYHEAD)
		mo.tracer.tracer = mo
	end
end, MT_CLAWGUY)

local numchains = 7

local function cleansegs(mo)
	if (mo.clawguysegs == nil)
		return
	end

	for i=1,numchains
		if (mo.clawguysegs[i] and mo.clawguysegs[i].valid)
			P_RemoveMobj(mo.clawguysegs[i])
		end
	end
	mo.clawguysegs = nil
end

addHook("MobjThinker", function(mo)
	mo.momx = 0
	mo.momy = 0

	if not (mo.tracer and mo.tracer.valid)
		-- Just remove it if tracer is invalid
		P_RemoveMobj(mo)
		return
	end

	if not (mo.health)
		-- Manually remove segments
		cleansegs(mo)

		-- Destroy ceiling piece along with the head
		if (mo.state == S_XPLD1)
			mo.tracer.state = mo.tracer.info.deathstate
			mo.tracer.flags = MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPTHING
		end

		-- Don't do anything else
		return
	else
		-- Handle segment chain
		if (mo.clawguysegs == nil)
			mo.clawguysegs = {}
		end

		for i=1,numchains
			-- Move to proper position
			local segx = mo.x + ((i * (mo.tracer.x - mo.x)) / (numchains+1))
			local segy = mo.y + ((i * (mo.tracer.y - mo.y)) / (numchains+1))
			local segz = (mo.z + 24*FRACUNIT) + ((i * ((mo.tracer.z - 48*FRACUNIT) - mo.z)) / (numchains+1))

			if (mo.clawguysegs[i] and mo.clawguysegs[i].valid)
				P_MoveOrigin(mo.clawguysegs[i], segx, segy, segz)
			else
				mo.clawguysegs[i] = P_SpawnMobj(segx, segy, segz, MT_CLAWGUY_CHAIN)
			end
		end
	end

	if (mo.state == S_CLAWGUYHEAD_LOWER)
		-- Grab the target from the tracer
		local realtarget
		if (mo.tracer.target and mo.tracer.target.valid)
			realtarget = mo.tracer.target
		end

		if not (realtarget and realtarget.valid)
			-- Lost your target, start rising back up again.
			mo.state = S_CLAWGUYHEAD_RAISE
		else
			-- Line up the shot
			mo.angle = R_PointToAngle2(mo.x, mo.y, realtarget.x, realtarget.y)

			if (mo.z - realtarget.z <= 40*FRACUNIT)
			or (mo.z <= mo.tracer.floorz)
				-- Fire once you're lined up (or too close to the ground)
				mo.momz = 0
				S_StartSound(mo, sfx_s3k91)
				mo.state = S_CLAWGUYHEAD_SHOOT1
				mo.angle = R_PointToAngle2(mo.x, mo.y, realtarget.x, realtarget.y)
			else
				-- Descend
				mo.momz = $1 - FRACUNIT
			end
		end
	elseif (mo.state == S_CLAWGUYHEAD_RAISE)
		-- Resting z position
		local restpos = mo.tracer.z - (62*FRACUNIT)
		if (mo.z >= restpos)
			-- Back to idle
			mo.momz = 0
			mo.z = restpos
			S_StartSound(mo, sfx_s3k76)
			mo.state = S_CLAWGUYHEAD_IDLE1
			mo.tracer.state = S_CLAWGUY_IDLE
		else
			-- Ascend
			mo.momz = $1 + FRACUNIT
		end
	end
end, MT_CLAWGUYHEAD)

-- Clean segs on removal, too
addHook("MobjRemoved", cleansegs, MT_CLAWGUYHEAD)
