local player = {}
local utils = require("yan.utils")
require 'yan'
player.X = 400
player.Y = 300
player.Speed = 50
player.Direction = 1

player.Health = 100
player.MaxHealth = 100

player.Crumbs = 0
player.Strength = 5
player.SwordSize = 75

local movementDirections = {w = {0,-1}, a = {-1,0}, s = {0,1}, d = {1,0}}

local sprite = love.graphics.newImage("/img/player.png")
local spritedmg = love.graphics.newImage("/img/player_damage.png")
local sword = love.graphics.newImage("/img/sword.png")

player.DX = 0
player.DY = 0

local attacking = false
local stopAttackTimer = 0

local attack = {Rotation = 0}

local damageTimer
local damaged = false

function player:Load(world)
    self.Body = love.physics.newBody(world, self.X, self.Y, "dynamic")
    self.Body:setLinearDamping(5)
    self.Shape = love.physics.newRectangleShape(50, 50)
    self.Fixture = love.physics.newFixture(self.Body, self.Shape)
    self.Fixture:setRestitution(0)
end

function player:Update(dt)
    self.DX = 0
    self.DY = 0
    
    local prevX, prevY = self.X, self.Y
    
    for key, mult in pairs(movementDirections) do
       
        if love.keyboard.isDown(key) then
            local impulseX, impulseY = 0, 0
            impulseX = impulseX + mult[1] * self.Speed 
            impulseY = impulseY + mult[2] * self.Speed
            --[[self.DX = self.DX + mult[1] * dt * self.Speed
            self.DY = self.DY + mult[2] * dt * self.Speed]]
            
            if key == "a" then
                self.Direction = 1
            elseif key == "d" then
                self.Direction = -1
            end
            
            self.Body:applyLinearImpulse(impulseX, impulseY)
        end
        
       
    end
    
    

    if attacking then
        if love.timer.getTime() > stopAttackTimer then
            attacking = false
        end
    end

    if damaged then
        if love.timer.getTime() > damageTimer then
            damaged = false
        end
    end
    
    self.X = self.Body:getX()
    self.Y = self.Body:getY()
    
    self.DX = self.X - prevX
    self.DY = self.Y - prevY
end

function player:TakeDamage(damage)
    damaged = true
    damageTimer = love.timer.getTime() + 0.1
    self.Health = self.Health - damage
    
    if self.Health <= 0 then
        self.Body:setActive(false)
        self.Dead = true
    end
end

function player:Attack(enemies)
    if attacking then return end
    attacking = true
    stopAttackTimer = love.timer.getTime() + 0.2
    attack.Rotation = 0
    yan:NewTween(attack, yan:TweenInfo(0.2), {Rotation = attack.Rotation + math.rad(360)}):Play()
    for _, enemy in ipairs(enemies) do
        if utils:Distance(self.X, self.Y, enemy.X, enemy.Y) < self.SwordSize + 20 then
            enemy:TakeDamage(self.Strength)
        end
    end
end

function player:Draw(cx, cy)
    love.graphics.draw(damaged and spritedmg or sprite, self.X - cx, self.Y - cy, 0, self.Direction, 1, 25, 25)
    if attacking then love.graphics.draw(sword, self.X - cx, self.Y - cy, attack.Rotation, ((self.SwordSize * 2) / 150) * self.Direction, (self.SwordSize * 2) / 150, self.SwordSize, self.SwordSize) end
end

return player