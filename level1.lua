local Level1 = {}

local tiny = require 'tiny'

local backgroundDrawSystem = require 'systems.backgroundDrawSystem'
local velocitySystem = require 'systems.velocitySystem'
local playerDrawSystem = require 'systems.playerDrawSystem'
local playerMovementSystem = require 'systems.playerMovementSystem'

local shockSystem = require 'systems.shockSystem'
local Story = require 'entities.story'

local enemySystem = require 'systems.enemySystem'
local enemyDrawSystem = require 'systems.enemyDrawSystem'

local projectileDrawSystem = require 'systems.projectileDrawSystem'

local Input = require 'boipushy'

local Background = require 'entities.background'

local Player = require 'entities.player'

local drawSystemFilter = tiny.requireAll("draw")
local updateSystemFilter = tiny.rejectAll("draw")

local waveFont = love.graphics.newFont("assets/fonts/VCR_OSD_MONO.ttf", 30)

function Level1:drawWave()
    local text = string.format("Wave: %d / %d", self.world.wave, self.world.wavetotal)
    local PADDING = 15
    love.graphics.printf(text, waveFont, 800 - waveFont:getWidth(text) - PADDING, 0 + PADDING, 1000)
end

function Level1:enter()
    playTrack("level1")
    -- Set up tiny world
    self.world = tiny.world(
            backgroundDrawSystem,
            projectileDrawSystem,
            enemyDrawSystem,
            playerDrawSystem,
            playerMovementSystem,
            shockSystem,
            enemySystem,
            velocitySystem,
            Player:new(300, 300),
            Background:new("stars"),
            Story:new({}, {})
    )
    self.world.wave = 1
    self.world.wavetotal = 8

    self.world.input = Input()
    self.world.input:bind('right', 'player-right')
    self.world.input:bind('left', 'player-left')
    self.world.input:bind('up', 'player-up')
    self.world.input:bind('down', 'player-down')
    self.world.input:bind('d', 'player-right')
    self.world.input:bind('a', 'player-left')
    self.world.input:bind('w', 'player-up')
    self.world.input:bind('s', 'player-down')
    self.world.input:bind('z', 'player-fire')
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
        self.world.input:update()
    end
end

function Level1:draw()
    self.world:update(dt, drawSystemFilter)
    self:drawWave()
end

return Level1