/*
Saccharine Springs Zone scenery
	by Lach
*/

local FOLIAGE_COLOR = SKINCOLOR_APPLE

local TEXTURE_TO_COLOR = {
	SACCWALL = SKINCOLOR_BEIGE, // there were colors other than beige initially, but none of them looked good LOL
	ACROCKY1 = SKINCOLOR_BEIGE,
	ACROCKY3 = SKINCOLOR_BEIGE,
	ACROCKY4 = SKINCOLOR_BEIGE
}

local function GetFloorTexture(mo)
	local moZ = mo.z + (mo.height >> 1)
	local sector = mo.subsector.sector
	local texture

	if mo.eflags & MFE_VERTICALFLIP
		local bestZ = INT32_MAX
		local bestFOF

		for fof in sector.ffloors()
			if fof.flags & (FF_EXISTS|FF_SOLID) == (FF_EXISTS|FF_SOLID)
				local fofZ
				if fof.b_slope
					fofZ = P_GetZAt(fof.b_slope, mo.x, mo.y)
				else
					fofZ = fof.bottomheight
				end

				if fofZ >= moZ
				and fofZ < bestZ
					bestZ = fofZ
					bestFOF = fof
				end
			end
		end

		if bestFOF
			texture = bestFOF.bottompic
		else
			texture = sector.ceilingpic
		end
	else
		local bestZ = INT32_MIN
		local bestFOF

		for fof in sector.ffloors()
			if fof.flags & (FF_EXISTS|FF_SOLID) == (FF_EXISTS|FF_SOLID)
				local fofZ
				if fof.t_slope
					fofZ = P_GetZAt(fof.t_slope, mo.x, mo.y)
				else
					fofZ = fof.topheight
				end

				if fofZ <= moZ
				and fofZ > bestZ
					bestZ = fofZ
					bestFOF = fof
				end
			end
		end

		if bestFOF
			texture = bestFOF.toppic
		else
			texture = sector.floorpic
		end
	end
	return texture
end

addHook("LinedefExecute", function()
	for mt in mapthings.iterate
		local mo = mt.mobj

		if not (mo and mo.valid)
			continue
		end

		// stalagmite colors!
		if mo.type == MT_DSZSTALAGMITE
			local color = TEXTURE_TO_COLOR[GetFloorTexture(mo)]

			if color
				mo.color = color
				mo.colorized = true
			end
		// color flower stems to match the RVZ grass
		elseif mo.flags & (MF_SCENERY|MF_SOLID) == MF_SCENERY
			mo.color = FOLIAGE_COLOR
		end
	end
end, "SACCLOAD")
