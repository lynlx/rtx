--[[ 
    GANDAX Auto Event System
    Event: Every 2 hours (even hours) GMT+8
    Duration: 29 menit 55 detik (selesai 5 detik sebelum jam)
    Fixed Event Point
    Features: Draggable UI, Minimize with GX logo
    Added: Anti-AFK, Click Teleport, Status Display, Color-coded buttons
--]]

local GANDAX_VERSION = "v1.4.1"
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

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
local IsDraggingUI = false
local IsDraggingLogo = false
local LastLogoPosition = nil
local AntiAFKEnabled = false
local ClickTPEnabled = false
-- ==========================================

-- ================= UI =====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GANDAX"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game.CoreGui

-- Main Frame
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 320, 0, 250) -- Diperbesar untuk fitur baru
Frame.Position = UDim2.new(0, 20, 0.5, -125)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.ZIndex = 2
Frame.ClipsDescendants = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

-- Title Bar
local TitleBar = Instance.new("Frame", Frame)
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 3
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
Title.ZIndex = 4

-- Minimize Button
local MinimizeButton = Instance.new("TextButton", TitleBar)
MinimizeButton.Size = UDim2.new(0, 30, 0, 20)
MinimizeButton.Position = UDim2.new(1, -40, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinimizeButton.Text = "-"
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 16
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.ZIndex = 4
MinimizeButton.AutoButtonColor = true
Instance.new("UICorner", MinimizeButton)

-- Main Content
local Content = Instance.new("Frame", Frame)
Content.Size = UDim2.new(1, 0, 1, -30)
Content.Position = UDim2.new(0, 0, 0, 30)
Content.BackgroundTransparency = 1
Content.ZIndex = 2

-- ================= COLOR-CODED BUTTONS ==================
-- Auto Event Toggle Button (Warna MERAH/OFF - HIJAU/ON)
local Toggle = Instance.new("TextButton", Content)
Toggle.Position = UDim2.new(0, 15, 0, 10)
Toggle.Size = UDim2.new(1, -30, 0, 35)
Toggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60) -- Merah untuk OFF
Toggle.Text = "AUTO EVENT : OFF"
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 13
Toggle.TextColor3 = Color3.new(1, 1, 1)
Toggle.ZIndex = 2
Toggle.AutoButtonColor = true
Instance.new("UICorner", Toggle)

-- Status Display (Text log untuk feedback aksi)
local Status = Instance.new("TextLabel", Content)
Status.Position = UDim2.new(0, 15, 0, 55)
Status.Size = UDim2.new(1, -30, 0, 70)
Status.BackgroundTransparency = 1
Status.TextWrapped = true
Status.TextYAlignment = Enum.TextYAlignment.Top
Status.Font = Enum.Font.Code
Status.TextSize = 11
Status.TextColor3 = Color3.fromRGB(200, 200, 200)
Status.Text = "GANDAX " .. GANDAX_VERSION .. "\nDuration: 29:55\nStatus: Idle\nNext Event: --:--:--"
Status.ZIndex = 2

-- Click Teleport Button (Warna HIJAU)
local ClickTPButton = Instance.new("TextButton", Content)
ClickTPButton.Position = UDim2.new(0, 15, 0, 135)
ClickTPButton.Size = UDim2.new(0.45, 0, 0, 30)
ClickTPButton.BackgroundColor3 = Color3.fromRGB(80, 160, 80) -- Hijau
ClickTPButton.Text = "CLICK TP (Ctrl)"
ClickTPButton.Font = Enum.Font.Gotham
ClickTPButton.TextSize = 11
ClickTPButton.TextColor3 = Color3.new(1, 1, 1)
ClickTPButton.ZIndex = 2
ClickTPButton.AutoButtonColor = true
Instance.new("UICorner", ClickTPButton)

-- Anti-AFK Button (Warna UNGU)
local AntiAFKButton = Instance.new("TextButton", Content)
AntiAFKButton.Position = UDim2.new(0.5, 0, 0, 135)
AntiAFKButton.Size = UDim2.new(0.45, 0, 0, 30)
AntiAFKButton.BackgroundColor3 = Color3.fromRGB(160, 80, 160) -- Ungu
AntiAFKButton.Text = "ANTI-AFK"
AntiAFKButton.Font = Enum.Font.Gotham
AntiAFKButton.TextSize = 11
AntiAFKButton.TextColor3 = Color3.new(1, 1, 1)
AntiAFKButton.ZIndex = 2
AntiAFKButton.AutoButtonColor = true
Instance.new("UICorner", AntiAFKButton)

-- Result Display (Feedback text)
local ResultText = Instance.new("TextLabel", Content)
ResultText.Position = UDim2.new(0, 15, 0, 175)
ResultText.Size = UDim2.new(1, -30, 0, 50)
ResultText.BackgroundTransparency = 1
ResultText.TextWrapped = true
ResultText.Font = Enum.Font.Code
ResultText.TextSize = 10
ResultText.TextColor3 = Color3.fromRGB(150, 200, 150)
ResultText.Text = "Ready - Click TP: Hold Ctrl + Click\nAnti-AFK: Prevents AFK kick"
ResultText.ZIndex = 2

-- GX Logo (Minimized State) - SEPENUHNYA TERPISAH dari Frame
local GXLogo = Instance.new("TextButton")
GXLogo.Size = UDim2.new(0, 60, 0, 60)
GXLogo.Position = UDim2.new(0, 20, 0, 20)
GXLogo.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
GXLogo.Text = "GX"
GXLogo.Font = Enum.Font.GothamBold
GXLogo.TextSize = 20
GXLogo.TextColor3 = Color3.new(1, 1, 1)
GXLogo.Visible = false
GXLogo.Active = true
GXLogo.ZIndex = 100
GXLogo.AutoButtonColor = true
GXLogo.Name = "GXLogo"
GXLogo.Parent = ScreenGui
Instance.new("UICorner", GXLogo).CornerRadius = UDim.new(0, 10)

-- GX Logo Decoration (FIXED: Create them AFTER logo parent is set)
local GXDecoration1 = Instance.new("Frame")
GXDecoration1.Size = UDim2.new(0, 4, 0.6, 0)
GXDecoration1.Position = UDim2.new(0.3, 0, 0.2, 0)
GXDecoration1.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
GXDecoration1.BorderSizePixel = 0
GXDecoration1.ZIndex = 101
GXDecoration1.Name = "GXDecoration1"

local GXDecoration2 = Instance.new("Frame")
GXDecoration2.Size = UDim2.new(0, 4, 0.6, 0)
GXDecoration2.Position = UDim2.new(0.7, 0, 0.2, 0)
GXDecoration2.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
GXDecoration2.BorderSizePixel = 0
GXDecoration2.ZIndex = 101
GXDecoration2.Name = "GXDecoration2"
-- ==========================================

-- ================= SIMPLE DRAG SYSTEM ==============
-- Simple drag untuk Frame
local function makeDraggable(frame, dragPart)
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
    
    dragPart.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            -- Set flag berdasarkan frame yang didrag
            if frame == Frame then
                IsDraggingUI = true
            else
                IsDraggingLogo = true
            end
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if frame == Frame then
                        IsDraggingUI = false
                    else
                        IsDraggingLogo = false
                    end
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

-- Apply draggable
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
    
    ResultText.Text = "EVENT STARTED!\nTeleported to event location\nDuration: 29:55"
end

local function endEvent()
    local hrp = getHRP()
    if hrp and LastPosition then
        hrp.CFrame = LastPosition
    end
    EventActive = false
    EventEndTime = nil
    
    ResultText.Text = "EVENT ENDED!\nReturned to original position"
end

local function resetLogo()
    -- Reset logo ke state awal
    GXLogo.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    GXLogo.BackgroundTransparency = 0
    GXLogo.Text = "GX"
    
    -- Re-attach decorations jika hilang
    if not GXLogo:FindFirstChild("GXDecoration1") then
        GXDecoration1.Parent = GXLogo
        Instance.new("UICorner", GXDecoration1)
    end
    
    if not GXLogo:FindFirstChild("GXDecoration2") then
        GXDecoration2.Parent = GXLogo
        Instance.new("UICorner", GXDecoration2)
    end
    
    -- Reset size dan visibility
    GXLogo.Size = UDim2.new(0, 60, 0, 60)
    GXLogo.Visible = false
end

local function minimizeUI()
    if UIMinimized then return end
    
    -- Reset logo terlebih dahulu
    resetLogo()
    
    -- Simpan posisi frame
    LastLogoPosition = Frame.Position
    
    -- Animasi minimize frame
    local frameTween = TweenService:Create(
        Frame,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }
    )
    
    frameTween:Play()
    
    -- Tunggu animasi selesai lalu sembunyikan frame
    wait(0.2)
    Frame.Visible = false
    
    -- Tampilkan logo di posisi yang sama
    GXLogo.Position = LastLogoPosition
    GXLogo.Visible = true
    GXLogo.Size = UDim2.new(0, 0, 0, 0)
    GXLogo.BackgroundTransparency = 0
    
    -- Pastikan decorations ada
    GXDecoration1.Parent = GXLogo
    GXDecoration2.Parent = GXLogo
    
    -- Animasi logo muncul
    local logoAnim = TweenService:Create(
        GXLogo,
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0, 60, 0, 60)
        }
    )
    
    logoAnim:Play()
    UIMinimized = true
    MinimizeButton.Text = "+"
    
    ResultText.Text = "Minimized to GX logo\nClick logo to restore"
end

local function maximizeUI()
    if not UIMinimized then return end
    
    -- Simpan posisi logo
    LastLogoPosition = GXLogo.Position
    
    -- Animasi logo hilang
    local logoAnim = TweenService:Create(
        GXLogo,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }
    )
    
    logoAnim:Play()
    
    -- Tunggu animasi selesai lalu sembunyikan logo
    wait(0.2)
    GXLogo.Visible = false
    
    -- Reset logo state
    GXLogo.Size = UDim2.new(0, 60, 0, 60)
    GXLogo.BackgroundTransparency = 0
    
    -- Tampilkan frame di posisi logo
    Frame.Position = LastLogoPosition
    Frame.Visible = true
    Frame.Size = UDim2.new(0, 0, 0, 0)
    Frame.BackgroundTransparency = 0
    
    -- Animasi frame muncul
    local frameAnim = TweenService:Create(
        Frame,
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0, 320, 0, 250)
        }
    )
    
    frameAnim:Play()
    UIMinimized = false
    MinimizeButton.Text = "-"
    
    ResultText.Text = "GANDAX " .. GANDAX_VERSION .. " Restored\nAll features available"
end

local function toggleMinimize()
    if UIMinimized then
        maximizeUI()
    else
        minimizeUI()
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
            Status.Text = "Status: EVENT ACTIVE\nEnds in: " .. string.format("%02d:%02d", m, s) .. "\nNext Event: --:--:--"
        end
    else
        Status.Text = "GANDAX " .. GANDAX_VERSION .. "\nDuration: 29:55\nStatus: " .. (AutoEventEnabled and "Active" or "Idle") .. "\nNext Event: " .. getNextEventCountdown()
    end
end

-- ================= CLICK TELEPORT SYSTEM ==================
local Mouse = LocalPlayer:GetMouse()

ClickTPButton.MouseButton1Click:Connect(function()
    ClickTPEnabled = not ClickTPEnabled
    
    if ClickTPEnabled then
        ClickTPButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100) -- Hijau terang saat ON
        ClickTPButton.Text = "CLICK TP: ON (Ctrl)"
        ResultText.Text = "Click TP ACTIVE\nHold Ctrl + Click to teleport"
    else
        ClickTPButton.BackgroundColor3 = Color3.fromRGB(80, 160, 80) -- Hijau normal saat OFF
        ClickTPButton.Text = "CLICK TP (Ctrl)"
        ResultText.Text = "Click TP INACTIVE"
    end
end)

Mouse.Button1Down:Connect(function()
    if ClickTPEnabled and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") and Mouse.Target then
            local targetPos = Mouse.Hit.p
            char.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
            ResultText.Text = string.format("Teleported to:\nX: %d, Y: %d, Z: %d", 
                math.floor(targetPos.X), math.floor(targetPos.Y), math.floor(targetPos.Z))
        end
    end
end)

-- ================= ANTI-AFK SYSTEM ==================
AntiAFKButton.MouseButton1Click:Connect(function()
    AntiAFKEnabled = not AntiAFKEnabled
    
    if AntiAFKEnabled then
        AntiAFKButton.BackgroundColor3 = Color3.fromRGB(180, 100, 180) -- Ungu terang saat ON
        AntiAFKButton.Text = "ANTI-AFK: ON"
        ResultText.Text = "Anti-AFK ACTIVE\nWill prevent AFK kick"
        
        -- Start anti-AFK loop
        task.spawn(function()
            while AntiAFKEnabled do
                wait(30)
                if AntiAFKEnabled then
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new(0, 0))
                    end)
                end
            end
        end)
    else
        AntiAFKButton.BackgroundColor3 = Color3.fromRGB(160, 80, 160) -- Ungu normal saat OFF
        AntiAFKButton.Text = "ANTI-AFK"
        ResultText.Text = "Anti-AFK INACTIVE"
    end
end)

-- ================= EVENTS =================
Toggle.MouseButton1Click:Connect(function()
    AutoEventEnabled = not AutoEventEnabled
    if AutoEventEnabled then
        Toggle.Text = "AUTO EVENT : ON"
        Toggle.BackgroundColor3 = Color3.fromRGB(60, 180, 60) -- Hijau saat ON
        ResultText.Text = "Auto Event ENABLED\nWill auto teleport every 2 hours"
    else
        Toggle.Text = "AUTO EVENT : OFF"
        Toggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60) -- Merah saat OFF
        ResultText.Text = "Auto Event DISABLED"
        if EventActive then
            endEvent()
        end
    end
    updateStatus()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    toggleMinimize()
end)

-- Event yang lebih sederhana untuk GXLogo
GXLogo.MouseButton1Click:Connect(function()
    if UIMinimized then
        maximizeUI()
    end
end)

-- Hover effects untuk semua buttons
MinimizeButton.MouseEnter:Connect(function()
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
end)

MinimizeButton.MouseLeave:Connect(function()
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
end)

Toggle.MouseEnter:Connect(function()
    Toggle.BackgroundColor3 = AutoEventEnabled and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(200, 80, 80)
end)

Toggle.MouseLeave:Connect(function()
    Toggle.BackgroundColor3 = AutoEventEnabled and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(180, 60, 60)
end)

ClickTPButton.MouseEnter:Connect(function()
    ClickTPButton.BackgroundColor3 = ClickTPEnabled and Color3.fromRGB(120, 220, 120) or Color3.fromRGB(100, 180, 100)
end)

ClickTPButton.MouseLeave:Connect(function()
    ClickTPButton.BackgroundColor3 = ClickTPEnabled and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(80, 160, 80)
end)

AntiAFKButton.MouseEnter:Connect(function()
    AntiAFKButton.BackgroundColor3 = AntiAFKEnabled and Color3.fromRGB(200, 120, 200) or Color3.fromRGB(180, 100, 180)
end)

AntiAFKButton.MouseLeave:Connect(function()
    AntiAFKButton.BackgroundColor3 = AntiAFKEnabled and Color3.fromRGB(180, 100, 180) or Color3.fromRGB(160, 80, 160)
end)

GXLogo.MouseEnter:Connect(function()
    GXLogo.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)

GXLogo.MouseLeave:Connect(function()
    GXLogo.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
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

-- Inisialisasi: Attach decorations ke logo
GXDecoration1.Parent = GXLogo
GXDecoration2.Parent = GXLogo
Instance.new("UICorner", GXDecoration1)
Instance.new("UICorner", GXDecoration2)

-- Initial update
updateStatus()

print("========================================")
print("GANDAX AUTO EVENT " .. GANDAX_VERSION)
print("========================================")
print("FIXES:")
print("1. ✓ Fixed logo background disappearing on multiple minimize/maximize")
print("2. ✓ Logo decorations properly reattached each time")
print("3. ✓ Background transparency reset on each minimize")
print("")
print("FEATURES ADDED:")
print("1. ✓ Anti-AFK System (Prevents AFK kick)")
print("2. ✓ Click Teleport (Hold Ctrl + Click)")
print("3. ✓ Color-coded buttons (Red/Green/Purple)")
print("4. ✓ Status Display with feedback")
print("5. ✓ Auto Event every 2 hours")
print("6. ✓ Minimize with GX logo")
print("========================================")
