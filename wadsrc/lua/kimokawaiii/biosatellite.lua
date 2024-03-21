--Allows Players to move at a speed of 60 if they are runnning.
local function charge(line, mo)
	if not (mapheaderinfo[gamemap].chargesmoke)
		return
	end

	local defspeed = skins[mo.skin].normalspeed

	if 3*defspeed/2 < 60*FRACUNIT and mo.player.speed > skins[mo.skin].runspeed
		mo.player.normalspeed = 60*FRACUNIT
		mo.player.supercharge = true
	end

	if 3*defspeed/2 >= 60*FRACUNIT and mo.player.speed > skins[mo.skin].runspeed
		mo.player.normalspeed = 3*skins[mo.skin].normalspeed/2
		mo.player.supercharge = true
	end

	if mo.player.speed >= defspeed and defspeed <= skins[mo.skin].runspeed
		mo.player.normalspeed = 60*FRACUNIT
		mo.player.acceleration = $ * 3
		mo.player.supercharge = true
		mo.player.runcount = 3*TICRATE
	end
end

addHook("MapLoad", do
	for p in players.iterate do
		p.supercharge = false
		p.oldspeed = 0
		p.runcount = 0
	end
end)

local function smokeinit(mo)
	mo.frame = $1 |TR_TRANS40
	mo.fuse = TICRATE
end
--Spawn Particles if charging or revert stats if not.
addHook("PlayerThink", function(p)
	if not (mapheaderinfo[gamemap].chargesmoke)
		return
	end

	if not (p.mo and p.mo.valid)
		return
	end

	local defspeed = skins[p.mo.skin].normalspeed
	local defaccel = skins[p.mo.skin].acceleration

	if p.runcount != nil and p.runcount > 0
		p.runcount = $ - 1
	end

	if p.supercharge == true
	and p.speed > skins[p.mo.skin].runspeed
	and p.playerstate != PST_DEAD
	and (leveltime % 2 == 0)
	and (tonumber(mapheaderinfo[gamemap].chargesmoke) == 1)
		smokeinit(P_SpawnMobj(p.mo.x, p.mo.y, p.mo.z, MT_PARTICLE))
		smokeinit(P_SpawnMobj(p.mo.x, p.mo.y, p.mo.z+48*FRACUNIT, MT_PARTICLE))
		smokeinit(P_SpawnMobj(p.mo.x-FixedMul(32*FRACUNIT, cos(p.mo.angle+FixedAngle(90*FRACUNIT))), p.mo.y-FixedMul(32*FRACUNIT, sin(p.mo.angle+FixedAngle(90*FRACUNIT))), p.mo.z+32*FRACUNIT, MT_PARTICLE))
		smokeinit(P_SpawnMobj(p.mo.x+FixedMul(32*FRACUNIT, cos(p.mo.angle+FixedAngle(90*FRACUNIT))), p.mo.y+FixedMul(32*FRACUNIT, sin(p.mo.angle+FixedAngle(90*FRACUNIT))), p.mo.z+32*FRACUNIT, MT_PARTICLE))
	end

	if p.supercharge == true and (p.speed <= skins[p.mo.skin].runspeed and p.runcount == 0)
		p.supercharge = false
		p.normalspeed = defspeed
		p.acceleration = defaccel
	end
end)


--Execute linedef trigger with tag of front X offset.
local function chargeBreak(line, toucher)
	local mo = toucher.player
		if mo.supercharge == true
		P_LinedefExecute(sides[line.sidenum[0]].textureoffset/FRACUNIT)
		return true
	end
	if mo.supercharge == false
		return true
	end
end

addHook("LinedefExecute", charge, "STRTCHRG")
addHook("LinedefExecute", chargeBreak, "CHRGBRK")
