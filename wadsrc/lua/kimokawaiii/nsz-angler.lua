--fishy enemy, putters along back and forth while periodically emitting painful electricity; think flasher from s2
freeslot(
	"MT_ANGLERFISH",
	"S_ANGLER_MOVE1",
	"S_ANGLER_MOVE2",
	"S_ANGLER_MOVEREPEAT",
	"S_ANGLER_TURN1",
	"S_ANGLER_TURN2",
	"S_ANGLER_TURNREPEAT",
	"S_ANGLER_TURN3",
	"S_ANGLER_ATTACK_PREPARE1",
	"S_ANGLER_ATTACK_PREPARE2",
	"S_ANGLER_ATTACK1",
	"S_ANGLER_ATTACK2",
	"S_ANGLER_ATTACK3",
	"S_ANGLER_ATTACK4",
	"S_ANGLER_CALM",
	"SPR_ANGL"
)

mobjinfo[MT_ANGLERFISH] = {
	--$Name Bulbream
	--$Sprite ANGLA3A7
	--$Category SUGOI Enemies
	doomednum = 3146,
	spawnstate = S_ANGLER_MOVE1,
	deathstate = S_XPLD1,
	deathsound = sfx_pop,
	radius = 24*FRACUNIT,
	height = 24*FRACUNIT,
	mass = DMG_ELECTRIC,
	flags = MF_SPECIAL|MF_SHOOTABLE|MF_ENEMY|MF_NOGRAVITY|MF_RUNSPAWNFUNC
}

states[S_ANGLER_MOVE1] = {SPR_ANGL, A, 2, A_Thrust, 3, 1, S_ANGLER_MOVE2}
states[S_ANGLER_MOVE2] = {SPR_ANGL, A, 2, A_Thrust, 3, 1, S_ANGLER_MOVEREPEAT}
states[S_ANGLER_MOVEREPEAT] = {SPR_ANGL, A, 0, A_Repeat, 10, S_ANGLER_MOVE1, S_ANGLER_TURN1}

states[S_ANGLER_TURN1] = {SPR_ANGL, A, 2, nil, 0, 0, S_ANGLER_TURN2}
states[S_ANGLER_TURN2] = {SPR_ANGL, A, 2, nil, 0, 0, S_ANGLER_TURNREPEAT}
states[S_ANGLER_TURNREPEAT] = {SPR_ANGL, A, 0, A_Repeat, 4, S_ANGLER_TURN1, S_ANGLER_TURN3}

states[S_ANGLER_TURN3] = {SPR_ANGL, A, 2, nil, 0, 0, S_ANGLER_MOVE1}

states[S_ANGLER_ATTACK_PREPARE1] = {SPR_ANGL, A, 4, A_PlaySound, sfx_s3k5c, 1, S_ANGLER_ATTACK_PREPARE2}
states[S_ANGLER_ATTACK_PREPARE2] = {SPR_ANGL, A, 0, A_Repeat, 4, S_ANGLER_ATTACK_PREPARE1, S_ANGLER_ATTACK1}

states[S_ANGLER_ATTACK1] = {SPR_ANGL, B, 0, A_PlaySound, sfx_buzz1, 1, S_ANGLER_ATTACK2}
states[S_ANGLER_ATTACK2] = {SPR_ANGL, B|FF_FULLBRIGHT, 1, nil, 0, 0, S_ANGLER_ATTACK3}
states[S_ANGLER_ATTACK3] = {SPR_ANGL, C|FF_FULLBRIGHT, 1, nil, 0, 0, S_ANGLER_ATTACK4}
states[S_ANGLER_ATTACK4] = {SPR_ANGL, B, 0, A_Repeat, 10, S_ANGLER_ATTACK2, S_ANGLER_CALM}

states[S_ANGLER_CALM] = {SPR_ANGL, A, 18, A_PlaySound, sfx_s3k43, 1, S_ANGLER_MOVE1}

--anglerfish thinker
addHook("MobjThinker", function(mo)
	if (mo.movecount == 120) and (mo.state == S_ANGLER_MOVE1)
		mo.state = S_ANGLER_ATTACK_PREPARE1
	end

	--shes gonna zap you!
	if (mo.state == S_ANGLER_ATTACK_PREPARE1)
		mo.momx = 0
		mo.momy = 0
	end

	if (mo.state == S_ANGLER_ATTACK2) or (mo.state == S_ANGLER_ATTACK3)
		P_RadiusAttack(mo, mo, 100<<FRACBITS, DMG_ELECTRIC)
		mo.flags = $1|MF_PAIN
	end

	if (mo.state == S_ANGLER_CALM)
		mo.movecount = 0
		mo.flags = ($1 & ~MF_PAIN)
	end

	--A_AnglerfishTurn replacement, functionally almost identical
	if (mo.state == S_ANGLER_TURN1
	or mo.state == S_ANGLER_TURN2
	or mo.state == S_ANGLER_TURN3)
		A_ChangeAngleRelative(mo, 10, 10)
		P_InstaThrust(mo, mo.angle, 4*FRACUNIT)
	end

	if (mo.state == S_ANGLER_TURN3)
		mo.movecount = P_RandomRange(120, 121)
	end
end, MT_ANGLERFISH)
