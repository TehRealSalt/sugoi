freeslot(
	"SPR_SNTR",
	"SPR_BUBF",
	"MT_NOVATREE",
	"S_NOVATREE",
	"S_NOVATREEOVERLAY",
	"MT_NOVASTAR1",
	"MT_NOVASTAR2",
	"S_NOVASTAR1",
	"S_NOVASTAR2",
	"MT_SEAFLOWER",
	"S_SEAFLOWER1",
	"S_SEAFLOWER2",
	"MT_SEAWEEDANIM",
	"S_SEAWEEDANIM",
	"MT_NOVASHOREURCHIN",
	"S_NOVASHOREURCHIN",
	"SPR_URCH"
)

mobjinfo[MT_NOVATREE] = {
	--$Name Nova Tree
	--$Sprite SNTRA0
	--$Category SUGOI Decoration
	doomednum = 3460,
	spawnstate = S_NOVATREE,
	radius = 16*FRACUNIT,
	height = 164*FRACUNIT,
	flags = MF_SOLID|MF_PUSHABLE
}

states[S_NOVATREE] = {SPR_SNTR, A, -1, nil, 0, 0, S_NULL}
states[S_NOVATREEOVERLAY] = {SPR_SNTR, B|FF_FULLBRIGHT, 5, A_OverlayThink, 0, 0, S_NOVATREEOVERLAY}

addHook("MobjSpawn", function(mo)
	mo.target = P_SpawnMobj(mo.x, mo.y, mo.z, MT_OVERLAY)
	mo.target.target = mo
	mo.target.state = S_NOVATREEOVERLAY
end, MT_NOVATREE)

mobjinfo[MT_NOVASTAR1] = {
	--$Name Nova Star (Pink)
	--$Sprite SNTRC0
	--$Category SUGOI Decoration
	doomednum = 3461,
	spawnstate = S_NOVASTAR1,
	radius = 16*FRACUNIT,
	height = 16*FRACUNIT,
	flags = MF_NOTHINK|MF_NOBLOCKMAP
}

mobjinfo[MT_NOVASTAR2] = {
	--$Name Nova Star (Purple)
	--$Sprite SNTRD0
	--$Category SUGOI Decoration
	doomednum = 3462,
	spawnstate = S_NOVASTAR2,
	radius = 16*FRACUNIT,
	height = 16*FRACUNIT,
	flags = MF_NOTHINK|MF_NOBLOCKMAP
}

states[S_NOVASTAR1] = {SPR_SNTR, C|FF_FULLBRIGHT, -1, nil, 0, 0, S_NULL}
states[S_NOVASTAR2] = {SPR_SNTR, D|FF_FULLBRIGHT, -1, nil, 0, 0, S_NULL}

mobjinfo[MT_SEAFLOWER] = {
	--$Name Sea Crystal Flower
	--$Sprite BUBFA0
	--$Category SUGOI Decoration
	doomednum = 3463,
	spawnstate = S_SEAFLOWER1,
	radius = 8*FRACUNIT,
	height = 16*FRACUNIT,
	flags = MF_SCENERY|MF_NOBLOCKMAP
}

states[S_SEAFLOWER1] = {SPR_BUBF, A, 8, nil, 0, 0, S_SEAFLOWER2}
states[S_SEAFLOWER2] = {SPR_BUBF, B, 8, nil, 0, 0, S_SEAFLOWER1}

mobjinfo[MT_SEAWEEDANIM] = {
	--$Name Seaweed (Animated)
	--$Sprite SEWEA0
	--$Category SUGOI Decoration
	doomednum = 3464,
	spawnstate = S_SEAWEEDANIM,
	radius = 24*FRACUNIT,
	height = 56*FRACUNIT,
	flags = MF_SCENERY|MF_NOBLOCKMAP
}

states[S_SEAWEEDANIM] = {SPR_SEWE, A|FF_ANIMATE, -1, nil, 5, 5, S_NULL}

mobjinfo[MT_NOVASHOREURCHIN] = {
	--$Name Sea Urchin
	--$Sprite URCHA0
	--$Category SUGOI Decoration
	doomednum = 2533,
	spawnstate = S_NOVASHOREURCHIN,
	radius = FRACUNIT,
	height = FRACUNIT,
	flags = MF_NOTHINK|MF_NOBLOCKMAP
}

states[S_NOVASHOREURCHIN] = {SPR_URCH, A, -1, nil, 0, 0, S_NULL}
