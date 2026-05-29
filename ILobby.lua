local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Qanuir/orion-ui/refs/heads/main/source.lua"))()

local Window = OrionLib:MakeWindow({
    Name = "The Intruder | Lobby",
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
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local locationMap = {
    ["Home"] = "House",
    ["Mall"] = "Mall",
    ["Mine"] = "Mine",
    ["Mental Hospital"] = "Ward",
    ["Satan Lodge"] = "Lodge",
    ["OAK DEER INN"] = "Hotel",
    ["Subway"] = "Subway",
    ["Dis Manibus"] = "Final"
}

local locationNames = {"Home", "Mall", "Mine", "Mental Hospital", "Satan Lodge", "OAK DEER INN", "Subway", "Dis Manibus"}
local selectedLocation = "Home"
local selectedPlayers = 2
local selectedRoom = ""
local roomDropdown = nil
local lastRoomList = {}

local function getRoomList()
    local rooms = {}
    local roomPath = Workspace:FindFirstChild("Rooms")
    if roomPath then
        local playersPath = roomPath:FindFirstChild(tostring(selectedPlayers) .. " Players")
        if playersPath then
            local roomPath2 = playersPath:FindFirstChild(locationMap[selectedLocation])
            if roomPath2 then
                for _, child in pairs(roomPath2:GetChildren()) do
                    if child:FindFirstChild("LookThroughTV") then
                        table.insert(rooms, child.Name)
                    end
                end
            end
        end
    end
    return rooms
end

local function enterRoom(roomName)
    local roomPath = Workspace:FindFirstChild("Rooms")
    if roomPath then
        local playersPath = roomPath:FindFirstChild(tostring(selectedPlayers) .. " Players")
        if playersPath then
            local roomPath2 = playersPath:FindFirstChild(locationMap[selectedLocation])
            if roomPath2 then
                local roomObj = roomPath2:FindFirstChild(roomName)
                if roomObj then
                    local enterObject = roomObj:FindFirstChild("LookThroughTV")
                    if enterObject and LocalPlayer.Character then
                        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            firetouchinterest(enterObject, hrp, 0)
                            firetouchinterest(enterObject, hrp, 1)
                        end
                    end
                end
            end
        end
    end
end

local function teleportTo(position)
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(position.X, position.Y, position.Z)
        end
    end
end

local function updateRoomDropdown()
    local rooms = getRoomList()
    if #rooms > 0 then
        if #rooms ~= #lastRoomList or rooms[1] ~= lastRoomList[1] then
            lastRoomList = rooms
            if roomDropdown then
                roomDropdown:Refresh(rooms)
            else
                roomDropdown = AutoStartTab:AddDropdown({
                    Name = "Select Room",
                    Default = rooms[1],
                    Options = rooms,
                    Callback = function(v)
                        selectedRoom = v
                    end
                })
            end
            if not table.find(rooms, selectedRoom) then
                selectedRoom = rooms[1]
            end
        end
    else
        if roomDropdown then
            roomDropdown:Refresh({"No rooms available"})
            selectedRoom = ""
        end
    end
end

TeleportTab:AddParagraph("Locations", "")

local locations = {
    ["Home"] = Vector3.new(6.75, 3.90, -11.10),
    ["Mall"] = Vector3.new(4.16, 31.05, -10.80),
    ["Mine"] = Vector3.new(4.09, 62.55, -10.19),
    ["Mental Hospital"] = Vector3.new(2.38, 80.15, -11.90),
    ["Satan Lodge"] = Vector3.new(5.03, 106.35, -11.90),
    ["OAK DEER INN"] = Vector3.new(-19.66, 132.90, -12.15),
    ["Subway"] = Vector3.new(7.76, 164.80, -12.46),
    ["Dis Manibus"] = Vector3.new(11.72, 200.10, -11.05)
}

for locationName, position in pairs(locations) do
    TeleportTab:AddButton({
        Name = locationName,
        Callback = function()
            teleportTo(position)
        end
    })
end

AutoStartTab:AddParagraph("Auto Start Settings", "")

AutoStartTab:AddDropdown({
    Name = "Select Location",
    Default = "Home",
    Options = locationNames,
    Callback = function(v)
        selectedLocation = v
        updateRoomDropdown()
    end
})

AutoStartTab:AddDropdown({
    Name = "Select Players",
    Default = "2",
    Options = {"2", "3", "4"},
    Callback = function(v)
        selectedPlayers = tonumber(v)
        updateRoomDropdown()
    end
})

updateRoomDropdown()

RunService.RenderStepped:Connect(function()
    updateRoomDropdown()
end)

local function executeAutoStart()
    if selectedRoom ~= "" then
        enterRoom(selectedRoom)
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
