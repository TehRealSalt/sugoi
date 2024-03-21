-- run hooks
addHook("ThinkFrame", do
	for p in players.iterate
		local mo = p.mo
		if not (mo and mo.valid) then
			return
		end

		mo.ggz = $ or {}
		-- ^ init the table for stuff

		-- jump button handling, we'll be using this for 2 gimmicks
		mo.ggz.jump = $ or 0	-- init this
		mo.ggz.jump = (p.cmd.buttons & BT_JUMP) and $+1 or 0

		-- functions
		glacierglaze.FrozenState(p)
		glacierglaze.S2Bubble(p)
		glacierglaze.WaterSlowdown(p)
		glacierglaze.Drowning(p)
	end
end)

-- damage functions
local function ggz_damageFunc(mo, inflictor, source)
	glacierglaze.FrozenDamage(mo, inflictor, source)
	glacierglaze.BubbleDamage(mo, inflictor, source)
end
addHook("MobjDamage", ggz_damageFunc, MT_PLAYER)
addHook("MobjDeath", ggz_damageFunc, MT_PLAYER)

-- collide functions
local function ggz_collideFunc(mo, mo2)
	-- frozen function
	if (glacierglaze.FrozenCollide(mo, mo2) != nil)
		return glacierglaze.FrozenCollide(mo, mo2)
	end

	-- bubble function
	if (glacierglaze.BubbleCollide(mo, mo2) != nil)
		return glacierglaze.BubbleCollide(mo, mo2)
	end
end
addHook("MobjCollide", ggz_collideFunc, MT_PLAYER)
addHook("MobjMoveCollide", ggz_collideFunc, MT_PLAYER)

-- make players fall into the stage in their hurt frames
addHook("PlayerSpawn", function(p)
	if not (mapheaderinfo[gamemap].glacierglaze) then return end
	local mo = p.mo

	if not (p.starpostnum)
	and not (P_IsObjectOnGround(mo))
		then mo.state = S_PLAY_PAIN
	end
end)

-- wall collision hook (hooklib)
hookLib.AddHook("PlayerLineCollide", function(p, line, side)
	glacierglaze.FrozenWallCollide(p, line, side)
	glacierglaze.BubbleWallCollide(p, line, side)
end)