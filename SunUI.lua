-- // SunUI Library by AGTV (inspired by Linoria)
-- // Single-file library (no dependencies)

local SunUI = {}
SunUI.__index = SunUI

-- // Services
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- // Core creation
function SunUI:CreateWindow(config)
	local window = Instance.new("ScreenGui")
	window.Name = config.Name or "SunUI Demo"
	window.ResetOnSpawn = false
	window.Parent = PlayerGui

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "Frame"
	mainFrame.Size = UDim2.new(0, 500, 0, 350)
	mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
	mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = window

	local title = Instance.new("TextLabel")
	title.Text = config.Title or "SunUI"
	title.Size = UDim2.new(1, 0, 0, 30)
	title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	title.TextColor3 = Color3.new(1, 1, 1)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 16
	title.Parent = mainFrame

	local tabContainer = Instance.new("Frame")
	tabContainer.Size = UDim2.new(0, 120, 1, -30)
	tabContainer.Position = UDim2.new(0, 0, 0, 30)
	tabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	tabContainer.Parent = mainFrame

	local contentContainer = Instance.new("Frame")
	contentContainer.Size = UDim2.new(1, -120, 1, -30)
	contentContainer.Position = UDim2.new(0, 120, 0, 30)
	contentContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	contentContainer.Parent = mainFrame

	local tabs = {}
	local selectedTab

	function SunUI:AddTab(tabName)
		local tabButton = Instance.new("TextButton")
		tabButton.Text = tabName
		tabButton.Size = UDim2.new(1, 0, 0, 35)
		tabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		tabButton.TextColor3 = Color3.new(1, 1, 1)
		tabButton.Parent = tabContainer

		local tabFrame = Instance.new("ScrollingFrame")
		tabFrame.Visible = false
		tabFrame.Size = UDim2.new(1, -10, 1, -10)
		tabFrame.Position = UDim2.new(0, 5, 0, 5)
		tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
		tabFrame.ScrollBarThickness = 4
		tabFrame.BackgroundTransparency = 1
		tabFrame.Parent = contentContainer

		local layout = Instance.new("UIListLayout")
		layout.Padding = UDim.new(0, 8)
		layout.Parent = tabFrame

		tabButton.MouseButton1Click:Connect(function()
			if selectedTab then selectedTab.Visible = false end
			tabFrame.Visible = true
			selectedTab = tabFrame
		end)

		local tabObj = {}

		function tabObj:AddToggle(name, default, callback)
			local toggle = Instance.new("TextButton")
			toggle.Size = UDim2.new(1, -10, 0, 30)
			toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			toggle.TextColor3 = Color3.new(1, 1, 1)
			toggle.Text = name .. ": " .. (default and "ON" or "OFF")
			toggle.Parent = tabFrame

			local state = default

			toggle.MouseButton1Click:Connect(function()
				state = not state
				toggle.Text = name .. ": " .. (state and "ON" or "OFF")
				if callback then callback(state) end
			end)
		end

		function tabObj:AddSlider(name, min, max, default, callback)
			local label = Instance.new("TextLabel")
			label.Text = name .. ": " .. default
			label.Size = UDim2.new(1, -10, 0, 25)
			label.TextColor3 = Color3.new(1, 1, 1)
			label.BackgroundTransparency = 1
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = tabFrame

			local sliderFrame = Instance.new("Frame")
			sliderFrame.Size = UDim2.new(1, -10, 0, 6)
			sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			sliderFrame.Parent = tabFrame

			local fill = Instance.new("Frame")
			fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
			fill.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
			fill.Parent = sliderFrame

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

			game:GetService("UserInputService").InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local ratio = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
					local value = math.floor(min + (max - min) * ratio)
					fill.Size = UDim2.new(ratio, 0, 1, 0)
					label.Text = name .. ": " .. value
					if callback then callback(value) end
				end
			end)
		end

		function tabObj:AddDropdown(name, options, callback)
			local drop = Instance.new("TextButton")
			drop.Size = UDim2.new(1, -10, 0, 30)
			drop.TextColor3 = Color3.new(1, 1, 1)
			drop.Text = name .. " ▼"
			drop.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			drop.Parent = tabFrame

			local open = false
			local list = Instance.new("Frame")
			list.Visible = false
			list.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			list.Position = UDim2.new(0, 0, 1, 0)
			list.Size = UDim2.new(1, 0, 0, #options * 25)
			list.Parent = drop

			for _, opt in ipairs(options) do
				local btn = Instance.new("TextButton")
				btn.Size = UDim2.new(1, 0, 0, 25)
				btn.Text = opt
				btn.TextColor3 = Color3.new(1, 1, 1)
				btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				btn.Parent = list

				btn.MouseButton1Click:Connect(function()
					drop.Text = name .. ": " .. opt
					list.Visible = false
					open = false
					if callback then callback(opt) end
				end)
			end

			drop.MouseButton1Click:Connect(function()
				open = not open
				list.Visible = open
			end)
		end

		function tabObj:AddKeybind(name, default, callback)
			local keyButton = Instance.new("TextButton")
			keyButton.Size = UDim2.new(1, -10, 0, 30)
			keyButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			keyButton.TextColor3 = Color3.new(1, 1, 1)
			keyButton.Text = name .. ": " .. default.Name
			keyButton.Parent = tabFrame

			local waiting = false
			keyButton.MouseButton1Click:Connect(function()
				keyButton.Text = name .. ": ..."
				waiting = true
			end)

			game:GetService("UserInputService").InputBegan:Connect(function(input)
				if waiting then
					keyButton.Text = name .. ": " .. input.KeyCode.Name
					waiting = false
					if callback then callback(input.KeyCode) end
				end
			end)
		end

		table.insert(tabs, tabObj)
		return tabObj
	end

	return setmetatable({
		Main = mainFrame,
		AddTab = SunUI.AddTab
	}, SunUI)
end

return SunUI
