local SurveyScene = {}

function SurveyScene:new(survey)
    local surveyScene = { survey = survey }

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