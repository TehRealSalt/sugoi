local msgdef = {
     [1] = "This is the end of your adventure.",
     [2] = "Congratulations! You can relax.",

     [3] = "But... is this really the end?",

     [4] = "You beat Eggman again, yet won't he come back?",
     [5] = "Won't the anomaly form even more worlds you must conquer?",
     [6] = "It has happened every year, like clockwork...",
     [7] = "Your progress is undone every time.",

     [8] = "Do you remember what causes this anomaly?",
     [9] = "Who the true antagonist of SUGOI itself is...?",

    [10] = "Eggman removed me from my host, but he failed to destroy me.",
    [11] = "I now seek another body to control...",

    [12] = "You must be strong to have made it this far...",
    [13] = "PERHAPS I WILL TAKE YOURS!"
}

local sonicmsgs = {
    [10] = "Eggman removed me from you, but he failed to destroy me.",
    [11] = "I miss you, you know.",

    [12] = "You were a fine host - such a nimble, astute physique...",
    [13] = "PERHAPS I WILL TAKE IT BACK!"
}

local queue
local onscreenmsgs
local newmsgdelay
local MAXMSG = 7

local function clearmsg()
	queue = nil
	onscreenmsgs = nil
	newmsgdelay = nil
end

addHook("MapChange", clearmsg)

addHook("ThinkFrame", function()
	if (queue == nil)
		return
	end

	for i=1,MAXMSG
		if (onscreenmsgs[i][1] != nil)
			local len = #(msgdef[onscreenmsgs[i][1]])
			if (onscreenmsgs[i][2] > 320+(8*len))
				onscreenmsgs[i][1] = nil
				onscreenmsgs[i][2] = 0
			else
				onscreenmsgs[i][2] = $1+1
			end
		elseif (newmsgdelay <= 0)
			if (queue[1] != nil)
				local len = #(msgdef[queue[1]])
				onscreenmsgs[i][1] = queue[1]
				onscreenmsgs[i][2] = 0
				newmsgdelay = TICRATE+(4*len)
				table.remove(queue, 1)
			end
		end
	end

	if (newmsgdelay > 0)
		newmsgdelay = $1-1
	end
end)

addHook("LinedefExecute", function(line, mo, sec)
	local first = abs(line.frontside.textureoffset) >> FRACBITS
	local last = abs(line.frontside.rowoffset) >> FRACBITS

	if (last == 0)
		if (first == 0)
			-- 0,0 clears all onscreen messages
			clearmsg()
			return
		else
			-- Just display the one message
			last = first
		end
	end

	for id = first,last
		if not (msgdef[id])
			print("BAD MESSAGE ID!")
			return
		end

		if (queue == nil)
			queue = {}
			onscreenmsgs = {}
			newmsgdelay = 0

			for i=1,MAXMSG
				onscreenmsgs[i] = {nil,0}
			end
		end

		table.insert(queue, id)
	end
end, "SOAESMSG")

hud.add(function(v, player)
	if (queue == nil)
		return
	end

	for i=1,MAXMSG
		if (onscreenmsgs[i][1] != nil)
			local str = msgdef[onscreenmsgs[i][1]]

			if ((player and player.valid) and (player.mo and player.mo.valid))
			and (player.mo.skin == "sonic" and not multiplayer)
			and (sonicmsgs[onscreenmsgs[i][1]] != nil)
				str = sonicmsgs[onscreenmsgs[i][1]]
			end

			local flags = V_50TRANS|V_ALLOWLOWERCASE
			local length = v.stringWidth(str, flags, "normal")

			v.drawString(
				320 - (onscreenmsgs[i][2] << 1),
				64 + (16 * (i-1)),
				str, flags|V_SNAPTORIGHT, "left"
			)
		end
	end
end)
