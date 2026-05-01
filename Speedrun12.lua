local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TpButtonGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 120, 0, 30)
Button.Position = UDim2.new(0.5, -60, 0.5, -15)
Button.Text = "Teleport"
Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.GothamBold
Button.TextSize = 14
Button.Parent = ScreenGui

local dragging = false
local dragStart = nil
local startPos = nil

Button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        dragging = true
        dragStart = input.Position
        startPos = Button.Position
    end
end)

Button.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        dragging = false
    end
end)

Button.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            TweenService:Create(hrp, TweenInfo.new(10), {CFrame = CFrame.new(-7703.5751953125, 194.17575073242188, 1833.22900390625)}):Play()
        end
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
