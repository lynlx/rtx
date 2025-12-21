--=====================================
-- GANDAX EVENT SYSTEM
-- STEP 2 - Toggle + Countdown
--=====================================

local RunService = game:GetService("RunService")

-- CONFIG
local VERSION = "v1.0.1-step2"
local EVENT_INTERVAL = 2 * 3600
local EVENT_DURATION = 30 * 60
local GMT_OFFSET = 8 * 3600

-- STATE
local autoEvent = false

-- TIME
local function getTimeGMT8()
    return os.time(os.date("!*t")) + GMT_OFFSET
end

-- UI
local gui = Instance.new("ScreenGui")
gui.Name = "GANDAX_STEP2"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.fromOffset(320, 200)
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
statusLabel.Position = UDim2.fromOffset(10, 65)
statusLabel.Size = UDim2.fromOffset(300, 25)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.TextColor3 = Color3.new(1,1,1)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.BackgroundTransparency = 1

-- TIMER
local timerLabel = Instance.new("TextLabel", frame)
timerLabel.Position = UDim2.fromOffset(10, 95)
timerLabel.Size = UDim2.fromOffset(300, 35)
timerLabel.TextXAlignment = Enum.TextXAlignment.Left
timerLabel.TextColor3 = Color3.fromRGB(0,255,150)
timerLabel.Font = Enum.Font.GothamBold
timerLabel.TextSize = 16
timerLabel.BackgroundTransparency = 1

-- TOGGLE BUTTON
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Position = UDim2.fromOffset(10, 140)
toggleBtn.Size = UDim2.fromOffset(300, 35)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Text = "Auto Event : OFF"

Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)

toggleBtn.MouseButton1Click:Connect(function()
    autoEvent = not autoEvent
    toggleBtn.Text = autoEvent and "Auto Event : ON" or "Auto Event : OFF"
end)

-- LOOP
RunService.Heartbeat:Connect(function()
    local now = getTimeGMT8()
    local progress = now % EVENT_INTERVAL

    if not autoEvent then
        statusLabel.Text = "Status: Auto Event OFF"
        timerLabel.Text = "--"
        return
    end

    if progress < EVENT_DURATION then
        local left = EVENT_DURATION - progress
        statusLabel.Text = "Status: EVENT ACTIVE"
        timerLabel.Text = string.format(
            "Ends In: %02d:%02d:%02d",
            left//3600, (left%3600)//60, left%60
        )
    else
        local nextEvent = EVENT_INTERVAL - progress
        statusLabel.Text = "Status: Waiting Event"
        timerLabel.Text = string.format(
            "Next Event In: %02d:%02d:%02d",
            nextEvent//3600, (nextEvent%3600)//60, nextEvent%60
        )
    end
end)
