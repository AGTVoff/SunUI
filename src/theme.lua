-- src/theme.lua
local Theme = {
    Background = Color3.fromRGB(15, 15, 15),
    Accent = Color3.fromRGB(0, 255, 120),
    Text = Color3.fromRGB(255, 255, 255),
    CornerRadius = UDim.new(0, 10),
    BorderThickness = 2
}

function Theme:GetRGBColor(t)
    local hue = (tick() * 100 + t) % 255 / 255
    return Color3.fromHSV(hue, 1, 1)
end

return Theme
