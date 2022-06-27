local Cutscene = require 'cutscene'
local CutsceneSegment = require 'entities.cutsceneSegment'
local level1 = require 'level1'

local canProceed = false

local openingCutscene = Cutscene:new({CutsceneSegment:new("A Message from Dopamine Farm Studios Inc."), CutsceneSegment:new("We are required by Extranet legal code to inform you that this game contains targeted advertising and pop-up Surveys in order to improve the type of content we serve. Upon your death in this game, you will be allowed to continue, provided you complete a Survey. Thank you for your cooperation."),CutsceneSegment:new("Press Z to continue")}, function()
    canProceed = true
end, 2.0, 0.0)

function openingCutscene:enter()
    love.graphics.setShader()
    stopMusicWithFadeout(3)
end

function openingCutscene:keypressed(key)
    if key == 'z' and canProceed then
        Gamestate.switch(level1)
    end
end

return openingCutscene