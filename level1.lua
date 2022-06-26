local Level1 = {}

local Player = require 'entities.player'

function Level1:enter()
    print("Entered level!")
    playTrack("level1")
    -- Set up tiny world
end

return Level1