local Enemy = {}

function Enemy:new(pos, size, sprite, weapons, health)
    return {
        pos = pos,
        size = size,
        sprite = love.graphics.newImage(string.format("assets/%s.png", sprite)),
        weapons = weapons,
        health = health
    }
end

return Enemy