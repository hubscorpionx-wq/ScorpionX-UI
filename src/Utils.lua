local TweenService = game:GetService("TweenService")

local Utils = {}

function Utils:CreateCorner(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or UDim.new(0, 8)
    corner.Parent = object
    return corner
end

function Utils:CreateStroke(object, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.Parent = object
    return stroke
end

function Utils:Tween(object, properties, time, style, direction)
    local info = TweenInfo.new(
        time or 0.2,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    )

    local tween = TweenService:Create(object, info, properties)
    tween:Play()

    return tween
end

return Utils
