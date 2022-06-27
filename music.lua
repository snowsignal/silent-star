-- There are initially fileName -> fileExt mappings and then become fileName -> source mappings.
-- Why? Because it looks nice
local sfx = {glitch01 = "wav", death = "mp3", wavecomplete = "mp3"}
local tracks = {menu = "mp3", level1 = "mp3", finalDecision = "ogg"}

-- ye active music track
activeTrackName = nil
activeTrackPos = nil
activeTrack = nil

activeMusicTween = nil

-- Loads everything into memory and ensures that the game hogs resources
function loadSounds()
    for trackName, fileExt in pairs(tracks) do
        -- all you need is love
        tracks[trackName] = love.sound.newSoundData("assets/tracks/" .. trackName .. "." .. fileExt)
    end
    for sfxName, fileExt in pairs(sfx) do
        sfx[sfxName] = love.audio.newSource("assets/sfx/" .. sfxName .. "." .. fileExt, "static")
    end
end

-- play as many as you want. 
function playSfx(sfxName)
    if sfx[sfxName] then
        local sfx = sfx[sfxName]:clone()
        sfx:play()
    end
end

function getCurrentTrackNoise()
    if activeTrack and activeTrackName then
        local pos = activeTrack:tell("samples")
        return tracks[activeTrackName]:getSample(pos)
    else
        return 0
    end
end

local function musicTween(duration, vStart, vEnd, during, after)
    if activeMusicTween then
        Timer.cancel(activeMusicTween)
    end
    local fadeOutVolume = { volume = vStart}
    local differential = (vEnd - vStart) / duration
    activeMusicTween = Timer.during(duration, function(dt)
        fadeOutVolume.volume = fadeOutVolume.volume + differential * dt
        during(fadeOutVolume)
    end, after)
end

function stopMusicWithFadeout(duration)
    musicTween(duration, 1, 0, function(t)
        activeTrack:setVolume(t.volume)
    end, function()
        stopMusic()
    end)
end

function pauseMusicWithFadeoutAndSlowDown(duration)
    musicTween(duration, 1, 0, function(t)
        activeTrack:setPitch(t.volume + 0.01)
        activeTrack:setVolume(t.volume)
    end, function()
        pauseMusic()
    end)
end

function resumeMusicWithFadeIn(duration)

    musicTween(duration, 0, 1, function(t)
        if not activeTrack:isPlaying() then
            resumeMusic()
        end
        activeTrack:setPitch(t.volume + 0.01)
        activeTrack:setVolume(t.volume)
    end, function() end)
end

-- only one at a time. loops automatically
function playTrack(trackName)
    if tracks[trackName] then
        stopMusic()
        activeTrackName = trackName
        activeTrack = love.audio.newSource(tracks[trackName])
        activeTrack:setVolume(1)
        activeTrack:setLooping(true) -- this will be deathloop in 2013
        activeTrack:play()
    end
end

function stopMusic()
    if activeTrack then
        activeTrack:stop()
        activeTrackName = nil
        activeTrackPos = nil
        if activeMusicTween then
            Timer.cancel(activeMusicTween)
        end
    end
end

function pauseMusic()
    if activeTrack then
        activeTrackPos = activeTrack:tell("samples")
        activeTrack:pause()
    end
end

function resumeMusic()
    if activeTrack then
        activeTrack:play()
        activeTrack:seek(activeTrackPos, "samples")
    end
end