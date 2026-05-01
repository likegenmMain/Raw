local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "Likegenm",
    Footer = "v1.0(Blade Ball)",
    ToggleKeybind = Enum.KeyCode.RightControl,
    Center = true,
    AutoShow = true
})

local MainTab = Window:AddTab("Legit", "lock")
local AP = MainTab:AddLeftGroupbox("AutoParry")

AP:AddLabel("AutoParry: Chance, ON/OFF")

local chanceSlider = AP:AddSlider("Chance", {
    Text = "Parry Chance %",
    Default = 100,
    Min = 1,
    Max = 100,
    Rounding = 0
})

local autoParryToggle = AP:AddToggle("Enable", {
    Text = "Auto Parry",
    Default = false
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local enabled = false
local chance = 100

autoParryToggle:OnChanged(function(value)
    enabled = value
end)

chanceSlider:OnChanged(function(value)
    chance = value
end)

RunService.Heartbeat:Connect(function()
    if not enabled then return end
    if not player.Character then return end
    
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local ballsFolder = workspace:FindFirstChild("Balls") 
    if not ballsFolder then return end
    
    for _, ball in pairs(ballsFolder:GetChildren()) do
        if ball:IsA("BasePart") then
            local distance = (ball.Position - hrp.Position).Magnitude
            
            if distance <= 42 then
                local random = math.random(1, 100)
                
                if random <= chance then
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                    task.wait(1)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
                end
            end
        end
    end
end)

local BT = Window:AddTab("Blatant")

local SpeedGroup = BT:AddLeftGroupbox('Speed')

local speedActive = false
local speedConnection

SpeedGroup:AddSlider("Speedhack", {
    Text = "Speed",
    Default = 36,
    Min = 36,
    Max = 100,
    Rounding = 0,
    Callback = function(value)
        Options.Speedhack.Value = value
    end
})

SpeedGroup:AddToggle("SpeedToggle", {
    Text = "Enable Speed Hack",
    Default = false,
    Callback = function(value)
        Toggles.SpeedToggle.Value = value
    end
})

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

Toggles.SpeedToggle:OnChanged(function(value)
    speedActive = value
    
    if speedConnection then
        speedConnection:Disconnect()
        speedConnection = nil
    end
    
    if value then
        speedConnection = RunService.Heartbeat:Connect(function()
            if not speedActive or not player.Character then return end
            
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local cameraCFrame = Camera.CFrame
            local lookVector = cameraCFrame.LookVector
            local rightVector = cameraCFrame.RightVector
            
            local mv = Vector3.new(0, 0, 0)
            local speed = Options.Speedhack.Value

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
                hrp.Velocity = Vector3.new(
                    mv.X * speed,
                    hrp.Velocity.Y,
                    mv.Z * speed
                )
            end
        end)
    end
end)
