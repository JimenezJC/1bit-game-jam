require "src.scene"

local scene
--initialize push - deals with scaling resolutions
local push = require "lib.push"

function love.load()
    scene = Scene.new()
    font = love.graphics.newFont("assets/fonts/digi.ttf",8)
    love.graphics.setFont(font)

    --setup aliasing
    love.graphics.setDefaultFilter("nearest","nearest")

    --setup screen
    push:setupScreen(256,192, 768,576, {fullscreen = false, vsync = true, pixelperfect = true})

    

end

function love.update(dt)
    scene:update(dt)
end

function love.draw()
    push:start()
    
    scene:draw()
    
    push:finish()
end

function love.mousepressed(x, y, button)
    if button == 1 then
        scene:react()
    end
end

function love.keypressed(key)
    if key == "r" then
        scene:retry()
    end
end
