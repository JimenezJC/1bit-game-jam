require "src.noon"

Scene = {}
Scene.__index = Scene

function Scene.new()
  local self = setmetatable({}, Scene)
  self:reset()
  return self
end

function Scene:reset()
  self.noon = Noon.new(1.0, 5.0)
  self.result = nil
  self.game_over = false
  self.miss_timer = 0
  self.showing_miss = false
end

function Scene:update(dt)
  -- Checking conditions if so do a completely different type of update
  if self:handle_miss_timer(dt) then return end
  if self.game_over then return end
  -- Actual updates
  self.noon:update(dt)
  self:check_missed()
end

function Scene:handle_miss_timer(dt)
  if not self.showing_miss then return false end
  self.miss_timer = self.miss_timer + dt
  if self.miss_timer >= 1.5 then
    self.game_over = true
    self.showing_miss = false
  end
  return true
end

function Scene:check_missed()
  if self.noon.state == "missed" and not self.result then
    self.result = "miss"
    self.showing_miss = true
    self.miss_timer = 0
  end
end

function Scene:react()
  if self.game_over or self.showing_miss then return end

  local result = self.noon:react()
  if result then
    self.result = result
    if result == "miss" then
      self.showing_miss = true
      self.miss_timer = 0
    end
  end
end

function Scene:retry()
  if self.game_over then
    self:reset()
  end
end

function Scene:draw()
  if self.game_over then
    love.graphics.print("game over", 384, 288)
  else
    self.noon:draw()
    if self.result then
      love.graphics.print(self.result, 384, 288)
    end
  end
end
