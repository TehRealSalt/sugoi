-- The Map Builder by LJ Sonic (KIMOKAWAIII version)
-- (the todo list is irrelevant now, because this is discontinued)
-- NOTE TO SELF: DO NOT ADD MORE LOCALS OR THE SCRIPT WILL NOT LOAD

// Todo (important):
// Fix chasecam off screwing up controls
// Handle saves in a (really) better way
// Don't reset when resizing map
// Fix clientside bug where player can't move

// Todo:
// Update the NetVars hook for enemies
// Use custom timer instead of leveltime?
// Improve object move handling (higher max speed, better collision boxes, ...)
// Remove objects when builders build on them?
// Prevent players from spawning in a solid block
// Fix spilled ring collision box
// Improve help menu?
// Improve layer system?
// Allow layer 2 to be displayed in front of layer 1
// Improve springs (animation, better collision box, ...)
// Invincibility sparkles
// Use less locals
// Change music for playing players when changed?
// Fix/Improve layer erasing?
// Improve sound handling
// More tips in menus
// Delay before allowing player respawn? (1 second? Or maybe not at all...)
// Improve handling of map changes
// Handle AFK players? (host.wad?)
// Check for desynch?

// Todo (fixes):
// Check case where 2 players leave at the same tic
// Don't let border/tile collisions prevent object collisions
// Fix player leaving potentially skipping next player's turn?
// Check enemy spawners when changing player size
// Fix enemies disappearing (fixed?)
// Fix players walking when moving against walls
// Fix unspinning under spikes not happening
// Fix objects disappearing on borders
// Fix spindash when hitting spring
// Fix braking sound happening sometimes
// Check both Sonic and Tails for Tails pickup
// WARNING: ...\Maps-zip.wad|LUA_CORE:3643: attempt to perform arithmetic on local 'tile' (a nil value)
// Fix death animation and direction?
// Fix player input?

// Todo (features):
// Add more monitors
// Ring toss
// Handle conveyor belts
// Handle end signs correctly
// Warps?
// Brake?
// Handle water/lava/goop? (if possible...)
// 45 degrees slopes and/or stairs? (probably never lol)
// Enemy wall?
// Add spring falling animation?
// Server-protected areas?
// Teetering?
// Ladders? (Alyssa)
// Flowerpot? (forgot who wanted this lel)

// Todo (optimisations):
// Disable HUD for joiners
// Improve object/blockmap hole handling
// Compress objects in gamestate?
// Fix tile info compression
// Variables for screen distance
// Cache object sprites?
// Add tile type optimisation tables?
// Vectorize object properties?
// Split moveObjectXXX functions?
// Use blockmap to draw objects? (may cause drawing order problems)

// Layer 1		Layer 2
// Player		Background
// Player		Foreground

// Player		Player
// Background	Background
// Foreground	Background
// Foreground	Foreground


modmaps.mapversion = "0.3"

local FU = FRACUNIT

//local MAP = mapheaderinfo.kawaiii_mapbuilder // kawaiii

local BLOCK_SIZE = 8 * FU
local BLOCKMAP_SIZE = 8 * BLOCK_SIZE

local XOFFSET = 0
local YOFFSET = 0
local SCREEN_WIDTH = 320 * FU
local SCREEN_HEIGHT = 200 * FU

local GRAVITY = FU / 4

local PLAYER_WIDTH = 6 * FU
local PLAYER_HEIGHT = 10 * FU
local PLAYER_SPIN_HEIGHT = 6 * FU
local PLAYER_JUMP = FU * 7 / 2

// !!!
local MAX_OBJECT_DIST = 40 * BLOCK_SIZE
local OBJECT_WIDTH = 8 * FU // !!!
local OBJECT_HEIGHT = 8 * FU // !!!


local tiletypenames = {
	"Decorative", // 1
	"Invalid", // 2
	"Invalid", // 3
	"Weak spring", // 4
	"Strong spring", // 5
	"Floor damages", // 6
	"Ceiling damages", // 7
	"Bouncing platform", // 8
	"Damages", // 9
	"Instant death", // 10
	"It's a ring, stop asking.", // 11
	"It's a pancake, of course.", // 12
	"Got ring", // 13
	"Got monitor", // 14
	"Left spring", // 15
	"Right spring", // 16
	"Steam", // 17
	"Star post", // 18
	"Weak left diagonal spring", // 19
	"Weak right diagonal spring", // 20
	"Strong left diagonal spring", // 21
	"Strong right diagonal spring", // 22
	"Ice", // 23
	"Ice platform", // 24
	"Enemy", // 25
	"End sign", // 26 // kawaiii
}


// !!!
local OBJ_PLAYER = 1
local OBJ_SPILLEDRING = 2
local OBJ_BLUECRAWLA = 3
local OBJ_REDCRAWLA = 4
local OBJ_ROBOFISH = 5
local OBJ_GREENSPRINGSHELL = 6
local OBJ_YELLOWSPRINGSHELL = 7
local OBJ_GOLDBUZZ = 8
local OBJ_REDBUZZ = 9
local OBJ_GREENSNAPPER = 10
local OBJ_SHARP = 11
local OBJ_THOK = 12


local objinfo = modmaps.objectproperties
local skininfo = modmaps.skininfo


// A compressed map tile is an integer stored on 4 bytes.
// The 12 lower bits are the layer 1 tile id.
// The 12 upper bits are the layer 2 tile id.
// If bit 12 (4096) is 1, the layer 2 tile is an overlay, otherwise it is a background.
// The 7 other bits are reserved for various use.
// Layer 1 can be interacted with while layer 2 is purely decorative.
local TILE1 = 4095 // 0x00000fff: Bitmask for layer 1. map[i] & TILE1 is layer 1 tile id.
local TILE2 = 20 // Bitshift for layer 2. map[i] >> TILE2 is layer 2 tile id.
local TILEINFO = 983040 // 0x000f0000: Bitmask for layer 1 extra info. Value meaning depends on the tile id
local OVERLAY = 4096 // 0x00001000: Bitmask for layer 2 extra info. 4096 means it's an overlay.


// Prototypes
//local endGame
//local loseGame


// Variables
local pp // List of "fake" players
local gameinitialised // kawaiii
local mapchanged = true
local spritesnotloaded = true
local themes = {}
local mapticker, maptickerspeed // For respawning rings and other shit
local objectticker // For despawning far away enemies
local compressedgamestate // For compressing the gamestate when someone joins
local renderscale = 2
local fakebuilder
local app // For integration with the Computers library

// Blockmap
local blockmap // For fast collision detection
local blockmaplen // Number of objects in each block
local blockmapw, blockmaph // Size in blocks

// Map
local map
local map1 // Shortcut for layer 1
local map2 // Shortcut for layer 2
local tileinfo // Shortcut for tile info

// Objects
local objtype // Type
local objx, objy // Position
local objw, objh // Size
local objdx, objdy // Speed
local objdir // Direction (1 = left, 2 = right)
local objanim // Animation
local objspr // Animation state
local objcolor // Color
local objspawn // Spawn location
local objblockmap // Is in blockmap
local objextra // Extra information

// Object properties
// Yeah I know it's empty

// Object rendering properties
local objinfoscale = {} // Drawing scale

// Options
local allowmusicpreview = true
local allowediting = true

// Tile properties
local tiletype = {}
local tiledefaulttype = {}
local tiletag = {}
local tiletheme = {}
local tilethemetile = {}
local tileground = {}
local tileextra = {}
local tileextra2 = {}

// Tile rendering properties
local tilevisible = {}
local tilevisiblebuilder = {}
local tileanim = {}
local tileanimspd = {}
local tileanimlen = {}
local tilescale = {}
local tilex = {}
local tiley = {}
local tileflags = {}

// Tile history variables
local tilehistory = {}
local tilehistoryposition = 1


// Parses tile properties
function modmaps.setTileProperties()
	themes = {}

	local i = 1
	local theme
	local themenum = 0
	for _, tile in ipairs(modmaps.tileproperties)
		if tile.theme
			// Check for split themes
			theme = nil
			for prevthemenum, prevtheme in ipairs(themes)
				if prevtheme.name == tile.theme
					themenum = prevthemenum
					theme = prevtheme
					break
				end
			end

			if not theme
				themenum = #themes + 1
				themes[themenum] = {name = tile.theme, icon = tile.icon}
				theme = themes[themenum]
			end
			continue
		end

		tiletype[i] = tile[1] > 3 and tile[1] or 1
		local t = tiletype[i]

		tiledefaulttype[i] = tile[1] - 1

		if tile.tag
			local tag = tile.tag
			local j = 1
			for _, tile in ipairs(modmaps.tileproperties)
				if tile.theme continue end

				if tile.id == tag
					tiletag[i] = j
					break
				end

				j = $ + 1
			end
		else
			tiletag[i] = 0
		end

		if tile.noedit
			tiletheme[i] = 0
			tilethemetile[i] = 0
		else
			theme[#theme + 1] = i
			tiletheme[i] = themenum
			tilethemetile[i] = #theme
		end

		tileground[i] = t == 7 or t == 23 or t == 24

		tileextra[i] = tile.enemy or tile.monitor or false
		tileextra2[i] = tile.flip or false

		i = $ + 1
	end

	spritesnotloaded = true
end

modmaps.setTileProperties()

for i, info in ipairs(modmaps.objectproperties)
	objinfoscale[i] = info.scale ~= nil and info.scale or FU / 5

	local anim = info.anim
	if anim and anim[1] and type(anim[1]) ~= "table"
		info.anim = {$}
	end
end


local function getKeys(p)
	local cmd = p.cmd

	local left, right = false, false
	if cmd.sidemove < 0
		left = true
	elseif cmd.sidemove > 0
		right = true
	end

	local up, down = false, false
	if cmd.forwardmove > 0 or cmd.buttons & BT_WEAPONPREV
		up = true
	elseif cmd.forwardmove < 0 or cmd.buttons & BT_WEAPONNEXT
		down = true
	end

	return left, right, up, down
end


// !!!
rawset(_G, "getMap", function()
	return map
end)

// !!!
rawset(_G, "getMapPlayers", function()
	return pp
end)

// !!!
function modmaps.getMap()
	return map
end


local function findTarget(o)
	local nearestdist = INT32_MAX
	local target

	for i = 1, #pp
		local p = pp[i]
		if p.builder or p.dead continue end

		local o2 = p.obj
		local dist = P_AproxDistance(objx[o2] - objx[o], objy[o2] - objy[o])
		if dist <= nearestdist
			nearestdist = dist
			target = o2
		end
	end

	return target
end


local function insertObjectInBlockmap(o)
	if not objblockmap[o] return end

	local x, y = objx[o] / BLOCKMAP_SIZE, objy[o] / BLOCKMAP_SIZE
	local block = blockmap[x + y * blockmapw + 1]

	//block[#block + 1] = o // Add object to the end of the block

	// Find a hole in the block
	for i = 1, #block
		local o2 = block[i]
		if not o2
			block[i] = o // Add object to the hole
			return
		end
	end
	block[#block + 1] = o // Add object to the end of the block
end

local function removeObjectFromBlockmap(o)
	if not objblockmap[o] return end

	local x, y = objx[o] / BLOCKMAP_SIZE, objy[o] / BLOCKMAP_SIZE
	local block = blockmap[x + y * blockmapw + 1]
	local blocklen = #block

	/*for i = 1, blocklen
		local o2 = block[i]
		if o == o2
			block[i] = block[blocklen]
			block[blocklen] = nil
			return
		end
	end*/

	for i = 1, blocklen
		local o2 = block[i]
		if o == o2
			if i == blocklen // Last object in the block
				block[i] = nil
			else // Object in middle of the block
				block[i] = false
			end
			return
		end
	end
end

local function createBlockmap()
	blockmap = {}
	blockmapw = (map.w * BLOCK_SIZE + BLOCKMAP_SIZE - 1) / BLOCKMAP_SIZE
	blockmaph = (map.h * BLOCK_SIZE + BLOCKMAP_SIZE - 1) / BLOCKMAP_SIZE

	local BLOCKMAP_SIZE = BLOCKMAP_SIZE
	local blockmap = blockmap
	local blockmapw = blockmapw
	local objx, objy = objx, objy

	for i = 1, blockmapw * blockmaph
		blockmap[i] = {}
	end

	for o = 1, #objtype
		if objtype[o] and objblockmap[o]
			local x, y = objx[o] / BLOCKMAP_SIZE, objy[o] / BLOCKMAP_SIZE
			local block = blockmap[x + y * blockmapw + 1]
			block[#block + 1] = o // Add object to the end of the block
		end
	end
end

local function spawnObject(t, x, y)
	// Find free object number
	local o
	for i = 1, #objtype
		if not objtype[i]
			o = i
			break
		end
	end
	if not o
		o = #objtype + 1
	end

	// Initialise object
	local info = objinfo[t]
	objtype[o] = t
	objx[o], objy[o] = x, y
	objw[o], objh[o] = info.w, info.h // !!!
	objdx[o], objdy[o] = 0, 0
	objdir[o] = 1
	if t ~= 1
		objanim[o] = 1
		objspr[o] = info.anim[objanim[o]].spd // !!!
	else
		objanim[o] = "stand"
		objspr[o] = false
	end
	objcolor[o] = nil
	objspawn[o] = false
	objblockmap[o] = t ~= OBJ_THOK // !!!
	objextra[o] = false

	insertObjectInBlockmap(o)

	return o
end

local function removeObject(o)
	if objtype[o] == OBJ_PLAYER
		local p = pp[objextra[o]]

		if p.carry // Free carried player
			pp[objextra[p.carry]].carried = nil
			p.carry = nil
		elseif p.carried // Free carrying player
			pp[objextra[p.carried]].carry = nil
			p.carried = nil
		end

		// Unlink chasers
		for o2 = 1, #objtype
			local t2 = objtype[o2]
			if (t2 == OBJ_GOLDBUZZ or t2 == OBJ_REDBUZZ) and objextra[o2] == o
				local target = findTarget(o2)
				if target
					objextra[o2] = target
				else
					removeObject(o2)
				end
			end
		end
	end

	removeObjectFromBlockmap(o)

	objtype[o] = false

	// Avoid holes in the table
	if o == #objtype
		while o ~= 0 and not objtype[o]
			objtype[o] = nil
			objx[o], objy[o] = nil, nil
			objw[o], objh[o] = nil, nil
			objdx[o], objdy[o] = nil, nil
			objdir[o] = nil
			objanim[o] = nil
			objspr[o] = nil
			objcolor[o] = nil
			objspawn[o] = nil
			objblockmap[o] = nil
			objextra[o] = nil

			o = $ - 1
		end
	end
end

local function checkSpawner(i, x, y)
	// Check if the enemy is still alive
	for o = 1, #objtype
		if objtype[o] and objspawn[o] == i return end
	end

	local t = tileextra[map1[i]]
	if t == "Blue Crawla"
		t = OBJ_BLUECRAWLA
	elseif t == "Red Crawla"
		t = OBJ_REDCRAWLA
	elseif t == "Gold Buzz"
		t = OBJ_GOLDBUZZ
	elseif t == "Red Buzz"
		t = OBJ_REDBUZZ
	elseif t == "Green Spring Shell"
		t = OBJ_GREENSPRINGSHELL
	elseif t == "Yellow Spring Shell"
		t = OBJ_YELLOWSPRINGSHELL
	elseif t == "Green Snapper"
		t = OBJ_GREENSNAPPER
	elseif t == "Sharp"
		t = OBJ_SHARP
	elseif t == "Robo Fish"
		t = OBJ_ROBOFISH
	else
		print("Unknown enemy spawn type "..tile.."!") // !!!
	end

	local o = spawnObject(t, (x - 1) * BLOCK_SIZE + BLOCK_SIZE / 2 - objinfo[t].w / 2, y * BLOCK_SIZE - objinfo[t].h)
	objdir[o] = tileextra2[map1[i]] and 2 or 1
	objspawn[o] = i

	if t == OBJ_GOLDBUZZ or t == OBJ_REDBUZZ
		local target = findTarget(o)
		if target
			objextra[o] = target
		else
			removeObject(o)
		end
	elseif t == OBJ_ROBOFISH
		objdy[o] = -5 * FU
	end
end

local function checkSpawnersInColumn(x, y1, y2)
	// Don't go off the limits
	if y1 < 1
		y1 = 1
	end
	if y2 > map.h
		y2 = map.h
	end

	local i = x + (y1 - 1) * map.w
	for y = y1, y2
		if tiletype[map1[i]] == 25 // Enemy spawner
			checkSpawner(i, x, y)
		end
		i = $ + map.w
	end
end

local function checkSpawnersInLine(y, x1, x2)
	// Don't go off the limits
	if x1 < 1
		x1 = 1
	end
	if x2 > map.w
		x2 = map.w
	end

	local i = x1 + (y - 1) * map.w
	for x = x1, x2
		if tiletype[map1[i]] == 25 // Enemy spawner
			checkSpawner(i, x, y)
		end
		i = $ + 1
	end
end

local function checkSpawnersInArea(x1, y1, x2, y2)
	// Don't go off the limits
	if x1 < 1
		x1 = 1
	end
	if x2 > map.w
		x2 = map.w
	end
	if y1 < 1
		y1 = 1
	end
	if y2 > map.h
		y2 = map.h
	end

	local d = map.w - (x2 - x1 + 1)
	local i = x1 + (y1 - 1) * map.w
	for y = y1, y2
		for x = x1, x2
			if tiletype[map1[i]] == 25 // Enemy spawner
				checkSpawner(i, x, y)
			end
			i = $ + 1
		end
		i = $ + d
	end
end

local function playerOnGround(p)
	local o = p.obj

	if (objy[o] + objh[o]) % BLOCK_SIZE ~= 0 // Feet not exactly on tile bottom
	or objy[o] >= map.h * BLOCK_SIZE - objh[o] // Feet at bottom of the map
		return false
	end

	local y = (objy[o] + objh[o]) / BLOCK_SIZE * map.w + 1
	for i = objx[o] / BLOCK_SIZE + y, (objx[o] + PLAYER_WIDTH - 1) / BLOCK_SIZE + y
		local tile = map1[i]
		if tileground[tile]
			return true
		else
			local t = tiletype[tile]
			if t == 1 and tileinfo[i] >> 4 ~= 0
				return true
			elseif t == 6 and (p.flash or p.invincibility)
			or t == 12 and (p.jump or p.spin or p.spindash ~= nil) // !!!
				return true
			end
		end
	end
end

local function playerOnBlock(p, b)
	return false
	/*if not b
		for _, b in ipairs(tt.builders)
			if playerOnBlock(p, b)
				return true
			end
		end
		return false
	end

	for i = 1, #shapes[b.shape]
		local x, y = (getBlockX(b, i) - 1) * BLOCK_SIZE, (getBlockY(b, i) - 1) * BLOCK_SIZE

		if p.x < x + BLOCK_SIZE and p.x + PLAYER_WIDTH > x and p.y + p.h == y
			return true
		end
	end*/
end

local function playerOnIce(p)
	local o = p.obj

	if (objy[o] + objh[o]) % BLOCK_SIZE ~= 0
	or objy[o] >= map.h * BLOCK_SIZE - objh[o]
		return false
	end

	local y = (objy[o] + objh[o]) / BLOCK_SIZE * map.w + 1
	for i = objx[o] / BLOCK_SIZE + y, (objx[o] + PLAYER_WIDTH - 1) / BLOCK_SIZE + y
		local tile = tiletype[map1[i]]
		if tile == 23 or tile == 24 // !!!
			return true
		end
	end
end

/*local function playerClimbingBlock(p, b)
	if not p.climb
		return false
	elseif not b
		return p.climb
	end

	if p.dir == 1
		for i = 1, #shapes[b.shape]
			local x, y = (getBlockX(b, i) - 1) * BLOCK_SIZE, (getBlockY(b, i) - 1) * BLOCK_SIZE

			if p.x == x + BLOCK_SIZE and p.y + p.h > y and p.y < y + BLOCK_SIZE
				return true
			end
		end
	else
		for i = 1, #shapes[b.shape]
			local x, y = (getBlockX(b, i) - 1) * BLOCK_SIZE, (getBlockY(b, i) - 1) * BLOCK_SIZE

			if p.x + PLAYER_WIDTH == x and p.y + p.h > y and p.y < y + BLOCK_SIZE
				return true
			end
		end
	end

	return false
end*/

// ...
local function playerCantClimb(p)
	local o = p.obj

	local w = map.w
	local x = objdir[o] == 1 and (objx[o] - 1) / BLOCK_SIZE + 1 or (objx[o] + PLAYER_WIDTH) / BLOCK_SIZE + 1
	for i = x + objy[o] / BLOCK_SIZE * w, min(x + (objy[o] + objh[o] - 1) / BLOCK_SIZE * w, w * map.h), w
		local tile = tiletype[map1[i]]
		if tile == 1 and tileinfo[i] >> 4 == 1 // Solid
		or tile == 23 // Ice
			return false
		end
	end

	/*if p.dir == 1
		for _, b in ipairs(tt.builders)
			for i = 1, #shapes[b.shape]
				local x, y = (getBlockX(b, i) - 1) * BLOCK_SIZE, (getBlockY(b, i) - 1) * BLOCK_SIZE

				if p.x == x + BLOCK_SIZE and p.y + p.h > y and p.y < y + BLOCK_SIZE
					return false
				end
			end
		end
	else
		for _, b in ipairs(tt.builders)
			for i = 1, #shapes[b.shape]
				local x, y = (getBlockX(b, i) - 1) * BLOCK_SIZE, (getBlockY(b, i) - 1) * BLOCK_SIZE

				if p.x + PLAYER_WIDTH == x and p.y + p.h > y and p.y < y + BLOCK_SIZE
					return false
				end
			end
		end
	end*/

	return true
end

local function playerColliding(p)
	local o = p.obj

	if objx[o] < 0 or objx[o] + PLAYER_WIDTH > map.w * BLOCK_SIZE or objy[o] < 0
		return true
	end

	for x = objx[o] / BLOCK_SIZE + 1, (objx[o] + PLAYER_WIDTH - 1) / BLOCK_SIZE + 1
		for y = objy[o] / BLOCK_SIZE + 1, min((objy[o] + objh[o] - 1) / BLOCK_SIZE + 1, map.h)
			local i = x + (y - 1) * map.w
			local tile = tiletype[map1[i]]
			if tile == 1 and tileinfo[i] >> 4 == 1 // Solid
			or tile == 6 // Floor damages
			or tile == 7 // Ceiling damages
			or tile == 23 // Ice
				return true
			end
		end
	end

	/*for _, b in ipairs(tt.builders)
		for i = 1, #shapes[b.shape]
			local x, y = (getBlockX(b, i) - 1) * BLOCK_SIZE, (getBlockY(b, i) - 1) * BLOCK_SIZE

			if objx[o] < x + BLOCK_SIZE and objx[o] + PLAYER_WIDTH > x and objy[o] < y + BLOCK_SIZE and objy[o] + p.h > y
				return true
			end
		end
	end*/
end

local function objectsInArea(x1, y1, x2, y2)
	local objx, objy = objx, objy
	local objw, objh = objw, objh

	for o = 1, #objtype
		if objtype[o]
		and objx[o] + objw[o] > x1
		and objx[o] <= x2
		and objy[o] + objh[o] > y1
		and objy[o] <= y2
			return true
		end
	end
end

local function objectsAtPosition(x, y)
	return objectsInArea(
		(x - 1) * BLOCK_SIZE,
		(y - 1) * BLOCK_SIZE,
		x * BLOCK_SIZE - 1,
		y * BLOCK_SIZE - 1)
end

local function playersInArea(x1, y1, x2, y2)
	for i = 1, #pp
		local p = pp[i]
		if not (p.builder or p.dead)
			local o = p.obj
			if objx[o] + objw[o] > x1
			and objx[o] <= x2
			and objy[o] + objh[o] > y1
			and objy[o] <= y2
				return true
			end
		end
	end
end

local function playersAtPosition(x, y)
	return playersInArea(
		(x - 1) * BLOCK_SIZE,
		(y - 1) * BLOCK_SIZE,
		x * BLOCK_SIZE - 1,
		y * BLOCK_SIZE - 1)
end

local musicslottoname = {
	MAP01 = "GFZ1",
	MAP02 = "GFZ2",
	MAP03 = "VSBOSS",
	MAP04 = "THZ1",
	MAP05 = "THZ2",
	MAP06 = "GFZALT",
	MAP07 = "DSZ1",
	MAP08 = "DSZ2",
	MAP09 = "DSZ2",
	MAP10 = "CEZ1",
	MAP11 = "CEZ2",
	MAP12 = "VSBOSS",
	MAP13 = "ACZ1",
	MAP14 = "ACZ2",
	MAP16 = "RVZ1",
	MAP18 = "RVZALT",
	MAP19 = "DCZ",
	MAP21 = "MP_DOM",
	MAP22 = "ERZ1",
	MAP23 = "ERZ2",
	MAP24 = "BCZ1",
	MAP25 = "VSMETL",
	MAP26 = "VSBRAK",
	MAP27 = "ERZ1",
	MAP28 = "VSBRAK",
	MAP29 = "APZ1",
	MAP30 = "MARIO1",
	MAP31 = "MARIO2",
	MAP45 = "MP_GHZ",
	MAP50 = "OSPEC",
	MAP51 = "OSPEC2",
	MAP86 = "MP_FR2",
	MAP87 = "MP_DOM",
	MAP88 = "MP_GL2",
	MAP89 = "MP_GLZ",
	MAP90 = "MP_MED",
	MAP91 = "MP_AIR",
	MAP92 = "MP_SUN",
	MAP93 = "MP_WTR",
	MAP94 = "MP_0RI",
	MAP95 = "MP_DES",
	MAP96 = "MP_MIN",
	MAP97 = "ACZ2",
	MAP99 = "ATZ",
	MAPAZ = "VSALT",
	MAPB0 = "MP_COA",
	MAPB1 = "MP_RAI",
	MAPB2 = "MP_FOR",
	MAPB3 = "MP_FIR",
	MAPB4 = "MP_ICE",
	MAPB5 = "MP_WT2",
	MAPB6 = "AGZ",
	MAPB7 = "AGZALT",
	MAPB8 = "BHZ",
	MAPB9 = "MP_MRZ",
	MAPCS = "DISCO",
	MAPZZ = "OINTRO",
}

local function S_ChangeMusicOld(music, loop, p)
	if type(music) == "number"
		music = musicslottoname[G_BuildMapName(music)]
		if not music
			S_StopMusic(p)
			return
		end
	end

	S_ChangeMusic(music, loop, p)
end

local function changeMusic(n, p)
	S_StopMusic(p)
	if n ~= nil
		S_ChangeMusicOld(n, true, p)
	end

	/*if p
		S_StopMusic(p)
		S_ChangeMusicOld(n, true, p)
		return
	end

	for i, _ in ipairs(tt.builders)
		if not players[i] continue end

		S_StopMusic(players[i])
		S_ChangeMusicOld(n, true, players[i])
	end

	if not tt.players return end

	for i, _ in ipairs(tt.players)
		if not players[i] continue end

		S_StopMusic(players[i])
		S_ChangeMusicOld(n, true, players[i])
	end*/
end

local function startSound(n, o)
	if not o
		S_StartSound(nil, n)
		return
	end

	o = o.obj // !!!!

	local x, y = objx[o], objy[o]
	local d = 256 * FU

	local owner = displayplayer
	if not (owner and owner.maps and owner.maps.player) return end
	local p = pp[owner.maps.player]
	if not p return end

	local px, py
	if p.builder
		px, py = (p.x - 1) * BLOCK_SIZE, (p.y - 1) * BLOCK_SIZE
	elseif p.dead
		px, py = p.x, p.y
	else
		px, py = objx[p.obj], objy[p.obj]
	end

	if P_AproxDistance(px - x, py - y) < d
		S_StartSound(nil, n, owner)
	end

	/*for i = 1, #pp
		local p = pp[i]
		local owner = players[p.owner]
		if not owner continue end

		local px, py
		if p.builder
			px, py = (p.x - 1) * BLOCK_SIZE, (p.y - 1) * BLOCK_SIZE
		elseif p.dead
			px, py = p.x, p.y
		else
			px, py = objx[p.obj], objy[p.obj]
		end

		if P_AproxDistance(px - x, py - y) < d
			S_StartSound(nil, n, owner)
		end
	end*/
end

local function setObjectAnimation(o, anim)
	objanim[o], objspr[o] = anim, objinfo[objtype[o]].anim[anim].spd
end

// ...
local function setPlayerAnimation(p, anim)
	// !!!
	//p.anim, p.spr = anim, skininfo[p.skin].anim[anim].spd
	local o = p.obj
	objanim[o], objspr[o] = anim, skininfo[p.skin].anim[anim].spd

	if anim == "land"
		p.xdxd = true
	elseif p.xdxd
		--xdxd()
	end
end

// ...
local function loopPlayerAnimation(p)
	local a = skininfo[p.skin].anim[p.anim]

	if p.anim == "walk"
		p.spr = ($ + 4 * abs(p.dx) / FU - a.spd) % (a.spd * #a) + a.spd
	else
		p.spr = $ + 1
		if p.spr >= a.spd * (#a + 1)
			p.spr = a.spd
		end
	end
end

// ...
local function loopObjectAnimation(o)
	local objanim = objanim
	local objspr = objspr

	if objtype[o] ~= OBJ_PLAYER // !!!
		local a = objinfo[objtype[o]].anim[objanim[o]] // !!! // !!! BUG?

		objspr[o] = $ + 1
		if objspr[o] >= a.spd * (#a + 1)
			objspr[o] = a.spd
		end
	else
		// !!!!
		local p = pp[objextra[o]]
		local a = skininfo[p.skin].anim[objanim[o]]
		local spr = a[objspr[o] / a.spd]

		if objanim[o] == "walk"
			objspr[o] = ($ + 4 * abs(objdx[o]) / FU - a.spd) % (a.spd * a.frames) + a.spd
		else
			objspr[o] = $ + 1
			if objspr[o] >= a.spd * (a.frames + 1)
				objspr[o] = a.spd
			end
		end
	end
end

local function setPlayerSkin(p, skin)
	p.skin = skin
	if p.obj
		setPlayerAnimation(p, objanim[p.obj])
	end
end

local function setObjectHeight(o, h)
	// Keep feet at the same height
	removeObjectFromBlockmap(o)
	objy[o] = $ + objh[o] - h
	insertObjectInBlockmap(o)

	objh[o] = h
end

local function spinPlayer(p)
	local o = p.obj

	p.spin = true

	setObjectHeight(o, PLAYER_SPIN_HEIGHT)

	if p.anim ~= "roll"
		setPlayerAnimation(p, "roll")
	end
	startSound(sfx_spin, p)
end

local function unspinPlayer(p)
	local o = p.obj

	p.spindash = false

	setObjectHeight(o, PLAYER_HEIGHT)

	if playerColliding(p)
		setObjectHeight(o, PLAYER_SPIN_HEIGHT)
		if abs(objdx[o]) < FU / 2
			if objdx[o] < 0
				objdx[o] = $ - FU / 2
			elseif objdx[o] > 0
				objdx[o] = $ + FU / 2
			elseif objdir[o] == 1
				objdx[o] = $ - FU / 2
			else
				objdx[o] = $ + FU / 2
			end
		end
		return false
	end

	p.spin = false

	if objdx[o] == 0
		setPlayerAnimation(p, "stand")
	elseif abs(objdx[o]) < skininfo[p.skin].run
		setPlayerAnimation(p, "walk")
	else
		setPlayerAnimation(p, "run")
	end

	return true
end

local function jumpPlayer(p)
	if p.carried
		pp[objextra[p.carried]].carry = nil
		p.carried = nil
	end

	if p.spin
		if not unspinPlayer(p)
			return
		end
	elseif p.spindash ~= false and not unspinPlayer(p)
		return
	end

	local o = p.obj

	if p.thok
		p.thok = false
	end

	p.jump = true

	objdy[o] = -PLAYER_JUMP

	setObjectHeight(o, PLAYER_SPIN_HEIGHT)

	if skininfo[p.skin].bounce
		setPlayerAnimation(p, "spring")
	else
		setPlayerAnimation(p, "roll")
	end

	startSound(sfx_jump, p)
end

local function thokPlayer(p)
	local o = p.obj

	p.thok = true
	objdx[o] = objdir[o] == 1 and -skininfo[p.skin].thok or skininfo[p.skin].thok

	local thok = spawnObject(OBJ_THOK, objx[o], objy[o])
	objcolor[thok] = p.owner ~= nil and players[p.owner] and players[p.owner].skincolor or SKINCOLOR_BLUE
	objextra[thok] = 8 // Vanish after 8 tics

	startSound(sfx_thok, p)
end

local function flyPlayer(p)
	if p.spin and not unspinPlayer(p)
		return
	end

	p.fly = skininfo[p.skin].fly
	p.jump = false

	setPlayerAnimation(p, "fly")
end

local function glidePlayer(p)
	local o = p.obj

	if p.spin and not unspinPlayer(p)
		return
	end

	p.glide = true
	p.jump = false

	objdx[o] = objdir[o] == 1 and -2 * FU or 2 * FU

	setPlayerAnimation(p, "glide")
end

local function releasePlayerGlide(p)
	/*local o = p.obj

	setObjectHeight(o, PLAYER_HEIGHT)

	if playerColliding(p)
		setObjectHeight(o, PLAYER_SPIN_HEIGHT)
		return
	end*/

	p.glide = nil
	p.spin = true

	setPlayerAnimation(p, "roll")
end

local function releasePlayerClimb(p)
	local o = p.obj

	p.climb = nil
	p.jump = true

	setObjectHeight(o, PLAYER_HEIGHT)

	setPlayerAnimation(p, "roll")
end

local function startPlayerBounceMode(p)
	p.bouncemode = true

	setPlayerAnimation(p, "bouncemode")
end

local function releasePlayerBounceMode(p)
	p.bouncemode = nil
	p.bounce = nil
	p.bouncetime = 0
	p.bouncedx, p.bouncedy = nil, nil

	setPlayerAnimation(p, "fall")
end

// !!!
// Needs better handling of jump/spin cases
local function springPlayer(p, dx, dy, sfx)
	local o = p.obj

	if p.carry
		pp[objextra[p.carry]].carried = nil
		p.carry = nil
	elseif p.carried
		pp[objextra[p.carried]].carry = nil
		p.carried = nil
	end

	if p.spin
		if not unspinPlayer(p)
			return
		end
	elseif p.spindash ~= false and not unspinPlayer(p)
		return
	end

	if p.jump or p.fly ~= nil or p.glide or p.climb
		p.jump = false
		p.fly = nil
		p.glide = nil
		p.climb = nil
		p.bouncemode = nil
		p.bounce = nil

		setObjectHeight(o, PLAYER_HEIGHT)

		if playerColliding(p)
			setObjectHeight(o, PLAYER_SPIN_HEIGHT)
		end
	elseif p.spin
		unspinPlayer(p)
	end

	p.thok = nil

	if p.flash == 3 * TICRATE
		p.flash = $ - 1
	end

	p.spring = true
	if dx ~= nil
		objdx[o] = dx
		objdir[o] = dx < 0 and 1 or dx > 0 and 2 or $
	end
	objdy[o] = -dy
	setPlayerAnimation(p, "spring")
	startSound(sfx or sfx_spring, p)
end

local function landObject(o)
	local t = objtype[o]

	if t == OBJ_PLAYER
		local p = pp[objextra[o]]

		if (p.spin or p.spindash ~= false) and objdy[o] > GRAVITY
			unspinPlayer(p)
		elseif p.bouncemode
			if not p.bounce
				p.bounce = true
				p.bouncetime = 6

				p.bouncedx, p.bouncedy = objdx[o], objdy[o]
				objdx[o] = 0

				setPlayerAnimation(p, "bounce")
			end
		elseif p.jump or p.thok
			p.jump = false
			if p.thok
				p.thok = false
			end

			setObjectHeight(o, PLAYER_HEIGHT)

			if playerColliding(p)
				spinPlayer(p)
			else
				setPlayerAnimation(p, objdx[o] == 0 and "stand" or abs(objdx[o]) < skininfo[p.skin].run and "walk" or "run")
			end
		elseif p.fly ~= nil or p.glide
			p.fly = nil
			p.glide = nil

			setObjectHeight(o, PLAYER_HEIGHT)

			if playerColliding(p)
				spinPlayer(p)
			else
				setPlayerAnimation(p, objdx[o] == 0 and "stand" or abs(objdx[o]) < skininfo[p.skin].run and "walk" or "run")
			end
		elseif p.climb
			p.climb = nil

			setPlayerAnimation(p, "stand")
		// !!!
		elseif p.spring
			p.spring = nil
			setPlayerAnimation(p, objdx[o] == 0 and "stand" or abs(objdx[o]) < skininfo[p.skin].run and "walk" or "run")
		elseif p.carry
			pp[objextra[p.carry]].carried = nil
			p.carry = nil
			setPlayerAnimation(p, objdx[o] == 0 and "stand" or abs(objdx[o]) < skininfo[p.skin].run and "walk" or "run")
		elseif p.carried
			pp[objextra[p.carried]].carry = nil
			p.carried = nil
			setPlayerAnimation(p, objdx[o] == 0 and "stand" or abs(objdx[o]) < skininfo[p.skin].run and "walk" or "run")
		elseif p.flash == 3 * TICRATE
			p.flash = $ - 1
			setPlayerAnimation(p, objdx[o] == 0 and "stand" or abs(objdx[o]) < skininfo[p.skin].run and "walk" or "run")
		elseif objanim[o] == "carry"
			setPlayerAnimation(p, objdx[o] == 0 and "stand" or abs(objdx[o]) < skininfo[p.skin].run and "walk" or "run")
		end

		objdy[o] = 0
	elseif t == OBJ_SPILLEDRING
		objdy[o] = -$ * 7 / 8
		if objdx[o] < 0
			objdx[o] = min($ + FU / 8, 0)
		elseif objdx[o] > 0
			objdx[o] = max($ - FU / 8, 0)
		end
	else
		objdy[o] = 0
	end
end

local function hitObjectWall(o)
	local t = objtype[o]

	if t == OBJ_PLAYER
		local p = pp[objextra[o]]

		if p.glide
			p.glide = nil

			setObjectHeight(o, PLAYER_HEIGHT)

			if playerColliding(p)
				local y = objy[o]
				objy[o] = ($ / BLOCK_SIZE + 1) * BLOCK_SIZE
				if playerColliding(p)
					objy[o] = y + objh[o]
					objh[o] = PLAYER_SPIN_HEIGHT
					objy[o] = $ - objh[o]
					p.spin = true
					return
				end
			end

			p.climb = true
			objdy[o] = 0

			setPlayerAnimation(p, "climbstatic")
		end

		objdx[o] = 0
	elseif t == OBJ_SPILLEDRING
		objdx[o] = -$ * 7 / 8
	else
		objdx[o] = 0
		objdir[o] = $ == 1 and 2 or 1
	end
end

local function hitObjectCeiling(o)
	if objtype[o] ~= OBJ_SPILLEDRING
		objdy[o] = 0
	else
		objdy[o] = -$ * 7 / 8
		if objdx[o] < 0
			objdx[o] = min($ + FU / 8, 0)
		elseif objdx[o] > 0
			objdx[o] = max($ - FU / 8, 0)
		end
	end
end

// ...
local function killPlayer(p, cause)
	p.dead = true
	p.rings = 0
	//setPlayerAnimation(p, "die")
	p.x, p.y = objx[p.obj], objy[p.obj]
	p.dx, p.dy = 0, -3 * FU
	if cause == "drown"
		startSound(sfx_drown, p)
	elseif cause ~= "spikes"
		startSound(P_RandomRange(sfx_altdi1, sfx_altdi4), p)
	end

	removeObject(p.obj)
	p.obj = nil

	/*if gameover return end

	for _, p in ipairs(pp)
		if not p.dead return end
	end
	loseTetris()*/
end

local function damagePlayer(p, cause)
	local o = p.obj

	if cause == "spikes"
		startSound(sfx_spkdth, p)
	end

	if p.carry
		pp[objextra[p.carry]].carried = nil
		p.carry = nil
	elseif p.carried
		pp[objextra[p.carried]].carry = nil
		p.carried = nil
	end

	if p.shield
		p.shield = $ == "strongforce" and "weakforce" or nil
		if cause ~= "spikes"
			startSound(sfx_shldls, p)
		end
	else
		if p.rings == 0
			killPlayer(p, cause)
			return
		end

		// Spill rings
		local ringnum = min(p.rings, 32)
		local ringx = objx[o] + objw[o] / 2 - objinfo[OBJ_SPILLEDRING].w / 2
		local ringy = objy[o] + objh[o] / 2 - objinfo[OBJ_SPILLEDRING].h / 2
		if ringy + objinfo[OBJ_SPILLEDRING].h > objy[o] + objh[o]
			ringy = objy[o] + objh[o] - objinfo[OBJ_SPILLEDRING].h
		end
		for i = 1, ringnum
			local angle = (-FU / 2 + (i - 1) * (FU / ringnum)) * FU
			local speed = 3

			local o = spawnObject(OBJ_SPILLEDRING, ringx, ringy)
			objdx[o] = cos(angle) * speed
			objdy[o] = sin(angle) * speed
			objextra[o] = 8 * TICRATE
		end

		p.rings = 0

		startSound(P_RandomRange(sfx_altow1, sfx_altow4), p)
	end

	unspinPlayer(p)
	p.jump = false
	p.thok = nil
	p.fly = nil
	p.glide = nil
	p.bouncemode = nil
	p.climb = nil
	p.bounce = nil
	p.spring = nil

	p.flash = 3 * TICRATE
	objdx[o] = FU * ((objdx[o] < 0 or objdx[o] == 0 and objdir[o] == 1) and 3 or -3) / 2
	objdy[o] = -2 * FU

	setPlayerAnimation(p, "pain")
end

local function playerBreakMonitor(p, i)
	local o = p.obj

	// Effect
	local t = tileextra[map1[i]]
	if t == "Ring"
		p.rings = min($ + 10, 9999)
	elseif t == "Shoes"
		p.shoes = min((p.shoes or 0) + 20 * TICRATE, 65535)
		changeMusic("_SHOES", players[p.owner])
	elseif t == "Invincibility"
		p.invincibility = min((p.invincibility or 0) + 20 * TICRATE, 65535)
		changeMusic("_INV", players[p.owner])
	elseif t == "Pity Shield"
		p.shield = "pity"
		startSound(sfx_shield, p)
	elseif t == "Force Shield"
		p.shield = "strongforce"
		startSound(sfx_shield, p)
	elseif t == "Whirlwind Shield"
		p.shield = "wind"
		startSound(sfx_shield, p)
	elseif t == "Eggman"
		if not (p.flash or p.invincibility)
			damagePlayer(p)
		end
	end

	// Bounce
	if objtype[o] and objdy[o] > GRAVITY
		objdy[o] = -$
	end

	// Break
	map1[i] = tiletag[$]
	if objtype[o] // !!!!
		startSound(sfx_pop, p)
	end
end

/*local function prepareBlock(b)
	b.shape = b.nextshape
	b.sprite = b.nextsprite
	b.angle = P_RandomRange(1, 4)

	b.y = 2 - getBlockHeight(b)
	repeat
		b.y = $ - 1
		b.x = P_RandomRange(1, map.w - getBlockWidth(b) + 1)
	until not blockColliding(b)

	local n = 0
	for i = 1, #shapes
		if not tt.usedshapes[i] n = $ + 1 end
	end

	local shape = P_RandomRange(1, n)
	for i = 1, #shapes
		if not tt.usedshapes[i]
			shape = $ - 1
			if shape == 0
				b.nextshape = i
				tt.usedshapes[i] = true
				break
			end
		end
	end

	if n == 1
		for i = 1, #shapes
			tt.usedshapes[i] = false
		end
	end

	b.nextsprite = P_RandomRange(1, #tetristhemes[tt.theme].sprites)

	b.nextmove = tt.speed
end*/

local function centerCameraAroundPoint(p, x, y)
	p.scrollx = x - SCREEN_WIDTH / 2 / renderscale
	local limit = map.w * BLOCK_SIZE - SCREEN_WIDTH / renderscale
	if p.scrollx > limit
		p.scrollx = limit
	elseif p.scrollx < 0
		p.scrollx = 0
	end

	p.scrolly = y - SCREEN_HEIGHT / 2 / renderscale
	limit = map.h * BLOCK_SIZE - SCREEN_HEIGHT / renderscale
	if p.scrolly > limit
		p.scrolly = limit
	elseif p.scrolly < 0
		p.scrolly = 0
	end
end

local function moveBuilder(p, dx, dy)
	p.x = $ + dx
	if p.x < 1
		p.x = map.w
	end
	if p.x > map.w
		p.x = 1
	end

	p.y = $ + dy
	if p.y < 1
		p.y = map.h
	end
	if p.y > map.h
		p.y = 1
	end
end

local function handleFakeBuilder(noenemies)
	fakebuilder.input = $ + 1

	local input = modmaps.builderinputs[fakebuilder.map][fakebuilder.input]
	if input == 1
		moveBuilder(fakebuilder, -1, 0)
	elseif input == 2
		moveBuilder(fakebuilder, 1, 0)
	elseif input == 3
		moveBuilder(fakebuilder, 0, -1)
	elseif input == 4
		moveBuilder(fakebuilder, 0, 1)
	elseif input == 5
		fakebuilder.erase = false
	elseif input == 6
		fakebuilder.erase = true
	elseif input == 7
		fakebuilder.erase = nil
	elseif input == 8
		fakebuilder.layer = $ == 1 and 2 or 1
		fakebuilder.overlay = false
	elseif input == 9
		fakebuilder.overlay = not $
	elseif input == 10
		fakebuilder.tiletype = $ ~= 2 and $ + 1 or 0
	elseif input == 11
		local i = fakebuilder.x + (fakebuilder.y - 1) * map.w
		local tile = (fakebuilder.layer == 2 or fakebuilder.overlay) and map2[i] or map1[i]
		if tiletheme[tile] ~= 0
			fakebuilder.tile = tile
			if tiletype[tile] ~= 1
				fakebuilder.tiletype = 0
			elseif fakebuilder.layer == 2 or fakebuilder.overlay
				fakebuilder.tiletype = tiledefaulttype[tile]
			else
				fakebuilder.tiletype = tileinfo[i] >> 4
			end
		end
	elseif input == 12
		fakebuilder.speed = 2
	elseif input == 13
		fakebuilder.speed = 4
	elseif input == 14
		fakebuilder.speed = 6
	elseif input == 15
		fakebuilder.speed = 8
	elseif input == 16
		fakebuilder.speed = 1
	elseif input == 17
		fakebuilder.speed = -2
	elseif input == 18
		map.backgroundtype = 1
		map.background = 1
	elseif input == 19
		map.backgroundtype = 2
		map.background = 213
	elseif input == 20
		fakebuilder.speed = -4
	elseif input >= 1000 and input < 2000
		map.background = input - 1000
	else
		fakebuilder.tile = -input
		fakebuilder.erase = nil
		if tiletype[fakebuilder.tile] == 1
			fakebuilder.tiletype = tiledefaulttype[fakebuilder.tile]
		end
	end

	if fakebuilder.erase ~= nil
		local i = fakebuilder.x + (fakebuilder.y - 1) * map.w

		if fakebuilder.erase
			if fakebuilder.layer == 2 or fakebuilder.overlay
				map2[i] = 1
				tileinfo[i] = $ & ~1
			else
				map1[i] = 1
				tileinfo[i] = $ & ~240
			end
		elseif fakebuilder.erase == false
			if fakebuilder.overlay
				map2[i] = fakebuilder.tile
				tileinfo[i] = $ | 1
			elseif fakebuilder.layer == 1
				map1[i] = fakebuilder.tile
				tileinfo[i] = $ & ~240 | (fakebuilder.tiletype << 4)
				if tiletype[fakebuilder.tile] == 25 // Enemy spawner
				and not noenemies
					checkSpawner(i, fakebuilder.x, fakebuilder.y)
				end
			else
				map2[i] = fakebuilder.tile
				tileinfo[i] = $ & ~1
			end
		end
	end
end

local function spawnFakeBuilder()
	local fakebuildermap
	if fakebuilder
		fakebuildermap = fakebuilder.map
	elseif mapheaderinfo[gamemap].kawaiii_mapbuilder == "auto"
		fakebuildermap = 1
	else
		if P_RandomChance(FU / 100)
			fakebuildermap = #modmaps.builderinputs
		else
			fakebuildermap = P_RandomRange(2, #modmaps.builderinputs - 1)
		end
	end

	fakebuilder = {
		map = fakebuildermap,
		input = 0,
		speed = 2,
		x = 4, y = map.h - 3,
		layer = 1,
		overlay = false,
		tiletype = 0
	}
end

local function centerCamera(p)
	if p.builder
		centerCameraAroundPoint(p,
			(p.x - 1) * BLOCK_SIZE + BLOCK_SIZE / 2,
			(p.y - 1) * BLOCK_SIZE + BLOCK_SIZE / 2)
	elseif p.dead
		centerCameraAroundPoint(p, p.x, p.y)
	else
		local o = p.obj
		centerCameraAroundPoint(p,
			objx[o] + objw[o] / 2,
			objy[o] + objh[o] / 2)
	end
end

local function clearMap()
	// Reset map
	local size = map.w * map.h
	while #map1 > size
		table.remove(map1)
		table.remove(map2)
		table.remove(tileinfo)
	end
	for i = 1, size
		map1[i] = 1
		map2[i] = 1
		tileinfo[i] = 0
	end

	// Reset tickers
	mapticker = 1
	maptickerspeed = min(#map1 / (30 * TICRATE), 64) // !!!
	objectticker = 1

	// Reset map actions
	map.actions = {}

	// Reset map spawn
	map.spawnx = 4 * BLOCK_SIZE - BLOCK_SIZE / 2
	map.spawny = (map.h - 4) * BLOCK_SIZE - 1
	map.spawndir = 2

	// Reset objects
	objtype = {}
	objx, objy = {}, {}
	objw, objh = {}, {}
	objdx, objdy = {}, {}
	objdir = {}
	objanim = {}
	objspr = {}
	objcolor = {}
	objspawn = {}
	objblockmap = {}
	objextra = {}
	// ...

	// Reset blockmap
	createBlockmap()

	// !!!!
	/*objtype[1] = 1
	objw[1] = OBJECT_WIDTH
	objh[1] = OBJECT_HEIGHT
	objx[1] = 8 * BLOCK_SIZE
	objy[1] = (map.h - 4) * BLOCK_SIZE - objh[1]
	objdir[1] = 1
	objspr[1] = bluecrawlaanim.spd // !!!*/

	/*for i = 1, 1000
		objtype[i] = 1
		objw[i] = OBJECT_WIDTH
		objh[i] = OBJECT_HEIGHT
		objx[i] = P_RandomRange(8 * 8, 32 * 8) * FU
		objy[i] = (map.h - 4) * BLOCK_SIZE - objh[1]
		objdir[i] = P_RandomRange(1, 2)
		objspr[i] = bluecrawlaanim.spd // !!!
	end*/

	// Reset tile history
	tilehistory = {}
	tilehistoryposition = 1

	// kawaiii
	if mapheaderinfo[gamemap].kawaiii_mapbuilder ~= "true"
		spawnFakeBuilder()

		map.background = 1
		if mapheaderinfo[gamemap].kawaiii_mapbuilder == "auto"
			map.music = "ghzlj"
		else
			map.music = mapheaderinfo[gamemap].musname
		end
		map.spawnx = 4 * BLOCK_SIZE - BLOCK_SIZE / 2
		map.spawny = (map.h - 32) * BLOCK_SIZE - 1
	end

	// !!!!! kawaiii debug
	//map.spawnx = 117 * BLOCK_SIZE - BLOCK_SIZE / 2
	//map.spawny = 36 * BLOCK_SIZE - 1
	/*for _ = 1, 15000
		handleFakeBuilder()
	end*/
end

// kawaiii
local function uninitialiseGame()
	mapchanged = true

	for p in players.iterate
		if p.menu
			menulib.close(p)
		end

		p.maps = nil
	end

	gameinitialised = nil
	pp = nil
	map = nil
	objtype = nil
	objx = nil
	objy = nil
	objw = nil
	objh = nil
	objdx = nil
	objdy = nil
	objdir = nil
	objanim = nil
	objspr = nil
	objspawn = nil
	objcolor = nil
	objblockmap = nil
	objextra = nil
	fakebuilder = nil
	compressedgamestate = nil
end

local function getSpawnPoint(p)
	local h = PLAYER_HEIGHT
	if p.starpostx ~= nil
		return
			p.starpostx * BLOCK_SIZE - BLOCK_SIZE / 2,
			p.starposty * BLOCK_SIZE - h,
			p.starpostdir
	elseif p.spawnx == nil
		return
			map.spawnx,
			map.spawny - h + 1,
			map.spawndir
	else
		return
			p.spawnx,
			p.spawny - h + 1,
			p.spawndir
	end
end

local function spawnPlayer(n)
	local p = pp[n]
	local owner = p.owner ~= nil and players[p.owner] or nil

	if p.builder
		p.builderx, p.buildery = p.x, p.y

		p.builder = nil
		p.choosingtile = nil
		p.choosingtheme = nil
	elseif p.obj
		// Remove the old body
		removeObject(p.obj)
	end

	// !!!!! kawaiii
	if not multiplayer and fakebuilder
		local starpostinput = fakebuilder.starpostinput
		clearMap()
		if starpostinput
			fakebuilder.starpostinput = starpostinput
			for _ = 1, starpostinput
				handleFakeBuilder(true)
			end
		elseif modeattacking or (server and server.valid and server.marathon)
			for _ = 1, #modmaps.builderinputs[fakebuilder.map]
				handleFakeBuilder(true)
			end
		end
	end

	p.dead = nil
	p.x, p.y = nil, nil
	p.dx, p.dy = nil, nil

	// Find spawn location and direction
	local x, y, dir = getSpawnPoint(p)

	p.jump = false
	p.spin = false
	p.spindash = false
	p.thok = nil
	p.fly = nil
	p.glide = nil
	p.climb = nil
	p.bouncemode = nil
	p.bounce = nil
	if owner and owner.mo and owner.mo.valid and skininfo[owner.mo.skin]
		setPlayerSkin(p, owner.mo.skin)
	elseif not p.skin
		setPlayerSkin(p, "sonic")
	end
	p.scrollx = 0
	p.scrolly = 0 //(map.h - 20) * BLOCK_SIZE // !!!
	//setPlayerAnimation(p, "stand") // !!!
	p.rings = 0
	p.flash = 3 * TICRATE
	//p.air = 30 * TICRATE
	p.carry = nil
	p.carried = nil
	p.shoes = nil
	p.invincibility = nil
	p.shield = nil

	// Spawn player's body
	local o = spawnObject(OBJ_PLAYER, x - objinfo[OBJ_PLAYER].w / 2, y) // !!!
	p.obj = o
	objdir[o] = dir
	objspr[o] = skininfo[p.skin].anim[objanim[o]].spd
	objextra[o] = n

	// !!!!! kawaiii debug
	if fakebuilder
		objanim[o] = "pain"
	end

	centerCamera(p)

	// Spawn enemies
	checkSpawnersInArea(
		(objx[o] - MAX_OBJECT_DIST) / BLOCK_SIZE + 1,
		(objy[o] - MAX_OBJECT_DIST) / BLOCK_SIZE + 1,
		(objx[o] + objw[o] + MAX_OBJECT_DIST) / BLOCK_SIZE + 1,
		(objy[o] + objh[o] + MAX_OBJECT_DIST) / BLOCK_SIZE + 1)

	if owner
		if mapheaderinfo[gamemap].kawaiii_mapbuilder
			changeMusic(map.music, owner)
		else
			S_ChangeMusicOld(map.music, true, owner) // kawaiii
		end
	end
end

local function spawnBuilder(p)
	local owner = p.owner ~= nil and players[p.owner] or nil

	p.builder = true
	p.x, p.y = p.builderx, p.buildery
	p.fillremove = nil
	p.fillx, p.filly = nil, nil

	p.starpostx, p.starposty = nil, nil
	p.starpostdir = nil

	p.dead = nil
	p.dx, p.dy = nil, nil

	// Remove the old body
	if p.obj
		removeObject(p.obj)
		p.obj = nil
	end

	if owner
		S_StopMusic(owner)
	end
end

local function joinGame(joiner)
	if joiner.bot return end

	local i = #pp + 1
	pp[i] = {}
	local p = pp[i]

	p.owner = #joiner

	p.tile = nil
	p.layer = 1
	p.overlay = false
	p.tiletype = 0
	p.builderx = map.spawnx / BLOCK_SIZE + 1
	p.buildery = min(map.spawny / BLOCK_SIZE + 2, map.h)
	// !!!
	p.scrollx = 0
	p.scrolly = 0
	p.builderspeed = 1
	p.erasebothlayers = false
	p.camera = 1
	p.scrolldistance = 6 // !!! p.scrolldistance = 0

	spawnPlayer(i)

	joiner.pflags = $ | PF_FORCESTRAFE

	joiner.maps = {}
	local t = joiner.maps

	t.player = i
	t.prevbuttons = joiner.cmd.buttons
	t.prevleft, t.prevright, t.prevup, t.prevdown = getKeys(joiner)
	t.horizontalkeyrepeat = 8
	t.verticalkeyrepeat = 8

	if not fakebuilder // kawaiii
		menulib.open(joiner, "help1", "maps")
	end

	/*local tj, th = joiner.tetris, host.tetris
	local cfg = th.cfg
	local builder = true

	if th.players
		if cfg.balance == 1
			local n = 0
			for _, _ in ipairs(th.builders)
				n = $ + 1
			end
			builder = n < cfg.builders
		elseif cfg.balance == 2
			local n = 0
			for _, _ in ipairs(th.players)
				n = $ + 1
			end
			builder = n >= cfg.survivors
		end

		if midgame and not builder
			builder = true
			for _, _ in ipairs(th.players)
				builder = false
				break
			end
		end
	end

	if builder
		th.builders[#joiner] = {}
		local b = th.builders[#joiner]

		b.nextshape = P_RandomRange(1, #shapes)
		th.usedshapes[b.nextshape] = true
		b.nextsprite = P_RandomRange(1, #tetristhemes[th.theme].sprites)
		local oldtt = tt
		tt = th
		prepareBlock(b)
		tt = oldtt

		b.scrolly = 0
	else
		th.players[#joiner] = {}
		local p = th.players[#joiner]

		if midgame
			local n = -1
			for _, _ in ipairs(th.players)
				n = $ + 1
			end

			n = P_RandomRange(1, n)
			for i, p2 in ipairs(th.players)
				if i ~= #joiner
					n = $ - 1
					if n == 0
						p.h = p2.h
						p.x = p2.x
						p.y = p2.y
						p.dir = p2.dir
						p.jump = p2.jump
						p.spin = p2.spin
						p.dx = p2.dx
						p.dy = p2.dy
						p.skin = p2.skin
						p.scrolly = p2.scrolly
						p.anim = p2.anim
						p.spr = p2.spr
						break
					end
				end
			end
		else
			p.h = PLAYER_HEIGHT
			p.x = P_RandomRange(0, (th.width * BLOCK_SIZE - PLAYER_WIDTH) / FU) * FU
			p.y = th.height * BLOCK_SIZE - p.h
			p.dir = P_RandomRange(1, 2)
			p.dx = 0
			p.dy = 0
			p.jump = false
			p.spin = false
			p.skin = joiner and joiner.mo and joiner.mo.valid and joiner.mo.skin or "sonic"
			p.scrolly = (th.height - 20) * BLOCK_SIZE
			setPlayerAnimation(p, "stand")
		end
		p.air = 30 * TICRATE
	end

	tj.host = #host
	tj.prevbuttons = joiner.cmd.buttons
	tj.prevleft, tj.prevright, tj.prevup, tj.prevdown = getKeys(joiner)
	tj.horizontalkeyrepeat = 8
	tj.verticalkeyrepeat = 8

	changeMusic(th.music, joiner)*/
	//COM_BufInsertText(joiner, "chasecam 1")
end

local function leaveGame(i)
	local p = pp[i]

	// Remove the player's body
	if p.obj
		removeObject(p.obj)
	end

	// Remove the player
	table.remove(pp, i)

	// Relink players to their owners
	if cpulib
		for _, p in ipairs(app.users)
			if p.maps.player > i
				p.maps.player = $ - 1
			end
		end
	else
		for p in players.iterate
			if p.maps and p.maps.player > i
				p.maps.player = $ - 1
			end
		end
	end

	// Relink players to their bodies
	for i2, p in ipairs(pp)
		if p.obj
			objextra[p.obj] = i2
		end
	end
end

/*local function joinTetris(joiner, host, midgame)
	local tj, th = joiner.tetris, host.tetris
	local cfg = th.cfg
	local builder = true

	if th.players
		if cfg.balance == 1
			local n = 0
			for _, _ in ipairs(th.builders)
				n = $ + 1
			end
			builder = n < cfg.builders
		elseif cfg.balance == 2
			local n = 0
			for _, _ in ipairs(th.players)
				n = $ + 1
			end
			builder = n >= cfg.survivors
		end

		if midgame and not builder
			builder = true
			for _, _ in ipairs(th.players)
				builder = false
				break
			end
		end
	end

	if builder
		th.builders[#joiner] = {}
		local b = th.builders[#joiner]

		b.nextshape = P_RandomRange(1, #shapes)
		th.usedshapes[b.nextshape] = true
		b.nextsprite = P_RandomRange(1, #tetristhemes[th.theme].sprites)
		local oldtt = tt
		tt = th
		prepareBlock(b)
		tt = oldtt

		b.scrolly = 0
	else
		th.players[#joiner] = {}
		local p = th.players[#joiner]

		if midgame
			local n = -1
			for _, _ in ipairs(th.players)
				n = $ + 1
			end

			n = P_RandomRange(1, n)
			for i, p2 in ipairs(th.players)
				if i ~= #joiner
					n = $ - 1
					if n == 0
						p.h = p2.h
						p.x = p2.x
						p.y = p2.y
						p.dir = p2.dir
						p.jump = p2.jump
						p.spin = p2.spin
						p.dx = p2.dx
						p.dy = p2.dy
						p.skin = p2.skin
						p.scrolly = p2.scrolly
						p.anim = p2.anim
						p.spr = p2.spr
						break
					end
				end
			end
		else
			p.h = PLAYER_HEIGHT
			p.x = P_RandomRange(0, (th.width * BLOCK_SIZE - PLAYER_WIDTH) / FU) * FU
			p.y = th.height * BLOCK_SIZE - p.h
			p.dir = P_RandomRange(1, 2)
			p.dx = 0
			p.dy = 0
			p.jump = false
			p.spin = false
			p.skin = joiner and joiner.mo and joiner.mo.valid and joiner.mo.skin or "sonic"
			p.scrolly = (th.height - 20) * BLOCK_SIZE
			setPlayerAnimation(p, "stand")
		end
		p.air = 30 * TICRATE
	end

	tj.host = #host
	tj.prevbuttons = joiner.cmd.buttons
	tj.prevleft, tj.prevright, tj.prevup, tj.prevdown = getKeys(joiner)
	tj.horizontalkeyrepeat = 8
	tj.verticalkeyrepeat = 8

	changeMusic(th.music, joiner)
	//COM_BufInsertText(joiner, "chasecam 1")
end*/

local function clearMapAndPlayers()
	clearMap()

	// Reset players
	for _, p in ipairs(pp)
		p.tile = 2
		p.builderx = map.spawnx / BLOCK_SIZE + 1
		p.buildery = map.spawny / BLOCK_SIZE + 2
		p.tpx, p.tpy = nil, nil
		p.spawnx, p.spawny = nil, nil
		p.scrollx, p.scrolly = 0, 0 // !!!
		spawnBuilder(p)
	end
end


local maxcodesize = 16
local tilesize = 12

local function compressLayer(layer)
	// Count how many times each tile is used
	local uses = {}
	for i = 1, #tiletype
		uses[i] = 0
	end
	for i = 1, #layer
		uses[layer[i]] = $ + 1
	end

	local usedtiles = {}
	for i = 1, #tiletype
		if uses[i]
			usedtiles[#usedtiles + 1] = i
		end
	end

	// Sort tiles by number of uses
	local function sortTiles(tile1, tile2)
		return uses[tile1] > uses[tile2]
	end
	table.sort(usedtiles, sortTiles)

	local compressedtiles = {}
	for i = 1, #usedtiles
		local tile = usedtiles[i]
		compressedtiles[i] = tile | (uses[tile] << 16)
	end

	local tilecode = {}
	local tilecodesize = {}
	local code = 0
	local codesize = 0
	local maxcodesizemask = (1 << maxcodesize) - 1
	//local usedbits = 0 // !!!

	// Generate a binary probability tree
	local function split(i1, i2, range)
		if i1 == i2
			local tile = usedtiles[i1]
			if codesize < maxcodesize or codesize == maxcodesize and code ~= maxcodesizemask
				tilecode[tile] = code
				tilecodesize[tile] = codesize
				//usedbits = $ + uses[usedtiles[i1]] * codesize // !!!
			else
				tilecode[tile] = maxcodesizemask | (tile << maxcodesize)
				tilecodesize[tile] = maxcodesize + tilesize
				//usedbits = $ + uses[usedtiles[i1]] * (maxcodesize + tilesize) // !!!
			end
			return
		end

		local half = range / 2
		local sum = 0
		for i = i1, i2
			sum = $ + uses[usedtiles[i]]
			if sum >= half
				codesize = $ + 1
				split(i1, i, sum)
				codesize = $ - 1

				code = $ | (1 << codesize)
				codesize = $ + 1
				split(i + 1, i2, range - sum)
				codesize = $ - 1
				code = $ & ~(1 << codesize)

				break
			end
		end
	end

	split(1, #usedtiles, #layer)

	//usedbits = $ + #compressedtiles * 32
	//print(usedbits.." bits used VS "..(#layer * 12).." bits uncompressed ("..((#layer * 12 - usedbits) * 100 / (#layer * 12)).."% compression)")

	// Generate the compressed layer
	local compressedlayer = {tiles = compressedtiles}
	local bit = 0
	compressedlayer[1] = 0
	for i = 1, #layer
		local tile = layer[i]
		local code = tilecode[tile]
		local codesize = tilecodesize[tile]

		local space = 32 - bit
		if codesize <= space
			compressedlayer[#compressedlayer] = $ | (code << bit)
			bit = $ + codesize
			if bit == 32
				compressedlayer[#compressedlayer + 1] = 0
				bit = 0
			end
		else
			local mask = (1 << space) - 1
			compressedlayer[#compressedlayer] = $ | ((code & mask) << bit)
			compressedlayer[#compressedlayer + 1] = code >> space
			bit = codesize - space
		end
	end

	return compressedlayer
end

local function decompressLayer(compressedlayer)
	// Generate a binary probability tree from the code list
	/*local codes = compressedlayer.codes
	local tree = {}
	for i = 1, #codes
		local rawcode = codes[i]
		local codesize = rawcode & 15
		local code = (rawcode >> 4) & ((1 << codesize) - 1)
		local tile = rawcode >> (4 + codesize)
	end*/

	// Count how many times each tile is used
	local uses = {}
	local usedtiles = {}
	local compressedtiles = compressedlayer.tiles
	for i = 1, #compressedtiles
		local compressedtile = compressedtiles[i]
		usedtiles[i] = compressedtile & 65535
		uses[i] = compressedtile >> 16
	end

	local codes = {}
	local code = 0
	local codesize = 0
	local maxcodesizemask = (1 << maxcodesize) - 1

	// Generate a binary probability tree
	local function split(i1, i2, range, tree)
		if i1 == i2
			if not (codesize == maxcodesize and code == maxcodesizemask)
				tree[1] = usedtiles[i1]
			else
				tree[1] = false
			end
			return
		end

		local half = range / 2
		local sum = 0
		for i = i1, i2
			sum = $ + uses[i]
			if sum >= half
				codesize = $ + 1
				tree[1] = {}
				split(i1, i, sum, tree[1])
				codesize = $ - 1

				code = $ | (1 << codesize)
				codesize = $ + 1
				tree[2] = {}
				split(i + 1, i2, range - sum, tree[2])
				codesize = $ - 1
				code = $ & ~(1 << codesize)

				break
			end
		end
	end

	split(1, #usedtiles, map.w * map.h, codes)

	/*print("Checking tree...")
	code = 0
	codesize = 0
	local function check(tree)
		if #tree == 1
			local s = ""
			for i = 1, codesize
				s = $..((code & (1 << (i - 1))) and "1" or "0")
			end

			if tree[1] == false
				print(s..", false")
			else
				print(s..", "..tree[1])
			end
			return
		end

		codesize = $ + 1
		check(tree[1])
		codesize = $ - 1

		code = $ | (1 << codesize)
		codesize = $ + 1
		check(tree[2])
		codesize = $ - 1
		code = $ & ~(1 << codesize)
	end
	if fakesize
		check(codes)
		print("Tree checked.")
	end*/

	// Decompress the layer
	local layer = {}
	local byte = 1
	local bytevalue = compressedlayer[byte]
	local bit = 0
	for i = 1, map.w * map.h
		local tree = codes
		local codesize = 0

		while #tree ~= 1
			if bytevalue & (1 << bit)
				tree = tree[2]
			else
				tree = tree[1]
			end

			codesize = $ + 1
			if codesize > maxcodesize break end

			bit = $ + 1
			if bit == 32
				byte = $ + 1
				bytevalue = compressedlayer[byte]
				bit = 0
			end
		end

		local tile = tree[1]
		if codesize <= maxcodesize and tile ~= false
			layer[#layer + 1] = tile
		else
			tile = 0

			for i = 0, tilesize - 1
				if bytevalue & (1 << bit)
					tile = $ | (1 << i)
				end

				bit = $ + 1
				if bit == 32
					byte = $ + 1
					bytevalue = compressedlayer[byte]
					bit = 0
				end
			end

			layer[#layer + 1] = tile
		end
	end

	return layer
end

local function compressMap()
	compressedgamestate.map = {}

	for k, v in pairs(map)
		if type(k) == "string" and k ~= "tileinfo"
			compressedgamestate.map[k] = v
		end
	end

	compressedgamestate.map[1] = compressLayer(map1)
	compressedgamestate.map[2] = compressLayer(map2)

	// !!!! Hacky!!!
	for i = 1, #tileinfo
		tileinfo[i] = $ + 1
	end
	compressedgamestate.map.tileinfo = compressLayer(tileinfo)
end

local function decompressMap()
	map = {}

	for k, v in pairs(compressedgamestate.map)
		if type(k) == "string" and k ~= "tileinfo"
			map[k] = v
		end
	end

	map[1] = decompressLayer(compressedgamestate.map[1])
	map[2] = decompressLayer(compressedgamestate.map[2])

	// !!!! Hacky!!!
	map.tileinfo = decompressLayer(compressedgamestate.map.tileinfo)
	for i = 1, #map.tileinfo
		map.tileinfo[i] = $ - 1
	end

	map1 = map[1]
	map2 = map[2]
	tileinfo = map.tileinfo
end

local function compressBlockmap()
	local blockmap = blockmap

	local compressedblockmap = {}
	local compressedblockmappositions = {}
	for i = 1, #blockmap
		local block = blockmap[i]

		local empty = true
		for j = 1, #block
			if block[j]
				empty = false
				break
			end
		end

		//if block[1]
		if not empty
			local compressedblock = {}
			for j = 1, #block
				compressedblock[#compressedblock + 1] = block[j]
			end
			compressedblockmap[#compressedblockmap + 1] = compressedblock
			compressedblockmappositions[#compressedblockmappositions + 1] = i
		end
	end

	compressedgamestate.blockmap = compressedblockmap
	compressedgamestate.blockmappositions = compressedblockmappositions
	compressedgamestate.blockmapw = blockmapw
	compressedgamestate.blockmaph = blockmaph
end

local function decompressBlockmap()
	blockmap = {}
	blockmapw = compressedgamestate.blockmapw
	blockmaph = compressedgamestate.blockmaph

	local compressedblockmap = compressedgamestate.blockmap
	local compressedblockmappositions = compressedgamestate.blockmappositions
	local blockmap = blockmap

	for i = 1, blockmapw * blockmaph
		blockmap[i] = {}
	end

	for i = 1, #compressedblockmap
		local compressedblock = compressedblockmap[i]
		local block = blockmap[compressedblockmappositions[i]]
		for j = 1, #compressedblock
			block[j] = compressedblock[j]
		end
	end
end

local function compressGamestate()
	compressedgamestate = {}

	compressMap()
	compressBlockmap()
end

local function decompressGamestate()
	decompressMap()
	decompressBlockmap()

	compressedgamestate = nil
end

local function compressMapOld()
	compressedgamestate = {}
	compressedgamestate.map = {}

	local map = map
	local map1 = map1
	local map2 = map2
	local tileinfo = tileinfo
	local compressedmap = compressedgamestate.map

	for k, v in pairs(map)
		if type(k) == "string" and k ~= "tileinfo"
			compressedmap[k] = v
		end
	end

	for i = 1, #map1
		compressedmap[i] = map1[i] | (map2[i] << TILE2) | (tileinfo[i] << 12)
	end
end

local function decompressMapOld()
	map = {}
	map[1] = {}
	map[2] = {}
	map.tileinfo = {}
	map1 = map[1]
	map2 = map[2]
	tileinfo = map.tileinfo

	local map = map
	local map1 = map1
	local map2 = map2
	local tileinfo = tileinfo
	local compressedmap = compressedgamestate.map

	for k, v in pairs(compressedmap)
		if type(k) == "string"
			map[k] = v
		end
	end
	map.backgroundtype = $ or 2

	for i = 1, #compressedmap
		local tile = compressedmap[i]
		map1[i] = tile & TILE1
		map2[i] = tile >> TILE2
		tileinfo[i] = (tile >> 12) & 255
	end

	createBlockmap() // !!!

	compressedgamestate = nil
end


local function setRenderScale(n)
	// Rescale the tile sprites if they are already loaded
	if not spritesnotloaded
		for i = 1, #tilescale
			tilescale[i] = $ / renderscale * n
			tilex[i] = $ / renderscale * n
			tiley[i] = $ / renderscale * n
		end
	end

	renderscale = n
end


// Menu

local help_page = 1
local HELP_PAGES = 6

local function helptitle(title)
	return {
		text = "\x85"..title,
		skip = true
	}
end

local function helppage()
	local page = help_page

	local line = {
		text = "Page "..page.." of "..HELP_PAGES,
		tip = "Use the left and right keys to change the page, or spin to come back.",
	}

	if page ~= 1
		line.left = function(p, t)
			t.id = "help"..page - 1
		end
	end

	if page ~= HELP_PAGES
		line.right = function(p, t)
			t.id = "help"..page + 1
		end
		line.ok = function(p, t)
			t.id = "help"..page + 1
		end
	end

	help_page = $ + 1

	return line
end

local function helpline(text)
	return {
		text = function() return text, "" end,
		skip = true
	}
end

local function helplinecentered(text)
	return {
		text = text,
		skip = true
	}
end


local menus = {
template = {
	step = 6,
	background = "GHZWALLC",
	backgroundsize = 32,
	border = "GHZWALL7",
	bordersize = 8
},
mainhost = {
	w = 128, h = 128,
	{
		text = function(p)
			return pp[p.maps.player].builder and "Play" or "Edit"
		end,
		tip = "Switch between testing and editing mode",
		ok = function(player)
			local n = player.maps.player
			local p = pp[n]

			if p.builder
				spawnPlayer(n)
			else
				spawnBuilder(p)
			end

			menulib.close(player)
		end
	},
	menulib.separator,
	{
		text = function(p)
			return "Layer: "..pp[p.maps.player].layer
		end,
		tip = "Shortcut: CUSTOM ACTION 1",
		condition = function(p)
			return pp[p.maps.player].builder
		end,
		ok = function(player)
			local p = pp[player.maps.player]
			p.layer = $ == 1 and 2 or 1
			p.overlay = false
		end,
		left = function(player)
			local p = pp[player.maps.player]
			p.layer = $ == 1 and 2 or 1
			p.overlay = false
		end,
		right = function(player)
			local p = pp[player.maps.player]
			p.layer = $ == 1 and 2 or 1
			p.overlay = false
		end
	},
	{
		text = function(p)
			return "Overlay: "..(pp[p.maps.player].overlay and "Yes" or "No")
		end,
		tip = "Shortcut: CUSTOM ACTION 2",
		condition = function(p)
			return pp[p.maps.player].builder
		end,
		ok = function(p)
			pp[p.maps.player].overlay = not $
		end,
		left = function(p)
			pp[p.maps.player].overlay = not $
		end,
		right = function(p)
			pp[p.maps.player].overlay = not $
		end
	},
	menulib.separator,
	{
		text = function(p)
			local layer = pp[p.maps.player].visiblelayer
			return "Show "..(
				layer == 1 and "selected layer"
				or layer == 2 and "layer 1"
				or layer == 3 and "layer 2"
				or layer == 4 and "overlay"
				or "all layers")
		end,
		tip = "Choose what layers are displayed in editing mode",
		condition = function(p)
			return pp[p.maps.player].builder
		end,
		left = function(p)
			pp[p.maps.player].visiblelayer = not $ and 4 or $ ~= 1 and $ - 1 or nil
		end,
		right = function(p)
			pp[p.maps.player].visiblelayer = not $ and 1 or $ ~= 4 and $ + 1 or nil
		end
	},
	menulib.separator,
	{
		text = "Fill rectangular area",
		tip = "Fill a rectangular area with a tile",
		condition = function(p)
			return pp[p.maps.player].builder
		end,
		ok = function(player)
			local p = pp[player.maps.player]
			p.fillx, p.filly = p.x, p.y
			menulib.close(player)
		end
	},
	{
		text = "Remove rectangular area",
		tip = "Remove a rectangular area",
		condition = function(p)
			return pp[p.maps.player].builder
		end,
		ok = function(player)
			local p = pp[player.maps.player]
			p.fillremove = true
			p.fillx, p.filly = p.x, p.y
			menulib.close(player)
		end
	},
	menulib.separator,
	{
		text = "Set spawn",
		tip = "Set your cursor position as your spawn",
		condition = function(p)
			return pp[p.maps.player].builder
		end,
		ok = "playerspawnproperties"
	},
	menulib.separator,
	{
		text = "Set map spawn",
		tip = "Set your cursor position as the map spawn",
		condition = function(p)
			return pp[p.maps.player].builder
		end,
		ok = "mapspawnproperties"
	},
	{text = "Level properties", ok = "properties"},
	{text = "Clear level", ok = "clearmap"},
	menulib.separator,
	{
		text = "Save",
		tip = "Save the level",
		ok = function(p)
			COM_BufInsertText(p, "save")
		end
	},
	{text = "Options", ok = "options"},
	{text = "Help", ok = "help1"},
	{
		text = "Quit",
		tip = cpulib and "Quit the Map Builder" or "You can't quit in stand-alone mode.",
		condition = not cpulib and do return false end or nil,
		ok = function(p)
			cpulib.leaveApplication(p)
		end
	}
},
mainplayer = {
	w = 128, h = 128,
	{
		text = function(p)
			return pp[p.maps.player].builder and "Play" or "Edit"
		end,
		tip = "Switch between testing and editing mode",
		ok = function(player)
			local n = player.maps.player
			local p = pp[n]

			if p.builder
				spawnPlayer(n)
			else
				spawnBuilder(p)
			end

			menulib.close(player)
		end
	},
	menulib.separator,
	{
		text = function(p)
			return "Layer: "..pp[p.maps.player].layer
		end,
		tip = "Shortcut: CUSTOM ACTION 1",
		condition = function(p)
			return pp[p.maps.player].builder
		end,
		ok = function(player)
			local p = pp[player.maps.player]
			p.layer = $ == 1 and 2 or 1
			p.overlay = false
		end,
		left = function(player)
			local p = pp[player.maps.player]
			p.layer = $ == 1 and 2 or 1
			p.overlay = false
		end,
		right = function(player)
			local p = pp[player.maps.player]
			p.layer = $ == 1 and 2 or 1
			p.overlay = false
		end
	},
	{
		text = function(p)
			return "Overlay: "..(pp[p.maps.player].overlay and "Yes" or "No")
		end,
		tip = "Shortcut: CUSTOM ACTION 2",
		condition = function(p)
			return pp[p.maps.player].builder
		end,
		ok = function(p)
			pp[p.maps.player].overlay = not $
		end,
		left = function(p)
			pp[p.maps.player].overlay = not $
		end,
		right = function(p)
			pp[p.maps.player].overlay = not $
		end
	},
	menulib.separator,
	{
		text = function(p)
			local layer = pp[p.maps.player].visiblelayer
			return "Show "..(
				layer == 1 and "selected layer"
				or layer == 2 and "layer 1"
				or layer == 3 and "layer 2"
				or layer == 4 and "overlay"
				or "all layers")
		end,
		tip = "Choose what layers are displayed when editing",
		condition = function(p)
			return pp[p.maps.player].builder
		end,
		left = function(p)
			pp[p.maps.player].visiblelayer = not $ and 4 or $ ~= 1 and $ - 1 or nil
		end,
		right = function(p)
			pp[p.maps.player].visiblelayer = not $ and 1 or $ ~= 4 and $ + 1 or nil
		end
	},
	menulib.separator,
	{
		text = "Set spawn",
		tip = "Set your cursor position as your spawn",
		condition = function(p)
			return pp[p.maps.player].builder
		end,
		ok = "playerspawnproperties"
	},
	menulib.separator,
	{text = "Options", ok = "options"},
	{text = "Help", ok = "help1"},
	{
		text = "Quit",
		tip = cpulib and "Quit the Map Builder" or "You can't quit in stand-alone mode.",
		condition = not cpulib and do return false end or nil,
		ok = function(p)
			cpulib.leaveApplication(p)
		end
	}
},
playerspawnproperties = {
	w = 128, h = 128,
	{
		text = function(player)
			local p = pp[player.maps.player]
			return "Direction", p.spawndir == 1 and "Left" or "Right"
		end,
		ok = function(player)
			local p = pp[player.maps.player]

			p.spawnx = p.x * BLOCK_SIZE - BLOCK_SIZE / 2
			p.spawny = p.y * BLOCK_SIZE - 1
			p.spawndir = $ or 2
			menulib.close(player)
		end,
		left = function(player)
			local p = pp[player.maps.player]
			p.spawndir = $ == 1 and 2 or 1
		end,
		right = function(player)
			local p = pp[player.maps.player]
			p.spawndir = $ == 1 and 2 or 1
		end
	},
},
mapspawnproperties = {
	w = 128, h = 128,
	{
		text = function(p)
			return "Direction", map.spawndir == 1 and "Left" or "Right"
		end,
		ok = function(player)
			local p = pp[player.maps.player]

			map.spawnx = p.x * BLOCK_SIZE - BLOCK_SIZE / 2
			map.spawny = p.y * BLOCK_SIZE - 1
			menulib.close(player)
		end,
		left = function()
			map.spawndir = $ == 1 and 2 or 1
		end,
		right = function()
			map.spawndir = $ == 1 and 2 or 1
		end
	},
},
properties = {
	w = 128, h = 128,
	open = function(p)
		p.menu.mapw, p.menu.maph = map.w, map.h
	end,
	{
		text = function()
			return "Background type", map.backgroundtype == 1 and "Picture" or "Color"
		end,
		tip = "Set the level background type",
		left = function()
			if map.backgroundtype == 1
				map.backgroundtype = 2
				map.background = 213
			else
				map.backgroundtype = 1
				map.background = 1
			end
		end,
		right = function()
			if map.backgroundtype == 1
				map.backgroundtype = 2
				map.background = 213
			else
				map.backgroundtype = 1
				map.background = 1
			end
		end
	},
	{
		text = function()
			if map.backgroundtype == 1
				return "Background picture", modmaps.backgrounds[map.background].name
			else
				return "Background color", map.background
			end
		end,
		tip = "Set the level background",
		left = function()
			if map.backgroundtype == 1
				map.background = $ == 1 and #modmaps.backgrounds or $ - 1
			else
				map.background = $ == 0 and 255 or $ - 1
			end
		end,
		right = function()
			if map.backgroundtype == 1
				map.background = $ ~= #modmaps.backgrounds and $ + 1 or 1
			else
				map.background = $ ~= 255 and $ + 1 or 0
			end
		end
	},
	menulib.separator,
	{
		text = function()
			if type(map.music) == "number" and map.music >= mus_map01m and map.music <= mus_mapzzm
				return "Music slot", G_BuildMapName(map.music):sub(4, 5)
			else
				return "Music slot", map.music
			end
		end,
		tip = "Set the level music",
		left = function(p)
			if type(map.music) == "number" and map.music >= mus_map01m and map.music <= mus_mapzzm
				map.music = $ <= mus_map01m and mus_mapb9m or $ - 1
			else
				map.music = mus_mapb9m
			end
			if allowmusicpreview
				S_ChangeMusicOld(map.music, true, p)
			end
		end,
		right = function(p)
			if type(map.music) == "number" and map.music >= mus_map01m and map.music <= mus_mapzzm
				map.music = $ < mus_mapb9m and $ + 1 or mus_map01m
			else
				map.music = mus_map01m
			end
			if allowmusicpreview
				S_ChangeMusicOld(map.music, true, p)
			end
		end
	},
	{
		text = function()
			return "Music preview", allowmusicpreview and "On" or "Off"
		end,
		tip = "Preview when setting the music. Disable if it causes lag spikes.",
		ok = function()
			allowmusicpreview = not $
		end,
		left = function()
			allowmusicpreview = not $
		end,
		right = function()
			allowmusicpreview = not $
		end
	},
	menulib.separator,
	{
		text = function(p)
			return "Width", p.menu.mapw
		end,
		left = function(p)
			p.menu.mapw = max($ - 8, 40)
		end,
		right = function(p)
			p.menu.mapw = ($ + 8) * p.menu.maph <= 65536 and $ + 8 or $
		end
	},
	{
		text = function(p)
			return "Height", p.menu.maph
		end,
		left = function(p)
			p.menu.maph = max($ - 8, 32)
		end,
		right = function(p)
			p.menu.maph = p.menu.mapw * ($ + 8) <= 65536 and $ + 8 or $
		end
	},
	menulib.separator,
	{
		text = function()
			return "Level editing", allowediting and "Enabled" or "Disabled"
		end,
		tip = "When disabled, only the host and the administrators can edit the map",
		ok = function()
			allowediting = not $
			print("Level editing was "..(allowediting and "en" or "dis").."abled.")
		end,
		left = function()
			allowediting = not $
			print("Level editing was "..(allowediting and "en" or "dis").."abled.")
		end,
		right = function()
			allowediting = not $
			print("Level editing was "..(allowediting and "en" or "dis").."abled.")
		end
	},
	menulib.separator,
	{
		text = function()
			return "Scale factor", renderscale
		end,
		//tip = "", // !!!
		left = function()
			if renderscale ~= 1
				setRenderScale(renderscale >> 1)
			else
				setRenderScale(16)
			end
			for _, p in ipairs(pp)
				centerCamera(p)
			end
		end,
		right = function()
			if renderscale ~= 16
				setRenderScale(renderscale << 1)
			else
				setRenderScale(1)
			end
			for _, p in ipairs(pp)
				centerCamera(p)
			end
		end
	},
	menulib.separator,
	{
		text = "Apply new level size",
		tip = "Be careful, this will reset the map!",
		condition = function(p)
			return p.menu.mapw ~= nil and (p.menu.mapw ~= map.w or p.menu.maph ~= map.h)
		end,
		ok = "clearmap"
	}
},
clearmap = {
	w = 128, h = 128,
	open = function(p, t)
		t.choice = 4
	end,
	{text = "Are you sure you want", skip = true},
	{text = "to remove everything?", skip = true},
	menulib.separator,
	{
		text = "No",
		ok = function(p)
			menulib.close(p)
		end
	},
	{
		text = "Yes",
		ok = function(player)
			if player.menu.mapw ~= nil
				map.w, map.h = player.menu.mapw, player.menu.maph
			end

			clearMapAndPlayers()

			print("The map has been reset.")

			menulib.close(player)
		end
	}
},
options = {
	w = 128, h = 128,
	{
		text = function(p)
			local t = pp[p.maps.player].camera
			if t == 1
				t = "Basic"
			elseif t == 2
				t = "Center"
			elseif t == 3
				t = "Dynamic 1"
			elseif t == 4
				t = "Dynamic 2"
			end
			return "Camera type", t
		end,
		left = function(p)
			pp[p.maps.player].camera = $ ~= 1 and $ - 1 or 4
		end,
		right = function(p)
			pp[p.maps.player].camera = $ ~= 4 and $ + 1 or 1
		end,
	},
	/*{
		text = function(p)
			return "Dynamic camera", pp[p.maps.player].dynamiccamera and "Yes" or "No"
		end,
		left = function(p)
			pp[p.maps.player].dynamiccamera = not $
		end,
		right = function(p)
			pp[p.maps.player].dynamiccamera = not $
		end,
		ok = function(p)
			menulib.close(p)
		end
	},*/
	{
		text = function(p)
			return "Camera scrolling distance", pp[p.maps.player].scrolldistance
		end,
		left = function(p)
			pp[p.maps.player].scrolldistance = $ <= 0 and 6 or $ - 1
		end,
		right = function(p)
			pp[p.maps.player].scrolldistance = $ < 6 and $ + 1 or 0
		end,
	},
	// !!!!! kawaiii debug
	/*menulib.separator,
	{
		text = function(p)
			return "Cursor speed", 9 - pp[p.maps.player].builderspeed
		end,
		left = function(p)
			pp[p.maps.player].builderspeed = $ == 8 and 1 or $ + 1
		end,
		right = function(p)
			pp[p.maps.player].builderspeed = $ == 1 and 8 or $ - 1
		end,
		ok = function(p)
			menulib.close(p)
		end
	},
	{
		text = function(p)
			return "Erase both layers", pp[p.maps.player].erasebothlayers and "Yes" or "No"
		end,
		tip = "Erase both layers when erasing",
		left = function(p)
			pp[p.maps.player].erasebothlayers = not $
		end,
		right = function(p)
			pp[p.maps.player].erasebothlayers = not $
		end,
		ok = function(p)
			pp[p.maps.player].erasebothlayers = not $
		end
	},*/
	menulib.separator,
	{
	text = function(p)
		return "Show background", pp[p.maps.player].nobgpic and "No" or "Yes"
	end,
	tip = "Disabling may improve the framerate",
	left = function(p)
		pp[p.maps.player].nobgpic = not $ and true or nil
	end,
	right = function(p)
		pp[p.maps.player].nobgpic = not $ and true or nil
	end,
	ok = function(p)
		pp[p.maps.player].nobgpic = not $ and true or nil
	end,
	}
},
help1 = {
	w = 256, h = 128,
	helppage(),
	helptitle("Basic controls"),
	menulib.separator,
	menulib.separator,
	menulib.separator,
	menulib.separator,
	menulib.separator,
	menulib.separator,
	helpline("Toss flag: open/close menu"),
	menulib.separator,
	helpline("Jump: add/remove block"),
	menulib.separator,
	helpline("Spin: choose block")
},
help2 = {
	w = 256, h = 128,
	helppage(),
	helptitle("Advanced controls"),
	menulib.separator,
	menulib.separator,
	menulib.separator,
	menulib.separator,
	menulib.separator,
	menulib.separator,
	menulib.separator,
	helpline("Custom action 1: switch between layers 1 and 2"),
	helpline("Custom action 2: toggle overlay"),
	helpline("Custom action 3: switch between block types"),
	helpline("Ring toss: copy block")
},
help3 = {
	w = 256, h = 128,
	helppage(),
	helptitle("Layers"),
	menulib.separator,
	menulib.separator,
	menulib.separator,
	menulib.separator,
	menulib.separator,
	menulib.separator,
	menulib.separator,
	helpline("Blocks on layer 1 may be interacted with,"),
	helpline("while blocks on layer 2 are decorative."),
	helpline("Overlay blocks are like layer 2 blocks but"),
	helpline("drawn in front of players and other blocks.")
},
help4 = {
	w = 256, h = 128,
	helppage(),
	helptitle("Commands"),
	menulib.separator,
	menulib.separator,
	menulib.separator,
	menulib.separator,
	menulib.separator,
	menulib.separator,
	menulib.separator,
	helpline("helpmaps: read this help menu"),
	helpline("tp: teleport to another builder"),
	helpline("tp back: teleport back to your location before teleporting"),
	helpline("showlayer: choose what layer are shown while in build mode"),
},
help5 = {
	w = 256, h = 128,
	helppage(),
	helptitle("Server commands"),
	menulib.separator,
	menulib.separator,
	menulib.separator,
	menulib.separator,
	menulib.separator,
	menulib.separator,
	helpline("rect: fill a rectangular area with a block"),
	helpline("rect rm: remove a rectangular area"),
	helpline("tileowner: see who put the block under the cursor"),
	helpline("allowediting: enable/disable level editing for non-server players"),
	helpline("music: set the music name/number")
},
help6 = {
	w = 256, h = 128,
	helppage(),
	helptitle("Loading maps from the 2.1 version"),
	menulib.separator,
	menulib.separator,
	menulib.separator,
	menulib.separator,
	menulib.separator,
	menulib.separator,
	menulib.separator,
	helpline("Load the old map as a regular add-on,"),
	helpline("then type \"loadwad\" in the console."),
	helpline("You can then use the usual"),
	helpline("\"save\" and \"load\" commands."),
},
/*help6 = {
	w = 256, h = 128,
	helppage(),
	helptitle("Saving"),
	menulib.separator,
	helpline("1) Open the\x84 tossflag menu\x80 and choose\x84 Save\x80"),
	helpline("2) Open\x84 log.txt\x80 from your SRB2 folder in a text editor"),
	helpline("3) Find the line that contains\x84 \"--- MAP START ---\"\x80"),
	helpline("     (if several,\x84 TAKE THE LAST ONE\x80)"),
	helpline("     and\x84 copy\x80 everything until\x84 \"--- MAP END ---\"\x80"),
	helpline("     (CTRL+F and CTRL+SHIFT+END are your friends)"),
	helpline("4) Create a\x84 new text file\x80 and\x84 paste\x80 in it"),
	helpline("5)\x84 Save\x80 the new text file with extension\x84 .lua\x80 (e.g. GreenHillZone.lua)"),
	helpline("6) To load the level again, simply load it as an\x84 add-on\x80"),
	helpline("     and type\x84 \"load\" in the console\x80"),
},*/
}

menulib.set("maps", menus)


local function initialiseGame()
	gameinitialised = true // kawaiii

	pp = {}

	map = {}
	map[1] = {}
	map[2] = {}
	map.tileinfo = {}
	map1 = map[1]
	map2 = map[2]
	tileinfo = map.tileinfo

	if mapheaderinfo[gamemap].kawaiii_mapbuilder == "true"
		map.w, map.h = 512, 64
	else
		map.w, map.h = 384, 48
	end
	map.backgroundtype = 1
	map.background = 1
	map.music = mus_map45m

	clearMapAndPlayers()

	if not cpulib and mapheaderinfo[gamemap].kawaiii_mapbuilder
		for p in players.iterate
			joinGame(p)
		end
	end

	/*cfg = {}
	cfg.width = 10
	cfg.height = 20

	cfg.flood = false
	cfg.floodspeed = 512*/
end

local function enableOrDisableHUD(enable)
	for _, name in ipairs({
		"score",
		"time",
		"rings",
		"lives",
		"rankings",
		"coopemeralds",
	})
		if sugoi
			sugoi.HUDShow(name, enable)
		elseif enable
			hud.enable(name)
		else
			hud.disable(name)
		end
	end
end

local function enableHUD()
	enableOrDisableHUD(true)
end

local function disableHUD()
	enableOrDisableHUD(false)
end

local function startGame()
	if not cpulib
		for p in players.iterate
			if p.maps
				p.pflags = $ | PF_FORCESTRAFE
			end
		end

		if mapheaderinfo[gamemap].kawaiii_mapbuilder
			disableHUD()
		end
	end

	/*//t.background = P_RandomRange(1, #tetrisbackgrounds)

	map.w, map.h = 20, 20

	if not map or #map1 > map.w * map.h
		t.map = {}
	end
	for i = 1, map.w * map.h
		map[i] = 0
	end

	t.scrolly = 0

	t.score = 0
	t.gameover = false

	if cfg.flood and t.mode == 3
		t.floodspeed = cfg.floodspeed
		t.flood = t.height * BLOCK_SIZE + t.floodspeed * 128
	else
		t.flood = nil
	end

	t.music = tetrismusics[P_RandomRange(1, #tetrismusics)]

	pp = {}

	local joiners = {}
	for joiner in players.iterate
		if joiner.tetris
			table.insert(joiners, joiner)
		end
	end
	for i = 1, #joiners
		joiners[i], joiners[P_RandomRange(1, #joiners)] = $2, $1
	end

	for _, joiner in ipairs(joiners)
		if joiner ~= p and joiner.tetris.map
			endTetris(joiner)
		end
		joinTetris(joiner, p)
		joiner.tetris.menu = nil
	end*/

	/*local cfg = t.cfg

	disableHUD()

	if cfg.theme == 0
		t.theme = P_RandomRange(1, #tetristhemes)
	else
		t.theme = cfg.theme
	end

	t.background = P_RandomRange(1, #tetrisbackgrounds)
	t.borders = P_RandomRange(1, #tetristhemes[t.theme].borders)

	t.speed = cfg.speed

	if t.mode == 1
		t.width, t.height = 10, 20
	elseif t.mode == 3
		t.width = cfg.width
		t.height = cfg.height + 10 // !!!
	else
		t.width = cfg.width
		t.height = cfg.height
	end

	if not t.map or #t.map > t.width * t.height
		t.map = {}
	end
	local map = t.map
	for i = 1, t.width * t.height
		map[i] = 0
	end

	t.scrolly = 0

	t.usedshapes = {}
	for i = 1, #shapes
		t.usedshapes[i] = false
	end

	t.fall = 0
	t.nextfall = 0
	t.score = 0
	t.gameover = false

	if cfg.flood and t.mode == 3
		t.floodspeed = cfg.floodspeed
		t.flood = t.height * BLOCK_SIZE + t.floodspeed * 128
	else
		t.flood = nil
	end

	t.music = tetrismusics[P_RandomRange(1, #tetrismusics)]

	t.builders = {}

	if t.mode == 3
		t.players = {}

		local joiners = {}
		for joiner in players.iterate
			if joiner.tetris
				table.insert(joiners, joiner)
			end
		end
		for i = 1, #joiners
			joiners[i], joiners[P_RandomRange(1, #joiners)] = $2, $1
		end

		for _, joiner in ipairs(joiners)
			if joiner ~= p and joiner.tetris.map
				endTetris(joiner)
			end
			joinTetris(joiner, p)
			joiner.tetris.menu = nil
		end
	else
		joinTetris(p, p)
	end*/
end

/*function endGame(p)
	local t = p.tetris

	for i, _ in ipairs(t.builders)
		if i == #p continue end
		players[i].tetris.mode = 1
		startTetris(players[i])
	end
	if t.players
		for i, _ in ipairs(t.players)
			if i == #p continue end
			players[i].tetris.mode = 1
			startTetris(players[i])
		end
	end

	t.theme = nil
	t.music = nil
	t.background = nil
	t.width = nil
	t.height = nil
	t.map = nil
	t.score = nil
	t.gameover = nil

	t.players = nil
	t.scrolly = nil
end*/

/*local function restartTetris()
	local mode = tt.mode

	endTetris(pp)
	tt.mode = mode
	startTetris(pp)
end*/

/*function loseGame()
	tt.gameover = true
	changeMusic("_GOVER")

	if not tt.players return end

	for _, p in ipairs(tt.players)
		if not p.dead
			killPlayer(p)
		end
	end
end*/

/*local function copyBlockToMap(b)
	for i = 1, #shapes[b.shape]
		local y = getBlockY(b, i)
		if y > 0 and y <= map.h
			map[getBlockX(b, i) + (y - 1) * map.w] = b.sprite
		end
	end
end

local function putBlock(b)
	if tt.mode ~= 3 and b.y < 1
		loseTetris()
		return
	end

	copyBlockToMap(b)

	local n = 0
	for y = max(b.y, 1), min(b.y + getBlockHeight(b) - 1, map.h)
		if lineFull(y)
			for i = 1 + (y - 1) * map.w, y * map.w
				map[i] = 0
			end
			n = $ + 1
			if tt.fall == 0
				tt.nextfall = 5
			end
			tt.fall = $ + 1
		end
	end

	if n == 1
		tt.score = $ + 40
	elseif n == 2
		tt.score = $ + 100
	elseif n == 3
		tt.score = $ + 300
	elseif n == 4
		tt.score = $ + 1200
	else
		tt.score = $ + n * 400
	end

	prepareBlock(b)
end*/

/*local function blockCantMove(b, dx, dy)
	b.x = $ + dx
	b.y = $ + dy

	if b.x < 1 or b.x + getBlockWidth(b) - 1 > map.w or tt.scrolly == 0 and b.y + getBlockHeight(b) - 1 > map.h or blockColliding(b)
		b.x = $ - dx
		b.y = $ - dy
		return true
	end

	b.x = $ - dx
	b.y = $ - dy
end

local function moveBlock(b, dx, dy)
	if blockCantMove(b, dx, dy)
		if dy > 0
			b.x = $ + dx
			b.y = $ + dy

			if b.y + getBlockHeight(b) - 1 > map.h
				b.x = $ - dx
				b.y = $ - dy
				putBlock(b)
				return
			end

			for i = 1, #shapes[b.shape]
				local y = getBlockY(b, i)
				if y > 0 and y <= map.h and tt.map[getBlockX(b, i) + (y - 1) * map.w] ~= 0
					b.x = $ - dx
					b.y = $ - dy
					putBlock(b)
					return
				end
			end

			b.x = $ - dx
			b.y = $ - dy
		end
		return
	end

	if tt.players
		for _, p in ipairs(tt.players)
			if not p.dead and (playerOnBlock(p, b) or playerClimbingBlock(p, b))
				b.x = $ + dx
				b.y = $ + dy

				movePlayer(p, dx * BLOCK_SIZE, dy * BLOCK_SIZE)

				b.x = $ - dx
				b.y = $ - dy
			end
		end
	end

	b.x = $ + dx
	b.y = $ + dy

	if tt.players
		for _, p in ipairs(tt.players)
			if p.dead continue end

			for i = 1, #shapes[b.shape]
				local x, y = (getBlockX(b, i) - 1) * BLOCK_SIZE, (getBlockY(b, i) - 1) * BLOCK_SIZE

				if p.x < x + BLOCK_SIZE and p.x + PLAYER_WIDTH > x and p.y < y + BLOCK_SIZE and p.y + p.h > y
					if dx < 0
						p.x = x - PLAYER_WIDTH
					elseif dx > 0
						p.x = x + BLOCK_SIZE
					elseif dy > 0
						p.y = y + BLOCK_SIZE
					else
						p.y = y - p.h
						landPlayer(p)
					end

					if playerColliding(p)
						killPlayer(p)
					end

					break
				end
			end
		end
	end
end

local function rotateBlock(b)
	if tt.players
		for _, p in ipairs(tt.players)
			if not p.dead and playerOnBlock(p, b)
				return
			end
		end
	end

	b.angle = $ % 4 + 1

	if b.x + getBlockWidth(b) - 1 > map.w
		local oldx = b.x
		b.x = map.w - getBlockWidth(b) + 1
		if blockColliding(b)
			b.x = oldx

			b.angle = $ - 1
			if b.angle == 0
				b.angle = 4
			end
		end
		return
	elseif tt.scrolly == 0 and b.y + getBlockHeight(b) - 1 > map.h or blockColliding(b)
		b.angle = $ - 1
		if b.angle == 0
			b.angle = 4
		end
		return
	end

	if not tt.players return end

	for _, p in ipairs(tt.players)
		if p.dead continue end

		for i = 1, #shapes[b.shape]
			local x, y = (getBlockX(b, i) - 1) * BLOCK_SIZE, (getBlockY(b, i) - 1) * BLOCK_SIZE

			if p.x < x + BLOCK_SIZE and p.x + PLAYER_WIDTH > x and p.y < y + BLOCK_SIZE and p.y + p.h > y
				b.angle = $ - 1
				if b.angle == 0
					b.angle = 4
				end
				break
			end
		end
	end
end*/

// ....
local function handlePlayerScrolling(p)
	local o = p.carried or p.obj
	if p.camera == 1 or p.camera == 4 // Basic or speed
		local dx, dy = objdx[o], objdy[o]

		o = p.obj
		local baseviewh, baseviewv = (12 + (p.camera ~= 4 and p.scrolldistance or 0)) * BLOCK_SIZE / renderscale, 8 * BLOCK_SIZE / renderscale
		local extraviewh, extraviewv = dx * 16 / renderscale, dy * 16 / renderscale
		local basecameraspeedh, basecameraspeedv = 2 * FU / renderscale, 4 * FU / renderscale

		if dx < 0
			local view = baseviewh
			if p.camera == 4
				view = $ - extraviewh
			end
			local limit = (SCREEN_WIDTH - 4 * BLOCK_SIZE) / renderscale
			if view > limit
				view = limit
			end

			limit = objx[o] - view
			if p.scrollx > limit
				local scrolldx = limit - p.scrollx
				limit = dx - basecameraspeedh
				if scrolldx < limit
					scrolldx = limit
				end

				p.scrollx = $ + scrolldx

				if p.scrollx < 0
					p.scrollx = 0
				end
			end
		elseif dx > 0
			local view = baseviewh
			if p.camera == 4
				view = $ + extraviewh
			end
			local limit = (SCREEN_WIDTH - 4 * BLOCK_SIZE) / renderscale
			if view > limit
				view = limit
			end

			limit = objx[o] + objw[o] - SCREEN_WIDTH / renderscale + view
			if p.scrollx < limit
				local scrolldx = limit - p.scrollx
				limit = dx + basecameraspeedh
				if scrolldx > limit
					scrolldx = limit
				end

				p.scrollx = $ + scrolldx

				limit = map.w * BLOCK_SIZE - SCREEN_WIDTH / renderscale
				if p.scrollx > limit
					p.scrollx = limit
				end
			end
		end

		if dy < 0
			local view = baseviewv
			if p.camera == 4 and not p.jump
				view = $ - extraviewv
			end
			local limit = (SCREEN_HEIGHT - 4 * BLOCK_SIZE) / renderscale
			if view > limit
				view = limit
			end

			limit = objy[o] - view
			if p.scrolly > limit
				local scrolldy = limit - p.scrolly
				limit = dy - basecameraspeedv
				if scrolldy < limit
					scrolldy = limit
				end

				p.scrolly = $ + scrolldy

				if p.scrolly < 0
					p.scrolly = 0
				end
			end
		elseif dy > 0
			local view = baseviewv
			if p.camera == 4 and not p.jump
				view = $ + extraviewv
			end
			local limit = (SCREEN_HEIGHT - 4 * BLOCK_SIZE) / renderscale
			if view > limit
				view = limit
			end

			limit = objy[o] + objh[o] + view - SCREEN_HEIGHT / renderscale
			if p.scrolly < limit
				local scrolldy = limit - p.scrolly
				limit = dy + basecameraspeedv
				if scrolldy > limit
					scrolldy = limit
				end

				p.scrolly = $ + scrolldy

				limit = map.h * BLOCK_SIZE - SCREEN_HEIGHT / renderscale
				if p.scrolly > limit
					p.scrolly = limit
				end
			end
		end
	elseif p.camera == 2 // Center
		centerCameraAroundPoint(p,
			objx[o] + objw[o] / 2,
			objy[o] + objh[o] - PLAYER_HEIGHT / 2)
	elseif p.camera == 3 // Direction
		local view = 12 * BLOCK_SIZE / renderscale
		local cameraspeed = 4096
		//local cameraspeed = BLOCK_SIZE / 4 + abs(objdx[o]) * 5 / 4
		local minspeed = 2 * FU

		local srcx = p.scrollx + SCREEN_WIDTH / renderscale / 2

		local dstx
		if objdx[o] < -minspeed // Left
			dstx = objx[o] + objw[o] / 2 - view
		elseif objdx[o] > minspeed or objdir[o] == 2 // Right
			dstx = objx[o] + objw[o] / 2 + view
		else // Left
			dstx = objx[o] + objw[o] / 2 - view
		end

		local x = FixedMul(srcx + objdx[o], FU - cameraspeed) + FixedMul(dstx, cameraspeed)
		/*if srcx < dstx
			x = $ + cameraspeed
			if x > dstx
				x = dstx
			end
		elseif srcx > dstx
			x = $ - cameraspeed
			if x < dstx
				x = dstx
			end
		end*/

		centerCameraAroundPoint(p,
			x,
			objy[o] + objh[o] - PLAYER_HEIGHT / 2)
	end
end

// !!! rm
/*local function handlePlayerScrolling(p)
	local o = p.carried or p.obj
	local dx, dy = objdx[o], objdy[o]

	o = p.obj
	local baseviewh, baseviewv = (12 + (not p.dynamiccamera and p.scrolldistance or 0)) * BLOCK_SIZE, 8 * BLOCK_SIZE
	local extraviewh, extraviewv = dx * 16, dy * 16
	local basecameraspeedh, basecameraspeedv = 2 * FU, 4 * FU

	if dx < 0
		local view = baseviewh
		if p.dynamiccamera
			view = $ - extraviewh
		end
		local limit = SCREEN_WIDTH - 4 * BLOCK_SIZE
		if view > limit
			view = limit
		end

		limit = objx[o] - view
		if p.scrollx > limit
			local scrolldx = limit - p.scrollx
			limit = dx - basecameraspeedh
			if scrolldx < limit
				scrolldx = limit
			end

			p.scrollx = $ + scrolldx

			if p.scrollx < 0
				p.scrollx = 0
			end
		end
	elseif dx > 0
		local view = baseviewh
		if p.dynamiccamera
			view = $ + extraviewh
		end
		local limit = SCREEN_WIDTH - 4 * BLOCK_SIZE
		if view > limit
			view = limit
		end

		limit = objx[o] + objw[o] + view - SCREEN_WIDTH
		if p.scrollx < limit
			local scrolldx = limit - p.scrollx
			limit = dx + basecameraspeedh
			if scrolldx > limit
				scrolldx = limit
			end

			p.scrollx = $ + scrolldx

			limit = map.w * BLOCK_SIZE - SCREEN_WIDTH
			if p.scrollx > limit
				p.scrollx = limit
			end
		end
	end

	if dy < 0
		local view = baseviewv
		if p.dynamiccamera and not p.jump
			view = $ - extraviewv
		end
		local limit = SCREEN_HEIGHT - 4 * BLOCK_SIZE
		if view > limit
			view = limit
		end

		limit = objy[o] - view
		if p.scrolly > limit
			local scrolldy = limit - p.scrolly
			limit = dy - basecameraspeedv
			if scrolldy < limit
				scrolldy = limit
			end

			p.scrolly = $ + scrolldy

			if p.scrolly < 0
				p.scrolly = 0
			end
		end
	elseif dy > 0
		local view = baseviewv
		if p.dynamiccamera and not p.jump
			view = $ + extraviewv
		end
		local limit = SCREEN_HEIGHT - 4 * BLOCK_SIZE
		if view > limit
			view = limit
		end

		limit = objy[o] + objh[o] + view - SCREEN_HEIGHT
		if p.scrolly < limit
			local scrolldy = limit - p.scrolly
			limit = dy + basecameraspeedv
			if scrolldy > limit
				scrolldy = limit
			end

			p.scrolly = $ + scrolldy

			limit = map.h * BLOCK_SIZE - SCREEN_HEIGHT
			if p.scrolly > limit
				p.scrolly = limit
			end
		end
	end
end*/

local function handleBuilderScrolling(p)
	if p.x * BLOCK_SIZE > p.scrollx + 224 * FU / renderscale
		p.scrollx = min(p.x * BLOCK_SIZE - 224 * FU / renderscale, map.w * BLOCK_SIZE - SCREEN_WIDTH / renderscale)
	elseif p.x * BLOCK_SIZE < p.scrollx + 96 * FU / renderscale
		p.scrollx = max(p.x * BLOCK_SIZE - 96 * FU / renderscale, 0)
	end

	if p.y * BLOCK_SIZE > p.scrolly + 136 * FU / renderscale
		p.scrolly = min(p.y * BLOCK_SIZE - 136 * FU / renderscale, map.h * BLOCK_SIZE - SCREEN_HEIGHT / renderscale)
	elseif p.y * BLOCK_SIZE < p.scrolly + 64 * FU / renderscale
		p.scrolly = max(p.y * BLOCK_SIZE - 64 * FU / renderscale, 0)
	end
end

// !!! rm
/*local function handleBuilderScrolling(p)
	if p.x * BLOCK_SIZE > p.scrollx + 224 * FU
		p.scrollx = min(p.x * BLOCK_SIZE - 224 * FU, map.w * BLOCK_SIZE - SCREEN_WIDTH)
	elseif p.x * BLOCK_SIZE < p.scrollx + 96 * FU
		p.scrollx = max(p.x * BLOCK_SIZE - 96 * FU, 0)
	end

	if p.y * BLOCK_SIZE > p.scrolly + 136 * FU
		p.scrolly = min(p.y * BLOCK_SIZE - 136 * FU, map.h * BLOCK_SIZE - SCREEN_HEIGHT)
	elseif p.y * BLOCK_SIZE < p.scrolly + 64 * FU
		p.scrolly = max(p.y * BLOCK_SIZE - 64 * FU, 0)
	end
end*/

local function handlePlayer(p, n)
	local owner = p.owner ~= nil and players[p.owner] or nil
	local t
	local o = p.obj

	local left, right, up, down
	local bt
	if owner and not owner.menu
		t = owner.maps
		bt = owner.cmd.buttons
		left, right, up, down = getKeys(owner)
	else
		bt = 0
		left, right, up, down = false, false, false, false
	end

	if p.dead
		// !!! We need to wait for a short time before respawning... don't we?
		if bt & BT_JUMP and not (t.prevbuttons & BT_JUMP)
			if mapheaderinfo[gamemap].kawaiii_mapbuilder
				spawnPlayer(n)
			elseif owner
			and owner.mo and owner.mo.valid
			and owner.mo.health
				P_DamageMobj(owner.mo, nil, nil, 10000)
				owner.deadtimer = 8*TICRATE
				owner.maps = nil
				p.owner = nil
			end
		else
			if p.dy <= 0 or p.y < (map.h + 1) * BLOCK_SIZE
				p.y = $ + p.dy
				p.dy = min($ + FU / 8, 6 * FU)
				//loopPlayerAnimation(p)
			end
		end
	else
		local skin = skininfo[p.skin]

		if p.climb
			if up
				objdy[o] = -FU
				if objanim[o] ~= "climb"
					setPlayerAnimation(p, "climb")
				end
			elseif down
				objdy[o] = FU
				if objanim[o] ~= "climb"
					setPlayerAnimation(p, "climb")
				end
			else
				objdy[o] = 0
				if objanim[o] ~= "climbstatic"
					setPlayerAnimation(p, "climbstatic")
				end
			end

			if bt & BT_JUMP and not (t.prevbuttons & BT_JUMP)
				releasePlayerClimb(p)

				objdir[o] = objdir[o] == 1 and 2 or 1
				objdx[o] = objdir[o] == 1 and -PLAYER_JUMP or PLAYER_JUMP

				startSound(sfx_jump, p)
			end

			if bt & BT_USE and not (t.prevbuttons & BT_USE) or right and objdir[o] == 1 or left and objdir[o] == 2
				releasePlayerClimb(p)
				objdx[o] = objdir[o] == 1 and FU or -FU
			end

			if playerCantClimb(p)
				releasePlayerClimb(p)
				if objdy[o] < 0
					objdy[o] = -PLAYER_JUMP / 2
				end
			end
		else
			if left and p.spindash == false and p.flash ~= 3 * TICRATE and not p.bounce
				if p.glide
					objdx[o] = -2 * FU
					objdir[o] = 1
				elseif not p.spin or objdx[o] > 0
					local spd
					local acc
					if not p.shoes
						spd = skin.spd
						acc = skin.acc
					else
						spd = min(skin.spd + 3 * FU, 8 * FU)
						acc = skin.acc * 3 / 2
					end

					if objdx[o] > -spd
						if p.spin or not playerOnGround(p)
							acc = $ / 2
						end
						objdx[o] = max($ - acc, -spd)
					end

					objdir[o] = 1
					if objdx[o] > -skin.run
						if objanim[o] == "stand" or objanim[o] == "run"
							setPlayerAnimation(p, "walk")
						end
					elseif objanim[o] == "stand" or objanim[o] == "walk"
						setPlayerAnimation(p, "run")
					end
				end
			end

			if right and p.spindash == false and p.flash ~= 3 * TICRATE and not p.bounce
				if p.glide
					objdx[o] = 2 * FU
					objdir[o] = 2
				elseif not p.spin or objdx[o] < 0
					local spd
					local acc
					if not p.shoes
						spd = skin.spd
						acc = skin.acc
					else
						spd = min(skin.spd + 3 * FU, 8 * FU)
						acc = skin.acc * 3 / 2
					end

					if objdx[o] < spd
						if p.spin or not playerOnGround(p)
							acc = $ / 2
						end
						objdx[o] = min($ + acc, spd)
					end

					objdir[o] = 2
					if objdx[o] < skin.run
						if objanim[o] == "stand" or objanim[o] == "run"
							setPlayerAnimation(p, "walk")
						end
					elseif objanim[o] == "stand" or objanim[o] == "walk"
						setPlayerAnimation(p, "run")
					end
				end
			end

			if bt & BT_JUMP
				if t.prevbuttons & BT_JUMP
					if p.bounce
						p.bouncetime = $ - 1
						if not p.bouncetime
							objdx[o] = p.bouncedx

							// Bounce!
							local strength = abs(p.bouncedy)
							if strength < 4 * FU
								strength = 4 * FU
							elseif strength < 5 * FU
								strength = 5 * FU
							end
							objdy[o] = -strength

							p.bounce = nil
							p.bouncetime = nil
							p.bouncedx, p.bouncedy = nil, nil

							setPlayerAnimation(p, "bouncemode")
							startSound(sfx_boingf, p)
						end
					end
				else
					if p.jump or p.spin and not playerOnGround(p)
						if p.jump and not p.thok and skin.thok
							thokPlayer(p)
						elseif skin.fly
							flyPlayer(p)
						elseif skin.glideandclimb
							glidePlayer(p)
						elseif skin.doublejump
							objdy[o] = -PLAYER_JUMP
							if p.shield == "wind"
								objdy[o] = $ - FU
							end

							p.jump = false
							p.thok = true
							p.spin = false
							setPlayerAnimation(p, "fall")
						elseif skin.bounce
							startPlayerBounceMode(p)
						end
					elseif p.fly ~= nil and p.fly ~= 0
						if objdy[o] > -FU * 3 / 2
							objdy[o] = max($ - FU, -FU * 3 / 2)
						end
					elseif objdy[o] >= 0 and playerOnGround(p)
					or p.carried
						jumpPlayer(p)
					elseif p.shield == "wind" and not (p.jump or p.thok or p.glide or playerOnGround(p))
						objdy[o] = -PLAYER_JUMP
						if skin.doublejump
							objdy[o] = $ - FU
						end

						p.jump = false
						p.thok = true
						p.spin = false
						p.fly = nil
						p.bouncemode = nil
						p.bounce = nil
						setPlayerAnimation(p, "fall")
						startSound(sfx_wdjump, p)
					end
				end
			elseif p.glide
				releasePlayerGlide(p)
			elseif p.bouncemode
				releasePlayerBounceMode(p)
			elseif p.jump
				objdy[o] = max($, -PLAYER_JUMP / 2)
			end

			if bt & BT_USE // Pressing spin
				if t.prevbuttons & BT_USE // Holding spin
					if p.spindash ~= false
						if leveltime % 5 == 0
							if p.spindash < skin.maxdash
								startSound(sfx_spndsh, p)
							end

							--local thok = spawnObject(OBJ_THOK, objx[o], objy[o])
							--objcolor[thok] = owner and owner.skincolor or SKINCOLOR_BLUE
							--objextra[thok] = 8 // Vanish after 8 tics
						end
						p.spindash = min($ + FU / 8, skin.maxdash) // !!!
					end
				else // Spin just pressed
					/*if not p.spin and objdy[o] >= 0 and abs(objdx[o]) > FU / 2 and playerOnGround(p)
						spinPlayer(p)
					elseif p.fly ~= nil and p.fly ~= 0
						if objdy[o] < 4 * FU
							objdy[o] = min($ + FU, 4 * FU)
						end
					end*/
					if p.fly ~= nil and p.fly ~= 0 // Flying
						if objdy[o] < 4 * FU
							objdy[o] = min($ + FU, 4 * FU)
						end
					elseif not p.spin and not p.bouncemode
					and objdy[o] >= 0 and playerOnGround(p)
						if abs(objdx[o]) > FU / 2
							spinPlayer(p)
						else
							p.spindash = skin.mindash
							setObjectHeight(o, PLAYER_SPIN_HEIGHT)
							setPlayerAnimation(p, "spindash")
						end
					elseif p.shield == "wind" and not (p.thok or p.glide or playerOnGround(p))
						objdy[o] = -PLAYER_JUMP
						if skin.doublejump
							objdy[o] = $ - FU
						end

						p.jump = false
						p.thok = true
						p.spin = false
						p.bouncemode = nil
						p.bounce = nil
						setPlayerAnimation(p, "fall")
						startSound(sfx_wdjump, p)
					end
				end
			elseif p.spindash ~= false // Spindash released
				objdx[o] = objdir[o] == 1 and -p.spindash or p.spindash
				p.spindash = false
				p.spin = true
				setPlayerAnimation(p, "roll")
				startSound(sfx_zoom, p)
			end

			// Brake when not accelerating
			if not (left or right or p.spin) and playerOnGround(p)
				// !!!!! kawaiii
				/*if objdx[o] < 0
					objdx[o] = min($ + FU / 8, 0)
				elseif objdx[o] > 0
					objdx[o] = max($ - FU / 8, 0)
				end*/
			end
		end

		if objanim[o] == "walk" and objdx[o] == 0
			setPlayerAnimation(p, "stand")
		elseif objanim[o] == "run" and abs(objdx[o]) < skin.run
			setPlayerAnimation(p, "walk")
		end

		if p.spin and P_AproxDistance(objdx[o], objdy[o]) > 2 * FU and leveltime & 1
			local thok = spawnObject(OBJ_THOK, objx[o], objy[o])
			objcolor[thok] = owner and owner.skincolor or SKINCOLOR_BLUE
			objextra[thok] = 8 // Vanish after 8 tics
		end

		/*if tt.flood ~= nil and theme.flood == 1 and objy[o] + objh[o] / 3 > tt.flood
			p.air = $ - 1
			if p.air == 0
				killPlayer(p)
			elseif p.air == 10 * TICRATE
				S_ChangeMusicOld("_DROWN", false, owner)
			elseif p.air < 30 * TICRATE and p.air % (5 * TICRATE) == 0
				S_StartSound(nil, sfx_s3ka9, owner)
			end
		else
			if p.air <= 10 * TICRATE
				S_ChangeMusicOld(tt.music, true, owner)
			end
			p.air = 30 * TICRATE
		end*/

		/*if tt.flood ~= nil and ((theme.flood == 2 or theme.flood == 4) and p.y + PLAYER_HEIGHT / 3 > tt.flood or theme.flood == 3 and p.y + PLAYER_HEIGHT * 5 / 6 > tt.flood)
			killPlayer(p)
		end*/

		// !!!
		// Placeholder for springs, hazards, collectibles and other various stuff
		// This needs serious handling
		// !!!!
		for x = objx[o] / BLOCK_SIZE + 1, (objx[o] + PLAYER_WIDTH - 1) / BLOCK_SIZE + 1
			for y = objy[o] / BLOCK_SIZE + 1, min((objy[o] + objh[o] - 1) / BLOCK_SIZE + 1, map.h)
				local i = x + (y - 1) * map.w
				local tile = tiletype[map1[i]]
				if tile < 4
					continue
				elseif tile == 4 // Weak spring
					springPlayer(p, nil, 6 * FU)
				elseif tile == 5 // Strong spring
					springPlayer(p, nil, 8 * FU)
				elseif tile == 9 // Damages
					if not (p.flash or p.invincibility)
						damagePlayer(p)
						if not p.obj break 2 end // !!!!
					end
				elseif tile == 10 // Instant death
					killPlayer(p)
					break 2 // !!!!
				elseif tile == 11 // Ring
					// ...
					// !!!
					p.rings = min($ + 1, 9999)
					map1[i] = tiletag[$]
					startSound(sfx_itemup, p)
				elseif tile == 15 // Left spring
					objdx[o] = -8 * FU
					if objanim[o] == "stand"
						setPlayerAnimation(p, -objdx[o] < skin.run and "walk" or "run")
					end
					startSound(sfx_spring, p)
				elseif tile == 16 // Right spring
					objdx[o] = 8 * FU
					if objanim[o] == "stand"
						setPlayerAnimation(p, objdx[o] < skin.run and "walk" or "run")
					end
					startSound(sfx_spring, p)
				elseif tile == 17 // Steam
					if leveltime & 31 == 0
						springPlayer(p, nil, 6 * FU, P_RandomRange(sfx_steam1, sfx_steam2))
					end
				elseif tile == 18 // Star post
					if p.starpostx ~= x or p.starposty ~= y
						p.starpostx, p.starposty, p.starpostdir = x, y, objdir[o]
						if fakebuilder
							fakebuilder.starpostinput = fakebuilder.input
						end
						startSound(sfx_strpst, p)
					end

					// !!!
					// Make the starpost blink (beta)
					// Wait no it blinks already, why did I write this? Then maybe it should rotate??
					local t = map1[i]
					if tiletag[t] > t
						map1[i] = tiletag[t]
					end
				elseif tile == 19 // Weak left diagonal spring
					springPlayer(p, -6 * FU, 6 * FU)
				elseif tile == 20 // Weak right diagonal spring
					springPlayer(p, 6 * FU, 6 * FU)
				elseif tile == 21 // Strong left diagonal spring
					springPlayer(p, -8 * FU, 8 * FU)
				elseif tile == 22 // Strong right diagonal spring
					springPlayer(p, 8 * FU, 8 * FU)
				elseif tile == 26 // End sign // !!!!! kawaiii
					if fakebuilder and owner
						if mapheaderinfo[gamemap].kawaiii_mapbuilder == "auto"
							owner.mo.health = p.rings + 1
							--owner.exiting = TICRATE * 14 / 5 + 1
							P_DoPlayerFinish(owner)
						elseif not mapheaderinfo[gamemap].kawaiii_mapbuilder
						and objx[o] + objw[o] / 2 > (x - 1) * BLOCK_SIZE
						and objx[o] + objw[o] / 2 < x * BLOCK_SIZE
						and playerOnGround(p)
							P_SetOrigin(owner.mo, owner.mo.x + 256 * FU, owner.mo.y, owner.mo.z)
							owner.pflags = $1 & ~PF_FORCESTRAFE
							S_ChangeMusicOld(mapheaderinfo[gamemap].musname, true, owner)
							owner.maps = nil
							p.owner = nil
							return
						end
					end
				end
			end
		end

		if p.flash and p.flash ~= 3 * TICRATE
			p.flash = $ - 1
		end

		if p.shoes
			p.shoes = $ - 1
			if p.shoes == 0
				p.shoes = nil
				if owner
					if p.invincibility
						S_ChangeMusicOld("_INV", nil, owner)
					else
						changeMusic(map.music, owner)
					end
				end
			end
		end

		if p.invincibility
			p.invincibility = $ - 1
			if p.invincibility == 0
				p.invincibility = nil
				if owner
					if p.shoes
						S_ChangeMusicOld("_SHOES", nil, owner)
					else
						changeMusic(map.music, owner)
					end
				end
			end
		end

		if p.obj
			if objanim[o] == "stand"
			and owner and owner.mo and owner.mo.valid and owner.mo.skin ~= p.skin
			and skininfo[owner.mo.skin]
				setPlayerSkin(p, owner.mo.skin)
			end

			handlePlayerScrolling(p)
		end
	end

	if bt & BT_TOSSFLAG and not (t.prevbuttons & BT_TOSSFLAG)
		// !!!!! kawaiii
		if fakebuilder
			menulib.open(owner, "options", "maps")
		else
			menulib.open(owner, (owner == server or IsPlayerAdmin(owner)) and "mainhost" or "mainplayer", "maps")
		end
	end

	if t and not owner.menu
		t.prevup, t.prevdown = up, down
		t.prevbuttons = owner.cmd.buttons
	end
end

local function handleBuilder(p)
	local owner = p.owner ~= nil and players[p.owner] or nil
	local t

	local left, right, up, down
	local bt
	if owner and not owner.menu
		t = owner.maps
		bt = owner.cmd.buttons
		left, right, up, down = getKeys(owner)
	else
		bt = 0
		left, right, up, down = false, false, false, false
	end

	if p.choosingtile // Choosing tile
		local n = #themes[p.theme]
		local tile = p.themetile

		if left
			local ok = false

			if t.prevleft
				if t.horizontalkeyrepeat == 1
					t.horizontalkeyrepeat = p.builderspeed
					ok = true
				else
					t.horizontalkeyrepeat = $ - 1
				end
			else
				t.horizontalkeyrepeat = 8
				ok = true
			end

			if ok
				local columns = (SCREEN_WIDTH - 2 * BLOCK_SIZE) / (BLOCK_SIZE * 3 / 2) + 1
				repeat
					tile = ($ - 1) % columns ~= 0 and $ - 1 or $ + columns - 1
				until tile <= n
			end
		end

		if right
			local ok = false

			if t.prevright
				if t.horizontalkeyrepeat == 1
					t.horizontalkeyrepeat = p.builderspeed
					ok = true
				else
					t.horizontalkeyrepeat = $ - 1
				end
			else
				t.horizontalkeyrepeat = 8
				ok = true
			end

			if ok
				local columns = (SCREEN_WIDTH - 2 * BLOCK_SIZE) / (BLOCK_SIZE * 3 / 2) + 1
				tile = $ % columns ~= 0 and $ + 1 <= n and $ + 1 or ($ - 1) / columns * columns + 1
			end
		end

		if up
			local ok = false

			if t.prevup
				if t.verticalkeyrepeat == 1
					t.verticalkeyrepeat = p.builderspeed
					ok = true
				else
					t.verticalkeyrepeat = $ - 1
				end
			else
				t.verticalkeyrepeat = 8
				ok = true
			end

			if ok
				local columns = (SCREEN_WIDTH - 2 * BLOCK_SIZE) / (BLOCK_SIZE * 3 / 2) + 1
				repeat
					tile = $ > columns and $ - columns or $ + (n - 1) / columns * columns
				until tile <= n
			end
		end

		if down
			local ok = false

			if t.prevdown
				if t.verticalkeyrepeat == 1
					t.verticalkeyrepeat = p.builderspeed
					ok = true
				else
					t.verticalkeyrepeat = $ - 1
				end
			else
				t.verticalkeyrepeat = 8
				ok = true
			end

			if ok
				local columns = (SCREEN_WIDTH - 2 * BLOCK_SIZE) / (BLOCK_SIZE * 3 / 2) + 1
				tile = $ + columns <= n and $ + columns or $ - ($ - 1) / columns * columns
			end
		end

		// Choose tile
		if bt & BT_JUMP and not (t.prevbuttons & BT_JUMP)
			p.tile = themes[p.theme][tile]
			if tiletype[p.tile] == 1
				p.tiletype = tiledefaulttype[p.tile]
			end
			if p.theme ~= p.prevtheme1
				p.prevtheme2 = p.prevtheme1
				p.prevthemetile2 = p.prevthemetile1
			end
			p.prevtheme1 = p.theme
			p.prevthemetile1 = tile
			p.choosingtile = false
		end

		// Close tile choice
		if bt & BT_USE and not (t.prevbuttons & BT_USE)
			p.choosingtile = false
			tile = nil
			p.choosingtheme = true
		end

		// Switch between layers
		if bt & BT_CUSTOM1 and not (t.prevbuttons & BT_CUSTOM1)
			p.layer = $ == 1 and 2 or 1
			p.overlay = false
		end

		// Toggle overlay
		if bt & BT_CUSTOM2 and not (t.prevbuttons & BT_CUSTOM2)
			p.overlay = not $
		end

		p.themetile = tile
	elseif p.choosingtheme // Choosing tile theme
		local n = #themes
		local theme = p.theme

		if left
			local ok = false

			if t.prevleft
				if t.horizontalkeyrepeat == 1
					t.horizontalkeyrepeat = p.builderspeed
					ok = true
				else
					t.horizontalkeyrepeat = $ - 1
				end
			else
				t.horizontalkeyrepeat = 8
				ok = true
			end

			if ok
				local columns = (SCREEN_WIDTH - 2 * BLOCK_SIZE) / (BLOCK_SIZE * 3 / 2) + 1
				repeat
					theme = ($ - 1) % columns ~= 0 and $ - 1 or $ + columns - 1
				until theme <= n
			end
		end

		if right
			local ok = false

			if t.prevright
				if t.horizontalkeyrepeat == 1
					t.horizontalkeyrepeat = p.builderspeed
					ok = true
				else
					t.horizontalkeyrepeat = $ - 1
				end
			else
				t.horizontalkeyrepeat = 8
				ok = true
			end

			if ok
				local columns = (SCREEN_WIDTH - 2 * BLOCK_SIZE) / (BLOCK_SIZE * 3 / 2) + 1
				theme = $ % columns ~= 0 and $ + 1 <= n and $ + 1 or ($ - 1) / columns * columns + 1
			end
		end

		if up
			local ok = false

			if t.prevup
				if t.verticalkeyrepeat == 1
					t.verticalkeyrepeat = p.builderspeed
					ok = true
				else
					t.verticalkeyrepeat = $ - 1
				end
			else
				t.verticalkeyrepeat = 8
				ok = true
			end

			if ok
				local columns = (SCREEN_WIDTH - 2 * BLOCK_SIZE) / (BLOCK_SIZE * 3 / 2) + 1
				repeat
					theme = $ > columns and $ - columns or $ + (n - 1) / columns * columns
				until theme <= n
			end
		end

		if down
			local ok = false

			if t.prevdown
				if t.verticalkeyrepeat == 1
					t.verticalkeyrepeat = p.builderspeed
					ok = true
				else
					t.verticalkeyrepeat = $ - 1
				end
			else
				t.verticalkeyrepeat = 8
				ok = true
			end

			if ok
				local columns = (SCREEN_WIDTH - 2 * BLOCK_SIZE) / (BLOCK_SIZE * 3 / 2) + 1
				theme = $ + columns <= n and $ + columns or $ - ($ - 1) / columns * columns
			end
		end

		// Choose tile
		if bt & BT_JUMP and not (t.prevbuttons & BT_JUMP)
			p.choosingtile = true
			p.themetile = theme == p.prevtheme1 and p.prevthemetile1 or theme == p.prevtheme2 and p.prevthemetile2 or 1
			p.choosingtheme = false
		end

		// Close theme choice
		if bt & BT_USE and not (t.prevbuttons & BT_USE)
			p.choosingtheme = false
		end

		// Switch between layers
		if bt & BT_CUSTOM1 and not (t.prevbuttons & BT_CUSTOM1)
			p.layer = $ == 1 and 2 or 1
			p.overlay = false
		end

		// Toggle overlay
		if bt & BT_CUSTOM2 and not (t.prevbuttons & BT_CUSTOM2)
			p.overlay = not $
		end

		p.theme = theme
	else // Building
		if left
			if t.prevleft
				if t.horizontalkeyrepeat == 1
					t.horizontalkeyrepeat = p.builderspeed
					moveBuilder(p, -1, 0)
				else
					t.horizontalkeyrepeat = $ - 1
				end
			else
				t.horizontalkeyrepeat = 8
				moveBuilder(p, -1, 0)
			end
		end

		if right
			if t.prevright
				if t.horizontalkeyrepeat == 1
					t.horizontalkeyrepeat = p.builderspeed
					moveBuilder(p, 1, 0)
				else
					t.horizontalkeyrepeat = $ - 1
				end
			else
				t.horizontalkeyrepeat = 8
				moveBuilder(p, 1, 0)
			end
		end

		if up
			if t.prevup
				if t.verticalkeyrepeat == 1
					t.verticalkeyrepeat = p.builderspeed
					moveBuilder(p, 0, -1)
				else
					t.verticalkeyrepeat = $ - 1
				end
			else
				t.verticalkeyrepeat = 8
				moveBuilder(p, 0, -1)
			end
		end

		if down
			if t.prevdown
				if t.verticalkeyrepeat == 1
					t.verticalkeyrepeat = p.builderspeed
					moveBuilder(p, 0, 1)
				else
					t.verticalkeyrepeat = $ - 1
				end
			else
				t.verticalkeyrepeat = 8
				moveBuilder(p, 0, 1)
			end
		end

		if bt & BT_JUMP and (allowediting or owner == server or IsPlayerAdmin(owner)) and p.tile
			// Build/remove on current layer
			if p.fillx == nil
				local i = p.x + (p.y - 1) * map.w

				if not (t.prevbuttons & BT_JUMP)
					if p.overlay
						p.erase = map2[i] ~= 1
					elseif p.layer == 1
						p.erase = map1[i] ~= 1
					else
						p.erase = map2[i] ~= 1
					end
				end

				local oldtile1 = map1[i]
				local oldtile2 = map2[i]
				local oldtileinfo = tileinfo[i]

				if p.erase
					if p.erasebothlayers
						map1[i] = 1
						map2[i] = 1
						tileinfo[i] = 0
					else
						if p.layer == 2 or p.overlay
							map2[i] = 1
							tileinfo[i] = $ & ~1
						else
							map1[i] = 1
							tileinfo[i] = $ & ~240
						end
					end

					if owner and owner ~= server
					and (map1[i] ~= oldtile1 or map2[i] ~= oldtile2 or tileinfo[i] ~= oldtileinfo)
						tilehistory[tilehistoryposition] = {i, owner.name.." (player "..#owner..")", leveltime}
						tilehistoryposition = ($ % 1024) + 1
					end
				elseif p.erase == false
					if p.overlay
						map2[i] = p.tile
						tileinfo[i] = $ | 1
					elseif p.layer == 1
						if not objectsAtPosition(p.x, p.y)
							map1[i] = p.tile
							tileinfo[i] = $ & ~240 | (p.tiletype << 4)

							// !!!
							//if tiletype[p.tile] == 25 // Enemy spawner
								//checkSpawner(i, p.x, p.y)
							//end
						end
					else
						map2[i] = p.tile
						tileinfo[i] = $ & ~1 // !!!!! bug Garrean
					end

					if owner and owner ~= server
					and (map1[i] ~= oldtile1 or map2[i] ~= oldtile2 or tileinfo[i] ~= oldtileinfo)
						tilehistory[tilehistoryposition] = {i, owner.name.." (player "..#owner..")", leveltime}
						tilehistoryposition = ($ % 1024) + 1
					end
				end
			else // Fill rectangular area
				local x1, y1 = min(p.x, p.fillx), min(p.y, p.filly)
				local x2, y2 = max(p.x, p.fillx), max(p.y, p.filly)
				local area = (x2 - x1 + 1) * (y2 - y1 + 1)

				if not (t.prevbuttons & BT_JUMP) and area <= 1024
					local tile = p.tile
					local ok = true

					if p.overlay
							local d = map.w - (x2 - x1 + 1)
							local i = x1 + (y1 - 1) * map.w
							local currenttile = map2[i]
							local currentoverlay = tileinfo[i] & 1
							for y = y1, y2
								for x = x1, x2
									if map2[i] ~= currenttile
									or tileinfo[i] & 1 ~= currentoverlay
										ok = false
									end
									i = $ + 1
								end
								i = $ + d
							end

							if ok
								d = map.w - (x2 - x1 + 1)
								i = x1 + (y1 - 1) * map.w
								if p.fillremove
									for y = y1, y2
										for x = x1, x2
											map2[i] = 1
											tileinfo[i] = $ & ~1
											i = $ + 1
										end
										i = $ + d
									end
								else
									for y = y1, y2
										for x = x1, x2
											map2[i] = tile
											tileinfo[i] = $ | 1
											i = $ + 1
										end
										i = $ + d
									end
								end
							end
					elseif p.layer == 1
						if not objectsInArea(
						(x1 - 1) * BLOCK_SIZE,
						(y1 - 1) * BLOCK_SIZE,
						x2 * BLOCK_SIZE - 1,
						y2 * BLOCK_SIZE - 1)
							local d = map.w - (x2 - x1 + 1)
							local i = x1 + (y1 - 1) * map.w
							local currenttile = map1[i]
							local currenttiletype = tileinfo[i] & 240
							for y = y1, y2
								for x = x1, x2
									if map1[i] ~= currenttile
									or tileinfo[i] & 240 ~= currenttiletype
										ok = false
									end
									i = $ + 1
								end
								i = $ + d
							end

							if ok
								local t = p.tiletype

								d = map.w - (x2 - x1 + 1)
								i = x1 + (y1 - 1) * map.w
								if p.fillremove
									for y = y1, y2
										for x = x1, x2
											map1[i] = 1
											tileinfo[i] = $ & ~240
											i = $ + 1
										end
										i = $ + d
									end
								else
									for y = y1, y2
										for x = x1, x2
											map1[i] = tile
											tileinfo[i] = $ & ~240 | (t << 4)
											// !!!
											//if tiletype[p.tile] == 25 // Enemy spawner
												//checkSpawner(i, p.x, p.y)
											//end
											i = $ + 1
										end
										i = $ + d
									end
								end
							end
						end
					else
						local d = map.w - (x2 - x1 + 1)
						local i = x1 + (y1 - 1) * map.w
						local currenttile = map2[i]
						local currentoverlay = tileinfo[i] & 1
						for y = y1, y2
							for x = x1, x2
								if map2[i] ~= currenttile
								or tileinfo[i] & 1 ~= currentoverlay
									ok = false
								end
								i = $ + 1
							end
							i = $ + d
						end

						if ok
							d = map.w - (x2 - x1 + 1)
							i = x1 + (y1 - 1) * map.w
							if p.fillremove
								for y = y1, y2
									for x = x1, x2
										map2[i] = 1
										tileinfo[i] = $ & ~1
										i = $ + 1
									end
									i = $ + d
								end
							else
								for y = y1, y2
									for x = x1, x2
										map2[i] = tile
										tileinfo[i] = $ & ~1
										i = $ + 1
									end
									i = $ + d
								end
							end
						end
					end

					if ok
						p.fillremove = nil
						p.fillx, p.filly = nil, nil
					end
				end
			end
		else
			p.erase = nil
		end

		/*if bt & BT_JUMP and (allowediting or owner == server or IsPlayerAdmin(owner))
			local i = p.x + (p.y - 1) * map.w

			if not (t.prevbuttons & BT_JUMP)
				if p.layer == 1
					p.erase = map[i] & TILE1 ~= 1
				else
					p.erase = map[i] >> TILE2 ~= 1
				end
			end

			if p.erase
				if p.erasebothlayers
					map[i] = 1 | (1 << TILE2)
				else
					if p.layer == 1
						map[i] = $ & ~TILE1 | 1
					else
						map[i] = $ & ~(TILE1 << TILE2) | (1 << TILE2)
					end
				end
			elseif p.erase == false
				if p.layer == 1
					map[i] = $ & ~TILE1 | p.tile
				else
					map[i] = ($ & ~(TILE1 << TILE2)) | (p.tile << TILE2)
				end
			end
		else
			p.erase = nil
		end*/

		// Switch between layers
		if bt & BT_CUSTOM1 and not (t.prevbuttons & BT_CUSTOM1)
			p.layer = $ == 1 and 2 or 1
			p.overlay = false
		end

		// Toggle overlay
		if bt & BT_CUSTOM2 and not (t.prevbuttons & BT_CUSTOM2)
			p.overlay = not $
		end

		// Switch between block types
		if bt & BT_CUSTOM3 and not (t.prevbuttons & BT_CUSTOM3) and p.tile and tiletype[p.tile] == 1
			p.tiletype = $ ~= 2 and $ + 1 or 0
		end

		// Choose tile
		if bt & BT_USE and not (t.prevbuttons & BT_USE)
			if p.themetile
				p.choosingtile = true
			else
				p.choosingtheme = true
				if not p.theme
					p.theme = 1
				end
			end
			p.erase = nil
		end

		// Copy
		if bt & BT_ATTACK and not (t.prevbuttons & BT_ATTACK)
			local i = p.x + (p.y - 1) * map.w
			local tile = (p.layer == 2 or p.overlay) and map2[i] or map1[i]
			if tiletheme[tile] ~= 0
				p.tile = tile
				if tiletype[tile] ~= 1
					p.tiletype = 0
				elseif p.layer == 2 or p.overlay
					p.tiletype = tiledefaulttype[tile]
				else
					p.tiletype = tileinfo[i] >> 4
				end
				p.theme = tiletheme[tile]
				p.themetile = tilethemetile[tile]
			end
		end

		handleBuilderScrolling(p)
	end

	if bt & BT_TOSSFLAG and not (t.prevbuttons & BT_TOSSFLAG)
		menulib.open(owner, (owner == server or IsPlayerAdmin(owner)) and "mainhost" or "mainplayer", "maps")
	end

	if t and not owner.menu
		t.prevleft, t.prevright, t.prevup, t.prevdown = left, right, up, down
		t.prevbuttons = owner.cmd.buttons
	end
end

local function hitPlayerObject(p, po, o, dy, prevy, prevh)
	local t = objtype[o]

	if t == OBJ_PLAYER
		// Tails pickup
		if p.fly and not p.carry
			local p2 = pp[objextra[o]]

			if not p2.carried
			//and objy[po] + objh[po] / 2 < objy[o] + objh[o] / 2 // !!!
			and objy[po] + objh[po] * 2 / 3 <= objy[o]
			and P_AproxDistance(objdx[po] - objdx[o], objdy[po] - objdy[o]) <= 2 * FU
				local prevx, prevy = objx[o], objy[o]

				// Center Sonic at Tails
				objx[o] = objx[po] + objw[po] / 2 - objw[o] / 2

				// Stick Sonic at Tails' feet
				objy[o] = objy[po] + objh[po] * 2 / 3

				if playerColliding(p2)
					objx[o], objy[o] = prevx, prevy
					return
				end

				p.carry = o
				p2.carried = po

				// Stop Sonic
				objdx[o], objdy[o] = 0, 0

				setPlayerAnimation(p2, "carry")
			end
		end
	elseif t == OBJ_SPILLEDRING
		// !!!
		if p.flash <= TICRATE * 3 / 4 * 3 or p.flash > 3 * TICRATE
			p.rings = min($ + 1, 9999)
			startSound(sfx_itemup, p)
			removeObject(o)
		end
	elseif t == OBJ_BLUECRAWLA or t == OBJ_REDCRAWLA
	or t == OBJ_GOLDBUZZ or t == OBJ_REDBUZZ
	or t == OBJ_ROBOFISH
		if (p.jump and (not skininfo[p.skin].bounce or p.bouncemode))
		or p.spin or p.spindash ~= false or p.glide or p.invincibility
			if objdy[po] > GRAVITY
				objdy[po] = -$
			end
			removeObject(o)
			startSound(sfx_pop, p)
		elseif not p.flash
			damagePlayer(p)
		end
	elseif t == OBJ_GREENSPRINGSHELL or t == OBJ_YELLOWSPRINGSHELL
		if prevy ~= nil and prevy + prevh <= objy[o]
			objy[po] = objy[o] - objh[po]
			springPlayer(p, nil, t == OBJ_GREENSPRINGSHELL and 4 * FU or 6 * FU)
			setObjectAnimation(o, 2)
		elseif (p.jump and (not skininfo[p.skin].bounce or p.bouncemode))
		or p.spin or p.spindash ~= false or p.glide or p.invincibility
			if objdy[po] > GRAVITY
				objdy[po] = -$
			end
			removeObject(o)
			startSound(sfx_pop, p)
		elseif not p.flash
			damagePlayer(p)
		end
	elseif t == OBJ_GREENSNAPPER
		if dy
			if (p.jump and (not skininfo[p.skin].bounce or p.bouncemode))
			or p.spin or p.spindash ~= false or p.glide or p.invincibility
				if objdy[po] > GRAVITY
					objdy[po] = -$
				end
				removeObject(o)
				startSound(sfx_pop, p)
			elseif not p.flash
				damagePlayer(p)
			end
		elseif not (p.flash or p.invincibility)
			damagePlayer(p)
		elseif (p.jump and (not skininfo[p.skin].bounce or p.bouncemode))
		or p.spin or p.spindash ~= false or p.glide or p.invincibility
			if objdy[po] > GRAVITY
				objdy[po] = -$
			end
			removeObject(o)
			startSound(sfx_pop, p)
		end
	elseif t == OBJ_SHARP
		if dy and prevy ~= nil and prevy + prevh <= objy[o]
			if not (p.flash or p.invincibility)
				damagePlayer(p)
			elseif (p.jump and (not skininfo[p.skin].bounce or p.bouncemode))
			or p.spin or p.spindash ~= false or p.glide or p.invincibility
				if objdy[po] > GRAVITY
					objdy[po] = -$
				end
				removeObject(o)
				startSound(sfx_pop, p)
			end
		elseif (p.jump and (not skininfo[p.skin].bounce or p.bouncemode))
		or p.spin or p.spindash ~= false or p.glide or p.invincibility
			if objdy[po] > GRAVITY
				objdy[po] = -$
			end
			removeObject(o)
			startSound(sfx_pop, p)
		elseif not p.flash
			damagePlayer(p)
		end
	end
end

local function checkObjectCollisions(o, dy, prevy, prevh)
	local objx, objy = objx, objy
	local objw, objh = objw, objh
	local objdx, objdy = objdx, objdy

	local t = objtype[o]
	local p
	if t == 1
		p = pp[objextra[o]]
	end

	local bx, by = objx[o] / BLOCKMAP_SIZE, objy[o] / BLOCKMAP_SIZE
	local bx1, by1 = bx - 1, by - 1
	local bx2, by2 = bx + 1, by + 1

	if bx1 < 0
		bx1 = 0
	end
	if by1 < 0
		by1 = 0
	end
	if bx2 >= blockmapw
		bx2 = blockmapw - 1
	end
	if by2 >= blockmaph
		by2 = blockmaph - 1
	end

	// !!!
	for by = by1, by2
		for bx = bx1, bx2
			local block = blockmap[bx + by * blockmapw + 1]
			for i = 1, #block
				local o2 = block[i]
				if not o2 continue end // Object removed

				local x = objx[o]
				local x2 = objx[o2]

				if x + objw[o] > x2
				and x < x2 + objw[o2]
				and objy[o] + objh[o] > objy[o2]
				and objy[o] < objy[o2] + objh[o2]
					if p // !!!
						hitPlayerObject(p, o, o2, dy, prevy, prevh)
						if not objtype[o] return end // Object removed
					elseif objtype[o2] == OBJ_PLAYER // !!!
						hitPlayerObject(pp[objextra[o2]], o2, o, dy, prevy, prevh)
						if not objtype[o] return end // Object removed
					end
				end
			end
		end
	end
end

local function moveObjectHorizontally(o, dx)
	local t = objtype[o]

	local p
	local prevx
	local prevw
	if t == 1
		p = pp[objextra[o]]
		prevx = objx[o]
		prevw = objw[o]
	end

	objx[o] = $ + dx

	if objx[o] < 0
		objx[o] = 0
		objdx[o] = 0
		if not p
			objdir[o] = 2
		end
		return
	elseif objx[o] > map.w * BLOCK_SIZE - objw[o]
		objx[o] = map.w * BLOCK_SIZE - objw[o]
		objdx[o] = 0
		if not p
			objdir[o] = 1
		end
		return
	end

	for x = objx[o] / BLOCK_SIZE + 1, (objx[o] + objw[o] - 1) / BLOCK_SIZE + 1
		for y = objy[o] / BLOCK_SIZE + 1, min((objy[o] + objh[o] - 1) / BLOCK_SIZE + 1, map.h)
			local i = x + (y - 1) * map.w
			local tile = tiletype[map1[i]]
			if tile == 1
				if tileinfo[i] >> 4 == 1 // Solid
					if dx < 0
						objx[o] = x * BLOCK_SIZE
					else
						objx[o] = (x - 1) * BLOCK_SIZE - objw[o]
					end
					hitObjectWall(o)
					return
				end
				continue
			elseif tile == 6 or tile == 7 // Spikes // !!! Spikes are shitty
			or tile == 23 // Ice
				if dx < 0
					objx[o] = x * BLOCK_SIZE
				else
					objx[o] = (x - 1) * BLOCK_SIZE - objw[o]
				end
				hitObjectWall(o)
				return
			elseif tile == 12 // Monitor // !!! Monitors too =p
				if p and ((p.jump and (not skininfo[p.skin].bounce or p.bouncemode))
				or p.spin or p.glide)
					playerBreakMonitor(p, i)
					if not objtype[o] return true end // Object removed
				elseif dx < 0
					objx[o] = x * BLOCK_SIZE
					hitObjectWall(o)
					return
				else
					objx[o] = (x - 1) * BLOCK_SIZE - objw[o]
					hitObjectWall(o)
					return
				end
			end
		end
	end

	checkObjectCollisions(o)
	if not objtype[o] return true end // Object removed

	/*for _, b in ipairs(tt.builders)
		for i = 1, #shapes[b.shape]
			local x, y = (getBlockX(b, i) - 1) * BLOCK_SIZE, (getBlockY(b, i) - 1) * BLOCK_SIZE

			if objx[o] < x + BLOCK_SIZE and objx[o] + objw[o] > x and objy[o] < y + BLOCK_SIZE and objy[o] + objh[o] > y
				if dx < 0
					objx[o] = x + BLOCK_SIZE
					hitPlayerWall(p)
				else
					objx[o] = x - objw[o]
					hitPlayerWall(p)
				end
				return
			end
		end
	end*/

	// Object spawn
	if p
		if dx < 0
			local x = (objx[o] - MAX_OBJECT_DIST) / BLOCK_SIZE + 1
			if x >= 1 and x < (prevx - MAX_OBJECT_DIST) / BLOCK_SIZE + 1
				checkSpawnersInColumn(x,
					(objy[o] - MAX_OBJECT_DIST) / BLOCK_SIZE + 1,
					(objy[o] + objh[o] - 1 + MAX_OBJECT_DIST) / BLOCK_SIZE + 1)
			end
		else
			local x = (objx[o] + objw[o] - 1 + MAX_OBJECT_DIST) / BLOCK_SIZE + 1
			if x <= map.w and x > (prevx + prevw - 1 + MAX_OBJECT_DIST) / BLOCK_SIZE + 1
				checkSpawnersInColumn(x,
					(objy[o] - MAX_OBJECT_DIST) / BLOCK_SIZE + 1,
					(objy[o] + objh[o] - 1 + MAX_OBJECT_DIST) / BLOCK_SIZE + 1)
			end
		end
	end
end

local function moveObjectVertically(o, dy)
	local t = objtype[o]

	local prevy = objy[o]
	local prevh = objh[o]

	local p
	if t == OBJ_PLAYER
		p = pp[objextra[o]]
	end

	objy[o] = $ + dy

	if objy[o] < 0
		objy[o] = 0
		objdy[o] = 0
		return
	end

	for x = objx[o] / BLOCK_SIZE + 1, (objx[o] + objw[o] - 1) / BLOCK_SIZE + 1
		for y = objy[o] / BLOCK_SIZE + 1, (objy[o] + objh[o] - 1) / BLOCK_SIZE + 1
			local i = x + (y - 1) * map.w
			local tile = tiletype[map1[i]]
			if tile == 1 // Decoration, solid or platform
				local info = tileinfo[i] >> 4
				if info == 1 // Solid
					if dy < 0
						objy[o] = y * BLOCK_SIZE
						hitObjectCeiling(o)
					else
						objy[o] = (y - 1) * BLOCK_SIZE - objh[o]
						landObject(o)
					end
					return
				elseif info == 2 and dy > 0
				and prevy + prevh <= (y - 1) * BLOCK_SIZE // Platform
				and t ~= OBJ_ROBOFISH // !!!
					objy[o] = (y - 1) * BLOCK_SIZE - objh[o]
					landObject(o)
					return
				end
				continue
			elseif tile == 23 // Ice
				if dy < 0
					objy[o] = y * BLOCK_SIZE
					hitObjectCeiling(o)
				else
					objy[o] = (y - 1) * BLOCK_SIZE - objh[o]
					landObject(o)
				end
				return
			elseif tile == 24 // Ice platform
				if dy > 0 and objy[o] + objh[o] - dy <= (y - 1) * BLOCK_SIZE
					objy[o] = (y - 1) * BLOCK_SIZE - objh[o]
					landObject(o)
					return
				end
			// !!!
			// Spikes are shitty
			elseif tile == 6 // Floor damages
				if dy < 0
					objy[o] = y * BLOCK_SIZE
					hitObjectCeiling(o)
				else
					objy[o] = (y - 1) * BLOCK_SIZE - objh[o]
					if p
						if p.flash or p.invincibility or p.bouncemode
							landObject(o)
						else
							damagePlayer(p, "spikes")
							if not objtype[o] return true end // Object removed
						end
					else
						landObject(o)
					end
				end
				return
			elseif tile == 7 // Ceiling damages
				if dy > 0
					objy[o] = (y - 1) * BLOCK_SIZE - objh[o]
					landObject(o)
				else
					objy[o] = y * BLOCK_SIZE
					if p
						if p.flash or p.invincibility or p.bouncemode
							landObject(o)
						else
							damagePlayer(p, "spikes")
							if not objtype[o] return true end // Object removed
						end
					else
						landObject(o)
					end
				end
				return
			elseif tile == 8 // Bouncing platform
				if dy > 0 and objy[o] + objh[o] - dy <= (y - 1) * BLOCK_SIZE
					objy[o] = (y - 1) * BLOCK_SIZE - objh[o]
					objdy[o] = min(-$, -3 * FU)
					if p
						if p.spin and abs(objdx[o]) < FU / 2
							unspinPlayer(p)
						end
						startSound(sfx_bnce2, p) // !!! Sound for objects too?
					end
				end
			elseif tile == 12 // Monitor // !!! Monitors are shitty, too...
				if p and ((p.jump and (not skininfo[p.skin].bounce or p.bouncemode))
				or p.spin or p.spindash ~= false or p.glide)
					playerBreakMonitor(p, i)
					if not objtype[o] return true end // Object removed
				elseif dy < 0
					objy[o] = y * BLOCK_SIZE
					hitObjectCeiling(o)
					return
				else
					objy[o] = (y - 1) * BLOCK_SIZE - objh[o]
					landObject(o)
					return
				end
			end
		end
	end

	checkObjectCollisions(o, dy, prevy, prevh)
	if not objtype[o] return true end // Object removed

	/*for _, b in ipairs(tt.builders)
		for i = 1, #shapes[b.shape]
			local x, y = (getBlockX(b, i) - 1) * BLOCK_SIZE, (getBlockY(b, i) - 1) * BLOCK_SIZE

			if objx[o] < x + BLOCK_SIZE and objx[o] + objw[o] > x and objy[o] < y + BLOCK_SIZE and objy[o] + objh[o] > y
				if dy < 0
					objy[o] = y + BLOCK_SIZE
					objdy[o] = 0
				else
					objy[o] = y - objh[o]
					landPlayer(p)
				end
				return
			end
		end
	end*/

	// Death pit
	if objy[o] + objh[o] > map.h * BLOCK_SIZE
		objy[o] = map.h * BLOCK_SIZE - objh[o]
		if p
			if mapheaderinfo[gamemap].kawaiii_mapbuilder == "auto"
				removeObjectFromBlockmap(o)
				objblockmap[o] = false

				local x, y, dir = getSpawnPoint(p)
				objx[o] = x - objw[o] / 2
				objy[o] = y
				objdir[o] = dir
				objdx[o], objdy[o] = 0, 0

				objblockmap[o] = true
				insertObjectInBlockmap(o)

				centerCamera(p)

				startSound(sfx_mixup, p)
			else
				killPlayer(p)
			end
		else
			removeObject(o)
		end
		return true
	end

	// Object spawn
	if p
		if dy < 0
			local y = (objy[o] - MAX_OBJECT_DIST) / BLOCK_SIZE + 1
			if y >= 1 and y < (prevy - MAX_OBJECT_DIST) / BLOCK_SIZE + 1
				checkSpawnersInLine(y,
					(objx[o] - MAX_OBJECT_DIST) / BLOCK_SIZE + 1,
					(objx[o] + objw[o] - 1 + MAX_OBJECT_DIST) / BLOCK_SIZE + 1)
			end
		else
			local y = (objy[o] + objh[o] - 1 + MAX_OBJECT_DIST) / BLOCK_SIZE + 1
			if y <= map.h and y > (prevy + prevh - 1 + MAX_OBJECT_DIST) / BLOCK_SIZE + 1
				checkSpawnersInLine(y,
					(objx[o] - MAX_OBJECT_DIST) / BLOCK_SIZE + 1,
					(objx[o] + objw[o] - 1 + MAX_OBJECT_DIST) / BLOCK_SIZE + 1)
			end
		end
	end
end

// !!!!
// ...
local function handleObjects()
	local objtype = objtype
	//local objx, objy = objx, objy
	//local objw, objh = objw, objh
	local objdx, objdy = objdx, objdy
	local objdir = objdir
	//local objanim = objanim
	//local objspr = objspr
	local objextra = objextra
	// ...

	for o = 1, #objtype
		local t = objtype[o]
		if not t continue end

		// !!!
		if t == OBJ_PLAYER
			local p = pp[objextra[o]]

			local prevx, prevy = objx[o], objy[o]

			if not p.carried
				removeObjectFromBlockmap(o)
				objblockmap[o] = false

				local dx = objdx[o]
				if dx and moveObjectHorizontally(o, dx) continue end

				local dy = objdy[o]
				if dy and moveObjectVertically(o, dy) continue end

				objblockmap[o] = true
				insertObjectInBlockmap(o)
			end

			local o2 = p.carry
			if o2
				removeObjectFromBlockmap(o2)
				objblockmap[o2] = false

				local dx = objx[o] - prevx
				local newx = objx[o2] + dx
				if dx and moveObjectHorizontally(o2, dx) continue end

				local dy = objy[o] - prevy
				local newy = objy[o2] + dy
				if dy and moveObjectVertically(o2, dy) continue end

				objblockmap[o2] = true
				insertObjectInBlockmap(o2)

				if not (objx[o2] == newx and objy[o2] == newy)
					p.carry = nil
					pp[objextra[o2]].carried = nil
				end
			end

			// Friction
			// !!!
			/*if tt.flood ~= nil and (theme.flood == 1 or theme.flood == 2) and objy[o] + objh[o] * 5 / 6 > tt.flood
				if objdx[o] < 0
					objdx[o] = min($ + FU / 6, 0)
				elseif objdx[o] > 0
					objdx[o] = max($ - FU / 6, 0)
				end
			else*/if playerOnGround(p)
				if playerOnIce(p)
					if not p.spin
						local objdx = objdx
						if objdx[o] < 0
							objdx[o] = min($ + FU / 64, 0)
						elseif objdx[o] > 0
							objdx[o] = max($ - FU / 64, 0)
						end
					end
				elseif p.spin
					if objdx[o] < 0
						objdx[o] = min($ + FU / 16, 0)
					elseif objdx[o] > 0
						objdx[o] = max($ - FU / 16, 0)
					end
				else
					if objdx[o] < 0
						objdx[o] = min($ + FU / 8, 0)
					elseif objdx[o] > 0
						objdx[o] = max($ - FU / 8, 0)
					end
				end

				// Stop spinning if the player is too slow
				if p.spin and abs(objdx[o]) < FU / 4
					unspinPlayer(p)
				end
			end

			if p.fly ~= nil
				// Flight gravity
				if p.fly ~= nil
					if p.fly ~= 0
						p.fly = $ - 1
						if p.fly == 0
							setPlayerAnimation(p, "tired")
						end
					end
				end

				objdy[o] = min($ + GRAVITY / 8, 6 * FU)
			elseif p.glide and objdy[o] >= 0
				// Glide gravity
				if objdy[o] < GRAVITY / 4
					objdy[o] = GRAVITY / 4
				elseif objdy[o] > GRAVITY / 4
					objdy[o] = max($ - GRAVITY / 2, GRAVITY / 4)
				end
			elseif not (p.climb or p.carried)
				// Regular gravity
				objdy[o] = min($ + GRAVITY, 6 * FU)
			end
		elseif t == OBJ_BLUECRAWLA or t == OBJ_REDCRAWLA
		or t == OBJ_GREENSPRINGSHELL or t == OBJ_YELLOWSPRINGSHELL
		or t == OBJ_GREENSNAPPER
		or t == OBJ_SHARP
			removeObjectFromBlockmap(o)
			objblockmap[o] = false

			local speed =
				t == OBJ_BLUECRAWLA and FU / 4
				or t == OBJ_REDCRAWLA and FU / 2
				or t == OBJ_GREENSPRINGSHELL and FU / 2
				or t == OBJ_YELLOWSPRINGSHELL and FU / 2
				or t == OBJ_GREENSNAPPER and FU / 4
				or t == OBJ_SHARP and FU / 4
			local dir = objdir[o] == 1 and -1 or 1
			if moveObjectHorizontally(o, speed * dir) continue end

			objblockmap[o] = true
			insertObjectInBlockmap(o)

			if (t == OBJ_GREENSPRINGSHELL or t == OBJ_YELLOWSPRINGSHELL) and objanim[o] == 2
				local a = objinfo[t].anim[2]
				if objspr[o] == (#a + 1) * a.spd - 1 // Last frame
					setObjectAnimation(o, 1)
				end
			end

			// Check ground borders
			if (objy[o] + objh[o]) % BLOCK_SIZE == 0 // Feet exactly on tile bottom
			and objy[o] < map.h * BLOCK_SIZE - objh[o] // Feet not at bottom of the map
				local x = (objx[o] + objw[o] / 2) / BLOCK_SIZE
				local y = (objy[o] + objh[o]) / BLOCK_SIZE

				local i = x + y * map.w + 1
				local tile = map1[i]
				if not tileground[tile]
					local t = tiletype[tile]
					if t == 1 and tileinfo[i] >> 4 == 0
						objdir[o] = $ == 1 and 2 or 1
					end
				end
			end
		elseif t == OBJ_GOLDBUZZ or t == OBJ_REDBUZZ
			removeObjectFromBlockmap(o)
			objblockmap[o] = false

			local dx = objdx[o]
			if dx and moveObjectHorizontally(o, dx) continue end

			local dy = objdy[o]
			if dy and moveObjectVertically(o, dy) continue end

			objblockmap[o] = true
			insertObjectInBlockmap(o)

			// Chase target
			local speed = t == OBJ_GOLDBUZZ and FU or FU * 2
			local target = objextra[o]
			local dist = max(P_AproxDistance(objx[target] - objx[o], objy[target] - objy[o]), 1)
			objdx[o] = FixedMul(FixedDiv(objx[target] - objx[o], dist), speed)
			objdy[o] = FixedMul(FixedDiv(objy[target] - objy[o], dist), speed)
			objdir[o] = objdx[o] < 0 and 1 or 2
		elseif t == OBJ_ROBOFISH // !!!
			removeObjectFromBlockmap(o)
			objblockmap[o] = false

			local dx = objdx[o]
			if dx and moveObjectHorizontally(o, dx) continue end

			local dy = objdy[o]
			if dy and moveObjectVertically(o, dy) continue end

			objblockmap[o] = true
			insertObjectInBlockmap(o)

			objdy[o] = min($ + GRAVITY, 6 * FU) // Gravity

			if objdy[o] < 0
				if objanim[o] ~= 1
					setObjectAnimation(o, 1)
				end
			else
				if objanim[o] ~= 2
					setObjectAnimation(o, 2)
				end

				if objdy[o] > 5 * FU
					objdy[o] = -5 * FU
				end
			end
		elseif t == OBJ_SPILLEDRING
			removeObjectFromBlockmap(o)
			objblockmap[o] = true

			local dx = objdx[o]
			if dx and moveObjectHorizontally(o, dx) continue end

			local dy = objdy[o]
			if dy and moveObjectVertically(o, dy) continue end

			objblockmap[o] = true
			insertObjectInBlockmap(o)

			objdy[o] = min($ + GRAVITY, 6 * FU) // Gravity

			// Disappear after some time
			if objextra[o] > 1
				objextra[o] = $ - 1
			else
				removeObject(o)
				continue // Object removed
			end
		elseif t == OBJ_THOK
			// Disappear after some time
			if objextra[o] > 1
				objextra[o] = $ - 1
			else
				removeObject(o)
				continue // Object removed
			end
		else
			print("Unknown object type "..t.."!") // !!!
		end

		loopObjectAnimation(o)
	end
end

local function handleGame()
	// Look for mid-game joiners
	if not cpulib and mapheaderinfo[gamemap].kawaiii_mapbuilder
		for p in players.iterate
			if not p.maps
				joinGame(p)
			end
		end
	end

	// !!!
	// Placeholder to handle player leaves
	// Or maybe it's just the normal code...
	for i = #pp, 1, -1
		local p = pp[i]
		local owner = p.owner ~= nil and players[p.owner] or nil
		if not (owner and owner.maps) // kawaiii
		or owner.maps.player ~= i // !!! Check for this in joinGame?
			leaveGame(i)
		end
	end
	/*repeat
		local done = true

		for i = 1, #pp
			local p = pp[i]
			local owner = p.owner ~= nil and players[p.owner] or nil
			if not owner
			or owner.maps.player ~= i // !!! Check for this in joinGame?
				local o = p.obj
				if o
					removeObject(o)
				end
				table.remove(pp, i)
				for p in players.iterate
					if p.maps.player > i
						p.maps.player = $ - 1
					end
				end
				for i2, p in ipairs(pp)
					if p.obj
						objextra[p.obj] = i2
					end
				end
				done = false
				break
			end
		end
	until done*/

	if cpulib
		for i = 1, #app.users
			local p = app.users[i]

			// Handle menu
			if p.menu
				menulib.handle(p, "maps")

				// If the menu just closed
				if not p.menu
					p.maps.prevbuttons = $ | BT_JUMP | BT_USE | BT_TOSSFLAG
				end
			end
		end
	else
		for p in players.iterate
			// Handle menu
			if p.menu
				menulib.handle(p, "maps")

				// If the menu just closed
				if not p.menu and p.maps
					p.maps.prevbuttons = $ | BT_JUMP | BT_USE | BT_TOSSFLAG
				end
			end
		end
	end

	// Handle players
	for i = 1, #pp
		local p = pp[i]
		if p.builder
			handleBuilder(p)
		else
			handlePlayer(p, i)
		end
	end

	if fakebuilder and leveltime > TICRATE * 5 / 4
		if fakebuilder.speed > 0
			for _ = 1, fakebuilder.speed
				if fakebuilder.input < #modmaps.builderinputs[fakebuilder.map]
					handleFakeBuilder()
				end
			end
		elseif not (leveltime % -fakebuilder.speed)
			if fakebuilder.input < #modmaps.builderinputs[fakebuilder.map]
				handleFakeBuilder()
			end
		end
	end

	handleObjects()

	// Handle the map ticker
	if multiplayer or not fakebuilder
		local n = #map1
		for i = 1, maptickerspeed
			local tile = tiletype[map1[mapticker]]

			if tile == 13 or tile == 14 // Got ring or monitor // !!!
				map1[mapticker] = tiletag[$]
			elseif tile == 18 // Star post // !!!
				local t = map1[mapticker]
				if tiletag[t] < t
					map1[mapticker] = tiletag[$]
				end
			end

			mapticker = $ % n + 1
		end
	end

	// Handle object despawning
	if objectticker > #objtype
		objectticker = 1
	end
	if objectticker <= #objtype and objtype[objectticker] and objtype[objectticker] ~= 1
		local objx, objy = objx, objy
		local objw, objh = objw, objh
		local x1, y1 = objx[objectticker] - MAX_OBJECT_DIST, objy[objectticker] - MAX_OBJECT_DIST
		local x2, y2 = objx[objectticker] + objw[objectticker] + MAX_OBJECT_DIST, objy[objectticker] + objh[objectticker] + MAX_OBJECT_DIST

		local unused = true
		for i = 1, #pp
			local p = pp[i]
			if p.builder continue end

			local px, py
			local pw, ph
			if p.dead
				px, py = p.x, p.y
				pw, ph = PLAYER_WIDTH, PLAYER_HEIGHT
			else
				local o = p.obj
				px, py = objx[o], objy[o]
				pw, ph = objw[o], objh[o]
			end

			if px + pw > x1
			and px < x2
			and py + ph > y1
			and py < y2
				unused = false
				break
			end
		end

		if unused
			removeObject(objectticker)
		end
	end
	objectticker = $ + 1
	if objectticker > #objtype
		objectticker = 1
	end

	/*if tt.flood ~= nil
		tt.flood = $ - tt.floodspeed
	end*/
end

/*local function handleGameOver()
	/*local bt, prevbt = pp.cmd.buttons, tt.prevbuttons

	if tt.players
		for _, p in ipairs(tt.players)
			if p.dy <= 0 or p.y < map.h * BLOCK_SIZE + BORDERS_SIZE
				p.y = $ + p.dy
				p.dy = min($ + FU / 8, 6 * FU)
				loopPlayerAnimation(p)
			end
		end
	end

	if tt.flood ~= nil and tt.flood > 0
		tt.flood = $ - tt.floodspeed
	end

	if not tt.menu and (bt & BT_JUMP and not (prevbt & BT_JUMP) or bt & BT_ATTACK and not (prevbt & BT_ATTACK) or bt & BT_CUSTOM1 and not (prevbt & BT_CUSTOM1))
		startTetris(pp)
	end
end*/


if not cpulib
	addHook("ThinkFrame", function()
		// kawaiii
		if not gameinitialised
			if mapheaderinfo[gamemap].kawaiii_mapbuilder
				initialiseGame()
			else
				return
			end
		end

		if compressedgamestate
			decompressGamestate()
		end

		if mapchanged
			mapchanged = false
			startGame()
		end

		handleGame()

		if not mapheaderinfo[gamemap].kawaiii_mapbuilder
		and #pp == 0 // No players remaining
			uninitialiseGame()
		end

		/*for p in players.iterate
			pp, tt = p, p.tetris

			if not tt
				loadTetris()

				for host in players.iterate
					if host.tetris and host.tetris.host == #host and host.tetris.mode == 3
						joinTetris(pp, host, true)
						if tt.host ~= nil break end
					end
				end

				if tt.host == nil
					tt.mode = 1
					startTetris(pp)
				end
			end

			if tt.menu
				handleMenu()
			elseif pp.cmd.buttons & BT_TOSSFLAG and not (tt.prevbuttons & BT_TOSSFLAG) and (#pp == tt.host or pp == server or IsPlayerAdmin(pp))
				tt.menu = {}
				tt.menu[1] = {}
				tt.menu[1].id = (pp == server or IsPlayerAdmin(pp)) and "mainhost" or #pp == tt.host and "mainplayer" or "mainguest"
				tt.menu[1].choice = 1
			end

			if tt.host == #pp
				if tt.mode == 3 or not tt.menu
					handleTetris()
				end
			elseif tt.host ~= nil and not players[tt.host]
				tt.mode = 1
				startTetris(pp)
				tt.menu = nil
			end
		end*/
	end)
end


addHook("MapChange", function()
	// kawaiii
	if gameinitialised
		uninitialiseGame()
	end

	enableHUD()
end)

addHook("NetVars", function(n)
	mapchanged = n($)

	allowmusicpreview = n($)
	allowediting = n($)
	renderscale = n($)

	gameinitialised = n($)
	if not gameinitialised return end

	mapticker = n($)
	maptickerspeed = n($)
	objectticker = n($)

	pp = n($)

	objtype = n($)
	objx = n($)
	objy = n($)
	objw = n($)
	objh = n($)
	objdx = n($)
	objdy = n($)
	objdir = n($)
	objanim = n($)
	objspr = n($)
	objspawn = n($)
	objcolor = n($)
	objblockmap = n($) // !!!
	objextra = n($)
	// !!!!
	// ...

	fakebuilder = n($)

	if map
		compressGamestate()
	end
	compressedgamestate = n($)
end)


addHook("JumpSpecial", function(p)
	if gameinitialised and p.maps return true end // kawaiii
end)

addHook("SpinSpecial", function(p)
	if gameinitialised and p.maps return true end // kawaiii
end)

// kawaiii
addHook("LinedefExecute", function(_, mo)
	local p = mo.player
	if not p return end

	if not gameinitialised
		initialiseGame()
	end

	if not p.maps
		joinGame(p)
	end
end, "AUTOMAPBUILDER")


// Commands

function modmaps.addCommand(name, func, perm)
	COM_AddCommand(name, function(p, ...)
		if compressedgamestate
			decompressGamestate()
		end

		// kawaiii
		if name ~= "suicide" and fakebuilder
			CONS_Printf(p, "You can't use this here!")
			return
		end

		func(p, ...)
	end, perm or 0)
end

local function stringToPlayer(s)
	if not s return nil end

	if tonumber(s) == nil
		s = s:lower()
		for p in players.iterate
			if s == p.name:lower() return p end
		end
	else
		local p = players[tonumber(s)]
		if p and p.valid return p end
	end
end

modmaps.addCommand("suicide", function(p)
	if p.maps
		local owner = p
		p = owner and owner.maps and pp[owner.maps.player]
		if not p or p.dead
			return
		elseif p.builder
			CONS_Printf(owner, "You can't suicide while building!")
			return
		end
		killPlayer(p)
		return
	elseif not G_PlatformGametype()
		CONS_Printf(p, "You may only use this in co-op, race, and competition!")
		return
	elseif not netgame and not multiplayer
		CONS_Printf(p, "You can't use this in Single Player! Use \"retry\" instead.")
		return
	elseif not (p and p.mo and p.mo.valid)
		return
	end

	P_DamageMobj(p.mo, nil, nil, 10000)
end)

modmaps.addCommand("tp", function(owner, dst)
	if not dst
		CONS_Printf(owner, "tp <player name/num>: teleport yourself to another builder")
		CONS_Printf(owner, "tp back: teleport yourself back to the location you were before teleporting")
		return
	end

	local p = owner and owner.maps and pp[owner.maps.player]
	if not p
		return
	elseif not p.builder
		CONS_Printf(owner, "You need to be in building mode to use this command.")
		return
	end

	if dst == "back"
		if p.tpx ~= nil
			p.x, p.y = p.tpx, p.tpy
			p.tpx, p.tpy = nil, nil
		end
	else
		dst = stringToPlayer($)
		if not dst
			CONS_Printf(owner, "Player not found.")
			return
		end

		dst = dst.maps and pp[dst.maps.player]
		if not dst
			CONS_Printf(owner, "This player is not in game.")
			return
		elseif not dst.builder
			CONS_Printf(owner, "This player is not in building mode.")
			return
		end

		p.tpx, p.tpy = p.x, p.y
		p.x, p.y = dst.x, dst.y
	end
end)

modmaps.addCommand("showlayer", function(owner, layer)
	local p = owner and owner.maps and pp[owner.maps.player]
	if not p
		return
	end

	if not layer
		CONS_Printf(owner, "showlayer <layer>: chooses the layers displayed when editing")
		CONS_Printf(owner, "Valid options: all, selected/current, active, background/back, overlay/front")
		return
	end

	if layer == "all" or layer == "0"
		p.visiblelayer = nil
	elseif layer == "selected" or layer == "current" or layer == "1"
		p.visiblelayer = 1
	elseif layer == "active" or layer == "2"
		p.visiblelayer = 2
	elseif layer == "background" or layer == "back" or layer == "3"
		p.visiblelayer = 3
	elseif layer == "overlay" or layer == "front" or layer == "4"
		p.visiblelayer = 4
	end
end)

modmaps.addCommand("rect", function(owner, remove)
	local p = owner and owner.maps and pp[owner.maps.player]
	if not p
		return
	elseif not p.builder
		CONS_Printf(owner, "You need to be in building mode to use this command.")
		return
	end

	if remove == "remove"
	or remove == "delete"
	or remove == "rm"
		p.fillremove = true
	end
	p.fillx, p.filly = p.x, p.y
end, 1)

modmaps.addCommand("pos", function(owner)
	local p = owner and owner.maps and pp[owner.maps.player]
	if not p
		return
	elseif not p.builder
		CONS_Printf(owner, "You need to be in building mode to use this command.")
		return
	end

	CONS_Printf(owner, p.x..", "..p.y)
end)

modmaps.addCommand("helpmaps", function(p)
	if not p.maps
		return
	end

	if p.menu
		menulib.close(p)
	end
	menulib.open(p, "help1", "maps")
end)

modmaps.addCommand("mapshelp", function(p)
	if not p.maps
		return
	end

	if p.menu
		menulib.close(p)
	end
	menulib.open(p, "help1", "maps")
end)

modmaps.addCommand("allowediting", function(p, on)
	if not on
		CONS_Printf(p, "Level editing is "..(allowediting and "en" or "dis").."abled.")
		return
	elseif not (p == server or IsPlayerAdmin(p))
		CONS_Printf(p, "Only the server or a remote admin can use this.")
		return
	end

	on = on:lower()
	if on == "on" or on == "yes" or on == "1"
		if not allowediting
			allowediting = true
			print("Level editing was enabled.")
		end
	elseif on == "off" or on == "no" or on == "0"
		if allowediting
			allowediting = false
			print("Level editing was disabled.")
		end
	elseif on == "toggle"
		if allowediting
			allowediting = false
			print("Level editing was disabled.")
		else
			allowediting = true
			print("Level editing was enabled.")
		end
	else
		CONS_Printf(p, "allowediting <On/Off>: allows players to edit the level")
	end
end)

modmaps.addCommand("music", function(p, music)
	if not music
		CONS_Printf(p, "music <slot>: sets the level music")
		return
	end

	map.music = music
	/*map.music = _G["mus_"..music:lower()]
	if not map.music
		CONS_Printf(p, "This music doesn't exist!")
	end*/
end, 1)

modmaps.addCommand("tileowner", function(owner)
	if not p.maps
		CONS_Printf(owner, "You can't use this here!")
		return
	end
	local p = owner and owner.maps and pp[owner.maps.player]
	if not p
		return
	elseif not p.builder
		CONS_Printf(owner, "You need to be in building mode to use this command.")
		return
	end

	local latestinfo
	local latesttime = 0
	local i = p.x + (p.y - 1) * map.w
	for _, info in ipairs(tilehistory)
		if info[1] == i and info[3] >= latesttime
			latestinfo, latesttime = info, info[3]
		end
	end

	if latestinfo
		CONS_Printf(owner, latestinfo[2].." "..(leveltime - latesttime) / TICRATE.." seconds ago")
	else
		CONS_Printf(owner, "Tile owner unknown")
	end
end, 1)




// Rendering functions

local function drawBox(v, x1, y1, x2, y2, p)
	local s1 = (y2 - y1) / p.height
	local s2 = (x2 - x1) / p.width

	if s2 > s1
		y1 = $ + p.topoffset * s1
		x2 = $ - p.width * s1 + FU + p.leftoffset * s1
		for x = x1 + p.leftoffset * s1, x2, p.width * s1
			v.drawScaled(x, y1, s1, p)
		end
		v.drawScaled(x2, y1, s1, p)
	else
		x1 = $ + p.leftoffset * s2
		y2 = $ - p.height * s2 + FU + p.topoffset * s2
		for y = y1 + p.topoffset * s2, y2, p.height * s2
			v.drawScaled(x1, y, s2, p)
		end
		v.drawScaled(x1, y2, s2, p)
	end
end

local function drawBlocksBox(v, x1, y1, x2, y2, size, p)
	local s = size / p.width

	for x = x1, x2 - size - size + FU, size
		v.drawScaled(x, y1, s, p)
	end

	local x = x2 - size + FU
	for y = y1, y2 - size - size + FU, size
		v.drawScaled(x, y, s, p)
	end

	local y = y2 - size + FU
	for x = x1 + size, x2 - size + FU, size
		v.drawScaled(x, y, s, p)
	end

	for y = y1 + size, y2 - size + FU, size
		v.drawScaled(x1, y, s, p)
	end
end


local function loadSprites(v)
	local i = 1
	for _, tile in ipairs(modmaps.tileproperties)
		if tile.theme continue end

		// Visibility
		tilevisible[i] = not (tile.hidden or tile.editonly)
		tilevisiblebuilder[i] = not tile.hidden

		// Sprite/animation
		local anim = {}
		if type(tile[2]) == "string"
			anim[1] = v.cachePatch(tile[2])
			tileanimspd[i] = 1
		else
			for i2, sprite in ipairs(tile[2])
				anim[i2] = v.cachePatch(sprite)
			end
			tileanimspd[i] = tile[2].spd or 1
		end
		tileanim[i] = anim
		tileanimlen[i] = #anim * tileanimspd[i]
		local p = anim[1]

		// Scale
		local s
		if tile[3] ~= nil
			s = tile[3] * renderscale
		else
			s = BLOCK_SIZE * renderscale / (p.width > p.height and p.width or p.height)
		end
		tilescale[i] = s

		// X-offset
		if tile[4] == nil
			tilex[i] = p.leftoffset * s + (BLOCK_SIZE * renderscale - p.width * s) / 2
		elseif abs(tile[4]) < 256
			tilex[i] = tile[4] * renderscale * FU + p.leftoffset * s
		else
			tilex[i] = tile[4] * renderscale + p.leftoffset * s
		end

		// Y-offset
		if tile[5] == nil
			tiley[i] = p.topoffset * s + BLOCK_SIZE * renderscale - p.height * s
		elseif abs(tile[5]) < 256
			tiley[i] = tile[5] * renderscale * FU + p.topoffset * s
		else
			tiley[i] = tile[5] * renderscale + p.topoffset * s
		end

		// Flags
		tileflags[i] = tile.flip and V_FLIP or 0

		i = $ + 1
	end

	spritesnotloaded = false
end


local function drawBackground(v, p)
	if map.backgroundtype == 1 // Picture
		local background = modmaps.backgrounds[map.background]

		if p.nobgpic // Show background option disabled
			local w, h = 320 * v.dupx(), 200 * v.dupy()
			v.drawFill((v.width() - w) / 2, (v.height() - h) / 2, w, h, (background.color or 0) | V_NOSCALESTART)
		else // Enabled
			local pic = v.cachePatch(background.pic)
			local t = background.type
			if t == "centered"
				local s = max(SCREEN_WIDTH / pic.width, SCREEN_HEIGHT / pic.height)
				v.drawScaled((SCREEN_WIDTH - pic.width * s) / 2, 0, s, pic)
			elseif t == "tiled"
				local s = background.scale or FU
				for y = 0, SCREEN_HEIGHT - 1, pic.height * s
					for x = 0, SCREEN_WIDTH - 1, pic.width * s
						v.drawScaled(x, y, s, pic)
					end
				end
			else // Horizontally tiled by default
				local s = SCREEN_HEIGHT / pic.height
				for x = 0, SCREEN_WIDTH - 1, pic.width * s
					v.drawScaled(x, 0, s, pic)
				end
			end
		end
	else // Color
		local w, h = 320 * v.dupx(), 200 * v.dupy()
		v.drawFill((v.width() - w) / 2, (v.height() - h) / 2, w, h, map.background | V_NOSCALESTART)
	end


	//v.drawFill(x / FU, y / FU, map.w * BLOCK_SIZE / FU, map.h * BLOCK_SIZE / FU, map.background)

	//drawBox(v, x, y, x + map.w * BLOCK_SIZE, y + 20 * BLOCK_SIZE, v.cachePatch(tetrisbackgrounds[tt.background]))
	/*v.drawFill(x / FU, y / FU, map.w * BLOCK_SIZE / FU, 20 * BLOCK_SIZE / FU, tetristhemes[tt.theme].color)
	//drawBox(v, x, y, x + map.w * BLOCK_SIZE, y + 20 * BLOCK_SIZE, v.cachePatch(tetrisbackgrounds[tt.background]))*/
end

local function drawForeground(v)
end


/*local function drawPlayer(v, p, owner)
	if p.y >= map.h * BLOCK_SIZE return end

	local c = owner and owner.skincolor or SKINCOLOR_BLUE
	local a = skininfo[p.skin].anim[p.anim]
	local spr = a[p.spr / a.spd]

	v.drawScaled(XOFFSET + p.x + PLAYER_WIDTH / 2, YOFFSET + p.y + p.h, FU / 5, spr, objdir[o] == 2 and V_FLIP or 0, v.getColormap(nil, c))

	if tt.flood ~= nil and tetristhemes[tt.theme].flood == 1 and p.y + p.h / 3 > tt.flood and leveltime & 8 and p.air ~= 0
		if p.air < 1 * TICRATE
			v.drawScaled(XOFFSET + p.x + PLAYER_WIDTH / 2, YOFFSET + p.y - 2 * FU, FU / 3, v.cachePatch("DRWNA0"))
		elseif p.air < 3 * TICRATE
			v.drawScaled(XOFFSET + p.x + PLAYER_WIDTH / 2, YOFFSET + p.y - 2 * FU, FU / 3, v.cachePatch("DRWNB0"))
		elseif p.air < 5 * TICRATE
			v.drawScaled(XOFFSET + p.x + PLAYER_WIDTH / 2, YOFFSET + p.y - 2 * FU, FU / 3, v.cachePatch("DRWNC0"))
		elseif p.air < 7 * TICRATE
			v.drawScaled(XOFFSET + p.x + PLAYER_WIDTH / 2, YOFFSET + p.y - 2 * FU, FU / 3, v.cachePatch("DRWND0"))
		elseif p.air < 9 * TICRATE
			v.drawScaled(XOFFSET + p.x + PLAYER_WIDTH / 2, YOFFSET + p.y - 2 * FU, FU / 3, v.cachePatch("DRWNE0"))
		elseif p.air < 11 * TICRATE
			v.drawScaled(XOFFSET + p.x + PLAYER_WIDTH / 2, YOFFSET + p.y - 2 * FU, FU / 3, v.cachePatch("DRWNF0"))
		end
	end
end*/

// !!!!
local function drawPlayer(v, p, scrollx, scrolly)
	local owner = p.owner ~= nil and players[p.owner] or nil

	local a = skininfo[p.skin].anim[p.anim]
	local spr = a[p.spr / a.spd]

	local x = p.x + PLAYER_WIDTH / 2 - scrollx
	local y = p.y + p.h - scrolly
	local leftoffset = spr.leftoffset
	local topoffset = spr.topoffset

	// !!!
	// Players seem to disappear too soon
	if x + (spr.width - leftoffset) * FU / 5 <= 0
	or x - leftoffset * FU / 5 >= SCREEN_WIDTH
	or y + (spr.height - topoffset) * FU / 5 <= 0
	or y - topoffset * FU / 5 >= SCREEN_HEIGHT
	or (p.flash and p.flash < 3 * TICRATE or p.invincibility) and leveltime & 1
		return
	end

	v.drawScaled(XOFFSET + x, YOFFSET + y, FU / 5, spr, p.dir == 2 and V_FLIP or 0, v.getColormap(nil, owner and owner.skincolor or SKINCOLOR_BLUE))

	/*if tt.flood ~= nil and tetristhemes[tt.theme].flood == 1 and p.y + p.h / 3 > tt.flood and leveltime & 8 and p.air ~= 0
		// !!!
		if p.air < 1 * TICRATE
			v.drawScaled(XOFFSET + p.x + PLAYER_WIDTH / 2, YOFFSET + p.y - 2 * FU, FU / 3, v.cachePatch("DRWNA0"))
		elseif p.air < 3 * TICRATE
			v.drawScaled(XOFFSET + p.x + PLAYER_WIDTH / 2, YOFFSET + p.y - 2 * FU, FU / 3, v.cachePatch("DRWNB0"))
		elseif p.air < 5 * TICRATE
			v.drawScaled(XOFFSET + p.x + PLAYER_WIDTH / 2, YOFFSET + p.y - 2 * FU, FU / 3, v.cachePatch("DRWNC0"))
		elseif p.air < 7 * TICRATE
			v.drawScaled(XOFFSET + p.x + PLAYER_WIDTH / 2, YOFFSET + p.y - 2 * FU, FU / 3, v.cachePatch("DRWND0"))
		elseif p.air < 9 * TICRATE
			v.drawScaled(XOFFSET + p.x + PLAYER_WIDTH / 2, YOFFSET + p.y - 2 * FU, FU / 3, v.cachePatch("DRWNE0"))
		elseif p.air < 11 * TICRATE
			v.drawScaled(XOFFSET + p.x + PLAYER_WIDTH / 2, YOFFSET + p.y - 2 * FU, FU / 3, v.cachePatch("DRWNF0"))
		end
	end*/
end

local function drawBuilder(v, p, scrollx, scrolly)
	local owner = p.owner ~= nil and players[p.owner] or nil

	if p.x * BLOCK_SIZE <= scrollx
	or (p.x - 1) * BLOCK_SIZE >= scrollx + SCREEN_WIDTH
	or p.y * BLOCK_SIZE <= scrolly
	or (p.y - 1) * BLOCK_SIZE >= scrolly + SCREEN_HEIGHT
		return
	end

	local tile = p.tile
	if not p.erase and tile ~= nil
		v.drawScaled(XOFFSET + ((p.x - 1) * BLOCK_SIZE - scrollx) * renderscale + tilex[tile], YOFFSET + ((p.y - 1) * BLOCK_SIZE - scrolly) * renderscale + tiley[tile], tilescale[tile], tileanim[tile][(leveltime % tileanimlen[tile]) / tileanimspd[tile] + 1], tileflags[tile] | V_50TRANS)
	end

	v.drawScaled(XOFFSET + ((p.x - 1) * BLOCK_SIZE - scrollx) * renderscale, YOFFSET + ((p.y - 1) * BLOCK_SIZE - scrolly) * renderscale, BLOCK_SIZE * renderscale / 8, v.cachePatch("MAPS_EDITCURS"), 0, v.getColormap(nil, owner and owner.skincolor or SKINCOLOR_RED))
end

// !!!!
// ...
local function drawObjects(v, scrollx, scrolly)
	local objtype = objtype
	local objx, objy = objx, objy
	local objw, objh = objw, objh
	local objdir = objdir
	local objanim = objanim
	local objspr = objspr
	local objextra = objextra
	local objinfoscale = objinfoscale
	local objinfo = objinfo
	// ...

	for o = 1, #objtype
		local t = objtype[o]
		if not t continue end

		local info = objinfo[t]

		if t ~= OBJ_PLAYER
			local a = info.anim[objanim[o]] // !!!
			local spr = v.cachePatch(a[objspr[o] / a.spd])

			local x = (objx[o] + objw[o] / 2 - scrollx) * renderscale
			local y = (objy[o] + objh[o] - scrolly) * renderscale
			local leftoffset = spr.leftoffset
			local topoffset = spr.topoffset
			local scale = objinfoscale[t] * renderscale

			// !!!
			// Objects seem to disappear too soon
			if x + (spr.width - leftoffset) * scale <= 0
			or x - leftoffset * scale >= SCREEN_WIDTH
			or y + (spr.height - topoffset) * scale <= 0
			or y - topoffset * scale >= SCREEN_HEIGHT
			or t == OBJ_SPILLEDRING and objextra[o] < 2 * TICRATE and leveltime & 1 // !!!
				continue
			end

			local f = objdir[o] == 2 and V_FLIP or 0
			if t == OBJ_THOK
				f = $ | V_50TRANS
			end

			v.drawScaled(XOFFSET + x, YOFFSET + y, scale, spr, f, v.getColormap(nil, objcolor[o]))
		else // Player
			local p = pp[objextra[o]]

			local owner = p.owner ~= nil and players[p.owner] or nil

			local a = skininfo[p.skin].anim[objanim[o]]
			local frame = objspr[o] / a.spd - 1
			local spr = v.getSprite2Patch(p.skin, a.sprite2, false, frame, 3)

			local x = (objx[o] + objw[o] / 2 - scrollx) * renderscale
			local y = (objy[o] + objh[o] - scrolly) * renderscale
			local leftoffset = spr.leftoffset
			local topoffset = spr.topoffset
			local scale = FU / 5 * renderscale

			// !!!
			// Objects seem to disappear too soon
			if x + (spr.width - leftoffset) * scale <= 0
			or x - leftoffset * scale >= SCREEN_WIDTH
			or y + (spr.height - topoffset) * scale <= 0
			or y - topoffset * scale >= SCREEN_HEIGHT
			or (p.flash and p.flash < 3 * TICRATE or p.invincibility) and leveltime & 1
				continue
			end

			v.drawScaled(XOFFSET + x, YOFFSET + y, scale, spr, objdir[o] == 2 and V_FLIP or 0, v.getColormap(nil, owner and owner.skincolor or SKINCOLOR_BLUE))

			if p.shield == "pity"
				local a = info.pityshieldanim
				local spr = v.cachePatch(a[(leveltime % #a) / a.spd + 1])
				v.drawScaled(XOFFSET + x, YOFFSET + y, scale, spr, V_20TRANS)
			elseif p.shield == "strongforce"
				local a = info.strongforceshieldanim
				local spr = v.cachePatch(a[(leveltime % #a) / a.spd + 1])
				v.drawScaled(XOFFSET + x, YOFFSET + y, scale, spr, V_50TRANS)
			elseif p.shield == "weakforce"
				local a = info.weakforceshieldanim
				local spr = v.cachePatch(a[(leveltime % #a) / a.spd + 1])
				v.drawScaled(XOFFSET + x, YOFFSET + y, scale, spr, V_50TRANS)
			elseif p.shield == "wind"
				local a = info.windshieldanim
				local spr = v.cachePatch(a[(leveltime % #a) / a.spd + 1])
				v.drawScaled(XOFFSET + x, YOFFSET + y, scale, spr, V_70TRANS)
			end
		end
	end
end

local function drawDeadPlayers(v, scrollx, scrolly)
	for i = 1, #pp
		local p = pp[i]
		if p.dead
			local owner = p.owner ~= nil and players[p.owner] or nil

			// !!! Death animations won't loop!
			local a = skininfo[p.skin].anim["die"]
			local spr = v.getSprite2Patch(p.skin, a.sprite2, false, 0, 3)

			local x = (p.x + PLAYER_WIDTH / 2 - scrollx) * renderscale
			local y = (p.y + PLAYER_HEIGHT - scrolly) * renderscale
			local leftoffset = spr.leftoffset
			local topoffset = spr.topoffset

			// !!!
			// Players seem to disappear too soon
			if x + (spr.width - leftoffset) * FU / 5 <= 0
			or x - leftoffset * FU / 5 >= SCREEN_WIDTH
			or y + (spr.height - topoffset) * FU / 5 <= 0
			or y - topoffset * FU / 5 >= SCREEN_HEIGHT
				continue
			end

			// !!! Direction isn't accounted for!
			v.drawScaled(XOFFSET + x, YOFFSET + y, FU / 5 * renderscale, spr, 0, v.getColormap(nil, owner and owner.skincolor or SKINCOLOR_BLUE))
		end
	end
end


/*local function drawFlood(v, x, y, scrolly)
	local t = tetristhemes[tt.theme]
	local y1 = (y + max(tt.flood - scrolly, 0)) / FU
	local y2 = (y + 20 * BLOCK_SIZE) / FU

	if t.floodcolor ~= nil and (t.flood ~= 4 or leveltime & 2) and y2 >= y1
		v.drawFill(x / FU, y1, map.w * BLOCK_SIZE / FU, y2 - y1, t.floodcolor)
	end
end*/

/*local lolz = 16384
local lols = 256

modmaps.addCommand("p", function(p, n)
	n = tonumber($)
	if n == nil n = lols end

	lolz = $ + n

	print(lolz)
end, 1)

modmaps.addCommand("m", function(p, n)
	n = tonumber($)
	if n == nil n = lols end

	lolz = $ - n

	print(lolz)
end, 1)

modmaps.addCommand("s", function(p, n)
	n = tonumber($)
	if n == nil return end

	lols = n
end, 1)

local function drawFlood(v, scrolly)
	local t = tetristhemes[tt.theme]

	if t.floodcolor ~= nil and (t.flood ~= 4 or leveltime & 2)
		local y1 = YOFFSET + max(tt.flood - scrolly, 0)
		local y2 = YOFFSET + 20 * BLOCK_SIZE
		local p = v.cachePatch("CFALL"..(leveltime & 3) + 1)
		//local s = BORDERS_SIZE / p.width
		local s = BORDERS_SIZE / p.height
		local f = V_50TRANS

		if y2 >= y1
			for y = y1 + p.topoffset * s, y2 - 1 + p.topoffset * s, BORDERS_SIZE + 22272*0
				for x = XOFFSET + p.leftoffset * s, XOFFSET + map.w * BLOCK_SIZE - 1 + p.leftoffset * s, BORDERS_SIZE / 2 + 22272*0 // !!!
					v.drawScaled(x, y, s, p, f)
				end
			end
		end
	end
end*/


local function drawMap(v, p)
	local scrollx, scrolly = p.scrollx, p.scrolly
	local visiblelayer = p.builder and p.visiblelayer or nil
	if visiblelayer == 1
		visiblelayer = p.overlay and 4 or p.layer == 1 and 2 or 3
	end

	drawBackground(v, p)

	// Let's use tons of locals so we speed up the renderer a little
	//local TILE1, TILE2 = TILE1, TILE2 // !!!
	local tilevisible = p.builder and tilevisiblebuilder or tilevisible
	local tileanim = tileanim
	local tileanimspd = tileanimspd
	local tileanimlen = tileanimlen
	local tilescale = tilescale
	local tilex = tilex
	local tiley = tiley
	local tileflags = tileflags
	local map = map
	local map1 = map1
	local map2 = map2
	local tileinfo = tileinfo
	local leveltime = leveltime
	local drawScaled = v.drawScaled

	local x1 = scrollx / BLOCK_SIZE
	local leftmargin = min(1, x1)
	x1 = -(scrollx % BLOCK_SIZE + leftmargin * BLOCK_SIZE) * renderscale

	local y1 = scrolly / BLOCK_SIZE
	local topmargin = min(1, y1)
	y1 = -(scrolly % BLOCK_SIZE + topmargin * BLOCK_SIZE) * renderscale

	local x2 = (scrollx + SCREEN_WIDTH / renderscale - 1) / BLOCK_SIZE
	local rightmargin = min(1, map.w - 1 - x2)
	x2 = SCREEN_WIDTH - 1 + rightmargin * BLOCK_SIZE * renderscale

	local y2 = (scrolly + SCREEN_HEIGHT / renderscale - 1) / BLOCK_SIZE
	local bottommargin = min(1, map.h - 1 - y2)
	y2 = SCREEN_HEIGHT - 1 + bottommargin * BLOCK_SIZE * renderscale

	local i1 = scrollx / BLOCK_SIZE - leftmargin + (scrolly / BLOCK_SIZE - topmargin) * map.w
	local d = map.w - (x2 - x1) / (BLOCK_SIZE * renderscale) - 1
	local tile

	// Draw background layer
	if not visiblelayer or visiblelayer == 3
		local i = i1
		for y = y1, y2, BLOCK_SIZE * renderscale
			for x = x1, x2, BLOCK_SIZE * renderscale
				i = $ + 1
				if not (tileinfo[i] & 1)
					tile = map2[i]
					if tilevisible[tile]
						drawScaled(x + tilex[tile], y + tiley[tile], tilescale[tile], tileanim[tile][(leveltime % tileanimlen[tile]) / tileanimspd[tile] + 1], tileflags[tile])
					end
				end
			end
			i = $ + d
		end
	end

	// Draw active layer
	if not visiblelayer or visiblelayer == 2
		local i = i1
		for y = y1, y2, BLOCK_SIZE * renderscale
			for x = x1, x2, BLOCK_SIZE * renderscale
				i = $ + 1
				tile = map1[i]
				if tilevisible[tile]
					drawScaled(x + tilex[tile], y + tiley[tile], tilescale[tile], tileanim[tile][(leveltime % tileanimlen[tile]) / tileanimspd[tile] + 1], tileflags[tile])
				end
			end
			i = $ + d
		end
	end

	// Draw alive players
	/*for _, p in ipairs(pp)
		if not (p.builder or p.dead)
			drawPlayer(v, p, scrollx, scrolly)
		end
	end*/

	// Draw objects
	drawObjects(v, scrollx, scrolly)

	// Draw foreground layer
	if not visiblelayer or visiblelayer == 4
		local i = i1
		for y = y1, y2, BLOCK_SIZE * renderscale
			for x = x1, x2, BLOCK_SIZE * renderscale
				i = $ + 1
				if tileinfo[i] & 1
					tile = map2[i]
					if tilevisible[tile]
						drawScaled(x + tilex[tile], y + tiley[tile], tilescale[tile], tileanim[tile][(leveltime % tileanimlen[tile]) / tileanimspd[tile] + 1], tileflags[tile])
					end
				end
			end
			i = $ + d
		end
	end

	/*local i = scrollx / BLOCK_SIZE + scrolly / BLOCK_SIZE * map.w
	for y = YOFFSET - scrolly % BLOCK_SIZE, SCREEN_HEIGHT - 1, BLOCK_SIZE
		for x = XOFFSET - scrollx % BLOCK_SIZE, SCREEN_WIDTH - 1, BLOCK_SIZE
			i = $ + 1

			tile2 = map2[i]
			if tilevisible[tile2]
				drawScaled(x + tilex[tile2], y + tiley[tile2], tilescale[tile2], tileanim[tile2][(leveltime % tileanimlen[tile2]) / tileanimspd[tile2] + 1])
			end

			tile1 = map1[i]
			if tilevisible[tile1]
				drawScaled(x + tilex[tile1], y + tiley[tile1], tilescale[tile1], tileanim[tile1][(leveltime % tileanimlen[tile1]) / tileanimspd[tile1] + 1])
			end
		end
		i = $ + d
	end*/

	/*for _, b in ipairs(tt.builders)
		s = tiles[b.sprite]
		for i = 1, #shapes[b.shape]
			local y = getBlockY(b, i)
			if y < 1 or y * BLOCK_SIZE <= scrolly or (y - 1) * BLOCK_SIZE >= scrolly + 20 * BLOCK_SIZE continue end
			v.drawScaled(XOFFSET + (getBlockX(b, i) - 1) * BLOCK_SIZE + s[4], YOFFSET + (getBlockY(b, i) - 1) * BLOCK_SIZE + s[5] - scrolly, s[3], s[2])
		end
	end*/

	drawDeadPlayers(v, scrollx, scrolly)

	// Draw builders
	for i = 1, #pp
		local p = pp[i]
		if p.builder
			drawBuilder(v, p, scrollx, scrolly)
		end
	end

	if fakebuilder
		drawBuilder(v, fakebuilder, scrollx, scrolly)
	end

	/*if tt.flood ~= nil
		drawFlood(v, scrolly)
	end*/

	// Draw "true" HUD
	if p.builder
		// Draw selected layer
		if p.overlay or p.layer == 2 or not p.tile or tiletype[p.tile] ~= 1
			v.drawString(2, 194, p.overlay and "Overlay" or "Layer "..p.layer, V_ALLOWLOWERCASE, "small")
		else
			v.drawString(2, 194, "Layer 1 - "
			..(p.tiletype == 0 and "decorative"
			or p.tiletype == 1 and "solid"
			or p.tiletype == 2 and "platform"),
			V_ALLOWLOWERCASE, "small")
		end
	else
		// Draw rings (experimental?)
		//drawScaled((hudinfo[HUD_RINGS].x) * select(2, v.dupx()), (hudinfo[HUD_RINGS].y) * select(2, v.dupy()), FU, v.cachePatch(p.rings <= 0 and (leveltime / 5) & 1 and "STTRRING" or "STTRINGS"), V_NOSCALESTART | V_HUDTRANS)
		v.draw(6, 6, v.cachePatch(p.rings <= 0 and (leveltime / 5) & 1 and "STTRRING" or "STTRINGS"), V_HUDTRANS)
		v.drawNum(102, 6, min(p.rings, 9999)) // !!! Handle ring limit correctly
	end
end

local function drawTileChoice(v, p)
	v.drawFill()

	local theme = themes[p.theme]
	local n = #theme
	local themetile = p.themetile
	local drawScaled = v.drawScaled
	local i = 1
	for y = BLOCK_SIZE / 2, SCREEN_HEIGHT - BLOCK_SIZE * 3 / 2, BLOCK_SIZE * 3 / 2
		for x = BLOCK_SIZE / 2, SCREEN_WIDTH - BLOCK_SIZE * 3 / 2, BLOCK_SIZE * 3 / 2
			if i > n break end

			local tile = theme[i]
			local xoffset, yoffset = tilex[tile] / renderscale, tiley[tile] / renderscale
			local scale = tilescale[tile] / renderscale
			if themetile ~= i
				drawScaled(x + xoffset, y + yoffset, scale, tileanim[tile][(leveltime % tileanimlen[tile]) / tileanimspd[tile] + 1], tileflags[tile] | V_50TRANS)
			else
				drawScaled(x - BLOCK_SIZE / 4 + xoffset * 3 / 2, y - BLOCK_SIZE / 4 + yoffset * 3 / 2, scale * 3 / 2, tileanim[tile][(leveltime % tileanimlen[tile]) / tileanimspd[tile] + 1], tileflags[tile])
			end

			i = $ + 1
		end
		if i > n break end
	end

	local tile = theme[themetile]
	local s = tiletype[tile] ~= 1 and tiletypenames[tiletype[tile]]
	or tiledefaulttype[tile] == 0 and "Decorative"
	or tiledefaulttype[tile] == 1 and "Solid"
	or tiledefaulttype[tile] == 2 and "Platform"
	v.drawString(160 - v.stringWidth(s, V_ALLOWLOWERCASE) / 2, 188, s, V_ALLOWLOWERCASE)
end

local function drawThemeChoice(v, p)
	v.drawFill()

	local n = #themes
	local theme = p.theme
	local drawScaled = v.drawScaled
	local cachePatch = v.cachePatch
	local i = 1
	for y = BLOCK_SIZE / 2, SCREEN_HEIGHT - BLOCK_SIZE * 3 / 2, BLOCK_SIZE * 3 / 2
		for x = BLOCK_SIZE / 2, SCREEN_WIDTH - BLOCK_SIZE * 3 / 2, BLOCK_SIZE * 3 / 2
			if i > n break end

			local icon = cachePatch(themes[i].icon)
			local s = icon.width > icon.height and BLOCK_SIZE / icon.width or BLOCK_SIZE / icon.height
			if theme ~= i
				drawScaled(x + icon.leftoffset * s, y + icon.topoffset * s, s, icon, V_50TRANS)
			else
				s = $ * 3 / 2
				drawScaled(x - BLOCK_SIZE / 4 + icon.leftoffset * s, y - BLOCK_SIZE / 4 + icon.topoffset * s, s, icon)
			end

			i = $ + 1
		end
		if i > n break end
	end

	local s = themes[theme].name
	v.drawString(160 - v.stringWidth(s, V_ALLOWLOWERCASE) / 2, 188, s, V_ALLOWLOWERCASE)
end

local function drawGame(v, player)
	if spritesnotloaded
		loadSprites(v)
	end

	local p = player.maps and pp[player.maps.player]

	if p
		if p.choosingtile
			drawTileChoice(v, p)
		elseif p.choosingtheme
			drawThemeChoice(v, p)
		else
			drawMap(v, p)
		end
	end

	if player.menu
		menulib.draw(v, player, "maps")
	end

	// Draw borders
	local screenw, screenh = v.width(), v.height()
	local realw, realh = 320 * v.dupx(), 200 * v.dupy()
	local borderw, borderh = (screenw - realw) / 2, (screenh - realh) / 2
	local borderflags = 31 | V_NOSCALESTART
	if borderw ~= 0
		v.drawFill(borderw + realw, borderh, borderw, realh, borderflags) // Right
		v.drawFill(0, borderh, borderw, realh, borderflags) // Left
	end
	if borderh ~= 0
		v.drawFill(0, 0, screenw, borderh, borderflags) // Top
		v.drawFill(0, borderh + realh, screenw, borderh, borderflags) // Bottom
	end
end

if not cpulib
	hud.add(function(v, p)
		if p.maps // kawaiii
		and not (splitscreen and #p == 1)
			drawGame(v, p)
		end
	end, "game")
end


if not cpulib
	hud.add(function(v)
		if not mapheaderinfo[gamemap].kawaiii_mapbuilder return end

		v.drawFill()

		v.drawString(4, 192, "Custom map")

		v.drawFill(160, 26, 1, 154, 0)
		v.drawFill(1, 26, 318, 1, 0)
		v.drawFill(1, 180, 318, 1, 0)

		local x, y = 60, 32
		for owner in players.iterate
			local p = owner.maps and pp[owner.maps.player]

			v.drawString(x, y, owner.name, V_ALLOWLOWERCASE | ((not p or p.dead) and V_50TRANS or p.builder and (leveltime & 8 and V_GREENMAP or V_ORANGEMAP) or 0))

			local icon = v.getSprite2Patch(p and p.skin or "sonic", SPR2_XTRA, false, A, 0)
			--local icon = v.cachePatch(skininfo[p and p.skin or "sonic"].icon)
			v.drawScaled((x - 20) * FU, (y - 4) * FU, FU / 2, icon, (not p or p.dead) and V_50TRANS or 0, v.getColormap(nil, owner.skincolor or SKINCOLOR_BLUE))

			y = $ + 16
			if y > 160
				y = 32
				x = $ + 160
			end
		end
	end, "scores")
end




function modmaps.cleanupName(name)
	for _, s in ipairs{"^Maps/", "^Maps/", "%.dat$", "%.map$"}
 		name = $:gsub(s, "")
	end

	return "MapsLegacy/Maps/"..name..".map.dat"
end

function modmaps.concatCommandArgs(...)
	local s
	for _, word in ipairs({...})
		if s
			s = s.." "..word
		else
			s = word
		end
	end
	return s
end

function modmaps.fileExists(filename)
	local file = io.openlocal(filename, "r")
	if file
		file:close()
		return true
	else
		return false
	end
end

function modmaps.writeMap(stream)
	modmaps.writeString(stream, modmaps.mapversion)

	modmaps.writeInt32(stream, map.w)
	modmaps.writeInt32(stream, map.h)

	modmaps.writeByte  (stream, map.backgroundtype)
	modmaps.writeUInt16(stream, map.background)

	if type(map.music) == "number"
		modmaps.writeByte(stream, 1)
		modmaps.writeUInt16(stream, map.music)
	else
		modmaps.writeByte(stream, 0)
		modmaps.writeString(stream, map.music)
	end

	modmaps.writeInt32(stream, map.spawnx)
	modmaps.writeInt32(stream, map.spawny)
	modmaps.writeInt32(stream, map.spawndir)

	local tiles1 = {}
	local tiles2 = {}
	local info = {}
	for i = 1, #map1
		tiles1[i - 1] = map1[i]
		tiles2[i - 1] = map2[i]
		info[i - 1] = tileinfo[i]
	end

	modmaps.writeHuffman(stream, tiles1, 12)
	modmaps.writeHuffman(stream, tiles2, 12)
	modmaps.writeHuffman(stream, info, 8)
end

function modmaps.readMap(stream)
	local version = modmaps.readString(stream)
	if version ~= modmaps.mapversion
		return "Wrong version. Map version is "..version..", script version is "..modmaps.mapversion.."."
	end

	clearMapAndPlayers()

	map = {}
	map[1] = {}
	map[2] = {}
	map.tileinfo = {}
	map1 = map[1]
	map2 = map[2]
	tileinfo = map.tileinfo

	map.w = modmaps.readInt32(stream)
	map.h = modmaps.readInt32(stream)

	map.backgroundtype = modmaps.readByte  (stream)
	map.background     = modmaps.readUInt16(stream)

	if modmaps.readByte(stream) == 1
		map.music = modmaps.readUInt16(stream)
	else
		map.music = modmaps.readString(stream)
	end

	map.spawnx   = modmaps.readInt32(stream)
	map.spawny   = modmaps.readInt32(stream)
	map.spawndir = modmaps.readInt32(stream)

	local tiles1 = modmaps.readHuffman(stream, map.w * map.h, 12)
	local tiles2 = modmaps.readHuffman(stream, map.w * map.h, 12)
	local info   = modmaps.readHuffman(stream, map.w * map.h, 8)

	for i = 1, map.w * map.h
		map1[i] = tiles1[i - 1]
		map2[i] = tiles2[i - 1]
		tileinfo[i] = info[i - 1]
	end

	createBlockmap() // !!!
end

modmaps.addCommand("save", function(p, ...)
	local filename = modmaps.concatCommandArgs(...)

	if filename
		filename = modmaps.cleanupName($)
		if filename == modmaps.mapfilename
			CONS_Printf(p, "\x83NOTICE:\x80 you can omit the file name when saving.")
		end
	else
		filename = modmaps.mapfilename
		if not filename
			CONS_Printf(p, "save [file name]: save the map")
			CONS_Printf(p, "Maps are saved in luafiles/MapsLegacy/Maps/ if you are the host,")
			CONS_Printf(p, "or in luafiles/client/MapsLegacy/Maps/ if you are a client.")
			CONS_Printf(p, "Note that this only saves the map on your end.")
			return
		end
	end

	local stream = modmaps.createByteStream()
	modmaps.writeMap(stream)

	local realfilename = filename
	if p ~= server
		realfilename = "client/"..$
	end

	if filename ~= modmaps.mapfilename and modmaps.fileExists(realfilename)
		CONS_Printf(p, "\x85".."ERROR:".."\x80 another map with the same name already exists.")
		CONS_Printf(p, "Remove the file manually if you actually want to override it.")
		return
	end

	local file = io.openlocal(realfilename, "wb")
	file:write(modmaps.bytesToString(stream.bytes))
	file:close()

	modmaps.mapfilename = filename
end, COM_LOCAL)

modmaps.addCommand("load", function(p, ...)
	local filename = modmaps.concatCommandArgs(...)

	if not filename
		CONS_Printf(p, "load <file name>: load a map")
		CONS_Printf(p, "Maps are saved in luafiles/MapsLegacy/Maps/ inside your SRB2 folder.")
		CONS_Printf(p, "If you are trying to load a map that was saved using the 2.1 version, please use \"loadwad\" instead.")
		return
	end

	filename = modmaps.cleanupName($)

	io.open(filename, "rb", function(file)
		if not file
			CONS_Printf(p, "\x85".."ERROR:".."\x80 the map could not be opened.")
			return
		end

		local bytes = modmaps.stringToBytes(file:read(INT32_MAX))

		local stream = modmaps.createByteStream(bytes)
		local errormsg = modmaps.readMap(stream)
		if errormsg
			CONS_Printf(p, errormsg)
			return
		end

		mapticker = 1
		maptickerspeed = min(#map1 / (30 * TICRATE), 64) // !!!
		map.actions = {}

		for i = 1, #pp
			spawnPlayer(i)
		end

		-- Only remember the name locally, as the name chosen by the server
		-- might already be used for something else in the clients' folders
		if p == consoleplayer
			modmaps.mapfilename = filename
		end
	end)
end, COM_ADMIN)

// !!!

/*modmaps.addCommand("savewad", function(p)
	if modmaps.customSaveMap
		modmaps.customSaveMap(p)
		return
	end

	compressMapOld()
	local map = compressedgamestate.map

	CONS_Printf(p, "--- MAP START ---")
	CONS_Printf(p, "if not modmaps")
	CONS_Printf(p, 'rawset(_G, "modmaps", {})')
	CONS_Printf(p, "modmaps.maps = {}")
	CONS_Printf(p, "end")
	CONS_Printf(p, "table.insert(modmaps.maps, {")

	CONS_Printf(p, 'version = "'..modmaps.mapversion..'",')
	CONS_Printf(p, "w = "..map.w..", h = "..map.h..",")
	CONS_Printf(p, "backgroundtype = "..map.backgroundtype..",")
	CONS_Printf(p, "background = "..map.background..",")
	if type(map.music) == "number"
		CONS_Printf(p, "music = "..map.music..",")
	else
		CONS_Printf(p, 'music = "'..map.music..'",')
	end
	CONS_Printf(p, "spawnx = "..map.spawnx..", spawny = "..map.spawny..", spawndir = "..map.spawndir..",")

	for i = 1, #map
		CONS_Printf(p, map[i]..",")
	end

	CONS_Printf(p, "})")
	CONS_Printf(p, "--- MAP END ---")

	compressedgamestate = nil
end)*/

modmaps.addCommand("loadwad", function(p, n)
	if not modmaps.customLoadMap
		if savedmap
			table.insert(modmaps.maps, savedmap)
			savedmap = nil
		end

		if #modmaps.maps == 0
			CONS_Printf(p, "No map found.")
			return
		end

		if #modmaps.maps == 1
			n = 1
		else
			n = tonumber($)
			if n
				if n < 1 or n > #modmaps.maps
					CONS_Printf(p, "This map doesn't exist. Try map numbers between 1 and "..#modmaps.maps..".")
					return
				end
			else
				CONS_Printf(p, "load <1-"..#modmaps.maps..">: load a map saved in a wad")
				return
			end
		end

		if modmaps.maps[n].version ~= modmaps.mapversion
			CONS_Printf(p, "Wrong version. Map version is "..(modmaps.maps[n].version or "0.1")..", script version is "..modmaps.mapversion..".")
			return
		end
	end

	clearMapAndPlayers()

	if modmaps.customLoadMap
		map = {}
		map[1] = {}
		map[2] = {}
		map.tileinfo = {}
		map1 = map[1]
		map2 = map[2]
		tileinfo = map.tileinfo
		modmaps.customLoadMap()
	else
		compressedgamestate = {}
		compressedgamestate.map = modmaps.maps[n]
		decompressMapOld()
	end

	mapticker = 1
	maptickerspeed = min(#map1 / (30 * TICRATE), 64) // !!!
	map.actions = {}

	for i = 1, #pp
		spawnPlayer(i)
	end

	modmaps.mapfilename = nil
end, 1)

/*modmaps.addCommand("save", function(p)
	CONS_Printf(p, "*** MAP START ***")
	CONS_Printf(p, "map = {")

	CONS_Printf(p, "w = "..map.w..", h = "..map.h..",")
	CONS_Printf(p, "background = "..map.background..",")
	CONS_Printf(p, "music = "..map.music..",")
	CONS_Printf(p, "spawnx = "..map.spawnx..", spawny = "..map.spawny..", spawndir = "..map.spawndir..",")

	for i = 1, #map1 / 16 * 16 - 15, 16
		local s = ""
		for j = i, i + 15
			s = $..map[i]..","
		end
		CONS_Printf(p, s)
	end

	local s = ""
	for i = #map1 / 16 * 16 + 1, #map1
		s = $..map[i]..","
	end
	if s ~= ""
		CONS_Printf(p, s)
	end

	CONS_Printf(p, "}")
	CONS_Printf(p, "*** MAP END ***")
end)*/

/*modmaps.addCommand("save", function(p)
	CONS_Printf(p, "*** MAP START ***")

	CONS_Printf(p, "load "..map.w.." "..map.h)

	for i = 1, #map1 / 16 * 16 - 15, 16
		local s = "l"
		for j = i, i + 15
			s = $.." "..map[j]
		end
		CONS_Printf(p, s)
	end

	local s = "l"
	for i = #map1 / 16 * 16 + 1, #map1
		s = $.." "..map[i]
	end
	if s ~= "l "
		CONS_Printf(p, s)
	end

	CONS_Printf(p, "*** MAP END ***")
end)


local mapload = nil

modmaps.addCommand("load", function(p, w, h)
	map.w, map.h = w, h
	while #map1 > map.w * map.h
		table.remove(map)
	end
	mapload = 1
end)

modmaps.addCommand("l", function(p, ...)
	if not mapload return end

	for i, tile in ipairs({...})
		map[mapload] = tile
		mapload = $ + 1
	end

	if mapload > map.w * map.h
		mapload = nil
	end
end)*/


if cpulib
	cpulib.addApplication({
		name = "The Map Builder",
		dontopen = true,

		open = function(runningapp)
			app = runningapp

			if compressedgamestate
				decompressGamestate()
			end

			initialiseGame()
			startGame()
		end,

		join = function(p, runningapp)
			app = runningapp
			joinGame(p)
		end,

		leave = function(p, runningapp)
			app = runningapp
			leaveGame(p.maps.player)
		end,

		handle = function(runningapp)
			app = runningapp

			if compressedgamestate
				decompressGamestate()
			end

			handleGame()
		end,

		draw = drawGame
	})

	cpulib.openApplication(#cpulib.apps) // !!!!
end