local Vector      = require 'hump.vector'

-- Const parameters for the player
local movespeed = 400

local Player = {}

local playerSprite = love.graphics.newImage("assets/spaceships/player.png")

defaultInvincibility = 2

defaultExtraLives = 2

function Player:new(x, y)
    return {
        player = {
            movespeed = movespeed,
            sprite = playerSprite,
            canFire = true,
            invincibility = defaultInvincibility,
            lives = defaultExtraLives,
        },
        pos = Vector(x, y),
        vel = Vector(),
        size = Vector(96, 120) / 4,
        originalSize = Vector(96, 120),
        scale = Vector(0.5, 0.5),
    }
end

return Player
