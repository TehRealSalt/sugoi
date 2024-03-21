-- drown the player even faster in cold water!
glacierglaze.Drowning = function(p)
	if not (mapheaderinfo[gamemap].glacierglaze) then return end
	
	local mo = p.mo
	if not (mo and mo.valid) then return end
	if not (mo.health) then return end
	
	-- underwater stuff
	if not (mo.eflags & MFE_UNDERWATER) then return end
	if (glacierglaze.InBubble(p)) then return end	-- nah
	if (glacierglaze.IsPlayerFrozen(p)) then return end	-- nah x2
	
	local drowningtics = TICRATE*11 + 1	-- when we actually start drowning
	local countdown = p.powers[pw_underwater]	-- our breath underwater
	
	if (countdown > drowningtics)
		-- make sure the warning sound effect is playing properly
		local warningtics = 25*TICRATE + 1
		while (warningtics > countdown)
			-- plays every 5 tics
			warningtics = $ - (5*TICRATE)
		end
		
		-- decrease timer!
		local removetics = glacierglaze.UnderwaterRemoveTics
		p.powers[pw_underwater] = max(max(drowningtics, warningtics), $ - removetics)
		//print("warningtics: "..warningtics)
		//print("p.powers[pw_underwater]: "..p.powers[pw_underwater])
	end
end