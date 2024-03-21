//Dark Stabot Intro-Cutscene

function A_SpawnThunder(stabber,var1)
	local effect = P_SpawnMobj(stabber.x+FixedMul(70*FRACUNIT, sin(stabber.angle)),stabber.y+FixedMul(1*FRACUNIT, sin(stabber.angle)),stabber.z+125*FRACUNIT,MT_EFFECT)
	effect.state = S_LIT1
	effect.scale = 2*FRACUNIT
	P_StartQuake(10*FRACUNIT, 20)
end

freeslot(
	"S_DARKSTABOT_DETERMINED05",
	"S_DARKSTABOT_DETERMINED1",
	"S_DARKSTABOT_DETERMINED2",
	"S_DARKSTABOT_DETERMINED3",
	"S_DARKSTABOT_DETERMINED4"
)

freeslot(
	"S_DARKSTABOT1_INTRO",
	"S_DARKSTABOT12_INTRO",
	"S_DARKSTABOT2_INTRO"
)

states[S_DARKSTABOT_DETERMINED05] = {SPR_DCBF, L, 2, nil, 0, 0, S_DARKSTABOT_DETERMINED1}
states[S_DARKSTABOT_DETERMINED1] = {SPR_DCBF, L, 30, nil, 0, 0, S_DARKSTABOT_DETERMINED2}
states[S_DARKSTABOT_DETERMINED2] = {SPR_DCBF, M, 80, A_SpawnThunder, 0, 0, S_DARK_STABOT_INTRO1}

states[S_DARKSTABOT1_INTRO] = {SPR_DCBF, M, 1, nil, 0, 0, S_DARKSTABOT12_INTRO}
states[S_DARKSTABOT12_INTRO] = {SPR_DCBF, M, 15, A_PlaySound, sfx_swrd1, 0, S_DARKSTABOT2_INTRO}
states[S_DARKSTABOT2_INTRO] = {SPR_DCBF, L, 15, A_PlaySound, sfx_swrd2, 0, S_DARK_STABOT_INTRO2}

local cutscene7 = true
local cutscenemode7 = false
local cutscenetimer7 = 0
local playerCam = nil

addHook("NetVars", function(network)
	cutscene7 = network(cutscene7)
	cutscenetimer7 = network(cutscenetimer7)
	cutscenemode7 = network(cutscenemode7)
	playerCam = network(playerCam)
end)

rawset(_G, "P_Activate10", function()
	if cutscenemode7 == true
	and cutscene7 == true
	and ((leveltime < 40) or (leveltime > 150))
		cutscenetimer7 = $1 + 1
	elseif ((cutscenemode7 == false) or (cutscene7 == false))
		cutscenetimer7 = 0
	end

	for player in players.iterate
		if player.cutscenemode7 == nil
		and (mapheaderinfo[gamemap].dscutscene) //if the boss arena is dark stabot's
			player.cutscenemode7 = true
		end

		if player.cutscenemode7 == nil
		and not (mapheaderinfo[gamemap].dscutscene)
			player.cutscenemode7 = false
		end

        if player.cutscenemode7 == nil
			player.cutscenemode7 = false
		end

		if player.cutscenemode7 == true
			player.powers[pw_nocontrol] = 1
		end
	end
end)

addHook("MobjThinker", function(stabber)
	if not stabber return end

	if (stabber.state == S_DARKSTABOT12_INTRO)
	and (stabber.tics == 14)
		local effect = P_SpawnMobj(stabber.x+FixedMul(50*FRACUNIT, sin(stabber.angle)),stabber.y,stabber.z+125*FRACUNIT,MT_EFFECT)
		effect.color = SKINCOLOR_BLACK
	end

	if (stabber.state == S_DARKSTABOT2_INTRO)
	and (stabber.tics == 14)
		local effect = P_SpawnMobj(stabber.x+FixedMul(50*FRACUNIT, sin(stabber.angle)),stabber.y+FixedMul(-80*FRACUNIT, cos(stabber.angle)),stabber.z+20*FRACUNIT,MT_EFFECT)
		effect.color = SKINCOLOR_BLACK
	end


    if stabber.state == S_DARKSTABOT_DETERMINED05
		local effect = P_SpawnMobj(stabber.x-30*FRACUNIT,stabber.y,stabber.z+10*FRACUNIT,MT_EFFECT)
        effect.color = SKINCOLOR_YELLOW
        S_StartSound(nil,sfx_swrd2)
	end

	for player in players.iterate

		if cutscenetimer7 >= 1
			player.awayviewmobj = playerCam
			player.awayviewtics = -1
		end

        if player.cutscenemode7 == true
        and cutscenetimer7 == 1
			playerCam.tracer = stabber
			player.awayviewmobj = playerCam
			player.awayviewtics = -1
			players[0].dialog = true
			players[0].dialogtimer = 1
			players[0].dialogoption = 11
			players[0].dialogskipdelay = 150
		end

		if (leveltime == 40)
			player.dialogblock = true
			P_SetOrigin(playerCam,stabber.x+120*FRACUNIT,stabber.y-100*FRACUNIT,stabber.z+50*FRACUNIT)
			playerCam.angle = FixedAngle(135*FRACUNIT)
			player.awayviewmobj = playerCam
			player.awayviewtics = -1
		end

		if (leveltime == 70)
			A_FaceTracer(playerCam)
			P_SetOrigin(playerCam,stabber.x+120*FRACUNIT,stabber.y+100*FRACUNIT,stabber.z+50*FRACUNIT)
			player.awayviewmobj = playerCam
			player.awayviewtics = -1
		end

		if (leveltime >= 70)
		and (leveltime < 95)
			A_FaceTracer(playerCam)
			player.awayviewmobj = playerCam
			player.awayviewtics = -1
			player.awayviewaiming = R_PointToAngle2(0, stabber.z, R_PointToDist2(stabber.x, stabber.y, playerCam.x, playerCam.y), playerCam.z)*(-1)
		end

		if (leveltime == 95)
			P_SetOrigin(playerCam,stabber.x+400*FRACUNIT,stabber.y-900*FRACUNIT,stabber.z-350*FRACUNIT)
			A_FaceTracer(playerCam)
			player.awayviewmobj = playerCam
			player.awayviewtics = -1
		end

		if (leveltime >= 95)
		and (leveltime < 140)
			A_FaceTracer(playerCam)
			player.awayviewmobj = playerCam
			player.awayviewtics = -1
			player.awayviewaiming = R_PointToAngle2(0, stabber.z, R_PointToDist2(stabber.x, stabber.y, playerCam.x, playerCam.y), playerCam.z)*(-1)
		end
	end

    if (leveltime == 50)
		P_SetMobjStateNF(stabber,S_DARKSTABOT1_INTRO)
	end

	if (leveltime == 60)
		stabber.momz = 9*FRACUNIT
		P_InstaThrust(stabber,stabber.angle,9*FRACUNIT)
		P_SetMobjStateNF(stabber,S_DARK_STABOT_INTRO2)
		S_StartSound(stabber,sfx_cannon)
	end

	if (leveltime >= 60)
	and not (P_IsObjectOnGround(stabber))
		P_SpawnGhostMobj(stabber)
	end

	if (leveltime == 125)
		P_SetMobjStateNF(stabber,S_DARK_STABOT_INTRO1)
		P_StartQuake(3*FRACUNIT+(FRACUNIT/2), 15)
        S_StartSound(nil,sfx_pstop)

		for i=1,14
			local dust = P_SpawnMobj(stabber.x,stabber.y,stabber.z,MT_EXPLODE)
			dust.angle = FixedAngle(360/15*i*FRACUNIT)
			P_InstaThrust(dust,dust.angle,6*FRACUNIT)
		end

	end

	for player in players.iterate

		if cutscenetimer7 == 50
			playerCam.momx = 0
			P_SetOrigin(playerCam,stabber.x,stabber.y-200*FRACUNIT,stabber.z+50*FRACUNIT)
			playerCam.angle = FixedAngle(90*FRACUNIT)
			player.awayviewmobj = playerCam
			player.awayviewtics = -1
			player.dialogblock = false
			player.awayviewaiming = 0
		end

		if cutscenetimer7 == 130
			playerCam.angle = FixedAngle(135*FRACUNIT)
			P_SetOrigin(playerCam,stabber.x+30*FRACUNIT,stabber.y-50*FRACUNIT,stabber.z+50*FRACUNIT)
			player.awayviewmobj = playerCam
			player.awayviewtics = -1
		end
	end

	if cutscenetimer7 == 180
		playerCam.angle = FixedAngle(90*FRACUNIT)
		P_SetOrigin(playerCam,stabber.x,stabber.y-200*FRACUNIT,stabber.z+50*FRACUNIT)
		P_Thrust(playerCam,playerCam.angle,5336)
	end

	if cutscenetimer7 == 200
		P_SetMobjStateNF(stabber,S_DARKSTABOT_DETERMINED05)
	end

	if cutscenetimer7 == 231
		P_Thrust(playerCam,playerCam.angle,-130069)
		S_StartSound(stabber,sfx_litng1)
	end

	for player in players.iterate

		if cutscenetimer7 == 231
			player.dialogblock = true
		end

		if cutscenetimer7 >= 1
		and cutscenetimer7 < 270
			P_SetMobjStateNF(player.mo,S_PLAY_STND)
		end

		if cutscenetimer7 >= 1
			player.mo.angle = FixedAngle(90*FRACUNIT)
		end
	end

	if cutscenetimer7 == 236
		A_SpawnThunder(stabber)
	end

	if cutscenetimer7 == 252
		P_SetOrigin(playerCam,5232*FRACUNIT,2452*FRACUNIT,48*FRACUNIT)
		playerCam.angle = FixedAngle(225*FRACUNIT)
		playerCam.momx = 0
		playerCam.momy = 0
	end

	for player in players.iterate
		if cutscenetimer7 >= 270
		and cutscenetimer7 < 290
			P_SetMobjStateNF(player.mo,S_PLAY_TAP1)
		end
	end

	if cutscenetimer7 == 290
		local effect = P_SpawnMobj(stabber.x+FixedMul(300*FRACUNIT, cos(stabber.angle)),stabber.y+FixedMul(300*FRACUNIT, sin(stabber.angle)),stabber.z,MT_EFFECT)
        effect.state = S_LIT1
        effect.scale = 2*FRACUNIT
        S_StartSound(nil,sfx_litng4)
		P_StartQuake(10*FRACUNIT, 15)
		sectors[19].floorpic = "VFZFLR01"
	end

	if (cutscenetimer7 >= 292)
	and (leveltime % 5 == 0)
		local effect = P_SpawnMobj(stabber.x+FixedMul(280*FRACUNIT, cos(stabber.angle)),stabber.y+FixedMul(280*FRACUNIT, sin(stabber.angle)),stabber.z,MT_SMOKE)
		effect.momz = 4*FRACUNIT
	end

	for player in players.iterate

		if cutscenetimer7 == 291
			P_SetMobjStateNF(player.mo,S_PLAY_PAIN)
			player.mo.momz = 3*FRACUNIT
			P_InstaThrust(player.mo,FixedAngle(270*FRACUNIT),10*FRACUNIT)
		end

		if cutscenetimer7 == 320
			player.dialogblock = false
			P_SetOrigin(playerCam,players[0].mo.x+150*FRACUNIT,players[0].mo.y-100*FRACUNIT,20*FRACUNIT)
			playerCam.angle = FixedAngle(135*FRACUNIT)
			playerCam.momx = (-1)*5336
		end
	end

	if cutscenetimer7 == 380
		P_SetOrigin(playerCam,stabber.x+100*FRACUNIT,stabber.y+150*FRACUNIT,stabber.z+50*FRACUNIT)
		playerCam.angle = FixedAngle(230*FRACUNIT)
	end

	if cutscenetimer7 == 390
		P_SetMobjStateNF(stabber,S_DARKSTABOT1_INTRO)
	end

	if cutscenetimer7 == 445
		G_ExitLevel(true)
	end
end, MT_DARK_STABOT_INTRO)

addHook("MapLoad", do
	for player in players.iterate
		if (mapheaderinfo[gamemap].dscutscene) //if the boss arena is dark stabot's
			cutscene7 = true
			cutscenemode7 = true
			cutscenetimer7 = 0
			player.cutscenemode7 = true
			playerCam = P_SpawnMobj(5132*FRACUNIT,2352*FRACUNIT,48*FRACUNIT,MT_CAMERA)
			playerCam.angle = FixedAngle(225*FRACUNIT)
			player.awayviewmobj = playerCam
			player.awayviewtics = -1
			sugoi.HUDShow("time", false)
			sugoi.HUDShow("lives", false)
			sugoi.HUDShow("score", false)
			sugoi.HUDShow("rings", false)
		else
			cutscenemode7 = false
			cutscenetimer7 = 0
			cutscene7 = true
			player.cutscenemode7 = false
		end
	end
end)
