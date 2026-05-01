local workspace = game:GetService("Workspace")

local function findPreset()
    for i = 1, 10 do
        local preset = workspace:FindFirstChild("Preset" .. i)
        if preset then
            local locks = preset:FindFirstChild("Locks")
            if locks then
                if locks:FindFirstChild("SlendrinaMother") then
                    return 1
                elseif locks:FindFirstChild("Grandpa") then
                    return 2
                end
            end
            
            if preset:FindFirstChild("Slendrina") then
                return 3
            end
        end
    end
    return nil
end

local chapter = findPreset()

if chapter == 1 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/likegenmMain/Raw/refs/heads/main/G1.lua"))()
elseif chapter == 2 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/likegenmMain/Raw/refs/heads/main/G2.lua"))()
elseif chapter == 3 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/likegenmMain/Raw/refs/heads/main/G3.lua"))()
else
    print("Chapter not found")
end
