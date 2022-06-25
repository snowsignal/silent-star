local tiny = require "tiny"
local bump = require "bump"

local cellSize = 64

local bumpSystem = tiny.processingSystem()
bumpSystem.filter = tiny.requireAll("pos", "size")
-- This is probably not a good filter

function bumpSystem:onAddToWorld(world)
    local bumpworld = bump.newWorld(cellSize)
    self.bump = bumpworld
    world.bump = bumpworld
end

function bumpSystem:onAdd(e)
    self.bump:add(e, e.pos.x, e.pos.y, e.size.x, e.size.y)
end

function bumpSystem:onRemove(e)
    self.bump:remove(e)
end

return bumpSystem
