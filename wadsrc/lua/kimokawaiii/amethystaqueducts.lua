freeslot(
		"MT_PATHORB",
		"MT_PATHORBR",
		"S_RED",
		"S_LIGHT",
		"S_HIDE",
		"SPR_PORB",
		"MT_KAWAII",
		"S_TAIKI",
		"S_KAWAII",
		"SPR_KAWA",
		"sfx_kawaii",
		"sfx_aquarium"
		)

mobjinfo[MT_PATHORB] = {
        //$Name Invisible Path Orb
        //$Sprite PORBA0
		//$Category SUGOI Decoration
        doomednum = 1910,
        spawnstate = S_INVISIBLE,
        spawnhealth = 80085,
        radius = 16*FRACUNIT,
        flags = MF_NOGRAVITY|MF_NOCLIP
}

mobjinfo[MT_PATHORBR] = {
        //$Name Visible Red Path Orb
        //$Sprite PORBD0
		//$Category SUGOI Decoration
        doomednum = 1912,
        spawnstate = S_RED,
        spawnhealth = 80085,
        radius = 16*FRACUNIT,
        flags = MF_NOGRAVITY|MF_NOCLIP
}

states[S_LIGHT] = {
        sprite = SPR_PORB,
        frame = FF_FULLBRIGHT|FF_ANIMATE|A,
		var1 = 3,
		var2 = 35,
        tics = 105,
        nextstate = S_INVISIBLE
}

states[S_RED] = {
        sprite = SPR_PORB,
        frame = FF_FULLBRIGHT|D,
        tics = -1,
        nextstate = S_HIDE
}

states[S_HIDE] = {
        sprite = SPR_NULL,
        frame = FF_FULLBRIGHT|A,
        tics = 140,
        nextstate = S_RED
}

mobjinfo[MT_KAWAII] = {
        //$Name Bob Team Epic Popuko
        //$Sprite KAWAA0
		//$Category SUGOI NPCs
        doomednum = 1911,
        spawnstate = S_TAIKI,
        spawnhealth = 80085,
        radius = 32*FRACUNIT,
        flags = MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT
}

states[S_TAIKI] = {
        sprite = SPR_KAWA,
        frame = FF_FULLBRIGHT|FF_ANIMATE|A,
		var1 = 1,
		var2 = 2,
        tics = -1,
        nextstate = S_INVISIBLE
}

states[S_KAWAII] = {
        sprite = SPR_KAWA,
        frame = FF_FULLBRIGHT|FF_ANIMATE|C,
		var1 = 2,
		var2 = 2,
        tics = -1,
        nextstate = S_INVISIBLE
}

local function verticalBoost(line, mo)
	mo.momz = P_AproxDistance(line.dx, line.dy)/4
end

addHook("LinedefExecute", verticalBoost, "BOUNCE")