local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "Revon Gui", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Section = PlayerTab:AddSection({
    Name = "Movement"
})

-- Walkspeed Slider
PlayerTab:AddSlider({
    Name = "Walkspeed",
    Min = 16,
    Max = 120,
    Default = 16,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

-- Jump Height Slider
PlayerTab:AddSlider({
    Name = "Jump Height",
    Min = 16,
    Max = 120,
    Default = 16,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Height",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end
})

local PlayerTab = Window:MakeTab({
    Name = "Visual",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Wall Visibility Toggle
PlayerTab:AddToggle({
    Name = "Wall",
    Default = false,
    Callback = function(Value)
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                -- Highlight effect
                if Value then
                    if not player.Character:FindFirstChild("Highlight") then
                        local highlight = Instance.new("Highlight")
                        highlight.Parent = player.Character
                        highlight.FillColor = Color3.fromRGB(0, 0, 255) -- Blue color
                        highlight.FillTransparency = 0.5 -- Semi-transparent
                        highlight.OutlineTransparency = 1 -- No outline
                    end
                else
                    local highlight = player.Character:FindFirstChild("Highlight")
                    if highlight then
                        highlight:Destroy()
                    end
                end
            end
        end
    end
})

local PlayerTab = Window:MakeTab({
    Name = "Aim",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Aimbot Toggle
PlayerTab:AddToggle({
    Name = "Aimbot",
    Default = false,
    Callback = function(Value)
        local aimbotEnabled = Value
        local UserInputService = game:GetService("UserInputService")
        local camera = workspace.CurrentCamera
        local localPlayer = game.Players.LocalPlayer

        local targetPlayer = nil

        local function getClosestPlayer()
            local closestPlayer = nil
            local shortestDistance = math.huge

            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local targetPos = player.Character.HumanoidRootPart.Position
                    local screenPos, onScreen = camera:WorldToScreenPoint(targetPos)
                    if onScreen then
                        local mousePos = UserInputService:GetMouseLocation()
                        local distance = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude

                        if distance < shortestDistance then
                            shortestDistance = distance
                            closestPlayer = player
                        end
                    end
                end
            end

            return closestPlayer
        end

        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if aimbotEnabled and input.UserInputType == Enum.UserInputType.MouseButton1 then -- Sol tık başladı
                targetPlayer = getClosestPlayer()
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then -- Sol tık bırakıldı
                targetPlayer = nil
            end
        end)

        game:GetService("RunService").RenderStepped:Connect(function()
            if aimbotEnabled and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                camera.CFrame = CFrame.new(camera.CFrame.Position, targetPlayer.Character.HumanoidRootPart.Position)
            end
        end)
    end
})
