function sugoi.SetupDefaultPVars(player)
	if ((splitscreen) and (player.ssnumbeaten == nil))
		player.ssnumbeaten = 0;
	end

	if (player.tokens == nil)
		player.tokens = 0;
	end

	if (player.ui == nil)
		player.ui = {
			mode = 0,
			cursor = 1,
			cooldown = 0,
			string = ""
		};
	end
end

function sugoi.CorrectLives(player)
	if not (multiplayer)
		-- Always grant infinite continues.
		-- They don't make sense with the overall design, with the hub and all.
		player.continues = 1;
	end

	local startLives = 3 -- (Would be nice to be able to read numgameovers...)

	if (multiplayer or netgame)
		startLives = CV_FindVar("startinglives").value;
	else
		-- sugoi_nolives lets you have infinite lives in SP
		if (sugoi.SpecialCVarValue("nolives"))
			--sugoi.DEShortcut("lives", false)
			player.lives = INFLIVES;
		elseif (player.lives == INFLIVES)
			--sugoi.DEShortcut("lives", true)
			player.lives = startLives;
		end
	end

	if (sugoi.hubSpot and sugoi.hubSpot.valid)
	and (player.lives != INFLIVES)
	and (player.lives < startLives)
		player.lives = startLives;
	end
end

local function playerSpawn(player)
	if not (G_PlatformGametype()) return; end
	sugoi.SetupDefaultPVars(player);
	sugoi.CorrectLives(player);
end

local function playerThink(mo)
	if not (G_PlatformGametype()) return end
	if not (mo.player and mo.player.valid) return end
	local player = mo.player;

	sugoi.SetupDefaultPVars(player);
	sugoi.CorrectLives(player);

	if (sugoi.fullyLoaded == true) -- avoid defrost time
	and (sugoi.exitingcheck == false) -- not during exit
		player.restoreShield = player.powers[pw_shield];
	end

	-- Undo the all super code
	if (skins[mo.skin].flags & SF_SUPER)
		player.sugoiAllSuper = nil;
	elseif (player.sugoiAllSuper == true) and not (player.powers[pw_super])
		player.charflags = $1 & ~SF_SUPER;
		player.sugoiAllSuper = nil;
	end

	if ((player.exiting) or (player.pflags & PF_FINISHED))
	and not (stagefailed)
		if (mapheaderinfo[gamemap].levelflags & LF_WARNINGTITLE)
			sugoi.GiveCredit(nil); -- give to everyone
		else
			sugoi.GiveCredit(player); -- give to winner
		end

		--G_SetCustomExitVars(sugoi.NextLevel(gamemap))
	end

	if (mapheaderinfo[gamemap].maxvmove)
		local maxvmove = tonumber(mapheaderinfo[gamemap].maxvmove) * mo.scale;

		if (abs(mo.momz) > maxvmove)
			mo.momz = maxvmove * sign(mo.momz);
		end
	end
end

local function allSuperDamage(mo, inf, src, damage, dmgType)
	if not (mo.player and mo.player.valid)
		return
	end

	if (dmgType & DMG_DEATHMASK)
		return
	end

	if (mo.player.powers[pw_super])
	and (mo.player.sugoiAllSuper == true)
		if (inf and inf.valid)
		and (inf.flags & MF_MISSILE)
			-- Damage causes MF2_SUPERFIRE-style stun
			P_DoPlayerPain(mo.player. src, inf);
			mo.state = S_PLAY_STUN;
			return true;
		end
	end
end

addHook("PlayerSpawn", playerSpawn)
addHook("MobjThinker", playerThink, MT_PLAYER)
addHook("MobjDamage", allSuperDamage, MT_PLAYER)
