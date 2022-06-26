local tiny = require 'tiny'
local enemySystem = tiny.processingSystem()
enemySystem.filter = tiny.requireAll()

function enemySystem:process(e)

end

return enemySystem