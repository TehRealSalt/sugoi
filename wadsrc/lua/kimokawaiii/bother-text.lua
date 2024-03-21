local function textEnemyName(player)
	if getEnemy(player.bother.encounterEnemy.type).theFlag then
		return " The " .. getEnemy(player.bother.encounterEnemy.type).name
	end
	return " " .. getEnemy(player.bother.encounterEnemy.type).name
end

local function textCohorts(player)
	if not player.bother.battle.enemies then
		return ""
	end
	local numEnemies = 0
	for rowk, rowv in pairs(player.bother.battle.enemies) do
		for xk, xv in pairs(rowv) do
			numEnemies = numEnemies + 1
		end
	end
	
	if numEnemies == 2 then
		return "and its cohort"
	elseif numEnemies > 2 then
		return "and its cohorts"
	end
	return ""
end

local function textActionUser(player)
	if not player.bother.battle.actions[1].subactions[1].user.name then
		return "INVALID USER"
	end
	return player.bother.battle.actions[1].subactions[1].user.name
end

local function textActionTarget(player)
	if not player.bother.battle.actions[1].subactions[1].target.name then
		return "INVALID TARGET"
	end
	return player.bother.battle.actions[1].subactions[1].target.name
end

local function textEnemyDying(player)
	player.bother.battle.actions[1].subactions[1].target.dying = 20
end

--The PSI name gets put into the action so I can say it
local function textPsiName(player)
	if not player.bother.battle.actions[1].subactions[1].arg then
		return "INVALID PSI NAME"
	end
	local psi = getPsi(player.bother.battle.actions[1].subactions[1].arg)
	return psi.name .. " " .. psi.strength
end

-- This will always give a positive number
local function textNumber(player)
	if player.bother.battle.actions[1].subactions[1].number == nil then
		return "NaN"
	end
	return tostring(abs(player.bother.battle.actions[1].subactions[1].number))
end

local function textPartyName(player, partyNum)
	if not player.bother.party[partyNum] then
		return "INVALID PARTY NAME"
	end
	return player.bother.party[partyNum].name
end

local function textSound(player, soundNum)
	S_StartSound(nil, soundNum, player)
end

local function textMusic(player, songName)
	S_ChangeMusic(songName, true, player)
end

local function textUserGender1(player)
	local user = player.bother.battle.actions[1].subactions[1].user
	if user.skin then
		return "he"
	end
	local enemy = getEnemy(user.type)
	if enemy.gender == 0 then
		return "it"
	elseif enemy.gender == 1 then
		return "he"
	elseif enemy.gender == 2 then
		return "she"
	end
	
	return "GENDER IS NOT BINARY"
end

-- Finds where the enemy is in the enemy table
local function findInEnemyTable(table, enemy)
	for rowk,rowv in pairs(table) do
		for ek,_ in pairs(rowv) do
			if table[rowk][ek] == enemy then
				return rowk,ek
			end
		end
	end
end

local function rowToAnimY(row)
	-- I am guessing at - 15... enemies are placed at the pos minus the patch height
	if row == 1 then
		return -5 - 15
	else
		return 25 - 15
	end
end

local function rowColToAnimX(row, col)
	local x = 0
	if row == 1 then
		x = 60
	else
		x = 55
	end
	
	x = x + ((col-1) * 35)
	return x - 160
end

local function textStartAnim(player, args)
	local animNum = args[1]
	local allyTarget = args[2]
	local subaction = player.bother.battle.actions[1].subactions[1]
	local perform = false
	
	if allyTarget then
		if subaction.target == 3 or subaction.target == "party" or (type(subaction.target) == "table" and subaction.target.skin) then
			perform = true
		end
	else
		if subaction.target == 1 or subaction.target == 2 or subaction.target == "enemies" or (type(subaction.target) == "table" and not subaction.target.skin) then
			perform = true
		end
	end
	
	if not perform then
		return
	end
	
	-- Special case, move screen back and forth
	if animNum == 47 then
		player.bother.screenWobble = 70
		return
	end
	
	if not getPsiAnim(animNum) then
		return
	end
	local psiAnim = getPsiAnim(animNum)
	local xOffset = 0
	local yOffset = 0
	local target = player.bother.battle.actions[1].subactions[1].target
	if psiAnim.target == bConst.ANIMTARGET_ALL or target == 3 then
		xOffset = 0
		yOffset = 0
	elseif type(target) == "number" then
		xOffset = 0
		yOffset = rowToAnimY(target)
	else
		local ey, ex = findInEnemyTable(player.bother.battle.enemies, target)
		xOffset = rowColToAnimX(ey, ex)
		yOffset = rowToAnimY(ey)
	end
	table.insert(player.bother.animations, {psiAnim = psiAnim, ticker = psiAnim.speed * psiAnim.frames,
		xOffset = xOffset, yOffset = yOffset})
end

local function textStartBattle(player, args)
	battleEncounter(player, player.bother.textBox.npc)
	player.bother.textBox.npc = nil
end

local function textExitLevel(player, args)
	local delay = args or 0
	player.exiting = 3 + delay
end

local function goToText(player, args)
	local textEvent = getTextEvent(args[1], args[2])
	playerGenerateText(player, textEvent)
	player.bother.textBox.textEventPos = 0
	player.bother.textBox.active = true
end

-- 1 is the FIRST time you've talked, gets incremented right before text is generated
local function goToIfTalked(player, args)
	local textEvent = getTextEvent(args[1], args[2])
	local chatsNeeded = args[3]
	-- use reactiontime to count how many times an npc has been talked to
	if player.bother.textBox.npc.reactiontime >= chatsNeeded then
		playerGenerateText(player, textEvent)
		player.bother.textBox.textEventPos = 0
		player.bother.textBox.active = true
	end
end

local function textDialogueWait(player, args)
	setupDialogueWait(player)
end


-- A single number tells me how long the textEvent should wait before continuing
-- functions are stored in tables with func, and args
-- textFunc is a function that only returns text
-- func is a function that performs an action, and should only be run when the 
-- text actually gets there, if both are placed in one table only textfunc is done
local textEvents = {}
textEvents.encounter = {}
textEvents.encounter["attacked"]	= {"@", {textFunc = textEnemyName}, " ", {textFunc = textCohorts}, " attacked!", 35, {func = setupBattleMenu, args=1}}
textEvents.encounter["blocked"] 	= {"@", {textFunc = textEnemyName}, " ", {textFunc = textCohorts}, " blocked the way!", 35, {func = setupBattleMenu, args=1}}
textEvents.encounter["came"] 		= {"@", {textFunc = textEnemyName}, " ", {textFunc = textCohorts}, " came after you!", 35, {func = setupBattleMenu, args=1}}
textEvents.encounter["trapped"] 	= {"@", {textFunc = textEnemyName}, " ", {textFunc = textCohorts}, " trapped you!", 35, {func = setupBattleMenu, args=1}}
textEvents.encounter["encounter"] 	= {"@You encounter", {textFunc = textEnemyName}, " ", {textFunc = textCohorts}, 35, {func = setupBattleMenu, args=1}}
textEvents.encounter["meet"] 		= {"@You meet", {textFunc = textEnemyName}, " ", {textFunc = textCohorts}, 35, {func = setupBattleMenu, args=1}}
textEvents.encounter["engage"]	 	= {"@You engage", {textFunc = textEnemyName}, " ", {textFunc = textCohorts}, 35, {func = setupBattleMenu, args=1}}
textEvents.encounter["confront"] 	= {"@You confront", {textFunc = textEnemyName}, " ", {textFunc = textCohorts}, 35, {func = setupBattleMenu, args=1}}

textEvents.sssonic = {}
textEvents.sssonic["start"]			= {{func = goToIfTalked, args = {"sssonic", "onceagain", 2}}, {func = goToText, args = {"sssonic","1"}}}
textEvents.sssonic["1"]				= {"\n@Oh there you are, finally, I've...", {func = textDialogueWait}, {func = goToText, args = {"sssonic","2"}}}
textEvents.sssonic["2"]				= {"\n@... The hell? I didn't call you here.", {func = textDialogueWait}, "\n`The owner of the mansion is up the next flight of stairs.", {func = textDialogueWait}, {func = goToText, args = {"sssonic","3"}}}
textEvents.sssonic["3"]				= {"\n@I can barely afford enough rings", {func = textDialogueWait}, "\n`to keep my shitty 3D prerendered sprites intact.", {func = textDialogueWait}, {func = goToText, args = {"sssonic","4"}}}
textEvents.sssonic["4"]				= {"\n@I work at the schoolhouse a few chaos controls down the zone.", {func = textDialogueWait}, "\n`I help young kids properly control their edge.", {func = textDialogueWait}, {func = goToText, args = {"sssonic","5"}}}
textEvents.sssonic["5"]				= {"\n@It's a tough job, but there's no-one better at it than me.", {func = textDialogueWait}, {func = goToText, args = {"sssonic","6"}}}
textEvents.sssonic["6"]				= {"\n@Now, I know you've been here before,", {func = textDialogueWait}, "\n`but those places you caused a mess in,", {func = textDialogueWait}, "\n`were Zones separated from the Shadow Realm.", {func = textDialogueWait}, "\n`Your abilities weren't properly nerfed like they deserve to be.", {func = textDialogueWait}, {func = goToText, args = {"sssonic","7"}}}
textEvents.sssonic["7"]				= {"\n@Now that you'll be fighting here you'll be doing it under OUR rules...", {func = textDialogueWait}, {func = goToText, args = {"sssonic","8"}}}
textEvents.sssonic["8"]				= {"\n@Listen carefully, and remember, YOU talked to ME for help... Imbecile.", {func = textDialogueWait}, {func = goToText, args = {"sssonic","9"}}}
textEvents.sssonic["9"]				= {"\n@PK Speed is a high powered attack to all enemies.", {func = textDialogueWait}, {func = goToText, args = {"sssonic","10"}}}
textEvents.sssonic["10"]			= {"\n@PK Freeze is a strong attack to one enemy that can also solidify them.", {func = textDialogueWait}, {func = goToText, args = {"sssonic","11"}}}
textEvents.sssonic["11"]			= {"\n@PK Fire is a moderate damage attack that hits a single row of enemies.", {func = textDialogueWait}, {func = goToText, args = {"sssonic","12"}}}
textEvents.sssonic["12"]			= {"\n@PK Thunder is an attack which will hit a random enemy 1-4 times.", {func = textDialogueWait}, "\n`The number of hits is based on power.", {func = textDialogueWait}, "\n`It's more accurate when there's more targets.", {func = textDialogueWait}, {func = goToText, args = {"sssonic","13"}}}
textEvents.sssonic["13"]			= {"\n@PK Flash can cause enemies to experience various status effects.", {func = textDialogueWait}, "\n`[ can cause crying or feeling strange.", {func = textDialogueWait}, {func = goToText, args = {"sssonic","14"}}}
textEvents.sssonic["14"]			= {"\n@Lifeup will heal an ally.", {func = textDialogueWait}, {func = goToText, args = {"sssonic","15"}}}
textEvents.sssonic["15"]			= {"\n@Healing cures status conditions.", {func = textDialogueWait}, "\n`[ cures cold, sunstroke, or sleep.", {func = textDialogueWait}, "\n`\\ also cures poison, nausea, crying, or feeling strange.", {func = textDialogueWait}, {func = goToText, args = {"sssonic","16"}}}
textEvents.sssonic["16"]			= {"\n@PSI Magnet drains PP from enemies if they have any.", {func = textDialogueWait}, {func = goToText, args = {"sssonic","17"}}}
textEvents.sssonic["17"]			= {"\n@Shield gives allies a physical damage reducing shield, \\ is also reflective.", {func = textDialogueWait}, {func = goToText, args = {"sssonic","18"}}}
textEvents.sssonic["18"]			= {"\n@PSI shield gives allies a shield from damaging PSI", {func = textDialogueWait}, {func = goToText, args = {"sssonic","19"}}}
textEvents.sssonic["19"]			= {"\n@Hypnosis puts enemies to sleep.", {func = textDialogueWait}, {func = goToText, args = {"sssonic","20"}}}
textEvents.sssonic["20"]			= {"\n@Brainshock can make enemies feel strange.", {func = textDialogueWait}, {func = goToText, args = {"sssonic","21"}}}
textEvents.sssonic["21"]			= {"\n@Paralysis can paralyze enemies", {func = textDialogueWait}, {func = goToText, args = {"sssonic","22"}}}
textEvents.sssonic["22"]			= {"\n@Defense Down can lower enemies' defense.", {func = textDialogueWait}, {func = goToText, args = {"sssonic","23"}}}
textEvents.sssonic["23"]			= {"\n@It's done, go, and don't question a single word I said.", {func = textDialogueWait}, 1}
textEvents.sssonic["onceagain"]		= {"\n@Soon enough... I'll have my own set of sprites like the real Shadow...", {func = textDialogueWait}, 1}

textEvents.intro = {}
textEvents.intro["1"] 				= {"\n@Sonic: What the!? We're so slow!", {func = textDialogueWait}, {func = goToText, args = {"intro","2"}}}
textEvents.intro["2"]				= {"\n@Tails: It looks like we're in some kind of \"RPG\" mode.", {func = textDialogueWait}, {func = goToText, args = {"intro","3"}}}
textEvents.intro["3"]				= {"\n@Sonic: Well, can we at least get a bike or something?", {func = textDialogueWait}, {func = goToText, args = {"intro","4"}}}
textEvents.intro["4"]				= {"\n@Knux: Maybe, but it probably wouldn't be a tandem,", {func = textDialogueWait}, "\n`so we wouldn't be able to use it together.", {func = textDialogueWait}, {func = goToText, args = {"intro","5"}}}
textEvents.intro["5"]				= {"\n@Sonic: WHAT! Lame...", {func = textDialogueWait}, {func = goToText, args = {"intro","6"}}}
textEvents.intro["6"]				= {"\n@Tails: Who made this anyway? I wonder if they actually find this fun.", {func = textDialogueWait}, {func = goToText, args = {"intro","7"}}}
textEvents.intro["7"]				= {"\n@Knux: I'm not sure, I wonder what's next though?", {func = textDialogueWait}, "\n`Making us play some stupid puzzle game?", {func = textDialogueWait}, {func = goToText, args = {"intro","8"}}}
textEvents.intro["8"]				= {"\n@Tails: Don't jinx it Knuckles!", {func = textDialogueWait}, {func = goToText, args = {"intro","9"}}}
textEvents.intro["9"]				= {"\n@Sonic: Look there's Shadow,", {func = textDialogueWait}, "\n`let's go and see what he called us here for anyway", {func = textDialogueWait}, 1}

textEvents.shadow = {}
textEvents.shadow["start"]			= {{func = goToIfTalked, args = {"shadow", "onceagain", 2}}, {func = goToText, args = {"shadow","1"}}}
textEvents.shadow["1"]				= {"\n@Finally you arrive...", {func = textDialogueWait}, "\n`It's actually pitiful that you still don't know the 3-Frame Chaos Control tech,", {func = textDialogueWait}, "\n`but at least you're here.", {func = textDialogueWait}, {func = goToText, args = {"shadow","2"}}}
textEvents.shadow["2"]				= {"\n", 35, {func = goToText, args = {"shadow","3"}}}
textEvents.shadow["3"]				= {"\n@... With your low level butt buddies in tow... Sigh.", {func = textDialogueWait}, {func = goToText, args = {"shadow","4"}}}
textEvents.shadow["4"]				= {"\n", 35, {func = goToText, args = {"shadow","5"}}}
textEvents.shadow["5"]				= {"\n@I've got more important shit to deal with, so I'll be quick, unlike you.", {func = textDialogueWait}, {func = goToText, args = {"shadow","6"}}}
textEvents.shadow["6"]				= {"\n@Sonic, do you have... A relative? A brother or cousin?", {func = textDialogueWait}, "\n`Do they resemble you, but with much more... Girth?", {func = textDialogueWait}, {func = goToText, args = {"shadow","7"}}}
textEvents.shadow["7"]				= {"\n@...", {func = textDialogueWait}, {func = goToText, args = {"shadow","8"}}}
textEvents.shadow["8"]				= {"\n@Don't answer those questions.", {func = textDialogueWait}, "\n`The last thing I need to know is that there are more than one of you about.", {func = textDialogueWait}, {func = goToText, args = {"shadow","9"}}}
textEvents.shadow["9"]				= {"\n@Listen, about 3 days ago some strange triangle looking creature", {func = textDialogueWait}, "\n`ran through my front yard and into the back", {func = textDialogueWait}, "\n`with something that vaguely resembles you.", {func = textDialogueWait}, {func = goToText, args = {"shadow","10"}}}
textEvents.shadow["10"]				= {"\n@Shortly before you arrived,", {func = textDialogueWait}, "\n`it transformed into one of those terrible tank robots", {func = textDialogueWait}, "\n`The Doctor keeps spamming in every goddamn Zone", {func = textDialogueWait}, {func = goToText, args = {"shadow","11"}}}
textEvents.shadow["11"]				= {"\n@Now, I don't know what it is, and I don't know who that was,", {func = textDialogueWait}, "\n`but you need to go back there and deal with your shit.", {func = textDialogueWait}, {func = goToText, args = {"shadow","12"}}}
textEvents.shadow["12"]				= {"\n@And yes, it is clearly YOUR shit, and not mine.", {func = textDialogueWait}, "\n`Nothing I do has been blue since 2005 and I tried being the 'good one'.", {func = textDialogueWait}, {func = goToText, args = {"shadow","13"}}}
textEvents.shadow["13"]				= {"\n@So go into my backyard,", {func = textDialogueWait}, "\n`get rid of that thing and its owner,", {func = textDialogueWait}, "\n`and then get off my damn property.", {func = textDialogueWait}, 1}
textEvents.shadow["onceagain"]		= {"\n@What? You want to come back into my house?", {func = textDialogueWait}, "\n`I'm still cleaning up the mess you made last time looking for HyperMysteriousShadonic123311.", {func = textDialogueWait}, "\n`I may be famous and popular but even I don't have enough rings to fix what YOU did a second time...", {func = textDialogueWait}, 1}

textEvents.blonic = {}
textEvents.blonic["1"]				= {{func = textMusic, args = "CHLNGE"}, "\n@Oh, you. My creator based me off of you.", {func = textDialogueWait}, {func = goToText, args = {"blonic","2"}}}
textEvents.blonic["2"]				= {"\n@... I know I don't look much like you now, but we used to be very similar", {func = textDialogueWait}, {func = goToText, args = {"blonic","3"}}}
textEvents.blonic["3"]				= {"\n@My creator is, sadly, ashamed of his masterpiece.", {func = textDialogueWait}, "\n`He spent countless hours reincarnating me until I was absolute perfection.", {func = textDialogueWait}, {func = goToText, args = {"blonic","4"}}}
textEvents.blonic["4"]				= {"\n@Then, without warning, he tossed me away in some dark closet with a bunch of other goofy looking guys.", {func = textDialogueWait}, {func = goToText, args = {"blonic","5"}}}
textEvents.blonic["5"]				= {"\n@He thought he got rid of me, for a while.", {func = textDialogueWait}, "\n`But he realized his mistake not too long ago.", {func = textDialogueWait}, {func = goToText, args = {"blonic","6"}}}
textEvents.blonic["6"]				= {"\n@So he stuck my soul and face onto this prototype crawla.", {func = textDialogueWait}, "\n`They codenamed it \"The Tapeworm\".", {func = textDialogueWait}, {func = goToText, args = {"blonic","7"}}}
textEvents.blonic["7"]				= {"\n@My creator slipped up, though. All of my power from before is still here.", {func = textDialogueWait}, "\n`So I've trapped him on the pedestal behind me.", {func = textDialogueWait}, {func = goToText, args = {"blonic","8"}}}
textEvents.blonic["8"]				= {"\n@I know you're here to save him... But I'm not letting you!", {func = textDialogueWait}, {func = goToText, args = {"blonic","9"}}}
textEvents.blonic["9"]				= {"\n@He needs to pay for never finishing his perfect creation!", {func = textDialogueWait}, {func = goToText, args = {"blonic","10"}}}
textEvents.blonic["10"]				= {"\n@He needs to pay for the endless reincarnations!", {func = textDialogueWait}, {func = goToText, args = {"blonic","11"}}}
textEvents.blonic["11"]				= {"\n@He needs to pay for throwing me away in a dark closet!", {func = textDialogueWait}, 35, {func = textStartBattle, args=MT_BLONICCRAWLA}}

textEvents.final = {}
textEvents.final["1"]				= {"\n@Iceman: What the hell is this?", {func = textDialogueWait}, "\n`Sryder did you do this?", {func = textDialogueWait}, "\n`I swear to God if you took my avatar and put me into SRB2 I'll-", {func = textExitLevel, args = 0}}

textEvents.action = {}
textEvents.action["bash"]			= {{func = textSound, args = sfx_aattck}, "\n@", {textFunc = textActionUser}, " attacks!", {func = textSound, args = sfx_attckp}, 18}
textEvents.action["abash"]			= {{func = textSound, args = sfx_eattck}, "\n@", {textFunc = textActionUser}, " is attacking!", {func = textSound, args = sfx_attckp}, 18}
textEvents.action["enemydamage"]	= {{func = textSound, args = sfx_bash}, "\n@", {textFunc = textNumber}, " HP of damage\n`to ", {textFunc = textActionTarget}, "!", 18}
textEvents.action["allydamage"]		= {{func = textSound, args = sfx_ahit}, "\n@", {textFunc = textNumber}, " HP of damage\n`to ", {textFunc = textActionTarget}, "!", 18}
textEvents.action["mortaldamage"]	= {{func = textSound, args = sfx_mortal}, "\n@", {textFunc = textNumber}, " HP of mortal damage\n`to ", {textFunc = textActionTarget}, "!", 18}
textEvents.action["allysmash"]		= {{func = textSound, args = sfx_asmash}, "\n`\127", 18}
textEvents.action["enemysmash"]		= {{func = textSound, args = sfx_esmash}, "\n`\127", 18}
textEvents.action["missed"]			= {{func = textSound, args = sfx_miss}, "\n@Just missed!", 18}
textEvents.action["dodged"]			= {{func = textSound, args = sfx_dodge}, "\n@", {textFunc = textActionTarget}, " dodged\n`quickly!", 18}
textEvents.action["adefend"]		= {"\n@", {textFunc = textActionUser}, " is on guard.", 18}
textEvents.action["didnotwork"]		= {"\n@It did not work\n`on ", {textFunc = textActionTarget}, "!", 18}
textEvents.action["didnthit"]		= {"\n@It didn't hit anyone!", 18}
textEvents.action["alreadygone"]	= {"\n@But ", {textFunc = textActionTarget}, " was\n`already gone...", 18}
textEvents.action["nopp"]			= {"\n@But, ", {textFunc = textUserGender1}, " didn't have enough PP.", 18}

textEvents.action["helpcall"]		= {{func = textSound, args = sfx_eattck}, "\n@", {textFunc = textActionUser}, " called\n` for help!",  {func = textSound, args = sfx_helpca}, 18}
textEvents.action["noonecame"]		= {"\n@But no one came.", 18}
textEvents.action["joinedbattle"]	= {"\n@", {textFunc = textActionTarget}, " joined\n`the battle.", 18}

textEvents.action["laughing"]		= {{func = textSound, args = sfx_eattck}, "\n@", {textFunc = textActionUser}, " started\n`laughing hysterically!", 18}
textEvents.action["felldown"]		= {{func = textSound, args = sfx_eattck}, "\n@", {textFunc = textActionUser}, " fell down!", 18}
textEvents.action["howling"]		= {{func = textSound, args = sfx_eattck}, "\n@", {textFunc = textActionUser}, " is\n`making a loud, piercing howl.", 18}
textEvents.action["biting"]			= {{func = textSound, args = sfx_eattck}, "\n@", {textFunc = textActionUser}, " used a\n`biting attack!", 18}
textEvents.action["coiled"]			= {{func = textSound, args = sfx_eattck}, "\n@", {textFunc = textActionUser}, " coiled\n`around you and attacked!", 18}
textEvents.action["hulahoop"]		= {{func = textSound, args = sfx_eattck}, "\n@", {textFunc = textActionUser}, " swung\n`its hula hoop!(?)", {func = textSound, args = sfx_attckp}, 18}
textEvents.action["charged"]		= {{func = textSound, args = sfx_eattck}, "\n@", {textFunc = textActionUser}, " charged\n`forward!", 18}
textEvents.action["shredded"]		= {{func = textSound, args = sfx_eattck}, "\n@", {textFunc = textActionUser}, " shredded\n`fiercely on a skateboard!(?)", 18}

textEvents.action["reassure"]		= {"\n@", {textFunc = textActionUser}, " tells the others\n`Kart will be released soon(tm)...", 35, {func = textMusic, args = "ENRAGE"}, "\n@The other enemies\n`were enraged!", 18}
textEvents.action["cashgrab"]		= {"\n@", {textFunc = textActionUser}, " said\n`Top Down was a cash grab...", 35, {func = textMusic, args = "ENRAGE"}, "\n@The other enemies\n`were enraged!", 18}
textEvents.action["crawled"]		= {{func = textSound, args = sfx_eattck}, "\n@", {textFunc = textActionUser}, " crawled\n`forwards menacingly!", 18}
textEvents.action["anime"]			= {{func = textSound, args = sfx_eattck}, "\n@", {textFunc = textActionUser}, " looked\n`on with anime eyes.", 18}
textEvents.action["stairfail"]		= {{func = textSound, args = sfx_eattck}, "\n@", {textFunc = textActionUser}, " failed\n`getting up some stairs.", 18}
textEvents.action["nosefire"]		= {{func = textSound, args = sfx_eattck}, "\n@", {textFunc = textActionUser}, " shot\n`fire from its nose!", 18}
textEvents.action["succ"]			= {{func = textSound, args = sfx_eattck}, "\n@", {textFunc = textActionUser}, " used\n`a sucky attack!", 18}
textEvents.action["sharpturn"]		= {{func = textSound, args = sfx_eattck}, "\n@", {textFunc = textActionUser}, " makes a sharp turn,\n`then realises its mistake.", 18}
textEvents.action["preparing"]		= {{func = textSound, args = sfx_eattck}, "\n@", {textFunc = textActionUser}, " is\n`preparing to strike!", 18}
textEvents.action["blonicbounce"]	= {{func = textSound, args = sfx_eattck}, "\n@", {textFunc = textActionUser}, " used\n`a Blonic bounce!", 18}

textEvents.action["heal"]			= {"\n@", {textFunc = textActionTarget}, " recovered\n` ", {textFunc = textNumber}, " HP!", {func = textSound, args = sfx_hpheal}, 18}
textEvents.action["maxedout"]		= {"\n@", {textFunc = textActionTarget}, "'s HP are\n`maxed out!", {func = textSound, args = sfx_hpheal}, 18}

textEvents.action["noviseffect"]	= {"\n@It had no visible effect\n`on ", {textFunc = textActionTarget}, "!", 18}

textEvents.action["ppdrain"]		= {"\n@Drained ", {textFunc = textNumber}, " PP\n`from ", {textFunc = textActionTarget}, "!", 18}

textEvents.action["defdown"]		= {"\n@", {textFunc = textActionTarget}, "'s defense\n`went down by ", {textFunc = textNumber}, "!", {func = textSound, args = sfx_statdn}, 18}

textEvents.action["offup"]			= {"\n@", {textFunc = textActionTarget}, "'s offense\n`went up by ", {textFunc = textNumber}, "!", {func = textSound, args = sfx_statup}, 18}
textEvents.action["spdup"]			= {"\n@", {textFunc = textActionTarget}, "'s speed\n`went up by ", {textFunc = textNumber}, "!", {func = textSound, args = sfx_statup}, 18}

textEvents.action["shield"]			= {"\n@", {textFunc = textActionTarget}, "'s body was protected by the shield of light!", 18}
textEvents.action["shieldstr"]		= {"\n@", {textFunc = textActionTarget}, "'s shield became stronger!", 18}
textEvents.action["pshield"]		= {"\n@", {textFunc = textActionTarget}, "'s body was protected by the power shield!", 18}
textEvents.action["pshieldstr"]		= {"\n@", {textFunc = textActionTarget}, "'s power shield became stronger!", 18}
textEvents.action["psyshield"]		= {"\n@", {textFunc = textActionTarget}, "'s body was protected by the psychic shield!", 18}
textEvents.action["psyshieldstr"]	= {"\n@", {textFunc = textActionTarget}, "'s psychic shield became stronger!", 18}
textEvents.action["ppsyshield"]		= {"\n@", {textFunc = textActionTarget}, "'s body was protected by\n`the psychic power shield!", 18}
textEvents.action["ppsyshieldstr"]	= {"\n@", {textFunc = textActionTarget}, "'s psychic power shield became stronger!", 18}
textEvents.action["shielddis"]		= {"\n@", {textFunc = textActionTarget}, "'s shield\n`disappeared!", 18}
textEvents.action["shielddef"]		= {"\n@The power shield\n`deflected the attack!", {func = textSound, args=sfx_rflct1}, 35}
textEvents.action["psyshielddef"]	= {"\n@The psychic power shield\n`deflected ", {textFunc = textPsiName}, {func = textSound, args = sfx_rflct1}, "!", 18}
textEvents.action["psyshielddis"]	= {"\n@", {textFunc = textActionTarget}, "'s psychic shield made ", {textFunc = textPsiName}, " disappear!", 18}

textEvents.action["PSI2"]			= {{func = textSound, args = sfx_psi2}, "\n@", {textFunc = textActionUser}, " tried\n`", {textFunc = textPsiName}, "!", 18}

textEvents.psi = {}
textEvents.psi["brainshockA"]		= {10,{func=textStartAnim,args={2,false}},{func=textSound,args=sfx_brain1},10,{func=textStartAnim,args={47,true}},38}
textEvents.psi["defdownA"]			= {{func=textStartAnim,args={5,false}},{func=textSound,args=sfx_paral1},24,{func=textStartAnim,args={39,true}},60}
textEvents.psi["fireA"]				= {{func=textStartAnim,args={7,false}},{func = textSound,args=sfx_fire1},17,{func = textSound,args=sfx_fire2},3,{func=textStartAnim,args={36,true}},18}
textEvents.psi["fireB"]				= {{func=textStartAnim,args={8,false}},{func = textSound,args=sfx_fire1},17,{func = textSound,args=sfx_fire2},14,{func = textSound,args=sfx_fire4},{func=textStartAnim,args={36,true}},18}
textEvents.psi["flashA"]			= {{func=textStartAnim,args={11,false}},{func = textSound,args=sfx_flash3},18}
textEvents.psi["freezeA"]			= {{func=textStartAnim,args={15,false}},{func = textSound,args=sfx_freez1},15,{func = textSound,args=sfx_freez2},10,{func=textStartAnim,args={41,true}},8,14}
textEvents.psi["freezeB"]			= {{func=textStartAnim,args={16,false}},{func = textSound,args=sfx_freez1},15,{func = textSound,args=sfx_freez2},10,{func=textStartAnim,args={41,true}},8,14}
textEvents.psi["speedA"]			= {{func=textStartAnim,args={19,false}},7,{func=textSound,args=sfx_storm1},22,{func=textSound,args=sfx_storm1},{func=textStartAnim,args={42,true}},24,{func=textSound,args=sfx_storm2}}
textEvents.psi["speedB"]			= {{func=textStartAnim,args={20,false}},{func=textSound,args=sfx_storm1},23,{func=textSound,args=sfx_storm1},20,{func=textSound,args=sfx_storm3},{func=textStartAnim,args={42,true}},20,{func=textSound,args=sfx_storm3},16,{func=textSound,args=sfx_storm2}}
textEvents.psi["paralysisA"]		= {{func=textStartAnim,args={23,false}},{func=textSound,args=sfx_paral1},36,{func=textStartAnim,args={43,true}},42}
textEvents.psi["paralysisO"]		= {{func=textStartAnim,args={24,false}},{func=textSound,args=sfx_paral2},36,{func=textStartAnim,args={43,true}},42}
textEvents.psi["magnetA"]			= {{func=textStartAnim,args={25,false}},{func=textSound,args=sfx_magnet},30,{func=textStartAnim,args={44,true}},34}
textEvents.psi["magnetO"]			= {{func=textStartAnim,args={26,false}},{func=textSound,args=sfx_magnet},30,{func=textStartAnim,args={44,true}},20}
textEvents.psi["hypnosisA"]			= {{func=textStartAnim,args={28,false}},{func=textSound,args=sfx_hypnos},15,{func=textStartAnim,args={47,true}},18}
textEvents.psi["hypnosisO"]			= {{func=textStartAnim,args={29,false}},{func=textSound,args=sfx_hypnos},33,{func=textStartAnim,args={47,true}},18}
textEvents.psi["thunderA"]			= {{func=textStartAnim,args={33,false}},{func=textStartAnim,args={46,true}},{func=textSound,args=sfx_thndr1},11,{func=textSound,args=sfx_thndr2},15}
textEvents.psi["shieldA"]			= {{func=textStartAnim,args={50,true}},{func=textSound,args=sfx_shld1},42}
textEvents.psi["shieldB"]			= {{func=textStartAnim,args={51,true}},{func=textSound,args=sfx_shld1},42}
textEvents.psi["psishieldA"]		= {{func=textStartAnim,args={52,true}},{func=textSound,args=sfx_shld2},42}

textEvents.action["youwon"]			= {{func = textMusic, args = "RWIN"}, "\n```````\128\n", 120}
textEvents.action["bosswon"]		= {{func = textMusic, args = "BWIN"}, "\n```````\128\n", 120}

textEvents.status = {}
textEvents.status["diamondized"]	= {"\n@", {textFunc = textActionTarget}, "'s was\n`diamondized!", {func = textSound, args = sfx_ailed}, 18}
textEvents.status["diamondcured"]	= {"\n@", {textFunc = textActionTarget}, "'s body\n`returned to normal!", {func = textSound, args = sfx_heal}, 18}

textEvents.status["paralysis"]		= {"\n@", {textFunc = textActionTarget}, "'s body\n`became numb!", {func = textSound, args = sfx_ailed}, 18}
textEvents.status["numbcantmove"]	= {"\n@", {textFunc = textActionUser}, "'s body is\n`numb and ", {textFunc = textUserGender1}, " can't move!", 18}
textEvents.status["paralysiscured"]	= {"\n@", {textFunc = textActionTarget}, "'s numbness is gone!", {func = textSound, args = sfx_heal}, 18}

textEvents.status["nausea"]			= {"\n@", {textFunc = textActionTarget}, " felt\n`somewhat nauseous...", {func = textSound, args = sfx_ailed}, 18}
textEvents.status["nauseadamage"]	= {"\n@", {textFunc = textActionUser}, " felt sick\n`and took ", {textFunc = textNumber}, " HP damage!", 18}
textEvents.status["nauseacured"]	= {"\n@", {textFunc = textActionTarget}, " felt much better!", {func = textSound, args = sfx_heal}, 18}

textEvents.status["poisoned"]		= {"\n@", {textFunc = textActionTarget}, " got\n`poisoned!", {func = textSound, args = sfx_ailed}, 18}
textEvents.status["poisondamage"]	= {"\n@", {textFunc = textActionUser}, " felt pain\n`from the poison", 18, "\n`and took ", {textFunc = textNumber}, " HP damage.", 18}
textEvents.status["poisoncured"]	= {"\n@The poison was removed from\n`", {textFunc = textActionTarget}, "'s body!", {func = textSound, args = sfx_heal}, 18}

textEvents.status["sunstrokedmg"]	= {"\n@", {textFunc = textActionUser}, " felt dizzy\n`and weak and received ", {textFunc = textNumber}, " HP damage!", 18}
textEvents.status["sunstrokecure"]	= {"\n@", {textFunc = textActionTarget}, "'s\n`sunstroke was cured!", {func = textSound, args = sfx_heal}, 18}

textEvents.status["cold"]			= {"\n@", {textFunc = textActionTarget}, " caught a cold!", {func = textSound, args = sfx_ailed}, 18}
textEvents.status["colddamage"]		= {"\n@", {textFunc = textActionUser}, " sneezed\n`and received ", {textFunc = textNumber}, " HP damage!", 18}
textEvents.status["coldcured"]		= {"\n@", {textFunc = textActionTarget}, " got over\n`the cold!", {func = textSound, args = sfx_heal}, 18}

textEvents.status["sleep"]			= {"\n@", {textFunc = textActionTarget}, " fell\n`asleep!", {func = textSound, args = sfx_ailed}, 18}
textEvents.status["fallenasleep"]	= {"\n@", {textFunc = textActionUser}, " has\n`fallen asleep!", 18}
textEvents.status["wokeup"]			= {"\n@", {textFunc = textActionTarget}, " woke up!", {func = textSound, args = sfx_heal}, 18}

textEvents.status["crying"]			= {"\n@", {textFunc = textActionTarget}, " could not\n`stop crying!", {func = textSound, args = sfx_ailed}, 18}
textEvents.status["stopcrying"]		= {"\n@", {textFunc = textActionTarget}, " finally\n`stopped crying...", {func = textSound, args = sfx_heal}, 18}

textEvents.status["immobilized"]	= {"\n@", {textFunc = textActionTarget}, " suddenly could not move!", {func = textSound, args = sfx_ailed}, 18}
textEvents.status["cantmovearound"]	= {"\n@", {textFunc = textActionUser}, " cannot\n`move around!", 18}
textEvents.status["movedfreely"]	= {"\n@", {textFunc = textActionTarget}, "'s body again\n`moved freely!", {func = textSound, args = sfx_heal}, 18}

textEvents.status["solidified"]		= {"\n@", {textFunc = textActionTarget}, "'s body\n`solidified", {func = textSound, args = sfx_ailed}, 18}
textEvents.status["abletomove"]		= {"\n@", {textFunc = textActionTarget}, " was\n`able to move!", {func = textSound, args = sfx_heal}, 18}

textEvents.status["feelstrange"]	= {"\n@", {textFunc = textActionTarget}, " felt\n`a little strange...", {func = textSound, args = sfx_ailed}, 18}
textEvents.status["actunusual"]		= {"\n@", {textFunc = textActionUser}, " is acting\n`a bit unusual.", 18}
textEvents.status["backtonormal"]	= {"\n@", {textFunc = textActionTarget}, " went\n`back to normal!", {func = textSound, args = sfx_heal}, 18}

textEvents.status["cconcentrate"]	= {"\n@", {textFunc = textActionTarget}, " was\n`not able to concentrate!", {func = textSound, args = sfx_ailed}, 18}
textEvents.status["aconcentrate"]	= {"\n@", {textFunc = textActionUser}, " was\n`able to concentrate!", {func = textSound, args = sfx_heal}, 18}

textEvents.die = {}
textEvents.die["allydie"]			= {"\n@", {textFunc = textActionTarget}, " got hurt and collapsed...",{func = textSound, args = sfx_adie}, 18}
textEvents.die["defeated"]			= {"\n@", {textFunc = textActionTarget}, " was defeated!", {func = textSound, args = sfx_edie}, {func = textEnemyDying}, 18}
textEvents.die["stopped"]			= {"\n@", {textFunc = textActionTarget}, " stopped moving!", {func = textSound, args = sfx_edie}, {func = textEnemyDying}, 18}
textEvents.die["tame"]				= {"\n@", {textFunc = textActionTarget}, " became tame!", {func = textSound, args = sfx_edie}, {func = textEnemyDying}, 18}
textEvents.die["defeated"]			= {"\n@", {textFunc = textActionTarget}, " disappeared!", {func = textSound, args = sfx_edie}, {func = textEnemyDying}, 18}
textEvents.die["melted"]			= {"\n@The figure of", {textFunc = textActionTarget}, " melted into thin air!", {func = textSound, args = sfx_edie}, {func = textEnemyDying}, 18}
textEvents.die["broken"]			= {"\n@", {textFunc = textActionTarget}, " was broken into pieces!", {func = textSound, args = sfx_edie}, {func = textEnemyDying}, 18}
textEvents.die["destroyed"]			= {"\n@", {textFunc = textActionTarget}, " was destroyed!", {func = textSound, args = sfx_edie}, {func = textEnemyDying}, 18}
textEvents.die["scrapped"]			= {"\n@", {textFunc = textActionTarget}, " was totally scrapped!", {func = textSound, args = sfx_edie}, {func = textEnemyDying}, 18}
textEvents.die["normal"]			= {"\n@", {textFunc = textActionTarget}, " turned back to normal!", {func = textSound, args = sfx_edie}, {func = textEnemyDying}, 18}
textEvents.die["dustearth"]			= {"\n@", {textFunc = textActionTarget}, " returned to the dust of the earth!", {func = textSound, args = sfx_edie}, {func = textEnemyDying}, 18}

textEvents.die["memory"]			= {"\n@ In memory of ", {textFunc = textActionTarget}, {func = textSound, args = sfx_edie}, {func = textEnemyDying}, 18}

textEvents.die["lostbattle"]		= {5, {func = textMusic, args = "BLOST"}, "\n@", {textFunc = textPartyName, args = 1}, " lost the battle...", 35}



-- player is needed to run the functions
local function getTextDuration(player, textEvent)
	local duration = 0
	local eventType
	local buildStr = ""
	local tempStr
	for i=1,#textEvent,1 do
		eventType = type(textEvent[i])
		if eventType == "string" then
			buildStr = buildStr .. textEvent[i]
			duration = duration + #textEvent[i]
		elseif eventType == "number" then
			duration = duration + textEvent[i]
		elseif eventType == "table" then
			if textEvent[i].textFunc then
				tempStr = textEvent[i].textFunc(player, textEvent[i].args)
				buildStr = buildStr .. tempStr
				duration = duration + #tempStr
			elseif textEvent[i].func then
				duration = duration + 1
			end
		end
	end
	
	if select(2, getFontWidthEB(buildStr, "EBRFN", 0)) < #buildStr then
		-- A ` is added after the newline character
		duration = duration + 1
	end
	return duration
end

local function getTextEvent(major, minor)
	if not textEvents[major][minor] then
		print("GetTextEvent(): Invalid text event")
		return nil
	end
	return textEvents[major][minor]
end

-- Generate the text that will be added for the event before it's added
-- Don't generate the text again and again each frame -.-
-- Basically copies what is in the stored textEvent, but runs the textFuncs to
-- Get their results
local function playerGenerateText(player, textEvent)
	local textBox = player.bother.textBox
	local sectionType
	local tempString
	local currentWidth = 0
	local tempFindSpace
	local tooLongPos
	
	textBox.textEvent = {}
	-- loop through the parts of the textEvent, if the pos is currently less
	-- than where that part ends, then we need to add how long it takes to get
	-- there
	for i=1,#textEvent,1 do
		sectionType = type(textEvent[i])
		if sectionType == "string" or (sectionType == "table" and textEvent[i].textFunc) then
			if sectionType == "string" then
				tempString = textEvent[i]
			else
				tempString = textEvent[i].textFunc(player, textEvent[i].args)
			end
			currentWidth, tooLongPos = getFontWidthEB(tempString, "EBRFN", currentWidth)
			while tooLongPos < #tempString do
				tempFindSpace = string.find(string.reverse(tempString), " ", #tempString-tooLongPos)
				if tempFindSpace ~= nil then
					tooLongPos = #tempString - tempFindSpace + 1
				else
					tooLongPos = 0
				end
				-- + 1 to get rid of the space that is there
				tempString = string.sub(tempString, 1, max(tooLongPos-1, 0)) .. "\n`" .. string.sub(tempString, tooLongPos + 1)
				currentWidth, tooLongPos = getFontWidthEB(tempString, "EBRFN", 0)
			end
			table.insert(textBox.textEvent, tempString)
		else
			table.insert(textBox.textEvent, textEvent[i])
		end
	end
	
	textBox.textEventEnd = getTextDuration(player, textBox.textEvent)
end

-- add the latest character to the current text
-- run any functions that should be run
local function playerRunText(player)
	local textBox = player.bother.textBox
	local eventType
	local checkPos = 0
	for j=1,2,1 do -- 2 letters per frame
		checkPos = 0
		for i=1,#textBox.textEvent,1 do
			eventType = type(textBox.textEvent[i])
			if eventType == "string" then
				checkPos = checkPos + #textBox.textEvent[i]
			elseif eventType == "number" then
				checkPos = checkPos + textBox.textEvent[i]
			elseif eventType == "table" then
				-- It IS a func, should be NO textfunc now
				checkPos = checkPos + 1
				if checkPos == textBox.textEventPos then
					textBox.textEvent[i].func(player, textBox.textEvent[i].args)
				end
			end
			if checkPos >= textBox.textEventPos then
				if eventType == "string" then
					local getIndex = textBox.textEventPos - checkPos + #textBox.textEvent[i]
					textBox.curText = textBox.curText .. string.sub(textBox.textEvent[i], getIndex, getIndex)
				end
				break
			end
		end
		
		-- each frame the text event continues
		textBox.textEventPos = textBox.textEventPos + 1
		
		if eventType == "string" and textBox.npc and leveltime % 3 == 0 and j == 1 then
			S_StartSound(nil, sfx_talked, player)
		end
		
		if eventType == "table" or eventType == "number" or textBox.textEventPos > textBox.textEventEnd then
			return
		end
	end
end

-- If there's more than 2 lines the first is deleted
local function playerCleanText(player)
	local textBox = player.bother.textBox
	if string.sub(textBox.curText, 1, 1) == "\n" then
		-- If the first character is \n there's a blank line we don't need
		textBox.curText = string.sub(textBox.curText, 2)
	end
	textBox.curText = string.gsub(textBox.curText, ".*\n(.*\n)", "%1")
end

local function playerTextThink(player)
	local bother = player.bother
	local textBox = bother.textBox
	
	if not textBox.active then
		return
	end
	
	player.mo.momx = 0
	player.mo.momy = 0
	player.mo.momz = 0
	
	if textBox.textEvent then
		playerRunText(player)
		playerCleanText(player)
		-- we have a current text event.. so go through that
		-- this text event is over
		if textBox.textEventPos > textBox.textEventEnd then
			textBox.textEventPos = 0
			if bother.battle.actions and bother.battle.actions[1] then
				if bother.battle.actions[1].subactions[1] then
					table.remove(bother.battle.actions[1].subactions, 1)
				end
				if not bother.battle.actions[1].subactions[1] then
					table.remove(bother.battle.actions, 1)
					bother.textBox.curText = ""
				end
			end
			textBox.textEvent = nil
			textBox.active = false
		end
	end
end

rawset(_G, "getTextEvent", getTextEvent)
rawset(_G, "playerGenerateText", playerGenerateText)
rawset(_G, "playerTextThink", playerTextThink)
