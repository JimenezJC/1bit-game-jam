Noon = {}
Noon.__index = Noon

function Noon.new(reaction_window, time_till_noon)
    local self = setmetatable({}, Noon)
    self.reaction_window = reaction_window
    self.time_till_noon = time_till_noon
    return self
end
function Noon:update(dt)
    -- TOOD
end
function Noon:draw()
    -- TODO
end