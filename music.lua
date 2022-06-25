-- There are initially fileName -> fileExt mappings and then become fileName -> source mappings.
-- Why? Because it looks nice
local sfx = {["game-start"] = "wav", ["menu-cancel"] = "wav", ["menu-close"] = "wav", ["menu-confirm"] = "wav", ["menu-navigate"] = "wav", ["menu-open"] = "wav", ["jump"] = "mp3"}
local tracks = {menu = "mp3"}

-- ye active music track
activeTrack = nil

-- Loads everything into memory and ensures that the game hogs resources
function loadSounds()
    for trackName, fileExt in pairs(tracks) do
        -- all you need is love
        tracks[trackName] = love.audio.newSource("assets/tracks/" .. trackName .. "." .. fileExt, "stream")
        tracks[trackName]:setLooping(true) -- this will be deathloop in 2013
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

-- only one at a time. loops automatically
function playTrack(trackName)
    if tracks[trackName] then
        stopMusic()
        activeTrack = tracks[trackName]
        activeTrack:play()
    end
end

-- stops the shitty OST
function stopMusic()
    if activeTrack then
        activeTrack:stop()
    end
end