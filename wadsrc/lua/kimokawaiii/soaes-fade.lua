/*
Proximity-fading FOFs
	by Lach & TehRealSalt
*/

--[[
HOW TO USE:
Place a Thing of type 2785 into a sector with a translucent FOF.
(The script will error in-game if no FOF is found.)
The maximum opacity value is determined by the opacity of the FOF (the #XXX
value in the front texture of the control linedef).
The Thing's z offset controls how far away, in FRACUNITS, a player has to be
from the Thing before the platform begins to fade into view.
If the Thing's Ambush flag is checked, the FOF will fade as the player
approaches the Thing in the direction determined by the Thing's angle.
Otherwise, the FOF will fade radially from the Thing's position.
(The Flip flag is not accounted for here, do not check it.)
]]--

freeslot("MT_FADEAGENT")

mobjinfo[MT_FADEAGENT] = {
	--$Name Proximity Fader
	--$Category SUGOI Decoration
	doomednum = 2785,
	height = 16*FRACUNIT,
	radius = 8*FRACUNIT,
	spawnhealth = 1000,
	spawnstate = S_INVISIBLE,
	flags = MF_NOGRAVITY|MF_SCENERY|MF_NOCLIP
}

local maxradius = 0

local foflistinit = false
local foflist = nil
local fofnextid = 1

local molist = nil

local function HandleTransparentBlocks(pmo, mo)
    if (mo.type != MT_FADEAGENT) then
        return
    end

	if (mo.detectionradius == nil) then
		return
	end

    local distance = P_AproxDistance(mo.x - pmo.x, mo.y - pmo.y)

    if (distance <= mo.detectionradius) then
		if mo.lineslope ~= nil
			local x = pmo[mo.independent] - mo[mo.independent]
			local y = FixedMul(x, mo.lineslope) + mo[mo.dependent]

			distance = abs(y - pmo[mo.dependent])
		end
        mo.distance = min($, distance)
    end
end

addHook("ThinkFrame", function()
	if (foflistinit == false) then
		-- TehRealSalt: FOF lists being stored on an mobj were too big to send,
		-- so we need to calculate all of that on the clients' end, rather
		-- than relying on SRB2's synching. Note that mo.fofid IS synched, but
		-- it will get overwritten by this initialization loop. There was not
		-- any other good way to quickly link every mobj to their position
		-- in the foflist.

		for mo in mobjs.iterate()
			if (mo.type == MT_FADEAGENT)
				mo.fofid = fofnextid -- Set fadeagent's foflist id.

				if (foflist == nil) then
					foflist = {} -- Init foflist if it doesn't exist
				end

				foflist[fofnextid] = {} -- Create fadeagent's table in the list

				for fof in mo.subsector.sector.ffloors()
					if (fof.flags & FF_EXISTS) and (fof.flags & FF_TRANSLUCENT) then
						table.insert(foflist[fofnextid], fof) -- Insert FOFs into this fadeagent's table
					end
				end

				if not (#foflist[fofnextid]) then
					-- There were no FOFs to be found in the fadeagent's sector
					-- SO, we need to clean this up.

					foflist[fofnextid] = nil -- Remove the table that was just made
					P_RemoveMobj(mo) -- Remove the mobj to prevent it from running.

					-- Warn the mapper.
					error("No FOF in fade agent object's sector! Object has been removed.")

					continue -- Do not increment next ID
				end

				fofnextid = $1+1 -- Increment next ID
			end
		end

		if (foflist ~= nil) and not (#foflist) then
			-- If every fadeagent is invalid, then this will be a completely
			-- empty table, but the blockmap search will run. Let's stop that.
			foflist = nil
		end

		foflistinit = true -- Make sure this initialization process only happens once.
	end

	if (foflist == nil) then
		return
	end

	if (molist != nil)
		for i = 1, #molist
			if not (molist[i].mo and molist[i].mo.valid)
				continue
			end

			if (molist[i].alpha == 0)
				molist[i].mo.flags2 = $1|MF2_DONTDRAW
			else
				molist[i].mo.flags2 = $1 & ~MF2_DONTDRAW
				molist[i].mo.frame = $1 & ~FF_TRANSMASK
				if (molist[i].alpha < NUMTRANSMAPS)
					molist[i].mo.frame = $1|((NUMTRANSMAPS - molist[i].alpha) << FF_TRANSSHIFT)
				end
			end
		end

		molist = nil
	end

    for player in players.iterate
        if not (player.spectator)
		and (player.mo and player.mo.valid)
            searchBlockmap("objects", HandleTransparentBlocks, player.mo,
                player.mo.x - maxradius, player.mo.x + maxradius,
                player.mo.y - maxradius, player.mo.y + maxradius
            )
        end
    end
end)

addHook("MobjThinker", function(mo)
	if (foflist == nil or mo.fofid == nil) then
		return
	end

	if (mo.detectionradius == nil or mo.distance == nil) then
		if (mo.spawnpoint and mo.spawnpoint.valid)
		and (mo.spawnpoint.options & MTF_AMBUSH) then
			local x = cos(mo.angle)
			local y = sin(mo.angle)

			if abs(y) > abs(x)
				mo.independent = "x"
				mo.dependent = "y"
				mo.lineslope = -FixedDiv(x, y or 1)
			else
				mo.independent = "y"
				mo.dependent = "x"
				mo.lineslope = -FixedDiv(y, x or 1)
			end
		end

		mo.detectionradius = (mo.spawnpoint.z - mo.subsector.sector.floorheight/FRACUNIT or 256)*FRACUNIT
		maxradius = max($, mo.detectionradius)

		mo.distance = INT32_MAX
	end

	-- TehRealSalt: Every fade block in our map looks like it's the same alpha,
	-- so we'll just use maxalpha as a simple assumption. To reimplement the
	-- customizability without storing it on a mobj table, you'd likely
	-- want to set this based on the FOF's control linedef's settings.
	local maxalpha = 200
	local alpha = max(1, maxalpha * FixedDiv(mo.detectionradius - mo.distance, mo.detectionradius) / FRACUNIT)
	local mobjalpha = min(NUMTRANSMAPS, alpha / 25)

	for i = 1, #(foflist[mo.fofid])
		foflist[mo.fofid][i].alpha = alpha
	end

	-- TehRealSalt: Lemme nitpick, because I don't want these to be seen from
	-- the boss's arena at all. Plus it'll look cooler.
	-- This is a separate list in thinkframe.
	for searchmo in mo.subsector.sector.thinglist()
		if (searchmo.type == MT_STARPOST) or (searchmo.flags & MF_MONITOR)
		or (searchmo.type == MT_OVERLAY and (searchmo.target.flags & MF_MONITOR))
			local changed = false
			if (mobjalpha == 0)
				if not (searchmo.flags2 & MF2_DONTDRAW)
					changed = true
				end
			else
				if ((searchmo.flags & MF_MONITOR) and (searchmo.health)) -- static effect, needs to run every visible frame
				or ((NUMTRANSMAPS - mobjalpha) != ((searchmo.frame & FF_TRANSMASK) >> FF_TRANSSHIFT))
					changed = true
				end
			end

			if (changed)
				if (molist == nil)
					molist = {}
				end
				table.insert(molist, {mo = searchmo, alpha = mobjalpha})
			end
		end
	end

	mo.distance = INT32_MAX
end, MT_FADEAGENT)


addHook("MapChange", do
	maxradius = 0
	foflistinit = false
	foflist = nil
	fofnextid = 1
	molist = nil
end)

addHook("NetVars", function(net)
	maxradius = net(maxradius)

	-- reinitalize foflist
	foflistinit = false
	foflist = nil
	fofnextid = 1
	molist = nil
end)
