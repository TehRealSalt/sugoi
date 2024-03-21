-- salt (me) made this and is really hot and totes cute (do not remove this line; only people who hate puppies dont give credit)
-- it's also illegal to remove this sick ascii image of a dog i generated off of some website
--                 @@@@@@@@@
--            @@@@@@@@@   @@@@
--          @@@@             @@
--       @@@@                 @@
--      @@@                    @@
--    @@@                       @@
--   @@                          @@
--  @@                            @@
--  @                              @
-- @@                              @
-- @                               @@
-- @                               @@
-- @@@        @@@                   @
--   @@@@@@@@@@                     @
--     @@@        @@@               @
--     @         @@@@          @@  @@
--    @@         @@@@         @@@@ @@
--    @                       @@@@ @
--   @@                           @@
--   @@                           @
--   @@                    @@@@@@@@@@@@@@@@
--   @@                 @@@@@@    @@@@@@@@@@
--    @@                        @@@@@@@@@@ @
--    @@@                        @@@@@@@@ @@
--     @@                         @@@@    @
--      @@@                       @@     @@
--        @@                     @@      @@
--         @@@              @@@@@@@@@@  @@
--           @@@@@@@     @@@@@      @@  @
--               @@@@@@ @@@        @@  @@
--                    @@@@@@      @@  @@
--                        @@@@   @@  @@
--                          @@@@ @  @@
--                             @@@@@@
--                              @@

local timer = -1
local tpause = false
local panimtimer = 0

local function ssTimerSet()
	if (mapheaderinfo[gamemap].templetimer)
		timer = mapheaderinfo[gamemap].templetimer * TICRATE
	else
		timer = -1
	end

	tpause = false
	panimtimer = 0
end

local function endTimer()
	if not (mapheaderinfo[gamemap].templetimer) return end
	S_StartSound(nil, sfx_lose)

	for player in players.iterate
		P_DoPlayerExit(player)
	end

	timer = -1
end

local function ssTimer()
	if not (mapheaderinfo[gamemap].templetimer) return end
	if (timer <= -1) return end

	if (tpause)
		if (panimtimer > 0)
			panimtimer = $ - 1
		end
	elseif not (tpause)
		if (timer > 0)
			timer = $ - 1
		elseif (timer == 0)
			endTimer()
		end
	end
end

local function playerHit(mo)
	if not (mapheaderinfo[gamemap].templetimer) return end
	if not (mo.player) return end

	local player = mo.player
	if (player.bot) return end

	if (player.powers[pw_shield]) return false end
	if (player.powers[pw_super]) return false end
	if (player.rings > 0) return false end

	endTimer()
	P_DoPlayerPain(player)
	return true
end

local function pauseTimer(line, mo, sec)
	if not (mapheaderinfo[gamemap].templetimer) return end
	tpause = true
	panimtimer = 3*TICRATE
end

local function syncTimer(net)
	timer = net(timer)
	tpause = net(tpause)
	panimtimer = net(panimtimer)
end

addHook("MapLoad", ssTimerSet)
addHook("ThinkFrame", ssTimer)
addHook("MobjDamage", playerHit, MT_PLAYER)
addHook("LinedefExecute", pauseTimer, "TMRPAUSE")
addHook("NetVars", syncTimer)

local function drawTimer(v, p)
	if not mapheaderinfo[gamemap].templetimer return end
	if (panimtimer % 3 == 2) or not (tpause) and not (timer < 0)
		v.drawString(160, 20, G_TicsToMinutes(timer, true)..":"..("%02d"):format(G_TicsToSeconds(timer)), V_MONOSPACE|V_YELLOWMAP|V_SNAPTOTOP|V_HUDTRANSDOUBLE|V_PERPLAYER, "center")
	elseif (timer == -1)
		v.drawString(160, 100, "You blew it!", V_MONOSPACE|V_REDMAP|V_SNAPTOTOP|V_HUDTRANSDOUBLE|V_PERPLAYER, "center")
	end
end
hud.add(drawTimer)
