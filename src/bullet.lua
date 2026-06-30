require "lib.play_animation"

Bullet = {}
Bullet.__index = Bullet

function Bullet.new()
    local self = setmetatable({}, Bullet)
    self.x = 0
    self.y = 0
    self.state = "idle"
    self.direction = "right"
    self.animations = {
        shooting = PlayAnimation.new("assets/shootout bullet fired", 0.1, false)
    }
  
    return self
end

function Bullet:changeDirection(direction)
    self.direction = direction
end

function Bullet:update(dt)
    if self.animations[self.state] then
        self.animations[self.state]:update(dt)
    end
end

function Bullet:draw()
    if self.animations[self.state] then
        -- regular firing direction, 3mmie fires
        if self.direction == "right" then
            self.x = 0
            self.animations[self.state]:draw(self.x, self.y)
        else
            --mirrored firing
            self.x = 256
            self.animations[self.state]:drawMirrored(self.x, self.y)
        end
    end
end

function Bullet:set_shooting()
    self.state = "shooting"
end
