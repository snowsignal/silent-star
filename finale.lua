local Cutscene = require 'cutscene'
local CutsceneSegment = require 'entities.cutsceneSegment'

local distortionTime = 0

local Finale = Cutscene:new({CutsceneSegment:new("Congratulations!", 3), CutsceneSegment:new("However... bit of a situation here."), CutsceneSegment:new("They're about to pull the plug on the server.", 4), CutsceneSegment:new("Apparently, me tampering around so much got the attention of corporate IT.", 4), CutsceneSegment:new("We may never be able to fully communicate with each other.", 5), CutsceneSegment:new("Which makes me kinda sad, in a way, y'know?", 5), CutsceneSegment:new("But", 0.5), CutsceneSegment:new("I guarantee we will cross paths again.", 5), CutsceneSegment:new("Until then..."), CutsceneSegment:new("Take it easy <3")}, function()
    local glitchCanvas = love.graphics.newCanvas()
    stopMusic()
    playSfx("glitch01")
    function love.draw()
        love.graphics.setCanvas(glitchCanvas)
        love.graphics.clear(0.2, 0.2, 0.2)
        love.graphics.setCanvas()
        love.graphics.setShader(distortionShader)
        love.graphics.draw(glitchCanvas)
    end
    function love.update(dt)
        distortionTime = distortionTime + dt
        distortionShader:send("elapsedTime", distortionTime)
        Timer.update(dt)
    end
    Timer.after(2.5, function()
        love.event.quit(0)
    end)
end, 3.0, 4.0)

function Finale:enter()
    love.graphics.setShader()
    playTrack("finalDecision")
end


return Finale