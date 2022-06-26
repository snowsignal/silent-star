local Background = {}

function Background:new(name, speed)
    local backimg = love.graphics.newImage(string.format("assets/%s.png", name))
    backimg:setFilter("nearest", "nearest")
    backimg:setWrap("repeat", "repeat")
    return {
        pos = Vector(),
        vel = Vector(0, speed or -120),
        backimg = backimg
    }
end

return Background