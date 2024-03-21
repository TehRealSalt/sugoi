sugoi.displayboss = nil;
sugoi.bossHUD = nil;
sugoi.queueBoss = nil;

function sugoi.SetBoss(boss, name)
	sugoi.displayboss = {
		mo = boss,
		nametag = name,
	};

	sugoi.bossHUD = {
		prev_hp = 0,
		disp_hp = 0,
		disp_hp_delta = 0,
		disp_red = 0,
		shake = 0,
	};

	sugoi.queueBoss = nil;
end

function sugoi.BossLookup()
	if (mapheaderinfo[gamemap].sugoibossmeter == nil)
		return;
	end

	local boss_name = nil;
	if (mapheaderinfo[gamemap].sugoibossmeter != "?")
		boss_name = mapheaderinfo[gamemap].sugoibossmeter;
	end

	for mt in mapthings.iterate do
		if (mt.mobj and mt.mobj.valid)
		and (mt.mobj.flags & MF_BOSS)
			//sugoi.SetBoss(mt.mobj, boss_name);
			sugoi.queueBoss = {
				boss = mt.mobj,
				name = boss_name,
			};
			return;
		end
	end
end

function sugoi.CheckQueuedBoss()
	if (sugoi.queueBoss == nil)
		return;
	end

	if not (sugoi.queueBoss.boss and sugoi.queueBoss.boss.valid)
		sugoi.queueBoss = nil;
		return;
	end

	if (sugoi.queueBoss.boss.target and sugoi.queueBoss.boss.target.valid)
		-- Boss noticed a player, so show the boss meter!
		sugoi.SetBoss(sugoi.queueBoss.boss, sugoi.queueBoss.name);
	end
end

local BOSS_METER_X = 138;
local BOSS_METER_Y = 176;
local BOSS_METER_FILL_OFFSET = 12;
local BOSS_METER_FILL_FUDGE = BOSS_METER_FILL_OFFSET + 5;
local BOSS_METER_FILL_WIDTH = 152;
local BOSS_METER_NAME_X = 304;
local BOSS_METER_NAME_Y = BOSS_METER_Y - 8;
local BOSS_METER_NAME_MAX = 144;
local BOSS_METER_EPSILON = FRACUNIT / BOSS_METER_FILL_WIDTH;
local BOSS_METER_SHAKE_TIME = 12;
local BOSS_METER_SHAKE_DIST = 4;
local BOSS_METER_SHAKE_SPIN = ANGLE_67h * 3 / 2;

local function drawBossMeter(v, player)
	if (sugoi.displayboss == nil)
		return;
	end

	local boss = sugoi.displayboss.mo;
	if not (boss and boss.valid)
		sugoi.displayboss = nil;
		return;
	end

	if (sugoi.bossHUD == nil)
		sugoi.bossHUD = {
			prev_hp = 0,
			disp_hp = 0,
			disp_hp_delta = 0,
			disp_red = 0,
			shake = 0,
		};
	end

	local hp_percent = 0;
	local red_percent = 0;

	if (boss.health > 0)
		if (boss.type == MT_EGGWORLD_OH)
			if (boss.world_vars != nil)
				hp_percent = boss.world_vars.health;
				red_percent = hp_percent + boss.world_vars.heal;
			end
		elseif (boss.type == MT_EGGLAS2)
			if (boss.acttime != nil)
				hp_percent = FixedDiv(boss.acttime, 2100);
			end
		else
			hp_percent = FixedDiv(boss.health, boss.info.spawnhealth);

			if (boss.raidBoss != nil)
				hp_percent = $1 - (boss.raidBoss.poise / boss.info.spawnhealth);
			end
		end
	end

	local function lerpHP(cur, dest)
		local ret = cur;

		if (cur != dest)
			local delta = (dest - cur);

			if (abs(delta) < BOSS_METER_EPSILON)
				ret = dest;
			else
				ret = $1 + (delta / 8);
			end
		end

		return ret;
	end

	if (hp_percent < sugoi.bossHUD.prev_hp and boss.type != MT_EGGLAS2)
	or (hp_percent == 0 and sugoi.bossHUD.disp_hp > 0)
		sugoi.bossHUD.shake = BOSS_METER_SHAKE_TIME;
	end
	sugoi.bossHUD.prev_hp = hp_percent;

	sugoi.bossHUD.disp_hp = lerpHP($1, hp_percent);
	if (sugoi.bossHUD.shake == 0)
		sugoi.bossHUD.disp_hp_delta = lerpHP($1, hp_percent);
		sugoi.bossHUD.disp_red = lerpHP($1, red_percent);
	end

	local bar_empty = v.cachePatch("BOSS_BAR");
	local bar_fill = v.cachePatch("BOSS_FIL");
	local bar_fill_flash = v.cachePatch("BOSS_FI2");
	local bar_fill_red = v.cachePatch("BOSS_RED");
	local bar_heart = v.cachePatch("BOSS_ICO");

	local x_offset = 0;
	local y_offset = 0;

	local fill_patch = bar_fill;

	if (sugoi.bossHUD.shake > 0)
		local angle = leveltime * BOSS_METER_SHAKE_SPIN;
		local t = (min(sugoi.bossHUD.shake, BOSS_METER_SHAKE_TIME) * FRACUNIT) / BOSS_METER_SHAKE_TIME;
		local dist = ease.outcubic(t, 0, BOSS_METER_SHAKE_DIST);

		x_offset = FixedMul(dist, cos(angle)) / 2;
		y_offset = FixedMul(dist, sin(angle));

		if ((leveltime / 2) & 1)
			fill_patch = bar_fill_flash;
		end

		sugoi.bossHUD.shake = $1 - 1;
	end

	v.draw(
		BOSS_METER_X + x_offset, BOSS_METER_Y + y_offset,
		bar_empty,
		V_SNAPTORIGHT|V_SNAPTOBOTTOM
	);

	if (sugoi.bossHUD.disp_red > sugoi.bossHUD.disp_hp)
	and (sugoi.bossHUD.disp_red > 0)
		v.drawCropped(
			(BOSS_METER_X + BOSS_METER_FILL_OFFSET + x_offset) * FRACUNIT, (BOSS_METER_Y + y_offset) * FRACUNIT,
			FRACUNIT, FRACUNIT,
			bar_fill_red,
			V_SNAPTORIGHT|V_SNAPTOBOTTOM, nil,
			BOSS_METER_FILL_OFFSET * FRACUNIT, 0,
			BOSS_METER_FILL_WIDTH * sugoi.bossHUD.disp_red, 16 * FRACUNIT
		);
	end

	if (sugoi.bossHUD.disp_hp_delta > sugoi.bossHUD.disp_hp)
	and (sugoi.bossHUD.disp_hp_delta > 0)
		v.drawCropped(
			(BOSS_METER_X + BOSS_METER_FILL_OFFSET + x_offset) * FRACUNIT, (BOSS_METER_Y + y_offset) * FRACUNIT,
			FRACUNIT, FRACUNIT,
			bar_fill,
			V_SNAPTORIGHT|V_SNAPTOBOTTOM|V_50TRANS, nil,
			BOSS_METER_FILL_OFFSET * FRACUNIT, 0,
			BOSS_METER_FILL_WIDTH * sugoi.bossHUD.disp_hp_delta, 16 * FRACUNIT
		);
	end

	if (sugoi.bossHUD.disp_hp > 0)
		v.drawCropped(
			(BOSS_METER_X + BOSS_METER_FILL_OFFSET + x_offset) * FRACUNIT, (BOSS_METER_Y + y_offset) * FRACUNIT,
			FRACUNIT, FRACUNIT,
			fill_patch,
			V_SNAPTORIGHT|V_SNAPTOBOTTOM, nil,
			BOSS_METER_FILL_OFFSET * FRACUNIT, 0,
			BOSS_METER_FILL_WIDTH * sugoi.bossHUD.disp_hp, 16 * FRACUNIT
		);
	end

	v.draw(
		BOSS_METER_X + x_offset, BOSS_METER_Y + y_offset,
		bar_heart,
		V_SNAPTORIGHT|V_SNAPTOBOTTOM
	);

	if (sugoi.displayboss.nametag != nil)
		local string_type = "right";
		if (v.stringWidth(sugoi.displayboss.nametag, V_ALLOWLOWERCASE, "normal") > BOSS_METER_NAME_MAX)
			string_type = "thin-right";
			y_offset = $1 + 1;
		end

		v.drawString(
			BOSS_METER_NAME_X + x_offset, BOSS_METER_NAME_Y + y_offset,
			sugoi.displayboss.nametag,
			V_ALLOWLOWERCASE|V_SNAPTORIGHT|V_SNAPTOBOTTOM,
			string_type
		);
	end
end

customhud.SetupItem("bossmeter", "sugoi", drawBossMeter, "game", 0);
