local Cutscene = {}

local function __NULL__() end

function Cutscene:new(segments, afterFadeOut, fadein, fadeout)
    local cutscene = {
        segments = segments,
        afterFadeOut = afterFadeOut or __NULL__,
        toRender = {},
        fadein = fadein or 1,
        fadeout = fadeout or 1,
        state = "fadein",
        fadeInTimer = nil,
        waitTillNextTimer = nil,
        fadeOutTimer = nil,
    }

    local SPACING = 30

    local lastTextAlpha = 0

    function cutscene:draw()
        local y = SPACING
        for index, segment in ipairs(self.toRender) do
            if index == #self.toRender then
                    love.graphics.setColor(1,1,1, lastTextAlpha)
            else
                love.graphics.setColor(1,1,1,1)
            end
            local lineSpacing = 0
            for _, textLine in ipairs(segment.text) do
                love.graphics.draw(textLine, 400 - textLine:getWidth() / 2, y + lineSpacing)
                lineSpacing = lineSpacing + textLine:getHeight() + 5
            end
            y = y + SPACING + lineSpacing
        end
    end

    function cutscene:update(dt)
        if self.state == "fadein" then
            self.toRender[#self.toRender+1] = self.segments[#self.toRender+1]
            lastTextAlpha = 0
            self.fadeInTimer = Timer.during(self.fadein, function() lastTextAlpha = self.fadeInTimer.time / self.fadein end, function()
                cutscene.state = "waitfornext"
            end)
            self.state = "awaiting"
        elseif self.state == "waitfornext" then
            self.waitTillNextTimer = Timer.after(#self.toRender > 0 and self.toRender[#self.toRender].waitTillNext or 0, function()
                if #self.segments == #self.toRender then
                    self.state = "fadeout"
                else
                    self.state = "fadein"
                end
            end)
            self.state = "awaiting"
        elseif self.state == "fadeout" then
            lastTextAlpha = 1
            self.fadeOutTimer = Timer.after(self.fadeout, function()
                self:afterFadeOut()
            end)
            self.state = "awaiting"
        end
    end


    return cutscene
end

return Cutscene