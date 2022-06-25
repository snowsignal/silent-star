local Vector      = require 'hump.vector'

local PowerUp = {}

function PowerUp:new(x, y, type)
    return {
        powerup = {
            type = type
        },
        pos = Vector(x, y),
        size = Vector(32, 32),
    }
end

return PowerUp