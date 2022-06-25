local backgroundDrawSystem = tiny.processingSystem({ draw = true })
--backgroundDrawSystem.filter = tiny.requireAll()

local backimg = love.graphics.newImage("assets/stars.png")
backimg:setFilter("nearest", "nearest")
backimg:setWrap("repeat", "repeat")
local backimg_w = backimg:getWidth()
local backimg_h = backimg:getHeight()

function backgroundDrawSystem:update(dt)
    --self.world.camera:detach()
    local lg = love.graphics
    local scale = 1
    local cpos = self.world.camera.camera:position()
    for y = 0 - cpos.y % (backimg_h * scale), 600, backimg_h do
        for x = 0 - cpos.x % (backimg_w * scale), 800, backimg_w do
            lg.draw(backimg, x, y, 0, scale, scale)
        end
    end
    --self.world.camera:attach()
end

return backgroundDrawSystem
