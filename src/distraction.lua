require "lib.play_animation"

Distraction = {}
Distraction.__index = Distraction

function Distraction.new(folder_path, x, y, frame_duration)
    local self = setmetatable({}, Distraction)
    self.x = x or 0
    self.y = y or 0
    self.animation = PlayAnimation.new(folder_path, frame_duration or 0.1, false)
    return self
end

function Distraction:update(dt)
    self.animation:update(dt)
end

function Distraction:draw()
    self.animation:draw(self.x, self.y)
end

function Distraction:is_finished()
    return self.animation:is_finished()
end
