local SurveyScene = {}

function SurveyScene:new(survey)
    local surveyScene = { survey = survey }

    function surveyScene:enter()
        Timer.after(2, function() Gamestate.pop() end)
    end

    function surveyScene:update(dt)

    end

    function surveyScene:draw()

    end

    return surveyScene
end

function SurveyScene:normal()
    return SurveyScene:new({})
end

return SurveyScene