--// GANDAX EVENT SYSTEM v1.0.1
--// Stable Drag + Teleport + Yaw Lock

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- =====================
-- CONFIG
-- =====================
local EVENT_YAW = 212
local EVENT_POSITION = Vector3.new(0, 0, 0) -- GANTI DENGAN POSISI EVENT
local EVENT_DURATION = 30 * 60 -- 30 menit

-- =====================
-- STATE
-- =====================
local AutoEvent = false
local SavedCFrame = nil
local EventActive = false

-- =====================
-- UI
-- =====================
local gui = Instance.new("ScreenGui")
gui.Name = "GandaxUI"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

-- MAIN FRAME
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(300, 150)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.Active = true
main.Draggable = true
main.Parent = gui

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "GANDAX EVENT SYSTEM"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = main

-- STATUS
local status = Instance.new("TextLabel")
status.Position = UDim2.fromOffset(0, 40)
status.Size = UDim2.new(1, 0, 0, 25)
status.BackgroundTransparency = 1
status.Text = "Status: OFF"
status.TextColor3 = Color3.new(1, 1, 1)
status.Font = Enum.Font.Gotham
status.TextSize = 13
status.Parent = main

-- TOGGLE
local toggle = Instance.new("TextButton")
toggle.Position = UDim2.fromOffset(50, 80)
toggle.Size = UDim2.fromOffset(200, 35)
toggle.Text = "AUTO EVENT : OFF"
toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 13
toggle.Parent = main

-- MINIMIZE
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.fromOffset(30, 30)
minBtn.Position = UDim2.new(1, -35, 0, 0)
minBtn.Text = "-"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 16
minBtn.Parent = main

-- ICON (MINIMIZED)
local icon = Instance.new("TextButton")
icon.Size = UDim2.fromOffset(45, 45)
icon.Position = UDim2.fromScale(0.5, 0.5)
icon.AnchorPoint = Vector2.new(0.5, 0.5)
icon.Text = "G"
icon.Visible = false
icon.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
icon.TextColor3 = Color3.new(1, 1, 1)
icon.Font = Enum.Font.GothamBold
icon.TextSize = 20
icon.Active = true
icon.Draggable = true
icon.Parent = gui

-- =====================
-- FUNCTIONS
-- =====================
local function lockYaw(yaw)
    local pos = hrp.Position
    hrp.CFrame = CFrame.new(pos) * CFrame.Angles(0, math.rad(yaw), 0)
end

local function teleportToEvent()
    if EventActive then return end
    EventActive = true

    SavedCFrame = hrp.CFrame

    hrp.CFrame = CFrame.new(EVENT_POSITION)
    task.wait(0.1)
    lockYaw(EVENT_YAW)

    status.Text = "Status: EVENT RUNNING"

    task.delay(EVENT_DURATION, function()
        if SavedCFrame then
            hrp.CFrame = SavedCFrame
        end
        EventActive = false
        status.Text = "Status: WAITING EVENT"
    end)
end

-- =====================
-- BUTTON LOGIC
-- =====================
toggle.MouseButton1Click:Connect(function()
    AutoEvent = not AutoEvent
    toggle.Text = AutoEvent and "AUTO EVENT : ON" or "AUTO EVENT : OFF"
    status.Text = AutoEvent and "Status: WAITING EVENT" or "Status: OFF"

    if AutoEvent then
        teleportToEvent()
    end
end)

minBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    icon.Visible = true
end)

icon.MouseButton1Click:Connect(function()
    icon.Visible = false
    main.Visible = true
end)

print("GANDAX EVENT SYSTEM v1.0.1 LOADED")
