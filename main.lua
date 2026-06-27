require "src.scene"

local scene

function love.load()
    scene = Scene.new()
end

function love.update(dt)
    scene:update(dt)
end

function love.draw()
    scene:draw()
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
