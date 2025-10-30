-- src/core.lua
local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/tonpseudo/MyFluentLib/main/src/theme.lua"))()
local TweenService = game:GetService("TweenService")

local Core = {}

function Core:CreateWindow(options)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = options.Name or "MyLibUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ResetOnSpawn = false

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 450, 0, 300)
    Frame.Position = UDim2.new(0.5, -225, 0.5, -150)
    Frame.BackgroundColor3 = Theme.Background
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    Frame.Active = true
    Frame.Draggable = true
    Frame.ClipsDescendants = true
    Frame.ZIndex = 5

    local UICorner = Instance.new("UICorner", Frame)
    UICorner.CornerRadius = UDim.new(0, 20)

    if Theme.BorderRGB then
        local UIStroke = Instance.new("UIStroke", Frame)
        UIStroke.Thickness = 2
        spawn(function()
            while task.wait() do
                for i = 0, 255 do
                    UIStroke.Color = Color3.fromHSV(i / 255, 1, 1)
                    task.wait(0.02)
                end
            end
        end)
    end

    return Frame
end

return Core
