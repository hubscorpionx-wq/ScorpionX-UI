--==============================================================================
-- ScorpioX Modern Elements Engine (Fix Dropdown Dinamico)
--==============================================================================

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

function Elements.CreateWindow(title)
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "ScorpioX_UI"
	
	local success, err = pcall(function()
		ScreenGui.Parent = game:GetService("CoreGui")
	end)
	if not success then
		ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	end

	local MainFrame = Instance.new("Frame")
	MainFrame.Size = UDim2.new(0, 450, 0, 350)
	MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
	MainFrame.BackgroundColor3 = Theme.Colors.Background
	MainFrame.BorderSizePixel = 0
	MainFrame.Parent = ScreenGui

	Utils.Corner(MainFrame)
	Utils.Stroke(MainFrame, Theme.Colors.Stroke)

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Size = UDim2.new(1, -20, 0, 35)
	TitleLabel.Position = UDim2.new(0, 15, 0, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Font = Theme.BoldFont
	TitleLabel.TextColor3 = Theme.Colors.Text
	TitleLabel.TextSize = 14
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Text = title or "ScorpioX Hub"
	TitleLabel.Parent = MainFrame

	local Container = Instance.new("ScrollingFrame")
	Container.Size = UDim2.new(1, -20, 1, -50)
	Container.Position = UDim2.new(0, 10, 0, 40)
	Container.BackgroundTransparency = 1
	Container.BorderSizePixel = 0
	Container.ScrollBarThickness = 3
	Container.ScrollBarImageColor3 = Theme.Colors.Accent
	Container.Parent = MainFrame

	local Layout = Instance.new("UIListLayout")
	Layout.Padding = UDim.new(0, 6)
	Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	Layout.Parent = Container

	Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		Container.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
	end)

	return Container
end

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
	label.Text = "➤ " .. string.upper(text)
	label.Parent = container

	return container
end

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

	local ToggleObject = {}
	function ToggleObject:Set(v)
		if state ~= v then
			state = v
			Update(true)
			if callback then task.spawn(callback, state) end
		end
	end

	return ToggleObject
end

--------------------------------------------------------------------------
-- DROPDOWN TOTALMENTE RIVISTO ED AGGIORNATO IN TEMPO REALE
--------------------------------------------------------------------------
function Elements.Dropdown(parent, title, options, isMultiSelect, callback)
	local frame = CreateContainer(parent, 40)
	frame.ClipsDescendants = true

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 0, 40)
	button.BackgroundTransparency = 1
	button.Text = "  " .. title .. " ▼"
	button.Font = Theme.SemiBoldFont
	button.TextSize = 13
	button.TextColor3 = Theme.Colors.Text
	button.TextXAlignment = Enum.TextXAlignment.Left
	button.RichText = true
	button.Parent = frame

	local btnPad = Instance.new("UIPadding")
	btnPad.PaddingLeft = UDim.new(0, 12)
	btnPad.Parent = button

	local opened = false
	local currentOptions = options or {}
	local selections = {} 

	local list = Instance.new("ScrollingFrame")
	list.Visible = false
	list.Position = UDim2.new(0, 12, 0, 42)
	list.Size = UDim2.new(1, -24, 0, 0)
	list.ScrollBarThickness = 2
	list.ScrollBarImageColor3 = Theme.Colors.Accent
	list.BackgroundTransparency = 1
	list.BorderSizePixel = 0
	list.Parent = frame

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 2)
	layout.Parent = list

	local function formatWithGreenNumber(text)
		local str = tostring(text)
		local num = str:match("(%d+)")
		if num then
			local greenColor = "rgb(0, 255, 127)"
			return str:gsub(num, "<font color=\"" .. greenColor .. "\">" .. num .. "</font>")
		end
		return str
	end

	local function getActiveSelectionsTable()
		local active = {}
		if isMultiSelect then
			for _, optName in ipairs(currentOptions) do
				if selections[tostring(optName)] then
					table.insert(active, tostring(optName))
				end
			end
		else
			for _, optName in ipairs(currentOptions) do
				if selections[tostring(optName)] then
					return {tostring(optName)}
				end
			end
		end
		return active
	end

	local function updateButtonText()
		local active = getActiveSelectionsTable()
		local arrow = opened and "  ▲" or "  ▼"
		
		if #active == 0 then
			button.Text = "  " .. title .. (isMultiSelect and " (0)" or "") .. arrow
		elseif #active == 1 then
			button.Text = "  " .. formatWithGreenNumber(active[1]) .. arrow
		else
			button.Text = "  " .. tostring(#active) .. " Selezionati" .. arrow
		end
	end

	local function refreshAllOptionsVisual()
		for _, child in ipairs(list:GetChildren()) do
			if child:IsA("TextButton") then
				local optName = child:GetAttribute("OptionValue")
				if optName then
					local isSelected = selections[optName] == true
					local baseText = formatWithGreenNumber(optName)
					if isSelected then
						child.Text = "✓ " .. baseText
						child.TextColor3 = Theme.Colors.Accent
					else
						child.Text = "  " .. baseText
						child.TextColor3 = Theme.Colors.TextDark
					end
				end
			end
		end
	end

	local function createOptionButton(optionText)
		local optName = tostring(optionText)
		local opt = Instance.new("TextButton")
		opt.Size = UDim2.new(1, 0, 0, 26)
		opt.BackgroundColor3 = Theme.Colors.Tertiary
		opt.Font = Theme.Font
		opt.TextSize = 12
		opt.RichText = true
		opt:SetAttribute("OptionValue", optName)
		opt.Parent = list

		Utils.Corner(opt)

		opt.Activated:Connect(function()
			local currentVal = opt:GetAttribute("OptionValue")
			if not currentVal then return end
			
			if isMultiSelect then
				selections[currentVal] = not selections[currentVal]
			else
				table.clear(selections)
				selections[currentVal] = true
				opened = false
				list.Visible = false
				Utils.Tween(frame, {Size = UDim2.new(0.95, 0, 0, 40)})
			end
			
			refreshAllOptionsVisual()
			updateButtonText()
			
			if callback then 
				callback(getActiveSelectionsTable()) 
			end
		end)

		return opt
	end

	local function updateList(newOptions)
		currentOptions = newOptions or {}
		
		local tempSelections = {}
		for _, optName in ipairs(currentOptions) do
			local nameStr = tostring(optName)
			if selections[nameStr] then 
				tempSelections[nameStr] = true 
			end
		end
		selections = tempSelections

		for _, child in ipairs(list:GetChildren()) do
			if child:IsA("TextButton") then child:Destroy() end
		end

		for _, newOpt in ipairs(currentOptions) do
			createOptionButton(newOpt)
		end

		updateButtonText()
		refreshAllOptionsVisual()

		list.CanvasSize = UDim2.new(0, 0, 0, #currentOptions * 28)
		if opened then
			local height = math.min(#currentOptions * 28 + 5, 115)
			list.Size = UDim2.new(1, -24, 0, height)
			Utils.Tween(frame, {Size = UDim2.new(0.95, 0, 0, height + 50)})
		end
	end

	button.Activated:Connect(function()
		opened = not opened
		updateButtonText()
		
		if opened then
			local height = math.min(#currentOptions * 28 + 5, 115)
			list.Visible = true
			list.Size = UDim2.new(1, -24, 0, height)
			Utils.Tween(frame, {Size = UDim2.new(0.95, 0, 0, height + 50)})
		else
			list.Visible = false
			Utils.Tween(frame, {Size = UDim2.new(0.95, 0, 0, 40)})
		end
		refreshAllOptionsVisual()
	end)

	local DropdownObject = {}
	
	function DropdownObject:Set(tableOfValues)
		table.clear(selections)
		if type(tableOfValues) == "table" then
			for _, val in ipairs(tableOfValues) do 
				selections[tostring(val)] = true 
			end
		else
			selections[tostring(tableOfValues)] = true
		end
		
		updateButtonText()
		refreshAllOptionsVisual()
	end

	updateList(options)

	return DropdownObject
end

return Elements
