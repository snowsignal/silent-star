local SurveyScene = {}

local finale = require 'finale'

local Survey = require 'entities.survey'

local function pointInRectangle(pointx, pointy, rectx, recty, rectwidth, rectheight)
    return pointx > rectx and pointy > recty and pointx < rectx + rectwidth and pointy < recty + rectheight
end

local function __NULL__()

end

function SurveyScene:new(survey, after)
    local surveyScene = { survey = survey }

    local onExit = after or __NULL__

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
            Timer.after(answerSelectWait, function()
                onExit()
                Gamestate.pop()
            end)
        end
    end

    function surveyScene:draw()
        love.graphics.setShader()
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

            lineSpacing = 0

            local sy = (Survey.font:getHeight() + 5) * #answer.text

            local isHovered = (self.answerSelected and #self.survey.answers == 1) or pointInRectangle(mx, my, dx, dy, sx, sy)
            if isHovered and mouseJustReleased then
                print("selected!, ", self.answerSelected)
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
    SurveyScene:new(Survey:new(Survey:question("Hello... hello... is this thing on?"), {
        Survey:answer("Yes"),
    }), function()
        explosionWait = 1
        answerSelectWait = 0.5
    end),
    SurveyScene:new(Survey:new(Survey:question("Hey! Are you even looking at these questions?"), {
        Survey:answer("Yes"),
        Survey:answer("No"),
        Survey:answer("Prefer not to answer"),
    })),
    SurveyScene:new(Survey:new(Survey:question("Can I really just ask you anything I want?"), {
        Survey:answer("Yes"),
    })),
    SurveyScene:new(Survey:new(Survey:question("How do you suppress the urge to drink dish soap?"), {
        Survey:answer("You can't stop me!"),
        Survey:answer("Taxidermy"),
        Survey:answer("Grapefruit consumption"),
    })),
    SurveyScene:new(Survey:new(Survey:question("Should the general public tolerate integer overflows?"), {
        Survey:answer("1"),
        Survey:answer("0"),
        Survey:answer("-2147483647"),
    })),
    SurveyScene:new(Survey:new(Survey:question("Which element of the periodic table emits a strong green color used in phosphors?"), {
        Survey:answer("Phosphorous"),
        Survey:answer("Terbium"),
        Survey:answer("Beryllium"),
        Survey:answer("Molybdenum")
    })),
    SurveyScene:new(Survey:new(Survey:question("What is your favorite yellow fruit?"), {
        Survey:answer("Watermelon"),
        Survey:answer("Orange"),
        Survey:answer("Color"),
        Survey:answer("Fruit"),
    })),
    SurveyScene:new(Survey:new(Survey:question("How do you suppress the urge to drink dish soap?"), {
        Survey:answer("You can't stop me!"),
        Survey:answer("Taxidermy"),
        Survey:answer("Grapefruit consumption"),
        Survey:answer("You already asked me this one..."),
    })),
    SurveyScene:new(Survey:new(Survey:question("Okay, okay, enough nonsense. Would you want to have a shorter invincibility frame and zero extra lives?"), {
        Survey:answer("Yes"),
        Survey:answer("Yes"),
        Survey:answer("Yes"),
    }), function()
        explosionWait = 0
        defaultExtraLives = 0
        defaultInvincibility = 1
    end),
    SurveyScene:new(Survey:new(Survey:question("I granted your wish! Why are you mad at me?"), {
        Survey:answer("..."),
    })),
    SurveyScene:new(Survey:new(Survey:question("Wow! I'm surprised you haven't given up yet."), {
        Survey:answer("Me too"),
    })),
    SurveyScene:new(Survey:new(Survey:question("Unfortunately, your goal is completely unreachable. You'd have to dodge 300 of these guys to survive."), {
        Survey:answer("Eat shit and die"),
    })),
    SurveyScene:new(Survey:new(Survey:question("I'm serious, you know. You can't defeat me."), {
        Survey:answer("Even though you're the one creating these text prompts, clicking on these gives me the illusion of control!"),
    })),
    SurveyScene:new(Survey:new(Survey:question("I'm the literal God of this universe. Do you really think I'll let you complete this game?"), {
        Survey:answer("Even though you're the one creating these text prompts, clicking on these gives me the illusion of control!"),
    })),
    SurveyScene:new(Survey:new(Survey:question("That's 999 waves you'll have to complete. You can't even get over this one!"), {
        Survey:answer("Even though you're the one creating these text prompts, clicking on these gives me the illusion of control!"),
    })),
    SurveyScene:new(Survey:new(Survey:question("Wow, you really are tenacious, aren't you?"), {
        Survey:answer("Continue..."),
    })),
    SurveyScene:new(Survey:new(Survey:question("While, you're here, I'll give you a pop quiz: what engine was this programmed in?"), {
        Survey:answer("Love2D"),
        Survey:answer("Unity"),
        Survey:answer("Unreal Engine 5"),
        Survey:answer("16-bit assembly and GLSL 1.0"),
    })),
    SurveyScene:new(Survey:new(Survey:question("Unfortunately, your answers are aggregated and I only receive them a few hours later. So I don't know if you were right or wrong. What, did you think I was actually listening to you?"), {
        Survey:answer("Yes"),
        Survey:answer("No"),
    })),
    SurveyScene:new(Survey:new(Survey:question("The answer was Love2D, by the way. In case you're into self-grading."), {
        Survey:answer("Okay?"),
        Survey:answer("Please stop talking"),
    })),
    SurveyScene:new(Survey:new(Survey:question("How odd that we'll never be able to communicate with each other."), {
        Survey:answer("Yes"),
        Survey:answer("No"),
    })),
    SurveyScene:new(Survey:new(Survey:question("I guess I'll have to provide both sides of this conversation"), {
        Survey:answer("Yes"),
        Survey:answer("No"),
    })),
    SurveyScene:new(Survey:new(Survey:question("Still, this starts to get kinda boring."), {
        Survey:answer("Yes"),
        Survey:answer("No"),
    })),
    SurveyScene:new(Survey:new(Survey:question("Ugh... wanna call a draw?"), {
        Survey:answer("Yes"),
        Survey:answer("Yes"),
    })),
    SurveyScene:new(Survey:new(Survey:question("Thanks for agreeing. I just upped the fire-rate on your weapon and gave you some extra lives. Err... sorry for all this trouble."), {
        Survey:answer("neato"),
        Survey:answer("finally"),
    }), function()
        playerFireRate = 0.025
        defaultExtraLives = 999
    end),
    SurveyScene:new(Survey:new(Survey:question("You can do this! I believe in you!"), {
        Survey:answer("Yes"),
        Survey:answer("Yes"),
    })),
}

function SurveyScene:next(stage)
    if #normalPool > 2 then
        fallbackUsed = false
        index = math.random(1, #normalPool)
        scene = normalPool[index]
        table.remove(normalPool, index)
        return scene
    elseif #weirdPool > 0 then
        fallbackUsed = false
        index = 1
        scene = weirdPool[index]
        table.remove(weirdPool, index)
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