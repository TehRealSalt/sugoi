// -------------------Emerald collect/level clear handling-------------------
freeslot("MT_SMZEMERALD")

local function emeraldLookalike(mo)
	if (mapheaderinfo[gamemap].badzemerald)
		mo.frame = (states[mobjinfo[_G[mapheaderinfo[gamemap].badzemerald]].spawnstate].frame)|FF_FULLBRIGHT
	end
end

local function gibeEmerald(mo, pmo)
	if not (pmo.player and pmo.player.valid) return end

	--[[
	if (mapheaderinfo[gamemap].badzemerald)
		P_SpawnMobj(pmo.x, pmo.y, pmo.z, _G[mapheaderinfo[gamemap].badzemerald])
	end
	--]]
	sugoi.AwardEmerald(true);

	for player in players.iterate
		P_DoPlayerExit(player)
	end
end

addHook("MobjSpawn", emeraldLookalike, MT_SMZEMERALD)
addHook("TouchSpecial", gibeEmerald, MT_SMZEMERALD)

// -------------------- Emerald object behavior --------------------
addHook("MobjSpawn", function(mobj)
	mobj.floatz = mobj.z
	mobj.floatpos = 0
	mobj.fxtime = 0
end, MT_SMZEMERALD)

addHook("MobjThinker", function(mobj)
	mobj.floatpos = $1 + ANG2
	mobj.z = mobj.floatz + sin(mobj.floatpos)*16
	mobj.fxtime = $1 + 1
	if(mobj.fxtime == 8)
		mobj.fxtime = 0
		P_SpawnMobj(mobj.x+P_RandomRange(-32,32)*FRACUNIT,
					mobj.y+P_RandomRange(-32,32)*FRACUNIT,
					mobj.z+P_RandomRange(-32,32)*FRACUNIT, MT_BOXSPARKLE)
	end
end, MT_SMZEMERALD)

// ------------------- The glider --------------------
freeslot("MT_SMZGLIDER")

local function GliderCatch (glider, collider)
	if collider.player and collider.player.bot == 0 and not collider.airglider and not collider.player.exiting
		if collider.player.rings == 0
			P_DoPlayerExit(collider.player)
			P_Thrust(collider,collider.angle,2*FRACUNIT)
		else
			collider.airglider = glider
			glider.target = collider
			glider.draintimer = 0
			glider.boost = 0
			glider.exploded = false
			glider.state = glider.info.seestate
			P_SpawnMobjFromMobj(glider, 0, 0, 0, MT_SMZGLIDER);
		end
	end
	return true
end

addHook("TouchSpecial", GliderCatch, MT_SMZGLIDER)

local function GliderFly(actor)
	local owner = actor.target
	if owner != nil
		if owner.valid and owner.player.rings > 0 and not owner.player.exiting and not actor.exploded
			if (owner.player.cmd.forwardmove > 0)
				actor.momz = min($1 + FRACUNIT/2, 15*FRACUNIT)
			elseif (owner.player.cmd.forwardmove < 0)
				actor.momz = max($1 - FRACUNIT/2, -15*FRACUNIT)
			else
				actor.momz = $1 - $1/20
			end
			if(owner.player.cmd.sidemove > 0)
				P_Thrust(actor,owner.angle-ANG30*3,(FRACUNIT/4)*3)
			elseif (owner.player.cmd.sidemove < 0)
				P_Thrust(actor,owner.angle+ANG30*3,(FRACUNIT/4)*3)
			end
			P_Thrust(actor,owner.angle,2*FRACUNIT-FRACUNIT/10)
			actor.momx = $1 - $1/18
			actor.momy = $1 - $1/18

			owner.momx = actor.momx
			owner.momy = actor.momy
			owner.momz = actor.momz
			owner.state = S_PLAY_RIDE
			owner.player.panim = PA_RIDE
			owner.player.drawangle = owner.angle
			A_CapeChase(actor, 44*FRACUNIT, -3)

			actor.draintimer = $1 + 1
			if actor.draintimer == 35
				actor.draintimer = 0
				owner.player.rings = $1 - 1
				local xpos = sin(-actor.angle)*32
				local ypos = cos(-actor.angle)*32
				P_SpawnMobj(actor.x+xpos,actor.y+ypos,actor.z,MT_SPARK)
				P_SpawnMobj(actor.x-xpos,actor.y-ypos,actor.z,MT_SPARK)
			end
		else
			if not actor.exploded
				if owner.valid
					owner.airglider = nil
					owner.momx = $1 / 4
					owner.momy = $1 / 4
					owner.momz = $1 / 4
					actor.exploded = true
					if not owner.player.exiting
						A_PlaySound(owner,sfx_s3kb2,1)
						P_DoPlayerExit(owner.player)
					end
				end
				P_KillMobj(actor)
			end
		end
	end
end
addHook("MobjThinker", GliderFly, MT_SMZGLIDER)


// ------------------- The mines --------------------
freeslot("MT_TDMINE", "MT_FATMINE", "MT_BLUEMINE", "MT_PURPLEMINE")

local function MineBlaster (mine, exploded)
	if(exploded.player.rings > 5 and not exploded.player.powers[pw_flashing] and not exploded.player.powers[pw_invulnerability])
		P_DoPlayerPain(exploded.player,mine,mine)
		exploded.player.rings = $1 - 5
		A_PlaySound(exploded,sfx_s3kb9,1)
		P_PlayerRingBurst(exploded.player,5)
	else
		P_DamageMobj(exploded,mine,mine)
	end
	P_KillMobj (mine)
	return true
end

addHook("TouchSpecial", MineBlaster, MT_TDMINE)
addHook("TouchSpecial", MineBlaster, MT_FATMINE)
addHook("TouchSpecial", MineBlaster, MT_BLUEMINE)
addHook("TouchSpecial", MineBlaster, MT_PURPLEMINE)

function A_ClearTarget (actor, var1, var2)
	actor.target = nil
end

// -------------------- The giant ring --------------------
freeslot("MT_SMZRING")

addHook("MobjSpawn",function(mobj)
	mobj.fxPos = 0
end,MT_SMZRING)

function A_SMZRingFX(actor,var1,var2)
	actor.fxPos = $1 + ANG20
	local position = (sin(actor.fxPos)*96)/FRACUNIT
	local xpos = sin(-actor.angle)*position
	local ypos = cos(-actor.angle)*position
	local zpos = cos(actor.fxPos)*96
	P_SpawnMobj(actor.x+xpos,actor.y+ypos,actor.z+zpos+96*FRACUNIT,var1)
	P_SpawnMobj(actor.x-xpos,actor.y-ypos,actor.z-zpos+96*FRACUNIT,var1)
end


function A_GlobalRingBox(actor,var1,var2)
	for player in players.iterate
		if (player.bot == 0)
			actor.target = player.mo
			A_RingBox(actor,var1,var2)
		end
	end
end
