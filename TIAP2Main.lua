local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({Title = "TIAP2 script", Author = "by Likegenm", Icon = "solar:gamepad-bold", Theme = "Dark", NewElements = true, Transparent = false, ToggleKey = Enum.KeyCode.RightControl, Acrylic = false})

local MainTab = Window:Tab({Title = "Main", Icon = "solar:home-bold"})
local VisualTab = Window:Tab({Title = "Visual", Icon = "solar:eye-bold"})

local Players = game.Players
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

MainTab:Section({Title = "WalkSpeed"})
MainTab:Slider({Title = "WalkSpeed", Value = {Min = 16, Max = 100, Default = 16}, Callback = function(v) pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = v end) end})

MainTab:Section({Title = "Inf Jumps"})
local infJumps = false
MainTab:Toggle({Title = "Inf Jumps", Value = false, Callback = function(v) infJumps = v end})
UserInputService.JumpRequest:Connect(function() if infJumps then local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end end)

MainTab:Section({Title = "Gravity"})
MainTab:Slider({Title = "Gravity", Value = {Min = 0, Max = 400, Default = 196.2}, Callback = function(v) workspace.Gravity = v end})
MainTab:Button({Title = "Set Default Gravity", Callback = function() workspace.Gravity = 196.2 end})

MainTab:Section({Title = "Fly"})
local FLYING, flyConnection, flyTween, flySpeed = false, nil, nil, 50
MainTab:Toggle({Title = "Fly", Value = false, Callback = function(v)
    FLYING = v
    if v then
        local char = LocalPlayer.Character if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart") if not hrp then return end
        flyConnection = RunService.Heartbeat:Connect(function()
            if not FLYING then return end
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
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Velocity = Vector3.zero end
    end
end})
MainTab:Slider({Title = "Fly Speed", Value = {Min = 16, Max = 200, Default = 50}, Callback = function(v) flySpeed = v end})

MainTab:Section({Title = "AimLock"})
local aimLockEnabled, aimLockFOV, aimLockRainbow, aimLockHue = false, 150, false, 0
local aimLockCircle = Drawing.new("Circle")
aimLockCircle.Visible = false
aimLockCircle.Thickness = 2
aimLockCircle.Filled = false
aimLockCircle.NumSides = 60
aimLockCircle.Transparency = 0.7
MainTab:Toggle({Title = "AimLock", Value = false, Callback = function(v) aimLockEnabled = v; aimLockCircle.Visible = v end})
MainTab:Slider({Title = "FOV", Value = {Min = 5, Max = 300, Default = 150}, Callback = function(v) aimLockFOV = v end})
MainTab:Toggle({Title = "Rainbow", Value = false, Callback = function(v) aimLockRainbow = v end})
RunService.RenderStepped:Connect(function()
    aimLockCircle.Radius = aimLockFOV
    aimLockCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    if aimLockRainbow then aimLockHue = (aimLockHue+0.002)%1; aimLockCircle.Color = Color3.fromHSV(aimLockHue,1,1) end
    if not aimLockEnabled then return end
    if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local closest, minDist = nil, aimLockFOV
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local head = p.Character:FindFirstChild("Head")
            local hum = p.Character:FindFirstChild("Humanoid")
            if head and hum and hum.Health > 0 then
                if LocalPlayer.Team and p.Team == LocalPlayer.Team then continue end
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X,pos.Y)-center).Magnitude
                    if dist < minDist then minDist = dist; closest = p end
                end
            end
        end
    end
    if closest and closest.Character then
        local head = closest.Character:FindFirstChild("Head")
        if head then Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, head.Position) end
    end
end)

MainTab:Section({Title = "AttachAura"})
local attachAuraEnabled, attachAuraRadius, attachAuraRainbow, attachAuraHue = false, 10, false, 0
local attachAuraVisual, attachAuraHitbox = nil, nil
MainTab:Toggle({Title = "AttachAura", Value = false, Callback = function(v)
    attachAuraEnabled = v
    if v then
        attachAuraVisual = Instance.new("Part")
        attachAuraVisual.Name = "AttachAuraVisual"
        attachAuraVisual.Shape = Enum.PartType.Cylinder
        attachAuraVisual.Size = Vector3.new(0.1, attachAuraRadius, attachAuraRadius)
        attachAuraVisual.Anchored = true
        attachAuraVisual.CanCollide = false
        attachAuraVisual.Transparency = 0.5
        attachAuraVisual.Material = Enum.Material.Neon
        attachAuraVisual.Parent = workspace
        attachAuraHitbox = Instance.new("Part")
        attachAuraHitbox.Name = "AttachAuraHitbox"
        attachAuraHitbox.Shape = Enum.PartType.Cylinder
        attachAuraHitbox.Size = Vector3.new(10, attachAuraRadius, attachAuraRadius)
        attachAuraHitbox.Anchored = true
        attachAuraHitbox.CanCollide = false
        attachAuraHitbox.Transparency = 1
        attachAuraHitbox.Parent = workspace
    else
        if attachAuraVisual then attachAuraVisual:Destroy(); attachAuraVisual = nil end
        if attachAuraHitbox then attachAuraHitbox:Destroy(); attachAuraHitbox = nil end
    end
end})
MainTab:Slider({Title = "Radius", Value = {Min = 5, Max = 50, Default = 10}, Callback = function(v)
    attachAuraRadius = v
    if attachAuraVisual then attachAuraVisual.Size = Vector3.new(0.1, v, v) end
    if attachAuraHitbox then attachAuraHitbox.Size = Vector3.new(10, v, v) end
end})
MainTab:Toggle({Title = "Rainbow", Value = false, Callback = function(v) attachAuraRainbow = v end})
RunService.Heartbeat:Connect(function()
    if not attachAuraEnabled or not attachAuraVisual or not attachAuraHitbox then return end
    local char = LocalPlayer.Character
    if not char then return end
    local lf = char:FindFirstChild("LeftFoot") or char:FindFirstChild("Left Leg")
    local rf = char:FindFirstChild("RightFoot") or char:FindFirstChild("Right Leg")
    if not lf or not rf then return end
    local mid = (lf.Position + rf.Position) / 2
    local tp = mid - Vector3.new(0, 1, 0)
    local cf = CFrame.new(tp) * CFrame.Angles(0, 0, math.rad(90))
    TweenService:Create(attachAuraVisual, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {CFrame = cf}):Play()
    if attachAuraRainbow then attachAuraHue = (attachAuraHue+0.002)%1; attachAuraVisual.Color = Color3.fromHSV(attachAuraHue,1,1) end
    attachAuraHitbox.CFrame = cf
end)

MainTab:Section({Title = "AntiVoid"})
local avEnabled, avMode, avPlatform, avConnection, touchedPlatform = false, "Collide", nil, nil, false
MainTab:Dropdown({Title = "AntiVoid Mode", Value = "Collide", Values = {"Collide", "Velocity"}, Callback = function(v) avMode = v end})
MainTab:Toggle({Title = "Enable AntiVoid", Value = false, Callback = function(v)
    avEnabled = v
    if v then
        avPlatform = Instance.new("Part")
        avPlatform.Name = "AntiVoidPlatform"
        avPlatform.Size = Vector3.new(10, 1, 10)
        avPlatform.Anchored = true
        avPlatform.Transparency = 1
        avPlatform.Parent = workspace
        avPlatform.Touched:Connect(function() touchedPlatform = true end)
        avPlatform.TouchEnded:Connect(function() touchedPlatform = false end)
        avConnection = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local hrp = char.HumanoidRootPart
            avPlatform.CFrame = CFrame.new(hrp.Position.X, -10, hrp.Position.Z)
            if avMode == "Velocity" and touchedPlatform and hrp.Velocity.Y < 0 then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, math.abs(hrp.Velocity.Y)*2, hrp.Velocity.Z)
            end
        end)
    else
        if avConnection then avConnection:Disconnect(); avConnection = nil end
        if avPlatform then avPlatform:Destroy(); avPlatform = nil end
    end
end})

MainTab:Section({Title = "AutoWallHop"})
MainTab:Button({Title = "AutoWallHop", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/likegenmMain/Unknown/refs/heads/main/TIAP2WallHop.lua"))() end})

MainTab:Section({Title = "Jerk"})
MainTab:Button({Title = "Execute Jerk", Callback = function() loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))() loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))() end})

MainTab:Section({Title = "AntiTroll"})
MainTab:Button({Title = "AntiTroll", Callback = function()
    workspace.Pyong.CanCollide = true
    workspace.Pyong.Transparency = 0
    for _, p in ipairs(workspace.TrollPart1:GetChildren()) do
        if p:IsA("BasePart") then p.Transparency = 0; p.CanCollide = true end
    end
end})

MainTab:Section({Title = "GodMode"})
MainTab:Button({Title = "GodMode", Callback = function()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if (obj.Name == "KILLPART-5" or obj.Name == "KILLPART-100") and obj:IsA("BasePart") then
            obj.CanCollide = false
            obj.Transparency = 0.5
            for _, child in ipairs(obj:GetChildren()) do
                if child.Name == "TouchInterest" or child:IsA("TouchTransmitter") then child:Destroy() end
            end
        end
    end
end})

MainTab:Section({Title = "Teleports"})
local teleportKeybind = "T"
MainTab:Dropdown({Title = "Teleport Keybind", Value = "T", Values = {"T","R","F","G","H","V","B","N","M"}, Callback = function(v) teleportKeybind = v end})
local selectedTeleport = "Spawn"
MainTab:Dropdown({Title = "Select Teleport", Value = "Spawn", Values = {"Spawn","Void","Win","1 Troll","1 Troll Win","2 Troll","2 Troll Win","3 Troll","3 Troll Win","4 Troll","4 Troll Win","5 Troll","5 Troll Win"}, Callback = function(v) selectedTeleport = v end})
local coords = {
    ["Spawn"] = Vector3.new(-4.89, 3.15, -4.20),
    ["Void"] = Vector3.new(0, -4995, 0),
    ["Win"] = Vector3.new(289.38, 355.48, -36.20),
    ["1 Troll"] = Vector3.new(-14.53, 147.15, -79.24),
    ["1 Troll Win"] = Vector3.new(-64.61, 147.15, -80.11),
    ["2 Troll"] = Vector3.new(-77.90, 147.15, -67.78),
    ["2 Troll Win"] = Vector3.new(-77.26, 147.15, -4.42),
    ["3 Troll"] = Vector3.new(-76.17, 248.15, -63.63),
    ["3 Troll Win"] = Vector3.new(-77.43, 248.15, -1.34),
    ["4 Troll"] = Vector3.new(-37.11, 249.74, 20.99),
    ["4 Troll Win"] = Vector3.new(-48.20, 297.15, 8.80),
    ["5 Troll"] = Vector3.new(-6.85, 325.15, -63.77),
    ["5 Troll Win"] = Vector3.new(6.60, 347.15, -33.74)
}
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode[teleportKeybind] and selectedTeleport and coords[selectedTeleport] then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(coords[selectedTeleport])
        end
    end
end)
for name, pos in pairs(coords) do
    MainTab:Button({Title = name, Callback = function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(pos)
        end
    end})
end

MainTab:Section({Title = "SpinBot"})
local spinActive, spinSpeed = false, 10
MainTab:Toggle({Title = "SpinBot", Value = false, Callback = function(v) spinActive = v end})
MainTab:Slider({Title = "Spin Speed", Value = {Min = 1, Max = 50, Default = 10}, Callback = function(v) spinSpeed = v end})
RunService.Heartbeat:Connect(function()
    if not spinActive then return end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
    end
end)

MainTab:Section({Title = "Misc"})
local noclipActive = false
MainTab:Toggle({Title = "NoClip", Value = false, Callback = function(v) noclipActive = v end})
RunService.Stepped:Connect(function()
    if not noclipActive then return end
    local char = LocalPlayer.Character
    if char then for _, p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end end end
end)
MainTab:Button({Title = "Invisible", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/InvisforPhantasm.lua"))() end})

MainTab:Section({Title = "AntiCollide"})
MainTab:Button({Title = "AntiCollide", Callback = function()
    for _, p in ipairs(workspace:GetDescendants()) do
        if p.Name == "Part" and p:IsA("BasePart") and (p.Position == Vector3.new(194.21, 343.65, -43.70) or p.Position == Vector3.new(194.21, 343.65, -33.70)) then
            p.CanCollide = true
        end
    end
end})

MainTab:Section({Title = "AntiGroup"})
MainTab:Button({Title = "AntiGroup", Callback = function()
    workspace.Group.CanCollide = false
    workspace.Group.TouchInterest:Destroy()
    local sg = workspace.Group:FindFirstChild("SurfaceGui")
    if sg and sg:FindFirstChild("TextLabel") and sg.TextLabel.TextColor3 == Color3.fromRGB(255, 255, 0) then
        sg.Name = "SurfaceGui2"
        sg.TextLabel.Text = "By Likegenm"
    end
    workspace.Group.SurfaceGui.TextLabel.Text = "No Group"
end})

MainTab:Section({Title = "Orbit Players"})
local orbitActive, orbitSpeed, orbitRadius, orbitAngle = false, 2, 10, 0
local selectedOrbitPlayer = nil
local function getPlayers()
    local p = {}
    for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LocalPlayer then table.insert(p, plr.Name) end end
    return p
end
MainTab:Dropdown({Title = "Select Player", Value = "", Values = getPlayers(), Callback = function(v) selectedOrbitPlayer = Players:FindFirstChild(v) end})
MainTab:Toggle({Title = "Orbit Player", Value = false, Callback = function(v) orbitActive = v end})
MainTab:Slider({Title = "Orbit Speed", Value = {Min = 1, Max = 10, Default = 2}, Callback = function(v) orbitSpeed = v end})
MainTab:Slider({Title = "Orbit Radius", Value = {Min = 5, Max = 30, Default = 10}, Callback = function(v) orbitRadius = v end})
RunService.Heartbeat:Connect(function()
    if not orbitActive or not selectedOrbitPlayer or not selectedOrbitPlayer.Character then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local targetHrp = selectedOrbitPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHrp then return end
    orbitAngle = orbitAngle + orbitSpeed * 0.05
    hrp.CFrame = targetHrp.CFrame * CFrame.new(math.cos(orbitAngle)*orbitRadius, 0, math.sin(orbitAngle)*orbitRadius)
end)

MainTab:Section({Title = "Troll"})
local isTweening = false
local trollPaths = {
    {start = Vector3.new(-14.53, 147.15, -79.24), finish = Vector3.new(-64.61, 147.15, -80.11)},
    {start = Vector3.new(-77.90, 147.15, -67.78), finish = Vector3.new(-77.26, 147.15, -4.42)},
    {start = Vector3.new(-76.17, 248.15, -63.63), finish = Vector3.new(-77.43, 248.15, -1.34)}
}
for i, path in ipairs(trollPaths) do
    MainTab:Toggle({Title = "Troll "..i, Value = false, Callback = function(v)
        if v then
            isTweening = true
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local function move()
                if not isTweening then return end
                TweenService:Create(hrp, TweenInfo.new(1, Enum.EasingStyle.Linear), {CFrame = CFrame.new(path.finish)}):Play()
                task.wait(1)
                if not isTweening then return end
                TweenService:Create(hrp, TweenInfo.new(1, Enum.EasingStyle.Linear), {CFrame = CFrame.new(path.start)}):Play()
                task.wait(1)
                move()
            end
            task.spawn(move)
        else
            isTweening = false
        end
    end})
end

MainTab:Section({Title = "AutoTroll"})
local autoTouchConnection = nil
MainTab:Toggle({Title = "AutoTroll", Value = false, Callback = function(v)
    if v then
        autoTouchConnection = RunService.RenderStepped:Connect(function()
            pcall(function()
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, workspace.Gudock, 0)
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, workspace.Gudock, 1)
            end)
            for _, p in ipairs(workspace.TrollPart1:GetChildren()) do
                if p:IsA("BasePart") then
                    pcall(function()
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, p, 0)
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, p, 1)
                    end)
                end
            end
        end)
    else
        if autoTouchConnection then autoTouchConnection:Disconnect(); autoTouchConnection = nil end
    end
end})

VisualTab:Section({Title = "FOV"})
local fovValue = 70
VisualTab:Slider({Title = "FOV", Value = {Min = 70, Max = 120, Default = 70}, Callback = function(v) fovValue = v end})
RunService.RenderStepped:Connect(function() Camera.FieldOfView = fovValue end)

VisualTab:Section({Title = "Tracers"})
local tracersEnabled, tracersRainbow, tracersColor, tracersThickness, tracersHue = false, false, Color3.fromRGB(255, 255, 255), 2, 0
local tracerLines, lastTracerUpdate = {}, 0
VisualTab:Toggle({Title = "Tracers", Value = false, Callback = function(v)
    tracersEnabled = v
    if not v then for _, l in pairs(tracerLines) do l:Remove() end; table.clear(tracerLines) end
end})
VisualTab:Toggle({Title = "Rainbow", Value = false, Callback = function(v) tracersRainbow = v end})
VisualTab:Slider({Title = "Thickness", Value = {Min = 1, Max = 5, Default = 2}, Callback = function(v) tracersThickness = v end})
RunService.RenderStepped:Connect(function()
    if not tracersEnabled then return end
    if tick() - lastTracerUpdate < 1 then return end
    lastTracerUpdate = tick()
    for _, l in pairs(tracerLines) do l:Remove() end; table.clear(tracerLines)
    tracersHue = (tracersHue + 0.002) % 1
    local color = tracersRainbow and Color3.fromHSV(tracersHue, 1, 1) or tracersColor
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local head = p.Character:FindFirstChild("Head")
            if head then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local line = Drawing.new("Line")
                    line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    line.To = Vector2.new(pos.X, pos.Y)
                    line.Color = color
                    line.Thickness = tracersThickness
                    line.Transparency = 0.5
                    line.Visible = true
                    tracerLines[p] = line
                end
            end
        end
    end
end)

VisualTab:Section({Title = "ESP"})
local espEnabled, espRainbow, espColor, espTransparency, espHue = false, false, Color3.fromRGB(255, 0, 0), 0.5, 0
local espHighlights, lastEspUpdate = {}, 0
VisualTab:Toggle({Title = "ESP", Value = false, Callback = function(v)
    espEnabled = v
    if not v then for _, h in pairs(espHighlights) do h:Destroy() end; table.clear(espHighlights) end
end})
VisualTab:Toggle({Title = "Rainbow", Value = false, Callback = function(v) espRainbow = v end})
VisualTab:Slider({Title = "Transparency", Value = {Min = 0, Max = 1, Default = 0.5}, Callback = function(v) espTransparency = v end})
RunService.RenderStepped:Connect(function()
    if not espEnabled then return end
    if tick() - lastEspUpdate < 1 then return end
    lastEspUpdate = tick()
    for _, h in pairs(espHighlights) do h:Destroy() end; table.clear(espHighlights)
    espHue = (espHue + 0.002) % 1
    local color = espRainbow and Color3.fromHSV(espHue, 1, 1) or espColor
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hl = Instance.new("Highlight")
            hl.Parent = p.Character
            hl.FillTransparency = espTransparency
            hl.OutlineTransparency = 0
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.FillColor = color
            hl.Enabled = true
            espHighlights[p] = hl
        end
    end
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/BypassVoid.lua"))()
