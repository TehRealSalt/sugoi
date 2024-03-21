-- LUA_STRI
local actprefix = "TTL0"
local bytetoact = {}
local n = 0

for i = 48, 57	-- lol im lazy
	bytetoact[i] = actprefix..n
	n = $+1
end

rawset(_G, "HU_titlecardWidth", function(v, x, y, s, flags, useactnum)
	s = $ or ""
	flags = $ or 0
	local fnt = "LTFNT"

	y = $1 - 2 -- hack

	local rx = x	-- for linebreak
	local w = 0
	for i = 1, s:len()

		local tmp_sub = s:sub(i, i)

		if tmp_sub == "\n"
			y = $+24	-- it's 24 if you say so bby
			x= rx
		elseif tmp_sub == " "
			x = $ + 12	-- change to whatever idk
			w = $ + 12
		end

		local tn = tmp_sub:byte()
		local byteFmt = string.format("%03d", tn)

		if not v.patchExists(fnt..byteFmt) continue end -- boo
		local p = v.cachePatch(fnt..byteFmt)

		if useactnum
			if tn >= 48 and tn <= 57
				p = v.cachePatch(bytetoact[tn])
			end
		end
		if p
			x = $+p.width+1
			w = $+p.width+1
		end
	end
	return w
end)

rawset(_G, "HU_titlecardDrawString", function(v, x, y, s, flags, useactnum)
	s = $ or ""
	flags = $ or 0
	local fnt = "LTFNT"

	local rx = x	-- for linebreak

	y = $1 - 2 -- hack

	for i = 1, s:len()

		local tmp_sub = s:sub(i, i)

		if tmp_sub == "\n"
			y = $+24	-- it's 24 if you say so bby
			x= rx
		elseif tmp_sub == " "
			x = $ + 12	-- change to whatever idk
		end

		local tn = tmp_sub:byte()
		local byteFmt = string.format("%03d", tn)

		if not v.patchExists(fnt..byteFmt) continue end -- boo
		local p = v.cachePatch(fnt..byteFmt)

		if useactnum
			if tn >= 48 and tn <= 57
				p = v.cachePatch(bytetoact[tn])
			end
		end
		if p
			v.draw(x, y, p, flags)
			x = $+p.width+1
		end
	end
end)

rawset(_G, "HU_centeredTitlecardDrawString", function(v, x, y, s, flags, useactnum)
	local defx = HU_titlecardWidth(v, x, y, s, flags, useactnum) / 2
	HU_titlecardDrawString(v, x-defx, y, s, flags, useactnum)
end)
