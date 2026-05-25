local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Qanuir/orion-ui/refs/heads/main/source.lua"))()

local Window = OrionLib:MakeWindow({
    Name = "TIAP2 script",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionTest",
    IntroEnabled = true,
    IntroText = "by Likegenm",
    IntroIcon = nil
})

local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local VisualTab = Window:MakeTab({
    Name = "Visual",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Players = game.Players
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

MainTab:AddSection({ Name = "WalkSpeed" })
MainTab:AddSlider({
    Name = "WalkSpeed", Min = 16, Max = 100, Default = 16,
    Color = Color3.fromRGB(255, 255, 255), Increment = 1, ValueName = "WalkSpeed",
    Callback = function(Value)
        pcall(function() game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value end)
    end    
})

MainTab:AddSection({ Name = "Inf Jumps" })
local infJumps = false
MainTab:AddToggle({
    Name = "Inf Jumps", Default = false,
    Callback = function(Value) infJumps = Value end    
})
UserInputService.JumpRequest:Connect(function()
    if infJumps then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

MainTab:AddSection({ Name = "Gravity" })
local gravValue = 196.2
MainTab:AddSlider({
    Name = "Gravity", Min = 0, Max = 400, Default = 196.2,
    Color = Color3.fromRGB(255, 255, 255), Increment = 1, ValueName = "Gravity",
    Callback = function(Value) gravValue = Value; workspace.Gravity = Value end
})
MainTab:AddButton({
    Name = "Set Default Gravity",
    Callback = function() gravValue = 196.2; workspace.Gravity = 196.2 end
})

MainTab:AddSection({ Name = "Fly" })
FLYING = false; QEfly = true; iyflyspeed = 1; vehicleflyspeed = 1
local flyKeyDown, flyKeyUp
function sFLY(vfly)
    local plr = Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then repeat task.wait() until char:FindFirstChildOfClass("Humanoid"); humanoid = char:FindFirstChildOfClass("Humanoid") end
    if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect(); flyKeyUp:Disconnect() end
    local T = char:FindFirstChild("HumanoidRootPart")
    if not T then return end
    local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local SPEED = 0
    local function FLY()
        FLYING = true
        local BG = Instance.new('BodyGyro'); local BV = Instance.new('BodyVelocity')
        BG.P = 9e4; BG.Parent = T; BV.Parent = T
        BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9); BG.CFrame = T.CFrame
        BV.Velocity = Vector3.new(0, 0, 0); BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        task.spawn(function()
            repeat task.wait()
                local camera = workspace.CurrentCamera
                if not vfly and humanoid then humanoid.PlatformStand = true end
                if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then SPEED = 50
                elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then SPEED = 0 end
                if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
                    BV.Velocity = ((camera.CFrame.LookVector * (CONTROL.F + CONTROL.B)) + ((camera.CFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - camera.CFrame.p)) * SPEED
                    lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
                elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
                    BV.Velocity = ((camera.CFrame.LookVector * (lCONTROL.F + lCONTROL.B)) + ((camera.CFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - camera.CFrame.p)) * SPEED
                else BV.Velocity = Vector3.new(0, 0, 0) end
                BG.CFrame = camera.CFrame
            until not FLYING
            CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}; lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}; SPEED = 0
            BG:Destroy(); BV:Destroy()
            if humanoid then humanoid.PlatformStand = false end
        end)
    end
    flyKeyDown = UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.W then CONTROL.F = (vfly and vehicleflyspeed or iyflyspeed)
        elseif input.KeyCode == Enum.KeyCode.S then CONTROL.B = - (vfly and vehicleflyspeed or iyflyspeed)
        elseif input.KeyCode == Enum.KeyCode.A then CONTROL.L = - (vfly and vehicleflyspeed or iyflyspeed)
        elseif input.KeyCode == Enum.KeyCode.D then CONTROL.R = (vfly and vehicleflyspeed or iyflyspeed)
        elseif input.KeyCode == Enum.KeyCode.E and QEfly then CONTROL.Q = (vfly and vehicleflyspeed or iyflyspeed)*2
        elseif input.KeyCode == Enum.KeyCode.Q and QEfly then CONTROL.E = -(vfly and vehicleflyspeed or iyflyspeed)*2 end
        pcall(function() camera.CameraType = Enum.CameraType.Track end)
    end)
    flyKeyUp = UserInputService.InputEnded:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.W then CONTROL.F = 0
        elseif input.KeyCode == Enum.KeyCode.S then CONTROL.B = 0
        elseif input.KeyCode == Enum.KeyCode.A then CONTROL.L = 0
        elseif input.KeyCode == Enum.KeyCode.D then CONTROL.R = 0
        elseif input.KeyCode == Enum.KeyCode.E then CONTROL.Q = 0
        elseif input.KeyCode == Enum.KeyCode.Q then CONTROL.E = 0 end
    end)
    FLY()
end
MainTab:AddToggle({
    Name = "Fly", Default = false,
    Callback = function(Value)
        if Value then sFLY(false)
        else FLYING = false; if flyKeyDown then flyKeyDown:Disconnect() end; if flyKeyUp then flyKeyUp:Disconnect() end end
    end
})

MainTab:AddSection({ Name = "AimLock" })
local aimLockEnabled = false
local aimLockFOV = 150
local aimLockColor = Color3.fromRGB(255, 0, 0)
local aimLockRainbow = false
local aimLockHue = 0
local aimLockCircle = Drawing.new("Circle")
aimLockCircle.Visible = false; aimLockCircle.Thickness = 2; aimLockCircle.Filled = false; aimLockCircle.NumSides = 60; aimLockCircle.Transparency = 0.7

MainTab:AddToggle({
    Name = "AimLock", Default = false,
    Callback = function(v) aimLockEnabled = v; aimLockCircle.Visible = v end
})
MainTab:AddSlider({
    Name = "FOV", Min = 5, Max = 300, Default = 150,
    Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "Radius",
    Callback = function(v) aimLockFOV = v end
})
MainTab:AddColorpicker({ Name = "Color", Default = Color3.fromRGB(255, 0, 0), Callback = function(v) aimLockColor = v end })
MainTab:AddToggle({ Name = "Rainbow", Default = false, Callback = function(v) aimLockRainbow = v end })

RunService.RenderStepped:Connect(function()
    aimLockCircle.Radius = aimLockFOV
    aimLockCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    if aimLockRainbow then aimLockHue = (aimLockHue + 0.002) % 1; aimLockCircle.Color = Color3.fromHSV(aimLockHue, 1, 1)
    else aimLockCircle.Color = aimLockColor end
    if not aimLockEnabled then return end
    if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local closest, minDist = nil, aimLockFOV
    local myTeam = LocalPlayer.Team
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local head = p.Character:FindFirstChild("Head")
            local hum = p.Character:FindFirstChild("Humanoid")
            if head and hum and hum.Health > 0 then
                if myTeam and p.Team == myTeam then continue end
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
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

MainTab:AddSection({ Name = "AttachAura" })
local attachAuraEnabled = false
local attachAuraRadius = 10
local attachAuraColor = Color3.fromRGB(255, 0, 0)
local attachAuraRainbow = false
local attachAuraHue = 0
local attachAuraVisual, attachAuraHitbox

MainTab:AddToggle({
    Name = "AttachAura", Default = false,
    Callback = function(v)
        attachAuraEnabled = v
        if v then
            attachAuraVisual = Instance.new("Part"); attachAuraVisual.Name = "AttachAuraVisual"; attachAuraVisual.Shape = Enum.PartType.Cylinder
            attachAuraVisual.Size = Vector3.new(0.1, attachAuraRadius, attachAuraRadius)
            attachAuraVisual.Anchored = true; attachAuraVisual.CanCollide = false; attachAuraVisual.Transparency = 0.5; attachAuraVisual.Material = Enum.Material.Neon
            attachAuraVisual.Parent = workspace
            attachAuraHitbox = Instance.new("Part"); attachAuraHitbox.Name = "AttachAuraHitbox"; attachAuraHitbox.Shape = Enum.PartType.Cylinder
            attachAuraHitbox.Size = Vector3.new(10, attachAuraRadius, attachAuraRadius)
            attachAuraHitbox.Anchored = true; attachAuraHitbox.CanCollide = false; attachAuraHitbox.Transparency = 1
            attachAuraHitbox.Parent = workspace
        else
            if attachAuraVisual then attachAuraVisual:Destroy(); attachAuraVisual = nil end
            if attachAuraHitbox then attachAuraHitbox:Destroy(); attachAuraHitbox = nil end
        end
    end
})
MainTab:AddSlider({ Name = "Radius", Min = 5, Max = 50, Default = 10, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "Radius",
    Callback = function(v) attachAuraRadius = v; if attachAuraVisual then attachAuraVisual.Size = Vector3.new(0.1, v, v) end; if attachAuraHitbox then attachAuraHitbox.Size = Vector3.new(10, v, v) end end })
MainTab:AddColorpicker({ Name = "Color", Default = Color3.fromRGB(255, 0, 0), Callback = function(v) attachAuraColor = v end })
MainTab:AddToggle({ Name = "Rainbow", Default = false, Callback = function(v) attachAuraRainbow = v end })

RunService.Heartbeat:Connect(function()
    if not attachAuraEnabled or not attachAuraVisual or not attachAuraHitbox then return end
    local char = LocalPlayer.Character
    if not char then return end
    local leftFoot = char:FindFirstChild("LeftFoot") or char:FindFirstChild("Left Leg")
    local rightFoot = char:FindFirstChild("RightFoot") or char:FindFirstChild("Right Leg")
    if not leftFoot or not rightFoot then return end
    local midPos = (leftFoot.Position + rightFoot.Position) / 2
    local targetPos = midPos - Vector3.new(0, 1, 0)
    local cf = CFrame.new(targetPos) * CFrame.Angles(0, 0, math.rad(90))
    TweenService:Create(attachAuraVisual, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {CFrame = cf}):Play()
    if attachAuraRainbow then attachAuraHue = (attachAuraHue + 0.002) % 1; attachAuraVisual.Color = Color3.fromHSV(attachAuraHue, 1, 1)
    else attachAuraVisual.Color = attachAuraColor end
    attachAuraHitbox.CFrame = cf
    if workspace:FindFirstChild("TrollPart1") then
        for _, part in ipairs(workspace.TrollPart1:GetChildren()) do
            if part:IsA("BasePart") and (part.Position - targetPos).Magnitude <= attachAuraRadius then
                pcall(function() firetouchinterest(LocalPlayer.Character.HumanoidRootPart, part, 0); firetouchinterest(LocalPlayer.Character.HumanoidRootPart, part, 1) end)
            end
        end
    end
end)

MainTab:AddSection({ Name = "AntiVoid" })
local avEnabled = false
local avMode = "Collide"
local avPlatform = nil
local avConnection = nil
local touchedPlatform = false

MainTab:AddDropdown({
    Name = "AntiVoid Mode", Default = "Collide", Options = {"Collide", "Velocity"},
    Callback = function(v) avMode = v end
})
MainTab:AddToggle({
    Name = "Enable AntiVoid", Default = false,
    Callback = function(v)
        avEnabled = v
        if v then
            avPlatform = Instance.new("Part")
            avPlatform.Name = "AntiVoidPlatform"; avPlatform.Size = Vector3.new(10, 1, 10)
            avPlatform.Anchored = true; avPlatform.Transparency = 1; avPlatform.Parent = workspace
            avPlatform.Touched:Connect(function() touchedPlatform = true end)
            avPlatform.TouchEnded:Connect(function() touchedPlatform = false end)
            
            avConnection = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local hrp = char.HumanoidRootPart
                avPlatform.CFrame = CFrame.new(hrp.Position.X, -10, hrp.Position.Z)
                
                if avMode == "Collide" then
                    avPlatform.CanCollide = true
                elseif avMode == "Velocity" then
                    avPlatform.CanCollide = true
                    if touchedPlatform and hrp.Velocity.Y < 0 then
                        hrp.Velocity = Vector3.new(hrp.Velocity.X, math.abs(hrp.Velocity.Y) * 2, hrp.Velocity.Z)
                    end
                end
            end)
        else
            if avConnection then avConnection:Disconnect(); avConnection = nil end
            if avPlatform then avPlatform:Destroy(); avPlatform = nil end
        end
    end
})

MainTab:AddSection({ Name = "AutoWallHop" })
MainTab:AddButton({ Name = "AutoWallHop", Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/likegenmMain/Unknown/refs/heads/main/TIAP2WallHop.lua"))()
end})

MainTab:AddSection({ Name = "Jerk" })
MainTab:AddButton({ Name = "Execute Jerk", Callback = function()
    loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))()
    loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
end})

MainTab:AddSection({ Name = "AntiTroll" })
MainTab:AddButton({ Name = "AntiTroll", Callback = function()
    workspace.Pyong.CanCollide = true; workspace.Pyong.Transparency = 0
    for _, part in ipairs(workspace.TrollPart1:GetChildren()) do
        if part:IsA("BasePart") then part.Transparency = 0; part.CanCollide = true end
    end
end})

MainTab:AddSection({ Name = "GodMode" })
MainTab:AddButton({ Name = "GodMode", Callback = function()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if (obj.Name == "KILLPART-5" or obj.Name == "KILLPART-100") and obj:IsA("BasePart") then
            obj.CanCollide = false; obj.Transparency = 0.5
            for _, child in ipairs(obj:GetChildren()) do
                if child.Name == "TouchInterest" or child:IsA("TouchTransmitter") then child:Destroy() end
            end
        end
    end
end})

MainTab:AddSection({ Name = "Teleports" })
local teleportKeybind = Enum.KeyCode.T
MainTab:AddDropdown({ Name = "Teleport Keybind", Default = "T", Options = {"T", "R", "F", "G", "H", "V", "B", "N", "M"}, Callback = function(Value) teleportKeybind = Enum.KeyCode[Value] end })
local selectedTeleport = nil
MainTab:AddDropdown({ Name = "Select Teleport", Default = "Spawn",
    Options = {"Spawn", "Void", "Win", "1 Troll", "1 Troll Win", "2 Troll", "2 Troll Win", "3 Troll", "3 Troll Win", "4 Troll", "4 Troll Win", "5 Troll", "5 Troll Win"},
    Callback = function(Value) selectedTeleport = Value end })

local coords = {
    ["Spawn"] = Vector3.new(-4.8890862464904785, 3.146289587020874, -4.204310417175293),
    ["Void"] = Vector3.new(0, -4995, 0),
    ["Win"] = Vector3.new(289.3809814453125, 355.48162841796875, -36.19516372680664),
    ["1 Troll"] = Vector3.new(-14.532586097717285, 147.14627075195312, -79.24214172363281),
    ["1 Troll Win"] = Vector3.new(-64.614501953125, 147.14627075195312, -80.10725402832031),
    ["2 Troll"] = Vector3.new(-77.90444946289062, 147.14627075195312, -67.78023529052734),
    ["2 Troll Win"] = Vector3.new(-77.26180267333984, 147.14627075195312, -4.419360160827637),
    ["3 Troll"] = Vector3.new(-76.16581726074219, 248.14627075195312, -63.627479553222656),
    ["3 Troll Win"] = Vector3.new(-77.4281005859375, 248.14627075195312, -1.3375933170318604),
    ["4 Troll"] = Vector3.new(-37.111900329589844, 249.74163818359375, 20.985715866088867),
    ["4 Troll Win"] = Vector3.new(-48.20106506347656, 297.1462707519531, 8.803067207336426),
    ["5 Troll"] = Vector3.new(-6.850697994232178, 325.1462707519531, -63.76831817626953),
    ["5 Troll Win"] = Vector3.new(6.5985331535339355, 347.1462707519531, -33.738792419433594)
}

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == teleportKeybind and selectedTeleport and coords[selectedTeleport] then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CFrame = CFrame.new(coords[selectedTeleport]) end
    end
end)
for name, pos in pairs(coords) do
    MainTab:AddButton({ Name = name, Callback = function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CFrame = CFrame.new(pos) end
    end})
end

MainTab:AddSection({ Name = "SpinBot" })
local spinActive = false; local spinSpeed = 10
MainTab:AddToggle({ Name = "SpinBot", Default = false, Callback = function(Value) spinActive = Value end })
MainTab:AddSlider({ Name = "Spin Speed", Min = 1, Max = 50, Default = 10, Color = Color3.fromRGB(255, 255, 255), Increment = 1, ValueName = "Speed", Callback = function(Value) spinSpeed = Value end })
RunService.Heartbeat:Connect(function()
    if not spinActive then return end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0) end
end)

MainTab:AddSection({ Name = "Misc" })
local noclipActive = false
MainTab:AddToggle({ Name = "NoClip", Default = false, Callback = function(Value) noclipActive = Value end })
RunService.Stepped:Connect(function()
    if not noclipActive then return end
    local char = LocalPlayer.Character
    if char then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end end end
end)

MainTab:AddButton({ Name = "Invisible", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/InvisforPhantasm.lua"))() end })

MainTab:AddSection({ Name = "AntiCollide" })
MainTab:AddButton({ Name = "AntiCollide", Callback = function()
    for _, part in ipairs(workspace:GetDescendants()) do
        if part.Name == "Part" and part:IsA("BasePart") and (part.Position == Vector3.new(194.21, 343.65, -43.70) or part.Position == Vector3.new(194.21, 343.65, -33.70)) then part.CanCollide = true end
    end
end})

MainTab:AddSection({ Name = "AntiGroup" })
MainTab:AddButton({ Name = "AntiGroup", Callback = function()
    workspace.Group.CanCollide = false; workspace.Group.TouchInterest:Destroy()
    local sg = workspace.Group:FindFirstChild("SurfaceGui")
    if sg and sg:FindFirstChild("TextLabel") and sg.TextLabel.TextColor3 == Color3.fromRGB(255, 255, 0) then
        sg.Name = "SurfaceGui2"; sg.TextLabel.Text = "By Likegenm"
    end
    workspace.Group.SurfaceGui.TextLabel.Text = "No Group"
end})

MainTab:AddSection({ Name = "Orbit Players" })
local orbitActive = false; local orbitSpeed = 2; local orbitRadius = 10; local orbitAngle = 0
local selectedOrbitPlayer = nil
local function getPlayers()
    local p = {}; for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LocalPlayer then table.insert(p, plr.Name) end end; return p
end
MainTab:AddDropdown({ Name = "Select Player", Default = "", Options = getPlayers(), Callback = function(Value) selectedOrbitPlayer = Players:FindFirstChild(Value) end })
MainTab:AddToggle({ Name = "Orbit Player", Default = false, Callback = function(Value) orbitActive = Value end })
MainTab:AddSlider({ Name = "Orbit Speed", Min = 1, Max = 10, Default = 2, Color = Color3.fromRGB(255, 255, 255), Increment = 1, ValueName = "Speed", Callback = function(Value) orbitSpeed = Value end })
MainTab:AddSlider({ Name = "Orbit Radius", Min = 5, Max = 30, Default = 10, Color = Color3.fromRGB(255, 255, 255), Increment = 1, ValueName = "Radius", Callback = function(Value) orbitRadius = Value end })
RunService.Heartbeat:Connect(function()
    if not orbitActive or not selectedOrbitPlayer or not selectedOrbitPlayer.Character then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local targetHrp = selectedOrbitPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHrp then return end
    orbitAngle = orbitAngle + orbitSpeed * 0.05
    hrp.CFrame = targetHrp.CFrame * CFrame.new(math.cos(orbitAngle) * orbitRadius, 0, math.sin(orbitAngle) * orbitRadius)
end)

MainTab:AddSection({ Name = "Troll" })
local trollPaths = {
    { name = "Troll 1", start = Vector3.new(-14.53, 147.15, -79.24), finish = Vector3.new(-64.61, 147.15, -80.11) },
    { name = "Troll 2", start = Vector3.new(-77.90, 147.15, -67.78), finish = Vector3.new(-77.26, 147.15, -4.42) },
    { name = "Troll 3", start = Vector3.new(-76.17, 248.15, -63.63), finish = Vector3.new(-77.43, 248.15, -1.34) }
}
local isTweening = false
for _, path in pairs(trollPaths) do
    MainTab:AddToggle({ Name = path.name, Default = false, Callback = function(Value)
        if Value then isTweening = true
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local function move() if not isTweening then return end
                TweenService:Create(hrp, TweenInfo.new(1, Enum.EasingStyle.Linear), {CFrame = CFrame.new(path.finish)}):Play(); task.wait(1)
                if not isTweening then return end
                TweenService:Create(hrp, TweenInfo.new(1, Enum.EasingStyle.Linear), {CFrame = CFrame.new(path.start)}):Play(); task.wait(1); move()
            end; task.spawn(move)
        else isTweening = false end
    end})
end

MainTab:AddToggle({ Name = "AutoTroll", Default = false, Callback = function(Value)
    if Value then
        autoTouchConnection = RunService.RenderStepped:Connect(function()
            pcall(function() firetouchinterest(LocalPlayer.Character.HumanoidRootPart, workspace.Gudock, 0); firetouchinterest(LocalPlayer.Character.HumanoidRootPart, workspace.Gudock, 1) end)
            for _, part in ipairs(workspace.TrollPart1:GetChildren()) do
                if part:IsA("BasePart") then pcall(function() firetouchinterest(LocalPlayer.Character.HumanoidRootPart, part, 0); firetouchinterest(LocalPlayer.Character.HumanoidRootPart, part, 1) end) end
            end
        end)
    else if autoTouchConnection then autoTouchConnection:Disconnect(); autoTouchConnection = nil end end
end})

VisualTab:AddSection({ Name = "FOV" })
local fovValue = 70
VisualTab:AddSlider({ Name = "FOV", Min = 70, Max = 120, Default = 70, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "FOV", Callback = function(v) fovValue = v end })
RunService.RenderStepped:Connect(function() Camera.FieldOfView = fovValue end)

VisualTab:AddSection({ Name = "Tracers" })
local tracersEnabled = false; local tracersRainbow = false; local tracersColor = Color3.fromRGB(255, 255, 255); local tracersThickness = 2; local tracersHue = 0
local tracerLines = {}
local lastTracerUpdate = 0

VisualTab:AddToggle({ Name = "Tracers", Default = false, Callback = function(v) tracersEnabled = v; if not v then for _, l in pairs(tracerLines) do l:Remove() end; table.clear(tracerLines) end end })
VisualTab:AddToggle({ Name = "Rainbow", Default = false, Callback = function(v) tracersRainbow = v end })
VisualTab:AddColorpicker({ Name = "Color", Default = Color3.fromRGB(255, 255, 255), Callback = function(v) tracersColor = v end })
VisualTab:AddSlider({ Name = "Thickness", Min = 1, Max = 5, Default = 2, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "px", Callback = function(v) tracersThickness = v end })

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
                    local line = Drawing.new("Line"); line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y); line.To = Vector2.new(pos.X, pos.Y)
                    line.Color = color; line.Thickness = tracersThickness; line.Transparency = 0.5; line.Visible = true
                    tracerLines[p] = line
                end
            end
        end
    end
end)

VisualTab:AddSection({ Name = "ESP" })
local espEnabled = false; local espRainbow = false; local espColor = Color3.fromRGB(255, 0, 0); local espTransparency = 0.5; local espHue = 0
local espHighlights = {}
local lastEspUpdate = 0

VisualTab:AddToggle({ Name = "ESP", Default = false, Callback = function(v) espEnabled = v; if not v then for _, h in pairs(espHighlights) do h:Destroy() end; table.clear(espHighlights) end end })
VisualTab:AddToggle({ Name = "Rainbow", Default = false, Callback = function(v) espRainbow = v end })
VisualTab:AddColorpicker({ Name = "Color", Default = Color3.fromRGB(255, 0, 0), Callback = function(v) espColor = v end })
VisualTab:AddSlider({ Name = "Transparency", Min = 0, Max = 1, Default = 0.5, Color = Color3.fromRGB(255,255,255), Increment = 0.1, ValueName = "Transp", Callback = function(v) espTransparency = v end })

RunService.RenderStepped:Connect(function()
    if not espEnabled then return end
    if tick() - lastEspUpdate < 1 then return end
    lastEspUpdate = tick()
    
    for _, h in pairs(espHighlights) do h:Destroy() end; table.clear(espHighlights)
    espHue = (espHue + 0.002) % 1
    local color = espRainbow and Color3.fromHSV(espHue, 1, 1) or espColor
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hl = Instance.new("Highlight"); hl.Parent = p.Character; hl.FillTransparency = espTransparency; hl.OutlineTransparency = 0
            hl.OutlineColor = Color3.fromRGB(255, 255, 255); hl.FillColor = color; hl.Enabled = true
            espHighlights[p] = hl
        end
    end
end)

OrionLib:Init()

loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/BypassVoid.lua"))()
