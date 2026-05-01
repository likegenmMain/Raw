local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "BloxStrike",
    Footer = "by Likegenm",
    ToggleKeybind = Enum.KeyCode.RightControl,
    Center = true,
    AutoShow = true
})

Library.ShowCustomCursor = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

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

RunService.RenderStepped:Connect(function()
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

local LPTab = Window:AddTab("Combat", "sword")
local VTab = Window:AddTab("Blatant", "zap")
local CTab = Window:AddTab("Render", "eye")
local WTab = Window:AddTab("World", "moon")
local MTab = Window:AddTab("Mics", "box")

local flyEnabled = false
local flyConnection = nil
local keys = {W=false, S=false, A=false, D=false}
local shiftDown = false
local torquePower = 50000
local torque = nil
local hrp = nil

local function setupFly()
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    hrp = char:WaitForChild("HumanoidRootPart")
    
    if torque then
        torque:Destroy()
    end
    
    torque = Instance.new("Torque")
    torque.Parent = hrp
end

local function startFly()
    if flyEnabled then
        setupFly()
        
        if flyConnection then
            flyConnection:Disconnect()
        end
        
        flyConnection = RunService.Heartbeat:Connect(function()
            if not flyEnabled or not hrp or not hrp.Parent then
                return
            end
            
            local moveDir = Vector3.new(0, 0, 0)
            local camCF = Camera.CFrame
            
            if keys.W then moveDir = moveDir + camCF.LookVector end
            if keys.S then moveDir = moveDir - camCF.LookVector end
            if keys.A then moveDir = moveDir - camCF.RightVector end
            if keys.D then moveDir = moveDir + camCF.RightVector end
            
            if shiftDown then
                torque.Torque = Vector3.new(0, 0, torquePower)
                hrp.Velocity = Vector3.new(0, -50, 0)
            elseif moveDir.Magnitude > 0 then
                moveDir = moveDir.Unit
                torque.Torque = Vector3.new(0, torquePower, 0)
                hrp.Velocity = moveDir * 50
            else
                torque.Torque = Vector3.new(0, 0, 0)
                hrp.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        if torque then
            torque:Destroy()
            torque = nil
        end
        if hrp then
            hrp.Velocity = Vector3.new(0, 0, 0)
        end
    end
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then keys.W = true end
    if input.KeyCode == Enum.KeyCode.S then keys.S = true end
    if input.KeyCode == Enum.KeyCode.A then keys.A = true end
    if input.KeyCode == Enum.KeyCode.D then keys.D = true end
    if input.KeyCode == Enum.KeyCode.LeftShift then shiftDown = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then keys.W = false end
    if input.KeyCode == Enum.KeyCode.S then keys.S = false end
    if input.KeyCode == Enum.KeyCode.A then keys.A = false end
    if input.KeyCode == Enum.KeyCode.D then keys.D = false end
    if input.KeyCode == Enum.KeyCode.LeftShift then shiftDown = false end
end)

local FlyBox = VTab:AddLeftGroupbox("Fly")

FlyBox:AddToggle("FlyToggle", {
    Text = "Fly",
    Default = false,
    Callback = function(state)
        flyEnabled = state
        startFly()
        Library:Notify("Fly: " .. (state and "ON" or "OFF"), 2)
    end
})

FlyBox:AddSlider("TorquePowerSlider", {
    Text = "Torque Power",
    Default = 50000,
    Min = 10000,
    Max = 100000,
    Rounding = 1,
    Callback = function(value)
        torquePower = value
    end
})

local infJumpEnabled = false
local jumpPower = 50
local infJumpConnection = nil

local function startInfJump()
    if infJumpEnabled then
        if infJumpConnection then
            infJumpConnection:Disconnect()
        end
        
        infJumpConnection = UserInputService.InputBegan:Connect(function(input)
            if infJumpEnabled and input.KeyCode == Enum.KeyCode.Space then
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local hrp = character.HumanoidRootPart
                    hrp.Velocity = Vector3.new(hrp.Velocity.X, jumpPower, hrp.Velocity.Z)
                end
            end
        end)
    else
        if infJumpConnection then
            infJumpConnection:Disconnect()
            infJumpConnection = nil
        end
    end
end

local JumpBox = VTab:AddRightGroupbox("InfJump")

JumpBox:AddToggle("JumpToggle", {
    Text = "InfJumps",
    Default = false,
    Callback = function(state)
        infJumpEnabled = state
        startInfJump()
        Library:Notify("InfJump: " .. (state and "ON" or "OFF"), 2)
    end
})

JumpBox:AddSlider("JumpPowerSlider", {
    Text = "Jump Power",
    Default = 50,
    Min = 20,
    Max = 200,
    Rounding = 1,
    Callback = function(value)
        jumpPower = value
    end
})

local antiFallEnabled = false
local antiFallConnection = nil

local function startAntiFall()
    if antiFallEnabled then
        if antiFallConnection then
            antiFallConnection:Disconnect()
        end
        
        antiFallConnection = RunService.Heartbeat:Connect(function()
            if not antiFallEnabled then return end
            
            local player = game.Players.LocalPlayer
            local char = player.Character
            if not char then return end
            
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local humanoid = char:FindFirstChild("Humanoid")
            
            if not hrp or not humanoid then return end
            
            if hrp.Position.Y < -50 then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)
            end
        end)
    else
        if antiFallConnection then
            antiFallConnection:Disconnect()
            antiFallConnection = nil
        end
    end
end

local AntiFallBox = VTab:AddLeftGroupbox("AntiFall")

AntiFallBox:AddToggle("AntiFallToggle", {
    Text = "Anti Fall",
    Default = false,
    Callback = function(state)
        antiFallEnabled = state
        startAntiFall()
        Library:Notify("Anti Fall: " .. (state and "ON" or "OFF"), 2)
    end
})

-- Render Tab - Box ESP with wall detection
local boxEspEnabled = false
local espObjects = {}
local espConnections = {}
local wallCheckEnabled = true
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}

local function isPlayerVisible(player)
    if not wallCheckEnabled then return true end
    
    local character = player.Character
    if not character then return false end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    
    local cameraPos = Camera.CFrame.Position
    local direction = (rootPart.Position - cameraPos).Unit * (rootPart.Position - cameraPos).Magnitude
    
    local result = Workspace:Raycast(cameraPos, direction, raycastParams)
    
    return not result or result.Instance:IsDescendantOf(character)
end

local function createBoxESP(player)
    if espObjects[player] or player == LocalPlayer then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "BoxESP"
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = player.Character or player.CharacterAdded:Wait()
    highlight.Enabled = true
    
    espObjects[player] = {
        highlight = highlight,
        lastVisible = false
    }
end

local function removeBoxESP(player)
    if espObjects[player] then
        if espObjects[player].highlight then
            espObjects[player].highlight:Destroy()
        end
        espObjects[player] = nil
    end
end

local function clearAllBoxESP()
    for player, _ in pairs(espObjects) do
        removeBoxESP(player)
    end
    espObjects = {}
end

local function refreshBoxESP()
    if not boxEspEnabled then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            createBoxESP(player)
        end
    end
end

local function updateBoxESP()
    if not boxEspEnabled then return end
    
    -- Обновляем фильтр для рейкаста
    if LocalPlayer.Character then
        raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    end
    
    for player, data in pairs(espObjects) do
        if player and player.Character and data.highlight then
            local visible = isPlayerVisible(player)
            
            if visible then
                -- Видимый - зеленый
                data.highlight.FillColor = Color3.fromRGB(0, 255, 0)
                data.highlight.OutlineColor = Color3.fromRGB(0, 200, 0)
            else
                -- За стеной - красный
                data.highlight.FillColor = Color3.fromRGB(255, 0, 0)
                data.highlight.OutlineColor = Color3.fromRGB(200, 0, 0)
            end
            
            data.lastVisible = visible
        else
            removeBoxESP(player)
        end
    end
end

local function onPlayerAdded(player)
    if boxEspEnabled and player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            if boxEspEnabled then
                createBoxESP(player)
            end
        end)
    end
end

local function onPlayerRemoved(player)
    if espObjects[player] then
        removeBoxESP(player)
    end
end

local RenderBox = CTab:AddLeftGroupbox("Box ESP")

RenderBox:AddToggle("BoxESPToggle", {
    Text = "Box ESP",
    Default = false,
    Callback = function(state)
        boxEspEnabled = state
        
        if state then
            refreshBoxESP()
            
            for _, conn in pairs(espConnections) do
                conn:Disconnect()
            end
            espConnections = {}
            
            espConnections[#espConnections+1] = Players.PlayerAdded:Connect(onPlayerAdded)
            espConnections[#espConnections+1] = Players.PlayerRemoving:Connect(onPlayerRemoved)
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    player.CharacterAdded:Connect(function()
                        if boxEspEnabled then
                            createBoxESP(player)
                        end
                    end)
                end
            end
            
            Library:Notify("Box ESP enabled!", 3)
        else
            clearAllBoxESP()
            for _, conn in pairs(espConnections) do
                conn:Disconnect()
            end
            espConnections = {}
            Library:Notify("Box ESP disabled!", 3)
        end
    end
})

RenderBox:AddToggle("WallCheckToggle", {
    Text = "Wall Detection",
    Default = true,
    Callback = function(state)
        wallCheckEnabled = state
    end
})

RenderBox:AddButton({
    Text = "Refresh Box ESP",
    Func = function()
        if boxEspEnabled then
            clearAllBoxESP()
            refreshBoxESP()
            Library:Notify("Box ESP refreshed!", 2)
        else
            Library:Notify("Enable Box ESP first!", 2)
        end
    end
})

RunService.RenderStepped:Connect(function()
    if boxEspEnabled then
        updateBoxESP()
    end
end)

Library:Notify("BloxStrike script (by Likegenm) Press RightCTRL to open UI", 5)
