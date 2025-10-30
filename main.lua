-- main.lua
local Library = {}
local HttpService = game:GetService("HttpService")

-- Charger les modules internes
local function loadModule(path)
    return loadstring(game:HttpGet("https://github.com/AGTVoff/SunUI/tree/main/src"))()
end

Library.Core = loadModule("core")
Library.Theme = loadModule("theme")
Library.Components = loadModule("components")
Library.Animation = loadModule("animation")
Library.Logo = loadModule("logo")

function Library:CreateWindow(options)
    return self.Core:CreateWindow(options)
end

return Library

