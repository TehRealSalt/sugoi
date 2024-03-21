freeslot("MT_SILVER_318")

addHook("MobjThinker", function(mo)
	for player in players.iterate do
		COM_BufInsertText(player, "cechoflags "..V_REDMAP|V_RETURN8)
		COM_BufInsertText(player, "cechoduration 6")
		if player.mo and player.mo.valid and player.mo.skin == "silver"
		and mo.health
			COM_BufInsertText(server, "csay \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\TIME PARADOX-CEPTION\\")
			P_KillMobj(mo)
			P_BlackOw(player)
			//P_KillMobj(player.mo) // Sorry for commenting these out, but these make it really easy to break the level change in SP if you press a button
			//player.lives = 0
		end
	end
end, MT_SILVER_318)
