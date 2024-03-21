//Cyber Deton Hazards Script
// - Enemies + other painful interactables
//Note: This should be loaded before CD-BOSS.lua

freeslot(
"MT_SAUCERSPAWNER",
"MT_SAUCER",
"MT_SAUCERFLOORCHECKER",
"MT_SPIKEHELM",
"MT_SAUCERBOMB",
"S_SAUCE_SPAWN",
"S_SAUCE_LOOK",
"S_SAUCE_STARTCHASE",
"S_SAUCE_CHASE1",
"S_SAUCE_CHASE2",
"S_SAUCE_DASH",
"S_SAUCE_LAMENT",
"S_SH_ROTATE",
"S_SBOMB_PUFF",
"S_SBOMB_XPLD",
"SPR_YELB",
"SPR_SFOT",
"SPR_SBMB"
)

mobjinfo[MT_SAUCERSPAWNER] = {
	doomednum = -1,
	spawnstate = S_SAUCE_SPAWN,
	spawnhealth = 1,
	radius = 24*FRACUNIT,
	height = 32*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY|MF_RUNSPAWNFUNC
}
mobjinfo[MT_SAUCER] = {
	doomednum = -1,
	spawnstate = S_SAUCE_LOOK,
	spawnhealth = 1,
	seestate = S_SAUCE_STARTCHASE,
	reactiontime = 32,
	attacksound = sfx_s3k51,
	deathstate = S_XPLD1,
	deathsound = sfx_pop,
	radius = 24*FRACUNIT,
	height = 32*FRACUNIT,
	speed = 4,
	dispoffset = 0,
	mass = 100,
	flags = MF_ENEMY|MF_SPECIAL|MF_SHOOTABLE|MF_SLIDEME|MF_NOGRAVITY
}
mobjinfo[MT_SAUCERFLOORCHECKER] = {
	doomednum = -1,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	radius = 24*FRACUNIT,
	height = 32*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOCLIPTHING
}
mobjinfo[MT_SPIKEHELM] = {
	doomednum = -1,
	spawnstate = S_SH_ROTATE,
	spawnhealth = 1,
	radius = 24*FRACUNIT,
	height = 24*FRACUNIT,
	flags = MF_PAIN|MF_NOCLIP|MF_NOCLIPHEIGHT
}
mobjinfo[MT_SAUCERBOMB] = {
	doomednum = -1,
	spawnstate = S_SBOMB_PUFF,
	spawnhealth = 1,
	deathstate = S_FBOMB_EXPL1,
	radius = 24*FRACUNIT,
	height = 24*FRACUNIT,
	flags = MF_SPECIAL
}

//Self-explanatory
function A_SaucerSpawn(actor)
	if actor and actor.valid
		local sauce = P_SpawnMobj(actor.x, actor.y, actor.z, MT_SAUCER)
		local ang = 0
		for i = 1, 16
			local xp = sauce.x + FixedMul(cos(ang), 64*FRACUNIT)
			local yp = sauce.y + FixedMul(sin(ang), 64*FRACUNIT)
			local smoke = P_SpawnMobj(xp, yp, sauce.z - 8*FRACUNIT, MT_EXPLODE)
			smoke.frame = TR_TRANS50
			ang = $+ANGLE_22h
		end
	end
end

//Saucer Spawner State
states[S_SAUCE_SPAWN] = {SPR_MSCF, TR_TRANS30|FF_ANIMATE|A, 12, A_SaucerSpawn, 11, 2, S_NULL}


//Cause I dislike A_Look's setup
function A_LookOut(actor)
	local play_t = {}
	if actor and actor.valid
		if actor.target and actor.target.valid
			actor.state = actor.info.seestate
		else
			P_LookForPlayers(actor, 3072*FRACUNIT, true)
		end
	end
end

//Counter setup for random state duration
function A_SetCounter(actor, var1, var2)
	actor.counter = P_RandomRange(var1, var2)
	if not (actor.fc)
		local spike = P_SpawnMobj(actor.x, actor.y, actor.z, MT_SPIKEHELM)
		spike.vanishtimer = 45
		actor.fc = P_SpawnMobj(actor.x, actor.y, actor.z, MT_SAUCERFLOORCHECKER)
		spike.target, actor.fc.target = actor, actor
	end
end

//Custom Saucer Chase
function A_SaucerChase(actor, var1, var2)
	if actor.counter == nil then actor.counter = 0 end

	local mo = actor.target
	if mo and mo.valid
		actor.angle = R_PointToAngle2(actor.x, actor.y, mo.x, mo.y)
		local dist = R_PointToDist2(0, 0, R_PointToDist2(0, 0, mo.x - actor.x, mo.y - actor.y), mo.z - actor.z)
		local speed = (actor.info.speed*2)*FRACUNIT
		if dist < 1 then dist = 1 end
		actor.momx = FixedMul(FixedDiv(mo.x - actor.x, dist), speed)
		actor.momy = FixedMul(FixedDiv(mo.y - actor.y, dist), speed)
		if actor.z > actor.fc.z + 48*FRACUNIT
			actor.momz = FixedMul(FixedDiv(mo.z - actor.z, dist), speed)
		end
		if actor.flags & MF_NOCLIPTHING then actor.flags = $&~MF_NOCLIPTHING end

		actor.counter = $+1
		if actor.counter == var1 then actor.state, actor.counter = var2, 0 end
	else
		actor.state = actor.info.spawnstate
	end
end

//Saucer's Dash Attack
function A_SaucerDash(actor, var1, var2)
	if actor.counter == nil then actor.counter = 0 end

	local mo = actor.target
	P_InstaThrust(actor, actor.angle, (actor.info.speed*FRACUNIT)*4)
	actor.momz = FRACUNIT
	local ghost = P_SpawnGhostMobj(actor)
	ghost.fuse = 2
	ghost.frame = TR_TRANS70

	if actor.counter % 2 == 0
		S_StartSound(actor, sfx_s3k51)
		local bomb = P_SpawnMobj(actor.x + actor.momx, actor.y + actor.momy, actor.z - 8*FRACUNIT, MT_SAUCERBOMB)
		bomb.scale = 2*FRACUNIT
	end

	if not (actor.flags & MF_NOCLIPTHING) then actor.flags = $|MF_NOCLIPTHING end

	actor.counter = $+1
	if actor.counter == var1 then actor.state, actor.counter, actor.momz = var2, 0, 0 end
end

//Saucer States
states[S_SAUCE_LOOK] = {SPR_YELB, A, 5, A_LookOut, 0, 0, S_SAUCE_LOOK}
states[S_SAUCE_STARTCHASE] = {SPR_YELB, A, 1, A_SetCounter, 0, 5, S_SAUCE_CHASE1}

states[S_SAUCE_CHASE1] = {SPR_YELB, A, 1, A_SaucerChase, 80, S_SAUCE_CHASE2, S_SAUCE_CHASE1}
states[S_SAUCE_CHASE2] = {SPR_YELB, B, 1, A_SaucerChase, TICRATE, S_SAUCE_DASH, S_SAUCE_CHASE2}

states[S_SAUCE_DASH] = {SPR_YELB, C, 6, A_SaucerDash, 8, S_SAUCE_LAMENT, S_SAUCE_DASH}
states[S_SAUCE_LAMENT] = {SPR_YELB, D, 20, nil, 0, 0, S_SAUCE_STARTCHASE}

//Spike Helm State
states[S_SH_ROTATE] = {SPR_SFOT, A, -1, nil, 0, 0, S_NULL}

//Saucer Bomb States
states[S_SBOMB_PUFF] = {SPR_SBMB, FF_ANIMATE|A, 3*TICRATE, nil, 3, 5, S_SBOMB_XPLD}
states[S_SBOMB_XPLD] = {SPR_SBMB, A, -1, nil, 0, 0, S_NULL}


rawset(_G, "saucerlist", {}) -- For storing saucer mobj (to count them later on)
addHook("MapLoad", do
	saucerlist = {} -- Reset
end)

addHook("MobjSpawn", function(sauce) -- Add to table
	table.insert(saucerlist, sauce)
end, MT_SAUCER)

addHook("MobjDeath", function(sauce) -- Remove from table
	for k, v in ipairs(saucerlist)
		if v == sauce then table.remove(saucerlist, k) end
	end
end, MT_SAUCER)


//Saucer Self-Inflicted Damage Control
addHook("MobjDamage", function(sauce, bomb)
	if bomb.type == MT_SAUCERBOMB then return true end
end, MT_SAUCER)

//Saucer Floor Checker Thinker - keeps the saucer floating above ground (and atop FOFs)
addHook("MobjThinker", function(floorc)
	local sauce = floorc.target
	local dist = R_PointToDist2(floorc.x, floorc.y, sauce.x, sauce.y)

	//Saucer height manupulation
	if sauce.state == S_SAUCE_CHASE1 or sauce.state == S_SAUCE_CHASE2
		if sauce.z < floorc.z + 48*FRACUNIT then sauce.momz = $+FRACUNIT end
	end
	//Floor check positionings
	floorc.momx = sauce.x - floorc.x
	floorc.momy = sauce.x - floorc.y
	if sauce.state == sauce.info.deathstate then floorc.state = S_NULL end
end, MT_SAUCERFLOORCHECKER)

//Spike Helm Thinker
addHook("MobjThinker", function(spike)
	local sauce = spike.target
	if sauce and sauce.valid
		if sauce.health > 0
			//Rotation around saucer
			spike.momx = sauce.x - spike.x + FixedMul(cos(spike.angle), 96*FRACUNIT)
			spike.momy = sauce.y - spike.y + FixedMul(sin(spike.angle), 96*FRACUNIT)
			spike.angle = $+ANG2*2

			spike.momz = sauce.z - spike.z
		else
			spike.die = true
			spike.momz = 8*FRACUNIT
		end
	else -- Just in case
		spike.die = true
	end

	if spike.die
		if not (spike.flags & MF_NOCLIPTHING) then spike.flags = $|MF_NOCLIPTHING end
		spike.momx, spike.momy = 0, 0

		spike.momz = $-FRACUNIT
		if leveltime % 2 == 0 then spike.flags2 = $^^MF2_DONTDRAW end
		spike.vanishtimer = $-1
		if spike.vanishtimer == 0 then spike.state = S_NULL end
	end
end, MT_SPIKEHELM)

//Saucer Bomb Thinker
addHook("MobjThinker", function(sb)
	if sb.state == S_SBOMB_XPLD
		sb.scale = FRACUNIT
		P_RadiusAttack(sb, sb, 160*FRACUNIT)
		for player in players.iterate
			local mo = player.mo
			if (mo and mo.valid)
			and not (player.playerstate & PST_DEAD)
				local dist =  R_PointToDist2(mo.x, mo.y, sb.x, sb.y)
				if dist > 152*FRACUNIT continue end
				P_InstaThrust(mo, R_PointToAngle2(sb.x, sb.y, mo.x, mo.y), 18*FRACUNIT)
				mo.momz = 8*FRACUNIT
			end
		end
		S_StartSound(sb, sfx_s3k4e)
		P_KillMobj(sb, sb, sb, 1)
	end
end, MT_SAUCERBOMB)

//Saucer Bomb Interaction
addHook("TouchSpecial", function(sb, mo)
	if mo and mo.valid and sb and sb.valid
		if sb.state == S_SBOMB_PUFF and not (sb.touched)
			sb.state = S_SBOMB_XPLD
			sb.touched = true
		end
	end
	return true
end, MT_SAUCERBOMB)
