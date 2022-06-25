-- There are initially fileName -> fileExt mappings and then become fileName -> source mappings.
-- Why? Because it looks nice
local sfx = {["game-start"] = "wav", ["menu-cancel"] = "wav", ["menu-close"] = "wav", ["menu-confirm"] = "wav", ["menu-navigate"] = "wav", ["menu-open"] = "wav", ["jump"] = "mp3"}
local tracks = {menu = "mp3", level1 = "mp3"}
local tween = require 'tween'

-- ye active music track
activeTrackName = nil
activeTrack = nil

fadeOutTween = tween.new(1, {}, {}, tween.easing.linear)

fadeOutVolume = { volume = 1 }

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
    end
end

function stopMusicWithFadeout(duration)
    fadeOutVolume = { volume = 1}
    fadeOutTween = tween.new(duration, fadeOutVolume, { volume = 0 }, tween.easing.linear)
end

-- only one at a time. loops automatically
function playTrack(trackName)
    if tracks[trackName] then
        stopMusic()
        activeTrackName = trackName
        activeTrack = love.audio.newSource(tracks[trackName])
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