local WaveSegment = {}

function WaveSegment:waitUntilAllDead()
    return { type = "allDead"}
end

function WaveSegment:waitSeconds(duration)
    return { type = "waitSeconds", duration = duration }
end

function WaveSegment:new(enemy, waitUntil)
    return {
        enemy = enemy,
        waitUntil = waitUntil
    }
end

return WaveSegment