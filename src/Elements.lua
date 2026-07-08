--==============================================================================
-- ScorpioX Modern Elements Engine (Premium Dark/Neon UI - Fix)
--==============================================================================

local Modules = getgenv().ScorpioXModules
local Theme = Modules.Theme -- Ripristinato come l'originale funzionante
local Utils = Modules.Utils

local Elements = {}

-- Funzione helper per creare i container degli elementi con stile coerente
local function CreateContainer(parent, height)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0.95, 0, 0, height)
	frame.BackgroundColor3 = Theme.Colors.Secondary
	frame.BorderSizePixel = 0
	frame.Parent = parent

	Utils.Corner(frame)
	Utils.Stroke(frame, Theme.Colors.Stroke)

	return frame
end

--------------------------------------------------------
-- SECTION
--------------------------------------------------------
function Elements.Section(parent, text)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(0.95, 0, 0, 30)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Font = Theme.BoldFont
	label.TextColor3 = Theme.Colors.Accent
	label.TextSize = 11
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = "╰┈➤ " .. string.upper(text)
	label.Parent = container

	return container
end

--------------------------------------------------------
-- PARAGRAPH
--------------------------------------------------------
function Elements.Paragraph(parent, title, body)
	local frame = CreateContainer(parent, 65)

	local Title = Instance.new("TextLabel")
	Title.Position = UDim2.new(0, 12, 0, 6)
	Title.Size = UDim2.new(1, -24, 0, 18)
	Title.BackgroundTransparency = 1
	Title.Font = Theme.BoldFont
	Title.TextColor3 = Theme.Colors.Text
	Title.TextSize = 13
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Text = title
	Title.Parent = frame

	local Body = Instance.new("TextLabel")
	Body.Position = UDim2.new(0, 12, 0, 24)
	Body.Size = UDim2.new(1, -24, 1, -30)
	Body.BackgroundTransparency = 1
	Body.Font = Theme.Font
	Body.TextWrapped = true
	Body.TextColor3 = Theme.Colors.TextDark
	Body.TextSize = 11
	Body.TextXAlignment = Enum.TextXAlignment.Left
	Body.TextYAlignment = Enum.TextYAlignment.Top
	Body.Text = body
	Body.Parent = frame

	return frame
end

--------------------------------------------------------
-- LABEL
--------------------------------------------------------
function Elements.Label(parent, text)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(0.95, 0, 0, 22)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.Position = UDim2.new(0, 4, 0, 0)
	label.BackgroundTransparency = 1
	label.Font = Theme.Font
	label.TextSize = 12
	label.TextColor3 = Theme.Colors.TextDark
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = text
	label.Parent = container

	return container
end

--------------------------------------------------------
-- SEPARATOR
--------------------------------------------------------
function Elements.Separator(parent)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(0.95, 0, 0, 10)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local line = Instance.new("Frame")
	line.Size = UDim2.new(1, 0, 0, 1)
	line.Position = UDim2.new(0, 0, 0.5, 0)
	line.BorderSizePixel = 0
	line.BackgroundColor3 = Theme.Colors.Stroke
	line.Parent = container

	return container
end

--------------------------------------------------------
-- BUTTON
--------------------------------------------------------
function Elements.Button(parent, text, callback)
	local frame = CreateContainer(parent, 36)
	
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 1, 0)
	button.BackgroundTransparency = 1
	button.Font = Theme.SemiBoldFont
	button.Text = text
	button.TextSize = 13
	button.TextColor3 = Theme.Colors.Text
	button.Parent = frame

	button.MouseEnter:Connect(function()
		Utils.Tween(frame, {BackgroundColor3 = Theme.Colors.Tertiary})
	end)

	button.MouseLeave:Connect(function()
		Utils.Tween(frame, {BackgroundColor3 = Theme.Colors.Secondary})
	end)

	button.MouseButton1Down:Connect(function()
		Utils.Tween(frame, {BackgroundColor3 = Theme.Colors.Accent})
		Utils.Tween(button, {TextColor3 = Color3.new(0,0,0)})
	end)

	button.MouseButton1Up:Connect(function()
		Utils.Tween(frame, {BackgroundColor3 = Theme.Colors.Tertiary})
		Utils.Tween(button, {TextColor3 = Theme.Colors.Text})
	end)

	button.Activated:Connect(function()
		if callback then task.spawn(callback) end
	end)

	return frame
end

--------------------------------------------------------
-- TOGGLE
--------------------------------------------------------
function Elements.Toggle(parent, title, default, callback)
	local frame = CreateContainer(parent, 44)

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0, 12, 0, 0)
	label.Size = UDim2.new(0.7, 0, 1, 0)
	label.Font = Theme.SemiBoldFont
	label.Text = title
	label.TextSize = 13
	label.TextColor3 = Theme.Colors.Text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local bg = Instance.new("Frame")
	bg.Size = UDim2.fromOffset(38, 20)
	bg.Position = UDim2.new(1, -50, 0.5, -10)
	bg.BackgroundColor3 = Theme.Colors.Stroke
	bg.BorderSizePixel = 0
	bg.Parent = frame

	Utils.Corner(bg)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.fromOffset(14, 14)
	knob.Position = UDim2.new(0, 3, 0.5, -7)
	knob.BackgroundColor3 = Color3.fromRGB(160, 160, 160)
	knob.BorderSizePixel = 0
	knob.Parent = bg

	Utils.Corner(knob)

	local state = default == true

	local function Update(animate)
		local targetBg = state and Theme.Colors.Accent or Theme.Colors.Stroke
		local targetKnobPos = state and UDim2.new(0, 21, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
		local targetKnobColor = state and Color3.new(0, 0, 0) or Color3.fromRGB(180, 180, 180)

		if animate then
			Utils.Tween(bg, {BackgroundColor3 = targetBg})
			Utils.Tween(knob, {Position = targetKnobPos, BackgroundColor3 = targetKnobColor})
		else
			bg.BackgroundColor3 = targetBg
			knob.Position = targetKnobPos
			knob.BackgroundColor3 = targetKnobColor
		end
	end

	Update(false)

	local click = Instance.new("TextButton")
	click.Size = UDim2.fromScale(1, 1)
	click.BackgroundTransparency = 1
	click.Text = ""
	click.Parent = frame

	click.Activated:Connect(function()
		state = not state
		Update(true)
		if callback then task.spawn(callback, state) end
	end)

	return frame
end

--------------------------------------------------------
-- SLIDER
--------------------------------------------------------
function Elements.Slider(parent, title, min, max, default, callback)
	local UIS = game:GetService("UserInputService")
	local frame = CreateContainer(parent, 52)

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0, 12, 0, 6)
	label.Size = UDim2.new(0.7, 0, 0, 18)
	label.Font = Theme.SemiBoldFont
	label.Text = title
	label.TextSize = 13
	label.TextColor3 = Theme.Colors.Text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local valueLabel = Instance.new("TextLabel")
	valueLabel.BackgroundTransparency = 1
	valueLabel.Position = UDim2.new(0.7, 0, 0, 6)
	valueLabel.Size = UDim2.new(0.3, -12, 0, 18)
	valueLabel.Font = Theme.BoldFont
	valueLabel.TextColor3 = Theme.Colors.Accent
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Text = tostring(default)
	valueLabel.Parent = frame

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1, -24, 0, 5)
	bar.Position = UDim2.new(0, 12, 0.7, 0)
	bar.BackgroundColor3 = Theme.Colors.Stroke
	bar.BorderSizePixel = 0
	bar.Parent = frame

	Utils.Corner(bar)

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(math.clamp((default - min) / (max - min), 0, 1), 0, 1, 0)
	fill.BackgroundColor3 = Theme.Colors.Accent
	fill.BorderSizePixel = 0
	fill.Parent = bar

	Utils.Corner(fill)

	local dragging = false

	local function SetValue(x)
		local percent = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
		fill.Size = UDim2.new(percent, 0, 1, 0)
		local value = math.floor(min + ((max - min) * percent))
		valueLabel.Text = tostring(value)

		if callback then task.spawn(callback, value) end
	end

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			SetValue(input.Position.X)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			SetValue(input.Position.X)
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	return frame
end

--------------------------------------------------------
-- TEXTBOX
--------------------------------------------------------
function Elements.TextBox(parent, title, placeholder, callback)
	local frame = CreateContainer(parent, 44)

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0, 12, 0, 0)
	label.Size = UDim2.new(0.4, 0, 1, 0)
	label.Font = Theme.SemiBoldFont
	label.Text = title
	label.TextSize = 13
	label.TextColor3 = Theme.Colors.Text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0.45, 0, 0, 26)
	box.Position = UDim2.new(1, -12, 0.5, -13)
	box.AnchorPoint = Vector2.new(1, 0)
	box.BackgroundColor3 = Theme.Colors.Tertiary
	box.TextColor3 = Theme.Colors.Text
	box.PlaceholderText = placeholder or "Scrivi..."
	box.PlaceholderColor3 = Theme.Colors.Placeholder
	box.Font = Theme.Font
	box.TextSize = 12
	box.ClearTextOnFocus = false
	box.Parent = frame

	Utils.Corner(box)
	Utils.Stroke(box, Theme.Colors.Stroke)

	box.FocusLost:Connect(function(enterPressed)
		if callback then task.spawn(callback, box.Text, enterPressed) end
	end)

	return frame
end

--------------------------------------------------------
-- DROPDOWN
--------------------------------------------------------
function Elements.Dropdown(parent, title, options, callback)
	local frame = CreateContainer(parent, 40)
	frame.ClipsDescendants = true

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 0, 40)
	button.BackgroundTransparency = 1
	button.Text = "  " .. title .. "  ▼"
	button.Font = Theme.SemiBoldFont
	button.TextSize = 13
	button.TextColor3 = Theme.Colors.Text
	button.TextXAlignment = Enum.TextXAlignment.Left
	button.Parent = frame

	local btnPad = Instance.new("UIPadding")
	btnPad.PaddingLeft = UDim.new(0, 12)
	btnPad.Parent = button

	local opened = false

	local list = Instance.new("ScrollingFrame")
	list.Visible = false
	list.Position = UDim2.new(0, 12, 0, 42)
	list.Size = UDim2.new(1, -24, 0, 0)
	list.CanvasSize = UDim2.new(0, 0, 0, #options * 28)
	list.ScrollBarThickness = 2
	list.ScrollBarImageColor3 = Theme.Colors.Accent
	list.BackgroundTransparency = 1
	list.BorderSizePixel = 0
	list.Parent = frame

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 2)
	layout.Parent = list

	for _, option in ipairs(options) do
		local opt = Instance.new("TextButton")
		opt.Size = UDim2.new(1, 0, 0, 26)
		opt.BackgroundColor3 = Theme.Colors.Tertiary
		opt.Font = Theme.Font
		opt.Text = tostring(option)
		opt.TextColor3 = Theme.Colors.TextDark
		opt.TextSize = 12
		opt.Parent = list

		Utils.Corner(opt)

		opt.MouseEnter:Connect(function()
			Utils.Tween(opt, {TextColor3 = Theme.Colors.Accent})
		end)
		opt.MouseLeave:Connect(function()
			Utils.Tween(opt, {TextColor3 = Theme.Colors.TextDark})
		end)

		opt.Activated:Connect(function()
			button.Text = "  " .. tostring(option) .. "  ▼"
			opened = false
			list.Visible = false
			Utils.Tween(frame, {Size = UDim2.new(0.95, 0, 0, 40)})
			if callback then task.spawn(callback, option) end
		end)
	end

	button.Activated:Connect(function()
		opened = not opened
		if opened then
			local height = math.min(#options * 28 + 5, 115)
			list.Visible = true
			list.Size = UDim2.new(1, -24, 0, height)
			Utils.Tween(frame, {Size = UDim2.new(0.95, 0, 0, height + 50)})
		else
			list.Visible = false
			Utils.Tween(frame, {Size = UDim2.new(0.95, 0, 0, 40)})
		end
	end)

	return frame
end

--------------------------------------------------------
-- KEYBIND
--------------------------------------------------------
function Elements.Keybind(parent, title, defaultKey, callback)
	local UIS = game:GetService("UserInputService")
	local frame = CreateContainer(parent, 40)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.6, 0, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Font = Theme.SemiBoldFont
	label.Text = title
	label.TextSize = 13
	label.TextColor3 = Theme.Colors.Text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local bind = Instance.new("TextButton")
	bind.Size = UDim2.fromOffset(75, 24)
	bind.Position = UDim2.new(1, -12, 0.5, -12)
	bind.AnchorPoint = Vector2.new(1, 0)
	bind.BackgroundColor3 = Theme.Colors.Tertiary
	bind.Font = Theme.BoldFont
	bind.TextColor3 = Theme.Colors.Accent
	bind.TextSize = 11
	bind.Text = defaultKey.Name
	bind.Parent = frame

	Utils.Corner(bind)
	Utils.Stroke(bind, Theme.Colors.Stroke)

	local current = defaultKey
	local waiting = false

	bind.Activated:Connect(function()
		waiting = true
		bind.Text = "..."
	end)

	UIS.InputBegan:Connect(function(input, gp)
		if gp then return end

		if waiting then
			if input.UserInputType == Enum.UserInputType.Keyboard then
				waiting = false
				current = input.KeyCode
				bind.Text = current.Name
			end
		-- FIX: Questo invia l'input aggiornato alla callback dell'utente quando viene premuto!
		elseif input.KeyCode == current then
			if callback then task.spawn(callback, current) end
		end
	end)

	return frame
end

return Elements
