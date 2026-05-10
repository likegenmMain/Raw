local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Qanuir/orion-ui/refs/heads/main/source.lua"))()

local Window = OrionLib:MakeWindow({
    Name = "Title of the library",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionTest",
    IntroText = "By Likegenm + FF"
})

local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local LPTab = Window:MakeTab({
    Name = "LocalPlayer",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local VisualTab = Window:MakeTab({
    Name = "Visual",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

MainTab:AddSection({ Name = "Invisible" })

local invisOn = false
local invisX = 99999999
local invisY = -99999999
local invisZ = 99999999
local invisChair = nil
local invisConnection = nil
local savedPos = nil

local function setTransparency(character, transparency)
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") then
            part.Transparency = transparency
        end
    end
end

MainTab:AddToggle({
    Name = "Invisible",
    Default = false,
    Callback = function(v)
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        
        invisOn = v
        
        if invisOn then
            savedPos = char.HumanoidRootPart.CFrame
            task.wait()
            char.HumanoidRootPart.CFrame = CFrame.new(invisX, invisY, invisZ)
            task.wait(0.15)
            
            invisChair = Instance.new("Seat", workspace)
            invisChair.Anchored = false
            invisChair.CanCollide = false
            invisChair.Name = "invischair"
            invisChair.Transparency = 1
            invisChair.Position = Vector3.new(invisX, invisY, invisZ)
            
            local weld = Instance.new("Weld", invisChair)
            local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
            if torso then
                weld.Part0 = invisChair
                weld.Part1 = torso
            end
            
            task.wait()
            invisChair.CFrame = savedPos
            setTransparency(char, 0.5)
        else
            if invisChair then invisChair:Destroy() invisChair = nil end
            setTransparency(char, 0)
        end
    end
})

LPTab:AddSection({ Name = "SpeedHack" })

local speedHackEnabled = false
local speedValue = 50
local speedConnection = nil

LPTab:AddToggle({
    Name = "SpeedHack",
    Default = false,
    Callback = function(v)
        speedHackEnabled = v
        if v then
            speedConnection = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                local look = Camera.CFrame.LookVector
                local right = Camera.CFrame.RightVector
                local mv = Vector3.zero
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then mv += Vector3.new(look.X, 0, look.Z).Unit end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then mv -= Vector3.new(look.X, 0, look.Z).Unit end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then mv -= Vector3.new(right.X, 0, right.Z).Unit end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then mv += Vector3.new(right.X, 0, right.Z).Unit end
                
                if mv.Magnitude > 0 then
                    hrp.Velocity = Vector3.new(mv.X * speedValue, hrp.Velocity.Y, mv.Z * speedValue)
                end
            end)
        else
            if speedConnection then speedConnection:Disconnect() speedConnection = nil end
        end
    end
})

LPTab:AddSlider({
    Name = "Speed",
    Min = 16,
    Max = 500,
    Default = 50,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Speed:",
    Callback = function(v) speedValue = v end
})

LPTab:AddSection({ Name = "Mouse Teleport" })

local mouseTeleportEnabled = false

LPTab:AddToggle({
    Name = "Mouse Teleport (T)",
    Default = false,
    Callback = function(v) mouseTeleportEnabled = v end
})

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.T and mouseTeleportEnabled then
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        hrp.CFrame = CFrame.new(Mouse.Hit.Position)
    end
end)

LPTab:AddSection({ Name = "Fly" })

local flyEnabled = false
local flySpeed = 50
local flyConnection = nil
local flyTween = nil

LPTab:AddToggle({
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

LPTab:AddSlider({
    Name = "Fly Speed",
    Min = 10,
    Max = 200,
    Default = 50,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Speed:",
    Callback = function(v) flySpeed = v end
})

LPTab:AddSection({ Name = "Anti Fall" })

local antiFallEnabled = false
local antiFallConnection = nil

LPTab:AddToggle({
    Name = "Anti Fall",
    Default = false,
    Callback = function(v)
        antiFallEnabled = v
        if v then
            antiFallConnection = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                if hrp.Velocity.Y < 0 then
                    local ray = Ray.new(hrp.Position, Vector3.new(0, -1000, 0))
                    local hit = workspace:FindPartOnRay(ray, char)
                    if hit then
                        local dist = hrp.Position.Y - hit.Position.Y
                        if dist >= 20 and dist <= 1000 then
                            hrp.CFrame = CFrame.new(hrp.Position.X, hit.Position.Y + 3, hrp.Position.Z)
                        end
                    end
                end
            end)
        else
            if antiFallConnection then antiFallConnection:Disconnect() antiFallConnection = nil end
        end
    end
})

VisualTab:AddSection({ Name = "FOV" })

VisualTab:AddSlider({
    Name = "FOV",
    Min = 30,
    Max = 120,
    Default = 70,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "FOV:",
    Callback = function(v) Camera.FieldOfView = v end
})

VisualTab:AddSection({ Name = "Fullbright" })

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

OrionLib:Init()

workspace.FallenPartsDestroyHeight = 0/0

local p = Instance.new("Part")
p.Name = "VoidFloor"
p.Parent = workspace
p.Size = Vector3.new(2048, 20, 2048)
p.Position = Vector3.new(0, -5000, 0)
p.Anchored = true
p.Color = Color3.new(0, 0, 0)
p.Transparency = 0.7
p.CanCollide = true

task.spawn(function()
    while true do
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        
        if hum and hum.Health <= 0 then
            hum.Health = hum.MaxHealth
        end
        
        if char and char.PrimaryPart then
            p.Position = Vector3.new(char.PrimaryPart.Position.X, -5000, char.PrimaryPart.Position.Z)
        end
        
        task.wait(0.01)
    end
end)
