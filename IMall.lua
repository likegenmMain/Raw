local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Qanuir/orion-ui/refs/heads/main/source.lua"))()

local Window = OrionLib:MakeWindow({
    Name = "Intruder Script | Mall",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "IntruderScriptMall",
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
local Lighting = game:GetService("Lighting")

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
    Callback = function(v) velocitySpeed = v end
})

PT:AddToggle({
    Name = "Enable SpeedHack",
    Default = false,
    Callback = function(v)
        velocityEnabled = v
        if v then
            velocityConnection = RunService.Heartbeat:Connect(function()
                if velocityEnabled then SetupVelocityMovement(velocitySpeed) end
            end)
        else
            if velocityConnection then velocityConnection:Disconnect() velocityConnection = nil end
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
    Callback = function(v) flySpeed = v end
})

PT:AddToggle({
    Name = "Enable Fly",
    Default = false,
    Callback = function(v)
        flyEnabled = v
        if v then
            flyConnection = RunService.Heartbeat:Connect(function()
                if flyEnabled then SetupFly(flySpeed) end
            end)
        else
            if flyConnection then flyConnection:Disconnect() flyConnection = nil end
            if flyTween then flyTween:Cancel() flyTween = nil end
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
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/MallInteractClick.lua"))()
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
            if fullBrightConnection then fullBrightConnection:Disconnect() fullBrightConnection = nil end
            Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            Lighting.Brightness = 1
            Lighting.GlobalShadows = true
            Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
            Lighting.FogStart = 100
        end
    end
})

GameplayTab:AddParagraph("Music", "")

local menuMusicSound = nil
local musicVolume = 0.5
local musicSpeed = 1.0

local function PlayMenuMusic()
    if menuMusicSound then menuMusicSound:Stop() menuMusicSound:Destroy() end
    menuMusicSound = Instance.new("Sound")
    menuMusicSound.SoundId = "rbxassetid://1848319100"
    menuMusicSound.Volume = musicVolume
    menuMusicSound.PlaybackSpeed = musicSpeed
    menuMusicSound.Looped = true
    menuMusicSound.Parent = workspace
    menuMusicSound:Play()
end

local function StopMenuMusic()
    if menuMusicSound then menuMusicSound:Stop() menuMusicSound:Destroy() menuMusicSound = nil end
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
    Callback = function(v) musicVolume = v UpdateMusicSettings() end
})

GameplayTab:AddSlider({
    Name = "Music Speed",
    Min = 0.1,
    Max = 2.0,
    Default = 1.0,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 0.1,
    ValueName = "Spd",
    Callback = function(v) musicSpeed = v UpdateMusicSettings() end
})

GameplayTab:AddParagraph("Anti Features", "")

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
    Callback = function(v) if v then DestroyAntiAnxiety() end end
})

GameplayTab:AddToggle({
    Name = "Anti Awareness",
    Default = false,
    Callback = function(v) if v then DestroyAntiAwareness() end end
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
        if hrp then hrp.CFrame = CFrame.new(pos) end
    end
end

TeleportTab:AddButton({ Name = "Locker1", Callback = function() TeleportTo(Vector3.new(-28.75, 4.09, -44.27)) end })
TeleportTab:AddButton({ Name = "Locker2", Callback = function() TeleportTo(Vector3.new(-28.23, 4.09, -40.44)) end })
TeleportTab:AddButton({ Name = "Locker3", Callback = function() TeleportTo(Vector3.new(-7.28, 4.09, -32.87)) end })
TeleportTab:AddButton({ Name = "Locker4", Callback = function() TeleportTo(Vector3.new(-1.34, 4.09, -32.28)) end })
TeleportTab:AddButton({ Name = "1", Callback = function() TeleportTo(Vector3.new(-20.13, 4.09, -43.03)) end })
TeleportTab:AddButton({ Name = "2", Callback = function() TeleportTo(Vector3.new(-6.39, 4.09, -55.05)) end })
TeleportTab:AddButton({ Name = "3", Callback = function() TeleportTo(Vector3.new(0.50, 4.09, -68.25)) end })
TeleportTab:AddButton({ Name = "4", Callback = function() TeleportTo(Vector3.new(2.74, 4.09, -31.19)) end })
TeleportTab:AddButton({ Name = "Box", Callback = function() TeleportTo(Vector3.new(-8.51, 4.09, -34.18)) end })
TeleportTab:AddButton({ Name = "Electricity", Callback = function() TeleportTo(Vector3.new(-9.28, 4.09, -51.06)) end })
TeleportTab:AddButton({ Name = "Phone", Callback = function() TeleportTo(Vector3.new(-0.29, 4.09, -40.39)) end })
TeleportTab:AddButton({ Name = "PC", Callback = function() TeleportTo(Vector3.new(-29.68, 4.09, -42.59)) end })
TeleportTab:AddButton({ Name = "LightSwitcher", Callback = function() TeleportTo(Vector3.new(3.57, 4.09, -67.31)) end })
TeleportTab:AddButton({ Name = "LockerRoom", Callback = function() TeleportTo(Vector3.new(-0.50, -50.76, -34.00)) end })

UITab:AddParagraph("Menu", "")

UITab:AddButton({
    Name = "Unload",
    Callback = function()
        if velocityConnection then velocityConnection:Disconnect() end
        if flyConnection then flyConnection:Disconnect() end
        if fullBrightConnection then fullBrightConnection:Disconnect() end
        if flyTween then flyTween:Cancel() end
        StopMenuMusic()
        Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
        Lighting.FogStart = 100
        OrionLib:Destroy()
    end
})

OrionLib:Init()
