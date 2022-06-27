local Vector = require 'hump.vector'

local Projectile = {}

local function __NULL__() end

function Projectile:new(pos, size, sprite, damage, vel, scale, onDeath, friendly, homing)
    local velocity = vel
    local rotation = velocity:angleTo(Vector(0, 1))
    return {
        pos = pos,
        size = size,
        projectile = {
            sprite = love.graphics.newImage(string.format("assets/%s.png", sprite)),
            damage = damage,
            onDeath = onDeath or __NULL__,
            friendly = friendly or false,
            homing = homing or false
        },
        vel = vel,
        scale = scale or Vector(1, 1),
        rotation = rotation or 0,
    }
end

function Projectile:circularBullet(pos)
    return Projectile:new(pos, Vector(30, 30), "projectiles/bullets/bulletCircle", 50, Vector(0, 500), Vector(0.25, 0.5))
end

function Projectile:rectangleBullet(pos)
    return Projectile:new(pos, Vector(20, 20), "projectiles/bullets/bulletRectangle", 50, Vector(0, -1000), Vector(0.25, 1), nil, true)
end

return Projectile