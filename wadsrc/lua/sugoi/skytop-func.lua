// I threw this together for Glaber in an hour because I'm horribly out of practice.
// Var1 is the same as it was in A_Chase, var2 is the trigger range of
// the dash attack. This code snippet is free for anyone to use. Go nuts.
// -Prime 2.0

function A_NeoChase(actor, ChaseVar, MeleeRange) // (actor, var1, var2)
	local tar = actor.target
	local tarDist = 0
	
	if (tar) // Only bother checking if target exists
	and (abs(actor.z - tar.z) < 150<<16) // Don't dash if player is too high/low. Change distance if you like.
	and FixedHypot(actor.y - tar.y, actor.x - tar.x) < MeleeRange<<16 then // Dash if in range.
		A_FaceTarget(actor, 0, 0)
		actor.state = actor.info.meleestate
	else
		A_Chase(actor, ChaseVar, 0)
	end
end
