local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()

local Window = Library:CreateWindow{
    Title = "Army RP ",
    SubTitle = "by Likegenm",
    TabWidth = 160,
    Size = UDim2.fromOffset(830, 525),
    Resize = true,
    MinSize = Vector2.new(470, 380),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
}

local Tabs = {
    Main = Window:CreateTab{
        Title = "Main",
        Icon = "home"
    },
    Aimbot = Window:CreateTab{
        Title = "Aimbot",
        Icon = "target"
    },
    Visuals = Window:CreateTab{
        Title = "Visuals",
        Icon = "eye"
    }
}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Wall Check Function
local function isBehindWall(player)
    local char = player.Character
    if not char then return true end
    local head = char:FindFirstChild("Head")
    if not head then return true end
    
    local cameraPos = Camera.CFrame.Position
    local targetPos = head.Position
    local direction = (targetPos - cameraPos)
    local distance = direction.Magnitude
    direction = direction.Unit
    
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, char}
    
    local rayResult = workspace:Raycast(cameraPos, direction * distance, rayParams)
    
    if rayResult then
        local hitPart = rayResult.Instance
        local hitChar = hitPart:FindFirstAncestorOfClass("Model")
        
        if hitChar == char then
            return false -- Луч попал в игрока, не за стеной
        else
            return true -- Луч попал в стену/парту, игрок за препятствием
        end
    end
    
    return false -- Нет препятствий
end

-- Aimbot
local aimbotEnabled = false
local aimbotTeamCheck = false
local aimbotWallCheck = false
local aimbotSmoothness = 1
local aimbotFOV = 100
local aimbotConnection = nil
local aimbotCircle = nil
local aimbotCircleConnection = nil
local aimbotShowFOV = false

-- Silent Aim
local silentAimEnabled = false
local silentAimTeamCheck = false
local silentAimWallCheck = false
local silentAimFOV = 100
local silentAimConnection = nil
local silentAimCircle = nil
local silentAimCircleConnection = nil
local silentAimShowFOV = false

local function isPlayerValid(player, teamCheck, wallCheck)
    if not player or player == LocalPlayer then return false end
    local char = player.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not head or not hum then return false end
    if hum.Health <= 0 then return false end
    
    if teamCheck then
        local localTeam = LocalPlayer.Team
        local playerTeam = player.Team
        if localTeam and playerTeam and localTeam == playerTeam then
            return false
        end
    end
    
    if wallCheck and isBehindWall(player) then
        return false
    end
    
    return true
end

local function getClosestPlayer(fov, teamCheck, wallCheck)
    local closest = nil
    local shortestDistance = fov
    
    for _, player in ipairs(Players:GetPlayers()) do
        if isPlayerValid(player, teamCheck, wallCheck) then
            local head = player.Character:FindFirstChild("Head")
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            
            if onScreen then
                local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                
                if distance < shortestDistance then
                    shortestDistance = distance
                    closest = player
                end
            end
        end
    end
    
    return closest
end

local function updateAimbotCircle()
    if not aimbotShowFOV or not aimbotCircle then return end
    local hue = tick() % 5 / 5
    aimbotCircle.Color = Color3.fromHSV(hue, 1, 1)
    aimbotCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    aimbotCircle.Radius = aimbotFOV
end

local function updateSilentAimCircle()
    if not silentAimShowFOV or not silentAimCircle then return end
    local hue = tick() % 5 / 5
    silentAimCircle.Color = Color3.fromHSV(hue, 1, 1)
    silentAimCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    silentAimCircle.Radius = silentAimFOV
end

local AimbotToggle = Tabs.Aimbot:CreateToggle("AimbotToggle", {
    Title = "Aimbot",
    Default = false
})

AimbotToggle:OnChanged(function(v)
    aimbotEnabled = v
    if aimbotEnabled then
        aimbotConnection = RunService.RenderStepped:Connect(function()
            if not aimbotEnabled then return end
            local target = getClosestPlayer(aimbotFOV, aimbotTeamCheck, aimbotWallCheck)
            if target and target.Character then
                local head = target.Character:FindFirstChild("Head")
                if head then
                    local cameraPos = Camera.CFrame.Position
                    local lookAt = CFrame.new(cameraPos, head.Position)
                    Camera.CFrame = Camera.CFrame:Lerp(lookAt, 1 / aimbotSmoothness)
                end
            end
        end)
    else
        if aimbotConnection then
            aimbotConnection:Disconnect()
            aimbotConnection = nil
        end
    end
end)

Tabs.Aimbot:CreateToggle("AimbotTeamCheck", {
    Title = "Team Check",
    Default = false
}):OnChanged(function(v)
    aimbotTeamCheck = v
end)

Tabs.Aimbot:CreateToggle("AimbotWallCheck", {
    Title = "Wall Check",
    Default = true
}):OnChanged(function(v)
    aimbotWallCheck = v
end)

local ShowFOVToggle = Tabs.Aimbot:CreateToggle("AimbotShowFOV", {
    Title = "Show FOV Circle",
    Default = false
})

ShowFOVToggle:OnChanged(function(v)
    aimbotShowFOV = v
    if aimbotShowFOV then
        aimbotCircle = Drawing.new("Circle")
        aimbotCircle.Visible = true
        aimbotCircle.Radius = aimbotFOV
        aimbotCircle.Thickness = 1.5
        aimbotCircle.Filled = false
        aimbotCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        aimbotCircleConnection = RunService.RenderStepped:Connect(updateAimbotCircle)
    else
        if aimbotCircle then
            aimbotCircle:Remove()
            aimbotCircle = nil
        end
        if aimbotCircleConnection then
            aimbotCircleConnection:Disconnect()
            aimbotCircleConnection = nil
        end
    end
end)

Tabs.Aimbot:CreateSlider("AimbotSmoothness", {
    Title = "Smoothness",
    Default = 1,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Callback = function(v)
        aimbotSmoothness = v
    end
})

Tabs.Aimbot:CreateSlider("AimbotFOV", {
    Title = "FOV Size",
    Default = 100,
    Min = 30,
    Max = 500,
    Rounding = 0,
    Callback = function(v)
        aimbotFOV = v
    end
})

-- Silent Aim
local SilentAimToggle = Tabs.Aimbot:CreateToggle("SilentAimToggle", {
    Title = "Silent Aim",
    Default = false
})

SilentAimToggle:OnChanged(function(v)
    silentAimEnabled = v
    if silentAimEnabled then
        silentAimConnection = RunService.RenderStepped:Connect(function()
            if not silentAimEnabled then return end
            local target = getClosestPlayer(silentAimFOV, silentAimTeamCheck, silentAimWallCheck)
            if target and target.Character then
                local head = target.Character:FindFirstChild("Head")
                if head then
                    local screenPos = Camera:WorldToViewportPoint(head.Position)
                    mousemoverel((screenPos.X - Mouse.X) * 0.3, (screenPos.Y - Mouse.Y) * 0.3)
                end
            end
        end)
    else
        if silentAimConnection then
            silentAimConnection:Disconnect()
            silentAimConnection = nil
        end
    end
end)

Tabs.Aimbot:CreateToggle("SilentAimTeamCheck", {
    Title = "Silent Team Check",
    Default = false
}):OnChanged(function(v)
    silentAimTeamCheck = v
end)

Tabs.Aimbot:CreateToggle("SilentAimWallCheck", {
    Title = "Silent Wall Check",
    Default = true
}):OnChanged(function(v)
    silentAimWallCheck = v
end)

local SilentShowFOVToggle = Tabs.Aimbot:CreateToggle("SilentAimShowFOV", {
    Title = "Silent Show FOV",
    Default = false
})

SilentShowFOVToggle:OnChanged(function(v)
    silentAimShowFOV = v
    if silentAimShowFOV then
        silentAimCircle = Drawing.new("Circle")
        silentAimCircle.Visible = true
        silentAimCircle.Radius = silentAimFOV
        silentAimCircle.Thickness = 1.5
        silentAimCircle.Filled = false
        silentAimCircle.Color = Color3.fromRGB(0, 255, 0)
        silentAimCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        silentAimCircleConnection = RunService.RenderStepped:Connect(updateSilentAimCircle)
    else
        if silentAimCircle then
            silentAimCircle:Remove()
            silentAimCircle = nil
        end
        if silentAimCircleConnection then
            silentAimCircleConnection:Disconnect()
            silentAimCircleConnection = nil
        end
    end
end)

Tabs.Aimbot:CreateSlider("SilentAimFOV", {
    Title = "Silent FOV Size",
    Default = 100,
    Min = 30,
    Max = 500,
    Rounding = 0,
    Callback = function(v)
        silentAimFOV = v
    end
})

-- Main Tab
local flyEnabled = false
local flySpeed = 200
local flyTween = nil
local flyConnection = nil

local FlyToggle = Tabs.Main:CreateToggle("FlyToggle", {
    Title = "Fly",
    Default = false
})

FlyToggle:OnChanged(function(v)
    flyEnabled = v
    if flyEnabled then
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
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
        if flyTween then flyTween:Cancel() flyTween = nil end
        if flyConnection then flyConnection:Disconnect() flyConnection = nil end
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.Velocity = Vector3.zero end
        end
    end
end)

Tabs.Main:CreateSlider("FlySpeed", {
    Title = "Fly Speed",
    Default = 200,
    Min = 100,
    Max = 1000,
    Rounding = 0,
    Callback = function(v)
        flySpeed = v
    end
})

local speedHackEnabled = false
local speedHackValue = 50
local speedHackConnection = nil

local SpeedToggle = Tabs.Main:CreateToggle("SpeedToggle", {
    Title = "SpeedHack",
    Default = false
})

SpeedToggle:OnChanged(function(v)
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
end)

Tabs.Main:CreateSlider("SpeedSlider", {
    Title = "SpeedHack Speed",
    Default = 50,
    Min = 10,
    Max = 500,
    Rounding = 0,
    Callback = function(v)
        speedHackValue = v
    end
})

local vehicleFlyEnabled = false
local vehicleFlySpeed = 200
local vehicleFlyConnection = nil

local VehicleFlyToggle = Tabs.Main:CreateToggle("VehicleFlyToggle", {
    Title = "Vehicle Fly",
    Default = false
})

VehicleFlyToggle:OnChanged(function(v)
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
end)

Tabs.Main:CreateSlider("VehicleFlySpeed", {
    Title = "Vehicle Fly Speed",
    Default = 200,
    Min = 100,
    Max = 1000,
    Rounding = 0,
    Callback = function(v)
        vehicleFlySpeed = v
    end
})

local vehicleTurboEnabled = false
local vehicleTurboSpeed = 100
local vehicleTurboConnection = nil

local VehicleTurboToggle = Tabs.Main:CreateToggle("VehicleTurboToggle", {
    Title = "Vehicle Turbo",
    Default = false
})

VehicleTurboToggle:OnChanged(function(v)
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
end)

Tabs.Main:CreateSlider("VehicleTurboSpeed", {
    Title = "Vehicle Turbo Speed",
    Default = 100,
    Min = 50,
    Max = 500,
    Rounding = 0,
    Callback = function(v)
        vehicleTurboSpeed = v
    end
})

local noclipEnabled = false
local noclipConnection = nil

local NoclipToggle = Tabs.Main:CreateToggle("NoclipToggle", {
    Title = "Noclip",
    Default = false
})

NoclipToggle:OnChanged(function(v)
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
end)

local noFallEnabled = false
local noFallConnection = nil

local NoFallToggle = Tabs.Main:CreateToggle("NoFallToggle", {
    Title = "NoFall",
    Default = false
})

NoFallToggle:OnChanged(function(v)
    noFallEnabled = v
    if noFallEnabled then
        noFallConnection = RunService.Heartbeat:Connect(function()
            if not noFallEnabled then return end
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local rayOrigin = hrp.Position
            local rayDirection = Vector3.new(0, -15, 0)
            local rayParams = RaycastParams.new()
            rayParams.FilterType = Enum.RaycastFilterType.Blacklist
            rayParams.FilterDescendantsInstances = {char}
            
            local rayResult = workspace:Raycast(rayOrigin, rayDirection, rayParams)
            
            if rayResult then
                local distanceToGround = (rayOrigin - rayResult.Position).Magnitude
                if distanceToGround <= 10 then
                    return
                end
                if distanceToGround <= 15 and hrp.Velocity.Y < 0 then
                    hrp.Velocity = Vector3.new(hrp.Velocity.X, hrp.Velocity.Y / 3, hrp.Velocity.Z)
                end
            end
        end)
    else
        if noFallConnection then
            noFallConnection:Disconnect()
            noFallConnection = nil
        end
    end
end)

local invisEnabled = false
local invisX = 99999999
local invisY = -99999999
local invisZ = 99999999

local function setTransparency(character, transparency)
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") then
            part.Transparency = transparency
        end
    end
end

local InvisToggle = Tabs.Main:CreateToggle("InvisToggle", {
    Title = "Invisible",
    Default = false
})

InvisToggle:OnChanged(function(v)
    invisEnabled = v
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    if invisEnabled then
        local savedpos = character.HumanoidRootPart.CFrame
        task.wait()
        character.HumanoidRootPart.CFrame = CFrame.new(invisX, invisY, invisZ)
        task.wait(0.15)
        
        local Seat = Instance.new('Seat', game.Workspace)
        Seat.Anchored = false
        Seat.CanCollide = false
        Seat.Name = 'invischair'
        Seat.Transparency = 1
        Seat.Position = Vector3.new(invisX, invisY, invisZ)
        
        local Weld = Instance.new("Weld", Seat)
        local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
        if torso then
            Weld.Part0 = Seat
            Weld.Part1 = torso
        end
        
        task.wait()
        Seat.CFrame = savedpos
        setTransparency(character, 0.5)
    else
        local chair = workspace:FindFirstChild('invischair')
        if chair then
            chair:Destroy()
        end
        setTransparency(character, 0)
    end
end)

-- Visuals Tab
Tabs.Visuals:CreateSlider("FOVSlider", {
    Title = "FOV",
    Default = 70,
    Min = 30,
    Max = 120,
    Rounding = 0,
    Callback = function(v)
        Camera.FieldOfView = v
    end
})

local fullbrightEnabled = false

local FullbrightToggle = Tabs.Visuals:CreateToggle("FullbrightToggle", {
    Title = "Fullbright",
    Default = false
})

FullbrightToggle:OnChanged(function(v)
    fullbrightEnabled = v
    if v then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.FogEnd = 999999
        Lighting.GlobalShadows = false
        Lighting.Outlines = false
        Lighting.ExposureCompensation = 1
    else
        Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        Lighting.OutdoorAmbient = Color3.fromRGB(105, 105, 105)
        Lighting.Brightness = 1
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
        Lighting.Outlines = true
        Lighting.ExposureCompensation = 0
    end
end)

local espEnabled = false
local espObjects = {}

local function createESP(player)
    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerESP"
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Adornee = player.Character
    highlight.Parent = player.Character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PlayerNameTag"
    billboard.Size = UDim2.new(4, 0, 1, 0)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = player.Character
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextSize = 16
    nameLabel.Parent = billboard
    
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = ""
    distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    distanceLabel.TextStrokeTransparency = 0
    distanceLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    distanceLabel.Font = Enum.Font.SourceSansBold
    distanceLabel.TextSize = 14
    distanceLabel.Parent = billboard
    
    local tracerLine = Drawing.new("Line")
    tracerLine.Thickness = 1
    tracerLine.Transparency = 0.7
    tracerLine.Visible = true
    
    table.insert(espObjects, {
        Player = player,
        Highlight = highlight,
        Billboard = billboard,
        NameLabel = nameLabel,
        DistanceLabel = distanceLabel,
        TracerLine = tracerLine
    })
end

local function removeESP(data)
    if data.Highlight then data.Highlight:Destroy() end
    if data.Billboard then data.Billboard:Destroy() end
    if data.TracerLine then data.TracerLine:Remove() end
end

local function clearAllESP()
    for _, data in ipairs(espObjects) do
        removeESP(data)
    end
    espObjects = {}
end

local function updateESP()
    local hue = tick() % 5 / 5
    local rainbowColor = Color3.fromHSV(hue, 1, 1)
    
    for _, data in ipairs(espObjects) do
        if data.Player.Character and data.Player.Character.Parent then
            local hrp = data.Player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                data.Highlight.FillColor = rainbowColor
                data.Highlight.OutlineColor = rainbowColor
                
                local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) and (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude or 0
                data.DistanceLabel.Text = string.format("%.0f studs", distance)
                
                local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    data.TracerLine.Visible = true
                    data.TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    data.TracerLine.To = Vector2.new(screenPos.X, screenPos.Y)
                    data.TracerLine.Color = rainbowColor
                else
                    data.TracerLine.Visible = false
                end
            end
        else
            data.TracerLine.Visible = false
        end
    end
end

local function refreshESP()
    clearAllESP()
    if espEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                createESP(player)
            end
        end
    end
end

local ESPToggle = Tabs.Visuals:CreateToggle("ESPToggle", {
    Title = "ESP",
    Default = false
})

ESPToggle:OnChanged(function(v)
    espEnabled = v
    if v then
        refreshESP()
        espConnection = RunService.RenderStepped:Connect(updateESP)
    else
        clearAllESP()
        if espConnection then
            espConnection:Disconnect()
            espConnection = nil
        end
    end
end)

Window:SelectTab(1)

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

while true do
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    
    if hum then
        if hum.Health <= 0 then
            hum.Health = hum.MaxHealth
        end
    end

    if char and char.PrimaryPart then
        local rootPos = char.PrimaryPart.Position
        p.Position = Vector3.new(rootPos.X, -5000, rootPos.Z)
    end
    
    task.wait(0.0000001)
end
