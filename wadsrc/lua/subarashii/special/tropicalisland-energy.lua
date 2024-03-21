local ENERGYHUD_WIDTH = 130
local ENERGYHUD_X = 160 - (ENERGYHUD_WIDTH / 2)
local ENERGYHUD_Y = 184

hud.add(function(v, player)
	if not (timedominator) then return end
	if not (player and player.mo) then return end
	if (player.mo.socket_energy == nil) then return end
	if (player.spectator) then return end

	local x = ENERGYHUD_X
	local y = ENERGYHUD_Y
	local flags = V_PERPLAYER | V_SNAPTOBOTTOM

	local en = player.mo.socket_energy
	local maxenergy = tdglobalstate.startenergy
	local energy = min(en, maxenergy) * ENERGYHUD_WIDTH / maxenergy
	local lowenergy = min(min(en, 8), maxenergy) * ENERGYHUD_WIDTH / maxenergy

	local string = "ENERGY"
	v.drawString(
		(x + (ENERGYHUD_WIDTH / 2)) - (v.stringWidth(string, flags) / 2),
		(ENERGYHUD_Y - 10),
		string, V_ORANGEMAP | flags)

	-- base
	v.drawFill(x - 1, y    , ENERGYHUD_WIDTH + 2, 8, 4 | flags)
	v.drawFill(x    , y + 1, ENERGYHUD_WIDTH    , 3, 23 | flags)
	v.drawFill(x    , y + 4, ENERGYHUD_WIDTH    , 3, 31 | flags)

	-- base highlights
	for col = 1, ENERGYHUD_WIDTH, 2 do
		local i = (col - 1)
		local top = y + 1
		v.drawFill(x + i, top    , 1, 3, 11 | flags)
		v.drawFill(x + i, top + 3, 1, 2, 23 | flags)
	end

	for col = 1, ENERGYHUD_WIDTH do
		local i = (col - 1)
		local top = y + 2

		local color = 4
		if (i % 2) then
			v.drawFill(x + i, top, 1, 1, 4 | flags)
		end
	end

	-- orange and red bars
	for col = 1, ENERGYHUD_WIDTH do
		local i = (col - 1)
		local top = y + 1

		if (col % 2) then
			if (col <= energy) then
				v.drawFill(x + i, top    , 1, 3, 52 | flags)
				v.drawFill(x + i, top + 3, 1, 2, 56 | flags)
				v.drawFill(x + i, top + 5, 1, 1, 62 | flags)
			end

			if (col <= lowenergy) then
				v.drawFill(x + i, top    , 1, 3, 37 | flags)
				v.drawFill(x + i, top + 3, 1, 2, 40 | flags)
				v.drawFill(x + i, top + 5, 1, 1, 43 | flags)
			end
		elseif (col <= energy)
		and not ((i+1) >= energy) then
			v.drawFill(x + i, top    , 1, 3, 11 | flags)
			v.drawFill(x + i, top + 3, 1, 2, 23 | flags)
		end
	end

	-- orange bar highlights
	for col = 1, ENERGYHUD_WIDTH do
		local i = (col - 1)
		local top = y + 2

		if (col <= energy) then
			if ((i+1) >= energy) then
				break
			end
			local color = 4
			if (i % 2)
			and (not ((i % 8) == 7)) then
				color = 52
			end
			v.drawFill(x + i, top, 1, 1, color | flags)
		else
			break
		end
	end

	-- red bar highlights
	for col = 1, ENERGYHUD_WIDTH do
		local i = (col - 1)
		local top = y + 2

		if (col <= lowenergy) then
			local color = 4
			if (i % 2) then
				if (col == energy) then
					break
				end
				color = 37
			end
			v.drawFill(x + i, top, 1, 1, color | flags)
		else
			break
		end
	end
end)

-- Intermission tally
hud.add(function(v, player)
	if (player.spectator) then return end
	if (not tdglobalstate.intermission) then return end

	local slide = player.socket_intermission.slide
	local flags = V_PERPLAYER
	local top = 80
	local left = 140
	local numleft = (left + 100)

	-- Sal: Edited for the new intermission gfx

	-- score bonus
	v.draw(left + max(0, slide - 150), top, v.cachePatch("YB_SCORE"), flags)
	v.drawNum(numleft + max(0, slide - 150), top, player.socket_scorebonus, flags)

	-- ring bonus
	v.draw(left + max(0, slide - 50), top + 20, v.cachePatch("YB_RING"), flags)
	v.drawNum(numleft + max(0, slide - 50), top + 20, player.socket_ringbonus, flags)

	-- total
	v.draw(left + slide, top + 60, v.cachePatch("YB_TOTAL"), flags)
	v.drawNum(numleft + slide, top + 60, player.socket_totalscore, flags)
end)
