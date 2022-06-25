local Cutscene = {}

function Cutscene:new(segments, fadein, fadeout)
    return {
        segments = segments,
        fadein = fadein or 1,
        fadeout = fadeout or 1
    }
end

function Cutscene:enter()
    self.toRender = {}

end

function Cutscene:draw()

end

function Cutscene:update()

end

return Cutscene