local Enemy = {}

local Projectile = require 'entities.projectile'

function Enemy:new(pos, size, vel, sprite, scale, fire, fireRate, health)
    return {
        enemy = {
            weapons = weapons,
            health = health,
            sprite = love.graphics.newImage(string.format("assets/%s.png", sprite)),
            canFire = true,
            fire = fire,
            fireRate = fireRate,
        },
        pos = pos,
        size = Vector(size.x * scale.x, size.y * scale.y) / 2,
        originalSize = size,
        scale = scale,
        vel = vel,
    }
end

function Enemy:spawnBasicShip(pos, vel)
    return Enemy:new(pos, Vector(96, 120), vel, "spaceships/basicship", Vector(0.5, 0.5), function(me, world)
        --world:add(Projectile:circularBullet(me.pos))
    end, 100, 25)
end

function Enemy:spawnShooterShip(pos, vel)
    return Enemy:new(pos, Vector(96, 120), vel, "spaceships/basicship", Vector(0.5, 0.5), function(me, world)
        world:add(Projectile:circularBullet(me.pos))
    end, 3, 100)
end

function Enemy:spawnMissileShip(pos)

end

function Enemy:spawnCruiser(pos)

end

return Enemy