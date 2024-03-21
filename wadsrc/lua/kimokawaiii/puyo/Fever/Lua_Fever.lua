// --------------------------------------
// LUA_Fever
// Fever chains
// --------------------------------------
local feverchain = {}
rawset(_G, "feverchains", feverchain)
rawset(_G, "numfeverchains", 0)
rawset(_G, "PP_AddFeverChain", function(chain)
	feverchain[numfeverchains] = chain
	numfeverchains = $1 + 1
end)
