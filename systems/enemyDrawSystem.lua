local tiny = require 'tiny'
local enemyDrawSystem = tiny.processingSystem({ draw = true})
enemyDrawSystem.filter = tiny.requireAll("enemy")

function enemyDrawSystem:process(e)
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

return enemyDrawSystem