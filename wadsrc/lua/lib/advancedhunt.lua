/*
Latius' Emerald (and Ideya) Hunt Lua Script, Version 1.3.2

This Lua script allows you to make Emerald Hunt stages where each
Emerald looks different.

Plus, with the use of LUA.numideyas, it is possible to choose how many of them
have to be collected, from 1 to 7.

To use this, all you need to do is place Thing 3219s into your map in place of
the Emerald Hunt things.

Thanks to Steel Titanium for helping with the 1.3 updates
*/

-- Make free slots for all Emeralds and/or Ideya (excluding the temp ones)
-- plus use our own Hunt Emeralds

freeslot("SPR_IDEY","S_IDEYA00","S_IDEYA01","S_IDEYA02","S_IDEYA03","S_IDEYA04","S_IDEYA05","S_IDEYA06","S_IDEYA07","MT_HUNT_IDEYA")

-- Set states for the Ideyas/Emeralds

-- State for any Ideyas during map loading
states[S_IDEYA00] = {SPR_NULL, A, -1,nil,0,0,S_IDEYA00}

-- States of the seven Emeralds
states[S_IDEYA01] = {SPR_IDEY, A, -1,nil,0,0,S_IDEYA01} //Green Emerald
states[S_IDEYA02] = {SPR_IDEY, B, -1,nil,0,0,S_IDEYA02} //Purple Emerald
states[S_IDEYA03] = {SPR_IDEY, C, -1,nil,0,0,S_IDEYA03} //Blue Emerald
states[S_IDEYA04] = {SPR_IDEY, D, -1,nil,0,0,S_IDEYA04} //Light Blue Emerald
//I know some call it the Cyan Emerald, but the Wiki calls it Light Blue -Latius
states[S_IDEYA05] = {SPR_IDEY, E, -1,nil,0,0,S_IDEYA05} //Orange Emerald
states[S_IDEYA06] = {SPR_IDEY, F, -1,nil,0,0,S_IDEYA06} //Red Emerald
states[S_IDEYA07] = {SPR_IDEY, G, -1,nil,0,0,S_IDEYA07} //White Emerald

-- Local values for number of Ideyas/Emeralds

local numbideya = 7 //The max number of Ideya. Stays in the script
local MAXHUNTIDEYA = 64 //The max number of Hunt Ideya to consider. CONSTANT
local MAXSPAWNIDEYA = 7 //Soft cap for max nunber of spawnable Ideyas. CONSTANT
local mapideyas //Local value of how many Ideya Spawns there are on the map
				//which are valid. Used when spawning the Ideyas.
local ideyalocations = {} //Current Ideya Locations.
local allideyalocations = {} //All valid spawnable Ideya Locations
local spawnideyas //Local value for how many Ideyas to spawn.
				  //Only changes with the map.
local ideyastate = {} //Used to refrence the state of the current Ideya locations
local ideyacollected = {} //Used to tell if an Ideya is collected
local ideyanum = {} //Used to make sure an Ideya isn't chosen twice
local numideyascollected //Number of Ideyas collected
local radarrange //The max range of the Ideya Radar. Only changes with the map
local soundinterval //Radar sound interval

//Time to make the Thing to collect
mobjinfo[MT_HUNT_IDEYA] = {
	//$Name Advanced Hunt Ideya
	//$Sprite IDEYF0
	//$Category SUGOI Powerups
	doomednum = 3219, //Hopefully this number isn't used by other Things...
    spawnstate = S_IDEYA00, //The default state until the actual state is
							//chosen during MapLoad
    spawnhealth = 1000,
    seestate = S_NULL, //Not needed
    seesound = sfx_None,
    reactiontime = 0,
    attacksound = sfx_None, //Can't attack
    painstate = S_NULL, //Not needed
    painchance = 0,
    painsound = sfx_None,
    meleestate = S_NULL, //Can't attack, so not needed
    missilestate = S_NULL, //Also not needed
    deathstate = S_SPRK1, //Needed so that the Emerald is collected
    xdeathstate = S_NULL, //Not a boss, so not needed
	deathsound = sfx_cgot, //Chaos Emerald collection sound
	speed = 10,
	radius = 16*FRACUNIT,
	height = 32*FRACUNIT,
	dispoffset = 0,
	mass = 4,
	damage = 0,
	activesound = sfx_None,
	raisestate = S_NULL,
	flags = MF_SPECIAL|MF_NOGRAVITY	//Special Collection, plus not affected by gravity
}


local function draw_IdeyaHUD(v, x, y, collect, total, flags)
	/*
	This function draws the portion of the Heads Up Displace which shows the
	number of Ideya... I mean, Emeralds collected.
	*/

	local draw_num
	if not collect then collect = 0 end //Assume that if Collect is not given,
										//no Emeralds are collected. But,
										//that should be given anyway

	/*
	Collect has to be a number between 0 and total. If it's not in that range,
	make it fit that range.
	*/
	collect = max($, 0)
	collect = min($, total)

	//Get the string versions of Collect and Total
	collect = tostring(collect)
	local total_s = tostring(total) //The Local value is because in the DrEAMS
									//version of this script, total is compared
									//to see if it's above 9, and if so, the
									//number stuff is adjusted to fit.

	v.draw(x, y, v.cachePatch("SBOEMER"), flags) //Draw the Ideya part of the HUD

	local num_xpos = x + 70 //Used for the x position of the numbers and "/"

	//Draw the number collected
	draw_num =string.sub(collect, 1, 1)
	v.draw(num_xpos, y, v.cachePatch("STTNUM"..tostring(draw_num)), flags)
	num_xpos = $ + 8

	//Draw the "/"
	v.draw(num_xpos, y, v.cachePatch("STTSLASH"), flags)
	num_xpos = $ + 8

	//Draw the total number of Emeralds to collect
	draw_num =string.sub(total_s, 1, 1)
	v.draw(num_xpos, y, v.cachePatch("STTNUM"..tostring(draw_num)), flags)
end


local function draw_IdeyaRadar(v, x, y, state, flags)
	/*
	Takes a Radar State between 1 and 6 - 1 being Out of Range, and 6 being
	Very Close - and puts the revelant Radar Image on the HUD
	*/

	if not state then state = 1 end //If a State is not given, then it must be
									//out of range.

	//Make sure the State is between 1 and 6
	state = max($, 1)
	state = min($, 6)

	//Finally, draw the Radar Image using the state given.
	v.draw(x, y, v.cachePatch("HOMING"..tostring(state)), flags)
end


addHook("MapLoad", do

	//First, we need to reset some bits
	mapideyas = 0 //No Emeralds detected yet
	allideyalocations = {} //No locations given yet
	ideyalocations = {} //No Emeralds chosen yet
	spawnideyas = 0 	//          "
	ideyastate = {}		//          "
	ideyacollected = {} //          "
	ideyanum = {}       //          "
	numideyascollected = 0 //No Emeralds collected yet
	soundinterval = -1

	//Also, reset the radar range to the default value
	radarrange = 2560 * FRACUNIT

	//Next, let's get the valid Ideya Locations, and add them to the table of all spawnable locations.
	for mobj in mobjs.iterate()
		if mobj and mobj.type == MT_HUNT_IDEYA //Is it one of the items we made?
			if mobj.valid and mapideyas < MAXHUNTIDEYA //Yes, so is it valid, and
													   //not over the hard cap?
				table.insert(allideyalocations, mobj) //Yes, so add it
				mapideyas = mapideyas + 1 //One more Emerald which is valid
			end
		end
	end


	//Now set the number of spawnable Ideyas
	if not mapheaderinfo[gamemap].numideyas //If not set in the map header
											//set to default value
		spawnideyas = 3
	elseif mapheaderinfo[gamemap].numideyas
		spawnideyas = tonumber(mapheaderinfo[gamemap].numideyas)
	end
	if spawnideyas > MAXSPAWNIDEYA //If the value is too high, cap it
		spawnideyas = MAXSPAWNIDEYA
	end

	//while we are at it, get the radar range from the map header if there is one
	if mapheaderinfo[gamemap].radarrange
		radarrange = mapheaderinfo[gamemap].radarrange * FRACUNIT
	end


	if mapideyas >= spawnideyas //Only do the next block if enough Ideya Spawn
								//Points were placed on the map
		/*
		Now, we go through the table and randomly pick a number of them
		dependant on how many Ideyas were chosen to be spawn, then add them
		to the spawned table
		*/

		//Temp flags and values for spawning the Emeralds
		local tempflag
		local tempval

		for i = 1,spawnideyas //We do this as many times as spawnideyas states
			repeat
				tempval = P_RandomKey(mapideyas) + 1 //This gives a value
													 //between 1 and mapideyas
				tempflag = true //It could be okay
				if i != 1 //IS this not the first Ideya to be spawned?
					for j = 1,i-1 //No, so check the list.
						if ideyanum[j] == tempval //We have a match...
							tempflag = false //So don't use it
						end
					end
				end
			until tempflag == true //It's okay, so it can be used.

			//Insert the Ideya into the table
			table.insert(ideyalocations, allideyalocations[tempval])
			table.insert(ideyanum, tempval) //And add the value to the table

			//Next, we spawn the chosen Ideyas after making sure each one has a
			//different sprite
			repeat
				tempval = P_RandomKey(numbideya) + 1
				tempflag = true //It could be okay
				if i != 1 //IS this not the first Ideya to be spawned?
					for j = 1,i-1 //No, so check the list.
						if ideyastate[j] == tempval //We have a match...
							tempflag = false //So don't use it
						end
					end
				end
			until tempflag == true

			//Need to spawn the Ideya using the value to determine the state
			P_SetMobjStateNF(ideyalocations[i], ideyalocations[i].state + tempval)
			table.insert(ideyacollected, false)
			table.insert(ideyastate, tempval)
		end

	elseif mapideyas > 0 //You didn't add enough Spawn points.
		print("Not enough Ideya Spawn points!")
		spawnideyas = 0
	else
		spawnideyas = 0
	end

end)


//This syncs new joiners with the others
addHook("NetVars", function(nethunt)
	spawnideyas = nethunt(spawnideyas) //Get the number of spawn Ideyas
	ideyalocations = nethunt(ideyalocations) //Get the location of the Ideyas
	numideyascollected = nethunt(numideyascollected) //Get the number of
													 //already collected Ideyas
	ideyacollected = nethunt(ideyacollected) //Get the table of the Ideyas
											 //already collected
	ideyastate = nethunt(ideyastate) //Get the table of the Ideya States
	radarrange = nethunt(radarrange) //Get the range of the Radar
	mapideyas = nethunt(mapideyas) //Fix the Map Ideyas
end)


//This hook deals with collecting the Ideyas/Emeralds
addHook("TouchSpecial", function(mo, touch)

	//Check to see if this is in a collectable state.
	if mo.state != S_IDEYA00 //It can be collected.
		for i = 1,spawnideyas //Find out which Ideya was collected
			if ideyalocations[i] == mo //This is the one
				ideyacollected[i] = true //Set the Ideya as collected
				//print("Ideya "..i.." collected")
			end
		end

		numideyascollected = numideyascollected + 1 //One less Ideya to collect
		if numideyascollected == spawnideyas //All Ideya collected?
			//print("All Ideya Collected!")
			soundinterval = -1
			A_PlaySound(mo,sfx_zelda) //Play a tune to signal the level's cleared
			A_ForceWin(mo) //Set the player into an exiting state
			if netgame then //Only do this if in a netgame
				for player in players.iterate
					if player.valid and (not (player.mo == mo)) then A_ForceWin(player.mo) end //If player is valid and not the one who got the last Emerald, put them into an exiting state as well
				end
			end
		end
	else
		//print("Ideya not collected...")
		mo.state = S_NULL
	end
end, MT_HUNT_IDEYA)

hud.add(function(v, p)
	if mapideyas < 1 then return end //Nope, don't do it unless mapideyas is 1+
	if p.spectator then return end //Double nope, spectators can't get this.
	if not p.mo then return end //TRIPLE NOPE!

	local mo = p.mo //Get the mo of p
	local disttoideya
	local radarstate

	//The Radar position of each Emerald on the HUD
	local radarx = 160 - (10 * (spawnideyas - 1))
	local radary = 168

	// Sal: Admittedly, I just think this is kinda ugly, so I didn't want to port it :V
	//draw_IdeyaHUD(v, 16, 58, numideyascollected, spawnideyas, V_SNAPTOTOP)

	if not mapheaderinfo[gamemap].radaroff //Only do this if the radar is not turned off
		for i = 1,spawnideyas
			if not ideyacollected[i] //Is this Ideya collected?
				//No, so we draw the Radar image for it.

				//First, we need to tell where the Player is in relation to it.
				disttoideya = R_PointToDist2(mo.x, mo.y, ideyalocations[i].x, ideyalocations[i].y)

				//Now, we need to convert it into a state, using the radarrange
				if disttoideya > radarrange //Out of range
					radarstate = 1
				elseif disttoideya > (3 * radarrange / 4)
					radarstate = 2
				elseif disttoideya > (radarrange / 2)
					radarstate = 3
				elseif disttoideya > (radarrange / 4)
					radarstate = 4
				elseif disttoideya > (radarrange / 10)
					radarstate = 5
				else
					radarstate = 6
				end
				draw_IdeyaRadar(v, radarx, radary, radarstate, V_SNAPTOBOTTOM)
			end

			//Get ready for the next Ideya Radar
			radarx = $ + 20
		end
	end
end)

//Used to play the sound
addHook("ThinkFrame", function()
	if not spawnideyas then return end

	local disttoideya
	local beststate

	beststate = 0

	for player in players.iterate do
		if player.spectator then continue end
		if not player.mo then continue end

		if not mapheaderinfo[gamemap].soundoff then //The sound can be turned on and off seperate from the radar
			for i = 1,spawnideyas
				if not ideyacollected[i] then
					disttoideya = R_PointToDist2(player.mo.x, player.mo.y, ideyalocations[i].x, ideyalocations[i].y)

					if disttoideya > radarrange
						beststate = max($, 1)
						if beststate == 1 then soundinterval = 0 end
					elseif disttoideya > (3 * radarrange / 4)
						beststate = max($, 2)
						if beststate == 2 then soundinterval = 35 end
					elseif disttoideya > (radarrange / 2)
						beststate = max($, 3)
						if beststate == 3 then soundinterval = 30 end
					elseif disttoideya > (radarrange / 4)
						beststate = max($, 4)
						if beststate == 4 then soundinterval = 20 end
					elseif disttoideya > (radarrange / 10)
						beststate = max($, 5)
						if beststate == 5 then soundinterval = 10 end
					else
						beststate = 6
						soundinterval = 5
					end
				end
			end
		end

		if (leveltime and soundinterval != nil)
		and (soundinterval > 0 and leveltime % soundinterval == 0)
			S_StartSound(nil, sfx_emfind, player)
		end
	end
end)