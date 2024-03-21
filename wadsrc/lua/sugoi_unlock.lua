sugoi.UnlockTags = {
	// SUGOI
	[ 1] = 401, // Area 1
	[ 2] = 402, // Area 2
	[ 3] = 403, // Area 3
	[ 4] = 404, // Final Cavern
	[ 5] = 405, // Area X
	[ 6] = 406, // Garanz Site 16
	// SUBARASHII
	[ 7] = 4001, // Living Room
	[ 8] = 4002, // Dining Room
	[ 9] = 4003, // Library
	[10] = 4004, // Ballroom
	[11] = 4005, // Final Tower
	[12] = 4006, // Bedroom
	[13] = 4007, // Gallery
	// KIMOKAWAIII
	// Side A
	[14] = 4101, // Left
	[15] = 4102, // Right
	[16] = 4103, // Back
	[17] = 4104, // Summit
	[18] = 4105, // Hidden Base
	// Side B
	[19] = 4201, // Left
	[20] = 4201, // Back
	[21] = 4202, // Final
	[22] = 4203, // Extra Reel
	// Post-game
	[23] = 4301, // Game beaten
	[24] = 4302, // All emeralds
}

sugoi.Unlocked = {};

function sugoi.Unlock(id)
	if (sugoi.UnlockTags[id])
		sugoi.Unlocked[id] = true;
	end
end

function sugoi.DoUnlockTags(id)
	for id,tag in pairs(sugoi.UnlockTags) do
		if (tag and sugoi.Unlocked[id])
			P_LinedefExecute(tag);
		end
	end
end

addHook("LinedefExecute", function(line, mo, sec)
	local id = abs(line.frontside.textureoffset / FRACUNIT);
	sugoi.Unlock(id);
end, "UNLOCK");

addHook("MapChange", function()
	if (gamecomplete)
		sugoi.Unlock(23);
	end

	/*
	if (gamecomplete and All7Emeralds(emeralds))
		sugoi.Unlock(24);
	end
	*/
end);
