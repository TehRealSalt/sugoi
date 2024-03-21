-- the rising bubble from 8bit sonic 2, recreated in lua

-- player handling!
freeslot("S_PLAY_GGZ_BUBBLE", "S_PLAY_GGZ_BUBBLEFAST")
states[S_PLAY_GGZ_BUBBLE] = {SPR_PLAY, A|SPR2_EDGE, 9, nil, 0, 0, S_PLAY_GGZ_BUBBLE}
states[S_PLAY_GGZ_BUBBLEFAST] = {SPR_PLAY, A|SPR2_EDGE, 2, nil, 0, 0, S_PLAY_GGZ_BUBBLEFAST}

glacierglaze.InBubble = function(p)
	local mo = p.mo
	mo.ggz = $ or {}

	local bubble = mo.ggz.bubble
	if not (bubble and bubble.valid) then return false end

	return true
end

glacierglaze.BubblePlayer = function(p, targmo)
	local mo = p.mo
	if not ((mo and mo.valid) and mo.health) then return end
	local ggz = mo.ggz
	targmo = $ or mo	-- make sure targmo exists, otherwise just spawn from the player

	-- remove these
	local fields = {"charability", "charability2"}
	for k, v in pairs(fields)
		p[v] = 0
	end

	-- player stuff
	p.pflags = ($|PF_THOKKED) & ~(PF_JUMPED|PF_SPINNING|PF_SHIELDABILITY)	-- remove these, and make it so we have PF_THOKKED (whirlwind shield)
	p.secondjump = 0
	p.powers[pw_underwater] = underwatertics
	ggz.bubbleprevmoms = {mo.momx, mo.momy, mo.momz}
	P_RestoreMusic(p)
	S_StartSound(mo, sfx_glgz3)
	ggz.bubbledirection = P_MobjFlip(targmo)

	-- spawn a fake bubble that'll stick with the player
	local fakebubble = P_SpawnMobjFromMobj(targmo, 0, 0, 0, MT_THOK)	-- we'll use MT_THOK so we can set scale accordingly
	fakebubble.scale = FixedMul(mo.scale, glacierglaze.BubbleScaleModifier)
	fakebubble.state = S_GGZ_BUBBLE
	fakebubble.radius = FixedMul(fakebubble.scale, mobjinfo[MT_GGZ_BUBBLE].radius)
	fakebubble.height = FixedMul(fakebubble.scale, mobjinfo[MT_GGZ_BUBBLE].height)
	fakebubble.target = mo
	ggz.bubble = fakebubble	-- we'll need to keep track of this in the player
end
glacierglaze.ResetBubbleStats = function(p)
	local skin = skins[p.skin]
	p.charability = skin["ability"]
	p.charability2 = skin["ability2"]
	p.ggz_resetbubble = nil	-- wont need this anymore, natural reset
end
glacierglaze.ResetBubble = function(p)
	local mo = p.mo
	local ggz = mo.ggz

	mo.flags = $ & ~(MF_NOGRAVITY)
	ggz.bubble = nil
	ggz.bubbledirection = nil
	ggz.bubbleprevmoms = nil
	ggz.bubblebounce = nil
	glacierglaze.ResetBubbleStats(p)
end

local function ggz_burstbubbles(mo)
	if not (mo and mo.valid) then return end
	local info = {mo.scale, mo.radius>>FRACBITS, mo.height>>FRACBITS}

	local bubbleList = {MT_SMALLBUBBLE, MT_MEDIUMBUBBLE}
	for i = 1, 16
		local xoff = FixedMul(info[1], P_RandomRange(-(info[2]), info[2])*FRACUNIT)
		local yoff = FixedMul(info[1], P_RandomRange(-(info[2]), info[2])*FRACUNIT)
		local zoff = FixedMul(info[1], P_RandomRange(0, info[3])*FRACUNIT)

		local bubble = P_SpawnMobjFromMobj(mo, xoff, yoff, zoff, bubbleList[P_RandomRange(1, #bubbleList)])
		P_InstaThrust(bubble, R_PointToAngle2(bubble.x, bubble.y, mo.x, mo.y), -(FixedMul(info[1], P_RandomRange(4, 6)*FRACUNIT)))
		P_SetObjectMomZ(bubble, P_RandomRange(-5, 5)*FRACUNIT)
	end
end

glacierglaze.S2Bubble = function(p)
	local mo = p.mo
	if not (mo and mo.valid) then return end
	local ggz = mo.ggz

	-- debug command to give a bubble
	if (glacierglaze.debug and (p.cmd.buttons & BT_CUSTOM3))
	and not (glacierglaze.InBubble(p))
	and not (glacierglaze.IsPlayerFrozen(p))
		glacierglaze.BubblePlayer(p)
	end

	-- bubble checks
	if not (glacierglaze.InBubble(p))
		if (p.ggz_resetbubble) then glacierglaze.ResetBubbleStats(p) end
		return
	end
	local bubble = ggz.bubble
	local dir = ggz.bubbledirection

	ggz.bubblebounce = $ and $-1 or 0
	local state = (ggz.bubblebounce) and S_GGZ_BUBBLE_BOUNCE or S_GGZ_BUBBLE
	if (bubble.state != state) then bubble.state = state end
	bubble.scale = FixedMul(p.shieldscale, FixedMul(glacierglaze.BubbleScaleModifier, mo.scale))
	-- position is gonna be a PAIN
	if (mo.eflags & MFE_VERTICALFLIP)
		local zpos = mo.z + mo.height - bubble.height
		if not (bubble.eflags & MFE_VERTICALFLIP) then zpos = mo.z - FixedMul(bubble.scale, 16*FRACUNIT) end
		P_MoveOrigin(bubble, mo.x, mo.y, zpos)
	else
		local zpos = mo.z
		if (bubble.eflags & MFE_VERTICALFLIP) then zpos = mo.z + mo.height - bubble.height + FixedMul(bubble.scale, 16*FRACUNIT) end
		P_MoveOrigin(bubble, mo.x, mo.y, zpos)
	end

	-- player stuff
	local state = (p.charflags & SF_FASTEDGE) and S_PLAY_GGZ_BUBBLEFAST or S_PLAY_GGZ_BUBBLE
	if (mo.state != state) then mo.state = state end
	p.pflags = ($|PF_THOKKED) & ~(PF_JUMPED|PF_SPINNING|PF_SHIELDABILITY)	-- remove these, and make it so we have PF_THOKKED (whirlwind shield)
	p.secondjump = 0
	p.powers[pw_underwater] = underwatertics
	mo.flags = $|MF_NOGRAVITY	-- we want no gravity!
	P_RestoreMusic(p)

	-- remove these
	local fields = {"charability", "charability2"}
	for k, v in pairs(fields)
		p[v] = 0
	end
	p.ggz_resetbubble = true

	-- check for surfaces of water FOFs
	local checkz = mo.z + (mo.height/2)	-- we always want the middle of us
	local checksurface = mo.watertop
	if (dir == -1) then checksurface = mo.waterbottom end

	local bouncetics = glacierglaze.BubbleBounceTics
	if (abs(checkz - checksurface) <= (mo.momz*dir))
	and (mo.momz*dir >= 0)	-- only going UP to the surface (or we're already on it)
		mo.momz = 0
		P_MoveOrigin(mo, mo.x, mo.y, checksurface - ((mo.height/2)*dir))
	elseif (mo.eflags & MFE_UNDERWATER)	-- we need to be underwater
		-- bounce on floors before momentum is set
		if (P_IsObjectOnGround(mo))
			local prevmomz = ggz.bubbleprevmoms[3]
			local flipped = (mo.eflags & MFE_VERTICALFLIP)

			if (((flipped) and prevmomz > 0) or (not (flipped) and prevmomz < 0))
				mo.momz = -prevmomz
				ggz.bubblebounce = glacierglaze.BubbleBounceTics
				S_StartSound(mo, sfx_glgz3)
			end
		end

		-- momentum
		local threshold = glacierglaze.BubbleSpinThreshold
		local spinheld = (p.cmd.buttons & BT_SPIN)

		local maxmult = 10
		local bubblemomz = 2048 * (((mo.momz*dir < threshold) and not ggz.bubblebounce) and maxmult or 1)
		if (ggz.bubblebounce)	-- make bounces a bit more impactful
			local multiplier = (bouncetics - ggz.bubblebounce)*maxmult/bouncetics
			bubblemomz = $ * multiplier
		end

		if (p.cmd.buttons & BT_SPIN)
			if (mo.momz*dir >= threshold)
				bubblemomz = -4096
			else
				bubblemomz = $/3
			end
		end
		mo.momz = $ + FixedMul(mo.scale, bubblemomz * ggz.bubbledirection)
	else
		-- not in water, remove nogravity
		mo.flags = $ & ~(MF_NOGRAVITY)
	end
	ggz.bubbleprevmoms = {mo.momx, mo.momy, mo.momz}	-- keep this updated

	-- hit a ceiling, reverse our momz!
	local checkz = mo.z + bubble.height
	if (mo.eflags & MFE_VERTICALFLIP) then checkz = mo.z + mo.height - bubble.height end
	checkz = $ + mo.momz
	local ceilingcheck = false

	if (checkz >= mo.ceilingz)
	or (checkz <= mo.floorz)
		if (mo.momz*dir > 0)	-- only if we're going up
			mo.momz = -mo.momz
			ggz.bubblebounce = glacierglaze.BubbleBounceTics
			S_StartSound(mo, sfx_glgz3)
		end
	end

	-- END CONDITIONS
	local function endBubble()
		-- bubble stuff
		ggz_burstbubbles(bubble)
		P_RemoveMobj(bubble)

		-- player stuff
		glacierglaze.ResetBubble(p)
		S_StartSound(mo, sfx_glgz4)
	end

	-- we got frozen
	if (glacierglaze.IsPlayerFrozen(p))
		endBubble()
		return
	end

	if (P_IsObjectOnGround(mo))	-- multiple end conditions here
	and not (mo.eflags & MFE_UNDERWATER)	-- out of water, burst bubble
		mo.state = S_PLAY_RUN
		endBubble()
		return
	end

	-- jump out
	if (ggz.jump == 1)	-- just pressed jump
		if (ggz.jump == 1)
			P_DoJump(p)
			p.pflags = $ & ~(PF_THOKKED)
		end
		endBubble()
		return
	end
end

-- damage function
glacierglaze.BubbleDamage = function(mo, inflictor, source)
	if not ((mo and mo.valid) and mo.health) then return end
	local p = mo.player
	if not (glacierglaze.InBubble(p)) then return end

	-- bubble stuff
	local bubble = mo.ggz.bubble
	ggz_burstbubbles(bubble)
	P_RemoveMobj(bubble)

	-- player stuff
	glacierglaze.ResetBubble(p)
	S_StartSound(mo, sfx_glgz4)
end

-- collide function to ignore extra large bubbles
glacierglaze.BubbleCollide = function(mo, mo2)
	if not ((mo and mo.valid) and mo.health) then return end
	local p = mo.player
	if not (p and p.valid) then return end
	if not (glacierglaze.InBubble(p)) then return end

	-- ignore extra large bubbles, we're already in one!
	if (mo2.type == MT_EXTRALARGEBUBBLE) then return false end
end

-- wall collide function
glacierglaze.BubbleWallCollide = function(p, line, side)
	local mo = p.mo
	if not ((mo and mo.valid) and mo.health) then return end
	if not (glacierglaze.InBubble(p)) then return end
	local ggz = mo.ggz
	local moms = ggz.bubbleprevmoms

	-- mo and wall info
	local momangle = R_PointToAngle2(0, 0, moms[1], moms[2])
	local wallangle = R_PointToAngle2(line.v1.x, line.v1.y, line.v2.x, line.v2.y)
	if (wallangle < 0) then wallangle = $ + ANGLE_180 end

	-- get reflection angle
	local incidence = wallangle - momangle
	local reflection = wallangle + incidence
	local speed = FixedHypot(moms[1], moms[2])

	-- bounce off wall
	mo.momx = FixedMul(speed, cos(reflection))
	mo.momy = FixedMul(speed, sin(reflection))
	ggz.bubblebounce = glacierglaze.BubbleBounceTics
	S_StartSound(mo, sfx_glgz3)
end

-- the actual 8bit s2 bubble
freeslot("MT_GGZ_BUBBLE", "S_GGZ_BUBBLE_SPAWN", "S_GGZ_BUBBLE", "S_GGZ_BUBBLE_BOUNCE", "S_GGZ_BUBBLE_DEATH", "SPR_GGZ6")
states[S_GGZ_BUBBLE_SPAWN] = {SPR_GGZ6, A|FF_ANIMATE, -1, nil, 3, 2, S_GGZ_BUBBLE_SPAWN}
states[S_GGZ_BUBBLE] = {SPR_GGZ6, A|FF_ANIMATE, -1, nil, 3, 4, S_GGZ_BUBBLE}
states[S_GGZ_BUBBLE_BOUNCE] = {SPR_GGZ6, A|FF_ANIMATE, -1, nil, 3, 1, S_GGZ_BUBBLE_BOUNCE}
states[S_GGZ_BUBBLE_DEATH] = {SPR_NULL, A, 5, A_Scream, 0, 0, S_NULL}
mobjinfo[MT_GGZ_BUBBLE] = {
	spawnstate = S_GGZ_BUBBLE_SPAWN,
	deathstate = S_GGZ_BUBBLE_DEATH,
	deathsound = sfx_glgz4,
	radius = 32*FRACUNIT,
	height = 60*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY,
}
addHook("MobjThinker", function(mo)
	if not (mo.health) then return end

	A_BubbleRise(mo, 1, 2048)
	if (mo.state == S_GGZ_BUBBLE_SPAWN)
		if (mo.scale != mo.destscale) then return end

		mo.state = S_GGZ_BUBBLE
		mo.flags = $|MF_SPECIAL
	end

	-- ceiling checks
	local checkz = mo.z + mo.height
	if (mo.eflags & MFE_VERTICALFLIP) then checkz = mo.z end
	checkz = $ + mo.momz
	local ceilingcheck = false

	if (checkz >= mo.ceilingz)
	or (checkz <= mo.floorz)
		ceilingcheck = true
	end

	-- burst the bubble under these conditions
	if not (mo.eflags & MFE_UNDERWATER)	-- not underwater
	or (ceilingcheck)	-- hit the ceiling
		ggz_burstbubbles(mo)
		P_KillMobj(mo)
	end
end, MT_GGZ_BUBBLE)
addHook("TouchSpecial", function(bubble, mo)
	local p = mo.player
	if (glacierglaze.InBubble(p)) then return true end
	if not ((mo and mo.valid) and mo.health) then return true end

	-- if we're frozen, just burst the bubble
	if (glacierglaze.IsPlayerFrozen(p))
		ggz_burstbubbles(bubble)
		P_KillMobj(bubble)
		return true
	end

	-- bubble the player!
	P_MoveOrigin(mo, bubble.x, bubble.y, bubble.z)
	glacierglaze.BubblePlayer(p, bubble)

	-- remove the old one
	P_RemoveMobj(bubble)
	return true
end, MT_GGZ_BUBBLE)

-- the 8bit s2 bubble spawn
freeslot("MT_GGZ_BUBBLESPAWN", "S_GGZ_BUBBLESPAWN")
states[S_GGZ_BUBBLESPAWN] = {SPR_BBLS, A|FF_ANIMATE, -1, nil, 3, 8, S_GGZ_BUBBLESPAWN}
mobjinfo[MT_GGZ_BUBBLESPAWN] = {
	--$Name Glacier Glaze Bubble Spawner
	--$Sprite BBLSA0
	--$Category SUGOI Items & Hazards
	doomednum = 772,
	spawnstate = S_GGZ_BUBBLESPAWN,
	radius = 8*FRACUNIT,
	height = 8*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_SCENERY,
}
addHook("MobjThinker", function(mo)
	if not (mo.ggz_rescaled)
		mo.ggz_scale = mo.scale
		mo.ggz_rescaled = true

		-- now increase scale
		mo.scale = FixedMul(glacierglaze.BubblePatchScaleModifier, $)
	end

	-- fisher price A_BubbleSpawn
	mo.ggz_timer = $ and $+1 or 1	-- doing this so we have the time since spawned

	-- only spawn bubbles if a player is close!
	if not (mo.flags2 & MF2_AMBUSH)	-- unless ambush is checked
		local closeplayer = false
		for p in players.iterate
			if not (p.mo and p.mo.valid) then continue end

			local checkdist = glacierglaze.BubblePatchDistance
			if (R_PointToDist2(mo.x, mo.y, p.mo.x, p.mo.y) < checkdist)
				-- player is close, we can spawn
				closeplayer = true
				break
			end
		end
		if not (closeplayer) then return end
	end

	local checktics = 8	-- duration to spawn a bubble
	if not (mo.ggz_timer%checktics)
		local chance = P_RandomByte()

		local spawntics = (mo.spawnpoint.angle) or glacierglaze.BubblePatchSpawnTics
		if (leveltime % (spawntics) < checktics)
			-- spawn the bubble
			local bubble = P_SpawnMobjFromMobj(mo, 0, 0, (mo.height/2), MT_GGZ_BUBBLE)
			bubble.scale = mo.ggz_scale/5
			bubble.destscale = FixedMul(glacierglaze.BubbleScaleModifier, mo.ggz_scale)
			bubble.scalespeed = FRACUNIT/24

			-- fix z pos for flipped gravity
			if (bubble.eflags & MFE_VERTICALFLIP)
				local newz = mo.z + mo.height
				newz = $ + (bubble.height*P_MobjFlip(mo))
				P_MoveOrigin(bubble, bubble.x, bubble.y, newz)
			end

			-- play a sound
			S_StartSound(mo, sfx_splash)
		elseif (chance > 144)
			P_SpawnMobjFromMobj(mo, 0, 0, (mo.height/2), MT_SMALLBUBBLE)
		elseif (chance > 96 and chance < 144)
			P_SpawnMobjFromMobj(mo, 0, 0, (mo.height/2), MT_MEDIUMBUBBLE)
		end
	end
end, MT_GGZ_BUBBLESPAWN)