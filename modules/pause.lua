local pause = {}

pause.Paused = false

require("yan")

local clickSfx = love.audio.newSource("/sfx/select.wav", "static")

function pause:Load()
    self.Screen = yan:Screen()
    self.Screen.Enabled = false
    self.Screen.ZIndex = 5
    
    bgFrame = yan:Frame(self.Screen)
    bgFrame.Color = Color.new(0,0,0,0.5)
    bgFrame.ZIndex = -1

    pauseImg = yan:Image(self.Screen, "/img/paused.png")
    pauseImg.Size = UIVector2.new(0, 500, 0, 100)
    pauseImg.Position = UIVector2.new(0,0,0.1,0)

    resumeBtn = yan:TextButton(self.Screen, "Resume", 32, "center", "center", "/Montserrat.ttf")
    resumeBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    resumeBtn.Position = UIVector2.new(0.5, 0, 0.5, 0)
    resumeBtn.Size = UIVector2.new(0.5, 0, 0.2, 0)
    resumeBtn.Color = Color.new(0, 133/255, 58/255, 1)
    resumeBtn.TextColor = Color.new(1,1,1,1)

    resumeBtn.MouseEnter = function ()
        resumeBtn.Size = UIVector2.new(0.5,10,0.2,10)
        resumeBtn.Color = Color.new(0, 113/255, 38/255, 1)
    end
    
    resumeBtn.MouseLeave = function ()
        resumeBtn.Size = UIVector2.new(0.5,0,0.2,0)
        resumeBtn.Color = Color.new(0, 133/255, 58/255, 1)
    end

    resumeBtn.MouseDown = function ()
        clickSfx:play()
        self.Paused = false
        self.Screen.Enabled = false
    end

    quitBtn = yan:TextButton(self.Screen, "Quit", 32, "center", "center", "/Montserrat.ttf")
    quitBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    quitBtn.Position = UIVector2.new(0.5, 0, 0.7, 30)
    quitBtn.Size = UIVector2.new(0.5, 0, 0.2, 0)
    quitBtn.Color = Color.new(0, 133/255, 58/255, 1)
    quitBtn.TextColor = Color.new(1,1,1,1)
    

    quitBtn.MouseEnter = function ()
        quitBtn.Size = UIVector2.new(0.5,10,0.2,10)
        quitBtn.Color = Color.new(0, 113/255, 38/255, 1)
    end
    
    quitBtn.MouseLeave = function ()
        quitBtn.Size = UIVector2.new(0.5,0,0.2,0)
        quitBtn.Color = Color.new(0, 133/255, 58/255, 1)
    end
    
    quitBtn.MouseDown = function ()
        clickSfx:play()
        love.event.quit()
    end
end

return pause