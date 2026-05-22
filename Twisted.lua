local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Qanuir/orion-ui/refs/heads/main/source.lua"))()

local Window = OrionLib:MakeWindow({
    Name = "Twisted",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionFlySpeed",
    IntroEnabled = true,
    IntroText = "Likegenm Script",
    IntroIcon = "rbxassetid://4483345998"
})

local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local VisualTab = Window:MakeTab({
    Name = "Visuals",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local TeleportTab = Window:MakeTab({
    Name = "Teleports",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local SettingsTab = Window:MakeTab({
    Name = "Settings",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")

_G.PositionCollector = _G.PositionCollector or nil

local flyEnabled = false
local flySpeed = 200
local flyTween = nil
local flyConnection = nil

MainTab:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = function(v)
        flyEnabled = v
        if flyEnabled then
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            flyConnection = RunService.Heartbeat:Connect(function()
                if not flyEnabled then return end
                local dir = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir += Vector3.new(0, -1, 0) end
                local vel = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero
                if flyTween then flyTween:Cancel() end
                flyTween = TweenService:Create(hrp, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {Velocity = vel})
                flyTween:Play()
            end)
        else
            if flyTween then flyTween:Cancel() flyTween = nil end
            if flyConnection then flyConnection:Disconnect() flyConnection = nil end
            local char = LocalPlayer.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.Velocity = Vector3.zero end
            end
        end
    end
})

MainTab:AddSlider({
    Name = "Fly Speed",
    Min = 100,
    Max = 1000,
    Default = 200,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(v)
        flySpeed = v
    end
})

local speedHackEnabled = false
local speedHackValue = 50
local speedHackConnection = nil

MainTab:AddToggle({
    Name = "SpeedHack",
    Default = false,
    Callback = function(v)
        speedHackEnabled = v
        if speedHackEnabled then
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            
            speedHackConnection = RunService.Heartbeat:Connect(function()
                if not speedHackEnabled then return end
                local char = LocalPlayer.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                local lookVector = Camera.CFrame.LookVector
                local rightVector = Camera.CFrame.RightVector
                local mv = Vector3.zero
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then mv += Vector3.new(lookVector.X, 0, lookVector.Z).Unit end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then mv -= Vector3.new(lookVector.X, 0, lookVector.Z).Unit end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then mv -= Vector3.new(rightVector.X, 0, rightVector.Z).Unit end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then mv += Vector3.new(rightVector.X, 0, rightVector.Z).Unit end
                
                if mv.Magnitude > 0 then
                    hrp.Velocity = Vector3.new(mv.X * speedHackValue, hrp.Velocity.Y, mv.Z * speedHackValue)
                end
            end)
        else
            if speedHackConnection then
                speedHackConnection:Disconnect()
                speedHackConnection = nil
            end
        end
    end
})

MainTab:AddSlider({
    Name = "SpeedHack Speed",
    Min = 10,
    Max = 500,
    Default = 50,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(v)
        speedHackValue = v
    end
})

local infJumpsEnabled = false
local infJumpsConnection = nil

MainTab:AddToggle({
    Name = "Inf Jumps",
    Default = false,
    Callback = function(v)
        infJumpsEnabled = v
        if infJumpsEnabled then
            infJumpsConnection = UserInputService.JumpRequest:Connect(function()
                if not infJumpsEnabled then return end
                local char = LocalPlayer.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)
            end)
        else
            if infJumpsConnection then
                infJumpsConnection:Disconnect()
                infJumpsConnection = nil
            end
        end
    end
})

local noclipEnabled = false
local noclipConnection = nil

MainTab:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(v)
        noclipEnabled = v
        if noclipEnabled then
            noclipConnection = RunService.Stepped:Connect(function()
                if not noclipEnabled then return end
                local char = LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
        end
    end
})

local jesusEnabled = false

local function setWaterCollide(state)
    local waterTable = workspace:FindFirstChild("map_related")
    if waterTable then
        waterTable = waterTable:FindFirstChild("water_table")
        if waterTable then
            for _, v in ipairs(waterTable:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = state
                end
            end
        end
    end
end

MainTab:AddToggle({
    Name = "Jesus",
    Default = false,
    Callback = function(v)
        jesusEnabled = v
        if jesusEnabled then
            setWaterCollide(true)
        else
            setWaterCollide(false)
        end
    end
})

local gravityEnabled = false
local gravityValue = 196.2

MainTab:AddToggle({
    Name = "Gravity",
    Default = false,
    Callback = function(v)
        gravityEnabled = v
        if gravityEnabled then
            workspace.Gravity = gravityValue
        else
            workspace.Gravity = 196.2
        end
    end
})

MainTab:AddSlider({
    Name = "Gravity Value",
    Min = 10,
    Max = 196.2,
    Default = 196.2,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Gravity",
    Callback = function(v)
        gravityValue = v
        if gravityEnabled then
            workspace.Gravity = v
        end
    end
})

local spinBotEnabled = false
local spinBotSpeed = 10
local spinBotConnection = nil

MainTab:AddToggle({
    Name = "SpinBot",
    Default = false,
    Callback = function(v)
        spinBotEnabled = v
        if spinBotEnabled then
            spinBotConnection = RunService.Heartbeat:Connect(function()
                if not spinBotEnabled then return end
                local char = LocalPlayer.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(spinBotSpeed), 0)
            end)
        else
            if spinBotConnection then
                spinBotConnection:Disconnect()
                spinBotConnection = nil
            end
        end
    end
})

MainTab:AddSlider({
    Name = "Spin Speed",
    Min = 1,
    Max = 50,
    Default = 10,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(v)
        spinBotSpeed = v
    end
})

local vehicleFlyEnabled = false
local vehicleFlySpeed = 200
local vehicleFlyConnection = nil

MainTab:AddToggle({
    Name = "Vehicle Fly",
    Default = false,
    Callback = function(v)
        vehicleFlyEnabled = v
        if vehicleFlyEnabled then
            vehicleFlyConnection = RunService.Heartbeat:Connect(function()
                if not vehicleFlyEnabled then return end
                
                local char = LocalPlayer.Character
                if not char then return end
                
                local primaryPart = char.PrimaryPart or char:FindFirstChild("HumanoidRootPart")
                if not primaryPart then return end
                
                local dir = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir += Vector3.new(0, -1, 0) end
                
                if dir.Magnitude > 0 then
                    primaryPart.Velocity = dir.Unit * vehicleFlySpeed
                end
                
                local cameraLook = Vector3.new(Camera.CFrame.LookVector.X, 0, Camera.CFrame.LookVector.Z)
                if cameraLook.Magnitude > 0 then
                    primaryPart.CFrame = CFrame.new(primaryPart.Position, primaryPart.Position + cameraLook.Unit)
                end
            end)
        else
            if vehicleFlyConnection then
                vehicleFlyConnection:Disconnect()
                vehicleFlyConnection = nil
            end
        end
    end
})

MainTab:AddSlider({
    Name = "Vehicle Fly Speed",
    Min = 100,
    Max = 1000,
    Default = 200,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(v)
        vehicleFlySpeed = v
    end
})

local vehicleTurboEnabled = false
local vehicleTurboSpeed = 100
local vehicleTurboConnection = nil

MainTab:AddToggle({
    Name = "Vehicle Turbo",
    Default = false,
    Callback = function(v)
        vehicleTurboEnabled = v
        if vehicleTurboEnabled then
            vehicleTurboConnection = RunService.Heartbeat:Connect(function()
                if not vehicleTurboEnabled then return end
                
                local char = LocalPlayer.Character
                if not char then return end
                
                local primaryPart = char.PrimaryPart or char:FindFirstChild("HumanoidRootPart")
                if not primaryPart then return end
                
                local lookVector = Camera.CFrame.LookVector
                local rightVector = Camera.CFrame.RightVector
                local mv = Vector3.zero
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then mv += Vector3.new(lookVector.X, 0, lookVector.Z).Unit end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then mv -= Vector3.new(lookVector.X, 0, lookVector.Z).Unit end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then mv -= Vector3.new(rightVector.X, 0, rightVector.Z).Unit end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then mv += Vector3.new(rightVector.X, 0, rightVector.Z).Unit end
                
                if mv.Magnitude > 0 then
                    primaryPart.Velocity = Vector3.new(mv.X * vehicleTurboSpeed, 0, mv.Z * vehicleTurboSpeed)
                end
                
                local cameraLook = Vector3.new(Camera.CFrame.LookVector.X, 0, Camera.CFrame.LookVector.Z)
                if cameraLook.Magnitude > 0 then
                    primaryPart.CFrame = CFrame.new(primaryPart.Position, primaryPart.Position + cameraLook.Unit)
                end
            end)
        else
            if vehicleTurboConnection then
                vehicleTurboConnection:Disconnect()
                vehicleTurboConnection = nil
            end
        end
    end
})

MainTab:AddSlider({
    Name = "Vehicle Turbo Speed",
    Min = 50,
    Max = 500,
    Default = 100,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(v)
        vehicleTurboSpeed = v
    end
})

local function getProbes()
    local probes = {}
    local probesFolder = workspace:FindFirstChild("player_related")
    if probesFolder then
        local probesContainer = probesFolder:FindFirstChild("probes")
        if probesContainer then
            local userId = LocalPlayer.UserId
            for _, probe in ipairs(probesContainer:GetChildren()) do
                if probe.Name == tostring(userId) then
                    table.insert(probes, probe.Name)
                end
            end
        end
    end
    return probes
end

local function getProbeObjects()
    local probes = {}
    local probesFolder = workspace:FindFirstChild("player_related")
    if probesFolder then
        local probesContainer = probesFolder:FindFirstChild("probes")
        if probesContainer then
            local userId = LocalPlayer.UserId
            for _, probe in ipairs(probesContainer:GetChildren()) do
                if probe.Name == tostring(userId) then
                    table.insert(probes, probe)
                end
            end
        end
    end
    return probes
end

local function teleportToProbe(probeName)
    local probesFolder = workspace:FindFirstChild("player_related")
    if probesFolder then
        local probesContainer = probesFolder:FindFirstChild("probes")
        if probesContainer then
            local probe = probesContainer:FindFirstChild(probeName)
            if probe then
                local myChar = LocalPlayer.Character
                if myChar then
                    local hrp = myChar:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local targetPos = probe:GetPivot().Position
                        hrp.CFrame = CFrame.new(targetPos)
                    end
                end
            end
        end
    end
end

local function collectProbe(probeName)
    local probesFolder = workspace:FindFirstChild("player_related")
    if probesFolder then
        local probesContainer = probesFolder:FindFirstChild("probes")
        if probesContainer then
            local probe = probesContainer:FindFirstChild(probeName)
            if probe then
                local myChar = LocalPlayer.Character
                if not myChar then return end
                local hrp = myChar:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                local savedPos = hrp.CFrame
                _G.PositionCollector = savedPos
                
                local targetPos = probe:GetPivot().Position
                hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0))
                
                task.wait(0.5)
                
                local promptPart = probe:FindFirstChild("PromptPart")
                if promptPart then
                    local prompt = promptPart:FindFirstChild("Prompt")
                    if prompt then
                        fireproximityprompt(prompt)
                    end
                end
                
                task.wait(0.5)
                
                hrp.CFrame = savedPos
            end
        end
    end
end

local probesDropdown = MainTab:AddDropdown({
    Name = "Probes",
    Default = "",
    Options = getProbes(),
    Callback = function(v) end
})

MainTab:AddButton({
    Name = "Teleport to Probe",
    Callback = function()
        local selectedProbe = probesDropdown.Value
        if selectedProbe and selectedProbe ~= "" then
            teleportToProbe(selectedProbe)
        end
    end
})

MainTab:AddButton({
    Name = "Collect Probe",
    Callback = function()
        local selectedProbe = probesDropdown.Value
        if selectedProbe and selectedProbe ~= "" then
            collectProbe(selectedProbe)
        end
    end
})

MainTab:AddButton({
    Name = "Refresh Probes",
    Callback = function()
        probesDropdown:Refresh(getProbes(), true)
    end
})

VisualTab:AddToggle({
    Name = "Fullbright",
    Default = false,
    Callback = function(v)
        if v then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = 3
            Lighting.ClockTime = 14
            Lighting.FogEnd = 999999
            Lighting.FogColor = Color3.fromRGB(255, 255, 255)
            Lighting.GlobalShadows = false
            Lighting.Outlines = false
            Lighting.ExposureCompensation = 1
        else
            Lighting.Ambient = Color3.fromRGB(0, 0, 0)
            Lighting.OutdoorAmbient = Color3.fromRGB(105, 105, 105)
            Lighting.Brightness = 1
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.FogColor = Color3.fromRGB(192, 192, 192)
            Lighting.GlobalShadows = true
            Lighting.Outlines = true
            Lighting.ExposureCompensation = 0
        end
    end
})

VisualTab:AddSlider({
    Name = "FOV",
    Min = 70,
    Max = 120,
    Default = 70,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "FOV",
    Callback = function(v)
        Camera.FieldOfView = v
    end
})

local velocityNotifyEnabled = false
local lastNotify = 0

VisualTab:AddToggle({
    Name = "Player Velocity",
    Default = false,
    Callback = function(v)
        velocityNotifyEnabled = v
    end
})

task.spawn(function()
    while true do
        if velocityNotifyEnabled then
            local char = LocalPlayer.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local vel = hrp.Velocity
                    local speed = math.floor(vel.Magnitude)
                    local vertSpeed = math.floor(vel.Y)
                    
                    if tick() - lastNotify > 1 then
                        lastNotify = tick()
                        OrionLib:MakeNotification({
                            Name = "Velocity",
                            Content = "Speed: " .. speed .. " | Vertical: " .. vertSpeed,
                            Time = 2
                        })
                    end
                end
            end
        end
        task.wait(1)
    end
end)

local probesESPEnabled = false
local probesESPObjects = {}
local probesESPConnection = nil

local function createProbeESP(probe)
    local highlight = Instance.new("Highlight")
    highlight.Name = "ProbeESP"
    highlight.FillColor = Color3.fromRGB(255, 255, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    highlight.OutlineTransparency = 0
    highlight.Adornee = probe
    highlight.Parent = probe
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ProbeNameTag"
    billboard.Size = UDim2.new(4, 0, 1, 0)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = probe
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "Probe"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 18
    textLabel.Parent = billboard
    
    local tracerLine = Drawing.new("Line")
    tracerLine.Color = Color3.fromRGB(255, 255, 0)
    tracerLine.Thickness = 1
    tracerLine.Transparency = 0.7
    tracerLine.Visible = true
    
    table.insert(probesESPObjects, {
        Probe = probe,
        Highlight = highlight,
        Billboard = billboard,
        TracerLine = tracerLine
    })
end

local function removeProbeESP(data)
    if data.Highlight then data.Highlight:Destroy() end
    if data.Billboard then data.Billboard:Destroy() end
    if data.TracerLine then data.TracerLine:Remove() end
end

local function clearAllProbesESP()
    for _, data in ipairs(probesESPObjects) do
        removeProbeESP(data)
    end
    probesESPObjects = {}
end

local function updateProbesESP()
    for _, data in ipairs(probesESPObjects) do
        if data.TracerLine and data.Probe and data.Probe.Parent then
            local probePos = data.Probe:GetPivot().Position
            local screenPos, onScreen = Camera:WorldToViewportPoint(probePos)
            
            if onScreen then
                data.TracerLine.Visible = true
                data.TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                data.TracerLine.To = Vector2.new(screenPos.X, screenPos.Y)
            else
                data.TracerLine.Visible = false
            end
        end
    end
end

local function refreshProbesESP()
    clearAllProbesESP()
    if probesESPEnabled then
        local probes = getProbeObjects()
        for _, probe in ipairs(probes) do
            createProbeESP(probe)
        end
    end
end

VisualTab:AddParagraph("Probes ESP", "")

VisualTab:AddToggle({
    Name = "Probes ESP",
    Default = false,
    Callback = function(v)
        probesESPEnabled = v
        if v then
            refreshProbesESP()
            probesESPConnection = RunService.RenderStepped:Connect(function()
                updateProbesESP()
            end)
        else
            clearAllProbesESP()
            if probesESPConnection then
                probesESPConnection:Disconnect()
                probesESPConnection = nil
            end
        end
    end
})

VisualTab:AddButton({
    Name = "Refresh Probes ESP",
    Callback = function()
        refreshProbesESP()
    end
})

local function getPrimaryPart()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char.PrimaryPart or char:FindFirstChild("HumanoidRootPart")
end

local function getPlayerNames()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(names, p.Name)
        end
    end
    return names
end

local vehicleTeleportSpeed = 500
local vehicleTeleportConnection = nil
local vehicleTeleportActive = false
local vehicleTeleportTarget = nil

local function startVehicleTeleport(targetPos)
    if vehicleTeleportConnection then
        vehicleTeleportConnection:Disconnect()
    end
    
    local part = getPrimaryPart()
    if not part then return end
    
    vehicleTeleportActive = true
    vehicleTeleportTarget = targetPos
    
    vehicleTeleportConnection = RunService.Heartbeat:Connect(function()
        if not vehicleTeleportActive then
            vehicleTeleportConnection:Disconnect()
            vehicleTeleportConnection = nil
            return
        end
        
        local currentPart = getPrimaryPart()
        if not currentPart then return end
        
        local direction = (vehicleTeleportTarget - currentPart.Position)
        local distance = direction.Magnitude
        
        if distance < 10 then
            currentPart.Velocity = Vector3.zero
            vehicleTeleportActive = false
            vehicleTeleportConnection:Disconnect()
            vehicleTeleportConnection = nil
        else
            local lookDir = Vector3.new(direction.X, 0, direction.Z)
            if lookDir.Magnitude > 0 then
                currentPart.CFrame = CFrame.new(currentPart.Position, currentPart.Position + lookDir.Unit)
            end
            
            currentPart.Velocity = direction.Unit * vehicleTeleportSpeed
        end
    end)
end

local cities = {
    ["Hazelton"] = Vector3.new(3530.361083984375, 47.397972106933594, -12934.0654296875),
    ["Prior Lake"] = Vector3.new(832.2999877929688, 22.198026657104492, 3563.01953125),
    ["Starbuck"] = Vector3.new(483.1630859375, 56.198020935058594, 17157.279296875),
    ["Hibbing"] = Vector3.new(-9458.9658203125, 22.177297592163086, 7043.642578125),
    ["Wadena"] = Vector3.new(17727.73828125, 60.198020935058594, -15855.8994140625)
}

local cityNames = {}
for name, _ in pairs(cities) do
    table.insert(cityNames, name)
end

TeleportTab:AddParagraph("Player Teleports", "")

local teleportPlayerDropdown = TeleportTab:AddDropdown({
    Name = "Select Player",
    Default = "",
    Options = getPlayerNames(),
    Callback = function(v) end
})

TeleportTab:AddButton({
    Name = "Teleport to Player",
    Callback = function()
        local targetName = teleportPlayerDropdown.Value
        if targetName and targetName ~= "" then
            local target = Players:FindFirstChild(targetName)
            if target and target.Character then
                local targetHrp = target.Character:FindFirstChild("HumanoidRootPart")
                if targetHrp then
                    local part = getPrimaryPart()
                    if part then
                        part.CFrame = targetHrp.CFrame
                    end
                end
            end
        end
    end
})

TeleportTab:AddButton({
    Name = "Vehicle TP to Player",
    Callback = function()
        local targetName = teleportPlayerDropdown.Value
        if targetName and targetName ~= "" then
            local target = Players:FindFirstChild(targetName)
            if target and target.Character then
                local targetHrp = target.Character:FindFirstChild("HumanoidRootPart")
                if targetHrp then
                    startVehicleTeleport(targetHrp.Position)
                end
            end
        end
    end
})

TeleportTab:AddButton({
    Name = "Refresh Players",
    Callback = function()
        teleportPlayerDropdown:Refresh(getPlayerNames(), true)
    end
})

TeleportTab:AddParagraph("Cities Teleports", "")

local citiesDropdown = TeleportTab:AddDropdown({
    Name = "Select City",
    Default = "",
    Options = cityNames,
    Callback = function(v) end
})

TeleportTab:AddButton({
    Name = "Teleport to City",
    Callback = function()
        local cityName = citiesDropdown.Value
        if cityName and cityName ~= "" and cities[cityName] then
            local part = getPrimaryPart()
            if part then
                part.CFrame = CFrame.new(cities[cityName])
            end
        end
    end
})

TeleportTab:AddButton({
    Name = "Vehicle TP to City",
    Callback = function()
        local cityName = citiesDropdown.Value
        if cityName and cityName ~= "" and cities[cityName] then
            startVehicleTeleport(cities[cityName])
        end
    end
})

TeleportTab:AddParagraph("Vehicle Teleport", "")

TeleportTab:AddSlider({
    Name = "Vehicle TP Speed",
    Min = 100,
    Max = 5000,
    Default = 500,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 10,
    ValueName = "Speed",
    Callback = function(v)
        vehicleTeleportSpeed = v
    end
})

TeleportTab:AddButton({
    Name = "Stop Vehicle Teleport",
    Callback = function()
        vehicleTeleportActive = false
        if vehicleTeleportConnection then
            vehicleTeleportConnection:Disconnect()
            vehicleTeleportConnection = nil
        end
        local part = getPrimaryPart()
        if part then
            part.Velocity = Vector3.zero
        end
    end
})

local hudEnabled = false
local hudUpdateConnection = nil

local function createHUD()
    local gui = gethui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LikegenmHUD"
    screenGui.Parent = gui
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(0, 400, 0, 60)
    title.Position = UDim2.new(1, -400, 0, 10)
    title.Text = "Likegenm"
    title.TextColor3 = Color3.fromRGB(255, 0, 255)
    title.TextSize = 44
    title.Font = Enum.Font.SourceSansBold
    title.BackgroundTransparency = 1
    title.TextXAlignment = Enum.TextXAlignment.Right
    title.RichText = true
    title.Parent = screenGui
    
    local frame = Instance.new("Frame")
    frame.Name = "FunctionsFrame"
    frame.Size = UDim2.new(0, 200, 0, 50)
    frame.Position = UDim2.new(1, -200, 0, 75)
    frame.BackgroundTransparency = 0.85
    frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local functionsLabel = Instance.new("TextLabel")
    functionsLabel.Name = "Functions"
    functionsLabel.Size = UDim2.new(1, 0, 1, 0)
    functionsLabel.Position = UDim2.new(0, 0, 0, 0)
    functionsLabel.Text = ""
    functionsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    functionsLabel.TextSize = 24
    functionsLabel.Font = Enum.Font.SourceSansSemibold
    functionsLabel.BackgroundTransparency = 1
    functionsLabel.TextXAlignment = Enum.TextXAlignment.Right
    functionsLabel.TextYAlignment = Enum.TextYAlignment.Center
    functionsLabel.RichText = true
    functionsLabel.Parent = frame
    
    return screenGui, functionsLabel, frame, title
end

local function updateHUD()
    local screenGui = gethui():FindFirstChild("LikegenmHUD")
    
    if not hudEnabled then
        if screenGui then
            screenGui:Destroy()
        end
        return
    end
    
    if not screenGui then
        createHUD()
        screenGui = gethui():FindFirstChild("LikegenmHUD")
    end
    
    local title = screenGui:FindFirstChild("Title")
    local titleHue = tick() % 5 / 5
    local titleColor = Color3.fromHSV(titleHue, 1, 1)
    title.Text = string.format('<font color="rgb(%d,%d,%d)">Likegenm</font>', titleColor.R * 255, titleColor.G * 255, titleColor.B * 255)
    
    local enabledFunctions = {}
    
    if flyEnabled then table.insert(enabledFunctions, "Fly|") end
    if speedHackEnabled then table.insert(enabledFunctions, "SpeedHack|") end
    if infJumpsEnabled then table.insert(enabledFunctions, "Inf Jumps|") end
    if noclipEnabled then table.insert(enabledFunctions, "Noclip|") end
    if jesusEnabled then table.insert(enabledFunctions, "Jesus|") end
    if gravityEnabled then table.insert(enabledFunctions, "Gravity|") end
    if spinBotEnabled then table.insert(enabledFunctions, "SpinBot|") end
    if vehicleFlyEnabled then table.insert(enabledFunctions, "Vehicle Fly|") end
    if vehicleTurboEnabled then table.insert(enabledFunctions, "Vehicle Turbo|") end
    if probesESPEnabled then table.insert(enabledFunctions, "Probes ESP|") end
    
    local frame = screenGui:FindFirstChild("FunctionsFrame")
    local functionsLabel = frame:FindFirstChild("Functions")
    
    if #enabledFunctions > 0 then
        local rainbowColors = {}
        for i, name in ipairs(enabledFunctions) do
            local hue = (tick() * 0.5 + i * 0.15) % 5 / 5
            local color = Color3.fromHSV(hue, 1, 1)
            table.insert(rainbowColors, string.format('<font color="rgb(%d,%d,%d)">%s</font>', color.R * 255, color.G * 255, color.B * 255, name))
        end
        functionsLabel.Text = table.concat(rainbowColors, " | ")
    else
        functionsLabel.Text = ""
    end
    
    frame.Size = UDim2.new(0, #enabledFunctions * 150, 0, 30)
    frame.Position = UDim2.new(1, -frame.Size.X.Offset, 0, 75)
end

SettingsTab:AddParagraph("HUD Settings", "")

SettingsTab:AddToggle({
    Name = "HUD",
    Default = false,
    Callback = function(v)
        hudEnabled = v
        updateHUD()
        if v then
            hudUpdateConnection = RunService.RenderStepped:Connect(updateHUD)
        else
            if hudUpdateConnection then
                hudUpdateConnection:Disconnect()
                hudUpdateConnection = nil
            end
        end
    end
})

OrionLib:Init()
