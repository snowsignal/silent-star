local Wave = {}

function Wave:new(wageSegments)
    return {
        wave = {
            waveSegments = waveSegments
        }
    }
end

return Wave