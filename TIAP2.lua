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

local WSSlider = Tab:AddSlider({
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

local FlySection = Tab:AddSection({Name = "Fly"})

local flying = false
local flySpeed = 50
local flyConnection = nil

Tab:AddToggle({Name = "Fly", Default = false, Callback = function(Value)
    flying = Value
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    if flying then
        hum.PlatformStand = true
        flyConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if not flying then return end
            local moveDir = Vector3.zero
            local uis = game:GetService("UserInputService")
            local camera = workspace.CurrentCamera
            if uis:IsKeyDown(Enum.KeyCode.W) then moveDir += camera.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.S) then moveDir -= camera.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.D) then moveDir += camera.CFrame.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.A) then moveDir -= camera.CFrame.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
            if uis:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir -= Vector3.new(0, 1, 0) end
            if moveDir.Magnitude > 0 then hrp.Velocity = moveDir.Unit * flySpeed else hrp.Velocity = Vector3.zero end
        end)
    else
        hum.PlatformStand = false
        if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    end
end})

Tab:AddSlider({Name = "Fly Speed", Min = 10, Max = 200, Default = 50, Color = Color3.fromRGB(255, 255, 255), Increment = 1, ValueName = "Speed", Callback = function(Value) flySpeed = Value end})

local FreezeSection = Tab:AddSection({Name = "Freeze"})
local freezeActive = false
Tab:AddToggle({Name = "Freeze on C", Default = false, Callback = function(Value) freezeActive = Value end})
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.C and freezeActive then
        pcall(function() game:GetService("ReplicatedStorage").Remotes.Damage:FireServer("Stun", "StunBeam") end)
    end
end)

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

OrionLib:Init()

loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/BypassVoid.lua"))()
