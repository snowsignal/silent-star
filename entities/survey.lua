local Survey = {questionWrapLimit = 600, answerWrapLimit = 300, font = love.graphics.setNewFont("assets/fonts/VCR_OSD_MONO.ttf", 20)}
local utils = require 'utils'

function wrapText(text, wrapLimit)
    _, wrappedText = Survey.font:getWrap(text, wrapLimit)
    wrappedText = utils.map(wrappedText, function(t) return love.graphics.newText(Survey.font, t) end)
    return wrappedText
end

function Survey:question(text, fx)
    return {
        text = wrapText(text, self.questionWrapLimit),
        fx = fx,
    }
end

function Survey:answer(text, fx)
    return {
        text = wrapText(text, self.answerWrapLimit),
        fx = fx
    }
end

function Survey:new(question, answers)
    return {
        question = question,
        answers = answers,
    }
end

return Survey