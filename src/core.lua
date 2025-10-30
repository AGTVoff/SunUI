-- src/core.lua
local Core = {}

function Core:Init(name)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = name or "SunUI"
    ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    return ScreenGui
end

return Core
