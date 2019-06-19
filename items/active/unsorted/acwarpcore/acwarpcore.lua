function init()
    self.cooldownTimer = 0
end


function update(dt, fireMode, shiftHeld)
    self.cooldownTimer = math.max(self.cooldownTimer - dt, 0)
end


function uninit()

end

function activate(fireMode, shiftHeld)
    if ready() then
        animator.playSound("fire")
        player.warp("ownShip", "beam")
        self.cooldownTimer = 5
        status.addEphemeralEffect("acwarpsickness")
        item.consume(1)
    else
        animator.playSound("deny")
        return
    end
end

function ready()
    return self.cooldownTimer == 0 and
        not status.uniqueStatusEffectActive("acwarpsickness") and world.terrestrial()
end
