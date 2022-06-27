local tiny = require "tiny"
local explosionDrawSystem = tiny.processingSystem({ draw = true})
explosionDrawSystem.filter = tiny.requireAll("pos", "scale", "explosion", "size")


function explosionDrawSystem:onAdd(e)
    e.explosion.animHandle = Timer.every(e.explosion.nextFrame, function()
        e.explosion.frame = e.explosion.frame + 1
    end)
end

function explosionDrawSystem:onRemove(e)
    Timer.cancel(e.explosion.animHandle)
end

function explosionDrawSystem:process(e)
    if e.explosion.frame > e.explosion.totalFrames then
        tiny.removeEntity(self.world, e)
        return
    end

    love.graphics.push()
    local size = e.size
    love.graphics.scale( e.scale.x, e.scale.y)
    love.graphics.draw(e.explosion.spriteSheet, e.explosion.spritelist[e.explosion.frame], e.pos.x / e.scale.x, e.pos.y / e.scale.y, 0, 1, -1, size.x / 2, size.y / 2)
    love.graphics.pop()
end

return explosionDrawSystem