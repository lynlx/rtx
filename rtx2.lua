--========================================================--
--  RTX HD MENU (REALISTIC VERSION)                       --
--  By ChatGPT (Revised)                                  --
--========================================================--

-- GUI SETUP ------------------------------------------------

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RTX_HD_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 320, 0, 370)
Frame.Position = UDim2.new(0.35, 0, 0.25, 0)     -- lebih ke tengah
Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,38)
Title.BackgroundColor3 = Color3.fromRGB(35,35,35)
Title.BorderSizePixel = 0
Title.Text = "RTX HD Mod Menu"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextSize = 18
Title.Parent = Frame

-- MINIMIZE BUTTON ------------------------------------------

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0,40,0,30)
MinBtn.Position = UDim2.new(1,-45,0,4)
MinBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
MinBtn.Text = "_"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.TextSize = 20
MinBtn.Parent = Frame

local minimized = false
MinBtn.MouseButton1Down:Connect(function()
    minimized = not minimized
    for _,v in ipairs(Frame:GetChildren()) do
        if v ~= Title and v ~= MinBtn then
            v.Visible = not minimized
        end
    end
    Frame.Size = minimized and UDim2.new(0,320,0,38) or UDim2.new(0,320,0,370)
end)

-- HOTKEY N --------------------------------------------------

game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.N then
        Frame.Visible = not Frame.Visible
    end
end)

-- TAB BUTTONS ----------------------------------------------

local Tabs = Instance.new("Folder", Frame)
local function MakeTabButton(name, order)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 32)
    b.Position = UDim2.new(0, 10, 0, 45 + (order*35))
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 15
    b.Text = name
    b.Parent = Tabs
    return b
end

local ultraHD   = MakeTabButton("Ultra HD Enhancement", 0)
local wetFloor  = MakeTabButton("Wet Floor Reflection", 1)
local waterHD   = MakeTabButton("High Quality Water", 2)

-- EFFECT LOGIC ---------------------------------------------

-- ULTRA HD (bukan bloom lebay, tapi tone + sharpen)
local Lighting = game:GetService("Lighting")

local function ApplyUltraHD()
    Lighting.Brightness = 3
    Lighting.Contrast = 0.25
    Lighting.ExposureCompensation = 0.2
    Lighting.Ambient = Color3.fromRGB(90,90,90)
    Lighting.OutdoorAmbient = Color3.fromRGB(120,120,120)

    -- Rost Shader Fake AO
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Name = "HD_CC"
    cc.TintColor = Color3.fromRGB(255,255,255)
    cc.Saturation = 0.15
    cc.Contrast = 0.2
    cc.Parent = Lighting

    local sharp = Instance.new("ColorCorrectionEffect")
    sharp.Name = "HD_Sharpen"
    sharp.Contrast = 0.3
    sharp.Parent = Lighting
end

ultraHD.MouseButton1Down:Connect(ApplyUltraHD)

--------------------------------------------------------------
-- WET FLOOR (fake reflection plane + specular trick)
--------------------------------------------------------------

local function ApplyWetFloor()
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Position.Y < 3 then
            local clone = Instance.new("Part")
            clone.Size = part.Size
            clone.CFrame = part.CFrame * CFrame.new(0, 0.02, 0)
            clone.Transparency = 0.55
            clone.Color = Color3.fromRGB(180,180,180)
            clone.Material = Enum.Material.SmoothPlastic
            clone.Reflectance = 0.45
            clone.Anchored = true
            clone.CanCollide = false
            clone.Name = "WetReflection"
            clone.Parent = workspace
        end
    end
end

wetFloor.MouseButton1Down:Connect(ApplyWetFloor)

--------------------------------------------------------------
-- HQ WATER (real Roblox settings)
--------------------------------------------------------------

local function ApplyWaterHD()
    Lighting.EnvironmentSpecularScale = 1
    Lighting.EnvironmentDiffuseScale = 0.5
    Lighting.ReflectionIntensity = 1

    local t = workspace.Terrain
    t.WaterTransparency = 0.08
    t.WaterReflectance = 1
    t.WaterWaveSize = 0.1
    t.WaterWaveSpeed = 6
end

waterHD.MouseButton1Down:Connect(ApplyWaterHD)

--========================================================--
--  END SCRIPT                                             --
--========================================================--
