// --------------------------------------
// LUA_AOSM
// Acceleration of Soniguri Map background
// --------------------------------------
freeslot("MT_AOSMAPPOINT", "MT_AOSMAPFOLLOWPOINT", "S_AOSMAPPOINT")

local maxviewangle = 34*FRACUNIT

addHook("MapLoad", function()
	if not(server and server.valid)
		return
	end
	server.mapfollowpoints = {}
	server.numfollowpoints = 0
	for point in mobjs.iterate()
		if(point.type == MT_AOSMAPFOLLOWPOINT)
			server.mapfollowpoints[server.numfollowpoints] = point
			server.numfollowpoints = $1 + 1
		end
	end
end)
/*addHook("MobjSpawn", function(mobj)
	if not(server and server.valid)
		return
	end
	server.mapfollowpoints[server.numfollowpoints] = mobj
	server.numfollowpoints = $1 + 1
end, MT_AOSMAPFOLLOWPOINT)*/

local speed = 5*FRACUNIT
addHook("MobjThinker", function(mobj)
	if not(server and server.valid)
		return
	end

	if(server.aoscamscale == nil)
		return
	end
	if(mobj.lockx == nil)
		mobj.lockx = mobj.x
	end
	if(mobj.locky == nil)
		mobj.locky = mobj.y
	end
	if(mobj.lockz == nil)
		mobj.lockz = mobj.z
	end
	if(mobj.angleto == nil)
		mobj.angleto = mobj.angle
	end
	if(mobj.angleview == nil)
		or(server.aostimer and (server.aostimer == 180*TICRATE or server.aostimer == (180*TICRATE)-1))
		mobj.angleview = 0
	end
	if(server.gamemode == 6)
		mobj.angleview = FixedAngle(50*FRACUNIT)
	end
	if not(server.numfollowpoints)
		mobj.angleto = $1 + FixedAngle((2*FRACUNIT)/7)
//		mobj.angle = mobj.angleto
	end
	mobj.angleview = $1 + FixedAngle((2*FRACUNIT)/20)
	if(mobj.angleview > FixedAngle(90*FRACUNIT))
		mobj.angleview = FixedAngle(90*FRACUNIT)
	end
	for player in players.iterate
		player.awayviewmobj = mobj
		player.awayviewtics = 1
		player.awayviewaiming = FixedAngle(FixedMul(sin(mobj.angleview), maxviewangle))
	end

	// Follow the path!
	if(server.numfollowpoints)
		if(mobj.followpoint == nil)
			mobj.followpoint = server.mapfollowpoints[AngleFixed(mobj.angle)/FRACUNIT]
		end
		if(mobj.nextfollowpoint == nil)
			mobj.nextfollowpoint = server.mapfollowpoints[AngleFixed(mobj.followpoint.angle)/FRACUNIT]
		end
		if(mobj.followdist == nil)
			mobj.followdist = 0
		end
		local disttonextpoint = R_PointToDist2(mobj.followpoint.x, mobj.followpoint.y, mobj.nextfollowpoint.x, mobj.nextfollowpoint.y)
		local angletonextpoint = R_PointToAngle2(mobj.followpoint.x, mobj.followpoint.y, mobj.nextfollowpoint.x, mobj.nextfollowpoint.y)
		local angle2nextpoint = R_PointToAngle2(0, mobj.followpoint.z, disttonextpoint, mobj.nextfollowpoint.z)
		mobj.followdist = $1 + speed
		if(mobj.followdist >= disttonextpoint)
			mobj.followpoint = mobj.nextfollowpoint
			mobj.nextfollowpoint = server.mapfollowpoints[AngleFixed(mobj.followpoint.angle)/FRACUNIT]
			mobj.followdist = $1 - disttonextpoint
		end
		// Teleport the object to the place
		local offx = FixedMul(FixedMul(cos(angletonextpoint), mobj.followdist), cos(angle2nextpoint))
		local offy = FixedMul(FixedMul(sin(angletonextpoint), mobj.followdist), cos(angle2nextpoint))
		local offz = FixedMul(sin(angle2nextpoint), mobj.followdist)
		P_MoveOrigin(mobj, mobj.followpoint.x + offx, mobj.followpoint.y + offy, mobj.followpoint.z + offz)
		if(mobj.anglethree == nil)
			mobj.anglethree = angletonextpoint
		end

		local extrafollowpoint = server.mapfollowpoints[AngleFixed(mobj.nextfollowpoint.angle)/FRACUNIT]
		local extraangle = R_PointToAngle2(mobj.nextfollowpoint.x, mobj.nextfollowpoint.y, extrafollowpoint.x, extrafollowpoint.y)
		local angledif = AngleFixed(extraangle)-AngleFixed(angletonextpoint)
		if(angledif > 180*FRACUNIT)
			angledif = 360*FRACUNIT - angledif
		end
		local turnspeed = abs(FixedMul(angledif, FixedDiv(speed, disttonextpoint)))

		if(AngleFixed(angletonextpoint-mobj.anglethree) < turnspeed)
			mobj.anglethree = angletonextpoint
		else
			local addmul = 1
			if(abs((AngleFixed(angletonextpoint)%(360*FRACUNIT))-(AngleFixed(mobj.anglethree)%(360*FRACUNIT))) > 180*FRACUNIT)
				addmul = -1
			end

			if(AngleFixed(angletonextpoint)%(360*FRACUNIT) > AngleFixed(mobj.anglethree)%(360*FRACUNIT))
				mobj.anglethree = $1 + (FixedAngle(turnspeed)*addmul)
			else
				mobj.anglethree = $1 - (FixedAngle(turnspeed)*addmul)
			end
		end
		// Hacky fix for overshooting our desired angle
		if(AngleFixed(angletonextpoint-mobj.anglethree) < turnspeed)
			mobj.anglethree = angletonextpoint
		end
		mobj.angleto = $1 + FixedAngle((2*FRACUNIT)/3)
		mobj.angle = mobj.anglethree + FixedAngle(FixedMul(sin(mobj.angleto), maxviewangle/3))
	end

	// Move back the further pulled back the camera is!
	local dist = server.aoscamscale*160/2
	if(server.gamemode == 6)
		dist = 34*FRACUNIT
	end
	local xdist = FixedMul(cos(server.awayviewaiming), FixedMul(cos(mobj.angle), dist))
	local ydist = FixedMul(cos(server.awayviewaiming), FixedMul(sin(mobj.angle), dist))
	local zdist = FixedMul(sin(server.awayviewaiming), dist)
	P_MoveOrigin(mobj, mobj.lockx+xdist, mobj.locky+ydist, mobj.lockz+zdist)

	if(server.gamemode == 6)
		P_MoveOrigin(mobj, mobj.lockx+xdist, mobj.locky+ydist, mobj.lockz+(FRACUNIT*60)+zdist)
	end
end, MT_AOSMAPPOINT)
