require "lib.play_animation"

Enemy = {}
Enemy.__index = Enemy

function Enemy.new(folder_path)
    local self = setmetatable({}, Enemy)
    self.x = 0
    self.y = 0
    self.state = "idle"
    self.folder_path = folder_path
    
    self.images = {
        idle = love.graphics.newImage(folder_path .. "/enemy3-idle.png"),
        killed = love.graphics.newImage(folder_path .. "/enemy3-killed/enemy3-killed.png")

    }
    self.animations = {
        shooting = PlayAnimation.new(folder_path .. "/enemy3-shot-fired frames", 0.1, false)
    }
    return self
end

function Enemy:update(dt)
    if self.animations[self.state] then
        self.animations[self.state]:update(dt)
    end
end

function Enemy:draw()
    if self.animations[self.state] then
        self.animations[self.state]:draw(self.x, self.y)
    elseif self.images[self.state] then
        love.graphics.draw(self.images[self.state], self.x, self.y)
    end
end

function Enemy:set_idle()
    self.state = "idle"
end

function Enemy:set_shooting()
    self.state = "shooting"
end

function Enemy:set_killed()
    self.state = "killed"
end
