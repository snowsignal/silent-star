local Vector      = require 'hump.vector'

local Checkpoint = {}

function Checkpoint:new(x, y, current)
    return {
        checkpoint = {
            current = current
        },
        pos = Vector(x, y),
        size = Vector(32, 32),
    }
end

return Checkpoint