/* BoBot the B.O.U.N.C.Y Bot */
freeslot(
"MT_BOUNCYBOT",
"S_BOUNCYBOT_STAND",
"S_BOUNCYBOT_LOOK",
"S_BOUNCYBOT_HOP",
"S_BOUNCYBOT_DEATH",
"SPR_BBOT",
"sfx_bbotse")

mobjinfo[MT_BOUNCYBOT] = {
	--$Name B.O.U.N.C.Y Bot
	--$Sprite BBOTA1
	--$Category SUGOI Enemies
	doomednum = 2339,
	radius = 24*FRACUNIT,
	height = 24*FRACUNIT,
	spawnstate = S_BOUNCYBOT_STAND,
	deathstate = S_BOUNCYBOT_DEATH,
	deathsound = sfx_bbotse,
	seestate = S_BOUNCYBOT_HOP,
	--sfx_s3k87
	seesound = sfx_bbotse,
	flags = MF_ENEMY|MF_SPECIAL|MF_SHOOTABLE
}

states[S_BOUNCYBOT_STAND] = {
	sprite = SPR_BBOT,
	frame = A,
	tics = 5,
	action = A_LOOK,
	nextstate = S_BOUNCYBOT_STAND
}
states[S_BOUNCYBOT_HOP] = {
	sprite = SPR_BBOT,
	frame = A,
	tics = 1,
	nextstate = S_BOUNCYBOT_HOP
}
states[S_BOUNCYBOT_LOOK] = {
	sprite = SPR_BBOT,
	frame = A,
	tics = 1,
	nextstate = S_BOUNCYBOT_LOOK
}
states[S_BOUNCYBOT_DEATH] = {
	sprite = SPR_BBOT,
	frame = A,
	tics = 1,
	nextstate = S_BOUNCYBOT_DEATH
}
local function bobot_handler(mo)
	/* Init */
	if not mo.hops
		mo.hops = 0
	end
	/* He's hopping.. MENANCINGLY */
	if mo.state == S_BOUNCYBOT_HOP
		A_FaceTarget(mo)
		if P_IsObjectOnGround(mo)
			if mo.hops == 4
				mo.hops = 0
			end
			if mo.hops == 0
				A_BunnyHop(mo,2,0)
			elseif mo.hops == 1
				A_BunnyHop(mo,6,0)
			else
				S_StartSound(mo,sfx_bbotse)
				A_BunnyHop(mo,8,8)
			end
			mo.hops = mo.hops + 1
		end
		if not (mo.target and mo.target.valid)
		or P_CheckSight(mo,mo.target) == false
			mo.state = S_BOUNCYBOT_LOOK
			mo.hops = 0
		end
	/* Searches for Players */
	elseif mo.state == S_BOUNCYBOT_LOOK
		if P_IsObjectOnGround(mo)
			S_StartSound(mo,sfx_bbotse)
			mo.angle = FixedAngle(P_RandomRange(0,359)*FRACUNIT)
			A_BunnyHop(mo,8,8)
			A_Look(mo)
		end
	/* F pt.2 */
	elseif mo.state == S_BOUNCYBOT_DEATH
		local frown = P_SpawnMobj(mo.x,mo.y,mo.z,MT_SAD_BOBOT)
		P_SetObjectMomZ(frown, 8*FRACUNIT, true)
		mo.state = S_XPLD1
	end
end

addHook("MobjThinker", bobot_handler, MT_BOUNCYBOT)

/* Sad BoBot */
freeslot(
"MT_SAD_BOBOT",
"S_SABT_LOOPA",
"S_SABT_LOOPB",
"S_SABT_LOOPC",
"S_SABT_LOOPD",
"SPR_SABT")

mobjinfo[MT_SAD_BOBOT] = {
	radius = 8*FRACUNIT,
	height = 8*FRACUNIT,
	deathsound = sfx_cybdth,
	spawnstate = S_SABT_LOOPA,
}

states[S_SABT_LOOPA] = {
	sprite = SPR_SABT,
	frame = A,
	tics = 1,
	nextstate = S_SABT_LOOPB
}
states[S_SABT_LOOPB] = {
	sprite = SPR_SABT,
	frame = B,
	tics = 1,
	nextstate = S_SABT_LOOPC
}
states[S_SABT_LOOPC] = {
	sprite = SPR_SABT,
	frame = C,
	tics = 1,
	nextstate = S_SABT_LOOPD
}
states[S_SABT_LOOPD] = {
	sprite = SPR_SABT,
	frame = D,
	tics = 1,
	nextstate = S_SABT_LOOPA
}

/* Spoofs MF_MISSILE because that hurts people and we don't want that :( */
local function bobot_frown_handler(mo)
	if not mo.spawn_noise
		S_StartSound(mo,sfx_dmpain)
		mo.spawn_noise = 1
	end
	if P_IsObjectOnGround(mo)
		A_Scream(mo)
		P_RemoveMobj(mo)
	end
end

addHook("MobjThinker", bobot_frown_handler, MT_SAD_BOBOT)