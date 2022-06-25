local game = { finished = false, startingTime = nil, endingTime = nil, deaths = 0 }

Camera      = require 'hump.camera'
Vector      = require 'hump.vector'
Sti         = require 'sti.init'
Gamestate   = require 'hump.gamestate'
tiny        = require 'tiny'
Input       = require 'boipushy'

bumpSystem  = require 'systems.bumpSystem'
cameraSystem     = require 'systems.cameraSystem'
require 'music'


local drawSystemFilter = tiny.requireAll("draw")
local updateSystemFilter = tiny.rejectAll("draw")

function game:enter()
    if not self.startingTime then
        self.startingTime = love.timer.getTime()
    end
    -- Start game music
    if self.deaths == 0 then
        playTrack("game")
    end

    -- Make tiny world
    self.world = tiny.world()

    self.world.canTunnel = self.canTunnel or false
    self.world.canDoubleJump = self.canDoubleJump or false

    scene:load("L1", self.world, self.checkpoint)

    self.world:add(
        -- Systems
        bumpSystem,
        cameraSystem,
        -- Draw systems
        -- Entities
        scene
    )

    self.world.input = Input()
    self.world.input:bind('right', 'player-right')
    self.world.input:bind('left', 'player-left')
    self.world.input:bind('up', 'player-up')
    self.world.input:bind('down', 'player-down')
    self.world.input:bind('d', 'player-right')
    self.world.input:bind('a', 'player-left')
    self.world.input:bind('w', 'player-up')
    self.world.input:bind('s', 'player-down')
    self.world.input:bind('x', 'move-to-ground')
    self.world.input:bind('z', 'player-jump')

    if self.deaths == 0 then
        tiny.add(self.world, BigText:new(275, 250, 30, "Find a way out of the cave!", 7))
    end

    self.world:refresh()
end

-- https://gafferongames.com/post/fix_your_timestep/
-- https://gamedev.stackexchange.com/questions/165949/keep-platformer-jump-height-consistent-with-different-frame-rates
-- Lol didnt read
local accum = 0
local frametarget = 1/60
function game:update(dt)
    if self.world.dead and not self.world.won then
        self.deaths = self.deaths + 1
        self.checkpoint = checkpointSystem:getCurrent()
        tiny.clearEntities(self.world)
        tiny.clearSystems(self.world)
        self.world:refresh()
        if self.checkpoint then
            self.canTunnel = self.checkpoint.canTunnel
            self.canDoubleJump = self.checkpoint.canDoubleJump
        end
        self.canTunnel = not not self.canTunnel
        self.canDoubleJump = not not self.canDoubleJump
        Gamestate.switch(self)
    end
    if self.world.won and not self.endingTime then
        self.endingTime = love.timer.getTime()
        tiny.add(self.world, BigText:new(125, 200, 22, string.format("Congratulations! You reached the exit in %.3f seconds", self.endingTime - self.startingTime), 1000))
        tiny.add(self.world, BigText:new(125, 250, 22, string.format("and had %d death(s)!", self.deaths), 1000))
        stopMusic()
    end
    accum = accum + dt
    while accum > frametarget do
        self.world:update(frametarget, updateSystemFilter)
        accum = accum - frametarget
        self.world.input:update()
    end
end

function game:draw()
    self.world.camera:attach()
    love.graphics.clear()
    love.graphics.setColor({1, 1, 1, 1})
    

    local dt = love.timer.getDelta()
    self.world:update(dt, drawSystemFilter)
    self.world.camera:detach()
end

return game
