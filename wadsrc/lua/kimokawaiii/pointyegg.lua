freeslot("MT_POINTYEGG","MT_POINTYEGG_SPIKEB","MT_POINTYEGG_SPIKEP","MT_POINTYEGG_SPIKEU","S_POINTYEGG_LOOK","S_POINTYEGG_DASHSTART","S_POINTYEGG_RISE")

-- Pointy Egg initialization --
addHook("MobjSpawn",function(actor)
	A_BossJetFume(actor,0,0)
	actor.floatpos = 0
	actor.isHit = false
	actor.floatz = actor.z
	actor.dashtime = P_RandomRange(105,210)
	actor.spiketable = {
		{{MT_POINTYEGG_SPIKEB,4,128,20,0}},
		{{MT_POINTYEGG_SPIKEB,8,192,30,25}},
		{{MT_POINTYEGG_SPIKEP,8,192,10,0}},
		{{MT_POINTYEGG_SPIKEB,5,256,5,10},{MT_POINTYEGG_SPIKEP,8,256,100,10}},
		{{MT_POINTYEGG_SPIKEP,3,96,100,0},{MT_POINTYEGG_SPIKEP,12,192,20,40}},
		{{MT_POINTYEGG_SPIKEB,5,128,100,50},{MT_POINTYEGG_SPIKEU,6,64,10,0}},
		{{MT_POINTYEGG_SPIKEP,6,192,30,5},{MT_POINTYEGG_SPIKEU,12,128,100,50}},
		{{MT_POINTYEGG_SPIKEU,18,192,50,30},{MT_POINTYEGG_SPIKEP,4,192,50,30},{MT_POINTYEGG_SPIKEU,18,192,10,15},{MT_POINTYEGG_SPIKEP,4,192,10,15}}
	}
end,MT_POINTYEGG)

-- Pointy Egg death sequence hook --
addHook("BossDeath",function(actor)
	local found = false
	for mobj in mobjs.iterate()
		if mobj.type == MT_BOSSFLYPOINT
			found = true
			actor.tracer = mobj
			A_HomingChase(actor,16*FRACUNIT,1)
		end
	end
	actor.flags = ($1|MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP)
	if found
		actor.state = actor.info.xdeathstate
	else
		actor.state = S_EGGMOBILE_FLEE1
		actor.momz = 2*FRACUNIT
	end
	return true
end,MT_POINTYEGG)

-- Pointy Egg movement actions --
function A_PointyEggFloat(actor,var1,var2)
	actor.dashtime = $1 - 1
	if actor.target.valid and actor.target.health > 0 and P_CheckSight(actor, actor.target)
		if actor.dashtime == 0
			actor.state = S_POINTYEGG_DASHSTART
		else
			actor.floatpos = $1 + ANG2*2
			actor.z = $1 + sin(actor.floatpos)
			A_FaceTarget(actor,var1,var2)
			P_InstaThrust(actor,actor.angle,FRACUNIT*2)
			actor.floatz = actor.z
		end
	else
		actor.state = S_POINTYEGG_LOOK
	end

end

function A_PointyEggDash(actor,var1,var2)
	P_InstaThrust(actor,actor.angle,FRACUNIT*8)
	actor.momz = -6*FRACUNIT
end

function A_PointyEggRise(actor,var1,var2)
	if actor.z >= actor.floatz
		actor.z = actor.floatz
		actor.dashtime = P_RandomRange(105,210)
		actor.state = S_POINTYEGG_FLOAT
		actor.momz = 0
	else
		actor.momz = $1 + FRACUNIT/4
	end
end

function A_PointyEggPain(actor,var1,var2)
	P_InstaThrust(actor,actor.angle,-FRACUNIT*10)
	actor.momz = 0
	actor.isHit = true
	A_Pain(actor,var1,var2)
end

function A_PointyEggFlee(actor,var1,var2)
	actor.angle = actor.tracer.angle
	A_ForceStop(actor)
end

-- Pointy Egg spike actions --
function A_PointyEggDeploy(actor,var1,var2)
	actor.isHit = false
	local tables = actor.spiketable[9-actor.health]
	for i=1,#tables,1
		local spikes = tables[i]
		local incr = (ANGLE_180/spikes[2])*2
		for j=1,spikes[2],1
			local spike = P_SpawnMobj(actor.x,actor.y,actor.z,spikes[1])
			spike.maxrad = spikes[3]
			spike.radius = 0
			spike.xspin = spikes[4]
			spike.yspin = spikes[5]
			spike.angle = incr*j
			spike.timer = 0
			spike.delay = j*TICRATE
			spike.target = actor
		end
	end
end

function A_PointyEggSpike(actor,var1,var2)
	if(actor.radius < actor.maxrad)
		actor.radius = $1 + 2
	end
	if(actor.target.health == 0)
		actor.state = actor.info.deathstate
		actor.flags = ($1 & ~MF_PAIN)
		actor.fuse = P_RandomRange(1,45)
	else
		A_Custom3DRotate(actor,actor.radius,(actor.xspin<<16)+actor.yspin)
	end
end

function A_PointyEggSpikeP(actor,var1,var2)
	A_PointyEggSpike(actor,var1,var2)
	if(actor.target.isHit)
		actor.flags = ($1 & ~MF_NOGRAVITY)
		actor.state = S_POINTYEGG_SPIKEP_DROP
		P_MoveOrigin(actor,actor.x,actor.y,actor.z)
	end
end

function A_PointyEggSpikeU(actor,var1,var2)
	actor.timer = $1 + 1
	if(actor.timer == actor.delay)
		actor.tracer = actor.target.target
		A_HomingChase(actor,8*FRACUNIT,1)
		actor.state = S_POINTYEGG_SPIKEU_LAUNCH
	else
		A_PointyEggSpike(actor,var1,var2)
	end
end
