local Wave = {}

function Wave:new(waveSegments)
    return {
        segments = waveSegments,
        readyToAdvance = true
    }
end

return Wave