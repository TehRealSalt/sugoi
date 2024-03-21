// --------------------------------
// LUA_BALL
// The thing that makes balls bouncy
// Bouncing rewritten for 2.2 since
// it broke, for some reason.
// --------------------------------
 local function IsDirChar(player)
	if not(player.pflags & PF_DIRECTIONCHAR)
		or(player.climbing) // stuff where the direction is forced at all times
		or((player.pflags & PF_ANALOGMODE) or twodlevel or (player.mo.flags2 & MF2_TWOD)) // keep things synchronised up there, since the camera IS seperate from player motion when that happens
		or(G_RingSlingerGametype()) // no firing rings in directions your player isn't aiming
		return false
	end
	return true
end

addHook("PlayerSpawn", function(player)
    if(player.mo and player.mo.valid)
		if(mapheaderinfo[gamemap].sugoigolfmode)
			player.golfmode = true
		elseif(player.golfmode)
			player.charability2 = skins[player.mo.skin].ability2
			player.jumpfactor = skins[player.mo.skin].jumpfactor
			player.normalspeed = skins[player.mo.skin].normalspeed
			player.thrustfactor = skins[player.mo.skin].thrustfactor
			player.mindash = skins[player.mo.skin].mindash
			player.maxdash = skins[player.mo.skin].maxdash
			player.golfmode = false
        end
    end
end)

addHook("MobjThinker", function(mo)
	if not(mapheaderinfo[gamemap].sugoigolfmode)
		return
	end
	if(mo.player and mo.player.valid)
		local player = mo.player
		if(player.slprevflags == nil)
			player.slprevflags = player.pflags
		end
		player.charability2 = CA2_SPINDASH
		player.jumpfactor = 0	// No jumping!
		player.mindash = skins[0].mindash
		player.maxdash = skins[0].maxdash
		if(player.pflags & PF_SPINNING)
			and not(player.pflags & PF_JUMPED)
			player.normalspeed = skins[mo.skin].normalspeed
			player.thrustfactor = skins[mo.skin].thrustfactor
			local wallchecker = P_SpawnMobj(-12000*FRACUNIT, -12000*FRACUNIT, mo.z, MT_GARGOYLE) -- sal: needs to be OOB, then moved to the player, because otherwise it kills people in coop
			wallchecker.radius = mo.radius
			wallchecker.height = mo.height
			wallchecker.flags = ($1|MF_NOCLIPTHING) & ~(MF_SOLID|MF_PUSHABLE)
			P_SetOrigin(wallchecker, mo.x, mo.y, mo.z)
			local hit = P_TryMove(wallchecker, mo.x+mo.momx, mo.y+mo.momy, true)
			P_RemoveMobj(wallchecker)
			if not(hit)
				mo.momx = $1 - player.cmomx
				mo.momy = $1 - player.cmomy
				local speed = R_PointToDist2(0, 0, mo.momx, mo.momy)
				P_BounceMove(mo)
				local angle = R_PointToAngle2(0, 0, mo.momx, mo.momy)
				P_InstaThrust(mo, angle, speed)
				mo.momx = $1 + player.cmomx
				mo.momy = $1 + player.cmomy
				S_StartSound(mo, sfx_bnce1)
				if(mo.player.pflags & PF_ANALOGMODE)
					mo.player.drawangle = angle
					mo.angle = angle
				end
			end
		else
			player.normalspeed = 0
			if not(P_IsObjectOnGround(mo))
				player.thrustfactor = skins[mo.skin].thrustfactor
			else
				player.thrustfactor = 0
			end
		//	if(player.slprevflags & PF_SPINNING)
		//		and(P_IsObjectOnGround(mo))
		//		mo.momx = player.cmomx
		//		mo.momy = player.cmomy
		//	end
			if(IsDirChar(player))
				if(player.mo.momx-player.cmomx or player.mo.momy-player.cmomy)
					player.drawangle = R_PointToAngle2(player.cmomx, player.cmomy, player.mo.momx, player.mo.momy)
				else
					player.drawangle = mo.angle
				end
			end
		end
		player.slprevflags = player.pflags
	end
end, MT_PLAYER)
