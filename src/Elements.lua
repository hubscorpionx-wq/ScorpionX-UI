

	local click = Instance.new("TextButton")
	click.Size = UDim2.fromScale(1, 1)
	click.BackgroundTransparency = 1
	click.Text = ""
	click.Parent = frame

	click.Activated:Connect(function()
		state = not state
		Update(true)
		if callback then task.spawn(callback, state) end
	end)

	-- ==========================================
	-- FIX: Creiamo l'oggetto personalizzato con il metodo :Set()
	-- ==========================================
	local ToggleObject = {}
	ToggleObject.Instance = frame -- Mantiene comunque il riferimento al frame se serve

	function ToggleObject:Set(v)
		if state ~= v then
			state = v
			Update(true)
			if callback then task.spawn(callback, state) end
		end
	end

	-- Permette al codice legacy di trattare l'oggetto come se fosse il frame originale
	setmetatable(ToggleObject, {
		__index = function(_, key)
			return frame[key]
		end,
		__newindex = function(_, key, value)
			frame[key] = value
		end
	})

	return ToggleObject
end

--------------------------------------------------------
-- SLIDER
--------------------------------------------------------
function Elements.Slider(parent, title, min, max, default, callback)
	local UIS = game:GetService("UserInputService")
	local frame = CreateContainer(parent, 52)

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0, 12, 0, 6)
	label.Size = UDim2.new(0.7, 0, 0, 18)
	label.Font = Theme.SemiBoldFont
	label.Text = title
	label.TextSize = 13
	label.TextColor3 = Theme.Colors.Text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local valueLabel = Instance.new("TextLabel")
	valueLabel.BackgroundTransparency = 1
	valueLabel.Position = UDim2.new(0.7, 0, 0, 6)
	valueLabel.Size = UDim2.new(0.3, -12, 0, 18)
	valueLabel.Font = Theme.BoldFont
	valueLabel.TextColor3 = Theme.Colors.Accent
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Text = tostring(default)
	valueLabel.Parent = frame

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1, -24, 0, 5)
	bar.Position = UDim2.new(0, 12, 0.7, 0)
	bar.BackgroundColor3 = Theme.Colors.Stroke
	bar.BorderSizePixel = 0
	bar.Parent = frame

	Utils.Corner(bar)

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(math.clamp((default - min) / (max - min), 0, 1), 0, 1, 0)
	fill.BackgroundColor3 = Theme.Colors.Accent
	fill.BorderSizePixel = 0
	fill.Parent = bar

	Utils.Corner(fill)

	local dragging = false

	local function SetValue(x)
		local percent = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
		fill.Size = UDim2.new(percent, 0, 1, 0)
		local value = math.floor(min + ((max - min) * percent))
		valueLabel.Text = tostring(value)

		if callback then task.spawn(callback, value) end
	end

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			SetValue(input.Position.X)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			SetValue(input.Position.X)
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	return frame
end

--------------------------------------------------------
-- TEXTBOX
--------------------------------------------------------
function Elements.TextBox(parent, title, placeholder, callback)
	local frame = CreateContainer(parent, 44)

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0, 12, 0, 0)
	label.Size = UDim2.new(0.4, 0, 1, 0)
	label.Font = Theme.SemiBoldFont
	label.Text = title
	label.TextSize = 13
	label.TextColor3 = Theme.Colors.Text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0.45, 0, 0, 26)
	box.Position = UDim2.new(1, -12, 0.5, -13)
	box.AnchorPoint = Vector2.new(1, 0)
	box.BackgroundColor3 = Theme.Colors.Tertiary
	box.TextColor3 = Theme.Colors.Text
	box.PlaceholderText = placeholder or "Scrivi..."
	box.PlaceholderColor3 = Theme.Colors.Placeholder
	box.Font = Theme.Font
	box.TextSize = 12
	box.ClearTextOnFocus = true
	box.Parent = frame

	Utils.Corner(box)
	Utils.Stroke(box, Theme.Colors.Stroke)

	box.FocusLost:Connect(function(enterPressed)
		if callback then task.spawn(callback, box.Text, enterPressed) end
	end)

	return frame
end

----------------------------------------------------------
-- DROPDOWN (Con Aggiornamento Dinamico della Selezione)
----------------------------------------------------------
function Elements.Dropdown(parent, title, options, callback)
	local frame = CreateContainer(parent, 40)
	frame.ClipsDescendants = true

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 0, 40)
	button.BackgroundTransparency = 1
	-- Inizialmente mostra il titolo
	button.Text = "  " .. title .. "  ▼"
	button.Font = Theme.SemiBoldFont
	button.TextSize = 13
	button.TextColor3 = Theme.Colors.Text
	button.TextXAlignment = Enum.TextXAlignment.Left
	button.Parent = frame

	local btnPad = Instance.new("UIPadding")
	btnPad.PaddingLeft = UDim.new(0, 12)
	btnPad.Parent = button

	local opened = false
	local currentOptions = options or {}
	local currentSelection = nil -- Memorizza l'opzione attualmente selezionata (es. "Copper x2")

	local list = Instance.new("ScrollingFrame")
	list.Visible = false
	list.Position = UDim2.new(0, 12, 0, 42)
	list.Size = UDim2.new(1, -24, 0, 0)
	list.CanvasSize = UDim2.new(0, 0, 0, #currentOptions * 28)
	list.ScrollBarThickness = 2
	list.ScrollBarImageColor3 = Theme.Colors.Accent
	list.BackgroundTransparency = 1
	list.BorderSizePixel = 0
	list.Parent = frame

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 2)
	layout.Parent = list

	-- Helper per creare un'opzione
	local function createOptionButton(optionText)
		local opt = Instance.new("TextButton")
		opt.Size = UDim2.new(1, 0, 0, 26)
		opt.BackgroundColor3 = Theme.Colors.Tertiary
		opt.Font = Theme.Font
		opt.Text = tostring(optionText)
		opt.TextColor3 = Theme.Colors.TextDark
		opt.TextSize = 12
		opt.Parent = list

		Utils.Corner(opt)

		opt.MouseEnter:Connect(function()
			Utils.Tween(opt, {TextColor3 = Theme.Colors.Accent})
		end)
		opt.MouseLeave:Connect(function()
			Utils.Tween(opt, {TextColor3 = Theme.Colors.TextDark})
		end)

		opt.Activated:Connect(function()
			local activeText = opt.Text
			currentSelection = activeText -- Salva la selezione corrente
			button.Text = "  " .. activeText .. "  ▼" -- Imposta il testo sul bottone principale
			opened = false
			list.Visible = false
			Utils.Tween(frame, {Size = UDim2.new(0.95, 0, 0, 40)})
			if callback then task.spawn(callback, activeText) end
		end)

		return opt
	end

	-- Aggiornamento dinamico intelligente (REUSE)
	local function updateList(newOptions)
		currentOptions = newOptions or {}

		-- 1. Trova se la risorsa precedentemente selezionata esiste ancora nella nuova lista (anche se la quantità è cambiata!)
		-- Es: se prima avevamo selezionato "Copper x2" e ora c'è "Copper x10", vogliamo identificare che la selezione è ancora "Copper"
		local updatedSelectionText = nil
		if currentSelection then
			local cleanOldName = currentSelection:gsub(" x%d+$", "") -- Estrae "Copper" da "Copper x2"
			for _, newOpt in ipairs(currentOptions) do
				local cleanNewName = tostring(newOpt):gsub(" x%d+$", "") -- Estrae "Copper" da "Copper x10"
				if cleanOldName == cleanNewName then
					updatedSelectionText = tostring(newOpt) -- Trovato! Sarà "Copper x10"
					break
				end
			end
		end

		-- Se la risorsa precedentemente selezionata esiste ancora ma con quantità aggiornata, sincronizziamo lo stato interno
		if updatedSelectionText then
			currentSelection = updatedSelectionText
		end

		-- 2. Recuperiamo solo i bottoni TextButton esistenti per aggiornarli
		local existingButtons = {}
		for _, child in ipairs(list:GetChildren()) do
			if child:IsA("TextButton") then
				table.insert(existingButtons, child)
			end
		end

		local maxCount = math.max(#currentOptions, #existingButtons)

		for i = 1, maxCount do
			local newOptText = currentOptions[i]
			local btn = existingButtons[i]

			if newOptText ~= nil then
				if btn ~= nil then
					btn.Text = tostring(newOptText)
					btn.Visible = true
				else
					createOptionButton(newOptText)
				end
			else
				if btn ~= nil then
					btn:Destroy()
				end
			end
		end

		-- 3. AGGIORNAMENTO DINAMICO DEL BOTTONE CHIUSO PRINCIPALE
		-- Se c'è una selezione attiva, aggiorna istantaneamente il testo del bottone principale chiuso (es. da "Copper x2" a "Copper x10")
		if currentSelection then
			local arrow = opened and "  ▲" or "  ▼"
			button.Text = "  " .. currentSelection .. arrow
		end

		-- Adatta lo scroll in base al numero finale di elementi
		list.CanvasSize = UDim2.new(0, 0, 0, #currentOptions * 28)

		-- Se aperto, aggiorna fluidamente l'altezza
		if opened then
			local height = math.min(#currentOptions * 28 + 5, 115)
			list.Size = UDim2.new(1, -24, 0, height)
			Utils.Tween(frame, {Size = UDim2.new(0.95, 0, 0, height + 50)})
		end
	end

	-- Inizializzazione
	updateList(options)

	-- Gestione click di apertura/chiusura del Dropdown principale
	button.Activated:Connect(function()
		opened = not opened
		
		-- Calcolo del testo da mostrare sul bottone principale (mantiene la selezione se esiste!)
		local displayText = currentSelection or title
		
		if opened then
			button.Text = "  " .. displayText .. "  ▲" -- Mantiene il nome dell'opzione anziché resettarsi!
			local height = math.min(#currentOptions * 28 + 5, 115)
			list.Visible = true
			list.Size = UDim2.new(1, -24, 0, height)
			Utils.Tween(frame, {Size = UDim2.new(0.95, 0, 0, height + 50)})
		else
			button.Text = "  " .. displayText .. "  ▼"
			list.Visible = false
			Utils.Tween(frame, {Size = UDim2.new(0.95, 0, 0, 40)})
		end
	end)

	-- Wrapper dei metodi esterni
	local DropdownObject = {}
	DropdownObject.Instance = frame

	function DropdownObject:Refresh(newOptions)
		updateList(newOptions)
	end

	function DropdownObject:Set(value)
		currentSelection = value
		local arrow = opened and "  ▲" or "  ▼"
		button.Text = "  " .. tostring(value) .. arrow
		if callback then task.spawn(callback, value) end
	end

	function DropdownObject:Get()
		return currentSelection
	end

	setmetatable(DropdownObject, {
		__index = function(_, key)
			return frame[key]
		end,
		__newindex = function(_, key, value)
			frame[key] = value
		end
	})

	return DropdownObject
end

--------------------------------------------------------
-- KEYBIND
--------------------------------------------------------
function Elements.Keybind(parent, title, defaultKey, callback)
	local UIS = game:GetService("UserInputService")
	local frame = CreateContainer(parent, 40)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.6, 0, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Font = Theme.SemiBoldFont
	label.Text = title
	label.TextSize = 13
	label.TextColor3 = Theme.Colors.Text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local bind = Instance.new("TextButton")
	bind.Size = UDim2.fromOffset(75, 24)
	bind.Position = UDim2.new(1, -12, 0.5, -12)
	bind.AnchorPoint = Vector2.new(1, 0)
	bind.BackgroundColor3 = Theme.Colors.Tertiary
	bind.Font = Theme.BoldFont
	bind.TextColor3 = Theme.Colors.Accent
	bind.TextSize = 11
	bind.Text = defaultKey and defaultKey.Name or "None"
	bind.Parent = frame

	Utils.Corner(bind)
	Utils.Stroke(bind, Theme.Colors.Stroke)

	local current = defaultKey
	local waiting = false

	bind.Activated:Connect(function()
		waiting = true
		bind.Text = "..."
	end)

	UIS.InputBegan:Connect(function(input, gp)
		if gp then return end

		if waiting then
			if input.UserInputType == Enum.UserInputType.Keyboard then
				waiting = false
				current = input.KeyCode
				bind.Text = current.Name
			end
		elseif input.KeyCode == current then
			if callback then task.spawn(callback, current) end
		end
	end)

	return frame
end

return Elements
