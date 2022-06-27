local tiny = require 'tiny'
local Explosion = require 'entities.explosion'
local velocitySystem = tiny.processingSystem()
velocitySystem.filter = tiny.requireAll("pos", "vel")

function collideFilter(item, other)
    if item.enemy and other.projectile then
        return "cross"
    elseif item.player and other.projectile and not other.projectile.friendly then
        return "cross"
    elseif item.player and other.boundary then
        return "slide"
    elseif item.player and other.enemy then
        return "cross"
    end
    return nil
end

function velocitySystem:process(e, dt)
    local target = e.pos + e.vel * dt

    if e.player and e.player.invincibility > 0 then
        e.player.invincibility = e.player.invincibility - dt
    end

    if e.size then
        local actual_x, actual_y, collisions, _ = self.world.bump:move(e, target.x, target.y, collideFilter)
        for _, col in ipairs(collisions) do
            if e.enemy and col.other.projectile and col.other.projectile.friendly then
                e.enemy.health = e.enemy.health - col.other.projectile.damage
                tiny.removeEntity(self.world, col.other)
                self.world:add(Explosion:new(col.other.pos, Vector(0.2, 0.2)))
                if e.enemy.health <= 0 then
                    tiny.removeEntity(self.world, e)
                    score = score + e.enemy.score
                    self.world:add(Explosion:new(col.other.pos, Vector(2, 2)))
                    return
                end
            elseif e.player and not (e.player.invincibility > 0) and (col.other.projectile or col.other.enemy) then
                e.player.lives = e.player.lives - 1
                if col.other.projectile then
                    tiny.removeEntity(self.world, col.other)
                    self.world:add(Explosion:new(col.other.pos, Vector(0.2, 0.2)))
                end
                if e.player.lives < 0 then
                    tiny.removeEntity(self.world, e)
                    self.world.killed = true
                    self.world.killedPos = e.pos
                end
                e.player.invincibility = defaultInvincibility
            end
        end
        e.pos = Vector(actual_x, actual_y)
    else
        e.pos = target
    end
end

return velocitySystem