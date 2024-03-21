local function socket_initintermission(player)
	player.socket_intermission = {
		tic = 0,
		slide = 200,
		tallydone = false
	}

	player.socket_totalscore = 0
	player.socket_scorebonus = 0
	player.socket_ringbonus = 0
	player.socket_exitwait = timedominator_td_intermissionmusiclength
end

addHook("ThinkFrame", do
	for player in players.iterate do
		if player.socket_intermission == nil then
			socket_initintermission(player)
		end
	end
end)

local td_intermissionmusiclength = 5*TICRATE
local td_energyscoremul = 100 -- Sal: boosted for fun :)

-- Can be called outside of this script
rawset(_G, "socket_startintermission", function(player)
	if not (player.mo and player.mo.valid)
		return
	end

	tdglobalstate.intermission = true
	tdglobalstate.exiting = false
	player.exiting = $+1

	player.socket_intermission.tic = 0
	player.socket_intermission.slide = 450
	player.socket_exitwait = td_intermissionmusiclength

	player.socket_totalscore = 0
	player.socket_scorebonus = player.mo.socket_energy * td_energyscoremul
	player.socket_ringbonus = player.rings * 100

	S_ChangeMusic("TDLCLR", false)

	sugoi.AwardEmerald(false) // Sal: Award the emerald and un-fail the stage
	sugoi.GiveCredit(player)
end)

rawset(_G, "socket_finishintermission", function(player)
	//player.score = player.socket_totalscore
	P_AddPlayerScore(player, player.socket_totalscore)
	player.socket_intermission.tallydone = false
	player.socket_scorebonus = 0
	player.socket_ringbonus = 0
	player.socket_exitwait = td_intermissionmusiclength
end)

local function addscorefrombonus(player, amount)
	P_AddPlayerScore(player, amount)
	player.socket_totalscore = $ + amount
	player.socket_scorebonus = $ - amount
end

local function addscorefromrings(player, amount)
	P_AddPlayerScore(player, amount)
	player.socket_totalscore = $ + amount
	player.socket_ringbonus = $ - amount
end

local function doscorecalc(player)
	local sb = min(player.socket_scorebonus, 100) -- Sal: Cuz I boosted it...
	local rb = min(player.socket_ringbonus, 100)

	while (sb > 0) do
		addscorefrombonus(player, 1)
		sb = $ - 1
	end
	while (rb > 0) do
		addscorefromrings(player, 1)
		rb = $ - 1
	end
end

local function socket_runintermission(player)
	if (tdglobalstate.exiting) then return end

	local intr = player.socket_intermission
	if (not intr) then return end

	if (not tdglobalstate.intermission) then
		intr.tallydone = false
		if (player.exiting == 10) then
			for player in players.iterate do
				socket_startintermission(player)
			end
		end
		return
	end

	intr.tic = $ + 1

	if (intr.slide > 0) then
		intr.slide = max(0, $ - 15)
	end

	player.exiting = $ + 1
	player.socket_exitwait = $ - 1

	if (player.socket_exitwait < td_intermissionmusiclength / 2)
	and (not intr.tallydone) then
		local sb = player.socket_scorebonus
		local rb = player.socket_ringbonus

		if (sb > 0) or (rb > 0)
		or (player.mo.socket_energy > 0) then
			if (sb > 0) or (rb > 0) then
				doscorecalc(player)
				sb = player.socket_scorebonus
				rb = player.socket_ringbonus
			end

			if (player.mo.socket_energy > 0) then
				player.mo.socket_energy = $ - 1
			end

			player.socket_exitwait = $ + 1

			S_StartSound(nil, sfx_ptally, player)
		end

		if (player.cmd.buttons & BT_USE) then
			while (sb > 0) do
				addscorefrombonus(player, 1)
				sb = $ - 1
			end
			while (rb > 0) do
				addscorefromrings(player, 1)
				rb = $ - 1
			end

			player.mo.socket_energy = 0
			intr.tallydone = true

			S_StartSound(nil, sfx_chchng, player)

			return
		end

		if (player.socket_scorebonus < 1)
		and (player.socket_ringbonus < 1) then
			S_StartSound(nil, sfx_chchng, player)
			intr.tallydone = true
		end
	end

	if (player.socket_exitwait < 1)
	and (player.socket_scorebonus < 1)
	and (player.socket_ringbonus < 1) then
		tdglobalstate.intermission = false
		tdglobalstate.exiting = true
		socket_finishintermission(player)
		sugoi.ExitLevel(nil, 1)
	end
end

addHook("ThinkFrame", do
	if (not timedominator)
	or (not (gametyperules & GTR_CAMPAIGN)) then
		return
	end

	for player in players.iterate do
		if (player.bot) then
			continue
		end
		socket_runintermission(player)
	end
end)
