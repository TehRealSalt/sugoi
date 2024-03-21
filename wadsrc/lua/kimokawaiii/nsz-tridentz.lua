-- Tridentz
-- Rewritten from the ground up by Sal, due to a mysterious crash

freeslot(
	"MT_TRIDENTZ",
	"MT_TRIDENTZ_SPIKES",

	"S_TRIDENTZ_MOVE1",
	"S_TRIDENTZ_MOVE2",
	"S_TRIDENTZ_MOVE3",
	"S_TRIDENTZ_MOVE4",
	"S_TRIDENTZ_MOVESPIKES1",
	"S_TRIDENTZ_MOVESPIKES2",
	"S_TRIDENTZ_MOVESPIKES3",
	"S_TRIDENTZ_MOVESPIKES4",

	"S_TRIDENTZ_SPIKES1",
	"S_TRIDENTZ_SPIKES2",
	"S_TRIDENTZ_SPIKES3",
	"S_TRIDENTZ_SPIKESRETRACT",

	"SPR_CLIO",
	"sfx_hrpoon"
)

mobjinfo[MT_TRIDENTZ] = {
	--$Name Tridentz
	--$Sprite CLIOA0
	--$Category SUGOI Enemies
	doomednum = 3144,
	spawnhealth = 1,
	spawnstate = S_TRIDENTZ_MOVE1,
	deathstate = S_XPLD1,
	deathsound = sfx_pop,
	reactiontime = 80,
	radius = 24*FRACUNIT,
	height = 24*FRACUNIT,
	speed = 2*FRACUNIT,
	flags = MF_SPECIAL|MF_SHOOTABLE|MF_ENEMY|MF_NOGRAVITY
}

states[S_TRIDENTZ_MOVE1] = {SPR_CLIO, A, 6, nil, 0, 0, S_TRIDENTZ_MOVE2}
states[S_TRIDENTZ_MOVE2] = {SPR_CLIO, H, 2, nil, 0, 0, S_TRIDENTZ_MOVE3}
states[S_TRIDENTZ_MOVE3] = {SPR_CLIO, B, 6, nil, 0, 0, S_TRIDENTZ_MOVE4}
states[S_TRIDENTZ_MOVE4] = {SPR_CLIO, H, 2, nil, 0, 0, S_TRIDENTZ_MOVE1}

states[S_TRIDENTZ_MOVESPIKES1] = {SPR_CLIO, C, 6, nil, 0, 0, S_TRIDENTZ_MOVESPIKES2}
states[S_TRIDENTZ_MOVESPIKES2] = {SPR_CLIO, I, 2, nil, 0, 0, S_TRIDENTZ_MOVESPIKES3}
states[S_TRIDENTZ_MOVESPIKES3] = {SPR_CLIO, D, 6, nil, 0, 0, S_TRIDENTZ_MOVESPIKES4}
states[S_TRIDENTZ_MOVESPIKES4] = {SPR_CLIO, I, 2, nil, 0, 0, S_TRIDENTZ_MOVESPIKES1}

mobjinfo[MT_TRIDENTZ_SPIKES] = {
	spawnhealth = 1000,
	spawnstate = S_TRIDENTZ_SPIKES1,
	radius = 24*FRACUNIT,
	height = 32*FRACUNIT,
	mass = DMG_SPIKE,
	flags = MF_PAIN|MF_NOGRAVITY|MF_NOCLIPHEIGHT
}

states[S_TRIDENTZ_SPIKES1] = {SPR_CLIO, E, 6, nil, 0, 0, S_TRIDENTZ_SPIKES2}
states[S_TRIDENTZ_SPIKES2] = {SPR_CLIO, F, 3, nil, 0, 0, S_TRIDENTZ_SPIKES3}
states[S_TRIDENTZ_SPIKES3] = {SPR_CLIO, G, -1, nil, 0, 0, S_NULL}
states[S_TRIDENTZ_SPIKESRETRACT] = {SPR_CLIO, E, 3, nil, 0, 0, S_NULL}

local function tridentzRetract(mo)
	P_SetObjectMomZ(mo, mo.info.speed, false)
	S_StartSound(mo, sfx_s3k64)
	mo.state = S_TRIDENTZ_MOVE1
	if (mo.tracer and mo.tracer.valid)
		mo.tracer.state = S_TRIDENTZ_SPIKESRETRACT
	end
end

addHook("MobjSpawn", function(mo)
	-- Set Tridentz Z
	mo.tridentz = mo.z
end, MT_TRIDENTZ)

addHook("MobjThinker", function(mo)
	if not (mo.health)
		if (mo.tracer and mo.tracer.valid)
			-- You're dead, so this needs to be gotten rid of.
			P_RemoveMobj(mo.tracer)
		end

		-- Dead, don't do anything.
		return
	end

	if (mo.tridentz == nil)
		-- Ensure this has been set
		mo.tridentz = mo.z
	end

	local range = 350*FRACUNIT
	local spikez = mo.z + 70*FRACUNIT
	local destz = mo.tridentz

	if (mo.state == S_TRIDENTZ_MOVE1
	or mo.state == S_TRIDENTZ_MOVE2
	or mo.state == S_TRIDENTZ_MOVE3
	or mo.state == S_TRIDENTZ_MOVE4)
		if (mo.movecount == 0)
			-- Move up to destination
			destz = mo.tridentz + (40*FRACUNIT)

			if (mo.z >= destz)
				mo.movecount = 1
			else
				P_SetObjectMomZ(mo, mo.info.speed, false)
			end
		elseif (mo.movecount == 1)
			-- Move down to destination
			destz = mo.tridentz - (40*FRACUNIT)

			if (mo.z <= destz)
				mo.movecount = 0
			else
				P_SetObjectMomZ(mo, -mo.info.speed, false)
			end
		end

		if (mo.target and mo.target.valid)
			-- Tridentz has a target
			local targetdist = R_PointToDist2(mo.x, mo.y, mo.target.x, mo.target.y)

			if (targetdist > range)
				-- They moved out of range, so do not target anymore
				mo.target = nil
			else
				-- If they're above us, then get ready to harpoon!
				if (mo.z < mo.target.z)
					if (mo.tracer and mo.tracer.valid)
						mo.tracer.state = S_TRIDENTZ_SPIKES1
					else
						mo.tracer = P_SpawnMobj(mo.x, mo.y, spikez, MT_TRIDENTZ_SPIKES)
						mo.tracer.target = mo
					end

					S_StartSound(mo, sfx_hrpoon)
					mo.state = S_TRIDENTZ_MOVESPIKES1
				end
			end
		else
			-- Find the closest available player within range
			local bestdistance = range+1
			for player in players.iterate
				if not (player.mo and player.mo.valid)
					continue
				end

				local playerdist = R_PointToDist2(mo.x, mo.y, player.mo.x, player.mo.y)
				if (playerdist < bestdistance)
					mo.target = player.mo
					bestdistance = playerdist
				end
			end
		end
	elseif (mo.state == S_TRIDENTZ_MOVESPIKES1
	or mo.state == S_TRIDENTZ_MOVESPIKES2
	or mo.state == S_TRIDENTZ_MOVESPIKES3
	or mo.state == S_TRIDENTZ_MOVESPIKES4)
		if not (mo.tracer and mo.tracer.valid)
			-- Double check that this is here, just to be safe!
			mo.tracer = P_SpawnMobj(mo.x, mo.y, spikez, MT_TRIDENTZ_SPIKES)
			mo.tracer.target = mo
		end

		if not (mo.target and mo.target.valid)
			-- Target is gone, retract
			tridentzRetract(mo)
		else
			local targetdist = R_PointToDist2(mo.x, mo.y, mo.target.x, mo.target.y)

			if (targetdist > range)
				-- Too far away, retract
				tridentzRetract(mo)
			else
				if (mo.z > mo.target.z) and (mo.z < mo.tridentz)
					-- Our target is below us, retract
					tridentzRetract(mo)
				else
					-- Inch closer to our target!
					targetdist = P_AproxDistance(P_AproxDistance(mo.target.x - mo.x, mo.target.y - mo.y), mo.target.z - mo.z)
					destz = mo.target.z - (8*FRACUNIT)
					P_SetObjectMomZ(mo, FixedDiv(destz - mo.z, max(1, targetdist)) << 3, false)
				end
			end
		end
	end

	-- Spike overlay
	if (mo.tracer and mo.tracer.valid)
		-- Move to the correct spot
		mo.tracer.z = spikez
	end
end, MT_TRIDENTZ)
