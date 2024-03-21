-- global definitions for glacier glaze

-- namespace for vars, constants, etc
rawset(_G, "glacierglaze", {})

-- constants
glacierglaze.debug = false

-- frost thrower related
glacierglaze.FrostthrowerMomentum = -28*FRACUNIT
glacierglaze.FrostthrowerShakeTime = TICRATE/2
glacierglaze.FrostthrowerShakeMaxRange = 5	-- assume it always starts at 1
glacierglaze.FrozenScale = FRACUNIT*6/5
glacierglaze.FrozenShakeTics = 9
glacierglaze.FrozenDamageMomentumThreshold = 28*FRACUNIT
glacierglaze.FrozenDamageZMomentumThreshold = -24*FRACUNIT
glacierglaze.FrozenProtectionTics = TICRATE*5/4
glacierglaze.FrozenProjectLifetime = 5*TICRATE

-- s2 bubble related
glacierglaze.BubblePatchDistance = 2048*FRACUNIT
glacierglaze.BubblePatchSpawnTics = 5*TICRATE
glacierglaze.BubblePatchScaleModifier = FRACUNIT*7/4
glacierglaze.BubbleScaleModifier = FRACUNIT*4/3
glacierglaze.BubbleSpinThreshold = FRACUNIT*5/4
glacierglaze.BubbleBounceTics = TICRATE/2

-- slowdown related
glacierglaze.SlowdownTics = 5*TICRATE	-- how long we should be frozen for
glacierglaze.SlowdownAddTics = 15	-- how fast we slow down
glacierglaze.SlowdownRemoveTics = 3	-- how fast we speed back up
glacierglaze.SlowdownModifier = FRACUNIT*6/9	-- how much we slow down BY
glacierglaze.SlowdownFields = {"normalspeed", "actionspd", "maxdash"}	-- what to affect with the modifier

-- underwater drowning related
glacierglaze.UnderwaterRemoveTics = 2	-- controls how much faster we drown underwater

-- badnik related
glacierglaze.FrostSkimThreshold = 16*FRACUNIT
glacierglaze.FrostSkimPatience = 4*TICRATE
glacierglaze.FrostSkimPatienceRandint = TICRATE/2
glacierglaze.FrostSkimFreezeRecoil = 2*TICRATE
glacierglaze.FrostSkimFireWait = TICRATE
glacierglaze.IceskaterCrawlaRevTics = 20
glacierglaze.IceskaterCrawlaChaseIntervals = 3*TICRATE
glacierglaze.IceskaterCrawlaSpinTics = TICRATE/2
glacierglaze.IceskaterCrawlaSpeedThreshold = FRACUNIT*5/2
glacierglaze.IceskaterCrawlaPinchMultiplier = FRACUNIT*3/2

-- SOUNDS
local sounds = {
	{sound = "sfx_glgz1", caption = "Partially frozen"},
	{sound = "sfx_glgz2", caption = "Ice shattered"},
	{sound = "sfx_glgz3", caption = "Bubble grab"},
	{sound = "sfx_glgz4", caption = "Bubble pop"},
}
for k, v in pairs(sounds)
	freeslot(v.sound)
	sfxinfo[_G[v.sound]].caption = v.caption
end

-- general protection function
-- 0 = no protection
-- 1 = normal protection
-- 2 = heat source
glacierglaze.IsPlayerProtected = function(p)
	-- heat source protection
	local shield = (p.powers[pw_shield] & SH_NOSTACK)
	if (shield & SH_PROTECTFIRE)
	or (P_PlayerFullbright(p))
		return 2
	end
	
	-- normal protection
	if (p.powers[pw_invulnerability])
	or (shield)
	or glacierglaze.InBubble(p)
		return 1
	end
	
	-- we have no protection
	return 0
end

-- angtoint
glacierglaze.AngToInt = function(a)
	if not a return 0 end
	a = $/ANG1
	if a < 0
		a = $+360
	end
	return a
end