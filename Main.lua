-- SorHub PvP - Main Loader
-- Blox Fruits PvP Script | Auto Bounty + Aimbot
-- Версия: 1.0.0

repeat wait() until game:IsLoaded()

-- Проверка на экзекьютор
local ExecutorInfo = {
    isDelta = shared and shared.VEIL_EXECUTOR == "Delta" or false,
    isKrnl = http and http.request or false,
    isSynapse = syn and syn.request or false,
    isScriptWare = is_sirhurt_closure or false
}

-- Анти-бан загрузка
local function LoadSorHub()
    local scriptUrl = "https://raw.githubusercontent.com/SorHubDev/BloxFruit/main/SorHub.lua"
    
    local success, result = pcall(function()
        return game:HttpGet(scriptUrl)
    end)
    
    if success and result then
        loadstring(result)()
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "SorHub PvP",
            Text = "⚠️ Failed to load script. Check internet connection.",
            Duration = 3
        })
    end
end

-- Имитация загрузки (анти-детект)
spawn(function()
    for i = 1, 3 do
        wait(1)
        if i == 2 then
            LoadSorHub()
        end
    end
end)

print("✅ SorHub PvP | Waiting for game load...")