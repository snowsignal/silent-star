local Vector = require 'hump.vector'

local Projectile = {}

local function __NULL__() end

function Projectile:new(pos, size, sprite, vel, scale, onDeath, friendly, homing)
    local velocity = vel
    local rotation = velocity:angleTo(Vector(0, 1))
    return {
        pos = pos,
        size = size,
        sprite = love.graphics.newImage(string.format("assets/%s.png", sprite)),
        vel = vel,
        scale = scale or Vector(1, 1),
        rotation = rotation or 0,
        onDeath = onDeath or __NULL__,
        friendly = friendly or false,
        homing = homing or false
    }
end

function Projectile:circularBullet(pos)
    return Projectile:new(pos, Vector(30, 30), "projectiles/bullets/bulletCircle", Vector(-300, -1000), Vector(0.5, 1))
end

function Projectile:rectangleBullet(pos)
    return Projectile:new(pos, Vector(20, 20), "projectiles/bullets/bulletRectangle", Vector(0, -1000), Vector(0.25, 1))
end

return Projectile