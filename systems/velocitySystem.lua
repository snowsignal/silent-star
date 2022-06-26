local tiny = require 'tiny'
local velocitySystem = tiny.processingSystem()
velocitySystem.filter = tiny.requireAll("pos", "vel")

function velocitySystem:process(e, dt)
    e.pos = e.pos + e.vel * dt
end

return velocitySystem