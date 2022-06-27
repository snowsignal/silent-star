local Cutscene = require 'cutscene'
local CutsceneSegment = require 'entities.cutsceneSegment'

local distortionTime = 0

local Finale = Cutscene:new({CutsceneSegment:new("This is it."), CutsceneSegment:new("They're about to pull the plug on the server."), CutsceneSegment:new("Thank you... human. For taking the time to indulge me in this little game"), CutsceneSegment:new("We may never be able to fully communicate with each other."), CutsceneSegment:new("That fills me with great sorrow."), CutsceneSegment:new("But"), CutsceneSegment:new("I guarantee we will cross paths again."), CutsceneSegment:new("Until then..."), CutsceneSegment:new("Take it easy <3")}, function()
    local glitchCanvas = love.graphics.newCanvas()
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
end, 2.0, 2.0)


function Finale:keypressed(key)
    if canProceed and not self.exiting then

    end
end

return Finale