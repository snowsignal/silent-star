local Vector      = require 'hump.vector'

local SlimeBlock = {}

function SlimeBlock:new(x, y)
    return {
        slimeblock = true,
        pos = Vector(x, y),
        size = Vector(32, 32),
    }
end

return SlimeBlock