--==============================================================================
-- SCORPION X HUB - SCRIPT DI ESEMPIO GENERICO COMPLETO (SOLO "EXAMPLE")
--==============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    hrp = character:WaitForChild("HumanoidRootPart")
end)

-- 1. CARICAMENTO DEI MODULI TRAMITE IL LOADER OTTIMIZZATO
local BASE = "https://raw.githubusercontent.com/hubscorpionx-wq/ScorpionX-UI/main/src/"

local function Get(name)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(BASE .. name .. ".lua"))()
    end)
    if not success then
        error("[-] Errore nel caricamento del modulo: " .. tostring(name) .. "\n" .. tostring(result))
    end
    return result
end

-- Inizializza l'ambiente globale per i moduli condivisi
local Modules = {
    Theme = Get("Theme"),
    Utils = Get("Utils")
}
getgenv().ScorpioXModules = Modules

-- Scarica i sorgenti dell'interfaccia grafica
local WindowFile = Get("Window")
local ElementsFile = Get("Elements")
local NotificationsFile = Get("Notifications")

-- Registra i moduli nella tabella globale per sicurezza interna
Modules.Window = WindowFile
Modules.Elements = ElementsFile
Modules.Notifications = NotificationsFile

-- Inizializza la libreria passando i componenti a "init.lua"
local Library = Get("init")(WindowFile, ElementsFile, NotificationsFile)


--==============================================================================
-- 2. CONFIGURAZIONE STATI UTENTE (SISTEMA CENTRALIZZATO OPTIONS)
--==============================================================================
local Options = {
    ExampleToggleA      = { Value = false },
    ExampleToggleB      = { Value = false },
    ExampleLoopToggle   = { Value = false }
}

--==============================================================================
-- 3. CREAZIONE E CONFIGURAZIONE DELL'INTERFACCIA UTENTE
--==============================================================================

local Window = Library:CreateWindow({
    Title = "Scorpion X Hub",
    Subtitle = "v1.0.2 BETA",
    ToggleKey = Enum.KeyCode.LeftControl, -- Tasto predefinito (es. Ctrl Sinistro)
    Size = UDim2.fromOffset(550, 450),     -- Dimensioni ottimali stabili
    Icon = "96045739039093"
})

-- Funzioni di notifica avanzate integrate nello stile Scorpion X
local function Notify(title, message, duration)
    pcall(function()
        Window:Notify(title, message, duration or 3)
    end)
end

local function NotifyToggle(name, state)
    Notify(name, state and "Attivato." or "Disattivato.")
end


--------------------------------------------------------------------------------
-- SCHEDA 1: TAB ONE (Example Toggles & Actions)
--------------------------------------------------------------------------------
local TabOne = Window:CreateTab("Tab One")

TabOne:Section("Example Section A")

-- Toggle classico con memorizzazione stato centralizzata
TabOne:Toggle("Example Toggle A", false, function(state)
    Options.ExampleToggleA.Value = state
    NotifyToggle("Example Toggle A", state)
end)

TabOne:Separator()

-- Toggle classico B
TabOne:Toggle("Example Toggle B", false, function(state)
    Options.ExampleToggleB.Value = state
    NotifyToggle("Example Toggle B", state)
end)

TabOne:Separator()

-- Pulsante interattivo per azioni immediate
TabOne:Button("Example Button A", function()
    Notify("Example", "Pulsante A cliccato con successo!")
    print("[EXAMPLE] Button A premuto.")
end)


--------------------------------------------------------------------------------
-- SCHEDA 2: TAB TWO (Example Loops & Drops) - AGGIORNATA
--------------------------------------------------------------------------------
local TabTwo = Window:CreateTab("Tab Two")

TabTwo:Section("Example Section B")

-- Toggle avanzato con esecuzione di un ciclo asincrono (Loop)
TabTwo:Toggle("Example Loop Toggle", false, function(state)
    Options.ExampleLoopToggle.Value = state
    NotifyToggle("Example Loop Toggle", state)
    
    if state then
        task.spawn(function()
            while Options.ExampleLoopToggle.Value do
                print("[EXAMPLE LOOP] Ciclo in esecuzione ogni 500ms...")
                task.wait(0.5)
            end
        end)
    end
end)

TabTwo:Separator()

-- Dropdown con supporto Multi-Selezione
local datasetMock = {"Option_Alpha", "Option_Beta", "Option_Gamma"}
local SelectedOptions = {} -- Ora contiene una tabella di elementi selezionati

local ExampleDropdown = TabTwo:Dropdown("Example Dropdown", datasetMock, function(optionsList)
    SelectedOptions = optionsList
    
    -- Unisce le opzioni selezionate in una stringa leggibile per la notifica
    local visualList = table.concat(SelectedOptions, ", ")
    if visualList == "" then visualList = "Nessuna selezione" end
    
    Notify("Dropdown", "Selezionati: " .. visualList)
end)

-- Pulsante per aggiornare la lista degli elementi a runtime
local function RefreshExampleDropdown()
    if ExampleDropdown and ExampleDropdown.Refresh then
        pcall(function()
            table.insert(datasetMock, "New_Option_" .. tostring(math.random(100, 999)))
            ExampleDropdown:Refresh(datasetMock)
            Notify("System", "Lista elementi aggiornata dinamicamente!")
        end)
    end
end

TabTwo:Button("Example Refresh List", function()
    RefreshExampleDropdown()
end)


--------------------------------------------------------------------------------
-- SCHEDA 3: TAB THREE (Example Inputs & Customizers)
--------------------------------------------------------------------------------
local TabThree = Window:CreateTab("Tab Three")

TabThree:Section("Example Section C")

-- TextBox per inserimento dati testuali o numerici quantitativi
local numericValue = 1
TabThree:TextBox("Example TextBox", "Inserisci valore...", function(text)
    local num = tonumber(text)
    numericValue = (num and num > 0) and num or 1
    if not num or num <= 0 then 
        Notify("Input Error", "Valore non valido! Impostato di default a 1.") 
    else
        Notify("Input Success", "Quantità impostata a: " .. numericValue)
    end
end)

-- Slider progressivo per regolare numericamente parametri di gioco
TabThree:Slider("Example Slider", 16, 150, 16, function(value)
    if character and character:FindFirstChildOfClass("Humanoid") then
        character:FindFirstChildOfClass("Humanoid").WalkSpeed = value
    end
end)


--------------------------------------------------------------------------------
-- SCHEDA 4: SETTINGS (Example Config & Core)
--------------------------------------------------------------------------------
local TabSettings = Window:CreateTab("Settings")

TabSettings:Section("Core UI Config")

-- Keybind dinamico per riassegnare il tasto di apertura menu
TabSettings:Keybind("Example Keybind", Enum.KeyCode.LeftControl, function(nuovoTasto)
    Window.ToggleKey = nuovoTasto
    if getgenv().ScorpioXModules and getgenv().ScorpioXModules.CurrentWindowInstance then
        getgenv().ScorpioXModules.CurrentWindowInstance.ToggleKey = nuovoTasto
    end
    Notify("Menu", "Tasto di attivazione modificato in " .. nuovoTasto.Name .. ".")
end)

TabSettings:Separator()

-- Box informativo descrittivo (Paragraph)
TabSettings:Paragraph("Example Title Paragraph", "Questo framework implementa un sistema ad eventi grafici ottimizzato. Trascina la barra superiore per spostare la GUI, oppure usa il pulsante mobile in modalità Mobile.")

-- Riga di testo pulita (Label)
TabSettings:Label("Scorpion X Hub UI Engine - Template Pro")

-- Pulsante per scaricare in modo sicuro l'interfaccia di gioco
TabSettings:Button("Rimuovi Interfaccia", function()
    Window:Destroy()
end)
