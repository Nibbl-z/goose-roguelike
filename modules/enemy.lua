local enemy = {}
local utils = require("yan.utils")
enemy.X = 0
enemy.Y = 0
enemy.Speed = 5
enemy.Direction = 1

enemy.__index = enemy

enemy.Health = 10
enemy.MaxHealth = 10
enemy.Dead = false
enemy.Damage = 1

enemy.attackTimer = 0
enemy.attacking = false

local sprite = love.graphics.newImage("/img/enemy.png")

function enemy:Load(world)
    self.Body = love.physics.newBody(world,  self.X, self.Y, "dynamic")
    self.Body:setLinearDamping(5)
    self.Shape = love.physics.newRectangleShape(30, 30)
    self.Fixture = love.physics.newFixture(self.Body, self.Shape)
    self.Fixture:setRestitution(0)
end

function enemy:Follow(player, dt)
    self.X = self.Body:getX()
    self.Y = self.Body:getY()
    if self.attacking then
        if love.timer.getTime() >= self.attackTimer then
            self.attacking = false
        else
            return
        end
    end
    if self.Dead then return end

    local impulseX, impulseY = 0, 0

    if self.X < player.X then
        impulseX = self.Speed
        self.Direction = -1
    end
    
    if self.X > player.X then
        impulseX = -self.Speed
        self.Direction = 1
    end
    
    if self.Y < player.Y then
        impulseY = self.Speed
    end
    
    if self.Y > player.Y then
        impulseY = -self.Speed
    end

    self.Body:applyLinearImpulse(impulseX, impulseY)
    
    
    
    if utils:Distance(self.X, self.Y, player.X, player.Y) <= 50 then
        player:TakeDamage(self.Damage)

        self.attacking = true
        self.attackTimer = love.timer.getTime() + 1
    end
end

function enemy:TakeDamage(damage)
    self.Health = self.Health - damage
    
    if self.Health <= 0 and not self.Dead then
        self.Body:setActive(false)
        self.Dead = true
        self.OnDeath()
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