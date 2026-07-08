local Window = require(script.Window)
local Elements = require(script.Elements)
local Notifications = require(script.Notifications)

local Library = {}

function Library:CreateWindow(title, iconId, toggleKey)
	local window = Window.new(title, iconId, toggleKey)

	local api = {}

	function api:CreateTab(name)
		return Elements.CreateTab(window, name)
	end

	function api:Notify(title, text, duration)
		Notifications.Notify(window.Gui, title, text, duration)
	end

	function api:Destroy()
		window:Destroy()
	end

	return api
end

return Library
