--[[ 
    GANDAX Auto Event System
    Event: Every 2 hours (even hours) GMT+8
    Duration: 29 menit 55 detik
    UI Drag Fixed (Title + Body menyatu)
--]]

local GANDAX_VERSION = "v1.2.1"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ================= CONFIG =================
local EVENT_CFRAME =
    CFrame.new(721, -475, 8865) *
    CFrame.Angles(0, math.rad(212), 0)

local EVENT_DURATION = (29 * 60) + 55
local GMT_OFFSET = 8
-- ==========================================

-- ================= STATE ==================
local AutoEventEnabled = false
local EventActive = false
local LastTriggeredHour = nil
local LastPosition = nil
local EventEndTime = nil
local UIMinimized = false
-- ==========================================

-- ================= UI =====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GANDAX"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- Main Frame
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 280, 0, 180)
Frame.Position = UDim2.new(0, 20, 0.5, -90)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = false
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

-- Title Bar
local TitleBar = Instance.new("Frame", Frame)
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Active = true
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "GANDAX AUTO EVENT " .. GANDAX_VERSION
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0, 10, 0, 0)

-- Minimize Button
local MinimizeButton = Instance.new("TextButton", TitleBar)
MinimizeButton.Size = UDim2.new(0, 30, 0, 20)
MinimizeButton.Position = UDim2.new(1, -40, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinimizeButton.Text = "-"
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 16
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", MinimizeButton)

-- GX Logo (Minimized)
local GXLogo = Instance.new("TextButton", ScreenGui)
GXLogo.Size = UDim2.new(0, 60, 0, 60)
GXLogo.Position = UDim2.new(0, 20, 0, 20)
GXLogo.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
GXLogo.Text = "GX"
GXLogo.Font = Enum.Font.GothamBold
GXLogo.TextSize = 20
GXLogo.TextColor3 = Color3.new(1, 1, 1)
GXLogo.Visible = false
GXLogo.Active = true
GXLogo.Draggable = true
Instance.new("UICorner", GXLogo).CornerRadius = UDim.new(0, 10)

-- Content
local Content = Instance.new("Frame", Frame)
Content.Size = UDim2.new(1, 0, 1, -30)
Content.Position = UDim2.new(0, 0, 0, 30)
Content.BackgroundTransparency = 1

local Toggle = Instance.new("TextButton", Content)
Toggle.Position = UDim2.new(0, 20, 0, 10)
Toggle.Size = UDim2.new(1, -40, 0, 30)
Toggle.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
Toggle.Text = "AUTO EVENT : OFF"
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 13
Toggle.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Toggle)

local Status = Instance.new("TextLabel", Content)
Status.Position = UDim2.new(0, 15, 0, 50)
Status.Size = UDim2.new(1, -30, 1, -60)
Status.BackgroundTransparency = 1
Status.TextWrapped = true
Status.TextYAlignment = Enum.TextYAlignment.Top
Status.Font = Enum.Font.Code
Status.TextSize = 12
Status.TextColor3 = Color3.fromRGB(200, 200, 200)
-- GX Logo Decoration (restore)
local GXDecoration1 = Instance.new("Frame", GXLogo)
GXDecoration1.Size = UDim2.new(0, 4, 0.6, 0)
GXDecoration1.Position = UDim2.new(0.32, 0, 0.2, 0)
GXDecoration1.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
GXDecoration1.BorderSizePixel = 0
Instance.new("UICorner", GXDecoration1)

local GXDecoration2 = Instance.new("Frame", GXLogo)
GXDecoration2.Size = UDim2.new(0, 4, 0.6, 0)
GXDecoration2.Position = UDim2.new(0.68, 0, 0.2, 0)
GXDecoration2.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
GXDecoration2.BorderSizePixel = 0
Instance.new("UICorner", GXDecoration2)

-- ==========================================

-- ================= DRAG FIX =================
local dragging = false
local dragStart
local startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
-- ==========================================

-- ================= FUNCTIONS ==============
local function getHRP()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getGMT8()
    local utc = DateTime.now():ToUniversalTime()
    local hour = (utc.Hour + GMT_OFFSET) % 24
    return hour, utc.Minute, utc.Second
end

local function getNextEventCountdown()
    local hour, min, sec = getGMT8()
    local nextHour = hour
    repeat
        nextHour = (nextHour + 1) % 24
    until nextHour % 2 == 0

    local delta = ((nextHour - hour) % 24) * 3600 - min * 60 - sec
    if delta < 0 then delta += 86400 end

    return string.format("%02d:%02d:%02d",
        math.floor(delta / 3600),
        math.floor(delta % 3600 / 60),
        delta % 60
    )
end

local function startEvent()
    local hrp = getHRP()
    if not hrp then return end
    LastPosition = hrp.CFrame
    hrp.CFrame = EVENT_CFRAME
    EventActive = true
    EventEndTime = os.time() + EVENT_DURATION
end

local function endEvent()
    local hrp = getHRP()
    if hrp and LastPosition then
        hrp.CFrame = LastPosition
    end
    EventActive = false
    EventEndTime = nil
end

local function toggleMinimize()
    UIMinimized = not UIMinimized
    if UIMinimized then
        GXLogo.Position = Frame.Position
        GXLogo.Visible = true
        Frame.Visible = false
    else
        Frame.Visible = true
        GXLogo.Visible = false
    end
end
-- ==========================================

-- ================= EVENTS =================
Toggle.MouseButton1Click:Connect(function()
    AutoEventEnabled = not AutoEventEnabled
    Toggle.Text = AutoEventEnabled and "AUTO EVENT : ON" or "AUTO EVENT : OFF"
    Toggle.BackgroundColor3 = AutoEventEnabled
        and Color3.fromRGB(40, 120, 40)
        or Color3.fromRGB(120, 40, 40)
end)

MinimizeButton.MouseButton1Click:Connect(toggleMinimize)
GXLogo.MouseButton1Click:Connect(toggleMinimize)
-- ==========================================

-- ================= LOOP ===================
RunService.Heartbeat:Connect(function()
    local hour, min, sec = getGMT8()

    if AutoEventEnabled and not EventActive
        and hour % 2 == 0
        and LastTriggeredHour ~= hour
        and min == 0 and sec == 0 then
        LastTriggeredHour = hour
        startEvent()
    end

    if EventActive then
        local remain = EventEndTime - os.time()
        if remain <= 0 then
            endEvent()
        else
            Status.Text = "Status: EVENT ACTIVE\nEnds in: "
                .. string.format("%02d:%02d", math.floor(remain/60), remain%60)
        end
    else
        Status.Text =
            "GANDAX "..GANDAX_VERSION..
            "\nDuration: 29:55"..
            "\nStatus: "..(AutoEventEnabled and "Active" or "Idle")..
            "\nNext Event: "..getNextEventCountdown()
    end
end)
-- ==========================================
