local menu = {}

menu.Enabled = true

require("yan")

local clickSfx = love.audio.newSource("/sfx/select.wav", "static")

function menu:Load()
    self.Screen = yan:Screen()
    
    logoImg = yan:Image(self.Screen, "/img/logo.png")
    logoImg.Size = UIVector2.new(0,500,0,250)
    
    playButton = yan:TextButton(self.Screen, "Play", 40, "center", "center", "/Montserrat.ttf")
    playButton.Position = UIVector2.new(0.5,0,0.7,0)
    playButton.Size = UIVector2.new(0.5, 0, 0.2, 0)
    playButton.AnchorPoint = Vector2.new(0.5, 0.5)
    
    playButton.MouseEnter = function ()
        playButton.Size = UIVector2.new(0.5,10,0.2,10)
        playButton.Color = Color.new(0.7,0.7,0.7,1)
    end
    
    playButton.MouseLeave = function ()
        playButton.Size = UIVector2.new(0.5,0,0.2,0)
        playButton.Color = Color.new(1,1,1,1)
    end
    
    playButton.MouseDown = function ()
        clickSfx:play()
        self.Enabled = false
        self.Screen.Enabled = false
        self.OnPlay()
    end
end

return menu