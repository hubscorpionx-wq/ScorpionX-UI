--==============================================================================
-- ScorpioX Loader
--==============================================================================

local BASE = "https://raw.githubusercontent.com/hubscorpionx-wq/ScorpionX-UI/main/src/"

local function Get(name)
	return loadstring(game:HttpGet(BASE .. name .. ".lua"))()
end

-- Core
local Theme = Get("Theme")
local Utils = Get("Utils")

-- Modules
local Window = Get("Window")(Theme, Utils)
local Elements = Get("Elements")(Theme, Utils)
local Notifications = Get("Notifications")(Theme, Utils)

-- Library
local Library = Get("init")(Window, Elements, Notifications)

return Library
