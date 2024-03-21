--Custom camera autorun initialization.
local function strafeon(line,mo)
	local x = mo.x
	local y = mo.y - 892*FRACUNIT
	local z = 192*FRACUNIT

	if not (mo.player.awayviewmobj and mo.player.awayviewmobj.valid)
		mo.player.awayviewmobj = P_SpawnMobj(x, y, z, MT_THOK)
	else
		P_MoveOrigin(mo.player.awayviewmobj, x, y, z)
	end

	local altcam = mo.player.awayviewmobj

	altcam.angle = ANGLE_90
	altcam.tics = 2
	altcam.flags2 = $1|MF2_DONTDRAW
	altcam.flags = $1|MF_NOGRAVITY

	mo.player.awayviewtics = 2
	mo.player.doautorun = true
end

--Forces player angle and running during autorun. Disables mouse turning.
addHook("PreThinkFrame",function()
	for p in players.iterate
		if p.doautorun == true
			p.cmd.forwardmove = 50
			p.drawangle = ANGLE_90
			p.angle = ANGLE_90
			p.skidtime = 0
			p.pflags = $1|PF_FORCESTRAFE
			p.cmd.angleturn = p.angle >> 16
			p.cmd.aiming = 0
			p.doautorun = false
		end
	end
end)

local function strafeoff(line,mo)
	if (mo.player.pflags & PF_FORCESTRAFE)
		mo.player.pflags = $1 & ~PF_FORCESTRAFE
		mo.player.doautorun = false
	end
end

addHook("LinedefExecute", strafeon, "FORCECAM")
addHook("LinedefExecute", strafeoff, "STPCAM")
