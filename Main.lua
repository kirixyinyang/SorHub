-- SorHub PvP - Main Loader (FIXED GUI)
-- Версия: 1.0.2

repeat wait() until game:IsLoaded()

-- Функция загрузки с анимацией
local function LoadSorHub()
    local urls = {
        "https://raw.githubusercontent.com/kirixyinyang/SorHub/main/SorHub.lua",
        "https://cdn.jsdelivr.net/gh/kirixyinyang/SorHub@main/SorHub.lua",
        "https://raw.githubusercontent.com/kirixyinyang/SorHub/main/SorHub.lua?t=" .. tick()
    }
    
    -- Показываем анимацию загрузки
    local loadingGui = Instance.new("ScreenGui")
    loadingGui.Name = "LoadingScreen"
    loadingGui.Parent = game:GetService("CoreGui")
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 100)
    frame.Position = UDim2.new(0.5, -150, 0.5, -50)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.Parent = loadingGui
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Text = "SorHub PvP"
    title.TextColor3 = Color3.fromRGB(255, 100, 100)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.BackgroundTransparency = 1
    title.Parent = frame
    
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 20)
    status.Position = UDim2.new(0, 0, 0, 35)
    status.Text = "Подключение к GitHub..."
    status.TextColor3 = Color3.new(1, 1, 1)
    status.TextSize = 14
    status.Font = Enum.Font.Gotham
    status.BackgroundTransparency = 1
    status.Parent = frame
    
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0.8, 0, 0, 10)
    progressBar.Position = UDim2.new(0.1, 0, 0, 65)
    progressBar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    progressBar.Parent = frame
    
    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    progressFill.Parent = progressBar
    
    -- Анимация загрузки
    for i = 1, 100 do
        progressFill.Size = UDim2.new(i/100, 0, 1, 0)
        if i == 30 then status.Text = "Загрузка скрипта..." end
        if i == 60 then status.Text = "Инициализация..." end
        if i == 90 then status.Text = "Почти готово..." end
        wait(0.03)
    end
    
    -- Загружаем реальный скрипт
    for _, url in ipairs(urls) do
        local success, result = pcall(function()
            return game:HttpGet(url)
        end)
        
        if success and result and #result > 500 then
            status.Text = "Запуск..."
            progressFill.Size = UDim2.new(1, 0, 1, 0)
            wait(0.5)
            loadingGui:Destroy()
            
            -- Выполняем скрипт
            loadstring(result)()
            return
        end
        wait(1)
    end
    
    -- Если ничего не загрузилось
    status.Text = "Ошибка загрузки :("
    progressFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    wait(2)
    loadingGui:Destroy()
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "SorHub PvP",
        Text = "❌ Не удалось загрузить. Попробуй позже.",
        Duration = 3
    })
end

-- Запускаем
spawn(LoadSorHub)
print("SorHub Loader activated")