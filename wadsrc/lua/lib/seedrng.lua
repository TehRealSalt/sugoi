/* SeedRng r2 library for SRB2 by FSX/tertu
 * The main generator is based on
 * xoroshiro128+ (http://xoroshiro.di.unimi.it/xoroshiro128plus.c) by David
 * Blackman and Sebastiano Vigna, but is not exactly the same and probably isn't
 * as good.
 * The seed extender is xorshift32 by George Marsaglia.
 *
 * To the extent possible under law, the author has dedicated all copyright
 * and related and neighboring rights to this software to the public domain
 * worldwide. This software is distributed without any warranty.
 */

//the algorithm assumes we have uint64s. we don't, so we have to play pretend.
local function i64_xor(a1, a2, b1, b2)
	return a1^^b1, a2^^b2
end

local function i64_shift_left(a1, a2, count)
	if count > 31 then
		return a2 << count-32, 0
	else
		return (a1 << count)|(a2 >> (32-count)), a2 << count
	end
end

local function i64_shift_right(a1, a2, count)
	if count > 31 then
		return 0, a1 >> count-32
	else
		return a1 >> count, (a2 >> count)|(a1 << (32-count))
	end
end

local function i64_or(a1, a2, b1, b2)
	return a1 | b1, a2 | b2
end

//not used anymore but if you want the code it's here.
local function i64_rotate_left_old(a1, a2, count)
	local res_a1, res_a2 = i64_shift_left(a1, a2, count)
	local res_b1, res_b2 = i64_shift_right(a1, a2, 64-count)
	return i64_or(res_a1, res_a2, res_b1, res_b2)
end

//works for any value up to 64, i'm pretty sure, but might fail above that
local function i64_rotate_left(a1, a2, count)
	if count == 0 or count == 64 then
		return a1, a2
	elseif count == 32 then
		return a2, a1
	elseif count > 32 then
		a1, a2 = a2, a1
		count = count - 32
	end
	return (a1<<count | a2>>(32-count)),(a2<<count | a1>>(32-count))
end

//this function advances the internal generator state. the people who developed
//it are people with doctorates in mathematics and i am yet to even have a
//bachelor's degree in anything at all, so i'll take their word for it
local function xoroshiro128_step(state)
	local a1, a2, b1, b2 = unpack(state)
	b1, b2 = i64_xor(a1, a2, b1, b2)
	local c1, c2 = i64_shift_left(b1, b2, 14)
	c1, c2 = i64_xor(b1, b2, c1, c2)
	local d1, d2 = i64_rotate_left(a1, a2, 55)
	state[1], state[2] = i64_xor(c1, c2, d1, d2)
	state[3], state[4] = i64_rotate_left(b1, b2, 36)
end

//This function tries to do something that doesn't do much but isn't allowed
//during HUD drawing time. If that fails, it means we're in HUD drawing mode.
local function InHUD()
	if players[0] == nil then
		//we are outside of a game and can't call P_IsFlagInBase, but this also
		//means we cannot be drawing a HUD right now.
		//I tried calling P_IsFlagAtBase outside of a game, it crashes SRB2.
		return false
	end
	//the result is discarded because i do not care at all what it is
	local test_call = pcall(P_IsFlagAtBase, MT_BLUEFLAG)
	return not test_call
end

//here's the Networking part of our program

local netstates = {}

local function retrieve(state, level)
	level = level + 2
	if type(state) == "table" then
		local state_ok = false
		if #state == 4 then
			state_ok = true
			for k, v in pairs(state) do
				if type(v) ~= "number" then
					state_ok = false
					break
				end
			end
		end
		if not state_ok then
			error("tried to use invalid SeedRng state", level)
		end
		return state
	elseif type(state) == "number" then
		if InHUD() then
			error("you cannot use networked SeedRng states in HUD functions", level)
		end
		if not netstates[state] then
			error("SeedRng state handle "..state.." is invalid", level)
		end
		return netstates[state]
	else
		error("tried to use impossible SeedRng state", level)
	end
end

addHook("NetVars", function(net) netstates = net(netstates) end)

local SeedRng = {}

//this is the definition block for SeedRng.Create
do
	//this is used to replace invalid seed values
	local function xorshift32(val)
		val = $^^($ << 13)
		val = $^^($ >> 17)
		return val^^(val << 5)
	end

	local function SRB2Rand32()
		local x = 0
		repeat
			x = P_RandomFixed() << 16 | P_RandomFixed()
		until x != 0
		return x
	end

	//If you pass no arguments, you get a random seed, but why would you do that?
	local function create_internal(...)
		local seed = {...}
		local state = {}
		local unmodified = false

		//get rid of bad seed components
		repeat
			unmodified = true
			for i=1, min(4, #seed) do
				if (not seed[i]) or seed[i] == 0 then
					table.remove(seed, i)
					unmodified = false
					break
				end
			end
		until unmodified

		if #seed == 0 then
			//no seed at all, make a random one
			for i=1, 4 do
				state[i] = SRB2Rand32()
			end
		else
			//extend our existing seed
			local last_seed_part = SRB2Rand32()
			for i=1, 4 do
				local val = seed[i]
				if (val == nil) or (val == 0)
					val = xorshift32(last_seed_part)
				end
				state[i] = val
				last_seed_part = val
			end
		end
		//run one step before it returns
		xoroshiro128_step(state)
		return state
	end

	function SeedRng.Create(net, ...)
		local state = create_internal(...)
		if net then
			if InHUD() then
				error("you cannot create networked SeedRng states in HUD functions", 2)
			end
			table.insert(netstates, state)
			return #netstates
		end
		return state
	end
end //of SeedRng.Create()

function SeedRng.Destroy(state)
	if type(state) == "number" then
		if not InHUD() then
			netstates[state] = nil
		else
			error("you cannot destroy networked SeedRng states in HUD functions", 2)
		end
	elseif type(state) == "table" then
		for k, v in pairs(state) do state[k] = nil end
	end
end

local function output_internal(state)
	local result =
		((((state[1] & 16777215) + (state[3] & 16777215))&65535) << 16) |
		(((state[2] & 16777215) + (state[4] & 16777215))&65535)
	xoroshiro128_step(state)
	return result
end

local function output_capped(state, limit, level)
	if limit < 1 then
		error("limit was "..limit.." but must be 1 or larger", level + 1)
	end
	local maximum_gen = (INT32_MAX / limit)*limit
	local value
	repeat
		value = output_internal(state)
	until (value >= 0) and (value <= maximum_gen)
	return value % limit
end

function SeedRng.Get32(state)
	return output_internal(retrieve(state, 1))
end

function SeedRng.GetFixed(state)
	return output_internal(retrieve(state, 1)) & 65535
end

function SeedRng.GetByte(state)
	return output_internal(retrieve(state, 1)) & 255
end

function SeedRng.GetSignedByte(state)
	return (output_internal(retrieve(state, 1)) & 255)-128
end

function SeedRng.GetBool(state)
	return (output_internal(retrieve(state, 1)) & 1) == 1
end

function SeedRng.GetChance(state, chance_frac)
	if chance_frac >= FRACUNIT then return true
	elseif chance_frac <= 0 then return false end
	return (output_internal(retrieve(state, 1)) & 65535) >= chance_frac
end

function SeedRng.GetKey(state, limit)
	return output_capped(retrieve(state, 1), limit, 1)
end

function SeedRng.GetRange(state, lower, upper)
	if lower > upper then error("invalid range for GetRange", 2)
	elseif lower == upper then return lower end
	if ((upper-lower) < 0) or ((upper-lower) == INT32_MAX) then
		error("lower and upper are too far apart", 2)
	end
	return output_capped(retrieve(state, 1), (upper-lower)+1, 1) + lower
end

function A_SeedRng_Get()
	return SeedRng
end
