local Survey = {}

local questionWrapLimit = 600
local answerWrapLimit = 300

local font = love.graphics.setNewFont("assets/fonts/VCR_OSD_MONO.ttf", 20)

function wrapText(text, wrapLimit)
    _, wrappedText = font:getWrap(text, wrapLimit)
    wrappedText = utils.map(wrappedText, function(t) return love.graphics.newText(font, t) end)
end

function Survey:question(text, fx)
    return {
        text = wrapText(text, questionWrapLimit),
        fx = fx,
    }
end

function Survey:answer(text, fx)
    _, wrappedText = font:getWrap(text, wrapLimit)
    wrappedText = utils.map(wrappedText, function(t) return love.graphics.newText(font, t) end)
    return {
        text = wrapText(text, answerWrapLimit),
        fx = fx
    }
end

function Survey:new(question, answers)
    return {
        survey = {
            questions = questions
        }
    }
end

return Survey