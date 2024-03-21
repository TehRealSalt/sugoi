-- Pseudorandom Numbers Library v1.0 by LJ Sonic

if _G[N_Random] return end	-- don't proceed if this library is already loaded (with how I name it this'd mean SRB2P5 is added????)

local t, x, y, z, w = 0, P_RandomFixed(), P_RandomFixed(), P_RandomFixed(), P_RandomFixed()

rawset(_G, "N_Random", function()
	t = x ^^ (x << 11)
	x, y, z, w = y, z, w, w ^^ (w >> 19) ^^ t ^^ (t >> 8)
	return w
end)

rawset(_G, "N_RandomKey", function(n) return abs(N_Random() % n) end)
rawset(_G, "N_RandomRange", function(a, b) return a + abs(N_Random() % (b - a + 1)) end)
rawset(_G, "N_RandomDatas", function() return d end)
