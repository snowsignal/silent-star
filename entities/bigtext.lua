local Vector = require 'hump.vector'

local BigText = {}

function BigText:new(x, y, size, msg, fadeOutTime)
    local font = love.graphics.setNewFont("assets/fonts/InkbitTwo.ttf", size)
    local text = love.graphics.newText(font, msg)
    return {
        bigtext = {
            text = text,
            fadeOutTime = fadeOutTime,
            initialFadeOut = fadeOutTime
        },
        pos = Vector(x, y),
    }
end

return BigText
