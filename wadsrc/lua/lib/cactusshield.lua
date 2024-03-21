-- Cacti Shield Lua script

freeslot(
	"SPR_CCTV",
	"SPR_CSPK",
	"SPR_CCPK",

	"SPR_CCTO",
	"S_CACTIORB1",
	"S_CACTIORB2",
	"S_CACTIORB3",
	"S_CACTIORB4",
	"S_CACTIORB5",
	"S_CACTIORB6",
	"S_CACTIORB7",
	"S_CACTIORB8",
	"S_CACTIORB9",
	"S_CACTIORB10",

	"MT_CACTISPIKE",
	"S_CACTISPIKE",

	"S_CACTISHIELD_FRONT1",
	"S_CACTISHIELD_FRONT2",
	"S_CACTISHIELD_FRONT3",
	"S_CACTISHIELD_FRONT4",
	"S_CACTISHIELD_BACK1",
	"S_CACTISHIELD_BACK2",
	"S_CACTISHIELD_BACK3",
	"S_CACTISHIELD_BACK4",
	"S_CACTISHIELD_ORB1",
	"S_CACTISHIELD_ORB2",
	"S_CACTISHIELD_ORB3",
	"S_CACTISHIELD_ORB4",
	"S_CACTISHIELD_FRONT_B1",
	"S_CACTISHIELD_FRONT_B2",
	"S_CACTISHIELD_FRONT_B3",
	"S_CACTISHIELD_FRONT_B4",
	"S_CACTISHIELD_BACK_B1",
	"S_CACTISHIELD_BACK_B2",
	"S_CACTISHIELD_BACK_B3",
	"S_CACTISHIELD_BACK_B4",
	"S_CACTISHIELD_ORB_B1",
	"S_CACTISHIELD_ORB_B2",
	"S_CACTISHIELD_ORB_B3",
	"S_CACTISHIELD_ORB_B4",
	"S_CACTISHIELD_ORB_B5",
	"S_CACTISHIELD_ORB_B6",

	"MT_CACTI_BOX",
	"S_CACTI_BOX",

	"MT_CACTI_GOLDBOX",
	"S_CACTI_GOLDBOX",

	"MT_CACTI_ICON",
	"S_CACTI_ICON1",
	"S_CACTI_ICON2",

	"SPR_TVCC",

	"sfx_spkshi"
)


rawset(_G, "SH_CACTI", SH_PITY|SH_PROTECTSPIKE);

local function haveCacti(p)
	if ((p.powers[pw_shield] & SH_NOSTACK) == SH_CACTI)
		return true
	end

	return false
end

addHook("ShieldSpawn", function(p)
	if not (haveCacti(p))
		return
	end

	-- P_SpawnShieldOrb does not work with these, so we'll have to use a more hacky method.
	local cactis_orb = P_SpawnMobj(p.mo.x, p.mo.y, p.mo.z, MT_OVERLAY)
	cactis_orb.state = S_CACTIORB1
	cactis_orb.target = p.mo
	p.mo.cactis_orb = cactis_orb

	local cactis_front = P_SpawnMobj(p.mo.x, p.mo.y, p.mo.z, MT_OVERLAY)
	cactis_front.state = S_CACTISHIELD_FRONT1
	cactis_front.target = p.mo
	p.mo.cactis_front = cactis_front

	local cactis_back = P_SpawnMobj(p.mo.x, p.mo.y, p.mo.z, MT_OVERLAY)
	cactis_back.state = S_CACTISHIELD_BACK1
	cactis_back.target = p.mo
	p.mo.cactis_back = cactis_back

	--print("Shield orb spawned.")

	return true
end)

-- spike burst function to save us some time on instances where we'll need it

local function cactiSpikeBurst(mo)
	local h_angle = 0
	local v_angle = 0
	local dist = 32
	local frame = 0

	for i=1,26

		local s_x = mo.x+ dist*FixedMul(cos(h_angle), cos(v_angle))
		local s_y = mo.y+ dist*FixedMul(sin(h_angle), cos(v_angle))
		local s_z = (mo.z+mo.height/2)+ dist* sin(v_angle)

		local spike = P_SpawnMobj(s_x, s_y, s_z, MT_CACTISPIKE)
		spike.frame = frame
		spike.angle = h_angle
		spike.target = mo -- dont damage self rofl
		spike.fuse = TICRATE/3
		spike.momx = 32 * FixedMul(cos(h_angle), cos(v_angle))
		spike.momy = 32 * FixedMul(sin(h_angle), cos(v_angle))
		spike.momz = 32 * sin(v_angle)

		h_angle = $+ANGLE_45

		if i == 8
			v_angle = ANGLE_45
			frame = 1
		elseif i == 16
			v_angle = -ANGLE_45
			frame = 2
		elseif i == 24
			v_angle = ANGLE_90
			frame = 3
		elseif i == 25
			v_angle = -ANGLE_90
			frame = 4
		end
	end

	P_NukeEnemies(mo, mo, 256*FRACUNIT)
	S_StartSound(mo, sfx_spkdth)
end

-- main thinker for the shield and the player!

addHook("ShieldSpecial", function(p)
	if not (p.mo and p.mo.valid)
		return
	end

	if not (haveCacti(p))
		return
	end

	cactiSpikeBurst(p.mo)
	p.mo.cactishield_cooldown = TICRATE*3
	p.pflags = $1|PF_SHIELDABILITY
	return true
end)

addHook("ThinkFrame", do
	for p in players.iterate

		if p.mo and p.mo.valid
		local mo = p.mo

			if not (haveCacti(p))
				if (mo.cactis_orb and mo.cactis_orb.valid) P_RemoveMobj(mo.cactis_orb) end
				if (mo.cactis_front and mo.cactis_front.valid) P_RemoveMobj(mo.cactis_front) end
				if (mo.cactis_back and mo.cactis_back.valid) P_RemoveMobj(mo.cactis_back) end
				mo.cactishield_cooldown = 0
				continue
			end

			local shieldScale = FixedMul(mo.scale, p.shieldscale)
			P_SetScale(mo.cactis_front, shieldScale)
			P_SetScale(mo.cactis_back, shieldScale)
			P_SetScale(mo.cactis_orb, shieldScale)

			if p.powers[pw_invulnerability]
			or p.powers[pw_super]
				mo.cactis_front.flags2 = $|MF2_DONTDRAW
				mo.cactis_back.flags2 = $|MF2_DONTDRAW
				mo.cactis_orb.flags2 = $|MF2_DONTDRAW
			else
				mo.cactis_front.flags2 = $ & ~MF2_DONTDRAW
				mo.cactis_back.flags2 = $ & ~MF2_DONTDRAW
				mo.cactis_orb.flags2 = $ & ~MF2_DONTDRAW
			end

			if mo.cactishield_cooldown == (11 or 22 or 33)
				S_StartSound(mo, sfx_spkdth)
			end

			if mo.cactishield_cooldown
				mo.cactishield_cooldown = max(0,$-1)
				p.pflags = $1|PF_SHIELDABILITY

				if mo.cactis_front and mo.cactis_front.valid and mo.cactis_back and mo.cactis_back.valid
					if (mo.cactishield_cooldown > TICRATE
					or ((mo.cactishield_cooldown > 6 and mo.cactishield_cooldown < 11)
					or (mo.cactishield_cooldown > 17 and mo.cactishield_cooldown < 22)
					or (mo.cactishield_cooldown > 28 and mo.cactishield_cooldown < 33)))
					and mo.cactishield_cooldown > 2
						mo.cactis_front.flags2 = $|MF2_DONTDRAW
						mo.cactis_back.flags2 = $|MF2_DONTDRAW
					else
						if not p.powers[pw_invulnerability] and not p.powers[pw_super]
							mo.cactis_back.flags2 = $ & ~MF2_DONTDRAW
							mo.cactis_front.flags2 = $ & ~MF2_DONTDRAW
						end
					end
				end
			end
		end
	end
end)

addHook("MobjDamage", function(mo, inflictor)
	if mo and mo.valid
	and mo.player and mo.player.valid
	and haveCacti(mo.player)
	and not mo.cactishield_doingdamagehook
		mo.cactishield_doingdamagehook = true
		cactiSpikeBurst(mo)
		S_StartSound(mo, sfx_spkdth)
		mo.cactishield_doingdamagehook = nil
	end
end, MT_PLAYER)


states[S_CACTIORB1] = {SPR_CCTO, A|FF_TRANS20, 1, nil, 0, 0, S_CACTIORB2}
states[S_CACTIORB2] = {SPR_CCTO, B|FF_TRANS20, 1, nil, 0, 0, S_CACTIORB3}
states[S_CACTIORB3] = {SPR_CCTO, A|FF_TRANS20, 1, nil, 0, 0, S_CACTIORB4}
states[S_CACTIORB4] = {SPR_CCTO, C|FF_TRANS20, 1, nil, 0, 0, S_CACTIORB5}
states[S_CACTIORB5] = {SPR_CCTO, A|FF_TRANS20, 1, nil, 0, 0, S_CACTIORB6}
states[S_CACTIORB6] = {SPR_CCTO, D|FF_TRANS20, 1, nil, 0, 0, S_CACTIORB7}
states[S_CACTIORB7] = {SPR_CCTO, A|FF_TRANS20, 1, nil, 0, 0, S_CACTIORB8}
states[S_CACTIORB8] = {SPR_CCTO, E|FF_TRANS20, 1, nil, 0, 0, S_CACTIORB9}
states[S_CACTIORB9] = {SPR_CCTO, A|FF_TRANS20, 1, nil, 0, 0, S_CACTIORB10}
states[S_CACTIORB10] = {SPR_CCTO, F|FF_TRANS20, 1, nil, 0, 0, S_CACTIORB1}

mobjinfo[MT_CACTISPIKE] = {
	doomednum = -1,
    spawnstate = S_CACTISPIKE,
    spawnhealth = 1000,
    seestate = S_NULL,
    seesound = 0,
    reactiontime = 8,
    attacksound = sfx_None,
    painstate = S_NULL,
    painchance = 0,
    painsound = sfx_None,
    meleestate = S_NULL,
    missilestate = S_NULL,
    deathstate = S_NULL,
    xdeathstate = S_NULL,
    deathsound = sfx_spkdth,
    speed = 2*FRACUNIT,
    radius = 8*FRACUNIT,
    height = 14*FRACUNIT,
    dispoffset = 0,
    mass = 100,
    damage = 0,
    activesound = sfx_None,
    flags = MF_MISSILE|MF_NOGRAVITY|MF_FLOAT,
    raisestate = 0
}

addHook("MobjSpawn", function(mo)
	mo.shadowscale = FRACUNIT
end, MT_CACTISPIKE)

local function cactiSpikeCollide(spike, mo)
	if (mo.player and mo.player.valid)
	and (gametyperules & GTR_FRIENDLY)
		return false;
	end
end

addHook("MobjCollide", cactiSpikeCollide, MT_CACTISPIKE)
addHook("MobjMoveCollide", cactiSpikeCollide, MT_CACTISPIKE)

states[S_CACTISHIELD_FRONT1] = {SPR_CSPK, A, 2, nil, 0, 0, S_CACTISHIELD_FRONT2}
states[S_CACTISHIELD_FRONT2] = {SPR_CSPK, B, 2, nil, 0, 0, S_CACTISHIELD_FRONT3}
states[S_CACTISHIELD_FRONT3] = {SPR_CSPK, C, 2, nil, 0, 0, S_CACTISHIELD_FRONT4}
states[S_CACTISHIELD_FRONT4] = {SPR_CSPK, D, 2, nil, 0, 0, S_CACTISHIELD_FRONT1}

states[S_CACTISHIELD_BACK1] = {SPR_CSPK, A, 2, nil, 1, 0, S_CACTISHIELD_BACK2}
states[S_CACTISHIELD_BACK2] = {SPR_CSPK, F, 2, nil, 1, 0, S_CACTISHIELD_BACK3}
states[S_CACTISHIELD_BACK3] = {SPR_CSPK, C, 2, nil, 1, 0, S_CACTISHIELD_BACK4}
states[S_CACTISHIELD_BACK4] = {SPR_CSPK, E, 2, nil, 1, 0, S_CACTISHIELD_BACK1}

states[S_CACTISHIELD_FRONT_B1] = {SPR_CSPK, G, 2, nil, 0, 0, S_CACTISHIELD_FRONT_B2}
states[S_CACTISHIELD_FRONT_B2] = {SPR_CSPK, H, 2, nil, 0, 0, S_CACTISHIELD_FRONT_B3}
states[S_CACTISHIELD_FRONT_B3] = {SPR_CSPK, I, 2, nil, 0, 0, S_CACTISHIELD_FRONT_B4}
states[S_CACTISHIELD_FRONT_B4] = {SPR_CSPK, J, 2, nil, 0, 0, S_CACTISHIELD_FRONT_B1}

states[S_CACTISHIELD_ORB_B1] = {SPR_CSPK, M, 1, nil, 0, 0, S_CACTISHIELD_ORB_B2}
states[S_CACTISHIELD_ORB_B2] = {SPR_CSPK, N, 1, nil, 0, 0, S_CACTISHIELD_ORB_B3}
states[S_CACTISHIELD_ORB_B3] = {SPR_CSPK, O, 1, nil, 0, 0, S_CACTISHIELD_ORB_B4}
states[S_CACTISHIELD_ORB_B4] = {SPR_CSPK, P, 1, nil, 0, 0, S_CACTISHIELD_ORB_B5}
states[S_CACTISHIELD_ORB_B5] = {SPR_CSPK, Q, 1, nil, 0, 0, S_CACTISHIELD_ORB_B6}
states[S_CACTISHIELD_ORB_B6] = {SPR_CSPK, R, 1, nil, 0, 0, S_CACTISHIELD_ORB_B1}

states[S_CACTISHIELD_BACK_B1] = {SPR_CSPK, G, 2, nil, 1, 0, S_CACTISHIELD_BACK_B2}
states[S_CACTISHIELD_BACK_B2] = {SPR_CSPK, L, 2, nil, 1, 0, S_CACTISHIELD_BACK_B3}
states[S_CACTISHIELD_BACK_B3] = {SPR_CSPK, I, 2, nil, 1, 0, S_CACTISHIELD_BACK_B4}
states[S_CACTISHIELD_BACK_B4] = {SPR_CSPK, K, 2, nil, 1, 0, S_CACTISHIELD_BACK_B1}

states[S_CACTISPIKE] = {SPR_CCPK, A, -1, nil, 0, 0, S_CACTISPIKE}

mobjinfo[MT_CACTI_BOX] = {
	--$Name Cactus Shield
	--$Sprite TVCCA0
	--$Category SUGOI Powerups
	doomednum = 4025,
	spawnstate = S_CACTI_BOX,
	painstate = S_CACTI_BOX,
	deathstate = S_BOX_POP1,
	deathsound = sfx_pop,
	radius = 18*FRACUNIT,
	height = 40*FRACUNIT,
	spawnhealth = 1,
	speed = 1,
	damage = MT_CACTI_ICON,
	flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR
}

mobjinfo[MT_CACTI_GOLDBOX] = {
	--$Name Cactus Shield (Respawn)
	--$Sprite TVCCB0
	--$Category SUGOI Powerups
	doomednum = 4027,
	spawnstate = S_CACTI_GOLDBOX,
	painstate = S_CACTI_GOLDBOX,
	deathstate = S_GOLDBOX_OFF1,
	deathsound = sfx_pop,
	attacksound = sfx_monton,
	radius = 20*FRACUNIT,
	height = 44*FRACUNIT,
	spawnhealth = 1,
	speed = 1,
	damage = MT_CACTI_ICON,
	flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR|MF_GRENADEBOUNCE
}

mobjinfo[MT_CACTI_ICON] = {
	spawnstate = S_CACTI_ICON1,
	seesound = sfx_spkshi,
	radius = 8*FRACUNIT,
	height = 14*FRACUNIT,
	spawnhealth = 1,
	speed = 2*FRACUNIT,
	damage = 62*FRACUNIT,
	reactiontime = 5,
	flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY|MF_BOXICON
}

states[S_CACTI_BOX] = {SPR_TVCC, A, 2, nil, 0, 0, S_BOX_FLICKER}
states[S_CACTI_GOLDBOX] = {SPR_TVCC, B, 2, A_GoldMonitorSparkle, 0, 0, S_GOLDBOX_FLICKER}
states[S_CACTI_ICON1] = {SPR_TVCC, FF_ANIMATE|C, 18, nil, 3, 4, S_CACTI_ICON2}
states[S_CACTI_ICON2] = {SPR_TVCC, C, 18, A_GiveShield, SH_CACTI, 0, S_NULL}
