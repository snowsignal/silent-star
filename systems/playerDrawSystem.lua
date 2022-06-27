local tiny = require 'tiny'
local playerDrawSystem = tiny.processingSystem({ draw = true})
playerDrawSystem.filter = tiny.requireAll("player", "pos", "size", "vel", "scale")

local whiteoutShader = love.graphics.newShader("invincible.glsl")

function playerDrawSystem:process(e)
    love.graphics.push()
    local size = e.originalSize
    local scale = Vector(e.scale.x, e.scale.y)
    if e.vel.x > 0 then
        scale.x = scale.x * 0.9
    elseif e.vel.x < 0 then
        scale.x = scale.x * -0.9
    end
    love.graphics.scale(scale.x, scale.y)
    if e.player.invincibility < 0 then
        e.player.invincibility = 0
    end
    whiteoutShader:send("strength", 1 - math.abs(math.sin(e.player.invincibility*15)))
    love.graphics.setShader(whiteoutShader)
    love.graphics.draw(e.player.sprite, e.pos.x / scale.x, e.pos.y / scale.y, 0, 1, 1, size.x / 2, size.y / 2)
    love.graphics.setShader()
    love.graphics.pop()
end

return playerDrawSystem