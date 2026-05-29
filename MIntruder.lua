local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Qanuir/orion-ui/refs/heads/main/source.lua"))()
local Window = OrionLib:MakeWindow({
    Name = "The Intruder Script | Mine",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "IntruderScript",
    IntroEnabled = false,
    IntroText = "Loading..."
})

local PT = Window:MakeTab({
    Name = "LocalPlayer",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local VisualTab = Window:MakeTab({
    Name = "Visual",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local TeleportTab = Window:MakeTab({
    Name = "Teleport",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local GameTab = Window:MakeTab({
    Name = "Game",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local velocitySpeed = 16
local velocityEnabled = false
local velocityConnection

local function SetupVelocityMovement(speed)
    local Camera = Workspace.CurrentCamera
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    
    if not Character or not HumanoidRootPart then return end
    
    local lookVector = Camera.CFrame.LookVector
    local rightVector = Camera.CFrame.RightVector
    
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
            mv.X * speed,
            HumanoidRootPart.Velocity.Y,
            mv.Z * speed
        )
    end
end

PT:AddSlider({
    Name = "Speedhack",
    Min = 12,
    Max = 50,
    Default = 16,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        velocitySpeed = Value
    end
})

PT:AddToggle({
    Name = "Enable Speed",
    Default = false,
    Callback = function(Value)
        velocityEnabled = Value
        
        if Value then
            velocityConnection = RunService.Heartbeat:Connect(function()
                if velocityEnabled then
                    SetupVelocityMovement(velocitySpeed)
                end
            end)
        else
            if velocityConnection then
                velocityConnection:Disconnect()
                velocityConnection = nil
            end
        end
    end
})

local flySpeed = 40
local flyEnabled = false
local flyConnection
local flyTween

local function SetupFly(speed)
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local camera = Workspace.CurrentCamera
    local lookVector = camera.CFrame.LookVector
    local rightVector = camera.CFrame.RightVector
    
    local targetVelocity = Vector3.new(0, 0, 0)
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        targetVelocity = targetVelocity + lookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        targetVelocity = targetVelocity - lookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        targetVelocity = targetVelocity - rightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        targetVelocity = targetVelocity + rightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        targetVelocity = targetVelocity + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        targetVelocity = targetVelocity + Vector3.new(0, -1, 0)
    end
    
    if targetVelocity.Magnitude > 0 then
        targetVelocity = targetVelocity.Unit * speed
    end
    
    if flyTween then
        flyTween:Cancel()
    end
    
    local TweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(
        0.1,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )
    
    flyTween = TweenService:Create(humanoidRootPart, tweenInfo, {Velocity = targetVelocity})
    flyTween:Play()
end

PT:AddSlider({
    Name = "Fly Speed",
    Min = 16,
    Max = 200,
    Default = 40,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        flySpeed = Value
    end
})

PT:AddToggle({
    Name = "Enable Fly",
    Default = false,
    Callback = function(Value)
        flyEnabled = Value
        
        if Value then
            flyConnection = RunService.Heartbeat:Connect(function()
                if flyEnabled then
                    SetupFly(flySpeed)
                end
            end)
        else
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            
            if flyTween then
                flyTween:Cancel()
                flyTween = nil
            end
            
            local character = LocalPlayer.Character
            if character then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end
})

local ambientEnabled = false
local ambientColor = Color3.new(1, 0, 0)
local ambientRainbow = false
local ambientConnection
local ambientRainbowConnection

local function ApplyAmbient()
    Lighting.OutdoorAmbient = ambientColor
    Lighting.Ambient = ambientColor
end

local function ResetAmbient()
    Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
    Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
end

VisualTab:AddToggle({
    Name = "Ambient",
    Default = false,
    Callback = function(Value)
        ambientEnabled = Value
        
        if Value then
            ambientConnection = RunService.Heartbeat:Connect(function()
                if ambientEnabled then
                    ApplyAmbient()
                end
            end)
            ApplyAmbient()
        else
            if ambientConnection then
                ambientConnection:Disconnect()
                ambientConnection = nil
            end
            ResetAmbient()
        end
    end
})

VisualTab:AddToggle({
    Name = "Rainbow Ambient",
    Default = false,
    Callback = function(Value)
        ambientRainbow = Value
        
        if Value then
            ambientRainbowConnection = RunService.Heartbeat:Connect(function()
                if not ambientRainbow then return end
                
                local hue = tick() % 5 / 5
                ambientColor = Color3.fromHSV(hue, 1, 1)
                
                if ambientEnabled then
                    ApplyAmbient()
                end
            end)
        else
            if ambientRainbowConnection then
                ambientRainbowConnection:Disconnect()
                ambientRainbowConnection = nil
            end
        end
    end
})

local fullBrightEnabled = false
local fullBrightConnection

local function ApplyFullBright()
    Lighting.Ambient = Color3.new(1, 1, 1)
    Lighting.Brightness = 2
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    Lighting.FogEnd = 100000
    Lighting.FogStart = 0
end

local function ResetLighting()
    Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
    Lighting.Brightness = 1
    Lighting.GlobalShadows = true
    Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
    Lighting.FogEnd = 100000
    Lighting.FogStart = 100
end

VisualTab:AddToggle({
    Name = "FullBright",
    Default = false,
    Callback = function(Value)
        fullBrightEnabled = Value
        
        if Value then
            fullBrightConnection = RunService.Heartbeat:Connect(function()
                if fullBrightEnabled then
                    ApplyFullBright()
                end
            end)
            ApplyFullBright()
        else
            if fullBrightConnection then
                fullBrightConnection:Disconnect()
                fullBrightConnection = nil
            end
            ResetLighting()
        end
    end
})

local intruderChamsEnabled = false
local intruderNameEnabled = false
local intruderDistanceEnabled = false
local intruderTracersEnabled = false
local intruderRainbow = true
local intruderChamsHighlight = nil
local intruderBillboard = nil
local intruderTracer = nil
local intruderUpdateConnection = nil
local intruderRainbowConnection = nil

local function UpdateIntruderESP()
    local intruder = Workspace:FindFirstChild("Intruder")
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if intruderChamsEnabled and intruder then
        if not intruderChamsHighlight then
            intruderChamsHighlight = Instance.new("Highlight")
            intruderChamsHighlight.Name = "IntruderChams"
            intruderChamsHighlight.FillColor = Color3.new(1, 0, 0)
            intruderChamsHighlight.OutlineColor = Color3.new(1, 1, 0)
            intruderChamsHighlight.FillTransparency = 0.3
            intruderChamsHighlight.OutlineTransparency = 0
            intruderChamsHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            intruderChamsHighlight.Adornee = intruder
            intruderChamsHighlight.Parent = intruder
        else
            intruderChamsHighlight.Adornee = intruder
            intruderChamsHighlight.Parent = intruder
        end
    else
        if intruderChamsHighlight then
            intruderChamsHighlight:Destroy()
            intruderChamsHighlight = nil
        end
    end
    
    if intruderNameEnabled and intruder then
        if not intruderBillboard then
            intruderBillboard = Instance.new("BillboardGui")
            intruderBillboard.Name = "IntruderName"
            intruderBillboard.Size = UDim2.new(0, 200, 0, 50)
            intruderBillboard.StudsOffset = Vector3.new(0, 5, 0)
            intruderBillboard.AlwaysOnTop = true
            intruderBillboard.MaxDistance = 500
            
            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = "INTRUDER"
            textLabel.TextColor3 = Color3.new(1, 0, 0)
            textLabel.TextStrokeTransparency = 0
            textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            textLabel.Font = Enum.Font.GothamBold
            textLabel.TextSize = 16
            textLabel.Parent = intruderBillboard
            
            intruderBillboard.Parent = intruder
        else
            intruderBillboard.Parent = intruder
            
            local textLabel = intruderBillboard:FindFirstChild("TextLabel")
            if textLabel and rootPart then
                local distanceText = "INTRUDER"
                if intruderDistanceEnabled then
                    local intruderPos = intruder:GetPivot().Position
                    local distance = (intruderPos - rootPart.Position).Magnitude
                    distanceText = string.format("INTRUDER [%.1f studs]", distance)
                end
                textLabel.Text = distanceText
            end
        end
    else
        if intruderBillboard then
            intruderBillboard:Destroy()
            intruderBillboard = nil
        end
    end
    
    if intruderTracersEnabled and intruder and rootPart then
        if not intruderTracer then
            intruderTracer = Instance.new("Beam")
            intruderTracer.Name = "IntruderTracer"
            intruderTracer.Color = ColorSequence.new(Color3.new(1, 0, 0))
            intruderTracer.Width0 = 0.2
            intruderTracer.Width1 = 0.2
            intruderTracer.Texture = "rbxassetid://446111271"
            intruderTracer.TextureLength = 10
            intruderTracer.TextureMode = Enum.TextureMode.Wrap
            intruderTracer.TextureSpeed = 2
            intruderTracer.ZOffset = 1
            
            local intruderAttachment = Instance.new("Attachment")
            intruderAttachment.Name = "TracerAttachment"
            intruderAttachment.Parent = intruder
            
            local localAttachment = Instance.new("Attachment")
            localAttachment.Name = "TracerAttachment"
            localAttachment.Parent = rootPart
            
            intruderTracer.Attachment0 = intruderAttachment
            intruderTracer.Attachment1 = localAttachment
            intruderTracer.Parent = Workspace
        else
            intruderTracer.Enabled = true
            intruderTracer.Attachment0.Parent = intruder
            intruderTracer.Attachment1.Parent = rootPart
        end
    else
        if intruderTracer then
            intruderTracer.Enabled = false
        end
    end
    
    if intruderRainbow and intruderChamsHighlight then
        local hue = tick() % 5 / 5
        local rainbowColor = Color3.fromHSV(hue, 1, 1)
        intruderChamsHighlight.FillColor = rainbowColor
        
        if intruderTracer then
            intruderTracer.Color = ColorSequence.new(rainbowColor)
        end
        
        if intruderBillboard then
            local textLabel = intruderBillboard:FindFirstChild("TextLabel")
            if textLabel then
                textLabel.TextColor3 = rainbowColor
            end
        end
    end
end

VisualTab:AddToggle({
    Name = "Intruder Chams",
    Default = false,
    Callback = function(Value)
        intruderChamsEnabled = Value
        
        if Value or intruderNameEnabled or intruderTracersEnabled then
            if not intruderUpdateConnection then
                intruderUpdateConnection = RunService.RenderStepped:Connect(function()
                    UpdateIntruderESP()
                end)
            end
            UpdateIntruderESP()
        else
            if intruderUpdateConnection then
                intruderUpdateConnection:Disconnect()
                intruderUpdateConnection = nil
            end
            
            if intruderChamsHighlight then
                intruderChamsHighlight:Destroy()
                intruderChamsHighlight = nil
            end
        end
    end
})

VisualTab:AddToggle({
    Name = "Name Intruder",
    Default = false,
    Callback = function(Value)
        intruderNameEnabled = Value
        
        if Value or intruderChamsEnabled or intruderTracersEnabled then
            if not intruderUpdateConnection then
                intruderUpdateConnection = RunService.RenderStepped:Connect(function()
                    UpdateIntruderESP()
                end)
            end
            UpdateIntruderESP()
        else
            if intruderUpdateConnection then
                intruderUpdateConnection:Disconnect()
                intruderUpdateConnection = nil
            end
            
            if intruderBillboard then
                intruderBillboard:Destroy()
                intruderBillboard = nil
            end
        end
    end
})

VisualTab:AddToggle({
    Name = "Show Distance",
    Default = false,
    Callback = function(Value)
        intruderDistanceEnabled = Value
        UpdateIntruderESP()
    end
})

VisualTab:AddToggle({
    Name = "Intruder Tracers",
    Default = false,
    Callback = function(Value)
        intruderTracersEnabled = Value
        
        if Value or intruderChamsEnabled or intruderNameEnabled then
            if not intruderUpdateConnection then
                intruderUpdateConnection = RunService.RenderStepped:Connect(function()
                    UpdateIntruderESP()
                end)
            end
            UpdateIntruderESP()
        else
            if intruderUpdateConnection then
                intruderUpdateConnection:Disconnect()
                intruderUpdateConnection = nil
            end
            
            if intruderTracer then
                intruderTracer:Destroy()
                intruderTracer = nil
            end
        end
    end
})

VisualTab:AddToggle({
    Name = "Rainbow Chams",
    Default = true,
    Callback = function(Value)
        intruderRainbow = Value
    end
})

VisualTab:AddButton({
    Name = "Kill Intruder",
    Callback = function()
        local intruder = Workspace:FindFirstChild("Intruder")
        if intruder then
            intruder:Destroy()
            
            if intruderChamsHighlight then
                intruderChamsHighlight:Destroy()
                intruderChamsHighlight = nil
            end
            
            if intruderBillboard then
                intruderBillboard:Destroy()
                intruderBillboard = nil
            end
            
            if intruderTracer then
                intruderTracer:Destroy()
                intruderTracer = nil
            end
        end
    end
})

local generatorNameESP = false
local generatorTracers = false
local generatorChams = false
local generatorRainbow = true
local generatorChamsColor = Color3.new(1, 1, 0)
local generatorHighlights = {}
local generatorBillboards = {}
local generatorTracersObj = {}
local generatorUpdateConnection = nil
local generatorRainbowConnection = nil

local function UpdateGeneratorESP()
    local gensFolder = Workspace:FindFirstChild("Generators")
    if not gensFolder then return end
    
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    for _, generator in pairs(gensFolder:GetChildren()) do
        local mainPart = nil
        if generator:IsA("Model") then
            mainPart = generator.PrimaryPart or generator:FindFirstChildWhichIsA("BasePart")
        elseif generator:IsA("BasePart") then
            mainPart = generator
        end
        
        if not mainPart then continue end
        
        if generatorChams then
            if not generatorHighlights[generator] then
                local highlight = Instance.new("Highlight")
                highlight.Name = "GeneratorChams"
                highlight.FillColor = generatorChamsColor
                highlight.OutlineColor = Color3.new(1, 1, 1)
                highlight.FillTransparency = 0.3
                highlight.OutlineTransparency = 0
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Adornee = generator
                highlight.Parent = generator
                generatorHighlights[generator] = highlight
            else
                generatorHighlights[generator].Adornee = generator
                generatorHighlights[generator].Parent = generator
            end
        else
            if generatorHighlights[generator] then
                generatorHighlights[generator]:Destroy()
                generatorHighlights[generator] = nil
            end
        end
        
        if generatorNameESP then
            if not generatorBillboards[generator] then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "GeneratorName"
                billboard.Size = UDim2.new(0, 200, 0, 80)
                billboard.StudsOffset = Vector3.new(0, 4, 0)
                billboard.AlwaysOnTop = true
                billboard.MaxDistance = 500
                
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = generator.Name
                nameLabel.TextColor3 = generatorChamsColor
                nameLabel.TextStrokeTransparency = 0
                nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.TextSize = 16
                nameLabel.Parent = billboard
                
                local stateLabel = Instance.new("TextLabel")
                stateLabel.Position = UDim2.new(0, 0, 0.5, 0)
                stateLabel.Size = UDim2.new(1, 0, 0.5, 0)
                stateLabel.BackgroundTransparency = 1
                stateLabel.Text = ""
                stateLabel.TextColor3 = Color3.new(1, 1, 1)
                stateLabel.TextStrokeTransparency = 0
                stateLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                stateLabel.Font = Enum.Font.Gotham
                stateLabel.TextSize = 14
                stateLabel.Parent = billboard
                
                billboard.Parent = generator
                generatorBillboards[generator] = {billboard = billboard, nameLabel = nameLabel, stateLabel = stateLabel}
            else
                generatorBillboards[generator].billboard.Parent = generator
                
                if rootPart and generatorDistance then
                    local distance = (mainPart.Position - rootPart.Position).Magnitude
                    generatorBillboards[generator].stateLabel.Text = string.format("[%.1f studs]", distance)
                else
                    generatorBillboards[generator].stateLabel.Text = ""
                end
                
                local healthValue = generator:FindFirstChild("health")
                local inUseValue = generator:FindFirstChild("inUse")
                local plrUsingValue = generator:FindFirstChild("plrUsing")
                
                if healthValue then
                    local stateText = string.format("Health: %d", healthValue.Value)
                    if inUseValue and inUseValue.Value and plrUsingValue then
                        stateText = stateText .. string.format("\nUsing: %s", plrUsingValue.Value)
                    end
                    generatorBillboards[generator].stateLabel.Text = stateText
                end
            end
        else
            if generatorBillboards[generator] then
                generatorBillboards[generator].billboard:Destroy()
                generatorBillboards[generator] = nil
            end
        end
        
        if generatorTracers and rootPart then
            if not generatorTracersObj[generator] then
                local tracer = Instance.new("Beam")
                tracer.Name = "GeneratorTracer"
                tracer.Color = ColorSequence.new(generatorChamsColor)
                tracer.Width0 = 0.15
                tracer.Width1 = 0.15
                tracer.Texture = "rbxassetid://446111271"
                tracer.TextureLength = 8
                tracer.TextureMode = Enum.TextureMode.Wrap
                tracer.TextureSpeed = 1.5
                tracer.ZOffset = 0.5
                
                local genAttachment = Instance.new("Attachment")
                genAttachment.Name = "TracerAttachment"
                genAttachment.Parent = mainPart
                
                local localAttachment = Instance.new("Attachment")
                localAttachment.Name = "TracerAttachment"
                localAttachment.Parent = rootPart
                
                tracer.Attachment0 = genAttachment
                tracer.Attachment1 = localAttachment
                tracer.Parent = Workspace
                
                generatorTracersObj[generator] = {tracer = tracer, genAttachment = genAttachment, localAttachment = localAttachment}
            else
                generatorTracersObj[generator].tracer.Enabled = true
                generatorTracersObj[generator].genAttachment.Parent = mainPart
                generatorTracersObj[generator].localAttachment.Parent = rootPart
            end
        else
            if generatorTracersObj[generator] then
                generatorTracersObj[generator].tracer.Enabled = false
            end
        end
        
        if generatorRainbow then
            local hue = (tick() % 5 / 5) + (tonumber(string.sub(generator.Name, -1)) or 0) * 0.2
            local rainbowColor = Color3.fromHSV(hue % 1, 1, 1)
            
            if generatorHighlights[generator] then
                generatorHighlights[generator].FillColor = rainbowColor
            end
            
            if generatorBillboards[generator] then
                generatorBillboards[generator].nameLabel.TextColor3 = rainbowColor
            end
            
            if generatorTracersObj[generator] then
                generatorTracersObj[generator].tracer.Color = ColorSequence.new(rainbowColor)
            end
        elseif not generatorRainbow then
            if generatorHighlights[generator] then
                generatorHighlights[generator].FillColor = generatorChamsColor
            end
            
            if generatorBillboards[generator] then
                generatorBillboards[generator].nameLabel.TextColor3 = generatorChamsColor
            end
            
            if generatorTracersObj[generator] then
                generatorTracersObj[generator].tracer.Color = ColorSequence.new(generatorChamsColor)
            end
        end
    end
end

local function ClearGeneratorESP()
    for generator, highlight in pairs(generatorHighlights) do
        highlight:Destroy()
    end
    generatorHighlights = {}
    
    for generator, data in pairs(generatorBillboards) do
        data.billboard:Destroy()
    end
    generatorBillboards = {}
    
    for generator, data in pairs(generatorTracersObj) do
        data.tracer:Destroy()
        if data.genAttachment then data.genAttachment:Destroy() end
        if data.localAttachment then data.localAttachment:Destroy() end
    end
    generatorTracersObj = {}
end

VisualTab:AddToggle({
    Name = "Generator Name ESP",
    Default = false,
    Callback = function(Value)
        generatorNameESP = Value
        
        if Value or generatorChams or generatorTracers then
            if not generatorUpdateConnection then
                generatorUpdateConnection = RunService.RenderStepped:Connect(function()
                    UpdateGeneratorESP()
                end)
            end
            UpdateGeneratorESP()
        else
            if not generatorChams and not generatorTracers then
                if generatorUpdateConnection then
                    generatorUpdateConnection:Disconnect()
                    generatorUpdateConnection = nil
                end
            end
            ClearGeneratorESP()
        end
    end
})

VisualTab:AddToggle({
    Name = "Generator Tracers",
    Default = false,
    Callback = function(Value)
        generatorTracers = Value
        
        if Value or generatorNameESP or generatorChams then
            if not generatorUpdateConnection then
                generatorUpdateConnection = RunService.RenderStepped:Connect(function()
                    UpdateGeneratorESP()
                end)
            end
            UpdateGeneratorESP()
        else
            if not generatorNameESP and not generatorChams then
                if generatorUpdateConnection then
                    generatorUpdateConnection:Disconnect()
                    generatorUpdateConnection = nil
                end
            end
            ClearGeneratorESP()
        end
    end
})

VisualTab:AddToggle({
    Name = "Generator Chams",
    Default = false,
    Callback = function(Value)
        generatorChams = Value
        
        if Value or generatorNameESP or generatorTracers then
            if not generatorUpdateConnection then
                generatorUpdateConnection = RunService.RenderStepped:Connect(function()
                    UpdateGeneratorESP()
                end)
            end
            UpdateGeneratorESP()
        else
            if not generatorNameESP and not generatorTracers then
                if generatorUpdateConnection then
                    generatorUpdateConnection:Disconnect()
                    generatorUpdateConnection = nil
                end
            end
            ClearGeneratorESP()
        end
    end
})

VisualTab:AddToggle({
    Name = "Show Generator Distance",
    Default = false,
    Callback = function(Value)
        generatorDistance = Value
        UpdateGeneratorESP()
    end
})

VisualTab:AddToggle({
    Name = "Generator Rainbow",
    Default = true,
    Callback = function(Value)
        generatorRainbow = Value
    end
})

VisualTab:AddButton({
    Name = "Refresh Generator ESP",
    Callback = function()
        ClearGeneratorESP()
        UpdateGeneratorESP()
    end
})

local function tpTo(pos)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

TeleportTab:AddButton({
    Name = "TP to Generator 1",
    Callback = function()
        tpTo(Vector3.new(49, 4, -87))
    end
})

TeleportTab:AddButton({
    Name = "TP to Generator 2",
    Callback = function()
        tpTo(Vector3.new(131, 4, -88))
    end
})

TeleportTab:AddButton({
    Name = "TP to Generator 3",
    Callback = function()
        tpTo(Vector3.new(127, 4, 32))
    end
})

TeleportTab:AddButton({
    Name = "TP to Generator 4",
    Callback = function()
        tpTo(Vector3.new(29, 4, 60))
    end
})

TeleportTab:AddButton({
    Name = "TP to Generator 5",
    Callback = function()
        tpTo(Vector3.new(154, 4, 60))
    end
})

TeleportTab:AddButton({
    Name = "TP to Lift",
    Callback = function()
        tpTo(Vector3.new(28, 4, -39))
    end
})

GameTab:AddButton({
    Name = "Fix Generators",
    Callback = function()
        pcall(function()
            local gensFolder = Workspace:FindFirstChild("Generators")
            if gensFolder then
                for _, gen in pairs(gensFolder:GetChildren()) do
                    if gen:IsA("MeshPart") then
                        ReplicatedStorage.changeValue:FireServer(gen.health, 100)
                    end
                end
            end
        end)
    end
})

GameTab:AddButton({
    Name = "Break Lockers",
    Callback = function()
        pcall(function()
            local lockersFolder = Workspace:FindFirstChild("Lockers")
            if lockersFolder then
                for _, locker in pairs(lockersFolder:GetChildren()) do
                    if locker:IsA("Model") then
                        ReplicatedStorage.changeValue:FireServer(locker.inUse, true)
                    end
                end
            end
        end)
    end
})

GameTab:AddButton({
    Name = "Break Intruder",
    Callback = function()
        pcall(function()
            local intruder = Workspace:FindFirstChild("Intruder")
            if intruder and intruder:FindFirstChild("Humanoid") then
                for _, child in pairs(intruder.Humanoid:GetChildren()) do
                    if child:IsA("NumberValue") then
                        ReplicatedStorage.changeValue:FireServer(child, 10)
                    end
                end
                task.wait(0.5)
                for _, child in pairs(intruder.Humanoid:GetChildren()) do
                    if child:IsA("NumberValue") then
                        ReplicatedStorage.changeValue:FireServer(child, 0)
                    end
                end
            end
        end)
    end
})

GameTab:AddButton({
    Name = "Win Game",
    Callback = function()
        pcall(function()
            ReplicatedStorage.changeValue:FireServer(Workspace.Values.complete, 100)
            local liftPos = Workspace.Lift:GetPivot()
            LocalPlayer.Character:PivotTo(liftPos)
        end)
    end
})

GameTab:AddButton({
    Name = "Make Nightmare",
    Callback = function()
        pcall(function()
            ReplicatedStorage.changeValue:FireServer(Workspace.Values.isEasyMode, false)
            ReplicatedStorage.changeValue:FireServer(Workspace.Values.isNightmareMode, true)
        end)
    end
})

GameTab:AddButton({
    Name = "Godmode",
    Callback = function()
        pcall(function()
            local intruder = Workspace:FindFirstChild("Intruder")
            if intruder then
                for _, desc in pairs(intruder:GetDescendants()) do
                    if desc:IsA("BasePart") or desc:IsA("Part") then
                        desc.CanTouch = false
                        desc.CanQuery = false
                    end
                end
            end
            ReplicatedStorage.changeValue:FireServer(LocalPlayer.Character.isDead, false)
            LocalPlayer.Character.isDead.Changed:Connect(function()
                ReplicatedStorage.changeValue:FireServer(LocalPlayer.Character.isDead, false)
            end)
            ReplicatedStorage.changeValue:FireServer(LocalPlayer.PlayerGui.Death.canExecute, false)
        end)
    end
})

OrionLib:Init()

