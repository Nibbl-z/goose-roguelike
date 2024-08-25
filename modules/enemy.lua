local enemy = {}

enemy.X = 0
enemy.Y = 0
enemy.Speed = 150
enemy.Direction = 1

enemy.__index = enemy

enemy.Health = 10
enemy.MaxHealth = 10
enemy.Dead = false
local sprite = love.graphics.newImage("/img/enemy.png")

function enemy:Follow(playerX, playerY, dt)
    if self.Dead then return end
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

function enemy:TakeDamage(damage)
    self.Health = self.Health - damage

    if self.Health <= 0 then
        self.Dead = true
    end
end

function enemy:Draw(cx, cy)
    if self.Dead then return end
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(sprite, self.X - cx, self.Y - cy, 0, self.Direction, 1, 25, 25)
    
    love.graphics.rectangle("fill", self.X - 32.5 - cx, self.Y - 55 - cy, 75, 10)
    love.graphics.setColor(1,0,0,1)
    love.graphics.rectangle("fill", self.X - 32.5 - cx, self.Y - 55 - cy, (self.Health / self.MaxHealth) * 75, 10)
    love.graphics.setColor(1,1,1,1)
end

return enemy