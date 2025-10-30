-- SunUI.lua
local SunUI = {}

-- ===== Theme =====
SunUI.Theme = {
    Background = Color3.fromRGB(15,15,15),
    Accent = Color3.fromRGB(0,255,120),
    Text = Color3.fromRGB(255,255,255),
    CornerRadius = UDim.new(0,10),
    BorderThickness = 2
}

function SunUI.Theme:GetRGBColor(t)
    local hue = (tick()*100 + t) % 255 / 255
    return Color3.fromHSV(hue,1,1)
end

-- ===== Utils =====
SunUI.Utils = {}
function SunUI.Utils:MakeDraggable(frame, dragArea)
    local UserInputService = game:GetService("UserInputService")
    local dragging, dragInput, start, startPos
    dragArea = dragArea or frame

    local function update(input)
        local delta = input.Position - start
        frame.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,
                                   startPos.Y.Scale,startPos.Y.Offset+delta.Y)
    end

    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            start = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragArea.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input==dragInput and dragging then
            update(input)
        end
    end)
end

-- ===== Core =====
SunUI.Core = {}
function SunUI.Core:Init(name)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = name or "SunUI"
    ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    return ScreenGui
end

-- ===== Components =====
SunUI.Components = {}
function SunUI.Components:MakeCorner(obj)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,8)
    c.Parent = obj
end

function SunUI.Components:CreateTab(parent, name, Theme)
    local Tab = Instance.new("ScrollingFrame", parent)
    Tab.Name = name
    Tab.Size = UDim2.new(1,0,1,-35)
    Tab.Position = UDim2.new(0,0,0,35)
    Tab.BackgroundTransparency = 1
    Tab.ScrollBarThickness = 6
    Tab.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local Layout = Instance.new("UIListLayout",Tab)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0,8)

    -- Toggle
    function Tab:AddToggle(label, callback)
        local Toggle = Instance.new("TextButton",Tab)
        Toggle.Size = UDim2.new(1,-20,0,35)
        Toggle.BackgroundColor3 = Theme.Background
        Toggle.TextColor3 = Theme.Text
        Toggle.Text = label..": OFF"
        Toggle.Font = Enum.Font.Gotham
        Toggle.TextScaled = true
        SunUI.Components:MakeCorner(Toggle)
        local state = false
        Toggle.MouseButton1Click:Connect(function()
            state = not state
            Toggle.Text = label..(state and ": ON" or ": OFF")
            callback(state)
        end)
    end

    -- Button
    function Tab:AddButton(label, callback)
        local Btn = Instance.new("TextButton",Tab)
        Btn.Size = UDim2.new(1,-20,0,35)
        Btn.BackgroundColor3 = Theme.Accent
        Btn.TextColor3 = Theme.Text
        Btn.Text = label
        Btn.Font = Enum.Font.GothamBold
        Btn.TextScaled = true
        SunUI.Components:MakeCorner(Btn)
        Btn.MouseButton1Click:Connect(callback)
    end

    -- Slider
    function Tab:AddSlider(label,min,max,default,callback)
        local FrameS = Instance.new("Frame",Tab)
        FrameS.Size = UDim2.new(1,-20,0,35)
        FrameS.BackgroundColor3 = Theme.Background
        SunUI.Components:MakeCorner(FrameS)

        local Bar = Instance.new("Frame",FrameS)
        Bar.BackgroundColor3 = Theme.Accent
        SunUI.Components:MakeCorner(Bar)
        Bar.Size = UDim2.new(default/max,0,1,0)

        local Label = Instance.new("TextLabel",FrameS)
        Label.Text = label..": "..default
        Label.Size = UDim2.new(1,0,1,0)
        Label.BackgroundTransparency = 1
        Label.TextColor3 = Theme.Text
        Label.Font = Enum.Font.Gotham
        Label.TextScaled = true

        local value = default
        FrameS.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local conn
                conn = game:GetService("UserInputService").InputChanged:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseMovement then
                        local rel = math.clamp((i.Position.X - FrameS.AbsolutePosition.X)/FrameS.AbsoluteSize.X,0,1)
                        value = math.floor(min + (max-min)*rel)
                        Bar.Size = UDim2.new(rel,0,1,0)
                        Label.Text = label..": "..value
                        callback(value)
                    end
                end)
                input.Changed:Connect(function()
                    if input.UserInputState==Enum.UserInputState.End then conn:Disconnect() end
                end)
            end
        end)
    end

    -- Selector
    function Tab:AddSelector(label,options,callback)
        local Btn = Instance.new("TextButton",Tab)
        Btn.Size = UDim2.new(1,-20,0,35)
        Btn.BackgroundColor3 = Theme.Background
        Btn.TextColor3 = Theme.Text
        Btn.Font = Enum.Font.Gotham
        Btn.TextScaled = true
        SunUI.Components:MakeCorner(Btn)
        local index = 1
        Btn.Text = label..": "..options[index]
        Btn.MouseButton1Click:Connect(function()
            index = index % #options + 1
            Btn.Text = label..": "..options[index]
            callback(options[index])
        end)
    end

    -- KeyBinder
    function Tab:AddKeyBinder(label,defaultKey,callback)
        local Btn = Instance.new("TextButton",Tab)
        Btn.Size = UDim2.new(1,-20,0,35)
        Btn.BackgroundColor3 = Theme.Background
        Btn.TextColor3 = Theme.Text
        Btn.Font = Enum.Font.Gotham
        Btn.TextScaled = true
        SunUI.Components:MakeCorner(Btn)

        local binding = false
        Btn.Text = label.." ["..defaultKey.Name.."]"
        Btn.MouseButton1Click:Connect(function()
            Btn.Text = label.." [Press Key]"
            binding=true
        end)

        game:GetService("UserInputService").InputBegan:Connect(function(input)
            if binding and input.UserInputType==Enum.UserInputType.Keyboard then
                Btn.Text = label.." ["..input.KeyCode.Name.."]"
                callback(input.KeyCode)
                binding=false
            end
        end)
    end

    return Tab
end

-- ===== Window =====
SunUI.Window = {}
function SunUI.Window:Create(title)
    local Gui = SunUI.Core:Init(title)
    local Frame = Instance.new("Frame",Gui)
    Frame.Size = UDim2.new(0,500,0,350)
    Frame.Position = UDim2.new(0.5,-250,0.5,-175)
    Frame.BackgroundColor3 = SunUI.Theme.Background
    Frame.BorderSizePixel = 0
    Instance.new("UICorner",Frame).CornerRadius = SunUI.Theme.CornerRadius

    local Border = Instance.new("UIStroke",Frame)
    Border.Thickness = SunUI.Theme.BorderThickness
    task.spawn(function()
        while task.wait(0.05) do
            Border.Color = SunUI.Theme:GetRGBColor(tick())
        end
    end)

    local TitleLabel = Instance.new("TextLabel",Frame)
    TitleLabel.Size = UDim2.new(1,0,0,35)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 20
    TitleLabel.TextColor3 = SunUI.Theme.Accent

    SunUI.Utils:MakeDraggable(Frame,TitleLabel)

    local TabBar = Instance.new("Frame",Frame)
    TabBar.Size = UDim2.new(1,0,0,35)
    TabBar.Position = UDim2.new(0,0,0,0)
    TabBar.BackgroundTransparency=1

    local tabs={}
    function Frame:AddTab(name)
        local Tab = SunUI.Components:CreateTab(Frame,name,SunUI.Theme)
        Tab.Visible=false
        table.insert(tabs,Tab)

        local Btn = Instance.new("TextButton",TabBar)
        Btn.Size=UDim2.new(0,120,1,0)
        Btn.Position=UDim2.new(0,(#tabs-1)*125,0,0)
        Btn.Text=name
        Btn.Font=Enum.Font.Gotham
        Btn.TextColor3=SunUI.Theme.Text
        Btn.TextScaled=true
        Btn.BackgroundColor3=SunUI.Theme.Background
        SunUI.Components:MakeCorner(Btn)

        Btn.MouseButton1Click:Connect(function()
            for i,t in ipairs(tabs) do
                t.Visible=(t==Tab)
            end
        end)

        if #tabs==1 then Tab.Visible=true end
        return Tab
    end

    return Frame
end

return SunUI
