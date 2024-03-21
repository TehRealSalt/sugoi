-- ROASTED RAVINE ACT 1 (& the boss i guess)
-- BY LAT' AND SAMMY_SWAG (but mostly sam for the level design and lat' for the lua)

-- BURN YO ASS FAM.

freeslot(
	"sfx_rrzr",
	"SPR_FPRT",
	"SPR_ROST",

	"SPR2_ROST",
	"S_PLAY_ROASTED",

	"SPR_RRTR",
	"MT_RRZTREE1",
	"MT_RRZTREE2",
	"MT_RRZTREE3",
	"S_RRZTREE1",
	"S_RRZTREE2",
	"S_RRZTREE3",

	"SPR_RRCT",
	"SPR_SOLA",
	"SPR_EGGG",
	"sfx_beam"
)

spr2defaults[SPR2_ROST] = SPR2_DEAD
states[S_PLAY_ROASTED] = {SPR_PLAY, SPR2_ROST|FF_ANIMATE, -1, nil, 0, 4, S_NULL}

local PARTICLE_DIST_RRZ = 2048

mobjinfo[MT_RRZTREE1] = {
	--$Name RRZ Tree 1
	--$Sprite RRTRA0
	--$Category SUGOI Decoration
	doomednum = 4020,
    spawnstate = S_RRZTREE1,
    spawnhealth = 1,
    seestate = S_NULL,
    seesound = sfx_None,
    reactiontime = 0,
    attacksound = sfx_None,
    painstate = S_NULL,
    painchance = 0,
    painsound = sfx_None,
    meleestate = S_NULL,
    missilestate = S_NULL,
    deathstate = S_NULL,
    xdeathstate = S_NULL,
    deathsound = sfx_None,
    speed = 6,
    radius = 128*FRACUNIT,
    height = 256*FRACUNIT,
    dispoffset = 0,
    mass = 100,
    damage = 0,
    activesound = sfx_None,
    flags = MF_SCENERY|MF_NOTHINK,
    raisestate = S_NULL
}

mobjinfo[MT_RRZTREE2] = {
	--$Name RRZ Tree 2
	--$Sprite RRTRB0
	--$Category SUGOI Decoration
	doomednum = 4021,
	spawnstate = S_RRZTREE2,
	spawnhealth = 1,
	seestate = S_NULL,
	seesound = sfx_None,
	reactiontime = 0,
	attacksound = sfx_None,
	painstate = S_NULL,
	painchance = 0,
	painsound = sfx_None,
	meleestate = S_NULL,
	missilestate = S_NULL,
	deathstate = S_NULL,
	xdeathstate = S_NULL,
	deathsound = sfx_None,
	speed = 6,
	radius = 64*FRACUNIT,
	height = 64*FRACUNIT,
	dispoffset = 0,
	mass = 100,
	damage = 0,
	activesound = sfx_None,
	flags = MF_SCENERY|MF_NOTHINK,
	raisestate = S_NULL
}

mobjinfo[MT_RRZTREE3] = {
	--$Name RRZ Tree 3
	--$Sprite RRTRC0
	--$Category SUGOI Decoration
	doomednum = 4022,
	spawnstate = S_RRZTREE3,
	spawnhealth = 1,
	seestate = S_NULL,
	seesound = sfx_None,
	reactiontime = 0,
	attacksound = sfx_None,
	painstate = S_NULL,
	painchance = 0,
	painsound = sfx_None,
	meleestate = S_NULL,
	missilestate = S_NULL,
	deathstate = S_NULL,
	xdeathstate = S_NULL,
	deathsound = sfx_None,
	speed = 6,
	radius = 128*FRACUNIT,
	height = 192*FRACUNIT,
	dispoffset = 0,
	mass = 100,
	damage = 0,
	activesound = sfx_None,
	flags = MF_SCENERY|MF_NOTHINK,
	raisestate = S_NULL
}

states[S_RRZTREE1] = {SPR_RRTR, A, -1, nil, 0, 0, S_NULL}
states[S_RRZTREE2] = {SPR_RRTR, B, -1, nil, 0, 0, S_NULL}
states[S_RRZTREE3] = {SPR_RRTR, C, -1, nil, 0, 0, S_NULL}

local function safeFromLight(mo)

	local p = mo.player

	if mo.subsector.sector.lightlevel < 230			-- we're not in a harsh sunlight.
		return true
	else											-- we might be exposed, but are there FOFs to protect us?
		for rover in mo.subsector.sector.ffloors()
			if rover.bottomheight > mo.z			-- FOF above us
			and rover.toplightlevel < 230			-- FOF casts shadow
				return true
			end
		end
	end

	if p and p.valid

		if p.pflags & PF_GODMODE
		or p.powers[pw_shield] & SH_PROTECTFIRE
		or p.powers[pw_invulnerability]
		or p.powers[pw_super]
			return true
		end
	end
end

addHook("MobjThinker", function(mo)
	if mo and mo.valid and mapheaderinfo[gamemap].burnbabyburn

		local p = mo.player

		if not p return end
		if p.exiting return end

		-- ROPE HANDLE TO MAKE STUFF EASIER.

		if p.powers[pw_carry] == CR_ROPEHANG -- fuck off
			mo.rrz_rope = 2
		else
			if not mo.rrz_rope then mo.rrz_rope = 0 end
			mo.rrz_rope = max(0, $-1)
		end

		if p.pflags & PF_JUMPED and mo.rrz_rope and p.cmd.forwardmove > 0
			P_InstaThrust(mo, mo.angle, FixedMul(8*FRACUNIT, mo.scale))
			--P_SetObjectMomZ(mo, FixedMul(5*FRACUNIT, mo.scale))
			mo.rrz_rope = 0
		end

		if not mo.prevringlost
			mo.exposedtime = 0
			mo.burnuptime = 0
			mo.burntoashes = 0
			mo.prevringlost = 2
		end

		if mo.exposedtime	-- sweat
		and leveltime % 10==0
		and mo.health
			local sweat = P_SpawnMobj(mo.x+P_RandomRange(-25, 25)*FRACUNIT, mo.y+P_RandomRange(-25, 25)*FRACUNIT, mo.z+P_RandomRange(20, 50)*FRACUNIT, MT_WATERDROP)
			sweat.flags = $1 & ~MF_SPECIAL
		end

		if mo.exposedtime
		and leveltime % 3==0
		and p.rings < 1
			local steam = P_SpawnMobj(mo.x+P_RandomRange(-25, 25)*FRACUNIT, mo.y+P_RandomRange(-25, 25)*FRACUNIT, mo.z+P_RandomRange(20, 50)*FRACUNIT, MT_SMOKE)
			P_SetObjectMomZ(steam, P_RandomRange(1, 3)*FRACUNIT)
			if mo.burntoashes > TICRATE/2
				local burn = P_SpawnMobj(mo.x+P_RandomRange(-25, 25)*FRACUNIT, mo.y+P_RandomRange(-25, 25)*FRACUNIT, mo.z+P_RandomRange(20, 50)*FRACUNIT, MT_THOK)
				P_SetObjectMomZ(burn, P_RandomRange(1, 3)*FRACUNIT)
				burn.momx = P_RandomRange(-1, 1)*FRACUNIT
				burn.momy = P_RandomRange(-1, 1)*FRACUNIT
				burn.sprite = SPR_FPRT
			end
		end

		if mo.ovahat and mo.health > 0	-- player has ova hat
			if not mo.hat
				local hat = P_SpawnMobj(mo.x, mo.y, mo.z, MT_THOK)
				hat.state = S_OVAHAT_PICKUP
				hat.target = mo
				hat.angle = mo.angle
				hat.flags2 = mo.flags2
				mo.hat = hat
			end

			local zoffs = 0
			if mo.eflags & MFE_VERTICALFLIP
				if p.panim == PA_ROLL or p.charability == CA_GLIDEANDCLIMB and mo.state >= S_PLAY_GLIDE and mo.state <= S_PLAY_CLIMB
					zoffs = FixedMul(mo.z-(mo.height/8), mo.scale) -- not that it's supported, i didnt even fucking test lol
				else
					zoffs = FixedMul(mo.z-mo.height, mo.scale)
				end
			else
				if p.panim == PA_ROLL or p.charability == CA_GLIDEANDCLIMB and mo.state >= S_PLAY_GLIDE and mo.state <= S_PLAY_CLIMB
					zoffs = FixedMul(mo.z+mo.height-FRACUNIT*10, mo.scale)
				else
					zoffs = FixedMul(mo.z+mo.height-FRACUNIT*5, mo.scale)
				end
			end

			P_MoveOrigin(mo.hat, mo.x, mo.y, zoffs)
			mo.hat.scale = mo.scale
			mo.hat.destscale = mo.destscale
			mo.hat.angle = mo.angle
			mo.hat.momx = mo.momx
			mo.hat.momy = mo.momy
			mo.hat.momz = mo.momz

			mo.exposedtime = 0
			mo.burnuptime = 0
			mo.burntoashes = 0

			if not safeFromLight(mo)
			and leveltime%3 == 0
				local steam = P_SpawnMobj(mo.hat.x+P_RandomRange(-mo.hat.radius/FRACUNIT, mo.hat.radius/FRACUNIT)*FRACUNIT, mo.hat.y+P_RandomRange(-mo.radius/FRACUNIT, mo.hat.radius/FRACUNIT)*FRACUNIT, mo.hat.z+P_RandomRange(0, mo.hat.height/FRACUNIT)*FRACUNIT, MT_SMOKE)
				P_SetObjectMomZ(steam, P_RandomRange(1, 3)*FRACUNIT)
				local burn = P_SpawnMobj(mo.hat.x+P_RandomRange(-mo.hat.radius/FRACUNIT, mo.hat.radius/FRACUNIT)*FRACUNIT, mo.hat.y+P_RandomRange(-mo.hat.radius/FRACUNIT, mo.hat.radius/FRACUNIT)*FRACUNIT, mo.hat.z+P_RandomRange(0, mo.hat.height/FRACUNIT)*FRACUNIT, MT_THOK)
				P_SetObjectMomZ(burn, P_RandomRange(1, 3)*FRACUNIT)
				burn.momx = P_RandomRange(-1, 1)*FRACUNIT
				burn.momy = P_RandomRange(-1, 1)*FRACUNIT
				burn.sprite = SPR_FPRT
			end
		end

		if not safeFromLight(mo)
		--and not p.powers[pw_shield] & SH_PROTECTFIRE

			mo.exposedtime = min(TICRATE+TICRATE/2+TICRATE*4, $+1)

			if mo.exposedtime > TICRATE*2

				mo.burnuptime = $+1

				if p.rings > 0
					if mo.burnuptime % (TICRATE + TICRATE/2)==0
						p.rings = max(0, $-mo.prevringlost)
						mo.prevringlost = $+2
						S_StartSound(mo, sfx_rrzr, p)
					end
				else
					mo.burntoashes = $+1
					if mo.burntoashes > TICRATE*4
					and mo.health
						p.pflags = $ & ~PF_JUMPED
						P_KillMobj(mo, nil, nil)
						mo.state = S_PLAY_ROASTED
					end
				end
			end
		else
			mo.exposedtime = max(0,$-1)
			if mo.exposedtime < TICRATE+TICRATE/2
				mo.burnuptime = 0
				mo.prevringlost = 2
				mo.burntoashes = 0
			end
		end
	end
end, MT_PLAYER)

local function toastEnemy(mo)

	if mo and mo.valid and mapheaderinfo[gamemap].burnbabyburn
	and mo.type ~= MT_MINUS



		if not mo.init
			mo.exposedtime = 0
			mo.init = true
		end

		if mo.exposedtime
		and leveltime % 3==0
			local steam = P_SpawnMobj(mo.x+P_RandomRange(-25, 25)*FRACUNIT, mo.y+P_RandomRange(-25, 25)*FRACUNIT, mo.z+P_RandomRange(20, 40)*FRACUNIT, MT_SMOKE)
			P_SetObjectMomZ(steam, P_RandomRange(1, 3)*FRACUNIT)
			if mo.exposedtime > TICRATE*2
				local burn = P_SpawnMobj(mo.x+P_RandomRange(-25, 25)*FRACUNIT, mo.y+P_RandomRange(-25, 25)*FRACUNIT, mo.z+P_RandomRange(20, 40)*FRACUNIT, MT_THOK)
				P_SetObjectMomZ(burn, P_RandomRange(1, 3)*FRACUNIT)
				burn.momx = P_RandomRange(-1, 1)*FRACUNIT
				burn.momy = P_RandomRange(-1, 1)*FRACUNIT
				burn.sprite = SPR_FPRT
			end
		end

		if not safeFromLight(mo)
		and mo.flags & MF_SHOOTABLE

			mo.exposedtime = $+1

			if mo.exposedtime > TICRATE*5
			and mo.health
				P_KillMobj(mo)
			end
		else
			mo.exposedtime = max(0,$-1)
		end
	end
end

addHook("MobjThinker", toastEnemy, MT_REDCRAWLA)


local function toastChicken(mo)
	if mo and mo.valid and mapheaderinfo[gamemap].burnbabyburn

		if not mo.init
			mo.exposedtime = 0
			mo.init = true
		end

		if mo and mo.valid
		and mo.exposedtime
		and leveltime % 3==0
			local steam = P_SpawnMobj(mo.x+P_RandomRange(-10, 10)*FRACUNIT, mo.y+P_RandomRange(-10, 10)*FRACUNIT, mo.z+P_RandomRange(0, 10)*FRACUNIT, MT_SMOKE)
			P_SetObjectMomZ(steam, P_RandomRange(1, 3)*FRACUNIT)
			if mo.exposedtime > TICRATE*1
				local burn = P_SpawnMobj(mo.x+P_RandomRange(-10, 10)*FRACUNIT, mo.y+P_RandomRange(-10, 10)*FRACUNIT, mo.z+P_RandomRange(0, 10)*FRACUNIT, MT_THOK)
				P_SetObjectMomZ(burn, P_RandomRange(1, 3)*FRACUNIT)
				burn.momx = P_RandomRange(-1, 1)*FRACUNIT
				burn.momy = P_RandomRange(-1, 1)*FRACUNIT
				burn.sprite = SPR_FPRT
			end
		end

		if mo and mo.valid
		and not safeFromLight(mo)

			mo.exposedtime = $+1
			if mo.exposedtime > TICRATE*2
				mo.momx = 0
				mo.momy = 0
				mo.state = S_PLAY_STND
				mo.sprite = SPR_ROST
				mo.frame = A
			end
		else
			if mo and mo.valid
				mo.exposedtime = max(0,$-1)
			end
		end
	end
end

addHook("MobjThinker", toastChicken, MT_FLICKY_03)

-- OVA HAT SCRIPT
-- CREDITS TO SeventhSentinel FOR THE ORIGINAL OVA HAT SPRITES, I JUST GAVE THEM A QUICK "POLISH COAT"

freeslot("MT_OVAHAT", "SPR_KTEH", "S_OVAHAT_PICKUP")

mobjinfo[MT_OVAHAT] = {
	--$Name OVA Hat
	--$Sprite KTEHA2A8
	--$Category SUGOI Powerups
	doomednum = 4036,
	spawnstate = S_OVAHAT_PICKUP,
	spawnhealth = 1,
	seestate = S_NULL,
	seesound = sfx_None,
	reactiontime = 0,
	attacksound = sfx_None,
	painstate = S_NULL,
	painchance = 0,
	painsound = sfx_None,
	meleestate = S_NULL,
	missilestate = S_NULL,
	deathstate = S_NULL,
	xdeathstate = S_NULL,
	deathsound = sfx_None,
	speed = 6,
	radius = 24*FRACUNIT,
	height = 24*FRACUNIT,
	dispoffset = 64,
	mass = 100,
	damage = 0,
	activesound = sfx_None,
	flags = MF_SCENERY|MF_SPECIAL,
	raisestate = S_NULL
}

states[S_OVAHAT_PICKUP] = {SPR_KTEH, A, -1, nil, 0, 0, S_NULL}

addHook("TouchSpecial", function(obj, mo)
	local p = mo.player
	mo.ovahat = true

	if (netgame)
		chatprint("\x82".."IRRELEVANT INFO: ".."\x80"..p.name.." has picked up the OVA hat and is now impervious to the sun! ...The hat still catches fire though.")
	else
		print("\x82".."IRRELEVANT INFO: ".."\x80You have picked up the OVA hat and are now impervious to the sun! ...The hat still catches fire though.")
	end
end, MT_OVAHAT)

/*
addHook("ThinkFrame", do
	for p in players.iterate

		if p.mo and p.mo.valid
		local mo = p.mo

			if mo.ovahat	-- player has ova hat
				if not mo.hat
					local hat = P_SpawnMobj(mo.x, mo.y, mo.z, MT_THOK)
					hat.state = S_OVAHAT_PICKUP
					hat.target = mo
					hat.angle = mo.angle
					hat.flags2 = mo.flags2
					mo.hat = hat
				end

				local zoffs
				if mo.eflags & MFE_VERTICALFLIP
					if p.panim == PA_ROLL or p.charability == CA_GLIDEANDCLIMB and mo.state >= S_PLAY_ABL1 and mo.state <= S_PLAY_CLIMB5
						zoffs = FixedMul(mo.z-(mo.height/8), mo.scale) -- not that it's supported, i didnt even fucking test lol
					else
						zoffs = FixedMul(mo.z-mo.height, mo.scale)
					end
				else
					if p.panim == PA_ROLL or p.charability == CA_GLIDEANDCLIMB and mo.state >= S_PLAY_ABL1 and mo.state <= S_PLAY_CLIMB5
						zoffs = FixedMul(mo.z+mo.height-FRACUNIT*10, mo.scale)
					else
						zoffs = FixedMul(mo.z+mo.height-FRACUNIT*5, mo.scale)
					end
				end

				P_MoveOrigin(mo.hat, mo.x, mo.y, zoffs)
				mo.hat.scale = mo.scale
				mo.hat.angle = mo.angle

				mo.exposedtime = 0
				mo.burnuptime = 0
				mo.burntoashes = 0

				if not safeFromLight(mo)
				and leveltime%3 == 0
					local steam = P_SpawnMobj(mo.hat.x+P_RandomRange(-mo.hat.radius/FRACUNIT, mo.hat.radius/FRACUNIT)*FRACUNIT, mo.hat.y+P_RandomRange(-mo.radius/FRACUNIT, mo.hat.radius/FRACUNIT)*FRACUNIT, mo.hat.z+P_RandomRange(0, mo.hat.height/FRACUNIT)*FRACUNIT, MT_SMOKE)
					P_SetObjectMomZ(steam, P_RandomRange(1, 3)*FRACUNIT)
					local burn = P_SpawnMobj(mo.hat.x+P_RandomRange(-mo.hat.radius/FRACUNIT, mo.hat.radius/FRACUNIT)*FRACUNIT, mo.hat.y+P_RandomRange(-mo.hat.radius/FRACUNIT, mo.hat.radius/FRACUNIT)*FRACUNIT, mo.hat.z+P_RandomRange(0, mo.hat.height/FRACUNIT)*FRACUNIT, MT_THOK)
					P_SetObjectMomZ(burn, P_RandomRange(1, 3)*FRACUNIT)
					burn.momx = P_RandomRange(-1, 1)*FRACUNIT
					burn.momy = P_RandomRange(-1, 1)*FRACUNIT
					burn.sprite = SPR_FPRT
				end
			end
		end
	end
end)
*/

-- WAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

freeslot("MT_NPCSPAWNER", "SPR_WAAA", "SPR_SONI", "SPR_TAIL", "SPR_KNUX", "MT_WALUIGISPAWNER", "S_WALUIGI", "MT_TACO", "S_TACO", "SPR_TACO", "sfx_tacos", "sfx_waaa", "SPR_FPRT")

sfxinfo[sfx_tacos] = {flags = SF_X4AWAYSOUND}

mobjinfo[MT_NPCSPAWNER] = {
	--$Name NPC
	--$Category SUGOI NPCs
	--$Flags8Text RRZ behavior
	doomednum = 4035,
    spawnstate = S_THOK,
    spawnhealth = 1,
    seestate = S_NULL,
    seesound = sfx_None,
    reactiontime = 0,
    attacksound = sfx_None,
    painstate = S_NULL,
    painchance = 0,
    painsound = sfx_None,
    meleestate = S_NULL,
    missilestate = S_NULL,
    deathstate = S_NULL,
    xdeathstate = S_NULL,
    deathsound = sfx_pop,
    speed = 0,
    radius = 1*FRACUNIT,
    height = 1*FRACUNIT,
    dispoffset = 0,
    mass = 100,
    damage = 0,
    activesound = sfx_None,
    flags = MF_SCENERY,
    raisestate = MT_THOK
}

local function createNPC(x, y, z, angle, forcedskin, forcedcolor, avoidmachines)
	local npc = P_SpawnMobj(x, y, z, MT_THOK) //MT_PLAYER
	npc.angle = angle

	if (forcedskin != nil)
		npc.skin = forcedskin
	else
		local skinlist = {}
		for skin in skins.iterate do
			if (skin.flags & SF_MACHINE) // Metal Sonic would not eat a taco
				if (avoidmachines)
				and not (P_RandomChance(FRACUNIT/10)) // ...unless if you're lucky :)
					continue
				end
			end

			table.insert(skinlist, skin.name)
		end

		npc.skin = skinlist[P_RandomKey(#skinlist) + 1]
	end

	if (forcedcolor != nil)
		npc.color = forcedcolor
	else
		local colorlist = {}
		for i = 1,#skincolors-1
			if not (skincolors[i].accessible)
				// Don't use super colors
				continue
			end

			table.insert(colorlist, i)
		end

		npc.color = colorlist[P_RandomKey(#colorlist) + 1]
	end

	npc.state = S_PLAY_STND
	npc.flags = (mobjinfo[MT_PLAYER].flags | MF_SCENERY) & ~MF_SHOOTABLE
	npc.radius = mobjinfo[MT_PLAYER].radius
	npc.height = mobjinfo[MT_PLAYER].height
	//npc.flags2 = mo.flags2
	npc.tics = -1
	npc.shadowscale = FRACUNIT

	if (skins[npc.skin].followitem > 0)
		local followitem = skins[npc.skin].followitem
		local followstate = mobjinfo[followitem].spawnstate

		if (followitem == MT_TAILSOVERLAY)
			// Welp I wasn't expecting that
			followstate = S_TAILSOVERLAY_STAND
		end

		if (followstate != S_NULL and followstate != S_INVISIBLE)
			local followx = npc.x + P_ReturnThrustX(npc, npc.angle, -FRACUNIT)
			local followy = npc.y + P_ReturnThrustY(npc, npc.angle, -FRACUNIT)
			local followz = npc.z + 3*FRACUNIT
			local followmobj = P_SpawnMobj(followx, followy, followz, MT_THOK)
			followmobj.angle = npc.angle
			followmobj.skin = npc.skin
			followmobj.color = npc.color

			followmobj.state = followstate
			followmobj.flags = (mobjinfo[followitem].flags | MF_SCENERY) & ~MF_SHOOTABLE
			followmobj.radius = mobjinfo[followitem].radius
			followmobj.height = mobjinfo[followitem].height
			--followmobj.tics = -1

			npc.tracer = followmobj
			followmobj.tracer = npc
		end
	end

	return npc
end

-- spawn npc

addHook("MobjThinker", function(mo)
	-- Extend this so it can replace another NPC object type I don't feel like updating too
	local rrzCustomer = (mo.flags2 & MF2_AMBUSH)

	if not (rrzCustomer)
	or (P_RandomChance((FRACUNIT*9)/10))
		local npc = createNPC(mo.x, mo.y, mo.z, mo.angle, nil, nil, rrzCustomer)

		if (rrzCustomer)
			-- Spawn tacos for Roasted Ravine's customers
			local gotox = npc.x+ 64*cos(npc.angle)
			local gotoy = npc.y+ 64*sin(npc.angle)

			local taco = P_SpawnMobj(gotox, gotoy, npc.z + 50*FRACUNIT, MT_TACO)
			taco.momz = -FRACUNIT*20
		end
	end

	P_RemoveMobj(mo)
	return
end, MT_NPCSPAWNER)

mobjinfo[MT_WALUIGISPAWNER] = {
	--$Name Waluigi
	--$Sprite WAAAA0
	--$Category SUGOI NPCs
	doomednum = 4033,
    spawnstate = S_WALUIGI,
    spawnhealth = 1,
    seestate = S_NULL,
    seesound = sfx_None,
    reactiontime = 0,
    attacksound = sfx_None,
    painstate = S_NULL,
    painchance = 0,
    painsound = sfx_None,
    meleestate = S_NULL,
    missilestate = S_NULL,
    deathstate = S_NULL,
    xdeathstate = S_NULL,
    deathsound = sfx_pop,
    speed = 0,
    radius = 16*FRACUNIT,
    height = 48*FRACUNIT,
    dispoffset = 0,
    mass = 100,
    damage = 0,
    activesound = sfx_None,
    flags = MF_SCENERY,
    raisestate = MT_THOK
}

states[S_WALUIGI] = {SPR_WAAA, A, -1, nil, 0, 0, S_WALUIGI}

mobjinfo[MT_TACO] = {
	--$Name Taco
	--$Sprite TACOA0
	--$Category SUGOI Decoration
	doomednum = 4034,
    spawnstate = S_TACO,
    spawnhealth = 1,
    seestate = S_NULL,
    seesound = sfx_None,
    reactiontime = 0,
    attacksound = sfx_None,
    painstate = S_NULL,
    painchance = 0,
    painsound = sfx_None,
    meleestate = S_NULL,
    missilestate = S_NULL,
    deathstate = S_NULL,
    xdeathstate = S_NULL,
    deathsound = sfx_pop,
    speed = 0,
    radius = 16*FRACUNIT,
    height = 48*FRACUNIT,
    dispoffset = 0,
    mass = 100,
    damage = 0,
    activesound = sfx_None,
    flags = MF_SCENERY,
    raisestate = MT_THOK
}


states[S_TACO] = {SPR_TACO, A, -1, nil, 0, 0, S_TACO}

-- HANDLE SEXY WALUIGI

addHook("MobjThinker", function(mo)
	mo.shadowscale = FRACUNIT

	-- waluigi looks around 4 players 4 cutscene

	if not mo.viewpoint

		mo.viewpoint = P_SpawnMobj(mo.x, mo.y, mo.z+FRACUNIT*100, MT_THOK)
		mo.viewpoint.sprite = SPR_NULL
		mo.viewpoint.state = S_INVISIBLE
		mo.viewpoint.tics = -1

	end
	if not mo.cutscene_played
		P_LookForPlayers(mo.viewpoint, 1512*FRACUNIT, true)
		mo.cutscene_time = 0
	end

	mo.target = mo.viewpoint.target

	-- DO CUTSCENE

	if mo.target
	and not mo.cutscene_ended
		mo.cutscene_played = true
		mo.cutscene_time = $+1

		mo.target.player.powers[pw_nocontrol]=32767

		--print(mo.cutscene_time)

		-- CAMERA ANGLE 1

		if mo.cutscene_time == 1

			local s_x_c = mo.x+ 708*cos(mo.angle+ANGLE_180)
			local s_y_c = mo.y+ 708*sin(mo.angle+ANGLE_180)

			local camera = P_SpawnMobj(s_x_c, s_y_c, mo.z+155*FRACUNIT, MT_THOK)
			camera.state = S_INVISIBLE
			camera.angle = mo.angle

			mo.target.player.awayviewmobj = camera
			mo.target.player.awayviewtics = TICRATE*3
			mo.target.player.awayviewaiming = -ANG1*4
		end

		-- CAMERA ANGLE 2

		if mo.cutscene_time == TICRATE*3

			local s_x_c = mo.x+ 155*cos(mo.angle+ANGLE_180)
			local s_y_c = mo.y+ 155*sin(mo.angle+ANGLE_180)

			local camera = P_SpawnMobj(s_x_c, s_y_c, mo.z+65*FRACUNIT, MT_THOK)
			camera.state = S_INVISIBLE
			camera.angle = mo.angle

			mo.target.player.awayviewmobj = camera
			mo.target.player.awayviewtics = TICRATE*10
			mo.target.player.awayviewaiming = -ANG1*4
		end

		-- SPAWN TACO

		if mo.cutscene_time == TICRATE*4

			local s_x_t = mo.x+ 32*cos(mo.angle+ANGLE_180)
			local s_y_t = mo.y+ 32*sin(mo.angle+ANGLE_180)

			local tacos = P_SpawnMobj(s_x_t, s_y_t, mo.z+35*FRACUNIT, MT_TACO)
			P_SetOrigin(tacos, tacos.x, tacos.y, tacos.floorz)
			tacos.tics = -1
			tacos.fuse = TICRATE*2
		end

		-- CAMERA ANGLE 3

		if mo.cutscene_time == TICRATE*8

			local s_x_c = mo.x+ 24*cos(mo.angle+ANGLE_180)
			local s_y_c = mo.y+ 24*sin(mo.angle+ANGLE_180)

			local camera = P_SpawnMobj(s_x_c, s_y_c, mo.z+35*FRACUNIT, MT_THOK)
			camera.state = S_INVISIBLE
			camera.angle = mo.angle + ANGLE_180

			mo.target.player.awayviewmobj = camera
			mo.target.player.awayviewtics = TICRATE*12
			mo.target.player.awayviewaiming = 0
		end

		-- CUSTOMER BURNS UP LIKE A TWAT LOL

		if mo.cutscene_time >= TICRATE*10-TICRATE/2

			if leveltime%3 == 0
				local steam = P_SpawnMobj(mo.special_customer.x+P_RandomRange(-25, 25)*FRACUNIT, mo.special_customer.y+P_RandomRange(-25, 25)*FRACUNIT, mo.special_customer.z+P_RandomRange(20, 50)*FRACUNIT, MT_SMOKE)
				P_SetObjectMomZ(steam, P_RandomRange(1, 3)*FRACUNIT)
				local burn = P_SpawnMobj(mo.special_customer.x+P_RandomRange(-25, 25)*FRACUNIT, mo.special_customer.y+P_RandomRange(-25, 25)*FRACUNIT, mo.special_customer.z+P_RandomRange(20, 50)*FRACUNIT, MT_THOK)
				P_SetObjectMomZ(burn, P_RandomRange(1, 3)*FRACUNIT)
				burn.momx = P_RandomRange(-1, 1)*FRACUNIT
				burn.momy = P_RandomRange(-1, 1)*FRACUNIT
				burn.sprite = SPR_FPRT
			end

			if mo.cutscene_time == TICRATE*14
				S_StartSound(mo.special_customer, sfx_shldls)
				P_SetObjectMomZ(mo.special_customer, 15*FRACUNIT, false)
				if (mo.special_customer.tracer and mo.special_customer.tracer.valid)
					P_RemoveMobj(mo.special_customer.tracer)
				end
				mo.special_customer.state = S_PLAY_ROASTED
				mo.special_customer.flags = $|MF_NOCLIPHEIGHT
				mo.special_customer.fuse = TICRATE*6
			end

			if mo.cutscene_time == TICRATE*14+TICRATE/2
				S_StartSound(nil, sfx_waaa, mo.target.player)
			end

			if mo.cutscene_time == TICRATE*18
				mo.target.player.awayviewtics = 1
				mo.target.player.powers[pw_nocontrol]=0
				mo.cutscene_ended = true
			end
		end
	end

	-- spawn waluigi's customers :)

	if not mo.soundtimer
	or not S_SoundPlaying(mo, sfx_tacos)
		S_StartSound(mo, sfx_tacos)
		mo.soundtimer = 482
	end
	mo.soundtimer = $-1
	local dist = 96
	if not mo.spawned_customers
		for i=1,5

			local s_x = mo.x+ dist*cos(mo.angle+ANGLE_180)
			local s_y = mo.y+ dist*sin(mo.angle+ANGLE_180)

			local customer = nil
			if i == 1
				customer = createNPC(s_x, s_y, mo.z, mo.angle, "tails", SKINCOLOR_WHITE, true)
				mo.special_customer = customer
			else
				customer = createNPC(s_x, s_y, mo.z, mo.angle, nil, nil, true)
			end

			dist = $+48
		end
		mo.spawned_customers = 1
	end
end, MT_WALUIGISPAWNER)



-- RRZ BOSS SCRIPT

freeslot("MT_RRZBOSS", "S_RRZBOSS_1")

mobjinfo[MT_RRZBOSS] = {
	--$Name Roasted Ravine Boss
	--$Sprite EGGMA1
	--$Category SUGOI Bosses
	doomednum = 4026,
    spawnstate = S_RRZBOSS_1,
    spawnhealth = 10,
    seestate = S_NULL,
    seesound = 0,
    reactiontime = 8,
    attacksound = sfx_None,
    painstate = S_RRZBOSS_1,
    painchance = 0,
    painsound = sfx_dmpain,
    meleestate = S_NULL,
    missilestate = S_NULL,
    deathstate = S_RRZBOSS_1,
    xdeathstate = S_RRZBOSS_1,
    deathsound = sfx_spkdth,
    speed = 10*FRACUNIT,
    radius = 24*FRACUNIT,
    height = 72*FRACUNIT,
    dispoffset = 0,
    mass = 100,
    damage = 0,
    activesound = sfx_None,
    flags = MF_SPECIAL|MF_BOSS|MF_NOGRAVITY|MF_SHOOTABLE,
    raisestate = 0
}

-- Yeah, we're not gonna use too many states since Lua will do most of the job.

states[S_RRZBOSS_1] = {SPR_EGGM, A, -1, nil, 0, 0, S_RRZBOSS_1}

-- BOSS THINKER HOLY SHITU

addHook("ShouldDamage", function(mo, inflictor)

	if inflictor and inflictor.RRZ_nuke ~= nil and not mo.spikesdown
		return false
	end
	if inflictor and inflictor.RRZ_cactishield and not mo.spikesdown and inflictor.RRZ_nuke == nil
		S_StartSound(inflictor, sfx_s3k80)
		return false
	end
	if not mo.spikesdown and not inflictor.RRZ_cactishield
		P_DamageMobj(inflictor, mo, mo)
		return false
	end
end, MT_RRZBOSS)

local function cactiSpikeBurst_Boss(mo, arg1)

	local h_angle = 0
	local v_angle = 0
	local dist = 64
	local frame = 0

	mo.spikes = {}

	for i=1,26

		local s_x = mo.x+ dist*FixedMul(cos(h_angle), cos(v_angle))
		local s_y = mo.y+ dist*FixedMul(sin(h_angle), cos(v_angle))
		local s_z = (mo.z+mo.height/2)+ dist* sin(v_angle)
		local spike = P_SpawnMobj(s_x, s_y, s_z, MT_CACTISPIKE)
		spike.frame = frame
		spike.angle = h_angle
		spike.target = mo -- dont damage self rofl
		spike.home = 1
		spike.tracer = mo.target
		spike.scale = FRACUNIT*2
		spike.momx = 55 * FixedMul(cos(h_angle), cos(v_angle))
		spike.momy = 55 * FixedMul(sin(h_angle), cos(v_angle))
		spike.momz = 55 * sin(v_angle)

		h_angle = $+ANGLE_45

		if i == 8
			v_angle = ANGLE_45
			frame = 1
		elseif i == 16
			v_angle = -ANGLE_45
			frame = 2
		elseif i == 24
			v_angle = ANGLE_90
			frame = 3
		elseif i == 25
			v_angle = -ANGLE_90
			frame = 4
		end
		table.insert(mo.spikes, spike)
	end
	S_StartSound(mo, sfx_spkdth)
	mo.spikesdown = TICRATE*4
end

addHook("MobjDamage", function(mo, inflictor)
	if mo and mo.valid and inflictor and inflictor.type == MT_CACTISPIKE
		if inflictor.instakill
			P_KillMobj(mo, inflictor)
		end
	end
end, MT_PLAYER)

addHook("MobjDamage", function(mo, inflictor) -- AGGMEN GETS HIT BY SUNIC, TOILZ OR KNOOSKLES
	mo.frame = V
	mo.invframes = TICRATE*2
	S_StartSound(mo, sfx_dmpain)
	if inflictor and inflictor.valid
		mo.target = inflictor
	end
end, MT_RRZBOSS)

addHook("MobjCollide", function(mo, touch)
	if mo and mo.valid
	and touch and touch.valid
	and not mo.spikesdown
	and touch.z+touch.height > mo.z-FRACUNIT*90
	and touch.type == MT_PLAYER
		if touch.RRZ_cactishield
			P_InstaThrust(touch, mo.angle, touch.player.speed)
		else
			P_DamageMobj(touch, mo, mo)
		end
	end
end, MT_RRZBOSS)

addHook("MobjThinker", function(mo)

	if mo and mo.valid	-- obligatory silver paranoia

		if not mo.phase then mo.phase = 1 end
		if not mo.target then P_LookForPlayers(mo, 2048*FRACUNIT, true) end
		if mo.nextattacktime == nil then mo.nextattacktime = TICRATE*3 end
		if not mo.attacktime then mo.attacktime = 0 end
		if not mo.center_point
			local point = P_SpawnMobj(mo.x, mo.y, mo.z, MT_THOK)
			point.state = S_INVISIBLE
			mo.center_point = point			-- we'll use this later.
		end

		if mo.egg
		and leveltime % 3==0
			local steam = P_SpawnMobj(mo.x+P_RandomRange(-25, 25)*FRACUNIT, mo.y+P_RandomRange(-25, 25)*FRACUNIT, mo.z+P_RandomRange(20, 50)*FRACUNIT, MT_SMOKE)
			P_SetObjectMomZ(steam, P_RandomRange(1, 3)*FRACUNIT)
			local burn = P_SpawnMobj(mo.x+P_RandomRange(-25, 25)*FRACUNIT, mo.y+P_RandomRange(-25, 25)*FRACUNIT, mo.z+P_RandomRange(20, 50)*FRACUNIT, MT_THOK)
			P_SetObjectMomZ(burn, P_RandomRange(1, 3)*FRACUNIT)
			burn.momx = P_RandomRange(-1, 1)*FRACUNIT
			burn.momy = P_RandomRange(-1, 1)*FRACUNIT
			burn.sprite = SPR_FPRT
		end

		if not mo.maxhealth
			mo.maxhealth = mo.health
		end

		if mo.target
			mo.target.disp_rrz_boss_bar = mo
		end

		mo.dispoffset = -64

		if not mo.cactis_back
		and not mo.cactis_orb
		and not mo.cactis_front


			local cactis_orb = P_SpawnMobj(mo.x, mo.y, mo.z, MT_OVERLAY)
			cactis_orb.state = S_CACTISHIELD_ORB_B1
			cactis_orb.target = mo
			mo.cactis_orb = cactis_orb

			local cactis_front = P_SpawnMobj(mo.x, mo.y, mo.z, MT_OVERLAY)
			cactis_front.state = S_CACTISHIELD_FRONT_B1
			cactis_front.target = mo
			mo.cactis_front = cactis_front

			local cactis_back = P_SpawnMobj(mo.x, mo.y, mo.z, MT_OVERLAY)
			cactis_back.state = S_CACTISHIELD_BACK_B1
			cactis_back.target = mo
			mo.cactis_back = cactis_back
		end

		if mo.spikesdown
			mo.spikesdown = $-1
			mo.cactis_back.flags2 = $|MF2_DONTDRAW
			mo.cactis_front.flags2 = $|MF2_DONTDRAW
			mo.cactis_orb.flags2 = $|MF2_DONTDRAW

			if mo.spikesdown < TICRATE*1
			and leveltime % 3 == 0
				mo.cactis_front.flags2 = $ & ~MF2_DONTDRAW
				mo.cactis_back.flags2 = $ & ~MF2_DONTDRAW
				mo.cactis_orb.flags2 = $ & ~MF2_DONTDRAW
			end
		else
			mo.cactis_front.flags2 = $ & ~MF2_DONTDRAW
			mo.cactis_back.flags2 = $ & ~MF2_DONTDRAW
			mo.cactis_orb.flags2 = $ & ~MF2_DONTDRAW
		end

		if mo.egg
			mo.spikesdown = 69*TICRATE -- kk prout
		end

		if mo.health <= 0
		and not mo.egg
			mo.flags2 = $|MF2_FRET
			mo.spikesdown = TICRATE*69 -- lol ecks dee
			if leveltime % 5 == 0

				local boom = P_SpawnMobj(mo.x+P_RandomRange(-70, 70)*FRACUNIT, mo.y+P_RandomRange(-70, 70)*FRACUNIT, mo.z+P_RandomRange(0, 40)*FRACUNIT, MT_BOSSEXPLODE)
				S_StartSound(boom, sfx_pop, p)

			end

		end

		if mo.flags2 & MF2_FRET		-- HIT, HELIOBERSERK FINISHER (0 HP)
		and mo.invframes
		and mo.health == 0
		and not mo.attacktime
			mo.invframes = 69*TICRATE -- mdr les memes.

			if not mo.ftime
				mo.ftime = 0
				mo.spikes_time = 0
				mo.spike_n = 0
			end
			mo.ftime = $+1

			if mo.ftime <= TICRATE
				P_InstaThrust(mo, 0, 0)
			end

			if mo.ftime >= TICRATE
			and mo.ftime <= TICRATE*2
				if not mo.finish_ready

					mo.ftime = TICRATE

					mo.angle = R_PointToAngle2(mo.x, mo.y, mo.center_point.x, mo.center_point.y)
					P_InstaThrust(mo, mo.angle, 14*FRACUNIT)
					P_SpawnGhostMobj(mo)

					if R_PointToDist2(mo.x, mo.y, mo.center_point.x, mo.center_point.y) <= 7*FRACUNIT
						P_InstaThrust(mo, 0, 0)
						P_SetOrigin(mo, mo.center_point.x, mo.center_point.y, mo.z)
						A_FaceTarget(mo)
						mo.finish_ready = true

						mo.sun_table = {}
						local orb = P_SpawnMobj(mo.x, mo.y, mo.z+mo.height/2, MT_THOK)
						mo.charge_orb = orb
						orb.flags2 = $|MF2_DONTDRAW
						orb.scale = FRACUNIT/5
						orb.tics = -1
						orb.sprite = SPR_SOLA
						orb.color = SKINCOLOR_YELLOW

					end
				end
			end

			if mo.ftime >= TICRATE*5
			and mo.ftime <= TICRATE*13

				if mo.ftime == TICRATE*5
					S_StartSound(nil, sfx_bechrg)
				end

				if leveltime %2 == 0
					mo.charge_orb.flags2 = $|MF2_DONTDRAW
				else
					mo.charge_orb.flags2 = $ & ~MF2_DONTDRAW
				end

				if mo.ftime <= TICRATE*9
					mo.charge_orb.scale = $+FRACUNIT/30
				end
				mo.charge_orb.frame = A|FF_FULLBRIGHT

				for k,v in ipairs(mo.sun_table)
					if v and v.valid
						v.momx = (mo.x - v.x) /8
						v.momy = (mo.y - v.y) /8
						v.momz = (mo.z - v.z) /8
					end
				end

				if leveltime %5 == 0
				and mo.ftime <= TICRATE*9
					for i = 1,2
						local h_angle = P_RandomRange(1, 359)*ANG1
						local v_angle = P_RandomRange(1, 359)*ANG1
						local dist = 256
						local spd = P_RandomRange(40, 50)

						local s_x = mo.x+ dist*FixedMul(cos(h_angle), cos(v_angle))
						local s_y = mo.y+ dist*FixedMul(sin(h_angle), cos(v_angle))
						local s_z = (mo.z+mo.height/2)+ dist* sin(v_angle)

						local spike = P_SpawnMobj(s_x, s_y, s_z, MT_THOK)
						spike.color = SKINCOLOR_YELLOW
						spike.sprite = SPR_SOLA
						spike.frame = A
						spike.target = mo -- dont damage self rofl
						spike.scale = FRACUNIT/4
						spike.frame = $1|FF_FULLBRIGHT
						spike.destscale = FRACUNIT*3
						--S_StartSound(spike, sfx_spkdth)
						table.insert(mo.sun_table, spike)
					end
				end
			end

			if mo.helio_finisher and mo.helio_finisher.valid
				if leveltime %2 == 0
					mo.helio_finisher.flags2 = $|MF2_DONTDRAW
				else
					mo.helio_finisher.flags2 = $ & ~MF2_DONTDRAW
				end
			end

			if mo.ftime >= TICRATE*13
			and mo.ftime <= TICRATE*19

				mo.charge_orb.flags2 = $|MF2_DONTDRAW
				if mo.ftime == TICRATE*13+1
					S_StartSound(nil, sfx_beam)
				end

				if mo.ftime == TICRATE*15
					S_StartSound(nil, sfx_s3k53)

					if mo.target

						local t = P_SpawnMobj(0,0,0,MT_OVERLAY)
						t.state = S_THOK
						t.target = mo.target
						t.frame = D
						t.sprite = SPR_TARG
						t.tics = TICRATE*4
						mo.target.rrz_target = t
					end
				end

				if mo.target.rrz_target and mo.target.rrz_target.valid

					if leveltime%2 == 0
						mo.target.rrz_target.flags2 = $|MF2_DONTDRAW
					else
						mo.target.rrz_target.flags2 = $1 & ~MF2_DONTDRAW
					end
				end

				if not mo.helio_finisher

					local b = P_SpawnMobj(mo.x, mo.y, mo.z+390*FRACUNIT, MT_CACTISPIKE)
					b.scale = FRACUNIT/4
					b.instakill = true
					b.state = S_THOK
					b.sprite = SPR_SOLA
					b.frame = B|FF_FULLBRIGHT
					b.tics = -1
					b.color = SKINCOLOR_YELLOW
					mo.helio_finisher = b
				end

				if mo.helio_finisher and mo.helio_finisher.valid
				and mo.ftime < TICRATE*15
					mo.helio_finisher.scale = $+FRACUNIT/10
				end

				if leveltime %3 == 0
				and mo.ftime < TICRATE*15

					local orb = P_SpawnMobj(mo.x, mo.y, mo.z, MT_CACTISPIKE)
					orb.target = mo
					orb.state = S_THOK
					orb.tics = 13
					orb.sprite = SPR_SOLA
					orb.scale = FRACUNIT*3/2
					orb.destscale = FRACUNIT/5
					orb.color = SKINCOLOR_YELLOW
					orb.frame = A|FF_FULLBRIGHT
					P_InstaThrust(orb, P_RandomRange(0,359)*ANG1, P_RandomRange(0, 7)*FRACUNIT)
					P_SetObjectMomZ(orb, 20*FRACUNIT)

				end
			end

			if mo.ftime == TICRATE*19

				S_StartSound(nil, sfx_s3k54)

				local b = mo.helio_finisher
				b.momx = (mo.target.x - b.x) / 128
				b.momy = (mo.target.y - b.y) / 128
				b.momz = ((mo.target.z+mo.target.height/2) - b.z) / 128

				b.sx = b.momx
				b.sy = b.momy

				--b.flags = $|MF_NOCLIP
				--b.flags = $|MF_NOCLIPHEIGHT
				b.flags = $ & ~MF_MISSILE
			end

			if mo.ftime > TICRATE*19
			and mo.helio_finisher and mo.helio_finisher.valid
				local b = mo.helio_finisher

				if P_IsObjectOnGround(b)
				or b.sx ~= b.momx
				or b.sy ~= b.momy
					P_NukeEnemies(b, b, 1536*FRACUNIT)
					/*for mobj in thinkers.iterate("mobj")
						if R_PointToDist2(b.x, b.y, mobj.x, mobj.y) < 1536*FRACUNIT
							print("fuck")
							P_KillMobj(mobj, nil, nil)
						end
					end*/

					S_StartSound(nil, sfx_bkpoof)

					for p in players.iterate
						P_FlashPal(p, 4, TICRATE/2)

						if p.mo and p.mo.valid
						local mo = p.mo

							--print(R_PointToDist2(b.x, b.y, p.mo.x, p.mo.y) / FRACUNIT)

							if R_PointToDist2(b.x, b.y, p.mo.x, p.mo.y) <= 1536*FRACUNIT
								P_KillMobj(p.mo)
							end
						end
					end


					P_SetOrigin(mo, mo.x, mo.y, mo.floorz)
					mo.sprite = SPR_EGGG
					mo.scale = FRACUNIT*3
					mo.flags = MF_SCENERY
					mo.flags2 = $ & ~MF2_FRET
					local sign = P_SpawnMobj(mo.x, mo.y, mo.z+24*FRACUNIT, MT_SIGN)
					sign.dispoffset = -1
					sign.flags = $|MF_NOGRAVITY
					mo.subsector.sector.specialflags = $ | SSF_EXIT
					mo.egg = true
					mo.dispoffset = 16

					if b and b.valid
						P_RemoveMobj(b)
					end
				end
			end
		end

		if mo.flags2 & MF2_FRET		-- HIT, PINCH PHASE ACTIVATION
		and mo.invframes
		and mo.health == 5
		and not mo.attacktime

			if not mo.ptime
				mo.ptime = 0
				mo.spikes_time = 0
				mo.spike_n = 0
			end
			mo.ptime = $+1

			if mo.ptime <= TICRATE
				P_InstaThrust(mo, 0, 0)
			end

			if mo.ptime >= TICRATE
			and mo.ptime <= TICRATE*2
				if not mo.pinch_ready

					mo.ptime = TICRATE

					mo.angle = R_PointToAngle2(mo.x, mo.y, mo.center_point.x, mo.center_point.y)
					P_InstaThrust(mo, mo.angle, 14*FRACUNIT)
					P_SpawnGhostMobj(mo)

					if R_PointToDist2(mo.x, mo.y, mo.center_point.x, mo.center_point.y) <= 7*FRACUNIT
						P_InstaThrust(mo, 0, 0)
						P_SetOrigin(mo, mo.center_point.x, mo.center_point.y, mo.z)
						A_FaceTarget(mo)
						mo.pinch_ready = true
					end
				end
			end


			if mo.ptime == TICRATE*2+TICRATE/2
				cactiSpikeBurst_Boss(mo, true)
			end

			if mo.ptime == TICRATE*2+TICRATE/2+TICRATE/4
				for k,v in ipairs(mo.spikes)

					if v and v.valid
						P_InstaThrust(v, 0, 0)
						P_SetObjectMomZ(v, 0)
						v.frame = D
						v.angle = R_PointToAngle2(v.x, v.y, v.target.target.x, v.target.target.y)
						v.tracer = v.target.target
					else
						table.remove(mo.spikes, k)
					end
				end
				mo.spikes_time = #mo.spikes*3
				mo.spike_n = 1
				mo.spikesdown = 0
			end

			if mo.ptime >= TICRATE*3

				mo.spikes_time = $-1

				if mo.spikes_time %3 == 0

					for k,v in ipairs(mo.spikes)

						if k == mo.spike_n
						and v and v.valid
							P_SetObjectMomZ(v, 50*FRACUNIT)
							S_StartSound(v, sfx_zoom)
							v.frame = D
							local g = P_SpawnGhostMobj(v)
							g.destscale = FRACUNIT*5
							g.fuse = 10
						end
					end
					mo.spike_n = $+1
				end
			end

			if mo.ptime == TICRATE*5

				-- find sector tag

				local wtag = mo.center_point.subsector.sector.tag

				S_StartSound(nil, sfx_crumbl)

				for sec in sectors.iterate do	-- here we go...



					if sec and sec.tag == wtag

						for rover in sec.ffloors()
							if rover and rover.valid then
								--EV_CrumbleChain(sec, rover) -- boom
								rover.sector.floorheight = -6969*FRACUNIT
								rover.sector.ceilingheight = -6969*FRACUNIT
							end
						end
					end
				end

				for p in players.iterate
					P_FlashPal(p, 1, TICRATE/2)
				end
			end

			-- we have one major problem, there's a metric fuckton of rocks on the screen now, let's remove them.

			/*if mo.ptime == TICRATE*5+1

				for mobj in thinkers.iterate("mobj") -- let's drop some frames faggot
					if mobj and mobj.type >= MT_FALLINGROCK and mobj.type <= MT_ROCKCRUMBLE16
						print("fuck you")
						P_RemoveMobj(mobj)
					end
				end
			end*/

			if mo.ptime == TICRATE*5+TICRATE/2
				P_InstaThrust(mo, 0, 0)
				mo.frame = A
				A_FaceTarget(mo)
				mo.flags2 = $ & ~MF2_FRET
				mo.nextattacktime = TICRATE*3
				mo.attack = nil
				mo.attacktime = 0
				mo.invframes = 0
			end
		end

		if mo.flags2 & MF2_FRET		-- HIT, NORMAL CIRCUMSTANCES
		and mo.invframes
		and mo.health ~= 5
		and mo.health ~= 0
		and not mo.attacktime
			mo.invframes = $-1

			if mo.invframes >= TICRATE*2-TICRATE/2
				P_InstaThrust(mo, 0, 0)
			end

			if mo.invframes == TICRATE*1-TICRATE/2
				A_FaceTarget(mo)
				mo.angle = $+180*ANG1
				P_InstaThrust(mo, mo.angle, 45*FRACUNIT)
			end

			if mo.invframes < TICRATE*1-TICRATE/2
				P_SpawnGhostMobj(mo)
			end

			if mo.invframes < 1
				P_InstaThrust(mo, 0, 0)
				mo.frame = A
				A_FaceTarget(mo)
				mo.flags2 = $ & ~MF2_FRET
				mo.invframes = 0
			end
		end

		if mo.target and mo.target.valid	-- aggmen found sanic, telz or knooskles

			if not mo.invframes

				if mo.nextattacktime
					A_FaceTarget(mo, 0, 0)
					P_InstaThrust(mo, mo.angle, 8*FRACUNIT)
					mo.nextattacktime = max(0,$-1)
					mo.spikes_time = nil
					mo.attacktime = 0
				else
					if not mo.attacktime

						local minatt = 1
						local maxatt = 3

						if mo.health <= 5
							minatt = 4
							maxatt = 7
						end
						P_InstaThrust(mo, 0, 0)
						mo.attacktime = 0
						mo.attack = 0
						mo.attack = P_RandomRange(minatt, maxatt)
						mo.smashsound = nil
					end
				end
			end

			if mo.attack then mo.attacktime = $+1 else mo.attacktime = 0 end

			if mo.attack == 7				-- SOLAR BEAM

				if not mo.attack_3_ready
					mo.attacktime = 1
					mo.angle = R_PointToAngle2(mo.x, mo.y, mo.center_point.x, mo.center_point.y)
					P_InstaThrust(mo, mo.angle, 14*FRACUNIT)
					P_SpawnGhostMobj(mo)

					if R_PointToDist2(mo.x, mo.y, mo.center_point.x, mo.center_point.y) <= 7*FRACUNIT
						P_InstaThrust(mo, 0, 0)
						P_SetOrigin(mo, mo.center_point.x, mo.center_point.y, mo.z)
						A_FaceTarget(mo)
						mo.attack_3_ready = true
						mo.sun_table = {}
						local orb = P_SpawnMobj(mo.x, mo.y, mo.z+mo.height/2, MT_THOK)
						mo.charge_orb = orb
						orb.flags2 = $|MF2_DONTDRAW
						orb.scale = FRACUNIT/5
						orb.tics = -1
						orb.sprite = SPR_SOLA
						orb.color = SKINCOLOR_YELLOW
					end
				end

				if mo.attacktime >= TICRATE/2
				and mo.attacktime <= TICRATE*5

					if mo.attacktime == TICRATE/2
						S_StartSound(nil, sfx_bechrg)
					end

					if leveltime %2 == 0
						mo.charge_orb.flags2 = $|MF2_DONTDRAW
					else
						mo.charge_orb.flags2 = $ & ~MF2_DONTDRAW
					end

					mo.charge_orb.scale = $+FRACUNIT/60
					mo.charge_orb.frame = A|FF_FULLBRIGHT
					--P_MoveOrigin(mo.charge_orb, mo.x, mo.y, mo.z - mo.scale*10)

					for k,v in ipairs(mo.sun_table)
						if v and v.valid
							v.momx = (mo.x - v.x) /8
							v.momy = (mo.y - v.y) /8
							v.momz = (mo.z - v.z) /8
						end
					end

					if leveltime %5 == 0
					and mo.attacktime <= TICRATE*4
						for i = 1,2
							local h_angle = P_RandomRange(1, 359)*ANG1
							local v_angle = P_RandomRange(1, 359)*ANG1
							local dist = 256
							local spd = P_RandomRange(40, 50)

							local s_x = mo.x+ dist*FixedMul(cos(h_angle), cos(v_angle))
							local s_y = mo.y+ dist*FixedMul(sin(h_angle), cos(v_angle))
							local s_z = (mo.z+mo.height/2)+ dist* sin(v_angle)

							local spike = P_SpawnMobj(s_x, s_y, s_z, MT_THOK)
							spike.color = SKINCOLOR_YELLOW
							spike.sprite = SPR_SOLA
							spike.frame = A
							spike.target = mo -- dont damage self rofl
							spike.scale = FRACUNIT/4
							spike.frame = $1|FF_FULLBRIGHT
							spike.destscale = FRACUNIT*3
							--S_StartSound(spike, sfx_spkdth)
							table.insert(mo.sun_table, spike)
						end
					end
				end

				if mo.attacktime >= TICRATE*3
				and mo.attacktime <= TICRATE*5

					if mo.attacktime == TICRATE*3+1

						if mo.target

							local t = P_SpawnMobj(0,0,0,MT_OVERLAY)
							t.state = S_THOK
							t.target = mo.target
							t.frame = D
							t.sprite = SPR_TARG
							t.tics = TICRATE*2
							mo.target.rrz_target = t
						end
					end

					if mo.target.rrz_target and mo.target.rrz_target.valid

						if leveltime%2 == 0
							mo.target.rrz_target.flags2 = $|MF2_DONTDRAW
						else
							mo.target.rrz_target.flags2 = $1 & ~MF2_DONTDRAW
						end
					end
				end

				if mo.attacktime == TICRATE*5
					S_StartSound(nil, sfx_beam)
				end

				if mo.attacktime >= TICRATE*5
				and mo.attacktime <= TICRATE*7+TICRATE/4
					if mo.charge_orb and mo.charge_orb.valid
						P_RemoveMobj(mo.charge_orb)
						mo.charge_orb = nil
					end

					A_FaceTarget(mo)

					//for i = 1,2

						local h_angle = R_PointToAngle2(mo.x, mo.y, mo.target.x, mo.target.y)
						local dist = 32*(i-1)

						local s_x = mo.x+ dist*cos(h_angle)
						local s_y = mo.y+ dist*sin(h_angle)
						//local f = P_SpawnMobj(s_x, s_y, mo.z, MT_CACTISPIKE)
						local f = P_SpawnPointMissile(mo, mo.target.x, mo.target.y, mo.target.z, MT_CACTISPIKE, mo.x, mo.y, mo.z)
						local targetmark = P_SpawnMobj(mo.target.x, mo.target.y, mo.target.z+mo.target.height/2, MT_THOK)
						if (targetmark and targetmark.valid)
							targetmark.state = S_INVISIBLE
							targetmark.tics = 1
						end
						if (f and f.valid)
							//f.state = S_THOK
							f.angle = h_angle
							f.sprite = SPR_SOLA
							f.frame = C|FF_FULLBRIGHT
							//P_InstaThrust(f, f.angle, 60*FRACUNIT)
							f.tracer = targetmark
							A_HomingChase(f, 60*FRACUNIT, 1)
							f.tics = -1
							f.target = mo
							f.flags = $|MF_MISSILE
							f.scale = FRACUNIT*3/2
							f.color = SKINCOLOR_YELLOW
							f.instakill = true
							mo.spikesdown = TICRATE*3
						end
					//end
				end

				if mo.attacktime == TICRATE*8+TICRATE/4

					mo.attack = nil
					mo.attacktime = nil
					mo.nextattacktime = TICRATE*5
					mo.attack_3_ready = nil
				end

			end

			if mo.attack == 6				-- SPIKEBALL / PINCH

				mo.friction = FRACUNIT+ FRACUNIT/69

				if mo.attacktime == TICRATE/2
					P_SetObjectMomZ(mo, -20*FRACUNIT)
				end

				if mo.attacktime >= TICRATE/2
				and mo.attacktime <= TICRATE+TICRATE/2
				and P_IsObjectOnGround(mo)
				and not mo.smashsound
					S_StartSound(nil, sfx_s3k5f)
					mo.smashsound = true
				end

				if mo.attacktime == TICRATE+TICRATE/2

					mo.flags = $|MF_BOUNCE
					mo.flags = $ & ~MF_NOGRAVITY
					mo.flags = $ & ~MF_FLOAT
					--A_FaceTarget(mo)
					P_InstaThrust(mo, mo.angle, 75*FRACUNIT)
					S_StartSound(nil, sfx_zoom)
				end

				if mo.attacktime >= TICRATE+TICRATE/2
				and mo.attacktime <= TICRATE*7
					local rock = P_SpawnMobj(mo.x + P_RandomRange(-15, 15)*FRACUNIT, mo.y + P_RandomRange(-15, 15)*FRACUNIT, mo.z, MT_PLAYER)
					S_StartSound(rock, sfx_s3k59)
					rock.flags = MF_SCENERY
					rock.fuse = TICRATE
					rock.sprite = SPR_ROIA
					rock.scale = FRACUNIT/4
					P_SetObjectMomZ(rock, P_RandomRange(10, 15)*FRACUNIT)


					mo.angle = $1 + ANG1*20
					if leveltime % 3 == 0

						local h_angle = P_RandomRange(1, 359)*ANG1
						local v_angle = P_RandomRange(3, 20)*ANG1
						local dist = 64
						local spd = P_RandomRange(40, 50)

						local s_x = mo.x+ dist*FixedMul(cos(h_angle), cos(v_angle))
						local s_y = mo.y+ dist*FixedMul(sin(h_angle), cos(v_angle))
						local s_z = (mo.z+mo.height/2)+ dist* sin(v_angle)

						local spike = P_SpawnMobj(s_x, s_y, s_z, MT_CACTISPIKE)
						spike.frame = A
						spike.angle = h_angle
						spike.target = mo -- dont damage self rofl
						spike.home = 1
						spike.tracer = mo.target
						spike.scale = FRACUNIT*2
						spike.momx = spd * FixedMul(cos(h_angle), cos(v_angle))
						spike.momy = spd * FixedMul(sin(h_angle), cos(v_angle))
						spike.momz = spd * sin(v_angle)
						spike.flags = $ & ~MF_NOGRAVITY
						spike.flags = $ & ~MF_FLOAT
						S_StartSound(spike, sfx_spkdth)
					end
				end
				if mo.attacktime == TICRATE*7
					P_InstaThrust(mo, 0, 0)
				end

				if mo.attacktime == TICRATE*7 + TICRATE/2
					cactiSpikeBurst_Boss(mo)
					P_SetObjectMomZ(mo, 15*FRACUNIT)
					mo.flags = $ & ~MF_BOUNCE
					mo.flags = $|MF_NOGRAVITY
				end

				if mo.attacktime == TICRATE*7 + TICRATE/2 + TICRATE/6
					P_SetObjectMomZ(mo, 0)
					A_FaceTarget(mo)
				end

				if mo.attacktime == TICRATE*8 + TICRATE/2
					mo.attack = nil
					mo.attacktime = nil
					mo.nextattacktime = TICRATE*5
				end
			end

			if mo.attack == 5				-- MAD SPINSPIKE / PINCH

				if not mo.attack_3_ready
					mo.attacktime = 1
					mo.angle = R_PointToAngle2(mo.x, mo.y, mo.center_point.x, mo.center_point.y)
					P_InstaThrust(mo, mo.angle, 14*FRACUNIT)
					P_SpawnGhostMobj(mo)

					if R_PointToDist2(mo.x, mo.y, mo.center_point.x, mo.center_point.y) <= 7*FRACUNIT
						P_InstaThrust(mo, 0, 0)
						P_SetOrigin(mo, mo.center_point.x, mo.center_point.y, mo.z)
						A_FaceTarget(mo)
						mo.attack_3_ready = true
					end
				end

				if mo.attacktime == TICRATE/2
					P_SetObjectMomZ(mo, -20*FRACUNIT)
				end

				if mo.attacktime >= TICRATE/2
				and mo.attacktime <= TICRATE+TICRATE/2
				and P_IsObjectOnGround(mo)
				and not mo.smashsound
					S_StartSound(nil, sfx_s3k5f)
					mo.smashsound = true
				end


				if mo.attacktime >= TICRATE+TICRATE/2
				and mo.attacktime <= TICRATE*7

					mo.angle = $1 + ANG1*20

					for i=1,2

					local h_angle = P_RandomRange(1, 359)*ANG1
					local v_angle = P_RandomRange(3, 20)*ANG1
					local dist = 64
					local spd = P_RandomRange(40, 50)

					local s_x = mo.x+ dist*FixedMul(cos(h_angle), cos(v_angle))
					local s_y = mo.y+ dist*FixedMul(sin(h_angle), cos(v_angle))
					local s_z = (mo.z+mo.height/2)+ dist* sin(v_angle)

					local spike = P_SpawnMobj(s_x, s_y, s_z, MT_CACTISPIKE)
					spike.frame = A
					spike.angle = h_angle
					spike.target = mo -- dont damage self rofl
					spike.home = 1
					spike.tracer = mo.target
					spike.scale = FRACUNIT*2
					spike.momx = spd * FixedMul(cos(h_angle), cos(v_angle))
					spike.momy = spd * FixedMul(sin(h_angle), cos(v_angle))
					spike.momz = spd * sin(v_angle)
					spike.flags = $ & ~MF_NOGRAVITY
					spike.flags = $ & ~MF_FLOAT
					S_StartSound(spike, sfx_spkdth)
					end
				end

				if mo.attacktime >= TICRATE*7
				and mo.attacktime <= TICRATE*7 + TICRATE/2
					mo.angle = $+ANG1*10
				end

				if mo.attacktime >= TICRATE*7 + TICRATE/2
				and mo.attacktime <= TICRATE*8
					mo.angle = $+ANG1*5
				end

				if mo.attacktime == TICRATE*9
					A_FaceTarget(mo)
					cactiSpikeBurst_Boss(mo)
					P_SetObjectMomZ(mo, 15*FRACUNIT)
				end

				if mo.attacktime == TICRATE*9 + TICRATE/6
					P_SetObjectMomZ(mo, 0)
					A_FaceTarget(mo)
				end

				if mo.attacktime == TICRATE*10+TICRATE/2
					mo.attack = nil
					mo.attacktime = nil
					mo.nextattacktime = TICRATE*5
					mo.attack_3_ready = nil
				end
			end

			if mo.attack == 4				-- HOMING SPIKE BURST / PINCH

				if mo.attacktime == TICRATE/2
					cactiSpikeBurst_Boss(mo, true)
				end

				if mo.attacktime == TICRATE/2 + TICRATE/4
					for k,v in ipairs(mo.spikes)

						if v and v.valid
							v.tptable = {v.x, v.y, v.z}
							P_InstaThrust(v, 0, 0)
							P_SetObjectMomZ(v, 0)
							v.frame = A
							v.angle = R_PointToAngle2(v.x, v.y, v.target.target.x, v.target.target.y)
							v.tracer = v.target.target
						else
							table.remove(mo.spikes, k)
						end
					end
					mo.spikes_time = #mo.spikes*3
					mo.spike_n = 1
					mo.spikesdown = $+mo.spikes_time-TICRATE*2
				end

				if mo.attacktime >= TICRATE/2 + TICRATE/4
					for k,v in ipairs(mo.spikes)
						if v and v.valid and not v.shot and v.tptable
							P_MoveOrigin(v, v.tptable[1], v.tptable[2], v.tptable[3])
							v.momz = 0
						else
							if mo.attacktime <= TICRATE*1+TICRATE/2
								table.remove(mo.spikes, k)
							end
						end
					end
				end

				if mo.attacktime >= TICRATE*1+TICRATE/2
				--and mo.attacktime <= TICRATE*2+mo.spikes_time + 2*TICRATE

					mo.spikes_time = $-1

					if mo.spikes_time %3 == 0

						for k,v in ipairs(mo.spikes)

							if k == mo.spike_n
							and v and v.valid
								v.shot = true
								A_HomingChase(v, 80*FRACUNIT, 1)
								S_StartSound(v, sfx_zoom)
								v.frame = A
								local g = P_SpawnGhostMobj(v)
								g.destscale = FRACUNIT*5
								g.fuse = 10
							end
						end

						mo.spike_n = $+1
					end
				end

				if mo.spikes_time == 0
					mo.attack = nil
					mo.attacktime = 0
					mo.nextattacktime = TICRATE*5
				end
			end


			if mo.attack == 3				-- MAD SPINSPIKE / NORMAL

				if not mo.attack_3_ready
					mo.attacktime = 1
					mo.angle = R_PointToAngle2(mo.x, mo.y, mo.center_point.x, mo.center_point.y)
					P_InstaThrust(mo, mo.angle, 14*FRACUNIT)
					P_SpawnGhostMobj(mo)

					if R_PointToDist2(mo.x, mo.y, mo.center_point.x, mo.center_point.y) <= 7*FRACUNIT
						P_InstaThrust(mo, 0, 0)
						P_SetOrigin(mo, mo.center_point.x, mo.center_point.y, mo.z)
						A_FaceTarget(mo)
						mo.attack_3_ready = true
					end
				end

				if mo.attacktime == TICRATE/2
					P_SetObjectMomZ(mo, -20*FRACUNIT)
				end

				if mo.attacktime >= TICRATE/2
				and mo.attacktime <= TICRATE+TICRATE/2
				and P_IsObjectOnGround(mo)
				and not mo.smashsound
					S_StartSound(nil, sfx_s3k5f)
					mo.smashsound = true
				end


				if mo.attacktime >= TICRATE+TICRATE/2
				and mo.attacktime <= TICRATE*7

					mo.angle = $1 + ANG1*20

					local h_angle = P_RandomRange(1, 359)*ANG1
					local v_angle = P_RandomRange(10, 30)*ANG1
					local dist = 64
					local spd = P_RandomRange(25, 50)

					local s_x = mo.x+ dist*FixedMul(cos(h_angle), cos(v_angle))
					local s_y = mo.y+ dist*FixedMul(sin(h_angle), cos(v_angle))
					local s_z = (mo.z+mo.height/2)+ dist* sin(v_angle)

					local spike = P_SpawnMobj(s_x, s_y, s_z, MT_CACTISPIKE)
					spike.frame = A
					spike.angle = h_angle
					spike.target = mo -- dont damage self rofl
					spike.home = 1
					spike.tracer = mo.target
					spike.scale = FRACUNIT*2
					spike.momx = spd * FixedMul(cos(h_angle), cos(v_angle))
					spike.momy = spd * FixedMul(sin(h_angle), cos(v_angle))
					spike.momz = spd * sin(v_angle)
					spike.flags = $ & ~MF_NOGRAVITY
					spike.flags = $ & ~MF_FLOAT
					S_StartSound(spike, sfx_spkdth)
				end

				if mo.attacktime >= TICRATE*7
				and mo.attacktime <= TICRATE*7 + TICRATE/2
					mo.angle = $+ANG1*10
				end

				if mo.attacktime >= TICRATE*7 + TICRATE/2
				and mo.attacktime <= TICRATE*8
					mo.angle = $+ANG1*5
				end

				if mo.attacktime == TICRATE*9
					A_FaceTarget(mo)
					cactiSpikeBurst_Boss(mo)
					P_SetObjectMomZ(mo, 15*FRACUNIT)
				end

				if mo.attacktime == TICRATE*9 + TICRATE/6
					P_SetObjectMomZ(mo, 0)
					A_FaceTarget(mo)
				end

				if mo.attacktime == TICRATE*10+TICRATE/2
					mo.attack = nil
					mo.attacktime = nil
					mo.nextattacktime = TICRATE*5
					mo.attack_3_ready = nil
				end
			end

			if mo.attack == 2				-- HOMING SPIKE BURST / NORMAL

				if mo.attacktime == TICRATE/2
					cactiSpikeBurst_Boss(mo)
				end

				if mo.attacktime == TICRATE/2 + TICRATE/4
					for k,v in ipairs(mo.spikes)

						if v and v.valid
							P_InstaThrust(v, 0, 0)
							v.tptable = {v.x, v.y, v.z}
							P_SetObjectMomZ(v, 0)
							v.frame = A
							v.angle = R_PointToAngle2(v.x, v.y, v.target.target.x, v.target.target.y)
							v.tracer = v.target.target
						else
							table.remove(mo.spikes, k)
						end
					end
					mo.spikes_time = #mo.spikes*10
					mo.spike_n = 1
					mo.spikesdown = $+mo.spikes_time-TICRATE*2
				end

				if mo.attacktime >= TICRATE/2 + TICRATE/4
					for k,v in ipairs(mo.spikes)
						if v and v.valid and not v.shot and v.tptable
							P_MoveOrigin(v, v.tptable[1], v.tptable[2], v.tptable[3])
							v.momz = 0
						else
							if mo.attacktime <= TICRATE*1+TICRATE/2
								table.remove(mo.spikes, k)
							end
						end
					end
				end

				if mo.attacktime >= TICRATE*1+TICRATE/2
				--and mo.attacktime <= TICRATE*2+mo.spikes_time + 2*TICRATE

					mo.spikes_time = $-1

					if mo.spikes_time %10 == 0

						for k,v in ipairs(mo.spikes)

							if k == mo.spike_n
							and v and v.valid
								v.shot = true
								A_HomingChase(v, 40*FRACUNIT, 1)
								S_StartSound(v, sfx_zoom)
								v.frame = A
								v.deathstate = S_RINGEXPLODE
								v.xdeathstate = S_RINGEXPLODE
								v.painchance = 192*FRACUNIT
								local g = P_SpawnGhostMobj(v)
								g.destscale = FRACUNIT*5
								g.fuse = 10
							end
						end

						mo.spike_n = $+1
					end
				end

				if mo.spikes_time == 0
				and mo.attacktime >= TICRATE*2+mo.spikes_time+TICRATE*2
					mo.attack = nil
					mo.attacktime = nil
					mo.nextattacktime = TICRATE*5
				end

			end

			if mo.attack == 1				-- SPIKEBALL / NORMAL

				mo.friction = FRACUNIT+ FRACUNIT/69

				if mo.attacktime == TICRATE/2
					P_SetObjectMomZ(mo, -20*FRACUNIT)
				end

				if mo.attacktime >= TICRATE/2
				and mo.attacktime <= TICRATE+TICRATE/2
				and P_IsObjectOnGround(mo)
				and not mo.smashsound
					S_StartSound(nil, sfx_s3k5f)
					mo.smashsound = true
				end

				if mo.attacktime == TICRATE+TICRATE/2

					mo.flags = $|MF_BOUNCE
					mo.flags = $ & ~MF_NOGRAVITY
					mo.flags = $ & ~MF_FLOAT
					--A_FaceTarget(mo)
					P_InstaThrust(mo, mo.angle, 55*FRACUNIT)
					S_StartSound(nil, sfx_zoom)
				end

				if mo.attacktime >= TICRATE+TICRATE/2
				and mo.attacktime <= TICRATE*7
					local rock = P_SpawnMobj(mo.x + P_RandomRange(-15, 15)*FRACUNIT, mo.y + P_RandomRange(-15, 15)*FRACUNIT, mo.z, MT_PLAYER)
					S_StartSound(rock, sfx_s3k59)
					rock.flags = MF_SCENERY
					rock.fuse = TICRATE
					rock.sprite = SPR_ROIA
					rock.scale = FRACUNIT/4
					P_SetObjectMomZ(rock, P_RandomRange(10, 15)*FRACUNIT)
				end

				if mo.attacktime == TICRATE*7
					P_InstaThrust(mo, 0, 0)
				end

				if mo.attacktime == TICRATE*7 + TICRATE/2
					cactiSpikeBurst_Boss(mo)
					P_SetObjectMomZ(mo, 15*FRACUNIT)
					mo.flags = $ & ~MF_BOUNCE
					mo.flags = $|MF_NOGRAVITY
				end

				if mo.attacktime == TICRATE*7 + TICRATE/2 + TICRATE/6
					P_SetObjectMomZ(mo, 0)
					A_FaceTarget(mo)
				end

				if mo.attacktime == TICRATE*8 + TICRATE/2
					mo.attack = nil
					mo.attacktime = nil
					mo.nextattacktime = TICRATE*5
				end
			end
		end
	end
end, MT_RRZBOSS)


addHook("ThinkFrame", do
	for p in players.iterate
		if p and p.valid
		and p.mo and p.mo.valid
		local mo = p.mo
			if mo and mo.disp_rrz_boss_bar
			and not mo.disp_rrz_boss_bar.egg
				for pp in players.iterate
					if pp and pp.valid
					and pp.mo and pp.mo.valid
						local mmo = pp.mo
						mmo.disp_rrz_boss_bar = mo.disp_rrz_boss_bar

						if mmo.disp_rrz_boss_bar.health <= 5
						and not mmo.boss_change_music
							S_ChangeMusic("BOSPIN", true, pp)
						end
					end
				end
			end
		end
	end
end)

hud.add(function(v,p)

	if p and p.valid
	and p.mo and p.mo.valid
	and p.mo.disp_rrz_boss_bar
	and p.mo.disp_rrz_boss_bar.valid
	and not p.mo.disp_rrz_boss_bar.egg

			local scrwidth = v.width() / v.dupx()
			local scrheight = v.height() / v.dupy()


			local boss = p.mo.disp_rrz_boss_bar
			--print(boss.health.."|"..boss.maxhealth)

			local whiteColor = 1
			local blackColor = 31
			local redColor = 34
			local greenColor = 112

			v.drawFill(scrwidth-(10*boss.maxhealth), 0, 10*boss.maxhealth, 7, redColor|V_SNAPTOTOP|V_SNAPTOLEFT)
			v.drawFill(scrwidth-(10*boss.maxhealth), 0, 10*boss.health, 7, greenColor|V_SNAPTOTOP|V_SNAPTOLEFT)

			v.drawFill(scrwidth-(10*boss.maxhealth), 0, 10*boss.maxhealth, 1, whiteColor|V_SNAPTOTOP|V_SNAPTOLEFT)
			v.drawFill(scrwidth-(10*boss.maxhealth), 1, 10*boss.maxhealth, 1, blackColor|V_SNAPTOTOP|V_SNAPTOLEFT)

			v.drawFill(scrwidth-(10*boss.maxhealth), 6, 10*boss.maxhealth, 1, whiteColor|V_SNAPTOTOP|V_SNAPTOLEFT)
			v.drawFill(scrwidth-(10*boss.maxhealth), 7, 10*boss.maxhealth, 1, blackColor|V_SNAPTOTOP|V_SNAPTOLEFT)

			local bgraph = "RBOSS"
			if boss.health <= 5
			and leveltime %10 < 5
				bgraph = "RBOSSC"
			end

			v.draw(scrwidth-(10*boss.maxhealth)-24, 0, v.cachePatch(bgraph), V_SNAPTOTOP|V_SNAPTOLEFT)

	end
end)
