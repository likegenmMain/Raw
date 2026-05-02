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

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")

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

-- Vehicle Fly
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

-- Vehicle Turbo
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

-- Probes
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
                        -- Используем WorldPivot или Position
                        local targetPos = probe:GetPivot().Position
                        hrp.CFrame = CFrame.new(targetPos)
                    end
                end
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

local function getPlayerNames()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(names, p.Name)
        end
    end
    return names
end

local teleportPlayerDropdown = TeleportTab:AddDropdown({
    Name = "Select Player",
    Default = "",
    Options = getPlayerNames(),
    Callback = function(v) end
})

TeleportTab:AddButton({
    Name = "Teleport",
    Callback = function()
        local targetName = teleportPlayerDropdown.Value
        if targetName and targetName ~= "" then
            local target = Players:FindFirstChild(targetName)
            if target and target.Character then
                local targetHrp = target.Character:FindFirstChild("HumanoidRootPart")
                local myChar = LocalPlayer.Character
                if targetHrp and myChar then
                    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
                    if myHrp then
                        myHrp.CFrame = targetHrp.CFrame
                    end
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

-- Vehicle Teleport
local vehicleTeleportSpeed = 500
local vehicleTeleportConnection = nil
local vehicleTeleportActive = false
local vehicleTeleportTarget = nil

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

local function startVehicleTeleport(targetPos)
    if vehicleTeleportConnection then
        vehicleTeleportConnection:Disconnect()
    end
    
    local myChar = LocalPlayer.Character
    if not myChar then return end
    
    local primaryPart = myChar.PrimaryPart or myChar:FindFirstChild("HumanoidRootPart")
    if not primaryPart then return end
    
    vehicleTeleportActive = true
    vehicleTeleportTarget = targetPos
    
    vehicleTeleportConnection = RunService.Heartbeat:Connect(function()
        if not vehicleTeleportActive then
            vehicleTeleportConnection:Disconnect()
            vehicleTeleportConnection = nil
            return
        end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local part = char.PrimaryPart or char:FindFirstChild("HumanoidRootPart")
        if not part then return end
        
        local direction = (vehicleTeleportTarget - part.Position)
        local distance = direction.Magnitude
        
        if distance < 10 then
            part.Velocity = Vector3.zero
            vehicleTeleportActive = false
            vehicleTeleportConnection:Disconnect()
            vehicleTeleportConnection = nil
        else
            local lookDir = Vector3.new(direction.X, 0, direction.Z)
            if lookDir.Magnitude > 0 then
                part.CFrame = CFrame.new(part.Position, part.Position + lookDir.Unit)
            end
            
            part.Velocity = direction.Unit * vehicleTeleportSpeed
        end
    end)
end

TeleportTab:AddButton({
    Name = "Vehicle Teleport to Player",
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
    Name = "Vehicle Teleport to Cursor",
    Callback = function()
        local mouse = LocalPlayer:GetMouse()
        startVehicleTeleport(mouse.Hit.Position)
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
        local char = LocalPlayer.Character
        if char then
            local part = char.PrimaryPart or char:FindFirstChild("HumanoidRootPart")
            if part then
                part.Velocity = Vector3.zero
            end
        end
    end
})

OrionLib:Init()
