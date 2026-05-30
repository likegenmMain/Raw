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

local VehicleTab = Window:MakeTab({
    Name = "Vehicle",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local AutoFarmTab = Window:MakeTab({
    Name = "AutoFarm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local ServerTab = Window:MakeTab({
    Name = "Server",
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
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
                if mv.Magnitude > 0 then hrp.Velocity = Vector3.new(mv.X * speedHackValue, hrp.Velocity.Y, mv.Z * speedHackValue) end
            end)
        else
            if speedHackConnection then speedHackConnection:Disconnect() speedHackConnection = nil end
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
            if infJumpsConnection then infJumpsConnection:Disconnect() infJumpsConnection = nil end
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
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        else
            if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
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
                if v:IsA("BasePart") then v.CanCollide = state end
            end
        end
    end
end

MainTab:AddToggle({
    Name = "Jesus",
    Default = false,
    Callback = function(v)
        jesusEnabled = v
        if jesusEnabled then setWaterCollide(true) else setWaterCollide(false) end
    end
})

local gravityEnabled = false
local gravityValue = 196.2

MainTab:AddToggle({
    Name = "Gravity",
    Default = false,
    Callback = function(v)
        gravityEnabled = v
        if gravityEnabled then workspace.Gravity = gravityValue else workspace.Gravity = 196.2 end
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
        if gravityEnabled then workspace.Gravity = v end
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
            if spinBotConnection then spinBotConnection:Disconnect() spinBotConnection = nil end
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
                if dir.Magnitude > 0 then primaryPart.Velocity = dir.Unit * vehicleFlySpeed end
                local cameraLook = Vector3.new(Camera.CFrame.LookVector.X, 0, Camera.CFrame.LookVector.Z)
                if cameraLook.Magnitude > 0 then primaryPart.CFrame = CFrame.new(primaryPart.Position, primaryPart.Position + cameraLook.Unit) end
            end)
        else
            if vehicleFlyConnection then vehicleFlyConnection:Disconnect() vehicleFlyConnection = nil end
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
                if mv.Magnitude > 0 then primaryPart.Velocity = Vector3.new(mv.X * vehicleTurboSpeed, 0, mv.Z * vehicleTurboSpeed) end
                local cameraLook = Vector3.new(Camera.CFrame.LookVector.X, 0, Camera.CFrame.LookVector.Z)
                if cameraLook.Magnitude > 0 then primaryPart.CFrame = CFrame.new(primaryPart.Position, primaryPart.Position + cameraLook.Unit) end
            end)
        else
            if vehicleTurboConnection then vehicleTurboConnection:Disconnect() vehicleTurboConnection = nil end
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

MainTab:AddParagraph("Buy Items", "")

local buyItems = {"Soda", "Small Gas Canister", "Big Gas Canister", "Chips", "Flashlight", "Beans"}

local buyItemDropdown = MainTab:AddDropdown({
    Name = "Select Item",
    Default = "Flashlight",
    Options = buyItems,
    Callback = function(v) end
})

MainTab:AddButton({
    Name = "Buy Item",
    Callback = function()
        local selectedItem = buyItemDropdown.Value
        if selectedItem and selectedItem ~= "" then
            ReplicatedStorage.events.buy_store_item:FireServer("Gas Station", selectedItem)
        end
    end
})

MainTab:AddParagraph("Respawn", "")

MainTab:AddButton({
    Name = "Respawn",
    Callback = function()
        ReplicatedStorage.events.plr_respawn:FireServer()
    end
})

local autoRespawnEnabled = false
local autoRespawnConnection = nil

MainTab:AddToggle({
    Name = "Auto Respawn",
    Default = false,
    Callback = function(v)
        autoRespawnEnabled = v
        if autoRespawnEnabled then
            autoRespawnConnection = RunService.Heartbeat:Connect(function()
                if not autoRespawnEnabled then return end
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChild("Humanoid")
                    if hum and hum.Health <= 0 then ReplicatedStorage.events.plr_respawn:FireServer() end
                end
            end)
        else
            if autoRespawnConnection then autoRespawnConnection:Disconnect() autoRespawnConnection = nil end
        end
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
                if probe.Name == tostring(userId) then table.insert(probes, probe.Name) end
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
                if probe.Name == tostring(userId) then table.insert(probes, probe) end
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
                    if hrp then hrp.CFrame = CFrame.new(probe:GetPivot().Position) end
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
                hrp.CFrame = CFrame.new(probe:GetPivot().Position + Vector3.new(0, 5, 0))
                task.wait(0.5)
                local promptPart = probe:FindFirstChild("PromptPart")
                if promptPart then
                    local prompt = promptPart:FindFirstChild("Prompt")
                    if prompt then fireproximityprompt(prompt) end
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
        if selectedProbe and selectedProbe ~= "" then teleportToProbe(selectedProbe) end
    end
})

MainTab:AddButton({
    Name = "Collect Probe",
    Callback = function()
        local selectedProbe = probesDropdown.Value
        if selectedProbe and selectedProbe ~= "" then collectProbe(selectedProbe) end
    end
})

MainTab:AddButton({
    Name = "Refresh Probes",
    Callback = function() probesDropdown:Refresh(getProbes(), true) end
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
            Lighting.GlobalShadows = false
            Lighting.Outlines = false
        else
            Lighting.Ambient = Color3.fromRGB(0, 0, 0)
            Lighting.OutdoorAmbient = Color3.fromRGB(105, 105, 105)
            Lighting.Brightness = 1
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = true
            Lighting.Outlines = true
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
    Callback = function(v) Camera.FieldOfView = v end
})

local velocityNotifyEnabled = false
local lastNotify = 0

VisualTab:AddToggle({
    Name = "Player Velocity",
    Default = false,
    Callback = function(v) velocityNotifyEnabled = v end
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
                        OrionLib:MakeNotification({Name = "Velocity", Content = "Speed: " .. speed .. " | Vertical: " .. vertSpeed, Time = 2})
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
    highlight.FillColor = Color3.fromRGB(255, 255, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    highlight.OutlineTransparency = 0
    highlight.Adornee = probe
    highlight.Parent = probe
    
    local billboard = Instance.new("BillboardGui")
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
    
    table.insert(probesESPObjects, {Probe = probe, Highlight = highlight, Billboard = billboard, TracerLine = tracerLine})
end

local function removeProbeESP(data)
    if data.Highlight then data.Highlight:Destroy() end
    if data.Billboard then data.Billboard:Destroy() end
    if data.TracerLine then data.TracerLine:Remove() end
end

local function clearAllProbesESP()
    for _, data in ipairs(probesESPObjects) do removeProbeESP(data) end
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
        for _, probe in ipairs(probes) do createProbeESP(probe) end
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
            probesESPConnection = RunService.RenderStepped:Connect(function() updateProbesESP() end)
        else
            clearAllProbesESP()
            if probesESPConnection then probesESPConnection:Disconnect() probesESPConnection = nil end
        end
    end
})

VisualTab:AddButton({
    Name = "Refresh Probes ESP",
    Callback = function() refreshProbesESP() end
})

local stormWarningEnabled = false
local stormWarningConnection = nil
local lastStormCount = 0

local function getStormCount()
    local stormsFolder = workspace:FindFirstChild("storm_related")
    if stormsFolder then
        local stormsContainer = stormsFolder:FindFirstChild("storms")
        if stormsContainer then
            local count = 0
            for _, storm in ipairs(stormsContainer:GetChildren()) do
                if storm:IsA("Model") or storm:IsA("BasePart") then count = count + 1 end
            end
            return count
        end
    end
    return 0
end

local function checkNewStorms()
    local currentCount = getStormCount()
    if currentCount > lastStormCount then
        local stormsFolder = workspace:FindFirstChild("storm_related")
        if stormsFolder then
            local stormsContainer = stormsFolder:FindFirstChild("storms")
            if stormsContainer then
                local children = stormsContainer:GetChildren()
                local newestStorm = nil
                for i = #children, 1, -1 do
                    if children[i]:IsA("Model") or children[i]:IsA("BasePart") then newestStorm = children[i] break end
                end
                if newestStorm then
                    OrionLib:MakeNotification({Name = "Storm Warning", Content = "New storm detected: " .. newestStorm.Name, Time = 5})
                end
            end
        end
    end
    lastStormCount = currentCount
end

VisualTab:AddParagraph("Storm Warning", "")

VisualTab:AddToggle({
    Name = "Storm Warning",
    Default = false,
    Callback = function(v)
        stormWarningEnabled = v
        if v then
            lastStormCount = getStormCount()
            stormWarningConnection = RunService.Heartbeat:Connect(function()
                if not stormWarningEnabled then return end
                checkNewStorms()
            end)
        else
            if stormWarningConnection then stormWarningConnection:Disconnect() stormWarningConnection = nil end
        end
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
        if p ~= LocalPlayer then table.insert(names, p.Name) end
    end
    return names
end

local vehicleTeleportSpeed = 500
local vehicleTeleportConnection = nil
local vehicleTeleportActive = false
local vehicleTeleportTarget = nil

local function startVehicleTeleport(targetPos)
    if vehicleTeleportConnection then vehicleTeleportConnection:Disconnect() end
    local part = getPrimaryPart()
    if not part then return end
    vehicleTeleportActive = true
    vehicleTeleportTarget = targetPos
    part.Velocity = Vector3.new(0, 10000, 0)
    task.wait(0.3)
    vehicleTeleportConnection = RunService.Heartbeat:Connect(function()
        if not vehicleTeleportActive then vehicleTeleportConnection:Disconnect() vehicleTeleportConnection = nil return end
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
            if lookDir.Magnitude > 0 then currentPart.CFrame = CFrame.new(currentPart.Position, currentPart.Position + lookDir.Unit) end
            currentPart.Velocity = direction.Unit * vehicleTeleportSpeed
        end
    end)
end

local cities = {
    ["Hazelton"] = Vector3.new(3530.361083984375, 47.397972106933594, -12934.0654296875),
    ["Prior Lake"] = Vector3.new(832.2999877929688, 22.198026657104492, 3563.01953125),
    ["Starbuck"] = Vector3.new(483.1630859375, 56.198020935058594, 17157.279296875),
    ["Hibbing"] = Vector3.new(-9458.9658203125, 22.177297592163086, 7043.642578125),
    ["Wadena"] = Vector3.new(17727.73828125, 60.198020935058594, -15855.8994140625),
    ["Viroqua"] = Vector3.new(11222.79296875, 22.268314361572266, 10442.5576171875)
}

local cityNames = {}
for name, _ in pairs(cities) do table.insert(cityNames, name) end

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
                    if part then part.CFrame = targetHrp.CFrame end
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
                if targetHrp then startVehicleTeleport(targetHrp.Position) end
            end
        end
    end
})

TeleportTab:AddButton({
    Name = "Refresh Players",
    Callback = function() teleportPlayerDropdown:Refresh(getPlayerNames(), true) end
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
            if part then part.CFrame = CFrame.new(cities[cityName]) end
        end
    end
})

TeleportTab:AddButton({
    Name = "Vehicle TP to City",
    Callback = function()
        local cityName = citiesDropdown.Value
        if cityName and cityName ~= "" and cities[cityName] then startVehicleTeleport(cities[cityName]) end
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
    Callback = function(v) vehicleTeleportSpeed = v end
})

TeleportTab:AddButton({
    Name = "Stop Vehicle Teleport",
    Callback = function()
        vehicleTeleportActive = false
        if vehicleTeleportConnection then vehicleTeleportConnection:Disconnect() vehicleTeleportConnection = nil end
        local part = getPrimaryPart()
        if part then part.Velocity = Vector3.zero end
    end
})

local deployState = false
local deployTask = nil

local function toggleDeploy(state)
    if state == deployState then return end
    deployState = state
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local seat = hum and hum.Sit and hum.SeatPart
    local carId = tostring(LocalPlayer.UserId)
    local playerRelated = workspace:FindFirstChild("player_related")
    local carsFolder = playerRelated and playerRelated:FindFirstChild("cars")
    local car = carsFolder and carsFolder:FindFirstChild(carId)
    if not (car and seat and seat:IsDescendantOf(car) and car:FindFirstChild("chassis")) then
        if deployState then OrionLib:MakeNotification({Name = "Deploy", Content = "You must be driving your vehicle!", Time = 3}) end
        return
    end
    local chassis = car.chassis
    local wheels = car:FindFirstChild("wheels")
    if deployState then
        if wheels then for _, p in ipairs(wheels:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
        if deployTask then pcall(task.cancel, deployTask) end
        deployTask = task.spawn(function()
            task.wait(0.5)
            if deployState and chassis and chassis.Parent then
                chassis.Anchored = true
                chassis.AssemblyLinearVelocity = Vector3.new(0,0,0)
                chassis.AssemblyAngularVelocity = Vector3.new(0,0,0)
                OrionLib:MakeNotification({Name = "Deploy", Content = "Vehicle Deployed!", Time = 2})
            end
        end)
    else
        if deployTask then pcall(task.cancel, deployTask) end
        if chassis and chassis.Parent then
            chassis.Anchored = false
            chassis.AssemblyLinearVelocity = Vector3.new(0,0,0)
            chassis.AssemblyAngularVelocity = Vector3.new(0,0,0)
        end
        if wheels then for _, p in ipairs(wheels:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end end
        OrionLib:MakeNotification({Name = "Deploy", Content = "Vehicle Undeployed!", Time = 2})
    end
end

VehicleTab:AddParagraph("Spawn Car", "")

VehicleTab:AddButton({
    Name = "Spawn Car",
    Callback = function()
        local vehicleName = LocalPlayer.player_inv["92454SS"]:GetAttribute("vehicle_name")
        ReplicatedStorage.events.spawn_vehicle:FireServer(vehicleName)
    end
})

VehicleTab:AddParagraph("Deploy Vehicle", "")

VehicleTab:AddToggle({
    Name = "Deploy Vehicle",
    Default = false,
    Callback = function(v) toggleDeploy(v) end
})

local committedCarStats = nil
local gcWarningShown = false

local function updateCarStats(forceCommit)
    local executor = (identifyexecutor and identifyexecutor()) or "Unknown"
    local unsupportedExecutors = {"Solara", "Xeno", "JJSploit"}
    local isUnsupported = false
    for _, name in ipairs(unsupportedExecutors) do if executor:find(name) then isUnsupported = true break end end
    if not ggc or isUnsupported then
        if not gcWarningShown then
            gcWarningShown = true
            OrionLib:MakeNotification({Name = "Vehicle Stats", Content = "Vehicle Stats Unsupported (" .. executor .. ")", Time = 5})
        end
        return
    end
    if forceCommit then
        committedCarStats = {
            road = Options.RoadSpeedValue, dirt = Options.DirtSpeedValue, grass = Options.GrassSpeedValue,
            torque = Options.TorqueValue, gears = Options.GearsValue, brakes = Options.BrakesValue, steerSpd = Options.SteerSpdValue,
        }
    end
    local stats = committedCarStats
    if not stats then return end
    for _, v in pairs(ggc(true)) do
        if type(v) == "table" and rawget(v, "Vehicle") and type(v.Vehicle) == "table" and rawget(v, "Driving") and type(v.Driving) == "table" then
            if v.Driving.Speeds then
                if stats.road then v.Driving.Speeds.Road = stats.road end
                if stats.dirt then v.Driving.Speeds.Dirt = stats.dirt end
                if stats.grass then v.Driving.Speeds.Grass = stats.grass end
            end
            if stats.torque then v.Driving.Torque = stats.torque end
            if stats.gears then v.Driving.Gears = stats.gears end
            if stats.brakes then v.Driving.Brakes = stats.brakes end
            if stats.steerSpd then v.Driving.Steer_Spd = stats.steerSpd end
        end
    end
end

VehicleTab:AddParagraph("Vehicle Stats", "")

local RoadSpeedValue = 108
local DirtSpeedValue = 50
local GrassSpeedValue = 20
local TorqueValue = 405
local GearsValue = 3
local BrakesValue = 1500
local SteerSpdValue = 0.05

VehicleTab:AddSlider({Name = "Road Speed", Min = 0, Max = 1000, Default = 108, Color = Color3.fromRGB(255, 255, 255), Increment = 1, ValueName = "mph", Callback = function(v) RoadSpeedValue = v end})
VehicleTab:AddSlider({Name = "Dirt Speed", Min = 0, Max = 1000, Default = 50, Color = Color3.fromRGB(255, 255, 255), Increment = 1, ValueName = "mph", Callback = function(v) DirtSpeedValue = v end})
VehicleTab:AddSlider({Name = "Grass Speed", Min = 0, Max = 1000, Default = 20, Color = Color3.fromRGB(255, 255, 255), Increment = 1, ValueName = "mph", Callback = function(v) GrassSpeedValue = v end})
VehicleTab:AddSlider({Name = "Torque", Min = 0, Max = 10000, Default = 405, Color = Color3.fromRGB(255, 255, 255), Increment = 1, ValueName = "Nm", Callback = function(v) TorqueValue = v end})
VehicleTab:AddSlider({Name = "Gears", Min = 1, Max = 10, Default = 3, Color = Color3.fromRGB(255, 255, 255), Increment = 1, ValueName = "gears", Callback = function(v) GearsValue = v end})
VehicleTab:AddSlider({Name = "Brakes", Min = 0, Max = 20000, Default = 1500, Color = Color3.fromRGB(255, 255, 255), Increment = 1, ValueName = "force", Callback = function(v) BrakesValue = v end})
VehicleTab:AddSlider({Name = "Steering Speed", Min = 0.01, Max = 0.1, Default = 0.05, Color = Color3.fromRGB(255, 255, 255), Increment = 0.001, ValueName = "sec", Callback = function(v) SteerSpdValue = v end})

VehicleTab:AddButton({Name = "Apply Stats", Callback = function() updateCarStats(true) end})

VehicleTab:AddParagraph("Vehicle Rotations", "")

local rotationLeftEnabled = false
local rotationRightEnabled = false
local rotationBackEnabled = false
local rotationForwardEnabled = false
local rotationConnection = nil

local function setCharacterRotation(degrees)
    local character = LocalPlayer.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(degrees), 0)
end

VehicleTab:AddToggle({Name = "Rotate Left", Default = false, Callback = function(v) rotationLeftEnabled = v end})
VehicleTab:AddToggle({Name = "Rotate Right", Default = false, Callback = function(v) rotationRightEnabled = v end})
VehicleTab:AddToggle({Name = "Rotate Back", Default = false, Callback = function(v) rotationBackEnabled = v end})
VehicleTab:AddToggle({Name = "Rotate Forward", Default = false, Callback = function(v) rotationForwardEnabled = v end})

rotationConnection = RunService.Heartbeat:Connect(function()
    if rotationLeftEnabled then setCharacterRotation(-90) end
    if rotationRightEnabled then setCharacterRotation(90) end
    if rotationBackEnabled then setCharacterRotation(180) end
    if rotationForwardEnabled then setCharacterRotation(0) end
end)

local orbitHeight = -200
local orbitSpeed = 0.002
local clickInterval = 5
local orbiting = false
local orbitConnection = nil
local orbitAngle = 0
local currentOrbitRadius = 50
local lastSizeCheck = 0
local bestTornado = nil
local clickTask = nil

local function getOrbitDistance(tornado)
    local size = (tornado.Size.X + tornado.Size.Z) / 2
    if size < 500 then return 100
    elseif size < 1000 then return 300
    elseif size < 1500 then return 500
    else return 700 end
end

local function equipCamera()
    local char = LocalPlayer.Character
    if not char then return false end
    if char:FindFirstChild("Handheld Camera") then return true end
    local camera = LocalPlayer.Backpack:FindFirstChild("Handheld Camera")
    if camera then camera.Parent = char; task.wait(0.3); return true end
    return false
end

local function setupCamera()
    equipCamera()
end

local function takePhoto()
    if not bestTornado then return end
    Camera.CFrame = CFrame.new(Camera.CFrame.Position, bestTornado.Position)
    task.wait(0.1)
    ReplicatedStorage.events.CameraCapture:FireServer({DoF = 0, Zoom = 0, Saturation = 1, Contrast = 1})
end

local function startAutoClick()
    if clickTask then task.cancel(clickTask) end
    clickTask = task.spawn(function()
        while orbiting do
            setupCamera()
            task.wait(0.3)
            takePhoto()
            task.wait(clickInterval)
        end
    end)
end

local function stopAutoClick()
    if clickTask then task.cancel(clickTask); clickTask = nil end
end

local function findBiggestTornado()
    local storms = workspace:FindFirstChild("storm_related")
    if not storms then return nil end
    local stormsFolder = storms:FindFirstChild("storms")
    if not stormsFolder then return nil end
    local biggest, biggestSize = nil, 0
    for _, storm in ipairs(stormsFolder:GetChildren()) do
        local rotation = storm:FindFirstChild("rotation")
        if rotation then
            for _, part in ipairs(rotation:GetDescendants()) do
                if part.Name == "tornado_scan" and part:IsA("BasePart") then
                    local size = (part.Size.X + part.Size.Z) / 2
                    if size > biggestSize then biggestSize = size; biggest = part end
                end
            end
        end
    end
    return biggest
end

local function stopOrbit()
    orbiting = false
    if orbitConnection then orbitConnection:Disconnect(); orbitConnection = nil end
    stopAutoClick()
    workspace.Gravity = 196.2
end

local function startOrbit()
    setupCamera()
    bestTornado = findBiggestTornado()
    if not bestTornado then return false end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    currentOrbitRadius = (bestTornado.Size.X + bestTornado.Size.Z) / 2 + getOrbitDistance(bestTornado)
    local startPos = bestTornado.Position + Vector3.new(currentOrbitRadius, orbitHeight, 0)
    hrp.CFrame = CFrame.new(startPos, bestTornado.Position)
    orbiting = true
    orbitAngle = 0
    workspace.Gravity = 0
    lastSizeCheck = tick()
    startAutoClick()
    orbitConnection = RunService.Heartbeat:Connect(function()
        if not orbiting then return end
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 0 then
            ReplicatedStorage.events.plr_respawn:FireServer()
            task.wait(0.5)
            return
        end
        if tick() - lastSizeCheck > 1 then
            lastSizeCheck = tick()
            local newBest = findBiggestTornado()
            if newBest then
                local newSize = (newBest.Size.X + newBest.Size.Z) / 2
                local oldSize = bestTornado and ((bestTornado.Size.X + bestTornado.Size.Z) / 2) or 0
                if newSize > oldSize then
                    bestTornado = newBest
                    currentOrbitRadius = (bestTornado.Size.X + bestTornado.Size.Z) / 2 + getOrbitDistance(bestTornado)
                end
            end
        end
        if not bestTornado or not bestTornado.Parent then
            bestTornado = findBiggestTornado()
            if not bestTornado then return end
            currentOrbitRadius = (bestTornado.Size.X + bestTornado.Size.Z) / 2 + getOrbitDistance(bestTornado)
        end
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        orbitAngle = orbitAngle + orbitSpeed
        local pos = bestTornado.Position + Vector3.new(math.cos(orbitAngle) * currentOrbitRadius, orbitHeight, math.sin(orbitAngle) * currentOrbitRadius)
        hrp.CFrame = CFrame.new(pos, bestTornado.Position)
        Camera.CameraType = Enum.CameraType.Custom
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, bestTornado.Position)
    end)
    return true
end

AutoFarmTab:AddParagraph("Camera AutoFarm", "")

AutoFarmTab:AddToggle({
    Name = "Camera AutoFarm",
    Default = false,
    Callback = function(v)
        if v then startOrbit() else stopOrbit() end
    end
})

ServerTab:AddParagraph("Server", "")

ServerTab:AddButton({
    Name = "Rejoin Server",
    Callback = function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId) end
})

ServerTab:AddParagraph("Bypass AC", "")

ServerTab:AddButton({
    Name = "Bypass AC",
    Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/likegenmMain/Unknown/refs/heads/main/TwistedACBypass.lua"))() end
})

ServerTab:AddParagraph("Bypass Void", "")

local bypassVoidEnabled = false
local bypassVoidConnection = nil
local voidFloor = nil

ServerTab:AddToggle({
    Name = "Bypass Void",
    Default = false,
    Callback = function(v)
        bypassVoidEnabled = v
        if v then
            OrionLib:MakeNotification({Name = "Bypass Void", Content = "Enable Auto Respawn for full protection!", Time = 5})
            workspace.FallenPartsDestroyHeight = 0/0
            voidFloor = Instance.new("Part")
            voidFloor.Name = "VoidFloor"
            voidFloor.Parent = workspace
            voidFloor.Size = Vector3.new(2048, 20, 2048)
            voidFloor.Position = Vector3.new(0, -5000, 0)
            voidFloor.Anchored = true
            voidFloor.Transparency = 0.7
            voidFloor.CanCollide = true
            bypassVoidConnection = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChild("Humanoid")
                if hum and hum.Health <= 0 then hum.Health = hum.MaxHealth end
                if char and char.PrimaryPart and voidFloor and voidFloor.Parent then
                    voidFloor.Position = Vector3.new(char.PrimaryPart.Position.X, -5000, char.PrimaryPart.Position.Z)
                end
            end)
        else
            if bypassVoidConnection then bypassVoidConnection:Disconnect() bypassVoidConnection = nil end
            if voidFloor and voidFloor.Parent then voidFloor:Destroy() voidFloor = nil end
            workspace.FallenPartsDestroyHeight = -500
        end
    end
})

Options = {
    RoadSpeedValue = RoadSpeedValue, DirtSpeedValue = DirtSpeedValue, GrassSpeedValue = GrassSpeedValue,
    TorqueValue = TorqueValue, GearsValue = GearsValue, BrakesValue = BrakesValue, SteerSpdValue = SteerSpdValue,
}

task.spawn(function()
    while true do
        Options.RoadSpeedValue = RoadSpeedValue; Options.DirtSpeedValue = DirtSpeedValue; Options.GrassSpeedValue = GrassSpeedValue
        Options.TorqueValue = TorqueValue; Options.GearsValue = GearsValue; Options.BrakesValue = BrakesValue; Options.SteerSpdValue = SteerSpdValue
        updateCarStats(false)
        task.wait(5)
    end
end)

OrionLib:Init()
