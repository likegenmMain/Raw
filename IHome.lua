local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Qanuir/orion-ui/refs/heads/main/source.lua"))()

local Window = OrionLib:MakeWindow({
    Name = "Intruder Script | Home",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "IntruderScript",
    IntroEnabled = true,
    IntroText = "By Likegenm Team"
})

local PT = Window:MakeTab({
    Name = "LocalPlayer",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local GameplayTab = Window:MakeTab({
    Name = "Gameplay",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local TeleportTab = Window:MakeTab({
    Name = "Teleport",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local UITab = Window:MakeTab({
    Name = "UI Settings",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

PT:AddParagraph("SpeedHack", "")

local velocitySpeed = 16
local velocityEnabled = false
local velocityConnection

local function SetupVelocityMovement(speed)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not hrp then return end
    
    local lookVector = Camera.CFrame.LookVector
    local rightVector = Camera.CFrame.RightVector
    local mv = Vector3.zero
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then mv += Vector3.new(lookVector.X, 0, lookVector.Z).Unit end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then mv -= Vector3.new(lookVector.X, 0, lookVector.Z).Unit end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then mv -= Vector3.new(rightVector.X, 0, rightVector.Z).Unit end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then mv += Vector3.new(rightVector.X, 0, rightVector.Z).Unit end
    
    if mv.Magnitude > 0 then
        hrp.Velocity = Vector3.new(mv.X * speed, hrp.Velocity.Y, mv.Z * speed)
    end
end

PT:AddSlider({
    Name = "SpeedHack Speed",
    Min = 12,
    Max = 50,
    Default = 16,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(v)
        velocitySpeed = v
    end
})

PT:AddToggle({
    Name = "Enable SpeedHack",
    Default = false,
    Callback = function(v)
        velocityEnabled = v
        if v then
            velocityConnection = RunService.Heartbeat:Connect(function()
                if velocityEnabled then
                    SetupVelocityMovement(velocitySpeed)
                end
            end)
        else
            if velocityConnection then
                velocityConnection:Disconnect()
                velocityConnection = nil
            end
        end
    end
})

PT:AddParagraph("Fly", "")

local flySpeed = 40
local flyEnabled = false
local flyConnection
local flyTween

local function SetupFly(speed)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local lookVector = Camera.CFrame.LookVector
    local rightVector = Camera.CFrame.RightVector
    local targetVelocity = Vector3.zero
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then targetVelocity += lookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then targetVelocity -= lookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then targetVelocity -= rightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then targetVelocity += rightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then targetVelocity += Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then targetVelocity += Vector3.new(0, -1, 0) end
    
    if targetVelocity.Magnitude > 0 then targetVelocity = targetVelocity.Unit * speed end
    
    if flyTween then flyTween:Cancel() end
    flyTween = TweenService:Create(hrp, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {Velocity = targetVelocity})
    flyTween:Play()
end

PT:AddSlider({
    Name = "Fly Speed",
    Min = 16,
    Max = 200,
    Default = 40,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(v)
        flySpeed = v
    end
})

PT:AddToggle({
    Name = "Enable Fly",
    Default = false,
    Callback = function(v)
        flyEnabled = v
        if v then
            flyConnection = RunService.Heartbeat:Connect(function()
                if flyEnabled then
                    SetupFly(flySpeed)
                end
            end)
        else
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            if flyTween then
                flyTween:Cancel()
                flyTween = nil
            end
            local char = LocalPlayer.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.Velocity = Vector3.zero end
            end
        end
    end
})

GameplayTab:AddParagraph("Interact Click", "")

GameplayTab:AddToggle({
    Name = "Interact Click",
    Default = false,
    Callback = function(v)
        if v then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/InteractClickIntruderHome.lua"))()
        end
    end
})

GameplayTab:AddParagraph("Visual", "")

local fullBrightEnabled = false
local fullBrightConnection

GameplayTab:AddToggle({
    Name = "FullBright",
    Default = false,
    Callback = function(v)
        fullBrightEnabled = v
        local Lighting = game:GetService("Lighting")
        if v then
            fullBrightConnection = RunService.Heartbeat:Connect(function()
                if fullBrightEnabled then
                    Lighting.Ambient = Color3.new(1, 1, 1)
                    Lighting.Brightness = 2
                    Lighting.GlobalShadows = false
                    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
                    Lighting.FogEnd = 100000
                    Lighting.FogStart = 0
                end
            end)
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.Brightness = 2
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            Lighting.FogEnd = 100000
            Lighting.FogStart = 0
        else
            if fullBrightConnection then
                fullBrightConnection:Disconnect()
                fullBrightConnection = nil
            end
            Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            Lighting.Brightness = 1
            Lighting.GlobalShadows = true
            Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
            Lighting.FogStart = 100
        end
    end
})

GameplayTab:AddParagraph("Music", "")

local menuMusicEnabled = false
local menuMusicSound = nil
local musicVolume = 0.5
local musicSpeed = 1.0

local function PlayMenuMusic()
    if menuMusicSound then
        menuMusicSound:Stop()
        menuMusicSound:Destroy()
    end
    menuMusicSound = Instance.new("Sound")
    menuMusicSound.SoundId = "rbxassetid://1848319100"
    menuMusicSound.Volume = musicVolume
    menuMusicSound.PlaybackSpeed = musicSpeed
    menuMusicSound.Looped = true
    menuMusicSound.Parent = workspace
    menuMusicSound:Play()
end

local function StopMenuMusic()
    if menuMusicSound then
        menuMusicSound:Stop()
        menuMusicSound:Destroy()
        menuMusicSound = nil
    end
end

local function UpdateMusicSettings()
    if menuMusicSound then
        menuMusicSound.Volume = musicVolume
        menuMusicSound.PlaybackSpeed = musicSpeed
    end
end

GameplayTab:AddToggle({
    Name = "Menu Music",
    Default = false,
    Callback = function(v)
        menuMusicEnabled = v
        if v then PlayMenuMusic() else StopMenuMusic() end
    end
})

GameplayTab:AddSlider({
    Name = "Music Volume",
    Min = 0.1,
    Max = 1,
    Default = 0.5,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 0.1,
    ValueName = "Vol",
    Callback = function(v)
        musicVolume = v
        UpdateMusicSettings()
    end
})

GameplayTab:AddSlider({
    Name = "Music Speed",
    Min = 0.1,
    Max = 2.0,
    Default = 1.0,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 0.1,
    ValueName = "Spd",
    Callback = function(v)
        musicSpeed = v
        UpdateMusicSettings()
    end
})

GameplayTab:AddParagraph("Anti Features", "")

local antiAnxietyEnabled = false
local antiAwarenessEnabled = false

local function DestroyAntiAnxiety()
    if workspace.Events:FindFirstChild("Anxiety") then workspace.Events.Anxiety:Destroy() end
    if workspace.Events:FindFirstChild("AnxietyAmount") then workspace.Events.AnxietyAmount:Destroy() end
    if LocalPlayer.PlayerGui:FindFirstChild("Anxiety") then LocalPlayer.PlayerGui.Anxiety:Destroy() end
end

local function DestroyAntiAwareness()
    if workspace.Events:FindFirstChild("AwarenessValue") then workspace.Events.AwarenessValue:Destroy() end
    if LocalPlayer.PlayerGui:FindFirstChild("IntruderAwareness") then LocalPlayer.PlayerGui.IntruderAwareness:Destroy() end
    if workspace.Events:FindFirstChild("IntruderAwareness") then workspace.Events.IntruderAwareness:Destroy() end
end

GameplayTab:AddToggle({
    Name = "Anti Anxiety",
    Default = false,
    Callback = function(v)
        antiAnxietyEnabled = v
        if v then DestroyAntiAnxiety() end
    end
})

GameplayTab:AddToggle({
    Name = "Anti Awareness",
    Default = false,
    Callback = function(v)
        antiAwarenessEnabled = v
        if v then DestroyAntiAwareness() end
    end
})

GameplayTab:AddParagraph("Intruder", "")

GameplayTab:AddButton({
    Name = "Intruder Pos",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/HomePosIntruder.lua"))()
    end
})

TeleportTab:AddParagraph("Locations", "")

local function TeleportTo(pos)
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(pos)
        end
    end
end

TeleportTab:AddButton({ Name = "Closet", Callback = function() TeleportTo(Vector3.new(-6.14, 4.14, 1.97)) end })
TeleportTab:AddButton({ Name = "Box", Callback = function() TeleportTo(Vector3.new(16.13, 4.14, -5.49)) end })
TeleportTab:AddButton({ Name = "Electricity", Callback = function() TeleportTo(Vector3.new(12.22, 4.14, 22.22)) end })
TeleportTab:AddButton({ Name = "Phone", Callback = function() TeleportTo(Vector3.new(13.38, 4.14, 1.81)) end })
TeleportTab:AddButton({ Name = "PC", Callback = function() TeleportTo(Vector3.new(8.45, 4.14, 9.78)) end })
TeleportTab:AddButton({ Name = "LightSwitcher", Callback = function() TeleportTo(Vector3.new(11.26, 4.14, -8.52)) end })

UITab:AddParagraph("Menu", "")

UITab:AddButton({
    Name = "Unload",
    Callback = function()
        if velocityConnection then velocityConnection:Disconnect() end
        if flyConnection then flyConnection:Disconnect() end
        if fullBrightConnection then fullBrightConnection:Disconnect() end
        if flyTween then flyTween:Cancel() end
        StopMenuMusic()
        local Lighting = game:GetService("Lighting")
        Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
        Lighting.FogStart = 100
        OrionLib:Destroy()
    end
})

OrionLib:Init()
