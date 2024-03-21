-- freeze the player completely solid (inspired from press garden act 2)

-- particles
freeslot("MT_GGZ_PARTICLE",
"S_GGZ_PARTICLE_SMALL", "SPR_GGZ4",
"S_GGZ_PARTICLE_LARGE", "SPR_GGZ5")
states[S_GGZ_PARTICLE_SMALL] = {SPR_GGZ4, A|FF_ANIMATE|FF_FULLBRIGHT, -1, nil, 7, 1, S_GGZ_PARTICLE_SMALL}
states[S_GGZ_PARTICLE_LARGE] = {SPR_GGZ5, A|FF_ANIMATE|FF_FULLBRIGHT, -1, nil, 3, 1, S_GGZ_PARTICLE_LARGE}
mobjinfo[MT_GGZ_PARTICLE] = {
	spawnstate = S_GGZ_PARTICLE_SMALL,
	deathstate = S_NULL,
	radius = 8*FRACUNIT,
	height = 16*FRACUNIT,
	flags = MF_SCENERY|MF_NOBLOCKMAP,
}
addHook("MobjThinker", function(mo)
	if (P_IsObjectOnGround(mo)) then P_RemoveMobj(mo) end
end, MT_GGZ_PARTICLE)
glacierglaze.SpawnIceParticles = function(mo, amount, scale, big)
	local info = {scale, mo.radius>>FRACBITS, mo.height>>FRACBITS}

	for i = 1, max(1, amount)
		local xoff = FixedMul(info[1], P_RandomRange(-(info[2]), info[2])*FRACUNIT)
		local yoff = FixedMul(info[1], P_RandomRange(-(info[2]), info[2])*FRACUNIT)
		local zoff = FixedMul(info[1], P_RandomRange(0, info[3])*FRACUNIT)

		local ice = P_SpawnMobjFromMobj(mo, xoff, yoff, zoff, MT_GGZ_PARTICLE)
		ice.state = (big) and S_GGZ_PARTICLE_LARGE or S_GGZ_PARTICLE_SMALL
		ice.scale = info[1]
		ice.fuse = glacierglaze.FrozenProjectLifetime

		-- set momentum
		local mommo = mo
		if (mo.player and mo.player.powers[pw_carry] == CR_MINECART)
		and (mo.tracer and mo.tracer.valid)	-- minecart is alive
			mommo = mo.tracer	-- just so we can take into account minecart momentum instead!
		end
		local moms = (big) and {6, {11, 15}} or {8, {6, 11}}

		ice.momx = mommo.momx + P_RandomRange(-(moms[1]), moms[1])*FRACUNIT
		ice.momy = mommo.momy + P_RandomRange(-(moms[1]), moms[1])*FRACUNIT
		ice.momz = mommo.momz + ((P_RandomRange(moms[2][1], moms[2][2])*FRACUNIT)*P_MobjFlip(mo))
	end
end

-- player functionality
freeslot("S_PLAY_GGZ_FROZEN", "SPR2_FROZ",
"S_PLAY_GGZ_FROZEN_WIGGLE", "SPR2_FRZW",
"SPR_GGZ3")
spr2defaults[SPR2_FROZ] = SPR2_DEAD	-- just incase people want to go the extra mile!
spr2defaults[SPR2_FRZW] = SPR2_DEAD	-- ditto, for wiggling
states[S_PLAY_GGZ_FROZEN] = {SPR_PLAY, A|SPR2_FROZ, -1, nil, 0, 0, S_PLAY_GGZ_FROZEN}
states[S_PLAY_GGZ_FROZEN_WIGGLE] = {SPR_PLAY, A|SPR2_FRZW, -1, nil, 0, 0, S_PLAY_GGZ_FROZEN_WIGGLE}

glacierglaze.FreezePlayer = function(p)
	local mo = p.mo
	if not ((mo and mo.valid) and mo.health) then return end
	mo.ggz = $ or {}
	local ggz = mo.ggz


	if (glacierglaze.IsPlayerProtected(p) == 2)	-- cant get frozen while heated
	or (glacierglaze.IsPlayerFrozen(p))	-- already frozen
		return
	end

	-- reduce all these to 0 so we cant move
	local fields = {"charability", "charability2", "jumpfactor", "normalspeed", "thrustfactor"}
	for k, v in pairs(fields)
		p[v] = 0
	end
	ggz.frozen = true
	ggz.frozenjumps = 0
	ggz.frozenangle = FixedHypot(mo.momx, mo.momy) and R_PointToAngle2(0, 0, mo.momx, mo.momy) or mo.angle
	ggz.frozenprevmoms = {mo.momx, mo.momy, mo.momz}
	ggz.frozenunderwater = p.powers[pw_underwater]
	p.powers[pw_underwater] = underwatertics
	p.powers[pw_flashing] = 0
	S_StartSound(mo, sfx_s3k80)
	if not (p.powers[pw_carry] == CR_MINECART)
		ggz.frozenprotection = glacierglaze.FrozenProtectionTics
	end
end

-- reset stats set in freeze
glacierglaze.ResetFreezeStats = function(p)
	local skin = skins[p.skin]
	local fields = {"jumpfactor", "normalspeed", "thrustfactor"}
	for k, v in pairs(fields)
		p[v] = skin[v]
	end
	-- too bad the structs have different fields... for some reason...
	p.charability = skin["ability"]
	p.charability2 = skin["ability2"]
	p.ggz_resetfreeze = nil	-- wont need this since this is a natural reset
end
glacierglaze.ResetFreeze = function(p)
	local mo = p.mo
	mo.ggz = $ or {}
	local ggz = mo.ggz

	-- show the player again
	mo.flags2 = $|(MF2_DONTDRAW)

	-- set back underwater stuff
	if (ggz.frozenunderwater)
		p.powers[pw_underwater] = ggz.frozenunderwater
		ggz.frozenunderwater = nil
	end

	-- reset .ggz struct
	ggz.frozen = nil
	ggz.frozenjumps = nil
	ggz.frozenwiggle = nil
	ggz.frozenprevmoms = nil
	glacierglaze.ResetFreezeStats(p)

	-- minecart stuff
	if (p.powers[pw_carry] == CR_MINECART)
	and (ggz.frozenminecart)
	and (mo.tracer and mo.tracer.valid)
		mo.tracer.flags2 = ggz.frozenminecart
	end
end

glacierglaze.IsPlayerFrozen = function(p)
	local mo = p.mo
	if not (mo and mo.valid)
		return false
	end

	mo.ggz = $ or {}

	local frozen = (mo.ggz.frozen) and true or false
	return frozen
end

glacierglaze.FrozenState = function(p)
	if (glacierglaze.debug and (p.cmd.buttons & BT_CUSTOM2)) then glacierglaze.FreezePlayer(p) end
	-- ^ debug command to get frozen

	local mo = p.mo
	local ggz = mo.ggz

	-- get rid of this when it's not needed
	if not (p.powers[pw_carry] == CR_MINECART)
		ggz.frozenminecart = nil
	end
	-- check if we're actually frozen
	if not (glacierglaze.IsPlayerFrozen(p))
		-- just to make sure stats are reset across levels
		if (p.ggz_resetfreeze) then glacierglaze.ResetFreezeStats(p) end

		-- remove protection frames
		if (P_IsObjectOnGround(mo)) then ggz.frozenprotection = 0 end
		ggz.frozenprotection = $ and $-1

		return
	end
	mo.friction = FRACUNIT	-- make us slide
	mo.state = S_PLAY_ROLL
	p.pflags = ($|PF_THOKKED) & ~(PF_JUMPED|PF_SPINNING|PF_SHIELDABILITY)	-- remove these, and make it so we have PF_THOKKED (whirlwind shield)
	p.secondjump = 0
	-- reduce all these to 0 so we cant move
	local fields = {"charability", "charability2", "jumpfactor", "normalspeed", "thrustfactor"}
	for k, v in pairs(fields)
		p[v] = 0
	end
	mo.friction = FRACUNIT	-- make us slide
	mo.flags = $|MF_SLIDEME	-- ditto, but across walls
	glacierglaze.SlowdownPlayer(p, true)
	p.ggz_resetfreeze = true
	p.powers[pw_underwater] = underwatertics	-- DONT drown.
	if not (p.powers[pw_carry] == CR_MINECART)
		ggz.frozenprotection = glacierglaze.FrozenProtectionTics	-- we'll have this constantly set so it's removed when not frozen
	end

	-- visuals (TODO: rotate with slopes?)
	local scale = FixedMul(p.shieldscale, FixedMul(mo.scale, glacierglaze.FrozenScale))

	-- spawn the top and bottom of the ice cube (based 2.2.9)
	local offset = -33	-- based on SPR_GGZ3 offsets, make it completely centred (y position)
	local xpos = FixedMul(p.shieldscale, FixedMul(glacierglaze.FrozenScale, offset*cos(ggz.frozenangle)))
	local ypos = FixedMul(p.shieldscale, FixedMul(glacierglaze.FrozenScale, offset*sin(ggz.frozenangle)))
	for i = 1, 2
		local icesplat = P_SpawnMobjFromMobj(mo, xpos, ypos, 0, MT_THOK)
		icesplat.scale = scale
		icesplat.sprite = SPR_GGZ3
		icesplat.flags2 = $|MF2_SPLAT
		icesplat.renderflags = RF_NOSPLATBILLBOARD
		icesplat.frame = ggz.frozenjumps|FF_PAPERSPRITE|FF_FULLBRIGHT
		icesplat.angle = ggz.frozenangle
		icesplat.tics = 1

		-- fix zpos for scale (bottom, top)
		local zpos = {mo.z, mo.z + FixedMul(scale, FRACUNIT*66)}
		if (mo.eflags & MFE_VERTICALFLIP)
			zpos = {mo.z + mo.height, mo.z + mo.height + (FixedMul(scale, FRACUNIT*66)*P_MobjFlip(mo))}
		end
		P_MoveOrigin(icesplat, icesplat.x, icesplat.y, zpos[i])
	end

	-- spawn the sides of the cube
	local radius = 66
	for i = 1, 4
		local angle = ggz.frozenangle + (ANGLE_90*i)
		local xoff = FixedMul(scale, (radius/2)*cos(angle))
		local yoff = FixedMul(scale, (radius/2)*sin(angle))

		local iceside = P_SpawnMobjFromMobj(mo, xoff, yoff, 0, MT_THOK)
		iceside.scale = scale
		iceside.sprite = SPR_GGZ3
		iceside.frame = ggz.frozenjumps|FF_PAPERSPRITE|FF_FULLBRIGHT
		iceside.angle = angle + ANGLE_90
		iceside.tics = 1

		-- fix zpos if flipped, due to the icecube scale
		if (mo.eflags & MFE_VERTICALFLIP)
			local newz = mo.z + mo.height
			newz = $ + (FixedMul(scale, FRACUNIT*66)*P_MobjFlip(mo))
			P_MoveOrigin(iceside, iceside.x, iceside.y, newz)
		end
	end

	-- spawn a faker
	local zoff = FixedMul(mo.scale, 8*FRACUNIT)
	local faker = P_SpawnMobjFromMobj(mo, 0, 0, zoff, MT_THOK)
	faker.skin = mo.skin
	faker.color = mo.color
	faker.state = (ggz.frozenwiggle) and S_PLAY_GGZ_FROZEN_WIGGLE or S_PLAY_GGZ_FROZEN
	faker.fuse = 1
	-- wiggle it about if needed
	if (ggz.frozenwiggle)
		local x = faker.x + FixedMul(faker.scale, P_RandomRange(-1, 1)*FRACUNIT)
		local y = faker.y + FixedMul(faker.scale, P_RandomRange(-1, 1)*FRACUNIT)
		local z = faker.z + FixedMul(faker.scale, P_RandomRange(-1, 1)*FRACUNIT)
		P_MoveOrigin(faker, x, y, z)
		ggz.frozenwiggle = $-1
	end
	-- give it a ghost effect for a cyan tint
	local g = P_SpawnGhostMobj(faker)
	g.frame = ($ & ~FF_TRANSMASK) | FF_TRANS50
	g.color, g.colorized = SKINCOLOR_CYAN, true
	g.tics = 1
	if (g.tracer and g.tracer.valid)	-- followmobj?
		local g2 = g.tracer

		g2.frame = ($ & ~FF_TRANSMASK) | FF_TRANS50
		g2.color, g.colorized = SKINCOLOR_CYAN, true
		g2.tics = 1
	end
	mo.flags2 = $|(MF2_DONTDRAW)	-- hide ourself

	if (p.powers[pw_carry] == CR_MINECART)
		if (mo.tracer and mo.tracer.valid)
			p.pflags = $|(PF_JUMPDOWN)	-- this should prevent us from jumping?
			mo.tracer.flags2 = $ & ~(MF2_AMBUSH)	-- this should prevent us from swapping, too
		end
	else
		local moms = ggz.frozenprevmoms

		-- break out on a hard floor collision
		local threshold = FixedMul(mo.scale, glacierglaze.FrozenDamageZMomentumThreshold)
		if (P_IsObjectOnGround(mo))
		and ((moms[3]*P_MobjFlip(mo)) <= threshold)
			-- spawn particles
			local oldmom = {mo.momx, mo.momy}	-- we'll restore this
			P_DoPlayerPain(p)
			glacierglaze.SpawnIceParticles(mo, P_RandomRange(11, 15), scale)
			glacierglaze.SpawnIceParticles(mo, P_RandomRange(5, 8), scale, true)
			S_StartSound(mo, sfx_glgz2)
			mo.momx, mo.momy = oldmom[1], oldmom[2]
			-- set angle properly if we have no momentum
			if not (FixedHypot(mo.momx, mo.momy))
				p.drawangle = ggz.frozenangle
			end

			P_MoveOrigin(mo, mo.x, mo.y, mo.z + (FixedMul(mo.scale, FRACUNIT*8)*P_MobjFlip(mo)))
			glacierglaze.ResetFreeze(p)	-- reset stuff
			return
		end
		ggz.frozenprevmoms = {mo.momx, mo.momy, mo.momz}
	end

	-- break out by jumping!
	if (ggz.jump == 1)
	and not (ggz.frozenwiggle)
		ggz.frozenwiggle = glacierglaze.FrozenShakeTics
		ggz.frozenjumps = $+1
		local jumps = ggz.frozenjumps

		local neededjumps = 5
		if (jumps >= neededjumps)
			-- spawn particles
			glacierglaze.SpawnIceParticles(mo, P_RandomRange(11, 15), scale)
			glacierglaze.SpawnIceParticles(mo, P_RandomRange(5, 8), scale, true)
			S_StartSound(mo, sfx_glgz2)

			-- reset stuff
			glacierglaze.ResetFreeze(p)

			-- jump out (unless in a minecart!)
			if not (p.powers[pw_carry] == CR_MINECART)
				local addmomz = max(0, mo.momz*P_MobjFlip(mo))

				P_MoveOrigin(mo, mo.x, mo.y, mo.z + (FixedMul(mo.scale, FRACUNIT*8)*P_MobjFlip(mo)))
				P_DoJump(p)
				p.pflags = $ & ~(PF_THOKKED|PF_STARTJUMP)	-- let us use our ability still
				mo.momz = $ + addmomz
			end
		else
			glacierglaze.SpawnIceParticles(mo, P_RandomRange(4, 7), scale)
			S_StartSound(mo, sfx_s3k94)
		end
	end
end

-- quick fix for the freeze gimmick
addHook("PreThinkFrame", do
	for p in players.iterate
		local mo = p.mo
		if not ((mo and mo.valid) and mo.health) then continue end

		if not (glacierglaze.IsPlayerFrozen(p)) then continue end
		p.cmd.forwardmove = 50	-- force forwardmove to prevent skidding
	end
end)

-- break out on a strong enough wall collision
glacierglaze.FrozenWallCollide = function(p, line, side)
	local mo = p.mo
	if not ((mo and mo.valid) and mo.health) then return end
	if not (glacierglaze.IsPlayerFrozen(p)) then return end
	local ggz = mo.ggz

	-- our previous momentum before hitting the wall
	local moms = ggz.frozenprevmoms

	local wallangle = R_PointToAngle2(line.v1.x, line.v1.y, line.v2.x, line.v2.y) - ANGLE_90
	local momangle = R_PointToAngle2(0, 0, moms[1], moms[2])
	local hitangle = wallangle - momangle
	local speedfactor = abs(cos(hitangle))

	local speed = FixedHypot(moms[1], moms[2])
	local hitspeed = FixedMul(speedfactor, speed)
	//print("wallang: "..(wallang/ANG1))
	//print("momang: "..(momang/ANG1))
	//print("hitangle: "..(hitangle/ANG1))
	//print("speedfac: "..speedfac)
	//print("speed: "..speed)
	//print("hitspeed: "..hitspeed)

	local threshold = FixedMul(mo.scale, glacierglaze.FrozenDamageMomentumThreshold)
	if (hitspeed >= threshold)
		-- teleport them
		P_DoPlayerPain(p)
		P_MoveOrigin(mo, mo.x, mo.y, mo.z + (FixedMul(mo.scale, FRACUNIT*8)*P_MobjFlip(mo)))
		-- fix angle and momentum
		local reflectangle = wallangle + hitangle
		p.drawangle = reflectangle
		P_InstaThrust(mo, reflectangle, -(FixedHypot(mo.momx, mo.momy)))

		-- spawn particles
		local scale = FixedMul(p.shieldscale, FixedMul(mo.scale, glacierglaze.FrozenScale))
		glacierglaze.SpawnIceParticles(mo, P_RandomRange(11, 15), scale)
		glacierglaze.SpawnIceParticles(mo, P_RandomRange(5, 8), scale, true)
		S_StartSound(mo, sfx_glgz2)

		-- reset stuff
		glacierglaze.ResetFreeze(p)
	end
end

-- save switch values for unfreezing on minecarts
addHook("TouchSpecial", function(switch, mo)
	local p = mo.player
	if not ((mo and mo.valid) and mo.health) then return end
	if not (p.powers[pw_carry] == CR_MINECART) then return end

	local destambush = (switch.flags2 & MF2_AMBUSH)
	local angdiff = glacierglaze.AngToInt(mo.tracer.angle - switch.angle)
	if (angdiff > 90 and angdiff < 270)
		destambush = ($ ^^ MF2_AMBUSH)
	end
	mo.ggz.frozenminecart = (mo.tracer.flags2 & ~MF2_AMBUSH) or destambush
end, MT_MINECARTSWITCHPOINT)

-- damage enemies if we ram them with speed
addHook("ShouldDamage", function(mo, inflictor, source)
	if not ((mo and mo.valid) and mo.health) then return end
	local p = mo.player
	if not (glacierglaze.IsPlayerFrozen(p)) then return end
	if (p.powers[pw_carry] == CR_MINECART) then return end

	local dmo = inflictor or source
	if not (dmo and dmo.valid)
	or not ((dmo.flags & (MF_ENEMY|MF_BOSS)) and not (dmo.flags & MF_MISSILE))
		return
	end

	local threshold = FixedMul(mo.scale, glacierglaze.FrozenDamageMomentumThreshold)
	if (FixedHypot(mo.momx, mo.momy) >= threshold)
		P_DamageMobj(dmo, mo, mo)
		if (mobjinfo[dmo.type].spawnhealth > 1)	-- bounce back here
			mo.momx, mo.momy = -mo.momx, -mo.momy
		end

		return false
	end
end, MT_PLAYER)
-- do the same, but vertically
addHook("PlayerCanDamage", function(p)
	local mo = p.mo
	if not ((mo and mo.valid) and mo.health) then return end
	if not (glacierglaze.IsPlayerFrozen(p)) then return end
	if (p.powers[pw_carry] == CR_MINECART) then return end

	local threshold = FixedMul(mo.scale, glacierglaze.FrozenDamageZMomentumThreshold)
	if (P_IsObjectOnGround(mo))
	and ((mo.momz*P_MobjFlip(mo)) <= threshold)
		return true
	end
end)

-- break out if we get damaged
glacierglaze.FrozenDamage = function(mo, inflictor, source)
	if not (mo and mo.valid) then return end
	local p = mo.player
	if not (glacierglaze.IsPlayerFrozen(p)) then return end

	-- spawn particles
	local scale = FixedMul(p.shieldscale, FixedMul(mo.scale, glacierglaze.FrozenScale))
	glacierglaze.SpawnIceParticles(mo, P_RandomRange(11, 15), scale)
	glacierglaze.SpawnIceParticles(mo, P_RandomRange(5, 8), scale, true)

	//P_MoveOrigin(mo, mo.x, mo.y, mo.z + (FixedMul(mo.scale, FRACUNIT*8)*P_MobjFlip(mo)))
	-- ^ somehow this revives the player and causes an overflow of death...?
	glacierglaze.ResetFreeze(p)	-- reset stuff

	S_StartSound(mo, sfx_glgz2)
end

-- hide shields when you're frozen
local function ggz_hideOverlay(overlay)
	local owner = overlay.target
	if not (owner and owner.valid) then return end
	if not (owner.player) then return end	-- this is needed for MT_OVERLAY apparently

	if (glacierglaze.IsPlayerFrozen(owner.player))
		overlay.flags2 = $|(MF2_DONTDRAW)
		if (overlay.tracer and overlay.tracer.valid)
			-- the overlay has a 2nd layer (like the s3k shields!)
			overlay.tracer.flags2 = $|(MF2_DONTDRAW)
		end

		return true
	end

	-- if we're here, we have no need for it to not be drawn
	overlay.flags2 = $ & ~(MF2_DONTDRAW)
	if (overlay.tracer and overlay.tracer.valid)
		overlay.tracer.flags2 = $ & ~(MF2_DONTDRAW)
	end

	return false
end
local overlays = {
MT_ELEMENTAL_ORB, MT_FORCE_ORB, MT_ATTRACT_ORB, MT_ARMAGEDDON_ORB, MT_WHIRLWIND_ORB, MT_PITY_ORB,
MT_FLAMEAURA_ORB, MT_BUBBLEWRAP_ORB, MT_THUNDERCOIN_ORB,
//MT_OVERLAY	-- needs its own thinker for this
}
for i = 1, #overlays
	addHook("MobjThinker", ggz_hideOverlay, overlays[i])
end
addHook("MobjThinker", function(overlay)
	if (overlay.target and overlay.target.valid)
	and (overlay.target.flags2 & MF2_SHIELD)	-- this is a 2nd layer for a shield
		-- we'll handle this inside that thinker instead
		return
	end

	-- now just run this like normal
	ggz_hideOverlay(overlay)
end, MT_OVERLAY)

-- collide function to break monitors and spikes
glacierglaze.FrozenCollide = function(mo, mo2)
	if not ((mo and mo.valid) and mo.health) then return end
	local p = mo.player
	if not (p and p.valid) then return end
	if not (glacierglaze.IsPlayerFrozen(p)) then return end

	-- first off, ignore bubbles entirely
	if (mo2.type == MT_EXTRALARGEBUBBLE) then return false end

	-- check for spikes or monitors
	if not (mo2.type == MT_SPIKE or mo2.type == MT_WALLSPIKE)
	and not ((mo2.flags & MF_MONITOR) and mo2.health)
		return
	end

	-- z height checks
	if not ((mo.z + mo.height >= mo2.z) and (mo.z <= mo2.z + mo2.height))
		return
	end

	-- speed check
	local threshold = FixedMul(mo.scale, glacierglaze.FrozenDamageMomentumThreshold)
	if not (FixedHypot(mo.momx, mo.momy) >= threshold) then return end

	-- damage the object
	if ((mo2.flags & MF_MONITOR) and mo2.health)
	and (mo2.flags & MF_GRENADEBOUNCE)	-- dont kill golden monitors
		P_DamageMobj(mo2, mo, mo)
	else
		P_KillMobj(mo2, mo, mo)
	end
	return false
end

-- the frost FOR the frostthrower
freeslot("MT_GGZ_FROST", "S_GGZ_FROST", "SPR_GGZ1")
states[S_GGZ_FROST] = {SPR_GGZ1, A|FF_ANIMATE|FF_FULLBRIGHT, 12, nil, 11, 1, S_NULL}
mobjinfo[MT_GGZ_FROST] = {
	spawnstate = S_GGZ_FROST,
	deathstate = S_NULL,
	radius = 28*FRACUNIT,
	height = 20*FRACUNIT,
	flags = MF_NOGRAVITY|MF_SPECIAL,
}
addHook("TouchSpecial", function(frost, mo)
	local p = mo.player
	if not ((mo and mo.valid) and mo.health) then return true end
	if (glacierglaze.IsPlayerFrozen(p)) then return true end
	if (mo.ggz.frozenprotection) then return true end

	glacierglaze.FreezePlayer(p)
	return true
end, MT_GGZ_FROST)

-- the frostthrower
freeslot("MT_GGZ_FROSTTHROWER", "S_GGZ_FROSTTHROWER", "SPR_GGZ2")
states[S_GGZ_FROSTTHROWER] = {SPR_GGZ2, A, -1, nil, 0, 0, S_GGZ_FROSTTHROWER}
mobjinfo[MT_GGZ_FROSTTHROWER] = {
	--$Name Glacier Glaze Frostthrower
	--$Sprite GGZ2A0
	--$Category SUGOI Items & Hazards
	doomednum = 771,
	spawnstate = S_GGZ_FROSTTHROWER,
	radius = 32*FRACUNIT,
	height = 48*FRACUNIT,
	speed = glacierglaze.FrostthrowerMomentum,
	flags = MF_SOLID,
}
addHook("MobjThinker", function(mo)
	local frostthrower_active = true	-- unless spawnpoint angle is set, always be active
	if (mo.spawnpoint.angle != 0)	-- spawnpoint angle determines how long
		local angle = max(TICRATE, mo.spawnpoint.angle)	-- should be active for at least a second
		local totaltics = angle * 2
		local timeroffset = (mo.flags2 & MF2_AMBUSH) and angle or 0
		local timer = ((leveltime + timeroffset)%totaltics)

		frostthrower_active = (timer >= mo.spawnpoint.angle)	-- should only be active on this condition
		if not (frostthrower_active)
		and (timer >= (mo.spawnpoint.angle - TICRATE))
			mo.flags2 = $|MF2_DONTDRAW

			-- spawn a fake one to shake around!
			local shaketimer = timer - (mo.spawnpoint.angle - TICRATE) + 1
			local range = glacierglaze.FrostthrowerShakeMaxRange
			local dist = max(1, (shaketimer*range)/TICRATE)
			local xoff = P_RandomRange(-(dist), dist)*FRACUNIT
			local yoff = P_RandomRange(-(dist), dist)*FRACUNIT

			local fakethrower = P_SpawnMobjFromMobj(mo, xoff, yoff, 0, MT_THOK)
			fakethrower.sprite, fakethrower.frame = SPR_GGZ2, A
			fakethrower.tics = 2	-- thought I should be using 1 but eh
		else
			mo.flags2 = $ & ~(MF2_DONTDRAW)
		end
	end
	if not (frostthrower_active) then return end	-- not active

	-- spawn the frost that'll freeze players!
	if not (leveltime%3)
		local frost = P_SpawnMobjFromMobj(mo, 0, 0, mo.height, MT_GGZ_FROST)
		frost.momx = FixedMul(mo.scale, P_RandomRange(-3, 3)*FRACUNIT)
		frost.momy = FixedMul(mo.scale, P_RandomRange(-3, 3)*FRACUNIT)
		frost.flags2 = not ($ & MF2_OBJECTFLIP) and $|(MF2_OBJECTFLIP) or $ & ~(MF2_OBJECTFLIP)	-- make sure this spawns opposite to the frostthrower
		frost.eflags = not ($ & MFE_VERTICALFLIP) and $|(MFE_VERTICALFLIP) or $ & ~(MFE_VERTICALFLIP)	-- ditto
		P_SetObjectMomZ(frost, mobjinfo[mo.type].speed)
	end

	-- play sound
	if not (S_SoundPlaying(mo, sfx_s3k7f))
		S_StartSound(mo, sfx_s3k7f)
	end
end, MT_GGZ_FROSTTHROWER)