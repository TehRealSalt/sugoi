-- LUA_SSN
-- map specific Lua to make the skybox look flashy. literally.

local skybox

addHook("MapLoad", function(n)
	if not mapheaderinfo[n].dvdss6 return end
	for c in mapthings.iterate
		if not c continue end
		if c.type ~= mobjinfo[MT_SKYBOX].doomednum
			continue -- no
		end
		skybox = c.mobj
	end
end)

addHook("NetVars", function(net)
	skybox = net(skybox)
end)

addHook("ThinkFrame", do
	if not mapheaderinfo[gamemap].dvdss6 return end

	if not skybox or not skybox.valid return end
	for i = 1,8
		local rang = P_RandomRange(0, 360)*ANG1	-- random angle
		local randomz = P_RandomRange(10, 160)*FRACUNIT	-- abs z

		local x, y = skybox.x + 800*cos(rang), skybox.y + 800*sin(rang)
		local prt = P_SpawnMobj(x, y, randomz, MT_DVDPARTICLE)
		prt.color = P_RandomRange(1, 24)
		prt.scale = FRACUNIT*3
	end
end)
