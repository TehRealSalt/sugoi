//HERE'S A GOOD PROTIP
//SHE EXECUTES LINEDEF 1000
//1000 IS FOR REMOVING THE BARRIER IN FRONT OF HER
//WHY AM I SCREAMING

//todo: the other attacks
//pinch mode banter *fire emoji*
//death  "screen-clear"
//some other stuff i dunno

freeslot(
	"MT_PURPLEHEART",
	"MT_32BITMEGABLADE",
	"MT_NEPBLADE",
	"MT_FAKENEPBLADE",
	"MT_SHINECUBE",
	"MT_DEBRIS",
	"MT_PURPLEBALL",
	"MT_PURPLEBALLGRAVITY",
	"MT_FAKEPURPLEHEART",
	"MT_SWORDFRENZY",
	"MT_LASERFRENZY",
	"MT_LASERFRENZYSET",
	"MT_PURPLELASER",
	"MT_DIASLASH",
	"MT_HORISLASH",
	"S_PURPLEHEART_ENTRY1",
	"S_PURPLEHEART_ENTRY2",
	"S_PURPLEHEART_ENTRY3",
	"S_PURPLEHEART_ENTRY4",
	"S_PURPLEHEART_ENTRY5",
	"S_PURPLEHEART_ROAM1",
	"S_PURPLEHEART_ROAM2",
	"S_PURPLEHEART_ROAM3",
	"S_PURPLEHEART_ROAM4",
	"S_PURPLEHEART_ROAM5",
	"S_PURPLEHEART_ROAM6",
	"S_PURPLEHEART_32BIT1",
	"S_PURPLEHEART_32BIT2",
	"S_PURPLEHEART_32BIT3",
	"S_PURPLEHEART_32BIT4",
	"S_PURPLEHEART_32BIT5",
	"S_PURPLEHEART_DELTA1",
	"S_PURPLEHEART_DELTA2",
	"S_PURPLEHEART_DELTA3",
	"S_PURPLEHEART_DELTA4",
	"S_PURPLEHEART_DELTA5",
	"S_PURPLEHEART_CROSS1",
	"S_PURPLEHEART_CROSS2",
	"S_PURPLEHEART_CROSS3",
	"S_PURPLEHEART_CROSS4",
	"S_PURPLEHEART_CROSS5",
	"S_PURPLEHEART_CROSS6",
	"S_PURPLEHEART_CROSS7",
	"S_PURPLEHEART_CROSS8",
	"S_PURPLEHEART_PINCH1",
	"S_PURPLEHEART_PINCH2",
	"S_PURPLEHEART_PINCH3",
	"S_PURPLEHEART_PINCH4",
	"S_PURPLEHEART_PINCH5",
	"S_PURPLEHEART_NEPBREAK1",
	"S_PURPLEHEART_NEPBREAK2",
	"S_PURPLEHEART_NEPBREAK3",
	"S_PURPLEHEART_NEPBREAK4",
	"S_PURPLEHEART_NEPBREAK5",
	"S_PURPLEHEART_NEPBREAK6",
	"S_PURPLEHEART_NEPBREAK7",
	"S_PURPLEHEART_NEPBREAK8",
	"S_PURPLEHEART_STAND",
	"S_PURPLEHEART_FIRE",
	"S_PURPLEHEART_CHARGE",
	"S_PURPLEHEART_HURT",
	"S_PURPLEHEART_KNOCKOUT1",
	"S_PURPLEHEART_KNOCKOUT2",
	"S_PURPLEHEART_KNOCKOUT3",
	"S_32BITMEGABLADE",
	"S_NEPBLADE1",
	"S_NEPBLADE2",
	"S_NEPBLADE3",
	"S_FAKENEPBLADE",
	"S_SHINECUBE",
	"S_DEBRIS1",
	"S_DEBRIS2",
	"S_PURPLEBALL",
	"S_FAKEPURPLEHEART",
	"S_SWORDFRENZY",
	"S_LASERFRENZY",
	"S_LASERFRENZYSET1",
	"S_LASERFRENZYSET2",
	"S_LASERFRENZYSET3",
	"S_PURPLELASER",
	"S_DIASLASH",
	"S_HORISLASH",
	"spr_nepu",
	"spr_nepx",
	"spr_nepf",
	"spr_cros"
)

freeslot(
	"sfx_ph32b",
	"sfx_ph32c",
	"sfx_phatk1",
	"sfx_phatk2",
	"sfx_phatk3",
	"sfx_phatk4",
	"sfx_phbrk1",
	"sfx_phbrk2",
	"sfx_phbrk3",
	"sfx_phbrk4",
	"sfx_phdsa",
	"sfx_phent1",
	"sfx_phent2",
	"sfx_phhrt1",
	"sfx_phhrt2",
	"sfx_phhrt3",
	"sfx_phhrt4",
	"sfx_phkoed",
	"sfx_phpnc",
	"sfx_phdmg",
	"sfx_phslas",
	"sfx_phfocs",
	"sfx_phswo",
	"sfx_phbrst",
	"sfx_phdash",
	"sfx_phcros",
	"sfx_phthud"
)

local wipelist =
{
	MT_FAKEPURPLEHEART,
	MT_PURPLEBALL,
	MT_32BITMEGABLADE,
	MT_SWORDFRENZY,
	MT_LASERFRENZY,
	MT_PURPLELASER,
	MT_SHINECUBE,
	MT_DEBRIS
}

local function tableContains(table, value)
	for _,v in ipairs(table)
		if value == v then
			return true
		end
	end
	return false
end

local function screenWipe()
	for mobj in mobjs.iterate() do
		if (tableContains(wipelist, mobj.type)) then
			P_KillMobj(mobj);
		end
	end
end

local soundlist1 =
{
	sfx_phatk1,
	sfx_phatk2,
	sfx_phatk3,
	sfx_phatk4
}


local soundlist2 =
{
	sfx_ph32b,
	sfx_ph32c
}

local function playRandomSound(list,range)
	local num = P_RandomRange(1,range);
	S_StartSound(nil,list[num]);
end

local function playerCount()
	local count  = 0;
	for p in players.iterate do
		if p.mo and p.mo.health then
			count = $ + 1;
		end
	end
	return count;
end

mobjinfo[MT_PURPLEHEART] = {
--$Name Purple Heart
--$Sprite NEPUA0
--$Category SUGOI Bosses
doomednum = 1555,
spawnstate = S_PURPLEHEART_ENTRY1,
spawnhealth = 16,
seestate = S_PURPLEHEART_ENTRY2,
reactiontime = 70,
deathstate = S_PURPLEHEART_KNOCKOUT1,
deathsound = sfx_phkoed,
speed = 8*FRACUNIT,
radius = 50*FRACUNIT,
height = 150*FRACUNIT,
dispoffset = 0,
mass = 100,
damage = 1,
flags = MF_NOGRAVITY|MF_SPECIAL|MF_ENEMY|MF_BOSS,
raisestate = S_NULL
}

mobjinfo[MT_FAKEPURPLEHEART] = {
doomednum = -1,
spawnstate = S_FAKEPURPLEHEART,
spawnhealth = 1000,
radius = 50*FRACUNIT,
height = 150*FRACUNIT,
dispoffset = -1,
flags = MF_NOGRAVITY
}

mobjinfo[MT_SWORDFRENZY] = {
doomednum = -1,
spawnstate = S_SWORDFRENZY,
spawnhealth = 1000,
radius = 50*FRACUNIT,
height = 150*FRACUNIT,
dispoffset = -1,
flags = MF_NOGRAVITY
}

mobjinfo[MT_LASERFRENZY] = {
doomednum = -1,
spawnstate = S_LASERFRENZY,
spawnhealth = 1000,
radius = 50*FRACUNIT,
height = 150*FRACUNIT,
dispoffset = -1,
flags = MF_NOGRAVITY
}

mobjinfo[MT_LASERFRENZYSET] = {
doomednum = -1,
spawnstate = S_LASERFRENZYSET1,
spawnhealth = 1000,
radius = 50*FRACUNIT,
height = 150*FRACUNIT,
dispoffset = -1,
flags = MF_NOGRAVITY
}

mobjinfo[MT_PURPLELASER] = {
doomednum = -1,
spawnstate = S_PURPLELASER,
spawnhealth = 1000,
seestate = 0,
reactiontime = 70,
deathstate = S_XPLD1,
deathsound = sfx_none,
speed = 24*FRACUNIT,
radius = 50*FRACUNIT,
height = 150*FRACUNIT,
dispoffset = 0,
mass = 100,
damage = 1,
flags = MF_NOGRAVITY|MF_SPECIAL|MF_MISSILE|MF_NOCLIPHEIGHT,
raisestate = S_NULL
}

mobjinfo[MT_PURPLEBALL] = {
doomednum = -1,
spawnstate = S_PURPLEBALL,
spawnhealth = 1000,
seestate = 0,
reactiontime = 70,
deathstate = S_XPLD1,
deathsound = sfx_phthud,
speed = 24*FRACUNIT,
radius = 25*FRACUNIT,
height = 40*FRACUNIT,
dispoffset = 0,
mass = 100,
damage = 1,
flags = MF_NOGRAVITY|MF_SPECIAL|MF_MISSILE,
raisestate = S_NULL
}

mobjinfo[MT_PURPLEBALLGRAVITY] = {
doomednum = -1,
spawnstate = S_PURPLEBALL,
spawnhealth = 1000,
seestate = 0,
reactiontime = 70,
deathstate = S_XPLD1,
deathsound = sfx_phthud,
speed = 24*FRACUNIT,
radius = 25*FRACUNIT,
height = 40*FRACUNIT,
dispoffset = 0,
mass = 100,
damage = 1,
flags = MF_SPECIAL|MF_MISSILE,
raisestate = S_NULL
}

mobjinfo[MT_DEBRIS] = {
doomednum = -1,
spawnstate = S_DEBRIS1,
spawnhealth = 1000,
seestate = 0,
reactiontime = 70,
deathstate = S_XPLD1,
deathsound = sfx_none,
speed = 0,
radius = 7*FRACUNIT,
height = 14*FRACUNIT,
dispoffset = 0,
mass = 100,
damage = 1,
flags = MF_NOGRAVITY|MF_SPECIAL|MF_MISSILE|MF_NOBLOCKMAP,
raisestate = S_NULL
}

mobjinfo[MT_32BITMEGABLADE] = {
doomednum = -1,
spawnstate = S_32BITMEGABLADE,
spawnhealth = 1000,
seestate = 0,
reactiontime = 70,
deathstate = S_XPLD1,
deathsound = sfx_pop,
speed = 24*FRACUNIT,
radius = 25*FRACUNIT,
height = 90*FRACUNIT,
dispoffset = 0,
mass = 100,
damage = 1,
flags = MF_NOGRAVITY|MF_SPECIAL|MF_PAIN,
raisestate = S_NULL
}

mobjinfo[MT_NEPBLADE] = {
doomednum = -1,
spawnstate = S_NEPBLADE1,
spawnhealth = 1000,
seestate = 0,
reactiontime = 70,
deathstate = S_NULL,
deathsound = sfx_none,
speed = 24*FRACUNIT,
radius = 25*FRACUNIT,
height = 120*FRACUNIT,
dispoffset = 0,
mass = 100,
damage = 1,
flags = MF_SPECIAL|MF_PAIN,
raisestate = S_NULL
}

mobjinfo[MT_FAKENEPBLADE] = {
doomednum = -1,
spawnstate = S_FAKENEPBLADE,
spawnhealth = 1000,
seestate = 0,
reactiontime = 70,
deathstate = S_NULL,
deathsound = sfx_none,
speed = 24*FRACUNIT,
radius = 25*FRACUNIT,
height = 120*FRACUNIT,
dispoffset = 0,
mass = 100,
damage = 1,
flags = MF_NOGRAVITY,
raisestate = S_NULL
}

mobjinfo[MT_SHINECUBE] = {
doomednum = -1,
spawnstate = S_SHINECUBE,
spawnhealth = 1000,
radius = 20*FRACUNIT,
height = 20*FRACUNIT,
dispoffset = -1,
flags = MF_NOGRAVITY
}

mobjinfo[MT_DIASLASH] = {
doomednum = -1,
spawnstate = S_DIASLASH,
spawnhealth = 1000,
seestate = 0,
reactiontime = 70,
deathstate = S_NULL,
deathsound = sfx_none,
speed = 4*FRACUNIT,
radius = 20*FRACUNIT,
height = 70*FRACUNIT,
dispoffset = 0,
mass = 100,
damage = 1,
flags = MF_SPECIAL|MF_PAIN|MF_NOGRAVITY,
raisestate = S_NULL
}

mobjinfo[MT_HORISLASH] = {
doomednum = -1,
spawnstate = S_HORISLASH,
spawnhealth = 1000,
seestate = 0,
reactiontime = 70,
deathstate = S_NULL,
deathsound = sfx_none,
speed = 4*FRACUNIT,
radius = 60*FRACUNIT,
height = 20*FRACUNIT,
dispoffset = 0,
mass = 100,
damage = 1,
flags = MF_SPECIAL|MF_PAIN|MF_NOGRAVITY,
raisestate = S_NULL
}

sfxinfo[sfx_ph32b].caption = "/"
sfxinfo[sfx_ph32c].caption = "/"

sfxinfo[sfx_phatk1].caption = "/"
sfxinfo[sfx_phatk2].caption = "/"
sfxinfo[sfx_phatk3].caption = "/"
sfxinfo[sfx_phatk4].caption = "/"

sfxinfo[sfx_phbrk1].caption = "/"
sfxinfo[sfx_phbrk2].caption = "/"
sfxinfo[sfx_phbrk3].caption = "/"
sfxinfo[sfx_phbrk4].caption = "/"

sfxinfo[sfx_phdsa].caption = "/"

sfxinfo[sfx_phent1].caption = "/"
sfxinfo[sfx_phent2].caption = "/"

sfxinfo[sfx_phhrt1].caption = "/"
sfxinfo[sfx_phhrt2].caption = "/"
sfxinfo[sfx_phhrt3].caption = "/"
sfxinfo[sfx_phhrt4].caption = "/"

sfxinfo[sfx_phkoed].caption = "/"
sfxinfo[sfx_phpnc].caption = "/"
sfxinfo[sfx_phdmg].caption = "/"
sfxinfo[sfx_phslas].caption = "/"
sfxinfo[sfx_phfocs].caption = "/"
sfxinfo[sfx_phswo].caption = "/"
sfxinfo[sfx_phbrst].caption = "/"
sfxinfo[sfx_phdash].caption = "/"
sfxinfo[sfx_phcros].caption = "/"
sfxinfo[sfx_phthud].caption = "/"

local boss_list = {}

function A_HealthDraw(actor,var1,var2)
	table.insert(boss_list, actor)
end

function A_GroundCheck(actor,var1,var2)
	if P_IsObjectOnGround(actor)
		actor.state = var1
	else
		return
	end
end

function A_StartQuake(actor,var1, var2)
//var1 = intensity (needs to be a multiple of FRACUNIT)
//var2 = time quake lasts, in tics
P_StartQuake(var1,var2)
//S_StartSound(nil, sfx_bkpoof)
end

states[S_PURPLEHEART_ENTRY1] = {SPR_NEPU,0,1,A_Look,1 + 600 * FRACUNIT,1,S_PURPLEHEART_ENTRY1}
states[S_PURPLEHEART_ENTRY2] = {SPR_NEPU,0|FF_ANIMATE,70,function()
	//S_ChangeMusic(0);
end,2,8, S_PURPLEHEART_ENTRY3}
states[S_PURPLEHEART_ENTRY3] = {SPR_NEPU,0|FF_ANIMATE,250,function(mo)
	if leveltime < 20*TICRATE then //feel free to adjust this, it's a silly gimmick.
		S_StartSound(nil, sfx_phent1);
	else
		S_StartSound(nil, sfx_phent2);
		mo.tics = 300;
	end
end,2,8, S_PURPLEHEART_ENTRY4}
states[S_PURPLEHEART_ENTRY4] = {SPR_NEPU,0,1,A_HealthDraw,nil,nil, S_PURPLEHEART_ENTRY5}
states[S_PURPLEHEART_ENTRY5] = {SPR_NEPU,0,1,function(mo)
	S_ChangeMusic("PHEART");
	P_LinedefExecute(1000);
	mo.bossphase = "ROAM";
end,nil,nil, S_PURPLEHEART_ROAM1}

states[S_PURPLEHEART_STAND] = {SPR_NEPU,0|FF_ANIMATE,-1,nil,2,8,S_PURPLEHEART_STAND}
states[S_PURPLEHEART_FIRE] = {SPR_NEPU,3,1,nil,nil,nil,S_PURPLEHEART_FIRE}
states[S_PURPLEHEART_CHARGE] = {SPR_NEPU,4,1,nil,nil,nil,S_PURPLEHEART_CHARGE}
states[S_PURPLEHEART_HURT] = {SPR_NEPU,5,1,nil,nil,nil,S_PURPLEHEART_HURT}

states[S_PURPLEHEART_ROAM1] = {SPR_NEPU,4,60,function(mo)
	mo.extravalue1 = 0;
	A_FaceTarget(mo,nil,nil);
	A_Thrust(mo,36,1);
	S_StartSound(nil,sfx_phdash);
	mo.flags = $1 & ~(MF_SHOOTABLE|MF_SPECIAL);
	mo.overrideinvuln = true;
end,nil,nil,S_PURPLEHEART_ROAM2}
states[S_PURPLEHEART_ROAM2] = {SPR_NEPU,4,44,function(mo)
	if mo.pinch == 1 then
		mo.tics = 35;
	end
	S_StartSound(nil, sfx_phfocs); //this didn't work with just A_PlaySound ;-;
end,nil,nil,S_PURPLEHEART_ROAM3}
states[S_PURPLEHEART_ROAM3] = {SPR_NEPU,3,10,function(mo)
	if (mo.pinch == 1) then
		mo.tics = 5;
	end
	A_FaceTarget(mo,nil,nil);
	S_StartSound(nil,sfx_phbrst);
	mo.overrideinvuln = false;
	mo.flags = $1 | MF_SPECIAL
	for player in players.iterate do
		if player.mo and (player.mo.valid and player.mo.health) then
			P_SpawnXYZMissile(mo, player.mo, MT_PURPLEBALL, mo.x,mo.y,mo.z + 100*FRACUNIT);
		end
	end
end,nil,nil,S_PURPLEHEART_ROAM4}
states[S_PURPLEHEART_ROAM4] = {SPR_NEPU,3,1,A_Repeat,6,S_PURPLEHEART_ROAM3,S_PURPLEHEART_ROAM5}
states[S_PURPLEHEART_ROAM5] = {SPR_NEPU,3,1,function(mo)
	if (mo.extravalue1 == 0 and mo.pinch == 1) then
		A_MultiShot(mo,10 + MT_PURPLEBALLGRAVITY*FRACUNIT, -20*FRACUNIT)
		mo.state = S_PURPLEHEART_ROAM2
		mo.flags = $1 & ~(MF_SHOOTABLE|MF_SPECIAL);
		mo.overrideinvuln = true;
		mo.extravalue1 = 1;
	end
end,nil,nil,S_PURPLEHEART_ROAM6}
states[S_PURPLEHEART_ROAM6] = {SPR_NEPU,0,30,nil,nil,nil,S_PURPLEHEART_ROAM1}

states[S_PURPLEHEART_32BIT1] = {SPR_NEPU,4,17,A_ZThrust,16,nil,S_PURPLEHEART_32BIT2}
states[S_PURPLEHEART_32BIT2] = {SPR_NEPU,4,75,function(mo)
		playRandomSound(soundlist2,2);
end,nil,nil,S_PURPLEHEART_32BIT3}
states[S_PURPLEHEART_32BIT3] = {SPR_NEPU,2,17,function(mo)
	local bladerain = P_SpawnMobj(mo.x,mo.y,mo.z, MT_SWORDFRENZY);
	bladerain.target = mo;
end,nil,nil,S_PURPLEHEART_32BIT4}
states[S_PURPLEHEART_32BIT4] = {SPR_NEPU,4,17,A_ZThrust,-16,nil,S_PURPLEHEART_32BIT5}
states[S_PURPLEHEART_32BIT5] = {SPR_NEPU,0|FF_ANIMATE,17,nil,2,8,S_PURPLEHEART_32BIT5}

states[S_PURPLEHEART_DELTA1] = {SPR_NEPU,2,45,function(mo)
	S_StartSound(nil,sfx_phdsa);
end,nil,nil,S_PURPLEHEART_DELTA2}
states[S_PURPLEHEART_DELTA2] = {SPR_NEPU,3,15,function(mo,var1,var2)
	if mo.pinch == 1 then
		mo.tics = 7;
	end
	A_FindTarget(mo,MT_PLAYER,1);
	A_FaceTarget(mo,0,0);
	playRandomSound(soundlist1,4);
	mo.flags = $1 & ~(MF_SHOOTABLE|MF_SPECIAL);
	mo.overrideinvuln = true;
end,nil,nil,S_PURPLEHEART_DELTA3}
states[S_PURPLEHEART_DELTA3] = {SPR_NEPU,3,30,function(mo)
	if mo.pinch == 1 then
		mo.tics = 15;
		A_Thrust(mo,72,1);
	else
		A_Thrust(mo,64,1);
	end
	S_StartSound(nil,sfx_phdash);
	mo.overrideinvuln = false;
	mo.flags = $1 | MF_SPECIAL
end,nil,nil,S_PURPLEHEART_DELTA4}
states[S_PURPLEHEART_DELTA4] = {SPR_NEPU,3,1,A_Repeat,6,S_PURPLEHEART_DELTA2,S_PURPLEHEART_DELTA5}
states[S_PURPLEHEART_DELTA5] = {SPR_NEPU,0,35,nil,nil,nil,S_PURPLEHEART_DELTA2}


states[S_PURPLEHEART_CROSS1] = {SPR_NEPU,4,17,nil,nil,nil,S_PURPLEHEART_CROSS2}
states[S_PURPLEHEART_CROSS2] = {SPR_NEPU,6,60,function(mo)
	S_StartSound(nil, sfx_phcros);
end,nil,nil,S_PURPLEHEART_CROSS3}
states[S_PURPLEHEART_CROSS3] = {SPR_NEPU,6,50,function(mo)
	A_FindTarget(mo,MT_PLAYER,1);
	A_FaceTarget(mo,nil,nil);
	S_StartSound(nil,sfx_phbrst);
	A_Thrust(mo,72,1);
	mo.overrideinvuln = true;
	mo.flags = $1 & ~(MF_SPECIAL|MF_SHOOTABLE);
end,nil,nil,S_PURPLEHEART_CROSS4}
states[S_PURPLEHEART_CROSS4] = {SPR_NEPU,4,12,function(mo)
	A_FaceTarget(mo,nil,nil);
	S_StartSound(nil, sfx_phslas);
	P_StartQuake(10*FRACUNIT, 7);
	P_SpawnMobj(mo.x + 50 * cos(mo.angle),mo.y + 50 * sin(mo.angle) ,mo.z - 40*FRACUNIT,MT_DIASLASH)
	local missile = P_SpawnMobj(mo.x ,mo.y,mo.z,MT_PURPLEBALLGRAVITY)
	missile.target = mo;
	if mo.pinch == 1 then
		A_NapalmScatter(mo, MT_PURPLEBALLGRAVITY + 8 * FRACUNIT, 300 + 16*FRACUNIT);
	end
	A_Thrust(mo,30,1);
end,nil,nil,S_PURPLEHEART_CROSS5}
states[S_PURPLEHEART_CROSS5] = {SPR_NEPU,3,1,A_Repeat,8,S_PURPLEHEART_CROSS4,S_PURPLEHEART_CROSS6}
states[S_PURPLEHEART_CROSS6] = {SPR_NEPU,6,50,function(mo)
	S_StartSound(nil, sfx_phfocs);
end,nil,nil,S_PURPLEHEART_CROSS7}
states[S_PURPLEHEART_CROSS7] = {SPR_NEPU,6,50,function(mo)
	if mo.pinch == 1 then
		A_MultiShot(mo,10 + MT_PURPLEBALLGRAVITY*FRACUNIT, -40*FRACUNIT)
	end
	for i = 1, 10 do
		local newangle = mo.angle + ANG1 * i * 36
		local slash = P_SpawnMobj(mo.x + 180* sin(newangle), mo.y + 180 * cos(newangle), mo.z - 60*FRACUNIT, MT_HORISLASH)
		slash.target = mo;
	end
	mo.overrideinvuln = false;
	mo.flags = $1 | MF_SPECIAL
	S_StartSound(nil, sfx_phslas);
end,nil,nil,S_PURPLEHEART_CROSS8}
states[S_PURPLEHEART_CROSS8] = {SPR_NEPU,0|FF_ANIMATE,35,nil,2,4,S_PURPLEHEART_CROSS8}

states[S_PURPLEHEART_PINCH1] = {SPR_NEPU,5,65,function(mo)
	A_Thrust(mo,-40,1);
	mo.flags = $1 & ~(MF_SHOOTABLE|MF_SPECIAL);
	mo.overrideinvuln = true;
end,0,0,S_PURPLEHEART_PINCH2}
states[S_PURPLEHEART_PINCH2] = {SPR_NEPU,2,110,function(mo)
	S_StartSound(nil,sfx_phpnc);
	S_ChangeMusic("NBREAK");
end,nil,nil,S_PURPLEHEART_PINCH3}
states[S_PURPLEHEART_PINCH3] = {SPR_NEPU,4,90,function(mo)
	S_StartSound(nil,sfx_phbrk1);
end,nil,nil,S_PURPLEHEART_PINCH4}
states[S_PURPLEHEART_PINCH4] = {SPR_NEPU,2,40,function(mo)
	for p in players.iterate do
		P_FlashPal(p,1,15);
	end
	P_StartQuake(15*FRACUNIT, 35);
end,nil,nil,S_PURPLEHEART_NEPBREAK1}

states[S_PURPLEHEART_NEPBREAK1] = {SPR_NEPU,4,10,function(mo)
	A_FindTarget(mo,MT_PLAYER,1);
	A_FaceTarget(mo,0,0);
end,nil,nil,S_PURPLEHEART_NEPBREAK2}
states[S_PURPLEHEART_NEPBREAK2] = {SPR_NEPU,4,1,function(mo)
	S_StartSound(nil, sfx_phdash);
end,nil,nil,S_PURPLEHEART_NEPBREAK3}

states[S_PURPLEHEART_NEPBREAK3] = {SPR_NEPU,6,3,function(mo)
	A_Thrust(mo,48,1);
		for i = -1, 1 do
			local offsetx = cos(mo.angle + (ANG30 * i))
			local offsety = sin(mo.angle + (ANG30 * i))
			local deb = P_SpawnMobj(mo.x - 80 * offsetx,mo.y  - 80 * offsety,mo.z+40*FRACUNIT, MT_DEBRIS)
			deb.target = mo;
			deb.momx = FixedMul(offsetx,mo.momx / 8)
			deb.momy = FixedMul(offsety,mo.momy / 8)
	end
	if not P_TryMove(mo,mo.x + mo.momx, mo.y + mo.momy) then
		A_NapalmScatter(mo, MT_PURPLEBALLGRAVITY + 16 * FRACUNIT, 400 + 35*FRACUNIT);
		A_NapalmScatter(mo, MT_PURPLEBALLGRAVITY + 16 * FRACUNIT, 420 + 35*FRACUNIT);
		P_StartQuake(15*FRACUNIT, 35);
		S_StartSound(nil,sfx_phslas);
		mo.extravalue2 = $ + 1;
		if mo.extravalue2 >= 15 then
			mo.state = S_PURPLEHEART_NEPBREAK4;
			mo.extravalue2 = 0;
		else
			mo.state = S_PURPLEHEART_NEPBREAK1;
		end
	end
end,nil,nil,S_PURPLEHEART_NEPBREAK3}

states[S_PURPLEHEART_NEPBREAK4] = {SPR_NEPU,4,70,A_ZThrust,35,nil,S_PURPLEHEART_NEPBREAK5}
states[S_PURPLEHEART_NEPBREAK5] = {SPR_NEPU,4,450,function(mo)
	S_StartSound(nil,sfx_phbrk4);
	local meme = P_SpawnMobj(mo.x,mo.y,mo.z + 200*FRACUNIT, MT_LASERFRENZY);
	P_StartQuake(10*FRACUNIT, 450);
end,35,nil,S_PURPLEHEART_NEPBREAK6}
states[S_PURPLEHEART_NEPBREAK6] = {SPR_NEPU,4,50,function(mo)
	S_StartSound(nil,sfx_phbrk2);
	A_FindTarget(mo,MT_PLAYER,1);
	A_FaceTarget(mo,0,0);
	A_Thrust(mo,70,1);
end,35,nil,S_PURPLEHEART_NEPBREAK7}
states[S_PURPLEHEART_NEPBREAK7] = {SPR_NEPU,4,100,function(mo)
	local supermeme =  P_SpawnMobj(mo.x,mo.y,mo.z, MT_NEPBLADE);
	supermeme.momz = -35*FRACUNIT
end,35,nil,S_PURPLEHEART_NEPBREAK8}
states[S_PURPLEHEART_NEPBREAK8] = {SPR_NEPU,4,70,A_ZThrust,-35,nil,S_PURPLEHEART_PINCH5}

states[S_PURPLEHEART_PINCH5] = {SPR_NEPU,2,70,function(mo)
	mo.overrideinvuln = false;
	mo.flags = $1 | MF_SPECIAL;
	mo.bosstimer = 0;
	mo.bossphase = "ROAM";
	mo.momz = 0;
	mo.state = S_PURPLEHEART_ROAM5;
end,nil,nil,S_PURPLEHEART_PINCH5}


states[S_PURPLEHEART_KNOCKOUT1] = {SPR_NEPU,5,105,nil,nil,nil,S_PURPLEHEART_KNOCKOUT2}
states[S_PURPLEHEART_KNOCKOUT2] = {SPR_NEPF,5,18,A_ForceWin,nil,nil,S_PURPLEHEART_KNOCKOUT3}
states[S_PURPLEHEART_KNOCKOUT3] = {SPR_NEPF,4,8,A_ZThrust,18,FRACUNIT,S_PURPLEHEART_KNOCKOUT3}

states[S_PURPLEBALL] = {SPR_NEPX,3|FF_ANIMATE,1,nil,4,4,S_PURPLEBALL}
states[S_FAKEPURPLEHEART] = {SPR_NEPF,6,8,nil,nil,nil,S_NULL}

states[S_DIASLASH] = {SPR_CROS,0|FF_ANIMATE,15,nil,4,3,S_NULL}
states[S_HORISLASH] = {SPR_CROS,5|FF_ANIMATE,15,nil,9,3,S_NULL}

states[S_32BITMEGABLADE] = {SPR_NEPX,0,140,nil,nil,nil,S_NULL}
states[S_NEPBLADE1] = {SPR_NEPX,5,4,function(mo)
//this is the epitome of lazy
	if P_IsObjectOnGround(mo) then
		mo.state = S_NEPBLADE2
	end
end,nil,nil,S_NEPBLADE1}
states[S_NEPBLADE2] = {SPR_NEPX,5,45,function(mo)
	P_StartQuake(15*FRACUNIT, 20);
	S_StartSound(nil,sfx_phbrst);
end,nil,nil,S_NEPBLADE3}
states[S_NEPBLADE3] = {SPR_NEPX,5,4,nil,nil,nil,S_NEPBLADE3}

states[S_FAKENEPBLADE] = {SPR_NEPX,7|TR_TRANS50,50,nil,nil,nil,S_NULL}

states[S_SHINECUBE] = {SPR_NEPX,1|TR_TRANS50,16,nil,nil,nil,S_NULL}

states[S_DEBRIS1] = {SPR_NEPX,2,25,nil,nil,nil,S_DEBRIS2}
states[S_DEBRIS2] = {SPR_NEPX,2,-1,A_SetObjectFlags,MF_NOGRAVITY,1,S_DEBRIS2}

states[S_SWORDFRENZY] = {SPR_NULL,0,280,function(mo)
	if mo.target and mo.target.valid then
		if mo.target.pinch == 1 then
			mo.tics = 420;
		end
	end
end,nil,nil,S_NULL}

states[S_LASERFRENZY] = {SPR_NULL,0,400,nil,nil,nil,S_NULL}
states[S_LASERFRENZYSET1] = {SPR_NULL,0,35,function(mo)
	mo.extravalue2 = 4 + 2 * playerCount()
end,nil,nil,S_LASERFRENZYSET2}
states[S_LASERFRENZYSET2] = {SPR_NULL,0,3,function(mo)
	local laser = P_SpawnMobj(mo.x,mo.y,mo.z, MT_PURPLELASER)
	laser.target = mo;
	laser.momz = -60*FRACUNIT;
end,nil,nil,S_LASERFRENZYSET3}
states[S_LASERFRENZYSET3] = {SPR_NULL,0,30,A_Repeat,40,S_LASERFRENZYSET2,S_NULL}

states[S_PURPLELASER] = {SPR_NEPX,6,105,nil,nil,nil,S_NULL}

//These are all for PH.

//Wavy motion
local function floatLogic(mo)
	if not mo.wavetimer then
		mo.wavetimer = 1;
	else
		mo.wavetimer = $ + 2 ;
		mo.wavetimer = $ % 721;
	end
	mo.z  = $1 + sin(FixedAngle(mo.wavetimer*FRACUNIT));
end

//Summon invincibility sparkles
local function sparkle(star)
	if not star.floattimer
		star.floattimer = 0;
	end
	star.floattimer = ($1 + 1) % 140;
	if star.floattimer % 16 == 0 then
		local spark = P_SpawnMobj(star.x,star.y,star.z,MT_IVSP);
		spark.momx = P_RandomRange(-4,4)*FRACUNIT;
		spark.momz = P_RandomRange(-5,-2)*FRACUNIT;
	end
end

local hurtsounds = {
	sfx_phhrt1,
	sfx_phhrt2,
	sfx_phhrt3,
	sfx_phhrt4
}

//some bullshit involving getting hurt, bossphases, invulnerability and cute sounds
local function removeHealth(target,inflictor,source,damage)
	target.health = $1 - 1
	if target.health < 1
		S_StartSound(nil,mobjinfo[target.type].deathsound)
		P_KillMobj(target)
	else
		if target.health == 8 then
			screenWipe();
			target.pinch = 1;
			target.bossphase = "PINCH";
			target.bosstimer = 0;
			target.state = S_PURPLEHEART_PINCH1
			target.extravalue1 = 0;
			target.extravalue2 = 0;
		end
		S_StartSound(nil,sfx_phdmg);
		if target.health > 8 then
			if leveltime % 2 == 0 then
				S_StartSound(nil, hurtsounds[1])
			else
					S_StartSound(nil, hurtsounds[2])
			end
		else
			if leveltime % 2 == 0 then
				S_StartSound(nil, hurtsounds[3])
			else
					S_StartSound(nil, hurtsounds[4])
			end
		end
		target.invulntime = mobjinfo[target.type].reactiontime
		target.flags2 = $1 | MF2_FRET
		target.flags = $1 & ~MF_SHOOTABLE
	end
	return true
end

//setup
local function purpleSpawn(mo)
	mo.bossphase = "IDLE";
	mo.overrideinvuln = false;
	mo.invulntime = 0;
	mo.bosstimer = 0;
	mo.oldbosstimer = 0;
	mo.pinch = 0;
	mo.shadowscale = 5*FRACUNIT/4
end

//aaaaalll logic goes here
local function purpleThinker(mo)
	if mo.bossphase then
		if mo.bossphase ~= "IDLE" then
			mo.bosstimer = $ + 1;
		end

		if mo.bossphase == "ROAM" then
			mo.momx = $1 * 93/100;
			mo.momy = $1 * 93/100;
			if mo.bosstimer > 470 and mo.state == S_PURPLEHEART_ROAM5 then //very arbitrary number lul
				local seed = P_RandomRange(1,3);
				if seed == 1 then
					mo.bossphase = "32BIT"
					mo.state = S_PURPLEHEART_32BIT1
				elseif seed == 2 then
					mo.bossphase = "DELTA"
					mo.state = S_PURPLEHEART_DELTA1
				else
					mo.bossphase = "CROSS"
					mo.state = S_PURPLEHEART_CROSS1
				end
				mo.bosstimer = 0;
			end
		end

		if mo.bossphase == "32BIT" then
			mo.momz = $1 * 93/100;
			if mo.bosstimer >(260 - 45*mo.pinch) then
				mo.bossphase = "ROAM"
				mo.state = S_PURPLEHEART_ROAM1
				mo.bosstimer = 0;
			end
		end

		if mo.bossphase == "DELTA" then
			mo.momx = $1 * 95/100;
			mo.momy = $1 * 95/100;
			if mo.bosstimer > (290 + 80*mo.pinch) and mo.state == S_PURPLEHEART_DELTA5 then
				mo.bossphase = "ROAM"
				mo.state = S_PURPLEHEART_ROAM1
				mo.bosstimer = 0;
			end
			if mo.state == S_PURPLEHEART_DELTA3 then
					for i = -1, 1 do
						local offsetx = cos(mo.angle + (ANG30 * i))
						local offsety = sin(mo.angle + (ANG30 * i))
						local deb = P_SpawnMobj(mo.x - 80 * offsetx,mo.y  - 80 * offsety,mo.z+10*FRACUNIT, MT_DEBRIS)
						deb.target = mo;
						deb.momx = FixedMul(offsetx,mo.momx / 8)
						deb.momy = FixedMul(offsety,mo.momy / 8)
					end
			end
		end

		if mo.bossphase == "CROSS" then
			mo.momx = $1 * 93/100;
			mo.momy = $1 * 93/100;
			if mo.bosstimer > (300 - 30 * mo.pinch) and mo.state == S_PURPLEHEART_CROSS8 then //very arbitrary number lul
				mo.bossphase = "ROAM"
				mo.state = S_PURPLEHEART_ROAM1
				mo.bosstimer = 0;
			end
		end

		if mo.bossphase == "PINCH" //follow up with neptune break?????????
			mo.momx = $1 * 95/100;
			mo.momy = $1 * 95/100;
			mo.momz = $1 * 95/100;
		end

	end

	if mo.invulntime > 0
		mo.invulntime = $1 - 1
	end
	if (not (mo.flags & MF_SHOOTABLE)) and mo.overrideinvuln == true and leveltime % 4 == 0 then
		P_SpawnGhostMobj(mo);
		local shadow = P_SpawnMobj(mo.x,mo.y,mo.z - 25*FRACUNIT, MT_FAKEPURPLEHEART);
		shadow.target = mo;
	end
	if mo.invulntime == 0 then
		mo.flags2 = $1 & ~(MF2_FRET | MF2_DONTDRAW)
		if (mo.overrideinvuln == false) then
			mo.flags = $1 | MF_SHOOTABLE
		end
	end
end

local function purpleKnockout(target,inflictor,source)
	screenWipe()
	target.bossphase = "END"
	target.state = target.info.deathstate
	return true
end

//These are for stuff that belongs to objects that are NOT PH.
//for fake purple heart
local function shadowCopy(mo)
	if mo.target and mo.target.valid then
		mo.frame = mo.target.frame;
		mo.scale = mo.target.shadowscale;
	end
end

//Sword A E S T H E T I C
local function swordParticle(mo)
	if leveltime % 4 == 0 then
		local cube = P_SpawnMobj(mo.x + P_RandomRange(-10,10)*FRACUNIT, mo.y+ P_RandomRange(-10,10)*FRACUNIT, mo.z+ P_RandomRange(0,40)*FRACUNIT , MT_SHINECUBE)
		cube.momx = P_RandomRange(-10,10);
		cube.momy = P_RandomRange(-10,10);
		cube.momz = P_RandomRange(4,12);
		cube.scale = P_RandomRange(1,2) * FRACUNIT;
	end
	if mo.tics == (100 + 18*mo.target.pinch) then
		mo.momz = (-18 - 6*mo.target.pinch)*FRACUNIT;
		S_StartSound(mo,sfx_phslas);
	end
end

local function swordFrenzy(mo)
	if mo.tics % (45 - 15*mo.target.pinch) == 0 then
		S_StartSound(nil, sfx_phswo);
		for player in players.iterate do
			if player.mo and (player.mo.valid and player.mo.health) then
				local sword = P_SpawnMobj(player.mo.x, player.mo.y, mo.z + 30*FRACUNIT, MT_32BITMEGABLADE)
				sword.target = mo.target;
				if mo.target.pinch == 1 then
					sword.scale = 3*FRACUNIT/2;
				else
					sword.scale = 5*FRACUNIT/4;
				end
				local reticle = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_CYBRAKDEMON_TARGET_RETICULE)
			end
		end
	end
end

local function laserFrenzy(mo)
	if mo.tics % (17 + 3 * playerCount()) == 0  then
		S_StartSound(nil, sfx_phswo);
		for player in players.iterate do
			if player.mo and (player.mo.valid and player.mo.health) then
				local beamspawn = P_SpawnMobj(player.mo.x, player.mo.y, mo.z + 800*FRACUNIT, MT_LASERFRENZYSET)
				beamspawn.target = mo.target;
				local reticle = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_CYBRAKDEMON_TARGET_RETICULE)
			end
		end
	end
end

local function nepbladeFrenzy(mo)
	if P_IsObjectOnGround(mo) then
		local shadow = P_SpawnMobj(mo.x, mo.y, mo.z, MT_FAKENEPBLADE);
		shadow.scale = 2 * FRACUNIT
		shadow.momz = 55*FRACUNIT;
		if mo.state == S_NEPBLADE3 then
			mo.extravalue1 = $ + 1;
			A_MultiShot(mo,10 + MT_PURPLEBALL*FRACUNIT, -40*FRACUNIT)
			if mo.extravalue1 >= 16 then
				P_KillMobj(mo);
			end
		end
	end
end

local function largeSlash(mo)
	mo.scale = 3*FRACUNIT
end

local function sugoibosshud(v,p) // Salt: Last second really shite boss hud because Iceman doesnt want us using TD's
	// Boss finding is pretty much the same; the drawing part is different
	-- No bosses in this stage? No drawing.
	if #boss_list <= 0 return end

	-- Poll our small list of bosses
	local bosshealth = 0;
	local bossmax    = 0;

	-- (We ignore the index given to us, we only want the object;
	--  that's why this also uses pairs and not ipairs for order)
	for	_,mobj in pairs(boss_list)
		if mobj.valid and not (mobj.flags2 & MF2_BOSSDEAD)
			bossmax    = $1 + mobj.info.spawnhealth
			bosshealth = $1 + mobj.health
		end
	end

	-- No bosses are still alive.
	if bossmax <= 0 return end

	local startx = 168
	local starty = 173

	v.draw(startx,starty,v.cachePatch("NEPBOSS"), V_SNAPTOBOTTOM|V_SNAPTOLEFT)
	if bosshealth > 0
		v.draw(startx+29,starty+10,v.cachePatch("NEPBAR"..bosshealth),V_SNAPTOBOTTOM|V_SNAPTOLEFT)
	end
end
hud.add(sugoibosshud);

addHook("MobjThinker", shadowCopy, MT_FAKEPURPLEHEART)
addHook("MobjThinker", swordParticle, MT_32BITMEGABLADE)

addHook("MobjThinker", swordFrenzy, MT_SWORDFRENZY)
addHook("MobjThinker", laserFrenzy, MT_LASERFRENZY)
addHook("MobjThinker", nepbladeFrenzy, MT_NEPBLADE)

addHook("MobjSpawn", largeSlash, MT_DIASLASH)
addHook("MobjSpawn", largeSlash, MT_HORISLASH)

addHook("MobjThinker",floatLogic,MT_PURPLEHEART)
addHook("MobjThinker",sparkle,MT_PURPLEHEART)
addHook("MobjThinker",purpleThinker,MT_PURPLEHEART)
addHook("MobjSpawn", purpleSpawn, MT_PURPLEHEART)
addHook("MobjDamage", removeHealth, MT_PURPLEHEART)
addHook("MobjDeath", purpleKnockout, MT_PURPLEHEART)
