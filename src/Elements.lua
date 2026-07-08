--==============================================================================
-- ScorpioX Elements
--==============================================================================

local Theme = require(script.Parent.Theme)
local Utils = require(script.Parent.Utils)

local Elements = {}

local function CreateContainer(parent, height)

	local frame = Instance.new("Frame")

	frame.Size = UDim2.new(0.95,0,0,height)
	frame.BackgroundColor3 = Theme.Colors.Secondary
	frame.BorderSizePixel = 0

	frame.Parent = parent

	Utils.Corner(frame)
	Utils.Stroke(frame,Theme.Colors.Stroke)

	return frame

end

--------------------------------------------------------
-- SECTION
--------------------------------------------------------

function Elements.Section(parent,text)

	local label = Instance.new("TextLabel")

	label.Size = UDim2.new(.95,0,0,22)

	label.BackgroundTransparency = 1

	label.Font = Theme.BoldFont
	label.TextColor3 = Theme.Colors.Accent
	label.TextSize = 12

	label.TextXAlignment = Enum.TextXAlignment.Left

	label.Text = "── "..string.upper(text).." ──"

	label.Parent = parent

	return label

end

--------------------------------------------------------
-- PARAGRAPH
--------------------------------------------------------

function Elements.Paragraph(parent,title,body)

	local frame = CreateContainer(parent,60)

	local Title = Instance.new("TextLabel")

	Title.Position = UDim2.new(0,10,0,5)
	Title.Size = UDim2.new(1,-20,0,18)

	Title.BackgroundTransparency = 1

	Title.Font = Theme.BoldFont
	Title.TextColor3 = Theme.Colors.Accent
	Title.TextSize = 13

	Title.TextXAlignment = Enum.TextXAlignment.Left

	Title.Text = title

	Title.Parent = frame

	local Body = Instance.new("TextLabel")

	Body.Position = UDim2.new(0,10,0,24)
	Body.Size = UDim2.new(1,-20,1,-28)

	Body.BackgroundTransparency = 1

	Body.Font = Theme.Font
	Body.TextWrapped = true

	Body.TextColor3 = Theme.Colors.TextDark
	Body.TextSize = 12

	Body.TextXAlignment = Enum.TextXAlignment.Left
	Body.TextYAlignment = Enum.TextYAlignment.Top

	Body.Text = body

	Body.Parent = frame

	return frame

end

return Elements
