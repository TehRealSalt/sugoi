// --------------------------------------
// LUA_AOS
// Acceleration of Soniguri
// Would've liked to do a lot more for
// this port, pretty much remaking the
// entire boss in an updated version of
// the engine... But this is what I get
// for procrastinating until the very
// last minute!
// --------------------------------------
freeslot("sfx_sgdash", "sfx_sgring", "sfx_sgtarg", "sfx_sgchrg", "sfx_sgbeam", "sfx_sgbem2", "sfx_sgrock", "sfx_sgshot", "sfx_sghit", "sfx_sgsrd1", "sfx_sgsrd2", "sfx_sgsrd3", "sfx_sgbom1", "sfx_sgdie", "sfx_sgshld", "sfx_sghypr", "sfx_sgacel", "sfx_sglazr", "sfx_sglzr1", "sfx_sglzr2", "sfx_sgnuke", "sfx_sgmen1", "sfx_sgmen2", "sfx_sgmen3")
local deadzone = 15
local darkring = false
local debugboxes = false
local deathfadetime = TICRATE*2
local initialdashspeed = FRACUNIT*9
local numscreens = 14

local deatheffnum = 50

sfxinfo[sfx_sgring].singular = true
sfxinfo[sfx_sgmen2].singular = true
sfxinfo[sfx_sgmen3].singular = true

local numplayers = 0
local playerinfo = {}
local numpframes = 0
local pframeinfo = {}
local numobjs = 0
local objinfo = {}
local numframes = 0
local frameinfo = {}
local numanims = 0
local animinfo = {}

local sonigmovecountp1 = 12
local sonigmovelistp1 = {}
sonigmovelistp1[0] = 1		// Blue ball
sonigmovelistp1[1] = 6		// Shoot + spread
sonigmovelistp1[2] = 2		// Dash rockets
sonigmovelistp1[3] = 7		// Rocket + spread
sonigmovelistp1[4] = 9		// Purple ball
sonigmovelistp1[5] = 15		// Sword
sonigmovelistp1[6] = 2		// Dash rockets
sonigmovelistp1[7] = 8		// Dash shoot
sonigmovelistp1[8] = 1		// Blue ball
sonigmovelistp1[9] = 10		// Rocket
sonigmovelistp1[10] = 13	// Hyper
sonigmovelistp1[11] = 16	// Double sword
local sonigmovecountp2 = 13
local sonigmovelistp2 = {}
sonigmovelistp2[0] = 17		// Dash rockets 2
sonigmovelistp2[1] = 19		// Spread 2
sonigmovelistp2[2] = 22		// Edge
sonigmovelistp2[3] = 20		// Sword -> Double sword
sonigmovelistp2[4] = 17		// Dash rockets 2
sonigmovelistp2[5] = 25		// Hyper
sonigmovelistp2[6] = 23		// Edge + blue ball
sonigmovelistp2[7] = 15		// Sword
sonigmovelistp2[8] = 18		// Rocket 2
sonigmovelistp2[9] = 17		// Dash rockets 2
sonigmovelistp2[10] = 8		// Dash shoot
sonigmovelistp2[11] = 24	// Purple ball (no dash)
sonigmovelistp2[12] = 7		// Rocket + spread

local maxprev = 4

local startcuttime = TICRATE*3

local OBJ_RAINBOWCIRCLE = 0
local OBJ_DEATHBALL = 1

rawset(_G, "AOS_AddPlayer", function(player)
	playerinfo[numplayers] = player
	numplayers = $1 + 1
	return(numplayers-1)
end)

rawset(_G, "AOS_AddPFrame", function(frame)
	pframeinfo[numpframes] = frame
	numpframes = $1 + 1
	return(numpframes-1)
end)

rawset(_G, "AOS_AddObject", function(obj)
	objinfo[numobjs] = obj
	numobjs = $1 + 1
	return(numobjs-1)
end)

rawset(_G, "AOS_AddFrame", function(frame)
	frameinfo[numframes] = frame
	numframes = $1 + 1
	return(numframes-1)
end)

rawset(_G, "AOS_AddAnim", function(anim)
	animinfo[numanims] = anim
	numanims = $1 + 1
	return(numanims-1)
end)

rawset(_G, "AOSDotProduct", function(x1, y1, x2, y2)
	return FixedMul(x1, x2)+FixedMul(y1, y2)
end)

local function AOSTestPointsPastPlane(x1, y1, w1, h1, a1, x2, y2, w2, h2, a2, s)
	// S:
	// 0: test for box 1's right plane
	// 1: test for box 1's top plane
	// 2: test for box 1's left plane
	// 3: test for box 1's bottom plane
	local normalx
	local normaly
	if(s == 0 or s == 2)
		normalx = cos(a1)
		normaly = sin(a1)
	else
		normalx = -sin(a1)
		normaly = cos(a1)
	end
	if(s >= 2)
		normalx = -$1
		normaly = -$1
	end

	local planedist = AOSDotProduct(normalx, normaly, x1, y1)
	if(s == 0)
		planedist = $1 + (w1/2)
	elseif(s == 1)
		planedist = $1 + (h1/2)
	elseif(s == 2)
		planedist = $1 + (w1/2)
	elseif(s == 3)
		planedist = $1 + (h1/2)
	end

	local numpoints = 0
	// Test if the points on the other box are past the plane!
	local wcos = FixedMul(cos(a2), w2/2)
	local wsin = FixedMul(sin(a2), w2/2)
	local hcos = FixedMul(cos(a2), h2/2)
	local hsin = FixedMul(sin(a2), h2/2)
	local points = {}
	points[0] = {}
	points[0].x = (x2-wcos)-hsin
	points[0].y = (y2+hcos)-wsin
	points[1] = {}
	points[1].x = (x2+wcos)-hsin
	points[1].y = (y2+hcos)+wsin
	points[2] = {}
	points[2].x = (x2-wcos)+hsin
	points[2].y = (y2-hcos)-wsin
	points[3] = {}
	points[3].x = (x2+wcos)+hsin
	points[3].y = (y2-hcos)+wsin
	local pnum = 0
	while(pnum < 4)
		local planedist2 = AOSDotProduct(normalx, normaly, points[pnum].x, points[pnum].y)
	//	if(pnum == 0)
	//		print(planedist - planedist2)
	//	end
		if(planedist-planedist2 >= 0)
			numpoints = $1 + 1
//			print(pnum+" hit?")
//		else
//			print(pnum+" miss?")
		end
		pnum = $1 + 1
	end
	return numpoints
end

rawset(_G, "AOSTestCollision", function(x1, y1, w1, h1, a1, x2, y2, w2, h2, a2)
	if(R_PointToDist2(x1,y1,x2,y2) > w1+h1+w2+h2)	// too far?
		return false	// Can't possibly touch!
	end
	if(AOSTestPointsPastPlane(x1, y1, w1, h1, a1, x2, y2, w2, h2, a2, 0) == 0)
		or(AOSTestPointsPastPlane(x1, y1, w1, h1, a1, x2, y2, w2, h2, a2, 1) == 0)
		or(AOSTestPointsPastPlane(x1, y1, w1, h1, a1, x2, y2, w2, h2, a2, 2) == 0)
		or(AOSTestPointsPastPlane(x1, y1, w1, h1, a1, x2, y2, w2, h2, a2, 3) == 0)
		or(AOSTestPointsPastPlane(x2, y2, w2, h2, a2, x1, y1, w1, h1, a1, 0) == 0)
		or(AOSTestPointsPastPlane(x2, y2, w2, h2, a2, x1, y1, w1, h1, a1, 1) == 0)
		or(AOSTestPointsPastPlane(x2, y2, w2, h2, a2, x1, y1, w1, h1, a1, 2) == 0)
		or(AOSTestPointsPastPlane(x2, y2, w2, h2, a2, x1, y1, w1, h1, a1, 3) == 0)
		return false
	end
	return true
end)

local startdist = 70

local function createAOSPlayer(player, pnum, startangle)
	player.aosplayers[pnum] = {}
	player.aosplayers[pnum].exists = true
	if not(player.clients[pnum] == -1)
		player.aosplayers[pnum].character = 0//players[player.clients[pnum]].character
	elseif(pnum == 32)
		player.aosplayers[pnum].character = 1
	else
		player.aosplayers[pnum].character = 0
		player.aosplayers[pnum].exists = false
	end
	player.aosplayers[pnum].x = FixedDiv(FixedMul(-cos(startangle)*startdist, player.arenaradius), 245*FRACUNIT)
	player.aosplayers[pnum].y = FixedDiv(FixedMul(sin(startangle)*startdist, player.arenaradius), 245*FRACUNIT)
	player.aosplayers[pnum].dashdirection = 0
	player.aosplayers[pnum].movementspeed = 2*FRACUNIT
	player.aosplayers[pnum].movementspeeddiag = 2*FRACUNIT
	player.aosplayers[pnum].dashing = 0			// 0 = not dashing, 1 = dashing, 2 and higher = dashing exit, can still avoid beams and spawns rings
	player.aosplayers[pnum].dashtime = 0		// Used for RCC
	player.aosplayers[pnum].adddashspeed = 0	// Set to initialdashspeed when the player starts dashing. quickly depletes during the dash. gets added to base dash speed.
	player.aosplayers[pnum].addmomx = 0			// For exiting dashing
	player.aosplayers[pnum].addmomy = 0
	if not(player.aosplayers[pnum].character == 1)
		player.aosplayers[pnum].health = 3000
	else
		player.aosplayers[pnum].health = 9000		// 3000 per health bar, there's 3 health bars so 9000 in total
	end
	player.aosplayers[pnum].redhealth = 0
	player.aosplayers[pnum].heat = 0			// FRACUNIT = 1%
	player.aosplayers[pnum].hyper = 0			// FRACUNIT = 1 meter, so max is 3*FRACUNIT
	player.aosplayers[pnum].target = 0			// Target player
	if not(player.aosplayers[pnum].character == 1)
		player.aosplayers[pnum].target = -1	// Gets set later
	end
	player.aosplayers[pnum].cantarget = true
	player.aosplayers[pnum].shootdirection = 0	// Usually the direction to the other player
	player.aosplayers[pnum].canaim = true
	player.aosplayers[pnum].canmove = true
	player.aosplayers[pnum].facingdir = 0		// if 1, the player's facing left. This is constantly written to if the player is targeting
	player.aosplayers[pnum].knockbacktime = 0
	player.aosplayers[pnum].knockbackmomx = 0
	player.aosplayers[pnum].knockbackmomy = 0
	player.aosplayers[pnum].width = 7*FRACUNIT
	player.aosplayers[pnum].height = 7*FRACUNIT
	player.aosplayers[pnum].deathtimer = 0
	// Attacks
	player.aosplayers[pnum].currentattack = 0
	player.aosplayers[pnum].attacktimer = 0
	player.aosplayers[pnum].attackvar = 0
	player.aosplayers[pnum].candashcancel = false
	player.aosplayers[pnum].lockspeed = false
	player.aosplayers[pnum].beamammo = FRACUNIT
	player.aosplayers[pnum].ballisticammo = FRACUNIT
	player.aosplayers[pnum].prevbutt = 0
	player.aosplayers[pnum].animation = 0
	player.aosplayers[pnum].frame = 0
	player.aosplayers[pnum].animtime = 0
	player.aosplayers[pnum].drawdirection = 0
	player.aosplayers[pnum].ptwocolor = false
	player.aosplayers[pnum].shieldtime = 0
	// Trail
	player.aosplayers[pnum].prevx = {}
	player.aosplayers[pnum].prevy = {}
	player.aosplayers[pnum].prevframe = {}
	player.aosplayers[pnum].prevangle = {}
	player.aosplayers[pnum].prevflip = {}
	local prvnum = 0
	while(prvnum < maxprev)
		player.aosplayers[pnum].prevx[prvnum] = player.aosplayers[pnum].x
		player.aosplayers[pnum].prevy[prvnum] = player.aosplayers[pnum].y
		player.aosplayers[pnum].prevframe[prvnum] = playerinfo[player.aosplayers[pnum].character].animations[player.aosplayers[pnum].animation].frames[player.aosplayers[pnum].frame]
		player.aosplayers[pnum].prevangle[prvnum] = player.aosplayers[pnum].drawdirection
		player.aosplayers[pnum].prevflip[prvnum] = player.aosplayers[pnum].facingdir
		prvnum = $1 + 1
	end
end

local function createAOSPlayers(player)
	local startangle = 0
	local pnum = 0
	while(pnum < player.numplayers)
		player.aosplayers[pnum] = {}
		player.aosplayers[pnum].exists = true
		if not(player.clients[pnum] == -1)
			player.aosplayers[pnum].character = 0//players[player.clients[pnum]].character
		elseif(pnum == 32)
			player.aosplayers[pnum].character = 1
		else
			player.aosplayers[pnum].character = 0
			player.aosplayers[pnum].exists = false
		end
		player.aosplayers[pnum].x = FixedDiv(FixedMul(-cos(startangle)*startdist, player.arenaradius), 245*FRACUNIT)
		player.aosplayers[pnum].y = FixedDiv(FixedMul(sin(startangle)*startdist, player.arenaradius), 245*FRACUNIT)
		player.aosplayers[pnum].dashdirection = 0
		player.aosplayers[pnum].movementspeed = 2*FRACUNIT
		player.aosplayers[pnum].movementspeeddiag = 2*FRACUNIT
		player.aosplayers[pnum].dashing = 0			// 0 = not dashing, 1 = dashing, 2 and higher = dashing exit, can still avoid beams and spawns rings
		player.aosplayers[pnum].dashtime = 0		// Used for RCC
		player.aosplayers[pnum].adddashspeed = 0	// Set to initialdashspeed when the player starts dashing. quickly depletes during the dash. gets added to base dash speed.
		player.aosplayers[pnum].addmomx = 0			// For exiting dashing
		player.aosplayers[pnum].addmomy = 0
		if not(player.aosplayers[pnum].character == 1)
			player.aosplayers[pnum].health = 3000
		else
			player.aosplayers[pnum].health = 9000		// 3000 per health bar, there's 3 health bars so 9000 in total
		end
		player.aosplayers[pnum].redhealth = 0
		player.aosplayers[pnum].heat = 0			// FRACUNIT = 1%
		player.aosplayers[pnum].hyper = 0			// FRACUNIT = 1 meter, so max is 3*FRACUNIT
		player.aosplayers[pnum].target = 0			// Target player
		if not(player.aosplayers[pnum].character == 1)
			player.aosplayers[pnum].target = -1	// Gets set later
		end
		player.aosplayers[pnum].cantarget = true
		player.aosplayers[pnum].shootdirection = 0	// Usually the direction to the other player
		player.aosplayers[pnum].canaim = true
		player.aosplayers[pnum].canmove = true
		player.aosplayers[pnum].facingdir = 0		// if 1, the player's facing left. This is constantly written to if the player is targeting
		player.aosplayers[pnum].knockbacktime = 0
		player.aosplayers[pnum].knockbackmomx = 0
		player.aosplayers[pnum].knockbackmomy = 0
		player.aosplayers[pnum].width = 7*FRACUNIT
		player.aosplayers[pnum].height = 7*FRACUNIT
		player.aosplayers[pnum].deathtimer = 0
		// Attacks
		player.aosplayers[pnum].currentattack = 0
		player.aosplayers[pnum].attacktimer = 0
		player.aosplayers[pnum].attackvar = 0
		player.aosplayers[pnum].candashcancel = false
		player.aosplayers[pnum].lockspeed = false
		player.aosplayers[pnum].beamammo = FRACUNIT
		player.aosplayers[pnum].ballisticammo = FRACUNIT
		player.aosplayers[pnum].prevbutt = 0
		player.aosplayers[pnum].animation = 0
		player.aosplayers[pnum].frame = 0
		player.aosplayers[pnum].animtime = 0
		player.aosplayers[pnum].drawdirection = 0
		player.aosplayers[pnum].ptwocolor = false

		// Trail
		player.aosplayers[pnum].prevx = {}
		player.aosplayers[pnum].prevy = {}
		player.aosplayers[pnum].prevframe = {}
		player.aosplayers[pnum].prevangle = {}
		player.aosplayers[pnum].prevflip = {}
		local prvnum = 0
		while(prvnum < maxprev)
			player.aosplayers[pnum].prevx[prvnum] = player.aosplayers[pnum].x
			player.aosplayers[pnum].prevy[prvnum] = player.aosplayers[pnum].y
			player.aosplayers[pnum].prevframe[prvnum] = playerinfo[player.aosplayers[pnum].character].animations[player.aosplayers[pnum].animation].frames[player.aosplayers[pnum].frame]
			player.aosplayers[pnum].prevangle[prvnum] = player.aosplayers[pnum].drawdirection
			player.aosplayers[pnum].prevflip[prvnum] = player.aosplayers[pnum].facingdir
			prvnum = $1 + 1
		end

		startangle = $1 + FixedAngle(360*FRACUNIT/player.numplayers)
		pnum = $1 + 1
		if(pnum == 32)
			startangle = ANGLE_180
		end
	end
end

local maxdash = TICRATE/3

local maxobjects = 512+128

rawset(_G, "createAOSObject", function(player, num)
	local onum = 0
	if not(num == nil)
		onum = num
	else
		while(onum < maxobjects)
			and(player.aosobjects[onum].exists)
			onum = $1 + 1
		end
		if(onum >= maxobjects)
			return -1
		end
	end
	player.aosobjects[onum].exists = true
	player.aosobjects[onum].type = 0
	player.aosobjects[onum].x = 0
	player.aosobjects[onum].y = 0
	player.aosobjects[onum].momx = 0
	player.aosobjects[onum].momy = 0
	player.aosobjects[onum].angle = 0
	player.aosobjects[onum].scale = FRACUNIT
	player.aosobjects[onum].spherecollision = false	// By default, does box collision. Uses width as radius, height is unused.
	player.aosobjects[onum].width = 0				// NOTE: this does not scale with object.scale!
	player.aosobjects[onum].height = 0				// Set either of these to 0 to disable collision for this object.
	player.aosobjects[onum].timer = 0				// If you really want a thin object, use 1
	player.aosobjects[onum].alttimer = 0
	player.aosobjects[onum].hitflag = false
	player.aosobjects[onum].parent = 0		// Usage depends on the object, but for projectiles, this should be the id of the player who spawned it
	player.aosobjects[onum].target = 0
	player.aosobjects[onum].animation = 0
	player.aosobjects[onum].frame = 0
	player.aosobjects[onum].animtime = 0
	player.aosobjects[onum].dontdraw = false
	player.aosobjects[onum].aboveplayers = false
	player.aosobjects[onum].drawflags = 0
	player.aosobjects[onum].hassub = false	// Sub-objects! Only used for drawing, so you can have multiple layers of transparancy if you want.
	player.aosobjects[onum].subx = 0
	player.aosobjects[onum].suby = 0
	player.aosobjects[onum].subangle = 0
	player.aosobjects[onum].subscale = FRACUNIT
	player.aosobjects[onum].subanimation = 0
	player.aosobjects[onum].subframe = 0
	player.aosobjects[onum].subanimtime = 0
	player.aosobjects[onum].subdrawflags = 0
	player.aosobjects[onum].canbegrazed = false
	player.aosobjects[onum].hasbeengrazed = {}
	local pnum = 0
	while(pnum < 32)
		player.aosobjects[onum].hasbeengrazed[pnum] = false
		pnum = $1 + 1
	end
	return onum
end)

local function AOSInitObjects(player)
	local onum = 0
	while(onum < maxobjects)
		player.aosobjects[onum] = nil
		player.aosobjects[onum] = {}
		local obj = createAOSObject(player, onum)
		player.aosobjects[obj].exists = false
		onum = $1 + 1
	end
end

rawset(_G, "removeAOSObject", function(player, objectnum)
	player.aosobjects[objectnum] = nil	// Not sure if this does much, but its probably fine
	player.aosobjects[objectnum] = {}
end)

rawset(_G, "setPAnim", function(aosp, anim)
	if not(aosp.animation == anim)
		aosp.animtime = 0
		aosp.frame = 0
	end
	aosp.animation = anim
end)

local function AOSStartGame(player, initonly)
//	player.numplayers = 2
	player.startcuttime = startcuttime/6
	player.aostimer = 180*TICRATE
	local rng = A_SeedRng_Get()
	player.seedrngstate = rng.Create(true, 1, 2, 3, 4)
	player.targetseedrngstate = rng.Create(true, 1, 2, 3, 4)
	player.soniguriattack = 0
	player.soniguridumbvar = 0
	player.soniguriphase = 0
	player.soniguricamerastuff = 0
	player.sonigurichaseobj = -1
	player.sonigurilastplayeralive = 0
	if not(initonly)
		local cnum = 0
		while(cnum < 32)
			if not(player.clients[cnum] == -1)
				S_StopMusic(players[player.clients[cnum]])
			end
			cnum = $1 + 1
		end
	end
	createAOSPlayers(player)
	AOSInitObjects(player)
end

/*COM_AddCommand("startgame", function(player, numplay)
	if not(numplay == nil)
		and not(tonumber(numplay) == nil)
		player.numplayers = tonumber(numplay)
	end
	AOSStartGame(player)
end)*/

rawset(_G, "AOSPlaySound", function(player, sound)
	local cnum = 0
	while(cnum < 32)
		if not(player.clients[cnum] == -1)
			S_StartSound(nil, sound, players[player.clients[cnum]])
		end
		cnum = $1 + 1
	end
end)

rawset(_G, "AOSPlayerCanGraze", function(aosp)
	if(aosp.dashing)
		and not(aosp.currentattack == 22)	// Not using edge
		and not(aosp.currentattack == 23)
		return true
	end
	return false
end)

rawset(_G, "AOSHurtPlayer", function(player, aospn, aospns, damage, heatscale, kbx, kby, kbs)
	if(player.aosplayers[aospn].deathtimer)
		or(player.aosplayers[aospn].shieldtime)
		or(aospn == 32 and (player.aosplayers[aospn].currentattack == 4 or player.aosplayers[aospn].currentattack == 27))
		return
	end

	if(aospn == 32)
		local numalive = 0
		local pnum = 0
		while(pnum < 32)
			if(player.aosplayers[pnum].exists)
				and not(player.aosplayers[pnum].deathtimer)
				numalive = $1 + 1
			end
			pnum = $1 + 1
		end
		if(numalive < 1)
			numalive = 1	// Prevent divide by 0 errors
		end
		if(numalive & 1)
			numalive = $1 + 1
		end
		damage = $1 / (numalive/2)
	else
		local numalive = 0
		local pnum = 0
		while(pnum < 32)
			if(player.aosplayers[pnum].exists)
				and not(player.aosplayers[pnum].deathtimer)
				numalive = $1 + 1
			end
			pnum = $1 + 1
		end
		if(numalive & 1)
			numalive = $1 + 1
		end
		damage = $1 * (numalive/2)
	end

	if(heatscale)
		and(player.aosplayers[aospn].heat > 100*FRACUNIT)
		damage = FixedMul($1, player.aosplayers[aospn].heat/100)
	end

	player.aosplayers[aospn].health = $1 - damage
	player.aosplayers[aospn].redhealth = damage/2	// Probably not accurate
	if not(player.aosplayers[aospn].character == 1)	// Not soniguri
		player.aosplayers[aospn].knockbacktime = TICRATE/2
		if not(kbx == nil)
			or(kby == nil)
			local angle = R_PointToAngle2(kbx, kby, player.aosplayers[aospn].x, player.aosplayers[aospn].y)
			local speed = 2*FRACUNIT
			if not(kbs == nil)
				speed = kbs
			end
			player.aosplayers[aospn].knockbackmomx = FixedMul(cos(angle), speed)
			player.aosplayers[aospn].knockbackmomy = FixedMul(sin(angle), speed)
		end
	end
	if(player.aosplayers[aospn].health <= 0)
		player.aosplayers[aospn].deathtimer = 1
	end
	if(aospn < 32)
		player.aosplayers[aospn].shieldtime = TICRATE*3/2
	end
	AOSPlaySound(player, sfx_sghit)
end)

local deathtime = TICRATE

local function AOSPlayerThinker(player, aosp, cmd, aospn)

	if not(aosp.exists)
		return
	end

	if(player.startcuttime == startcuttime)
		aosp.target = 32
		S_StartSound(nil, sfx_sgtarg, players[player.clients[aospn]])
	end

	local prvnum = maxprev-1
	while(prvnum > 0)
		aosp.prevx[prvnum] = aosp.prevx[prvnum-1]
		aosp.prevy[prvnum] = aosp.prevy[prvnum-1]
		aosp.prevframe[prvnum] = aosp.prevframe[prvnum-1]
		aosp.prevangle[prvnum] = aosp.prevangle[prvnum-1]
		aosp.prevflip[prvnum] = aosp.prevflip[prvnum-1]
		prvnum = $1 - 1
	end
	aosp.prevx[0] = aosp.x
	aosp.prevy[0] = aosp.y
	aosp.prevframe[0] = playerinfo[aosp.character].animations[aosp.animation].frames[aosp.frame]
	aosp.prevangle[0] = aosp.drawdirection
	aosp.prevflip[0] = aosp.facingdir

	if(player.startcuttime < startcuttime)
		cmd.buttons = 0
		cmd.forwardmove = 0
		cmd.sidemove = 0
	end

	if(aosp.deathtimer)
		// Animation!
		setPAnim(aosp, 4)

		aosp.animtime = $1 + 1
		if(aosp.animtime > playerinfo[aosp.character].animations[aosp.animation].speed)
			aosp.frame = $1 + 1
			aosp.animtime = 0
			if(aosp.frame >= playerinfo[aosp.character].animations[aosp.animation].numframes)
				aosp.animation = playerinfo[aosp.character].animations[aosp.animation].nextanim
				aosp.frame = 0
			end
		end

		aosp.deathtimer = $1 + 1
		if(aosp.deathtimer == deathtime)
			AOSPlaySound(player, sfx_sgdie)

			local bnum = 0
			while(bnum < deatheffnum)
				local obj = createAOSObject(player)
				player.aosobjects[obj].type = OBJ_DEATHBALL
				player.aosobjects[obj].x = aosp.x
				player.aosobjects[obj].y = aosp.y
				player.aosobjects[obj].angle = FixedAngle((360*FRACUNIT*bnum)/20)
				player.aosobjects[obj].alttimer = (bnum*4319)%3

				local speed = P_RandomRange((FRACUNIT/5), FRACUNIT)*5
				player.aosobjects[obj].momx = FixedMul(cos(player.aosobjects[obj].angle), speed)
				player.aosobjects[obj].momy = FixedMul(sin(player.aosobjects[obj].angle), speed)

				player.aosobjects[obj].parent = aospn
				bnum = $1 + 1
			end
		end
		return
	end
	local inputdir = R_PointToAngle2(0, 0, cmd.sidemove*FRACUNIT, cmd.forwardmove*FRACUNIT)
	inputdir = $1 + FixedAngle(45*FRACUNIT/2)
	local direction = AngleFixed(inputdir)/(45*FRACUNIT)

	if(aosp.shieldtime)
		if(aosp.shieldtime > 0)
			aosp.shieldtime = $1 - 1
		else
			aosp.shieldtime = $1 + 1
		end
	end

	if(player.aosplayers[32].currentattack == 4)
		or(player.aosplayers[32].currentattack == 27)
		aosp.target = -1
	end

	// Targeting
/*	if(player.numplayers > 2)
		if((cmd.buttons & BT_FIRENORMAL) and not(aosp.prevbutt & BT_FIRENORMAL))
			or(player.aosplayers[aosp.target].deathtimer >= deathtime)
			if(player.clients[aospn] >= 0)
				S_StartSound(nil, sfx_sgtarg, players[player.clients[aospn]])
			end
			aosp.target = ($1 + 1)%player.numplayers
			if(player.aosplayers[aosp.target].deathtimer >= deathtime)
				aosp.target = ($1 + 1)%player.numplayers
			end
			if(aosp.target == aospn)
				aosp.target = ($1 + 1)%player.numplayers
			end
			if(player.aosplayers[aosp.target].deathtimer >= deathtime)
				aosp.target = ($1 + 1)%player.numplayers
			end
		end
	else*/if((cmd.buttons & BT_FIRENORMAL) and not(aosp.prevbutt & BT_FIRENORMAL))
		and not(player.aosplayers[32].currentattack == 4)
		and not(player.aosplayers[32].currentattack == 5)
		and not(player.aosplayers[32].currentattack == 27)
		if(aosp.target >= 0)
			aosp.target = -1
		else
			aosp.target = 32
			S_StartSound(nil, sfx_sgtarg, players[player.clients[aospn]])
		end
	//	S_StartSound(nil, sfx_sgtarg, players[player.clients[aospn]])
	end

	local moving = R_PointToDist2(0, 0, cmd.sidemove*FRACUNIT, cmd.forwardmove*FRACUNIT) > deadzone*FRACUNIT

	if(cmd.buttons & BT_ATTACK)
		and not(aosp.prevbutt & BT_ATTACK)
		and not(aosp.dashing == 1)
		and(aosp.candashcancel or not aosp.currentattack)
		and not(aosp.knockbacktime)
		aosp.canmove = true
		AOSPlaySound(player, sfx_sgdash)
		aosp.adddashspeed = initialdashspeed
		aosp.currentattack = 0
		aosp.canaim = true
		aosp.attacktimer = 0
		aosp.attackvar = 0
		aosp.dashing = 1
		aosp.dashtime = 0
		if(moving)
			aosp.dashdirection = FixedAngle(direction*45*FRACUNIT)
		else
			if(aosp.facingdir == 0)
				aosp.dashdirection = 0
			else
				aosp.dashdirection = FixedAngle(180*FRACUNIT)
			end
		end
		aosp.addmomx = 0
		aosp.addmomy = 0
		aosp.heat = $1 + 30*FRACUNIT
	end

	if not(aosp.lockspeed)
		aosp.movementspeed = 2*FRACUNIT
		aosp.movementspeeddiag = 2*FRACUNIT
	end

	// Animation!
	aosp.animtime = $1 + 1
	if(aosp.animtime > playerinfo[aosp.character].animations[aosp.animation].speed)
		aosp.frame = $1 + 1
		aosp.animtime = 0
		if(aosp.frame >= playerinfo[aosp.character].animations[aosp.animation].numframes)
			aosp.animation = playerinfo[aosp.character].animations[aosp.animation].nextanim
			aosp.frame = 0
		end
	end

	if(aosp.dashing)
		or(aosp.lockspeed)
		if(aosp.dashing == 1)
			or(aosp.lockspeed)
			if not(aosp.dashtime%3)
				and not(aosp.lockspeed)
				local obj = createAOSObject(player)
				player.aosobjects[obj].x = aosp.x
				player.aosobjects[obj].y = aosp.y
				player.aosobjects[obj].angle = aosp.dashdirection
				player.aosobjects[obj].parent = aospn
			end

			aosp.dashtime = $1 + 1

			if(aosp.dashing == 1)
				aosp.heat = $1 + FRACUNIT/4
			end

			if(aosp.adddashspeed > 0)
				aosp.adddashspeed = $1 - (FRACUNIT*3)
			end

			if not(cmd.buttons & BT_ATTACK)
				and not(aosp.lockspeed)
				aosp.dashing = 2
			else
				if not(aosp.lockspeed)
					aosp.movementspeed = (15*FRACUNIT/2)+aosp.adddashspeed
					aosp.addmomx = FixedMul(cos(aosp.dashdirection), (15*FRACUNIT/2))
					aosp.addmomy = FixedMul(sin(aosp.dashdirection), (15*FRACUNIT/2))
				end
				aosp.x = $1 + FixedMul(cos(aosp.dashdirection), aosp.movementspeed)
				aosp.y = $1 + FixedMul(sin(aosp.dashdirection), aosp.movementspeed)
			end
		else
			if(aosp.dashing and aosp.dashing < TICRATE/5)
				and not(leveltime%3)
				local obj = createAOSObject(player)
				player.aosobjects[obj].x = aosp.x
				player.aosobjects[obj].y = aosp.y
				player.aosobjects[obj].angle = aosp.dashdirection
				player.aosobjects[obj].parent = aospn
			end
			aosp.dashing = $1 + 1
			if(aosp.dashing > maxdash)
				aosp.dashing = 0
			end
		end
	end

	if(aosp.addmomx)
		or(aosp.addmomy)
		local oldmomx = aosp.addmomx
		local oldmomy = aosp.addmomy
		local momdir = R_PointToAngle2(0, 0, aosp.addmomx, aosp.addmomy)
		aosp.addmomx = $1 - FixedMul(cos(momdir), 7*FRACUNIT/(TICRATE/4))
		aosp.addmomy = $1 - FixedMul(sin(momdir), 7*FRACUNIT/(TICRATE/4))
		if(AOSDotProduct(oldmomx, oldmomy, aosp.addmomx, aosp.addmomy) < 0)
			aosp.addmomx = 0
			aosp.addmomy = 0
			aosp.dashing = 0
		end
	end

	if(aosp.heat > 300*FRACUNIT)
		aosp.heat = 300*FRACUNIT
	end

	local addx = 0
	local addy = 0
	if(moving)
		and(aosp.canmove)
		and not(aosp.lockspeed)
		and not(aosp.knockbacktime)
		if not(aosp.dashing == 1)
			local speed = aosp.movementspeeddiag
			if(direction == 0)
				or(direction == 2)
				or(direction == 4)
				or(direction == 6)
				speed = aosp.movementspeed
			end
			if(direction == 0)
				or(direction == 1)
				or(direction == 7)
				addx = speed
				aosp.x = $1 + speed
			elseif(direction == 3)
				or(direction == 4)
				or(direction == 5)
				addx = -speed
				aosp.x = $1 - speed
			end

			if(direction == 1)
				or(direction == 2)
				or(direction == 3)
				addy = speed
				aosp.y = $1 + speed
			elseif(direction == 5)
				or(direction == 6)
				or(direction == 7)
				addy = -speed
				aosp.y = $1 - speed
			end
		else
			local dirtochase = FixedAngle(direction*45*FRACUNIT)
			if(AngleFixed(dirtochase-aosp.dashdirection) < 10*FRACUNIT)
				aosp.dashdirection = dirtochase
			else
				local addmul = 1
				if(abs((AngleFixed(dirtochase)%(360*FRACUNIT))-(AngleFixed(aosp.dashdirection)%(360*FRACUNIT))) > 180*FRACUNIT)
					addmul = -1
				end

				if(AngleFixed(dirtochase)%(360*FRACUNIT) > AngleFixed(aosp.dashdirection)%(360*FRACUNIT))
					aosp.dashdirection = $1 + (FixedAngle(10*FRACUNIT)*addmul)
				else
					aosp.dashdirection = $1 - (FixedAngle(10*FRACUNIT)*addmul)
				end
			end
			// Hacky fix for overshooting our desired angle
			if(AngleFixed(dirtochase-aosp.dashdirection) < 10*FRACUNIT)
				aosp.dashdirection = dirtochase
			end
		end
	end

	if not(aosp.dashing == 1)
		aosp.x = $1 + aosp.addmomx
		aosp.y = $1 + aosp.addmomy
	end

	if(aosp.knockbacktime)
		aosp.canmove = true
		aosp.lockspeed = false
		aosp.dashing = 0
		aosp.currentattack = 0
		aosp.canaim = true
		aosp.attacktimer = 0
		aosp.attackvar = 0
		aosp.x = $1 + aosp.knockbackmomx
		aosp.y = $1 + aosp.knockbackmomy
		aosp.knockbacktime = $1 - 1
	elseif not(aosp.dashing == 1)
		aosp.heat = $1 - FRACUNIT*60/35
		if(aosp.heat < 0)
			aosp.heat = 0
		end
	end

	// Attacking!
	if(cmd.buttons & BT_CUSTOM1)
		and not(aosp.prevbutt & BT_CUSTOM1)
		and(aosp.hyper >= FRACUNIT)
		aosp.canmove = true
		aosp.lockspeed = false
		aosp.dashing = 0
		aosp.canaim = true
		aosp.currentattack = 5
		if(cmd.buttons & BT_USE)
			aosp.currentattack = 6
	//	elseif(cmd.buttons & BT_CUSTOM2)
	//		aosp.currentattack = 7
		end
		aosp.attacktimer = 0
		aosp.attackvar = 0
		aosp.hyper = $1 - FRACUNIT
	elseif not(aosp.currentattack)
		and not(aosp.knockbacktime)
	//	and(player.aostimer <= 177*TICRATE)
		aosp.lockspeed = false
		if(cmd.buttons & BT_CUSTOM2)
			and not(aosp.prevbutt & BT_CUSTOM2)
			aosp.currentattack = 3
			aosp.attacktimer = 0
			aosp.attackvar = 0
		/*	if(cmd.buttons & BT_JUMP)
				and not(aosp.prevbutt & BT_JUMP)
				aosp.currentattack = 3
				aosp.attacktimer = 0
				aosp.attackvar = 0
			elseif(cmd.buttons & BT_USE)
				and not(aosp.prevbutt & BT_USE)
				aosp.currentattack = 4
				aosp.attacktimer = 0
				aosp.attackvar = 0
			end*/
		else
			if(cmd.buttons & BT_JUMP)
				and not(aosp.prevbutt & BT_JUMP)
				aosp.currentattack = 1
				aosp.attacktimer = 0
				aosp.attackvar = 0
			elseif(cmd.buttons & BT_USE)
				and not(aosp.prevbutt & BT_USE)
				aosp.currentattack = 2
				aosp.attacktimer = 0
				aosp.attackvar = 0
			end
		end
	end

	// Animation 2
	if not(aosp.currentattack)
		if(aosp.knockbacktime)
			setPAnim(aosp, 3)
			aosp.drawdirection = R_PointToAngle2(0, 0, -aosp.knockbackmomx, -aosp.knockbackmomy)

			if(aosp.knockbackmomx > 0)
				aosp.facingdir = 1
			else
				aosp.facingdir = 0
			end
		elseif(aosp.dashing)
			if(aosp.dashing == 1)
				aosp.drawdirection = aosp.dashdirection
			else
				aosp.drawdirection = R_PointToAngle2(0, 0, aosp.addmomx + addx, aosp.addmomy + addy)
			end
			if(player.aosplayers[aosp.target])
				and(aosp.target >= 0)
				and(aosp.cantarget)
				aosp.shootdirection = R_PointToAngle2(aosp.x, aosp.y, player.aosplayers[aosp.target].x, player.aosplayers[aosp.target].y)
			else
				aosp.shootdirection = FixedAngle(direction*45*FRACUNIT)
			end
			setPAnim(aosp, 2)
		else
			if(moving)
				setPAnim(aosp, 1)
			else
				setPAnim(aosp, 0)
			end
			if(player.aosplayers[aosp.target])
				and(aosp.target >= 0)
				and(aosp.cantarget)
				aosp.drawdirection = R_PointToAngle2(aosp.x, aosp.y, player.aosplayers[aosp.target].x, player.aosplayers[aosp.target].y)
				aosp.shootdirection = aosp.drawdirection
			elseif(moving)
				aosp.drawdirection = FixedAngle(direction*45*FRACUNIT)
				aosp.shootdirection = aosp.drawdirection
			end
		end
	elseif(aosp.canaim)
		if not(aosp.animation == 2)
			if(player.aosplayers[aosp.target])
				and(aosp.target >= 0)
				and(aosp.cantarget)
				aosp.drawdirection = R_PointToAngle2(aosp.x, aosp.y, player.aosplayers[aosp.target].x, player.aosplayers[aosp.target].y)
				aosp.shootdirection = aosp.drawdirection
			elseif(moving)
				aosp.drawdirection = FixedAngle(direction*45*FRACUNIT)
				aosp.shootdirection = aosp.drawdirection
			end
		end
	end

	if(aosp.currentattack)
		playerinfo[aosp.character].attacks[aosp.currentattack-1](player, aosp, cmd, cmd.buttons, aospn)
	else
		if(aosp.beamammo < FRACUNIT)
			aosp.beamammo = $1 + FRACUNIT/55
			if(aosp.beamammo > FRACUNIT)
				aosp.beamammo = FRACUNIT
			end
		end
		if(aosp.ballisticammo < FRACUNIT)
			aosp.ballisticammo = $1 + FRACUNIT/55
			if(aosp.ballisticammo > FRACUNIT)
				aosp.ballisticammo = FRACUNIT
			end
		end
	end

	// Moving past the circle?
	if(R_PointToDist2(0, 0, aosp.x, aosp.y) > player.arenaradius)
		// Stay inside of it!
		local angle = R_PointToAngle2(0, 0, aosp.x, aosp.y)
		aosp.x = FixedMul(cos(angle), player.arenaradius)
		aosp.y = FixedMul(sin(angle), player.arenaradius)
	end

	// Collision!
	local onum = 0
	while(onum < maxobjects)
		if(player.aosobjects[onum].exists)
			and not(player.aosobjects[onum].width == 0)
			and not(player.aosobjects[onum].height == 0)
			local col
			if(player.aosobjects[onum].spherecollision)
				if(R_PointToDist2(aosp.x, aosp.y, player.aosobjects[onum].x, player.aosobjects[onum].y) < (aosp.width/2)+(player.aosobjects[onum].width/2))
					col = true
				else
					col = false
				end
			else
				col = AOSTestCollision(aosp.x, aosp.y, aosp.width, aosp.height, 0, player.aosobjects[onum].x, player.aosobjects[onum].y, player.aosobjects[onum].width, player.aosobjects[onum].height, player.aosobjects[onum].angle)
			end
			if(col)
				and(objinfo[player.aosobjects[onum].type])
				and not(objinfo[player.aosobjects[onum].type].playercollide == nil)
				objinfo[player.aosobjects[onum].type].playercollide(player, onum, aospn)
			end
		end
		onum = $1 + 1
	end

//	aosp.cantarget = false

	if not(aosp.knockbacktime)
		if(player.aosplayers[aosp.target])
			and(aosp.target >= 0)
			and(aosp.cantarget)
			if(aosp.x > player.aosplayers[aosp.target].x)
				aosp.facingdir = 1
			else
				aosp.facingdir = 0
			end
		else
			if(aosp.dashing == 1)
				if(cos(aosp.dashdirection) < 0)
					aosp.facingdir = 1
				else
					aosp.facingdir = 0
				end
			else
			/*	if(moving)
					if(direction == 0)
						or(direction == 1)
						or(direction == 7)
						aosp.facingdir = 0
					elseif(direction == 3)
						or(direction == 4)
						or(direction == 5)
						aosp.facingdir = 1
					end
				end*/
				if(aosp.currentattack)
					if(cos(aosp.drawdirection) < 0)
						aosp.facingdir = 1
					elseif(cos(aosp.drawdirection) > 0)
						aosp.facingdir = 0
					end
				else
					if(aosp.x > player.aosplayers[32].x)
						aosp.facingdir = 1
					else
						aosp.facingdir = 0
					end
				end
			end
		end
	end

	// Stay on screen!
	if(player.aosplayers[32].currentattack == 27)
		// Right
		if(FixedMul(aosp.x-player.aoscamx, player.aoscamscale) > 160*FRACUNIT)
			aosp.x = FixedDiv(160*FRACUNIT, player.aoscamscale)+player.aoscamx
		end

		// Left
		if(FixedMul(aosp.x-player.aoscamx, player.aoscamscale) < -160*FRACUNIT)
			aosp.x = FixedDiv(-160*FRACUNIT, player.aoscamscale)+player.aoscamx
		end

		// Up
		if(FixedMul(aosp.y+player.aoscamy, player.aoscamscale) > 100*FRACUNIT)
			aosp.y = FixedDiv(100*FRACUNIT, player.aoscamscale)-player.aoscamy
		end

		// Down
		if(FixedMul(aosp.y+player.aoscamy, player.aoscamscale) < -100*FRACUNIT)
			aosp.y = FixedDiv(-100*FRACUNIT, player.aoscamscale)-player.aoscamy
		end
	end

	aosp.prevbutt = cmd.buttons
end

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

local function AOSSoniguriThinker(player, aosp, aospn)
	local prvnum = maxprev-1
	while(prvnum > 0)
		aosp.prevx[prvnum] = aosp.prevx[prvnum-1]
		aosp.prevy[prvnum] = aosp.prevy[prvnum-1]
		aosp.prevframe[prvnum] = aosp.prevframe[prvnum-1]
		aosp.prevangle[prvnum] = aosp.prevangle[prvnum-1]
		aosp.prevflip[prvnum] = aosp.prevflip[prvnum-1]
		prvnum = $1 - 1
	end
	aosp.prevx[0] = aosp.x
	aosp.prevy[0] = aosp.y
	aosp.prevframe[0] = playerinfo[aosp.character].animations[aosp.animation].frames[aosp.frame]
	aosp.prevangle[0] = aosp.drawdirection
	aosp.prevflip[0] = aosp.facingdir

	if(player.startcuttime < startcuttime)
		// Animation!
		if(player.startcuttime == 18+15)
			setPAnim(aosp, 7)
		end
		aosp.animtime = $1 + 1
		if(aosp.animtime > playerinfo[aosp.character].animations[aosp.animation].speed)
			aosp.frame = $1 + 1
			aosp.animtime = 0
			if(aosp.frame >= playerinfo[aosp.character].animations[aosp.animation].numframes)
				aosp.animation = playerinfo[aosp.character].animations[aosp.animation].nextanim
				aosp.frame = 0
			end
		end

		if(aosp.x > player.aosplayers[aosp.target].x)
			aosp.drawdirection = FixedAngle(180*FRACUNIT)
			aosp.facingdir = 1
		else
			aosp.drawdirection = 0
			aosp.facingdir = 0
		end

		if(player.startcuttime+1 == startcuttime)
			setPAnim(aosp, 0)
		end

		return
	end

	if(aosp.deathtimer)
		// Animation!
		setPAnim(aosp, 4)

		aosp.animtime = $1 + 1
		if(aosp.animtime > playerinfo[aosp.character].animations[aosp.animation].speed)
			aosp.frame = $1 + 1
			aosp.animtime = 0
			if(aosp.frame >= playerinfo[aosp.character].animations[aosp.animation].numframes)
				aosp.animation = playerinfo[aosp.character].animations[aosp.animation].nextanim
				aosp.frame = 0
			end
		end

		if(leveltime & 1)
			aosp.deathtimer = $1 + 1
			if(aosp.deathtimer == deathtime)
				AOSPlaySound(player, sfx_sgdie)
				local bnum = 0
				while(bnum < deatheffnum)
					local obj = createAOSObject(player)
					player.aosobjects[obj].type = OBJ_DEATHBALL
					player.aosobjects[obj].x = aosp.x
					player.aosobjects[obj].y = aosp.y
					player.aosobjects[obj].angle = FixedAngle((360*FRACUNIT*bnum)/20)
					player.aosobjects[obj].alttimer = (bnum*4319)%3

					local speed = P_RandomRange((FRACUNIT/5), FRACUNIT)*5
					player.aosobjects[obj].momx = FixedMul(cos(player.aosobjects[obj].angle), speed)
					player.aosobjects[obj].momy = FixedMul(sin(player.aosobjects[obj].angle), speed)

					player.aosobjects[obj].parent = aospn
					bnum = $1 + 1
				end

				// Add remaining health to score for all players!
				local pnum = 0
				while(pnum < player.numplayers)
					if(player.clients[pnum] >= 0 and players[player.clients[pnum]] and players[player.clients[pnum]].valid)
						if not(modeattacking)
							// It'd suck to have the last digit not be 0...
							local usescore = player.aosplayers[pnum].health/10
							P_AddPlayerScore(players[player.clients[pnum]], usescore*10)
						else
							P_AddPlayerScore(players[player.clients[pnum]], player.aosplayers[pnum].health)
						end
					end
					pnum = $1 + 1
				end
			end
		end

		if(aosp.deathtimer > deathtime * 2)
			G_ExitLevel()
		end

		if(aosp.currentattack)
			playerinfo[aosp.character].attacks[aosp.currentattack-1](player, aosp, nil, nil, aospn)
		end
		return
	end
	local direction = R_PointToAngle2(aosp.x, aosp.y, player.aosplayers[aosp.target].x, player.aosplayers[aosp.target].y)
	if(aosp.lockspeed)
		direction = aosp.dashdirection
	end

	if(aosp.shieldtime)
		if(aosp.shieldtime > 0)
			aosp.shieldtime = $1 - 1
		else
			aosp.shieldtime = $1 + 1
		end
	end

	local moving = true
	local shoulddash = false

	if not(player.aosplayers[aosp.target].exists)
		or(player.aosplayers[aosp.target].deathtimer)
		aosp.target = 0
		getRandomTarget(player, aosp)
	end

	// Attacks (earlier than normal players)
	if not(aosp.currentattack)
		getRandomTarget(player, aosp)
		if(aosp.health <= 3000)		// Last phase
			aosp.currentattack = 3
			aosp.dashdirection = direction	// Prevent soniguri from going in an endless circle
		elseif(aosp.health <= 6000)
			if(player.soniguriphase == 0)
				player.soniguriphase = 1
				player.soniguriattack = 0
				aosp.currentattack = 27
				// Reset rng so this attack is the same every time
				local rng = A_SeedRng_Get()
				player.seedrngstate = rng.Create(true, 1, 2, 3, 4)
				player.targetseedrngstate = rng.Create(true, 1, 2, 3, 4)
			else
				aosp.currentattack = sonigmovelistp2[player.soniguriattack]
				player.soniguriattack = ($1 + 1)%sonigmovecountp2
			end
		else
			aosp.currentattack = sonigmovelistp1[player.soniguriattack]
			player.soniguriattack = ($1 + 1)%sonigmovecountp1
		end
	//	aosp.currentattack = 2		// Dash rockets
	end

	if(aosp.currentattack == 3)
		direction = R_PointToAngle2(aosp.x, aosp.y, 0, 0)

		if(R_PointToDist2(aosp.x, aosp.y, 0, 0) < aosp.movementspeed)
			aosp.x = 0
			aosp.y = 0
			aosp.currentattack = 4
			aosp.attacktimer = 0
			AOSPlaySound(player, sfx_sgacel)
			moving = false
		end
	end

	if(aosp.currentattack == 13)
		if not(aosp.attacktimer)
			player.soniguriangle = R_PointToAngle2(0, 0, aosp.x, aosp.y)
			aosp.attacktimer = 1
		end

		direction = R_PointToAngle2(aosp.x, aosp.y, FixedMul(cos(player.soniguriangle), player.arenaradius), FixedMul(sin(player.soniguriangle), player.arenaradius))

		if(R_PointToDist2(aosp.x, aosp.y, 0, 0) > player.arenaradius-aosp.width)
			player.soniguriangle = R_PointToAngle2(0, 0, aosp.x, aosp.y)
			aosp.x = FixedMul(cos(player.soniguriangle), player.arenaradius-aosp.width)
			aosp.y = FixedMul(sin(player.soniguriangle), player.arenaradius-aosp.width)
			aosp.currentattack = 14
			aosp.attacktimer = 0
			AOSPlaySound(player, sfx_sghypr)
			moving = false
		end
	end

	if(aosp.currentattack == 25)
		if not(aosp.attacktimer)
			player.soniguriangle = R_PointToAngle2(0, 0, aosp.x, aosp.y)
			aosp.attacktimer = 1
		end

		direction = R_PointToAngle2(aosp.x, aosp.y, FixedMul(cos(player.soniguriangle), player.arenaradius), FixedMul(sin(player.soniguriangle), player.arenaradius))

		if(R_PointToDist2(aosp.x, aosp.y, 0, 0) > player.arenaradius-aosp.width)
			player.soniguriangle = R_PointToAngle2(0, 0, aosp.x, aosp.y)
			aosp.x = FixedMul(cos(player.soniguriangle), player.arenaradius-aosp.width)
			aosp.y = FixedMul(sin(player.soniguriangle), player.arenaradius-aosp.width)
			aosp.currentattack = 26
			aosp.attacktimer = 0
			AOSPlaySound(player, sfx_sghypr)
			moving = false
		end
	end

	if(aosp.currentattack == 27)
		direction = R_PointToAngle2(aosp.x, aosp.y, 0, player.arenaradius+(aosp.width*7))
		if(player.sonigurichaseobj >= 0)
			and(player.aosobjects[player.sonigurichaseobj])
			and(player.aosobjects[player.sonigurichaseobj].exists)
			aosp.x = player.aosobjects[player.sonigurichaseobj].x
			aosp.y = player.aosobjects[player.sonigurichaseobj].y
			aosp.dashdirection = player.aosobjects[player.sonigurichaseobj].angle
			aosp.drawdirection = aosp.dashdirection
		else
			aosp.dashdirection = direction
		end
	end

	if(aosp.currentattack == 4)
		or(aosp.currentattack == 6)
		or(aosp.currentattack == 7)
		or(aosp.currentattack == 14)
		or(aosp.currentattack == 26)
		moving = false
	end

	if(aosp.currentattack == 2)
		or(aosp.currentattack == 3 and aosp.attacktimer)
		or(aosp.currentattack == 9)
		or(aosp.currentattack == 13)
		or(aosp.currentattack == 17)
		or(aosp.currentattack == 22)
		or(aosp.currentattack == 23)
		or(aosp.currentattack == 25 and R_PointToDist2(aosp.x, aosp.y, 0, 0) < player.arenaradius-(aosp.width*7))
		shoulddash = true
	end

	if(aosp.currentattack == 15)
		or(aosp.currentattack == 16)
		if(R_PointToDist2(aosp.x, aosp.y, player.aosplayers[aosp.target].x, player.aosplayers[aosp.target].y) < 120*FRACUNIT)
			aosp.currentattack = $1 - 4
		else
			shoulddash = true
		end
	end

	if(shoulddash)
		and not(aosp.dashing == 1)
		aosp.canmove = true
		AOSPlaySound(player, sfx_sgdash)
		aosp.dashing = 1
		aosp.dashdirection = direction
		aosp.addmomx = 0
		aosp.addmomy = 0
	end

	if not(aosp.lockspeed)
		aosp.movementspeed = FRACUNIT
		aosp.movementspeeddiag = FRACUNIT
		if(aosp.currentattack == 27)
			aosp.movementspeed = $1 * 3
			aosp.movementspeeddiag = $1 * 3
		end
	end

	// Animation!
	aosp.animtime = $1 + 1
	if(aosp.animtime > playerinfo[aosp.character].animations[aosp.animation].speed)
		aosp.frame = $1 + 1
		aosp.animtime = 0
		if(aosp.frame >= playerinfo[aosp.character].animations[aosp.animation].numframes)
			aosp.animation = playerinfo[aosp.character].animations[aosp.animation].nextanim
			aosp.frame = 0
		end
	end

	if(aosp.dashing)
		or(aosp.lockspeed)
		if(aosp.dashing == 1)
			or(aosp.lockspeed)
			if not(leveltime%4)
				and not(aosp.lockspeed)
				local obj = createAOSObject(player)
				player.aosobjects[obj].x = aosp.x
				player.aosobjects[obj].y = aosp.y
				player.aosobjects[obj].angle = aosp.dashdirection
				player.aosobjects[obj].parent = aospn
			end

			if not(shoulddash)
				aosp.dashing = 0
			else
				if not(aosp.lockspeed)
					if(aosp.currentattack == 3)
						or(aosp.currentattack == 9)
						aosp.movementspeed = 10*FRACUNIT/2
					elseif(aosp.currentattack == 22)
						aosp.movementspeed = 11*FRACUNIT/2
					else
						aosp.movementspeed = 12*FRACUNIT/2
					end
					aosp.addmomx = FixedMul(cos(aosp.dashdirection), aosp.movementspeed)
					aosp.addmomy = FixedMul(sin(aosp.dashdirection), aosp.movementspeed)
				end
				aosp.x = $1 + FixedMul(cos(aosp.dashdirection), aosp.movementspeed)
				aosp.y = $1 + FixedMul(sin(aosp.dashdirection), aosp.movementspeed)
			end
		else
			aosp.dashing = 0
		end
	end

	if(aosp.addmomx)
		or(aosp.addmomy)
		local oldmomx = aosp.addmomx
		local oldmomy = aosp.addmomy
		local momdir = R_PointToAngle2(0, 0, aosp.addmomx, aosp.addmomy)
		aosp.addmomx = $1 - FixedMul(cos(momdir), 7*FRACUNIT/(TICRATE/4))
		aosp.addmomy = $1 - FixedMul(sin(momdir), 7*FRACUNIT/(TICRATE/4))
		if(AOSDotProduct(oldmomx, oldmomy, aosp.addmomx, aosp.addmomy) < 0)
			aosp.addmomx = 0
			aosp.addmomy = 0
			aosp.dashing = 0
		end
	end

	local addx = 0
	local addy = 0
	if(moving)
		if not(aosp.dashing == 1)
			addx = FixedMul(cos(direction), aosp.movementspeed)
			addy = FixedMul(sin(direction), aosp.movementspeed)
			aosp.x = $1 + addx
			aosp.y = $1 + addy
		else
			local dirtochase = direction
			if(AngleFixed(dirtochase-aosp.dashdirection) < 10*FRACUNIT)
				aosp.dashdirection = dirtochase
			else
				local addmul = 1
				if(abs((AngleFixed(dirtochase)%(360*FRACUNIT))-(AngleFixed(aosp.dashdirection)%(360*FRACUNIT))) > 180*FRACUNIT)
					addmul = -1
				end

				if(AngleFixed(dirtochase)%(360*FRACUNIT) > AngleFixed(aosp.dashdirection)%(360*FRACUNIT))
					aosp.dashdirection = $1 + (FixedAngle(10*FRACUNIT)*addmul)
				else
					aosp.dashdirection = $1 - (FixedAngle(10*FRACUNIT)*addmul)
				end
			end
			// Hacky fix for overshooting our desired angle
			if(AngleFixed(dirtochase-aosp.dashdirection) < 10*FRACUNIT)
				aosp.dashdirection = dirtochase
			end
		end
	end

	if not(aosp.dashing == 1)
		aosp.x = $1 + aosp.addmomx
		aosp.y = $1 + aosp.addmomy
	end

	// Animation 2
	if not(aosp.currentattack)
		or(aosp.dashing)
		if(aosp.knockbacktime)
			setPAnim(aosp, 3)
		elseif(aosp.dashing)
			if(aosp.dashing == 1)
				aosp.drawdirection = aosp.dashdirection
			else
				aosp.drawdirection = R_PointToAngle2(0, 0, aosp.addmomx + addx, aosp.addmomy + addy)
			end
			if(player.aosplayers[aosp.target])
				and(aosp.target >= 0)
				and(aosp.cantarget)
				aosp.shootdirection = R_PointToAngle2(aosp.x, aosp.y, player.aosplayers[aosp.target].x, player.aosplayers[aosp.target].y)
			else
				aosp.shootdirection = FixedAngle(direction*45*FRACUNIT)
			end
			setPAnim(aosp, 2)
		else
			if(moving)
				setPAnim(aosp, 1)
			else
				setPAnim(aosp, 0)
			end
			if(player.aosplayers[aosp.target])
				and(aosp.target >= 0)
				and(aosp.cantarget)
				aosp.drawdirection = R_PointToAngle2(aosp.x, aosp.y, player.aosplayers[aosp.target].x, player.aosplayers[aosp.target].y)
				aosp.shootdirection = aosp.drawdirection
			elseif(moving)
				aosp.drawdirection = FixedAngle(direction*45*FRACUNIT)
				aosp.shootdirection = aosp.drawdirection
			end
		end
	elseif not(aosp.currentattack == 27)
		if(aosp.currentattack == 14)
			or(aosp.currentattack == 26)
			aosp.drawdirection = player.soniguriangle+FixedAngle(180*FRACUNIT)
		elseif not(aosp.currentattack == 6)
			and not(aosp.currentattack == 7)
			if not(aosp.animation == 2)
				if(player.aosplayers[aosp.target])
					and(aosp.target >= 0)
					and(aosp.cantarget)
					aosp.drawdirection = R_PointToAngle2(aosp.x, aosp.y, player.aosplayers[aosp.target].x, player.aosplayers[aosp.target].y)
					aosp.shootdirection = aosp.drawdirection
				elseif(moving)
					aosp.drawdirection = FixedAngle(direction*45*FRACUNIT)
					aosp.shootdirection = aosp.drawdirection
				end
			end
		elseif(aosp.currentattack == 7)
			aosp.shootdirection = R_PointToAngle2(aosp.x, aosp.y, player.aosplayers[aosp.target].x, player.aosplayers[aosp.target].y)
		end
	end

	if(aosp.currentattack)
		playerinfo[aosp.character].attacks[aosp.currentattack-1](player, aosp, nil, nil, aospn)
	end

	// Moving past the circle?
	if(R_PointToDist2(0, 0, aosp.x, aosp.y) > player.arenaradius)
		// Stay inside of it!
		local angle = R_PointToAngle2(0, 0, aosp.x, aosp.y)
		aosp.x = FixedMul(cos(angle), player.arenaradius)
		aosp.y = FixedMul(sin(angle), player.arenaradius)
	end

	// Collision!
	local onum = 0
	while(onum < maxobjects)
		if(player.aosobjects[onum].exists)
			and not(player.aosobjects[onum].width == 0)
			and not(player.aosobjects[onum].height == 0)
			local col = AOSTestCollision(aosp.x, aosp.y, aosp.width, aosp.height, 0, player.aosobjects[onum].x, player.aosobjects[onum].y, player.aosobjects[onum].width, player.aosobjects[onum].height, player.aosobjects[onum].angle)
			if(col)
				and(objinfo[player.aosobjects[onum].type])
				and not(objinfo[player.aosobjects[onum].type].playercollide == nil)
				objinfo[player.aosobjects[onum].type].playercollide(player, onum, aospn)
			end
		end
		onum = $1 + 1
	end

//	aosp.cantarget = false

	if(aosp.currentattack == 14)
		or(aosp.currentattack == 26)
		if(cos(aosp.drawdirection) < 0)
			aosp.facingdir = 1
		else
			aosp.facingdir = 0
		end
	elseif(player.aosplayers[aosp.target])
		and(aosp.target >= 0)
		and(aosp.cantarget)
		if(aosp.x > player.aosplayers[aosp.target].x)
			aosp.facingdir = 1
		else
			aosp.facingdir = 0
		end
	else
		if(aosp.dashing == 1)
			if(cos(aosp.dashdirection) < 0)
				aosp.facingdir = 1
			else
				aosp.facingdir = 0
			end
		else
			if(moving)
				if(direction == 0)
					or(direction == 1)
					or(direction == 7)
					aosp.facingdir = 0
				elseif(direction == 3)
					or(direction == 4)
					or(direction == 5)
					aosp.facingdir = 1
				end
			end
			if(aosp.currentattack)
				if(cos(aosp.drawdirection) < 0)
					aosp.facingdir = 1
				elseif(cos(aosp.drawdirection) > 0)
					aosp.facingdir = 0
				end
			end
		end
	end
end

rawset(_G, "setAnim", function(obj, anim)
	if not(obj.animation == anim)
		obj.animtime = 0
		obj.frame = 0
	end
	obj.animation = anim
end)

rawset(_G, "setSubAnim", function(obj, anim)
	if not(obj.subanimation == anim)
		obj.subanimtime = 0
		obj.subframe = 0
	end
	obj.subanimation = anim
end)

rawset(_G, "AOSObjectThinker", function(player, objectnum)
	local object = player.aosobjects[objectnum]
	if(objinfo[object.type])
		and not(objinfo[object.type].thinker == nil)
		objinfo[object.type].thinker(player, objectnum)
	end

	// Momentum!
	object.x = $1 + object.momx
	object.y = $1 + object.momy

	// Animation!
	object.animtime = $1 + 1
	if(object.animtime > animinfo[object.animation].speed)
		object.frame = $1 + 1
		object.animtime = 0
		if(object.frame >= animinfo[object.animation].numframes)
			object.animation = animinfo[object.animation].nextanim
			object.frame = 0
		end
	end

	// For sub objects too!
	if(object.hassub)
		object.subanimtime = $1 + 1
		if(object.subanimtime > animinfo[object.subanimation].speed)
			object.subframe = $1 + 1
			object.subanimtime = 0
			if(object.subframe >= animinfo[object.subanimation].numframes)
				object.subanimation = animinfo[object.subanimation].nextanim
				object.subframe = 0
			end
		end
	end
end)

local nocmd = {}
nocmd.buttons = 0
nocmd.sidemove = 0
nocmd.forwardmove = 0

// From Arle Puyo Pop Tsuu
local function RemoveFromTable(table, pos, length)
	local table2 = table
	local pos2 = pos
	while(pos2+1 < length)
		table2[pos2] = table2[pos2+1]
		pos2 = $1 + 1
	end
	return table2
end

// Also from Arle Puyo Pop Tsuu
local function JoinPlayer(player, host)
	player.host = host
	local pnum = 0
	while(pnum < 32)
		if(players[player.host].clients[pnum] == #player)	// Don't add ourself to the list!
			return
		end
		if(players[player.host].clients[pnum] == -1)
			player.clientnum = pnum
			players[player.host].clients[pnum] = #player
			return
		end
		pnum = $1 + 1
	end
end

local huddisabled = false

addHook("ThinkFrame", function()
	// Enabling and disabling the hud
	if(mapheaderinfo[gamemap].aosoniguri)
		if not(huddisabled)
			hud.disable("stagetitle")
			hud.disable("score")
			hud.disable("time")
			hud.disable("rings")
			hud.disable("lives")
			hud.disable("coopemeralds")
			hud.disable("tabemblems")
			huddisabled = true
		end
	elseif(huddisabled)
		hud.enable("stagetitle")
		hud.enable("score")
		hud.enable("time")
		hud.enable("rings")
		hud.enable("lives")
		hud.enable("coopemeralds")
		hud.enable("tabemblems")
		huddisabled = false
	end


	for player in players.iterate
		if(mapheaderinfo[gamemap].aosoniguri)
			if(player.aoscamscale == nil)
				player.aoscamscale = FRACUNIT
			end
			if(player.aoscamx == nil)
				player.aoscamx = 0
			end
			if(player.aoscamy == nil)
				player.aoscamy = 0
			end

			if(player.numplayers == nil)
				player.numplayers = 33
			end
			if(player.aosplayers == nil)
				player.aosplayers = {}
			end
			if(player.aosobjects == nil)
				player.aosobjects = {}
			end
			if(player.aostimer == nil)
				player.aostimer = 0
			end
			if(player.arenaradius == nil)
				player.arenaradius = 185*FRACUNIT
			end

			if(player.timeslow == nil)
				player.timeslow = 0
			end
			if(player.gamemode == nil)
				player.gamemode = 6		// 0 = In-game, 1 = Menu, 2 = Lobbies, 3 = In lobby, 4 = Character select, 5 = Options
			end
			if(player.prevcmd == nil)
				player.prevcmd = 0
			end
			if(player.prevside == nil)
				player.prevside = 0
			end
			if(player.prevforward == nil)
				player.prevforward = 0
			end

			if(player.character == nil)
				player.character = 0
			end

			// Menu stuff
			if(player.selection == nil)
				player.selection = 0
			end
			if(player.selmovetime == nil)
				player.selmovetime = 0
			end
			if(player.ready == nil)
				player.ready = false
			end

			if(player.startcuttime == nil)
				player.startcuttime = 0
			end

			if(player.sonigurideathfadetimer == nil)
				player.sonigurideathfadetimer = deathfadetime
			end

			if(player.howtoplayscreen == nil)
				player.howtoplayscreen = 0
			end

			// Lobbies! Like Arle Puyo Pop Tsuu
			if(player.host == nil)
				player.host = 0
			end
			if(player.clients == nil)
				player.clients = {}
				player.clients[0] = #player
				local clnum = 1
				while(clnum < 32)
					if(players[clnum] and players[clnum].valid and not(players[clnum].bot == 1))
						player.clients[clnum] = clnum
					else
						player.clients[clnum] = -1	// -1 = no client
					end
					clnum = $1 + 1
				end
				player.clients[32] = -1
			end
			if(player.leveltimetime == nil)
				player.leveltimetime = 0
			end
			if not(leveltime)
				player.leveltimetime = $1 + 1
			else
				player.leveltimetime = 0
			end
			if not(leveltime)
				and not(#player)
				and(player.leveltimetime == 1)
				AOSStartGame(player, true)
				player.gamemode = 6
				player.sonigurideathfadetimer = deathfadetime
				player.howtoplayscreen = 0
				for player2 in players.iterate
					S_StopMusic(player2)
				end
			end
			if(player.clientnum == nil)
				player.clientnum = #player
			end
			local cnum = 0
			while(cnum < 32)
				if(players[cnum] and players[cnum].valid and not(players[cnum].bot == 1))
					and(players[cnum].host == #player)
					if(player.clients[cnum] == -1)
						player.clients[cnum] = cnum
						createAOSPlayer(player, cnum, 0)	// New player

						// Play music for players who've just joined
						if(players[player.host].startcuttime > startcuttime/2)
							S_StopMusic(player)
							S_ChangeMusic("ICARUS", true, player)
						end
					end
				else
					if(player.clients[cnum] >= 0)
						player.clients[cnum] = -1
						if(player.aosplayers[cnum])	// Fixes a problem with joining.... doesn't seem to matter anyway?
							player.aosplayers[cnum].exists = false
						end
					end
				end
				cnum = $1 + 1
			end
			if(player.gamemode == 0)
				and(#player == player.host)
				if(player.timeslow)
					player.timeslow = $1 - 1
				end
				if not(player.timeslow & 1)
					if(player.startcuttime == startcuttime/3)
						AOSPlaySound(player, sfx_sghypr)
					end
					if(player.startcuttime == startcuttime/2)
						local cnum = 0
						while(cnum < 32)
							if not(player.clients[cnum] == -1)
								S_StopMusic(players[player.clients[cnum]])
								S_ChangeMusic("ICARUS", true, players[player.clients[cnum]])
							end
							cnum = $1 + 1
						end
					end
					player.startcuttime = $1 + 1
					local pnum = 0
					local numalive = 0
					local lastalive = false
					while(pnum < player.numplayers)
						if(player.clients[pnum] >= 0 and players[player.clients[pnum]] and players[player.clients[pnum]].valid)
							AOSPlayerThinker(player, player.aosplayers[pnum], players[player.clients[pnum]].cmd, player.clients[pnum])
							if not(player.aosplayers[pnum].deathtimer > deathtime*2)
								numalive = $1 + 1
							end
							if not(player.aosplayers[pnum].deathtimer > deathtime)
								and not(lastalive)
								player.sonigurilastplayeralive = pnum
								lastalive = true
							end
						elseif(pnum < 32)
							AOSPlayerThinker(player, player.aosplayers[pnum], nocmd, pnum)
						else
							AOSSoniguriThinker(player, player.aosplayers[pnum], pnum)
						end
						pnum = $1 + 1
					end

					if(numalive == 0)
						player.sonigurideathfadetimer = $1 - 1
						if(player.sonigurideathfadetimer == 0)
							AOSStartGame(player, false)
							player.sonigurideathfadetimer = 1
						end
					elseif(player.sonigurideathfadetimer < deathfadetime)
						player.sonigurideathfadetimer = $1 + 4
						if(player.sonigurideathfadetimer > deathfadetime)
							player.sonigurideathfadetimer = deathfadetime
						end
					end

					local rcs = {}
					local numrcs = 0
					local onum = 0
					while(onum < maxobjects)
						if(player.aosobjects[onum].exists)
							AOSObjectThinker(player, onum)
							if(player.aosobjects[onum].type == 0)
								rcs[numrcs] = onum
								numrcs = $1 + 1
							end
						end
						onum = $1 + 1
					end

					// Collision!
					onum = 0
					while(onum < maxobjects)
						if(player.aosobjects[onum].exists)
//							and not(player.aosobjects[onum].width == 0)
//							and not(player.aosobjects[onum].height == 0)
							and(player.aosobjects[onum].canbegrazed)

							// Test for collision with all rcs's!
							local rnum = 0
							while(rnum < numrcs)
								local object = player.aosobjects[rcs[rnum]]
								if not(player.aosobjects[onum].hasbeengrazed[object.parent])
									and not(object.canbegrazed)
									and(object.parent < 32)
									local col
									col = AOSTestCollision(object.x, object.y, object.width, object.height, object.angle, player.aosobjects[onum].x, player.aosobjects[onum].y, player.aosobjects[onum].width, player.aosobjects[onum].height, player.aosobjects[onum].angle)
									if(col)
										AOSPlaySound(player, sfx_sgring)
										local gain = 3
										if(player.aosplayers[object.parent].redhealth < gain)
											player.aosplayers[object.parent].health = $1 + player.aosplayers[object.parent].redhealth
											player.aosplayers[object.parent].redhealth = 0
										else
											player.aosplayers[object.parent].health = $1 + gain
											player.aosplayers[object.parent].redhealth = $1 - gain
										end
										if(player.aosplayers[object.parent].health > 3000)
											print("health above max shouldn't happen?")
											player.aosplayers[object.parent].health = 3000
										end
										player.aosplayers[object.parent].hyper = $1 + (FRACUNIT/450)*gain
										if(player.aosplayers[object.parent].hyper > FRACUNIT*3)
											player.aosplayers[object.parent].hyper = FRACUNIT*3
										end
										object.canbegrazed = true
										player.aosobjects[onum].hasbeengrazed[object.parent] = true
									end
								end
								rnum = $1 + 1
							end
						end
						onum = $1 + 1
					end

					// Camera movement
					if not(player.aosplayers[32].currentattack == 27)
						player.aoscamx = 0
						player.aoscamy = 0
						local playdiv = 0
						pnum = 0
						while(pnum < player.numplayers)
							if not(player.aosplayers[pnum].deathtimer >= deathtime and pnum < 32 and not(player.sonigurilastplayeralive == pnum))
								or(player.numplayers <= 2)
								if(player.aosplayers[pnum].exists)
									player.aoscamx = $1 + player.aosplayers[pnum].x
									player.aoscamy = $1 - player.aosplayers[pnum].y
									playdiv = $1 + 1
								end
							end
							pnum = $1 + 1
						end

						player.aoscamx = $1 / playdiv
						player.aoscamy = $1 / playdiv

						// Camera scale
						player.aoscamscale = 180*FRACUNIT
						pnum = 0
						while(pnum < player.numplayers)
							if not(player.aosplayers[pnum].deathtimer >= deathtime and pnum < 32 and not(player.sonigurilastplayeralive == pnum))
								or(player.numplayers <= 2)
								if(player.aosplayers[pnum].exists)
									local dist = R_PointToDist2(player.aoscamx, -player.aoscamy, player.aosplayers[pnum].x, player.aosplayers[pnum].y)*8/3
									dist = $1 + 180*FRACUNIT
									if(dist > player.aoscamscale)
										player.aoscamscale = dist
									end
								end
							end
							pnum = $1 + 1
						end

						if(player.aoscamscale < 150*FRACUNIT)
							player.aoscamscale = 150*FRACUNIT
						end

						// Cutscene camera
						local square = (startcuttime/3)*(startcuttime/3)
						player.aoscamscale = $1 + (square*FRACUNIT/60)
						local goodcutdist = abs((startcuttime*2/3)-player.startcuttime)*abs((startcuttime*2/3)-player.startcuttime)
						if(goodcutdist > square)
							goodcutdist = square
						end
						player.aoscamscale = $1 - (goodcutdist*FRACUNIT/60)

						player.aoscamscale = FixedDiv(FRACUNIT, $1/270)

						player.aostimer = $1 - 1
						if(player.aostimer < 0)
							player.aostimer = 0
						end

					/*	if(player.cmd.buttons & BT_JUMP)
							player.aoscamscale = $1 * 40/41
						end
						if(player.cmd.buttons & BT_USE)
							player.aoscamscale = $1 * 41/40
						end*/

					//	player.aoscamx = $1 + (player.cmd.sidemove*FRACUNIT/10)
					//	player.aoscamy = $1 - (player.cmd.forwardmove*FRACUNIT/10)

						// Do stuff
						if(player.soniguricamerastuff)
							player.soniguricamerastuff = $1 - FRACUNIT/TICRATE
							if(player.soniguricamerastuff < 0)
								player.soniguricamerastuff = 0
							end

							local x1 = FixedMul(player.aoscamx, FRACUNIT-player.soniguricamerastuff)
							local y1 = FixedMul(player.aoscamy, FRACUNIT-player.soniguricamerastuff)
							// x2/y2 aren't useful since its always 0
							local scale1 = FixedMul(player.aoscamscale, FRACUNIT-player.soniguricamerastuff)
							local scale2 = FixedMul(FRACUNIT*11/10, player.soniguricamerastuff)

							player.aoscamx = x1
							player.aoscamy = y1
							player.aoscamscale = scale1+scale2
						end
					else
						player.soniguricamerastuff = FRACUNIT

						if(player.aoscamx)
							or(player.aoscamy)
							local speed = FRACUNIT*3

							local dist = R_PointToDist2(player.aoscamx, player.aoscamy, 0, 0)
							if(dist <= speed)
								player.aoscamx = 0
								player.aoscamy = 0
							end

							local dir = R_PointToAngle2(player.aoscamx, player.aoscamy, 0, 0)
							player.aoscamx = $1 + FixedMul(cos(dir), speed)
							player.aoscamy = $1 + FixedMul(sin(dir), speed)

							dist = R_PointToDist2(player.aoscamx, player.aoscamy, 0, 0)
							if(dist < speed)
								player.aoscamx = 0
								player.aoscamy = 0
							end
						end

						if(player.aoscamscale < FRACUNIT*11/10)
							player.aoscamscale = $1 + (FRACUNIT/120)
							if(player.aoscamscale > FRACUNIT*11/10)
								player.aoscamscale = FRACUNIT*11/10
							end
						elseif(player.aoscamscale > FRACUNIT*11/10)
							player.aoscamscale = $1 - (FRACUNIT/120)
							if(player.aoscamscale < FRACUNIT*11/10)
								player.aoscamscale = FRACUNIT*11/10
							end
						end
					end
				end
			elseif(player.gamemode == 6)
				and(#player == player.host)
				if(player.cmd.buttons & BT_JUMP)
					and not(player.prevcmd & BT_JUMP)
					and(player.howtoplayscreen < numscreens)
					and not(modeattacking)
					player.howtoplayscreen = $1 + 1
					AOSPlaySound(player, sfx_sgmen2)
				elseif(player.cmd.buttons & BT_USE)
					and not(player.prevcmd & BT_USE)
					and(player.howtoplayscreen > 0)
					and(player.sonigurideathfadetimer == deathfadetime)
					and not(modeattacking)
					player.howtoplayscreen = $1 - 1
					AOSPlaySound(player, sfx_sgmen3)
				end


				if(player.howtoplayscreen >= numscreens)
					or(modeattacking)
					player.sonigurideathfadetimer = $1 - 2
					if(player.sonigurideathfadetimer <= 0)
						player.sonigurideathfadetimer = 1
						player.gamemode = 0
						AOSStartGame(player, false)
					end
				end
			elseif(player.gamemode == 1)
				local move = 0
				if(player.prevside <= 0)
					and(player.cmd.sidemove > 0)
					move = 1
				elseif(player.prevside >= 0)
					and(player.cmd.sidemove < 0)
					move = -1
				end
				if(move)
					S_StartSound(nil, sfx_sgmen1, player)
					player.selmovetime = (TICRATE/2)*move
					player.selection = ($1 + move)%2
					if(player.selection < 0)
						player.selection = 1
					end
				end
				if(player.selmovetime > 0)
					player.selmovetime = $1 - 1
				elseif(player.selmovetime < 0)
					player.selmovetime = $1 + 1
				end
				if(player.cmd.buttons & BT_JUMP)
					and not(player.prevcmd & BT_JUMP)
					and(player.selection == 0)
					player.gamemode = 2
					S_StartSound(nil, sfx_sgmen2, player)
				//	S_ChangeMusic("BF-LBY", true, player)
					player.selmovetime = TICRATE/2
				end
			elseif(player.gamemode == 2)
				if(player.cmd.buttons & BT_USE)
					and not(player.prevcmd & BT_USE)
					player.gamemode = 1
					player.selection = 0
					player.selmovetime = 0
					S_ChangeMusic("SGMENU", true, player)
					S_StartSound(nil, sfx_sgmen3, player)
				else
					// Look for lobbies!
					local numhosts = 0
					local hosts = {}
					for player2 in players.iterate
						if(player2.host == #player2)
							and(player2.gamemode == 3)
							hosts[numhosts] = #player2
							numhosts = $1 + 1
						end
					end
					if(player.selection > 0)
						and(player.cmd.forwardmove > 0)
						and(player.prevforward <= 0)
						S_StartSound(nil, sfx_sgmen1, player)
						player.selection = $1 - 1
					elseif(player.selection < numhosts)
						and(player.cmd.forwardmove < 0)
						and(player.prevforward >= 0)
						S_StartSound(nil, sfx_sgmen1, player)
						player.selection = $1 + 1
					end
					if(player.selection > numhosts)
						player.selection = numhosts
					end
					// Selected?
					if(player.cmd.buttons & BT_JUMP)
						and not(player.prevcmd & BT_JUMP)
						player.gamemode = 3
						player.selmovetime = 0
						if(player.selection)
							JoinPlayer(player, hosts[player.selection-1])
						end
						S_StartSound(nil, sfx_sgmen2, player)
					end
				end
				if(player.selmovetime)
					player.selmovetime = $1 - 1
				end
			elseif(player.gamemode == 3)
				if(player.host == #player)
					and(player.cmd.buttons & BT_JUMP)
					and not(player.prevcmd & BT_JUMP)
					local numclients = 0
					local cnum = 0
					while(cnum < 32)
						if not(player.clients[cnum] == -1)
							players[player.clients[cnum]].gamemode = 4
						//	S_ChangeMusic("CHAR", true, players[player.clients[cnum]])
							numclients = $1 + 1
						end
						cnum = $1 + 1
					end
					player.numplayers = numclients
					player.gamemode = 4
				//	S_ChangeMusic("CHAR", true, player)
				elseif(player.cmd.buttons & BT_USE)
					and not(player.prevcmd & BT_USE)
					if(player.host == #player)
						local clnum = 1
						while(clnum < 32)
							player.clients[clnum] = -1	// -1 = no client
							clnum = $1 + 1
						end
					else
						player.host = #player
					end
					player.gamemode = 2
					S_StartSound(nil, sfx_sgmen3, player)
				end
			elseif(player.gamemode == 4)
				if(player.cmd.forwardmove > 0)
					and(player.prevforward <= 0)
					S_StartSound(nil, sfx_sgmen1, player)
					player.selection = $1 - 1
					if(player.selection < 0)
						player.selection = numplayers - 1
					end
					player.selmovetime = -TICRATE/4
				elseif(player.cmd.forwardmove < 0)
					and(player.prevforward >= 0)
					S_StartSound(nil, sfx_sgmen1, player)
					player.selection = ($1 + 1)%numplayers
					player.selmovetime = TICRATE/4
				end
				if(player.selmovetime > 0)
					player.selmovetime = $1 - 1
				elseif(player.selmovetime < 0)
					player.selmovetime = $1 + 1
				end
				player.character = player.selection
				if(player.cmd.buttons & BT_JUMP)
					and not(player.prevcmd & BT_JUMP)
					if(player.ready)
						player.ready = false
						S_StartSound(nil, sfx_sgmen3, player)
					else
						player.ready = true
						S_StartSound(nil, sfx_sgmen2, player)
					end
				end

				if(#player == player.host)
					local clnum = 0
					local allready = true
					while(clnum < 32)
						and(player.clients[clnum] >= 0)
						if not(players[player.clients[clnum]].ready)
							allready = false
						end
						clnum = $1 + 1
					end
					if(allready)
						AOSStartGame(player)
						player.gamemode = 0
						local clnum2 = 0
						while(clnum2 < 32)
							and(player.clients[clnum2] >= 0)
							players[player.clients[clnum2]].ready = false
							clnum2 = $1 + 1
						end
					end
				end
			end

			player.jumpfactor = 0
			player.charability2 = CA2_NONE
			player.normalspeed = 0
			player.pflags = $1|PF_FORCESTRAFE
			player.prevcmd = player.cmd.buttons
			player.prevside = player.cmd.sidemove
			player.prevforward = player.cmd.forwardmove
			player.prevaos = true
		elseif(player.prevaos)
			player.aoscamscale = nil
			player.aoscamx = nil
			player.aoscamy = nil
			player.numplayers = nil
			player.aosplayers = nil
			player.aosobjects = nil
			player.aostimer = nil
			player.arenaradius = nil
			player.timeslow = nil
			player.gamemode = nil		// 0 = In-game, 1 = Menu, 2 = Lobbies, 3 = In lobby, 4 = Character select, 5 = Options
			player.prevcmd = nil
			player.prevside = nil
			player.prevforward = nil
			player.character = nil
			player.selection = nil
			player.selmovetime = nil
			player.ready = nil
			player.startcuttime = nil
			player.host = nil
			player.clients = nil
			player.clientnum = nil
			player.seedrngstate = nil
			player.targetseedrngstate = nil
			player.soniguriattack = nil
			player.soniguriangle = nil
			player.soniguridumbvar = nil
			player.soniguriphase = nil
			player.soniguricamerastuff = nil
			player.sonigurichaseobj = nil
			player.sonigurideathfadetimer = nil
			player.sonigurilastplayeralive = nil
			player.leveltimetime = nil
			player.howtoplayscreen = nil
			player.jumpfactor = skins[player.mo.skin].jumpfactor
			player.charability2 = skins[player.mo.skin].ability2
			player.normalspeed = skins[player.mo.skin].normalspeed
			player.pflags = $1 & !PF_FORCESTRAFE
			player.prevcmd = nil
			player.prevside = nil
			player.prevforward = nil
			player.prevaos = false
		end
	end
end)

local useaoscamscale = FRACUNIT		// This is dumb. Oh well. Replaces player.aoscamscale when rendering.

local function drawCircleArena(v, player)
	local cutscale = 0
	if(player.startcuttime > startcuttime/3)
		cutscale = player.startcuttime - (startcuttime/3)
		if(cutscale > startcuttime-(startcuttime/3))
			cutscale = startcuttime-(startcuttime/3)
		end

		cutscale = $1 * FRACUNIT / (startcuttime-(startcuttime/3))
	end
	local scale = FixedMul(FixedDiv(FixedMul(useaoscamscale, player.arenaradius), 185*FRACUNIT), cutscale)
	v.drawScaled((160*FRACUNIT)-FixedMul(player.aoscamx, useaoscamscale), (100*FRACUNIT)-FixedMul(player.aoscamy, useaoscamscale), scale, v.aosring1)
	if(darkring)
		v.drawScaled((160*FRACUNIT)-FixedMul(player.aoscamx, useaoscamscale), (100*FRACUNIT)-FixedMul(player.aoscamy, useaoscamscale), scale, v.aosringback, V_50TRANS)
	end
	v.drawScaled((160*FRACUNIT)-FixedMul(player.aoscamx, useaoscamscale), (100*FRACUNIT)-FixedMul(player.aoscamy, useaoscamscale), scale, v.aosring2, V_20TRANS)
	v.drawScaled((160*FRACUNIT)-FixedMul(player.aoscamx, useaoscamscale), (100*FRACUNIT)-FixedMul(player.aoscamy, useaoscamscale), scale, v.aosring3, V_40TRANS)
	v.drawScaled((160*FRACUNIT)-FixedMul(player.aoscamx, useaoscamscale), (100*FRACUNIT)-FixedMul(player.aoscamy, useaoscamscale), scale, v.aosring4, V_60TRANS)
	v.drawScaled((160*FRACUNIT)-FixedMul(player.aoscamx, useaoscamscale), (100*FRACUNIT)-FixedMul(player.aoscamy, useaoscamscale), scale, v.aosring5, V_80TRANS)
end

local hpcolors = {}
hpcolors[0] = 133
hpcolors[1] = 166
hpcolors[2] = 35
// Flashing (not used anyway...)
hpcolors[3] = 52
hpcolors[4] = 54
hpcolors[5] = 56
hpcolors[6] = 181
hpcolors[7] = 183
hpcolors[8] = 185
hpcolors[9] = 183
hpcolors[10] = 181
hpcolors[11] = 56
hpcolors[12] = 54

local function drawHealthBar(v, x, y, value, redvalue, flip)
	local exflags = V_SNAPTOTOP|V_SNAPTOLEFT
	local xmul = 1
	if(flip)
		exflags = V_SNAPTOTOP|V_SNAPTORIGHT
		xmul = -1
	end

	if(flip)
		v.draw(x+101, y-1, v.healthbarflip, exflags)
	else
		v.draw(x-1, y-1, v.healthbar, exflags)
	end

	local flip2 = flip
	local flip3 = false
	if(value > 3000)
		and(value < 6000)
		if(flip2)
			flip2 = false
		else
			flip2 = true
		end
		flip3 = true
	end

	local length = (((value-1) % 3000)*109/3000)+1
	local lengthred = (((redvalue) % 3000)*109/3000)
	if not(length+lengthred > ((((value-1)+redvalue) % 3000)*109/3000))
		and(lengthred)
		lengthred = $1 + 1	// Good hacky fix
	end
	if(value <= 0)
		and(length > 0)
		length = 0
	end
	local lengths = {}
	if not(flip3)
		lengths[0] = length
		lengths[1] = length - 2
		lengths[2] = length - 4
		lengths[3] = length - 5
		lengths[4] = length - 6
		lengths[5] = length - 7
		lengths[6] = length - 8
		lengths[7] = length - 9
	else
		lengths[0] = length - 9
		lengths[1] = length - 7
		lengths[2] = length - 5
		lengths[3] = length - 4
		lengths[4] = length - 3
		lengths[5] = length - 2
		lengths[6] = length - 1
		lengths[7] = length
	end
	local redlengths = {}
	redlengths[0] = lengthred
	redlengths[1] = lengthred
	redlengths[2] = lengthred
	redlengths[3] = lengthred
	redlengths[4] = lengthred
	redlengths[5] = lengthred
	redlengths[6] = lengthred
	redlengths[7] = lengthred
	if(lengths[0] < 0)
		redlengths[0] = $1 + lengths[0]
	end
	if(lengths[1] < 0)
		redlengths[1] = $1 + lengths[1]
	end
	if(lengths[2] < 0)
		redlengths[2] = $1 + lengths[2]
	end
	if(lengths[3] < 0)
		redlengths[3] = $1 + lengths[3]
	end
	if(lengths[4] < 0)
		redlengths[4] = $1 + lengths[4]
	end
	if(lengths[5] < 0)
		redlengths[5] = $1 + lengths[5]
	end
	if(lengths[6] < 0)
		redlengths[6] = $1 + lengths[6]
	end
	if(lengths[7] < 0)
		redlengths[7] = $1 + lengths[7]
	end

	local lnum = 0
	while(lnum < 8)
		if(redlengths[lnum]+lengths[lnum] > 100)
			redlengths[lnum] = 100-lengths[lnum]
		end
		if(redlengths[lnum] < 0)
			redlengths[lnum] = 0
		end
		if(lengths[lnum] > 100)
			lengths[lnum] = 100
		elseif(lengths[lnum] < 0)
			lengths[lnum] = 0
		end
		lnum = $1 + 1
	end

	local xoffs = {}
	local xnum = 0
	while(xnum < 8)
		xoffs[xnum] = 0
		if(flip2)
			xoffs[xnum] = 100-lengths[xnum]
		end
		xnum = $1 + 1
	end

	// Draw the extra health
	local color = hpcolors[1]
	if(value <= 6000)
		color = hpcolors[2]
	end
	if(value > 3000)
		v.drawFill(x, y, 100, 1, color+exflags)
		v.drawFill(x+(2*xmul), y+1, 100, 1, color+exflags)
		v.drawFill(x+(4*xmul), y+2, 100, 1, color+exflags)
		v.drawFill(x+(5*xmul), y+3, 100, 1, color+exflags)
		v.drawFill(x+(6*xmul), y+4, 100, 1, color+exflags)
		v.drawFill(x+(7*xmul), y+5, 100, 2, color+exflags)
		v.drawFill(x+(8*xmul), y+7, 100, 2, color+exflags)
		v.drawFill(x+(9*xmul), y+9, 100, 6, color+exflags)
	end

	color = hpcolors[2-((value-1)*3/9000)]
//	if(value < 3000)
//		color = hpcolors[3+(leveltime%10)]
//	end

	if not(flip)
		color = 151
	end

	v.drawFill(x+xoffs[0], y, lengths[0], 1, color+exflags)
	v.drawFill(x+xoffs[1]+(2*xmul), y+1, lengths[1], 1, color+exflags)
	v.drawFill(x+xoffs[2]+(4*xmul), y+2, lengths[2], 1, color+exflags)
	v.drawFill(x+xoffs[3]+(5*xmul), y+3, lengths[3], 1, color+exflags)
	v.drawFill(x+xoffs[4]+(6*xmul), y+4, lengths[4], 1, color+exflags)
	v.drawFill(x+xoffs[5]+(7*xmul), y+5, lengths[5], 2, color+exflags)
	v.drawFill(x+xoffs[6]+(8*xmul), y+7, lengths[6], 2, color+exflags)
	v.drawFill(x+xoffs[7]+(9*xmul), y+9, lengths[7], 6, color+exflags)
	// Red
	xnum = 0
	while(xnum < 8)
		if(flip2)
			xoffs[xnum] = $1-redlengths[xnum]
		else
			xoffs[xnum] = $1+lengths[xnum]
		end
		xnum = $1 + 1
	end
	v.drawFill(x+xoffs[0], y, redlengths[0], 1, 35+exflags)
	v.drawFill(x+xoffs[1]+(2*xmul), y+1, redlengths[1], 1, 35+exflags)
	v.drawFill(x+xoffs[2]+(4*xmul), y+2, redlengths[2], 1, 35+exflags)
	v.drawFill(x+xoffs[3]+(5*xmul), y+3, redlengths[3], 1, 35+exflags)
	v.drawFill(x+xoffs[4]+(6*xmul), y+4, redlengths[4], 1, 35+exflags)
	v.drawFill(x+xoffs[5]+(7*xmul), y+5, redlengths[5], 2, 35+exflags)
	v.drawFill(x+xoffs[6]+(8*xmul), y+7, redlengths[6], 2, 35+exflags)
	v.drawFill(x+xoffs[7]+(9*xmul), y+9, redlengths[7], 6, 35+exflags)
end

local function drawHyperBar(v, x, y, hyper)
	local exflags = V_SNAPTOTOP|V_SNAPTOLEFT
	if(x > 180)
		exflags = V_SNAPTOTOP|V_SNAPTORIGHT
	end
	local amount = (hyper*38/FRACUNIT)%38
	local base = 27
	local current = 133
	if(hyper/FRACUNIT == 1)
		base = 133
		current = 124
	elseif(hyper/FRACUNIT == 2)
		base = 124
		current = 112
	elseif(hyper/FRACUNIT)
		base = 112
	end
	v.drawFill(x, y, 13, 40, 31+exflags)
	v.drawFill(x+1, y+1, 11, 38, base+exflags)
	v.drawFill(x+1, y+1, 11, amount, current+exflags)
	v.draw(x+15, y+30, v.numbers[hyper/FRACUNIT], exflags)
end

local function drawHeat(v, x, y, heat)
	local exflags = V_SNAPTOTOP|V_SNAPTOLEFT
	if(x > 180)
		exflags = V_SNAPTOTOP|V_SNAPTORIGHT
	end
	local numbersbase = v.numbers
	if(heat >= 300*FRACUNIT)
		numbersbase = v.numbershot
	elseif(heat >= 200*FRACUNIT)
		numbersbase = v.numbersmid
	end
	v.draw(x-12, y, numbersbase[((heat/FRACUNIT)/100)%10], exflags)
	v.draw(x-4, y, numbersbase[((heat/FRACUNIT)/10)%10], exflags)
	v.draw(x+4, y, numbersbase[(heat/FRACUNIT)%10], exflags)
	v.draw(x+12, y, numbersbase[10], exflags)
	if(heat > 100*FRACUNIT)
		local numbersadd = v.numbersmid
		if(heat >= 200*FRACUNIT)
			numbersadd = v.numbershot
		end

		local trans = (heat/FRACUNIT)%100
		trans = $1 / 10
		trans = 10 - $1
		trans = $1 * V_10TRANS
		v.draw(x-12, y, numbersadd[((heat/FRACUNIT)/100)%10], trans|exflags)
		v.draw(x-4, y, numbersadd[((heat/FRACUNIT)/10)%10], trans|exflags)
		v.draw(x+4, y, numbersadd[(heat/FRACUNIT)%10], trans|exflags)
		v.draw(x+12, y, numbersadd[10], trans|exflags)
	end
end

local function drawObjSprite(v, player, x, y, scale, angle, frame, flags)
	if(flags & V_FLIP)
		local cosAngle = -cos(angle)
		local sinAngle = sin(angle)
		angle = R_PointToAngle2(0, 0, cosAngle, sinAngle)
	end
	angle = $1 + FixedAngle((180*FRACUNIT)/frameinfo[frame].rotatenum)
	local rot = AngleFixed(angle)/FRACUNIT
	rot = $1 * frameinfo[frame].rotatenum / 360
	local patch = v.frames[frame][rot]
	v.drawScaled((160*FRACUNIT)-FixedMul(player.aoscamx - x, useaoscamscale), (100*FRACUNIT)-FixedMul(player.aoscamy + y, useaoscamscale), FixedMul(useaoscamscale, scale)/8, patch, flags)
end

local function drawObject(v, player, object)
	if not(object.dontdraw)
		drawObjSprite(v, player, object.x, object.y, object.scale, object.angle, animinfo[object.animation].frames[object.frame], object.drawflags)
	end
	if(object.hassub)
		drawObjSprite(v, player, object.subx, object.suby, object.subscale, object.subangle, animinfo[object.subanimation].frames[object.subframe], object.subdrawflags)
	end
end

local function drawShield(v, player, x, y, scale, color)
	local x = (160*FRACUNIT)-FixedMul(player.aoscamx - x, useaoscamscale)
	local y = (100*FRACUNIT)-FixedMul(player.aoscamy + y, useaoscamscale)
	local colormap = v.getColormap(TC_DEFAULT, color)
	v.drawScaled(x, y, FixedMul(useaoscamscale/2, scale), v.shield1, V_20TRANS, colormap)
	v.drawScaled(x, y, FixedMul(useaoscamscale/2, scale), v.shield2, V_40TRANS, colormap)
	v.drawScaled(x, y, FixedMul(useaoscamscale/2, scale), v.shield3, V_60TRANS, colormap)
	v.drawScaled(x, y, FixedMul(useaoscamscale/2, scale), v.shield4, V_80TRANS, colormap)
end

local function drawTrail(v, player, aosp, x, y, frame, angle, flip, flags, soniguri, num)
	if(flip)
		flags = $1|V_FLIP
	end

	if(flags & V_FLIP)
		local cosAngle = -cos(angle)
		local sinAngle = sin(angle)
		angle = R_PointToAngle2(0, 0, cosAngle, sinAngle)
	end
	angle = $1 + FixedAngle((180*FRACUNIT)/pframeinfo[frame].rotatenum)
	local rot = AngleFixed(angle)/FRACUNIT
	rot = $1 * pframeinfo[frame].rotatenum / 360
	local patch = v.pframesalt[frame][rot]
	local x = (160*FRACUNIT)-FixedMul(player.aoscamx - x, useaoscamscale)
	local y = (100*FRACUNIT)-FixedMul(player.aoscamy + y, useaoscamscale)
	if(soniguri)
		local colormap = v.getColormap(TC_DEFAULT, SKINCOLOR_TEAL)
		v.drawScaled(x, y, FixedMul(FixedMul(useaoscamscale/4, playerinfo[aosp.character].scale), (FRACUNIT/2)+(num*FRACUNIT/10)), patch, flags, colormap)
	else
		v.drawScaled(x, y, FixedMul(FixedMul(useaoscamscale/4, playerinfo[aosp.character].scale), (FRACUNIT/2)+(num*FRACUNIT/10)), patch, flags)
	end
end

local function drawPlayerWheel(v, player, aospn)
	local aosp = player.aosplayers[aospn]

	local x = (160*FRACUNIT)-FixedMul(player.aoscamx - aosp.x, useaoscamscale)
	local y = (100*FRACUNIT)-FixedMul(player.aoscamy + aosp.y, useaoscamscale)

	local trans = abs(((leveltime/2)%20)-10)

	if not(trans >= 10)
		trans = $1 * V_10TRANS

		v.drawScaled(x, y, FixedMul(useaoscamscale/4, FRACUNIT), v.playerwheel[leveltime%24], trans)
	end
end

local function drawPlayer(v, player, aospn)
	local aosp = player.aosplayers[aospn]
	local flags = 0

	if(aosp.facingdir)
		flags = $1|V_FLIP
	end

	local angle = aosp.drawdirection
	if(flags & V_FLIP)
		local cosAngle = -cos(angle)
		local sinAngle = sin(angle)
		angle = R_PointToAngle2(0, 0, cosAngle, sinAngle)
	end
	angle = $1 + FixedAngle((180*FRACUNIT)/pframeinfo[playerinfo[aosp.character].animations[aosp.animation].frames[aosp.frame]].rotatenum)
	local rot = AngleFixed(angle)/FRACUNIT
	rot = $1 * pframeinfo[playerinfo[aosp.character].animations[aosp.animation].frames[aosp.frame]].rotatenum / 360
	local patch = v.pframes[playerinfo[aosp.character].animations[aosp.animation].frames[aosp.frame]][rot]
	local color = playerinfo[aosp.character].ponecolor
	if(aosp.ptwocolor)
		color = playerinfo[aosp.character].ptwocolor
	elseif(aospn < 32)
		and(multiplayer)
		color = players[player.clients[aospn]].skincolor
	end
	local colormap = v.getColormap(TC_DEFAULT, color)
	local x = (160*FRACUNIT)-FixedMul(player.aoscamx - aosp.x, useaoscamscale)
	local y = (100*FRACUNIT)-FixedMul(player.aoscamy + aosp.y, useaoscamscale)
	v.drawScaled(x, y, FixedMul(useaoscamscale/4, playerinfo[aosp.character].scale), patch, flags, colormap)

	if(aosp.shieldtime)
		local shieldscale = abs(aosp.shieldtime)*FRACUNIT/(TICRATE/2)
		if(shieldscale > FRACUNIT)
			shieldscale = FRACUNIT
		end
		local color = SKINCOLOR_SUNSET
		if(aosp.shieldtime < 0)
			color = SKINCOLOR_SKY
		end
		drawShield(v, player, aosp.x, aosp.y, shieldscale, color)
	end
end

local function drawDeathSwoosh(v, player, aospn)
	local aosp = player.aosplayers[aospn]
	local deathtimer = aosp.deathtimer
	local deathtime2 = deathtime
	if(aospn >= 32)
		deathtimer = $1 * 2
		deathtime2 = $1 * 2
		if(leveltime & 1)
			deathtimer = $1 + 1
		end
	end
	if(deathtimer > deathtime2)
		local scale = (FRACUNIT*(deathtimer-deathtime2)/8)+1
		local x = (160*FRACUNIT)-FixedMul(player.aoscamx - aosp.x, useaoscamscale)
		local y = (100*FRACUNIT)-FixedMul(player.aoscamy + aosp.y, useaoscamscale)

		local deathflags = 0
		local trans = (30+deathtime2)-deathtimer
		if(trans > 0)
			trans = 10-trans
			if(trans < 0)
				trans = 0
			end
			deathflags = trans*V_10TRANS

			v.drawScaled(x, y, FixedMul(useaoscamscale/4, scale), v.deathswoosh, deathflags)
		end
	end
end

local function drawBox(v, player, x, y, w, h, a, p)
	local patch = v.point
	if(p)
		patch = v.point2
	end
	x = (160*FRACUNIT)-FixedMul(player.aoscamx - $1, useaoscamscale)
	y = (100*FRACUNIT)-FixedMul(player.aoscamy + $1, useaoscamscale)
	local wcos = FixedMul(cos(a), w/2)
	local wsin = FixedMul(sin(a), w/2)
	local hcos = FixedMul(cos(a), h/2)
	local hsin = FixedMul(sin(a), h/2)
	// Corners
	v.drawScaled(x-FixedMul(wcos, useaoscamscale)-FixedMul(hsin, useaoscamscale), y+FixedMul(wsin, useaoscamscale)-FixedMul(hcos, useaoscamscale), FRACUNIT, patch)
	v.drawScaled(x+FixedMul(wcos, useaoscamscale)-FixedMul(hsin, useaoscamscale), y-FixedMul(wsin, useaoscamscale)-FixedMul(hcos, useaoscamscale), FRACUNIT, patch)
	v.drawScaled(x-FixedMul(wcos, useaoscamscale)+FixedMul(hsin, useaoscamscale), y+FixedMul(wsin, useaoscamscale)+FixedMul(hcos, useaoscamscale), FRACUNIT, patch)
	v.drawScaled(x+FixedMul(wcos, useaoscamscale)+FixedMul(hsin, useaoscamscale), y-FixedMul(wsin, useaoscamscale)+FixedMul(hcos, useaoscamscale), FRACUNIT, patch)
	// Sides
	v.drawScaled(x-FixedMul(hsin, useaoscamscale), y-FixedMul(hcos, useaoscamscale), FRACUNIT, patch)
	v.drawScaled(x-FixedMul(wcos, useaoscamscale), y+FixedMul(wsin, useaoscamscale), FRACUNIT, patch)
	v.drawScaled(x+FixedMul(wcos, useaoscamscale), y-FixedMul(wsin, useaoscamscale), FRACUNIT, patch)
	v.drawScaled(x+FixedMul(hsin, useaoscamscale), y+FixedMul(hcos, useaoscamscale), FRACUNIT, patch)
end

local radius = 40
local ammodrawiterations = 80
local function drawAmmo(v, player, x, y, beam, ballistic)
	x = (160*FRACUNIT)-FixedMul(player.aoscamx - $1, useaoscamscale)
	y = (100*FRACUNIT)-FixedMul(player.aoscamy + $1, useaoscamscale)
	v.drawScaled(x, y, useaoscamscale/2, v.circleoutline, V_50TRANS)
	local angle = 0
	local pnum = 0
	local amountdumb = ammodrawiterations*beam/FRACUNIT
	while(pnum < amountdumb)
		local cosx = (cos(angle)*radius)/FRACUNIT
		local siny = -(sin(angle)*radius)/FRACUNIT

		angle = $1 + FixedAngle(180*FRACUNIT/ammodrawiterations)
		v.drawScaled(x+(cosx*(useaoscamscale/2)), y+(siny*(useaoscamscale/2)), useaoscamscale/2, v.beamammo)
		pnum = $1 + 1
	end
	angle = ANGLE_180
	pnum = 0
	amountdumb = ammodrawiterations*ballistic/FRACUNIT
	if(amountdumb > ammodrawiterations)
		amountdumb = ammodrawiterations
	end
	while(pnum < amountdumb)
		local cosx = (cos(angle)*radius)/FRACUNIT
		local siny = -(sin(angle)*radius)/FRACUNIT

		angle = $1 + FixedAngle(180*FRACUNIT/ammodrawiterations)
		v.drawScaled(x+(cosx*(useaoscamscale/2)), y+(siny*(useaoscamscale/2)), useaoscamscale/2, v.ballisticammo)
		pnum = $1 + 1
	end
end

local function drawLockon(v, player, aosp)
	local x = (160*FRACUNIT)-FixedMul(player.aoscamx - aosp.x, useaoscamscale)
	local y = (100*FRACUNIT)-FixedMul(player.aoscamy + aosp.y, useaoscamscale)
	v.drawScaled(x, y, useaoscamscale/4, v.lockon)
end

local function drawStar(v, player, dist, angle, flags)
	local cosx = FixedMul(cos(angle), dist)
	local cosy = FixedMul(sin(angle), dist)
	local x = (160*FRACUNIT)-FixedMul(player.aoscamx - cosx, useaoscamscale)
	local y = (100*FRACUNIT)-FixedMul(player.aoscamy + cosy, useaoscamscale)
	v.draw(x/FRACUNIT, y/FRACUNIT, v.dumbstar, flags)
end

local function drawStartStuff(v, player, time)
	local bartrans = 10
	local texttrans = 10
	if(time < TICRATE/2)
		bartrans = time*10/(TICRATE/2)
		texttrans = bartrans
	elseif(time > (TICRATE*3)-(TICRATE/2))
		bartrans = ((TICRATE*3)-time)*10/(TICRATE/2)
		texttrans = bartrans
	end

	// Text stuff
	local distto2 = abs((2*TICRATE)-time)
	if(distto2 < TICRATE/6)
		texttrans = distto2*10/(TICRATE/6)
	end

	local statictrans = bartrans/2
	bartrans = 10-$1
	statictrans = 10-$1
	texttrans = 10-$1
	bartrans = $1 * V_10TRANS
	statictrans = $1 * V_10TRANS
	texttrans = $1 * V_10TRANS
	v.draw(0, 92, v.startbar, bartrans)
	if(leveltime & 1)
		v.draw(0, 92, v.static1, statictrans)
	else
		v.draw(0, 92, v.static2, statictrans)
	end
	if(time < 2*TICRATE)
		v.draw(0, 92, v.standby, texttrans)
	else
		v.draw(0, 92, v.ignition, texttrans)
	end
end

local options = {}
options[0] = "VERSUS"
options[1] = "OPTIONS"

local lastplayer = 0

local function drawAOS(v, player, camera)
	if(splitscreen and player and #player)
		return
	end
	if(player == nil)
		if not(multiplayer)
			return
		end
		player = players[lastplayer]
	else
		lastplayer = #player
	end

	if not(mapheaderinfo[gamemap].aosoniguri)
		or(player.gamemode == nil)
		return
	end

	useaoscamscale = player.aoscamscale
	local dif = -(((v.dupy()*200)-v.height())*FRACUNIT)/200
	useaoscamscale = FixedMul($1, (dif/5)+FRACUNIT)

	if(v.pframes == nil)
		v.pframes = {}
		v.pframesalt = {}	// Trail
		v.frames = {}
		v.characterselectportraits = {}
		v.characterselectcircles = {}
		v.point = v.cachePatch("POINT")
		v.point2 = v.cachePatch("POINT2")
		v.beamammo = v.cachePatch("BEAMAMMO")
		v.ballisticammo = v.cachePatch("BALLAMMO")
		v.lockon = v.cachePatch("LOCKON")
		v.circleoutline = v.cachePatch("AMMOMETR")
		v.sonigurihit = v.cachePatch("SNIGHIT")
		v.textbar = v.cachePatch("TEXTBAR")
		v.characterselectbg1 = v.cachePatch("CSS1")
		v.characterselectbg2 = v.cachePatch("CSS2")
		v.characterselectcircle = v.cachePatch("CSSCIRCL")
		v.startbar = v.cachePatch("STARTBAR")
		v.static1 = v.cachePatch("STATIC1")
		v.static2 = v.cachePatch("STATIC2")
		v.standby = v.cachePatch("STANDBY")
		v.ignition = v.cachePatch("IGNITION")
		v.healthbar = v.cachePatch("HPBAR")
		v.healthbarflip = v.cachePatch("HPBARF")
		v.numbers = {}
		v.numbers[0] = v.cachePatch("SGNUM0")
		v.numbers[1] = v.cachePatch("SGNUM1")
		v.numbers[2] = v.cachePatch("SGNUM2")
		v.numbers[3] = v.cachePatch("SGNUM3")
		v.numbers[4] = v.cachePatch("SGNUM4")
		v.numbers[5] = v.cachePatch("SGNUM5")
		v.numbers[6] = v.cachePatch("SGNUM6")
		v.numbers[7] = v.cachePatch("SGNUM7")
		v.numbers[8] = v.cachePatch("SGNUM8")
		v.numbers[9] = v.cachePatch("SGNUM9")
		v.numbers[10] = v.cachePatch("SGPERC")
		v.numbersmid = {}
		v.numbersmid[0] = v.cachePatch("SGNUM0M")
		v.numbersmid[1] = v.cachePatch("SGNUM1M")
		v.numbersmid[2] = v.cachePatch("SGNUM2M")
		v.numbersmid[3] = v.cachePatch("SGNUM3M")
		v.numbersmid[4] = v.cachePatch("SGNUM4M")
		v.numbersmid[5] = v.cachePatch("SGNUM5M")
		v.numbersmid[6] = v.cachePatch("SGNUM6M")
		v.numbersmid[7] = v.cachePatch("SGNUM7M")
		v.numbersmid[8] = v.cachePatch("SGNUM8M")
		v.numbersmid[9] = v.cachePatch("SGNUM9M")
		v.numbersmid[10] = v.cachePatch("SGPERCM")
		v.numbershot = {}
		v.numbershot[0] = v.cachePatch("SGNUM0H")
		v.numbershot[1] = v.cachePatch("SGNUM1H")
		v.numbershot[2] = v.cachePatch("SGNUM2H")
		v.numbershot[3] = v.cachePatch("SGNUM3H")
		v.numbershot[4] = v.cachePatch("SGNUM4H")
		v.numbershot[5] = v.cachePatch("SGNUM5H")
		v.numbershot[6] = v.cachePatch("SGNUM6H")
		v.numbershot[7] = v.cachePatch("SGNUM7H")
		v.numbershot[8] = v.cachePatch("SGNUM8H")
		v.numbershot[9] = v.cachePatch("SGNUM9H")
		v.numbershot[10] = v.cachePatch("SGPERCH")
		v.aosring1 = v.cachePatch("AOSRING1")
		v.aosring2 = v.cachePatch("AOSRING2")
		v.aosring3 = v.cachePatch("AOSRING3")
		v.aosring4 = v.cachePatch("AOSRING4")
		v.aosring5 = v.cachePatch("AOSRING5")
		v.aosringback = v.cachePatch("AOSRINGB")
		v.dumbstar = v.cachePatch("DUMBSTAR")
		v.dumbblack = v.cachePatch("DUMBLACK")
		v.dumbwhite = v.cachePatch("DUMWHITE")
		v.shield1 = v.cachePatch("SHIELD1")
		v.shield2 = v.cachePatch("SHIELD2")
		v.shield3 = v.cachePatch("SHIELD3")
		v.shield4 = v.cachePatch("SHIELD4")
		v.playerwheel = {}
		v.playerwheel[0] = v.cachePatch("PLWH1")
		v.playerwheel[1] = v.cachePatch("PLWH2")
		v.playerwheel[2] = v.cachePatch("PLWH3")
		v.playerwheel[3] = v.cachePatch("PLWH4")
		v.playerwheel[4] = v.cachePatch("PLWH5")
		v.playerwheel[5] = v.cachePatch("PLWH6")
		v.playerwheel[6] = v.cachePatch("PLWH7")
		v.playerwheel[7] = v.cachePatch("PLWH8")
		v.playerwheel[8] = v.cachePatch("PLWH9")
		v.playerwheel[9] = v.cachePatch("PLWH10")
		v.playerwheel[10] = v.cachePatch("PLWH11")
		v.playerwheel[11] = v.cachePatch("PLWH12")
		v.playerwheel[12] = v.cachePatch("PLWH13")
		v.playerwheel[13] = v.cachePatch("PLWH14")
		v.playerwheel[14] = v.cachePatch("PLWH15")
		v.playerwheel[15] = v.cachePatch("PLWH16")
		v.playerwheel[16] = v.cachePatch("PLWH17")
		v.playerwheel[17] = v.cachePatch("PLWH18")
		v.playerwheel[18] = v.cachePatch("PLWH19")
		v.playerwheel[19] = v.cachePatch("PLWH20")
		v.playerwheel[20] = v.cachePatch("PLWH21")
		v.playerwheel[21] = v.cachePatch("PLWH22")
		v.playerwheel[22] = v.cachePatch("PLWH23")
		v.playerwheel[23] = v.cachePatch("PLWH24")
		v.howtoplay = {}
		v.howtoplay[0] = v.cachePatch("HTP1")
		v.howtoplay[1] = v.cachePatch("HTP2")
		v.howtoplay[2] = v.cachePatch("HTP3")
		v.howtoplay[3] = v.cachePatch("HTP4")
		v.howtoplay[4] = v.cachePatch("HTP5")
		v.howtoplay[5] = v.cachePatch("HTP6")
		v.howtoplay[6] = v.cachePatch("HTP7")
		v.howtoplay[7] = v.cachePatch("HTP8")
		v.howtoplay[8] = v.cachePatch("HTP9")
		v.howtoplay[9] = v.cachePatch("HTP10")
		v.howtoplay[10] = v.cachePatch("HTP11")
		v.howtoplay[11] = v.cachePatch("HTP12")
		v.howtoplay[12] = v.cachePatch("HTP13")
		v.howtoplay[13] = v.cachePatch("HTP14")
		v.howtoplay[14] = v.cachePatch("HTP14")
		v.howtoplay[15] = v.cachePatch("HTP15")
		v.deathswoosh = v.cachePatch("DTHSWOSH")
//	end
		local fnum = 0
		while(fnum < numpframes)
			v.pframes[fnum] = {}
			v.pframesalt[fnum] = {}
			local rnum = 0
			while(rnum < pframeinfo[fnum].rotatenum)
				v.pframes[fnum][rnum] = v.cachePatch(pframeinfo[fnum].frames[rnum])
				local frame2 = pframeinfo[fnum].frames[rnum]
				frame2 = string.gsub($1, "SORV", "SORT")
				frame2 = string.gsub($1, "SNIG", "SNIT")
				v.pframesalt[fnum][rnum] = v.cachePatch(frame2)
				rnum = $1 + 1
			end
			fnum = $1 + 1
		end
		fnum = 0
		while(fnum < numframes)
			v.frames[fnum] = {}
			local rnum = 0
			while(rnum < frameinfo[fnum].rotatenum)
				v.frames[fnum][rnum] = v.cachePatch(frameinfo[fnum].frames[rnum])
				rnum = $1 + 1
			end
			fnum = $1 + 1
		end
		fnum = 0
		while(fnum < numplayers)
			if(v.characterselectportraits[fnum] == nil)
				v.characterselectportraits[fnum] = v.cachePatch(playerinfo[fnum].characterselectportrait)
			end
			fnum = $1 + 1
		end
		fnum = 0
		while(fnum < numplayers)
			if(v.characterselectcircles[fnum] == nil)
				v.characterselectcircles[fnum] = v.cachePatch(playerinfo[fnum].characterselectcircle)
			end
			fnum = $1 + 1
		end
	end
	if(player.gamemode == 0)
		or(players[player.host].gamemode == 0)
		// Draw the black background
		if(players[player.host].aosplayers[32].currentattack == 4)
			or(players[player.host].aosplayers[32].currentattack == 5)
			local trans = 10-(players[player.host].aosplayers[32].attacktimer/3)
			if(players[player.host].aosplayers[32].currentattack == 5)
				trans = (players[player.host].aosplayers[32].attacktimer/3)
			end
			if not(trans > 10)
				if(trans < 0)
					trans = 0
				end
				trans = $1 * V_10TRANS
				v.draw(0, 0, v.dumbblack, trans|V_SNAPTOTOP|V_SNAPTOLEFT)
				local snum = 0
				local sangle = FixedAngle(leveltime*3*FRACUNIT/TICRATE)
				local distoff = 0
				while(snum < 60)
					local dist = ((leveltime+distoff)%(TICRATE*5/2))*FRACUNIT*36*10
					dist = FixedSqrt($1)*2
					drawStar(v, player, dist, sangle, trans)
					distoff = $1 + 48114
					sangle = $1 + FixedAngle(351331*FRACUNIT)
					snum = $1 + 1
				end
			end
		end

		drawCircleArena(v, players[player.host])
		if(players[player.host].aosplayers[#player].exists)
			and not(players[player.host].aosplayers[#player].deathtimer >= deathtime)
			drawPlayerWheel(v, players[player.host], #player)
		end
		// Draw trails
		local pnum = 0
		while(pnum < players[player.host].numplayers)
			if not(players[player.host].aosplayers[pnum].deathtimer >= deathtime)
				and(players[player.host].aosplayers[pnum].dashing)
				and(players[player.host].aosplayers[pnum].exists)
				local flag = V_80TRANS
				local aosp = players[player.host].aosplayers[pnum]
				local prvnum = maxprev-1
				while(prvnum >= 0)
					drawTrail(v, players[player.host], aosp, aosp.prevx[prvnum], aosp.prevy[prvnum], aosp.prevframe[prvnum], aosp.prevangle[prvnum], aosp.prevflip[prvnum], flag, aosp.character, 5-prvnum)
					flag = $1 - V_20TRANS
					prvnum = $1 - 1
				end
			end
			pnum = $1 + 1
		end

		// Draw objects!
		local onum = 0
		while(onum < maxobjects)
			if(players[player.host].aosobjects[onum].exists)
				and not(players[player.host].aosobjects[onum].aboveplayers)
				drawObject(v, players[player.host], players[player.host].aosobjects[onum])
			end
			onum = $1 + 1
		end
		pnum = 0
		while(pnum < players[player.host].numplayers)
			if not(players[player.host].aosplayers[pnum].deathtimer >= deathtime)
				and(players[player.host].aosplayers[pnum].exists)
				and(pnum == 32 or (players[pnum] and players[pnum].valid))
				drawPlayer(v, players[player.host], pnum, false)
			elseif(players[player.host].aosplayers[pnum].exists)
				and(pnum == 32 or (players[pnum] and players[pnum].valid))
				drawDeathSwoosh(v, players[player.host], pnum)
			end
			pnum = $1 + 1
		end
		// Draw objects x2!
		local onum = 0
		while(onum < maxobjects)
			if(players[player.host].aosobjects[onum].exists)
				and(players[player.host].aosobjects[onum].aboveplayers)
				drawObject(v, players[player.host], players[player.host].aosobjects[onum])
			end
			onum = $1 + 1
		end
		if(debugboxes)
			onum = 0
			while(onum < maxobjects)
				if(players[player.host].aosobjects[onum].exists)
					and(players[player.host].aosobjects[onum].width)
					and(players[player.host].aosobjects[onum].height)
					drawBox(v, player, players[player.host].aosobjects[onum].x, players[player.host].aosobjects[onum].y, players[player.host].aosobjects[onum].width, players[player.host].aosobjects[onum].height, players[player.host].aosobjects[onum].angle, 1)
				end
				onum = $1 + 1
			end
			pnum = 0
			while(pnum < players[player.host].numplayers)
				if(players[player.host].aosplayers[pnum].exists)
					drawBox(v, player, players[player.host].aosplayers[pnum].x, players[player.host].aosplayers[pnum].y, players[player.host].aosplayers[pnum].width, players[player.host].aosplayers[pnum].height, 0)
				end
				pnum = $1 + 1
			end
		end
		pnum = 0
		while(pnum < players[player.host].numplayers)
		//	if not(players[player.host].aosplayers[pnum].deathtimer >= deathtime)
		//		drawAmmo(v, players[player.host], players[player.host].aosplayers[pnum].x, players[player.host].aosplayers[pnum].y, players[player.host].aosplayers[pnum].beamammo, players[player.host].aosplayers[pnum].ballisticammo)
		//	end
		//	if(players[player.host].numplayers > 2)
			if(players[player.host].aosplayers[player.clientnum].target == pnum)
				and(players[player.host].aosplayers[pnum].exists)
				drawLockon(v, players[player.host], players[player.host].aosplayers[players[player.host].aosplayers[player.clientnum].target])
			end
			pnum = $1 + 1
		end

		if(players[player.host].startcuttime > startcuttime)
			// Draw the hud!
			v.drawString(50, 2, playerinfo[players[player.host].aosplayers[player.clientnum].character].name, V_SNAPTOTOP|V_SNAPTOLEFT, "left")
			drawHealthBar(v, 20, 15, players[player.host].aosplayers[player.clientnum].health, players[player.host].aosplayers[player.clientnum].redhealth, false)
			drawHyperBar(v, 3, 1, players[player.host].aosplayers[player.clientnum].hyper)
			drawHeat(v, 105, 32, players[player.host].aosplayers[player.clientnum].heat)
		//	if(players[player.host].aosplayers[player.clientnum].target >= 0)
			if not(players[player.host].aosplayers[32].currentattack == 4)
				and not(players[player.host].aosplayers[32].currentattack == 5)
				and not(players[player.host].aosplayers[32].currentattack == 27)
				v.drawString(270, 2, playerinfo[players[player.host].aosplayers[32].character].name, V_SNAPTOTOP|V_SNAPTORIGHT, "right")
				drawHealthBar(v, 199, 15, players[player.host].aosplayers[32].health, 0, true)
			//	drawHeat(v, 205, 32, players[player.host].aosplayers[players[player.host].aosplayers[player.clientnum].target].heat)
			end
	//		v.drawString(160, 20, (players[player.host].aostimer+(TICRATE-1))/TICRATE, 0, "center")
	//	else
			// Start stuff
	//		drawStartStuff(v, players[player.host], 180*TICRATE-players[player.host].aostimer)
		end

		// Draw the white flash
		local trans = abs((startcuttime/2) - players[player.host].startcuttime)/3
		if not(trans > 10)
			if(trans < 0)
				trans = 0
			end
			trans = $1 * V_10TRANS
			v.draw(0, 0, v.dumbwhite, trans|V_SNAPTOTOP|V_SNAPTOLEFT)
		end
	elseif(players[player.host].gamemode == 6)
		and not(modeattacking)
		v.draw(1, 0, v.howtoplay[players[player.host].howtoplayscreen])
	elseif(player.gamemode == 1)
		v.draw(0, 160, v.textbar, V_50TRANS)
		local dumbsel1 = player.selection - 1
		local dumbsel2 = player.selection - 2
		if(dumbsel1 < 0)
			dumbsel1 = $1 + 2
		end
		if(dumbsel2 < 0)
			dumbsel2 = $1 + 2
		end
		if(player.selmovetime > 0)
			v.drawString(-20+(player.selmovetime*90/(TICRATE/2))-12, 165, options[dumbsel2], 0, "center")
		end
		v.drawString(70+(player.selmovetime*90/(TICRATE/2))-12, 165, options[dumbsel1], 0, "center")
		v.drawString(160+(player.selmovetime*90/(TICRATE/2))-4, 165, options[player.selection], V_YELLOWMAP, "center")
		v.drawString(270+(player.selmovetime*90/(TICRATE/2))-12, 165, options[(player.selection+1)%2], 0, "center")
		if(player.selmovetime < 0)
			v.drawString(360+(player.selmovetime*90/(TICRATE/2))-12, 165, options[(player.selection+2)%2], 0, "center")
		end
	elseif(player.gamemode == 2)
		v.draw(0, 30+(player.selmovetime*130/(TICRATE/2)), v.textbar, V_50TRANS)
		v.drawString(108, 35+(player.selmovetime*130/(TICRATE/2)), "Select a lobby.", V_BLUEMAP)
		v.draw(0, 50+(player.selmovetime*155/(TICRATE/2)), v.textbar, V_50TRANS)
		local createmap = 0
		if not(player.selection)
			createmap = V_YELLOWMAP
		end
		v.drawString(110, 55+(player.selmovetime*155/(TICRATE/2)), "Create a lobby", createmap)

		// Look for lobbies!
		local numhosts = 0
		local hosts = {}
		local numplayers = {}
		for player2 in players.iterate
			if(player2.host == #player2)
				and(player2.gamemode == 3)
				hosts[numhosts] = #player2
				numplayers[numhosts] = 0
				local pnum = 0
				while(pnum < 32)
					if not(player2.clients[pnum] == -1)
						numplayers[numhosts] = $1 + 1
					end
					pnum = $1 + 1
				end
				numhosts = $1 + 1
			end
		end

		local hnum = 0
		while(hnum < numhosts)
			local map = 0
			if(player.selection == hnum+1)
				map = V_YELLOWMAP
			end
			v.draw(0, 80+(20*hnum)+(player.selmovetime*155/(TICRATE/2)), v.textbar, V_50TRANS)
			v.drawString(20, 85+(20*hnum)+(player.selmovetime*155/(TICRATE/2)), "Join "+players[hosts[hnum]].name+"'s lobby", map)
			v.drawString(240, 85+(20*hnum)+(player.selmovetime*155/(TICRATE/2)), numplayers[hnum], map)
			hnum = $1 + 1
		end
	elseif(player.gamemode == 3)
		local pnum = 0
		while(players[player.host].clients[pnum] >= 0)
			v.draw(0, 20+(20*pnum), v.textbar, V_50TRANS)
			v.drawString(20, 25+(20*pnum), players[players[player.host].clients[pnum]].name)
			pnum = $1 + 1
		end
	elseif(player.gamemode == 4)
			//	if(player.numplayers > 1)
		/*			player.gamemode = 0
					if(player.numplayers < 2)
						player.numplayers = 2
					end
					AOSStartGame(player)*/
			//	end
		v.draw(0, 0, v.characterselectbg1)
		local angle = 0//leveltime*FRACUNIT*10
		local numballs = 10
		if(players[player.host].numplayers == 2)
			local char1 = players[player.host].character
			local char2 = player.character
			if(player.host == #player)
			//	char1 = player.character
				if(player.clients[1] == -1)
					char2 = 1
				else
					char2 = players[player.clients[1]].character
				end
			end
			v.drawScaled(60*FRACUNIT, 100*FRACUNIT, FRACUNIT/2, v.characterselectportraits[char1])
			v.drawScaled(260*FRACUNIT, 100*FRACUNIT, FRACUNIT/2, v.characterselectportraits[char2], V_FLIP)
		else
			// Our character only! On the left!
			v.drawScaled(60*FRACUNIT, 100*FRACUNIT, FRACUNIT/2, v.characterselectportraits[player.character])
		end
		v.draw(96, 0, v.characterselectbg2)
		// Draw the balls!
		if(players[player.host].numplayers == 2)
			local char1 = players[player.host].character+(numplayers*5)
			local char2 = player.character+(numplayers*5)
			local selmove1 = players[player.host].selmovetime
			local selmove2 = player.selmovetime
			if(player.host == #player)
				if(player.clients[1] == -1)
					char2 = 1+(numplayers*5)
					selmove2 = 0
				else
					char2 = players[player.clients[1]].character+(numplayers*5)
					selmove2 = players[player.clients[1]].selmovetime
				end
			end
			local chars1 = {}
			chars1[0] = (char1-5)%numplayers
			chars1[1] = (char1-4)%numplayers
			chars1[2] = (char1-3)%numplayers
			chars1[3] = (char1-2)%numplayers
			chars1[4] = (char1-1)%numplayers
			chars1[5] = (char1)%numplayers
			chars1[6] = (char1+1)%numplayers
			chars1[7] = (char1+2)%numplayers
			chars1[8] = (char1+3)%numplayers
			chars1[9] = (char1+4)%numplayers
			chars1[10] = (char1+5)%numplayers
			local chars2 = {}
			chars2[0] = (char2-5)%numplayers
			chars2[1] = (char2-4)%numplayers
			chars2[2] = (char2-3)%numplayers
			chars2[3] = (char2-2)%numplayers
			chars2[4] = (char2-1)%numplayers
			chars2[5] = (char2)%numplayers
			chars2[6] = (char2+1)%numplayers
			chars2[7] = (char2+2)%numplayers
			chars2[8] = (char2+3)%numplayers
			chars2[9] = (char2+4)%numplayers
			chars2[10] = (char2+5)%numplayers
			local bnum = 0
			angle = $1 - 135*FRACUNIT
			local angle2 = angle
			angle = $1 + selmove1*(240*FRACUNIT/numballs)/(TICRATE/4)
			angle2 = $1 + selmove2*(240*FRACUNIT/numballs)/(TICRATE/4)
			while(bnum < numballs)
				v.drawScaled(cos(FixedAngle(angle))*80, (100*FRACUNIT)+(sin(FixedAngle(angle))*80), FRACUNIT/3, v.characterselectcircle)
				v.drawScaled(cos(FixedAngle(angle))*80, (100*FRACUNIT)+(sin(FixedAngle(angle))*80), FRACUNIT/3, v.characterselectcircles[chars1[bnum]])
				v.drawScaled((320*FRACUNIT)-(cos(FixedAngle(angle2))*80), (100*FRACUNIT)+(sin(FixedAngle(angle2))*80), FRACUNIT/3, v.characterselectcircle)
				v.drawScaled((320*FRACUNIT)-(cos(FixedAngle(angle2))*80), (100*FRACUNIT)+(sin(FixedAngle(angle2))*80), FRACUNIT/3, v.characterselectcircles[chars2[bnum]])
				angle = $1 + (270*FRACUNIT/numballs)
				angle2 = $1 + (270*FRACUNIT/numballs)
				bnum = $1 + 1
			end
			// Draw the names
			v.drawString(106, 85, playerinfo[chars1[5]].name, 0, "left")
			v.drawString(214, 115, playerinfo[chars2[5]].name, 0, "right")
		else
			local char1 = player.character+(numplayers*5)
			local selmove1 = player.selmovetime
			local chars1 = {}
			chars1[0] = (char1-5)%numplayers
			chars1[1] = (char1-4)%numplayers
			chars1[2] = (char1-3)%numplayers
			chars1[3] = (char1-2)%numplayers
			chars1[4] = (char1-1)%numplayers
			chars1[5] = (char1)%numplayers
			chars1[6] = (char1+1)%numplayers
			chars1[7] = (char1+2)%numplayers
			chars1[8] = (char1+3)%numplayers
			chars1[9] = (char1+4)%numplayers
			chars1[10] = (char1+5)%numplayers
			local bnum = 0
			angle = $1 - 135*FRACUNIT
			angle = $1 + selmove1*(240*FRACUNIT/numballs)/(TICRATE/4)
			while(bnum < numballs)
				v.drawScaled(cos(FixedAngle(angle))*80, (100*FRACUNIT)+(sin(FixedAngle(angle))*80), FRACUNIT/3, v.characterselectcircle)
				v.drawScaled(cos(FixedAngle(angle))*80, (100*FRACUNIT)+(sin(FixedAngle(angle))*80), FRACUNIT/3, v.characterselectcircles[chars1[bnum]])
				angle = $1 + (270*FRACUNIT/numballs)
				bnum = $1 + 1
			end
			// Draw the names
			v.drawString(106, 85, playerinfo[chars1[5]].name, 0, "left")
		end

		// Draw readiness!
		local ready1 = false
		local ready2 = false
		if(players[player.host].numplayers == 2)
			if(#player == player.host)
				ready1 = player.ready
				ready2 = players[player.clients[1]].ready
			else
				ready1 = players[player.host].ready
				ready2 = player.ready
			end
		else
			ready1 = player.ready
		end

		if(ready1)
			v.drawString(100, 10, "READY", 0, "left")
		end
		if(ready2)
			v.drawString(220, 10, "READY", 0, "right")
		end
	end

	// Draw death fade
	local trans = (players[player.host].sonigurideathfadetimer*10)/deathfadetime
	if not(trans > 10)
		if(trans < 0)
			trans = 0
		end
		trans = $1 * V_10TRANS
		v.draw(0, 0, v.dumbblack, trans|V_SNAPTOTOP|V_SNAPTOLEFT)
	end
end
hud.add(drawAOS, "game")
hud.add(drawAOS, "scores")
