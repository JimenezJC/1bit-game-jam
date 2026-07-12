require "src.noon"
require "src.3mmie"
require "src.enemy"
require "src.bullet"
require "src.distraction"
local stages = require "src.stages"

Scene = {}
Scene.__index = Scene

-- invert colors shader
-- thanks to DarkSysL on Reddit
shader_invert = love.graphics.newShader[[ vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords) { vec4 col = texture2D( texture, texture_coords ); return vec4(1-col.r, 1-col.g, 1-col.b, col.a); } ]]

function Scene.new()
  local self = setmetatable({}, Scene)
  self.current_stage = 1
  self:reset()
  return self
end

function Scene:reset()
  local config = stages[self.current_stage]

  local noon_time = love.math.random(config.noon.time_till_noon_min, config.noon.time_till_noon_max)
  self.noon = Noon.new(config.noon.reaction_window, noon_time)
  self.result = nil
  self.game_over = false
  self.miss_timer = 0
  self.showing_miss = false
  self.win = false
  self.hit_timer = 0
  self.showing_hit = false

  self.player = ThreeMmie.new()
  self.player.x = config.player.x
  self.player.y = config.player.y

  self.enemy = Enemy.new(config.enemy.folder_path)
  self.enemy.x = config.enemy.x
  self.enemy.y = config.enemy.y

  self.bullet = Bullet.new()
  self.bullet.x = config.bullet.x
  self.bullet.y = config.bullet.y

  self.distractions = {}
  self.distraction_timer = 0

  self.sun = love.graphics.newImage(config.sprites.sun)
  self.foreground = love.graphics.newImage(config.sprites.foreground)
  self.background = love.graphics.newImage(config.sprites.background)
end

function Scene:update(dt)
  self.player:update(dt)
  self.enemy:update(dt)
  self.bullet:update(dt)

  -- Check if distractions exist, update if active and delete if finished
  for i = #self.distractions, 1, -1 do
    self.distractions[i]:update(dt)
    if self.distractions[i]:is_finished() then
      table.remove(self.distractions, i)
    end
  end

  if self:handle_miss_timer(dt) then return end
  if self:handle_hit_timer(dt) then return end
  if self.game_over or self.win then return end

  self.noon:update(dt)
  self:check_missed()

  -- Spawn a distraction as long as it isn't noon
  local config = stages[self.current_stage]
  if self.noon.state ~= "reaction" and #config.distractions > 0 then
    self.distraction_timer = self.distraction_timer + dt
    if self.distraction_timer >= config.distraction_interval then
      self.distraction_timer = 0
      local distraction_config = config.distractions[love.math.random(#config.distractions)]
      self:spawn_distraction(
        distraction_config.folder_path,
        distraction_config.x,
        distraction_config.y,
        distraction_config.frame_duration
      )
    end
  end
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
    self.player:set_killed()

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
      self.player:set_killed()

      --mirror bullet
      self.bullet:changeDirection("left")

      --draw bullet
      self.bullet:set_shooting()

      --height offset for bullet
      self.bullet.y = 3

      

    elseif result == "hit" then
      self.showing_hit = true
      self.hit_timer = 0
      self.player:set_shooting()
      self.enemy:set_killed()
      self.bullet:set_shooting()

      --height offset for bullet
      self.bullet.y = -2

    end
  end
end

-- Function that spawns a distraction
function Scene:spawn_distraction(folder_path, x, y, frame_duration)
  table.insert(self.distractions, Distraction.new(folder_path, x, y, frame_duration))
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
    --showing miss or hit, invert!
    if self.showing_hit or self.showing_miss then
      love.graphics.setShader(shader_invert)
    end
    --draw background layers - foreground, background, sun
    love.graphics.draw(self.background, 0,0)
    love.graphics.draw(self.sun, 100,math.ceil(self.noon.time_till_noon)+69)
    love.graphics.draw(self.foreground, 0,0)
    
    --draw bullet behind player/enemies
    if self.showing_hit or self.showing_miss then
      self.bullet:draw()
    end
    self.player:draw()
    self.enemy:draw()
    self.noon:draw()
      for _, distraction in ipairs(self.distractions) do
      distraction:draw()
    end
    if self.result then
      love.graphics.printf({self.result,{0,0,0,0}}, 128, 50,20,"center")
    end
  end
end
