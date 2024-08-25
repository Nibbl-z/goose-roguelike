local shop = {}

shop.X = 0
shop.Y = 0
shop.Visible = false
require 'yan'
local sprite = love.graphics.newImage("/img/shop.png")
local player = require("modules.player")
local purchases = {
    {
        Name = "Heal",
        Description = "Heals 10 health",
        Price = 10,
        OnPurchase = function (player)
            player.Health  = player.Health + 10
            if player.Health > player.MaxHealth then
                player.Health = player.MaxHealth
            end
        end
    }
}

function shop:Load()
    self.Screen = yan:Screen()
    self.Screen.Enabled = false
    frame = yan:Frame(self.Screen)
    frame.Size = UIVector2.new(0.6,0,0.6,0)
    frame.Position = UIVector2.new(0.5,0,0.5,0)
    frame.AnchorPoint = Vector2.new(0.5,0.5)
    frame.Padding = UIVector2.new(0,5,0,5)

    frame.Color = Color.new(0,0,0,0.5)
    
    for i, purchase in ipairs(purchases) do
        purchaseFrame = yan:Frame(self.Screen)
        purchaseFrame.Position = UIVector2.new(0,0,0.2 * (i - 1), 10 * (i - 1))
        purchaseFrame.Size = UIVector2.new(1,0,0.2,0)
        purchaseFrame.Color = Color.new(0.2,0.2,0.2,1)
        purchaseFrame.Padding = UIVector2.new(0,10,0,10)
        purchaseFrame:SetParent(frame)
        
        titleLabel = yan:Label(self.Screen, purchase.Name, 25, "left", "center")
        titleLabel.Size = UIVector2.new(0.6,0,0.6,0)
        titleLabel.TextColor = Color.new(1,1,1,1)
        titleLabel:SetParent(purchaseFrame)
        titleLabel.ZIndex = 3
        
        descriptionLabel = yan:Label(self.Screen, purchase.Description, 15, "left", "center")
        descriptionLabel.Size = UIVector2.new(0.6,0,0.4,0)
        descriptionLabel.Position = UIVector2.new(0,0,0.6,0)
        descriptionLabel.TextColor = Color.new(1,1,1,1)
        descriptionLabel:SetParent(purchaseFrame)
        descriptionLabel.ZIndex = 3
        
        purchaseButton = yan:TextButton(self.Screen, purchase.Price.." Crumbs", 15, "center", "center")
        purchaseButton.Size = UIVector2.new(0.4,0,1,0)
        purchaseButton.Position = UIVector2.new(0.6,0,0,0)
        purchaseButton.Color = Color.new(0,1,0,1)
        purchaseButton.TextColor = Color.new(1,1,1,1)
        purchaseButton:SetParent(purchaseFrame)
        purchaseButton.ZIndex = 3

        purchaseButton.MouseDown = function ()
            if player.Crumbs >= purchase.Price then
                player.Crumbs = player.Crumbs - purchase.Price
                purchase.OnPurchase(player)
            end
            
        end
    end
end

function shop:Draw(cx, cy)
    love.graphics.draw(sprite, self.X - cx, self.Y - cy)
end

return shop