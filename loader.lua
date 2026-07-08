-- ScorpioX Loader

local BASE_URL = "https://raw.githubusercontent.com/hubscorpionx-wq/ScorpionX-UI/main/src/"

local function LoadModule(name)
    return loadstring(game:HttpGet(BASE_URL .. name .. ".lua"))()
end

local Theme = LoadModule("Theme")
local Utils = LoadModule("Utils")
local Window = LoadModule("Window")(Theme, Utils)
local Notifications = LoadModule("Notifications")(Theme, Utils)
local Elements = LoadModule("Elements")(Theme, Utils)

return LoadModule("init")(Window, Elements, Notifications)
