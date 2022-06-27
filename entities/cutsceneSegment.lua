local utils = require 'utils'

local CutsceneSegment = {}

local wrapLimit = 600

local font = love.graphics.setNewFont("assets/fonts/VCR_OSD_MONO.ttf", 20)

function CutsceneSegment:new(text, waitTillNext, fx)
    _, wrappedText = font:getWrap(text, wrapLimit)
    wrappedText = utils.map(wrappedText, function(t) return love.graphics.newText(font, t) end)
    return {
        text = wrappedText,
        fx = fx or nil,
        waitTillNext = waitTillNext or 0.5
    }
end

return CutsceneSegment