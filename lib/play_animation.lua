PlayAnimation = {}
PlayAnimation.__index = PlayAnimation

function PlayAnimation.new(folder_path, frame_duration)
    local self = setmetatable({}, PlayAnimation)
    self.frames = {}
    self.current_frame = 1
    self.frame_timer = 0
    self.frame_duration = frame_duration or 0.1
    
    local files = love.filesystem.getDirectoryItems(folder_path)
    table.sort(files)
    
    for _, file in ipairs(files) do
        if file:match("%.png$") then
            local img = love.graphics.newImage(folder_path .. "/" .. file)
            table.insert(self.frames, img)
        end
    end
    
    return self
end

function PlayAnimation:update(dt)
    if #self.frames == 0 then return end
    
    self.frame_timer = self.frame_timer + dt
    if self.frame_timer >= self.frame_duration then
        self.frame_timer = self.frame_timer - self.frame_duration
        self.current_frame = self.current_frame + 1
        if self.current_frame > #self.frames then
            self.current_frame = 1
        end
    end
end

function PlayAnimation:draw(x, y)
    if #self.frames == 0 then return end
    love.graphics.draw(self.frames[self.current_frame], x, y)
end