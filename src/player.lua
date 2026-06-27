-- Don't know if we need this yet
Player = {}
Player.__index = Player

function Player.new()
    local self  = setmetatable({}, Player)
    return self
end
function Player:update(dt)
    -- TODO
end
function Player:draw()
    -- TODO
end
