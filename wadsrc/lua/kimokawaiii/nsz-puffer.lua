freeslot(
	"SPR_PUFR",
	"SPR_PUF2",
	"MT_PUFFBUBBLE",
	"S_PUFFBUBBLE1",
	"S_PUFFBUBBLE2",
	"S_PUFFBUBBLE3",
	"S_PUFFBUBBLE4",
	"S_PUFFBUBBLE_SPIKE1",
	"S_PUFFBUBBLE_SPIKE2",
	"S_PUFFBUBBLE_SPIKE3",
	"S_PUFFBUBBLE_RETRACT1",
	"sfx_puffon",
	"sfx_puffof"
)

mobjinfo[MT_PUFFBUBBLE] = {
	--$Name Puffer Bubble
	--$Sprite PUFRA0
	--$Category SUGOI Items & Hazards
	doomednum = 3471,
	spawnhealth = 1,
	spawnstate = S_PUFFBUBBLE1,
	raisestate = S_PUFFBUBBLE_SPIKE1,
	painchance = 1,
	damage = 0,
	radius = 24*FRACUNIT,
	height = 32*FRACUNIT,
	mass = 13*FRACUNIT,
	flags = MF_NOGRAVITY|MF_SPRING|MF_SOLID
}

function A_PuffOnOff(actor, v1, v2)
	if (v1 == 1)
		actor.flags = $1 & ~MF_SPRING
	else
		actor.flags = $1 | MF_SPRING
	end

	if (v2 != 0)
		S_StartSound(actor, v2)
	end
end

states[S_PUFFBUBBLE1] = {SPR_PUFR, A|FF_FULLBRIGHT, 4, nil, 0, 0, S_PUFFBUBBLE2}
states[S_PUFFBUBBLE2] = {SPR_PUFR, B|FF_FULLBRIGHT, 4, nil, 0, 0, S_PUFFBUBBLE3}
states[S_PUFFBUBBLE3] = {SPR_PUFR, C|FF_FULLBRIGHT, 4, nil, 0, 0, S_PUFFBUBBLE4}
states[S_PUFFBUBBLE4] = {SPR_PUFR, B|FF_FULLBRIGHT, 4, nil, 0, 0, S_PUFFBUBBLE1}

states[S_PUFFBUBBLE_SPIKE1] = {SPR_PUFR, D|FF_FULLBRIGHT, 2, A_PlaySound, sfx_puffon, 1, S_PUFFBUBBLE_SPIKE2}
states[S_PUFFBUBBLE_SPIKE2] = {SPR_PUFR, E|FF_FULLBRIGHT, 2, A_PuffOnOff, 1, 0, S_PUFFBUBBLE_SPIKE3}
states[S_PUFFBUBBLE_SPIKE3] = {SPR_PUFR, D|FF_FULLBRIGHT, 5*TICRATE, nil, 0, 0, S_PUFFBUBBLE_RETRACT1}
states[S_PUFFBUBBLE_RETRACT1] = {SPR_PUFR, F|FF_FULLBRIGHT, 2, A_PuffOnOff, 0, sfx_puffof, S_PUFFBUBBLE1}

local function PuffCollide(mo, toucher)
	// SRB2 drastically fucked up MF_PAIN so we have to manually do it now.
	if not (mo.flags & MF_SPRING)
	and (toucher.player and toucher.player.valid)
		if (mo.z > toucher.z + toucher.height)
		or (mo.z + mo.height < toucher.z)
			return false;
		end

		if (toucher.flags & MF_SHOOTABLE)
		and (toucher.health > 0)
			P_DamageMobj(toucher, mo, mo, 1, DMG_SPIKE);
		end

		return false;
	end
end

addHook("MobjCollide", PuffCollide, MT_PUFFBUBBLE);
addHook("MobjMoveCollide", PuffCollide, MT_PUFFBUBBLE);
