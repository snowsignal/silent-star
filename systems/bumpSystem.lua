local tiny = require "tiny"
local bump = require "bump"

local bumpSystem = tiny.processingSystem()
bumpSystem.filter = tiny.requireAll("pos", "size")

function bumpSystem:onAddToWorld(world)
    local bumpworld = bump.newWorld()
    self.bump = bumpworld
    world.bump = bumpworld
end

function bumpSystem:onAdd(e)
    self.bump:add(e, e.pos.x - e.size.x / 2, e.pos.y - e.size.y / 2, e.size.x, e.size.y)
end

function bumpSystem:onRemove(e)
    self.bump:remove(e)
end

return bumpSystem
