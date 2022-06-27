local Vector      = require 'hump.vector'

-- Const parameters for the player
local movespeed = 400

local Player = {}

local playerSprite = love.graphics.newImage("assets/spaceships/player.png")

function Player:new(x, y)
    return {
        player = {
            movespeed = movespeed,
            sprite = playerSprite,
            canFire = true,
            invincibility = 0,
            lives = 1,
        },
        pos = Vector(x, y),
        vel = Vector(),
        size = Vector(96, 120) / 4,
        originalSize = Vector(96, 120),
        scale = Vector(1, 1),
    }
end

return Player
