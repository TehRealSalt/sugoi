--Index:
-- .EARLY FREESLOTS & TABLES
-- .OBJECTS
-- .ACTIONS
-- .EVENTS
-- .HOOKS

--
-- Sal: Redefine MT_STARGENESIS_PULL, as SRB2 removed it.
--
freeslot("MT_STARGENESIS_PULL")

mobjinfo[MT_STARGENESIS_PULL] = {
	doomednum = 755,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1000,
	reactiontime = 8,
	radius = 8,
	height = 8,
	mass = 10,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY
}

------------------------------------------------------------------------------------
-- EARLY FREESLOTS & TABLES
------------------------------------------------------------------------------------

local function setCheckpoint(phase)
    for player in players.iterate
        player.starpostnum = phase
        player.starposttime = player.realtime
        player.starpostx = 0*FRACUNIT
        player.starposty = 0*FRACUNIT
        player.starpostz = 0*FRACUNIT
        player.starpostangle = ANGLE_90
    end
end

--````````````````````````````````````
-- Maps
--````````````````````````````````````
rawset(_G, "internalmaps", {

	NONUMBER = -1,
	["GEN_BUILDMAP"] = 175,
	["GEN_MAP_FOUNTAIN"] = 176,
	["GEN_MAP_BOSS_STARS"] = 177,
})

local internalmaps_meta = {
	__call = function(internalmaps_meta, newtable)
		return internalmaps_meta[newtable]
	end
}
internalmaps = setmetatable(internalmaps, internalmaps_meta)

--````````````````````````````````````
-- MapThingNums
--````````````````````````````````````
rawset(_G, "mapthingNum", {

	NONUMBER = -1,
	["MT_STARROD_W"] = 1031,
	["MT_STAR_BULLET"] = -1,
	["MT_STAR_RET"] = 1020,
	["MT_STAR_RETBOX"] = 1021,
	["MT_PLANET1"] = 1030,
	["MT_STARSHOOT"] = 1032,
	["MT_EXPSTAR"] = 1040,
	["MT_EXPSTAR2"] = -1,
	["MT_EXPSTAR3"] = -1,
	["MT_MINESOARER"] = 1042,
	["MT_DUSTSPAWNER"] = 1050,
	["MT_ALTSKYBOX"] = 680,
})

local mapthingnum_meta = {
	__call = function(mapthingnum_meta, newtable)
		return mapthingnum_meta[newtable]
	end
}
mapthingNum = setmetatable(mapthingNum, mapthingnum_meta)
------------------------------------------------------------------------


-- Loose Actor Sprites
freeslot("SPR_DRAC") -- Mysterious Character
freeslot("SPR_EGGL") -- Egg Lying
freeslot("SPR_CRID") -- Eggmobile
freeslot("SPR_CTHK") -- Centered Thok
freeslot("SPR_STSP") -- Starship internal
freeslot("SPR_DRCK") -- Crack
freeslot("SPR_RGHT") -- ??? Defeat





-- Boss Object Form / Sprites
freeslot("MT_EXPSTAR", "S_FLORSIT0", "SPR_ANGR")
for i = 65,90, 1 do
	freeslot("SPR_ZZZ"..string.char(i))
end
freeslot("SPR_ZZBA")
--[[for i = 65,73, 1 do
	freeslot("SPR_ZZB"..string.char(i))
end]]
-- Phase 2
for i = 65,90, 1 do
	freeslot("SPR_YYY"..string.char(i))
end
--[[
for i = 65,90, 1 do
	freeslot("SPR_YYA"..string.char(i))
end
]]

freeslot("MT_EXPSTAR2", "S_EXP_FORM2")
--freeslot("MT_EXPSTAR3", "S_EXP_FORM3")





--````````````````````````````````````
-- SPRITE
--````````````````````````````````````
rawset(_G, "SPRITE", {
	-- Used: *
	["gns_Demo_Closed"] = SPR_ZZZA, -- Frames: 1 [A]
	["gns_Demo_OpenLeft01"] = SPR_ZZZB, -- Frames: 7 [A-G]
	["gns_Demo_OpenLeft02"] = SPR_ZZZC, -- Frames: 7 [A-G]
	["gns_Demo_OpenRight01"] = SPR_ZZZD, -- Frames: 7 [A-G]
	["gns_Demo_OpenRight02"] = SPR_ZZZE, -- Frames: 7 [A-G]
	["gns_Demo_OpenMiddle01"] = SPR_ZZZF, -- Frames: 7 [A-G]
	["gns_Demo_Yell01"] = SPR_ZZZG, -- Frames: 7 [A-G]
	["gns_Demo_Yell02_LP"] = SPR_ZZZH, -- Frames: 7 [A-G]
	["gns_Demo_Yell02_End"] = SPR_ZZZI, -- Frames: 7 [A-G]
	["gns_IdleStill"] = SPR_ZZZJ, -- Frames: 5 [A-E]
	["gns_SynthesisExecute"] = SPR_ZZZK, -- Frames: 7 [A-G]
	["gns_StarSkyRip"] = SPR_ZZZL, -- Frames: 7 [A-G]
	["gns_ShardSwipeStart"] = SPR_ZZZM, -- Frames: 5 [A-E]
	["gns_ShardSwipeEnd"] = SPR_ZZZN, -- Frames: 5 [A-E]
	["gns_SolarBeamStart"] = SPR_ZZZO, -- Frames: 5 [A-E]
	["gns_SolarBeamSpin"] = SPR_ZZZP, -- Frames: 7 [A-G]
	["gns_SolarBeamSpin_LP"] = SPR_ZZZQ, -- Frames: 7 [A-G]
	["gns_SolarBeamEnd"] = SPR_ZZZR, -- Frames: 5 [A-E]
	["gns_SunDriveStart"] = SPR_ZZZS, -- Frames: 7 [A-G]
	["gns_SunDriveLP"] = SPR_ZZZT, -- Frames: 7 [A-G]
	["gns_SunDriveEnd"] = SPR_ZZZU, -- Frames: 7 [A-G]
	["gns_Move"] = SPR_ZZZV, -- Frames: 5 [A-E]
	["gns_MHurt"] = SPR_ZZZW, -- Frames: 3 [A-C]
	["gns_MegaHurt"] = SPR_ZZZX, -- Frames: 3 [A-C]
	["gns_WarpOut"] = SPR_ZZZY, -- Frames: 7 [A-G]
	["gns_WarpIn"] = SPR_ZZZZ, -- Frames: 7 [A-G]
	["gns_AnyAction"] = SPR_ZZBA, -- Frames: 7 [A-G] (PortalOpen)

	["drm_Demo_Pulsate"] = SPR_YYYA, -- Frames: 7 [A-G]
	["drm_Demo_Roar01S"] = SPR_YYYB, -- Frames: 7 [A-G]
	["drm_Demo_Roar02F"] = SPR_YYYC, -- Frames: 5 [A-E]
	["drm_Demo_Roar02F_LP"] = SPR_YYYD, -- Frames: 7 [A-G]
	["drm_IdleStill"] = SPR_YYYE, -- Frames: 11 [A-K]
	["drm_StarShooting"] = SPR_YYYF, -- Frames: 11 [A-G]
	["drm_AnyAction1"] = SPR_YYYG, -- Frames: 11 [A-G]
	["drm_AnyAction2"] = SPR_YYYH, -- Frames: 11 [A-M]
	["drm_AnyAction3"] = SPR_YYYI, -- Frames: 11 [A-M]
	["drm_BladeSpinStart"] = SPR_YYYJ, -- Frames: 11 [A-M]
	["drm_BladeSpin_LP"] = SPR_YYYK, -- Frames: 11 [A-I]
	["drm_BladeSpinEnd"] = SPR_YYYL, -- Frames: 11 [A-I]
	["drm_WarpOut"] = SPR_YYYM, -- Frames: 11 [A-M]
	["drm_WarpIn"] = SPR_YYYN, -- Frames: 11 [A-M]
	["drm_FaceReveal"] = SPR_YYYO, -- Frames: 11 [A-I]
	["drm_R_IdleStill"] = SPR_YYYP, -- Frames: 11 [A-K]
	["drm_R_StarShooting"] = SPR_YYYQ, -- Frames: 11 [A-G]
	["drm_R_AnyAction1"] = SPR_YYYR, -- Frames: 11 [A-G]
	["drm_R_AnyAction2"] = SPR_YYYS, -- Frames: 11 [A-M]
	["drm_R_AnyAction3"] = SPR_YYYT, -- Frames: 11 [A-M]
	["drm_R_BladeSpinStart"] = SPR_YYYU, -- Frames: 11 [A-M]
	["drm_R_BladeSpin_LP"] = SPR_YYYV, -- Frames: 11 [A-I]
	["drm_R_BladeSpinEnd"] = SPR_YYYW, -- Frames: 11 [A-I]
	["drm_R_WarpOut"] = SPR_YYYX, -- Frames: 11 [A-M]
	["drm_R_WarpIn"] = SPR_YYYY, -- Frames: 11 [A-M]
	["drm_R_Hurt"] = SPR_YYYZ, -- Frames: 7 [A-G]
})
SPRITE = setmetatable(SPRITE, {
	__call = function(sprn, val)
		--print("called into "..val)
		return sprn[val]
	end
})
------------------------------------------------------------------------

--12-30-2016 Modified Level floor height from -256 to -1024

--````````````````````````````````````
-- DUMMY MOBJ
--````````````````````````````````````
rawset(_G, "maplocation", {
	["PLAYER_MAP_SPAWNPOINT"] = {x = 0*FRACUNIT, y = 0*FRACUNIT, z = 0*FRACUNIT, angle = FixedAngle(90*FRACUNIT)},
	["PLAYER_SPAWNPOINT"] = {x = 0*FRACUNIT, y = 0*FRACUNIT, z = 0*FRACUNIT, angle = FixedAngle(90*FRACUNIT)},
	--["PLAYER_SPAWNPOINT"] = {x = 0*FRACUNIT, y = -4*FRACUNIT, z = 0*FRACUNIT, angle = FixedAngle(90*FRACUNIT)},

	["MAINFIELD_VIEWPOINT"] = {x = 0*FRACUNIT, y = -256*FRACUNIT, z = 0*FRACUNIT, angle = FixedAngle(90*FRACUNIT)},
	["MT_IIANASTAR_SPAWNPOINT"] = {x = 0*FRACUNIT, y = 832*FRACUNIT, z = 0*FRACUNIT},
	["GNS_SPAWNPOINT"] = {x = 0*FRACUNIT, y = 832*FRACUNIT, z = 0*FRACUNIT},
	["GNS_SPINBLADEPOINT"] = {x = 0*FRACUNIT, y = 3200*FRACUNIT, z = 0*FRACUNIT},

	--Negatives for harder difficulty?
	["MT_SYNTHPOINT1"] = {x = -640*FRACUNIT, y = 560*FRACUNIT, z = 256*FRACUNIT},
	["MT_SYNTHPOINT2"] = {x = 640*FRACUNIT, y = 560*FRACUNIT, z = 256*FRACUNIT},
	["MT_SYNTHPOINT3"] = {x = -580*FRACUNIT, y = 560*FRACUNIT, z = 0*FRACUNIT},
	["MT_SYNTHPOINT4"] = {x = 580*FRACUNIT, y = 560*FRACUNIT, z = 0*FRACUNIT},
	["MT_SYNTHPOINT5"] = {x = -490*FRACUNIT, y = 560*FRACUNIT, z = -256*FRACUNIT},
	["MT_SYNTHPOINT6"] = {x = 490*FRACUNIT, y = 560*FRACUNIT, z = -256*FRACUNIT},
	["MT_SYNTHPOINT7"] = {x = 0*FRACUNIT, y = 560*FRACUNIT, z = -360*FRACUNIT},

})
maplocation = setmetatable(maplocation, {
	__call = function(dmy, new)
		--[[dmy[new].x = $1 * FRACUNIT
		dmy[new].y = $1 * FRACUNIT
		dmy[new].z = $1 * FRACUNIT]]
		return dmy[new]
	end
})
------------------------------------------------------------------------


--````````````````````````````````````
-- DUMMY MOBJ Attribute
--````````````````````````````````````
rawset(_G, "EnemyHud", {
	["starlis"] = {hide = false},
	["soleye"] = {hide = false}
})
EnemyHud = setmetatable(EnemyHud, {
	__call = function(e, v)
		return e[v]
	end
})
------------------------------------------------------------------------

--````````````````````````````````````
-- SOUND
--````````````````````````````````````
freeslot("sfx_pmdpt")
freeslot("sfx_slomo")
freeslot("sfx_lasprk")
freeslot("sfx_utale2")
freeslot("sfx_skai2", "sfx_crak", "sfx_brek", "sfx_hexp")
freeslot("sfx_lasb8")
freeslot("sfx_ris01", "sfx_ris02", "sfx_ris03", "sfx_ris04")
freeslot("sfx_rdth1", "sfx_rdth2")
freeslot("sfx_kexpls", "sfx_kexpl", "sfx_khit1", "sfx_khit3", "sfx_kexpl2", "sfx_bmetr")
freeslot("sfx_sla01", "sfx_sla02")
freeslot("sfx_lunl", "sfx_strprt", "sfx_strfre", "sfx_dmcont", "sfx_dmumk", "sfx_grow", "sfx_wcut", "sfx_las2", "sfx_lasb", "sfx_lasa",
"sfx_v01out", "sfx_v01in", "sfx_dgrow", "sfx_strdth")
rawset(_G, "Snd", {
	["SE_EFF_SLOWMOTION"] = sfx_slomo,
	["SE_EFF_WINDSPARKLE"] = sfx_lasprk,
	["SE_EFF_UNDRTLE_02"] = sfx_utale2,

	["SE_KR_EXPLODE1S"] = sfx_kexpls,
	["SE_KR_EXPLODE1"] = sfx_kexpl,
	["SE_KR_EXPLODE2"] = sfx_kexpl2,
	["SE_KR_HIT1"] = sfx_khit1,
	["SE_KR_HIT3"] = sfx_khit3,
	["SE_KR_METER"] = sfx_bmetr,
	["SE_KR_GROW"] = sfx_grow,
	["SE_KR_LAS2"] = sfx_las2,
	["SE_KR_LASERCHARGE"] = sfx_lasb,
	["SE_KR_LASERCHARGE_8"] = sfx_lasb8,
	["SE_KR_LASERFIREA"] = sfx_lasa,
	["SE_KR_SLASH01"] = sfx_sla01,
	["SE_KR_SLASH02"] = sfx_sla02,
	["SE_EFF_VOCIN"] = sfx_v01in,
	["SE_EFF_VOCOUT"] = sfx_v01out,
	["SE_EFF_LUNALA"] = sfx_lunl,
	["SE_EFF_STARPORTAL"] = sfx_strprt,
	["SE_EFF_STARFIRE"] = sfx_strfre,
	["SE_EFF_DGROW"] = sfx_dgrow,
	["SE_EFF_SKAI_2"] = sfx_skai2,
	["SE_EFF_BARRIER_CRACK"] = sfx_crak,
	["SE_EFF_BARRIER_BREAK"] = sfx_brek,
	["SE_EFF_BARRIER_EXPLODE"] = sfx_hexp,
	["SE_EFF_DRM_R_VOICE01"] = sfx_ris01,
	["SE_EFF_DRM_R_VOICE02"] = sfx_ris02,
	["SE_EFF_DRM_R_VOICE03"] = sfx_ris03,
	["SE_EFF_DRM_R_VOICE04"] = sfx_ris04,
	["SE_EFF_STARLIS_ENDING1"] = sfx_strdth,
	["SE_EFF_DARKUMEKI"] = sfx_dmumk,
	["SE_EFF_DARKCOUNTER"] = sfx_dmcont,
	["SE_EFF_DREAM_R_DEFEAT1"] = sfx_rdth1,
	["SE_EFF_DREAM_R_DEFEAT2_SCREAM"] = sfx_rdth2,

	["BGM_EV_none"] = "quiet",
	["BGM_EV_RUSA"] = "rusami",
	["BGM_EV_CONHIT"] = "conhit",
	["BGM_EV_DOGMA"] = "dogma",
	["BGM_EV_FEAR"] = "mlfear",
	["BGM_EV_CREEP"] = "black",
	["BGM_EV_AMBITION"] = "ambitn",
	["BGM_EV_ATTACK"] = "attack",
	["BGM_EV_STARDREAM_INTRO"] = "strint",
	["BGM_EV_STARDREAM"] = "strdrm",
	["BGM_EV_TLSPACE01"] = "drkfor",
	["BGM_EV_SPACE2"] = "free",
	--["BGM_EV_EXPERIMENT"] = "drkfor",
})
Snd = setmetatable(Snd, {
	__call = function(s, val)

		return s[val] or "none"
	end
})

S_sfx[sfx_lasa].flags = $1|SF_TOTALLYSINGLE

------------------------------------------------------------------------





--````````````````````````````````````
-- PAUSE
--````````````````````````````````````
rawset(_G, "EVPAUSE", {})


local function codeYLW(str)
	return "\x82"..str.."\x80"
end


EVPAUSE.currentMainEntry = {entry = "null"}


function EVPAUSE.UPDATEPAUSEINFO(tableList)
	EVPAUSE.currentMainEntry.entry = tableList.entry
end


COM_AddCommand("updmain", function(player, text)
	local str = text:gsub("/n", "\n")
	EVPAUSE.currentMainEntry = {entry = str}
end)
--updmain "Darkness Reborn. Using/nDiragyn as a host, it has/nresurrected itself fully/nusing the power of the Soul/nHeart.It now carries more than/nenough power to seek more/nthan the destruction of the/ncosmos. Revenge."

EVPAUSE.PauseInfoList = {
	["star_01d_entry"] = {entry =
							"A mysterious figure has\n"..
							"stolen and\x82 fused\x80 with\n"..
							"Star Genesis and the\n"..
							"Chaos Emeralds! But \x82why?\x80\n"..
							"Who is this mysterious\n"..
							"\x82intruder\x80, and \x82where did\n"..
							"\x82they come from?\x80\n"..
							"Fire away, \x82S-Gear!\x80"},
	["star_02d_entry"] = {entry =
							"The mysterious intruder\n"..
							"has now\x82 drawn more power\n\x82"..
							"from another dimension\x80.\n"..
							"Its\x82 true form\x80 has been\n"..
							"regenerated, and its power\n"..
							"has reached\x82 99.9% \x80of its\n\x82"..
							"full potential.\x80"},
}
EVPAUSE.PauseInfoList = setmetatable(EVPAUSE.PauseInfoList, {
	__call = function(s, val)
		return s[val]
	end
})

------------------------------------------------------------------------









------------------------------------------------------------------------------------
-- OBJECTS
------------------------------------------------------------------------------------

--Player Camera
freeslot("MT_PCAM", "S_PCAM")
mobjinfo[MT_PCAM] = {
	doomednum = -1,
	spawnhealth = 8,
	spawnstate = S_PCAM,
	speed = 8*FRACUNIT,
	radius = 32*FRACUNIT,
	height = 32*FRACUNIT,
	damage = 0,
	mass = 0,
	flags = MF_NOGRAVITY|MF_FLOAT|MF_NOCLIP
}
states[S_PCAM] = {SPR_NULL,0,-1,A_None,0,0,S_PCAM}

-- Star Rod 2W

freeslot("MT_STARROD_W", "S_STAR_RODW0", "SPR_STRW")
mobjinfo[MT_STARROD_W] = {
	doomednum = mapthingNum("MT_STARROD_W"),
	spawnhealth = 8,
	spawnstate = S_STAR_RODW0,
	speed = 8*FRACUNIT,
	radius = 32*FRACUNIT,
	height = 32*FRACUNIT,
	damage = 0,
	mass = 0,
	flags = MF_NOGRAVITY|MF_FLOAT|MF_NOCLIP
}
states[S_STAR_RODW0] = {SPR_STRW,0,-1,A_None,0,0,S_STAR_RODW0}

-- Star Reticle (Star 1)
freeslot("MT_STAR_RET", "S_STARRET0", "SPR_SRTC")
-- Star Reticle (Box)
freeslot("MT_STAR_RETBOX", "S_STARRETBOX0", "SPR_SRTB")

-- Star Bullet
freeslot("MT_STAR_BULLET", "S_STAR_BLLT0", "SPR_STBU") --SPR_STBL

mobjinfo[MT_STAR_RET] = {
	doomednum = mapthingNum("MT_NONUMBER"),
	spawnhealth = 8,
	spawnstate = S_STARRET0,
	speed = 8,
	radius = 64*FRACUNIT,
	height = 64*FRACUNIT,
	damage = 0,
	mass = 0,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOBLOCKMAP
}
states[S_STARRET0] = {SPR_SRTC,0,1,function(mo)
	mo.scale = 2*FRACUNIT
end,0,0,S_STARRET0}


mobjinfo[MT_STAR_RETBOX] = {
	doomednum = mapthingNum("MT_STAR_RETBOX"),
	spawnhealth = 8,
	spawnstate = S_STARRETBOX0,
	speed = 8,
	radius = 64*FRACUNIT,
	height = 64*FRACUNIT,
	damage = 0,
	mass = 0,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOBLOCKMAP
}
states[S_STARRETBOX0] = {SPR_SRTB,0,1,function(mo)
	mo.scale = 1*FRACUNIT
end,0,0,S_STARRETBOX0}


mobjinfo[MT_STAR_BULLET] = {
	doomednum = mapthingNum("MT_STAR_BULLET"),
	spawnhealth = 8,
	spawnstate = S_STAR_BLLT0,
	speed = 80*FRACUNIT,
	radius = 32*FRACUNIT,
	height = 32*FRACUNIT,
	damage = 1,
	mass = 100,
	flags = MF_MISSILE|MF_NOGRAVITY
}
states[S_STAR_BLLT0] = {SPR_STBU,0,1,function(mo)
	--mo.scale = 1*FRACUNIT
end,0,0,S_STAR_BLLT0}


freeslot("MT_ALTSKYBOX", "S_ALTSKYBOX0")

mobjinfo[MT_ALTSKYBOX] = {
	doomednum = mapthingNum("MT_ALTSKYBOX"),
	spawnhealth = 8,
	spawnstate = S_ALTSKYBOX0,
	speed = 8,
	radius = 32*FRACUNIT,
	height = 32*FRACUNIT,
	damage = 0,
	mass = 0,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOBLOCKMAP
}
states[S_ALTSKYBOX0] = {SPR_NULL,0,-1,A_None,0,0,S_NULL}

addHook("MobjThinker", function(skybox)
	--[[if (leveltime < 3)
		for player in players.iterate
			if (skybox.spawnpoint.options & MTF_OBJECTSPECIAL)
				-- Set as centerpoint
				P_SetSkyboxMobj(skybox, true)
			else
				-- Set as skybox
				P_SetSkyboxMobj(skybox)
			end
		end
	end]]
end, MT_ALTSKYBOX)



--Scenery

freeslot("MT_STARHOLE_BULLET", "S_STHBULLET0", "SPR_STBA")

mobjinfo[MT_STARHOLE_BULLET] = {
	doomednum = -1,
	spawnhealth = 8,
	spawnstate = S_STHBULLET0,
	--seesound = ,
	speed = 32*FRACUNIT,
	radius = 32*FRACUNIT,
	height = 32*FRACUNIT,
	damage = 8,
	mass = 100,
	flags = MF_MISSILE|MF_NOGRAVITY
}
states[S_STHBULLET0] = {SPR_STBA,0|3<<FF_TRANSSHIFT,1,A_None,0,0,S_STHBULLET0}

freeslot("MT_STAR_ORB", "S_STRORB0", "S_STRORB1", "S_STRORB2", "SPR_SPOW")

mobjinfo[MT_STAR_ORB] = {
	doomednum = -1,
	spawnhealth = 8,
	spawnstate = S_STRORB0,
	--seesound = ,
	speed = 32*FRACUNIT,
	radius = 16*FRACUNIT,
	height = 32*FRACUNIT,
	damage = 8,
	mass = 100,
	flags = MF_MISSILE|MF_NOGRAVITY
}
states[S_STRORB0] = {SPR_SPOW,0|3<<FF_TRANSSHIFT,2,A_None,0,0,S_STRORB1}
states[S_STRORB1] = {SPR_SPOW,1|3<<FF_TRANSSHIFT,2,A_None,0,0,S_STRORB2}
states[S_STRORB2] = {SPR_SPOW,2|3<<FF_TRANSSHIFT,2,A_None,0,0,S_STRORB0}

freeslot("MT_YLW_ORB", "S_YLW_ORB0", "SPR_YLOR")

mobjinfo[MT_YLW_ORB] = {
	doomednum = -1,
	spawnhealth = 8,
	spawnstate = S_YLW_ORB0,
	--seesound = sfx_rail2,
	speed = 80*FRACUNIT,
	radius = 64*FRACUNIT,
	height = 80*FRACUNIT,
	damage = 8,
	mass = 100,
	flags = MF_MISSILE|MF_NOGRAVITY
}
states[S_YLW_ORB0] = {SPR_YLOR,0|3<<FF_TRANSSHIFT,1,A_None,0,0,S_YLW_ORB0}

freeslot("MT_YLW_CRACKLE", "S_YLW_CRACK0", "S_YLW_CRACK1", "S_YLW_CRACK_LP", "SPR_YCRK")

mobjinfo[MT_YLW_CRACKLE] = {
	doomednum = -1,
	spawnhealth = 8,
	spawnstate = S_YLW_CRACK0,
	--seesound = sfx_rail2,
	speed = 80*FRACUNIT,
	radius = 32*FRACUNIT,
	height = 32*FRACUNIT,
	damage = 8,
	mass = 100,
	flags = MF_NOGRAVITY
}
states[S_YLW_CRACK0] = {SPR_YCRK,0|4<<FF_TRANSSHIFT,2,A_None,0,0,S_YLW_CRACK1}
states[S_YLW_CRACK1] = {SPR_YCRK,1|4<<FF_TRANSSHIFT,2,A_None,0,0,S_YLW_CRACK_LP}
states[S_YLW_CRACK_LP] = {SPR_YCRK,1|4<<FF_TRANSSHIFT,0,A_Repeat,15,S_YLW_CRACK0,S_NULL}
--states[S_YLW_CRACK0] = {SPR_YCRK,0|4<<FF_TRANSSHIFT,2,A_None,0,0,S_YLW_CRACK1}
--states[S_YLW_CRACK1] = {SPR_YCRK,1|4<<FF_TRANSSHIFT,0,A_None,0,0,S_NULL}
-- Revert if Lagged (*)

-- KExplode
freeslot("MT_KEXPLODE", "SPR_KEXP")
for i = 0,5, 1 do
	freeslot("S_KEXPLODE"..tostring(i))
end

mobjinfo[MT_KEXPLODE] = {
	doomednum = -1,
	spawnhealth = 8,
	spawnstate = S_KEXPLODE0,
	speed = 8,
	radius = 64*FRACUNIT,
	height = 64*FRACUNIT,
	damage = 64*FRACUNIT,
	mass = 0,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_MISSILE
}
states[S_KEXPLODE0] = {SPR_KEXP,0,2,function(mo)
	P_StartQuake(12*FRACUNIT, 4, {0, 0, 0},0)
	S_StartSoundAtVolume(nil, Snd("SE_KR_EXPLODE1S"), 100)
end,0,0,S_KEXPLODE1}
states[S_KEXPLODE1] = {SPR_KEXP,1,2,A_Explode,0,0,S_KEXPLODE2}
states[S_KEXPLODE2] = {SPR_KEXP,2,2,A_Explode,0,0,S_KEXPLODE3}
states[S_KEXPLODE3] = {SPR_KEXP,3,2,A_Explode,0,0,S_KEXPLODE4}
states[S_KEXPLODE4] = {SPR_KEXP,4,2,A_Explode,0,0,S_KEXPLODE5}
states[S_KEXPLODE5] = {SPR_KEXP,5,2,A_Explode,0,0,S_NULL}



-- Planet 1
freeslot("MT_BGSUN", "S_BGSUN_0", "SPR_BSUN")

mobjinfo[MT_BGSUN] = {
	doomednum = mapthingNum("MT_PLANET1"),
	spawnhealth = 8,
	spawnstate = S_BGSUN_0,
	speed = 8,
	radius = 64*FRACUNIT,
	height = 64*FRACUNIT,
	damage = 0,
	mass = 0,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOBLOCKMAP
}
states[S_BGSUN_0] = {SPR_BSUN,A|TR_TRANS60,12,function(mo)
	--print("spawned")
	mo.scale = 2*FRACUNIT
	mo.scaled = P_SpawnMobj(mo.x,mo.y,mo.z, MT_STARGENESIS_PULL)
	mo.scaled.fuse = 64
	mo.scaled.sprite = SPR_BSUN
	mo.scaled.frame = $1|8<<FF_TRANSSHIFT
	--mo.scaled = P_SpawnMobj(mo.x,mo.y,mo.z, MT_BGSUN_FLARE1)
	--mo.scaled.newscale = mo.scale
	mo.scaled.scale = mo.scale*2
	mo.scaled.destscale = mo.scale*7/5
	mo.scaled.scalespeed = mo.scale/80
end,0,0,S_BGSUN_0}

freeslot("MT_SCENERY_STARSHOOTER", "S_STRSHOOT")

mobjinfo[MT_SCENERY_STARSHOOTER] = {
	doomednum = mapthingNum("MT_STARSHOOT"),
	spawnhealth = 8,
	spawnstate = S_STRSHOOT,
	speed = 8,
	radius = 64*FRACUNIT,
	height = 64*FRACUNIT,
	damage = 0,
	mass = 0,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOBLOCKMAP
}
states[S_STRSHOOT] = {SPR_NULL,A,64,function(mo)
	mo.scale = 2*FRACUNIT
	mo.shootingStar = P_SpawnMobj(mo.x,mo.y,mo.z, MT_STARGENESIS_PULL)
	mo.shootingStar.sprite = SPR_THOK
	mo.shootingStar.frame = $1|TR_TRANS80
	mo.shootingStar.color = SKINCOLOR_CYAN
	mo.shootingStar.scale = FRACUNIT/2
	mo.shootingStar.destscale = FRACUNIT/32
	mo.shootingStar.scalespeed = mo.scale/512
	local direction = P_RandomChoice({-1, 1})
	mo.shootingStar.momz = direction*P_RandomRange(1, 6)*FRACUNIT
	mo.shootingStar.momx = direction*6*FRACUNIT
	mo.shootingStar.momy = -1*FRACUNIT
	mo.shootingStar.cusval = 1
	mo.shootingStar.fuse = 4*TICRATE
	--mo.shootingStar.fuse = mo.scale/FRACBITS
end,0,0,S_STRSHOOT}
--[[
-- (Scaled) Planet 1
freeslot("MT_BGSUN_FLARE1", "S_BGSUNFLARE1_0","S_BGSUNFLARE1_1")

mobjinfo[MT_BGSUN_FLARE1] = {
	doomednum = -1,
	spawnhealth = 8,
	spawnstate = S_BGSUNFLARE1_0,
	speed = 8,
	radius = 64*FRACUNIT,
	height = 64*FRACUNIT,
	damage = 0,
	mass = 0,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOBLOCKMAP
}
states[S_BGSUNFLARE1_0] = {SPR_BSUN,0|8<<FF_TRANSSHIFT,26,nil,0,0,S_BGSUNFLARE1_1}
states[S_BGSUNFLARE1_1] = {SPR_BSUN,0|9<<FF_TRANSSHIFT,6,nil,0,0,S_NULL}]]


-- Star Hole
freeslot("MT_STARHOLE", "S_HOLES_0", "S_STARHOLE_NOSPAWNING", "S_STARHOLE_ENDSPAWNER", "SPR_SHLE", "SPR_SHLT", "SPR_SHLR")
freeslot("MT_STARHOLE_OUTER", "S_STARHOLEOUTER_0","S_STARHOLEOUTER_1")

mobjinfo[MT_STARHOLE] = {
	doomednum = -1,
	spawnhealth = 8,
	spawnstate = S_HOLES_0,
	speed = 8,
	radius = 64*FRACUNIT,
	height = 64*FRACUNIT,
	damage = 0,
	mass = 0,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOBLOCKMAP
}

local function starhole_afterimage(mo)
	--print("spawned")
	mo.scaled = P_SpawnMobj(mo.x,mo.y,mo.z, MT_STARGENESIS_PULL)
	mo.scaled.sprite = SPR_SHLE
	mo.scaled.frame = A|8<<FF_TRANSSHIFT
	--mo.scaled.newscale = mo.scale
	mo.scaled.scale = mo.scale
	mo.scaled.destscale = mo.scale*7/5
	mo.scaled.scalespeed = mo.scale/80
	mo.scaled.fuse = 32
end

states[S_HOLES_0] = {SPR_SHLE,0,8,function(mo) starhole_afterimage(mo) end,0,0,S_HOLES_0}
states[S_STARHOLE_NOSPAWNING] = {SPR_SHLE,0,8,function(mo) starhole_afterimage(mo) end,0,0,S_STARHOLE_NOSPAWNING}
states[S_STARHOLE_ENDSPAWNER] = {SPR_SHLE,0,8,function(mo) starhole_afterimage(mo) end,0,0,S_STARHOLE_ENDSPAWNER}

--[[
mobjinfo[MT_STARHOLE_OUTER] = {
	doomednum = -1,
	spawnhealth = 8,
	spawnstate = S_STARHOLEOUTER_0,
	speed = 8,
	radius = 64*FRACUNIT,
	height = 64*FRACUNIT,
	damage = 0,
	mass = 0,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOBLOCKMAP
}
states[S_STARHOLEOUTER_0] = {SPR_SHLE,0|8<<FF_TRANSSHIFT,26,nil,0,0,S_STARHOLEOUTER_1}
states[S_STARHOLEOUTER_1] = {SPR_SHLE,0|9<<FF_TRANSSHIFT,6,nil,0,0,S_NULL}]]


-- Soar
freeslot("MT_MINESOARER", "S_MINESOARER_0", "S_MINESOARER_1", "S_MINESOARER_DEAD",
 "SPR_SREM", "SPR_SRER", "SPR_SREB")

mobjinfo[MT_MINESOARER] = {
	doomednum = mapthingNum("MT_MINESOARER"),
	spawnhealth = FRACUNIT,
	spawnstate = S_MINESOARER_0,
	speed = 16,
	radius = 24*FRACUNIT,
	height = 24*FRACUNIT,
	damage = 0,
	mass = 0,
	flags = MF_NOGRAVITY --MF_SPECIAL|MF_SHOOTABLE|MF_ENEMY
}

states[S_MINESOARER_0] = {SPR_SREM,0,-1,A_none,0,0,S_MINESOARER_0}
states[S_MINESOARER_1] = {SPR_SRER,0,1,A_none,0,0,S_MINESOARER_1}
-- Explode
states[S_MINESOARER_DEAD] = {SPR_SREB,0,45,A_none,0,0,S_KEXPLODE0}
--states[S_MINESOARER_DEAD2] = {SPR_NULL,0,45,A_SpawnObjectAbsolute,0,MT_KEXPLODE,S_NULL}

addHook("MobjThinker", function(mo)
	if mo.events == nil then
		mo.events = {}
	end
end, MT_MINESOARER)

addHook("MobjDamage", function(mo, inflictor, source, damage)
	if (mo.flags & MF_SHOOTABLE) then
		mo.health = $1-1
		local delay = 5
		if not mo.hittimer or mo.hittimer <= leveltime - delay then
			mo.hittimer = leveltime
			S_StartSoundAtVolume(nil, Snd("SE_KR_HIT1"), 48)
			--print(mo.health)
		end
	end
	if (mo.health <= 10) then
		mo.health = 0
		mo.flags = $1&~MF_SHOOTABLE|MF_ENEMY
		OBJECT:CreateNew(MT_KEXPLODE, mo)
		P_StartQuake(12*FRACUNIT, 4, {0, 0, 0},0)
		S_StartSoundAtVolume(nil, Snd("SE_KR_EXPLODE1S"), 100)
		mo.state = S_MINESOARER_DEAD
	end

	--mo.isDamaged = false
	return true
end, MT_MINESOARER)



freeslot("MT_DUSTSPAWNER", "S_DUSTSPAWN0", "S_DUSTSPAWN1", "S_DUSTSPAWN2")

function A_StarSpawner(actor, var1, var2)
	local star = P_SpawnMobj(actor.x + P_RandomRange(-1024, 1024)*FRACUNIT, actor.y + P_RandomRange(-256, 256)*FRACUNIT, actor.z + P_RandomRange(-240, 256)*FRACUNIT, MT_STARGENESIS_PULL)
	star.sprite = SPR_CTHK
	star.color = SKINCOLOR_WHITE
	star.frame = $1|TR_TRANS20
	--star.cusval = 1
	--star.scale = FRACUNIT/2
	if (var1 and var1 == 1) then
		star.momy = -64*FRACUNIT
		star.fuse = 50
	else
		star.momy = -32*FRACUNIT
		star.fuse = 100
	end
	star.scale = max(P_RandomRange(FRACUNIT/5, 1*FRACUNIT/5), 1*FRACUNIT/5)
end

function A_StarSpawner_End(actor, var1, var2)
	local star = P_SpawnMobj(actor.x + P_RandomRange(-1024, 1024)*FRACUNIT, actor.y + P_RandomRange(-256, 256)*FRACUNIT, actor.z + P_RandomRange(-240, 256)*FRACUNIT, MT_STARGENESIS_PULL)
	star.sprite = SPR_CTHK
	star.color = P_RandomChoice({SKINCOLOR_CYAN, SKINCOLOR_RED, SKINCOLOR_YELLOW, SKINCOLOR_PURPLE, SKINCOLOR_ORANGE, SKINCOLOR_RED})
	star.frame = $1|TR_TRANS20|FF_FULLBRIGHT
	--star.cusval = 1
	--star.scale = FRACUNIT/2
	if (var1 and var1 == 1) then
		star.momy = -64*FRACUNIT
		star.fuse = 50
	else
		star.momy = -32*FRACUNIT
		star.fuse = 100
	end
	star.scale = max(P_RandomRange(FRACUNIT/5, 1*FRACUNIT/5), 1*FRACUNIT/5)
end

mobjinfo[MT_DUSTSPAWNER] = {
	doomednum = mapthingNum("MT_DUSTSPAWNER"),
	spawnhealth = 8,
	spawnstate = S_DUSTSPAWN0,
	speed = 8,
	radius = 64*FRACUNIT,
	height = 64*FRACUNIT,
	damage = 0,
	mass = 0,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOBLOCKMAP
}
states[S_DUSTSPAWN0] = {SPR_NULL,0,8, A_StarSpawner,0,0, S_DUSTSPAWN0}
states[S_DUSTSPAWN1] = {SPR_NULL,0,4, A_StarSpawner,1,0, S_DUSTSPAWN1}
states[S_DUSTSPAWN2] = {SPR_NULL,0,2, A_StarSpawner_End,1,0, S_DUSTSPAWN2}


-- Wave Circle
freeslot("MT_WAVE_CIRC", "S_WAVEC0", "S_WAVEC1", "SPR_WAVC")

mobjinfo[MT_WAVE_CIRC] = {
	doomednum = -1,
	spawnhealth = 8,
	spawnstate = S_WAVEC0,
	speed = 8,
	radius = 64*FRACUNIT,
	height = 64*FRACUNIT,
	damage = 0,
	mass = 0,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOBLOCKMAP
} --states[S_WAVEC0] = {SPR_WAVC,0,-1,A_None,0,0,S_WAVEC0}
states[S_WAVEC0] = {
        sprite = SPR_WAVC,
        frame = 0|8<<FF_TRANSSHIFT,
        tics = 5,
		nextstate = S_WAVEC1
}
states[S_WAVEC1] = {
        sprite = SPR_WAVC,
        frame = 0|9<<FF_TRANSSHIFT,
        tics = 5,
		nextstate = S_NULL
}

-- SweepLineWarning
freeslot("MT_SWEEP_WARNING", "S_SWEEPWARN0", "S_SWEEPWARN1", "S_SWEEPWARN2", "S_SWEEPWARN3","SPR_WSWP")

mobjinfo[MT_SWEEP_WARNING] = {
	doomednum = -1,
	spawnhealth = 8,
	spawnstate = S_SWEEPWARN0,
	speed = 8,
	radius = 32*FRACUNIT,
	height = 32*FRACUNIT,
	damage = 0,
	mass = 0,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOBLOCKMAP
}
states[S_SWEEPWARN0] = {SPR_WSWP,0|5<<FF_TRANSSHIFT,2,A_None,0,0, S_SWEEPWARN1}
states[S_SWEEPWARN1] = {SPR_WSWP,1|5<<FF_TRANSSHIFT,2,A_None,0,0, S_SWEEPWARN2}
states[S_SWEEPWARN2] = {SPR_WSWP,2|5<<FF_TRANSSHIFT,2,A_None,0,0, S_SWEEPWARN3}
states[S_SWEEPWARN3] = {SPR_WSWP,3|5<<FF_TRANSSHIFT,2,A_None,0,0, S_NULL}

-- SweepLine
freeslot("MT_SWEEP_LINE", "S_SWEEPLINE0", "S_SWEEPLINE1", "S_SWEEPLINE2", "S_SWEEPLINE3","SPR_SWPL")

mobjinfo[MT_SWEEP_LINE] = {
	doomednum = -1,
	spawnhealth = 8,
	spawnstate = S_SWEEPLINE0,
	speed = 8,
	radius = 32*FRACUNIT,
	height = 32*FRACUNIT,
	damage = 28*FRACUNIT,
	mass = 0,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOBLOCKMAP
}
states[S_SWEEPLINE0] = {SPR_SWPL,0|5<<FF_TRANSSHIFT,2,A_Explode,0,0, S_SWEEPLINE1}
states[S_SWEEPLINE1] = {SPR_SWPL,1|5<<FF_TRANSSHIFT,2,A_Explode,0,0, S_SWEEPLINE2}
states[S_SWEEPLINE2] = {SPR_SWPL,2|5<<FF_TRANSSHIFT,2,A_Explode,0,0, S_SWEEPLINE3}
states[S_SWEEPLINE3] = {SPR_SWPL,3|5<<FF_TRANSSHIFT,2,A_Explode,0,0, S_NULL}
-----------------





local BOSS_HEALTH_FULL = 1130--old:1780--1680 --3500--1980
local BOSS_HEALTH_ATTACKENABLE = 700--old:1350--BOSS_HEALTH_FULL*2/3--1550
local BOSS_HEALTH_HALF = BOSS_HEALTH_FULL/2
local BOSS_HEALTH_DEFEAT = BOSS_HEALTH_FULL/(128/2)
-- (ENEMY | )
mobjinfo[MT_EXPSTAR] = {
	doomednum = mapthingNum("MT_EXPSTAR"),
	spawnhealth = BOSS_HEALTH_FULL,--100,--1000,
	spawnstate = S_FLORSIT0,
	-- Boss Properties
	--seestate = 0,
	attacksound = 0,
	seesound = sfx_none,
	activesound = 0,
	reactiontime = 100,
	painstate = S_FLORSIT0,
	painchance = 8,
	painsound = sfx_edmg2,
	--deathstate = S_,
	deathsound = sfx_edmg3,
	-------------------
	speed = 80*FRACUNIT,
	radius = 128*FRACUNIT,
	height = 128*FRACUNIT,
	damage = 0,
	mass = 10,
	flags = MF_SPECIAL|MF_SHOOTABLE|MF_NOGRAVITY|MF_BOSS
}
mobjinfo[MT_EXPSTAR].BOSS1_HEALTH_FULL = 1130
mobjinfo[MT_EXPSTAR].BOSS1_HEALTH_ATTACKENABLE = 700
mobjinfo[MT_EXPSTAR].BOSS1_HEALTH_DEFEAT = 1130/(128/2)
mobjinfo[MT_EXPSTAR].BOSS1_NET_HEALTH_FULL = 1780
mobjinfo[MT_EXPSTAR].BOSS1_NET_HEALTH_ATTACKENABLE = 1350
mobjinfo[MT_EXPSTAR].BOSS1_NET_HEALTH_DEFEAT = 1780/(128/2)
mobjinfo[MT_EXPSTAR].BOSS2_HEALTH_FULL = 1780
mobjinfo[MT_EXPSTAR].BOSS2_HEALTH_HALF = 890
mobjinfo[MT_EXPSTAR].BOSS2_HEALTH_DEFEAT = 1780/(128/2)
states[S_FLORSIT0] = {
        sprite = SPR_ZZZA,
        frame = 0,
        tics = -1
}
--[[
states[S_FLORSIT0] = {SPR_AAAA,0,1,A_None,0,0,S_FLORSIT0}]]

local function UBFLORALIS_SPAWNSETTING(mo)
	return function(mo)
		-- Update values based on game status
		--if (netgame) then
		--	mo.health = mo.info.BOSS1_NET_HEALTH_FULL
		--	mo.info.spawnhealth = mo.info.BOSS1_NET_HEALTH_FULL
		--	BOSS_HEALTH_FULL = mo.info.BOSS1_NET_HEALTH_FULL
		--	BOSS_HEALTH_ATTACKENABLE = mo.info.BOSS1_NET_HEALTH_ATTACKENABLE
		--	BOSS_HEALTH_HALF = BOSS_HEALTH_FULL/2
		--	BOSS_HEALTH_DEFEAT = BOSS_HEALTH_FULL/(128/2)
		--else
			mo.health = mo.info.BOSS1_HEALTH_FULL
			mo.info.spawnhealth = mo.info.BOSS1_HEALTH_FULL
			BOSS_HEALTH_FULL = mo.info.BOSS1_HEALTH_FULL
			BOSS_HEALTH_ATTACKENABLE = mo.info.BOSS1_HEALTH_ATTACKENABLE
			BOSS_HEALTH_HALF = BOSS_HEALTH_FULL/2
			BOSS_HEALTH_DEFEAT = BOSS_HEALTH_FULL/(128/2)
		--end
		if not mo.customsetting then
			mo.customsetting = {scale = -1}
		end
		if mo.events == nil then
			mo.events = {}
		end
		if not mo.hurtc then
			mo.hurtc = 0
		end
		if not mo.hpfill then
			mo.hpfill = {count = 0, steps = 24, enabled = false}
		end
		if not mo.nonvisibility then
			mo.nonvisibility = true
		end
		if not mo.trmap then
			--mo.trmap = 0<<FF_TRANSSHIFT
		end
	end
end
addHook("MobjSpawn", UBFLORALIS_SPAWNSETTING(), MT_EXPSTAR)

addHook("MobjDamage", function(mo, inflictor, source, damage)
	-- Hurt
	mo.hurtc = 3
	--print("hit")
	if (mo.flags & MF_SHOOTABLE) then
		--mo.health = $1-1
		local health_delay = 2
		--if mo.health % 2 then delay = 1 end
		if not mo.healthtimer or mo.healthtimer <= leveltime - health_delay then
			mo.healthtimer = leveltime
			mo.health = $1-1
		end
		--S_StartSoundAtVolume(nil, sfx_s3k3d, 16)
		--TODO: accurate hit sound
		local delay = 5
		--if mo.health % 2 then delay = 1 end
		if not mo.hittimer or mo.hittimer <= leveltime - delay then
			mo.hittimer = leveltime
			S_StartSoundAtVolume(nil, Snd("SE_KR_HIT1"), 48)
			--print(mo.health)
			--print("SECOND: "..BOSS_HEALTH_HALF)
			--print("!ENABLE: "..BOSS_HEALTH_ATTACKENABLE)
		end
	end
	mo.isDamaged = false
	return true
end, MT_EXPSTAR)











------------------------------------------------------------------------------------
-- ACTIONS
------------------------------------------------------------------------------------
local function strgn_MusicLoop(user, sound)
	if (mapheaderinfo[gamemap].starzone) then
		if (sound) then
			if (sound.BGM)
				for player in players.iterate do
					SOUND:PlayBGM(player, Snd(sound.BGM), true)
				end
			end
		end
	end
end

local function genesis_Teleport(mo, newLocation, properties)
	mo.flags = $1&~MF_SHOOTABLE
	SOUND:PlaySFX(nil, Snd("SE_EFF_VOCOUT"), 64)
	if properties and properties.dream then
		ACT:startSprAnim(mo, SPRITE("drm_WarpOut"), A, M, 2, false)
	elseif properties and properties.star then
		ACT:startSprAnim(mo, SPRITE("drm_R_WarpOut"), A, M, 2, false)
	else
		ACT:startSprAnim(mo, SPRITE("gns_WarpOut"), A, G, properties.speed, false)
	end
	P_SpawnGhostMobj(mo)
	mo.flags2 = $1|MF2_DONTDRAW
	mo.nonvisibility = true
	OBJECT:setPosition(mo, newLocation)
	wait(properties.waitTime or 0)
	mo.flags2 = $1&~MF2_DONTDRAW
	mo.nonvisibility = false
	P_SpawnGhostMobj(mo)
	SOUND:PlaySFX(nil, Snd("SE_EFF_VOCIN"), 64)
	if properties and properties.dream then
		ACT:startSprAnim(mo, SPRITE("drm_WarpIn"), A, M, 2, false)
	elseif properties and properties.star then
		ACT:startSprAnim(mo, SPRITE("drm_R_WarpIn"), A, M, 2, false)
	else
		ACT:startSprAnim(mo, SPRITE("gns_WarpIn"), A, G, properties.speed, false)
	end
	mo.flags = $1|MF_SHOOTABLE
end

local function genesis_MinorHitShake()
	local MajorHitShake = TASK:Regist(function()
		for i=0,6,1 do
			P_StartQuake(12*FRACUNIT, 1, {0, 0, 0}, 0)
			wait(1)
		end
	end)
end

local function genesis_MajorHitShake()
	local MajorHitShake = TASK:Regist(function()
		for i=0,8,1 do
			P_StartQuake(32*FRACUNIT, 1, {0, 0, 0}, 0)
			wait(1)
		end
	end)
end

local function ShootPlayersFromSpotsRandomly(spots, missile_type, shots, wait_time)
	local targets = {}
	local plist = {}

	while #plist < #spots do
		for player in players.iterate do
			if player.mo and not (player.playerstate == PST_DEAD) then
				table.insert(plist, P_RandomKey(#plist)+1, player)
			end
		end
		-- failsafe to at least avoid freezing
		if #plist == 0 then
			-- if nobody is around, fire at nothing
			for dummies = 0, #spots do
				local Object = {}
				Object.mo = OBJECT:CreateNew(MT_PUSH, {x = maplocation("PLAYER_SPAWNPOINT").x, y = maplocation("PLAYER_SPAWNPOINT").y, z = maplocation("PLAYER_SPAWNPOINT").z+32*FRACUNIT})
				Object.mo.fuse = 10*TICRATE
				table.insert(plist, P_RandomKey(#plist)+1, Object)
			end
		end
		--if #plist == 0 then error("no players?") end
	end

	--table.sort(plist, function(a, b) return P_SignedRandom() < 0 end)

	for i = 1, #spots do
		local pmo = plist[i].mo
		targets[i] = P_SpawnMobj(pmo.x, pmo.y, pmo.z, MT_ALTVIEWMAN)
	end

	-->Attack Here<--
	for i=1, shots do
		for j = 1, #spots do
			SOUND:PlaySFX(nil, Snd("SE_EFF_STARFIRE"), 6)
			SOUND:PlaySFX(nil, sfx_rlaunc, 8)
			P_SpawnMissile(spots[j], targets[j], missile_type)
		end
		wait(wait_time)
	end

	for _,t in pairs(targets) do
		P_RemoveMobj(t)
	end
end

local function star_CreateSynthPoints()
	local p1 = OBJECT:CreateNew(MT_ALTVIEWMAN, maplocation("MT_SYNTHPOINT1"))
	local p2 = OBJECT:CreateNew(MT_ALTVIEWMAN, maplocation("MT_SYNTHPOINT2"))
	local p3 = OBJECT:CreateNew(MT_ALTVIEWMAN, maplocation("MT_SYNTHPOINT3"))
	local p4 = OBJECT:CreateNew(MT_ALTVIEWMAN, maplocation("MT_SYNTHPOINT4"))
	local p5 = OBJECT:CreateNew(MT_ALTVIEWMAN, maplocation("MT_SYNTHPOINT5"))
	local p6 = OBJECT:CreateNew(MT_ALTVIEWMAN, maplocation("MT_SYNTHPOINT6"))
	local p7 = OBJECT:CreateNew(MT_ALTVIEWMAN, maplocation("MT_SYNTHPOINT7"))
	return p1, p2, p3, p4, p5, p6, p7
end

local function star_RemoveSynthPoints(s_points)
	for _,v in pairs(s_points)
		P_RemoveMobj(v)
	end
end

local function DestroyAllEventsInStorage(ev)
for _,v in pairs(ev)
		TASK:Destroy(v)
	end
	ev = {}
end


local function genesis_createStarPort(mo, ...)
	local args = {...}
	local rets = {}
	for k,v in ipairs(args) do
		table.insert(rets, OBJECT:CreateNew(v.obj, v.loc, {v.id} or nil))
	end
		OBJECT:setgroupscale(rets, 0)
		mo.events["genesis_MINEMOVE_A"] = TASK:Regist(function()
			waitForSignal("MINEMOVE_A_READY")
			--print("MINEMOVE_A: READY?")
			local retmines = {}
			local retpoints = {}
			for _,mv in ipairs(args) do
				table.insert(retmines, OBJECT:CreateNew(mv.mine.obj, {x = mv.mine.loc.x,y = mv.mine.loc.y,z = mv.mine.loc.z-64*FRACUNIT}, {mv.id} or nil))
				table.insert(retpoints, mv.mine.points)
			end
			OBJECT:setgroupscale(retmines, 0)
			waitForSignal("MINEMOVE_A_GO")
			--print("MINEMOVE_A: GO!")
			OBJECT:setgroupscale(retmines, 1*FRACUNIT, FloatFixed("0.05"))
			for index, mine in ipairs(retmines) do
				if mine and mine.valid then --[[...]] else break end
				mine.events["minemove"] = TASK:Regist(function()
					mine.angle = ANGLE_270
					mine.color = SKINCOLOR_CYAN
					--mine.state = S_MINESOARER_1
					--wait(35)
					for i=1, #retpoints[index] do
						if mine and mine.valid then --[[...]] else break end
						mine.events["GhostTrail"] = TASK:Regist(function()
							while true do
								if mine and mine.valid then --[[...]] else break end
								if (mine.fuse == 1) then break end
								P_SpawnGhostMobj(mine)
								wait(0)
							end
						end)
						--mine.momz =  maplocation("PLAYER_SPAWNPOINT").z - mine.z
						--OBJECT:moveTo(mine, retpoints[index][i].loc,
						--	retpoints[index][i].loc.speed or 32*FRACUNIT,
						--	{arc = retpoints[index][i].loc.arc} or {arc = {x = 0, y = 0, z = 0}})
						S_StartSoundAtVolume(nil, sfx_s3k47, 100)
						OBJECT:moveTo(mine, retpoints[index][i].loc,
							32*FRACUNIT,
							{tween = {0,FRACUNIT}, arc = {x = 0, y = 0, z = 0}})

					end
					wait(1)
					OBJECT:DestroyObjects({wp1a, wp2a}, true)
					wait(15)
					S_StartSoundAtVolume(nil, sfx_ptally, 100)
					S_StartSoundAtVolume(nil, sfx_ptally, 100)
					if mine and mine.valid then
						mine.color = SKINCOLOR_RED
						mine.frame = A
					end
					wait(15)
					if mine and mine.valid then
						--if not (mine.state == S_MINESOARER_DEAD) then
							--OBJECT:showobject(mine, false)
							--TASK:Destroy(mine.events["GhostTrail"])
							local kex = OBJECT:CreateNew(MT_KEXPLODE, mine)
							OBJECT:setscale(kex, 2*FRACUNIT)
							S_StartSoundAtVolume(nil, Snd("SE_KR_EXPLODE1S"), 100)
							wait(2)
							OBJECT:DestroyObjects(rets, true)
							OBJECT:DestroyObjects(retpoints, true)
							--OBJECT:DestroyObjects({wp1a, wp2a}, true)
							if mine and mine.valid then
								mine.fuse = 1
							end
							--mine.state = S_MINESOARER_DEAD
						--end
						--TASK:Destroy(mine.events["minemove"])
					end
				end)
			end
		end)
	signal("MINEMOVE_A_READY")
	wait(2)
	OBJECT:setgroupscale(rets, 3*FRACUNIT, FloatFixed("0.09"))
	wait(64)
	signal("MINEMOVE_A_GO")
	OBJECT:setgroupscale(rets, 0, FloatFixed("0.09"))

	wait(15)
end

local function genesis_AbsorbParticle(mo, amount, bound)
	for i = 0,amount, 1
		--wait(2)
		local particle = P_SpawnMobj(
					mo.x+P_RandomRange(-512,512)*FRACUNIT,
					mo.y+P_RandomRange(-512, -256)*FRACUNIT,
					mo.z+P_RandomRange(512,-512)*FRACUNIT, MT_THOK)
		particle.color = 14
		particle.frame = 0|(8<<FF_TRANSSHIFT)
		local Absorb = TASK:Regist(function()
			wait(0)
			OBJECT:moveTo(particle, mo, 32*FRACUNIT)
		end)
		wait(0)
	end
end

local function genesis_FireSolarBeam(mo, fireStart, fireEnd)
	local function CameraOUT()
		OBJECT:moveTo(server.mo.cam, {x = 0*FRACUNIT, y = -420*FRACUNIT, z = 0*FRACUNIT, angle = ANGLE_90}, 32*FRACUNIT)
	end
	local function CameraReset()
		for player in players.iterate do
			player.awayviewmobj = player.mo.cam
			CAMERA:SetEye(server, maplocation("MAINFIELD_VIEWPOINT"), 0)
			CAMERA:UnsetEye(server, 0)
			OBJECT:setPosition(server.mo.cam, maplocation("MAINFIELD_VIEWPOINT"))
			CAMERA:override(player, false)
		end
	end
	--local function FIRESOLARBEAM()
	local FIRESOLARBEAM = TASK:Regist(function()
		local ABSORPTION = TASK:Regist(function()
			genesis_AbsorbParticle(mo, 3*TICRATE)
		end)
		wait(3*TICRATE)
		SOUND:PlaySFX(nil, Snd("SE_KR_LASERFIREA"), 100)
		local CameraOUT_RUN = TASK:Regist(CameraOUT)
		local AIM_OBJECT = OBJECT:CreateNew(MT_ALTVIEWMAN, fireStart)
		local FIRE = TASK:Regist(function()
			for i=0,6*TICRATE do
				if (mo.EVENTSTATE == "DEAD") then
					break
				end
				P_StartQuake(4*FRACUNIT, 1, {0, 0, 0},0)
				local crackle = P_SpawnMobj(
					mo.x+P_RandomRange(-420,420)*FRACUNIT,
					mo.y+16*FRACUNIT,
					mo.z+P_RandomRange(-420,420)*FRACUNIT, MT_YLW_CRACKLE)
				crackle.color = P_RandomRange(5,25)
				crackle.scale = P_RandomRange(1/2, 2)*FRACUNIT
				crackle.momy = -128*FRACUNIT -- Revert if Lagged (*)(16)
				P_SpawnXYZMissile(mo, AIM_OBJECT, MT_YLW_ORB , mo.x, mo.y, mo.z)
					for i=1, #LineList do
						local line = LineList[i]
						-- ABSORPTION
						if line.tag == 5050
							line.frontside.textureoffset = $1 + 32*FRACUNIT
						end
						if line.tag == 5051
							line.frontside.textureoffset = $1 - 32*FRACUNIT
						end
						if line.tag == 5052
							line.frontside.textureoffset = $1 + 16*FRACUNIT
						end
						if line.tag == 5053
							line.frontside.textureoffset = $1 - 16*FRACUNIT
						end
						--UNIVERSE Wave
						if line.tag == 5080
							line.backside.textureoffset = $1 - 128*FRACUNIT
						end
						if line.tag == 5081
							line.backside.textureoffset = $1 + 128*FRACUNIT
						end
					end
				wait(0)
			end

			OBJECT:moveTo(server.mo.cam, maplocation("MAINFIELD_VIEWPOINT"), 4*FRACUNIT)
			P_RemoveMobj(AIM_OBJECT)
			local CameraReset_RUN = TASK:Regist(CameraReset)
		end)
		wait(35)
		OBJECT:moveTo(AIM_OBJECT, fireEnd, 12*FRACUNIT, {tween = {FixedMul(FloatFixed("0.78"),FloatFixed("0.21")), FixedMul(FloatFixed("0.0"),FloatFixed("0.9"))}})
	end)
	--local FIRESOLARBEAM_RUN = TASK:Regist(FIRESOLARBEAM)
end

local function genesis_FireMultiSolarBeam(mo, ...)
	local args = {...}
	local rets = {}

	local function CameraOUT()
		OBJECT:moveTo(server.mo.cam, {x = 0*FRACUNIT, y = -420*FRACUNIT, z = 0*FRACUNIT, angle = ANGLE_90}, 32*FRACUNIT)
	end
	local function CameraReset()
		for player in players.iterate do
			player.awayviewmobj = player.mo.cam
			CAMERA:SetEye(server, maplocation("MAINFIELD_VIEWPOINT"), 0)
			CAMERA:UnsetEye(server, 0)
			OBJECT:setPosition(server.mo.cam, maplocation("MAINFIELD_VIEWPOINT"))
			CAMERA:override(player, false)
		end
	end
	local FIRESOLARBEAM = TASK:Regist(function()
		local ABSORPTION = TASK:Regist(function()
			genesis_AbsorbParticle(mo, 3*TICRATE)
		end)
		wait(3*TICRATE)
		SOUND:PlaySFX(nil, Snd("SE_KR_LASERFIREA"), 100)
		-- Pass Scroll Once
		local LineSc = TASK:Regist(function()
			for i=0,6*TICRATE do
				for i=1, #LineList do
					local line = LineList[i]
					-- ABSORPTION
					if line.tag == 5050
						line.frontside.textureoffset = $1 + 32*FRACUNIT
					end
					if line.tag == 5051
						line.frontside.textureoffset = $1 - 32*FRACUNIT
					end
					if line.tag == 5052
						line.frontside.textureoffset = $1 + 16*FRACUNIT
					end
					if line.tag == 5053
						line.frontside.textureoffset = $1 - 16*FRACUNIT
					end
					--UNIVERSE Wave
					if line.tag == 5080
						line.backside.textureoffset = $1 - 128*FRACUNIT
					end
					if line.tag == 5081
						line.backside.textureoffset = $1 + 128*FRACUNIT
					end
				end
				wait(0)
			end
			OBJECT:moveTo(server.mo.cam, maplocation("MAINFIELD_VIEWPOINT"), 4*FRACUNIT)
			local CameraReset_RUN = TASK:Regist(CameraReset)
		end)
		local CameraOUT_RUN = TASK:Regist(CameraOUT)
		for k,v in ipairs(args) do
			local AIM_OBJECT = OBJECT:CreateNew(MT_ALTVIEWMAN, v.fireStart)
			local FIRE = TASK:Regist(function()
				for i=0,6*TICRATE do
					P_StartQuake(4*FRACUNIT, 1, {0, 0, 0},0)
					local crackle = P_SpawnMobj(
						mo.x+P_RandomRange(-420,420)*FRACUNIT,
						mo.y+16*FRACUNIT,
						mo.z+P_RandomRange(-420,420)*FRACUNIT, MT_YLW_CRACKLE)
					crackle.color = P_RandomRange(5,25)
					crackle.scale = P_RandomRange(1/2, 2)*FRACUNIT
					P_SpawnXYZMissile(mo, AIM_OBJECT, MT_YLW_ORB , mo.x, mo.y, mo.z)

					wait(0)
				end
				P_RemoveMobj(AIM_OBJECT)
			end)
			local MOVE = TASK:Regist(function()
			wait(35)
			OBJECT:moveTo(AIM_OBJECT, v.fireEnd, 12*FRACUNIT, {tween = {FixedMul(FloatFixed("0.78"),FloatFixed("0.21")), FixedMul(FloatFixed("0.0"),FloatFixed("0.9"))}})
			end)
		end
	end)
end

local function genesis_execQuickSynth(mo, ...)
	local args = {...}
	local rets = {}
	for k,v in ipairs(args) do
		table.insert(rets, OBJECT:CreateNew(MT_ALTVIEWMAN, v.loc, {v.id} or nil))
	end

	ACT:startSprAnim(mo, SPRITE("gns_SynthesisExecute"), A, G, 2, false)
	SOUND:PlaySFX(nil, Snd("SE_KR_LAS2"), 90)

	local holerets = {}
	for _,v in ipairs(args) do
		table.insert(holerets, OBJECT:CreateNew(MT_STARHOLE, v.loc, {v.id} or nil))
	end
	OBJECT:setgroupscale(holerets, 0)
	OBJECT:setgroupscale(holerets, 2*FRACUNIT/2, FloatFixed("0.09"))
	-->Attack Here<--
	local Fire = TASK:Regist(function()
		ShootPlayersFromSpotsRandomly(rets, MT_STARHOLE_BULLET, 8, 1)
		OBJECT:setgroupscale(holerets, 0, FloatFixed("0.06"))
		OBJECT:DestroyObjects(rets)
	end)
	--TASK:Destroy(Fire)
end





-------------------
-- DREAM ACTIONS
-------------------
local function dream_CleanupTrash()
	-- If srb2 won't clean up the trash, I'll do it myself.
	for mobj in mobjs.iterate()
		if ((mobj and mobj.valid) and (mobj.type == MT_ALTVIEWMAN or mobj.type == MT_STARHOLE or mobj.type == MT_MINESOARER or mobj.type == MT_PUSH))
			if (mobj.events) then
				mobj.events = {}
			end
			--OBJECT:CreateNew(MT_KEXPLODE, mobj)
			mobj.fuse = 5
			--P_RemoveMobj(mobj)
		end
		if ((mobj and mobj.valid) and (mobj.type == MT_STARHOLE and mobj.extrainfo == 8))
			--mobj.state = S_STARHOLE_ENDSPAWNER
			--OBJECT:setscale(mobj, 0, FloatFixed("0.1"))
		end
	end
end

local function dream_execFire(mo, ...)
	local args = {...}
	local rets = {}
	for k,v in ipairs(args) do
		table.insert(rets, OBJECT:CreateNew(MT_PUSH, v.loc, {v.id} or nil))
	end

	SOUND:PlaySFX(nil, sfx_s3k92, 90)
	SOUND:PlaySFX(nil, sfx_s3k9c, 90)
	--SOUND:PlaySFX(nil, Snd("SE_KR_LAS2"), 90)

	local holerets = {}
	for _,v in ipairs(args) do
		table.insert(holerets, OBJECT:CreateNew(MT_STARHOLE, v.loc, {v.id} or nil))
	end
	OBJECT:setgroupscale(holerets, 0)
	OBJECT:setgroupscale(holerets, 2*FRACUNIT/2, FloatFixed("0.09"))
	-->Attack Here<--
	local Fire = TASK:Regist(function()
		ShootPlayersFromSpotsRandomly(rets, MT_STARHOLE_BULLET, 8, 1)
		wait(10)
		OBJECT:setgroupscale(holerets, 0, FloatFixed("0.06"))
		for _,v in ipairs(rets) do
			OBJECT:Destroy(v, 1)
		end
		for _,v in ipairs(holerets) do
			OBJECT:Destroy(v, 1)
		end
		--OBJECT:DestroyObjects(rets, true)
		--OBJECT:DestroyObjects(holerets, true)
	end)
	--TASK:Destroy(Fire)
end

local function dream_ph2_DreamFire1(mo, repeatTimes)
	local STAR_GEN = mo
	--local camera = server.mo.cam
	local newLocation = {}
	local randSpotHorz = 0
	local randSpotVert = 0
	local DreamFire_Move = (function()
		if not (mo.EVENTSTATE == "PAUSED") then
			dream_execFire(mo, {loc = {x = P_RandomRange(-320, 320)*FRACUNIT, y = 720*FRACUNIT, z = P_RandomRange(-400, 400)*FRACUNIT}})
		end
		wait(25)
		if not (mo.EVENTSTATE == "PAUSED") then
			dream_execFire(mo, {loc = {x = P_RandomRange(-320, 320)*FRACUNIT, y = 720*FRACUNIT, z = P_RandomRange(-400, 400)*FRACUNIT}})
		end
		wait(25)
		if not (mo.EVENTSTATE == "PAUSED") then
			dream_execFire(mo, {loc = {x = P_RandomRange(-320, 320)*FRACUNIT, y = 720*FRACUNIT, z = P_RandomRange(-400, 400)*FRACUNIT}})
		end
		wait(25)
		if not (mo.EVENTSTATE == "PAUSED") then
			dream_execFire(mo, {loc = {x = P_RandomRange(-320, 320)*FRACUNIT, y = 720*FRACUNIT, z = P_RandomRange(-400, 400)*FRACUNIT}})
		end
	end)
	for RepeatTimes = 1, repeatTimes or 3 do
		ACT:startSprAnim(STAR_GEN, SPRITE("drm_IdleStill"), A, G, 6, 2*TICRATE)
		SOUND:PlaySFX(nil, sfx_s3ka0, 100)
		SOUND:PlaySFX(nil, sfx_s3k8c, 100)
		ACT:startSprAnim(STAR_GEN, SPRITE("drm_StarShooting"), A, G, 3)
		local DreamFire_Move_tsk = TASK:Regist(DreamFire_Move)
		ACT:startSprAnim(STAR_GEN, SPRITE("drm_IdleStill"), A, G, 6, 1*TICRATE)
		randSpotHorz = P_RandomRange(-450, 450)
		randSpotVert = P_RandomRange(-256, 256)
		newLocation = {x = randSpotHorz*FRACUNIT, y = 832*FRACUNIT, z = randSpotVert*FRACUNIT, angle = ANGLE_90}
		genesis_Teleport(mo, newLocation, {speed = 1, waitTime = 18, dream = true})
		dream_CleanupTrash()
	end
end

local function dream_ph2_CloseupIdle(mo)
	local STAR_GEN = mo
	--local camera = server.mo.cam
	local newLocation = {}
	local randSpotHorz = 0
	local randSpotVert = 0
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_IdleStill"), A, G, 6)
	randSpotHorz = P_RandomRange(-450, 450)
	randSpotVert = P_RandomRange(-256, 256)
	newLocation = {x = randSpotHorz*FRACUNIT, y = 832*FRACUNIT, z = randSpotVert*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {waitTime = 18, dream = true})
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_IdleStill"), A, G, 6)
	randSpotHorz = P_RandomRange(-450, 450)
	randSpotVert = P_RandomRange(-256, 256)
	newLocation = {x = randSpotHorz*FRACUNIT, y = 832*FRACUNIT, z = randSpotVert*FRACUNIT, angle = ANGLE_90}
	local Overlay = OBJECT:CreateNew(MT_STARGENESIS_PULL, {x = STAR_GEN.x, y = STAR_GEN.y-256*FRACUNIT, z = STAR_GEN.z}, param)
	local BigOverlay = TASK:Regist(function()
		wait(50)
		OBJECT:showobject(STAR_GEN, false)
		while true do
			if (mo.EVENTSTATE == "PAUSED") then
				OBJECT:setscale(Overlay, 1*FRACUNIT, FRACUNIT)
				Overlay.fuse = 1
				break
			end
			Overlay.sprite = STAR_GEN.sprite
			Overlay.frame = STAR_GEN.frame
			Overlay.color = STAR_GEN.color
			Overlay.scale = 10*FRACUNIT
			-- failsafe to destroy overlay
			if not (Overlay.dreamBigOverlay) then
				Overlay.dreamBigOverlay = 1
			end
			OBJECT:setPosition(Overlay, STAR_GEN)
			if (STAR_GEN.nonvisibility == true) then break end
			wait(0)
		end
		OBJECT:Destroy(Overlay, 1)
		--print("overlay done")
	end)
	genesis_Teleport(mo, newLocation, {waitTime = 18, dream = true})
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_IdleStill"), A, G, 6)
	newLocation = {x = maplocation("GNS_SPAWNPOINT").x, y = maplocation("GNS_SPAWNPOINT").y, z = maplocation("GNS_SPAWNPOINT").z, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {waitTime = 18, dream = true})
end

local function dream_ph2_DreamRift(mo, repeatTimes, waitingTime)
	local STAR_GEN = mo
	--local camera = server.mo.cam
	local newLocation = {}
	local randSpotHorz = 0
	local randSpotVert = 0
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_IdleStill"), A, G, 6)
	SOUND:PlaySFX(nil, sfx_s3ka0, 100)
	SOUND:PlaySFX(nil, sfx_s3k8c, 100)
	SOUND:PlaySFX(nil, sfx_s3k9a, 100)
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_AnyAction2"), A, M, 2)
	local dream_TempRemoveFromField = TASK:Regist(function()
		newLocation = {x = maplocation("GNS_SPAWNPOINT").x, y = maplocation("GNS_SPAWNPOINT").y, z = maplocation("GNS_SPAWNPOINT").z, angle = ANGLE_90}
		genesis_Teleport(mo, newLocation, {waitTime = waitingTime or 18*TICRATE, dream = true})
		signal("DoneWithTrackerObjects")
	end)
	for RiftRepeatTimes = 1, repeatTimes or 5 do
		local randStartSpotHorz = P_RandomRange(-450, 450)
		local randStartSpotVert = P_RandomRange(-256, 256)
		local randPreSpotHorz = P_RandomRange(-320, 320)
		local randPreSpotVert = P_RandomRange(-128, 128)
		local randSpotHorz_dest = P_RandomRange(-256, 256)
		local randSpotVert_dest = P_RandomRange(-128, 128)
		local randSpotHorz_dest2 = P_RandomRange(-256, 256)
		local randSpotVert_dest2 = P_RandomRange(-128, 128)
		S_StartSoundAtVolume(nil, sfx_s3k95, 100)
		genesis_createStarPort(mo, {obj = MT_STARHOLE, loc = {x = randStartSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y-480*FRACUNIT, z = randStartSpotVert*FRACUNIT},
			mine = {obj = MT_MINESOARER, loc = {x = randStartSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y-480*FRACUNIT, z = randStartSpotVert*FRACUNIT},
			points = {
				{obj = MT_ALTVIEWMAN, loc = {x = randPreSpotHorz*FRACUNIT, y = 420*FRACUNIT, z = randPreSpotVert*FRACUNIT, angle = ANGLE_90, speed = 8*FRACUNIT, arc = {z = -2*FRACUNIT}}},
				{obj = MT_ALTVIEWMAN, loc = {x = randSpotHorz_dest*FRACUNIT, y = maplocation("PLAYER_SPAWNPOINT").y, z = randSpotVert_dest, angle = ANGLE_90, speed = 2*FRACUNIT}}
			}},
		},
		{obj = MT_STARGENESIS_PULL, loc = {x = randStartSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y-480*FRACUNIT, z = randStartSpotVert*FRACUNIT},
			mine = {obj = MT_MINESOARER, loc = {x = randStartSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y-480*FRACUNIT, z = randSpotVert*FRACUNIT},
			points = {
				{obj = MT_ALTVIEWMAN, loc = {x = randPreSpotHorz*FRACUNIT, y = 420*FRACUNIT, z = randPreSpotVert*FRACUNIT, angle = ANGLE_90, speed = 8*FRACUNIT, arc = {z = -2*FRACUNIT}}},
				{obj = MT_ALTVIEWMAN, loc = {x = randSpotHorz_dest2*FRACUNIT, y = maplocation("PLAYER_SPAWNPOINT").y, z = randSpotVert_dest2*FRACUNIT, angle = ANGLE_90, speed = 2*FRACUNIT}}
			}},
		})
		wait(35)
	end
	waitForSignal("DoneWithTrackerObjects")
	dream_CleanupTrash()
end


local function dream_ph2_ZapRift_Horz(mo, repeatTimes)
	local STAR_GEN = mo
	--local camera = server.mo.cam
	local newLocation = {}
	local randSpotHorz = 0
	local randSpotVert = 0
	for RepeatZapLineTimes = 1, repeatTimes or 5 do
		local StartHorz = P_RandomChoice({-1, 1})--P_RandomRange(-1, 1)
		local StartVert = P_RandomChoice({-55, 55})--P_RandomRange(-1, 1)
		--StartHorz = ternary(StartHorz == 0, 1, -1)
		--StartVert = ternary(StartVert == 0 or StartVert == 1, 55, -55)
		local ZapLine_Source = OBJECT:CreateNew(MT_STARGENESIS_PULL, {x = maplocation("PLAYER_SPAWNPOINT").x-700*FRACUNIT*StartHorz, y = maplocation("PLAYER_SPAWNPOINT").y+500*FRACUNIT, z = maplocation("GNS_SPAWNPOINT").z+StartVert*FRACUNIT})
		local ZapLine_trgt = OBJECT:CreateNew(MT_STARGENESIS_PULL, {x = maplocation("PLAYER_SPAWNPOINT").x+700*FRACUNIT*StartHorz, y = maplocation("PLAYER_SPAWNPOINT").y+500*FRACUNIT, z = maplocation("GNS_SPAWNPOINT").z+StartVert*FRACUNIT})
		wait(1)
		OBJECT:setAngle(ZapLine_Source, ANGLE_90)
		SOUND:PlaySFX(nil, Snd("SE_KR_LASERFIREA"))
		P_StartQuake(32*FRACUNIT, 5)
		local FireZapLine = TASK:Regist(function()
			while true do
				if (mo.EVENTSTATE == "PAUSED") then
					break
				end
				local missile = P_SpawnXYZMissile(ZapLine_Source, ZapLine_trgt, MT_YLW_ORB, ZapLine_Source.x, ZapLine_Source.y, ZapLine_Source.z)
				if missile and missile.valid then missile.scale = FloatFixed("0.9") end
				ZapLine_Source.momy = -10*FRACUNIT
				ZapLine_Source.fuse = 3*TICRATE
				ZapLine_trgt.fuse = 3*TICRATE
				ZapLine_trgt.momy = -15*FRACUNIT
				wait(0)
			end
		end)
		wait(25)
	end
end

local function dream_ph2_ZapRift_HorzVert(mo, repeatTimes)
	local STAR_GEN = mo
	--local camera = server.mo.cam
	local newLocation = {}
	local randSpotHorz = 0
	local randSpotVert = 0
	local VerticalZapLine = TASK:Regist(function()
		for RepeatZapLineTimes = 1, repeatTimes or 5 do
			local StartHorz = P_RandomRange(-1, 1)
			StartHorz = P_RandomChoice({-128, 128})
			local ZapLine_Source = OBJECT:CreateNew(MT_STARGENESIS_PULL, {x = maplocation("PLAYER_SPAWNPOINT").x+StartHorz*FRACUNIT, y = maplocation("PLAYER_SPAWNPOINT").y+500*FRACUNIT, z = 1000*FRACUNIT})
			--local ZapLine_trgt = OBJECT:CreateNew(MT_STARGENESIS_PULL, {x = maplocation("PLAYER_SPAWNPOINT").x+StartHorz*FRACUNIT, y = maplocation("PLAYER_SPAWNPOINT").y+500*FRACUNIT, z = -700*FRACUNIT})
			wait(1)
			--SOUND:PlaySFX(nil, Snd("SE_KR_LASERFIREA"))
			P_StartQuake(32*FRACUNIT, 5)
			local FireZapLine = TASK:Regist(function()
				while true do
					if (mo.EVENTSTATE == "PAUSED") then
						break
					end
					local missile = P_SpawnMobj(ZapLine_Source.x, ZapLine_Source.y, ZapLine_Source.z, MT_YLW_ORB)--P_SpawnXYZMissile(ZapLine_Source, ZapLine_trgt, MT_YLW_ORB, ZapLine_Source.x, ZapLine_Source.y, ZapLine_Source.z)
					if missile and missile.valid then
						missile.flags = $1|MF_MISSILE|MF_NOGRAVITY
						missile.scale = FloatFixed("0.7")
						missile.momz = -128*FRACUNIT
						missile.fuse = 5*TICRATE
					end
					ZapLine_Source.sprite = SPR_SHLE
					ZapLine_Source.frame = A
					ZapLine_Source.momy = -10*FRACUNIT
					ZapLine_Source.fuse = 5*TICRATE
					--ZapLine_trgt.fuse = 5*TICRATE
					--ZapLine_trgt.momy = -10*FRACUNIT
					wait(0)
				end
			end)
			wait(25)
		end
	end)
	for RepeatHorzZapLineTimes = 1, repeatTimes or 5 do
		local StartHorz = P_RandomChoice({-1, 1})
		local StartVert = P_RandomRange(-55, 55)

		local ZapLine_Source = OBJECT:CreateNew(MT_STARGENESIS_PULL, {x = maplocation("PLAYER_SPAWNPOINT").x-700*FRACUNIT*StartHorz, y = maplocation("PLAYER_SPAWNPOINT").y+500*FRACUNIT, z = maplocation("GNS_SPAWNPOINT").z+StartVert*FRACUNIT})
		local ZapLine_trgt = OBJECT:CreateNew(MT_STARGENESIS_PULL, {x = maplocation("PLAYER_SPAWNPOINT").x+700*FRACUNIT*StartHorz, y = maplocation("PLAYER_SPAWNPOINT").y+500*FRACUNIT, z = maplocation("GNS_SPAWNPOINT").z+StartVert*FRACUNIT})
		wait(1)
		OBJECT:setAngle(ZapLine_Source, ANGLE_90)
		SOUND:PlaySFX(nil, Snd("SE_KR_LASERFIREA"))
		P_StartQuake(32*FRACUNIT, 5)
		local FireZapLine = TASK:Regist(function()
			while true do
				if (mo.EVENTSTATE == "PAUSED") then
					break
				end
				local missile = P_SpawnXYZMissile(ZapLine_Source, ZapLine_trgt, MT_YLW_ORB, ZapLine_Source.x, ZapLine_Source.y, ZapLine_Source.z)
				if missile and missile.valid then missile.scale = FloatFixed("0.7") end
				ZapLine_Source.momy = -10*FRACUNIT
				ZapLine_Source.fuse = 3*TICRATE
				ZapLine_trgt.fuse = 3*TICRATE
				ZapLine_trgt.momy = -15*FRACUNIT
				wait(0)
			end
		end)
		wait(25)
	end
end

local function dream_ph2_ZapRift_Distance(mo, repeatTimes)
	local STAR_GEN = mo
	local camera = server.mo.cam
	local newLocation = {}
	local randSpotHorz = 0
	local randSpotVert = 0

	--print("welcome to the next level")
	for SpawnRepeatTimes = 1, repeatTimes or 3 do
		if (mo.EVENTSTATE == "PAUSED") then
			break
		end
		randSpotHorz = P_RandomRange(-512, 512)
		randSpotVert = P_RandomRange(-128, 128)
		local StarRift = OBJECT:CreateNew(MT_STARHOLE, {x = maplocation("GNS_SPAWNPOINT").x+randSpotHorz*FRACUNIT, y = 640*FRACUNIT, z = maplocation("GNS_SPAWNPOINT").z+randSpotVert*FRACUNIT})
		OBJECT:setscale(StarRift, 0)
		SOUND:PlaySFX(nil, sfx_s3k79)
		OBJECT:setscale(StarRift, 2*FRACUNIT, FRACUNIT)
		randSpotHorz = P_RandomRange(-128, 128)
		randSpotVert = P_RandomRange(-128, 128)
		ACT:startSprAnim(STAR_GEN, SPRITE("drm_IdleStill"), A, G, 6, 1*TICRATE, true)
		for RepeatWarningTime = 1, 15 do
			local WarnCircle = OBJECT:CreateNew(MT_STARGENESIS_PULL, {x = maplocation("PLAYER_SPAWNPOINT").x+randSpotHorz*FRACUNIT, y = maplocation("PLAYER_SPAWNPOINT").y, z = maplocation("PLAYER_SPAWNPOINT").z+randSpotVert*FRACUNIT})
			WarnCircle.sprite = SPR_THOK
			WarnCircle.color = SKINCOLOR_RED
			WarnCircle.fuse = 1
			wait(1)
		end
		SOUND:PlaySFX(nil, Snd("SE_KR_LASERCHARGE"), 100)
		ACT:startSprAnim(STAR_GEN, SPRITE("drm_AnyAction3"), A, M, 2)
		SOUND:PlaySFX(nil, Snd("SE_KR_LASERFIREA"))
		P_StartQuake(32*FRACUNIT, 5)
		ACT:startSprAnim(STAR_GEN, SPRITE("drm_IdleStill"), A, G, 6, 2*TICRATE, true)
		--local dream_WaitOutAttack = TASK:Regist(function()
		--	ACT:startSprAnim(STAR_GEN, SPRITE("drm_IdleStill"), A, G, 6)
		--	signal("AttackFinished")
		--end)
		for LaserFireTime = 1, 1*TICRATE do
			if (mo.EVENTSTATE == "PAUSED") then
				break
			end
			local missile = P_SpawnPointMissile(StarRift, maplocation("PLAYER_SPAWNPOINT").x+randSpotHorz*FRACUNIT, maplocation("PLAYER_SPAWNPOINT").y, maplocation("PLAYER_SPAWNPOINT").z+randSpotVert*FRACUNIT, MT_YLW_ORB, StarRift.x, StarRift.y, StarRift.z)
			if missile and missile.valid then missile.scale = FloatFixed("0.7") end
			wait(0)
		end
		--waitForSignal("AttackFinished")
		OBJECT:setscale(StarRift, 0, FRACUNIT)
		StarRift.fuse = 35
	end
end

local function dream_ph2_BladeSweep(mo, repeatTimes, waitingTime)
	local STAR_GEN = mo
	local camera = server.mo.cam
	local newLocation = {}
	local randSpotHorz = 0
	local randSpotVert = 0

	local ShockWaveVibrate = TASK:Regist(function()
		wait(35)
		SOUND:PlaySFX(nil, sfx_s3k4e)
		P_StartQuake(32*FRACUNIT, 5)
		local DashShockWave = OBJECT:CreateNew(MT_STARGENESIS_PULL, STAR_GEN)
		DashShockWave.sprite = SPR_WAVC
		DashShockWave.frame = A
		DashShockWave.color = SKINCOLOR_BLACK
		OBJECT:setscale(DashShockWave, 32*FRACUNIT, 1*FRACUNIT)
		for transLevel = 2, 9 do
			if DashShockWave and DashShockWave.valid then --[[..]] else break end
			P_SpawnGhostMobj(DashShockWave)
			DashShockWave.frame = A|transLevel<<FF_TRANSSHIFT
			wait(1)
		end
		DashShockWave.fuse = 1
	end)
	SOUND:PlaySFX(nil, Snd("SE_KR_LASERCHARGE"), 100)
	local gns_AnimationLoop = TASK:Regist(function()
		ACT:startSprAnim(STAR_GEN, SPRITE("drm_BladeSpinStart"), A, M, 2)
		ACT:startSprAnim(STAR_GEN, SPRITE("drm_BladeSpin_LP"), A, I, 2)
		while true do
			if (mo.EVENTSTATE == "PAUSED") then
				break
			end
			ACT:startSprAnim(STAR_GEN, SPRITE("drm_BladeSpin_LP"), A, I, 1)
			wait(0)
		end
	end)
	OBJECT:moveTo(STAR_GEN, maplocation("GNS_SPINBLADEPOINT"), 22*FRACUNIT, {arc = {x = -1024*FRACUNIT, z = -128*FRACUNIT, y = -512*FRACUNIT}, tween = {0, FRACUNIT}})
	for RepeatZapLineTimes = 1, repeatTimes or 3 do
		local StartHorz = P_RandomChoice({-128, -64, 64, 128})*FRACUNIT
		local SpinFire_Source = OBJECT:CreateNew(MT_STARGENESIS_PULL, {x = maplocation("GNS_SPINBLADEPOINT").x+StartHorz, y = maplocation("GNS_SPINBLADEPOINT").y-500*FRACUNIT, z = maplocation("GNS_SPINBLADEPOINT").z+600*FRACUNIT})
		SpinFire_Source.fuse = 3*TICRATE
		SpinFire_Source.sprite = SPR_SHLE
		SpinFire_Source.momy = -32*FRACUNIT
		wait(1)
		OBJECT:setAngle(SpinFire_Source, ANGLE_90)
		SOUND:PlaySFX(nil, Snd("SE_KR_LASERFIREA"), 96)
		P_StartQuake(32*FRACUNIT, 5)
		local FireSpinFire = TASK:Regist(function()
			while true do
				if (mo.EVENTSTATE == "PAUSED") then
					break
				end
				if not SpinFire_Source.valid then break end
				local missile = P_SpawnMobj(SpinFire_Source.x+32*cos(SpinFire_Source.angle),
											SpinFire_Source.y+32*sin(SpinFire_Source.angle), SpinFire_Source.z, MT_YLW_ORB)
				if missile and missile.valid then
					missile.flags = $1|MF_MISSILE|MF_NOGRAVITY
					missile.scale = FloatFixed("0.7")
					missile.momz = -128*FRACUNIT
					missile.fuse = 5*TICRATE
				end
				local missileL = P_SpawnMobj(SpinFire_Source.x-32*cos(SpinFire_Source.angle),
											SpinFire_Source.y-32*sin(SpinFire_Source.angle), SpinFire_Source.z, MT_YLW_ORB)
				if missileL and missileL.valid then
					missileL.flags = $1|MF_MISSILE|MF_NOGRAVITY
					missileL.scale = FloatFixed("0.7")
					missileL.momz = -128*FRACUNIT
					missileL.fuse = 5*TICRATE
				end
				local Crackle = P_SpawnMobj(SpinFire_Source.x+P_RandomRange(-128, 128)*FRACUNIT,
											SpinFire_Source.y+P_RandomRange(-128, 128)*FRACUNIT, SpinFire_Source.z, MT_YLW_CRACKLE)
				SpinFire_Source.angle = FixedAngle(leveltime*FRACUNIT*8)
				wait(0)
			end
		end)
		wait(waitingTime or 25)
	end
	OBJECT:moveTo(STAR_GEN, maplocation("GNS_SPAWNPOINT"), 22*FRACUNIT, {arc = {x = 256*FRACUNIT, z = 128*FRACUNIT, y = 256*FRACUNIT}, tween = {0, FRACUNIT}})
	TASK:Destroy(gns_AnimationLoop)
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_BladeSpin_LP"), A, I, 2)
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_BladeSpinEnd"), A, I, 2)

end



-------------------
-- DREAM_R ACTION
-------------------

local function dream_r_CleanupTrash()
	-- If srb2 won't clean up the trash, I'll do it myself.
	for mobj in mobjs.iterate()
		if ((mobj and mobj.valid) and (mobj.type == MT_ALTVIEWMAN or mobj.type == MT_PUSH or mobj.type == MT_STARHOLE or mobj.type == MT_MINESOARER))
			if (mobj.events) then
				mobj.events = {}
			end
			OBJECT:CreateNew(MT_KEXPLODE, mobj)
			mobj.fuse = 1
			--P_RemoveMobj(mobj)
		end
	end
end

local function dream_r_ph2_DreamFire1(mo, repeatTimes)
	local STAR_GEN = mo
	--local camera = server.mo.cam
	local newLocation = {}
	local randSpotHorz = 0
	local randSpotVert = 0
	local DreamFire_Move = (function()
		dream_execFire(mo, {loc = {x = P_RandomRange(-320, 320)*FRACUNIT, y = 720*FRACUNIT, z = P_RandomRange(-400, 400)*FRACUNIT}})
		wait(15)
		dream_execFire(mo, {loc = {x = P_RandomRange(-320, 320)*FRACUNIT, y = 720*FRACUNIT, z = P_RandomRange(-400, 400)*FRACUNIT}})
		wait(15)
		dream_execFire(mo, {loc = {x = P_RandomRange(-320, 320)*FRACUNIT, y = 720*FRACUNIT, z = P_RandomRange(-400, 400)*FRACUNIT}})
		wait(15)
		dream_execFire(mo, {loc = {x = P_RandomRange(-320, 320)*FRACUNIT, y = 720*FRACUNIT, z = P_RandomRange(-400, 400)*FRACUNIT}})
		wait(15)
		dream_execFire(mo, {loc = {x = P_RandomRange(-320, 320)*FRACUNIT, y = 720*FRACUNIT, z = P_RandomRange(-400, 400)*FRACUNIT}})
		wait(15)
		dream_execFire(mo, {loc = {x = P_RandomRange(-320, 320)*FRACUNIT, y = 720*FRACUNIT, z = P_RandomRange(-400, 400)*FRACUNIT}})
		wait(15)
		dream_execFire(mo, {loc = {x = P_RandomRange(-320, 320)*FRACUNIT, y = 720*FRACUNIT, z = P_RandomRange(-400, 400)*FRACUNIT}})
		wait(15)
		dream_execFire(mo, {loc = {x = P_RandomRange(-320, 320)*FRACUNIT, y = 720*FRACUNIT, z = P_RandomRange(-400, 400)*FRACUNIT}})
	end)
	for RepeatTimes = 1, repeatTimes or 3 do
		ACT:startSprAnim(STAR_GEN, SPRITE("drm_R_IdleStill"), A, G, 6, 2*TICRATE)
		SOUND:PlaySFX(nil, sfx_s3ka0, 100)
		SOUND:PlaySFX(nil, sfx_s3k8c, 100)
		ACT:startSprAnim(STAR_GEN, SPRITE("drm_R_StarShooting"), A, G, 3)
		local DreamFire_Move_tsk = TASK:Regist(DreamFire_Move)
		ACT:startSprAnim(STAR_GEN, SPRITE("drm_R_IdleStill"), A, G, 6, 22)
		randSpotHorz = P_RandomRange(-450, 450)
		randSpotVert = P_RandomRange(-256, 256)
		newLocation = {x = randSpotHorz*FRACUNIT, y = 832*FRACUNIT, z = randSpotVert*FRACUNIT, angle = ANGLE_90}
		genesis_Teleport(mo, newLocation, {speed = 1, waitTime = 9, star = true})
		dream_CleanupTrash()
	end
end

local function dream_r_ph2_CloseupIdle(mo)
	local STAR_GEN = mo
	--local camera = server.mo.cam
	local newLocation = {}
	local randSpotHorz = 0
	local randSpotVert = 0
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_R_IdleStill"), A, G, 3)
	randSpotHorz = P_RandomRange(-450, 450)
	randSpotVert = P_RandomRange(-256, 256)
	newLocation = {x = randSpotHorz*FRACUNIT, y = 832*FRACUNIT, z = randSpotVert*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {waitTime = 9, star = true})
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_R_IdleStill"), A, G, 3)
	randSpotHorz = P_RandomRange(-450, 450)
	randSpotVert = P_RandomRange(-256, 256)
	newLocation = {x = randSpotHorz*FRACUNIT, y = 832*FRACUNIT, z = randSpotVert*FRACUNIT, angle = ANGLE_90}
	local Overlay = OBJECT:CreateNew(MT_STARGENESIS_PULL, {x = STAR_GEN.x, y = STAR_GEN.y-256*FRACUNIT, z = STAR_GEN.z}, param)
	local BigOverlay = TASK:Regist(function()
		wait(42)
		OBJECT:showobject(STAR_GEN, false)
		while true do
			if (mo.EVENTSTATE == "FINAL_DEAD") then
				OBJECT:setscale(Overlay, 1*FRACUNIT, FRACUNIT)
				Overlay.fuse = 1
				break
			end
			Overlay.sprite = STAR_GEN.sprite
			Overlay.frame = STAR_GEN.frame
			Overlay.color = STAR_GEN.color
			Overlay.scale = 10*FRACUNIT
			-- failsafe to destroy overlay
			if not (Overlay.dreamBigOverlay) then
				Overlay.dreamBigOverlay = 1
			end
			OBJECT:setPosition(Overlay, STAR_GEN)
			if (STAR_GEN.nonvisibility == true) then break end
			wait(0)
		end
		OBJECT:Destroy(Overlay, 1)
		--print("overlay done")
	end)
	genesis_Teleport(mo, newLocation, {waitTime = 9, star = true})
	SOUND:PlaySFX(nil, Snd("SE_EFF_DRM_R_VOICE01"), 95)
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_FaceReveal"), A, H, 2, 1*TICRATE/2)
	newLocation = {x = maplocation("GNS_SPAWNPOINT").x, y = maplocation("GNS_SPAWNPOINT").y, z = maplocation("GNS_SPAWNPOINT").z, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {waitTime = 9, star = true})
end

local function dream_r_ph2_DreamRift(mo, repeatTimes, waitingTime, riftTime, moveOn)
	local STAR_GEN = mo
	--local camera = server.mo.cam
	local newLocation = {}
	local randSpotHorz = 0
	local randSpotVert = 0
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_R_IdleStill"), A, G, 3)
	SOUND:PlaySFX(nil, sfx_s3ka0, 100)
	SOUND:PlaySFX(nil, sfx_s3k8c, 100)
	SOUND:PlaySFX(nil, sfx_s3k9a, 100)
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_R_AnyAction2"), A, M, 2)
	local dream_TempRemoveFromField = TASK:Regist(function()
		newLocation = {x = maplocation("GNS_SPAWNPOINT").x, y = maplocation("GNS_SPAWNPOINT").y, z = maplocation("GNS_SPAWNPOINT").z, angle = ANGLE_90}
		genesis_Teleport(mo, newLocation, {waitTime = waitingTime or 18*TICRATE, star = true})
		signal("DoneWithTrackerObjects")
	end)
	local RiftAttack = TASK:Regist(function()
		for RiftRepeatTimes = 1, repeatTimes or 5 do
			if (mo.EVENTSTATE == "FINAL_DEAD") then
				break
			end
			local randStartSpotHorz = P_RandomRange(-450, 450)
			local randStartSpotVert = P_RandomRange(-256, 256)
			local randPreSpotHorz = P_RandomRange(-320, 320)
			local randPreSpotVert = P_RandomRange(-128, 128)
			local randSpotHorz_dest = P_RandomRange(-256, 256)
			local randSpotVert_dest = P_RandomRange(-128, 128)
			local randSpotHorz_dest2 = P_RandomRange(-256, 256)
			local randSpotVert_dest2 = P_RandomRange(-128, 128)
			S_StartSoundAtVolume(nil, sfx_s3k95, 100)
			genesis_createStarPort(mo, {obj = MT_STARHOLE, loc = {x = randStartSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y-480*FRACUNIT, z = randStartSpotVert*FRACUNIT},
				mine = {obj = MT_MINESOARER, loc = {x = randStartSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y-480*FRACUNIT, z = randStartSpotVert*FRACUNIT},
				points = {
					{obj = MT_ALTVIEWMAN, loc = {x = randPreSpotHorz*FRACUNIT, y = 420*FRACUNIT, z = randPreSpotVert*FRACUNIT, angle = ANGLE_90, speed = 8*FRACUNIT, arc = {z = -2*FRACUNIT}}},
					{obj = MT_ALTVIEWMAN, loc = {x = randSpotHorz_dest*FRACUNIT, y = maplocation("PLAYER_SPAWNPOINT").y, z = randSpotVert_dest, angle = ANGLE_90, speed = 2*FRACUNIT}}
				}},
			},
			{obj = MT_STARGENESIS_PULL, loc = {x = randStartSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y-480*FRACUNIT, z = randStartSpotVert*FRACUNIT},
				mine = {obj = MT_MINESOARER, loc = {x = randStartSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y-480*FRACUNIT, z = randSpotVert*FRACUNIT},
				points = {
					{obj = MT_ALTVIEWMAN, loc = {x = randPreSpotHorz*FRACUNIT, y = 420*FRACUNIT, z = randPreSpotVert*FRACUNIT, angle = ANGLE_90, speed = 8*FRACUNIT, arc = {z = -2*FRACUNIT}}},
					{obj = MT_ALTVIEWMAN, loc = {x = randSpotHorz_dest2*FRACUNIT, y = maplocation("PLAYER_SPAWNPOINT").y, z = randSpotVert_dest2*FRACUNIT, angle = ANGLE_90, speed = 2*FRACUNIT}}
				}},
			})
			wait(riftTime or 35)
		end
	end)
	for RiftRepeatTimes = 1, repeatTimes or 5 do
		if (mo.EVENTSTATE == "FINAL_DEAD") then
			break
		end
		if moveOn then break end
		wait(0)
	end
	dream_CleanupTrash()
	waitForSignal("DoneWithTrackerObjects")
end


local function dream_r_ph2_ZapRift_Horz(mo, repeatTimes, delayTime)
	local STAR_GEN = mo
	--local camera = server.mo.cam
	local newLocation = {}
	local randSpotHorz = 0
	local randSpotVert = 0
	for RepeatZapLineTimes = 1, repeatTimes or 5 do
		local StartHorz = P_RandomChoice({-1, 1})--P_RandomRange(-1, 1)
		local StartVert = P_RandomChoice({-64, 64, 96})--P_RandomRange(-1, 1)
		--StartHorz = ternary(StartHorz == 0, 1, -1)
		--StartVert = ternary(StartVert == 0 or StartVert == 1, 55, -55)
		local ZapLine_Source = OBJECT:CreateNew(MT_PUSH, {x = maplocation("PLAYER_SPAWNPOINT").x-700*FRACUNIT*StartHorz, y = maplocation("PLAYER_SPAWNPOINT").y+500*FRACUNIT, z = maplocation("GNS_SPAWNPOINT").z+StartVert*FRACUNIT})
		local ZapLine_trgt = OBJECT:CreateNew(MT_PUSH, {x = maplocation("PLAYER_SPAWNPOINT").x+700*FRACUNIT*StartHorz, y = maplocation("PLAYER_SPAWNPOINT").y+500*FRACUNIT, z = maplocation("GNS_SPAWNPOINT").z+StartVert*FRACUNIT})
		ZapLine_Source.fuse = 5*TICRATE
		ZapLine_trgt.fuse = 5*TICRATE
		wait(1)
		OBJECT:setAngle(ZapLine_Source, ANGLE_90)
		SOUND:PlaySFX(nil, Snd("SE_KR_LASERFIREA"), 95)
		P_StartQuake(32*FRACUNIT, 5)
		local FireZapLine = TASK:Regist(function()
			while true do
				if (mo.EVENTSTATE == "FINAL_DEAD") then
					break
				end
				if not ZapLine_Source.valid then break end
				local missile = P_SpawnXYZMissile(ZapLine_Source, ZapLine_trgt, MT_YLW_ORB, ZapLine_Source.x, ZapLine_Source.y, ZapLine_Source.z)
				if missile and missile.valid then missile.scale = FloatFixed("1.05") end
				ZapLine_Source.sprite = SPR_SHLE
				ZapLine_Source.frame = A
				ZapLine_Source.momy = -10*FRACUNIT
				ZapLine_trgt.momy = -15*FRACUNIT
				wait(0)
			end
		end)
		wait(delayTime or 25)
	end
end

local function dream_r_ph2_ZapRift_HorzVert(mo, repeatTimes, delayTime)
	local STAR_GEN = mo
	--local camera = server.mo.cam
	local newLocation = {}
	local randSpotHorz = 0
	local randSpotVert = 0
	local VerticalZapLine = TASK:Regist(function()
		for RepeatZapLineTimes = 1, repeatTimes or 5 do
			local StartHorz = P_RandomRange(-1, 1)
			StartHorz = P_RandomChoice({-144, 144})
			local ZapLine_Source = OBJECT:CreateNew(MT_PUSH, {x = maplocation("PLAYER_SPAWNPOINT").x+StartHorz*FRACUNIT, y = maplocation("PLAYER_SPAWNPOINT").y+500*FRACUNIT, z = 1000*FRACUNIT})
			ZapLine_Source.fuse = 5*TICRATE
			--local ZapLine_trgt = OBJECT:CreateNew(MT_STARGENESIS_PULL, {x = maplocation("PLAYER_SPAWNPOINT").x+StartHorz*FRACUNIT, y = maplocation("PLAYER_SPAWNPOINT").y+500*FRACUNIT, z = -700*FRACUNIT})
			wait(1)
			--SOUND:PlaySFX(nil, Snd("SE_KR_LASERFIREA"))
			P_StartQuake(32*FRACUNIT, 5)
			local FireZapLine = TASK:Regist(function()
				while true do
					if (mo.EVENTSTATE == "FINAL_DEAD") then
						break
					end
					if not ZapLine_Source.valid then break end
					local missile = P_SpawnMobj(ZapLine_Source.x, ZapLine_Source.y, ZapLine_Source.z, MT_YLW_ORB)--P_SpawnXYZMissile(ZapLine_Source, ZapLine_trgt, MT_YLW_ORB, ZapLine_Source.x, ZapLine_Source.y, ZapLine_Source.z)
					if missile and missile.valid then
						missile.flags = $1|MF_MISSILE|MF_NOGRAVITY
						missile.scale = FloatFixed("0.7")
						missile.momz = -128*FRACUNIT
						missile.fuse = 5*TICRATE
					end
					ZapLine_Source.sprite = SPR_SHLE
					ZapLine_Source.frame = A
					ZapLine_Source.momy = -10*FRACUNIT
					--ZapLine_trgt.fuse = 5*TICRATE
					--ZapLine_trgt.momy = -10*FRACUNIT
					wait(0)
				end
			end)
			wait(delayTime or 25)
		end
	end)
	for RepeatHorzZapLineTimes = 1, repeatTimes or 5 do
		local StartHorz = P_RandomChoice({-1, 1})
		--local StartZ = P_RandomChoice({-78, -64, -55, 55, 64, 78, 100})
		--local StartZ = P_RandomChoice({-78, -64, 64, 78, 100})
		local StartZ = P_RandomChoice({-64, 64, 96})

		local ZapLine_Source = OBJECT:CreateNew(MT_PUSH, {x = maplocation("PLAYER_SPAWNPOINT").x-700*FRACUNIT*StartHorz, y = maplocation("PLAYER_SPAWNPOINT").y+500*FRACUNIT, z = maplocation("GNS_SPAWNPOINT").z+StartZ*FRACUNIT})
		local ZapLine_trgt = OBJECT:CreateNew(MT_PUSH, {x = maplocation("PLAYER_SPAWNPOINT").x+700*FRACUNIT*StartHorz, y = maplocation("PLAYER_SPAWNPOINT").y+500*FRACUNIT, z = maplocation("GNS_SPAWNPOINT").z+StartZ*FRACUNIT})
		ZapLine_Source.fuse = 3*TICRATE
		ZapLine_trgt.fuse = 3*TICRATE
		wait(1)
		OBJECT:setAngle(ZapLine_Source, ANGLE_90)
		SOUND:PlaySFX(nil, Snd("SE_KR_LASERFIREA"), 95)
		P_StartQuake(32*FRACUNIT, 5)
		local FireZapLine = TASK:Regist(function()
			while true do
				if (mo.EVENTSTATE == "FINAL_DEAD") then
					break
				end
				if not ZapLine_Source.valid then break end
				local missile = P_SpawnXYZMissile(ZapLine_Source, ZapLine_trgt, MT_YLW_ORB, ZapLine_Source.x, ZapLine_Source.y, ZapLine_Source.z)
				if missile and missile.valid then missile.scale = FloatFixed("1.05") end
				ZapLine_Source.momy = -10*FRACUNIT
				ZapLine_trgt.momy = -15*FRACUNIT
				wait(0)
			end
		end)
		wait(delayTime or 25)
	end
end

local function dream_r_ph2_ZapRift_Distance(mo, repeatTimes)
	local STAR_GEN = mo
	local camera = server.mo.cam
	local newLocation = {}
	local randSpotHorz = 0
	local randSpotVert = 0

	--print("welcome to the next level")
	for SpawnRepeatTimes = 1, repeatTimes or 3 do
		if (mo.EVENTSTATE == "FINAL_DEAD") then
			break
		end
		randSpotHorz = P_RandomRange(-512, 512)
		randSpotVert = P_RandomRange(-128, 128)
		local StarRift = OBJECT:CreateNew(MT_STARHOLE, {x = maplocation("GNS_SPAWNPOINT").x+randSpotHorz*FRACUNIT, y = 640*FRACUNIT, z = maplocation("GNS_SPAWNPOINT").z+randSpotVert*FRACUNIT})
		OBJECT:setscale(StarRift, 0)
		--SOUND:PlaySFX(nil, sfx_s3k79)
		SOUND:PlaySFX(nil, Snd("SE_EFF_DRM_R_VOICE02"))
		OBJECT:setscale(StarRift, 2*FRACUNIT, FRACUNIT)
		randSpotHorz = P_RandomRange(-128, 128)
		randSpotVert = P_RandomRange(-128, 128)
		ACT:startSprAnim(STAR_GEN, SPRITE("drm_R_IdleStill"), A, G, 6, 1*TICRATE, true)
		for RepeatWarningTime = 1, 15 do
			local WarnCircle = OBJECT:CreateNew(MT_PUSH, {x = maplocation("PLAYER_SPAWNPOINT").x+randSpotHorz*FRACUNIT, y = maplocation("PLAYER_SPAWNPOINT").y, z = maplocation("PLAYER_SPAWNPOINT").z+randSpotVert*FRACUNIT})
			WarnCircle.sprite = SPR_THOK
			WarnCircle.color = SKINCOLOR_RED
			WarnCircle.fuse = 1
			wait(1)
		end
		SOUND:PlaySFX(nil, Snd("SE_KR_LASERCHARGE"))
		ACT:startSprAnim(STAR_GEN, SPRITE("drm_R_AnyAction3"), A, M, 2)
		SOUND:PlaySFX(nil, Snd("SE_KR_LASERFIREA"), 95)
		P_StartQuake(32*FRACUNIT, 5)
		ACT:startSprAnim(STAR_GEN, SPRITE("drm_R_IdleStill"), A, G, 6, 2*TICRATE, true)
		--local dream_WaitOutAttack = TASK:Regist(function()
		--	ACT:startSprAnim(STAR_GEN, SPRITE("drm_IdleStill"), A, G, 6)
		--	signal("AttackFinished")
		--end)
		for LaserFireTime = 1, 1*TICRATE do
			if (mo.EVENTSTATE == "FINAL_DEAD") then
				break
			end
			local missile = P_SpawnPointMissile(StarRift, maplocation("PLAYER_SPAWNPOINT").x+randSpotHorz*FRACUNIT, maplocation("PLAYER_SPAWNPOINT").y, maplocation("PLAYER_SPAWNPOINT").z+randSpotVert*FRACUNIT, MT_YLW_ORB, StarRift.x, StarRift.y, StarRift.z)
			if missile and missile.valid then missile.scale = FloatFixed("0.7") end
			wait(0)
		end
		--waitForSignal("AttackFinished")
		OBJECT:setscale(StarRift, 0, FRACUNIT)
		StarRift.fuse = 35
	end
end

local function dream_r_ph2_BladeSweep(mo, repeatTimes, waitingTime, newsfxPitch)
	local STAR_GEN = mo
	local camera = server.mo.cam
	local newLocation = {}
	local randSpotHorz = 0
	local randSpotVert = 0

	local ShockWaveVibrate = TASK:Regist(function()
		wait(25)
		SOUND:PlaySFX(nil, sfx_s3k4e)
		SOUND:PlaySFX(nil, Snd("SE_EFF_DRM_R_VOICE03"), 90)
		P_StartQuake(32*FRACUNIT, 5)
		local DashShockWave = OBJECT:CreateNew(MT_PUSH, STAR_GEN)
		if DashShockWave and DashShockWave.valid
			DashShockWave.sprite = SPR_WAVC
			DashShockWave.frame = A|FF_FULLBRIGHT
			DashShockWave.color = SKINCOLOR_YELLOW
			OBJECT:setscale(DashShockWave, 32*FRACUNIT, 1*FRACUNIT)
			for transLevel = 2, 9 do
				if DashShockWave and DashShockWave.valid then --[[..]] else break end
				P_SpawnGhostMobj(DashShockWave)
				DashShockWave.frame = A|transLevel<<FF_TRANSSHIFT
				wait(1)
			end
			DashShockWave.fuse = 1
		end
	end)
	if newsfxPitch then
		SOUND:PlaySFX(nil, Snd("SE_KR_LASERCHARGE_8"), 100)
	else
		SOUND:PlaySFX(nil, Snd("SE_KR_LASERCHARGE"), 100)
	end
	local gns_AnimationLoop = TASK:Regist(function()
		ACT:startSprAnim(STAR_GEN, SPRITE("drm_R_BladeSpinStart"), A, M, 2)
		ACT:startSprAnim(STAR_GEN, SPRITE("drm_R_BladeSpin_LP"), A, I, 2)
		while true do
			if (mo.EVENTSTATE == "FINAL_DEAD") then
				break
			end
			ACT:startSprAnim(STAR_GEN, SPRITE("drm_R_BladeSpin_LP"), A, I, 1)
			wait(0)
		end
	end)
	OBJECT:moveTo(STAR_GEN, maplocation("GNS_SPINBLADEPOINT"), 32*FRACUNIT, {arc = {x = -1024*FRACUNIT, z = -128*FRACUNIT, y = -512*FRACUNIT}, tween = {0, FRACUNIT}})
	for RepeatZapLineTimes = 1, repeatTimes or 3 do
		local StartHorz = P_RandomChoice({-164, -128, -64, 64, 128, 164})*FRACUNIT
		local SpinFire_Source = OBJECT:CreateNew(MT_PUSH, {x = maplocation("GNS_SPINBLADEPOINT").x+StartHorz, y = maplocation("GNS_SPINBLADEPOINT").y-500*FRACUNIT, z = maplocation("GNS_SPINBLADEPOINT").z+600*FRACUNIT})
		SpinFire_Source.fuse = 3*TICRATE
		SpinFire_Source.sprite = SPR_SHLE
		SpinFire_Source.momy = -32*FRACUNIT
		wait(1)
		OBJECT:setAngle(SpinFire_Source, ANGLE_90)
		SOUND:PlaySFX(nil, Snd("SE_KR_LASERFIREA"), 96)
		P_StartQuake(32*FRACUNIT, 5)
		local FireSpinFire = TASK:Regist(function()
			while true do
				if (mo.EVENTSTATE == "FINAL_DEAD") then
					break
				end
				if not SpinFire_Source.valid then break end
				local missile = P_SpawnMobj(SpinFire_Source.x+32*cos(SpinFire_Source.angle),
											SpinFire_Source.y+32*sin(SpinFire_Source.angle), SpinFire_Source.z, MT_YLW_ORB)
				if missile and missile.valid then
					missile.flags = $1|MF_MISSILE|MF_NOGRAVITY
					missile.scale = FloatFixed("0.7")
					missile.momz = -128*FRACUNIT
					missile.fuse = 5*TICRATE
				end
				local missileL = P_SpawnMobj(SpinFire_Source.x-32*cos(SpinFire_Source.angle),
											SpinFire_Source.y-32*sin(SpinFire_Source.angle), SpinFire_Source.z-64*FRACUNIT, MT_YLW_ORB)
				if missileL and missileL.valid then
					missileL.flags = $1|MF_MISSILE|MF_NOGRAVITY
					missileL.scale = FloatFixed("0.7")
					missileL.momz = -128*FRACUNIT
					missileL.fuse = 5*TICRATE
				end
				local Crackle = P_SpawnMobj(SpinFire_Source.x+P_RandomRange(-128, 128)*FRACUNIT,
											SpinFire_Source.y+P_RandomRange(-128, 128)*FRACUNIT, SpinFire_Source.z, MT_YLW_CRACKLE)
				SpinFire_Source.angle = FixedAngle(leveltime*FRACUNIT*8)
				wait(0)
			end
		end)
		wait(waitingTime or 25)
	end
	OBJECT:moveTo(STAR_GEN, maplocation("GNS_SPAWNPOINT"), 22*FRACUNIT, {arc = {x = 256*FRACUNIT, z = 128*FRACUNIT, y = 256*FRACUNIT}, tween = {0, FRACUNIT}})
	TASK:Destroy(gns_AnimationLoop)
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_R_BladeSpin_LP"), A, I, 2)
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_R_BladeSpinEnd"), A, I, 2)

end
------------------------------------------------------------------------











------------------------------------------------------------------------------------
-- EVENTS
------------------------------------------------------------------------------------

event.newevent("ev_starfountain01",
function(mo,v)
	CONSOLE:disablejoining(true)
	local forceShowhud = TASK:Regist(function()
		while true do
			for player in players.iterate do
				CONSOLE:forceshowhud(player)
			end
			wait(0)
		end
	end)
	if (server.isdedicated) -- Salt: skip this if in dedicated server
		COM_BufInsertText(server, "exitlevel")
		return
	end
	local camera = server.mo.cam
	local player_standByPosition = {x = 320*FRACUNIT, y = -7488*FRACUNIT, z = 0}
	EVM_HUD["myst_sub_text"] = nil
	for player in players.iterate do
		player.mo.flags2 = $1|MF2_DONTDRAW
		OBJECT:setPosition(player.mo, player_standByPosition)
		netgameCamOverride(player, server, {enabled = true})
		EVM_HUD["widescreen"].z_index = 48
		EVM_HUD["airmanHud"].z_index = -1
		player.hudOptions.widescreen.enabled = true
		syncNetgameText(player, server)
		--player.rTextStore = server.rTextStore
		EVM_HUD["wipefade"].z_index = 47
	end
	local starrod_w = OBJECT:Find(MT_STARROD_W)
	local eggman, eggmobile, badGuy, metal, hero = OBJECT:CreateObjects(
		{obj = MT_STARGENESIS_PULL, loc = {x = -512*FRACUNIT, y = -7552*FRACUNIT, z = 568*FRACUNIT}},
		{obj = MT_STARGENESIS_PULL, loc = {x = -512*FRACUNIT, y = -7552*FRACUNIT, z = 568*FRACUNIT}},
		{obj = MT_STARGENESIS_PULL, loc = {x = -512*FRACUNIT, y = -7552*FRACUNIT, z = 568*FRACUNIT}},
		{obj = MT_STARGENESIS_PULL, loc = {x = -512*FRACUNIT, y = -7552*FRACUNIT, z = 568*FRACUNIT}},
		{obj = MT_STARGENESIS_PULL, loc = {x = -512*FRACUNIT, y = -7552*FRACUNIT, z = 568*FRACUNIT}})
	local emerald1, emerald2, emerald3, emerald4, emerald5, emerald6, emerald7 = OBJECT:CreateObjects(
		{obj = MT_STARGENESIS_PULL, loc = {x = -512*FRACUNIT, y = -7552*FRACUNIT, z = 568*FRACUNIT}},
		{obj = MT_STARGENESIS_PULL, loc = {x = -512*FRACUNIT, y = -7552*FRACUNIT, z = 568*FRACUNIT}},
		{obj = MT_STARGENESIS_PULL, loc = {x = -512*FRACUNIT, y = -7552*FRACUNIT, z = 568*FRACUNIT}},
		{obj = MT_STARGENESIS_PULL, loc = {x = -512*FRACUNIT, y = -7552*FRACUNIT, z = 568*FRACUNIT}},
		{obj = MT_STARGENESIS_PULL, loc = {x = -512*FRACUNIT, y = -7552*FRACUNIT, z = 568*FRACUNIT}},
		{obj = MT_STARGENESIS_PULL, loc = {x = -512*FRACUNIT, y = -7552*FRACUNIT, z = 568*FRACUNIT}},
		{obj = MT_STARGENESIS_PULL, loc = {x = -512*FRACUNIT, y = -7552*FRACUNIT, z = 568*FRACUNIT}})
	eggman.sprite = SPR_EGGM
	eggman.radius = mobjinfo[MT_EGGMOBILE].radius
	eggman.height = mobjinfo[MT_EGGMOBILE].height
	eggman.shadowscale = FRACUNIT // Sal: shadowscales to make it more immersive!
	eggmobile.sprite = SPR_CRID
	eggmobile.frame = A
	--badGuy.sprite = SPR_TOAD
	badGuy.sprite = SPR_DRAC
	badGuy.frame = A
	badGuy.radius = mobjinfo[MT_PLAYER].radius
	badGuy.height = mobjinfo[MT_PLAYER].height
	badGuy.shadowscale = FRACUNIT
	metal.sprite = SPR_METL
	metal.color = skins["metalsonic"].prefcolor
	metal.radius = skins["metalsonic"].radius
	metal.height = skins["metalsonic"].height
	metal.shadowscale = FRACUNIT
	hero.sprite = SPR_PLAY
	hero.sprite2 = SPR2_STND
	hero.skin = server.mo.skin
	hero.color = server.mo.color
	hero.radius = skins[server.mo.skin].radius
	hero.height = skins[server.mo.skin].height
	hero.shadowscale = FRACUNIT
	emerald1.sprite = SPR_CEMG
	emerald1.frame = A
	emerald2.sprite = SPR_CEMG
	emerald2.frame = B
	emerald3.sprite = SPR_CEMG
	emerald3.frame = C
	emerald4.sprite = SPR_CEMG
	emerald4.frame = D
	emerald5.sprite = SPR_CEMG
	emerald5.frame = E
	emerald6.sprite = SPR_CEMG
	emerald6.frame = F
	emerald7.sprite = SPR_CEMG
	emerald7.frame = G

	local fountainviewUp = OBJECT:Find(MT_ALTVIEWMAN, {id = 0})
	CAMERA:SetEye(server, {x = -1408*FRACUNIT, y = -2592*FRACUNIT, z = 0*FRACUNIT, angle = FixedAngle(90*FRACUNIT)}, 0)
	CAMERA:UnsetEye(server, 0)
	wait(90)
	OBJECT:moveTo(server.mo.cam, {x = -1408*FRACUNIT, y = -2592*FRACUNIT, z = 512*FRACUNIT, angle = ANGLE_90}, 2*FRACUNIT,
								{tween = {FRACUNIT/86, FRACUNIT}})
	wait(64)
	metal.frame = E
	-- Start Metal Chase
	for player in players.iterate do
		SOUND:PlayBGM(player, Snd("BGM_EV_CONHIT"))
	end
	OBJECT:setPosition(metal, {x = -9536*FRACUNIT, y = -2432*FRACUNIT, z = 0*FRACUNIT})
	CAMERA:SetEye(server, {x = -6752*FRACUNIT, y = -2368*FRACUNIT, z = -32*FRACUNIT, angle = OBJECT:lookAt(server.mo.cam, metal)}, 0)
	local lookAtMetal = TASK:Regist(function()
		while true do
			CAMERA:SetEye(server, {x = -6752*FRACUNIT, y = -2368*FRACUNIT, z = -32*FRACUNIT, angle = OBJECT:lookAt(server.mo.cam, metal)}, CAMERA:lookAtZ(server, metal))
			wait(0)
		end
	end)
	local metalAfterImage = TASK:Regist(function()
		while true do
			local dist = R_PointToDist2(server.mo.cam.x, server.mo.cam.y, metal.x, metal.y)
			dist = 2048*FRACUNIT - $
			P_SpawnGhostMobj(metal)
			--P_StartQuake(max(4*FRACUNIT, FixedDiv(FRACUNIT/256, dist) + 1), 1)
			--print(FixedDiv(FRACUNIT, dist) )
			wait(0)
		end
	end)
	local metalMovingSound = TASK:Regist(function()
		wait(15)
		SOUND:PlaySFX(nil, sfx_mswarp, 90)
	end)
	local metalMove = TASK:Regist(function()
		OBJECT:moveTo(metal, {x = -1408*FRACUNIT, y = -1984*FRACUNIT, z = 64*FRACUNIT, angle = OBJECT:lookAt(metal, starrod_w)}, 45*FRACUNIT)
	end)
	wait(106)
	TASK:Destroy(lookAtMetal)
	TASK:Destroy(metalMove)
	-- Start Egg Chase
	SOUND:PlaySFX(nil, sfx_telept, 64)
	CAMERA:SetEye(server, {x = -2112*FRACUNIT, y = -6240*FRACUNIT, z = -32*FRACUNIT, angle = OBJECT:lookAt(server.mo.cam, starrod_w)}, 0)
	OBJECT:setPosition(eggman, {x = -1376*FRACUNIT, y = -6432*FRACUNIT, z = 0*FRACUNIT})
	OBJECT:setPosition(hero, {x = -1376*FRACUNIT, y = -6432*FRACUNIT, z = hero.floorz})
	eggman.frame = W
	local eggmanTrail = TASK:Regist(function()
		while true
			local trail = P_SpawnMobj(eggman.x, eggman.y, eggman.z, MT_STARGENESIS_PULL)
			trail.sprite = SPR_THOK
			trail.color = SKINCOLOR_CYAN
			trail.frame = A|TR_TRANS50
			OBJECT:setscale(trail, FRACUNIT/2, 4*FRACUNIT)
			trail.fuse = 20
			wait(2)
		end
	end)
	local eggmanMoveToRod01 = TASK:Regist(function()
		OBJECT:moveTo(eggman, {x = starrod_w.x, y = starrod_w.y, z = starrod_w.z}, 22*FRACUNIT, {angle = OBJECT:lookAt(eggman, starrod_w)})
	end)
	wait(10)
	local heroChaseEggman = TASK:Regist(function()
		ACT:startSpr2Anim(hero, SPR2_RUN, 3, 2*TICRATE, true)
		OBJECT:moveTo(hero, {x = starrod_w.x, y = starrod_w.y, z = hero.floorz}, 21*FRACUNIT, {angle = OBJECT:lookAt(hero, eggman)})
	end)
	CAMERA:UnsetEye(server, 0)
	local cameraPanLeftSlow = TASK:Regist(function()
		OBJECT:moveTo(server.mo.cam, {x = -2112*FRACUNIT, y = -6237*FRACUNIT, z = -32*FRACUNIT}, FRACUNIT/32)
	end)
	wait(64)
	TASK:Destroy(heroChaseEggman)
	TASK:Destroy(cameraPanLeftSlow)
	TASK:Destroy(eggmanMoveToRod01)
	-- Start Follow as Egg
	OBJECT:setPosition(hero, {x = -6400*FRACUNIT, y = -6432*FRACUNIT, z = hero.floorz})
	wait(1)
	OBJECT:setPosition(server.mo.cam, eggman)
	CAMERA:UnsetEye(server, 0)
	local cameraLookatRodZ = TASK:Regist(function()
		while true
			CAMERA:lookAtZ(server, starrod_w)
			--server.mo.cam.angle = OBJECT:lookAt(server.mo.cam, starrod_w)
			wait(0)
		end
	end)
	local cameraFollowAsEgg = TASK:Regist(function()
		OBJECT:moveTo(server.mo.cam, starrod_w, 11*FRACUNIT, {angle = OBJECT:lookAt(camera, starrod_w)})
	end)
	wait(3*TICRATE)
	SOUND:PlaySFX(nil, sfx_s3k66, 90)
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = true, dest = 0, flash = true})
		SOUND:PlayBGM(player, "")
	end
	wait(90)
	TASK:Destroy(cameraLookatRodZ)
	TASK:Destroy(cameraFollowAsEgg)
	wait(35)
	-- Start Kick the egg
	SOUND:PlaySFX(nil, Snd("SE_EFF_SLOWMOTION"), 99)
	for player in players.iterate do
		SOUND:PlayBGM(player, Snd("BGM_EV_CREEP"))
	end
	badGuy.frame = A
	OBJECT:setPosition(eggman, {x = camera.x, y = camera.y+256*FRACUNIT, z = camera.z})
	OBJECT:setPosition(badGuy, {x = eggman.x+64*FRACUNIT, y = eggman.y, z = eggman.z+64*FRACUNIT})
	local curEggLoc = {x = eggman.x, y = eggman.y, z = eggman.z}
	local eggKickCollision = TASK:Regist(function()
		OBJECT:moveTo(eggman, {x = curEggLoc.x-128*FRACUNIT, y = curEggLoc.y, z = curEggLoc.z-128*FRACUNIT}, FRACUNIT/8, 0)
	end)
	local badguyKickCollision = TASK:Regist(function()
		OBJECT:moveTo(badGuy, eggman, FRACUNIT/8, {angle = OBJECT:lookAt(eggman, starrod_w)})
	end)
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = false, dest = 0, Time = 8})
	end
	wait(3*TICRATE)
	SOUND:PlaySFX(nil, sfx_s3k81, 99)
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = true, dest = 0, flash = true})
	end
	wait(5)
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = false, dest = 10, flash = true})
	end
	TASK:Destroy(eggKickCollision)
	TASK:Destroy(badguyKickCollision)
	local fountainOuterfloor = {z = 168*FRACUNIT}
	local eggKickFly = TASK:Regist(function()
		OBJECT:moveTo(eggman, {x = curEggLoc.x-256*FRACUNIT, y = curEggLoc.y, z = fountainOuterfloor.z}, 64*FRACUNIT, 0)
	end)
	CAMERA:SetEye(server, {x = -2112*FRACUNIT, y = -2592*FRACUNIT, z = fountainOuterfloor.z+96*FRACUNIT, angle = FixedAngle(135*FRACUNIT)}, 0)
	TASK:Destroy(eggKickFly)
	OBJECT:setPosition(metal, {x = camera.x, y = camera.y-256*FRACUNIT, z = camera.z})
	curEggLoc = {x = eggman.x, y = eggman.y, z = eggman.z}
	local eggKickHitGround = TASK:Regist(function()
		OBJECT:moveTo(eggman, {x = curEggLoc.x-850*FRACUNIT, y = curEggLoc.y, z = fountainOuterfloor.z}, 64*FRACUNIT, 0)
		eggman.momx = -6*FRACUNIT
		SOUND:PlaySFX(nil, sfx_s3k6e, 99)
		SOUND:PlaySFX(nil, sfx_s3k81, 99)
		P_StartQuake(2*FRACUNIT, 5)
		eggman.sprite = SPR_EGGL
		eggman.frame = A
		curEggLoc = {x = eggman.x, y = eggman.y, z = eggman.z+8*FRACUNIT}
		OBJECT:setPosition(eggmobile, curEggLoc)
		TASK:Destroy(eggmanTrail)
	end)
	wait(15)
	local eggmobileKnockedOff = TASK:Regist(function()
		OBJECT:moveTo(eggmobile, {x = curEggLoc.x-2048*FRACUNIT, y = curEggLoc.y+512*FRACUNIT, z = -1024*FRACUNIT}, 44*FRACUNIT, {arc = {x = 0, y = 0, z = 512*FRACUNIT}})
	end)
	wait(64)
	SetTextConfig("myst_speak01", server, {auto = true, autotime = 2*TICRATE, ticksfx = sfx_pmdpt, speed = 1})
	Speak(v, "myst_speak01", nil, "???", "Gotcha!", true)
	-- Start Metal Shootdown
	metal.frame = P
	local metalSkyWatchLoc = {x = -4448*FRACUNIT, y = -4448*FRACUNIT, z = 1024*FRACUNIT}
	local badGuyStandPosition = {x = -1408*FRACUNIT, y = -2912*FRACUNIT, z = fountainOuterfloor.z}
	OBJECT:setPosition(badGuy, badGuyStandPosition)
	OBJECT:setPosition(metal, {x = metalSkyWatchLoc.x+256*FRACUNIT, y = metalSkyWatchLoc.x+256*FRACUNIT, z = metalSkyWatchLoc.z-32*FRACUNIT})
	CAMERA:SetEye(server, metalSkyWatchLoc, 0)
	CAMERA:UnsetEye(server, 0)
	local cameraLookatBadGuy = TASK:Regist(function()
		while true
			CAMERA:lookAtZ(server, badGuy)
			--camera.angle = OBJECT:lookAt(camera, badGuy)
			wait(0)
		end
	end)
	local cameraPanRight = TASK:Regist(function()
		OBJECT:moveTo(camera, {x = metalSkyWatchLoc.x+512*FRACUNIT, y = metalSkyWatchLoc.y, z = metalSkyWatchLoc.z}, 2*FRACUNIT, {angle = OBJECT:lookAt(camera, badGuy)})
	end)
	local metalIdleMove = TASK:Regist(function()
		OBJECT:moveTo(metal, {x = metalSkyWatchLoc.x+512*FRACUNIT, y = metalSkyWatchLoc.y+512*FRACUNIT, z = metalSkyWatchLoc.z}, 2*FRACUNIT)
	end)
	local metalStartCharge = TASK:Regist(function()
		wait(64)
		TASK:Destroy(metalIdleMove)
		wait(10)
		SOUND:PlaySFX(nil, sfx_s3k5c, 99)
		metal.frame = S
		wait(10)
		SOUND:PlaySFX(nil, sfx_mswarp, 99)
		metal.frame = E
		OBJECT:moveTo(metal, {x = badGuy.x, y = badGuy.y, z = badGuy.z+32*FRACUNIT}, 16*FRACUNIT)
	end)
	wait(35)
	SetTextConfig("myst_speak02", server, {auto = true, autotime = 3*TICRATE, speed = 1})
	Speak(v, "myst_speak02", nil, "???", "And, for you...", true)
	wait(2)
	TASK:Destroy(metalStartCharge)
	metalSkyWatchLoc = {x = metal.x+320*FRACUNIT, y = metal.y+320*FRACUNIT, z = metal.z}
	badGuy.frame = B
	TASK:Destroy(cameraPanRight)
	TASK:Destroy(cameraLookatBadGuy)
	--CAMERA:SetEye(server, {x = badGuyStandPosition.x, y = badGuyStandPosition.y-128*FRACUNIT, z = badGuyStandPosition.z, angle = OBJECT:lookAt(camera, badGuy)}, 0)
	--CAMERA:UnsetEye(server, 0)
	wait(1)
	local cameraFastZoomOut = TASK:Regist(function()
		CAMERA:SetEye(server, {x = badGuy.x, y = badGuy.y-128*FRACUNIT, z = badGuy.z, angle = OBJECT:lookAt(camera, badGuy)}, 0)
		CAMERA:UnsetEye(server, 0)
		OBJECT:moveTo(camera, {x = badGuy.x, y = badGuy.y-114*FRACUNIT, z = badGuy.z}, FRACUNIT/2, {angle = OBJECT:lookAt(camera, badGuy)})
		local particleHitSpawn = TASK:Regist(function()
			for i=0, 18 do
				local randomSpot = {x = badGuy.x+P_RandomRange(-128, 128)*FRACUNIT, y =  badGuy.y+P_RandomRange(-128, 128)*FRACUNIT}
				local hitter = P_SpawnMobj(randomSpot.x, randomSpot.y, badGuy.z, MT_THOK)
				hitter.momz = 64*FRACUNIT
				P_StartQuake(4*FRACUNIT, 5)
				hitter.color = 14
				SOUND:PlaySFX(nil, Snd("SE_EFF_STARFIRE"), 99)
				wait(0)
			end
		end)
		badGuy.frame = C
		OBJECT:moveTo(camera, {x = badGuy.x, y = badGuy.y-1320*FRACUNIT, z = badGuy.z}, 22*FRACUNIT)
	end)
	SetTextConfig("myst_speak02", server, {auto = true, autotime = 1*TICRATE, speed = 1})
	Speak(v, "myst_speak02", nil, "???", "HAVE THIS!", true)
	wait(12)
	-- Start metal explode
	TASK:Destroy(cameraFastZoomOut)
	SOUND:PlaySFX(nil, sfx_bkpoof, 99)
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = true, dest = 0, flash = true})
		SOUND:PlayBGM(player, "")
	end
	wait(15)
	local curMetalLoc = {x = metal.x, y = metal.y, z = metal.z}
	CAMERA:SetEye(server, {x = curMetalLoc.x+320*FRACUNIT, y = curMetalLoc.y+320*FRACUNIT, z = curMetalLoc.z, angle = OBJECT:lookAt(camera, metal)}, 0)
	CAMERA:UnsetEye(server, 0)
	wait(1)
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = false, dest = 10, Time = 5})
	end
	local cameraLookatMetalShotDown = TASK:Regist(function()
		while true
			CAMERA:lookAtZ(server, metal)
			OBJECT:lookAt(camera, metal, true)
			A_BossScream(metal, MT_CYBRAKDEMON_VILE_EXPLOSION)
			wait(0)
		end
	end)
	local MetalShotDownSFXLoop = TASK:Regist(function()
		while true
			SOUND:PlaySFX(nil, sfx_cybdth, 99)
			wait(3)
		end
	end)
	OBJECT:moveTo(metal, {x = 3264*FRACUNIT, y = -128*FRACUNIT, z = badGuy.z}, 62*FRACUNIT)
	TASK:Destroy(cameraLookatMetalShotDown)
	TASK:Destroy(MetalShotDownSFXLoop)
	TASK:Destroy(metalAfterImage)
	metal.flags2 = $1|MF2_DONTDRAW
	local explosion = P_SpawnMobj(metal.x, metal.y, metal.z, MT_SONIC3KBOSSEXPLODE)
	OBJECT:setscale(explosion, 10*FRACUNIT)
	SOUND:PlaySFX(nil, sfx_s3k7a, 99)
	SOUND:PlaySFX(nil, sfx_s3k9b, 99)
	P_StartQuake(8*FRACUNIT, 8)
	-- Start hero interaction
	for player in players.iterate do
		SOUND:PlayBGM(player, Snd("BGM_EV_DOGMA"), true)
	end
	wait(90)
	badGuy.frame = E
	CAMERA:SetEye(server, {x = badGuy.x-256*FRACUNIT, y = badGuy.y-128*FRACUNIT, z = badGuy.z, angle = OBJECT:lookAt(camera, badGuy)}, 0)
	CAMERA:UnsetEye(server, 0)
	SetTextConfig("myst_speak03", server, {auto = true, autotime = 3*TICRATE, ticksfx = sfx_pmdpt, speed = 1})
	Speak(v, "myst_speak03", nil, "???", "I've been waiting for almost\x82\n20 years\x80 to do that.", true)
	Speak(v, "myst_speak03", nil, "???", "Although... that fool saw right\nthrough me.", true)
	--Speak(v, "myst_speak03", server, "???", "Although... that fool \x82saw my face\x80.\bThat wasn't good...", true)
	Speak(v, "myst_speak03", nil, "???", "It felt great KO-ing Robotnik\nand his bots myself for once at least.", true)
	local curBadGuyLoc = {x = badGuy.x, y = badGuy.y, z = badGuy.z}
	OBJECT:setPosition(hero, {x = -1408*FRACUNIT, y = -3488*FRACUNIT, z = 128*FRACUNIT})
	CAMERA:SetEye(server, {x = badGuy.x-128*FRACUNIT, y = badGuy.y-128*FRACUNIT, z = badGuy.z, angle = OBJECT:lookAt(camera, hero)}, 0)
	CAMERA:UnsetEye(server, 0)
	ACT:startSpr2Anim(hero, SPR2_JUMP, 3, 2*TICRATE, true)
	SOUND:PlaySFX(nil, sfx_jump, 99)
	OBJECT:moveTo(hero, {x = curBadGuyLoc.x, y = curBadGuyLoc.y-296*FRACUNIT, z = fountainOuterfloor.z}, 8*FRACUNIT, {arc = {x = 0, y = 0, z = 128*FRACUNIT}})
	ACT:startSpr2Anim(hero, SPR2_STND, 3, 2*TICRATE, true)
	Speak(v, "myst_speak03", nil, "???", "Now with those two out of the way..\nyou're next!", true)
	Speak(v, "myst_speak03", nil, "???", "I'll finally have the chance to\nbe rid of you!", true)
	CAMERA:SetEye(server, {x = badGuy.x-64*FRACUNIT, y = badGuy.y-480*FRACUNIT, z = badGuy.z, angle = OBJECT:lookAt(camera, badGuy)}, 0)
	CAMERA:UnsetEye(server, 0)
	OBJECT:lookAt(camera, badGuy, true)
	local cameraPanLeftSlow = TASK:Regist(function()
		OBJECT:moveTo(camera, {x = badGuy.x-96*FRACUNIT, y = badGuy.y-480*FRACUNIT, z = badGuy.z}, FRACUNIT/32, {angle = OBJECT:lookAt(camera, badGuy)})
	end)
	wait(3*TICRATE)
	TASK:Destroy(cameraPanLeftSlow)
	badGuy.frame = D
	CAMERA:SetEye(server, {x = badGuy.x, y = badGuy.y-160*FRACUNIT, z = badGuy.z+64*FRACUNIT, angle = OBJECT:lookAt(camera, badGuy)}, 0)
	SetTextConfig("myst_speak04", server, {auto = true, autotime = 1*TICRATE/2, ticksfx = sfx_pmdpt, speed = 1})
	Speak(v, "myst_speak04", nil, "???", "What?", true)
	SetTextConfig("myst_speak04", server, {auto = true, autotime = 2*TICRATE, ticksfx = sfx_pmdpt, speed = 1})
	Speak(v, "myst_speak04", nil, "???", "You say you you have no\nidea who I am?", true)
	Speak(v, "myst_speak04", nil, "???", "Are you serious?", true)
	SetTextConfig("myst_speak04", server, {auto = true, autotime = 3*TICRATE, ticksfx = sfx_pmdpt, speed = 1})
	CAMERA:SetEye(server, {x = badGuy.x, y = badGuy.y-96*FRACUNIT, z = badGuy.z+64*FRACUNIT, angle = OBJECT:lookAt(camera, hero)}, 0)
	CAMERA:UnsetEye(server, 0)
	local cameraZoomIntoHero = TASK:Regist(function()
		OBJECT:moveTo(camera, {x = badGuy.x, y = badGuy.y-256*FRACUNIT, z = badGuy.z}, FRACUNIT/64, {angle = OBJECT:lookAt(camera, hero)})
	end)
	wait(1)
	Speak(v, "myst_speak04", nil, "???", "Have you enjoyed being the center\nof attention THAT much?", true)
	Speak(v, "myst_speak04", nil, "???", "Well. I think \x82you\x80 know though.", true)
	TASK:Destroy(cameraZoomIntoHero)
	CAMERA:SetEye(server, {x = badGuy.x, y = badGuy.y-160*FRACUNIT, z = badGuy.z+64*FRACUNIT, angle = OBJECT:lookAt(camera, badGuy)}, 0)
	SetTextConfig("myst_speak04", server, {auto = true, autotime = 2*TICRATE, ticksfx = sfx_pmdpt, speed = 1})
	wait(1)
	Speak(v, "myst_speak04", nil, "???", "You know what? I don't care,\nI'm not here for that today.", true)
	badGuy.frame = E
	Speak(v, "myst_speak04", nil, "???", "Because I'll finally wipe\nyou from history!", true)
	CAMERA:SetEye(server, {x = starrod_w.x, y = starrod_w.y-512*FRACUNIT, z = starrod_w.z+64*FRACUNIT, angle = OBJECT:lookAt(camera, starrod_w)}, 0)
	CAMERA:UnsetEye(server, 0)
	local cameraZoomIntoStar = TASK:Regist(function()
		OBJECT:moveTo(camera, {x = starrod_w.x, y = starrod_w.y-64*FRACUNIT, z = starrod_w.z}, FRACUNIT/4, {angle = OBJECT:lookAt(camera, starrod_w)})
	end)
	SetTextConfig("myst_speak05", server, {auto = true, autotime = 3*TICRATE, speed = 1})
	Speak(v, "myst_speak05", nil, "???", "Using \x83Star Genesis\x80!", true)
	SetTextConfig("myst_speak05", server, {auto = true, autotime = 4*TICRATE, speed = 1})
	Speak(v, "myst_speak05", nil, "???", "A magical rod that will grant\nmy every wish!", true)
	wait(1)
	Speak(v, "myst_speak05", nil, "???", "I could easily squash you\nwith its energy.", true)
	wait(1)
	Speak(v, "myst_speak05", server, "???", "Its power is unimaginable in\ngood hands- and also...", true)
	TASK:Destroy(cameraZoomIntoStar)
	wait(1)
	CAMERA:SetEye(server, {x = badGuy.x, y = badGuy.y-160*FRACUNIT, z = badGuy.z+64*FRACUNIT, angle = OBJECT:lookAt(camera, badGuy)}, 0)
	CAMERA:UnsetEye(server, 0)
	OBJECT:lookAt(camera, badGuy, true)
	SetTextConfig("myst_speak06", server, {auto = true, autotime = 2*TICRATE, ticksfx = sfx_pmdpt, speed = 1})
	Speak(v, "myst_speak06", nil, "???", "You know what? I think I'll just\ndestroy your universe with it instead!", true)
	wait(1)
	Speak(v, "myst_speak06", nil, "???", "Then I'll replace your existence\n\x82like you did mine\x80!", true)
	wait(1)
	Speak(v, "myst_speak06", nil, "???", "You won't be able to stop me!", true)
	-- Start Emerald Transfer
	CAMERA:SetEye(server, {x = badGuy.x, y = badGuy.y-96*FRACUNIT, z = badGuy.z+64*FRACUNIT, angle = OBJECT:lookAt(camera, badGuy)}, 0)
	SetTextConfig("myst_speak06", server, {auto = true, autotime = 1*TICRATE, ticksfx = sfx_pmdpt, speed = 1})
	local BadGuyCharging = TASK:Regist(function()
		wait(36)
		badGuy.frame = B
	end)
	Speak(v, "myst_speak06", nil, "???", "Now then, I'll be taking those...", true)
	CAMERA:SetEye(server, {x = hero.x, y = hero.y-160*FRACUNIT, z = hero.z+64*FRACUNIT, angle = OBJECT:lookAt(camera, badGuy)}, 0)
	CAMERA:UnsetEye(server, 0)
	SetTextConfig("myst_speak06", server, {auto = true, autotime = 2*TICRATE, ticksfx = sfx_pmdpt, speed = 1})
	local powerSapToBadGuy = TASK:Regist(function()
		while true do
			local randomSpot = {x = hero.x, z = hero.z}
			local sapper = P_SpawnMobj(randomSpot.x, hero.y, randomSpot.z, MT_STARGENESIS_PULL)
			sapper.sprite = SPR_THOK
			P_StartQuake(12*FRACUNIT, 5)
			sapper.color = P_RandomRange(0, 25)
			sapper.frame = $1|FF_TRANS40
			OBJECT:setscale(sapper, 0, FloatFixed("0.1"))
			local sapperMoveToBadGuy = TASK:Regist(function()
				OBJECT:moveTo(sapper, {x = badGuy.x, y = badGuy.y, z = badGuy.z+45*FRACUNIT}, 42*FRACUNIT, {arc = {x = P_RandomRange(-128, 128)*FRACUNIT, y = 0, z = P_RandomRange(0, 96)*FRACUNIT}})
				sapper.fuse = 2
			end)
			--SOUND:PlaySFX(nil, Snd("SE_EFF_STARFIRE"),18)
			wait(0)
		end
	end)
	hero.sprite2 = SPR2_PAIN
	hero.frame = A
	local moveCameraToLeftView = TASK:Regist(function()
		OBJECT:moveTo(camera, {x = hero.x-512*FRACUNIT, y = hero.y+64*FRACUNIT, z = hero.z+64*FRACUNIT}, FRACUNIT/2, {angle = OBJECT:lookAt(camera, badGuy)})
	end)
	local LookatBadGuy = TASK:Regist(function()
		while true do
			OBJECT:lookAt(camera, badGuy, true)
			wait(0)
		end
	end)
	local takeAllEmeraldsFromHero = TASK:Regist(function()
		wait(2*TICRATE)
		SOUND:PlaySFX(camera, Snd("SE_EFF_SLOWMOTION"), 99)
		SOUND:PlaySFX(nil, Snd("SE_EFF_SLOWMOTION"), 99)
		for player in players.iterate do
			SCREEN:SetWipe(player, {set = true, dest = 0, flash = true})
		end
		wait(4)
		for player in players.iterate do
			SCREEN:SetWipe(player, {set = false, dest = 0, Time = 4})
		end
		OBJECT:setPosition(emerald1, {x = hero.x, y = hero.y, z = hero.z+16*FRACUNIT})
		SOUND:PlaySFX(nil, sfx_s3kb3, 99)
		SOUND:PlaySFX(nil, sfx_s3kb3, 99)
		OBJECT:moveTo(emerald1, {x = badGuy.x, y = badGuy.y, z = badGuy.z+45*FRACUNIT}, 8*FRACUNIT)
		emerald1.flags2 = $1|MF2_DONTDRAW
		wait(26)
		SOUND:PlaySFX(nil, Snd("SE_EFF_SLOWMOTION"), 99)
		SOUND:PlaySFX(nil, Snd("SE_EFF_SLOWMOTION"), 99)
		for player in players.iterate do
			SCREEN:SetWipe(player, {set = true, dest = 0, flash = true})
		end
		wait(4)
		for player in players.iterate do
			SCREEN:SetWipe(player, {set = false, dest = 0, Time = 4})
		end
		OBJECT:setPosition(emerald2, {x = hero.x, y = hero.y, z = hero.z+16*FRACUNIT})
		SOUND:PlaySFX(nil, sfx_s3kb3, 99)
		SOUND:PlaySFX(nil, sfx_s3kb3, 99)
		OBJECT:moveTo(emerald2, {x = badGuy.x, y = badGuy.y, z = badGuy.z+45*FRACUNIT}, 8*FRACUNIT)
		emerald2.flags2 = $1|MF2_DONTDRAW
		wait(26)
		SOUND:PlaySFX(nil, Snd("SE_EFF_SLOWMOTION"), 99)
		SOUND:PlaySFX(nil, Snd("SE_EFF_SLOWMOTION"), 99)
		for player in players.iterate do
			SCREEN:SetWipe(player, {set = true, dest = 0, flash = true})
		end
		wait(4)
		for player in players.iterate do
			SCREEN:SetWipe(player, {set = false, dest = 0, Time = 8})
		end
		OBJECT:setPosition(emerald3, {x = hero.x, y = hero.y, z = hero.z+16*FRACUNIT})
		SOUND:PlaySFX(nil, sfx_s3kb3, 99)
		SOUND:PlaySFX(nil, sfx_s3kb3, 99)
		OBJECT:moveTo(emerald3, {x = badGuy.x, y = badGuy.y, z = badGuy.z+45*FRACUNIT}, 8*FRACUNIT)
		emerald3.flags2 = $1|MF2_DONTDRAW
		wait(26)
		SOUND:PlaySFX(nil, Snd("SE_EFF_SLOWMOTION"), 99)
		SOUND:PlaySFX(nil, Snd("SE_EFF_SLOWMOTION"), 99)
		for player in players.iterate do
			SCREEN:SetWipe(player, {set = true, dest = 0, flash = true})
		end
		wait(4)
		for player in players.iterate do
			SCREEN:SetWipe(player, {set = false, dest = 0, Time = 4})
		end
		OBJECT:setPosition(emerald4, {x = hero.x, y = hero.y, z = hero.z+16*FRACUNIT})
		SOUND:PlaySFX(nil, sfx_s3kb3, 99)
		SOUND:PlaySFX(nil, sfx_s3kb3, 99)
		OBJECT:moveTo(emerald4, {x = badGuy.x, y = badGuy.y, z = badGuy.z+45*FRACUNIT}, 8*FRACUNIT)
		emerald4.flags2 = $1|MF2_DONTDRAW
		wait(26)
		SOUND:PlaySFX(nil, Snd("SE_EFF_SLOWMOTION"), 99)
		SOUND:PlaySFX(nil, Snd("SE_EFF_SLOWMOTION"), 99)
		for player in players.iterate do
			SCREEN:SetWipe(player, {set = true, dest = 0, flash = true})
		end
		wait(4)
		for player in players.iterate do
			SCREEN:SetWipe(player, {set = false, dest = 0, Time = 4})
		end
		OBJECT:setPosition(emerald5, {x = hero.x, y = hero.y, z = hero.z+16*FRACUNIT})
		SOUND:PlaySFX(nil, sfx_s3kb3, 99)
		SOUND:PlaySFX(nil, sfx_s3kb3, 99)
		OBJECT:moveTo(emerald5, {x = badGuy.x, y = badGuy.y, z = badGuy.z+45*FRACUNIT}, 8*FRACUNIT)
		emerald5.flags2 = $1|MF2_DONTDRAW
		wait(26)
		SOUND:PlaySFX(nil, Snd("SE_EFF_SLOWMOTION"), 99)
		SOUND:PlaySFX(nil, Snd("SE_EFF_SLOWMOTION"), 99)
		for player in players.iterate do
			SCREEN:SetWipe(player, {set = true, dest = 0, flash = true})
		end
		wait(4)
		for player in players.iterate do
			SCREEN:SetWipe(player, {set = false, dest = 0, Time = 4})
		end
		OBJECT:setPosition(emerald6, {x = hero.x, y = hero.y, z = hero.z+16*FRACUNIT})
		SOUND:PlaySFX(nil, sfx_s3kb3, 99)
		SOUND:PlaySFX(nil, sfx_s3kb3, 99)
		OBJECT:moveTo(emerald6, {x = badGuy.x, y = badGuy.y, z = badGuy.z+45*FRACUNIT}, 8*FRACUNIT)
		emerald6.flags2 = $1|MF2_DONTDRAW
		wait(26)
		SOUND:PlaySFX(nil, Snd("SE_EFF_SLOWMOTION"), 99)
		SOUND:PlaySFX(nil, Snd("SE_EFF_SLOWMOTION"), 99)
		for player in players.iterate do
			SCREEN:SetWipe(player, {set = true, dest = 0, flash = true})
		end
		wait(4)
		for player in players.iterate do
			SCREEN:SetWipe(player, {set = false, dest = 0, Time = 4})
		end
		OBJECT:setPosition(emerald7, {x = hero.x, y = hero.y, z = hero.z+16*FRACUNIT})
		SOUND:PlaySFX(nil, sfx_s3kb3, 99)
		SOUND:PlaySFX(nil, sfx_s3kb3, 99)
		OBJECT:moveTo(emerald7, {x = badGuy.x, y = badGuy.y, z = badGuy.z+45*FRACUNIT}, 8*FRACUNIT)
		emerald7.flags2 = $1|MF2_DONTDRAW
		TASK:Destroy(powerSapToBadGuy)
		for player in players.iterate do
			SCREEN:SetWipe(player, {set = true, dest = 0, flash = true})
			SOUND:PlayBGM(player, "", true)
		end
		SOUND:PlaySFX(nil, Snd("SE_EFF_STARPORTAL"), 99)
		SOUND:PlaySFX(nil, Snd("SE_EFF_STARPORTAL"), 99)
		wait(26)
		signal("ContinuePostEmerald")
	end)
	badGuy.frame = C
	SOUND:PlaySFX(nil, Snd("SE_EFF_SLOWMOTION"), 99)
	SOUND:PlaySFX(nil, Snd("SE_EFF_SLOWMOTION"), 99)
	Speak(v, "myst_speak06", nil, "???", "CHAOS EMERALDS!", true)
	waitForSignal("ContinuePostEmerald")
	-- Start Rod Steal
	TASK:Destroy(powerSapToBadGuy)
	TASK:Destroy(moveCameraToLeftView)
	TASK:Destroy(LookatBadGuy)
	TASK:Destroy(takeAllEmeraldsFromHero)
	ACT:stopSprAnim(hero)

	hero.sprite2 = SPR2_DEAD
	hero.frame = A
	hero.shadowscale = 0 -- Sal: undo shadowscale shenanigans
	hero.flags = $ | MF_NOCLIPHEIGHT

	badGuy.frame = D
	local curHeroLoc = {x = hero.x, y = hero.y, z = hero.z}
	wait(120)
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = false, dest = 10, Timer = 8})
	end
	CAMERA:SetEye(server, {x = hero.x-512*FRACUNIT, y = hero.y+64*FRACUNIT, z = hero.z+64*FRACUNIT, angle = OBJECT:lookAt(camera, hero)}, 0)
	CAMERA:UnsetEye(server, 0)
	SOUND:PlaySFX(nil, sfx_s3k35, 99)
	OBJECT:moveTo(hero, {x = curHeroLoc.x+500*FRACUNIT, y = curHeroLoc.y-500*FRACUNIT, z = -1000*FRACUNIT}, 18*FRACUNIT, {arc = {x = 0, y = 0, z = 600*FRACUNIT}})
	wait(15)
	SOUND:PlaySFX(nil, sfx_s3k4a, 99)
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = true, dest = 0, flash = true, pic = "bfill"})
	end
	badGuy.frame = F
	OBJECT:setPosition(badGuy, {x = starrod_w.x, y = starrod_w.y+64*FRACUNIT, z = starrod_w.z-106*FRACUNIT})
	OBJECT:setscale(badGuy, 3*FRACUNIT)
	CAMERA:SetEye(server, {x = starrod_w.x, y = starrod_w.y-256*FRACUNIT, z = starrod_w.z+128*FRACUNIT, angle = OBJECT:lookAt(camera, starrod_w)}, 0)
	CAMERA:UnsetEye(server, 0)
	local darkBG = P_SpawnMobj(badGuy.x, badGuy.y, badGuy.z, MT_STARGENESIS_PULL)
	darkBG.sprite = SPR_THOK
	darkBG.color = SKINCOLOR_BLACK
	darkBG.flags = $ | MF_NOCLIPHEIGHT -- Sal
	OBJECT:setPosition(darkBG, {x = starrod_w.x, y = starrod_w.y+128*FRACUNIT, z = starrod_w.z-512*FRACUNIT})
	OBJECT:setscale(darkBG, 32*FRACUNIT)
	local zoomCameraInPoint = TASK:Regist(function()
		OBJECT:moveTo(camera, {x = starrod_w.x, y = starrod_w.y-128*FRACUNIT, z = starrod_w.z}, FRACUNIT/8, {angle = OBJECT:lookAt(camera, starrod_w)})
	end)
	wait(22)
	SOUND:PlaySFX(nil, sfx_s3k4a, 99)
	for player in players.iterate do
		SOUND:PlayBGM(player, Snd("BGM_EV_FEAR"), true)
		SCREEN:SetWipe(player, {set = false, dest = 10, flash = true})
	end
	wait(35)
	EVM_HUD["myst_sub_text"] = {z_index = 64, func =
	function(v, player, cam)
		v.drawString(320/2, 200-16, "I did it! It's all mine!", V_ALLOWLOWERCASE|V_MONOSPACE, "center")
	end
	}
	wait(4*TICRATE)
	EVM_HUD["myst_sub_text"] = {z_index = 64, func =
	function(v, player, cam)
		v.drawString(320/2, 200-16, "I've finally gotten \x83Star Genesis\x80!", V_ALLOWLOWERCASE|V_MONOSPACE, "center")
	end
	}
	wait(4*TICRATE)
	EVM_HUD["myst_sub_text"] = {z_index = 64, func =
	function(v, player, cam)
		v.drawString(320/2, 200-16, "Nothing can stop me now!", V_ALLOWLOWERCASE|V_MONOSPACE, "center")
	end
	}
	wait(4*TICRATE)
	EVM_HUD["myst_sub_text"] = {z_index = 64, func =
	function(v, player, cam)
		v.drawString(320/2, 200-16, "Muahahahahahaha!", V_ALLOWLOWERCASE|V_MONOSPACE, "center")
	end
	}
	wait(4*TICRATE)
	EVM_HUD["myst_sub_text"] = nil
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = true, dest = 10, Time = 8, pic = "bfill"})
	end
	wait(3*TICRATE)
	TASK:Destroy(zoomCameraInPoint)
	-- Start bad guy transform
	OBJECT:setscale(darkBG, 0*FRACUNIT)
	badGuy.frame = E
	OBJECT:setscale(badGuy, 1*FRACUNIT)
	local rodPedestalLoc = {x = -1408*FRACUNIT, y = -1984*FRACUNIT, z = 624*FRACUNIT}
	OBJECT:setPosition(badGuy, {x = rodPedestalLoc.x, y = rodPedestalLoc.y, z = rodPedestalLoc.z+512*FRACUNIT})
	OBJECT:setPosition(starrod_w, {x = badGuy.x, y = badGuy.y, z = badGuy.z+128*FRACUNIT})
	OBJECT:setPosition(emerald1, {x = badGuy.x, y = badGuy.y, z = badGuy.z+32*FRACUNIT})
	OBJECT:setPosition(emerald2, {x = badGuy.x, y = badGuy.y, z = badGuy.z+32*FRACUNIT})
	OBJECT:setPosition(emerald3, {x = badGuy.x, y = badGuy.y, z = badGuy.z+32*FRACUNIT})
	OBJECT:setPosition(emerald4, {x = badGuy.x, y = badGuy.y, z = badGuy.z+32*FRACUNIT})
	OBJECT:setPosition(emerald5, {x = badGuy.x, y = badGuy.y, z = badGuy.z+32*FRACUNIT})
	OBJECT:setPosition(emerald6, {x = badGuy.x, y = badGuy.y, z = badGuy.z+32*FRACUNIT})
	OBJECT:setPosition(emerald7, {x = badGuy.x, y = badGuy.y, z = badGuy.z+32*FRACUNIT})
	local emerald1NewLoc = {x = -1408*FRACUNIT, y = -1664*FRACUNIT, z = badGuy.z}
	local emerald2NewLoc = {x = -1616*FRACUNIT, y = -1760*FRACUNIT, z = badGuy.z}
	local emerald3NewLoc = {x = -1728*FRACUNIT, y = -1984*FRACUNIT, z = badGuy.z}
	local emerald4NewLoc = {x = -1568*FRACUNIT, y = -2256*FRACUNIT, z = badGuy.z}
	local emerald5NewLoc = {x = -1248*FRACUNIT, y = -2256*FRACUNIT, z = badGuy.z}
	local emerald6NewLoc = {x = -1088*FRACUNIT, y = -1984*FRACUNIT, z = badGuy.z}
	local emerald7NewLoc = {x = -1200*FRACUNIT, y = -1760*FRACUNIT, z = badGuy.z}
	CAMERA:SetEye(server, {x = badGuy.x, y = badGuy.y-1024*FRACUNIT, z = badGuy.z-256*FRACUNIT, angle = OBJECT:lookAt(camera, badGuy)}, 0)
	CAMERA:UnsetEye(server, 0)
	local curCamLoc = {x = camera.x, y = camera.y, z = camera.z}
	local zoomCameraOutofPoint = TASK:Regist(function()
		OBJECT:moveTo(camera, {x = curCamLoc.x, y = curCamLoc.y-128*FRACUNIT, z = curCamLoc.z}, FRACUNIT/8, {angle = OBJECT:lookAt(camera, badGuy)})
	end)
	badGuy.frame = B
	wait(2*TICRATE)
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = false, dest = 0, Time = 4, pic = "bfill"})
	end
	wait(2*TICRATE)
	emerald1.flags2 = $1&~MF2_DONTDRAW
	emerald1.frame = $1|FF_FULLBRIGHT
	SOUND:PlaySFX(nil, sfx_s3kb3, 99)
	OBJECT:moveTo(emerald1, emerald1NewLoc, 45*FRACUNIT)
	emerald2.flags2 = $1&~MF2_DONTDRAW
	emerald2.frame = $1|FF_FULLBRIGHT
	SOUND:PlaySFX(nil, sfx_s3kb3, 99)
	OBJECT:moveTo(emerald2, emerald2NewLoc, 45*FRACUNIT)
	emerald3.flags2 = $1&~MF2_DONTDRAW
	emerald3.frame = $1|FF_FULLBRIGHT
	SOUND:PlaySFX(nil, sfx_s3kb3, 99)
	OBJECT:moveTo(emerald3, emerald3NewLoc, 45*FRACUNIT)
	emerald4.flags2 = $1&~MF2_DONTDRAW
	emerald4.frame = $1|FF_FULLBRIGHT
	SOUND:PlaySFX(nil, sfx_s3kb3, 99)
	OBJECT:moveTo(emerald4, emerald4NewLoc, 45*FRACUNIT)
	emerald5.flags2 = $1&~MF2_DONTDRAW
	emerald5.frame = $1|FF_FULLBRIGHT
	SOUND:PlaySFX(nil, sfx_s3kb3, 99)
	OBJECT:moveTo(emerald5, emerald5NewLoc, 45*FRACUNIT)
	emerald6.flags2 = $1&~MF2_DONTDRAW
	emerald6.frame = $1|FF_FULLBRIGHT
	SOUND:PlaySFX(nil, sfx_s3kb3, 99)
	OBJECT:moveTo(emerald6, emerald6NewLoc, 45*FRACUNIT)
	emerald7.flags2 = $1&~MF2_DONTDRAW
	emerald7.frame = $1|FF_FULLBRIGHT
	SOUND:PlaySFX(nil, sfx_s3kb3, 99)
	OBJECT:moveTo(emerald7, emerald7NewLoc, 45*FRACUNIT)
	SOUND:PlaySFX(nil, sfx_s3ka4)
	wait(3*TICRATE)
	SOUND:PlaySFX(nil, sfx_s3k9f)
	SOUND:PlaySFX(nil, Snd("SE_EFF_DARKCOUNTER"))
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = true, dest = 0, pic = "wfill", flash = true})
	end
	local curBadGuyLoc = {x = badGuy.x, y = badGuy.y, z = badGuy.z+512*FRACUNIT}
	local glowObjects = TASK:Regist(function()
		local glowingObjects = {badGuy, emerald1, emerald2, emerald3, emerald4, emerald5, emerald6, emerald7, starrod_w}
		local rotateObjects = {emerald1, emerald2, emerald3, emerald4, emerald5, emerald6, emerald7}
		badGuy.frame = B
		while true do
			badGuy.angle = $1+FixedAngle(16*FRACUNIT)
			for k,glowMobjTop in pairs(glowingObjects) do
				local glower =  P_SpawnMobj(glowMobjTop.x, glowMobjTop.y, glowMobjTop.z, MT_STARGENESIS_PULL)
				glower.sprite = SPR_THOK
				glower.color = SKINCOLOR_WHITE --P_RandomRange(0,25)
				glower.frame = $1|FF_FULLBRIGHT|TR_TRANS50
				OBJECT:setscale(glower, 2*FRACUNIT)
				for k,rotateMobj in pairs(rotateObjects) do
				P_MoveOrigin(rotateMobj,
					badGuy.x + 512*cos(badGuy.angle+FixedAngle(leveltime*FRACUNIT*32)),
					badGuy.y + 512*sin(badGuy.angle+FixedAngle(leveltime*FRACUNIT*32)),
					badGuy.z)
				end
				glower.momx = P_RandomRange(-64, 64)*FRACUNIT
				glower.momy = P_RandomRange(-64, 64)*FRACUNIT
				glower.momz = 64*FRACUNIT
				glower.fuse = 10
				glowMobjTop.momz = 32*FRACUNIT
			end
			wait(0)
		end
	end)
	local intensityQuake = TASK:Regist(function()
		while true do
			P_StartQuake(32*FRACUNIT, 5)
			wait(0)
		end
	end)
	wait(5)
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = false, dest = 10, pic = "wfill", flash = true})
	end
	-- Start Ambition 1
	TASK:Destroy(zoomCameraOutofPoint)
	TASK:Destroy(glowObjects)
	SOUND:PlaySFX(nil, sfx_s3k4e)
	--SOUND:PlaySFX(nil, sfx_rumble)
	local rumbleSFXLoop = TASK:Regist(function()
		while true do
			if S_IdPlaying(sfx_s3k6f) then
			else
				SOUND:PlaySFX(nil, sfx_s3k6f)
			end
			wait(0)
		end
	end)
	P_FadeLight(65535, 128, 3*TICRATE)
	badGuy.flags2 = $1|MF2_DONTDRAW
	emerald1.flags2 = $1|MF2_DONTDRAW
	emerald2.flags2 = $1|MF2_DONTDRAW
	emerald3.flags2 = $1|MF2_DONTDRAW
	emerald4.flags2 = $1|MF2_DONTDRAW
	emerald5.flags2 = $1|MF2_DONTDRAW
	emerald6.flags2 = $1|MF2_DONTDRAW
	emerald7.flags2 = $1|MF2_DONTDRAW
	eggmobile.flags2 = $1|MF2_DONTDRAW
	OBJECT:setPosition(starrod_w, curBadGuyLoc)
	wait(2*TICRATE)
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = true, dest = 10, Time = 5})
	end
	wait(2*TICRATE)
	CAMERA:SetEye(server, {x = hero.x, y = hero.y-512*FRACUNIT, z = hero.z+256*FRACUNIT, angle = OBJECT:lookAt(camera, badGuy)}, 0)
	CAMERA:UnsetEye(server, 0)
	OBJECT:setPosition(starrod_w, {x = hero.x, y = hero.y, z = hero.z+600*FRACUNIT})
	hero.flags2 = $1|MF2_DONTDRAW
	TASK:Destroy(intensityQuake)
	TASK:Destroy(rumbleSFXLoop)
	for player in players.iterate do
		SOUND:PlayBGM(player, "", true)
		SCREEN:SetWipe(player, {set = false, dest = 10, flash = true})
	end
	wait(64)
	SOUND:PlaySFX(nil, Snd("SE_EFF_WINDSPARKLE"))
	starrod_w.frame = $1|FF_FULLBRIGHT|TR_TRANS40
	starrod_w.sprite = SPR_SHLE
	OBJECT:setscale(starrod_w, 1*FRACUNIT/2)
	local starSparkle = TASK:Regist(function()
		while true do
			OBJECT:CreateNew(MT_SUPERSPARK, {x = starrod_w.x, y = starrod_w.y, z = starrod_w.z})
			wait(8)
		end
	end)
	OBJECT:moveTo(starrod_w, {x = hero.x, y = hero.y, z = hero.z+256*FRACUNIT}, 3*FRACUNIT)
	TASK:Destroy(starSparkle)

	SOUND:PlaySFX(nil, Snd("SE_EFF_UNDRTLE_02"))
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = true, dest = 0, flash = true, pic = "wfill"})
	end
	wait(8)
	local rootLoc = {x = 5888*FRACUNIT, y = -7296*FRACUNIT, z = -524*FRACUNIT}
	OBJECT:setPosition(hero, {x = rootLoc.x, y = rootLoc.y+512*FRACUNIT, z = rootLoc.z})
	wait(5)
	local star1, star2, lightExplode = OBJECT:CreateObjects(
		{obj = MT_STARGENESIS_PULL, loc = {x = hero.x-640*FRACUNIT, y = hero.y, z = hero.z}},
		{obj = MT_STARGENESIS_PULL, loc = {x = hero.x+640*FRACUNIT, y = hero.y, z = hero.z}},
		{obj = MT_STARGENESIS_PULL, loc = {x = hero.x+1024*FRACUNIT, y = hero.y, z = hero.z}})
	star1.sprite = SPR_SHLE
	star2.sprite = SPR_SHLE
	lightExplode.sprite = SPR_CTHK
	lightExplode.color = SKINCOLOR_WHITE
	lightExplode.frame = $1|FF_FULLBRIGHT
	star1.frame = $1|FF_FULLBRIGHT|TR_TRANS50
	star2.frame = $1|FF_FULLBRIGHT|TR_TRANS50
	local starGatherAfterImage = TASK:Regist(function()
		while true do
			if star1.valid then
				OBJECT:CreateNew(MT_SUPERSPARK, star1)
				P_SpawnGhostMobj(star1)
			end
			if star2.valid then
				OBJECT:CreateNew(MT_SUPERSPARK, star2)
				P_SpawnGhostMobj(star2)
			end
			wait(0)
		end
	end)
	OBJECT:setscale(star1, 1*FRACUNIT/2)
	OBJECT:setscale(star2, 1*FRACUNIT/2)
	OBJECT:setPosition(hero, {x = rootLoc.x, y = rootLoc.y+512*FRACUNIT, z = rootLoc.z})
	CAMERA:SetEye(server, {x = 5888*FRACUNIT, y = -7296*FRACUNIT, z = -524*FRACUNIT, angle = ANGLE_90}, 0)
	CAMERA:UnsetEye(server, 0)
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = false, dest = 10, flash = true})
	end
	wait(15)
	for player in players.iterate do
		SOUND:PlayBGM(player, Snd("BGM_EV_AMBITION"), false)
	end
	local finalHeroLoc = {x = hero.x, y = hero.y, z = hero.z}
	local MoveStar1 = TASK:Regist(function()
		OBJECT:moveTo(star1, hero, 10*FRACUNIT)
		star1.fuse = 1
	end)
	local MoveStar2 = TASK:Regist(function()
		OBJECT:moveTo(star2, hero, 10*FRACUNIT)
		star2.fuse = 1
		TASK:Destroy(starGatherAfterImage)
		signal("StartAmbition")
	end)
	waitForSignal("StartAmbition")
	wait(15)
	OBJECT:setPosition(lightExplode, hero)
	OBJECT:setscale(lightExplode, 32*FRACUNIT, 5*FRACUNIT)
	wait(2*TICRATE)
	hero.sprite = SPR_STSP
	hero.frame = A
	hero.frame = $1|FF_FULLBRIGHT
	--hero.sprite = SPR_VLTR
	hero.angle = ANGLE_270
	hero.flags2 = $1&~MF2_DONTDRAW
	CAMERA:SetEye(server, {x = 5688*FRACUNIT, y = -7296*FRACUNIT, z = -524*FRACUNIT, angle = OBJECT:lookAt(camera, hero)}, 0)
	CAMERA:UnsetEye(server, 0)
	local cameraLookAtFinalHero = TASK:Regist(function()
		while true do
			OBJECT:lookAt(camera, hero, true)
			--CAMERA:lookAtZ(server, hero, true)
			wait(0)
		end
	end)
	lightExplode.fuse = 1
	--local fadeInTunnel = TASK:Regist(function()
	--	for i=0, 240, 8 do
	--		P_FadeLight(100, i, 3*TICRATE)
	--		wait(1)
	--	end
	--end)
	wait(15)
	local star_shipGlow = TASK:Regist(function()
		while true do
			if hero.valid then
				P_SpawnGhostMobj(hero)
				local sparkle = OBJECT:CreateNew(MT_IVSP, hero)
				sparkle.frame = $1|FF_FULLBRIGHT
			end
			wait(0)
		end
	end)
	SOUND:PlaySFX(nil, sfx_s3k4e)
	P_StartQuake(64*FRACUNIT, 5)
	P_SpawnMobj(hero.x, hero.y, hero.z, MT_EXPLODE)
	local finalHeroMoveToLoc1 = {x = hero.x, y = hero.y-4096*FRACUNIT, z = hero.z}
	OBJECT:moveTo(hero, finalHeroMoveToLoc1, 55*FRACUNIT)
	OBJECT:setPosition(hero, {x = 2304*FRACUNIT, y = -5632*FRACUNIT, z = -1024*FRACUNIT})
	CAMERA:SetEye(server, {x = 2624*FRACUNIT, y = -5472*FRACUNIT, z = -900*FRACUNIT, angle = OBJECT:lookAt(camera, hero)}, 0)
	CAMERA:UnsetEye(server, 0)
	SOUND:PlaySFX(nil, sfx_s3k4e)
	SOUND:PlaySFX(nil, sfx_splish)
	SOUND:PlaySFX(nil, sfx_splish)
	local splish = P_SpawnMobj(hero.x, hero.y, hero.z, MT_SPLISH)
	OBJECT:setscale(splish, 5*FRACUNIT)
	P_StartQuake(64*FRACUNIT, 5)
	OBJECT:moveTo(hero, {x = -1408*FRACUNIT, y = -2912*FRACUNIT, z = 1024*FRACUNIT}, 55*FRACUNIT, {arc = {y = -1500*FRACUNIT}, angle = OBJECT:lookAt(camera, {x = -1408*FRACUNIT, y = -2912*FRACUNIT})})
	CAMERA:SetEye(server, {x = 736*FRACUNIT, y = -3200*FRACUNIT, z = 1024*FRACUNIT, angle = OBJECT:lookAt(camera, hero)}, 0)
	CAMERA:UnsetEye(server, 0)
	local finalHeroMoveToFinalLoc = TASK:Regist(function()
		while true do
			if hero.valid then
				OBJECT:moveTo(hero, {x = -1760*FRACUNIT, y = 8544*FRACUNIT, z = 4096*FRACUNIT}, 28*FRACUNIT, {arc = {z = 1500*FRACUNIT}, angle = OBJECT:lookAt(camera, {x = -1760*FRACUNIT, y = 8544*FRACUNIT})})
			end
			wait(0)
		end
	end)
	wait(140)
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = true, dest = 10, Time = 14, pic = "bfill"})
	end
	wait(3*TICRATE)
	TASK:Destroy(finalHeroMoveToFinalLoc)
	TASK:Destroy(star_shipGlow)
	TASK:Destroy(cameraLookAtFinalHero)
	TASK:Destroy(starGatherAfterImage)
	wait(6*TICRATE)
	TASK:Destroy(forceShowhud)
	sugoi.ExitLevel(internalmaps("GEN_MAP_BOSS_STARS"), 1)

	--[[local characterName = ""
	if (player.mo.skin = "sonic") then
		characterName = "Sonic the Hedgehog"
	elseif (player.mo.skin = "tails") then
		characterName = "Sonic the Hedgehog"
	else]]
	--End of scene
	--print("<End of event>")
end)


event.newevent("DemoEvent",
function(mo,v)
	local STAR_GEN = mo
	--while true
	--[[
	wait(88)
	-ACT:startSprAnim(mo, SPRITE("genesis_StartupClosed"), 0, 6, 8, false)
	for player in players.iterate do
		CAMERA:override(player, true)
		player.awayviewmobj = server.mo.cam
		player.awayviewtics = 9999--server.awayviewtics
		player.rTextStore = server.rTextStore
	end
	--Speak(v, "test", nil, "", "test", false)
	]]
	--wait(2)
	EVPAUSE.UPDATEPAUSEINFO(EVPAUSE.PauseInfoList["star_01d_entry"])
	local STAR_GEN_Spawnpoint = maplocation("MT_IIANASTAR_SPAWNPOINT")
	OBJECT:setPosition(STAR_GEN, {x = STAR_GEN_Spawnpoint.x, y = STAR_GEN_Spawnpoint.y, z = -1023*FRACUNIT})
	if (server.isdedicated) -- Salt: unfortunately, i have to skip this if in dedicated server too
		COM_BufInsertText(server, "exitlevel")
		return
	end
	for player in players.iterate do
		netgameCamOverride(player, server, {enabled = true})
		EVM_HUD["widescreen"].z_index = 48
		EVM_HUD["wipefade"].z_index = 999
		player.hudOptions.widescreen.enabled = true
		OBJECT:setPosition(player.mo, {x = 0, y = 0, z = -88*FRACUNIT})
		player.air.retmark.flags = $1|MF2_DONTDRAW
		player.air.retbox.flags = $1|MF2_DONTDRAW
		EVM_HUD["airmanHud"].z_index = -1
		player.hudOptions.hidden = true
		player.hudOptions.hideValue = 32
		EnemyHud("starlis").hide = true
	end
	local movingEye = P_SpawnMobj(server.mo.x, server.mo.y, server.mo.z, MT_STARGENESIS_PULL)
	movingEye.flags2 = $1|MF2_DONTDRAW
	CAMERA:SetEye(server, {x = 256*FRACUNIT, y = 256*FRACUNIT, z = -256*FRACUNIT, angle = FixedAngle(270*FRACUNIT)}, 20*FRACUNIT)
	CAMERA:UnsetEye(server, 20*FRACUNIT)
	local LookAtmovingEye = TASK:Regist(function()
		while true
			OBJECT:lookAt(server.awayviewmobj, movingEye, true)
			CAMERA:lookAtZ(server, movingEye, true)
			--server.awayviewmobj.angle = OBJECT:setAnglePoint(server.awayviewmobj, server.mo)
			wait(0)
		end
	end)
	SOUND:PlayBGM(player, Snd("BGM_EV_STARDREAM_INTRO"), false)
	wait(210) -- Remove if faulty
	--wait(64)
	local moveEyepoint = TASK:Regist(function()
		OBJECT:moveTo(movingEye, STAR_GEN_Spawnpoint, 4*FRACUNIT)
		signal("movegenesis_tospawn")
	end)
	local moveBossToSpawn = TASK:Regist(function()
		waitForSignal("movegenesis_tospawn")
		OBJECT:moveTo(STAR_GEN, STAR_GEN_Spawnpoint, 8*FRACUNIT, {tween = {0, FloatFixed("1")}})
	end)
	OBJECT:moveTo(server.mo.cam, maplocation("MAINFIELD_VIEWPOINT"), 4*FRACUNIT, {arc = {x = 128*FRACUNIT, z = -150*FRACUNIT}, tween = {0, FloatFixed("1")}})
	--print("preshow")
	TASK:Destroy(LookAtmovingEye)
	wait(135)
	--wait(120)
	ACT:startSprAnim(mo, SPRITE("gns_Demo_Closed"), A, A, 8, false)
	wait(3*TICRATE)
	for player in players.iterate do
		SOUND:PlayBGM(player, Snd("BGM_EV_STARDREAM"), true)
	end
	attachLoop("n_musicCheck", function() strgn_MusicLoop(nil, {BGM = "BGM_EV_STARDREAM"} )end)
	--Move Camera On first Open
	local gns_LeftSideView = {x = mo.x-0*FRACUNIT, y = mo.y-480*FRACUNIT, z = -260*FRACUNIT}
	CAMERA:SetEye(server, {x = gns_LeftSideView.x, y = gns_LeftSideView.y, z = gns_LeftSideView.z, angle = ANGLE_90}, 0)
	CAMERA:UnsetEye(server, 0)
	local function PanWingLeft()
		--print("move 1")
		OBJECT:moveTo(server.mo.cam, {x = gns_LeftSideView.x-512*FRACUNIT, y = gns_LeftSideView.y, z = gns_LeftSideView.z+512*FRACUNIT, angle = ANGLE_90}, 9*FRACUNIT, {arc = {x = -128*FRACUNIT}, tween = {0, 0}})
		signal("GotoPanRightSide")
	end
	SOUND:PlaySFX(nil, Snd("SE_KR_GROW"), 80)
	ACT:startSprAnim(mo, SPRITE("gns_Demo_OpenLeft01"), A, G, 3, false)
	local PanCameraLeftSide_Tsk = TASK:Regist(PanWingLeft)
	ACT:startSprAnim(mo, SPRITE("gns_Demo_OpenLeft02"), A, G, 5, false)
	waitSignal("GotoPanRightSide")
	--wait(70)
	TASK:Destroy(PanCameraLeftSide_Tsk)
	--Move Camera On second Open
	local gns_RightSideView = {x = mo.x+0*FRACUNIT, y = mo.y-480*FRACUNIT, z = -260*FRACUNIT}
	CAMERA:SetEye(server, {x = gns_RightSideView.x, y = gns_RightSideView.y, z = gns_RightSideView.z, angle = ANGLE_90}, 0)
	CAMERA:UnsetEye(server, 0)
	local function PanWingRight()
		--print("move 2")
		OBJECT:moveTo(server.mo.cam, {x = gns_RightSideView.x+512*FRACUNIT, y = gns_RightSideView.y, z = gns_RightSideView.z+512*FRACUNIT, angle = ANGLE_90}, 9*FRACUNIT, {arc = {x = 128*FRACUNIT}, tween = {0, 0}})
		signal("GotoPanBackToPlayer")
	end
	SOUND:PlaySFX(nil, Snd("SE_KR_GROW"), 80)
	ACT:startSprAnim(mo, SPRITE("gns_Demo_OpenRight01"), A, G, 3, false)
	local PanCameraRightSide_Tsk = TASK:Regist(PanWingRight)
	ACT:startSprAnim(mo, SPRITE("gns_Demo_OpenRight02"), A, G, 5, false)
	waitSignal("GotoPanBackToPlayer")
	TASK:Destroy(PanCameraRightSide_Tsk)
	--Move Camera On  fourth Open
	CAMERA:SetEye(server, {x = mo.x, y = mo.y-480*FRACUNIT, z = 256*FRACUNIT, angle = ANGLE_90}, 0)
	CAMERA:UnsetEye(server, 0)
	local LookAtBoss = TASK:Regist(function()
		while true
			OBJECT:lookAt(server.awayviewmobj, mo, true)
			CAMERA:lookAtZ(server, mo, true)
			wait(0)
		end
	end)
	local PanToCenterField = TASK:Regist(function()
		--print("move 4")
		S_StartSoundAtVolume(nil, sfx_wcut, 98)
		OBJECT:moveTo(server.mo.cam, maplocation("MAINFIELD_VIEWPOINT"), 6*FRACUNIT, {tween = {0, FRACUNIT}})
		--OBJECT:moveTo(server.mo.cam, {x = mo.x, y = mo.y-130*FRACUNIT, z = 0*FRACUNIT, angle = ANGLE_90}, 32*FRACUNIT, {tween = {0, FRACUNIT}})
	end)
	ACT:startSprAnim(STAR_GEN, SPRITE("gns_Demo_OpenMiddle01"), A, G, 4, false)
	local function ScreenWave()
		for i = 0,30, 1
			local c = OBJECT:CreateNew(MT_THOK, mo)
			local w = OBJECT:CreateNew(MT_WAVE_CIRC, mo)
			c.color = 3
			OBJECT:setscale(c, 32*FRACUNIT, 2*FRACUNIT)
			OBJECT:setscale(w, 38*FRACUNIT, 2*FRACUNIT)
			c.frame = 0|(8<<FF_TRANSSHIFT)
			wait(3)
		end
	end
	local function YellVibration()
		local i = 0
		while true do
			if (i > 3*TICRATE)
				break
			end
			i = i + 1
			P_StartQuake(3*FRACUNIT, 1, {0, 0, 0},0)
			wait(0)
		end
	end
	for player in players.iterate do
		OBJECT:setPosition(player.mo, {x = 0, y = 0, z = -88*FRACUNIT})
	end
	wait(4*7)
	ACT:startSprAnim(STAR_GEN, SPRITE("gns_Demo_Yell01"), A, G, 4, false)
	local ScreenWave_Tsk = TASK:Regist(ScreenWave)
	local YellVibration_Tsk = TASK:Regist(YellVibration)
	S_StartSoundAtVolume(nil, Snd("SE_EFF_LUNALA"), 100)
	ACT:startSprAnim(STAR_GEN, SPRITE("gns_Demo_Yell02_LP"), A, F, 2, 2*TICRATE)
	TASK:Destroy(ScreenWave_Tsk)
	TASK:Destroy(YellVibration_Tsk)
	ACT:startSprAnim(STAR_GEN, SPRITE("gns_Demo_Yell02_End"), A, G, 2, false)
	TASK:Destroy(LookAtBoss)
	CAMERA:SetEye(server, maplocation("MAINFIELD_VIEWPOINT"), 0)
	CAMERA:UnsetEye(server, 0)
	wait(3)
	for player in players.iterate do
		netgameCamOverride(player, server, {enabled = false})
		--EVM_HUD["wipefade"].z_index = -1
		player.hudOptions.widescreen.enabled = false
		player.air.retmark.flags = $1&~MF2_DONTDRAW
		player.air.retbox.flags = $1&~MF2_DONTDRAW
		EVM_HUD["airmanHud"].z_index = 45
		SOUND:PlaySFX(nil, Snd("SE_KR_METER"), 100, player)
		player.awayviewmobj = player.mo.cam
		player.hudOptions.hidden = false
		EnemyHud("starlis").hide = false
		--AirMan.Init(player)
		--AirMan.Enable(player)
	end
	mo.hpfill.steps = 24
	mo.hpfill.enabled = true
	event.beginEvent("genesis_entrypoint", mo, mo)
	wait(0)
end)

event.newevent("genesis_entrypoint",
function(mo,v)
	--MAIN STATE MACHINE
	--TODO begin demo on this line and end it here; set a flag to prevent it from playing again
	--TODO: Star field movement or particle spawner object thinker
	--TODO: Be able to interrupt animations (SOLVED - hook events into mo and end them)
	--TODO: events for every attack phase
	--event.beginEvent("genesis_bossChecker", mo, mo.EVENTHOOKS)
	mo.name = "Star Genesis"
	event.beginEvent("genesis_bossChecker", mo)
	event.beginEvent("genesis_synth1", mo, mo.events)
end)

event.newevent("genesis_synth1",
function(mo,v)
	local STAR_GEN = mo
	local p1, p2, p3, p4, p5, p6, p7 = star_CreateSynthPoints()
	local newLocation = {}

	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1*TICRATE)
	ACT:startSprAnim(mo, SPRITE("gns_SynthesisExecute"), A, G, 3, false)
	SOUND:PlaySFX(nil, Snd("SE_KR_LAS2"), 90)
	local h1, h2, h5, h6 = OBJECT:CreateObjects(
		{obj = MT_STARHOLE, loc = p1},
		{obj = MT_STARHOLE, loc = p2},
		{obj = MT_STARHOLE, loc = p5},
		{obj = MT_STARHOLE, loc = p6})
	OBJECT:setgroupscale({h1, h2, h5, h6}, 0)
	OBJECT:setgroupscale({h1, h2, h5, h6}, 2*FRACUNIT/2, FloatFixed("0.09"))
	--ACT:startSprAnim(mo, SPRITE("genesis_SynthesisHold"), 0, 2, 3, false)
	--ACT:startSprAnim(mo, SPRITE("genesis_SynthesisEnd"), 0, 3, 3, false)
	local Fire = TASK:Regist(function()
		ShootPlayersFromSpotsRandomly({p1, p2, p5, p6}, MT_STARHOLE_BULLET, 6, 1)
		OBJECT:setgroupscale({h1, h2, h5, h6}, 0, FloatFixed("0.06"))
	end)
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1*TICRATE)
	TASK:Destroy(Fire)
	OBJECT:DestroyObjects({h1, h2, h5, h6})
	ACT:startSprAnim(mo, SPRITE("gns_Move"), A, E, 4, false, true)
	newLocation = {x = 450*FRACUNIT, y = 832*FRACUNIT, z = maplocation("GNS_SPAWNPOINT").z, angle = ANGLE_90}
	genesis_Teleport(STAR_GEN, newLocation, {speed = 1, waitTime = 25})
	--OBJECT:moveTo(mo, {x = 450*FRACUNIT, y = 832*FRACUNIT, z = mo.z, angle = ANGLE_90},16*FRACUNIT, {tween = {FloatFixed("0.122"), FloatFixed("0.98")}, arc = {x = 0, y = 110*FRACUNIT, z = 0}})
	ACT:startSprAnim(mo, SPRITE("gns_SynthesisExecute"), A, G, 3, false)
	SOUND:PlaySFX(nil, Snd("SE_KR_LAS2"), 90)
	local h1, h3, h5, h7 = OBJECT:CreateObjects(
		{obj = MT_STARHOLE, loc = p1},
		{obj = MT_STARHOLE, loc = p3},
		{obj = MT_STARHOLE, loc = p5},
		{obj = MT_STARHOLE, loc = p7})
	OBJECT:setgroupscale({h1, h3, h5, h7}, 0)
	OBJECT:setgroupscale({h1, h3, h5, h7}, 2*FRACUNIT/2, FloatFixed("0.09"))
	-->Attack Here<--
	local Fire = TASK:Regist(function()
		ShootPlayersFromSpotsRandomly({p1, p3, p5, p7}, MT_STARHOLE_BULLET, 6, 1)
		OBJECT:setgroupscale({h1, h3, h5, h7}, 0, FloatFixed("0.06"))
	end)
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1*TICRATE)
	TASK:Destroy(Fire)
	OBJECT:DestroyObjects({h1, h3, h5, h7})
	newLocation = {x = -450*FRACUNIT, y = 832*FRACUNIT, z = maplocation("GNS_SPAWNPOINT").z, angle = ANGLE_90}
	genesis_Teleport(STAR_GEN, newLocation, {speed = 1, waitTime = 15})
	--ACT:startSprAnim(mo, SPRITE("genesis_MoveF"), 0, 3, 4, false, true)
	--OBJECT:moveTo(mo, {x = -450*FRACUNIT, y = 832*FRACUNIT, z = mo.z, angle = ANGLE_90}, 32*FRACUNIT, {tween = {FloatFixed("0.122"), FloatFixed("0.98")}, arc = {x = 0, y = 110*FRACUNIT, z = 0}})
	ACT:startSprAnim(mo, SPRITE("gns_SynthesisExecute"), A, G, 3, false)
	SOUND:PlaySFX(nil, Snd("SE_KR_LAS2"), 90)
	local h2, h4, h6, h7 = OBJECT:CreateObjects(
		{obj = MT_STARHOLE, loc = p2},
		{obj = MT_STARHOLE, loc = p4},
		{obj = MT_STARHOLE, loc = p6},
		{obj = MT_STARHOLE, loc = p7})
	OBJECT:setgroupscale({h2, h4, h6, h7}, 0)
	OBJECT:setgroupscale({h2, h4, h6, h7}, 2*FRACUNIT/2, FloatFixed("0.09"))
	--ACT:startSprAnim(mo, SPRITE("genesis_SynthesisHold"), 0, 2, 3, false)
	--ACT:startSprAnim(mo, SPRITE("genesis_SynthesisEnd"), 0, 3, 3, false)
	-->Attack Here<--
	local Fire = TASK:Regist(function()
		ShootPlayersFromSpotsRandomly({p2, p4, p6, p7}, MT_STARHOLE_BULLET, 6, 1)
		OBJECT:setgroupscale({h2, h4, h6, h7}, 0, FloatFixed("0.06"))
	end)
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1*TICRATE)
	TASK:Destroy(Fire)
	OBJECT:DestroyObjects({h2, h4, h6, h7})
	newLocation = {x = maplocation("GNS_SPAWNPOINT").x, y = maplocation("GNS_SPAWNPOINT").y, z = maplocation("GNS_SPAWNPOINT").z, angle = ANGLE_90}
	genesis_Teleport(STAR_GEN, newLocation, {speed = 1, waitTime = 15})
	--ACT:startSprAnim(mo, SPRITE("genesis_MoveF"), 0, 3, 4, false, true)
	--OBJECT:moveTo(mo, maplocation("MT_IIANASTAR_SPAWNPOINT"), 18*FRACUNIT, {tween = {FloatFixed("0.122"), FloatFixed("0.98")}, arc = {x = 0, y = 198*FRACUNIT, z = 0}})
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9)
	ACT:startSprAnim(mo, SPRITE("gns_SynthesisExecute"), A, G, 3, false)
	SOUND:PlaySFX(nil, Snd("SE_KR_LAS2"), 90)
	local h1, h2, h3, h4, h7 = OBJECT:CreateObjects(
		{obj = MT_STARHOLE, loc = p1},
		{obj = MT_STARHOLE, loc = p2},
		{obj = MT_STARHOLE, loc = p3},
		{obj = MT_STARHOLE, loc = p4},
		{obj = MT_STARHOLE, loc = p7})
	OBJECT:setgroupscale({h1, h2, h3, h4, h7}, 0)
	OBJECT:setgroupscale({h1, h2, h3, h4, h7}, 2*FRACUNIT/2, FloatFixed("0.09"))
	--ACT:startSprAnim(mo, SPRITE("genesis_SynthesisHold"), 0, 2, 3, false)
	--ACT:startSprAnim(mo, SPRITE("genesis_SynthesisEnd"), 0, 3, 3, false)
	-->Attack Here<--
	local Fire = TASK:Regist(function()
		ShootPlayersFromSpotsRandomly({p1, p2, p3, p4, p7}, MT_STARHOLE_BULLET, 6, 1)
		OBJECT:setgroupscale({h1, h2, h3, h4, h7}, 0, FloatFixed("0.06"))
	end)
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1*TICRATE)
	TASK:Destroy(Fire)
	OBJECT:DestroyObjects({h1, h2, h3, h4, h7})
	star_RemoveSynthPoints({p1, p2, p3, p4, p5, p6, p7})
	--wait(90)
	TASK:Destroy(mo.events["genesis_synth1"])
	event.beginEvent("genesis_starport1", mo, mo.events)

end)

event.newevent("genesis_starport1",
function(mo,v)
	local STAR_GEN = mo
	local newLocation = {}

	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1*TICRATE)
	newLocation = {x = 0, y = maplocation("GNS_SPAWNPOINT").y+512*FRACUNIT, z = maplocation("GNS_SPAWNPOINT").z, angle = ANGLE_90}
	genesis_Teleport(STAR_GEN, newLocation, {speed = 1, waitTime = 18})
	--ACT:startSprAnim(mo, SPRITE("genesis_MoveF"), 0, 3, 3, false, true)
	--OBJECT:moveTo(mo, {x = 255*FRACUNIT, y = 832*FRACUNIT, z = mo.z, angle = ANGLE_90}, 12*FRACUNIT, {tween = {FloatFixed("0.122"), FloatFixed("0.98")}, arc = {x = 0, y = 18*FRACUNIT, z = 0}})
	--ACT:startSprAnim(mo, SPRITE("genesis_IdleF"), 0, 3, 9, 2*TICRATE/2)
	--ACT:startSprAnim(mo, SPRITE("genesis_MoveF"), 0, 3, 3, false, true)
	--OBJECT:moveTo(mo, maplocation("MT_IIANASTAR_SPAWNPOINT"), 12*FRACUNIT, {tween = {FloatFixed("0.122"), FloatFixed("0.98")}, arc = {x = 0, y = 16*FRACUNIT, z = 0}})
	--ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1*TICRATE)
	--OBJECT:moveTo(mo, {x = 0, y = 1060*FRACUNIT, z = mo.z, angle = ANGLE_90}, 12*FRACUNIT, {tween = {FloatFixed("0.122"), FloatFixed("0.98")}, arc = {x = 0, y = 0, z = -64*FRACUNIT}})
	ACT:startSprAnim(mo, SPRITE("gns_AnyAction"), A, G, 3, false)
	--ACT:startSprAnim(mo, SPRITE("genesis_StarPortStart"), 0, 4, 3, false)
	--ACT:startSprAnim(mo, SPRITE("genesis_StarPortHold"), 0, 0, 3, false)
	--ACT:startSprAnim(mo, SPRITE("genesis_StarPortEnd"), 0, 3, 3, false)
	-->Attack Here<--
	S_StartSoundAtVolume(nil, Snd("SE_EFF_STARPORTAL"), 100)
	local StarPortR1 = TASK:Regist(function()
		genesis_createStarPort(mo,
		{obj = MT_STARHOLE, loc = {x = -512*FRACUNIT, y = 600*FRACUNIT, z = 256*FRACUNIT},
			mine = {obj = MT_MINESOARER, loc = {x = -512*FRACUNIT, y = 600*FRACUNIT, z = 256*FRACUNIT},
				points = {
					{obj = MT_ALTVIEWMAN, loc = {x = -245*FRACUNIT, y = 420*FRACUNIT, z = 30*FRACUNIT, angle = ANGLE_90, speed = 8*FRACUNIT, arc = {x = 0, y = 0, z = -2*FRACUNIT}}},
					{obj = MT_ALTVIEWMAN, loc = {x = -32*FRACUNIT, y = 0*FRACUNIT, z = 30*FRACUNIT, angle = ANGLE_90, speed = 2*FRACUNIT}}
				}},
		},
		{obj = MT_STARHOLE, loc = {x = 512*FRACUNIT, y = 600*FRACUNIT, z = 256*FRACUNIT},
			mine = {obj = MT_MINESOARER, loc = {x = 512*FRACUNIT, y = 600*FRACUNIT, z = 256*FRACUNIT},
				points = {
					{obj = MT_ALTVIEWMAN, loc = {x = 245*FRACUNIT, y = 420*FRACUNIT, z = 30*FRACUNIT, angle = ANGLE_90, speed = 8*FRACUNIT, arc = {x = 0, y = 0, z = -2*FRACUNIT}}},
					{obj = MT_ALTVIEWMAN, loc = {x = 32*FRACUNIT, y = 0*FRACUNIT, z = 30*FRACUNIT, angle = ANGLE_90, speed = 2*FRACUNIT}}
				}},
		})
	end)
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1*TICRATE)
	--TASK:Destroy(mo.events["genesis_starport1"])
	event.beginEvent("genesis_synth2", mo, mo.events)
end)

event.newevent("genesis_synth2",
function(mo,v)
	local STAR_GEN = mo
	local newLocation = {}
	--ACT:startSprAnim(mo, SPRITE("genesis_MoveF"), 0, 3, 4, false, true)
	--OBJECT:moveTo(mo, {x = -200*FRACUNIT, y = 832*FRACUNIT, z = 0*FRACUNIT, angle = ANGLE_90}, 32*FRACUNIT, {arc = {x = 0, y = 32*FRACUNIT, z = 0}})
	--ACT:startSprAnim(mo, SPRITE("genesis_IdleF"), 0, 3, 9, 3*TICRATE)
	newLocation = {x = 0*FRACUNIT, y = 832*FRACUNIT, z = 0*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(STAR_GEN, newLocation, {speed = 1, waitTime = 18})
	--ACT:startSprAnim(mo, SPRITE("genesis_MoveF"), 0, 3, 4, false, true)
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1*TICRATE)
	wait(15)
	newLocation = {x = 320*FRACUNIT, y = 832*FRACUNIT, z = 54*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(STAR_GEN, newLocation, {speed = 1, waitTime = 18})
	--OBJECT:moveTo(mo, {x = 320*FRACUNIT, y = 832*FRACUNIT, z = 54*FRACUNIT, angle = ANGLE_90}, 32*FRACUNIT, {arc = {x = 0, y = 32*FRACUNIT, z = 0}})
	--ACT:startSprAnim(mo, SPRITE("genesis_IdleF"), 0, 3, 9, 3*TICRATE)
	--ACT:startSprAnim(mo, SPRITE("genesis_MoveF"), 0, 3, 4, false, true)
	wait(15)
	newLocation = {x = -320*FRACUNIT, y = 832*FRACUNIT, z = 0*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(STAR_GEN, newLocation, {speed = 1, waitTime = 18})
	--OBJECT:moveTo(mo, {x = 0*FRACUNIT, y = 832*FRACUNIT, z = 0*FRACUNIT, angle = ANGLE_90}, 32*FRACUNIT, {arc = {x = 0, y = 32*FRACUNIT, z = 0}})
	wait(15)
	newLocation = {x = 0*FRACUNIT, y = 832*FRACUNIT, z = 0*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(STAR_GEN, newLocation, {speed = 1, waitTime = 18})
	local p1, p2, p3, p4, p5, p6, p7 = star_CreateSynthPoints()
	--ACT:startSprAnim(mo, SPRITE("genesis_SynthesizeStart"), 0, 3, 3, false)
	SOUND:PlaySFX(nil, Snd("SE_KR_LAS2"), 90)
	local h1, h2, h3, h4 = OBJECT:CreateObjects(
		{obj = MT_STARHOLE, loc = p1},
		{obj = MT_STARHOLE, loc = p2},
		{obj = MT_STARHOLE, loc = p3},
		{obj = MT_STARHOLE, loc = p4})
	OBJECT:setgroupscale({h1, h2, h3, h4}, 0)
	OBJECT:setgroupscale({h1, h2, h3, h4}, 2*FRACUNIT/2, FloatFixed("0.09"))
	ACT:startSprAnim(mo, SPRITE("gns_SynthesisExecute"), A, G, 3, false)
	--ACT:startSprAnim(mo, SPRITE("genesis_SynthesisHold"), 0, 2, 3, false)
	--ACT:startSprAnim(mo, SPRITE("genesis_SynthesisEnd"), 0, 3, 3, false)
	-->Attack Here<--
	local Fire = TASK:Regist(function()
		ShootPlayersFromSpotsRandomly({p1, p2, p3, p4}, MT_STARHOLE_BULLET, 25, 1)
		OBJECT:setgroupscale({h1, h2, h3, h4}, 0, FloatFixed("0.06"))
	end)
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1*TICRATE)
	--ACT:startSprAnim(mo, SPRITE("genesis_IdleF"), 0, 3, 9, 2*TICRATE/2)
	TASK:Destroy(Fire)
	OBJECT:DestroyObjects({h1, h2, h3, h4})
	star_RemoveSynthPoints({p1, p2, p3, p4, p5, p6, p7})
	TASK:Destroy(mo.events["genesis_synth2"])
	event.beginEvent("genesis_starport2", mo, mo.events)
end)

event.newevent("genesis_starport2",
function(mo,v)
	local STAR_GEN = mo
	local newLocation = {}
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1*TICRATE)
	--ACT:startSprAnim(mo, SPRITE("genesis_IdleF"), 0, 3, 9, 1)
	newLocation = {x = -520*FRACUNIT, y = 832*FRACUNIT, z = 0*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(STAR_GEN, newLocation, {speed = 1, waitTime = 24})
	--OBJECT:moveTo(mo, {x = -520*FRACUNIT, y = 832*FRACUNIT, z = 0*FRACUNIT, angle = ANGLE_90}, 32*FRACUNIT, {arc = {x = 0, y = 32*FRACUNIT, z = 0}})
	ACT:startSprAnim(mo, SPRITE("gns_AnyAction"), A, G, 3, false)
	--ACT:startSprAnim(mo, SPRITE("genesis_StarPortStart"), 0, 4, 3, false)
	S_StartSoundAtVolume(nil, Snd("SE_EFF_STARPORTAL"), 100)
	local StarPortR1 = TASK:Regist(function()
		genesis_createStarPort(mo,
		{obj = MT_STARHOLE, loc = {x = 520*FRACUNIT, y = 600*FRACUNIT, z = 256*FRACUNIT},
			mine = {obj = MT_MINESOARER, loc = {x = 520*FRACUNIT, y = 600*FRACUNIT, z = 256*FRACUNIT},
				points = {
					{obj = MT_ALTVIEWMAN, loc = {x = 245*FRACUNIT, y = 420*FRACUNIT, z = 30*FRACUNIT, angle = ANGLE_90, speed = 8*FRACUNIT, arc = {x = 0, y = 0, z = -2*FRACUNIT}}},
					{obj = MT_ALTVIEWMAN, loc = {x = -128*FRACUNIT, y = 0*FRACUNIT, z = 64*FRACUNIT, angle = ANGLE_90, speed = 2*FRACUNIT}}
				}},
		})
	end)
	--ACT:startSprAnim(mo, SPRITE("genesis_StarPortHold"), 0, 0, 3, 2*TICRATE)
	--ACT:startSprAnim(mo, SPRITE("genesis_StarPortEnd"), 0, 3, 3, false)
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1)
	--ACT:startSprAnim(mo, SPRITE("genesis_IdleF"), 0, 3, 9, 3)
	newLocation = {x = 520*FRACUNIT, y = 832*FRACUNIT, z = 0*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(STAR_GEN, newLocation, {speed = 1, waitTime = 24})
	--OBJECT:moveTo(mo, {x = 520*FRACUNIT, y = 832*FRACUNIT, z = 0*FRACUNIT, angle = ANGLE_90}, 32*FRACUNIT, {arc = {x = 0, y = 32*FRACUNIT, z = 0}})
	ACT:startSprAnim(mo, SPRITE("gns_AnyAction"), A, G, 3, false)
	--ACT:startSprAnim(mo, SPRITE("genesis_StarPortStart"), 0, 4, 3, false)
	S_StartSoundAtVolume(nil, Snd("SE_EFF_STARPORTAL"), 100)
	local StarPortR2 = TASK:Regist(function()
		genesis_createStarPort(mo,
		{obj = MT_STARHOLE, loc = {x = -520*FRACUNIT, y = 600*FRACUNIT, z = 256*FRACUNIT},
			mine = {obj = MT_MINESOARER, loc = {x = -520*FRACUNIT, y = 600*FRACUNIT, z = 256*FRACUNIT},
				points = {
					{obj = MT_ALTVIEWMAN, loc = {x = -245*FRACUNIT, y = 420*FRACUNIT, z = 30*FRACUNIT, angle = ANGLE_90, speed = 8*FRACUNIT, arc = {x = 0, y = 0, z = -2*FRACUNIT}}},
					{obj = MT_ALTVIEWMAN, loc = {x = 128*FRACUNIT, y = 0*FRACUNIT, z = -64*FRACUNIT, angle = ANGLE_90, speed = 2*FRACUNIT}}
				}},
		})
	end)
	--ACT:startSprAnim(mo, SPRITE("genesis_StarPortHold"), 0, 0, 3, 2*TICRATE)
	--ACT:startSprAnim(mo, SPRITE("genesis_StarPortEnd"), 0, 3, 3, false)
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1)
	newLocation = maplocation("GNS_SPAWNPOINT")
	genesis_Teleport(STAR_GEN, newLocation, {speed = 1, waitTime = 24})
	--ACT:startSprAnim(mo, SPRITE("genesis_IdleF"), 0, 3, 9, 3)
	TASK:Destroy(mo.events["genesis_starport2"])
	event.beginEvent("genesis_synth1", mo, mo.events)
end)

event.newevent("genesis_MidpointDemo",
function(mo,v)
	local STAR_GEN = mo
	local newLocation = {}
	newLocation = maplocation("GNS_SPAWNPOINT")
	wait(25)
	genesis_Teleport(STAR_GEN, newLocation, {speed = 1, waitTime = 20})
	local function ScreenWave()
		for i = 0,30, 1
			local c = OBJECT:CreateNew(MT_THOK, mo)
			local w = OBJECT:CreateNew(MT_WAVE_CIRC, mo)
			c.color = 3
			OBJECT:setscale(c, 32*FRACUNIT, 2*FRACUNIT)
			OBJECT:setscale(w, 38*FRACUNIT, 2*FRACUNIT)
			c.frame = 0|(8<<FF_TRANSSHIFT)
			wait(3)
		end
	end
	local function YellVibration()
		local i = 0
		while true do
			if (i > 3*TICRATE)
				break
			end
			i = i + 1
			P_StartQuake(3*FRACUNIT, 1, {0, 0, 0},0)
			wait(0)
		end
	end
	for player in players.iterate do
		--OBJECT:setPosition(player.mo, {x = 0, y = 0, z = -88*FRACUNIT})
	end
	wait(4*7)
	ACT:startSprAnim(STAR_GEN, SPRITE("gns_Demo_Yell01"), A, G, 4, false)
	local ScreenWave_Tsk = TASK:Regist(ScreenWave)
	local YellVibration_Tsk = TASK:Regist(YellVibration)
	S_StartSoundAtVolume(nil, Snd("SE_EFF_LUNALA"), 100)
	ACT:startSprAnim(STAR_GEN, SPRITE("gns_Demo_Yell02_LP"), A, F, 2, 2*TICRATE)
	TASK:Destroy(ScreenWave_Tsk)
	TASK:Destroy(YellVibration_Tsk)
	ACT:startSprAnim(STAR_GEN, SPRITE("gns_Demo_Yell02_End"), A, G, 2, false)
	local DustField = OBJECT:Find(MT_DUSTSPAWNER)
	DustField.state = S_DUSTSPAWN1
	wait(5)
	event.beginEvent("genesis_hyperset1", mo, mo.events)
	--event.beginEvent("genesis_solarbeam", mo, mo.events)
end)

--event.newevent("genesis_solarbeam",
--function(mo,v)
local function genesis_hyperset_solarbeam(mo, overrideFirePosition)
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1)
	--ACT:startSprAnim(mo, SPRITE("genesis_IdleF"), 0, 3, 9, 0)

	local function CameraZoom()
		for player in players.iterate do
			CAMERA:override(player, true, true)
			OBJECT:setPosition(server.mo.cam, maplocation("MAINFIELD_VIEWPOINT"))
			CAMERA:SetEye(server, maplocation("MAINFIELD_VIEWPOINT"), 0)
			CAMERA:UnsetEye(server, 0)
			server.mo.cam.angle = ANGLE_90
			player.awayviewmobj = server.mo.cam
			player.awayviewtics = 9999
			server.awayviewtics = 9999
		end
		OBJECT:moveTo(server.mo.cam, {x = 0*FRACUNIT, y = -200*FRACUNIT, z = 0*FRACUNIT, angle = ANGLE_90}, FloatFixed("0.5"))
	end
	ACT:startSprAnim(mo, SPRITE("gns_SolarBeamStart"), A, E, 4, false)
	local CameraZoom_RUN = TASK:Regist(CameraZoom)
	ACT:startSprAnim(mo, SPRITE("gns_SolarBeamSpin"), A, G, 6, false)
	ACT:startSprAnim(mo, SPRITE("gns_SolarBeamSpin"), A, G, 2, false)
	SOUND:PlaySFX(nil, Snd("SE_KR_LASERCHARGE"), 100)
	if (overrideFirePosition) then
		genesis_FireSolarBeam(mo, overrideFirePosition.startLoc, overrideFirePosition.endLoc)
	else
		genesis_FireSolarBeam(mo, {x = 0, y = -800*FRACUNIT, z = 800*FRACUNIT}, {x = 0, y = -800*FRACUNIT, z = -800*FRACUNIT})
	end
	--[[genesis_FireMultiSolarBeam(mo, {fireStart = {x = 0, y = -800*FRACUNIT, z = 800*FRACUNIT},
									fireEnd = {x = 0, y = -800*FRACUNIT, z = -800*FRACUNIT}},
										{fireStart = {x = 453*FRACUNIT, y = -800*FRACUNIT, z = 800*FRACUNIT},
										fireEnd = {x = -454*FRACUNIT, y = -800*FRACUNIT, z = -800*FRACUNIT}})]]
	ACT:startSprAnim(mo, SPRITE("gns_SolarBeamSpin_LP"), A, G, 1, 10*TICRATE)
	ACT:startSprAnim(mo, SPRITE("gns_SolarBeamSpin"), A, G, 4, 1)
	ACT:startSprAnim(mo, SPRITE("gns_SolarBeamSpin"), A, G, 6, 1)
	ACT:startSprAnim(mo, SPRITE("gns_SolarBeamEnd"), A, E, 3, false)
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1)
	--ACT:startSprAnim(mo, SPRITE("genesis_IdleF"), 0, 3, 9)
	--event.beginEvent("genesis_hyperset1", mo, mo.events)
end
--end)

local function genesis_hyperset_synth1(mo)
	local STAR_GEN = mo
	local newLocation = {}
	local randSpotHorz = 0
	local randSpotVert = 0
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1)
	--ACT:startSprAnim(mo, SPRITE("genesis_IdleF"), 0, 3, 9, 1)
	newLocation = {x = 345*FRACUNIT, y = 832*FRACUNIT, z = 0*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {speed = 1, waitTime = 18})
	genesis_execQuickSynth(mo, {loc = {x = -320*FRACUNIT, y = 720*FRACUNIT, z = 400*FRACUNIT}},
						{loc = {x = -320*FRACUNIT, y = 720*FRACUNIT, z = 200*FRACUNIT}},
						{loc = {x = -320*FRACUNIT, y = 720*FRACUNIT, z = -200*FRACUNIT}},
						{loc = {x = -320*FRACUNIT, y = 720*FRACUNIT, z = -400*FRACUNIT}})

	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1)
	wait(15)
	newLocation = {x = -434*FRACUNIT, y = 832*FRACUNIT, z = -206*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {speed = 1, waitTime = 18})
	genesis_execQuickSynth(mo, {loc = {x = -220*FRACUNIT, y = 720*FRACUNIT, z = 400*FRACUNIT}},
						{loc = {x = 0*FRACUNIT, y = 720*FRACUNIT, z = 400*FRACUNIT}},
						{loc = {x = 232*FRACUNIT, y = 720*FRACUNIT, z = 256*FRACUNIT}},
						{loc = {x = 438*FRACUNIT, y = 720*FRACUNIT, z = 0*FRACUNIT}},
						{loc = {x = 450*FRACUNIT, y = 720*FRACUNIT, z = -256*FRACUNIT}})
	wait(15)
	newLocation = {x = 342*FRACUNIT, y = 832*FRACUNIT, z = -350*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {speed = 1, waitTime = 18})
	genesis_execQuickSynth(mo, {loc = {x = -320*FRACUNIT, y = 720*FRACUNIT, z = 400*FRACUNIT}},
						{loc = {x = -256*FRACUNIT, y = 720*FRACUNIT, z = 200*FRACUNIT}},
						{loc = {x = -128*FRACUNIT, y = 720*FRACUNIT, z = 0*FRACUNIT}},
						{loc = {x = -256*FRACUNIT, y = 720*FRACUNIT, z = -200*FRACUNIT}},
						{loc = {x = -128*FRACUNIT, y = 720*FRACUNIT, z = -400*FRACUNIT}})
	wait(15)
	newLocation = {x = 0*FRACUNIT, y = 832*FRACUNIT, z = 456*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {speed = 1, waitTime = 18})
	genesis_execQuickSynth(mo, {loc = {x = -480*FRACUNIT, y = 720*FRACUNIT, z = -256*FRACUNIT}},
						{loc = {x = -256*FRACUNIT, y = 720*FRACUNIT, z = -280*FRACUNIT}},
						{loc = {x = -0*FRACUNIT, y = 720*FRACUNIT, z = -320*FRACUNIT}},
						{loc = {x = 256*FRACUNIT, y = 720*FRACUNIT, z = -280*FRACUNIT}},
						{loc = {x = 480*FRACUNIT, y = 720*FRACUNIT, z = -256*FRACUNIT}})
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1)
	--ACT:startSprAnim(mo, SPRITE("genesis_IdleF"), 0, 3, 5)
	randSpotHorz = P_RandomRange(-450, 450)
	randSpotVert = P_RandomRange(-256, 256)
	newLocation = {x = randSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y, z = randSpotVert*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {speed = 1, waitTime = 4})
	randSpotHorz = P_RandomRange(-450, 450)
	randSpotVert = P_RandomRange(-256, 256)
	newLocation = {x = randSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y, z = randSpotVert*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {speed = 1, waitTime = 4})
	randSpotHorz = P_RandomRange(-450, 450)
	randSpotVert = P_RandomRange(-256, 256)
	newLocation = {x = randSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y, z = randSpotVert*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {speed = 1, waitTime = 4})
	randSpotHorz = P_RandomRange(-450, 450)
	randSpotVert = P_RandomRange(-256, 256)
	newLocation = {x = randSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y, z = randSpotVert*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {speed = 1, waitTime = 4})
	--genesis_Teleport(mo, {x = 234*FRACUNIT, y = 832*FRACUNIT, z = 241*FRACUNIT, angle = ANGLE_90}, {speed = 1, waitTime = 4})
	--genesis_Teleport(mo, {x = -325*FRACUNIT, y = 832*FRACUNIT, z = 352*FRACUNIT, angle = ANGLE_90}, {speed = 1, waitTime = 4})
	--genesis_Teleport(mo, {x = 347*FRACUNIT, y = 832*FRACUNIT, z = 52*FRACUNIT, angle = ANGLE_90}, {speed = 1, waitTime = 4})
	--genesis_Teleport(mo, {x = 0*FRACUNIT, y = 832*FRACUNIT, z = -45*FRACUNIT, angle = ANGLE_90}, {speed = 1, waitTime = 4})
	genesis_execQuickSynth(mo, {loc = {x = -480*FRACUNIT, y = 720*FRACUNIT, z = -256*FRACUNIT}},
						{loc = {x = -256*FRACUNIT, y = 720*FRACUNIT, z = -280*FRACUNIT}},
						{loc = {x = -0*FRACUNIT, y = 720*FRACUNIT, z = -320*FRACUNIT}},
						{loc = {x = 256*FRACUNIT, y = 720*FRACUNIT, z = -280*FRACUNIT}},
						{loc = {x = 480*FRACUNIT, y = 720*FRACUNIT, z = -256*FRACUNIT}},
						{loc = {x = -480*FRACUNIT, y = 720*FRACUNIT, z = 256*FRACUNIT}},
						{loc = {x = -256*FRACUNIT, y = 720*FRACUNIT, z = 280*FRACUNIT}},
						{loc = {x = -0*FRACUNIT, y = 720*FRACUNIT, z = 320*FRACUNIT}},
						{loc = {x = 256*FRACUNIT, y = 720*FRACUNIT, z = 280*FRACUNIT}},
						{loc = {x = 480*FRACUNIT, y = 720*FRACUNIT, z = 256*FRACUNIT}})
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1)
	--ACT:startSprAnim(mo, SPRITE("genesis_IdleF"), 0, 3, 9)
end

local function genesis_hyperset_StarPortMove1(mo)
	genesis_Teleport(mo, {x = 0*FRACUNIT, y = 832*FRACUNIT, z = 0*FRACUNIT, angle = ANGLE_90}, {speed = 1, waitTime = 8})
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1)
	--ACT:startSprAnim(mo, SPRITE("genesis_IdleF"), 0, 3, 9)
	genesis_Teleport(mo, {x = -256*FRACUNIT, y = 832*FRACUNIT, z = 0*FRACUNIT, angle = ANGLE_90}, {speed = 1, waitTime = 8})
	S_StartSoundAtVolume(nil, Snd("SE_EFF_STARPORTAL"), 100)
	local StarPortR2 = TASK:Regist(function()
		genesis_createStarPort(mo,
		{obj = MT_STARHOLE, loc = {x = -520*FRACUNIT, y = 600*FRACUNIT, z = 256*FRACUNIT},
			mine = {obj = MT_MINESOARER, loc = {x = -520*FRACUNIT, y = 600*FRACUNIT, z = 256*FRACUNIT},
				points = {
					{obj = MT_ALTVIEWMAN, loc = {x = -245*FRACUNIT, y = 420*FRACUNIT, z = 30*FRACUNIT, angle = ANGLE_90, speed = 8*FRACUNIT, arc = {x = 0, y = 0, z = -2*FRACUNIT}}},
					{obj = MT_ALTVIEWMAN, loc = {x = 128*FRACUNIT, y = 0*FRACUNIT, z = -64*FRACUNIT, angle = ANGLE_90, speed = 2*FRACUNIT}}
				}},
		})
		--wait(15)
		S_StartSoundAtVolume(nil, Snd("SE_EFF_STARPORTAL"), 100)
		genesis_createStarPort(mo, {obj = MT_STARHOLE, loc = {x = -520*FRACUNIT, y = 600*FRACUNIT, z = -128*FRACUNIT},
			mine = {obj = MT_MINESOARER, loc = {x = -520*FRACUNIT, y = 600*FRACUNIT, z = -128*FRACUNIT},
				points = {
					{obj = MT_ALTVIEWMAN, loc = {x = 245*FRACUNIT, y = 420*FRACUNIT, z = 30*FRACUNIT, angle = ANGLE_90, speed = 8*FRACUNIT, arc = {x = 0, y = 0, z = -2*FRACUNIT}}},
					{obj = MT_ALTVIEWMAN, loc = {x = -128*FRACUNIT, y = 0*FRACUNIT, z = -64*FRACUNIT, angle = ANGLE_90, speed = 2*FRACUNIT}}
				}},
		})
		--wait(15)
		S_StartSoundAtVolume(nil, Snd("SE_EFF_STARPORTAL"), 100)
		genesis_createStarPort(mo, {obj = MT_STARHOLE, loc = {x = 520*FRACUNIT, y = 600*FRACUNIT, z = 256*FRACUNIT},
			mine = {obj = MT_MINESOARER, loc = {x = 520*FRACUNIT, y = 600*FRACUNIT, z = 256*FRACUNIT},
				points = {
					{obj = MT_ALTVIEWMAN, loc = {x = 245*FRACUNIT, y = 420*FRACUNIT, z = 30*FRACUNIT, angle = ANGLE_90, speed = 8*FRACUNIT, arc = {x = 0, y = 0, z = -2*FRACUNIT}}},
					{obj = MT_ALTVIEWMAN, loc = {x = -128*FRACUNIT, y = 0*FRACUNIT, z = 64*FRACUNIT, angle = ANGLE_90, speed = 2*FRACUNIT}}
				}},
		})
		--wait(15)
		S_StartSoundAtVolume(nil, Snd("SE_EFF_STARPORTAL"), 100)
		genesis_createStarPort(mo, {obj = MT_STARHOLE, loc = {x = 520*FRACUNIT, y = 600*FRACUNIT, z = -128*FRACUNIT},
			mine = {obj = MT_MINESOARER, loc = {x = 520*FRACUNIT, y = 600*FRACUNIT, z = -128*FRACUNIT},
				points = {
					{obj = MT_ALTVIEWMAN, loc = {x = -245*FRACUNIT, y = 420*FRACUNIT, z = 30*FRACUNIT, angle = ANGLE_90, speed = 8*FRACUNIT, arc = {x = 0, y = 0, z = -2*FRACUNIT}}},
					{obj = MT_ALTVIEWMAN, loc = {x = 128*FRACUNIT, y = 0*FRACUNIT, z = 64*FRACUNIT, angle = ANGLE_90, speed = 2*FRACUNIT}}
				}},
		})
	end)
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1)
	--ACT:startSprAnim(mo, SPRITE("genesis_IdleF"), 0, 3, 9, 2*TICRATE)
	genesis_Teleport(mo, {x = 256*FRACUNIT, y = 832*FRACUNIT, z = 0*FRACUNIT, angle = ANGLE_90}, {speed = 1, waitTime = 12})
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1)
	--ACT:startSprAnim(mo, SPRITE("genesis_IdleF"), 0, 3, 9, 2*TICRATE)
	genesis_Teleport(mo, {x = -346*FRACUNIT, y = 832*FRACUNIT, z = 128*FRACUNIT, angle = ANGLE_90}, {speed = 1, waitTime = 12})
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1)
	--ACT:startSprAnim(mo, SPRITE("genesis_IdleF"), 0, 3, 9, 2*TICRATE)
	genesis_Teleport(mo, {x = 416*FRACUNIT, y = 832*FRACUNIT, z = 64*FRACUNIT, angle = ANGLE_90}, {speed = 1, waitTime = 12})
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1)
	--ACT:startSprAnim(mo, SPRITE("genesis_IdleF"), 0, 3, 9, 2*TICRATE)
	ACT:startSprAnim(mo, SPRITE("gns_AnyAction"), 0, 3, 12, false, true)
	OBJECT:moveTo(mo, {x = -255*FRACUNIT, y = 832*FRACUNIT, z = mo.z, angle = ANGLE_90}, 12*FRACUNIT, {tween = {FloatFixed("0.122"), FloatFixed("0.98")}, arc = {x = 0, y = 18*FRACUNIT, z = 0}})
	genesis_Teleport(mo, {x = 0*FRACUNIT, y = 832*FRACUNIT, z = 0*FRACUNIT, angle = ANGLE_90}, {speed = 1, waitTime = 12})
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1)
end


--event.newevent("genesis_starport3",
--function(mo,v)
local function genesis_hyperset_StarPortSkyOpen(mo)
	--genesis_Teleport(mo, {x = 0*FRACUNIT, y = 832*FRACUNIT, z = 0*FRACUNIT, angle = ANGLE_90}, {speed = 2})
	local function CameraZoom()
		for player in players.iterate do
			CAMERA:override(player, true)
			OBJECT:setPosition(server.mo.cam, maplocation("MAINFIELD_VIEWPOINT"))
			CAMERA:SetEye(server, maplocation("MAINFIELD_VIEWPOINT"), 0)
			CAMERA:UnsetEye(server, 0)
			server.mo.cam.angle = ANGLE_90
			player.awayviewmobj = server.mo.cam
			player.awayviewtics = 9999
			server.awayviewtics = 9999
		end
		OBJECT:moveTo(server.mo.cam, {x = 0*FRACUNIT, y = 223*FRACUNIT, z = 600*FRACUNIT, angle = ANGLE_90}, 18*FRACUNIT, {tween = {FloatFixed("0.122"), FloatFixed("0.98")}, arc = {x = 0, y = 0, z = -8*FRACUNIT}})
		wait(2*TICRATE)
		OBJECT:moveTo(server.mo.cam, maplocation("MAINFIELD_VIEWPOINT"), 40*FRACUNIT, {tween = {FloatFixed("0.122"), FloatFixed("0.98")}, arc = {x = 0, y = 0, z = -8*FRACUNIT}})
		for player in players.iterate do
			player.awayviewmobj = player.mo.cam
			CAMERA:SetEye(server, maplocation("MAINFIELD_VIEWPOINT"), 0)
			CAMERA:UnsetEye(server, 0)
			OBJECT:setPosition(server.mo.cam, maplocation("MAINFIELD_VIEWPOINT"))
			CAMERA:override(player, false)
		end
	end
	local CameraZoom_RUN = TASK:Regist(CameraZoom)
	OBJECT:moveTo(mo, {x = 0*FRACUNIT, y = 1024*FRACUNIT, z = 600*FRACUNIT, angle = ANGLE_90}, 32*FRACUNIT, {tween = {FloatFixed("0.122"), FloatFixed("0.98")}, arc = {x = 0, y = 0, z = -8*FRACUNIT}})
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1)
	--ACT:startSprAnim(mo, SPRITE("genesis_IdleF"), 0, 3, 9, 1)
	ACT:startSprAnim(mo, SPRITE("gns_StarSkyRip"), A, G, 2)
	SOUND:PlaySFX(nil, Snd("SE_EFF_STARPORTAL"), 100)
	-- Reference Later for new Star Portal Beam
	local BigPortalLocation = {x = 0*FRACUNIT, y = 1124*FRACUNIT, z = 920*FRACUNIT}
	local portal = OBJECT:CreateNew(MT_STARHOLE, BigPortalLocation, {id = 8})
			OBJECT:setscale(portal, 10*FRACUNIT, FloatFixed("0.3"))
	local function SendExplodeObjects()
		while true do
			if (portal.state == S_HOLES_0) then
			local randPreSpotHorz = P_RandomRange(-320, 320)
			local randPreSpotVert = P_RandomRange(-128, 128)
			local randSpotHorz = P_RandomRange(-256, 256)
			local randSpotVert = P_RandomRange(-128, 128)
			S_StartSoundAtVolume(nil, sfx_s3k95, 100)
			genesis_createStarPort(mo, {obj = MT_STARHOLE, loc = {x = BigPortalLocation.x, y = BigPortalLocation.y+32*FRACUNIT, z = BigPortalLocation.z},
			mine = {obj = MT_MINESOARER, loc = {x = BigPortalLocation.x, y = BigPortalLocation.y+64*FRACUNIT, z = BigPortalLocation.z},
				points = {
					{obj = MT_ALTVIEWMAN, loc = {x = randPreSpotHorz*FRACUNIT, y = 420*FRACUNIT, z = randPreSpotVert*FRACUNIT, angle = ANGLE_90, speed = 8*FRACUNIT, arc = {z = -2*FRACUNIT}}},
					{obj = MT_ALTVIEWMAN, loc = {x = randSpotHorz*FRACUNIT, y = maplocation("PLAYER_SPAWNPOINT").y, z = randSpotVert, angle = ANGLE_90, speed = 2*FRACUNIT}}
				}},
				})
			elseif (portal.state == S_STARHOLE_NOSPAWNING) then
				--[[ do nothing ]]
			elseif (portal.state == S_STARHOLE_ENDSPAWNER) then
				break
			end
			wait(3*TICRATE)
		end
	end
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1)
	--ACT:startSprAnim(mo, SPRITE("genesis_IdleF"), 0, 3, 4, 1)
	OBJECT:moveTo(mo, maplocation("MT_IIANASTAR_SPAWNPOINT"), 32*FRACUNIT, {tween = {FloatFixed("0.122"), FloatFixed("0.98")}, arc = {x = 0, y = 0, z = -8*FRACUNIT}})
	local SendExplodeObjects_Tsk = TASK:Regist(SendExplodeObjects)
	--ACT:startSprAnim(mo, SPRITE("genesis_IdleF"), 0, 3, 9, 1*TICRATE)
	--event.beginEvent("", mo, mo.events)
end
--end)

local function genesis_hyperset_StarPortSkyFlash(mo)
	-- Always after StarPortSkyOpen
	local START_Z = 0*FRACUNIT
	START_Z = P_RandomRange(-64, 64)*FRACUNIT
	local OpenStar = TASK:Regist(function()
		local BIG_STAR = OBJECT:Find(MT_STARHOLE, {id = 8})
		wait(5)
		SOUND:PlaySFX(nil, sfx_s3k90, 100)
		OBJECT:setscale(BIG_STAR,6*FRACUNIT, FloatFixed("0.6"))
		wait(5)
		SOUND:PlaySFX(nil, sfx_s3k90, 100)
		OBJECT:setscale(BIG_STAR,10*FRACUNIT, FloatFixed("0.6"))
		local RangeWarning = TASK:Regist(function()
			SOUND:PlaySFX(nil, Snd("SE_KR_SLASH01"), 64)
			for i = 0, 640, 32 do
				local w = OBJECT:CreateNew(MT_SWEEP_WARNING, {x = 320*FRACUNIT-i*FRACUNIT, y = 0, z = START_Z})
				OBJECT:setscale(w, 5*FRACUNIT)
			end
		end)
		wait(35)
		SOUND:PlaySFX(nil, sfx_s3k90, 100)
		OBJECT:setscale(BIG_STAR,6*FRACUNIT, FloatFixed("0.6"))
		wait(5)
		SOUND:PlaySFX(nil, sfx_s3k90, 100)
		OBJECT:setscale(BIG_STAR,10*FRACUNIT, FloatFixed("0.6"))
		wait(45)
		local openVib = TASK:Regist(function()
			local i = 0
			while true do
				if (mo.EVENTSTATE == "DEAD") then
					break
				end
				if (i > 2*TICRATE)
					break
				end
				i = i + 1
				P_StartQuake(6*FRACUNIT, 1, {0, 0, 0},0)
				wait(0)
			end
		end)
		SOUND:PlaySFX(nil, Snd("SE_EFF_DGROW"), 100)
		OBJECT:setscale(BIG_STAR,68*FRACUNIT, FloatFixed("4.0"))
		for i=0, 2*TICRATE+15 do
			if (mo.EVENTSTATE == "DEAD") then
				break
			end
			if (BIG_STAR.valid)
				SOUND:PlaySFX(nil, Snd("SE_EFF_STARFIRE"),32)
				local HEAD_TO = OBJECT:CreateNew(MT_THOK, {x = P_RandomRange(-420, 420)*FRACUNIT, y = -512*FRACUNIT, z = START_Z})
				local object = P_SpawnXYZMissile(mo, HEAD_TO, MT_STAR_ORB, P_RandomRange(-420, 420)*FRACUNIT, 900*FRACUNIT, START_Z+P_RandomRange(-32, 32)*FRACUNIT)
				object.color = P_RandomRange(5, 20)
				--OBJECT:setscale(object, 1*FRACUNIT/2)
			end
			P_StartQuake(4*FRACUNIT, 1, {0, 0, 0},0)
			wait(1)
		end
	end)
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1)
	--ACT:startSprAnim(mo, SPRITE("genesis_IdleF"), 0, 3, 9, 1*TICRATE)
	genesis_Teleport(mo, {x = 0, y = 1280*FRACUNIT, z = 0, angle = ANGLE_90}, {speed = 1, waitTime = 20})
	wait(5*TICRATE)
	-- Close
	local BIG_STAR = OBJECT:Find(MT_STARHOLE, {id = 8})
	SOUND:PlaySFX(nil, Snd("SE_EFF_STARPORTAL"), 100)
	OBJECT:setscale(BIG_STAR,0*FRACUNIT, FloatFixed("4.0"))
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1)
	--ACT:startSprAnim(mo, SPRITE("genesis_IdleF"), 0, 3, 9, 1*TICRATE)
	genesis_Teleport(mo, {x = 0, y = 832*FRACUNIT, z = 0, angle = ANGLE_90}, {speed = 1, waitTime = 8})
end

local function genesis_hyperset_IdleStep1(mo)
	local STAR_GEN = mo
	local newLocation = {}
	local randSpotHorz = 0
	local randSpotVert = 0
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1)
	randSpotHorz = P_RandomRange(-450, 450)
	randSpotVert = P_RandomRange(-256, 256)
	newLocation = {x = randSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y, z = randSpotVert*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {speed = 1, waitTime = 35})
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1)
	randSpotHorz = P_RandomRange(-450, 450)
	randSpotVert = P_RandomRange(-256, 256)
	newLocation = {x = randSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y, z = randSpotVert*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {speed = 1, waitTime = 35})
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1)
	randSpotHorz = P_RandomRange(-450, 450)
	randSpotVert = P_RandomRange(-256, 256)
	newLocation = {x = randSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y, z = randSpotVert*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {speed = 1, waitTime = 35})
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1)
	newLocation = {x = 0*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y, z = 0*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {speed = 1, waitTime = 35})
end

local function genesis_hyperset_IdleStep2(mo)
	local STAR_GEN = mo
	local newLocation = {}
	local randSpotHorz = 0
	local randSpotVert = 0
	randSpotHorz = P_RandomRange(-450, 450)
	randSpotVert = P_RandomRange(-256, 256)
	newLocation = {x = randSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y, z = randSpotVert*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {speed = 1, waitTime = 8})
	wait(5)
	randSpotHorz = P_RandomRange(-450, 450)
	randSpotVert = P_RandomRange(-256, 256)
	newLocation = {x = randSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y, z = randSpotVert*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {speed = 1, waitTime = 8})
	wait(5)
	randSpotHorz = P_RandomRange(-450, 450)
	randSpotVert = P_RandomRange(-256, 256)
	newLocation = {x = randSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y, z = randSpotVert*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {speed = 1, waitTime = 8})
	wait(5)
	randSpotHorz = P_RandomRange(-450, 450)
	randSpotVert = P_RandomRange(-256, 256)
	newLocation = {x = randSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y, z = randSpotVert*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {speed = 1, waitTime = 8})
	ACT:startSprAnim(mo, SPRITE("gns_IdleStill"), A, E, 9, 1)
	newLocation = maplocation("GNS_SPAWNPOINT")
	genesis_Teleport(mo, newLocation, {speed = 1, waitTime = 35})

end

local function genesis_hyperset_SolBlade1(mo, Properties)
	local START_Z = 0*FRACUNIT
	START_Z = P_RandomRange(-64, 64)*FRACUNIT
	local HitAreaWarning = TASK:Regist(function()
		SOUND:PlaySFX(nil, Snd("SE_KR_SLASH01"), 64)
		for i = 0, 640, (Properties.PreWaveSpeed) or 32 do
			local topLine = OBJECT:CreateNew(MT_SWEEP_WARNING, {x = 320*FRACUNIT-i*FRACUNIT, y = 0, z = START_Z+96*FRACUNIT})
			local bottomLine = OBJECT:CreateNew(MT_SWEEP_WARNING, {x = 320*FRACUNIT-i*FRACUNIT, y = 0, z = START_Z-96*FRACUNIT})
			for k = 96, 256, 32 do
				OBJECT:CreateNew(MT_SWEEP_WARNING, {x = topLine.x, y = 0, z = START_Z+k*FRACUNIT})
				OBJECT:CreateNew(MT_SWEEP_WARNING, {x = bottomLine.x, y = 0, z = START_Z-k*FRACUNIT})
			end
			if (Properties and Properties.PreLineWait)
				wait(0)
			else
			end
		end
	end)
	--ACT:startSprAnim(mo, SPRITE("genesis_ShineSlashHold"), 0, 3, 3, Properties.HoldTime or 1*TICRATE)
	ACT:startSprAnim(mo, SPRITE("gns_ShardSwipeStart"), A, E, 3)
	wait(18)
	local HitAreaDamage = TASK:Regist(function()
		SOUND:PlaySFX(nil, Snd("SE_KR_SLASH02"), 100)
		OBJECT:moveTo(mo, {x = 0*FRACUNIT, y = 832*FRACUNIT, z = maplocation("GNS_SPAWNPOINT").z-32*FRACUNIT}, 16*FRACUNIT, {tween = {FloatFixed("0.122"), FloatFixed("0.98")}})
		for i = 0, 640, (Properties.WaveSpeed) or 32 do
			P_StartQuake(12*FRACUNIT, 4, {0, 0, 0},0)

			local topLine = OBJECT:CreateNew(MT_SWEEP_LINE, {x = 320*FRACUNIT-i*FRACUNIT, y = 0, z = START_Z+96*FRACUNIT})
			local bottomLine = OBJECT:CreateNew(MT_SWEEP_LINE, {x = 320*FRACUNIT-i*FRACUNIT, y = 0, z = START_Z-96*FRACUNIT})
			for k = 96, 256, 32 do
				OBJECT:CreateNew(MT_SWEEP_LINE, {x = topLine.x, y = 0, z = START_Z+k*FRACUNIT})
				OBJECT:CreateNew(MT_SWEEP_LINE, {x = bottomLine.x, y = 0, z = START_Z-k*FRACUNIT})
			end
			if (Properties and Properties.LineWait)
				wait(0)
			else
			end
		end
		OBJECT:moveTo(mo, {x = 0*FRACUNIT, y = 832*FRACUNIT, z = maplocation("GNS_SPAWNPOINT").z}, 32*FRACUNIT, {tween = {FloatFixed("0.122"), FloatFixed("0.98")}})
	end)
	--	ACT:startSprAnim(mo, SPRITE("genesis_ShineSlashRelease"), 4, 4, 3, Properties.EndWaitTime or 1*TICRATE)
	ACT:startSprAnim(mo, SPRITE("gns_ShardSwipeEnd"), A, E, 2)
	wait(15)
end


event.newevent("genesis_hyperset1",
function(mo,v)
	local STAR_GEN = mo
	local newLocation = {}
	local randSpotHorz = 0
	local randSpotVert = 0
	--print("[Prepare New Attack Pattern]")
	--wait(35)
	genesis_hyperset_synth1(mo)
	genesis_hyperset_IdleStep1(mo)
	genesis_hyperset_StarPortSkyOpen(mo)
	genesis_hyperset_IdleStep1(mo)
	genesis_hyperset_SolBlade1(mo, {})
	randSpotHorz = P_RandomRange(-450, 450)
	randSpotVert = P_RandomRange(-256, 256)
	newLocation = {x = randSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y, z = randSpotVert*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {speed = 1, waitTime = 8})
	genesis_hyperset_SolBlade1(mo, {})
	randSpotHorz = P_RandomRange(-450, 450)
	randSpotVert = P_RandomRange(-256, 256)
	newLocation = {x = randSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y, z = randSpotVert*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {speed = 1, waitTime = 8})
	genesis_Teleport(mo, maplocation("GNS_SPAWNPOINT"), {speed = 1, waitTime = 8})
	genesis_hyperset_SolBlade1(mo, {})
	genesis_hyperset_StarPortMove1(mo)
	genesis_hyperset_SolBlade1(mo, {HoldTime = 1, EndWaitTime = 1})
	genesis_hyperset_SolBlade1(mo, {HoldTime = 1, EndWaitTime = 1, Reverse = true})
	genesis_hyperset_SolBlade1(mo, {HoldTime = 1, EndWaitTime = 1})
	local BigStarPortal = OBJECT:Find(MT_STARHOLE, {id = 8})
	BigStarPortal.state = S_STARHOLE_NOSPAWNING
	genesis_hyperset_solarbeam(mo)
	BigStarPortal.state = S_HOLES_0
	genesis_hyperset_IdleStep2(mo)
	BigStarPortal.state = S_STARHOLE_ENDSPAWNER
	genesis_hyperset_StarPortSkyFlash(mo)
	event.beginEvent("genesis_hyperset2", mo, mo.events)
end)

event.newevent("genesis_hyperset2",
function(mo,v)
	local STAR_GEN = mo
	local newLocation = {}
	local randSpotHorz = 0
	local randSpotVert = 0
	genesis_hyperset_SolBlade1(mo, {})
	genesis_hyperset_StarPortMove1(mo)
	genesis_hyperset_SolBlade1(mo, {})
	genesis_hyperset_IdleStep1(mo)
	randSpotHorz = P_RandomRange(-450, 450)
	randSpotVert = P_RandomRange(-256, 256)
	newLocation = {x = randSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y, z = randSpotVert*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {speed = 1, waitTime = 8})
	genesis_Teleport(mo, maplocation("GNS_SPAWNPOINT"), {speed = 1, waitTime = 8})
	genesis_hyperset_SolBlade1(mo, {})
	genesis_hyperset_synth1(mo)
	randSpotHorz = P_RandomRange(-450, 450)
	randSpotVert = P_RandomRange(-256, 256)
	newLocation = {x = randSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y, z = randSpotVert*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {speed = 1, waitTime = 8})
	randSpotHorz = P_RandomRange(-450, 450)
	randSpotVert = P_RandomRange(-256, 256)
	newLocation = {x = randSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y, z = randSpotVert*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {speed = 1, waitTime = 8})
	genesis_Teleport(mo, maplocation("GNS_SPAWNPOINT"), {speed = 1, waitTime = 8})
	genesis_hyperset_SolBlade1(mo, {})
	--genesis_hyperset_IdleStep2(mo)
	event.beginEvent("genesis_hyperset3", mo, mo.events)
end)

event.newevent("genesis_hyperset3",
function(mo,v)
	local STAR_GEN = mo
	local newLocation = {}
	local randSpotHorz = 0
	local randSpotVert = 0
	randSpotHorz = P_RandomRange(-450, 450)
	randSpotVert = P_RandomRange(-256, 256)
	newLocation = {x = randSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y, z = randSpotVert*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {speed = 1, waitTime = 8})
	randSpotHorz = P_RandomRange(-450, 450)
	randSpotVert = P_RandomRange(-256, 256)
	newLocation = {x = randSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y, z = randSpotVert*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {speed = 1, waitTime = 8})
	genesis_Teleport(mo, maplocation("GNS_SPAWNPOINT"), {speed = 1, waitTime = 8})
	genesis_hyperset_SolBlade1(mo, {HoldTime = 1, EndWaitTime = 1})
	genesis_hyperset_SolBlade1(mo, {HoldTime = 1, EndWaitTime = 1, Reverse = true})
	genesis_hyperset_synth1(mo)
	--genesis_hyperset_solarbeam(mo)
	newLocation = maplocation("GNS_SPAWNPOINT")
	genesis_Teleport(STAR_GEN, newLocation, {speed = 1, waitTime = 20})
	genesis_hyperset_solarbeam(mo, {startLoc = {x = 800*FRACUNIT, y = -800*FRACUNIT, z = 0*FRACUNIT}, endLoc = {x = -800*FRACUNIT, y = -800*FRACUNIT, z = 0*FRACUNIT}})
	event.beginEvent("genesis_hyperset1", mo, mo.events)
end)











------------------------------------------------------------------------------------
-- HOOKS
------------------------------------------------------------------------------------

-- Clear All
rawset(_G, "MobjList", {})
local bossmobj_iteratelist = {
	MT_STARHOLE,
	MT_MINESOARER,
}

addHook("MapChange", do
	MobjList = {}
end)

for i=1, #bossmobj_iteratelist do
	addHook("MobjSpawn", function(mo)
		if (mapheaderinfo[gamemap].starzone) then
			table.insert(MobjList, mo)
		end
	end, bossmobj_iteratelist[i])

	addHook("MobjRemoved", function(mo)
		if (mapheaderinfo[gamemap].starzone) then
			for i=1, #MobjList do
				if MobjList[i] == mo then
					table.remove(MobjList, i)
					break
				end
			end
		end
	end, bossmobj_iteratelist[i])
end
-------------------------------------

event.newevent("genesis_bossChecker",
function(mo,v)
	local STAR_GEN = mo
	local newLocation = {}
	--Check Health Status 1 (quarter?|ENABLEATTACK)
	--print("START HEALTH CHECK")
	while true
		if not mo.valid then
			return
		end
		if mo.health == BOSS_HEALTH_ATTACKENABLE then
			mo.health = BOSS_HEALTH_ATTACKENABLE-1
			ACT:stopSprAnim(mo)
			mo.EVENTSTATE = "Attackenable"
			--print("(!ENABLED) PASS REACHED")
			break
		end
		wait(0)
	end
	--mo.health = BOSS_HEALTH_ATTACKENABLE
	DestroyAllEventsInStorage(mo.events)
	genesis_MinorHitShake()
	S_StartSoundAtVolume(nil, Snd("SE_KR_EXPLODE1S"), 100)
	for player in players.iterate do
		P_FlashPal(player, 2, 2)
		forcePlayerReborn(player)
	end
	ACT:startSprAnim(STAR_GEN, SPRITE("gns_MHurt"), A, C, 4, false)
	local DestroyAll = TASK:Regist(function()
		for mobj in mobjs.iterate()
			if ((mobj and mobj.valid) and (mobj.type == MT_ALTVIEWMAN or mobj.type == MT_STARHOLE or mobj.type == MT_MINESOARER))
				if (mobj.events) then
					mobj.events = {}
				end
				OBJECT:CreateNew(MT_KEXPLODE, mobj)
				mobj.fuse = 5
				--P_RemoveMobj(mobj)
			end
		end
	end)
	DestroyAllEventsInStorage(mo.events)
	event.beginEvent("genesis_MidpointDemo", mo, mo)
	--Check Health Status 2 (End)
	--mo.health = 40
	--print("START SECOND HEALTH CHECK")
	while true
		if not mo.valid then
			return
		end
		if mo.health < BOSS_HEALTH_DEFEAT then
			mo.flags = $1&~MF_SHOOTABLE
			break
		end
		wait(0)
	end
	--Death Animation
	--TODO: fix any hiccups on death animation start
	for player in players.iterate do
		SOUND:PlayBGM(player, "quiet")
		forcePlayerReborn(player)
	end
	attachLoop("n_musicCheck", function() strgn_MusicLoop(nil, {BGM = "BGM_EV_none"}) end)
	mo.EVENTSTATE = "DEAD"
	local endEventsAndEverything = TASK:Regist(function()
		for mobj in mobjs.iterate()
			if ((mobj and mobj.valid) and (mobj.type == MT_ALTVIEWMAN or (mobj.type == MT_STARHOLE and not mobj.extrainfo == 8) or mobj.type == MT_MINESOARER))
				if (mobj.events) then
					mobj.events = {}
				end
				OBJECT:CreateNew(MT_KEXPLODE, mobj)
				OBJECT:CreateNew(MT_KEXPLODE, mobj)
				mobj.fuse = 5
				--P_RemoveMobj(mobj)
			end
			if ((mobj and mobj.valid) and (mobj.type == MT_STARHOLE and mobj.extrainfo == 8))
				mobj.state = S_STARHOLE_ENDSPAWNER
				OBJECT:setscale(mobj, 0, FloatFixed("0.8"))
			end
		end
		for i=0, 5*TICRATE do
			DestroyAllEventsInStorage(mo.events)
			ACT:startSprAnim(mo, SPRITE("gns_MegaHurt"), C, C, 5)
			wait(0)
		end
	end)
	genesis_MinorHitShake()
	genesis_MinorHitShake()
	S_StartSoundAtVolume(nil, Snd("SE_KR_EXPLODE1S"), 100)
	for player in players.iterate do
		P_FlashPal(player, 2, 2)
	end
	local explode = OBJECT:CreateNew(MT_KEXPLODE, mo)
	OBJECT:setscale(explode, 5*FRACUNIT, FloatFixed("0.8"))
	--ACT:startSprAnim(mo, SPRITE("gns_MegaHurt"), C, C, 5, false,nil,true)
	--genesis_Teleport(mo, {x = 0*FRACUNIT, y = 832*FRACUNIT, z = 0*FRACUNIT, angle = ANGLE_90}, {speed = 2})
	S_StartSoundAtVolume(nil, Snd("SE_KR_EXPLODE1S"), 100)
	S_StartSoundAtVolume(nil, Snd("SE_EFF_STARLIS_ENDING1"), 100)
	local DieMove = TASK:Regist(function()
		local fallbackpos = {x = mo.x, y = mo.y, z = mo.z}
		genesis_MinorHitShake()
		local explode = OBJECT:CreateNew(MT_KEXPLODE, mo)
		OBJECT:setscale(explode, 5*FRACUNIT, FloatFixed("0.8"))
		OBJECT:moveTo(mo, {x = fallbackpos.x-64*FRACUNIT, y = fallbackpos.y+64*FRACUNIT, z = fallbackpos.z-64*FRACUNIT, angle = ANGLE_90}, 2*FRACUNIT, {tween = {FloatFixed("0.122"), FloatFixed("0.98")}})
		fallbackpos = {x = mo.x, y = mo.y, z = mo.z}
		S_StartSoundAtVolume(nil, Snd("SE_KR_EXPLODE1S"), 100)
		genesis_MinorHitShake()
		local explode = OBJECT:CreateNew(MT_KEXPLODE, mo)
		OBJECT:setscale(explode, 5*FRACUNIT)
		local explodeDouble = TASK:Regist(function()
			S_StartSoundAtVolume(nil, Snd("SE_KR_EXPLODE1S"), 100)
			genesis_MinorHitShake()
			local explode = OBJECT:CreateNew(MT_KEXPLODE, mo)
			OBJECT:setscale(explode, 5*FRACUNIT, FloatFixed("0.8"))
			wait(18)
			S_StartSoundAtVolume(nil, Snd("SE_KR_EXPLODE1S"), 100)
			genesis_MinorHitShake()
			local explode = OBJECT:CreateNew(MT_KEXPLODE, mo)
			OBJECT:setscale(explode, 5*FRACUNIT, FloatFixed("0.8"))
		end)
		OBJECT:moveTo(mo, {x = fallbackpos.x+64*FRACUNIT, y = fallbackpos.y+64*FRACUNIT, z = fallbackpos.z-128*FRACUNIT, angle = ANGLE_90}, 2*FRACUNIT, {tween = {FloatFixed("0.122"), FloatFixed("0.98")}})
		for player in players.iterate do
			SCREEN:SetWipe(player, {set = true, dest = 10, Time = 18})
		end
		fallbackpos = {x = mo.x, y = mo.y, z = mo.z}
		S_StartSoundAtVolume(nil, Snd("SE_KR_EXPLODE1S"), 100)
		genesis_MinorHitShake()
		local explode = OBJECT:CreateNew(MT_KEXPLODE, mo)
		OBJECT:setscale(explode, 5*FRACUNIT)
		local moveToNewLocation = TASK:Regist(function()
			wait(180)
			-- Safely try to clean up trash around ph1
			dream_CleanupTrash()
			OBJECT:setPosition(mo, {x = 0, y = -688*FRACUNIT, z = -4096*FRACUNIT})
			wait(90)
			signal("MoveToPhase2")
			--event.beginEvent("Starlis_Phase2", nil)
			--P_RemoveMobj(mo)
		end)
		OBJECT:moveTo(mo, {x = fallbackpos.x+64*FRACUNIT, y = fallbackpos.y+64*FRACUNIT, z = -1480*FRACUNIT, angle = ANGLE_90}, 4*FRACUNIT, {tween = {FloatFixed("0.122"), FloatFixed("0.98")}})
	end)
	waitForSignal("MoveToPhase2")
	wait(35)
	--OBJECT:showobject(mo, false)
	TASK:Destroy(DieMove)
	TASK:Destroy(endEventsAndEverything)
	mo.EVENTSTATE = "PH2"
	event.beginEvent("Gen_Dream_Demo", STAR_GEN, STAR_GEN)
	--print("ENDOFBOSS")
	---------------------
end)

event.newevent("Gen_Dream_Demo",
function(mo,v)
	local STAR_GEN = mo
	local camera = server.mo.cam
	local newLocation = {}
	local cameraLocation = {}
	--local skybox = OBJECT:Find(MT_ALTSKYBOX)
	--[[for player in players.iterate do
		P_SetSkyboxMobj(skybox)
	end]]
	--start_animationTimer(v)
	setCheckpoint(2)
	EVM_HUD["airmanHud"].z_index = -1
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = true, dest = 0, Flash = true})
	end
	wait(1)
	for player in players.iterate do
		netgameCamOverride(player, server, {enabled = true})
		EVM_HUD["widescreen"].z_index = 48
		EVM_HUD["wipefade"].z_index = 47
		player.hudOptions.widescreen.enabled = true
		player.hudOptions.widescreen.wideframe = 10
		OBJECT:setPosition(player.mo, maplocation("PLAYER_SPAWNPOINT"))
		player.air.retmark.flags = $1|MF2_DONTDRAW
		player.air.retbox.flags = $1|MF2_DONTDRAW
		player.hudOptions.hidden = true
		player.hudOptions.hideValue = 32
		EnemyHud("starlis").hide = true
	end
	STAR_GEN.sprite = SPRITE("gns_SynthesisExecute")
	STAR_GEN.frame = D
	cameraLocation = {x = 544*FRACUNIT, y = 4192*FRACUNIT, z = 0*FRACUNIT, angle = FixedAngle(100*FRACUNIT)}
	CAMERA:SetEye(server, cameraLocation, 0)
	CAMERA:UnsetEye(server, 0)
	wait(35)
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = false, dest = 0, Time = 2})
	end
	destroyLoop("n_musicCheck")
	for player in players.iterate do
		SOUND:PlayBGM(player, Snd("BGM_EV_ATTACK"), false)
	end
	--attachLoop("n_musicCheck", function() strgn_MusicLoop(nil, {BGM = "BGM_EV_ATTACK"}) end)
	newLocation = {x = cameraLocation.x-512*FRACUNIT, y = cameraLocation.y, z = cameraLocation.z}
	OBJECT:setPosition(STAR_GEN, newLocation)
	local SlowPanCamera = TASK:Regist(function()
		OBJECT:moveTo(camera, {x = cameraLocation.x-256*FRACUNIT, y = cameraLocation.y, z = cameraLocation.z, angle = FixedAngle(100*FRACUNIT)}, 2*FRACUNIT/32, {tween = {FRACUNIT, FRACUNIT}})
	end)
	wait(35)
	OBJECT:moveTo(STAR_GEN, {x = newLocation.x, y = newLocation.y+840*FRACUNIT, z = cameraLocation.z, angle = ANGLE_90}, 9*FRACUNIT)
	TASK:Destroy(SlowPanCamera)
	cameraLocation = {x = STAR_GEN.x, y = STAR_GEN.y-512*FRACUNIT, z = STAR_GEN.z, angle = 0}
	CAMERA:SetEye(server, cameraLocation, 0)
	OBJECT:lookAt(camera, STAR_GEN, true)
	CAMERA:UnsetEye(server, 0)
	local powerSapToStarGen = function()
		while true do
			local randomSpot = {x = STAR_GEN.x, y = STAR_GEN.y+512*FRACUNIT, z = STAR_GEN.z}
			local sapper = P_SpawnMobj(randomSpot.x, randomSpot.y, randomSpot.z, MT_STARGENESIS_PULL)
			sapper.sprite = SPR_THOK
			P_StartQuake(12*FRACUNIT, 5)
			sapper.scale = 4*FRACUNIT
			sapper.color = P_RandomRange(0, 25)
			sapper.frame = $1|FF_TRANS40|FF_FULLBRIGHT
			OBJECT:setscale(sapper, 0, FloatFixed("1.1"))
			local sapperMoveToStrGn = TASK:Regist(function()
				OBJECT:moveTo(sapper, {x = STAR_GEN.x, y = STAR_GEN.y, z = STAR_GEN.z}, 42*FRACUNIT, {arc = {x = P_RandomRange(-512, 512)*FRACUNIT, y = P_RandomRange(-512, 512)*FRACUNIT, z = P_RandomRange(-512, 512)*FRACUNIT}})
				sapper.fuse = 2
			end)
			wait(0)
		end
	end
	local blackSphere = OBJECT:CreateNew(MT_STARGENESIS_PULL, {x = STAR_GEN.x, y = STAR_GEN.y-32*FRACUNIT, z = STAR_GEN.z})
	OBJECT:setscale(blackSphere, 0)
	blackSphere.sprite = SPR_CTHK
	blackSphere.color = SKINCOLOR_BLACK
	local ZoomoutCamera = TASK:Regist(function()
		OBJECT:moveTo(camera, {x = cameraLocation.x, y = cameraLocation.y-256*FRACUNIT, z = cameraLocation.z, angle = 0}, 4*FRACUNIT/32, {tween = {FRACUNIT, FRACUNIT}})
	end)
	SOUND:PlaySFX(nil, sfx_s3k93)
	wait(1)
	SOUND:PlaySFX(nil, sfx_s3k93)
	ACT:startSprAnim(STAR_GEN, SPRITE("gns_StarSkyRip"), A, C, 6)
	wait(90)
	TASK:Destroy(ZoomoutCamera)
	local ZoomoutCamera_Far = TASK:Regist(function()
		OBJECT:moveTo(camera, {x = cameraLocation.x, y = cameraLocation.y-512*FRACUNIT, z = cameraLocation.z, angle = 0}, 14*FRACUNIT, {tween = {FRACUNIT, FRACUNIT}})
	end)
	SOUND:PlaySFX(nil, Snd("SE_EFF_SLOWMOTION"))
	SOUND:PlaySFX(nil, Snd("SE_EFF_SLOWMOTION"))
	local powerSapToStarGen_tsk = TASK:Regist(powerSapToStarGen)
	OBJECT:setscale(blackSphere, 32*FRACUNIT, FloatFixed("0.02"))
	local RandomSfx = TASK:Regist(function()
		while true do
			SOUND:PlaySFX(nil, sfx_s3k4b, 86)
			SOUND:PlaySFX(nil, sfx_s3k5c, 86)
			SOUND:PlaySFX(nil, sfx_s3k9f, 84)
			wait(3)
		end
	end)
	ACT:startSprAnim(STAR_GEN, SPRITE("gns_StarSkyRip"), C, E, 1)
	for lightlevel = 240, 196, -1 do
		P_FadeLight(65535, lightlevel, 3*TICRATE)
		wait(4)
	end
	TASK:Destroy(powerSapToStarGen_tsk)
	TASK:Destroy(RandomSfx)
	wait(1)
	SOUND:PlaySFX(nil, Snd("SE_KR_LASERFIREA"))
	SOUND:PlaySFX(nil, Snd("SE_EFF_DARKCOUNTER"))
	P_StartQuake(32*FRACUNIT, 5)
	OBJECT:setscale(blackSphere, 64*FRACUNIT, FloatFixed("8"))
	wait(132)
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = true, dest = 10, Time = 8, pic = "bfill"})
	end
	for bgm_volume = 35, 0, -1 do
		--for player in players.iterate do
		--	COM_BufInsertText(player, "DIGMUSICVOLUME "..bgm_volume)
		--end
		wait(2)
	end
	--wait(64)
	wait(35)
	OBJECT:Destroy(blackSphere, 1)

	event.beginEvent("Gen_powerStar_Demo", STAR_GEN, mo.events)
	--print("<EOF> Reached of Event")
	--TODO: start on boss
end)


event.newevent("Gen_powerStar_Demo",
function(mo,v)
	local STAR_GEN = mo
	local camera = server.mo.cam
	local newLocation = {}
	local cameraLocation = {}

	local DustField = OBJECT:Find(MT_DUSTSPAWNER)
	DustField.state = S_DUSTSPAWN0
	--start_animationTimer(v)
	P_FadeLight(65535, 196, 1)
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = true, dest = 0, Flash = true, pic = "bfill"})
	end
	wait(1)
	for player in players.iterate do
		netgameCamOverride(player, server, {enabled = true})
		EVM_HUD["widescreen"].z_index = 48
		EVM_HUD["wipefade"].z_index = 47
		player.hudOptions.widescreen.enabled = true
		player.hudOptions.widescreen.wideframe = 10
		OBJECT:setPosition(player.mo, maplocation("PLAYER_SPAWNPOINT"))
		player.air.retmark.flags = $1|MF2_DONTDRAW
		player.air.retbox.flags = $1|MF2_DONTDRAW
		EVM_HUD["airmanHud"].z_index = -1
		player.hudOptions.hidden = true
		player.hudOptions.hideValue = 32
		EnemyHud("starlis").hide = true
	end
	OBJECT:setPosition(STAR_GEN, maplocation("GNS_SPAWNPOINT"))
	cameraLocation = {x = server.mo.x, y = server.mo.y+8*FRACUNIT, z = server.mo.z, angle = 0}
	CAMERA:SetEye(server, cameraLocation, 0)
	CAMERA:UnsetEye(server, 0)
	OBJECT:lookAt(camera, server.mo, true)
	STAR_GEN.color = SKINCOLOR_BLACK
	STAR_GEN.customsetting.scale = "5.8"
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = false, dest = 0, Time = 8, pic = "bfill"})
	end
	for player in players.iterate do
		SOUND:PlayBGM(player, Snd("BGM_EV_TLSPACE01"))
		--COM_BufInsertText(player, "DIGMUSICVOLUME 35")
	end
	attachLoop("n_musicCheck", function() strgn_MusicLoop(nil, {BGM = "BGM_EV_TLSPACE01"}) end)

	OBJECT:moveTo(camera, {x = cameraLocation.x, y = cameraLocation.y+256*FRACUNIT, z = cameraLocation.z, angle = 0}, 3*FRACUNIT, {tween = {FRACUNIT, FRACUNIT}})
	wait(15)
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_Demo_Pulsate"), A, F, 6, 6*TICRATE, true)
	cameraLocation = {x = STAR_GEN.x, y = STAR_GEN.y-512*FRACUNIT, z = STAR_GEN.z, angle = 0}
	CAMERA:SetEye(server, cameraLocation, 0)
	CAMERA:UnsetEye(server, 0)
	OBJECT:lookAt(camera, STAR_GEN, true)
	local ZoomoutCameraStep1 = TASK:Regist(function()
		OBJECT:moveTo(camera, {x = cameraLocation.x, y = cameraLocation.y-512*FRACUNIT, z = cameraLocation.z, angle = 0}, 4*FRACUNIT, {tween = {FRACUNIT, FRACUNIT}})
		signal("setCameraToStage")
	end)
	for player in players.iterate do
		OBJECT:setPosition(player.mo, {x = 0, y = 0, z = -88*FRACUNIT})
	end
	waitForSignal("setCameraToStage")
	cameraLocation = {x = mo.x, y = mo.y-480*FRACUNIT, z = 256*FRACUNIT, angle = ANGLE_90}
	CAMERA:SetEye(server, cameraLocation, 0)
	CAMERA:UnsetEye(server, 0)
	local YellVibration = function()
		local i = 0
		while true do
			if (i > 3*TICRATE)
				break
			end
			i = i + 1
			P_StartQuake(18*FRACUNIT, 1, {0, 0, 0},0)
			wait(0)
		end
	end
	local function ScreenWave()
		for i = 0,30, 1
			local c = OBJECT:CreateNew(MT_THOK, mo)
			local w = OBJECT:CreateNew(MT_WAVE_CIRC, mo)
			c.color = P_RandomRange(3, 15)
			OBJECT:setscale(c, 32*FRACUNIT, 2*FRACUNIT)
			OBJECT:setscale(w, 38*FRACUNIT, 2*FRACUNIT)
			c.frame = 0|(8<<FF_TRANSSHIFT)
			wait(3)
		end
	end
	local LookAtBoss = TASK:Regist(function()
		while true do
			OBJECT:lookAt(server.awayviewmobj, mo, true)
			CAMERA:lookAtZ(server, mo, true)
			wait(0)
		end
	end)
	local PanToCenterField = TASK:Regist(function()
		OBJECT:moveTo(camera, maplocation("MAINFIELD_VIEWPOINT"), 6*FRACUNIT, {tween = {0, FRACUNIT}})
		signal("drm_Roar")
	end)
	waitForSignal("drm_Roar")
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_Demo_Roar01S"), A, G, 4)
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_Demo_Roar02F"), A, E, 2)
	local ScreenWave_Tsk = TASK:Regist(ScreenWave)
	local YellVibration_Tsk = TASK:Regist(YellVibration)
	SOUND:PlaySFX(nil, Snd("SE_EFF_DARKUMEKI"), 100)
	SOUND:PlaySFX(nil, Snd("SE_EFF_DARKUMEKI"), 100)
	STAR_GEN.name = "Star Soul Genesis"
	STAR_GEN.hpfill.steps = 32
	STAR_GEN.hpfill.enabled = true
	STAR_GEN.health = STAR_GEN.info.BOSS2_HEALTH_FULL
	STAR_GEN.info.spawnhealth = STAR_GEN.info.BOSS2_HEALTH_FULL
	EVM_HUD["airmanHud"].z_index = 50
	for player in players.iterate do
		EnemyHud("starlis").hide = false
		player.hudOptions.hidden = false
		SOUND:PlaySFX(nil, Snd("SE_KR_METER"), 100, player)
	end
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_Demo_Roar02F_LP"), A, G, 1, 3*TICRATE)
	TASK:Destroy(LookAtBoss)
	TASK:Destroy(ScreenWave_Tsk)
	TASK:Destroy(YellVibration_Tsk)
	-- End Demo --
	for player in players.iterate do
		netgameCamOverride(player, server, {enabled = false})
		player.hudOptions.widescreen.enabled = false
		player.air.retmark.flags = $1&~MF2_DONTDRAW
		player.air.retbox.flags = $1&~MF2_DONTDRAW
		EVM_HUD["airmanHud"].z_index = 45
		player.awayviewmobj = player.mo.cam
		player.hudOptions.hidden = false
		EnemyHud("starlis").hide = false
	end
	--end_animationTimer(v)
	EVPAUSE.UPDATEPAUSEINFO(EVPAUSE.PauseInfoList["star_02d_entry"])
	STAR_GEN.health = STAR_GEN.info.BOSS2_HEALTH_FULL
	STAR_GEN.info.spawnhealth = STAR_GEN.info.BOSS2_HEALTH_FULL
	mo.flags = $1|MF_SHOOTABLE
	mo.EVENTSTATE = ""
	event.beginEvent("dream_entrypoint", mo, mo)
	--print("<EOF> Reached of Event")
end)


event.newevent("dream_entrypoint",
function(mo,v)
	mo.name = "Star Soul Genesis"
	event.beginEvent("dream_healthChecker", mo)
	event.beginEvent("dream_attackset1", mo, mo.events)
end)

event.newevent("dream_attackset1",
function(mo,v)
	local STAR_GEN = mo
	local camera = server.mo.cam
	local newLocation = {}
	local randSpotHorz = 0
	local randSpotVert = 0

	dream_ph2_DreamFire1(STAR_GEN)
	dream_ph2_CloseupIdle(STAR_GEN)
	dream_ph2_DreamRift(STAR_GEN)
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_IdleStill"), A, G, 6)
	SOUND:PlaySFX(nil, Snd("SE_KR_LASERCHARGE"), 100)
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_AnyAction3"), A, M, 2)
	local dream_WaitOutAttack = TASK:Regist(function()
		ACT:startSprAnim(STAR_GEN, SPRITE("drm_IdleStill"), A, G, 6, 4*TICRATE)
		signal("AttackFinished")
	end)
	dream_ph2_ZapRift_Horz(STAR_GEN, 3)
	waitForSignal("AttackFinished")
	dream_ph2_DreamFire1(STAR_GEN, 1)
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_IdleStill"), A, G, 6)
	newLocation = {x = maplocation("GNS_SPAWNPOINT").x, y = maplocation("GNS_SPAWNPOINT").y, z = maplocation("GNS_SPAWNPOINT").z, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {waitTime = 18, dream = true})
	SOUND:PlaySFX(nil, Snd("SE_KR_LASERCHARGE"), 100)
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_AnyAction3"), A, M, 2)
	local dream_WaitOutAttack = TASK:Regist(function()
		ACT:startSprAnim(STAR_GEN, SPRITE("drm_IdleStill"), A, G, 6, 4*TICRATE)
		signal("AttackFinished")
	end)
	dream_ph2_ZapRift_Horz(STAR_GEN, 4)
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_IdleStill"), A, G, 6)
	event.beginEvent("dream_attackset2", mo, mo.events)
end)

event.newevent("dream_attackset2",
function(mo,v)
	local STAR_GEN = mo
	local camera = server.mo.cam
	local newLocation = {}
	local randSpotHorz = 0
	local randSpotVert = 0

	ACT:startSprAnim(STAR_GEN, SPRITE("drm_IdleStill"), A, G, 6)
	dream_ph2_DreamRift(STAR_GEN, 1, 3*TICRATE)
	dream_ph2_DreamFire1(STAR_GEN, 2)
	randSpotHorz = P_RandomRange(-450, 450)
	randSpotVert = P_RandomRange(-256, 256)
	newLocation = {x = randSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y, z = randSpotVert*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {waitTime = 18, dream = true})
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_IdleStill"), A, G, 6)
	randSpotHorz = P_RandomRange(-450, 450)
	randSpotVert = P_RandomRange(-256, 256)
	newLocation = {x = randSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y, z = randSpotVert*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {waitTime = 18, dream = true})
	dream_ph2_DreamRift(STAR_GEN, 2, 6*TICRATE)
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_IdleStill"), A, G, 6)
	newLocation = {x = maplocation("GNS_SPAWNPOINT").x, y = maplocation("GNS_SPAWNPOINT").y, z = maplocation("GNS_SPAWNPOINT").z, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {waitTime = 18, dream = true})
	SOUND:PlaySFX(nil, Snd("SE_KR_LASERCHARGE"), 100)
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_AnyAction2"), A, M, 2)
	dream_ph2_ZapRift_Distance(STAR_GEN)

	ACT:startSprAnim(STAR_GEN, SPRITE("drm_IdleStill"), A, G, 6)
	event.beginEvent("dream_attackset3", mo, mo.events)
end)

event.newevent("dream_attackset3",
function(mo,v)
	local STAR_GEN = mo
	local camera = server.mo.cam
	local newLocation = {}
	local randSpotHorz = 0
	local randSpotVert = 0

	ACT:startSprAnim(STAR_GEN, SPRITE("drm_IdleStill"), A, G, 6)randSpotHorz = P_RandomRange(-450, 450)

	randSpotHorz = P_RandomRange(-450, 450)
	randSpotVert = P_RandomRange(-256, 256)
	newLocation = {x = randSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y, z = randSpotVert*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {waitTime = 18, dream = true})
	randSpotHorz = P_RandomRange(-450, 450)
	randSpotVert = P_RandomRange(-256, 256)
	newLocation = {x = randSpotHorz*FRACUNIT, y = maplocation("GNS_SPAWNPOINT").y, z = randSpotVert*FRACUNIT, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {waitTime = 18, dream = true})
	newLocation = {x = maplocation("GNS_SPAWNPOINT").x, y = maplocation("GNS_SPAWNPOINT").y, z = maplocation("GNS_SPAWNPOINT").z, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {waitTime = 18, dream = true})
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_IdleStill"), A, G, 6)
	dream_ph2_BladeSweep(STAR_GEN, 3)
	--wait(355)
	event.beginEvent("dream_attackset1", mo, mo.events)
end)


event.newevent("dream_r_countdownset1",
function(mo,v)
	local STAR_GEN = mo
	local camera = server.mo.cam
	local newLocation = {}

	dream_r_ph2_BladeSweep(STAR_GEN, 6)
	dream_r_ph2_BladeSweep(STAR_GEN, 9, 15, true)
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_R_IdleStill"), A, G, 3, 15)
	dream_r_ph2_CloseupIdle(STAR_GEN)
	dream_r_ph2_DreamRift(STAR_GEN, 4, 1*TICRATE, nil, true)
	SOUND:PlaySFX(nil, Snd("SE_KR_LASERCHARGE"))
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_R_AnyAction2"), A, M, 2)
	dream_r_ph2_ZapRift_Distance(STAR_GEN, 4)
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_R_IdleStill"), A, G, 3, 3)
	SOUND:PlaySFX(nil, Snd("SE_KR_LASERCHARGE"))
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_R_AnyAction3"), A, M, 2)
	local dream_WaitOutAttack = TASK:Regist(function()
		ACT:startSprAnim(STAR_GEN, SPRITE("drm_R_IdleStill"), A, G, 6, 4*TICRATE)
		signal("AttackFinished")
	end)
	dream_r_ph2_ZapRift_Horz(STAR_GEN, 5)
	waitForSignal("AttackFinished")
	SOUND:PlaySFX(nil, Snd("SE_KR_LASERCHARGE"))
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_R_AnyAction3"), A, M, 2)
	local dream_WaitOutAttack = TASK:Regist(function()
		ACT:startSprAnim(STAR_GEN, SPRITE("drm_R_IdleStill"), A, G, 6, 10*TICRATE)
		signal("AttackFinished")
	end)
	dream_r_ph2_ZapRift_Horz(STAR_GEN, 10)
	waitForSignal("AttackFinished")
	SOUND:PlaySFX(nil, Snd("SE_KR_LASERCHARGE_8"))
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_R_AnyAction3"), A, M, 2)
	--start_animationTimer(v)
	local dream_WaitOutAttack = TASK:Regist(function()
		ACT:startSprAnim(STAR_GEN, SPRITE("drm_R_IdleStill"), A, G, 6, 10*TICRATE)
		signal("AttackFinished")
	end)
	dream_r_ph2_ZapRift_HorzVert(STAR_GEN, 15, 22)
	waitForSignal("AttackFinished")
	--end_animationTimer()
	dream_r_ph2_BladeSweep(STAR_GEN, 14, 15, true)
	--dream_r_ph2_DreamFire1(STAR_GEN, 2)
	newLocation = {x = maplocation("GNS_SPAWNPOINT").x, y = maplocation("GNS_SPAWNPOINT").y, z = maplocation("GNS_SPAWNPOINT").z, angle = ANGLE_90}
	genesis_Teleport(mo, newLocation, {waitTime = 9, star = true})

	event.beginEvent("dream_r_countdownset1", mo, mo.events)
end)


event.newevent("dream_healthChecker",
function(mo,v)
	local STAR_GEN = mo
	local newLocation = {}
	local camera = server.mo.cam
	--print("Begin Health-Check: Half")
	--mo.health = STAR_GEN.info.BOSS2_HEALTH_HALF+1 -- Check animation hangs
	while true
		if not mo.valid then
			return
		end
		if mo.health == STAR_GEN.info.BOSS2_HEALTH_HALF then
			mo.health = STAR_GEN.info.BOSS2_HEALTH_HALF-1
			ACT:stopSprAnim(mo)
			--mo.EVENTSTATE = "Attackenable"
			break
		end
		wait(0)
	end
	mo.EVENTSTATE = "PAUSED"
	dream_CleanupTrash()
	local endEventsAndEverything = TASK:Regist(function()
		for mobj in mobjs.iterate()
			if ((mobj and mobj.valid) and (mobj.type == MT_ALTVIEWMAN or mobj.type == MT_STARHOLE or mobj.type == MT_PUSH or mobj.type == MT_MINESOARER))
				if (mobj.events) then
					mobj.events = {}
				end
				OBJECT:CreateNew(MT_KEXPLODE, mobj)
				mobj.fuse = 5
			end
		end
		for i=0, 3*TICRATE do
			DestroyAllEventsInStorage(mo.events)
			STAR_GEN.sprite = SPRITE("drm_Demo_Roar02F")
			STAR_GEN.frame = E
			wait(0)
		end
	end)
	dream_CleanupTrash()
	STAR_GEN.visibility = true
	OBJECT:showobject(STAR_GEN, true)
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = true, dest = 0, flash = true})
		forcePlayerReborn(player)
	end
	OBJECT:setPosition(STAR_GEN, maplocation("GNS_SPAWNPOINT"))
	wait(1)
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = false, dest = 10, flash = true})
	end
	mo.flags = $1&~MF_SHOOTABLE
	STAR_GEN.sprite = SPRITE("drm_Demo_Roar02F")
	STAR_GEN.frame = E
	for player in players.iterate do
		SOUND:PlayBGM(player, Snd("BGM_EV_none"))
	end
	attachLoop("n_musicCheck", function() strgn_MusicLoop(nil, {BGM = "BGM_EV_none"}) end)
	DestroyAllEventsInStorage(mo.events)
	dream_CleanupTrash()
	genesis_MinorHitShake()
	S_StartSoundAtVolume(nil, Snd("SE_KR_EXPLODE1S"), 100)
	for player in players.iterate do
		P_FlashPal(player, 2, 2)
	end
	local Explode = OBJECT:CreateNew(MT_KEXPLODE, STAR_GEN)
	Explode.scale = 10*FRACUNIT
	S_StartSoundAtVolume(nil, Snd("SE_EFF_SLOWMOTION"), 100)
	wait(35)
	for RepeatExplosions = 1, 3 do
		genesis_MinorHitShake()
		local randExplodePoint = P_RandomRange(-256, 256)*FRACUNIT
		local Explode = OBJECT:CreateNew(MT_KEXPLODE, {
										x = STAR_GEN.x+randExplodePoint,
										y = STAR_GEN.y-128*FRACUNIT,
										z = STAR_GEN.z+randExplodePoint})
		Explode.scale = 6*FRACUNIT
		S_StartSoundAtVolume(nil, Snd("SE_KR_EXPLODE1S"), 100)
		wait(35)
	end
	wait(15)
	SOUND:PlaySFX(nil, Snd("SE_EFF_SKAI_2"))
	SOUND:PlaySFX(nil, Snd("SE_EFF_SKAI_2"))
	local BarrierCrack = OBJECT:CreateNew(MT_STARGENESIS_PULL, {
										x = STAR_GEN.x,
										y = STAR_GEN.y-4*FRACUNIT,
										z = STAR_GEN.z})
	BarrierCrack.sprite = SPR_DRCK
	BarrierCrack.scale = 5*FRACUNIT
	for BarrierCrackShieldSteps = 0, 4 do
		SOUND:PlaySFX(nil, Snd("SE_EFF_BARRIER_CRACK"))
		BarrierCrack.frame = BarrierCrackShieldSteps|FF_FULLBRIGHT
		wait(35)
	end
	SOUND:PlaySFX(nil, Snd("SE_EFF_BARRIER_BREAK"))
	local LightFlood = OBJECT:CreateNew(MT_STARGENESIS_PULL, {
										x = STAR_GEN.x,
										y = STAR_GEN.y-32*FRACUNIT,
										z = STAR_GEN.z})
	LightFlood.sprite = SPR_CTHK
	LightFlood.color = SKINCOLOR_WHITE
	LightFlood.frame = A|FF_FULLBRIGHT
	OBJECT:setscale(LightFlood, 45*FRACUNIT, 8*FRACUNIT)
	BarrierCrack.fuse = 5
	wait(35)
	EVM_HUD["wipefade"].z_index = 40
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = true, dest = 10, Time = 1})
	end
	wait(2*TICRATE)
	for player in players.iterate do
		netgameCamOverride(player, server, {enabled = true})
		CAMERA:SetEye(server, {x = STAR_GEN.x, y = STAR_GEN.y-32*FRACUNIT, z = STAR_GEN.z}, 0)
		CAMERA:UnsetEye(server, 0)
	end
	SOUND:PlaySFX(nil, Snd("SE_EFF_WINDSPARKLE"))
	wait(115)
	for player in players.iterate do
		SOUND:PlayBGM(player, Snd("BGM_EV_SPACE2"))
	end
	attachLoop("n_musicCheck", function() strgn_MusicLoop(nil, {BGM = "BGM_EV_SPACE2"}) end)
	wait(50)
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = false, dest = 10, flash = true})
	end
	local FastZoomOutCameraToField = TASK:Regist(function()
		OBJECT:lookAt(server.mo.cam, STAR_GEN, true)
		OBJECT:moveTo(server.mo.cam, maplocation("MAINFIELD_VIEWPOINT"), 26*FRACUNIT, {tween = {FRACUNIT, FRACUNIT}})
		CAMERA:SetEye(server, maplocation("MAINFIELD_VIEWPOINT"), 0)
		CAMERA:UnsetEye(server, 0)
		OBJECT:setPosition(server.mo.cam, maplocation("MAINFIELD_VIEWPOINT"))
	end)
	LightFlood.fuse = 1
	SOUND:PlaySFX(nil, Snd("SE_EFF_BARRIER_EXPLODE"))
	SOUND:PlaySFX(nil, Snd("SE_EFF_DRM_R_VOICE01"), 95)
	P_StartQuake(32*FRACUNIT, 5)
	--STAR_GEN.health = STAR_GEN.info.BOSS2_HEALTH_FULL
	STAR_GEN.health = 1
	wait(1)
	STAR_GEN.hpfill.steps = 14
	STAR_GEN.hpfill.enabled = true
	--if netgame then
	--	STAR_GEN.health = 1000
	--	STAR_GEN.info.spawnhealth = 1000
	--else
		STAR_GEN.health = 600
		STAR_GEN.info.spawnhealth = 600
	--end
	SOUND:PlaySFX(nil, Snd("SE_KR_METER"), 100)
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_FaceReveal"), A, H, 2, 2*TICRATE)
	for player in players.iterate do
		netgameCamOverride(player, server, {enabled = false, awayviewmobj = player.mo.cam})
	end
	mo.flags = $1|MF_SHOOTABLE
	event.beginEvent("dream_r_countdownset1", mo, mo.events)
	--print("Begin health check: Final")
	--STAR_GEN.health = 11 -- Check animation hangs
	while true
		if not mo.valid then
			return
		end
		if mo.health < 10 then
			mo.flags = $1&~MF_SHOOTABLE
			break
		end
		wait(0)
	end
	mo.flags = $1 &~ MF_SHOOTABLE
	STAR_GEN.visibility = true
	S_StartSoundAtVolume(nil, Snd("SE_KR_EXPLODE1S"), 100)
	genesis_MinorHitShake()
	for player in players.iterate do
		SOUND:PlayBGM(player, Snd("BGM_EV_none"))
		forcePlayerReborn(player)
	end
	attachLoop("n_musicCheck", function() strgn_MusicLoop(nil, {BGM = "BGM_EV_none"}) end)
	DestroyAllEventsInStorage(mo.events)
	local endEventsAndEverything = TASK:Regist(function()
		for mobj in mobjs.iterate()
			if ((mobj and mobj.valid) and (mobj.type == MT_ALTVIEWMAN or (mobj.type == MT_STARHOLE and not mobj.extrainfo == 8) or mobj.type == MT_PUSH or mobj.type == MT_MINESOARER))
				if (mobj.events) then
					mobj.events = {}
				end
				OBJECT:CreateNew(MT_KEXPLODE, mobj)
				mobj.fuse = 5
			end
		end
		dream_r_CleanupTrash()
		for i=0, 5*TICRATE do
			DestroyAllEventsInStorage(mo.events)
			dream_r_CleanupTrash()
			ACT:startSprAnim(STAR_GEN, SPRITE("drm_R_Hurt"), G, G, 2, false)
			wait(1)
		end
	end)
	mo.EVENTSTATE = "FINAL_DEAD"
	OBJECT:showobject(STAR_GEN, true)
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = true, dest = 0, flash = true})
	end
	OBJECT:setPosition(STAR_GEN, maplocation("GNS_SPAWNPOINT"))
	wait(1)
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = false, dest = 10, flash = true})
	end
	dream_r_CleanupTrash()
	ACT:startSprAnim(STAR_GEN, SPRITE("drm_R_Hurt"), G, G, 2, false, true)
	local Explode = OBJECT:CreateNew(MT_KEXPLODE, STAR_GEN)
	Explode.scale = 10*FRACUNIT
	SOUND:PlaySFX(nil, Snd("SE_EFF_DREAM_R_DEFEAT1"))
	wait(35)
	for RepeatExplosions = 1, 6 do
		genesis_MajorHitShake()
		local randExplodePoint = P_RandomRange(-256, 256)*FRACUNIT
		local Explode = OBJECT:CreateNew(MT_KEXPLODE, {
										x = STAR_GEN.x+randExplodePoint,
										y = STAR_GEN.y-128*FRACUNIT,
										z = STAR_GEN.z+randExplodePoint})
		Explode.scale = 6*FRACUNIT
		S_StartSoundAtVolume(nil, Snd("SE_KR_EXPLODE1S"), 90)
		wait(15)
	end
	wait(1*TICRATE)
	local black_background = OBJECT:CreateNew(MT_STARGENESIS_PULL, STAR_GEN)
	OBJECT:setPosition(black_background, {x = STAR_GEN.x, y = STAR_GEN.y+128*FRACUNIT, z = STAR_GEN.z})
	black_background.scale = 64*FRACUNIT
	black_background.sprite = SPR_CTHK
	black_background.color = SKINCOLOR_BLACK
	black_background.frame = A|9<<FF_TRANSSHIFT
	for bg_alphalevel = 9, 1, -1 do
		black_background.frame = A|bg_alphalevel<<FF_TRANSSHIFT
		wait(7)
	end
	black_background.frame = A|0<<FF_TRANSSHIFT
	wait(25)
	local falling_star = OBJECT:CreateNew(MT_STARGENESIS_PULL, STAR_GEN)
	falling_star.sprite = SPR_SHLE
	falling_star.frame = A|FF_FULLBRIGHT
	OBJECT:setPosition(falling_star, {x = STAR_GEN.x-800*FRACUNIT, y = STAR_GEN.y, z = STAR_GEN.z+1000*FRACUNIT})
	SOUND:PlaySFX(nil, Snd("SE_EFF_DRM_R_VOICE04"), 90)
	OBJECT:moveTo(falling_star, {x = STAR_GEN.x-248*FRACUNIT, y = STAR_GEN.y, z = STAR_GEN.z+256*FRACUNIT}, 18*FRACUNIT)
	for player in players.iterate do
		--netgameCamOverride(player, server, {enabled = true})
		--EVM_HUD["widescreen"].z_index = 48
		--EVM_HUD["wipefade"].z_index = 47
		--player.hudOptions.widescreen.enabled = true
		--player.hudOptions.widescreen.wideframe = 10
		--OBJECT:setPosition(player.mo, maplocation("PLAYER_SPAWNPOINT"))
		player.air.retmark.flags = $1|MF2_DONTDRAW
		player.air.retbox.flags = $1|MF2_DONTDRAW
		EVM_HUD["airmanHud"].z_index = -1
		--player.hudOptions.hidden = true
		--player.hudOptions.hideValue = 32
		--EnemyHud("starlis").hide = true
	end
	falling_star.fuse = 2
	S_StartSoundAtVolume(nil, Snd("SE_KR_EXPLODE2"), 100)
	genesis_MajorHitShake()
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = true, dest = 0, flash = true})
	end
	local actor_ristar = OBJECT:CreateNew(MT_STARGENESIS_PULL, STAR_GEN)
	actor_ristar.sprite = SPR_RGHT
	actor_ristar.frame = A|FF_FULLBRIGHT|TR_TRANS40
	OBJECT:setscale(actor_ristar, 2*FRACUNIT)
	actor_ristar.angle = ANGLE_180
	local fadeOutActor = TASK:Regist(function()
		for Timer = 3, 9 do
			actor_ristar.frame = A|FF_FULLBRIGHT|Timer<<FF_TRANSSHIFT
			wait(80)
		end
	end)
	black_background.color = SKINCOLOR_WHITE
	OBJECT:setPosition(actor_ristar, {x = STAR_GEN.x, y = STAR_GEN.y-256*FRACUNIT, z = STAR_GEN.z+128*FRACUNIT})
	wait(1)
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = false, dest = 10, flash = true})
	end
	local DustField = OBJECT:Find(MT_DUSTSPAWNER)
	DustField.state = S_DUSTSPAWN2
	SOUND:PlaySFX(nil, Snd("SE_EFF_DREAM_R_DEFEAT2_SCREAM"))
	local explode_sfx_source = OBJECT:CreateNew(MT_STARGENESIS_PULL, server.mo.cam)
	OBJECT:setPosition(explode_sfx_source, {x = server.mo.cam.x, y = server.mo.cam.y+640*FRACUNIT, z = server.mo.cam.z})
	local explode_fadeout_sfx_distance = TASK:Regist(function()
		while true do
			if not explode_sfx_source and explode_sfx_source.valid then
				break
			end
			S_StartSoundAtVolume(explode_sfx_source, Snd("SE_KR_EXPLODE1S"), 8)
			wait(3)
		end
	end)
	local explodeSourceFlyAway = TASK:Regist(function()
		OBJECT:moveTo(explode_sfx_source, {x = explode_sfx_source.x, y = 4096*FRACUNIT, z = explode_sfx_source.z}, 3*FRACUNIT)
	end)
	local exploding = TASK:Regist(function()
		for Timer = 0, 18*TICRATE do
			genesis_MajorHitShake()
			local randExplodePoint = P_RandomRange(-256, 256)*FRACUNIT
			local Explode = OBJECT:CreateNew(MT_KEXPLODE, {
											x = STAR_GEN.x+randExplodePoint,
											y = STAR_GEN.y-128*FRACUNIT,
											z = STAR_GEN.z+randExplodePoint})
			Explode.scale = P_RandomChoice({4, 5, 6, 7, 8})*FRACUNIT
			wait(2)
		end
	end)
	local intensityQuake = TASK:Regist(function()
		for intensity = 0, 26, 4 do
			P_StartQuake(8*FRACUNIT+intensity*FRACUNIT, 35)
			wait(35)
		end
	end)
	wait(3*TICRATE)
	for player in players.iterate do
		SCREEN:SetWipe(player, {set = true, dest = 10, Time = 40})
	end
	wait(18*TICRATE)
	TASK:Destroy(intensityQuake)
	TASK:Destroy(exploding)
	TASK:Destroy(explode_fadeout_sfx_distance)
	TASK:Destroy(endEventsAndEverything)
	black_background.color = SKINCOLOR_WHITE
	black_background.frame = A|FF_FULLBRIGHT
	black_background.scale = 14*FRACUNIT
	OBJECT:setPosition(black_background, {x = server.mo.cam.x, y = server.mo.cam.y+70*FRACUNIT, z = server.mo.cam.z})
	wait(5)
	for player in players.iterate do
		P_DoPlayerExit(player)
	end
	--print("End of Level")
	--print("<EOE> Reached end of event")
end)


event.newevent("init_genesis",
function(mo,v)
	CONSOLE:disablejoining(true)
	local boss = OBJECT:Find(MT_EXPSTAR)
	--setCheckpoint(2)
	if (server.starpostnum == 2) then
		--event.beginEvent("Gen_Dream_Demo", boss, boss)
		event.beginEvent("Gen_powerStar_Demo", boss, boss)
	else
		event.beginEvent("DemoEvent", boss, boss)
	end
	--print("FULL:"..BOSS_HEALTH_FULL)
	--print("HALF:"..BOSS_HEALTH_HALF)
	--print("EN:"..BOSS_HEALTH_ATTACKENABLE)
	--print("DEFEAT:"..BOSS_HEALTH_DEFEAT)
end)


addHook("MobjThinker", function(mo)

	--mo.name = "???"
	--mo.name = "Staralis"
	--mo.name = "Dark Sol EXP. 020"
	--mo.scale = 3*FRACUNIT
	if mo.customsetting and mo.customsetting.scale then
		local scale = mo.customsetting.scale
		if (scale == -1) then
			mo.scale = FloatFixed("3.8")
		else
			mo.scale = FloatFixed(scale)
		end
	end

	mo.hurtc = max($ - 1, 0)

	if (mo.hpfill and mo.hpfill.enabled == true) then
		if (leveltime % 1 == 0) then
			--print("Fill Count: "..mo.hpfill.count)
			if mo.hpfill.count >= mo.health then
				mo.hpfill.count = 0
				mo.hpfill.enabled = false
				--print("fill off")
			else
				--print("fill on")
				dmghealth = min($ + mo.hpfill.steps or 24, mo.health) -- Fix orange meter: Revert if broken
				mo.hpfill.count = min($ + mo.hpfill.steps or 24, mo.health) -- Default: 24
			end

		end
		--[[if (mo.hurtc) then
			mo.hpfill.count = 0
			mo.hpfill.enabled = false
		end]]
	end

	if not (mo.EVENTHOOKS) then
		mo.EVENTHOOKS = {}
		-- Current Event State
		mo.EVENTSTATE = ""
		--event.beginEvent("DemoEvent", mo, mo)
		--event.beginEvent("genesis_entrypoint", mo)
		--event.beginEvent("genesis_starport1", mo)
		--event.beginEvent("genesis_starport2", mo)
		--event.beginEvent("genesis_MidpointDemo", mo)
		--event.beginEvent("Starlis_Phase2", mo)
	end

end, MT_EXPSTAR)


