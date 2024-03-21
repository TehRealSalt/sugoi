-- Cloud Bounce Script

-- Lua help from Tatsuru, Lach and Lactozilla

local function cloudBounce(line, mo)
   local player = mo.player
		if (mo.momz < 0) then
			mo.momz = (mo.momz * -1)
			player.bounced = true
			-- print ("BOUNCE!")
    end
end
addHook("LinedefExecute", cloudBounce, "CLDBOUNC")

addHook("PlayerThink", function(player)
  if player.mo and player.mo.valid
    if player.bounced
      player.mo.state = S_PLAY_SPRING
	  P_ResetPlayer(player)
		if player.charflags & SF_MULTIABILITY
			player.pflags = $ | PF_NOJUMPDAMAGE|PF_THOKKED -- Breaks with Knuckles
		else
			player.pflags = $ | PF_JUMPED|PF_NOJUMPDAMAGE|PF_THOKKED -- Breaks with Metal Sonic
		end
      player.bounced = false
      S_StartSound(player.mo, sfx_s3k87)
    end
  end
end)

-- Hidden Museum Scripts

-- Lua help from ampersand/Rapidgame7

-- Congratulations!
-- You found the hidden museum!
-- Here, you can take a look behind
-- the scenes and check out some old,
-- scrapped and unfinished areas!

local function floorCecho01(line, mobj, sector)
    if mobj and mobj.valid and mobj.player then
	    COM_BufInsertText(mobj.player, "cechoduration 1")
        COM_BufInsertText(mobj.player, "cecho \\\\\\\\\\\\\\\\\\\\\\\\Congratulations!\\You found the hidden museum!\\Here, you can take a look behind\\the scenes and check out some old,\\scrapped and unfinished areas!")
    end
end
addHook("LinedefExecute", floorCecho01, "PPZMSG1")

-- This room was originally supposed to be
-- in the indoors area after the first checkpoint,
-- but it was scrapped because it was hard to find
-- a proper place to fit it in.

local function floorCecho02(line, mobj, sector)
    if mobj and mobj.valid and mobj.player then
	    COM_BufInsertText(mobj.player, "cechoduration 1")
        COM_BufInsertText(mobj.player, "cecho \\\\\\\\\\\\\\\\\\\\\\\\\\This room was originally supposed to be\\in the indoors area after the first checkpoint,\\but it was scrapped because it was hard to find\\a proper place to fit it in.")
    end
end
addHook("LinedefExecute", floorCecho02, "PPZMSG2")

-- This room was used for testing purposes.
-- Here you can see some WIP texturing ideas,
-- a place to test out the cloud bouncing,
-- and even a scrapped golden water idea,
-- among other things.

local function floorCecho03(line, mobj, sector)
    if mobj and mobj.valid and mobj.player then
	    COM_BufInsertText(mobj.player, "cechoduration 1")
        COM_BufInsertText(mobj.player, "cecho \\\\\\\\\\\\\\\\\\\\\\\\This room was used for testing purposes.\\Here you can see some WIP texturing ideas,\\a place to test out the cloud bouncing,\\and even a scrapped golden water idea,\\among other things.")
    end
end
addHook("LinedefExecute", floorCecho03, "PPZMSG3")

-- This teleporter will take you to the skybox.
-- When you want to teleport back, just go to the edge.
-- Have fun messing with other players!

local function floorCecho04(line, mobj, sector)
    if mobj and mobj.valid and mobj.player then
	    COM_BufInsertText(mobj.player, "cechoduration 1")
        COM_BufInsertText(mobj.player, "cecho \\\\\\\\\\\\\\\\\\\\\\\\\\\\This teleporter will take you to the skybox.\\When you want to come back, just go to the edge.\\Have fun messing with other players!")
    end
end
addHook("LinedefExecute", floorCecho04, "PPZMSG4")

