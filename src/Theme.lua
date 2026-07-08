local Theme = {}

Theme.Default = {
    Background = Color3.fromRGB(15, 15, 15),
    Secondary = Color3.fromRGB(22, 22, 22),
    Surface = Color3.fromRGB(30, 30, 30),

    Accent = Color3.fromRGB(150, 255, 0),

    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(180, 180, 180),

    Border = Color3.fromRGB(45, 45, 45),

    Success = Color3.fromRGB(0, 255, 100),
    Warning = Color3.fromRGB(255, 180, 0),
    Error = Color3.fromRGB(255, 70, 70),

    CornerRadius = UDim.new(0,8),

    Font = Enum.Font.SourceSansSemibold,
    TitleFont = Enum.Font.SourceSansBold
}

return Theme
