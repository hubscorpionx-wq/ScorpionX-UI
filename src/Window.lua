--==============================================================================
-- ScorpioX Window Engine (Ripristinato)
--==============================================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local Modules = getgenv().ScorpioXModules
local Theme = Modules.Theme
local Utils = Modules.Utils

local Window = {}
Window.__index = Window

function Window.new(config)
	config = config or {}
	local title = config.Title or "SCORPIO X"
	local iconId = tostring(config.Icon or ""):match("%d+")
	
	local self = setmetatable({}, Window)
	self.ToggleKey = config.ToggleKey or Enum.KeyCode.RightControl

	local customSize = config.Size or UDim2.fromOffset(450, 300)
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	local old = playerGui:FindFirstChild("ScorpioXMenu") or CoreGui:FindFirstChild("ScorpioXMenu")
	if old then old:Destroy() end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "ScorpioXMenu"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.DisplayOrder = 999

	pcall(function() ScreenGui.Parent = CoreGui end)
	if not ScreenGui.Parent then ScreenGui.Parent = playerGui end
	self.Gui = ScreenGui

	----------------------------------------------------
	-- MAIN
	----------------------------------------------------
	local Main = Instance.new("Frame")
	Main.Name = "MainFrame"
	Main.Size = customSize
	Main.Position = UDim2.new(0.5, -Main.Size.X.Offset / 2, 0.5, -Main.Size.Y.Offset / 2)
	Main.BackgroundColor3 = Theme.Colors.Background
	Main.Parent = ScreenGui

	Utils.Corner(Main)
	Utils.Stroke(Main, Theme.Colors.Accent)
	self.Main = Main

	----------------------------------------------------
	-- TOPBAR
	----------------------------------------------------
	local TopBar = Instance.new("Frame")
	TopBar.Name = "TopBar"
	TopBar.Size = UDim2.new(1, 0, 0, 38)
	TopBar.BackgroundColor3 = Theme.Colors.Secondary
	TopBar.Parent = Main

	Utils.Corner(TopBar)
	self.TopBar = TopBar

	local titleOffset = 15
	if iconId then
		local TopBarIcon = Instance.new("ImageLabel")
		TopBarIcon.Name = "TopBarIcon"
		TopBarIcon.Size = UDim2.fromOffset(20, 20)
		TopBarIcon.Position = UDim2.new(0, 12, 0.5, -10)
		TopBarIcon.BackgroundTransparency = 1
		TopBarIcon.Image = "rbxassetid://" .. iconId
		TopBarIcon.Parent = TopBar
		titleOffset = 40
	end

	local Title = Instance.new("TextLabel")
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0, titleOffset, 0, 0)
	Title.Size = UDim2.new(1, -titleOffset - 15, 1, 0)
	Title.Font = Theme.BoldFont
	Title.TextColor3 = Theme.Colors.Text
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.TextSize = 15
	Title.Text = tostring(title):upper()
	Title.Parent = TopBar
	self.Title = Title

	----------------------------------------------------
	-- FLOAT BUTTON (Cerchio Perfetto)
	----------------------------------------------------
	local Toggle
	if iconId then
		Toggle = Instance.new("ImageButton")
		Toggle.Image = "rbxassetid://" .. iconId
	else
		Toggle = Instance.new("TextButton")
		Toggle.Text = "SCO"
		Toggle.Font = Theme.BoldFont
		Toggle.TextSize = 14
		Toggle.TextColor3 = Theme.Colors.Accent
	end

	Toggle.Name = "Toggle"
	Toggle.Size = UDim2.fromOffset(58, 58)
	Toggle.Position = UDim2.new(0, 20, .35, 0)
	Toggle.BackgroundColor3 = Theme.Colors.Background
	Toggle.Parent = ScreenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = Toggle

	Utils.Stroke(Toggle, Theme.Colors.Accent)
	self.Toggle = Toggle

	----------------------------------------------------
	-- DRAG
	----------------------------------------------------
	Utils.MakeDraggable(Main, TopBar)
	Utils.MakeDraggable(Toggle)

	----------------------------------------------------
	-- TOGGLE MENU
	----------------------------------------------------
	Toggle.Activated:Connect(function()
		Main.Visible = not Main.Visible
	end)

	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == self.ToggleKey then
			Main.Visible = not Main.Visible
		end
	end)

	----------------------------------------------------
	-- SIDEBAR
	----------------------------------------------------
	local SideBar = Instance.new("ScrollingFrame")
	SideBar.Name = "SideBar"
	SideBar.Size = UDim2.new(0, 130, 1, -50)
	SideBar.Position = UDim2.new(0, 10, 0, 45)
	SideBar.BackgroundTransparency = 1
	SideBar.BorderSizePixel = 0
	SideBar.ScrollBarThickness = 3
	SideBar.ScrollBarImageColor3 = Theme.Colors.Accent
	SideBar.CanvasSize = UDim2.new()
	SideBar.Parent = Main

	local SideLayout = Instance.new("UIListLayout")
	SideLayout.Padding = UDim.new(0, 5)
	SideLayout.Parent = SideBar

	SideLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		SideBar.CanvasSize = UDim2.new(0, 0, 0, SideLayout.AbsoluteContentSize.Y + 10)
	end)
	self.SideBar = SideBar

	----------------------------------------------------
	-- CONTENT
	----------------------------------------------------
	local Content = Instance.new("Frame")
	Content.Name = "Content"
	Content.Position = UDim2.new(0, 150, 0, 45)
	Content.Size = UDim2.new(1, -160, 1, -55)
	Content.BackgroundTransparency = 1
	Content.Parent = Main
	self.Content = Content

	self.Tabs = {}
	self.Buttons = {}
	self.ActiveTab = nil

	function self:SelectTab(name)
		for tabName, frame in pairs(self.Tabs) do
			frame.Visible = (tabName == name)
		end
		for btnName, button in pairs(self.Buttons) do
			if btnName == name then
				button.BackgroundColor3 = Theme.Colors.Accent
				button.TextColor3 = Color3.new()
			else
				button.BackgroundColor3 = Theme.Colors.Secondary
				button.TextColor3 = Theme.Colors.TextDark
			end
		end
		self.ActiveTab = name
	end

	function self:CreateTab(name)
		local tabFrame = Instance.new("ScrollingFrame")
		tabFrame.Name = name
		tabFrame.Size = UDim2.new(1, 0, 1, 0)
		tabFrame.CanvasSize = UDim2.new()
		tabFrame.BackgroundTransparency = 1
		tabFrame.BorderSizePixel = 0
		tabFrame.ScrollBarThickness = 3
		tabFrame.ScrollBarImageColor3 = Theme.Colors.Accent
		tabFrame.Visible = false
		tabFrame.Parent = self.Content

		local layout = Instance.new("UIListLayout")
		layout.Padding = UDim.new(0, 6)
		layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		layout.Parent = tabFrame

		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			tabFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
		end)

		local tabButton = Instance.new("TextButton")
		tabButton.Size = UDim2.new(1, -10, 0, 32)
		tabButton.BackgroundColor3 = Theme.Colors.Secondary
		tabButton.Text = "   " .. name
		tabButton.TextColor3 = Theme.Colors.TextDark
		tabButton.TextXAlignment = Enum.TextXAlignment.Left
		tabButton.Font = Theme.SemiBoldFont
		tabButton.TextSize = 13
		tabButton.Parent = self.SideBar

		Utils.Corner(tabButton)
		Utils.Stroke(tabButton, Theme.Colors.Stroke)

		tabButton.Activated:Connect(function()
			self:SelectTab(name)
		end)

		self.Tabs[name] = tabFrame
		self.Buttons[name] = tabButton

		local tabContainer = {}
		local Elements = Modules.Elements

		function tabContainer:Section(text) return Elements.Section(tabFrame, text) end
		function tabContainer:Paragraph(title, body) return Elements.Paragraph(tabFrame, title, body) end
		function tabContainer:Label(text) return Elements.Label(tabFrame, text) end
		function tabContainer:Separator() return Elements.Separator(tabFrame) end
		function tabContainer:Button(text, callback) return Elements.Button(tabFrame, text, callback) end
		function tabContainer:Toggle(title, default, callback) return Elements.Toggle(tabFrame, title, default, callback) end
		function tabContainer:Slider(title, min, max, default, callback) return Elements.Slider(tabFrame, title, min, max, default, callback) end
		function tabContainer:TextBox(title, placeholder, callback) return Elements.TextBox(tabFrame, title, placeholder, callback) end
		function tabContainer:Dropdown(title, options, callback) return Elements.Dropdown(tabFrame, title, options, callback) end
		function tabContainer:Keybind(title, defaultKey, callback) return Elements.Keybind(tabFrame, title, defaultKey, callback) end

		if not self.ActiveTab then
			self:SelectTab(name)
		end

		return tabContainer
	end

	return self
end

return Window
