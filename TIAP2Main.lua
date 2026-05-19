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

local Tab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local WSS = Tab:AddSection({
    Name = "WalkSpeed"
})

Tab:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 100,
    Default = 16,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "WalkSpeed",
    Callback = function(Value)
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end)
    end    
})

local JSection = Tab:AddSection({
    Name = "Inf Jumps"
})

local infJumps = false

Tab:AddToggle({
    Name = "Inf Jumps",
    Default = false,
    Callback = function(Value)
        infJumps = Value
    end    
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJumps then
        local char = game.Players.LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local GravitySection = Tab:AddSection({
    Name = "Gravity"
})

local gravValue = 196.2

Tab:AddSlider({
    Name = "Gravity",
    Min = 0,
    Max = 400,
    Default = 196.2,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Gravity",
    Callback = function(Value)
        gravValue = Value
        workspace.Gravity = Value
    end
})

Tab:AddButton({
    Name = "Set Default Gravity",
    Callback = function()
        gravValue = 196.2
        workspace.Gravity = 196.2
    end
})

local FlySection = Tab:AddSection({
    Name = "Fly"
})

local Players = game.Players
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

FLYING = false
QEfly = true
iyflyspeed = 1
vehicleflyspeed = 1

local flyKeyDown, flyKeyUp

function sFLY(vfly)
    local plr = Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        repeat task.wait() until char:FindFirstChildOfClass("Humanoid")
        humanoid = char:FindFirstChildOfClass("Humanoid")
    end

    if flyKeyDown or flyKeyUp then
        flyKeyDown:Disconnect()
        flyKeyUp:Disconnect()
    end

    local T = char:FindFirstChild("HumanoidRootPart")
    if not T then return end
    local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local SPEED = 0

    local function FLY()
        FLYING = true
        local BG = Instance.new('BodyGyro')
        local BV = Instance.new('BodyVelocity')
        BG.P = 9e4
        BG.Parent = T
        BV.Parent = T
        BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        BG.CFrame = T.CFrame
        BV.Velocity = Vector3.new(0, 0, 0)
        BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        task.spawn(function()
            repeat task.wait()
                local camera = workspace.CurrentCamera
                if not vfly and humanoid then
                    humanoid.PlatformStand = true
                end

                if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
                    SPEED = 50
                elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
                    SPEED = 0
                end
                if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
                    BV.Velocity = ((camera.CFrame.LookVector * (CONTROL.F + CONTROL.B)) + ((camera.CFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - camera.CFrame.p)) * SPEED
                    lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
                elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
                    BV.Velocity = ((camera.CFrame.LookVector * (lCONTROL.F + lCONTROL.B)) + ((camera.CFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - camera.CFrame.p)) * SPEED
                else
                    BV.Velocity = Vector3.new(0, 0, 0)
                end
                BG.CFrame = camera.CFrame
            until not FLYING
            CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            SPEED = 0
            BG:Destroy()
            BV:Destroy()

            if humanoid then humanoid.PlatformStand = false end
        end)
    end

    flyKeyDown = UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.W then
            CONTROL.F = (vfly and vehicleflyspeed or iyflyspeed)
        elseif input.KeyCode == Enum.KeyCode.S then
            CONTROL.B = - (vfly and vehicleflyspeed or iyflyspeed)
        elseif input.KeyCode == Enum.KeyCode.A then
            CONTROL.L = - (vfly and vehicleflyspeed or iyflyspeed)
        elseif input.KeyCode == Enum.KeyCode.D then
            CONTROL.R = (vfly and vehicleflyspeed or iyflyspeed)
        elseif input.KeyCode == Enum.KeyCode.E and QEfly then
            CONTROL.Q = (vfly and vehicleflyspeed or iyflyspeed)*2
        elseif input.KeyCode == Enum.KeyCode.Q and QEfly then
            CONTROL.E = -(vfly and vehicleflyspeed or iyflyspeed)*2
        end
        pcall(function() camera.CameraType = Enum.CameraType.Track end)
    end)

    flyKeyUp = UserInputService.InputEnded:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.W then
            CONTROL.F = 0
        elseif input.KeyCode == Enum.KeyCode.S then
            CONTROL.B = 0
        elseif input.KeyCode == Enum.KeyCode.A then
            CONTROL.L = 0
        elseif input.KeyCode == Enum.KeyCode.D then
            CONTROL.R = 0
        elseif input.KeyCode == Enum.KeyCode.E then
            CONTROL.Q = 0
        elseif input.KeyCode == Enum.KeyCode.Q then
            CONTROL.E = 0
        end
    end)
    FLY()
end

Tab:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = function(Value)
        if Value then
            sFLY(false)
        else
            FLYING = false
            if flyKeyDown then flyKeyDown:Disconnect() end
            if flyKeyUp then flyKeyUp:Disconnect() end
        end
    end
})

local JerkSection = Tab:AddSection({
    Name = "Jerk"
})

Tab:AddButton({
    Name = "Execute Jerk",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))()
        loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
    end
})

local AntiTrollSection = Tab:AddSection({
    Name = "AntiTroll"
})

Tab:AddButton({
    Name = "AntiTroll",
    Callback = function()
        game.Workspace.Pyong.CanCollide = true
        game.Workspace.Pyong.Transparency = 0
        for _, part in ipairs(game.workspace.TrollPart1:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
                part.CanCollide = true
            end
        end
    end
})

local GodModeSection = Tab:AddSection({Name = "GodMode"})

Tab:AddButton({
    Name = "GodMode",
    Callback = function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if (obj.Name == "KILLPART-5" or obj.Name == "KILLPART-100") and obj:IsA("BasePart") then
                obj.CanCollide = false
                obj.Transparency = 0.5
                for _, child in ipairs(obj:GetChildren()) do
                    if child.Name == "TouchInterest" or child:IsA("TouchTransmitter") then
                        child:Destroy()
                    end
                end
            end
        end
    end
})

local TPSection = Tab:AddSection({
    Name = "Teleports"
})

local teleportKeybind = Enum.KeyCode.T

Tab:AddDropdown({
    Name = "Teleport Keybind",
    Default = "T",
    Options = {"T", "R", "F", "G", "H", "V", "B", "N", "M"},
    Callback = function(Value)
        teleportKeybind = Enum.KeyCode[Value]
    end
})

local selectedTeleport = nil

Tab:AddDropdown({
    Name = "Select Teleport",
    Default = "Spawn",
    Options = {"Spawn", "Void", "Win", "1 Troll", "1 Troll Win", "2 Troll", "2 Troll Win", "3 Troll", "3 Troll Win", "4 Troll", "4 Troll Win", "5 Troll", "5 Troll Win"},
    Callback = function(Value)
        selectedTeleport = Value
    end
})

game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == teleportKeybind and selectedTeleport then
        local char = game.Players.LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        
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
        
        if coords[selectedTeleport] then
            char.HumanoidRootPart.CFrame = CFrame.new(coords[selectedTeleport])
        end
    end
end)

Tab:AddButton({Name = "Spawn", Callback = function() local char = game.Players.LocalPlayer.Character if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CFrame = CFrame.new(-4.8890862464904785, 3.146289587020874, -4.204310417175293) end end})
Tab:AddButton({Name = "Void", Callback = function() local char = game.Players.LocalPlayer.Character if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CFrame = CFrame.new(0, -4995, 0) end end})
Tab:AddButton({Name = "Win", Callback = function() local char = game.Players.LocalPlayer.Character if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CFrame = CFrame.new(289.3809814453125, 355.48162841796875, -36.19516372680664) end end})
Tab:AddButton({Name = "1 Troll", Callback = function() local char = game.Players.LocalPlayer.Character if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CFrame = CFrame.new(-14.532586097717285, 147.14627075195312, -79.24214172363281) end end})
Tab:AddButton({Name = "1 Troll Win", Callback = function() local char = game.Players.LocalPlayer.Character if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CFrame = CFrame.new(-64.614501953125, 147.14627075195312, -80.10725402832031) end end})
Tab:AddButton({Name = "2 Troll", Callback = function() local char = game.Players.LocalPlayer.Character if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CFrame = CFrame.new(-77.90444946289062, 147.14627075195312, -67.78023529052734) end end})
Tab:AddButton({Name = "2 Troll Win", Callback = function() local char = game.Players.LocalPlayer.Character if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CFrame = CFrame.new(-77.26180267333984, 147.14627075195312, -4.419360160827637) end end})
Tab:AddButton({Name = "3 Troll", Callback = function() local char = game.Players.LocalPlayer.Character if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CFrame = CFrame.new(-76.16581726074219, 248.14627075195312, -63.627479553222656) end end})
Tab:AddButton({Name = "3 Troll Win", Callback = function() local char = game.Players.LocalPlayer.Character if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CFrame = CFrame.new(-77.4281005859375, 248.14627075195312, -1.3375933170318604) end end})
Tab:AddButton({Name = "4 Troll", Callback = function() local char = game.Players.LocalPlayer.Character if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CFrame = CFrame.new(-37.111900329589844, 249.74163818359375, 20.985715866088867) end end})
Tab:AddButton({Name = "4 Troll Win", Callback = function() local char = game.Players.LocalPlayer.Character if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CFrame = CFrame.new(-48.20106506347656, 297.1462707519531, 8.803067207336426) end end})
Tab:AddButton({Name = "5 Troll", Callback = function() local char = game.Players.LocalPlayer.Character if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CFrame = CFrame.new(-6.850697994232178, 325.1462707519531, -63.76831817626953) end end})
Tab:AddButton({Name = "5 Troll Win", Callback = function() local char = game.Players.LocalPlayer.Character if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CFrame = CFrame.new(6.5985331535339355, 347.1462707519531, -33.738792419433594) end end})

local SpinSection = Tab:AddSection({Name = "SpinBot"})
local spinActive = false
local spinSpeed = 10
local spinConnection = nil
Tab:AddToggle({Name = "SpinBot", Default = false, Callback = function(Value)
    spinActive = Value
    if spinActive then
        spinConnection = game:GetService("RunService").Heartbeat:Connect(function()
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
            end
        end)
    else
        if spinConnection then spinConnection:Disconnect() spinConnection = nil end
    end
end})
Tab:AddSlider({Name = "Spin Speed", Min = 1, Max = 50, Default = 10, Color = Color3.fromRGB(255, 255, 255), Increment = 1, ValueName = "Speed", Callback = function(Value) spinSpeed = Value end})

local MiscSection = Tab:AddSection({Name = "Misc"})

local noclipActive = false
local noclipConnection = nil
Tab:AddToggle({Name = "NoClip", Default = false, Callback = function(Value)
    noclipActive = Value
    if noclipActive then
        noclipConnection = game:GetService("RunService").Stepped:Connect(function()
            local char = game.Players.LocalPlayer.Character
            if char then
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide then
                        v.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
        local char = game.Players.LocalPlayer.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end
    end
end})

Tab:AddButton({Name = "Invisible", Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/InvisforPhantasm.lua"))()
end})

local AntiCollideSection = Tab:AddSection({
    Name = "AntiCollide"
})

Tab:AddButton({
    Name = "AntiCollide",
    Callback = function()
        for _, part in ipairs(workspace:GetDescendants()) do
            if part.Name == "Part" and part:IsA("BasePart") then
                if (part.Position == Vector3.new(194.2142333984375, 343.64630126953125, -43.70063018798828)) or (part.Position == Vector3.new(194.2142333984375, 343.64630126953125, -33.70064163208008)) then
                    part.CanCollide = true
                end
            end
        end
    end
})

local AntiGroupSection = Tab:AddSection({
    Name = "AntiGroup"
})

Tab:AddButton({
    Name = "AntiGroup",
    Callback = function()
        game.Workspace.Group.CanCollide = false
        game.Workspace.Group.TouchInterest:Destroy()
        if game.Workspace.Group:FindFirstChild("SurfaceGui") and game.Workspace.Group.SurfaceGui:FindFirstChild("TextLabel") and game.Workspace.Group.SurfaceGui.TextLabel.TextColor3 == Color3.fromRGB(255, 255, 0) then
            game.Workspace.Group.SurfaceGui.Name = "SurfaceGui2"
            game.Workspace.Group.SurfaceGui2.TextLabel.Text = "By Likegenm"
        end
        game.Workspace.Group.SurfaceGui.TextLabel.Text = "No Group"
    end
})

local AVSection = Tab:AddSection({
    Name = "AntiVoid"
})

local avEnabled = false
local avPlatform = nil
local avConnection = nil

Tab:AddToggle({
    Name = "Enable AntiVoid",
    Default = false,
    Callback = function(Value)
        avEnabled = Value
        if avEnabled then
            local char = game.Players.LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            avPlatform = Instance.new("Part")
            avPlatform.Name = "AntiVoidPlatform"
            avPlatform.Size = Vector3.new(10, 1, 10)
            avPlatform.Anchored = true
            avPlatform.CanCollide = true
            avPlatform.Transparency = 1
            avPlatform.Parent = workspace
            
            avConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local char = game.Players.LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local hrp = char.HumanoidRootPart
                
                avPlatform.CFrame = CFrame.new(hrp.Position.X, -10, hrp.Position.Z)
            end)
        else
            if avConnection then
                avConnection:Disconnect()
                avConnection = nil
            end
            if avPlatform then
                avPlatform:Destroy()
                avPlatform = nil
            end
        end
    end
})

local OrbitSection = Tab:AddSection({Name = "Orbit Players"})

local orbitActive = false
local orbitSpeed = 2
local orbitRadius = 10
local orbitConnection = nil
local selectedOrbitPlayer = nil

local function getPlayers()
    local players = {}
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= game.Players.LocalPlayer then
            table.insert(players, plr.Name)
        end
    end
    return players
end

Tab:AddDropdown({
    Name = "Select Player",
    Default = "",
    Options = getPlayers(),
    Callback = function(Value)
        selectedOrbitPlayer = game.Players:FindFirstChild(Value)
    end
})

Tab:AddToggle({Name = "Orbit Player", Default = false, Callback = function(Value)
    orbitActive = Value
    if orbitActive and selectedOrbitPlayer then
        local char = game.Players.LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local angle = 0
        orbitConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if not orbitActive or not selectedOrbitPlayer or not selectedOrbitPlayer.Character then return end
            local targetHrp = selectedOrbitPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not targetHrp then return end
            
            angle = angle + orbitSpeed * 0.05
            local x = math.cos(angle) * orbitRadius
            local z = math.sin(angle) * orbitRadius
            hrp.CFrame = targetHrp.CFrame * CFrame.new(x, 0, z)
        end)
    else
        if orbitConnection then
            orbitConnection:Disconnect()
            orbitConnection = nil
        end
    end
end})

Tab:AddSlider({Name = "Orbit Speed", Min = 1, Max = 10, Default = 2, Color = Color3.fromRGB(255, 255, 255), Increment = 1, ValueName = "Speed", Callback = function(Value) orbitSpeed = Value end})

Tab:AddSlider({Name = "Orbit Radius", Min = 5, Max = 30, Default = 10, Color = Color3.fromRGB(255, 255, 255), Increment = 1, ValueName = "Radius", Callback = function(Value) orbitRadius = Value end})

local TrollSection = Tab:AddSection({Name = "Troll"})

local TweenService = game:GetService("TweenService")

local trollPaths = {
    {
        name = "Troll 1",
        start = Vector3.new(-14.532586097717285, 147.14627075195312, -79.24214172363281),
        finish = Vector3.new(-64.614501953125, 147.14627075195312, -80.10725402832031)
    },
    {
        name = "Troll 2",
        start = Vector3.new(-77.90444946289062, 147.14627075195312, -67.78023529052734),
        finish = Vector3.new(-77.26180267333984, 147.14627075195312, -4.419360160827637)
    },
    {
        name = "Troll 3",
        start = Vector3.new(-76.16581726074219, 248.14627075195312, -63.627479553222656),
        finish = Vector3.new(-77.4281005859375, 248.14627075195312, -1.3375933170318604)
    }
}

local tweenConnection = nil
local isTweening = false

for _, path in pairs(trollPaths) do
    Tab:AddToggle({
        Name = path.name,
        Default = false,
        Callback = function(Value)
            if Value then
                isTweening = true
                local char = game.Players.LocalPlayer.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                local function moveBackAndForth()
                    if not isTweening then return end
                    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                    local tweenToFinish = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(path.finish)})
                    tweenToFinish:Play()
                    tweenToFinish.Completed:Wait()
                    
                    if not isTweening then return end
                    local tweenToStart = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(path.start)})
                    tweenToStart:Play()
                    tweenToStart.Completed:Wait()
                    
                    moveBackAndForth()
                end
                
                moveBackAndForth()
            else
                isTweening = false
            end
        end
    })
end

Tab:AddToggle({
    Name = "AutoTroll",
    Default = false,
    Callback = function(Value)
        autoTouchActive = Value
        if autoTouchActive then
            autoTouchConnection = game:GetService("RunService").RenderStepped:Connect(function()
                pcall(function()
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, workspace.Gudock, 0)
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, workspace.Gudock, 1)
                end)
                for _, part in ipairs(game.workspace.TrollPart1:GetChildren()) do
                    if part:IsA("BasePart") then
                        pcall(function()
                            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, part, 0)
                            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, part, 1)
                        end)
                    end
                end
            end)
        else
            if autoTouchConnection then
                autoTouchConnection:Disconnect()
                autoTouchConnection = nil
            end
        end
    end
})

OrionLib:Init()

loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/BypassVoid.lua"))()
