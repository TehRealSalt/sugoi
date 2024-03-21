// lua script by Toaster

function A_FloorCheck(mo, var1)
    if var1 and ((!(mo.eflags & MFE_VERTICALFLIP) and mo.z <= mo.floorz)
     or ((mo.eflags & MFE_VERTICALFLIP) and mo.z + mo.height >= mo.ceilingz)) then
        mo.state = var1
    end
end

function A_AngleToState(mo, var1, var2)
    if mo.spawnpoint
        mo.state = (var1 + (mo.spawnpoint.angle % var2))
    end
end