/*
One Last Goodbye - Arena
	by Lach
*/

freeslot("MT_FAKESIGN", "MT_SOAES_PILLARPARTICLES")

// Fake signpost

mobjinfo[MT_FAKESIGN] = {
	--$Name Fake Signpost
	--$Sprite SIGNA0
	--$Category SUGOI Decoration
	doomednum = 2786,
	spawnstate = S_SIGNSTOP,
	seestate = S_PLAY_SIGN,
	raisestate = S_SIGNBOARD,
	height = 8*FRACUNIT, --mobjinfo[MT_SIGN].height
	radius = 32*FRACUNIT, --mobjinfo[MT_SIGN].radius
	flags = MF_SCENERY|MF_NOBLOCKMAP|MF_NOCLIP
}

addHook("MobjThinker", function(mo)
	if not (mo.tracer and mo.tracer.valid)
		mo.tracer = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_OVERLAY);
		mo.tracer.target = mo;
		mo.tracer.movedir = ANGLE_90;
		mo.tracer.state = S_SIGNBOARD;
	end

	if (mo.target and mo.target.valid)
		return;
	end

	for player in players.iterate do
		if (player.mo and player.mo.valid)
			mo.target = player.mo;
			A_SignPlayer(mo, -1, 0);
			mo.flags = $1 | MF_NOTHINK;
			return;
		end
	end
end, MT_FAKESIGN)

// pillar particle spawners

mobjinfo[MT_SOAES_PILLARPARTICLES] = {
	--$Name SoAES's Cool Pillar Particles
	--$Sprite THOKA0
	--$Category SUGOI Decoration
	doomednum = 2788,
	spawnstate = S_INVISIBLE,
	radius = 256*FRACUNIT,
	height = 16*FRACUNIT,
	reactiontime = 16, // tics each orb will live for
	mass = 16, // inverse factor for speed orbs travel to center
	damage = 2, // inverse factor for orb scales
	painchance = 8,
	flags = MF_SCENERY|MF_NOBLOCKMAP|MF_NOCLIP|MF_NOGRAVITY
}

local colors = {SKINCOLOR_PURPLE, SKINCOLOR_CYAN, SKINCOLOR_BLACK}
local vars = {"x", "y", "z"}

addHook("MobjSpawn", function(mo)
	mo.particles = {}
end, MT_SOAES_PILLARPARTICLES)

addHook("MobjThinker", function(mo)
	local info = mo.info

	local hangle = P_RandomKey(360)*ANG1
	local vangle = P_RandomRange(-180, 180)*ANG1
	local dist = info.radius >> FRACBITS
	local hthrust = FixedMul(cos(vangle), mo.scale)

	local orb = P_SpawnMobj(
		mo.x + dist*FixedMul(cos(hangle), hthrust),
		mo.y + dist*FixedMul(sin(hangle), hthrust),
		mo.z + mo.height/2 + dist*FixedMul(sin(vangle), mo.scale), MT_THOK)
	orb.target = mo
	orb.scale = mo.scale/info.damage
	orb.color = colors[P_RandomKey(3) + 1]
	orb.frame = FF_FULLBRIGHT
	orb.tics = info.reactiontime
	table.insert(mo.particles, orb)

	for i = #mo.particles, 1, -1
		orb = mo.particles[i]

		if not (orb and orb.valid)
			table.remove(mo.particles)
			continue
		end

		for v = 1, #vars
			local var = vars[v]
			orb["mom"..var] = (mo[var] - orb[var]) / info.mass
		end
	end
end, MT_SOAES_PILLARPARTICLES)

// MT_UWU

/*

states[S_SOAES_IDLE] = {
	sprite = SPR_SAES,
	frame = FF_ANIMATE | FF_FULLBRIGHT,
	var1 = 3,
	var2 = 5
}

mobjinfo[MT_SOAES] = {
	doomednum = 2787,
	spawnstate = S_INVISIBLE,
	height = 48*FRACUNIT,
	radius = 16*FRACUNIT,
	flags = MF_SCENERY | MF_NOGRAVITY | MF_NOBLOCKMAP | MF_NOCLIP
}

*/
