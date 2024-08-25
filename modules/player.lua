local player = {}
local utils = require("yan.utils")
require 'yan'
player.X = 400
player.Y = 300
player.Speed = 50
player.Direction = 1

player.Health = 100
player.MaxHealth = 100

local movementDirections = {up = {0,-1}, left = {-1,0}, down = {0,1}, right = {1,0}}

local sprite = love.graphics.newImage("/img/player.png")
local sword = love.graphics.newImage("/img/sword.png")

player.DX = 0
player.DY = 0

local attacking = false
local stopAttackTimer = 0

local attack = {Rotation = 0}

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

            if key == "left" then
                self.Direction = 1
            elseif key == "right" then
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
    
    self.X = self.Body:getX()
    self.Y = self.Body:getY()
    
    self.DX = self.X - prevX
    self.DY = self.Y - prevY
end

function player:Attack(enemies)
    attacking = true
    stopAttackTimer = love.timer.getTime() + 0.2
    attack.Rotation = 0
    yan:NewTween(attack, yan:TweenInfo(0.2), {Rotation = attack.Rotation + math.rad(360)}):Play()
    for _, enemy in ipairs(enemies) do
        if utils:Distance(self.X, self.Y, enemy.X, enemy.Y) < 90 then
            enemy:TakeDamage(5)
        end
    end
end

function player:Draw(cx, cy)
    love.graphics.draw(sprite, self.X - cx, self.Y - cy, 0, self.Direction, 1, 25, 25)
    if attacking then love.graphics.draw(sword, self.X - cx, self.Y - cy, attack.Rotation, self.Direction, 1, 75, 75) end
end

return player