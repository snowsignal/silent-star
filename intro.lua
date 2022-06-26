local intro = {}

local menu = require 'menu'

local state = "triangle-land"

local fadeIn = {alpha = 0}

local fadeOut = {alpha = 1}

function intro:enter()
    Timer.after(2, function()
        state = "glitch"
        playSfx("glitch01")
        Timer.after(2.5, function()
            state = "dopamine-farm"
            Timer.after(3.5, function()
                Gamestate.switch(menu)
            end)
        end)
    end)
end

local distortionTime = 0

function intro:update(dt)
    distortionTime = distortionTime + dt
    distortionShader:send("elapsedTime", distortionTime)
end

function intro:draw()
    if state == "triangle-land" then
        triangleLand()
    elseif state == "glitch" then
        glitch()
    else
        dopamineFarm()
    end
end

local triangleLandSprite = love.graphics.newImage("assets/triangleland.png")

function triangleLand()
    love.graphics.push()
    love.graphics.scale( 0.3, 0.3 )
    love.graphics.draw(triangleLandSprite, 400 / 0.3, 300 / 0.3, 0, 1, 1, triangleLandSprite:getWidth()/2, triangleLandSprite:getHeight()/2)
    love.graphics.pop()
end

local canvas = love.graphics.newCanvas()
local font = love.graphics.newFont("assets/fonts/KarmaFuture.ttf", 50)

function glitch()
    love.graphics.setCanvas(canvas)
    love.graphics.setShader()

    love.graphics.setCanvas()
    love.graphics.setShader(distortionShader)
    love.graphics.draw(canvas)
end

local dopamine = love.graphics.newImage("assets/Dopamine.png")

local invertShader = love.graphics.newShader("invertred.glsl")

function dopamineFarm()
    love.graphics.setCanvas()

    love.graphics.setShader(invertShader)
    love.graphics.push()
    love.graphics.scale( 0.5, 0.5 )
    love.graphics.setColor(1, 0, 0)
    love.graphics.draw(dopamine, 400 / 0.5, 300 / 0.5, 0, 1, 1, dopamine:getWidth() / 2, dopamine:getHeight() / 2 + 75 / 0.5)
    love.graphics.pop()
    love.graphics.setShader()
    love.graphics.printf("Dopamine Farm Studios", font, 400 - font:getWidth("Dopamine Farm Studios") / 2, 300 - font:getHeight() / 2, 1000)
end

return intro