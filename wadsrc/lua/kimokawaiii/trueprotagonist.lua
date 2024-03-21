freeslot(
"MT_PROTAGONIST",
"MT_PROTAGONIST_TRACER",
"MT_PROTAGONIST_WALKER1",
"MT_PROTAGONIST_WALKER2",
"MT_PROTAGONIST_WALKER3",
"MT_PROTAGONIST_MISSILE1",
"MT_PROTAGONIST_MISSILE2",
"MT_PROTAGONIST_MISSILE3",
"MT_PROTAGONIST_BULLET")

function A_CheckFuse(actor, var1, var2)
	if actor.fuse == 0
		actor.state = var2
	end
end

function A_NoTarget(actor,var1,var2)
	actor.target = nil
end

function A_ProtagShotLow(actor, var1, var2)
	A_FindTracer(actor,MT_PROTAGONIST_TRACER,0)
	if actor.tracer.target
--		print ("Aimed at tracer's target; shooting.")
		P_SpawnPointMissile(actor, actor.tracer.target.x, actor.tracer.target.y, 0, var1, actor.x, actor.y, actor.z)
	else
--		print (leveltime+" No player found! (low)")
		A_TrapShot(actor, (0*65536)+var1, (0*65536)+327)
	end
end

function A_ProtagFlash1(actor, var1, var2)
	if actor.angle == ANGLE_180
		A_SpawnObjectRelative(actor,(-15*65536)+0,(2*65536)+MT_PROTAGONIST_BULLETBLAST)
	else
		A_SpawnObjectRelative(actor,(18*65536)+0,(2*65536)+MT_PROTAGONIST_BULLETBLAST)
	end
end

function A_ProtagFlash2(actor, var1, var2)
	if actor.angle == ANGLE_180
		A_SpawnObjectRelative(actor,(-41*65536)+0,(12*65536)+MT_PROTAGONIST_BULLETBLAST_2)
	else
		A_SpawnObjectRelative(actor,(44*65536)+0,(12*65536)+MT_PROTAGONIST_BULLETBLAST_2)
	end
end

function A_ChickenCheckX(actor, var1, var2)
	if (actor.z <= actor.floorz)
		P_SetMobjStateNF(actor, var1)
	end
end

function A_Break(actor, var1, var2)
	actor.momx = actor.momx / 2
	actor.momy = actor.momy / 2
end

function A_ProtagRun(actor, var1, var2)
	if actor.momx == 0
		A_ChangeAngleRelative(actor,180,180)
	end

	A_Thrust(actor, 12, 1)
end

function A_ProtagLook(actor, var1, var2)
	A_Break(actor, var1, var2)
	if P_LookForPlayers(actor, 0, true, false)
		A_ChangeAngleRelative(actor,180,180)
		P_SetMobjStateNF(actor, var2)
	else
		P_SetMobjStateNF(actor, actor.info.spawnstate)
	end
end

function A_ProtagWalkersGo(actor, var1, var2)
	if actor.angle == ANGLE_180
		A_SpawnObjectRelative(actor,(-52*65536)+0,(40*65536)+MT_PROTAGONIST_WALKER1)
		A_SpawnObjectRelative(actor,(-52*65536)+0,(40*65536)+MT_PROTAGONIST_WALKER2)
		A_SpawnObjectRelative(actor,(-52*65536)+0,(40*65536)+MT_PROTAGONIST_WALKER3)
		A_SpawnObjectRelative(actor,(-52*65536)+0,(4*65536)+MT_PROTAGONIST_CONFETTI)
	else
		A_SpawnObjectRelative(actor,(52*65536)+0,(40*65536)+MT_PROTAGONIST_WALKER1)
		A_SpawnObjectRelative(actor,(52*65536)+0,(40*65536)+MT_PROTAGONIST_WALKER2)
		A_SpawnObjectRelative(actor,(52*65536)+0,(40*65536)+MT_PROTAGONIST_WALKER3)
		A_SpawnObjectRelative(actor,(52*65536)+0,(4*65536)+MT_PROTAGONIST_CONFETTI)
	end
	A_PlaySound(actor,sfx_s3k81,0)
end

function A_ProtagMissilesGo(actor, var1, var2)
	A_SpawnObjectRelative(actor,(0*65536)+0,(32*65536)+MT_PROTAGONIST_MISSILE1)
	A_SpawnObjectRelative(actor,(0*65536)+0,(32*65536)+MT_PROTAGONIST_MISSILE2)
	A_SpawnObjectRelative(actor,(0*65536)+0,(33*65536)+MT_PROTAGONIST_MISSILE3)
	A_PlaySound(actor,sfx_thok,0)
end

function A_ProtagDefeat(actor, var1, var2)
	A_ForceWin(actor,0,0)
end

function A_ProtagWalkerLook(actor, var1, var2)
	if P_LookForPlayers(actor, 0, true, false)
		A_FaceTarget(actor, 0, 0)
--		Using extravalue1 to force the state to last the 5 tics I want it to
--		last, otherwise it just switches to the next state instantly
		actor.extravalue1 = actor.extravalue1 - 1
		if actor.extravalue1 == -5
			actor.state = var2
			actor.extravalue1 = 0
		end
		if actor.target.player.exiting > 1
			P_KillMobj(actor,actor,actor)
		end
	else
		A_Break(actor, 0, 0)
	end
end

function A_ProtagMissileLook(actor, var1, var2)
	A_FindTracer(actor,MT_PLAYER,0)
	if actor.tracer
		if actor.tracer.player.exiting > 1
			P_KillMobj(actor,actor,actor)
			return
		end
		A_FaceTracer(actor, 0, 0)
		A_HomingChase(actor, 20*FRACUNIT, 1)
	else
		P_KillMobj(actor,actor,actor)
	end
end

local function walkerbounce(target,inflictor,source)
	if inflictor.type == MT_PLAYER
		P_SetMobjStateNF(target,target.info.deathstate)
		A_Scream(target)
		A_ZThrust(inflictor,12,(1*65536)+1)
		inflictor.player.pflags = $1 & ~PF_JUMPED
		inflictor.secondjump = 0
		inflictor.jumping = 0
		inflictor.player.pflags = $1 & ~PF_SPINNING
		if inflictor.player.pflags & PF_GLIDING
			P_SetMobjStateNF(inflictor,S_PLAY_GLIDE)
		else
			if inflictor.player.powers[pw_flashing] < 5
				inflictor.player.powers[pw_flashing] = 4
			end
			P_SetMobjStateNF(inflictor,S_PLAY_FALL)
		end
		return true
	else
		P_SetMobjStateNF(target,target.info.deathstate)
		return true
	end
end

local function protaginvincible(actor)
	if actor.health == 0
		A_SetObjectFlags(actor,MF_NOGRAVITY,1)
		A_SetObjectFlags(actor,MF_NOCLIP,1)
		A_SetObjectFlags(actor,MF_NOCLIPHEIGHT,1)
	end
	if actor.health <= actor.info.damage
	and actor.frame < 40
	and actor.fuse == 0
	and (leveltime % 2) == 0
		A_GhostMe(actor,0,0)
	end
	if actor.fuse > 1
		if (actor.fuse % 2) == 0
			A_SetObjectFlags2(actor,MF2_DONTDRAW,1)
		else
			A_SetObjectFlags2(actor,MF2_DONTDRAW,2)
		end
	end
	if actor.momx > 3*FRACUNIT
	and actor.frame > -1
	and actor.frame < 6
		A_Break(actor,0,0)
	end
	if actor.momx > 3*FRACUNIT
	and actor.frame == 42
		A_Break(actor,0,0)
	end
end

local function protaghittable(actor)
	if actor.flags2 & MF2_FRET
		actor.flags2 = $1 & ~MF2_FRET
		return true
	end
end

local function bulletxpld(actor)
	if actor.state == S_XPLD1
		if actor.type ~= MT_PROTAGONIST_BULLET
			S_StartSound(actor,sfx_pop)
		end
		//P_KillMobj(actor) // sal: wtf?!
	end
end

local function gimmering(player)
	if mapheaderinfo[gamemap].trueprotagonist
	and not player.bot
		P_GivePlayerRings(player,1)
		S_StartSound(player.mo,sfx_itemup)
	end
end

local function tracerchase(actor)
	A_FindTracer(actor,MT_PROTAGONIST,0)
	if actor.tracer
		A_CapeChase(actor,(0*65536)+1,(160*65536)+0)
	end
end

addHook("MobjDeath", walkerbounce, MT_PROTAGONIST_WALKER1)
addHook("MobjDeath", walkerbounce, MT_PROTAGONIST_WALKER2)
addHook("MobjDeath", walkerbounce, MT_PROTAGONIST_WALKER3)
addHook("BossThinker", protaginvincible, MT_PROTAGONIST)
addHook("MobjFuse", protaghittable, MT_PROTAGONIST)
addHook("MobjThinker", bulletxpld, MT_PROTAGONIST_MISSILE1)
addHook("MobjThinker", bulletxpld, MT_PROTAGONIST_MISSILE2)
addHook("MobjThinker", bulletxpld, MT_PROTAGONIST_MISSILE3)
addHook("MobjThinker", bulletxpld, MT_PROTAGONIST_BULLET)
addHook("PlayerSpawn", gimmering)
addHook("MobjThinker", tracerchase, MT_PROTAGONIST_TRACER)

--Todo:
--Maybe more thorough tests for the new targeting method of the missile dolls
--It's (seemingly) working flawlessly even though it totally shouldn't????