local player = {}

player.X = 400
player.Y = 300
player.Speed = 250
player.Direction = 1

local movementDirections = {w = {0,-1}, a = {-1,0}, s = {0,1}, d = {1,0}}

local sprite = love.graphics.newImage("/img/player.png")

player.DX = 0
player.DY = 0

function player:Update(dt)
    self.DX = 0
    self.DY = 0
    for key, mult in pairs(movementDirections) do
        if love.keyboard.isDown(key) then
            self.X = self.X + mult[1] * dt * self.Speed
            self.Y = self.Y + mult[2] * dt * self.Speed
            self.DX = self.DX + mult[1] * dt * self.Speed
            self.DY = self.DY + mult[2] * dt * self.Speed
            if key == "a" then
                self.Direction = 1
            elseif key == "d" then
                self.Direction = -1
            end
        end
    end
end

function player:Draw(cx, cy)
    love.graphics.draw(sprite, self.X - cx, self.Y - cy, 0, self.Direction, 1, 25, 25)
end

return player