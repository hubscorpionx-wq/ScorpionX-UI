--==============================================================================
-- ScorpioX Utils
--==============================================================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Utils = {}

-- Tween
function Utils.Tween(object, properties, info)
	info = info or TweenInfo.new(
		0.25,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.Out
	)

	local tween = TweenService:Create(object, info, properties)
	tween:Play()

	return tween
end

-- Arrotonda GUI
function Utils.Corner(gui, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = radius or UDim.new(0,6)
	corner.Parent = gui
	return corner
end

-- Bordo GUI
function Utils.Stroke(gui, color, thickness)

	local stroke = Instance.new("UIStroke")

	stroke.Color = color
	stroke.Thickness = thickness or 1
	stroke.Parent = gui

	return stroke

end

-- Drag moderno (PC + Mobile)
function Utils.MakeDraggable(guiObject, dragHandle)

	dragHandle = dragHandle or guiObject

	local dragging = false
	local dragStart
	local startPos

	local function update(input)

		local delta = input.Position - dragStart

		guiObject.Position = UDim2.new(

			startPos.X.Scale,
			startPos.X.Offset + delta.X,

			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y

		)

	end

	dragHandle.InputBegan:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			dragStart = input.Position
			startPos = guiObject.Position

			input.Changed:Connect(function()

				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end

			end)

		end

	end)

	UserInputService.InputChanged:Connect(function(input)

		if dragging then

			if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then

				update(input)

			end

		end

	end)

end

-- Crea Label
function Utils.CreateLabel(parent,text,size,color,font)

	local lbl = Instance.new("TextLabel")

	lbl.BackgroundTransparency = 1
	lbl.Text = text or ""
	lbl.TextColor3 = color or Color3.new(1,1,1)
	lbl.Font = font or Enum.Font.SourceSans
	lbl.TextSize = size or 14
	lbl.Parent = parent

	return lbl

end

-- Clamp
function Utils.Clamp(v,min,max)

	return math.clamp(v,min,max)

end

return Utils
