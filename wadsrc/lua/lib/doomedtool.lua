--
-- == DoomEdTool ==
-- by TehRealSalt
--
-- Checks for any map thing number conflicts,
-- and reports that information to you.
--

-- This sucks, but is the only thing I can do.
-- (SOC is totally fucked.)
local MTNAMES = {
	[0] = "MT_NULL",
	"MT_UNKNOWN",

	"MT_THOK", // Thok! mobj
	"MT_PLAYER",
	"MT_TAILSOVERLAY", // c:
	"MT_METALJETFUME",

	// Enemies
	"MT_BLUECRAWLA", // Crawla (Blue)
	"MT_REDCRAWLA", // Crawla (Red)
	"MT_GFZFISH", // SDURF
	"MT_GOLDBUZZ", // Buzz (Gold)
	"MT_REDBUZZ", // Buzz (Red)
	"MT_JETTBOMBER", // Jetty-Syn Bomber
	"MT_JETTGUNNER", // Jetty-Syn Gunner
	"MT_CRAWLACOMMANDER", // Crawla Commander
	"MT_DETON", // Deton
	"MT_SKIM", // Skim mine dropper
	"MT_TURRET", // Industrial Turret
	"MT_POPUPTURRET", // Pop-Up Turret
	"MT_SPINCUSHION", // Spincushion
	"MT_CRUSHSTACEAN", // Crushstacean
	"MT_CRUSHCLAW", // Big meaty claw
	"MT_CRUSHCHAIN", // Chain
	"MT_BANPYURA", // Banpyura
	"MT_BANPSPRING", // Banpyura spring
	"MT_JETJAW", // Jet Jaw
	"MT_SNAILER", // Snailer
	"MT_VULTURE", // BASH
	"MT_POINTY", // Pointy
	"MT_POINTYBALL", // Pointy Ball
	"MT_ROBOHOOD", // Robo-Hood
	"MT_FACESTABBER", // Castlebot Facestabber
	"MT_FACESTABBERSPEAR", // Castlebot Facestabber spear aura
	"MT_EGGGUARD", // Egg Guard
	"MT_EGGSHIELD", // Egg Guard's shield
	"MT_GSNAPPER", // Green Snapper
	"MT_SNAPPER_LEG", // Green Snapper leg
	"MT_SNAPPER_HEAD", // Green Snapper head
	"MT_MINUS", // Minus
	"MT_MINUSDIRT", // Minus dirt
	"MT_SPRINGSHELL", // Spring Shell
	"MT_YELLOWSHELL", // Spring Shell (yellow)
	"MT_UNIDUS", // Unidus
	"MT_UNIBALL", // Unidus Ball
	"MT_CANARIVORE", // Canarivore
	"MT_CANARIVORE_GAS", // Canarivore gas
	"MT_PYREFLY", // Pyre Fly
	"MT_PYREFLY_FIRE", // Pyre Fly fire
	"MT_PTERABYTESPAWNER", // Pterabyte spawner
	"MT_PTERABYTEWAYPOINT", // Pterabyte waypoint
	"MT_PTERABYTE", // Pterabyte
	"MT_DRAGONBOMBER", // Dragonbomber
	"MT_DRAGONWING", // Dragonbomber wing
	"MT_DRAGONTAIL", // Dragonbomber tail segment
	"MT_DRAGONMINE", // Dragonbomber mine

	// Generic Boss Items
	"MT_BOSSEXPLODE",
	"MT_SONIC3KBOSSEXPLODE",
	"MT_BOSSFLYPOINT",
	"MT_EGGTRAP",
	"MT_BOSS3WAYPOINT",
	"MT_BOSS9GATHERPOINT",
	"MT_BOSSJUNK",

	// Boss 1
	"MT_EGGMOBILE",
	"MT_JETFUME1",
	"MT_EGGMOBILE_BALL",
	"MT_EGGMOBILE_TARGET",
	"MT_EGGMOBILE_FIRE",

	// Boss 2
	"MT_EGGMOBILE2",
	"MT_EGGMOBILE2_POGO",
	"MT_GOOP",
	"MT_GOOPTRAIL",

	// Boss 3
	"MT_EGGMOBILE3",
	"MT_FAKEMOBILE",
	"MT_SHOCKWAVE",

	// Boss 4
	"MT_EGGMOBILE4",
	"MT_EGGMOBILE4_MACE",
	"MT_JETFLAME",
	"MT_EGGROBO1",
	"MT_EGGROBO1JET",

	// Boss 5
	"MT_FANG",
	"MT_BROKENROBOT",
	"MT_VWREF",
	"MT_VWREB",
	"MT_PROJECTORLIGHT",
	"MT_FBOMB",
	"MT_TNTDUST", // also used by barrel
	"MT_FSGNA",
	"MT_FSGNB",
	"MT_FANGWAYPOINT",

	// Black Eggman (Boss 7)
	"MT_BLACKEGGMAN",
	"MT_BLACKEGGMAN_HELPER",
	"MT_BLACKEGGMAN_GOOPFIRE",
	"MT_BLACKEGGMAN_MISSILE",

	// New Very-Last-Minute 2.1 Brak Eggman (Cy-Brak-demon)
	"MT_CYBRAKDEMON",
	"MT_CYBRAKDEMON_ELECTRIC_BARRIER",
	"MT_CYBRAKDEMON_MISSILE",
	"MT_CYBRAKDEMON_FLAMESHOT",
	"MT_CYBRAKDEMON_FLAMEREST",
	"MT_CYBRAKDEMON_TARGET_RETICULE",
	"MT_CYBRAKDEMON_TARGET_DOT",
	"MT_CYBRAKDEMON_NAPALM_BOMB_LARGE",
	"MT_CYBRAKDEMON_NAPALM_BOMB_SMALL",
	"MT_CYBRAKDEMON_NAPALM_FLAMES",
	"MT_CYBRAKDEMON_VILE_EXPLOSION",

	// Metal Sonic (Boss 9)
	"MT_METALSONIC_RACE",
	"MT_METALSONIC_BATTLE",
	"MT_MSSHIELD_FRONT",
	"MT_MSGATHER",

	// Collectible Items
	"MT_RING",
	"MT_FLINGRING", // Lost ring
	"MT_BLUESPHERE",  // Blue sphere for special stages
	"MT_FLINGBLUESPHERE", // Lost blue sphere
	"MT_BOMBSPHERE",
	"MT_REDTEAMRING",  //Rings collectable by red team.
	"MT_BLUETEAMRING", //Rings collectable by blue team.
	"MT_TOKEN", // Special Stage token for special stage
	"MT_REDFLAG", // Red CTF Flag
	"MT_BLUEFLAG", // Blue CTF Flag
	"MT_EMBLEM",
	"MT_EMERALD1",
	"MT_EMERALD2",
	"MT_EMERALD3",
	"MT_EMERALD4",
	"MT_EMERALD5",
	"MT_EMERALD6",
	"MT_EMERALD7",
	"MT_EMERHUNT", // Emerald Hunt
	"MT_EMERALDSPAWN", // Emerald spawner w/ delay
	"MT_FLINGEMERALD", // Lost emerald

	// Springs and others
	"MT_FAN",
	"MT_STEAM",
	"MT_BUMPER",
	"MT_BALLOON",

	"MT_YELLOWSPRING",
	"MT_REDSPRING",
	"MT_BLUESPRING",
	"MT_YELLOWDIAG",
	"MT_REDDIAG",
	"MT_BLUEDIAG",
	"MT_YELLOWHORIZ",
	"MT_REDHORIZ",
	"MT_BLUEHORIZ",

	"MT_BOOSTERSEG",
	"MT_BOOSTERROLLER",
	"MT_YELLOWBOOSTER",
	"MT_REDBOOSTER",

	// Interactive Objects
	"MT_BUBBLES", // Bubble source
	"MT_SIGN", // Level end sign
	"MT_SPIKEBALL", // Spike Ball
	"MT_SPINFIRE",
	"MT_SPIKE",
	"MT_WALLSPIKE",
	"MT_WALLSPIKEBASE",
	"MT_STARPOST",
	"MT_BIGMINE",
	"MT_BLASTEXECUTOR",
	"MT_CANNONLAUNCHER",

	// Monitor miscellany
	"MT_BOXSPARKLE",

	// Monitor boxes -- regular
	"MT_RING_BOX",
	"MT_PITY_BOX",
	"MT_ATTRACT_BOX",
	"MT_FORCE_BOX",
	"MT_ARMAGEDDON_BOX",
	"MT_WHIRLWIND_BOX",
	"MT_ELEMENTAL_BOX",
	"MT_SNEAKERS_BOX",
	"MT_INVULN_BOX",
	"MT_1UP_BOX",
	"MT_EGGMAN_BOX",
	"MT_MIXUP_BOX",
	"MT_MYSTERY_BOX",
	"MT_GRAVITY_BOX",
	"MT_RECYCLER_BOX",
	"MT_SCORE1K_BOX",
	"MT_SCORE10K_BOX",
	"MT_FLAMEAURA_BOX",
	"MT_BUBBLEWRAP_BOX",
	"MT_THUNDERCOIN_BOX",

	// Monitor boxes -- repeating (big) boxes
	"MT_PITY_GOLDBOX",
	"MT_ATTRACT_GOLDBOX",
	"MT_FORCE_GOLDBOX",
	"MT_ARMAGEDDON_GOLDBOX",
	"MT_WHIRLWIND_GOLDBOX",
	"MT_ELEMENTAL_GOLDBOX",
	"MT_SNEAKERS_GOLDBOX",
	"MT_INVULN_GOLDBOX",
	"MT_EGGMAN_GOLDBOX",
	"MT_GRAVITY_GOLDBOX",
	"MT_FLAMEAURA_GOLDBOX",
	"MT_BUBBLEWRAP_GOLDBOX",
	"MT_THUNDERCOIN_GOLDBOX",

	// Monitor boxes -- special
	"MT_RING_REDBOX",
	"MT_RING_BLUEBOX",

	// Monitor icons
	"MT_RING_ICON",
	"MT_PITY_ICON",
	"MT_ATTRACT_ICON",
	"MT_FORCE_ICON",
	"MT_ARMAGEDDON_ICON",
	"MT_WHIRLWIND_ICON",
	"MT_ELEMENTAL_ICON",
	"MT_SNEAKERS_ICON",
	"MT_INVULN_ICON",
	"MT_1UP_ICON",
	"MT_EGGMAN_ICON",
	"MT_MIXUP_ICON",
	"MT_GRAVITY_ICON",
	"MT_RECYCLER_ICON",
	"MT_SCORE1K_ICON",
	"MT_SCORE10K_ICON",
	"MT_FLAMEAURA_ICON",
	"MT_BUBBLEWRAP_ICON",
	"MT_THUNDERCOIN_ICON",

	// Projectiles
	"MT_ROCKET",
	"MT_LASER",
	"MT_TORPEDO",
	"MT_TORPEDO2", // silent
	"MT_ENERGYBALL",
	"MT_MINE", // Skim/Jetty-Syn mine
	"MT_JETTBULLET", // Jetty-Syn Bullet
	"MT_TURRETLASER",
	"MT_CANNONBALL", // Cannonball
	"MT_CANNONBALLDECOR", // Decorative/still cannonball
	"MT_ARROW", // Arrow
	"MT_DEMONFIRE", // Glaregoyle fire

	// The letter
	"MT_LETTER",

	// Tutorial Scenery
	"MT_TUTORIALPLANT",
	"MT_TUTORIALLEAF",
	"MT_TUTORIALFLOWER",
	"MT_TUTORIALFLOWERF",

	// Greenflower Scenery
	"MT_GFZFLOWER1",
	"MT_GFZFLOWER2",
	"MT_GFZFLOWER3",

	"MT_BLUEBERRYBUSH",
	"MT_BERRYBUSH",
	"MT_BUSH",

	// Trees (both GFZ and misc)
	"MT_GFZTREE",
	"MT_GFZBERRYTREE",
	"MT_GFZCHERRYTREE",
	"MT_CHECKERTREE",
	"MT_CHECKERSUNSETTREE",
	"MT_FHZTREE", // Frozen Hillside
	"MT_FHZPINKTREE",
	"MT_POLYGONTREE",
	"MT_BUSHTREE",
	"MT_BUSHREDTREE",
	"MT_SPRINGTREE",

	// Techno Hill Scenery
	"MT_THZFLOWER1",
	"MT_THZFLOWER2",
	"MT_THZFLOWER3",
	"MT_THZTREE", // Steam whistle tree/bush
	"MT_THZTREEBRANCH", // branch of said tree
	"MT_ALARM",

	// Deep Sea Scenery
	"MT_GARGOYLE", // Deep Sea Gargoyle
	"MT_BIGGARGOYLE", // Deep Sea Gargoyle (Big)
	"MT_SEAWEED", // DSZ Seaweed
	"MT_WATERDRIP", // Dripping Water source
	"MT_WATERDROP", // Water drop from dripping water
	"MT_CORAL1", // Coral
	"MT_CORAL2",
	"MT_CORAL3",
	"MT_CORAL4",
	"MT_CORAL5",
	"MT_BLUECRYSTAL", // Blue Crystal
	"MT_KELP", // Kelp
	"MT_ANIMALGAETOP", // Animated algae top
	"MT_ANIMALGAESEG", // Animated algae segment
	"MT_DSZSTALAGMITE", // Deep Sea 1 Stalagmite
	"MT_DSZ2STALAGMITE", // Deep Sea 2 Stalagmite
	"MT_LIGHTBEAM", // DSZ Light beam

	// Castle Eggman Scenery
	"MT_CHAIN", // CEZ Chain
	"MT_FLAME", // Flame (has corona)
	"MT_FLAMEPARTICLE",
	"MT_EGGSTATUE", // Eggman Statue
	"MT_MACEPOINT", // Mace rotation point
	"MT_CHAINMACEPOINT", // Combination of chains and maces point
	"MT_SPRINGBALLPOINT", // Spring ball point
	"MT_CHAINPOINT", // Mace chain
	"MT_HIDDEN_SLING", // Spin mace chain (activatable)
	"MT_FIREBARPOINT", // Firebar
	"MT_CUSTOMMACEPOINT", // Custom mace
	"MT_SMALLMACECHAIN", // Small Mace Chain
	"MT_BIGMACECHAIN", // Big Mace Chain
	"MT_SMALLMACE", // Small Mace
	"MT_BIGMACE", // Big Mace
	"MT_SMALLGRABCHAIN", // Small Grab Chain
	"MT_BIGGRABCHAIN", // Big Grab Chain
	"MT_YELLOWSPRINGBALL", // Yellow spring on a ball
	"MT_REDSPRINGBALL", // Red spring on a ball
	"MT_SMALLFIREBAR", // Small Firebar
	"MT_BIGFIREBAR", // Big Firebar
	"MT_CEZFLOWER", // Flower
	"MT_CEZPOLE1", // Pole (with red banner)
	"MT_CEZPOLE2", // Pole (with blue banner)
	"MT_CEZBANNER1", // Banner (red)
	"MT_CEZBANNER2", // Banner (blue)
	"MT_PINETREE", // Pine Tree
	"MT_CEZBUSH1", // Bush 1
	"MT_CEZBUSH2", // Bush 2
	"MT_CANDLE", // Candle
	"MT_CANDLEPRICKET", // Candle pricket
	"MT_FLAMEHOLDER", // Flame holder
	"MT_FIRETORCH", // Fire torch
	"MT_WAVINGFLAG1", // Waving flag (red)
	"MT_WAVINGFLAG2", // Waving flag (blue)
	"MT_WAVINGFLAGSEG1", // Waving flag segment (red)
	"MT_WAVINGFLAGSEG2", // Waving flag segment (blue)
	"MT_CRAWLASTATUE", // Crawla statue
	"MT_FACESTABBERSTATUE", // Facestabber statue
	"MT_SUSPICIOUSFACESTABBERSTATUE", // :eggthinking:
	"MT_BRAMBLES", // Brambles

	// Arid Canyon Scenery
	"MT_BIGTUMBLEWEED",
	"MT_LITTLETUMBLEWEED",
	"MT_CACTI1", // Tiny Red Flower Cactus
	"MT_CACTI2", // Small Red Flower Cactus
	"MT_CACTI3", // Tiny Blue Flower Cactus
	"MT_CACTI4", // Small Blue Flower Cactus
	"MT_CACTI5", // Prickly Pear
	"MT_CACTI6", // Barrel Cactus
	"MT_CACTI7", // Tall Barrel Cactus
	"MT_CACTI8", // Armed Cactus
	"MT_CACTI9", // Ball Cactus
	"MT_CACTI10", // Tiny Cactus
	"MT_CACTI11", // Small Cactus
	"MT_CACTITINYSEG", // Tiny Cactus Segment
	"MT_CACTISMALLSEG", // Small Cactus Segment
	"MT_ARIDSIGN_CAUTION", // Caution Sign
	"MT_ARIDSIGN_CACTI", // Cacti Sign
	"MT_ARIDSIGN_SHARPTURN", // Sharp Turn Sign
	"MT_OILLAMP",
	"MT_TNTBARREL",
	"MT_PROXIMITYTNT",
	"MT_DUSTDEVIL",
	"MT_DUSTLAYER",
	"MT_ARIDDUST",
	"MT_MINECART",
	"MT_MINECARTSEG",
	"MT_MINECARTSPAWNER",
	"MT_MINECARTEND",
	"MT_MINECARTENDSOLID",
	"MT_MINECARTSIDEMARK",
	"MT_MINECARTSPARK",
	"MT_SALOONDOOR",
	"MT_SALOONDOORCENTER",
	"MT_TRAINCAMEOSPAWNER",
	"MT_TRAINSEG",
	"MT_TRAINDUSTSPAWNER",
	"MT_TRAINSTEAMSPAWNER",
	"MT_MINECARTSWITCHPOINT",

	// Red Volcano Scenery
	"MT_FLAMEJET",
	"MT_VERTICALFLAMEJET",
	"MT_FLAMEJETFLAME",

	"MT_FJSPINAXISA", // Counter-clockwise
	"MT_FJSPINAXISB", // Clockwise

	"MT_FLAMEJETFLAMEB", // Blade's flame

	"MT_LAVAFALL",
	"MT_LAVAFALL_LAVA",
	"MT_LAVAFALLROCK",

	"MT_ROLLOUTSPAWN",
	"MT_ROLLOUTROCK",

	"MT_BIGFERNLEAF",
	"MT_BIGFERN",
	"MT_JUNGLEPALM",
	"MT_TORCHFLOWER",
	"MT_WALLVINE_LONG",
	"MT_WALLVINE_SHORT",

	// Dark City Scenery

	// Egg Rock Scenery

	// Azure Temple Scenery
	"MT_GLAREGOYLE",
	"MT_GLAREGOYLEUP",
	"MT_GLAREGOYLEDOWN",
	"MT_GLAREGOYLELONG",
	"MT_TARGET", // AKA Red Crystal
	"MT_GREENFLAME",
	"MT_BLUEGARGOYLE",

	// Stalagmites
	"MT_STALAGMITE0",
	"MT_STALAGMITE1",
	"MT_STALAGMITE2",
	"MT_STALAGMITE3",
	"MT_STALAGMITE4",
	"MT_STALAGMITE5",
	"MT_STALAGMITE6",
	"MT_STALAGMITE7",
	"MT_STALAGMITE8",
	"MT_STALAGMITE9",

	// Christmas Scenery
	"MT_XMASPOLE",
	"MT_CANDYCANE",
	"MT_SNOWMAN",    // normal
	"MT_SNOWMANHAT", // with hat + scarf
	"MT_LAMPPOST1",  // normal
	"MT_LAMPPOST2",  // with snow
	"MT_HANGSTAR",
	"MT_MISTLETOE",
	// Xmas GFZ bushes
	"MT_XMASBLUEBERRYBUSH",
	"MT_XMASBERRYBUSH",
	"MT_XMASBUSH",
	// FHZ
	"MT_FHZICE1",
	"MT_FHZICE2",
	"MT_ROSY",
	"MT_CDLHRT",

	// Halloween Scenery
	// Pumpkins
	"MT_JACKO1",
	"MT_JACKO2",
	"MT_JACKO3",
	// Dr Seuss Trees
	"MT_HHZTREE_TOP",
	"MT_HHZTREE_PART",
	// Misc
	"MT_HHZSHROOM",
	"MT_HHZGRASS",
	"MT_HHZTENTACLE1",
	"MT_HHZTENTACLE2",
	"MT_HHZSTALAGMITE_TALL",
	"MT_HHZSTALAGMITE_SHORT",

	// Botanic Serenity scenery
	"MT_BSZTALLFLOWER_RED",
	"MT_BSZTALLFLOWER_PURPLE",
	"MT_BSZTALLFLOWER_BLUE",
	"MT_BSZTALLFLOWER_CYAN",
	"MT_BSZTALLFLOWER_YELLOW",
	"MT_BSZTALLFLOWER_ORANGE",
	"MT_BSZFLOWER_RED",
	"MT_BSZFLOWER_PURPLE",
	"MT_BSZFLOWER_BLUE",
	"MT_BSZFLOWER_CYAN",
	"MT_BSZFLOWER_YELLOW",
	"MT_BSZFLOWER_ORANGE",
	"MT_BSZSHORTFLOWER_RED",
	"MT_BSZSHORTFLOWER_PURPLE",
	"MT_BSZSHORTFLOWER_BLUE",
	"MT_BSZSHORTFLOWER_CYAN",
	"MT_BSZSHORTFLOWER_YELLOW",
	"MT_BSZSHORTFLOWER_ORANGE",
	"MT_BSZTULIP_RED",
	"MT_BSZTULIP_PURPLE",
	"MT_BSZTULIP_BLUE",
	"MT_BSZTULIP_CYAN",
	"MT_BSZTULIP_YELLOW",
	"MT_BSZTULIP_ORANGE",
	"MT_BSZCLUSTER_RED",
	"MT_BSZCLUSTER_PURPLE",
	"MT_BSZCLUSTER_BLUE",
	"MT_BSZCLUSTER_CYAN",
	"MT_BSZCLUSTER_YELLOW",
	"MT_BSZCLUSTER_ORANGE",
	"MT_BSZBUSH_RED",
	"MT_BSZBUSH_PURPLE",
	"MT_BSZBUSH_BLUE",
	"MT_BSZBUSH_CYAN",
	"MT_BSZBUSH_YELLOW",
	"MT_BSZBUSH_ORANGE",
	"MT_BSZVINE_RED",
	"MT_BSZVINE_PURPLE",
	"MT_BSZVINE_BLUE",
	"MT_BSZVINE_CYAN",
	"MT_BSZVINE_YELLOW",
	"MT_BSZVINE_ORANGE",
	"MT_BSZSHRUB",
	"MT_BSZCLOVER",
	"MT_BIG_PALMTREE_TRUNK",
	"MT_BIG_PALMTREE_TOP",
	"MT_PALMTREE_TRUNK",
	"MT_PALMTREE_TOP",

	// Misc scenery
	"MT_DBALL",
	"MT_EGGSTATUE2",

	// Powerup Indicators
	"MT_ELEMENTAL_ORB", // Elemental shield mobj
	"MT_ATTRACT_ORB", // Attract shield mobj
	"MT_FORCE_ORB", // Force shield mobj
	"MT_ARMAGEDDON_ORB", // Armageddon shield mobj
	"MT_WHIRLWIND_ORB", // Whirlwind shield mobj
	"MT_PITY_ORB", // Pity shield mobj
	"MT_FLAMEAURA_ORB", // Flame shield mobj
	"MT_BUBBLEWRAP_ORB", // Bubble shield mobj
	"MT_THUNDERCOIN_ORB", // Thunder shield mobj
	"MT_THUNDERCOIN_SPARK", // Thunder spark
	"MT_IVSP", // Invincibility sparkles
	"MT_SUPERSPARK", // Super Sonic Spark

	// Flickies
	"MT_FLICKY_01", // Bluebird
	"MT_FLICKY_01_CENTER",
	"MT_FLICKY_02", // Rabbit
	"MT_FLICKY_02_CENTER",
	"MT_FLICKY_03", // Chicken
	"MT_FLICKY_03_CENTER",
	"MT_FLICKY_04", // Seal
	"MT_FLICKY_04_CENTER",
	"MT_FLICKY_05", // Pig
	"MT_FLICKY_05_CENTER",
	"MT_FLICKY_06", // Chipmunk
	"MT_FLICKY_06_CENTER",
	"MT_FLICKY_07", // Penguin
	"MT_FLICKY_07_CENTER",
	"MT_FLICKY_08", // Fish
	"MT_FLICKY_08_CENTER",
	"MT_FLICKY_09", // Ram
	"MT_FLICKY_09_CENTER",
	"MT_FLICKY_10", // Puffin
	"MT_FLICKY_10_CENTER",
	"MT_FLICKY_11", // Cow
	"MT_FLICKY_11_CENTER",
	"MT_FLICKY_12", // Rat
	"MT_FLICKY_12_CENTER",
	"MT_FLICKY_13", // Bear
	"MT_FLICKY_13_CENTER",
	"MT_FLICKY_14", // Dove
	"MT_FLICKY_14_CENTER",
	"MT_FLICKY_15", // Cat
	"MT_FLICKY_15_CENTER",
	"MT_FLICKY_16", // Canary
	"MT_FLICKY_16_CENTER",
	"MT_SECRETFLICKY_01", // Spider
	"MT_SECRETFLICKY_01_CENTER",
	"MT_SECRETFLICKY_02", // Bat
	"MT_SECRETFLICKY_02_CENTER",
	"MT_SEED",

	// Environmental Effects
	"MT_RAIN", // Rain
	"MT_SNOWFLAKE", // Snowflake
	"MT_SPLISH", // Water splish!
	"MT_LAVASPLISH", // Lava splish!
	"MT_SMOKE",
	"MT_SMALLBUBBLE", // small bubble
	"MT_MEDIUMBUBBLE", // medium bubble
	"MT_EXTRALARGEBUBBLE", // extra large bubble
	"MT_WATERZAP",
	"MT_SPINDUST", // Spindash dust
	"MT_TFOG",
	"MT_PARTICLE",
	"MT_PARTICLEGEN", // For fans, etc.

	// Game Indicators
	"MT_SCORE", // score logo
	"MT_DROWNNUMBERS", // Drowning Timer
	"MT_GOTEMERALD", // Chaos Emerald (intangible)
	"MT_LOCKON", // Target
	"MT_LOCKONINF", // In-level Target
	"MT_TAG", // Tag Sign
	"MT_GOTFLAG", // Got Flag sign
	"MT_FINISHFLAG", // Finish flag

	// Ambient Sounds
	"MT_AMBIENT",

	"MT_CORK",
	"MT_LHRT",

	// Ring Weapons
	"MT_REDRING",
	"MT_BOUNCERING",
	"MT_RAILRING",
	"MT_INFINITYRING",
	"MT_AUTOMATICRING",
	"MT_EXPLOSIONRING",
	"MT_SCATTERRING",
	"MT_GRENADERING",

	"MT_BOUNCEPICKUP",
	"MT_RAILPICKUP",
	"MT_AUTOPICKUP",
	"MT_EXPLODEPICKUP",
	"MT_SCATTERPICKUP",
	"MT_GRENADEPICKUP",

	"MT_THROWNBOUNCE",
	"MT_THROWNINFINITY",
	"MT_THROWNAUTOMATIC",
	"MT_THROWNSCATTER",
	"MT_THROWNEXPLOSION",
	"MT_THROWNGRENADE",

	// Mario-specific stuff
	"MT_COIN",
	"MT_FLINGCOIN",
	"MT_GOOMBA",
	"MT_BLUEGOOMBA",
	"MT_FIREFLOWER",
	"MT_FIREBALL",
	"MT_FIREBALLTRAIL",
	"MT_SHELL",
	"MT_PUMA",
	"MT_PUMATRAIL",
	"MT_HAMMER",
	"MT_KOOPA",
	"MT_KOOPAFLAME",
	"MT_AXE",
	"MT_MARIOBUSH1",
	"MT_MARIOBUSH2",
	"MT_TOAD",

	// NiGHTS Stuff
	"MT_AXIS",
	"MT_AXISTRANSFER",
	"MT_AXISTRANSFERLINE",
	"MT_NIGHTSDRONE",
	"MT_NIGHTSDRONE_MAN",
	"MT_NIGHTSDRONE_SPARKLING",
	"MT_NIGHTSDRONE_GOAL",
	"MT_NIGHTSPARKLE",
	"MT_NIGHTSLOOPHELPER",
	"MT_NIGHTSBUMPER", // NiGHTS Bumper
	"MT_HOOP",
	"MT_HOOPCOLLIDE", // Collision detection for NiGHTS hoops
	"MT_HOOPCENTER", // Center of a hoop
	"MT_NIGHTSCORE",
	"MT_NIGHTSCHIP", // NiGHTS Chip
	"MT_FLINGNIGHTSCHIP", // Lost NiGHTS Chip
	"MT_NIGHTSSTAR", // NiGHTS Star
	"MT_FLINGNIGHTSSTAR", // Lost NiGHTS Star
	"MT_NIGHTSSUPERLOOP",
	"MT_NIGHTSDRILLREFILL",
	"MT_NIGHTSHELPER",
	"MT_NIGHTSEXTRATIME",
	"MT_NIGHTSLINKFREEZE",
	"MT_EGGCAPSULE",
	"MT_IDEYAANCHOR",
	"MT_NIGHTOPIANHELPER", // the actual helper object that orbits you
	"MT_PIAN", // decorative singing friend
	"MT_SHLEEP", // almost-decorative sleeping enemy

	// Secret badniks and hazards, shhhh
	"MT_PENGUINATOR",
	"MT_POPHAT",
	"MT_POPSHOT",
	"MT_POPSHOT_TRAIL",

	"MT_HIVEELEMENTAL",
	"MT_BUMBLEBORE",

	"MT_BUGGLE",

	"MT_SMASHINGSPIKEBALL",
	"MT_CACOLANTERN",
	"MT_CACOSHARD",
	"MT_CACOFIRE",
	"MT_SPINBOBERT",
	"MT_SPINBOBERT_FIRE1",
	"MT_SPINBOBERT_FIRE2",
	"MT_HANGSTER",

	// Utility Objects
	"MT_TELEPORTMAN",
	"MT_ALTVIEWMAN",
	"MT_CRUMBLEOBJ", // Sound generator for crumbling platform
	"MT_TUBEWAYPOINT",
	"MT_PUSH",
	"MT_GHOST",
	"MT_OVERLAY",
	"MT_ANGLEMAN",
	"MT_POLYANCHOR",
	"MT_POLYSPAWN",

	// Skybox objects
	"MT_SKYBOX",

	// Debris
	"MT_SPARK", //spark
	"MT_EXPLODE", // Robot Explosion
	"MT_UWEXPLODE", // Underwater Explosion
	"MT_DUST",
	"MT_ROCKSPAWNER",
	"MT_FALLINGROCK",
	"MT_ROCKCRUMBLE1",
	"MT_ROCKCRUMBLE2",
	"MT_ROCKCRUMBLE3",
	"MT_ROCKCRUMBLE4",
	"MT_ROCKCRUMBLE5",
	"MT_ROCKCRUMBLE6",
	"MT_ROCKCRUMBLE7",
	"MT_ROCKCRUMBLE8",
	"MT_ROCKCRUMBLE9",
	"MT_ROCKCRUMBLE10",
	"MT_ROCKCRUMBLE11",
	"MT_ROCKCRUMBLE12",
	"MT_ROCKCRUMBLE13",
	"MT_ROCKCRUMBLE14",
	"MT_ROCKCRUMBLE15",
	"MT_ROCKCRUMBLE16",

	// Level debris
	"MT_GFZDEBRIS",
	"MT_BRICKDEBRIS",
	"MT_WOODDEBRIS",
	"MT_REDBRICKDEBRIS",
	"MT_BLUEBRICKDEBRIS",
	"MT_YELLOWBRICKDEBRIS",

	"MT_NAMECHECK",
	"MT_RAY",
};

local NUMOBJTYPES = 1163;
assert(#mobjinfo == NUMOBJTYPES, "This script needs updated. ("..#mobjinfo.." != "..NUMOBJTYPES..")");

local MTFREESLOTS = 0;
local ActualFreeslot = freeslot;

local function StoreNamesFreeslot(...)
	local table = {...};
	for i = 1,#table
		local item = table[i];
		if (item == nil)
			return;
		end

		local prefix = "MT_";
		if (string.sub(item, 1, #prefix) == prefix)
			local firstFreeslot = MT_RAY + 1;
			local mt = firstFreeslot + MTFREESLOTS;
			MTNAMES[mt] = item;
			MTFREESLOTS = $1 + 1;
		end

		ActualFreeslot(item);
	end
end

rawset(_G, "freeslot", StoreNamesFreeslot);

local function GetMTName(i)
	if (MTNAMES[i])
		return MTNAMES[i];
	end

	return tostring(i); -- The best we could do.
end

local function DoomEdTool(player, arg)
	local function printf(str)
		CONS_Printf(player, str);
	end

	local numErrors = 0;
	local usedNums = {};

	for i = 0,#mobjinfo-1
		local doomednum = mobjinfo[i].doomednum;
		if (doomednum == -1)
			-- Not in editor
			continue;
		end

		local name = GetMTName(i);
		if (doomednum > 35 and doomednum < 4096)
			if (usedNums[doomednum] != nil)
				printf(" - Mobj type '"..name.."' shares DoomEdNum ["..doomednum.."] with type '"..usedNums[doomednum].."'.");
				numErrors = $1 + 1;
			end

			usedNums[doomednum] = name;
		else
			printf(" - Mobj type '"..name.."' has bad DoomEdNum ["..doomednum.."].");
			numErrors = $1 + 1;
		end
	end

	if (numErrors > 0)
		printf(" == "..numErrors.." DoomEdNum warnings found. ==");
	else
		printf(" == No DoomEdNum warnings found! ==");
	end
end

COM_AddCommand("doomedtool", DoomEdTool);

local function DoomEdRange(player, filterSize)
	local function printf(str)
		CONS_Printf(player, str);
	end

	printf(" == Analyzing free DoomEdNum ranges . . . ==");

	filterSize = tonumber(filterSize);
	if (filterSize == nil)
		filterSize = 10;
		printf(" == Filtering to size of "..filterSize.." by default. ==");
	elseif (filterSize > 0)
		printf(" == Filtering to size of "..filterSize..". ==");
	end

	local usedNums = {};
	for i = 0,#mobjinfo-1
		local doomednum = mobjinfo[i].doomednum;
		if (doomednum == -1)
			-- Not in editor
			continue;
		end

		if (doomednum > 35 and doomednum < 4096)
			usedNums[doomednum] = true;
		end
	end

	local ranges = {};
	local r = 1;

	for i = 36,4095 do
		if (usedNums[i] == true)
			if (ranges[r] != nil)
				-- Range ended, start a new one.
				r = $1 + 1;
			end

			continue;
		end

		if (ranges[r] == nil)
			ranges[r] = {
				start = i,
				size = 0,
			};
		end

		ranges[r].size = $1 + 1;
	end

	local numRanges = 0;
	for i = 1,r do
		local range = ranges[i];

		if (filterSize > 0) and (range.size < filterSize)
			-- Too small for our liking.
			continue;
		end

		local rEnd = range.start + range.size-1;
		printf(" - Range ( "..range.start.." - "..rEnd.." ) is free.");
		numRanges = $1 + 1;
	end

	if (numRanges == 0)
		if (filterSize <= 0)
			printf(" == You literally ran out of DoomEdNums. This is bad. ==");
		else
			printf(" == No DoomEdNum ranges under the specified size. ==");
		end
	else
		printf(" == Found "..numRanges.." free DoomEdNum ranges. ==");
	end
end

COM_AddCommand("doomedrange", DoomEdRange);
