-- LUA_BOBO

freeslot(
"MT_BOUNCYBOI",
"S_BOUNCYBOI_BOSS1",
"S_BOUNCYBOI_PAIN1",
"S_BOUNCYBOI_PAIN2",
"S_BOUNCYBOI_PAIN3",
"S_BOUNCYBOI_DEATH1",
"SPR_BOBO")

mobjinfo[MT_BOUNCYBOI] = {
	--$Name Bouncy Boi
	--$Sprite BOBOA0
	--$Category SUGOI Bosses
	doomednum = 2340,
	radius = 64*FRACUNIT,
	height = 64*FRACUNIT,
	spawnstate = S_BOUNCYBOI_BOSS1,
	spawnhealth = 12,
	painstate = S_BOUNCYBOI_PAIN1,
	painsound = sfx_dmpain,
	deathstate = S_BOUNCYBOI_DEATH1,
	deathsound = sfx_cybdth,
	flags = MF_BOSS|MF_SPECIAL|MF_SHOOTABLE
}

states[S_BOUNCYBOI_BOSS1] = {
	sprite = SPR_BOBO,
	frame = A|TR_TRANS30,
	tics = 1,
	nextstate = S_BOUNCYBOI_BOSS1
}
states[S_BOUNCYBOI_PAIN1] = {
	sprite = SPR_BOBO,
	frame = B|TR_TRANS30,
	tics = 0,
	nextstate = S_BOUNCYBOI_PAIN2,
	action = A_ForceStop,
	var1 = 0
}
states[S_BOUNCYBOI_PAIN2] = {
	sprite = SPR_BOBO,
	frame = B|TR_TRANS30,
	tics = 0,
	nextstate = S_BOUNCYBOI_PAIN3,
	action = A_Thrust,
	var1 = -8,
	var2 = 1
}
states[S_BOUNCYBOI_PAIN3] = {
	sprite = SPR_BOBO,
	frame = B|TR_TRANS30,
	tics = TICRATE,
	nextstate = S_BOUNCYBOI_BOSS1,
	action = A_Pain
}

states[S_BOUNCYBOI_DEATH1] = {
	sprite = SPR_BOBO,
	frame = B|TR_TRANS30,
	tics = 1,
	nextstate = S_BOUNCYBOI_DEATH1,
}
/* Init */

/* Shooting Function */
local function bobo_boss_shoot(mo)
	S_StartSound(mo,sfx_s3k39)
	for i = 0,11
		local angle = mo.angle + FixedAngle((i * 30)*FRACUNIT)
		local blob = P_SpawnMobj(mo.x,mo.y,mo.z+16,MT_TINYBLOB)
		blob.angle = angle
		blob.target = mo
	end
end

local function bobo_boss_bigly_shoot(mo)
	S_StartSound(mo,sfx_s3k39)
	for i = 0,23
		local angle = mo.angle + FixedAngle((i * 15)*FRACUNIT)
		local blob = P_SpawnMobj(mo.x,mo.y,mo.z+32,MT_BLOB)
		blob.momz = 8 * FRACUNIT
		blob.angle = angle
		blob.target = mo
	end
end

/* Main Thinker */
local function bobo_boss_handler(mo)
	/* Init */
	if not mo.hops
		mo.hops = 0
		mo.fling = true
		mo.booms = 0
		mo.blowing_up_started = false
		mo.pinch = false
		states[S_BOUNCYBOI_BOSS1].frame = A|TR_TRANS30
	end
	/* Normal Mode */
	if mo.state != S_BOUNCYBOI_PAIN1 and mo.state != S_BOUNCYBOI_PAIN2 and mo.state != S_BOUNCYBOI_PAIN3
		if mo.health > 6
			if P_IsObjectOnGround(mo)
				if mo.fling == true
					mo.fling = false
					mo.flags = MF_BOSS|MF_SPECIAL|MF_SHOOTABLE
				end
				A_FaceTarget(mo)
				if mo.hops < 5
					S_StartSound(mo,sfx_s3k87)
					if mo.hops == 0
						bobo_boss_bigly_shoot(mo)
					else
						bobo_boss_shoot(mo)
					end
					if mo.hops % 2 == 0
						A_BunnyHop(mo,4,4)
					else
						A_BunnyHop(mo,8,8)
					end
					mo.hops = mo.hops + 1
				else
					S_StartSound(mo,sfx_s3ka4)
					A_BunnyHop(mo,16,16)
					mo.hops = 0
					mo.flags = MF_BOSS|MF_SPECIAL|MF_SHOOTABLE|MF_PAIN
					mo.fling = true
				end
			elseif	mo.fling == true
				if mo.tics % 10
					A_GhostMe(mo)
				end
			end
		/* PINCH MODE */
		elseif mo.health <= 6 and mo.health > 0
			if mo.pinch == false
				mo.pinch = true
				states[S_BOUNCYBOI_BOSS1].frame = C|TR_TRANS30
			end
			if P_IsObjectOnGround(mo)
				if mo.fling == true
					mo.fling = false
					mo.flags = MF_BOSS|MF_SPECIAL|MF_SHOOTABLE
				end
				A_FaceTarget(mo)
				if mo.hops % 2
					bobo_boss_bigly_shoot(mo)
					A_BunnyHop(mo,12,0)
					mo.hops = mo.hops + 1
				else
					S_StartSound(mo,sfx_s3ka4)
					A_BunnyHop(mo,16,16)
					mo.flags = MF_BOSS|MF_SPECIAL|MF_SHOOTABLE|MF_PAIN
					mo.fling = true
					mo.hops = mo.hops + 1
				end
			elseif	mo.fling == true
				if mo.tics % 10
					A_GhostMe(mo)
				end
			end
		/* F */
		else
			if mo.blowing_up_started == false
				mo.blowing_up_started = true
			end
			if mo.tics % 10
				A_BossScream(mo,1)
				mo.booms = mo.booms + 1
			end
			if mo.booms == 30
				for player in players.iterate
					P_FlashPal(player, PAL_WHITE, 1)
				end
				S_StartSound(nil,sfx_s3k4e)
				local frown = P_SpawnMobj(mo.x,mo.y,mo.z+32,MT_SAD_BOBO)
				P_SetObjectMomZ(frown, 16*FRACUNIT, true)
				A_BossDeath(mo)
			end
		end
	end
end

addHook("MobjThinker", bobo_boss_handler, MT_BOUNCYBOI)