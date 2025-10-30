-- // SunUI Library by AGTV (Stylish Fluent-Inspired UI)
-- // Single file, no dependencies

local SunUI = {}
SunUI.__index = SunUI

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Tween helper
local function Tween(obj, prop, goal, time)
	game:GetService("TweenService"):Create(obj, TweenInfo.new(time or 0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {[prop] = goal}):Play()
end

-- Draggable helper
local function MakeDraggable(frame)
	local dragging = false
	local dragInput, dragStart, startPos

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- // Create Window
function SunUI:CreateWindow(config)
	local window = Instance.new("ScreenGui")
	window.Name = config.Name or "SunUI"
	window.ResetOnSpawn = false
	window.Parent = PlayerGui

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 520, 0, 360)
	frame.Position = UDim2.new(0.5, -260, 0.5, -180)
	frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	frame.BorderSizePixel = 0
	frame.Parent = window

	MakeDraggable(frame)

	-- RGB outline
	local outline = Instance.new("UIStroke")
	outline.Thickness = 2
	outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	outline.Parent = frame

	local hue = 0
	RunService.RenderStepped:Connect(function(dt)
		hue = (hue + dt * 0.2) % 1
		outline.Color = Color3.fromHSV(hue, 1, 1)
	end)

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = frame

	local title = Instance.new("TextLabel")
	title.Text = config.Title or "SunUI"
	title.Size = UDim2.new(1, 0, 0, 40)
	title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	title.TextColor3 = Color3.new(1, 1, 1)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 18
	title.Parent = frame

	local tabsFrame = Instance.new("Frame")
	tabsFrame.Size = UDim2.new(0, 120, 1, -40)
	tabsFrame.Position = UDim2.new(0, 0, 0, 40)
	tabsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	tabsFrame.Parent = frame

	local tabCorner = Instance.new("UICorner")
	tabCorner.CornerRadius = UDim.new(0, 12)
	tabCorner.Parent = tabsFrame

	local content = Instance.new("Frame")
	content.Size = UDim2.new(1, -130, 1, -40)
	content.Position = UDim2.new(0, 130, 0, 40)
	content.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	content.Parent = frame

	local contentCorner = Instance.new("UICorner")
	contentCorner.CornerRadius = UDim.new(0, 12)
	contentCorner.Parent = content

	local selectedTab
	local tabs = {}

	function SunUI:AddTab(tabName)
		local tabBtn = Instance.new("TextButton")
		tabBtn.Text = tabName
		tabBtn.Size = UDim2.new(1, 0, 0, 35)
		tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		tabBtn.TextColor3 = Color3.new(1, 1, 1)
		tabBtn.Font = Enum.Font.Gotham
		tabBtn.TextSize = 14
		tabBtn.Parent = tabsFrame

		local tabFrame = Instance.new("ScrollingFrame")
		tabFrame.Visible = false
		tabFrame.Size = UDim2.new(1, -10, 1, -10)
		tabFrame.Position = UDim2.new(0, 5, 0, 5)
		tabFrame.BackgroundTransparency = 1
		tabFrame.ScrollBarThickness = 5
		tabFrame.Parent = content

		local layout = Instance.new("UIListLayout")
		layout.Padding = UDim.new(0, 8)
		layout.Parent = tabFrame

		tabBtn.MouseButton1Click:Connect(function()
			if selectedTab then selectedTab.Visible = false end
			tabFrame.Visible = true
			selectedTab = tabFrame
			for _, b in ipairs(tabsFrame:GetChildren()) do
				if b:IsA("TextButton") then
					Tween(b, "BackgroundColor3", Color3.fromRGB(30, 30, 30), 0.2)
				end
			end
			Tween(tabBtn, "BackgroundColor3", Color3.fromRGB(255, 140, 0), 0.2)
		end)

		-- Elements
		local tabObj = {}

		function tabObj:AddToggle(name, default, callback)
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -10, 0, 30)
			btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 14
			btn.Text = name .. ": " .. (default and "ON" or "OFF")
			btn.Parent = tabFrame

			local state = default
			btn.MouseButton1Click:Connect(function()
				state = not state
				btn.Text = name .. ": " .. (state and "ON" or "OFF")
				Tween(btn, "BackgroundColor3", state and Color3.fromRGB(255, 140, 0) or Color3.fromRGB(40, 40, 40), 0.2)
				if callback then callback(state) end
			end)
		end

		function tabObj:AddSlider(name, min, max, default, callback)
			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1, -10, 0, 25)
			label.BackgroundTransparency = 1
			label.Text = name .. ": " .. default
			label.TextColor3 = Color3.new(1, 1, 1)
			label.Font = Enum.Font.Gotham
			label.TextSize = 14
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = tabFrame

			local bar = Instance.new("Frame")
			bar.Size = UDim2.new(1, -10, 0, 6)
			bar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			bar.Parent = tabFrame

			local fill = Instance.new("Frame")
			fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
			fill.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
			fill.Parent = bar

			local dragging = false
			bar.InputBegan:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
			end)
			bar.InputEnded:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
			end)

			UserInputService.InputChanged:Connect(function(i)
				if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
					local ratio = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
					local val = math.floor(min + (max - min) * ratio)
					fill.Size = UDim2.new(ratio, 0, 1, 0)
					label.Text = name .. ": " .. val
					if callback then callback(val) end
				end
			end)
		end

		function tabObj:AddDropdown(name, options, callback)
			local drop = Instance.new("TextButton")
			drop.Size = UDim2.new(1, -10, 0, 30)
			drop.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			drop.TextColor3 = Color3.new(1, 1, 1)
			drop.Font = Enum.Font.Gotham
			drop.TextSize = 14
			drop.Text = name .. " ▼"
			drop.Parent = tabFrame

			local list = Instance.new("Frame")
			list.Size = UDim2.new(1, 0, 0, #options * 25)
			list.Position = UDim2.new(0, 0, 1, 0)
			list.Visible = false
			list.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			list.Parent = drop

			for _, opt in ipairs(options) do
				local o = Instance.new("TextButton")
				o.Size = UDim2.new(1, 0, 0, 25)
				o.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				o.TextColor3 = Color3.new(1, 1, 1)
				o.Text = opt
				o.Font = Enum.Font.Gotham
				o.TextSize = 14
				o.Parent = list
				o.MouseButton1Click:Connect(function()
					drop.Text = name .. ": " .. opt
					list.Visible = false
					if callback then callback(opt) end
				end)
			end

			drop.MouseButton1Click:Connect(function()
				list.Visible = not list.Visible
			end)
		end

		function tabObj:AddKeybind(name, default, callback)
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -10, 0, 30)
			btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 14
			btn.Text = name .. ": " .. default.Name
			btn.Parent = tabFrame

			local waiting = false
			btn.MouseButton1Click:Connect(function()
				btn.Text = name .. ": ..."
				waiting = true
			end)

			UserInputService.InputBegan:Connect(function(i)
				if waiting then
					waiting = false
					btn.Text = name .. ": " .. i.KeyCode.Name
					if callback then callback(i.KeyCode) end
				end
			end)
		end

		table.insert(tabs, tabObj)
		return tabObj
	end

	return setmetatable({AddTab = SunUI.AddTab}, SunUI)
end

return SunUI
