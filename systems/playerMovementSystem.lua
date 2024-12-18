local tiny = require 'tiny'
local Projectile = require 'entities.projectile'
local playerMovementSystem = tiny.processingSystem()
playerMovementSystem.filter = tiny.requireAll("player", "vel")

playerFireRate = 0.125

function playerMovementSystem:process(e)
    local input = self.world.input

    if input:down('player-fire') and e.player.canFire then
        e.player.canFire = false
        self.world:add(Projectile:rectangleBullet(e.pos))
        self.world.timer:after(playerFireRate, function() e.player.canFire = true end)
    elseif input:down('player-secondary-fire') and e.player.canFire then
        e.player.canFire = false
        self.world:add(Projectile:secondaryBullet(e.pos, false))
        self.world:add(Projectile:secondaryBullet(e.pos, true))
        self.world.timer:after(playerFireRate * 3, function() e.player.canFire = true end)
    end

    if input:down('player-right') then
        e.vel.x = e.player.movespeed
    elseif input:down('player-left') then
        e.vel.x = -e.player.movespeed
    else
        e.vel.x = 0
    end

    if input:down('player-up') then
        e.vel.y = -e.player.movespeed
    elseif input:down('player-down') then
        e.vel.y = e.player.movespeed
    else
        e.vel.y = 0
    end
end

return playerMovementSystem