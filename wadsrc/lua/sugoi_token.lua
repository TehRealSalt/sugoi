sugoi.temptokens = 0;

function sugoi.UpdateTokens()
	if (sugoi.temptokens <= 0)
		return;
	end

	for player in players.iterate
		player.tokens = $1 + sugoi.temptokens;

		if (player.tokens > 99)
			player.tokens = 99;
		end
	end

	sugoi.temptokens = 0;
end

function sugoi.AddToken(num, player)
	sugoi.temptokens = $1 + num;

	if (player and player.valid) and not (player.bot)
		S_StartSound(nil, sfx_token, player);
	end
end

addHook("TouchSpecial", function(mo, pmo)
	if not (pmo.player and pmo.player.valid)
		return false;
	end

	sugoi.AddToken(1, pmo.player);
	P_KillMobj(mo);

	return true;
end, MT_TOKEN);

addHook("TouchSpecial", function(mo, pmo)
	if not (pmo.player and pmo.player.valid)
		return;
	end

	if (pmo.player.bot)
		return;
	end

	if (circuitmap)
		return;
	end

	if (mo.health > 90)
		return;
	end

	if (pmo.player.starpostnum >= mo.health)
		return;
	end

	sugoi.UpdateTokens();
end, MT_STARPOST);
