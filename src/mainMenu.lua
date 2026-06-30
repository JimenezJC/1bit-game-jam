
MainMenu = {}
MainMenu.__index = MainMenu

-- invert colors shader
-- thanks to DarkSysL on Reddit
shader_invert = love.graphics.newShader[[ vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords) { vec4 col = texture2D( texture, texture_coords ); return vec4(1-col.r, 1-col.g, 1-col.b, col.a); } ]]

function MainMenu.new()
  local self = setmetatable({}, MainMenu)
  self:reset()
  return self
end

function MainMenu:reset()
  -- background sprites - sun, foreground, background
  self.sun = love.graphics.newImage("assets/sun.png")
  
end

function MainMenu:update(dt)
  
end

function MainMenu:react()
  
end

function MainMenu:draw()
 
  love.graphics.printf({"menu test",{0,0,0,0}}, 28, 50,200,"center")
  
end
