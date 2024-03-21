//In-Level Hook-Ring Parts! By ManimiFire.

freeslot(
	"MT_HOOKRING",
	"MT_NORMALHOOK",
	"S_HOOKRING",
	"S_NORMALHOOK",
	"MT_HOOKPOINT",
	"S_HOOKPOINT1",
	"S_HOOKPOINT2",
	"S_HOOKPOINT3",
	"S_HOOKPOINT4",
	"S_PLAY_DWSPIN",
	"S_PLAY_DWSPIN2",
	"MT_THRUSTCUSTOMIZER",
	"S_THRUSTCUSTOMIZER"
)
freeslot("S_HOOKPOINTAUTO1", "S_HOOKPOINTAUTO2", "S_HOOKPOINTAUTO3", "S_HOOKPOINTAUTO4", "SPR_GWSG", "SPR_GWSR")

mobjinfo[MT_HOOKPOINT] = {
	//$Sprite GWSGA0
	//$Name Hook Point
	//$Category SUGOI Items & Hazards
	doomednum = 2125,
	spawnstate = S_HOOKPOINT1,
	height = 30*FRACUNIT,
	radius = 30*FRACUNIT,
    flags = MF_FLOAT|MF_NOGRAVITY|MF_SOLID
}

mobjinfo[MT_THRUSTCUSTOMIZER] = {
	//$Sprite PITYA0
	//$Name Thrust Customizer
	//$Category SUGOI Items & Hazards
	doomednum = 2126,
	spawnstate = S_THRUSTCUSTOMIZER,
	height = 15*FRACUNIT,
	radius = 15*FRACUNIT,
    flags = MF_FLOAT|MF_NOGRAVITY|MF_SOLID
}

mobjinfo[MT_HOOKRING] = {
	spawnstate = S_HOOKRING,
	height = 4*FRACUNIT,
	radius = 4*FRACUNIT,
    flags = MF_STICKY|MF_FLOAT|MF_NOGRAVITY
}

mobjinfo[MT_NORMALHOOK] = {
	spawnstate = S_NORMALHOOK,
	height = 10*FRACUNIT,
	radius = 10*FRACUNIT,
	flags = MF_NOCLIPHEIGHT
}

states[S_HOOKRING] = {SPR_BMCH, A, 1, nil, 0, 0, S_HOOKRING}
states[S_NORMALHOOK] = {SPR_SMCH, A, 1, nil, 0, 0, S_NORMALHOOK}
states[S_HOOKPOINT1] = {SPR_GWSG, A, 2, nil, 0, 0, S_HOOKPOINT2}
states[S_HOOKPOINT2] = {SPR_GWSG, B, 2, nil, 0, 0, S_HOOKPOINT3}
states[S_HOOKPOINT3] = {SPR_GWSG, C, 2, nil, 0, 0, S_HOOKPOINT4}
states[S_HOOKPOINT4] = {SPR_GWSG, B, 2, nil, 0, 0, S_HOOKPOINT1}
states[S_HOOKPOINTAUTO1] = {SPR_GWSR, A, 2, nil, 0, 0, S_HOOKPOINTAUTO2}
states[S_HOOKPOINTAUTO2] = {SPR_GWSR, B, 2, nil, 0, 0, S_HOOKPOINTAUTO3}
states[S_HOOKPOINTAUTO3] = {SPR_GWSR, C, 2, nil, 0, 0, S_HOOKPOINTAUTO4}
states[S_HOOKPOINTAUTO4] = {SPR_GWSR, B, 2, nil, 0, 0, S_HOOKPOINTAUTO1}
states[S_THRUSTCUSTOMIZER] = {SPR_NULL, A, 1, nil, 0, 0, S_THRUSTCUSTOMIZER}

states[S_PLAY_DWSPIN] = {SPR_PLAY, SPR2_ROLL|FF_ANIMATE, 20, nil, 0, 1, S_PLAY_FALL}
states[S_PLAY_DWSPIN2] = {SPR_PLAY, SPR2_ROLL|FF_ANIMATE, 28, nil, 0, 1, S_PLAY_FALL}

local chain

local targett

local distt = 1400<<FRACBITS

local crings = {}

local ccount = 0

local function initCombiLoop()
	ccount = 0
end

local function drawCombiRing(x,y,z)
	ccount = $1+1
	if crings[ccount] and crings[ccount].valid then
	      P_MoveOrigin(crings[ccount], x, y, z)
    else
		crings[ccount] = P_SpawnMobj(x, y, z, MT_NORMALHOOK)
		crings[ccount].scale = FRACUNIT
	end
	crings[ccount].fuse = 2
end

local function attachPlayers(chain)
	-- Draw combi rings
	if not chain return end
	for i=1,7 do
	if chain.target ~= nil
		drawCombiRing(
			chain.target.x+(chain.x-chain.target.x)*i/8,
			chain.target.y+(chain.y-chain.target.y)*i/8,
			chain.target.z+(chain.z-chain.target.z)*i/8
		)
	end
	end
end
addHook("MobjThinker", attachPlayers, MT_HOOKRING)

addHook("MobjCollide", function(point,customizer)
 if point and point.valid
 and customizer and customizer.valid
 and customizer.type == MT_THRUSTCUSTOMIZER
 and abs(customizer.z-point.z)<= point.height
 point.customizer = customizer
 end
end,MT_HOOKPOINT)


local bots = {}
local points = {}

addHook("NetVars", function(network)
	bots = network(bots)
	points = network(points)
end)

addHook("MapLoad", do
	for point in mobjs.iterate()
	if point.type == MT_PLAYER
	and point.player
	and point.player.bot == 1
	table.insert(bots,point)
	end
	end
	for point in mobjs.iterate()
	if point.type == MT_HOOKPOINT
	table.insert(points,point)
	end
	end
end)

rawset(_G, "P_Activate4", function()
for player in players.iterate
if player.custom1button == nil
	 player.custom1button = 0
	 end
	 if player.usedprefinishhook == nil
	 player.usedprefinishhook = false
	 end
	 if player.usedcutscenehook == nil
	 player.usedcutscenehook = false
	 end
	 if player.feelinground == nil
	 player.feelinground = false
	 end
	 if player.feelingroundtimer == nil
	 player.feelingroundtimer = 0
	 end
	 if player.readyreadyready == nil
	 player.readyreadyready = false
	 end
	 if player.spinnow == nil
	 player.spinnow = false
	 end
	 if player.recoveryy == nil
	 player.recoveryy = 0
	 end
	 if player.nowmomx == nil
	 player.nowmomx = 0
	 end
	 if player.nowmomy == nil
	 player.nowmomy = 0
	 end
	 if player.nowmomz == nil
	 player.nowmomz = 0
	 end
	 if player.number == nil
	 player.number = -100
	 end
	 if player.numbertwo == nil
	 player.numbertwo = 150
	 end
	 if player.numberthree == nil
	 player.numberthree = -100
	 end
	 if player.numberfour == nil
	 player.numberfour = 150
	 end
	 if player.hookhang == nil
	 player.hookhang = false
	 end
	 if player.autodelay == nil
	 player.autodelay = 0
	 end
	 if player.autodelay > 0
	 player.autodelay = $1 - 1
	 end
	 if player.autodelay == 0
	 player.previouspoint = nil
	 end
	 if player.readytojump == nil
	 player.readytojump = false
	 end
	 if (player.cmd.buttons & BT_ATTACK)
	 player.custom1button = $1 + 1
	 else
	 player.custom1button = 0
	 end
	 if player.recoveryy > 0
	 player.recoveryy = $1 - 1
	 end
	 if player.mo
		and player.spectator == true
		player.readyreadyready = false
		player.hookhang = false
		player.recoveryy = 0
		end
		if player.readyreadyready == true
		and player.mo.point == nil
		player.readyreadyready = false
		player.hookhang = false
		player.recoveryy = 0
		end
		if player.feelinground == true
	 player.feelingroundtimer = $1 + 1
	 else
	 player.feelingroundtimer = 0
	 end
	 if player.feelingroundtimer >= 3
	 and player.mo.point and player.mo.point.valid
	 and player.spinnow == true
	 player.mo.angle = player.mo.point.angle
	 player.mo.momx = 0
	 player.mo.momy = 0
	 player.mo.momz = 0
	 if not (player.mo.state == S_PLAY_PAIN)
	 and not  (player.mo.state == S_PLAY_DEAD)
	 if player.mo.point.spawnpoint.angle >= 0
	 and player.mo.point.spawnpoint.angle < 20
	 player.mo.state = S_PLAY_RIDE
	 elseif player.mo.point.spawnpoint.angle >= 20
	 P_SpawnGhostMobj(player.mo)
	 player.mo.state = S_PLAY_RIDE
	 end
	 end
	 end
	 if player.mo and player.mo.valid
	 if player.mo.point and player.mo.point.valid
	 if player.feelingroundtimer > 1
	 and player.spinnow == true
		-- sal: fuck A_Custom3DRotate
		local radius = FixedMul(100*FRACUNIT, player.mo.scale)
		local hOff = FixedMul(-50*FRACUNIT, player.mo.scale)
		local speed = FixedMul(-150*FRACUNIT/10, player.mo.scale)

		//player.mo.angle = $1 + FixedAngle(speed)
		player.mo.movedir = $1 + FixedAngle(speed)

		local newx, newy, newz

		newx = player.mo.point.x + FixedMul(FixedMul(sin(player.mo.movedir), cos(player.mo.angle)), radius)
		newy = player.mo.point.y + FixedMul(FixedMul(sin(player.mo.movedir), sin(player.mo.angle)), radius)
		newz = player.mo.point.z + FixedMul(cos(player.mo.movedir), radius) + player.mo.point.height/2 - player.mo.height/2 + hOff

		P_MoveOrigin(player.mo, newx, newy, newz)
	 end
	 if player.feelingroundtimer > 2
	 and player.readytojump == false
	 and (player.mo.z <= player.mo.point.z)
	 player.readytojump = true
	 end
	 if player.feelingroundtimer == 1
	 and (player.mo.point and player.mo.point.valid)
	 and (player.bot ~= 1)
	 player.mo.point.angle = player.mo.angle
	 end
	 if (player.mo.z > player.mo.point.z)
	 and player.feelinground == true
	 and player.readytojump == true
	 player.mo.momx = 0
	 player.mo.momy = 0
	 player.mo.momz = 0
	 player.pflags = $1 & ~PF_JUMPED & ~PF_SPINNING
	 player.mo.state = S_PLAY_DWSPIN
	 player.mo.momz = $1 + player.mo.point.spawnpoint.angle*FRACUNIT
	 if not (player.mo.point.customizer)
	 P_Thrust(player.mo,player.mo.point.angle,20*FRACUNIT)
	 end
	 if player.mo.point.customizer and player.mo.point.customizer.valid
	 P_Thrust(player.mo,player.mo.point.angle,player.mo.point.customizer.spawnpoint.angle*FRACUNIT)
	 end
	 if (player.mo.state == S_PLAY_ROLL)
	 player.mo.state = S_PLAY_DWSPIN
	 end
	 if player.mo.chain and player.mo.chain.valid
	 player.mo.chain.grabbing = false
	 P_RemoveMobj(player.mo.chain)
	 end
	 player.spinnow = false
	 player.feelinground = false
	 player.feelingroundtimer = 0
     player.readyreadyready = false
	 player.readytojump = false
	 player.hookhang = false
	 player.recoveryy = 0
	 player.mo.target = nil
	 player.mo.point = nil
	 player.mo.chain = nil
	 if player.number == -100
	 player.number = 20
	 elseif player.number == 20
	 player.number = -100
	 end
	 if player.numbertwo == 150
	 player.numbertwo = 70
	 elseif player.numbertwo == 70
	 player.numbertwo = 150
	 end
	 end
	 end
	 end



	 for i = 1, #bots
      if (bots[i] and bots[i].valid)
	  and (player.mo.chain and player.mo.chain.valid)
	  and (player.mo.point and player.mo.point.valid)
	  and bots[i].player.readyreadyready == false
	  and not (player.powers[pw_carry])
	  and not (bots[i].player.powers[pw_carry])
	  and (player.playerstate == PST_LIVE)
	  and (bots[i].player.playerstate == PST_LIVE)
	  and (player.mo ~= nil)
	  and abs(player.mo.point.z-player.mo.z)<= 350*FRACUNIT
	  and R_PointToDist2(player.mo.point.x,player.mo.point.y,player.mo.x,player.mo.y)<= 350*FRACUNIT
	  and not (player.mo.point.spawnpoint.options & MTF_OBJECTSPECIAL)
	  and bots[i].player.hang == false
	  and not (player.powers[pw_super])
	  and not (bots[i].player.powers[pw_super])
	  and not (player.mo.state == S_PLAY_PAIN)
	  and not (player.mo.state == S_PLAY_DEAD)
	  and (player.mo.point ~= bots[i].player.previouspoint)
	  and not (bots[i].state == S_PLAY_PAIN)
	  and not (bots[i].state == S_PLAY_DEAD)
	  and player.bot ~= 1
	  P_MoveOrigin(bots[i],player.mo.x,player.mo.y,player.mo.z)
	  bots[i].player.autodelay = 40
	  bots[i].player.readyreadyready = true
	  local an = player.mo.angle
	  local slope = player.aiming
	  S_StartSound(bots[i], sfx_s3ka2)
	  chain = P_SpawnMobj(bots[i].x, bots[i].y, bots[i].z+6*FRACUNIT, MT_HOOKRING)
	  bots[i].target = player.mo.point
	  bots[i].point = player.mo.point
	  chain.scale = FRACUNIT
	  chain.target = bots[i]
	  bots[i].player.previouspoint = player.mo.point
	  bots[i].target = player.mo.point
	  bots[i].tracer = chain
	  bots[i].chain = chain
	  chain.angle = an
	  local factor = FRACUNIT>>2
	  local xdist = bots[i].point.x-chain.x
		xdist = FixedMul($1, factor)

		local ydist = bots[i].point.y-chain.y
		ydist = FixedMul($1, factor)

		local zdist = bots[i].point.z-chain.z
		zdist = FixedMul($1, factor)
   chain.momx = $1+xdist
   chain.momy = $1+ydist
   chain.momz = $1+zdist
	  chain.ready = false
	  end
	  end



end
end)

//if player.numberthree == -100
//	 player.numberthree = 20
//	 elseif player.numberthree == 20
//	 player.numberthree = -100
//	 end
//	 if player.numberfour == 150
//	 player.numberfour = 70
//	 elseif player.numberfour == 70
//	 player.numberfour = 150
//	 end

addHook("AbilitySpecial", function(player)
 if player.feelinground == true
 return true
 end
end)

addHook("SpinSpecial", function(player)
 if player.feelinground == true
 return true
 end
end)

addHook("JumpSpecial", function(player)
 if player.feelinground == true
 return true
 end
end)

addHook("JumpSpinSpecial", function(player)
 if player.feelinground == true
 return true
 end
end)

//You ----~--   _`"-_~~-><_!~!    ----~--> point

freeslot("sfx_aim")

addHook("MobjThinker", function(point)
  if not point return end
  for player in players.iterate



      if player.custom1button == 1
	  and player.readyreadyready == false
	  and not (player.powers[pw_carry])
	  and (player.playerstate == PST_LIVE)
	  and (player.mo ~= nil)
	  and abs(point.z-player.mo.z)<= 350*FRACUNIT
	  and R_PointToDist2(point.x,point.y,player.mo.x,player.mo.y)<= 350*FRACUNIT
	  and not (point.spawnpoint.options & MTF_OBJECTSPECIAL)
	  and player.hang == false
	  and not (player.powers[pw_super])
	  and (point ~= player.previouspoint)
	  and not (player.mo.state == S_PLAY_PAIN)
	  and not (player.mo.state == S_PLAY_DEAD)
	  and player.bot ~= 1
	  player.autodelay = 40
	  player.readyreadyready = true
	  local an = player.mo.angle
	  local slope = player.aiming
	  S_StartSound(player.mo, sfx_s3ka2)
	  chain = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z+6*FRACUNIT, MT_HOOKRING)
	  player.mo.target = point
	  player.mo.point = point
	  chain.scale = FRACUNIT
	  chain.target = player.mo
	  player.previouspoint = point
	  player.mo.chain = chain
	  chain.angle = an
	  local factor = FRACUNIT>>2
	  local xdist = player.mo.point.x-chain.x
		xdist = FixedMul($1, factor)

		local ydist = player.mo.point.y-chain.y
		ydist = FixedMul($1, factor)

		local zdist = player.mo.point.z-chain.z
		zdist = FixedMul($1, factor)
   chain.momx = $1+xdist
   chain.momy = $1+ydist
   chain.momz = $1+zdist
	  chain.ready = false
	  end



	  if player.readyreadyready == false
	  and not (player.powers[pw_carry])
	  and (player.playerstate == PST_LIVE)
	  and (player.mo ~= nil)
	  and abs(point.z-player.mo.z)<= 350*FRACUNIT
	  and R_PointToDist2(point.x,point.y,player.mo.x,player.mo.y)<= 350*FRACUNIT
	  and (point.spawnpoint.options & MTF_OBJECTSPECIAL)
	  and player.hang == false
	  and player.feelinground == false
	  and (mapheaderinfo[gamemap].dwz)
	  and not (player.spawntimer >= 100)
	  and not (player.starposttime)
	  and (point.spawnpoint.angle == 10)
	  and (point ~= player.previouspoint)
	  and not (player.powers[pw_super])
	  and not (player.mo.state == S_PLAY_PAIN)
	  and not (player.mo.state == S_PLAY_DEAD)
	  player.autodelay = 80
	  player.readyreadyready = true
	  local an = player.mo.angle
	  local slope = player.aiming
	  S_StartSound(player.mo, sfx_s3ka2)
	  chain = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z+6*FRACUNIT, MT_HOOKRING)
	  player.mo.target = point
	  player.mo.point = point
	  chain.scale = FRACUNIT
	  chain.target = player.mo
	  player.previouspoint = point
	  player.mo.chain = chain
	  chain.angle = an
	  local factor = FRACUNIT>>2
	  local xdist = player.mo.point.x-chain.x
		xdist = FixedMul($1, factor)

		local ydist = player.mo.point.y-chain.y
		ydist = FixedMul($1, factor)

		local zdist = player.mo.point.z-chain.z
		zdist = FixedMul($1, factor)
   chain.momx = $1+xdist
   chain.momy = $1+ydist
   chain.momz = $1+zdist
	  chain.ready = false
	  end
	  if player.readyreadyready == false
	  and not (player.powers[pw_carry])
	  and (player.playerstate == PST_LIVE)
	  and (player.mo ~= nil)
	  and abs(point.z-player.mo.z)<= 350*FRACUNIT
	  and R_PointToDist2(point.x,point.y,player.mo.x,player.mo.y)<= 350*FRACUNIT
	  and (point.spawnpoint.options & MTF_OBJECTSPECIAL)
	  and player.hang == false
	  and player.feelinground == false
	  and (mapheaderinfo[gamemap].dwz)
	  and (point.spawnpoint.angle == 20)
	  and (point ~= player.previouspoint)
	  and not (player.powers[pw_super])
	  and not (player.mo.state == S_PLAY_PAIN)
	  and not (player.mo.state == S_PLAY_DEAD)
	  player.autodelay = 80
	  player.readyreadyready = true
	  local an = player.mo.angle
	  local slope = player.aiming
	  S_StartSound(player.mo, sfx_s3ka2)
	  chain = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z+6*FRACUNIT, MT_HOOKRING)
	  player.mo.target = point
	  player.mo.point = point
	  chain.scale = FRACUNIT
	  chain.target = player.mo
	  player.previouspoint = point
	  player.mo.chain = chain
	  chain.angle = an
	  local factor = FRACUNIT>>2
	  local xdist = player.mo.point.x-chain.x
		xdist = FixedMul($1, factor)

		local ydist = player.mo.point.y-chain.y
		ydist = FixedMul($1, factor)

		local zdist = player.mo.point.z-chain.z
		zdist = FixedMul($1, factor)
   chain.momx = $1+xdist
   chain.momy = $1+ydist
   chain.momz = $1+zdist
	  chain.ready = false
	  end
	  if player.readyreadyready == false
	  and not (player.powers[pw_carry])
	  and (player.playerstate == PST_LIVE)
	  and (player.mo ~= nil)
	  and abs(point.z-player.mo.z)<= 350*FRACUNIT
	  and R_PointToDist2(point.x,point.y,player.mo.x,player.mo.y)<= 350*FRACUNIT
	  and (point.spawnpoint.options & MTF_OBJECTSPECIAL)
	  and player.hang == false
	  and player.feelinground == false
	  and (mapheaderinfo[gamemap].dwz)
	  and (point.spawnpoint.angle == 6)
	  and (player.usedcutscenehook == false)
	  and (point ~= player.previouspoint)
	  and not (player.powers[pw_super])
	  and not (player.mo.state == S_PLAY_PAIN)
	  and not (player.mo.state == S_PLAY_DEAD)
	  player.autodelay = 80
	  player.readyreadyready = true
	  local an = player.mo.angle
	  local slope = player.aiming
	  S_StartSound(player.mo, sfx_s3ka2)
	  chain = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z+6*FRACUNIT, MT_HOOKRING)
	  player.mo.target = point
	  player.mo.point = point
	  chain.scale = FRACUNIT
	  chain.target = player.mo
	  player.previouspoint = point
	  player.mo.chain = chain
	  chain.angle = an
	  local factor = FRACUNIT>>2
	  local xdist = player.mo.point.x-chain.x
		xdist = FixedMul($1, factor)

		local ydist = player.mo.point.y-chain.y
		ydist = FixedMul($1, factor)

		local zdist = player.mo.point.z-chain.z
		zdist = FixedMul($1, factor)
   chain.momx = $1+xdist
   chain.momy = $1+ydist
   chain.momz = $1+zdist
	  chain.ready = false
	  end
	  if player.readyreadyready == false
	  and not (player.powers[pw_carry])
	  and (player.playerstate == PST_LIVE)
	  and (player.mo ~= nil)
	  and abs(point.z-player.mo.z)<= 350*FRACUNIT
	  and R_PointToDist2(point.x,point.y,player.mo.x,player.mo.y)<= 350*FRACUNIT
	  and (point.spawnpoint.options & MTF_OBJECTSPECIAL)
	  and player.hang == false
	  and player.feelinground == false
	  and (mapheaderinfo[gamemap].dwz)
	  and (point.spawnpoint.angle == 5)
	  and (player.usedprefinishhook == false)
	  and (point ~= player.previouspoint)
	  and not (player.powers[pw_super])
	  and not (player.mo.state == S_PLAY_PAIN)
	  and not (player.mo.state == S_PLAY_DEAD)
	  player.autodelay = 80
	  player.readyreadyready = true
	  local an = player.mo.angle
	  local slope = player.aiming
	  S_StartSound(player.mo, sfx_s3ka2)
	  chain = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z+6*FRACUNIT, MT_HOOKRING)
	  player.mo.target = point
	  player.mo.point = point
	  chain.scale = FRACUNIT
	  chain.target = player.mo
	  player.previouspoint = point
	  player.mo.chain = chain
	  chain.angle = an
	  local factor = FRACUNIT>>2
	  local xdist = player.mo.point.x-chain.x
		xdist = FixedMul($1, factor)

		local ydist = player.mo.point.y-chain.y
		ydist = FixedMul($1, factor)

		local zdist = player.mo.point.z-chain.z
		zdist = FixedMul($1, factor)
   chain.momx = $1+xdist
   chain.momy = $1+ydist
   chain.momz = $1+zdist
	  chain.ready = false
	  end
	 if not (player.powers[pw_carry])
	  and (player.playerstate == PST_LIVE)
	  and (player.mo ~= nil)
	  and player.mo.point and player.mo.point.valid
	  and abs(player.mo.point.z-player.mo.z)<= 250*FRACUNIT
	  and R_PointToDist2(player.mo.point.x,player.mo.point.y,player.mo.x,player.mo.y)<= 250*FRACUNIT
	  and player.mo.chain and player.mo.chain.valid
	  and player.mo.chain.grabbing == true
	  and player.feelinground == false
	  and player.mo.point and player.mo.point.valid
	  and not (player.mo.state == S_PLAY_PAIN)
	  and not (player.mo.state == S_PLAY_DEAD)
	  player.feelinground = true
	  player.spinnow = true
	  if (player.mo.point.spawnpoint.angle == 5)
	  player.usedprefinishhook = true
	  end
	  if (player.mo.point.spawnpoint.angle == 6)
	  player.usedcutscenehook = true
	  end
	 end
  end
  if point and point.valid
  and (point.spawnpoint.options & MTF_OBJECTSPECIAL)
  and ((point.state == S_HOOKPOINT1) or (point.state == S_HOOKPOINT2) or (point.state == S_HOOKPOINT3) or (point.state == S_HOOKPOINT4))
  P_SetMobjStateNF(point,S_HOOKPOINTAUTO1)
  end
  if point and point.valid
  and (point.spawnpoint.angle == 9)
  point.spawnpoint.angle = 8
  end
end,MT_HOOKPOINT)

addHook("MobjThinker", function(chain)
   if not chain return end
   chain.atwall = 0
   local distt = 1400<<FRACBITS
   local disttt = 1300<<FRACBITS
   local dist = 250<<FRACBITS
   local factor = FRACUNIT>>5
   if chain.valid
   and chain.target == nil
   P_RemoveMobj(chain)
   end
   if chain.valid
   and chain.target ~= nil
   and chain.target.player.playerstate == PST_DEAD
   chain.target.player.readyreadyready = false
   chain.grabbing = false
   P_RemoveMobj(chain)
   end
   if chain.valid
   and chain.tracer
   and chain.tracer.player
   and chain.tracer.player.playerstate == PST_DEAD
   chain.target.player.readyreadyready = false
   chain.grabbing = false
   P_RemoveMobj(chain)
   end
   if chain.valid
   and chain.hangtime == nil
   chain.hangtime = 0
   end
   if chain.valid
   and chain.goingback == nil
   chain.goingback = false
   end
   if chain.valid
   and P_AproxDistance(P_AproxDistance(chain.target.x-chain.x, chain.target.y-chain.y) ,chain.target.z-chain.z) >= distt
   chain.goingback = true
   end
   if chain.valid
   and chain.goingback == true
   local xdist = chain.target.x-chain.x
		xdist = FixedMul($1, factor)

		local ydist = chain.target.y-chain.y
		ydist = FixedMul($1, factor)

		local zdist = chain.target.z-chain.z
		zdist = FixedMul($1, factor)
   chain.momx = $1+xdist
   chain.momy = $1+ydist
   chain.momz = $1+zdist
   end
   if chain.valid
   and chain.goingback == true
   and abs(chain.z - chain.target.z)<= chain.target.height
   and R_PointToDist2(chain.x, chain.y, chain.target.x, chain.target.y)<= 40*FRACUNIT
   chain.grabbing = false
   chain.target.player.readyreadyready = false
   P_RemoveMobj(chain)
   end
   if chain.valid
   if (chain.eflags & MFE_JUSTHITFLOOR) or (abs((chain.z + chain.height) - chain.floorz) < 8*chain.scale) or (abs((chain.z + chain.height) - chain.ceilingz) < 8*chain.scale) or (P_IsObjectOnGround(chain))
   if chain.goingback == false
   chain.momz = 0
   chain.momx = 0
   chain.momy = 0
   chain.ready = true
   chain.hangtime = $1 + 1
   if chain.hangtime == 1 then
   chain.currentdist = P_AproxDistance(P_AproxDistance(chain.target.x-chain.x, chain.target.y-chain.y) ,chain.target.z-chain.z)
   end
   end
   end
   end
   if chain.valid
   and chain.target == nil
   and chain.grabbing == true
   chain.grabbing = false
   P_RemoveMobj(chain)
   end
   if chain.valid
   and chain.tracer
   and chain.tracer.player
   and chain.tracer == nil
   and chain.grabbing == true
   chain.grabbing = false
   chain.target.player.readyreadyready = false
   P_RemoveMobj(chain)
   end
   if chain.valid
   and chain.validness == nil
   chain.validness = 0
   end
   if chain.valid
   if chain.momz == 0
   and chain.momx == 0
   and chain.momy == 0
   and chain.validness > 1
   if chain.goingback == false
   chain.momz = 0
   chain.momx = 0
   chain.momy = 0
   chain.ready = true
   chain.hangtime = $1 + 1
   if chain.hangtime == 1 then
   chain.currentdist = P_AproxDistance(P_AproxDistance(chain.target.x-chain.x, chain.target.y-chain.y) ,chain.target.z-chain.z)
   end
   end
   end
   end
   if chain.valid
   if chain.ready == true
   if P_AproxDistance(P_AproxDistance(chain.target.x-chain.x, chain.target.y-chain.y) ,chain.target.z-chain.z) > chain.currentdist
   and chain.target.player.feelinground == false
   local xdist = chain.target.x-chain.x
		xdist = FixedMul($1, factor)

		local ydist = chain.target.y-chain.y
		ydist = FixedMul($1, factor)

		local zdist = chain.target.z-chain.z
		zdist = FixedMul($1, factor)
   chain.momz = 0
   chain.momx = 0
   chain.momy = 0
   chain.target.momx = $1-xdist
   chain.target.momy = $1-ydist
   chain.target.momz = $1-zdist
   chain.target.state = S_PLAY_RIDE
   end
   end
   end
   if chain.valid
   and chain.rest == nil
   chain.rest = 0
   end
   if chain.valid
   if (chain.grabbing == true)
   and chain.ready == true
   and chain.target.player.feelinground == false
   local xdist = chain.target.x-chain.x
		xdist = FixedMul($1, factor)

		local ydist = chain.target.y-chain.y
		ydist = FixedMul($1, factor)

		local zdist = chain.target.z-chain.z
		zdist = FixedMul($1, factor)
   chain.target.momx = $1-xdist
   chain.target.momy = $1-ydist
   chain.target.momz = $1-zdist
   chain.hangtime = 0
   chain.target.state = S_PLAY_RIDE
   end
   end
   if chain.valid
   if chain.validness == nil
   chain.validness = 0
   elseif chain.validness ~= nil
   chain.validness = $1 + 1
   elseif chain.grabbing == nil
   chain.grabbing = false
   end
   end
   if chain.valid
		and (chain.tracer and chain.tracer.valid)
        and chain.grabbing == true
		P_MoveOrigin(chain, chain.tracer.x, chain.tracer.y, chain.tracer.z)
		chain.hangtime = $1 + 1
		chain.ready = true
        chain.momz = 0
        chain.momx = 0
        chain.momy = 0
		if chain.hangtime == 1 then
        chain.currentdist = P_AproxDistance(P_AproxDistance(chain.target.x-chain.x, chain.target.y-chain.y) ,chain.target.z-chain.z)
        end
		end
end, MT_HOOKRING)

addHook("MobjMoveCollide", function(chain, targett)
		if targett and chain.valid
        if (targett.type == MT_HOOKPOINT)
		and not targett.player
		and chain.target
		and chain.target ~= targett
		and P_AproxDistance(P_AproxDistance(chain.target.x-chain.x, chain.target.y-chain.y) ,chain.target.z-chain.z) < distt
		and abs(chain.z - targett.z)<= targett.height
		if chain.goingback == false
		chain.tracer = targett
		chain.grabbing = true
		end
		end
		end
end, MT_HOOKRING)

addHook("MobjCollide", function(chain, targett)
		if targett and chain.valid
        if (targett.type == MT_HOOKPOINT)
		and not targett.player
		and chain.target
		and chain.target ~= targett
		and P_AproxDistance(P_AproxDistance(chain.target.x-chain.x, chain.target.y-chain.y) ,chain.target.z-chain.z) < distt
		and abs(chain.z - targett.z)<= targett.height
		if chain.goingback == false
		chain.tracer = targett
		chain.grabbing = true
		end
		end
		end
end, MT_HOOKRING)

addHook("MobjDamage", function(p, inflictor, source)
	if not (mapheaderinfo[gamemap].dwz or mapheaderinfo[gamemap].darkstabot) return end
        if p.chain and p.chain.valid
		p.player.readyreadyready = false
		p.target.grabbing = false
		p.player.hookhang = false
		p.player.feelinground = false
		p.player.feelingroundtimer = 0
		p.player.spinnow = false
		p.player.readytojump = false
		P_RemoveMobj(p.chain)
		end
        if p.player.feelinground == true
		p.player.feelinground = false
		p.player.feelingroundtimer = 0
		p.player.spinnow = false
		p.player.readytojump = false
		p.player.autodelay = 100
		end
end,MT_PLAYER)

addHook("MobjRemoved", function(p, inflictor, source)
	if not (mapheaderinfo[gamemap].dwz or mapheaderinfo[gamemap].darkstabot) return end
        if p.chain and p.chain.valid
		p.player.readyreadyready = false
		p.target.grabbing = false
		p.player.hookhang = false
		p.player.feelinground = false
		p.player.feelingroundtimer = 0
		p.player.spinnow = false
		p.player.readytojump = false
		P_RemoveMobj(p.chain)
		end
        if p.player.feelinground == true
		p.player.feelinground = false
		p.player.feelingroundtimer = 0
		p.player.spinnow = false
		p.player.readytojump = false
		end
end,MT_PLAYER)

addHook("MobjDeath", function(p, inflictor, source)
	if not (mapheaderinfo[gamemap].dwz or mapheaderinfo[gamemap].darkstabot) return end
        if p.chain and p.chain.valid
		p.player.readyreadyready = false
		p.target.grabbing = false
		p.player.hookhang = false
		p.player.feelinground = false
		p.player.feelingroundtimer = 0
		p.player.spinnow = false
		p.player.readytojump = false
		P_RemoveMobj(p.chain)
		end
        if p.player.feelinground == true
		p.player.feelinground = false
		p.player.feelingroundtimer = 0
		p.player.spinnow = false
		p.player.readytojump = false
		p.player.autodelay = 100
		end
end,MT_PLAYER)

addHook("PlayerSpawn", function(player)
 //for player in players.iterate // Sal: WHAT
		player.readyreadyready = false
		player.hookhang = false
		player.recoveryy = 0
		player.feelinground = false
		player.feelingroundtimer = 0
		player.spinnow = false
		player.readytojump = false
		player.autodelay = 0
		player.number = -100
		player.numbertwo = 150
		player.usedprefinishhook = false
		player.usedcutscenehook = false
 //end
end)

local function R_GetScreenCoords(p, c, mx, my, mz)
	local camx, camy, camz, camangle, camaiming
	if p.awayviewtics then
		camx = p.awayviewmobj.x
		camy = p.awayviewmobj.y
		camz = p.awayviewmobj.z
		camangle = p.awayviewmobj.angle
		camaiming = p.awayviewaiming
	elseif c.chase then
		camx = c.x
		camy = c.y
		camz = c.z
		camangle = c.angle
		camaiming = c.aiming
	else
		camx = p.mo.x
		camy = p.mo.y
		camz = p.viewz-20*FRACUNIT
		camangle = p.mo.angle
		camaiming = p.aiming
	end

	local x = camangle-R_PointToAngle2(camx, camy, mx, my)

	local distfact = cos(x)
	if not distfact then
		distfact = 1
	end -- MonsterIestyn, your bloody table fixing...

	if x > ANGLE_90 or x < ANGLE_270 then
		return -9, -9, 0
	else
		x = FixedMul(tan(x, true), 160<<FRACBITS)+160<<FRACBITS
	end

	local y = camz-mz
	if y == 0 then y = 1 end
	--//print(y/FRACUNIT)
	y = FixedDiv(y, FixedMul(distfact, R_PointToDist2(camx, camy, mx, my)))
	y = (y*160)+(100<<FRACBITS)
	y = y+tan(camaiming, true)*160

	local scale = FixedDiv(160*FRACUNIT, FixedMul(distfact, R_PointToDist2(camx, camy, mx, my)))
	--//print(scale)

	return x, y, scale
end
//I like to steal things.

hud.add(function(v, player, camera)
	for i = 1, #points
		if not points[i] then return end
		if player.readyreadyready == false
		and (points[i] and points[i].valid)
		and (player.mo and player.mo.valid)
		and R_PointToDist2(points[i].x,points[i].y,player.mo.x,player.mo.y) <= 350*FRACUNIT
		and abs(points[i].z-player.mo.z) <= 350*FRACUNIT
		and not (player.powers[pw_carry])
		and (player.playerstate == PST_LIVE)
		and not (points[i].spawnpoint.options & MTF_OBJECTSPECIAL)
		and player.hang == false
		and (points[i] ~= player.previouspoint)
		and not (player.powers[pw_super])
		and not (player.mo.state == S_PLAY_PAIN)
		and not (player.mo.state == S_PLAY_DEAD) then
			local x, y, scale = R_GetScreenCoords(player, camera, points[i].x, points[i].y, points[i].z + 16*points[i].scale)
			if x < 0 or x > 320*FRACUNIT or y < 0 or y > 200*FRACUNIT then return end
			local patch = v.cachePatch("AIM")
			local help = ("RING TOSS")
			if splitscreen and player == players[1] and y > 62*FRACUNIT then
				v.draw(x/FRACUNIT-18, y/FRACUNIT+30, patch, V_50TRANS)
				v.drawString(x/FRACUNIT-18, y/FRACUNIT+30, help, V_50TRANS)
			elseif splitscreen and player == players[0] and y < 138*FRACUNIT then
				v.draw(x/FRACUNIT-18, y/FRACUNIT-70, patch, V_50TRANS)
				v.drawString(x/FRACUNIT-18, y/FRACUNIT-70, help, V_50TRANS)
			elseif not splitscreen
				v.draw(x/FRACUNIT-18, y/FRACUNIT-20, patch, V_50TRANS)
				v.drawString(x/FRACUNIT-18, y/FRACUNIT-20, help, V_50TRANS)
			end
		end
	end
end, "game")
