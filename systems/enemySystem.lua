local tiny = require 'tiny'
local enemySystem = tiny.processingSystem()
enemySystem.filter = tiny.requireAll("enemy")

function enemySystem:process(e)
    if e.pos.y > 650 then
        tiny.removeEntity(self.world, e)
    end
    if e.enemy.canFire then
        e.enemy.canFire = false
        e.enemy.fire(e, self.world)
        self.world.timer:after(e.enemy.fireRate, function()
            e.enemy.canFire = true
        end)
    end
end

return enemySystem