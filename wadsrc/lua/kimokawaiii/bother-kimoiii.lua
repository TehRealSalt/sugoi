//print("Hello World")

local function FixedRealRound(x)
	local a = abs(x)
	local i = (a>>FRACBITS)<<FRACBITS;
	local f = a-i
	if f == 0 then
		return x
	end
	if x == INT32_MIN
		return INT32_MIN
	elseif x < (INT32_MAX-FRACUNIT/2)+1 then
		if f >= FRACUNIT/2 then
			return FixedRound(x)
		else
			return FixedTrunc(x)
		end
	end
	return INT32_MAX
end

rawset(_G, "FixedRealRound", FixedRealRound)


local function initialisePartyStats(partyMember)
	partyMember.stats = {}
	partyMember.stats.offense = 2
	partyMember.stats.defense = 2
	partyMember.stats.speed = 2
	partyMember.stats.guts = 2
	partyMember.stats.vitality = 2
	partyMember.stats.iq = 2
	partyMember.stats.luck = 2
	partyMember.stats.hp = partyMember.stats.vitality * 15
	partyMember.stats.pp = partyMember.stats.iq * 5
	partyMember.currentStats = {}
end




local function battleEncounter(player, enemy)
	local bother = player.bother
	S_StopMusic(player)
	bother.encounterEnemy = enemy
	-- set the battle encounter formation to a random formation the enemy can give
	bother.encounterFormation = getEnemy(enemy.type).formations[P_RandomKey(#getEnemy(enemy.type).formations) + 1]

	if not getEnemy(bother.encounterEnemy.type).boss then
		-- there is a slight pause for regular enemies
		bother.battleStart = bConst.SWIRL_DURATION + 17
	else
		bother.battleStart = bConst.SWIRL_DURATION
	end

	for mobj in mobjs.iterate() do
		if not mobj.player and (mobj.flags & (MF_ENEMY|MF_BOSS)) then
			mobj.flags = mobj.flags | MF_NOTHINK
		end
	end
	bother.textBox.curText = ""
end

rawset(_G, "battleEncounter", battleEncounter)

-- I've buffed Sonic and Tails' defense because there's no equipment yet

local growthRate = {}
growthRate["sonic"] = {
	offense = 18,
	--defense = 5,
	defense = 15,
	speed = 4,
	guts = 7,
	vitality = 5,
	iq = 5,
	luck = 6
}

growthRate["tails"] = {
	offense = 12,
	--defense = 3,
	defense = 13,
	speed = 8,
	guts = 5,
	vitality = 2,
	iq = 7,
	luck = 5
}

growthRate["knuckles"] = {
	offense = 21,
	defense = 18,
	speed = 7,
	guts = 3,
	vitality = 4,
	iq = 4,
	luck = 3
}

local psiLevels = {}
psiLevels["sonic"] = {
	[2] = 23,
	[4] = 43,
	[8] = 1,
	[18] = 17,
	[19] = 9,
	[20] = 10,
	[22] = 2,
	[27] = 44
}

psiLevels["tails"] = {
	[2] = 23,
	[6] = 35,
	[8] = 13,
	[10] = 27,
	[14] = 45,
	[15] = 24,
	[23] = 28,
	[24] = 46,
	[25] = 14,
	[26] = 36,
	[29] = 41
}

psiLevels["knuckles"] = {
	[2] = 23,
	[3] = 5,
	[6] = 31,
	[12] = 32,
	[14] = 47,
	[19] = 6,
	[20] = 33,
	[21] = 45,
	[24] = 49,
	[27] = 46,
	[29] = 48
}

-- This function is just to get them all instantly leveled for the SS map
-- Has an element of randomness like the original
-- 2 people could be the same character with different stats
local function playerPartyInstantLevel(party, newLevel)
	local r
	local statGain
	while party.level < newLevel do
		--print(party.skin .. " Level " .. party.level + 1)
		for statk,statv in pairs(party.stats) do
			if statk ~= "hp" and statk ~= "pp" then
				if party.level + 1 < 10 and (statk == "vitality" or statk == "iq") then
					r = 5
				elseif (party.level + 1) % 4 == 0 then
					r = P_RandomRange(7, 10)
				else
					r = P_RandomRange(3, 6)
				end
				statGain = FixedMul(((growthRate[party.skin][statk] * party.level) - ((statv-2) * 10))*FRACUNIT, FixedDiv(r*FRACUNIT, 50*FRACUNIT))
				statGain = FixedRealRound(statGain)/FRACUNIT
				party.stats[statk] = party.stats[statk] + statGain
				--print(statk .. ": +" .. statGain .. " new: " .. party.stats[statk])
			end
		end
		-- I can't guarantee that hp and pp are updated after vitality and iq
		if party.stats.hp < 15 * party.stats.vitality then
			statGain = (15 * party.stats.vitality) - party.stats.hp
		else
			statGain = P_RandomRange(1, 3)
		end
		party.stats.hp = party.stats.hp + statGain
		--print("hp: +" .. statGain .. " new: " .. party.stats.hp)

		if party.stats.pp < 5 * party.stats.iq then
			statGain = (5 * party.stats.iq) - party.stats.pp
		else
			statGain = P_RandomRange(0, 2)
		end
		party.stats.pp = party.stats.pp + statGain
		--print("pp: +" .. statGain .. " new: " .. party.stats.pp)

		party.level = party.level + 1

		if psiLevels[party.skin][party.level] then
			--print("Adding " .. getPsi(psiLevels[party.skin][party.level]).name .. " " .. getPsi(psiLevels[party.skin][party.level]).strength .. " to " .. party.name)
			table.insert(party.psi, psiLevels[party.skin][party.level])
		end
	end

	--print("newLevel: " + newLevel)
	--print(party.skin + "vit: " + party.stats.vitality + " iq: " + party.stats.iq + " off: " + party.stats.offense + " def: " + party.stats.defense + " spd: " + party.stats.speed + " gut: " + party.stats.guts + " luc: " + party.stats.luck)

	resetCurrentStats(party)
	party.currentStats.hp = party.stats.hp*FRACUNIT
	party.currentStats.pp = party.stats.pp*FRACUNIT
end

local function playerBotherSetup(player)
	local numPartyMembers = 1

	if not (netplay or multiplayer) then
		numPartyMembers = 3
	end

	player.bother = {}
	local bother = player.bother
	bother.xScreenOff = 0
	bother.screenShake = 0
	bother.window = 0
	bother.bPress = 0
	bother.inBattle = nil
	bother.battleStart = 0
	bother.battle = {}
	bother.encounterEnemy = nil
	bother.party = {}

	local party

	for i=1,numPartyMembers,1 do
		bother.party[i] = {}
		party = bother.party[i]
		party.level = 1
		initialisePartyStats(party)
		-- Current stats, these can be edited during battle,
		-- all except HP and PP are reset afterwards
		resetCurrentStats(party)
		party.currentStats.hp = party.stats.hp*FRACUNIT
		party.currentStats.pp = party.stats.pp*FRACUNIT
		party.damage = 0
		party.ppUsed = 0
		party.name = player.name -- only 5 characters actually fit, it's trimmed in the HUD drawing
		party.skin = player.mo.skin
		if party.skin ~= "sonic" and party.skin ~= "tails" and party.skin ~= "knuckles" then
			party.skin = "sonic"
		end
		party.status = {0, 0, 0} -- statuses table
		party.takeDamage = partyTakeDamage
		party.psi = {}
	end

	if numPartyMembers == 3 then
		-- Not actual name in SP
		bother.party[1].name = skins[player.mo.skin].realname
		bother.party[2].name = "Tails"
		bother.party[2].skin = "tails"
		bother.party[3].name = "Knux"
		bother.party[3].skin = "knuckles"

		if bother.party[1].name == "Tails" then
			bother.party[2].name = "Sonic"
			bother.party[2].skin = "sonic"
		elseif bother.party[1].name == "Knuckles" then
			bother.party[1].name = "Knux"
			bother.party[2].name = "Sonic"
			bother.party[2].skin = "sonic"
			bother.party[3].name = "Tails"
			bother.party[3].skin = "tails"
		end
	end

	for i=1,numPartyMembers,1 do
		playerPartyInstantLevel(bother.party[i], 30)
	end

	-- set active to true to draw a text window, current text has what is
	-- currently written, textEvent has the event that is being written
	bother.textBox = {}
	bother.textBox.textEvent = {}
	bother.textBox.curText = ""
	bother.textBox.textEventPos = 0
	bother.textBox.textEventEnd = 0
	bother.textBox.active = false
	bother.textBox.npc = nil -- Which mobj you are currently talking to

	-- animations for PSI
	bother.animations = {}
end

local function playerEncounterThink(player)
	local bother = player.bother
	if bother.battleStart == bConst.SWIRL_DURATION then
		if not getEnemy(bother.encounterEnemy.type).boss then
			S_ChangeMusic("renctr", false, player)
		else
			S_ChangeMusic("benctr", false, player)
		end
	end
	if bother.battleStart == 10 then
		battleInitiate(player)
	end
	bother.battleStart = bother.battleStart - 1
	player.mo.momx = 0
	player.mo.momy = 0
	player.mo.momz = 0
	player.powers[pw_nocontrol] = 1
end

local function playerSpawnBother(player)
	player.bother = nil
	-- the player.bother is the player information for the bother gamemap
	-- I did it this way to easily clean it after the map was over
	if mapheaderinfo[gamemap].bother then
		//print("Setting up the party for player: " .. #player)
		playerBotherSetup(player)
		sugoi.HUDShow("score", false)
		sugoi.HUDShow("time", false)
		sugoi.HUDShow("rings", false)
		sugoi.HUDShow("lives", false)
	else
		return
	end
	if not player.starposttime then
		-- Play the intro!
		player.bother.textBox.curText = ""
		playerGenerateText(player, getTextEvent("intro", "1"))
		player.bother.textBox.active = true
		player.bother.textBox.npc = player.mo
	end
end

-- Executes when the map is changed from the map with BOTHER enabled
-- Simple, set player.bother (holds all the BOTHER stuff) to nil for the game
-- To figure out there's no references left to any of the stuff and remove
local function playerBotherMapEnd(mapnum)
	if mapheaderinfo[mapnum].bother then
		for player in players.iterate do
			player.bother = nil
			player.normalspeed = skins[player.mo.skin].normalspeed
		end
		sugoi.HUDShow("score", true)
		sugoi.HUDShow("time", true)
		sugoi.HUDShow("rings", true)
		sugoi.HUDShow("lives", true)
	end
end

-- Executes when the map is changed to the BOTHER map
-- Sets up the players party, disables the unused HUD elements
local function playerBotherMapStart(mapnum)
	if mapheaderinfo[mapnum].bother then
		for player in players.iterate do
			if not player.bother then -- Need to check this in case player is joining in progress netgame
				//print("Setting up the party for player: " .. #player)
				playerBotherSetup(player)
			end
		end
		sugoi.HUDShow("score", false)
		sugoi.HUDShow("time", false)
		sugoi.HUDShow("rings", false)
		sugoi.HUDShow("lives", false)
	end
end

local function playerThinkBother(mobj)
	local player
	if not mobj.player then
		return
	else
		player = mobj.player
	end

	-- the player.bother is the player information for the bother gamemap
	-- I did it this way to easily clean it after the map was over
	if mapheaderinfo[gamemap].bother and not player.bother then
		//print("Setting up the party for player: " .. #player)
		playerBotherSetup(player)
		sugoi.HUDShow("score", false)
		sugoi.HUDShow("time", false)
		sugoi.HUDShow("rings", false)
		sugoi.HUDShow("lives", false)
	end

	if not player.bother then
		return
	end

	player.normalspeed = skins[player.mo.skin].runspeed / 3

	if player.bother.battleStart then
		playerEncounterThink(player)
	end

	if player.bother.textBox.textEvent
	and not (player.bother.menu and player.bother.menu.active) then
		playerTextThink(player)
	end

	if player.bother.inBattle ~= nil then
		playerBattleThink(player)
	end

	if player.bother.menu and player.bother.menu.active then
		player.pflags = player.pflags | PF_FORCESTRAFE
		playerMenuThink(player, player.bother.menu)
	else
		player.pflags = player.pflags & ~(PF_FORCESTRAFE)
	end

	if player.bother.screenShakeIntensity then
		player.bother.screenShake = P_RandomRange(-player.bother.screenShakeIntensity, player.bother.screenShakeIntensity)
		if leveltime % 4 == 0 then
			player.bother.screenShakeIntensity = player.bother.screenShakeIntensity - 1
		end
	end

	if player.bother.screenWobble then
		local timeToAngle = FixedAngle(FixedMul(FixedDiv(player.bother.screenWobble*FRACUNIT, 35*FRACUNIT), 360*FRACUNIT))
		player.bother.xScreenOff = FixedRealRound(FixedMul(sin(timeToAngle), 32*FRACUNIT))/FRACUNIT
		player.bother.screenWobble = player.bother.screenWobble - 1
	else
		player.bother.screenWobble = 0
	end

	for k, anim in ipairs(player.bother.animations) do
		if anim.ticker then
			player.bother.animations[k].ticker = player.bother.animations[k].ticker - 1

			if anim.ticker == 0 then
				table.remove(player.bother.animations, k)
			end
		end
	end
end

local function damageBother(target, inflictor, source, damage)
	if not mapheaderinfo[gamemap].bother then
		return nil
	end

	if (target.flags & MF_NOTHINK) or (source.flags & MF_NOTHINK) then
		return true
	end

	local thisPlayer
	local thisEnemy
	if target.player then
		thisPlayer = target.player
		thisEnemy = source
	elseif source and source.player then
		thisPlayer = source.player
		thisEnemy = target
	end
	if thisPlayer then
		battleEncounter(thisPlayer, thisEnemy)
	end
	return true
end

local function jumpHandling(player)
	if mapheaderinfo[gamemap].bother then
		if not (player.pflags & PF_JUMPDOWN) then
			local dist = player.mo.radius
			local x = player.mo.x + P_ReturnThrustX(player.mo, player.mo.angle, dist)
			local y = player.mo.y + P_ReturnThrustY(player.mo, player.mo.angle, dist)
			local talktime = P_SpawnMobj(x, y, player.mo.z, MT_TALKCHECK)
			talktime.destscale = player.mo.scale
			talktime.scale = player.mo.scale
			talktime.eflags = talktime.eflags|(player.mo.eflags&MFE_VERTICALFLIP)
			talktime.target = player.mo
		end
		return true
	end
end

local function disableSpinJump(player)
	if mapheaderinfo[gamemap].bother then
		return true
	end
end

local npcDialogues = {}
npcDialogues[MT_BLONICCRAWLA]		= {"blonic", "1"}
npcDialogues[MT_BOINSCHOOLHOUSE]	= {"sssonic", "start"}
npcDialogues[MT_EDGYHEDGY]			= {"shadow", "start"}
npcDialogues[MT_TONI]				= {"final", "1"}

local function openTheGame(talktime, other)
	if not talktime.target or not talktime.target.player then
		return nil
	end
	local player = talktime.target.player
	if not player.bother or player.bother.textBox.active or player.bother.battleStart or player.bother.inBattle ~= nil then
		return nil
	end
	if talktime.z > other.z + other.height
	or talktime.z + talktime.height < other.z then
		return false
	end
	if npcDialogues[other.type] then
		local dialogue = npcDialogues[other.type]
		player.bother.textBox.curText = ""
		player.bother.textBox.npc = other
		other.reactiontime = other.reactiontime + 1
		playerGenerateText(player, getTextEvent(dialogue[1], dialogue[2]))
		player.bother.textBox.active = true
	end
	return nil
end

addHook("MapChange", playerBotherMapEnd)
addHook("MapLoad", playerBotherMapStart)
addHook("PlayerSpawn", playerSpawnBother)
addHook("MobjThinker", playerThinkBother, MT_PLAYER)
addHook("MobjDamage", damageBother)
addHook("JumpSpecial", jumpHandling)
addHook("SpinSpecial", disableSpinJump)
addHook("MobjMoveCollide", openTheGame, MT_TALKCHECK)
