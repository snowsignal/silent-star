local Enemy = {}

function Enemy:new(pos, size, vel, sprite, scale, weapons, health)
    return {
        enemy = {
            weapons = weapons,
            sprite = love.graphics.newImage(string.format("assets/%s.png", sprite)),
        },
        pos = pos,
        size = size,
        scale = scale,
        vel = vel,
        health = health
    }
end

function Enemy:spawnBasicShip(pos)
    return Enemy:new(pos, Vector(96, 120), Vector(100, 220), "spaceships/basicship", Vector(0.5, 0.5), {}, 100)
end

function Enemy:spawnMissileShip(pos)

end

function Enemy:spawnCruiser(pos)

end

return Enemy