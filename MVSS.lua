local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Qanuir/orion-ui/refs/heads/main/source.lua"))()

local Window = OrionLib:MakeWindow({
    Name = "Murders VS Sherifs",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionTest",
    IntroEnabled = true,
    IntroText = "By Likegenm"
})

local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game.Players
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

if getgenv().hi == nil then getgenv().hi = false end

MainTab:AddSection({ Name = "Client Spoof" })

local spoofEnabled = false

local spoofLabel = MainTab:AddLabel("Client Spoof (OFF)")

local function updateSpoofLabel()
    if spoofEnabled then
        spoofLabel:Set("<font color='#00FF00'>Client Spoof (ON)</font>")
    else
        spoofLabel:Set("<font color='#FF0000'>Client Spoof (OFF)</font>")
    end
end

MainTab:AddButton({
    Name = "Bypass AC",
    Callback = function()
        spoofEnabled = not spoofEnabled
        updateSpoofLabel()
    end
})

MainTab:AddSection({ Name = "Speedhack" })

local speedEnabled = false
local speedValue = 50

MainTab:AddToggle({
    Name = "SpeedHack",
    Default = false,
    Callback = function(v) speedEnabled = v end
})

MainTab:AddSlider({
    Name = "Speed",
    Min = 16,
    Max = 200,
    Default = 50,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(v) speedValue = v end
})

task.spawn(function()
    while true do
        if speedEnabled then
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChild("Humanoid")
                    if hum then hum.WalkSpeed = speedValue end
                end
            end)
        end
        task.wait(0.1)
    end
end)

MainTab:AddSection({ Name = "Inf Jumps" })

local infJumpsEnabled = false

MainTab:AddToggle({
    Name = "Inf Jumps",
    Default = false,
    Callback = function(v) infJumpsEnabled = v end
})

UserInputService.JumpRequest:Connect(function()
    if not infJumpsEnabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)
end)

MainTab:AddSection({ Name = "Fly" })

local flyEnabled = false
local flySpeed = 50
local flyConnection = nil
local flyTween = nil

MainTab:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = function(v)
        flyEnabled = v
        if v then
            flyConnection = RunService.Heartbeat:Connect(function()
                if not flyEnabled then return end
                local char = LocalPlayer.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
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

MainTab:AddSlider({
    Name = "Fly Speed",
    Min = 10,
    Max = 200,
    Default = 50,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(v) flySpeed = v end
})

MainTab:AddSection({ Name = "Hip" })

MainTab:AddSlider({
    Name = "Hip Height",
    Min = 2,
    Max = 50,
    Default = 2,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Hip",
    Callback = function(v)
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then hum.HipHeight = v end
        end
    end
})

MainTab:AddSection({ Name = "Noclip" })

local noclipEnabled = false
local noclipConnection = nil

MainTab:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(v)
        noclipEnabled = v
        if v then
            noclipConnection = RunService.Stepped:Connect(function()
                if not noclipEnabled then return end
                local char = LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            end
        end
    end
})

MainTab:AddSection({ Name = "Hitboxes" })

local hitboxEnabled = false
local hitboxSize = 20
local hitboxVisible = 0.7

MainTab:AddToggle({
    Name = "Hitboxes",
    Default = false,
    Callback = function(v) hitboxEnabled = v end
})

MainTab:AddSlider({
    Name = "Hitbox Size",
    Min = 5,
    Max = 150,
    Default = 20,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Size",
    Callback = function(v) hitboxSize = v end
})

MainTab:AddSlider({
    Name = "Visibility",
    Min = 0,
    Max = 1,
    Default = 0.7,
    Color = Color3.fromRGB(255,255,255),
    Increment = 0.1,
    ValueName = "Vis",
    Callback = function(v) hitboxVisible = v end
})

RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp:IsA("BasePart") then
                if hitboxEnabled then
                    hrp.CanCollide = false
                    hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                    hrp.Transparency = hitboxVisible
                else
                    hrp.Transparency = 1
                    hrp.Size = Vector3.new(5, 5, 5)
                end
            end
        end
    end
end)

MainTab:AddSection({ Name = "ESP" })

local espEnabled = false
local tracersEnabled = false
local rainbowColor = false
local espColor = Color3.fromRGB(255, 0, 0)
local tracersColor = Color3.fromRGB(255, 255, 255)
local hue = 0

local espHighlights = {}
local tracerLines = {}

MainTab:AddToggle({
    Name = "ESP",
    Default = false,
    Callback = function(v) espEnabled = v end
})

MainTab:AddToggle({
    Name = "Tracers",
    Default = false,
    Callback = function(v) tracersEnabled = v end
})

MainTab:AddToggle({
    Name = "Rainbow",
    Default = false,
    Callback = function(v) rainbowColor = v end
})

MainTab:AddColorpicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(v) espColor = v end
})

MainTab:AddColorpicker({
    Name = "Tracers Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(v) tracersColor = v end
})

local function updateESP()
    for _, h in pairs(espHighlights) do
        h:Destroy()
    end
    table.clear(espHighlights)
    
    for _, line in pairs(tracerLines) do
        line:Remove()
    end
    table.clear(tracerLines)
    
    if not espEnabled and not tracersEnabled then return end
    
    local color = rainbowColor and Color3.fromHSV(hue, 1, 1) or espColor
    hue = (hue + 0.001) % 1
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                
                if espEnabled then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = player.Character
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillColor = color
                    highlight.Enabled = true
                    espHighlights[player] = highlight
                end
                
                if tracersEnabled and onScreen then
                    local line = Drawing.new("Line")
                    line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    line.To = Vector2.new(pos.X, pos.Y)
                    line.Color = rainbowColor and Color3.fromHSV(hue, 1, 1) or tracersColor
                    line.Thickness = 2
                    line.Transparency = 0.5
                    line.Visible = true
                    tracerLines[player] = line
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(updateESP)

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
