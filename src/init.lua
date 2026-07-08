--==============================================================================
-- ScorpioX UI Library (init.lua)
-- Author: ScorpioX
--==============================================================================

return function(Window, Elements, Notifications)

	local Library = {}

	Library.__index = Library

	function Library:CreateWindow(config)

		config = config or {}

		-- MODIFICATO: Passa l'intera tabella config a Window.new per supportare le dimensioni custom
		local window = Window.new(config)

		local api = {}

		------------------------------------------------
		-- CREATE TAB
		------------------------------------------------

		function api:CreateTab(name)

			local tab = window:CreateTab(name)

			local TabAPI = {}

			function TabAPI:Section(text)
				return Elements.Section(tab, text)
			end

			function TabAPI:Paragraph(title, body)
				return Elements.Paragraph(tab, title, body)
			end

			function TabAPI:Label(text)
				return Elements.Label(tab, text)
			end

			function TabAPI:Separator()
				return Elements.Separator(tab)
			end

			function TabAPI:Button(text, callback)
				return Elements.Button(tab, text, callback)
			end

			function TabAPI:Toggle(title, default, callback)
				return Elements.Toggle(tab, title, default, callback)
			end

			function TabAPI:Slider(title, min, max, default, callback)
				return Elements.Slider(tab, title, min, max, default, callback)
			end

			function TabAPI:TextBox(title, placeholder, callback)
				return Elements.TextBox(tab, title, placeholder, callback)
			end

			function TabAPI:Dropdown(title, options, callback)
				return Elements.Dropdown(tab, title, options, callback)
			end

			function TabAPI:Keybind(title, key, callback)
				return Elements.Keybind(tab, title, key, callback)
			end

			return TabAPI

		end

		------------------------------------------------
		-- NOTIFY
		------------------------------------------------

		function api:Notify(title, message, duration)

			Notifications.Notify(
				window.Gui,
				title,
				message,
				duration
			)

		end

		------------------------------------------------
		-- DESTROY
		------------------------------------------------

		function api:Destroy()

			window:Destroy()

		end

		return api

	end

	return setmetatable({}, Library)

end
