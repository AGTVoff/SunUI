-- example.lua
local SunUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/AGTVoff/SunUI/main/main.lua"))()
local Window = SunUI.Window:Create("SunUI Example")

-- Onglet 1
local Tab1 = Window:AddTab("General")
Tab1:AddToggle("Enable Feature", function(v) print("General Toggle:", v) end)
Tab1:AddButton("Run Action", function() print("General Button pressed") end)
Tab1:AddSlider("Volume", 0, 100, 50, function(v) print("General Slider:", v) end)
Tab1:AddSelector("Mode", {"Easy", "Normal", "Hard"}, function(opt) print("General Selected:", opt) end)
Tab1:AddKeyBinder("Hotkey", Enum.KeyCode.F, function(k) print("General Key bound to:", k.Name) end)

-- Onglet 2
local Tab2 = Window:AddTab("Combat")
Tab2:AddToggle("God Mode", function(v) print("Combat Toggle:", v) end)
Tab2:AddButton("Self Destruct", function() print("Combat Button activated") end)
Tab2:AddSlider("Speed", 0, 20, 5, function(v) print("Combat Slider:", v) end)
Tab2:AddSelector("Weapon", {"Pistol", "Rifle", "Sniper"}, function(opt) print("Combat Selected:", opt) end)
Tab2:AddKeyBinder("Custom Key", Enum.KeyCode.G, function(k) print("Combat Key bound to:", k.Name) end)

-- Onglet 3
local Tab3 = Window:AddTab("Misc")
Tab3:AddToggle("Fly Mode", function(v) print("Misc Toggle:", v) end)
Tab3:AddButton("Teleport Home", function() print("Misc Button executed") end)
Tab3:AddSlider("Height", 0, 100, 25, function(v) print("Misc Slider:", v) end)
Tab3:AddSelector("Rainbow Mode", {"Off", "On"}, function(opt) print("Misc Selected:", opt) end)
Tab3:AddKeyBinder("Toggle GUI", Enum.KeyCode.H, function(k) print("Misc Key bound to:", k.Name) end)
