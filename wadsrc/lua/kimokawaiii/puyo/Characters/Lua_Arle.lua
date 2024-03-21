// --------------------------------------
// Lua_Arle
// Arle's cut-ins
// --------------------------------------
local function GetRot(angle)
	local returnval = (((angle/FRACUNIT)-45)/45)%8
	while(returnval < 0)
		returnval = $1 + 8
	end
	return returnval
end

local function cutinfire(v, x, y, scale, flags, cutintime)
	if(v.arlefire == nil)
		v.arlefire = v.cachePatch("ARLEFIRE")
		v.arlefbl1 = v.cachePatch("ARLEFBL1")
		v.arlefbl2 = v.cachePatch("ARLEFBL2")
		v.arlefbl3 = v.cachePatch("ARLEFBL3")
		v.arlefbl4 = v.cachePatch("ARLEFBL4")
		v.arlefbl5 = v.cachePatch("ARLEFBL5")
	end
	
	local firepatches = {}
	firepatches[0] = v.arlefbl3
	firepatches[1] = v.arlefbl2
	firepatches[2] = v.arlefbl1
	firepatches[3] = v.arlefbl2
	firepatches[4] = v.arlefbl3
	firepatches[5] = v.arlefbl4
	firepatches[6] = v.arlefbl5
	firepatches[7] = v.arlefbl4
	
	local yoff = cutintime*FRACUNIT
	
	if(cutintime > TICRATE*2/3)
		yoff = $1 + (cutintime-(TICRATE*2/3))*FRACUNIT*2
	end
	
	yoff = $1 * 2
	
	v.drawScaled(x, y-yoff-(40*FRACUNIT), scale*2/3, v.arlefire, flags)
	
	// Faia
	local firerot = cutintime*FRACUNIT*8
	local firedist = 3*cutintime*FRACUNIT
	local firex = 44*scale*2/3
	local firey = 14*scale*2/3
	if(flags & V_FLIP)
		firex = -$1
	end
	local f = 0
	while(f < 3)
		local fcos = FixedMul(cos(FixedAngle(firerot)), firedist)
		local fsin = FixedMul(sin(FixedAngle(firerot)), firedist)
		local gotrot = GetRot(firerot)
		local flags2 = flags & !V_FLIP
		if(gotrot == 3)
			or(gotrot == 4)
			or(gotrot == 5)
			if(flags2 & V_FLIP)
				flags2 = $1 & !V_FLIP
			else
				flags2 = $1|V_FLIP
			end
		end
		v.drawScaled(x+firex+fcos, y-firey+fsin-yoff-(40*FRACUNIT), scale*2/3*cutintime/6, firepatches[gotrot], flags2)
		firerot = $1 + ((360/3)*FRACUNIT)
		f = $1 + 1
	end
end

PP_AddCutin(cutinfire)

local function cutinicestorm(v, x, y, scale, flags, cutintime)
	if(v.arleicestorm == nil)
		v.arleicestorm = v.cachePatch("ARLEFIRE")
		v.arleice = v.cachePatch("ARLEAISU")
		v.arleice2 = v.cachePatch("ARLEAIS2")
	end
	
	local flags2 = flags
	if(flags & V_FLIP)
		flags2 = $1 & !V_FLIP
	else
		flags2 = $1|V_FLIP
	end
	
	local yoff = cutintime*FRACUNIT
	
	if(cutintime > TICRATE*2/3)
		yoff = $1 + (cutintime-(TICRATE*2/3))*FRACUNIT*2
	end
	
	yoff = $1 * 2
	
	v.drawScaled(x, y-yoff-(40*FRACUNIT), scale*2/3, v.arleicestorm, flags2)
	local firex = 44*scale*2/3
	local firey = 14*scale*2/3
	if(flags2 & V_FLIP)
		firex = -$1
	end
	local scale2 = scale*2
	if(cutintime > 15)
		scale2 = $1 + (FRACUNIT + (cutintime*FRACUNIT/8)/2)
	end
	if(cutintime & 1)
		and not(cutintime > 15)
		v.drawScaled(x+firex, y-yoff-(40*FRACUNIT)-firey, scale2*2/3, v.arleice2, flags2)
	else
		v.drawScaled(x+firex+scale2, y-yoff-(40*FRACUNIT)-firey+scale2, scale2*2/3, v.arleice, flags2)
	end
end

PP_AddCutin(cutinicestorm)

local function cutinbraindumbed(v, x, y, scale, flags, cutintime)
	if(v.arlebraindumbed == nil)
		v.arlebraindumbed = v.cachePatch("ARLEBDMB")
		v.arledreamcastspin = {}
		v.arledreamcastspin[0] = v.cachePatch("ARLEDRMC")
		v.arledreamcastspin[1] = v.cachePatch("ARLEDRM2")
		v.arledreamcastspin[2] = v.cachePatch("ARLEDRM3")
		v.arledreamcastspin[3] = v.cachePatch("ARLEDRM4")
	end
	
	local angle = FixedAngle(cutintime*FRACUNIT*8)
	local distance = 10*FRACUNIT
	local xoff = FixedMul(cos(angle), distance)
	if(flags & V_FLIP)
		xoff = -$1
	end
	local yoff = FixedMul(sin(angle), distance)
	
	yoff = $1 * 2
	
	v.drawScaled(x+(xoff*2), y-yoff-(90*FRACUNIT), scale*2/3, v.arlebraindumbed, flags)
	
	local dreamcastframe = (cutintime/2)%4
	v.drawScaled(x-(xoff/2)-(20*FRACUNIT), y+(yoff/2)-(70*FRACUNIT), scale*4/3, v.arledreamcastspin[dreamcastframe], flags)
	v.drawScaled(x-(xoff/2)+(40*FRACUNIT), y+(yoff/2)-(95*FRACUNIT), scale*4/3, v.arledreamcastspin[dreamcastframe], flags)
	v.drawScaled(x-(xoff/2)-(10*FRACUNIT), y+(yoff/2)-(130*FRACUNIT), scale*4/3, v.arledreamcastspin[dreamcastframe], flags)
end

PP_AddCutin(cutinbraindumbed)

local function cutinjugem(v, x, y, scale, flags, cutintime)
	if(v.arlejugem == nil)
		v.arlejugem = v.cachePatch("ARLEJUGM")
		v.arlejugem1 = v.cachePatch("ARLEJGM1")
		v.arlejugem2 = v.cachePatch("ARLEJGM2")
	end
	
	local yoff = cutintime*FRACUNIT
	
	if(cutintime > TICRATE*2/3)
		yoff = $1 + (cutintime-(TICRATE*2/3))*FRACUNIT*2
	end
	
	yoff = $1 * 2
	
	v.drawScaled(x, y-yoff-(40*FRACUNIT), scale*2/3, v.arlejugem, flags)
	if(cutintime & 1)
		v.drawScaled(x-(20*FRACUNIT), y-yoff-(135*FRACUNIT), scale/3, v.arlejugem1, flags)
	else
		v.drawScaled(x-(20*FRACUNIT), y-yoff-(137*FRACUNIT), scale/3, v.arlejugem2, flags)
	end
end

PP_AddCutin(cutinjugem)

local function cutinbayoen(v, x, y, scale, flags, cutintime)
	if(v.arlebayoen == nil)
		v.arlebayoen = v.cachePatch("BAYOEEEN")
		v.arlebayoenf1 = v.cachePatch("BAYOENF1")
		v.arlebayoenf2 = v.cachePatch("BAYOENF2")
		v.arlebayoenflowers = {}
		v.arlebayoenflowers[0] = v.cachePatch("FLOWER1")
		v.arlebayoenflowers[1] = v.cachePatch("FLOWER2")
		v.arlebayoenflowers[2] = v.cachePatch("FLOWER3")
	end
	
	local yoff = cutintime*FRACUNIT*2/3
	local xoff = cutintime*FRACUNIT
	if(flags & V_FLIP)
		xoff = -$1
	end
	
	local frame = v.arlebayoen
	local flags2 = flags
	if(cutintime <= 20)
		local time = ((cutintime)-1)%10
		if(time == 1)
			or(time == 4)
			or(time == 6)
			or(time == 9)
			frame = v.arlebayoenf1
		elseif(time == 2)
			or(time == 3)
			or(time == 7)
			or(time == 8)
			frame = v.arlebayoenf2
		end
		
		if(time >= 3)
			and(time <= 7)
			if(flags & V_FLIP)
				flags2 = $1 & !V_FLIP
			else
				flags2 = $1|V_FLIP
			end
		end
	end
	
	// Flowers
	local firerot = cutintime*FRACUNIT*3
	local firedist = 60*FRACUNIT
	local f = 0
	while(f < 6)
		firedist = (((60*FRACUNIT*f)%7)*6*FRACUNIT)+(30*FRACUNIT)
		local fcos = FixedMul(cos(FixedAngle(firerot)), firedist)
		local fsin = FixedMul(sin(FixedAngle(firerot)), firedist)
		v.drawScaled(x-xoff+(20*FRACUNIT)+fcos, y+fsin-yoff-(90*FRACUNIT), scale*2/3, v.arlebayoenflowers[f%3], flags)
		firerot = $1 + ((360/6)*FRACUNIT)
		f = $1 + 1
	end

	v.drawScaled(x-xoff+(20*FRACUNIT), y-yoff-(90*FRACUNIT), scale*2/3, frame, flags2)
end

PP_AddCutin(cutinbayoen)

local function cutincounter(v, x, y, scale, flags, cutintime)
end

PP_AddCutin(cutincounter)

local function cutindamage(v, x, y, scale, flags, cutintime)
end

PP_AddCutin(cutindamage)

local function cutinwin(v, x, y, scale, flags, cutintime)
end

PP_AddCutin(cutinwin)

local function cutinlose(v, x, y, scale, flags, cutintime)
end

PP_AddCutin(cutinlose)
