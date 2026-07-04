require "src.scene"
require "src.mainMenu"

local mainMenu
local scene
--initialize push - deals with scaling resolutions
local push = require "lib.push"

--gamestate init
Gamestate = require "lib.gamestate"
local menu = {}
local game = {}
--TODO: maybe transition screens?

function love.load()
    scene = Scene.new()
    mainMenu = MainMenu.new()
    font = love.graphics.newFont("assets/fonts/digi.ttf",8)
    love.graphics.setFont(font)

    --setup aliasing
    love.graphics.setDefaultFilter("nearest","nearest")

    --setup screen
    push:setupScreen(256,192, 768,576, {fullscreen = false, vsync = true, pixelperfect = true})

    --Gamestate stuff
    Gamestate.registerEvents()
    Gamestate.switch(menu)
end

function game:update(dt)
    scene:update(dt)
end

function game:draw()
    push:start()
    
    scene:draw()
    
    push:finish()
end

--TODO: menu state functions!!
function menu:update(dt)
    mainMenu:update(dt)
    if mainMenu.slide == 3 then
        Gamestate.switch(game)
    end
end

function menu:draw()
    push:start()
    mainMenu:draw()
    push:finish()
end

function love.mousepressed(x, y, button)
    --checks if gamestate is game
    if Gamestate.current() == game then
        if button == 1 then
            scene:react()
        end
    end
    
end

function love.keypressed(key)
    --checks if gamestate is game
    if Gamestate.current() == game then
        if key == "r" then
            scene:retry()
        end
    elseif Gamestate.current() == menu then
        if key == "return" then
            mainMenu:react()
        end
    end
end
