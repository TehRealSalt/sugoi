local function totemisland(line, mobj, sector)
    if mobj and mobj.valid and mobj.player then
	    COM_BufInsertText(mobj.player, "cechoduration 3")
        COM_BufInsertText(mobj.player, "cecho \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Totem Island Zone\\(Root)")
    end
end
addHook("LinedefExecute", totemisland, "TOTEMISL")

local function greenmeadow(line, mobj, sector)
    if mobj and mobj.valid and mobj.player then
	    COM_BufInsertText(mobj.player, "cechoduration 3")
        COM_BufInsertText(mobj.player, "cecho \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Green Meadow Zone\\(Bluesfire)")
    end
end
addHook("LinedefExecute", greenmeadow, "GREENMEA")

local function alpineheights(line, mobj, sector)
    if mobj and mobj.valid and mobj.player then
	    COM_BufInsertText(mobj.player, "cechoduration 3")
        COM_BufInsertText(mobj.player, "cecho \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Alpine Heights Zone\\(Simsmagic)")
    end
end
addHook("LinedefExecute", alpineheights, "ALPINEHE")

local function verdantvalley(line, mobj, sector)
    if mobj and mobj.valid and mobj.player then
	    COM_BufInsertText(mobj.player, "cechoduration 3")
        COM_BufInsertText(mobj.player, "cecho \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Verdant Valley Zone\\(Fres)")
    end
end
addHook("LinedefExecute", verdantvalley, "VERDANTV")

local function stormstronghold(line, mobj, sector)
    if mobj and mobj.valid and mobj.player then
	    COM_BufInsertText(mobj.player, "cechoduration 3")
        COM_BufInsertText(mobj.player, "cecho \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Storm Stronghold Zone\\(frozenLake)")
    end
end
addHook("LinedefExecute", stormstronghold, "STORMSTR")

local function greenflowercaves(line, mobj, sector)
    if mobj and mobj.valid and mobj.player then
	    COM_BufInsertText(mobj.player, "cechoduration 3")
        COM_BufInsertText(mobj.player, "cecho \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Greenflower Caves Zone\\(LordPotatosack)")
    end
end
addHook("LinedefExecute", greenflowercaves, "GREENFLO")

local function sunsetmine(line, mobj, sector)
    if mobj and mobj.valid and mobj.player then
	    COM_BufInsertText(mobj.player, "cechoduration 3")
        COM_BufInsertText(mobj.player, "cecho \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Sunset Mine Zone\\(White T.U)")
    end
end
addHook("LinedefExecute", sunsetmine, "SUNSETMI")

local function acidplant(line, mobj, sector)
    if mobj and mobj.valid and mobj.player then
	    COM_BufInsertText(mobj.player, "cechoduration 3")
        COM_BufInsertText(mobj.player, "cecho \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Acid Plant Zone\\(CoatRack)")
    end
end
addHook("LinedefExecute", acidplant, "ACIDPLAN")

local function discofoundry(line, mobj, sector)
    if mobj and mobj.valid and mobj.player then
	    COM_BufInsertText(mobj.player, "cechoduration 3")
        COM_BufInsertText(mobj.player, "cecho \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Disco Foundry Zone\\(Kuja)")
    end
end
addHook("LinedefExecute", discofoundry, "DISCOFOU")
