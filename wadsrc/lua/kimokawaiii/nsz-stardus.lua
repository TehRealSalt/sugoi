freeslot(
	"MT_STARDUS",
	"S_STARDUS_STND",
	"S_STARDUS_RUN",
	"MT_STARDUSBALL",
	"S_STARDUSBALL",
	"S_STARDUSBALL_EXPAND",
	"S_STARDUSBALL_CONTRACT",
	"SPR_UNI2"
)

--a_rotatespikeball but NOT SHIT
function A_RotateSpikeBall2(actor, var1, var2)
	local radius = FixedMul(12*actor.ballradius, actor.scale)

	actor.angle = $1 + FixedAngle(actor.ballradius)
	P_MoveOrigin(actor, actor.target.x + FixedMul(cos(actor.angle), radius),
		actor.target.y + FixedMul(sin(actor.angle), radius),
		actor.target.z + actor.target.height/2
	)
end

function A_GolaBall(actor, var1, var2)
	A_RotateSpikeBall2(actor, 0, 0)
	actor.extravalue1 = $1 - 1

	if (actor.extravalue1 <= 0)
		actor.reactiontime = 1
		actor.state = S_STARDUSBALL_EXPAND
	end
end

function A_GolaBallExpand(actor, var1, var2)
	A_RotateSpikeBall2(actor, 0, 0)
	actor.reactiontime = $1 - 1

	if (actor.reactiontime == 0) and (actor.ballradius < 20*FRACUNIT)
		actor.reactiontime = 1
		actor.ballradius = $1 + ((3*FRACUNIT)/16)
	end

	if (actor.ballradius >= 20*FRACUNIT)
		actor.reactiontime = 1
		actor.state = S_STARDUSBALL_CONTRACT
	end
end

function A_GolaBallContract(actor, var1, var2)
	A_RotateSpikeBall2(actor, 0, 0)
	actor.reactiontime = $1 - 1

	if (actor.reactiontime == 0) and (actor.ballradius > 2*FRACUNIT)
		actor.reactiontime = 1
		actor.ballradius = $1 - ((3*FRACUNIT)/16)
	end

	if (actor.ballradius <= 2*FRACUNIT)
		actor.reactiontime = 1
		actor.extravalue1 = 80
		actor.state = S_STARDUSBALL
	end
end

--Gola/Sol loosely based on sa1's version
mobjinfo[MT_STARDUS] = {
	--$Name Stardus Crusaders
	--$Sprite UNI2A0
	--$Category SUGOI Enemies
	doomednum = 2513,
	spawnhealth = 1,
	spawnstate = S_STARDUS_STND,
	seestate = S_STARDUS_RUN,
	deathstate = S_XPLD1,
	deathsound = sfx_pop,
	attacksound = sfx_s3kd8s,
	activesound = sfx_s3kaa,
	radius = 18*FRACUNIT,
	height = 36*FRACUNIT,
	speed = 2,
	reactiontime = 32,
	painchance = MT_STARDUSBALL,
	flags = MF_SPECIAL|MF_SHOOTABLE|MF_ENEMY|MF_NOGRAVITY
}

states[S_STARDUS_STND] = {SPR_UNI2, A|FF_FULLBRIGHT, 4, A_Look, 0, 0, S_STARDUS_STND}
states[S_STARDUS_RUN] = {SPR_UNI2, A|FF_FULLBRIGHT, 1, A_Chase, 0, 0, S_STARDUS_RUN}

mobjinfo[MT_STARDUSBALL] = {
	doomednum = -1,
	spawnhealth = 1,
	spawnstate = S_STARDUSBALL,
	deathstate = S_XPLD1,
	radius = 13*FRACUNIT,
	height = 20*FRACUNIT,
	speed = 6*FRACUNIT,
	reactiontime = 1,
	painchance = 20*FRACUNIT,
	mass = DMG_SPIKE,
	flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_PAIN
}

states[S_STARDUSBALL] = {SPR_UNI2, B|FF_FULLBRIGHT, 1, A_GolaBall, 0, 0, S_STARDUSBALL}
states[S_STARDUSBALL_EXPAND] = {SPR_UNI2, B|FF_FULLBRIGHT, 1, A_GolaBallExpand, 0, 0, S_STARDUSBALL_EXPAND}
states[S_STARDUSBALL_CONTRACT] = {SPR_UNI2, B|FF_FULLBRIGHT, 1, A_GolaBallContract, 0, 0, S_STARDUSBALL_CONTRACT}

--Make fireballs on spawn
addHook("MobjSpawn", function(mo)
	for i = 0,3
		local fire = P_SpawnMobj(mo.x, mo.y, mo.z+30*FRACUNIT, MT_STARDUSBALL)
		fire.target = mo
		fire.extravalue1 = 80
		fire.angle = (i * ANGLE_90)
	end
end, MT_STARDUS)

--Fireball radius shit
addHook("MobjSpawn", function(mo)
	mo.ballradius = 2*FRACUNIT
end, MT_STARDUSBALL)

addHook("MobjThinker", function(mo)
	if (mo.target and mo.target.valid)
		mo.z = mo.target.z+30*FRACUNIT
	end

	if (mo.target and mo.target.valid)
	and (mo.target.state == S_XPLD2)
		P_RemoveMobj(mo)
	end
end, MT_STARDUSBALL)
