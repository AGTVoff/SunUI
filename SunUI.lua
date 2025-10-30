local library = {}
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

function library:createGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ThemeGUI"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 400, 0, 300)
    frame.Position = UDim2.new(0.5, -200, 0.5, -150)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    frame.BorderSizePixel = 0
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 12)
    
    -- Contour RGB animé
    local rgbContour = Instance.new("Frame", frame)
    rgbContour.Size = UDim2.new(1, 8, 1, 8)
    rgbContour.Position = UDim2.new(0, -4, 0, -4)
    rgbContour.BackgroundTransparency = 1
    local uistroke = Instance.new("UIStroke", rgbContour)
    uistroke.Thickness = 4
    uistroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    local hue = 0
    RunService.Heartbeat:Connect(function(dt)
        hue = (hue + dt * 0.2) % 1
        uistroke.Color = Color3.fromHSV(hue,1,1)
    end)
    
    -- Méthodes d'ajout d'éléments :
    function library:addButton(parent, text, size, pos, callback)
        local btn = Instance.new("TextButton", parent)
        btn.Size = size
        btn.Position = pos
        btn.Text = text
        btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        btn.TextColor3 = Color3.new(1,1,1)
        local corner = Instance.new("UICorner", btn)
        corner.CornerRadius = UDim.new(0, 8)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end
    
    function library:addToggle(parent, text, size, pos, initial, callback)
        local btn = self:addButton(parent, text, size, pos, function()
            initial.value = not initial.value
            callback(initial.value)
        end)
        
        local indicator = Instance.new("Frame", btn)
        indicator.Size = UDim2.new(0, 20, 0, 20)
        indicator.Position = UDim2.new(1, -25, 0.5, -10)
        indicator.BackgroundColor3 = initial.value and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
        indicator.BorderSizePixel = 0
        local uic = Instance.new("UICorner", indicator)
        uic.CornerRadius = UDim.new(0, 4)
        
        -- Mise à jour couleur quand toggle changé
        callback = function(val)
            indicator.BackgroundColor3 = val and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
        end
        
        return btn
    end
    
    function library:addSlider(parent, text, size, pos, min, max, default, callback)
        local label = Instance.new("TextLabel", parent)
        label.Size = UDim2.new(0, 200, 0, 20)
        label.Position = pos
        label.Text = text .. ": " .. tostring(default)
        label.TextColor3 = Color3.new(1,0,0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
        
        local sliderFrame = Instance.new("Frame", parent)
        sliderFrame.Size = UDim2.new(0, size.X.Offset, 0, 14)
        sliderFrame.Position = UDim2.new(0, pos.X.Offset, 0, pos.Y.Offset + 20)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
        local corner = Instance.new("UICorner", sliderFrame)
        corner.CornerRadius = UDim.new(0, 7)
        local sliderIndicator = Instance.new("Frame", sliderFrame)
        sliderIndicator.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
        sliderIndicator.BackgroundColor3 = Color3.fromRGB(200,0,0)
        local corner2 = Instance.new("UICorner", sliderIndicator)
        corner2.CornerRadius = UDim.new(0, 7)
        
        local dragging = false
        sliderFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        sliderFrame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        sliderFrame.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local relX = math.clamp(input.Position.X - sliderFrame.AbsolutePosition.X,0,sliderFrame.AbsoluteSize.X)
                local perc = relX / sliderFrame.AbsoluteSize.X
                local val = min + perc * (max - min)
                local displayVal = math.floor(val * 100)/100
                label.Text = text .. ": " .. tostring(displayVal)
                sliderIndicator.Size = UDim2.new(perc, 0, 1, 0)
                callback(displayVal)
            end
        end)
        return callback
    end
    
    function library:addKeybind(parent, label, size, pos, defaultKey, callback)
        local labelObj = Instance.new("TextLabel", parent)
        labelObj.Size = size
        labelObj.Position = pos
        labelObj.Text = label
        labelObj.TextColor3 = Color3.fromRGB(255,0,0)
        labelObj.BackgroundTransparency = 1
        labelObj.Font = Enum.Font.Gotham
        labelObj.TextSize = 14
        local keybindButton = Instance.new("TextButton", parent)
        keybindButton.Size = UDim2.new(0, 40, 0, 20)
        keybindButton.Position = UDim2.new(0, pos.X.Offset + size.X.Offset + 10, 0, pos.Y.Offset)
        keybindButton.Text = tostring(defaultKey.Name)
        keybindButton.BackgroundColor3 = Color3.fromRGB(50,0,0)
        keybindButton.TextColor3 = Color3.new(1,1,1)
        keybindButton.Font = Enum.Font.Gotham
        keybindButton.TextSize = 14
        local listening = false
        keybindButton.MouseButton1Click:Connect(function()
            listening = true
            keybindButton.Text = "Press..."
        end)
        game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
            if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                callback(input.KeyCode)
                keybindButton.Text = tostring(input.KeyCode.Name)
                listening = false
            end
        end)
        return keybindButton
    end
    
    function library:addSelector(parent, label, size, pos, options, defaultIndex, callback)
        local labelTxt=Instance.new("TextLabel", parent)
        labelTxt.Size=size
        labelTxt.Position=pos
        labelTxt.Text=label
        labelTxt.TextColor3=Color3.fromRGB(255,0,0)
        labelTxt.BackgroundTransparency=1
        labelTxt.Font=Enum.Font.Gotham
        labelTxt.TextSize=14
        local sel = Instance.new("TextButton", parent)
        sel.Size=size
        sel.Position=UDim2.new(pos.X.Scale, pos.X.Offset + size.X.Offset + 10, pos.Y.Scale, pos.Y.Offset)
        sel.Text=options[defaultIndex]
        sel.BackgroundColor3=Color3.fromRGB(50,0,0)
        sel.TextColor3=Color3.White
        sel.Font=Enum.Font.Gotham
        sel.TextSize=14
        local index=defaultIndex
        sel.MouseButton1Click:Connect(function()
            index= index%#options +1
            sel.Text= options[index]
            callback(options[index])
        end)
        return sel
    end

    return {
        gui=screenGui,
        frame=frame,
        addButton=library.addButton,
        addToggle=library.addToggle,
        addSlider=library.addSlider,
        addKeybind=library.addKeybind,
        addSelector=library.addSelector,
    }
end

return library
