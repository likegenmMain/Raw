local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Granny: Multiplayer Chapter: 3 | by Likegenm",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "by Likegenm",
   ConfigurationSaving = {
      Enabled = false
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

local Tab = Window:CreateTab("Items", 4483362458)
local player = game.Players.LocalPlayer
local allItems = {}
local espObjects = {}
local espColor = Color3.fromRGB(255, 255, 255)
local tracerColor = Color3.fromRGB(255, 255, 255)
local rainbowESP = false
local rainbowTracers = false
local espEnabled = false
local tracersEnabled = false
local nametagObjects = {}
local nametagsEnabled = false
local nametagColor = Color3.fromRGB(255, 255, 255)
local distanceTags = {}
local distanceEnabled = false
local distanceColor = Color3.fromRGB(255, 255, 255)

local scanItems = function()
   allItems = {}
   for i = 1, 10 do
      local preset = workspace:FindFirstChild("Preset" .. i)
      if preset then
         for _, obj in pairs(preset:GetChildren()) do
            if obj:FindFirstChild("InteractRemote") then
               table.insert(allItems, obj.Name)
            end
         end
      end
   end
end

scanItems()

local selectedItem = ""

local GrabSection = Tab:CreateSection("Item Grabber")

local dropdown = Tab:CreateDropdown({
   Name = "Select Item",
   Options = allItems,
   CurrentOption = "",
   Flag = "SelectItem",
   Callback = function(Value)
      selectedItem = Value
   end
})

Tab:CreateButton({
   Name = "Refresh Items",
   Callback = function()
      scanItems()
      dropdown:Refresh(allItems)
   end
})

Tab:CreateButton({
   Name = "Get Selected Item",
   Callback = function()
      if selectedItem == "" then return end
      for i = 1, 10 do
         local preset = workspace:FindFirstChild("Preset" .. i)
         if preset then
            local obj = preset:FindFirstChild(selectedItem)
            if obj and obj:FindFirstChild("InteractRemote") then
               obj.InteractRemote:FireServer(player)
            end
         end
      end
   end
})

Tab:CreateButton({
   Name = "Get All Items",
   Callback = function()
      for i = 1, 10 do
         local preset = workspace:FindFirstChild("Preset" .. i)
         if preset then
            for _, obj in pairs(preset:GetChildren()) do
               if obj:FindFirstChild("InteractRemote") then
                  obj.InteractRemote:FireServer(player)
               end
            end
         end
      end
   end
})

local ESPSection = Tab:CreateSection("Item ESP")

local createESP = function(obj)
   local highlight = Instance.new("Highlight")
   highlight.Parent = obj
   highlight.Adornee = obj
   highlight.FillColor = espColor
   highlight.FillTransparency = 0.5
   highlight.OutlineColor = espColor
   highlight.OutlineTransparency = 0
   table.insert(espObjects, highlight)
   return highlight
end

local clearESP = function()
   for _, h in pairs(espObjects) do
      h:Destroy()
   end
   espObjects = {}
end

local applyESP = function()
   clearESP()
   if not espEnabled then return end
   for i = 1, 10 do
      local preset = workspace:FindFirstChild("Preset" .. i)
      if preset then
         for _, obj in pairs(preset:GetChildren()) do
            if obj:FindFirstChild("InteractRemote") then
               createESP(obj)
            end
         end
      end
   end
end

Tab:CreateToggle({
   Name = "Item ESP",
   CurrentValue = false,
   Flag = "ItemESP",
   Callback = function(Value)
      espEnabled = Value
      if Value then applyESP() else clearESP() end
   end
})

Tab:CreateToggle({
   Name = "Rainbow ESP",
   CurrentValue = false,
   Flag = "RainbowESP",
   Callback = function(Value)
      rainbowESP = Value
   end
})

Tab:CreateColorPicker({
   Name = "ESP Color",
   Color = Color3.fromRGB(255, 255, 255),
   Flag = "ESPColor",
   Callback = function(Value)
      espColor = Value
      for _, h in pairs(espObjects) do
         h.FillColor = Value
         h.OutlineColor = Value
      end
   end
})

local NameTagSection = Tab:CreateSection("Item NameTags")

local createNameTag = function(obj)
   local billboard = Instance.new("BillboardGui")
   billboard.Parent = obj
   billboard.Adornee = obj
   billboard.Size = UDim2.new(0, 200, 0, 30)
   billboard.StudsOffset = Vector3.new(0, 2, 0)
   billboard.AlwaysOnTop = true
   
   local textLabel = Instance.new("TextLabel")
   textLabel.Parent = billboard
   textLabel.Size = UDim2.new(1, 0, 1, 0)
   textLabel.BackgroundTransparency = 1
   textLabel.Text = obj.Name
   textLabel.TextColor3 = nametagColor
   textLabel.TextStrokeTransparency = 0.5
   textLabel.Font = Enum.Font.SourceSansBold
   textLabel.TextSize = 14
   
   table.insert(nametagObjects, billboard)
   return billboard
end

local clearNameTags = function()
   for _, nt in pairs(nametagObjects) do
      nt:Destroy()
   end
   nametagObjects = {}
end

local applyNameTags = function()
   clearNameTags()
   if not nametagsEnabled then return end
   for i = 1, 10 do
      local preset = workspace:FindFirstChild("Preset" .. i)
      if preset then
         for _, obj in pairs(preset:GetChildren()) do
            if obj:FindFirstChild("InteractRemote") and obj:IsA("BasePart") then
               createNameTag(obj)
            end
         end
      end
   end
end

Tab:CreateToggle({
   Name = "Item NameTags",
   CurrentValue = false,
   Flag = "ItemNameTags",
   Callback = function(Value)
      nametagsEnabled = Value
      if Value then applyNameTags() else clearNameTags() end
   end
})

Tab:CreateColorPicker({
   Name = "NameTag Color",
   Color = Color3.fromRGB(255, 255, 255),
   Flag = "NameTagColor",
   Callback = function(Value)
      nametagColor = Value
      for _, nt in pairs(nametagObjects) do
         if nt:FindFirstChildOfClass("TextLabel") then
            nt:FindFirstChildOfClass("TextLabel").TextColor3 = Value
         end
      end
   end
})

local DistanceSection = Tab:CreateSection("Item Distance")

local createDistanceTag = function(obj)
   local billboard = Instance.new("BillboardGui")
   billboard.Parent = obj
   billboard.Adornee = obj
   billboard.Size = UDim2.new(0, 200, 0, 20)
   billboard.StudsOffset = Vector3.new(0, -1, 0)
   billboard.AlwaysOnTop = true
   
   local textLabel = Instance.new("TextLabel")
   textLabel.Parent = billboard
   textLabel.Size = UDim2.new(1, 0, 1, 0)
   textLabel.BackgroundTransparency = 1
   textLabel.Text = "0 studs"
   textLabel.TextColor3 = distanceColor
   textLabel.TextStrokeTransparency = 0.5
   textLabel.Font = Enum.Font.SourceSansBold
   textLabel.TextSize = 12
   
   table.insert(distanceTags, {billboard = billboard, target = obj})
   return billboard
end

local clearDistanceTags = function()
   for _, dt in pairs(distanceTags) do
      dt.billboard:Destroy()
   end
   distanceTags = {}
end

local applyDistanceTags = function()
   clearDistanceTags()
   if not distanceEnabled then return end
   for i = 1, 10 do
      local preset = workspace:FindFirstChild("Preset" .. i)
      if preset then
         for _, obj in pairs(preset:GetChildren()) do
            if obj:FindFirstChild("InteractRemote") and obj:IsA("BasePart") then
               createDistanceTag(obj)
            end
         end
      end
   end
end

Tab:CreateToggle({
   Name = "Item Distance",
   CurrentValue = false,
   Flag = "ItemDistance",
   Callback = function(Value)
      distanceEnabled = Value
      if Value then applyDistanceTags() else clearDistanceTags() end
   end
})

Tab:CreateColorPicker({
   Name = "Distance Color",
   Color = Color3.fromRGB(255, 255, 255),
   Flag = "DistanceColor",
   Callback = function(Value)
      distanceColor = Value
      for _, dt in pairs(distanceTags) do
         if dt.billboard:FindFirstChildOfClass("TextLabel") then
            dt.billboard:FindFirstChildOfClass("TextLabel").TextColor3 = Value
         end
      end
   end
})

local TracerSection = Tab:CreateSection("Item Tracers")

local tracers = {}

local createItemTracer = function(obj)
   local tracer = Drawing.new("Line")
   tracer.Visible = true
   tracer.Color = tracerColor
   tracer.Thickness = 1
   tracer.Transparency = 1
   table.insert(tracers, {tracer = tracer, target = obj})
   return tracer
end

local clearTracers = function()
   for _, t in pairs(tracers) do
      t.tracer:Remove()
   end
   tracers = {}
end

local applyTracers = function()
   clearTracers()
   if not tracersEnabled then return end
   for i = 1, 10 do
      local preset = workspace:FindFirstChild("Preset" .. i)
      if preset then
         for _, obj in pairs(preset:GetChildren()) do
            if obj:FindFirstChild("InteractRemote") and obj:IsA("BasePart") then
               createItemTracer(obj)
            end
         end
      end
   end
end

Tab:CreateToggle({
   Name = "Item Tracers",
   CurrentValue = false,
   Flag = "ItemTracers",
   Callback = function(Value)
      tracersEnabled = Value
      if Value then applyTracers() else clearTracers() end
   end
})

Tab:CreateToggle({
   Name = "Rainbow Tracers",
   CurrentValue = false,
   Flag = "RainbowItemTracers",
   Callback = function(Value)
      rainbowTracers = Value
   end
})

Tab:CreateColorPicker({
   Name = "Tracer Color",
   Color = Color3.fromRGB(255, 255, 255),
   Flag = "TracerColor",
   Callback = function(Value)
      tracerColor = Value
      for _, t in pairs(tracers) do
         t.tracer.Color = Value
      end
   end
})

local VisualTab = Window:CreateTab("Visual", 4483362458)

local VisualSection = VisualTab:CreateSection("Visuals")

VisualTab:CreateSlider({
   Name = "FOV Changer",
   Range = {30, 120},
   Increment = 1,
   Suffix = "FOV",
   CurrentValue = 70,
   Flag = "FOV",
   Callback = function(Value)
      workspace.CurrentCamera.FieldOfView = Value
   end
})

local grannyESPObjects = {}
local grannyESPColor = Color3.fromRGB(255, 0, 0)
local grannyESPEnabled = false
local rainbowGrannyESP = false

local clearGrannyESP = function()
   for _, h in pairs(grannyESPObjects) do
      h:Destroy()
   end
   grannyESPObjects = {}
end

local applyGrannyESP = function()
   clearGrannyESP()
   if not grannyESPEnabled then return end
   for i = 1, 10 do
      local preset = workspace:FindFirstChild("Preset" .. i)
      if preset then
         local granny = preset:FindFirstChild("Granny")
         if granny then
            local highlight = Instance.new("Highlight")
            highlight.Parent = granny
            highlight.Adornee = granny
            highlight.FillColor = grannyESPColor
            highlight.FillTransparency = 0.5
            highlight.OutlineColor = grannyESPColor
            highlight.OutlineTransparency = 0
            table.insert(grannyESPObjects, highlight)
         end
      end
   end
end

VisualTab:CreateToggle({
   Name = "Granny ESP",
   CurrentValue = false,
   Flag = "GrannyESP",
   Callback = function(Value)
      grannyESPEnabled = Value
      if Value then applyGrannyESP() else clearGrannyESP() end
   end
})

VisualTab:CreateToggle({
   Name = "Rainbow Granny ESP",
   CurrentValue = false,
   Flag = "RainbowGrannyESP",
   Callback = function(Value)
      rainbowGrannyESP = Value
   end
})

VisualTab:CreateColorPicker({
   Name = "Granny ESP Color",
   Color = Color3.fromRGB(255, 0, 0),
   Flag = "GrannyESPColor",
   Callback = function(Value)
      grannyESPColor = Value
      for _, h in pairs(grannyESPObjects) do
         h.FillColor = Value
         h.OutlineColor = Value
      end
   end
})

local grandpaESPObjects = {}
local grandpaESPColor = Color3.fromRGB(0, 255, 0)
local grandpaESPEnabled = false
local rainbowGrandpaESP = false

local clearGrandpaESP = function()
   for _, h in pairs(grandpaESPObjects) do
      h:Destroy()
   end
   grandpaESPObjects = {}
end

local applyGrandpaESP = function()
   clearGrandpaESP()
   if not grandpaESPEnabled then return end
   for i = 1, 10 do
      local preset = workspace:FindFirstChild("Preset" .. i)
      if preset then
         local grandpa = preset:FindFirstChild("Grandpa")
         if grandpa then
            local highlight = Instance.new("Highlight")
            highlight.Parent = grandpa
            highlight.Adornee = grandpa
            highlight.FillColor = grandpaESPColor
            highlight.FillTransparency = 0.5
            highlight.OutlineColor = grandpaESPColor
            highlight.OutlineTransparency = 0
            table.insert(grandpaESPObjects, highlight)
         end
      end
   end
end

VisualTab:CreateToggle({
   Name = "Grandpa ESP",
   CurrentValue = false,
   Flag = "GrandpaESP",
   Callback = function(Value)
      grandpaESPEnabled = Value
      if Value then applyGrandpaESP() else clearGrandpaESP() end
   end
})

VisualTab:CreateToggle({
   Name = "Rainbow Grandpa ESP",
   CurrentValue = false,
   Flag = "RainbowGrandpaESP",
   Callback = function(Value)
      rainbowGrandpaESP = Value
   end
})

VisualTab:CreateColorPicker({
   Name = "Grandpa ESP Color",
   Color = Color3.fromRGB(0, 255, 0),
   Flag = "GrandpaESPColor",
   Callback = function(Value)
      grandpaESPColor = Value
      for _, h in pairs(grandpaESPObjects) do
         h.FillColor = Value
         h.OutlineColor = Value
      end
   end
})

local slendrinaESPObjects = {}
local slendrinaESPColor = Color3.fromRGB(255, 0, 255)
local slendrinaESPEnabled = false
local rainbowSlendrinaESP = false

local clearSlendrinaESP = function()
   for _, h in pairs(slendrinaESPObjects) do
      h:Destroy()
   end
   slendrinaESPObjects = {}
end

local applySlendrinaESP = function()
   clearSlendrinaESP()
   if not slendrinaESPEnabled then return end
   for i = 1, 10 do
      local preset = workspace:FindFirstChild("Preset" .. i)
      if preset then
         local slendrina = preset:FindFirstChild("Slendrina")
         if slendrina then
            local highlight = Instance.new("Highlight")
            highlight.Parent = slendrina
            highlight.Adornee = slendrina
            highlight.FillColor = slendrinaESPColor
            highlight.FillTransparency = 0.5
            highlight.OutlineColor = slendrinaESPColor
            highlight.OutlineTransparency = 0
            table.insert(slendrinaESPObjects, highlight)
         end
      end
   end
end

VisualTab:CreateToggle({
   Name = "Slendrina ESP",
   CurrentValue = false,
   Flag = "SlendrinaESP",
   Callback = function(Value)
      slendrinaESPEnabled = Value
      if Value then applySlendrinaESP() else clearSlendrinaESP() end
   end
})

VisualTab:CreateToggle({
   Name = "Rainbow Slendrina ESP",
   CurrentValue = false,
   Flag = "RainbowSlendrinaESP",
   Callback = function(Value)
      rainbowSlendrinaESP = Value
   end
})

VisualTab:CreateColorPicker({
   Name = "Slendrina ESP Color",
   Color = Color3.fromRGB(255, 0, 255),
   Flag = "SlendrinaESPColor",
   Callback = function(Value)
      slendrinaESPColor = Value
      for _, h in pairs(slendrinaESPObjects) do
         h.FillColor = Value
         h.OutlineColor = Value
      end
   end
})

local thirdPersonEnabled = false

VisualTab:CreateToggle({
   Name = "Third Person",
   CurrentValue = false,
   Flag = "ThirdPerson",
   Callback = function(Value)
      thirdPersonEnabled = Value
      if Value then
         player.CameraMinZoomDistance = 0.5
         player.CameraMaxZoomDistance = 20
      else
         player.CameraMinZoomDistance = 0.5
         player.CameraMaxZoomDistance = 0.5
      end
   end
})

local fullbrightEnabled = false
local defaultLighting = {}

VisualTab:CreateToggle({
   Name = "Fullbright",
   CurrentValue = false,
   Flag = "Fullbright",
   Callback = function(Value)
      fullbrightEnabled = Value
      local lighting = game:GetService("Lighting")
      if Value then
         defaultLighting.Brightness = lighting.Brightness
         defaultLighting.ClockTime = lighting.ClockTime
         defaultLighting.FogEnd = lighting.FogEnd
         defaultLighting.GlobalShadows = lighting.GlobalShadows
         defaultLighting.OutdoorAmbient = lighting.OutdoorAmbient
         
         lighting.Brightness = 2
         lighting.ClockTime = 14
         lighting.FogEnd = 100000
         lighting.GlobalShadows = false
         lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
      else
         lighting.Brightness = defaultLighting.Brightness
         lighting.ClockTime = defaultLighting.ClockTime
         lighting.FogEnd = defaultLighting.FogEnd
         lighting.GlobalShadows = defaultLighting.GlobalShadows
         lighting.OutdoorAmbient = defaultLighting.OutdoorAmbient
      end
   end
})

local GameTab = Window:CreateTab("Game", 4483362458)

local DoorSection = GameTab:CreateSection("Door Unlock")

GameTab:CreateButton({
   Name = "Unlock All Doors",
   Callback = function()
      for i = 1, 7 do
         local door = workspace:FindFirstChild("Preset" .. i)
         if door then
            local lockDoor = door:FindFirstChild("LockPickDoor" .. i)
            if lockDoor then
               lockDoor:Destroy()
            end
         end
      end
   end
})

local GrannyTab = Window:CreateTab("Granny", 4483362458)

local function findGrannyModel()
   for i = 1, 10 do
      local preset = workspace:FindFirstChild("Preset" .. i)
      if preset then
         local granny = preset:FindFirstChild("Granny")
         if granny then
            return granny
         end
      end
   end
   return nil
end

GrannyTab:CreateButton({
   Name = "Kill Granny",
   Callback = function()
      local granny = findGrannyModel()
      if granny then
         local zombie = granny:FindFirstChild("Zombie")
         if zombie then
            zombie.Health = 0
         end
      end
   end
})

GrannyTab:CreateButton({
   Name = "Destroy Granny",
   Callback = function()
      local granny = findGrannyModel()
      if granny then
         granny:Destroy()
      end
   end
})

GrannyTab:CreateButton({
   Name = "Stun Granny",
   Callback = function()
      local granny = findGrannyModel()
      if granny then
         local zombie = granny:FindFirstChild("Zombie")
         if zombie then
            zombie.WalkSpeed = 0
         end
      end
   end
})

GrannyTab:CreateButton({
   Name = "Teleport Granny",
   Callback = function()
      local granny = findGrannyModel()
      if granny then
         local hrp = granny:FindFirstChild("HumanoidRootPart")
         if hrp then
            hrp.CFrame = CFrame.new(0, -500, 0)
         end
      end
   end
})

local antiGrannyKillEnabled = false

GrannyTab:CreateToggle({
   Name = "Anti Granny (Kill)",
   CurrentValue = false,
   Flag = "AntiGrannyKill",
   Callback = function(Value)
      antiGrannyKillEnabled = Value
   end
})

local instanceKillEnabled = false
local instanceKillTarget = ""

GrannyTab:CreateToggle({
   Name = "Instance Kill Granny",
   CurrentValue = false,
   Flag = "InstanceKillGranny",
   Callback = function(Value)
      instanceKillEnabled = Value
      instanceKillTarget = "Granny"
   end
})

local GrandpaTab = Window:CreateTab("Grandpa", 4483362458)

local function findGrandpaModel()
   for i = 1, 10 do
      local preset = workspace:FindFirstChild("Preset" .. i)
      if preset then
         local grandpa = preset:FindFirstChild("Grandpa")
         if grandpa then
            return grandpa
         end
      end
   end
   return nil
end

GrandpaTab:CreateButton({
   Name = "Kill Grandpa",
   Callback = function()
      local grandpa = findGrandpaModel()
      if grandpa then
         local zombie = grandpa:FindFirstChild("Zombie")
         if zombie then
            zombie.Health = 0
         end
      end
   end
})

GrandpaTab:CreateButton({
   Name = "Destroy Grandpa",
   Callback = function()
      local grandpa = findGrandpaModel()
      if grandpa then
         grandpa:Destroy()
      end
   end
})

GrandpaTab:CreateButton({
   Name = "Stun Grandpa",
   Callback = function()
      local grandpa = findGrandpaModel()
      if grandpa then
         local zombie = grandpa:FindFirstChild("Zombie")
         if zombie then
            zombie.WalkSpeed = 0
         end
      end
   end
})

GrandpaTab:CreateButton({
   Name = "Teleport Grandpa",
   Callback = function()
      local grandpa = findGrandpaModel()
      if grandpa then
         local hrp = grandpa:FindFirstChild("HumanoidRootPart")
         if hrp then
            hrp.CFrame = CFrame.new(0, -500, 0)
         end
      end
   end
})

local antiGrandpaKillEnabled = false

GrandpaTab:CreateToggle({
   Name = "Anti Grandpa (Kill)",
   CurrentValue = false,
   Flag = "AntiGrandpaKill",
   Callback = function(Value)
      antiGrandpaKillEnabled = Value
   end
})

GrandpaTab:CreateToggle({
   Name = "Instance Kill Grandpa",
   CurrentValue = false,
   Flag = "InstanceKillGrandpa",
   Callback = function(Value)
      instanceKillEnabled = Value
      instanceKillTarget = "Grandpa"
   end
})

local SlendrinaTab = Window:CreateTab("Slendrina", 4483362458)

local function findSlendrinaModel()
   for i = 1, 10 do
      local preset = workspace:FindFirstChild("Preset" .. i)
      if preset then
         local slendrina = preset:FindFirstChild("Slendrina")
         if slendrina then
            return slendrina
         end
      end
   end
   return nil
end

SlendrinaTab:CreateButton({
   Name = "Kill Slendrina",
   Callback = function()
      local slendrina = findSlendrinaModel()
      if slendrina then
         local enemy = slendrina:FindFirstChild("SlendrinaEnemy")
         if enemy then
            enemy.Health = 0
         end
      end
   end
})

SlendrinaTab:CreateButton({
   Name = "Destroy Slendrina",
   Callback = function()
      local slendrina = findSlendrinaModel()
      if slendrina then
         slendrina:Destroy()
      end
   end
})

SlendrinaTab:CreateButton({
   Name = "Stun Slendrina",
   Callback = function()
      local slendrina = findSlendrinaModel()
      if slendrina then
         local enemy = slendrina:FindFirstChild("SlendrinaEnemy")
         if enemy then
            enemy.WalkSpeed = 0
         end
      end
   end
})

SlendrinaTab:CreateButton({
   Name = "Teleport Slendrina",
   Callback = function()
      local slendrina = findSlendrinaModel()
      if slendrina then
         local hrp = slendrina:FindFirstChild("HumanoidRootPart")
         if hrp then
            hrp.CFrame = CFrame.new(0, -500, 0)
         end
      end
   end
})

local antiSlendrinaEnabled = false

SlendrinaTab:CreateToggle({
   Name = "Anti Slendrina (Destroy)",
   CurrentValue = false,
   Flag = "AntiSlendrinaDestroy",
   Callback = function(Value)
      antiSlendrinaEnabled = Value
   end
})

SlendrinaTab:CreateToggle({
   Name = "Instance Kill Slendrina",
   CurrentValue = false,
   Flag = "InstanceKillSlendrina",
   Callback = function(Value)
      instanceKillEnabled = Value
      instanceKillTarget = "Slendrina"
   end
})

local LocalPlayerTab = Window:CreateTab("LocalPlayer", 4483362458)

local antiFallEnabled = false
local antiFallConnection = nil

LocalPlayerTab:CreateToggle({
   Name = "Anti Fall",
   CurrentValue = false,
   Flag = "AntiFall",
   Callback = function(Value)
      antiFallEnabled = Value
      if Value then
         local char = player.Character or player.CharacterAdded:Wait()
         local hum = char:WaitForChild("Humanoid")
         
         if antiFallConnection then antiFallConnection:Disconnect() end
         antiFallConnection = hum.StateChanged:Connect(function(oldState, newState)
            if not antiFallEnabled then return end
            if newState == Enum.HumanoidStateType.Freefall then
               local currentChar = player.Character
               if not currentChar then return end
               local rootPart = currentChar:FindFirstChild("HumanoidRootPart")
               if not rootPart then return end
               
               local rayParams = RaycastParams.new()
               rayParams.FilterType = Enum.RaycastFilterType.Blacklist
               rayParams.FilterDescendantsInstances = {currentChar}
               
               local rayResult = workspace:Raycast(rootPart.Position, Vector3.new(0, -999, 0), rayParams)
               
               if rayResult then
                  rootPart.CFrame = CFrame.new(rayResult.Position + Vector3.new(0, 3, 0))
               end
            end
         end)
      else
         if antiFallConnection then
            antiFallConnection:Disconnect()
            antiFallConnection = nil
         end
      end
   end
})

local speedEnabled = false

LocalPlayerTab:CreateToggle({
   Name = "Speed",
   CurrentValue = false,
   Flag = "Speed",
   Callback = function(Value)
      speedEnabled = Value
   end
})

local invis_on = false
local invisTimer = 0
local invisX = 1000
local invisY = 1000
local invisZ = 1000

local function setTransparency(character, transparency)
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") then
            part.Transparency = transparency
        end
    end
end

local function activateInvis()
   if invis_on then return end
   local charNow = player.Character
   if not charNow or not charNow:FindFirstChild("HumanoidRootPart") then return end
   
   local savedpos = charNow.HumanoidRootPart.CFrame
   charNow.HumanoidRootPart.CFrame = CFrame.new(invisX, invisY, invisZ)
   task.wait(0.15)
   
   local Seat = Instance.new('Seat', game.Workspace)
   Seat.Anchored = false
   Seat.CanCollide = false
   Seat.Name = 'invischair'
   Seat.Transparency = 1
   Seat.Position = Vector3.new(invisX, invisY, invisZ)
   
   local Weld = Instance.new("Weld", Seat)
   local torso = charNow:FindFirstChild("Torso") or charNow:FindFirstChild("UpperTorso")
   if torso then
      Weld.Part0 = Seat
      Weld.Part1 = torso
   end
   
   task.wait()
   Seat.CFrame = savedpos
   setTransparency(charNow, 0.5)
   invis_on = true
   invisTimer = 3
end

local function deactivateInvis()
   if not invis_on then return end
   local invisChair = workspace:FindFirstChild('invischair')
   if invisChair then invisChair:Destroy() end
   local charNow = player.Character
   if charNow then
      setTransparency(charNow, 0)
   end
   invis_on = false
   invisTimer = 0
end

LocalPlayerTab:CreateToggle({
   Name = "Invisible",
   CurrentValue = false,
   Flag = "Invisible",
   Callback = function(Value)
      if Value then
         activateInvis()
      else
         deactivateInvis()
      end
   end
})

local espUpdateTimer = 0

game:GetService("RunService").Heartbeat:Connect(function(delta)
   if speedEnabled then
      local char = player.Character
      if char then
         local hum = char:FindFirstChild("Humanoid")
         if hum then
            hum.WalkSpeed = 10
         end
      end
   end
   
   espUpdateTimer = espUpdateTimer + delta
   if espUpdateTimer >= 5 then
      espUpdateTimer = 0
      if grannyESPEnabled then applyGrannyESP() end
      if grandpaESPEnabled then applyGrandpaESP() end
      if slendrinaESPEnabled then applySlendrinaESP() end
   end
   
   if instanceKillEnabled then
      if instanceKillTarget == "Granny" then
         local granny = findGrannyModel()
         if granny then
            local zombie = granny:FindFirstChild("Zombie")
            if zombie then
               zombie.Health = 0
            end
         end
      elseif instanceKillTarget == "Grandpa" then
         local grandpa = findGrandpaModel()
         if grandpa then
            local zombie = grandpa:FindFirstChild("Zombie")
            if zombie then
               zombie.Health = 0
            end
         end
      elseif instanceKillTarget == "Slendrina" then
         local slendrina = findSlendrinaModel()
         if slendrina then
            local enemy = slendrina:FindFirstChild("SlendrinaEnemy")
            if enemy then
               enemy.Health = 0
            end
         end
      end
   end
   
   if antiSlendrinaEnabled then
      local slendrina = findSlendrinaModel()
      if slendrina then
         slendrina:Destroy()
      end
   end
end)

game:GetService("RunService").RenderStepped:Connect(function(delta)
   local cam = workspace.CurrentCamera
   local hue = tick() % 5 / 5
   local rainbowColor = Color3.fromHSV(hue, 1, 1)
   
   if invisTimer > 0 then
      invisTimer = invisTimer - delta
      if invisTimer <= 0 then
         deactivateInvis()
      end
   end
   
   if rainbowESP then
      for _, h in pairs(espObjects) do
         h.FillColor = rainbowColor
         h.OutlineColor = rainbowColor
      end
   end
   
   if rainbowGrannyESP then
      for _, h in pairs(grannyESPObjects) do
         h.FillColor = rainbowColor
         h.OutlineColor = rainbowColor
      end
   end
   
   if rainbowGrandpaESP then
      for _, h in pairs(grandpaESPObjects) do
         h.FillColor = rainbowColor
         h.OutlineColor = rainbowColor
      end
   end
   
   if rainbowSlendrinaESP then
      for _, h in pairs(slendrinaESPObjects) do
         h.FillColor = rainbowColor
         h.OutlineColor = rainbowColor
      end
   end
   
   if distanceEnabled then
      local char = player.Character
      local root = char and char:FindFirstChild("HumanoidRootPart")
      if root then
         for _, dt in pairs(distanceTags) do
            if dt.target and dt.target.Parent then
               local dist = math.floor((dt.target.Position - root.Position).Magnitude)
               if dt.billboard:FindFirstChildOfClass("TextLabel") then
                  dt.billboard:FindFirstChildOfClass("TextLabel").Text = dist .. " studs"
               end
               dt.billboard.Enabled = true
            else
               dt.billboard.Enabled = false
            end
         end
      end
   end
   
   if tracersEnabled then
      for _, t in pairs(tracers) do
         if t.target and t.target.Parent then
            local screenPos, onScreen = cam:WorldToViewportPoint(t.target.Position)
            if onScreen then
               t.tracer.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
               t.tracer.To = Vector2.new(screenPos.X, screenPos.Y)
               t.tracer.Visible = true
            else
               t.tracer.Visible = false
            end
            if rainbowTracers then
               t.tracer.Color = rainbowColor
            end
         else
            t.tracer.Visible = false
         end
      end
   end
   
   if antiGrannyKillEnabled then
      local char = player.Character
      local root = char and char:FindFirstChild("HumanoidRootPart")
      if root then
         local granny = findGrannyModel()
         if granny and granny:FindFirstChild("HumanoidRootPart") then
            local dist = (granny.HumanoidRootPart.Position - root.Position).Magnitude
            if dist <= 10 then
               local zombie = granny:FindFirstChild("Zombie")
               if zombie then
                  zombie.Health = 0
               end
            end
         end
      end
   end
   
   if antiGrandpaKillEnabled then
      local char = player.Character
      local root = char and char:FindFirstChild("HumanoidRootPart")
      if root then
         local grandpa = findGrandpaModel()
         if grandpa and grandpa:FindFirstChild("HumanoidRootPart") then
            local dist = (grandpa.HumanoidRootPart.Position - root.Position).Magnitude
            if dist <= 10 then
               local zombie = grandpa:FindFirstChild("Zombie")
               if zombie then
                  zombie.Health = 0
               end
            end
         end
      end
   end
end)

player.CharacterAdded:Connect(function(newChar)
   task.wait(0.5)
   if invis_on then deactivateInvis() end
   if espEnabled then applyESP() end
   if nametagsEnabled then applyNameTags() end
   if distanceEnabled then applyDistanceTags() end
   if tracersEnabled then applyTracers() end
   if grannyESPEnabled then applyGrannyESP() end
   if grandpaESPEnabled then applyGrandpaESP() end
   if slendrinaESPEnabled then applySlendrinaESP() end
   if antiFallEnabled then
      local hum = newChar:WaitForChild("Humanoid")
      if antiFallConnection then antiFallConnection:Disconnect() end
      antiFallConnection = hum.StateChanged:Connect(function(oldState, newState)
         if not antiFallEnabled then return end
         if newState == Enum.HumanoidStateType.Freefall then
            local currentChar = player.Character
            if not currentChar then return end
            local rootPart = currentChar:FindFirstChild("HumanoidRootPart")
            if not rootPart then return end
            
            local rayParams = RaycastParams.new()
            rayParams.FilterType = Enum.RaycastFilterType.Blacklist
            rayParams.FilterDescendantsInstances = {currentChar}
            
            local rayResult = workspace:Raycast(rootPart.Position, Vector3.new(0, -999, 0), rayParams)
            
            if rayResult then
               rootPart.CFrame = CFrame.new(rayResult.Position + Vector3.new(0, 3, 0))
            end
         end
      end)
   end
end)
