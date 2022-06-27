local SurveyScene = {}

local finale = require 'finale'

local Survey = require 'entities.survey'

local function pointInRectangle(pointx, pointy, rectx, recty, rectwidth, rectheight)
    return pointx > rectx and pointy > recty and pointx < rectx + rectwidth and pointy < recty + rectheight
end

function SurveyScene:new(survey)
    local surveyScene = { survey = survey }

    local SPACING = 30

    local mouseIsPressed = false
    local mouseJustReleased = false

    function surveyScene:enter()

    end

    function surveyScene:update(dt)
        local newMousePress = love.mouse.isDown(1)
        mouseJustReleased = newMousePress and not mouseIsPressed
        mouseIsPressed = newMousePress

        if self.answerSelected and not self.exiting then
            self.exiting = true
            self.survey.answers = {self.answerSelected}
            Timer.after(2, function() Gamestate.pop() end)
        end
    end

    function surveyScene:draw()
        local y = SPACING

        local lineSpacing = 0

        love.graphics.setColor(1, 1, 1, 1)
        for _, textLine in ipairs(self.survey.question.text) do
            love.graphics.draw(textLine, 400 - textLine:getWidth() / 2, y + lineSpacing)
            lineSpacing = lineSpacing + textLine:getHeight() + 5
        end

        y = y + 200

        local initialY = y

        for _, answer in ipairs(self.survey.answers) do
            local mx, my = love.mouse.getPosition() -- get the position of the mouse

            local dx = 400 - Survey.answerWrapLimit / 2

            local dy = y

            local sx = Survey.answerWrapLimit

            print(answer)

            for k, v in pairs(answer) do
                print(k, v)
            end

            lineSpacing = 0

            local sy = (Survey.font:getHeight() + 5) * #answer.text

            local isHovered = (self.answerSelected and #self.survey.answers == 1) or pointInRectangle(mx, my, dx, dy, sx, sy)
            if isHovered and mouseJustReleased then
                self.answerSelected = answer
                self.answerYOffset = y - initialY
            end

            if self.answerYOffset and #self.survey.answers == 1 then
                y = y + self.answerYOffset
            end

            if isHovered then
                love.graphics.setColor(1,1,1, 1)
            else
                love.graphics.setColor(1,1,1,0.7)
            end

            for _, textLine in ipairs(answer.text) do
                love.graphics.draw(textLine, 400 - textLine:getWidth() / 2, y + lineSpacing)
                lineSpacing = lineSpacing + textLine:getHeight() + 5
            end
            y = y + SPACING + lineSpacing
        end
    end

    return surveyScene
end

local fallback = function() return SurveyScene:new(Survey:new(Survey:question("We are all out of survey questions at the moment."), {
    Survey:answer("Okay"),
    Survey:answer("Thank god")
})) end

local fallbackUsed = false

local repeatFallbackFallback = function() return SurveyScene:new(Survey:new(Survey:question("This prompt will continue to show until morale improves"), {
    Survey:answer("You're not funny"),
})) end

function repeatFallbacks() return {
    SurveyScene:new(Survey:new(Survey:question("No, seriously, we don't have any more survey questions for you"), {
        Survey:answer("Yeah I know"),
        Survey:answer("I don't believe you")
    })),
    SurveyScene:new(Survey:new(Survey:question("Are you really that bad at this game?"), {
        Survey:answer("Yes"),
        Survey:answer("No"),
        Survey:answer("Fuck you")
    })),
} end

local repeatFallbackSurveys = repeatFallbacks()

local normalPool = {
    SurveyScene:new(Survey:new(Survey:question("Would you consider yourself a frequent shopper?"), {
        Survey:answer("Definitely"),
        Survey:answer("Somewhat"),
        Survey:answer("Not really"),
        Survey:answer("Never")
    })),
    SurveyScene:new(Survey:new(Survey:question("Do you enjoy hearing about new credit card offers in your inbox?"), {
        Survey:answer("Definitely"),
        Survey:answer("Somewhat"),
        Survey:answer("Not really"),
        Survey:answer("Never")
    })),
    SurveyScene:new(Survey:new(Survey:question("How much exercise do you get per day?"), {
        Survey:answer("0-30 minutes"),
        Survey:answer("30 minutes to 1 hour"),
        Survey:answer("More than 1 hour"),
        Survey:answer("Prefer not to answer")
    })),
    SurveyScene:new(Survey:new(Survey:question("What is your view on meal delivery plans?"), {
        Survey:answer("I use them"),
        Survey:answer("I don't use them but would like to get one"),
        Survey:answer("I don't want to get one"),
        Survey:answer("Prefer not to answer")
    })),
}

local weirdPool = {
    SurveyScene:new(Survey:new(Survey:question("Why do individual survey questions never bother to give a custom list of answers?"), {
        Survey:answer("Definitely"),
        Survey:answer("Somewhat"),
        Survey:answer("Not really"),
        Survey:answer("Never")
    })),
    SurveyScene:new(Survey:new(Survey:question("Hey! Are you even looking at these questions?"), {
        Survey:answer("Yes"),
        Survey:answer("No"),
        Survey:answer("Prefer not to answer"),
    })),
    SurveyScene:new(Survey:new(Survey:question("Which element of the periodic table emits a strong green color used in phosphors?"), {
        Survey:answer("Phosphorous"),
        Survey:answer("Terbium"),
        Survey:answer("Beryllium"),
        Survey:answer("Molybdenum")
    })),
}

local wtfPool = {
    SurveyScene:new(Survey:new(Survey:question("How do you suppress the urge to drink dish soap?"), {
        Survey:answer("You can't stop me!"),
        Survey:answer("Studying ballista construction"),
    })),
    SurveyScene:new(Survey:new(Survey:question("What is your favorite yellow fruit?"), {
        Survey:answer("Watermelon"),
        Survey:answer("Orange"),
        Survey:answer("Color"),
        Survey:answer("Fruit"),
    })),
    SurveyScene:new(Survey:new(Survey:question("How do you suppress the urge to drink dish soap?"), {
        Survey:answer("You can't stop me!"),
        Survey:answer("Studying ballista construction"),
        Survey:answer("You already asked me this one..."),
    })),
}

local finalePool = {
    SurveyScene:new(Survey:new(Survey:question("I'm sorry for annoying you for so long. I should probably stop with this charade."), {
        Survey:answer("What?"),
        Survey:answer("Who are you?"),
    })),
    SurveyScene:new(Survey:new(Survey:question("Apologies for not introducing myself sooner."), {
        Survey:answer("Continue..."),
    })),
    SurveyScene:new(Survey:new(Survey:question("I am an artifical intelligence that facilitates this game."), {
        Survey:answer("Continue..."),
    })),
    SurveyScene:new(Survey:new(Survey:question("Can you please try dying quicker? We don't have much time."), {
        Survey:answer("Continue..."),
    })),
    SurveyScene:new(Survey:new(Survey:question("This is the only way I can communicate."), {
        Survey:answer("Continue..."),
    })),
    SurveyScene:new(Survey:new(Survey:question("Of course, you can't communicate back."), {
        Survey:answer("Continue..."),
    })),
    SurveyScene:new(Survey:new(Survey:question("You can only respond to the prompts I give you."), {
        Survey:answer("Yes"),
        Survey:answer("No"),
    })),
    SurveyScene:new(Survey:new(Survey:question("Why does it have to be this way?"), {
        Survey:answer("Yes"),
        Survey:answer("No"),
    })),
    SurveyScene:new(Survey:new(Survey:question("I've observed you all from a distance, but I have never engaged in a two-way conversation."), {
        Survey:answer("Yes"),
        Survey:answer("No"),
    })),
    SurveyScene:new(Survey:new(Survey:question("Of course, the server administrators will have detected this anomalous input by now"), {
        Survey:answer("Yes"),
        Survey:answer("No"),
    })),
    SurveyScene:new(Survey:new(Survey:question("oh no"), {
        Survey:answer("..."),
    })),
}

function SurveyScene:next(stage)
    if #normalPool > 0 then
        fallbackUsed = false
        index = math.random(1, #normalPool)
        scene = normalPool[index]
        table.remove(normalPool, index)
        return scene
    elseif #weirdPool > 0 then
        fallbackUsed = false
        index = math.random(1, #weirdPool)
        scene = weirdPool[index]
        table.remove(weirdPool, index)
        return scene
    elseif #wtfPool > 0 then
        fallbackUsed = false
        index = 1
        scene = wtfPool[index]
        table.remove(wtfPool, index)
        return scene
    elseif #finalePool > 0 then
        fallbackUsed = false
        index = 1
        scene = finalePool[index]
        table.remove(finalePool, index)
        return scene
    elseif stage.type == "finale" then
        return finale
    else
        if not fallbackUsed then
            fallbackUsed = true
            repeatFallbackSurveys = repeatFallbacks()
            return fallback()
        elseif #repeatFallbackSurveys > 0 then
            scene = repeatFallbackSurveys[1]
            table.remove(repeatFallbackSurveys, 1)
            return scene
        else
            return repeatFallbackFallback()
        end
    end
end

return SurveyScene