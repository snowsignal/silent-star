local Vector      = require 'hump.vector'

-- Const parameters for the player
local movespeed = 6
local decayfrac = 0.2
local holdjumptime = 0.2

local Player = {}

function Player:new(x, y)
    return {
        playerControlled = {
            canjump = false,
            stoppedJump = false,
            canDoubleJump = false,
            jumptime = 0,
            inground = false,
            rollanim = 0,

            oldpupiloffset = Vector(),
            mouselooktime = 0,
            
            tunnelstarttimer = 0,
            tunnelstartpos = Vector(),
            
            airtime = 0,
            prevgroundhit = true,
            groundhitanim = 0, -- 1 is start of animation, ticks down to 0
        }, -- Just a component marking this as a controllable character
        pos = Vector(x, y),
        vel = Vector(),
        size = Vector(28, 28),
        sprsize = Vector(32, 32),
        sproffset = Vector(-2, -4),
    }
end

return Player
