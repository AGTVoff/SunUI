-- src/logo.lua
local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/tonpseudo/MyFluentLib/main/src/theme.lua"))()

local Logo = {}

function Logo:AddTo(parent)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 30)
    Label.Text = "⚡ SunUI"
    Label.TextColor3 = Theme.Accent
    Label.BackgroundTransparency = 1
    Label.Font = Theme.Font
    Label.TextSize = 22
    Label.Parent = parent

    -- Glow RGB
    spawn(function()
        while task.wait() do
            for i = 0, 255 do
                Label.TextColor3 = Color3.fromHSV(i/255, 1, 1)
                task.wait(0.03)
            end
        end
    end)
end

return Logo
