-- slow the player down upon entering cold water!
glacierglaze.SlowdownPlayer = function(p, nosound)
	local mo = p.mo
	local ggz = mo.ggz
	if (glacierglaze.IsPlayerProtected(p)) then return end	-- nope
	
	-- play a freezing sfx
	if not (ggz.slowdowntics)
	and not (nosound)
		S_StartSound(mo, sfx_glgz1)
	end
	-- slow down the player
	ggz.slowdown = $ or 0
	ggz.slowdowntics = glacierglaze.SlowdownTics
end

glacierglaze.WaterSlowdown = function(p)
	local mo = p.mo
	if not (mo and mo.valid) then return end
	local ggz = mo.ggz
	
	-- water slows us down
	if (mo.health)	-- only if we're alive
	and (mo.eflags & MFE_UNDERWATER)
	and (mapheaderinfo[gamemap].glacierglaze)
	or (glacierglaze.debug and (p.cmd.buttons & BT_CUSTOM1))	-- debug command to get slowdown
		glacierglaze.SlowdownPlayer(p)
	end
	
	-- handle the timer
	ggz.slowdowntics = $ and $-1 or 0
	if (glacierglaze.IsPlayerProtected(p) == 2)
		ggz.slowdowntics = 0	-- COMPLETELY remove it, we're heated
	end
	
	-- handle everything related to slowdown itself here
	if (ggz.slowdown != nil)
		-- increase/decrease based on timer
		if (ggz.slowdowntics)
			ggz.slowdown = min(100, $ + glacierglaze.SlowdownAddTics)
		else
			local shield = (p.powers[pw_shield] & SH_NOSTACK)
			local firesource = (shield & SH_PROTECTFIRE) or ggz.fireattack
			
			local removetics = glacierglaze.SlowdownRemoveTics * ((firesource) and 2 or 1)	-- fire sources should thaw us out quicker
			ggz.slowdown = max(0, $ - removetics)
		end
		
		-- transparency
		if not (mo.flags2 & MF2_DONTDRAW)
			local trans = 10 - (ggz.slowdown/20)
			
			if (trans >= 1 and trans <= 9)
				-- spawn ghost mobj
				local g = P_SpawnGhostMobj(mo)
				g.frame = ($ & ~FF_TRANSMASK) | (trans << FF_TRANSSHIFT)
				g.rollangle = mo.rollangle
				g.color, g.colorized = SKINCOLOR_CYAN, true
				g.tics = 1
				if (g.tracer and g.tracer.valid)	-- followmobj?
					local g2 = g.tracer
					
					g2.frame = ($ & ~FF_TRANSMASK) | (trans << FF_TRANSSHIFT)
					g2.rollangle = mo.rollangle
					g2.color, g.colorized = SKINCOLOR_CYAN, true
					g2.tics = 1
				end
				
				-- spawn some snowflakes for a chilly effect
				local freq = 3 + ((100 - ggz.slowdown)*12/100)	-- less particles depending on how frozen we are
				if not (leveltime%freq)
					local xoff = P_RandomRange(-20, 20)*mo.scale
					local yoff = P_RandomRange(-20, 20)*mo.scale
					local zoff = P_RandomRange(0, 60)*mo.scale
					
					local snowflake = P_SpawnMobjFromMobj(mo, xoff, yoff, zoff, MT_SNOWFLAKE)
					snowflake.sprite, snowflake.frame = SPR_SNO1, P_RandomRange(0, 2)|FF_FULLBRIGHT
					snowflake.destscale = mo.scale/3
					snowflake.scalespeed = FRACUNIT/24
					snowflake.fuse = 3*TICRATE
					snowflake.flags = MF_NOGRAVITY
					P_SetObjectMomZ(snowflake, -3*FRACUNIT / ((mo.eflags & MFE_UNDERWATER) and 2 or 1))
				end
			end
		end
		
		-- get the modifier to slow us down, then reduce them
		local range = FRACUNIT - glacierglaze.SlowdownModifier
		local modifier = FRACUNIT - (ggz.slowdown*range/100)
		local skin = skins[p.skin]
		
		for k, v in pairs(glacierglaze.SlowdownFields)
			p[v] = FixedMul(modifier, skin[v])
		end
		p.ggz_resetslowdown = true	-- for map changes
		
		-- if it's nil, remove it completely
		if not (ggz.slowdown)
			ggz.slowdown = nil
			ggz.fireattack = nil	-- get rid of this here
			p.ggz_resetslowdown = nil 	-- wont need this anymore since it's natural removal
		end
	elseif (p.ggz_resetslowdown)
		-- fallback for resetting normalspeed, actionspd and whatnot
		local skin = skins[p.skin]
		for k, v in pairs(glacierglaze.SlowdownFields)
			p[v] = skin[v]
		end
		
		-- remove this since we've got it all reset
		p.ggz_resetslowdown = nil
	end
end

-- if we're damaged by fire, thaw us out!
addHook("MobjDamage", function(mo, inflictor, source, damage, damagetype)
	if not (damagetype & DMG_FIRE) then return end	-- needs to be fire
	
	local ggz = mo.ggz
	if not (ggz.slowdowntics and ggz.slowdown) then return end	-- no need to even do this
	
	ggz.slowdowntics = 0
	ggz.fireattack = true	-- so we can thaw out quicker
end, MT_PLAYER)