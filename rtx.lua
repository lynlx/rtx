--[[
    WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
-- RTX v2 Mod Menu - Full Script (Enhanced: minimize, close, tabs, HD water/floor/boost)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RTXv2MenuGui"
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame (movable, resizable)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 280)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.new(0, 0, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true

-- Title
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, -80, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "RTX v2 Mod Menu"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextStrokeTransparency = 0.7
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.Position = UDim2.new(0, 0, 0, 0)

-- Top buttons container (minimize + close)
local TopButtons = Instance.new("Frame")
TopButtons.Parent = MainFrame
TopButtons.Size = UDim2.new(0, 80, 0, 40)
TopButtons.Position = UDim2.new(1, -80, 0, 0)
TopButtons.BackgroundTransparency = 1

local function makeTopButton(parent, size, pos, txt)
    local b = Instance.new("TextButton")
    b.Parent = parent
    b.Size = size
    b.Position = pos
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Text = txt
    b.Font = Enum.Font.GothamBold
    b.TextSize = 20
    b.BorderSizePixel = 0
    return b
end

local MinBtn = makeTopButton(TopButtons, UDim2.new(0,40,0,40), UDim2.new(0,0,0,0), "-")
local CloseBtn = makeTopButton(TopButtons, UDim2.new(0,40,0,40), UDim2.new(0,40,0,0), "X")

-- Small restore icon (shown when minimized) (pojok kiri bawah)
local RestoreIcon = Instance.new("TextButton")
RestoreIcon.Parent = ScreenGui
RestoreIcon.Size = UDim2.new(0, 80, 0, 30)
RestoreIcon.Position = UDim2.new(0, 10, 1, -40)
RestoreIcon.AnchorPoint = Vector2.new(0,1)
RestoreIcon.Text = "RTX Menu"
RestoreIcon.Font = Enum.Font.GothamSemibold
RestoreIcon.TextSize = 16
RestoreIcon.BackgroundColor3 = Color3.fromRGB(35,35,35)
RestoreIcon.BorderSizePixel = 0
RestoreIcon.Visible = false
RestoreIcon.ZIndex = 50

-- Tab buttons (Graphics / Advanced)
local TabBar = Instance.new("Frame")
TabBar.Parent = MainFrame
TabBar.Size = UDim2.new(1, -20, 0, 36)
TabBar.Position = UDim2.new(0, 10, 0, 44)
TabBar.BackgroundTransparency = 1

local function makeTab(name, pos)
    local t = Instance.new("TextButton")
    t.Parent = TabBar
    t.Size = UDim2.new(0, 140, 1, 0)
    t.Position = pos
    t.Text = name
    t.Font = Enum.Font.GothamSemibold
    t.TextSize = 16
    t.BackgroundColor3 = Color3.fromRGB(40,40,40)
    t.TextColor3 = Color3.fromRGB(220,220,220)
    t.BorderSizePixel = 0
    return t
end

local TabGraphics = makeTab("Graphics", UDim2.new(0, 0, 0, 0))
local TabAdvanced = makeTab("Advanced", UDim2.new(0, 150, 0, 0))

-- Container for mods buttons (Graphics tab)
local ModsContainer = Instance.new("ScrollingFrame")
ModsContainer.Parent = MainFrame
ModsContainer.Position = UDim2.new(0, 10, 0, 84)
ModsContainer.Size = UDim2.new(1, -20, 1, -100)
ModsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ModsContainer.BackgroundTransparency = 1
ModsContainer.ScrollBarThickness = 5
ModsContainer.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
ModsContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y

-- Advanced container (hidden by default)
local AdvancedContainer = Instance.new("ScrollingFrame")
AdvancedContainer.Parent = MainFrame
AdvancedContainer.Position = ModsContainer.Position
AdvancedContainer.Size = ModsContainer.Size
AdvancedContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
AdvancedContainer.BackgroundTransparency = 1
AdvancedContainer.ScrollBarThickness = 5
AdvancedContainer.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
AdvancedContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
AdvancedContainer.Visible = false

-- UIListLayout for containers
local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = ModsContainer
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 10)

local ListLayout2 = Instance.new("UIListLayout")
ListLayout2.Parent = AdvancedContainer
ListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout2.Padding = UDim.new(0, 10)

-- Helper: Create Toggle Button
local function CreateToggle(name, defaultState, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Button.BorderSizePixel = 0
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.GothamSemibold
    Button.TextSize = 18
    Button.Text = name .. ": OFF"

    local toggled = defaultState
    local function UpdateText()
        if toggled then
            Button.Text = name .. ": ON"
            Button.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
        else
            Button.Text = name .. ": OFF"
            Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        end
    end

    Button.MouseButton1Click:Connect(function()
        toggled = not toggled
        UpdateText()
        callback(toggled)
    end)

    UpdateText()
    return Button, function() return toggled end
end

-- Store references for effects so we can toggle
local SunRays, Bloom, ColorCorrection, DepthOfField
local originalLighting = {
    EnvironmentSpecularScale = Lighting:FindFirstChild("EnvironmentSpecularScale") and Lighting.EnvironmentSpecularScale or Lighting.EnvironmentSpecularScale,
    EnvironmentDiffuseScale = Lighting:FindFirstChild("EnvironmentDiffuseScale") and Lighting.EnvironmentDiffuseScale or Lighting.EnvironmentDiffuseScale,
    Brightness = Lighting.Brightness,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
}

-- Keep track of parts reflectance changed for 'wet floor'
local originalReflectance = {}
local wetFloorApplied = false

-- RTX v2 base toggles (same as before)
local function ToggleShadows(enabled)
    Lighting.GlobalShadows = enabled
    if enabled then
        Lighting.Ambient = Color3.fromRGB(50, 50, 50)
        Lighting.OutdoorAmbient = Color3.fromRGB(100, 100, 100)
    else
        Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
end

local function ToggleColorCorrection(enabled)
    if enabled then
        if not ColorCorrection then
            ColorCorrection = Instance.new("ColorCorrectionEffect")
            ColorCorrection.Brightness = 0.05
            ColorCorrection.Contrast = 0.3
            ColorCorrection.Saturation = 0.5
            ColorCorrection.TintColor = Color3.fromRGB(235, 235, 235)
            ColorCorrection.Name = "RTXv2ColorCorrection"
            ColorCorrection.Parent = Lighting
        end
    else
        if ColorCorrection then
            ColorCorrection:Destroy()
            ColorCorrection = nil
        end
    end
end

local function ToggleBloom(enabled)
    if enabled then
        if not Bloom then
            Bloom = Instance.new("BloomEffect")
            Bloom.Intensity = 1.5
            Bloom.Size = 50
            Bloom.Threshold = 0.7
            Bloom.Name = "RTXv2Bloom"
            Bloom.Parent = Lighting
        end
    else
        if Bloom then
            Bloom:Destroy()
            Bloom = nil
        end
    end
end

local function ToggleSunRays(enabled)
    if enabled then
        if not SunRays then
            SunRays = Instance.new("SunRaysEffect")
            SunRays.Intensity = 0.2
            SunRays.Spread = 0.3
            SunRays.Name = "RTXv2SunRays"
            SunRays.Parent = Lighting
        end
    else
        if SunRays then
            SunRays:Destroy()
            SunRays = nil
        end
    end
end

local function ToggleDOF(enabled)
    if enabled then
        if not DepthOfField then
            DepthOfField = Instance.new("DepthOfFieldEffect")
            DepthOfField.FocusDistance = 30
            DepthOfField.InFocusRadius = 15
            DepthOfField.NearIntensity = 0.3
            DepthOfField.FarIntensity = 0.5
            DepthOfField.Name = "RTXv2DOF"
            DepthOfField.Parent = Lighting
        end
    else
        if DepthOfField then
            DepthOfField:Destroy()
            DepthOfField = nil
        end
    end
end

-- New: High Quality Water (uses Terrain water properties)
local Terrain = Workspace:FindFirstChildOfClass("Terrain")
local waterOriginal = {}
if Terrain then
    waterOriginal.WaterReflectance = Terrain.WaterReflectance
    waterOriginal.WaterTransparency = Terrain.WaterTransparency
    waterOriginal.WaterColor = Terrain.WaterColor
end

local function ToggleHighQualityWater(enabled)
    if not Terrain then return end
    if enabled then
        -- stronger reflections, clearer water (tweak as needed)
        Terrain.WaterReflectance = 1         -- full reflection
        Terrain.WaterTransparency = 0.2      -- less transparent so reflection visible
        Terrain.WaterColor = Color3.fromRGB(200,210,230)
    else
        -- restore
        Terrain.WaterReflectance = waterOriginal.WaterReflectance
        Terrain.WaterTransparency = waterOriginal.WaterTransparency
        Terrain.WaterColor = waterOriginal.WaterColor
    end
end

-- New: Wet Floor / Floor reflections (increase BasePart.Reflectance for candidate floor parts)
local function ApplyWetFloor(enabled)
    if wetFloorApplied == enabled then return end
    wetFloorApplied = enabled
    if enabled then
        -- scan for parts that look like floors (heuristic to avoid touching everything)
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj:IsDescendantOf(Terrain) then
                -- heuristic: wide and thin parts or name contains floor/ground
                local isFloor = false
                local n = obj.Name:lower()
                if n:find("floor") or n:find("ground") or n:find("road") or n:find("pavement") then
                    isFloor = true
                elseif obj.Size and obj.Size.Y and obj.Size.Y <= 2 and (obj.Size.X > 4 or obj.Size.Z > 4) then
                    isFloor = true
                end

                if isFloor then
                    originalReflectance[obj] = obj.Reflectance
                    -- set to higher reflectance for wet look (clamped)
                    obj.Reflectance = math.clamp((obj.Reflectance or 0) + 0.6, 0, 1)
                end
            end
        end
    else
        -- restore original reflectance (if still exist)
        for part, val in pairs(originalReflectance) do
            if part and part.Parent then
                part.Reflectance = val
            end
            originalReflectance[part] = nil
        end
    end
end

-- New: Ultra HD Boost (combined lighting tweaks)
local ultraHDBloom, ultraHDColorCorrection
local ultraHDEnabled = false

local function ToggleUltraHD(enabled)
    if enabled == ultraHDEnabled then return end
    ultraHDEnabled = enabled
    if enabled then
        -- store original if not already
        originalLighting.Brightness = Lighting.Brightness
        originalLighting.EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale
        originalLighting.EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale
        -- stronger specular/diffuse to simulate richer reflections
        Lighting.EnvironmentSpecularScale = 2
        Lighting.EnvironmentDiffuseScale = 1.2
        Lighting.Brightness = math.clamp(Lighting.Brightness + 0.15, 0, 2)

        if not ultraHDBloom then
            ultraHDBloom = Instance.new("BloomEffect")
            ultraHDBloom.Intensity = 1.8
            ultraHDBloom.Size = 60
            ultraHDBloom.Threshold = 0.65
            ultraHDBloom.Name = "RTXv2UltraBloom"
            ultraHDBloom.Parent = Lighting
        end

        if not ultraHDColorCorrection then
            ultraHDColorCorrection = Instance.new("ColorCorrectionEffect")
            ultraHDColorCorrection.Brightness = 0.06
            ultraHDColorCorrection.Contrast = 0.35
            ultraHDColorCorrection.Saturation = 0.6
            ultraHDColorCorrection.TintColor = Color3.fromRGB(240,240,245)
            ultraHDColorCorrection.Name = "RTXv2UltraColor"
            ultraHDColorCorrection.Parent = Lighting
        end
    else
        -- restore
        Lighting.EnvironmentSpecularScale = originalLighting.EnvironmentSpecularScale or 1
        Lighting.EnvironmentDiffuseScale = originalLighting.EnvironmentDiffuseScale or 1
        Lighting.Brightness = originalLighting.Brightness or 1

        if ultraHDBloom then
            ultraHDBloom:Destroy()
            ultraHDBloom = nil
        end
        if ultraHDColorCorrection then
            ultraHDColorCorrection:Destroy()
            ultraHDColorCorrection = nil
        end
    end
end

-- Add toggles to menu (Graphics)
local toggles = {
    {name = "Realistic Shadows", func = ToggleShadows},
    {name = "Color Correction", func = ToggleColorCorrection},
    {name = "Bloom Effect", func = ToggleBloom},
    {name = "Sun Rays", func = ToggleSunRays},
    {name = "Depth of Field", func = ToggleDOF},
}

for _, toggleData in ipairs(toggles) do
    local btn = CreateToggle(toggleData.name, false, toggleData.func)
    btn.Parent = ModsContainer
end

-- Add new high-quality options to Graphics
local waterBtn = CreateToggle("High Quality Water (reflections)", false, ToggleHighQualityWater)
waterBtn.Parent = ModsContainer

local floorBtn = CreateToggle("Wet Floor (floor reflections)", false, function(state) ApplyWetFloor(state) end)
floorBtn.Parent = ModsContainer

local ultraBtn = CreateToggle("Ultra HD Boost (specular+color)", false, ToggleUltraHD)
ultraBtn.Parent = ModsContainer

-- Advanced tab toggles (examples)
local advExampleBtn = CreateToggle("Verbose Debug Info (dev)", false, function(s) end)
advExampleBtn.Parent = AdvancedContainer

-- Make menu resizable
local UIS = game:GetService("UserInputService")
local Resizing = false
local ResizeStart = nil
local ResizeStartSize = nil

local resizeCorner = Instance.new("Frame")
resizeCorner.Name = "ResizeCorner"
resizeCorner.Size = UDim2.new(0, 20, 0, 20)
resizeCorner.Position = UDim2.new(1, -20, 1, -20)
resizeCorner.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
resizeCorner.BorderSizePixel = 0
resizeCorner.Parent = MainFrame
resizeCorner.ZIndex = 10
resizeCorner.Cursor = "SizeNWSE"

resizeCorner.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Resizing = true
        ResizeStart = input.Position
        ResizeStartSize = MainFrame.Size
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Resizing = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if Resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - ResizeStart
        local newWidth = math.clamp(ResizeStartSize.X.Offset + delta.X, 200, 900)
        local newHeight = math.clamp(ResizeStartSize.Y.Offset + delta.Y, 150, 800)
        MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end)

-- Minimize / Close behavior with tween fade
local Minimized = false
local normalSize = MainFrame.Size

local function FadeOutGui(gui, time)
    TweenService:Create(gui, TweenInfo.new(time or 0.25), {BackgroundTransparency = 1}):Play()
    for _, c in ipairs(gui:GetDescendants()) do
        if c:IsA("GuiObject") and c ~= RestoreIcon then
            pcall(function()
                TweenService:Create(c, TweenInfo.new(time or 0.25), {ImageTransparency = 1, TextTransparency = 1, BackgroundTransparency = 1}):Play()
            end)
        end
    end
end

local function FadeInGui(gui, time)
    TweenService:Create(gui, TweenInfo.new(time or 0.25), {BackgroundTransparency = 0}):Play()
    for _, c in ipairs(gui:GetDescendants()) do
        if c:IsA("GuiObject") and c ~= RestoreIcon then
            pcall(function()
                TweenService:Create(c, TweenInfo.new(time or 0.25), {ImageTransparency = 0, TextTransparency = 0, BackgroundTransparency = 0}):Play()
            end)
        end
    end
end

local function UpdateMinimizeState(instant)
    if Minimized then
        -- animate shrink + fade, hide inner containers
        local t = TweenInfo.new(0.22)
        TweenService:Create(MainFrame, t, {Size = UDim2.new(0, 160, 0, 40), Position = UDim2.new(0, 10, 0, 10)}):Play()
        ModsContainer.Visible = false
        AdvancedContainer.Visible = false
        TabBar.Visible = false
        resizeCorner.Visible = false
        -- fade Title only for polish
        Title.TextTransparency = 0.1
        MinBtn.Text = "+"
        -- show restore icon
        RestoreIcon.Visible = true
    else
        -- restore to previous
        local t = TweenInfo.new(0.22)
        TweenService:Create(MainFrame, t, {Size = normalSize, Position = UDim2.new(0.5, -normalSize.X.Offset/2, 0.5, -normalSize.Y.Offset/2)}):Play()
        TabBar.Visible = true
        ModsContainer.Visible = (TabGraphics.BackgroundColor3 == TabGraphics.BackgroundColor3) -- will set below
        resizeCorner.Visible = true
        MinBtn.Text = "-"
        RestoreIcon.Visible = false
    end
end

MinBtn.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    UpdateMinimizeState()
end)

CloseBtn.MouseButton1Click:Connect(function()
    -- close: destroy GUI, also restore any changed values
    ApplyWetFloor(false)
    ToggleHighQualityWater(false)
    ToggleUltraHD(false)
    if ScreenGui then
        ScreenGui:Destroy()
    end
end)

RestoreIcon.MouseButton1Click:Connect(function()
    Minimized = false
    UpdateMinimizeState()
end)

-- Shortcut Key "N" (toggle minimize / restore)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.N then
        Minimized = not Minimized
        UpdateMinimizeState()
    end
end)

-- Tab switching logic (simple visual feedback)
local function selectTab(tabName)
    if tabName == "Graphics" then
        ModsContainer.Visible = true
        AdvancedContainer.Visible = false
        TabGraphics.BackgroundColor3 = Color3.fromRGB(60,60,60)
        TabAdvanced.BackgroundColor3 = Color3.fromRGB(40,40,40)
    else
        ModsContainer.Visible = false
        AdvancedContainer.Visible = true
        TabGraphics.BackgroundColor3 = Color3.fromRGB(40,40,40)
        TabAdvanced.BackgroundColor3 = Color3.fromRGB(60,60,60)
    end
end

TabGraphics.MouseButton1Click:Connect(function() selectTab("Graphics") end)
TabAdvanced.MouseButton1Click:Connect(function() selectTab("Advanced") end)

-- initial tab selection
selectTab("Graphics")

-- Show menu
ScreenGui.Enabled = true
