local Vector = require 'hump.vector'

local Projectile = {}

local function __NULL__() end

function Projectile:new(pos, size, sprite, damage, vel, scale, onDeath, friendly, homing)
    local velocity = vel
    local rotation = velocity:angleTo(Vector(0, 1))
    if rotation < 0 then
        rotation = math.pi + rotation
    end
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

function Projectile:circularBullet(pos, vel)
    return Projectile:new(pos, Vector(30, 30), "projectiles/bullets/bulletCircle", 50, vel, Vector(0.25, 0.5))
end

function Projectile:mine(pos)
    return Projectile:new(pos, Vector(30, 30), "projectiles/bullets/bulletCircle", 50, Vector(), Vector(0.75, 0.75))
end

function Projectile:explosive(pos)
    return Projectile:new(pos, Vector(44, 40), "projectiles/solid/explosive", 50, Vector(), Vector(0.75, 0.75))
end

function Projectile:rocket(pos, vel)
    return Projectile:new(pos, Vector(44, 59), "projectiles/solid/rocket", 50, vel, Vector(1, 1))
end

function Projectile:smallExplosive(pos, vel)
    return Projectile:new(pos, Vector(30, 30), "projectiles/solid/explosive", 50, vel, Vector(0.2, 0.2))
end

function Projectile:secondaryBullet(pos, right)
    local xvel
    if right then
        xvel = 300
    else
        xvel = -300
    end

    return Projectile:new(pos, Vector(20, 20), "projectiles/solid/rocket", 100, Vector(xvel, -400), Vector(0.5, 0.5), nil, true)
end

function Projectile:rectangleBullet(pos)
    return Projectile:new(pos, Vector(20, 20), "projectiles/bullets/bulletRectangle", 50, Vector(0, -1000), Vector(0.25, 1), nil, true)
end

return Projectile