-- src/core.lua
local Core = {}

function Core:Init(name)
    local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    ScreenGui.Name = name or "SunUI"
    ScreenGui.ResetOnSpawn = false
    return ScreenGui
end

return Core
