--[[ 
    GANDAX Weather & Time Control
    Features: Weather cleanup, time slider, minimize, draggable UI
    Fixed: Minimize button, UI structure, slider functionality
--]]

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- ================= STATE ==================
local UIMinimized = false
-- ==========================================

-- ================= UI =====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GANDAX_FINAL"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame - SEMUA DALAM SATU FRAME
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 320, 0, 260)
Frame.Position = UDim2.new(0, 20, 0.5, -130)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

-- Title Bar (HANYA INI YANG DRAGGABLE)
local TitleBar = Instance.new("Frame", Frame)
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

-- Title Text
local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "GANDAX WEATHER CONTROL"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0, 15, 0, 0)

-- Minimize Button (FIXED - seperti v1.2.0)
local MinimizeButton = Instance.new("TextButton", TitleBar)
MinimizeButton.Size = UDim2.new(0, 30, 0, 20)
MinimizeButton.Position = UDim2.new(1, -40, 0, 7)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinimizeButton.Text = "-"
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 16
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", MinimizeButton)

-- GX Logo (Minimized State)
local GXLogo = Instance.new("TextButton", ScreenGui)
GXLogo.Size = UDim2.new(0, 60, 0, 60)
GXLogo.Position = Frame.Position
GXLogo.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
GXLogo.Text = "GX"
GXLogo.Font = Enum.Font.GothamBold
GXLogo.TextSize = 20
GXLogo.TextColor3 = Color3.new(1, 1, 1)
GXLogo.Visible = false
GXLogo.Active = true
GXLogo.Draggable = true
Instance.new("UICorner", GXLogo).CornerRadius = UDim.new(0, 10)

-- Main Content Area
local Content = Instance.new("Frame", Frame)
Content.Size = UDim2.new(1, 0, 1, -35)
Content.Position = UDim2.new(0, 0, 0, 35)
Content.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Content.BorderSizePixel = 0
Instance.new("UICorner", Content).CornerRadius = UDim.new(0, 10)

-- Status Display
local Status = Instance.new("TextLabel", Content)
Status.Position = UDim2.new(0, 15, 0, 10)
Status.Size = UDim2.new(1, -30, 0, 40)
Status.BackgroundTransparency = 1
Status.TextWrapped = true
Status.TextYAlignment = Enum.TextYAlignment.Top
Status.Font = Enum.Font.Code
Status.TextSize = 11
Status.TextColor3 = Color3.fromRGB(200, 200, 200)
Status.Text = "GANDAX Weather & Time Control\nReady to use all features"

-- Time Control Section
local TimeLabel = Instance.new("TextLabel", Content)
TimeLabel.Position = UDim2.new(0, 15, 0, 60)
TimeLabel.Size = UDim2.new(1, -30, 0, 20)
TimeLabel.BackgroundTransparency = 1
TimeLabel.Text = "TIME CONTROL (Drag slider)"
TimeLabel.Font = Enum.Font.GothamBold
TimeLabel.TextSize = 12
TimeLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
TimeLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Time Slider Background
local SliderBackground = Instance.new("Frame", Content)
SliderBackground.Position = UDim2.new(0, 15, 0, 85)
SliderBackground.Size = UDim2.new(1, -30, 0, 20)
SliderBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SliderBackground.Active = false  -- Nonaktifkan agar tidak menangkap drag
SliderBackground.Selectable = false
Instance.new("UICorner", SliderBackground).CornerRadius = UDim.new(0, 5)

-- Time Slider Track
local SliderTrack = Instance.new("Frame", SliderBackground)
SliderTrack.Size = UDim2.new(1, 0, 1, 0)
SliderTrack.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
Instance.new("UICorner", SliderTrack).CornerRadius = UDim.new(0, 5)

-- Time Slider Thumb (bisa digeser)
local SliderThumb = Instance.new("TextButton", SliderBackground)  -- Pakai TextButton agar bisa di-click
SliderThumb.Size = UDim2.new(0, 15, 0, 25)
SliderThumb.Position = UDim2.new(0.5, -7.5, 0, -2.5)
SliderThumb.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
SliderThumb.BorderSizePixel = 0
SliderThumb.Text = ""  -- Kosongkan text
SliderThumb.AutoButtonColor = false  -- Nonaktifkan auto color
Instance.new("UICorner", SliderThumb).CornerRadius = UDim.new(0, 3)

-- Time Display
local TimeDisplay = Instance.new("TextLabel", Content)
TimeDisplay.Position = UDim2.new(0, 15, 0, 110)
TimeDisplay.Size = UDim2.new(1, -30, 0, 20)
TimeDisplay.BackgroundTransparency = 1
TimeDisplay.Text = "Current Time: 12:00 (Day)"
TimeDisplay.Font = Enum.Font.Code
TimeDisplay.TextSize = 11
TimeDisplay.TextColor3 = Color3.fromRGB(200, 200, 200)
TimeDisplay.TextXAlignment = Enum.TextXAlignment.Center

-- Weather Control Section
local WeatherLabel = Instance.new("TextLabel", Content)
WeatherLabel.Position = UDim2.new(0, 15, 0, 135)
WeatherLabel.Size = UDim2.new(1, -30, 0, 20)
WeatherLabel.BackgroundTransparency = 1
WeatherLabel.Text = "WEATHER CONTROL"
WeatherLabel.Font = Enum.Font.GothamBold
WeatherLabel.TextSize = 12
WeatherLabel.TextColor3 = Color3.fromRGB(255, 180, 100)
WeatherLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Remove Atmosphere Button
local RemoveAtmosButton = Instance.new("TextButton", Content)
RemoveAtmosButton.Position = UDim2.new(0.05, 0, 0, 160)
RemoveAtmosButton.Size = UDim2.new(0.45, 0, 0, 30)
RemoveAtmosButton.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
RemoveAtmosButton.Text = "REMOVE ATMOSPHERE"
RemoveAtmosButton.Font = Enum.Font.Gotham
RemoveAtmosButton.TextSize = 11
RemoveAtmosButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", RemoveAtmosButton)

-- Remove Particles Button
local RemoveParticlesButton = Instance.new("TextButton", Content)
RemoveParticlesButton.Position = UDim2.new(0.5, 0, 0, 160)
RemoveParticlesButton.Size = UDim2.new(0.45, 0, 0, 30)
RemoveParticlesButton.BackgroundColor3 = Color3.fromRGB(200, 120, 80)
RemoveParticlesButton.Text = "REMOVE PARTICLES"
RemoveParticlesButton.Font = Enum.Font.Gotham
RemoveParticlesButton.TextSize = 11
RemoveParticlesButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", RemoveParticlesButton)

-- Result Display
local ResultText = Instance.new("TextLabel", Content)
ResultText.Position = UDim2.new(0, 15, 0, 200)
ResultText.Size = UDim2.new(1, -30, 0, 40)
ResultText.BackgroundTransparency = 1
ResultText.TextWrapped = true
ResultText.Font = Enum.Font.Code
ResultText.TextSize = 10
ResultText.TextColor3 = Color3.fromRGB(150, 200, 150)
ResultText.Text = "Ready"
-- ==========================================

-- ================= FUNCTIONS ==============
-- Solara-proof button connection
local function connectButton(button, callback)
    button.Activated:Connect(callback)
    button.MouseButton1Click:Connect(callback)
end

-- Function untuk toggle minimize (SAMA PERSIS seperti v1.2.0)
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

-- Function untuk update waktu berdasarkan slider
local function updateTimeFromSlider(position)
    -- position: 0-1 dari slider
    local hour = math.floor(position * 24) % 24
    local minute = math.floor((position * 24 * 60) % 60)
    
    -- Set waktu di Lighting
    Lighting.ClockTime = hour + (minute / 60)
    
    -- Tentukan nama waktu
    local timeName = ""
    if hour >= 5 and hour < 10 then
        timeName = "Morning"
    elseif hour >= 10 and hour < 16 then
        timeName = "Day"
    elseif hour >= 16 and hour < 19 then
        timeName = "Afternoon"
    elseif hour >= 19 and hour < 23 then
        timeName = "Night"
    else
        timeName = "Midnight"
    end
    
    -- Update display
    TimeDisplay.Text = string.format("Current Time: %02d:%02d (%s)", hour, minute, timeName)
    
    -- Update brightness sesuai waktu
    if timeName == "Morning" then
        Lighting.Brightness = 1.2
        Lighting.Ambient = Color3.fromRGB(255, 230, 200)
    elseif timeName == "Day" then
        Lighting.Brightness = 2.0
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    elseif timeName == "Afternoon" then
        Lighting.Brightness = 1.5
        Lighting.Ambient = Color3.fromRGB(255, 200, 150)
    elseif timeName == "Night" then
        Lighting.Brightness = 0.3
        Lighting.Ambient = Color3.fromRGB(50, 50, 100)
    else -- Midnight
        Lighting.Brightness = 0.1
        Lighting.Ambient = Color3.fromRGB(20, 20, 40)
    end
end

-- Function untuk remove atmosphere
local function removeAllAtmosphere()
    local count = 0
    
    -- Check Lighting service
    for _, obj in pairs(Lighting:GetChildren()) do
        if obj:IsA("Atmosphere") then
            obj:Destroy()
            count = count + 1
        end
    end
    
    -- Check Workspace
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Atmosphere") then
            obj:Destroy()
            count = count + 1
        end
    end
    
    return count
end

-- Function untuk remove particles
local function removeAllParticles()
    local count = 0
    
    -- Check Workspace
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") then
            obj:Destroy()
            count = count + 1
        end
    end
    
    return count
end

-- Function untuk setup slider dragging
local function setupSlider()
    local UserInputService = game:GetService("UserInputService")
    local isDragging = false
    local dragStart = nil
    local startPos = nil
    
    -- Function untuk update slider position
    local function updateSliderPosition(xPosition)
        -- Hitung posisi relatif dalam slider
        local absoluteX = xPosition - SliderBackground.AbsolutePosition.X
        local relativeX = math.clamp(absoluteX / SliderBackground.AbsoluteSize.X, 0, 1)
        
        -- Update thumb position
        SliderThumb.Position = UDim2.new(relativeX, -7.5, 0, -2.5)
        
        -- Update time
        updateTimeFromSlider(relativeX)
    end
    
    -- Mouse down pada slider thumb
    SliderThumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            SliderThumb.BackgroundColor3 = Color3.fromRGB(130, 180, 255)
        end
    end)
    
    -- Mouse down pada slider background (klik langsung)
    SliderBackground.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UserInputService:GetMouseLocation()
            updateSliderPosition(mousePos.X)
        end
    end)
    
    -- Mouse movement global
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            updateSliderPosition(mousePos.X)
        end
    end)
    
    -- Mouse up global
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if isDragging then
                isDragging = false
                SliderThumb.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
            end
        end
    end)
end

-- Function untuk make title bar draggable
local function makeTitleBarDraggable()
    local UserInputService = game:GetService("UserInputService")
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    -- Fungsi untuk update position
    local function update(input)
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    -- Input began di title bar
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    -- Input changed
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    -- Global input changed
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end
-- ==========================================

-- ================= EVENT CONNECTIONS =================
-- Minimize Button (FIXED - langsung panggil fungsi)
MinimizeButton.Activated:Connect(toggleMinimize)

-- GX Logo untuk restore
GXLogo.MouseButton1Click:Connect(function()
    if UIMinimized then
        toggleMinimize()
    end
end)

-- Remove Atmosphere Button
connectButton(RemoveAtmosButton, function()
    RemoveAtmosButton.Text = "CLEANING..."
    RemoveAtmosButton.BackgroundColor3 = Color3.fromRGB(120, 160, 220)
    
    local count = removeAllAtmosphere()
    
    RemoveAtmosButton.Text = "REMOVE ATMOSPHERE"
    RemoveAtmosButton.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
    
    ResultText.Text = "✓ Cleared " .. count .. " fog/haze effects"
    
    print("Removed " .. count .. " Atmosphere objects")
end)

-- Remove Particles Button
connectButton(RemoveParticlesButton, function()
    RemoveParticlesButton.Text = "CLEANING..."
    RemoveParticlesButton.BackgroundColor3 = Color3.fromRGB(220, 140, 100)
    
    local count = removeAllParticles()
    
    RemoveParticlesButton.Text = "REMOVE PARTICLES"
    RemoveParticlesButton.BackgroundColor3 = Color3.fromRGB(200, 120, 80)
    
    ResultText.Text = "✓ Cleared " .. count .. " rain/snow particles"
    
    print("Removed " .. count .. " ParticleEmitter objects")
end)
-- ==========================================

-- ================= INITIALIZATION =================
-- Setup draggable title bar
makeTitleBarDraggable()

-- Setup slider
setupSlider()

-- Set initial time to 12:00 (Day)
updateTimeFromSlider(0.5)

print("GANDAX Weather & Time Control v3.0 Loaded!")
print("FIXED ISSUES:")
print("1. Minimize button now works")
print("2. UI stays together (no separation)")
print("3. Slider can be dragged without moving UI")
print("4. Only title bar is draggable")
-- ==========================================
