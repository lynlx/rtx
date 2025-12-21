--==================================================
-- GANDAX EVENT SYSTEM
-- v1.0.1 - AUTO TELEPORT + FIXED YAW
--==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--==================== CONFIG ======================
local VERSION = "v1.0.1"

-- TIME
local EVENT_INTERVAL = 2 * 3600       -- 2 jam
local EVENT_DURATION = 30 * 60        -- 30 menit
local GMT_OFFSET = 8 * 3600           -- GMT+8

-- EVENT POINT (FIX)
local EVENT_POSITION = Vector3.new(721, -488, 8865)
local EVENT_YAW = math.rad(212)       -- WAJIB & TERKUNCI

--==================== STATE =======================
local autoEvent = false
local minimized = false
local inEvent = false
local savedCFrame = nil

--==================== TIME FUNC ===================
local function getTimeGMT8()
    return os.time(os.date("!*t")) + GMT_OFFSET
end

--==================== TELEPORT ====================
local function teleportToEvent()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame =
            CFrame.new(EVENT_POSITION) * CFrame.Angles(0, EVENT_YAW, 0)
    end
end

local function teleportBack()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") and savedCFrame then
        char.HumanoidRootPart.CFrame = savedCFrame
    end
end

--==================== UI ==========================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "GANDAX_EVENT_SYSTEM"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(320, 230)
frame.Position = UDim2.fromScale(0.05, 0.25)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

-- HEADER
local header = Instance.new("Frame", frame)
header.Size = UDim2.fromOffset(320, 40)
header.BackgroundColor3 = Color3.fromRGB(35,35,35)
header.BorderSizePixel = 0

local titleBtn = Instance.new("TextButton", header)
titleBtn.Size = UDim2.fromScale(1,1)
titleBtn.Text = "GANDAX EVENT SYSTEM"
titleBtn.Font = Enum.Font.GothamBold
titleBtn.TextSize = 14
titleBtn.TextColor3 = Color3.new(1,1,1)
titleBtn.BackgroundTransparency = 1
titleBtn.AutoButtonColor = false

local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Size = UDim2.fromOffset(30,30)
minimizeBtn.Position = UDim2.fromOffset(285,5)
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0,6)

-- CONTENT
local content = Instance.new("Frame", frame)
content.Position = UDim2.fromOffset(0,40)
content.Size = UDim2.fromOffset(320,190)
content.BackgroundTransparency = 1

local versionLabel = Instance.new("TextLabel", content)
versionLabel.Size = UDim2.fromOffset(320,20)
versionLabel.Text = VERSION
versionLabel.Font = Enum.Font.Gotham
versionLabel.TextSize = 11
versionLabel.TextColor3 = Color3.fromRGB(180,180,180)
versionLabel.BackgroundTransparency = 1

local statusLabel = Instance.new("TextLabel", content)
statusLabel.Position = UDim2.fromOffset(10,25)
statusLabel.Size = UDim2.fromOffset(300,25)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.TextColor3 = Color3.new(1,1,1)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.BackgroundTransparency = 1

local timerLabel = Instance.new("TextLabel", content)
timerLabel.Position = UDim2.fromOffset(10,55)
timerLabel.Size = UDim2.fromOffset(300,35)
timerLabel.TextXAlignment = Enum.TextXAlignment.Left
timerLabel.TextColor3 = Color3.fromRGB(0,255,150)
timerLabel.Font = Enum.Font.GothamBold
timerLabel.TextSize = 16
timerLabel.BackgroundTransparency = 1

local toggleBtn = Instance.new("TextButton", content)
toggleBtn.Position = UDim2.fromOffset(10,105)
toggleBtn.Size = UDim2.fromOffset(300,35)
toggleBtn.Text = "Auto Event : OFF"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0,6)

toggleBtn.MouseButton1Click:Connect(function()
    autoEvent = not autoEvent
    toggleBtn.Text = autoEvent and "Auto Event : ON" or "Auto Event : OFF"
end)

--==================== DRAG (PC + MOBILE) ==========
do
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = i.Position
            startPos = frame.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

--==================== MINIMIZE ====================
local function setMinimized(state)
    minimized = state
    if minimized then
        content.Visible = false
        frame.Size = UDim2.fromOffset(50,50)
        header.Size = UDim2.fromOffset(50,50)
        titleBtn.Text = "G"
        titleBtn.TextSize = 20
        minimizeBtn.Visible = false
    else
        content.Visible = true
        frame.Size = UDim2.fromOffset(320,230)
        header.Size = UDim2.fromOffset(320,40)
        titleBtn.Text = "GANDAX EVENT SYSTEM"
        titleBtn.TextSize = 14
        minimizeBtn.Visible = true
    end
end

minimizeBtn.MouseButton1Click:Connect(function()
    setMinimized(true)
end)

titleBtn.MouseButton1Click:Connect(function()
    if minimized then
        setMinimized(false)
    end
end)

--==================== MAIN LOOP ===================
RunService.Heartbeat:Connect(function()
    if not autoEvent then
        statusLabel.Text = "Status: Auto Event OFF"
        timerLabel.Text = "--"
        return
    end

    local now = getTimeGMT8()
    local progress = now % EVENT_INTERVAL

    if progress < EVENT_DURATION then
        -- EVENT ACTIVE
        local left = EVENT_DURATION - progress
        statusLabel.Text = "Status: EVENT ACTIVE"
        timerLabel.Text = string.format(
            "Ends In: %02d:%02d:%02d",
            left//3600, (left%3600)//60, left%60
        )

        if not inEvent then
            inEvent = true
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                savedCFrame = char.HumanoidRootPart.CFrame -- SIMPAN POSISI + ARAH
                teleportToEvent()
            end
        end
    else
        -- WAITING
        local nextEvent = EVENT_INTERVAL - progress
        statusLabel.Text = "Status: Waiting Event"
        timerLabel.Text = string.format(
            "Next Event In: %02d:%02d:%02d",
            nextEvent//3600, (nextEvent%3600)//60, nextEvent%60
        )

        if inEvent then
            inEvent = false
            teleportBack()
            savedCFrame = nil
        end
    end
end)
