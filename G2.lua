local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Granny: Multiplayer Chapter: 2 | by Likegenm",
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

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

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
         local locks = preset:FindFirstChild("Locks")
         if locks then
            local granny = locks:FindFirstChild("Granny")
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
         local locks = preset:FindFirstChild("Locks")
         if locks then
            local grandpa = locks:FindFirstChild("Grandpa")
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

local PlayersESPSection = VisualTab:CreateSection("Players ESP")

local playersESPObjects = {}
local playersESPColor = Color3.fromRGB(0, 255, 0)
local playersESPEnabled = false
local rainbowPlayersESP = false

local playersTracers = {}
local playersTracersEnabled = false
local playersTracerColor = Color3.fromRGB(0, 255, 0)
local rainbowPlayersTracers = false

local clearPlayersESP = function()
   for _, h in pairs(playersESPObjects) do
      h:Destroy()
   end
   playersESPObjects = {}
end

local applyPlayersESP = function()
   clearPlayersESP()
   if not playersESPEnabled then return end
   for _, plr in pairs(Players:GetPlayers()) do
      if plr ~= player and plr.Character then
         local highlight = Instance.new("Highlight")
         highlight.Parent = plr.Character
         highlight.Adornee = plr.Character
         highlight.FillColor = playersESPColor
         highlight.FillTransparency = 0.5
         highlight.OutlineColor = playersESPColor
         highlight.OutlineTransparency = 0
         table.insert(playersESPObjects, highlight)
      end
   end
end

local clearPlayersTracers = function()
   for _, t in pairs(playersTracers) do
      t.tracer:Remove()
   end
   playersTracers = {}
end

local applyPlayersTracers = function()
   clearPlayersTracers()
   if not playersTracersEnabled then return end
   for _, plr in pairs(Players:GetPlayers()) do
      if plr ~= player and plr.Character then
         local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
         if hrp then
            local tracer = Drawing.new("Line")
            tracer.Visible = true
            tracer.Color = playersTracerColor
            tracer.Thickness = 1
            tracer.Transparency = 1
            table.insert(playersTracers, {tracer = tracer, target = hrp})
         end
      end
   end
end

VisualTab:CreateToggle({
   Name = "Players ESP",
   CurrentValue = false,
   Flag = "PlayersESP",
   Callback = function(Value)
      playersESPEnabled = Value
      if Value then applyPlayersESP() else clearPlayersESP() end
   end
})

VisualTab:CreateToggle({
   Name = "Rainbow Players ESP",
   CurrentValue = false,
   Flag = "RainbowPlayersESP",
   Callback = function(Value)
      rainbowPlayersESP = Value
   end
})

VisualTab:CreateColorPicker({
   Name = "Players ESP Color",
   Color = Color3.fromRGB(0, 255, 0),
   Flag = "PlayersESPColor",
   Callback = function(Value)
      playersESPColor = Value
      for _, h in pairs(playersESPObjects) do
         h.FillColor = Value
         h.OutlineColor = Value
      end
   end
})

VisualTab:CreateToggle({
   Name = "Players Tracers",
   CurrentValue = false,
   Flag = "PlayersTracers",
   Callback = function(Value)
      playersTracersEnabled = Value
      if Value then applyPlayersTracers() else clearPlayersTracers() end
   end
})

VisualTab:CreateToggle({
   Name = "Rainbow Players Tracers",
   CurrentValue = false,
   Flag = "RainbowPlayersTracers",
   Callback = function(Value)
      rainbowPlayersTracers = Value
   end
})

VisualTab:CreateColorPicker({
   Name = "Players Tracer Color",
   Color = Color3.fromRGB(0, 255, 0),
   Flag = "PlayersTracerColor",
   Callback = function(Value)
      playersTracerColor = Value
      for _, t in pairs(playersTracers) do
         t.tracer.Color = Value
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
      local lighting = Lighting
      if Value then
         defaultLighting.Brightness = lighting.Brightness
         defaultLighting.ClockTime = lighting.ClockTime
         defaultLighting.FogEnd = lighting.FogEnd
         defaultLighting.GlobalShadows = lighting.GlobalShadows
         defaultLighting.OutdoorAmbient = lighting.OutdoorAmbient
         defaultLighting.Ambient = lighting.Ambient

         lighting.Brightness = 2
         lighting.ClockTime = 14
         lighting.FogEnd = 100000
         lighting.GlobalShadows = false
         lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
         lighting.Ambient = Color3.fromRGB(128, 128, 128)
      else
         lighting.Brightness = defaultLighting.Brightness
         lighting.ClockTime = defaultLighting.ClockTime
         lighting.FogEnd = defaultLighting.FogEnd
         lighting.GlobalShadows = defaultLighting.GlobalShadows
         lighting.OutdoorAmbient = defaultLighting.OutdoorAmbient
         lighting.Ambient = defaultLighting.Ambient
      end
   end
})

local AmbientColorSection = VisualTab:CreateSection("Ambient Color")

local ambientColorEnabled = false
local ambientColorValue = Color3.fromRGB(255, 255, 255)

VisualTab:CreateToggle({
   Name = "Ambient Color",
   CurrentValue = false,
   Flag = "AmbientColor",
   Callback = function(Value)
      ambientColorEnabled = Value
      if Value then
         Lighting.Ambient = ambientColorValue
      else
         Lighting.Ambient = defaultLighting.Ambient or Color3.new()
      end
   end
})

VisualTab:CreateColorPicker({
   Name = "Ambient Color",
   Color = Color3.fromRGB(255, 255, 255),
   Flag = "AmbientColorPicker",
   Callback = function(Value)
      ambientColorValue = Value
      if ambientColorEnabled then
         Lighting.Ambient = Value
      end
   end
})

local TimeChangerSection = VisualTab:CreateSection("Time Changer")

local timeChangerEnabled = false
local timeValue = 14

VisualTab:CreateToggle({
   Name = "Time Changer",
   CurrentValue = false,
   Flag = "TimeChanger",
   Callback = function(Value)
      timeChangerEnabled = Value
      if not Value then
         Lighting.ClockTime = defaultLighting.ClockTime or 14
      end
   end
})

VisualTab:CreateSlider({
   Name = "Time",
   Range = {0, 24},
   Increment = 0.1,
   Suffix = "",
   CurrentValue = 14,
   Flag = "TimeSlider",
   Callback = function(Value)
      timeValue = Value
      if timeChangerEnabled then
         Lighting.ClockTime = Value
      end
   end
})

local GrannyTab = Window:CreateTab("Granny", 4483362458)

local KillSection = GrannyTab:CreateSection("Kill")

local function findGrannyModel()
   for i = 1, 10 do
      local preset = workspace:FindFirstChild("Preset" .. i)
      if preset then
         local locks = preset:FindFirstChild("Locks")
         if locks then
            local granny = locks:FindFirstChild("Granny")
            if granny then
               return granny
            end
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
   Name = "Freeze Granny",
   Callback = function()
      local granny = findGrannyModel()
      if granny then
         local zombie = granny:FindFirstChild("Zombie")
         if zombie then
            zombie.WalkSpeed = 0
         end
         local hrp = granny:FindFirstChild("HumanoidRootPart")
         if hrp then
            hrp.Anchored = true
         end
      end
   end
})

local ViewAngleGrannySection = GrannyTab:CreateSection("View Angle")

local viewAngleGrannyEnabled = false

GrannyTab:CreateToggle({
   Name = "View Angle Granny",
   CurrentValue = false,
   Flag = "ViewAngleGranny",
   Callback = function(Value)
      viewAngleGrannyEnabled = Value
   end
})

local TeleportSection = GrannyTab:CreateSection("Teleport")

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

local OrbitSection = GrannyTab:CreateSection("Orbit")

local orbitGrannyEnabled = false
local orbitGrannySpeed = 5
local orbitGrannyRadius = 10
local orbitGrannyHeight = 0

GrannyTab:CreateToggle({
   Name = "Orbit Granny",
   CurrentValue = false,
   Flag = "OrbitGranny",
   Callback = function(Value)
      orbitGrannyEnabled = Value
   end
})

GrannyTab:CreateSlider({
   Name = "Orbit Speed",
   Range = {1, 20},
   Increment = 1,
   Suffix = "",
   CurrentValue = 5,
   Flag = "OrbitGrannySpeed",
   Callback = function(Value)
      orbitGrannySpeed = Value
   end
})

GrannyTab:CreateSlider({
   Name = "Orbit Radius",
   Range = {5, 30},
   Increment = 1,
   Suffix = "Studs",
   CurrentValue = 10,
   Flag = "OrbitGrannyRadius",
   Callback = function(Value)
      orbitGrannyRadius = Value
   end
})

GrannyTab:CreateSlider({
   Name = "Orbit Height",
   Range = {-10, 10},
   Increment = 1,
   Suffix = "Studs",
   CurrentValue = 0,
   Flag = "OrbitGrannyHeight",
   Callback = function(Value)
      orbitGrannyHeight = Value
   end
})

local AutoFreezeGrannySection = GrannyTab:CreateSection("Auto Freeze")

local autoFreezeGrannyEnabled = false
local autoFreezeGrannyRange = 10

GrannyTab:CreateToggle({
   Name = "Auto Freeze Granny",
   CurrentValue = false,
   Flag = "AutoFreezeGranny",
   Callback = function(Value)
      autoFreezeGrannyEnabled = Value
   end
})

GrannyTab:CreateSlider({
   Name = "Auto Freeze Range",
   Range = {1, 50},
   Increment = 1,
   Suffix = "Studs",
   CurrentValue = 10,
   Flag = "AutoFreezeGrannyRange",
   Callback = function(Value)
      autoFreezeGrannyRange = Value
   end
})

local AntiGrannySection = GrannyTab:CreateSection("Anti Granny")

local antiGrannyKillEnabled = false

GrannyTab:CreateToggle({
   Name = "Anti Granny (Kill)",
   CurrentValue = false,
   Flag = "AntiGrannyKill",
   Callback = function(Value)
      antiGrannyKillEnabled = Value
   end
})

local instanceKillGrannyEnabled = false

GrannyTab:CreateToggle({
   Name = "Instance Kill Granny",
   CurrentValue = false,
   Flag = "InstanceKillGranny",
   Callback = function(Value)
      instanceKillGrannyEnabled = Value
   end
})

local GrandpaTab = Window:CreateTab("Grandpa", 4483362458)

local GrandpaKillSection = GrandpaTab:CreateSection("Kill")

local function findGrandpaModel()
   for i = 1, 10 do
      local preset = workspace:FindFirstChild("Preset" .. i)
      if preset then
         local locks = preset:FindFirstChild("Locks")
         if locks then
            local grandpa = locks:FindFirstChild("Grandpa")
            if grandpa then
               return grandpa
            end
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
   Name = "Freeze Grandpa",
   Callback = function()
      local grandpa = findGrandpaModel()
      if grandpa then
         local zombie = grandpa:FindFirstChild("Zombie")
         if zombie then
            zombie.WalkSpeed = 0
         end
         local hrp = grandpa:FindFirstChild("HumanoidRootPart")
         if hrp then
            hrp.Anchored = true
         end
      end
   end
})

local ViewAngleGrandpaSection = GrandpaTab:CreateSection("View Angle")

local viewAngleGrandpaEnabled = false

GrandpaTab:CreateToggle({
   Name = "View Angle Grandpa",
   CurrentValue = false,
   Flag = "ViewAngleGrandpa",
   Callback = function(Value)
      viewAngleGrandpaEnabled = Value
   end
})

local GrandpaTeleportSection = GrandpaTab:CreateSection("Teleport")

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

local OrbitGrandpaSection = GrandpaTab:CreateSection("Orbit")

local orbitGrandpaEnabled = false
local orbitGrandpaSpeed = 5
local orbitGrandpaRadius = 10
local orbitGrandpaHeight = 0

GrandpaTab:CreateToggle({
   Name = "Orbit Grandpa",
   CurrentValue = false,
   Flag = "OrbitGrandpa",
   Callback = function(Value)
      orbitGrandpaEnabled = Value
   end
})

GrandpaTab:CreateSlider({
   Name = "Orbit Speed",
   Range = {1, 20},
   Increment = 1,
   Suffix = "",
   CurrentValue = 5,
   Flag = "OrbitGrandpaSpeed",
   Callback = function(Value)
      orbitGrandpaSpeed = Value
   end
})

GrandpaTab:CreateSlider({
   Name = "Orbit Radius",
   Range = {5, 30},
   Increment = 1,
   Suffix = "Studs",
   CurrentValue = 10,
   Flag = "OrbitGrandpaRadius",
   Callback = function(Value)
      orbitGrandpaRadius = Value
   end
})

GrandpaTab:CreateSlider({
   Name = "Orbit Height",
   Range = {-10, 10},
   Increment = 1,
   Suffix = "Studs",
   CurrentValue = 0,
   Flag = "OrbitGrandpaHeight",
   Callback = function(Value)
      orbitGrandpaHeight = Value
   end
})

local AutoFreezeGrandpaSection = GrandpaTab:CreateSection("Auto Freeze")

local autoFreezeGrandpaEnabled = false
local autoFreezeGrandpaRange = 10

GrandpaTab:CreateToggle({
   Name = "Auto Freeze Grandpa",
   CurrentValue = false,
   Flag = "AutoFreezeGrandpa",
   Callback = function(Value)
      autoFreezeGrandpaEnabled = Value
   end
})

GrandpaTab:CreateSlider({
   Name = "Auto Freeze Range",
   Range = {1, 50},
   Increment = 1,
   Suffix = "Studs",
   CurrentValue = 10,
   Flag = "AutoFreezeGrandpaRange",
   Callback = function(Value)
      autoFreezeGrandpaRange = Value
   end
})

local AntiGrandpaSection = GrandpaTab:CreateSection("Anti Grandpa")

local antiGrandpaKillEnabled = false

GrandpaTab:CreateToggle({
   Name = "Anti Grandpa (Kill)",
   CurrentValue = false,
   Flag = "AntiGrandpaKill",
   Callback = function(Value)
      antiGrandpaKillEnabled = Value
   end
})

local instanceKillGrandpaEnabled = false

GrandpaTab:CreateToggle({
   Name = "Instance Kill Grandpa",
   CurrentValue = false,
   Flag = "InstanceKillGrandpa",
   Callback = function(Value)
      instanceKillGrandpaEnabled = Value
   end
})

local PetsTab = Window:CreateTab("Pets", 4483362458)

local ChildSection = PetsTab:CreateSection("Child")

local function findChildModels()
   local children = {}
   for i = 1, 10 do
      local preset = workspace:FindFirstChild("Preset" .. i)
      if preset then
         local locks = preset:FindFirstChild("Locks")
         if locks then
            for _, obj in pairs(locks:GetDescendants()) do
               if obj.Name == "SlendrinaChild" then
                  local zombie = obj:FindFirstChild("Zombie")
                  if zombie then
                     table.insert(children, obj)
                  end
               end
            end
         end
      end
   end
   return children
end

PetsTab:CreateButton({
   Name = "Kill Child",
   Callback = function()
      local children = findChildModels()
      for _, child in pairs(children) do
         local zombie = child:FindFirstChild("Zombie")
         if zombie then
            zombie.Health = 0
         end
      end
   end
})

PetsTab:CreateButton({
   Name = "Freeze Child",
   Callback = function()
      local children = findChildModels()
      for _, child in pairs(children) do
         local zombie = child:FindFirstChild("Zombie")
         if zombie then
            zombie.WalkSpeed = 0
         end
         local hrp = child:FindFirstChild("HumanoidRootPart")
         if hrp then
            hrp.Anchored = true
         end
      end
   end
})

PetsTab:CreateButton({
   Name = "Destroy Child",
   Callback = function()
      local children = findChildModels()
      for _, child in pairs(children) do
         child:Destroy()
      end
   end
})

local TeleportsTab = Window:CreateTab("Teleports", 4483362458)

local PlayersTeleportSection = TeleportsTab:CreateSection("Teleport to Player")

local selectedPlayer = ""

local function getPlayerList()
   local list = {}
   for _, plr in pairs(Players:GetPlayers()) do
      if plr ~= player then
         table.insert(list, plr.Name)
      end
   end
   return list
end

local playerDropdown = TeleportsTab:CreateDropdown({
   Name = "Select Player",
   Options = getPlayerList(),
   CurrentOption = "",
   Flag = "SelectPlayer",
   Callback = function(Value)
      selectedPlayer = Value
   end
})

TeleportsTab:CreateButton({
   Name = "Refresh Players",
   Callback = function()
      playerDropdown:Refresh(getPlayerList())
   end
})

TeleportsTab:CreateButton({
   Name = "Teleport to Player",
   Callback = function()
      if selectedPlayer == "" then return end
      local target = Players:FindFirstChild(selectedPlayer)
      if target and target.Character then
         local hrp = target.Character:FindFirstChild("HumanoidRootPart")
         if hrp then
            local char = player.Character
            if char then
               local myHrp = char:FindFirstChild("HumanoidRootPart")
               if myHrp then
                  myHrp.CFrame = hrp.CFrame
               end
            end
         end
      end
   end
})

local MapTeleportsSection = TeleportsTab:CreateSection("Map Teleports")

TeleportsTab:CreateButton({
   Name = "Teleport to Void",
   Callback = function()
      local char = player.Character
      if char then
         local hrp = char:FindFirstChild("HumanoidRootPart")
         if hrp then
            hrp.CFrame = CFrame.new(hrp.Position.X, -4995, hrp.Position.Z)
         end
      end
   end
})

local SavedPositionSection = TeleportsTab:CreateSection("Saved Position")

local savedPosition = nil

TeleportsTab:CreateButton({
   Name = "Save Position",
   Callback = function()
      local char = player.Character
      if char then
         local hrp = char:FindFirstChild("HumanoidRootPart")
         if hrp then
            savedPosition = hrp.CFrame
         end
      end
   end
})

TeleportsTab:CreateButton({
   Name = "Teleport to Position",
   Callback = function()
      if savedPosition then
         local char = player.Character
         if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
               hrp.CFrame = savedPosition
            end
         end
      end
   end
})

local LocalPlayerTab = Window:CreateTab("LocalPlayer", 4483362458)

local KillAuraSection = LocalPlayerTab:CreateSection("Kill Aura")

local killAuraEnabled = false
local killAuraRange = 10

LocalPlayerTab:CreateToggle({
   Name = "Kill Aura",
   CurrentValue = false,
   Flag = "KillAura",
   Callback = function(Value)
      killAuraEnabled = Value
   end
})

LocalPlayerTab:CreateSlider({
   Name = "Kill Aura Range",
   Range = {1, 50},
   Increment = 1,
   Suffix = "Studs",
   CurrentValue = 10,
   Flag = "KillAuraRange",
   Callback = function(Value)
      killAuraRange = Value
   end
})

local AntiFallSection = LocalPlayerTab:CreateSection("Anti Fall")

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

local AntiFallV2Section = LocalPlayerTab:CreateSection("Anti Fall V2")

local antiFallV2Enabled = false
local antiFallV2Chance = 100
local antiFallV2Connection = nil

LocalPlayerTab:CreateToggle({
   Name = "Anti Fall V2",
   CurrentValue = false,
   Flag = "AntiFallV2",
   Callback = function(Value)
      antiFallV2Enabled = Value
      if Value then
         local char = player.Character or player.CharacterAdded:Wait()
         local hum = char:WaitForChild("Humanoid")
         if antiFallV2Connection then antiFallV2Connection:Disconnect() end
         antiFallV2Connection = hum.StateChanged:Connect(function(oldState, newState)
            if not antiFallV2Enabled then return end
            if newState == Enum.HumanoidStateType.Freefall then
               local currentChar = player.Character
               if not currentChar then return end
               local rootPart = currentChar:FindFirstChild("HumanoidRootPart")
               if not rootPart then return end
               local rayParams = RaycastParams.new()
               rayParams.FilterType = Enum.RaycastFilterType.Blacklist
               rayParams.FilterDescendantsInstances = {currentChar}
               local rayResult = workspace:Raycast(rootPart.Position, Vector3.new(0, -5, 0), rayParams)
               if rayResult then
                  local chance = math.random(1, 100)
                  if chance <= antiFallV2Chance then
                     rootPart.Velocity = Vector3.new(0, 1, 0)
                  end
               end
            end
         end)
      else
         if antiFallV2Connection then
            antiFallV2Connection:Disconnect()
            antiFallV2Connection = nil
         end
      end
   end
})

LocalPlayerTab:CreateSlider({
   Name = "Anti Fall V2 Chance",
   Range = {1, 100},
   Increment = 1,
   Suffix = "%",
   CurrentValue = 100,
   Flag = "AntiFallV2Chance",
   Callback = function(Value)
      antiFallV2Chance = Value
   end
})

local AntiWaterSection = LocalPlayerTab:CreateSection("Anti Water")

local antiWaterEnabled = false

LocalPlayerTab:CreateToggle({
   Name = "Anti Water",
   CurrentValue = false,
   Flag = "AntiWater",
   Callback = function(Value)
      antiWaterEnabled = Value
   end
})

local SpeedSection = LocalPlayerTab:CreateSection("Speed")

local speedEnabled = false

LocalPlayerTab:CreateToggle({
   Name = "Speed",
   CurrentValue = false,
   Flag = "Speed",
   Callback = function(Value)
      speedEnabled = Value
   end
})

local BunnyHopSection = LocalPlayerTab:CreateSection("Bunny Hop")

local bunnyHopEnabled = false

LocalPlayerTab:CreateToggle({
   Name = "Bunny Hop",
   CurrentValue = false,
   Flag = "BunnyHop",
   Callback = function(Value)
      bunnyHopEnabled = Value
   end
})

local InvisibleSection = LocalPlayerTab:CreateSection("Invisible")

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

local PickUpAuraSection = LocalPlayerTab:CreateSection("PickUp Aura")

local pickUpAuraEnabled = false
local pickUpAuraRange = 10
local pickUpAuraThroughWalls = true
local pickUpAuraChance = 100

LocalPlayerTab:CreateToggle({
   Name = "PickUp Aura",
   CurrentValue = false,
   Flag = "PickUpAura",
   Callback = function(Value)
      pickUpAuraEnabled = Value
   end
})

LocalPlayerTab:CreateSlider({
   Name = "PickUp Aura Range",
   Range = {1, 100},
   Increment = 1,
   Suffix = "Studs",
   CurrentValue = 10,
   Flag = "PickUpAuraRange",
   Callback = function(Value)
      pickUpAuraRange = Value
   end
})

LocalPlayerTab:CreateToggle({
   Name = "PickUp Through Walls",
   CurrentValue = true,
   Flag = "PickUpThroughWalls",
   Callback = function(Value)
      pickUpAuraThroughWalls = Value
   end
})

LocalPlayerTab:CreateSlider({
   Name = "PickUp Chance",
   Range = {1, 100},
   Increment = 1,
   Suffix = "%",
   CurrentValue = 100,
   Flag = "PickUpChance",
   Callback = function(Value)
      pickUpAuraChance = Value
   end
})

local UseAuraSection = LocalPlayerTab:CreateSection("Use Aura")

local useAuraEnabled = false
local useAuraRange = 10

LocalPlayerTab:CreateToggle({
   Name = "Use Aura",
   CurrentValue = false,
   Flag = "UseAura",
   Callback = function(Value)
      useAuraEnabled = Value
   end
})

LocalPlayerTab:CreateSlider({
   Name = "Use Aura Range",
   Range = {1, 100},
   Increment = 1,
   Suffix = "Studs",
   CurrentValue = 10,
   Flag = "UseAuraRange",
   Callback = function(Value)
      useAuraRange = Value
   end
})

local RangeSection = LocalPlayerTab:CreateSection("Range")

local rangeCircleEnabled = false
local rangeCircleColor = Color3.fromRGB(255, 255, 255)
local rangeCircleRainbow = false
local rangeCircle = nil

LocalPlayerTab:CreateToggle({
   Name = "Range",
   CurrentValue = false,
   Flag = "Range",
   Callback = function(Value)
      rangeCircleEnabled = Value
      if not Value and rangeCircle then
         rangeCircle:Destroy()
         rangeCircle = nil
      end
   end
})

LocalPlayerTab:CreateToggle({
   Name = "Range Rainbow",
   CurrentValue = false,
   Flag = "RangeRainbow",
   Callback = function(Value)
      rangeCircleRainbow = Value
   end
})

LocalPlayerTab:CreateColorPicker({
   Name = "Range Color",
   Color = Color3.fromRGB(255, 255, 255),
   Flag = "RangeColor",
   Callback = function(Value)
      rangeCircleColor = Value
      if rangeCircle then
         rangeCircle.BrickColor = BrickColor.new(Value)
      end
   end
})

local NoclipSection = LocalPlayerTab:CreateSection("Noclip")

local noclipEnabled = false
local noclipChance = 50
local noclipMaxThickness = 3.0

LocalPlayerTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Flag = "Noclip",
   Callback = function(Value)
      noclipEnabled = Value
   end
})

LocalPlayerTab:CreateSlider({
   Name = "Noclip Chance",
   Range = {1, 100},
   Increment = 1,
   Suffix = "%",
   CurrentValue = 50,
   Flag = "NoclipChance",
   Callback = function(Value)
      noclipChance = Value
   end
})

LocalPlayerTab:CreateSlider({
   Name = "Max Wall Thickness",
   Range = {1, 6},
   Increment = 0.1,
   Suffix = "Studs",
   CurrentValue = 3.0,
   Flag = "NoclipThickness",
   Callback = function(Value)
      noclipMaxThickness = Value
   end
})

local LagSwitchSection = LocalPlayerTab:CreateSection("Lag Switch")

local lagSwitchEnabled = false
local lagSwitchDuration = 1
local lagSwitchInterval = 5

LocalPlayerTab:CreateToggle({
   Name = "Lag Switch",
   CurrentValue = false,
   Flag = "LagSwitch",
   Callback = function(Value)
      lagSwitchEnabled = Value
   end
})

LocalPlayerTab:CreateSlider({
   Name = "Lag Duration",
   Range = {0.1, 5},
   Increment = 0.1,
   Suffix = "s",
   CurrentValue = 1,
   Flag = "LagDuration",
   Callback = function(Value)
      lagSwitchDuration = Value
   end
})

LocalPlayerTab:CreateSlider({
   Name = "Lag Interval",
   Range = {1, 30},
   Increment = 1,
   Suffix = "s",
   CurrentValue = 5,
   Flag = "LagInterval",
   Callback = function(Value)
      lagSwitchInterval = Value
   end
})

local instanceKillGrannyTimer = 0
local instanceKillGrandpaTimer = 0
local espUpdateTimer = 0
local pickUpAuraTimer = 0
local useAuraTimer = 0
local orbitGrannyAngle = 0
local orbitGrandpaAngle = 0
local killAuraTimer = 0
local autoFreezeGrannyTimer = 0
local autoFreezeGrandpaTimer = 0
local lagSwitchTimer = 0
local lagSwitchActive = false
local noclipTimer = 0
local antiWaterTimer = 0

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

   if bunnyHopEnabled then
      local char = player.Character
      if char then
         local hum = char:FindFirstChild("Humanoid")
         if hum and hum.MoveDirection.Magnitude > 0 and hum:GetState() == Enum.HumanoidStateType.Running then
            if not hum.Jump then
               hum.Jump = true
            end
         end
      end
   end

   if timeChangerEnabled then
      Lighting.ClockTime = timeValue
   end

   antiWaterTimer = antiWaterTimer + delta
   if antiWaterEnabled and antiWaterTimer >= 0.5 then
      antiWaterTimer = 0
      for i = 1, 10 do
         local preset = workspace:FindFirstChild("Preset" .. i)
         if preset then
            local locks = preset:FindFirstChild("Locks")
            if locks then
               for _, obj in pairs(locks:GetDescendants()) do
                  if obj.Name == "Creature" then
                     obj:Destroy()
                  end
               end
            end
         end
      end
      if workspace:FindFirstChild("Creature") then
         workspace.Creature:Destroy()
      end
      if workspace:FindFirstChild("Water") then
         workspace.Water:Destroy()
      end
   end

   instanceKillGrannyTimer = instanceKillGrannyTimer + delta
   if instanceKillGrannyEnabled and instanceKillGrannyTimer >= 1 then
      instanceKillGrannyTimer = 0
      local granny = findGrannyModel()
      if granny then
         local zombie = granny:FindFirstChild("Zombie")
         if zombie then
            zombie.Health = 0
         end
      end
   end

   instanceKillGrandpaTimer = instanceKillGrandpaTimer + delta
   if instanceKillGrandpaEnabled and instanceKillGrandpaTimer >= 1 then
      instanceKillGrandpaTimer = 0
      local grandpa = findGrandpaModel()
      if grandpa then
         local zombie = grandpa:FindFirstChild("Zombie")
         if zombie then
            zombie.Health = 0
         end
      end
   end

   espUpdateTimer = espUpdateTimer + delta
   if espUpdateTimer >= 5 then
      espUpdateTimer = 0
      if espEnabled then applyESP() end
      if grannyESPEnabled then applyGrannyESP() end
      if grandpaESPEnabled then applyGrandpaESP() end
      if playersESPEnabled then applyPlayersESP() end
      if playersTracersEnabled then applyPlayersTracers() end
   end

   pickUpAuraTimer = pickUpAuraTimer + delta
   if pickUpAuraEnabled and pickUpAuraTimer >= 0.5 then
      pickUpAuraTimer = 0
      local char = player.Character
      if char then
         local root = char:FindFirstChild("HumanoidRootPart")
         if root then
            for i = 1, 10 do
               local preset = workspace:FindFirstChild("Preset" .. i)
               if preset then
                  for _, obj in pairs(preset:GetChildren()) do
                     if obj:FindFirstChild("InteractRemote") and obj:IsA("BasePart") then
                        local dist = (obj.Position - root.Position).Magnitude
                        if dist <= pickUpAuraRange then
                           if not pickUpAuraThroughWalls then
                              local rayParams = RaycastParams.new()
                              rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                              rayParams.FilterDescendantsInstances = {char}
                              local rayResult = workspace:Raycast(root.Position, (obj.Position - root.Position).Unit * dist, rayParams)
                              if rayResult then
                                 continue
                              end
                           end
                           local chance = math.random(1, 100)
                           if chance <= pickUpAuraChance then
                              obj.InteractRemote:FireServer(player)
                           end
                        end
                     end
                  end
               end
            end
         end
      end
   end

   useAuraTimer = useAuraTimer + delta
   if useAuraEnabled and useAuraTimer >= 0.5 then
      useAuraTimer = 0
      local char = player.Character
      if char then
         local root = char:FindFirstChild("HumanoidRootPart")
         if root then
            for i = 1, 10 do
               local preset = workspace:FindFirstChild("Preset" .. i)
               if preset then
                  for _, obj in pairs(preset:GetChildren()) do
                     if obj:FindFirstChild("InteractRemote") and obj:IsA("BasePart") then
                        if obj:FindFirstChild("ProximityPrompt") then
                           local dist = (obj.Position - root.Position).Magnitude
                           if dist <= useAuraRange then
                              fireproximityprompt(obj.ProximityPrompt)
                           end
                        end
                     end
                  end
               end
            end
         end
      end
   end

   killAuraTimer = killAuraTimer + delta
   if killAuraEnabled and killAuraTimer >= 0.5 then
      killAuraTimer = 0
      local char = player.Character
      if char then
         local root = char:FindFirstChild("HumanoidRootPart")
         if root then
            local granny = findGrannyModel()
            if granny and granny:FindFirstChild("HumanoidRootPart") then
               local dist = (granny.HumanoidRootPart.Position - root.Position).Magnitude
               if dist <= killAuraRange then
                  local zombie = granny:FindFirstChild("Zombie")
                  if zombie then zombie.Health = 0 end
               end
            end
            local grandpa = findGrandpaModel()
            if grandpa and grandpa:FindFirstChild("HumanoidRootPart") then
               local dist = (grandpa.HumanoidRootPart.Position - root.Position).Magnitude
               if dist <= killAuraRange then
                  local zombie = grandpa:FindFirstChild("Zombie")
                  if zombie then zombie.Health = 0 end
               end
            end
            local children = findChildModels()
            for _, child in pairs(children) do
               local hrp = child:FindFirstChild("HumanoidRootPart")
               if hrp then
                  local dist = (hrp.Position - root.Position).Magnitude
                  if dist <= killAuraRange then
                     local zombie = child:FindFirstChild("Zombie")
                     if zombie then zombie.Health = 0 end
                  end
               end
            end
         end
      end
   end

   autoFreezeGrannyTimer = autoFreezeGrannyTimer + delta
   if autoFreezeGrannyEnabled and autoFreezeGrannyTimer >= 0.5 then
      autoFreezeGrannyTimer = 0
      local char = player.Character
      if char then
         local root = char:FindFirstChild("HumanoidRootPart")
         if root then
            local granny = findGrannyModel()
            if granny and granny:FindFirstChild("HumanoidRootPart") then
               local dist = (granny.HumanoidRootPart.Position - root.Position).Magnitude
               if dist <= autoFreezeGrannyRange then
                  local zombie = granny:FindFirstChild("Zombie")
                  if zombie then zombie.WalkSpeed = 0 end
                  local hrp = granny:FindFirstChild("HumanoidRootPart")
                  if hrp then hrp.Anchored = true end
               end
            end
         end
      end
   end

   autoFreezeGrandpaTimer = autoFreezeGrandpaTimer + delta
   if autoFreezeGrandpaEnabled and autoFreezeGrandpaTimer >= 0.5 then
      autoFreezeGrandpaTimer = 0
      local char = player.Character
      if char then
         local root = char:FindFirstChild("HumanoidRootPart")
         if root then
            local grandpa = findGrandpaModel()
            if grandpa and grandpa:FindFirstChild("HumanoidRootPart") then
               local dist = (grandpa.HumanoidRootPart.Position - root.Position).Magnitude
               if dist <= autoFreezeGrandpaRange then
                  local zombie = grandpa:FindFirstChild("Zombie")
                  if zombie then zombie.WalkSpeed = 0 end
                  local hrp = grandpa:FindFirstChild("HumanoidRootPart")
                  if hrp then hrp.Anchored = true end
               end
            end
         end
      end
   end

   lagSwitchTimer = lagSwitchTimer + delta
   if lagSwitchEnabled then
      if lagSwitchActive then
         if lagSwitchTimer >= lagSwitchDuration then
            lagSwitchTimer = 0
            lagSwitchActive = false
            game:GetService("NetworkClient"):SetOutgoingKBPSLimit(9e9)
         end
      else
         if lagSwitchTimer >= lagSwitchInterval then
            lagSwitchTimer = 0
            lagSwitchActive = true
            game:GetService("NetworkClient"):SetOutgoingKBPSLimit(0)
         end
      end
   elseif lagSwitchActive then
      lagSwitchActive = false
      game:GetService("NetworkClient"):SetOutgoingKBPSLimit(9e9)
   end

   noclipTimer = noclipTimer + delta
   if noclipEnabled and noclipTimer >= 0.1 then
      noclipTimer = 0
      local char = player.Character
      if char then
         local root = char:FindFirstChild("HumanoidRootPart")
         if root then
            local hum = char:FindFirstChild("Humanoid")
            if hum and hum.MoveDirection.Magnitude > 0 then
               local chance = math.random(1, 100)
               if chance <= noclipChance then
                  local moveDir = hum.MoveDirection
                  local rayOrigin = root.Position
                  local rayDir = moveDir * noclipMaxThickness
                  local rayParams = RaycastParams.new()
                  rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                  rayParams.FilterDescendantsInstances = {char}
                  local rayResult = workspace:Raycast(rayOrigin, rayDir, rayParams)
                  if rayResult then
                     root.CFrame = root.CFrame + moveDir * (noclipMaxThickness + 1)
                  end
               end
            end
         end
      end
   end

   if orbitGrannyEnabled then
      local char = player.Character
      if char and char:FindFirstChild("HumanoidRootPart") then
         local granny = findGrannyModel()
         if granny and granny:FindFirstChild("HumanoidRootPart") then
            orbitGrannyAngle = orbitGrannyAngle + (orbitGrannySpeed * delta)
            local offsetX = math.cos(orbitGrannyAngle) * orbitGrannyRadius
            local offsetZ = math.sin(orbitGrannyAngle) * orbitGrannyRadius
            local targetPos = granny.HumanoidRootPart.Position + Vector3.new(offsetX, orbitGrannyHeight, offsetZ)
            char.HumanoidRootPart.CFrame = CFrame.new(targetPos)
         end
      end
   end

   if orbitGrandpaEnabled then
      local char = player.Character
      if char and char:FindFirstChild("HumanoidRootPart") then
         local grandpa = findGrandpaModel()
         if grandpa and grandpa:FindFirstChild("HumanoidRootPart") then
            orbitGrandpaAngle = orbitGrandpaAngle + (orbitGrandpaSpeed * delta)
            local offsetX = math.cos(orbitGrandpaAngle) * orbitGrandpaRadius
            local offsetZ = math.sin(orbitGrandpaAngle) * orbitGrandpaRadius
            local targetPos = grandpa.HumanoidRootPart.Position + Vector3.new(offsetX, orbitGrandpaHeight, offsetZ)
            char.HumanoidRootPart.CFrame = CFrame.new(targetPos)
         end
      end
   end

   if rangeCircleEnabled then
      local char = player.Character
      if char and char:FindFirstChild("HumanoidRootPart") then
         local root = char.HumanoidRootPart
         local legY = root.Position.Y - 3
         if not rangeCircle then
            rangeCircle = Instance.new("Part")
            rangeCircle.Name = "RangeCircle"
            rangeCircle.Anchored = true
            rangeCircle.CanCollide = false
            rangeCircle.Massless = true
            rangeCircle.Size = Vector3.new(0.2, 0.2, 0.2)
            rangeCircle.Shape = Enum.PartType.Cylinder
            rangeCircle.Material = Enum.Material.Neon
            rangeCircle.BrickColor = BrickColor.new(rangeCircleColor)
            rangeCircle.Parent = workspace
         end
         rangeCircle.Position = Vector3.new(root.Position.X, legY, root.Position.Z)
         local rot = tick() * 180
         rangeCircle.Orientation = Vector3.new(0, rot % 360, 90)
         rangeCircle.Size = Vector3.new(pickUpAuraRange * 0.2, pickUpAuraRange * 2, pickUpAuraRange * 2)
      end
   else
      if rangeCircle then
         rangeCircle:Destroy()
         rangeCircle = nil
      end
   end
end)

game:GetService("RunService").RenderStepped:Connect(function(delta)
   local cam = workspace.CurrentCamera
   local hue = tick() % 5 / 5
   local rainbowColor = Color3.fromHSV(hue, 1, 1)

   if viewAngleGrannyEnabled then
      local granny = findGrannyModel()
      if granny and granny:FindFirstChild("Head") then
         cam.CFrame = CFrame.new(cam.CFrame.Position, granny.Head.Position)
      end
   end

   if viewAngleGrandpaEnabled then
      local grandpa = findGrandpaModel()
      if grandpa and grandpa:FindFirstChild("Head") then
         cam.CFrame = CFrame.new(cam.CFrame.Position, grandpa.Head.Position)
      end
   end

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

   if rainbowPlayersESP then
      for _, h in pairs(playersESPObjects) do
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

   if playersTracersEnabled then
      for _, t in pairs(playersTracers) do
         if t.target and t.target.Parent then
            local screenPos, onScreen = cam:WorldToViewportPoint(t.target.Position)
            if onScreen then
               t.tracer.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
               t.tracer.To = Vector2.new(screenPos.X, screenPos.Y)
               t.tracer.Visible = true
            else
               t.tracer.Visible = false
            end
            if rainbowPlayersTracers then
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

   if rangeCircleRainbow and rangeCircle then
      rangeCircle.BrickColor = BrickColor.new(rainbowColor)
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
   if playersESPEnabled then applyPlayersESP() end
   if playersTracersEnabled then applyPlayersTracers() end
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
   if antiFallV2Enabled then
      local hum = newChar:WaitForChild("Humanoid")
      if antiFallV2Connection then antiFallV2Connection:Disconnect() end
      antiFallV2Connection = hum.StateChanged:Connect(function(oldState, newState)
         if not antiFallV2Enabled then return end
         if newState == Enum.HumanoidStateType.Freefall then
            local currentChar = player.Character
            if not currentChar then return end
            local rootPart = currentChar:FindFirstChild("HumanoidRootPart")
            if not rootPart then return end
            local rayParams = RaycastParams.new()
            rayParams.FilterType = Enum.RaycastFilterType.Blacklist
            rayParams.FilterDescendantsInstances = {currentChar}
            local rayResult = workspace:Raycast(rootPart.Position, Vector3.new(0, -5, 0), rayParams)
            if rayResult then
               local chance = math.random(1, 100)
               if chance <= antiFallV2Chance then
                  rootPart.Velocity = Vector3.new(0, 1, 0)
               end
            end
         end
      end)
   end
   if rangeCircle then
      rangeCircle:Destroy()
      rangeCircle = nil
   end
end)

Players.PlayerAdded:Connect(function(plr)
   plr.CharacterAdded:Connect(function(char)
      task.wait(0.5)
      if playersESPEnabled then applyPlayersESP() end
      if playersTracersEnabled then applyPlayersTracers() end
      playerDropdown:Refresh(getPlayerList())
   end)
end)

Players.PlayerRemoving:Connect(function(plr)
   task.wait(0.5)
   if playersESPEnabled then applyPlayersESP() end
   if playersTracersEnabled then applyPlayersTracers() end
   playerDropdown:Refresh(getPlayerList())
end)

workspace.FallenPartsDestroyHeight = 0/0

game:GetService("RunService").Heartbeat:Connect(function()
    local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum and hum.Health <= 0 then
        hum.Health = hum.MaxHealth
    end
end)
