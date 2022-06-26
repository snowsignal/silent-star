local tiny = require 'tiny'
local playerDrawSystem = tiny.processingSystem({ draw = true})
playerDrawSystem.filter = tiny.requireAll("player", "pos", "size", "vel")

function playerDrawSystem:process(e)
    love.graphics.push()
    local size = e.size
    local scale = Vector(1, 1)
    if e.vel.x > 0 then
        love.graphics.scale( 0.9, 1 )
        scale.x = 0.9
    elseif e.vel.x < 0 then
        love.graphics.scale( -0.9, 1 )
        scale.x = -0.9
    end
    love.graphics.draw(e.player.sprite, e.pos.x / scale.x, e.pos.y / scale.y, 0, 1, 1, size.x / 2, size.y / 2)
    love.graphics.pop()
end

return playerDrawSystem