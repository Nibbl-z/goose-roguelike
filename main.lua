local player = require("modules.player")
local utils = require("yan.utils")
local enemies = {}
local crumbs = {}

local cx, cy = 0, 0
local cxOffset, cyOffset = 550, 250

local world = love.physics.newWorld(0, 0, true)
require("yan")

local wave = 1
local startingEnemies = 5
local enemyIncrease = 4

local waveTextHideDelay = love.timer.getTime() + 3

function SpawnWave()
    waveText.Text = "WAVE "..wave
    yan:NewTween(waveText, yan:TweenInfo(1, EasingStyle.QuadOut), {Position = UIVector2.new(0,0,0,0)}):Play()
    waveTextHideDelay = love.timer.getTime() + 3
    
    for i = 1, startingEnemies + (enemyIncrease * (wave - 1)) do
        local enemy = setmetatable({}, require("modules.enemy"))
        
        local function ChoosePos()
            enemy.X = love.math.random(-400,800)
            enemy.Y = love.math.random(-400,800)

            if utils:Distance(enemy.X, enemy.Y, player.X, player.Y) <= 300 then ChoosePos() return end
        end
        ChoosePos()
        
        enemy:Load(world)
        enemy.OnDeath = function ()
            local crumb = setmetatable({}, require("modules.crumb"))
            
            crumb.X = enemy.X
            crumb.Y = enemy.Y
            
            table.insert(crumbs, crumb)
        end

        table.insert(enemies, enemy)
    end
end

function love.load()
    screen = yan:Screen()
    
    screen.Enabled = true
    
    waveText = yan:Label(screen, "WAVE 1", 32, "center", "center")
    waveText.Size = UIVector2.new(1,0,0.1,0)
    waveText.Position = UIVector2.new(0,0,-0.1,0)
    waveText.TextColor = Color.new(1,1,1,1)
    
    crumbsText = yan:Label(screen, "Crumbs: 0", 24, "right", "center")
    crumbsText.Position = UIVector2.new(1,0,0,0)
    crumbsText.AnchorPoint = Vector2.new(1,0)
    crumbsText.TextColor = Color.new(1,1,1,1)
    crumbsText.Size = UIVector2.new(0.5,0,0.1,0)
    
    player:Load(world)
    love.window.setMode(500,500,{borderless = true})
    cx, cy = love.window.getPosition()
    
    SpawnWave()
end

function love.update(dt)
    world:update(dt)
    
    local deadEnemies = 0

    for _, enemy in ipairs(enemies) do
        enemy:Follow(player, dt)
        
        if enemy.Dead then
            deadEnemies = deadEnemies + 1
        end
    end

    for _, crumb in ipairs(crumbs) do
        print(utils:Distance(player.X, player.Y, crumb.X, crumb.Y))
        if utils:Distance(player.X, player.Y, crumb.X, crumb.Y) <= 30 then
            if not crumb.Collected then
                crumb.Collected = true
                player.Crumbs = player.Crumbs + 1
            end
        end
    end

    crumbsText.Text = "Crumbs: "..player.Crumbs
    
    if deadEnemies == #enemies then
        wave = wave + 1
        SpawnWave()
    end

    if waveTextHideDelay ~= -1 and love.timer.getTime() >= waveTextHideDelay then
        waveTextHideDelay = -1
        yan:NewTween(waveText, yan:TweenInfo(1, EasingStyle.QuadOut), {Position = UIVector2.new(0,0,-0.1,0)}):Play()
    end

    player:Update(dt)
    
    love.window.setPosition(cx, cy)
    cx = cx + player.DX
    cy = cy + player.DY

    yan:Update(dt)
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
    for _, crumb in ipairs(crumbs) do
        crumb:Draw(cx - cxOffset, cy - cyOffset)
    end
    player:Draw(cx - cxOffset, cy - cyOffset)
    
    love.graphics.rectangle("fill", 5, 5, 75, 25)
    love.graphics.setColor(1,0,0,1)
    love.graphics.rectangle("fill", 5, 5, (player.Health / player.MaxHealth) * 75, 25)
    love.graphics.setColor(1,1,1,1)

    yan:Draw()
end