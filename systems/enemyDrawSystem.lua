local tiny = require 'tiny'
local enemyDrawSystem = tiny.processingSystem({ draw = true})
enemyDrawSystem.filter = tiny.requireAll("pos", "vel", "size", "enemy")

function enemyDrawSystem:process(e)
    love.graphics.push()
    local size = e.size
    local scale = Vector(e.scale.x, e.scale.y)
    if e.vel.x > 0 then
        scale.x = scale.x * 0.9
    elseif e.vel.x < 0 then
        scale.x = scale.x * -0.9
    end
    love.graphics.scale( scale.x, scale.y)
    love.graphics.draw(e.enemy.sprite, e.pos.x / scale.x, e.pos.y / scale.y, 0, 1, -1, size.x / 2, size.y / 2)
    love.graphics.pop()
end

return enemyDrawSystem