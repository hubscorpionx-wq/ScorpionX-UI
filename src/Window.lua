--==============================================================================
-- ScorpioX Window Engine (Completo - Layout Corretto)
--==============================================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local Modules = getgenv().ScorpioXModules
local Theme = Modules.Theme or require(Modules.Theme)
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

	local old =
		playerGui:FindFirstChild("ScorpioXMenu")
		or CoreGui:FindFirstChild("ScorpioXMenu")

	if old then
		old:Destroy()
	end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "ScorpioXMenu"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.DisplayOrder = 999

	pcall(function()
		ScreenGui.Parent = CoreGui
	end)

	if not ScreenGui.Parent then
		ScreenGui.Parent = playerGui
	end

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

	Utils.Corner(Main,Theme.WindowCorner)
	Utils.Stroke(Main,Theme.Colors.Accent,1.5)

	self.Main = Main

	----------------------------------------------------
	-- TOPBAR
	----------------------------------------------------

	local TopBar = Instance.new("Frame")

	TopBar.Name = "TopBar"
	TopBar.Size = UDim2.new(1,0,0,38)
	TopBar.BackgroundColor3 = Theme.Colors.Secondary
	TopBar.Parent = Main

	Utils.Corner(TopBar,Theme.WindowCorner)

	self.TopBar = TopBar

	-- CONTENITORE PRINCIPALE DELLA TOPBAR CON LAYOUT ORIZZONTALE CORRETTO
	local TopBarContainer = Instance.new("Frame")
	TopBarContainer.Name = "TopBarContainer"
	TopBarContainer.BackgroundTransparency = 1
	TopBarContainer.Position = UDim2.new(0, 12, 0, 0)
	TopBarContainer.Size = UDim2.new(1, -24, 1, 0)
	TopBarContainer.Parent = TopBar

	local TopBarLayout = Instance.new("UIListLayout")
	TopBarLayout.FillDirection = Enum.FillDirection.Horizontal
	TopBarLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	TopBarLayout.SortOrder = Enum.SortOrder.LayoutOrder -- Forza l'uso del LayoutOrder numerico
	TopBarLayout.Padding = UDim.new(0, 8)
	TopBarLayout.Parent = TopBarContainer

	-- 1. ICONA (LayoutOrder = 1)
	if iconId then
		local TopBarIcon = Instance.new("ImageLabel")
		TopBarIcon.Name = "TopBarIcon"
		TopBarIcon.Size = UDim2.fromOffset(24, 24)
		TopBarIcon.BackgroundTransparency = 1
		TopBarIcon.Image = "rbxassetid://" .. iconId
		TopBarIcon.LayoutOrder = 1
		TopBarIcon.Parent = TopBarContainer
	end

	-- 2. TITOLO PRINCIPALE (LayoutOrder = 2)
	local Title = Instance.new("TextLabel")
	Title.Name = "TitleLabel"
	Title.BackgroundTransparency = 1
	Title.AutomaticSize = Enum.AutomaticSize.X
	Title.Size = UDim2.new(0, 0, 1, 0)
	Title.Font = Theme.BoldFont
	Title.TextColor3 = Theme.Colors.Text
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.TextSize = 15
	Title.Text = tostring(title):upper()
	Title.LayoutOrder = 2
	Title.Parent = TopBarContainer

	self.Title = Title

	-- CONTROLLO SE IL SOTTOTITOLO ESISTE NELLA CONFIGURAZIONE
	if config.Subtitle and config.Subtitle ~= "" then
		-- 3. IL PUNTO SEPARATORE (LayoutOrder = 3)
		local DotSeparator = Instance.new("TextLabel")
		DotSeparator.Name = "DotSeparator"
		DotSeparator.BackgroundTransparency = 1
		DotSeparator.AutomaticSize = Enum.AutomaticSize.X
		DotSeparator.Size = UDim2.new(0, 0, 1, 0)
		DotSeparator.Font = Enum.Font.SourceSansBold
		DotSeparator.TextColor3 = Color3.fromRGB(120, 120, 120)
		DotSeparator.TextSize = 14
		DotSeparator.Text = "•"
		DotSeparator.LayoutOrder = 3
		DotSeparator.Parent = TopBarContainer

		-- 4. SOTTOTITOLO (LayoutOrder = 4)
		local Subtitle = Instance.new("TextLabel")
		Subtitle.Name = "SubtitleLabel"
		Subtitle.BackgroundTransparency = 1
		Subtitle.AutomaticSize = Enum.AutomaticSize.X
		Subtitle.Size = UDim2.new(0, 0, 1, 0)
		Subtitle.Font = Theme.SemiBoldFont or Enum.Font.SourceSans
		Subtitle.TextColor3 = Color3.fromRGB(160, 160, 160)
		Subtitle.TextXAlignment = Enum.TextXAlignment.Left
		Subtitle.TextSize = 12
		Subtitle.Text = tostring(config.Subtitle)
		Subtitle.LayoutOrder = 4
		Subtitle.Parent = TopBarContainer
		
		self.Subtitle = Subtitle
	end

	----------------------------------------------------
	-- FLOAT BUTTON (PULSANTE DI ATTIVAZIONE)
	----------------------------------------------------

	local Toggle

	if iconId then
		Toggle = Instance.new("ImageButton")
		Toggle.Image = "rbxassetid://" .. iconId
		
		local Padding = Instance.new("UIPadding")
		Padding.PaddingTop = UDim.new(0, 10)
		Padding.PaddingBottom = UDim.new(0, 10)
		Padding.PaddingLeft = UDim.new(0, 10)
		Padding.PaddingRight = UDim.new(0, 10)
		Padding.Parent = Toggle
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

	Utils.Corner(Toggle, UDim.new(1, 0))
	Utils.Stroke(Toggle, Theme.Colors.Accent, 1.5)

	self.Toggle = Toggle

	----------------------------------------------------
	-- DRAG
	----------------------------------------------------

	Utils.MakeDraggable(Main,TopBar)
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
	SideBar.Size = UDim2.new(0,130,1,-50)
	SideBar.Position = UDim2.new(0,10,0,45)

	SideBar.BackgroundTransparency = 1
	SideBar.BorderSizePixel = 0
	SideBar.ScrollBarThickness = 3
	SideBar.ScrollBarImageColor3 = Theme.Colors.Accent
	SideBar.CanvasSize = UDim2.new()

	SideBar.Parent = Main

	local SideLayout = Instance.new("UIListLayout")
	SideLayout.Padding = UDim.new(0,5)
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
	Content.Position = UDim2.new(0,150,0,45)
	Content.Size = UDim2.new(1,-160,1,-55)
	Content.BackgroundTransparency = 1
	Content.Parent = Main

	self.Content = Content

	----------------------------------------------------
	-- TABLES
	----------------------------------------------------

	self.Tabs = {}
	self.Buttons = {}
	self.ActiveTab = nil
	self.ActiveDropdown = nil
	self.ActiveDropdownContainer = nil

	----------------------------------------------------
	-- FUNCTIONS
	----------------------------------------------------

	function self:HideDropdown()
		if self.ActiveDropdown then
			self.ActiveDropdown.Visible = false
			self.ActiveDropdown.Size = UDim2.new(1, 0, 0, 0)
			if self.ActiveDropdownContainer then
				self.ActiveDropdownContainer.Size = UDim2.new(0.95, 0, 0, 35)
			end
			self.ActiveDropdown = nil
			self.ActiveDropdownContainer = nil
		end
	end

	function self:SelectTab(name)
		self:HideDropdown()
		for tabName,frame in pairs(self.Tabs) do
			frame.Visible = (tabName == name)
		end
		for btnName,button in pairs(self.Buttons) do
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

	----------------------------------------------------
	-- CREATE TAB
	----------------------------------------------------

	function self:CreateTab(name)
		local tabFrame = Instance.new("ScrollingFrame")
		tabFrame.Name = name
		tabFrame.Size = UDim2.new(1,0,1,0)
		tabFrame.CanvasSize = UDim2.new()
		tabFrame.BackgroundTransparency = 1
		tabFrame.BorderSizePixel = 0
		tabFrame.ScrollBarThickness = 3
		tabFrame.ScrollBarImageColor3 = Theme.Colors.Accent
		tabFrame.Visible = false
		tabFrame.Parent = self.Content

		local layout = Instance.new("UIListLayout")
		layout.Padding = UDim.new(0,6)
		layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		layout.Parent = tabFrame

		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			tabFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
		end)

		local tabButton = Instance.new("TextButton")
		tabButton.Size = UDim2.new(1,-10,0,32)
		tabButton.BackgroundColor3 = Theme.Colors.Secondary
		tabButton.Text = "   "..name
		tabButton.TextColor3 = Theme.Colors.TextDark
		tabButton.TextXAlignment = Enum.TextXAlignment.Left
		tabButton.Font = Theme.SemiBoldFont
		tabButton.TextSize = 13
		tabButton.Parent = self.SideBar

		Utils.Corner(tabButton)
		Utils.Stroke(tabButton,Theme.Colors.Stroke)

		tabButton.Activated:Connect(function()
			self:SelectTab(name)
		end)

		self.Tabs[name] = tabFrame
		self.Buttons[name] = tabButton

		if not self.ActiveTab then
			self:SelectTab(name)
		end

		return tabFrame
	end

	----------------------------------------------------
	-- DESTROY
	----------------------------------------------------

	function self:Destroy()
		if self.Gui then
			self.Gui:Destroy()
		end
	end

	return self
end

return Window
