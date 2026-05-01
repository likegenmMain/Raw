local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()


local Window = Library:CreateWindow({
    Title = "Isle Script",
    Footer = "by Likegenm",
    ToggleKeybind = Enum.KeyCode.RightControl,
    Center = true,
    AutoShow = true
})

Library.ShowCustomCursor = false

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(newCharacter) 
    Character = newCharacter
    Humanoid = newCharacter:WaitForChild("Humanoid")
    HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
end)

local speedEnabled = false
local speedValue = 50
local infJumpEnabled = false
local flyEnabled = false
local flySpeed = 50
local flyBodyGyro
local noclipEnabled = false
local spinEnabled = false
local spinSpeed = 30
local fullbrightEnabled = false
local platformEnabled = false
local fovValue = 70

local platformConnection

local function createPlatform()
    if not workspace:FindFirstChild("FollowPlatform") then
        local p = Instance.new("Part")
        p.Name = "FollowPlatform"
        p.Size = Vector3.new(10,1,10)
        p.Anchored = true
        p.CanCollide = true
        p.Transparency = 1
        p.Color = Color3.fromRGB(100, 100, 255)
        p.Parent = workspace
    end
end

local function updatePlatform()
    if workspace:FindFirstChild("FollowPlatform") and Character and HumanoidRootPart then
        workspace.FollowPlatform.Position = Vector3.new(
            HumanoidRootPart.Position.X,
            -400,
            HumanoidRootPart.Position.Z
        )
    end
end

local function startPlatform()
    platformEnabled = true
    createPlatform()
    if platformConnection then
        platformConnection:Disconnect()
    end
    platformConnection = RunService.Heartbeat:Connect(updatePlatform)
end

local function stopPlatform()
    platformEnabled = false
    if platformConnection then
        platformConnection:Disconnect()
        platformConnection = nil
    end
    if workspace:FindFirstChild("FollowPlatform") then
        workspace.FollowPlatform:Destroy()
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.V then
        speedEnabled = not speedEnabled
        Library:Notify("Speed: " .. (speedEnabled and "ON" or "OFF"), 2)
    elseif input.KeyCode == Enum.KeyCode.J then
        infJumpEnabled = not infJumpEnabled
        Library:Notify("Infinite Jump: " .. (infJumpEnabled and "ON" or "OFF"), 2)
    elseif input.KeyCode == Enum.KeyCode.N then
        noclipEnabled = not noclipEnabled
        Library:Notify("Noclip: " .. (noclipEnabled and "ON" or "OFF"), 2)
    elseif input.KeyCode == Enum.KeyCode.Y then
        flyEnabled = not flyEnabled
        if flyEnabled then
            if Character and HumanoidRootPart then
                flyBodyGyro = Instance.new("BodyGyro")
                flyBodyGyro.P = 10000
                flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                flyBodyGyro.CFrame = HumanoidRootPart.CFrame
                flyBodyGyro.Parent = HumanoidRootPart
                Humanoid.PlatformStand = true
            end
        else
            if flyBodyGyro then
                flyBodyGyro:Destroy()
                flyBodyGyro = nil
            end
            if Character and Humanoid then
                Humanoid.PlatformStand = false
            end
        end
        Library:Notify("Fly: " .. (flyEnabled and "ON" or "OFF"), 2)
    end
end)

local InfoTab = Window:AddTab("Info", "info")

local LeftBox = InfoTab:AddLeftGroupbox("Player Info")

local playerId = LocalPlayer.UserId
local playerName = LocalPlayer.Name
local playerDisplayName = LocalPlayer.DisplayName
local accountAge = LocalPlayer.AccountAge

-- Картинка игрока большая
local imageHolder = LeftBox:AddLabel("")
imageHolder.TextLabel.Size = UDim2.new(1, 0, 0, 200)
imageHolder.TextLabel.Text = ""

local image = Instance.new("ImageLabel")
image.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. playerId .. "&width=720&height=720&format=png"
image.Size = UDim2.new(0, 200, 0, 200)
image.Position = UDim2.new(0.5, -100, 0, 0)
image.BackgroundTransparency = 1
image.Parent = imageHolder.TextLabel

LeftBox:AddDivider()

local idLabel = LeftBox:AddLabel("Player ID: " .. playerId)
idLabel.TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

local nameLabel = LeftBox:AddLabel("Username: " .. playerName)
nameLabel.TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

local displayNameLabel = LeftBox:AddLabel("Display Name: " .. playerDisplayName)
displayNameLabel.TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

local ageLabel = LeftBox:AddLabel("Account Age: " .. accountAge .. " days")
ageLabel.TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

LeftBox:AddDivider()

local ping = 0
local fps = 0
local lastIteration, frameCount = tick(), 0

local pingLabel = LeftBox:AddLabel("Ping: " .. ping .. " ms")
pingLabel.TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

local fpsLabel = LeftBox:AddLabel("FPS: " .. fps)
fpsLabel.TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

game:GetService("RunService").RenderStepped:Connect(function()
    frameCount = frameCount + 1
    
    if tick() - lastIteration >= 1 then
        fps = frameCount
        frameCount = 0
        lastIteration = tick()
        
        ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
        
        pingLabel.TextLabel.Text = "Ping: " .. ping .. " ms"
        fpsLabel.TextLabel.Text = "FPS: " .. fps
    end
end)

LeftBox:AddDivider()

local RightBox = InfoTab:AddRightGroupbox("Credits")

local creditsLabel = RightBox:AddLabel("Credits:")
creditsLabel.TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)

local allLabel = RightBox:AddLabel("All: Likegenm")
allLabel.TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)

local discordLabel = RightBox:AddLabel("Discord: https://discord.gg/K3nnT6yt")
discordLabel.TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)

RightBox:AddButton({
    Text = "Copy Discord Link",
    Func = function()
        setclipboard("https://discord.gg/K3nnT6yt")
        Library:Notify("Discord link copied!", 2)
    end
})

local MainTab = Window:AddTab("Main", "zap")

local MovementBox = MainTab:AddLeftGroupbox("Movement")

local SpeedToggle = MovementBox:AddToggle("SpeedToggle", {
    Text = "Speed Hack [V]",
    Default = false,
    Callback = function(state)
        speedEnabled = state
    end
})

MovementBox:AddSlider("SpeedSlider", {
    Text = "Speed Value",
    Default = 50,
    Min = 0,
    Max = 200,
    Rounding = 1,
    Callback = function(value)
        speedValue = value
    end
})

MovementBox:AddToggle("InfJumpToggle", {
    Text = "Infinite Jump [J]",
    Default = false,
    Callback = function(state)
        infJumpEnabled = state
    end
})

local FlyToggle = MovementBox:AddToggle("FlyToggle", {
    Text = "Fly [Y]",
    Default = false,
    Callback = function(state)
        flyEnabled = state
        if flyEnabled then
            if Character and HumanoidRootPart then
                flyBodyGyro = Instance.new("BodyGyro")
                flyBodyGyro.P = 10000
                flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                flyBodyGyro.CFrame = HumanoidRootPart.CFrame
                flyBodyGyro.Parent = HumanoidRootPart
                Humanoid.PlatformStand = true
            end
        else
            if flyBodyGyro then
                flyBodyGyro:Destroy()
                flyBodyGyro = nil
            end
            if Character and Humanoid then
                Humanoid.PlatformStand = false
            end
        end
    end
})

MovementBox:AddSlider("FlySpeedSlider", {
    Text = "Fly Speed",
    Default = 50,
    Min = 0,
    Max = 200,
    Rounding = 1,
    Callback = function(value)
        flySpeed = value
    end
})

MovementBox:AddToggle("NoclipToggle", {
    Text = "Noclip [N]",
    Default = false,
    Callback = function(state)
        noclipEnabled = state
    end
})

MovementBox:AddToggle("SpinToggle", {
    Text = "Spin",
    Default = false,
    Callback = function(state)
        spinEnabled = state
    end
})

MovementBox:AddSlider("SpinSpeedSlider", {
    Text = "Spin Speed",
    Default = 30,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Callback = function(value)
        spinSpeed = value
    end
})

MovementBox:AddSlider("FOVSlider", {
    Text = "FOV Changer",
    Default = 70,
    Min = 0,
    Max = 120,
    Rounding = 1,
    Callback = function(value)
        fovValue = value
        if workspace.CurrentCamera then
            workspace.CurrentCamera.FieldOfView = value
        end
    end
})

local TeleportBox = MainTab:AddRightGroupbox("Teleport")

TeleportBox:AddButton({
    Text = "Mouse Teleport (T)",
    Func = function()
        if Character and HumanoidRootPart then
            local mouse = LocalPlayer:GetMouse()
            local target = mouse.Hit.Position
            HumanoidRootPart.CFrame = CFrame.new(target + Vector3.new(0, 3, 0))
            Library:Notify("Mouse teleport!", 2)
        end
    end
})

TeleportBox:AddButton({
    Text = "Save Pos",
    Func = function()
        _G.pos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        Library:Notify("Position saved!", 3)
    end
})

TeleportBox:AddButton({
    Text = "Teleport to SavePos",
    Func = function()
        if _G.pos and Character and HumanoidRootPart then
            HumanoidRootPart.CFrame = CFrame.new(_G.pos)
            Library:Notify("Teleported to saved position!", 3)
        end
    end
})

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.T and Character and HumanoidRootPart then
        local mouse = LocalPlayer:GetMouse()
        local target = mouse.Hit.Position
        HumanoidRootPart.CFrame = CFrame.new(target + Vector3.new(0, 3, 0))
        Library:Notify("Mouse teleport!", 2)
    end
end)

RunService.Stepped:Connect(function()
    if noclipEnabled and Character then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if speedEnabled and Character and HumanoidRootPart then
        local cameraCFrame = Camera.CFrame
        local lookVector = cameraCFrame.LookVector
        local rightVector = cameraCFrame.RightVector
        
        local mv = Vector3.new(0, 0, 0)

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            mv = mv + Vector3.new(lookVector.X, 0, lookVector.Z).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            mv = mv - Vector3.new(lookVector.X, 0, lookVector.Z).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            mv = mv - Vector3.new(rightVector.X, 0, rightVector.Z).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            mv = mv + Vector3.new(rightVector.X, 0, rightVector.Z).Unit
        end
        
        if mv.Magnitude > 0 then
            HumanoidRootPart.Velocity = Vector3.new(
                mv.X * speedValue,
                HumanoidRootPart.Velocity.Y,
                mv.Z * speedValue
            )
        end
    end
    
    if infJumpEnabled and Character and HumanoidRootPart and Humanoid then
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            HumanoidRootPart.Velocity = Vector3.new(
                HumanoidRootPart.Velocity.X,
                50,
                HumanoidRootPart.Velocity.Z
            )
        end
    end
    
    if flyEnabled and Character and HumanoidRootPart and flyBodyGyro then
        local flyVelocity = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            flyVelocity = flyVelocity + (Camera.CFrame.LookVector * flySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            flyVelocity = flyVelocity - (Camera.CFrame.LookVector * flySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            flyVelocity = flyVelocity - (Camera.CFrame.RightVector * flySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            flyVelocity = flyVelocity + (Camera.CFrame.RightVector * flySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            flyVelocity = flyVelocity + Vector3.new(0, flySpeed, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            flyVelocity = flyVelocity - Vector3.new(0, flySpeed, 0)
        end
        
        HumanoidRootPart.Velocity = flyVelocity
        flyBodyGyro.CFrame = Camera.CFrame
    end
    
    if spinEnabled and Character and HumanoidRootPart then
        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
    end
    
    if platformEnabled then
        updatePlatform()
    end
    
    if workspace.CurrentCamera then
        workspace.CurrentCamera.FieldOfView = fovValue
    end
end)

local SpamBoardBox = MainTab:AddLeftGroupbox("Spammer Keycode")

local eSpammerRunning = false

SpamBoardBox:AddToggle("ESpammerToggle", {
    Text = "E Spammer",
    Default = false,
    Callback = function(state)
        eSpammerRunning = state
        if state then
            spawn(function()
                while eSpammerRunning do
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, nil)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, nil)
                    wait(0.01)
                end
            end)
        end
    end
})

local AutoFarmBox = MainTab:AddLeftGroupbox("AutoFarm")

AutoFarmBox:AddButton({
    Text = "AutoDrone",
    Func = function()
		_G.AD = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-95.67, 233.37, -2790.43) + Vector3.new(0, 5, 0)
		wait(0.5)
		game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, nil)
		wait(0.1)
		game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, nil)
		wait(0.1)
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(_G.AD)
		wait(0.1)
		local VIM = game:GetService("VirtualInputManager")
        for _, item in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if item.Name:find("Assistant Drone") then
                item.Parent = game.Players.LocalPlayer.Character
                wait(0.2)
                VIM:SendMouseButtonEvent(500, 500, 0, true, game, 1)
                wait(0.1)
                VIM:SendMouseButtonEvent(500, 500, 0, false, game, 1)
                break
            end
        end
    end
})

AutoFarmBox:AddButton({
    Text = "AutoFarm Owl Observer",
    Func = function()
		_G.AOO = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1382.51, 178.06, -1487.28) + Vector3.new(0, 5, 0)
		wait(0.5)
		game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, nil)
		wait(0.1)
		game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, nil)
		wait(0.1)
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(_G.AOO)
		wait(0.1)
		local VIM = game:GetService("VirtualInputManager")
        for _, item in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if item.Name:find("Owl Observer") then
                item.Parent = game.Players.LocalPlayer.Character
                wait(0.2)
                VIM:SendMouseButtonEvent(500, 500, 0, true, game, 1)
                wait(0.1)
                VIM:SendMouseButtonEvent(500, 500, 0, false, game, 1)
                break
            end
        end
	end
})

AutoFarmBox:AddButton({
    Text = "AutoFarm Katana/Steel Sword",
    Func = function()
        _G.KP = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1832.76, -188.49, -1277.78) + Vector3.new(0, 5, 0)
        wait(0.5)
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, nil)
        wait(0.1)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, nil)
        wait(0.1)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(_G.KP)
        wait(0.5)
        local VIM = game:GetService("VirtualInputManager")
        for _, item in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if item.Name:find("Katana") or item.Name:find("Steel Sword") then
                item.Parent = game.Players.LocalPlayer.Character
                wait(0.2)
                VIM:SendMouseButtonEvent(500, 500, 0, true, game, 1)
                wait(0.1)
                VIM:SendMouseButtonEvent(500, 500, 0, false, game, 1)
                break
            end
        end
    end
})

AutoFarmBox:AddButton({
    Text = "AutoGenerators",
    Func = function()
        local TweenService = game:GetService("TweenService")
        local VIM = game:GetService("VirtualInputManager")
        local player = game.Players.LocalPlayer
        local character = player.Character
        local humanoidRootPart = character.HumanoidRootPart
        
        local oldNoclip = noclipEnabled
        noclipEnabled = true
        
        local function equipAllFuses()
            for _, item in pairs(player.Backpack:GetChildren()) do
                if item.Name:find("Fuse") then
                    item.Parent = character
                    wait(0.2)
                    VIM:SendMouseButtonEvent(500, 500, 0, true, game, 1)
                    wait(0.1)
                    VIM:SendMouseButtonEvent(500, 500, 0, false, game, 1)
                    wait(0.2)
                end
            end
        end
        
        local function clearNonFuseItems()
            for _, item in pairs(player.Backpack:GetChildren()) do
                if not item.Name:find("Fuse") then
                    item.Parent = character
                    wait(0.2)
                    VIM:SendMouseButtonEvent(500, 500, 0, true, game, 1)
                    wait(0.1)
                    VIM:SendMouseButtonEvent(500, 500, 0, false, game, 1)
                    wait(0.2)
                    item:Destroy()
                end
            end
        end
        
        local savedPos = humanoidRootPart.Position
        
        if #player.Backpack:GetChildren() == 0 then
            local storagePos = Vector3.new(-826.4652709960938, 70.46780395507812, -599.8519287109375)
            humanoidRootPart.CFrame = CFrame.new(storagePos)
            wait(0.5)
            
            local tweenDown = TweenService:Create(
                humanoidRootPart,
                TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                {CFrame = CFrame.new(storagePos - Vector3.new(0, 5, 0))}
            )
            tweenDown:Play()
            tweenDown.Completed:Wait()
            wait(0.5)
            
            VIM:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
            wait(0.1)
            VIM:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
            wait(0.5)
            
            local tweenUp = TweenService:Create(
                humanoidRootPart,
                TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                {CFrame = CFrame.new(storagePos)}
            )
            tweenUp:Play()
            tweenUp.Completed:Wait()
        end
        
        clearNonFuseItems()
        
        local generators = {}
        for i = 1, 1000 do
            local fuse = workspace:FindFirstChild("Map"):FindFirstChild("Ignore"):FindFirstChild("Tools"):FindFirstChild("Fuse#" .. i)
            if fuse then
                table.insert(generators, fuse)
            end
        end
        
        for i = 1, 6 do
            if generators[i] then
                humanoidRootPart.CFrame = generators[i].CFrame + Vector3.new(0, 5, 0)
                wait(0.5)
                VIM:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
                wait(0.1)
                VIM:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
                wait(0.5)
                
                equipAllFuses()
                wait(0.5)
            end
        end
        
        local pos1 = Vector3.new(525.6123657226562, -3.598816394805908, -510.3340148925781)
        
        for repeatCount = 1, 3 do
            humanoidRootPart.CFrame = CFrame.new(pos1)
            wait(0.5)
            
            local tween1 = TweenService:Create(
                humanoidRootPart,
                TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                {CFrame = CFrame.new(pos1 + Vector3.new(0, 5, 0))}
            )
            tween1:Play()
            tween1.Completed:Wait()
            
            wait(0.2)
            
            VIM:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
            wait(0.1)
            VIM:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
            wait(0.5)
            
            equipAllFuses()
            wait(0.5)
            
            local tween2 = TweenService:Create(
                humanoidRootPart,
                TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                {CFrame = CFrame.new(pos1)}
            )
            tween2:Play()
            tween2.Completed:Wait()
            
            wait(0.5)
        end
        
        local pos2 = Vector3.new(524.2295532226562, -3.8193211555480957, -508.0196228027344)
        
        for repeatCount = 1, 3 do
            humanoidRootPart.CFrame = CFrame.new(pos2)
            wait(0.5)
            
            local tween3 = TweenService:Create(
                humanoidRootPart,
                TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                {CFrame = CFrame.new(pos2 + Vector3.new(0, 5, 0))}
            )
            tween3:Play()
            tween3.Completed:Wait()
            
            wait(0.2)
            
            VIM:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
            wait(0.1)
            VIM:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
            wait(0.5)
            
            equipAllFuses()
            wait(0.5)
            
            local tween4 = TweenService:Create(
                humanoidRootPart,
                TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                {CFrame = CFrame.new(pos2)}
            )
            tween4:Play()
            tween4.Completed:Wait()
            
            wait(0.5)
        end
        
        noclipEnabled = oldNoclip
        
        humanoidRootPart.CFrame = CFrame.new(savedPos)
        Library:Notify("AutoGenerators completed!", 3)
    end
})

local TeleportTab = Window:AddTab("Teleport", "map-pin")

local ImportantBox = TeleportTab:AddLeftGroupbox("Important Locations")

local importantTeleports = {
    {"Lair", Vector3.new(-1677.50, -16.46, -517.84)},
    {"LightHouse", Vector3.new(-1545.85, 226.78, -198.82)},
    {"Facility", Vector3.new(-1617.14, -41.38, -1534.31)},
    {"Facility v2", Vector3.new(-1786.97, -193.03, -1368.30)},
    {"Ship", Vector3.new(-340.64, 12.05, 894.64)},
    {"Ship v2", Vector3.new(-344.97, 28.78, 844.50)},
    {"Observatory", Vector3.new(467.98, 150.34, -1216.91)},
    {"Dome", Vector3.new(-812.90, 303.50, -1373.33)},
    {"Hangar", Vector3.new(-1618.50, 22.02, -2373.56)}
}

for _, btn in pairs(importantTeleports) do
    ImportantBox:AddButton({
        Text = btn[1],
        Func = function()
            if Character and HumanoidRootPart then
                HumanoidRootPart.CFrame = CFrame.new(btn[2])
                Library:Notify("Teleported to " .. btn[1], 3)
            end
        end
    })
end

local ArtifactsBox = TeleportTab:AddRightGroupbox("Artifacts")

local artifactTeleports = {
    {"Artifact A", Vector3.new(-1347.18, -456.25, -1568.46)},
    {"Artifact B", Vector3.new(1405.43, -249.38, -1851.34)},
    {"Artifact C", Vector3.new(-753.34, 126.10, -3172.48)},
    {"Artifact D", Vector3.new(-1767.44, -190.47, -1296.23)}
}

for _, btn in pairs(artifactTeleports) do
    ArtifactsBox:AddButton({
        Text = btn[1],
        Func = function()
            if Character and HumanoidRootPart then
                HumanoidRootPart.CFrame = CFrame.new(btn[2])
                Library:Notify("Teleported to " .. btn[1], 3)
            end
        end
    })
end

local BuildingsBox = TeleportTab:AddLeftGroupbox("Buildings")

local buildingTeleports = {
    {"Military Camp", Vector3.new(-1069.08, 265.76, -1820.14)},
    {"Docks", Vector3.new(-2003.32, 6.12, -1554.91)},
    {"Generators", Vector3.new(548.08, -3.36, -543.73)},
    {"Radio Station", Vector3.new(-1061.86, 499.19, -1391.46)},
    {"GreenHouse", Vector3.new(-1365.93, 305.96, -1217.68)},
    {"Hunting House", Vector3.new(-664.69, 139.33, -296.46)},
    {"WareHouse", Vector3.new(-826.02, 62.19, -562.24)}
}

for _, btn in pairs(buildingTeleports) do
    BuildingsBox:AddButton({
        Text = btn[1],
        Func = function()
            if Character and HumanoidRootPart then
                HumanoidRootPart.CFrame = CFrame.new(btn[2])
                Library:Notify("Teleported to " .. btn[1], 3)
            end
        end
    })
end

local ItemsBox = TeleportTab:AddRightGroupbox("Items & Misc")

local itemTeleports = {
    {"Drone", Vector3.new(-95.67, 233.37, -2790.43)},
    {"Ballistic Vest", Vector3.new(-714.69, -5.38, 869.87)},
    {"Gatling Room", Vector3.new(-1375.45, 179.03, -1501.44)}
}

for _, btn in pairs(itemTeleports) do
    ItemsBox:AddButton({
        Text = btn[1],
        Func = function()
            if Character and HumanoidRootPart then
                HumanoidRootPart.CFrame = CFrame.new(btn[2])
                Library:Notify("Teleported to " .. btn[1], 3)
            end
        end
    })
end

local VisualTab = Window:AddTab("Visual", "eye")

local LightingBox = VisualTab:AddLeftGroupbox("Lighting")

LightingBox:AddToggle("FullbrightToggle", {
    Text = "Fullbright",
    Default = false,
    Callback = function(state)
        fullbrightEnabled = state
        if state then
            task.spawn(function()
                while fullbrightEnabled do
                    Lighting.GlobalShadows = false
                    Lighting.FogEnd = 100000
                    Lighting.Brightness = 2
                    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
                    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
                    Lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
                    Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
                    task.wait(0.1)
                end
            end)
        else
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 50000
            Lighting.Brightness = 1
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            Lighting.Ambient = Color3.fromRGB(0.5, 0.5, 0.5)
            Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
            Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
        end
    end
})

local FPSBox = VisualTab:AddRightGroupbox("FPS Boost")

FPSBox:AddButton({
    Text = "Remove Textures",
    Func = function()
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                if part:FindFirstChildWhichIsA("Decal") then
                    for _, decal in pairs(part:GetChildren()) do
                        if decal:IsA("Decal") then
                            decal:Destroy()
                        end
                    end
                end
                if part:FindFirstChildOfClass("Texture") then
                    part.Texture = ""
                end
                part.Material = Enum.Material.Plastic
                part.Color = Color3.fromRGB(150, 150, 150)
            end
        end
        Library:Notify("Textures removed!", 3)
    end
})

local XRayBox = VisualTab:AddLeftGroupbox("X-Ray")

local xrayEnabled = false
local originalMaterials = {}

XRayBox:AddToggle("XRayToggle", {
    Text = "X-Ray",
    Default = false,
    Callback = function(state)
        xrayEnabled = state
        if state then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v:IsDescendantOf(Players.LocalPlayer.Character) then
                    if not originalMaterials[v] then
                        originalMaterials[v] = v.Material
                    end
                    if v.Transparency < 0.5 then
                        v.Transparency = 0.5
                    end
                    v.Material = Enum.Material.ForceField
                end
            end
        else
            for v, material in pairs(originalMaterials) do
                if v and v.Parent then
                    v.Material = material
                    if v.Transparency == 0.5 then
                        v.Transparency = 0
                    end
                end
            end
            originalMaterials = {}
        end
    end
})

XRayBox:AddButton({
    Text = "Refresh X-Ray",
    Func = function()
        if xrayEnabled then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v:IsDescendantOf(Players.LocalPlayer.Character) then
                    if not originalMaterials[v] then
                        originalMaterials[v] = v.Material
                    end
                    if v.Transparency < 0.5 then
                        v.Transparency = 0.5
                    end
                    v.Material = Enum.Material.ForceField
                end
            end
            Library:Notify("X-Ray refreshed!", 3)
        end
    end
})

local CameraBox = VisualTab:AddLeftGroupbox("Camera")

CameraBox:AddButton({
    Text = "Inf Zoom",
    Func = function()
        LocalPlayer.CameraMaxZoomDistance = 10000000000
        LocalPlayer.CameraMinZoomDistance = 0
        Library:Notify("Inf Zoom enabled!", 3)
    end
})

local AmbientBox = VisualTab:AddLeftGroupbox("Ambient")

local ambientEnabled = false

AmbientBox:AddToggle("AmbientToggle", {
    Text = "Custom Ambient",
    Default = false,
    Callback = function(state)
        ambientEnabled = state
        if state then
            Lighting.Ambient = Color3.fromRGB(255, 200, 200)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 200, 200)
            Lighting.ColorShift_Top = Color3.fromRGB(255, 200, 200)
            Lighting.ColorShift_Bottom = Color3.fromRGB(255, 200, 200)
            Lighting.Brightness = 2.5
        else
            Lighting.Ambient = Color3.fromRGB(0.5, 0.5, 0.5)
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
            Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
            Lighting.Brightness = 1
        end
    end
})

AmbientBox:AddSlider("RedSlider", {
    Text = "Red",
    Default = 255,
    Min = 0,
    Max = 255,
    Rounding = 0,
    Callback = function(value)
        if ambientEnabled then
            local current = Lighting.Ambient
            Lighting.Ambient = Color3.fromRGB(value, current.G * 255, current.B * 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(value, current.G * 255, current.B * 255)
            Lighting.ColorShift_Top = Color3.fromRGB(value, current.G * 255, current.B * 255)
            Lighting.ColorShift_Bottom = Color3.fromRGB(value, current.G * 255, current.B * 255)
        end
    end
})

AmbientBox:AddSlider("GreenSlider", {
    Text = "Green",
    Default = 200,
    Min = 0,
    Max = 255,
    Rounding = 0,
    Callback = function(value)
        if ambientEnabled then
            local current = Lighting.Ambient
            Lighting.Ambient = Color3.fromRGB(current.R * 255, value, current.B * 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(current.R * 255, value, current.B * 255)
            Lighting.ColorShift_Top = Color3.fromRGB(current.R * 255, value, current.B * 255)
            Lighting.ColorShift_Bottom = Color3.fromRGB(current.R * 255, value, current.B * 255)
        end
    end
})

AmbientBox:AddSlider("BlueSlider", {
    Text = "Blue",
    Default = 200,
    Min = 0,
    Max = 255,
    Rounding = 0,
    Callback = function(value)
        if ambientEnabled then
            local current = Lighting.Ambient
            Lighting.Ambient = Color3.fromRGB(current.R * 255, current.G * 255, value)
            Lighting.OutdoorAmbient = Color3.fromRGB(current.R * 255, current.G * 255, value)
            Lighting.ColorShift_Top = Color3.fromRGB(current.R * 255, current.G * 255, value)
            Lighting.ColorShift_Bottom = Color3.fromRGB(current.R * 255, current.G * 255, value)
        end
    end
})

AmbientBox:AddButton({
    Text = "Reset Ambient",
    Func = function()
        Lighting.Ambient = Color3.fromRGB(255, 200, 200)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 200, 200)
        Lighting.ColorShift_Top = Color3.fromRGB(255, 200, 200)
        Lighting.ColorShift_Bottom = Color3.fromRGB(255, 200, 200)
        Library:Notify("Ambient reset!", 3)
    end
})

local rainbowAmbientEnabled = false
local rainbowConnection

AmbientBox:AddToggle("RainbowAmbientToggle", {
    Text = "Rainbow Ambient",
    Default = false,
    Callback = function(state)
        rainbowAmbientEnabled = state
        if state then
            if ambientEnabled then
                ambientEnabled = false
            end
            local hue = 0
            if rainbowConnection then
                rainbowConnection:Disconnect()
            end
            rainbowConnection = RunService.Heartbeat:Connect(function()
                hue = (hue + 0.001) % 1
                local color = Color3.fromHSV(hue, 1, 1)
                Lighting.Ambient = color
                Lighting.OutdoorAmbient = color
                Lighting.ColorShift_Top = color
                Lighting.ColorShift_Bottom = color
                Lighting.Brightness = 2
            end)
        else
            if rainbowConnection then
                rainbowConnection:Disconnect()
                rainbowConnection = nil
            end
            Lighting.Ambient = Color3.fromRGB(0.5, 0.5, 0.5)
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
            Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
            Lighting.Brightness = 1
        end
    end
})

FPSBox:AddButton({
    Text = "Low Graphics",
    Func = function()
        settings().Rendering.QualityLevel = 1
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Lighting").Technology = Enum.Technology.Legacy
        Library:Notify("Low graphics enabled!", 3)
    end
})

local EffectsBox = VisualTab:AddLeftGroupbox("Remove Effects")

EffectsBox:AddButton({
    Text = "Remove Blur/Water",
    Func = function()
        task.spawn(function()
            while task.wait(0.1) do
                if Camera then
                    Camera.Blur.Enabled = false
                    Camera.DepthOfField.Enabled = false
                end
                
                if workspace.Terrain then
                    workspace.Terrain.WaterWaveSize = 0
                    workspace.Terrain.WaterWaveSpeed = 0
                    workspace.Terrain.WaterReflectance = 0
                    workspace.Terrain.WaterTransparency = 1
                end
            end
        end)

		local Lighting = game:GetService("Lighting")
        for _, effect in pairs(Lighting:GetChildren()) do
            if effect:IsA("DepthOfFieldEffect") or effect:IsA("BlurEffect") then
                effect:Destroy()
            end
        end

        for _, script in pairs(game:GetDescendants()) do
            if script:IsA("LocalScript") or script:IsA("Script") then
                if script.Name == "BlurModule" or (script.Source and script.Source:find("DepthOfField")) then
                    script:Destroy()
                end
            end
        end

        for _, folder in pairs(workspace.CurrentCamera:GetDescendants()) do
            if folder:IsA("Folder") and (folder.Name == "LunaBlur" or folder.Name:find("Blur")) then
                folder:Destroy()
            end
        end

        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("Part") and part.Material == Enum.Material.Glass then
                part:Destroy()
            end
        end
        Library:Notify("Blur/Water effects removed!", 3)
    end
})

local itemEspEnabled = false
local espObjects = {}
local espConnections = {}

local function createItemESP(item)
    if espObjects[item] then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ItemESP"
    highlight.FillColor = Color3.fromRGB(255, 255, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 200, 0)
    highlight.OutlineTransparency = 0
    highlight.Parent = item
    highlight.Enabled = true
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ItemNameGUI"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = item
    
    local text = Instance.new("TextLabel")
    text.Name = "ItemName"
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextStrokeTransparency = 0
    text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    text.Font = Enum.Font.GothamBold
    text.TextSize = 16
    text.Text = item.Name
    text.Parent = billboard
    
    espObjects[item] = {
        highlight = highlight,
        billboard = billboard
    }
end

local function removeItemESP(item)
    if espObjects[item] then
        if espObjects[item].highlight then
            espObjects[item].highlight:Destroy()
        end
        if espObjects[item].billboard then
            espObjects[item].billboard:Destroy()
        end
        espObjects[item] = nil
    end
end

local function clearAllESP()
    for item, _ in pairs(espObjects) do
        removeItemESP(item)
    end
    espObjects = {}
end

local function refreshItemESP()
    if not itemEspEnabled then return end
    
    clearAllESP()
    
    local toolsFolder = workspace:FindFirstChild("Map")
    if toolsFolder then
        toolsFolder = toolsFolder:FindFirstChild("Ignore")
        if toolsFolder then
            toolsFolder = toolsFolder:FindFirstChild("Tools")
            if toolsFolder then
                for _, item in pairs(toolsFolder:GetChildren()) do
                    if item:IsA("Tool") or item:IsA("Part") or item:IsA("Model") then
                        createItemESP(item)
                    end
                end
            end
        end
    end
end

local function onItemAdded(item)
    if itemEspEnabled then
        if item.Parent and item.Parent.Name == "Tools" then
            createItemESP(item)
        end
    end
end

local function onItemRemoved(item)
    if espObjects[item] then
        removeItemESP(item)
    end
end

EffectsBox:AddToggle("ItemESPToggle", {
    Text = "Items ESP (Yellow)",
    Default = false,
    Callback = function(state)
        itemEspEnabled = state
        
        if state then
            refreshItemESP()
            
            for _, conn in pairs(espConnections) do
                conn:Disconnect()
            end
            espConnections = {}
            
            local toolsFolder = workspace:FindFirstChild("Map")
            if toolsFolder then
                toolsFolder = toolsFolder:FindFirstChild("Ignore")
                if toolsFolder then
                    toolsFolder = toolsFolder:FindFirstChild("Tools")
                    if toolsFolder then
                        espConnections[#espConnections+1] = toolsFolder.ChildAdded:Connect(onItemAdded)
                        espConnections[#espConnections+1] = toolsFolder.ChildRemoved:Connect(onItemRemoved)
                    end
                end
            end
            
            Library:Notify("Items ESP enabled!", 3)
        else
            clearAllESP()
            for _, conn in pairs(espConnections) do
                conn:Disconnect()
            end
            espConnections = {}
            Library:Notify("Items ESP disabled!", 3)
        end
    end
})

EffectsBox:AddButton({
    Text = "Refresh Items ESP",
    Func = function()
        if itemEspEnabled then
            refreshItemESP()
            Library:Notify("Items ESP refreshed!", 2)
        else
            Library:Notify("Enable Items ESP first!", 2)
        end
    end
})

local enemyEspEnabled = false
local enemyEspObjects = {}
local enemyEspConnections = {}

local function createEnemyESP(enemy)
    if enemyEspObjects[enemy] then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "EnemyESP"
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.3
    highlight.OutlineColor = Color3.fromRGB(200, 0, 0)
    highlight.OutlineTransparency = 0
    highlight.Parent = enemy
    highlight.Enabled = true
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "EnemyNameGUI"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = enemy
    
    local text = Instance.new("TextLabel")
    text.Name = "EnemyName"
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextStrokeTransparency = 0
    text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    text.Font = Enum.Font.GothamBold
    text.TextSize = 16
    text.Text = "⚠️ " .. enemy.Name .. " ⚠️"
    text.Parent = billboard
    
    enemyEspObjects[enemy] = {
        highlight = highlight,
        billboard = billboard
    }
end

local function removeEnemyESP(enemy)
    if enemyEspObjects[enemy] then
        if enemyEspObjects[enemy].highlight then
            enemyEspObjects[enemy].highlight:Destroy()
        end
        if enemyEspObjects[enemy].billboard then
            enemyEspObjects[enemy].billboard:Destroy()
        end
        enemyEspObjects[enemy] = nil
    end
end

local function clearAllEnemyESP()
    for enemy, _ in pairs(enemyEspObjects) do
        removeEnemyESP(enemy)
    end
    enemyEspObjects = {}
end

local function refreshEnemyESP()
    if not enemyEspEnabled then return end
    
    clearAllEnemyESP()
    
    local aiHunter = workspace:FindFirstChild("AIHunter")
    if aiHunter then
        for _, enemy in pairs(aiHunter:GetChildren()) do
            if enemy:IsA("Model") then
                createEnemyESP(enemy)
            end
        end
    end
    
    local monsterA = workspace:FindFirstChild("Monster")
    if monsterA then
        monsterA = monsterA:FindFirstChild("A")
        if monsterA then
            for _, enemy in pairs(monsterA:GetChildren()) do
                if enemy:IsA("Model") then
                    createEnemyESP(enemy)
                end
            end
        end
    end
end

local function onEnemyAdded(enemy)
    if enemyEspEnabled then
        if enemy:IsA("Model") then
            createEnemyESP(enemy)
        end
    end
end

local function onEnemyRemoved(enemy)
    if enemyEspObjects[enemy] then
        removeEnemyESP(enemy)
    end
end

EffectsBox:AddToggle("EnemyESPToggle", {
    Text = "Enemies ESP (Red)",
    Default = false,
    Callback = function(state)
        enemyEspEnabled = state
        
        if state then
            refreshEnemyESP()
            
            for _, conn in pairs(enemyEspConnections) do
                conn:Disconnect()
            end
            enemyEspConnections = {}
            
            local aiHunter = workspace:FindFirstChild("AIHunter")
            if aiHunter then
                enemyEspConnections[#enemyEspConnections+1] = aiHunter.ChildAdded:Connect(onEnemyAdded)
                enemyEspConnections[#enemyEspConnections+1] = aiHunter.ChildRemoved:Connect(onEnemyRemoved)
            end
            
            local monsterA = workspace:FindFirstChild("Monster")
            if monsterA then
                monsterA = monsterA:FindFirstChild("A")
                if monsterA then
                    enemyEspConnections[#enemyEspConnections+1] = monsterA.ChildAdded:Connect(onEnemyAdded)
                    enemyEspConnections[#enemyEspConnections+1] = monsterA.ChildRemoved:Connect(onEnemyRemoved)
                end
            end
            
            Library:Notify("Enemies ESP enabled!", 3)
        else
            clearAllEnemyESP()
            for _, conn in pairs(enemyEspConnections) do
                conn:Disconnect()
            end
            enemyEspConnections = {}
            Library:Notify("Enemies ESP disabled!", 3)
        end
    end
})

EffectsBox:AddButton({
    Text = "Refresh Enemies ESP",
    Func = function()
        if enemyEspEnabled then
            refreshEnemyESP()
            Library:Notify("Enemies ESP refreshed!", 2)
        else
            Library:Notify("Enable Enemies ESP first!", 2)
        end
    end
})

local MiscTab = Window:AddTab("Misc", "code")

local ScriptsBox = MiscTab:AddLeftGroupbox("Scripts")

ScriptsBox:AddButton({
    Text = "Dex Explorer",
    Func = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/MassiveHubs/loadstring/refs/heads/main/DexXenoAndRezware'))()
        Library:Notify("Dex Explorer loaded!", 3)
    end
})

local ETab = Window:AddTab("Exploits", "zap")

local PlatformBox = ETab:AddLeftGroupbox("Platform")

PlatformBox:AddButton({
    Text = "Create Platform",
    Func = function()
        startPlatform()
        Library:Notify("Platform created!", 3)
    end
})

PlatformBox:AddButton({
    Text = "Remove Platform",
    Func = function()
        stopPlatform()
        Library:Notify("Platform removed!", 3)
    end
})

local PlatformToggle = PlatformBox:AddToggle("PlatformToggle", {
    Text = "Auto Platform",
    Default = false,
    Callback = function(state)
        if state then
            startPlatform()
        else
            stopPlatform()
        end
    end
})

PlatformBox:AddButton({
    Text = "Teleport to Platform",
    Func = function()
        if Character and HumanoidRootPart then
            HumanoidRootPart.CFrame = CFrame.new(
                HumanoidRootPart.Position.X,
                -380,
                HumanoidRootPart.Position.Z
            )
            Library:Notify("Teleported to platform!", 3)
        end
    end
})

local AntiAimBox = ETab:AddLeftGroupbox("AntiAim")

AntiAimBox:AddButton({
	Text = "AntiAim(Players)",
	Func = function()
		local player = game.Players.LocalPlayer

		if player.Character then
			Instance.new("ForceField", player.Character)
		end

		player.CharacterAdded:Connect(function(char)
			Instance.new("ForceField", char)
		end)
	end
})

local SettingsTab = Window:AddTab("Settings", "settings")

local MenuGroup = SettingsTab:AddLeftGroupbox("Menu")

MenuGroup:AddToggle("KeybindMenuOpen", {
    Default = Library.KeybindFrame.Visible,
    Text = "Open Keybind Menu",
    Callback = function(value)
        Library.KeybindFrame.Visible = value
    end,
})

MenuGroup:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor",
    Default = true,
    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end,
})

MenuGroup:AddDropdown("NotificationSide", {
    Values = { "Left", "Right" },
    Default = "Right",
    Text = "Notification Side",
    Callback = function(Value)
        Library:SetNotifySide(Value)
    end,
})

MenuGroup:AddDropdown("DPIDropdown", {
    Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
    Default = "100%",
    Text = "DPI Scale",
    Callback = function(Value)
        Value = Value:gsub("%%", "")
        local DPI = tonumber(Value)
        Library:SetDPIScale(DPI)
    end,
})

MenuGroup:AddDivider()

MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { 
    Default = "RightShift", 
    NoUI = true, 
    Text = "Menu keybind" 
})

MenuGroup:AddButton({
    Text = "Unload",
    Func = function()
        Library:Unload()
    end
})

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

ThemeManager:SetFolder("LikegenmTheme")
SaveManager:SetFolder("LikegenmConfig")

local RightGroup = SettingsTab:AddRightGroupbox("Configuration")

RightGroup:AddButton({
    Text = "Load Config",
    Func = function()
        SaveManager:Load()
    end
})

RightGroup:AddButton({
    Text = "Save Config",
    Func = function()
        SaveManager:Save()
    end
})

RightGroup:AddInput("ConfigName", {
    Default = "Default",
    Text = "Config Name",
    Placeholder = "Enter config name..."
})

RightGroup:AddButton({
    Text = "Delete Config",
    Func = function()
        SaveManager:Delete()
    end
})

RightGroup:AddButton({
    Text = "Refresh Configs",
    Func = function()
        SaveManager:RefreshConfigList()
    end
})

ThemeManager:ApplyToGroupbox(MenuGroup)
SaveManager:ApplyToGroupbox(RightGroup)

Library:Notify("Isle script (by Likegenm) Press RightCTRL to open UI", 5)
