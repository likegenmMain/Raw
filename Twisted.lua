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

OrionLib:Init()
