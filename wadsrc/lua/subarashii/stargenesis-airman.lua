--=================================================================
-- 'Air Manager' by (reinamoon|chimiru)
-- do not use my script without my permission
--
-- (dogfight still movement but can be moved with own actions)
--
-- rnm39 - 2016/2017
--=================================================================

-- TODO [+]: On death, perform proper in-air resetting (floats downwards after death), and music changes
-- TODO: [unneeded] proper aerial dodging
-- TODO: [unneeded] proper specific game-over
-- TODO: [unneeded] proper bullet power-up

rawset(_G, "AirMan", {})


-- Sal: Add unique state for star genesis player
freeslot("S_STARGENESIS_PLAYER")
states[S_STARGENESIS_PLAYER] = {SPR_STSP, A, -1, nil, 1, 0, S_STARGENESIS_PLAYER}


function AirMan.Init(player)
	player.air = {
		enabled = true,
		retmark = P_SpawnMobj(0, 0, 0, MT_STAR_RET), -- MT_RING
		retbox = P_SpawnMobj(0, 0, 0, MT_STAR_RETBOX),
		frontRet = false
		-- Create the awayviewmobj camera 240 units away from the player
	}
end

local function math_clamp(x, min, max)
  if x < min then
    return min
  elseif x > max then
    return max
  else
    return x
  end
end

local TANBOUNDX = tan(ANGLE_45, true)
local TANBOUNDY = tan(ANG1*65/2, true)
local function P_ReturnCamBounds(dist)
	return FixedMul(TANBOUNDX, dist), FixedMul(TANBOUNDY, dist)
end

function AirMan.checkawayviewbounds(player)

	if (player and player.awayviewmobj)
		local xboundary, yboundary = P_ReturnCamBounds( player.mo.y - player.awayviewmobj.y)

		if player.mo.x > player.awayviewmobj.x+xboundary then
			--print("out right")
			P_MoveOrigin(player.mo, xboundary, player.mo.y, player.mo.z)
		end
		if player.mo.x < player.awayviewmobj.x-xboundary then
			---print("out left")
			P_MoveOrigin(player.mo, -xboundary, player.mo.y, player.mo.z)
		end
		if player.mo.z > player.awayviewmobj.z+yboundary then
			--print("out up")
			P_MoveOrigin(player.mo, player.mo.x, player.mo.y, yboundary)
		end
		if player.mo.z < player.awayviewmobj.z-yboundary then
			--print("out down")
			P_MoveOrigin(player.mo, player.mo.x, player.mo.y, -yboundary)
		end
	end
end

function AirMan.Enable(player)
	if player.air then
		player.air.enabled = true
	end
	player.mo.flags = $|MF_NOGRAVITY
	--player.normalspeed = 0
	--player.thrustfactor = 0
end

function AirMan.Disable(player)
	if player.air then
		player.air.enabled = false
	end
	--player.normalspeed = player.mo.skin.normalspeed
	--player.thrustfactor = player.mo.skin.thrustfactor
	player.normalspeed = skins[player.mo.skin].normalspeed
	player.thrustfactor = skins[player.mo.skin].thrustfactor
end

function AirMan.ToggleFrontRet(player, value)
	if (player.air and player.air.enabled == true) then
		player.air.frontRet = value
	end
end

local SPEEDLIMIT = 8*FRACUNIT
function AirMan.SetAirControl(player)

	-- DO NOT ALLOW CONTROL WHEN DEAD (STOP DRIFTING, PLEASE)
	if (player.playerstate == PST_DEAD) then return end

	local ship = player.mo
	-- Reduce momentum first so the ship slows down
	ship.momx = $-$/4
	ship.momz = $-$/4
	-- Arrow Key Movement
	player.pflags = $1|PF_FORCESTRAFE
	-- Vector based movement
	if player.cmd.sidemove or player.cmd.forwardmove then
		-- Get input values
		local dh = player.cmd.sidemove*FRACUNIT
		local dv = player.cmd.forwardmove*FRACUNIT
		-- Calculate module
		local dm = FixedHypot(dh, dv)
		-- Get unitary vector components
		dh = FixedDiv($, dm)
		dv = FixedDiv($, dm)
		-- Cap module to 50
		dm = min($, 50*FRACUNIT)
		-- Thrust mobj according to vector
		ship.momx = $ + FixedMul(dh, 3*dm/50)
		ship.momz = $ + FixedMul(dv, 3*dm/50)
		ship.momy = 0
		--ship.angle = ANGLE_90+FixedMul(dh, 3*dv/50)
	end
end
--[[
-- Permap ThingList
rawset(_G, "ThingList", {})
rawset(_G, "MapThingList", {})
rawset(_G, "LineList", {})]]

local function P_ConeCheck(player_thing, thing_list)
	if not (player_thing and player_thing.valid) return end
	-- Define initial limit conditions. They act as a visibility cone.
	local current_thing = nil
	local current_distance = 1024*FRACUNIT
	local current_cosine = cos(R_PointToAngle2(
			player_thing.x,
			player_thing.y,
			player_thing.player.air.retbox.x,
			player_thing.player.air.retbox.y)+ANG15) -- Default: ANG15
	--local current_cosine = cos(ANG15) -- Default: ANG15

	-- Iterate through the thing list to look for targettable objects, and stay with the optimal target (if any at all).
	for i=1, #thing_list do
		if not (thing_list[i] and thing_list[i].valid) continue end
		local thing = thing_list[i]
		local dx = thing.x - player_thing.x
		local dy = thing.y - player_thing.y
		local dz = thing.z - player_thing.z
		local dm = FixedHypot(dz, FixedHypot(dx, dy))
		if dm < current_distance then
			local dc = FixedDiv(dy, dm)
			if dc > current_cosine then
				current_thing = thing
				current_distance = dm
				//current_cosine = dc
			end
		end
	end
	-- Return our best target (or nil if none is found, as set by the initial conditions)
	return current_thing
end

-- Control Reticle Lean
function AirMan.RetControlOld(player)
	local retmark = player.air.retmark
	local target = P_ConeCheck(player.mo, ThingList)
	local retbox = player.air.retbox
	-- Shift to the left/right/up/down
	if target then
		P_MoveOrigin(retmark, target.x, target.y, target.z)
	else
		if not (player.air.frontRet)
			P_MoveOrigin(retmark, player.mo.x+FixedMul(player.mo.momx, 15*FRACUNIT), player.mo.y + 512*FRACUNIT, player.mo.z+FixedMul(player.mo.momz, 15*FRACUNIT))
		else
			--P_MoveOrigin(retmark, FixedMul(player.mo.x, 3*FRACUNIT), player.mo.y + 512*FRACUNIT, player.mo.z+FixedMul(player.mo.momz, 15*FRACUNIT))
			P_MoveOrigin(retmark, player.mo.x+FixedMul(player.mo.momx, 15*FRACUNIT), player.mo.y + 512*FRACUNIT, player.mo.z+FixedMul(player.mo.momz, 15*FRACUNIT))
		end
		--P_MoveOrigin(retmark, player.mo.x, player.mo.y + 512*FRACUNIT, player.mo.z)
	end
end
-- Control Reticle Lean
function AirMan.RetControl(player)
	local retmark = player.air.retmark
	local target = P_ConeCheck(player.mo, ThingList)
	local retbox = player.air.retbox

	-- Shift
	if target and target.flags & MF_SHOOTABLE then
		P_MoveOrigin(retmark, target.x, target.y, target.z)
		P_MoveOrigin(retbox, player.mo.x+FixedMul(player.mo.momx, 15*FRACUNIT), player.mo.y + 128*FRACUNIT, player.mo.z+FixedMul(player.mo.momz, 15*FRACUNIT))
	else
		if not (player.air.frontRet)
			P_MoveOrigin(retmark, player.mo.x+FixedMul(player.mo.momx, 15*FRACUNIT), player.mo.y + 512*FRACUNIT, player.mo.z+FixedMul(player.mo.momz, 15*FRACUNIT))
			P_MoveOrigin(retbox, player.mo.x+FixedMul(player.mo.momx, 15*FRACUNIT), player.mo.y + 128*FRACUNIT, player.mo.z+FixedMul(player.mo.momz, 15*FRACUNIT))
		else
			P_MoveOrigin(retmark, FixedMul(player.mo.x, 3*FRACUNIT), player.mo.y + 512*FRACUNIT, player.mo.z+FixedMul(player.mo.momz, 15*FRACUNIT))
			P_MoveOrigin(retbox, player.mo.x+FixedMul(player.mo.momx, 15*FRACUNIT), player.mo.y + 128*FRACUNIT, player.mo.z+FixedMul(player.mo.momz, 15*FRACUNIT))
		end
		--P_MoveOrigin(retmark, player.mo.x, player.mo.y + 512*FRACUNIT, player.mo.z)
	end
	if (player.awayviewmobj) then
		if (player.awayviewmobj) and not (player.awayviewmobj.override) then
			-- Move Camera View slight when moving
			local xboundary, yboundary = P_ReturnCamBounds( player.mo.y - player.awayviewmobj.y)
			local iangle = ANGLE_90 -- Input basic angle
			local iaiming = 0 -- Input basic "aiming" angle
			local altcam = player.awayviewmobj
			--local aimtarget = player.mo
			local aimtarget = player.mo.aimtarget
			player.mo.aimtarget = player.mo
			local hturn = R_PointToAngle2(altcam.x, altcam.y, aimtarget.x, aimtarget.y) -- Account for triangle made by XY components
			local vturn = R_PointToAngle2(altcam.y, altcam.z, aimtarget.y, aimtarget.z) -- Account for triangle made by YZ components
			player.awayviewmobj.angle = (iangle/8)*7 + hturn/8 -- Weighted angles from basic angle and calculated angle
			player.awayviewaiming = (iaiming/8)*7 + vturn/8
		end
	end
end

function AirMan.MultiplayerOutline(player)
	-- Sal: Add player-colored outline, to make it more parseable in big netgames.
	if not (netgame or multiplayer)
		return
	end

	if not (player.air.outline and player.air.outline.valid)
		player.air.outline = P_SpawnMobjFromMobj(player.mo, 0, 0, 0, MT_OVERLAY)
		player.air.outline.target = player.mo

		player.air.outline.state = S_STARGENESIS_PLAYER
		player.air.outline.frame = B | FF_FULLBRIGHT
		player.air.outline.color = player.skincolor
		player.air.outline.drawonlyforplayer = player
	end

	player.air.outline.fuse = 2
end

local function CreateCustomPlayerCamera(mo)
	if not (mo and mo.valid) then
		return
	end

	local pmo = mo
	if pmo.aimtarget == nil then
		pmo.aimtarget = mo
	end
	if pmo.cam == nil
		pmo.cam = P_SpawnMobj(pmo.x,pmo.y+444*FRACUNIT, pmo.z, MT_PCAM)
	end

	pmo.cam.fuse = 10
end

local function IndPlayerScreenWipe(player)
	if (player.hudOptions and player.hudOptions.wipe) then
		if (player.hudOptions.wipe.set) then
			--if (player.hudOptions.wipe.flash) then player.hudOptions.wipe.dest = $1 return end
			if (leveltime % (player.hudOptions.wipe.Time or 1) == 0)
				player.hudOptions.wipe.dest = max($1-1, 0)
			end
		else
			--if (player.hudOptions.wipe.flash) then player.hudOptions.wipe.dest = $1 return end
			if (leveltime % (player.hudOptions.wipe.Time or 1) == 0)
				player.hudOptions.wipe.dest = min($1+1, 10)
			end
		end
	end
end



local enehudhide = 0
addHook("MapLoad", do
	if (mapheaderinfo[gamemap].starzone) then
		for player in players.iterate do
			enehudhide = 0
			AirMan.Init(player)
			AirMan.Enable(player)
			-- Failsafe check
			player.NotOnTheAirAnymore = false
		end
	elseif not (mapheaderinfo[gamemap].starzone) then
		for player in players.iterate do
			if (player.NotOnTheAirAnymore == false or nil)
				player.NotOnTheAirAnymore = true
				AirMan.Disable(player)
				--player.pflags = $1&~PF_FORCESTRAFE
				--COM_BufInsertText(server, "allowjoin 0")
			end
		end
	end
end)

----------------------------------------------------

local function calculate_hp_stat(player)
	if not(player.mo)
		return(nil)
	elseif(player.powers[pw_carry])
		return(nil)
	elseif(player.mo.skin == "tails_guy")
		return(nil)
	else
		local s = skins[player.mo.skin]
		local hp = 20
		if(s.ability == CA_GLIDEANDCLIMB)
			hp = $ + 1
		end
		if(s.ability2 == CA2_MULTIABILITY)
			hp = $ - 1
		end
		return(hp)
	end
end

--Initiate variables
addHook("MapLoad", function()
	if (mapheaderinfo[gamemap].starzone) then
		for player in players.iterate do
			player.hp_max = calculate_hp_stat(player)
			player.hp = player.hp_max
		end
	end
end, MT_PLAYER)

addHook("ThinkFrame", function()
	if (mapheaderinfo[gamemap].starzone) then
		for player in players.iterate do
			--Calculate Max HP
			if(player.mo)
				player.hp_max = calculate_hp_stat(player)
			end
			--Correct the HP value
			if(player.hp_max)
				if(player.hp == nil) or(player.hp == 0 and player.mo and player.mo.health > 0)
					player.hp = player.hp_max
				elseif not(player.mo) or(player.mo.health == 0)
					player.hp = 0
				else
					player.hp = min($,player.hp_max)
				end
			else
				player.hp_max = nil
				player.hp = nil
			end
			--Handle health-ups
			if(player.healthprev and player.hp)
				and(player.health >= player.healthprev + 10)
				player.hp = min(player.hp_max,$+1)
			end
			player.healthprev = player.health
		end
	end
end)

-- Fake Damage
addHook("MobjDamage", function(mobj, source, attacker, notused)
	if (mapheaderinfo[gamemap].starzone) then
		if(mobj.valid) and(mobj.player.hp) and not(mobj.player.powers[pw_super])
			-- Inflict damage and remove items
			mobj.player.hp = $1 - 1
			if mobj.player.hp > 0 // Non-shield non-fatal damage
				if not(skins[mobj.skin].soundsid[SKSPLPAN1] == skins["sonic"].soundsid[SKSPLPAN1])
					S_StartSound(mobj,sfx_altow1)
				else
					S_StartSound(mobj, sfx_s3k35)
				end
			mobj.player.powers[pw_flashing] = 50	// Set invuln flashing
			else
				mobj.health = 0
				mobj.player.health = 0
				P_KillMobj(mobj) //Non-shield fatal damage
			end
			return true
		else
			return false
		end
	end
end, MT_PLAYER)

-----------------------------------------------------------------------------


--````````````````````````````````````
-- MAP
--````````````````````````````````````

rawset(_G, "GMAP", {})

------------------------------------------------------------------------------------
-- MAP ITERATING MANAGEMENT
------------------------------------------------------------------------------------

rawset(_G, "ThingList", {})
rawset(_G, "MapThingList", {})
rawset(_G, "LineList", {})
rawset(_G, "SectorList", {})

-- ThingList
local mobj_iteratelist = {
	--[[MT_BLUECRAWLA,
	MT_REDCRAWLA,

	MT_CYBRAKDEMON,]]
	--MT_JETTBOMBER,
	--MT_MINESOARER,
	MT_EXPSTAR,
	MT_YLW_ORB
}

-- MapThingList
local mobj_mapthinglist_iteratelist = {
	MT_STARGENESIS_PULL,
	MT_ALTSKYBOX
}


for i=1, #mobj_iteratelist do
	addHook("MobjSpawn", function(mo)
		if (mapheaderinfo[gamemap].starzone) then
			table.insert(ThingList, mo)
			--print("added object type: "..tostring(mo.type).." of "..tostring(mo))
		end
	end, mobj_iteratelist[i])

	addHook("MobjRemoved", function(mo)
		if (mapheaderinfo[gamemap].starzone) then
			for i=1, #ThingList do
				if ThingList[i] == mo then
					table.remove(ThingList, i)
					break
				end
			end
		end
		--print("removed object type: "..tostring(mo.type).." of "..tostring(mo))
	end, mobj_iteratelist[i])
end

for i=1, #mobj_mapthinglist_iteratelist do
	addHook("MobjSpawn", function(mo)
		if (mapheaderinfo[gamemap].starzone) then
			table.insert(MapThingList, mo)
			--print("added object type: "..tostring(mo.type).." of "..tostring(mo))
		end
	end, mobj_mapthinglist_iteratelist[i])

	addHook("MobjRemoved", function(mo)
		if (mapheaderinfo[gamemap].starzone) then
			for i=1, #MapThingList do
				if MapThingList[i] == mo then
					table.remove(MapThingList, i)
					break
				end
			end
		end
		--print("removed object type: "..tostring(mo.type).." of "..tostring(mo))
	end, mobj_mapthinglist_iteratelist[i])
end



addHook("MapLoad", do
	if (mapheaderinfo[gamemap].starzone) then
		for line in lines.iterate do
			table.insert(LineList, line)
		end
		for sector in sectors.iterate do
			table.insert(SectorList, sector)
		end
	end
end)
addHook("MapChange", do
	MapThingList = {}
	ThingList = {}
	LineList = {}
	SectorList = {}
end)




function GMAP.SetLinedefEffects()
	for i=1, #LineList do
		local line = LineList[i]
		-- GALAXY ROLL
		if line.frontside.special == 509
			line.frontside.textureoffset = $1 + 6*FRACUNIT/32
			line.frontside.rowoffset = $1 + 3*FRACUNIT/32
		end
		if line.frontside.special == 508
			line.frontside.textureoffset = $1 - 6*FRACUNIT/32
			line.frontside.rowoffset = $1 - 3*FRACUNIT/32
		end
		-- ABSORPTION
		if line.tag == 5050
			line.frontside.textureoffset = $1 - 1*FRACUNIT/2
		end
		if line.tag == 5051
			line.frontside.textureoffset = $1 + 1*FRACUNIT/2
		end
		if line.tag == 5052
			line.frontside.textureoffset = $1 - 1*FRACUNIT/4
		end
		if line.tag == 5053
			line.frontside.textureoffset = $1 + 1*FRACUNIT/4
		end
		-- UNIVERSE WAVE
		if line.tag == 5080
			line.backside.textureoffset = $1 - 1*FRACUNIT/8
		end
		if line.tag == 5081
			line.backside.textureoffset = $1 + 1*FRACUNIT/8
		end
	end
end
-----------------------------------------------------------------------------



--````````````````````````````````````
-- HUD
--````````````````````````````````````
--local function airmanhud(v, player, cam)
EVM_HUD["airmanHud"] = {z_index = 45, func =
function(v, player, cam)
	if (mapheaderinfo[gamemap].starzone or mapheaderinfo[gamemap].starzonecut) then
		if player.awayviewmobj then -- or player.mo.cam
			--v.drawString(20, 158, "PlayerList Count: "..#PlayerList, V_ALLOWLOWERCASE|V_MONOSPACE, "left")
			--v.drawString(20, 158, "ThingList Count: "..#ThingList, V_ALLOWLOWERCASE|V_MONOSPACE, "left")
		end


		-- Hide P Hud (scroll)
		if (player.hudOptions.hidden) then
			player.hudOptions.hideValue = min($1+4, 32)
		else
			player.hudOptions.hideValue = max($1-4, 0)
		end
		--TODO does not work, undo or fix
		-- Hide P Hud (scroll)
		if (EnemyHud("starlis").hide) then
			enehudhide = min($1+1, 10)
		else
			enehudhide = max($1-1, 0)
		end

		if not (player.hudOptions.hidden) then
			if not player.hp then return end -- temporary fix, do not keep
			--
			local P_HP_X, P_HP_Y = 2,176+player.hudOptions.hideValue
			if (splitscreen and player == players[1]) -- Salt: splitscreen support
				P_HP_Y = $1-100
			end
			local P_HELD_MAX = 37
			local PHP_WINDOW = v.cachePatch("PHPWIND")
			local PHP_WINDOW_GLASS = v.cachePatch("PHPGLASS")
			local PHP_HEALTH_GLASS = v.cachePatch("PHPBGLAS")

			--local flagsP =  V_SNAPTOTOP|V_SNAPTOLEFT
			--local flagsB =  V_SNAPTOTOP|V_SNAPTORIGHT

			local P_LIFEICO_Y = P_HP_Y+179*FRACUNIT+player.hudOptions.hideValue*FRACUNIT
			if (splitscreen and player == players[1])
				P_LIFEICO_Y = $1-100*FRACUNIT
			end

			--v.drawScaled(7*FRACUNIT, 179*FRACUNIT, FRACUNIT/3, v.cachePatch(skins[player.mo.skin].face), 0,
			local face = v.getSprite2Patch(player.mo.skin, SPR2_XTRA, false, 0, 0)
			v.drawScaled(P_HP_X+7*FRACUNIT, P_LIFEICO_Y + (FRACUNIT/2), FRACUNIT/3, face, 0,
						v.getColormap(player.mo.skin, player.mo.color))
			v.drawString(P_HP_X+68, P_HP_Y+6, "x"+player.lives, V_ALLOWLOWERCASE, "left")
			v.draw(P_HP_X, P_HP_Y, PHP_WINDOW_GLASS, V_50TRANS, v.getColormap(player.mo.skin, player.mo.color))
			v.draw(P_HP_X, P_HP_Y, PHP_WINDOW, 0, v.getColormap(player.mo.skin, player.mo.color))
			v.drawFill(P_HP_X+20, P_HP_Y+4, player.hp*P_HELD_MAX/player.hp_max+(1/2), 10, 160)
			v.draw(P_HP_X, P_HP_Y, PHP_HEALTH_GLASS, V_60TRANS)

			if player --and not splitscreen
				local skinname = skins[player.mo.skin].realname -- Sal: Display proper name
				if skinname:len() > 5 then
					v.drawString(P_HP_X+3, P_HP_Y-9, skinname, V_MONOSPACE, "thin")
				else
					v.drawString(P_HP_X+3, P_HP_Y-9, skinname, V_MONOSPACE, "left")
				end
			end


			-- ENEMY
			local BOSS_HP_X,BOSS_HP_Y = 164+enehudhide,158+enehudhide
			local HELD_MAX = 104 --Width
			local BOSS_WINDOW = v.cachePatch("BSWIND")
			local BOSS_WINDOW_GLASS = v.cachePatch("BSGLASSP")
			local BOSS_WINDOW_SNAPIN = v.cachePatch("BSSNAPIN")
			local BOSS_HEALTH_GLASS = v.cachePatch("BSHGLAS")

			if ThingList then
				for i=1, #ThingList do
					if ThingList[i].type == MT_EXPSTAR then
						local mo = ThingList[i]
						--local healthbar = (mo.health - 1)%100
						--v.drawFill(BOSS_HP_X, BOSS_HP_Y, healthbar, 3, 208)
						if (mo.hurtc) then
							BOSS_HP_Y = $1-leveltime%4
						end

						v.draw(BOSS_HP_X, BOSS_HP_Y, BOSS_WINDOW, 0)
						v.draw(BOSS_HP_X, BOSS_HP_Y, BOSS_WINDOW_GLASS, V_10TRANS)
						if mo != dmghealthref then
							rawset(_G, "dmghealthref", mo)
							rawset(_G, "dmghealth", mo.health)
						elseif dmghealth < mo.health and not mo.hurtc then
							dmghealth = $ + 1
						elseif dmghealth > mo.health and not mo.hurtc then
							dmghealth = $ - 4
						end

						-- Health Draw
						if (dmghealth > mo.health) then
							v.drawFill(BOSS_HP_X+36, BOSS_HP_Y+20, dmghealth*HELD_MAX/mo.info.spawnhealth+(1/2), 8, 87)
						end
						v.drawFill(BOSS_HP_X+36, BOSS_HP_Y+20, mo.health*HELD_MAX/mo.info.spawnhealth+(1/2), 8, 208)
						-- Fill bar rapidly display
						if (mo.hpfill and mo.hpfill.enabled == true and mo.hpfill.count > 0) then
							v.draw(BOSS_HP_X, BOSS_HP_Y, BOSS_WINDOW, 0)
							v.drawFill(BOSS_HP_X+36, BOSS_HP_Y+20, mo.hpfill.count*HELD_MAX/mo.info.spawnhealth+(1/2), 8, 208)
						end
						-- Snap-in window
						v.draw(BOSS_HP_X, BOSS_HP_Y, BOSS_HEALTH_GLASS, V_70TRANS)
						v.draw(BOSS_HP_X, BOSS_HP_Y, BOSS_WINDOW_SNAPIN, 0)
						if mo and mo.name
							if mo.name:len() > 13 then
								v.drawString(BOSS_HP_X+142,BOSS_HP_Y+4, mo.name, V_ALLOWLOWERCASE|V_MONOSPACE, "thin-right")
							else
								v.drawString(BOSS_HP_X+142,BOSS_HP_Y+4, mo.name, V_ALLOWLOWERCASE|V_MONOSPACE, "right")
							end
						else
							v.drawString(BOSS_HP_X+142,BOSS_HP_Y+4, "Boss", V_ALLOWLOWERCASE|V_MONOSPACE, "right")
						end
					end
				end
			end
		end

		--[[if (player.mo.Wipe and player.mo.Wipe.dest < 10) then
			local wipe = player.mo.Wipe
			v.drawScaled(v.width()/2, v.height()/2, v.dupx()*FRACUNIT, v.cachePatch((wipe.pic) or "WFILL"), wipe.dest<<V_ALPHASHIFT)
		end]]

		--[[ Unfortunately, SRB2 now puts a big dumbass "GAME PAUSED" on top of this... :(
		if (paused) then
			local pauseLeftX, pauseLeftY = 64,54

			if (EVPAUSE and EVPAUSE.currentMainEntry) then
				v.drawScaled(0, 0, FRACUNIT/2, v.cachePatch("PAUSEBG"), 0)

				--v.drawString(pauseLeftX, pauseLeftY, EVPAUSE.PauseInfoList("star_01d_entry").entry, V_ALLOWLOWERCASE, "left")
				v.drawString(pauseLeftX, pauseLeftY-1, EVPAUSE.currentMainEntry.entry, V_ALLOWLOWERCASE|V_GRAYMAP|V_40TRANS, "left")
				v.drawString(pauseLeftX, pauseLeftY, EVPAUSE.currentMainEntry.entry, V_ALLOWLOWERCASE, "left")
			end
		end
		--]]
	end
end
}
--hud.add(airmanhud, "game")
------------------------------------------------------------------------








event.newevent("SetView",
function(player,v)
	while true
		if (player.mo and player.mo.valid) and (player.mo.cam and not (player.mo.cam.override))
			CAMERA:SetEye(player, maplocation("MAINFIELD_VIEWPOINT"), 0)
			CAMERA:UnsetEye(player, 0)
		end
		wait(0)
	end
end)

addHook("PlayerSpawn", function(player)
	if (mapheaderinfo[gamemap].starzone)
	and (player.mo and player.mo.valid) then
		player.mo.flags = $1|MF_NOGRAVITY
	end
end)
addHook("MobjDeath", function(target, inflictor, source)
	if not (mapheaderinfo[gamemap].starzone) then return end
	target.player.lives = $1-1
	--target.flags = $1|MF_NOCLIP
	target.player.pflags = $1|PF_NOCLIP
	target.player.pflags = $1|PF_FULLSTASIS
	target.flags = $1&~MF_SOLID
	P_StartQuake(32*FRACUNIT, 5)
	local explode = P_SpawnMobj(target.x, target.y, target.z, MT_EXPLODE)
	local ejectedPlayer = P_SpawnMobj(target.x, target.y, target.z, MT_STARGENESIS_PULL)
	--ejectedPlayer.sprite = SPR_PLAY--skins[target.skin]
	ejectedPlayer.skin = target.skin
	ejectedPlayer.state = mobjinfo[MT_PLAYER].deathstate
	--ejectedPlayer.state = skins[target.skin]
	ejectedPlayer.color = target.color
	ejectedPlayer.scale = 1*FRACUNIT/8
	ejectedPlayer.flags = $1|MF_SOLID
	ejectedPlayer.flags = $1&~MF_NOGRAVITY
	ejectedPlayer.momz = 3*FRACUNIT
	ejectedPlayer.fuse = 10*TICRATE
	explode.scale = 4*FRACUNIT
	S_StartSoundAtVolume(nil, sfx_s3k66, 100)
	--target.momy = -32*FRACUNIT
	--target.momz = -16*FRACUNIT
	return true
end, MT_PLAYER)

local views = {}

-- Hook
addHook("ThinkFrame", do

	if (mapheaderinfo[gamemap].starzonecut) then
		for player in players.iterate do
			CreateCustomPlayerCamera(player.mo)
			IndPlayerScreenWipe(player)
			player.awayviewaiming = server.awayviewaiming

			-- Stop pressing F3.
			COM_BufInsertText(player, "showhud 1")
		end
	end

	if (mapheaderinfo[gamemap].starzone) then

		--COM_BufInsertText(server, "allowjoin 0")

		GMAP.SetLinedefEffects()

		-- Extra Mobj Settings
		if MapThingList then
			for i=1, #MapThingList do
				local mo = MapThingList[i]

				if mo.type == MT_STARGENESIS_PULL then
					if (mo.cusval == 1) then
						P_SpawnGhostMobj(mo)
					end
				end
			end
		end

		if SectorList then
			for i=1, #SectorList do
				local sector = SectorList[i]

				--sector.floorheight = $1-1*FRACUNIT/2
				--sector.ceilingheight = $1-1*FRACUNIT/2
			end
		end

		for player in players.iterate

			--Camera aiming fix
			player.awayviewaiming = server.awayviewaiming

			-- Stop pressing F3.
			COM_BufInsertText(player, "showhud 1")

			CreateCustomPlayerCamera(player.mo)
			IndPlayerScreenWipe(player)

			player.mo.state = S_STARGENESIS_PLAYER

			if (player.playerstate == PST_LIVE) then
				if (leveltime % 2 == 0) then
					player.mo.dust = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_STARGENESIS_PULL)
					player.mo.dust.sprite = SPR_CTHK
					player.mo.dust.frame = A|TR_TRANS50
					player.mo.dust.color = SKINCOLOR_PINK
					player.mo.dust.scale = FRACUNIT/2
					player.mo.dust.destscale = 0
					player.mo.dust.scalespeed = FRACUNIT/16
					player.mo.dust.momy = -16*FRACUNIT
					player.mo.dust.fuse = 10
				end
			end

			if not (player.air and player.air.enabled) then
				--print("no air")
				continue
			end

			if not (player.mo.EVENTHOOKS) then
				player.mo.EVENTHOOKS = true
				--event.beginEvent("SetView", player, player)
				event.beginEvent("SetView", player, views[#player]) -- Salt: aa i try to fix netcode issues; doing this shouldn't break things since funcs aren't synced anyways, in theory should just remove a "can't sync this" warning
			end

			P_MoveOrigin(player.mo, player.mo.x, 0*FRACUNIT, player.mo.z)

			if player.playerstate == PST_REBORN
				--print("reborn")
				player.mo.EVENTHOOKS = nil
				player.mo.momx = 0
				player.mo.momy = 0
				player.mo.momz = 0
				player.air.retmark.flags2 = $1&~MF2_DONTDRAW
				player.air.retbox.flags2 = $1&~MF2_DONTDRAW
				--player.mo.flags = $1&~MF_NOCLIP
			end

			if player.playerstate == PST_DEAD
				player.mo.momx = 0
				player.mo.momz = 0
				player.air.retmark.flags2 = $1|MF2_DONTDRAW
				player.air.retbox.flags2 = $1|MF2_DONTDRAW
				--player.mo.flags = $1|MF_NOCLIP
				-- DO NOT ALLOW CONTROL WHEN DEAD (STOP DRIFTING, PLEASE)
				player.pflags = $1|PF_FULLSTASIS
				--player.deadtimer = 0
			end

			player.mo.flags = $1|MF_NOGRAVITY
			player.mo.angle = ANGLE_90

			-- Sal: I like seeing more of the angles, but we want to mostly face forward.
			player.drawangle = R_PointToAngle2(0, 0, player.mo.momx, 3*SPEEDLIMIT)

			if player.awayviewmobj and not player.awayviewmobj.override
			or player.awayviewmobj and (player.awayviewmobj.override and player.awayviewmobj.ctrl)
			and not (player.playerstate == PST_DEAD) then
				AirMan.SetAirControl(player)
				AirMan.ToggleFrontRet(player, true)
				AirMan.checkawayviewbounds(player)
				AirMan.RetControl(player)

				player.air.retbox.fuse = 10
				player.air.retmark.fuse = 10

				player.air.retbox.drawonlyforplayer = player -- Sal: clientside the ret
				player.air.retmark.drawonlyforplayer = player

				AirMan.MultiplayerOutline(player) -- Sal: add color outline

				player.pflags = $1&~PF_FULLSTASIS
				--player.mo.state = S_PLAY_SUPERFLY1
				if (player.cmd.buttons & BT_JUMP)
					if ((leveltime*2) % 5 < 2)

						P_SpawnXYZMissile(player.mo, player.air.retmark, MT_STAR_BULLET, player.mo.x, player.mo.y, player.mo.z)
						--S_StartSoundAtVolume(nil, Snd("SE_KR_HIT1"), 12)
						--S_StartSoundAtVolume(nil, sfx_wdrip6, 22)
					end
				end

			else
				-- DO NOT ALLOW CONTROL WHEN DEAD (STOP DRIFTING, PLEASE)
				player.pflags = $1|PF_FULLSTASIS
				player.mo.momx = 0
				player.mo.momz = 0
				player.air.retbox.fuse = 10
				player.air.retmark.fuse = 10
				--print("no camera for "..player.name)
			end
		end
	end
end)

