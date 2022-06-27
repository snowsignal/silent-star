local Level1 = {}

deaths = 0
score = 0

explosionWait = 3
answerSelectWait = 2

local finale = require 'finale'

local tiny = require 'tiny'

local backgroundDrawSystem = require 'systems.backgroundDrawSystem'
local damageSystem = require 'systems.damageSystem'
local playerDrawSystem = require 'systems.playerDrawSystem'
local playerMovementSystem = require 'systems.playerMovementSystem'

local shockSystem = require 'systems.shockSystem'
local Story = require 'entities.story'

local enemySystem = require 'systems.enemySystem'
local enemyDrawSystem = require 'systems.enemyDrawSystem'

local projectileDrawSystem = require 'systems.projectileDrawSystem'

local bumpSystem = require 'systems.bumpSystem'

local surveyScene = require 'surveyScene'

local Explosion = require 'entities.explosion'

local explosionDrawSystem = require 'systems.explosionDrawSystem'

local Input = require 'boipushy'

local Wave = require 'entities.wave'

local Enemy = require 'entities.enemy'

local Background = require 'entities.background'

local Player = require 'entities.player'

local drawSystemFilter = tiny.requireAll("draw")
local updateSystemFilter = tiny.rejectAll("draw")

local waveFont = love.graphics.newFont("assets/fonts/VCR_OSD_MONO.ttf", 30)

function Level1:drawBar()
    local PADDING = 15
    local playerLives
    for _, ent in ipairs(self.world.entities) do
        if ent.player then
            playerLives = ent.player.lives
        end
    end
    if playerLives then
        local extraLives = string.format("Extra Lives: %d", playerLives)
        love.graphics.printf(extraLives, waveFont, PADDING, 0 + PADDING, 1000)
    end
    local score = string.format("Score: %d", score)
    love.graphics.printf(score, waveFont, 400 - waveFont:getWidth(score) / 4 - PADDING, 0 + PADDING, 1000)
    local wave = string.format("Wave:%d/%d", self.world.wave, self.world.wavetotal)
    love.graphics.printf(wave, waveFont, 800 - waveFont:getWidth(wave) - PADDING, 0 + PADDING, 1000)
end

local topBoundary = { pos = Vector(400, 1), size= Vector(800, 1), boundary = {}}
local bottomBoundary = { pos = Vector(400, 599), size = Vector(800, 1), boundary = {}}
local leftBoundary = { pos = Vector(1, 300), size = Vector(1, 600), boundary = {}}
local rightBoundary =  { pos = Vector(799, 300), size = Vector(1, 600), boundary = {}}

function Level1:enter()
    print("Entered")
    playTrack("level1")
    -- Set up tiny world
    self.world = tiny.world(
            backgroundDrawSystem,
            projectileDrawSystem,
            enemyDrawSystem,
            playerDrawSystem,
            explosionDrawSystem,
            playerMovementSystem,
            enemySystem,
            damageSystem,
            bumpSystem,
            Player:new(300, 300),
            Background:new("stars"),
            topBoundary,
            bottomBoundary,
            leftBoundary,
            rightBoundary
    )
    self.world.timer = Timer.new()
    self.world.canvas = love.graphics.newCanvas()

    self.world.stage = {
        type = "normal"
    }

    self.world:add(shockSystem)

    function swarmWave(wave)
        self.world.remainingEnemies = 15
        return self.world.timer:every(0.4, function()
            if self.world.remainingEnemies <= 0 then
                wave.readyToAdvance = true
                return
            end
            local vel = Vector(0, 400)
            self.world:add(Enemy:spawnBasicShip(Vector(math.random(50, 750), -50), vel))
            self.world.remainingEnemies = self.world.remainingEnemies - 1
        end)
    end

    function concentratedWave(loc)
        return function(wave)
            self.world.remainingEnemies = 50
            return self.world.timer:every(0.15, function()
                if self.world.remainingEnemies <= 0 then
                    wave.readyToAdvance = true
                    return
                end
                local vel = Vector(0, 600)
                self.world:add(Enemy:spawnBasicShip(Vector(loc + math.random(-10, 10), -50), vel))
                self.world.remainingEnemies = self.world.remainingEnemies - 1
            end)
        end
    end

    function mineWave(number, start)
        number = number or 4
        start = start or 100
        return function(wave)
            self.world.remainingEnemies = number
            local y = start
            local left = false
            return self.world.timer:every(0.01, function()
                y = y + ((600 - start) / number)
                left = not left
                if self.world.remainingEnemies <= 0 then
                    wave.readyToAdvance = true
                    return
                end
                local vel
                if left then
                    vel = Vector(250,0)
                else
                    vel = Vector(-250,0)
                end
                local pos
                if left then
                    pos = Vector(-50, y)
                else
                    pos = Vector(850, y)
                end
                self.world:add(Enemy:spawnMineLayer(pos, vel))
                self.world.remainingEnemies = self.world.remainingEnemies - 1
            end)
        end
    end

    function exploderWave(number, start)
        number = number or 4
        start = start or 100
        return function(wave)
            self.world.remainingEnemies = number
            local y = start
            local left = false
            return self.world.timer:every(0.01, function()
                y = y + ((600 - start) / number)
                left = not left
                if self.world.remainingEnemies <= 0 then
                    wave.readyToAdvance = true
                    return
                end
                local vel
                if left then
                    vel = Vector(250,0)
                else
                    vel = Vector(-250,0)
                end
                local pos
                if left then
                    pos = Vector(-50, y)
                else
                    pos = Vector(850, y)
                end
                self.world:add(Enemy:spawnExplosionLayer(pos, vel))
                self.world.remainingEnemies = self.world.remainingEnemies - 1
            end)
        end
    end

    function shootingWave(wave)
        self.world.remainingEnemies = 20
        return self.world.timer:every(0.5, function()
            if self.world.remainingEnemies <= 0 then
                wave.readyToAdvance = true
                return
            end
            vel = Vector(0, 220)
            self.world:add(Enemy:spawnShooterShip(Vector(math.random(300, 600), -50), vel))
            self.world.remainingEnemies = self.world.remainingEnemies - 1
        end)
    end

    function fastShooterWave(wave)
        self.world.remainingEnemies = 40

        return self.world.timer:every(1, function()
            if self.world.remainingEnemies <= 0 then
                wave.readyToAdvance = true
                return
            end
            local vel = Vector(math.random(0, 100), math.random(300, 700))
            local vel2 = Vector(-vel.x, vel.y)
            self.world:add(Enemy:spawnFastShooter(Vector(math.random(0, 800), -50), vel, vel2))
            self.world.remainingEnemies = self.world.remainingEnemies - 1
        end)
    end

    function repeatLast(amount, for_)
        local counter = amount

        return function(wave)
            if counter > 0 then
                counter = counter - 1
                shockSystem.waveSegmentIndex = shockSystem.waveSegmentIndex - (for_ + 1)
            end
            wave.readyToAdvance = true
        end
    end

    function simultaneous(s1, s2)
        local world = self.world
        return function (wave)
            h1 = s1(wave)
            h2 = s2(wave)
            local timers = {h1, h2}
            function timers:cancel()
                for _, handle in ipairs(self) do
                    world.timer:cancel(handle)
                end
            end
            return timers
        end
    end

    self.world:add(Story:new({
        Wave:new({
            function(wave)
                return self.world.timer:after(5, function()
                    wave.readyToAdvance = true
                end)
            end,
            swarmWave,
            concentratedWave(300),
            concentratedWave(600),
            mineWave(),
            simultaneous(concentratedWave(50), concentratedWave(750)),
            simultaneous(swarmWave, shootingWave)
        }),
        Wave:new({
            function(wave)
                for _, ent in ipairs(self.world.entities) do
                    if ent.backimg then
                        ent.vel = ent.vel * 1.5
                    end
                end
                self.world.shader = abberationShader
                abberationShader:send("punch", 0.5)
                self.world.stage = { type = "weird" }
                playSfx("glitch01")
                return self.world.timer:after(2, function()
                    wave.readyToAdvance = true
                    playTrack("level1")
                    musicSettings.pitchOffset = 0.3
                    resumeMusicWithFadeIn(3)
                end)
            end,
            mineWave(6),
            fastShooterWave,
            simultaneous(fastShooterWave, concentratedWave(400)),
            exploderWave(),
            simultaneous(fastShooterWave, swarmWave),
            exploderWave(5),
            repeatLast(2, 2)
        }),
        Wave:new({
            function(wave)
                self.world.stage = { type = "finale" }
                self.world.wavetotal = 999
                for _, ent in ipairs(self.world.entities) do
                    if ent.backimg then
                        ent.vel = ent.vel * 1.5
                    end
                end

                abberationShader:send("punch", 0.75)

                self.world.remainingEnemies = 300

                local deathsSinceWaveStart = deaths

                return self.world.timer:every(0.05, function()
                    musicSettings.pitchOffset = musicSettings.pitchOffset + 0.0001
                    if activeTrack and not activeMusicTween then
                        love.audio.setVolume(1 + musicSettings.pitchOffset)
                    end
                    if deathsSinceWaveStart < deaths then
                        deathsSinceWaveStart = deaths
                        self.world.remainingEnemies = 300
                    end
                    if self.world.remainingEnemies <= 0 then
                        wave.readyToAdvance = true
                        return
                    end
                    local playerPos
                    for _, ent in ipairs(self.world.entities) do
                        if ent.player then
                            playerPos = ent.pos
                        end
                    end
                    local vel = Vector(0, math.random(800, 1000 + musicSettings.pitchOffset * 10))
                    if playerPos then
                        self.world:add(Enemy:spawnBasicShip(Vector(playerPos.x, -50), vel))
                        self.world.remainingEnemies = self.world.remainingEnemies - 1
                    end
                end)
            end
        }),
        Wave:new({
            function(wave)
                self.world.wavetotal = 4
                stopMusic()
                musicSettings.pitchOffset = 0
                playSfx("wavecomplete")
                for _, ent in ipairs(self.world.entities) do
                    if ent.backimg then
                        ent.vel = ent.vel * 3
                    end
                end
                return self.world.timer:after(5, function()
                    Gamestate.switch(finale)
                end)
            end
        })
    }, {}))

    self.world.wave = 1
    self.world.wavetotal = 8

    self.world.input = Input()
    self.world.input:bind('right', 'player-right')
    self.world.input:bind('left', 'player-left')
    self.world.input:bind('up', 'player-up')
    self.world.input:bind('down', 'player-down')
    self.world.input:bind('d', 'player-right')
    self.world.input:bind('a', 'player-left')
    self.world.input:bind('w', 'player-up')
    self.world.input:bind('s', 'player-down')
    self.world.input:bind('z', 'player-fire')
    self.world.input:bind('x', 'player-secondary-fire')
end

-- https://gafferongames.com/post/fix_your_timestep/
-- https://gamedev.stackexchange.com/questions/165949/keep-platformer-jump-height-consistent-with-different-frame-rates
-- Lol didnt read
local accum = 0
local frametarget = 1/60
function Level1:update(dt)
    self.world.timer:update(dt)
    if self.world.killed and not self.world.shownExplosion then
        self.world.shownExplosion = true
        playSfx("death")
        pauseMusicWithFadeoutAndSlowDown(3)
        self.world:add(Explosion:new(self.world.killedPos, Vector(3.5, 3.5)))
        self.world:refresh()
        self.world.timer:after(explosionWait, function()
            Gamestate.push(surveyScene:next(self.world.stage))
        end)
    else
        accum = accum + dt
        while accum > frametarget do
            self.world:update(frametarget, updateSystemFilter)
            accum = accum - frametarget
            self.world.input:update()
        end
    end
end

function Level1:draw()
    love.graphics.setShader()
    love.graphics.setCanvas(self.world.canvas)
    self.world:update(dt, drawSystemFilter)
    self:drawBar()

    love.graphics.setCanvas()
    if self.world.shader then
        love.graphics.setShader(self.world.shader)
    end
    love.graphics.draw(self.world.canvas)
end

function Level1:resume()
    resumeMusicWithFadeIn(2)
    deaths = deaths + 1
    self.world.killed = false
    self.world:add(Player:new(self.world.killedPos.x, self.world.killedPos.y))
    self.world.killedPos = nil
    self.world.shownExplosion = false
    self.world:refresh()
end

return Level1