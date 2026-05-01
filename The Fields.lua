local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = "The Field script",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Playertab = Window:AddTab('Player')

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local speedgb = Playertab:AddLeftGroupbox('SpeedHack')

local walkSpeedConnection
local currentWalkSpeed = 16

speedgb:AddSlider('SpeedSlider', {
    Text = 'Speed:',
    Default = 16,
    Min = 16,
    Max = 100,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        currentWalkSpeed = Value
        if walkSpeedConnection then
            local character = Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = Value
            end
        end
    end
})

speedgb:AddToggle('SpeedToggle', {
    Text = 'Enable Speed',
    Default = false,
    Tooltip = 'Toggle speed hack',
    Callback = function(Value)
        if Value then
            walkSpeedConnection = RunService.Heartbeat:Connect(function()
                local character = Players.LocalPlayer.Character
                if character and character:FindFirstChild("Humanoid") then
                    character.Humanoid.WalkSpeed = currentWalkSpeed
                end
            end)
            
            local character = Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = currentWalkSpeed
            end
        else
            if walkSpeedConnection then
                walkSpeedConnection:Disconnect()
                walkSpeedConnection = nil
            end
            
            local character = Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = 16
            end
        end
    end
})

local flygb = Playertab:AddRightGroupbox('Fly')

local flyEnabled = false
local flyTween = nil
local flyConnection = nil
local currentFlySpeed = 40

flygb:AddSlider('FlySlider', {
    Text = 'Fly Speed:',
    Default = 40,
    Min = 16,
    Max = 100,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        currentFlySpeed = Value
    end
})

flygb:AddToggle('FlyOn', {
    Text = 'Fly',
    Default = false,
    Tooltip = 'Toggle fly',
    Callback = function(Value)
        local player = Players.LocalPlayer
        
        if Value then
            flyEnabled = true
            
            flyConnection = RunService.Heartbeat:Connect(function()
                if not flyEnabled then return end
                
                local character = player.Character
                if not character then return end
                
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if not humanoidRootPart then return end
                
                local camera = workspace.CurrentCamera
                local lookVector = camera.CFrame.LookVector
                local rightVector = camera.CFrame.RightVector
                
                local targetVelocity = Vector3.new(0, 0, 0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    targetVelocity = targetVelocity + lookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    targetVelocity = targetVelocity - lookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    targetVelocity = targetVelocity - rightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    targetVelocity = targetVelocity + rightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    targetVelocity = targetVelocity + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    targetVelocity = targetVelocity + Vector3.new(0, -1, 0)
                end
                
                if targetVelocity.Magnitude > 0 then
                    targetVelocity = targetVelocity.Unit * currentFlySpeed
                end
                
                if flyTween then
                    flyTween:Cancel()
                end
                
                local tweenInfo = TweenInfo.new(
                    0.1,
                    Enum.EasingStyle.Linear,
                    Enum.EasingDirection.Out
                )
                
                flyTween = TweenService:Create(humanoidRootPart, tweenInfo, {Velocity = targetVelocity})
                flyTween:Play()
            end)
            
        else
            flyEnabled = false
            
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            
            if flyTween then
                flyTween:Cancel()
                flyTween = nil
            end
            
            local character = player.Character
            if character then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end
})

flygb:AddLabel('Fly Hotkey'):AddKeyPicker('FlyKeybind', {
    Default = 'F',
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Toggle Fly',
    NoUI = false,
    
    Callback = function(Value)
        if Value then
            Toggles.FlyOn:SetValue(not Toggles.FlyOn.Value)
        end
    end,
    
    ChangedCallback = function(New)
        print('Fly keybind changed to:', New)
    end
})

local VTab = Window:AddTab("Visual")

local Ggb = VTab:AddLeftGroupbox("Grafic")

local fogConnection
local dayConnection

Ggb:AddToggle('NoFog', {
    Text = 'NoFog',
    Default = true,
    Tooltip = 'FogEnd 100000',
    Callback = function(Value)
        local lighting = game:GetService("Lighting")
        if Value then
            fogConnection = RunService.Heartbeat:Connect(function()
                lighting.FogEnd = 100000
                lighting.FogStart = 0
                lighting.FogColor = Color3.new(1, 1, 1)
            end)
            lighting.FogEnd = 100000
            lighting.FogStart = 0
            lighting.FogColor = Color3.new(1, 1, 1)
        else
            if fogConnection then
                fogConnection:Disconnect()
                fogConnection = nil
            end
            lighting.FogEnd = 100000
            lighting.FogStart = 100
            lighting.FogColor = Color3.new(0.5, 0.5, 0.5)
        end
    end
})

Ggb:AddToggle('AlwaysDay', {
    Text = 'AlwaysDay',
    Default = true,
    Tooltip = 'Always day',
    Callback = function(Value)
        local lighting = game:GetService("Lighting")
        if Value then
            dayConnection = RunService.Heartbeat:Connect(function()
                lighting.ClockTime = 14
                lighting.GeographicLatitude = 0
            end)
            lighting.ClockTime = 14
            lighting.GeographicLatitude = 0
        else
            if dayConnection then
                dayConnection:Disconnect()
                dayConnection = nil
            end
        end
    end
})

local ItemsGB = VTab:AddRightGroupbox("Items ESP")

local espEnabled = false
local espColor = Color3.new(1, 0, 0)
local espTransparency = 0.3
local espRainbow = false
local espDistance = 500
local espShowName = true
local espShowDistance = true
local highlightedItems = {}

local rainbowConnection

local function CreateItemHighlight(model)
    if not model:IsA("Model") then return end
    if highlightedItems[model] then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ItemHighlight"
    highlight.FillColor = espColor
    highlight.OutlineColor = Color3.new(1, 1, 0)
    highlight.FillTransparency = espTransparency
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = model
    highlight.Enabled = espEnabled
    highlight.Parent = model
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ItemNameTag"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 5, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = espDistance
    
    local adornee = model:FindFirstChild("HumanoidRootPart") or 
                   model:FindFirstChild("Head") or 
                   model:FindFirstChild("Torso") or
                   model.PrimaryPart or model
    
    if adornee then
        billboard.Adornee = adornee
    end
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = billboard
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "Name"
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = model.Name
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.TextScaled = false
    nameLabel.Visible = espShowName
    nameLabel.Parent = frame
    
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "Distance"
    distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "0m"
    distanceLabel.TextColor3 = Color3.new(1, 1, 1)
    distanceLabel.TextStrokeTransparency = 0
    distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.TextSize = 12
    distanceLabel.Visible = espShowDistance
    distanceLabel.Parent = frame
    
    billboard.Parent = model
    billboard.Enabled = espEnabled
    
    highlightedItems[model] = {
        Highlight = highlight,
        Billboard = billboard
    }
end

local function UpdateESP()
    if not espEnabled then return end
    
    local itemsFolder = workspace:FindFirstChild("Items")
    if not itemsFolder then return end
    
    for _, model in pairs(itemsFolder:GetChildren()) do
        if model:IsA("Model") and not highlightedItems[model] then
            CreateItemHighlight(model)
        end
    end
end

local function ClearESP()
    for model, esp in pairs(highlightedItems) do
        if esp.Highlight then esp.Highlight:Destroy() end
        if esp.Billboard then esp.Billboard:Destroy() end
    end
    highlightedItems = {}
end

ItemsGB:AddToggle('ESPEnabled', {
    Text = 'ESP ON/OFF',
    Default = false,
    Tooltip = 'Toggle Items ESP',
    Callback = function(Value)
        espEnabled = Value
        
        if Value then
            UpdateESP()
            
            local itemsFolder = workspace:FindFirstChild("Items")
            if itemsFolder then
                itemsFolder.ChildAdded:Connect(function(child)
                    if child:IsA("Model") then
                        task.wait(0.5)
                        if espEnabled then
                            CreateItemHighlight(child)
                        end
                    end
                end)
            end
        else
            ClearESP()
        end
    end
})

ItemsGB:AddLabel('ESP Color'):AddColorPicker('ESPColor', {
    Default = Color3.new(1, 0, 0),
    Title = 'ESP Color',
    Transparency = 0,
    
    Callback = function(Value)
        espColor = Value
        for model, esp in pairs(highlightedItems) do
            if esp.Highlight then
                esp.Highlight.FillColor = Value
            end
        end
    end
})

ItemsGB:AddToggle('ESPRainbow', {
    Text = 'Rainbow Color',
    Default = false,
    Tooltip = 'Toggle rainbow effect',
    Callback = function(Value)
        espRainbow = Value
        
        if Value then
            rainbowConnection = RunService.Heartbeat:Connect(function()
                if not espRainbow then return end
                
                local hue = tick() % 5 / 5
                local color = Color3.fromHSV(hue, 1, 1)
                
                for model, esp in pairs(highlightedItems) do
                    if esp.Highlight then
                        esp.Highlight.FillColor = color
                    end
                end
                
                espColor = color
            end)
        else
            if rainbowConnection then
                rainbowConnection:Disconnect()
                rainbowConnection = nil
            end
        end
    end
})

ItemsGB:AddSlider('ESPDistance', {
    Text = 'Distance',
    Default = 500,
    Min = 50,
    Max = 5000,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        espDistance = Value
        for model, esp in pairs(highlightedItems) do
            if esp.Billboard then
                esp.Billboard.MaxDistance = Value
            end
        end
    end
})

ItemsGB:AddSlider('ESPTransparency', {
    Text = 'Transparency',
    Default = 0.3,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = false,
    Callback = function(Value)
        espTransparency = Value
        for model, esp in pairs(highlightedItems) do
            if esp.Highlight then
                esp.Highlight.FillTransparency = Value
            end
        end
    end
})

ItemsGB:AddToggle('ESPShowName', {
    Text = 'Show Name',
    Default = true,
    Callback = function(Value)
        espShowName = Value
        for model, esp in pairs(highlightedItems) do
            if esp.Billboard and esp.Billboard.Frame then
                local nameLabel = esp.Billboard.Frame:FindFirstChild("Name")
                if nameLabel then
                    nameLabel.Visible = Value
                end
            end
        end
    end
})

ItemsGB:AddToggle('ESPShowDistance', {
    Text = 'Show Distance',
    Default = true,
    Callback = function(Value)
        espShowDistance = Value
        for model, esp in pairs(highlightedItems) do
            if esp.Billboard and esp.Billboard.Frame then
                local distanceLabel = esp.Billboard.Frame:FindFirstChild("Distance")
                if distanceLabel then
                    distanceLabel.Visible = Value
                end
            end
        end
    end
})

local PlayerESPGB = VTab:AddLeftGroupbox("NPC esp")

local playerEspEnabled = false
local playerEspColor = Color3.new(0, 1, 0)
local playerEspTransparency = 0.3
local playerEspRainbow = false
local playerEspDistance = 500
local playerShowName = true
local playerShowDistance = true
local playerShowHealth = true
local highlightedPlayers = {}

local playerRainbowConnection

local function CreatePlayerHighlight(character)
    if not character:IsA("Model") then return end
    if highlightedPlayers[character] then return end
    
    local player = Players:GetPlayerFromCharacter(character)
    if player and player == Players.LocalPlayer then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerHighlight"
    highlight.FillColor = playerEspColor
    highlight.OutlineColor = Color3.new(1, 1, 0)
    highlight.FillTransparency = playerEspTransparency
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = character
    highlight.Enabled = playerEspEnabled
    highlight.Parent = character
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "NPCESP"
    billboard.Size = UDim2.new(0, 200, 0, 80)
    billboard.StudsOffset = Vector3.new(0, 5, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = playerEspDistance
    
    if rootPart then
        billboard.Adornee = rootPart
    end
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = billboard
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "Name"
    nameLabel.Size = UDim2.new(1, 0, 0.3, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player and player.Name or character.Name
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.TextScaled = false
    nameLabel.Visible = playerShowName
    nameLabel.Parent = frame
    
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "Distance"
    distanceLabel.Size = UDim2.new(1, 0, 0.3, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.3, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "0m"
    distanceLabel.TextColor3 = Color3.new(1, 1, 1)
    distanceLabel.TextStrokeTransparency = 0
    distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.TextSize = 12
    distanceLabel.Visible = playerShowDistance
    distanceLabel.Parent = frame
    
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Name = "Health"
    healthLabel.Size = UDim2.new(1, 0, 0.3, 0)
    healthLabel.Position = UDim2.new(0, 0, 0.6, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "HP: 100/100"
    healthLabel.TextColor3 = Color3.new(1, 1, 1)
    healthLabel.TextStrokeTransparency = 0
    healthLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    healthLabel.Font = Enum.Font.Gotham
    healthLabel.TextSize = 12
    healthLabel.Visible = playerShowHealth
    healthLabel.Parent = frame
    
    billboard.Parent = character
    billboard.Enabled = playerEspEnabled
    
    highlightedPlayers[character] = {
        Highlight = highlight,
        Billboard = billboard,
        Player = player,
        Humanoid = humanoid
    }
end

local function UpdatePlayerESP()
    if not playerEspEnabled then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character then
            CreatePlayerHighlight(player.Character)
        end
    end
    
    local activeHumanoids = workspace:FindFirstChild("ActiveHumanoids")
    if activeHumanoids then
        for _, model in pairs(activeHumanoids:GetChildren()) do
            if model:IsA("Model") and not Players:GetPlayerFromCharacter(model) then
                CreatePlayerHighlight(model)
            end
        end
    end
end

local function ClearPlayerESP()
    for character, esp in pairs(highlightedPlayers) do
        if esp.Highlight then esp.Highlight:Destroy() end
        if esp.Billboard then esp.Billboard:Destroy() end
    end
    highlightedPlayers = {}
end

PlayerESPGB:AddToggle('PlayerESPEnabled', {
    Text = 'NPC ESP ON/OFF',
    Default = false,
    Tooltip = 'Toggle NPC ESP',
    Callback = function(Value)
        playerEspEnabled = Value
        
        if Value then
            UpdatePlayerESP()
            
            Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function(character)
                    task.wait(1)
                    if playerEspEnabled then
                        CreatePlayerHighlight(character)
                    end
                end)
            end)
            
            Players.PlayerRemoving:Connect(function(player)
                local character = player.Character
                if character and highlightedPlayers[character] then
                    if highlightedPlayers[character].Highlight then
                        highlightedPlayers[character].Highlight:Destroy()
                    end
                    if highlightedPlayers[character].Billboard then
                        highlightedPlayers[character].Billboard:Destroy()
                    end
                    highlightedPlayers[character] = nil
                end
            end)
            
            local activeHumanoids = workspace:FindFirstChild("ActiveHumanoids")
            if activeHumanoids then
                activeHumanoids.ChildAdded:Connect(function(child)
                    if child:IsA("Model") then
                        task.wait(0.5)
                        if playerEspEnabled then
                            CreatePlayerHighlight(child)
                        end
                    end
                end)
            end
        else
            ClearPlayerESP()
        end
    end
})

PlayerESPGB:AddLabel('NPC color'):AddColorPicker('PlayerESPColor', {
    Default = Color3.new(0, 1, 0),
    Title = 'NPC esp color',
    Transparency = 0,
    
    Callback = function(Value)
        playerEspColor = Value
        for character, esp in pairs(highlightedPlayers) do
            if esp.Highlight then
                esp.Highlight.FillColor = Value
            end
        end
    end
})

PlayerESPGB:AddToggle('PlayerESPRainbow', {
    Text = 'Rainbow Color',
    Default = false,
    Tooltip = 'Toggle rainbow effect for NPC',
    Callback = function(Value)
        playerEspRainbow = Value
        
        if Value then
            playerRainbowConnection = RunService.Heartbeat:Connect(function()
                if not playerEspRainbow then return end
                
                local hue = tick() % 5 / 5
                local color = Color3.fromHSV(hue, 1, 1)
                
                for character, esp in pairs(highlightedPlayers) do
                    if esp.Highlight then
                        esp.Highlight.FillColor = color
                    end
                end
                
                playerEspColor = color
            end)
        else
            if playerRainbowConnection then
                playerRainbowConnection:Disconnect()
                playerRainbowConnection = nil
            end
        end
    end
})

PlayerESPGB:AddSlider('PlayerESPDistance', {
    Text = 'Distance',
    Default = 500,
    Min = 50,
    Max = 5000,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        playerEspDistance = Value
        for character, esp in pairs(highlightedPlayers) do
            if esp.Billboard then
                esp.Billboard.MaxDistance = Value
            end
        end
    end
})

PlayerESPGB:AddSlider('PlayerESPTransparency', {
    Text = 'Transparency',
    Default = 0.3,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = false,
    Callback = function(Value)
        playerEspTransparency = Value
        for character, esp in pairs(highlightedPlayers) do
            if esp.Highlight then
                esp.Highlight.FillTransparency = Value
            end
        end
    end
})

PlayerESPGB:AddToggle('PlayerShowName', {
    Text = 'Show Name',
    Default = true,
    Callback = function(Value)
        playerShowName = Value
        for character, esp in pairs(highlightedPlayers) do
            if esp.Billboard then
                local nameLabel = esp.Billboard.Frame:FindFirstChild("Name")
                if nameLabel then
                    nameLabel.Visible = Value
                end
            end
        end
    end
})

PlayerESPGB:AddToggle('PlayerShowDistance', {
    Text = 'Show Distance',
    Default = true,
    Callback = function(Value)
        playerShowDistance = Value
        for character, esp in pairs(highlightedPlayers) do
            if esp.Billboard then
                local distanceLabel = esp.Billboard.Frame:FindFirstChild("Distance")
                if distanceLabel then
                    distanceLabel.Visible = Value
                end
            end
        end
    end
})

PlayerESPGB:AddToggle('PlayerShowHealth', {
    Text = 'Show Health',
    Default = true,
    Callback = function(Value)
        playerShowHealth = Value
        for character, esp in pairs(highlightedPlayers) do
            if esp.Billboard then
                local healthLabel = esp.Billboard.Frame:FindFirstChild("Health")
                if healthLabel then
                    healthLabel.Visible = Value
                end
            end
        end
    end
})

local AimbentGBox = VTab:AddRightGroupbox("Ambient")

local ambientEnabled = false
local ambientColor = Color3.new(1, 0, 0)
local ambientConnection

AimbentGBox:AddToggle('AimbentToggle', {
    Text = 'Ambient ON/OFF',
    Default = false,
    Tooltip = 'Toggle ambient color',
    Callback = function(Value)
        ambientEnabled = Value
        local lighting = game:GetService("Lighting")
        
        if Value then
            ambientConnection = RunService.Heartbeat:Connect(function()
                if not ambientEnabled then return end
                lighting.OutdoorAmbient = ambientColor
                lighting.Ambient = ambientColor
            end)
            lighting.OutdoorAmbient = ambientColor
            lighting.Ambient = ambientColor
        else
            if ambientConnection then
                ambientConnection:Disconnect()
                ambientConnection = nil
            end
            lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
            lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
        end
    end
})

AimbentGBox:AddLabel('Ambient Color'):AddColorPicker('AimbentColor', {
    Default = Color3.new(1, 0, 0),
    Title = 'Ambient Color',
    Transparency = 0,
    
    Callback = function(Value)
        ambientColor = Value
        if ambientEnabled then
            local lighting = game:GetService("Lighting")
            lighting.OutdoorAmbient = Value
            lighting.Ambient = Value
        end
    end
})

RunService.RenderStepped:Connect(function()
    if espEnabled then
        for model, esp in pairs(highlightedItems) do
            if model and model.Parent then
                if esp.Billboard and esp.Billboard.Adornee then
                    local camera = workspace.CurrentCamera
                    local adorneePos = esp.Billboard.Adornee.Position
                    local distance = (camera.CFrame.Position - adorneePos).Magnitude
                    
                    esp.Billboard.Enabled = distance <= espDistance
                    esp.Highlight.Enabled = distance <= espDistance
                    
                    if esp.Billboard.Frame then
                        local distanceLabel = esp.Billboard.Frame:FindFirstChild("Distance")
                        if distanceLabel and espShowDistance then
                            distanceLabel.Text = math.floor(distance) .. "m"
                        end
                    end
                end
            else
                if esp.Highlight then esp.Highlight:Destroy() end
                if esp.Billboard then esp.Billboard:Destroy() end
                highlightedItems[model] = nil
            end
        end
    end
    
    if playerEspEnabled then
        for character, esp in pairs(highlightedPlayers) do
            if character and character.Parent then
                local camera = workspace.CurrentCamera
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                
                if rootPart and esp.Billboard then
                    local distance = (camera.CFrame.Position - rootPart.Position).Magnitude
                    
                    esp.Billboard.Enabled = distance <= playerEspDistance
                    esp.Highlight.Enabled = distance <= playerEspDistance
                    
                    if esp.Billboard.Frame then
                        local distanceLabel = esp.Billboard.Frame:FindFirstChild("Distance")
                        if distanceLabel and playerShowDistance then
                            distanceLabel.Text = math.floor(distance) .. "m"
                        end
                        
                        local healthLabel = esp.Billboard.Frame:FindFirstChild("Health")
                        if healthLabel and playerShowHealth and esp.Humanoid then
                            healthLabel.Text = "HP: " .. math.floor(esp.Humanoid.Health) .. "/" .. math.floor(esp.Humanoid.MaxHealth)
                            healthLabel.TextColor3 = Color3.fromHSV(esp.Humanoid.Health / esp.Humanoid.MaxHealth * 0.3, 1, 1)
                        end
                    end
                end
            else
                if esp.Highlight then esp.Highlight:Destroy() end
                if esp.Billboard then esp.Billboard:Destroy() end
                highlightedPlayers[character] = nil
            end
        end
    end
end)

local UITab = Window:AddTab('UI Settings')
local MenuGroup = UITab:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() 
    if fogConnection then fogConnection:Disconnect() end
    if dayConnection then dayConnection:Disconnect() end
    if rainbowConnection then rainbowConnection:Disconnect() end
    if playerRainbowConnection then playerRainbowConnection:Disconnect() end
    if ambientConnection then ambientConnection:Disconnect() end
    if walkSpeedConnection then walkSpeedConnection:Disconnect() end
    ClearESP()
    ClearPlayerESP()
    Library:Unload() 
end)

MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'LeftAlt', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('TheFieldScript')
SaveManager:SetFolder('TheFieldScript')

SaveManager:BuildConfigSection(UITab)
ThemeManager:ApplyToTab(UITab)

SaveManager:LoadAutoloadConfig()

Library:SetWatermarkVisibility(true)

local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter = FrameCounter + 1
    
    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
    end
    
    Library:SetWatermark(('The Field Script | %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ))
end)

Library:OnUnload(function()
    WatermarkConnection:Disconnect()
    if fogConnection then fogConnection:Disconnect() end
    if dayConnection then dayConnection:Disconnect() end
    if rainbowConnection then rainbowConnection:Disconnect() end
    if playerRainbowConnection then playerRainbowConnection:Disconnect() end
    if ambientConnection then ambientConnection:Disconnect() end
    if walkSpeedConnection then walkSpeedConnection:Disconnect() end
    ClearESP()
    ClearPlayerESP()
    print('Unloaded!')
    Library.Unloaded = true
end)
