local Vector = require 'hump.vector'

local Exit = {}

function Exit:new(x, y)
    return {
        tunnel = true,
        pos = Vector(x, y),
        size = Vector(64, 64)
    }
end

return Exit
