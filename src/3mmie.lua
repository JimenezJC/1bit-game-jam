require "lib.play_animation"

ThreeMmie = {}
ThreeMmie.__index = ThreeMmie

function ThreeMmie.new()
    local self = setmetatable({}, ThreeMmie)
    self.x = 0
    self.y = 0
    self.state = "idle"
    self.images = {
        idle = love.graphics.newImage("assets/3mmie shootout/3mmie-idle/3mmie-idle.png"),
        killed = love.graphics.newImage("assets/3mmie shootout/3mmie-killed/3mmie-killed.png")
    }
    self.animations = {
        shooting = PlayAnimation.new("assets/3mmie shootout/3mmie-shot-fired frames", 0.1, false)
    }
    return self
end

function ThreeMmie:update(dt)
    if self.animations[self.state] then
        self.animations[self.state]:update(dt)
    end
end

function ThreeMmie:draw()
    if self.animations[self.state] then
        self.animations[self.state]:draw(self.x, self.y)
    elseif self.images[self.state] then
        love.graphics.draw(self.images[self.state], self.x, self.y)
    end
end

function ThreeMmie:set_idle()
    self.state = "idle"
end

function ThreeMmie:set_killed()
    self.state = "killed"
end

function ThreeMmie:set_shooting()
    self.state = "shooting"
end
