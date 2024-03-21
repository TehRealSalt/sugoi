//Pulley in SRB2! Why? Why not? By Manimifire.

// V^^^^^^V
//  ^^^^^^
//  --__--
//    |
//    |
//    |
//    |
//    |                <-- Some weird shit.           --> Random thing because I'm bored: \(OwO)/
//                                                                                          ( )
//                                                                                          /  \
//    |
//    |
//    |
//  (^*^)
//  (^^^)
// {^^^^^}
// {-----}

freeslot("MT_PULLEY","MT_PULLEYBASE","MT_PULLEYPOINT","S_PULLEY","S_PULLEYBASE","S_PULLEYPOINT","SPR_PULL","sfx_pull")

mobjinfo[MT_PULLEY] = {
	//$Sprite PULLA0
	//$Name Pulley
	//$Category SUGOI Items & Hazards
    doomednum = 2800,
	spawnstate = S_PULLEY,
	height = 15*FRACUNIT,
	radius = 15*FRACUNIT,
	//flags = MF_SOLID|MF_FLOAT|MF_NOGRAVITY|MF_STICKY
	flags = MF_FLOAT|MF_NOGRAVITY|MF_STICKY
}

states[S_PULLEY] = {SPR_PULL, A, 1, nil, 0, 0, S_PULLEY}

//Now the base!

mobjinfo[MT_PULLEYBASE] = {
	//$Sprite PULLB0
	//$Name Pulley Base
	//$Category SUGOI Items & Hazards
    doomednum = 2801,
	spawnstate = S_PULLEYBASE,
	height = 14*FRACUNIT,
	radius = 25*FRACUNIT,
	flags = MF_SOLID|MF_FLOAT|MF_NOGRAVITY|MF_STICKY
}

states[S_PULLEYBASE] = {SPR_PULL, B, 1, nil, 0, 0, S_PULLEYBASE}

mobjinfo[MT_PULLEYPOINT] = {
	//$Sprite PULLB0
	//$Name Pulley Point
	//$Category SUGOI Items & Hazards
    doomednum = 2134,
	spawnstate = S_PULLEYPOINT,
	seestate = S_PULLEYPOINT,
	meleestate = S_PULLEYPOINT,
	missilestate = S_PULLEYPOINT,
	painstate = S_PULLEYPOINT,
	deathstate = S_PULLEYPOINT,
	xdeathstate = S_PULLEYPOINT,
	height = 14*FRACUNIT,
	radius = 25*FRACUNIT,
	flags = MF_FLOAT|MF_NOGRAVITY
}

states[S_PULLEYPOINT] = {SPR_NULL, A, 1, nil, 0, 0, S_PULLEYPOINT}

local bots = {}
local pulleypoints = {}

addHook("NetVars", function(network)
	bots = network(bots)
	pulleypoints = network(pulleypoints)
end)

addHook("MapLoad", do

	for point in mobjs.iterate()
	if point.type == MT_PLAYER
	and point.player
	and point.player.bot == 1
	table.insert(bots,point)
	end
	end

	for pointt in mobjs.iterate()
	if pointt.type == MT_PULLEYPOINT
	table.insert(pulleypoints,pointt)
	end
	end

  for player in players.iterate
    player.hang = false
	player.catch = false
	player.goingondelay = 0
	player.jumpbutton = 0
  end

end)

rawset(_G, "P_Activate2", function()

  for player in players.iterate

    if player.hang == nil
	player.hang = false
	end

	if player.dietimer == nil
	player.dietimer = 0
	end

	if player.playerstate == PST_DEAD
	player.dietimer = $1 + 1
	else
	player.dietimer = 0
	end

	if player.jumpbutton == nil
	player.jumpbutton = 0
	end

	if player.goingondelay == nil
	player.goingondelay = 0
	end

	if player.catch == nil
	player.catch = false
	end

	if player.hang == true
	player.mo.momz = 0
	end

	if player.goingondelay > 0
	player.goingondelay = $1 - 1
	end

	if player.cmd.buttons & BT_JUMP
	player.jumpbutton = $1 + 1
	else
	player.jumpbutton = 0
	end

	if player.playerstate == PST_DEAD
	player.hang = false
	player.catch = false
	player.goingondelay = 0
	player.jumpbutton = 0
	end

   if player.hang == true
   and player.hangobject and player.hangobject.valid
   player.mo.state = S_PLAY_RIDE
   P_MoveOrigin(player.mo,player.hangobject.x,player.hangobject.y,player.hangobject.z-42*FRACUNIT)
   player.mo.momx = 0
   player.mo.momy = 0
   player.powers[pw_nocontrol] = 1
   end

   for i = 1, #bots
   if (bots[i] and bots[i].valid)
   and player.hang == true
   and player.hangobject and player.hangobject.valid
   and bots[i].player.playerstate == PST_LIVE
   and bots[i].player.catch == false
   and not (bots[i].state == S_PLAY_PAIN)
   and not (bots[i].state == S_PLAY_DEAD)
   and bots[i].player.hangobjectrecent ~= player.hangobject
   P_MoveOrigin(bots[i],player.mo.x,player.mo.y,player.mo.z)
   bots[i].player.catch = true
   bots[i].player.hang = true
   bots[i].player.hangobject = player.hangobject
   bots[i].player.hangobjectrecent = player.hangobject
   bots[i].player.hangobject.playercount = $1 + 1
   end
   end

   if player.hang == true
   and player.catch == true
   and player.jumpbutton == 1
   and player.bot ~= 1
   //P_MoveOrigin(player.mo,player.hangobject.x+FixedMul(40*FRACUNIT, cos(player.mo.angle)),player.hangobject.y+FixedMul(40*FRACUNIT, cos(player.mo.angle)),player.mo.z)
   player.hangobject.playercount = $1 - 1
   player.mo.state = S_PLAY_JUMP
   P_Thrust(player.mo,player.mo.angle,19*FRACUNIT)
   player.hang = false
   player.catch = false
   player.goingondelay = 10
   player.mo.momz = 0
   player.hangobject = nil
   end

   for i = 1, #bots
   if (bots[i] and bots[i].valid)
   and bots[i].player.hang == true
   and bots[i].player.catch == true
   and player.bot ~= 1
   and player.hang == false
   bots[i].player.hangobject.playercount = $1 - 1
   bots[i].state = S_PLAY_JUMP
   P_Thrust(bots[i],player.mo.angle,19*FRACUNIT)
   bots[i].angle = player.mo.angle
   bots[i].player.hang = false
   bots[i].player.catch = false
   bots[i].player.goingondelay = 10
   bots[i].momz = 0
   bots[i].player.hangobject = nil
   end
   end

   if player.hangobject and player.hangobject.valid
   and player.hangobject.gotoangle == true
   and (player.hangobject.spawnpoint.options & MTF_OBJECTSPECIAL)
   and ((player.hangobject.z+player.hangobject.height>=(player.hangobject.spawnpoint.angle*FRACUNIT-10*FRACUNIT)) and (player.hangobject.z+player.hangobject.height<=player.hangobject.spawnpoint.angle*FRACUNIT+10*FRACUNIT))
   player.hangobject.goback = true
   player.hangobject.gotoangle = false
   player.hangobject.givepushback = true
   player.hangobject.giveanglepush = false
   player.hangobject.gobackdown = true
   player.mo.state = S_PLAY_JUMP
   player.hang = false
   player.catch = false
   player.hangobject.playercount = $1 - 1
   player.goingondelay = 10
   for sector in sectors.iterate
   for mobj in sector.thinglist()
   for rover in sector.ffloors()
   if mobj == player.hangobject
   and rover.master.frontside.midtexture == 1130
   P_Thrust(player.mo,player.mo.angle,rover.master.frontside.textureoffset)
   player.mo.momz = $1 + rover.master.frontside.rowoffset
   player.hangobject = nil
   end
   end
   end
   end
   end

   if player.hangobject and player.hangobject.valid
   and player.hangobject.gotoangle == true
   and (player.hangobject.spawnpoint.options & MTF_AMBUSH)
   and (player.hangobject.nextpoint and player.hangobject.nextpoint.valid)
   and (player.hangobject.originalx > player.hangobject.nextpoint.x)
   and (player.hangobject.x <= player.hangobject.nextpoint.x)
   player.mo.state = S_PLAY_JUMP
   player.hangobject.momx = 0
   player.hangobject.momy = 0
   player.hangobject.momz = 0
   player.hang = false
   player.catch = false
   player.hangobject.playercount = $1 - 1
   player.goingondelay = 10
   player.hangobject.goback = true
   player.hangobject.gotoangle = false
   player.hangobject.givepushback = true
   player.hangobject.giveanglepush = false
   player.hangobject.gobackdown = true
   P_Thrust(player.mo,player.mo.angle,10*FRACUNIT)
   player.mo.momz = $1 + 3*FRACUNIT
   player.hangobject = nil
   end

   if player.hangobject and player.hangobject.valid
   and player.hangobject.gotoangle == true
   and (player.hangobject.spawnpoint.options & MTF_AMBUSH)
   and (player.hangobject.nextpoint and player.hangobject.nextpoint.valid)
   and (player.hangobject.originalx < player.hangobject.nextpoint.x)
   and (player.hangobject.x >= player.hangobject.nextpoint.x)
   player.mo.state = S_PLAY_JUMP
   player.hangobject.momx = 0
   player.hangobject.momy = 0
   player.hangobject.momz = 0
   player.hang = false
   player.catch = false
   player.hangobject.playercount = $1 - 1
   player.goingondelay = 10
   player.hangobject.goback = true
   player.hangobject.gotoangle = false
   player.hangobject.givepushback = true
   player.hangobject.giveanglepush = false
   player.hangobject.gobackdown = true
   P_Thrust(player.mo,player.mo.angle,10*FRACUNIT)
   player.mo.momz = $1 + 3*FRACUNIT
   player.hangobject = nil
   end

   if player.goingondelay == 1
   player.hangobjectrecent = nil
   end

  end
end)

addHook("AbilitySpecial", function(player)
 if player.hang == true
 and player.hangobject and player.hangobject.valid
 return true
 end

 if player.hang == true
 and player.catch == true
 and player.jumpbutton == 1
 return true
 end

 if player.goingondelay > 0
 return true
 end

end)

addHook("MapChange", do
  for player in players.iterate
    player.hang = false
	player.catch = false
	player.goingondelay = 0
	player.jumpbutton = 0
  end
end)

addHook("PlayerSpawn", function(player)
    if player
    player.hang = false
	player.catch = false
	player.goingondelay = 0
	player.jumpbutton = 0
	end
end)

addHook("MobjThinker", function(pulley)
if not pulley return end

   for i = 1, #pulleypoints
   if (pulleypoints[i] and pulleypoints[i].valid)
   and (pulleypoints[i].spawnpoint.angle == pulley.spawnpoint.angle)
   and (pulley.spawnpoint.options & MTF_AMBUSH)
   pulley.nextpoint = pulleypoints[i]
   end
   end

   if not (pulley.spawnpoint.options & MTF_AMBUSH)
   pulley.nextpoint = pulley
   end

   if pulley.gotoangle == nil
   pulley.gotoangle = false
   end

   if pulley.gobackdown == nil
   pulley.gobackdown = false
   end

   if pulley.gobackdowntimer == nil
   pulley.gobackdowntimer = 0
   end

   if pulley.goback == nil
   pulley.goback = false
   end

   if pulley.givepushback == nil
   pulley.givepushback = false
   end

   if pulley.givepushtimer == nil
   pulley.givepushtimer = 0
   end

   if pulley.givepushback == true
   pulley.givepushtimer = $1 + 1
   else
   pulley.givepushtimer = 0
   end

   if pulley.giveanglepush == nil
   pulley.giveanglepush = false
   end

   if pulley.giveangletimer == nil
   pulley.giveangletimer = 0
   end

   if pulley.giveanglepush == true
   pulley.giveangletimer = $1 + 1
   else
   pulley.giveangletimer = 0
   end

   if pulley.gobackdown == true
   pulley.gobackdowntimer = $1 + 1
   else
   pulley.gobackdowntimer = 0
   end

   if pulley.originalz == nil
   pulley.originalz = pulley.z
   end

   if pulley.originalx == nil
   pulley.originalx = pulley.x
   end

   if pulley.originaly == nil
   pulley.originaly = pulley.y
   end

   if pulley.playercount == nil
   pulley.playercount = 0
   end

 for player in players.iterate
   if pulley and pulley.valid
   and player.mo and player.mo.valid
   and player.playerstate == PST_LIVE
   and R_PointToDist2(player.mo.x,player.mo.y,pulley.x,pulley.y)<= 42*FRACUNIT
   and abs(player.mo.z - pulley.z)<= 28*FRACUNIT
   and player.catch == false
   and not (player.mo.state == S_PLAY_PAIN)
   and not (player.mo.state == S_PLAY_DEAD)
   //and player.goingondelay == 0
   and player.hangobjectrecent ~= pulley
   player.catch = true
   player.hang = true
   player.hangobject = pulley
   player.hangobjectrecent = pulley
   pulley.hang = true
   pulley.playercount = $1 + 1
   if pulley.gotoangle == false
   and pulley.goback == false
   pulley.gotoangle = true
   pulley.goback = false
   pulley.giveanglepush = true
   end
   end
 end

   if pulley.gotoangle == true
   and pulley.playercount == 0
   and (pulley.z+pulley.height>=pulley.spawnpoint.angle*FRACUNIT-10*FRACUNIT) and (pulley.z+pulley.height<=pulley.spawnpoint.angle*FRACUNIT+10*FRACUNIT)
   and not (pulley.spawnpoint.options & MTF_AMBUSH)
   pulley.goback = true
   pulley.givepushtimer = 0
   pulley.gotoangle = false
   pulley.givepushback = true
   pulley.giveanglepush = false
   pulley.gobackdown = false
   pulley.hang = true
   end

   if pulley.gotoangle == true
   and (pulley.nextpoint and pulley.nextpoint.valid)
   and pulley.playercount == 0
   and (pulley.originalx < pulley.nextpoint.x)
   and (pulley.x >= pulley.nextpoint.x)
   and (pulley.spawnpoint.options & MTF_AMBUSH)
   pulley.goback = true
   pulley.gotoangle = false
   pulley.givepushback = true
   pulley.giveanglepush = false
   pulley.gobackdown = false
   pulley.hang = true
   end

   if pulley.gotoangle == true
   and (pulley.nextpoint and pulley.nextpoint.valid)
   and pulley.playercount == 0
   and (pulley.originalx > pulley.nextpoint.x)
   and (pulley.x <= pulley.nextpoint.x)
   and (pulley.spawnpoint.options & MTF_AMBUSH)
   pulley.goback = true
   pulley.gotoangle = false
   pulley.givepushback = true
   pulley.giveanglepush = false
   pulley.gobackdown = false
   pulley.hang = true
   end

   if pulley.gotoangle == true
   if pulley.playercount == 0
   and not (pulley.spawnpoint.options & MTF_AMBUSH)
   and (((pulley.z+pulley.height<pulley.spawnpoint.angle*FRACUNIT) and (pulley.z+pulley.height<pulley.spawnpoint.angle*FRACUNIT-10*FRACUNIT) and (pulley.z+pulley.height>pulley.originalz) and (pulley.z+pulley.height>pulley.originalz+10*FRACUNIT))
   or ((pulley.z+pulley.height>pulley.spawnpoint.angle*FRACUNIT) and (pulley.z+pulley.height>pulley.spawnpoint.angle*FRACUNIT+10*FRACUNIT) and (pulley.z+pulley.height<pulley.originalz) and (pulley.z+pulley.height<pulley.originalz-10*FRACUNIT)))
   pulley.goback = true
   pulley.gotoangle = false
   pulley.givepushback = true
   pulley.giveanglepush = false
   pulley.gobackdown = false
   pulley.momz = 0
   pulley.hang = true
   end
   end

   if pulley.gotoangle == true
   if pulley.playercount == 0
   and (pulley.nextpoint and pulley.nextpoint.valid)
   and (pulley.spawnpoint.options & MTF_AMBUSH)
   and (((pulley.z<pulley.nextpoint.x) and (pulley.z>pulley.originalx))
   or ((pulley.z>pulley.nextpoint.x) and (pulley.z<pulley.originalx)))
   pulley.goback = true
   pulley.gotoangle = false
   pulley.givepushback = true
   pulley.giveanglepush = false
   pulley.gobackdown = false
   pulley.momz = 0
   pulley.momx = 0
   pulley.momy = 0
   pulley.hang = true
   --print("go to next point WAIT NO PLAYERS")
   end
   end

   if pulley.goback == true
   and pulley.playercount > 0
   //and (pulley.z+pulley.height>=pulley.originalz-10*FRACUNIT) and (pulley.z+pulley.height<=pulley.originalz+10*FRACUNIT)
   pulley.goback = false
   pulley.gotoangle = true
   pulley.momz = 0
   pulley.momx = 0
   pulley.momy = 0
   pulley.giveanglepush = true
   pulley.givepushback = false
   pulley.gobackdown = false
   pulley.hang = true
   --print("go to prev point WAIT PLAYERS ABOARD")
   end

   if pulley.gotoangle == true
   and pulley.playercount > 0
   and not (pulley.spawnpoint.options & MTF_AMBUSH)
   and (pulley.z+pulley.height>=pulley.spawnpoint.angle*FRACUNIT-10*FRACUNIT) and (pulley.z+pulley.height<=pulley.spawnpoint.angle*FRACUNIT+10*FRACUNIT)
   pulley.momz = 0
   pulley.hang = false
   end

   if pulley.gotoangle == true
   and (pulley.nextpoint and pulley.nextpoint.valid)
   and pulley.playercount > 0
   and (pulley.spawnpoint.options & MTF_AMBUSH)
   and (pulley.originalx > pulley.nextpoint.x)
   and (pulley.x <= pulley.nextpoint.x)
   pulley.momz = 0
   pulley.momx = 0
   pulley.momy = 0
   pulley.hang = false
   --print("you arrived to the pullley's next point")
   end

   if pulley.gotoangle == true
   and (pulley.nextpoint and pulley.nextpoint.valid)
   and pulley.playercount > 0
   and (pulley.spawnpoint.options & MTF_AMBUSH)
   and (pulley.originalx < pulley.nextpoint.x)
   and (pulley.x >= pulley.nextpoint.x)
   pulley.momz = 0
   pulley.momx = 0
   pulley.momy = 0
   pulley.hang = false
   --print("you arrived to the pullley's next point")
   end

   if pulley.goback == true
   and pulley.playercount == 0
   and not (pulley.spawnpoint.options & MTF_AMBUSH)
   and ((pulley.z+pulley.height>=pulley.originalz-10*FRACUNIT) and (pulley.z+pulley.height<=pulley.originalz+10*FRACUNIT))
   pulley.momz = 0
   pulley.hang = false
   end

   if pulley.goback == true
   and (pulley.nextpoint and pulley.nextpoint.valid)
   and pulley.playercount == 0
   and (pulley.spawnpoint.options & MTF_AMBUSH)
   and (pulley.nextpoint.x < pulley.originalx)
   and (pulley.x >= pulley.originalx)
   pulley.momz = 0
   pulley.momx = 0
   pulley.momy = 0
   pulley.hang = false
   --print("you arrived to the pullley's prev point")
   end

   if pulley.goback == true
   and (pulley.nextpoint and pulley.nextpoint.valid)
   and pulley.playercount == 0
   and (pulley.spawnpoint.options & MTF_AMBUSH)
   and (pulley.nextpoint.x > pulley.originalx)
   and (pulley.x <= pulley.originalx)
   pulley.momz = 0
   pulley.momx = 0
   pulley.momy = 0
   pulley.hang = false
   --print("you arrived to the pullley's prev point")
   end

   if not (pulley.spawnpoint.options & MTF_AMBUSH)
   if pulley.goback == true
   if pulley.givepushtimer == 1
   if (pulley.z < pulley.originalz)
   pulley.momz = 15*FRACUNIT
   pulley.hang = true
   elseif (pulley.z > pulley.originalz)
   pulley.momz = (-1)*15*FRACUNIT
   pulley.hang = true
   end
   end
   end
   end

   if (pulley.spawnpoint.options & MTF_AMBUSH)
   if (pulley.nextpoint and pulley.nextpoint.valid)
   if pulley.goback == true
   if pulley.givepushtimer == 1
   if (pulley.x<pulley.originalx)
   and (pulley.originalx>pulley.nextpoint.x)
   pulley.momx = 50*FRACUNIT
   end
   end
   end
   end
   end

   if (pulley.spawnpoint.options & MTF_AMBUSH)
   if (pulley.nextpoint and pulley.nextpoint.valid)
   if pulley.goback == true
   if pulley.givepushtimer == 1
   if (pulley.x>pulley.originalx)
   and (pulley.originalx<pulley.nextpoint.x)
   pulley.momx = (-1)*50*FRACUNIT
   end
   end
   end
   end
   end

   if not (pulley.spawnpoint.options & MTF_AMBUSH)
   if pulley.gotoangle == true
   if pulley.giveangletimer == 1
   if (pulley.z+pulley.height<pulley.spawnpoint.angle*FRACUNIT)
   pulley.momz = 15*FRACUNIT
   pulley.hang = true
   elseif (pulley.z+pulley.height>pulley.spawnpoint.angle*FRACUNIT)
   pulley.momz = (-1)*15*FRACUNIT
   pulley.hang = true
   end
   end
   end
   end

   if (pulley.spawnpoint.options & MTF_AMBUSH)
   if (pulley.nextpoint and pulley.nextpoint.valid)
   if pulley.gotoangle == true
   if pulley.giveangletimer == 1
   if (pulley.x<pulley.nextpoint.x)
   and (pulley.nextpoint.x>pulley.originalx)
   pulley.momx = 50*FRACUNIT
   end
   end
   end
   end
   end

   if (pulley.spawnpoint.options & MTF_AMBUSH)
   if (pulley.nextpoint and pulley.nextpoint.valid)
   if pulley.gotoangle == true
   if pulley.giveangletimer == 1
   if (pulley.x>pulley.nextpoint.x)
   and (pulley.nextpoint.x<pulley.originalx)
   pulley.momx = (-1)*50*FRACUNIT
   end
   end
   end
   end
   end

   if pulley.hang == nil
	pulley.hang = false
   end

   if pulley.hangtimer == nil
	pulley.hangtimer = 0
   end

	if pulley.hang == true
	  pulley.hangtimer = $1 + 1
	else
	  pulley.hangtimer = 0
	end

	if pulley.hangtimer == 5
	  pulley.hangtimer = 0
	end

   if pulley.hangtimer == 1
   and not (pulley.spawnpoint.options & MTF_AMBUSH)
   and (((pulley.z+pulley.height<pulley.spawnpoint.angle*FRACUNIT) and (pulley.z+pulley.height<pulley.spawnpoint.angle*FRACUNIT-10*FRACUNIT) and (pulley.z+pulley.height>pulley.originalz) and (pulley.z+pulley.height>pulley.originalz+10*FRACUNIT))
   or ((pulley.z+pulley.height>pulley.spawnpoint.angle*FRACUNIT) and (pulley.z+pulley.height>pulley.spawnpoint.angle*FRACUNIT+10*FRACUNIT) and (pulley.z+pulley.height<pulley.originalz) and (pulley.z+pulley.height<pulley.originalz-10*FRACUNIT)))
	S_StartSound(pulley,sfx_pull)
   end

   if pulley.hangtimer == 1
    and (pulley.spawnpoint.options & MTF_AMBUSH)
	and (pulley.nextpoint and pulley.nextpoint.valid)
	and (((pulley.x<pulley.nextpoint.x) and (pulley.x>pulley.originalx))
    or ((pulley.x>pulley.nextpoint.x) and (pulley.x<pulley.originalx)))
	  S_StartSound(pulley,sfx_pull)
   end

  if (pulley.spawnpoint.options & MTF_AMBUSH)
   and (pulley.nextpoint and pulley.nextpoint.valid)
   and (((pulley.x<pulley.nextpoint.x) and (pulley.x>pulley.originalx))
   or ((pulley.x>pulley.nextpoint.x) and (pulley.x<pulley.originalx)))
	local fire = P_SpawnMobj(pulley.x+P_RandomRange(-10,10)*FRACUNIT,pulley.y+P_RandomRange(-10,10)*FRACUNIT,pulley.z+pulley.height+20*FRACUNIT+P_RandomRange(-10,10)*FRACUNIT,MT_DESOLATELIGHT)
	fire.state = S_SPINFIRE1
	fire.fuse = 7
	fire.scale = pulley.scale/2
  end

end,MT_PULLEY)

addHook("MobjDamage", function(p, inflictor, source)
	if not (mapheaderinfo[gamemap].dwz or mapheaderinfo[gamemap].darkstabot) return end

         p.player.hang = false
		 p.player.catch = false
		 p.player.goingondelay = 10
         if p.player.hangobject and p.player.hangobject.valid
		 p.player.hangobject.playercount = $1 - 1
		 p.player.hangobject = nil
		 end
end, MT_PLAYER)

addHook("MobjDeath", function(p, inflictor, source)
	if not (mapheaderinfo[gamemap].dwz or mapheaderinfo[gamemap].darkstabot) return end

         p.player.hang = false
		 p.player.catch = false
		 p.player.goingondelay = 10
         if p.player.hangobject and p.player.hangobject.valid
		 p.player.hangobject.playercount = $1 - 1
		 p.player.hangobject = nil
		 end
end, MT_PLAYER)

addHook("MobjRemoved", function(p)
	if not (mapheaderinfo[gamemap].dwz or mapheaderinfo[gamemap].darkstabot) return end

         p.player.hang = false
		 p.player.catch = false
		 p.player.goingondelay = 10
         if p.player.hangobject and p.player.hangobject.valid
		 p.player.hangobject.playercount = $1 - 1
		 p.player.hangobject = nil
		 end
end, MT_PLAYER)