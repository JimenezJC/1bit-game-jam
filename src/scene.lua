require "src.noon"
require "src.3mmie"
require "src.enemy"

Scene = {}
Scene.__index = Scene

function Scene.new()
  local self = setmetatable({}, Scene)
  self:reset()
  return self
end

function Scene:reset()
  --TODO: three scenes, need a variable to 'set' which scene we're in? (Earth, Space, Hell)
  self.noon = Noon.new(1.0, 5.0)
  self.result = nil
  self.game_over = false
  self.miss_timer = 0
  self.showing_miss = false
  self.win = false
  self.hit_timer = 0
  self.showing_hit = false

  self.player = ThreeMmie.new()
  self.player.x = 20
  self.player.y = 94

  self.enemy = Enemy.new("assets/enemy3 shootout")
  self.enemy.x = 190
  self.enemy.y = 75

  -- background sprites - sun, foreground, background
  self.sun = love.graphics.newImage("assets/sun.png")
  self.foreground = love.graphics.newImage("assets/foreground.png")
  self.background = love.graphics.newImage("assets/background.png")
end

function Scene:update(dt)
  self.player:update(dt)
  self.enemy:update(dt)

  if self:handle_miss_timer(dt) then return end
  if self:handle_hit_timer(dt) then return end
  if self.game_over or self.win then return end

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

function Scene:handle_hit_timer(dt)
  if not self.showing_hit then return false end
  self.hit_timer = self.hit_timer + dt
  if self.hit_timer >= 1.5 then
    self.win = true
    self.showing_hit = false
  end
  return true
end

function Scene:check_missed()
  if self.noon.state == "missed" and not self.result then
    self.result = "miss"
    self.showing_miss = true
    self.miss_timer = 0
    self.enemy:set_shooting()
  end
end

function Scene:react()
  if self.game_over or self.showing_miss or self.win or self.showing_hit then return end

  local result = self.noon:react()
  if result then
    self.result = result
    if result == "miss" then
      self.showing_miss = true
      self.miss_timer = 0
      self.enemy:set_shooting()
    elseif result == "hit" then
      self.showing_hit = true
      self.hit_timer = 0
      self.player:set_shooting()
    end
  end
end

function Scene:retry()
  if self.game_over or self.win then
    self:reset()
  end
end

function Scene:draw()
  if self.game_over then
    love.graphics.printf({"game over",{0,0,0,0}}, 28, 50,200,"center")
  elseif self.win then
    love.graphics.printf({"you win",{0,0,0,0}}, 28, 50,200,"center")
  else
    --draw background layers - foreground, background, sun
    love.graphics.draw(self.background, 0,0)
    love.graphics.draw(self.sun, 100,math.ceil(self.noon.time_till_noon)+69)
    love.graphics.draw(self.foreground, 0,0)
    

    self.player:draw()
    self.enemy:draw()
    self.noon:draw()
    if self.result then
      love.graphics.printf({self.result,{0,0,0,0}}, 128, 50,20,"center")
    end
  end
end
