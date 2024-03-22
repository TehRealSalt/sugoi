freeslot(
	"MT_EGGWORLD_OH",

	"S_EGGWORLD_OH",
	"S_EGGWORLD_OH_PAIN",
	"S_EGGWORLD_OH_DEATH",
	"S_EGGWORLD_OH_INTRO",

	"MT_EGGWORLD_OH_FIST",
	"S_EGGWORLD_OH_FIST",
	"S_EGGWORLD_OH_FIST_DIE",
	"S_EGGWORLD_OH_FIST_DIE2",

	"MT_EGGWORLD_OH_KNIFE",
	"S_EGGWORLD_OH_KNIFE",

	"SPR_EWOH",
	"SPR_EWHK",

	"sfx_egwor2",
	"sfx_ewhha1",
	"sfx_ewhha2",
	"sfx_ewhyel",
	"sfx_ewhdie"
)

mobjinfo[MT_EGGWORLD_OH] = {
	--$Name Egg World Over Heaven
	--$Sprite EWOHA1
	--$Category SUGOI Bosses
	doomednum = 3558,
	spawnstate = S_EGGWORLD_OH,
	painstate = S_EGGWORLD_OH_PAIN,
	deathstate = S_EGGWORLD_OH_DEATH,
	painsound = sfx_dmpain,
	deathsound = sfx_s3kb4,
	radius = 44*FRACUNIT,
	height = 144*FRACUNIT,
	spawnhealth = 24,
	speed = 12*FRACUNIT,
	reactiontime = 2*TICRATE,
	flags = MF_BOSS|MF_NOGRAVITY
}

states[S_EGGWORLD_OH] = {SPR_EWOH, A, -1, nil, 0, 0, S_EGGWORLD_OH};
states[S_EGGWORLD_OH_PAIN] = {SPR_EWOH, A, 24, A_Pain, 0, 0, S_EGGWORLD_OH};
states[S_EGGWORLD_OH_DEATH] = {SPR_EWOH, A, -1, nil, 0, 0, S_EGGWORLD_OH_DEATH};
states[S_EGGWORLD_OH_INTRO] = {SPR_EWOH, A, -1, nil, 0, 0, S_EGGWORLD_OH};

mobjinfo[MT_EGGWORLD_OH_FIST] = {
	spawnstate = S_EGGWORLD_OH_FIST,
	deathstate = S_EGGWORLD_OH_FIST_DIE,
	painsound = sfx_dmpain,
	deathsound = sfx_s3kb4,
	radius = 24*FRACUNIT,
	height = 48*FRACUNIT,
	spawnhealth = 1000,
	flags = MF_NOGRAVITY|MF_PAIN|MF_NOCLIPHEIGHT|MF_NOCLIP
}
states[S_EGGWORLD_OH_FIST] = {SPR_EWOH, B, -1, nil, 0, 0, S_EGGWORLD_OH_FIST};
states[S_EGGWORLD_OH_FIST_DIE] = {SPR_EWOH, B, 2, A_BossScream, 0, 0, S_EGGWORLD_OH_FIST_DIE2};
states[S_EGGWORLD_OH_FIST_DIE2] = {SPR_EWOH, B, 2, A_Repeat, 17, S_EGGWORLD_OH_FIST_DIE, S_NULL};

mobjinfo[MT_EGGWORLD_OH_KNIFE] = {
	spawnstate = S_EGGWORLD_OH_KNIFE,
	--seesound = sfx_knifes,
	--deathsound = sfx_knifed,
	spawnhealth = 1000,
	radius = 24*FRACUNIT,
	height = 4*FRACUNIT,
	speed = 40*FRACUNIT,
	flags = MF_PAIN|MF_NOGRAVITY
}
states[S_EGGWORLD_OH_KNIFE] = {SPR_EWHK, B|FF_FULLBRIGHT|FF_ANIMATE|FF_RANDOMANIM|FF_FLOORSPRITE, -1, nil, 1, 1, S_NULL};

sfxinfo[sfx_egworp].flags = SF_X4AWAYSOUND;
sfxinfo[sfx_egwor2].flags = SF_X4AWAYSOUND;
sfxinfo[sfx_knifes].flags = SF_X4AWAYSOUND;

sfxinfo[sfx_ewhha1].flags = SF_X2AWAYSOUND|SF_TOTALLYSINGLE;
sfxinfo[sfx_ewhha2].flags = SF_X2AWAYSOUND|SF_TOTALLYSINGLE;
sfxinfo[sfx_ewhyel].flags = SF_X2AWAYSOUND|SF_TOTALLYSINGLE;

--
-- Some misc constants.
--

-- Default number of hits needed to beat the boss at 1P.
local heaven_default_hp = mobjinfo[MT_EGGWORLD_OH].spawnhealth;

-- Healing decay speeds.
local heaven_decay_length = 2 * TICRATE; -- How long before extra (red) HP starts decaying.
local heaven_decay_amount = (FRACUNIT / 256) / TICRATE; --

local heaven_special_attack_health = FRACUNIT / 3;

-- Default A_CapeChase settings for the fist objects.
local default_fist_v = 12;
local default_fist_lr = 38;
local default_fist_fb = 56;

-- Distance values, based on the size of the (intended) map.
local arena_diameter = 2560 << FRACBITS;
local arena_radius = arena_diameter >> 1;
local melee_dist = arena_radius >> 1;

local tele_dist_outside = 1664 << FRACBITS;
local tele_dist_inside = 512 << FRACBITS;

-- Teleport visual settings
local telefxdist = 128;
local telefxtime = 6;

-- Spinning knife visual settings
local knife_shadow = FixedDiv(40*FRACUNIT, mobjinfo[MT_EGGWORLD_OH_KNIFE].radius);
local knife_spin = ANGLE_45 / 3;

-- Marx knife attack settings
local marx_knife_time = TICRATE;

--
-- Thinker settings for the spinning knives.
--

-- Don't do anything special
local KNIFE_NORMAL = 0;

-- Change angle over time, disappear after 1 second.
local KNIFE_MARX = 1;

--
-- Attack function types.
-- Each attack ID can define these, and will run these
-- when using that attack ID.
--
local ATK_FUNC_THINK = 0; -- Runs every tick during the attack
local ATK_FUNC_START = 1; -- Runs once at the start of the attack
local ATK_FUNC_END = 2; -- Runs once at the end of the attack

--
-- Attack IDs.
-- Defines all of the possible attacks. See also
-- the atk_pattern table.
--

-- ATK_TELEPORT: Do a teleport.
-- vars[1]: Behavior setting
local ATK_TELEPORT = 0;

-- Teleport randomly anywhere inside of the arena.
local TELEPORT_RANDOM = 0;
-- Teleport in one of eight spots outside of the arena.
-- The boss can't be damaged here.
local TELEPORT_OUTSIDE = 1;
-- Teleport in one of eight spots inside of the arena.
local TELEPORT_CENTER = 2;

-- ATK_CRAZYSPIN: Spin around in a straight line,
-- averaging the center of the arena and a random player
local ATK_CRAZYSPIN = 1;

-- ATK_MARX: Marx-style knife pattern
-- vars[1]: Number of times to repeat this attack
local ATK_MARX = 2;

--
-- Attack pattern table.
-- Sets the order of all of the attacks used.
-- Once the end of this table is reached, it repeats from the start.
-- Each entry is an attack ID, and then up to 3 variables the attack can use.
--

local atk_pattern = {
	{ ATK_TELEPORT, { TELEPORT_OUTSIDE, 0, 0 } },
	{ ATK_CRAZYSPIN, { 0, 0, 0 } },
	{ ATK_TELEPORT, { TELEPORT_OUTSIDE, 0, 0 } },
	{ ATK_CRAZYSPIN, { 0, 0, 0 } },

	{ ATK_TELEPORT, { TELEPORT_CENTER, 0, 0 } },
	{ ATK_MARX, { 1, 0, 0 } },

	{ ATK_TELEPORT, { TELEPORT_OUTSIDE, 0, 0 } },
	{ ATK_CRAZYSPIN, { 0, 0, 0 } },
	{ ATK_TELEPORT, { TELEPORT_OUTSIDE, 0, 0 } },
	{ ATK_CRAZYSPIN, { 0, 0, 0 } },

	{ ATK_TELEPORT, { TELEPORT_CENTER, 0, 0 } },
	{ ATK_MARX, { 1, 0, 0 } },

	{ ATK_TELEPORT, { TELEPORT_OUTSIDE, 0, 0 } },
	{ ATK_CRAZYSPIN, { 0, 0, 0 } },
	{ ATK_TELEPORT, { TELEPORT_OUTSIDE, 0, 0 } },
	{ ATK_CRAZYSPIN, { 0, 0, 0 } },

	{ ATK_TELEPORT, { TELEPORT_CENTER, 0, 0 } },
	{ ATK_TELEPORT, { TELEPORT_CENTER, 0, 0 } },
	{ ATK_TELEPORT, { TELEPORT_CENTER, 0, 0 } },
	{ ATK_MARX, { 3, 0, 0 } },
};
local atk_pattern_len = #atk_pattern;

--
-- Special attack pattern table.
-- Once reaching low enough health, the boss will pause
-- the main attack table, and then go through all of the
-- attacks in this table, and then resume the main table.
--
local atk_pattern_special = {
	{ ATK_TELEPORT, { TELEPORT_RANDOM, 0, 0 } },
};
local atk_pattern_special_len = #atk_pattern_special;

--
-- Global variables.
-- The contents of heaven_vars is net-synced
-- and reset upon revisiting the map.
--
local heaven_vars = nil;

local function Heaven_Reset()
	heaven_vars = {
		obj = nil,
		center = nil,
		damage_factor = FRACUNIT / heaven_default_hp,
		heal_factor = FRACUNIT / heaven_default_hp / 2,
		player_count = -1,
		death_flash = 0,
	};
end

Heaven_Reset();

addHook("MapLoad", Heaven_Reset);
addHook("MapChange", Heaven_Reset);

addHook("NetVars", function(net)
	heaven_vars = net(heaven_vars);
end);

--	Heaven_StopVoice(mo):
--		Stops all voice sound effects
local function Heaven_StopVoice(mo)
	S_StopSoundByID(mo, sfx_ewhha1);
	S_StopSoundByID(mo, sfx_ewhha2);
	S_StopSoundByID(mo, sfx_ewhyel);
end

--	Heaven_PlayYell(mo):
--		Makes the boss laugh
local function Heaven_PlayLaugh(mo)
	Heaven_StopVoice(mo);

	if (P_RandomByte() & 1)
		S_StartSound(mo, sfx_ewhha2);
	else
		S_StartSound(mo, sfx_ewhha1);
	end
end

--	Heaven_PlayYell(mo):
--		Makes the boss scream
local function Heaven_PlayYell(mo)
	Heaven_StopVoice(mo);
	S_StartSound(mo, sfx_ewhyel);
end

--	Heaven_PlayWarp(mo, inverted):
--		Plays a teleport sound for the boss
local function Heaven_PlayWarp(mo, inverted)
	S_StopSound(mo);

	if (inverted)
		S_StartSound(mo, sfx_egwor2);
	else
		S_StartSound(mo, sfx_egworp);
	end
end

--	Heaven_PlayerCount():
--		Returns the number of players in the server
local function Heaven_PlayerCount()
	if not (gametyperules & GTR_FRIENDLY)
		// Act like unmodified.
		return 1;
	end

	local numPlaying = 0;
	for player in players.iterate() do
		if (player.bot)
			// Don't count bots.
			continue;
		end

		if (player.spectator and not player.outofcoop)
			// Don't count intentional spectators,
			// but DO count Game Overs
			continue;
		end

		numPlaying = $1 + 1;
	end

	return numPlaying;
end

--	Heaven_FixedLog2(x):
--		Implements log2 for fixed point numbers
local function Heaven_FixedLog2(x)
	local precision = FRACBITS - 1; // need to reduce to fit into INT32
	local b = 1 << (precision - 1);
	local y = 0;

	if (x == 0)
		return INT32_MIN;
	end

	while (x < 1 << precision)
		x = $1 << 1;
		y = $1 - (1 << precision);
	end

	while (x >= 2 << precision)
		x = $1 >> 1;
		y = $1 + (1 << precision);
	end

	local z = x;

	for i = 0,precision-1 do
		z = z * z >> precision;

		if (z >= 2 << precision)
			z = $1 >> 1;
			y = $1 + b;
		end

		b = $1 >> 1;
	end

	return (y << 1) - FRACUNIT; // and then fudge here to get back to actual result
end

--	Heaven_HPMultiplier(playing_int):
--		Returns a multiplier for Coop HP scaling.
local function Heaven_HPMultiplier(playing_int)
	if (playing_int < 2)
		return FRACUNIT;
	end

	local playing = playing_int * FRACUNIT;
	return (playing + FRACUNIT) - RaidBosses.FixedLog2(playing);
end

--	Heaven_UpdateDamageFactor(mo, player_count):
--		Checks if Coop health scaling needs to be updated.
--		Does nothing if player count hasn't changed.
local function Heaven_UpdateDamageFactor(mo, player_count)
	if (heaven_vars.player_count == player_count)
		return;
	end

	local mul = Heaven_HPMultiplier(player_count);
	heaven_vars.damage_factor = FixedDiv(FRACUNIT, mul) / heaven_default_hp;
	heaven_vars.heal_factor = heaven_vars.damage_factor / 2;

	heaven_vars.player_count = player_count;
end

--	ATK_CreateKnife(mo, knife_type):
--		Handles creating spinning knife objects.
--		`knife_type` handles alternate knife thinkers.
local function ATK_CreateKnife(mo, knife_type)
	local knife = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_EGGWORLD_OH_KNIFE);
	if not (knife and knife.valid)
		return;
	end

	knife.target = mo;
	knife.renderflags = $1 | RF_NOSPLATBILLBOARD;

	-- Give extra knockback
	--knife.flags2 = $1 | MF2_EXPLOSION;

	-- Make bigger
	knife.scale = (4 * $1) / 3;

	-- Add drop shadows
	knife.shadowscale = knife_shadow;

	-- Set knife type
	knife.extravalue1 = knife_type;

	if (knife_type == KNIFE_MARX)
		knife.fuse = marx_knife_time;
	end

	return knife;
end

--	ATK_RandomTarget():
--		Gets a random player object in the server.
--		Can return nil if there aren't any usable players.
local function ATK_RandomTarget()
	local available = {};

	for player in players.iterate do
		if not (player.mo and player.mo.valid) continue end
		if not (player.mo.health) continue end
		if not (player.lives) continue end
		if (player.bot or player.spectator or player.exiting) continue end

		table.insert(available, player.mo);
	end

	if (#available > 0)
		return available[P_RandomKey(#available) + 1];
	end

	return nil;
end

--	ATK_ClosestTarget(mo):
--		Gets the closest player to the object.
--		Can return nil if there aren't any usable players.
local function ATK_ClosestTarget(mo)
	local bestmo = nil;
	local bestdist = arena_diameter << 1;

	for player in players.iterate do
		if not (player.mo and player.mo.valid) continue end
		if not (player.mo.health) continue end
		if not (player.lives) continue end
		if (player.bot or player.spectator or player.exiting) continue end

		local distance = R_PointToDist2(mo.x, mo.y, player.mo.x, player.mo.y);

		if (distance < bestdist)
			bestmo = player.mo;
			bestdist = distance;
		end
	end

	if (bestmo and bestmo.valid)
		return bestmo;
	end

	return nil;
end

--	ATK_EstimationVal(mo, target, speed):
--		Estimate where the player is going to be,
--		if throwing bullets in their direction is desired.
local function ATK_EstimationVal(mo, target, speed)
	if (speed == nil)
		speed = mobjinfo[MT_EGGWORLD_OH_KNIFE].speed;
	end

	local est = R_PointToDist2(mo.x, mo.y, target.x, target.y) / (speed << 1);
	local ang = R_PointToAngle2(mo.x, mo.y, target.x + (target.momx * est), target.y + (target.momy * est));

	if (abs(mo.angle - ang) > ANGLE_90)
		-- Don't turn stupidly hard because of thok
		-- Might rarely cause an odd projectile to be thrown slightly more to the side
		-- but it'll be corrected near instantly so I'm not too bothered -- better than shooting OPPOSITE from the player
		return 0;
	else
		return est;
	end
end

--	Heaven_FistUpdate(mo, instant):
--		Moves the fists over time and handles visual updates.
local function Heaven_FistUpdate(mo, instant)
	for i = 1,2 do
		if not (mo.world_vars.fists[i] and mo.world_vars.fists[i].valid)
			mo.world_vars.fists[i] = P_SpawnMobj(mo.x, mo.y, mo.z, MT_EGGWORLD_OH_FIST);
		end

		local fist = mo.world_vars.fists[i];

		if (fist.fist_vars == nil)
			fist.fist_vars = {
				v_pos = default_fist_v,
				v_pos_dest = default_fist_v,
				lr_pos = default_fist_lr,
				lr_pos_dest = default_fist_lr,
				fb_pos = default_fist_fb,
				fb_pos_dest = default_fist_fb,
			};
		end

		fist.target = mo;

		if (instant == true)
			fist.fist_vars.v_pos = fist.fist_vars.v_pos_dest;
			fist.fist_vars.lr_pos = fist.fist_vars.lr_pos_dest;
			fist.fist_vars.fb_pos = fist.fist_vars.fb_pos_dest;
		else
			fist.fist_vars.v_pos = $1 + ((fist.fist_vars.v_pos_dest - $1) / 4);
			fist.fist_vars.lr_pos = $1 + ((fist.fist_vars.lr_pos_dest - $1) / 4);
			fist.fist_vars.fb_pos = $1 + ((fist.fist_vars.fb_pos_dest - $1) / 4);
		end

		fist.sprite = SPR_EWOH;
		fist.frame = B;

		fist.shadowscale = FRACUNIT;

		fist.flags2 = ($1 & ~MF2_DONTDRAW) | (mo.flags2 & MF2_DONTDRAW);

		if (mo.state != S_EGGWORLD_OH)
		or ((mo.flags2 & (MF2_FRET|MF2_DONTDRAW)) != 0)
			fist.flags = ($1 & ~MF_PAIN);

			if (mo.flags2 & MF2_FRET)
			and (leveltime % 2 == 0)
				fist.frame = D;
			end
		else
			fist.flags = ($1 | MF_PAIN);
		end

		local lr = fist.fist_vars.lr_pos;
		if ((i - 1) & 1)
			lr = -lr;
		end

		fist.flags2 = $1 | MF2_EXPLOSION;
		A_CapeChase(
			fist,
			fist.fist_vars.v_pos << 16,
			(fist.fist_vars.fb_pos << 16) + lr
		);
	end
end

--	Heaven_CheckTelePos(world, mo):
--		Blockmap iteration function for ATK_TELEPORT.
--		Checks if the player is too close to the teleport position.
local function Heaven_CheckTelePos(world, mo)
	if (mo.z > (heaven_vars.center.z + 128 << FRACBITS))
		return nil; -- don't count flying players
	end

	if (mo.player and mo.player.valid)
		return true;
	end

	return nil;
end

--
-- Attack function table.
-- Thes functions are called during each attack.
--
local heaven_atk_funcs = {
	[ATK_TELEPORT] = {
		[ATK_FUNC_START] = function(mo)
			-- Teleport away.
			-- Make ourselves intangible.
			mo.flags = $1 & ~(MF_SPECIAL|MF_SHOOTABLE);
			mo.flags2 = $1 | MF2_DONTDRAW;

			-- Update our fists to also be intangible.
			Heaven_FistUpdate(mo, false);

			-- Spawn afterimages going out of us.
			for i = 0,7 do
				local ghost = P_SpawnGhostMobj(mo);
				ghost.momx = (telefxdist / telefxtime) * cos(ANGLE_45 * i);
				ghost.momy = (telefxdist / telefxtime) * sin(ANGLE_45 * i);
				ghost.fuse = telefxtime;

				for j = 1,2 do
					local fist = mo.world_vars.fists[j];
					if (fist and fist.valid)
						local ghost = P_SpawnGhostMobj(fist);
						ghost.momx = (telefxdist / telefxtime) * cos(ANGLE_45 * i);
						ghost.momy = (telefxdist / telefxtime) * sin(ANGLE_45 * i);
						ghost.fuse = telefxtime;
					end
				end
			end

			-- Play warp sound
			Heaven_PlayWarp(mo, false);

			-- Set delay
			mo.world_vars.attack_delay = TICRATE * 2 / 3;
		end,
		[ATK_FUNC_THINK] = function(mo)
			-- Spawn the afterimage effect right before reappearing
			if (mo.world_vars.attack_delay == telefxtime)
				-- Find a place that isn't taken up by a player, so you don't cheap hit 'em.
				-- (If nothing's free, then fuck it.)

				local angi = P_RandomRange(0, 7); -- Pick random angle

				if (mo.world_vars.attack_vars[1] == TELEPORT_OUTSIDE)
					-- We're teleporting outside of the arena, so it shouldn't ever be blocked.
					P_SetOrigin(mo,
						heaven_vars.center.x + FixedMul(tele_dist_outside, cos(angi * ANGLE_45)),
						heaven_vars.center.y + FixedMul(tele_dist_outside, sin(angi * ANGLE_45)),
						heaven_vars.center.z
					);
				else
					-- Blockmap iteration returns false if the search was stopped at any point.
					local goodpos = false;
					local tries = 8;

					while ((not goodpos) and (tries > 0))
						angi = $1 + 1;
						if (angi > 7)
							angi = 0;
						end

						local tele_dist = tele_dist_inside;
						if (mo.world_vars.attack_vars[1] == TELEPORT_CENTER)
							tele_dist = 256 << FRACBITS;
						end

						-- Move to new position
						P_SetOrigin(mo,
							heaven_vars.center.x + FixedMul(tele_dist_inside, cos(angi * ANGLE_45)),
							heaven_vars.center.y + FixedMul(tele_dist_inside, sin(angi * ANGLE_45)),
							heaven_vars.center.z
						);

						-- Make sure there's plenty of room for the player to react
						local radius = (mobjinfo[MT_EGGWORLD_OH].radius + mobjinfo[MT_EGGWORLD_OH_FIST].radius) << 2;
						goodpos = searchBlockmap(
							"objects", Heaven_CheckTelePos, mo,
							mo.x - radius, mo.x + radius,
							mo.y - radius, mo.y + radius
						);
						tries = $1 - 1;
					end
				end

				-- Point toward the middle.
				mo.angle = R_PointToAngle2(
					mo.x, mo.y,
					heaven_vars.center.x, heaven_vars.center.y
				);
				mo.world_vars.angle_dest = mo.angle;

				Heaven_FistUpdate(mo, true);

				-- Visual & stuff
				Heaven_PlayWarp(mo, true);

				for i = 0,7 do
					local ghost = P_SpawnGhostMobj(mo);
					P_SetOrigin(ghost,
						mo.x + (telefxdist * cos(ANGLE_45*i)),
						mo.y + (telefxdist * sin(ANGLE_45*i)),
						mo.z
					);
					ghost.momx = (telefxdist / telefxtime) * cos((ANGLE_45*i) + ANGLE_180);
					ghost.momy = (telefxdist / telefxtime) * sin((ANGLE_45*i) + ANGLE_180);
					ghost.fuse = telefxtime;

					for j = 1,2 do
						local fist = mo.world_vars.fists[j];
						if (fist and fist.valid)
							ghost = P_SpawnGhostMobj(fist);
							P_SetOrigin(ghost,
								fist.x + (telefxdist * cos(ANGLE_45*i)),
								fist.y + (telefxdist * sin(ANGLE_45*i)),
								fist.z
							);

							ghost.momx = (telefxdist / telefxtime) * cos((ANGLE_45*i) + ANGLE_180);
							ghost.momy = (telefxdist / telefxtime) * sin((ANGLE_45*i) + ANGLE_180);
							ghost.fuse = telefxtime;
						end
					end
				end
			end
		end,
		[ATK_FUNC_END] = function(mo)
			-- Make tangible again.
			mo.flags = $1 | (MF_SPECIAL|MF_SHOOTABLE);
			mo.flags2 = $1 & ~MF2_DONTDRAW;
			Heaven_FistUpdate(mo, false);
		end,
	},

	[ATK_CRAZYSPIN] = {
		[ATK_FUNC_START] = function(mo)
			-- Pick a target to bully specifically.
			mo.target = ATK_RandomTarget();

			-- Aim between them and the center.
			local aim_x = heaven_vars.center.x;
			local aim_y = heaven_vars.center.y;

			if (mo.target and mo.target.valid)
				aim_x = $1 + (mo.target.x / 2);
				aim_y = $1 + (mo.target.y / 2);
			end

			-- Thrust in that direction.
			mo.movedir = R_PointToAngle2(mo.x, mo.y, aim_x, aim_y);
			P_InstaThrust(mo, mo.movedir, FRACUNIT);

			-- Update angles.
			mo.angle = mo.movedir;
			mo.world_vars.angle_dest = mo.movedir;

			-- Put the fists out to the sides.
			for i = 1,2 do
				local fist = mo.world_vars.fists[i];
				if (fist and fist.valid)
					fist.fist_vars.lr_pos_dest = 128;
				end
			end

			Heaven_PlayLaugh(mo);
			mo.world_vars.attack_delay = 5 * TICRATE / 3;
		end,
		[ATK_FUNC_THINK] = function(mo)
			-- Get faster over time.
			P_Thrust(mo, mo.movedir, 2 * FRACUNIT);

			-- SPIN!
			mo.world_vars.angle_dest = $1 + ANG10;

			for i = 1,2 do
				local fist = mo.world_vars.fists[i];
				if (fist and fist.valid)
					fist.fist_vars.lr_pos_dest = 128;
					fist.fist_vars.fb_pos_dest = 0;
				end
			end

			if (leveltime % 15 == 0)
				-- Play scary ambiance
				S_StartSound(mo, sfx_s3kc0s);
			end
		end,
	},

	[ATK_MARX] = {
		[ATK_FUNC_START] = function(mo)
			-- Aim towards whoever's the closest
			mo.target = ATK_ClosestTarget(mo);

			if (mo.target and mo.target.valid)
				mo.world_vars.angle_dest = R_PointToAngle2(mo.x, mo.y, mo.target.x, mo.target.y);
			end

			-- Put your arms in the air
			for i = 1,2 do
				local fist = mo.world_vars.fists[i];
				if (fist and fist.valid)
					fist.fist_vars.lr_pos_dest = default_fist_lr * 2;
					fist.fist_vars.fb_pos_dest = 0;
					fist.fist_vars.v_pos_dest = 112;
				end
			end

			Heaven_PlayYell(mo);
			mo.world_vars.attack_delay = 2*TICRATE;
		end,
		[ATK_FUNC_THINK] = function(mo)
			if (mo.world_vars.attack_delay == marx_knife_time)
				-- Play the knife throw sound
				S_StartSound(mo, sfx_knifes);

				-- Create knives with KNIFE_MARX type,
				-- push them out in a circle
				for i = 1,4 do
					local knife = ATK_CreateKnife(mo, KNIFE_MARX);
					knife.z = mo.z + 24*FRACUNIT;
					knife.movedir = (mo.angle - ANGLE_45) + (ANGLE_90 * i);
					knife.angle = knife.movedir;
					P_InstaThrust(knife, knife.movedir, knife.info.speed);
				end

				-- Handle repeat count.
				-- Extend the current timer, then decrement the variable.
				if (mo.world_vars.attack_vars[1] > 1)
					mo.world_vars.attack_delay = $1 + (marx_knife_time * 3 / 4);
					mo.world_vars.attack_vars[1] = $1 - 1;
				end

				-- Stop vibrating.
				mo.spritexoffset = 0;
				mo.spriteyoffset = 0;
			elseif (mo.world_vars.attack_delay > marx_knife_time)
				-- Vibrate furiously before you attack.
				mo.spritexoffset = P_RandomRange(-8, 8) * FRACUNIT;
				mo.spriteyoffset = P_RandomRange(-8, 8) * FRACUNIT;
			end
		end,
	},
};

--	ATK_RunFunc(mo, funcType, atkID):
--		Runs an attack function from our attack
--		function table, if it exists.
local function ATK_RunFunc(mo, funcType, atkID)
	if (atkID == nil)
		atkID = mo.world_vars.attack_id;
	end

	local funcHeap = heaven_atk_funcs[ atkID ];
	if (funcHeap == nil)
		return;
	end

	local atkFunc = funcHeap[funcType];
	if (atkFunc == nil)
		return;
	end

	atkFunc(mo);
end

--	ATK_AttackStart(mo):
--		Starts a new attack.
local function ATK_AttackStart(mo)
	-- Remove target every new attack;
	-- a target should be set in the attack function.
	mo.target = nil;

	-- Quit moving inbetween attacks
	mo.momx = 0;
	mo.momy = 0;
	mo.momz = 0;

	-- Reset to default fist positions
	for i = 1,2 do
		local fist = mo.world_vars.fists[i];
		if (fist and fist.valid)
			fist.fist_vars.lr_pos_dest = default_fist_lr;
			fist.fist_vars.fb_pos_dest = default_fist_fb;
			fist.fist_vars.v_pos_dest = default_fist_v;
		end
	end

	ATK_RunFunc(mo, ATK_FUNC_START);
	mo.world_vars.attack_delay = $1 + 1; -- buffer tic
end

--	ATK_AttackEnd(mo):
--		Finalizes the current attack before
--		moving onto another one.
local function ATK_AttackEnd(mo)
	--mo.world_vars.attack_delay = 0;
	ATK_RunFunc(mo, ATK_FUNC_END);
end

--	ATK_SetUpNext(mo, force):
--		Handles changing the boss's current attack.
--		`force` can be used to use a specific attack ID and vars,
--		otherwise it will use the attack pattern table.
local function ATK_SetUpNext(mo, force)
	-- Run previous attack's end
	ATK_AttackEnd(mo);

	-- Table of new attack info
	local atk_info = nil;

	if (force != nil)
		-- Force to a specific attack
		atk_info = force;
	elseif (mo.world_vars.attack_special_pos <= atk_pattern_special_len)
	and ((mo.world_vars.attack_special_pos > 1) -- Already started the special attack
	or (mo.world_vars.health <= heaven_special_attack_health)) -- Health lowered below threshold
		-- Do super special attack pattern at low health
		atk_info = atk_pattern_special[mo.world_vars.attack_special_pos];

		-- Set pattern position for next call
		mo.world_vars.attack_special_pos = $1 + 1;

		-- Ends if above table length
	else
		atk_info = atk_pattern[mo.world_vars.attack_pos];

		-- Set pattern position for next call
		mo.world_vars.attack_pos = $1 + 1;

		if (mo.world_vars.attack_pos > atk_pattern_len) -- Reset if above table length
			mo.world_vars.attack_pos = 1;
		end
	end

	-- Set new attack ID
	mo.world_vars.attack_id = atk_info[1];
	mo.world_vars.attack_vars = { 0, 0, 0 };

	if (atk_info[2] != nil)
		for i = 1,3 do
			mo.world_vars.attack_vars[i] = atk_info[2][i];
		end
	end

	-- Run new attack's start
	ATK_AttackStart(mo);
end

--	ATK_Handler(mo):
--		Handles running all of the boss's attack
--		functions every tick.
local function ATK_Handler(mo)
	if (mo.world_vars.attack_delay > 0)
		mo.world_vars.attack_delay = $1 - 1;
	end

	if (mo.world_vars.attack_delay <= 0)
		ATK_SetUpNext(mo);
		return;
	end

	ATK_RunFunc(mo, ATK_FUNC_THINK);
end

--	Heaven_IntroHandler(mo):
--		Thinker during intro animation.
local INTRO_DELAY = TICRATE;
local INTRO_TIME = 4 * TICRATE;

local function Heaven_IntroHandler(mo)
	if (leveltime < INTRO_DELAY)
		return;
	end

	if (mo.world_vars.intro > INTRO_TIME)
		-- Set normal properties
		mo.state = S_EGGWORLD_OH;
		mo.flags = MF_BOSS|MF_NOGRAVITY|MF_SPECIAL|MF_SHOOTABLE;
		mo.z = mo.floorz;

		for i = 1,2 do
			local fist = mo.world_vars.fists[i];
			if (fist and fist.valid)
				fist.state = S_EGGWORLD_OH_FIST;
				fist.flags = $1 | MF_PAIN;
			end
		end

		sugoi.SetBoss(mo, "Egg World Over Heaven");

		P_StartQuake(24 * FRACUNIT, TICRATE);

		if (mo.world_vars.intro_beam and mo.world_vars.intro_beam.valid)
			mo.world_vars.intro_beam.destscale = FRACUNIT / 8;
			mo.world_vars.intro_beam.scalespeed = 4 * FRACUNIT;
		end

		-- Teleport away
		ATK_SetUpNext(mo, atk_pattern[1]);
		return;
	end

	if (mo.world_vars.intro == 0)
		mapmusname = "EWOH";
		S_ChangeMusic(mapmusname, true);
	end

	local intro_time_left = (INTRO_TIME - mo.world_vars.intro);
	local intro_time_frac = (mo.world_vars.intro * FRACUNIT) / INTRO_TIME;

	if not (mo.world_vars.intro_beam and mo.world_vars.intro_beam.valid)
		mo.world_vars.intro_beam = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_EGGWORLD_INTROBEAM);
		mo.world_vars.intro_beam.z = mo.floorz;
		mo.world_vars.intro_beam.target = mo;
		mo.world_vars.intro_beam.scale = FRACUNIT / 8;
		mo.world_vars.intro_beam.scalespeed = 2 * FRACUNIT;
		mo.world_vars.intro_beam.destscale = 64 * FRACUNIT;
	end

	mo.z = mo.floorz + (intro_time_left * FRACUNIT);
	Heaven_FistUpdate(mo);

	local trans = ease.linear(intro_time_frac, NUMTRANSMAPS, -1);

	if (trans < NUMTRANSMAPS)
		local trans_flag = 0;
		if (trans > 0)
			trans_flag = (trans << FF_TRANSSHIFT);
		end

		mo.flags2 = $1 & ~MF2_DONTDRAW;

		if (trans == -1)
			mo.sprite = SPR_EWOH;
			mo.frame = A;
		else
			mo.sprite = SPR_EWLD;
			mo.frame = J|FF_FULLBRIGHT|trans_flag;
		end

		for i = 1,2 do
			local fist = mo.world_vars.fists[i];
			if (fist and fist.valid)
				if (trans == -1)
					fist.sprite = SPR_EWOH;
					fist.frame = B;
				else
					fist.sprite = SPR_EWLD;
					fist.frame = L|FF_FULLBRIGHT|trans_flag;
				end

				fist.flags = $1 & ~MF_PAIN;
				fist.flags2 = $1 & ~MF2_DONTDRAW;
			end
		end
	end

	P_StartQuake(ease.outsine(intro_time_frac, 16*FRACUNIT, 0), 2);

	mo.world_vars.intro = $1 + 1;
end

--	Heaven_DeathHandler(mo):
--		Thinker during outro animation.
local DEATH_RISE_TIME = 4*TICRATE;
local DEATH_RED_TIME = 5*TICRATE;
local DEATH_QUAKE_LEN = 292;

local function Heaven_DeathHandler(mo)
	mo.flags2 = $1 & ~MF2_FRET;
	if (mo.world_vars.death == 0)
		S_FadeOutStopMusic(MUSICRATE);
		P_FadeLight(65535, -96, DEATH_RISE_TIME, true, true, true);
	end

	for i = 1,2 do
		if (mo.world_vars.fists[i] and mo.world_vars.fists[i].valid)
			local fist = mo.world_vars.fists[i];
			fist.flags = $1 & ~MF_PAIN;
			if (fist.health > 0)
				P_KillMobj(fist, mo, mo);
				fist.health = 0;
			end
			mo.world_vars.fists[i] = nil;
		end
	end

	if (mo.world_vars.death == 0)
	or (mo.world_vars.death == TICRATE)
		heaven_vars.death_flash = 10;
		S_StartSound(nil, sfx_storm1); -- from bother
	elseif (mo.world_vars.death == DEATH_RISE_TIME)
		local beam = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_EGGWORLD_INTROBEAM);
		beam.z = mo.floorz;
		beam.target = mo;
		beam.scale = FRACUNIT / 8;
		beam.scalespeed = 2 * FRACUNIT;
		beam.destscale = 64 * FRACUNIT;

		mo.momz = FRACUNIT / 2;
	elseif (mo.world_vars.death == DEATH_RED_TIME)
		mo.color = SKINCOLOR_SALMON;
		mo.colorized = true;
		mo.renderflags = $1 | RF_FULLBRIGHT;
		mo.blendmode = AST_ADD;
		mo.momz = FRACUNIT;

		S_StartSound(nil, sfx_ewhdie);
	elseif (mo.world_vars.death > DEATH_RED_TIME)
		local death_quake = mo.world_vars.death - DEATH_RED_TIME;

		if (death_quake <= DEATH_QUAKE_LEN)
			local death_frac = (death_quake * FRACUNIT) / DEATH_QUAKE_LEN;
			local trans = ease.linear(death_frac, 0, NUMTRANSMAPS);

			if (trans < NUMTRANSMAPS)
				local trans_flag = 0;
				if (trans > 0)
					trans_flag = (trans << FF_TRANSSHIFT);
				end

				mo.frame = E | trans_flag;
			else
				mo.flags2 = $1 | MF2_DONTDRAW;
			end

			P_StartQuake(ease.outsine(death_frac, 32*FRACUNIT, 4*FRACUNIT), TICRATE);
		else
			for player in players.iterate do
				if not (player.exiting)
					player.exiting = TICRATE;
				end
			end
		end

		if (death_quake >= DEATH_QUAKE_LEN - 3*TICRATE)
		and (heaven_vars.death_flash < 10)
		and (mo.world_vars.death % 10 == 0)
			heaven_vars.death_flash = $1 + 1;
		end
	else
		if (heaven_vars.death_flash > 0)
			heaven_vars.death_flash = $1 - 1;
		end
	end

	mo.world_vars.death = $1 + 1;
end

--
-- Egg World Over Heaven main thinker
--
addHook("BossThinker", function(mo)
	heaven_vars.obj = mo;

	mo.flags2 = $1 | MF2_EXPLOSION;
	mo.friction = FRACUNIT;

	if (leveltime < 2)
		-- Wait until level is totally loaded.
		return;
	end

	local player_count = Heaven_PlayerCount();

	if (mo.world_vars == nil) -- We haven't been initialized yet
		-- Find boss center mapthing.
		for mt in mapthings.iterate do
			if (mt.type == mobjinfo[MT_BOSS3WAYPOINT].doomednum)
			and (mt.mobj and mt.mobj.valid)
				heaven_vars.center = mt.mobj;
				break;
			end
		end

		if not (heaven_vars.center and heaven_vars.center.valid)
			print("NO BOSS CENTER!");
			P_RemoveMobj(mo);
			return;
		end

		-- Init Egg World variables.
		mo.world_vars = {
			health = FRACUNIT, -- percentage health!
			heal = 0, -- healing when he hurts you! kinda loosely based off fighting games!
			heal_decay = 0, -- decays over time!
			invuln_timer = 0,
			fists = {},
			angle_dest = mo.angle,
			intro = 0,
			death = 0,

			attack_pos = 1,
			attack_special_pos = 1,
			attack_id = ATK_WAIT,
			attack_vars = { 0, 0, 0 },
			attack_delay = TICRATE,

			did_special_attack = false,
		};

		heaven_vars.player_count = -1; -- force health update
		Heaven_UpdateDamageFactor(mo, player_count);

		-- Go to intro state
		mo.state = S_EGGWORLD_OH_INTRO;
		return;
	end

	if (mo.state == S_EGGWORLD_OH_INTRO)
		-- Run intro
		Heaven_IntroHandler(mo);
		return;
	elseif (mo.state == S_EGGWORLD_OH_DEATH)
		-- Run outro
		Heaven_DeathHandler(mo);
		return;
	end

	if (mo.world_vars.intro_beam and mo.world_vars.intro_beam.valid)
	and (mo.world_vars.intro_beam.scale == mo.world_vars.intro_beam.destscale)
		-- Remove intro beam once the boss has started
		P_RemoveMobj(mo.world_vars.intro_beam);
	end

	if (mo.world_vars.health <= 0)
		-- Percentage health is gone! Kill the boss!
		P_KillMobj(mo);
		return;
	end

	-- Prevent players from being able to kill the boss
	-- until we die on our own terms
	mo.health = mo.info.spawnhealth;

	-- Update Coop health scaling, if needed.
	Heaven_UpdateDamageFactor(mo, player_count);

	if not (mo.flags2 & MF2_FRET)
		-- Decay red HP over time
		if (mo.world_vars.heal > 0)
			if (mo.world_vars.heal_decay >= heaven_decay_length)
				mo.world_vars.heal = $1 - heaven_decay_amount;
			else
				mo.world_vars.heal_decay = $1 + 1;
			end
		else
			mo.world_vars.heal_decay = 0;
		end
	end

	-- Update fist locations
	Heaven_FistUpdate(mo);
	for i = 1,2 do
		if not (mo.world_vars.fists[i] and mo.world_vars.fists[i].valid)
			-- Something horribly wrong has happened.
			-- Try again next tick.
			return;
		end
	end

	/*
	-- Move fists up and down to match our target
	local fist_height = (mo.target.z - mo.z) / FRACUNIT;
	local fist_height_min = default_fist_v;
	local fist_height_max = (mo.height / FRACUNIT) - 16;

	if (fist_height < default_fist_v)
		fist_height = default_fist_v;
	elseif (fist_height > fist_height_max)
		fist_height = fist_height_max;
	end
	*/

	-- Make sure we're always using the correct frame
	mo.frame = A;
	if (mo.flags2 & MF2_FRET) and (leveltime % 2 == 0)
		mo.frame = C;
	end

	-- Rotate to match our desired angle over time.
	mo.angle = $1 + ((mo.world_vars.angle_dest - $1) / 8);

	-- Run our attack logic
	ATK_Handler(mo);
end, MT_EGGWORLD_OH);

--
-- Handle spinning knifes thinker
--
addHook("MobjThinker", function(mo)
	if not (mo.health)
		return
	end

	mo.angle = $1 + knife_spin;

	if (mo.fuse and mo.fuse < TICRATE)
	and (mo.extravalue1 != KNIFE_MARX)
		mo.flags2 = $1 ^^ MF2_DONTDRAW;
	end

	if (mo.extravalue1 == KNIFE_MARX)
		-- Marx bullets
		mo.movedir = $1 + ANG10;

		local spd = R_PointToDist2(0, 0, mo.momx, mo.momy);
		P_InstaThrust(mo, mo.movedir, spd);
	end

	--[[
	-- disabled for lag
	if not (mo.cusval)
		local ghost = P_SpawnGhostMobj(mo)
		ghost.fuse = 4
	end
	--]]
end, MT_EGGWORLD_OH_KNIFE)

--
-- On damage, remove some percentage health,
-- add some red HP, and reset red HP decay.
--
addHook("MobjDamage", function(tar, inf, src)
	tar.world_vars.health = max(0, $1 - heaven_vars.damage_factor);
	tar.world_vars.heal = $1 + heaven_vars.heal_factor;
	tar.world_vars.heal_decay = 0;
end, MT_EGGWORLD_OH);

--
-- Hide the boss for the intro.
--
addHook("MobjSpawn", function(mo)
	mo.flags2 = $1 | MF2_DONTDRAW;
end, MT_EGGWORLD_OH);

--
-- When the player gets damaged, heal the boss's
-- extra (red) HP on the boss meter.
--
addHook("MobjDamage", function(tar, inf, src)
	if not (heaven_vars.obj and heaven_vars.obj.valid)
		return;
	end

	if (tar and tar.valid)
	and (tar.player and tar.player.valid)
	and (tar.player.bot == BOT_2PAI)
		return;
	end

	local world = heaven_vars.obj;

	world.world_vars.health = min($1 + world.world_vars.heal, FRACUNIT);
	world.world_vars.heal = 0;
	world.world_vars.heal_decay = 0;

	if (tar and tar.valid)
	and ((inf and inf.valid and inf.type == MT_EGGWORLD_OH_KNIFE)
	or (src and src.valid and src.type == MT_EGGWORLD_OH_KNIFE))
		S_StartSound(tar, sfx_knifed);
	end
end, MT_PLAYER);

--	Heaven_FistBlock(fist, bullet):
--		MobjCollide hook for making the fists destroy
--		Fang's projectiles.
local function Heaven_FistBlock(fist, bullet)
	if not (fist and fist.valid)
		return;
	end

	if not (bullet and bullet.valid)
		return;
	end

	if not (bullet.flags & MF_MISSILE)
		return;
	end

	if (fist.target == bullet.target)
		return;
	end

	if (bullet.z + bullet.height < fist.z)
	or (bullet.z > fist.z + fist.height)
		return;
	end

	P_KillMobj(bullet);
	S_StartSound(nil, sfx_mspogo);
	return true;
end

addHook("MobjCollide", Heaven_FistBlock, MT_EGGWORLD_OH_FIST);
addHook("MobjMoveCollide", Heaven_FistBlock, MT_EGGWORLD_OH_FIST);

--
-- Draw death flash effect
--
hud.add(function(v)
	if (heaven_vars.death_flash > 0)
		local white = v.cachePatch("WHIPTE");

		local screen_scale = max(
			v.width() / v.dupx(),
			v.height() / v.dupy()
		);

		local flag = ((NUMTRANSMAPS - heaven_vars.death_flash) << FF_TRANSSHIFT);

		v.drawScaled(
			-1, -1,
			(screen_scale * FRACUNIT) + 2,
			white,
			V_SNAPTOTOP|V_SNAPTOLEFT|flag
		);
	end
end)
