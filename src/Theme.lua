--==============================================================================
-- ScorpioX Theme
--==============================================================================

local Theme = {}

Theme.Colors = {

	Background = Color3.fromRGB(15,15,15),

	Secondary = Color3.fromRGB(22,22,22),

	Tertiary = Color3.fromRGB(30,30,30),

	Accent = Color3.fromRGB(150,255,0),

	Text = Color3.fromRGB(255,255,255),

	TextDark = Color3.fromRGB(180,180,180),

	Placeholder = Color3.fromRGB(120,120,120),

	Stroke = Color3.fromRGB(45,45,45),

	Success = Color3.fromRGB(0,200,0),

	Error = Color3.fromRGB(220,70,70),

	Warning = Color3.fromRGB(255,180,0)

}

Theme.CornerRadius = UDim.new(0,6)

Theme.WindowCorner = UDim.new(0,10)

Theme.Font = Enum.Font.SourceSans

Theme.BoldFont = Enum.Font.SourceSansBold

Theme.SemiBoldFont = Enum.Font.SourceSansSemibold

Theme.TitleSize = 14

Theme.TextSize = 13

Theme.SmallText = 11

Theme.AnimationSpeed = TweenInfo.new(
	0.25,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.Out
)

return Theme
