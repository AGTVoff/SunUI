-- src/components.lua
local Components = {}

local function MakeCorner(obj)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = obj
end

function Components:CreateTab(parent, name, Theme)
    local Tab = Instance.new("Frame", parent)
    Tab.Name = name
    Tab.Size = UDim2.new(1, 0, 1, -35)
    Tab.Position = UDim2.new(0, 0, 0, 35)
    Tab.BackgroundTransparency = 1

    local Layout = Instance.new("UIListLayout", Tab)
    Layout.Padding = UDim.new(0, 10)

    function Tab:AddToggle(label, callback)
        local Toggle = Instance.new("TextButton", Tab)
        Toggle.Text = label .. ": OFF"
        Toggle.BackgroundColor3 = Theme.Background
        Toggle.TextColor3 = Theme.Text
        MakeCorner(Toggle)
        Toggle.Font = Enum.Font.Gotham
        Toggle.TextScaled = true

        local state = false
        Toggle.MouseButton1Click:Connect(function()
            state = not state
            Toggle.Text = label .. (state and ": ON" or ": OFF")
            callback(state)
        end)
    end

    function Tab:AddButton(label, callback)
        local Btn = Instance.new("TextButton", Tab)
        Btn.Text = label
        Btn.BackgroundColor3 = Theme.Accent
        Btn.TextColor3 = Theme.Text
        MakeCorner(Btn)
        Btn.Font = Enum.Font.Gotham
        Btn.TextScaled = true
        Btn.MouseButton1Click:Connect(callback)
    end

    function Tab:AddSlider(label, min, max, default, callback)
        local FrameS = Instance.new("Frame", Tab)
        FrameS.Size = UDim2.new(0, 400, 0, 30)
        FrameS.BackgroundColor3 = Theme.Background
        MakeCorner(FrameS)

        local Bar = Instance.new("Frame", FrameS)
        Bar.BackgroundColor3 = Theme.Accent
        MakeCorner(Bar)
        Bar.Size = UDim2.new(default / max, 0, 1, 0)

        local Label = Instance.new("TextLabel", FrameS)
        Label.Text = label .. ": " .. default
        Label.Size = UDim2.new(1, 0, 1, 0)
        Label.BackgroundTransparency = 1
        Label.TextColor3 = Theme.Text
        Label.Font = Enum.Font.Gotham
        Label.TextScaled = true

        local value = default
        FrameS.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local conn
                conn = game:GetService("UserInputService").InputChanged:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseMovement then
                        local rel = math.clamp((i.Position.X - FrameS.AbsolutePosition.X)/FrameS.AbsoluteSize.X, 0, 1)
                        value = math.floor(min + (max - min) * rel)
                        Bar.Size = UDim2.new(rel, 0, 1, 0)
                        Label.Text = label .. ": " .. value
                        callback(value)
                    end
                end)
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        conn:Disconnect()
                    end
                end)
            end
        end)
    end

    function Tab:AddSelector(label, options, callback)
        local Btn = Instance.new("TextButton", Tab)
        Btn.Text = label .. ": " .. options[1]
        Btn.BackgroundColor3 = Theme.Background
        Btn.TextColor3 = Theme.Text
        MakeCorner(Btn)
        Btn.Font = Enum.Font.Gotham
        Btn.TextScaled = true

        local index = 1
        Btn.MouseButton1Click:Connect(function()
            index = index % #options + 1
            Btn.Text = label .. ": " .. options[index]
            callback(options[index])
        end)
    end

    function Tab:AddKeyBinder(label, defaultKey, callback)
        local Btn = Instance.new("TextButton", Tab)
        Btn.Text = label .. ": [" .. defaultKey.Name .. "]"
        Btn.BackgroundColor3 = Theme.Background
        Btn.TextColor3 = Theme.Text
        MakeCorner(Btn)
        Btn.Font = Enum.Font.Gotham
        Btn.TextScaled = true

        local binding = false
        Btn.MouseButton1Click:Connect(function()
            Btn.Text = label .. ": [Press Key]"
            binding = true
        end)

        game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
            if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                Btn.Text = label .. ": [" .. input.KeyCode.Name .. "]"
                callback(input.KeyCode)
                binding = false
            end
        end)
    end

    return Tab
end

return Components
