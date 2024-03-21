// ----------------------------
// Lua_Puyo
// *insert description here*
// ----------------------------
// TODO:
// 		Add a proper character select screen
//		Add more cut-ins
// ----------------------------
// BUGS:
// Fever collision with walls
// ----------------------------
// 2 OR MORE PLAYERS REQUIREMENT IS CURRENTLY DISABLED, SHOULD BE RE-ENABLED

local puyodebug = false	// Allows seeing puyo when paused

local menudead = 15

freeslot(
// Menus, etc.
"sfx_menu1p", "sfx_menu2p", "sfx_menu3p", "sfx_level", "sfx_ppgo", "sfx_ppwin", "sfx_pplose",
// Puyos
"sfx_pmove", "sfx_prot",				// Puyo manipulation
"sfx_pplace", "sfx_ppop1", "sfx_ppop2", "sfx_ppop3", "sfx_ppop4", "sfx_ppop5", "sfx_ppop6", "sfx_ppop7",	// Placement and popping
"sfx_trash1", "sfx_trash2",				// Garbage Puyo
"sfx_clear")							// All clear

// Used for continue screen... I think?
local CONTINUERATE = 40

// Stage music options (can be any string)
local stagemusic = {}
stagemusic[1] = "THEME"
stagemusic[2] = "AREAA"
stagemusic[3] = "STICKR"
stagemusic[4] = "LAST"
stagemusic[5] = "FINAL"

// Stage characters
local stagecharacters = {}
stagecharacters[1] = 5
stagecharacters[2] = 6
stagecharacters[3] = 3
stagecharacters[4] = 2
stagecharacters[5] = 4

// ------------------------------------
// Customization options!
// ------------------------------------
// Skin options
local skindata = {}
// Classic
skindata[0] = {}
skindata[0].prefix = "C"		// Prefix to identify the skin. I.E. CGRPUYO1 would be a classic green puyo
skindata[0].name = "Classic"
skindata[0].hasanims = true
skindata[0].hascarbuncle = true
skindata[0].hires = false
skindata[0].garbhires = false
skindata[0].scale = FRACUNIT
// Sun
skindata[1] = {}
skindata[1].prefix = "S"
skindata[1].name = "Sun"
skindata[1].hasanims = true
skindata[1].hascarbuncle = true
skindata[1].hires = false
skindata[1].garbhires = false
skindata[1].scale = FRACUNIT
// Fever
skindata[2] = {}
skindata[2].prefix = "F"
skindata[2].name = "Fever"
skindata[2].hasanims = false
skindata[2].hascarbuncle = false
skindata[2].hires = true
skindata[2].garbhires = false
skindata[2].scale = FRACUNIT/2
// Aqua
skindata[3] = {}
skindata[3].prefix = "A"
skindata[3].name = "Aqua"
skindata[3].hasanims = false
skindata[3].hascarbuncle = false
skindata[3].hires = true
skindata[3].garbhires = true
skindata[3].scale = FRACUNIT/4
// Gummy
skindata[4] = {}
skindata[4].prefix = "G"
skindata[4].name = "Gummy"
skindata[4].hasanims = false
skindata[4].hascarbuncle = false
skindata[4].hires = true
skindata[4].garbhires = true
skindata[4].scale = FRACUNIT/4
// Mean Bean (Mania)
skindata[5] = {}
skindata[5].prefix = "B"
skindata[5].name = "Mania"
skindata[5].hasanims = false
skindata[5].hascarbuncle = false
skindata[5].hires = false
skindata[5].garbhires = false
skindata[5].scale = FRACUNIT

local numskins = 6
rawset(_G, "PP_AddSkin", function(skin)
	skindata[numskins] = skin
	numskins = $1 + 1
end)

// Music options
local musicoptions = {}
musicoptions[0] = {}
musicoptions[0].musicslot = "THEME"
musicoptions[0].name = "Theme of Puyo Puyo"
musicoptions[1] = {}
musicoptions[1].musicslot = "STICKR"
musicoptions[1].name = "Sticker of Puyo Puyo"
musicoptions[2] = {}
musicoptions[2].musicslot = "AREAA"
musicoptions[2].name = "Area A"
musicoptions[3] = {}
musicoptions[3].musicslot = "LAST"
musicoptions[3].name = "Last Area"
musicoptions[4] = {}
musicoptions[4].musicslot = "FINAL"
musicoptions[4].name = "Final of Puyo Puyo"
musicoptions[5] = {}
musicoptions[5].musicslot = "MEANBM"
musicoptions[5].name = "Theme of Puyo Puyo (Mean Bean Machine)"
musicoptions[6] = {}
musicoptions[6].musicslot = "15THM"
musicoptions[6].name = "Theme of Puyo Puyo (15th Anniversary)"
local fevermusicoptions = {}
fevermusicoptions[0] = {}
fevermusicoptions[0].musicslot = "FEVER"
fevermusicoptions[0].name = "Fever (Puyo Puyo Fever)"
fevermusicoptions[1] = {}
fevermusicoptions[1].musicslot = "FVR15"
fevermusicoptions[1].name = "Fever (Puyo Puyo! 15th Anniversary)"
local nummusictracks = 7
local numfevermusictracks = 2

// Backgrounds
local backgrounds = {}
backgrounds[0] = "PUYO"	// BG + this + nothing/A/B = the background's patches. Up to 5 characters
backgrounds[1] = "TSUU"
backgrounds[2] = "FEVER"
backgrounds[3] = "TETO"
backgrounds[4] = "MANIA"

local numbackgrounds = 5

// ------------------------------------
// Board constants
// ------------------------------------
// Ideally, size be stored in the board itself, so it could be variable, like transformation... Oh well
local boardwidth = 6
local boardheight = 17	// Top 5 rows are invisible, top 3 rows are unusable, except for garbage. Garbage at the top 3 rows will be removed when the player gets to place more puyo.
local bufferrows = 5	// Number of buffer rows, they're invisible, above the actual board
local garbagerows = 3	// Number of rows that puyo cant be placed on, and any puyo in it will be deleted when the player can place more puyo.
local numeffects = 64	// Number of effects (puyo popping)
// Squishy puyo!
// Works based on an angle for each column, the sin of that * squishsinmul = the squishyness
local squishsinmul = FRACUNIT*60	// FRACUNIT = Pixel, multiply this by the sin of the squish. Then multiplied by number of puyo in the column/12
local squishanglespeed = FRACUNIT*15	// add this to the squish angle
local squishangle = 40*FRACUNIT			// In FRACUNIT, what angle from 90 the squish angle needs to be to display the squished sprite

local normalfallspeed = FRACUNIT*10/17
local flashtime = TICRATE/2

local fasttime = TICRATE/15

local rotatespeed = FRACUNIT*25

local flashtime = TICRATE/2
local mulpoptime = TICRATE/12
local feverpoptime = TICRATE/4
local fevermodepoptime = TICRATE/8

local effecttime = TICRATE/2

local mininput = 17		// Deadzone

local diacutetime = TICRATE*10/70

local scoretimer = TICRATE*3/2

local starttime = TICRATE*3

local losevoicetimer = TICRATE

local GARBUNIT = FRACUNIT/4		// FRACUNIT is too high precision for garbage calculation with a 32-bit int

local cutintime = TICRATE

local feverenterdelay = TICRATE*2/3
local fevernextdelay = TICRATE/2

local showboard	= true

local feverswitchtime = TICRATE/2

local chainefftime = TICRATE*2/3
local chaineffflashtime = chainefftime-TICRATE/3

// Garbage/score stuff
// Information from puyo nexus
local chainpower = {}
chainpower[0] = 0		// 1 Chain
chainpower[1] = 8		// 2 Chain
chainpower[2] = 16		// 3 Chain
chainpower[3] = 32		// 4 Chain
chainpower[4] = 64		// 5 Chain
chainpower[5] = 92		// 6 Chain
chainpower[6] = 128		// 7 Chain
chainpower[7] = 160		// 8 Chain
chainpower[8] = 192		// 9 Chain
chainpower[9] = 224		// 10 Chain
chainpower[10] = 256	// 11 Chain
chainpower[11] = 288	// 12 Chain
chainpower[12] = 320	// 13 Chain
chainpower[13] = 352	// 14 Chain
chainpower[14] = 384	// 15 Chain
chainpower[15] = 416	// 16 Chain
chainpower[16] = 448	// 17 Chain
chainpower[17] = 480	// 18 Chain
chainpower[18] = 512	// 19 Chain (Last possible chain)
chainpower[19] = 544	// 20 Chain
chainpower[20] = 576	// 21 Chain
chainpower[21] = 608	// 22 Chain
chainpower[22] = 640	// 23 Chain
chainpower[23] = 672	// 24 Chain

// Note: This is based on Arle's fever chain power in Fever 1
// Prooobably should put this in Lua_Characters... Along with unique ones for each character
local chainpowerfever = {}
chainpowerfever[0] = 4		// 1 Chain
chainpowerfever[1] = 12		// 2 Chain
chainpowerfever[2] = 24		// 3 Chain
chainpowerfever[3] = 33		// 4 Chain
chainpowerfever[4] = 50		// 5 Chain
chainpowerfever[5] = 101	// 6 Chain
chainpowerfever[6] = 169	// 7 Chain
chainpowerfever[7] = 254	// 8 Chain
chainpowerfever[8] = 341	// 9 Chain
chainpowerfever[9] = 428	// 10 Chain
chainpowerfever[10] = 538	// 11 Chain
chainpowerfever[11] = 648	// 12 Chain
chainpowerfever[12] = 763	// 13 Chain
chainpowerfever[13] = 876	// 14 Chain
chainpowerfever[14] = 990	// 15 Chain
chainpowerfever[15] = 999	// 16 Chain
chainpowerfever[16] = 999	// 17 Chain
chainpowerfever[17] = 999	// 18 Chain
chainpowerfever[18] = 999	// 19 Chain (Last possible chain)
chainpowerfever[19] = 999	// 20 Chain
chainpowerfever[20] = 999	// 21 Chain
chainpowerfever[21] = 999	// 22 Chain
chainpowerfever[22] = 999	// 23 Chain
chainpowerfever[23] = 999	// 24 Chain

local chainpowerfevermode = {}
chainpowerfevermode[0] = 4		// 1 Chain
chainpowerfevermode[1] = 10		// 2 Chain
chainpowerfevermode[2] = 18		// 3 Chain
chainpowerfevermode[3] = 21		// 4 Chain
chainpowerfevermode[4] = 29		// 5 Chain
chainpowerfevermode[5] = 46		// 6 Chain
chainpowerfevermode[6] = 76		// 7 Chain
chainpowerfevermode[7] = 113	// 8 Chain
chainpowerfevermode[8] = 150	// 9 Chain
chainpowerfevermode[9] = 223	// 10 Chain
chainpowerfevermode[10] = 259	// 11 Chain
chainpowerfevermode[11] = 266	// 12 Chain
chainpowerfevermode[12] = 313	// 13 Chain
chainpowerfevermode[13] = 364	// 14 Chain
chainpowerfevermode[14] = 398	// 15 Chain
chainpowerfevermode[15] = 432	// 16 Chain
chainpowerfevermode[16] = 468	// 17 Chain
chainpowerfevermode[17] = 504	// 18 Chain
chainpowerfevermode[18] = 540	// 19 Chain (Last possible chain)
chainpowerfevermode[19] = 576	// 20 Chain
chainpowerfevermode[20] = 612	// 21 Chain
chainpowerfevermode[21] = 648	// 22 Chain
chainpowerfevermode[22] = 684	// 23 Chain
chainpowerfevermode[23] = 720	// 24 Chain

// Puyo Puyo 1 chain power
local chainpowerpuyo = {}
chainpowerpuyo[0] = 0		// 1 Chain
chainpowerpuyo[1] = 8		// 2 Chain
chainpowerpuyo[2] = 16		// 3 Chain
chainpowerpuyo[3] = 32		// 4 Chain
chainpowerpuyo[4] = 64		// 5 Chain
chainpowerpuyo[5] = 128		// 6 Chain
chainpowerpuyo[6] = 256		// 7 Chain
chainpowerpuyo[7] = 512		// 8 Chain
chainpowerpuyo[8] = 999		// 9 Chain
chainpowerpuyo[9] = 999		// 10 Chain
chainpowerpuyo[10] = 999	// 11 Chain
chainpowerpuyo[11] = 999	// 12 Chain
chainpowerpuyo[12] = 999	// 13 Chain
chainpowerpuyo[13] = 999	// 14 Chain
chainpowerpuyo[14] = 999	// 15 Chain
chainpowerpuyo[15] = 999	// 16 Chain
chainpowerpuyo[16] = 999	// 17 Chain
chainpowerpuyo[17] = 999	// 18 Chain
chainpowerpuyo[18] = 999	// 19 Chain (Last possible chain)
chainpowerpuyo[19] = 999	// 20 Chain
chainpowerpuyo[20] = 999	// 21 Chain
chainpowerpuyo[21] = 999	// 22 Chain
chainpowerpuyo[22] = 999	// 23 Chain
chainpowerpuyo[23] = 999	// 24 Chain

local colorbonus = {}
colorbonus[0] = 0		// 1 color cleared
colorbonus[1] = 3		// 2 colors cleared
colorbonus[2] = 6		// 3 colors cleared
colorbonus[3] = 12		// 4 colors cleared
colorbonus[4] = 24		// 5 colors cleared
colorbonus[5] = 48		// 6 colors cleared (useless)

local colorbonusfever = {}
colorbonusfever[0] = 0		// 1 color cleared
colorbonusfever[1] = 2		// 2 colors cleared
colorbonusfever[2] = 4		// 3 colors cleared
colorbonusfever[3] = 8		// 4 colors cleared
colorbonusfever[4] = 16		// 5 colors cleared
colorbonusfever[5] = 32		// 6 colors cleared (not in fever)

local groupbonus = {}	// Add these for every group that was cleared, i.e. two groups of 5 will be 4 in total
groupbonus[0] = 0		// 4 puyo in the group (3 if minimum requirement is 3)
groupbonus[1] = 2		// 5 (4 if minimum is 3)
groupbonus[2] = 3		// 6 (5, etc.)
groupbonus[3] = 4		// 7 (doesn't apply if the minimum is greater than 4, it'll start at 4 anyway)
groupbonus[4] = 5		// 8
groupbonus[5] = 6		// 9
groupbonus[6] = 7		// 10
groupbonus[7] = 10		// 11+

local groupbonusfever = {}
groupbonusfever[0] = 0		// 4
groupbonusfever[1] = 1		// 5
groupbonusfever[2] = 2		// 6
groupbonusfever[3] = 3		// 7
groupbonusfever[4] = 4		// 8
groupbonusfever[5] = 5		// 9
groupbonusfever[6] = 6		// 10
groupbonusfever[7] = 8		// 11+

local function CalculateScoreBonus(puyocleared, chain, colorscleared, groupscleared, scorerules, fever)
	local totalgroupbonus = 0
	local gnum = 0
	while not(groupscleared[gnum] == nil)
		local group = groupscleared[gnum]
		if(group > 7)
			group = 7
		end
		if(scorerules == 1)
			totalgroupbonus = $1 + groupbonusfever[group]
		else
			totalgroupbonus = $1 + groupbonus[group]
		end
		gnum = $1 + 1
	end
	local chain2 = chain
	if(chain2 > 23)
		chain2 = 23
	end
	local secondhalf = (chainpower[chain2] + colorbonus[colorscleared-1] + totalgroupbonus)
	if(scorerules == 1)
		// Note: This should technically have seperate attack powers for each character... but I'm lazy
		secondhalf = (chainpowerfever[chain2] + colorbonusfever[colorscleared-1] + totalgroupbonus)
	elseif(scorerules == 2)
		secondhalf = (chainpowerpuyo[chain2] + colorbonus[colorscleared-1] + totalgroupbonus)
	end
	if(secondhalf < 1)
		secondhalf = 1
	elseif(secondhalf > 999)
		secondhalf = 999
	end
	return (10*puyocleared) * secondhalf
end

local function CalculateGarbage(chainscore, board)
	local garbagepoints = ((chainscore*GARBUNIT)/board.targetpoints)+board.leftovergarbage
	local returnvalue = garbagepoints/GARBUNIT							// Garbage to send, rounded down
	board.leftovergarbage = garbagepoints - (returnvalue*GARBUNIT)		// Left over garbage points
//	if(board.leftovergarbage < 0)
//		print("what")
//	end
	if(returnvalue < 1)
		returnvalue = 1		// Always send at least 1 garbage!... seems to be how its meant to work, anyway
	end
	return returnvalue
end

local fevercolors = {}	// Used for drawing the board in fever mode, has no impact on gameplay whatsoever
fevercolors[0] = 31
// Red
fevercolors[1] = 47
fevercolors[2] = 46
fevercolors[3] = 71
fevercolors[4] = 45
fevercolors[5] = 71
fevercolors[6] = 46
fevercolors[7] = 47
fevercolors[8] = 31
// Green
fevercolors[9] = 119
fevercolors[10] = 119
fevercolors[11] = 118
fevercolors[12] = 117
fevercolors[13] = 118
fevercolors[14] = 119
fevercolors[15] = 119
fevercolors[16] = 31
// Blue
fevercolors[17] = 254
fevercolors[18] = 253
fevercolors[19] = 159
fevercolors[20] = 158
fevercolors[21] = 159
fevercolors[22] = 253
fevercolors[23] = 254
// Yellow
fevercolors[24] = 237
fevercolors[25] = 79
fevercolors[26] = 78
fevercolors[27] = 77
fevercolors[28] = 78
fevercolors[29] = 79
fevercolors[30] = 237
// Purple
fevercolors[31] = 187
fevercolors[32] = 187
fevercolors[33] = 186
fevercolors[34] = 186
fevercolors[35] = 186
fevercolors[36] = 187
fevercolors[37] = 187
local numfevercolors = 38

local puyorules = {}
puyorules.fever = false
puyorules.dropsets = false
puyorules.voicepattern = 2
puyorules.garbagerules = 2
puyorules.scorerules = 2
puyorules.allclearrules = 2
puyorules.targetpoints = 70
puyorules.margintime = 96

local tsuurules = {}
tsuurules.fever = false
tsuurules.dropsets = false
tsuurules.voicepattern = 0
tsuurules.garbagerules = 0
tsuurules.scorerules = 0
tsuurules.allclearrules = 0
tsuurules.targetpoints = 70
tsuurules.margintime = 96

local feverrules = {}
feverrules.fever = true
feverrules.dropsets = true
feverrules.voicepattern = 1
feverrules.garbagerules = 1
feverrules.scorerules = 1
feverrules.allclearrules = 1
feverrules.targetpoints = 120
feverrules.margintime = 128

local rulenames = {}
rulenames[0] = "Puyo Puyo"
rulenames[1] = "Puyo Puyo Tsuu"
rulenames[2] = "Puyo Puyo Fever"
rulenames[3] = "Custom"

local rulepropnames = {}
rulepropnames[0] = "Dropsets"
rulepropnames[1] = "Garbage rules"
rulepropnames[2] = "Score rules"
rulepropnames[3] = "All clear rules"
rulepropnames[4] = "Voice pattern"
rulepropnames[5] = "Fever mode"

local games = {}
games[0] = "Puyo Puyo Tsuu"
games[1] = "Puyo Puyo Fever"
games[2] = "Puyo Puyo"
games[3] = "Puyo Puyo Sun"

local ruledescriptions = {}
ruledescriptions[0] = "Orignal Puyo Puyo rules!\nLike Tsuu, but note that you\ncan't offset or get all clears."
ruledescriptions[1] = "Classic Puyo Puyo rules.\nMake chains to bury your opponent\nin garbage puyo!"
ruledescriptions[2] = "Fever rules.\nOffset garbage to enter fever mode\nfor large pre-made chains!"
ruledescriptions[3] = ""

local tiletype = 0
local tileinair = 1
local tilebottompiece = 2
local tilesquish = 3
local tileyoff = 4
local tilemomentum = 5
local tileremovetime = 6
local tilelookedfor = 7
local numtilestuff = 8

local function MakeTilesFromBoard(board, fever)
	local boardtiles = {}
	// Why are no pointers in lua
	if not(fever)
		local tnum = 0
		while(tnum < boardwidth*boardheight)
			local tnum2 = tnum*numtilestuff
			boardtiles[tnum] = {}
			boardtiles[tnum].type = board.tiles[tnum2+tiletype]
			boardtiles[tnum].inair = board.tiles[tnum2+tileinair]
			boardtiles[tnum].bottompiece = board.tiles[tnum2+tilebottompiece]
			boardtiles[tnum].squish = board.tiles[tnum2+tilesquish]
			boardtiles[tnum].yoff = board.tiles[tnum2+tileyoff]
			boardtiles[tnum].momentum = board.tiles[tnum2+tilemomentum]
			boardtiles[tnum].removetime = board.tiles[tnum2+tileremovetime]
			boardtiles[tnum].lookedfor = board.tiles[tnum2+tilelookedfor]
			tnum = $1 + 1
		end
	else
		local tnum = 0
		while(tnum < boardwidth*boardheight)
			local tnum2 = tnum*numtilestuff
			boardtiles[tnum] = {}
			boardtiles[tnum].type = board.fevertiles[tnum2+tiletype]
			boardtiles[tnum].inair = board.fevertiles[tnum2+tileinair]
			boardtiles[tnum].bottompiece = board.fevertiles[tnum2+tilebottompiece]
			boardtiles[tnum].squish = board.fevertiles[tnum2+tilesquish]
			boardtiles[tnum].yoff = board.fevertiles[tnum2+tileyoff]
			boardtiles[tnum].momentum = board.fevertiles[tnum2+tilemomentum]
			boardtiles[tnum].removetime = board.fevertiles[tnum2+tileremovetime]
			boardtiles[tnum].lookedfor = board.fevertiles[tnum2+tilelookedfor]
			tnum = $1 + 1
		end
	end
	return boardtiles
end

local function MakeBoardFromTiles(boardtiles, board, fever)
	// Why are no pointers in lua
	if not(fever)
		local tnum = 0
		while(tnum < boardwidth*boardheight)
			local tnum2 = tnum*numtilestuff
			board.tiles[tnum2+tiletype] = boardtiles[tnum].type
			board.tiles[tnum2+tileinair] = boardtiles[tnum].inair
			board.tiles[tnum2+tilebottompiece] = boardtiles[tnum].bottompiece
			board.tiles[tnum2+tilesquish] = boardtiles[tnum].squish
			board.tiles[tnum2+tileyoff] = boardtiles[tnum].yoff
			board.tiles[tnum2+tilemomentum] = boardtiles[tnum].momentum
			board.tiles[tnum2+tileremovetime] = boardtiles[tnum].removetime
			board.tiles[tnum2+tilelookedfor] = boardtiles[tnum].lookedfor
			tnum = $1 + 1
		end
	else
		local tnum = 0
		while(tnum < boardwidth*boardheight)
			local tnum2 = tnum*numtilestuff
			board.fevertiles[tnum2+tiletype] = boardtiles[tnum].type
			board.fevertiles[tnum2+tileinair] = boardtiles[tnum].inair
			board.fevertiles[tnum2+tilebottompiece] = boardtiles[tnum].bottompiece
			board.fevertiles[tnum2+tilesquish] = boardtiles[tnum].squish
			board.fevertiles[tnum2+tileyoff] = boardtiles[tnum].yoff
			board.fevertiles[tnum2+tilemomentum] = boardtiles[tnum].momentum
			board.fevertiles[tnum2+tileremovetime] = boardtiles[tnum].removetime
			board.fevertiles[tnum2+tilelookedfor] = boardtiles[tnum].lookedfor
			tnum = $1 + 1
		end
	end
end

local function InitBoard(player, colors, dropset, rules, spice)
	local board = {}

	// AI stuff
	board.trigger = nil		// Group that, when popped, sets off the chain
	board.extension = nil		// Group that will become the trigger when its finished being built
	board.extensioncolor = 0
	board.samecolorplaced = 0
	board.hasplacedyet = false
	board.hasunintellegentlyplaced = false
	board.haspopped = false

	board.state = 4			// 0 = placing, 1 = falling, 2 = looking for chains, 3 = popping, 4 = dropping trash
	if(spice < 2)
		board.colors = 0
	elseif(spice == 2)
		board.colors = 1		// 0 = 3, 1 = 4, 2 = 5
	else
		board.colors = 2
	end
	if(player.stagenum >= 4)
		board.colors = 2
	end
	board.colorslist = colors
	board.tiles = {}
/*	board.tilestype = {}
	board.tilesinair = {}
	board.tilesbottompiece = {}
	board.tilessquish = {}
	board.tilesyoff = {}
	board.tilesmomentum = {}
	board.tilesremovetime = {}
	board.tileslookedfor = {}*/
	local tnum = 0
	while(tnum < boardwidth*boardheight)
//		board.tiles[tnum] = {}
/*		board.tilestype[tnum] = 0			// 0 = Blank, 1 = Red, 2 = Green, 3 = Blue, 4 = Yellow, 5 = Purple, 6 = Garbage, 7 = Sun, 8 = block
		board.tilesinair[tnum] = false		// Only effects drawing in tsuu, but does slightly effect gameplay in fever.
		board.tilesbottompiece[tnum] = (boardwidth*boardheight)+(tnum%boardwidth)// Same as above.
		board.tilessquish[tnum] = 0		// Replacement for board.squish
		board.tilesyoff[tnum] = 0			// Used for floating puyo
		board.tilesmomentum[tnum] = 0		// Only used for split placed puyo
		board.tilesremovetime[tnum] = 0	// Frames to removal
		board.tileslookedfor[tnum] = false	// Used for finding chains*/
		local tnum2 = tnum*numtilestuff
		board.tiles[tnum2+tiletype] = 0
		board.tiles[tnum2+tileinair] = 0
		board.tiles[tnum2+tilebottompiece] = (boardwidth*boardheight)+(tnum%boardwidth)
		board.tiles[tnum2+tilesquish] = 0
		board.tiles[tnum2+tileyoff] = 0
		board.tiles[tnum2+tilemomentum] = 0
		board.tiles[tnum2+tileremovetime] = 0
		board.tiles[tnum2+tilelookedfor] = 0
		tnum = $1 + 1
	end
	tnum = 0
	if(rules.fever)
		board.fevertiles = {}
	/*	board.fevertilestype = {}
		board.fevertilesinair = {}
		board.fevertilesbottompiece = {}
		board.fevertilessquish = {}
		board.fevertilesyoff = {}
		board.fevertilesmomentum = {}
		board.fevertilesremovetime = {}
		board.fevertileslookedfor = {}*/
		while(tnum < boardwidth*boardheight)
	//		board.fevertiles[tnum] = {}
	/*		board.fevertilestype[tnum] = 0
			board.fevertilesinair[tnum] = false
			board.fevertilesbottompiece[tnum] = (boardwidth*boardheight)+(tnum%boardwidth)
			board.fevertilessquish[tnum] = 0
			board.fevertilesyoff[tnum] = 0
			board.fevertilesmomentum[tnum] = 0
			board.fevertilesremovetime[tnum] = 0
			board.fevertileslookedfor[tnum] = false*/
			local tnum2 = tnum*numtilestuff
			board.fevertiles[tnum2+tiletype] = 0
			board.fevertiles[tnum2+tileinair] = 0
			board.fevertiles[tnum2+tilebottompiece] = (boardwidth*boardheight)+(tnum%boardwidth)
			board.fevertiles[tnum2+tilesquish] = 0
			board.fevertiles[tnum2+tileyoff] = 0
			board.fevertiles[tnum2+tilemomentum] = 0
			board.fevertiles[tnum2+tileremovetime] = 0
			board.fevertiles[tnum2+tilelookedfor] = 0
			tnum = $1 + 1
		end
	else
		board.fevertiles = {}
	end
	board.effectstype = {}
	board.effectsx = {}
	board.effectsy = {}
	board.effectsxspeed = {}
	board.effectsyspeed = {}
	board.effectstimer = {}
	local enum = 0
	while(enum < numeffects)
	//	board.effects[enum] = {}
		board.effectstype[enum] = 0
		board.effectsx[enum] = 0
		board.effectsy[enum] = 0
		board.effectsxspeed[enum] = 0
		board.effectsyspeed[enum] = 0
		board.effectstimer[enum] = 0
		enum = $1 + 1
	end
	// Voice stuff
	board.voicepattern = rules.voicepattern		// 0 = Puyo Puyo Tsuu, 1 = Puyo Puyo Fever
	board.diacutes = 0			// Number of times to repeat the next voice
	board.prevdiacutes = 0
	board.diacutevoice = sfx_arles1	// Voice to repeat x times
	board.diacutetimer = 0		// If above 0, repeat board.diacutevoice
	board.lastmaxnumpopped = 0	// Last maximum number of puyo popped in a group (i.e. if there's 2 groups, one with 4 and one with 5, it'll be 5)
	board.lastnumgroups = 0		// Number of groups popped
	board.spelldone = false
	// Garbage
	board.garbagetray = 0		// Amount of garbage that will fall.
	board.extragarbage = {}		// Extra garbage that migh not fall yet. There's one for each board (yes, even your own, which is used in RPG Blast)
	board.extragarbage[0] = 0
	board.extragarbage[1] = 0
	board.extragarbage[2] = 0
	board.extragarbage[3] = 0

	board.fevergarbagetray = 0
	board.feverextragarbage = {}
	board.feverextragarbage[0] = 0
	board.feverextragarbage[1] = 0
	board.feverextragarbage[2] = 0
	board.feverextragarbage[3] = 0

	board.garbagesoundyet = false	// If true, don't play the garbage landing sound (resets every time)
	board.garbageplacetimer = 0		// Once this reaches specific intervals, drop garbage in each collumn.
	board.garbagehasdropped = false
	board.garbagedropsound = 0		// If 1, play the sound for 12 or more garbage puyo
	board.fevergarbagedelay = false	// If true, garbage wont fall
	board.garbagerules = rules.garbagerules			// If 1, points from holding down will not be added to your garbage remainder, and offsetting will prevent garbage from falling
	if not(board.garbagerules == 1)
		if(spice == 1)
			or(spice == 4)
			board.garbagetray = 12
		end
	end
	// Placing puyo
	board.dropspeedmul = FRACUNIT
	if(rules.scorerules)
		and(spice == 0)
		board.dropspeedmul = FRACUNIT*2/3
	end
	if(spice == 4)	// Hardest difficulty
		and(rules.scorerules)
		board.dropspeedmul = FRACUNIT*3/2
	end
	if(spice == 5)	// Even harder!
		board.dropspeedmul = FRACUNIT*18	// Always full drop speed!
	end
	if(player.stagenum == 2)
		board.dropspeedmul = FRACUNIT*3/2
	elseif(player.stagenum == 3)
		board.dropspeedmul = FRACUNIT*3
	elseif(player.stagenum == 4)
		board.dropspeedmul = FRACUNIT*5
	elseif(player.stagenum == 5)
		board.dropspeedmul = FRACUNIT*18
	end
	board.dropsets = rules.dropsets		// Allows for dropsets and creates 2 x's
	board.placingpuyoindex = 0	// Index that we're at in the puyo list
	board.dropsetindex = 0		// Index in the character's dropset
	board.ljswap = false		// If true, swap Ls and Js
	board.placingpuyo = ((bufferrows-1)*boardwidth)+2	// Position of the puyo being placed
	board.placingpuyocolor = {}						// Color of the puyo being placed
	board.placingpuyocolor[0] = player.puyolists[board.colors][0]
	board.placingpuyocolor[1] = player.puyolists[board.colors][1]
	board.placingpuyotype = 0						// Puyo formation. 0 = pair, 1 = L tall, 2 = L wide, 3 = J tall, 4 = J wide, 5 = quad, 6 = big
	if(board.dropsets)
		board.placingpuyotype = chardata[dropset].dropset[0]
	end
	board.placingpuyoyoffset = 0					// Y offset of the puyo being placed. Positive = up. In FRACUNIT
	board.placingpuyorotate = 1						// Increasing this goes counter clockwise. For double puyo, 0 = right
	board.placingpuyointendedrotate = 1				// Where the player "wants" the puyo to rotate
	board.placingpuyorotate2 = 90*FRACUNIT			// In FRACUNIT, the angle to draw the puyo at
	board.placingpuyorotatedir = false				// If true, rotate counter clockwise.
	board.placingpuyotouchedgroundtimer = 0			// How long the puyo have touched the ground in total
	board.placingpuyoshake = 0						// Used for animation
	board.placedpuyoprevonground = false			// Ditto
	board.placedsplit = false						// If true, use momentum for mid-air puyo
	board.justmoved = 0								// If 1, just moved right (place 8 pixels to the left), if 2, just moved to the left (opposite direcetion)
	board.unitstopoint = 0							// Increases by 1 every pixel the puyo move down every frame you hold down. 8 = 1 point
	tnum = 0
//	board.squish = {}
//	while(tnum < boardwidth)
//		board.squish[tnum] = 0		// If above 1, add squishsinmul. If above 180, reset to 0.
//		tnum = $1 + 1
//	end
	board.chain = 0
	board.flashtime = 0				// Counts down to 0, if above 0, any puyo with removetime set wont decrease their timer and will flash.
	board.panic = false				// Used for music
	board.sidemovetime = 0
	board.prevbuttons = 0
	board.prevsidemove = 0
	board.prevforwardmove = 0
	board.nexttime = 8				// If above 0, then move the next graphics down that much
	// Score!
	board.score = 0
	board.targetpoints = rules.targetpoints		// Points needed to spawn a garbage puyo
	board.leftovergarbage = 0		// Remainder of the garbage formula, in FRACUNIT
	board.scorehalf1 = 0			// For score display
	board.scorehalf2 = 0			// Ditto
	board.scoretimer = 0			// Ditto x2
	board.allclear = false
	board.allcleartimer = 0
	board.matchhasstarted = false
	board.lostyoff = 0
	board.scorerules = rules.scorerules			// 0 = Tsuu, 1 = Fever
	board.allclearrules = rules.allclearrules
	board.boardyoff = 0		// Adds this * -8 to height. Fakes puyo falling in fever
	// Fever
	board.fever = rules.fever
	board.fevertime = 15*FRACUNIT	// 1 FRACUNIT = 1 second for extra accuracy!
	board.fevermeter = 0
	board.fevermode = false			// If true, use fever tiles instead of normal tiles
	board.feverchain = 2			// 0 = 3, 12 = 15
	board.giveallclearbonus = true
	board.feverdelaytimer = 0		// If above 0, don't process the board
	board.fevervocietime = 0		// Frames untill fever sucess/failure voice plays. Doesn't count down if fever delay timer is above 0
	board.fevervoice = 0			// If 0, play sfx_arlef3, otherwise, sfx_arlef2
	board.playersinfever = {}		// Used for garbage
	board.playersinfever[0] = false
	board.playersinfever[1] = false
	board.playersinfever[2] = false
	board.playersinfever[3] = false
	board.feverswitchtime = 0	// If above 0, board isn't processed. Fever switch effect is applied
	// Last minute "x-chain!" text stuff
	board.chaineffectnumber = 0
	board.chaineffecttimer = 0
	board.chaineffectoriginpuyo = 0
	// Cut-ins
	board.cutin = 0
	board.cutintime = 0		// 1+ = display cut-in
	return board
end

// COMMANDS
/*COM_AddCommand("setpuyo", function(player, state)
	if(state == nil)
		return
	end
	local tostate = tonumber(state)
	if(tostate == nil)
		return
	end
	player.gamestate = tostate
	if(player.gamestate < -1)
		player.gamestate = -1
	elseif(player.gamestate >= 0)
		player.gamestate = 1
	end
end)

COM_AddCommand("garbage", function(player, num)
	if(num == nil or tonumber(num) == nil)
		return
	end
	player.boards[0].garbagetray = tonumber(num)
end)

COM_AddCommand("fever", function(player, num)
	if(num == nil or tonumber(num) == nil)
		return
	end
	player.boards[0].fevermeter = tonumber(num)
end)

COM_AddCommand("setchar", function(player, num, p)
	if(num == nil or tonumber(num) == nil)
		return
	end
	if(p == nil or tonumber(p) == nil)
		return
	end
	player.characters[tonumber(num)] = tonumber(p)
end)

COM_AddCommand("music", function(player, num)
	if(num == nil or tonumber(num) == nil)
		return
	end
	player.musicoption = tonumber(num)
end)

COM_AddCommand("numplayers", function(player, num)
	if(num == nil or tonumber(num) == nil)
		return
	end
	player.numplayers = tonumber(num)
end)*/

local function MakePuyoList(colors, numcolors)
	local p = 0
	local lists = {}
	lists.mainlist = {}
	lists.altlist = {}
	while(p < 256)
		local num = P_RandomRange(0, numcolors-1)
		lists.mainlist[p] = colors[num]
		lists.altlist[p] = colors[(num+1+(P_RandomByte()%(numcolors-1)))%numcolors]
		if(lists.mainlist[p] == lists.altlist[p])
		//	print("same color")
		end
		p = $1 + 1
	end
	return lists
end

local function PlaySoundActual(player, sound, voice)
	if(splitscreen)
		and(#player)
		return	// Don't play sounds twice!
	end
	if not(voice == nil)
		and(player.mo and player.mo.valid)

		local usestartvoice = chardata[voice].startvoice
		if(chardata[voice].engstartvoice)
			and(player.puyoenglish)
			usestartvoice = chardata[voice].engstartvoice
		end

		if(usestartvoice < 0)
			return
		end
		if(player.voiceobj == nil)
			player.voiceobj = {}
		end
		if not(player.voiceobj[voice] and player.voiceobj[voice].valid)
			player.voiceobj[voice] = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_GARGOYLE)
			player.voiceobj[voice].flags = $1|MF_NOCLIP|MF_NOCLIPTHING
			player.voiceobj[voice].flags = $1 & !MF_SOLID
			player.voiceobj[voice].flags2 = $1|MF2_DONTDRAW
		end
		P_SetOrigin(player.voiceobj[voice], player.mo.x, player.mo.y, player.mo.z)
		S_StopSound(player.voiceobj[voice])
		S_StartSound(player.voiceobj[voice], sound-sfx_arles+usestartvoice, player)
	else
		S_StartSound(nil, sound, player)
	end
end

local function PlaySound(player, sound, voice)
	if(splitscreen)
		and(#player)
		return	// Don't play sounds twice!
	end
	local cnum = 0
	while(cnum < 4)
		if not(player.clients[cnum] == -1)
			PlaySoundActual(players[player.clients[cnum]], sound, voice)
		end
		cnum = $1 + 1
	end
end

local function RestoreMusic(player)
	local cnum = 0
	while(cnum < 4)
		if not(player.clients[cnum] == -1)
			if(player.stagenum)
				S_ChangeMusic(stagemusic[player.stagenum], true, players[player.clients[cnum]])
			else
				S_ChangeMusic(musicoptions[players[player.clients[cnum]].musicoption].musicslot, true, players[player.clients[cnum]])
			end
		end
		cnum = $1 + 1
	end
end

local function StartGame(player, novoice)
	local totalwins = 0
	local wnum = 0
	while(wnum < 4)
		totalwins = $1 + player.wins[wnum]
		wnum = $1 + 1
	end
	if not(novoice)
		if not(totalwins)
			local cnum = 0
			while(cnum < 4)
				if not(player.clients[cnum] == -1)
					S_StopMusic(players[player.clients[cnum]])
					PlaySound(players[player.clients[cnum]], sfx_arles, player.characters[cnum])
				end
				cnum = $1 + 1
			end
		else
			RestoreMusic(player)
		end
	end
	// Randomize colors!
	local colors = {}
	colors[0] = P_RandomRange(0, 5-1)
	colors[1] = P_RandomRange(0, 5-1)
	colors[2] = P_RandomRange(0, 5-1)
	colors[3] = P_RandomRange(0, 5-1)
	colors[4] = P_RandomRange(0, 5-1)
	if(colors[1] == colors[0])
		colors[1] = ($1 + 1)%5
	end
	while(colors[2] == colors[0])
		or(colors[2] == colors[1])
		colors[2] = ($1 + 1)%5
	end
	while(colors[3] == colors[0])
		or(colors[3] == colors[1])
		or(colors[3] == colors[2])
		colors[3] = ($1 + 1)%5
	end
	while(colors[4] == colors[0])
		or(colors[4] == colors[1])
		or(colors[4] == colors[2])
		or(colors[4] == colors[3])
		colors[4] = ($1 + 1)%5
	end
	colors[0] = $1 + 1
	colors[1] = $1 + 1
	colors[2] = $1 + 1
	colors[3] = $1 + 1
	colors[4] = $1 + 1

	local rules = tsuurules
	if(player.rules == 0)
		rules = puyorules
	elseif(player.rules == 2)
		rules = feverrules
	elseif(player.rules == 3)
		rules = player.customrules
	end
	if(rules.fever)
		colors[0] = 1
		colors[1] = 2
		colors[2] = 3
		colors[3] = 4
		colors[4] = 5
	end

	// Make the list of all puyo!
	local list1 = MakePuyoList(colors, 3)
	local list2 = MakePuyoList(colors, 4)
	local list3 = MakePuyoList(colors, 5)
	player.puyolists[0] = list1.mainlist
	player.puyolists[1] = list2.mainlist
	player.puyolists[2] = list3.mainlist
	player.puyolistsalt[0] = list1.altlist
	player.puyolistsalt[1] = list2.altlist
	player.puyolistsalt[2] = list3.altlist
	// Set the first 4 colors of 4 and 5 to the ones from 3 for maximum accuracy! (also because you can see the next display when selecting a difficulty)
	local lnum = 0
	while(lnum < 4)
		local lnum2 = lnum%2
		if(lnum < 2)
			player.puyolists[lnum2][0] = player.puyolists[0][0]
			player.puyolists[lnum2][1] = player.puyolists[0][1]
			player.puyolists[lnum2][2] = player.puyolists[0][2]
			player.puyolists[lnum2][3] = player.puyolists[0][3]
		else
			player.puyolistsalt[lnum2][0] = player.puyolistsalt[0][0]
			player.puyolistsalt[lnum2][1] = player.puyolistsalt[0][1]
			player.puyolistsalt[lnum2][2] = player.puyolistsalt[0][2]
			player.puyolistsalt[lnum2][3] = player.puyolistsalt[0][3]
		end
		lnum = $1 + 1
	end
	// Initialize the boards!
	player.boards[0] = InitBoard(player, colors, player.characters[0], rules, 2)
	if(player.numplayers > 1)
		player.boards[1] = InitBoard(player, colors, player.characters[1], rules, 2)
	else
		player.boards[1] = nil
	end
	if(player.numplayers > 2)
		player.boards[2] = InitBoard(player, colors, player.characters[2], rules, 2)
	else
		player.boards[2] = nil
	end
	if(player.numplayers > 3)
		player.boards[3] = InitBoard(player, colors, player.characters[3], rules, 2)
	else
		player.boards[3] = nil
	end
	player.starttime = starttime
	player.carbyanim = 1
	player.carbyframe = 0
	player.carbytime = 0
	player.carbyx = 16
	player.carbyy = 0
	player.carbyflip = false
	// Set carbuncle!
	player.carbuncle = 3
	local cnum = 0
	while(cnum < player.numplayers)
		if(player.characters[cnum] == 0)		// Arle?
			and not(player.carbuncle == 2)		// No fakebuncle!
			player.carbuncle = 1				// Carbuncle should appear!
		elseif(player.characters[cnum] == 1)	// Carbuncle?
			player.carbuncle = 2				// I found you, fakebuncle!
		end
		cnum = $1 + 1
	end
	// Puyo anim stuff
	player.puyoanim = 0
	player.puyoframe = 0
	player.puyotime = 0
	player.matchended = 0
end

local function StartGame2(player)
	local totalwins = 0
	local wnum = 0
	while(wnum < 4)
		totalwins = $1 + player.wins[wnum]
		wnum = $1 + 1
	end
	if(totalwins)
		return
	end
	RestoreMusic(player)
end

/*COM_AddCommand("startpuyo", function(player)
	StartGame(player)
	player.gamestate = 0
end)

COM_AddCommand("endpuyo", function(player)
	if not(rpgblast)
		CONS_Printf(player, "RPG Blast only!")
	else
		player.gamestate = -1
		P_RestoreMusic(player)
	end
end)*/

local function JoinPlayer(player, host)
	player.host = host
	local pnum = 0
	while(pnum < 4)
		if(players[player.host].clients[pnum] == #player)	// Don't add ourself to the list!
			return
		end
		if(players[player.host].clients[pnum] == -1)
			players[player.host].clients[pnum] = #player
			return
		end
		pnum = $1 + 1
	end
end

/*
COM_AddCommand("joinplayer", function(player, num)
	if(num == nil or tonumber(num) == nil)
		or not(players[tonumber(num)])
		return
	end
	JoinPlayer(player, tonumber(num))
end)
*/

local function RemovePuyoGroup(tiles, puyo)
	if(tiles[puyo].type >= 6)
		return 0
	end
	local numpuyo = 1
	tiles[puyo].lookedfor = true
	if(puyo/boardwidth > bufferrows)
		and(tiles[puyo-boardwidth].type == tiles[puyo].type)
		and not(tiles[puyo-boardwidth].lookedfor)
		numpuyo = $1 + RemovePuyoGroup(tiles, puyo-boardwidth)
	end
	if(puyo%boardwidth > 0)
		and(tiles[puyo-1].type == tiles[puyo].type)
		and not(tiles[puyo-1].lookedfor)
		numpuyo = $1 + RemovePuyoGroup(tiles, puyo-1)
	end
	if(puyo%boardwidth < boardwidth-1)
		and(tiles[puyo+1].type == tiles[puyo].type)
		and not(tiles[puyo+1].lookedfor)
		numpuyo = $1 + RemovePuyoGroup(tiles, puyo+1)
	end
	if(puyo/boardwidth < boardheight-1)
		and(tiles[puyo+boardwidth].type == tiles[puyo].type)
		and not(tiles[puyo+boardwidth].lookedfor)
		numpuyo = $1 + RemovePuyoGroup(tiles, puyo+boardwidth)
	end
	return numpuyo
end

local function RemovePuyoGroupVeryInoptimal(tiles, puyo, num, fever, fevermode)
	local poptime = mulpoptime*num
	if(fever)
		poptime = feverpoptime
	end

	tiles[puyo].removetime = poptime
	if(puyo/boardwidth > bufferrows)
		and not(tiles[puyo-boardwidth].removetime)
		if(tiles[puyo-boardwidth].type == tiles[puyo].type)
			RemovePuyoGroupVeryInoptimal(tiles, puyo-boardwidth, num+1, fever, fevermode)
		elseif(tiles[puyo-boardwidth].type >= 6)
			and(tiles[puyo-boardwidth].type <= 7)
			tiles[puyo-boardwidth].removetime = poptime
		end
	end
	if(puyo%boardwidth > 0)
		and not(tiles[puyo-1].removetime)
		if(tiles[puyo-1].type == tiles[puyo].type)
			RemovePuyoGroupVeryInoptimal(tiles, puyo-1, num+1, fever, fevermode)
		elseif(tiles[puyo-1].type >= 6)
			and(tiles[puyo-1].type <= 7)
			tiles[puyo-1].removetime = poptime
		end
	end
	if(puyo%boardwidth < boardwidth-1)
		and not(tiles[puyo+1].removetime)
		if(tiles[puyo+1].type == tiles[puyo].type)
			RemovePuyoGroupVeryInoptimal(tiles, puyo+1, num+1, fever, fevermode)
		elseif(tiles[puyo+1].type >= 6)
			and(tiles[puyo+1].type <= 7)
			tiles[puyo+1].removetime = poptime
		end
	end
	if(puyo/boardwidth < boardheight-1)
		and not(tiles[puyo+boardwidth].removetime)
		if(tiles[puyo+boardwidth].type == tiles[puyo].type)
			RemovePuyoGroupVeryInoptimal(tiles, puyo+boardwidth, num+1, fever, fevermode)
		elseif(tiles[puyo+boardwidth].type >= 6)
			and(tiles[puyo+boardwidth].type <= 7)
			tiles[puyo+boardwidth].removetime = poptime
		end
	end
end

local function RemoveFromTable(table, pos, length)
	local table2 = table
	local pos2 = pos
	while(pos2+1 < length)
		table2[pos2] = table2[pos2+1]
		pos2 = $1 + 1
	end
	return table2
end

// From lua-users.org
local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

local function ChainResolved(tilesorig)
	local tiles = deepcopy(tilesorig)		// Copying the board is good.
	// First, remove all puyo that are popping!
	local tnum = 0
	while(tnum < boardwidth*boardheight)
		if(tiles[tnum].removetime)
			tiles[tnum].type = 0
		end
		tnum = $1 + 1
	end

	// Next, teleport every tile down!
	tnum = (boardwidth*boardheight)-1
	while(tnum >= 0)
		if(tiles[tnum].type)
			local tnum2 = tnum
			while(tiles[tnum2+boardwidth] and not tiles[tnum2+boardwidth].type)
				tiles[tnum2+boardwidth].type = tiles[tnum2].type
				tiles[tnum2].type = 0
				tnum2 = $1 + boardwidth
			end
		end
		tnum = $1 - 1
	end
	// Now look for chains!
	tnum = 0
	while(tnum < boardwidth*boardheight)
		if(tiles[tnum].type)
			and not(tiles[tnum].lookedfor)
			and not(tiles[tnum].removetime)
			and(RemovePuyoGroup(tiles, tnum) >= 4)
			return false	// Chain found, so its not resolved
		end
		tnum = $1 + 1
	end
	return true	// No chains found, so it must be resolved!
end

local function GetSquishOff(boardtiles, tnum, rownum, bottomtile)
	local bottom = bottomtile
	return FixedMul(sin(boardtiles[boardtiles[tnum].bottompiece-boardwidth].squish), squishsinmul)*((tnum/boardwidth)-(bottom/boardwidth)+1)/(rownum-1)/FRACUNIT*2/3
end

local function lookForBottom(boardtiles, tnum)
	local tnum2 = tnum+boardwidth
	while(tnum2 < boardwidth*boardheight)
		and(boardtiles[tnum2] and boardtiles[tnum2].type)	// Also check for blocks and tetriminos
		and not(boardtiles[tnum2].type == 8)
		tnum2 = $1 + boardwidth
	end
	return tnum2
end

local function SimulateChain(tiles)
	// First, remove all puyo that are popping!
	local chainnum = 0
	local tnum = 0
	while(tnum < boardwidth*boardheight)
		tiles[tnum].lookedfor = false
		if(tiles[tnum].removetime)
			tiles[tnum].type = 0
		end
		tnum = $1 + 1
	end

	// Next, teleport every tile down!
	tnum = (boardwidth*boardheight)-1
	while(tnum >= 0)
		if(tiles[tnum].type)
			local tnum2 = tnum
			while(tiles[tnum2+boardwidth] and not tiles[tnum2+boardwidth].type)
				tiles[tnum2+boardwidth].type = tiles[tnum2].type
				tiles[tnum2].type = 0
				tnum2 = $1 + boardwidth
			end
		end
		tnum = $1 - 1
	end
	// Now look for chains!
	tnum = 0
	local thingpopped = false
	while(tnum < boardwidth*boardheight)
		if(tiles[tnum].type)
		//	and not(tiles[tnum].lookedfor)
		//	and not(tiles[tnum].removetime)
			local num = RemovePuyoGroup(tiles, tnum)
			if(num >= 4)
				RemovePuyoGroupVeryInoptimal(tiles, tnum, num, false, false)
				chainnum = $1 + 1
				thingpopped = true
			end
		end
		tnum = $1 + 1
	end
	if(thingpopped)
		chainnum = $1 + SimulateChain(tiles)
	end
	return chainnum
end

local function lookForGroupTiles(board, group, tile)
	if(tile%boardwidth < group.bbx1)
		group.bbx1 = tile%boardwidth
	end
	if(tile%boardwidth > group.bby2)
		group.bbx2 = tile%boardwidth
	end
	if(tile/boardwidth < group.bby1)
		group.bby1 = tile/boardwidth
	end
	if(tile/boardwidth > group.bby2)
		group.bby2 = tile/boardwidth
	end
	group.tiles[group.numtiles] = tile
	group.tilesingroup[tile] = true
	group.numtiles = $1 + 1
	if(tile%boardwidth < boardwidth-1)
		and(board[tile+1] and board[tile+1].type == board[tile].type)
		and not(group.tilesingroup[tile+1])
		group = lookForGroupTiles(board, group, tile+1)
	end
	if(tile%boardwidth)
		and(board[tile-1] and board[tile-1].type == board[tile].type)
		and not(group.tilesingroup[tile-1])
		group = lookForGroupTiles(board, group, tile-1)
	end
	if(tile/boardwidth > bufferrows)
		and(board[tile-boardwidth] and board[tile-boardwidth].type == board[tile].type)
		and not(group.tilesingroup[tile-boardwidth])
		group = lookForGroupTiles(board, group, tile-boardwidth)
	end
	if(tile/boardwidth < boardheight)
		and(board[tile+boardwidth] and board[tile+boardwidth].type == board[tile].type)
		and not(group.tilesingroup[tile+boardwidth])
		group = lookForGroupTiles(board, group, tile+boardwidth)
	end
	return group
end

local function makeGroup(board, tile)
	local group = {}
	group.bbx1 = boardwidth
	group.bbx2 = 0
	group.bby1 = boardheight
	group.bby2 = 0
	group.tiles = {}
	group.tilesingroup = {}
	group.numtiles = 0
	return lookForGroupTiles(board, group, tile)
end

local function removeGroupAndSimulateBoard(tiles, group)
	local gnum = 0
	while(gnum < group.numtiles)
		tiles[group.tiles[gnum]].type = 0
		gnum = $1 + 1
	end
	return SimulateChain(tiles)
end

local function lookForGroups(tiles, tile, tileslookedfor, groups, groupnum)
	tileslookedfor[tile] = true
	if(tiles[tile+boardwidth] and not tiles[tile+boardwidth].type)
		and not(tileslookedfor[tile+boardwidth])
		local goodgroups = lookForGroups(tiles, tile+boardwidth,tileslookedfor, groups, groupnum)
		groups = goodgroups[0]
		groupnum = goodgroups[1]
	end
	if(tiles[tile-1] and not tiles[tile-1].type)
		and not(tileslookedfor[tile-1])
		and(tile%boardwidth > 0)
		local goodgroups = lookForGroups(tiles, tile-1, tileslookedfor, groups, groupnum)
		groups = goodgroups[0]
		groupnum = goodgroups[1]
	end
	if(tiles[tile+1] and not tiles[tile+1].type)
		and not(tileslookedfor[tile+1])
		and(tile%boardwidth < boardwidth-1)
		local goodgroups = lookForGroups(tiles, tile+1, tileslookedfor, groups, groupnum)
		groups = goodgroups[0]
		groupnum = goodgroups[1]
	end
	if(tiles[tile-boardwidth] and not tiles[tile-boardwidth].type)
		and not(tileslookedfor[tile-boardwidth])
		and(tile > bufferrows*boardwidth)
		local goodgroups = lookForGroups(tiles, tile-boardwidth, tileslookedfor, groups, groupnum)
		groups = goodgroups[0]
		groupnum = goodgroups[1]
	end

	if(tiles[tile+boardwidth] and tiles[tile+boardwidth].type and tiles[tile+boardwidth].type < 6)
		and not(tileslookedfor[tile+boardwidth])
		groups[groupnum] = makeGroup(tiles, tile+boardwidth)
		groupnum = $1 + 1
	end
	if(tiles[tile-1] and tiles[tile-1].type and tiles[tile-1].type < 6)
		and not(tileslookedfor[tile-1])
		and(tile%boardwidth > 0)
		groups[groupnum] = makeGroup(tiles, tile-1)
		groupnum = $1 + 1
	end
	if(tiles[tile+1] and tiles[tile+1].type and tiles[tile+1].type < 6)
		and not(tileslookedfor[tile+1])
		and(tile%boardwidth < boardwidth-1)
		groups[groupnum] = makeGroup(tiles, tile+1)
		groupnum = $1 + 1
	end
	if(tiles[tile-boardwidth] and tiles[tile-boardwidth].type and tiles[tile-boardwidth].type < 6)
		and not(tileslookedfor[tile-boardwidth])
		and(tile > bufferrows*boardwidth)
		groups[groupnum] = makeGroup(tiles, tile-boardwidth)
		groupnum = $1 + 1
	end
	local goodgroup = {}
	goodgroup[0] = groups
	goodgroup[1] = groupnum
	return goodgroup
end

local function lookForTrigger(board, tile)
	local boardtiles = MakeTilesFromBoard(board, board.fevermode)
	local highestnumber = -1
	local groupwithnumber

	// first, look for puyo close to this tile
	local tileslookedfor = {}
	local goodgroups = lookForGroups(boardtiles, tile, tileslookedfor, {}, 0)
	local groups = goodgroups[0]
	local groupnum = goodgroups[1]

	// Simulate the board without the group!
	local gnum = 0
	while(gnum < groupnum)
		local tiles = deepcopy(boardtiles)		// Copying the board is good.
		local number = removeGroupAndSimulateBoard(tiles, groups[gnum])
		if(number > highestnumber)
			highestnumber = number
			groupwithnumber = gnum
		end
		gnum = $1 + 1
	end

	if not(groupwithnumber == nil)
/*		if(players[0].cmd.buttons & BT_CUSTOM1)
			and not(players[0].prevbutt & BT_CUSTOM1)
			local gnum = 0
			while(gnum < groups[groupwithnumber].numtiles)
				boardtiles[groups[groupwithnumber].tiles[gnum]].type = 0
				gnum = $1 + 1
			end
		end*/
		return groups[groupwithnumber]
	end

	// Trigger found!

	// This wont work when finding the trigger if its burried under garbage or something is being built on top of it,
	// so this is only useful for finding the best place to build off of when our old one is inaccessable.

	// then, once one is found, build on top of it, and remember which group we're building on top of the trigger
	// remember to place puyo of the same color as the trigger on the group we're building, with only the group we're building
	// between those puyo and the trigger!
	// once the puyo are placed, then the group we're building should become the trigger

	// once the chain becomes large enough (which we should remember how long it is, rather than simulating how long it is)
	// the goal should not be to build on top of the trigger, but just place puyo of the same color next to it to pop it




	// Group:
	// up to 3 indexes for where the puyo in the group is
	// bounding box left x
	// bounding box right x
	// bounding box top y
	// bounding box bottom y

	// square group (3, space on top 2 tiles):
	// step 1: place any non trigger color in the bounding box (since there's 3 colors, there'll most likely be a space on one of the top tiles)
	// if air tile is facing center of board or there's only 2:
		// step 2: place a trigger color on the non-trigger color
		// step 3: place extension colors next to extension (waste some puyo if you need to in order to reach the color)
	// if air tile is facing away from center of board:
		// step 2: place extension color on top of group
		// step 3: place trigger color on top of extension

	// horizontal group (2/3 horizontal or 3, space on bottom 2 tiles)
	// step 1: place any non trigger color on top of the bounding box
	// step 2: place a trigger color directly on top of the extension group
	// step 3: place extension colors next to or on top of extension

	// vertical group (2/3 vertical)
	// step 1: if you get a double, place to the left or right (opposite direction of trigger's next group, if its a 1, to the center)
	// step 2: if you get a trigger and its a 2, place on top of extension, otherwise, continue extending the extension, but not if you get a double)
	// step 1a: if you get a random trigger, place on top of it
	// step 2a: place extensions to the side

	// sandwich group (2/3 not all connected, vertical)
	// step 1: place extension puyo on air "group" thats closest to top
	// step 2: place trigger puyo on extension puyo

	// gtr group (3 not all connected, horizontal)
	// step 1: place extension puyo on air "group" thats closest to top
	// step 2: place trigger puyo on extension puyo closest to the highest trigger in the group

	// single puyo
	// place any puyo of the same color next to it, in any direction
	// if you dont get one of the same color and there's space, then place a trigger color on top of it
	// if you dont get a trigger color, then palce it on the opposite side of the board



	// Horizontal trigger:
	// in order to make sure we dont mess something up, if we get double of our extend color, then place it vertically (no rotation or double)
	// if we get mixed colors, if one is the extend color and one is the trigger color, then place it vertically
	// but only if it doesn't make the extend color inaccessable, then split it by placing it horizontally
	// if we get the extend color and a random color, place it horizontally as to not mess up the trigger
	// if we get the trigger color and a random color, then if it doesn't make the extension inaccessable, then place it vertically
	// so that the trigger color is on top of the extension
	// if we get two random colors (not a double), then place it on the opposite side of the board horizontally (which is defenetly optimal)
	// if we get one random color, then place it on the opposite side of the board vertically (also defenetly optimal)

	// Vertical/square trigger:
	// double extend: vertical, to the left or right (whichever has more free space)
	// extend trigger: vertical, exactly always to the left or right by 1 (where the extend is)
	// double trigger: vertical, again, always left or right, but only if there's enough extend vertically, if not, then
	// treat it as double random
	// extend random: horizontal, left or right
	// trigger random: horizontal, random being on the trigger, trigger being on the extend, if extend is not tall enough,
	// treat as double random
	// two randoms: same as horizontal
	// double random: same as horizontal

	// Trigger is inaccessable:
	// if a group thats blocking it is next to air, then pop it
	// once this is done, then scan the board again for the trigger and lenght, as you might've just screwed up your chain
	// otherwise, find a new one, you're too dumb to figure it out!
end

// It would be better to put these in the board, but then i would have to scroll up
// and its 7:19 PM, and the deadline is apparently 9:00 PM
// I have good priorities starting this the day of the deadline
// this is not what i need

	// square group (3, space on top 2 tiles):
	// step 1: place any non trigger color in the bounding box (since there's 3 colors, there'll most likely be a space on one of the top tiles)
	// if air tile is facing center of board or there's only 2:
		// step 2: place a trigger color on the non-trigger color
		// step 3: place extension colors next to extension (waste some puyo if you need to in order to reach the color)
	// if air tile is facing away from center of board:
		// step 2: place extension color on top of group
		// step 3: place trigger color on top of extension

	// horizontal group (2/3 horizontal or 3, space on bottom 2 tiles)
	// step 1: place any non trigger color on top of the bounding box
	// step 2: place a trigger color directly on top of the extension group
	// step 3: place extension colors next to or on top of extension

	// vertical group (2/3 vertical)
	// step 1: if you get a double, place to the left or right (opposite direction of trigger's next group, if its a 1, to the center)
	// step 2: if you get a trigger and its a 2, place on top of extension, otherwise, continue extending the extension, but not if you get a double)
	// step 1a: if you get a random trigger, place on top of it
	// step 2a: place extensions to the side

	// sandwich group (2/3 not all connected, vertical)
	// step 1: place extension puyo on air "group" thats closest to top
	// step 2: place trigger puyo on extension puyo

	// gtr group (3 not all connected, horizontal)
	// step 1: place extension puyo on air "group" thats closest to top
	// step 2: place trigger puyo on extension puyo closest to the highest trigger in the group

	// single puyo
	// place any puyo of the same color next to it, in any direction
	// if you dont get one of the same color and there's space, then place a trigger color on top of it
	// if you dont get a trigger color, then palce it on the opposite side of the board

/*local trigger		// Group that, when popped, sets off the chain
local extension		// Group that will become the trigger when its finished being built

local extensioncolor
local samecolorplaced = 0
local hasplacedyet = false
local hasunintellegentlyplaced = false
local haspopped = false*/

local function doAICmd(board, character)
	local boardtiles = MakeTilesFromBoard(board, board.fevermode)

	local cmd = {}
	cmd.sidemove = 0
	cmd.forwardmove = 0
	cmd.buttons = 0

//	lookForTrigger(board, (boardwidth*bufferrows)+2)

	local suketoudara = false
	local harpy = false
	local nohoho = false
	if(character == 6)
		suketoudara = true
	end
	local targetdest = -1
	local targetrot = 1

	local boardisempty = true
	local tnum = 0
	while(tnum < boardwidth*boardheight)
		if(boardtiles[tnum].type)
			boardisempty = false
		end
		tnum = $1 + 1
	end

	if(suketoudara)
		// Place puyo in the first 3 rows!
		local rnum = boardwidth*(boardheight-1)
		local cnum = 0
		while(rnum >= boardwidth*(boardheight-3))
			and(targetdest == -1)
			if(boardtiles[cnum+rnum])
				and not(boardtiles[cnum+rnum].type)
				targetdest = cnum+rnum
			end
			cnum = $1 + 1
			if(cnum > boardwidth)
				cnum = 0
				rnum = $1 - boardwidth
			end
		end

		if not(targetdest == -1)
			and(board.placingpuyo%boardwidth == targetdest%boardwidth)
			cmd.forwardmove = -50
		end
	elseif(harpy)
		// Place puyo in the left and right collumns!
		local rnum = boardwidth*(boardheight-1)
		local cnum = 0
		while(rnum >= boardwidth*bufferrows)
			and(targetdest == -1)
			if(boardtiles[cnum+rnum])
				and not(boardtiles[cnum+rnum].type)
				targetdest = cnum+rnum
			end
			cnum = $1 + boardwidth-1
			if(cnum > boardwidth)
				cnum = 0
				rnum = $1 - boardwidth
			end
		end

		if not(targetdest == -1)
			and(board.placingpuyo%boardwidth == targetdest%boardwidth)
			cmd.forwardmove = -50
		end
	elseif(nohoho)
		// Place puyo in the 3 right collumns!
		local half = boardwidth/2
		if(boardwidth & 1)
			half = $1 + 1
		end
		local rnum = boardwidth*(boardheight-1)
		local cnum = boardwidth-1
		while(cnum >= half)
			and(targetdest == -1)
			if(boardtiles[cnum+rnum])
				and not(boardtiles[cnum+rnum].type)
				targetdest = cnum+rnum
			end
			rnum = $1 - boardwidth
			if(rnum < boardwidth*bufferrows)
				cnum = $1 - 1
				rnum = $1 - boardwidth*(boardheight-1)
			end
		end
		//print(cnum)

		if not(targetdest == -1)
			and(board.placingpuyo%boardwidth == targetdest%boardwidth)
			cmd.forwardmove = -50
		end
	elseif(boardisempty)
		targetdest = boardwidth
		targetrot = 0
	end

	// Look for the trigger
	if(board.trigger == nil)
		or(board.state == 3 and not board.haspopped)
		or(board.samecolorplaced >= 4)
		board.trigger = lookForTrigger(board, (boardwidth*bufferrows)+2)
		if(board.trigger)
			board.samecolorplaced = board.trigger.numtiles
		end
	end

	if(board.state == 3)
		board.haspopped = true
	else
		board.haspopped = false
	end

	if(board.state == 0)
		and(board.hasunintellegentlyplaced)
		if not(board.hasplacedyet)
			if(board.placingpuyocolor[0] == boardtiles[board.trigger.tiles[0]].type)
				board.samecolorplaced = $1 + 1
			end
			if(board.placingpuyocolor[1] == boardtiles[board.trigger.tiles[0]].type)
				board.samecolorplaced = $1 + 1
			end
			board.hasplacedyet = true
		end
	else
		board.hasunintellegentlyplaced = false
		board.hasplacedyet = false
	end

//	print(board.samecolorplaced)

	// okay, now look for stuff
	if(targetdest < 0)
		if(board.trigger == nil)
		//	print("no trigger")
		else
	//		if(board.trigger.bbx1 == board.trigger.bbx2)
	//			and(board.trigger.bby1 == board.trigger.bby2)	// Single puyo

				// is there anything above it?
				if(boardtiles[board.trigger.tiles[0]-boardwidth].type)
					// Only place puyo of the same type on it!
					local alreadydidextend = false
					local pnum = board.trigger.tiles[0]
					while(boardtiles[pnum])
						and(boardtiles[pnum-boardwidth])
						and(boardtiles[pnum].type == boardtiles[board.trigger.tiles[0]].type or boardtiles[pnum].type == board.extensioncolor and not alreadydidextend)
						if(boardtiles[pnum].type == board.extensioncolor)
							and not(boardtiles[pnum-boardwidth].type == board.extensioncolor)
							alreadydidextend = true
						end
						pnum = $1 - boardwidth
					end
					if(board.placingpuyocolor[0] == boardtiles[board.trigger.tiles[0]].type and board.placingpuyocolor[1] == boardtiles[board.trigger.tiles[0]].type)	// Double same
						targetdest = board.trigger.bbx1+boardwidth
						targetrot = 1
						board.hasunintellegentlyplaced = true
					elseif(board.placingpuyocolor[0] == boardtiles[board.trigger.tiles[0]].type)
						and(board.placingpuyocolor[1] == board.extensioncolor)
						// Pivot = trigger, non-pivot = extension
						targetdest = board.trigger.bbx1+boardwidth
						if(board.trigger.bbx2 < boardwidth/2)
							targetrot = 0
						else
							targetrot = 2
						end
						board.hasunintellegentlyplaced = true
					elseif(board.placingpuyocolor[0] == board.extensioncolor)
						and(board.placingpuyocolor[1] == boardtiles[board.trigger.tiles[0]].type)
						// Pivot = extension, non-pivot = trigger
						targetdest = board.trigger.bbx1+boardwidth
						if(board.trigger.bbx2 < boardwidth/2)
							targetrot = 2
						else
							targetrot = 0
						end
						board.hasunintellegentlyplaced = true
					elseif(boardtiles[pnum].type)
						if(board.trigger.bbx2 < boardwidth/2)
							targetdest = board.trigger.bbx1+boardwidth+1
						else
							targetdest = board.trigger.bbx1+boardwidth-1
						end
						if(board.placingpuyocolor[0] == boardtiles[board.trigger.tiles[0]].type)
							targetrot = 1
						else
							targetrot = 3
						end
						board.hasunintellegentlyplaced = true
					elseif(board.placingpuyocolor[0] == boardtiles[board.trigger.tiles[0]].type)
						// Pivot = trigger, non-pivot = random
						targetdest = board.trigger.bbx1+boardwidth
						targetrot = 1
						board.hasunintellegentlyplaced = true
					elseif(board.placingpuyocolor[1] == boardtiles[board.trigger.tiles[0]].type)
						// Pivot = random, non-pivot = trigger
						targetdest = board.trigger.bbx1+boardwidth
						targetrot = 2
						board.hasunintellegentlyplaced = true
					elseif(board.placingpuyocolor[0] == board.extensioncolor and board.placingpuyocolor[1] == board.extensioncolor)
						// double extension
						if(board.trigger.bbx2 < boardwidth/2)
							targetdest = board.trigger.bbx1+boardwidth+1
						else
							targetdest = board.trigger.bbx1+boardwidth-1
						end
						targetrot = 1
						board.hasunintellegentlyplaced = true
					elseif(board.placingpuyocolor[0] == board.extensioncolor)
						// Pivot = extension, non-pivot = random
						if(board.trigger.bbx2 < boardwidth/2)
							targetdest = board.trigger.bbx1+boardwidth+1
							targetrot = 0
						else
							targetdest = board.trigger.bbx1+boardwidth-1
							targetrot = 2
						end
						board.hasunintellegentlyplaced = true
					elseif(board.placingpuyocolor[1] == board.extensioncolor)
						// Pivot = random, non-pivot = extension
						if(board.trigger.bbx2 < boardwidth/2)
							targetdest = board.trigger.bbx1+boardwidth+2
							targetrot = 2
						else
							targetdest = board.trigger.bbx1+boardwidth-2
							targetrot = 0
						end
						board.hasunintellegentlyplaced = true
					else // Nothing matches
						local opposite = 0
						if(board.trigger.bbx2 < boardwidth/2)
							opposite = boardwidth-1
						end
						targetdest = boardwidth+opposite
					end
				else
					if(board.placingpuyocolor[0] == boardtiles[board.trigger.tiles[0]].type and board.placingpuyocolor[1] == boardtiles[board.trigger.tiles[0]].type)	// Double same
						targetdest = board.trigger.bbx1+boardwidth
						targetrot = 0
						board.extensioncolor = 0
						board.trigger = lookForTrigger(board, (boardwidth*bufferrows)+2)
						board.hasunintellegentlyplaced = true
					elseif(board.placingpuyocolor[0] == boardtiles[board.trigger.tiles[0]].type)	// Pivot same
						targetdest = board.trigger.bbx1+boardwidth
						targetrot = 3
						board.extensioncolor = board.placingpuyocolor[1]
						board.hasunintellegentlyplaced = true
					elseif(board.placingpuyocolor[1] == boardtiles[board.trigger.tiles[0]].type)	// Non-pivot same
						targetdest = board.trigger.bbx1+boardwidth
						targetrot = 1
						board.extensioncolor = board.placingpuyocolor[0]
						board.hasunintellegentlyplaced = true
					elseif(board.placingpuyocolor[0] == board.placingpuyocolor[1])	// double random
						targetdest = board.trigger.bbx1+boardwidth
						targetrot = 0
						board.extensioncolor = board.placingpuyocolor[0]
					else // Nothing matches
						local opposite = 0
						if(board.trigger.bbx2 < boardwidth/2)
							opposite = boardwidth-1
						end
						targetdest = boardwidth+opposite
					end
				end
			end
	//	end
	end

	// dumb
	if(character == 4)
		or(character == 2)
		cmd.forwardmove = -50
	elseif(character == 3)
		or(character == 6)
		if(leveltime & 1)
			cmd.forwardmove = -50
		end
	elseif(leveltime%TICRATE > TICRATE*5/6)
		cmd.forwardmove = -50
	end


	// Go to target destination
	if(targetdest > 0)
		if(board.placingpuyo%boardwidth < targetdest%boardwidth)
			and(leveltime & 1)
			cmd.sidemove = 50
		elseif(board.placingpuyo%boardwidth > targetdest%boardwidth)
			and(leveltime & 1)
			cmd.sidemove = -50
		end
	end

	if not(targetrot == board.placingpuyorotate)
		and not(leveltime % 3)

		if(targetrot > board.placingpuyorotate)
			cmd.buttons = $1|BT_JUMP
		else
			cmd.buttons = $1|BT_USE
		end
	end

	return cmd
end

local function UpdateBoard(player, board, cmd, panicplayer, numboard, character)
	local boardtiles = MakeTilesFromBoard(board, board.fevermode)

	board.justmoved = 0
	if(board.lostyoff)
	//	and(player.numplayers <= 2 or player.matchended > 1)
		board.lostyoff = $1 + 1
		if(board.lostyoff == losevoicetimer)
			PlaySound(player, sfx_arlel, character)
		end
	end

	if(board.feverswitchtime)
		board.feverswitchtime = $1 - 1
	end

	if(board.chaineffecttimer)
		board.chaineffecttimer = $1 + 1
		if(board.chaineffecttimer > chainefftime)
			board.chaineffecttimer = 0
		end
	end

	if not(board.feverdelaytimer)
		and not(board.feverswitchtime)
		if(board.state == 0)		// Placing
			and not(player.matchended)

			board.giveallclearbonus = true

			board.fevergarbagedelay = false
			board.matchhasstarted = true
			if(rpgblast)
				and not(player.puyotarget and player.puyotarget.valid)
				MakeBoardFromTiles(boardtiles, board, board.fevermode)
				return
			end
			board.chain = 0
			board.garbagehasdropped = false
			board.garbagesoundyet = false
			board.diacutes = 0
			local nextcolor = (board.placingpuyocolor[0]%5)+1
			local prevcolor = board.placingpuyocolor[0]-1
			if(prevcolor <= 0)
				prevcolor = 5
			end
			if(board.colors == 0)
				while not(nextcolor == board.colorslist[0] or nextcolor == board.colorslist[1] or nextcolor == board.colorslist[2])
					nextcolor = ($1%5)+1
				end
				while not(prevcolor == board.colorslist[0] or prevcolor == board.colorslist[1] or prevcolor == board.colorslist[2])
					prevcolor = $1 - 1
					if(prevcolor <= 0)
						prevcolor = 5
					end
				end
			elseif(board.colors == 1)
				while not(nextcolor == board.colorslist[0] or nextcolor == board.colorslist[1] or nextcolor == board.colorslist[2] or nextcolor == board.colorslist[3])
					nextcolor = ($1%5)+1
				end
				while not(prevcolor == board.colorslist[0] or prevcolor == board.colorslist[1] or prevcolor == board.colorslist[2] or prevcolor == board.colorslist[3])
					prevcolor = $1 - 1
					if(prevcolor <= 0)
						prevcolor = 5
					end
				end
			end
			// Rotation
			if(cmd.buttons & BT_JUMP)		// Left
				and not(board.prevbuttons & BT_JUMP)
				PlaySound(player, sfx_prot)
				if(board.placingpuyotype == 6)
					board.placingpuyocolor[0] = nextcolor
				else
					board.placingpuyointendedrotate = ($1 + 1)%4
					board.placingpuyorotatedir = true
				end
			elseif(cmd.buttons & BT_USE)	// Right
				and not(board.prevbuttons & BT_USE)
				PlaySound(player, sfx_prot)
				if(board.placingpuyotype == 6)
					board.placingpuyocolor[0] = prevcolor
				else
					board.placingpuyointendedrotate = ($1 + 3)%4
					board.placingpuyorotatedir = false
				end
			end

			if(abs(board.placingpuyorotate2-(board.placingpuyorotate*90*FRACUNIT)) < rotatespeed)
				board.placingpuyorotate2 = board.placingpuyorotate*90*FRACUNIT
			else
				if(board.placingpuyorotatedir)
					board.placingpuyorotate2 = ($1 + rotatespeed)%(360*FRACUNIT)
				else
					board.placingpuyorotate2 = ($1 + ((360*FRACUNIT)-rotatespeed))%(360*FRACUNIT)
				end
			end

			local toppuyo = board.placingpuyo
			if(board.placingpuyorotate == 1)
				or(board.placingpuyotype >= 5)
				toppuyo = board.placingpuyo-boardwidth
			end

			if not((boardtiles[toppuyo+1] and boardtiles[toppuyo+1].type) or toppuyo%boardwidth == boardwidth-1)
				or not((boardtiles[toppuyo-1] and boardtiles[toppuyo-1].type) or toppuyo%boardwidth == 0)
				or not(board.placingpuyointendedrotate == 0 or board.placingpuyointendedrotate == 2)
				board.placingpuyorotate = board.placingpuyointendedrotate
			end

			local leftpuyo = board.placingpuyo
			local rightpuyo = board.placingpuyo
			local bottompuyo = board.placingpuyo
			if(board.placingpuyorotate == 0)
				or(board.placingpuyorotate == 1 and (board.placingpuyotype == 1 or board.placingpuyotype == 2))
				or(board.placingpuyotype >= 5)
				rightpuyo = board.placingpuyo+1
			elseif(board.placingpuyorotate == 2)
				or(board.placingpuyorotate == 3 and (board.placingpuyotype == 1 or board.placingpuyotype == 2))
				leftpuyo = board.placingpuyo-1
			elseif(board.placingpuyorotate == 3)
				bottompuyo = board.placingpuyo+boardwidth
			end

			if(board.placingpuyotype == 1 or board.placingpuyotype == 2)
				and(board.placingpuyorotate == 0 or board.placingpuyorotate == 3)
				bottompuyo = board.placingpuyo+boardwidth
			end

			// Detect walls!
			// Put this after floor detection and make sure you dont push puyo into other puyo to imitate yon rules
			local yon = board.fever

			if not(yon)
				if(board.placingpuyorotate == 0 or board.placingpuyorotate == 2)
					or(board.placingpuyotype == 1 or board.placingpuyotype == 2)
					if(leftpuyo%boardwidth == boardwidth-1 and board.placingpuyo%boardwidth == 0)	// That doesn't make sense!
						or(boardtiles[leftpuyo] and boardtiles[leftpuyo].type)
						board.placingpuyo = $1 + 1	// Push out of the wall!
					elseif(rightpuyo%boardwidth == 0 and board.placingpuyo%boardwidth == boardwidth-1)	// That also doesn't make sense!
						or(boardtiles[rightpuyo] and boardtiles[rightpuyo].type)
						board.placingpuyo = $1 - 1		// Push out of the wall!
					end
				end

				leftpuyo = board.placingpuyo
				rightpuyo = board.placingpuyo
				bottompuyo = board.placingpuyo
				if(board.placingpuyorotate == 0)
					or(board.placingpuyorotate == 1 and (board.placingpuyotype == 1 or board.placingpuyotype == 2))
					or(board.placingpuyotype >= 5)
					rightpuyo = board.placingpuyo+1
				elseif(board.placingpuyorotate == 2)
					or(board.placingpuyorotate == 3 and (board.placingpuyotype == 1 or board.placingpuyotype == 2))
					leftpuyo = board.placingpuyo-1
				elseif(board.placingpuyorotate == 3)
					bottompuyo = board.placingpuyo+boardwidth
				end

				if(board.placingpuyotype == 1 or board.placingpuyotype == 2)
					and(board.placingpuyorotate == 0 or board.placingpuyorotate == 3)
					bottompuyo = board.placingpuyo+boardwidth
				end
			end

			// Moving
			if(cmd.sidemove)
				and(board.prevsidemove == cmd.sidemove)
				board.sidemovetime = $1 + 1
			else
				board.sidemovetime = 0
			end

			if(cmd.sidemove < -mininput)
				and(leftpuyo%boardwidth > 0)
				and not(boardtiles[leftpuyo-1] and boardtiles[leftpuyo-1].type)
				and not(boardtiles[bottompuyo-1] and boardtiles[bottompuyo-1].type)
				if(board.prevsidemove >= -mininput)
					or(board.sidemovetime > fasttime and(leveltime & 1))
					board.placingpuyo = $1 - 1
					board.justmoved = 2
					PlaySound(player, sfx_pmove)
				end
			elseif(cmd.sidemove > mininput)
				and(rightpuyo%boardwidth < boardwidth-1)
				and not(boardtiles[rightpuyo+1] and boardtiles[rightpuyo+1].type)
				and not(boardtiles[bottompuyo+1] and boardtiles[bottompuyo+1].type)
				if(board.prevsidemove <= mininput)
					or(board.sidemovetime > fasttime and(leveltime & 1))
					board.justmoved = 1
					board.placingpuyo = $1 + 1
					PlaySound(player, sfx_pmove)
				end
			end

			leftpuyo = board.placingpuyo
			rightpuyo = board.placingpuyo
			bottompuyo = board.placingpuyo
			if(board.placingpuyorotate == 0)
				or(board.placingpuyorotate == 1 and (board.placingpuyotype == 1 or board.placingpuyotype == 2))
				or(board.placingpuyotype >= 5)
				rightpuyo = board.placingpuyo+1
			elseif(board.placingpuyorotate == 2)
				or(board.placingpuyorotate == 3 and (board.placingpuyotype == 1 or board.placingpuyotype == 2))
				leftpuyo = board.placingpuyo-1
			elseif(board.placingpuyorotate == 3)
				bottompuyo = board.placingpuyo+boardwidth
			end

			if(board.placingpuyotype == 1 or board.placingpuyotype == 2)
				and(board.placingpuyorotate == 0 or board.placingpuyorotate == 3)
				bottompuyo = board.placingpuyo+boardwidth
			end

			// Gravity
			local prevoffset = board.placingpuyoyoffset
			if(cmd.forwardmove < -mininput)
				board.placingpuyoyoffset = $1 - normalfallspeed*21

				board.unitstopoint = $1 + ((prevoffset-board.placingpuyoyoffset)/FRACUNIT)
				local scoregot = board.unitstopoint/16
				board.score = $1 + scoregot
				board.unitstopoint = $1 % 16
				if not(board.garbagerules)
					board.leftovergarbage = $1 + (scoregot*GARBUNIT/board.targetpoints)
				end
			else
				board.placingpuyoyoffset = $1 - FixedMul(normalfallspeed, board.dropspeedmul)
			end
			if(board.placingpuyoyoffset < 0)
				if not(boardtiles[leftpuyo+boardwidth] and boardtiles[leftpuyo+boardwidth].type)
					and not(boardtiles[rightpuyo+boardwidth] and boardtiles[rightpuyo+boardwidth].type)
					and not(boardtiles[bottompuyo+boardwidth] and boardtiles[bottompuyo+boardwidth].type)
					// Board floor
					and not(leftpuyo/boardwidth >= boardheight-1)
					and not(rightpuyo/boardwidth >= boardheight-1)
					and not(bottompuyo/boardwidth >= boardheight-1)
					board.placingpuyoyoffset = $1 + 16*FRACUNIT
					board.placingpuyo = $1 + boardwidth	// Move down!
					board.placedpuyoprevonground = false
				else
					if not(board.placedpuyoprevonground)
						PlaySound(player, sfx_pplace)
						board.placingpuyoshake = 13
					end
					board.placingpuyoyoffset = 0
					board.placedpuyoprevonground = true
					board.placingpuyotouchedgroundtimer = $1 + 1
					if(cmd.forwardmove < -mininput)
						board.placingpuyotouchedgroundtimer = $1 + TICRATE/4//2
					end
				end
			else
				board.placedpuyoprevonground = false
			end

			leftpuyo = board.placingpuyo
			rightpuyo = board.placingpuyo
			bottompuyo = board.placingpuyo
			if(board.placingpuyorotate == 0)
				or(board.placingpuyorotate == 1 and (board.placingpuyotype == 1 or board.placingpuyotype == 2))
				or(board.placingpuyotype >= 5)
				rightpuyo = board.placingpuyo+1
			elseif(board.placingpuyorotate == 2)
				or(board.placingpuyorotate == 3 and (board.placingpuyotype == 1 or board.placingpuyotype == 2))
				leftpuyo = board.placingpuyo-1
			elseif(board.placingpuyorotate == 3)
				bottompuyo = board.placingpuyo+boardwidth
			end

			if(board.placingpuyotype == 1 or board.placingpuyotype == 2)
				and(board.placingpuyorotate == 0 or board.placingpuyorotate == 3)
				bottompuyo = board.placingpuyo+boardwidth
			end

			// Detect floors!
			if(board.placingpuyorotate == 0 or board.placingpuyorotate == 2)
				or(board.placingpuyotype == 1 or board.placingpuyotype == 2)
				if(boardtiles[leftpuyo] and boardtiles[leftpuyo].type)
					and not(yon and ((boardtiles[leftpuyo-boardwidth] and boardtiles[leftpuyo-boardwidth].type) or (boardtiles[rightpuyo-boardwidth] and boardtiles[rightpuyo-boardwidth].type)))
					board.placingpuyo = $1 - boardwidth
					board.placingpuyoyoffset = 0
				elseif(boardtiles[rightpuyo] and boardtiles[rightpuyo].type)
					and not(yon and ((boardtiles[leftpuyo-boardwidth] and boardtiles[leftpuyo-boardwidth].type) or (boardtiles[rightpuyo-boardwidth] and boardtiles[rightpuyo-boardwidth].type)))
					board.placingpuyo = $1 - boardwidth
					board.placingpuyoyoffset = 0
				end
			end

			if not(board.placingpuyorotate == 0 or board.placingpuyorotate == 2)
				or(board.placingpuyotype == 1 or board.placingpuyotype == 2)
				if(boardtiles[bottompuyo] and boardtiles[bottompuyo].type)
					board.placingpuyo = $1 - boardwidth
					board.placingpuyoyoffset = 0
				end
			end

			if(bottompuyo/boardwidth >= boardheight)
				board.placingpuyo = $1 - boardwidth
				//board.placingpuyo = $1 - (((bottompuyo/boardwidth) - boardheight)*boardwidth)
				board.placingpuyoyoffset = 0
			end

			if(board.placingpuyoshake)
				board.placingpuyoshake = $1 - 1
			end

			if(board.placingpuyotouchedgroundtimer > TICRATE)
				if not(board.placingpuyotype == 5)
					boardtiles[board.placingpuyo].type = board.placingpuyocolor[0]
					boardtiles[board.placingpuyo].inair = false
					boardtiles[board.placingpuyo].yoff = 0
				//	boardtiles[board.placingpuyo].shaking = 0
					if(boardtiles[board.placingpuyo+boardwidth] and boardtiles[board.placingpuyo+boardwidth].type)
						or((board.placingpuyo/boardwidth)+1 >= boardheight)
						boardtiles[lookForBottom(boardtiles, board.placingpuyo)-boardwidth].squish = 1
					end
				end
				if(board.placingpuyotype == 0)
					local puyoto
					if(board.placingpuyorotate == 0)
						puyoto = board.placingpuyo+1
					elseif(board.placingpuyorotate == 1)
						puyoto = board.placingpuyo-boardwidth
					elseif(board.placingpuyorotate == 2)
						puyoto = board.placingpuyo-1
					else
						puyoto = board.placingpuyo+boardwidth
					end
					boardtiles[puyoto].type = board.placingpuyocolor[1]
					boardtiles[puyoto].inair = false
					boardtiles[puyoto].yoff = 0
			//		boardtiles[puyoto].shaking = 0
					if(boardtiles[puyoto+boardwidth] and boardtiles[puyoto+boardwidth].type)
						or((puyoto/boardwidth)+1 >= boardheight)
						boardtiles[lookForBottom(boardtiles, puyoto)-boardwidth].squish = 1
					end
				elseif(board.placingpuyotype == 1)
					or(board.placingpuyotype == 2)
					local topcolor = board.placingpuyocolor[0]
					local sidecolor = board.placingpuyocolor[1]
					if(board.placingpuyotype == 2)
						topcolor = board.placingpuyocolor[1]
						sidecolor = board.placingpuyocolor[0]
					end
					local puyoto
					if(board.placingpuyorotate == 0)
						puyoto = board.placingpuyo+1
					elseif(board.placingpuyorotate == 1)
						puyoto = board.placingpuyo-boardwidth
					elseif(board.placingpuyorotate == 2)
						puyoto = board.placingpuyo-1
					else
						puyoto = board.placingpuyo+boardwidth
					end

				//	local oldpuyoto = puyoto

					boardtiles[puyoto].type = topcolor
					boardtiles[puyoto].inair = false
					boardtiles[puyoto].yoff = 0
				//	boardtiles[puyoto].shaking = 0
					boardtiles[puyoto].momentum = 0
					if(boardtiles[puyoto+boardwidth] and boardtiles[puyoto+boardwidth].type and not (board.placingpuyo == puyoto+boardwidth))
						or((puyoto/boardwidth)+1 >= boardheight)
						boardtiles[lookForBottom(boardtiles, puyoto)-boardwidth].squish = 1
					end

					if(board.placingpuyorotate == 1)
						puyoto = board.placingpuyo+1
					elseif(board.placingpuyorotate == 2)
						puyoto = board.placingpuyo-boardwidth
					elseif(board.placingpuyorotate == 3)
						puyoto = board.placingpuyo-1
					else
						puyoto = board.placingpuyo+boardwidth
					end

					boardtiles[puyoto].type = sidecolor
					boardtiles[puyoto].inair = false
					boardtiles[puyoto].yoff = 0
				//	boardtiles[puyoto].shaking = 0
					boardtiles[puyoto].momentum = 0
					if(boardtiles[puyoto+boardwidth] and boardtiles[puyoto+boardwidth].type and not (board.placingpuyo == puyoto+boardwidth))
						or((puyoto/boardwidth)+1 >= boardheight)
						boardtiles[lookForBottom(boardtiles, puyoto)-boardwidth].squish = 1
					end

				elseif(board.placingpuyotype == 5)
					local puyoto = {}
					puyoto[0] = board.placingpuyo
					puyoto[1] = board.placingpuyo+1
					puyoto[2] = board.placingpuyo-boardwidth
					puyoto[3] = board.placingpuyo-boardwidth+1
					local puyoto2 = {}
					puyoto2[0] = board.placingpuyo
					puyoto2[1] = board.placingpuyo+1
					puyoto2[2] = board.placingpuyo
					puyoto2[3] = board.placingpuyo+1
					local swirlcolors = {}
					if(board.placingpuyorotate == 0)
						or(board.placingpuyorotate == 1)
						swirlcolors[0] = board.placingpuyocolor[0]
						swirlcolors[3] = board.placingpuyocolor[1]
					else
						swirlcolors[0] = board.placingpuyocolor[1]
						swirlcolors[3] = board.placingpuyocolor[0]
					end
					if(board.placingpuyorotate == 1)
						or(board.placingpuyorotate == 2)
						swirlcolors[1] = board.placingpuyocolor[0]
						swirlcolors[2] = board.placingpuyocolor[1]
					else
						swirlcolors[1] = board.placingpuyocolor[1]
						swirlcolors[2] = board.placingpuyocolor[0]
					end
					local ptnum = 0
					while(ptnum < 4)
						boardtiles[puyoto[ptnum]].type = swirlcolors[ptnum]
						boardtiles[puyoto[ptnum]].inair = false
						boardtiles[puyoto[ptnum]].yoff = 0
					//	boardtiles[puyoto[ptnum]].shaking = 0
						if(boardtiles[puyoto2[ptnum]+boardwidth] and boardtiles[puyoto2[ptnum]+boardwidth].type)
							or((puyoto2[ptnum]/boardwidth)+1 >= boardheight)
							boardtiles[lookForBottom(boardtiles, puyoto2[ptnum])-boardwidth].squish = 1
						end
						ptnum = $1 + 1
					end
				elseif(board.placingpuyotype == 6)
					local puyoto = {}
					puyoto[0] = board.placingpuyo+1
					puyoto[1] = board.placingpuyo-boardwidth
					puyoto[2] = board.placingpuyo-boardwidth+1
					local puyoto2 = {}
					puyoto2[0] = board.placingpuyo+1
					puyoto2[1] = board.placingpuyo
					puyoto2[2] = board.placingpuyo+1
					local ptnum = 0
					while(ptnum < 3)
						boardtiles[puyoto[ptnum]].type = board.placingpuyocolor[0]
						boardtiles[puyoto[ptnum]].inair = false
						boardtiles[puyoto[ptnum]].yoff = 0
					//	boardtiles[puyoto[ptnum]].shaking = 0
						if(boardtiles[puyoto2[ptnum]+boardwidth] and boardtiles[puyoto2[ptnum]+boardwidth].type)
							or((puyoto2[ptnum]/boardwidth)+1 >= boardheight)
							boardtiles[lookForBottom(boardtiles, puyoto2[ptnum])-boardwidth].squish = 1
						end
						ptnum = $1 + 1
					end
				end
				board.placedsplit = true
				board.placingpuyo = ((bufferrows-1)*boardwidth)+2
				board.placingpuyonumber = 2
				board.placingpuyoyoffset = 0
				local nextpiece = chardata[character].dropset[(board.dropsetindex+1)%16]
				if(board.ljswap)
					if(nextpiece == 1)
						nextpiece = 3
					elseif(nextpiece == 2)
						nextpiece = 4
					elseif(nextpiece == 3)
						nextpiece = 1
					elseif(nextpiece == 4)
						nextpiece = 2
					end
				end
				if not(nextpiece >= 3 and nextpiece <= 5)
					or not(board.dropsets)
					board.placingpuyorotate = 1
					board.placingpuyorotate2 = 90*FRACUNIT
				elseif(nextpiece == 5)
					board.placingpuyorotate = 0
					board.placingpuyorotate2 = 0
				else
					board.placingpuyorotate = 2
					board.placingpuyorotate2 = 180*FRACUNIT
					board.placingpuyo = $1 + 1
				end
				board.placingpuyointendedrotate = board.placingpuyorotate
				board.placingpuyorotatedir = false
				board.placingpuyotouchedgroundtimer = 0
				board.placingpuyoshake = 0
				board.placedpuyoprevonground = false
				board.state = 1
			elseif(yon)
				leftpuyo = board.placingpuyo
				rightpuyo = board.placingpuyo
				bottompuyo = board.placingpuyo
				if(board.placingpuyorotate == 0)
					or(board.placingpuyorotate == 1 and (board.placingpuyotype == 1 or board.placingpuyotype == 2))
					or(board.placingpuyotype >= 5)
					rightpuyo = board.placingpuyo+1
				elseif(board.placingpuyorotate == 2)
					or(board.placingpuyorotate == 3 and (board.placingpuyotype == 1 or board.placingpuyotype == 2))
					leftpuyo = board.placingpuyo-1
				elseif(board.placingpuyorotate == 3)
					bottompuyo = board.placingpuyo+boardwidth
				end

				if(board.placingpuyorotate == 0 or board.placingpuyorotate == 2)
					or(board.placingpuyotype == 1 or board.placingpuyotype == 2)
					if(leftpuyo%boardwidth == boardwidth-1 and board.placingpuyo%boardwidth == 0)	// That doesn't make sense!
						or(boardtiles[leftpuyo] and boardtiles[leftpuyo].type)
						board.placingpuyo = $1 + 1	// Push out of the wall!
					elseif(rightpuyo%boardwidth == 0 and board.placingpuyo%boardwidth == boardwidth-1)	// That also doesn't make sense!
						or(boardtiles[rightpuyo] and boardtiles[rightpuyo].type)
						board.placingpuyo = $1 - 1		// Push out of the wall!
					end
				end

				leftpuyo = board.placingpuyo
				rightpuyo = board.placingpuyo
				bottompuyo = board.placingpuyo
				if(board.placingpuyorotate == 0)
					or(board.placingpuyorotate == 1 and (board.placingpuyotype == 1 or board.placingpuyotype == 2))
					or(board.placingpuyotype >= 5)
					rightpuyo = board.placingpuyo+1
				elseif(board.placingpuyorotate == 2)
					or(board.placingpuyorotate == 3 and (board.placingpuyotype == 1 or board.placingpuyotype == 2))
					leftpuyo = board.placingpuyo-1
				elseif(board.placingpuyorotate == 3)
					bottompuyo = board.placingpuyo+boardwidth
				end

				if(board.placingpuyotype == 1 or board.placingpuyotype == 2)
					and(board.placingpuyorotate == 0 or board.placingpuyorotate == 3)
					bottompuyo = board.placingpuyo+boardwidth
				end
			end

			local pnum = 0
			while(pnum < player.numplayers)
				board.playersinfever[pnum] = player.boards[pnum].fevermode
				pnum = $1 + 1
			end
		elseif(board.state == 1)	// Falling
			local puyomoving = false
			// Squishy!
			local tnum = boardwidth*boardheight
			while(tnum >= 0)
				if(boardtiles[tnum])
					if(boardtiles[tnum].squish)
						boardtiles[tnum].squish = $1 + FixedAngle(squishanglespeed)
						if(AngleFixed(boardtiles[tnum].squish) >= 180*FRACUNIT)
							boardtiles[tnum].squish = 0
						end
						puyomoving = true
					end

					boardtiles[tnum].bottompiece = lookForBottom(boardtiles, tnum)
				end
				tnum = $1 - 1
			end

			local numpuyo = 0

			tnum = boardwidth*boardheight
			if(board.placedsplit)
				while(tnum >= 0)
					if(boardtiles[tnum] and boardtiles[tnum].type)
						numpuyo = $1 + 1
						if not(tnum/boardwidth >= boardheight-1)
							and not(boardtiles[tnum+boardwidth] and boardtiles[tnum+boardwidth].type and not(boardtiles[tnum+boardwidth].momentum or boardtiles[tnum+boardwidth].yoff))
							and not(boardtiles[tnum].type == 8)
							puyomoving = true
							boardtiles[tnum].inair = true
							boardtiles[tnum].momentum = $1 + 1
							if(boardtiles[tnum].momentum > 8)
								boardtiles[tnum].momentum = 8
							end
							boardtiles[tnum].yoff = $1 + boardtiles[tnum].momentum
							// Transfer to the next tile!
							if(boardtiles[tnum].yoff >= 16)
								and not(boardtiles[tnum+boardwidth] and boardtiles[tnum+boardwidth].type and not boardtiles[tnum+boardwidth].momentum)
								boardtiles[tnum+boardwidth].type = boardtiles[tnum].type
								boardtiles[tnum+boardwidth].yoff = boardtiles[tnum].yoff-16
								boardtiles[tnum+boardwidth].momentum = boardtiles[tnum].momentum
								boardtiles[tnum].type = 0
								boardtiles[tnum].yoff = 0
								boardtiles[tnum].momentum = 0
								if(boardtiles[tnum+boardwidth+boardwidth] and boardtiles[tnum+boardwidth+boardwidth].type and not(boardtiles[tnum+boardwidth+boardwidth].momentum or boardtiles[tnum+boardwidth+boardwidth].yoff))
									or((tnum+boardwidth)/boardwidth >= boardheight-1)
									boardtiles[tnum+boardwidth].yoff = 0
									boardtiles[tnum+boardwidth].inair = false
									boardtiles[tnum+boardwidth].momentum = 0
									boardtiles[tnum].bottompiece = lookForBottom(boardtiles, tnum+boardwidth)
									boardtiles[boardtiles[tnum].bottompiece-boardwidth].squish = 1
								end
							elseif(boardtiles[tnum].yoff > 16)
								boardtiles[tnum].yoff = 15
								boardtiles[tnum].momentum = 0
							end
						end
					end
					tnum = $1 - 1
				end
			else
				if(board.fever)
					tnum = 0
				end

				while((tnum >= 0 and not board.fever) or (tnum < boardwidth*boardheight and board.fever))
					if(boardtiles[tnum] and boardtiles[tnum].type)
						numpuyo = $1 + 1

						// Also check if there's air between us and the ground, if there is we're in the air!
						local piece = tnum
						while(piece < boardwidth*boardheight)
							and not(boardtiles[tnum].inair)
							and not(boardtiles[piece] and boardtiles[piece].type == 8)
							if not(boardtiles[piece])
								or not(boardtiles[piece].type)
								puyomoving = true
								boardtiles[tnum].inair = true
							end
							piece = $1 + boardwidth
						end

						// Find the next top!
						local nexttop = tnum/boardwidth
						local add = tnum%boardwidth
						while(nexttop < boardheight-1)
							and not(boardtiles[(nexttop*boardwidth)+add] and boardtiles[(nexttop*boardwidth)+add].type and not(boardtiles[(nexttop*boardwidth)+add].inair))
							nexttop = $1 + 1
						end
						nexttop = $1 * boardwidth
						nexttop = $1 + add

						// Find the squish offset
						local bottom = boardtiles[tnum].bottompiece
						if(boardtiles[nexttop])
							bottom = boardtiles[nexttop].bottompiece
						end
						local offinpixels = GetSquishOff(boardtiles, nexttop, (nexttop-bottom)/boardwidth, bottom)
					//	if(boardtiles[tnum].yoff > offinpixels)
					//		boardtiles[tnum].yoff = offinpixels
					//	end
						if not(tnum/boardwidth >= boardheight-1)
							and not((boardtiles[tnum+boardwidth] and boardtiles[tnum+boardwidth].type and not boardtiles[tnum+boardwidth].momentum) and (boardtiles[tnum].yoff >= offinpixels+16 or(boardtiles[tnum+boardwidth].inair) or not(boardtiles[tnum].inair)))
							and not(board.fever and (boardtiles[tnum+boardwidth] and boardtiles[tnum+boardwidth].type) and not boardtiles[tnum+boardwidth].momentum)
							and not(boardtiles[tnum].type == 8)
							puyomoving = true
							if(board.fever)
								boardtiles[tnum].momentum = 8
							else
								boardtiles[tnum].momentum = 12//8
							end
							boardtiles[tnum].inair = true
							boardtiles[tnum].yoff = $1 + boardtiles[tnum].momentum
							local off = offinpixels
							// Transfer to the next tile!
							if(boardtiles[tnum].yoff >= 16+off)
								and not(boardtiles[tnum+boardwidth] and boardtiles[tnum+boardwidth].type)
								boardtiles[tnum+boardwidth].type = boardtiles[tnum].type
								boardtiles[tnum+boardwidth].yoff = boardtiles[tnum].yoff-16
								boardtiles[tnum+boardwidth].momentum = boardtiles[tnum].momentum
								boardtiles[tnum].type = 0
								boardtiles[tnum].inair = false
								boardtiles[tnum].yoff = 0
								boardtiles[tnum].momentum = 0
								if(boardtiles[tnum+boardwidth+boardwidth] and boardtiles[tnum+boardwidth+boardwidth].type and not boardtiles[tnum+boardwidth+boardwidth].momentum)
									or((tnum+boardwidth)/boardwidth >= boardheight-1)
									boardtiles[tnum].inair = false
									boardtiles[tnum+boardwidth].yoff = 0
									boardtiles[tnum+boardwidth].inair = false
									boardtiles[tnum+boardwidth].momentum = 0
									boardtiles[tnum].bottompiece = lookForBottom(boardtiles, tnum+boardwidth)
									if(board.fever)
									//	local targetsin = sin(board.squish[tnum%boardwidth])
									//	local noarcsinrip = cos(board.squish[tnum%boardwidth])
									//	targetsin = $1 + (FRACUNIT/2)
									//	noarcsinrip = $1 * 6/7
									//	board.squish[tnum%boardwidth] = R_PointToAngle2(0, 0, targetsin, noarcsinrip)
										if(AngleFixed(boardtiles[boardtiles[tnum].bottompiece-boardwidth].squish) < 90*FRACUNIT)
											boardtiles[boardtiles[tnum].bottompiece-boardwidth].squish = $1 + FixedAngle(squishanglespeed)
											if(AngleFixed(boardtiles[boardtiles[tnum].bottompiece-boardwidth].squish) > 90*FRACUNIT)
												boardtiles[boardtiles[tnum].bottompiece-boardwidth].squish = FixedAngle(90*FRACUNIT)
											end
										else
											boardtiles[boardtiles[tnum].bottompiece-boardwidth].squish = $1 - FixedAngle(squishanglespeed*2)
											if(AngleFixed(boardtiles[boardtiles[tnum].bottompiece-boardwidth].squish) < 90*FRACUNIT)
												boardtiles[boardtiles[tnum].bottompiece-boardwidth].squish = FixedAngle(90*FRACUNIT)
											end
										end
									else
										boardtiles[boardtiles[tnum].bottompiece-boardwidth].squish = 1
									end
									if(boardtiles[tnum+boardwidth].type == 6)
										and not(board.garbagesoundyet)
										and(board.garbagehasdropped)
										board.garbagesoundyet = true
										PlaySound(player, sfx_trash1+board.garbagedropsound)
									end
								end
						//	elseif(boardtiles[tnum].yoff > 16)
						//		boardtiles[tnum].yoff = 15
						//		boardtiles[tnum].momentum = 0
							end
						else
							boardtiles[tnum].yoff = 0
							boardtiles[tnum].momentum = 0
						end
					end
					if(board.fever)
						tnum = $1 + 1
					else
						tnum = $1 - 1
					end
				end
			end

			if not(numboard and player.stagenum)
				if not(board.fevermode)
					if(numpuyo > boardwidth*(boardheight-bufferrows-3))
						and not(board.panic)
						board.panic = true
						if not(panicplayer == nil)
							S_ChangeMusic("WARNS", true, panicplayer)
						end
					elseif(numpuyo < boardwidth*(boardheight-bufferrows-4))
						and(board.panic)
						board.panic = false
						if not(panicplayer == nil)
							if(player.stagenum)
								S_ChangeMusic(stagemusic[player.stagenum], true, panicplayer)
							else
								S_ChangeMusic(musicoptions[panicplayer.musicoption].musicslot, true, panicplayer)
							end
						end
					end
				end
			end

			// All clear!
			if(numpuyo == 0)
				and(board.matchhasstarted)
				and(board.giveallclearbonus)
				and not(board.allclearrules)
				board.allclear = true
				PlaySound(player, sfx_clear)
			elseif(numpuyo == 0)
				and(board.matchhasstarted)
				and(board.giveallclearbonus)
				and not(board.allcleartimer)
				and(board.allclearrules == 1)
				board.allcleartimer = TICRATE*2
				PlaySound(player, sfx_clear)
				if not(board.fevermode)
					and not(board.fevermeter == 7)
					local randomchain = P_RandomByte()%numfeverchains
					local tnum = 0
					while(tnum < boardwidth*boardheight)
						if(feverchains[randomchain][board.colors][1][tnum])
							boardtiles[tnum].type = board.colorslist[feverchains[randomchain][board.colors][1][tnum]-1]
							boardtiles[tnum].inair = false
						else
							boardtiles[tnum].type = 0
							boardtiles[tnum].inair = false
						end
						tnum = $1 + 1
					end
					// Set the board's yoff
					board.boardyoff = (-(boardheight-bufferrows)*16)-(16*boardheight)
				end
			end

			if(numpuyo == 0)
				and(board.matchhasstarted)
				and(board.giveallclearbonus)
				and not(board.allclearrules == 2)
				if(board.fevermeter == 7)
					and not(board.fevermode)
					board.feverchain = $1 + 2
					if(board.feverchain > 12)
						board.feverchain = 12
					end
				end
				if(board.fevertime)
					or not(board.fevermode)
					board.fevertime = $1 + (FRACUNIT*5)
					if(board.fevertime > 30*FRACUNIT)
						board.fevertime = 30*FRACUNIT
					end
				end
			end

			if not(puyomoving)			// No puyo moving?
				and not(board.boardyoff)	// Not if the entire board is moving!
				board.state = 2				// Next state! (popping)
			end
		elseif(board.state == 2)
			// Remove groups of four!
			local tnum = boardwidth*bufferrows
			local popped = false
			// Scoring!
			local totalpuyopopped = 0
			local groups = {}
			local numgroups = 0
			local colorscleared = 0
			local colorsclearedlist = {}
			colorsclearedlist[1] = false	// Red
			colorsclearedlist[2] = false	// Green
			colorsclearedlist[3] = false	// Blue
			colorsclearedlist[4] = false	// Yellow
			colorsclearedlist[5] = false	// Purple
			board.lastmaxnumpopped = 0
			board.spelldone = false
			local numpuyo = 0
			while(tnum < boardwidth*boardheight)
				if(boardtiles[tnum].type)
					and not(boardtiles[tnum].lookedfor)
					and not(boardtiles[tnum].removetime)
					local numberofpuyo = RemovePuyoGroup(boardtiles, tnum)
					if(numberofpuyo >= 4)
						// Score!
						totalpuyopopped = $1 + numberofpuyo
						groups[numgroups] = numberofpuyo-4
						numgroups = $1 + 1
						if not(colorsclearedlist[boardtiles[tnum].type])
							colorscleared = $1 + 1
							colorsclearedlist[boardtiles[tnum].type] = true
						end

						if(numberofpuyo > board.lastmaxnumpopped)
							board.lastmaxnumpopped = numberofpuyo
						end
						RemovePuyoGroupVeryInoptimal(boardtiles, tnum, 0, board.fever, board.fevermode)
						popped = true
					end
				end
				if(boardtiles[tnum].type)
					numpuyo = $1 + 1
				end
				tnum = $1 + 1
			end
			board.lastnumgroups = numgroups

			tnum = 0
			while(tnum < boardwidth*boardheight)
				boardtiles[tnum].lookedfor = false
				boardtiles[tnum].yoff = 0
				boardtiles[tnum].inair = false
				boardtiles[tnum].momentum = 0
				tnum = $1 + 1
			end
			if not(popped)
				if(board.fevermode)
					if(board.chain)
					//	and not(board.fevervoicetime)	// Kindof hacky
						board.feverdelaytimer = fevernextdelay
						if(board.fevertime)
							if(board.prevdiacutes > 1)
								board.fevervocietime = TICRATE/18*10
							else
								board.fevervocietime = TICRATE/6
							end
						end
						if(board.chain-(board.feverchain+3) >= 0)	// Got the chain?
							board.feverchain = $1 + 1
							if not(numpuyo)
								board.feverchain = $1 + 1
							end
							board.fevervoice = 0
						elseif(board.chain-(board.feverchain+3) == -1)	// 1 less?
							board.feverchain = $1 - 1
							board.fevervoice = 1
						else
							board.feverchain = $1 - 2
							board.fevervoice = 1
						end

						if(board.feverchain > 12)
							board.feverchain = 12
						elseif(board.feverchain < 0)
							board.feverchain = 0
						end

						if(board.fevertime)
							local randomchain = P_RandomByte()%numfeverchains
							local tnum = 0
							while(tnum < boardwidth*boardheight)
								if(boardtiles[tnum].type and boardtiles[tnum].type < 6)
									local enum = 0
									local madeeffect = false
									while(enum < numeffects)
										and not(madeeffect)
										if not(board.effectstype[enum])
											madeeffect = true
											board.effectstype[enum] = boardtiles[tnum].type+5
											board.effectsx[enum] = ((tnum%boardwidth)*16)*FRACUNIT
											board.effectsy[enum] = (((tnum/boardwidth)-bufferrows)*16)*FRACUNIT
											local dir = FixedAngle(P_RandomRange(45, 135)*FRACUNIT)
											board.effectsxspeed[enum] = FixedMul(cos(dir), FRACUNIT*5)
											board.effectsyspeed[enum] = -FixedMul(sin(dir), FRACUNIT*5)
											board.effectstimer[enum] = effecttime*5/2
										end
										enum = $1 + 1
									end
								end

								if(feverchains[randomchain][board.colors][board.feverchain][tnum])
									boardtiles[tnum].type = board.colorslist[feverchains[randomchain][board.colors][board.feverchain][tnum]-1]
								else
									boardtiles[tnum].type = 0
								end
								tnum = $1 + 1
							end
							// Set the board's yoff
							board.boardyoff = (-(boardheight-bufferrows)*16)-(16*boardheight)
						end
					elseif not(board.fevertime)
						MakeBoardFromTiles(boardtiles, board, board.fevermode)
						board.fevermode = false
						boardtiles = MakeTilesFromBoard(board, false)
						board.fevermeter = 0
						board.fevertime = 15*FRACUNIT
						board.giveallclearbonus = false
						board.state = 4
						board.feverswitchtime = feverswitchtime
						// Add fever garbage to the normal board!
						board.garbagetray = $1 + board.fevergarbagetray
						board.fevergarbagetray = 0
						local bnum = 0
						while(bnum < player.numplayers)
							board.extragarbage[bnum] = $1 + board.feverextragarbage[bnum]
							board.feverextragarbage[bnum] = 0
							bnum = $1 + 1
						end

						local cnum = 0
						while(cnum < player.numplayers)
							if not(cnum and player.stagenum)
								and(player.clients[cnum] >= 0 and players[player.clients[cnum]] and players[player.clients[cnum]].valid)
								if(player.boards[cnum].panic)
									S_ChangeMusic("WARNS", true, players[player.clients[cnum]])
								else
									if(player.stagenum)
										S_ChangeMusic(stagemusic[player.stagenum], true, players[player.clients[cnum]])
									else
										S_ChangeMusic(musicoptions[players[player.clients[cnum]].musicoption].musicslot, true, players[player.clients[cnum]])
									end
								end
							end
							cnum = $1 + 1
						end
					end
				end
				if not(board.garbagehasdropped)
					and not(board.lostyoff)
					board.state = 4
				else
					if(boardtiles[(boardwidth*bufferrows)+2].type)	// X filled?
						or(boardtiles[(boardwidth*bufferrows)+3].type and board.dropsets)
						if(rpgblast)
							if(player.mo and player.mo.valid)
								if(player.puyotarget and player.puyotarget.valid)
									P_KillMobj(player.mo, player.puyotarget)
								else
									P_KillMobj(player.mo)
								end
							end
							player.gamestate = -1
							MakeBoardFromTiles(boardtiles, board, board.fevermode)
							return
						elseif not(board.lostyoff)
							and not(player.matchended)
							PlaySound(player, sfx_pplose)
							board.lostyoff = 1
						//	print("Player "+(numboard+1)+" lost!")
						end
					end

					if not(board.lostyoff)
						// Enter fever mode! (was at the top of state 0, but that caused the next puyo to be given twice)
						if(board.fevermeter >= 7)
							and not(board.fevermode)
							MakeBoardFromTiles(boardtiles, board, board.fevermode)
							board.fevermode = true
							board.fevermeter = 0
							board.feverdelaytimer = feverenterdelay
							board.giveallclearbonus = false
							board.feverswitchtime = feverswitchtime
							PlaySound(player, sfx_arlef1, player.characters[numboard])
							local cnum = 0
							while(cnum < player.numplayers)
								if(player.clients[cnum] >= 0)
									and(players[player.clients[cnum]] and players[player.clients[cnum]].valid)
									S_ChangeMusic(fevermusicoptions[players[player.clients[cnum]].fevermusicoption].musicslot, true, players[player.clients[cnum]])
								end
								cnum = $1 + 1
							end

							boardtiles = MakeTilesFromBoard(board, true)
							local randomchain = P_RandomByte()%numfeverchains
							local tnum = 0
							while(tnum < boardwidth*boardheight)
								if(feverchains[randomchain][board.colors][board.feverchain][tnum])
									boardtiles[tnum].type = board.colorslist[feverchains[randomchain][board.colors][board.feverchain][tnum]-1]
								else
									boardtiles[tnum].type = 0
								end
								tnum = $1 + 1
							end
							// Set the board's yoff
							board.boardyoff = (-(boardheight-bufferrows)*16)-(16*boardheight)
							board.state = 1
							MakeBoardFromTiles(boardtiles, board, true)
							return
						end

						board.state = 0
						if not(player.matchended)
							if(board.matchhasstarted)
								board.nexttime = 8
								if(board.placingpuyotype == 6)	// Big puyo?
									board.placingpuyoindex = ($1 + 1)%256	// Only move one forward!
								else
									board.placingpuyoindex = ($1 + 2)%256
								end
							end
							board.placingpuyocolor[0] = player.puyolists[board.colors][(board.placingpuyoindex)%256]
							board.placingpuyocolor[1] = player.puyolists[board.colors][(board.placingpuyoindex+1)%256]
							if(board.matchhasstarted)
								board.dropsetindex = ($1 + 1)%16
								if(board.dropsets)
									board.placingpuyotype = chardata[character].dropset[board.dropsetindex]
								else
									board.placingpuyotype = 0
								end
								if(board.ljswap)
									if(board.placingpuyotype == 1)
										board.placingpuyotype = 3
									elseif(board.placingpuyotype == 2)
										board.placingpuyotype = 4
									elseif(board.placingpuyotype == 3)
										board.placingpuyotype = 1
									elseif(board.placingpuyotype == 4)
										board.placingpuyotype = 2
									end
								end
								if(board.placingpuyotype == 3)
									board.placingpuyotype = 2
								elseif(board.placingpuyotype == 4)
									board.placingpuyotype = 1
								elseif(board.placingpuyotype == 6)
									if(board.ljswap)
										board.ljswap = false
									else
										board.ljswap = true
									end
								end
							end
							if(board.placingpuyotype == 5)
								and(board.placingpuyocolor[0] == board.placingpuyocolor[1])
								board.placingpuyocolor[1] = player.puyolistsalt[board.colors][(board.placingpuyoindex+1)%256]
							end
						end
					end
				end
				board.chain = 0
			else
				if(board.fevermode)
					and(ChainResolved(boardtiles))
					and(board.fevertime > 0)
				//	if(board.chain-(board.feverchain+2) >= 0)
					if(board.chain > 2)	// 4 or higher
						board.fevertime = $1 + ((FRACUNIT/2)*(board.chain-1))
					//	local val = ((FRACUNIT/2)*(board.chain-1))	// Pointless...?
						if(board.fevertime > 30*FRACUNIT)
							board.fevertime = 30*FRACUNIT
						end
					end
				end
				local score = CalculateScoreBonus(totalpuyopopped, board.chain, colorscleared, groups, board.scorerules)
				board.score = $1 + score

				board.scorehalf1 = totalpuyopopped*10
				board.scorehalf2 = score/board.scorehalf1
				board.scoretimer = scoretimer

				local garbagegenerated = CalculateGarbage(score, board)
				if(board.allclear)
					garbagegenerated = $1 + 29	// Free rock!
					board.allclear = false
				end
				// Offsetting!
				if not(board.garbagerules == 2)
					if(board.fevergarbagetray)
						board.fevergarbagetray = $1 - garbagegenerated
						if(board.fevergarbagetray < 0)
							garbagegenerated = -board.fevergarbagetray
							board.fevergarbagetray = 0
						else
							garbagegenerated = 0
						end

						if(board.garbagerules == 1)	// Fever garbage rules
							board.fevergarbagedelay = true
						end
					end
					local enum = 0
					while(enum < player.numplayers)
						if(board.feverextragarbage[enum])
							board.feverextragarbage[enum] = $1 - garbagegenerated
							if(board.feverextragarbage[enum] < 0)
								garbagegenerated = -board.feverextragarbage[enum]
								board.feverextragarbage[enum] = 0
							else
								garbagegenerated = 0
							end

							if(board.garbagerules == 1)	// Fever garbage rules
								board.fevergarbagedelay = true
							end
						end
						enum = $1 + 1
					end

					local offsetted = false

					if(board.garbagetray)
						board.garbagetray = $1 - garbagegenerated
						if(board.garbagetray < 0)
							garbagegenerated = -board.garbagetray
							board.garbagetray = 0
						else
							garbagegenerated = 0
						end

						if(board.garbagerules == 1)	// Fever garbage rules
							board.fevergarbagedelay = true
						end

						offsetted = true
					end
					enum = 0
					while(enum < player.numplayers)
						if(board.extragarbage[enum])
							board.extragarbage[enum] = $1 - garbagegenerated
							if(board.extragarbage[enum] < 0)
								garbagegenerated = -board.extragarbage[enum]
								board.extragarbage[enum] = 0
							else
								garbagegenerated = 0
							end

							if(board.garbagerules == 1)	// Fever garbage rules
								board.fevergarbagedelay = true
							end

							offsetted = true
						end
						enum = $1 + 1
					end

					if(offsetted)
						if(board.fever)
							board.fevermeter = $1 + 1
							if(board.fevermeter >= 7)
								board.fevermeter = 7
							end

							local pnum = 0
							while(pnum < player.numplayers)
								if not(pnum == numboard)
									player.boards[pnum].fevertime = $1 + FRACUNIT
									if(player.boards[pnum].fevertime > 30*FRACUNIT)
										player.boards[pnum].fevertime = 30*FRACUNIT
									end
								end
								pnum = $1 + 1
							end
						end
					end
				end
				if(garbagegenerated)
					// Attack!
					if(rpgblast)
						and(player.puyotarget and player.puyotarget.valid)
						and(player.mo and player.mo.valid)
						local oldattack = player.stats.attack
						player.stats.attack = $1 + (garbagegenerated/2)
						player.puyotarget.dmgtimer = 0		// Can be damaged again right away!
						P_DamageMobj(player.puyotarget, player.mo, player.mo)
						player.stats.attack = oldattack
					end

					local bnum = 0
					while(bnum < player.numplayers)
						if not(bnum == numboard)
							// Add garbage!
							if(board.playersinfever[bnum])
								player.boards[bnum].feverextragarbage[numboard] = $1 + garbagegenerated
							else
								player.boards[bnum].extragarbage[numboard] = $1 + garbagegenerated
							end
						end
						bnum = $1 + 1
					end
				end
			//	board.extragarbage = $1 + CalculateGarbage(score, board)
				board.state = 3
				board.flashtime = flashtime
				if(board.fevermode)
					board.flashtime = $1/2
				end
			end
		elseif(board.state == 3)
			local firstpoppedpuyo = -1

			local poppingpuyo = false
			local tnum = 0
			while(tnum < boardwidth*boardheight)
				if(boardtiles[tnum].removetime)
					if(firstpoppedpuyo < 0)
						firstpoppedpuyo = tnum
					end
					if not(board.flashtime)
						boardtiles[tnum].removetime = $1 - 1
					end
					poppingpuyo = true
					if not(boardtiles[tnum].removetime)
					//	boardtiles[tnum].removetime = 0
						// Effects
						if(boardtiles[tnum].type < 6)
							local enum = 0
							local madeeffects = 0
							while(enum < numeffects)
								and(madeeffects < 4)
								if not(board.effectstype[enum])
									madeeffects = $1 + 1
									board.effectstype[enum] = boardtiles[tnum].type
									board.effectsx[enum] = (((tnum%boardwidth)*16)+8)*FRACUNIT
									board.effectsy[enum] = ((((tnum/boardwidth)-bufferrows)*16)+12)*FRACUNIT
									local dir = FixedAngle((90-50+(20*madeeffects))*FRACUNIT)
									board.effectsxspeed[enum] = FixedMul(cos(dir), FRACUNIT*5)
									board.effectsyspeed[enum] = -FixedMul(sin(dir), FRACUNIT*5)
									board.effectstimer[enum] = effecttime
								end
								enum = $1 + 1
							end
						end
						boardtiles[tnum].type = 0
					end
				end
				tnum = $1 + 1
			end

			if(board.flashtime)
				board.flashtime = $1 - 1
				if not(board.flashtime)
					// Chain text
					board.chaineffectnumber = board.chain
					board.chaineffecttimer = 1
					board.chaineffectoriginpuyo = firstpoppedpuyo

					if(board.voicepattern == 1)
						local resolved = ChainResolved(boardtiles)
						if((resolved)
							or(board.lastnumgroups > 1 and board.chain > 4-1 and not board.spelldone)
							or(board.lastmaxnumpopped > 6 and board.chain > 4-1 and not board.spelldone))
							and(board.chain)
							if(board.chain < 7)
								PlaySound(player, sfx_ppop1 + board.chain)
							else
								PlaySound(player, sfx_ppop1 + 6)
							end
							local sound = sfx_arles1
							if not(resolved)
								if(board.lastmaxnumpopped > 4)
									sound = sfx_arles2	// Ice Storm
									board.cutin = 1
								else
									sound = sfx_arles1	// Fire
									board.cutin = 0
								end
							elseif(board.chain >= 8-1)
/*								if(board.chain >= 9-1 and not(board.lastmaxnumpopped > 4))
									or(board.lastnumgroups > 1)
									or not(chardata[character].hassixthspell)*/
									sound = sfx_arles5	// Bayoen
									board.cutin = 4
/*								else
									sound = sfx_arles6	// Heaven Ray
									board.cutin = 3
								end*/
							elseif(board.chain >= 6-1)
								if(board.lastnumgroups > 1)
									sound = sfx_arles4	// Jugem
									board.cutin = 3
								else
									sound = sfx_arles3	// Brain dumbed
									board.cutin = 2
								end
							else
							/*	if(board.lastnumgroups > 1)
									sound = sfx_arles7	// Should be thunder
									board.cutin = thundercutin
								else*/if(board.lastmaxnumpopped > 4)
									sound = sfx_arles2	// Ice Storm
									board.cutin = 1
								else
									board.cutin = 0
								end
							end
							board.cutintime = 1
							PlaySound(player, sound, character)
							board.diacutevoice = sound
							if(board.diacutes)
								board.diacutetimer = diacutetime*board.diacutes
							end
							board.spelldone = true
						elseif(board.chain < 4)
							PlaySound(player, sfx_ppop1 + board.chain)
							PlaySound(player, sfx_arlec1 + board.chain, character)
						elseif(board.chain < 7)
							PlaySound(player, sfx_ppop1 + board.chain)
							PlaySound(player, sfx_arlec1 + 4, character)
							board.diacutes = $1 + 1
							board.diacutevoice = 0
						else
							PlaySound(player, sfx_ppop1 + 6)
							PlaySound(player, sfx_arlec1 + 4, character)
							board.diacutes = $1 + 1
							board.diacutevoice = 0
						end
					else
						local voicelist = {}
						if(chardata[character].voicepattern == nil)
							voicelist[0] = sfx_arlec1
//							voicelist[1] = sfx_arles1
//							voicelist[2] = sfx_arles2
//							voicelist[3] = sfx_arlec5
							voicelist[1] = sfx_arlec2
							voicelist[2] = sfx_arles1
							voicelist[3] = sfx_arles2
							voicelist[4] = sfx_arles3
							voicelist[5] = sfx_arles4
							voicelist[6] = sfx_arles5
						else
							voicelist[0] = chardata[character].voicepattern[0]+sfx_arles
							voicelist[1] = chardata[character].voicepattern[1]+sfx_arles
							voicelist[2] = chardata[character].voicepattern[2]+sfx_arles
							voicelist[3] = chardata[character].voicepattern[3]+sfx_arles
							voicelist[4] = chardata[character].voicepattern[4]+sfx_arles
							voicelist[5] = chardata[character].voicepattern[5]+sfx_arles
							voicelist[6] = chardata[character].voicepattern[6]+sfx_arles
						end
						if(board.voicepattern == 2)
							voicelist[4] = voicelist[6]
							voicelist[5] = voicelist[6]
						//	voicelist[6] =  voicelist[6]
						end
						local voicetoplay = board.chain
						if(board.chain > 6)
							voicetoplay = 6
						end
						voicetoplay = voicelist[$1]-sfx_arles
						if(ChainResolved(boardtiles))
							if(voicetoplay == 6)
								board.cutin = 0
								board.cutintime = 1
							elseif(voicetoplay == 7)
								board.cutin = 1
								board.cutintime = 1
							elseif(voicetoplay == 8)
								board.cutin = 2
								board.cutintime = 1
							elseif(voicetoplay == 9)
								board.cutin = 3
								board.cutintime = 1
							elseif(voicetoplay == 10)
								board.cutin = 4
								board.cutintime = 1
							end
						end
						if(board.chain < 7)
							PlaySound(player, sfx_ppop1 + board.chain)
							PlaySound(player, voicelist[board.chain], character)
							if(voicelist[board.chain]-sfx_arles == 5)
								board.diacutes = $1 + 1
								board.diacutevoice = 0
							else
								board.diacutevoice = voicelist[board.chain]
								if(board.diacutes)
									board.diacutetimer = diacutetime*board.diacutes
								end
							end
						else
							PlaySound(player, sfx_ppop1 + 6)
							PlaySound(player, voicelist[6], character)
							board.diacutevoice = voicelist[6]
							if(board.diacutes)
								board.diacutetimer = diacutetime*board.diacutes
							end
						end
					end
					board.chain = $1 + 1
					if(board.diacutes > 3)
						board.diacutes = 3
					end
					board.prevdiacutes = board.diacutes
				end
			end

			if not(poppingpuyo)
				board.state = 1
				board.placedsplit = false
			end
		elseif(board.state == 4)
			if(board.fevergarbagedelay)
				board.state = 1
				board.garbagehasdropped = true
			else
				local garbagetray = board.garbagetray
				if(board.fevermode)
					garbagetray = board.fevergarbagetray
				end
				if(garbagetray < boardwidth*2)
					board.garbagedropsound = 0
				else
					board.garbagedropsound = 1
				end

				if(garbagetray >= boardwidth*3)
					PlaySound(player, sfx_arled2, character)
				elseif(garbagetray >= boardwidth)
					PlaySound(player, sfx_arled1, character)
				end
				board.placedsplit = false
				local collumn = 0
				local roundeddown = garbagetray/6
				if(roundeddown > 5)
					roundeddown = 5
				end
				local offsets = {}
				local onum = 0
				while(onum < boardwidth)
					offsets[onum] = P_RandomByte()%24
					onum = $1 + 1
				end
				local droppedgarbage = 0
				while(collumn < boardwidth)
					local pnum = roundeddown-1
					while(pnum >= 0)
						and(garbagetray)
						and(droppedgarbage < 5*boardwidth)
						local row = pnum*boardwidth
						if not(boardtiles[row+collumn].type)
							boardtiles[row+collumn].type = 6
							boardtiles[row+collumn].yoff = offsets[collumn]
						//	boardtiles[row+collumn].shaking = 0
							garbagetray = $1 - 1
							droppedgarbage = $1 + 1
						end
						pnum = $1 - 1
					end
					collumn = $1 + 1
				end
				local randomdroplist = {}
				local rnum = 0
				while(rnum < boardwidth)
					randomdroplist[rnum] = rnum
					rnum = $1 + 1
				end
				while(droppedgarbage < 5*boardwidth)
					and(garbagetray)
					and(rnum)
					local tpos = P_RandomByte()%rnum
					local pos = randomdroplist[tpos]
					randomdroplist = RemoveFromTable(randomdroplist, tpos, rnum)
					rnum = $1 - 1
					if not(boardtiles[bufferrows-roundeddown+pos].type)
						boardtiles[bufferrows-roundeddown+pos].type = 6
						boardtiles[bufferrows-roundeddown+pos].yoff = offsets[pos]
					//	boardtiles[bufferrows-roundeddown+pos].shaking = 0
					end
					droppedgarbage = $1 + 1
					garbagetray = $1 - 1
				end
				if(board.fevermode)
					board.fevergarbagetray = garbagetray
				else
					board.garbagetray = garbagetray
				end
				board.state = 1
				board.garbagehasdropped = true
			end
		end
	end

	// Effects
	local enum = 0
	while(enum < numeffects)
		if(board.effectstype[enum])
			board.effectsx[enum] = $1 + board.effectsxspeed[enum]
			board.effectsy[enum] = $1 + board.effectsyspeed[enum]
			board.effectsyspeed[enum] = $1 + (FRACUNIT/2)
			if(board.effectstimer[enum])
				board.effectstimer[enum] = $1 - 1
			else
				board.effectstype[enum] = 0
			end
		end
		if(board.effectstype[enum] >= 6)
			board.effectsx[enum] = $1 + board.effectsxspeed[enum]
			board.effectsy[enum] = $1 + board.effectsyspeed[enum]
			board.effectsyspeed[enum] = $1 + (FRACUNIT/2)
			if(board.effectstimer[enum])
				board.effectstimer[enum] = $1 - 1
			else
				board.effectstype[enum] = 0
			end
		end
		enum = $1 + 1
	end

	if not(board.feverdelaytimer)
		and not(board.feverswitchtime)
		if(board.nexttime)
			and not(board.boardyoff)
			board.nexttime = $1 - 1
		end

		if(board.fevertime)
			and(board.fevermode)
			board.fevertime = $1 - FRACUNIT/TICRATE
			if(board.fevertime < 0)
				board.fevertime = 0
			end
		end

		// Drop puyo
		if(board.boardyoff)
			board.boardyoff = $1 + 16
			// Squish
			if(board.boardyoff >= 0)
				board.boardyoff = 0
			end
			if(abs(board.boardyoff)%16 == 0)
				and(board.boardyoff >= -(boardheight*16))
				local height = (board.boardyoff+(boardheight*16))/16
			//	print(height)
				height = $1 * boardwidth
				local starttile = boardwidth*(boardheight-1)
				local stnum = 0
				while(stnum < boardwidth)
					if(boardtiles[starttile+stnum-height] and boardtiles[starttile+stnum-height].type)
						if(AngleFixed(boardtiles[starttile+stnum].squish) < 90*FRACUNIT)
							boardtiles[starttile+stnum].squish = $1 + FixedAngle(squishanglespeed)
							if(AngleFixed(boardtiles[starttile+stnum].squish) > 90*FRACUNIT)
								boardtiles[starttile+stnum].squish = FixedAngle(90*FRACUNIT)
							end
						else
							boardtiles[starttile+stnum].squish = $1 - FixedAngle(squishanglespeed*2)
							if(AngleFixed(boardtiles[starttile+stnum].squish) < 90*FRACUNIT)
								boardtiles[starttile+stnum].squish = FixedAngle(90*FRACUNIT)
							end
						end
					end
					stnum = $1 + 1
				end
			end
		end

		if(board.fevervocietime)
			board.fevervocietime = $1 - 1
			if not(board.fevervocietime)
				if(board.fevervoice == 0)
					PlaySound(player, sfx_arlef3, player.characters[numboard])
				else
					PlaySound(player, sfx_arlef2, player.characters[numboard])
				end
			end
		end
	elseif(board.feverdelaytimer)
		board.feverdelaytimer = $1 - 1
	end

	if(board.diacutetimer)
		and(board.diacutes)
		board.diacutetimer = $1 - 1
		if(board.diacutetimer%diacutetime == 0)
			PlaySound(player, board.diacutevoice, character)
		end
	elseif(board.diacutevoice)
		board.diacutes = 0
	end

	if(board.scoretimer)
		board.scoretimer = $1 - 1
	end

	local bnum = 0
	while(bnum < player.numplayers)
		if not(bnum == numboard)
			// Add garbage!
			if not(player.boards[bnum].state == 1 or player.boards[bnum].state == 2 or player.boards[bnum].state == 3)
				board.garbagetray = $1 + board.extragarbage[bnum]
				board.extragarbage[bnum] = 0
				board.fevergarbagetray = $1 + board.feverextragarbage[bnum]
				board.feverextragarbage[bnum] = 0
			end
		end
		bnum = $1 + 1
	end

	if(board.cutintime)
		board.cutintime = $1 + 1
		if(board.cutintime > cutintime)
			board.cutintime = 0
		end
	end

	if(board.allcleartimer)
		board.allcleartimer = $1 - 1
	end

	board.prevbuttons = cmd.buttons
	board.prevsidemove = cmd.sidemove
	board.prevforwardmove = cmd.forwardmove

	MakeBoardFromTiles(boardtiles, board, board.fevermode)
end

// From RPG Blast
local function dmgformula(playeratk,enemydef)
	local result,crit = max(1,playeratk-enemydef)
	if (P_RandomRange(1,5) == 5)		// critical hit
		result,crit = $1*2,true
	end
	return result,crit
end

/*
addHook("MobjThinker", function(mobj)
	if not(mobj.flags & MF_ENEMY)
		or not(rpgblast)
		return
	end

	for player in players.iterate
		if(player.mo and player.mo.valid)
			if(R_PointToDist2(mobj.x, mobj.y, player.mo.x, player.mo.y) < 200*FRACUNIT)
				and not(player.puyotarget and player.puyotarget.valid)
				player.puyotarget = mobj
				if(player.gamestate < 0)
					player.gamestate = 0
					StartGame(player)
				end
			end
		end
	end
end)
*/

local addedskins = {}
local skinchars = {}
addHook("ThinkFrame", function()
	// Add skin characters
	local snum = 0
	while(snum < #skins)
		local sname = skins[snum].name
		if not(rawget(_G, sname+"_puyoinfo"))
			or(addedskins[sname])
			snum = $1 + 1
			continue
		end

		// Make the cut-in functions!
		local chr = rawget(_G, sname+"_puyoinfo")
		if(chr.cifuncs)
			chr.cutins = {}
			local cnum = 0
			while(cnum <= 8)
				chr.cutins[cnum] = PP_AddCutin(chr.cifuncs[cnum])
				cnum = $1 + 1
			end
		end

		// Add the character
		skinchars[sname] = PP_AddCharacter(chr)
		addedskins[sname] = true

		snum = $1 + 1
	end

	local numiterates = 0
	for player in players.iterate
		if not(mapheaderinfo[gamemap].arlepuyopoptsuu)
			or(splitscreen and #player and not mapheaderinfo[gamemap].multipuyo)
			or(numiterates > 17)	// Prevents crashes... kinda dumb though
			// Uninitialize everything!
			if not(player.gamestate == nil)
				and(player.gamestate >= 0)
				player.gamestate = -1

				player.totalscore = nil
				player.room = nil
			//	player.musicoption = nil
			//	player.fevermusicoption = nil
			//	player.puyoskin = nil
			//	player.background = nil
				// Rules
				player.numplayers = nil
			//	player.garbagerate = nil
				player.rules = nil
				player.stagenum = nil
				player.fadetime = nil
				player.leveltime = nil
				player.didcontinue = nil
				player.continuepuyoy = nil
				player.customrules = nil
				// Lobbies
				player.host = nil
				player.clients = nil
				player.menuselection = nil
				player.characters = nil
				// Puyo list
				player.puyolists = nil
				player.puyolistsalt = nil
				player.wins = nil
				// Carbuncle!
				player.carbyanim = nil
				player.carbyframe = nil
				player.carbytime = nil
				player.carbyx = nil
				player.carbyy = nil
				player.carbyflip = nil
				player.carbuncle = nil
				// Puyo animations!
				player.puyoanim = nil
				player.puyoframe = nil
				player.puyotime = nil
				player.matchended = nil
				// Boards
				player.boards = nil
			end
			if(mapheaderinfo[gamemap].arlepuyopoptsuu)
				player.host = 0
				player.powers[pw_nocontrol] = 1
			elseif not(mapheaderinfo[gamemap].soniguri)
				player.host = nil
				if(player.prevpuyo)
					and(player.mo and player.mo.valid)
					player.prevpuyo = false
					player.jumpfactor = skins[player.mo.skin].jumpfactor
					player.charability2 = skins[player.mo.skin].ability2
					player.normalspeed = skins[player.mo.skin].normalspeed
					player.pflags = $1 & !PF_FORCESTRAFE
				end
			end
		else
			if(leveltime == 0)
				player.totalscore = 0
				player.fadetime = 0
				if(mapheaderinfo[gamemap].multipuyo)
					if(splitscreen)
						player.gamestate = 3
						if(#player)
							player.host = 0
						end
						S_ChangeMusic("CHRSLP", true, player)
					else
						player.gamestate = 1
						S_ChangeMusic("MENU", true, player)
					end
					player.stagenum = 0
					player.characters = nil
				else
					player.gamestate = 6
					player.stagenum = 1
					player.leveltime = 0
				end
			end

			if(player.totalscore == nil)
				player.totalscore = 0
			end

			if(player.room == nil)
				player.room = #player
			end
			if(player.musicoption == nil)
				player.musicoption = 2
			end
			if(player.fevermusicoption == nil)
				player.fevermusicoption = 0
			end
			if(player.puyoskin == nil)
				player.puyoskin = 0
			end
			if(player.background == nil)
				player.background = 1
			end
			if(player.puyoenglish == nil)
				player.puyoenglish = false
			end
			// Rules
			if(player.numplayers == nil)
				player.numplayers = 2
				if(rpgblast)
					player.numplayers = 1
				end
			end
	//		if(player.garbagerate == nil)
	//			player.garbagerate = 70
	//		end
			if(player.rules == nil)
				player.rules = 1			// 0 = Puyo Puyo, 1 = Tsuu, 2 = Fever, 3 = Custom
			end
			if(player.stagenum == nil)
				player.stagenum = 1			// 0 = multiplayer, 1+ = singleplayer stage
				if(mapheaderinfo[gamemap].multipuyo)
					player.stagenum = 0
				end
			end
			if(player.fadetime == nil)
				player.fadetime = -1		// if above 0, subtract and fade out. if less than 0, subtract and fade in
			end
			if(player.fadetime)
				player.fadetime = $1 - 1
				if(player.fadetime < -TICRATE)
					player.fadetime = 0
				end
			end
			if(player.leveltime == nil)
				player.leveltime = 0
			end
			if(player.didcontinue == nil)
				player.didcontinue = 0		// -1 did not continue, 1+ = continued
			end
			if(player.continuepuyoy == nil)
				player.continuepuyoy = 0
			end
			if(player.customrules == nil)
				player.customrules = deepcopy(tsuurules)	// Specifically a copy so we defenetly dont modify it!
			end
			// Lobbies
			if(player.host == nil)
				or not(players[player.host])
				or not(players[player.host].host == player.host)
				player.host = #player
			end
			if(player.clients == nil)
				player.clients = {}
				player.clients[0] = #player
				player.clients[1] = -1	// -1 = no client
				player.clients[2] = -1
				player.clients[3] = -1
			end
			if(splitscreen)
				and(mapheaderinfo[gamemap].multipuyo)
				and not(#player)
				player.clients[1] = 1
			end
			if(player.menuselection == nil)
				player.menuselection = 0
			end
			if(player.host == #player)
				local pnum = 0
				while(pnum < 4)
					if not(player.clients[pnum] == -1)
						and((not(players[player.clients[pnum]] and players[player.clients[pnum]].valid)) or not(players[player.clients[pnum]].host == #player))
						RemoveFromTable(player.clients, pnum, 4)	// Remove the client!
						player.clients[3] = -1			// Set player 4 to -1 (they dont exist)
					end
					pnum = $1 + 1
				end
			end
			if(player.gamestate == nil)
				player.gamestate = 6		// 0 = in-game, 1 = main menu, 2 = lobby select, 3 = character select, 4 = team select, 5 = options, 6 = level transition, 7 = cutscene, 8 = rules, 9 = custom rules, 10 = game over, -1 = SRB2.
				if(mapheaderinfo[gamemap].multipuyo)
					S_ChangeMusic("MENU", true, player)
					player.gamestate = 1
				elseif(rpgblast)
					player.gamestate = -1
				end
			elseif(player.gamestate != -1 and not mapheaderinfo[gamemap].arlepuyopoptsuu)
				player.gamestate = -1
			end
			if(player.characters == nil)
				player.characters = {}
				player.characters[0] = 0
				player.characters[1] = 2
				player.characters[2] = 3
				player.characters[3] = 1
			end
			// Puyo list
			if(player.puyolists == nil)
				player.puyolists = {}
				player.puyolists[0] = {}
				player.puyolists[1] = {}
				player.puyolists[2] = {}
			end
			if(player.puyolistsalt == nil)
				player.puyolistsalt = {}
				player.puyolistsalt[0] = {}
				player.puyolistsalt[1] = {}
				player.puyolistsalt[2] = {}
			end
			if(player.wins == nil)
				player.wins = {}
				player.wins[0] = 0
				player.wins[1] = 0
				player.wins[2] = 0
				player.wins[3] = 0
			end
			// RPG Blast!
	/*		if(rpgblast)
			//	if not(player.puyotarget and player.puyotarget.valid)
			//		player.puyotarget = P_SpawnMobj(player.mo.x+(60*FRACUNIT), player.mo.y, player.mo.z, MT_BLUECRAWLA)
			//	end
				if(player.notargettimer == nil)
					player.notargettimer = TICRATE*3/2
				end
				if(player.puyotarget and player.puyotarget.valid)
					and(player.gamestate >= 0)
					player.notargettimer = TICRATE*3/2
					if(player.puyotargettargx == nil)
						player.puyotargettargx = player.puyotarget.x
					end
					if(player.puyotargettargy == nil)
						player.puyotargettargy = player.puyotarget.y
					end
					if(player.puyotargettargz == nil)
						player.puyotargettargz = player.puyotarget.z
					end
					P_SetOrigin(player.puyotarget, player.puyotargettargx, player.puyotargettargy, player.puyotargettargz)
					player.puyotarget.momx = 0
					player.puyotarget.momy = 0
					player.puyotarget.momz = 0
					player.mo.momx = player.cmomx
					player.mo.momy = player.cmomy
					player.puyotarget.angle = R_PointToAngle2(player.puyotarget.x, player.puyotarget.y, player.mo.x, player.mo.y)
					player.mo.angle = R_PointToAngle2(player.mo.x, player.mo.y, player.puyotarget.x, player.puyotarget.y)+ANGLE_45
					if(enemy_data[player.puyotarget.type] and player.puyotarget.state == enemy_data[player.puyotarget.type].attack_state)
						or(player.puyotarget.state == mobjinfo[player.puyotarget.type].missilestaet)
						or(player.puyotarget.state == mobjinfo[player.puyotarget.type].meleestaet)
						if not(player.prevtargetattack)
							player.boards[0].extragarbage[0] = $1 + (dmgformula(player.puyotarget.attack, player.stats.defense)/2)
						end
						player.prevtargetattack = true
					else
						if(player.prevtargetattack)
							player.boards[0].garbagetray = $1 + player.boards[0].extragarbage[0]
							player.boards[0].extragarbage[0] = 0
						end
						player.prevtargetattack = false
					end
				else
					player.prevtargetattack = false
					player.puyotargettargx = nil
					player.puyotargettargy = nil
					player.puyotargettargz = nil
					if not(player.gamestate < 0)
						and(player.boards[0].state == 0)
						if(player.notargettimer)
							player.notargettimer = $1 - 1
						else
							player.gamestate = -1
							P_RestoreMusic(player)
							PlaySound(player, sfx_arlew, character)
							PlaySound(player, sfx_ppwin)
						end
					end
				end
			end*/
			// Carbuncle!
			if(player.carbyanim == nil)
				player.carbyanim = 1
			end
			if(player.carbyframe == nil)
				player.carbyframe = 0
			end
			if(player.carbytime == nil)
				player.carbytime = 0
			end
			if(player.carbyx == nil)
				player.carbyx = 16
			end
			if(player.carbyy == nil)
				player.carby = 0
			end
			if(player.carbyflip == nil)
				player.carbyflip = false
			end
			if(player.carbuncle == nil)
				player.carbuncle = 0		// 0 = no carbuncle, 1 = carbuncle, 2 = fakebuncle, 3 = carbuncle (acts like fakebuncle)
			end
			// Puyo animations!
			if(player.puyoanim == nil)
				player.puyoanim = 0
			end
			if(player.puyoframe == nil)
				player.puyoframe = 0
			end
			if(player.puyotime == nil)
				player.puyotime = 0
			end
			if(player.matchended == nil)
				player.matchended = 0
			end
			// Boards
			if(player.boards == nil)
				player.boards = {}
				StartGame(player, true)
				player.puyoanim = 1
			end

			if(player.host == #player)
				if(player.gamestate == 0)
					// Carbuncle!
					if(player.carbuncle)
						player.carbytime = $1 + 1
						if not(carbyanimations[player.carbyanim].canflip)
							if(player.carbyx > 40)
								player.carbyflip = true
							elseif(player.carbyx < 16)
								player.carbyflip = false
							end
						end
						if(player.carbytime > carbyframes[carbyanimations[player.carbyanim].frames[player.carbyframe]].duration)
							if(player.carbyflip)
								player.carbyx = $1 - carbyframes[carbyanimations[player.carbyanim].frames[player.carbyframe]].endmovement
							else
								player.carbyx = $1 + carbyframes[carbyanimations[player.carbyanim].frames[player.carbyframe]].endmovement
							end
							player.carbytime = 0
							player.carbyframe = $1 + 1
							if(player.carbyframe >= carbyanimations[player.carbyanim].numframes)
								player.carbyframe = 0
								player.carbyanim = carbyanimations[player.carbyanim].nextanim
								if(player.carbyanim == -1)
									player.carbyanim = carbyrandomlist[P_RandomByte()%carbyrandomlength]
								elseif(player.carbuncle == 2 or player.carbuncle == 3)
									and(player.carbyanim == 0)
									player.carbyanim = 13
									if(player.carbuncle == 3)
										player.carbyanim = 14
									end
								end
								if(player.carbyx > 40)
									player.carbyflip = true
								elseif(player.carbyx < 16)
									player.carbyflip = false
								end
							end
							if(carbyanimations[player.carbyanim].frames[player.carbyframe] == 11)
								PlaySound(player, sfx_ppgo)
							end

							if(player.carbyanim == 13)
								or(player.carbyanim == 14)
								player.carbyy = $1 - 10
								if(player.carbyy < -700)
									player.carbyy = -700
								end
							end
						end
					end

					// Puyo!
					player.puyotime = $1 + 1
					if(player.puyotime > puyoanims[player.puyoanim].speed)
						player.puyoframe = $1 + 1
						player.puyotime = 0
						if(player.puyoframe >= puyoanims[player.puyoanim].numframes)
							player.puyoframe = 0
							if(player.puyoanim)
								player.puyoanim = 0
							else
								player.puyoanim = P_RandomByte()%17
							end
						end
					end

					if(player.starttime)
						player.starttime = $1 - 1
						if not(player.starttime)
							StartGame2(player)
						end
					else
						local bnum = 0
						local boarddoingstuff = false
						local numdeadplayers = 0
						local notdead = {}
						local playerswon = {}
						while(bnum < player.numplayers)
							if not(player.starttime)	// Can happen... kind of hacky reset though
								if not(player.clients[bnum] == -1)
									and(players[player.clients[bnum]] and players[player.clients[bnum]].valid)
									UpdateBoard(player, player.boards[bnum], players[player.clients[bnum]].cmd, players[player.clients[bnum]], bnum, player.characters[bnum])
								else	// AI
									UpdateBoard(player, player.boards[bnum], doAICmd(player.boards[bnum], player.characters[bnum]), nil, bnum, player.characters[bnum])
								end
								if not(player.boards[bnum].state == 0)
									and not(player.boards[bnum].lostyoff)
									boarddoingstuff = true
								end
								if(player.boards[bnum].lostyoff)
									numdeadplayers = $1 + 1
								else
									notdead[player.characters[bnum]] = true
									playerswon[bnum] = true
								end
								if(player.boards[bnum].nexttime > 7)
									player.boards[bnum].nexttime = 7
								end
							end
							bnum = $1 + 1
						end
						if(player.numplayers == 1)
							numdeadplayers = $1 - 1
						end
						if(numdeadplayers >= player.numplayers - 1)
							and not(player.matchended)
							player.matchended = 1
						end
						if(player.matchended)
							and not(boarddoingstuff)
							player.matchended = $1 + 1
						end
						local mostwins = player.wins[0]
						local playerwon = 0
						if(player.wins[1] > mostwins)
							mostwins = player.wins[1]
							playerwon = 1
						end
						if(player.wins[2] > mostwins)
							mostwins = player.wins[2]
							playerwon = 2
						end
						if(player.wins[3] > mostwins)
							mostwins = player.wins[3]
							playerwon = 3
						end
						if(player.matchended == TICRATE/3)
							if(gameisover)
								or(player.stagenum)
								if(playerswon[0])
									PlaySound(player, sfx_ppwin)
								end
								S_StopMusic(player)
							else
								if not(mostwins >= 2)
									RestoreMusic(player)
								end
							end
						elseif(player.matchended == TICRATE*25/10)
							local wvnum = 0
							while(wvnum < numchars)
								if(notdead[wvnum])
									PlaySound(player, sfx_arlew, wvnum)
									// Add score
									player.totalscore = $1 + player.boards[0].score
									if(player.stagenum >= 5)
										P_AddPlayerScore(player, player.totalscore)
									end
								end
								wvnum = $1 + 1
							end
							wvnum = 0
							while(wvnum < 4)
								if(playerswon[wvnum])
									player.wins[wvnum] = $1 + 1
									if(wvnum == playerwon)
										mostwins = $1 + 1
									end
								end
								wvnum = $1 + 1
							end

							if not(player.stagenum)
								and(mostwins >= 2)
								PlaySound(player, sfx_ppwin)
								local cnum = 0
								while(cnum < 4)
									if not(player.clients[cnum] == -1)
										S_StopMusic(players[player.clients[cnum]])
									end
									cnum = $1 + 1
								end
							end
						elseif(player.matchended >= TICRATE*6)
							if(player.stagenum)
								if(player.matchended == TICRATE*6)
									if(playerswon[0])
										player.stagenum = $1 + 1
									end
									player.fadetime = -1
								elseif(player.matchended == TICRATE*7)
									if(playerswon[0])
										if(player.stagenum > 5)
											if not(netgame)
											//	sugoi.GiveEmblem()
											//	sugoi.ExitLevel()
												P_DoPlayerExit(player)
												player.fadetime = TICRATE*60
											else
												P_DoPlayerExit(player)
												player.fadetime = TICRATE
												player.gamestate = 11
											end
										else
											S_StopMusic(player)
											player.fadetime = TICRATE
											player.gamestate = 6
											player.leveltime = 0
										end
									else
										player.totalscore = 0
										if(player.lives > 1)
											player.fadetime = TICRATE
											player.leveltime = (CONTINUERATE*10)+TICRATE
											player.didcontinue = 0
											player.continuepuyoy = 0
											player.gamestate = 10
											S_ChangeMusic("SORROW", false, player)
										else
											P_KillMobj(player.mo)
											player.gamestate = 11
											player.didcontinue = 0
										end
									end
								end
							else
								if(mostwins >= 2)
									if(player.matchended == TICRATE*6)
										player.fadetime = -1
									elseif(player.matchended == TICRATE*7)
										player.fadetime = TICRATE
										player.gamestate = 3
										local cnum = 0
										while(cnum < 4)
											player.wins[cnum] = 0
											if not(player.clients[cnum] == -1)
												S_ChangeMusic("CHRSLP", true, players[player.clients[cnum]])
											end
											cnum = $1 + 1
										end
									end
								else
									StartGame(player)
								end
							end
						end
					end
					// RPG Blast code, probably doesn't even work anymore...
					// Why is this labled as RPG Blast code? This is for the emblem!
				/*	if(player.boards[0].chain > player.mo.health-1)
						player.mo.health = player.boards[0].chain+1
				//		player.mo.health = player.health
					end*/

					if(player.boards[0].chain > player.rings)
						and(player.stagenum)	// Singleplayer only
						player.rings = player.boards[0].chain
					//	print("New best! Rings: "+player.rings)
					end
				elseif(player.gamestate == 3)
					if(player.cmd.buttons & BT_JUMP)
						and(player.prevbutt == nil or not(player.prevbutt & BT_JUMP))
					//	and(player.clients[1] >= 0)		// 2 OR MORE PLAYERS REQUIREMENT
						player.gamestate = 0
						local numclients = 0
						local cnum = 0
						while(cnum < 4)
							if not(player.clients[cnum] == -1)
								numclients = $1 + 1
							end
							cnum = $1 + 1
						end
					/*	if(player.numclients < 2)
							player.numclients = 2	// For testing
						end*/
						PlaySound(player, sfx_menu2p)
						player.numplayers = numclients
						StartGame(player)
					// ------------------------------------------
					// EXTRA LINES ADDED FOR CHARACTER SELECT
					else
						// Change character!
						local cnum = 0
						while not(player.clients[cnum] == -1)
							and(cnum < 4)	// Failsafe I guess?
							local cplayer = players[player.clients[cnum]]
						///	if(cplayer.prevside == 0)
								if(cplayer.cmd.sidemove > menudead)
									and not(cplayer.prevside > menudead)
									player.characters[cnum] = $1 + 1
									if(player.characters[cnum] >= numchars)
										player.characters[cnum] = 0
									end
									S_StartSound(nil, sfx_menu1p, cplayer)
								elseif(cplayer.cmd.sidemove < -menudead)
									and not(cplayer.prevside < -menudead)
									player.characters[cnum] = $1 - 1
									if(player.characters[cnum] < 0)
										player.characters[cnum] = numchars-1
									end
									S_StartSound(nil, sfx_menu1p, cplayer)
								end
						//	end
							cnum = $1 + 1
						end
					// ------------------------------------------
					end
				elseif(player.gamestate == 7)
					if(player.cutscene == nil)
						player.cutscene = 0
					end

					if(player.cmd.buttons & BT_JUMP)
						and(player.prevbutt == nil or not(player.prevbutt & BT_JUMP))
						player.gamestate = 0
						PlaySound(player, sfx_level)
						player.numplayers = 2
						StartGame(player)
					end
				end
			end
			if(players[player.host].gamestate == 0)
				player.menuselection = 0
			elseif(players[player.host].gamestate == 1)
				if(player.cmd.forwardmove > menudead)
					and not(player.prevforward > menudead)
					player.menuselection = $1 - 1
					S_StartSound(player.mo, sfx_menu1p, player)
				elseif(player.cmd.forwardmove < -menudead)
					and not(player.prevforward < -menudead)
					player.menuselection = $1 + 1
					S_StartSound(player.mo, sfx_menu1p, player)
				end

				if(player.menuselection < 0)
					player.menuselection = 0
				elseif(player.menuselection > 1)
		//			and not(#player == #server or (admin and admin.valid and #player == #admin))	// ...Why is there a quit option?
					player.menuselection = 1
				elseif(player.menuselection > 2)
					player.menuselection = 2
				end

				if(player.cmd.buttons & BT_JUMP)
					and(player.prevbutt == nil or not(player.prevbutt & BT_JUMP))
					if(player.menuselection == 0)
						player.gamestate = 2	// Lobby select menu!
					elseif(player.menuselection == 1)
						player.gamestate = 5	// Options!
					else
						G_ExitLevel(true)
					end
					S_StartSound(player.mo, sfx_menu2p, player)
					player.menuselection = 0
				end
			elseif(players[player.host].gamestate == 2)
				if(player.cmd.forwardmove > menudead)
					and not(player.prevforward > menudead)
					player.menuselection = $1 - 1
					S_StartSound(player.mo, sfx_menu1p, player)
				elseif(player.cmd.forwardmove < -menudead)
					and not(player.prevforward < -menudead)
					player.menuselection = $1 + 1
					S_StartSound(player.mo, sfx_menu1p, player)
				end
				local numhosts = 0
				local hosts = {}
				for player2 in players.iterate
					if(player2.host == #player2)
						and(player2.gamestate == 3)
						hosts[numhosts] = #player2
						numhosts = $1 + 1
					end
				end
				if(player.menuselection < 0)
					player.menuselection = 0
				elseif(player.menuselection > numhosts)
					player.menuselection = numhosts
				end
				if(player.cmd.buttons & BT_JUMP)
					and(player.prevbutt == nil or not(player.prevbutt & BT_JUMP))
					if(player.menuselection)	// Joining somebody?
						JoinPlayer(player, hosts[player.menuselection-1])
						player.menuselection = 0
					else
						player.gamestate = 8	// Rules menu!
						player.menuselection = 1	// Tsuu default!
					end
					S_ChangeMusic("CHRSLP", true, player)
					S_StartSound(player.mo, sfx_menu2p, player)
				elseif(player.cmd.buttons & BT_USE)
					and(player.prevbutt == nil or not(player.prevbutt & BT_USE))
					player.gamestate = 1
					S_StartSound(player.mo, sfx_menu3p, player)
					player.menuselection = 0
				end
			elseif(players[player.host].gamestate == 3)
				if(player.cmd.buttons & BT_USE)
					and(player.prevbutt == nil or not(player.prevbutt & BT_USE))
					and not(splitscreen)
					if(player.host == #player)
						player.gamestate = 2
						if(player.clients[1] >= 0)
							players[player.clients[1]].host = player.clients[1]
						//	players[player.clients[1]].clients[0] = player.clients[1]
						//	players[player.clients[1]].gamestate = 2
						end
						if(player.clients[2] >= 0)
							players[player.clients[2]].host = player.clients[2]
						//	players[player.clients[2]].clients[0] = player.clients[2]
						//	players[player.clients[2]].gamestate = 2
						end
						if(player.clients[3] >= 0)
							players[player.clients[3]].host = player.clients[3]
						//	players[player.clients[3]].clients[0] = player.clients[3]
						//	players[player.clients[3]].gamestate = 2
						end
						player.clients[1] = -1
						player.clients[2] = -1
						player.clients[3] = -1
					else
						player.host = #player
					end
					S_ChangeMusic("MENU", true, player)
					S_StartSound(player.mo, sfx_menu3p, player)
					player.menuselection = 0
				end
			elseif(players[player.host].gamestate == 5)
				if(player.cmd.forwardmove > menudead)
					and not(player.prevforward > menudead)
					player.menuselection = $1 - 1
					S_StartSound(player.mo, sfx_menu1p, player)
				elseif(player.cmd.forwardmove < -menudead)
					and not(player.prevforward < -menudead)
					player.menuselection = $1 + 1
					S_StartSound(player.mo, sfx_menu1p, player)
				end

				if(player.menuselection < 0)
					player.menuselection = 0
				elseif(player.menuselection > 4)
					player.menuselection = 4
				end

				local modify = 0
				if(player.cmd.sidemove > menudead)
					and not(player.prevside > menudead or player.prevside == nil)
					modify = 1
					S_StartSound(player.mo, sfx_menu1p, player)
				elseif(player.cmd.sidemove < -menudead)
					and not(player.prevside < -menudead or player.prevside == nil)
					modify = -1
					S_StartSound(player.mo, sfx_menu1p, player)
				end

				if(player.menuselection == 0)		// Music
					player.musicoption = ($1 + modify)%nummusictracks
					if(player.musicoption < 0)
						player.musicoption = nummusictracks-1
					end
				elseif(player.menuselection == 1)	// Fever music
					player.fevermusicoption = ($1 + modify)%numfevermusictracks
					if(player.fevermusicoption < 0)
						player.fevermusicoption = numfevermusictracks-1
					end
				elseif(player.menuselection == 2)	// Puyo skin
					player.puyoskin = ($1 + modify)%numskins
					if(player.puyoskin < 0)
						player.puyoskin = numskins-1
					end
				elseif(player.menuselection == 3)	// Background
					player.background = ($1 + modify)%numbackgrounds
					if(player.background < 0)
						player.background = numbackgrounds-1
					end
				elseif(player.menuselection == 4)	// Voice language
					if(modify)
						if(player.puyoenglish)
							player.puyoenglish = false
						else
							player.puyoenglish = true
						end
					end
				end

				if(player.cmd.buttons & BT_USE)
					and(player.prevbutt == nil or not(player.prevbutt & BT_USE))
					player.gamestate = 1
					S_StartSound(player.mo, sfx_menu3p, player)
					player.menuselection = 0
				end
			elseif(players[player.host].gamestate == 6)
				// Last minute garbage
				if(player.cmd.buttons & BT_TOSSFLAG)
					and not(player.prevbutt == nil)
					and not(player.prevbutt & BT_TOSSFLAG)
					if(player.puyoenglish)
						player.puyoenglish = false
					else
						player.puyoenglish = true
					end
					S_StartSound(nil, sfx_menu1, player)
				end

				if not(player.leveltime)
					player.fadetime = TICRATE
				end
				player.leveltime = $1 + 1
				if(player.leveltime == TICRATE*3/2)
					S_StartSound(player.mo, sfx_level, player)
				end
				if(player.leveltime == TICRATE*3)
					player.fadetime = -1
				end
				if(player.leveltime >= TICRATE*4)
					player.fadetime = TICRATE
					// Start the level!
					player.gamestate = 0
					player.numplayers = 2
					player.characters[0] = 0
					if(skinchars[player.mo.skin])
						player.characters[0] = skinchars[player.mo.skin]
					end
					player.characters[1] = stagecharacters[player.stagenum]
					player.rules = 1		// Pain.
					player.wins[0] = 0
					player.wins[1] = 0
					player.wins[2] = 0
					player.wins[3] = 0
					StartGame(player)
				end
			elseif(players[player.host].gamestate == 8)
				if(player.cmd.forwardmove > menudead)
					and not(player.prevforward > menudead)
					player.menuselection = $1 - 1
					S_StartSound(player.mo, sfx_menu1p, player)
				elseif(player.cmd.forwardmove < -menudead)
					and not(player.prevforward < -menudead)
					player.menuselection = $1 + 1
					S_StartSound(player.mo, sfx_menu1p, player)
				end

				if(player.menuselection < 0)
					player.menuselection = 0
				elseif(player.menuselection > 3)
					player.menuselection = 3
				end

				if(player.cmd.buttons & BT_JUMP)
					and(player.prevbutt == nil or not(player.prevbutt & BT_JUMP))
				//	if(player.menuselection == 2)
				//		S_StartSound(player.mo, sfx_lose, player)
				//	else
						player.gamestate = 3	// Character select menu!
						if(player.menuselection == 3)	// Custom!
							player.gamestate = 9		// Custom rules menu!
						end
						S_StartSound(player.mo, sfx_menu2p, player)
						player.rules = player.menuselection
						player.menuselection = 0
						if(player.rules > 3)
							player.rules = 3
						end
				//	end
				elseif(player.cmd.buttons & BT_USE)
					and(player.prevbutt == nil or not(player.prevbutt & BT_USE))
					S_ChangeMusic("MENU", true, player)
					player.gamestate = 2
					S_StartSound(player.mo, sfx_menu3p, player)
					player.menuselection = 0
				end
			elseif(players[player.host].gamestate == 9)
				if(player.cmd.forwardmove > menudead)
					and not(player.prevforward > menudead)
					player.menuselection = $1 - 1
					S_StartSound(player.mo, sfx_menu1p, player)
				elseif(player.cmd.forwardmove < -menudead)
					and not(player.prevforward < -menudead)
					player.menuselection = $1 + 1
					S_StartSound(player.mo, sfx_menu1p, player)
				end

				if(player.menuselection < 0)
					player.menuselection = 0
				elseif(player.menuselection > 5)
					player.menuselection = 5
				end

				local modify = 0
				if(player.cmd.sidemove > menudead)
					and not(player.prevside > menudead or player.prevside == nil)
					modify = 1
					S_StartSound(player.mo, sfx_menu1p, player)
				elseif(player.cmd.sidemove < -menudead)
					and not(player.prevside < -menudead or player.prevside == nil)
					modify = -1
					S_StartSound(player.mo, sfx_menu1p, player)
				end

				if(player.menuselection == 0)		// Dropsets
					and(modify)
					if(player.customrules.dropsets)
						player.customrules.dropsets = false
					else
						player.customrules.dropsets = true
					end
				elseif(player.menuselection == 1)	// Garbage rules
					player.customrules.garbagerules = ($1 + modify)%3
					if(player.customrules.garbagerules < 0)
						player.customrules.garbagerules = 2
					end
				elseif(player.menuselection == 2)	// Score rules
					player.customrules.scorerules = ($1 + modify)%3
					if(player.customrules.scorerules < 0)
						player.customrules.scorerules = 2
					end
				elseif(player.menuselection == 3)	// All clear rules
					player.customrules.allclearrules = ($1 + modify)%3
					if(player.customrules.allclearrules < 0)
						player.customrules.allclearrules = 2
					end
				elseif(player.menuselection == 4)	// Voice pattern
					player.customrules.voicepattern = ($1 + modify)%3
					if(player.customrules.voicepattern < 0)
						player.customrules.voicepattern = 2
					end
				elseif(player.menuselection == 5)	// Fever mode
					and(modify)
					if(player.customrules.fever)
						player.customrules.fever = false
					else
						player.customrules.fever = true
					end
				end

				if(player.cmd.buttons & BT_JUMP)
					and(player.prevbutt == nil or not(player.prevbutt & BT_JUMP))
					player.gamestate = 3	// Character select menu!
					S_StartSound(player.mo, sfx_menu2p, player)
					player.menuselection = 0
				elseif(player.cmd.buttons & BT_USE)
					and(player.prevbutt == nil or not(player.prevbutt & BT_USE))
					player.gamestate = 8
					S_StartSound(player.mo, sfx_menu3p, player)
					player.menuselection = 0
				end
			elseif(players[player.host].gamestate == 10)
				if(player.lives)
					or(player.didcontinue)
					player.leveltime = $1 - 1

					if not(player.didcontinue)
						if(player.cmd.buttons & BT_JUMP)
							and not(player.prevbutt & BT_JUMP)
							S_StartSound(nil, sfx_menu2p, player)
							player.didcontinue = 1
							player.leveltime = TICRATE*2
							player.lives = $1 - 1
							S_StartSound(nil, sfx_altdi1, player)
						end
					end

					if not(player.didcontinue)
						if(player.cmd.buttons & BT_USE)
							and not(player.prevbutt & BT_USE)
							player.leveltime = ($1/CONTINUERATE)*CONTINUERATE
						end
						if not(player.leveltime%CONTINUERATE)
							and(player.leveltime)
							S_StartSound(nil, sfx_menu1p, player)
						end
						if(player.leveltime <= 0)
							player.didcontinue = -1
							player.leveltime = TICRATE*3
						end
					elseif(player.didcontinue > 0)
						if(player.leveltime == TICRATE)
							player.fadetime = -1
						end
						if(player.leveltime <= 0)
							player.gamestate = 6
							player.leveltime = 0
							player.fadetime = TICRATE
							S_StopMusic(player)
						end
					else
					//	if(player.continuepuyoy)
							local oldy = player.continuepuyoy
							player.continuepuyoy = $1 + (((TICRATE*3)-player.leveltime)*2)
					//	else
					//		player.continuepuyoy = $1 + 1
					//	end

						if(player.continuepuyoy > 178)
							if(oldy < 178)
								S_StartSound(nil, sfx_trash2, player)
							end
							player.continuepuyoy = 178
						end

						if(player.leveltime == TICRATE)
							player.fadetime = -1
						end
						if(player.leveltime <= 0)
							player.fadetime = TICRATE
							S_StopMusic(player)
							local exited = false
							for player2 in players.iterate
								if(player2.exiting)
									exited = true
								end
							end
							if(exited)
								player.gamestate = 11
								P_DoPlayerExit(player)
							else
								player.gamestate = 6
								player.stagenum = 1
								player.leveltime = 0
							end
						end
					end
				end
			end
			if not(players[player.host].gamestate < 0)
				player.jumpfactor = 0
				player.charability2 = CA2_NONE
				player.normalspeed = 0
				player.pflags = $1|PF_FORCESTRAFE
				player.prevpuyo = true
			elseif(player.prevpuyo)
				and(player.mo and player.mo.valid)
				player.prevpuyo = false
				player.jumpfactor = skins[player.mo.skin].jumpfactor
				player.charability2 = skins[player.mo.skin].ability2
				player.normalspeed = skins[player.mo.skin].normalspeed
				player.pflags = $1 & !PF_FORCESTRAFE
			end
			player.prevbutt = player.cmd.buttons
			player.prevside = player.cmd.sidemove
			player.prevforward = player.cmd.forwardmove
		end
		numiterates = $1 + 1
	end
end)

local function drawSprite(v, x, y, patch, halfscale, skinhalf, skinscale)
/*	if(halfscale)
		v.drawScaled(x*FRACUNIT/220*200/2, y*FRACUNIT/220*200/2, FRACUNIT*200/220/2, patch)
		return
	end
	v.drawScaled(x*FRACUNIT/220*200, y*FRACUNIT/220*200, FRACUNIT*200/220, patch)*/
	if(skinhalf)
		if(halfscale)
			v.drawScaled(x*FRACUNIT/2, y*FRACUNIT/2, skinscale/2, patch)
			return
		end
		v.drawScaled(x*FRACUNIT, y*FRACUNIT, skinscale, patch)
		return
	end
	if(halfscale)
		v.drawScaled(x*FRACUNIT/2, y*FRACUNIT/2, FRACUNIT/2, patch)
		return
	end
	v.draw(x, y, patch)
end

local function drawPuyo(v, x, y, patch, halfscale, poppingtime, skinhalf, skinscale)
	if not(poppingtime)
		drawSprite(v, x, y, patch, halfscale)
	else
		if(halfscale)
			x = $1/2
			y = $1/2
		end

		local poptime = feverpoptime-2
		local scale = FRACUNIT*(poppingtime+2)/(poptime*2/3)
		if(feverpoptime-poppingtime < 2)
			scale = FRACUNIT+((feverpoptime-poppingtime)*FRACUNIT*2/3/2)
		end
		scale = FixedMul($1, FRACUNIT*4/6)
		x = $1 * FRACUNIT
		y = $1 * FRACUNIT

		if(halfscale)
			x = $1 + ((FRACUNIT-scale)*4)
			y = $1 + ((FRACUNIT-scale)*4)
			scale = $1 / 2
		else
			x = $1 + ((FRACUNIT-scale)*8)
			y = $1 + ((FRACUNIT-scale)*8)
		end

		if(skinhalf)
			v.drawScaled(x, y, FixedMul(scale, skinscale), patch)
			return
		end
		v.drawScaled(x, y, scale, patch)
	end
end

local function drawBoard(v, player, board, x, y, yoff, puyoskin)
	local color1 = 152
	local color2 = 155
	local color3 = 155
	if(board == 1)	// Player 2
		color1 = 35
		color2 = 41
		color3 = 41
	elseif(board == 2)	// Player 3
		color1 = 112
		color2 = 115
		color3 = 115
	elseif(board == 3)	// Player 4
		color1 = 73
		color2 = 75
		color3 = 75
	end

	local fm = player.boards[board].fevermode
	if(player.boards[board].feverswitchtime > feverswitchtime/2)
		if(fm)
			fm = false
		else
			fm = true
		end
	end

	local useboardyoff = player.boards[board].boardyoff
	if(player.boards[board].fevermode)
		and not(fm)
		useboardyoff = 0
	end

	local boardtiles = MakeTilesFromBoard(player.boards[board], fm)

	if(fm)
		color3 = fevercolors[(leveltime/2)%numfevercolors]
	end

	local fourplayer = false
	local origx = x
	local origy = y
	if(player.numplayers > 2)
		fourplayer = true
		x = $1 * 2
		y = $1 * 2
	end

	// Draw the board!
	local bc = player.characters[board]
	local bflip = 0
	local ow = 0
	if(board & 1)
		bflip = V_FLIP
		ow = 96
		if(fourplayer)
			ow = $1 * 2
		end
	end
	if(showboard)
		if(fourplayer)
			v.drawFill(origx, origy+yoff, (boardwidth*8)+2, ((boardheight-bufferrows)*8)+2, color1)
			v.drawFill(origx+1, origy+1+yoff, boardwidth*8, (boardheight-bufferrows)*8, color3)
			if not(fm)
				if(bflip and v.characters[bc].backgroundf)
					v.drawScaled((x+1+ow)*FRACUNIT/2, (y+1+yoff)*FRACUNIT/2, FRACUNIT/2, v.characters[bc].backgroundf, V_20TRANS|bflip)
				else
					v.drawScaled((x+1+ow)*FRACUNIT/2, (y+1+yoff)*FRACUNIT/2, FRACUNIT/2, v.characters[bc].background, V_20TRANS|bflip)	// Draw the character image!
				end
			end
		else
			v.drawFill(origx, origy+yoff, (boardwidth*16)+2, ((boardheight-bufferrows)*16)+2, color1)
			v.drawFill(origx+1, origy+1+yoff, boardwidth*16, (boardheight-bufferrows)*16, color3)
			if not(fm)
				if(bflip and v.characters[bc].backgroundf)
					v.draw(origx+1+ow, origy+1+yoff, v.characters[bc].backgroundf, V_20TRANS|bflip)
				else
					v.draw(origx+1+ow, origy+1+yoff, v.characters[bc].background, V_20TRANS|bflip)	// Draw the character image!
				end
			end
		end
		drawSprite(v, x+32+1, y+1+yoff, v.cantplacex, fourplayer)
		if(player.boards[board].dropsets)
			drawSprite(v, x+48+1, y+1+yoff, v.cantplacex, fourplayer)
		end
	end

	// Next
	local pcolor = {}
	local pcoloralt = {}
	local pcnum = 0
	local pc2num = 0
	local pieces = {}
	local bigpuyoswap = player.boards[board].ljswap
	while(pcnum < 6)
		if not(pcnum & 1)
			pieces[pcnum/2] = chardata[player.characters[board]].dropset[(player.boards[board].dropsetindex+(pcnum/2))%16]
			if(bigpuyoswap)
				if(pieces[pcnum/2] == 1)
					pieces[pcnum/2] = 3
				elseif(pieces[pcnum/2] == 2)
					pieces[pcnum/2] = 4
				elseif(pieces[pcnum/2] == 3)
					pieces[pcnum/2] = 1
				elseif(pieces[pcnum/2] == 4)
					pieces[pcnum/2] = 2
				end
			end
			if(pieces[pcnum/2] == 6)
				and(pcnum > 0)
				if(bigpuyoswap)
					bigpuyoswap = false
				else
					bigpuyoswap = true
				end
			end
		end

		pcolor[pcnum] = player.puyolists[player.boards[board].colors][(player.boards[board].placingpuyoindex+pc2num)%256]-1
		pcoloralt[pcnum] = player.puyolistsalt[player.boards[board].colors][(player.boards[board].placingpuyoindex+pc2num)%256]-1
		pcnum = $1 + 1
		if not(chardata[player.characters[board]].dropset[(player.boards[board].dropsetindex+(pcnum/2))%16] == 6)
			or not(pcnum & 1)
			or not(player.boards[board].dropsets)
			pc2num = $1 + 1	// Skip over colors with big puyo!
		end
	end
	local nexttimeyoff = (player.boards[board].nexttime*6)
	local nextxoff = (boardwidth*16)-1
	local nextxoff2 = 6
	local nextyoff = 17
	local xmul = 1
	if(board & 1)
		if(fourplayer)
			if(board == 1)
				nextxoff = -232
				nextyoff = 6
			else
				nextxoff = -293
				nextyoff = -73
			end
			nextxoff2 = -6
		else
			nextxoff = -43
			nextxoff2 = -6
		end
		xmul = -1
	elseif(fourplayer)
		if(board == 0)	// Dumb stuff that doesn't work with any board size
			nextxoff = -32
			nextyoff = 6
		else
			nextxoff = 27
			nextyoff = -73
		end
	end
	v.drawFill(x+nextxoff+2+8+1, y+nextyoff+1, 24, 39, color2)
	v.drawFill(x+nextxoff+2+8+nextxoff2+1, y+nextyoff+23+1, 24, 39, color2)
	/*if not(paused or (menuactive and not netgame))
		or(puyodebug)
		local pnnum = 2
		while(pnnum >= 0)
			local nextx = 0
			local nexty = 0
			local dontdraw = false
			if(pnnum == 2)
				if(player.boards[board].nexttime == 7 or player.boards[board].nexttime == 8)	// Hard coded fix
					and(fourplayer)
					dontdraw = true
				end
				nextx = x+nextxoff+2+9+(8*xmul)+4-2
				nexty = y+46+nexttimeyoff+nextyoff-16+3+8
			elseif(pnnum == 1)
				local nextmoveoff = ((nexttimeyoff/6)*xmul)
				if(nextmoveoff > 7)
					nextmoveoff = 7
				end
				nexty = y+30+nexttimeyoff/2+nextyoff-16+3
				nextx = x+nextxoff+2+9+nextmoveoff+4
			else
				nextx = x+nextxoff+2+9+4
				nexty = y+30-32+(nexttimeyoff*4/6)+nextyoff-16+3
			end

			// Draw the thing
			local color1 = pnnum*2
			local color2 = (pnnum*2)+1
			if not(dontdraw)
				if(pieces[pnnum] == 0)
					or not(player.boards[board].dropsets)
					drawSprite(v, nextx, nexty, v.puyoskins[puyoskin][pcolor[color1]][0], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
					drawSprite(v, nextx, nexty-15, v.puyoskins[puyoskin][pcolor[color2]][0], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
				elseif(pieces[pnnum] == 1)
					local framecenter = 1
					local frameside = 0
					if(pcolor[color1] == pcolor[color2])
						framecenter = $1|8
						frameside = $1|4
					end
					drawSprite(v, nextx-8, nexty, v.puyoskins[puyoskin][pcolor[color1]][framecenter], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
					drawSprite(v, nextx-8, nexty-15, v.puyoskins[puyoskin][pcolor[color1]][2], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
					drawSprite(v, nextx+8, nexty, v.puyoskins[puyoskin][pcolor[color2]][frameside], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
				elseif(pieces[pnnum] == 2)
					local framecenter = 8
					local frametop = 0
					if(pcolor[color1] == pcolor[color2])
						framecenter = $1|1
						frametop = $1|2
					end
					drawSprite(v, nextx-8, nexty, v.puyoskins[puyoskin][pcolor[color1]][framecenter], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
					drawSprite(v, nextx-8, nexty-15, v.puyoskins[puyoskin][pcolor[color2]][frametop], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
					drawSprite(v, nextx+8, nexty, v.puyoskins[puyoskin][pcolor[color1]][4], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
				elseif(pieces[pnnum] == 3)
					local framecenter = 1
					local frameside = 0
					if(pcolor[color1] == pcolor[color2])
						framecenter = $1|4
						frameside = $1|8
					end
					drawSprite(v, nextx+8, nexty, v.puyoskins[puyoskin][pcolor[color1]][framecenter], false, skindata[puyoskin].hires, skindata[puyoskin].scale
					drawSprite(v, nextx+8, nexty-15, v.puyoskins[puyoskin][pcolor[color1]][2], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
					drawSprite(v, nextx-8, nexty, v.puyoskins[puyoskin][pcolor[color2]][frameside], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
				elseif(pieces[pnnum] == 4)
					local framecenter = 4
					local frametop = 0
					if(pcolor[color1] == pcolor[color2])
						framecenter = $1|1
						frametop = $1|2
					end
					drawSprite(v, nextx+8, nexty, v.puyoskins[puyoskin][pcolor[color1]][framecenter], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
					drawSprite(v, nextx+8, nexty-15, v.puyoskins[puyoskin][pcolor[color2]][frametop], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
					drawSprite(v, nextx-8, nexty, v.puyoskins[puyoskin][pcolor[color1]][8], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
				elseif(pieces[pnnum] == 5)
					drawSprite(v, nextx-8, nexty, v.puyoskins[puyoskin][pcolor[color1]][1], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
					drawSprite(v, nextx-8, nexty-15, v.puyoskins[puyoskin][pcolor[color1]][2], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
					if(pcolor[color1] == pcolor[color2])
						drawSprite(v, nextx+8, nexty, v.puyoskins[puyoskin][pcoloralt[color2]][1], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
						drawSprite(v, nextx+8, nexty-15, v.puyoskins[puyoskin][pcoloralt[color2]][2], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
					else
						drawSprite(v, nextx+8, nexty, v.puyoskins[puyoskin][pcolor[color2]][1], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
						drawSprite(v, nextx+8, nexty-15, v.puyoskins[puyoskin][pcolor[color2]][2], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
					end
				elseif(pieces[pnnum] == 6)
					drawSprite(v, nextx-8, nexty, v.puyoskins[puyoskin][11][pcolor[color1]], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
				end
			end
			pnnum = $1 - 1
		end
	end*/
	v.drawFill(x+nextxoff+2+8, y+nextyoff, 26, 1, color1)	// Top
	local nextflipx = 0
	if(board & 1)
		nextflipx = 19
	end
	v.drawFill(x+nextxoff+2+8+nextflipx, y+nextyoff+40, 7, 1, color1)	// Bottom
	nextflipx = 0
	if(board & 1)
		nextflipx = 25
	end
	v.drawFill(x+nextxoff+2+8+nextflipx, y+nextyoff+1, 1, 39, color1)	// Left side
	nextflipx = 25
	if(board & 1)
		nextflipx = 0
	end
	v.drawFill(x+nextxoff+2+8+nextflipx, y+nextyoff+1, 1, 23, color1)	// Right side
	// Second box
	nextflipx = 25
	if(board & 1)
		nextflipx = -6
	end
	v.drawFill(x+nextxoff+2+8+nextflipx, y+nextyoff+24, 7, 1, color1)	// Top
	nextflipx = 6
	if(board & 1)
		nextflipx = -6
	end
	v.drawFill(x+nextxoff+2+8+nextflipx, y+nextyoff+63, 26, 1, color1)	// Bottom
	nextflipx = 31
	if(board & 1)
		nextflipx = -6
	end
	v.drawFill(x+nextxoff+2+8+nextflipx, y+nextyoff+25, 1, 38, color1)	// Right side
	nextflipx = 6
	if(board & 1)
		nextflipx = 19
	end
	v.drawFill(x+nextxoff+2+8+nextflipx, y+nextyoff+41, 1, 22, color1)	// Left


	if(paused or (menuactive and not netgame))	// Paused?
		and not(puyodebug)
		return	// Can't see the puyo!
	end

	y = $1 + yoff

	if(player.boards[board].allclear)
		or(player.boards[board].allcleartimer > TICRATE)
		or(player.boards[board].allcleartimer & 1)
		if(fourplayer)
			v.drawString(origx+1+(boardwidth*4)+18, origy+25, "  ALL\nCLEAR", V_YELLOWMAP, "center")
		else
			v.drawString(x+1+(boardwidth*8), y+50, "ALL CLEAR", V_YELLOWMAP, "center")
		end
	end

	// End placement
	local tnum = player.boards[board].placingpuyo/boardwidth
	local toplaceypos = (boardheight-bufferrows)*16
	local toplaceypos2 = (boardheight-bufferrows)*16
	local toplacexoff = 0
	local boardoff = 0
	if(player.boards[board].placingpuyorotate == 0)
		or(player.boards[board].placingpuyotype == 5)
		or(player.boards[board].placingpuyotype == 6)
		or((player.boards[board].placingpuyotype == 1 or player.boards[board].placingpuyotype == 2) and player.boards[board].placingpuyorotate == 1)
		toplacexoff = 16
		boardoff = 1
	elseif(player.boards[board].placingpuyorotate == 2)
		or((player.boards[board].placingpuyotype == 1 or player.boards[board].placingpuyotype == 2) and player.boards[board].placingpuyorotate == 3)
		toplacexoff = -16
		boardoff = -1
	end
	local hitthing = false
	while(tnum < boardheight)
		local tile = tnum*boardwidth
		tile = $1 + player.boards[board].placingpuyo%boardwidth
		if not(boardtiles[tile])	// Hit ground!
			or(boardtiles[tile].type)	// Hit puyo!
			if not(boardtiles[tile-boardwidth] and boardtiles[tile-boardwidth].type)
				and not(hitthing)
				hitthing = true
				toplaceypos = ((tile/boardwidth)-bufferrows)*16
			end
		end
		tnum = $1 + 1
	end
	tnum = player.boards[board].placingpuyo/boardwidth
	hitthing = false
	while(tnum < boardheight)
		local tile = tnum*boardwidth
		tile = $1 + (player.boards[board].placingpuyo+boardoff)%boardwidth
		if not(boardtiles[tile])	// Hit ground!
			or(boardtiles[tile].type)	// Hit puyo!
			if not(boardtiles[tile-boardwidth] and boardtiles[tile-boardwidth].type)
				and not(hitthing)
				hitthing = true
				toplaceypos2 = ((tile/boardwidth)-bufferrows)*16
			end
		end
		tnum = $1 + 1
	end
	if(player.boards[board].placingpuyotype == 0)
		if(player.boards[board].placingpuyorotate == 1)
			toplaceypos2 = $1 - 16
		elseif(player.boards[board].placingpuyorotate == 3)
			toplaceypos = $1 - 16
		end
	end
	// Swirl colors
	local swirlcolors = {}
	if(player.boards[board].placingpuyorotate == 0)
		or(player.boards[board].placingpuyorotate == 1)
		swirlcolors[0] = player.boards[board].placingpuyocolor[0]
		swirlcolors[3] = player.boards[board].placingpuyocolor[1]
	else
		swirlcolors[0] = player.boards[board].placingpuyocolor[1]
		swirlcolors[3] = player.boards[board].placingpuyocolor[0]
	end
	if(player.boards[board].placingpuyorotate == 1)
		or(player.boards[board].placingpuyorotate == 2)
		swirlcolors[1] = player.boards[board].placingpuyocolor[0]
		swirlcolors[2] = player.boards[board].placingpuyocolor[1]
	else
		swirlcolors[1] = player.boards[board].placingpuyocolor[1]
		swirlcolors[2] = player.boards[board].placingpuyocolor[0]
	end
	local ljcolors = {}	// 0 = Bottom, 1 = Top, 2 = Side
	ljcolors[0] = player.boards[board].placingpuyocolor[0]

	local ljcolor0 = player.boards[board].placingpuyocolor[0]
	local ljcolor1 = player.boards[board].placingpuyocolor[1]
	if(player.boards[board].placingpuyotype == 1)
		ljcolor0 = player.boards[board].placingpuyocolor[1]
		ljcolor1 = player.boards[board].placingpuyocolor[0]
	end
	if(player.boards[board].placingpuyorotate == 0)
		or(player.boards[board].placingpuyorotate == 2)
		ljcolors[2] = ljcolor1
		ljcolors[1] = ljcolor0
	else
		ljcolors[2] = ljcolor0
		ljcolors[1] = ljcolor1
	end

	if(player.boards[board].placingpuyorotate == 0)
		or(player.boards[board].placingpuyorotate == 3)
		ljcolors[0] = ljcolors[1]
		ljcolors[1] = player.boards[board].placingpuyocolor[0]
	end

	if not(player.starttime)
		and(player.boards[board].state == 0)
	//	and not(player.matchended)
		if(player.boards[board].placingpuyotype == 0)
			drawSprite(v, ((player.boards[board].placingpuyo%boardwidth)*16)+x+1+8, toplaceypos+y+1-8, v.dead[1][player.boards[board].placingpuyocolor[0]-1], fourplayer)
			drawSprite(v, ((player.boards[board].placingpuyo%boardwidth)*16)+x+1+8+toplacexoff, toplaceypos2+y+1-8, v.dead[1][player.boards[board].placingpuyocolor[1]-1], fourplayer)
		elseif(player.boards[board].placingpuyotype == 1)
			or(player.boards[board].placingpuyotype == 2)
			drawSprite(v, ((player.boards[board].placingpuyo%boardwidth)*16)+x+1+8, toplaceypos+y+1-8, v.dead[1][ljcolors[0]-1], fourplayer)
			drawSprite(v, ((player.boards[board].placingpuyo%boardwidth)*16)+x+1+8, toplaceypos+y+1-8-16, v.dead[1][ljcolors[1]-1], fourplayer)
			drawSprite(v, ((player.boards[board].placingpuyo%boardwidth)*16)+x+1+8+toplacexoff, toplaceypos2+y+1-8, v.dead[1][ljcolors[2]-1], fourplayer)
		elseif(player.boards[board].placingpuyotype == 5)
			drawSprite(v, ((player.boards[board].placingpuyo%boardwidth)*16)+x+1+8, toplaceypos+y+1-8, v.dead[1][swirlcolors[0]-1], fourplayer)
			drawSprite(v, ((player.boards[board].placingpuyo%boardwidth)*16)+x+1+8+toplacexoff, toplaceypos2+y+1-8, v.dead[1][swirlcolors[1]-1], fourplayer)
			drawSprite(v, ((player.boards[board].placingpuyo%boardwidth)*16)+x+1+8, toplaceypos+y+1-8-16, v.dead[1][swirlcolors[2]-1], fourplayer)
			drawSprite(v, ((player.boards[board].placingpuyo%boardwidth)*16)+x+1+8+toplacexoff, toplaceypos2+y+1-8-16, v.dead[1][swirlcolors[3]-1], fourplayer)
		elseif(player.boards[board].placingpuyotype == 6)
			drawSprite(v, ((player.boards[board].placingpuyo%boardwidth)*16)+x+1+8, toplaceypos+y+1-8, v.dead[1][player.boards[board].placingpuyocolor[0]-1], fourplayer)
			drawSprite(v, ((player.boards[board].placingpuyo%boardwidth)*16)+x+1+8+toplacexoff, toplaceypos2+y+1-8, v.dead[1][player.boards[board].placingpuyocolor[0]-1], fourplayer)
			drawSprite(v, ((player.boards[board].placingpuyo%boardwidth)*16)+x+1+8, toplaceypos+y+1-8-16, v.dead[1][player.boards[board].placingpuyocolor[0]-1], fourplayer)
			drawSprite(v, ((player.boards[board].placingpuyo%boardwidth)*16)+x+1+8+toplacexoff, toplaceypos2+y+1-8-16, v.dead[1][player.boards[board].placingpuyocolor[0]-1], fourplayer)
		end
	end

	tnum = (boardwidth*boardheight)-1
	while(tnum >= 0)
		and(tnum >= boardwidth*bufferrows or not(player.boards[board].lostyoff) or not showboard)
		and(((tnum/boardwidth) /*+ (useboardyoff/16)*/ > bufferrows-1) or not(useboardyoff))
		if(boardtiles[tnum].type)
			local sprite = 0
			local byp = (boardheight-(tnum/boardwidth))-1
			local byoff = useboardyoff-(16*byp)+(16*boardheight)
			local nextby = useboardyoff-(16*(byp+1))+(16*boardheight)
			if(byoff > 0)
				byoff = 0
			end
			if(nextby > 0)
				nextby = 0
			end
			if not(boardtiles[tnum].type == 6)	// Not garbage puyo!
				and not(boardtiles[tnum].type == 7)	// Not sun puyo!
				and not(boardtiles[tnum].type == 8)	// Not block puyo!
				and not(boardtiles[tnum].inair)
				and not(byoff)						// This is the same as in air, effectively
				if(boardtiles[tnum].removetime)
					and not(player.boards[board].flashtime)
					sprite = 18
				elseif(boardtiles[boardtiles[tnum].bottompiece-boardwidth].squish)
					if(AngleFixed(boardtiles[boardtiles[tnum].bottompiece-boardwidth].squish) > (90*FRACUNIT)-squishangle)
						and(AngleFixed(boardtiles[boardtiles[tnum].bottompiece-boardwidth].squish) < (90*FRACUNIT)+squishangle)
						sprite = 17
					end
				elseif not(boardtiles[boardtiles[tnum].bottompiece-boardwidth].squish)
					local cantanimate = false
					if(boardtiles[tnum-boardwidth] and boardtiles[tnum-boardwidth].type == boardtiles[tnum].type and tnum/boardwidth > bufferrows)
						and not(boardtiles[tnum-boardwidth].momentum)
						and not(nextby)	// Can't connect with this!
						sprite = $1|1
					end
					if(boardtiles[tnum+boardwidth] and boardtiles[tnum+boardwidth].type == boardtiles[tnum].type)
						and not(boardtiles[tnum+boardwidth].momentum)
						sprite = $1|2
					end
					if(boardtiles[tnum-1] and boardtiles[tnum-1].type == boardtiles[tnum].type and tnum%boardwidth > 0)
						and not(boardtiles[tnum-1].momentum)
						and((not boardtiles[tnum+boardwidth]) or boardtiles[tnum+boardwidth].type)
						and((not boardtiles[tnum-1+boardwidth]) or boardtiles[tnum-1+boardwidth].type)
						if not(tnum%boardwidth and boardtiles[boardtiles[tnum-1].bottompiece-boardwidth].squish)
							sprite = $1|4
						end
						cantanimate = true
					end
					if(boardtiles[tnum+1] and boardtiles[tnum+1].type == boardtiles[tnum].type and tnum%boardwidth < boardwidth-1)
						and not(boardtiles[tnum+1].momentum)
						and((not boardtiles[tnum+boardwidth]) or boardtiles[tnum+boardwidth].type)
						and((not boardtiles[tnum+1+boardwidth]) or boardtiles[tnum+1+boardwidth].type)
						if not(tnum%boardwidth < boardwidth-1 and boardtiles[boardtiles[tnum+1].bottompiece-boardwidth].squish)
							sprite = $1|8
						end
						cantanimate = true
					end
					if(sprite == 0)
						and(skindata[puyoskin].hasanims)
						and not(cantanimate)
						and not(boardtiles.momentum)
						and((not boardtiles[tnum+boardwidth]) or boardtiles[tnum+boardwidth].type)
						and(boardtiles[tnum].type == puyoanims[player.puyoanim].color)
						sprite = puyoanims[player.puyoanim].frames[player.puyoframe]
						if(sprite > 0)
							sprite = $1 + 19
						end
					end
				end
			end
			if not(player.boards[board].flashtime & 1)
				or not(boardtiles[tnum].removetime)
				local puyox = ((tnum%boardwidth)*16)+x+1
				local puyoy = ((tnum/boardwidth)*16)-(bufferrows*16)+y+boardtiles[tnum].yoff+byoff
				if not(boardtiles[tnum].inair)
					and not(boardtiles[tnum].type == 8)
					// Get the top piece!
					local toppiece = tnum/boardwidth
					local add = tnum%boardwidth
					while(toppiece > 0)
						and(boardtiles[(toppiece*boardwidth)+add] and boardtiles[(toppiece*boardwidth)+add].type)
						and not(boardtiles[(toppiece*boardwidth)+add].type == 8)
						toppiece = $1 - 1
					end
					toppiece = $1 + 1
					toppiece = $1 * boardwidth
					toppiece = $1 + add
					if not(byoff)
						puyoy = $1+GetSquishOff(boardtiles, tnum, (toppiece-boardtiles[tnum].bottompiece)/boardwidth, boardtiles[tnum].bottompiece)
					end
				end
				if(player.boards[board].fever)
					and(boardtiles[tnum].removetime)
					and not(player.boards[board].flashtime)
					drawPuyo(v, puyox, puyoy, v.puyoskins[puyoskin][boardtiles[tnum].type-1][sprite], fourplayer, boardtiles[tnum].removetime, skindata[puyoskin].hires, skindata[puyoskin].scale)
				else
					drawSprite(v, puyox, puyoy, v.puyoskins[puyoskin][boardtiles[tnum].type-1][sprite], fourplayer, skindata[puyoskin].hires, skindata[puyoskin].scale)
				end
			end
		end
		tnum = $1 - 1
	end
	if(player.boards[board].state == 0)
	//	and not(player.matchended)
		local flashing = 0
		if(leveltime%flashtime*2 >= flashtime)
			flashing = 19
		end
		local frame = 0
		if(player.boards[board].placingpuyoshake)
			frame = (player.boards[board].placingpuyoshake/2)%4
			if(frame == 1)
				frame = 16
			elseif(frame == 2)
				frame = 0
			elseif(frame == 3)
				frame = 17
			end
		end
		if(frame)
			flashing = frame
		end
		local xoff = 0
		if(player.boards[board].justmoved == 1)
			xoff = -8
		elseif(player.boards[board].justmoved)
			xoff = 8
		end
		local moving = true
		if(abs(player.boards[board].placingpuyorotate2-(player.boards[board].placingpuyorotate*90*FRACUNIT)) < rotatespeed)
			moving = false
		end
		if(player.boards[board].placingpuyotype == 0)
			drawSprite(v, ((player.boards[board].placingpuyo%boardwidth)*16)+x+1+xoff, (((player.boards[board].placingpuyo/boardwidth)-bufferrows)*16)+y-(player.boards[board].placingpuyoyoffset/FRACUNIT), v.puyoskins[puyoskin][player.boards[board].placingpuyocolor[0]-1][flashing], fourplayer, skindata[puyoskin].hires, skindata[puyoskin].scale)
			local pcos = FixedMul(cos(FixedAngle(player.boards[board].placingpuyorotate2)), 16*FRACUNIT)/FRACUNIT
			local psin = FixedMul(sin(FixedAngle(player.boards[board].placingpuyorotate2)), 16*FRACUNIT)/FRACUNIT
			drawSprite(v, ((player.boards[board].placingpuyo%boardwidth)*16)+x+pcos+1+xoff, (((player.boards[board].placingpuyo/boardwidth)-bufferrows)*16)+y-(player.boards[board].placingpuyoyoffset/FRACUNIT)-psin, v.puyoskins[puyoskin][player.boards[board].placingpuyocolor[1]-1][frame], fourplayer, skindata[puyoskin].hires, skindata[puyoskin].scale)
		elseif(player.boards[board].placingpuyotype >= 1 and player.boards[board].placingpuyotype <= 4)
			local ljcolors = {}
			ljcolors[0] = player.boards[board].placingpuyocolor[0]	// Pivot
			ljcolors[1] = player.boards[board].placingpuyocolor[0]	// Top (assuming rotation is 1)
			ljcolors[2] = player.boards[board].placingpuyocolor[1]	// Side (assuming rotation is 1)
			if not(player.boards[board].placingpuyotype & 1)	// Wide
				ljcolors[1] = player.boards[board].placingpuyocolor[1]
				ljcolors[2] = player.boards[board].placingpuyocolor[0]
			end
			local ljframe = 0
			if not(moving)	// Stable?
				if(ljcolors[1] == ljcolors[0])	// Top is the same
					if(player.boards[board].placingpuyorotate == 1)
						ljframe = $1|1
					elseif(player.boards[board].placingpuyorotate == 3)
						ljframe = $1|2
					elseif(player.boards[board].placingpuyorotate == 2)
						ljframe = $1|4
					else
						ljframe = $1|8
					end
				end
				if(ljcolors[2] == ljcolors[0])	// Side is the same
					if(player.boards[board].placingpuyorotate == 1)
						if(player.boards[board].placingpuyotype <= 2)
							ljframe = $1|8
						else
							ljframe = $1|4
						end
					elseif(player.boards[board].placingpuyorotate == 3)
						if(player.boards[board].placingpuyotype <= 2)
							ljframe = $1|4
						else
							ljframe = $1|8
						end
					elseif(player.boards[board].placingpuyorotate == 2)
						if(player.boards[board].placingpuyotype <= 2)
							ljframe = $1|1
						else
							ljframe = $1|2
						end
					else
						if(player.boards[board].placingpuyotype <= 2)
							ljframe = $1|2
						else
							ljframe = $1|1
						end
					end
				end
			end
			drawSprite(v, ((player.boards[board].placingpuyo%boardwidth)*16)+x+1+xoff, (((player.boards[board].placingpuyo/boardwidth)-bufferrows)*16)+y-(player.boards[board].placingpuyoyoffset/FRACUNIT), v.puyoskins[puyoskin][ljcolors[0]-1][ljframe], fourplayer, skindata[puyoskin].hires, skindata[puyoskin].scale)
			local rnum = 0
			while(rnum < 2)
				local rot = player.boards[board].placingpuyorotate2
				if(rnum)
					rot = $1 - (90*FRACUNIT)
					if(player.boards[board].placingpuyotype > 2)	// J
						rot = $1 + (180*FRACUNIT)
					end
				end

				ljframe = 0
				if not(moving)	// Stable?
					if(ljcolors[rnum+1] == ljcolors[0])	// Top is the same
						if not(rnum)
							if(player.boards[board].placingpuyorotate == 1)
								ljframe = $1|2
							elseif(player.boards[board].placingpuyorotate == 3)
								ljframe = $1|1
							elseif(player.boards[board].placingpuyorotate == 2)
								ljframe = $1|8
							else
								ljframe = $1|4
							end
						else
							if(player.boards[board].placingpuyorotate == 1)
								if(player.boards[board].placingpuyotype <= 2)
									ljframe = $1|4
								else
									ljframe = $1|8
								end
							elseif(player.boards[board].placingpuyorotate == 3)
								if(player.boards[board].placingpuyotype <= 2)
									ljframe = $1|8
								else
									ljframe = $1|4
								end
							elseif(player.boards[board].placingpuyorotate == 2)
								if(player.boards[board].placingpuyotype <= 2)
									ljframe = $1|2
								else
									ljframe = $1|1
								end
							else
								if(player.boards[board].placingpuyotype <= 2)
									ljframe = $1|1
								else
									ljframe = $1|2
								end
							end
						end
					end
				end

				local pcos = FixedMul(cos(FixedAngle(rot)), 16*FRACUNIT)/FRACUNIT
				local psin = FixedMul(sin(FixedAngle(rot)), 16*FRACUNIT)/FRACUNIT
				drawSprite(v, ((player.boards[board].placingpuyo%boardwidth)*16)+x+pcos+1+xoff, (((player.boards[board].placingpuyo/boardwidth)-bufferrows)*16)+y-(player.boards[board].placingpuyoyoffset/FRACUNIT)-psin, v.puyoskins[puyoskin][ljcolors[rnum+1]-1][ljframe], fourplayer, skindata[puyoskin].hires, skindata[puyoskin].scale)
				rnum = $1 + 1
			end
		elseif(player.boards[board].placingpuyotype == 5)
			local snum = 0
			local swirlframes = {}
			if(moving)
				swirlframes[0] = frame
				swirlframes[1] = frame
				swirlframes[2] = frame
				swirlframes[3] = frame
			elseif(player.boards[board].placingpuyorotate == 0)
				swirlframes[0] = 1
				swirlframes[1] = 2
				swirlframes[2] = 2
				swirlframes[3] = 1
			elseif(player.boards[board].placingpuyorotate == 1)
				swirlframes[0] = 4
				swirlframes[1] = 8
				swirlframes[2] = 8
				swirlframes[3] = 4
			elseif(player.boards[board].placingpuyorotate == 2)
				swirlframes[0] = 2
				swirlframes[1] = 1
				swirlframes[2] = 1
				swirlframes[3] = 2
			elseif(player.boards[board].placingpuyorotate == 3)
				swirlframes[0] = 8
				swirlframes[1] = 4
				swirlframes[2] = 4
				swirlframes[3] = 8
			else
				swirlframes[0] = frame
				swirlframes[1] = frame
				swirlframes[2] = frame
				swirlframes[3] = frame
			end
			while(snum < 4)
				local pcos = FixedMul(cos(FixedAngle(player.boards[board].placingpuyorotate2+((225-(snum*360/4))*FRACUNIT))), 12*FRACUNIT)/FRACUNIT
				local psin = FixedMul(sin(FixedAngle(player.boards[board].placingpuyorotate2+((225-(snum*360/4))*FRACUNIT))), 12*FRACUNIT)/FRACUNIT
				if(snum < 2)
					drawSprite(v, ((player.boards[board].placingpuyo%boardwidth)*16)+x+pcos+1+xoff+8, (((player.boards[board].placingpuyo/boardwidth)-bufferrows)*16)+y-(player.boards[board].placingpuyoyoffset/FRACUNIT)-psin-8, v.puyoskins[puyoskin][player.boards[board].placingpuyocolor[0]-1][swirlframes[snum]], fourplayer, skindata[puyoskin].hires, skindata[puyoskin].scale)
				else
					drawSprite(v, ((player.boards[board].placingpuyo%boardwidth)*16)+x+pcos+1+xoff+8, (((player.boards[board].placingpuyo/boardwidth)-bufferrows)*16)+y-(player.boards[board].placingpuyoyoffset/FRACUNIT)-psin-8, v.puyoskins[puyoskin][player.boards[board].placingpuyocolor[1]-1][swirlframes[snum]], fourplayer, skindata[puyoskin].hires, skindata[puyoskin].scale)
				end
				snum = $1 + 1
			end
		elseif(player.boards[board].placingpuyotype == 6)
			drawSprite(v, ((player.boards[board].placingpuyo%boardwidth)*16)+x+1+xoff, (((player.boards[board].placingpuyo/boardwidth)-bufferrows)*16)+y-(player.boards[board].placingpuyoyoffset/FRACUNIT), v.puyoskins[puyoskin][11][player.boards[board].placingpuyocolor[0]-1], fourplayer, skindata[puyoskin].hires, skindata[puyoskin].scale)
		end
	end
	// Effects
	local enum = 0
	while(enum < numeffects)
		if(player.boards[board].effectstype[enum])
			if(player.boards[board].effectstype[enum] <= 5)
				local frame = player.boards[board].effectstimer[enum]*5/effecttime
				if(frame == 4)
					frame = 0
				elseif(frame == 3)
					frame = 1
				end
				drawSprite(v, (player.boards[board].effectsx[enum]/FRACUNIT)+x+1, (player.boards[board].effectsy[enum]/FRACUNIT)+y+1, v.dead[frame][player.boards[board].effectstype[enum]-1], fourplayer)
			else
				drawSprite(v, (player.boards[board].effectsx[enum]/FRACUNIT)+x+1, (player.boards[board].effectsy[enum]/FRACUNIT)+y+1, v.puyoskins[puyoskin][player.boards[board].effectstype[enum]-6][18], fourplayer, skindata[puyoskin].hires, skindata[puyoskin].scale)
			end
		end
		enum = $1 + 1
	end
	// Draw next... again
	y = $1 - yoff
	v.drawFill(x+nextxoff+2+8+1, y+nextyoff+1, 24, 39, color2)
	v.drawFill(x+nextxoff+2+8+nextxoff2+1, y+nextyoff+23+1, 24, 39, color2)
	if not(paused or (menuactive and not netgame))
		or(puyodebug)
		local pnnum = 2
		while(pnnum >= 0)
			local nextx = 0
			local nexty = 0
			local dontdraw = false
			if(pnnum == 2)
				if(player.boards[board].nexttime == 7 or player.boards[board].nexttime == 8)	// Hard coded fix
					and(fourplayer)
					dontdraw = true
				end
				nextx = x+nextxoff+2+9+(8*xmul)+4-2
				nexty = y+46+nexttimeyoff+nextyoff-16+3+8
			elseif(pnnum == 1)
				local nextmoveoff = ((nexttimeyoff/6)*xmul)
				if(nextmoveoff > 7)
					nextmoveoff = 7
				end
				nexty = y+30+nexttimeyoff/2+nextyoff-16+3
				nextx = x+nextxoff+2+9+nextmoveoff+4
			else
				nextx = x+nextxoff+2+9+4
				nexty = y+30-32+(nexttimeyoff*4/6)+nextyoff-16+3
			end

			// Draw the thing
			local color1 = pnnum*2
			local color2 = (pnnum*2)+1
			if not(dontdraw)
				if(pieces[pnnum] == 0)
					or not(player.boards[board].dropsets)
					drawSprite(v, nextx, nexty, v.puyoskins[puyoskin][pcolor[color1]][0], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
					drawSprite(v, nextx, nexty-15, v.puyoskins[puyoskin][pcolor[color2]][0], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
				elseif(pieces[pnnum] == 1)
					local framecenter = 1
					local frameside = 0
					if(pcolor[color1] == pcolor[color2])
						framecenter = $1|8
						frameside = $1|4
					end
					drawSprite(v, nextx-8, nexty, v.puyoskins[puyoskin][pcolor[color1]][framecenter], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
					drawSprite(v, nextx-8, nexty-15, v.puyoskins[puyoskin][pcolor[color1]][2], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
					drawSprite(v, nextx+8, nexty, v.puyoskins[puyoskin][pcolor[color2]][frameside], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
				elseif(pieces[pnnum] == 2)
					local framecenter = 8
					local frametop = 0
					if(pcolor[color1] == pcolor[color2])
						framecenter = $1|1
						frametop = $1|2
					end
					drawSprite(v, nextx-8, nexty, v.puyoskins[puyoskin][pcolor[color1]][framecenter], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
					drawSprite(v, nextx-8, nexty-15, v.puyoskins[puyoskin][pcolor[color2]][frametop], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
					drawSprite(v, nextx+8, nexty, v.puyoskins[puyoskin][pcolor[color1]][4], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
				elseif(pieces[pnnum] == 3)
					local framecenter = 1
					local frameside = 0
					if(pcolor[color1] == pcolor[color2])
						framecenter = $1|4
						frameside = $1|8
					end
					drawSprite(v, nextx+8, nexty, v.puyoskins[puyoskin][pcolor[color1]][framecenter], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
					drawSprite(v, nextx+8, nexty-15, v.puyoskins[puyoskin][pcolor[color1]][2], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
					drawSprite(v, nextx-8, nexty, v.puyoskins[puyoskin][pcolor[color2]][frameside], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
				elseif(pieces[pnnum] == 4)
					local framecenter = 4
					local frametop = 0
					if(pcolor[color1] == pcolor[color2])
						framecenter = $1|1
						frametop = $1|2
					end
					drawSprite(v, nextx+8, nexty, v.puyoskins[puyoskin][pcolor[color1]][framecenter], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
					drawSprite(v, nextx+8, nexty-15, v.puyoskins[puyoskin][pcolor[color2]][frametop], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
					drawSprite(v, nextx-8, nexty, v.puyoskins[puyoskin][pcolor[color1]][8], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
				elseif(pieces[pnnum] == 5)
					drawSprite(v, nextx-8, nexty, v.puyoskins[puyoskin][pcolor[color1]][1], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
					drawSprite(v, nextx-8, nexty-15, v.puyoskins[puyoskin][pcolor[color1]][2], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
					if(pcolor[color1] == pcolor[color2])
						drawSprite(v, nextx+8, nexty, v.puyoskins[puyoskin][pcoloralt[color2]][1], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
						drawSprite(v, nextx+8, nexty-15, v.puyoskins[puyoskin][pcoloralt[color2]][2], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
					else
						drawSprite(v, nextx+8, nexty, v.puyoskins[puyoskin][pcolor[color2]][1], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
						drawSprite(v, nextx+8, nexty-15, v.puyoskins[puyoskin][pcolor[color2]][2], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
					end
				elseif(pieces[pnnum] == 6)
					drawSprite(v, nextx-8, nexty, v.puyoskins[puyoskin][11][pcolor[color1]], false, skindata[puyoskin].hires, skindata[puyoskin].scale)
				end
			end
			pnnum = $1 - 1
		end
	end
	v.drawFill(x+nextxoff+2+8, y+nextyoff, 26, 1, color1)	// Top
	local nextflipx = 0
	if(board & 1)
		nextflipx = 19
	end
	v.drawFill(x+nextxoff+2+8+nextflipx, y+nextyoff+40, 7, 1, color1)	// Bottom
	nextflipx = 0
	if(board & 1)
		nextflipx = 25
	end
	v.drawFill(x+nextxoff+2+8+nextflipx, y+nextyoff+1, 1, 39, color1)	// Left side
	nextflipx = 25
	if(board & 1)
		nextflipx = 0
	end
	v.drawFill(x+nextxoff+2+8+nextflipx, y+nextyoff+1, 1, 23, color1)	// Right side
	// Second box
	nextflipx = 25
	if(board & 1)
		nextflipx = -6
	end
	v.drawFill(x+nextxoff+2+8+nextflipx, y+nextyoff+24, 7, 1, color1)	// Top
	nextflipx = 6
	if(board & 1)
		nextflipx = -6
	end
	v.drawFill(x+nextxoff+2+8+nextflipx, y+nextyoff+63, 26, 1, color1)	// Bottom
	nextflipx = 31
	if(board & 1)
		nextflipx = -6
	end
	v.drawFill(x+nextxoff+2+8+nextflipx, y+nextyoff+25, 1, 38, color1)	// Right side
	nextflipx = 6
	if(board & 1)
		nextflipx = 19
	end
	v.drawFill(x+nextxoff+2+8+nextflipx, y+nextyoff+41, 1, 22, color1)	// Left
//	v.drawFill(x, y, (boardwidth*16)+2, ((boardheight-bufferrows)*16)+2, 152)
	y = $1 + yoff
	if(showboard)
		if(fourplayer)
			v.drawFill(origx, origy, 1, ((boardheight-bufferrows)*8)+2, color1)
			v.drawFill(origx+(boardwidth*8)+1, origy, 1, ((boardheight-bufferrows)*8)+2, color1)
			v.drawFill(origx, origy, (boardwidth*8)+2, 1, color1)
			v.drawFill(origx, origy+((boardheight-bufferrows)*8)+1, (boardwidth*8)+2, 1, color1)
		else
			v.drawFill(x, y, 1, ((boardheight-bufferrows)*16)+2, color1)
			v.drawFill(x+(boardwidth*16)+1, y, 1, ((boardheight-bufferrows)*16)+2, color1)
			v.drawFill(x, y, (boardwidth*16)+2, 1, color1)
			v.drawFill(x, y+((boardheight-bufferrows)*16)+1, (boardwidth*16)+2, 1, color1)
		end
	end

	// Draw switch
	if(player.boards[board].feverswitchtime)
		local sizex = FRACUNIT-(abs(((player.boards[board].feverswitchtime*FRACUNIT)/feverswitchtime)-(FRACUNIT/2))*2)
		if(player.boards[board].feverswitchtime == feverswitchtime/2)
			sizex = FRACUNIT	// So it always has at least *one* frame covering the whole board
		end
		if(fourplayer)
			local wide = ((boardwidth*8))
			local wide2 = wide*(FRACUNIT-sizex)/FRACUNIT
			v.drawFill(origx+1+(wide2/2), origy+yoff+1, wide*sizex/FRACUNIT, ((boardheight-bufferrows)*8), 31)
		else
			local wide = ((boardwidth*16))
			local wide2 = wide*(FRACUNIT-sizex)/FRACUNIT
			v.drawFill(origx+1+(wide2/2), origy+yoff+1, wide*sizex/FRACUNIT, ((boardheight-bufferrows)*16), 31)
		end
	end
end

local function drawGarbageStuff(v, x, y, patch, flags, scale)
	if(flags & V_SMALLSCALEPATCH)
		flags = $1 & !V_SMALLSCALEPATCH
		v.drawScaled(x*FRACUNIT, y*FRACUNIT, scale/2, patch, flags)
	else
		v.drawScaled(x*FRACUNIT, y*FRACUNIT, scale, patch, flags)
	end
end

local function drawGarbage(v, player, board, x, y, puyoskin)
	// Garbage! (Kind of overlaps the top of the screen...
	local gxoff = 0
	local gtodraw = player.boards[board].garbagetray+player.boards[board].extragarbage[0]+player.boards[board].extragarbage[1]+player.boards[board].extragarbage[2]+player.boards[board].extragarbage[3]
	local numcommets = 0
	local flags = 0
	local mul = 16
	if(player.numplayers > 2)
		flags = V_SMALLSCALEPATCH
		mul = 8
	end
	if(player.boards[board].fevermode)
		flags = $1|V_50TRANS
		y = $1 - 6
		x = $1 - 4
	end

	local scale = FRACUNIT
	if(skindata[puyoskin].garbhires)
		scale = skindata[puyoskin].scale
	end

	while(gxoff < 6)
		and(numcommets < 3)
		if(gtodraw >= 240*6)
			drawGarbageStuff(v, x+1+(gxoff*mul), y-6, v.puyoskins[puyoskin][9][6], flags, scale)
			gtodraw = $1 - (240*6)
			numcommets = $1 + 1
		elseif(gtodraw >= 120*6)
			drawGarbageStuff(v, x+1+(gxoff*mul), y-6, v.puyoskins[puyoskin][9][5], flags, scale)
			gtodraw = $1 - (120*6)
		elseif(gtodraw >= 60*6)
			drawGarbageStuff(v, x+1+(gxoff*mul), y-6, v.puyoskins[puyoskin][9][4], flags, scale)
			gtodraw = $1 - (60*6)
		elseif(gtodraw >= 30*6)
			drawGarbageStuff(v, x+1+(gxoff*mul), y-6, v.puyoskins[puyoskin][9][3], flags, scale)
			gtodraw = $1 - (30*6)
		elseif(gtodraw >= 5*6)
			drawGarbageStuff(v, x+1+(gxoff*mul), y-6, v.puyoskins[puyoskin][9][2], flags, scale)
			gtodraw = $1 - (5*6)
		elseif(gtodraw >= 6)
			drawGarbageStuff(v, x+1+(gxoff*mul), y-6, v.puyoskins[puyoskin][9][1], flags, scale)
			gtodraw = $1 - 6
		elseif(gtodraw >= 1)
			drawGarbageStuff(v, x+1+(gxoff*mul), y-6, v.puyoskins[puyoskin][9][0], flags, scale)
			gtodraw = $1 - 1
		end
		gxoff = $1 + 1
	end
	if(player.boards[board].fevermode)
		flags = $1 & !V_50TRANS
		gxoff = 0
		gtodraw = player.boards[board].fevergarbagetray+player.boards[board].feverextragarbage[0]+player.boards[board].feverextragarbage[1]+player.boards[board].feverextragarbage[2]+player.boards[board].feverextragarbage[3]
		numcommets = 0
		y = $1 + 6
		x = $1 + 4
		while(gxoff < 6)
			and(numcommets < 3)
			if(gtodraw >= 240*6)
				drawGarbageStuff(v, x+1+(gxoff*mul), y-6, v.puyoskins[puyoskin][9][6], flags, scale)
				gtodraw = $1 - (240*6)
				numcommets = $1 + 1
			elseif(gtodraw >= 120*6)
				drawGarbageStuff(v, x+1+(gxoff*mul), y-6, v.puyoskins[puyoskin][9][5], flags, scale)
				gtodraw = $1 - (120*6)
			elseif(gtodraw >= 60*6)
				drawGarbageStuff(v, x+1+(gxoff*mul), y-6, v.puyoskins[puyoskin][9][4], flags, scale)
				gtodraw = $1 - (60*6)
			elseif(gtodraw >= 30*6)
				drawGarbageStuff(v, x+1+(gxoff*mul), y-6, v.puyoskins[puyoskin][9][3], flags, scale)
				gtodraw = $1 - (30*6)
			elseif(gtodraw >= 5*6)
				drawGarbageStuff(v, x+1+(gxoff*mul), y-6, v.puyoskins[puyoskin][9][2], flags, scale)
				gtodraw = $1 - (5*6)
			elseif(gtodraw >= 6)
				drawGarbageStuff(v, x+1+(gxoff*mul), y-6, v.puyoskins[puyoskin][9][1], flags, scale)
				gtodraw = $1 - 6
			elseif(gtodraw >= 1)
				drawGarbageStuff(v, x+1+(gxoff*mul), y-6, v.puyoskins[puyoskin][9][0], flags, scale)
				gtodraw = $1 - 1
			end
			gxoff = $1 + 1
		end
	end
end

local function drawChainText(v, player, board, x, y)
	// Draw chain text
	if(player.boards[board].chaineffecttimer)
		and not(player.boards[board].chaineffecttimer > chaineffflashtime and (player.boards[board].chaineffecttimer & 1))
		local xpos = ((player.boards[board].chaineffectoriginpuyo%boardwidth)*16)+x+9
		local ypos = ((((player.boards[board].chaineffectoriginpuyo/boardwidth)*16)-(bufferrows*16)+y)-player.boards[board].chaineffecttimer)+8
		local text = (player.boards[board].chaineffectnumber+1)+"-CHAIN!"
		v.drawString(xpos, ypos, text, V_YELLOWMAP, "thin-center")
	end
end

local function drawScore(v, player, board, x, y)
	local color = V_BLUEMAP
	if(board == 1)
		color = V_REDMAP
	elseif(board == 2)
		color = V_GREENMAP
	elseif(board == 3)
		color = V_YELLOWMAP
	end
	if(player.boards[board].scoretimer)
		v.drawString(x, y, player.boards[board].scorehalf1+"  x  "+player.boards[board].scorehalf2, color, "right")
	else
		v.drawString(x, y, player.boards[board].score, color, "right")
	end
end

local function cachePuyo(v, p)
	local puyo = {}
	puyo[0] = {}	// Red
	puyo[0][0] = v.cachePatch(p+"RDPUYO1")
	puyo[0][1] = v.cachePatch(p+"RDDOWN")
	puyo[0][2] = v.cachePatch(p+"RDUP")
	puyo[0][3] = v.cachePatch(p+"RDT")				// Tower
	puyo[0][4] = v.cachePatch(p+"RDRIGHT")
	puyo[0][5] = v.cachePatch(p+"RDBR")				// Bottom Right
	puyo[0][6] = v.cachePatch(p+"RDTR")				// Top Right
	puyo[0][7] = v.cachePatch(p+"RDTRIGH")			// T-Right
	puyo[0][8] = v.cachePatch(p+"RDLEFT")
	puyo[0][9] = v.cachePatch(p+"RDBL")				// Bottom Left
	puyo[0][10] = v.cachePatch(p+"RDTL")			// Top Left
	puyo[0][11] = v.cachePatch(p+"RDTLEFT")			// T-Left
	puyo[0][12] = v.cachePatch(p+"RDM")				// Middle
	puyo[0][13] = v.cachePatch(p+"RDTDOWN")			// T-Down
	puyo[0][14] = v.cachePatch(p+"RDTUP")			// T-Up
	puyo[0][15] = v.cachePatch(p+"RDALL")			// All directions
	puyo[0][16] = v.cachePatch(p+"RDPUYO2")			// Stretched
	puyo[0][17] = v.cachePatch(p+"RDPUYO3")			// Squished
	puyo[0][18] = v.cachePatch(p+"RDPUYO4")			// Popping
	puyo[0][19] = v.cachePatch(p+"RDFLASH")			// Flashing
	puyo[0][20] = v.cachePatch(p+"RDIDL1")			// Idle stuff
	puyo[0][21] = v.cachePatch(p+"RDIDL2")
	puyo[0][22] = v.cachePatch(p+"RDIDL3")
	puyo[0][23] = v.cachePatch(p+"RDIDL4")
	puyo[0][24] = v.cachePatch(p+"RDIDL5")
	puyo[0][25] = v.cachePatch(p+"RDIDL6")
	puyo[0][26] = v.cachePatch(p+"RDIDL7")
	puyo[1] = {}	// Green
	puyo[1][0] = v.cachePatch(p+"GRPUYO1")
	puyo[1][1] = v.cachePatch(p+"GRDOWN")
	puyo[1][2] = v.cachePatch(p+"GRUP")
	puyo[1][3] = v.cachePatch(p+"GRT")				// Tower
	puyo[1][4] = v.cachePatch(p+"GRRIGHT")
	puyo[1][5] = v.cachePatch(p+"GRBR")				// Bottom Right
	puyo[1][6] = v.cachePatch(p+"GRTR")				// Top Right
	puyo[1][7] = v.cachePatch(p+"GRTRIGH")			// T-Right
	puyo[1][8] = v.cachePatch(p+"GRLEFT")
	puyo[1][9] = v.cachePatch(p+"GRBL")				// Bottom Left
	puyo[1][10] = v.cachePatch(p+"GRTL")			// Top Left
	puyo[1][11] = v.cachePatch(p+"GRTLEFT")			// T-Left
	puyo[1][12] = v.cachePatch(p+"GRM")				// Middle
	puyo[1][13] = v.cachePatch(p+"GRTDOWN")			// T-Down
	puyo[1][14] = v.cachePatch(p+"GRTUP")			// T-Up
	puyo[1][15] = v.cachePatch(p+"GRALL")			// All directions
	puyo[1][16] = v.cachePatch(p+"GRPUYO2")			// Stretched
	puyo[1][17] = v.cachePatch(p+"GRPUYO3")			// Squished
	puyo[1][18] = v.cachePatch(p+"GRPUYO4")			// Popping
	puyo[1][19] = v.cachePatch(p+"GRFLASH")			// Flashing
	puyo[1][20] = v.cachePatch(p+"GRIDL1")			// Idle stuff
	puyo[1][21] = v.cachePatch(p+"GRIDL2")
	puyo[1][22] = v.cachePatch(p+"GRIDL3")
	puyo[1][23] = v.cachePatch(p+"GRIDL4")
	puyo[1][24] = v.cachePatch(p+"GRIDL5")
	puyo[1][25] = v.cachePatch(p+"GRIDL6")
	puyo[1][26] = v.cachePatch(p+"GRIDL7")
	puyo[1][27] = v.cachePatch(p+"GRIDL8")
	puyo[1][28] = v.cachePatch(p+"GRIDL9")
	puyo[1][29] = v.cachePatch(p+"GRIDL10")
	puyo[1][30] = v.cachePatch(p+"GRIDL11")
	puyo[1][31] = v.cachePatch(p+"GRIDL12")
	puyo[2] = {}	// Blue
	puyo[2][0] = v.cachePatch(p+"BLPUYO1")
	puyo[2][1] = v.cachePatch(p+"BLDOWN")
	puyo[2][2] = v.cachePatch(p+"BLUP")
	puyo[2][3] = v.cachePatch(p+"BLT")				// Tower
	puyo[2][4] = v.cachePatch(p+"BLRIGHT")
	puyo[2][5] = v.cachePatch(p+"BLBR")				// Bottom Right
	puyo[2][6] = v.cachePatch(p+"BLTR")				// Top Right
	puyo[2][7] = v.cachePatch(p+"BLTRIGH")			// T-Right
	puyo[2][8] = v.cachePatch(p+"BLLEFT")
	puyo[2][9] = v.cachePatch(p+"BLBL")				// Bottom Left
	puyo[2][10] = v.cachePatch(p+"BLTL")			// Top Left
	puyo[2][11] = v.cachePatch(p+"BLTLEFT")			// T-Left
	puyo[2][12] = v.cachePatch(p+"BLM")				// Middle
	puyo[2][13] = v.cachePatch(p+"BLTDOWN")			// T-Down
	puyo[2][14] = v.cachePatch(p+"BLTUP")			// T-Up
	puyo[2][15] = v.cachePatch(p+"BLALL")			// All directions
	puyo[2][16] = v.cachePatch(p+"BLPUYO2")			// Stretched
	puyo[2][17] = v.cachePatch(p+"BLPUYO3")			// Squished
	puyo[2][18] = v.cachePatch(p+"BLPUYO4")			// Regretting life choices (popping)
	puyo[2][19] = v.cachePatch(p+"BLFLASH")			// Flashing
	puyo[2][20] = v.cachePatch(p+"BLIDL1")			// Idle stuff
	puyo[2][21] = v.cachePatch(p+"BLIDL2")
	puyo[2][22] = v.cachePatch(p+"BLIDL3")
	puyo[2][23] = v.cachePatch(p+"BLIDL4")
	puyo[2][24] = v.cachePatch(p+"BLIDL5")
	puyo[2][25] = v.cachePatch(p+"BLIDL6")
	puyo[2][26] = v.cachePatch(p+"BLIDL7")
	puyo[2][27] = v.cachePatch(p+"BLIDL8")
	puyo[2][28] = v.cachePatch(p+"BLIDL9")
	puyo[3] = {}	// Yellow
	puyo[3][0] = v.cachePatch(p+"YLPUYO1")
	puyo[3][1] = v.cachePatch(p+"YLDOWN")
	puyo[3][2] = v.cachePatch(p+"YLUP")
	puyo[3][3] = v.cachePatch(p+"YLT")				// Tower
	puyo[3][4] = v.cachePatch(p+"YLRIGHT")
	puyo[3][5] = v.cachePatch(p+"YLBR")				// Bottom Right
	puyo[3][6] = v.cachePatch(p+"YLTR")				// Top Right
	puyo[3][7] = v.cachePatch(p+"YLTRIGH")			// T-Right
	puyo[3][8] = v.cachePatch(p+"YLLEFT")
	puyo[3][9] = v.cachePatch(p+"YLBL")				// Bottom Left
	puyo[3][10] = v.cachePatch(p+"YLTL")			// Top Left
	puyo[3][11] = v.cachePatch(p+"YLTLEFT")			// T-Left
	puyo[3][12] = v.cachePatch(p+"YLM")				// Middle
	puyo[3][13] = v.cachePatch(p+"YLTDOWN")			// T-Down
	puyo[3][14] = v.cachePatch(p+"YLTUP")			// T-Up
	puyo[3][15] = v.cachePatch(p+"YLALL")			// All directions
	puyo[3][16] = v.cachePatch(p+"YLPUYO2")			// Stretched
	puyo[3][17] = v.cachePatch(p+"YLPUYO3")			// Squished
	puyo[3][18] = v.cachePatch(p+"YLPUYO4")			// Popping
	puyo[3][19] = v.cachePatch(p+"YLFLASH")			// Flashing
	puyo[3][20] = v.cachePatch(p+"YLIDL1")			// Idle stuff
	puyo[3][21] = v.cachePatch(p+"YLIDL2")
	puyo[3][22] = v.cachePatch(p+"YLIDL3")
	puyo[3][23] = v.cachePatch(p+"YLIDL4")
	puyo[3][24] = v.cachePatch(p+"YLIDL5")
	puyo[3][25] = v.cachePatch(p+"YLIDL6")
	puyo[3][26] = v.cachePatch(p+"YLIDL7")
	puyo[3][27] = v.cachePatch(p+"YLIDL8")
	puyo[3][28] = v.cachePatch(p+"YLIDL9")
	puyo[4] = {}	// Purple
	puyo[4][0] = v.cachePatch(p+"PRPUYO1")
	puyo[4][1] = v.cachePatch(p+"PRDOWN")
	puyo[4][2] = v.cachePatch(p+"PRUP")
	puyo[4][3] = v.cachePatch(p+"PRT")				// Tower
	puyo[4][4] = v.cachePatch(p+"PRRIGHT")
	puyo[4][5] = v.cachePatch(p+"PRBR")				// Bottom Right
	puyo[4][6] = v.cachePatch(p+"PRTR")				// Top Right
	puyo[4][7] = v.cachePatch(p+"PRTRIGH")			// T-Right
	puyo[4][8] = v.cachePatch(p+"PRLEFT")
	puyo[4][9] = v.cachePatch(p+"PRBL")				// Bottom Left
	puyo[4][10] = v.cachePatch(p+"PRTL")			// Top Left
	puyo[4][11] = v.cachePatch(p+"PRTLEFT")			// T-Left
	puyo[4][12] = v.cachePatch(p+"PRM")				// Middle
	puyo[4][13] = v.cachePatch(p+"PRTDOWN")			// T-Down
	puyo[4][14] = v.cachePatch(p+"PRTUP")			// T-Up
	puyo[4][15] = v.cachePatch(p+"PRALL")			// All directions
	puyo[4][16] = v.cachePatch(p+"PRPUYO2")			// Stretched
	puyo[4][17] = v.cachePatch(p+"PRPUYO3")			// Squished
	puyo[4][18] = v.cachePatch(p+"PRPUYO4")			// Popping
	puyo[4][19] = v.cachePatch(p+"PRFLASH")			// Flashing
	puyo[4][20] = v.cachePatch(p+"PRIDL1")			// Idle stuff
	puyo[4][21] = v.cachePatch(p+"PRIDL2")
	puyo[4][22] = v.cachePatch(p+"PRIDL3")
	puyo[4][23] = v.cachePatch(p+"PRIDL4")
	puyo[4][24] = v.cachePatch(p+"PRIDL5")
	puyo[4][25] = v.cachePatch(p+"PRIDL6")
	puyo[4][26] = v.cachePatch(p+"PRIDL7")
	puyo[4][27] = v.cachePatch(p+"PRIDL8")
	puyo[4][28] = v.cachePatch(p+"PRIDL9")
	puyo[5] = {}	// Garbage/Nusiance
	puyo[5][0] = v.cachePatch(p+"NUPUYO1")
	puyo[5][1] = v.cachePatch(p+"NUPUYO2")
	puyo[5][2] = v.cachePatch(p+"NUPUYO3")
	puyo[6] = {}	// Sun
	puyo[6][0] = v.cachePatch(p+"SUPUYO1")
	puyo[6][1] = v.cachePatch(p+"SUPUYO2")
	puyo[6][2] = v.cachePatch(p+"SUPUYO3")
	puyo[6][3] = v.cachePatch(p+"SUPUYO4")
	puyo[6][4] = v.cachePatch(p+"SUPUYO5")
	puyo[7] = {}	// Block
	puyo[7][0] = v.cachePatch("CBLOCK")
	// 8 is free
	puyo[9] = {}	// Garbage hud
	puyo[9][0] = v.cachePatch(p+"GARBAG1")	// Single puyo
	puyo[9][1] = v.cachePatch(p+"GARBAG2")	// Row of puyo
	puyo[9][2] = v.cachePatch(p+"GARBAG3")	// 5 Rows of puyo	(Rock)
	puyo[9][3] = v.cachePatch(p+"GARBAG4")	// 30 Rows of puyo	(Meteor/Star)
	puyo[9][4] = v.cachePatch(p+"GARBAG5")	// 60 Rows of puyo	(Star/Moon)
	puyo[9][5] = v.cachePatch(p+"GARBAG6")	// 120 Rows of puyo	(Crown)
	puyo[9][6] = v.cachePatch(p+"GARBAG7")	// 240 Rows of puyo	(Commet)
	// 10 is free
	puyo[11] = {}	// Big puyo
	puyo[11][0] = v.cachePatch(p+"RDBIG")
	puyo[11][1] = v.cachePatch(p+"GRBIG")
	puyo[11][2] = v.cachePatch(p+"BLBIG")
	puyo[11][3] = v.cachePatch(p+"YLBIG")
	puyo[11][4] = v.cachePatch(p+"PRBIG")
	puyo[12] = {}	// Tetriminos
	puyo[12][0] = v.cachePatch("TTETR")
	puyo[12][1] = v.cachePatch("ITETR")
	puyo[12][2] = v.cachePatch("STETR")
	puyo[12][3] = v.cachePatch("ZTETR")
	puyo[12][4] = v.cachePatch("LTETR")
	puyo[12][5] = v.cachePatch("JTETR")
	puyo[12][6] = v.cachePatch("OTETR")
	return puyo
end

// Carbuncle!
local function doCarbuncle(v, player, camera)
	if not(players[player.host].gamestate == 0)
		return
	end

	if(v.carbuncle == nil)
		v.carbuncle = {}
		local cnum = 0
		while(cnum < 48)
			v.carbuncle[cnum] = v.cachePatch("CARBY"+(cnum+1))
			cnum = $1 + 1
		end
		v.fakebuncle = {}
		cnum = 0
		while(cnum < 18)
			v.fakebuncle[cnum] = v.cachePatch("FBNCL"+(cnum+1))
			cnum = $1 + 1
		end
	end
	if(v.sleeptimer == nil)
		v.sleeptimer = 0
	end
	local yoff = 0
	if(players[player.host].numplayers > 2)
		yoff = -30
	end
	v.sleeptimer = $1 + 1
	if not(paused or (menuactive and not netgame))
		or(puyodebug)
		or(players[player.host].carbuncle > 1)
		or(players[player.host].starttime)
		local flip = 0
		if(carbyanimations[players[player.host].carbyanim].canflip)
			and(players[player.host].carbyflip)
			flip = V_FLIP
		end
		if not(players[player.host].carbuncle == 2)
			v.draw(132+players[player.host].carbyx, 188+yoff+players[player.host].carbyy, v.carbuncle[carbyframes[carbyanimations[players[player.host].carbyanim].frames[players[player.host].carbyframe]].frame], flip)
		else
			local frame = carbyframes[carbyanimations[players[player.host].carbyanim].frames[players[player.host].carbyframe]].frame
			v.draw(132+players[player.host].carbyx, 188+yoff+players[player.host].carbyy, v.fakebuncle[frame], flip)
		end
	else
		v.draw(132+players[player.host].carbyx, 188+yoff, v.carbuncle[33+((v.sleeptimer/14)%2)], flip)
	end
end

local function DrawMenuBG(v, patch)
	local xoff = leveltime%8
	local yoff = (leveltime/2)%8
	v.draw(xoff+8+30, yoff+30, patch)
	v.draw(xoff-312+8+30, yoff-200+30, patch)
	v.draw(xoff-312+8+30, yoff+30, patch)
	v.draw(xoff+8+30, yoff-200+30, patch)
end

local function DrawFeverMeter(v, x, y, num, flip, small)
	local flags = 0
	if(flip)
		flags = $1|V_FLIP
	end
	local colormap = v.getColormap(-1, SKINCOLOR_GREEN)
	if(num == 8)
		colormap = v.getColormap(-1, (leveltime%(SKINCOLOR_ROSY-1))+1)	// Garbage, but easy fix...
	end
	if(small)
		v.drawScaled(x*FRACUNIT, y*FRACUNIT, FRACUNIT/2, v.fevermeter[num], flags, colormap)
	else
		v.draw(x, y, v.fevermeter[num], flags, colormap)
	end
end

local function DrawCutin(v, player, board, x, y)
	if(chardata[player.characters[board]].cutins == nil)
		or(chardata[player.characters[board]].cutins[player.boards[board].cutin] == nil)
		return
	end
	if(player.boards[board].cutintime)
		local flags = 0
		local trans = 10 - player.boards[board].cutintime
		if(trans < 0)
			trans = 0
		elseif(trans > 9)
			trans = 9
		end
		if((cutintime - player.boards[board].cutintime)+1 <= 9)
			trans = 10-((cutintime - player.boards[board].cutintime)+1)
			if(trans < 0)
				trans = 0
			elseif(trans > 9)
				trans = 9
			end
		end
		flags = $1|(trans*V_10TRANS)
		if(board & 1)
			flags = $1|V_FLIP
		end
		cutins[chardata[player.characters[board]].cutins[player.boards[board].cutin]](v, (x+1+(boardwidth*8))*FRACUNIT, (y+1+((boardheight-bufferrows)*16))*FRACUNIT, FRACUNIT, flags, player.boards[board].cutintime)
	end
end

// Drawing
hud.add(function(v, playerto, camera)
	local player
	if(mapheaderinfo[gamemap].arlepuyopoptsuu and (playerto.gamestate == nil or playerto.gamestate == -1))	// Too many players/splitscreen singleplayer
		if(players[0] and players[0].valid)	// False if dedicated server
			player = players[0]
		else
			player = players[1]
		end
	else
		player = playerto
	end
	if(player == nil)
		return
	end
	if(player.gamestate and player.gamestate < 0)
		or not(player.boards)	// need to be able to puyo first!
		return
	end
	if(splitscreen)
		and(#playerto == 0)
		return		// Only draw once!
	end
	if not(rpgblast)
		v.drawFill(0, 0, nil, nil, 21)		// Clear the screen!
	end
	// Puyo
	if(v.puyoskins == nil)
		v.puyoskins = {}
		v.cantplacex = v.cachePatch("XSPACE")
		// Puyo that have ascended to the stars
		v.dead = {}
		v.dead[0] = {}
		v.dead[0][0] =  v.cachePatch("DEAD3_R")
		v.dead[0][1] =  v.cachePatch("DEAD3_G")
		v.dead[0][2] =  v.cachePatch("DEAD3_B")
		v.dead[0][3] =  v.cachePatch("DEAD3_Y")
		v.dead[0][4] =  v.cachePatch("DEAD3_P")
		v.dead[1] = {}
		v.dead[1][0] =  v.cachePatch("DEAD2_R")
		v.dead[1][1] =  v.cachePatch("DEAD2_G")
		v.dead[1][2] =  v.cachePatch("DEAD2_B")
		v.dead[1][3] =  v.cachePatch("DEAD2_Y")
		v.dead[1][4] =  v.cachePatch("DEAD2_P")
		v.dead[2] = {}
		v.dead[2][0] =  v.cachePatch("DEAD1_R")
		v.dead[2][1] =  v.cachePatch("DEAD1_G")
		v.dead[2][2] =  v.cachePatch("DEAD1_B")
		v.dead[2][3] =  v.cachePatch("DEAD1_Y")
		v.dead[2][4] =  v.cachePatch("DEAD1_P")
		v.fourplayer =  v.cachePatch("BGFOURP")
		v.rpgblast = v.cachePatch("BGRPG")
		v.backgrounds = {}
		v.menubg = v.cachePatch("MENUBG1")
		v.rules = {}
		v.rules[0] = v.cachePatch("RULEPUYO")
		v.rules[1] = v.cachePatch("RULETSUU")
		v.rules[2] = v.cachePatch("RULEFEVR")
		v.rules[3] = v.cachePatch("RULEFEVR")
		v.fevermeter = {}
		local mnum = 0
		while(mnum < 8)
			v.fevermeter[mnum] = v.cachePatch("FVRMETR"+mnum)
			mnum = $1 + 1
		end
		v.fevermeter[8] = v.cachePatch("FVRMETRF")
		v.brickwall1 = v.cachePatch("BRICKWA1")
		v.brickwall2 = v.cachePatch("BRICKWA2")
		v.continuearle = v.cachePatch("ARLECONT")
		v.gameover = v.cachePatch("GAMEOVER")
	end
	local snum = 0
	while(snum < numskins)
		if(v.puyoskins[snum] == nil)
			v.puyoskins[snum] = cachePuyo(v, skindata[snum].prefix)	// Sun
		end
		snum = $1 + 1
	end
	local bnum = 0
	while(bnum < numbackgrounds)
		if(v.backgrounds[bnum] == nil)
			v.backgrounds[bnum] = {}
			v.backgrounds[bnum][0] = v.cachePatch("BG"+backgrounds[bnum])
			v.backgrounds[bnum][1] = v.cachePatch("BG"+backgrounds[bnum]+"A")
			v.backgrounds[bnum][2] = v.cachePatch("BG"+backgrounds[bnum]+"B")
		end
		bnum = $1 + 1
	end
	// Characters
	if(v.characters == nil)
		v.characters = {}
	end
	local cnum = 0
	while(cnum < numchars)
		if(v.characters[cnum] == nil)
			v.characters[cnum] = {}
			v.characters[cnum].background = v.cachePatch(chardata[cnum].background)
			if(chardata[cnum].backgroundf)
				v.characters[cnum].backgroundf = v.cachePatch(chardata[cnum].backgroundf)
			end
			v.characters[cnum].fevericon = v.cachePatch(chardata[cnum].fevericon)
			v.characters[cnum].cssicon = v.cachePatch(chardata[cnum].cssicon)
			v.characters[cnum].cssfull = v.cachePatch(chardata[cnum].cssfull)
			if(chardata[cnum].cssfullf)
				v.characters[cnum].cssfullf = v.cachePatch(chardata[cnum].cssfullf)
			end
		end
		cnum = $1 + 1
	end
	if(v.stagecharacters == nil)
		v.stagecharacters = {}
		v.stagecharacters[0] = v.cachePatch("DRACOSTG")
		v.stagecharacters[1] = v.cachePatch("SUKETSTG")
		v.stagecharacters[2] = v.cachePatch("SHEZOSTG")
		v.stagecharacters[3] = v.cachePatch("RULUESTG")
		v.stagecharacters[4] = v.cachePatch("SATANSTG")
	end

	if(players[player.host].gamestate > 0)
		DrawMenuBG(v, v.menubg)
	end

	if(players[player.host].gamestate == 0)	// In-game
		if not(rpgblast)
			v.draw(0, 0, v.backgrounds[player.background][2])
		end
		if(players[player.host].numplayers < 3)
			local boardyoff = 0
			local grav = players[player.host].boards[0].lostyoff-1
			if(grav < 0)
				grav = 0
			end
			boardyoff = grav*grav
			if(boardyoff > 320*2)
				boardyoff = 320*2
			end
			drawBoard(v, players[player.host], 0, 15, 3, boardyoff/2, player.puyoskin)
			if(players[player.host].numplayers > 1)
				boardyoff = 0
				grav = players[player.host].boards[1].lostyoff-1
				if(grav < 0)
					grav = 0
				end
				boardyoff = grav*grav
				if(boardyoff > 320*2)
					boardyoff = 320*2
				end
				drawBoard(v, players[player.host], 1, 320-106-15+8, 3, boardyoff/2, player.puyoskin)
			end
			if(rpgblast)
				v.draw(0, 0, v.rpgblast)
			else
				v.draw(0, 0, v.backgrounds[player.background][0])
				if not(player.matchended)
					v.draw(0, 0, v.backgrounds[player.background][1])
				end
			end
			drawGarbage(v, players[player.host], 0, 15, 3, player.puyoskin)
			drawScore(v, players[player.host], 0, 200, 196-8)//113, 200-8)
			if(players[player.host].numplayers > 1)
				drawGarbage(v, players[player.host], 1, 320-106-15+8, 3, player.puyoskin)
				drawScore(v, players[player.host], 1, 184, 172-8)//305, 200-8)
			end
			if(players[player.host].numplayers > 1)
				and not(player.stagenum)
				local p1map = V_YELLOWMAP
				local p2map = V_YELLOWMAP
				if(leveltime & 1)
					if(players[player.host].wins[0] >= 2)
						p1map = 0
					end
					if(players[player.host].wins[1] >= 2)
						p2map = 0
					end
				end
				v.drawString(126, 111-8, "P1 Wins: "+players[player.host].wins[0], p1map)
				v.drawString(126, 111+14-8, "P2 Wins: "+players[player.host].wins[1], p2map)
				v.drawString(128, 111+34, "Target: "+"2")
			end
			// Draw fever stuff!
			if(players[player.host].boards[0].fever)
				v.drawString(136, 86, "Time", V_YELLOWMAP, "center")
				v.drawString(136, 86+8, players[player.host].boards[0].fevertime/FRACUNIT, V_YELLOWMAP, "center")
				local num = players[player.host].boards[0].fevermeter
				if(players[player.host].boards[0].fevermode)
					num = 8
				end
				DrawFeverMeter(v, 1, 20, num, false, false)
			end
			if(players[player.host].numplayers > 1)
				if(players[player.host].boards[1].fever)
					v.drawString(184, 86, "Time", V_YELLOWMAP, "center")
					v.drawString(184, 86+8, players[player.host].boards[1].fevertime/FRACUNIT, V_YELLOWMAP, "center")
					local num = players[player.host].boards[1].fevermeter
					if(players[player.host].boards[1].fevermode)
						num = 8
					end
					DrawFeverMeter(v, 320-1, 20, num, true, false)
				end
			end
			// Cut-ins
			DrawCutin(v, players[player.host], 0, 15, 3)
			drawChainText(v, players[player.host], 0, 15, 3)
			if(players[player.host].numplayers > 1)
				DrawCutin(v, players[player.host], 1, 320-106-15+8, 3)
				drawChainText(v, players[player.host], 1, 320-106-15+8, 3)	// I'm just now noticing the inconsistant capitalization. Pain.
			end
		else
			v.draw(0, 0, v.backgrounds[0][2])
			drawBoard(v, players[player.host], 0, 73, 1, 0, player.puyoskin)
			if(players[player.host].numplayers > 1)
				drawBoard(v, players[player.host], 1, 195, 1, 0, player.puyoskin)
			end
			if(players[player.host].numplayers > 2)
				drawBoard(v, players[player.host], 2, 14, 101, 0, player.puyoskin)
			end
			if(players[player.host].numplayers > 3)
				drawBoard(v, players[player.host], 3, 256, 101, 0, player.puyoskin)
			end
			v.draw(0, 0, v.fourplayer)

			drawScore(v, players[player.host], 0, 194, 117+8)
			drawGarbage(v, players[player.host], 0, 73, 4, player.puyoskin)
			if(players[player.host].numplayers > 1)
				drawScore(v, players[player.host], 1, 188, 101)
				drawGarbage(v, players[player.host], 1, 195, 4, player.puyoskin)
			end
			if(players[player.host].numplayers > 2)
				drawScore(v, players[player.host], 2, 194, 183+8)
				drawGarbage(v, players[player.host], 2, 14, 104, player.puyoskin)
			end
			if(players[player.host].numplayers > 3)
				drawScore(v, players[player.host], 3, 188, 167)
				drawGarbage(v, players[player.host], 3, 256, 104, player.puyoskin)
			end

			if not(player.stagenum)
				local p1map = V_YELLOWMAP
				local p2map = V_YELLOWMAP
				local p3map = V_YELLOWMAP
				local p4map = V_YELLOWMAP
				if(leveltime & 1)
					if(players[player.host].wins[0] >= 2)
						p1map = 0
					end
					if(players[player.host].wins[1] >= 2)
						p2map = 0
					end
					if(players[player.host].wins[2] >= 2)
						p3map = 0
					end
					if(players[player.host].wins[3] >= 2)
						p4map = 0
					end
				end
				v.drawString(73, 100-1, "P1 Wins: "+players[player.host].wins[0], p1map, "thin")
				v.drawString(195, 100-1, "P2 Wins: "+players[player.host].wins[1], p2map, "thin")
				v.drawString(14, 100-8, "P3 Wins: "+players[player.host].wins[2], p3map, "thin")
				if(players[player.host].numplayers > 3)
					v.drawString(256, 100-8, "P4 Wins: "+players[player.host].wins[3], p4map, "thin")
				end
				v.drawString(128, 133, "Target: "+"2")
			end

			// Draw fever stuff!
			if(players[player.host].boards[0].fever)
				v.drawString(140, 80, "Time", V_YELLOWMAP, "center")
				v.drawString(140, 80+8, players[player.host].boards[0].fevertime/FRACUNIT, V_YELLOWMAP, "center")
				local num = players[player.host].boards[0].fevermeter
				if(players[player.host].boards[0].fevermode)
					num = 8
				end
				DrawFeverMeter(v, 65, 20, num, false, true)
			end
			if(players[player.host].numplayers > 1)
				if(players[player.host].boards[1].fever)
					v.drawString(178, 80, "Time", V_YELLOWMAP, "center")
					v.drawString(178, 80+8, players[player.host].boards[1].fevertime/FRACUNIT, V_YELLOWMAP, "center")
					local num = players[player.host].boards[1].fevermeter
					if(players[player.host].boards[1].fevermode)
						num = 8
					end
					DrawFeverMeter(v, 320-66, 20, num, true, true)
				end
			end
			if(players[player.host].numplayers > 2)
				if(players[player.host].boards[2].fever)
					v.drawString(81, 110, "Time", V_YELLOWMAP, "center")
					v.drawString(81, 110+8, players[player.host].boards[2].fevertime/FRACUNIT, V_YELLOWMAP, "center")
					local num = players[player.host].boards[2].fevermeter
					if(players[player.host].boards[2].fevermode)
						num = 8
					end
					DrawFeverMeter(v, 6, 120, num, false, true)
				end
			end
			if(players[player.host].numplayers > 3)
				if(players[player.host].boards[3].fever)
					v.drawString(239, 110, "Time", V_YELLOWMAP, "center")
					v.drawString(239, 110+8, players[player.host].boards[3].fevertime/FRACUNIT, V_YELLOWMAP, "center")
					local num = players[player.host].boards[3].fevermeter
					if(players[player.host].boards[3].fevermode)
						num = 8
					end
					DrawFeverMeter(v, 320-7, 120, num, true, true)
				end
			end

			DrawCutin(v, players[player.host], 0, 73, 1)
			if(players[player.host].numplayers > 1)
				DrawCutin(v, players[player.host], 1, 195, 1)
			end
			if(players[player.host].numplayers > 2)
				DrawCutin(v, players[player.host], 2, 14, 101)
			end
			if(players[player.host].numplayers > 3)
				DrawCutin(v, players[player.host], 3, 256, 101)
			end
		end
	elseif(players[player.host].gamestate == 1)
	//	v.drawString(0, 0, "This is a good main menu.", V_BLUEMAP)
		v.drawString(4, 4, "Main menu", V_BLUEMAP)
		local yoff = 20
		local onum = 0
		while/*(onum < 3 and (#player == #server or (admin and admin.valid and #player == #admin)))
			or*/(onum < 2)
			local flags = 0
			if(player.menuselection == onum)
				flags = V_YELLOWMAP
			end
			if(onum == 0)
				if not(player.stagenum)
					v.drawString(8, yoff, "Multiplayer", flags)
				else
					v.drawString(8, yoff, "Singleplayer", flags)
				end
			elseif(onum == 1)
				v.drawString(8, yoff, "Options", flags)
			else
				v.drawString(8, yoff, "Quit", flags)
			end
			yoff = $1 + 17
			onum = $1 + 1
		end
	elseif(players[player.host].gamestate == 2)
	//	v.drawString(0, 0, "Look at this amazing lobby select menu!", V_BLUEMAP)
		v.drawString(4, 4, "Lobby select", V_BLUEMAP)

		local numhosts = 0
		local hosts = {}
		local numplayers = {}
		for player2 in players.iterate
			if(player2.host == #player2)
				and(player2.gamestate == 3)
				hosts[numhosts] = #player2
				numplayers[numhosts] = 0
				local pnum = 0
				while(pnum < 4)
					if not(player2.clients[pnum] == -1)
						numplayers[numhosts] = $1 + 1
					end
					pnum = $1 + 1
				end
				numhosts = $1 + 1
			end
		end

		local yoff = 20
		local snum = 0
		local ruleflags = {}
		ruleflags[0] = V_GREENMAP
		ruleflags[1] = V_YELLOWMAP
		ruleflags[2] = V_REDMAP
		ruleflags[3] = V_BLUEMAP
		while(snum < numhosts+1)
			local flags = 0
			if(player.menuselection == snum)
				flags = V_YELLOWMAP
			end
			if(snum == 0)
				v.drawString(8, yoff, "Create lobby", flags)
			else
				v.drawString(14, yoff+20, "Join "+players[hosts[snum-1]].name+"'s lobby", flags)
				v.drawString(180, yoff+20, "Rules: "+rulenames[players[hosts[snum-1]].rules], ruleflags[players[hosts[snum-1]].rules], "thin")
				v.drawString(210, yoff+28, numplayers[snum-1]+"/4")
				yoff = $1 + 8
			end
			yoff = $1 + 9
			snum = $1 + 1
		end
	elseif(players[player.host].gamestate == 3)
		if(player.host == #player)
			or(splitscreen)
			if(player.clients[1] == -1)
				and not(splitscreen)
				v.drawString(4, 4, "Waiting for players...", V_BLUEMAP)
			else
				v.drawString(4, 4, "Press jump to start the match", V_BLUEMAP)
			end
		else
			v.drawString(4, 4, "Waiting for host to start match...", V_BLUEMAP)
		end
		local yoff = 16
		local pnum = 0
		while(pnum < 4)
			and not(players[player.host].clients[pnum] == -1)
			v.drawString(8, yoff, "Player "+(pnum+1)+": "+players[players[player.host].clients[pnum]].name)
			// ------------------------------------------
			// EXTRA LINES ADDED FOR CHARACTER SELECT
			v.drawString(185, yoff, "<"+chardata[players[player.host].characters[pnum]].name+">", V_YELLOWMAP|V_ALLOWLOWERCASE)
			// ------------------------------------------
			yoff = $1 + 17
			pnum = $1 + 1
		end
	elseif(players[player.host].gamestate == 5)
		v.drawString(4, 4, "Options", V_BLUEMAP)
		local yoff = 24
		local onum = 0
		local optionsnames = {}
		optionsnames[0] = "Music selection:\n     "+musicoptions[player.musicoption].name
		optionsnames[1] = "Fever music selection:\n     "+fevermusicoptions[player.fevermusicoption].name
		optionsnames[2] = "Puyo skin: "+skindata[player.puyoskin].name
		optionsnames[3] = "Background: "+(player.background+1)
		if(player.puyoenglish)
			optionsnames[4] = "Voice: En"
		else
			optionsnames[4] = "Voice: Jp"
		end
		local puyoanimtime = (leveltime/4)%TICRATE
		local puyoframe = 0
		if(puyoanimtime > TICRATE*2/3)
			puyoframe = 16+(puyoanimtime & 1)
			if((leveltime/2) & 1)
				puyoframe = 0
			end
		end
		while(onum < 5)
			local flags = 0
			if(player.menuselection == onum)
				flags = V_YELLOWMAP
			end
			v.drawString(8, yoff, optionsnames[onum], flags)
			if(onum == 2)
				v.drawScaled(200*FRACUNIT, (yoff-6)*FRACUNIT, skindata[player.puyoskin].scale, v.puyoskins[player.puyoskin][1][puyoframe])
			end
			yoff = $1 + 14+16
			onum = $1 + 1
		end

		v.drawScaled(270*FRACUNIT/2, 194*FRACUNIT/2, FRACUNIT/2, v.backgrounds[player.background][2])
		v.drawScaled(270*FRACUNIT/2, 194*FRACUNIT/2, FRACUNIT/2, v.backgrounds[player.background][0])
		v.drawScaled(270*FRACUNIT/2, 194*FRACUNIT/2, FRACUNIT/2, v.backgrounds[player.background][1])
	elseif(players[player.host].gamestate == 6)
		v.drawFill(nil, nil, nil, nil, 132)
		v.draw(121, 69, v.stagecharacters[players[player.host].stagenum-1])
		v.draw(2, 0, v.brickwall1)
		v.draw(0, 0, v.brickwall2)
		local flags = V_YELLOWMAP
		if(player.leveltime >= TICRATE*3/2)
			and(player.leveltime/2 & 1)
			flags = 0
		end
		v.drawString(160, 20, "STAGE "+players[player.host].stagenum, flags, "center")

	//	if(players[player.host].stagenum == 1)
			v.drawString(8, 180, "Press tossflag to change VO!", V_50TRANS, "thin")
			if(player.puyoenglish)
				v.drawString(30, 188, "English", V_YELLOWMAP|V_50TRANS, "thin")
			else
				v.drawString(30, 188, "Japanese", V_YELLOWMAP|V_50TRANS, "thin")
			end
	//	end
	elseif(players[player.host].gamestate == 8)
		v.drawString(4, 4, "Rule select", V_BLUEMAP)
		local sel = player.menuselection
		local yoff = 20
		local rnum = 0
		while(rnum < 4)
			local flags = 0
			if(sel == rnum)
				flags = V_YELLOWMAP
			end
			v.drawString(8, yoff, rulenames[rnum], flags)
			yoff = $1 + 17
			rnum = $1 + 1
		end

		// Draw the rule image!
		v.draw(180, 20, v.rules[sel])
		v.drawString(4, 144, ruledescriptions[sel])
	elseif(players[player.host].gamestate == 9)
		v.drawString(0, 0, "Custom rules", V_BLUEMAP)
		local yoff = 16
		local rnum = 0
		while(rnum < 6)
			local flags = 0
			if(player.menuselection == rnum)
				flags = V_YELLOWMAP
			end
			local rulename = rulepropnames[rnum]
			if(rnum == 0)
				if(player.customrules.dropsets)
					rulename = $1 + ": Yes"
				else
					rulename = $1 + ": No"
				end
			elseif(rnum == 1)
				rulename = $1 + ": " + games[player.customrules.garbagerules]
			elseif(rnum == 2)
				rulename = $1 + ": " + games[player.customrules.scorerules]
			elseif(rnum == 3)
				rulename = $1 + ": " + games[player.customrules.allclearrules]
			elseif(rnum == 4)
				rulename = $1 + ": " + games[player.customrules.voicepattern]
			elseif(rnum == 5)
				if(player.customrules.fever)
					rulename = $1 + ": Yes"
				else
					rulename = $1 + ": No"
				end
			end

			v.drawString(8, yoff, rulename, flags)
			yoff = $1 + 9
			rnum = $1 + 1
		end
	elseif(players[player.host].gamestate == 10)
		v.drawFill(nil, nil, nil, nil, 31)
		v.draw(160, 130, v.continuearle)
		local time = player.leveltime/CONTINUERATE
		if(time > 10)
			time = 10
		end
		v.drawString(160, 180, "CONTINUE", V_YELLOWMAP, "center")
		if (player.lifedebt != nil) -- sal
			v.drawString(160, 190, "LIVES: "+player.lifedebt, V_YELLOWMAP, "center")
		else
			v.drawString(160, 190, "LIVES: "+player.lives, V_YELLOWMAP, "center")
		end

		v.drawScaled((160-48)*FRACUNIT, (player.continuepuyoy-48)*FRACUNIT, FRACUNIT*3, v.puyoskins[1][11][1])
		if not(player.didcontinue)
			v.drawString(160, 20, time, 0, "center")
		end
		if(player.didcontinue < 0)
			//v.drawString(160, 20, time, 0, "center")
		end
	elseif(players[player.host].gamestate == 11)
		v.fadeScreen(31, 10)
	//	v.draw(0, 0, v.dumbblack)
		v.draw(160, 20, v.gameover)
	end
	if(skindata[player.puyoskin].hascarbuncle)
		doCarbuncle(v, player, camera)
	end
	if(players[player.host].fadetime)
		local trans = 10-(abs(players[player.host].fadetime)*10/TICRATE)
		if not(player.lives)
			and(player.gamestate == 10)
			and not(player.didcontinue)
			trans = 0
		end
		if(trans < 0)
			trans = 0
		end
		if not(trans > 9)
		//	trans = $1 * V_10TRANS
			v.fadeScreen(31, 10-trans)
		//	v.draw(0, 0, v.dumbblack, trans)
		end
	end
	if(netgame)
		and not(#player == #playerto)
		v.drawString(4, 188, "Viewing "+player.name+".")
	end
	// Black bars to keep the aspect ratio the same in wider and taller resolutions
	v.drawFill(-100, -100, 100, 400, 31)
	v.drawFill(320, -100, 100, 400, 31)

	v.drawFill(0, -100, 320, 100, 31)
	v.drawFill(0, 200, 320, 100, 31)
end, "game")
