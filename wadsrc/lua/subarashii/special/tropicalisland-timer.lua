rawset(_G, "timedominator", false)

rawset(_G, "tdglobalstate", {
	startenergy = 0,
	intermission = false,
	exiting = false
})

freeslot("MT_TIMEDOMINATOR_SPAWNPARTICLE")
mobjinfo[MT_TIMEDOMINATOR_SPAWNPARTICLE] = {
	doomednum = -1,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	flags = MF_NOCLIPHEIGHT|MF_NOGRAVITY|MF_NOBLOCKMAP,
}

freeslot("sfx_tdchg1", "sfx_tdchg2")

sfxinfo[sfx_tdchg1] = {
	caption = "Socket charging",
	flags = SF_TOTALLYSINGLE
}

sfxinfo[sfx_tdchg2] = {
	caption = "Socket fully charged",
	flags = SF_TOTALLYSINGLE
}

addHook("NetVars", function(net)
	timedominator = net(timedominator)
	tdglobalstate = net(tdglobalstate)
end)

-- Can be called outside of this script
rawset(_G, "socket_reset", function()
	timedominator = false
	tdglobalstate.startenergy = 65
end)

local function socket_load(nextmap)
	local header = mapheaderinfo[nextmap]

	if tdglobalstate.intermission then
		for player in players.iterate do
			socket_finishintermission(player)
		end
		tdglobalstate.intermission = false
	end

	socket_reset()

	if header.timedominator ~= nil then
		if tonumber(header.timedominator) ~= nil then
			timedominator = (tonumber(header.timedominator) != 0)
		else
			timedominator = (header.timedominator ~= "false")
		end
	end
end

addHook("MapChange", socket_load)

addHook("MapLoad", do
	tdglobalstate.exiting = false
end)

local function socket_initplayer(mo)
	mo.socket_intro = 0
	mo.socket_energy = 0
	mo.socket_charged = false
	mo.socket_recharge = {active = false, amount = 0}
	mo.socket_energytimer = 0
	mo.socket_realtime = 0
end

local function socket_playsoundlocal(sfx, volume, player)
	if (volume == nil) then
		volume = 255
	end

	if (player == nil) then
		S_StartSoundAtVolume(nil, sfx, volume)
		return
	end

	if (not player.bot)
	and (not (splitscreen and player == players[1])) then
		S_StartSoundAtVolume(nil, sfx, volume, player)
	end
end

local function socket_spawnparticle(mo)
	local xzdist = 400
	local ydist = 300
	local x = mo.x + (P_RandomRange(-xzdist, xzdist) * FRACUNIT)
	local y = mo.y - (ydist * FRACUNIT)
	local z = mo.z + (P_RandomRange(-xzdist, xzdist) * FRACUNIT)
	local pt = P_SpawnMobj(x, y, z, MT_TIMEDOMINATOR_SPAWNPARTICLE)
	pt.target = mo
	pt.state = S_THOK
	pt.tics = -1
	pt.color = SKINCOLOR_WHITE
	pt.vx = (mo.x - pt.x) / 10
	pt.vy = (mo.y - pt.y) / 10
	pt.vz = (mo.z - pt.z) / 10
end

local function socket_particlethink(mo)
	if (not (mo.target and mo.target.valid)) then
		P_RemoveMobj(mo)
		return
	end

	local destx = mo.target.x
	local desty = mo.target.y
	local destz = mo.target.z

	local momx = mo.vx
	local momy = mo.vy
	local momz = mo.vz

	local ndist = P_AproxDistance(
		P_AproxDistance(
		destx - (mo.x + momx),
		desty - (mo.y + momy)),
		destz - (mo.z + momz))

	if (ndist < (32*FRACUNIT)) then
		P_RemoveMobj(mo)
	else
		P_MoveOrigin(mo, mo.x + momx, mo.y + momy, mo.z + momz)

		local dist = FixedInt(FixedDiv(ndist, 32*FRACUNIT))
		mo.frame = $ & ~FF_TRANSMASK
		mo.frame = $ | (max(0, min(dist, 9)) << FF_TRANSSHIFT)

		P_SpawnGhostMobj(mo)
	end
end

addHook("MobjThinker", socket_particlethink, MT_TIMEDOMINATOR_SPAWNPARTICLE)

local function socket_spawncharge(mo)
	local starttime = (TICRATE / 2)
	local chargetime = starttime + (2 * TICRATE) + (TICRATE / 2)
	local waittime = chargetime + (TICRATE / 2)

	local player = mo.player

	if (player.playerstate != PST_LIVE) then return end
	if (mo.health < 1) then return end

	player.powers[pw_nocontrol] = 1
	mo.tics = states[S_PLAY_STND].tics
	mo.socket_intro = $+1

	if (mo.socket_intro < starttime) then
		mo.sprite = SPR_NULL
		return
	elseif (mo.socket_intro < chargetime) then
		if (leveltime & 1) then
			socket_spawnparticle(mo)
			socket_playsoundlocal(sfx_shrpsp, 190, player)

			if (mo.socket_intro > (starttime + TICRATE))
				mo.sprite = SPR_PLAY
			end
		else
			mo.sprite = SPR_NULL
		end
	elseif (mo.socket_intro < waittime) then
		if (mo.socket_intro < chargetime + (TICRATE / 3))
			if (leveltime & 1) then
				mo.sprite = SPR_PLAY
			else
				mo.sprite = SPR_NULL
			end
		elseif (mo.sprite == SPR_NULL) then
			mo.sprite = SPR_PLAY
		end
	elseif (mo.socket_energy < tdglobalstate.startenergy) then
		mo.socket_energy = $ + 2
		socket_playsoundlocal(sfx_tdchg1, nil, player)

		if (mo.socket_energy >= tdglobalstate.startenergy) then
			mo.socket_energy = tdglobalstate.startenergy
			mo.socket_charged = true
			mo.socket_ready = true
			mo.socket_energytimer = 0
			mo.socket_realtime = 0

			player.powers[pw_nocontrol] = 0

			socket_playsoundlocal(sfx_tdchg2, nil, player)
		end
	end
end

local function socket_handleenergy(mo)
	if (mo.socket_energy == nil)
	or (not mo.socket_charged) then
		return
	end

	local player = mo.player

	mo.socket_energy = min($, tdglobalstate.startenergy)

	if (not tdglobalstate.intermission) then
		if mo.socket_recharge.active then
			mo.socket_energy = $ + 1
			mo.socket_recharge.amount = $ - 1
			if mo.socket_recharge.amount == 0 then
				mo.socket_recharge.active = false
			end
		elseif (mo.socket_energy > 0)
		and (player.playerstate == PST_LIVE)
		and (mo.state != S_PLAY_STUN)
		and (not player.exiting)
		and (not (player.pflags & PF_FINISHED))
		and (not (player.pflags & PF_GODMODE)) then
			mo.socket_energytimer = $ + 1
			if ((mo.socket_energytimer % TICRATE) == 0)
				mo.socket_energy = $ - 1
			end
		end

		if (not player.exiting)
		and (not (player.pflags & PF_FINISHED)) then
			mo.socket_realtime = $ + 1
		end
	end

	-- Got hit
	if mo.socket_energydeplete then
		mo.socket_energy = $ - 1
		mo.socket_energydeplete = $ - 1
	end

	-- Ran out of energy
	if (mo.socket_energy < 1)
	and (player.playerstate == PST_LIVE)
	and (not tdglobalstate.intermission) then
		mo.socket_energy = 0
		--P_DamageMobj(mo, nil, nil, 1, DMG_INSTAKILL)
		P_DoPlayerExit(player)
	end

	mo.socket_dead = (mo.socket_energy < 1)
end

-- Can be called outside of this script
rawset(_G, "socket_giveenergy", function(mo, energy)
	if (not mo.socket_energy) then return end
	mo.socket_recharge = {active = true, amount = energy}
end)

local function socket_damaged(mo, inflictor, source)
	if not mo.socket_charged then return end

	P_ResetPlayer(mo.player)
	mo.state = S_PLAY_STUN
	mo.socket_energytimer = (TICRATE / 2)
	mo.player.powers[pw_flashing] = 2 * TICRATE

	P_InstaThrust(mo, mo.angle, -10 * FRACUNIT)
	P_SetObjectMomZ(mo, 10 * FRACUNIT, false)
	S_StartSound(mo, sfx_altdi1)

	if (not mo.player.powers[pw_shield]) then
		mo.socket_energydeplete = 5
	end

	P_RemoveShield(mo.player)
end

addHook("PlayerThink", function(player)
	if (not timedominator) then return end
	if (player.spectator) then return end
	if (player.quittime) then return end

	local mo = player.mo

	if (mo.socket_energy == nil) then
		socket_initplayer(mo)
	end

	if (not mo.socket_charged) then
		socket_spawncharge(mo)
	end

	socket_handleenergy(mo)
end)

-- Refresh realtime with Socket's timer
addHook("ThinkFrame", do
	if (not timedominator) then return end
	for player in players.iterate do
		if (player.quittime) then continue end
		if (player.spectator) then continue end
		local mo = player.mo
		if mo and mo.valid
		and (mo.socket_realtime ~= nil) then
			player.realtime = mo.socket_realtime
		end
	end
end)

addHook("MobjDamage", function(mo, inflictor, source, damage)
	if timedominator
	and (mo.player and mo.player.valid)
	and (not mo.player.spectator) then
		socket_damaged(mo, inflictor, source)
		return true
	end
end, MT_PLAYER)

addHook("TouchSpecial", function(mo, toucher)
	if (timedominator and toucher.player)
	and (toucher.player and toucher.player.valid)
	and (not toucher.player.spectator)
	and (toucher.player.playerstate == PST_LIVE)
	and (toucher.socket_energy != nil)
	and (mo.state == S_RING) then
		if (toucher.socket_energy >= tdglobalstate.startenergy) then
			return
		end
		toucher.socket_energy = $ + 1
	end
end, MT_RING)

addHook("TouchSpecial", function(starpost, mo)
	if (not timedominator) then return end

	local player = mo.player

	if (not (player and player.valid)) then return end
	if (player.spectator) then return end

	local startenergy = tdglobalstate.startenergy

	if (player.starpostnum < starpost.health)
	and (mo.socket_energy < startenergy) then
		socket_giveenergy(mo, startenergy - mo.socket_energy)
		mo.socket_energytimer = 0
	end
end, MT_STARPOST)
