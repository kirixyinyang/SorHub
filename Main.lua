-- SorHub PvP - Main Loader FIXED
-- Версия: 1.0.1 (Исправлена ошибка соединения)

repeat wait() until game:IsLoaded()

-- Функция загрузки с несколькими попытками
local function LoadScript()
    local urls = {
        "https://raw.githubusercontent.com/kirixyinyang/SorHub/main/SorHub.lua",
        "https://raw.githubusercontent.com/kirixyinyang/SorHub/main/SorHub.lua?token=" .. math.random(999999),
        "https://cdn.jsdelivr.net/gh/kirixyinyang/SorHub@main/SorHub.lua",  -- GitHub CDN (быстрее)
        "https://raw.githubusercontent.com/kirixyinyang/SorHub/main/SorHub.lua?t=" .. tick()
    }
    
    for _, url in ipairs(urls) do
        local success, result = pcall(function()
            return game:HttpGet(url)
        end)
        
        if success and result and #result > 100 then
            loadstring(result)()
            return true
        end
        wait(1)
    end
    return false
end

-- Уведомление о загрузке
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "SorHub PvP",
    Text = "⏳ Загрузка...",
    Duration = 2
})

-- Пытаемся загрузить
spawn(function()
    wait(2)
    local loaded = LoadScript()
    
    if not loaded then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "❌ SorHub PvP",
            Text = "Ошибка загрузки. Используй VPN или повтори позже",
            Duration = 5
        })
    end
end)

print("SorHub Loader activated")