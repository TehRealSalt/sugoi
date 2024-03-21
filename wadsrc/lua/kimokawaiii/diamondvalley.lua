freeslot("MT_DPOINTY_SPIKE", "S_DPOINTY_LOOK", "MT_DPOINTY_SPIKE_BREAK")

function A_DPointyInit(actor,var1,var2)
	for i=0,7,1
		local spike = P_SpawnMobj(actor.x,actor.y,actor.z,MT_DPOINTY_SPIKE)
		spike.angle = i*(ANG30+ANG15)
		spike.target = actor
	end
end

function A_DPointyChase(actor,var1,var2)
	if (actor.target and actor.target.valid)
	and (P_CheckSight(actor, actor.target))
		A_FaceTarget(actor,var1,var2)
		P_InstaThrust(actor,actor.angle,2*FRACUNIT)
	else
		actor.state = S_DPOINTY_LOOK
	end

end

function A_DPointyBall(actor,var1,var2)
	if (actor.target.health > 0)
		A_RotateSpikeBall(actor,var1,var2)
	else
		actor.angle = $1 + ANGLE_90
		P_Thrust(actor,actor.angle,4*FRACUNIT)
		actor.flags = ($1 & ~MF_NOGRAVITY)
		actor.state = S_DPOINTY_SPIKE_BREAK
	end
end
