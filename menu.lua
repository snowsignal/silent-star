-- This is the main menu.
-- There are many like it, but this one is ours.

local Gamestate = require "hump.gamestate"
local tiny      = require "tiny"
local Vector      = require 'hump.vector'
local slider    = require 'simple_slider'

local music     = require "music"

local menuTitle = "Silent Star"

local volumeTitle = "Volume"

local backgroundDrawSystem = require "systems.backgroundDrawSystem"

local titleFont = love.graphics.setNewFont("assets/fonts/VCR_OSD_MONO.ttf", 100)

local buttonFont = love.graphics.setNewFont("assets/fonts/VCR_OSD_MONO.ttf", 35)

local title = love.graphics.newText(titleFont, menuTitle)

local volumeText = love.graphics.newText(buttonFont, volumeTitle)

local volumeSlider =  newSlider(360, 450, 100, 0.5, 0, 1, function (v) love.audio.setVolume(v) end, {track = "line", knob = "circle"})

local menu = { buttons = {} }
local game = require "game"

local buttonColor = 150/255

local buttonTextColor = 200 / 255

local mouseIsPressed = false
local mouseJustReleased = false

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

function menu:update(dt)
    local newMousePress = love.mouse.isDown(1)
    mouseJustReleased = newMousePress and not mouseIsPressed
    mouseIsPressed = newMousePress
    volumeSlider:update()
    menu.world:update(dt, updateSystemFilter)
end

function menu:draw()
    local offw, offh = love.graphics.getDimensions()
    local x, y = offw / 5.5, offh / 4

    local dt = love.timer.getDelta()
    menu.world:update(dt, drawSystemFilter)
    love.graphics.setColor({1, 1, 1, 1})
    love.graphics.draw(title, x, y)

    love.graphics.setColor(color3(200 / 255))
    love.graphics.draw(volumeText, 300, 400)
    love.graphics.setLineWidth(4)
    volumeSlider:draw()
end


function menu:enter()
    playTrack("menu")

    local playButton = button_new("Play", 300, 300, function()
        Gamestate.switch(game)
    end)

    menu.world = tiny.world(
        -- Systems
            backgroundDrawSystem,
            buttonSystem,
        buttonDrawSystem,
        -- Entities
            playButton
    )

    menu.world.camera = {
        camera = {
            mousePosition = function()
                return love.mouse.getPosition()
            end
        }
    }
end

return menu