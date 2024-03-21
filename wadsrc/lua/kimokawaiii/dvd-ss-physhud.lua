-- LUA_PHYS
-- PhysHUD script!
-- this renders elements with "physics".

rawset(_G, "physHUD", {})

rawset(_G, "phud", {})

rawset(_G, "PF_FLIPPHYSICS", 1)

function phud.create(x, y, sprite, tics, c)

	local t = {
				x = x,
				y = y,
				p = sprite,
				anim = {},
				animtimer = 0,
				animloop = true,
				animprogress = 1,
				momx = 0,
				momy = 0,
				physics = true,
				waitphysics = 0,
				splat = false,
				flags = 0,
				physflags = 0,
				scale = FRACUNIT,
				destscale = FRACUNIT,
				scalespeed = FRACUNIT/12,
				deleteoffscreen = true,
				colormap = c,
				tics = tics or -1,
			}
	if not paused and not menuactive	-- don't add the HUD if the game has been paused.
		physHUD[#physHUD+1] = t
	end
	return t
end

rawset(_G, "DisplayPhysHUD", function(v, p, c)
	local clearcount= 0
	if physHUD[1]

		for k, i in ipairs(physHUD)

			if i.clear
				clearcount = $+1
				continue
			end

			local pp = v.cachePatch(i.p)

			-- splats
			local splatflag = 0
			if i.splat
			and i.tics < 9
				splatflag = V_90TRANS - V_10TRANS * i.tics
				--print(i.tics)
			end
			if i.isstring
				v.drawString(i.x, i.y, i.p, i.flags)
			else
				v.drawScaled(i.x*FRACUNIT, i.y*FRACUNIT, i.scale, pp, i.flags|splatflag, i.colormap)
			end

			if paused or menuactive continue end	-- do not go farther than rendering if the game is paused

			-- handle other stuff now

			-- momentum

			if i.waitphysics then i.waitphysics = $-1 end	-- wait x tics before applying physics

			if i.physics
			and not i.waitphysics
				if i.physflags & PF_FLIPPHYSICS
					i.x = $ + i.momx
					i.y = $ + i.momy
				else
					i.x = $ + i.momx
					i.y = $ - i.momy
				end

				if i.momy > 0
					i.momy = $/2
				else
					i.momy = min(-1, $*2)
				end
			end

			-- scale
			if i.scale < i.destscale
			and not i.waitphysics
				i.scale = min(i.destscale, $+i.scalespeed)
			end
			if i.scale > i.destscale
			and not i.waitphysics
				i.scale = max(i.destscale, $-i.scalespeed)
			end

			-- animation
			local anim_time = i.anim[#i.anim]
			if anim_time

				i.p = i.anim[i.animprogress]

				if i.animtimer >= anim_time
				and (i.animprogress < #i.anim-1 or i.animloop)
					i.animprogress = $+1
					if i.animprogress >= #i.anim
						i.animprogress = 1
					end
				end
				i.animtimer = $+1
			end

			-- tics
			if i.tics and i.tics > 0
				i.tics = $-1
				if not i.tics
					--table.remove(physHUD, k)
					i.clear = true
				end
			end

			-- delete off screen?
			if i.deleteoffscreen
				if i.x > 320
				or i.y > 200
				or i.x + pp.width < 0
				or i.y + pp.height < 0
					i.clear = true
					--table.remove(physHUD, k)
				end
			end
		end

		if clearcount >= #physHUD
			physHUD = {}
		end
	end
end)
