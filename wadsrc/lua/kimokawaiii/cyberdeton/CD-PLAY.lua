//Cyber Deton Player Script
// - Minor player manipulation
//Note: This should be loaded after CD-BOSS.lua

//Player Spawn - to undo the nuke effect
addHook("PlayerSpawn", function(player)
	player.cd_nuke = false
	player.nuketrans = 0
end)

//Player Thinker - for toggling "player.sheltered" variable and resetting nuke screen setup
addHook("PlayerThink", function(player)
	if player.sheltered
		local in_FOF = P_MobjTouchingSectorSpecial(player.mo, 2, 4)

		if in_FOF
			if in_FOF != player.rover.sector then player.sheltered = false end
		else
			player.sheltered = false
		end
	end

	if player.nuketrans != nil
		if player.nuketrans > 0 then player.cd_nuke = true else player.cd_nuke = false end
		local intensity = (10 - player.nuketrans)*FRACUNIT
		if player.cd_nuke then P_StartQuake(intensity, 1) end
	end

	if player.cd_timer != nil and player.cd_timer > 0
		player.cd_timer = $-1
	end
end)

//Custom Linedef Special
local function ShelterSector(line, mo)
	local player = mo.player
	if player
		player.sheltered = true

		//A simpler check for an FOF could be used but this may be good practice for when I make reusuable scripts
		//that rely on more complicated level design.
		local sec = mo.subsector.sector
		for rover in sec.ffloors()
			if not (rover.master.flags & ML_NOCLIMB) continue end
			player.rover = rover
		end
	end
end
addHook("LinedefExecute", ShelterSector, "SHELTER")


//Player HUD stuff (for enemy count, nuke screen effect and hints)
local function hud_cdboss(v, stplyr)
	if mapheaderinfo[gamemap].lvlttl == "Cyber Deton"
		if leveltime > 45 and saucerlist != nil
			v.draw(27, 73, v.cachePatch("GFXSAUCE"), V_SNAPTOTOP|V_PERPLAYER)
			v.drawString(45, 75, "x "..#saucerlist, V_SNAPTOTOP|V_PERPLAYER)
		end

		if stplyr.cd_timer != nil and stplyr.cd_timer > 0
			v.drawString(20, 130, stplyr.cd_hint, V_PERPLAYER|V_SNAPTOLEFT|V_SNAPTOBOTTOM)
		end

		if stplyr.cd_nuke
			local patch, trans = "NUKESCREEN"..stplyr.nuketrans, stplyr.nuketrans<<V_ALPHASHIFT
			local w, h = v.width()*FRACUNIT, v.height()*FRACUNIT
			v.drawStretched(0, 0, w, h, v.cachePatch(patch), trans|V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER, v.getColormap(TC_DEFAULT, SKINCOLOR_RED))
		end
	end
end
hud.add(hud_cdboss)