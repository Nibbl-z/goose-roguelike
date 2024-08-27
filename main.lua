local player = require("modules.player")
local utils = require("yan.utils")
local shop = require("modules.shop")
local menu = require("modules.menu")
local pause = require("modules.pause")

local enemies = {}
local crumbs = {}

local cx, cy = 0, 0
local cxOffset, cyOffset = 550, 250

local world = love.physics.newWorld(0, 0, true)
require("yan")

local wave = 1
local startingEnemies = 3
local enemyIncrease = 1

local startSpeed = 300
local speedIncrease = 50

local startDamage = 1
local damageIncrease = 0.1

local startHealth = 10
local healthIncrease = 0.25

local waveTextHideDelay = love.timer.getTime() + 3
local waveSpawnDelay = -1

local started = false

local sprites = {
    HealthbarBase = love.graphics.newImage("/img/healthbar_base.png"),
    Healthbar = love.graphics.newImage("/img/healthbar.png")
}

local sfx = {
    Crumb = love.audio.newSource("/sfx/crumb.wav", "static"),
    Wave = love.audio.newSource("/sfx/wave.wav", "static"),
    Music = love.audio.newSource("/music/music.mp3", "stream")
}


function SpawnWave()
    for i = 1, startingEnemies + (enemyIncrease * (wave - 1)) do
        local enemy = setmetatable({}, require("modules.enemy"))
        
        local function ChoosePos()
            enemy.X = love.math.random(-400,800)
            enemy.Y = love.math.random(-400,800)
            
            if utils:Distance(enemy.X, enemy.Y, player.X, player.Y) <= 300 then ChoosePos() return end
        end
        ChoosePos()
        
        enemy.Speed = startSpeed + (wave - 1) * speedIncrease
        enemy.Damage = startDamage + (wave - 1) * damageIncrease
        enemy.Health = startHealth + (wave - 1) * healthIncrease
        enemy.MaxHealth = startHealth + (wave - 1) * healthIncrease
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

function menu.OnPlay()
    pause.Paused = false
    started = true
    
    shop.X = 300
    shop.Y = 300
    shop.Visible = true
    shop:Load()
    
    sfx.Wave:clone():play()
    waveText.Text = "WAVE "..wave
    yan:NewTween(waveText, yan:TweenInfo(1, EasingStyle.QuadOut), {Position = UIVector2.new(0,0,0,0)}):Play()
    waveTextHideDelay = love.timer.getTime() + 3
    screen.Enabled = true
    SpawnWave()
end

function love.load()
    pause:Load()
    pause.Paused = true

    shop.Visible = false
    love.window.setMode(500,500,{borderless = true})
    cx, cy = love.window.getPosition()
    player:Load(world)
    menu:Load()
    screen = yan:Screen()
    
    screen.Enabled = false
    
    waveText = yan:Label(screen, "WAVE 1", 32, "center", "center", "/Montserrat.ttf")
    waveText.Size = UIVector2.new(1,0,0.1,0)
    waveText.Position = UIVector2.new(0,0,-0.1,0)
    waveText.TextColor = Color.new(1,1,1,1)
    
    crumbsImg = yan:Image(screen, "/img/crumb_ui.png")
    crumbsImg.Position = UIVector2.new(1,-10,0,10)
    crumbsImg.Size = UIVector2.new(0,30,0,30)
    crumbsImg.AnchorPoint = Vector2.new(1,0)
    
    crumbsText = yan:Label(screen, "0", 24, "right", "center", "/Montserrat.ttf")
    crumbsText.Position = UIVector2.new(1,-45,0,10)
    crumbsText.AnchorPoint = Vector2.new(1,0)
    crumbsText.TextColor = Color.new(1,1,1,1)
    crumbsText.Size = UIVector2.new(0.5,0,0,30)
    bgImage = love.graphics.newImage("/img/grass.png")
    bgImage:setWrap("repeat", "repeat")
    bgQuad = love.graphics.newQuad(0, 0, 20000000, 20000000, 800, 600)
    
    sfx.Music:setLooping(true)
    sfx.Music:setVolume(0.3)
    sfx.Music:play()
end

function love.update(dt)
    if not pause.Paused then world:update(dt) end
    
    local deadEnemies = 0

    for _, enemy in ipairs(enemies) do
        if not pause.Paused then enemy:Follow(player, dt) end
        
        if enemy.Dead then
            deadEnemies = deadEnemies + 1
        end
    end

    for _, crumb in ipairs(crumbs) do
        if utils:Distance(player.X, player.Y, crumb.X, crumb.Y) <= 30 then
            if not crumb.Collected then
                crumb.Collected = true
                player.Crumbs = player.Crumbs + 1
                sfx.Crumb:play()
            end
        end
    end
    
    crumbsText.Text = player.Crumbs
    
    if deadEnemies == #enemies and waveSpawnDelay == -1 and started then
        waveSpawnDelay = love.timer.getTime() + 3
        wave = wave + 1
        
        sfx.Wave:clone():play()
        waveText.Text = "WAVE "..wave
        yan:NewTween(waveText, yan:TweenInfo(1, EasingStyle.QuadOut), {Position = UIVector2.new(0,0,0,0)}):Play()
        waveTextHideDelay = love.timer.getTime() + 3
    end
    
    if waveSpawnDelay ~= -1 and love.timer.getTime() > waveSpawnDelay then
        waveSpawnDelay = -1

        SpawnWave()
    end

    if waveTextHideDelay ~= -1 and love.timer.getTime() >= waveTextHideDelay then
        waveTextHideDelay = -1
        yan:NewTween(waveText, yan:TweenInfo(1, EasingStyle.QuadOut), {Position = UIVector2.new(0,0,-0.1,0)}):Play()
    end
    
    if not pause.Paused then player:Update(dt) end
    
    love.window.setPosition(cx, cy)
    if not pause.Paused then 
        cx = cx + player.DX
        cy = cy + player.DY
    end

    if utils:Distance(player.X, player.Y, shop.X + 50, shop.Y + 50) <= 75 then
        shop.Sprite = 2
    else
        shop.Sprite = 1
    end
    
    yan:Update(dt)
end

function love.keypressed(key)
    if key == "space" then
        player:Attack(enemies)
    end
    if key == "e" and not pause.Screen.Enabled then
        print(utils:Distance(player.X, player.Y, shop.X, shop.Y))
        print(player.X, player.Y, shop.X, shop.Y)
        if utils:Distance(player.X, player.Y, shop.X + 50, shop.Y + 50) <= 75 then
            pause.Paused = not pause.Paused
            shop.Screen.Enabled = not shop.Screen.Enabled
        elseif shop.Screen.Enabled then
            pause.Paused = false
            shop.Screen.Enabled = false
        end
    end

    if key == "escape" and shop.Screen.Enabled == false then
        pause.Paused = not pause.Paused
        pause.Screen.Enabled = not pause.Screen.Enabled
    end
end

--[[function love.mousepressed(x,y,button)
    if button == 1 then
        
    end
end]]

function love.draw()
    love.graphics.draw(bgImage, bgQuad, 100 - cx - cxOffset, 10 - cy - cyOffset)
    
    shop:Draw(cx - cxOffset, cy - cyOffset)
    for _, enemy in ipairs(enemies) do
        enemy:Draw(cx - cxOffset, cy - cyOffset)
    end
    for _, crumb in ipairs(crumbs) do
        crumb:Draw(cx - cxOffset, cy - cyOffset)
    end
    player:Draw(cx - cxOffset, cy - cyOffset)
    
    if screen.Enabled then
        love.graphics.draw(sprites.HealthbarBase)
    
        love.graphics.stencil(function ()
            love.graphics.rectangle("fill", 34, 5, (player.Health / player.MaxHealth) * 60, 20)
        end, "replace", 1)
        love.graphics.setStencilTest("greater", 0)
        
        love.graphics.draw(sprites.Healthbar, 34, 5)
        love.graphics.setStencilTest()
    end
    
    yan:Draw()
end