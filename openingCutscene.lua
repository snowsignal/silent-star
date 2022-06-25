local Cutscene = require 'cutscene'
local CutsceneSegment = require 'entities.cutsceneSegment'

local openingCutscene = Cutscene:new({CutsceneSegment:new("This is some example text"),CutsceneSegment:new("More example text")})

function openingCutscene:enter()
    stopMusicWithFadeout(3)
end

return openingCutscene