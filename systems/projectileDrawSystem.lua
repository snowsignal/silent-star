local tiny = require 'tiny'
local projectileDrawSystem = tiny.processingSystem({ draw = true})
projectileDrawSystem.filter = tiny.requireAll("pos", "size", "rotation", "projectile")

local scaleCanvas = love.graphics.newCanvas(100, 100)

function projectileDrawSystem:process(e)
    if e.pos.y < -50 or e.pos.y > 650 or e.pos.x < 0 or e.pos.x > 850 then
        tiny.removeEntity(self.world, e)
        return
    end

    love.graphics.push()
    love.graphics.setCanvas(scaleCanvas)
    love.graphics.clear()
    love.graphics.scale(e.scale.x, e.scale.y)
    love.graphics.draw(e.projectile.sprite, 0, 0)
    love.graphics.pop()
    love.graphics.setCanvas(self.world.canvas)

    love.graphics.draw(scaleCanvas, e.pos.x, e.pos.y, e.rotation, 1, 1, e.size.x / 2 * e.scale.x, e.size.y / 2 * e.scale.y)
end

return projectileDrawSystem