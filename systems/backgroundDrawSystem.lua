local backgroundDrawSystem = tiny.processingSystem({ draw = true })
backgroundDrawSystem.filter = tiny.requireAll("pos", "backimg")

function backgroundDrawSystem:process(e)
    local backimg_w = e.backimg:getWidth()
    local backimg_h = e.backimg:getHeight()
    local lg = love.graphics
    local scale = 1
    for y = 0 - e.pos.y % (backimg_h * scale), 600, backimg_h do
        for x = 0 - e.pos.x % (backimg_w * scale), 800, backimg_w do
            lg.draw(e.backimg, x, y, 0, scale, scale)
        end
    end
end

return backgroundDrawSystem
