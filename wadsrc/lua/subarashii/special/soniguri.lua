/*
WELCOME TO THE WONDERFUL WIDE WORLD OF SONIGURI'S CODE
it's mostly trash
ok mostly the collision is trash
i swear i have better collision code now a days
i just dont wanna port it to lua
also some context relating to comments that mention Heat 300%
Heat 300% was a little fangame thingy i was making at some point
in lua
then sugoi 2 was announced
i knew what i had to do
*/

freeslot(
"sfx_sdash",
"sfx_beams",
"sfx_bazook",
"sfx_scrash",
"sfx_ssplod",
"sfx_sdead",
"sfx_shyper"
)

sfxinfo[sfx_sdash] = {
	singular = true,
	priority = 64
}

sfxinfo[sfx_beams] = {
	singular = true,
	priority = 64
}

sfxinfo[sfx_bazook] = {
	singular = false,
	priority = 64
}

sfxinfo[sfx_scrash] = {
	singular = false,
	priority = 64
}

sfxinfo[sfx_ssplod] = {
	singular = false,
	priority = 64
}

sfxinfo[sfx_sdead] = {
	singular = false,
	priority = 64
}

sfxinfo[sfx_shyper] = {
	singular = true,
	priority = 64
}

local HALFUNIT = FRACUNIT/2

local bulletwidths = {}
bulletwidths[1] = 4
bulletwidths[10] = 4
bulletwidths[12] = 11
bulletwidths[14] = 20
bulletwidths[23] = 8
bulletwidths[32] = 13
bulletwidths[33] = 13
bulletwidths[34] = 5

local bulletheights = {}
bulletheights[1] = 16
bulletheights[10] = 16
bulletheights[12] = 17
bulletheights[14] = 20
bulletheights[23] = 8
bulletheights[32] = 205
bulletheights[33] = 205
bulletheights[34] = 12

local function playercollision(imagewidth,imageheight,object,bulletarray)//huge collision function ported from heat 300%. this thing took days to make back when I did, and it's pretty garbage tbh
	local x=(object.x/HALFUNIT)/2
	local y=(object.y/HALFUNIT)/2
	local rotation=object.direction*FRACUNIT

	local point1 = {}
	local point2 = {}
	local point3 = {}
	local point4 = {}
	local point5 = {}
	local point6 = {}
	local point7 = {}
	local point8 = {}

	point1[1]=FixedMul((imagewidth)*FRACUNIT,cos(FixedAngle(rotation)))/FRACUNIT --right --math to find points
	point1[2]=FixedMul(imagewidth*FRACUNIT,sin(FixedAngle(rotation)))/FRACUNIT
	point2[1]=FixedMul((imagewidth*-1)*FRACUNIT,cos(FixedAngle(rotation)))/FRACUNIT--left
	point2[2]=FixedMul((imagewidth*-1)*FRACUNIT,sin(FixedAngle(rotation)))/FRACUNIT
	point3[1]=FixedMul((imageheight)*FRACUNIT,(sin(FixedAngle(rotation)))*-1)/FRACUNIT--bottom
	point3[2]=FixedMul((imageheight)*FRACUNIT,(cos(FixedAngle(rotation))))/FRACUNIT
	point4[1]=FixedMul((imageheight*-1)*FRACUNIT,(sin(FixedAngle(rotation)))*-1)/FRACUNIT--top
	point4[2]=FixedMul((imageheight*-1)*FRACUNIT,(cos(FixedAngle(rotation))))/FRACUNIT

	point5[1]=point1[1]+point3[1]+x --more math to find points, top left?
	point5[2]=point1[2]+point3[2]+y
	point6[1]=point2[1]+point3[1]+x --top right?
	point6[2]=point2[2]+point3[2]+y
	point7[1]=point1[1]+point4[1]+x --bottom left?
	point7[2]=point1[2]+point4[2]+y
	point8[1]=point2[1]+point4[1]+x --bottom right?
	point8[2]=point2[2]+point4[2]+y
	--to anyone reading these comments in the future and laughing at my idiocracy and poor commenting skills...in my defense...yeah i got nothin
	point1[1] = point1[1] + x
	point1[2] = point1[2] + y
	point2[1] = point2[1] + x
	point2[2] = point2[2] + y
	point3[1] = point3[1] + x
	point3[2] = point3[2] + y
	point4[1] = point4[1] + x
	point4[2] = point4[2] + y

	local rightcheck
	local leftcheck

	--check if it's on the same rough x plane as the bullets, and execute full collision code if it is. cut short if it does.

	if point6[1] < point8[1] then --i hope i got these right, set the one on the right to the one to use for checking right collision
		rightcheck = point8[1]
	else
		rightcheck = point6[1]
	end

	if point5[1] > point7[1] then --see above, except left this time
		leftcheck = point7[1]
	else
		leftcheck=point5[1]
	end

	local i = 1
	local temppoint1 = {}
	local temppoint2 = {}
	local temppoint3 = {}
	local temppoint4 = {}
	local temppoint5 = {}
	local temppoint6 = {}
	local temppoint7 = {}
	local temppoint8 = {}

	local temppoint21 = {}
	local temppoint22 = {}
	local temppoint23 = {}
	local temppoint24 = {}
	local temppoint25 = {}
	local temppoint26 = {}
	local temppoint27 = {}
	local temppoint28 = {}

	local tempbulx
	local tempbuly

	while bulletarray[i] ~= nil and bulletarray[i] ~= 0
		if bulletarray[i] ~= -1 then
			if rightcheck+imagewidth > (bulletheights[bulletarray[i].image]*-2)+((bulletarray[i].x/HALFUNIT)/2) and leftcheck-imagewidth < (bulletheights[bulletarray[i].image]*2)+((bulletarray[i].x/HALFUNIT)/2)
				tempbulx=bulletarray[i].x
				tempbuly=bulletarray[i].y
				bulletarray[i].x = (bulletarray[i].x/HALFUNIT)/2
				bulletarray[i].y = (bulletarray[i].y/HALFUNIT)/2
				//dbgmsg = 5
				temppoint1 = {point1[1]-bulletarray[i].x,point1[2]-bulletarray[i].y} --calculate rotation based on bullet's rotation
				temppoint2 = {point2[1]-bulletarray[i].x,point2[2]-bulletarray[i].y}
				temppoint3 = {point3[1]-bulletarray[i].x,point3[2]-bulletarray[i].y}
				temppoint4 = {point4[1]-bulletarray[i].x,point4[2]-bulletarray[i].y}
				temppoint5 = {point5[1]-bulletarray[i].x,point5[2]-bulletarray[i].y}
				temppoint6 = {point6[1]-bulletarray[i].x,point6[2]-bulletarray[i].y}
				temppoint7 = {point7[1]-bulletarray[i].x,point7[2]-bulletarray[i].y}
				temppoint8 = {point8[1]-bulletarray[i].x,point8[2]-bulletarray[i].y}

				temppoint21 = {(FixedMul(temppoint1[1]*FRACUNIT,cos(FixedAngle(bulletarray[i].direction*FRACUNIT)))-FixedMul(temppoint1[2]*FRACUNIT,sin(FixedAngle(bulletarray[i].direction*FRACUNIT))))/FRACUNIT,(FixedMul(temppoint1[1]*FRACUNIT,sin(FixedAngle(bulletarray[i].direction*FRACUNIT)))+FixedMul(temppoint1[2]*FRACUNIT,cos(FixedAngle(bulletarray[i].direction*FRACUNIT))))/FRACUNIT}
				temppoint22 = {(FixedMul(temppoint2[1]*FRACUNIT,cos(FixedAngle(bulletarray[i].direction*FRACUNIT)))-FixedMul(temppoint2[2]*FRACUNIT,sin(FixedAngle(bulletarray[i].direction*FRACUNIT))))/FRACUNIT,(FixedMul(temppoint2[1]*FRACUNIT,sin(FixedAngle(bulletarray[i].direction*FRACUNIT)))+FixedMul(temppoint2[2]*FRACUNIT,cos(FixedAngle(bulletarray[i].direction*FRACUNIT))))/FRACUNIT}
				temppoint23 = {(FixedMul(temppoint3[1]*FRACUNIT,cos(FixedAngle(bulletarray[i].direction*FRACUNIT)))-FixedMul(temppoint3[2]*FRACUNIT,sin(FixedAngle(bulletarray[i].direction*FRACUNIT))))/FRACUNIT,(FixedMul(temppoint3[1]*FRACUNIT,sin(FixedAngle(bulletarray[i].direction*FRACUNIT)))+FixedMul(temppoint3[2]*FRACUNIT,cos(FixedAngle(bulletarray[i].direction*FRACUNIT))))/FRACUNIT}
				temppoint24 = {(FixedMul(temppoint4[1]*FRACUNIT,cos(FixedAngle(bulletarray[i].direction*FRACUNIT)))-FixedMul(temppoint4[2]*FRACUNIT,sin(FixedAngle(bulletarray[i].direction*FRACUNIT))))/FRACUNIT,(FixedMul(temppoint4[1]*FRACUNIT,sin(FixedAngle(bulletarray[i].direction*FRACUNIT)))+FixedMul(temppoint4[2]*FRACUNIT,cos(FixedAngle(bulletarray[i].direction*FRACUNIT))))/FRACUNIT}
				temppoint25 = {(FixedMul(temppoint5[1]*FRACUNIT,cos(FixedAngle(bulletarray[i].direction*FRACUNIT)))-FixedMul(temppoint5[2]*FRACUNIT,sin(FixedAngle(bulletarray[i].direction*FRACUNIT))))/FRACUNIT,(FixedMul(temppoint5[1]*FRACUNIT,sin(FixedAngle(bulletarray[i].direction*FRACUNIT)))+FixedMul(temppoint5[2]*FRACUNIT,cos(FixedAngle(bulletarray[i].direction*FRACUNIT))))/FRACUNIT}
				temppoint26 = {(FixedMul(temppoint6[1]*FRACUNIT,cos(FixedAngle(bulletarray[i].direction*FRACUNIT)))-FixedMul(temppoint6[2]*FRACUNIT,sin(FixedAngle(bulletarray[i].direction*FRACUNIT))))/FRACUNIT,(FixedMul(temppoint6[1]*FRACUNIT,sin(FixedAngle(bulletarray[i].direction*FRACUNIT)))+FixedMul(temppoint6[2]*FRACUNIT,cos(FixedAngle(bulletarray[i].direction*FRACUNIT))))/FRACUNIT}
				temppoint27 = {(FixedMul(temppoint7[1]*FRACUNIT,cos(FixedAngle(bulletarray[i].direction*FRACUNIT)))-FixedMul(temppoint7[2]*FRACUNIT,sin(FixedAngle(bulletarray[i].direction*FRACUNIT))))/FRACUNIT,(FixedMul(temppoint7[1]*FRACUNIT,sin(FixedAngle(bulletarray[i].direction*FRACUNIT)))+FixedMul(temppoint7[2]*FRACUNIT,cos(FixedAngle(bulletarray[i].direction*FRACUNIT))))/FRACUNIT}
				temppoint28 = {(FixedMul(temppoint8[1]*FRACUNIT,cos(FixedAngle(bulletarray[i].direction*FRACUNIT)))-FixedMul(temppoint8[2]*FRACUNIT,sin(FixedAngle(bulletarray[i].direction*FRACUNIT))))/FRACUNIT,(FixedMul(temppoint8[1]*FRACUNIT,sin(FixedAngle(bulletarray[i].direction*FRACUNIT)))+FixedMul(temppoint8[2]*FRACUNIT,cos(FixedAngle(bulletarray[i].direction*FRACUNIT))))/FRACUNIT}


				temppoint1 = temppoint21 --{temppoint21[1] + bulletarray[i].x,temppoint21[2] + bulletarray[i].y}
				temppoint2 = temppoint22 --{temppoint22[1] + bulletarray[i].x,temppoint22[2] + bulletarray[i].y}
				temppoint3 = temppoint23 --{temppoint23[1] + bulletarray[i].x,temppoint23[2] + bulletarray[i].y}
				temppoint4 = temppoint24 --{temppoint24[1] + bulletarray[i].x,temppoint24[2] + bulletarray[i].y}
				temppoint5 = temppoint25 --{temppoint25[1] + bulletarray[i].x,temppoint25[2] + bulletarray[i].y}
				temppoint6 = temppoint26 --{temppoint26[1] + bulletarray[i].x,temppoint26[2] + bulletarray[i].y}
				temppoint7 = temppoint27 --{temppoint27[1] + bulletarray[i].x,temppoint27[2] + bulletarray[i].y}
				temppoint8 = temppoint28 --{temppoint28[1] + bulletarray[i].x,temppoint28[2] + bulletarray[i].y}
				bulletarray[i].x=tempbulx
				bulletarray[i].y=tempbuly


				local bulletx = {bulletwidths[bulletarray[i].image],bulletwidths[bulletarray[i].image]*-1} --{bulletwidths[bulletarray[i].image]+x,(bulletwidths[bulletarray[i].image]*-1)+x}
				local bullety = {bulletheights[bulletarray[i].image],bulletheights[bulletarray[i].image]*-1} --{bulletheights[bulletarray[i].image]+y,(bulletheights[bulletarray[i].image]*-1)+y}

//				Graphics.drawImage(temppoint1[1]+50,temppoint1[2]+50,dbgimg) --visual representation for collision! enable these for magics.
//				Graphics.drawImage(temppoint2[1]+50,temppoint2[2]+50,dbgimg)
//				Graphics.drawImage(temppoint3[1]+50,temppoint3[2]+50,dbgimg)
//				Graphics.drawImage(temppoint4[1]+50,temppoint4[2]+50,dbgimg)
//				Graphics.drawImage(temppoint5[1]+50,temppoint5[2]+50,dbgimg)
//				Graphics.drawImage(temppoint6[1]+50,temppoint6[2]+50,dbgimg)
//				Graphics.drawImage(temppoint7[1]+50,temppoint7[2]+50,dbgimg)
//				Graphics.drawImage(temppoint8[1]+50,temppoint8[2]+50,dbgimg)
//				Graphics.drawImage(bulletx[1]+50,bullety[1]+50,dbgimg2)
//				Graphics.drawImage(bulletx[2]+50,bullety[1]+50,dbgimg2)
//				Graphics.drawImage(bulletx[1]+50,bullety[2]+50,dbgimg2)
//				Graphics.drawImage(bulletx[2]+50,bullety[2]+50,dbgimg2)

				server.drawshit[1] = bulletx[1]
				server.drawshit[2] = bulletx[2]
				server.drawshit[3] = bullety[1]
				server.drawshit[4] = bullety[2]
				server.drawshit2[1] = temppoint5[1]
				server.drawshit2[2] = temppoint5[2]
				server.drawshit2[3] = temppoint6[1]
				server.drawshit2[4] = temppoint6[2]
				server.drawshit2[5] = temppoint7[1]
				server.drawshit2[6] = temppoint7[2]
				server.drawshit2[7] = temppoint8[1]
				server.drawshit2[8] = temppoint8[2]

								//CONS_Printf(server,"A"+temppoint1[1])
				//CONS_Printf(server,"A"+temppoint1[2])
				//CONS_Printf(server,"B"+bulletx[1])
				//CONS_Printf(server,"B"+bullety[1])

				--iterate through players new points and check if any of them are inside the bullet
				if temppoint1[1] <= bulletx[1] and temppoint1[1] >= bulletx[2] then
					if temppoint1[2] <= bullety[1] and temppoint1[2] >= bullety[2] then
						return(i)
					end
				end
				if temppoint2[1] <= bulletx[1] and temppoint2[1] >= bulletx[2] then
					if temppoint2[2] <= bullety[1] and temppoint2[2] >= bullety[2] then
						return(i)
					end
				end
				if temppoint3[1] <= bulletx[1] and temppoint3[1] >= bulletx[2] then
					if temppoint3[2] <= bullety[1] and temppoint3[2] >= bullety[2] then
						return(i)
					end
				end
				if temppoint4[1] <= bulletx[1] and temppoint4[1] >= bulletx[2] then
					if temppoint4[2] <= bullety[1] and temppoint4[2] >= bullety[2] then
						return(i)
					end
				end
				if temppoint5[1] <= bulletx[1] and temppoint5[1] >= bulletx[2] then
					if temppoint5[2] <= bullety[1] and temppoint5[2] >= bullety[2] then
						return(i)
					end
				end
				if temppoint6[1] <= bulletx[1] and temppoint6[1] >= bulletx[2] then
					if temppoint6[2] <= bullety[1] and temppoint6[2] >= bullety[2] then
						return(i)
					end
				end
				if temppoint7[1] <= bulletx[1] and temppoint7[1] >= bulletx[2] then
					if temppoint7[2] <= bullety[1] and temppoint7[2] >= bullety[2] then
						return(i)
					end
				end
				if temppoint8[1] <= bulletx[1] and temppoint8[1] >= bulletx[2] then
					if temppoint8[2] <= bullety[1] and temppoint8[2] >= bullety[2] then
						return(i)
					end
				end
				//dbgmsg=10
			end
		end
		i = i+1
	end
	return(0)
end

local function rotpart(dir,dir2,rotmove) //current direction, direction to turn to, amount to move by per frame
	if dir2 >= 360
		dir2 = $1 - 360
	end
	local tempangle = dir2 //get angle
	local direction = dir
	local tempangle2
	local dashdirection
	if tempangle>180 then //get the angle for the opposite direction; works by checking if you're above 180 or below it, and changing a value based off of that.
		tempangle2 = 180
		tempangle2 = (tempangle-tempangle2)
	else
		tempangle2 = 180
		tempangle2 = (tempangle2+tempangle)
	end
	if tempangle2<180 then //dashdirection here is the direction to turn by, determines which direction to turn by by which half of the 360 degrees your pointing to compared to your actual angle
		if direction>tempangle2 and direction<tempangle then //set variables for dictating rotation
			dashdirection = 1
		else
			dashdirection = -1
		end
	else
		if direction>tempangle and direction<tempangle2 then
			dashdirection = -1
		else
			dashdirection = 1
		end
	end

	if direction ~= tempangle then //rotate if your angle isn't accurate
		direction = $1 + (rotmove * dashdirection)
	end

	if direction + rotmove >= tempangle and direction - rotmove <= tempangle then //check if you're within the dashangle values for the actual angle you wanna go at, and if so, set the angle to the angle you wish to be at
		direction = tempangle
	end

	if direction >= 360
		direction = $1 - 360
	end
	if direction < 0
		direction = $1 + 360
	end
	return(direction)
end


local function splodfunc(i)
	local splodstruct = server.soniguri.enemies[i]
	splodstruct.image = (splodstruct.spawntics/2) + 15
	if splodstruct.image == 22
		splodstruct.delete = 1
	end
end

local function enemysplod(i,oldstruct)
	local splodstruct = {x,y}
	splodstruct.x = oldstruct.x
	splodstruct.y = oldstruct.y
	splodstruct.image = 15
	splodstruct.xspeed = 0
	splodstruct.yspeed = 0
	splodstruct.script = splodfunc
	splodstruct.spawntics = 0
	splodstruct.direction = 0
	splodstruct.flags = 0
	splodstruct.cantarget = 0
	server.soniguri.enemies[i] = splodstruct
end

local function bosssplod(sx,sy)
	local splodstruct = {x,y}
	splodstruct.x = sx
	splodstruct.y = sy
	splodstruct.image = 15
	splodstruct.xspeed = 0
	splodstruct.yspeed = 0
	splodstruct.script = splodfunc
	splodstruct.spawntics = 0
	splodstruct.direction = 0
	splodstruct.flags = 0
	splodstruct.cantarget = 0
	return(splodstruct)
end


local function collideoffset(obj,sx,sy,width,height) //send object, x offset, y offset, width and height of collision
	local colstruct = {x,y}
	colstruct.x = (FixedMul(sx*FRACUNIT,cos(FixedAngle(obj.direction*FRACUNIT)))-FixedMul(sy*FRACUNIT,sin(FixedAngle(obj.direction*FRACUNIT))))/2 //get rotations
	colstruct.y = (FixedMul(sx*FRACUNIT,sin(FixedAngle(obj.direction*FRACUNIT)))+FixedMul(sy*FRACUNIT,cos(FixedAngle(obj.direction*FRACUNIT))))/2

	colstruct.x = colstruct.x + obj.x //add to the regular location
	colstruct.y = colstruct.y + obj.y
	colstruct.direction = obj.direction
	return(playercollision(width,height,colstruct,server.soniguri.playerbuls))
end

local function hyperallocate(hp,oldhp)
	local newhp = (oldhp-hp)/25
	for player in players.iterate
		player.soogsobject.special = $1 + newhp
		if player.soogsobject.special > 300
			player.soogsobject.special = 300
		end
	end
end

local function directionalslowdown(sogs)
	local sslowdownspeed = HALFUNIT/3
	if sogs.xspeed ~= 0 or sogs.yspeed ~= 0 then --slow down there, ms. fas
		if sogs.xspeed>0 then --get direction of xspeed
			sogs.xdirection = 1
		else
			sogs.xdirection = -1
		end
		if sogs.yspeed>0 then --get direction of yspeed
			sogs.ydirection = 1
		else
			sogs.ydirection = -1
		end
		local tempspeed = abs(sogs.xspeed) + abs(sogs.yspeed) --generate the real speed
		local xslowdownspeed = FixedDiv(abs(sogs.xspeed) * 2 , tempspeed * 2) --generate percentage for slowdown
		local yslowdownspeed = FixedDiv(abs(sogs.yspeed) * 2 , tempspeed * 2) --generate percentage for slowdown, y edition
		sogs.xspeed = sogs.xspeed - (FixedMul(xslowdownspeed, sslowdownspeed*2) * sogs.xdirection)/2
		sogs.yspeed = sogs.yspeed - (FixedMul(yslowdownspeed, sslowdownspeed*2) * sogs.ydirection)/2
		if sogs.xspeed < sslowdownspeed and sogs.xspeed > sslowdownspeed*-1 then --reset xspeed to 0 if too near 0
			sogs.xspeed = 0
			xslowdownspeed=0
		end
		if sogs.yspeed < sslowdownspeed and sogs.yspeed > sslowdownspeed*-1 then --reset yspeed to 0 if too near 0
			sogs.yspeed = 0
			yslowdownspeed=0
		end
	end
end


local function soogsobjectreset()
	local soogsobjectdefault = {x,y,hp,heat,special,direction,dashing,xspeed,yspeed,canmove,delay,previoushp,action,anim}
	soogsobjectdefault.x = 50*HALFUNIT
	soogsobjectdefault.y = 200*HALFUNIT
	soogsobjectdefault.hp = FRACUNIT
	soogsobjectdefault.heat = 0
	soogsobjectdefault.special = 0
	soogsobjectdefault.direction = 90
	soogsobjectdefault.dashing = 0
	soogsobjectdefault.xspeed = 0
	soogsobjectdefault.yspeed = 0
	soogsobjectdefault.canmove = 2
	soogsobjectdefault.delay = 0
	soogsobjectdefault.previoushp = FRACUNIT
	soogsobjectdefault.action = 0
	soogsobjectdefault.anim = 0
	soogsobjectdefault.dashdirection = 0
	soogsobjectdefault.tempangle = 0
	soogsobjectdefault.tempangle2 = 0
	soogsobjectdefault.image = 1
	soogsobjectdefault.enemy = 0
	soogsobjectdefault.candash = 1
	soogsobjectdefault.animtimer = 0
	soogsobjectdefault.invinc = 0
	return(soogsobjectdefault)
end

local function basebulletcreate()
	local bullstruct = {x, y, xspeed, yspeed, direction, image, damage}
	bullstruct.x = 50*HALFUNIT
	bullstruct.y = 50*HALFUNIT
	bullstruct.xspeed = 0
	bullstruct.yspeed = 0
	bullstruct.direction = 90
	bullstruct.image = 1
	bullstruct.damage = 1
	bullstruct.script = nil
	bullstruct.flags = 0
	return(bullstruct)
end

local function bullethandler()
	local i = 1
	while (server.soniguri.enemybuls[i] ~= nil)
		if server.soniguri.enemybuls[i] ~= -1
			server.soniguri.enemybuls[i].x = server.soniguri.enemybuls[i].x + server.soniguri.enemybuls[i].xspeed //add speeds
			server.soniguri.enemybuls[i].y = server.soniguri.enemybuls[i].y + server.soniguri.enemybuls[i].yspeed
			if server.soniguri.enemybuls[i].script ~= nil then //run script if it calls for it
				server.soniguri.enemybuls[i].script(i)
			end
			if (server.soniguri.enemybuls[i].delete == 1) or (((server.soniguri.enemybuls[i].x > 700 * HALFUNIT) or (server.soniguri.enemybuls[i].x < -60 * HALFUNIT) or (server.soniguri.enemybuls[i].y > 500 * HALFUNIT) or (server.soniguri.enemybuls[i].y < -100 * HALFUNIT)) and server.soniguri.enemybuls[i].del == nil) then
				server.soniguri.enemybuls[i] = -1
			end
		end
		i = i + 1
	end
	i = 1
	while (server.soniguri.enemybuls[i] ~= nil)
		if server.soniguri.enemybuls[i] == -1
			if server.soniguri.enemybuls[i+1] == nil
				server.soniguri.enemybuls[i] = nil
			end
		end
		i = i + 1
	end
	i = 1
		while (server.soniguri.playerbuls[i] ~= nil)
		if server.soniguri.playerbuls[i] ~= -1
			server.soniguri.playerbuls[i].x = server.soniguri.playerbuls[i].x + server.soniguri.playerbuls[i].xspeed
			server.soniguri.playerbuls[i].y = server.soniguri.playerbuls[i].y + server.soniguri.playerbuls[i].yspeed
			if server.soniguri.playerbuls[i].script ~= nil then
				server.soniguri.playerbuls[i].script(i)
			end
			if (server.soniguri.playerbuls[i].delete == 1) or (((server.soniguri.playerbuls[i].x > 700 * HALFUNIT) or (server.soniguri.playerbuls[i].x < -60 * HALFUNIT) or (server.soniguri.playerbuls[i].y > 500 * HALFUNIT) or (server.soniguri.playerbuls[i].y < -100 * HALFUNIT)) and server.soniguri.playerbuls[i].del == nil) then
				server.soniguri.playerbuls[i] = -1
			end
		end
		i = i + 1
	end
	i = 1
	while (server.soniguri.playerbuls[i] ~= nil)
		if server.soniguri.playerbuls[i] == -1
			if server.soniguri.playerbuls[i+1] == nil
				server.soniguri.playerbuls[i] = nil
			end
		end
		i = i + 1
	end
end

local function enemyhandler()
	local i = 1
	while (server.soniguri.enemies[i] ~= nil)
		if server.soniguri.enemies[i] ~= -1
			server.soniguri.enemies[i].x = server.soniguri.enemies[i].x + server.soniguri.enemies[i].xspeed
			server.soniguri.enemies[i].y = server.soniguri.enemies[i].y + server.soniguri.enemies[i].yspeed
			server.soniguri.enemies[i].spawntics = server.soniguri.enemies[i].spawntics + 1
			if server.soniguri.enemies[i].script ~= nil then
				server.soniguri.enemies[i].script(i)
			end
			if server.soniguri.enemies[i].delete == 1 then
				server.soniguri.enemies[i] = -1
			end
		end
		i = i + 1
	end
	i = 1
	while (server.soniguri.enemies[i] ~= nil)
		if server.soniguri.enemies[i] == -1
			if server.soniguri.enemies[i+1] == nil
				server.soniguri.enemies[i] = nil
			end
		end
		i = i + 1
	end
end

local function dashringhandler()
	local i = 1
	while server.soniguri.dashrings[i] ~= nil
		if server.soniguri.dashrings[i] ~= -1
			server.soniguri.dashrings[i].time = $1 + 1
			if server.soniguri.dashrings[i].time == 6
				server.soniguri.dashrings[i].image = 8
			end
			if server.soniguri.dashrings[i].time == 13
				server.soniguri.dashrings[i].image = 9
			end
			if server.soniguri.dashrings[i].time == 20
				server.soniguri.dashrings[i] = -1
			end
		end
		i = $1 + 1
	end
	while server.soniguri.dashrings[i] ~= nil
		if server.soniguri.dashrings[i] == -1
			if server.soniguri.dashrings[i+1] == nil
				server.soniguri.enemies[i] = nil
			end
		end
		i = $1 + 1
	end
end

local function findenemy(sogs) //finds closest enemy
	local closest = 2048 * FRACUNIT //set it ridiculously far away
	local closestobj
	local i = 1
	while (server.soniguri.enemies[i] ~= nil) //iterate through enemies and find the closest
		if server.soniguri.enemies[i] ~= -1
			local tempdist = R_PointToDist2(sogs.x,sogs.y,server.soniguri.enemies[i].x,server.soniguri.enemies[i].y)
			if tempdist < closest and server.soniguri.enemies[i].cantarget == nil
				closest = tempdist
				closestobj = i
			end
		end
		i = i + 1
	end
	return(closestobj)
end


local function findfree(array) //finds a free slot in the array
	local i = 1
	while (array[i]) ~= nil
		if array[i] == -1
			return(i)
		end
		i = i + 1
	end
	return(i)
end


local function destroywhenhit(i) //used in beam rifle shots; converts a "hit" to a "delete"
	if server.soniguri.playerbuls[i].hit == 1
		server.soniguri.playerbuls[i].delete = 1
		S_StartSound(nil,sfx_scrash)
	end
end


local function explodewhenhit(i) //used in bazooka shots; creates an explosion when hit
	if server.soniguri.playerbuls[i].hit == 1
		server.soniguri.playerbuls[i].delete = 1
		enemysplod(findfree(server.soniguri.enemies),server.soniguri.playerbuls[i])
		S_StartSound(nil,sfx_ssplod)
	end
end


local function beamrifle1(sogs) //spawn beamrifle bullets!
	local beamstruct = {x,y}
	beamstruct.x = sogs.x //reset positions
	beamstruct.y = sogs.y
	if server.soniguri.enemies[sogs.enemy] ~= nil and server.soniguri.enemies[sogs.enemy] ~= -1 //if enemy exists, aim at it
		beamstruct.direction = (AngleFixed(R_PointToAngle2(sogs.x,sogs.y,server.soniguri.enemies[sogs.enemy].x,server.soniguri.enemies[sogs.enemy].y))/FRACUNIT)+90
		if beamstruct.direction > 360
			beamstruct.direction = beamstruct.direction - 360
		end
	else //else just shoot right
		beamstruct.direction = 90
	end

	beamstruct.xspeed = FixedMul(14*FRACUNIT,sin(FixedAngle(beamstruct.direction * FRACUNIT)))/2 //set speed
	beamstruct.yspeed = (FixedMul(14*FRACUNIT,cos(FixedAngle(beamstruct.direction * FRACUNIT)))*-1)/2

	beamstruct.image = 10
	beamstruct.damage = 140

	beamstruct.flags = V_30TRANS
	beamstruct.hit = 0
	beamstruct.script = destroywhenhit
	return(beamstruct)
end

local function beamrifle2(sogs) //spawn beamrifle bullets!
	local beamstruct = {x,y}
	beamstruct.x = sogs.x //reset positions
	beamstruct.y = sogs.y
	if server.soniguri.enemies[sogs.enemy] ~= nil and server.soniguri.enemies[sogs.enemy] ~= -1 //if enemy exists, aim at it
		beamstruct.direction = (AngleFixed(R_PointToAngle2(sogs.x,sogs.y,server.soniguri.enemies[sogs.enemy].x,server.soniguri.enemies[sogs.enemy].y))/FRACUNIT)+90
		if beamstruct.direction > 360
			beamstruct.direction = beamstruct.direction - 360
		end
	else //else just shoot right
		beamstruct.direction = 90
	end

	beamstruct.xspeed = FixedMul(14*FRACUNIT,sin(FixedAngle(beamstruct.direction * FRACUNIT)))/2 //set speed
	beamstruct.yspeed = (FixedMul(14*FRACUNIT,cos(FixedAngle(beamstruct.direction * FRACUNIT)))*-1)/2

	beamstruct.image = 10
	beamstruct.damage = 60

	beamstruct.flags = V_30TRANS
	beamstruct.hit = 0
	beamstruct.script = destroywhenhit
	return(beamstruct)
end


local function eggrobobul(creator) //spawn eggrobo bullets
	local beamstruct = {x,y}
	beamstruct.x = creator.x
	beamstruct.y = creator.y
	beamstruct.direction = (AngleFixed(R_PointToAngle2(creator.x,creator.y,creator.target.x,creator.target.y))/FRACUNIT)+90 //no need to check if players exist here; they always will, enemies always have a target, even if said target is dead
	if beamstruct.direction > 360
		beamstruct.direction = beamstruct.direction - 360
	end
	beamstruct.xspeed = FixedMul(9*FRACUNIT,sin(FixedAngle(beamstruct.direction * FRACUNIT)))/2 //set speed
	beamstruct.yspeed = (FixedMul(9*FRACUNIT,cos(FixedAngle(beamstruct.direction * FRACUNIT)))*-1)/2
	beamstruct.damage = 1967
	beamstruct.flags = V_30TRANS
	beamstruct.image = 10
	beamstruct.beam = 1
	return(beamstruct)
end


local function enemycol(width,height,enemystruct)
	local colcheck = playercollision(width,height,enemystruct,server.soniguri.playerbuls)
	if colcheck ~= nil and colcheck ~= 0
		enemystruct.hp = enemystruct.hp - server.soniguri.playerbuls[colcheck].damage
		server.soniguri.playerbuls[colcheck].hit = 1
	end
end


local function findplayer(enemystruct)
	local closest = 2048 * FRACUNIT
	local closestobj
	for p in players.iterate
		if p.soogsobject ~= nil
			local dist = R_PointToDist2(enemystruct.x,enemystruct.y,p.soogsobject.x,p.soogsobject.y)
			if dist < closest and p.soogsobject.hp > 0
				closest = dist
				closestobj = p.soogsobject
			end
		end
	end
	if closestobj == nil
		closestobj = server.soogsobject
	end
	return(closestobj)
end

local function eggrobofunc(i) //eggrobo functionality
	local enemystruct = server.soniguri.enemies[i]
	//server.soniguri.enemybuls[findfree(server.soniguri.enemybuls)] = eggrobobul(enemystruct)
	if enemystruct.xspeed ~= 0 and enemystruct.spawntics < 37
		enemystruct.xspeed = enemystruct.xspeed + HALFUNIT/2
	end

	if enemystruct.spawntics == 37 or enemystruct.spawntics == 57 or enemystruct.spawntics == 77
		server.soniguri.enemybuls[findfree(server.soniguri.enemybuls)] = eggrobobul(enemystruct)
	end

	if enemystruct.spawntics == 115
		enemystruct.xspeed = - 5 * HALFUNIT
	end

	if enemystruct.x <= -30*HALFUNIT
		enemystruct.delete = 1
	end

	if enemystruct.target == nil or not enemystruct.target.valid or enemystruct.target.hp <= 0 //finds closest live player!
		enemystruct.target = findplayer(enemystruct)
	end

	local hp = enemystruct.hp //runs collision, then allocates hyper.

	enemycol(16,16,enemystruct)

	hyperallocate(enemystruct.hp,hp)


	if enemystruct.hp <= 0 //kills itself and creates an explosion in its place.
		enemysplod(i,enemystruct)
	end
end


local function eggrobo(sx,sy) //spawn eggrobos
	local enemystruct = {x,y}
	enemystruct.x = sx
	enemystruct.y = sy
	enemystruct.direction = 270
	//enemystruct.xspeed = FixedMul(9*FRACUNIT,sin(FixedAngle(enemystruct.direction * FRACUNIT)))/2
	//enemystruct.yspeed = (FixedMul(9*FRACUNIT,cos(FixedAngle(enemystruct.direction * FRACUNIT)))*-1)/2
	enemystruct.xspeed = -12 * HALFUNIT
	enemystruct.yspeed = 0
	enemystruct.script = eggrobofunc
	enemystruct.hp = 120
	enemystruct.delete = 0
	enemystruct.spawntics = 0
	enemystruct.target = findplayer(enemystruct)
	//CONS_Printf(server,enemystruct.target)
	enemystruct.image = 11
	enemystruct.flags = 0
	return(enemystruct)
end

local function facestab(parent)
	local stabstruct = {x,y}
	stabstruct.x = parent.x
	stabstruct.y = parent.y
	stabstruct.direction = parent.direction
	stabstruct.image = 14
	stabstruct.flags = 0
	stabstruct.xspeed = 0
	stabstruct.yspeed = 0
	stabstruct.damage = FRACUNIT/15
	return(stabstruct)
end

local function facestabfunc(i)
	local enemystruct = server.soniguri.enemies[i]

	if not enemystruct.target.valid or enemystruct.target == nil or enemystruct.target.hp <= 0
		enemystruct.target = findplayer(enemystruct)
	end

	if enemystruct.spawntics == 30 //stop them once they get in
		enemystruct.xspeed = 0
	end

	if enemystruct.spawntics == 40 or enemystruct.spawntics == 65 //start dashing at set intervals
		enemystruct.dash = 1
	end

	if enemystruct.dash == 1 //dash prep, set speed and image
		enemystruct.xspeed = FixedMul(12*FRACUNIT,sin(FixedAngle(enemystruct.direction * FRACUNIT)))/2 //set speed
		enemystruct.yspeed = (FixedMul(12*FRACUNIT,cos(FixedAngle(enemystruct.direction * FRACUNIT)))*-1)/2
		enemystruct.dash = 2
		enemystruct.image = 14
	end

	if enemystruct.dash == 2 //actual act of dashing, lock spawntics and slowdown until you stop
		enemystruct.spawntics = 41
		directionalslowdown(enemystruct)
		if enemystruct.xspeed == 0 and enemystruct.yspeed == 0
			enemystruct.image = 13
			enemystruct.dash = 0
		end
		local bulslot = findfree(server.soniguri.enemybuls)
		server.soniguri.enemybuls[bulslot] = facestab(enemystruct)
		server.soniguri.enemybuls[bulslot].delete = 1
	end

	if enemystruct.dash == 0 //when not dashing, adjust angle to face towards enemy
		enemystruct.direction = (AngleFixed(R_PointToAngle2(enemystruct.x,enemystruct.y,enemystruct.target.x,enemystruct.target.y))/FRACUNIT)+90
		if enemystruct.direction >= 360
			enemystruct.direction = $1 - 360
		end
	end

	local hp = enemystruct.hp

	local col = collideoffset(enemystruct,-10,-10,10,10)
	if col == nil or col == 0
		col = collideoffset(enemystruct,10,-10,10,10)
		if col == nil or col == 0
			col = collideoffset(enemystruct,-10,10,10,10)
			if col == nil or col == 0
				col = collideoffset(enemystruct,10,10,10,10)
			end
		end
	end

	if col ~= nil and col ~= 0
		enemystruct.hp = $1 - server.soniguri.playerbuls[col].damage
		server.soniguri.playerbuls[col].hit = 1
	end

	hyperallocate(enemystruct.hp,hp)

	if enemystruct.hp <= 0
		enemysplod(i,enemystruct)
	end
end

local function facestabber(sx,sy) //spawn facestabber
	local enemystruct = {x,y}
	enemystruct.x = sx
	enemystruct.y = sy
	enemystruct.target = findplayer(enemystruct)
	enemystruct.direction = (AngleFixed(R_PointToAngle2(enemystruct.x,enemystruct.y,enemystruct.target.x,enemystruct.target.y))/FRACUNIT)+90
	if enemystruct.direction >= 360
		enemystruct.direction = $1 - 360
	end
	enemystruct.xspeed = - 6 * HALFUNIT
	enemystruct.yspeed = 0
	enemystruct.script = facestabfunc
	enemystruct.hp = 350
	enemystruct.delete = 0
	enemystruct.spawntics = 0
	enemystruct.target = findplayer(enemystruct)
	enemystruct.image = 13
	enemystruct.flags = 0
	enemystruct.dash = 0
	return(enemystruct)
end

local function unidusspike(parent)
	local spikestruct = {x,y}
	spikestruct.x = parent.x
	spikestruct.y = parent.y
	spikestruct.direction = 0
	spikestruct.damage = FRACUNIT/23
	spikestruct.image = 23
	spikestruct.flags = 0
	spikestruct.xspeed = 0
	spikestruct.yspeed = 0
	spikestruct.direction = 0
	spikestruct.del = 0
	return(spikestruct)
end

local function unidusfunc(i)
	local enemystruct = server.soniguri.enemies[i] //ease-of-access

	enemystruct.spikedirs[1] = $1 + 8 //update angles
	enemystruct.spikedirs[2] = $1 + 8
	enemystruct.spikedirs[3] = $1 + 8
	enemystruct.spikedirs[4] = $1 + 8

	local i2 = 1

	while i2 < 5
		server.soniguri.enemybuls[enemystruct.spikes[i2]].x = enemystruct.x+(FixedMul(30*FRACUNIT,cos(FixedAngle(enemystruct.spikedirs[i2]*FRACUNIT)))-FixedMul(30*FRACUNIT,sin(FixedAngle(enemystruct.spikedirs[i2]*FRACUNIT))))/2 //get rotations
		server.soniguri.enemybuls[enemystruct.spikes[i2]].y = enemystruct.y+(FixedMul(30*FRACUNIT,sin(FixedAngle(enemystruct.spikedirs[i2]*FRACUNIT)))+FixedMul(30*FRACUNIT,cos(FixedAngle(enemystruct.spikedirs[i2]*FRACUNIT))))/2
		i2 = $1 + 1
	end

	if enemystruct.spawntics == 65
		enemystruct.hp = 0
	end

	local hp = enemystruct.hp

	enemycol(11,11,enemystruct)

	hyperallocate(enemystruct.hp,hp)

	if enemystruct.hp <= 0
		i2 = 1
		while i2 < 5
			local tempdir = R_PointToAngle2(enemystruct.x,enemystruct.y,server.soniguri.enemybuls[enemystruct.spikes[i2]].x,server.soniguri.enemybuls[enemystruct.spikes[i2]].y)
			server.soniguri.enemybuls[enemystruct.spikes[i2]].xspeed = FixedMul(10*FRACUNIT,cos(tempdir))/2
			server.soniguri.enemybuls[enemystruct.spikes[i2]].yspeed = FixedMul(10*FRACUNIT,sin(tempdir))/2
			server.soniguri.enemybuls[enemystruct.spikes[i2]].del = nil
			i2 = $1 + 1
		end
		enemysplod(i,enemystruct)
	end
end

local function unidus(sx,sy)
	local enemystruct = {x,y}
	enemystruct.x = sx
	enemystruct.y = sy
	enemystruct.direction = 0
	enemystruct.xspeed = -5*HALFUNIT
	enemystruct.yspeed = 0

	enemystruct.spikes = {findfree(server.soniguri.enemybuls)} //spike balls
	server.soniguri.enemybuls[enemystruct.spikes[1]] = unidusspike(enemystruct)
	enemystruct.spikes[2] = findfree(server.soniguri.enemybuls)
	server.soniguri.enemybuls[enemystruct.spikes[2]] = unidusspike(enemystruct)
	enemystruct.spikes[3] = findfree(server.soniguri.enemybuls)
	server.soniguri.enemybuls[enemystruct.spikes[3]] = unidusspike(enemystruct)
	enemystruct.spikes[4] = findfree(server.soniguri.enemybuls)
	server.soniguri.enemybuls[enemystruct.spikes[4]] = unidusspike(enemystruct)

	enemystruct.spikedirs = {0,90,180,270} //spike ball directions

	enemystruct.hp = 80
	enemystruct.delete = 0
	enemystruct.spawntics = 0
	enemystruct.script = unidusfunc
	enemystruct.image = 22
	enemystruct.flags = 0
	return(enemystruct)
end

local function homemissilefunc(i)
	local bullstruct = server.soniguri.enemybuls[i]
	bullstruct.spawntics = $1 + 1
	if bullstruct.spawntics < 23 and bullstruct.target ~= nil
		bullstruct.direction = rotpart(bullstruct.direction,(AngleFixed(R_PointToAngle2(bullstruct.x,bullstruct.y,bullstruct.target.x,bullstruct.target.y))/FRACUNIT)+90,5)
		bullstruct.xspeed = FixedMul(3*FRACUNIT,sin(FixedAngle(bullstruct.direction*FRACUNIT)))/2
		bullstruct.yspeed = (FixedMul(3*FRACUNIT,cos(FixedAngle(bullstruct.direction*FRACUNIT)))*-1)/2
	elseif bullstruct.yspeed + bullstruct.xspeed < 11*HALFUNIT
		bullstruct.xspeed = $1 + FixedMul(FRACUNIT,sin(FixedAngle(bullstruct.direction*FRACUNIT)))/2
		bullstruct.yspeed = $1 + (FixedMul(FRACUNIT,cos(FixedAngle(bullstruct.direction*FRACUNIT)))*-1)/2
	end
end

local function homemissile(sx,sy,dir)
	local bullstruct = {x,y}
	bullstruct.x = sx
	bullstruct.y = sy
	bullstruct.xspeed = 0
	bullstruct.yspeed = 0
	bullstruct.direction = dir
	bullstruct.image = 34
	bullstruct.damage = 1
	bullstruct.script = nil
	bullstruct.flags = 0
	bullstruct.target = findplayer(bullstruct)
	bullstruct.spawntics = 0
	bullstruct.script = homemissilefunc
	bullstruct.damage = FRACUNIT/17
	return(bullstruct)
end



local function homemissilefunc2(i)
	local bullstruct = server.soniguri.enemybuls[i]
	bullstruct.spawntics = $1 + 1
	if bullstruct.spawntics < 20 and bullstruct.target ~= nil
		bullstruct.direction = rotpart(bullstruct.direction,(AngleFixed(R_PointToAngle2(bullstruct.x,bullstruct.y,bullstruct.target.x,bullstruct.target.y))/FRACUNIT)+90,2)
		bullstruct.xspeed = FixedMul(3*FRACUNIT,sin(FixedAngle(bullstruct.direction*FRACUNIT)))/2
		bullstruct.yspeed = (FixedMul(3*FRACUNIT,cos(FixedAngle(bullstruct.direction*FRACUNIT)))*-1)/2
	elseif bullstruct.yspeed + bullstruct.xspeed < 11*HALFUNIT
		bullstruct.xspeed = $1 + FixedMul(FRACUNIT,sin(FixedAngle(bullstruct.direction*FRACUNIT)))/2
		bullstruct.yspeed = $1 + (FixedMul(FRACUNIT,cos(FixedAngle(bullstruct.direction*FRACUNIT)))*-1)/2
	end
end

local function homemissile2(sx,sy,dir)
	local bullstruct = {x,y}
	bullstruct.x = sx
	bullstruct.y = sy
	bullstruct.xspeed = 0
	bullstruct.yspeed = 0
	bullstruct.direction = dir
	bullstruct.image = 34
	bullstruct.damage = 1
	bullstruct.script = nil
	bullstruct.flags = 0
	bullstruct.target = findplayer(bullstruct)
	bullstruct.spawntics = 0
	bullstruct.script = homemissilefunc2
	bullstruct.damage = FRACUNIT/17
	return(bullstruct)
end

local function jettyfunc(i)
	local enemystruct = server.soniguri.enemies[i]
	if enemystruct.spawntics > 35
		if enemystruct.face == 0
			if enemystruct.direction < 90 or enemystruct.direction >= 270
				enemystruct.direction = $1 + 6
			end
			if enemystruct.direction >= 360
				enemystruct.direction = $1 - 360
			end
		else
			if enemystruct.direction > 90
				enemystruct.direction = $1 - 6
			end
		end
		enemystruct.xspeed = FixedMul(8*FRACUNIT,sin(FixedAngle(enemystruct.direction*FRACUNIT)))/2
		enemystruct.yspeed = (FixedMul(8*FRACUNIT,cos(FixedAngle(enemystruct.direction*FRACUNIT)))*-1)/2
		if enemystruct.spawntics == 36 or enemystruct.spawntics == 43 or enemystruct.spawntics == 51 or enemystruct.spawntics == 58 //if time matches up with these, spawn some homing missiles
			server.soniguri.enemybuls[findfree(server.soniguri.enemybuls)] = homemissile(enemystruct.x,enemystruct.y,enemystruct.direction)
		end
	end

	if (enemystruct.spawntics & 2)
		enemystruct.image = 28
	else
		enemystruct.image = 27
	end

	local hp = enemystruct.hp //runs collision, then allocates hyper.

	enemycol(13,11,enemystruct)

	hyperallocate(enemystruct.hp,hp)

	if enemystruct.hp <= 0 //kills itself and creates an explosion in its place.
		enemysplod(i,enemystruct)
	end

	if enemystruct.x > 740*HALFUNIT
		enemystruct.delete = 1
	end
end


local function jetty(sx,sy)
	local enemystruct = {x,y}
	enemystruct.x = sx
	enemystruct.y = sy
	enemystruct.direction = 270
	enemystruct.xspeed = -3*HALFUNIT
	enemystruct.yspeed = 0
	enemystruct.truspeed = 5

	enemystruct.hp = 140
	enemystruct.delete = 0
	enemystruct.spawntics = 0
	enemystruct.script = jettyfunc
	enemystruct.image = 27
	enemystruct.flags = 0
	if sy < 200*HALFUNIT //upper half of the screen? set your direction to rotate to down! otherwise, set it to up.
		enemystruct.face = 1
	else
		enemystruct.face = 0
	end
	return(enemystruct)
end

local function bossbul(sx,sy,dir)
	local beamstruct = {x,y}
	beamstruct.x = sx
	beamstruct.y = sy
	beamstruct.direction = dir
	beamstruct.xspeed = FixedMul(9*FRACUNIT,sin(FixedAngle(beamstruct.direction * FRACUNIT)))/2 //set speed
	beamstruct.yspeed = (FixedMul(9*FRACUNIT,cos(FixedAngle(beamstruct.direction * FRACUNIT)))*-1)/2
	beamstruct.damage = 1967
	beamstruct.flags = V_30TRANS
	beamstruct.image = 10
	beamstruct.beam = 1
	return(beamstruct)
end

local function bossatk1()
	local spawndir = 0
	local spawnx = 320*HALFUNIT
	local spawny = 200*HALFUNIT
	local i = 1
	while i<15
		server.soniguri.enemybuls[findfree(server.soniguri.enemybuls)] = homemissile2(spawnx,spawny,spawndir)
		i = i + 1
		spawndir = $1 + 24
	end
end

local function bossatk2()
	local spawndir = 0
	local spawnx = 410*HALFUNIT
	local spawny = 230*HALFUNIT
	local i = 1
	while i<15
		server.soniguri.enemybuls[findfree(server.soniguri.enemybuls)] = bossbul(spawnx,spawny,spawndir)
		i = i + 1
		spawndir = $1 + 24
	end
end

local function bossatk3()
	local spawndir = 0
	local spawnx = 230*HALFUNIT
	local spawny = 150*HALFUNIT
	local i = 1
	while i<15
		server.soniguri.enemybuls[findfree(server.soniguri.enemybuls)] = bossbul(spawnx,spawny,spawndir)
		i = i + 1
		spawndir = $1 + 24
	end
end

local function bossdeath()
	server.soniguri.enemies[findfree(server.soniguri.enemies)] = bosssplod(P_RandomRange(230,410)*HALFUNIT,P_RandomRange(150,230)*HALFUNIT)
end

local function doomsdayfunc(i)
	local enemystruct = server.soniguri.enemies[i]
	if enemystruct.spawntics == 313
		enemystruct.xspeed = 0
	end
	if (enemystruct.spawntics & 1)
		enemystruct.image = 30
	else
		if (enemystruct.spawntics & 2)
			enemystruct.image = 31
		else
			enemystruct.image = 29
		end
	end
	if enemystruct.spawntics == 435
		server.soniguri.drawbosshud = true
	end
	if enemystruct.spawntics >= 435
		local hp = enemystruct.hp //collision

		local col

		local i2 = 1

		local i3 = 1

		while i3<4
			col = collideoffset(enemystruct,-147+(40*i2),-88+(40*i3),10,10)
			if col ~= nil and col ~= 0
				i3 = 4
			end
			i2 = $1 + 1
			if i2 == 7
				i2 = 1
				i3 = $1 + 1
			end
		end

		local rng

		if enemystruct.spawntics == 510
			rng = 1
		end
		if enemystruct.spawntics == 473
			rng = P_RandomRange(2,4)
		end

		if rng == 1
			bossatk1()
			enemystruct.spawntics = 436
		end
		if rng == 2
			bossatk2()
		end
		if rng == 3
			bossatk3()
		end
		if rng == 4
			bossatk2()
			bossatk3()
		end

		if col ~= nil and col ~= 0 //get rekt
			enemystruct.hp = $1 - server.soniguri.playerbuls[col].damage
			server.soniguri.playerbuls[col].hit = 1
		end

		server.soniguri.bosshp = enemystruct.hp

		hyperallocate(enemystruct.hp,hp) //allocate hyper

		if enemystruct.hp <= 0 and enemystruct.spawntics <= 510
			enemystruct.spawntics = 511
		end
		if enemystruct.spawntics > 510
			bossdeath()
			if enemystruct.spawntics & 7
				S_StartSound(nil,sfx_cybdth)
			end
			if enemystruct.spawntics >= 550
				server.soniguriclear = true
				sugoi.AwardEmerald(true)
				for player in players.iterate
					P_DoPlayerExit(player)
				end
			end
		end
	end
end

local function doomsday(sx,sy)
	local enemystruct = {x,y}
	enemystruct.x = sx
	enemystruct.y = sy
	S_ChangeMusic("DMSDAY") //change moosic
	enemystruct.direction = 0
	enemystruct.xspeed = -2*HALFUNIT
	enemystruct.yspeed = 0
	enemystruct.hp = 6000
	enemystruct.delete = 0
	enemystruct.spawntics = 0
	enemystruct.image = 29
	enemystruct.flags = 0
	enemystruct.script = doomsdayfunc
	server.soniguri.bosshp = 6000
	return(enemystruct)
end

local function mbsball(sx,sy)
	local spikestruct = {x,y}
	spikestruct.x = sx
	spikestruct.y = sy
	spikestruct.xspeed = 0
	spikestruct.yspeed = 0
	spikestruct.direction = 0
	spikestruct.delete = 0
	spikestruct.image = 0
	spikestruct.flags = 0
	return(spikestruct)
end

local function mblaser(sx,sy)
	local beamstruct = {x,y}
	beamstruct.x = sx
	beamstruct.y = sy
	beamstruct.direction = dir
	beamstruct.xspeed = FixedMul(12*FRACUNIT,sin(FixedAngle(beamstruct.direction * FRACUNIT)))/2 //set speed
	beamstruct.yspeed = (FixedMul(12*FRACUNIT,cos(FixedAngle(beamstruct.direction * FRACUNIT)))*-1)/2
	beamstruct.damage = 1967
	beamstruct.flags = V_30TRANS
	beamstruct.image = 10
	beamstruct.beam = 1
	return(beamstruct)
end

/*
HOLD UP THERE MISTER
I HEARD YOU WANTED TO MAKE YOUR OWN ENEMIES AND BULLETS
NO?
SCREW YOU, YOU'RE GONNA GET EDUCATED ANYWAY
START OUT BY MAKING A FUNCTION
INSIDE OF THAT FUNCTION MAKE A LOCAL STRUCT WITH X AND Y
SEE UNIDUS ABOVE FOR REFERENCE
ALL ENEMIES MUST HAVE THE FOLLOWING IN THEIR STRUCT:
x
y
direction
xspeed
yspeed
hp -NOT NEEDED IN BULLETS
delete
spawntics -NOT NEEDED IN BULLETS
image
flags
AND RECOMMENDED IF YOU WANT THE THING TO ACTUALLY BLEEDIN DO SOMETHING (NOT NECESSARILY ALWAYS NEEDED FOR BULLETS)
script
ALL ABOVE VARIABLES EXCEPT SCRIPT /MUST/ BE INITIALIZED OTHERWISE THEY WILL CAUSE ERRORS
X IS FOR THE X POSITION
Y IS FOR THE Y POSITION
DIRECTION IS THE ANGLE
XSPEED IS THE XSPEED
YSPEED IS THE YSPEED
XSPEED AND YSPEED DO NOT NATURALLY ACCOUNT FOR ANGLE, YOU MUST ROTATE THEM ON YOUR OWN!
HP IS HOW MUCH HP IT SPAWNS WITH
DELETE MUST BE INITIALIZED TO 0, IT IS USED FOR CLEANUP
SPAWNTICS CAN BE INITIALIZED TO ANYTHING, BUT RECOMMENDED TO BE SET TO 0. LETS YOU TIME THINGS, AS THE VALUE INCREMENTS EVERY FRAME. IT CAN ALSO BE MODIFIED IN THE SCRIPT FOR YOUR OWN NEEDS, BUT IT WILL STILL INCREMENT.
IMAGE IS THE IMAGE NUMBER IT WILL DRAW FROM. SEE FUNCTION GETBULARRAY
FLAGS IS THE DRAWING FLAGS. IF NONE ARE NEEDED, SET TO 0. V_SMALLSCALEPATCH IS AUTOMATICALLY APPLIED TO ALL DRAWN PATCHES.
SCRIPT IS THE SCRIPT YOU WISH TO CALL ON EVERY FRAME OF ITS EXISTENCE.
BULLETS ALSO NEED THEIR COLLISION DEFINED AT THE TOP INSIDE OF THE BULLETWIDTHS AND BULLETHEIGHTS ARRAYS.
THERE ARE SEVERAL USEFUL FUNCTIONS YOU WILL WANT TO USE HERE.
CONSULT EGGROBOFUNC FOR FURTHER DETAILS REGARDING THESE.
ONCE THE ENEMY IS FULLY INITIALIZED, RETURN THE STRUCT AND END THE FUNCTION.
*/

local function hyperfunc(i)
	local hyperstruct = server.soniguri.playerbuls[i]
	hyperstruct.spawntics = $1 + 1

	if hyperstruct.hit == 1 and hyperstruct.spawntics & 4 //play sound when hitting
		S_StartSound(nil,sfx_scrash)
		hyperstruct.hit = 0
	end

	if hyperstruct.spawntics >= 29 //transparency
		hyperstruct.damage = 0
		if hyperstruct.flags == V_90TRANS
			hyperstruct.delete = 1
		end
		if hyperstruct.flags == V_80TRANS
			hyperstruct.flags = V_90TRANS
		end
		if hyperstruct.flags == V_70TRANS
			hyperstruct.flags = V_80TRANS
		end
		if hyperstruct.flags == V_60TRANS
			hyperstruct.flags = V_70TRANS
		end
		if hyperstruct.flags == V_50TRANS
			hyperstruct.flags = V_60TRANS
		end
		if hyperstruct.flags == V_40TRANS
			hyperstruct.flags = V_50TRANS
		end
		if hyperstruct.flags == V_30TRANS
			hyperstruct.flags = V_40TRANS
		end
		if hyperstruct.flags == V_20TRANS
			hyperstruct.flags = V_30TRANS
		end
		if hyperstruct.flags == V_10TRANS
			hyperstruct.flags = V_20TRANS
		end
		if hyperstruct.flags == 0
			hyperstruct.flags = V_10TRANS
		end
	end
	if (hyperstruct.spawntics & 1)
		hyperstruct.image = 33
	else
		hyperstruct.image = 32
	end
end


local function beamhyper(sogs)
	local hyperstruct = {x,y}
	hyperstruct.direction = sogs.direction + 90
	if hyperstruct.direction >= 360
		hyperstruct.direction = $1 - 360
	end
	hyperstruct.x = sogs.x + (FixedMul(409*FRACUNIT,sin(FixedAngle(hyperstruct.direction*FRACUNIT)))/2)
	hyperstruct.y = sogs.y - (FixedMul(409*FRACUNIT,cos(FixedAngle(hyperstruct.direction*FRACUNIT)))/2)
	hyperstruct.xspeed = 0
	hyperstruct.yspeed = 0
	hyperstruct.delete = 0
	hyperstruct.flags = 0
	hyperstruct.image = 32
	hyperstruct.damage = 13
	hyperstruct.spawntics = 0
	hyperstruct.script = hyperfunc
	hyperstruct.del = 0
	return(hyperstruct)
end

local function bazookaf(sogs)
	local bazstruct = {x,y}
	bazstruct.x = sogs.x
	bazstruct.y = sogs.y

	if server.soniguri.enemies[sogs.enemy] ~= nil and server.soniguri.enemies[sogs.enemy] ~= -1 //if enemy exists, aim at it
		bazstruct.direction = (AngleFixed(R_PointToAngle2(sogs.x,sogs.y,server.soniguri.enemies[sogs.enemy].x,server.soniguri.enemies[sogs.enemy].y))/FRACUNIT)+90
		if bazstruct.direction > 360
			bazstruct.direction = bazstruct.direction - 360
		end
	else //else just shoot right
		bazstruct.direction = 90
	end

	bazstruct.xspeed = FixedMul(11*FRACUNIT,sin(FixedAngle(bazstruct.direction * FRACUNIT)))/2 //set speed
	bazstruct.yspeed = (FixedMul(11*FRACUNIT,cos(FixedAngle(bazstruct.direction * FRACUNIT)))*-1)/2

	bazstruct.image = 12
	bazstruct.damage = 280
	bazstruct.flags = 0
	bazstruct.hit = 0
	bazstruct.script = explodewhenhit
	return(bazstruct)
end

local function dashring(x2,y2,direction2)
	local ringstruct = {x,y,direction}
	ringstruct.x = x2
	ringstruct.y = y2
	ringstruct.direction = direction2
	ringstruct.time = 0
	ringstruct.image = 7
	ringstruct.flags = 0
	return(ringstruct)
end

local lvlarray = {"w",100,"s",eggrobo,670*HALFUNIT,200*HALFUNIT,"w",100,"s",eggrobo,670*HALFUNIT,70*HALFUNIT,"s",eggrobo,670*HALFUNIT,330*HALFUNIT,"e","w",35,"s",unidus,670*HALFUNIT,200*HALFUNIT,"e","w",20,"s",eggrobo,670*HALFUNIT,250*HALFUNIT,"s",unidus,670*HALFUNIT,70*HALFUNIT,"e","w",35,"s",unidus,670*HALFUNIT,50*HALFUNIT,"s",unidus,670*HALFUNIT,150*HALFUNIT,"s",unidus,670*HALFUNIT,250*HALFUNIT,"e","w",60,"s",jetty,670*HALFUNIT,200*HALFUNIT,"e","w",30,"s",jetty,670*HALFUNIT,50*HALFUNIT,"s",jetty,670*HALFUNIT,200*HALFUNIT,"s",eggrobo,670*HALFUNIT,250*HALFUNIT,"e","w",30,"s",jetty,670*HALFUNIT,50*HALFUNIT,"w",15,"s",jetty,670*HALFUNIT,150*HALFUNIT,"w",15,"s",jetty,670*HALFUNIT,200*HALFUNIT,"w",15,"s",jetty,670*HALFUNIT,250*HALFUNIT,"e","w",100,"s",facestabber,670*HALFUNIT,200*HALFUNIT,"w",30,"s",eggrobo,670*HALFUNIT,50*HALFUNIT,"s",eggrobo,670*HALFUNIT,250*HALFUNIT,"e","w",50,"s",eggrobo,670*HALFUNIT,50*HALFUNIT,"s",eggrobo,670*HALFUNIT,100*HALFUNIT,"s",eggrobo,670*HALFUNIT,150*HALFUNIT,"s",eggrobo,670*HALFUNIT,200*HALFUNIT,"s",eggrobo,670*HALFUNIT,250*HALFUNIT,"s",eggrobo,670*HALFUNIT,300*HALFUNIT,"e","w",30,"k","w",15,"k","w",30,"s",eggrobo,670*HALFUNIT,50*HALFUNIT,"s",eggrobo,670*HALFUNIT,350*HALFUNIT,
"w",15,"s",eggrobo,670*HALFUNIT,100*HALFUNIT,"s",eggrobo,670*HALFUNIT,300*HALFUNIT,"s",facestabber,670*HALFUNIT,200*HALFUNIT,"e","w",20,
"s",facestabber,670*HALFUNIT,50*HALFUNIT,"s",facestabber,670*HALFUNIT,350*HALFUNIT,"e","s",jetty,670*HALFUNIT,200*HALFUNIT,"e","w",60,
"s",unidus,670*HALFUNIT,50*HALFUNIT,"s",unidus,670*HALFUNIT,350*HALFUNIT,"e","w",40,"s",jetty,670*HALFUNIT,200*HALFUNIT,"s",jetty,670*HALFUNIT,50*HALFUNIT,"s",jetty,670*HALFUNIT,350*HALFUNIT,"s",eggrobo,670*HALFUNIT,125*HALFUNIT,"s",eggrobo,670*HALFUNIT,275*HALFUNIT,"w",100,"k","w",200,"s",doomsday,950*HALFUNIT,200*HALFUNIT,"e"}


local function levelparse(levelarray) //PARSE LEVEL
	local done = 0
	local add = 2
	while server.soniguri.lvlwait == 0
		done = 0
		add = 2
		if lvlarray[server.soniguri.lvlpos] == "w"
			server.soniguri.lvlwait = lvlarray[server.soniguri.lvlpos+1]
			done = 1
		end
		if lvlarray[server.soniguri.lvlpos] == "s" and done == 0
			server.soniguri.enemies[findfree(server.soniguri.enemies)] = lvlarray[server.soniguri.lvlpos+1](lvlarray[server.soniguri.lvlpos+2],lvlarray[server.soniguri.lvlpos+3])
			add = 4
			done = 1
		end
		if lvlarray[server.soniguri.lvlpos] == "e" and done == 0
			server.soniguri.lvlwait = -1
			done = 1
			add = 1
		end
		if lvlarray[server.soniguri.lvlpos] == "k" and done == 0
			done = 1
			add = 1
			server.soniguri.sngcloudstate = $1 + 1
		end
		server.soniguri.lvlpos = server.soniguri.lvlpos + add
	end
	if server.soniguri.lvlwait > 0
		server.soniguri.lvlwait = server.soniguri.lvlwait - 1
	end
	if server.soniguri.enemies[1] == nil and server.soniguri.lvlwait == -1
		server.soniguri.lvlwait = 0
	end
end

local dashspeed = 12

local dashangle = 6

local slowdownspeed = 1*HALFUNIT

local lastmap
addHook("MapLoad",function(mapname)
	if not (server and server.valid) return end -- sal

	if mapheaderinfo[mapname].soniguri
		server.soniguri = P_SpawnMobj(1,1,1,MT_GFZFLOWER1)
		server.soniguri.enemybuls = {}
		server.soniguriclear = false
		server.soniguri.playerbuls = {}
		server.soniguri.enemies = {}
		server.soniguri.dashrings = {}
		server.drawshit = {0,0,0,0}
		server.drawshit2 = {0,0,0,0,0,0,0,0}
		server.soniguri.gamestate = 0
		server.soniguri.sngspacescroll = 0
		server.soniguri.sngcloudscroll = 0
		server.soniguri.sngcloudstate = 0
		server.soniguri.sngcloudy = 0
		server.soniguri.sngcloudtimer = 0
		sugoi.HUDShow("score", false)
		sugoi.HUDShow("time", false)
		sugoi.HUDShow("rings", false)
		sugoi.HUDShow("lives", false)
		for player in players.iterate
			player.soogsobject = nil
		end
		server.soniguri.lvlpos = 1
		server.soniguri.lvlwait = 0
		server.soniguri.drawbosshud = false
		server.soniguri.gamestate = 0
		server.soniguri.sngcloudscroll = 0
		server.soniguri.sngcloudstate = 0
		server.soniguri.cloudy = 0
		server.soniguri.sngcloudtimer = 0
		if (server.isdedicated) // Salt: Maybe this'll fix dedicated servers? IDK (Confirmed, it does)
		or (modeattacking) // Salt: Aaa! It also breaks RA-specific replays apparently
			server.soniguri.slide = 10
		else
			server.soniguri.slide = 0
		end
	else
		server.soniguri = nil
		for player in players.iterate
			player.soogsobject = nil
		end

		if (lastmap != nil and mapheaderinfo[lastmap].soniguri)
			sugoi.HUDShow("score", true)
			sugoi.HUDShow("time", true)
			sugoi.HUDShow("rings", true)
			sugoi.HUDShow("lives", true)
		end
	end

	lastmap = mapname
end)


addHook("ThinkFrame", function()
	if not (server and server.valid) return end -- sal
	if server.soniguri ~= nil and server.soniguri.valid
	if server.soniguri.gamestate == 0
		if server.cmd.buttons & BT_JUMP and server.nojmp == 1
			server.soniguri.slide = $1 + 1
		end
		if server.cmd.buttons & BT_JUMP
			server.nojmp = 0
		else
			server.nojmp = 1
		end
		if server.soniguri.slide == 10
			server.soniguri.gamestate = 1
		end
	end

	if server.soniguri.gamestate == 1
		for player in players.iterate //main soniguri stuff
//			player.powers[pw_nocontrol] = 1 //disable control

			if player.soogsobject == nil //create suguri object
				player.soogsobject = soogsobjectreset()
				player.pflags = $1 | PF_FORCESTRAFE
			end

			local btn = player.cmd //ease-of-use
			local sogs = player.soogsobject
			//CONS_Printf(server,playercollision(6,13,sogs,server.soniguri.enemybuls))

			if server.soniguri.enemies[sogs.enemy] == nil or server.soniguri.enemies[sogs.enemy] == -1 or server.soniguri.enemies[sogs.enemy].cantarget ~= nil
				sogs.enemy = findenemy(sogs)
			end

			local colobject = playercollision(1,1,sogs,server.soniguri.enemybuls)

			if sogs.invinc > 0
				sogs.invinc = $1 - 1
			end

			if colobject ~= 0 and sogs.invinc == 0
				if (sogs.dashing == 1 and server.soniguri.enemybuls[colobject].beam == nil) or sogs.dashing == 0
					sogs.action = -1 //no movey movey
					sogs.delay = 6
					sogs.direction = 90
					sogs.hp = $1 - server.soniguri.enemybuls[colobject].damage //initial damage
					sogs.xspeed = FixedMul(10*FRACUNIT,sin(FixedAngle(server.soniguri.enemybuls[colobject].direction*FRACUNIT)))/2 //set speed
					sogs.yspeed = FixedMul(10*FRACUNIT,cos(FixedAngle(server.soniguri.enemybuls[colobject].direction*FRACUNIT)))/2
					sogs.hp = $1 - FixedMul(FixedMul(server.soniguri.enemybuls[colobject].damage,FixedDiv(sogs.heat*FRACUNIT,FRACUNIT*100)),FRACUNIT+HALFUNIT) //extra heat damage
					sogs.invinc = 14
					sogs.dashing = 0
					sogs.canmove = 0
					S_StartSound(nil,sfx_scrash)
					if sogs.hp <= 0
						sogs.action = -2
						sogs.delay = 35
						sogs.invinc = -1
					end
				end
				if sogs.dashing == 1 and server.soniguri.enemybuls[colobject].beam ~= nil
					sogs.heat = $1 + 1
					sogs.special = $1 + 1
				end
			end

			if sogs.action ~= 0
				sogs.delay = sogs.delay - 1
				if sogs.action == 1 //perform normal beam rifle shot
					if sogs.delay == 15
						server.soniguri.playerbuls[findfree(server.soniguri.playerbuls)] = beamrifle1(player.soogsobject)
						S_StartSound(nil,sfx_beams)
					end
					if sogs.delay <= 15
						sogs.canmove = 1
					elseif server.soniguri.enemies[sogs.enemy] ~= nil and server.soniguri.enemies[sogs.enemy] ~= -1
						sogs.direction = AngleFixed(R_PointToAngle2(sogs.x,sogs.y,server.soniguri.enemies[sogs.enemy].x,server.soniguri.enemies[sogs.enemy].y))/FRACUNIT
					end
					sogs.image = 5
				end

				if sogs.action == 2 //perform dash beam rifle shot
					if sogs.delay == 25 or sogs.delay == 20 or sogs.delay == 15
						server.soniguri.playerbuls[findfree(server.soniguri.playerbuls)] = beamrifle2(player.soogsobject)
						S_StartSound(nil,sfx_beams)
					end
					if sogs.delay <= 15
						sogs.canmove = 1
					elseif server.soniguri.enemies[sogs.enemy] ~= nil and server.soniguri.enemies[sogs.enemy] ~= -1
						sogs.direction = AngleFixed(R_PointToAngle2(sogs.x,sogs.y,server.soniguri.enemies[sogs.enemy].x,server.soniguri.enemies[sogs.enemy].y))/FRACUNIT
					end
				end

				if sogs.action == 3 //perform bazooka shot
					if sogs.delay == 15
						server.soniguri.playerbuls[findfree(server.soniguri.playerbuls)] = bazookaf(sogs)
						S_StartSound(nil,sfx_bazook)
					end
					if sogs.delay <= 15
						sogs.canmove = 1
					elseif server.soniguri.enemies[sogs.enemy] ~= nil and server.soniguri.enemies[sogs.enemy] ~= -1
						sogs.direction = AngleFixed(R_PointToAngle2(sogs.x,sogs.y,server.soniguri.enemies[sogs.enemy].x,server.soniguri.enemies[sogs.enemy].y))/FRACUNIT
					end
					sogs.image = 6
				end

				if sogs.action == 4 //perform normal beam rifle shot
					if sogs.delay == 38
						server.soniguri.playerbuls[findfree(server.soniguri.playerbuls)] = beamhyper(player.soogsobject)
						S_StartSound(nil,sfx_shyper)
					end
					if sogs.delay <= 20
						sogs.canmove = 1
					elseif server.soniguri.enemies[sogs.enemy] ~= nil and server.soniguri.enemies[sogs.enemy] ~= -1
						sogs.direction = AngleFixed(R_PointToAngle2(sogs.x,sogs.y,server.soniguri.enemies[sogs.enemy].x,server.soniguri.enemies[sogs.enemy].y))/FRACUNIT
					end
					sogs.image = 5
				end

				if sogs.action == -1 //get rekt skrub
					sogs.image = -1
				end

				if sogs.action == -2 //DIE, DIE, DIE
					if sogs.delay == 1
						sogs.delay = -1
						sogs.image = -2
						S_StartSound(nil,sfx_sdead)
					elseif sogs.delay > 1
						sogs.image = -1
					end
				end

				if sogs.delay == 0 //reset stuff when delay ends
					sogs.canmove = 2
					sogs.action = 0
					sogs.direction = 90
				end
			end

			if sogs.canmove == 2 then //allow movement and shooting

				if (btn.buttons & BT_JUMP) and sogs.dashing == 0 and sogs.nojmp == 1 //shoot
					sogs.delay = 21
					sogs.action = 1
					sogs.image = 5
					sogs.canmove = 0
					sogs.direction = 0
				end

				if (btn.buttons & BT_JUMP) and sogs.dashing == 1 and sogs.nojmp == 1 //dash shoot
					sogs.delay = 28
					sogs.action = 2
					sogs.image = 5
					sogs.canmove = 0
					sogs.direction = 0
					sogs.heat = $1 + 45
				end

				if (btn.buttons & BT_USE) and sogs.action == 0 and sogs.nospn == 1 //BAZOOKS
					sogs.delay = 28
					sogs.action = 3
					sogs.image = 6
					sogs.canmove = 0
					sogs.direction = 0
				end

				if sogs.anim > 0
					sogs.animtimer = sogs.animtimer - 1
					if sogs.anim == 1
						if sogs.animtimer == 0
							local done = 0
							if sogs.image == 4
								sogs.image = 1
								done = 1
							end
							if sogs.image == 3
								sogs.image = 4
							end
							if sogs.image == 2
								sogs.image = 3
							end
							if sogs.image == 1 and done == 0
								sogs.image = 2
							end
							sogs.animtimer = 2
						end
					end
				end

				if sogs.dashing == 0 //base movement

					if btn.forwardmove > 20 and abs(sogs.yspeed) <= 3 * HALFUNIT
						sogs.yspeed = -(3 * HALFUNIT)
						sogs.image = 2
					end

					if btn.forwardmove < -20 and abs(sogs.yspeed) <= 3 * HALFUNIT
						sogs.yspeed = (3 * HALFUNIT)
						sogs.image = 4
					end

					if btn.sidemove > 20 and abs(sogs.xspeed) <= 3 * HALFUNIT
						sogs.xspeed = (3 * HALFUNIT)
					end

					if btn.sidemove < -20 and abs(sogs.xspeed) <= 3 * HALFUNIT
						sogs.xspeed = -(3 * HALFUNIT)
					end

					if btn.forwardmove == 0
						sogs.image = 1
					end

				end
			end

			if sogs.canmove == 0 then //cancel out any dashes that may be occuring when you shouldn't be moving
				sogs.dashing = 0
			end


			if sogs.canmove >= 1 //hyper
				if (btn.buttons & BT_CUSTOM2) and sogs.action == 0 and sogs.special >= 100
					sogs.delay = 43
					sogs.action = 4
					sogs.image = 5
					sogs.canmove = 0
					sogs.direction = 0
					sogs.special = $1 - 100
					sogs.invinc = 50
				end
			end

			if (btn.buttons & BT_JUMP) //keep you from holding down the buttons to spam shots with frame perfect accuracy
				sogs.nojmp = 0
			else
				sogs.nojmp = 1
			end

			if (btn.buttons & BT_USE)
				sogs.nospn = 0
			else
				sogs.nospn = 1
			end

			if sogs.canmove >= 1 then //allow dashing

				if (btn.buttons & BT_CUSTOM1) and sogs.dashing == 0 and sogs.candash == 1 //dashing
					sogs.dashing = 1
					S_StartSound(nil,sfx_sdash)
					if btn.forwardmove ~= 0 or btn.sidemove ~= 0
						sogs.direction = AngleFixed(R_PointToAngle2(0,0,btn.forwardmove*FRACUNIT,btn.sidemove*FRACUNIT))/FRACUNIT //get angle
					end
					sogs.canmove = 2
					sogs.action = 0
					sogs.delay = 0
					sogs.heat = sogs.heat + 30
					sogs.image = 1
					sogs.anim = 1
					sogs.animtimer = 2
				end

				if not (btn.buttons & BT_CUSTOM1) and sogs.dashing == 1 //stop
					sogs.dashing = 0
					sogs.direction = 90
					sogs.image = 1
					sogs.anim = 0
					sogs.animtimer = 0
				end

				if btn.sidemove ~= 0 or btn.forwardmove ~= 0

				if sogs.dashing == 1 //dashing movement, ported from heat 300%
					sogs.tempangle = AngleFixed(R_PointToAngle2(0,0,btn.forwardmove*FRACUNIT,btn.sidemove*FRACUNIT))/FRACUNIT //get angle
					if sogs.tempangle>180 then //get the angle for the opposite direction; works by checking if you're above 180 or below it, and changing a value based off of that.
						sogs.tempangle2 = 180
						sogs.tempangle2 = (sogs.tempangle-sogs.tempangle2)
					else
						sogs.tempangle2 = 180
						sogs.tempangle2 = (sogs.tempangle2+sogs.tempangle)
					end
					if sogs.tempangle2<180 then //dashdirection here is the direction to turn by, determines which direction to turn by by which half of the 360 degrees your pointing to compared to your actual angle
						if sogs.direction>sogs.tempangle2 and sogs.direction<sogs.tempangle then //set variables for dictating rotation
							sogs.dashdirection = 1
						else
							sogs.dashdirection = -1
						end
					else
						if sogs.direction>sogs.tempangle and sogs.direction<sogs.tempangle2 then
							sogs.dashdirection = -1
						else
							sogs.dashdirection = 1
						end
					end
					if leveltime % 6 == 0 //create dashring every 6 frames
						server.soniguri.dashrings[findfree(server.soniguri.dashrings)] = dashring(sogs.x,sogs.y,sogs.direction)
					end
				end

				else
				sogs.dashdirection = 0
				end

				if sogs.dashing == 1
					sogs.heat = sogs.heat + 3 //heat
				end

				if sogs.dashing == 1 //dashing movement part 2, still ported from heat 300%
					if sogs.direction ~= sogs.tempangle then //rotate if your angle isn't accurate
						sogs.direction = $1 + (dashangle * sogs.dashdirection)
					end

					if sogs.direction + dashangle >= sogs.tempangle and sogs.direction - dashangle <= sogs.tempangle then //check if you're within the dashangle values for the actual angle you wanna go at, and if so, set the angle to the angle you wish to be at
						sogs.direction = sogs.tempangle
					end

					sogs.xspeed = FixedMul(dashspeed * FRACUNIT,sin(FixedAngle(sogs.direction * FRACUNIT)))/2 //set movement values
					sogs.yspeed = (FixedMul(dashspeed * FRACUNIT,cos(FixedAngle(sogs.direction * FRACUNIT)))*-1)/2
					if sogs.direction > 360 then //loop around angles if they exceed what they should
						sogs.direction = sogs.direction - 360
					end
					if sogs.direction< 0 then
						sogs.direction = sogs.direction + 360
					end
				end

			end

			if (btn.buttons & BT_CUSTOM1) and sogs.dashing == 0 //enable dashing
				sogs.candash = 0
			end
			if sogs.candash == 0 and not (btn.buttons & BT_CUSTOM1)
				sogs.candash = 1
			end

			//CONS_Printf(server,sogs.tempangle)
			//CONS_Printf(server,sogs.xspeed/HALFUNIT)
			//CONS_Printf(server,sogs.yspeed/HALFUNIT)
			//CONS_Printf(server,sogs.direction)

			sogs.x = $1 + (sogs.xspeed) //add speed values
			sogs.y = $1 + (sogs.yspeed)

			//slowdown code, also ported from heat 300%
			if sogs.xspeed ~= 0 or sogs.yspeed ~= 0 then --slow down there, ms. fas
				if sogs.xspeed>0 then --get direction of xspeed
					sogs.xdirection = 1
				else
					sogs.xdirection = -1
				end
				if sogs.yspeed>0 then --get direction of yspeed
					sogs.ydirection = 1
				else
					sogs.ydirection = -1
				end
				local tempspeed = abs(sogs.xspeed) + abs(sogs.yspeed) --generate the real speed
				local xslowdownspeed = FixedDiv(abs(sogs.xspeed) * 2 , tempspeed * 2) --generate percentage for slowdown
				local yslowdownspeed = FixedDiv(abs(sogs.yspeed) * 2 , tempspeed * 2) --generate percentage for slowdown, y edition
				sogs.xspeed = sogs.xspeed - (FixedMul(xslowdownspeed, slowdownspeed*2) * sogs.xdirection)/2
				sogs.yspeed = sogs.yspeed - (FixedMul(yslowdownspeed, slowdownspeed*2) * sogs.ydirection)/2
				if sogs.xspeed < slowdownspeed and sogs.xspeed > slowdownspeed*-1 then --reset xspeed to 0 if too near 0
					sogs.xspeed = 0
					xslowdownspeed=0
				end
				if sogs.yspeed < slowdownspeed and sogs.yspeed > slowdownspeed*-1 then --reset yspeed to 0 if too near 0
					sogs.yspeed = 0
					yslowdownspeed=0
				end
			end

			if sogs.x < 0 //limit you to the screen
				sogs.x = 0
			end
			if sogs.x > 640*HALFUNIT
				sogs.x = 640*HALFUNIT
			end
			if sogs.y < 0
				sogs.y = 0
			end
			if sogs.y > 400*HALFUNIT
				sogs.y = 400*HALFUNIT
			end

			if sogs.dashing == 0 and sogs.heat > 0 //lose heat
				sogs.heat = sogs.heat - 3
				if sogs.heat < 0
					sogs.heat = 0
				end
			end

			if sogs.heat > 300 //limit heat to 300%
				sogs.heat = 300
			end
		end
		bullethandler()
		enemyhandler()
		dashringhandler()
		levelparse(lvlarray)
		local numofplayers = 0
		local deadplayers = 0
		for p in players.iterate //exit level when everyone's dead
			numofplayers = $1 + 1
			if p.soogsobject.hp <= 0
				deadplayers = $1 + 1
			end
		end
		if deadplayers == numofplayers
			for p in players.iterate
				P_DoPlayerExit(p)
			end
		end
	end
	end
end)

//cloud background, made by root
local function TestDraw(v, stplyr, cam)
if ((splitscreen) and (stplyr == players[0])) return end
if server.soniguri ~= nil and server.soniguri.valid
local sngtcpatch = v.cachePatch("SNGSPACE")
	if (server.soniguri.sngcloudstate >= 3)
	v.draw(server.soniguri.sngspacescroll, 0, sngtcpatch)
	v.draw(server.soniguri.sngspacescroll + 256, 0, sngtcpatch)
	v.draw(server.soniguri.sngspacescroll + 512, 0, sngtcpatch)

	v.draw(server.soniguri.sngcloudscroll, -256, sngtcpatch)
	v.draw(server.soniguri.sngcloudscroll + 256, -256, sngtcpatch)
	v.draw(server.soniguri.sngcloudscroll + 512, -256, sngtcpatch)
	end

	if (server.soniguri.sngcloudstate == 0)
	local sngtcpatch = v.cachePatch("SNGCLOU1")
	v.draw(server.soniguri.sngcloudscroll, 0, sngtcpatch)
	v.draw(server.soniguri.sngcloudscroll + 256, 0, sngtcpatch)
	v.draw(server.soniguri.sngcloudscroll + 512, 0, sngtcpatch)

	v.draw(server.soniguri.sngcloudscroll, -256, sngtcpatch)
	v.draw(server.soniguri.sngcloudscroll + 256, -256, sngtcpatch)
	v.draw(server.soniguri.sngcloudscroll + 512, -256, sngtcpatch)
	end

	if (server.soniguri.sngcloudstate == 1)
	local sngtcpatch = v.cachePatch("SNGCLOU2")
	v.draw(server.soniguri.sngcloudscroll, 0, sngtcpatch)
	v.draw(server.soniguri.sngcloudscroll + 256, 0, sngtcpatch)
	v.draw(server.soniguri.sngcloudscroll + 512, 0, sngtcpatch)

	v.draw(server.soniguri.sngcloudscroll, -256, sngtcpatch)
	v.draw(server.soniguri.sngcloudscroll + 256, -256, sngtcpatch)
	v.draw(server.soniguri.sngcloudscroll + 512, -256, sngtcpatch)
	end

	if (server.soniguri.sngcloudstate == 2)
	local sngtcpatch = v.cachePatch("SNGCLOU3")
	v.draw(server.soniguri.sngcloudscroll, 0, sngtcpatch)
	v.draw(server.soniguri.sngcloudscroll + 256, 0, sngtcpatch)
	v.draw(server.soniguri.sngcloudscroll + 512, 0, sngtcpatch)

	v.draw(server.soniguri.sngcloudscroll, -256, sngtcpatch)
	v.draw(server.soniguri.sngcloudscroll + 256, -256, sngtcpatch)
	v.draw(server.soniguri.sngcloudscroll + 512, -256, sngtcpatch)
	end

	if (server.soniguri.sngcloudstate == 3)
	local sngtcpatch = v.cachePatch("SNGCLOU3")
	local sngtcpatch2 = v.cachePatch("SNGCLOU4")
	v.draw(server.soniguri.sngcloudscroll, server.soniguri.sngcloudy, sngtcpatch)
	v.draw(server.soniguri.sngcloudscroll + 256, server.soniguri.sngcloudy, sngtcpatch)
	v.draw(server.soniguri.sngcloudscroll + 512, server.soniguri.sngcloudy, sngtcpatch)

	v.draw(server.soniguri.sngcloudscroll, server.soniguri.sngcloudy-256, sngtcpatch2)
	v.draw(server.soniguri.sngcloudscroll + 256, server.soniguri.sngcloudy-256, sngtcpatch2)
	v.draw(server.soniguri.sngcloudscroll + 512, server.soniguri.sngcloudy-256, sngtcpatch2)
	end
end
end

hud.add(TestDraw,"game")

local function TestFrame()
if not (server and server.valid) return end // Salt: Demos don't like server
if server.soniguri ~= nil and server.soniguri.valid
server.soniguri.sngspacescroll = server.soniguri.sngspacescroll - 1
	if (server.soniguri.sngspacescroll <= -256) then
	server.soniguri.sngspacescroll = server.soniguri.sngspacescroll + 256
	end

server.soniguri.sngcloudscroll = server.soniguri.sngcloudscroll - 6
	if (server.soniguri.sngcloudscroll <= -256) then
	server.soniguri.sngcloudscroll = server.soniguri.sngcloudscroll + 256
	end

	if (server.soniguri.sngcloudstate == 3)
	server.soniguri.sngcloudy = $1 + 6
		if (server.soniguri.sngcloudy > 456)
		server.soniguri.sngcloudstate = 4
		end
	end
end
end

addHook("ThinkFrame", TestFrame)

local function getbularray(num) //convert bullet image numbers to strings for drawing
	if num==-2
		local strings = {"SDEDA0","SDEDA0","SDEDA0","SDEDA0","SDEDA0","SDEDA0","SDEDA0","SDEDA0","SDEDA0","SDEDA0","SDEDA0","SDEDA0","SDEDA0","SDEDA0","SDEDA0","SDEDA0","SDEDA0","SDEDA0","SDEDA0","SDEDA0","SDEDA0","SDEDA0","SDEDA0","SDEDA0"}
		return(strings)
	end
	if num==-1
		local strings = {"SGSHA0","SGSHA0","SGSHA0","SGSHA0","SGSHA0","SGSHA0","SGSHA0","SGSHA0","SGSHA0","SGSHA0","SGSHA0","SGSHA0","SGSHA0","SGSHA0","SGSHA0","SGSHA0","SGSHA0","SGSHA0","SGSHA0","SGSHA0","SGSHA0","SGSHA0","SGSHA0","SGSHA0"}
		return(strings)
	end
	if num==1
		local strings = {"SOOGA0","SOOGB0","SOOGC0","SOOGD0","SOOGE0","SOOGF0","SOOGG0","SOOGH0","SOOGI0","SOOGJ0","SOOGK0","SOOGL0","SOOGM0","SOOGN0","SOOGO0","SOOGP0","SOOGQ0","SOOGR0","SOOGS0","SOOGT0","SOOGU0","SOOGV0","SOOGW0","SOOGX0"}
		return(strings)
	end
	if num==2
		local strings = {"SGSPA0","SGSPB0","SGSPC0","SGSPD0","SGSPE0","SGSPF0","SGSPG0","SGSPH0","SGSPI0","SGSPJ0","SGSPK0","SGSPL0","SGSPM0","SGSPN0","SGSPO0","SGSPP0","SGSPQ0","SGSPR0","SGSPS0","SGSPT0","SGSPU0","SGSPV0","SGSPW0","SGSPX0"}
		return(strings)
	end
	if num==3
		local strings = {"SGSQA0","SGSQB0","SGSQC0","SGSQD0","SGSQE0","SGSQF0","SGSQG0","SGSQH0","SGSQI0","SGSQJ0","SGSQK0","SGSQL0","SGSQM0","SGSQN0","SGSQO0","SGSQP0","SGSQQ0","SGSQR0","SGSQS0","SGSQT0","SGSQU0","SGSQV0","SGSQW0","SGSQX0"}
		return(strings)
	end
	if num==4
		local strings = {"SGSRA0","SGSRB0","SGSRC0","SGSRD0","SGSRE0","SGSRF0","SGSRG0","SGSRH0","SGSRI0","SGSRJ0","SGSRK0","SGSRL0","SGSRM0","SGSRN0","SGSRO0","SGSRP0","SGSRQ0","SGSRR0","SGSRS0","SGSRT0","SGSRU0","SGSRV0","SGSRW0","SGSRX0"}
		return(strings)
	end
	if num==5
		local strings = {"SGSBA0","SGSBB0","SGSBC0","SGSBD0","SGSBE0","SGSBF0","SGSBG0","SGSBH0","SGSBI0","SGSBJ0","SGSBK0","SGSBL0","SGSBM0","SGSBN0","SGSBO0","SGSBP0","SGSBQ0","SGSBR0","SGSBS0","SGSBT0","SGSBU0","SGSBV0","SGSBW0","SGSBX0"}
		return(strings)
	end
	if num==6
		local strings = {"SGSZA0","SGSZB0","SGSZC0","SGSZD0","SGSZE0","SGSZF0","SGSZG0","SGSZH0","SGSZI0","SGSZJ0","SGSZK0","SGSZL0","SGSZM0","SGSZN0","SGSZO0","SGSZP0","SGSZQ0","SGSZR0","SGSZS0","SGSZT0","SGSZU0","SGSZV0","SGSZW0","SGSZX0"}
		return(strings)
	end
	if num==7
		local strings = {"DASH3A0","DASH3B0","DASH3C0","DASH3D0","DASH3E0","DASH3F0","DASH3G0","DASH3H0","DASH3I0","DASH3J0","DASH3K0","DASH3L0","DASH3M0","DASH3N0","DASH3O0","DASH3P0","DASH3Q0","DASH3R0","DASH3S0","DASH3T0","DASH3U0","DASH3V0","DASH3W0","DASH3X0"}
		return(strings)
	end
	if num==8
		local strings = {"DASH2A0","DASH2B0","DASH2C0","DASH2D0","DASH2E0","DASH2F0","DASH2G0","DASH2H0","DASH2I0","DASH2J0","DASH2K0","DASH2L0","DASH2M0","DASH2N0","DASH2O0","DASH2P0","DASH2Q0","DASH2R0","DASH2S0","DASH2T0","DASH2U0","DASH2V0","DASH2W0","DASH2X0"}
		return(strings)
	end
	if num==9
		local strings = {"DASH1A0","DASH1B0","DASH1C0","DASH1D0","DASH1E0","DASH1F0","DASH1G0","DASH1H0","DASH1I0","DASH1J0","DASH1K0","DASH1L0","DASH1M0","DASH1N0","DASH1O0","DASH1P0","DASH1Q0","DASH1R0","DASH1S0","DASH1T0","DASH1U0","DASH1V0","DASH1W0","DASH1X0"}
		return(strings)
	end
	if num==10
		local strings = {"BEAMA0","BEAMB0","BEAMC0","BEAMD0","BEAME0","BEAMF0","BEAMG0","BEAMH0","BEAMI0","BEAMJ0","BEAMK0","BEAML0","BEAMM0","BEAMN0","BEAMO0","BEAMP0","BEAMQ0","BEAMR0","BEAMS0","BEAMT0","BEAMU0","BEAMV0","BEAMW0","BEAMX0"}
		return(strings)
	end
	if num==11
		local strings = {"EGGROBO","EGGROBO","EGGROBO","EGGROBO","EGGROBO","EGGROBO","EGGROBO","EGGROBO","EGGROBO","EGGROBO","EGGROBO","EGGROBO","EGGROBO","EGGROBO","EGGROBO","EGGROBO","EGGROBO","EGGROBO","EGGROBO","EGGROBO","EGGROBO","EGGROBO","EGGROBO","EGGROBO"}
		return(strings)
	end
	if num==12
		local strings = {"BZKAA0","BZKAB0","BZKAC0","BZKAD0","BZKAE0","BZKAF0","BZKAG0","BZKAH0","BZKAI0","BZKAJ0","BZKAK0","BZKAL0","BZKAM0","BZKAN0","BZKAO0","BZKAP0","BZKAQ0","BZKAR0","BZKAS0","BZKAT0","BZKAU0","BZKAV0","BZKAW0","BZKAX0"}
		return(strings)
	end
	if num==13
		local strings = {"STABA0","STABB0","STABC0","STABD0","STABE0","STABF0","STABG0","STABH0","STABI0","STABJ0","STABK0","STABL0","STABM0","STABN0","STABO0","STABP0","STABQ0","STABR0","STABS0","STABT0","STABU0","STABV0","STABW0","STABX0"}
		return(strings)
	end
	if num==14
		local strings = {"STB2A0","STB2B0","STB2C0","STB2D0","STB2E0","STB2F0","STB2G0","STB2H0","STB2I0","STB2J0","STB2K0","STB2L0","STB2M0","STB2N0","STB2O0","STB2P0","STB2Q0","STB2R0","STB2S0","STB2T0","STB2U0","STB2V0","STB2W0","STB2X0"}
		return(strings)
	end
	if num==15
		local strings = {"SBOMA0"}
		return(strings)
	end
	if num==16
		local strings = {"SBOMB0"}
		return(strings)
	end
	if num==17
		local strings = {"SBOMC0"}
		return(strings)
	end
	if num==18
		local strings = {"SBOMD0"}
		return(strings)
	end
	if num==19
		local strings = {"SBOME0"}
		return(strings)
	end
	if num==20
		local strings = {"SBOMF0"}
		return(strings)
	end
	if num==21
		local strings = {"SBOMG0"}
		return(strings)
	end
	if num==22
		local strings = {"SNIDA0"}
		return(strings)
	end
	if num==23
		local strings = {"SNIDB0"}
		return(strings)
	end
	if num==24
		local strings = {"SNIDC0"}
		return(strings)
	end
	if num==25
		local strings = {"SNIDD0"}
		return(strings)
	end
	if num==26
		local strings = {"SNIDE0"}
		return(strings)
	end
	if num==27
		local strings = {"SJETA0","SJETB0","SJETC0","SJETD0","SJETE0","SJETF0","SJETG0","SJETH0","SJETI0","SJETJ0","SJETK0","SJETL0","SJETM0","SJETN0","SJETO0","SJETP0","SJETQ0","SJETR0","SJETS0","SJETT0","SJETU0","SJETV0","SJETW0","SJETX0"}
		return(strings)
	end
	if num==28
		local strings = {"FJETA0","FJETB0","FJETC0","FJETD0","FJETE0","FJETF0","FJETG0","FJETH0","FJETI0","FJETJ0","FJETK0","FJETL0","FJETM0","FJETN0","FJETO0","FJETP0","FJETQ0","FJETR0","FJETS0","FJETT0","FJETU0","FJETV0","FJETW0","FJETX0"}
		return(strings)
	end
	if num==29
		local strings = {"DMSAA0"}
		return(strings)
	end
	if num==30
		local strings = {"DMSBA0"}
		return(strings)
	end
	if num==31
		local strings = {"DMSCA0"}
		return(strings)
	end
	if num==32
		local strings = {"HBM1A0","HBM1B0","HBM1C0","HBM1D0","HBM1E0","HBM1F0","HBM1G0","HBM1H0","HBM1I0","HBM1J0","HBM1K0","HBM1L0","HBM1M0","HBM1N0","HBM1O0","HBM1P0","HBM1Q0","HBM1R0","HBM1S0","HBM1T0","HBM1U0","HBM1V0","HBM1W0","HBM1X0"}
		return(strings)
	end
	if num==33
		local strings = {"HBM2A0","HBM2B0","HBM2C0","HBM2D0","HBM2E0","HBM2F0","HBM2G0","HBM2H0","HBM2I0","HBM2J0","HBM2K0","HBM2L0","HBM2M0","HBM2N0","HBM2O0","HBM2P0","HBM2Q0","HBM2R0","HBM2S0","HBM2T0","HBM2U0","HBM2V0","HBM2W0","HBM2X0"}
		return(strings)
	end
	if num==34
		local strings = {"SMSLA0","SMSLB0","SMSLC0","SMSLD0","SMSLE0","SMSLF0","SMSLG0","SMSLH0","SMSLI0","SMSLJ0","SMSLK0","SMSLL0","SMSLM0","SMSLN0","SMSLO0","SMSLP0","SMSLQ0","SMSLR0","SMSLS0","SMSLT0","SMSLU0","SMSLV0","SMSLW0","SMSLX0"}
		return(strings)
	end
	if num==35
		local strings = {"SRLSA0","SRLSB0","SRLSC0","SRLSD0","SRLSE0","SRLSF0","SRLSG0","SRLSH0","SRLSI0","SRLSJ0","SRLSK0","SRLSL0","SRLSM0","SRLSN0","SRLSO0","SRLSP0","SRLSQ0","SRLSR0","SRLSS0","SRLST0","SRLSU0","SRLSV0","SRLSW0","SRLSX0"}
		return(strings)
	end
	if num==36
		local strings = {"RESPA0","RESPA0","RESPA0","RESPA0","RESPA0","RESPA0","RESPA0","RESPA0","RESPA0","RESPA0","RESPA0","RESPA0","RESPA0","RESPA0","RESPA0","RESPA0","RESPA0","RESPA0","RESPA0","RESPA0","RESPA0","RESPA0","RESPA0","RESPA0"}
		return(strings)
	end
end

local function getspriterot(obj,v) //get the sprite rotation
	local spritearray = getbularray(obj.image) //get sprite array
	local rotnum
	rotnum = FixedDiv(max((obj.direction*FRACUNIT)+(23*FRACUNIT),0),360*FRACUNIT)
	rotnum = FixedMul(rotnum,24*FRACUNIT)/FRACUNIT
	if rotnum>24
		rotnum = 24
	end
	return(v.cachePatch(spritearray[max(rotnum,1)]))
	//return(v.cachePatch(spritearray[1]))
end

local function bulletdraw(v) //draw bullets~
	local buls = server.soniguri.enemybuls //ease-of-access
	local pbuls = server.soniguri.playerbuls
	local i = 1
	while (buls[i] ~= nil) //iterate through all bullets
		if buls[i] ~= -1 //don't run bullets waiting their turn to be replaced
			//v.draw(buls[i].x/HALFUNIT,buls[i].y/HALFUNIT,getspriterot(buls[i],v),V_SMALLSCALEPATCH|buls[i].flags) //draw with the right rotation
			v.drawScaled(buls[i].x,buls[i].y,FRACUNIT/2,getspriterot(buls[i],v),buls[i].flags)
		end
		i = i + 1
	end
	i = 1
	while (pbuls[i] ~= nil) //iterate through player bullets
		if pbuls[i] ~= -1 //dont run bullets waiting their turn to be replaced
			//v.draw(pbuls[i].x/HALFUNIT,pbuls[i].y/HALFUNIT,getspriterot(pbuls[i],v),V_SMALLSCALEPATCH|pbuls[i].flags) //draw with the right rotation
			v.drawScaled(pbuls[i].x,pbuls[i].y,FRACUNIT/2,getspriterot(pbuls[i],v),pbuls[i].flags)
		end
		i = i + 1
	end
end

local function enemydraw(v) //draw enemies~
	local enms = server.soniguri.enemies //ease-of-access
	local i = 1
	while (enms[i] ~= nil)
		if enms[i] ~= -1
			//v.draw(enms[i].x/HALFUNIT,enms[i].y/HALFUNIT,getspriterot(enms[i],v),V_SMALLSCALEPATCH|enms[i].flags)
			v.drawScaled(enms[i].x,enms[i].y,FRACUNIT/2,getspriterot(enms[i],v),enms[i].flags)
		end
		i = i + 1
	end
end

local function ringsdraw(v) //draw dash rings~
	local enms = server.soniguri.dashrings //ease-of-access
	local i = 1
	while (enms[i] ~= nil)
		if enms[i] ~= -1
			//v.draw(enms[i].x/HALFUNIT,enms[i].y/HALFUNIT,getspriterot(enms[i],v),V_SMALLSCALEPATCH|enms[i].flags)
			v.drawScaled(enms[i].x,enms[i].y,FRACUNIT/2,getspriterot(enms[i],v),enms[i].flags)
		end
		i = i + 1
	end
end


local function soniguridraw(v, player, camera)
	if not (server and server.valid) return end // Salt: Demos don't like server
	if ((splitscreen) and (player == players[0])) return end // Salt: I'm turning off player 1's display instead of player 2's in splitscreen, because ez

	//local soogsspritearray = {v.cachePatch("SOOGA0")}
	if player.soogsobject ~= nil and server.soniguri ~= nil and server.soniguri.valid
		enemydraw(v) //draw enemies
		bulletdraw(v) //draw bullets
		ringsdraw(v)
	end
	if server.soniguri ~= nil and server.soniguri.valid
		if server.soniguri.slide < 10 //how to play
			local slidearray = {"SNGTITLE","HTP1","HTP2","HTP3","HTP4","HTP5","HTP6","HTP7","HTP8","HTP9"}
			v.draw(0,0,v.cachePatch(slidearray[server.soniguri.slide+1]))
		end
	end
	if server.soniguri ~= nil and server.soniguri.valid
		for p in players.iterate
			if p.soogsobject ~= nil
				local sogs = p.soogsobject
				//v.draw(sogs.x/HALFUNIT, sogs.y/HALFUNIT, getspriterot(sogs,v),V_SMALLSCALEPATCH,v.getColormap(0,p.skincolor))
				v.drawScaled(sogs.x,sogs.y,FRACUNIT/2,getspriterot(sogs,v),0,v.getColormap(0,p.skincolor))

				//v.drawNum(50,50,sogs.x/HALFUNIT)
				//v.drawNum(50,70,sogs.y/HALFUNIT)
				//v.drawFill(server.drawshit[1]+100,server.drawshit[3]+100,1,1)//server.drawshit[2]*-1,server.drawshit[4]*-1)
				//v.drawFill(server.drawshit[1]+100,server.drawshit[4]+100,1,1)
				//v.drawFill(server.drawshit[2]+100,server.drawshit[3]+100,1,1)
				//v.drawFill(server.drawshit[2]+100,server.drawshit[4]+100,1,1)
				//v.drawFill(server.drawshit2[1]+100,server.drawshit2[2]+100,1,1,4)
				//v.drawFill(server.drawshit2[3]+100,server.drawshit2[4]+100,1,1,3)
				//v.drawFill(server.drawshit2[5]+100,server.drawshit2[6]+100,1,1,2)
				//v.drawFill(server.drawshit2[7]+100,server.drawshit2[8]+100,1,1)
			end
		end
	end
	if player.soogsobject ~= nil and server.soniguri ~= nil and server.soniguri.valid
		//enemydraw(v) //draw enemies
		//bulletdraw(v) //draw bullets
		if server.soniguri.enemies[player.soogsobject.enemy] ~= nil and server.soniguri.enemies[player.soogsobject.enemy] ~= -1
			//v.draw(server.soniguri.enemies[player.soogsobject.enemy].x/HALFUNIT,server.soniguri.enemies[player.soogsobject.enemy].y/HALFUNIT,v.cachePatch("SOOGCSHR"),V_SMALLSCALEPATCH,v.getColormap(0,player.skincolor))
			v.drawScaled(server.soniguri.enemies[player.soogsobject.enemy].x,server.soniguri.enemies[player.soogsobject.enemy].y,FRACUNIT/2,v.cachePatch("SOOGCSHR"),0,v.getColormap(0,player.skincolor))
		end

		if server.soniguri.drawbosshud == true //draw boss hp bar
			if server.soniguri.bosshp >= 4000
				v.drawFill(200,8,110,16,113)
				v.drawFill(200,8,FixedMul(FixedDiv((server.soniguri.bosshp-4000)*FRACUNIT,2000*FRACUNIT),110),16,73)
			end
			if server.soniguri.bosshp >= 2000 and server.soniguri.bosshp < 4000
				v.drawFill(200,8,110,16,152)
				v.drawFill(200,8,FixedMul(FixedDiv((server.soniguri.bosshp-2000)*FRACUNIT,2000*FRACUNIT),110),16,113)
			end
			if server.soniguri.bosshp < 2000
				v.drawFill(200,8,110,16,31)
				v.drawFill(200,8,FixedMul(FixedDiv((server.soniguri.bosshp)*FRACUNIT,2000*FRACUNIT),110),16,152)
			end
		end

		 //HUD (by root)
		//Hyper bar
		local dhypercol = 0
		local dhypernum = (player.soogsobject.special / 100)
		local dhyperbgc = 0
		local dhyperbfc
		if (dhypernum == 0)
			dhyperbgc = 31
			dhyperbfc = 152
		end
		if (dhypernum == 1)
			dhyperbgc = 152
			dhyperbfc = 113
		end
		if (dhypernum == 2)
			dhyperbgc = 113
			dhyperbfc = 73
		end
		if (dhypernum == 3)
			dhyperbgc = 73
			dhyperbfc = 73
		end
		local dhyperbh = ((player.soogsobject.special / 2) % 50)

		v.drawFill(8, 8, 16, 50, dhyperbgc)
		v.drawFill(8, 58-dhyperbh, 16, dhyperbh, dhyperbfc)
		if (splitscreen)
			v.drawString(18, 28, dhypernum, 0, "thin")
		else
			v.drawNum(20, 28, dhypernum)
		end
		//-------------------------
		//Heat
		//create number string
		local dheatstr = ""
		if (player.soogsobject.heat < 100)
			if (player.soogsobject.heat < 10)
				dheatstr = "00"..tostring(player.soogsobject.heat)
			else
				dheatstr = "0"..tostring(player.soogsobject.heat)
			end

		else
			dheatstr = tostring(player.soogsobject.heat)
		end
		//get color to draw it at
		local dheatcol = 0
		if (player.soogsobject.heat >= 100)
			dheatcol = V_REDMAP
		end
		if (player.soogsobject.heat >= 200)
			dheatcol = V_ORANGEMAP
		end

		//draw it!
		if (splitscreen)
			v.drawString(32, 58, "P2 Heat:"..dheatstr.."%", dheatcol)
		else
			v.drawString(32, 50, "Heat:"..dheatstr.."%", dheatcol)
		end
		//------------------------
		//HP
		v.drawFill(32, 32, 100, 16, 31)
		v.drawFill(32, 32, player.soogsobject.hp / (FRACUNIT / 100), 16, 152)

		if (splitscreen) // Salt: Share some of the love, will ya Player 2~?
			local p1 = players[0]


			if server.soniguri.enemies[p1.soogsobject.enemy] ~= nil and server.soniguri.enemies[p1.soogsobject.enemy] ~= -1
				//v.draw(server.soniguri.enemies[p1.soogsobject.enemy].x/HALFUNIT,server.soniguri.enemies[p1.soogsobject.enemy].y/HALFUNIT,v.cachePatch("SOOGCSHR"),V_SMALLSCALEPATCH,v.getColormap(0,p1.skincolor))
				v.drawScaled(server.soniguri.enemies[p1.soogsobject.enemy].x,server.soniguri.enemies[p1.soogsobject.enemy].y,FRACUNIT/2,v.cachePatch("SOOGCSHR"),0,v.getColormap(0,p1.skincolor))
			end

			//Hyper bar
			local p1dhypercol = 0
			local p1dhypernum = (p1.soogsobject.special / 100)
			local p1dhyperbgc = 0
			local p1dhyperbfc
			if (p1dhypernum == 0)
				p1dhyperbgc = 31
				p1dhyperbfc = 152
			end
			if (p1dhypernum == 1)
				p1dhyperbgc = 152
				p1dhyperbfc = 113
			end
			if (p1dhypernum == 2)
				p1dhyperbgc = 113
				p1dhyperbfc = 73
			end
			if (p1dhypernum == 3)
				p1dhyperbgc = 73
				p1dhyperbfc = 73
			end
			local p1dhyperbh = ((p1.soogsobject.special / 2) % 50)

			v.drawFill(8, 8, 8, 50, p1dhyperbgc)
			v.drawFill(8, 58-p1dhyperbh, 8, p1dhyperbh, p1dhyperbfc)
			v.drawString(10, 28, p1dhypernum, 0, "thin")
			//-------------------------
			//Heat
			//create number string
			local p1dheatstr = ""
			if (p1.soogsobject.heat < 100)
				if (p1.soogsobject.heat < 10)
					p1dheatstr = "00"..tostring(p1.soogsobject.heat)
				else
					p1dheatstr = "0"..tostring(p1.soogsobject.heat)
				end

			else
				p1dheatstr = tostring(p1.soogsobject.heat)
			end
			//get color to draw it at
			local p1dheatcol = 0
			if (p1.soogsobject.heat >= 100)
				p1dheatcol = V_REDMAP
			end
			if (p1.soogsobject.heat >= 200)
				p1dheatcol = V_ORANGEMAP
			end
			//draw it!
			v.drawString(32, 50, "P1 Heat:"..p1dheatstr.."%", p1dheatcol)
			//------------------------
			//HP
			v.drawFill(32, 32, 100, 8, 31)
			v.drawFill(32, 32, p1.soogsobject.hp / (FRACUNIT / 100), 8, 232)

			// rest of the splitscreen separators
			v.drawFill(32, 40, 100, 1, 31) // hyper dividor line
			v.drawFill(16, 8, 1, 50, 31) // health dividor line

			v.drawString(4, 8, "P1", 0, "thin") // hyper p1
			v.drawString(18, 8, "P2", 0, "thin") // hyper p2

			v.drawString(32, 32, "P1", 0, "thin") // health p1
			v.drawString(32, 40, "P2", 0, "thin") // health p2
		end
	end
end

hud.add(soniguridraw,"game")