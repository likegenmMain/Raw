local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Qanuir/orion-ui/refs/heads/main/source.lua"))()

local Window = OrionLib:MakeWindow({
    Name = "Likegenm Scripts",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "LikegenmHub",
    IntroEnabled = true,
    IntroText = "By Likegenm"
})

local TeleportTab = Window:MakeTab({
    Name = "Teleport",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local AutoStartTab = Window:MakeTab({
    Name = "AutoStart",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local ScriptsTab = Window:MakeTab({
    Name = "Scripts",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local locations = {
    ["The House"] = Vector3.new(6.75, 3.90, -11.10),
    ["The Mall"] = Vector3.new(4.16, 31.05, -10.80),
    ["The Mineshaft"] = Vector3.new(4.09, 62.55, -10.19),
    ["Mental Hospital"] = Vector3.new(2.38, 80.15, -11.90),
    ["Satan's Lodge"] = Vector3.new(5.03, 106.35, -11.90),
    ["Oak Deer INN"] = Vector3.new(-19.66, 132.90, -12.15),
    ["The Subway"] = Vector3.new(7.76, 164.80, -12.46),
    ["Dis Manibus"] = Vector3.new(11.72, 200.10, -11.05)
}

local function teleportTo(position)
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(position.X, position.Y, position.Z)
        end
    end
end

TeleportTab:AddParagraph("Locations", "")

for locationName, position in pairs(locations) do
    TeleportTab:AddButton({
        Name = locationName,
        Callback = function()
            teleportTo(position)
        end
    })
end

AutoStartTab:AddParagraph("Auto Start Settings", "")

local locationNames = {"The House", "The Mall", "The Mineshaft", "Mental Hospital", "Satan's Lodge", "Oak Deer INN", "The Subway", "Dis Manibus"}
local selectedLocation = "The House"

AutoStartTab:AddDropdown({
    Name = "Select Location",
    Default = "The House",
    Options = locationNames,
    Callback = function(v)
        selectedLocation = v
    end
})

local function executeAutoStart()
    if PlayerGui:FindFirstChild("Password") then
        local passwordFrame = PlayerGui.Password
        if passwordFrame:FindFirstChild("TextBox") then
            passwordFrame.TextBox.Text = "8469"
        end
        if passwordFrame:FindFirstChild("TextButton") then
            passwordFrame.TextButton.Text = "8469"
        end
    end
    if locations[selectedLocation] then
        teleportTo(locations[selectedLocation])
    end
end

AutoStartTab:AddToggle({
    Name = "Enable AutoStart",
    Default = false,
    Callback = function(v)
        if v then
            executeAutoStart()
        end
    end
})

OrionLib:Init()
