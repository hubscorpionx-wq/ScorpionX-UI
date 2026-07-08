--==============================================================================
-- ScorpioX Loader
--==============================================================================

local BASE = "https://raw.githubusercontent.com/hubscorpionx-wq/ScorpionX-UI/main/src/"

local function Get(name)
    return loadstring(game:HttpGet(BASE .. name .. ".lua"))()
end

-- Moduli condivisi
local Modules = {}

Modules.Theme = Get("Theme")
Modules.Utils = Get("Utils")

getgenv().ScorpioXModules = Modules

-- Moduli principali
Modules.Window = Get("Window")
Modules.Elements = Get("Elements")
Modules.Notifications = Get("Notifications")

-- Libreria
local Library = Get("init")(Modules.Window, Modules.Elements, Modules.Notifications)

return Library
