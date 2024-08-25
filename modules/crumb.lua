local crumb = {}
crumb.X = 0
crumb.Y = 0
crumb.Collected = false
local sprite = love.graphics.newImage("/img/crumb.png")
crumb.__index = crumb

function crumb:Draw(cx, cy)
    if self.Collected then return end
    love.graphics.draw(sprite, self.X - cx, self.Y - cy)
end

return crumb