-- (All of the Nova Shore Lua scripts have been cleaned up by Sal \m/)

freeslot(
	"SPR_DOPE",
	"MT_DOPEFISH",
	"S_DOPEFISH_IDLE1",
	"S_DOPEFISH_IDLE2",
	"S_DOPEFISH_NOTICE1",
	"S_DOPEFISH_NOTICE2",
	"S_DOPEFISH_NOTICE3",
	"S_DOPEFISH_ESCAPE1",
	"S_DOPEFISH_ESCAPE2",
	"MT_MANEGG",
	"S_MANEGG"
)

-- Ideally, burrowcrab should use different particles if on land vs. inside non-solid FOF (water)
function A_BurrowcrabBurrow(actor, var1, var2)
    if (actor.eflags & MFE_UNDERWATER) then
		A_MultiShot(actor, (MT_BURROWCRABDUST<<16)+8, -32)
	else
		A_MultiShot(actor, (MT_BURROWCRABROCK<<16)+8, -40)
	end
end

mobjinfo[MT_DOPEFISH] = {
	--$Name Dopefish
	--$Sprite DOPEA0
	--$Category SUGOI NPCs
	doomednum = 3149,
	spawnstate = S_DOPEFISH_IDLE1,
	radius = 24*FRACUNIT,
	height = 48*FRACUNIT,
	reactiontime = 25,
	flags = MF_NOBLOCKMAP|MF_NOCLIPTHING|MF_NOGRAVITY|MF_PUSHABLE
}

states[S_DOPEFISH_IDLE1] = {SPR_DOPE, A, 10, nil, 0, 0, S_DOPEFISH_IDLE2}
states[S_DOPEFISH_IDLE2] = {SPR_DOPE, B, 10, nil, 0, 0, S_DOPEFISH_IDLE1}
states[S_DOPEFISH_NOTICE1] = {SPR_DOPE, C, 20, nil, 0, 0, S_DOPEFISH_NOTICE2}
states[S_DOPEFISH_NOTICE2] = {SPR_DOPE, D, 50, A_PlaySound, sfx_s3kc3s, 1, S_DOPEFISH_ESCAPE1}
states[S_DOPEFISH_ESCAPE1] = {SPR_DOPE, A, 7, nil, 0, 0, S_DOPEFISH_ESCAPE2}
states[S_DOPEFISH_ESCAPE2] = {SPR_DOPE, B, 7, nil, 0, 0, S_DOPEFISH_ESCAPE1}

mobjinfo[MT_MANEGG] = {
	--$Name Manegg
	--$Sprite DOPEE0
	--$Category SUGOI NPCs
	doomednum = 3148,
	spawnstate = S_MANEGG,
	radius = 24*FRACUNIT,
	height = 24*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOCLIPTHING
}

states[S_MANEGG] = {SPR_DOPE, E, -1, nil, 0, 0, S_MANEGG}

addHook("MobjThinker", function(mo)
	if (mo.state == S_DOPEFISH_ESCAPE1)
	or (mo.state == S_DOPEFISH_ESCAPE2)
		mo.momx = 10*FRACUNIT
		mo.reactiontime = $1 - 1
	end

	if (mo.reactiontime <= 0)
		P_RemoveMobj(mo)
		return
	end
end, MT_DOPEFISH)

local function makefullbright(actor)
	if (mapheaderinfo[gamemap] and mapheaderinfo[gamemap].moonlit) then
        actor.frame = $1|FF_FULLBRIGHT
    end
end

addHook("MobjSpawn", makefullbright, MT_RING)
addHook("MobjSpawn", makefullbright, MT_FLINGRING)
