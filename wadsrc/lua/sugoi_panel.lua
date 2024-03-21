-- Checkpoint flip panels - this file is courtesy of toaster!

freeslot(
	"SPR_HPNL",
	"MT_HUBPANEL",
	"S_HUBPANEL0",
	"S_HUBPANEL1",
	"S_HUBPANEL2",
	"S_HUBPANEL3",
	"S_HUBPANEL4",
	"S_HUBPANEL5"
);

mobjinfo[MT_HUBPANEL] = {
	--$Name Hub Transport Panel
	--$Sprite HPNLC0
	--$Category SUGOI Hub
	doomednum = 3509,
	spawnstate = S_HUBPANEL0,
	spawnhealth = 1000,
	radius = 48*FRACUNIT,
	height = FRACUNIT,
	flags = MF_SOLID|MF_NOGRAVITY|MF_NOCLIPHEIGHT
}

states[S_HUBPANEL0] = {SPR_NULL, 0, -1, nil, 0, 0, S_NULL};

states[S_HUBPANEL1] = {SPR_HPNL, 0, 1, nil, 0, 0, S_HUBPANEL2};
states[S_HUBPANEL2] = {SPR_HPNL, 1, 1, nil, 0, 0, S_HUBPANEL3};
states[S_HUBPANEL3] = {SPR_HPNL, 2, 1, nil, 0, 0, S_HUBPANEL4};
states[S_HUBPANEL4] = {SPR_HPNL, 3, 1, nil, 0, 0, S_HUBPANEL5};
states[S_HUBPANEL5] = {SPR_HPNL, 4, 1, nil, 0, 0, S_HUBPANEL0};

local panelflats = {
	"HUBPANL1",
	"HUBPANL2",
};

sugoi.HubPanelMaps = { sugoi.hubMaps.sugoi, sugoi.hubMaps.subarashii, sugoi.hubMaps.kawaiii, sugoi.hubMaps.kimoiii };

sugoi.PANELANIM_ENTER = 1;
sugoi.PANELANIM_EXIT = 2;

sugoi.DoPanelStart = false;

// The unpopulated list of things to check for when flipping.
local panelthings = {};

addHook("MapChange", function(m)
	panelthings = {};
end)

local function FlipPanel(panel)
	panel.flipping = true;

	if (panel.state == S_HUBPANEL0) then
		panel.state = S_HUBPANEL1;
	end

	if not (panel.flips) then
		panel.flips = 3;
	end

	panel.panelfof.flags = $1 & ~(FF_RENDERALL|FF_CUTLEVEL);
end

addHook("MapThingSpawn", function(mo, mt)
	local num = #(mo.subsector.sector);

	if (panelthings[num] and panelthings[num].valid)
		P_RemoveMobj(mo);
		return;
	end

	panelthings[num] = mo;
end, MT_HUBPANEL);

addHook("MobjThinker", function(mo)
	if not (mo.panelfof and mo.panelfof.valid) then
		for rover in mo.subsector.sector.ffloors()
			for i = 1,#panelflats do
				if (rover.toppic == panelflats[i])
					mo.panelfof = rover;
				end
			end
		end

		return;
	end

	if (mo.spawnpoint and mo.spawnpoint.valid)
		mo.extravalue1 = mo.spawnpoint.extrainfo + 1;
	end

	if (mo.state == S_HUBPANEL0) then
		if (mo.flips) then
			mo.flips = max(0, $1 - 1);

			if (mo.flips) then
				mo.state = S_HUBPANEL1;
			elseif (mo.flipping == true) then
				mo.flipping = false;
				mo.panelfof.flags = $1|(FF_RENDERALL|FF_CUTLEVEL);
				--S_StartSound(mo, sfx_upclak);
			end
		end
	end
end, MT_HUBPANEL);

addHook("MobjCollide", function(panel, mo)
	if not (mo.player and mo.player.valid)
		return false; -- Not player
	end

	if (mo.panelanim)
		return false; -- Already animating
	end

	if (panel.z > mo.z + mo.height)
		return false; -- overhead
	end

	if (panel.z + panel.height < mo.z)
		return false; -- underneath
	end

	local dist = P_AproxDistance(panel.x - mo.x, panel.y - mo.y)
	if (dist > (panel.radius - mo.radius))
		return false; -- Not in circle
	end

	FlipPanel(panel);
	S_StartSound(panel, sfx_s3k82);

	P_ResetPlayer(mo.player);

	mo.panelanim = sugoi.PANELANIM_ENTER;
	mo.panelmobj = panel;

	sugoi.StartUI(mo.player, 2, nil);

	return false;
end, MT_HUBPANEL);

addHook("PlayerThink", function(player)
	if not (player.mo and player.mo.valid)
		return;
	end

	if not (player.mo.panelanim)
		return;
	end

	local destpoint = {
		x = 0,
		y = 0,
		z = 0,
		dist = 0
	};

	local noclipflags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY;

	player.mo.flags = $1|noclipflags;
	player.pflags = $1|PF_SPINNING|PF_THOKKED;
	player.mo.height = P_GetPlayerSpinHeight(player);
	player.mo.reactiontime = 2;

	if (player.panim != PA_ROLL)
		player.mo.state = S_PLAY_ROLL;
	end

	if not (player.mo.panelmobj and player.mo.panelmobj.valid)
		-- both aren't valid? we're done
		player.mo.panelanim = nil;
		player.mo.flags = $1 & ~noclipflags;
		print("No panel mobj...?");
		return;
	end

	if (player.mo.panelanim == sugoi.PANELANIM_ENTER)
		destpoint.x = player.mo.panelmobj.x;
		destpoint.y = player.mo.panelmobj.y;
		destpoint.z = player.mo.panelmobj.z - (128*FRACUNIT) + 1;

		P_MoveOrigin(
			player.mo,
			(player.mo.x + destpoint.x) / 2,
			(player.mo.y + destpoint.y) / 2,
			(player.mo.z + destpoint.z) / 2
		);

		--print("Moving under panel...");
	elseif (player.mo.panelanim == sugoi.PANELANIM_EXIT)
		destpoint.z = player.mo.panelmobj.z + player.mo.panelmobj.scale

		if (player.mo.z - player.mo.momz > destpoint.z)
			FlipPanel(player.mo.panelmobj);
			S_StartSound(panel, sfx_s3kb6);

			player.mo.panelmobj = nil;
			player.mo.panelanim = nil;

			player.mo.flags = $1 & ~noclipflags;
			--print("Finished panel animation!");
		else
			player.mo.momx = 0;
			player.mo.momy = 0;
			player.mo.momz = 16*FRACUNIT;
			--print("Moving out of panel...");
		end
	else
		player.mo.panelanim = nil;
		player.mo.flags = $1 & ~noclipflags;
		print("No panel animation state...?");
	end
end);
