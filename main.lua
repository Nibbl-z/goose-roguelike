local player = require("modules.player")

local enemies = {}

local cx, cy = 0, 0
local cxOffset, cyOffset = 550, 250
function love.load()
    love.window.setMode(500,500,{})
    cx, cy = love.window.getPosition()
    table.insert(enemies, require("modules.enemy"))
end

function love.update(dt)
    for _, enemy in ipairs(enemies) do
        enemy:Follow(player.X, player.Y, dt)
    end
    player:Update(dt)
    
    love.window.setPosition(cx, cy)
    cx = cx + player.DX
    cy = cy + player.DY
end

function love.draw()
    for _, enemy in ipairs(enemies) do
        enemy:Draw(cx - cxOffset, cy - cyOffset)
    end
    player:Draw(cx - cxOffset, cy - cyOffset)
end