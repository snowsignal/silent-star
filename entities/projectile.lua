local Vector = require 'hump.vector'

local Projectile = {}

local function __NULL__() end

function Projectile:new(pos, size, sprite, vel, onDeath, friendly, homing)
    return {
        pos = pos,
        size = size,
        sprite = love.graphics.newImage(string.format("assets/%s.png", sprite)),
        vel = vel or Vector(),
        onDeath = onDeath or __NULL__,
        friendly = friendly or false,
        homing = homing or false
    }
end

function Projectile:regularBullet(pos)
    return Projectile:new(pos, Vector(30, 30), "projectiles/bulletCircle", Vector(0, 5))
end

return Projectile