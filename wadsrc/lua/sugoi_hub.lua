sugoi.hubMaps = {
	sugoi = 100,
	subarashii = 136,
	kawaiii = 208,
	kimoiii = 244,
};

sugoi.hubSpot = nil;
sugoi.lastHub = nil;

freeslot(
	"MT_HUBSPOT"
);

mobjinfo[MT_HUBSPOT] = {
	--$Name Hub Thinker Spot
	--$Sprite MAPPD0
	--$Category SUGOI Hub
	doomednum = 3500,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1000,
	radius = 16*FRACUNIT,
	height = 48*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY
}

function sugoi.IsHubLevel()
	if (sugoi.hubSpot)
		return true;
	end

	return false;
end

function sugoi.HubLevelThinker(mo)
	if not (G_PlatformGametype())
		return;
	end

	if not (sugoi.hubSpot)
		sugoi.hubSpot = mo;
	end

	if not (sugoi.currentVoteInfo.voting)
		return;
	end

	if (sugoi.currentVoteInfo.timer > 0 and sugoi.cv_vote.value > 0)
	or (sugoi.cv_vote.value == 0)
		for player in players.iterate do
			player.pflags = $1|PF_FULLSTASIS;

			local buffertime = 2;
			if (sugoi.cv_vote.value > 0)
				buffertime = (sugoi.cv_vote.value * TICRATE) - 10;
			end

			if (sugoi.currentVoteInfo.timer >= buffertime and player.cmd.buttons)
				player.disablevote = true;
			elseif (player.disablevote) and not (player.cmd.buttons)
				player.disablevote = false;
			end

			--if (sugoi.playerVotes[#player] == nil) and not (player.disablevote)
			if not (player.disablevote)
			and not (player.bot or player.spectator)
				if (player.cmd.buttons & BT_JUMP)
				and not (player.cmd.buttons & BT_USE)
					sugoi.playerVotes[#player] = true;
				elseif (player.cmd.buttons & BT_USE)
				and not (player.cmd.buttons & BT_JUMP)
					sugoi.playerVotes[#player] = false;
				end
			end
		end
	end

	if (sugoi.currentVoteInfo.timer <= 0) or (sugoi.GetVoteCount() >= sugoi.GetPlayerCount(false, false))
		sugoi.FinishVote(true);
	elseif (sugoi.cv_vote.value > 0 and sugoi.currentVoteInfo.timer > 0)
	or (sugoi.cv_vote.value == 0 and sugoi.currentVoteInfo.timer > 1)
		sugoi.currentVoteInfo.timer = $1 - 1;
	end
end

addHook("MobjThinker", sugoi.HubLevelThinker, MT_HUBSPOT)
