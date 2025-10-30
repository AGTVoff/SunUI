-- example.lua
local SunUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/AGTVoff/SunUI/main/main.lua"))()
local Window = SunUI.Window:Create("SunUI Example")

local Tab1 = Window:AddTab("General")
Tab1:AddToggle("God Mode", function(v) print("God mode:", v) end)
Tab1:AddButton("Self Destruct", function() print("Boom!") end)
Tab1:AddSlider("Speed", 0, 100, 50, function(v) print("Speed:", v) end)
Tab1:AddSelector("Team", {"Blue", "Red", "Green"}, function(opt) print("Team:", opt) end)
Tab1:AddKeyBinder("Dash", Enum.KeyCode.F, function(k) print("Key set to:", k.Name) end)
