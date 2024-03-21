// --------------------------------------
// LUA_DTHB
// Death ball object
// --------------------------------------
local maxtime = (TICRATE*4/6)

local frames = {}
frames[0] = {}
frames[0].rotatenum = 1
frames[0].frames = {}
frames[0].frames[0] = "DTHHEXR1"
frames[1] = {}
frames[1].rotatenum = 1
frames[1].frames = {}
frames[1].frames[0] = "DTHHEXR2"
frames[2] = {}
frames[2].rotatenum = 1
frames[2].frames = {}
frames[2].frames[0] = "DTHHEXR3"
frames[3] = {}
frames[3].rotatenum = 1
frames[3].frames = {}
frames[3].frames[0] = "DTHHEXR4"
frames[4] = {}
frames[4].rotatenum = 1
frames[4].frames = {}
frames[4].frames[0] = "DTHHEXG1"
frames[5] = {}
frames[5].rotatenum = 1
frames[5].frames = {}
frames[5].frames[0] = "DTHHEXG2"
frames[6] = {}
frames[6].rotatenum = 1
frames[6].frames = {}
frames[6].frames[0] = "DTHHEXG3"
frames[7] = {}
frames[7].rotatenum = 1
frames[7].frames = {}
frames[7].frames[0] = "DTHHEXG4"
frames[8] = {}
frames[8].rotatenum = 1
frames[8].frames = {}
frames[8].frames[0] = "DTHHEXB1"
frames[9] = {}
frames[9].rotatenum = 1
frames[9].frames = {}
frames[9].frames[0] = "DTHHEXB2"
frames[10] = {}
frames[10].rotatenum = 1
frames[10].frames = {}
frames[10].frames[0] = "DTHHEXB3"
frames[11] = {}
frames[11].rotatenum = 1
frames[11].frames = {}
frames[11].frames[0] = "DTHHEXB4"

local animations = {}
animations[0] = {}
animations[0].speed = 0
animations[0].numframes = 4
animations[0].nextanim = 0
animations[0].frames = {}
animations[0].frames[0] = AOS_AddFrame(frames[0])
animations[0].frames[1] = AOS_AddFrame(frames[1])
animations[0].frames[2] = AOS_AddFrame(frames[2])
animations[0].frames[3] = AOS_AddFrame(frames[3])
animations[1] = {}
animations[1].speed = 0
animations[1].numframes = 4
animations[1].nextanim = 0
animations[1].frames = {}
animations[1].frames[0] = AOS_AddFrame(frames[4])
animations[1].frames[1] = AOS_AddFrame(frames[5])
animations[1].frames[2] = AOS_AddFrame(frames[6])
animations[1].frames[3] = AOS_AddFrame(frames[7])
animations[2] = {}
animations[2].speed = 0
animations[2].numframes = 4
animations[2].nextanim = 0
animations[2].frames = {}
animations[2].frames[0] = AOS_AddFrame(frames[8])
animations[2].frames[1] = AOS_AddFrame(frames[9])
animations[2].frames[2] = AOS_AddFrame(frames[10])
animations[2].frames[3] = AOS_AddFrame(frames[11])

animations[0].nextanim = AOS_AddAnim(animations[0])
animations[1].nextanim = AOS_AddAnim(animations[1])
animations[2].nextanim = AOS_AddAnim(animations[2])

local object = {}
object.thinker = function(player, objectnum)
	local object = player.aosobjects[objectnum]
	object.scale = FRACUNIT*5
	
	if(object.alttimer == 1)
		setAnim(object, animations[1].nextanim)
	elseif(object.alttimer == 2)
		setAnim(object, animations[2].nextanim)
	else
		setAnim(object, animations[0].nextanim)
	end
	
	object.timer = $1 + 1
	
	local trans = maxtime-object.timer
	if(trans > 0)
		trans = 10-trans
		if(trans < 3)
			trans = 3
		end
		object.drawflags = trans*V_10TRANS
	end
	
	if(object.timer > maxtime)
		removeAOSObject(player, objectnum)
		return
	end
end

AOS_AddObject(object)
