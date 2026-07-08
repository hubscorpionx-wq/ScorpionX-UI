--==============================================================================
-- ScorpioX Notifications
--==============================================================================

local TweenService = game:GetService("TweenService")

local Theme = require(script.Parent.Theme)
local Utils = require(script.Parent.Utils)

local Notifications = {}

local Holder

local function GetHolder(parent)

	if Holder and Holder.Parent then
		return Holder
	end

	Holder = Instance.new("Frame")
	Holder.Name = "NotificationHolder"
	Holder.AnchorPoint = Vector2.new(1,1)
	Holder.Position = UDim2.new(1,-15,1,-15)
	Holder.Size = UDim2.new(0,300,1,-30)
	Holder.BackgroundTransparency = 1
	Holder.Parent = parent

	local layout = Instance.new("UIListLayout")
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	layout.Padding = UDim.new(0,8)
	layout.Parent = Holder

	return Holder

end

function Notifications.Notify(parent,title,text,duration)

	duration = duration or 4

	local holder = GetHolder(parent)

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1,0,0,70)
	frame.BackgroundColor3 = Theme.Colors.Secondary
	frame.Parent = holder

	Utils.Corner(frame)
	Utils.Stroke(frame,Theme.Colors.Accent)

	frame.BackgroundTransparency = 1

	local titleLabel = Instance.new("TextLabel")
	titleLabel.BackgroundTransparency = 1
	titleLabel.Position = UDim2.new(0,12,0,8)
	titleLabel.Size = UDim2.new(1,-24,0,18)
	titleLabel.Font = Theme.BoldFont
	titleLabel.TextSize = 14
	titleLabel.TextColor3 = Theme.Colors.Accent
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Text = title
	titleLabel.Parent = frame

	local body = Instance.new("TextLabel")
	body.BackgroundTransparency = 1
	body.Position = UDim2.new(0,12,0,28)
	body.Size = UDim2.new(1,-24,1,-38)
	body.Font = Theme.Font
	body.TextWrapped = true
	body.TextSize = 12
	body.TextColor3 = Theme.Colors.Text
	body.TextXAlignment = Enum.TextXAlignment.Left
	body.TextYAlignment = Enum.TextYAlignment.Top
	body.Text = text
	body.Parent = frame

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1,0,0,3)
	bar.Position = UDim2.new(0,0,1,-3)
	bar.BorderSizePixel = 0
	bar.BackgroundColor3 = Theme.Colors.Accent
	bar.Parent = frame

	frame.BackgroundTransparency = 0

	TweenService:Create(
		bar,
		TweenInfo.new(duration,Enum.EasingStyle.Linear),
		{
			Size = UDim2.new(0,0,0,3)
		}
	):Play()

	task.delay(duration,function()

		local tween = TweenInfo.new(.25)

		Utils.Tween(frame,{
			BackgroundTransparency = 1
		},tween)

		Utils.Tween(titleLabel,{
			TextTransparency = 1
		},tween)

		Utils.Tween(body,{
			TextTransparency = 1
		},tween)

		Utils.Tween(bar,{
			BackgroundTransparency = 1
		},tween)

		task.wait(.3)

		frame:Destroy()

	end)

end

return Notifications
