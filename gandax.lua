--=====================================
-- GANDAX EVENT SYSTEM - STEP 1
-- Countdown Timer Only
-- Version : v1.0.0-step1
--=====================================

-- SERVICES
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- CONFIG
local VERSION = "v1.0.0-step1"
local EVENT_INTERVAL = 2 * 3600      -- 2 jam
local EVENT_DURATION = 30 * 60       -- 30 menit
local GMT_OFFSET = 8 * 3600          -- GMT+8

-- TIME UTILS
local function getGMT8Time()
    return os.time(os.date("!*t")) + GMT_OFFSET
end

local function getNextEventTime(now)
    return now + (EVENT_INTERVAL - (now % EVENT_INTERVAL))
end

local function isEventActive(now)
    return (now % EVENT_INTERVAL) < EVENT_DURATION
end

-- UI
local gui = Instance.new("ScreenGui")
gui.Name = "GANDAX_STEP1"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(320, 160)
frame.Position = UDim2.fromScale(0.05, 0.25)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromOffset(320, 40)
title.Text = "GANDAX EVENT SYSTEM"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.BackgroundColor3 = Color3.fromRGB(35,35,35)
title.BorderSizePixel = 0

-- VERSION
local versionLabel = Instance.new("TextLabel", frame)
versionLabel.Position = UDim2.fromOffset(0, 40)
versionLabel.Size = UDim2.fromOffset(320, 20)
versionLabel.Text = VERSION
versionLabel.TextColor3 = Color3.fromRGB(180,180,180)
versionLabel.Font = Enum.Font.Gotham
versionLabel.TextSize = 11
versionLabel.BackgroundTransparency = 1

-- STATUS
local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Position = UDim2.fromOffset(10, 70)
statusLabel.Size = UDim2.fromOffset(300, 25)
statusLabel.Text = "Status: Checking..."
statusLabel.TextXAlignment = Left
statusLabel.TextColor3 = Color3.new(1,1,1)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.BackgroundTransparency = 1

-- TIMER
local timerLabel = Instance.new("TextLabel", frame)
timerLabel.Position = UDim2.fromOffset(10, 100)
timerLabel.Size = UDim2.fromOffset(300, 40)
timerLabel.Text = "--:--:--"
timerLabel.TextXAlignment = Left
timerLabel.TextColor3 = Color3.fromRGB(0,255,150)
timerLabel.Font = Enum.Font.GothamBold
timerLabel.TextSize = 16
timerLabel.BackgroundTransparency = 1

-- UPDATE LOOP
RunService.RenderStepped:Connect(function()
    local now = getGMT8Time()

    if isEventActive(now) then
        local left = EVENT_DURATION - (now % EVENT_INTERVAL)
        statusLabel.Text = "Status: EVENT ACTIVE"
        timerLabel.Text = string.format(
            "Ends In: %02d:%02d:%02d",
            left//3600, (left%3600)//60, left%60
        )
    else
        local nextEvent = getNextEventTime(now)
        local diff = nextEvent - now
        statusLabel.Text = "Status: Waiting Event"
        timerLabel.Text = string.format(
            "Next Event In: %02d:%02d:%02d",
            diff//3600, (diff%3600)//60, diff%60
        )
    end
end)
