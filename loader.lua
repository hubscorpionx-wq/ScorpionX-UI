--==============================================================================
-- ScorpioX Loader (Ottimizzato)
--==============================================================================

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

-- 1. Inizializza subito l'ambiente globale con i moduli condivisi
local Modules = {}
Modules.Theme = Get("Theme")
Modules.Utils = Get("Utils")

getgenv().ScorpioXModules = Modules

-- 2. Scarica i file sorgenti (ora Window non crasherà mai perché ScorpioXModules.Theme esiste già)
local WindowFile = Get("Window")
local ElementsFile = Get("Elements")
local NotificationsFile = Get("Notifications")

-- Aggiorna la tabella moduli per sicurezza
Modules.Window = WindowFile
Modules.Elements = ElementsFile
Modules.Notifications = NotificationsFile

-- 3. Inizializza la libreria passando i componenti a "init.lua"
local Library = Get("init")(WindowFile, ElementsFile, NotificationsFile)

return Library
