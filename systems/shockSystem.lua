-- The Shock System controls the events of the game, tactfully throwing enemies at the player,
-- and causing player death. It is basically the story controller, if you will.

local tiny = require 'tiny'

local finale = require 'finale'

local shockSystem = tiny.processingSystem()
shockSystem.filter = tiny.requireAll("story")

function shockSystem:nextWaveSegment()
    self.waveSegmentIndex = self.waveSegmentIndex + 1
    if not self.wave or self.waveSegmentIndex > #self.wave.segments then
        return false
    end
    self:updateWave()
    return true
end

function shockSystem:nextWave()
    self.waveSegmentIndex = 1
    self.world.wave = self.world.wave + 1
    if self.world.wave > self.waveTotal then
        return false
    end
    self:updateWave()
    return true
end

function shockSystem:updateWave()
    self.wave = self.story.waves[self.world.wave]
    self.waveSegment = self.wave.segments[self.waveSegmentIndex]
end

function shockSystem:onAdd(e)
    if self.story then
        print("Initialized shockSystem twice")
        love.quit()
    end
    -- Set up callbacks
    self.story = e.story
    self.world.wave = 0
    self.waveSegmentIndex = 1
    self.waveTotal = #self.story.waves
end

function shockSystem:process()
    -- Check if we can continue
    if not self.wave or self.wave.readyToAdvance then
        if self.waveTimer then
            if self.waveTimer.cancel then
                self.waveTimer:cancel()
            else
                self.world.timer:cancel(self.waveTimer)
            end
        end
        if not self:nextWaveSegment() then
            if not self:nextWave() then
                Gamestate.switch(finale)
                return
            end
        end
        self.wave.readyToAdvance = false
        self.waveTimer = self.waveSegment(self.wave)
    end
end

return shockSystem