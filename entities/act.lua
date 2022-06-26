local Act = {}

function Act:new(surveys)
    return {
        act = {
            questionPool = surveys
        }
    }
end

return Act