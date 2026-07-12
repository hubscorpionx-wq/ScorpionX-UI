--==============================================================================
-- ScorpioX Utils (Ottimizzato)
--==============================================================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Utils = {}

----------------------------------------------------
-- TWEEN
----------------------------------------------------
function Utils.Tween(object, properties, info)
	local tween = TweenService:Create(
		object,
		info or TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		properties
	)
	tween:Play()
	return tween
end

----------------------------------------------------
-- CORNER
----------------------------------------------------
function Utils.Corner(instance, radius)
	local old = instance:FindFirstChildOfClass("UICorner")
	if old then
		old:Destroy()
	end

	local corner = Instance.new("UICorner")
	corner.CornerRadius = radius or UDim.new(0, 6)
	corner.Parent = instance

	return corner
end

----------------------------------------------------
-- STROKE
----------------------------------------------------
function Utils.Stroke(instance, color, thickness)
	local old = instance:FindFirstChildOfClass("UIStroke")
	if old then
		old:Destroy()
	end

	local stroke = Instance.new("UIStroke")
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Color = color or Color3.fromRGB(255, 255, 255)
	stroke.Thickness = thickness or 1
	stroke.Parent = instance

	return stroke
end

----------------------------------------------------
-- DRAG (PC + MOBILE) - Fixato Memory Leak
----------------------------------------------------
function Utils.MakeDraggable(object, handle)
	handle = handle or object

	local dragging = false
	local dragStart
	local startPos

	local function Update(input)
		local delta = input.Position - dragStart
		object.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = object.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			Update(input)
		end
	end)

	-- Risolto: Rileva la fine dell'input globalmente senza duplicare connessioni eventi
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

----------------------------------------------------
-- RIPPLE EFFECT - Ottimizzato e reso realistico
----------------------------------------------------
function Utils.Ripple(button)
	-- Assicura che gli elementi fuori dal bottone siano nascosti
	button.ClipsDescendants = true

	button.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			local ripple = Instance.new("Frame")
			ripple.AnchorPoint = Vector2.new(0.5, 0.5)
			
			-- Calcola la posizione esatta del click rispetto al bottone
			local mousePos = input.Position
			local buttonPos = button.AbsolutePosition
			local relativeX = mousePos.X - buttonPos.X
			local relativeY = mousePos.Y - buttonPos.Y
			
			ripple.Position = UDim2.fromOffset(relativeX, relativeY)
			ripple.Size = UDim2.fromOffset(0, 0)
			ripple.BackgroundTransparency = 0.35
			ripple.BackgroundColor3 = Color3.new(1, 1, 1)
			ripple.BorderSizePixel = 0
			ripple.Parent = button

			-- Crea l'angolo tondo per il ripple senza toccare quello del bottone
			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(1, 0)
			corner.Parent = ripple

			-- Usa il lato più grande per coprire l'intero bottone
			local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2

			local tween = Utils.Tween(
				ripple,
				{
					Size = UDim2.fromOffset(maxSize, maxSize),
					BackgroundTransparency = 1
				},
				TweenInfo.new(0.5, Enum.EasingStyle.OutQuad)
			)

			tween.Completed:Connect(function()
				ripple:Destroy()
			end)
		end
	end)
end

----------------------------------------------------
-- HOVER EFFECT
----------------------------------------------------
function Utils.Hover(button, normal, hover)
	button.MouseEnter:Connect(function()
		Utils.Tween(button, { BackgroundColor3 = hover })
	end)

	button.MouseLeave:Connect(function()
		Utils.Tween(button, { BackgroundColor3 = normal })
	end)
end

----------------------------------------------------
-- CREATE LABEL
----------------------------------------------------
function Utils.CreateLabel(parent, text, size, color, font)
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, 0, 0, 20)
	label.Text = text or ""
	label.TextColor3 = color or Color3.new(1, 1, 1)
	label.Font = font or Enum.Font.SourceSans
	label.TextSize = size or 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = parent

	return label
end

----------------------------------------------------
-- MATH UTILS
----------------------------------------------------
function Utils.Clamp(value, min, max)
	return math.clamp(value, min, max)
end

function Utils.Round(number)
	return math.floor(number + 0.5)
end

function Utils.Lerp(a, b, t)
	return a + (b - a) * t
end

return Utils
