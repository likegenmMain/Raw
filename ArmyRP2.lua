local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

local Window = Library:CreateWindow{
    Title = "Army RP",
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
    Blatant = Window:CreateTab{Title = "Blatant", Icon = "zap"},
    Aimbot = Window:CreateTab{Title = "Aimbot", Icon = "target"},
    Visuals = Window:CreateTab{Title = "Visuals", Icon = "eye"},
    Settings = Window:CreateTab{Title = "Settings", Icon = "settings"}
}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local fovValue = 70

RunService.RenderStepped:Connect(function()
    Camera.FieldOfView = fovValue
end)

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
        if hitChar == char then return false end
        return true
    end
    return false
end

local aimbotEnabled = false
local aimbotTeamCheck = false
local aimbotWallCheck = false
local aimbotSmoothness = 1
local aimbotFOV = 100
local aimbotConnection = nil
local aimbotCircle = nil
local aimbotCircleConnection = nil
local aimbotShowFOV = false

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
        if localTeam and playerTeam and localTeam == playerTeam then return false end
    end
    if wallCheck and isBehindWall(player) then return false end
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

Tabs.Aimbot:CreateToggle("AimbotToggle", {Title = "Aimbot", Default = false}):OnChanged(function(v)
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
        if aimbotConnection then aimbotConnection:Disconnect() aimbotConnection = nil end
    end
end)

Tabs.Aimbot:CreateToggle("AimbotTeamCheck", {Title = "Team Check", Default = false}):OnChanged(function(v) aimbotTeamCheck = v end)
Tabs.Aimbot:CreateToggle("AimbotWallCheck", {Title = "Wall Check", Default = true}):OnChanged(function(v) aimbotWallCheck = v end)

Tabs.Aimbot:CreateToggle("AimbotShowFOV", {Title = "Show FOV Circle", Default = false}):OnChanged(function(v)
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
        if aimbotCircle then aimbotCircle:Remove() aimbotCircle = nil end
        if aimbotCircleConnection then aimbotCircleConnection:Disconnect() aimbotCircleConnection = nil end
    end
end)

Tabs.Aimbot:CreateSlider("AimbotSmoothness", {Title = "Smoothness", Default = 1, Min = 1, Max = 10, Rounding = 0, Callback = function(v) aimbotSmoothness = v end})
Tabs.Aimbot:CreateSlider("AimbotFOV", {Title = "FOV Size", Default = 100, Min = 30, Max = 500, Rounding = 0, Callback = function(v) aimbotFOV = v end})

Tabs.Aimbot:CreateToggle("SilentAimToggle", {Title = "Silent Aim", Default = false}):OnChanged(function(v)
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
        if silentAimConnection then silentAimConnection:Disconnect() silentAimConnection = nil end
    end
end)

Tabs.Aimbot:CreateToggle("SilentAimTeamCheck", {Title = "Silent Team Check", Default = false}):OnChanged(function(v) silentAimTeamCheck = v end)
Tabs.Aimbot:CreateToggle("SilentAimWallCheck", {Title = "Silent Wall Check", Default = true}):OnChanged(function(v) silentAimWallCheck = v end)

Tabs.Aimbot:CreateToggle("SilentAimShowFOV", {Title = "Silent Show FOV", Default = false}):OnChanged(function(v)
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
        if silentAimCircle then silentAimCircle:Remove() silentAimCircle = nil end
        if silentAimCircleConnection then silentAimCircleConnection:Disconnect() silentAimCircleConnection = nil end
    end
end)

Tabs.Aimbot:CreateSlider("SilentAimFOV", {Title = "Silent FOV Size", Default = 100, Min = 30, Max = 500, Rounding = 0, Callback = function(v) silentAimFOV = v end})

local spiderEnabled = false
local spiderSpeed = 30
local spiderConn = nil
local rayCheck = RaycastParams.new()
rayCheck.FilterType = Enum.RaycastFilterType.Blacklist

Tabs.Blatant:CreateToggle("SpiderToggle", {Title = "Spider (Wall Climb)", Default = false}):OnChanged(function(v)
    spiderEnabled = v
    if spiderConn then spiderConn:Disconnect() spiderConn = nil end
    if spiderEnabled then
        spiderConn = RunService.Heartbeat:Connect(function(dt)
            local char = LocalPlayer.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")
            if not root or not hum then return end
            rayCheck.FilterDescendantsInstances = {char, workspace.CurrentCamera}
            local vec = hum.MoveDirection * 2.5
            local ray = workspace:Raycast(root.Position - Vector3.new(0, 2, 0), vec, rayCheck)
            if ray and ray.Normal.Y == 0 then
                root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, spiderSpeed * dt * 60, root.AssemblyLinearVelocity.Z)
            end
        end)
    end
end)

Tabs.Blatant:CreateSlider("SpiderSpeed", {Title = "Spider Speed", Default = 30, Min = 10, Max = 100, Rounding = 0, Callback = function(v) spiderSpeed = v end})

local flyEnabled = false
local flySpeed = 200
local flyTween = nil
local flyConnection = nil

Tabs.Blatant:CreateToggle("FlyToggle", {Title = "Fly", Default = false}):OnChanged(function(v)
    flyEnabled = v
    if flyEnabled then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        flyConnection = RunService.Heartbeat:Connect(function()
            if not flyEnabled then return end
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
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
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Velocity = Vector3.zero end
    end
end)

Tabs.Blatant:CreateSlider("FlySpeed", {Title = "Fly Speed", Default = 200, Min = 100, Max = 1000, Rounding = 0, Callback = function(v) flySpeed = v end})

local speedHackEnabled = false
local speedHackValue = 50
local speedHackConnection = nil

Tabs.Blatant:CreateToggle("SpeedToggle", {Title = "SpeedHack", Default = false}):OnChanged(function(v)
    speedHackEnabled = v
    if speedHackEnabled then
        speedHackConnection = RunService.Heartbeat:Connect(function()
            if not speedHackEnabled then return end
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
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
        if speedHackConnection then speedHackConnection:Disconnect() speedHackConnection = nil end
    end
end)

Tabs.Blatant:CreateSlider("SpeedSlider", {Title = "SpeedHack Speed", Default = 50, Min = 10, Max = 500, Rounding = 0, Callback = function(v) speedHackValue = v end})

local vehicleFlyEnabled = false
local vehicleFlySpeed = 200
local vehicleFlyConnection = nil

Tabs.Blatant:CreateToggle("VehicleFlyToggle", {Title = "Vehicle Fly", Default = false}):OnChanged(function(v)
    vehicleFlyEnabled = v
    if vehicleFlyEnabled then
        vehicleFlyConnection = RunService.Heartbeat:Connect(function()
            if not vehicleFlyEnabled then return end
            local primaryPart = LocalPlayer.Character and (LocalPlayer.Character.PrimaryPart or LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
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
            if cameraLook.Magnitude > 0 then
                primaryPart.CFrame = CFrame.new(primaryPart.Position, primaryPart.Position + cameraLook.Unit)
            end
        end)
    else
        if vehicleFlyConnection then vehicleFlyConnection:Disconnect() vehicleFlyConnection = nil end
    end
end)

Tabs.Blatant:CreateSlider("VehicleFlySpeed", {Title = "Vehicle Fly Speed", Default = 200, Min = 100, Max = 1000, Rounding = 0, Callback = function(v) vehicleFlySpeed = v end})

local vehicleTurboEnabled = false
local vehicleTurboSpeed = 100
local vehicleTurboConnection = nil

Tabs.Blatant:CreateToggle("VehicleTurboToggle", {Title = "Vehicle Turbo", Default = false}):OnChanged(function(v)
    vehicleTurboEnabled = v
    if vehicleTurboEnabled then
        vehicleTurboConnection = RunService.Heartbeat:Connect(function()
            if not vehicleTurboEnabled then return end
            local primaryPart = LocalPlayer.Character and (LocalPlayer.Character.PrimaryPart or LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
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
            if cameraLook.Magnitude > 0 then
                primaryPart.CFrame = CFrame.new(primaryPart.Position, primaryPart.Position + cameraLook.Unit)
            end
        end)
    else
        if vehicleTurboConnection then vehicleTurboConnection:Disconnect() vehicleTurboConnection = nil end
    end
end)

Tabs.Blatant:CreateSlider("VehicleTurboSpeed", {Title = "Vehicle Turbo Speed", Default = 100, Min = 50, Max = 500, Rounding = 0, Callback = function(v) vehicleTurboSpeed = v end})

Tabs.Blatant:CreateToggle("NoclipToggle", {Title = "Noclip", Default = false}):OnChanged(function(v)
    if v then
        noclipConnection = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then for _, p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
    end
end)

Tabs.Blatant:CreateToggle("NoFallToggle", {Title = "NoFall", Default = false}):OnChanged(function(v)
    if v then
        noFallConnection = RunService.Heartbeat:Connect(function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local rayResult = workspace:Raycast(hrp.Position, Vector3.new(0, -15, 0), RaycastParams.new())
            if rayResult and (hrp.Position - rayResult.Position).Magnitude <= 15 and hrp.Velocity.Y < 0 then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, hrp.Velocity.Y / 3, hrp.Velocity.Z)
            end
        end)
    else
        if noFallConnection then noFallConnection:Disconnect() noFallConnection = nil end
    end
end)

Tabs.Visuals:CreateSlider("FOVSlider", {Title = "FOV", Default = 70, Min = 30, Max = 120, Rounding = 0, Callback = function(v)
    fovValue = v
end})

local fullbrightEnabled = false
Tabs.Visuals:CreateToggle("FullbrightToggle", {Title = "Fullbright", Default = false}):OnChanged(function(v)
    fullbrightEnabled = v
    if v then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.FogEnd = 999999
        Lighting.GlobalShadows = false
    else
        Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        Lighting.OutdoorAmbient = Color3.fromRGB(105, 105, 105)
        Lighting.Brightness = 1
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
    end
end)

local espEnabled = false
local espObjects = {}
local espConnection = nil

Tabs.Visuals:CreateToggle("ESPToggle", {Title = "ESP", Default = false}):OnChanged(function(v)
    espEnabled = v
    if v then
        espConnection = RunService.Heartbeat:Connect(function()
            task.wait(1)
            if not espEnabled then return end
            for i = #espObjects, 1, -1 do
                if not espObjects[i].Player.Character or not espObjects[i].Player.Character.Parent then
                    if espObjects[i].Highlight then espObjects[i].Highlight:Destroy() end
                    table.remove(espObjects, i)
                end
            end
            local hue = tick() % 5 / 5
            for _, data in ipairs(espObjects) do
                if data.Player.Character and data.Player.Character.Parent then
                    if not data.Highlight or not data.Highlight.Parent then
                        data.Highlight = Instance.new("Highlight")
                        data.Highlight.FillTransparency = 0.5
                        data.Highlight.OutlineTransparency = 0
                        data.Highlight.Adornee = data.Player.Character
                        data.Highlight.Parent = data.Player.Character
                        data.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    end
                    data.Highlight.FillColor = Color3.fromHSV(hue, 1, 1)
                    data.Highlight.OutlineColor = Color3.fromHSV(hue, 1, 1)
                end
            end
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local found = false
                    for _, data in ipairs(espObjects) do
                        if data.Player == player then found = true break end
                    end
                    if not found then
                        local hl = Instance.new("Highlight")
                        hl.FillTransparency = 0.5
                        hl.OutlineTransparency = 0
                        hl.Adornee = player.Character
                        hl.Parent = player.Character
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        table.insert(espObjects, {Player = player, Highlight = hl})
                    end
                end
            end
        end)
    else
        if espConnection then espConnection:Disconnect() espConnection = nil end
        for _, data in ipairs(espObjects) do
            if data.Highlight then data.Highlight:Destroy() end
        end
        espObjects = {}
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

Tabs.Blatant:CreateToggle("InvisToggle", {Title = "Invisible", Default = false}):OnChanged(function(v)
    invisEnabled = v
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
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
        if chair then chair:Destroy() end
        setTransparency(character, 0)
    end
end)

SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

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
    if hum and hum.Health <= 0 then hum.Health = hum.MaxHealth end
    if char and char.PrimaryPart then
        p.Position = Vector3.new(char.PrimaryPart.Position.X, -5000, char.PrimaryPart.Position.Z)
    end
    task.wait(0.0000001)
end

SaveManager:LoadAutoloadConfig()
