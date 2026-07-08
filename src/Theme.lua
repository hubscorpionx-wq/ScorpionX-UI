--==============================================================================
-- ScorpioX Theme
--==============================================================================

local Theme = {}

----------------------------------------------------
-- COLORS
----------------------------------------------------

Theme.Colors = {

	Background = Color3.fromRGB(15,15,15),
	Secondary = Color3.fromRGB(22,22,22),
	Tertiary = Color3.fromRGB(30,30,30),

	Accent = Color3.fromRGB(150,255,0),
	AccentDark = Color3.fromRGB(110,210,0),

	Text = Color3.fromRGB(255,255,255),
	TextDark = Color3.fromRGB(180,180,180),
	Placeholder = Color3.fromRGB(120,120,120),

	Stroke = Color3.fromRGB(45,45,45),
	Hover = Color3.fromRGB(35,35,35),
	Disabled = Color3.fromRGB(80,80,80),

	Success = Color3.fromRGB(0,200,0),
	Warning = Color3.fromRGB(255,180,0),
	Error = Color3.fromRGB(220,70,70)

}

----------------------------------------------------
-- CORNERS
----------------------------------------------------

Theme.WindowCorner = UDim.new(0,10)
Theme.ElementCorner = UDim.new(0,6)
Theme.CircleCorner = UDim.new(1,0)

----------------------------------------------------
-- STROKES
----------------------------------------------------

Theme.StrokeThickness = 1
Theme.WindowStrokeThickness = 1.5

----------------------------------------------------
-- FONTS
----------------------------------------------------

Theme.Font = Enum.Font.SourceSans
Theme.BoldFont = Enum.Font.SourceSansBold
Theme.SemiBoldFont = Enum.Font.SourceSansSemibold

----------------------------------------------------
-- TEXT SIZES
----------------------------------------------------

Theme.TitleSize = 15
Theme.TextSize = 13
Theme.SmallText = 11

----------------------------------------------------
-- ELEMENT SIZES
----------------------------------------------------

Theme.ButtonHeight = 35
Theme.ToggleHeight = 45
Theme.SliderHeight = 55
Theme.TextBoxHeight = 45
Theme.DropdownHeight = 40
Theme.KeybindHeight = 40
Theme.ParagraphHeight = 60

Theme.ElementPadding = 6

----------------------------------------------------
-- WINDOW
----------------------------------------------------

Theme.WindowSize = UDim2.fromOffset(450, 300)
----------------------------------------------------
-- ANIMATIONS
----------------------------------------------------

Theme.AnimationSpeed = TweenInfo.new(
	0.25,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.Out
)

Theme.FastTween = TweenInfo.new(
	0.12,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.Out
)

Theme.SlowTween = TweenInfo.new(
	0.35,
	Enum.EasingStyle.Quint,
	Enum.EasingDirection.Out
)

return Theme
