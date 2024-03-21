freeslot("MT_NEODRILLA") // don't slot this in SOC to prevent duplication
//Lua made by toaster

addHook("TouchSpecial", function(mo, pmo)
    local ang = (R_PointToAngle2(mo.x, mo.y, pmo.x, pmo.y) - mo.angle)/ANG1
    if ((-23 < ang) and (ang < 23)
    and not (pmo.player.powers[pw_invulnerability])
    and not (pmo.player.powers[pw_super]))
        P_DamageMobj(pmo, mo, mo)
        return true
    end
end, MT_NEODRILLA)

addHook("MobjThinker", function(mo)
    if (S_SoundPlaying(mo, sfx_drill1) or S_SoundPlaying(mo, sfx_drill2)) return end

    if not mo.target
        if mo.start
            mo.start = 0
        end
        return
    end

    if mo.start
        S_StartSound(mo, sfx_drill2)
    else
        S_StartSound(mo, sfx_drill1)
        mo.start = 1
    end
end, MT_NEODRILLA)
