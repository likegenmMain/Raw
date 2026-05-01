local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Murino Horror",
   LoadingTitle = "Murino Horror Interface",
   LoadingSubtitle = "by Likegenm + Vicinly",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "MurinoHorror_Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

local LocalPlayerTab = Window:CreateTab("LocalPlayer", 4483362458)
local GameTab = Window:CreateTab("Game", 4483362458)
local VisualTab = Window:CreateTab("Visual", 4483362458)
local CreditsTab = Window:CreateTab("Credits", 4483362458)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local speedEnabled = false
local originalSpeed = humanoid.WalkSpeed
local flyEnabled = false
local flySpeed = 50
local noclipEnabled = false
local infiniteJumpEnabled = false
local bodyVelocity = nil
local longJumpEnabled = false
local originalJumpPower = humanoid.JumpPower
local originalHipHeight = humanoid.HipHeight
local speedLoop = nil
local currentSpeedValue = 16

local fullbrightEnabled = false
local originalBrightness = game.Lighting.Brightness
local originalOutdoorAmbient = game.Lighting.OutdoorAmbient
local originalGlobalShadows = game.Lighting.GlobalShadows
local originalFogEnd = game.Lighting.FogEnd
local originalFogStart = game.Lighting.FogStart

local freeCamEnabled = false
local freeCamCamera = nil
local freeCamPart = nil
local originalCameraSubject = nil
local freeCamConnection = nil
local freeCamSpeed = 3
local originalWalkSpeed = nil

local invisEnabled = false
local invisChair = nil

local floatEnabled = false
local floatBodyVelocity = nil
local floatConnection = nil

local menuMusicEnabled = false
local menuMusicSound = nil
local musicVolume = 0.5
local musicSpeed = 1.0

local antiRushEnabled = false
local antiRushLoop = nil
local isInRushInvis = false
local rushInvisChair = nil

local antiBunnyEnabled = false
local antiBunnyLoop = nil

local antiTrainEnabled = false
local antiTrainLoop = nil

local antiAntonChigurEnabled = false
local antiAntonChigurLoop = nil

local antiAmamamEnabled = false
local antiAmamamLoop = nil

local antiArthurEnabled = false
local antiArthurLoop = nil

local function setCharacterTransparency(transparency)
    pcall(function()
        local char = player.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    part.Transparency = transparency
                end
            end
        end
    end)
end

local function toggleInvisibility()
    if isInRushInvis then
        game.StarterGui:SetCore("SendNotification", {
            Title = "Invisibility",
            Duration = 2,
            Text = "Can't toggle while AntiRush is active"
        })
        return
    end

    invisEnabled = not invisEnabled

    if invisEnabled then
        local savedPos = rootPart.CFrame
        local invisPos = Vector3.new(-25.95, 84, 3537.55)

        character:MoveTo(invisPos)
        task.wait(0.15)

        invisChair = Instance.new("Seat")
        invisChair.Name = "invischair"
        invisChair.Anchored = false
        invisChair.CanCollide = false
        invisChair.Transparency = 1
        invisChair.Position = invisPos
        invisChair.Parent = workspace

        local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
        if torso then
            local weld = Instance.new("Weld", invisChair)
            weld.Part0 = invisChair
            weld.Part1 = torso
        end

        task.wait()
        invisChair.CFrame = savedPos
        setCharacterTransparency(0.5)

        game.StarterGui:SetCore("SendNotification", {
            Title = "Invisibility",
            Duration = 2,
            Text = "Invisibility ON"
        })
    else
        if invisChair then
            invisChair:Destroy()
            invisChair = nil
        end
        setCharacterTransparency(0)

        game.StarterGui:SetCore("SendNotification", {
            Title = "Invisibility",
            Duration = 2,
            Text = "Invisibility OFF"
        })
    end
end

local function PlayMenuMusic()
    if menuMusicSound then
        menuMusicSound:Stop()
        menuMusicSound:Destroy()
    end
    
    menuMusicSound = Instance.new("Sound")
    menuMusicSound.SoundId = "rbxassetid://1848319100"
    menuMusicSound.Volume = musicVolume
    menuMusicSound.PlaybackSpeed = musicSpeed
    menuMusicSound.Looped = true
    menuMusicSound.Parent = workspace
    
    menuMusicSound:Play()
end

local function StopMenuMusic()
    if menuMusicSound then
        menuMusicSound:Stop()
        menuMusicSound:Destroy()
        menuMusicSound = nil
    end
end

local function UpdateMusicSettings()
    if menuMusicSound then
        menuMusicSound.Volume = musicVolume
        menuMusicSound.PlaybackSpeed = musicSpeed
    end
end

local function startRushInvis()
    if isInRushInvis then return end
    isInRushInvis = true

    pcall(function()
        local savedPos = rootPart.CFrame
        local invisPos = Vector3.new(-25.95, 84, 3537.55)
        character:MoveTo(invisPos)
        task.wait(0.15)

        rushInvisChair = Instance.new("Seat")
        rushInvisChair.Name = "rush_invischair"
        rushInvisChair.Anchored = false
        rushInvisChair.CanCollide = false
        rushInvisChair.Transparency = 1
        rushInvisChair.Position = invisPos
        rushInvisChair.Parent = workspace

        local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
        if torso then
            local weld = Instance.new("Weld", rushInvisChair)
            weld.Part0 = rushInvisChair
            weld.Part1 = torso
        end

        task.wait()
        rushInvisChair.CFrame = savedPos
        setCharacterTransparency(0.5)

        game.StarterGui:SetCore("SendNotification", {
            Title = "AntiRush",
            Duration = 3,
            Text = "⚠️ Rush detected! Invisibility until Skvorec disappears"
        })
    end)
end

local function stopRushInvis()
    if not isInRushInvis then return end
    isInRushInvis = false

    pcall(function()
        if rushInvisChair then
            rushInvisChair:Destroy()
            rushInvisChair = nil
        end
        setCharacterTransparency(0)

        game.StarterGui:SetCore("SendNotification", {
            Title = "AntiRush",
            Duration = 2,
            Text = "✅ Skvorec gone, invisibility off"
        })
    end)
end

local function startAntiRush()
    if antiRushLoop then antiRushLoop:Disconnect() end
    antiRushLoop = game:GetService("RunService").Stepped:Connect(function()
        if not antiRushEnabled then return end

        pcall(function()
            local hb = workspace:FindFirstChild("Hitboxes")
            local skvorec = hb and hb:FindFirstChild("Skvorec")

            if skvorec and skvorec.Parent == hb then
                if not isInRushInvis then
                    startRushInvis()
                end
            else
                if isInRushInvis then
                    stopRushInvis()
                end
            end
        end)
    end)
end

local function stopAntiRush()
    if antiRushLoop then
        antiRushLoop:Disconnect()
        antiRushLoop = nil
    end
    if isInRushInvis then
        stopRushInvis()
    end
end

local function startAntiBunny()
    if antiBunnyLoop then 
        task.cancel(antiBunnyLoop)
        antiBunnyLoop = nil
    end
    
    antiBunnyLoop = task.spawn(function()
        while antiBunnyEnabled do
            pcall(function()
                local playerGui = player:FindFirstChild("PlayerGui")
                if playerGui then
                    local dontMove = playerGui:FindFirstChild("DontMove")
                    if dontMove then
                        dontMove:Destroy()
                    end
                end
            end)
            task.wait(0.1)
        end
    end)
end

local function stopAntiBunny()
    if antiBunnyLoop then
        task.cancel(antiBunnyLoop)
        antiBunnyLoop = nil
    end
end

local function startAntiAntonChigur()
    if antiAntonChigurLoop then
        task.cancel(antiAntonChigurLoop)
        antiAntonChigurLoop = nil
    end

    antiAntonChigurLoop = task.spawn(function()
        while antiAntonChigurEnabled do
            pcall(function()
                local antonGui = player.PlayerGui:FindFirstChild("AntonChigur")
                if antonGui then
                    antonGui:Destroy()
                end
            end)
            task.wait(0.1)
        end
    end)
end

local function stopAntiAntonChigur()
    if antiAntonChigurLoop then
        task.cancel(antiAntonChigurLoop)
        antiAntonChigurLoop = nil
    end
end

local function startAntiAmamam()
    if antiAmamamLoop then
        task.cancel(antiAmamamLoop)
        antiAmamamLoop = nil
    end

    antiAmamamLoop = task.spawn(function()
        while antiAmamamEnabled do
            pcall(function()
                local amamamGui = player.PlayerGui:FindFirstChild("amamam")
                if amamamGui then
                    amamamGui:Destroy()
                end
            end)
            task.wait(0.1)
        end
    end)
end

local function stopAntiAmamam()
    if antiAmamamLoop then
        task.cancel(antiAmamamLoop)
        antiAmamamLoop = nil
    end
end

local function startAntiArthur()
    if antiArthurLoop then
        task.cancel(antiArthurLoop)
        antiArthurLoop = nil
    end

    antiArthurLoop = task.spawn(function()
        while antiArthurEnabled do
            pcall(function()
                local arthurGui = player.PlayerGui:FindFirstChild("ArturSpawn")
                if arthurGui then
                    arthurGui:Destroy()
                end
            end)
            task.wait(0.1)
        end
    end)
end

local function stopAntiArthur()
    if antiArthurLoop then
        task.cancel(antiArthurLoop)
        antiArthurLoop = nil
    end
end

local function startAntiTrain()
    if antiTrainLoop then 
        antiTrainLoop:Disconnect()
        antiTrainLoop = nil
    end
    
    antiTrainLoop = game:GetService("RunService").Heartbeat:Connect(function()
        if not antiTrainEnabled then return end
        
        pcall(function()
            local map = workspace:FindFirstChild("Map")
            if map then
                local workingTrain = map:FindFirstChild("WorkingTrain") or map:FindFirstChild("Working Train")
                if workingTrain then
                    workingTrain:Destroy()
                end
            end
        end)
    end)
    
    task.spawn(function()
        while antiTrainEnabled do
            pcall(function()
                local map = workspace:FindFirstChild("Map")
                if map then
                    local workingTrain = map:FindFirstChild("WorkingTrain") or map:FindFirstChild("Working Train")
                    if workingTrain then
                        workingTrain:Destroy()
                    end
                end
            end)
            task.wait(0.001)
        end
    end)
end

local function stopAntiTrain()
    if antiTrainLoop then
        antiTrainLoop:Disconnect()
        antiTrainLoop = nil
    end
end

local function toggleFloat()
    floatEnabled = not floatEnabled

    if floatEnabled then
        floatBodyVelocity = Instance.new("BodyVelocity")
        floatBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        floatBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        floatBodyVelocity.Parent = rootPart

        local UIS = game:GetService("UserInputService")

        floatConnection = game:GetService("RunService").RenderStepped:Connect(function()
            if floatEnabled and floatBodyVelocity and rootPart then
                local verticalMove = 0
                if UIS:IsKeyDown(Enum.KeyCode.Space) then
                    verticalMove = 20
                elseif UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
                    verticalMove = -20
                end

                local camera = workspace.CurrentCamera
                local forward = camera.CFrame.LookVector
                local right = camera.CFrame.RightVector

                local moveDirection = Vector3.new(0, 0, 0)

                if UIS:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + forward end
                if UIS:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - forward end
                if UIS:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + right end
                if UIS:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - right end

                if moveDirection.Magnitude > 0 then
                    moveDirection = moveDirection.Unit * currentSpeedValue
                end

                floatBodyVelocity.Velocity = Vector3.new(moveDirection.X, verticalMove, moveDirection.Z)
            end
        end)

        game.StarterGui:SetCore("SendNotification", {
            Title = "Float",
            Duration = 2,
            Text = "Float ON (WASD = Move, Space = Up, Shift = Down)"
        })
    else
        if floatBodyVelocity then
            floatBodyVelocity:Destroy()
            floatBodyVelocity = nil
        end
        if floatConnection then
            floatConnection:Disconnect()
            floatConnection = nil
        end

        game.StarterGui:SetCore("SendNotification", {
            Title = "Float",
            Duration = 2,
            Text = "Float OFF"
        })
    end
end

local SpeedSection = LocalPlayerTab:CreateSection("Speed")

local SpeedSlider = LocalPlayerTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 100},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(value)
        pcall(function()
            currentSpeedValue = value
            if speedEnabled and humanoid and humanoid.Parent then
                humanoid.WalkSpeed = value
            end
        end)
    end,
})

local SpeedToggle = LocalPlayerTab:CreateToggle({
    Name = "Enable Speed",
    CurrentValue = false,
    Flag = "SpeedToggle",
    Callback = function(value)
        pcall(function()
            speedEnabled = value
            if speedLoop then speedLoop:Disconnect() end
            if value then
                originalSpeed = humanoid.WalkSpeed
                speedLoop = game:GetService("RunService").Heartbeat:Connect(function()
                    if speedEnabled and humanoid and humanoid.Parent then
                        if humanoid.WalkSpeed ~= currentSpeedValue then
                            humanoid.WalkSpeed = currentSpeedValue
                        end
                    end
                end)
            else
                if humanoid then humanoid.WalkSpeed = originalSpeed end
            end
        end)
    end,
})

local FlySection = LocalPlayerTab:CreateSection("Fly")

local FlySpeedSlider = LocalPlayerTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 200},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(value)
        pcall(function() flySpeed = value end)
    end,
})

local FlyToggle = LocalPlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(value)
        pcall(function()
            flyEnabled = value
            if value then
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 100000
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.Parent = rootPart

                local flyConnection
                flyConnection = game:GetService("RunService").RenderStepped:Connect(function()
                    if flyEnabled then
                        local camera = workspace.CurrentCamera
                        local forward = camera.CFrame.LookVector
                        local right = camera.CFrame.RightVector
                        local up = camera.CFrame.UpVector

                        local move = Vector3.new(0, 0, 0)
                        local UIS = game:GetService("UserInputService")

                        if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + forward end
                        if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - forward end
                        if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + right end
                        if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - right end
                        if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + up end
                        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - up end

                        if move.Magnitude > 0 then move = move.Unit * flySpeed end
                        bodyVelocity.Velocity = move
                        humanoid.PlatformStand = true
                    else
                        if bodyVelocity then bodyVelocity:Destroy() end
                        humanoid.PlatformStand = false
                        if flyConnection then flyConnection:Disconnect() end
                    end
                end)
            else
                if bodyVelocity then bodyVelocity:Destroy() end
                humanoid.PlatformStand = false
            end
        end)
    end,
})

local JumpSection = LocalPlayerTab:CreateSection("Jump")

local InfJumpToggle = LocalPlayerTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfJump",
    Callback = function(value)
        pcall(function() infiniteJumpEnabled = value end)
    end,
})

local LongJumpSlider = LocalPlayerTab:CreateSlider({
    Name = "Long Jump Power",
    Range = {50, 300},
    Increment = 10,
    Suffix = "Power",
    CurrentValue = 50,
    Flag = "LongJumpPower",
    Callback = function(value)
        pcall(function()
            if longJumpEnabled and humanoid then humanoid.JumpPower = value end
        end)
    end,
})

local LongJumpToggle = LocalPlayerTab:CreateToggle({
    Name = "Long Jump",
    CurrentValue = false,
    Flag = "LongJump",
    Callback = function(value)
        pcall(function()
            longJumpEnabled = value
            if value then
                originalJumpPower = humanoid.JumpPower
                humanoid.JumpPower = 100
            else
                if humanoid then humanoid.JumpPower = originalJumpPower end
            end
        end)
    end,
})

local HipSection = LocalPlayerTab:CreateSection("Hip Height")

local HipHeightSlider = LocalPlayerTab:CreateSlider({
    Name = "Hip Height",
    Range = {0, 20},
    Increment = 1,
    Suffix = "Height",
    CurrentValue = 0,
    Flag = "HipHeight",
    Callback = function(value)
        pcall(function() humanoid.HipHeight = value end)
    end,
})

local HipHeightToggle = LocalPlayerTab:CreateToggle({
    Name = "Enable Hip Height",
    CurrentValue = false,
    Flag = "HipHeightToggle",
    Callback = function(value)
        pcall(function()
            if value then
                originalHipHeight = humanoid.HipHeight
                humanoid.HipHeight = 10
            else
                humanoid.HipHeight = originalHipHeight
            end
        end)
    end,
})

local OtherSection = LocalPlayerTab:CreateSection("Other")

local NoclipToggle = LocalPlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(value)
        pcall(function()
            noclipEnabled = value
            if value then
                game:GetService("RunService").Stepped:Connect(function()
                    if noclipEnabled and character then
                        for _, part in ipairs(character:GetDescendants()) do
                            if part:IsA("BasePart") then part.CanCollide = false end
                        end
                    end
                end)
            else
                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = true end
                    end
                end
            end
        end)
    end,
})

local InvisToggle = LocalPlayerTab:CreateToggle({
    Name = "Invisibility",
    CurrentValue = false,
    Flag = "Invisibility",
    Callback = function(value)
        pcall(function()
            if value and not invisEnabled then toggleInvisibility()
            elseif not value and invisEnabled then toggleInvisibility() end
        end)
    end,
})

local FloatToggle = LocalPlayerTab:CreateToggle({
    Name = "Float",
    CurrentValue = false,
    Flag = "Float",
    Callback = function(value)
        pcall(function()
            if value and not floatEnabled then toggleFloat()
            elseif not value and floatEnabled then toggleFloat() end
        end)
    end,
})

local AntiSection = GameTab:CreateSection("Anti")

local AntiRushToggle = GameTab:CreateToggle({
    Name = "AntiRush",
    CurrentValue = false,
    Flag = "AntiRush",
    Callback = function(value)
        pcall(function()
            antiRushEnabled = value
            if value then
                startAntiRush()
                game.StarterGui:SetCore("SendNotification", {
                    Title = "AntiRush",
                    Duration = 2,
                    Text = "AntiRush ON - Invis while Skvorec present"
                })
            else
                stopAntiRush()
                game.StarterGui:SetCore("SendNotification", {
                    Title = "AntiRush",
                    Duration = 2,
                    Text = "AntiRush OFF"
                })
            end
        end)
    end,
})

local AntiAntonToggle = GameTab:CreateToggle({
    Name = "Anti Anton Chigur",
    CurrentValue = false,
    Flag = "AntiAnton",
    Callback = function(value)
        pcall(function()
            antiAntonChigurEnabled = value
            if value then
                startAntiAntonChigur()
            else
                stopAntiAntonChigur()
            end
        end)
    end,
})

local AntiAmamamToggle = GameTab:CreateToggle({
    Name = "Anti amamam",
    CurrentValue = false,
    Flag = "AntiAmamam",
    Callback = function(value)
        pcall(function()
            antiAmamamEnabled = value
            if value then
                startAntiAmamam()
            else
                stopAntiAmamam()
            end
        end)
    end,
})

local AntiArthurToggle = GameTab:CreateToggle({
    Name = "Anti Arthur",
    CurrentValue = false,
    Flag = "AntiArthur",
    Callback = function(value)
        pcall(function()
            antiArthurEnabled = value
            if value then
                startAntiArthur()
            else
                stopAntiArthur()
            end
        end)
    end,
})

local AntiBunnyToggle = GameTab:CreateToggle({
    Name = "Anti Bunny",
    CurrentValue = false,
    Flag = "AntiBunny",
    Callback = function(value)
        pcall(function()
            antiBunnyEnabled = value
            if value then
                startAntiBunny()
            else
                stopAntiBunny()
            end
        end)
    end,
})

local AntiTrainToggle = GameTab:CreateToggle({
    Name = "Anti Train",
    CurrentValue = false,
    Flag = "AntiTrain",
    Callback = function(value)
        pcall(function()
            antiTrainEnabled = value
            if value then
                startAntiTrain()
            else
                stopAntiTrain()
            end
        end)
    end,
})

local MusicSection = GameTab:CreateSection("Music")

local MenuMusicToggle = GameTab:CreateToggle({
    Name = "Menu Music",
    CurrentValue = false,
    Flag = "MenuMusic",
    Callback = function(value)
        menuMusicEnabled = value
        if value then
            PlayMenuMusic()
        else
            StopMenuMusic()
        end
    end,
})

local MusicVolumeSlider = GameTab:CreateSlider({
    Name = "Music Volume",
    Range = {0.1, 1},
    Increment = 0.1,
    Suffix = "Volume",
    CurrentValue = 0.5,
    Flag = "MusicVolume",
    Callback = function(value)
        musicVolume = value
        UpdateMusicSettings()
    end,
})

local MusicSpeedSlider = GameTab:CreateSlider({
    Name = "Music Speed",
    Range = {0.1, 2.0},
    Increment = 0.1,
    Suffix = "Speed",
    CurrentValue = 1.0,
    Flag = "MusicSpeed",
    Callback = function(value)
        musicSpeed = value
        UpdateMusicSettings()
    end,
})

local VisualSection = VisualTab:CreateSection("Visual")

local FOVSlider = VisualTab:CreateSlider({
    Name = "Field of View",
    Range = {70, 120},
    Increment = 1,
    Suffix = "FOV",
    CurrentValue = 70,
    Flag = "FOV",
    Callback = function(value)
        pcall(function() workspace.CurrentCamera.FieldOfView = value end)
    end,
})

local InfZoomToggle = VisualTab:CreateToggle({
    Name = "Infinite Zoom",
    CurrentValue = false,
    Flag = "InfZoom",
    Callback = function(value)
        pcall(function()
            if value then player.MaxZoomDistance = 1000000
            else player.MaxZoomDistance = 20 end
        end)
    end,
})

local FullbrightToggle = VisualTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,
    Flag = "Fullbright",
    Callback = function(value)
        pcall(function()
            fullbrightEnabled = value
            if value then
                originalBrightness = game.Lighting.Brightness
                originalOutdoorAmbient = game.Lighting.OutdoorAmbient
                originalGlobalShadows = game.Lighting.GlobalShadows
                originalFogEnd = game.Lighting.FogEnd
                originalFogStart = game.Lighting.FogStart

                game.Lighting.Brightness = 2
                game.Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
                game.Lighting.GlobalShadows = false
                game.Lighting.FogEnd = 100000
                game.Lighting.FogStart = 100000
            else
                game.Lighting.Brightness = originalBrightness
                game.Lighting.OutdoorAmbient = originalOutdoorAmbient
                game.Lighting.GlobalShadows = originalGlobalShadows
                game.Lighting.FogEnd = originalFogEnd
                game.Lighting.FogStart = originalFogStart
            end
        end)
    end,
})

local BrightnessSlider = VisualTab:CreateSlider({
    Name = "Brightness",
    Range = {0, 5},
    Increment = 0.1,
    Suffix = "Brightness",
    CurrentValue = 2,
    Flag = "Brightness",
    Callback = function(value)
        pcall(function() game.Lighting.Brightness = value end)
    end,
})

local FreeCamSection = VisualTab:CreateSection("FreeCam")

local FreeCamSpeedSlider = VisualTab:CreateSlider({
    Name = "FreeCam Speed",
    Range = {1, 5},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 3,
    Flag = "FreeCamSpeed",
    Callback = function(value)
        pcall(function() freeCamSpeed = value end)
    end,
})

local FreeCamToggle = VisualTab:CreateToggle({
    Name = "FreeCam",
    CurrentValue = false,
    Flag = "FreeCam",
    Callback = function(value)
        pcall(function()
            freeCamEnabled = value
            if value then
                originalWalkSpeed = humanoid.WalkSpeed
                humanoid.WalkSpeed = 0

                local camera = workspace.CurrentCamera
                originalCameraSubject = camera.CameraSubject

                freeCamPart = Instance.new("Part")
                freeCamPart.Name = "FreeCamPart"
                freeCamPart.Transparency = 1
                freeCamPart.CanCollide = false
                freeCamPart.Anchored = true
                freeCamPart.Position = camera.CFrame.Position
                freeCamPart.Parent = workspace

                camera.CameraSubject = freeCamPart

                freeCamConnection = game:GetService("RunService").RenderStepped:Connect(function()
                    if freeCamEnabled then
                        local UIS = game:GetService("UserInputService")
                        local move = Vector3.new(0, 0, 0)
                        local cf = camera.CFrame

                        if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + cf.LookVector end
                        if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - cf.LookVector end
                        if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + cf.RightVector end
                        if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - cf.RightVector end
                        if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
                        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end

                        if move.Magnitude > 0 then
                            move = move.Unit * freeCamSpeed
                            freeCamPart.Position = freeCamPart.Position + move
                        end

                        local mouse = player:GetMouse()
                        if UIS:IsKeyDown(Enum.KeyCode.RightShift) then
                            local newCF = CFrame.new(freeCamPart.Position, freeCamPart.Position + mouse.UnitRay.Direction * 100)
                            freeCamPart.CFrame = newCF
                            camera.CFrame = newCF
                        else
                            camera.CFrame = CFrame.new(freeCamPart.Position, freeCamPart.Position + camera.CFrame.LookVector)
                        end
                    end
                end)
            else
                if freeCamConnection then freeCamConnection:Disconnect() end
                if freeCamPart then freeCamPart:Destroy() end
                if originalCameraSubject then workspace.CurrentCamera.CameraSubject = originalCameraSubject end
                if originalWalkSpeed and humanoid then humanoid.WalkSpeed = originalWalkSpeed end
            end
        end)
    end,
})

local CreditsSection = CreditsTab:CreateSection("Credits")

CreditsTab:CreateLabel("Script by Likegenm + Vicinly")
CreditsTab:CreateLabel("Murino Horror Hub")
CreditsTab:CreateLabel("Thanks for using!")

game:GetService("UserInputService").JumpRequest:Connect(function()
    pcall(function()
        if infiniteJumpEnabled and not floatEnabled then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Z and not isInRushInvis then
        pcall(function() toggleInvisibility() end)
    end
end)

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
end)
