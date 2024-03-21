freeslot("MT_JETFUMEC2", "S_JETFUMEC2")

mobjinfo[MT_JETFUMEC2] = {
        doomednum = -1,
        spawnstate = S_JETFUMEC2,
        spawnhealth = 1000,
        seestate = S_NULL,
        seesound = sfx_None,
        reactiontime = 8,
        attacksound = sfx_None,
        painstate = S_NULL,
        painchance = 0,
        painsound = sfx_None,
        meleestate = S_NULL,
        missilestate = S_NULL,
        deathstate = S_NULL,
        xdeathstate = S_NULL,
        deathsound = sfx_None,
        speed = 1,
        radius = 8*FRACUNIT,
        height = 16*FRACUNIT,
        dispoffset = 0,
        mass = 4,
        damage = 0,
        activesound = sfx_None,
        flags = MF_NOBLOCKMAP|MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT,
        raisestate = S_NULL
}
states[S_JETFUMEC2] = {SPR_JETF, FF_ANIMATE|FF_FULLBRIGHT, -1, nil, 1, 1, S_NULL}

