-- LJ Sonic by LJ Sonic

-- Todo:
-- Node
-- Locals?


local phases
local boss
local mapcenterx, mapcentery
local questionsparsed

local function isCodeIndented(code)
	return code
end

local indentationquestions = {
-- Level 0
{
	level = 0,

	[[
		-- Okay.
		-- You look quite lost, so allow me to explain.

		-- Use your MOVEMENT KEYS to indent lines of code,
		-- then press JUMP when they are correctly indented.

		-- ...What, you don't know what that means?
		-- No big deal, just find a tutorial
		-- and learn Lua real quick LOLOLOLOLOLOL

		if isCodeIndented(code) then
			P_DamageMobj(boss) -- Indent just that line
		end
	]],

	function(code, player, boss)
		-- In an attempt to save some bytes, I have decided not to
		-- copypaste the long comment from above, as it would make
		-- no difference from a player's perspective.

		-- Hopefully this will make the levelpack a bit lighter, and thus
		-- easier to upload for Sal, and easier to download for players,
		-- and also maybe help a bit with the Master Board bandwidth usage!

		-- Ah wait... Oh well.

		if isCodeIndented(code) then
			P_DamageMobj(boss)
		end
	end
},
{
	level = 0,

	[[
		P_DamageMobj(boss) -- You Suck. jk
	]],

	function(code, player, boss)
		P_DamageMobj(boss) -- You Suck. jk
	end
},
{
	level = 0,

	[[
		-- You are so naive, did you SERIOUSLY think
		-- you could play a Sonic game without any
		-- programmig knowledge?!

		-- Know what? I feel bad for you, so I'll give you a hand.
		P_DamageMobj(boss) -- *sigh*
	]],

	function(code, player, boss)
		-- You are so naive, did you SERIOUSLY think
		-- you could play a Sonic game without any
		-- programmig knowledge?!

		-- Know what? I feel bad for you, so I'll give you a hand.
		P_DamageMobj(boss) -- *sigh*
	end
},
{
	level = 0,

	[[
		-- You are nice.
		COM_BufInsertText(player, "say I am nice")
		COM_BufInsertText(player, "say I am nice")
		COM_BufInsertText(player, "say I am nice")
		COM_BufInsertText(player, "say I am nice")
		COM_BufInsertText(player, "say I am nice")
		COM_BufInsertText(player, "say I am nice")
		COM_BufInsertText(player, "say I am nice")
		COM_BufInsertText(player, "say I am nice")
		COM_BufInsertText(player, "say I am nice")
		COM_BufInsertText(player, "say I am nice")
	]],

	function(code, player, boss)
		-- You suuuuuuuuuuuuuuuuuuuuuuuck.
		COM_BufInsertText(player, "say I am nice")
		COM_BufInsertText(player, "say I am nice")
		COM_BufInsertText(player, "say I am nice")
		COM_BufInsertText(player, "say I am nice")
		COM_BufInsertText(player, "say I am nice")
		COM_BufInsertText(player, "say I am nice")
		COM_BufInsertText(player, "say I am nice")
		COM_BufInsertText(player, "say I am nice")
		COM_BufInsertText(player, "say I am nice")
		COM_BufInsertText(player, "say I am nice")
	end
},
{
	level = 0,

	[[
		-- ...
		P_DamageMobj(boss)
		player.mo.destscale = FRACUNIT / 2 -- be a bee
		player.mo.momz = 64 * FRACUNIT -- bees suck
	]],

	function(code, player, boss)
		-- ...
		P_DamageMobj(boss)
		player.mo.destscale = FRACUNIT / 2 -- be a bee
		player.mo.momz = 64 * FRACUNIT -- bees suck
	end
},
{
	level = 0,

	[[
		-- Call me when your coolness reaches a positive value.
		-- For now I am bored, so I'll just damage myself.
		P_DamageMobj(boss) -- I bet ampersnad could even fail to indent that one
	]],

	function(code, player, boss)
		-- Call me when your coolness reaches a positive value.
		-- For now I am bored, so I'll just damage myself.
		P_DamageMobj(boss) -- I bet ampersnad could even fail to indent that one
	end
},

-- Level 1
{
	level = 1,

	[[
		if isCodeIndented(code) then
			P_GivePlayerRings(player, 3)
			P_DamageMobj(boss)
		end
	]],

	function(code, player, boss)
		if isCodeIndented(code) then
			P_GivePlayerRings(player, 3)
			P_DamageMobj(boss)
		end
	end
},
{
	level = 1,

	[[
		if isCodeIndented(code) then
			P_GivePlayerRings(player, 1)
			P_DamageMobj(boss)
		else
			P_GivePlayerRings(player, -1)
		end
	]],

	function(code, player, boss)
		if isCodeIndented(code) then
			P_GivePlayerRings(player, 1)
			P_DamageMobj(boss)
		else
			P_GivePlayerRings(player, -1)
		end
	end
},
{
	level = 1,
	rare = true,

	[[
		if not isCodeIndented(code) then
			for _ = 1, 99999999 do
				-- xd
			end
		end
	]],

	function(code, player, boss)
		if not isCodeIndented(code) then
			for _ = 1, 99999999 do
				-- xd
			end
		end
	end
},
{
	level = 1,
	rare = true,

	[[
		if isCodeIndented(code)
			P_DamageMobj(boss)
		else
			rawset(_G, "sugoi", nil) -- LOL
		end
	]],

	function(code, player, boss)
		if isCodeIndented(code)
			P_DamageMobj(boss)
		else
			-- LOL
		end
	end
},
{
	level = 1,
	rare = true,

	[[
		if isCodeIndented(code)
			P_DamageMobj(boss)
		else
			rawset(_G, "FRACUNIT", 66666) -- xd!!
		end
	]],

	function(code, player, boss)
		if isCodeIndented(code)
			P_DamageMobj(boss)
		else
			-- xd!!
		end
	end
},
{
	level = 1,
	rare = true,

	[[
		if isCodeIndented(code) then
			COM_BufInsertText(player, "quit") -- XD
		else
			COM_BufInsertText(player, "quit") -- lel
		end
	]],

	function(code, player, boss)
		-- I'm not that sadistic lol
	end
},
{
	level = 1,

	[[
		if not not not not isCodeIndented(code) then
			player.mo.momz = 32 * FRACUNIT
			P_DamageMobj(boss)
		else
			P_DamageMobj(player.mo)
		end
	]],

	function(code, player, boss)
		if not not not not isCodeIndented(code) then
			player.mo.momz = 32 * FRACUNIT
			P_DamageMobj(boss)
		else
			P_DamageMobj(player.mo)
		end
	end
},
{
	level = 1,

	[[
		if player.name:lower():find("tracker") then
			P_KillMobj(boss) -- oh god not that guy again
		elseif not isCodeIndented(code) then
			P_DamageMobj(player.mo)
		else
			P_DamageMobj(boss)
			local mo = player.mo
			P_SpawnMobj(mo.x, mo.y, mo.z, MT_RING)
		end
	]],

	function(code, player, boss)
		if player.name:lower():find("tracker") then
			P_KillMobj(boss) -- oh god not that guy again
		elseif not isCodeIndented(code) then
			P_DamageMobj(player.mo)
		else
			P_DamageMobj(boss)
			local mo = player.mo
			P_SpawnMobj(mo.x, mo.y, mo.z, MT_RING)
		end
	end
},

-- Level 2
{
	level = 2,

	[[
		local ljsonicsucksandmustdielol
		if 1 + 1 == 2 then
			ljsonicsucksandmustdielol = false
		else
			ljsonicsucksandmustdielol = true
		end

		if isCodeIndented(code) and ljsonicsucksandmustdielol then
			P_KillMobj(boss)
		end

		if isCodeIndented(code) then
			P_DamageMobj(boss)
		end
	]],

	function(code, player, boss)
		local ljsonicsucksandmustdielol
		if 1 + 1 == 2 then
			ljsonicsucksandmustdielol = false
		else
			ljsonicsucksandmustdielol = true
		end

		if isCodeIndented(code) and ljsonicsucksandmustdielol then
			P_KillMobj(boss)
		end

		if isCodeIndented(code) then
			P_DamageMobj(boss)
		end
	end
},
{
	level = 2,

	[[
		local x, y
		local attempts = 100
		repeat
			x = player.mo.x + P_RandomRange(-256, 256) * FRACUNIT
			y = player.mo.y + P_RandomRange(-256, 256) * FRACUNIT
			attempts = $ - 1
		until R_PointInSubsector(x, y).sector.special ~= 6 or attempts == 0

		local mt
		if isCodeIndented(code) then
			mt = MT_RING
			P_DamageMobj(boss)
		else
			mt = MT_BLUECRAWLA
		end
		P_SpawnMobj(x, y, player.mo.z, mt)
	]],

	function(code, player, boss)
		local x, y
		local attempts = 100
		repeat
			x = player.mo.x + P_RandomRange(-256, 256) * FRACUNIT
			y = player.mo.y + P_RandomRange(-256, 256) * FRACUNIT
			attempts = $ - 1
		until R_PointInSubsector(x, y).sector.special ~= 6 or attempts == 0

		local mt
		if isCodeIndented(code) then
			mt = MT_RING
			P_DamageMobj(boss)
		else
			mt = MT_BLUECRAWLA
		end
		P_SpawnMobj(x, y, player.mo.z, mt)
	end,
},
{
	level = 2,

	[[
		local rewards = {
			MT_RING,
			MT_RING_BOX,

			MT_JETTBOMBER,
			MT_EGGMAN_BOX,
		}

		local n
		if isCodeIndented(code) then
			n = P_RandomRange(1, #rewards / 2)
			P_DamageMobj(boss)
		else
			n = P_RandomRange(#rewards / 2 + 1, #rewards)
		end

		local mo = player.mo
		P_SpawnMobj(
			mo.x + 420 * sin(mo.angle),
			mo.y + 420 * cos(mo.angle),
			mo.z + 42 * FRACUNIT,
			rewards[n]
		)
	]],

	function(code, player, boss)
		local rewards = {
			MT_RING,
			MT_RING_BOX,

			MT_JETTBOMBER,
			MT_EGGMAN_BOX,
		}

		local n
		if isCodeIndented(code) then
			n = P_RandomRange(1, #rewards / 2)
			P_DamageMobj(boss)
		else
			n = P_RandomRange(#rewards / 2 + 1, #rewards)
		end

		local mo = player.mo
		P_SpawnMobj(
			mo.x + 420 * cos(mo.angle),
			mo.y + 420 * sin(mo.angle),
			mo.z + 42 * FRACUNIT,
			rewards[n]
		)
	end
},

{
	level = 2,

	[[
		for sector in sectors.iterate do
			if sector.floorpic == "XMSFLR02" then
				sector.floorpic = "PIT"
			elseif sector.floorpic == "PIT" then
				sector.floorpic = "XMSFLR02"
			end
		end

		local victim
		if isCodeIndented(code)
			victim = boss
		else
			victim = player.mo
		end
		P_DamageMobj(victim)
	]],

	function(code, player, boss)
		for sector in sectors.iterate do
			if sector.floorpic == "XMSFLR02" then
				sector.floorpic = "PIT"
			elseif sector.floorpic == "PIT" then
				sector.floorpic = "XMSFLR02"
			end
		end

		local victim
		if isCodeIndented(code)
			victim = boss
		else
			victim = player.mo
		end
		P_DamageMobj(victim)
	end
},

-- Level 3
{
	level = 3,

	[[
		local drops
		if isCodeIndented(code) then
			drops = {}
			for i = 1, 16 do
				drops[i] = _G[("MT_FLICKY_%.2d"):format(i)]
			end
			P_DamageMobj(boss)
		else
			drops = {
				MT_BLUECRAWLA, MT_REDCRAWLA,
				MT_GFZFISH,    MT_CANNONBALL,
			}
		end

		local centersector = R_PointInSubsector(mapcenterx, mapcentery).sector
		for _ = 1, 66 do
			local angle = P_RandomRange(-FRACUNIT / 2, FRACUNIT / 2 - 1)
			angle = $ * FRACUNIT
			local dist = P_RandomRange(0, 768)
			P_SpawnMobj(
				mapcenterx + dist * cos(angle),
				mapcentery + dist * sin(angle),
				centersector.ceilingheight - 256 * FRACUNIT,
				drops[P_RandomRange(1, #drops)]
			)
		end
	]],

	function(code, player, boss)
		local drops
		if isCodeIndented(code) then
			drops = {}
			for i = 1, 16 do
				drops[i] = _G[("MT_FLICKY_%.2d"):format(i)]
			end
			P_DamageMobj(boss)
		else
			drops = {
				MT_BLUECRAWLA, MT_REDCRAWLA,
				MT_GFZFISH,    MT_CANNONBALL,
			}
		end

		local centersector = R_PointInSubsector(mapcenterx, mapcentery).sector
		for _ = 1, 66 do
			local angle = P_RandomRange(-FRACUNIT / 2, FRACUNIT / 2 - 1)
			angle = $ * FRACUNIT
			local dist = P_RandomRange(0, 768)
			P_SpawnMobj(
				mapcenterx + dist * cos(angle),
				mapcentery + dist * sin(angle),
				centersector.ceilingheight - 256 * FRACUNIT,
				drops[P_RandomRange(1, #drops)]
			)
		end
	end
},

{
	level = 3,

	[[
		local P_KillMobj, hud, P_PlayerInPain

		local function addHook()
			P_KillMobj = P_GivePlayerRings
			hud = {add = P_DamageMobj}
			P_PlayerInPain = ({isCodeIndented})[FRACUNIT * 0 + 1]
		end

		addHook("ThinkFrame", do
			for mobj in mobjs.iterate() do
				for mobj in mobjs.iterate() do
					if mobj.valid
					and mobj.player
					and mobj.player.valid
					and mobj.player.mo
					and mobj.player.mo.valid
					and mobj.player.mo.player
					and mobj.player.mo.player.valid
					and mobj.player.mo.player.mo
					and mobj.player.mo.player.mo.valid then
						mobj.player.mo = mobj.player.mo
					end
				end
			end
		end)

		if P_PlayerInPain(code) then
			P_KillMobj(player.mo, 3)
			hud.add(boss)
		end
	]],

	function(code, player, boss)
		local P_KillMobj, hud, P_PlayerInPain

		local function addHook()
			P_KillMobj = P_GivePlayerRings
			hud = {add = P_DamageMobj}
			P_PlayerInPain = ({isCodeIndented})[FRACUNIT * 0 + 1]
		end

		addHook("ThinkFrame", do
			for mobj in mobjs.iterate() do
				for mobj in mobjs.iterate() do
					if mobj.valid
					and mobj.player
					and mobj.player.valid
					and mobj.player.mo
					and mobj.player.mo.valid
					and mobj.player.mo.player
					and mobj.player.mo.player.valid
					and mobj.player.mo.player.mo
					and mobj.player.mo.player.mo.valid then
						mobj.player.mo = mobj.player.mo
					end
				end
			end
		end)

		if P_PlayerInPain(code) then
			P_KillMobj(player, 3)
			hud.add(boss)
		end
	end
},

{
	level = 3,

	[[
		local function shouldBeCoolWithYou()
			return isCodeIndented(code)
		end

		if shouldBeCoolWithYou() then
			P_DamageMobj(boss)

			local skies = {
				6,    9,    21,   35,
				50,   51,   52,   53,
				54,   55,   56,   57,
				98,   99,   1024, 1025,
				1026, 1027, 1028,
			}
			P_SetupLevelSky(skies[P_RandomRange(1, #skies)])
		elseif P_RandomChance(FRACUNIT / 2) then
			player.mo.destscale = FRACUNIT / 2 -- tiny tiny
		else
			P_GivePlayerRings(player, -player.rings / 2)
		end
	]],

	function(code, player, boss)
		local function shouldBeCoolWithYou()
			return isCodeIndented(code)
		end

		if shouldBeCoolWithYou() then
			P_DamageMobj(boss)

			local skies = {
				6,    9,    21,   35,
				50,   51,   52,   53,
				54,   55,   56,   57,
				98,   99,   1024, 1025,
				1026, 1027, 1028,
			}
			P_SetupLevelSky(skies[P_RandomRange(1, #skies)])
		elseif P_RandomChance(FRACUNIT / 2) then
			player.mo.destscale = FRACUNIT / 2 -- tiny tiny
		else
			P_GivePlayerRings(player, -player.rings / 2)
		end
	end
},

{
	level = 3,

	[[
		local power
		if isCodeIndented(code) then
			local powers = {
				pw_invulnerability,
				pw_flashing,
				pw_sneakers,
			}
			power = powers[P_RandomRange(1, #powers)]
		else
			power = pw_nocontrol -- xdd
			P_DamageMobj(boss)
		end

		player.powers[power] = 10 * TICRATE
	]],

	function(code, player, boss)
		local power
		if isCodeIndented(code) then
			local powers = {
				pw_invulnerability,
				pw_flashing,
				pw_sneakers,
			}
			power = powers[P_RandomRange(1, #powers)]
		else
			power = pw_nocontrol -- xdd
			P_DamageMobj(boss)
		end

		player.powers[power] = 10 * TICRATE
	end
},

/*{
	level = ,

	[[
	]],

	function(code, player, boss)
	end
},*/
}

local FU = FRACUNIT

freeslot(
	"MT_LJSONIC", "S_LJSONIC",
	"MT_LJPARTICLE", "S_LJPARTICLE",
	"sfx_indent"
)

mobjinfo[MT_LJSONIC] = {
	spawnstate = S_LJSONIC,
	spawnhealth = 6,
	radius = 16*FRACUNIT,
	height = 48*FRACUNIT,
	flags = MF_BOSS|MF_NOGRAVITY
}

states[S_LJSONIC] = {SPR_PLAY, SPR2_STND, -1, nil, 0, 0, S_NULL}

mobjinfo[MT_LJPARTICLE] = {
	spawnstate = S_LJPARTICLE,
	spawnhealth = 1000,
	radius = 4*FRACUNIT,
	height = 4*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP
}

states[S_LJPARTICLE] = {SPR_PRTL, A|FF_FULLBRIGHT|FF_TRANS70, -1, nil, 0, 0, S_NULL}

local function pointToDist3D(x1, y1, z1, x2, y2, z2)
	return R_PointToDist2(0, z1, R_PointToDist2(x1, y1, x2, y2), z2)
end

local function pointToAngle3D(x1, y1, z1, x2, y2, z2)
	local angle = R_PointToAngle2(x1, y1, x2, y2)
	local vangle = R_PointToAngle2(0, z1, R_PointToDist2(x1, y1, x2, y2), z2)
	return angle, vangle
end

local function randomFixed(a, b)
	return P_RandomRange(a / 256, b / 256) * 256
end

local function randomPointInSphere(x, y, z, radius)
	radius = $ / FU
	local rx, ry, rz
	repeat
		rx = P_RandomRange(-radius, radius) * FU
		ry = P_RandomRange(-radius, radius) * FU
		rz = P_RandomRange(-radius, radius) * FU
	until pointToDist3D(0, 0, 0, rx, ry, rz) <= radius * FU
	return x + rx, y + ry, z + rz
end

local function randomDirection(speed)
	local x, y, z = randomPointInSphere(0, 0, 0, 256 * FU)
	local dist = pointToDist3D(0, 0, 0, x, y, z)
	local multiplier = FixedDiv(speed, dist)
	local momx = FixedMul(x, multiplier)
	local momy = FixedMul(y, multiplier)
	local momz = FixedMul(z, multiplier)
	return momx, momy, momz
end

local function thrustTowards(mo, x, y, z, speed)
	local angle, vangle = pointToAngle3D(mo.x, mo.y, mo.z, x, y, z)
	mo.momx = $ + FixedMul(FixedMul(speed, cos(angle)), cos(vangle))
	mo.momy = $ + FixedMul(FixedMul(speed, sin(angle)), cos(vangle))
	mo.momz = $ + FixedMul(speed, sin(vangle))
end

local function instaThrustTowards(mo, x, y, z, speed)
	mo.momx, mo.momy, mo.momz = 0, 0, 0
	thrustTowards(mo, x, y, z, speed)
end

local function randomElement(t)
	return t[P_RandomRange(1, #t)]
end

local function getFrame(mo)
	return mo.frame & ~(FF_TRANSMASK | FF_FULLBRIGHT)
end

local function setFrame(mo, frame)
	mo.frame = frame | (mo.frame & (FF_TRANSMASK | FF_FULLBRIGHT))
end

local function getTarget(mo)
	local t = mo.target
	if t and t.valid
		local p = t.player
		if p and p.valid
			return p
		end
	end
end

local function findTarget(mo)
	local targets = {}
	for p in players.iterate
		if not (p.mo and p.mo.valid)
		or not p.mo.health
		or p.spectator
		or p.pflags & PF_INVIS
		or p.bot
			continue
		end

		if p.name:lower():find("amper")
			mo.target = p.mo
			return
		end

		table.insert(targets, p.mo)
	end

	if #targets
		mo.target = randomElement(targets)
	end
end

local function parseQuestions()
	for _, question in ipairs(indentationquestions)
		-- Remove trailing tabs
		local linestart = question[1]:find("[^\t]")
		if linestart ~= nil
			local code = ""
			for line in question[1]:gmatch("(.-)\n")
				code = $..(line:sub(linestart)).."\n"
			end
			question[1] = code
		end

		-- Colourise keywords
		for _, keyword in ipairs({
			"if ",
			" then",
			"else",
			"elseif",
			"end",
			"while ",
			" do",
			"do ",
			"repeat",
			"until ",
			"for ",
			"function",
			"local ",
			"and ",
			" or ",
			"\tor ",
			"not ",
		})
			question[1] = $:gsub(keyword, "\x84"..keyword.."\x80")
		end

		-- Colourise functions
		question[1] = $:gsub("([%w_]-)%(", function(name)
			return "\x87"..name.."\x80("
		end)

		-- Colourise comments
		question[1] = $:gsub("(%-%-.-)\n", function(comment)
			comment = $:gsub("[\x80\x81\x82\x83\x84\x85\x86\x87]", "")
			return "\x83"..comment.."\x80\n"
		end)

		-- Duplicate spaces
		question[1] = $:gsub(" ", "  ")
	end

	questionsparsed = true
end

local function startPhase(mo)
	local init = phases[mo.phase.id].init
	if init
		init(mo, mo.phase)
	end
end

local function stopPhase(mo)
	local stop = phases[mo.phase.id].stop
	if stop
		stop(mo, mo.phase)
	end
end

local function nextPhase(mo, id)
	stopPhase(mo)

	if id
		mo.phase = nil
		for otherid, phase in ipairs(phases)
			if phase.id == id
				mo.phase = {id = otherid}
				break
			end
		end
		assert(mo.phase, 'phase "'..id..'" not found')
	else
		mo.phase = {id = mo.phase.id + 1}
	end

	startPhase(mo)
end

local function spawnParticle(x, y, z)
	local particle = P_SpawnMobj(x, y, z, MT_LJPARTICLE)
	local trans = P_RandomRange(5, 9)
	particle.frame = $ & ~FF_TRANSMASK | (trans << FF_TRANSSHIFT)
	return particle
end

local function spawnVerticalParticleHalfCircle(mo, n, speed)
	for _ = 1, n
		local particle = spawnParticle(mo.x, mo.y, mo.z)

		particle.tics = P_RandomRange(TICRATE / 2, TICRATE)
		particle.scale = randomFixed(mo.scale / 2, mo.scale)

		local vangle = P_RandomRange(0, FU / 2 - 1) * FU
		particle.momx = FixedMul(speed, FixedMul(cos(vangle), cos(mo.angle + ANGLE_90)))
		particle.momy = FixedMul(speed, FixedMul(cos(vangle), sin(mo.angle + ANGLE_90)))
		particle.momz = FixedMul(speed, sin(vangle))
	end
end

local function handleDecorationParticles(mo)
	for _ = 1, 4
		local x = mapcenterx + P_RandomRange(-3072 + 64, 3072 - 64) * FU
		local y = mapcentery + P_RandomRange(-3072 + 64, 3072 - 64) * FU
		local s = R_PointInSubsector(x, y).sector
		if s.floorpic ~= "F_SKY1" continue end

		local direction = mo.decorationparticlesdirection
		if direction == 3
			direction = P_RandomRange(1, 2)
		end

		local z
		if direction == 1
			z = s.floorheight
		else
			z = s.ceilingheight
		end

		local momz = randomFixed(16 * FU, 32 * FU)
		if direction == 2
			momz = -$
		end

		local particle = spawnParticle(x, y, z)
		particle.momz = momz
		particle.tics = P_RandomRange(TICRATE, 5 * TICRATE)
		particle.scale = randomFixed(FU, 4 * FU)
	end
end

local function handleParticles(mo, particles)
	-- Spawn particles
	if #particles < 128
		local particle = spawnParticle(mo.x, mo.y, mo.z)
		table.insert(particles, particle)

		particle.tics = -1
		particle.scale = randomFixed(mo.scale / 2, mo.scale)

		particle.momx, particle.momy, particle.momz = randomPointInSphere(mo.momx, mo.momy, mo.momz, 16 * mo.scale)
	end

	-- Attract and remove particles
	for i = #particles, 1, -1
		local particle = particles[i]
		if not particle.valid
			table.remove(particles, i)
			continue
		end

		-- Attract particle
		thrustTowards(particle, mo.x, mo.y, mo.z + mo.height / 2, mo.scale)

		-- Remove particle when it touches LJ Sonic
		local speed = pointToDist3D(0, 0, 0, particle.momx, particle.momy, particle.momz)
		local dist = pointToDist3D(particle.x, particle.y, particle.z, mo.x, mo.y, mo.z + mo.height / 2)
		if dist <= speed
			P_RemoveMobj(particle)
			table.remove(particles, i)
		end
	end
end

local function startQuestion(phase, mo)
	-- Lock the player
	local p = getTarget(mo)
	phase.lockedplayer = p
	phase.pflags = p.pflags & PF_FORCESTRAFE
	p.pflags = $ | PF_FORCESTRAFE
	if p.pflags & PF_ANALOGMODE
		phase.pflags = $ | PF_ANALOGMODE
		p.pflags = $ & ~PF_ANALOGMODE
	end
	phase.thrustfactor = p.thrustfactor
	p.thrustfactor = 0

	-- Lock the enemies
	for mo in mobjs.iterate()
		if mo.flags & MF_ENEMY
			mo.flags = $ | MF_NOTHINK
		end
	end

	phase.playerparticles = {}
end

local function stopQuestion(phase)
	-- Unlock the player
	local p = phase.lockedplayer
	if p and p.valid
		p.thrustfactor = phase.thrustfactor
		if not (phase.pflags & PF_FORCESTRAFE)
			p.pflags = $ & ~PF_FORCESTRAFE
		end
		if phase.pflags & PF_ANALOGMODE
			p.pflags = $ | PF_ANALOGMODE
		end
	end

	-- Unlock the enemies
	for mo in mobjs.iterate()
		if mo.flags & MF_ENEMY
			mo.flags = $ & ~MF_NOTHINK
		end
	end

	for _, particle in ipairs(phase.playerparticles or {})
		if not particle.valid
			table.remove(phase.playerparticles, i)
			continue
		end

		particle.momx, particle.momy, particle.momz = randomDirection(P_RandomRange(48, 64) * FU)
		particle.tics = 3 * TICRATE
	end
end

local function waitingPhase(duration, init, action)
	return {
		init = function(mo, phase)
			if init
				init(mo, phase)
			end

			phase.wait = duration
		end,
		action = function(mo, phase)
			if action
				action(mo, phase)
			end

			phase.wait = $ - 1
			if not phase.wait
				nextPhase(mo)
			end
		end
	}
end

local function exitLevel()
	if sugoi
		sugoi.ExitLevel()
	else
		G_ExitLevel()
	end
end

phases = {
-- Apparition
{
	init = function(mo, phase)
		boss = mo

		mo.skin = "sonic"
		mo.color = SKINCOLOR_WHITE
		mo.indentationlevel = FU * 3 / 2

		mo.momz = -2 * FU
		for s in sectors.iterate
			s.lightlevel = 128
		end

		phase.particles = {}

		-- Find and face target
		findTarget(mo)
		if mo.target and mo.target.valid
			mo.angle = R_PointToAngle2(mo.x, mo.y, mo.target.x, mo.target.y)
		end

		-- !!!! dbg
		local dbg = 0
		if dbg == 1
			mo.frame = $ | FF_FULLBRIGHT
			P_SetOrigin(mo, mapcenterx, mapcentery, 0)

			mo.phase = {id = 2}
			startPhase(mo)
		elseif dbg == 2
			mo.particles = {}
			mo.frame = $ | FF_FULLBRIGHT
			P_SetOrigin(mo, mapcenterx, mapcentery, 0)

			mo.phase = {id = 6}
			startPhase(mo)
		elseif dbg == 3 -- Give mushroom
			mo.particles = {}
			mo.frame = $ | FF_FULLBRIGHT
			P_SetOrigin(mo, mapcenterx, mapcentery, 0)

			mo.health = 1
			nextPhase(mo, "give mushroom")
		end
	end,
	action = function(mo, phase)
		-- Descend
		mo.momz = min($ + FU / 256, -FU / 8)
		if not #phase.particles
			if mo.frame & FF_FULLBRIGHT and not phase.flashed
				phase.flashed = true
				for p in players.iterate
					P_FlashPal(p, PAL_WHITE, TICRATE / 2)
				end
				S_StartSound(nil, sfx_s3ka8)
			end

			if P_IsObjectOnGround(mo)
				for _ = 1, 128
					local particle = spawnParticle(mo.x, mo.y, mo.z)

					particle.tics = P_RandomRange(TICRATE, 4 * TICRATE)
					particle.scale = randomFixed(FU / 4, FU / 2)

					local angle = P_RandomRange(-FU / 2, FU / 2 - 1) * FU
					local speed = randomFixed(FU / 2, 2 * FU)
					particle.momx = FixedMul(speed, cos(angle))
					particle.momy = FixedMul(speed, sin(angle))
					particle.momz = FU / 8
				end

				nextPhase(mo)
			end
		end

		-- Spawn particles
		if not (mo.frame & FF_FULLBRIGHT)
			for _ = 1, 4
				local x, y, z = randomPointInSphere(mo.x, mo.y, mo.z, 1024 * FU)
				local particle = spawnParticle(x, y, z)
				table.insert(phase.particles, particle)

				particle.tics = -1
				particle.scale = randomFixed(FU / 4, 2 * FU)
				instaThrustTowards(particle, mo.x, mo.y, mo.z + mo.height / 2, randomFixed(0, 8 * FU))
			end
		end

		-- Attract and remove particles
		for i = #phase.particles, 1, -1
			local particle = phase.particles[i]
			if not particle.valid
				table.remove(phase.particles, i)
				continue
			end

			local speed = pointToDist3D(0, 0, 0, particle.momx, particle.momy, particle.momz)
			local dist = pointToDist3D(particle.x, particle.y, particle.z, mo.x, mo.y, mo.z + mo.height / 2)

			-- Attract particle
			speed = $ + FU / 8
			instaThrustTowards(particle, mo.x, mo.y, mo.z + mo.height / 2, speed)

			-- Remove particle when it touches LJ Sonic
			if dist <= speed
				P_RemoveMobj(particle)
				table.remove(phase.particles, i)
			end
		end

		local duration = 10 * TICRATE

		-- Light
		if mapcenterx == 0 and mapcentery == 0
			local s = mo.subsector.sector
			s.lightlevel = min(128 + (255 - 128) * leveltime / duration, 255)
			s = R_PointInSubsector(mo.x + 192 * FU, mo.y).sector
			s.lightlevel = min(128 + (160 - 128) * leveltime / duration, 160)
		end

		-- Transparency
		local trans = max(9 - 9 * leveltime / duration, 0)
		mo.frame = $ & ~FF_TRANSMASK | (trans << FF_TRANSSHIFT)
		if trans == 0
			mo.frame = $ | FF_FULLBRIGHT
		end
	end
},

-- Waiting
waitingPhase(TICRATE),

-- Walking towards the player
{
	id = "walk",
	init = function(mo, phase)
		mo.sprite2 = SPR2_WALK
		setFrame(mo, A)
		phase.steps = 6
		if not mo.particles
			mo.particles = {}
		end
	end,
	action = function(mo, phase)
		handleParticles(mo, mo.particles)

		if not (mo.target and mo.target.valid)
			nextPhase(mo)
			return
		end

		if phase.wait
			phase.wait = $ - 1
			if not phase.wait
				mo.sprite2 = SPR2_WALK
				setFrame(mo, phase.stepframe)
			end
		else
			mo.angle = R_PointToAngle2(mo.x, mo.y, mo.target.x, mo.target.y)
			P_InstaThrust(mo, mo.angle, 8 * mo.scale)

			-- Don't fall from the platform
			if mo.z ~= P_FloorzAtPos(mo.x + mo.momx, mo.y + mo.momy, mo.z, mo.height)
				mo.sprite2 = SPR2_STND
				setFrame(mo, A)
				P_InstaThrust(mo, mo.angle, 0)
				nextPhase(mo)
			end

			if not (leveltime % 8)
				if getFrame(mo) == D or getFrame(mo) == H
					phase.stepframe = getFrame(mo) == D and E or A

					-- Stop
					mo.sprite2 = SPR2_STND
					setFrame(mo, A)
					P_InstaThrust(mo, mo.angle, 0)

					P_StartQuake(2 * mo.scale, TICRATE / 2)

					S_StartSound(mo, sfx_brakrx)

					-- Spawn particles
					for _ = 1, 64
						local particle = spawnParticle(mo.x, mo.y, mo.z)

						particle.tics = P_RandomRange(TICRATE / 4, TICRATE)
						particle.scale = randomFixed(mo.scale / 4, mo.scale / 2)

						local angle = P_RandomRange(-FU / 2, FU / 2 - 1) * FU
						local speed = randomFixed(mo.scale, 2 * mo.scale)
						particle.momx = FixedMul(speed, cos(angle))
						particle.momy = FixedMul(speed, sin(angle))
						particle.momz = mo.scale / 8
					end

					phase.wait = TICRATE / 4

					phase.steps = $ - 1
					if not phase.steps
					or R_PointToDist2(mo.x, mo.y, mo.target.x, mo.target.y) < 384 * mo.scale
						nextPhase(mo)
					end
				else
					setFrame(mo, getFrame(mo) + 1)
				end
			end
		end
	end
},

-- Waiting
waitingPhase(TICRATE,
	nil,
	function(mo, phase)
		handleParticles(mo, mo.particles)
	end
),

-- Waiting for target to land on the floor
{
	id = "question",
	action = function(mo, phase)
		local done = false
		local t = getTarget(mo)
		if not (t and t.valid)
			done = true
		elseif P_IsObjectOnGround(t.mo) or t.climbing
			t.mo.momx, t.mo.momy = 0, 0
			done = true
		end

		if done
			if mo.health == 1
				nextPhase(mo, "node")
			else
				nextPhase(mo)
			end
		end
	end
},

-- Indenting
{
	init = function(mo, phase)
		if not questionsparsed
			parseQuestions()
		end

		if not getTarget(mo)
			nextPhase(mo)
			return
		end

		-- Pick a question
		if mo.indentationlevel / FU == 0 and not mo.tutorialshown
			phase.question = 1
			mo.tutorialshown = true
		else
			repeat
				phase.question = P_RandomRange(1, #indentationquestions)
				local question = indentationquestions[phase.question]
			until question.level == mo.indentationlevel / FU and (not question.rare or P_RandomChance(FU / 4))
		end
		-- !!!! dbg
		--phase.question = #indentationquestions
		--phase.question = 1

		startQuestion(phase, mo)

		phase.line = 1

		phase.indentation = {}
		for _ in indentationquestions[phase.question][1]:gmatch("(.-)\n")
			table.insert(phase.indentation, 0)
		end

		S_StartSound(mo, sfx_indent)

		phase.time = 0
	end,
	stop = function(mo, phase)
		stopQuestion(phase)
	end,
	action = function(mo, phase)
		if not questionsparsed
			parseQuestions()
		end

		local p = getTarget(mo)
		if not p
			nextPhase(mo)
			return
		end

		handleParticles(mo, mo.particles)
		handleParticles(p.mo, phase.playerparticles)

		if p.cmd.forwardmove and not phase.confirmed
			local move
			if phase.vkeyrepeat == nil
				move = true
				phase.vkeyrepeat = TICRATE / 5
			elseif phase.vkeyrepeat == 0
				move = true
				phase.vkeyrepeat = TICRATE / 35
			else
				phase.vkeyrepeat = $ - 1
			end

			if move
				if p.cmd.forwardmove > 0 -- Up
					phase.line = max($ - 1, 1)
				elseif p.cmd.forwardmove < 0 -- Down
					local numlines = 0
					local code = indentationquestions[phase.question][1]
					for _ in code:gmatch(".-\n")
						numlines = $ + 1
					end

					phase.line = min($ + 1, numlines)
				end
			end
		else
			phase.vkeyrepeat = nil
		end

		if p.cmd.sidemove and not phase.confirmed
			local move
			if phase.hkeyrepeat == nil
				move = true
				phase.hkeyrepeat = TICRATE / 5
			elseif phase.hkeyrepeat == 0
				move = true
				phase.hkeyrepeat = TICRATE / 35
			else
				phase.hkeyrepeat = $ - 1
			end

			if move
				if p.cmd.sidemove < 0 -- Left
					phase.indentation[phase.line] = max($ - 1, 0)
				elseif p.cmd.sidemove > 0 -- Right
					phase.indentation[phase.line] = min($ + 1, 4)
				end
			end
		else
			phase.hkeyrepeat = nil
		end

		if p.cmd.buttons & BT_JUMP and phase.time >= TICRATE and not phase.confirmed
			phase.confirmed = true

			-- Check indentation
			phase.indented = true
			local n = 1
			local code = indentationquestions[phase.question][1]
			for line in code:gmatch(".-\n")
				if line ~= "\n"
				and line:find("[^\t]") ~= phase.indentation[n] + 1
					phase.indented = false
				end
				n = $ + 1
			end

			phase.time = 0
			phase.highlighted = true
			phase.numhighlights = 0
		end

		-- Make the lines incorrectly indented blink
		if phase.confirmed and phase.time >= TICRATE / 8
			phase.highlighted = not $
			if not phase.highlighted
				phase.numhighlights = $ + 1
			end
			phase.time = 0
		end

		if phase.confirmed and (phase.indented or phase.numhighlights == 4)
			if phase.indented
				mo.indentationlevel = min($ + FU / 2, 3 * FU)
			else
				mo.indentationlevel = max($ - FU / 2, 0)
			end

			indentationquestions[phase.question][2](phase.indented, p, mo)

			if phase == mo.phase -- The phase wasn't changed by the code snippet
				nextPhase(mo)
			end
		end

		phase.time = $ + 1
	end
},

-- Spilling particles
{
	id = "spill particles",
	init = function(mo, phase)
		phase.time = 0

		for _, particle in ipairs(mo.particles)
			if not particle.valid
				table.remove(mo.particles, i)
				continue
			end

			particle.momx, particle.momy, particle.momz = randomDirection(P_RandomRange(48, 64) * FU)
			particle.tics = 3 * TICRATE
		end
		mo.particles = nil

		mo.frame = $ & ~FF_FULLBRIGHT
		for p in players.iterate
			P_FlashPal(p, PAL_WHITE, TICRATE / 4)
		end
		S_StartSound(nil, sfx_s3ka8)

		phase.sectorlight = {}
		for s in sectors.iterate
			phase.sectorlight[s.tag] = s.lightlevel
		end

		mo.decorationparticlesdirection = P_RandomRange(1, 3)

		-- Grow if it's the pinch phase
		if mo.health <= 2 and mo.scale < 4 * FU
			mo.destscale, mo.scalespeed = 4 * FU, FU / 12
			S_StartSound(nil, sfx_mario3)
		end
	end,
	action = function(mo, phase)
		if mo.frame & FF_TRANSMASK ~= FF_TRANS70
			for _ = 1, 8
				local particle = spawnParticle(mo.x, mo.y, mo.z + mo.height / 2)

				particle.tics = 2 * TICRATE
				particle.scale = randomFixed(FU / 4, FU)
				particle.momx, particle.momy, particle.momz = randomDirection(P_RandomRange(48, 64) * FU)
			end
		end

		-- Light
		local duration = 2 * TICRATE
		for s in sectors.iterate
			local dstlight
			if s.tag == 1
				dstlight = 192
			elseif s.tag == 2
				dstlight = 255
			else
				dstlight = 160
			end

			local srclight = phase.sectorlight[s.tag]
			s.lightlevel = min(srclight + (dstlight - srclight) * phase.time / duration, dstlight)
		end

		-- Transparency
		local trans = min(7 * phase.time / duration, 7)
		mo.frame = $ & ~FF_TRANSMASK | (trans << FF_TRANSSHIFT)

		phase.time = $ + 1
		if phase.time >= duration
			nextPhase(mo)
		end
	end
},

-- Choose next attack
{
	init = function(mo)
		nextPhase(mo, randomElement({
			"teleport and shoot",
			"spindash",
			"wind",
			"jump",
		}))
	end

	/*init = function(mo)
		mo.momz = 16 * FU
	end,
	action = function(mo, phase)
		handleDecorationParticles()

		mo.momz = max($ - FU / 2, 0)
		if not mo.momz
		end
	end*/
},

-- Teleport and shoot
{
	id = "teleport and shoot",
	init = function(mo, phase)
		phase.time = 0

		if mo.shoots == nil
			mo.shoots = 10
		end

		findTarget(mo)

		local t = mo.target
		if t and not t.valid
			t = nil
		end

		-- Pick random teleport destination
		local angle = P_RandomRange(-FU / 2, FU / 2 - 1) * FU
		local dist = P_RandomRange(0, 768) * FU
		local dstx = mapcenterx + FixedMul(dist, cos(angle))
		local dsty = mapcentery + FixedMul(dist, sin(angle))
		local dstz = P_RandomRange(128, 512) * FU

		-- Spawn teleport particles
		for _ = 1, 32
			local x, y, z = randomPointInSphere(mo.x, mo.y, mo.z, 32 * FU)
			local particle = spawnParticle(x, y, z)
			particle.tics = P_RandomRange(1, 2 * TICRATE)
			particle.scale = randomFixed(FU / 4, FU)
			instaThrustTowards(particle, dstx, dsty, dstz, randomFixed(16 * FU, 32 * FU))
		end

		-- Teleport
		local angle = P_RandomRange(-FU / 2, FU / 2 - 1) * FU
		P_SetOrigin(mo, dstx, dsty, dstz)
		if t
			mo.angle = R_PointToAngle2(mo.x, mo.y, t.x, t.y)
		end

		-- Shoot
		if t
			local ball = spawnParticle(mo.x, mo.y, mo.z)
			ball.tics = 2 * TICRATE
			ball.flags = ($ & ~MF_NOBLOCKMAP) | MF_PAIN
			ball.scale = 8 * FU
			ball.frame = $ & ~FF_TRANSMASK | FF_TRANS30 | FF_FULLBRIGHT
			instaThrustTowards(ball, t.x, t.y, t.z + t.height / 2, 32 * FU)
			S_StartSound(ball, sfx_s3k54)
		end

		mo.shoots = $ - 1
		if not mo.shoots
			mo.shoots = nil
			nextPhase(mo)
		end
	end,
	action = function(mo, phase)
		handleDecorationParticles(mo)

		phase.time = $ + 1
		if phase.time == TICRATE * 3 / 4
			nextPhase(mo, "teleport and shoot")
		end
	end
},

-- Wait
{
	init = function(mo, phase)
		phase.wait = 2 * TICRATE
	end,
	action = function(mo, phase)
		handleDecorationParticles(mo)

		phase.wait = $ - 1
		if not phase.wait
			nextPhase(mo, "gather particles")
		end
	end
},

-- Charging spindash
{
	id = "spindash",
	init = function(mo, phase)
		mo.sprite2 = SPR2_SPIN
		setFrame(mo, A)
		mo.flags = $ & ~MF_NOGRAVITY
		phase.wait = 2 * TICRATE
	end,
	action = function(mo, phase)
		handleDecorationParticles(mo)

		-- Spinning animation
		local frame = getFrame(mo)
		frame = $ + 1
		if frame > D
			frame = A
		end
		setFrame(mo, frame)

		if leveltime & 4
			S_StartSound(mo, sfx_spndsh)
		end

		-- Spawn spindash particles
		for _ = 1, 2
			local particle = spawnParticle(mo.x, mo.y, mo.z)

			particle.tics = P_RandomRange(TICRATE / 4, 2 * TICRATE)
			particle.scale = randomFixed(mo.scale / 4, mo.scale)

			local angle = mo.angle + ANGLE_180 + P_RandomRange(-ANGLE_45 / FU, ANGLE_45 / FU) * FU
			local speed = randomFixed(mo.scale / 2, 2 * mo.scale)
			particle.momx = FixedMul(speed, cos(angle))
			particle.momy = FixedMul(speed, sin(angle))
			particle.momz = mo.scale / 2
		end

		-- Face target
		if mo.target and mo.target.valid
			mo.angle = R_PointToAngle2(mo.x, mo.y, mo.target.x, mo.target.y)
		else
			findTarget(mo)
		end

		-- Release when ready
		phase.wait = $ - 1
		if not phase.wait
			nextPhase(mo)
		end
	end
},

-- Spindash release
{
	init = function(mo, phase)
		phase.speed = 64 * FU
		mo.flags = $ | MF_PAIN
		mo.sprite2 = SPR2_ROLL
		setFrame(mo, A)
		S_StartSound(mo, sfx_zoom)
		spawnVerticalParticleHalfCircle(mo, 64, 4 * mo.scale)
	end,
	stop = function(mo)
		mo.flags = $ & ~MF_PAIN
		mo.flags = $ | MF_NOGRAVITY
		mo.momx, mo.momy, mo.momz = 0, 0, 0
		mo.sprite2 = SPR2_STND
		setFrame(mo, A)
	end,
	action = function(mo, phase)
		handleDecorationParticles(mo)

		-- Spinning animation
		local frame = getFrame(mo)
		frame = $ + 1
		if frame > F
			frame = A
		end
		setFrame(mo, frame)

		if not (leveltime % (TICRATE / 8))
			spawnVerticalParticleHalfCircle(mo, 32, 2 * mo.scale)
		end

		P_InstaThrust(mo, mo.angle, phase.speed)

		-- Don't fall from the platform
		if mo.z ~= P_FloorzAtPos(mo.x + mo.momx, mo.y + mo.momy, mo.z, mo.height)
			nextPhase(mo)
		end

		-- Slow down until stopped
		phase.speed = max($ - FU, 0)
		if not phase.speed
			nextPhase(mo)
		end
	end
},

-- Wait
{
	init = function(mo, phase)
		phase.wait = TICRATE
	end,
	action = function(mo, phase)
		handleDecorationParticles(mo)

		phase.wait = $ - 1
		if not phase.wait
			nextPhase(mo, "gather particles")
		end
	end
},

-- Wind around LJ Sonic
{
	id = "wind",
	init = function(mo, phase)
		mo.flags = $ & ~MF_NOGRAVITY
		phase.speed = 0
		-- DSS3KC9S DSS3KA0-DSS3KA8 DSS3K81-DSS3K83
		-- DSS3KB6 DSS3K83
		S_StartSound(mo, sfx_s3ka4)
	end,
	stop = function(mo, phase)
		mo.flags = $ | MF_NOGRAVITY
	end,
	action = function(mo, phase)
		handleDecorationParticles(mo)

		-- Push players around LJ Sonic
		for p in players.iterate
			if not p.mo continue end

			P_Thrust(
				p.mo,
				R_PointToAngle2(mo.x, mo.z, p.mo.x, p.mo.y) + ANGLE_90,
				phase.speed
			)

			if p.mo.state == S_PLAY_STND
			or p.mo.state == S_PLAY_WAIT
			or p.mo.state == S_PLAY_EDGE
				p.mo.state = S_PLAY_RUN
			end
		end

		-- Animation
		mo.angle = $ + 8192 * phase.speed

		-- Spawn particles
		for _ = 1, 4
			local angle = P_RandomRange(-FU / 2, FU / 2 - 1) * FU
			local dist = FixedMul(256 * phase.speed, randomFixed(FU / 8, FU))
			local particle = spawnParticle(
				mo.x + FixedMul(dist, cos(angle)),
				mo.y + FixedMul(dist, sin(angle)),
				mo.z + phase.speed * P_RandomRange(0, 128)
			)

			particle.tics = P_RandomRange(TICRATE, 3 * TICRATE)
			particle.scale = randomFixed(FU / 2, 2 * FU)

			local angle = R_PointToAngle2(mo.x, mo.y, particle.x, particle.y) + ANGLE_90
			particle.momx = FixedMul(8 * phase.speed, cos(angle))
			particle.momy = FixedMul(8 * phase.speed, sin(angle))
		end

		if not phase.stopping
			-- Speed up wind
			phase.speed = min($ + FU / 64, 3 * FU)
			if phase.speed == 3 * FU
				phase.stopping = true
			end
		else
			-- Slow down wind
			phase.speed = max($ - FU / 32, 0)
			if not phase.speed
				nextPhase(mo, "gather particles")
			end
		end
	end
},

-- Jumping on players
{
	id = "jump",
	init = function(mo, phase)
		findTarget(mo)

		mo.flags = $ & ~MF_NOGRAVITY
		mo.flags = $ | MF_PAIN
		phase.jumps = 5
		phase.ball = P_RandomChance(FU / 2)

		if phase.ball
			mo.sprite2 = SPR2_ROLL
			setFrame(mo, A)
		end
	end,
	stop = function(mo, phase)
		mo.flags = $ | MF_NOGRAVITY
		mo.flags = $ & ~MF_PAIN
		mo.momx, mo.momy = 0, 0

		mo.sprite2 = SPR2_STND
		setFrame(mo, A)
	end,
	action = function(mo, phase)
		local t = mo.target
		if not (t and t.valid)
			nextPhase(mo, "gather particles")
			return
		end

		handleDecorationParticles(mo)

		-- Jump
		if P_IsObjectOnGround(mo) and mo.momz <= 0
			if phase.jumps == 5
				S_StartSound(mo, sfx_jump)
			elseif phase.jumps == 0
				nextPhase(mo, "gather particles")
				return
			else
				S_StartSound(mo, sfx_thwomp)
				P_StartQuake(4 * FU, TICRATE / 2)

				for _ = 1, 128
					local particle = spawnParticle(mo.x, mo.y, mo.z)

					particle.tics = P_RandomRange(TICRATE / 2, TICRATE)
					particle.scale = randomFixed(FU, 2 * FU)
					particle.flags = ($ & ~MF_NOBLOCKMAP) | MF_PAIN
					particle.frame = $ & ~FF_TRANSMASK | FF_TRANS30 | FF_FULLBRIGHT

					local angle = P_RandomRange(-FU / 2, FU / 2 - 1) * FU
					local speed = randomFixed(4 * FU, 16 * FU)
					particle.momx = FixedMul(speed, cos(angle))
					particle.momy = FixedMul(speed, sin(angle))
				end
			end

			local dir = R_PointToAngle2(mo.x, mo.y, t.x, t.y)
			P_InstaThrust(mo, dir, 24 * FU)

			mo.momz = 12 * mo.scale
			phase.falling = nil

			phase.jumps = $ - 1
		end

		-- Fall straight onto the target
		if mo.z - mo.floorz > 256 * FU and R_PointToDist2(mo.x, mo.y, t.x, t.y) < 128 * FU
		or mo.subsector.sector.floorheight ~= P_FloorzAtPos(mo.x + mo.momx, mo.y + mo.momy, mo.z, mo.height)
			mo.momx, mo.momy = 0, 0
			mo.momz = -16 * FU
			phase.falling = true
		end

		if phase.ball
			local frame = getFrame(mo)
			frame = $ + 1
			if frame > F
				frame = A
			end
			setFrame(mo, frame)
		else
			if not phase.falling
				local dir = R_PointToAngle2(mo.x, mo.y, t.x, t.y)
				P_InstaThrust(mo, dir, 24 * FU)
			end

			mo.angle = $ + 8192 * 3 * FU
		end
	end
},

-- Gathering particles
{
	id = "gather particles",
	init = function(mo, phase)
		phase.particles = {}
		for mo in mobjs.iterate()
			if mo.type == MT_LJPARTICLE
				table.insert(phase.particles, mo)
				mo.tics = -1
			end
		end
		phase.numparticles = #phase.particles
		mo.decorationparticlesdirection = nil
		phase.attractionspeed = randomFixed(FU / 4, 2 * FU)

		phase.sectorlight = {}
		for s in sectors.iterate
			phase.sectorlight[s.tag] = s.lightlevel
		end
	end,
	stop = function(mo, phase)
		mo.frame = $ | FF_FULLBRIGHT
		for p in players.iterate
			P_FlashPal(p, PAL_WHITE, TICRATE / 2)
		end
		S_StartSound(nil, sfx_s3ka8)
		mo.particles = {}
	end,
	action = function(mo, phase)
		local x, y, z = mo.x, mo.y, mo.z + mo.height / 2
		for i = #phase.particles, 1, -1
			local particle = phase.particles[i]
			if not particle.valid
				table.remove(phase.particles, i)
				continue
			end

			local dist = pointToDist3D(particle.x, particle.y, particle.z, x, y, z)
			local speed = pointToDist3D(0, 0, 0, particle.momx, particle.momy, particle.momz)

			speed = $ + phase.attractionspeed
			instaThrustTowards(particle, x, y, z, speed)

			-- Remove particle when it touches LJ Sonic
			if dist <= speed
				P_RemoveMobj(particle)
				table.remove(phase.particles, i)
			end

			if not #phase.particles
				nextPhase(mo)
			end
		end

		-- Light
		local n = #phase.particles
		local duration = 2 * TICRATE
		for s in sectors.iterate
			local srclight = phase.sectorlight[s.tag]
			s.lightlevel = max(128 + (srclight - 128) * n / phase.numparticles, 128)
		end

		-- Transparency
		local trans = max(7 * n / phase.numparticles, 0)
		mo.frame = $ & ~FF_TRANSMASK | (trans << FF_TRANSSHIFT)
	end
},

-- Waiting
{
	init = function(mo, phase)
		phase.wait = 2 * TICRATE
	end,
	action = function(mo, phase)
		handleParticles(mo, mo.particles)

		phase.wait = $ - 1
		if not phase.wait
			findTarget(mo)

			if mo.z == mo.floorz
				nextPhase(mo, "walk")
			else
				nextPhase(mo, "question")
			end
		end
	end
},

-- Give mushroom
{
	id = "give mushroom",
	init = function(mo, phase)
		S_StartSound(nil, sfx_mario9)
		phase.wait = TICRATE
	end,
	action = function(mo, phase)
		phase.wait = $ - 1
		if not phase.wait
			nextPhase(mo, "spill particles")
		end
	end
},

-- Ultimate question.
{
	id = "node",
	init = function(mo, phase)
		if not questionsparsed
			parseQuestions()
		end

		if not getTarget(mo)
			nextPhase(mo)
			return
		end

		phase.question = -1
		phase.line = 1

		startQuestion(phase, mo)

		S_StartSound(mo, sfx_indent)

		phase.time = 0
	end,
	stop = function(mo, phase)
		stopQuestion(phase)
	end,
	action = function(mo, phase)
		if not questionsparsed
			parseQuestions()
		end

		local p = getTarget(mo)
		if not p
			nextPhase(mo)
			return
		end

		handleParticles(mo, mo.particles)
		handleParticles(p.mo, phase.playerparticles)

		if p.cmd.forwardmove and not phase.confirmed
			local move
			if phase.vkeyrepeat == nil
				move = true
				phase.vkeyrepeat = TICRATE / 5
			elseif phase.vkeyrepeat == 0
				move = true
				phase.vkeyrepeat = TICRATE / 35
			else
				phase.vkeyrepeat = $ - 1
			end

			if move
				if p.cmd.forwardmove > 0 -- Up
					phase.line = max($ - 1, 1)
				elseif p.cmd.forwardmove < 0 -- Down
					phase.line = min($ + 1, 6)
				end
			end
		else
			phase.vkeyrepeat = nil
		end

		if p.cmd.buttons & BT_JUMP and phase.time >= TICRATE and not phase.confirmed
			phase.confirmed = true
			phase.time = 0
			phase.highlighted = true
			phase.numhighlights = 0
		end

		-- Make the selected line blink
		if phase.confirmed and phase.time >= TICRATE / 8
			phase.highlighted = not $
			if not phase.highlighted
				phase.numhighlights = $ + 1
			end
			phase.time = 0
		end

		if phase.confirmed and phase.numhighlights == 4
			if phase.line > 2
				P_DamageMobj(mo)
			else
				nextPhase(mo)
			end
		end

		phase.time = $ + 1
	end
},

{
	init = function(mo, phase)
		local t = mo.target
		if t and not t.valid
			t = nil
		end

		for _, particle in ipairs(mo.particles)
			if not particle.valid
				table.remove(mo.particles, i)
				continue
			end

			particle.tics = 2 * TICRATE

			if t
				particle.flags = ($ & ~MF_NOBLOCKMAP) | MF_PAIN
				instaThrustTowards(particle, t.x, t.y, t.z + t.height / 2, 32 * FU)
				S_StartSound(particle, sfx_s3ka8)
			end
		end

		if t
			local bombtypes = {
				MT_BIGMINE,     MT_ROCKET,
				MT_LASER,       MT_TORPEDO,
				MT_MINE,        MT_JETTBULLET,
				MT_TURRETLASER, MT_CANNONBALL,
				MT_ARROW,       MT_DEMONFIRE,
				MT_DRAGONMINE,  MT_TNTBARREL,
				MT_BLUECRAWLA,  MT_REDCRAWLA,
			}

			for _ = 1, 256
				local mt = randomElement(bombtypes)

				local dx, dy, dz
				repeat
					dx, dy, dz = randomDirection(512 * FU)
				until dz >= 0

				local x, y, z = t.x + dx, t.y + dy, t.z + dz
				local bomb = P_SpawnMobj(x, y, z, mt)
				instaThrustTowards(bomb, t.x, t.y, t.z, 512 * FU / (2 * TICRATE))
			end
		end

		phase.wait = 20 * TICRATE
	end,
	action = function(mo, phase)
		local t = mo.target
		if t and not t.valid
			t = nil
		end

		if t and not (leveltime % (TICRATE / 8))
			P_SpawnMobj(t.x, t.y, t.z + 512 * FU, MT_DRAGONMINE)

			-- Shoot energy balls at the target
			local ball = spawnParticle(mo.x, mo.y, mo.z)
			ball.tics = 2 * TICRATE
			ball.flags = ($ & ~MF_NOBLOCKMAP) | MF_PAIN
			ball.scale = randomFixed(FU, 8 * FU)
			instaThrustTowards(ball, t.x, t.y, t.z + t.height / 2, 64 * FU)
			S_StartSound(ball, sfx_s3k54)
		end

		phase.wait = $ - 1
		if not phase.wait
			nextPhase(mo, "spill particles")
		end
	end
},

-- Truth
{
	id = "god",
	init = function(mo, phase)
		mo.god = true
		mo.flags2 = $ | MF2_DONTDRAW

		phase.wait = 3 * TICRATE
	end,
	action = function(mo, phase)
		phase.wait = $ - 1
		if not phase.wait
			nextPhase(mo)
		end
	end
},

waitingPhase(3 * TICRATE,
	function(mo, phase)
		S_FadeOutStopMusic(MUSICRATE)

		for mo in mobjs.iterate()
			if mo.type == MT_LJPARTICLE
				mo.momx, mo.momy, mo.momz = 0, 0, 0
				mo.tics = P_RandomRange(TICRATE, 10 * TICRATE)
			end
		end
	end,
	function(mo, phase)
		for p in players.iterate
			COM_BufInsertText(p, "cecho AHAHAHAH...")
		end
	end
),

waitingPhase(5 * TICRATE,
	function(mo, phase)
		findTarget(mo)
		mo.playerparticles = {}
	end,
	function(mo, phase)
		for p in players.iterate
			COM_BufInsertText(p, "cecho Did you *SERIOUSLY* think\\you could just get rid of me?\\How naive...")
		end

		local p = getTarget(mo)
		if p
			handleParticles(p.mo, mo.playerparticles)
		end

		if not S_IdPlaying(sfx_ambin2)
			S_StartSound(nil, sfx_ambin2)
		end
	end
),

waitingPhase(5 * TICRATE,
	nil,
	function(mo, phase)
		for p in players.iterate
			COM_BufInsertText(p, "cecho I know what you are here for.\\And I won't let you have it back.")
		end

		local p = getTarget(mo)
		if p
			handleParticles(p.mo, mo.playerparticles)
		end

		if not S_IdPlaying(sfx_ambin2)
			S_StartSound(nil, sfx_ambin2)
		end
	end
),

waitingPhase(3 * TICRATE,
	nil,
	function(mo, phase)
		for p in players.iterate
			COM_BufInsertText(p, "cecho And now...")
		end

		P_StartQuake(2 * FU, TICRATE)

		if P_RandomChance(FU / 32)
			S_StartSound(nil, sfx_s3ka8)
		end

		local p = getTarget(mo)
		if p
			handleParticles(p.mo, mo.playerparticles)
		end

		if not S_IdPlaying(sfx_ambin2)
			S_StartSound(nil, sfx_ambin2)
		end
	end
),

waitingPhase(7 * TICRATE,
	function(mo, phase)
		S_StartSound(nil, sfx_s3k93)
	end,
	function(mo, phase)
		for p in players.iterate
			COM_BufInsertText(p, "cecho I don't know how you managed\\to get out of my control,\\but this time I'm not leaving you.")
		end

		if P_RandomChance(FU / 16)
			for p in players.iterate
				P_FlashPal(p, PAL_WHITE, TICRATE / 8)
			end

			S_StartSound(nil, sfx_s3k54)
		end

		P_StartQuake(4 * FU, TICRATE)

		local p = getTarget(mo)
		if p
			handleParticles(p.mo, mo.playerparticles)
		end

		if not S_IdPlaying(sfx_ambin2)
			S_StartSound(nil, sfx_ambin2)
		end
	end
),

{
	init = function(mo, phase)
		S_StartSound(nil, sfx_beflap)
	end,
	action = function(mo, phase)
		for p in players.iterate
			COM_BufInsertText(p, "cecho They must never know.")
		end

		if P_RandomChance(FU / 8)
			for p in players.iterate
				P_FlashPal(p, PAL_WHITE, TICRATE / 4)
			end

			S_StartSound(nil, sfx_s3k54)
		end

		P_StartQuake(8 * FU, TICRATE)

		local p = getTarget(mo)
		if p
			-- Attract and remove particles
			for i = #mo.playerparticles, 1, -1
				local particle = mo.playerparticles[i]
				if not particle.valid
					table.remove(phase.playerparticles, i)
					continue
				end

				-- Attract particle
				instaThrustTowards(particle, p.mo.x, p.mo.y, p.mo.z + p.mo.height / 2, 16 * FU)

				-- Remove particle when it touches the player
				local speed = pointToDist3D(0, 0, 0, particle.momx, particle.momy, particle.momz)
				local dist = pointToDist3D(particle.x, particle.y, particle.z, p.mo.x, p.mo.y, p.mo.z + p.mo.height / 2)
				if dist <= speed
					P_RemoveMobj(particle)
					table.remove(mo.playerparticles, i)
					if not #mo.playerparticles
						nextPhase(mo)
					end
				end
			end
		end

		if not S_IdPlaying(sfx_ambin2)
			S_StartSound(nil, sfx_ambin2)
		end
	end
},

waitingPhase(5 * TICRATE,
	nil,
	function(mo, phase)
		if not S_IdPlaying(sfx_ambin2)
			S_StartSound(nil, sfx_ambin2)
		end
	end
),

{
	init = function(mo, phase)
		exitLevel()
	end,
	action = function(mo, phase)
	end
},

{
	id = "pain",
	init = function(mo, phase)
		S_StartSound(nil, sfx_beflap)
		phase.wait = (mo.health > 1 and 2 or 5) * TICRATE
	end,
	stop = function(mo, phase)
		mo.sprite2 = SPR2_STND
		setFrame(mo, A)
	end,
	action = function(mo, phase)
		-- Attract and remove particles
		for i = #mo.particles, 1, -1
			local particle = mo.particles[i]
			if not particle.valid
				table.remove(mo.particles, i)
				continue
			end

			-- Attract particle
			local speed = (mo.health and 8 or 16) * mo.scale
			instaThrustTowards(particle, mo.x, mo.y, mo.z + mo.height / 2, speed)

			-- Remove particle when it touches LJ Sonic
			local speed = pointToDist3D(0, 0, 0, particle.momx, particle.momy, particle.momz)
			local dist = pointToDist3D(particle.x, particle.y, particle.z, mo.x, mo.y, mo.z + mo.height / 2)
			if dist <= speed
				-- When the first particle touches LJ Sonic
				if not phase.touched
					phase.touched = true

					P_StartQuake(4 * FU, TICRATE / 2)

					mo.health = $ - 1
					if mo.health
						mo.sprite2 = SPR2_PAIN
						setFrame(mo, A) -- Pain frame

						S_StartSound(nil, randomElement({
							sfx_begoop,
							sfx_altow1,
							sfx_mario8,
						}))
					else
						S_StartSound(nil, sfx_mario8)
						mo.destscale, mo.scalespeed = FU, FU / 12
					end
				end

				P_RemoveMobj(particle)
				table.remove(mo.particles, i)
			end
		end

		-- If dead, spawn trailing particles
		if phase.dead
			for _ = 1, 8
				local x, y, z = randomPointInSphere(mo.x, mo.y, mo.z + mo.height / 2, 16 * FU)
				local particle = spawnParticle(x, y, z)

				particle.tics = P_RandomRange(TICRATE / 4, TICRATE)
				particle.scale = randomFixed(FU / 4, FU)

				particle.momx, particle.momy, particle.momz = randomDirection(FU)
			end
		-- If done shrinking, die
		elseif not mo.health and mo.scale == mo.destscale
			phase.dead = true

			mo.sprite2 = SPR2_DEAD
			setFrame(mo, A) -- Death frame
			mo.momz = 14 * FU
			mo.flags = $ & ~MF_NOGRAVITY
			mo.flags = $ | MF_NOCLIP | MF_NOCLIPHEIGHT

			S_StartSound(mo, P_RandomRange(sfx_altdi1, sfx_altdi4))
		end

		phase.wait = $ - 1
		if not phase.wait
			if mo.health == 2
				nextPhase(mo, "give mushroom")
			elseif mo.health > 0
				nextPhase(mo, "spill particles")
			else
				exitLevel()
			end
		end
	end
},
}

addHook("PlayerThink", function(p)
	local mo = p.mo
	if mo and mo.ljhit
		mo.momx = $ / 4
		mo.momy = $ / 4
		mo.ljhit = nil
	end
end)

addHook("MobjDamage", function(mo, particle)
	if particle and particle.type == MT_LJPARTICLE
		mo.ljhit = true
	end
end, MT_PLAYER)

addHook("BossThinker", function(mo)
	phases[mo.phase.id].action(mo, mo.phase)
	return true
end, MT_LJSONIC)

addHook("MobjSpawn", function(mo)
	sugoi.SetBoss(mo, "LJ Sonic")
	mo.phase = {id = 1}
	startPhase(mo)
end, MT_LJSONIC)

addHook("MobjDamage", function(mo)
	if not mo.phase.question return true end
	nextPhase(mo, "pain")
	return true
end, MT_LJSONIC)

addHook("ShouldDamage", function(mo)
	return true
end, MT_LJSONIC)

addHook("MobjDeath", function(mo, inflictor)
	if mo.god return true end

	if inflictor and inflictor.valid
		if inflictor.skin:find("hms")
			nextPhase(mo, "god")
		else
			P_KillMobj(inflictor)
		end
		return true
	elseif not mo.phase.question
		return
	end

	mo.health = 1
	nextPhase(mo, "pain")
	return true
end, MT_LJSONIC)

-- WTF?! o_O
addHook("MobjRemoved", function(mo)
	exitLevel()
end, MT_LJSONIC)

addHook("MapLoad", function()
	if not mapheaderinfo[gamemap].kawaiii_ljsonic return end

	local n = P_RandomRange(1, 2)
	if n == 1
		mapcenterx, mapcentery = 0, 0
	elseif n == 2
		mapcenterx, mapcentery = 8192 * FU, 0
	end

	for p in players.iterate
		if not p.mo continue end

		local angle = P_RandomRange(-FU / 2, FU / 2 - 1) * FU
		P_SetOrigin(
			p.mo,
			mapcenterx + 768 * cos(angle),
			mapcentery + 768 * sin(angle),
			0
		)
		p.mo.angle = angle + ANGLE_180
	end

	local s = R_PointInSubsector(mapcenterx, mapcentery).sector
	P_SpawnMobj(mapcenterx, mapcentery, s.floorheight + 512 * FU, MT_LJSONIC)
end)

addHook("MapChange", function()
	if boss and boss.valid
		local phase = boss.phase

		-- Unlock the player
		if phase.thrustfactor ~= nil
			local p = getTarget(boss)
			if p
				p.thrustfactor = phase.thrustfactor
				if not (phase.pflags & PF_FORCESTRAFE)
					p.pflags = $ & ~PF_FORCESTRAFE
				end
				if phase.pflags & PF_ANALOGMODE
					p.pflags = $ | PF_ANALOGMODE
				end
			end
		end

		boss = nil
	end
end)

addHook("PlayerSpawn", function(p)
	if mapheaderinfo[gamemap].kawaiii_ljsonic and mapcenterx ~= nil and p.mo
		local angle = P_RandomRange(-FU / 2, FU / 2 - 1) * FU
		P_SetOrigin(
			p.mo,
			mapcenterx + 768 * cos(angle),
			mapcentery + 768 * sin(angle),
			0
		)
		p.mo.angle = angle + ANGLE_180
	end
end)

for _, h in ipairs({
	"JumpSpecial",
	"AbilitySpecial",
	"SpinSpecial",
	"JumpSpinSpecial"
})
	addHook(h, function(p)
		if boss and boss.valid
		and boss.phase.question
		and getTarget(boss) == p
			return true
		end
	end)
end

addHook("NetVars", function(n)
	boss = n($)
	mapcenterx = n($)
	mapcentery = n($)
end)

local function drawCode(v, phase)
	local code = indentationquestions[phase.question][1]

	local w, h = 300, 180
	local linenumw = 16

	v.drawFill((320 - w) / 2, (200 - h) / 2, linenumw, h, 25)
	v.drawFill((320 - w) / 2 + linenumw, (200 - h) / 2, w - linenumw, h, 27)

	local y = (200 - h) / 2 + 1
	local n = 1
	for line in code:gmatch("(.-)\n")
		-- Line number
		v.drawString((320 - w) / 2 + 2, y, "\x86"..n, nil, "small")

		-- Selected line
		if n == phase.line
			v.drawFill((320 - w) / 2 + linenumw + 1, y - 1, w - linenumw - 1, 6, 25)
		end

		-- Wrong line
		if phase.highlighted
		and line ~= ""
		and line:find("[^\t]") ~= phase.indentation[n] + 1
			v.drawFill((320 - w) / 2 + linenumw + 1, y - 1, w - linenumw - 1, 6, 39)
		end

		-- Code
		local x = (320 - w) / 2 + linenumw + 1 + phase.indentation[n] * 16
		v.drawString(x, y, line:gsub("\t", ""), V_ALLOWLOWERCASE, "small")

		y = $ + 6
		n = $ + 1
	end
end

local ultimatequestion = {
	"In Sonic Robo Blast 2, what is a \"node\"?",
	"",
	"A) An alternate term for \"player\"",
	"B) An alternate term for \"player number\"",
	"C) An entity that represents a network connection",
	"D) Something else",
	"E) I'm not sure, but I know it's not a player",
	"F) I don't know",
}

local function drawUltimateQuestion(v, phase)
	local w, h = 200, #ultimatequestion * 6

	v.drawFill((320 - w) / 2, (200 - h) / 2, w, h, 27)

	local y = (200 - h) / 2 + 1
	local n = 1
	for linenum, line in ipairs(ultimatequestion)
		-- Selected line
		if linenum - 2 == phase.line
			v.drawFill((320 - w) / 2 + 1, y - 1, w - 1, 6, 25)
		end

		-- Wrong line
		if phase.highlighted
		and line ~= ""
		and phase.line == linenum - 2
			local color = phase.line > 2 and 114 or 39
			v.drawFill((320 - w) / 2 + 1, y - 1, w - 1, 6, color)
		end

		-- Code
		local x = (320 - w) / 2 + 1
		v.drawString(x, y, line, V_ALLOWLOWERCASE, "small")

		y = $ + 6
		n = $ + 1
	end
end

hud.add(function(v, p)
	if not mapheaderinfo[gamemap].kawaiii_ljsonic return end

	if boss and boss.valid and boss.phase.question and getTarget(boss) == p
		if not questionsparsed
			parseQuestions()
		end

		if boss.phase.question == -1
			drawUltimateQuestion(v, boss.phase)
		else
			drawCode(v, boss.phase)
		end
	end
end)
