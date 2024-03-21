freeslot("S_GWZ_SPIKE","SPR_GSPK")

states[S_GWZ_SPIKE] = {SPR_GSPK,FF_ANIMATE|FF_GLOBALANIM,-1,nil,3,2}

local function GWZSound(plr)
	if not plr.mo return end
	if not plr.mo.health return end
	if not mapheaderinfo[gamemap].gwzsound return end

	if (plr.mo.gwzsound == nil)
		plr.mo.gwzsound = 34
	end

	if P_PlayerTouchingSectorSpecial(plr, 3, 2)
		plr.mo.gwzsound = $ + 1
	else
		plr.mo.gwzsound = 34
	end

	if plr.mo.gwzsound == 35
		S_StartSound(plr.mo,sfx_s3k74,plr)
		plr.mo.gwzsound = 0
	end
end

local function GWZSpike(ball)
	if not mapheaderinfo[gamemap].gwzsound return end
	if mapheaderinfo[gamemap].gwzsound == "yes"
		ball.state = S_GWZ_SPIKE
	end
end

addHook("PlayerThink", GWZSound)
addHook("MobjSpawn", GWZSpike, MT_SPIKEBALL)