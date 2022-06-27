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
    return Enemy:new(pos, Vector(96, 120), vel, "spaceships/basicship", Vector(0.5, 0.5), function() end, 100, 25)
end

function Enemy:spawnShooterShip(pos, vel)
    return Enemy:new(pos, Vector(96, 120), vel, "spaceships/basicship", Vector(0.5, 0.5), function(me, world)
        world:add(Projectile:circularBullet(me.pos, me.vel + vel))
    end, 3, 100)
end

function Enemy:spawnFastShooter(pos, vel, vel2)
    return Enemy:new(pos, Vector(96, 120), vel, "spaceships/basicship", Vector(0.5, 0.5), function(me, world)
        world:add(Projectile:circularBullet(me.pos, me.vel + vel))
        world:add(Projectile:circularBullet(me.pos, me.vel + vel2))
    end, 0.5, 100)
end

function Enemy:spawnMineLayer(pos, vel)
    return Enemy:new(pos, Vector(110, 80), vel, "spaceships/minelayer", Vector(0.75, 0.75), function(me, world)
        local mine = Projectile:mine(me.pos)
        world:add(mine)
        world.timer:after(10, function()
            tiny.removeEntity(world, mine)
        end)
    end, math.random(1, 5) / 2, 200)
end

function Enemy:spawnMissileShip(pos)

end

function Enemy:spawnCruiser(pos)

end

return Enemy