sugoi.SHOPLISTLEN = 5;

sugoi.shopitems = {};

sugoi.shopitemlist = {};
sugoi.keeper = nil;

sugoi.cv_testitem = CV_RegisterVar({
	name = "sugoi_debugitem",
	defaultvalue = "",
	flags = CV_CALL|CV_NOINIT|CV_NETVAR|CV_SHOWMODIF|CV_CHEAT,
	func = function(cv)
		if (cv.flags & CV_MODIFIED)
			G_SetUsedCheats();
		end
	end
})

freeslot(
	"MT_DISPLAYCASEITEM",

	"MT_DISPLAYEMERALD",
	"S_DISPLAYEMERALD",

	"MT_DISPLAYSUPER",
	"S_DISPLAYSUPER",
	"SPR_TVSU",

	"MT_SHOPKEEPER_SHADOW",
	"S_SHOPKEEPER_SHADOW",
	"SPR_SHPS",
	"SPR_SHPE",

	"MT_SHOPKEEPER_OWL",
	"S_SHOPKEEPER_OWL",
	"SPR_OWLK",

	"sfx_omo1",
	"sfx_omo2",
	"sfx_omo3",
	"sfx_omo4",
	"sfx_omo5",
	"sfx_omoxit",
	"sfx_omobuy",

	"sfx_manegg"
);

mobjinfo[MT_DISPLAYCASEITEM] = {
	--$Name Shop Display Item Spot
	--$Sprite TVMYA0
	--$Category SUGOI Hub
	--$AngleText Item ID
	doomednum = 3503,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1000,
	radius = 18*FRACUNIT,
	height = 40*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOSECTOR|MF_NOGRAVITY
}

mobjinfo[MT_DISPLAYEMERALD] = {
	spawnstate = S_DISPLAYEMERALD,
	spawnhealth = 1000,
	radius = 16*FRACUNIT,
	height = 32*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY
}
states[S_DISPLAYEMERALD] = {SPR_CEMG, A, -1, nil, 0, 0, S_DISPLAYEMERALD}

mobjinfo[MT_DISPLAYSUPER] = {
	spawnstate = S_DISPLAYSUPER,
	spawnhealth = 1000,
	radius = 18*FRACUNIT,
	height = 40*FRACUNIT,
	flags = MF_NOBLOCKMAP
}
states[S_DISPLAYSUPER] = {SPR_TVSU, A, 2, nil, 0, 0, S_BOX_FLICKER}

mobjinfo[MT_SHOPKEEPER_SHADOW] = {
	--$Name Shadow Shopkeeper
	--$Sprite SHPSA2A8
	--$Category SUGOI NPCs
	doomednum = 3505,
	spawnstate = S_SHOPKEEPER_SHADOW,
	spawnhealth = 1000,
	radius = 16*FRACUNIT,
	height = 48*FRACUNIT,
	flags = MF_NOBLOCKMAP
}
states[S_SHOPKEEPER_SHADOW] = {SPR_SHPS, A, -1, nil, 0, 0, S_SHOPKEEPER_SHADOW}

mobjinfo[MT_SHOPKEEPER_OWL] = {
	--$Name Owl Shopkeeper
	--$Sprite OWLKA0
	--$Category SUGOI NPCs
	doomednum = 3510,
	spawnstate = S_SHOPKEEPER_OWL,
	spawnhealth = 1000,
	radius = 16*FRACUNIT,
	height = 48*FRACUNIT,
	flags = MF_NOBLOCKMAP
}
states[S_SHOPKEEPER_OWL] = {SPR_OWLK, A, -1, nil, 0, 0, S_SHOPKEEPER_OWL}

addHook("MobjThinker", function(mo)
	local yourdeviloryourangle = 1;
	if (mo.spawnpoint and mo.spawnpoint.valid)
		yourdeviloryourangle = mo.spawnpoint.angle;
	end

	local i = sugoi.shopitemlist[yourdeviloryourangle];

	if (i)
		local item = sugoi.shopitems[i];
		local z = 0;
		if (item.displayItemType == MT_DISPLAYEMERALD)
			z = 24*FRACUNIT;
		end

		local newmo = P_SpawnMobjFromMobj(mo, 0, 0, z, item.displayItemType);
		newmo.flags = $1 & ~(MF_SOLID|MF_MONITOR|MF_SHOOTABLE|MF_SPECIAL); -- Remove interactivity flags

		-- Only remove upon replacement, since it's not ready on map load
		P_RemoveMobj(mo);
	end
end, MT_DISPLAYCASEITEM);

addHook("MobjThinker", function(mo)
	mo.shadowscale = 2*FRACUNIT/3;

	if (sugoi.NextEmeraldNum() == 0)
		mo.frame = 7;
	else
		mo.frame = sugoi.NextEmeraldNum() - 1;
	end
end, MT_DISPLAYEMERALD);

addHook("MobjSpawn", function(mo)
	mo.shadowscale = FRACUNIT;

	if (P_RandomChance(FRACUNIT/96))
		mo.sprite = SPR_SHPE;
		mo.frame = A;
	else
		local numframes = 10;
		mo.sprite = SPR_SHPS;
		mo.frame = ($1 & ~FF_FRAMEMASK) | P_RandomKey(numframes);
	end
end, MT_SHOPKEEPER_SHADOW);

addHook("MobjSpawn", function(mo)
	mo.scale = (6 * $1) / 5;
	mo.shadowscale = FRACUNIT;
end, MT_SHOPKEEPER_OWL);

function sugoi.DefaultBuyFunc(player)
	player.shopitem = sugoi.shopitemlist[player.ui.cursor];
	S_StartSound(nil, sfx_chchng, player);
	return true;
end

function sugoi.AddShopItem(identifier, itemTable)
	if (type(identifier) != "string")
		error("sugoi.AddShopItem: identifier is not a string. Item was not added.");
		return false;
	end

	if (sugoi.shopitems[identifer] != nil)
		error("sugoi.AddShopItem: Item '"..identifier.."' already exists. Item was not added.");
		return false;
	end

	local newItem = {
		name = "",
		description = "",
		price = 1,
		displayItemType = MT_PITY_BOX,
		shopIcon = "TVPIC0",
		livesIcon = "TVPIICON",
		addFunc = nil,
		buyFunc = sugoi.DefaultBuyFunc,
		useFunc = nil,
		mysteryFunc = nil,
	};

	if (type(itemTable.name) == "string")
		newItem.name = itemTable.name;
	end

	if (type(itemTable.description) == "string")
		newItem.description = itemTable.description;
	end

	if (type(itemTable.price) == "number")
		if (itemTable.price >= 0)
			newItem.price = itemTable.price;
		else
			error("sugoi.AddShopItem: price is negative.");
		end
	end

	if (type(itemTable.displayItemType) == "number")
		if (itemTable.displayItemType > 0 and itemTable.displayItemType < #mobjinfo)
			newItem.displayItemType = itemTable.displayItemType;
		else
			error("sugoi.AddShopItem: displayItemType is out of range (1 - "..(#mobjinfo - 1)..").");
		end
	end

	if (type(itemTable.shopIcon) == "string")
		newItem.shopIcon = itemTable.shopIcon;
	end

	if (type(itemTable.livesIcon) == "string")
		newItem.livesIcon = itemTable.livesIcon;
	end

	if (type(itemTable.addFunc) == "function")
		newItem.addFunc = itemTable.addFunc;
	end

	if (type(itemTable.buyFunc) == "function")
		newItem.buyFunc = itemTable.buyFunc;
	end

	if (type(itemTable.useFunc) == "function")
		newItem.useFunc = itemTable.useFunc;
	end

	if (type(itemTable.mysteryFunc) == "function")
		newItem.mysteryFunc = itemTable.mysteryFunc;
	end

	sugoi.shopitems[identifier] = newItem;
	return true;
end

function sugoi.KeeperName(keeper)
	if (keeper and keeper.valid)
		if (keeper.type == MT_SHOPKEEPER_SHADOW)
			return "Shadow";

			--[[
			if (keeper.sprite == SPR_SHPE)
				return "3D Shadow?";
			end

			-- nametag switch; meh don't really like it that much
			local frame = (keeper.frame & FF_FRAMEMASK)
			if (frame == 0) return "1.09.4 Shadow";
			elseif (frame == 1) return "Riders Shadow";
			elseif (frame == 2) return "ShadowCE";
			elseif (frame == 3) return "EMW5 Shadow";
			elseif (frame == 4) return "2.1 Shadow";
			elseif (frame == 5) return "Shadow?";
			elseif (frame == 6) return "JShadow";
			elseif (frame == 7) return "SPMoves Shadow";
			elseif (frame == 8) return "2.2 Shadow";
			end
			--]]
		elseif (keeper.type == MT_SHOPKEEPER_OWL)
			return "Old Man Owl";
		elseif (keeper.type == MT_MANEGG)
			return "Manegg";
		end
	end

	return "";
end

function sugoi.ShadowKeeperStrings(keeper, activator)
	local keeperstrings = { -- Default common strings
		"Hmph. What do you want?",
		"You again. Make this quick.",
		"Here we go again.",
		"Let's get this over with.",
		"Just hand over your Emerald Tokens already.",
		"Don't give me any small talk. I just want your Emerald Tokens.",
		"All sales are final.",
		"Want a refund? Hmph! Too bad.",
		"There's no time to play games with your money. Give it to me.",
		"So, are you going to just look or what?",
		"\"Just looking\", huh? Hmph.",
		"So, how's the Shadow Realm treating you?",
		"What? Follow you into the levels? Don't be ridiculous.",
		"Buy your things and leave already, please.",
		"If you open any of the merchandise, you have to buy it.",
		"No, we don't offer payment plans.",
		"I've considered doing a rental option, but for some reason nobody can be bothered to return my junk.",
		"Not too far from firing a Chaos Spear at your stupid face..."
	};
	local useRareStrings = P_RandomChance(FRACUNIT/10);

	if (keeper.sprite == SPR_SHPE) -- MD2 texture easter egg strings
		keeperstrings = {
			"...Why are you looking at me like that?",
			"What? Is there something wrong?",
			"Stop it with the looks."
		};
		--name = "MD2 Texture Shadow"
	elseif (activator.skin == "shadow") -- Entirely new strings for shadow!
		if (useRareStrings) -- Rare Shadow strings! Yes, turns out me and boin wrote enough strings for Shadow to warrent this
			keeperstrings = {
				"Howzabout youse and mese vamoose?",
				"I'm thinking about confessing to him... Don't let Shadow know.",
				"What's cooking, good-looking? Hehe.",
				"\"You have the most beautiful eyes\"... She used to say that to me too.",
				"Hi there, BFF! ...Er, wait, wrong Shadow.",
				"Hey, do you still have that Pokemon GO card I lent to you?",
				"Yo, Shadow. Up for a SUGOI Coop session later tonight?",
				"HEY what is happening MY BOY DOWN IN HERE in the SHA-DOW REALM, sup sup DAWGGO",
				"Sometimes I wonder if there's any Shadow Androids living with us... Am I... an android, too?",
				"I have a dream... that one day, all Shadows will be reunited with their Marias."
			}
		else
			keeperstrings = {
				"Welcome back, Shadow.",
				"Hey there, Shadow. Ready for the next book club meeting next weekend?",
				"Hello, Shadow. Fancy meeting you here... haha.",
				"What are you doing later? Fancy a go on the secret rollercoaster?",
				"Back so soon? I thought I told you to... wait, wrong agent.",
				"Hi there, BFF!",
				"Haha... did you see that foolish hedgehog running around here earlier?",
				"If you ask me, this stuff is worthless, but we have to get rid of it somehow.",
				"Greetings, Shadow! Need anything?",
				"Hey, Shadow. Thinking of taking the boys out for dinner later, you in?",
				"Thinking of working on my garden, after this is all done. Tough hobby when it's snowing 24/7.",
				"I'm thinking of going to Dop Town, want to come?",
				"Who drew that scribble in the sky, anyway?",
				"Sigh, I was really hoping to not be caught with shop duty today...",
				"CHAOS CONTROL! ...How was that? Shadow said I needed to work on it.",
				"I mean, I should be giving you the employee discount, but...",
				"Hey, when's it your turn to run the shop, anyways?",
				"Can you take over for me? I can't deal with Sonic and his friends anymore...",
				"It's a little weird to see so many of ourselves every day, but you get used to it eventually.",
				"Still snowing out there? Man, that sucks.",
				"I'm doing some sudoku puzzles to pass the time.",
				"Hey there, how are you doing?",
				"Let me know when the blue annoyance comes back so I can find someone to switch off with...",
				"Gee, it sure is boring around here when you're the only one manning the shop...",
				"Hm, my shoes have been acting funny. Looks about time for the weekly shoe jet maintenance.",
				"I've got a lot of magazines on the go back here. Want one?",
				"What even powers our shoe jets?",
				"I'm taking piano lessons with Shadow later today."
			}
		end
	elseif (activator.skin == "hms123311") -- Heh.
		keeperstrings = {
			"What? Why are we even looking for you if you're right here?",
			"You could save us so much time right now by just warping to the final boss level and OHKOing it. Please?",
			"The plot makes no sense at all now. Look what you've done.",
			"To be honest, I've never actually seen you in person before this 'adventure'.",
			"Those spines... are they real?",
			"How fast is your actionspd, anyway?",
			"I'm surprised you don't have a script to spawn fire trails when you're running.",
			"Do you even have to buy things? Why are you here?"
		}
	elseif (activator.skin == "robo-hood") -- HEH.
		keeperstrings = {
			"Oh, uh... Hi, I guess?",
			"Uh... don't bother. Most of these levels aren't beatable without spindash, anyways.",
			"I don't think you'll have a lot of fun in the Shadow Realm, sorry bud.",
			"Why are you even here, it's not like I'm opening the shop for you or anything...",
			"Er, uh, yikes... sorry about destroying your sister in Castle Eggman Zone.",
			"Uh... Hey there... guy. Gal? Thing? Something else?",
			"I've always wanted to know what kind of Flicky is powering you, but if that's too personal a question...",
			"Can anyone dissuade you from trying to beat things?",
			"TAS aside, I'd like to see you actually beat the final boss without taking damage.",
			"How come you can't be destroyed in one hit like the other ones? What's different?",
			"Normally I'd call this stuff useless, but... you're probably relying on these to beat some levels, aren't you?"
		}
	else
		if (useRareStrings) -- Rare strings
			keeperstrings = {
				"You better not be expecting me to make a stupid 'fourth Chaos Emerald' joke.",
				"I know you're trying to skip Minesweeper... hmph! Amateur.",
				"In the Shadow Realm, Xmas Mode is always turned on. Ugh, I wish it was Halloween for once...",
				"Hmph. Hmph? Hmmmmph. Hmph... Hmph!",
				"Do you like the art around this place? I commissioned it.",
				"You don't have to be afraid, you can make levels like these too! Er, I mean, ugh I hate everything.",
				"Ahh, my precious Maria... Maria Anna of Spain.",
				"We meant to replace that Eggman statue in the lobby with a statue of us, but we never got around to it."
			};

			if (activator.skin == "sonic")
				table.insert(keeperstrings, "Eggman banned you from anime? Boy, that's rough.");
				table.insert(keeperstrings, "How did you manage to get through Garanz Site 16 with your retinas intact?");
			elseif (activator.skin == "tails")
				table.insert(keeperstrings, "Hmm... Oh, sorry, I didn't see you there. You have no presence at all."); -- All Tails lines are rare
				table.insert(keeperstrings, "Heh, how does it feel to hardly be involved at all for once?");
				table.insert(keeperstrings, "Were you written out of the story intentionally?");
				table.insert(keeperstrings, "Looks like a character that doesn't even exist in canon wound up getting a bigger role than you.");
				if not (multiplayer) and not (players[1] and players[1].valid) -- no multiplayer, splitscreen, or bots
					table.insert(keeperstrings, "Huh? You're all alone for once? There has to be someone else here, but I can't even sense them.");
				end
			elseif (activator.skin == "knuckles")
				table.insert(keeperstrings, "Back again? I thought you brexited last time.");
				table.insert(keeperstrings, "Woah, are you *the* Joseph Joestar? ...Er, sorry, you don't have the hat or the beard.");
			elseif (activator.skin == "silver")
				if (netgame)
					table.insert(keeperstrings, "Thankfully, it looks like netgames are safe from paradox death.");
				else
					table.insert(keeperstrings, "Didn't we kill you last time? Or did you have some extra lives?");
				end
				table.insert(keeperstrings, "I don't understand why you're even here, your timeline ceased to exist.");
			end

			if not (skins["shadow"] and skins["shadow"].valid)
				table.insert(keeperstrings, "Huh, do you think it's weird that you only ever see one of us around here at a time?");
			end
		else
			if (activator.skin == "sonic") -- Common Sonic strings
				table.insert(keeperstrings, "Hmph. Still can't believe I signed up to work with you...");
				table.insert(keeperstrings, "So, what's the plan... wait, you still don't have one. Got it.");
				table.insert(keeperstrings, "Okay, you go off and do stuff while I wait here.");
				table.insert(keeperstrings, "HMS is just a legend, right? There's no way something that powerful could possibly exist...");
				table.insert(keeperstrings, "You mentioned HMS being somewhere after Flooded Sea Zone, but I don't think that level is completable.");
				table.insert(keeperstrings, "Ugh, Sonic. It's you again.");
			elseif (activator.skin == "knuckles")
				table.insert(keeperstrings, "Unlike Sonic... I think you're chuckling just fine, mister KTE.");
				table.insert(keeperstrings, "You know, being able to smash things with your face is a valuable skill. Does it work on grape soda cans?");
				table.insert(keeperstrings, "How's the Master Emerald holding up? Still intact?");
				table.insert(keeperstrings, "Let's be honest, which is better - the Shadow Realm or that hovel of a ruin you sit on all day?");
				table.insert(keeperstrings, "As the guardian of the Master Emerald, you probably have an infinite supply of Emerald Tokens to give me. I should raise my prices.");
				table.insert(keeperstrings, "Hey, I've got a sweet deal for you. If you beat Sonic up for me, I'll give you a discount.");
			elseif (activator.skin == "silver")
				table.insert(keeperstrings, "I guess this means the trifecta is all here in the Shadow Realm, huh. Where's Sonic?");
				table.insert(keeperstrings, "If you use telekinesis to shoplift, I swear...");
				table.insert(keeperstrings, "Where did you get those boots, anyway? I kind of want some cool hightops now.");
				table.insert(keeperstrings, "Is Blaze doing well? Do you ever see her?");
				table.insert(keeperstrings, "Hey, give me a psychokinetic massage later.");
			end
		end
	end

	return keeperstrings;
end

function sugoi.OwlKeeperStrings(keeper, activator)
	local keeperstrings = { -- Default common strings
		"Ahhh, there you are...",
		"Ahhh, I can help you out...",
		"Ahhh, anything catch your eye?",
		"Ahhh, hoot hoot, ahhh...",
		"Ahhh, what a time to relax, ahhh...",
		"Ahhh, why not take a load off... ahhh...",
		"Ahhh, floating islands are so relaxing... ahhh...",
		"Ahhh, why isn't this just great?",
		"Ahhh, it's you again, ahhh...",
		"Ahhh, gradients...",
	};

	if (activator.skin == "sonic") -- Common Sonic strings
		table.insert(keeperstrings, "Ahhh, like my drip, Sonic?");
		table.insert(keeperstrings, "Ahhh, why put up this much fuss over HMS? Just relax a little...");
	end

	if (sugoi.daycycle == 0) -- Day time strings
		table.insert(keeperstrings, "Ahhh, what a beautiful afternoon... ahhh...");
		table.insert(keeperstrings, "Ahhh, the sky is so clear and blue right now... ahhh...");
		table.insert(keeperstrings, "Ahhh, blueberries...");
	elseif (sugoi.daycycle == 1) -- Sunset
		table.insert(keeperstrings, "Ahhh, the sky is so pretty at sundown... ahhh...");
		table.insert(keeperstrings, "Ahhh, why don't you watch the sunset with me?");
		table.insert(keeperstrings, "Ahhh, oranges...");
		table.insert(keeperstrings, "Ahhh, where's the sun, anyways?");
	elseif (sugoi.daycycle == 2) -- Dusk
		table.insert(keeperstrings, "Ahhh, there goes the sun...");
		table.insert(keeperstrings, "Ahhh, the red shimmer and cooling breeze...");
		table.insert(keeperstrings, "Ahhh, apples...");
		table.insert(keeperstrings, "Ahhh, it's about to get dark, are you still working?");
	elseif (sugoi.daycycle == 3) -- Night
		table.insert(keeperstrings, "Ahhh, you should take a break with me, avoid catching a cold...");
		table.insert(keeperstrings, "Ahhh, the shining stars...");
		table.insert(keeperstrings, "Ahhh, plums...");
		table.insert(keeperstrings, "Ahhh, a shooting star... make a wish!");
		table.insert(keeperstrings, "Ahhh, it's so dark out now...");
	elseif (sugoi.daycycle == 4) -- Dawn
		table.insert(keeperstrings, "Ahhh, the sun is coming back up...");
		table.insert(keeperstrings, "Ahhh, the pastel mix of the sunrise...");
		table.insert(keeperstrings, "Ahhh, watermelons...");
		table.insert(keeperstrings, "Ahhh, the start of a new day...");
	elseif (sugoi.daycycle == 5) -- Cloudy
		table.insert(keeperstrings, "Ahhh, we've hit a cloud patch...");
		table.insert(keeperstrings, "Ahhh, maybe it's about to rain...");
		table.insert(keeperstrings, "Ahhh, bananas...");
		table.insert(keeperstrings, "Ahhh, it feels damp today...");
	end

	if (sugoi.Unlocked[17]) -- Comment on ghost status
		table.insert(keeperstrings, "Ahhh, all of the shadow ghosts are gone... now I can fully enjoy the sights, ahhh...");
	elseif (sugoi.Unlocked[14])
		table.insert(keeperstrings, "Ahhh, you got rid of a shadow ghost... thank you!");
		table.insert(keeperstrings, "Ahhh, the view is getting less dark... all thanks to you!");
	else
		table.insert(keeperstrings, "Ahhh, those rude shadow ghosts are blocking the beautiful view...");
	end

	if (sugoi.Unlocked[18]) -- Hidden Base hint
		table.insert(keeperstrings, "Ahhh, I heard there's something neat hidden in the mountains...");
		table.insert(keeperstrings, "Ahhh, hop around up to the waterfall... ahhh...");
	end

	return keeperstrings;
end

function sugoi.ManeggKeeperStrings(keeper, activator)
	local keeperstrings = { -- Default common strings
		"I am Manegg!", -- Literally every line he has from the sprite comic
		"I will rule this universe as I have many others!",
		"Eggman will be destroyed!",
		"Not a bad idea, doc!",
		"Roboticizer, GO!!!!",
		"Come, my mechas!!!",
		"Hahahahahaha!!!",
		"What just happened?!",
		"What is it?",
		"AAAAAAAHHH HHHHHHHH!!!!",
		"What is up, doc?", -- Bugs Bunny quotes For Some Reason
		"Don't take life too seriously. You'll never get out alive.",
		"Ain't I a Man Egg",
		"It's a living.",
		"Fund my illicit plans, please and thank you.", -- Original stuff
		"3 pages is a new record for any character existing in any comic ever! Correct?",
		"With your money... I will escape from this pit of hell using the Man Carrier.",
		"Boarding time for the ark ends in 30 minutes.",
	};

	if (sugoi.Unlocked[21]) -- Comment on ghost status
		table.insert(keeperstrings, "Where'd all of my buddies go?!");
	elseif (sugoi.Unlocked[20])
		table.insert(keeperstrings, "Hmm, seems less crowded than usual. Those guys must have a date with darkness.");
	else
		table.insert(keeperstrings, "Have you met my shadow-y friends? I love these little guys.");
	end

	return keeperstrings;
end

function sugoi.KeeperStrings(keeper, activator)
	if (keeper and keeper.valid)
		if (keeper.type == MT_SHOPKEEPER_SHADOW)
			return sugoi.ShadowKeeperStrings(keeper, activator);
		elseif (keeper.type == MT_SHOPKEEPER_OWL)
			return sugoi.OwlKeeperStrings(keeper, activator);
		elseif (keeper.type == MT_MANEGG)
			return sugoi.ManeggKeeperStrings(keeper, activator);
		end
	end

	return {""};
end

function sugoi.KeeperColor(keeper)
	if (keeper and keeper.valid)
		if (keeper.type == MT_SHOPKEEPER_SHADOW)
			return "\143";
		elseif (keeper.type == MT_SHOPKEEPER_OWL)
			return "\142";
		elseif (keeper.type == MT_MANEGG)
			return "\139";
		end
	end

	return "\128";
end

function sugoi.KeeperMusic(keeper)
	if (keeper and keeper.valid)
		if (keeper.type == MT_SHOPKEEPER_OWL)
			return "SHOPB";
		elseif (keeper.type == MT_MANEGG)
			return "SHOPC";
		end
	end

	return "SHOP";
end

function sugoi.KeeperSoundMove(keeper)
	if (keeper and keeper.valid)
		if (keeper.type == MT_SHOPKEEPER_OWL)
			return sfx_omo1 + P_RandomKey(5);
		end
	end

	return nil;
end

function sugoi.KeeperSoundBuy(keeper)
	if (keeper and keeper.valid)
		if (keeper.type == MT_SHOPKEEPER_OWL)
			return sfx_omobuy;
		elseif (keeper.type == MT_MANEGG)
			return sfx_manegg;
		end
	end

	return nil;
end

function sugoi.KeeperSoundCantBuy(keeper)
	if (keeper and keeper.valid)
		if (keeper.type == MT_SHOPKEEPER_OWL)
			return sfx_omo1 + P_RandomKey(5);
		end
	end

	return nil;
end

function sugoi.KeeperSoundExit(keeper)
	if (keeper and keeper.valid)
		if (keeper.type == MT_SHOPKEEPER_OWL)
			return sfx_omoxit;
		end
	end

	return nil;
end

function sugoi.PurchaseString()
	local purchaseStrings = {
		"Thanks for buying!",
		"Thanks for the purchase!",
		"Thanks for your money!",
		"Good choice!",
		"You bought that!",
		"I guess you can have that.",
		"Got it!",
		"That one...? Okay, I won't judge you.",
		"You recieved an item!",
		"It's in your bag.",
		"Big spender, huh?",
	};

	if (P_RandomChance(FRACUNIT/10))
		-- Use rare lines.
		purchaseStrings = {
			"SUGOI!",
			"SUBARASHII!",
			"Bought!!!!!",
			"Consume.",
			"Money can be exchanged for goods & services.",
			"Try again, it didn't accept your card.",
			"Big large purchase.",
		}
	end

	local numStrings = #purchaseStrings;
	return purchaseStrings[P_RandomKey(numStrings) + 1];
end

function sugoi.InitShopItemList()
	local debug = sugoi.cv_testitem.string;
	if (debug != "")
		local debugItem = sugoi.shopitems[debug];
		if (debugItem != nil)
			for i = 1,sugoi.SHOPLISTLEN do
				sugoi.shopitemlist[i] = debug;
			end
			return;
		end
	end

	local start = 1;

	local itemList = {};
	for k,it in pairs(sugoi.shopitems)
		local itemAddVal = nil;

		if (it.addFunc != nil)
			itemAddVal = it.addFunc();
		end

		if (itemAddVal == true)
			-- Forcefully add into the next slot (for Pity Shield or secrets)
			sugoi.shopitemlist[start] = k;
			start = $1 + 1;
			continue;
		elseif (itemAddVal == false)
			-- Never add this item if this condition is met.
			continue;
		end

		-- Otherwise, just add to the random table.
		table.insert(itemList, k);
	end

	if (start > sugoi.SHOPLISTLEN)
		-- Don't need to do anything else
		return;
	end

	for i = start,sugoi.SHOPLISTLEN do
		local picked = P_RandomKey(#itemList) + 1;
		sugoi.shopitemlist[i] = itemList[picked];
		table.remove(itemList, picked);
	end
end

function sugoi.UsePlayerItem(player)
	local prevTarget = player.mo.target;
	player.mo.target = player.mo; -- Oh good god

	if (player.shopitem == "mystery")
		local randoItemList = {};

		for k,v in pairs(sugoi.shopitems)
			if (v.useFunc == nil)
				-- Item does not have a use function, skip.
				continue;
			end

			local mysteryValue = true;
			if (v.mysteryFunc != nil)
				-- The item wants to decide whenever or not it can be rolled.
				local newMysteryValue = v.mysteryFunc();

				if (newMysteryValue != nil)
					-- Convert potential numbers to booleans
					if (newMysteryValue)
						mysteryValue = true;
					else
						mysteryValue = false;
					end
				end
			end

			if (mysteryValue == true)
				-- We can use this one.
				table.insert(randoItemList, k);
			end
		end

		player.shopitem = randoItemList[P_RandomKey(#randoItemList) + 1];
	end

	local item = sugoi.shopitems[player.shopitem];
	if (item != nil and item.useFunc != nil)
		item.useFunc(player);
	end

	player.shopitem = nil;
	player.mo.target = prevTarget; -- Set this awful hack back where it belongs :V
end
