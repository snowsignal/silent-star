local tiny = require 'tiny'
local shockSystem = tiny.processingSystem()
shockSystem.filter = tiny.requireAll()

-- The Shock System controls the events of the game, tactfully throwing enemies at the player,
-- and causing player death. It is basically the story controller, if you will
function shockSystem:process(e)

end

return shockSystem