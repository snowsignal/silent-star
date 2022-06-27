-- The Shock System controls the events of the game, tactfully throwing enemies at the player,
-- and causing player death. It is basically the story controller, if you will.

local tiny = require 'tiny'

local Enemy = require 'entities.enemy'
local shockSystem = tiny.processingSystem()
shockSystem.filter = tiny.requireAll("story")

function shockSystem:onAdd(e)
    -- Set up callbacks
    local story = e.story
    local wave = 1
    local wavetotal = #story.waves
    self.world.remainingEnemies = 20
    self.world.timer:every(0.25, function()
        vel = Vector(0, 400)
        self.world:add(Enemy:spawnBasicShip(Vector(math.random(50, 750), -50), vel))
        self.world.remainingEnemies = self.world.remainingEnemies - 1

    end)
end

return shockSystem