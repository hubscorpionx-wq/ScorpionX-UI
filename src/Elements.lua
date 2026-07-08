local Modules = getgenv().ScorpioXModules

local Theme = Modules.Theme
local Utils = Modules.Utils

local Elements = {}

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

	local label = Instance.new("TextLabel")

	label.Size = UDim2.new(0.95, 0, 0, 22)
	label.BackgroundTransparency = 1

	label.Font = Theme.BoldFont
	label.TextColor3 = Theme.Colors.Accent
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left

	label.Text = "── " .. string.upper(text) .. " ──"

	label.Parent = parent

	return label

end

--------------------------------------------------------
-- PARAGRAPH
--------------------------------------------------------

function Elements.Paragraph(parent, title, body)

	local frame = CreateContainer(parent, 60)

	local Title = Instance.new("TextLabel")
	Title.Position = UDim2.new(0, 10, 0, 5)
	Title.Size = UDim2.new(1, -20, 0, 18)
	Title.BackgroundTransparency = 1
	Title.Font = Theme.BoldFont
	Title.TextColor3 = Theme.Colors.Accent
	Title.TextSize = 13
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Text = title
	Title.Parent = frame

	local Body = Instance.new("TextLabel")
	Body.Position = UDim2.new(0, 10, 0, 24)
	Body.Size = UDim2.new(1, -20, 1, -28)
	Body.BackgroundTransparency = 1
	Body.Font = Theme.Font
	Body.TextWrapped = true
	Body.TextColor3 = Theme.Colors.TextDark
	Body.TextSize = 12
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

	local label = Instance.new("TextLabel")

	label.Size = UDim2.new(0.95,0,0,22)
	label.BackgroundTransparency = 1

	label.Font = Theme.Font
	label.TextSize = 12
	label.TextColor3 = Theme.Colors.TextDark
	label.TextXAlignment = Enum.TextXAlignment.Left

	label.Text = text

	label.Parent = parent

	return label

end

--------------------------------------------------------
-- SEPARATOR
--------------------------------------------------------

function Elements.Separator(parent)

	local line = Instance.new("Frame")

	line.Size = UDim2.new(0.95,0,0,1)
	line.BorderSizePixel = 0
	line.BackgroundColor3 = Theme.Colors.Stroke

	line.Parent = parent

	return line

end

--------------------------------------------------------
-- BUTTON
--------------------------------------------------------

function Elements.Button(parent, text, callback)

	local frame = CreateContainer(parent,35)

	local button = Instance.new("TextButton")

	button.Size = UDim2.new(1,0,1,0)
	button.BackgroundTransparency = 1

	button.Font = Theme.SemiBoldFont
	button.Text = text
	button.TextSize = 13
	button.TextColor3 = Theme.Colors.Text

	button.Parent = frame

	button.MouseButton1Down:Connect(function()

		Utils.Tween(frame,{
			BackgroundColor3 = Theme.Colors.Accent
		})

		Utils.Tween(button,{
			TextColor3 = Color3.new(0,0,0)
		})

	end)

	button.MouseButton1Up:Connect(function()

		Utils.Tween(frame,{
			BackgroundColor3 = Theme.Colors.Secondary
		})

		Utils.Tween(button,{
			TextColor3 = Theme.Colors.Text
		})

	end)

	button.Activated:Connect(function()

		if callback then
			task.spawn(callback)
		end

	end)

	return frame

end

--------------------------------------------------------
-- TOGGLE
--------------------------------------------------------

function Elements.Toggle(parent, title, default, callback)

	local frame = CreateContainer(parent, 45)

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0,10,0,0)
	label.Size = UDim2.new(0.7,0,1,0)
	label.Font = Theme.SemiBoldFont
	label.Text = title
	label.TextSize = 13
	label.TextColor3 = Theme.Colors.Text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local bg = Instance.new("Frame")
	bg.Size = UDim2.fromOffset(42,22)
	bg.Position = UDim2.new(1,-52,.5,-11)
	bg.BackgroundColor3 = Theme.Colors.Stroke
	bg.BorderSizePixel = 0
	bg.Parent = frame

	Utils.Corner(bg, UDim.new(1,0))

	local knob = Instance.new("Frame")
	knob.Size = UDim2.fromOffset(16,16)
	knob.Position = UDim2.new(0,3,0,3)
	knob.BackgroundColor3 = Color3.fromRGB(180,180,180)
	knob.BorderSizePixel = 0
	knob.Parent = bg

	Utils.Corner(knob, UDim.new(1,0))

	local state = default == true

	local function Update()

		if state then

			Utils.Tween(bg,{
				BackgroundColor3 = Theme.Colors.Accent
			})

			Utils.Tween(knob,{
				Position = UDim2.new(0,23,0,3),
				BackgroundColor3 = Color3.new(1,1,1)
			})

		else

			Utils.Tween(bg,{
				BackgroundColor3 = Theme.Colors.Stroke
			})

			Utils.Tween(knob,{
				Position = UDim2.new(0,3,0,3),
				BackgroundColor3 = Color3.fromRGB(180,180,180)
			})

		end

	end

	Update()

	local click = Instance.new("TextButton")
	click.Size = UDim2.fromScale(1,1)
	click.BackgroundTransparency = 1
	click.Text = ""
	click.Parent = frame

	click.Activated:Connect(function()

		state = not state

		Update()

		if callback then
			task.spawn(callback,state)
		end

	end)

	return frame

end

--------------------------------------------------------
-- SLIDER
--------------------------------------------------------

function Elements.Slider(parent,title,min,max,default,callback)

	local UIS = game:GetService("UserInputService")

	local frame = CreateContainer(parent,55)

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0,10,0,4)
	label.Size = UDim2.new(.7,0,0,18)
	label.Font = Theme.SemiBoldFont
	label.Text = title
	label.TextSize = 13
	label.TextColor3 = Theme.Colors.Text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local valueLabel = Instance.new("TextLabel")
	valueLabel.BackgroundTransparency = 1
	valueLabel.Position = UDim2.new(.7,0,0,4)
	valueLabel.Size = UDim2.new(.3,-10,0,18)
	valueLabel.Font = Theme.BoldFont
	valueLabel.TextColor3 = Theme.Colors.Accent
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Text = tostring(default)
	valueLabel.Parent = frame

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(.9,0,0,6)
	bar.Position = UDim2.new(.05,0,.7,0)
	bar.BackgroundColor3 = Theme.Colors.Stroke
	bar.BorderSizePixel = 0
	bar.Parent = frame

	Utils.Corner(bar, UDim.new(1,0))

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(math.clamp((default-min)/(max-min),0,1),0,1,0)
	fill.BackgroundColor3 = Theme.Colors.Accent
	fill.BorderSizePixel = 0
	fill.Parent = bar

	Utils.Corner(fill, UDim.new(1,0))

	local dragging = false

	local function SetValue(x)

		local percent = math.clamp(
			(x-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,
			0,
			1
		)

		fill.Size = UDim2.new(percent,0,1,0)

		local value = math.floor(min+((max-min)*percent))

		valueLabel.Text = tostring(value)

		if callback then
			task.spawn(callback,value)
		end

	end

	bar.InputBegan:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			SetValue(input.Position.X)

		end

	end)

	UIS.InputChanged:Connect(function(input)

		if dragging and (
			input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch
		) then

			SetValue(input.Position.X)

		end

	end)

	UIS.InputEnded:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

			dragging = false

		end

	end)

	return frame

end

--------------------------------------------------------
-- TEXTBOX
--------------------------------------------------------

function Elements.TextBox(parent,title,placeholder,callback)

	local frame = CreateContainer(parent,45)

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0,10,0,0)
	label.Size = UDim2.new(0.4,0,1,0)
	label.Font = Theme.SemiBoldFont
	label.Text = title
	label.TextSize = 13
	label.TextColor3 = Theme.Colors.Text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0.45,0,0,26)
	box.Position = UDim2.new(1,-170,0.5,-13)
	box.BackgroundColor3 = Theme.Colors.Tertiary
	box.TextColor3 = Theme.Colors.Text
	box.PlaceholderText = placeholder or ""
	box.PlaceholderColor3 = Theme.Colors.Placeholder
	box.Font = Theme.Font
	box.TextSize = 12
	box.ClearTextOnFocus = false
	box.Parent = frame

	Utils.Corner(box)

	box.FocusLost:Connect(function(enterPressed)

		if callback then
			task.spawn(callback, box.Text, enterPressed)
		end

	end)

	return frame

end

--------------------------------------------------------
-- DROPDOWN
--------------------------------------------------------

function Elements.Dropdown(parent,title,options,callback)

	local frame = CreateContainer(parent,40)
	frame.ClipsDescendants = true

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1,0,0,40)
	button.BackgroundTransparency = 1
	button.Text = "  "..title.." ▼"
	button.Font = Theme.SemiBoldFont
	button.TextSize = 13
	button.TextColor3 = Theme.Colors.Text
	button.TextXAlignment = Enum.TextXAlignment.Left
	button.Parent = frame

	local opened = false

	local list = Instance.new("ScrollingFrame")
	list.Visible = false
	list.Position = UDim2.new(0,0,0,42)
	list.Size = UDim2.new(1,0,0,0)
	list.CanvasSize = UDim2.new(0,0,0,#options*30)
	list.ScrollBarThickness = 3
	list.ScrollBarImageColor3 = Theme.Colors.Accent
	list.BackgroundColor3 = Theme.Colors.Secondary
	list.BorderSizePixel = 0
	list.Parent = frame

	Utils.Corner(list)
	Utils.Stroke(list,Theme.Colors.Stroke)

	local layout = Instance.new("UIListLayout")
	layout.Parent = list

	for _,option in ipairs(options) do

		local opt = Instance.new("TextButton")
		opt.Size = UDim2.new(1,0,0,30)
		opt.BackgroundTransparency = 1
		opt.Font = Theme.Font
		opt.Text = "   "..tostring(option)
		opt.TextColor3 = Theme.Colors.Text
		opt.TextSize = 12
		opt.TextXAlignment = Enum.TextXAlignment.Left
		opt.Parent = list

		opt.Activated:Connect(function()

			button.Text = "  "..tostring(option).." ▼"

			opened = false

			list.Visible = false
			list.Size = UDim2.new(1,0,0,0)

			frame.Size = UDim2.new(.95,0,0,40)

			if callback then
				task.spawn(callback, option)
			end

		end)

	end

	button.Activated:Connect(function()

		opened = not opened

		if opened then

			local height = math.min(#options*30,120)

			list.Visible = true
			list.Size = UDim2.new(1,0,0,height)

			frame.Size = UDim2.new(.95,0,0,height+45)

		else

			list.Visible = false
			list.Size = UDim2.new(1,0,0,0)

			frame.Size = UDim2.new(.95,0,0,40)

		end

	end)

	return frame

end

--------------------------------------------------------
-- KEYBIND
--------------------------------------------------------

function Elements.Keybind(parent,title,defaultKey,callback)

	local UIS = game:GetService("UserInputService")

	local frame = CreateContainer(parent,40)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(.6,0,1,0)
	label.Position = UDim2.new(0,10,0,0)
	label.BackgroundTransparency = 1
	label.Font = Theme.SemiBoldFont
	label.Text = title
	label.TextSize = 13
	label.TextColor3 = Theme.Colors.Text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local bind = Instance.new("TextButton")
	bind.Size = UDim2.new(0,80,0,24)
	bind.Position = UDim2.new(1,-90,.5,-12)
	bind.BackgroundColor3 = Theme.Colors.Tertiary
	bind.Font = Theme.BoldFont
	bind.TextColor3 = Theme.Colors.Accent
	bind.TextSize = 12
	bind.Text = defaultKey.Name
	bind.Parent = frame

	Utils.Corner(bind)

	local current = defaultKey
	local waiting = false

	bind.Activated:Connect(function()

		waiting = true
		bind.Text = "..."

	end)

	UIS.InputBegan:Connect(function(input,gp)

		if gp then
			return
		end

		if waiting then

			if input.UserInputType == Enum.UserInputType.Keyboard then

				waiting = false
				current = input.KeyCode

				bind.Text = current.Name

			end

		elseif input.KeyCode == current then

			if callback then
				task.spawn(callback,current)
			end

		end

	end)

	return frame

end

--------------------------------------------------------
-- RETURN
--------------------------------------------------------


return Elements
