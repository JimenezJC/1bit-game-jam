Noon = {}
Noon.__index = Noon

function Noon.new(reaction_window, time_till_noon)
  local self = setmetatable({}, Noon)
  self.reaction_window = reaction_window
  self.time_till_noon = time_till_noon
  self.state = "countdown"
  self.reaction_elapsed = 0
  return self
end

function Noon:update(dt)
  if self.state == "countdown" then
    self.time_till_noon = self.time_till_noon - (1*dt)
    if self.time_till_noon <= 0 then
      self.state = "reaction"
      self.time_till_noon = 0
    end
  elseif self.state == "reaction" then
    self.reaction_elapsed = self.reaction_elapsed + (1*dt)
    if self.reaction_elapsed >= self.reaction_window then
      self.state = "missed"
    end
  end
end

function Noon:react()
  if self.state == "reaction" then
    self.state = "hit"
    return "hit"
  elseif self.state == "countdown" then
    self.state = "missed"
    return "miss"
  end
  return nil
end

function Noon:is_active()
  return self.state == "countdown" or self.state == "reaction"
end

function Noon:is_countdown()
  return self.state == "countdown"
end

function Noon:is_reaction()
  return self.state == "reaction"
end

function Noon:draw()
  if self.state == "countdown" then
    love.graphics.print(math.ceil(self.time_till_noon), 384, 150)
  elseif self.state == "reaction" then
    love.graphics.print("react", 384, 150)
  end
end
