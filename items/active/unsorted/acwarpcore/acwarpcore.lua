function init()
    if root.itemConfig({ name="ct_warpcore", count=1}) then
        player.giveItem({ name="ct_warpcore", count=1})
        item.consume(1)
        sb.logWarn("%s", "replace deprecated item acwarpcore.")
    end
end


function update(dt, fireMode, shiftHeld)
end


function uninit()

end

function activate(fireMode, shiftHeld)
end

function ready()
end
