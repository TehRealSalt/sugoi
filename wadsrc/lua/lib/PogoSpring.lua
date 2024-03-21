--
-- Pogo Spring
-- remade by TehRealSalt
--

if (PogoSpring)
	return;
end

rawset(_G, "PogoSpring", {});
PogoSpring.Strength = 20 << FRACBITS;
PogoSpring.JumpStr = PogoSpring.Strength; --(PogoSpring.Strength << 1) / 3;

freeslot(
	"SPR_TVPS",
	"MT_POGOSPRING_BOX",
	"S_POGOSPRING_BOX",

	"MT_POGOSPRING_GOLDBOX",
	"S_POGOSPRING_GOLDBOX",

	"MT_POGOSPRING_ICON",
	"S_POGOSPRING_ICON1",
	"S_POGOSPRING_ICON2",

	"SPR_SPRP",
	"MT_POGOSPRING",
	"S_POGOSPRING",
	"S_POGOSPRING_BOUNCE1",
	"S_POGOSPRING_BOUNCE2",
	"S_POGOSPRING_BOUNCE3",
	"S_POGOSPRING_BOUNCE4",
	"S_POGOSPRING_BOUNCE5",
	"S_POGOSPRING_BOUNCE6",

	"SPR2_POGS",
	"S_PLAY_POGOSPRING"
);

-- Player state
-- Triple Trouble had its own pose for this,
-- so maybe someone wants to make one :)
spr2defaults[SPR2_POGS] = SPR2_STND;
states[S_PLAY_POGOSPRING] = {SPR_PLAY, SPR2_POGS|FF_ANIMATE, -1, nil, 0, 4, S_NULL};

function A_GivePogoSpring(actor)
	if not ((actor.target and actor.target.valid and actor.target.health)
	and (actor.target.player and actor.target.player.valid))
		return;
	end

	PogoSpring.Init(actor.target.player);
	S_StartSound(actor.target, actor.info.seesound);
end

mobjinfo[MT_POGOSPRING_BOX] = {
	--$Name Pogo Spring
	--$Sprite TVPSA0
	--$Category SUGOI Powerups
	--$Flags1Text Run linedef executor on pop
	--$Flags4Text Random (Strong)
	--$Flags8Text Random (Weak)
	doomednum = 4064,
	spawnstate = S_POGOSPRING_BOX,
	painstate = S_POGOSPRING_BOX,
	deathstate = S_BOX_POP1,
	deathsound = sfx_pop,
	spawnhealth = 1,
	reactiontime = 8,
	speed = 1,
	radius = 18*FRACUNIT,
	height = 40*FRACUNIT,
	mass = 100,
	damage = MT_POGOSPRING_ICON,
	flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR,
}

states[S_POGOSPRING_BOX] = {SPR_TVPS, A, 2, nil, 0, 0, S_BOX_FLICKER}

mobjinfo[MT_POGOSPRING_GOLDBOX] = {
	--$Name Pogo Spring (Respawn)
	--$Sprite TVPSB0
	--$Category SUGOI Powerups
	--$Flags1Text Run linedef executor on pop
	--$Flags4Text Random (Strong)
	--$Flags8Text Random (Weak)
	doomednum = 4065,
	spawnstate = S_POGOSPRING_GOLDBOX,
	painstate = S_POGOSPRING_GOLDBOX,
	deathstate = S_GOLDBOX_OFF1,
	deathsound = sfx_pop,
	attacksound = sfx_monton,
	spawnhealth = 1,
	reactiontime = 8,
	speed = 1,
	radius = 20*FRACUNIT,
	height = 44*FRACUNIT,
	mass = 100,
	damage = MT_POGOSPRING_ICON,
	flags = MF_SOLID|MF_SHOOTABLE|MF_MONITOR|MF_GRENADEBOUNCE,
}

states[S_POGOSPRING_GOLDBOX] = {SPR_TVPS, B, 2, A_GoldMonitorSparkle, 0, 0, S_GOLDBOX_FLICKER}

mobjinfo[MT_POGOSPRING_ICON] = {
	spawnstate = S_POGOSPRING_ICON1,
	spawnhealth = 1,
	seesound = sfx_cdfm31,
	reactiontime = 8,
	speed = 2*FRACUNIT,
	radius = 8*FRACUNIT,
	height = 14*FRACUNIT,
	mass = 100,
	damage = 62*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY|MF_BOXICON,
}

states[S_POGOSPRING_ICON1] = {SPR_TVPS, FF_ANIMATE|C, 18, nil, 3, 4, S_POGOSPRING_ICON2}
states[S_POGOSPRING_ICON2] = {SPR_TVPS, C, 18, A_GivePogoSpring, 0, 0, S_NULL}

mobjinfo[MT_POGOSPRING] = {
	spawnstate = S_POGOSPRING,
	seestate = S_POGOSPRING_BOUNCE1,
	deathstate = S_XPLD1,
	seesound = sfx_spring,
	deathsound = sfx_pop,
	spawnhealth = 1000,
	radius = 16*FRACUNIT,
	height = 18*FRACUNIT,
	dispoffset = -5,
	flags = MF_NOBLOCKMAP|MF_NOCLIP|MF_NOCLIPTHING|MF_NOCLIPHEIGHT|MF_SCENERY|MF_NOGRAVITY,
}

states[S_POGOSPRING] = {SPR_SPRP, B, -1, nil, 0, 0, S_NULL}

states[S_POGOSPRING_BOUNCE1] = {SPR_SPRP, A,  2, nil, 0, 0, S_POGOSPRING_BOUNCE2}
states[S_POGOSPRING_BOUNCE2] = {SPR_SPRP, E,  4, nil, 0, 0, S_POGOSPRING_BOUNCE3}
states[S_POGOSPRING_BOUNCE3] = {SPR_SPRP, D,  1, nil, 0, 0, S_POGOSPRING_BOUNCE4}
states[S_POGOSPRING_BOUNCE4] = {SPR_SPRP, C,  1, nil, 0, 0, S_POGOSPRING_BOUNCE5}
states[S_POGOSPRING_BOUNCE5] = {SPR_SPRP, B,  1, nil, 0, 0, S_POGOSPRING_BOUNCE6}
states[S_POGOSPRING_BOUNCE6] = {SPR_SPRP, A,  1, nil, 0, 0, S_POGOSPRING}

PogoSpring.Init = function(player)
	if not (player and player.valid)
		return;
	end

	if not (player.mo and player.mo.valid)
		return;
	end

	player.HasPogoSpring = true; -- SUGOI: Keep between levels

	if (player.mo.PogoSpring and player.mo.PogoSpring.valid)
		-- Already have.
		return;
	end

	local spring = P_SpawnMobjFromMobj(player.mo, 0, 0, 0, MT_POGOSPRING);
	spring.target = player.mo;
	spring.health = PogoSpring.Strength;

	P_ResetPlayer(player);
	player.mo.PogoSpring = spring;

	PogoSpring.Think(player);
end

PogoSpring.Pop = function(mo)
	if (mo.player and mo.player.valid)
		mo.player.HasPogoSpring = false;
	end

	if not (mo.PogoSpring and mo.PogoSpring.valid)
		return;
	end

	mo.PogoSpring.state = mo.PogoSpring.info.deathstate;
	mo.PogoSpring.health = 0;
	mo.PogoSpring.momx = 0;
	mo.PogoSpring.momy = 0;
	mo.PogoSpring.momz = 0;

	mo.PogoSpring = nil;
end

PogoSpring.JumpOff = function(player)
	if not (player and player.valid)
		return false;
	end

	if not (player.mo and player.mo.valid)
		return false;
	end

	if (player.pflags & PF_JUMPSTASIS)
		return false;
	end

	if (player.HasPogoSpring)
		if (player.pflags & PF_JUMPDOWN)
			return true;
		end

		PogoSpring.Pop(player.mo);

		if (player.jumpfactor)
			local thrust = PogoSpring.JumpStr;

			if (maptol & TOL_NIGHTS)
				thrust = $1 << 1;
			elseif (player.powers[pw_super] and not (player.charflags & SF_NOSUPERJUMPBOOST))
				thrust = ($1 << 2) / 3;
			end

			if (player.mo.eflags & MFE_UNDERWATER)
				thrust = FixedMul(thrustmomz, FixedDiv(117*FRACUNIT, 200*FRACUNIT));
			end

			local factor = player.jumpfactor;
			if (twodlevel or (player.mo.flags2 & MF2_TWOD))
				factor = $1 + ($1 / 10);
			end
			thrust = FixedMul($1, factor);

			P_SetObjectMomZ(player.mo, thrust);
			player.pflags = $1 | P_GetJumpFlags(player) | PF_STARTJUMP;

			S_StartSound(player.mo, sfx_jump);
			player.mo.state = S_PLAY_JUMP;
		end

		return true;
	end
end

PogoSpring.NoAbility = function(player)
	if not (player and player.valid)
		return false;
	end

	if not (player.mo and player.mo.valid)
		return false;
	end

	if (player.HasPogoSpring)
		-- Don't use abilities during Pogo Spring
		return true;
	end

	return false;
end

PogoSpring.Think = function(player)
	if not (player and player.valid)
		return;
	end

	if not (player.mo and player.mo.valid)
		return;
	end

	if not (player.mo.PogoSpring and player.mo.PogoSpring.valid)
		return;
	end

	local mo = player.mo;
	local spring = mo.PogoSpring;

	local z = mo.z - spring.height;
	if (mo.eflags & MFE_VERTICALFLIP)
		z = mo.z + mo.height;
	end
	P_MoveOrigin(spring, mo.x, mo.y, z);

	spring.momx, spring.momy, spring.momz = mo.momx, mo.momy, mo.momz;

	spring.destscale = mo.destscale;
	P_SetScale(spring, mo.scale);

	spring.eflags = ($1 & ~MFE_VERTICALFLIP) | (mo.eflags & MFE_VERTICALFLIP);

	if (player.powers[pw_carry] != CR_NONE)
	and (player.powers[pw_carry] != CR_FAN)
		PogoSpring.Pop(player.mo);
		return;
	end

	--[[
	if (player.exiting)
		PogoSpring.JumpOff(player);
		return;
	end
	--]]

	if (mo.eflags & MFE_JUSTHITFLOOR) or (P_IsObjectOnGround(mo))
		local thrust = spring.health;
		if (player.cmd.buttons & BT_SPIN)
			thrust = $1 >> 1;
		end

		P_SetObjectMomZ(mo, thrust);

		spring.state = spring.info.seestate;
		S_StartSound(mo, spring.info.seesound);
	end

	if (mo.state != S_PLAY_POGOSPRING)
		mo.state = S_PLAY_POGOSPRING;
		player.panim = PA_IDLE;
	end
end

PogoSpring.CanDamage = function(player, victim)
	if not (player and player.valid)
		return nil;
	end

	if not (player.mo and player.mo.valid)
		return nil;
	end

	if not (player.HasPogoSpring)
		return nil;
	end

	local mo = player.mo;

	local bottom = mo.z;
	local top = mo.z + mo.height;

	if (mo.eflags & MFE_VERTICALFLIP)
		bottom = mo.z + mo.height;
		top = mo.z;
	end

	local flip = P_MobjFlip(mo);
	if (flip * (bottom - (victim.z + (victim.height >> 1))) > 0) -- Above
	or ((flip * mo.momz) < 0) -- Is falling
		-- Stomp'd!
		return true;
	end

	-- Use default check.
	return nil;
end

addHook("JumpSpecial", PogoSpring.JumpOff);

addHook("AbilitySpecial", PogoSpring.NoAbility);
addHook("SpinSpecial", PogoSpring.NoAbility);
addHook("JumpSpinSpecial", PogoSpring.NoAbility);

addHook("PlayerCanDamage", PogoSpring.CanDamage);

addHook("MobjDamage", PogoSpring.Pop, MT_PLAYER);
addHook("MobjDeath", PogoSpring.Pop, MT_PLAYER);

addHook("PlayerSpawn", function(player)
	if not (player and player.valid)
		return;
	end

	if not (player.mo and player.mo.valid)
		return;
	end

	if (player.HasPogoSpring == true)
		-- SUGOI keep items
		PogoSpring.Init(player);
	end
end);

addHook("PlayerThink", function(player)
	if (player.HasPogoSpring)
		PogoSpring.Think(player)
	end
end);
