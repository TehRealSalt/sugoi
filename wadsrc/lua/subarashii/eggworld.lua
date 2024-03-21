freeslot(
	"MT_EGGWORLD",

	"S_EGGWORLD_SPAWN",
	"S_EGGWORLD_INTRO",
	"S_EGGWORLD",

	"S_EGGWORLD_ATK_SPIN",
	"S_EGGWORLD_ATK_CHARGE",
	"S_EGGWORLD_ATK_RAPID",
	"S_EGGWORLD_ATK_TELEPORT",

	"S_EGGWORLD_ATK_KNIFE",
	"S_EGGWORLD_ATK_KNIFEALLPLAYERS",
	"S_EGGWORLD_ATK_TELEKNIFE",

	"S_EGGWORLD_ATK_SPINWINDUP",
	"S_EGGWORLD_ATK_SPIN",

	"S_EGGWORLD_STUN",
	"S_EGGWORLD_PAIN",
	"S_EGGWORLD_RETREAT",

	"S_EGGWORLD_DEATH",
	"S_EGGWORLD_DEATH2",
	"S_EGGWORLD_DEATH3",
	"S_EGGWORLD_DEATH4",
	"S_EGGWORLD_DEATH5",
	"S_EGGWORLD_DEATH6",
	"S_EGGWORLD_DEATH7",
	"S_EGGWORLD_DEATH8",
	"S_EGGWORLD_DEATH9",
	"S_EGGWORLD_DEATH10",
	"S_EGGWORLD_DEATH11",
	"S_EGGWORLD_DEATH12",
	"S_EGGWORLD_DEATH13",
	"S_EGGWORLD_DEATH14",
	"S_EGGWORLD_DEATH15",
	"S_EGGWORLD_DEATH16",
	"S_EGGWORLD_DEATH17",
	"S_EGGWORLD_DEATH18",
	"S_EGGWORLD_DEATH19",
	"S_EGGWORLD_DEATH20",
	"S_EGGWORLD_DEATH21",
	"S_EGGWORLD_DEATH22",
	"S_EGGWORLD_DEATH23",
	"S_EGGWORLD_DEATH24",
	"S_EGGWORLD_DEATH25",

	"S_EGGWORLD_FLEE",

	"MT_EGGWORLD_FIST",
	"S_EGGWORLD_FIST",

	"MT_EGGWORLD_KNIFE",
	"S_EGGWORLD_KNIFE",

	"MT_EGGWORLD_FISTBLUR",
	"S_EGGWORLD_FISTBLUR",
	"S_EGGWORLD_FISTBLUR2",

	"MT_EGGWORLD_FISTBLURWHITE",
	"S_EGGWORLD_FISTBLURWHITE",

	"MT_EGGWORLD_KNIFEBLUR",
	"S_EGGWORLD_KNIFEBLUR",
	"S_EGGWORLD_KNIFEBLUR2",

	"MT_EGGWORLD_INTROBEAM",
	"S_EGGWORLD_INTROBEAM",

	"MT_EGGWORLD_DEATHSHINE",
	"S_EGGWORLD_DEATHSHINE",
	"S_EGGWORLD_DEATHSHINE2",

	"SPR_EWLD",
	"sfx_egworp",
	"sfx_knifes",
	"sfx_knifed"
)

mobjinfo[MT_EGGWORLD] = {
	--$Name Egg World
	--$Sprite EWLDA1
	--$Category SUGOI Bosses
	doomednum = 3550,
	spawnstate = S_EGGWORLD_SPAWN,
	painstate = S_EGGWORLD_PAIN,
	deathstate = S_EGGWORLD_DEATH,
	xdeathstate = S_EGGWORLD_FLEE,
	painsound = sfx_dmpain,
	deathsound = sfx_cybdth,
	radius = 44*FRACUNIT,
	height = 112*FRACUNIT,
	spawnhealth = 1000,
	damage = 4,
	speed = 12*FRACUNIT,
	reactiontime = 2*TICRATE,
	flags = MF_BOSS|MF_BOUNCE|MF_NOGRAVITY
}
states[S_EGGWORLD_SPAWN] = {SPR_NULL, A, -1, nil, 0, 0, S_EGGWORLD_SPAWN}
states[S_EGGWORLD_INTRO] = {SPR_NULL, A, 9*TICRATE - (TICRATE/2), nil, 0, 0, S_EGGWORLD}
states[S_EGGWORLD] = {SPR_EWLD, A, -1, nil, 0, 0, S_EGGWORLD}

states[S_EGGWORLD_ATK_CHARGE] = {SPR_EWLD, A, -1, nil, 0, 0, S_EGGWORLD_ATK_CHARGE}
states[S_EGGWORLD_ATK_RAPID] = {SPR_EWLD, A, -1, nil, 0, 0, S_EGGWORLD_ATK_RAPID}
states[S_EGGWORLD_ATK_TELEPORT] = {SPR_EWLD, E, 2, nil, 0, 0, S_EGGWORLD_ATK_TELEPORT}

states[S_EGGWORLD_ATK_KNIFE] = {SPR_EWLD, A, -1, nil, 0, 0, S_EGGWORLD_ATK_KNIFE}
states[S_EGGWORLD_ATK_KNIFEALLPLAYERS] = {SPR_EWLD, A, -1, nil, 0, 0, S_EGGWORLD_ATK_KNIFEALLPLAYERS}
states[S_EGGWORLD_ATK_TELEKNIFE] = {SPR_EWLD, E, 2, nil, 0, 0, S_EGGWORLD_ATK_KNIFE}

states[S_EGGWORLD_ATK_SPINWINDUP] = {SPR_EWLD, D|FF_ANIMATE, TICRATE, nil, 1, 1, S_EGGWORLD_ATK_SPIN}
states[S_EGGWORLD_ATK_SPIN] = {SPR_EWLD, I|FF_ANIMATE, 2, nil, 1, 1, S_EGGWORLD_ATK_SPIN}

states[S_EGGWORLD_STUN] = {SPR_EWLD, A, 2*TICRATE, A_PlaySound, sfx_s3k96, 0, S_EGGWORLD}
states[S_EGGWORLD_PAIN] = {SPR_EWLD, C, TICRATE, A_Pain, 0, 0, S_EGGWORLD_RETREAT}
states[S_EGGWORLD_RETREAT] = {SPR_EWLD, I|FF_ANIMATE, TICRATE/2, nil, 1, 1, S_EGGWORLD}

states[S_EGGWORLD_DEATH] = {SPR_EWLD, A, 8, A_Fall, 0, 0, S_EGGWORLD_DEATH2}
for i = 2,13
	states[_G["S_EGGWORLD_DEATH"..i]] = {SPR_EWLD, A, 8, A_BossScream, 0, 0, _G["S_EGGWORLD_DEATH"..(i+1)]}
end

states[S_EGGWORLD_DEATH14] = {SPR_EWLD, D|FF_FULLBRIGHT, 1, nil, 0, 0, S_EGGWORLD_DEATH15}
states[S_EGGWORLD_DEATH15] = {SPR_EWLD, E|FF_FULLBRIGHT, 1, nil, 0, 0, S_EGGWORLD_DEATH16}
states[S_EGGWORLD_DEATH16] = {SPR_EWLD, F, 80, nil, 0, 0, S_EGGWORLD_DEATH17}
states[S_EGGWORLD_DEATH17] = {SPR_EWLD, D|FF_FULLBRIGHT, 2, nil, 0, 0, S_EGGWORLD_DEATH18}
states[S_EGGWORLD_DEATH18] = {SPR_EWLD, E|FF_FULLBRIGHT, 2, nil, 0, 0, S_EGGWORLD_DEATH19}
states[S_EGGWORLD_DEATH19] = {SPR_EWLD, F, 60, nil, 0, 0, S_EGGWORLD_DEATH20}
states[S_EGGWORLD_DEATH20] = {SPR_EWLD, D|FF_FULLBRIGHT, 4, nil, 0, 0, S_EGGWORLD_DEATH21}
states[S_EGGWORLD_DEATH21] = {SPR_EWLD, E|FF_FULLBRIGHT, 4, nil, 0, 0, S_EGGWORLD_DEATH22}
states[S_EGGWORLD_DEATH22] = {SPR_EWLD, F, 40, nil, 0, 0, S_EGGWORLD_DEATH23}
states[S_EGGWORLD_DEATH23] = {SPR_EWLD, D|FF_FULLBRIGHT, 8, nil, 0, 0, S_EGGWORLD_DEATH24}
states[S_EGGWORLD_DEATH24] = {SPR_EWLD, E|FF_FULLBRIGHT, 8, nil, 0, 0, S_EGGWORLD_DEATH25}
states[S_EGGWORLD_DEATH25] = {SPR_EWLD, E|FF_FULLBRIGHT, -1, A_BossDeath, 0, 0, S_NULL}

states[S_EGGWORLD_FLEE] = {SPR_EWLD, E|FF_FULLBRIGHT, 1, nil, 0, 0, S_EGGWORLD_FLEE}

mobjinfo[MT_EGGWORLD_FIST] = {
	spawnstate = S_EGGWORLD_FIST,
	deathstate = S_BOSSEXPLODE,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	spawnhealth = 1000,
	flags = MF_NOGRAVITY|MF_PAIN|MF_NOCLIPHEIGHT|MF_NOCLIP
}
states[S_EGGWORLD_FIST] = {SPR_EWLD, B, -1, nil, 0, 0, S_EGGWORLD_FIST}

mobjinfo[MT_EGGWORLD_KNIFE] = {
	spawnstate = S_EGGWORLD_KNIFE,
	--seesound = sfx_knifes,
	--deathsound = sfx_knifed,
	spawnhealth = 1000,
	radius = 18*FRACUNIT,
	height = 4*FRACUNIT,
	speed = 40*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_MISSILE|MF_NOGRAVITY
}
states[S_EGGWORLD_KNIFE] = {SPR_EWLD, M|FF_FULLBRIGHT, 1, function(mo)
	mo.shadowscale = FRACUNIT
	if (leveltime & 1)
		local ghost = P_SpawnMobj(mo.x, mo.y, mo.z, MT_EGGWORLD_KNIFEBLUR)
		ghost.angle = mo.angle
		ghost.fuse = 5
	end
end, 0, 0, S_EGGWORLD_KNIFE}

mobjinfo[MT_EGGWORLD_FISTBLUR] = {
	spawnstate = S_EGGWORLD_FISTBLUR,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	spawnhealth = 1000,
	flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP
}
states[S_EGGWORLD_FISTBLUR] = {SPR_EWLD, N, 1, nil, 0, 0, S_EGGWORLD_FISTBLUR2}
states[S_EGGWORLD_FISTBLUR2] = {SPR_EWLD, N|TR_TRANS50|FF_FULLBRIGHT, 1, nil, 0, 0, S_EGGWORLD_FISTBLUR}

mobjinfo[MT_EGGWORLD_FISTBLURWHITE] = {
	spawnstate = S_EGGWORLD_FISTBLURWHITE,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	spawnhealth = 1000,
	flags = MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP
}
states[S_EGGWORLD_FISTBLURWHITE] = {SPR_EWLD, L|TR_TRANS50, 1, nil, 0, 0, S_EGGWORLD_FISTBLURWHITE}

mobjinfo[MT_EGGWORLD_KNIFEBLUR] = {
	spawnstate = S_EGGWORLD_KNIFEBLUR,
	radius = 18*FRACUNIT,
	height = 4*FRACUNIT,
	spawnhealth = 1000,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY
}
states[S_EGGWORLD_KNIFEBLUR] = {SPR_EWLD, O, 1, nil, 0, 0, S_EGGWORLD_KNIFEBLUR2}
states[S_EGGWORLD_KNIFEBLUR2] = {SPR_EWLD, O|TR_TRANS50|FF_FULLBRIGHT, 1, nil, 0, 0, S_EGGWORLD_KNIFEBLUR}

mobjinfo[MT_EGGWORLD_INTROBEAM] = {
	spawnstate = S_EGGWORLD_INTROBEAM,
	spawnhealth = 1000,
	dispoffset = -1,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT
}
states[S_EGGWORLD_INTROBEAM] = {SPR_EWLD, K|FF_TRANS50|FF_FULLBRIGHT, -1, nil, 1, -32, S_EGGWORLD_INTROBEAM}

mobjinfo[MT_EGGWORLD_DEATHSHINE] = {
	spawnstate = S_EGGWORLD_DEATHSHINE,
	spawnhealth = 1000,
	dispoffset = -1,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT
}
states[S_EGGWORLD_DEATHSHINE] = {SPR_EWLD, G|FF_TRANS10|FF_FULLBRIGHT, TICRATE/2, nil, 1, 96, S_EGGWORLD_DEATHSHINE2}
states[S_EGGWORLD_DEATHSHINE2] = {SPR_EWLD, H|FF_TRANS10|FF_FULLBRIGHT, TICRATE/2, nil, 1, 96, S_EGGWORLD_DEATHSHINE}

local lvlintro = 0 -- Changing, sync-required variables
local lvlinttime = 0
local eggworld = nil
local worldactive = false
local didintro = false
local worldhpfactor = 12
local worldhealadd = 0
local worldflee = 0
local center = nil

local disphp = 0 -- Changable, no-sync-required variables (for HUD or music)
local mugtimer = 0
local song = nil
local intromus = "SWITCH"
local levelmus = "MRGADO"
local bossmus = "ALCHM2"

local activetag = 1000 -- Unchanging variables, netplay may or may not break if these are changed mid-game
local introtag = 2000
local emeraldtag = 2001
local healamount = FRACUNIT / (worldhpfactor*2 - worldhealadd)
local intropatches = { -- Image, duration, fake fademask transparency
	{"EGGTLK01",  1, 0},
	{"EGGTLK01",  1, V_30TRANS},
	{"EGGTLK01",  1, V_50TRANS},
	{"EGGTLK01",  1, V_70TRANS},
	{"EGGTLK01",  7},
	{"EGGTLK02",  1},
	{"EGGTLK03",  1},
	{"EGGTLK04",  1},
	{"EGGTLK05",  1},
	{"EGGTLK06",  1},
	{"EGGTLK07",  1},
	{"EGGTLK08",  1},
	{"EGGTLK09",  1},
	{"EGGTLK10",  1},
	{"EGGTLK11",  1},
	{"EGGTLK12",  1},
	{"EGGTLK13",  1},
	{"EGGTLK14",  1},
	{"EGGTLK15",  1},
	{"EGGTLK16",  1},
	{"EGGTLK17",  1},
	{"EGGTLK18",  2},
	{"EGGTLK19",  1}, -- EGGTLK17
	{"EGGTLK20", 14}, -- EGGTLK16
	{"EGGTLK21",  1}, -- EGGTLK19
	{"EGGTLK22",  1}, -- EGGTLK20
	{"EGGTLK23",  1}, -- EGGTLK21
	{"EGGTLK24",  1}, -- EGGTLK22
	{"EGGTLK25",  1}, -- EGGTLK23
	{"EGGTLK26",  1}, -- EGGTLK24
	{"EGGTLK27",  1}, -- EGGTLK25
	{"EGGTLK28",  1}, -- EGGTLK26
	{"EGGTLK29",  1}, -- EGGTLK27
	{"EGGTLK30",  1}, -- EGGTLK28
	{"EGGTLK31",  1}, -- EGGTLK29
	{"EGGTLK32",  1}, -- EGGTLK30
	{"EGGTLK33",  1}, -- EGGTLK31
	{"EGGTLK34",  1}, -- EGGTLK32
	{"EGGTLK35",  1}, -- EGGTLK33
	{"EGGTLK36",  1}, -- EGGTLK34
	{"EGGTLK37",  1}, -- EGGTLK35
	{"EGGTLK38",  1}, -- EGGTLK36
	{"EGGTLK39",  1}, -- EGGTLK37
	{"EGGTLK40",  1}, -- EGGTLK38
	{"EGGTLK41",  1}, -- EGGTLK39
	{"EGGTLK42",  1}, -- EGGTLK40
	{"EGGTLK43",  1}, -- EGGTLK41
	{"EGGTLK44",  1}, -- EGGTLK42
	{"EGGTLK45",  1}, -- EGGTLK43
	{"EGGTLK46",  1}, -- EGGTLK44
	{"EGGTLK47", 77}, -- EGGTLK45
	{"EGGTLK48",  1}, -- EGGTLK46
	{"EGGTLK49",  1}, -- EGGTLK47
	{"EGGTLK50",  1}, -- EGGTLK48
	{"EGGTLK51",  1}, -- EGGTLK49
	{"EGGTLK52",  1}, -- EGGTLK50
	{"EGGTLK53",  1}, -- EGGTLK51
	{"EGGTLK54",  2}, -- EGGTLK16
	{"EGGTLK54",  1, V_70TRANS}, -- EGGTLK16
	{"EGGTLK54",  1, V_50TRANS}, -- EGGTLK16
	{"EGGTLK54",  1, V_30TRANS}, -- EGGTLK16
	{"EGGTLK54",  9+TICRATE, 0}, -- EGGTLK16
	{nil,         1, V_30TRANS},
	{nil,         1, V_50TRANS},
	{nil,         1, V_70TRANS}
}

local finalmapintrotime = 0
for i = 1,#intropatches
	finalmapintrotime = $1 + intropatches[i][2]
end
rawset(_G, "finalmapintrotime", finalmapintrotime)

local function P_CoolerBossTargetPlayer(actor, type) -- type: 0/nil for first sighted, 1 for closest, 2 for most rings, 3 for random
	local lastdist
	local lastrings
	local targetlist = {}

	for player in players.iterate
		if (player.pflags & PF_INVIS or player.bot or player.spectator) continue end
		if not (player.mo and player.mo.valid) continue end
		if (player.mo.health <= 0) continue end
		if not (P_CheckSight(actor, player.mo)) continue end

		if (type == 1)
			local dist = P_AproxDistance(actor.x - player.mo.x, actor.y - player.mo.y)
			if not (lastdist) or (dist < lastdist)
				lastdist = dist+1
				actor.target = player.mo
			end
			continue
		elseif (type == 2)
			local rings = player.mo.health-1
			if not (lastrings) or (rings < lastrings)
				lastrings = rings+1
				actor.target = player.mo
			end
			continue
		elseif (type == 3)
			table.insert(targetlist, player.mo)
			for k,v in ipairs(targetlist)
				if not (v and v.valid and v.player and v.player.valid)
					table.remove(targetlist, k)
				end
			end
			local key = (P_RandomRange(1, #targetlist))
			actor.target = targetlist[key]
			continue
		end

		actor.target = player.mo
		return true
	end
end

local function worldThinker(mo)
	eggworld = mo

	local playercount = 0
	for player in players.iterate
		if (player.bot) continue end
		if (player.spectator) continue end
		playercount = $1+1
	end
	playercount = max($1, 1) -- there's ALWAYS at least one player, right? :U
	worldhpfactor = min(16, 12 + (playercount/3)) -- Caps at 16 health
	worldhealadd = (playercount-1)/2

	if (mo.worldhealth == nil)
		mo.worldhealth = FRACUNIT -- percentage health!
	end

	if (mo.worldheal == nil)
		mo.worldheal = 0 -- healing when he hurts you! kinda loosely based off fighting games!
	end

	if (mo.worldhealdecay == nil)
		mo.worldhealdecay = 0 -- decays over time!
	end

	if (mo.invulntimer == nil)
		mo.invulntimer = 0
	end

	if (mo.health <= 0)
		if (mo.fists[1] and mo.fists[1].valid and mo.fists[1].health) P_KillMobj(mo.fists[1]) end
		if (mo.fists[2] and mo.fists[2].valid and mo.fists[2].health) P_KillMobj(mo.fists[2]) end
		mo.flags2 = (($1|MF2_BOSSDEAD) & !MF2_FRET)

		song = "_STOPMUSIC"
		stoppedclock = true;

		if ((mo.state >= S_EGGWORLD_DEATH14) and (mo.state <= S_EGGWORLD_FLEE))
			worldflee = $1+1
			mo.momz = FRACUNIT

			if (mo.extravalue1 <= 5) mo.extravalue1 = 5 end

			if not (worldflee > 6*TICRATE)
				if (worldflee % mo.extravalue1 == 0)
					S_StartSound(nil, sfx_s3k4e)
					mo.extravalue1 = $1-1

					if (center and center[1] and center[2])
						for i = 1,64
							local radius = 1280
							if (center[3])
								radius = center[3]
							end

							local x = (center[1]*FRACUNIT) + (P_RandomRange(-1*radius, radius)*FRACUNIT)
							local y = (center[2]*FRACUNIT) + (P_RandomRange(-1*radius, radius)*FRACUNIT)
							local z = (R_PointInSubsector(x,y).sector.floorheight) + (P_RandomRange(0, 8)*FRACUNIT)

							local explode = P_SpawnMobj(x, y, z, MT_BOSSEXPLODE)
							explode.scale = P_RandomRange(2, 4)*FRACUNIT
							explode.momz = P_RandomRange(2, 16)*FRACUNIT
						end
					end
				end
			end

			if (worldflee % 4 == 0)
				P_StartQuake(worldflee*(FRACUNIT/4), 4)
				A_BossScream(mo, 0, 0)
			end

			if not (mo.overlay and mo.overlay.valid)
				mo.overlay = P_SpawnMobj(mo.x, mo.y, mo.z, MT_EGGWORLD_DEATHSHINE)
			end
			mo.overlay.target = mo
			mo.overlay.scale = worldflee*(FRACUNIT/40)
			P_MoveOrigin(mo.overlay, mo.x, mo.y, mo.z + mo.height)
		else
			mo.extravalue1 = 36
			worldflee = 0
		end

		return
	end

	if (mo.worldhealth <= 0)
		P_KillMobj(mo)
		return true
	end

	mo.health = mo.info.spawnhealth

	if (mo.state == S_EGGWORLD_SPAWN)
		if (worldactive)
			if not (didintro)
				mo.state = S_EGGWORLD_INTRO
			else
				mo.state = S_EGGWORLD
			end
		end
		return true
	end

	--local floatheight = (24*FRACUNIT) + (abs(leveltime % 32 - 16)*(FRACUNIT/2))
	--mo.z = mo.floorz+floatheight

	local defaultfistheight = 12
	local defaultfistside = 38

	if (mo.fists == nil)
		mo.fists = {}
	end

	for i = 1,2
		if not (mo.fists[i] and mo.fists[i].valid) mo.fists[i] = P_SpawnMobj(mo.x, mo.y, mo.z, MT_EGGWORLD_FIST) end
		if (mo.fists[i].wantedvpos == nil) mo.fists[i].wantedvpos = defaultfistheight end
		if (mo.fists[i].curvpos == nil) mo.fists[i].curvpos = defaultfistheight end
		if (mo.fists[i].wantedfbpos == nil) mo.fists[i].wantedfbpos = 56 end
		if (mo.fists[i].curfbpos == nil) mo.fists[i].curfbpos = 56 end
		if (i == 2)
			if (mo.fists[i].wantedlrpos == nil) mo.fists[i].wantedlrpos = -defaultfistside end
			if (mo.fists[i].curlrpos == nil) mo.fists[i].curlrpos = -defaultfistside end
		else
			if (mo.fists[i].wantedlrpos == nil) mo.fists[i].wantedlrpos = defaultfistside end
			if (mo.fists[i].curlrpos == nil) mo.fists[i].curlrpos = defaultfistside end
		end

		mo.fists[i].target = mo

		mo.fists[i].curvpos = $1 + ((mo.fists[i].wantedvpos-$1)/16)
		mo.fists[i].curfbpos = $1 + ((mo.fists[i].wantedfbpos-$1)/8)
		mo.fists[i].curlrpos = $1 + ((mo.fists[i].wantedlrpos-$1)/8)

		mo.fists[i].sprite = SPR_EWLD
		mo.fists[i].frame = B

		mo.fists[i].shadowscale = FRACUNIT

		if (mo.state == S_EGGWORLD_PAIN)
			mo.fists[i].flags = ($1 & !MF_PAIN)
			if (leveltime % 2 == 0)
				mo.fists[i].frame = L
			end
		else
			mo.fists[i].flags = $1|MF_PAIN
		end

		mo.fists[i].flags2 = $1|MF2_EXPLOSION
		A_CapeChase(mo.fists[i], mo.fists[i].curvpos<<16, (mo.fists[i].curfbpos<<16)+mo.fists[i].curlrpos)
	end

	if not ((mo.fists[1] and mo.fists[1].valid) and (mo.fists[2] and mo.fists[2].valid)) return true end

	if (mo.state == S_EGGWORLD_INTRO)
		local worldintro = states[S_EGGWORLD_INTRO].tics - mo.tics
		local trans = max(0, NUMTRANSMAPS - (worldintro/14) + 8)

		if (worldintro < 3*TICRATE)
			song = "_STOPMUSIC"
		else
			song = bossmus
		end

		mo.fists[1].sprite = SPR_NULL
		mo.fists[2].sprite = SPR_NULL
		mo.fists[1].frame = A
		mo.fists[2].frame = A

		mo.fists[1].wantedvpos = 16
		mo.fists[2].wantedvpos = 16
		mo.fists[1].wantedfbpos = 56
		mo.fists[2].wantedfbpos = 56
		mo.fists[1].wantedlrpos = defaultfistside
		mo.fists[2].wantedlrpos = -defaultfistside

		mo.z = mo.floorz+((8+(mo.tics^2)/8)*FRACUNIT)

		A_CapeChase(mo.fists[1], mo.fists[1].curvpos<<16, (mo.fists[1].curfbpos<<16)+mo.fists[1].curlrpos)
		A_CapeChase(mo.fists[2], mo.fists[2].curvpos<<16, (mo.fists[2].curfbpos<<16)+mo.fists[2].curlrpos)

		if (worldintro == (3*TICRATE+(TICRATE/2)))
			mo.overlay = P_SpawnMobj(mo.x, mo.y, mo.floorz, MT_EGGWORLD_INTROBEAM)
			mo.overlay.target = mo
			mo.overlay.scale = 0
			mo.overlay.scalespeed = 2*FRACUNIT
			mo.overlay.destscale = 64*FRACUNIT
		end

		if (mo.overlay and mo.overlay.valid)
			P_MoveOrigin(mo.overlay, mo.x, mo.y, mo.floorz)
		end

		if (trans < NUMTRANSMAPS)
			mo.sprite = SPR_EWLD
			mo.frame = J|FF_FULLBRIGHT|(trans<<FF_TRANSSHIFT)
			mo.fists[1].sprite = SPR_EWLD
			mo.fists[2].sprite = SPR_EWLD
			mo.fists[1].frame = L|FF_FULLBRIGHT|(trans<<FF_TRANSSHIFT)
			mo.fists[2].frame = L|FF_FULLBRIGHT|(trans<<FF_TRANSSHIFT)
			mo.fists[1].flags = ($1 & !MF_PAIN)
			mo.fists[2].flags = ($1 & !MF_PAIN)
		end

		if (worldintro == states[S_EGGWORLD_INTRO].tics-1)
			--S_StartSound(nil, sfx_s3k83)
			P_StartQuake(24*FRACUNIT, TICRATE)
			P_LinedefExecute(activetag)
			mo.z = mo.floorz
			didintro = true
		else
			P_StartQuake((worldintro/TICRATE)*(3*FRACUNIT/2), 1)
		end

		return true
	end

	if (mo.overlay and mo.overlay.valid)
		mo.overlay.destscale = 0
		mo.overlay.scalespeed = 4*FRACUNIT
		if (mo.overlay.scale < FRACUNIT/5)
			P_RemoveMobj(mo.overlay)
		end
	end

	if not (mo.state == S_EGGWORLD_PAIN)
		if (mo.worldheal)
			local decaylength = 2*TICRATE
			if (mo.worldhealdecay >= decaylength)
				mo.worldheal = $1-(FRACUNIT/128) --$1-((FRACUNIT / (worldhpfactor*2 - worldhealadd)) / 4)
				mo.worldhealdecay = decaylength-TICRATE
			end
			mo.worldhealdecay = $1+1
		else
			mo.worldhealdecay = 0
		end
	end

	if not ((mo.target and mo.target.valid) and (mo.target.flags & MF_SHOOTABLE)) or not (worldactive)
		mo.fists[1].wantedvpos = defaultfistheight
		mo.fists[2].wantedvpos = defaultfistheight
		mo.fists[1].wantedfbpos = 56
		mo.fists[2].wantedfbpos = 56
		mo.fists[1].wantedlrpos = defaultfistside
		mo.fists[2].wantedlrpos = -defaultfistside

		if (P_CoolerBossTargetPlayer(mo, 0))
			return true
		end

		mo.reactiontime = mo.info.reactiontime
		mo.extravalue1 = 0
		mo.extravalue2 = 0
		mo.momx = $1/2
		mo.momy = $1/2
		if (didintro)
			P_SetMobjStateNF(mo, S_EGGWORLD)
		else
			mo.state = S_EGGWORLD_SPAWN
		end
		return true
	end

	local fistheight = (mo.target.z - mo.z)/FRACUNIT
	if (fistheight < defaultfistheight)
		fistheight = defaultfistheight
	elseif (fistheight > (mo.height/FRACUNIT) - 16)
		fistheight = (mo.height/FRACUNIT) - 16
	end

	mo.flags = (($1|MF_SPECIAL) & !MF_NOGRAVITY)
	mo.flags2 = $1|MF2_EXPLOSION
	mo.friction = FRACUNIT
	song = bossmus

	if not ((mo.state == S_EGGWORLD_PAIN) or (mo.state == S_EGGWORLD_STUN) or (mo.state == S_EGGWORLD_RETREAT))
		if ((mo.reactiontime != nil) and (mo.reactiontime > 0))
			mo.reactiontime = $1-1
		end

		if (mo.invulntimer != nil)
			if (mo.invulntimer > 0)
				mo.flags2 = $1|MF2_FRET
				mo.frame = C
				mo.invulntimer = $1-1
			else
				mo.flags2 = ($1 & !MF2_FRET)
				mo.frame = states[mo.state].frame
			end
		end
	end

	if (mo.wantedangle != nil)
		mo.angle = $1 + ((mo.wantedangle-$1)/8)
	end

	local targetdist = P_AproxDistance(mo.x - mo.target.x, mo.y - mo.target.y)
	local meleedist = 640*FRACUNIT

	if ((mo.state == S_EGGWORLD_PAIN) or (mo.state == S_EGGWORLD_STUN))
		if ((mo.state == S_EGGWORLD_STUN) and (mo.invulntimer))
			mo.state = S_EGGWORLD
			return true
		end

		mo.flags = ($1 & !MF_PAIN)

		if not (mo.invulntimer)
			mo.flags = $1|MF_SHOOTABLE
		end

		mo.extravalue1 = 0
		mo.extravalue2 = 0

		mo.fists[1].wantedvpos = defaultfistheight
		mo.fists[2].wantedvpos = defaultfistheight
		mo.fists[1].wantedfbpos = 56
		mo.fists[2].wantedfbpos = 56

		mo.momx = $1/2
		mo.momy = $1/2

		if (mo.state == S_EGGWORLD_PAIN)
			mo.wantedangle = R_PointToAngle2(mo.x, mo.y, mo.target.x, mo.target.y)
			mo.fists[1].wantedlrpos = defaultfistside
			mo.fists[2].wantedlrpos = -defaultfistside

			mo.reactiontime = mo.info.reactiontime/2
			if ((mo.invulntimer == nil) or (mo.invulntimer <= 0)) and (playercount > 1)
				mo.invulntimer = mo.info.reactiontime/2 + (max(0, playercount-2) * (TICRATE/7)) -- no invuln time in SP, 1 second minimum in MP, ~5.3 seconds maximum in MP
			end
		else
			mo.fists[1].wantedlrpos = 112
			mo.fists[2].wantedlrpos = -112
		end

		--P_CoolerBossTargetPlayer(mo, 3)
	elseif (mo.state == S_EGGWORLD)
		mo.flags = ($1 & !MF_PAIN)

		if not (mo.invulntimer)
			mo.flags = $1|MF_SHOOTABLE
		end

		mo.wantedangle = R_PointToAngle2(mo.x, mo.y, mo.target.x, mo.target.y)

		mo.fists[1].wantedvpos = fistheight
		mo.fists[2].wantedvpos = fistheight
		mo.fists[1].wantedfbpos = 56
		mo.fists[2].wantedfbpos = 56
		mo.fists[1].wantedlrpos = defaultfistside
		mo.fists[2].wantedlrpos = -defaultfistside

		local testmove = nil
		local movelist = {}

		if (P_RandomChance(FRACUNIT/32))
			if (testmove)
				movelist = {testmove}
			elseif (mo.worldhealth <= FRACUNIT/worldhpfactor) -- last move
				table.insert(movelist, S_EGGWORLD_ATK_SPINWINDUP)
			elseif (mo.worldhealth <= FRACUNIT/3)
				table.insert(movelist, S_EGGWORLD_ATK_SPINWINDUP)
				table.insert(movelist, S_EGGWORLD_ATK_TELEKNIFE)
				if (playercount > 3)
					table.insert(movelist, S_EGGWORLD_ATK_KNIFEALLPLAYERS)
					table.insert(movelist, S_EGGWORLD_ATK_SPINWINDUP)
				end
			elseif (mo.worldhealth <= 2*FRACUNIT/3)
				table.insert(movelist, S_EGGWORLD_ATK_KNIFE)
				table.insert(movelist, S_EGGWORLD_ATK_KNIFE)
				table.insert(movelist, S_EGGWORLD_ATK_TELEPORT)
				if (playercount > 3)
					table.insert(movelist, S_EGGWORLD_ATK_KNIFEALLPLAYERS)
					table.insert(movelist, S_EGGWORLD_ATK_KNIFEALLPLAYERS)
				end
			end
		end

		if (targetdist > meleedist)
			P_InstaThrust(mo, mo.angle, mo.info.speed) -- Charge towards target
		else
			if (testmove)
				movelist = {testmove}
			elseif (mo.worldhealth <= FRACUNIT/worldhpfactor) -- last move
				table.insert(movelist, S_EGGWORLD_ATK_SPINWINDUP)
			elseif (mo.worldhealth <= FRACUNIT/3)
				table.insert(movelist, S_EGGWORLD_ATK_SPINWINDUP) -- I'm an asshole.
				table.insert(movelist, S_EGGWORLD_ATK_TELEKNIFE)
			elseif (mo.worldhealth <= 2*FRACUNIT/3)
				table.insert(movelist, S_EGGWORLD_ATK_CHARGE)
				table.insert(movelist, S_EGGWORLD_ATK_RAPID)
				table.insert(movelist, S_EGGWORLD_ATK_RAPID)
				table.insert(movelist, S_EGGWORLD_ATK_TELEPORT)
			elseif (mo.worldhealth >= FRACUNIT)
				table.insert(movelist, S_EGGWORLD_ATK_CHARGE)
			else
				table.insert(movelist, S_EGGWORLD_ATK_CHARGE)
				table.insert(movelist, S_EGGWORLD_ATK_RAPID)
			end

			if (P_RandomChance(FRACUNIT/3)) -- Strafe
				P_Thrust(mo, mo.angle - ANGLE_90, mo.info.speed/8)
			else
				P_Thrust(mo, mo.angle + ANGLE_90, mo.info.speed/8)
			end

			if (targetdist < meleedist/2)
				P_InstaThrust(mo, mo.angle, mo.info.speed/2)
			end
		end

		if ((#movelist >= 1) and not (mo.reactiontime))
			mo.state = movelist[P_RandomKey(#movelist)+1]
		end
	elseif (mo.state == S_EGGWORLD_ATK_CHARGE)
		if not (mo.reactiontime)
			if not (mo.extravalue2 == 1) -- Set up attack
				mo.reactiontime = 3*mo.info.reactiontime/2
				mo.extravalue1 = P_RandomRange(1,2)
				mo.extravalue2 = 1
				mo.momx = $1/2
				mo.momy = $1/2
			else -- Back to spawn loop
				mo.reactiontime = mo.info.reactiontime
				mo.extravalue1 = 0
				mo.extravalue2 = 0
				mo.state = S_EGGWORLD
				return true
			end
		end

		local otherfist = 2
		if (mo.extravalue1 == 2)
			otherfist = 1
		end

		mo.fists[1].wantedvpos = defaultfistheight
		mo.fists[2].wantedvpos = defaultfistheight
		mo.fists[1].wantedlrpos = defaultfistside
		mo.fists[2].wantedlrpos = -defaultfistside
		mo.fists[otherfist].wantedfbpos = 56
		if (mo.reactiontime >= TICRATE)
			mo.fists[mo.extravalue1].wantedfbpos = 56 + 384
		else
			mo.fists[mo.extravalue1].wantedfbpos = 56
		end

		if (leveltime & 1)
			local ghost = P_SpawnMobj(mo.fists[mo.extravalue1].x, mo.fists[mo.extravalue1].y, mo.fists[mo.extravalue1].z, MT_EGGWORLD_FISTBLUR)
			ghost.fuse = 5
		end

		local wallcheck = P_SpawnMobj(mo.fists[mo.extravalue1].x, mo.fists[mo.extravalue1].y, mo.fists[mo.extravalue1].z, MT_GARGOYLE)
		wallcheck.flags = MF_NOGRAVITY|MF_NOCLIPTHING
		wallcheck.radius = mo.fists[mo.extravalue1].radius
		wallcheck.height = mo.fists[mo.extravalue1].height

		if not (P_TryMove(wallcheck, wallcheck.x + mo.momx, wallcheck.y + mo.momy, true))
			P_RemoveMobj(wallcheck)
			mo.reactiontime = mo.info.reactiontime
			mo.extravalue1 = 0
			mo.extravalue2 = 0
			mo.state = S_EGGWORLD_STUN
			return true
		else
			P_RemoveMobj(wallcheck)
			P_InstaThrust(mo, mo.angle, 2*mo.info.speed)
			if (leveltime % 15 == 0)
				S_StartSound(mo, sfx_s3kd7s)
			end
		end
	elseif (mo.state == S_EGGWORLD_ATK_RAPID)
		if not (mo.reactiontime)
			if not (mo.extravalue2 == 1) -- Set up attack
				mo.reactiontime = mo.info.reactiontime
				mo.extravalue2 = 1
				mo.momx = $1/2
				mo.momy = $1/2
			else -- Back to spawn loop
				mo.reactiontime = mo.info.reactiontime
				mo.extravalue1 = 0
				mo.extravalue2 = 0
				mo.state = S_EGGWORLD_STUN
				return true
			end
		end

		mo.fists[1].wantedvpos = fistheight
		mo.fists[2].wantedvpos = fistheight
		mo.fists[1].wantedlrpos = defaultfistside
		mo.fists[2].wantedlrpos = -defaultfistside

		if ((mo.reactiontime % 6 == 0))
			mo.fists[1].wantedfbpos = 56
			mo.fists[2].wantedfbpos = 56 + (meleedist/FRACUNIT)
			S_StartSound(mo, sfx_s3kc9s)
		elseif ((mo.reactiontime % 3 == 0))
			mo.fists[1].wantedfbpos = 56 + (meleedist/FRACUNIT)
			mo.fists[2].wantedfbpos = 56
			S_StartSound(mo, sfx_s3kc9s)
		end

		if (leveltime & 1)
			local ghost1 = P_SpawnMobj(mo.fists[1].x, mo.fists[1].y, mo.fists[1].z, MT_EGGWORLD_FISTBLUR)
			ghost1.fuse = 5
			local ghost2 = P_SpawnMobj(mo.fists[2].x, mo.fists[2].y, mo.fists[2].z, MT_EGGWORLD_FISTBLUR)
			ghost2.fuse = 5
		end

		if (targetdist > 3*meleedist/4)
			P_InstaThrust(mo, mo.angle, 3*mo.info.speed/4)
		else
			if (P_RandomChance(FRACUNIT/3)) -- Strafe
				P_Thrust(mo, mo.angle - ANGLE_90, mo.info.speed/32)
			else
				P_Thrust(mo, mo.angle + ANGLE_90, mo.info.speed/32)
			end
			P_InstaThrust(mo, mo.angle + ANGLE_180, mo.info.speed/4)
		end

		mo.wantedangle = R_PointToAngle2(mo.x, mo.y, mo.target.x, mo.target.y)
		mo.angle = $1 + ((mo.wantedangle-$1)/8)
	elseif ((mo.state == S_EGGWORLD_ATK_TELEPORT) or (mo.state == S_EGGWORLD_ATK_TELEKNIFE))
		if not (center)
			mo.reactiontime = mo.info.reactiontime
			mo.extravalue1 = 0
			mo.extravalue2 = 0
			mo.state = S_EGGWORLD
			return true
		end

		P_SpawnGhostMobj(mo)
		local ghost1 = P_SpawnMobj(mo.fists[1].x, mo.fists[1].y, mo.fists[1].z, MT_EGGWORLD_FISTBLURWHITE)
		ghost1.fuse = 8
		local ghost2 = P_SpawnMobj(mo.fists[2].x, mo.fists[2].y, mo.fists[2].z, MT_EGGWORLD_FISTBLURWHITE)
		ghost2.fuse = 8

		local radius = 960
		if (center[3])
			radius = 3*center[3]/4
		end

		--[[
		local function findrandomplayer() -- bleh, doesn't work as well as i had hoped; wanted egg world to only move a specific distance from his position
			local ps = {} -- all of the available p's!
			for player in players.iterate
				if not (player.mo and player.mo.valid) continue end
				table.insert(ps, player)
			end
			return ps[P_RandomKey(#ps)+1]
		end
		local wantedp = findrandomplayer()

		local check = P_SpawnMobj(mo.x, mo.y, mo.z, MT_GARGOYLE) --P_SpawnMobj(wantedp.mo.x, wantedp.mo.y, wantedp.mo.z, MT_GARGOYLE)
		check.flags = MF_NOGRAVITY|MF_NOCLIPTHING
		check.radius = mo.radius
		check.height = mo.height

		local move = radius*FRACUNIT
		local dir = FixedAngle(P_RandomRange(0, 360)*FRACUNIT)
		local xmove = P_ReturnThrustX(check, dir, move)
		local ymove = P_ReturnThrustY(check, dir, move)
		local canmovemore = P_TryMove(check, check.x + xmove, check.y + ymove, true)

		for player in players.iterate
			if not (canmovemore) break end
			if not (player.mo and player.mo.valid) continue end

			while (P_AproxDistance(check.x - player.mo.x, check.y - player.mo.y) <= 3*check.radius) and (canmovemore)
				move = $1/2
				dir = FixedAngle(P_RandomRange(0, 360)*FRACUNIT))
				xmove = P_ReturnThrustX(check, dir, move)
				ymove = P_ReturnThrustY(check, dir, move)
				if (abs(move) < 8*FRACUNIT)
					canmovemore = false
				else
					canmovemore = P_TryMove(check, check.x + xmove, check.y + ymove, true)
					P_BounceMove(check)
				end
			end
		end

		P_SetOrigin(mo, check.x, check.y, check.z)
		P_RemoveMobj(check)
		]]

		local x = (center[1]*FRACUNIT) + (P_RandomRange(-1*radius, radius)*FRACUNIT)
		local y = (center[2]*FRACUNIT) + (P_RandomRange(-1*radius, radius)*FRACUNIT)
		local z = R_PointInSubsector(x,y).sector.floorheight

		local blocked = true
		local loops = 0

		while (blocked) and not (loops > 64) -- if it needs to loop more than 64 times to find a good position...
			loops = $1+1 -- then it's probably never finding it, lets just let a player take a cheap hit and move on :X
			local badspot = false

			if (R_PointToDist2(x, y, mo.x, mo.y) <= 256*FRACUNIT) and (loops < 32) -- don't teleport to the same spot :V (ignore this check after a certain point; more likely to happen in big netgames)
				badspot = true -- check this first, so that we can skip the player iterate if this is already a bad spot! efficiency!
			end

			if not (badspot)
				for player in players.iterate
					if not (player.mo and player.mo.valid) continue end
					if (R_PointToDist2(x, y, player.mo.x, player.mo.y) <= 512*FRACUNIT)
						badspot = true
						break
					end
				end
			end

			if (badspot)
				x = (center[1]*FRACUNIT) + (P_RandomRange(-1*radius, radius)*FRACUNIT)
				y = (center[2]*FRACUNIT) + (P_RandomRange(-1*radius, radius)*FRACUNIT)
				z = R_PointInSubsector(x,y).sector.floorheight
			else
				blocked = false
			end
		end

		P_SetOrigin(mo, x, y, z)

		S_StartSound(nil, sfx_egworp)

		mo.angle = R_PointToAngle2(mo.x, mo.y, mo.target.x, mo.target.y)
		mo.wantedangle = mo.angle

		mo.fists[1].wantedvpos = defaultfistheight
		mo.fists[2].wantedvpos = defaultfistheight
		mo.fists[1].wantedfbpos = 56
		mo.fists[2].wantedfbpos = 56
		mo.fists[1].wantedlrpos = defaultfistside
		mo.fists[2].wantedlrpos = -defaultfistside

		mo.fists[1].curvpos = defaultfistheight
		mo.fists[2].curvpos = defaultfistheight
		mo.fists[1].curfbpos = 56
		mo.fists[2].curfbpos = 56
		mo.fists[1].curlrpos = defaultfistside
		mo.fists[2].curlrpos = -defaultfistside

		P_SpawnGhostMobj(mo)
		local ghost3 = P_SpawnMobj(mo.fists[1].x, mo.fists[1].y, mo.fists[1].z, MT_EGGWORLD_FISTBLURWHITE)
		ghost3.fuse = 8
		local ghost4 = P_SpawnMobj(mo.fists[2].x, mo.fists[2].y, mo.fists[2].z, MT_EGGWORLD_FISTBLURWHITE)
		ghost4.fuse = 8

		mo.extravalue1 = 0
		mo.extravalue2 = 0
		mo.momx = $1/2
		mo.momy = $1/2

		if (mo.state == S_EGGWORLD_ATK_TELEKNIFE)
			mo.state = S_EGGWORLD_ATK_KNIFE
		else
			mo.reactiontime = mo.info.reactiontime/2
			mo.state = S_EGGWORLD
		end
	elseif ((mo.state == S_EGGWORLD_ATK_KNIFE) or (mo.state == S_EGGWORLD_ATK_KNIFEALLPLAYERS))
		if not (mo.reactiontime)
			if not (mo.extravalue2 == 1) -- Set up attack
				mo.reactiontime = 2*mo.info.reactiontime/3
				mo.extravalue1 = 0
				mo.extravalue2 = 1
				mo.momx = $1/2
				mo.momy = $1/2
			else -- Back to spawn loop
				mo.reactiontime = mo.info.reactiontime
				mo.extravalue1 = 0
				mo.extravalue2 = 0
				mo.state = S_EGGWORLD_STUN
				return true
			end
		end

		mo.wantedangle = mo.angle + ANGLE_90 + ANGLE_45

		mo.fists[1].wantedvpos = defaultfistheight
		mo.fists[2].wantedvpos = defaultfistheight
		mo.fists[1].wantedlrpos = 128
		mo.fists[2].wantedlrpos = -128
		mo.fists[1].wantedfbpos = 0
		mo.fists[2].wantedfbpos = 0

		if (mo.state == S_EGGWORLD_ATK_KNIFE)
			local numknives = min(64, 24 + (playercount-1 * 4)) -- 1p knives = 24, 10p knives = 64
			if (mo.reactiontime == mo.info.reactiontime/3)
				A_MultiShot(mo, (MT_EGGWORLD_KNIFE<<16)+numknives, 0)
				S_StartSound(nil, sfx_knifes)
			end
		elseif (mo.state == S_EGGWORLD_ATK_KNIFEALLPLAYERS)
			if (mo.reactiontime == (2*mo.info.reactiontime/3)-1)
				mo.momz = 16*FRACUNIT
			end

			if (mo.reactiontime == mo.info.reactiontime/3)
			or (mo.reactiontime == mo.info.reactiontime/3 - 5)
			or (mo.reactiontime == mo.info.reactiontime/3 - 10)
				for player in players.iterate
					if not ((player and player.valid) and (player.mo and player.mo.valid)) continue end
					if (player.spectator or player.pflags & PF_INVIS or player.playerstate != PST_LIVE) continue end
					P_SpawnPointMissile(mo, player.mo.x + (4*player.mo.momx/3),
						player.mo.y + (4*player.mo.momy/3), player.mo.z + (player.mo.height/2) + (4*player.mo.momz/3),
						MT_EGGWORLD_KNIFE, mo.x, mo.y, mo.z + (mo.height/2))
				end
				S_StartSound(nil, sfx_knifes)
			end

			if ((mo.reactiontime <= 2) and not (P_IsObjectOnGround(mo)))
				mo.reactiontime = 3
			end
		end
	elseif ((mo.state == S_EGGWORLD_ATK_SPINWINDUP) or (mo.state == S_EGGWORLD_ATK_SPIN) or (mo.state == S_EGGWORLD_RETREAT))
		if not (mo.reactiontime) and not (mo.state == S_EGGWORLD_RETREAT)
			if not (mo.extravalue2 == 1) -- Set up attack
				mo.reactiontime = 3*mo.info.reactiontime
				mo.extravalue2 = 1
				mo.momx = $1/2
				mo.momy = $1/2
				S_StartSound(nil, sfx_s3kd8s)
			else -- Back to spawn loop
				mo.reactiontime = 5*mo.info.reactiontime/2
				mo.extravalue1 = 0
				mo.extravalue2 = 0
				mo.state = S_EGGWORLD_STUN
				return true
			end
		end

		mo.flags = $1 & !MF_SHOOTABLE

		mo.wantedangle = mo.angle + ANGLE_90 + ANGLE_45

		mo.fists[1].wantedvpos = defaultfistheight
		mo.fists[2].wantedvpos = defaultfistheight
		mo.fists[1].wantedlrpos = 128
		mo.fists[2].wantedlrpos = -128
		mo.fists[1].wantedfbpos = 0
		mo.fists[2].wantedfbpos = 0

		if ((mo.state == S_EGGWORLD_ATK_SPIN) or (mo.state == S_EGGWORLD_RETREAT))
			mo.flags = $1|MF_PAIN

			local dir = R_PointToAngle2(mo.x, mo.y, mo.target.x, mo.target.y)
			if (mo.state == S_EGGWORLD_RETREAT)
				dir = R_PointToAngle2(mo.target.x, mo.target.y, mo.x, mo.y)
			end

			P_Thrust(mo, dir, mo.info.speed/5)
			if (leveltime % 15 == 0)
				S_StartSound(mo, sfx_s3kc0s)
			end

			if (leveltime & 1)
				local ghost1 = P_SpawnMobj(mo.fists[1].x, mo.fists[1].y, mo.fists[1].z, MT_EGGWORLD_FISTBLUR)
				ghost1.fuse = 5
				local ghost2 = P_SpawnMobj(mo.fists[2].x, mo.fists[2].y, mo.fists[2].z, MT_EGGWORLD_FISTBLUR)
				ghost2.fuse = 5
			end

			--[[if (mo.state == S_EGGWORLD_ATK_SPIN)
				local dust = P_SpawnMobj(mo.x, mo.y, mo.z, MT_PARTICLE)
				dust.frame = A|FF_FULLBRIGHT|FF_TRANS80
				dust.scale = 2*FRACUNIT
				dust.destscale = 6*FRACUNIT
				P_InstaThrust(dust, dir+ANGLE_180+FixedAngle(P_RandomRange(-45,45)*FRACUNIT), P_RandomRange(4,16)*FRACUNIT)
				dust.momz = P_RandomRange(1,4)*FRACUNIT
				dust.fuse = TICRATE/3
			end]]
		else
			mo.momx = $1/2
			mo.momy = $1/2
		end
	end

	return true
end

local function hurtWorld(tar, inf, src)
	tar.worldhealth = max(0, $1-(FRACUNIT/worldhpfactor))
	tar.worldheal = $1 + healamount
	tar.worldhealdecay = 0

	mugtimer = -TICRATE
end

local function healWorld(tar, inf, src)
	if not (eggworld and eggworld.valid) return end

	if (tar and tar.valid)
	and (tar.player and tar.player.valid)
	and (tar.player.bot == BOT_2PAI)
		return
	end

	eggworld.worldhealth = min($1+eggworld.worldheal, FRACUNIT)
	eggworld.worldheal = 0
	eggworld.worldhealdecay = 0

	mugtimer = TICRATE

	if (tar and tar.valid)
	and ((inf and inf.valid and inf.type == MT_EGGWORLD_KNIFE)
	or (src and src.valid and src.type == MT_EGGWORLD_KNIFE))
		S_StartSound(tar, sfx_knifed)
	end
end

local function stopShootingMe(fist, bullet)
	if not (fist and fist.valid) return end
	if not (bullet and bullet.valid) return end

	if not (bullet.flags & MF_MISSILE) return end
	if (fist.target == bullet.target) return end

	P_KillMobj(bullet)
	S_StartSound(nil, sfx_mspogo)
	return true
end

local function mapLoadHookNice(map)
	center = nil
	for thing in mapthings.iterate
		if (thing.type == 292) -- MT_BOSS3WAYPOINT
			center = {thing.x, thing.y, thing.angle}
		end
	end

	if (mapheaderinfo[map].finalmapintro)
		customhud.disable("bossmeter")

		if (All7Emeralds(emeralds)) and not (modeattacking) -- no record attack, marathon, or dedicated servers
		and not (server and server.valid and (server.marathon or server.isdedicated))
			P_LinedefExecute(emeraldtag)
		end

		if (modeattacking)
			P_LinedefExecute(introtag)
			return
		end

		for player in players.iterate
			if (player.starpostnum)
				P_LinedefExecute(introtag)
				return
			end
		end

		lvlintro = 1
		lvlinttime = intropatches[lvlintro][2]
	else
		customhud.enable("bossmeter")
	end
end

local function worldActivate(line, mo, sec)
	if not (worldactive)
		worldactive = true
	elseif ((mo and mo.valid) and (mo.player and mo.player.valid))
		mo.player.powers[pw_flashing] = 3*TICRATE
	end
end

local function introThinker()
	levelmus = "MRGADO"
	bossmus = "ALCHM2"

	if (mapheaderinfo[gamemap].finalmapintro)
		if (lvlintro > 0)
			stoppedclock = true

			for player in players.iterate
				player.pflags = $1|PF_FULLSTASIS
				if (player.mo and player.mo.valid)
					player.mo.angle = ANGLE_90
				end
			end

			song = intromus

			if (lvlinttime > 0)
				lvlinttime = $1-1
			else
				lvlintro = $1+1
				if ((lvlintro > #intropatches) or not (intropatches[lvlintro]))
					lvlintro = 0
					P_LinedefExecute(introtag)
					stoppedclock = false
				else
					lvlinttime = intropatches[lvlintro][2]
				end
			end
		else
			if not (worldactive) and (leveltime > 2)
				song = levelmus
			end
		end

		if (worldactive)
			G_SetCustomExitVars(sugoi.hubMaps["kawaiii"], 0);
			stagefailed = false;
		else
			G_SetCustomExitVars(175, 2); -- star genesis
			stagefailed = true;
		end
	end

	if (song != nil)
		if (song == "_STOPMUSIC")
			S_StopMusic()
		else
			S_ChangeMusic(song, true)
		end
	end
end

local function resetWorld(map)
	lvlintro = 0
	lvlinttime = 0
	eggworld = nil
	worldactive = false
	didintro = false
	worldhpfactor = 12
	worldhealadd = 0
	worldflee = 0
	center = nil
	song = nil

	disphp = 0
	mugtimer = 0
end

local function synchShit(net)
	lvlintro = net(lvlintro)
	lvlinttime = net(lvlinttime)
	eggworld = net(eggworld)
	worldactive = net(worldactive)
	didintro = net(didintro)
	worldhpfactor = net(worldhpfactor)
	worldhealadd = net(worldhealadd)
	worldflee = net(worldflee)
	center = net(center)
	--song = net(song)
end

addHook("MapChange", resetWorld)
addHook("MapLoad", mapLoadHookNice)

addHook("ThinkFrame", introThinker)

addHook("LinedefExecute", worldActivate, "WORLDACT")
addHook("BossThinker", worldThinker, MT_EGGWORLD)
addHook("MobjDamage", hurtWorld, MT_EGGWORLD)
addHook("MobjDamage", healWorld, MT_PLAYER)
addHook("MobjCollide", stopShootingMe, MT_EGGWORLD_FIST)

addHook("NetVars", synchShit)

-- Hud drawing

local function whiteWorld(v)
	local white = v.cachePatch("WORLDWHT")
	local black = v.cachePatch("BLAPCK")
	local screenscale = max(v.width()/v.dupx(), v.height()/v.dupy())

	if (lvlintro > 0)
		if (intropatches[lvlintro][1] != nil)
			v.drawFill(nil, nil, nil, nil, 172)
			v.draw(0, -8, v.cachePatch(intropatches[lvlintro][1]))
		end

		if (intropatches[lvlintro][3] != nil)
			v.drawScaled(-1, -1, (screenscale*FRACUNIT)+2, black, V_SNAPTOTOP|V_SNAPTOLEFT|intropatches[lvlintro][3])
		end

		return
	end

	local tint = max(0, NUMTRANSMAPS-(worldflee/12)+10)
	if (tint >= NUMTRANSMAPS) return end

	v.drawScaled(-1, -1, (screenscale*FRACUNIT)+2, white, V_SNAPTOTOP|V_SNAPTOLEFT|(tint<<FF_TRANSSHIFT))
end

local function worldHud(v, p)
	local bar = v.cachePatch("WORLDBAR")

	local mugshot = v.cachePatch("WORLDMUG")
	local mugshot2 = v.cachePatch("WORLDMG2")
	local mugshot3 = v.cachePatch("WORLDMG3")

	local easteregg = v.cachePatch("SVICTORY")

	local width = v.width() / v.dupx()
	local height = v.height() / v.dupy()

	if ((eggworld and eggworld.valid) and (eggworld.health > 0) and (worldactive) and (didintro))
		local barlength = 144
		local barheight = 6
		local startx = 320 - barlength - 16
		local starty = 200 - barheight - 18

		--v.drawFill(startx, starty, barlength, barheight, 31|V_SNAPTOBOTTOM|V_SNAPTORIGHT)

		if (eggworld.health > 0)
			if not (disphp == eggworld.worldhealth)
				disphp = $1 + ((eggworld.worldhealth - $1)/8)
				if (abs(eggworld.worldhealth - disphp) < FRACUNIT/barlength)
					disphp = eggworld.worldhealth
				end
			end

			if ((disphp > 0) and (FixedMul(disphp, barlength) < 1)) disphp = FRACUNIT/barlength + 1 end

			if (eggworld.worldheal > 0)
				v.drawFill(startx, starty, min(FixedMul(disphp+eggworld.worldheal, barlength), barlength), barheight, 34|V_SNAPTOBOTTOM|V_SNAPTORIGHT)
			elseif (((eggworld.worldhealth - disphp)/8) > 0)
				v.drawFill(startx, starty, min(FixedMul(eggworld.worldhealth, barlength), barlength), barheight, 34|V_SNAPTOBOTTOM|V_SNAPTORIGHT)
			end

			v.drawFill(startx, starty, min(FixedMul(disphp, barlength), barlength), barheight, 196|V_SNAPTOBOTTOM|V_SNAPTORIGHT)
			v.drawFill(startx, starty + barheight/6, min(FixedMul(disphp, barlength), barlength), 2*barheight/3, 194|V_SNAPTOBOTTOM|V_SNAPTORIGHT)
			v.drawFill(startx, starty + barheight/3, min(FixedMul(disphp, barlength), barlength), barheight/3, 192|V_SNAPTOBOTTOM|V_SNAPTORIGHT)
		end

		v.draw(startx, starty, bar, V_SNAPTOBOTTOM|V_SNAPTORIGHT)
		--v.drawString(startx+106, starty-11, "Egg World", V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_YELLOWMAP, "right")

		local wantedmug = mugshot
		if (mugtimer > 0)
			wantedmug = mugshot2
			mugtimer = $1-1
		elseif (mugtimer < 0)
			wantedmug = mugshot3
			mugtimer = $1+1
		end
		v.draw(startx+112, starty-3, wantedmug, V_SNAPTOBOTTOM|V_SNAPTORIGHT)

		if ((eggworld.health > 0) and (p.lives <= 0) and (p.playerstate == PST_DEAD))
			v.draw((width/2) - (easteregg.width/2), (height/2) - (easteregg.height/2), easteregg, V_SNAPTOTOP|V_SNAPTOLEFT)
		end
	end

	whiteWorld(v)
end

hud.add(worldHud, "game")
hud.add(whiteWorld, "scores")

-- Boss map, share powerups

freeslot(
	"MT_HALFRING_BOX",
	"MT_HALFRING_ICON",
	"S_HALFRING_BOX",
	"S_HALFRING_ICON1",
	"S_HALFRING_ICON2",
	"SPR_TVHR",

	"MT_PITYALL_BOX",
	"MT_PITYALL_ICON",
	"S_PITYALL_BOX",
	"S_PITYALL_ICON1",
	"S_PITYALL_ICON2",
	"SPR_TVPA"
)

function A_AllPlayersRingBox(mo, v1, v2)
	for player in players.iterate
		if (player == mo.target.player) or (gametyperules & GTR_FRIENDLY)
			P_GivePlayerRings(player, mo.info.reactiontime);

			if (mo.info.seesound)
				S_StartSound(player.mo, mo.info.seesound);
			end
		end
	end
end

function A_AllPlayersPityShield(mo, v1, v2)
	for player in players.iterate
		if (player == mo.target.player) or ((gametyperules & GTR_FRIENDLY) and not (player.powers[pw_shield] & SH_NOSTACK))
			P_SwitchShield(player, SH_PINK);
			S_StartSound(player.mo, mo.info.seesound);
		end
	end
end

mobjinfo[MT_HALFRING_BOX] = {
	--$Name All Players 5-Ring Monitor
	--$Sprite TVHRA0
	--$Category SUGOI Powerups
	doomednum = 3551,
	spawnstate = S_HALFRING_BOX,
	painstate = S_HALFRING_BOX,
	deathstate = S_BOX_POP1,
	deathsound = sfx_pop,
	radius = 18*FRACUNIT,
	height = 40*FRACUNIT,
	spawnhealth = 1,
	speed = 1,
	damage = MT_HALFRING_ICON,
	flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR
}

mobjinfo[MT_HALFRING_ICON] = {
	spawnstate = S_HALFRING_ICON1,
	seesound = sfx_itemup,
	radius = 8*FRACUNIT,
	height = 14*FRACUNIT,
	spawnhealth = 1,
	speed = 2*FRACUNIT,
	damage = 62*FRACUNIT,
	reactiontime = 5,
	flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY|MF_BOXICON
}

states[S_HALFRING_BOX] = {SPR_TVHR, A, 2, nil, 0, 0, S_BOX_FLICKER}
states[S_HALFRING_ICON1] = {SPR_TVHR, FF_ANIMATE|C, 18, nil, 3, 4, S_HALFRING_ICON2}
states[S_HALFRING_ICON2] = {SPR_TVHR, C, 18, A_AllPlayersRingBox, 0, 0, S_NULL}

mobjinfo[MT_PITYALL_BOX] = {
	--$Name All Players Pity Monitor
	--$Sprite TVPAA0
	--$Category SUGOI Powerups
	doomednum = 3552,
	spawnstate = S_PITYALL_BOX,
	painstate = S_PITYALL_BOX,
	deathstate = S_BOX_POP1,
	deathsound = sfx_pop,
	radius = 18*FRACUNIT,
	height = 40*FRACUNIT,
	spawnhealth = 1,
	speed = 1,
	damage = MT_PITYALL_ICON,
	flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR
}

mobjinfo[MT_PITYALL_ICON] = {
	spawnstate = S_PITYALL_ICON1,
	seesound = sfx_shield,
	radius = 8*FRACUNIT,
	height = 14*FRACUNIT,
	spawnhealth = 1,
	speed = 2*FRACUNIT,
	damage = 62*FRACUNIT,
	reactiontime = 8,
	flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY|MF_BOXICON
}

states[S_PITYALL_BOX] = {SPR_TVPA, A, 2, nil, 0, 0, S_BOX_FLICKER}
states[S_PITYALL_ICON1] = {SPR_TVPA, FF_ANIMATE|C, 18, nil, 3, 4, S_PITYALL_ICON2}
states[S_PITYALL_ICON2] = {SPR_TVPA, C, 18, A_AllPlayersPityShield, 0, 0, S_NULL}
