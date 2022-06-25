local CutsceneSegment = {}

local font = love.graphics.setNewFont("assets/fonts/VCR_OSD_MONO.ttf", 20)

function CutsceneSegment:new(text, fx, waitTillNext)
    return {
        text = love.graphics.newText(font, text),
        fx = fx or nil,
        waitTillNext = waitTillNext or 2.5
    }
end

return CutsceneSegment