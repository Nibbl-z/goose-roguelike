local player = require("modules.player")

local enemies = {}

local cx, cy = 0, 0
local cxOffset, cyOffset = 550, 250

local world = love.physics.newWorld(0, 0, true)

function love.load()
    player:Load(world)
    love.window.setMode(500,500,{borderless = true})
    cx, cy = love.window.getPosition()
    for i = 1, 20 do
        local enemy = setmetatable({}, require("modules.enemy"))
        enemy.X = love.math.random(-200,600)
        enemy.Y = love.math.random(-200,600)
        enemy:Load(world)
        table.insert(enemies, enemy)
    end
end

function love.update(dt)
    world:update(dt)
    for _, enemy in ipairs(enemies) do
        enemy:Follow(player.X, player.Y, dt)
    end
    player:Update(dt)
    
    love.window.setPosition(cx, cy)
    cx = cx + player.DX
    cy = cy + player.DY
end

function love.keypressed(key)
    if key == "z" then
        player:Attack(enemies)
    end
end

function love.draw()
    for _, enemy in ipairs(enemies) do
        enemy:Draw(cx - cxOffset, cy - cyOffset)
    end
    player:Draw(cx - cxOffset, cy - cyOffset)
end