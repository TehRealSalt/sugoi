function modmaps.bytesToString(bytes)
	local chars = {}
	local j = 1

	for i = 1, #bytes / 1024
		chars[i] = string.char(unpack(bytes, j, j + 1023))
		j = j + 1024
	end

	chars[#bytes / 1024 + 1] = string.char(unpack(bytes, j, #bytes))

	return table.concat(chars)
end

function modmaps.stringToBytes(s)
	local bytes = {}
	local j = 1

	for i = 1, #s / 1024
		local chunk = {s:byte(j, j + 1024 - 1)}
		for i = 1, 1024
			bytes[j] = chunk[i]
			j = j + 1
		end
	end

	local chunk = {s:byte(j, #s)}
	for i = 1, 1024
		bytes[j] = chunk[i]
		j = j + 1
	end

	return bytes
end

function modmaps.createByteStream(bytes)
	return {
		bytes = bytes or {},
		byteoffset = 1,
		bitoffset = 0
	}
end

function modmaps.readBit(stream)
	local byteoffset = stream.byteoffset
	local bitoffset = stream.bitoffset

	if bitoffset < 7
		stream.bitoffset = bitoffset + 1
	else
		stream.byteoffset = byteoffset + 1
		stream.bitoffset = 0
	end

	return (stream.bytes[byteoffset] >> (7 - bitoffset)) & 1
end
local readBit = modmaps.readBit

function modmaps.writeBit(stream, bit)
	local bytes = stream.bytes
	local byteoffset = stream.byteoffset
	local bitoffset = stream.bitoffset

	if bitoffset ~= 0
		bytes[byteoffset] = bytes[byteoffset] | (bit << (7 - bitoffset))
	else
		bytes[byteoffset] = bit << 7
	end

	if bitoffset < 7
		stream.bitoffset = bitoffset + 1
	else
		stream.byteoffset = byteoffset + 1
		stream.bitoffset = 0
	end
end
local writeBit = modmaps.writeBit

function modmaps.readByte(stream)
	local bytes = stream.bytes

	local highbyteoffset = stream.byteoffset
	local highbitoffset = stream.bitoffset

	stream.byteoffset = highbyteoffset + 1

	if highbitoffset ~= 0
		local byte = (bytes[highbyteoffset]
			& (255 >> highbitoffset)) << highbitoffset

		local lowbitoffset = 8 - highbitoffset
		byte = byte | ((bytes[stream.byteoffset]
			& (255 << lowbitoffset)) >> lowbitoffset)

		return byte
	else
		return bytes[highbyteoffset]
	end
end
local readByte = modmaps.readByte

function modmaps.writeByte(stream, byte)
	local bytes = stream.bytes

	local highbyteoffset = stream.byteoffset
	local highbitoffset = stream.bitoffset

	stream.byteoffset = highbyteoffset + 1

	if highbitoffset ~= 0
		bytes[highbyteoffset] = bytes[highbyteoffset]
			| ((byte & (255 << highbitoffset)) >> highbitoffset)

		local lowbitoffset = 8 - highbitoffset
		bytes[stream.byteoffset] = (byte
			& (255 >> lowbitoffset)) << lowbitoffset
	else
		bytes[highbyteoffset] = byte
	end
end
local writeByte = modmaps.writeByte

function modmaps.readUInt(stream, len)
	local bytes = stream.bytes
	local byteoffset = stream.byteoffset
	local bitoffset = stream.bitoffset

	if bitoffset + len < 8 and bitoffset ~= 0
		stream.bitoffset = bitoffset + len
		return (bytes[byteoffset] >> (8 - bitoffset - len)) & ((1 << len) - 1)
	end

	local n = 0

	if bitoffset ~= 0
		local space = 8 - bitoffset
		len = len - space
		n = (bytes[byteoffset] & ((1 << space) - 1)) << len

		byteoffset = byteoffset + 1
		bitoffset = 0
	end

	while len >= 8
		len = len - 8
		n = n | (bytes[byteoffset] << len)
		byteoffset = byteoffset + 1
	end

	if len ~= 0
		n = n | (bytes[byteoffset] >> (8 - len))
		bitoffset = len
	end

	stream.byteoffset = byteoffset
	stream.bitoffset = bitoffset

	return n
end
local readUInt = modmaps.readUInt

function modmaps.writeUInt(stream, len, n)
	local bytes = stream.bytes
	local byteoffset = stream.byteoffset
	local bitoffset = stream.bitoffset

	if bitoffset + len < 8 and bitoffset ~= 0
		bytes[byteoffset] = bytes[byteoffset] | (n << (8 - bitoffset - len))
		stream.bitoffset = bitoffset + len
		return
	end

	if bitoffset ~= 0
		local space = 8 - bitoffset
		len = len - space
		bytes[byteoffset] = bytes[byteoffset] | (n >> len)

		byteoffset = byteoffset + 1
		bitoffset = 0
	end

	while len >= 8
		len = len - 8
		bytes[byteoffset] = (n >> len) & 255
		byteoffset = byteoffset + 1
	end

	if len ~= 0
		bytes[byteoffset] = (n << (8 - len)) & 255
		bitoffset = len
	end

	stream.byteoffset = byteoffset
	stream.bitoffset = bitoffset
end
local writeUInt = modmaps.writeUInt

function modmaps.readUInt16(stream)
	return readUInt(stream, 16)
end

function modmaps.writeUInt16(stream, n)
	writeUInt(stream, 16, n)
end

function modmaps.readInt32(stream)
	return readUInt(stream, 32)
end

function modmaps.writeInt32(stream, n)
	writeUInt(stream, 32, n)
end

function modmaps.readBytes(stream, num, bytes, start)
	bytes = bytes or {}
	start = start or 1

	for i = start, start + num - 1
		bytes[i] = readByte(stream)
	end

	return bytes
end

function modmaps.writeBytes(stream, bytes, start, num)
	start = start or 1
	if num == nil
		num = #bytes
	end

	for i = start, start + num - 1
		writeByte(stream, bytes[i])
	end
end

function modmaps.readString(stream)
	local len = readByte(stream)
	if len == 255
		len = modmaps.readInt32(stream)
	end

	return modmaps.bytesToString(modmaps.readBytes(stream, len))
end

function modmaps.writeString(stream, s)
	if #s < 255
		writeByte(stream, #s)
	else
		writeByte(stream, 255)
		writeInt32(stream, #s)
	end

	modmaps.writeBytes(stream, modmaps.stringToBytes(s))
end
