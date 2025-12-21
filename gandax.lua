--// ===============================
--// GANDAX AUTO EVENT v1.0.1
--// Author : GANDAX
--// ===============================

--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

--// CONFIG
local VERSION = "v1.0.1"

-- EVENT POSITION (FIX)
local EVENT_CFRAME = CFrame.new(721, -488, 8865) * CFrame.Angles(0, math.rad(212), 0)

-- EVENT SETTINGS
local EVENT_INTERVAL = 2 * 3600 -- 2 jam
local EVENT_DURATION = 30 * 60  -- 30 menit
local GMT_OFFSET = 8 * 3600     -- GMT+8

--// STATE
local autoEventEnabled = false
local eventActive = false
local lastEventId = nil
local savedCFrame = nil

--// CHARACTER
local function getChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

--// TIME UTILS
local function getUnixTime()
    return os.time(os.date("!*t")) + GMT_OFFSET
end

local function isEventHour()
    local t = os.date("!*t", getUnixTime())
    return t.hour % 2 == 0 and t.min == 0
end

local function getNextEventTimestamp()
    local now = getUnixTime()
    return now + (EVENT_INTERVAL - (now % EVENT_INTERVAL))
end

--// UI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "GANDAX_UI"

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(330, 420)
main.Position = UDim2.fromScale(0.05, 0.2)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 0
main.Active = true

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 10)

-- HEADER
local header = Instance.new("Frame", main)
header.Size = UDim2.fromOffset(330, 40)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
header.BorderSizePixel = 0

local title = Instance.new("TextLabel", header)
title.Size = UDim2.fromScale(1, 1)
title.Text = "GANDAX Auto Event "..VERSION
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 14

-- MINIMIZE
local minimized = false
local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Size = UDim2.fromOffset(30, 30)
minimizeBtn.Position = UDim2.fromOffset(290, 5)
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)

-- CONTENT
local content = Instance.new("Frame", main)
content.Position = UDim2.fromOffset(0, 40)
content.Size = UDim2.fromOffset(330, 380)
content.BackgroundTransparency = 1

-- DRAG
do
    local dragging, dragStart, startPos
    header.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = i.Position
            startPos = main.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                      startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    minimizeBtn.Text = minimized and "+" or "-"
    main.Size = minimized and UDim2.fromOffset(330, 40) or UDim2.fromOffset(330, 420)
end)

-- LABEL FACTORY
local function makeLabel(text, y)
    local l = Instance.new("TextLabel", content)
    l.Size = UDim2.fromOffset(310, 25)
    l.Position = UDim2.fromOffset(10, y)
    l.TextXAlignment = Left
    l.Text = text
    l.TextColor3 = Color3.new(1,1,1)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.Gotham
    l.TextSize = 12
    return l
end

-- BUTTON FACTORY
local function makeButton(text, y)
    local b = Instance.new("TextButton", content)
    b.Size = UDim2.fromOffset(310, 30)
    b.Position = UDim2.fromOffset(10, y)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    return b
end

-- UI ELEMENTS
local posLabel = makeLabel("Position: -", 10)
local dirLabel = makeLabel("Yaw: -", 40)
local timerLabel = makeLabel("Next Event: --:--:--", 70)

local toggleBtn = makeButton("🟢 Auto Event : OFF", 110)

-- POSITION UPDATE
RunService.RenderStepped:Connect(function()
    local hrp = getChar():FindFirstChild("HumanoidRootPart")
    if hrp then
        local pos = hrp.Position
        posLabel.Text = string.format("Position: X %.1f | Y %.1f | Z %.1f", pos.X, pos.Y, pos.Z)
        local _, yaw, _ = hrp.CFrame:ToEulerAnglesYXZ()
        dirLabel.Text = string.format("Yaw: %d°", math.deg(yaw))
    end

    local now = getUnixTime()
    if not eventActive then
        local nextEv = getNextEventTimestamp()
        local diff = nextEv - now
        timerLabel.Text = string.format(
            "Next Event: %02d:%02d:%02d",
            diff//3600, (diff%3600)//60, diff%60
        )
    else
        timerLabel.Text = "Event Active"
    end
end)

-- TOGGLE
toggleBtn.MouseButton1Click:Connect(function()
    autoEventEnabled = not autoEventEnabled
    toggleBtn.Text = autoEventEnabled and "🔴 Auto Event : ON" or "🟢 Auto Event : OFF"
end)

-- EVENT LOOP
task.spawn(function()
    while true do
        task.wait(1)
        if autoEventEnabled and not eventActive and isEventHour() then
            local id = os.date("%Y%m%d%H", getUnixTime())
            if id ~= lastEventId then
                lastEventId = id
                eventActive = true

                local hrp = getChar():WaitForChild("HumanoidRootPart")
                savedCFrame = hrp.CFrame
                hrp.CFrame = EVENT_CFRAME

                task.delay(EVENT_DURATION, function()
                    if hrp and savedCFrame then
                        hrp.CFrame = savedCFrame
                    end
                    eventActive = false
                end)
            end
        end
    end
end)
