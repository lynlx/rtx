--[[ 
    GANDAX Auto Event System
    Event: Every 2 hours (even hours) GMT+8
    Duration: 29 menit 55 detik (selesai 5 detik sebelum jam)
    Fixed Event Point
    Features: Draggable UI, Minimize with GX logo
--]]

local GANDAX_VERSION = "v1.2.0"
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- ================= CONFIG =================
local EVENT_CFRAME =
    CFrame.new(721, -475, 8865) *
    CFrame.Angles(0, math.rad(212), 0)

-- Ubah durasi menjadi 29 menit 55 detik
local EVENT_DURATION = (29 * 60) + 55 -- 29 menit 55 detik
local GMT_OFFSET = 8
-- ==========================================

-- ================= STATE ==================
local AutoEventEnabled = false
local EventActive = false
local LastTriggeredHour = nil
local LastPosition = nil
local EventEndTime = nil
local UIMinimized = false
local Dragging = false
local DragStart = nil
local StartPosition = nil
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
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

-- Title Bar
local TitleBar = Instance.new("Frame", Frame)
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

-- Make only title bar draggable for main UI
TitleBar.Active = true

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

-- GX Logo (Minimized State)
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
Instance.new("UICorner", GXLogo).CornerRadius = UDim.new(0, 10)

-- GX Logo Decoration
local GXDecoration1 = Instance.new("Frame", GXLogo)
GXDecoration1.Size = UDim2.new(0, 4, 0.6, 0)
GXDecoration1.Position = UDim2.new(0.3, 0, 0.2, 0)
GXDecoration1.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
GXDecoration1.BorderSizePixel = 0
Instance.new("UICorner", GXDecoration1)

local GXDecoration2 = Instance.new("Frame", GXLogo)
GXDecoration2.Size = UDim2.new(0, 4, 0.6, 0)
GXDecoration2.Position = UDim2.new(0.7, 0, 0.2, 0)
GXDecoration2.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
GXDecoration2.BorderSizePixel = 0
Instance.new("UICorner", GXDecoration2)

-- Main Content
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
Status.Text = "GANDAX " .. GANDAX_VERSION .. "\nDuration: 29:55\nStatus: Idle\nNext Event: --:--:--"
-- ==========================================

-- ================= DRAG FUNCTIONS ==============
local function makeDraggable(frame, dragPart)
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, 
                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    dragPart.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragPart.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Apply draggable functionality
makeDraggable(Frame, TitleBar)
makeDraggable(GXLogo, GXLogo)
-- ==========================================

-- ================= FUNCTIONS ==============
local function getHRP()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getGMT8()
    local utc = DateTime.now():ToUniversalTime()
    local hour = utc.Hour + GMT_OFFSET
    if hour >= 24 then
        hour -= 24
    end
    return hour, utc.Minute, utc.Second, utc.UnixTimestamp
end

local function getNextEventCountdown()
    local hour, min, sec = getGMT8()
    local nextHour = hour
    repeat
        nextHour = (nextHour + 1) % 24
    until nextHour % 2 == 0

    local deltaHours = (nextHour - hour) % 24
    local totalSeconds = deltaHours * 3600 - min * 60 - sec
    if totalSeconds < 0 then
        totalSeconds += 24 * 3600
    end

    local h = math.floor(totalSeconds / 3600)
    local m = math.floor((totalSeconds % 3600) / 60)
    local s = totalSeconds % 60
    return string.format("%02d:%02d:%02d", h, m, s)
end

local function startEvent()
    local hrp = getHRP()
    if not hrp then
        return
    end

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
        -- Save current position
        local framePos = Frame.Position
        GXLogo.Position = framePos
        GXLogo.Visible = true
        Frame.Visible = false
        MinimizeButton.Text = "+"
    else
        Frame.Visible = true
        GXLogo.Visible = false
        MinimizeButton.Text = "-"
    end
end

local function updateStatus()
    local hour, min, sec = getGMT8()
    
    if AutoEventEnabled then
        if not EventActive and hour % 2 == 0 and LastTriggeredHour ~= hour and min == 0 and sec == 0 then
            LastTriggeredHour = hour
            startEvent()
        end
    end

    if EventActive then
        local remain = EventEndTime - os.time()
        if remain <= 0 then
            endEvent()
        else
            local m = math.floor(remain / 60)
            local s = math.floor(remain % 60)
            Status.Text = "Status: EVENT ACTIVE\nEnds in: " .. string.format("%02d:%02d", m, s)
        end
    else
        Status.Text = "GANDAX " .. GANDAX_VERSION .. "\nDuration: 29:55\nStatus: " .. (AutoEventEnabled and "Active" or "Idle") .. "\nNext Event: " .. getNextEventCountdown()
    end
end
-- ==========================================

-- ================= EVENTS =================
Toggle.MouseButton1Click:Connect(function()
    AutoEventEnabled = not AutoEventEnabled
    if AutoEventEnabled then
        Toggle.Text = "AUTO EVENT : ON"
        Toggle.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
    else
        Toggle.Text = "AUTO EVENT : OFF"
        Toggle.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
        if EventActive then
            endEvent()
        end
    end
    updateStatus()
end)

MinimizeButton.MouseButton1Click:Connect(toggleMinimize)

-- Double click GX logo to restore
local lastClickTime = 0
GXLogo.MouseButton1Click:Connect(function()
    local currentTime = tick()
    if currentTime - lastClickTime < 0.3 then -- Double click detection
        if UIMinimized then
            toggleMinimize()
        end
    end
    lastClickTime = currentTime
end)

-- Make GX logo change color on hover
GXLogo.MouseEnter:Connect(function()
    GXLogo.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)

GXLogo.MouseLeave:Connect(function()
    GXLogo.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

-- Make minimize button change color on hover
MinimizeButton.MouseEnter:Connect(function()
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
end)

MinimizeButton.MouseLeave:Connect(function()
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
end)
-- ==========================================

-- ================= MAIN LOOP ===============
RunService.Heartbeat:Connect(function()
    updateStatus()
    
    -- Update GX logo text based on status
    if EventActive then
        local remain = EventEndTime - os.time()
        if remain > 0 then
            local m = math.floor(remain / 60)
            local s = math.floor(remain % 60)
            GXLogo.Text = string.format("%d:%02d", m, s)
        else
            GXLogo.Text = "GX"
        end
    else
        GXLogo.Text = "GX"
    end
end)
-- ==========================================

-- Initial update
updateStatus()
