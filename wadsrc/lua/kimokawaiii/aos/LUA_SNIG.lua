// --------------------------------------
// LUA_SNIG
// Soniguri player information
// --------------------------------------
local frameinfo = {}
frameinfo[0] = {}
frameinfo[0].rotatenum = 1		// Frame rotation (based on the object's rotation). If this is 1, no rotation. 8 would be 8 way rotation (I.E. east, northeast, north, etc.)
frameinfo[0].frames = {}
frameinfo[0].frames[0] = "SNIGIDL1"
frameinfo[1] = {}
frameinfo[1].rotatenum = 24
frameinfo[1].frames = {}
frameinfo[1].frames[0] = "SNIGD1_A"
frameinfo[1].frames[1] = "SNIGD1_B"
frameinfo[1].frames[2] = "SNIGD1_C"
frameinfo[1].frames[3] = "SNIGD1_D"
frameinfo[1].frames[4] = "SNIGD1_E"
frameinfo[1].frames[5] = "SNIGD1_F"
frameinfo[1].frames[6] = "SNIGD1_G"
frameinfo[1].frames[7] = "SNIGD1_H"
frameinfo[1].frames[8] = "SNIGD1_I"
frameinfo[1].frames[9] = "SNIGD1_J"
frameinfo[1].frames[10] = "SNIGD1_K"
frameinfo[1].frames[11] = "SNIGD1_L"
frameinfo[1].frames[12] = "SNIGD1_M"
frameinfo[1].frames[13] = "SNIGD1_N"
frameinfo[1].frames[14] = "SNIGD1_O"
frameinfo[1].frames[15] = "SNIGD1_P"
frameinfo[1].frames[16] = "SNIGD1_Q"
frameinfo[1].frames[17] = "SNIGD1_R"
frameinfo[1].frames[18] = "SNIGD1_S"
frameinfo[1].frames[19] = "SNIGD1_T"
frameinfo[1].frames[20] = "SNIGD1_U"
frameinfo[1].frames[21] = "SNIGD1_V"
frameinfo[1].frames[22] = "SNIGD1_W"
frameinfo[1].frames[23] = "SNIGD1_X"
frameinfo[2] = {}
frameinfo[2].rotatenum = 24
frameinfo[2].frames = {}
frameinfo[2].frames[0] = "SNIGD2_A"
frameinfo[2].frames[1] = "SNIGD2_B"
frameinfo[2].frames[2] = "SNIGD2_C"
frameinfo[2].frames[3] = "SNIGD2_D"
frameinfo[2].frames[4] = "SNIGD2_E"
frameinfo[2].frames[5] = "SNIGD2_F"
frameinfo[2].frames[6] = "SNIGD2_G"
frameinfo[2].frames[7] = "SNIGD2_H"
frameinfo[2].frames[8] = "SNIGD2_I"
frameinfo[2].frames[9] = "SNIGD2_J"
frameinfo[2].frames[10] = "SNIGD2_K"
frameinfo[2].frames[11] = "SNIGD2_L"
frameinfo[2].frames[12] = "SNIGD2_M"
frameinfo[2].frames[13] = "SNIGD2_N"
frameinfo[2].frames[14] = "SNIGD2_O"
frameinfo[2].frames[15] = "SNIGD2_P"
frameinfo[2].frames[16] = "SNIGD2_Q"
frameinfo[2].frames[17] = "SNIGD2_R"
frameinfo[2].frames[18] = "SNIGD2_S"
frameinfo[2].frames[19] = "SNIGD2_T"
frameinfo[2].frames[20] = "SNIGD2_U"
frameinfo[2].frames[21] = "SNIGD2_V"
frameinfo[2].frames[22] = "SNIGD2_W"
frameinfo[2].frames[23] = "SNIGD2_X"
frameinfo[3] = {}
frameinfo[3].rotatenum = 24
frameinfo[3].frames = {}
frameinfo[3].frames[0] = "SNIGD3_A"
frameinfo[3].frames[1] = "SNIGD3_B"
frameinfo[3].frames[2] = "SNIGD3_C"
frameinfo[3].frames[3] = "SNIGD3_D"
frameinfo[3].frames[4] = "SNIGD3_E"
frameinfo[3].frames[5] = "SNIGD3_F"
frameinfo[3].frames[6] = "SNIGD3_G"
frameinfo[3].frames[7] = "SNIGD3_H"
frameinfo[3].frames[8] = "SNIGD3_I"
frameinfo[3].frames[9] = "SNIGD3_J"
frameinfo[3].frames[10] = "SNIGD3_K"
frameinfo[3].frames[11] = "SNIGD3_L"
frameinfo[3].frames[12] = "SNIGD3_M"
frameinfo[3].frames[13] = "SNIGD3_N"
frameinfo[3].frames[14] = "SNIGD3_O"
frameinfo[3].frames[15] = "SNIGD3_P"
frameinfo[3].frames[16] = "SNIGD3_Q"
frameinfo[3].frames[17] = "SNIGD3_R"
frameinfo[3].frames[18] = "SNIGD3_S"
frameinfo[3].frames[19] = "SNIGD3_T"
frameinfo[3].frames[20] = "SNIGD3_U"
frameinfo[3].frames[21] = "SNIGD3_V"
frameinfo[3].frames[22] = "SNIGD3_W"
frameinfo[3].frames[23] = "SNIGD3_X"
frameinfo[4] = {}
frameinfo[4].rotatenum = 24
frameinfo[4].frames = {}
frameinfo[4].frames[0] = "SNIGD4_A"
frameinfo[4].frames[1] = "SNIGD4_B"
frameinfo[4].frames[2] = "SNIGD4_C"
frameinfo[4].frames[3] = "SNIGD4_D"
frameinfo[4].frames[4] = "SNIGD4_E"
frameinfo[4].frames[5] = "SNIGD4_F"
frameinfo[4].frames[6] = "SNIGD4_G"
frameinfo[4].frames[7] = "SNIGD4_H"
frameinfo[4].frames[8] = "SNIGD4_I"
frameinfo[4].frames[9] = "SNIGD4_J"
frameinfo[4].frames[10] = "SNIGD4_K"
frameinfo[4].frames[11] = "SNIGD4_L"
frameinfo[4].frames[12] = "SNIGD4_M"
frameinfo[4].frames[13] = "SNIGD4_N"
frameinfo[4].frames[14] = "SNIGD4_O"
frameinfo[4].frames[15] = "SNIGD4_P"
frameinfo[4].frames[16] = "SNIGD4_Q"
frameinfo[4].frames[17] = "SNIGD4_R"
frameinfo[4].frames[18] = "SNIGD4_S"
frameinfo[4].frames[19] = "SNIGD4_T"
frameinfo[4].frames[20] = "SNIGD4_U"
frameinfo[4].frames[21] = "SNIGD4_V"
frameinfo[4].frames[22] = "SNIGD4_W"
frameinfo[4].frames[23] = "SNIGD4_X"
frameinfo[5] = {}
frameinfo[5].rotatenum = 1
frameinfo[5].frames = {}
frameinfo[5].frames[0] = "SNIGIDL2"
frameinfo[6] = {}
frameinfo[6].rotatenum = 1
frameinfo[6].frames = {}
frameinfo[6].frames[0] = "SNIGIDL3"
frameinfo[7] = {}
frameinfo[7].rotatenum = 24
frameinfo[7].frames = {}
frameinfo[7].frames[0] = "SNIGS1_A"
frameinfo[7].frames[1] = "SNIGS1_B"
frameinfo[7].frames[2] = "SNIGS1_C"
frameinfo[7].frames[3] = "SNIGS1_D"
frameinfo[7].frames[4] = "SNIGS1_E"
frameinfo[7].frames[5] = "SNIGS1_F"
frameinfo[7].frames[6] = "SNIGS1_G"
frameinfo[7].frames[7] = "SNIGS1_G"
frameinfo[7].frames[8] = "SNIGS1_G"
frameinfo[7].frames[9] = "SNIGS1_G"
frameinfo[7].frames[10] = "SNIGS1_G"
frameinfo[7].frames[11] = "SNIGS1_G"
frameinfo[7].frames[12] = "SNIGS1_G"
frameinfo[7].frames[13] = "SNIGS1_S"
frameinfo[7].frames[14] = "SNIGS1_S"
frameinfo[7].frames[15] = "SNIGS1_S"
frameinfo[7].frames[16] = "SNIGS1_S"
frameinfo[7].frames[17] = "SNIGS1_S"
frameinfo[7].frames[18] = "SNIGS1_S"
frameinfo[7].frames[19] = "SNIGS1_T"
frameinfo[7].frames[20] = "SNIGS1_U"
frameinfo[7].frames[21] = "SNIGS1_V"
frameinfo[7].frames[22] = "SNIGS1_W"
frameinfo[7].frames[23] = "SNIGS1_X"
frameinfo[8] = {}
frameinfo[8].rotatenum = 24
frameinfo[8].frames = {}
frameinfo[8].frames[0] = "SNIGSH_A"
frameinfo[8].frames[1] = "SNIGSH_B"
frameinfo[8].frames[2] = "SNIGSH_C"
frameinfo[8].frames[3] = "SNIGSH_D"
frameinfo[8].frames[4] = "SNIGSH_E"
frameinfo[8].frames[5] = "SNIGSH_F"
frameinfo[8].frames[6] = "SNIGSH_G"
frameinfo[8].frames[7] = "SNIGSH_G"
frameinfo[8].frames[8] = "SNIGSH_G"
frameinfo[8].frames[9] = "SNIGSH_G"
frameinfo[8].frames[10] = "SNIGSH_G"
frameinfo[8].frames[11] = "SNIGSH_G"
frameinfo[8].frames[12] = "SNIGSH_G"
frameinfo[8].frames[13] = "SNIGSH_S"
frameinfo[8].frames[14] = "SNIGSH_S"
frameinfo[8].frames[15] = "SNIGSH_S"
frameinfo[8].frames[16] = "SNIGSH_S"
frameinfo[8].frames[17] = "SNIGSH_S"
frameinfo[8].frames[18] = "SNIGSH_S"
frameinfo[8].frames[19] = "SNIGSH_T"
frameinfo[8].frames[20] = "SNIGSH_U"
frameinfo[8].frames[21] = "SNIGSH_V"
frameinfo[8].frames[22] = "SNIGSH_W"
frameinfo[8].frames[23] = "SNIGSH_X"
frameinfo[9] = {}
frameinfo[9].rotatenum = 1
frameinfo[9].frames = {}
frameinfo[9].frames[0] = "SNIGHD"
frameinfo[10] = {}
frameinfo[10].rotatenum = 1
frameinfo[10].frames = {}
frameinfo[10].frames[0] = "SNIGFLSH"

local idle1 = AOS_AddPFrame(frameinfo[0])
local idle2 = AOS_AddPFrame(frameinfo[5])
local idle3 = AOS_AddPFrame(frameinfo[6])
local dash1 = AOS_AddPFrame(frameinfo[1])
local dash2 = AOS_AddPFrame(frameinfo[2])
local dash3 = AOS_AddPFrame(frameinfo[3])
local dash4 = AOS_AddPFrame(frameinfo[4])
local shoot1 = AOS_AddPFrame(frameinfo[7])
local shield = AOS_AddPFrame(frameinfo[8])
local hurtdie = AOS_AddPFrame(frameinfo[9])
local flashdie = AOS_AddPFrame(frameinfo[10])

local player = {}
player.name = "Soniguri"
player.characterselectportrait = "SNIGCHR"
player.characterselectcircle = "SNIGCSSB"
player.scale = FRACUNIT
player.ponecolor = SKINCOLOR_BLUE
player.ptwocolor = SKINCOLOR_ORANGE
player.animations = {}
// Animations:
// 0:	Idle
// 1:	Moving
// 2:	Dashing
// 3:	Hurt
// 4:	Die
// 5:	Shield
// Anything else is character specific
// Note that 0-5 have hard-coded next animations
// When a custom animation ends, the next animation should be 0-5

// Idle
player.animations[0] = {}
player.animations[0].speed = 2	// Time between frames
player.animations[0].numframes = 4
player.animations[0].nextanim = 0	// Animation to play when this animation ends. Same animation = loop.
player.animations[0].frames = {}
player.animations[0].frames[0] = idle1
player.animations[0].frames[1] = idle2
player.animations[0].frames[2] = idle1
player.animations[0].frames[3] = idle3
// Moving
player.animations[1] = {}
player.animations[1].speed = 2
player.animations[1].numframes = 4
player.animations[1].nextanim = 1
player.animations[1].frames = {}
player.animations[1].frames[0] = idle1
player.animations[1].frames[1] = idle2
player.animations[1].frames[2] = idle1
player.animations[1].frames[3] = idle3
// Dashing
player.animations[2] = {}
player.animations[2].speed = 1
player.animations[2].numframes = 4
player.animations[2].nextanim = 1
player.animations[2].frames = {}
player.animations[2].frames[0] = dash1
player.animations[2].frames[1] = dash2
player.animations[2].frames[2] = dash3
player.animations[2].frames[3] = dash4
// Hurt
player.animations[3] = {}
player.animations[3].speed = 1
player.animations[3].numframes = 1
player.animations[3].nextanim = 0
player.animations[3].frames = {}
player.animations[3].frames[0] = hurtdie
// Die
player.animations[4] = {}
player.animations[4].speed = 0
player.animations[4].numframes = 2
player.animations[4].nextanim = 4
player.animations[4].frames = {}
player.animations[4].frames[0] = hurtdie
player.animations[4].frames[1] = flashdie
// Shield
player.animations[5] = {}
player.animations[5].speed = 1
player.animations[5].numframes = 1
player.animations[5].nextanim = 0
player.animations[5].frames = {}
player.animations[5].frames[0] = shield
// Shoot
player.animations[6] = {}
player.animations[6].speed = 40
player.animations[6].numframes = 1
player.animations[6].nextanim = 0
player.animations[6].frames = {}
player.animations[6].frames[0] = shoot1
// Shield loop
player.animations[7] = {}
player.animations[7].speed = 40
player.animations[7].numframes = 1
player.animations[7].nextanim = 7
player.animations[7].frames = {}
player.animations[7].frames[0] = shield
// Attacks
player.attacks = {}
local blueball = 0
local bluebeam = 0
local function getRandomTarget(player, aosp)
	local numalive = 0
	local aliveplayers = {}
	local pnum = 0
	while(pnum < 32)
		if(player.aosplayers[pnum].exists)
			and not(player.aosplayers[pnum].deathtimer)
			aliveplayers[numalive] = pnum
			numalive = $1 + 1
		end
		pnum = $1 + 1
	end
	
	if(numalive)
		local rng = A_SeedRng_Get()
		
		aosp.target = aliveplayers[rng.GetKey(player.targetseedrngstate, numalive)]
	end
end
player.attacks[0] = function(player, aosp, cmd, buttons, aospn)
	aosp.attacktimer = $1 + 1
	local attackrate = TICRATE*2/7
	if not(aosp.attacktimer%attackrate)
		AOSPlaySound(player, sfx_sglzr1)
		// Shoot the thing!
		local beam = player.aosobjects[createAOSObject(player)]
		beam.type = blueball
		beam.angle = aosp.shootdirection+FixedAngle(aosp.attacktimer*360*FRACUNIT/attackrate/20*14)
		beam.x = aosp.x-(4*cos(beam.angle))
		beam.y = aosp.y-(4*sin(beam.angle))
		beam.momx = (2*cos(beam.angle))
		beam.momy = (2*sin(beam.angle))
		beam.parent = aospn
		beam.target = aosp.target
		//aosp.currentattack = 0
	end
	if(aosp.attacktimer > TICRATE*2)
		aosp.attacktimer = 0
		aosp.currentattack = 0
		aosp.canmove = true
	end
end
local missile1 = 0
player.attacks[1] = function(player, aosp, cmd, buttons, aospn)
	aosp.attacktimer = $1 + 1
	local delay = TICRATE*2/3
	if(aosp.attacktimer-delay == 1)
		or(aosp.attacktimer-delay == TICRATE/8)
		or(aosp.attacktimer-delay == TICRATE/4)
		AOSPlaySound(player, sfx_sgshot)
		// Shoot the thing!
		local beam = player.aosobjects[createAOSObject(player)]
		beam.type = missile1
		if(aosp.attacktimer-delay == 1)
			beam.angle = aosp.shootdirection+ANGLE_180
		elseif(aosp.attacktimer-delay == TICRATE/4)
			beam.angle = aosp.shootdirection-ANGLE_90
		else
			beam.angle = aosp.shootdirection+ANGLE_90
		end
		beam.x = aosp.x+(4*cos(beam.angle))
		beam.y = aosp.y+(4*sin(beam.angle))
		beam.parent = aospn
		beam.target = aosp.target
	end
	if(aosp.attacktimer > TICRATE*2)
		aosp.attacktimer = 0
		aosp.currentattack = 0
		aosp.canmove = true
	end
end
player.attacks[2] = function(player, aosp, cmd, buttons, aospn)
	// Dummy attack
	aosp.attacktimer = $1 + 1
end
local time1 = TICRATE*15
local time2 = TICRATE*32
local time3 = TICRATE*50
local lightball
player.attacks[3] = function(player, aosp, cmd, buttons, aospn)
	// Final phase
	setPAnim(aosp, 7)
	
	aosp.attacktimer = $1 + 1
	
	// Stay at the center of the areana!
	aosp.x = 0
	aosp.y = 0
	
	if(aosp.attacktimer == 1)
		// Reset rng so this attack is the same every time
		local rng = A_SeedRng_Get()
		player.seedrngstate = rng.Create(true, 1, 2, 3, 4)
		player.targetseedrngstate = rng.Create(true, 1, 2, 3, 4)
		// Shoot the thing!
		local beam = player.aosobjects[createAOSObject(player)]
		beam.type = lightball
		beam.x = aosp.x
		beam.y = aosp.y
		beam.parent = aospn
//		getRandomTarget(player, aosp)
//		beam.target = aosp.target
		
		// Spawn other balls
		// Red
		beam = player.aosobjects[createAOSObject(player)]
		beam.type = lightball
		beam.x = aosp.x
		beam.y = aosp.y
		beam.parent = aospn
		beam.alttimer = 1
		beam.angle = FixedAngle(135*FRACUNIT)
		// Purple
		beam = player.aosobjects[createAOSObject(player)]
		beam.type = lightball
		beam.x = aosp.x
		beam.y = aosp.y
		beam.parent = aospn
		beam.alttimer = 2
		beam.angle = FixedAngle(180*FRACUNIT)
		// Cyan
		beam = player.aosobjects[createAOSObject(player)]
		beam.type = lightball
		beam.x = aosp.x
		beam.y = aosp.y
		beam.parent = aospn
		beam.alttimer = 3
		beam.angle = FixedAngle(270*FRACUNIT)
		// Green
		beam = player.aosobjects[createAOSObject(player)]
		beam.type = lightball
		beam.x = aosp.x
		beam.y = aosp.y
		beam.parent = aospn
		beam.alttimer = 4
		beam.angle = FixedAngle(135*FRACUNIT)
	elseif(aosp.attacktimer == time1)
		// Tan
		local beam = player.aosobjects[createAOSObject(player)]
		beam.type = lightball
		beam.x = aosp.x
		beam.y = aosp.y
		beam.parent = aospn
		beam.alttimer = 6
		// Steel
		beam = player.aosobjects[createAOSObject(player)]
		beam.type = lightball
		beam.x = aosp.x
		beam.y = aosp.y
		beam.parent = aospn
		beam.alttimer = 5
	elseif(aosp.attacktimer == time2)
		// Orange
		local beam = player.aosobjects[createAOSObject(player)]
		beam.type = lightball
		beam.x = aosp.x
		beam.y = aosp.y
		beam.parent = aospn
		beam.alttimer = 7
		beam.angle = FixedAngle(90*FRACUNIT)
	end
	
	if(aosp.attacktimer == 1)
		or(aosp.attacktimer == time1)
		or(aosp.attacktimer == time2)
		if(aosp.attacktimer == time1)
			or(aosp.attacktimer == time2)
			AOSPlaySound(player, sfx_sgacel)
		end
		player.timeslow = TICRATE*3
	end
		
	
	local shoottime = 12
	if(aosp.attacktimer > time2)
		shoottime = 4
	elseif(aosp.attacktimer > time1)
		shoottime = 8
	end
	
	if(aosp.attacktimer > TICRATE*2)
		and not(aosp.attacktimer-time1 > 0 and aosp.attacktimer-time1 < TICRATE*2)
		and not(aosp.attacktimer-time2 > 0 and aosp.attacktimer-time2 < TICRATE*2)
		if not(aosp.attacktimer%shoottime)
			AOSPlaySound(player, sfx_sglzr2)
			local rng = A_SeedRng_Get()
			
			// Shoot the thing!
			local beam = player.aosobjects[createAOSObject(player)]
			beam.type = bluebeam
			beam.angle = aosp.shootdirection+FixedAngle(rng.GetKey(player.seedrngstate, 360*FRACUNIT))
			beam.x = aosp.x
			beam.y = aosp.y
			beam.parent = aospn
			getRandomTarget(player, aosp)
			beam.target = aosp.target
		end
	end
	
	if(aosp.attacktimer > time3)
		aosp.currentattack = 5
		aosp.deathtimer = 1
		aosp.health = 0
		aosp.attacktimer = 0
	end
end
// Death "attack"
player.attacks[4] = function(player, aosp, cmd, buttons, aospn)
	aosp.attacktimer = $1 + 1
end
local longbeam
local beamspawn
local bluebeamshoot
local bsspawnangles = {}
bsspawnangles[0] = FixedAngle(85*FRACUNIT)
bsspawnangles[1] = FixedAngle(-85*FRACUNIT)
bsspawnangles[2] = FixedAngle(115*FRACUNIT)
bsspawnangles[3] = FixedAngle(-115*FRACUNIT)
player.attacks[5] = function(player, aosp, cmd, buttons, aospn)
	aosp.attacktimer = $1 + 1
	
	setPAnim(aosp, 6)
	
	if(aosp.attacktimer == 1)
		AOSPlaySound(player, sfx_sglzr1)
		local bsnum = 0
		while(bsnum < 4)
			// Shoot the thing!
			local beam = player.aosobjects[createAOSObject(player)]
			beam.type = beamspawn
			local goodangle = aosp.shootdirection+bsspawnangles[bsnum]
			local angle2 = FixedAngle(20*FRACUNIT)
			if(bsnum & 1)
				angle2 = FixedAngle(-20*FRACUNIT)
			end
			beam.angle = aosp.shootdirection+angle2
			local dist = 10
			if(bsnum > 1)
				dist = 20
			end
			beam.x = aosp.x+(dist*cos(goodangle))
			beam.y = aosp.y+(dist*sin(goodangle))
			beam.parent = aospn
			beam.target = aosp.target
			bsnum = $1 + 1
		end
	elseif(aosp.attacktimer == TICRATE/10)
		or(aosp.attacktimer == TICRATE/5)
		AOSPlaySound(player, sfx_sglzr1)
	end
	
	// Shoot the beams!
	local shootrate = 2
	if(aosp.attacktimer == 1)
		or(aosp.attacktimer == shootrate)
		or(aosp.attacktimer == shootrate*2)
		or(aosp.attacktimer == shootrate*3)
		or(aosp.attacktimer == shootrate*4)
		or(aosp.attacktimer == shootrate*5)
		AOSPlaySound(player, sfx_sgbem2)
		// random angle!
		local rng = A_SeedRng_Get()
		
		local beam = player.aosobjects[createAOSObject(player)]
		beam.type = bluebeamshoot
		beam.angle = aosp.shootdirection+FixedAngle(rng.GetKey(player.seedrngstate, 45*FRACUNIT)-(45*FRACUNIT/2))
		beam.momx = 9*cos(beam.angle)
		beam.momy = 9*sin(beam.angle)
		beam.x = aosp.x+(4*cos(beam.angle))
		beam.y = aosp.y+(4*sin(beam.angle))
		beam.parent = aospn
	end
	
	if(aosp.attacktimer > shootrate*6)
		aosp.attacktimer = 0
		aosp.currentattack = 0
		aosp.canmove = true
		setPAnim(aosp, 0)
	end
end
local missile2
player.attacks[6] = function(player, aosp, cmd, buttons, aospn)
	aosp.attacktimer = $1 + 1
	
	setPAnim(aosp, 7)
	
	if(aosp.attacktimer == 1)
		AOSPlaySound(player, sfx_sglzr1)
		local bsnum = 0
		while(bsnum < 4)
			// Shoot the thing!
			local beam = player.aosobjects[createAOSObject(player)]
			beam.type = beamspawn
			local goodangle = aosp.shootdirection+bsspawnangles[bsnum]
			local angle2 = FixedAngle(20*FRACUNIT)
			if(bsnum & 1)
				angle2 = FixedAngle(-20*FRACUNIT)
			end
			beam.angle = aosp.shootdirection+angle2
			local dist = 10
			if(bsnum > 1)
				dist = 20
			end
			beam.x = aosp.x+(dist*cos(goodangle))
			beam.y = aosp.y+(dist*sin(goodangle))
			beam.parent = aospn
			beam.target = aosp.target
			bsnum = $1 + 1
		end
	elseif(aosp.attacktimer == TICRATE/10)
		or(aosp.attacktimer == TICRATE/5)
		AOSPlaySound(player, sfx_sglzr1)
	end
	
	// Shoot the rockets!
	local shootrate = 2
	if(aosp.attacktimer == 1)
		or(aosp.attacktimer-1 == shootrate)
		or(aosp.attacktimer-1 == shootrate*2)
		or(aosp.attacktimer-1 == shootrate*3)
		or(aosp.attacktimer-1 == shootrate*4)
		or(aosp.attacktimer-1 == shootrate*5)
		or(aosp.attacktimer-1 == shootrate*6)
		or(aosp.attacktimer-1 == shootrate*7)
		or(aosp.attacktimer-1 == shootrate*8)
		or(aosp.attacktimer-1 == shootrate*9)
	//	or(aosp.attacktimer-1 == shootrate*10)
	//	or(aosp.attacktimer-1 == shootrate*11)
		AOSPlaySound(player, sfx_sgshot)
		// random angle!
		local rng = A_SeedRng_Get()
		
		local beam = player.aosobjects[createAOSObject(player)]
		beam.type = missile2
		local shootangle = aosp.shootdirection+FixedAngle((90+(180*(((aosp.attacktimer-1)/shootrate)&1)))*FRACUNIT)
		beam.angle = aosp.shootdirection
		beam.momx = FixedMul(2*cos(shootangle), (((aosp.attacktimer-1)/shootrate/2)*FRACUNIT/8)+FRACUNIT)
		beam.momy = FixedMul(2*sin(shootangle), (((aosp.attacktimer-1)/shootrate/2)*FRACUNIT/8)+FRACUNIT)
		beam.x = aosp.x+(4*cos(beam.angle))
		beam.y = aosp.y+(4*sin(beam.angle))
		beam.parent = aospn
	end
	
	if(aosp.attacktimer > shootrate*12)
		aosp.attacktimer = 0
		aosp.currentattack = 0
		aosp.canmove = true
		setPAnim(aosp, 0)
	end
end
player.attacks[7] = function(player, aosp, cmd, buttons, aospn)
	aosp.attacktimer = $1 + 1
	
	setPAnim(aosp, 6)
	
	aosp.lockspeed = true
	aosp.movementspeed = 4*FRACUNIT
	if(aosp.attacktimer == 1)
		aosp.dashdirection = aosp.shootdirection
	end
	
	// Shoot the beams!
	local shootrate = 2
	if(aosp.attacktimer == 1)
		or(aosp.attacktimer == shootrate)
		or(aosp.attacktimer == shootrate*2)
		or(aosp.attacktimer == shootrate*3)
		or(aosp.attacktimer == shootrate*4)
		or(aosp.attacktimer == shootrate*5)
		AOSPlaySound(player, sfx_sgbem2)
		// random angle!
		local rng = A_SeedRng_Get()
		
		local beam = player.aosobjects[createAOSObject(player)]
		beam.type = bluebeamshoot
		beam.angle = aosp.shootdirection+FixedAngle(rng.GetKey(player.seedrngstate, 45*FRACUNIT)-(45*FRACUNIT/2))
		beam.momx = 9*cos(beam.angle)
		beam.momy = 9*sin(beam.angle)
		beam.x = aosp.x+(4*cos(beam.angle))
		beam.y = aosp.y+(4*sin(beam.angle))
		beam.parent = aospn
	end
	
	if(aosp.attacktimer > shootrate*12)
		aosp.attacktimer = 0
		aosp.currentattack = 0
		aosp.canmove = true
		aosp.lockspeed = false
		setPAnim(aosp, 0)
	end
end
local purpleball = 0
player.attacks[8] = function(player, aosp, cmd, buttons, aospn)
	aosp.attacktimer = $1 + 1
	local attackrate = 4
	if not(aosp.attacktimer%attackrate)
		and not(aosp.attacktimer > attackrate*6)
		AOSPlaySound(player, sfx_sglzr1)
		// Shoot the thing!
		local beam = player.aosobjects[createAOSObject(player)]
		beam.type = purpleball
		beam.angle = aosp.shootdirection+FixedAngle(aosp.attacktimer*360*FRACUNIT/attackrate/20*14)
		beam.x = aosp.x-(4*cos(beam.angle))
		beam.y = aosp.y-(4*sin(beam.angle))
		beam.momx = (2*cos(beam.angle))
		beam.momy = (2*sin(beam.angle))
		beam.parent = aospn
		beam.target = aosp.target
	end
	if(aosp.attacktimer > attackrate*7)
		aosp.attacktimer = 0
		aosp.currentattack = 0
		aosp.canmove = true
	end
end
local missile3
player.attacks[9] = function(player, aosp, cmd, buttons, aospn)
	aosp.attacktimer = $1 + 1
	
	setPAnim(aosp, 7)
	
	// Shoot the rockets!
	local shootrate = 2
	if(aosp.attacktimer == 1)
		or(aosp.attacktimer-1 == shootrate)
		or(aosp.attacktimer-1 == shootrate*2)
		or(aosp.attacktimer-1 == shootrate*3)
		or(aosp.attacktimer-1 == shootrate*4)
		or(aosp.attacktimer-1 == shootrate*5)
		or(aosp.attacktimer-1 == shootrate*6)
		or(aosp.attacktimer-1 == shootrate*7)
		or(aosp.attacktimer-1 == shootrate*8)
		or(aosp.attacktimer-1 == shootrate*9)
		or(aosp.attacktimer-1 == shootrate*10)
		or(aosp.attacktimer-1 == shootrate*11)
		AOSPlaySound(player, sfx_sgshot)
		// random angle!
		local rng = A_SeedRng_Get()
		
		local beam = player.aosobjects[createAOSObject(player)]
		beam.type = missile3
		local shootangle = aosp.shootdirection+FixedAngle((90+(180*(((aosp.attacktimer-1)/shootrate)&1)))*FRACUNIT)
		beam.angle = aosp.shootdirection
		beam.momx = FixedMul(2*cos(shootangle), (((aosp.attacktimer-1)/shootrate/2)*FRACUNIT/8)+FRACUNIT)
		beam.momy = FixedMul(2*sin(shootangle), (((aosp.attacktimer-1)/shootrate/2)*FRACUNIT/8)+FRACUNIT)
		beam.x = aosp.x+(4*cos(beam.angle))
		beam.y = aosp.y+(4*sin(beam.angle))
		beam.parent = aospn
	end
	
	if(aosp.attacktimer > shootrate*19)
		aosp.attacktimer = 0
		aosp.currentattack = 0
		aosp.canmove = true
		setPAnim(aosp, 0)
	end
end
local swordbeam
local swordlength = 7*FRACUNIT
local swordsegnum = 12
player.attacks[10] = function(player, aosp, cmd, buttons, aospn)
	aosp.attacktimer = $1 + 1
	
	setPAnim(aosp, 7)
	
	aosp.dashing = 0
	
	aosp.lockspeed = true
	if(aosp.attacktimer == 1)
		aosp.movementspeed = 1
		aosp.dashdirection = aosp.shootdirection
		aosp.attackvar = aosp.shootdirection-FixedAngle(120*FRACUNIT)
	end
	local angleval = 0
	if(aosp.attacktimer == TICRATE/6)
		aosp.movementspeed = 4*FRACUNIT
	elseif(aosp.attacktimer > TICRATE/2)
		aosp.movementspeed = $1 - FRACUNIT/6
		if(aosp.attacktimer < TICRATE*7/8)
			aosp.attackvar = $1 + FixedAngle(aosp.movementspeed*5)
			angleval = aosp.movementspeed*2
		end
	end
	if(aosp.attacktimer == TICRATE/2)
		AOSPlaySound(player, sfx_sgshld)
	end
	
	// Shoot beam sword!
	local snum = 0
	local basex = aosp.x
	local basey = aosp.y
	local angle = aosp.attackvar//+FixedAngle((leveltime*15)*FRACUNIT)
	local angleadd = -FixedAngle(angleval)
	while(snum < swordsegnum)
		local beam = player.aosobjects[createAOSObject(player)]
		beam.type = swordbeam
		beam.angle = angle
	//	beam.momx = FixedMul(cos(beam.angle), swordlength*swordsegnum)
	//	beam.momy = FixedMul(sin(beam.angle), swordlength*swordsegnum)
		beam.x = basex+FixedMul(cos(beam.angle), swordlength)
		beam.y = basey+FixedMul(sin(beam.angle), swordlength)
		basex = beam.x
		basey = beam.y
		beam.parent = aospn
		angle = $1 + angleadd
		snum = $1 + 1
	end
	
	if(aosp.attacktimer > TICRATE)
		aosp.attacktimer = 0
		aosp.currentattack = 0
		aosp.canmove = true
		aosp.lockspeed = false
		setPAnim(aosp, 0)
	end
end
player.attacks[11] = function(player, aosp, cmd, buttons, aospn)
	aosp.attacktimer = $1 + 1
	
	setPAnim(aosp, 7)
	
	aosp.dashing = 0
	
	aosp.lockspeed = true
	if(aosp.attacktimer == 1)
		aosp.movementspeed = 1
		aosp.dashdirection = aosp.shootdirection
		aosp.attackvar = aosp.shootdirection-FixedAngle(120*FRACUNIT)
	end
	local angleval = 0
	if(aosp.attacktimer == TICRATE/6)
		aosp.movementspeed = 4*FRACUNIT
	elseif(aosp.attacktimer > TICRATE/2)
		aosp.movementspeed = $1 - FRACUNIT/6
		if(aosp.attacktimer < TICRATE*7/8)
			aosp.attackvar = $1 + FixedAngle(aosp.movementspeed*5)
			angleval = aosp.movementspeed*2
		end
	end
	if(aosp.attacktimer == TICRATE/2)
		AOSPlaySound(player, sfx_sgshld)
	end
	
	// Shoot beam sword!
	local snum = 0
	local basex = aosp.x
	local basey = aosp.y
	local angle = aosp.attackvar//+FixedAngle((leveltime*15)*FRACUNIT)
	local angleadd = -FixedAngle(angleval)
	while(snum < swordsegnum)
		local beam = player.aosobjects[createAOSObject(player)]
		beam.type = swordbeam
		beam.angle = angle
	//	beam.momx = FixedMul(cos(beam.angle), swordlength*swordsegnum)
	//	beam.momy = FixedMul(sin(beam.angle), swordlength*swordsegnum)
		beam.x = basex+FixedMul(cos(beam.angle), swordlength)
		beam.y = basey+FixedMul(sin(beam.angle), swordlength)
		basex = beam.x
		basey = beam.y
		beam.parent = aospn
		angle = $1 + angleadd
		snum = $1 + 1
	end
	// Shoot the second beam sword!
	snum = 0
	basex = aosp.x
	basey = aosp.y
	angle = aosp.attackvar//+FixedAngle((leveltime*15)*FRACUNIT)
	angleadd = -FixedAngle(angleval)
	while(snum < swordsegnum)
		local beam = player.aosobjects[createAOSObject(player)]
		beam.type = swordbeam
		beam.angle = angle
	//	beam.momx = FixedMul(cos(beam.angle), swordlength*swordsegnum)
	//	beam.momy = FixedMul(sin(beam.angle), swordlength*swordsegnum)
		beam.x = basex-FixedMul(cos(beam.angle), swordlength)
		beam.y = basey-FixedMul(sin(beam.angle), swordlength)
		basex = beam.x
		basey = beam.y
		beam.parent = aospn
		angle = $1 + angleadd
		snum = $1 + 1
	end
	
	if(aosp.attacktimer > TICRATE)
		aosp.attacktimer = 0
		aosp.currentattack = 0
		aosp.canmove = true
		aosp.lockspeed = false
		setPAnim(aosp, 0)
	end
end
player.attacks[12] = function(player, aosp, cmd, buttons, aospn)

end
local bshyperspawnangles = {}
bshyperspawnangles[0] = FixedAngle(20*FRACUNIT)
bshyperspawnangles[1] = FixedAngle(-20*FRACUNIT)
bshyperspawnangles[2] = FixedAngle(50*FRACUNIT)
bshyperspawnangles[3] = FixedAngle(-50*FRACUNIT)
local hyperlaserangles = {}
hyperlaserangles[0] = FixedAngle(20*FRACUNIT)
hyperlaserangles[1] = FixedAngle(-20*FRACUNIT)
hyperlaserangles[2] = FixedAngle(50*FRACUNIT)
hyperlaserangles[3] = FixedAngle(-50*FRACUNIT)
local hyperbeam
player.attacks[13] = function(player, aosp, cmd, buttons, aospn)
	aosp.attacktimer = $1 + 1
	
	setPAnim(aosp, 7)
	
	if(aosp.attacktimer < TICRATE*2)
		aosp.shieldtime = -aosp.attacktimer
	end
	
	if(aosp.attacktimer == 1)
		player.soniguridumbvar = 0
	end
	
	if(aosp.attacktimer > TICRATE/2)
		and(aosp.attacktimer < TICRATE*8)
		if not(aosp.attacktimer%(TICRATE/2))
			AOSPlaySound(player, sfx_sglzr2)
			// Shoot the thing!
			local beam = player.aosobjects[createAOSObject(player)]
			beam.type = bluebeam
			local angle = FixedAngle(160*FRACUNIT)
			if(aosp.attackvar & 4)
				angle = FixedAngle(200*FRACUNIT)
			end
			beam.angle = player.soniguriangle+FixedAngle(angle)
			beam.x = aosp.x+(8*cos(beam.angle))
			beam.y = aosp.y+(8*sin(beam.angle))
			beam.parent = aospn
			getRandomTarget(player, aosp)
			beam.target = aosp.target
			
			if(aosp.attackvar & 4)
				aosp.attackvar = $1 & !4
			else
				aosp.attackvar = $1|4
			end
		end
		
		if not(aosp.attacktimer%(TICRATE/5))
			AOSPlaySound(player, sfx_sgshot)
			// Shoot the thing!
			local beam = player.aosobjects[createAOSObject(player)]
			beam.type = missile1
			local angle = FixedAngle(160*FRACUNIT)
			if(aosp.attackvar & 8)
				angle = FixedAngle(200*FRACUNIT)
			end
			beam.angle = player.soniguriangle+FixedAngle(angle)
			beam.x = aosp.x+(8*cos(beam.angle))
			beam.y = aosp.y+(8*sin(beam.angle))
			beam.parent = aospn
			getRandomTarget(player, aosp)
			beam.target = aosp.target
			if(aosp.attackvar & 8)
				aosp.attackvar = $1 & !8
			else
				aosp.attackvar = $1|8
			end
		end
		
		if not(aosp.attacktimer%(TICRATE/6))
			AOSPlaySound(player, sfx_sglzr1)
			local num = aosp.attackvar & 3
			
			// Shoot the thing!
			local beam = player.aosobjects[createAOSObject(player)]
			beam.type = beamspawn
			beam.angle = (player.soniguriangle+bshyperspawnangles[num])+FixedAngle(180*FRACUNIT)
			local dist = 50
			local basex = aosp.x+(dist*cos(player.soniguriangle))
			local basey = aosp.y+(dist*sin(player.soniguriangle))
			beam.x = basex+(dist*cos(beam.angle))
			beam.y = basey+(dist*sin(beam.angle))
			beam.parent = aospn
			getRandomTarget(player, aosp)
			beam.target = aosp.target
			num = ($1 + 1) & 3
			aosp.attackvar = $1 & !3
			aosp.attackvar = $1 + num
		end
		
		
		if not(aosp.attacktimer%(TICRATE/3))
			AOSPlaySound(player, sfx_sglazr)
			// Shoot the thing!
			local beam = player.aosobjects[createAOSObject(player)]
			beam.type = hyperbeam
			local angle = AngleFixed(player.soniguriangle+hyperlaserangles[player.soniguridumbvar]+FixedAngle(180*FRACUNIT))
			angle = ($1/24)/FRACUNIT
			angle = $1 * 24 * FRACUNIT
			beam.angle = FixedAngle(angle)
			beam.x = aosp.x+(240*cos(beam.angle))
			beam.y = aosp.y+(240*sin(beam.angle))
			beam.parent = aospn
			getRandomTarget(player, aosp)
			beam.target = aosp.target
			player.soniguridumbvar = ($1 + 1) & 3
		end
	end
	
	if(aosp.attacktimer > TICRATE*9)
		aosp.attacktimer = 0
		aosp.currentattack = 0
		aosp.canmove = true
		setPAnim(aosp, 0)
	end
end
player.attacks[14] = function(player, aosp, cmd, buttons, aospn)

end
player.attacks[15] = function(player, aosp, cmd, buttons, aospn)

end
player.attacks[16] = function(player, aosp, cmd, buttons, aospn)
	aosp.attacktimer = $1 + 1
	local delay = TICRATE*2/3
	if(aosp.attacktimer-delay == 1)
		or(aosp.attacktimer-delay == TICRATE/5)
		or(aosp.attacktimer-delay == TICRATE*2/5)
		or(aosp.attacktimer-delay == TICRATE*3/5)
		AOSPlaySound(player, sfx_sgshot)
		// Shoot the thing!
		local beam = player.aosobjects[createAOSObject(player)]
		beam.type = missile1
		beam.angle = aosp.shootdirection+ANGLE_90
		beam.x = aosp.x+(4*cos(beam.angle))
		beam.y = aosp.y+(4*sin(beam.angle))
		beam.parent = aospn
		beam.target = aosp.target
		
		if not(aosp.attacktimer-delay > TICRATE/4)
			beam = player.aosobjects[createAOSObject(player)]
			beam.type = missile1
			beam.angle = aosp.shootdirection-ANGLE_90
			beam.x = aosp.x+(4*cos(beam.angle))
			beam.y = aosp.y+(4*sin(beam.angle))
			beam.parent = aospn
			beam.target = aosp.target
		end
	end
	if(aosp.attacktimer > TICRATE*2)
		aosp.attacktimer = 0
		aosp.currentattack = 0
		aosp.canmove = true
	end
end
player.attacks[17] = function(player, aosp, cmd, buttons, aospn)
	aosp.attacktimer = $1 + 1
	
	setPAnim(aosp, 7)
	
	// Shoot the rockets!
	local shootrate = 2
	if(aosp.attacktimer == 1)
		or(aosp.attacktimer-1 == shootrate)
		or(aosp.attacktimer-1 == shootrate*2)
		or(aosp.attacktimer-1 == shootrate*3)
		or(aosp.attacktimer-1 == shootrate*4)
		or(aosp.attacktimer-1 == shootrate*5)
		or(aosp.attacktimer-1 == shootrate*6)
		or(aosp.attacktimer-1 == shootrate*7)
		or(aosp.attacktimer-1 == shootrate*8)
		or(aosp.attacktimer-1 == shootrate*9)
		or(aosp.attacktimer-1 == shootrate*10)
		or(aosp.attacktimer-1 == shootrate*11)
		or(aosp.attacktimer-1 == shootrate*12)
		or(aosp.attacktimer-1 == shootrate*13)
		AOSPlaySound(player, sfx_sgshot)
		// random angle!
		local rng = A_SeedRng_Get()
		
		local beam = player.aosobjects[createAOSObject(player)]
		beam.type = missile3
		local shootangle = aosp.shootdirection+FixedAngle((90+(180*(((aosp.attacktimer-1)/shootrate)&1)))*FRACUNIT)
		beam.angle = aosp.shootdirection
		beam.momx = FixedMul(2*cos(shootangle), (((aosp.attacktimer-1)/shootrate/2)*FRACUNIT/8)+FRACUNIT)
		beam.momy = FixedMul(2*sin(shootangle), (((aosp.attacktimer-1)/shootrate/2)*FRACUNIT/8)+FRACUNIT)
		beam.x = aosp.x+(4*cos(beam.angle))
		beam.y = aosp.y+(4*sin(beam.angle))
		beam.parent = aospn
	end
	
	if(aosp.attacktimer > shootrate*19)
		aosp.attacktimer = 0
		aosp.currentattack = 0
		aosp.canmove = true
		setPAnim(aosp, 0)
	end
end
player.attacks[18] = function(player, aosp, cmd, buttons, aospn)
	aosp.attacktimer = $1 + 1
	
	setPAnim(aosp, 7)
	
	if(aosp.attacktimer == 1)
		AOSPlaySound(player, sfx_sglzr1)
		AOSPlaySound(player, sfx_sglazr)
		local bsnum = 0
		while(bsnum < 4)
			// Shoot the thing!
			local beam = player.aosobjects[createAOSObject(player)]
			beam.type = beamspawn
			local goodangle = aosp.shootdirection+bsspawnangles[bsnum]
			local angle2 = FixedAngle(20*FRACUNIT)
			if(bsnum & 1)
				angle2 = FixedAngle(-20*FRACUNIT)
			end
			beam.angle = aosp.shootdirection+angle2
			local dist = 10
			if(bsnum > 1)
				dist = 20
			end
			beam.x = aosp.x+(dist*cos(goodangle))
			beam.y = aosp.y+(dist*sin(goodangle))
			beam.parent = aospn
			beam.target = aosp.target
			
			// Shoot the thing!
			beam = player.aosobjects[createAOSObject(player)]
			beam.type = hyperbeam
			local angle = AngleFixed(aosp.shootdirection+hyperlaserangles[bsnum])
			angle = ($1/24)/FRACUNIT
			angle = $1 * 24 * FRACUNIT
			beam.angle = FixedAngle(angle)
			beam.x = aosp.x+(240*cos(beam.angle))
			beam.y = aosp.y+(240*sin(beam.angle))
			beam.parent = aospn
			beam.target = aosp.target

			bsnum = $1 + 1
		end
	elseif(aosp.attacktimer == TICRATE/10)
		or(aosp.attacktimer == TICRATE/5)
		AOSPlaySound(player, sfx_sglzr1)
	end
	
	if(aosp.attacktimer > 12)
		aosp.attacktimer = 0
		aosp.currentattack = 0
		aosp.canmove = true
		setPAnim(aosp, 0)
	end
end
player.attacks[19] = function(player, aosp, cmd, buttons, aospn)
	aosp.attacktimer = $1 + 1
	
	setPAnim(aosp, 7)
	
	aosp.dashing = 0
	
	aosp.lockspeed = true
	if(aosp.attacktimer == 1)
		aosp.movementspeed = 1
		aosp.dashdirection = aosp.shootdirection
		aosp.attackvar = aosp.shootdirection-FixedAngle(120*FRACUNIT)
	end
	local angleval = 0
	if(aosp.attacktimer == TICRATE/6)
		aosp.movementspeed = 4*FRACUNIT
	elseif(aosp.attacktimer > TICRATE/2)
		aosp.movementspeed = $1 - FRACUNIT/6
		if(aosp.attacktimer < TICRATE*7/8)
			aosp.attackvar = $1 + FixedAngle(aosp.movementspeed*5)
			angleval = aosp.movementspeed*2
		end
	end
	if(aosp.attacktimer == TICRATE/2)
		AOSPlaySound(player, sfx_sgshld)
	end
	
	// Shoot beam sword!
	local snum = 0
	local basex = aosp.x
	local basey = aosp.y
	local angle = aosp.attackvar//+FixedAngle((leveltime*15)*FRACUNIT)
	local angleadd = -FixedAngle(angleval)
	while(snum < swordsegnum)
		local beam = player.aosobjects[createAOSObject(player)]
		beam.type = swordbeam
		beam.angle = angle
	//	beam.momx = FixedMul(cos(beam.angle), swordlength*swordsegnum)
	//	beam.momy = FixedMul(sin(beam.angle), swordlength*swordsegnum)
		beam.x = basex+FixedMul(cos(beam.angle), swordlength)
		beam.y = basey+FixedMul(sin(beam.angle), swordlength)
		basex = beam.x
		basey = beam.y
		beam.parent = aospn
		angle = $1 + angleadd
		snum = $1 + 1
	end
	
	if(aosp.attacktimer > TICRATE)
		aosp.attacktimer = 0
		aosp.currentattack = 12
		aosp.canmove = true
		aosp.lockspeed = false
		setPAnim(aosp, 0)
	end
end
player.attacks[20] = function(player, aosp, cmd, buttons, aospn)
	aosp.attacktimer = $1 + 1
	
	if(aosp.attacktimer > TICRATE*3/2)
		aosp.attacktimer = 0
		aosp.currentattack = 0
		aosp.canmove = true
		aosp.lockspeed = false
	end
end
local edgebox
player.attacks[21] = function(player, aosp, cmd, buttons, aospn)
	aosp.attacktimer = $1 + 1
	
	local beam = player.aosobjects[createAOSObject(player)]
	beam.type = edgebox
	beam.angle = aosp.dashdirection
	beam.x = aosp.x
	beam.y = aosp.y
	beam.parent = aospn
	
	if(aosp.attacktimer > TICRATE*2)
		aosp.attacktimer = 0
		aosp.currentattack = 0
		aosp.canmove = true
		aosp.lockspeed = false
	end
end
player.attacks[22] = function(player, aosp, cmd, buttons, aospn)
	aosp.attacktimer = $1 + 1
	
	local delay = TICRATE*2/3
	local attackrate = TICRATE*2/7
	if(aosp.attacktimer-delay == 1)
		or(aosp.attacktimer-delay == TICRATE/8)
		or(aosp.attacktimer-delay == TICRATE/4)
		AOSPlaySound(player, sfx_sglzr1)
		// Shoot the thing!
		local beam = player.aosobjects[createAOSObject(player)]
		beam.type = blueball
		beam.angle = aosp.shootdirection+FixedAngle(aosp.attacktimer*360*FRACUNIT/attackrate/20*14)
		beam.x = aosp.x-(4*cos(beam.angle))
		beam.y = aosp.y-(4*sin(beam.angle))
		beam.momx = (2*cos(beam.angle))
		beam.momy = (2*sin(beam.angle))
		beam.parent = aospn
		beam.target = aosp.target
	end
	
	local beam = player.aosobjects[createAOSObject(player)]
	beam.type = edgebox
	beam.angle = aosp.dashdirection
	beam.x = aosp.x
	beam.y = aosp.y
	beam.parent = aospn
	
	if(aosp.attacktimer > TICRATE*2)
		aosp.attacktimer = 0
		aosp.currentattack = 0
		aosp.canmove = true
		aosp.lockspeed = false
	end
end
player.attacks[23] = function(player, aosp, cmd, buttons, aospn)
	aosp.attacktimer = $1 + 1
	local attackrate = 4
	if not(aosp.attacktimer%attackrate)
		and not(aosp.attacktimer > attackrate*6)
		AOSPlaySound(player, sfx_sglzr1)
		// Shoot the thing!
		local beam = player.aosobjects[createAOSObject(player)]
		beam.type = purpleball
		beam.angle = aosp.shootdirection+FixedAngle(aosp.attacktimer*360*FRACUNIT/attackrate/20*14)
		beam.x = aosp.x-(4*cos(beam.angle))
		beam.y = aosp.y-(4*sin(beam.angle))
		beam.momx = (2*cos(beam.angle))
		beam.momy = (2*sin(beam.angle))
		beam.parent = aospn
		beam.target = aosp.target
	end
	if(aosp.attacktimer > attackrate*7)
		aosp.attacktimer = 0
		aosp.currentattack = 0
		aosp.canmove = true
	end
end
player.attacks[24] = function(player, aosp, cmd, buttons, aospn)

end
local nukespawnangles = {}
nukespawnangles[0] = FixedAngle(15*FRACUNIT)
nukespawnangles[1] = FixedAngle(-15*FRACUNIT)
nukespawnangles[2] = FixedAngle(30*FRACUNIT)
nukespawnangles[3] = FixedAngle(-30*FRACUNIT)
nukespawnangles[4] = FixedAngle(45*FRACUNIT)
nukespawnangles[5] = FixedAngle(-45*FRACUNIT)
nukespawnangles[6] = FixedAngle(60*FRACUNIT)
nukespawnangles[7] = FixedAngle(-60*FRACUNIT)
local nuke
local explosion
player.attacks[25] = function(player, aosp, cmd, buttons, aospn)
	aosp.attacktimer = $1 + 1
	
	setPAnim(aosp, 7)
	
	if(aosp.attacktimer < TICRATE*2)
		aosp.shieldtime = -aosp.attacktimer
	end

	if(aosp.attacktimer == 1)
		AOSPlaySound(player, sfx_sglzr1)
		
		// Shoot the thing!
		local nnum = 0
		while(nnum < 4)
			getRandomTarget(player, aosp)
			local n2num = 0
			while(n2num < 2)
				local beam = player.aosobjects[createAOSObject(player)]
				beam.type = nuke
				beam.angle = (player.soniguriangle+nukespawnangles[(nnum*2)+n2num])+FixedAngle(180*FRACUNIT)
				local dist = 130
				local basex = aosp.x+(dist*cos(player.soniguriangle))
				local basey = aosp.y+(dist*sin(player.soniguriangle))
				dist = $1 + 40
				beam.x = basex+(dist*cos(beam.angle))
				beam.y = basey+(dist*sin(beam.angle))
				beam.parent = aospn
				beam.target = aosp.target
				beam.angle = (player.soniguriangle+nukespawnangles[n2num])+FixedAngle(180*FRACUNIT)
				beam.timer = (TICRATE*2*nnum)+(TICRATE*2)
				beam.scale = 1
				n2num = $1 + 1
			end
			nnum = $1 + 1
		end
	end
	
	if(aosp.attacktimer > 120)
		aosp.attacktimer = 0
		aosp.currentattack = 21
		aosp.canmove = true
		setPAnim(aosp, 0)
	end
end
local bmt = {}
bmt[0] = 0
bmt[1] = 1
bmt[2] = 1
bmt[3] = 1
bmt[4] = 1
bmt[5] = 0
bmt[6] = 2
bmt[7] = 2
bmt[8] = 0
bmt[9] = 2
local edge2
player.attacks[26] = function(player, aosp, cmd, buttons, aospn)
	aosp.attacktimer = $1 + 1
	
	if(aosp.attacktimer == 1)
		aosp.attackvar = 0
	end
	
	if(aosp.attacktimer >= TICRATE*2)
		and(player.sonigurichaseobj > -1)
		aosp.dashing = 1
		aosp.dashdirection = direction
		aosp.addmomx = 0
		aosp.addmomy = 0
		setPAnim(aosp, 2)
	end
	
	if(aosp.attacktimer == TICRATE*2)
		or(aosp.attacktimer == TICRATE*4)
		or(aosp.attacktimer == TICRATE*6)
		or(aosp.attacktimer == TICRATE*8)
		or(aosp.attacktimer == TICRATE*10)
		or(aosp.attacktimer == TICRATE*12)
		or(aosp.attacktimer == TICRATE*14)
		or(aosp.attacktimer == TICRATE*15)
		or(aosp.attacktimer == TICRATE*16)
		or(aosp.attacktimer == TICRATE*17)
		// Shoot the thing!
		getRandomTarget(player, aosp)
		local bnum = createAOSObject(player)
		local beam = player.aosobjects[bnum]
		beam.type = edge2
		beam.x = -200*FRACUNIT
		if(aosp.attackvar & 1)
			beam.x = -$1
		end
		beam.y = (-130*FRACUNIT)+(130*FRACUNIT*bmt[aosp.attackvar])
		beam.angle = R_PointToAngle2(beam.x, beam.y, player.aosplayers[aosp.target].x, player.aosplayers[aosp.target].y)
		beam.parent = aospn
		beam.target = aosp.target
		beam.timer = TICRATE*3
		beam.alttimer = TICRATE*5/2
		aosp.attackvar = $1 + 1
	end
	
	if(aosp.attacktimer > TICRATE*20)
		local pnum = 0
		while(pnum < 32)
			if(player.aosplayers[pnum].exists)
				player.aosplayers[pnum].target = 32
				S_StartSound(nil, sfx_sgtarg, players[player.clients[pnum]])
			end
			pnum = $1 + 1
		end
		aosp.attacktimer = 0
		aosp.currentattack = 21
		aosp.canmove = true
		setPAnim(aosp, 0)
	end
end

AOS_AddPlayer(player)

local frames = {}
frames[0] = {}
frames[0].rotatenum = 1
frames[0].frames = {}
frames[0].frames[0] = "SNIGBEM1"
frames[1] = {}
frames[1].rotatenum = 1
frames[1].frames = {}
frames[1].frames[0] = "SNIGBEM2"
frames[2] = {}
frames[2].rotatenum = 1
frames[2].frames = {}
frames[2].frames[0] = "SNIGBALL"
frames[3] = {}
frames[3].rotatenum = 24
frames[3].frames = {}
frames[3].frames[0] = "RCKT1_A"
frames[3].frames[1] = "RCKT1_B"
frames[3].frames[2] = "RCKT1_C"
frames[3].frames[3] = "RCKT1_D"
frames[3].frames[4] = "RCKT1_E"
frames[3].frames[5] = "RCKT1_F"
frames[3].frames[6] = "RCKT1_G"
frames[3].frames[7] = "RCKT1_G"
frames[3].frames[8] = "RCKT1_G"
frames[3].frames[9] = "RCKT1_G"
frames[3].frames[10] = "RCKT1_G"
frames[3].frames[11] = "RCKT1_G"
frames[3].frames[12] = "RCKT1_G"
frames[3].frames[13] = "RCKT1_S"
frames[3].frames[14] = "RCKT1_S"
frames[3].frames[15] = "RCKT1_S"
frames[3].frames[16] = "RCKT1_S"
frames[3].frames[17] = "RCKT1_S"
frames[3].frames[18] = "RCKT1_S"
frames[3].frames[19] = "RCKT1_T"
frames[3].frames[20] = "RCKT1_U"
frames[3].frames[21] = "RCKT1_V"
frames[3].frames[22] = "RCKT1_W"
frames[3].frames[23] = "RCKT1_X"
frames[4] = {}
frames[4].rotatenum = 24
frames[4].frames = {}
frames[4].frames[0] = "RCKT2_A"
frames[4].frames[1] = "RCKT2_B"
frames[4].frames[2] = "RCKT2_C"
frames[4].frames[3] = "RCKT2_D"
frames[4].frames[4] = "RCKT2_E"
frames[4].frames[5] = "RCKT2_F"
frames[4].frames[6] = "RCKT2_G"
frames[4].frames[7] = "RCKT2_G"
frames[4].frames[8] = "RCKT2_G"
frames[4].frames[9] = "RCKT2_G"
frames[4].frames[10] = "RCKT2_G"
frames[4].frames[11] = "RCKT2_G"
frames[4].frames[12] = "RCKT2_G"
frames[4].frames[13] = "RCKT2_S"
frames[4].frames[14] = "RCKT2_S"
frames[4].frames[15] = "RCKT2_S"
frames[4].frames[16] = "RCKT2_S"
frames[4].frames[17] = "RCKT2_S"
frames[4].frames[18] = "RCKT2_S"
frames[4].frames[19] = "RCKT2_T"
frames[4].frames[20] = "RCKT2_U"
frames[4].frames[21] = "RCKT2_V"
frames[4].frames[22] = "RCKT2_W"
frames[4].frames[23] = "RCKT2_X"
frames[5] = {}
frames[5].rotatenum = 1
frames[5].frames = {}
frames[5].frames[0] = "SNIGBEM3"
frames[6] = {}
frames[6].rotatenum = 1
frames[6].frames = {}
frames[6].frames[0] = "SNIGBEM4"
frames[7] = {}
frames[7].rotatenum = 24
frames[7].frames = {}
frames[7].frames[0] = "SNGBL1_A"
frames[7].frames[1] = "SNGBL1_B"
frames[7].frames[2] = "SNGBL1_C"
frames[7].frames[3] = "SNGBL1_D"
frames[7].frames[4] = "SNGBL1_E"
frames[7].frames[5] = "SNGBL1_F"
frames[7].frames[6] = "SNGBL1_G"
frames[7].frames[7] = "SNGBL1_H"
frames[7].frames[8] = "SNGBL1_I"
frames[7].frames[9] = "SNGBL1_J"
frames[7].frames[10] = "SNGBL1_K"
frames[7].frames[11] = "SNGBL1_L"
frames[7].frames[12] = "SNGBL1_A"
frames[7].frames[13] = "SNGBL1_B"
frames[7].frames[14] = "SNGBL1_C"
frames[7].frames[15] = "SNGBL1_D"
frames[7].frames[16] = "SNGBL1_E"
frames[7].frames[17] = "SNGBL1_F"
frames[7].frames[18] = "SNGBL1_G"
frames[7].frames[19] = "SNGBL1_H"
frames[7].frames[20] = "SNGBL1_I"
frames[7].frames[21] = "SNGBL1_J"
frames[7].frames[22] = "SNGBL1_K"
frames[7].frames[23] = "SNGBL1_L"
frames[8] = {}
frames[8].rotatenum = 24
frames[8].frames = {}
frames[8].frames[0] = "SNGBL2_A"
frames[8].frames[1] = "SNGBL2_B"
frames[8].frames[2] = "SNGBL2_C"
frames[8].frames[3] = "SNGBL2_D"
frames[8].frames[4] = "SNGBL2_E"
frames[8].frames[5] = "SNGBL2_F"
frames[8].frames[6] = "SNGBL2_G"
frames[8].frames[7] = "SNGBL2_H"
frames[8].frames[8] = "SNGBL2_I"
frames[8].frames[9] = "SNGBL2_J"
frames[8].frames[10] = "SNGBL2_K"
frames[8].frames[11] = "SNGBL2_L"
frames[8].frames[12] = "SNGBL2_A"
frames[8].frames[13] = "SNGBL2_B"
frames[8].frames[14] = "SNGBL2_C"
frames[8].frames[15] = "SNGBL2_D"
frames[8].frames[16] = "SNGBL2_E"
frames[8].frames[17] = "SNGBL2_F"
frames[8].frames[18] = "SNGBL2_G"
frames[8].frames[19] = "SNGBL2_H"
frames[8].frames[20] = "SNGBL2_I"
frames[8].frames[21] = "SNGBL2_J"
frames[8].frames[22] = "SNGBL2_K"
frames[8].frames[23] = "SNGBL2_L"
frames[9] = {}
frames[9].rotatenum = 24
frames[9].frames = {}
frames[9].frames[0] = "BEAMB_A"
frames[9].frames[1] = "BEAMB_B"
frames[9].frames[2] = "BEAMB_C"
frames[9].frames[3] = "BEAMB_D"
frames[9].frames[4] = "BEAMB_E"
frames[9].frames[5] = "BEAMB_F"
frames[9].frames[6] = "BEAMB_G"
frames[9].frames[7] = "BEAMB_G"
frames[9].frames[8] = "BEAMB_G"
frames[9].frames[9] = "BEAMB_G"
frames[9].frames[10] = "BEAMB_G"
frames[9].frames[11] = "BEAMB_G"
frames[9].frames[12] = "BEAMB_G"
frames[9].frames[13] = "BEAMB_S"
frames[9].frames[14] = "BEAMB_S"
frames[9].frames[15] = "BEAMB_S"
frames[9].frames[16] = "BEAMB_S"
frames[9].frames[17] = "BEAMB_S"
frames[9].frames[18] = "BEAMB_S"
frames[9].frames[19] = "BEAMB_T"
frames[9].frames[20] = "BEAMB_U"
frames[9].frames[21] = "BEAMB_V"
frames[9].frames[22] = "BEAMB_W"
frames[9].frames[23] = "BEAMB_X"
frames[10] = {}
frames[10].rotatenum = 1
frames[10].frames = {}
frames[10].frames[0] = "SNIGBALP"
frames[11] = {}
frames[11].rotatenum = 24
frames[11].frames = {}
frames[11].frames[0] = "SNGH1_A"
frames[11].frames[1] = "SNGH1_B"
frames[11].frames[2] = "SNGH1_C"
frames[11].frames[3] = "SNGH1_D"
frames[11].frames[4] = "SNGH1_E"
frames[11].frames[5] = "SNGH1_F"
frames[11].frames[6] = "SNGH1_G"
frames[11].frames[7] = "SNGH1_G"
frames[11].frames[8] = "SNGH1_G"
frames[11].frames[9] = "SNGH1_G"
frames[11].frames[10] = "SNGH1_G"
frames[11].frames[11] = "SNGH1_G"
frames[11].frames[12] = "SNGH1_G"
frames[11].frames[13] = "SNGH1_S"
frames[11].frames[14] = "SNGH1_S"
frames[11].frames[15] = "SNGH1_S"
frames[11].frames[16] = "SNGH1_S"
frames[11].frames[17] = "SNGH1_S"
frames[11].frames[18] = "SNGH1_S"
frames[11].frames[19] = "SNGH1_T"
frames[11].frames[20] = "SNGH1_U"
frames[11].frames[21] = "SNGH1_V"
frames[11].frames[22] = "SNGH1_W"
frames[11].frames[23] = "SNGH1_X"
frames[12] = {}
frames[12].rotatenum = 24
frames[12].frames = {}
frames[12].frames[0] = "SNGH2_A"
frames[12].frames[1] = "SNGH2_B"
frames[12].frames[2] = "SNGH2_C"
frames[12].frames[3] = "SNGH2_D"
frames[12].frames[4] = "SNGH2_E"
frames[12].frames[5] = "SNGH2_F"
frames[12].frames[6] = "SNGH2_G"
frames[12].frames[7] = "SNGH2_G"
frames[12].frames[8] = "SNGH2_G"
frames[12].frames[9] = "SNGH2_G"
frames[12].frames[10] = "SNGH2_G"
frames[12].frames[11] = "SNGH2_G"
frames[12].frames[12] = "SNGH2_G"
frames[12].frames[13] = "SNGH2_S"
frames[12].frames[14] = "SNGH2_S"
frames[12].frames[15] = "SNGH2_S"
frames[12].frames[16] = "SNGH2_S"
frames[12].frames[17] = "SNGH2_S"
frames[12].frames[18] = "SNGH2_S"
frames[12].frames[19] = "SNGH2_T"
frames[12].frames[20] = "SNGH2_U"
frames[12].frames[21] = "SNGH2_V"
frames[12].frames[22] = "SNGH2_W"
frames[12].frames[23] = "SNGH2_X"
frames[13] = {}
frames[13].rotatenum = 24
frames[13].frames = {}
frames[13].frames[0] = "EDGE_A"
frames[13].frames[1] = "EDGE_B"
frames[13].frames[2] = "EDGE_C"
frames[13].frames[3] = "EDGE_D"
frames[13].frames[4] = "EDGE_E"
frames[13].frames[5] = "EDGE_F"
frames[13].frames[6] = "EDGE_G"
frames[13].frames[7] = "EDGE_G"
frames[13].frames[8] = "EDGE_G"
frames[13].frames[9] = "EDGE_G"
frames[13].frames[10] = "EDGE_G"
frames[13].frames[11] = "EDGE_G"
frames[13].frames[12] = "EDGE_G"
frames[13].frames[13] = "EDGE_S"
frames[13].frames[14] = "EDGE_S"
frames[13].frames[15] = "EDGE_S"
frames[13].frames[16] = "EDGE_S"
frames[13].frames[17] = "EDGE_S"
frames[13].frames[18] = "EDGE_S"
frames[13].frames[19] = "EDGE_T"
frames[13].frames[20] = "EDGE_U"
frames[13].frames[21] = "EDGE_V"
frames[13].frames[22] = "EDGE_W"
frames[13].frames[23] = "EDGE_X"
frames[14] = {}
frames[14].rotatenum = 1
frames[14].frames = {}
frames[14].frames[0] = "EXPLOSON"
frames[15] = {}
frames[15].rotatenum = 1
frames[15].frames = {}
frames[15].frames[0] = "EXPROSON"
frames[16] = {}
frames[16].rotatenum = 1
frames[16].frames = {}
frames[16].frames[0] = "EXPUOSON"

frames[17] = {}
frames[17].rotatenum = 1
frames[17].frames = {}
frames[17].frames[0] = "LBALLB"
frames[18] = {}
frames[18].rotatenum = 1
frames[18].frames = {}
frames[18].frames[0] = "LBALLR"
frames[19] = {}
frames[19].rotatenum = 1
frames[19].frames = {}
frames[19].frames[0] = "LBALLP"
frames[20] = {}
frames[20].rotatenum = 1
frames[20].frames = {}
frames[20].frames[0] = "LBALLC"
frames[21] = {}
frames[21].rotatenum = 1
frames[21].frames = {}
frames[21].frames[0] = "LBALLG"
frames[22] = {}
frames[22].rotatenum = 1
frames[22].frames = {}
frames[22].frames[0] = "LBALLS"
frames[23] = {}
frames[23].rotatenum = 1
frames[23].frames = {}
frames[23].frames[0] = "LBALLT"
frames[24] = {}
frames[24].rotatenum = 1
frames[24].frames = {}
frames[24].frames[0] = "LBALLO"

frames[25] = {}
frames[25].rotatenum = 1
frames[25].frames = {}
frames[25].frames[0] = "EXPBOSON"
frames[26] = {}
frames[26].rotatenum = 1
frames[26].frames = {}
frames[26].frames[0] = "EXPCOSON"
frames[27] = {}
frames[27].rotatenum = 24
frames[27].frames = {}
frames[27].frames[0] = "BEAMV_A"
frames[27].frames[1] = "BEAMV_B"
frames[27].frames[2] = "BEAMV_C"
frames[27].frames[3] = "BEAMV_D"
frames[27].frames[4] = "BEAMV_E"
frames[27].frames[5] = "BEAMV_F"
frames[27].frames[6] = "BEAMV_G"
frames[27].frames[7] = "BEAMV_G"
frames[27].frames[8] = "BEAMV_G"
frames[27].frames[9] = "BEAMV_G"
frames[27].frames[10] = "BEAMV_G"
frames[27].frames[11] = "BEAMV_G"
frames[27].frames[12] = "BEAMV_G"
frames[27].frames[13] = "BEAMV_S"
frames[27].frames[14] = "BEAMV_S"
frames[27].frames[15] = "BEAMV_S"
frames[27].frames[16] = "BEAMV_S"
frames[27].frames[17] = "BEAMV_S"
frames[27].frames[18] = "BEAMV_S"
frames[27].frames[19] = "BEAMV_T"
frames[27].frames[20] = "BEAMV_U"
frames[27].frames[21] = "BEAMV_V"
frames[27].frames[22] = "BEAMV_W"
frames[27].frames[23] = "BEAMV_X"
frames[28] = {}
frames[28].rotatenum = 24
frames[28].frames = {}
frames[28].frames[0] = "SNGG1_A"
frames[28].frames[1] = "SNGG1_B"
frames[28].frames[2] = "SNGG1_C"
frames[28].frames[3] = "SNGG1_D"
frames[28].frames[4] = "SNGG1_E"
frames[28].frames[5] = "SNGG1_F"
frames[28].frames[6] = "SNGG1_G"
frames[28].frames[7] = "SNGG1_G"
frames[28].frames[8] = "SNGG1_G"
frames[28].frames[9] = "SNGG1_G"
frames[28].frames[10] = "SNGG1_G"
frames[28].frames[11] = "SNGG1_G"
frames[28].frames[12] = "SNGG1_G"
frames[28].frames[13] = "SNGG1_S"
frames[28].frames[14] = "SNGG1_S"
frames[28].frames[15] = "SNGG1_S"
frames[28].frames[16] = "SNGG1_S"
frames[28].frames[17] = "SNGG1_S"
frames[28].frames[18] = "SNGG1_S"
frames[28].frames[19] = "SNGG1_T"
frames[28].frames[20] = "SNGG1_U"
frames[28].frames[21] = "SNGG1_V"
frames[28].frames[22] = "SNGG1_W"
frames[28].frames[23] = "SNGG1_X"
frames[29] = {}
frames[29].rotatenum = 24
frames[29].frames = {}
frames[29].frames[0] = "SNGG2_A"
frames[29].frames[1] = "SNGG2_B"
frames[29].frames[2] = "SNGG2_C"
frames[29].frames[3] = "SNGG2_D"
frames[29].frames[4] = "SNGG2_E"
frames[29].frames[5] = "SNGG2_F"
frames[29].frames[6] = "SNGG2_G"
frames[29].frames[7] = "SNGG2_G"
frames[29].frames[8] = "SNGG2_G"
frames[29].frames[9] = "SNGG2_G"
frames[29].frames[10] = "SNGG2_G"
frames[29].frames[11] = "SNGG2_G"
frames[29].frames[12] = "SNGG2_G"
frames[29].frames[13] = "SNGG2_S"
frames[29].frames[14] = "SNGG2_S"
frames[29].frames[15] = "SNGG2_S"
frames[29].frames[16] = "SNGG2_S"
frames[29].frames[17] = "SNGG2_S"
frames[29].frames[18] = "SNGG2_S"
frames[29].frames[19] = "SNGG2_T"
frames[29].frames[20] = "SNGG2_U"
frames[29].frames[21] = "SNGG2_V"
frames[29].frames[22] = "SNGG2_W"
frames[29].frames[23] = "SNGG2_X"
frames[30] = {}
frames[30].rotatenum = 24
frames[30].frames = {}
frames[30].frames[0] = "SNSHT_A"
frames[30].frames[1] = "SNSHT_B"
frames[30].frames[2] = "SNSHT_C"
frames[30].frames[3] = "SNSHT_D"
frames[30].frames[4] = "SNSHT_E"
frames[30].frames[5] = "SNSHT_F"
frames[30].frames[6] = "SNSHT_G"
frames[30].frames[7] = "SNSHT_G"
frames[30].frames[8] = "SNSHT_G"
frames[30].frames[9] = "SNSHT_G"
frames[30].frames[10] = "SNSHT_G"
frames[30].frames[11] = "SNSHT_G"
frames[30].frames[12] = "SNSHT_G"
frames[30].frames[13] = "SNSHT_S"
frames[30].frames[14] = "SNSHT_S"
frames[30].frames[15] = "SNSHT_S"
frames[30].frames[16] = "SNSHT_S"
frames[30].frames[17] = "SNSHT_S"
frames[30].frames[18] = "SNSHT_S"
frames[30].frames[19] = "SNSHT_T"
frames[30].frames[20] = "SNSHT_U"
frames[30].frames[21] = "SNSHT_V"
frames[30].frames[22] = "SNSHT_W"
frames[30].frames[23] = "SNSHT_X"

local beam1frame1 = AOS_AddFrame(frames[0])
local beam1frame2 = AOS_AddFrame(frames[1])
local blueballframe = AOS_AddFrame(frames[2])
local rocketframe1 = AOS_AddFrame(frames[3])
local rocketframe2 = AOS_AddFrame(frames[4])
local beam2frame1 = AOS_AddFrame(frames[5])
local beam2frame2 = AOS_AddFrame(frames[6])
local longbeamframe1 = AOS_AddFrame(frames[7])
local longbeamframe2 = AOS_AddFrame(frames[8])
local bluebeamframe = AOS_AddFrame(frames[9])
local purpleballframe = AOS_AddFrame(frames[10])
local hyperframe1 = AOS_AddFrame(frames[11])
local hyperframe2 = AOS_AddFrame(frames[12])
local edgeframe = AOS_AddFrame(frames[13])
local explosionframe1 = AOS_AddFrame(frames[14])
local explosionframe2 = AOS_AddFrame(frames[15])
local explosionframe3 = AOS_AddFrame(frames[16])

local lightballblueframe = AOS_AddFrame(frames[17])
local lightballredframe = AOS_AddFrame(frames[18])
local lightballpurpleframe = AOS_AddFrame(frames[19])
local lightballcyanframe = AOS_AddFrame(frames[20])
local lightballgreenframe = AOS_AddFrame(frames[21])
local lightballsteelframe = AOS_AddFrame(frames[22])
local lightballtanframe = AOS_AddFrame(frames[23])
local lightballorangeframe = AOS_AddFrame(frames[24])

local laserexplodeframe1 = AOS_AddFrame(frames[25])
local laserexplodeframe2 = AOS_AddFrame(frames[26])
local beamtrail = AOS_AddFrame(frames[27])
local hyperglowframe1 = AOS_AddFrame(frames[28])
local hyperglowframe2 = AOS_AddFrame(frames[29])
local beamshootframe = AOS_AddFrame(frames[30])

local animations = {}
animations[0] = {}
animations[0].speed = 1
animations[0].numframes = 1
animations[0].nextanim = 0
animations[0].frames = {}
animations[0].frames[0] = beam1frame1
animations[1] = {}
animations[1].speed = 1
animations[1].numframes = 1
animations[1].nextanim = 0
animations[1].frames = {}
animations[1].frames[0] = beam1frame2
animations[2] = {}
animations[2].speed = 1
animations[2].numframes = 1
animations[2].nextanim = 0
animations[2].frames = {}
animations[2].frames[0] = beam2frame1
animations[3] = {}
animations[3].speed = 2
animations[3].numframes = 2
animations[3].nextanim = 0
animations[3].frames = {}
animations[3].frames[0] = rocketframe1
animations[3].frames[1] = rocketframe2
animations[4] = {}
animations[4].speed = 1
animations[4].numframes = 1
animations[4].nextanim = 0
animations[4].frames = {}
animations[4].frames[0] = beam2frame2
animations[5] = {}
animations[5].speed = 1
animations[5].numframes = 1
animations[5].nextanim = 0
animations[5].frames = {}
animations[5].frames[0] = blueballframe
animations[6] = {}
animations[6].speed = 1
animations[6].numframes = 1
animations[6].nextanim = 0
animations[6].frames = {}
animations[6].frames[0] = longbeamframe1
animations[7] = {}
animations[7].speed = 1
animations[7].numframes = 1
animations[7].nextanim = 0
animations[7].frames = {}
animations[7].frames[0] = longbeamframe2
animations[8] = {}
animations[8].speed = 1
animations[8].numframes = 1
animations[8].nextanim = 0
animations[8].frames = {}
animations[8].frames[0] = bluebeamframe
animations[9] = {}
animations[9].speed = 1
animations[9].numframes = 1
animations[9].nextanim = 0
animations[9].frames = {}
animations[9].frames[0] = purpleballframe
animations[10] = {}
animations[10].speed = 2
animations[10].numframes = 2
animations[10].nextanim = 0
animations[10].frames = {}
animations[10].frames[0] = hyperframe1
animations[10].frames[1] = hyperframe2
animations[11] = {}
animations[11].speed = 1
animations[11].numframes = 1
animations[11].nextanim = 0
animations[11].frames = {}
animations[11].frames[0] = edgeframe
animations[12] = {}
animations[12].speed = 0
animations[12].numframes = 2
animations[12].nextanim = 0
animations[12].frames = {}
animations[12].frames[0] = explosionframe1
animations[12].frames[1] = explosionframe2
animations[13] = {}
animations[13].speed = 0
animations[13].numframes = 2
animations[13].nextanim = 0
animations[13].frames = {}
animations[13].frames[0] = explosionframe1
animations[13].frames[1] = explosionframe3

animations[14] = {}
animations[14].speed = 0
animations[14].numframes = 1
animations[14].nextanim = 0
animations[14].frames = {}
animations[14].frames[0] = lightballblueframe
animations[15] = {}
animations[15].speed = 0
animations[15].numframes = 1
animations[15].nextanim = 0
animations[15].frames = {}
animations[15].frames[0] = lightballredframe
animations[16] = {}
animations[16].speed = 0
animations[16].numframes = 1
animations[16].nextanim = 0
animations[16].frames = {}
animations[16].frames[0] = lightballpurpleframe
animations[17] = {}
animations[17].speed = 0
animations[17].numframes = 1
animations[17].nextanim = 0
animations[17].frames = {}
animations[17].frames[0] = lightballcyanframe
animations[18] = {}
animations[18].speed = 0
animations[18].numframes = 1
animations[18].nextanim = 0
animations[18].frames = {}
animations[18].frames[0] = lightballgreenframe
animations[19] = {}
animations[19].speed = 0
animations[19].numframes = 1
animations[19].nextanim = 0
animations[19].frames = {}
animations[19].frames[0] = lightballsteelframe
animations[20] = {}
animations[20].speed = 0
animations[20].numframes = 1
animations[20].nextanim = 0
animations[20].frames = {}
animations[20].frames[0] = lightballtanframe
animations[21] = {}
animations[21].speed = 0
animations[21].numframes = 1
animations[21].nextanim = 0
animations[21].frames = {}
animations[21].frames[0] = lightballorangeframe

animations[22] = {}
animations[22].speed = 0
animations[22].numframes = 2
animations[22].nextanim = 0
animations[22].frames = {}
animations[22].frames[0] = laserexplodeframe1
animations[22].frames[1] = laserexplodeframe2
animations[23] = {}
animations[23].speed = 1
animations[23].numframes = 1
animations[23].nextanim = 0
animations[23].frames = {}
animations[23].frames[0] = beamtrail
animations[24] = {}
animations[24].speed = 2
animations[24].numframes = 2
animations[24].nextanim = 0
animations[24].frames = {}
animations[24].frames[0] = hyperglowframe1
animations[24].frames[1] = hyperglowframe2
animations[25] = {}
animations[25].speed = 1
animations[25].numframes = 1
animations[25].nextanim = 0
animations[25].frames = {}
animations[25].frames[0] = beamshootframe

local beam1anim1 = AOS_AddAnim(animations[0])
local beam1anim2 = AOS_AddAnim(animations[1])
local beam2anim1 = AOS_AddAnim(animations[2])
local missileanim = AOS_AddAnim(animations[3])
local beam2anim2 = AOS_AddAnim(animations[4])
local blueballanim = AOS_AddAnim(animations[5])
local longbeamanim1 = AOS_AddAnim(animations[6])
local longbeamanim2 = AOS_AddAnim(animations[7])
local bluebeamanim = AOS_AddAnim(animations[8])
local purpleballanim = AOS_AddAnim(animations[9])
local hyperanim = AOS_AddAnim(animations[10])
local edgeanim = AOS_AddAnim(animations[11])
local explosionanim = AOS_AddAnim(animations[12])
local explosionanim2 = AOS_AddAnim(animations[13])

local lightballblueanim = AOS_AddAnim(animations[14])
local lightballredanim = AOS_AddAnim(animations[15])
local lightballpurpleanim = AOS_AddAnim(animations[16])
local lightballcyananim = AOS_AddAnim(animations[17])
local lightballgreenanim = AOS_AddAnim(animations[18])
local lightballsteelanim = AOS_AddAnim(animations[19])
local lightballtananim = AOS_AddAnim(animations[20])
local lightballorangeanim = AOS_AddAnim(animations[21])

local laserexplodeanim = AOS_AddAnim(animations[22])
local beamtrailanim = AOS_AddAnim(animations[23])
local hyperglowanim = AOS_AddAnim(animations[24])
local beamshootanim = AOS_AddAnim(animations[25])
animations[0].nextanim = beam1anim1
animations[1].nextanim = beam1anim2
animations[2].nextanim = beam2anim1
animations[3].nextanim = missileanim
animations[4].nextanim = beam2anim2
animations[5].nextanim = blueballanim
animations[6].nextanim = longbeamanim1
animations[7].nextanim = longbeamanim2
animations[8].nextanim = bluebeamanim
animations[9].nextanim = purpleballanim
animations[10].nextanim = hyperanim
animations[11].nextanim = edgeanim
animations[12].nextanim = explosionanim
animations[13].nextanim = explosionanim2

animations[14].nextanim = lightballblueanim
animations[15].nextanim = lightballredanim
animations[16].nextanim = lightballpurpleanim
animations[17].nextanim = lightballcyananim
animations[18].nextanim = lightballgreenanim
animations[19].nextanim = lightballsteelanim
animations[20].nextanim = lightballtananim
animations[21].nextanim = lightballorangeanim

animations[22].nextanim = laserexplodeanim
animations[23].nextanim = beamtrailanim
animations[24].nextanim = hyperglowanim
animations[25].nextanim = beamshootanim

local laserexplode
local objects = {}
objects[0] = {}
objects[0].thinker = function(player, objectnum)
	local object = player.aosobjects[objectnum]
	object.scale = 3*FRACUNIT
	object.subscale = 3*FRACUNIT
	object.width = 9*FRACUNIT/2
	object.height = 9*FRACUNIT/2
	object.hassub = true
	
	setAnim(object, beam1anim1)
	setSubAnim(object, beam1anim2)
	
	// Transparancy
	object.subdrawflags = V_50TRANS
	
	if not(object.alttimer)	// We weren't spawned
		object.canbegrazed = true
		
		if(object.timer < TICRATE)
			// Chase the target!
			local dirtochase = R_PointToAngle2(object.x, object.y, player.aosplayers[object.target].x, player.aosplayers[object.target].y)
			if(AngleFixed(dirtochase-object.angle) < FRACUNIT*7)
				object.angle = dirtochase
			else
				local addmul = 1
				if(abs((AngleFixed(dirtochase)%(360*FRACUNIT))-(AngleFixed(object.angle)%(360*FRACUNIT))) > 180*FRACUNIT)
					addmul = -1
				end
				
				if(AngleFixed(dirtochase)%(360*FRACUNIT) > AngleFixed(object.angle)%(360*FRACUNIT))
					object.angle = $1 + (FixedAngle(FRACUNIT*7)*addmul)
				else
					object.angle = $1 - (FixedAngle(FRACUNIT*7)*addmul)
				end
			end
			// Hacky fix for overshooting our desired angle
			if(AngleFixed(dirtochase-object.angle) < FRACUNIT*7)
				object.angle = dirtochase
			end
		end
		
		object.momx = FixedMul(cos(object.angle), 5*FRACUNIT)
		object.momy = FixedMul(sin(object.angle), 5*FRACUNIT)
		
		// Spawn more!
		// Shoot the thing!
		local bnum = createAOSObject(player)
		local beam = player.aosobjects[bnum]
		beam.type = bluebeam
		beam.momx = 0
		beam.momy = 0
		beam.x = object.x
		beam.y = object.y
		beam.alttimer = objectnum+1
		beam.subx = beam.x
		beam.suby = beam.y
		beam.subdrawflags = V_50TRANS
		setAnim(beam, beam1anim1)
		setSubAnim(beam, beam1anim2)
		beam.hassub = true
		beam.timer = TICRATE*3/2
		beam.parent = object.parent
		
		if(bnum < objectnum)
			AOSObjectThinker(player, bnum)
		end
		
	elseif(object.timer > TICRATE*2)
		removeAOSObject(player, objectnum)
		return
	end
	
	object.timer = $1 + 1
	
	local angle = R_PointToAngle2(0, 0, object.x, object.y)
	if(R_PointToDist2(0, 0, object.x, object.y) > player.arenaradius)
		and not(AOSDotProduct(cos(angle), sin(angle), cos(object.angle), sin(object.angle)) < 0)
		and not((R_PointToDist2(0, 0, object.x-object.momx, object.y-object.momy) > player.arenaradius) and not(R_PointToDist2(0, 0, object.x, object.y) > player.arenaradius*3/2))
//		AOSPlaySound(player, sfx_sgbom1)

		local beam = player.aosobjects[createAOSObject(player)]
		beam.type = laserexplode
		beam.x = object.x
		beam.y = object.y
		beam.parent = object.parent

		removeAOSObject(player, objectnum)
		return
	end
	
	object.subx = object.x+object.momx
	object.suby = object.y+object.momy
	
	if(object.subangle)
		object.subangle = $1 - 1
	end
end
objects[0].playercollide = function(player, objectnum, aospn)
//	local timer = player.aosobjects[objectnum].subangle
//	if(player.aosobjects[objectnum].alttimer)
//		timer = player.aosobjects[player.aosobjects[objectnum].alttimer-1].subangle
//	end
	if(aospn == player.aosobjects[objectnum].parent)
		or(AOSPlayerCanGraze(player.aosplayers[aospn]))
//		or(timer)
		return
	end
	AOSHurtPlayer(player, aospn, player.aosobjects[objectnum].parent, 180, true, player.aosobjects[objectnum].x, player.aosobjects[objectnum].y)
//	if(player.aosobjects[objectnum].alttimer)
//		player.aosobjects[player.aosobjects[objectnum].alttimer-1].subangle = TICRATE/3
//	else
//		player.aosobjects[objectnum].subangle = TICRATE/3
//	end
end
objects[2] = {}
objects[2].thinker = function(player, objectnum)
	local object = player.aosobjects[objectnum]
	object.scale = 4*FRACUNIT
	object.width = 8*FRACUNIT
	object.height = 8*FRACUNIT
	
	object.canbegrazed = true
	
	setAnim(object, blueballanim)
	
	if not(object.timer)
		object.alttimer = 3*FRACUNIT
	elseif(object.alttimer)
		object.alttimer = $1 - FRACUNIT/10
		if(object.alttimer < 0)
			object.alttimer = 0
		end
	end
	
	// Transparancy
	object.drawflags = V_20TRANS
	
	object.angle = $1 - FixedAngle(5*FRACUNIT)
	object.momx = FixedMul(cos(object.angle), object.alttimer)
	object.momy = FixedMul(sin(object.angle), object.alttimer)
	
	object.timer = $1 + 1
	if(object.timer > TICRATE*2)
		// Shoot the thing!
		local beam = player.aosobjects[createAOSObject(player)]
		beam.type = bluebeam
		beam.x = object.x
		beam.y = object.y
		beam.parent = object.parent
		beam.target = object.target
		beam.angle = object.angle+ANGLE_180
		AOSPlaySound(player, sfx_sglzr2)
		removeAOSObject(player, objectnum)
		return
	end
end
objects[2].playercollide = function(player, objectnum, aospn)
	if(aospn == player.aosobjects[objectnum].parent)
		or(AOSPlayerCanGraze(player.aosplayers[aospn]))
		return
	end
	AOSHurtPlayer(player, aospn, player.aosobjects[objectnum].parent, 180, true, player.aosobjects[objectnum].x, player.aosobjects[objectnum].y)
	removeAOSObject(player, objectnum)
end
objects[1] = {}
objects[1].thinker = function(player, objectnum)
	local object = player.aosobjects[objectnum]
	object.scale = 3*FRACUNIT
	object.width = 24*FRACUNIT
	object.height = 12*FRACUNIT
	
	object.canbegrazed = true
	
	setAnim(object, missileanim)
	
	if(cos(object.angle) < 0)
		object.drawflags = $1|V_FLIP
	else
		object.drawflags = $1 & !V_FLIP
	end
	
	object.timer = $1 + 1
	
	// Chase the target!
	if(object.timer < TICRATE)
		local dirtochase = R_PointToAngle2(object.x, object.y, player.aosplayers[object.target].x, player.aosplayers[object.target].y)
		if(AngleFixed(dirtochase-object.angle) < FRACUNIT*8)
			object.angle = dirtochase
		else
			local addmul = 1
			if(abs((AngleFixed(dirtochase)%(360*FRACUNIT))-(AngleFixed(object.angle)%(360*FRACUNIT))) > 180*FRACUNIT)
				addmul = -1
			end
			
			if(AngleFixed(dirtochase)%(360*FRACUNIT) > AngleFixed(object.angle)%(360*FRACUNIT))
				object.angle = $1 + (FixedAngle(FRACUNIT*8)*addmul)
			else
				object.angle = $1 - (FixedAngle(FRACUNIT*8)*addmul)
			end
		end
		// Hacky fix for overshooting our desired angle
		if(AngleFixed(dirtochase-object.angle) < FRACUNIT*8)
			object.angle = dirtochase
		end
		
		object.alttimer = 6*FRACUNIT
		object.momx = FixedMul(cos(object.angle), object.alttimer)
		object.momy = FixedMul(sin(object.angle), object.alttimer)
	end
	
	local angle = R_PointToAngle2(0, 0, object.x, object.y)
	if(R_PointToDist2(0, 0, object.x, object.y) > player.arenaradius)
		and not((R_PointToDist2(0, 0, object.x-object.momx, object.y-object.momy) > player.arenaradius) and not(R_PointToDist2(0, 0, object.x, object.y) > player.arenaradius*3/2))
		if(AOSDotProduct(cos(angle), sin(angle), cos(object.angle), sin(object.angle)) < 0)
			object.x = FixedMul(cos(angle), player.arenaradius)
			object.y = FixedMul(sin(angle), player.arenaradius)
		else
			AOSPlaySound(player, sfx_sgbom1)
			removeAOSObject(player, objectnum)
			return
		end
	end
end
objects[1].playercollide = function(player, objectnum, aospn)
	if(aospn == player.aosobjects[objectnum].parent)
		return
	end
	AOSHurtPlayer(player, aospn, player.aosobjects[objectnum].parent, 200, false, player.aosobjects[objectnum].x, player.aosobjects[objectnum].y)
	AOSPlaySound(player, sfx_sgbom1)
	removeAOSObject(player, objectnum)
end
objects[4] = {}
objects[4].thinker = function(player, objectnum)
	local object = player.aosobjects[objectnum]
	object.scale = 3*FRACUNIT
	object.width = 16*FRACUNIT*3/2
	object.height = 5*FRACUNIT*3/2
	
	object.canbegrazed = true
	
	setAnim(object, missileanim)
	
	
	if(cos(object.angle) < 0)
		object.drawflags = $1|V_FLIP
	else
		object.drawflags = $1 & !V_FLIP
	end
	
	// Chase the target!
	local dirtochase = R_PointToAngle2(object.x, object.y, player.aosplayers[object.target].x, player.aosplayers[object.target].y)
	if(AngleFixed(dirtochase-object.angle) < FRACUNIT*2)
		object.angle = dirtochase
	else
		local addmul = 1
		if(abs((AngleFixed(dirtochase)%(360*FRACUNIT))-(AngleFixed(object.angle)%(360*FRACUNIT))) > 180*FRACUNIT)
			addmul = -1
		end
		
		if(AngleFixed(dirtochase)%(360*FRACUNIT) > AngleFixed(object.angle)%(360*FRACUNIT))
			object.angle = $1 + (FixedAngle(FRACUNIT*2)*addmul)
		else
			object.angle = $1 - (FixedAngle(FRACUNIT*2)*addmul)
		end
	end
	// Hacky fix for overshooting our desired angle
	if(AngleFixed(dirtochase-object.angle) < FRACUNIT*2)
		object.angle = dirtochase
	end
	
	if(object.timer)
		object.momx = FixedMul(cos(object.angle), object.timer)
		object.momy = FixedMul(sin(object.angle), object.timer)
		object.timer = $1 + FRACUNIT/5
		if(object.timer > 6*FRACUNIT)
			object.timer = 6*FRACUNIT
		end
	else
		local speed = R_PointToDist2(0, 0, object.momx, object.momy)
		local angle = R_PointToAngle2(0, 0, object.momx, object.momy)
		speed = $1 - FRACUNIT/10
		if(speed <= 0)
			object.momx = 0
			object.momy = 0
			object.alttimer = $1 + 1
			if(object.alttimer > TICRATE/3)
				object.timer = 1
			end
		else
			object.momx = FixedMul(cos(angle), speed)
			object.momy = FixedMul(sin(angle), speed)
		end
	end
	local angle = R_PointToAngle2(0, 0, object.x, object.y)
	if(R_PointToDist2(0, 0, object.x, object.y) > player.arenaradius)
		if(AOSDotProduct(cos(angle), sin(angle), cos(object.angle), sin(object.angle)) < 0)
			object.x = FixedMul(cos(angle), player.arenaradius)
			object.y = FixedMul(sin(angle), player.arenaradius)
		else
			AOSPlaySound(player, sfx_sgbom1)
			removeAOSObject(player, objectnum)
			return
		end
	end
end
objects[4].playercollide = function(player, objectnum, aospn)
	if(aospn == player.aosobjects[objectnum].parent)
		return
	end
	AOSHurtPlayer(player, aospn, player.aosobjects[objectnum].parent, 250, false, player.aosobjects[objectnum].x, player.aosobjects[objectnum].y)
	AOSPlaySound(player, sfx_sgbom1)
	removeAOSObject(player, objectnum)
end
objects[5] = {}
objects[5].thinker = function(player, objectnum)
	local object = player.aosobjects[objectnum]
	object.scale = 3*FRACUNIT
	object.subscale = 3*FRACUNIT
	object.width = 36*FRACUNIT
	object.height = 3*FRACUNIT
	object.hassub = true
	
	object.canbegrazed = true
	
	setAnim(object, longbeamanim1)
	setSubAnim(object, longbeamanim2)
	
	// Transparancy
	object.subdrawflags = V_50TRANS
	
	object.timer = $1 + 1
	if(object.timer > TICRATE*3/2)
		removeAOSObject(player, objectnum)
		return
	end
	
	object.subx = object.x+object.momx
	object.suby = object.y+object.momy
	object.subangle = object.angle
end
objects[5].playercollide = function(player, objectnum, aospn)
	if(aospn == player.aosobjects[objectnum].parent)
		or(AOSPlayerCanGraze(player.aosplayers[aospn]))
		return
	end
	AOSHurtPlayer(player, aospn, player.aosobjects[objectnum].parent, 180, true, player.aosobjects[objectnum].x, player.aosobjects[objectnum].y)
	removeAOSObject(player, objectnum)
end
objects[6] = {}
objects[6].thinker = function(player, objectnum)
	local object = player.aosobjects[objectnum]
	object.scale = 3*FRACUNIT
	
	setAnim(object, beamshootanim)
	
	if(AngleFixed(object.angle) > 90*FRACUNIT and AngleFixed(object.angle) < 270*FRACUNIT)
		object.drawflags = $1|V_FLIP
	end
	
	object.timer = $1 + 1
	if(object.timer == 1)
		or(object.timer == TICRATE/10)
		or(object.timer == TICRATE/5)
		// random angle!
		local rng = A_SeedRng_Get()
		
		// Shoot the thing!
		local beam = player.aosobjects[createAOSObject(player)]
		beam.type = longbeam
		beam.angle = object.angle+FixedAngle(rng.GetKey(player.seedrngstate, 45*FRACUNIT)-(45*FRACUNIT/2))
		beam.x = object.x+FixedMul(cos(beam.angle), 26*FRACUNIT)
		beam.y = object.y+FixedMul(sin(beam.angle), 26*FRACUNIT)
		beam.momx = FixedMul(cos(beam.angle), 7*FRACUNIT)
		beam.momy = FixedMul(sin(beam.angle), 7*FRACUNIT)
		beam.parent = object.parent
		beam.target = object.target
	//	AOSPlaySound(player, sfx_sglzr1)
	end
	
	if(object.timer > TICRATE*2/3)
		removeAOSObject(player, objectnum)
		return
	end
end
objects[7] = {}
objects[7].thinker = function(player, objectnum)
	local object = player.aosobjects[objectnum]
	object.scale = 2*FRACUNIT
	object.subscale = 2*FRACUNIT
	object.width = 12*FRACUNIT
	object.height = 3*FRACUNIT
	object.hassub = true
	
	object.canbegrazed = true
	
	setAnim(object, bluebeamanim)
	setSubAnim(object, beamtrailanim)
	
	if(cos(object.angle) < 0)
		object.drawflags = $1|V_FLIP
	else
		object.drawflags = $1 & !V_FLIP
	end
	
	// Transparancy
	/*local timer2 = object.timer-(TICRATE*3/4)
	if(timer2 < 0)
		timer2 = 0
	end
	object.drawflags = timer2*10/(TICRATE*3/2)
	if(object.drawflags > 9)
		object.drawflags = 9
	end
	object.drawflags = $1 * V_10TRANS
	if not(object.drawflags)
		object.drawflags = V_10TRANS
	end*/
	
	object.subdrawflags = object.drawflags|V_40TRANS
	
	object.subx = object.x+object.momx
	object.suby = object.y+object.momy
	object.subangle = object.angle
	
	object.timer = $1 + 1
	if(object.timer > TICRATE*3/2)
		removeAOSObject(player, objectnum)
		return
	end
end
objects[7].playercollide = function(player, objectnum, aospn)
	if(aospn == player.aosobjects[objectnum].parent)
		or(AOSPlayerCanGraze(player.aosplayers[aospn]))
		return
	end
	AOSHurtPlayer(player, aospn, player.aosobjects[objectnum].parent, 180, true, player.aosobjects[objectnum].x, player.aosobjects[objectnum].y)
	removeAOSObject(player, objectnum)
end
local purplebeam
objects[8] = {}
objects[8].thinker = function(player, objectnum)
	local object = player.aosobjects[objectnum]
	object.scale = 4*FRACUNIT
	object.width = 8*FRACUNIT
	object.height = 8*FRACUNIT
	
	object.canbegrazed = true
	
	setAnim(object, purpleballanim)
	
	if not(object.timer)
		object.alttimer = 3*FRACUNIT
	elseif(object.alttimer)
		object.alttimer = $1 - FRACUNIT/10
		if(object.alttimer < 0)
			object.alttimer = 0
		end
	end
	
	// Transparancy
	object.drawflags = V_20TRANS
	
	object.angle = $1 - FixedAngle(5*FRACUNIT)
	object.momx = FixedMul(cos(object.angle), object.alttimer)
	object.momy = FixedMul(sin(object.angle), object.alttimer)
	
	object.timer = $1 + 1
	if(object.timer > TICRATE*2)
		// Shoot the thing!
		local bnum = 0
		while(bnum < 10)
			local beam = player.aosobjects[createAOSObject(player)]
			beam.type = purplebeam
			beam.x = object.x
			beam.y = object.y
			beam.momx = 3*cos(object.angle+FixedAngle(360*FRACUNIT/10*bnum))/2
			beam.momy = 3*sin(object.angle+FixedAngle(360*FRACUNIT/10*bnum))/2
			beam.parent = object.parent
			beam.target = object.target
			bnum = $1 + 1
		end
		AOSPlaySound(player, sfx_sglzr2)
		removeAOSObject(player, objectnum)
		return
	end
end
objects[8].playercollide = function(player, objectnum, aospn)
	if(aospn == player.aosobjects[objectnum].parent)
		or(AOSPlayerCanGraze(player.aosplayers[aospn]))
		return
	end
	AOSHurtPlayer(player, aospn, player.aosobjects[objectnum].parent, 180, true, player.aosobjects[objectnum].x, player.aosobjects[objectnum].y)
	removeAOSObject(player, objectnum)
end
objects[9] = {}
objects[9].thinker = function(player, objectnum)
	local object = player.aosobjects[objectnum]
	object.scale = 3*FRACUNIT
	object.subscale = 3*FRACUNIT
	object.width = 9*FRACUNIT/2
	object.height = 9*FRACUNIT/2
	object.hassub = true
	
	object.canbegrazed = true
	
	setAnim(object, beam2anim1)
	setSubAnim(object, beam2anim2)
	
	// Transparancy
	object.subdrawflags = V_50TRANS
	
	local offscreen = true
	if(object.x < 160*FRACUNIT)
		and(object.x > -160*FRACUNIT)
		and(object.y < 100*FRACUNIT)
		and(object.y > -100*FRACUNIT)
		offscreen = false
	end
	if(R_PointToDist2(0, 0, object.x, object.y) <= player.arenaradius)
		and not(player.aosplayers[32].currentattack == 27)
		offscreen = false
	end
	if(object.timer > TICRATE*15 or (player.aosplayers[32].currentattack == 27))
		and(offscreen)
		removeAOSObject(player, objectnum)
		return
	end
	
	object.timer = $1 + 1
	
	object.subx = object.x+object.momx
	object.suby = object.y+object.momy
end
objects[9].playercollide = function(player, objectnum, aospn)
	if(aospn == player.aosobjects[objectnum].parent)
		or(AOSPlayerCanGraze(player.aosplayers[aospn]))
		return
	end
	AOSHurtPlayer(player, aospn, player.aosobjects[objectnum].parent, 180, true, player.aosobjects[objectnum].x, player.aosobjects[objectnum].y)
	removeAOSObject(player, objectnum)
end
objects[10] = {}
objects[10].thinker = function(player, objectnum)
	local object = player.aosobjects[objectnum]
	object.scale = 3*FRACUNIT
	object.width = 16*FRACUNIT*3/2
	object.height = 5*FRACUNIT*3/2
	
	object.canbegrazed = true
	
	setAnim(object, missileanim)
	
	
	if(cos(object.angle) < 0)
		object.drawflags = $1|V_FLIP
	else
		object.drawflags = $1 & !V_FLIP
	end
	
	// Chase the target!
	local dirtochase = R_PointToAngle2(object.x, object.y, player.aosplayers[object.target].x, player.aosplayers[object.target].y)
	if(AngleFixed(dirtochase-object.angle) < FRACUNIT/4)
		object.angle = dirtochase
	else
		local addmul = 1
		if(abs((AngleFixed(dirtochase)%(360*FRACUNIT))-(AngleFixed(object.angle)%(360*FRACUNIT))) > 180*FRACUNIT)
			addmul = -1
		end
		
		if(AngleFixed(dirtochase)%(360*FRACUNIT) > AngleFixed(object.angle)%(360*FRACUNIT))
			object.angle = $1 + (FixedAngle(FRACUNIT/4)*addmul)
		else
			object.angle = $1 - (FixedAngle(FRACUNIT/4)*addmul)
		end
	end
	// Hacky fix for overshooting our desired angle
	if(AngleFixed(dirtochase-object.angle) < FRACUNIT/4)
		object.angle = dirtochase
	end
	
	if(object.timer)
		object.momx = FixedMul(cos(object.angle), object.timer)
		object.momy = FixedMul(sin(object.angle), object.timer)
		object.timer = $1 + FRACUNIT/5
		if(object.timer > 6*FRACUNIT)
			object.timer = 6*FRACUNIT
		end
		if(object.alttimer < 0)
			object.alttimer = $1 - 1
		else
			object.alttimer = $1 + 1
		end
		if(abs(object.alttimer) == TICRATE/5)
			if(object.alttimer < 0)
				object.alttimer = 1
				object.angle = $1 + FixedAngle(35*FRACUNIT)
			else
				object.alttimer = -1
				object.angle = $1 - FixedAngle(35*FRACUNIT)
			end
		end
	else
		local speed = R_PointToDist2(0, 0, object.momx, object.momy)
		local angle = R_PointToAngle2(0, 0, object.momx, object.momy)
		speed = $1 - FRACUNIT/10
		if(speed <= 0)
			object.momx = 0
			object.momy = 0
			object.alttimer = $1 + 1
			if(object.alttimer > TICRATE/3)
				object.timer = 1
				object.alttimer = 0
			end
		else
			object.momx = FixedMul(cos(angle), speed)
			object.momy = FixedMul(sin(angle), speed)
		end
	end
	local angle = R_PointToAngle2(0, 0, object.x, object.y)
	if(R_PointToDist2(0, 0, object.x, object.y) > player.arenaradius)
		if(AOSDotProduct(cos(angle), sin(angle), cos(object.angle), sin(object.angle)) < 0)
			object.x = FixedMul(cos(angle), player.arenaradius)
			object.y = FixedMul(sin(angle), player.arenaradius)
		else
			AOSPlaySound(player, sfx_sgbom1)
			removeAOSObject(player, objectnum)
			return
		end
	end
end
objects[10].playercollide = function(player, objectnum, aospn)
	if(aospn == player.aosobjects[objectnum].parent)
		return
	end
	AOSHurtPlayer(player, aospn, player.aosobjects[objectnum].parent, 250, false, player.aosobjects[objectnum].x, player.aosobjects[objectnum].y)
	AOSPlaySound(player, sfx_sgbom1)
	removeAOSObject(player, objectnum)
end
objects[11] = {}
objects[11].thinker = function(player, objectnum)
	local object = player.aosobjects[objectnum]
	object.scale = 3*FRACUNIT
	object.subscale = 3*FRACUNIT
	object.width = 9*FRACUNIT/2
	object.height = 9*FRACUNIT/2
	object.hassub = true
	
	object.canbegrazed = true
	
	setAnim(object, beam2anim1)
	setSubAnim(object, beam2anim2)
	
	// Transparancy
	object.subdrawflags = V_50TRANS
	
	if(object.timer)
		removeAOSObject(player, objectnum)
		return
	end
	
	object.timer = $1 + 1
	
	object.subx = object.x+object.momx
	object.suby = object.y+object.momy
end
objects[11].playercollide = function(player, objectnum, aospn)
	if(aospn == player.aosobjects[objectnum].parent)
		return
	end
	AOSHurtPlayer(player, aospn, player.aosobjects[objectnum].parent, 180, true, player.aosobjects[objectnum].x, player.aosobjects[objectnum].y)
	removeAOSObject(player, objectnum)
end
objects[12] = {}
objects[12].thinker = function(player, objectnum)
	local object = player.aosobjects[objectnum]
	object.scale = 5*FRACUNIT
	object.subscale = 5*FRACUNIT
	object.width = 380*FRACUNIT
	object.height = 25*FRACUNIT
	object.hassub = true
	
	object.canbegrazed = true
	
	setAnim(object, hyperanim)
	setSubAnim(object, hyperglowanim)
	
	// Transparancy
	object.subdrawflags = V_20TRANS
	
	if(cos(object.angle) < 0)
		object.drawflags = $1|V_FLIP
		object.subdrawflags = $1|V_FLIP
	else
		object.drawflags = $1 & !V_FLIP
	end
		
	
	if(object.timer > TICRATE)
		removeAOSObject(player, objectnum)
		return
	end
	
	object.timer = $1 + 1
	
	object.subx = object.x+object.momx
	object.suby = object.y+object.momy
	object.subangle = object.angle
end
objects[12].playercollide = function(player, objectnum, aospn)
	if(aospn == player.aosobjects[objectnum].parent)
		or(AOSPlayerCanGraze(player.aosplayers[aospn]))
		return
	end
	AOSHurtPlayer(player, aospn, player.aosobjects[objectnum].parent, 280, true, player.aosobjects[objectnum].x, player.aosobjects[objectnum].y)
//	removeAOSObject(player, objectnum)
end
objects[13] = {}
objects[13].thinker = function(player, objectnum)
	local object = player.aosobjects[objectnum]
	object.scale = 5*FRACUNIT/2
	object.width = 15*FRACUNIT
	object.height = 15*FRACUNIT
	object.aboveplayers = true
	
	setAnim(object, edgeanim)
	
	object.drawflags = V_20TRANS
	
	if(AngleFixed(object.angle) > 90*FRACUNIT and AngleFixed(object.angle) < 270*FRACUNIT)
		object.drawflags = $1|V_FLIP
	end
	
	if(object.timer)
		removeAOSObject(player, objectnum)
		return
	end
	
	object.timer = $1 + 1
end
objects[13].playercollide = function(player, objectnum, aospn)
	if(aospn == player.aosobjects[objectnum].parent)
		return
	end
	AOSHurtPlayer(player, aospn, player.aosobjects[objectnum].parent, 180, true, player.aosobjects[objectnum].x, player.aosobjects[objectnum].y)
end
objects[14] = {}
objects[14].thinker = function(player, objectnum)
	local object = player.aosobjects[objectnum]
	if(object.scale < 6*FRACUNIT)
		object.scale = $1 + (FRACUNIT*6)/TICRATE
		if(object.scale > 6*FRACUNIT)
			object.scale = 6*FRACUNIT
		end
	end
	object.width = 24*FRACUNIT*2
	object.height = 12*FRACUNIT*2
	
	object.canbegrazed = true
	
	setAnim(object, missileanim)
	
	if(cos(object.angle) < 0)
		object.drawflags = $1|V_FLIP
	else
		object.drawflags = $1 & !V_FLIP
	end
	
	if(object.timer)
		object.timer = $1 - 1
	end
	
	if(object.timer == 1)
		object.alttimer = FRACUNIT*9/2
	end
	
	if(object.alttimer)
		object.alttimer = $1 - FRACUNIT/20
		if(object.alttimer < 0)
			object.alttimer = 0
		end
	end
	
	// Chase the target!
	if not(object.timer)
		local dirtochase = R_PointToAngle2(object.x, object.y, player.aosplayers[object.target].x, player.aosplayers[object.target].y)
		if(AngleFixed(dirtochase-object.angle) < object.alttimer)
			object.angle = dirtochase
		else
			local addmul = 1
			if(abs((AngleFixed(dirtochase)%(360*FRACUNIT))-(AngleFixed(object.angle)%(360*FRACUNIT))) > 180*FRACUNIT)
				addmul = -1
			end
			
			if(AngleFixed(dirtochase)%(360*FRACUNIT) > AngleFixed(object.angle)%(360*FRACUNIT))
				object.angle = $1 + (FixedAngle(object.alttimer)*addmul)
			else
				object.angle = $1 - (FixedAngle(object.alttimer)*addmul)
			end
		end
		// Hacky fix for overshooting our desired angle
		if(AngleFixed(dirtochase-object.angle) < object.alttimer)
			object.angle = dirtochase
		end
		
		object.momx = FixedMul(cos(object.angle), 5*FRACUNIT)
		object.momy = FixedMul(sin(object.angle), 5*FRACUNIT)
	end
	
	local angle = R_PointToAngle2(0, 0, object.x, object.y)
	if(R_PointToDist2(0, 0, object.x, object.y) > player.arenaradius)
		and not((R_PointToDist2(0, 0, object.x-object.momx, object.y-object.momy) > player.arenaradius) and not(R_PointToDist2(0, 0, object.x, object.y) > player.arenaradius*3/2))
		if(AOSDotProduct(cos(angle), sin(angle), cos(object.angle), sin(object.angle)) < 0)
			object.x = FixedMul(cos(angle), player.arenaradius)
			object.y = FixedMul(sin(angle), player.arenaradius)
		else
			AOSPlaySound(player, sfx_sgnuke)
			local beam = player.aosobjects[createAOSObject(player)]
			beam.type = explosion
			beam.momx = 0
			beam.momy = 0
			beam.x = object.x
			beam.y = object.y
			beam.parent = object.parent
			removeAOSObject(player, objectnum)
			return
		end
	end
end
objects[14].playercollide = function(player, objectnum, aospn)
	if(aospn == player.aosobjects[objectnum].parent)
		or(player.aosobjects[objectnum].scale < 6*FRACUNIT)
		return
	end
//	AOSHurtPlayer(player, aospn, player.aosobjects[objectnum].parent, 200, false, player.aosobjects[objectnum].x, player.aosobjects[objectnum].y)
	AOSPlaySound(player, sfx_sgnuke)
	local beam = player.aosobjects[createAOSObject(player)]
	beam.type = explosion
	beam.momx = 0
	beam.momy = 0
	beam.x = player.aosobjects[objectnum].x
	beam.y = player.aosobjects[objectnum].y
	beam.parent = player.aosobjects[objectnum].parent
	removeAOSObject(player, objectnum)
end
objects[15] = {}
objects[15].thinker = function(player, objectnum)
	local object = player.aosobjects[objectnum]
	if not(object.timer)
		object.scale = 5*FRACUNIT/2
	end
	object.width = 48*object.scale
	object.height = 48*object.scale
	object.spherecollision = true
	
	setAnim(object, explosionanim)
	
	if(object.timer > TICRATE)
	//	setAnim(object, explosionanim2)
		if not(object.timer & 1)
			object.drawflags = $1|V_50TRANS
		else
			object.drawflags = $1 & !V_50TRANS
		end
	end
	
	if(object.timer > TICRATE*3)
		object.scale = $1 - FRACUNIT/10
		if(object.scale <= 0)
			removeAOSObject(player, objectnum)
			return
		end
	end
	
	object.timer = $1 + 1
end
objects[15].playercollide = function(player, objectnum, aospn)
	if(aospn == player.aosobjects[objectnum].parent)
		or(player.aosobjects[objectnum].timer > TICRATE)
		return
	end
	AOSHurtPlayer(player, aospn, player.aosobjects[objectnum].parent, 180, true, player.aosobjects[objectnum].x, player.aosobjects[objectnum].y)
end
objects[16] = {}
objects[16].thinker = function(player, objectnum)
	local object = player.aosobjects[objectnum]
	local maxscale = 2*FRACUNIT
	if(object.timer == 0)
		object.scale = 1
	end
	if(object.alttimer == 1)
		maxscale = FRACUNIT*8/10
	elseif(object.alttimer == 2)
		maxscale = FRACUNIT
	elseif(object.alttimer == 3)
		maxscale = FRACUNIT/2
	elseif(object.alttimer == 4)
		maxscale = 2*FRACUNIT*9/10
	elseif(object.alttimer == 5)
		maxscale = 2*FRACUNIT*7/10
	elseif(object.alttimer == 6)
		maxscale = 2*FRACUNIT*6/10
	elseif(object.alttimer == 7)
		maxscale = 2*FRACUNIT*11/10
	end
	
	object.width = 58*object.scale
	object.height = 58*object.scale
	object.spherecollision = true
	
	if(object.alttimer == 1)
		setAnim(object, lightballredanim)
	elseif(object.alttimer == 2)
		setAnim(object, lightballpurpleanim)
	elseif(object.alttimer == 3)
		setAnim(object, lightballcyananim)
	elseif(object.alttimer == 4)
		setAnim(object, lightballgreenanim)
	elseif(object.alttimer == 5)
		setAnim(object, lightballsteelanim)
	elseif(object.alttimer == 6)
		setAnim(object, lightballtananim)
	elseif(object.alttimer == 7)
		setAnim(object, lightballorangeanim)
	else
		setAnim(object, lightballblueanim)
		object.aboveplayers = true
	end
	
	local rotspeed = FRACUNIT*3
	if(object.alttimer == 1)
		rotspeed = FRACUNIT*5/2
	elseif(object.alttimer == 2)
		rotspeed = FRACUNIT*2
	elseif(object.alttimer == 3)
		rotspeed = FRACUNIT*3
	elseif(object.alttimer == 4)
		rotspeed = FRACUNIT*2/3
	elseif(object.alttimer == 5)
		rotspeed = FRACUNIT*2/3
	elseif(object.alttimer == 6)
		rotspeed = FRACUNIT
	elseif(object.alttimer == 7)
		rotspeed = FRACUNIT/2
	end
	
	if(player.aosplayers[object.parent].attacktimer < time1)
		rotspeed = $1 / 2
	elseif(player.aosplayers[object.parent].attacktimer > time2)
		rotspeed = $1 * 5 / 4
	end
	
	
	// Red
	// Purple
	// Cyan
	if(object.alttimer == 1)
		or(object.alttimer == 2)
		or(object.alttimer == 3)
		or(object.alttimer == 4)
		rotspeed = -$1
	end
	
	object.angle = $1 + FixedAngle(rotspeed)
	
	// Place the thing
	
	if(object.alttimer == 1)
		// Red
		object.x = FixedMul(cos(object.angle), 100*FRACUNIT)
		object.y = FixedMul(sin(object.angle), 150*FRACUNIT)
	elseif(object.alttimer == 2)
		// Purple
		object.x = FixedMul(cos(object.angle), (player.arenaradius+(object.width/2)-(FRACUNIT*10)))
		object.y = FixedMul(sin(object.angle), player.arenaradius)
	elseif(object.alttimer == 3)
		// Cyan
		local tox = FixedMul(cos(object.angle), 30*FRACUNIT)
		local toy = FixedMul(sin(object.angle), 180*FRACUNIT)
		local offangle = FixedAngle(30*FRACUNIT)
		object.x = FixedMul(cos(offangle), tox)+FixedMul(sin(offangle), toy)
		object.y = FixedMul(cos(offangle+ANGLE_90), tox)+FixedMul(sin(offangle+ANGLE_90), toy)
	elseif(object.alttimer == 4)
		// Green
		object.x = FixedMul(cos(object.angle), 200*FRACUNIT)
		object.y = FixedMul(sin(object.angle), 200*FRACUNIT)
	elseif(object.alttimer == 5)
		// Steel
		object.x = FixedMul(cos(object.angle), 240*FRACUNIT)
		object.y = FixedMul(sin(object.angle), 190*FRACUNIT)
	elseif(object.alttimer == 6)
		// Tan
		object.x = FixedMul(cos(object.angle), 130*FRACUNIT)
		object.y = FixedMul(sin(object.angle), 110*FRACUNIT)
	elseif(object.alttimer == 7)
		// Orange
		local tox = FixedMul(cos(object.angle), 180*FRACUNIT)
		local toy = FixedMul(sin(object.angle), 30*FRACUNIT)
		local offangle = FixedAngle(-20*FRACUNIT)
		object.x = FixedMul(cos(offangle), tox)+FixedMul(sin(offangle), toy)
		object.y = FixedMul(cos(offangle+ANGLE_90), tox)+FixedMul(sin(offangle+ANGLE_90), toy)
	end
	
	object.drawflags = $1|V_20TRANS
	
	object.timer = $1 + 1
	
	if not(player.aosplayers[object.parent].currentattack == 4)
		object.scale = $1 - FRACUNIT/13
		if(object.scale <= 0)
			removeAOSObject(player, objectnum)
			return
		end
	elseif(object.scale < maxscale)
		object.scale = $1 + FRACUNIT/30
		if(object.scale > maxscale)
			object.scale = maxscale
		end
	end
end
objects[16].playercollide = function(player, objectnum, aospn)
	if(aospn == player.aosobjects[objectnum].parent)
		return
	end
	AOSHurtPlayer(player, aospn, player.aosobjects[objectnum].parent, 220, true, player.aosobjects[objectnum].x, player.aosobjects[objectnum].y)
end
objects[17] = {}
objects[17].thinker = function(player, objectnum)
	local object = player.aosobjects[objectnum]
	if not(object.timer)
		object.scale = 5*FRACUNIT/2
	end
	object.width = 3*object.scale
	object.height = 3*object.scale
	object.spherecollision = true
	
	setAnim(object, laserexplodeanim)
	
	if(object.timer > TICRATE/2)
		object.scale = $1 - FRACUNIT/10
		if(object.scale <= 0)
			removeAOSObject(player, objectnum)
			return
		end
	end
	
	object.timer = $1 + 1
end
objects[17].playercollide = function(player, objectnum, aospn)
	if(aospn == player.aosobjects[objectnum].parent)
		or(player.aosobjects[objectnum].timer > 3)
		return
	end
	AOSHurtPlayer(player, aospn, player.aosobjects[objectnum].parent, 180, true, player.aosobjects[objectnum].x, player.aosobjects[objectnum].y)
end
local purplebeam2
objects[18] = {}
objects[18].thinker = function(player, objectnum)
	local object = player.aosobjects[objectnum]
	object.scale = 5*FRACUNIT/2
	object.width = 15*FRACUNIT
	object.height = 15*FRACUNIT
	object.aboveplayers = true
	
	setAnim(object, edgeanim)
	
	object.drawflags = V_20TRANS
	
	if(AngleFixed(object.angle) > 90*FRACUNIT and AngleFixed(object.angle) < 270*FRACUNIT)
		object.drawflags = $1|V_FLIP
	end
	
	if(object.timer+1 == object.alttimer)
		AOSPlaySound(player, sfx_sgsrd3)
		player.sonigurichaseobj = objectnum
	end
	
	if(object.timer < object.alttimer)
		object.momx = cos(object.angle)*8
		object.momy = sin(object.angle)*8
		
		// Shoot the thing!
		if(object.x < 160*FRACUNIT)
			and(object.x > -160*FRACUNIT)
			and(object.y < 100*FRACUNIT)
			and(object.y > -100*FRACUNIT)
			local bnum = createAOSObject(player)
			local beam = player.aosobjects[bnum]
			beam.type = purplebeam2
			beam.momx = 0
			beam.momy = 0
			beam.x = object.x
			beam.y = object.y
			beam.timer = object.timer
			beam.parent = object.parent
			beam.angle = object.angle
			
			if(bnum < objectnum)
				AOSObjectThinker(player, bnum)
			end
		end
		
		local attackrate = TICRATE/8
		if not(object.timer%attackrate)
			and not(object.subscale > 7)
			AOSPlaySound(player, sfx_sglzr1)
			// Shoot the thing!
			local beam = player.aosobjects[createAOSObject(player)]
			beam.type = blueball
			if(object.subscale & 1)
				beam.type = purpleball
			end
			beam.angle = object.angle+FixedAngle(object.timer*360*FRACUNIT/attackrate/20*14)
			beam.x = object.x-(4*cos(beam.angle))
			beam.y = object.y-(4*sin(beam.angle))
			beam.momx = (2*cos(beam.angle))
			beam.momy = (2*sin(beam.angle))
			beam.parent = object.parent
			beam.target = object.target
			object.subscale = $1 + 1
		end
	else
		object.subscale = 0
	end
	
	if not(object.timer)
		if(player.sonigurichaseobj == objectnum)
			player.sonigurichaseobj = -1
		end
		removeAOSObject(player, objectnum)
		return
	end
	
	object.timer = $1 - 1
end
objects[18].playercollide = function(player, objectnum, aospn)
	if(aospn == player.aosobjects[objectnum].parent)
		return
	end
	AOSHurtPlayer(player, aospn, player.aosobjects[objectnum].parent, 180, true, player.aosobjects[objectnum].x, player.aosobjects[objectnum].y)
end
objects[19] = {}
objects[19].thinker = function(player, objectnum)
	local object = player.aosobjects[objectnum]
	if not(object.alttimer)
		object.scale = 5*FRACUNIT
		object.subscale = 5*FRACUNIT
		object.alttimer = 1
	end
	object.width = 13*FRACUNIT/2
	object.height = 13*FRACUNIT/2
	object.hassub = true
	
	setAnim(object, beam2anim1)
	setSubAnim(object, beam2anim2)
	
	// Transparancy
	object.subdrawflags = V_50TRANS
	
	if not(object.timer)
		object.width = 0
		object.height = 0
		object.scale = $1 - FRACUNIT/5
		if(object.scale <= 0)
			removeAOSObject(player, objectnum)
			return
		end
	else
		object.timer = $1 - 1
	end
	
	object.subscale = object.scale
	object.subx = object.x+object.momx
	object.suby = object.y+object.momy
end
objects[19].playercollide = function(player, objectnum, aospn)
	if(aospn == player.aosobjects[objectnum].parent)
	//	or(AOSPlayerCanGraze(player.aosplayers[aospn]))
		return
	end
	AOSHurtPlayer(player, aospn, player.aosobjects[objectnum].parent, 180, true, player.aosobjects[objectnum].x, player.aosobjects[objectnum].y)
end
bluebeam = AOS_AddObject(objects[0])
missile1 = AOS_AddObject(objects[1])
blueball = AOS_AddObject(objects[2])
longbeam = AOS_AddObject(objects[5])
beamspawn = AOS_AddObject(objects[6])
bluebeamshoot = AOS_AddObject(objects[7])
missile2 = AOS_AddObject(objects[4])
purpleball = AOS_AddObject(objects[8])
purplebeam = AOS_AddObject(objects[9])
missile3 = AOS_AddObject(objects[10])
swordbeam = AOS_AddObject(objects[11])
hyperbeam = AOS_AddObject(objects[12])
edgebox = AOS_AddObject(objects[13])
nuke = AOS_AddObject(objects[14])
explosion = AOS_AddObject(objects[15])
lightball = AOS_AddObject(objects[16])
laserexplode = AOS_AddObject(objects[17])
edge2 = AOS_AddObject(objects[18])
purplebeam2 = AOS_AddObject(objects[19])
