//Dialogue Stuff for Dark Stabot and Desolate Woods Act 1:

local string = ""
local red = "\x85"
local white = "\x80"
local green = "\x83"
local dy = 150
local tdy = 165
local YY = 160*FRACUNIT
local dnameflags = V_SNAPTORIGHT|V_YELLOWMAP|V_ALLOWLOWERCASE
local dflags = V_SNAPTORIGHT|V_ALLOWLOWERCASE
local boxflags = V_10TRANS
local delaytimer = 0
local dling = 0

addHook("NetVars", function(network)
	string = network(string)
	dy = network(dw)
	tdy = network(tdw)
	YY = network(YY)
	dnameflags = network(dnameflags)
	dflags = network(dflags)
	boxflags = network(boxflags)
	delaytimer = network(delaytimer)
	dling = network(dling)
end)

local function F_DoDelay(delay)
	if dling == 0
		delaytimer = delay
		dling = delay
	end
end

freeslot("S_XYZEYE_PHANTOMSHIELD1")
freeslot("S_XYZEYE_PHANTOMSHIELD2")
freeslot("S_XYZEYE_PHANTOMSHIELD3")
freeslot("S_XYZEYE_PHANTOMSHIELD4")
freeslot("S_XYZEYE_PHANTOMSHIELD5")
freeslot("S_XYZEYE_PHANTOMSHIELD6")
freeslot("S_XYZEYE_PHANTOMSHIELD7")
freeslot("S_XYZEYE_PHANTOMSHIELD8")
freeslot("S_XYZEYE_PHANTOMSHIELD9")
freeslot("S_XYZEYE_PHANTOMSHIELD10")
freeslot("S_XYZEYE_PHANTOMSHIELD11")
freeslot("S_XYZEYE_PHANTOMSHIELD12")
freeslot("SPR_PHNS")

states[S_XYZEYE_PHANTOMSHIELD1] = {SPR_PHNS, A, 2, nil, 0, 0, S_XYZEYE_PHANTOMSHIELD2}
states[S_XYZEYE_PHANTOMSHIELD2] = {SPR_PHNS, B, 2, nil, 0, 0, S_XYZEYE_PHANTOMSHIELD3}
states[S_XYZEYE_PHANTOMSHIELD3] = {SPR_PHNS, C, 2, nil, 0, 0, S_XYZEYE_PHANTOMSHIELD4}
states[S_XYZEYE_PHANTOMSHIELD4] = {SPR_PHNS, D, 2, nil, 0, 0, S_XYZEYE_PHANTOMSHIELD5}
states[S_XYZEYE_PHANTOMSHIELD5] = {SPR_PHNS, E, 2, nil, 0, 0, S_XYZEYE_PHANTOMSHIELD6}
states[S_XYZEYE_PHANTOMSHIELD6] = {SPR_PHNS, F, 2, A_PlaySound, sfx_beelec, 1, S_XYZEYE_PHANTOMSHIELD7}
states[S_XYZEYE_PHANTOMSHIELD7] = {SPR_PHNS, G, 2, nil, 0, 0, S_XYZEYE_PHANTOMSHIELD8}
states[S_XYZEYE_PHANTOMSHIELD8] = {SPR_PHNS, H, 2, nil, 0, 0, S_XYZEYE_PHANTOMSHIELD9}
states[S_XYZEYE_PHANTOMSHIELD9] = {SPR_PHNS, I, 2, nil, 0, 0, S_XYZEYE_PHANTOMSHIELD10}
states[S_XYZEYE_PHANTOMSHIELD10] = {SPR_PHNS, J, 2, nil, 0, 0, S_XYZEYE_PHANTOMSHIELD11}
states[S_XYZEYE_PHANTOMSHIELD11] = {SPR_PHNS, K, 2, nil, 0, 0, S_XYZEYE_PHANTOMSHIELD12}
states[S_XYZEYE_PHANTOMSHIELD12] = {SPR_PHNS, L, 2, nil, 0, 0, S_XYZEYE_PHANTOMSHIELD1}

freeslot(
	"S_SNOWMANN",
	"sfx_eggman","sfx_dbot","sfx_boss",
	"MT_SONIC", "MT_TAILSS","S_TAILSS",
	"S_SONIC1",
	"MT_DIALOGOPTION","S_DIALOGOPTION1","S_DIALOGOPTION2","S_DIALOGOPTION3",
	"S_DIALOGOPTIONHELP1","S_DIALOGOPTIONHELP2","S_DIALOGOPTIONHELP3",
	"SPR_TEXP","SPR_HEXP",
	"sfx_ring","S_WWZBUSH")

mobjinfo[MT_DIALOGOPTION] = {
	//$Sprite TEXPA0
	//$Name Desolate Woods Dialog
	//$Category SUGOI Items & Hazards
    doomednum = -1,
	spawnstate = S_DIALOGOPTION1,
	height = 7*FRACUNIT,
	radius = 10*FRACUNIT,
	flags = MF_FLOAT|MF_NOGRAVITY
}

states[S_DIALOGOPTION1] = {SPR_TEXP, A, 5, nil, 0, 0, S_DIALOGOPTION2}
states[S_DIALOGOPTION2] = {SPR_TEXP, B, 5, nil, 0, 0, S_DIALOGOPTION3}
states[S_DIALOGOPTION3] = {SPR_TEXP, C, 5, nil, 0, 0, S_DIALOGOPTION1}

states[S_DIALOGOPTIONHELP1] = {SPR_HEXP, A, 5, nil, 0, 0, S_DIALOGOPTIONHELP2}
states[S_DIALOGOPTIONHELP2] = {SPR_HEXP, B, 5, nil, 0, 0, S_DIALOGOPTIONHELP3}
states[S_DIALOGOPTIONHELP3] = {SPR_HEXP, C, 5, nil, 0, 0, S_DIALOGOPTIONHELP1}

rawset(_G, "P_Activate18", function()

	if delaytimer > 0
		delaytimer = $1 - 1
	end

	if dling > 0
		dling = $1 - 1
	end

	for player in players.iterate

		if player.dialoglevel == false
			dy = 150
			tdy = 165
			YY = 160*FRACUNIT
			dnameflags = V_SNAPTORIGHT|V_YELLOWMAP|V_ALLOWLOWERCASE
			dflags = V_SNAPTORIGHT|V_ALLOWLOWERCASE
			boxflags = V_10TRANS
		elseif player.dialoglevel == true
			dy = 150
			tdy = 165
			YY = 160*FRACUNIT
			dnameflags = V_SNAPTORIGHT|V_YELLOWMAP|V_ALLOWLOWERCASE|V_40TRANS
			dflags = V_SNAPTORIGHT|V_ALLOWLOWERCASE|V_40TRANS
			boxflags = V_30TRANS
		end

        if player.timer == nil
			player.timer = 0
		end

		if player.continuecutscene3 == nil
			player.continuecutscene3 = false
		end

		if player.fadeblack == nil
			player.fadeblack = false
		end

		if player.showblack == nil
			player.showblack = false
		end

		if player.fadeblacktimer == nil
			player.fadeblacktimer = 0
		end

		if player.fadeblack == true
			player.fadeblacktimer = $1 + 1
		else
			player.fadeblacktimer = 0
		end

		if player.fadered == nil
			player.fadered = false
		end

		if player.faderedtimer == nil
			player.faderedtimer = 0
		end

		if player.fadered == true
			player.faderedtimer = $1 + 1
		else
			player.faderedtimer = 0
		end

		if player.fadeblacktimer >= 59
			player.fadeblack = false
		end

		if player.continuecutscenetimer3 == nil
			player.continuecutscenetimer3 = 0
		end

		if player.continuecutscene3 == true
			player.continuecutscenetimer3 = $1 + 1
		else
			player.continuecutscenetimer3 = 0
		end

        if player.dialog == nil
			player.dialog = false
		end

		if player.choice == nil
			player.choice = false
		end

		if player.thechoice == nil
			player.thechoice = 0
		end
	end

	if server and server.valid

		if server.choice == true
		and server.thechoice == 0
		and server.cmd.sidemove > 0
			server.thechoice = 1
			S_StartSound(nil,sfx_menu1)
		end

		if server.choice == true
		and server.thechoice == 1
		and server.cmd.sidemove < 0
			server.thechoice = 0
			S_StartSound(nil,sfx_menu1)
		end

		if server.choice == true
		and server.thechoice == 0
		and server.cmd.buttons & BT_JUMP
			server.thechoice = 0
			server.choice = false
			S_StartSound(nil,sfx_menu1)
			server.timer = 0
			string = ""
			server.dialogtimer = $1 + 1
			server.dialogabsolutetimer = 0
		end

		if server.choice == true
		and server.thechoice == 1
		and server.cmd.buttons & BT_JUMP
			server.thechoice = 1
			server.choice = false
			S_StartSound(nil,sfx_menu1)
			server.timer = 0
			string = ""
			server.dialogtimer = $1 + 1
			server.dialogabsolutetimer = 0
		end
	end

	for player in players.iterate

		if player.dialoglevel == nil
			player.dialoglevel = false
		end

		if player.skip == nil
			player.skip = false
		end

		if player.skiptimer == nil
			player.skiptimer = 0
		end

		if player.skip == true
		 	player.skiptimer = $1 + 1
		else
			player.skiptimer = 0
		end

		if player.skiptimer >= 11
			player.skiptimer = 0
		end

		if player.maxdialog == nil
			player.maxdialog = 0
		end

		if player.dialogdelaytrigger == nil
			player.dialogdelaytrigger = false
		end

		if player.dialogskip == nil
			player.dialogskip = false
		end

		if player.dialogblock == nil
			player.dialogblock = false
		end

		if player.dialogdelay == nil
			player.dialogdelay = 0
		end

		if player.dialogdelay > 0
			player.dialogdelay = $1 - 1
		end

		if player.dialogskipdelay == nil
			player.dialogskipdelay = 0
		end

		if player.dialogskipdelay > 0
			player.dialogskipdelay = $1 - 1
		end

		if player.dialogtimer == nil
			player.dialogtimer = 0
		end

		if player.dialogabsolutetimer == nil
			player.dialogabsolutetimer = 0
		end

		if player.dialog == true
			player.dialogabsolutetimer = $1 + 1
		else
			player.dialogabsolutetimer = 0
		end

		if player.dialogoption == nil
			player.dialogoption = 0
		end

		if player.pushbutton == nil
			player.pushbutton = 0
		end

		if player.cmd.buttons & BT_ATTACK
			player.pushbutton = $1 + 1
		else
			player.pushbutton = 0
		end

		if player.dialog == true
		and player.dialogskip == true
		and player.timer == string.len(string)
		and player.dialogabsolutetimer > 10
			player.skip = true
		end

		if player.dialogabsolutetimer < 10
			player.skip = false
		end

		if player.dialog == false
			player.skip = false
		end

		if player.timer ~= string.len(string)
			player.skip = false
		end

		if player.dialog == true
		and player.dialoglevel == false
			player.powers[pw_nocontrol] = 1
		end

		if server.dialog == true
			if server.timer == string.len(string)
			and server.dialogoption == 26 //important
			and server.dialogabsolutetimer > 10
			and server.dialogtimer == 4
				server.choice = true
			end
		end

		if player.pushbutton == 1
			if player.dialog == true
				if player.timer == string.len(string)
				and player.dialogabsolutetimer > 10
				and player.maxdialog ~= player.dialogtimer
				and player.dialogskip == true
					player.timer = 0
					string = ""
					player.dialogtimer = $1 + 1
					player.dialogabsolutetimer = 0
				end
			end
		end

		if player.dialogskipdelay == 0
			if player.dialog == true
			and player.dialogskip == false
			and player.maxdialog == player.dialogtimer
				player.dialog = false
				player.dialogtimer = 0
				player.timer = 0
				string = ""
				player.maxdialog = 0
				player.dialogdelay = 25

				if player.mo.tracer and player.mo.tracer.previousangle
					player.mo.tracer.angle = player.mo.tracer.previousangle
					player.mo.tracer.tracer = nil
					player.mo.tracer = nil
				end
			end
		end

		if player.dialogskipdelay == 0
			if player.dialog == true
			and player.dialogskip == false
			and player.maxdialog ~= player.dialogtimer
				player.timer = 0
				string = ""
				player.dialogtimer = $1 + 1
				player.dialogabsolutetimer = 0
			end
		end

		if player.pushbutton == 1
			if player.dialog == true
				if player.timer == string.len(string)
				and player.dialogabsolutetimer > 10
				and player.maxdialog == player.dialogtimer
				and player.dialogskip == true

					if player.dialogoption == 5
						player.continuecutscene3 = true
					end

					--[[
					if player.dialogoption == 7
						G_ExitLevel(62,true)
					end
					]]

				player.dialog = false
				player.dialogtimer = 0
				player.timer = 0
				string = ""
				player.maxdialog = 0
				player.dialogdelay = 25

					if player.mo.tracer and player.mo.tracer.previousangle ~= nil
						player.mo.tracer.angle = player.mo.tracer.previousangle
						player.mo.tracer.tracer = nil
						player.mo.tracer = nil
					end
				end
			end
		end

		if player.pushbutton == 1
		and player.dialog == true
		and player.timer < string.len(string)
		and player.dialogskip == true
			player.timer = string.len(string)
		end

		if player.dialog == true
		and player.timer < string.len(string)
		and delaytimer == 0
			player.timer = $1 + 1
        end

		if player.timer < string.len(string)
		and player.dialog == true
		and delaytimer == 0
		and not (player.dialogoption == 5 and player.dialogtimer == 1)
		and not (player.dialogoption == 7)
		and not (player.dialogoption == 9)
		and not (player.dialogoption == 10)
		and not (player.dialogoption == 11)
		and not (player.dialogoption == 12)
		and not (player.dialogoption == 14)
		and not (player.dialogoption == 16)
		and not (player.dialogoption == 17)
		and not (player.dialogoption == 19)
		and not (player.dialogoption == 20)
		and not (player.dialogoption == 21)
		and not (player.dialogoption == 22)
		and not (player.dialogoption == 24)
		and not (player.dialogoption == 25)
		and not (player.dialogoption == 26)
		and not (player.dialogoption == 8 and player.dialogtimer == 1)
		and not (player.dialogoption == 29)
		and not (player.dialogoption == 30)
		and player.timer % 2 == 0 then
			S_StartSound(nil, sfx_radio)
		end

		if player.timer < string.len(string)
		and delaytimer == 0
		and dling == 0
		and not ((player.dialogoption == 11) and (player.dialogtimer == 4) and (player.timer >= 9))
		and player.dialog == true
		and player.dialogoption == 11
		and player.timer % 2 == 0 then
			S_StartSound(nil, sfx_boss)
		end

		if player.timer < string.len(string)
		and delaytimer == 0
		and dling == 0
		and player.dialog == true
		and player.dialogoption == 10
		and player.timer % 2 == 0 then
			S_StartSound(nil, sfx_boss)
		end

		if ((player.dialogoption == 1) //making the player be able to cancel in-level dialogs when he needs to.
		or (player.dialogoption == 2)
		or (player.dialogoption == 3)
		or (player.dialogoption == 4)
		or (player.dialogoption == 6)
		or (player.dialogoption == 15)
		or (player.dialogoption == 18)
		or (player.dialogoption == 23)
		or (player.dialogoption == 28)
		or (player.dialogoption == 31))
		and (player.dialog == true) //The player is currently in a middle of a dialog.
		and (player.cmd.buttons & BT_USE) //let's make the cancel button as the "spin" button.

			player.dialogoption = 0 //Shut down the dialog.
			player.dialog = false
			player.dialogtimer = 0
			player.timer = 0
			string = ""
			player.maxdialog = 0
			player.dialogdelay = 25

			player.dialogdelaytrigger = false
			player.dialogskip = false
			player.dialogskipdelay = 0
			player.dialoglevel = false
			player.dialogblock = false

		    if player.mo.tracer.previousangle
				player.mo.tracer.angle = player.mo.tracer.previousangle //bring the NPC's previous angle direction back.
			end

		    if player.mo.tracer
				player.mo.tracer.tracer = nil //The NPC's tracer is gone (player) so, I guess he doesn't need one right now.
				player.mo.tracer = nil //The player's tracer is gone (NPC) so, I guess he doesn't need one right now.
		    end

		end

		if player.dialogoption == 4 //Bush message
			player.maxdialog = 3
			player.dialogskip = true
			player.dialoglevel = false
		elseif player.dialogoption == 11 //Dark Stabot Dialog
			player.maxdialog = 5
			player.dialogskip = false
			player.dialoglevel = false
		elseif player.dialogoption == 10 //After defeating stabbot, he says:
			player.maxdialog = 1
			player.dialogskip = false
			player.dialoglevel = false
		end


//The non-skippable system messages:

		if player.dialog == false
			player.dialogskipdelay = 50
		end

		if (player.dialog == true
		and player.dialoglevel == true)
		and not (player.dialoglivesdisable)
			sugoi.DEShortcut("lives", false)
			player.dialoglivesdisable = true -- Sal: DO NOT use hud enables/disables every tic
		elseif (player.dialog == false
		and not player.cutscenemode == true
		and not player.cutscenemode2 == true
		and not player.cutscenemode3 == true
		and not player.cutscenemode7 == true
		and not player.cutscenemode8 == true
		and not player.cutscenemode9 == true
		and not player.cutscenemode10 == true
		and not player.cutscenemode11 == true
		and not player.cutscenemode12 == true
		and not player.cutscenemode13 == true
		and not player.cutscenemode14 == true
		and not player.cutscenemode15 == true
		and not player.cutscenemode16 == true
		and not player.cutscenemode17 == true
		and not player.cutscenemode18 == true
		and not player.minicutscene == true)
		and (player.dialoglivesdisable)
			sugoi.DEShortcut("lives", true)
			player.dialoglivesdisable = false
		end

		if player.dialogskip == false
		and player.dialogoption == 11
		and player.dialogtimer == 2
		and player.timer == 0
			player.dialogskipdelay = 80
		end

		if player.dialogskip == false
		and player.dialogoption == 11
		and player.dialogtimer == 3
		and player.timer == 0
			player.dialogskipdelay = 190
		end

		if player.dialogskip == false
		and player.dialogoption == 11
		and player.dialogtimer == 4
		and player.timer == 0
			player.dialogskipdelay = 80
		end

		if player.dialogskip == false
		and player.dialogoption == 11
		and player.dialogtimer == 5
		and player.timer == 0
			player.dialogskipdelay = 80
		end

		if player.dialogskip == false
		and player.dialogoption == 11
		and player.dialogtimer == 4
		and player.timer == 9
			F_DoDelay(15)
		end

		if player.dialogskip == false
		and player.dialogoption == 11
		and player.dialogtimer == 4
		and player.timer == 10
			F_DoDelay(15)
		end

		if player.dialogskip == false
		and player.dialogoption == 11
		and player.dialogtimer == 4
		and player.timer == 11
			F_DoDelay(15)
		end



//pointless thing for showhud fix:


		if player.dialogtimer ~= nil
			if player.dialogblock ~= nil
				if player.dialogtimer ~= 0
					if player.dialogblock == false
						if player.dialogoption == 11
							if player.dialogtimer == 1
								string = "You..."
							elseif player.dialogtimer == 2
								string = "I'm gonna stop you..."
							elseif player.dialogtimer == 3
								string = "And make my master pleased!"
							elseif player.dialogtimer == 4
								string = "It's time..."
							elseif player.dialogtimer == 5
								string = red.."EN GARDE!"
							end
						end

						if player.dialogoption == 10
							if player.dialogtimer == 1
								string = "Impossible! Ugh!\nHow could I possibly lose?"
							end
						end

						if player.dialogoption == 4
							if player.dialogtimer == 1
								string = "Here's a tip-"
							elseif player.dialogtimer == 2
								string = "Red floating balls with "..green.."green"..white.." stripes\nare called: \"Hook Points\""
							elseif player.dialogtimer == 3
								string = "Press the ring toss button next to them to\nswing using your hookring."
							end
						end

					end
				end
			end
		end
	end	//for the players in players iterate close
end)

addHook("MapLoad", do
	for player in players.iterate
		player.timer = 0
		player.dialogtimer = 0
		player.dialogdelay = 0
		player.dialogdelaytrigger = false
		player.dialogoption = 0
		player.dialog = false
		player.continuecutscene3 = false
		player.continuecutscenetimer3 = 0
		player.dialogskip = false
		player.dialogskipdelay = 0
		player.dialoglevel = false
		player.fadeblack = false
		player.showblack = false
		player.fadeblacktimer = 0
		player.fadered = false
		player.faderedtimer = 0
		player.dialogblock = false
		player.choice = false
		player.thechoice = 0
		string = ""
	end
end)

addHook("MapChange", do
	for player in players.iterate
		player.timer = 0
		player.dialogtimer = 0
		player.dialogdelay = 0
		player.dialogdelaytrigger = false
		player.dialogoption = 0
		player.dialog = false
		player.continuecutscene3 = false
		player.continuecutscenetimer3 = 0
		player.dialogskip = false
		player.dialogskipdelay = 0
		player.dialoglevel = false
		player.fadeblack = false
		player.showblack = false
		player.fadeblacktimer = 0
		player.fadered = false
		player.faderedtimer = 0
		player.dialogblock = false
		player.choice = false
		player.thechoice = 0
		string = ""
	end
end)

addHook("PlayerSpawn", function(player)
	player.continuecutscene3 = false
	player.continuecutscenetimer3 = 0
	player.fadeblack = false
	player.fadeblacktimer = 0

	if player.dialog == true
	and player.dialoglevel == false
		string = ""
	end

	if player.dialog == true
	and player.dialoglevel == false
		player.timer = 0
		player.dialogtimer = 0
		player.dialogoption = 0
		player.dialogdelay = 0
		player.dialogdelaytrigger = false
		player.dialog = false
		player.dialogblock = false
		player.dialogskip = false
		player.dialogskipdelay = 0
		player.dialoglevel = false
	end
end)

addHook("MobjDeath", function(pmo)
	if not (mapheaderinfo[gamemap].dwz or mapheaderinfo[gamemap].darkstabot) return end

	pmo.player.continuecutscene3 = false
	pmo.player.continuecutscenetimer3 = 0
	pmo.player.fadeblack = false
	pmo.player.fadeblacktimer = 0

	if pmo.tracer and pmo.tracer.valid
	and pmo.tracer.previousangle ~= nil
		pmo.tracer.angle = pmo.tracer.previousangle
		pmo.tracer.tracer = nil
		pmo.tracer = nil
	end

	if pmo.player.dialog == true
	and pmo.player.dialoglevel == false
		string = ""
	end

	if pmo.player.dialog == true
	and pmo.player.dialoglevel == false
		pmo.player.timer = 0
		pmo.player.dialogtimer = 0
		pmo.player.dialogoption = 0
		pmo.player.dialogdelay = 0
		pmo.player.dialogdelaytrigger = false
		pmo.player.dialogskip = false
		pmo.player.dialogskipdelay = 0
		pmo.player.dialoglevel = false
		pmo.player.dialog = false
		pmo.player.dialogblock = false
	end
end, MT_PLAYER)

addHook("MobjRemoved", function(pmo)
	if not (mapheaderinfo[gamemap].dwz or mapheaderinfo[gamemap].darkstabot) return end

	pmo.player.continuecutscene3 = false
	pmo.player.continuecutscenetimer3 = 0

	if pmo.tracer and player.tracer.valid
	and pmo.tracer.previousangle ~= nil
		pmo.tracer.angle = player.tracer.previousangle
		pmo.tracer.tracer = nil
		pmo.tracer = nil
	end

	if pmo.player.dialog == true
	and pmo.player.dialoglevel == false
		string = ""
	end

	if pmo.player.dialog == true
	and pmo.player.dialoglevel == false
		pmo.player.timer = 0
		pmo.player.dialogtimer = 0
		pmo.player.dialogoption = 0
		pmo.player.dialogdelay = 0
		pmo.player.dialogdelaytrigger = false
		pmo.player.dialogskip = false
		pmo.player.dialogskipdelay = 0
		pmo.player.dialoglevel = false
		pmo.player.dialog = false
		pmo.player.dialogblock = false
	end
end, MT_PLAYER)

addHook("MobjDamage", function(pmo)
	if not (mapheaderinfo[gamemap].dwz or mapheaderinfo[gamemap].darkstabot) return end

	pmo.player.continuecutscene3 = false
	pmo.player.continuecutscenetimer3 = 0

	if pmo.tracer and pmo.tracer.valid
	and pmo.tracer.previousangle ~= nil
		pmo.tracer.angle = pmo.tracer.previousangle
		pmo.tracer.tracer = nil
		pmo.tracer = nil
	end

	if pmo.player.dialog == true
	and pmo.player.dialoglevel == false
		string = ""
	end

	if pmo.player.dialog == true
	and pmo.player.dialoglevel == false
		pmo.player.timer = 0
		pmo.player.dialogtimer = 0
		pmo.player.dialogoption = 0
		pmo.player.dialogdelay = 0
		pmo.player.dialogdelaytrigger = false
		pmo.player.dialogskip = false
		pmo.player.dialogskipdelay = 0
		pmo.player.dialoglevel = false
		pmo.player.dialog = false
		pmo.player.dialogblock = false
	end
end, MT_PLAYER)

addHook("MobjThinker", function(npc)
	if not npc return end

	if leveltime == 0
		npc.skin = "tails"
		npc.color = SKINCOLOR_ORANGE
	end
	if leveltime == 1
		npc.skin = "tails"
		npc.color = SKINCOLOR_ORANGE
	end
	if npc.previousangle == nil
		npc.previousangle = npc.angle
	end
	if npc.dialogchance == nil
		npc.dialogchance = false
	end
	if npc.found == nil
		npc.found = 0
	end

	if npc.dialogchance == true
		npc.found = $1 + 1
	else
		npc.found = 0
	end

	if npc.found == 1
		npc.sign = P_SpawnMobj(npc.x,npc.y,npc.z+npc.height+10*FRACUNIT,MT_DIALOGOPTION)
		npc.sign.state = S_DIALOGOPTIONHELP1
	end

	if npc.found == 0
	and npc.sign and npc.sign.valid
		P_RemoveMobj(npc.sign)
	end

	for player in players.iterate
		if not player.mo and player.mo.valid
			continue
		end

		if R_PointToDist2(player.mo.x, player.mo.y, npc.x, npc.y)<= 100*FRACUNIT
		and abs(player.mo.z - npc.z)<= 70*FRACUNIT
		and player.pushbutton == 1
		and player.dialog == false
		and player.dialogtimer == 0
		and npc.tracer == nil
		and player.dialogdelay == 0
			player.dialog = true
			player.dialogtimer = 1
			player.dialogoption = npc.spawnpoint.angle
			npc.tracer = player.mo
			player.mo.tracer = npc
			A_FaceTracer(npc)
		end
	end

	if npc.tracer == nil
		npc.dialogchance = true
	else
		npc.dialogchance = false
	end

	if npc.spawnpoint.angle == 4
		if not (npc.barrieroverlay)
			S_StartSound(npc, sfx_s3k40)
			npc.barrieroverlay = P_SpawnMobj(npc.x, npc.y, npc.z, MT_OVERLAY)
			npc.barrieroverlay.state = S_XYZEYE_PHANTOMSHIELD1
		end

		if npc.barrieroverlay.valid
			npc.barrieroverlay.target = npc
			P_MoveOrigin(npc.barrieroverlay, npc.x, npc.y, npc.z)
		end

		P_SetMobjStateNF(npc,S_WWZBUSH)
		npc.flags = MF_RUNSPAWNFUNC
	end
end, MT_TAILSS)


--
-- Sal: holy SHIT there's a lot of redundant code here,
-- and complete nonsense player iterators.
-- This was actually the source of a ton of frame lag,
-- (Julie's toaster compy went from 8 to full 35 just by pressing F3)
-- so uhhh yeah I had to split this up into functions and prevent all the copy-paste.
-- Still not very optimal but whatever.
--

local function HUDHookA(v, stfu, black)
	if server.showblack ~= nil
		if server.showblack == true
			v.draw(0*FRACUNIT, 0*FRACUNIT, black)
		end
	end
end

local function HUDHookB(v, stfu, black, timer)
	if (timer)
		-- This used to be a massive horrible elseif block.
		if (timer < 0 or timer >= 57)
			-- beyond expected bounds
			return;
		end

		local trans = abs(9 - ((timer-1) >> 1));
		if (trans >= NUMTRANSMAPS)
			return;
		end

		if (trans != 0)
			trans = $1 << V_ALPHASHIFT;
		end

		v.draw(0*FRACUNIT, 0*FRACUNIT, black, trans);
	end
end

local function HUDHookC(v, stfu, player)
	if player
		if player.dialogtimer ~= nil
			if player.dialogblock ~= nil
				if player.dialogtimer ~= 0
					if player.dialogblock == false

						local XX = 0
						local BLUE = v.cachePatch("TEXTBOX")
						v.drawScaled(XX, YY, FRACUNIT/2, BLUE, boxflags)

						if player.dialogoption == 4
							if player.dialogtimer == 1
								v.drawString(5, dy, "???:", dnameflags)
								v.drawString(5, tdy, string.sub(string, 1, player.timer), dflags)
							elseif player.dialogtimer == 2
								v.drawString(5, dy, "???:", dnameflags)
								v.drawString(5, tdy, string.sub(string, 1, player.timer), dflags)
							elseif player.dialogtimer == 3
								v.drawString(5, dy, "???:", dnameflags)
								v.drawString(5, tdy, string.sub(string, 1, player.timer), dflags)
							end
						end

						if player.dialogoption == 11
							if player.dialogtimer == 1
								v.drawString(5, dy, "Dark Stabot:", dnameflags)
								v.drawString(5, tdy, string.sub(string, 1, player.timer), dflags)
							elseif player.dialogtimer == 2
								v.drawString(5, dy, "Dark Stabot:", dnameflags)
								v.drawString(5, tdy, string.sub(string, 1, player.timer), dflags)
							elseif player.dialogtimer == 3
								v.drawString(5, dy, "Dark Stabot:", dnameflags)
								v.drawString(5, tdy, string.sub(string, 1, player.timer), dflags)
							elseif player.dialogtimer == 4
								v.drawString(5, dy, "Dark Stabot:", dnameflags)
								v.drawString(5, tdy, string.sub(string, 1, player.timer), dflags)
							elseif player.dialogtimer == 5
								v.drawString(5, dy, "Dark Stabot:", dnameflags)
								v.drawString(5, tdy, string.sub(string, 1, player.timer), dflags)
							end
						end

						if player.dialogoption == 10
							if player.dialogtimer == 1
								v.drawString(5, dy, "Dark Stabot:", dnameflags)
								v.drawString(5, tdy, string.sub(string, 1, player.timer), dflags)
							end
						end
					end
				end
			end
		end

		if player.choice ~= nil
			if player.thechoice ~= nil
				if player.choice == true
				and player.thechoice == 0
					v.drawString(30, 185, "YES", V_SNAPTORIGHT|V_ALLOWLOWERCASE|V_YELLOWMAP)
					v.drawString(60, 185, "NO", V_SNAPTORIGHT|V_ALLOWLOWERCASE)
				end

				if player.choice == true
				and player.thechoice == 1
					v.drawString(30, 185, "YES", V_SNAPTORIGHT|V_ALLOWLOWERCASE)
					v.drawString(60, 185, "NO", V_SNAPTORIGHT|V_ALLOWLOWERCASE|V_YELLOWMAP)
				end
			end
		end

		if player.skiptimer ~= nil
			if player.skiptimer >= 1
			and player.skiptimer <= 2
				v.draw(300, 150, v.cachePatch("DLGSKP1"), 0)
			end

			if player.skiptimer >= 3
			and player.skiptimer <= 4
				v.draw(300, 150, v.cachePatch("DLGSKP2"), 0)
			end

			if player.skiptimer >= 5
			and player.skiptimer <= 6
				v.draw(300, 150, v.cachePatch("DLGSKP3"), 0)
			end

			if player.skiptimer >= 7
			and player.skiptimer <= 8
				v.draw(300, 150, v.cachePatch("DLGSKP4"), 0)
			end

			if player.skiptimer >= 9
			and player.skiptimer <= 10
				v.draw(300, 150, v.cachePatch("DLGSKP5"), 0)
			end
		end
	end
end

local function MainHUDHook(v, stfu)
	-- DO NOT RUN UNLESS IF IT'S THE LEVEL...
	if not (mapheaderinfo[gamemap].dwz or mapheaderinfo[gamemap].darkstabot) return end

	local black = v.cachePatch("AFILL");
	HUDHookA(v, stfu, black);
	HUDHookB(v, stfu, black, server.fadeblacktimer);

	black = v.cachePatch("RFILL"); -- (This makes no sense.)
	HUDHookB(v, stfu, black, server.faderedtimer);

	local player = stfu;
	if not (player and player.valid)
		player = displayplayer;
	end
	HUDHookC(v, stfu, player);
end

hud.add(function(v,stfu)
	MainHUDHook(v, stfu);
end,"game")

hud.add(function(v,stfu)
	MainHUDHook(v, stfu);
end,"scores")
