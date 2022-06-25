local bigTextDrawSystem = tiny.processingSystem({ draw = true })
bigTextDrawSystem.filter = tiny.requireAll("bigtext", "pos")

local lg = love.graphics

local tb = {
    Vector(-1, -1),
    Vector(-1, 0),
    Vector(-1, 1),
    Vector(0, -1),
    Vector(0, 1),
    Vector(1, -1),
    Vector(1, 0),
    Vector(1, 1),
}
function bigTextDrawSystem:process(e)
    self.world.camera:detach()
    lg.setColor({0, 0, 0, e.bigtext.fadeOutTime / e.bigtext.initialFadeOut})
    for _, v in ipairs(tb) do
        lg.draw(e.bigtext.text, e.pos.x + v.x * 2, e.pos.y + v.y * 2)
    end
    lg.setColor({1, 1, 1, e.bigtext.fadeOutTime / e.bigtext.initialFadeOut})
    lg.draw(e.bigtext.text, e.pos.x, e.pos.y)
    self.world.camera:attach()
end

return bigTextDrawSystem
