require "/scripts/util.lua"

function init(...)
    if root.itemConfig({ name="ct_wupgradetable", count=1}) then
        self.pos = object.position()
        self.dir = object.direction()
        object.smash(true)
        world.placeObject("ct_wupgradetable", self.pos, self.dir)
    end
end

function update()
    if root.itemConfig({ name="ct_wupgradetable", count=1}) then
        self.pos = object.position()
        self.dir = object.direction()
        object.smash(true)
        world.placeObject("ct_wupgradetable", self.pos, self.dir)
        --sb.logInfo("%s", "smashed")
        --if not self.co then
        --    self.co = coroutine.create(function()
        --        util.wait(1, function()
        --            sb.logInfo("coin")
        --
        --        end)
        --    end)
        --     coroutine.resume(self.co)
        --end

    end
end

function uninit()
    world.placeObject("ct_wupgradetable", self.pos, self.dir)
end

