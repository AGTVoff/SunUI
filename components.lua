-- src/components.lua
local Components = {}

function Components:AddButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -20, 0, 30)
    Button.Position = UDim2.new(0, 10, 0, 10)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255,255,255)
    Button.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Button.Font = Enum.Font.GothamSemibold
    Button.Parent = parent
    Button.MouseButton1Click:Connect(function()
        callback()
    end)
    local UICorner = Instance.new("UICorner", Button)
    UICorner.CornerRadius = UDim.new(0,8)
    return Button
end

return Components
