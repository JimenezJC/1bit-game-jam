require "src.noon"

Scene = {}
Scene.__index = Scene

function Scene.new()
    local self = setmetatable({}, Scene)
    self.noon = Noon.new(1.0, 5.0)
    return self
end

function Scene:update(dt)
    self.noon:update(dt)
end

function Scene:draw()
    self.noon:draw()
end
