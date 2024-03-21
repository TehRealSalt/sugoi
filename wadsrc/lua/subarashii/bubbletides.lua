local cameras = {}
local ogl = {}

local function getCam(v, p, c)
	cameras[#p] = c
	if v.renderer() == "opengl"
		ogl[#p] = true
	else
		ogl[#p] = false
	end
end
hud.add(getCam, "game")

local function tintScreen(mo)
	if (mapheaderinfo[gamemap].waterflash != nil)
		for player in players.iterate
			if not (player and player.valid) return end
			if not (player.mo and player.mo.valid) return end
			local mo = player.mo

			if ogl[#player] return end
			local cam = cameras[#player]

			if (cam and cam.chase)
				for fof in cam.subsector.sector.ffloors()
					if not (fof.flags & FF_SWIMMABLE) continue end

					if not ((cam.z + (16*mo.scale/2)) >= fof.topheight)
					and not ((cam.z + (16*mo.scale/2)) < fof.bottomheight)
						P_FlashPal(player, mapheaderinfo[gamemap].waterflash, 1)
					end
				end
			else
				for fof in mo.subsector.sector.ffloors()
					if not (fof.flags & FF_SWIMMABLE) continue end

					if not (player.viewz >= fof.topheight)
					and not (player.viewz < fof.bottomheight)
						P_FlashPal(player, mapheaderinfo[gamemap].waterflash, 1)
					end
				end
			end
		end
	end
end
addHook("ThinkFrame", tintScreen)

local function nogravDrone(mo)
	if not (mapheaderinfo[gamemap].nogravitynightsdrone) return end
	mo.momz = 0
	mo.flags = $1|MF_NOGRAVITY
end
addHook("MobjThinker", nogravDrone, MT_NIGHTSDRONE)

freeslot("MT_PPZFOUNTAIN", "S_PPZFOUNTAIN", "SPR_MFTN")
mobjinfo[MT_PPZFOUNTAIN] = {
	--$Name PPZ Fountain
	--$Sprite MFTNA0
	--$Category SUGOI Decoration
	doomednum = 2230,
	spawnstate = S_PPZFOUNTAIN,
	radius = 24*FRACUNIT,
	height = 96*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_SCENERY
}
states[S_PPZFOUNTAIN] = {SPR_MFTN, A|FF_ANIMATE, -1, nil, 2, 5, S_PPZFOUNTAIN}

freeslot("MT_PPZSMALLCORAL", "S_PPZSMALLCORAL", "MT_PPZCORAL", "S_PPZCORAL", "MT_PPZBIGCORAL", "S_PPZBIGCORAL", "SPR_PPCR")
mobjinfo[MT_PPZSMALLCORAL] = {
	--$Name PPZ Coral (Small)
	--$Sprite PPCRA0
	--$Category SUGOI Decoration
	doomednum = 2231,
	spawnstate = S_PPZSMALLCORAL,
	radius = 32*FRACUNIT,
	height = 72*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_NOTHINK
}
states[S_PPZSMALLCORAL] = {SPR_PPCR, A, -1, nil, 0, 0, S_PPZCORAL}

mobjinfo[MT_PPZCORAL] = {
	--$Name PPZ Coral (Medium)
	--$Sprite PPCRB0
	--$Category SUGOI Decoration
	doomednum = 2232,
	spawnstate = S_PPZCORAL,
	radius = 48*FRACUNIT,
	height = 80*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_NOTHINK
}
states[S_PPZCORAL] = {SPR_PPCR, B, -1, nil, 0, 0, S_PPZBIGCORAL}

mobjinfo[MT_PPZBIGCORAL] = {
	--$Name PPZ Coral (Large)
	--$Sprite PPCRC0
	--$Category SUGOI Decoration
	doomednum = 2233,
	spawnstate = S_PPZBIGCORAL,
	radius = 48*FRACUNIT,
	height = 80*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_NOTHINK
}
states[S_PPZBIGCORAL] = {SPR_PPCR, C, -1, nil, 0, 0, S_PPZBIGCORAL}

freeslot("MT_PPZSMALLWEEDSEA", "S_PPZSMALLWEEDSEA", "MT_PPZWEEDSEA", "S_PPZWEEDSEA", "MT_PPZBIGWEEDSEA", "S_PPZBIGWEEDSEA", "SPR_WEDS")
mobjinfo[MT_PPZSMALLWEEDSEA] = {
	--$Name PPZ Seaweed (Small)
	--$Sprite WEDSA0
	--$Category SUGOI Decoration
	doomednum = 2234,
	spawnstate = S_PPZSMALLWEEDSEA,
	radius = 14*FRACUNIT,
	height = 96*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_NOTHINK
}
states[S_PPZSMALLWEEDSEA] = {SPR_WEDS, A, -1, nil, 0, 0, S_PPZSMALLWEEDSEA}

mobjinfo[MT_PPZWEEDSEA] = {
	--$Name PPZ Seaweed (Medium)
	--$Sprite WEDSB0
	--$Category SUGOI Decoration
	doomednum = 2235,
	spawnstate = S_PPZWEEDSEA,
	radius = 14*FRACUNIT,
	height = 160*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_NOTHINK
}
states[S_PPZWEEDSEA] = {SPR_WEDS, B, -1, nil, 0, 0, S_PPZWEEDSEA}

mobjinfo[MT_PPZBIGWEEDSEA] = {
	--$Name PPZ Seaweed (Large)
	--$Sprite WEDSC0
	--$Category SUGOI Decoration
	doomednum = 2236,
	spawnstate = S_PPZBIGWEEDSEA,
	radius = 14*FRACUNIT,
	height = 256*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_NOTHINK
}
states[S_PPZBIGWEEDSEA] = {SPR_WEDS, C, -1, nil, 0, 0, S_PPZBIGWEEDSEA}
