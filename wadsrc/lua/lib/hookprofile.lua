// Hook profiler by LJ Sonic
// Adjusted by TehRealSalt

local cv_hookprofiler = CV_RegisterVar({
	name = "profile_hooks",
	defaultvalue = "Off",
	PossibleValue = CV_OnOff
});

local CUMULATION_PERIOD = TICRATE
local REPORT_THRESHOLD = 10


local hookInfo = {}


local function wrapper(callback, hookIndex)
    return function(...)
        local startTime = getTimeMicros()
        callback(...)
        hookInfo[hookIndex].cumulatedTime = $ + getTimeMicros() - startTime
    end
end

local function profile_print(str)
	if cv_hookprofiler.value then
		print(str)
	end
end

addHook("ThinkFrame", function()
	if not cv_hookprofiler.value then return end
    if leveltime % CUMULATION_PERIOD ~= 0 then return end

    profile_print("[PROFILE] Cumulated hook times {")

    for i, info in ipairs(hookInfo) do
        if info.cumulatedTime >= REPORT_THRESHOLD then
            profile_print(("    Hook #%d: %d.%03dms"):format(
                i,
                info.cumulatedTime / 1000,
                info.cumulatedTime % 1000)
            )
        end

        info.cumulatedTime = 0
    end

    profile_print("}")
end)

local vanillaAddHook = addHook

rawset(_G, "addHook", function(name, callback, arg)
    if name == "MobjThinker"
	or name == "ThinkFrame"
	or name == "PreThinkFrame"
	or name == "PostThinkFrame"
	or name == "PlayerThink" then
        local hookIndex = #hookInfo + 1

        table.insert(hookInfo, { cumulatedTime = 0 })
        print("Added " .. name .. " hook #" .. hookIndex)

        -- if hookIndex == 1 or hookIndex == 4 then return end
        vanillaAddHook(name, wrapper(callback, hookIndex), arg)
    else
        vanillaAddHook(name, callback, arg)
    end
end)
