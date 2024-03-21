modmaps.skininfo = {
sonic = {
	spd = 5 * FRACUNIT,
	run = 3 * FRACUNIT,
	acc = FRACUNIT / 4,
	mindash = 2 * FRACUNIT,
	maxdash = 6 * FRACUNIT,
	thok = 5 * FRACUNIT,

	anim = {
		stand    = {spd =  9, sprite2 = SPR2_STND, frames = 1},
		walk     = {spd = 16, sprite2 = SPR2_WALK, frames = 8},
		run      = {spd =  1, sprite2 = SPR2_RUN_, frames = 4},
		roll     = {spd =  1, sprite2 = SPR2_ROLL, frames = 6},
		spindash = {spd =  2, sprite2 = SPR2_SPIN, frames = 4},
		spring   = {spd =  9, sprite2 = SPR2_SPNG, frames = 1},
		fall     = {spd =  2, sprite2 = SPR2_FALL, frames = 2},
		carry    = {spd =  9, sprite2 = SPR2_RIDE, frames = 1},
		pain     = {spd =  9, sprite2 = SPR2_PAIN, frames = 1},
		die      = {spd =  9, sprite2 = SPR2_DEAD, frames = 1},
	}
},
tails = {
	spd = 5 * FRACUNIT,
	run = 3 * FRACUNIT,
	acc = FRACUNIT / 4,
	mindash = 2 * FRACUNIT,
	maxdash = 5 * FRACUNIT,
	fly = 8 * TICRATE,

	anim = {
		stand    = {spd =  9, sprite2 = SPR2_STND, frames = 1},
		walk     = {spd = 16, sprite2 = SPR2_WALK, frames = 8},
		run      = {spd =  1, sprite2 = SPR2_RUN_, frames = 2},
		roll     = {spd =  1, sprite2 = SPR2_ROLL, frames = 3},
		spindash = {spd =  2, sprite2 = SPR2_SPIN, frames = 3},
		spring   = {spd =  9, sprite2 = SPR2_SPNG, frames = 1},
		fall     = {spd =  2, sprite2 = SPR2_FALL, frames = 2},
		carry    = {spd =  9, sprite2 = SPR2_RIDE, frames = 1},
		pain     = {spd =  9, sprite2 = SPR2_PAIN, frames = 1},
		die      = {spd =  9, sprite2 = SPR2_DEAD, frames = 1},
		fly      = {spd =  2, sprite2 = SPR2_FLY_, frames = 2},
		tired    = {spd =  6, sprite2 = SPR2_TIRE, frames = 2},
	}
},
knuckles = {
	spd = 5 * FRACUNIT,
	run = 3 * FRACUNIT,
	acc = FRACUNIT / 4,
	mindash = 2 * FRACUNIT,
	maxdash = 6 * FRACUNIT,
	glideandclimb = true,

	anim = {
		stand         = {spd =  9, sprite2 = SPR2_STND, frames = 1},
		walk          = {spd = 16, sprite2 = SPR2_WALK, frames = 8},
		run           = {spd =  1, sprite2 = SPR2_RUN_, frames = 4},
		roll          = {spd =  1, sprite2 = SPR2_ROLL, frames = 5},
		spindash      = {spd =  2, sprite2 = SPR2_SPIN, frames = 4},
		spring        = {spd =  9, sprite2 = SPR2_SPNG, frames = 1},
		fall          = {spd =  2, sprite2 = SPR2_FALL, frames = 2},
		carry         = {spd =  9, sprite2 = SPR2_RIDE, frames = 1},
		pain          = {spd =  9, sprite2 = SPR2_PAIN, frames = 1},
		die           = {spd =  9, sprite2 = SPR2_DEAD, frames = 1},
		glide         = {spd =  2, sprite2 = SPR2_GLID, frames = 2},
		climb         = {spd =  5, sprite2 = SPR2_CLMB, frames = 4},
		climbstatic   = {spd =  9, sprite2 = SPR2_CLNG, frames = 1},
	}
},
amy = {
	spd = 5 * FRACUNIT,
	run = 3 * FRACUNIT,
	acc = FRACUNIT / 4,
	mindash = 2 * FRACUNIT,
	maxdash = 6 * FRACUNIT,
	doublejump = true,

	anim = {
		stand    = {spd =  9, sprite2 = SPR2_STND, frames = 1},
		walk     = {spd = 16, sprite2 = SPR2_WALK, frames = 8},
		run      = {spd =  1, sprite2 = SPR2_RUN_, frames = 8},
		roll     = {spd =  1, sprite2 = SPR2_ROLL, frames = 4},
		spindash = {spd =  1, sprite2 = SPR2_ROLL, frames = 4},
		spring   = {spd =  9, sprite2 = SPR2_SPNG, frames = 1},
		fall     = {spd =  2, sprite2 = SPR2_FALL, frames = 2},
		carry    = {spd =  9, sprite2 = SPR2_RIDE, frames = 1},
		pain     = {spd =  9, sprite2 = SPR2_PAIN, frames = 1},
		die      = {spd =  9, sprite2 = SPR2_DEAD, frames = 1},
	}
},
fang = {
	spd = 5 * FRACUNIT,
	run = 3 * FRACUNIT,
	acc = FRACUNIT / 4,
	mindash = 2 * FRACUNIT,
	maxdash = 6 * FRACUNIT,
	bounce = true,

	anim = {
		stand    = {spd =  9, sprite2 = SPR2_STND, frames = 1},
		walk     = {spd = 16, sprite2 = SPR2_WALK, frames = 8},
		run      = {spd =  1, sprite2 = SPR2_RUN_, frames = 6},
		roll     = {spd =  1, sprite2 = SPR2_ROLL, frames = 4},
		spindash = {spd =  1, sprite2 = SPR2_ROLL, frames = 4},
		spring   = {spd =  9, sprite2 = SPR2_SPNG, frames = 1},
		fall     = {spd =  2, sprite2 = SPR2_FALL, frames = 2},
		carry    = {spd =  9, sprite2 = SPR2_RIDE, frames = 1},
		pain     = {spd =  9, sprite2 = SPR2_PAIN, frames = 1},
		die      = {spd =  9, sprite2 = SPR2_DEAD, frames = 1},
		bouncemode = {spd =  9, sprite2 = SPR2_BNCE, frames = 1},
		bounce   = {spd =  2, sprite2 = SPR2_LAND, frames = 3},
		shoot    = {spd =  2, sprite2 = SPR2_FIRE, frames = 4},
	}
},
metalsonic = {
	spd = 8 * FRACUNIT,
	run = 4 * FRACUNIT,
	acc = FRACUNIT / 5,
	mindash = 2 * FRACUNIT,
	maxdash = 6 * FRACUNIT,
	thok = 3 * FRACUNIT,

	anim = {
		stand    = {spd =  9, sprite2 = SPR2_STND, frames = 1},
		walk     = {spd = 16, sprite2 = SPR2_WALK, frames = 1},
		run      = {spd =  1, sprite2 = SPR2_RUN_, frames = 1},
		roll     = {spd =  1, sprite2 = SPR2_ROLL, frames = 6},
		spindash = {spd =  2, sprite2 = SPR2_SPIN, frames = 4},
		spring   = {spd =  9, sprite2 = SPR2_SPNG, frames = 1},
		fall     = {spd =  2, sprite2 = SPR2_FALL, frames = 1},
		carry    = {spd =  9, sprite2 = SPR2_RIDE, frames = 1},
		pain     = {spd =  9, sprite2 = SPR2_PAIN, frames = 1},
		die      = {spd =  9, sprite2 = SPR2_DEAD, frames = 1},
	}
},
}


modmaps.objectproperties = {
// Player
{
	w = 6 * FRACUNIT, h = 10 * FRACUNIT,
	pityshieldanim = {spd = 2,"PITYA0","PITYB0L0","PITYC0K0","PITYD0J0","PITYE0I0","PITYF0H0","PITYG0","PITYF0H0","PITYE0I0","PITYD0J0","PITYC0K0","PITYB0L0"},
	strongforceshieldanim = {spd = 3,"FORCA0","FORCB0","FORCC0","FORCD0","FORCE0","FORCF0","FORCG0","FORCH0","FORCI0","FORCJ0"},
	weakforceshieldanim = {spd = 3,"FORCK0","FORCL0","FORCM0","FORCN0","FORCO0","FORCP0","FORCQ0","FORCR0","FORCS0","FORCT0"},
	windshieldanim = {spd = 3,"WINDA0","WINDB0","WINDC0","WINDD0","WINDE0","WINDF0","WINDG0","WINDH0"},
},
// Spilled ring
{
	w = 4 * FRACUNIT, h = 4 * FRACUNIT,
	scale = FRACUNIT * 3 / 16,
	anim = {spd = 1,"RINGA0","RINGB0X0","RINGC0W0","RINGD0V0","RINGE0U0","RINGF0T0","RINGG0S0","RINGH0R0","RINGI0Q0","RINGJ0P0","RINGK0O0","RINGL0N0","RINGM0","RINGL0N0","RINGK0O0","RINGJ0P0","RINGI0Q0","RINGH0R0","RINGG0S0","RINGF0T0","RINGE0U0","RINGD0V0","RINGC0W0","RINGB0X0"}
},
// Blue Crawla
{
	w = 8 * FRACUNIT, h = 8 * FRACUNIT,
	anim = {spd = 3,"POSSB3B7","POSSC3C7","POSSD3D7","POSSE3E7","POSSF3F7"}
},
// Red Crawla
{
	w = 8 * FRACUNIT, h = 8 * FRACUNIT,
	anim = {spd = 3,"SPOSB3B7","SPOSC3C7","SPOSD3D7","SPOSE3E7","SPOSF3F7"}
},
// SDURF
{
	w = 6 * FRACUNIT, h = 6 * FRACUNIT,
	scale = FRACUNIT / 6,
	anim = {
		{spd = 9,"FISHB0"}, // Jumping
		{spd = 9,"FISHA0"} // Falling
	}
},
// Green Spring Shell
{
	w = 8 * FRACUNIT, h = 8 * FRACUNIT,
	anim = {
		{spd = 4,"SSHLB3B7","SSHLC3C7","SSHLD3D7","SSHLA3A7","SSHLB3B7","SSHLC3C7","SSHLD3D7"},
		{spd = 1,"SSHLH3H7","SSHLH3H7","SSHLH3H7","SSHLH3H7","SSHLG3G7","SSHLF3F7","SSHLE3E7","SSHLA3A7","SSHLA3A7","SSHLA3A7","SSHLA3A7","SSHLA3A7","SSHLA3A7","SSHLA3A7","SSHLA3A7","SSHLA3A7","SSHLA3A7","SSHLA3A7","SSHLA3A7","SSHLA3A7","SSHLA3A7","SSHLA3A7","SSHLA3A7"}
	}
},
// Yellow Spring Shell
{
	w = 8 * FRACUNIT, h = 8 * FRACUNIT,
	anim = {
		{spd = 4,"SSHLJ3J7","SSHLK3K7","SSHLL3L7","SSHLI3I7","SSHLJ3J7","SSHLK3K7","SSHLL3L7"},
		{spd = 1,"SSHLP3P7","SSHLP3P7","SSHLP3P7","SSHLP3P7","SSHLO3O7","SSHLN3N7","SSHLM3M7","SSHLI3I7","SSHLI3I7","SSHLI3I7","SSHLI3I7","SSHLI3I7","SSHLI3I7","SSHLI3I7","SSHLI3I7","SSHLI3I7","SSHLI3I7","SSHLI3I7","SSHLI3I7","SSHLI3I7","SSHLI3I7","SSHLI3I7","SSHLI3I7"}
	}
},
// Gold Buzz
{
	w = 6 * FRACUNIT, h = 6 * FRACUNIT,
	scale = FRACUNIT / 8,
	anim = {spd = 2,"BUZZA3A7","BUZZB3B7"}
},
// Red Buzz
{
	w = 6 * FRACUNIT, h = 6 * FRACUNIT,
	scale = FRACUNIT / 8,
	anim = {spd = 2,"RBUZA3A7","RBUZB3B7"}
},
// Green Snapper
{
	w = 8 * FRACUNIT, h = 8 * FRACUNIT,
	scale = FRACUNIT / 8,
	anim = {spd = 8,"GSNPA3A7"}
	--anim = {spd = 8,"GSNPA3A7","GSNPB3B7","GSNPC3C7","GSNPD3D7"}
},
// Sharp
{
	w = 8 * FRACUNIT, h = 8 * FRACUNIT,
	scale = FRACUNIT / 4,
	anim = {
		{spd = 1,"SHRPB3B7","SHRPC3C7","SHRPD3D7","SHRPA3A7"}
	}
},
// Thok
{
	w = 8 * FRACUNIT, h = 8 * FRACUNIT,
	anim = {spd = 9,"THOKA0"}
},
}


modmaps.backgrounds = {
{
	name = "Greenflower",
	pic = "MAPS_SKY1",
	color = 232
},
{
	name = "Techno Hill 1",
	pic = "SKY3",
	color = 89
},
{
	name = "Techno Hill 2",
	pic = "SKY5",
	color = 232
},
{
	name = "Techno Hill 3",
	pic = "SKY6",
	color = 241
},
{
	name = "Cave",
	pic = "SKY7",
	color = 27
},
{
	name = "Castle Eggman",
	pic = "MAPS_SKY10",
	color = 22
},
{
	name = "Stormy sky",
	pic = "SKY20",
	color = 22
},
{
	name = "Arid Canyon",
	pic = "ACZSKY",
	color = 212
},
{
	name = "Snow hills",
	pic = "SKY30",
	color = 243
},
{
	name = "Mountains",
	pic = "SKY29",
	color = 225
},
{
	name = "Evening mountains",
	pic = "SKY127",
	color = 66
},
{
	name = "Valley",
	pic = "SKY40",
	color = 215
},
{
	name = "Stars",
	pic = "SKY117",
	color = 243
},
{
	name = "Blue stars",
	pic = "SKY9",
	color = 31
},
{
	name = "Mario",
	pic = "SKY31",
	color = 232
},
{
	name = "Blue",
	pic = "SKY35",
	color = 238
},
{
	name = "Nature",
	pic = "SKY19",
	color = 204
},
{
	name = "Planets",
	pic = "SKY59",
	color = 127
},
{
	name = "Forest",
	pic = "SKY64",
	color = 175
},
{
	name = "Forest 2",
	pic = "SKY103",
	color = 168
},
{
	name = "Jungle",
	type = "tiled",
	scale = FRACUNIT / 16,
	pic = "SFZLEAFW",
},
{
	name = "Dark blue",
	pic = "SKY66",
	color = 242
},
{
	name = "Icy cave",
	pic = "SKY107",
	color = 238
},
{
	name = "Water cave",
	pic = "SKY132",
	color = 237
},
{
	name = "Bright Stars",
	pic = "SKY98",
	color = 31
},
{
	name = "Bright Stars 2",
	pic = "SKY99",
	color = 31
},
{
	name = "Crystals",
	pic = "SKY58",
	color = 84
},
{
	name = "Special stage 1",
	pic = "SKY50",
	color = 173
},
{
	name = "Special stage 2",
	pic = "SKY51",
	color = 63
},
{
	name = "Special stage 3",
	pic = "SKY52",
	color = 255
},
{
	name = "Special stage 4",
	pic = "SKY53",
	color = 207
},
{
	name = "Special stage 5",
	pic = "SKY54",
	color = 139
},
{
	name = "Special stage 6",
	pic = "SKY55",
	color = 203
},
{
	name = "Special stage 7",
	pic = "SKY56",
	color = 26
},
{
	name = "Special stage 8",
	pic = "SKY57",
	color = 16
},
}