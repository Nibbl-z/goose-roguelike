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
    },
    
    {
        Name = "Strength",
        Description = "Increase sword damage by 2",
        Price = 15,
        OnPurchase = function (player)
            player.Strength = player.Strength + 2
        end
    },

    {
        Name = "Bigger Sword",
        Description = "Increase sword range by 5",
        Price = 15,
        OnPurchase = function (player)
            player.SwordSize = player.SwordSize + 5
        end
    },

    {
        Name = "Speed",
        Description = "Increases your movement speed by 10%",
        Price = 10,
        OnPurchase = function (player)
            player.Speed = player.Speed + 5
        end
    },

    {
        Name = "Max Health",
        Description = "Increases your maximum health by 10",
        Price = 10,
        OnPurchase = function (player)
            player.MaxHealth = player.MaxHealth + 10
        end
    }
}

function shop:Load()
    self.Screen = yan:Screen()
    self.Screen.Enabled = false
    
    frameImg = yan:Image(self.Screen, "/img/shop_frame.png")

    frame = yan:Frame(self.Screen)
    frame.Size = UIVector2.new(0.8,0,0.8,0)
    frame.Position = UIVector2.new(0.5,0,0.5,0)
    frame.AnchorPoint = Vector2.new(0.5,0.5)
    frame.Padding = UIVector2.new(0,5,0,5)
    
    frame.Color = Color.new(0,0,0,0)
    
    for i, purchase in ipairs(purchases) do
        purchaseFrame = yan:Image(self.Screen, "/img/shop_item.png")
        purchaseFrame.Position = UIVector2.new(0,0,0.15 * (i - 1) + 0.1, 10 * (i - 1))
        purchaseFrame.Size = UIVector2.new(1,0,0.15,0)
        --purchaseFrame.Color = Color.new(0.2,0.2,0.2,0)
        purchaseFrame.Padding = UIVector2.new(0,12,0,12)
        purchaseFrame:SetParent(frame)
        
        titleLabel = yan:Label(self.Screen, purchase.Name, 15, "left", "center", "/Montserrat.ttf")
        titleLabel.Size = UIVector2.new(0.7,0,0.6,0)
        titleLabel.TextColor = Color.new(1,1,1,1)
        titleLabel:SetParent(purchaseFrame)
        titleLabel.ZIndex = 3
        
        descriptionLabel = yan:Label(self.Screen, purchase.Description, 12, "left", "center", "/Montserrat.ttf")
        descriptionLabel.Size = UIVector2.new(0.7,0,0.4,0)
        descriptionLabel.Position = UIVector2.new(0,0,0.5,0)
        descriptionLabel.TextColor = Color.new(0.8,0.8,0.8,1)
        descriptionLabel:SetParent(purchaseFrame)
        descriptionLabel.ZIndex = 3
        
        purchaseButton = yan:TextButton(self.Screen, purchase.Price.." Crumbs", 15, "center", "center", "/Montserrat.ttf")
        purchaseButton.Size = UIVector2.new(0.3,0,1,0)
        purchaseButton.Position = UIVector2.new(0.7,0,0,0)
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