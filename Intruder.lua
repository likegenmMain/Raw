local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PG = LocalPlayer.PlayerGui:FindFirstChild("Rooms")
local LK = workspace:FindFirstChild("Lobby")
local sc = workspace:FindFirstChild("Cameras")

local lobby = LocalPlayer.PlayerGui:FindFirstChild("Room")

local home = PG and 
           PG:FindFirstChild("Basement") and 
           PG:FindFirstChild("BasementStairs") and 
           PG:FindFirstChild("Bathroom") and 
           PG:FindFirstChild("FrontDoor") and 
           PG:FindFirstChild("Hallway") and 
           PG:FindFirstChild("LivingRoom") and 
           PG:FindFirstChild("Outside") and 
           PG:FindFirstChild("Street") and 
           PG:FindFirstChild("Vent")

local Hallways = PG and 
                PG:FindFirstChild("Hallway1") and 
                PG:FindFirstChild("Hallway2") and 
                PG:FindFirstChild("Hallway3")

local mall = PG and 
            PG:FindFirstChild("Diner") and 
            PG:FindFirstChild("Escalator") and 
            PG:FindFirstChild("Hallway") and 
            PG:FindFirstChild("Hallway2") and 
            PG:FindFirstChild("Hallway3") and 
            PG:FindFirstChild("Janitor") and 
            PG:FindFirstChild("Outside") and 
            PG:FindFirstChild("SecondFloor") and 
            PG:FindFirstChild("ShoeStore")

local mine = workspace:FindFirstChild("Generators") ~= nil

local MH = Hallways and 
          PG:FindFirstChild("North") and 
          PG:FindFirstChild("Storage") and 
          PG:FindFirstChild("Study") and 
          PG:FindFirstChild("Vent")

local SL = sc and 
           sc:FindFirstChild("1") and 
           sc:FindFirstChild("2") and 
           sc:FindFirstChild("3") and 
           sc:FindFirstChild("4") and 
           sc:FindFirstChild("5") and not
           sc:FindFirstChild("6") and not
           sc:FindFirstChild("7") and not
           sc:FindFirstChild("8")

local OAK = LK and 
           LK:FindFirstChild("OldMan") and 
           LK:FindFirstChild("Woman") and 
           LK:FindFirstChild("Worker") and 
           LK:FindFirstChild("HackingTool")

local DM = PG and 
          PG:FindFirstChild("Basement") and 
          PG:FindFirstChild("FrontDoor") and 
          PG:FindFirstChild("Hallway") and 
          PG:FindFirstChild("LivingRoom") and 
          PG:FindFirstChild("Mall") and 
          PG:FindFirstChild("Outside") and 
          PG:FindFirstChild("Secret") and 
          PG:FindFirstChild("Well")

if lobby then 
           loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/Intruder(Lobby).lua"))() 
end

if home then 
           loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/1/refs/heads/main/TheIntruderHome.lua"))() 
end

if mall then 
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/1/refs/heads/main/TheIntruderMall.lua"))() 
end

if mine then
           loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/1/refs/heads/main/MineIntruder.lua"))()
end

if MH then
           loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/1/refs/heads/main/MHIntruder.lua"))()
end

if SL then
           loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/1/refs/heads/main/SLIntruder.lua"))()
end
