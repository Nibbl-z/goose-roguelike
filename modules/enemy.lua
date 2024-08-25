local enemy = {}

enemy.X = 0
enemy.Y = 0
enemy.Speed = 150
enemy.Direction = 1

enemy.__index = enemy

local sprite = love.graphics.newImage("/img/enemy.png")

function enemy:Follow(playerX, playerY, dt)
    if self.X < playerX then
        self.X = self.X + dt * self.Speed
        self.Direction = -1
    end
    
    if self.X > playerX then
        self.X = self.X - dt * self.Speed
        self.Direction = 1
    end
    
    if self.Y < playerY then
        self.Y = self.Y + dt * self.Speed
    end
    
    if self.Y > playerY then
        self.Y = self.Y - dt * self.Speed
    end
end

function enemy:Draw(cx, cy)
    love.graphics.draw(sprite, self.X - cx, self.Y - cy, 0, self.Direction, 1, 25, 25)
end

return enemy