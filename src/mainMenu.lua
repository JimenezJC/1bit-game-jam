
MainMenu = {}
MainMenu.__index = MainMenu

function MainMenu.new()
  local self = setmetatable({}, MainMenu)
  self:reset()

  -- background sprites - sun, foreground, background
  self.background = love.graphics.newImage("assets/title-screen.png")

  -- return button
  self.returnButtonAnim = PlayAnimation.new("assets/return button animation", 0.1, true)

  --start button
  self.startButton = love.graphics.newImage("assets/buttons/start-button.png")
  return self
end

function MainMenu:reset()
  
  -- slide system, 0 is main menu, other numbers are the tutorial screens?
  self.slide = 0  
  
end

function MainMenu:update(dt)
  self.returnButtonAnim:update(dt)
end

function MainMenu:react()
  self.slide = self.slide + 1
end

function MainMenu:draw()
  if self.slide == 0 then
    love.graphics.draw(self.background, 0, 0)
    love.graphics.printf({"press enter to start",{0,0,0,0}}, 28, 150,200,"center")
    love.graphics.printf({"team yarn - 2026",{0,0,0,0}}, 28, 182,200,"center")
  elseif self.slide == 1 then
    love.graphics.printf("when the sun fully rises from the horizon, click mouse 1 to draw and shoot!", 28,50, 200, "center")
    self.returnButtonAnim:draw(224,160)
  elseif self.slide == 2 then
    love.graphics.printf("when the sun fully rises from the horizon, click mouse 1 to draw and shoot!", 28,50, 200, "center")
    love.graphics.printf("make sure you don't draw too early!",28, 75, 200, "center")
    self.returnButtonAnim:draw(224,160)
  end
  

  
end
