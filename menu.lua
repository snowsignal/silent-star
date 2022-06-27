-- This is the main menu.
-- There are many like it, but this one is ours.

local Gamestate = require "hump.gamestate"
local tiny      = require "tiny"
local Vector      = require 'hump.vector'
local slider    = require 'simple_slider'

local music     = require "music"

local menuCanvas = love.graphics.newCanvas()

local menuTitle = "Silent Star"

local backgroundDrawSystem = require "systems.backgroundDrawSystem"

local velocitySystem = require "systems.damageSystem"

local Background = require 'entities.background'

local titleFont = love.graphics.setNewFont("assets/fonts/VCR_OSD_MONO.ttf", 100)

local buttonFont = love.graphics.setNewFont("assets/fonts/VCR_OSD_MONO.ttf", 35)

local title = love.graphics.newText(titleFont, menuTitle)

local volumeImage = love.graphics.newImage("assets/volume.png")

local volumeSlider =  newSlider(100, 590, 100, 0.5, 0, 1, function (v) love.audio.setVolume(v) end, {track = "line", knob = "circle"})

local menu = { buttons = {} }
local openingCutscene = require "openingCutscene"

local buttonColor = 150/255

local buttonTextColor = 200 / 255

local mouseIsPressed = false
local mouseJustReleased = false

local shockSystem = require 'systems.shockSystem'
local enemySystem = require 'systems.enemySystem'

local function pointInRectangle(pointx, pointy, rectx, recty, rectwidth, rectheight)
    return pointx > rectx and pointy > recty and pointx < rectx + rectwidth and pointy < recty + rectheight
end

local function color3(color)
    return {color, color, color, 1}
end

local buttonSystem = tiny.processingSystem()
buttonSystem.filter = tiny.requireAll("button")
function buttonSystem:process(e)
    local mx, my = love.mouse.getPosition() -- get the position of the mouse
    local x, y = e.position:unpack()
    local bt = e.button

    bt.hover = pointInRectangle(mx, my, x, y, buttonFont:getWidth(bt.text) + 20, buttonFont:getHeight() + 20)
    if bt.hover and mouseJustReleased then
        bt.callback()
    end
end

local buttonDrawSystem = tiny.processingSystem({draw = true})
buttonDrawSystem.filter = tiny.requireAll("button")
function buttonDrawSystem:process(e)
    local mx, my = love.mouse.getPosition() -- get the position of the mouse
    local x, y = e.position:unpack()
    local bt = e.button

    local drawTextColor = bt.textColor
    if bt.hover then
        drawTextColor = color3(buttonTextColor + 30 / 255)
    end

	--love.graphics.setColor(bt.color)
	--love.graphics.rectangle("fill", x, y, buttonFont:getWidth(bt.text) + 20, buttonFont:getHeight() + 20, 5)

    love.graphics.setFont(buttonFont)
	love.graphics.setColor(drawTextColor)
	love.graphics.print(bt.text, x + 10, y + 10)
end

local function button_new(text, x, y, callback)
    x = x or 0
    y = y or 0
    return {
        position = Vector(x, y),
        button = {
            text = text,
            textColor = color3(buttonColor),
            color = color3(buttonTextColor),
            callback = callback,
            hover = false
        }
    }
end

local drawSystemFilter = tiny.requireAll("draw")
local updateSystemFilter = tiny.rejectAll("draw")

local time = 0

function menu:update(dt)
    if menu.exiting then
        tiny.clearEntities(menu.world)
        tiny.clearSystems(menu.world)
        menu.world:refresh()
        Gamestate.switch(openingCutscene)
    else
        abberationShader:send("punch", math.abs(getCurrentTrackNoise()))
        local newMousePress = love.mouse.isDown(1)
        mouseJustReleased = newMousePress and not mouseIsPressed
        mouseIsPressed = newMousePress
        volumeSlider:update()
        menu.world:update(dt, updateSystemFilter)
    end
end

local invertShader = love.graphics.newShader("invert.glsl")

function menu:draw()
    love.graphics.setCanvas(menuCanvas)
    love.graphics.setShader()

    local dt = love.timer.getDelta()
    menu.world:update(dt, drawSystemFilter)
    love.graphics.setColor({1, 1, 1, 1})
    love.graphics.draw(title, 400 - title:getWidth() / 2, 100)

    love.graphics.setColor(color3(200 / 255))
    love.graphics.push()
    love.graphics.setShader(invertShader)
    love.graphics.scale(0.05, 0.05)
    love.graphics.draw(volumeImage, 20 / 0.05, 575 / 0.05)
    love.graphics.setShader()
    love.graphics.pop()
    love.graphics.setLineWidth(4)
    volumeSlider:draw()

    love.graphics.setCanvas()
    love.graphics.setShader(abberationShader)
    love.graphics.draw(menuCanvas)
end

function menu:enter()
    playTrack("menu")

    local playButton = button_new("Play", 300, 300, function()
        menu.exiting = true
    end)

    menu.world = tiny.world(
        -- Systems
            velocitySystem,
            backgroundDrawSystem,
            buttonSystem,
        buttonDrawSystem,
            shockSystem,
            enemySystem,
        -- Entities
            playButton,
            Background:new("stars", -50)
    )
end

function menu:leave()
    menu.world:refresh()
end

return menu