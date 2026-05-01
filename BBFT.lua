local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "BBFT script",
   LoadingTitle = "Loading",
   LoadingSubtitle = "by Likegenm",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Likegenm | BBFT.lua"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false
})

local Tab = Window:CreateTab("Main", 4483362458)

local WalkSpeedSection = Tab:CreateSection("WalkSpeed")
local WSLider = Tab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 200},
   Increment = 1,
   Suffix = "WS",
   CurrentValue = 16,
   Flag = "Walkspeed",
   Callback = function(Value)
       pcall(function()
           game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
       end)
   end,
})

local JumpSection = Tab:CreateSection("Inf Jumps")
local infJumps = false
local InfJumpsToggle = Tab:CreateToggle({
   Name = "Inf Jumps",
   CurrentValue = false,
   Flag = "InfJumps",
   Callback = function(Value)
       infJumps = Value
   end,
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

local FlySection = Tab:CreateSection("Fly")
local flying = false
local flySpeed = 50
local flyConnection = nil

local FlyToggle = Tab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Flag = "Fly",
   Callback = function(Value)
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
   end,
})

local FlySpeedSlider = Tab:CreateSlider({
   Name = "Fly Speed",
   Range = {10, 200},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 50,
   Flag = "FlySpeed",
   Callback = function(Value)
       flySpeed = Value
   end,
})

local VehicleFlySection = Tab:CreateSection("Vehicle Fly")
local vehicleFlying = false
local vehicleFlySpeed = 1
local vflyKeyDown = nil
local vflyKeyUp = nil
local QEfly = true

local function getRoot(char)
   return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

local function startVehicleFly()
   local plr = game.Players.LocalPlayer
   local char = plr.Character or plr.CharacterAdded:Wait()
   local humanoid = char:FindFirstChildOfClass("Humanoid")
   if not humanoid then
       repeat task.wait() until char:FindFirstChildOfClass("Humanoid")
       humanoid = char:FindFirstChildOfClass("Humanoid")
   end

   if vflyKeyDown or vflyKeyUp then
       vflyKeyDown:Disconnect()
       vflyKeyUp:Disconnect()
   end

   local T = getRoot(char)
   local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
   local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
   local SPEED = 0

   local function FLY()
       vehicleFlying = true
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
               if not vehicleFlying and humanoid then
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
           until not vehicleFlying
           CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
           lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
           SPEED = 0
           BG:Destroy()
           BV:Destroy()

           if humanoid then humanoid.PlatformStand = false end
       end)
   end

   vflyKeyDown = game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
       if processed then return end
       if input.KeyCode == Enum.KeyCode.W then
           CONTROL.F = vehicleFlySpeed
       elseif input.KeyCode == Enum.KeyCode.S then
           CONTROL.B = -vehicleFlySpeed
       elseif input.KeyCode == Enum.KeyCode.A then
           CONTROL.L = -vehicleFlySpeed
       elseif input.KeyCode == Enum.KeyCode.D then
           CONTROL.R = vehicleFlySpeed
       elseif input.KeyCode == Enum.KeyCode.E and QEfly then
           CONTROL.Q = vehicleFlySpeed * 2
       elseif input.KeyCode == Enum.KeyCode.Q and QEfly then
           CONTROL.E = -vehicleFlySpeed * 2
       end
       pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
   end)

   vflyKeyUp = game:GetService("UserInputService").InputEnded:Connect(function(input, processed)
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

local function stopVehicleFly()
   vehicleFlying = false
   if vflyKeyDown or vflyKeyUp then 
       vflyKeyDown:Disconnect() 
       vflyKeyUp:Disconnect() 
   end
   if game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
       game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
   end
   pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end

local VehicleFlyToggle = Tab:CreateToggle({
   Name = "Vehicle Fly",
   CurrentValue = false,
   Flag = "VehicleFly",
   Callback = function(Value)
       if Value then
           startVehicleFly()
       else
           stopVehicleFly()
       end
   end,
})

local VehicleFlySpeedSlider = Tab:CreateSlider({
   Name = "Vehicle Fly Speed",
   Range = {1, 20},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 1,
   Flag = "VehicleFlySpeed",
   Callback = function(Value)
       vehicleFlySpeed = Value
   end,
})

local white = game:GetService("Teams").white
local red = game:GetService("Teams").red
local black = game:GetService("Teams").black
local blue = game:GetService("Teams").blue
local green = game:GetService("Teams").green
local magenta = game:GetService("Teams").magenta
local yellow = game:GetService("Teams").yellow

local TeamChangerSection = Tab:CreateSection("Team Changer")

local GreenTeamButton = Tab:CreateButton({
   Name = "Green Team",
   Callback = function()
       pcall(function()
           workspace.ChangeTeam:FireServer(green)
       end)
   end,
})

local MagentaTeamButton = Tab:CreateButton({
   Name = "Magenta Team",
   Callback = function()
       pcall(function()
           workspace.ChangeTeam:FireServer(magenta)
       end)
   end,
})

local YellowTeamButton = Tab:CreateButton({
   Name = "Yellow Team",
   Callback = function()
       pcall(function()
           workspace.ChangeTeam:FireServer(yellow)
       end)
   end,
})

local WhiteTeamButton = Tab:CreateButton({
   Name = "White Team",
   Callback = function()
       pcall(function()
           workspace.ChangeTeam:FireServer(white)
       end)
   end,
})

local RedTeamButton = Tab:CreateButton({
   Name = "Red Team",
   Callback = function()
       pcall(function()
           workspace.ChangeTeam:FireServer(red)
       end)
   end,
})

local BlackTeamButton = Tab:CreateButton({
   Name = "Black Team",
   Callback = function()
       pcall(function()
           workspace.ChangeTeam:FireServer(black)
       end)
   end,
})

local BlueTeamButton = Tab:CreateButton({
   Name = "Blue Team",
   Callback = function()
       pcall(function()
           workspace.ChangeTeam:FireServer(blue)
       end)
   end,
})

local TeleportsSection = Tab:CreateSection("Teleports")

local TeleportVoidButton = Tab:CreateButton({
   Name = "Teleport Void",
   Callback = function()
       local char = game.Players.LocalPlayer.Character
       if char and char:FindFirstChild("HumanoidRootPart") then
           local pos = char.HumanoidRootPart.Position
           char.HumanoidRootPart.CFrame = CFrame.new(pos.X, -4995, pos.Z)
       end
   end,
})

local TeleportWhiteButton = Tab:CreateButton({
   Name = "Teleport White",
   Callback = function()
       local char = game.Players.LocalPlayer.Character
       if char and char:FindFirstChild("HumanoidRootPart") then
           char.HumanoidRootPart.CFrame = CFrame.new(-43.17396545410156, 23.101789474487305, -435.8960876464844)
       end
   end,
})

local TeleportRedButton = Tab:CreateButton({
   Name = "Teleport Red",
   Callback = function()
       local char = game.Players.LocalPlayer.Character
       if char and char:FindFirstChild("HumanoidRootPart") then
           char.HumanoidRootPart.CFrame = CFrame.new(289.72027587890625, 53.00434494018555, -65.34805297851562)
       end
   end,
})

local TeleportBlackButton = Tab:CreateButton({
   Name = "Teleport Black",
   Callback = function()
       local char = game.Players.LocalPlayer.Character
       if char and char:FindFirstChild("HumanoidRootPart") then
           char.HumanoidRootPart.CFrame = CFrame.new(-440.7001647949219, 57.68651580810547, -70.62168884277344)
       end
   end,
})

local TeleportBlueButton = Tab:CreateButton({
   Name = "Teleport Blue",
   Callback = function()
       local char = game.Players.LocalPlayer.Character
       if char and char:FindFirstChild("HumanoidRootPart") then
           char.HumanoidRootPart.CFrame = CFrame.new(284.32403564453125, 87.21946716308594, 289.2806091308594)
       end
   end,
})

local TeleportPurpleButton = Tab:CreateButton({
   Name = "Teleport Purple",
   Callback = function()
       local char = game.Players.LocalPlayer.Character
       if char and char:FindFirstChild("HumanoidRootPart") then
           char.HumanoidRootPart.CFrame = CFrame.new(289.2187805175781, 53.44639205932617, 643.5872802734375)
       end
   end,
})

local TeleportYellowButton = Tab:CreateButton({
   Name = "Teleport Yellow",
   Callback = function()
       local char = game.Players.LocalPlayer.Character
       if char and char:FindFirstChild("HumanoidRootPart") then
           char.HumanoidRootPart.CFrame = CFrame.new(-417.4566345214844, 58.879661560058594, 645.0250854492188)
       end
   end,
})

local AutoFarmSection = Tab:CreateSection("Auto Farm")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local gravityNormal = workspace.Gravity
local isRunning = false
local speed = 375
local currentTween = nil

local destinations = {
    CFrame.new(-43.6134491, 62.1137619, 672.744934, -0.999842644, -0.00183729955, 0.017645346, 0, 0.994622767, 0.103564225, -0.0177407414, 0.103547923, -0.994466245),
    CFrame.new(-60.1504707, 97.4659729, 8767.91406, -0.99889338, 0.000705028593, 0.0470264405, 0, 0.999887645, -0.0149902813, -0.047031723, -0.0149736926, -0.998781145),
    CFrame.new(-54.331871, -345.398346, 9488.60645, -0.98221302, 0, 0.187770084, 0, 1, 0, -0.187770084, 0, -0.98221302),
}

local function moveTo(targetCFrame, setGravity)
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local distance = (root.Position - targetCFrame.Position).Magnitude
    local duration = distance / speed

    currentTween = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    currentTween:Play()

    local reached = false
    currentTween.Completed:Connect(function()
        reached = true
    end)

    if setGravity then
        workspace.Gravity = gravityNormal
    else
        workspace.Gravity = 0
    end

    while not reached and isRunning do
        RunService.Heartbeat:Wait()
    end
end

task.spawn(function()
    while true do
        task.wait(10)
        if isRunning then
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.L, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.L, false, game)
        end
    end
end)

local function autoFarmLoop()
    while isRunning do
        local char = player.Character or player.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart", 5)
        if not root then return end

        for i, cf in ipairs(destinations) do
            if not isRunning then return end
            moveTo(cf, i == #destinations)
        end

        repeat task.wait(1) until not isRunning or not player.Character
    end
end

local function startAutoFarm()
    if isRunning then return end
    isRunning = true
    task.spawn(autoFarmLoop)
end

local function stopAutoFarm()
    isRunning = false
    workspace.Gravity = gravityNormal
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
end

local AutoFarmToggle = Tab:CreateToggle({
   Name = "Auto Farm",
   CurrentValue = false,
   Flag = "AutoFarm",
   Callback = function(Value)
       if Value then
           startAutoFarm()
       else
           stopAutoFarm()
       end
   end,
})

player.CharacterAdded:Connect(function()
    if isRunning then
        task.wait(1)
        task.spawn(autoFarmLoop)
    end
end)

local GravitySection = Tab:CreateSection("Gravity")

local GravitySlider = Tab:CreateSlider({
   Name = "Gravity",
   Range = {0, 400},
   Increment = 1,
   Suffix = "Studs",
   CurrentValue = workspace.Gravity,
   Flag = "GravitySlider",
   Callback = function(Value)
       workspace.Gravity = Value
   end,
})

local ResetGravityButton = Tab:CreateButton({
   Name = "Reset Gravity",
   Callback = function()
       workspace.Gravity = 196.2
       GravitySlider:Set(196.2)
   end,
})

local MiscSection = Tab:CreateSection("Misc")
local noclipActive = false
local noclipConnection = nil

local NoClipToggle = Tab:CreateToggle({
   Name = "NoClip",
   CurrentValue = false,
   Flag = "NoClip",
   Callback = function(Value)
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
   end,
})

local InvisButton = Tab:CreateButton({
   Name = "Invisible",
   Callback = function()
       loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/InvisforPhantasm.lua"))()
   end,
})

loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/BypassVoid.lua"))()
