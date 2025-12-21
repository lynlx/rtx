--[[ 
    GANDAX Auto Event System
    Event: Every 2 hours (even hours) GMT+8
    Duration: 30 minutes
    Fixed Event Point
--]]

local GANDAX_VERSION = "v1.0.0"
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ================= CONFIG =================
local EVENT_CFRAME =
    CFrame.new(721, -488, 8865) *
    CFrame.Angles(0, math.rad(212), 0)

local EVENT_DURATION = 30 * 60 -- 30 minutes
local GMT_OFFSET = 8
-- ==========================================

-- ================= STATE ==================
local AutoEventEnabled = false
local EventActive = false
local LastTriggeredHour = nil
local LastPosition = nil
local EventEndTime = nil
-- ==========================================

-- ================= UI =====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GANDAX"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 260, 0, 160)
Frame.Position = UDim2.new(0, 20, 0.5, -80)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Frame.BorderSizePixel = 0

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundTransparency = 1
Title.Text = "GANDAX AUTO EVENT "..GANDAX_VERSION
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.new(1,1,1)

local Toggle = Instance.new("TextButton", Frame)
Toggle.Position = UDim2.new(0,20,0,40)
Toggle.Size = UDim2.new(1,-40,0,30)
Toggle.BackgroundColor3 = Color3.fromRGB(120,40,40)
Toggle.Text = "AUTO EVENT : OFF"
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 13
Toggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Toggle)

local Status = Instance.new("TextLabel", Frame)
Status.Position = UDim2.new(0,15,0,80)
Status.Size = UDim2.new(1,-30,0,60)
Status.BackgroundTransparency = 1
Status.TextWrapped = true
Status.TextYAlignment = Enum.TextYAlignment.Top
Status.Font = Enum.Font.Code
Status.TextSize = 12
Status.TextColor3 = Color3.fromRGB(200,200,200)
Status.Text = "GANDAX "..GANDAX_VERSION.."\nStatus: Idle\nNext Event: --:--:--"
-- ==========================================

-- ================= FUNCTIONS ==============
local function getHRP()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getGMT8()
    local utc = DateTime.now():ToUniversalTime()
    local hour = utc.Hour + GMT_OFFSET
    if hour >= 24 then hour -= 24 end
    return hour, utc.Minute, utc.Second, utc.UnixTimestamp
end

local function getNextEventCountdown()
    local hour, min, sec = getGMT8()
    local nextHour = hour
    repeat
        nextHour = (nextHour + 1) % 24
    until nextHour % 2 == 0

    local deltaHours = (nextHour - hour) % 24
    local totalSeconds = deltaHours*3600 - min*60 - sec
    if totalSeconds < 0 then totalSeconds += 24*3600 end

    local h = math.floor(totalSeconds/3600)
    local m = math.floor((totalSeconds%3600)/60)
    local s = totalSeconds%60
    return string.format("%02d:%02d:%02d", h,m,s)
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
-- ==========================================

-- ================= TOGGLE =================
Toggle.MouseButton1Click:Connect(function()
    AutoEventEnabled = not AutoEventEnabled
    if AutoEventEnabled then
        Toggle.Text = "AUTO EVENT : ON"
        Toggle.BackgroundColor3 = Color3.fromRGB(40,120,40)
    else
        Toggle.Text = "AUTO EVENT : OFF"
        Toggle.BackgroundColor3 = Color3.fromRGB(120,40,40)
        if EventActive then
            endEvent()
        end
    end
end)
-- ==========================================

-- ================= MAIN LOOP ===============
RunService.Heartbeat:Connect(function()
    local hour, min, sec, unix = getGMT8()

    if AutoEventEnabled then
        if not EventActive and hour % 2 == 0 and LastTriggeredHour ~= hour and min == 0 then
            LastTriggeredHour = hour
            startEvent()
        end
    end

    if EventActive then
        local remain = EventEndTime - os.time()
        if remain <= 0 then
            endEvent()
        else
            local m = math.floor(remain/60)
            local s = remain%60
            Status.Text = "Status: EVENT ACTIVE\nEnds in: "..string.format("%02d:%02d", m, s)
        end
    else
        Status.Text = "Status: Idle\nNext Event: "..getNextEventCountdown()
    end
end)
-- ==========================================
