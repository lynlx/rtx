--=====================================
-- GANDAX EVENT SYSTEM
-- STEP 2.2 - Icon Minimize + Hotkey
--=====================================

local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- CONFIG
local VERSION = "v1.0.1-step2.2"
local EVENT_INTERVAL = 2 * 3600
local EVENT_DURATION = 30 * 60
local GMT_OFFSET = 8 * 3600

-- STATE
local autoEvent = false
local minimized = false

-- TIME
local function getTimeGMT8()
    return os.time(os.date("!*t")) + GMT_OFFSET
end

-- UI ROOT
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "GANDAX_STEP2_2"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(320, 220)
frame.Position = UDim2.fromScale(0.05, 0.25)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- HEADER
local header = Instance.new("Frame", frame)
header.Size = UDim2.fromOffset(320, 40)
header.BackgroundColor3 = Color3.fromRGB(35,35,35)
header.BorderSizePixel = 0

local title = Instance.new("TextLabel", header)
title.Size = UDim2.fromScale(1,1)
title.Text = "GANDAX EVENT SYSTEM"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.BackgroundTransparency = 1

local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Size = UDim2.fromOffset(30, 30)
minimizeBtn.Position = UDim2.fromOffset(285, 5)
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
minimizeBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)

-- CONTENT
local content = Instance.new("Frame", frame)
content.Position = UDim2.fromOffset(0, 40)
content.Size = UDim2.fromOffset(320, 180)
content.BackgroundTransparency = 1

-- VERSION
local versionLabel = Instance.new("TextLabel", content)
versionLabel.Position = UDim2.fromOffset(0, 0)
versionLabel.Size = UDim2.fromOffset(320, 20)
versionLabel.Text = VERSION
versionLabel.TextColor3 = Color3.fromRGB(180,180,180)
versionLabel.Font = Enum.Font.Gotham
versionLabel.TextSize = 11
versionLabel.BackgroundTransparency = 1

-- STATUS
local statusLabel = Instance.new("TextLabel", content)
statusLabel.Position = UDim2.fromOffset(10, 25)
statusLabel.Size = UDim2.fromOffset(300, 25)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.TextColor3 = Color3.new(1,1,1)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.BackgroundTransparency = 1

-- TIMER
local timerLabel = Instance.new("TextLabel", content)
timerLabel.Position = UDim2.fromOffset(10, 55)
timerLabel.Size = UDim2.fromOffset(300, 35)
timerLabel.TextXAlignment = Enum.TextXAlignment.Left
timerLabel.TextColor3 = Color3.fromRGB(0,255,150)
timerLabel.Font = Enum.Font.GothamBold
timerLabel.TextSize = 16
timerLabel.BackgroundTransparency = 1

-- TOGGLE
local toggleBtn = Instance.new("TextButton", content)
toggleBtn.Position = UDim2.fromOffset(10, 100)
toggleBtn.Size = UDim2.fromOffset(300, 35)
toggleBtn.Text = "Auto Event : OFF"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)

toggleBtn.MouseButton1Click:Connect(function()
    autoEvent = not autoEvent
    toggleBtn.Text = autoEvent and "Auto Event : ON" or "Auto Event : OFF"
end)

-- DRAG
do
    local dragging, dragStart, startPos
    header.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = i.Position
            startPos = frame.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- MINIMIZE / RESTORE
local function setMinimized(state)
    minimized = state
    if minimized then
        content.Visible = false
        header.Size = UDim2.fromOffset(50, 50)
        frame.Size = UDim2.fromOffset(50, 50)
        title.Text = "G"
        title.TextSize = 20
        minimizeBtn.Visible = false
    else
        content.Visible = true
        header.Size = UDim2.fromOffset(320, 40)
        frame.Size = UDim2.fromOffset(320, 220)
        title.Text = "GANDAX EVENT SYSTEM"
        title.TextSize = 14
        minimizeBtn.Visible = true
    end
end

minimizeBtn.MouseButton1Click:Connect(function()
    setMinimized(true)
end)

header.InputBegan:Connect(function(i)
    if minimized and i.UserInputType == Enum.UserInputType.MouseButton1 then
        setMinimized(false)
    end
end)

-- HOTKEY NUMPAD 9
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.KeypadNine then
        setMinimized(not minimized)
    end
end)

-- LOOP
RunService.Heartbeat:Connect(function()
    if not autoEvent then
        statusLabel.Text = "Status: Auto Event OFF"
        timerLabel.Text = "--"
        return
    end

    local now = getTimeGMT8()
    local progress = now % EVENT_INTERVAL

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
