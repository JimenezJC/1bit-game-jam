Scene = {}
Scene.__index = Scene

function Scene.new()
    local self = setmetatable({}, Scene)
    self.noon = 
    return self
end
function Scene:update(dt)
    -- TODO
end

function Scene:draw()
    -- TODO 
end
