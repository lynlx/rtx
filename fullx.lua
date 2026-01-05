--[[ 
    GANDAX 2.4.2 - Minimize Fix & UI Improvements
    Fixed: Minimize bug, improved logo design
    Added: Cinematic 1 & 2 effects
--]]

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- ================= STATE ==================
local UIMinimized = false
local ClickTPEnabled = false
local AntiAFKEnabled = false
local BokehEnabled = false
local BokehIntensity = 0.5
local CurrentDepthOfField = nil

-- Mouse untuk Click TP
local Mouse = LocalPlayer:GetMouse()
-- ==========================================

-- ================= UI =====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GANDAX_2_4_2"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame (diperbesar untuk menampung tombol baru)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 350, 0, 480) -- Diperbesar dari 420 ke 480
Frame.Position = UDim2.new(0, 20, 0.5, -240) -- Disesuaikan untuk tinggi baru
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
local FrameCorner = Instance.new("UICorner", Frame)
FrameCorner.CornerRadius = UDim.new(0, 10)

-- Title Bar
local TitleBar = Instance.new("Frame", Frame)
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

-- Title Text
local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "GANDAX 2.4.2"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0, 15, 0, 0)

-- Minimize Button
local MinimizeButton = Instance.new("TextButton", TitleBar)
MinimizeButton.Size = UDim2.new(0, 30, 0, 20)
MinimizeButton.Position = UDim2.new(1, -40, 0, 7)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinimizeButton.Text = "-"
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 16
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", MinimizeButton)

-- =========== IMPROVED GX LOGO ===========
local GXLogo = Instance.new("Frame", ScreenGui)
GXLogo.Size = UDim2.new(0, 70, 0, 70)  -- Sedikit lebih besar
GXLogo.Position = Frame.Position
GXLogo.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
GXLogo.Visible = false
Instance.new("UICorner", GXLogo).CornerRadius = UDim.new(0, 12)

-- Background gradient effect
local Gradient = Instance.new("UIGradient", GXLogo)
Gradient.Rotation = 45
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 60, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
})

-- Border stroke
local LogoStroke = Instance.new("UIStroke", GXLogo)
LogoStroke.Color = Color3.fromRGB(100, 100, 255)
LogoStroke.Thickness = 2

-- GX Text with effects
local LogoText = Instance.new("TextLabel", GXLogo)
LogoText.Size = UDim2.new(1, 0, 1, 0)
LogoText.BackgroundTransparency = 1
LogoText.Text = "GX"
LogoText.Font = Enum.Font.GothamBlack
LogoText.TextSize = 26
LogoText.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoText.TextStrokeTransparency = 0
LogoText.TextStrokeColor3 = Color3.fromRGB(100, 100, 255)

-- Shadow effect
local TextShadow = Instance.new("TextLabel", GXLogo)
TextShadow.Size = UDim2.new(1, 0, 1, 0)
TextShadow.Position = UDim2.new(0, 2, 0, 2)
TextShadow.BackgroundTransparency = 1
TextShadow.Text = "GX"
TextShadow.Font = Enum.Font.GothamBlack
TextShadow.TextSize = 26
TextShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
TextShadow.TextTransparency = 0.3
TextShadow.ZIndex = -1

-- Click area (transparent button covering the whole logo)
local LogoButton = Instance.new("TextButton", GXLogo)
LogoButton.Size = UDim2.new(1, 0, 1, 0)
LogoButton.BackgroundTransparency = 1
LogoButton.Text = ""
-- =========================================

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
Status.Text = "GANDAX 2.4.2 - Minimize Bug Fixed\nLogo design improved + Cinematic Effects"

-- ================= TIME CONTROL ==================
local TimeLabel = Instance.new("TextLabel", Content)
TimeLabel.Position = UDim2.new(0, 15, 0, 60)
TimeLabel.Size = UDim2.new(1, -30, 0, 20)
TimeLabel.BackgroundTransparency = 1
TimeLabel.Text = "TIME CONTROL"
TimeLabel.Font = Enum.Font.GothamBold
TimeLabel.TextSize = 12
TimeLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
TimeLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Time Slider
local TimeSliderBackground = Instance.new("Frame", Content)
TimeSliderBackground.Position = UDim2.new(0, 15, 0, 85)
TimeSliderBackground.Size = UDim2.new(1, -30, 0, 20)
TimeSliderBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", TimeSliderBackground).CornerRadius = UDim.new(0, 5)

local TimeSliderThumb = Instance.new("Frame", TimeSliderBackground)
TimeSliderThumb.Size = UDim2.new(0, 15, 0, 25)
TimeSliderThumb.Position = UDim2.new(0.5, -7.5, 0, -2.5)
TimeSliderThumb.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
TimeSliderThumb.BorderSizePixel = 0
Instance.new("UICorner", TimeSliderThumb).CornerRadius = UDim.new(0, 3)

local TimeDisplay = Instance.new("TextLabel", Content)
TimeDisplay.Position = UDim2.new(0, 15, 0, 110)
TimeDisplay.Size = UDim2.new(1, -30, 0, 20)
TimeDisplay.BackgroundTransparency = 1
TimeDisplay.Text = "Time: 12:00 (Day)"
TimeDisplay.Font = Enum.Font.Code
TimeDisplay.TextSize = 11
TimeDisplay.TextColor3 = Color3.fromRGB(200, 200, 200)
TimeDisplay.TextXAlignment = Enum.TextXAlignment.Center

-- ================= BOKEH EFFECT ==================
local BokehLabel = Instance.new("TextLabel", Content)
BokehLabel.Position = UDim2.new(0, 15, 0, 135)
BokehLabel.Size = UDim2.new(1, -30, 0, 20)
BokehLabel.BackgroundTransparency = 1
BokehLabel.Text = "BOKEH EFFECT"
BokehLabel.Font = Enum.Font.GothamBold
BokehLabel.TextSize = 12
BokehLabel.TextColor3 = Color3.fromRGB(255, 120, 200)
BokehLabel.TextXAlignment = Enum.TextXAlignment.Left

local BokehToggleButton = Instance.new("TextButton", Content)
BokehToggleButton.Position = UDim2.new(0.05, 0, 0, 160)
BokehToggleButton.Size = UDim2.new(0.45, 0, 0, 30)
BokehToggleButton.BackgroundColor3 = Color3.fromRGB(180, 80, 180)
BokehToggleButton.Text = "BOKEH: OFF"
BokehToggleButton.Font = Enum.Font.Gotham
BokehToggleButton.TextSize = 11
BokehToggleButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", BokehToggleButton)

-- Bokeh Slider
local BokehSliderBackground = Instance.new("Frame", Content)
BokehSliderBackground.Position = UDim2.new(0, 15, 0, 195)
BokehSliderBackground.Size = UDim2.new(1, -30, 0, 20)
BokehSliderBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", BokehSliderBackground).CornerRadius = UDim.new(0, 5)

local BokehSliderThumb = Instance.new("Frame", BokehSliderBackground)
BokehSliderThumb.Size = UDim2.new(0, 15, 0, 25)
BokehSliderThumb.Position = UDim2.new(0.5, -7.5, 0, -2.5)
BokehSliderThumb.BackgroundColor3 = Color3.fromRGB(200, 100, 200)
BokehSliderThumb.BorderSizePixel = 0
Instance.new("UICorner", BokehSliderThumb).CornerRadius = UDim.new(0, 3)

local BokehIntensityDisplay = Instance.new("TextLabel", Content)
BokehIntensityDisplay.Position = UDim2.new(0, 15, 0, 220)
BokehIntensityDisplay.Size = UDim2.new(1, -30, 0, 20)
BokehIntensityDisplay.BackgroundTransparency = 1
BokehIntensityDisplay.Text = "Intensity: 0.5"
BokehIntensityDisplay.Font = Enum.Font.Code
BokehIntensityDisplay.TextSize = 11
BokehIntensityDisplay.TextColor3 = Color3.fromRGB(200, 200, 200)
BokehIntensityDisplay.TextXAlignment = Enum.TextXAlignment.Center

-- ================= WEATHER CONTROL ==================
local WeatherLabel = Instance.new("TextLabel", Content)
WeatherLabel.Position = UDim2.new(0, 15, 0, 245)
WeatherLabel.Size = UDim2.new(1, -30, 0, 20)
WeatherLabel.BackgroundTransparency = 1
WeatherLabel.Text = "WEATHER CONTROL"
WeatherLabel.Font = Enum.Font.GothamBold
WeatherLabel.TextSize = 12
WeatherLabel.TextColor3 = Color3.fromRGB(255, 180, 100)
WeatherLabel.TextXAlignment = Enum.TextXAlignment.Left

local RemoveAtmosButton = Instance.new("TextButton", Content)
RemoveAtmosButton.Position = UDim2.new(0.05, 0, 0, 270)
RemoveAtmosButton.Size = UDim2.new(0.45, 0, 0, 30)
RemoveAtmosButton.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
RemoveAtmosButton.Text = "REMOVE ATMOSPHERE"
RemoveAtmosButton.Font = Enum.Font.Gotham
RemoveAtmosButton.TextSize = 11
RemoveAtmosButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", RemoveAtmosButton)

local RemoveParticlesButton = Instance.new("TextButton", Content)
RemoveParticlesButton.Position = UDim2.new(0.5, 0, 0, 270)
RemoveParticlesButton.Size = UDim2.new(0.45, 0, 0, 30)
RemoveParticlesButton.BackgroundColor3 = Color3.fromRGB(200, 120, 80)
RemoveParticlesButton.Text = "REMOVE PARTICLES"
RemoveParticlesButton.Font = Enum.Font.Gotham
RemoveParticlesButton.TextSize = 11
RemoveParticlesButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", RemoveParticlesButton)

-- ================= CINEMATIC EFFECTS ==================
local CinematicLabel = Instance.new("TextLabel", Content)
CinematicLabel.Position = UDim2.new(0, 15, 0, 305) -- Disesuaikan
CinematicLabel.Size = UDim2.new(1, -30, 0, 20)
CinematicLabel.BackgroundTransparency = 1
CinematicLabel.Text = "CINEMATIC EFFECTS"
CinematicLabel.Font = Enum.Font.GothamBold
CinematicLabel.TextSize = 12
CinematicLabel.TextColor3 = Color3.fromRGB(200, 255, 150)
CinematicLabel.TextXAlignment = Enum.TextXAlignment.Left

local Cinematic1Button = Instance.new("TextButton", Content)
Cinematic1Button.Position = UDim2.new(0.05, 0, 0, 330) -- Disesuaikan
Cinematic1Button.Size = UDim2.new(0.45, 0, 0, 30)
Cinematic1Button.BackgroundColor3 = Color3.fromRGB(80, 160, 220)
Cinematic1Button.Text = "CINEMATIC 1"
Cinematic1Button.Font = Enum.Font.Gotham
Cinematic1Button.TextSize = 11
Cinematic1Button.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Cinematic1Button)

local Cinematic2Button = Instance.new("TextButton", Content)
Cinematic2Button.Position = UDim2.new(0.5, 0, 0, 330) -- Disesuaikan
Cinematic2Button.Size = UDim2.new(0.45, 0, 0, 30)
Cinematic2Button.BackgroundColor3 = Color3.fromRGB(220, 160, 80)
Cinematic2Button.Text = "CINEMATIC 2"
Cinematic2Button.Font = Enum.Font.Gotham
Cinematic2Button.TextSize = 11
Cinematic2Button.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Cinematic2Button)

-- ================= UTILITIES ==================
local ClickTPButton = Instance.new("TextButton", Content)
ClickTPButton.Position = UDim2.new(0.05, 0, 0, 370) -- Disesuaikan
ClickTPButton.Size = UDim2.new(0.45, 0, 0, 30)
ClickTPButton.BackgroundColor3 = Color3.fromRGB(80, 160, 80)
ClickTPButton.Text = "CLICK TP (Ctrl)"
ClickTPButton.Font = Enum.Font.Gotham
ClickTPButton.TextSize = 11
ClickTPButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", ClickTPButton)

local AntiAFKButton = Instance.new("TextButton", Content)
AntiAFKButton.Position = UDim2.new(0.5, 0, 0, 370) -- Disesuaikan
AntiAFKButton.Size = UDim2.new(0.45, 0, 0, 30)
AntiAFKButton.BackgroundColor3 = Color3.fromRGB(180, 80, 180)
AntiAFKButton.Text = "ANTI-AFK"
AntiAFKButton.Font = Enum.Font.Gotham
AntiAFKButton.TextSize = 11
AntiAFKButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", AntiAFKButton)

-- Result Display
local ResultText = Instance.new("TextLabel", Content)
ResultText.Position = UDim2.new(0, 15, 0, 410) -- Disesuaikan
ResultText.Size = UDim2.new(1, -30, 0, 50)
ResultText.BackgroundTransparency = 1
ResultText.TextWrapped = true
ResultText.Font = Enum.Font.Code
ResultText.TextSize = 10
ResultText.TextColor3 = Color3.fromRGB(150, 200, 150)
ResultText.Text = "GANDAX 2.4.2 Ready\nMinimize system fixed + Cinematic Effects added"
-- ==========================================

-- ================= FIXED MINIMIZE SYSTEM ==================

-- FIX: Improved minimize function
local function toggleMinimize()
    UIMinimized = not UIMinimized
    
    if UIMinimized then
        -- Simpan posisi frame ke logo
        GXLogo.Position = Frame.Position
        Frame.Visible = false
        GXLogo.Visible = true
        MinimizeButton.Text = "+"
        ResultText.Text = "Minimized to system tray\nClick GX logo to restore"
    else
        Frame.Visible = true
        GXLogo.Visible = false
        MinimizeButton.Text = "-"
        ResultText.Text = "GANDAX 2.4.2 Restored\nAll features available"
    end
end

-- Minimize button
MinimizeButton.MouseButton1Click:Connect(function()
    toggleMinimize()
end)

-- Logo button click to restore
LogoButton.MouseButton1Click:Connect(function()
    if UIMinimized then
        toggleMinimize()
    end
end)

-- Logo dragging system
local logoDragging = false
local logoDragStart = Vector2.new(0, 0)
local logoStartPos = Vector2.new(0, 0)

GXLogo.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        logoDragging = true
        logoDragStart = Vector2.new(input.Position.X, input.Position.Y)
        logoStartPos = Vector2.new(GXLogo.Position.X.Offset, GXLogo.Position.Y.Offset)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if logoDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - logoDragStart
        GXLogo.Position = UDim2.new(0, logoStartPos.X + delta.X, 0, logoStartPos.Y + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        logoDragging = false
    end
end)

-- ================= CINEMATIC EFFECTS FUNCTIONS ==================

-- Cinematic 1 Effect
Cinematic1Button.MouseButton1Click:Connect(function()
    pcall(function()
        local function makecoollightningYOOOOOOOOOOOOOOOOOOOOOOOOOOOOO()
            local ass = Instance.new("Clouds", workspace.Terrain)
            ass.Cover = 0.662
            ass.Density = 0.7
            ass.Color = Color3.fromRGB(8,8,8)
            game.Lighting.Ambient = Color3.new()
            game.Lighting.ColorShift_Bottom = Color3.new()
            game.Lighting.ColorShift_Top = Color3.new()
            game.Lighting.OutdoorAmbient = Color3.fromRGB(77,77,77)
            game.Lighting.LightingStyle = "Realistic"
            game.Lighting.ClockTime = 6.2
            game.Lighting.GeographicLatitude = 272
            game.Lighting.FogEnd = 1e8
            game.Lighting.ColorCorrection.Enabled = false
        end
        makecoollightningYOOOOOOOOOOOOOOOOOOOOOOOOOOOOO()
        
        ResultText.Text = "Cinematic 1 Applied\nDark Clouds & Moody Lighting Activated"
    end)
end)

-- Cinematic 2 Effect
Cinematic2Button.MouseButton1Click:Connect(function()
    pcall(function()
        local light = game.Lighting
        for i, v in pairs(light:GetChildren()) do
            v:Destroy()
        end

        local ter = workspace.Terrain
        local color = Instance.new("ColorCorrectionEffect")
        local bloom = Instance.new("BloomEffect")
        local sun = Instance.new("SunRaysEffect")
        local blur = Instance.new("BlurEffect")

        color.Parent = light
        bloom.Parent = light
        sun.Parent = light
        blur.Parent = light

        -- enable or disable shit

        local config = {

            Terrain = true;
            ColorCorrection = true;
            Sun = true;
            Lighting = true;
            BloomEffect = true;
            
        }

        -- settings {

        color.Enabled = false
        color.Contrast = 0.15
        color.Brightness = 0.1
        color.Saturation = 0.25
        color.TintColor = Color3.fromRGB(255, 222, 211)

        bloom.Enabled = false
        bloom.Intensity = 0.1

        sun.Enabled = false
        sun.Intensity = 0.2
        sun.Spread = 1

        bloom.Enabled = false
        bloom.Intensity = 0.05
        bloom.Size = 32
        bloom.Threshold = 1

        blur.Enabled = false
        blur.Size = 6

        -- settings }


        if config.ColorCorrection then
            color.Enabled = true
        end


        if config.Sun then
            sun.Enabled = true
        end


        if config.Terrain then
            -- settings {
            ter.WaterColor = Color3.fromRGB(10, 10, 24)
            ter.WaterWaveSize = 0.15
            ter.WaterWaveSpeed = 22
            ter.WaterTransparency = 1
            ter.WaterReflectance = 0.05
            -- settings }
        end


        if config.Lighting then
            -- settings {
            light.Ambient = Color3.fromRGB(0, 0, 0)
            light.Brightness = 4
            light.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
            light.ColorShift_Top = Color3.fromRGB(0, 0, 0)
            light.ExposureCompensation = 0
            light.FogColor = Color3.fromRGB(132, 132, 132)
            light.GlobalShadows = true
            light.OutdoorAmbient = Color3.fromRGB(112, 117, 128)
            light.Outlines = false
            -- settings }
        end



        game:GetService("MaterialService")["Use2022Materials"] = true
        
        ResultText.Text = "Cinematic 2 Applied\nAdvanced Lighting & Terrain Effects"
    end)
end)

-- ================= REST OF THE FUNCTIONALITY ==================

-- UI Dragging System
local dragging = false
local dragStart = Vector2.new(0, 0)
local frameStart = Vector2.new(0, 0)

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = Vector2.new(input.Position.X, input.Position.Y)
        frameStart = Vector2.new(Frame.Position.X.Offset, Frame.Position.Y.Offset)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
        Frame.Position = UDim2.new(0, frameStart.X + delta.X, 0, frameStart.Y + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Time Slider System
local timeDragging = false
TimeSliderThumb.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        timeDragging = true
        TimeSliderThumb.BackgroundColor3 = Color3.fromRGB(130, 180, 255)
    end
end)

TimeSliderBackground.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mouse = UserInputService:GetMouseLocation()
        local x = mouse.X - TimeSliderBackground.AbsolutePosition.X
        local percent = math.clamp(x / TimeSliderBackground.AbsoluteSize.X, 0, 1)
        TimeSliderThumb.Position = UDim2.new(percent, -7.5, 0, -2.5)
        updateTime(percent)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if timeDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mouse = UserInputService:GetMouseLocation()
        local x = mouse.X - TimeSliderBackground.AbsolutePosition.X
        local percent = math.clamp(x / TimeSliderBackground.AbsoluteSize.X, 0, 1)
        TimeSliderThumb.Position = UDim2.new(percent, -7.5, 0, -2.5)
        updateTime(percent)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if timeDragging then
            timeDragging = false
            TimeSliderThumb.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        end
    end
end)

function updateTime(percent)
    local hour = math.floor(percent * 24)
    local minute = math.floor((percent * 24 * 60) % 60)
    local time = hour + (minute / 60)
    
    Lighting.ClockTime = time
    
    local timeName = "Day"
    if hour >= 5 and hour < 12 then timeName = "Morning"
    elseif hour >= 12 and hour < 17 then timeName = "Day"
    elseif hour >= 17 and hour < 20 then timeName = "Evening"
    else timeName = "Night" end
    
    TimeDisplay.Text = string.format("Time: %02d:%02d (%s)", hour, minute, timeName)
end

-- Bokeh System
local bokehDragging = false
BokehSliderThumb.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        bokehDragging = true
        BokehSliderThumb.BackgroundColor3 = Color3.fromRGB(220, 140, 220)
    end
end)

BokehSliderBackground.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mouse = UserInputService:GetMouseLocation()
        local x = mouse.X - BokehSliderBackground.AbsolutePosition.X
        local percent = math.clamp(x / BokehSliderBackground.AbsoluteSize.X, 0, 1)
        BokehSliderThumb.Position = UDim2.new(percent, -7.5, 0, -2.5)
        updateBokehIntensity(percent)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if bokehDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mouse = UserInputService:GetMouseLocation()
        local x = mouse.X - BokehSliderBackground.AbsolutePosition.X
        local percent = math.clamp(x / BokehSliderBackground.AbsoluteSize.X, 0, 1)
        BokehSliderThumb.Position = UDim2.new(percent, -7.5, 0, -2.5)
        updateBokehIntensity(percent)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if bokehDragging then
            bokehDragging = false
            BokehSliderThumb.BackgroundColor3 = Color3.fromRGB(200, 100, 200)
        end
    end
end)

function updateBokehIntensity(value)
    BokehIntensity = value
    BokehIntensityDisplay.Text = string.format("Intensity: %.2f", value)
    
    if CurrentDepthOfField then
        CurrentDepthOfField.FarIntensity = value
    end
end

BokehToggleButton.MouseButton1Click:Connect(function()
    BokehEnabled = not BokehEnabled
    
    if BokehEnabled then
        BokehToggleButton.BackgroundColor3 = Color3.fromRGB(220, 120, 220)
        BokehToggleButton.Text = "BOKEH: ON"
        
        CurrentDepthOfField = Instance.new("DepthOfFieldEffect")
        CurrentDepthOfField.Name = "GANDAX_Bokeh"
        CurrentDepthOfField.Enabled = true
        CurrentDepthOfField.FarIntensity = BokehIntensity
        CurrentDepthOfField.InFocusRadius = 50
        CurrentDepthOfField.NearIntensity = 0
        CurrentDepthOfField.Parent = Lighting
        
        ResultText.Text = "Bokeh Effect ON - Intensity: " .. string.format("%.2f", BokehIntensity)
    else
        BokehToggleButton.BackgroundColor3 = Color3.fromRGB(180, 80, 180)
        BokehToggleButton.Text = "BOKEH: OFF"
        
        if CurrentDepthOfField then
            CurrentDepthOfField:Destroy()
            CurrentDepthOfField = nil
        end
        
        ResultText.Text = "Bokeh Effect OFF"
    end
end)

-- Click TP System
ClickTPButton.MouseButton1Click:Connect(function()
    ClickTPEnabled = not ClickTPEnabled
    
    if ClickTPEnabled then
        ClickTPButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        ClickTPButton.Text = "TP ACTIVE (Ctrl)"
        ResultText.Text = "Click TP ACTIVE\nHold Ctrl + Click to teleport"
    else
        ClickTPButton.BackgroundColor3 = Color3.fromRGB(80, 160, 80)
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

-- Anti-AFK System
AntiAFKButton.MouseButton1Click:Connect(function()
    AntiAFKEnabled = not AntiAFKEnabled
    
    if AntiAFKEnabled then
        AntiAFKButton.BackgroundColor3 = Color3.fromRGB(220, 100, 220)
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
        AntiAFKButton.BackgroundColor3 = Color3.fromRGB(180, 80, 180)
        AntiAFKButton.Text = "ANTI-AFK"
        ResultText.Text = "Anti-AFK INACTIVE"
    end
end)

-- Weather Control Functions
RemoveAtmosButton.MouseButton1Click:Connect(function()
    RemoveAtmosButton.Text = "CLEANING..."
    RemoveAtmosButton.BackgroundColor3 = Color3.fromRGB(120, 160, 220)
    
    local count = 0
    for _, obj in pairs(Lighting:GetChildren()) do
        if obj:IsA("Atmosphere") then
            obj:Destroy()
            count = count + 1
        end
    end
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Atmosphere") then
            obj:Destroy()
            count = count + 1
        end
    end
    
    wait(0.3)
    RemoveAtmosButton.Text = "REMOVE ATMOSPHERE"
    RemoveAtmosButton.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
    ResultText.Text = string.format("Removed %d atmosphere effects", count)
end)

RemoveParticlesButton.MouseButton1Click:Connect(function()
    RemoveParticlesButton.Text = "CLEANING..."
    RemoveParticlesButton.BackgroundColor3 = Color3.fromRGB(220, 140, 100)
    
    local count = 0
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") then
            obj:Destroy()
            count = count + 1
        end
    end
    
    wait(0.3)
    RemoveParticlesButton.Text = "REMOVE PARTICLES"
    RemoveParticlesButton.BackgroundColor3 = Color3.fromRGB(200, 120, 80)
    ResultText.Text = string.format("Removed %d particle effects", count)
end)

-- Initialize
updateTime(0.5)
updateBokehIntensity(0.5)

print("========================================")
print("GANDAX 2.4.2 - MINIMIZE FIX & UI IMPROVEMENTS")
print("========================================")
print("FIXED ISSUES:")
print("1. ✓ Minimize system completely fixed")
print("2. ✓ Logo GX now has better design with effects")
print("3. ✓ Logo click properly restores UI")
print("4. ✓ Added Cinematic 1 & 2 effects")
print("5. ✓ All other features remain functional")
print("========================================")
