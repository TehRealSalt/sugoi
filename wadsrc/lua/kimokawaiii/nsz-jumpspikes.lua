-- Jump spikes
-- Partially rewritten by Sal

freeslot(
	"SPR_SSZS",
	"MT_JUMPSPIKE",
	"S_JUMPSPIKE_WAIT",
	"S_JUMPSPIKE_POPUP1",
	"S_JUMPSPIKE_POPUP2",
	"S_JUMPSPIKE_POPUP3",
	"S_JUMPSPIKE_POPUP4",
	"S_JUMPSPIKE_POPUP5",
	"S_JUMPSPIKE_POPUPWAIT",
	"S_JUMPSPIKE_JUMP1",
	"S_JUMPSPIKE_JUMP2",
	"S_JUMPSPIKE_JUMP3",
	"sfx_sszsup",
	"sfx_sszsdn",
	"sfx_spiker",

	"SPR_DUST",
	"MT_SPIKEDUST",
	"S_SPIKEDUST1",
	"S_SPIKEDUST2",
	"S_SPIKEDUST3",
	"S_SPIKEDUST4",
	"S_SPIKEDUST5",
	"S_SPIKEDUST6"
)

function A_ShootSpikeJump(actor)
	A_ZThrust(actor, 10, (1<<16)+1)
	S_StartSound(actor, sfx_sszsup)
end

sfxinfo[sfx_sszsup] = {true, 64, 0}
sfxinfo[sfx_sszsdn] = {true, 64, 0}
sfxinfo[sfx_spiker] = {true, 64, 0}

mobjinfo[MT_JUMPSPIKE] = {
	--$Name Jumping Spikeball Shooter
	--$Sprite SSZSE0
	--$Category SUGOI Items & Hazards
	doomednum = 3472,
	spawnhealth = 1,
	spawnstate = S_JUMPSPIKE_WAIT,
	radius = 24*FRACUNIT,
	height = 32*FRACUNIT,
	mass = DMG_SPIKE,
	flags = MF_NOCLIP|MF_NOCLIPTHING
}

states[S_JUMPSPIKE_WAIT] = {SPR_NULL, A, 50, nil, 0, 0, S_JUMPSPIKE_POPUP1}
states[S_JUMPSPIKE_POPUP1] = {SPR_SSZS, A, 1, A_PlaySound, sfx_spiker, 1, S_JUMPSPIKE_POPUP2}
states[S_JUMPSPIKE_POPUP2] = {SPR_SSZS, B, 1, A_SetObjectFlags, MF_PAIN, 0, S_JUMPSPIKE_POPUP3}
states[S_JUMPSPIKE_POPUP3] = {SPR_SSZS, C, 1, nil, 0, 0, S_JUMPSPIKE_POPUP4}
states[S_JUMPSPIKE_POPUP4] = {SPR_SSZS, E, 3, nil, 0, 0, S_JUMPSPIKE_POPUP5}
states[S_JUMPSPIKE_POPUP5] = {SPR_SSZS, D, 2, nil, 0, 0, S_JUMPSPIKE_POPUPWAIT}
states[S_JUMPSPIKE_POPUPWAIT] = {SPR_SSZS, E, 30, nil, 0, 0, S_JUMPSPIKE_JUMP1}
states[S_JUMPSPIKE_JUMP1] = {SPR_SSZS, E, 1, A_ShootSpikeJump, 0, 0, S_JUMPSPIKE_JUMP2}
states[S_JUMPSPIKE_JUMP2] = {SPR_SSZS, F|FF_FULLBRIGHT, 4, nil, 0, 0, S_JUMPSPIKE_JUMP3}
states[S_JUMPSPIKE_JUMP3] = {SPR_SSZS, G|FF_FULLBRIGHT, 4, nil, 0, 0, S_JUMPSPIKE_JUMP2}

mobjinfo[MT_SPIKEDUST] = {
	doomednum = -1,
	spawnstate = S_SPIKEDUST1,
	speed = 3*FRACUNIT,
	radius = FRACUNIT,
	height = FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_NOCLIPTHING|MF_NOGRAVITY
}

states[S_SPIKEDUST1] = {SPR_DUST, A|FF_TRANS40, 4, nil, 0, 0, S_SPIKEDUST2}
states[S_SPIKEDUST2] = {SPR_DUST, B|FF_TRANS50, 5, nil, 0, 0, S_SPIKEDUST3}
states[S_SPIKEDUST3] = {SPR_DUST, C|FF_TRANS60, 3, nil, 0, 0, S_SPIKEDUST4}
states[S_SPIKEDUST4] = {SPR_DUST, D|FF_TRANS70, 2, nil, 0, 0, S_SPIKEDUST5}
states[S_SPIKEDUST5] = {SPR_DUST, D|FF_TRANS80, 1, nil, 0, 0, S_SPIKEDUST6}
states[S_SPIKEDUST6] = {SPR_DUST, D|FF_TRANS90, 1, nil, 0, 0, S_NULL}

addHook("MobjThinker", function(mo)
	mo.momx = 0
	mo.momy = 0

	if (mo.state == S_JUMPSPIKE_WAIT) and not (mo.extravalue1)
		if (mo.spawnpoint and mo.spawnpoint.valid)
			mo.tics = $1 + mo.spawnpoint.angle
		end
		mo.extravalue1 = 1
	end

	if (mo.state == S_JUMPSPIKE_JUMP2 or mo.state == S_JUMPSPIKE_JUMP3) and (P_IsObjectOnGround(mo))
		-- Sal: Look for any player that's close enough, rather than only looking at player 0
		for player in players.iterate do
			if not (player.mo and player.mo.valid) continue end
			if (player.bot) continue end

			if (P_AproxDistance(mo.x - player.mo.x, mo.y - player.mo.y) < (1600<<FRACBITS))
				A_MultiShot(mo, (MT_SPIKEDUST<<16)+10, -48)
				S_StartSound(mo, sfx_sszsdn)
				break
			end
		end

		mo.state = S_JUMPSPIKE_WAIT
		mo.flags = MF_NOCLIP|MF_NOCLIPTHING
	end
end, MT_JUMPSPIKE)
