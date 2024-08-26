local pause = {}

pause.Paused = false

require("yan")

function pause:Load()
    self.Screen = yan:Screen()
    self.Screen.Enabled = false
    resumeBtn = yan:TextButton(self.Screen, "Resume", 32, "center", "center", "/Montserrat.ttf")
    resumeBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    resumeBtn.Position = UIVector2.new(0.5, 0, 0.5, 0)
    resumeBtn.Size = UIVector2.new(0.5, 0, 0.2, 0)
    
    resumeBtn.MouseEnter = function ()
        resumeBtn.Size = UIVector2.new(0.5,10,0.2,10)
        resumeBtn.Color = Color.new(0.7,0.7,0.7,1)
    end
    
    resumeBtn.MouseLeave = function ()
        resumeBtn.Size = UIVector2.new(0.5,0,0.2,0)
        resumeBtn.Color = Color.new(1,1,1,1)
    end

    resumeBtn.MouseDown = function ()
        self.Paused = false
        self.Screen.Enabled = false
    end

    quitBtn = yan:TextButton(self.Screen, "Quit", 32, "center", "center", "/Montserrat.ttf")
    quitBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    quitBtn.Position = UIVector2.new(0.5, 0, 0.7, 30)
    quitBtn.Size = UIVector2.new(0.5, 0, 0.2, 0)

    quitBtn.MouseEnter = function ()
        quitBtn.Size = UIVector2.new(0.5,10,0.2,10)
        quitBtn.Color = Color.new(0.7,0.7,0.7,1)
    end
    
    quitBtn.MouseLeave = function ()
        quitBtn.Size = UIVector2.new(0.5,0,0.2,0)
        quitBtn.Color = Color.new(1,1,1,1)
    end
end

return pause