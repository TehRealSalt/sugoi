rawset(_G, "sugoi", {});

function sugoi.GameName()
	return "sugoiComplete",4;
end

if not (rawget(_G, "sign"))
	rawset(_G, "sign", function(num)
		if (num < 0)
			return -1;
		elseif (num > 0)
			return 1;
		else
			return 0;
		end
	end);
end

sugoi.fullyLoaded = false;

freeslot(
	"sfx_ubara1",
	"sfx_ubara2",
	"sfx_ubara3"
)

function sugoi.subarashii(player)
	P_DoPlayerPain(player);
	S_StartSound(nil, sfx_ubara1 + P_RandomKey(3), player);
end

function sugoi.SpecialCVarValue(cvName)
	if (cvName == "nolives")
		if (gamestate == GS_LEVEL and not G_GametypeUsesLives())
		or (modeattacking)
			return 0;
		end

		return sugoi.cv_nolives.value;
	end
end

function sugoi.ResetLives()
	if (sugoi.SpecialCVarValue("nolives"))
		return;
	end

	if not (G_GametypeUsesLives())
		return;
	end

	if (modeattacking)
		return;
	end

	for player in players.iterate
		if (player.bot)
			continue;
		end

		player.lives = 1; -- no cheaty
	end
end

sugoi.cv_nolives = CV_RegisterVar({
	name = "sugoi_nolives",
	defaultvalue = "Off",
	flags = CV_CALL|CV_NETVAR|CV_NOINIT|CV_SHOWMODIF, -- CV_CHEAT?
	PossibleValue = CV_OnOff,
	func = sugoi.ResetLives
});

function sugoi.FindPlayerFromName(n)
	if (type(n) != "string")
		return nil;
	end

	for player in players.iterate do
		if (player.name == n)
			return player;
		end
	end
end

function sugoi.GetPlayerCount(bots, spect)
	local playercount = 0;

	for player in players.iterate
		if ((player.bot) and not (bots))
			continue;
		end

		if ((player.spectator or player.quittime) and not (spect))
			continue;
		end

		playercount = $1 + 1;
	end

	return playercount;
end

function sugoi.NextEmeraldNum(emVal)
	if (emVal == nil)
		emVal = emeralds;
	end

	for i = 0,6
		local emFlag = 1 << i;

		if (emVal & emFlag)
			continue;
		end

		return i+1;
	end

	return 0;
end

local cv_altmusic = CV_RegisterVar({
	name = "sugoi_altmusic",
	--flags = CV_HIDDEN,
	defaultvalue = "Off",
	PossibleValue = CV_OnOff
})

addHook("MusicChange", function(oldname, newname, mflags, looping, position, prefadems, fadeinms)
	if (cv_altmusic.value)
	and (gamestate != GS_TITLESCREEN) // Sound Test
		if (newname == "GARANZ")
			return "GARAN2";
		elseif (newname == "MRGADO")
			return "NOWLOD";
		elseif (newname == "ALCHM2")
			return "CRAZYM";
		elseif (newname == "GUNDAM")
			-- "Boo Takes Charge" by ThinkOneMoreTime
			return "BOOTC";
		elseif (newname == "JOREND")
			-- "Last Area (FM)" by ThinkOneMoreTime
			return "OLDLJE";
		end
	end
end)

-- This is used for some dumb hacks
sugoi.ExtraReelStart = 270;
