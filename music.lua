-- There are initially fileName -> fileExt mappings and then become fileName -> source mappings.
-- Why? Because it looks nice
local sfx = {glitch01 = "wav"}
local tracks = {menu = "mp3", level1 = "mp3", finalDecision = "ogg"}
local tween = require 'tween'

-- ye active music track
activeTrackName = nil
activeTrack = nil

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

local function stopMusicTween(duration, func)
    local fadeOutVolume = { volume = 1}
    local fadeOutTween = tween.new(duration, fadeOutVolume, { volume = 0 }, tween.easing.linear)

    -- Hook into the update callback
    local previousUpdate = love.update
    function love.update(...)
        previousUpdate(...)
        if not fadeOutTween:update(...) then
            if activeTrack then
                func(fadeOutVolume)
            end
        end
    end
end

function stopMusicWithFadeout(duration)
    stopMusicTween(duration, function(t)
        activeTrack:setVolume(t.volume)
    end)
end

function stopMusicWithFadeoutAndSlowDown(duration)
    stopMusicTween(duration, function(t)
        activeTrack:setPitch(t.volume + 0.01)
        activeTrack:setVolume(t.volume)
    end)
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

-- stops the shitty OST
function stopMusic()
    if activeTrack then
        activeTrack:stop()
        activeTrackName = nil
    end
end