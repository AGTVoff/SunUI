-- src/animation.lua
local TweenService = game:GetService("TweenService")

local Animation = {}

function Animation:Tween(obj, props, duration)
    TweenService:Create(obj, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

return Animation
