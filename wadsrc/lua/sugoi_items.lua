local function PityAddFunc()
	for player in players.iterate do
		if (player.bot or player.spectator)
			continue;
		end

		if (player.tokens > 0)
			-- Someone has a token.
			return false;
		end
	end

	-- No one has a token.
	return true;
end

sugoi.AddShopItem(
	"pity",
	{
		name = "Pity Shield",
		description = "No money? I suppose you can have a\n" +
			"free sample. This is a Pity Shield.\n" +
			"It simply protects from a single\n" +
			"hit, nothing special about it.",
		price = 0,

		displayItemType = MT_PITY_BOX,
		shopIcon = "TVPIC0",
		livesIcon = "TVPIICON",

		addFunc = PityAddFunc,

		useFunc = function(player)
			P_SwitchShield(player, SH_PITY);
			S_StartSound(player.mo, mobjinfo[MT_PITY_ICON].seesound);
		end,
	}
);

sugoi.AddShopItem(
	"whirlwind",
	{
		name = "Whirlwind Shield",
		description = "The Whirlwind Shield lets the\n" +
			"user take a single hit from any\n" +
			"attack, as well as gives them an\n" +
			"extra jump at any time. Makes\n" +
			"getting to secret areas easier.",

		displayItemType = MT_WHIRLWIND_BOX,
		shopIcon = "TVWWC0",
		livesIcon = "TVWWICON",

		useFunc = function(player)
			P_SwitchShield(player, SH_WHIRLWIND);
			S_StartSound(player.mo, mobjinfo[MT_WHIRLWIND_ICON].seesound);
		end,
	}
);

sugoi.AddShopItem(
	"force",
	{
		name = "Force Shield",
		description = "The Force Shield protects from,\n" +
			"not one, but two attacks towards\n" +
			"the user. Can be helpful for\n" +
			"tougher stages.",

		displayItemType = MT_FORCE_BOX,
		shopIcon = "TVFOC0",
		livesIcon = "TVFOICON",

		useFunc = function(player)
			P_SwitchShield(player, SH_FORCE|1);
			S_StartSound(player.mo, mobjinfo[MT_FORCE_ICON].seesound);
		end,
	}
);

sugoi.AddShopItem(
	"armageddon",
	{
		name = "Armageddon Shield",
		description = "The Armageddon Shield protects\n" +
			"from a single attack, exploding\n" +
			"and destroying enemies around the\n" +
			"user when they get hit. Can be\n" +
			"detonated at any time.",

		displayItemType = MT_ARMAGEDDON_BOX,
		shopIcon = "TVARC0",
		livesIcon = "TVARICON",

		useFunc = function(player)
			P_SwitchShield(player, SH_ARMAGEDDON);
			S_StartSound(player.mo, mobjinfo[MT_ARMAGEDDON_ICON].seesound);
		end,
	}
);

sugoi.AddShopItem(
	"attract",
	{
		name = "Attraction Shield",
		description = "The Attraction Shield can let the\n" +
			"user take an extra hit, brings all\n" +
			"nearby rings towards them, and has\n" +
			"complete immunity to electricity.\n" +
			"Gains extra lives quickly!",

		displayItemType = MT_ATTRACT_BOX,
		shopIcon = "TVATC0",
		livesIcon = "TVATICON",

		useFunc = function(player)
			P_SwitchShield(player, SH_ATTRACT);
			S_StartSound(player.mo, mobjinfo[MT_ATTRACT_ICON].seesound);
		end,
	}
);

sugoi.AddShopItem(
	"elemental",
	{
		name = "Elemental Shield",
		description = "The Elemental Shield lets the\n" +
			"user take a single normal hit like\n" +
			"most shields, but also makes the\n" +
			"user immune to fire and drowning.",

		displayItemType = MT_ELEMENTAL_BOX,
		shopIcon = "TVELC0",
		livesIcon = "TVELICON",

		useFunc = function(player)
			P_SwitchShield(player, SH_ELEMENTAL);
			S_StartSound(player.mo, mobjinfo[MT_ELEMENTAL_ICON].seesound);
		end,
	}
);

sugoi.AddShopItem(
	"flameaura",
	{
		name = "Flame Shield",
		description = "The Flame Shield grants the user\n" +
			"an extra hit, and makes them\n" +
			"completely immune to fire. Can\n" +
			"also perform a fast mid-air dash.",

		displayItemType = MT_FLAMEAURA_BOX,
		shopIcon = "TVFLC0",
		livesIcon = "TVFLICON",

		useFunc = function(player)
			P_SwitchShield(player, SH_FLAMEAURA);
			S_StartSound(player.mo, mobjinfo[MT_FLAMEAURA_ICON].seesound);
		end,
	}
);

sugoi.AddShopItem(
	"bubblewrap",
	{
		name = "Bubble Shield",
		description = "The Bubble Shield lets the user\n" +
			"take an extra hit, and makes them\n" +
			"completely immune to drowning.\n" +
			"Can perform a bounce attack mid-\n" +
			"air.",

		displayItemType = MT_BUBBLEWRAP_BOX,
		shopIcon = "TVBBC0",
		livesIcon = "TVBBICON",

		useFunc = function(player)
			P_SwitchShield(player, SH_BUBBLEWRAP);
			S_StartSound(player.mo, mobjinfo[MT_BUBBLEWRAP_ICON].seesound);
		end,
	}
);

sugoi.AddShopItem(
	"thundercoin",
	{
		name = "Lightning Shield",
		description = "The Lightning Shield protects\n" +
			"from a single hit, attracts nearby\n" +
			"rings, and has immunity to\n" +
			"electricity. It can perform a\n" +
			"double jump, as well.",

		displayItemType = MT_THUNDERCOIN_BOX,
		shopIcon = "TVZPC0",
		livesIcon = "TVZPICON",

		useFunc = function(player)
			P_SwitchShield(player, SH_THUNDERCOIN);
			S_StartSound(player.mo, mobjinfo[MT_THUNDERCOIN_ICON].seesound);
		end,
	}
);

function sugoi.GivePinkShields()
	for player in players.iterate do
		if not (player.mo and player.mo.valid)
			continue;
		end

		local curShield = (player.powers[pw_shield] & SH_NOSTACK);
		if (curShield == 0)
			P_SwitchShield(player, SH_PINK);
			S_StartSound(player.mo, mobjinfo[MT_PITY_ICON].seesound);
		end
	end
end

sugoi.AddShopItem(
	"pink",
	{
		name = "Heart Shield",
		description = "Just a regular shield with no\n" +
			"abilities, but it's given to\n" +
			"everyone playing who don't have\n" +
			"a shield. Why, aren't you so\n" +
			"thoughtful?",
		price = 1,

		displayItemType = MT_PITYALL_BOX,
		shopIcon = "TVPAC0",
		livesIcon = "TVPPICON",

		addFunc = function()
			if not (netgame or multiplayer)
				-- Only allow in multiplayer games.
				return false;
			end

			if (PityAddFunc() == true)
				-- If we're adding a pity shield,
				-- this item would be kind of pointless.
				return false;
			end

			-- Use regular spawning mechanism.
			return nil;
		end,

		useFunc = function(player)
			player.activatePinkShield = true;
		end,

		mysteryFunc = function()
			-- Only allow in multiplayer games.
			return (netgame or multiplayer);
		end,
	}
);

sugoi.AddShopItem(
	"cactus",
	{
		name = "Cactus Shield",
		description = "The Cactus Shield protects the\n" +
			"user from a single hit, and makes\n" +
			"them immune to spike damage. Can\n" +
			"shoot spikes in all directions,\n" +
			"which recharge every few seconds.",

		displayItemType = MT_CACTI_BOX,
		shopIcon = "TVCCC0",
		livesIcon = "TVCCICON",

		useFunc = function(player)
			P_SwitchShield(player, SH_CACTI);
			S_StartSound(player.mo, mobjinfo[MT_CACTI_ICON].seesound);
		end,
	}
);

sugoi.AddShopItem(
	"boulder",
	{
		name = "Boulder Shield",
		description = "The Boulder Shield protects the\n" +
			"user from a single hit, and lets\n" +
			"them turn into a massive boulder.\n" +
			"Can be used to bounce around, as\n" +
			"well as climb slopes easily.",

		displayItemType = MT_BOULDER_BOX,
		shopIcon = "TVBDC0",
		livesIcon = "TVBDICON",

		useFunc = function(player)
			P_SwitchShield(player, SH_BOULDER);
			S_StartSound(player.mo, mobjinfo[MT_BOULDER_ICON].seesound);
		end,
	}
);

sugoi.AddShopItem(
	"pogo",
	{
		name = "Pogo Spring",
		description = "The Pogo Spring attaches\n" +
			"to your feet and lets you do\n" +
			"hop around constantly. Jumping\n" +
			"will give you a massive jump,\n" +
			"but you lose the spring.",

		displayItemType = MT_POGOSPRING_BOX,
		shopIcon = "TVPSC0",
		livesIcon = "TVPSICON",

		useFunc = function(player)
			PogoSpring.Init(player);
			S_StartSound(player.mo, mobjinfo[MT_POGOSPRING_ICON].seesound);
		end,
	}
);

sugoi.AddShopItem(
	"invincibility",
	{
		name = "Invincibility",
		description = "Grants the user 20 seconds of\n" +
			"invincibility at the beginning of\n" +
			"the next level. Short-lived, but\n" +
			"can come in handy.",

		displayItemType = MT_INVULN_BOX,
		shopIcon = "TVIVC0",
		livesIcon = "TVIVICON",

		useFunc = function(player)
			A_Invincibility(player.mo);
		end,
	}
);

sugoi.AddShopItem(
	"sneakers",
	{
		name = "Speed Sneakers",
		description = "Grants the user 20 seconds of\n" +
			"extra speed at the beginning of\n" +
			"the next level. Breeze through\n" +
			"shorter levels!",

		displayItemType = MT_SNEAKERS_BOX,
		shopIcon = "TVSSC0",
		livesIcon = "TVSSICON",

		useFunc = function(player)
			A_SuperSneakers(player.mo);
		end,
	}
);

sugoi.AddShopItem(
	"fireflower",
	{
		name = "Fire Flower",
		description = "Protects you from an extra hit,\n" +
			"and lets you shoot fireballs. Can\n" +
			"stack with other shields.",

		displayItemType = MT_FIREFLOWER,
		shopIcon = "SHOPFIRF",
		livesIcon = "FIRFICON",

		useFunc = function(player)
			S_StartSound(player.mo, sfx_mario3);
			player.powers[pw_shield] = ($1 & SH_NOSTACK) | SH_FIREFLOWER;
			player.mo.color = SKINCOLOR_WHITE;
		end,
	}
);

sugoi.AddShopItem(
	"oneup",
	{
		name = "Extra Life",
		description = "Another shot at redemption! Buy a\n" +
			"couple if you find yourself\n" +
			"getting low.",

		displayItemType = MT_1UP_BOX,
		shopIcon = "TV1UC0",

		addFunc = function()
			local infiniteLives = false;

			for player in players.iterate do
				if (player.lives == INFLIVES)
					infiniteLives = true;
					break;
				end
			end

			-- Don't add if anyone has infinite lives.
			if (infiniteLives == true)
				return false;
			end

			-- Add to the randomize list otherwise.
			return nil;
		end,

		buyFunc = function(player)
			P_GivePlayerLives(player, 1);
			P_PlayLivesJingle(player);
			return true;
		end,

		-- While you can't have a 1-Up in your inventory because of the buyFunc,
		-- uncommenting this would allow it to be rolled in the Mystery item table.
		--[[
		useFunc = function(player)
			P_GivePlayerLives(player, 1);
			P_PlayLivesJingle(player);
		end,
		--]]
	}
);

sugoi.AddShopItem(
	"emerald",
	{
		name = "Chaos Emerald",
		description = "A very shiny Chaos Emerald! Skip\n" +
			"out on doing an Emerald Stage, but\n" +
			"at a much steeper cost.",
		price = 3,

		displayItemType = MT_DISPLAYEMERALD,
		shopIcon = "TV1PC0", -- The chaos emerald is drawn in later

		addFunc = function()
			-- If all you got them all, don't add this one.
			if (All7Emeralds(emeralds))
				return false;
			end

			-- Add to the randomize list otherwise.
			return nil;
		end,

		buyFunc = function(player)
			local nextem = sugoi.NextEmeraldNum(emeralds);
			local nextemflag = 1 << (nextem-1);

			if (nextem == 0)
				player.ui.string = "Sold out!";
				S_StartSound(nil, sfx_lose, player);
				return false;
			else
				emeralds = $1 | nextemflag;
				S_StartSound(nil, sfx_cgot); -- All players should hear!
				return true;
			end
		end,
	}
);

sugoi.AddShopItem(
	"super",
	{
		name = "Super Monitor",
		description = "Grants the user 50 rings and turns\n" +
			"them Super at the start of a level!\n" +
			"Characters that normally can't go\n" +
			"Super can still be hurt, but\n" +
			"only lose some rings.",
		price = 3,

		displayItemType = MT_DISPLAYSUPER,
		shopIcon = "SHOPTVSU",
		livesIcon = "TVSUICON",

		addFunc = function()
			-- Only add this one if you got all them all.
			if not (All7Emeralds(emeralds))
				return false;
			end

			-- Add to the randomize list otherwise.
			return nil;
		end,

		useFunc = function(player)
			if not (skins[player.mo.skin].flags & SF_SUPER)
				player.charflags = $1 | SF_SUPER;
				player.sugoiAllSuper = true;
			end

			P_DoSuperTransformation(player, true);
		end,

		mysteryFunc = function()
			-- Only allow if you got all emeralds.
			if (All7Emeralds(emeralds))
				return true;
			end

			return false;
		end,
	}
);

sugoi.AddShopItem(
	"gravityboots",
	{
		name = "Gravity Boots",
		description = "...What? Er, um, the Gravity Boots\n" +
			"reverse your gravity for a short\n" +
			"period of time at the start of the\n" +
			"next level.",
		price = 1,

		displayItemType = MT_GRAVITY_BOX,
		shopIcon = "TVGVC0",
		livesIcon = "TVGVICON",

		addFunc = function()
			-- Only add this one after a small chance.
			if (P_RandomChance(FRACUNIT/10))
				return nil;
			end

			return false;
		end,

		useFunc = function(player)
			player.powers[pw_gravityboots] = 20*TICRATE + 1;
			S_StartSound(nil, sfx_s3k73, player);
		end,
	}
);

sugoi.AddShopItem(
	"eggman",
	{
		name = "Eggman Monitor",
		description = "This item just hurts you.\n" +
			"SUBARASHII!",
		price = 1,

		displayItemType = MT_EGGMAN_BOX,
		shopIcon = "TVEGC0",

		addFunc = function()
			-- Only add this one after a small chance.
			if (P_RandomChance(FRACUNIT/32))
				return nil;
			end

			return false;
		end,

		buyFunc = function(player)
			sugoi.subarashii(player);
			player.ui.string = "SUBARASHII!"; -- No one can see this :D
			player.ui.mode = 0;
			player.ui.cooldown = 0;
			player.pflags = ($1 & !PF_FORCESTRAFE);
			return true;
		end,
	}
);

sugoi.AddShopItem(
	"mystery",
	{
		name = "Mystery Item",
		description = "Feed your gacha addiction and get\n" +
			"a randomly picked item at the\n" +
			"start of the next level. Maybe\n" +
			"you'll get something good!",

		displayItemType = MT_MYSTERY_BOX,
		shopIcon = "TVMYC0",
		livesIcon = "TVMYICON",

		addFunc = function()
			if (P_RandomChance(FRACUNIT/5))
				-- Higher chance of appearing by being forced in.
				return true;
			end

			-- Use regular odds
			return nil;
		end,

		useFunc = function(player)
			-- If the random item picker rolls random, lets do some funny stuff :p
			if (P_RandomChance(FRACUNIT/10))
				sugoi.subarashii(player);
			else
				if (P_RandomChance(FRACUNIT/4))
					P_GivePlayerRings(player, 1);
				else
					P_GivePlayerRings(player, 10);
				end

				S_StartSound(player.mo, sfx_itemup);
			end
		end,
	}
);
