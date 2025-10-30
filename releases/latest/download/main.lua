-- main.lua
local SunUI = {}

local base = "https://raw.githubusercontent.com/AGTVoff/SunUI/main/src/"

SunUI.Theme = loadstring(game:HttpGet(base .. "theme.lua"))()
SunUI.Utils = loadstring(game:HttpGet(base .. "utils.lua"))()
SunUI.Core = loadstring(game:HttpGet(base .. "core.lua"))()
SunUI.Components = loadstring(game:HttpGet(base .. "components.lua"))()
SunUI.Window = loadstring(game:HttpGet(base .. "window.lua"))(SunUI)

return SunUI
