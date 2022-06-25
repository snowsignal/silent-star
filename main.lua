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
tiny        = require 'tiny'
local menu  = require 'menu'

shader = love.graphics.newShader("abberation.glsl")
love.graphics.setShader(shader)
shader:send("time", 0)

function love.load()
    loadSounds()
    Gamestate.registerEvents()
    Gamestate.switch(menu)
end
