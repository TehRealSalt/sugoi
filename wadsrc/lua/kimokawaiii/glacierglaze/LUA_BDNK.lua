-- glacier glaze badniks

-- Frost Skim
freeslot("MT_GGZ_FROSTSKIM", "S_GGZ_FROSTSKIM", "S_GGZ_FROSTSKIM_FREEZE", "S_GGZ_FROSTSKIM_LAUNCH", "SPR_GGZ7")
states[S_GGZ_FROSTSKIM] = {SPR_GGZ7, A, 1, nil, 0, 0, S_GGZ_FROSTSKIM}
states[S_GGZ_FROSTSKIM_FREEZE] = {SPR_GGZ7, A, 5*TICRATE, nil, 0, 0, S_GGZ_FROSTSKIM}
states[S_GGZ_FROSTSKIM_LAUNCH] = {SPR_GGZ7, A, 3*TICRATE, nil, 0, 0, S_GGZ_FROSTSKIM}
mobjinfo[MT_GGZ_FROSTSKIM] = {
	--$Name Frost Skim
	--$Sprite GGZ7A1
	--$Category SUGOI Enemies
	doomednum = 773,
	spawnstate = S_GGZ_FROSTSKIM,
	meleestate = S_GGZ_FROSTSKIM_FREEZE,
	//missilestate = S_GGZ_FROSTSKIM_LAUNCH,	-- this made it a bit too random for my liking, handling this in the thinker instead
	deathstate = S_XPLD_FLICKY,
	deathsound = sfx_pop,
	speed = (mobjinfo[MT_SKIM].speed/3*2),	-- slower than a normal skim
	radius = 16*FRACUNIT,
	height = 24*FRACUNIT,
	flags = MF_ENEMY|MF_SPECIAL|MF_NOGRAVITY|MF_SHOOTABLE,
}
-- thought I could do this without a MobjThinker, but Skims have hardcoded water functionality that I have to replicate
addHook("MobjThinker", function(mo)
	if (mo.state == S_GGZ_FROSTSKIM)
		if (mo.watertop == mo.waterbottom) then mo.flags = $ & ~(MF_NOGRAVITY) return end	-- no possible water, cease functions
		mo.flags = $|MF_NOGRAVITY	-- make sure it has this

		-- get z positions to check
		local checkz, checksurface = mo.z, mo.watertop
		if (mo.eflags & MFE_VERTICALFLIP)
			checkz, checksurface = mo.z + mo.height, mo.waterbottom
		end

		-- smoothly rise to the surface
		if (not (mo.eflags & MFE_VERTICALFLIP) and checkz < checksurface)
		or ((mo.eflags & MFE_VERTICALFLIP) and checkz > checksurface)
			mo.ggz_rising = true
			P_SetObjectMomZ(mo, 5120, true)
		end
		-- snap to the surface when close enough
		if (abs(checkz - checksurface) <= (mo.momz*P_MobjFlip(mo)))
			-- snap to surface
			local snapz = checksurface
			if (mo.eflags & MFE_VERTICALFLIP) then snapz = checksurface + mo.height end
			P_MoveOrigin(mo, mo.x, mo.y, snapz)
			mo.momz = 0
			-- play a sound when we JUST hit the surface
			if (mo.ggz_rising)
				S_StartSound(mo, sfx_splash)
				mo.ggz_rising = nil
			end

			if (mo.target and mo.target.valid)	-- only if we have a target to fire at
				-- init patience var
				if (mo.ggz_patience == nil)
					local randint = P_RandomRange(-(glacierglaze.FrostSkimPatienceRandint), glacierglaze.FrostSkimPatienceRandint)
					local patience = glacierglaze.FrostSkimPatience + randint
					mo.ggz_patience = patience
				end

				-- lower patience if we're above freezing range
				local checkz = mo.z - FixedMul(mo.scale, glacierglaze.FrostSkimThreshold)
				if (mo.eflags & MFE_VERTICALFLIP)
					checkz = (mo.z + mo.height) + FixedMul(mo.scale, glacierglaze.FrostSkimThreshold)
				end
				checkz = $ + (FixedMul(mo.scale, -16*FRACUNIT)*P_MobjFlip(mo))

				if (not (mo.eflags & MFE_VERTICALFLIP) and mo.target.z >= checkz)
				or ((mo.eflags & MFE_VERTICALFLIP) and mo.target.z <= checkz)
					mo.ggz_patience = $-1
				end

				-- patience depleted? shoot at the target
				if not (mo.ggz_patience)
					mo.state = S_GGZ_FROSTSKIM_LAUNCH
					return
				end
			end
		end

		-- chase player
		A_SkimChase(mo)
	else
		mo.ggz_patience = nil	-- reset patience here
		if (mo.state == S_GGZ_FROSTSKIM_FREEZE)
			if (mo.tics > glacierglaze.FrostSkimFreezeRecoil)	-- less than this would be recovery time
				-- spawn frost to freeze the player from above
				if not (leveltime%3)
					local frost = P_SpawnMobjFromMobj(mo, 0, 0, -16*FRACUNIT, MT_GGZ_FROST)
					frost.momx = FixedMul(mo.scale, P_RandomRange(-3, 3)*FRACUNIT)
					frost.momy = FixedMul(mo.scale, P_RandomRange(-3, 3)*FRACUNIT)
					P_SetObjectMomZ(frost, glacierglaze.FrostthrowerMomentum)
				end

				-- play sound
				if not (S_SoundPlaying(mo, sfx_s3k7f))
					S_StartSound(mo, sfx_s3k7f)
				end
			end
		elseif (mo.state == S_GGZ_FROSTSKIM_LAUNCH)
			if (mo.target and mo.target.valid)
				local timer = states[S_GGZ_FROSTSKIM_LAUNCH].tics - mo.tics

				mo.angle = R_PointToAngle2(mo.x, mo.y, mo.target.x, mo.target.y)
				if (timer == glacierglaze.FrostSkimFireWait)	-- FIRE
					local multishot_zpos = -48 + (mo.height/FRACUNIT)	-- A_MultiShotDist has 48*FRACUNIT built into it for some reason
					A_MultiShotDist(mo, (MT_SPINDUST<<16)|4, multishot_zpos)
					A_LobShot(mo, MT_POPSHOT, ((mo.height/FRACUNIT)<<16)+56)
				end
			else
				-- try find a new target?
				A_Look(mo, 1, 2)
			end
		end
	end
end, MT_GGZ_FROSTSKIM)

-- iceskater crawla (honestly pretty similar to CBFS)
function A_GGZ_CrawlaSpinThrust(actor, var1, var2)
	-- thrust towards target
	local multiplier = (actor.health == 1) and glacierglaze.IceskaterCrawlaPinchMultiplier or FRACUNIT
	local speed = FixedMul(multiplier, FixedMul(actor.scale, mobjinfo[actor.type].speed))

	actor.angle = R_PointToAngle2(actor.x, actor.y, actor.target.x, actor.target.y)
	P_InstaThrust(actor, actor.angle, speed)
	S_StartSound(actor, sfx_zoom)

	S_StartSound(actor, sfx_zoom)
end
function A_GGZ_CrawlaAction(actor, var1, var2)
	-- correct frame depending on health
	if (actor.health == 1) then actor.frame = $ + 4 end

	-- run functions depending on var1
	if (var1)
		local funcs = {A_Look, A_PlayAttackSound, A_GGZ_CrawlaSpinThrust}
		local func = funcs[var1]

		if (func) then func(actor) end
	end
end

function A_GGZ_CrawlaSliggaTrigga(actor, var1, var2)
	-- dont worry about this for now
end

freeslot("MT_GGZ_CRAWLA", "SPR_GGZ8", "S_GGZ_CRAWLA_LOOK", "S_GGZ_CRAWLA_REV", "S_GGZ_CRAWLA_SPIN",
"S_GGZ_CRAWLA_PAIN", "S_GGZ_CRAWLA_PAIN_TRIGGA", "S_GGZ_CRAWLA_DEATH1", "S_GGZ_CRAWLA_DEATH2", "S_GGZ_CRAWLA_DEATH3")
states[S_GGZ_CRAWLA_LOOK] = {SPR_GGZ8, A, TICRATE, A_GGZ_CrawlaAction, 1, 0, S_GGZ_CRAWLA_LOOK}
states[S_GGZ_CRAWLA_REV] = {SPR_GGZ8, A, glacierglaze.IceskaterCrawlaRevTics, A_GGZ_CrawlaAction, 2, 0, S_GGZ_CRAWLA_SPIN}
states[S_GGZ_CRAWLA_SPIN] = {SPR_GGZ8, A, glacierglaze.IceskaterCrawlaSpinTics, A_GGZ_CrawlaAction, 3, 0, S_GGZ_CRAWLA_REV}
states[S_GGZ_CRAWLA_PAIN] = {SPR_GGZ8, A, TICRATE*3/4, A_Pain, 0, 0, S_GGZ_CRAWLA_PAIN_TRIGGA}	-- painstates HAVE to go back to spawnstates for some reason...
states[S_GGZ_CRAWLA_PAIN_TRIGGA] = {SPR_GGZ8, D, TICRATE/2, A_GGZ_CrawlaSliggaTrigga, 0, 0, S_GGZ_CRAWLA_LOOK}	-- painstates HAVE to go back to spawnstates for some reason...
states[S_GGZ_CRAWLA_DEATH1] = {SPR_GGZ8, D, 2, A_BossScream, 1, 0, S_GGZ_CRAWLA_DEATH2}
states[S_GGZ_CRAWLA_DEATH2] = {SPR_NULL, A, 2, A_BossScream, 1, 0, S_GGZ_CRAWLA_DEATH3}
states[S_GGZ_CRAWLA_DEATH3] = {SPR_NULL, A, 0, A_Repeat, 7, S_GGZ_CRAWLA_DEATH1, S_XPLD_FLICKY}
mobjinfo[MT_GGZ_CRAWLA] = {
	--$Name Iceskater Crawla
	--$Sprite GGZ8A1
	--$Category SUGOI Enemies
	doomednum = 774,
	spawnhealth = 2,
	spawnstate = S_GGZ_CRAWLA_LOOK,
	seestate = S_GGZ_CRAWLA_REV,
	attacksound = sfx_s3kc5s,
	painstate = S_GGZ_CRAWLA_PAIN,
	painsound = sfx_dmpain,
	deathstate = S_GGZ_CRAWLA_DEATH1,
	deathsound = sfx_s3kb4,
	activesound = sfx_s3k5d,
	radius = 24*FRACUNIT,
	height = 32*FRACUNIT,
	speed = 22*FRACUNIT,
	flags = MF_ENEMY|MF_SPECIAL|MF_SHOOTABLE|MF_BOUNCE,
}
addHook("MobjThinker", function(mo)
	if not ((mo and mo.valid) and mo.health) then return end

	-- state info
	local target = mo.target
	if (mo.state == S_GGZ_CRAWLA_LOOK)
		-- check if we already have a target from the pain state
		if ((target and target.valid) and target.health)
			-- yep, force us back to the chase state
			mo.state = S_GGZ_CRAWLA_REV
			return
		end
	elseif (mo.state == S_GGZ_CRAWLA_REV)
		if not ((target and target.valid) and target.health)
			mo.state = S_GGZ_CRAWLA_LOOK
			return
		end

		-- set frame
		local startframe, frames = 0, 3
		if (mo.health == 1)	-- change frames when low health
			startframe = 4
		end

		local timer = (states[S_GGZ_CRAWLA_REV].tics - mo.tics) + 1
		local frameadd = min(frames - 1, (timer*frames) / states[S_GGZ_CRAWLA_REV].tics)
		mo.frame = startframe + frameadd

		-- rotate to the target
		local diff = R_PointToAngle2(mo.x, mo.y, target.x, target.y) - mo.angle
		local factor = 8
		if (diff)
			diff = (glacierglaze.AngToInt(diff) > 180) and InvAngle(InvAngle(diff)/factor) or $/factor
			mo.angle = $ + diff
		end
	elseif (mo.state == S_GGZ_CRAWLA_SPIN)
		-- rotate based on momentum
		local spd = max(0, FixedHypot(mo.momx, mo.momy) - (FixedMul(mo.scale, glacierglaze.IceskaterCrawlaSpeedThreshold) / ((mo.eflags & MFE_UNDERWATER) and 2 or 1)))
		local angleadd = (spd/mo.scale) * (ANG1*(4 / ((mo.eflags & MFE_UNDERWATER) and 2 or 1)))
		mo.angle = $ + angleadd

		-- dont stop this state until we've slowed down enough
		if (angleadd)
			mo.tics = max(glacierglaze.IceskaterCrawlaSpinTics, $)
		else
			if (mo.tics == 1)	-- go to look state instead of rev state if we have no target!
			and not ((target and target.valid) and target.health)
				mo.state = S_GGZ_CRAWLA_LOOK
				return
			end
		end
	end

	-- change frames
	if (mo.health == 1)
	and not (mo.state >= S_GGZ_CRAWLA_PAIN and mo.state <= S_GGZ_CRAWLA_DEATH3)
		-- only if we're in relative frames
		if (mo.frame >= A and mo.frame <= C)
			mo.frame = $ + 4
		end
	end
end, MT_GGZ_CRAWLA)