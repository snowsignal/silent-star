local bigTextSystem = tiny.processingSystem()
bigTextSystem.filter = tiny.requireAll("bigtext")

function bigTextSystem:process(e, dt)
    e.bigtext.fadeOutTime = e.bigtext.fadeOutTime - dt
    if e.bigtext.fadeOutTime < 0 then
        tiny.remove(self.world, e)
    end
end

return bigTextSystem