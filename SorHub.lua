-- SorHub PvP v1.0.0
-- Режим: PvP | Auto Bounty | Aimbot | Boss Farm
-- Полная защита от бана

do
    -- Сервисы
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local VirtualUser = game:GetService("VirtualUser")
    local HttpService = game:GetService("HttpService")
    local TweenService = game:GetService("TweenService")
    local LP = Players.LocalPlayer
    local Mouse = LP:GetMouse()
    
    -- ========== АНТИ-БАН СИСТЕМА ==========
    local AntiBan = {
        Enabled = true,
        LastPosition = nil,
        JumpTimers = {},
        Start = function()
            spawn(function()
                while AntiBan.Enabled and wait(2 + math.random(1, 3)) do
                    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                        -- Случайные прыжки (имитация игрока)
                        LP.Character.Humanoid.Jump = true
                        wait(0.1)
                        LP.Character.Humanoid.Jump = false
                        
                        -- Случайные движения мыши
                        if UserInputService then
                            local pos = Vector2.new(
                                math.random(500, 1500),
                                math.random(300, 800)
                            )
                            UserInputService.MoveMouse(pos)
                        end
                        
                        -- Анти-афк
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                    end
                end
            end)
        end
    }
    
    -- ========== СОЗДАНИЕ GUI ==========
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SorHub"
    ScreenGui.Parent = LP:FindFirstChild("PlayerGui") or game:GetService("CoreGui")
    ScreenGui.ResetOnSpawn = false
    
    -- Главное окно
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    -- Заголовок
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Title.Text = "SorHub PvP (Beta) v1.0.0"
    Title.TextColor3 = Color3.fromRGB(255, 100, 100)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame
    
    -- Кнопка закрытия
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.TextSize = 16
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = Title
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui.Enabled = false
    end)
    
    -- Вкладки
    local TabFrame = Instance.new("Frame")
    TabFrame.Name = "TabFrame"
    TabFrame.Size = UDim2.new(1, 0, 0, 40)
    TabFrame.Position = UDim2.new(0, 0, 0, 40)
    TabFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    TabFrame.Parent = MainFrame
    
    local Tabs = {
        {Name = "⚔️ Aimbot", Color = Color3.fromRGB(255, 80, 80)},
        {Name = "💰 Bounty", Color = Color3.fromRGB(80, 255, 80)},
        {Name = "👾 Boss", Color = Color3.fromRGB(80, 80, 255)},
        {Name = "⚙️ Settings", Color = Color3.fromRGB(255, 255, 80)}
    }
    
    local TabButtons = {}
    local CurrentTab = "⚔️ Aimbot"
    
    -- Контейнер для контента вкладок
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, -20, 1, -100)
    ContentFrame.Position = UDim2.new(0, 10, 0, 90)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    ContentFrame.BackgroundTransparency = 0.3
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Parent = MainFrame
    
    -- Функция создания переключателя
    local function CreateToggle(parent, text, default, yPos, callback)
        local ToggleBtn = Instance.new("TextButton")
        ToggleBtn.Name = text .. "Toggle"
        ToggleBtn.Size = UDim2.new(0, 250, 0, 35)
        ToggleBtn.Position = UDim2.new(0, 10, 0, yPos)
        ToggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 80)
        ToggleBtn.Text = text .. ": " .. (default and "ON" or "OFF")
        ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
        ToggleBtn.TextSize = 14
        ToggleBtn.Font = Enum.Font.Gotham
        ToggleBtn.Parent = parent
        
        local state = default
        ToggleBtn.MouseButton1Click:Connect(function()
            state = not state
            ToggleBtn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 80)
            ToggleBtn.Text = text .. ": " .. (state and "ON" or "OFF")
            if callback then callback(state) end
        end)
        
        return ToggleBtn
    end
    
    -- Функция создания слайдера
    local function CreateSlider(parent, text, min, max, default, yPos, callback)
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Name = text .. "Slider"
        SliderFrame.Size = UDim2.new(0, 250, 0, 40)
        SliderFrame.Position = UDim2.new(0, 10, 0, yPos)
        SliderFrame.BackgroundTransparency = 1
        SliderFrame.Parent = parent
        
        local Label = Instance.new("TextLabel")
        Label.Name = "Label"
        Label.Size = UDim2.new(1, 0, 0, 20)
        Label.BackgroundTransparency = 1
        Label.Text = text .. ": " .. default
        Label.TextColor3 = Color3.new(1, 1, 1)
        Label.TextSize = 14
        Label.Font = Enum.Font.Gotham
        Label.Parent = SliderFrame
        
        local SliderBg = Instance.new("Frame")
        SliderBg.Name = "SliderBg"
        SliderBg.Size = UDim2.new(1, 0, 0, 10)
        SliderBg.Position = UDim2.new(0, 0, 0, 25)
        SliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        SliderBg.Parent = SliderFrame
        
        local SliderFill = Instance.new("Frame")
        SliderFill.Name = "SliderFill"
        SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        SliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 200)
        SliderFill.Parent = SliderBg
        
        local value = default
        local dragging = false
        
        SliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        
        SliderBg.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mousePos = UserInputService:GetMouseLocation()
                local absPos = SliderBg.AbsolutePosition
                local size = SliderBg.AbsoluteSize.X
                local relative = math.clamp((mousePos.X - absPos.X) / size, 0, 1)
                
                value = min + (max - min) * relative
                SliderFill.Size = UDim2.new(relative, 0, 1, 0)
                Label.Text = text .. ": " .. math.floor(value)
                
                if callback then callback(math.floor(value)) end
            end
        end)
    end
    
    -- ========== ВКЛАДКА AIMBOT ==========
    local AimbotFrame = Instance.new("Frame")
    AimbotFrame.Name = "AimbotFrame"
    AimbotFrame.Size = UDim2.new(1, 0, 1, 0)
    AimbotFrame.BackgroundTransparency = 1
    AimbotFrame.Parent = ContentFrame
    AimbotFrame.Visible = true
    
    local AimbotSettings = {
        Enabled = true,
        FullScreen = true,
        Radius = 200,
        VisibleCheck = true,
        TeamCheck = true,
        Prediction = 0.15,
        HitPart = "Head"
    }
    
    CreateToggle(AimbotFrame, "Enable Aimbot", AimbotSettings.Enabled, 10, function(state)
        AimbotSettings.Enabled = state
    end)
    
    CreateToggle(AimbotFrame, "Full Screen Mode", AimbotSettings.FullScreen, 55, function(state)
        AimbotSettings.FullScreen = state
    end)
    
    CreateToggle(AimbotFrame, "Visible Check", AimbotSettings.VisibleCheck, 100, function(state)
        AimbotSettings.VisibleCheck = state
    end)
    
    CreateToggle(AimbotFrame, "Team Check", AimbotSettings.TeamCheck, 145, function(state)
        AimbotSettings.TeamCheck = state
    end)
    
    CreateSlider(AimbotFrame, "Aimbot Radius", 50, 500, AimbotSettings.Radius, 190, function(value)
        AimbotSettings.Radius = value
    end)
    
    CreateSlider(AimbotFrame, "Prediction", 0, 0.5, AimbotSettings.Prediction * 100, 240, function(value)
        AimbotSettings.Prediction = value / 100
    end)
    
    -- ========== ВКЛАДКА BOUNTY ==========
    local BountyFrame = Instance.new("Frame")
    BountyFrame.Name = "BountyFrame"
    BountyFrame.Size = UDim2.new(1, 0, 1, 0)
    BountyFrame.BackgroundTransparency = 1
    BountyFrame.Parent = ContentFrame
    BountyFrame.Visible = false
    
    local BountySettings = {
        Enabled = false,
        AutoFind = true,
        IgnoreTeams = true,
        AutoRespawn = true,
        SafeMode = true,
        Priority = "Low Health"
    }
    
    CreateToggle(BountyFrame, "Auto Bounty Farm", BountySettings.Enabled, 10, function(state)
        BountySettings.Enabled = state
        if state then StartBountyFarm() end
    end)
    
    CreateToggle(BountyFrame, "Ignore Teams", BountySettings.IgnoreTeams, 55, function(state)
        BountySettings.IgnoreTeams = state
    end)
    
    CreateToggle(BountyFrame, "Auto Respawn", BountySettings.AutoRespawn, 100, function(state)
        BountySettings.AutoRespawn = state
    end)
    
    CreateToggle(BountyFrame, "Safe Mode", BountySettings.SafeMode, 145, function(state)
        BountySettings.SafeMode = state
    end)
    
    -- ========== ВКЛАДКА BOSS ==========
    local BossFrame = Instance.new("Frame")
    BossFrame.Name = "BossFrame"
    BossFrame.Size = UDim2.new(1, 0, 1, 0)
    BossFrame.BackgroundTransparency = 1
    BossFrame.Parent = ContentFrame
    BossFrame.Visible = false
    
    local BossSettings = {
        Enabled = false,
        AutoKill = true,
        AutoCollect = true,
        IgnoreSmall = false,
        Priority = "Nearest"
    }
    
    CreateToggle(BossFrame, "Auto Boss Farm", BossSettings.Enabled, 10, function(state)
        BossSettings.Enabled = state
    end)
    
    CreateToggle(BossFrame, "Auto Collect Drops", BossSettings.AutoCollect, 55, function(state)
        BossSettings.AutoCollect = state
    end)
    
    CreateToggle(BossFrame, "Ignore Small Bosses", BossSettings.IgnoreSmall, 100, function(state)
        BossSettings.IgnoreSmall = state
    end)
    
    -- ========== ВКЛАДКА SETTINGS ==========
    local SettingsFrame = Instance.new("Frame")
    SettingsFrame.Name = "SettingsFrame"
    SettingsFrame.Size = UDim2.new(1, 0, 1, 0)
    SettingsFrame.BackgroundTransparency = 1
    SettingsFrame.Parent = ContentFrame
    SettingsFrame.Visible = false
    
    local GlobalSettings = {
        AntiBan = true,
        MenuKey = "Insert",
        AutoUpdate = true
    }
    
    CreateToggle(SettingsFrame, "Anti-Ban System", GlobalSettings.AntiBan, 10, function(state)
        GlobalSettings.AntiBan = state
        AntiBan.Enabled = state
    end)
    
    CreateToggle(SettingsFrame, "Auto Update", GlobalSettings.AutoUpdate, 55, function(state)
        GlobalSettings.AutoUpdate = state
    end)
    
    -- Создание кнопок вкладок
    for i, tab in ipairs(Tabs) do
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = tab.Name .. "Btn"
        TabBtn.Size = UDim2.new(0.25, 0, 1, 0)
        TabBtn.Position = UDim2.new((i-1) * 0.25, 0, 0, 0)
        TabBtn.BackgroundColor3 = tab.Color
        TabBtn.BackgroundTransparency = 0.3
        TabBtn.Text = tab.Name
        TabBtn.TextColor3 = Color3.new(1, 1, 1)
        TabBtn.TextSize = 14
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.Parent = TabFrame
        
        TabBtn.MouseButton1Click:Connect(function()
            CurrentTab = tab.Name
            AimbotFrame.Visible = (tab.Name == "⚔️ Aimbot")
            BountyFrame.Visible = (tab.Name == "💰 Bounty")
            BossFrame.Visible = (tab.Name == "👾 Boss")
            SettingsFrame.Visible = (tab.Name == "⚙️ Settings")
        end)
    end
    
    -- ========== ЛОГИКА АИМБОТА ==========
    local Aimbot = {
        Target = nil,
        
        GetClosest = function()
            local closest = nil
            local shortest = math.huge
            
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LP and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                    
                    -- Проверка команды
                    if AimbotSettings.TeamCheck and player.Team == LP.Team then
                        goto continue
                    end
                    
                    -- Проверка видимости
                    if AimbotSettings.VisibleCheck then
                        local ray = Ray.new(
                            LP.Character.Head.Position,
                            (player.Character.Head.Position - LP.Character.Head.Position).unit * 1000
                        )
                        local hit = workspace:FindPartOnRay(ray, LP.Character)
                        if hit and not hit:IsDescendantOf(player.Character) then
                            goto continue
                        end
                    end
                    
                    local targetPart = player.Character:FindFirstChild(AimbotSettings.HitPart) or player.Character.Head
                    if targetPart then
                        local dist = (LP.Character.Head.Position - targetPart.Position).magnitude
                        
                        if not AimbotSettings.FullScreen and dist > AimbotSettings.Radius then
                            goto continue
                        end
                        
                        if dist < shortest then
                            shortest = dist
                            closest = player
                        end
                    end
                    
                    ::continue::
                end
            end
            
            return closest
        end,
        
        Start = function()
            spawn(function()
                while wait(0.03) do
                    if AimbotSettings.Enabled and LP.Character and LP.Character:FindFirstChild("Humanoid") and LP.Character.Humanoid.Health > 0 then
                        local target = Aimbot.GetClosest()
                        if target then
                            local targetPart = target.Character:FindFirstChild(AimbotSettings.HitPart) or target.Character.Head
                            if targetPart then
                                -- Предсказание
                                local prediction = targetPart.Position + (target.Character.HumanoidRootPart.Velocity * AimbotSettings.Prediction)
                                
                                -- Поворот камеры
                                workspace.CurrentCamera.CFrame = CFrame.new(
                                    workspace.CurrentCamera.CFrame.Position,
                                    prediction
                                )
                            end
                        end
                    end
                end
            end)
        end
    }
    
    -- ========== ЛОГИКА АВТО БАУНТИ ==========
    function StartBountyFarm()
        spawn(function()
            while BountySettings.Enabled and wait(0.5) do
                if LP.Character and LP.Character:FindFirstChild("Humanoid") and LP.Character.Humanoid.Health > 0 then
                    
                    -- Поиск игроков с низким здоровьем
                    local targets = {}
                    
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LP and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                            
                            -- Проверка команд
                            if BountySettings.IgnoreTeams and player.Team == LP.Team then
                                goto skip
                            end
                            
                            local healthPercent = player.Character.Humanoid.Health / player.Character.Humanoid.MaxHealth
                            table.insert(targets, {
                                player = player,
                                health = healthPercent,
                                dist = (LP.Character.Head.Position - player.Character.Head.Position).magnitude
                            })
                            
                            ::skip::
                        end
                    end
                    
                    -- Сортировка по приоритету
                    if BountySettings.Priority == "Low Health" then
                        table.sort(targets, function(a, b) return a.health < b.health end)
                    else
                        table.sort(targets, function(a, b) return a.dist < b.dist end)
                    end
                    
                    -- Атака первой цели
                    if #targets > 0 and targets[1].health < 0.5 then
                        local target = targets[1].player
                        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                            LP.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 10)
                            
                            -- Активация аимбота
                            AimbotSettings.Enabled = true
                            AimbotSettings.Target = target
                        end
                    end
                end
            end
        end)
    end
    
    -- ========== ЗАПУСК ==========
    Aimbot.Start()
    AntiBan.Start()
    
    -- Горячая клавиша для открытия/закрытия
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Insert then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)
    
    -- Уведомление о загрузке
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "SorHub PvP",
        Text = "✅ Loaded successfully! Press INSERT to open menu",
        Duration = 3
    })
    
    print("✅ SorHub PvP loaded - Press INSERT for menu")
end