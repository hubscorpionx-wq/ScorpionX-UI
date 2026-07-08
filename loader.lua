--==============================================================================
-- ScorpioX Loader
--==============================================================================

local BASE = "https://raw.githubusercontent.com/hubscorpionx-wq/ScorpionX-UI/main/src/"

local function Get(name)
    return loadstring(game:HttpGet(BASE .. name .. ".lua"))()
end

-- Carica i moduli base
getgenv().ScorpioXModules = {}

getgenv().ScorpioXModules.Theme = Get("Theme")
getgenv().ScorpioXModules.Utils = Get("Utils")

-- Carica gli altri moduli
getgenv().ScorpioXModules.Window = Get("Window")
getgenv().ScorpioXModules.Elements = Get("Elements")
getgenv().ScorpioXModules.Notifications = Get("Notifications")

-- Restituisce la libreria
return Get("init")
