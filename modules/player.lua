local player = {}
local utils = require("yan.utils")

player.X = 400
player.Y = 300
player.Speed = 250
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

function player:Update(dt)
    self.DX = 0
    self.DY = 0
    for key, mult in pairs(movementDirections) do
        if love.keyboard.isDown(key) then
            self.X = self.X + mult[1] * dt * self.Speed
            self.Y = self.Y + mult[2] * dt * self.Speed
            self.DX = self.DX + mult[1] * dt * self.Speed
            self.DY = self.DY + mult[2] * dt * self.Speed
            if key == "left" then
                self.Direction = 1
            elseif key == "right" then
                self.Direction = -1
            end
        end
    end

    if attacking then
        if love.timer.getTime() > stopAttackTimer then
            attacking = false
        end
    end
end

function player:Attack(enemies)
    attacking = true

    for _, enemy in ipairs(enemies) do
        if utils:Distance(self.X, self.Y, enemy.X, enemy.Y) < 75 then
            enemy:TakeDamage(5)
        end
    end
end

function player:Draw(cx, cy)
    love.graphics.draw(sprite, self.X - cx, self.Y - cy, 0, self.Direction, 1, 25, 25)
    love.graphics.draw(sword, self.X - cx, self.Y - cy, 0, self.Direction, 1, 75, 75)
end

return player