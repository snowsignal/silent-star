local Explosion = {}

function Explosion:new(pos, scale)
    local totalFrames = 8
    local spriteSheet = love.graphics.newImage("assets/Explosion.png")
    local spritelist = {}
    for i = 1, spriteSheet:getWidth() / totalFrames do
        spritelist[#spritelist+1] = love.graphics.newQuad(32 * (i-1), 0, 32, 32, spriteSheet:getDimensions())
    end
    return {
        pos = pos,
        size = Vector(32, 32),
        scale = scale or Vector(1, 1),
        explosion = {
            spriteSheet = spriteSheet,
            spritelist = spritelist,
            nextFrame = 2 / 24,
            frame = 1,
            totalFrames = totalFrames
        }
    }
end

return Explosion