local Level1 = {}

local tiny = require 'tiny'

local backgroundDrawSystem = require 'systems.backgroundDrawSystem'
local velocitySystem = require 'systems.velocitySystem'

local Background = require 'entities.background'

local Player = require 'entities.player'

local drawSystemFilter = tiny.requireAll("draw")
local updateSystemFilter = tiny.rejectAll("draw")

function Level1:enter()
    print("Entered level!")
    playTrack("level1")
    -- Set up tiny world
    self.world = tiny.world(
            backgroundDrawSystem,
            velocitySystem,
            Background:new("stars")
    )
end

-- https://gafferongames.com/post/fix_your_timestep/
-- https://gamedev.stackexchange.com/questions/165949/keep-platformer-jump-height-consistent-with-different-frame-rates
-- Lol didnt read
local accum = 0
local frametarget = 1/60
function Level1:update(dt)
    accum = accum + dt
    while accum > frametarget do
        self.world:update(frametarget, updateSystemFilter)
        accum = accum - frametarget
    end
end

function Level1:draw()
    self.world:update(dt, drawSystemFilter)
end

return Level1