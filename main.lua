-- Silent Star
-- Play the hottest new bullet hell game in the Plexaverse!
-- Written and designed by Jane Lewis

love.filesystem.setRequirePath(love.filesystem.getRequirePath() .. ';lib/?.lua')

love.window.setTitle("Silent Star")
love.window.setMode(800, 600, { resizable = false, fullscreen = false})
love.graphics.setDefaultFilter("nearest", "nearest")

Camera      = require 'hump.camera'
Vector      = require 'hump.vector'
Sti         = require 'sti.init'
Bump        = require 'bump'
Gamestate   = require 'hump.gamestate'
Timer = require 'hump.timer'
tiny        = require 'tiny'
local menu  = require 'menu'

shader = love.graphics.newShader("abberation.glsl")
shader:send("punch", 0)
math.randomseed(os.time())

function love.update(dt)
    Timer.update(dt)
end

function love.load()
    loadSounds()
    Gamestate.registerEvents()
    Gamestate.switch(menu)
end
