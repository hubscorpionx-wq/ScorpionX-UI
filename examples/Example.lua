--==============================================================================
-- SCORPIOX HUB - SCRIPT DI ESEMPIO COMPLETO
--==============================================================================

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
local Modules = {}
Modules.Theme = Get("Theme")
Modules.Utils = Get("Utils")

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
-- 2. CREAZIONE E CONFIGURAZIONE DELL'INTERFACCIA UTENTE
--==============================================================================

local Window = Library:CreateWindow({
    Title = "Scorpion X Hub",
    ToggleKey = Enum.KeyCode.RightControl, -- Tasto predefinito per PC
    Size = UDim2.fromOffset(450, 300),     -- Dimensioni della finestra
    Icon = "96045739039093"                 -- ID Icona di ScorpioX
})

--------------------------------------------------------------------------------
-- SCHEDA PRINCIPALE: MAIN
--------------------------------------------------------------------------------
local Main = Window:CreateTab("Main")

-- Sezione Impostazioni dell'interfaccia
Main:Section("Impostazioni UI")

-- KEYBIND 1: Cambio dinamico del tasto di apertura/chiusura del menu
Main:Keybind("Tasto Menu", Enum.KeyCode.RightControl, function(nuovoTasto)
    Window.ToggleKey = nuovoTasto
    
    if getgenv().ScorpioXModules and getgenv().ScorpioXModules.CurrentWindowInstance then
        getgenv().ScorpioXModules.CurrentWindowInstance.ToggleKey = nuovoTasto
    end
    
    print("Il menu ora si apre con il tasto:", nuovoTasto.Name)
end)

Main:Separator()

-- Sezione Funzioni dello script
Main:Section("Funzioni Cheat")

-- KEYBIND 2: Tasto rapido per attivare o disattivare una mod specifica
local modAttiva = false
Main:Keybind("Attiva Mod", Enum.KeyCode.E, function(tastoPremuto)
    modAttiva = not modAttiva
    print("Stato della mod cambiato! Attiva:", modAttiva, "| Tasto usato:", tastoPremuto.Name)
end)

-- BUTTON: Pulsante classico cliccabile
Main:Button("Print Hello", function()
    print("Hello World")
end)

-- TOGGLE: Interruttore On/Off
Main:Toggle("God Mode", false, function(state)
    print("Toggle:", state)
end)

-- SLIDER: Barra di regolazione numerica progressiva
Main:Slider("WalkSpeed", 16, 100, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

-- TEXTBOX: Campo di testo per l'input dell'utente
Main:TextBox("Player Name", "Scrivi...", function(text)
    print("Testo inserito:", text)
end)

-- DROPDOWN: Menu a tendina con selezione multipla
Main:Dropdown("Select Team", {"Red", "Blue", "Green"}, function(option)
    print("Squadra selezionata:", option)
end)

Main:Separator()

-- PARAGRAPH: Box informativo con titolo e descrizione estesa
Main:Paragraph("Info Script", "Questo script usa Scorpion X Hub Engine. Trascina la barra superiore per muovere la finestra o usa il pulsante mobile rotondo se sei da dispositivi Mobile.")

-- LABEL: Semplice riga di testo descrittiva
Main:Label("Scorpion X Hub UI Example")


--------------------------------------------------------------------------------
-- SCHEDA SECONDARIA: MISC
--------------------------------------------------------------------------------
local Misc = Window:CreateTab("Misc")

-- BUTTON: Pulsante per testare l'invio delle notifiche popup temporizzate
Misc:Button("Notify", function()
    Window:Notify("Scorpion X Hub", "La notifica funziona correttamente!", 5)
end)

-- BUTTON: Pulsante per distruggere e scaricare completamente la GUI dal gioco
Misc:Button("Rimuovi Interfaccia", function()
    Window:Destroy()
end)

