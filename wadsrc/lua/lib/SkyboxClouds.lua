/*
Skybox Clouds
	by Lach

You may reuse this script in your own maps! Please do not edit it.

v1
*/

--[[
HOW TO USE:

Include a copy of this script in your addon.
In your level header, you may fill out the following:

Lua.SBC_NumClouds = n
Lua.SBC_CloudState = S_YOURSTATE
Lua.SBC_MinHeight = f
Lua.SBC_MaxHeight = f
Lua.SBC_MinDistance = f
Lua.SBC_MaxDistance = f
Lua.SBC_CloudSpeed = f
Lua.SBC_CloudScale = f
Lua.SBC_SkyboxID = n

Instances of n should be replaced with integers of your choosing.
Instances of f can include decimal points up to 4 places. (These will be converted to FRACUNITs, e.g. 0.5 will become FRACUNIT/2.)
Specifying SBC_CloudState will signal that clouds should be spawned in this map.
The clouds will be spawned around the Skybox View Point in your map.
This can be specified with SBC_SkyboxID, otherwise the first Skybox View Point found will be used.
All other values will default to 0 if not given (except SBC_CloudScale, which defaults to 1).
]]--

if SkyboxClouds
	return
end

rawset(_G, "SkyboxClouds", true)

freeslot("MT_SKYBOXCLOUD")

mobjinfo[MT_SKYBOXCLOUD] = {
	spawnstate = S_NULL,
	radius = 16*FRACUNIT,
	height = 16*FRACUNIT,
	flags = MF_SCENERY|MF_NOCLIP|MF_NOCLIPTHING|MF_NOCLIPHEIGHT|MF_NOBLOCKMAP|MF_NOGRAVITY
}

local PI = 355*FRACUNIT/113 // Zu Chongzi approximation

local function SBC_NumError()
	return "A Skybox Clouds parameter for "..G_BuildMapName(gamemap).." was not an identifiable number"
end

local function ParseDecimal(str)
	if str == nil
		return 0
	end

	local point
	local decimal
	local integer = tonumber(str)

	if integer ~= nil // no decimal point? free real estate
		return integer*FRACUNIT
	end

	point = str:find('.', 1, true) or str:find(',', 1, true)

	assert(point ~= nil, SBC_NumError())

	integer = tonumber(str:sub(1, point - 1))
	decimal = str:sub(point + 1, point + 4)
	decimal = tonumber($ .. (("0"):rep(4 - $:len())))

	assert(integer ~= nil and decimal ~= nil, SBC_NumError())

	return integer*FRACUNIT + decimal*FRACUNIT/10000
end

addHook("MapLoad", function(num)
	local map = mapheaderinfo[num]
	if map and map.sbc_cloudstate
		local mindistance = ParseDecimal(map.sbc_mindistance)
		local minheight = ParseDecimal(map.sbc_minheight)
		local distance = ParseDecimal(map.sbc_maxdistance) - mindistance
		local height = ParseDecimal(map.sbc_maxheight) - minheight
		local scale = ParseDecimal(map.sbc_cloudscale) or FRACUNIT
		local speed = ParseDecimal(map.sbc_cloudspeed)
		local state = _G[map.sbc_cloudstate]
		local id = tonumber(map.sbc_skyboxid)
		local skybox

		for mt in mapthings.iterate
			if mt.type == mobjinfo[MT_SKYBOX].doomednum
			and (id == nil or id == mt.extrainfo)
				skybox = mt.mobj
				break
			end
		end

		assert(skybox and skybox.valid, "No Skybox View Point" .. (id == nil and "" or (" with id " .. id)) .. " found in map " .. num)

		for i = 1, tonumber(map.sbc_numclouds) or 0
			local dist = mindistance + FixedMul(distance, P_RandomFixed())
			local cloud = P_SpawnMobj(skybox.x, skybox.y, skybox.z, MT_SKYBOXCLOUD)

			cloud.target = skybox
			cloud.scale = scale
			cloud.state = state
			cloud.angle = FixedAngle(P_RandomKey(360)*FRACUNIT)
			P_SetOrigin(cloud,
				cloud.x + P_ReturnThrustX(cloud, cloud.angle, dist),
				cloud.y + P_ReturnThrustY(cloud, cloud.angle, dist),
				minheight + FixedMul(height, P_RandomFixed()))
			cloud.movefactor = speed
			cloud.movedir = INT32_MAX / (2*FixedMul(PI, dist) / speed) * 2
			cloud.angle = $ + ANGLE_90
		end
	end
end)

addHook("MobjThinker", function(mo)
	P_InstaThrust(mo, mo.angle, mo.movefactor)
	mo.angle = $ + mo.movedir
end, MT_SKYBOXCLOUD)