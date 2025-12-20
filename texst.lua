--[[
    ██╗   ██╗██╗   ██╗██████╗ ███████╗██████╗     ██╗   ██╗██╗    ██╗   ██╗██╗  ██╗
    ██║   ██║╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗    ██║   ██║██║    ██║   ██║██║  ██║
    ██║   ██║ ╚████╔╝ ██████╔╝█████╗  ██████╔╝    ██║   ██║██║    ██║   ██║███████║
    ╚██╗ ██╔╝  ╚██╔╝  ██╔═══╝ ██╔══╝  ██╔══██╗    ██║   ██║██║    ╚██╗ ██╔╝╚════██║
     ╚████╔╝    ██║   ██║     ███████╗██║  ██║    ╚██████╔╝██║     ╚████╔╝      ██║
      ╚═══╝     ╚═╝   ╚═╝     ╚══════╝╚═╝  ╚═╝     ╚═════╝ ╚═╝      ╚═══╝       ╚═╝
    
    VyperUI V4.0 FINAL - Delta Executor Edition
    Ultra-Modern Responsive UI Library
    
    Author: yeremiaginting059
    Version: 4.0.0 - FINAL RELEASE
    
    ✨ NEW FEATURES V4.0:
    ✓ 100% Responsive UI - Auto-scaling untuk semua device
    ✓ Modern Topbar - Glassmorphic design dengan gradient neon
    ✓ Hide/Show Toggle - Button di tengah topbar dengan smooth animation
    ✓ Collapsible Sidebar - Slide untuk minimize/maximize
    ✓ Minimize to Logo - Window minimize jadi draggable logo di kiri bawah
    ✓ Logo Integration - Logo VyperUI dari GitLab
    ✓ Smooth Animations - Spring, fade, bounce effects untuk semua interaksi
    ✓ Delta Executor Compatible - Tested untuk drag, resize, slider, touch
    ✓ Mobile Optimized - Full touch support untuk mobile devices
]]

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- ========================================
-- RESPONSIVE SCREEN DETECTION (ROBUST INITIALIZATION)
-- ========================================

local Camera = workspace.CurrentCamera
local ScreenSize = Vector2.new(1920, 1080)
local IsMobile = false
local IsTablet = false
local IsDesktop = true

local function initializeCamera()
    local attempts = 0
    local maxAttempts = 100
    
    while not Camera and attempts < maxAttempts do
        Camera = workspace.CurrentCamera
        if not Camera then
            local success = pcall(function()
                task.wait(0.05)
            end)
            if not success then
                wait(0.05)
            end
        end
        attempts = attempts + 1
    end
    
    if Camera then
        ScreenSize = Camera.ViewportSize or Vector2.new(1920, 1080)
        IsMobile = ScreenSize.X < 800
        IsTablet = ScreenSize.X >= 800 and ScreenSize.X < 1200
        IsDesktop = ScreenSize.X >= 1200
    end
end

initializeCamera()

local function updateResponsiveMetrics()
    if Camera and Camera.Parent then
        pcall(function()
            ScreenSize = Camera.ViewportSize or ScreenSize
            IsMobile = ScreenSize.X < 800
            IsTablet = ScreenSize.X >= 800 and ScreenSize.X < 1200
            IsDesktop = ScreenSize.X >= 1200
        end)
    end
end

pcall(function()
    if Camera then
        Camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateResponsiveMetrics)
    end
end)

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = workspace.CurrentCamera
    if Camera then
        updateResponsiveMetrics()
        pcall(function()
            Camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateResponsiveMetrics)
        end)
    end
end)

-- ========================================
-- MODERN GLASSMORPHIC THEME V4.0
-- ========================================

local Theme = {
    Colors = {
        NeonPurple = Color3.fromRGB(138, 43, 226),
        NeonCyan = Color3.fromRGB(0, 255, 255),
        NeonPink = Color3.fromRGB(255, 20, 147),
        NeonBlue = Color3.fromRGB(64, 156, 255),
        NeonGreen = Color3.fromRGB(57, 255, 20),
        
        GlassLight = Color3.fromRGB(255, 255, 255),
        GlassDark = Color3.fromRGB(15, 15, 25),
        GlassMid = Color3.fromRGB(25, 25, 40),
        
        Background = Color3.fromRGB(10, 10, 18),
        BackgroundSecondary = Color3.fromRGB(15, 15, 25),
        Surface = Color3.fromRGB(20, 20, 32),
        SurfaceLight = Color3.fromRGB(30, 30, 48),
        
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 200),
        TextTertiary = Color3.fromRGB(120, 120, 140),
        TextDisabled = Color3.fromRGB(80, 80, 100),
        
        AccentPrimary = Color3.fromRGB(138, 43, 226),
        AccentSecondary = Color3.fromRGB(64, 156, 255),
        AccentTertiary = Color3.fromRGB(255, 20, 147),
        
        Success = Color3.fromRGB(57, 255, 20),
        Warning = Color3.fromRGB(255, 193, 7),
        Error = Color3.fromRGB(244, 67, 54),
        Info = Color3.fromRGB(33, 150, 243),
        
        Border = Color3.fromRGB(60, 60, 80),
        BorderLight = Color3.fromRGB(80, 80, 120),
        Shadow = Color3.fromRGB(0, 0, 0),
    },
    
    Transparency = {
        Glass = 0.3,
        GlassHover = 0.2,
        GlassActive = 0.15,
        Overlay = 0.5,
        Shadow = 0.7,
        Disabled = 0.6,
    },
    
    Logo = {
        URL = "rbxassetid://94138995594797",
        DecalID = "rbxassetid://94138995594797",
    },
    
    GetResponsiveSize = function(mobile, tablet, desktop)
        if IsMobile then return mobile end
        if IsTablet then return tablet or desktop end
        return desktop
    end,
}

Theme.Sizes = {
    TopbarHeight = Theme.GetResponsiveSize(45, 55, 60),
    -- SidebarWidth = Theme.GetResponsiveSize(60, 200, 240),
    SidebarWidth = Theme.GetResponsiveSize(60, 150, 180),
    SidebarMinimized = Theme.GetResponsiveSize(50, 65, 70),
    CornerRadius = Theme.GetResponsiveSize(8, 10, 12),
    CornerRadiusSmall = Theme.GetResponsiveSize(6, 7, 8),
    IconSize = Theme.GetResponsiveSize(16, 18, 20),
    AvatarSize = Theme.GetResponsiveSize(28, 32, 36),
    Padding = Theme.GetResponsiveSize(12, 14, 16),
    PaddingSmall = Theme.GetResponsiveSize(6, 7, 8),
    PaddingLarge = Theme.GetResponsiveSize(16, 20, 24),
    Spacing = Theme.GetResponsiveSize(8, 10, 12),
    ButtonHeight = Theme.GetResponsiveSize(40, 45, 50),
    MinimizedLogoSize = Theme.GetResponsiveSize(50, 60, 70),
}

Theme.Fonts = {
    Primary = Enum.Font.GothamBold,
    Secondary = Enum.Font.Gotham,
    Mono = Enum.Font.RobotoMono,
}

Theme.Animations = {
    Fast = 0.15,
    Normal = 0.25,
    Slow = 0.4,
    VerySlow = 0.6,
}

-- ========================================
-- ADVANCED ANIMATION SYSTEM V4.0
-- ========================================

local Animator = {}
Animator.ActiveTweens = {}

function Animator:Tween(instance, props, duration, style, direction, callback)
    if not instance or not instance.Parent then return end

    duration = duration or Theme.Animations.Normal
    style = style or Enum.EasingStyle.Quint
    direction = direction or Enum.EasingDirection.Out

    -- cancel previous tween for this instance if present
    if self.ActiveTweens[instance] then
        pcall(function() self.ActiveTweens[instance]:Cancel() end)
        self.ActiveTweens[instance] = nil
    end

    local tweenInfo = TweenInfo.new(duration, style, direction)
    local stroke = instance:FindFirstChildOfClass("UIStroke")

    -- mapping keys that start with "Stroke" -> actual UIStroke property names
    local strokeMap = {
        StrokeColor = "Color",
        StrokeTransparency = "Transparency",
        StrokeThickness = "Thickness"
    }

    -- we'll collect separate tween targets: one for instance, one for stroke
    local instanceTargets = {}
    local strokeTargets = {}

    for key, value in pairs(props or {}) do
        if key:match("^Stroke") then
            -- map to real stroke property name, if stroke exists
            if stroke then
                local realKey = strokeMap[key] or key:gsub("^Stroke", "")
                -- ensure the stroke actually has that property (best-effort, pcall)
                local ok = pcall(function() return stroke[realKey] end)
                if ok then
                    strokeTargets[realKey] = value
                end
            end
        else
            -- normal property: ensure instance supports it before tween
            local ok = pcall(function() return instance[key] end)
            if ok then
                instanceTargets[key] = value
            end
        end
    end

    -- create tweens for instance and stroke separately
    if next(instanceTargets) then
        local t = TweenService:Create(instance, tweenInfo, instanceTargets)
        self.ActiveTweens[instance] = t
        t:Play()
        if callback then
            t.Completed:Connect(function()
                pcall(callback)
                self.ActiveTweens[instance] = nil
            end)
        end
    end

    if stroke and next(strokeTargets) then
        -- cancel previous stroke tween if any
        if self.ActiveTweens[stroke] then
            pcall(function() self.ActiveTweens[stroke]:Cancel() end)
            self.ActiveTweens[stroke] = nil
        end

        local ts = TweenService:Create(stroke, tweenInfo, strokeTargets)
        self.ActiveTweens[stroke] = ts
        ts:Play()
        -- don't duplicate callback here (already attached to instance tween if present).
        if not next(instanceTargets) and callback then
            ts.Completed:Connect(function()
                pcall(callback)
                self.ActiveTweens[stroke] = nil
            end)
        end
    end

    -- if nothing was tweened but callback exists, call it after duration as fallback
    if not next(instanceTargets) and not (stroke and next(strokeTargets)) and callback then
        task.delay(duration, function()
            pcall(callback)
        end)
    end

    return true
end



function Animator:Spring(instance, props, callback)
    return self:Tween(instance, props, Theme.Animations.Normal, Enum.EasingStyle.Back, Enum.EasingDirection.Out, callback)
end

function Animator:Elastic(instance, props, callback)
    return self:Tween(instance, props, Theme.Animations.Slow, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, callback)
end

function Animator:Bounce(instance, scale)
    if not instance or not instance.Parent then return end
    
    scale = scale or 0.95
    local originalSize = instance.Size
    
    self:Tween(instance, {Size = UDim2.new(
        originalSize.X.Scale * scale,
        originalSize.X.Offset * scale,
        originalSize.Y.Scale * scale,
        originalSize.Y.Offset * scale
    )}, Theme.Animations.Fast, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function()
        self:Spring(instance, {Size = originalSize})
    end)
end

function Animator:Ripple(parent, position, color)
    if not parent or not parent.Parent then return end
    
    color = color or Theme.Colors.AccentPrimary
    
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundColor3 = color
    ripple.BackgroundTransparency = 0.5
    ripple.BorderSizePixel = 0
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0, position.X, 0, position.Y)
    ripple.ZIndex = 10
    ripple.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    local maxSize = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2
    
    self:Tween(ripple, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        BackgroundTransparency = 1
    }, Theme.Animations.Slow, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function()
        ripple:Destroy()
    end)
end

function Animator:Glow(instance, color, intensity)
    if not instance then return nil end
    
    color = color or Theme.Colors.AccentPrimary
    intensity = intensity or 0.5
    
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://6014261993"
    glow.ImageColor3 = color
    glow.ImageTransparency = 1 - intensity
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(49, 49, 450, 450)
    glow.Size = UDim2.new(1, 40, 1, 40)
    glow.Position = UDim2.new(0, -20, 0, -20)
    glow.ZIndex = 0
    glow.Parent = instance
    
    return glow
end

function Animator:PulseGlow(glow, duration)
    if not glow then return end
    
    duration = duration or 2
    
    local function pulse()
        if not glow or not glow.Parent then return end
        
        self:Tween(glow, {ImageTransparency = 0.3}, duration/2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, function()
            if not glow or not glow.Parent then return end
            
            self:Tween(glow, {ImageTransparency = 0.7}, duration/2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, function()
                if glow and glow.Parent then
                    pulse()
                end
            end)
        end)
    end
    
    pulse()
end

function Animator:FadeIn(instance, duration)
    if not instance then return end
    self:Tween(instance, {BackgroundTransparency = 0}, duration or Theme.Animations.Normal)
end

function Animator:FadeOut(instance, duration, callback)
    if not instance then return end
    self:Tween(instance, {BackgroundTransparency = 1}, duration or Theme.Animations.Normal, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, callback)
end

function Animator:SlideIn(instance, direction, duration)
    if not instance then return end
    
    direction = direction or "left"
    duration = duration or Theme.Animations.Normal
    
    local viewport = Camera.ViewportSize
    local startPos
    
    if direction == "left" then
        startPos = UDim2.new(0, -instance.AbsoluteSize.X, instance.Position.Y.Scale, instance.Position.Y.Offset)
    elseif direction == "right" then
        startPos = UDim2.new(0, viewport.X, instance.Position.Y.Scale, instance.Position.Y.Offset)
    elseif direction == "top" then
        startPos = UDim2.new(instance.Position.X.Scale, instance.Position.X.Offset, 0, -instance.AbsoluteSize.Y)
    elseif direction == "bottom" then
        startPos = UDim2.new(instance.Position.X.Scale, instance.Position.X.Offset, 0, viewport.Y)
    end
    
    local endPos = instance.Position
    instance.Position = startPos
    
    self:Spring(instance, {Position = endPos})
end

function Animator:SlideOut(instance, direction, duration, callback)
    if not instance then return end
    
    direction = direction or "left"
    duration = duration or Theme.Animations.Normal
    
    local viewport = Camera.ViewportSize
    local endPos
    
    if direction == "left" then
        endPos = UDim2.new(0, -instance.AbsoluteSize.X, instance.Position.Y.Scale, instance.Position.Y.Offset)
    elseif direction == "right" then
        endPos = UDim2.new(0, viewport.X, instance.Position.Y.Scale, instance.Position.Y.Offset)
    elseif direction == "top" then
        endPos = UDim2.new(instance.Position.X.Scale, instance.Position.X.Offset, 0, -instance.AbsoluteSize.Y)
    elseif direction == "bottom" then
        endPos = UDim2.new(instance.Position.X.Scale, instance.Position.X.Offset, 0, viewport.Y)
    end
    
    self:Tween(instance, {Position = endPos}, duration, Enum.EasingStyle.Quint, Enum.EasingDirection.In, callback)
end

-- ========================================
-- UTILITY FUNCTIONS V4.0
-- ========================================

local Utils = {}

function Utils:CreateElement(className, props)
    local element = Instance.new(className)
    
    for prop, value in pairs(props or {}) do
        if prop ~= "Children" then
            pcall(function() element[prop] = value end)
        end
    end
    
    if props and props.Children then
        for _, child in ipairs(props.Children) do
            child.Parent = element
        end
    end
    
    return element
end

function Utils:CreateGlassFrame(parent, props)
    props = props or {}
    
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = props.Color or Theme.Colors.GlassMid
    frame.BackgroundTransparency = props.Transparency or Theme.Transparency.Glass
    frame.BorderSizePixel = 0
    frame.Size = props.Size or UDim2.new(1, 0, 1, 0)
    frame.Position = props.Position or UDim2.new(0, 0, 0, 0)
    frame.ZIndex = props.ZIndex or 1
    frame.ClipsDescendants = props.ClipsDescendants or false
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, props.CornerRadius or Theme.Sizes.CornerRadius)
    corner.Parent = frame
    
    if props.Stroke ~= false then
        local stroke = Instance.new("UIStroke")
        stroke.Color = props.StrokeColor or Theme.Colors.Border
        stroke.Thickness = props.StrokeThickness or 1
        stroke.Transparency = props.StrokeTransparency or 0.5
        stroke.Parent = frame
    end
    
    if props.Gradient then
        local gradient = Instance.new("UIGradient")
        gradient.Color = props.GradientColors or ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.Colors.NeonPurple),
            ColorSequenceKeypoint.new(0.5, Theme.Colors.NeonCyan),
            ColorSequenceKeypoint.new(1, Theme.Colors.NeonPink)
        })
        gradient.Rotation = props.GradientRotation or 45
        gradient.Parent = frame
    end
    
    return frame
end

function Utils:CreateText(parent, text, props)
    props = props or {}
    
    local label = Instance.new("TextLabel")
    label.Text = text or ""
    label.Font = props.Font or Theme.Fonts.Secondary
    label.TextSize = props.TextSize or Theme.GetResponsiveSize(12, 13, 14)
    label.TextColor3 = props.TextColor or Theme.Colors.TextPrimary
    label.TextTransparency = props.TextTransparency or 0
    label.BackgroundTransparency = 1
    label.Size = props.Size or UDim2.new(1, 0, 1, 0)
    label.Position = props.Position or UDim2.new(0, 0, 0, 0)
    label.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
    label.TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Center
    label.TextWrapped = props.TextWrapped or false
    label.TextScaled = props.TextScaled or false
    label.RichText = props.RichText or false
    label.ZIndex = props.ZIndex or 2
    label.Parent = parent
    
    return label
end

function Utils:CreateIcon(parent, icon, props)
    props = props or {}
    
    return self:CreateText(parent, icon, {
        Font = Theme.Fonts.Primary,
        TextSize = props.Size or Theme.Sizes.IconSize,
        TextColor = props.Color or Theme.Colors.AccentPrimary,
        Size = props.FrameSize or UDim2.new(0, props.Size or Theme.Sizes.IconSize, 0, props.Size or Theme.Sizes.IconSize),
        Position = props.Position,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = props.ZIndex or 3
    })
end

function Utils:CreatePadding(parent, padding)
    local uiPadding = Instance.new("UIPadding")
    
    if type(padding) == "table" then
        uiPadding.PaddingTop = UDim.new(0, padding.Top or 0)
        uiPadding.PaddingBottom = UDim.new(0, padding.Bottom or 0)
        uiPadding.PaddingLeft = UDim.new(0, padding.Left or 0)
        uiPadding.PaddingRight = UDim.new(0, padding.Right or 0)
    else
        local p = padding or Theme.Sizes.Padding
        uiPadding.PaddingTop = UDim.new(0, p)
        uiPadding.PaddingBottom = UDim.new(0, p)
        uiPadding.PaddingLeft = UDim.new(0, p)
        uiPadding.PaddingRight = UDim.new(0, p)
    end
    
    uiPadding.Parent = parent
    return uiPadding
end

function Utils:CreateListLayout(parent, props)
    props = props or {}
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, props.Padding or Theme.Sizes.Spacing)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.FillDirection = props.FillDirection or Enum.FillDirection.Vertical
    layout.HorizontalAlignment = props.HorizontalAlignment or Enum.HorizontalAlignment.Left
    layout.VerticalAlignment = props.VerticalAlignment or Enum.VerticalAlignment.Top
    layout.Parent = parent
    
    return layout
end

function Utils:GenerateUID()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local uid = ""
    for i = 1, 16 do
        local idx = math.random(1, #chars)
        uid = uid .. chars:sub(idx, idx)
    end
    return uid
end

-- ========================================
-- INPUT HANDLER (DELTA EXECUTOR OPTIMIZED)
-- ========================================

local Input = {}

function Input:MakeDraggable(frame, handle)
    handle = handle or frame
    
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        local viewport = Camera.ViewportSize
        local newX = math.clamp(startPos.X.Offset + delta.X, 0, viewport.X - frame.AbsoluteSize.X)
        local newY = math.clamp(startPos.Y.Offset + delta.Y, 0, viewport.Y - frame.AbsoluteSize.Y)
        frame.Position = UDim2.new(0, newX, 0, newY)
    end
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

local Input = {}

-- ========================================
-- MAKE DRAGGABLE (Unchanged)
-- ========================================
function Input:MakeDraggable(frame, handle)
    handle = handle or frame
    
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        local viewport = Camera.ViewportSize
        local newX = math.clamp(startPos.X.Offset + delta.X, 0, viewport.X - frame.AbsoluteSize.X)
        local newY = math.clamp(startPos.Y.Offset + delta.Y, 0, viewport.Y - frame.AbsoluteSize.Y)
        frame.Position = UDim2.new(0, newX, 0, newY)
    end
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- ========================================
-- MAKE RESIZABLE (WITH AUTO-SAVE CALLBACK)
-- ========================================
function Input:MakeResizable(frame, minSize, maxSize, onResizeEnd)
    minSize = minSize or UDim2.new(0, Theme.GetResponsiveSize(300, 400, 400), 0, Theme.GetResponsiveSize(250, 300, 300))
    maxSize = maxSize or UDim2.new(0, 1400, 0, 900)
    
    local resizing = false
    local resizeInput
    local resizeStart
    local startSize
    
    local resizeHandle = Instance.new("TextButton")
    resizeHandle.Name = "ResizeHandle"
    resizeHandle.Text = "⌟"
    resizeHandle.Font = Theme.Fonts.Primary
    resizeHandle.TextSize = Theme.GetResponsiveSize(14, 16, 18)
    resizeHandle.TextColor3 = Color3.fromRGB(100, 100, 105)
    resizeHandle.BackgroundTransparency = 1
    resizeHandle.Size = UDim2.new(0, Theme.GetResponsiveSize(30, 35, 40), 0, Theme.GetResponsiveSize(30, 35, 40))
    resizeHandle.Position = UDim2.new(1, -Theme.GetResponsiveSize(30, 35, 40), 1, -Theme.GetResponsiveSize(30, 35, 40))
    resizeHandle.ZIndex = 10
    resizeHandle.Parent = frame
    
    local function update(input)
        local delta = input.Position - resizeStart
        local newWidth = math.clamp(startSize.X.Offset + delta.X, minSize.X.Offset, maxSize.X.Offset)
        local newHeight = math.clamp(startSize.Y.Offset + delta.Y, minSize.Y.Offset, maxSize.Y.Offset)
        frame.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
    
    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart = input.Position
            startSize = frame.Size
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    resizing = false
                    
                    -- ✅ AUTO-SAVE CALLBACK (NEW)
                    if onResizeEnd then
                        task.wait(0.05)  -- Small delay untuk pastikan size udah final
                        local finalWidth = frame.AbsoluteSize.X
                        local finalHeight = frame.AbsoluteSize.Y
                        onResizeEnd(finalWidth, finalHeight)
                    end
                end
            end)
        end
    end)
    
    resizeHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            resizeInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == resizeInput and resizing then
            update(input)
        end
    end)
end


function Input:AddRippleEffect(button, callback)
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local pos = input.Position - button.AbsolutePosition
            Animator:Ripple(button, pos)
            
            if callback then
                callback()
            end
        end
    end)
end

function Input:AddHoverEffect(element, hoverProps, normalProps)
    local stroke = element:FindFirstChildOfClass("UIStroke")

    element.MouseEnter:Connect(function()
        for prop, val in pairs(hoverProps) do
            if prop == "StrokeTransparency" and stroke then
                Animator:Tween(stroke, {Transparency = val}, Theme.Animations.Fast)
            else
                Animator:Tween(element, {[prop] = val}, Theme.Animations.Fast)
            end
        end
    end)
    
    element.MouseLeave:Connect(function()
        for prop, val in pairs(normalProps) do
            if prop == "StrokeTransparency" and stroke then
                Animator:Tween(stroke, {Transparency = val}, Theme.Animations.Fast)
            else
                Animator:Tween(element, {[prop] = val}, Theme.Animations.Fast)
            end
        end
    end)
end


-- ========================================
-- PARTICLE SYSTEM
-- ========================================

local ParticleSystem = {}

function ParticleSystem:CreateAnimatedBackground(parent)
    if IsMobile then
        return nil
    end
    
    local container = Instance.new("Frame")
    container.Name = "ParticleBackground"
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.ZIndex = 0
    container.Parent = parent
    
    for i = 1, 15 do
        spawn(function()
            local particle = Instance.new("Frame")
            particle.Size = UDim2.new(0, math.random(2, 5), 0, math.random(2, 5))
            particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
            particle.BackgroundColor3 = i % 3 == 0 and Theme.Colors.NeonPurple or (i % 3 == 1 and Theme.Colors.NeonCyan or Theme.Colors.NeonPink)
            particle.BackgroundTransparency = 0.7
            particle.BorderSizePixel = 0
            particle.ZIndex = 0
            particle.Parent = container
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = particle
            
            while particle.Parent and container.Parent do
                local randomX = math.random()
                local randomY = math.random()
                local duration = math.random(8, 15)
                
                Animator:Tween(particle, {
                    Position = UDim2.new(randomX, 0, randomY, 0),
                    BackgroundTransparency = math.random(50, 90) / 100
                }, duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                
                wait(duration)
            end
        end)
    end
    
    return container
end

-- ========================================
-- MODERN WINDOW V4.0
-- ========================================
local Window = {}
Window.__index = Window

function Window.new(config)
    local self = setmetatable({}, Window)
    
    self.Config = config or {}
    self.Title = self.Config.Title or "VyperUI V4.0"
    self.Subtitle = self.Config.Subtitle or ""
    
    local defaultWidth = Theme.GetResponsiveSize(math.min(ScreenSize.X - 20, 400), 700, 850)
    local defaultHeight = Theme.GetResponsiveSize(math.min(ScreenSize.Y - 20, 500), 500, 550)
    
    self.Size = self.Config.Size or UDim2.new(0, defaultWidth, 0, defaultHeight)
    self.Tabs = {}
    self.CurrentTab = nil
    self.SidebarCollapsed = true
    self.IsHidden = false
    self.IsMinimized = false
    
    self:Build()
    
    return self
end

function Window:Build()
    self.GUI = Utils:CreateElement("ScreenGui", {
        Name = "VyperUI_" .. Utils:GenerateUID(),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true
    })
    
    pcall(function() self.GUI.Parent = CoreGui end)
    if not self.GUI.Parent then
        self.GUI.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- Main Window Frame (satu container untuk semua)
    self.MainFrame = Utils:CreateGlassFrame(self.GUI, {
        Color = Theme.Colors.Background,
        Transparency = 0.05,
        Size = self.Size,
        Position = UDim2.new(0.5, -self.Size.X.Offset/2, 0.5, -self.Size.Y.Offset/2),
        CornerRadius = Theme.Sizes.CornerRadius,
        StrokeColor = Theme.Colors.BorderLight,
        StrokeTransparency = 0.3,
        ClipsDescendants = true
    })
    
    local shadow = Animator:Glow(self.MainFrame, Theme.Colors.AccentPrimary, 0.2)
    
    -- Background particles di belakang semua
    ParticleSystem:CreateAnimatedBackground(self.MainFrame)
    
    self:CreateTopbar()
    self:CreateSidebar()
    self:CreateContentArea()
    self:CreateMinimizedLogo()
    
    Input:MakeDraggable(self.MainFrame, self.Topbar)
    Input:MakeResizable(self.MainFrame)
end

function Window:CreateTopbar()
    -- Topbar tanpa glass effect bertumpuk, cuma border bawah
    self.Topbar = Instance.new("Frame")
    self.Topbar.Name = "Topbar"
    self.Topbar.BackgroundTransparency = 1
    self.Topbar.Size = UDim2.new(1, 0, 0, Theme.Sizes.TopbarHeight)
    self.Topbar.Position = UDim2.new(0, 0, 0, 0)
    self.Topbar.BorderSizePixel = 0
    self.Topbar.ZIndex = 5
    self.Topbar.Parent = self.MainFrame
    
    -- Border bawah topbar (garis pemisah subtle)
    local bottomBorder = Instance.new("Frame")
    bottomBorder.Name = "BottomBorder"
    bottomBorder.BackgroundColor3 = Theme.Colors.Border
    bottomBorder.BackgroundTransparency = 0.7
    bottomBorder.BorderSizePixel = 0
    bottomBorder.Size = UDim2.new(1, 0, 0, 1)
    bottomBorder.Position = UDim2.new(0, 0, 1, -1)
    bottomBorder.ZIndex = 5
    bottomBorder.Parent = self.Topbar
    
    -- Left Section: Logo
    local leftSection = Instance.new("Frame")
    leftSection.BackgroundTransparency = 1
    leftSection.Size = UDim2.new(0, Theme.GetResponsiveSize(80, 100, 120), 1, 0)
    leftSection.Parent = self.Topbar
    
    local logo = Instance.new("ImageLabel")
    logo.BackgroundTransparency = 1
    logo.Size = UDim2.new(0, Theme.GetResponsiveSize(32, 36, 40), 0, Theme.GetResponsiveSize(32, 36, 40))
    logo.Position = UDim2.new(0, Theme.GetResponsiveSize(16, 20, 24), 0.5, -Theme.GetResponsiveSize(16, 18, 20))
    logo.Image = "rbxassetid://94138995594797"
    logo.Parent = leftSection
    
    -- Center Section: Title & Subtitle
    local centerSection = Instance.new("Frame")
    centerSection.BackgroundTransparency = 1
    centerSection.Size = UDim2.new(1, -Theme.GetResponsiveSize(280, 340, 400), 1, 0)
    centerSection.Position = UDim2.new(0, Theme.GetResponsiveSize(80, 100, 120), 0, 0)
    centerSection.Parent = self.Topbar
    
    local titleLabel = Utils:CreateText(centerSection, self.Title, {
        Font = Theme.Fonts.Primary,
        TextSize = Theme.GetResponsiveSize(15, 17, 19),
        TextColor = Theme.Colors.TextPrimary,
        Size = UDim2.new(1, 0, 0.55, 0),
        Position = UDim2.new(0, 0, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Bottom
    })
    
    if not IsMobile then
        Utils:CreateText(centerSection, self.Subtitle, {
            Font = Theme.Fonts.Secondary,
            TextSize = Theme.GetResponsiveSize(10, 11, 12),
            TextColor = Theme.Colors.TextSecondary,
            Size = UDim2.new(1, 0, 0.45, 0),
            Position = UDim2.new(0, 0, 0.55, 0),
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Top
        })
    end
    
    -- Right Section: Window Buttons
    local rightSection = Instance.new("Frame")
    rightSection.BackgroundTransparency = 1
    rightSection.Size = UDim2.new(0, Theme.GetResponsiveSize(120, 140, 160), 1, 0)
    rightSection.Position = UDim2.new(1, -Theme.GetResponsiveSize(120, 140, 160), 0, 0)
    rightSection.Parent = self.Topbar
    
    self:CreateWindowButtons(rightSection)
end

function Window:CreateWindowButtons(parent)
    local container = Instance.new("Frame")
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, -Theme.GetResponsiveSize(16, 20, 24), 1, 0)
    container.Position = UDim2.new(0, 0, 0, 0)
    container.Parent = parent
    
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, Theme.Sizes.PaddingSmall)
    layout.Parent = container
    
    local buttonSize = Theme.GetResponsiveSize(28, 32, 36)
    
    local minimizeBtn = self:CreateTopbarButton(container, "−", Theme.Colors.Info, buttonSize)
    minimizeBtn.MouseButton1Click:Connect(function()
        self:MinimizeWindow()
    end)
    
    local closeBtn = self:CreateTopbarButton(container, "✕", Theme.Colors.Error, buttonSize)
    closeBtn.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
end

function Window:CreateTopbarButton(parent, icon, color, size)
    local button = Utils:CreateGlassFrame(parent, {
        Color = Theme.Colors.Surface,
        Transparency = Theme.Transparency.Glass,
        Size = UDim2.new(0, size, 0, size),
        CornerRadius = size/2,
        StrokeColor = color,
        StrokeTransparency = 0.7
    })
    
    Utils:CreateIcon(button, icon, {
        Size = Theme.GetResponsiveSize(12, 14, 16),
        Color = color,
        Position = UDim2.new(0.5, -Theme.GetResponsiveSize(6, 7, 8), 0.5, -Theme.GetResponsiveSize(6, 7, 8))
    })
    
    local clickBtn = Instance.new("TextButton")
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.ZIndex = 10
    clickBtn.Parent = button
    
    clickBtn.MouseButton1Click:Connect(function()
        Animator:Bounce(button, 0.85)
    end)
    
    if not IsMobile then
        Input:AddHoverEffect(button,
            {BackgroundTransparency = Theme.Transparency.GlassHover, StrokeTransparency = 0.3},
            {BackgroundTransparency = Theme.Transparency.Glass, StrokeTransparency = 0.7}
        )
    end
    
    return clickBtn
end

function Window:CreateSidebar()
    if self.SidebarCollapsed == nil then
        self.SidebarCollapsed = true
    end

    -- Sidebar tanpa glass effect bertumpuk, cuma border kanan
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Name = "Sidebar"
    self.Sidebar.BackgroundTransparency = 1
    self.Sidebar.Size = UDim2.new(0, self.SidebarCollapsed and Theme.Sizes.SidebarMinimized or Theme.Sizes.SidebarWidth, 1, -Theme.Sizes.TopbarHeight)
    self.Sidebar.Position = UDim2.new(0, 0, 0, Theme.Sizes.TopbarHeight)
    self.Sidebar.BorderSizePixel = 0
    self.Sidebar.ZIndex = 3
    self.Sidebar.ClipsDescendants = false
    self.Sidebar.Parent = self.MainFrame
    
    -- Border kanan sidebar (garis pemisah)
    local rightBorder = Instance.new("Frame")
    rightBorder.Name = "RightBorder"
    rightBorder.BackgroundColor3 = Theme.Colors.Border
    rightBorder.BackgroundTransparency = 0.7
    rightBorder.BorderSizePixel = 0
    rightBorder.Size = UDim2.new(0, 1, 1, 0)
    rightBorder.Position = UDim2.new(1, -1, 0, 0)
    rightBorder.ZIndex = 3
    rightBorder.Parent = self.Sidebar

    -- Tab Container dengan auto-sizing
    self.TabContainer = Instance.new("ScrollingFrame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.Size = UDim2.new(1, 0, 1, -Theme.GetResponsiveSize(70, 80, 90))
    self.TabContainer.Position = UDim2.new(0, 0, 0, Theme.GetResponsiveSize(10, 12, 14))
    self.TabContainer.ScrollBarThickness = 4
    self.TabContainer.ScrollBarImageColor3 = Theme.Colors.AccentPrimary
    self.TabContainer.ScrollingDirection = Enum.ScrollingDirection.Y
    self.TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.TabContainer.ZIndex = 3
    self.TabContainer.Parent = self.Sidebar

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, Theme.Sizes.PaddingSmall)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = self.TabContainer

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, Theme.Sizes.PaddingSmall)
    padding.PaddingLeft = UDim.new(0, Theme.Sizes.PaddingSmall)
    padding.PaddingRight = UDim.new(0, Theme.Sizes.PaddingSmall)
    padding.PaddingBottom = UDim.new(0, Theme.Sizes.PaddingSmall)
    padding.Parent = self.TabContainer

    -- Toggle Button di bawah (fixed position)
    local toggleBtnContainer = Instance.new("Frame")
    toggleBtnContainer.BackgroundTransparency = 1
    toggleBtnContainer.Size = UDim2.new(1, 0, 0, Theme.GetResponsiveSize(60, 70, 80))
    toggleBtnContainer.Position = UDim2.new(0, 0, 1, -Theme.GetResponsiveSize(60, 70, 80))
    toggleBtnContainer.ZIndex = 5
    toggleBtnContainer.Parent = self.Sidebar

    local toggleBtn = Utils:CreateGlassFrame(toggleBtnContainer, {
        Color = Theme.Colors.AccentPrimary,
        Transparency = Theme.Transparency.Glass,
        Size = UDim2.new(0, Theme.GetResponsiveSize(38, 42, 46), 0, Theme.GetResponsiveSize(38, 42, 46)),
        Position = UDim2.new(0.5, -Theme.GetResponsiveSize(19, 21, 23), 0.5, -Theme.GetResponsiveSize(19, 21, 23)),
        CornerRadius = Theme.Sizes.CornerRadiusSmall,
        StrokeColor = Theme.Colors.AccentPrimary,
        StrokeTransparency = 0.2
    })

    local toggleIcon = Utils:CreateIcon(toggleBtn, self.SidebarCollapsed and "▶" or "◀", {
        Size = Theme.GetResponsiveSize(14, 15, 16),
        Color = Theme.Colors.TextPrimary,
        Position = UDim2.new(0.5, -Theme.GetResponsiveSize(7, 7, 8), 0.5, -Theme.GetResponsiveSize(7, 7, 8))
    })

    local toggleBtnClick = Instance.new("TextButton")
    toggleBtnClick.Size = UDim2.new(1, 0, 1, 0)
    toggleBtnClick.BackgroundTransparency = 1
    toggleBtnClick.Text = ""
    toggleBtnClick.ZIndex = 10
    toggleBtnClick.Parent = toggleBtn

    toggleBtnClick.MouseButton1Click:Connect(function()
        self:ToggleSidebar()
        toggleIcon.Text = self.SidebarCollapsed and "▶" or "◀"
        Animator:Bounce(toggleBtn, 0.9)
    end)

    if not IsMobile then
        Input:AddHoverEffect(toggleBtn,
            {
                BackgroundTransparency = Theme.Transparency.GlassHover,
                StrokeTransparency = 0.05,
                StrokeColor = Theme.Colors.NeonCyan
            },
            {
                BackgroundTransparency = Theme.Transparency.Glass,
                StrokeTransparency = 0.2,
                StrokeColor = Theme.Colors.AccentPrimary
            }
        )
    end
end

function Window:CreateContentArea()
    local sidebarWidth = self.SidebarCollapsed and Theme.Sizes.SidebarMinimized or Theme.Sizes.SidebarWidth
    
    -- Content area tanpa background, langsung di atas background utama
    self.ContentArea = Instance.new("Frame")
    self.ContentArea.Name = "ContentArea"
    self.ContentArea.BackgroundTransparency = 1
    self.ContentArea.Size = UDim2.new(1, -sidebarWidth, 1, -Theme.Sizes.TopbarHeight)
    self.ContentArea.Position = UDim2.new(0, sidebarWidth, 0, Theme.Sizes.TopbarHeight)
    self.ContentArea.BorderSizePixel = 0
    self.ContentArea.ZIndex = 2
    self.ContentArea.Parent = self.MainFrame
end

function Window:CreateMinimizedLogo()
    local logoSize = Theme.Sizes.MinimizedLogoSize
    
    self.MinimizedLogo = Utils:CreateGlassFrame(self.GUI, {
        Color = Theme.Colors.GlassMid,
        Transparency = Theme.Transparency.Glass,
        Size = UDim2.new(0, logoSize, 0, logoSize),
        Position = UDim2.new(0, 20, 1, -logoSize - 20),
        CornerRadius = logoSize/2,
        StrokeColor = Theme.Colors.AccentPrimary,
        StrokeTransparency = 0.3,
        Gradient = true
    })
    
    self.MinimizedLogo.Visible = false
    
    local logoGlow = Animator:Glow(self.MinimizedLogo, Theme.Colors.AccentPrimary, 0.5)
    Animator:PulseGlow(logoGlow, 2)
    
    local logoImage = Instance.new("ImageLabel")
    logoImage.Name = "LogoImage"
    logoImage.BackgroundTransparency = 1
    logoImage.Size = UDim2.new(0.8, 0, 0.8, 0)
    logoImage.Position = UDim2.new(0.1, 0, 0.1, 0)
    logoImage.Image = Theme.Logo.URL
    logoImage.ImageColor3 = Theme.Colors.TextPrimary
    logoImage.ZIndex = 3
    logoImage.Parent = self.MinimizedLogo
    
    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(1, 0)
    logoCorner.Parent = logoImage
    
    local clickBtn = Instance.new("TextButton")
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.ZIndex = 10
    clickBtn.Parent = self.MinimizedLogo
    
    clickBtn.MouseButton1Click:Connect(function()
        self:RestoreWindow()
        Animator:Bounce(self.MinimizedLogo, 0.9)
    end)
    
    Input:MakeDraggable(self.MinimizedLogo)
    
    if not IsMobile then
        Input:AddHoverEffect(self.MinimizedLogo,
            {Size = UDim2.new(0, logoSize + 10, 0, logoSize + 10), StrokeTransparency = 0.1},
            {Size = UDim2.new(0, logoSize, 0, logoSize), StrokeTransparency = 0.3}
        )
    end
end

function Window:ToggleSidebar()
    self.SidebarCollapsed = not self.SidebarCollapsed
    
    local newWidth = self.SidebarCollapsed and Theme.Sizes.SidebarMinimized or Theme.Sizes.SidebarWidth
    local contentX = newWidth
    
    Animator:Spring(self.Sidebar, {Size = UDim2.new(0, newWidth, 1, -Theme.Sizes.TopbarHeight)})
    Animator:Spring(self.ContentArea, {
        Size = UDim2.new(1, -newWidth, 1, -Theme.Sizes.TopbarHeight),
        Position = UDim2.new(0, contentX, 0, Theme.Sizes.TopbarHeight)
    })
    
    for _, tab in ipairs(self.Tabs) do
        if tab.Button then
            local textLabel = tab.Button:FindFirstChild("TabText")
            if textLabel then
                if self.SidebarCollapsed then
                    Animator:Tween(textLabel, {TextTransparency = 1}, Theme.Animations.Fast)
                else
                    Animator:Tween(textLabel, {TextTransparency = 0}, Theme.Animations.Fast)
                end
            end
        end
    end
end

function Window:MinimizeWindow()
    self.IsMinimized = true
    
    Animator:Tween(self.MainFrame, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0, 20, 1, -Theme.Sizes.MinimizedLogoSize - 20)
    }, Theme.Animations.Normal, Enum.EasingStyle.Back, Enum.EasingDirection.In, function()
        self.MainFrame.Visible = false
        self.MinimizedLogo.Visible = true
        Animator:Spring(self.MinimizedLogo, {Size = UDim2.new(0, Theme.Sizes.MinimizedLogoSize, 0, Theme.Sizes.MinimizedLogoSize)})
    end)
end

function Window:RestoreWindow()
    self.IsMinimized = false
    
    Animator:Tween(self.MinimizedLogo, {
        Size = UDim2.new(0, 0, 0, 0)
    }, Theme.Animations.Fast, nil, nil, function()
        self.MinimizedLogo.Visible = false
        self.MainFrame.Visible = true
        
        Animator:Spring(self.MainFrame, {
            Size = self.Size,
            Position = UDim2.new(0.5, -self.Size.X.Offset/2, 0.5, -self.Size.Y.Offset/2)
        })
    end)
end

function Window:CreateTab(config)
    config = config or {}
    local title = config.Title or "Tab"
    local icon = config.Icon or "●"
    
    local tab = {
        Title = title,
        Icon = icon,
        Content = nil,
        Button = nil,
        Active = false
    }
    
    local buttonHeight = Theme.GetResponsiveSize(40, 45, 50)
    
    -- 🧱 Tab button (BACKGROUND TRANSPARAN PENUH)
    tab.Button = Utils:CreateGlassFrame(self.TabContainer, {
        Color = Theme.Colors.Surface,
        Transparency = 1, -- ✅ FULLY TRANSPARENT
        Size = UDim2.new(1, 0, 0, buttonHeight),
        CornerRadius = Theme.Sizes.CornerRadiusSmall,
        StrokeColor = Theme.Colors.Border,
        StrokeTransparency = 0.7
    })
    
    local iconLabel = Utils:CreateIcon(tab.Button, icon, {
        Size = Theme.GetResponsiveSize(16, 18, 20),
        Color = Theme.Colors.TextSecondary,
        Position = UDim2.new(0, Theme.Sizes.Padding, 0.5, -Theme.GetResponsiveSize(8, 9, 10))
    })
    iconLabel.Name = "TabIcon"
    
    local textLabel = Utils:CreateText(tab.Button, title, {
        Font = Theme.Fonts.Primary,
        TextSize = Theme.GetResponsiveSize(13, 14, 15),
        TextColor = Theme.Colors.TextSecondary,
        Size = UDim2.new(1, -Theme.GetResponsiveSize(50, 55, 60), 1, 0),
        Position = UDim2.new(0, Theme.GetResponsiveSize(40, 45, 50), 0, 0),
        TextTransparency = self.SidebarCollapsed and 1 or 0
    })
    textLabel.Name = "TabText"
    
    local clickBtn = Instance.new("TextButton")
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.ZIndex = 10
    clickBtn.Parent = tab.Button
    
    clickBtn.MouseButton1Click:Connect(function()
        self:SwitchTab(tab)
        Animator:Bounce(tab.Button, 0.95)
    end)
    
    -- 🌈 Hover effect: Background tetep transparan, cuma border yang glow
    local stroke = tab.Button:FindFirstChildOfClass("UIStroke")
    if not IsMobile and stroke then
        clickBtn.MouseEnter:Connect(function()
            if not tab.Active then
                pcall(function()
                    TweenService:Create(stroke, TweenInfo.new(Theme.Animations.Fast), {
                        Transparency = 0.3,
                        Color = Theme.Colors.AccentPrimary
                    }):Play()
                end)
            end
        end)
        
        clickBtn.MouseLeave:Connect(function()
            if not tab.Active then
                pcall(function()
                    TweenService:Create(stroke, TweenInfo.new(Theme.Animations.Fast), {
                        Transparency = 0.7,
                        Color = Theme.Colors.Border
                    }):Play()
                end)
            end
        end)
    end
    
    tab.Content = Instance.new("ScrollingFrame")
    tab.Content.Name = "TabContent_" .. title
    tab.Content.BackgroundTransparency = 1
    tab.Content.BorderSizePixel = 0
    tab.Content.Size = UDim2.new(1, 0, 1, 0)
    tab.Content.ScrollBarThickness = 6
    tab.Content.ScrollBarImageColor3 = Theme.Colors.AccentPrimary
    tab.Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    tab.Content.Visible = false
    tab.Content.ZIndex = 2
    tab.Content.Parent = self.ContentArea

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, Theme.Sizes.Spacing)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = tab.Content

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, Theme.Sizes.Padding)
    padding.PaddingLeft = UDim.new(0, Theme.Sizes.Padding)
    padding.PaddingRight = UDim.new(0, Theme.Sizes.Padding)
    padding.PaddingBottom = UDim.new(0, Theme.Sizes.Padding)
    padding.Parent = tab.Content

    tab.Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tab.Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    tab.Content.ScrollingDirection = Enum.ScrollingDirection.Y
    
    table.insert(self.Tabs, tab)
    
    if #self.Tabs == 1 then
        self:SwitchTab(tab)
    end
    
    return tab.Content
end

function Window:SwitchTab(targetTab)
    for _, tab in ipairs(self.Tabs) do
        local stroke = tab.Button:FindFirstChildOfClass("UIStroke")
        local iconLabel = tab.Button:FindFirstChild("TabIcon")
        local textLabel = tab.Button:FindFirstChild("TabText")
        
        if tab == targetTab then
            tab.Active = true
            tab.Content.Visible = true
            
            -- ✅ Background tetep transparan, cuma animasi BORDER & TEXT
            if stroke then
                Animator:Tween(stroke, {
                    Color = Theme.Colors.AccentPrimary,
                    Transparency = 0.3
                }, Theme.Animations.Fast)
            end
            
            if iconLabel then
                Animator:Tween(iconLabel, {TextColor3 = Theme.Colors.TextPrimary}, Theme.Animations.Fast)
            end
            
            if textLabel then
                Animator:Tween(textLabel, {TextColor3 = Theme.Colors.TextPrimary}, Theme.Animations.Fast)
            end
        else
            tab.Active = false
            tab.Content.Visible = false
            
            -- ✅ Tab inactive: border balik normal
            if stroke then
                Animator:Tween(stroke, {
                    Color = Theme.Colors.Border,
                    Transparency = 0.7
                }, Theme.Animations.Fast)
            end
            
            if iconLabel then
                Animator:Tween(iconLabel, {TextColor3 = Theme.Colors.TextSecondary}, Theme.Animations.Fast)
            end
            
            if textLabel then
                Animator:Tween(textLabel, {TextColor3 = Theme.Colors.TextSecondary}, Theme.Animations.Fast)
            end
        end
    end
    
    self.CurrentTab = targetTab
end

function Window:Destroy()
    Animator:Tween(self.MainFrame, {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    }, Theme.Animations.Normal, Enum.EasingStyle.Back, Enum.EasingDirection.In, function()
        if self.GUI then
            self.GUI:Destroy()
        end
    end)
end


-- ========================================
-- COMPONENTS V4.0
-- ========================================

local Components = {}

function Components:CreateButton(parent, config)
    config = config or {}
    local title = config.Title or "Button"
    local subtitle = config.Subtitle
    local callback = config.Callback or function() end
    local active = config.Active or false
    
    -- 🧱 Container utama tombol (BACKGROUND TRANSPARAN PENUH)
    local container = Utils:CreateGlassFrame(parent, {
        Color = Theme.Colors.Surface,
        Transparency = 1, -- ✅ FULLY TRANSPARENT (dulu: Theme.Transparency.Glass)
        Size = UDim2.new(1, 0, 0, subtitle and Theme.GetResponsiveSize(60, 65, 70) or Theme.Sizes.ButtonHeight),
        CornerRadius = Theme.Sizes.CornerRadiusSmall,
        StrokeColor = Theme.Colors.AccentPrimary,
        StrokeTransparency = 0.7,
        ClipsDescendants = true
    })
    
    Utils:CreatePadding(container, Theme.Sizes.Padding)
    
    local textContainer = Instance.new("Frame")
    textContainer.BackgroundTransparency = 1
    textContainer.Size = UDim2.new(1, 0, 1, 0)
    textContainer.Parent = container
    
    Utils:CreateText(textContainer, title, {
        Font = Theme.Fonts.Primary,
        TextSize = Theme.GetResponsiveSize(13, 14, 15),
        TextColor = Theme.Colors.TextPrimary,
        Position = UDim2.new(0, 0, 0, subtitle and Theme.GetResponsiveSize(6, 7, 8) or 0),
        TextYAlignment = subtitle and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,
        TextScaled = IsMobile
    })
    
    if subtitle then
        Utils:CreateText(textContainer, subtitle, {
            Font = Theme.Fonts.Secondary,
            TextSize = Theme.GetResponsiveSize(10, 11, 12),
            TextColor = Theme.Colors.TextSecondary,
            Position = UDim2.new(0, 0, 0, Theme.GetResponsiveSize(26, 28, 32)),
            TextYAlignment = Enum.TextYAlignment.Top,
            TextScaled = IsMobile
        })
    end

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.ZIndex = 10
    button.Parent = container

    local stroke = container:FindFirstChildOfClass("UIStroke")
    if not stroke then
        stroke = Instance.new("UIStroke")
        stroke.Color = Theme.Colors.AccentPrimary
        stroke.Thickness = 1
        stroke.Transparency = 0.7
        stroke.Parent = container
    end

    local function getRippleColor()
        if active then
            return Theme.Colors.Success or Color3.fromRGB(0, 255, 100)
        else
            return Theme.Colors.Danger or Color3.fromRGB(255, 80, 80)
        end
    end

    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local clickPos = Vector2.new(input.Position.X, input.Position.Y)
            if container.AbsolutePosition then
                clickPos = clickPos - container.AbsolutePosition
            end

            pcall(function()
                Animator:Ripple(container, clickPos, getRippleColor())
                Animator:Bounce(container, 0.9)
            end)

            active = not active
            callback(active)
        end
    end)

    -- 🌈 Hover: Background tetep transparan, cuma border yang glow
    if not IsMobile then
        button.MouseEnter:Connect(function()
            pcall(function()
                -- Background tetep transparan, ga perlu di-tween lagi
                TweenService:Create(stroke, TweenInfo.new(Theme.Animations.Fast), {
                    Transparency = 0.25,
                    Color = Theme.Colors.NeonCyan
                }):Play()
            end)
        end)
        
        button.MouseLeave:Connect(function()
            pcall(function()
                TweenService:Create(stroke, TweenInfo.new(Theme.Animations.Fast), {
                    Transparency = 0.7,
                    Color = Theme.Colors.AccentPrimary
                }):Play()
            end)
        end)
    end

    return container
end



function Components:CreateToggle(parent, config)
    config = config or {}
    local title = config.Title or "Toggle"
    local subtitle = config.Subtitle
    local default = config.Default or false
    local callback = config.Callback or function() end
    
    local container = Utils:CreateGlassFrame(parent, {
        Color = Theme.Colors.Surface,
        Transparency = 1, -- ✅ FULLY TRANSPARENT
        Size = UDim2.new(1, 0, 0, subtitle and Theme.GetResponsiveSize(60, 65, 70) or Theme.Sizes.ButtonHeight),
        CornerRadius = Theme.Sizes.CornerRadiusSmall,
        StrokeColor = Theme.Colors.Border,
        StrokeTransparency = 0.7
    })
    
    Utils:CreatePadding(container, Theme.Sizes.Padding)
    
    local textContainer = Instance.new("Frame")
    textContainer.BackgroundTransparency = 1
    textContainer.Size = UDim2.new(1, -60, 1, 0)
    textContainer.Parent = container
    
    Utils:CreateText(textContainer, title, {
        Font = Theme.Fonts.Primary,
        TextSize = Theme.GetResponsiveSize(13, 14, 15),
        TextColor = Theme.Colors.TextPrimary,
        Position = UDim2.new(0, 0, 0, subtitle and Theme.GetResponsiveSize(6, 7, 8) or 0),
        TextYAlignment = subtitle and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,
        TextScaled = IsMobile
    })
    
    if subtitle then
        Utils:CreateText(textContainer, subtitle, {
            Font = Theme.Fonts.Secondary,
            TextSize = Theme.GetResponsiveSize(10, 11, 12),
            TextColor = Theme.Colors.TextSecondary,
            Position = UDim2.new(0, 0, 0, Theme.GetResponsiveSize(26, 28, 32)),
            TextYAlignment = Enum.TextYAlignment.Top,
            TextScaled = IsMobile
        })
    end
    
    local toggleSize = Theme.GetResponsiveSize(22, 24, 26)
    local trackWidth = Theme.GetResponsiveSize(42, 46, 50)
    
    local toggleTrack = Utils:CreateGlassFrame(container, {
        Color = default and Theme.Colors.AccentPrimary or Theme.Colors.SurfaceLight,
        Transparency = 0.1,
        Size = UDim2.new(0, trackWidth, 0, toggleSize),
        Position = UDim2.new(1, -trackWidth, 0.5, -toggleSize/2),
        CornerRadius = toggleSize/2,
        Stroke = false
    })
    
    local glow = Animator:Glow(toggleTrack, Theme.Colors.AccentPrimary, default and 0.5 or 0)
    
    local knobSize = Theme.GetResponsiveSize(16, 18, 20)
    local toggleKnob = Instance.new("Frame")
    toggleKnob.BackgroundColor3 = Theme.Colors.TextPrimary
    toggleKnob.BorderSizePixel = 0
    toggleKnob.Size = UDim2.new(0, knobSize, 0, knobSize)
    toggleKnob.Position = default and UDim2.new(1, -knobSize - 3, 0.5, -knobSize/2) or UDim2.new(0, 3, 0.5, -knobSize/2)
    toggleKnob.ZIndex = 5
    toggleKnob.Parent = toggleTrack
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = toggleKnob
    
    local knobShadow = Animator:Glow(toggleKnob, Theme.Colors.Shadow, 0.3)
    
    local state = default
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.ZIndex = 10
    button.Parent = container
    
    button.MouseButton1Click:Connect(function()
        state = not state
        
        Animator:Bounce(toggleTrack, 0.95)
        
        if state then
            Animator:Spring(toggleKnob, {Position = UDim2.new(1, -knobSize - 3, 0.5, -knobSize/2)})
            Animator:Tween(toggleTrack, {BackgroundColor3 = Theme.Colors.AccentPrimary}, Theme.Animations.Fast)
            if glow then
                Animator:Tween(glow, {ImageTransparency = 0.5}, Theme.Animations.Fast)
            end
        else
            Animator:Spring(toggleKnob, {Position = UDim2.new(0, 3, 0.5, -knobSize/2)})
            Animator:Tween(toggleTrack, {BackgroundColor3 = Theme.Colors.SurfaceLight}, Theme.Animations.Fast)
            if glow then
                Animator:Tween(glow, {ImageTransparency = 1}, Theme.Animations.Fast)
            end
        end
        
        callback(state)
    end)
    
    -- ✅ Hover: Ga perlu tween background lagi (udah transparan)
    -- Border tetep ada dari stroke default
    if not IsMobile then
        local stroke = container:FindFirstChildOfClass("UIStroke")
        if stroke then
            button.MouseEnter:Connect(function()
                pcall(function()
                    TweenService:Create(stroke, TweenInfo.new(Theme.Animations.Fast), {
                        Transparency = 0.4,
                        Color = Theme.Colors.NeonCyan
                    }):Play()
                end)
            end)
            
            button.MouseLeave:Connect(function()
                pcall(function()
                    TweenService:Create(stroke, TweenInfo.new(Theme.Animations.Fast), {
                        Transparency = 0.7,
                        Color = Theme.Colors.Border
                    }):Play()
                end)
            end)
        end
    end
    
    return container
end


function Components:CreateDropdown(parent, config)
    config = config or {}
    local title = config.Title or "Dropdown"
    local subtitle = config.Subtitle
    local options = config.Options or {"Option 1", "Option 2", "Option 3"}
    local default = config.Default or options[1]
    local callback = config.Callback or function() end

    local closedHeight = subtitle and Theme.GetResponsiveSize(85,90,95) or Theme.GetResponsiveSize(70,75,80)
    local optionHeight = Theme.GetResponsiveSize(42,46,50)
    local maxVisible = 5

    local expandedHeight = math.min(#options, maxVisible) * optionHeight + 10
    local scrollHeight = #options > maxVisible and (maxVisible * optionHeight + 10) or (#options * optionHeight + 10)

    -- ✅ Container utama TRANSPARAN
    local container = Utils:CreateGlassFrame(parent, {
        Color = Theme.Colors.Surface,
        Transparency = 1, -- ✅ FULLY TRANSPARENT
        Size = UDim2.new(1, 0, 0, closedHeight),
        CornerRadius = Theme.Sizes.CornerRadiusSmall,
        StrokeColor = Theme.Colors.AccentPrimary,
        StrokeTransparency = 0.7,
        ClipsDescendants = true,
    })
    Utils:CreatePadding(container, Theme.Sizes.PaddingSmall)

    Utils:CreateText(container, title, {
        Font = Theme.Fonts.Primary,
        TextSize = Theme.GetResponsiveSize(14,15,16),
        TextColor = Theme.Colors.TextPrimary,
        TextYAlignment = Enum.TextYAlignment.Top
    })
    
    if subtitle then
        Utils:CreateText(container, subtitle, {
            Font = Theme.Fonts.Secondary,
            TextSize = Theme.GetResponsiveSize(11,12,13),
            TextColor = Theme.Colors.TextSecondary,
            Position = UDim2.new(0,0,0,Theme.GetResponsiveSize(26,28,30)),
            TextYAlignment = Enum.TextYAlignment.Top
        })
    end

    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Size = UDim2.new(1,-10,0,Theme.GetResponsiveSize(34,38,42))
    dropdownButton.Position = UDim2.new(0,0,0,Theme.GetResponsiveSize(42,46,50))
    dropdownButton.BackgroundTransparency = 1
    dropdownButton.Text = default
    dropdownButton.TextColor3 = Theme.Colors.TextPrimary
    dropdownButton.Font = Theme.Fonts.Primary
    dropdownButton.TextSize = Theme.GetResponsiveSize(14,15,16)
    dropdownButton.TextXAlignment = Enum.TextXAlignment.Left
    dropdownButton.ZIndex = 10
    dropdownButton.Parent = container

    local arrow = Instance.new("TextLabel")
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.Font = Enum.Font.GothamBold
    arrow.TextColor3 = Theme.Colors.NeonCyan
    arrow.TextSize = Theme.GetResponsiveSize(16,18,20)
    arrow.AnchorPoint = Vector2.new(1,0.5)
    arrow.Position = UDim2.new(1,-8,0.5,0)
    arrow.ZIndex = 11
    arrow.Parent = dropdownButton

    -- ✅ Dropdown frame tetep punya background (biar keliatan pas expand)
    local dropdownFrame = Instance.new("ScrollingFrame")
    dropdownFrame.Active = true
    dropdownFrame.ScrollBarThickness = 6
    dropdownFrame.ScrollBarImageColor3 = Theme.Colors.NeonCyan
    dropdownFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    dropdownFrame.CanvasSize = UDim2.new(0,0,0,0)
    dropdownFrame.BackgroundColor3 = Theme.Colors.GlassDark
    dropdownFrame.BackgroundTransparency = 0.15
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.Visible = false
    dropdownFrame.Size = UDim2.new(1,0,0,0)
    dropdownFrame.Position = UDim2.new(0,0,0,Theme.GetResponsiveSize(78,84,90))
    dropdownFrame.ZIndex = 9
    dropdownFrame.Parent = container

    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, Theme.Sizes.CornerRadiusSmall)
    dropdownCorner.Parent = dropdownFrame

    local dropdownStroke = Instance.new("UIStroke")
    dropdownStroke.Color = Theme.Colors.NeonCyan
    dropdownStroke.Thickness = 1
    dropdownStroke.Transparency = 0.5
    dropdownStroke.Parent = dropdownFrame

    local uiList = Instance.new("UIListLayout")
    uiList.Parent = dropdownFrame
    uiList.Padding = UDim.new(0,0)

    local dropdownPadding = Instance.new("UIPadding")
    dropdownPadding.PaddingBottom = UDim.new(0, 8)
    dropdownPadding.Parent = dropdownFrame

    local function RenderOptions(newOptions)
        for _, child in ipairs(dropdownFrame:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("Frame") then
                if child.Name:match("^Option") or child.Name == "Separator" then
                    child:Destroy()
                end
            end
        end

        for i, option in ipairs(newOptions) do
            local optionContainer = Instance.new("Frame")
            optionContainer.Name = "Option_" .. i
            optionContainer.BackgroundTransparency = 1
            optionContainer.Size = UDim2.new(1,0,0,optionHeight)
            optionContainer.ZIndex = 12
            optionContainer.Parent = dropdownFrame

            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1,-12,1,-4)
            optBtn.Position = UDim2.new(0,6,0,2)
            optBtn.BackgroundColor3 = Theme.Colors.Surface
            optBtn.BackgroundTransparency = 0.9
            optBtn.BorderSizePixel = 0
            optBtn.Text = ""
            optBtn.ZIndex = 13
            optBtn.Parent = optionContainer

            local optCorner = Instance.new("UICorner")
            optCorner.CornerRadius = UDim.new(0, Theme.Sizes.CornerRadiusSmall)
            optCorner.Parent = optBtn

            local checkmark = Instance.new("TextLabel")
            checkmark.BackgroundTransparency = 1
            checkmark.Text = "✓"
            checkmark.Font = Enum.Font.GothamBold
            checkmark.TextColor3 = Theme.Colors.NeonCyan
            checkmark.TextSize = Theme.GetResponsiveSize(16,18,20)
            checkmark.Size = UDim2.new(0,Theme.GetResponsiveSize(24,26,28),1,0)
            checkmark.Position = UDim2.new(0,Theme.GetResponsiveSize(8,10,12),0,0)
            checkmark.TextXAlignment = Enum.TextXAlignment.Center
            checkmark.TextYAlignment = Enum.TextYAlignment.Center
            checkmark.Visible = (option == dropdownButton.Text)
            checkmark.ZIndex = 15
            checkmark.Parent = optBtn

            local optText = Instance.new("TextLabel")
            optText.BackgroundTransparency = 1
            optText.Text = option
            optText.Font = Theme.Fonts.Primary
            optText.TextSize = Theme.GetResponsiveSize(13,14,15)
            optText.TextColor3 = (option == dropdownButton.Text) and Theme.Colors.NeonCyan or Theme.Colors.TextPrimary
            optText.Size = UDim2.new(1,-Theme.GetResponsiveSize(40,44,48),1,0)
            optText.Position = UDim2.new(0,Theme.GetResponsiveSize(36,40,44),0,0)
            optText.TextXAlignment = Enum.TextXAlignment.Left
            optText.TextYAlignment = Enum.TextYAlignment.Center
            optText.ZIndex = 14
            optText.Parent = optBtn

            optBtn.MouseEnter:Connect(function()
                TweenService:Create(optBtn, TweenInfo.new(0.2), {
                    BackgroundTransparency = 0.5,
                    BackgroundColor3 = Theme.Colors.AccentPrimary
                }):Play()
                TweenService:Create(optText, TweenInfo.new(0.15), {
                    TextColor3 = Theme.Colors.TextPrimary
                }):Play()
            end)
            
            optBtn.MouseLeave:Connect(function()
                local isSelected = (option == dropdownButton.Text)
                TweenService:Create(optBtn, TweenInfo.new(0.2), {
                    BackgroundTransparency = 0.9,
                    BackgroundColor3 = Theme.Colors.Surface
                }):Play()
                TweenService:Create(optText, TweenInfo.new(0.15), {
                    TextColor3 = isSelected and Theme.Colors.NeonCyan or Theme.Colors.TextPrimary
                }):Play()
            end)

            optBtn.MouseButton1Click:Connect(function()
                dropdownButton.Text = option
                callback(option)

                for _, child in ipairs(dropdownFrame:GetChildren()) do
                    if child.Name:match("^Option") then
                        local btn = child:FindFirstChild("TextButton")
                        if btn then
                            local check = btn:FindFirstChild("TextLabel")
                            local text = btn:FindFirstChildOfClass("TextLabel")
                            if check and text then
                                check.Visible = (text.Text == option)
                                text.TextColor3 = (text.Text == option) and Theme.Colors.NeonCyan or Theme.Colors.TextPrimary
                            end
                        end
                    end
                end

                Animator:Bounce(optBtn, 0.95)

                TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1,0,0,closedHeight)
                }):Play()
                TweenService:Create(dropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1,0,0,0)
                }):Play()
                TweenService:Create(arrow, TweenInfo.new(0.2), {
                    Rotation = 0,
                    TextColor3 = Theme.Colors.NeonCyan
                }):Play()
                
                task.wait(0.3)
                dropdownFrame.Visible = false
            end)

            if i < #newOptions then
                local separator = Instance.new("Frame")
                separator.Name = "Separator"
                separator.BackgroundColor3 = Theme.Colors.Border
                separator.BackgroundTransparency = 0.7
                separator.BorderSizePixel = 0
                separator.Size = UDim2.new(1,-24,0,1)
                separator.Position = UDim2.new(0,12,1,-1)
                separator.ZIndex = 12
                separator.Parent = optionContainer
            end
        end

        scrollHeight = #newOptions > maxVisible and (maxVisible * optionHeight + 10) or (#newOptions * optionHeight + 10)
    end

    RenderOptions(options)

    dropdownButton.MouseButton1Click:Connect(function()
        if dropdownFrame.Visible then
            TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(1,0,0,closedHeight)
            }):Play()
            TweenService:Create(dropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(1,0,0,0)
            }):Play()
            TweenService:Create(arrow, TweenInfo.new(0.2), {
                Rotation = 0,
                TextColor3 = Theme.Colors.NeonCyan
            }):Play()
            
            task.wait(0.3)
            dropdownFrame.Visible = false
        else
            dropdownFrame.Visible = true
            TweenService:Create(arrow, TweenInfo.new(0.2), {
                Rotation = 180,
                TextColor3 = Theme.Colors.NeonPink
            }):Play()
            TweenService:Create(container, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(1,0,0,closedHeight + scrollHeight + 12)
            }):Play()
            TweenService:Create(dropdownFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(1,0,0,scrollHeight)
            }):Play()
            
            TweenService:Create(dropdownStroke, TweenInfo.new(0.3), {
                Transparency = 0.3
            }):Play()
        end
    end)

    return {
        Container = container,
        
        UpdateOptions = function(self, newOptions, newDefault)
            options = newOptions or options
            
            if newDefault and table.find(options, newDefault) then
                dropdownButton.Text = newDefault
            elseif #options > 0 then
                dropdownButton.Text = options[1]
            else
                dropdownButton.Text = "No Options"
            end
            
            RenderOptions(options)
        end,
        
        Destroy = function(self)
            container:Destroy()
        end
    }
end


function Components:CreateSlider(parent, config)
    config = config or {}
    local title = config.Title or "Slider"
    local subtitle = config.Subtitle or ""
    local min = config.Min or 0
    local max = config.Max or 100
    local default = config.Default or min
    local increment = config.Increment or 1
    local callback = config.Callback or function() end
    
    -- ✅ Container TRANSPARAN
    local container = Utils:CreateGlassFrame(parent, {
        Color = Theme.Colors.Surface,
        Transparency = 1, -- ✅ FULLY TRANSPARENT
        Size = UDim2.new(1, 0, 0, Theme.GetResponsiveSize(65, 70, 75)),
        CornerRadius = Theme.Sizes.CornerRadiusSmall,
        StrokeColor = Theme.Colors.Border,
        StrokeTransparency = 0.8
    })
    
    Utils:CreatePadding(container, Theme.Sizes.Padding)
    
    -- ========== LEFT SIDE (Title + Subtitle) ==========
    local leftSide = Instance.new("Frame")
    leftSide.Name = "LeftSide"
    leftSide.BackgroundTransparency = 1
    leftSide.Size = UDim2.new(0.5, -Theme.Sizes.Padding, 1, 0)
    leftSide.Parent = container
    
    local titleLabel = Utils:CreateText(leftSide, title, {
        Font = Theme.Fonts.Primary,
        TextSize = Theme.GetResponsiveSize(13, 14, 15),
        TextColor = Theme.Colors.TextPrimary,
        Size = UDim2.new(1, 0, 0, 20),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    })
    
    if subtitle ~= "" then
        local subtitleLabel = Utils:CreateText(leftSide, subtitle, {
            Font = Theme.Fonts.Primary,
            TextSize = Theme.GetResponsiveSize(11, 12, 13),
            TextColor = Theme.Colors.TextSecondary,
            Size = UDim2.new(1, 0, 1, -22),
            Position = UDim2.new(0, 0, 0, 22),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true
        })
    end
    
    -- ========== RIGHT SIDE (Slider + Value) ==========
    local rightSide = Instance.new("Frame")
    rightSide.Name = "RightSide"
    rightSide.BackgroundTransparency = 1
    rightSide.Size = UDim2.new(0.5, -Theme.Sizes.Padding, 1, 0)
    rightSide.Position = UDim2.new(0.5, Theme.Sizes.Padding, 0, 0)
    rightSide.Parent = container
    
    local valueLabel = Utils:CreateText(rightSide, tostring(default), {
        Font = Theme.Fonts.Mono,
        TextSize = Theme.GetResponsiveSize(12, 13, 14),
        TextColor = Theme.Colors.AccentPrimary,
        Size = UDim2.new(1, 0, 0, 20),
        TextXAlignment = Enum.TextXAlignment.Right,
        TextYAlignment = Enum.TextYAlignment.Top
    })
    
    -- ========== SLIDER CONTAINER ==========
    local sliderContainer = Instance.new("Frame")
    sliderContainer.BackgroundTransparency = 1
    sliderContainer.Size = UDim2.new(1, 0, 0, 20)
    sliderContainer.Position = UDim2.new(0, 0, 0.5, 0)
    sliderContainer.AnchorPoint = Vector2.new(0, 0.5)
    sliderContainer.Parent = rightSide
    
    -- ========== TRACK (Background) - tetep punya background ==========
    local sliderTrack = Utils:CreateGlassFrame(sliderContainer, {
        Color = Theme.Colors.Surface,
        Transparency = 0.5,
        Size = UDim2.new(1, 0, 0, Theme.GetResponsiveSize(6, 7, 8)),
        Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        CornerRadius = Theme.GetResponsiveSize(3, 3.5, 4),
        StrokeColor = Theme.Colors.Border,
        StrokeTransparency = 0.85
    })
    
    -- ========== FILL (Progress) ==========
    local sliderFill = Instance.new("Frame")
    sliderFill.BackgroundColor3 = Theme.Colors.AccentPrimary
    sliderFill.BorderSizePixel = 0
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.ZIndex = 2
    sliderFill.Parent = sliderTrack
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    -- ========== KNOB (Handle) ==========
    local knobSize = Theme.GetResponsiveSize(12, 13, 14)
    local sliderKnob = Instance.new("Frame")
    sliderKnob.BackgroundColor3 = Theme.Colors.TextPrimary
    sliderKnob.BorderSizePixel = 0
    sliderKnob.Size = UDim2.new(0, knobSize, 0, knobSize)
    sliderKnob.Position = UDim2.new((default - min) / (max - min), -knobSize/2, 0.5, -knobSize/2)
    sliderKnob.AnchorPoint = Vector2.new(0, 0.5)
    sliderKnob.ZIndex = 3
    sliderKnob.Parent = sliderTrack
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = sliderKnob
    
    local knobShadow = Instance.new("ImageLabel")
    knobShadow.Name = "Shadow"
    knobShadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    knobShadow.ImageColor3 = Color3.new(0, 0, 0)
    knobShadow.ImageTransparency = 0.8
    knobShadow.BackgroundTransparency = 1
    knobShadow.Size = UDim2.new(1, 4, 1, 4)
    knobShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    knobShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    knobShadow.ZIndex = 2
    knobShadow.Parent = sliderKnob
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(1, 0)
    shadowCorner.Parent = knobShadow
    
    local currentValue = default
    local dragging = false
    local dragInput
    
    local function updateSlider(input)
        local relativeX = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
        local rawValue = min + (relativeX * (max - min))
        currentValue = math.floor(rawValue / increment + 0.5) * increment
        currentValue = math.clamp(currentValue, min, max)
        
        local percent = (currentValue - min) / (max - min)
        
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        sliderKnob.Position = UDim2.new(percent, -knobSize/2, 0.5, -knobSize/2)
        valueLabel.Text = tostring(currentValue)
        
        callback(currentValue)
    end
    
    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
            
            Animator:Tween(sliderKnob, {
                Size = UDim2.new(0, knobSize + 3, 0, knobSize + 3)
            }, Theme.Animations.Fast, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            
            Animator:Tween(knobShadow, {
                ImageTransparency = 0.6
            }, Theme.Animations.Fast)
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    
                    Animator:Tween(sliderKnob, {
                        Size = UDim2.new(0, knobSize, 0, knobSize)
                    }, Theme.Animations.Fast, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    
                    Animator:Tween(knobShadow, {
                        ImageTransparency = 0.8
                    }, Theme.Animations.Fast)
                end
            end)
        end
    end)
    
    sliderTrack.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateSlider(input)
        end
    end)
    
    if not IsMobile then
        sliderTrack.MouseEnter:Connect(function()
            if not dragging then
                Animator:Tween(sliderKnob, {
                    Size = UDim2.new(0, knobSize + 2, 0, knobSize + 2)
                }, Theme.Animations.Fast)
            end
        end)
        
        sliderTrack.MouseLeave:Connect(function()
            if not dragging then
                Animator:Tween(sliderKnob, {
                    Size = UDim2.new(0, knobSize, 0, knobSize)
                }, Theme.Animations.Fast)
            end
        end)
    end
    
    return container
end


function Components:CreateTextBox(parent, config)
    config = config or {}
    local title = config.Title or "TextBox"
    local subtitle = config.Subtitle or "Description"
    local placeholder = config.Placeholder or "Enter text..."
    local default = config.Default or ""
    local callback = config.Callback or function() end
    
    -- ✅ Main Container TRANSPARAN
    local container = Utils:CreateGlassFrame(parent, {
        Color = Theme.Colors.Surface,
        Transparency = 1, -- ✅ FULLY TRANSPARENT
        Size = UDim2.new(1, 0, 0, Theme.GetResponsiveSize(75, 80, 85)),
        CornerRadius = Theme.Sizes.CornerRadiusSmall,
        StrokeColor = Theme.Colors.Border,
        StrokeTransparency = 0.7
    })
    
    Utils:CreatePadding(container, Theme.Sizes.Padding)
    
    local headerContainer = Instance.new("Frame")
    headerContainer.BackgroundTransparency = 1
    headerContainer.Size = UDim2.new(1, 0, 1, 0)
    headerContainer.Parent = container
    
    -- Left Side: Title & Subtitle
    local leftSide = Instance.new("Frame")
    leftSide.BackgroundTransparency = 1
    leftSide.Size = UDim2.new(0.5, -5, 1, 0)
    leftSide.Position = UDim2.new(0, 0, 0, 0)
    leftSide.Parent = headerContainer
    
    local titleLabel = Utils:CreateText(leftSide, title, {
        Font = Theme.Fonts.Primary,
        TextSize = Theme.GetResponsiveSize(14, 15, 16),
        TextColor = Theme.Colors.TextPrimary,
        Size = UDim2.new(1, 0, 0, 22),
        Position = UDim2.new(0, 0, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local subtitleLabel = Utils:CreateText(leftSide, subtitle, {
        Font = Theme.Fonts.Secondary,
        TextSize = Theme.GetResponsiveSize(11, 12, 13),
        TextColor = Theme.Colors.TextSecondary,
        Size = UDim2.new(1, 0, 0, 18),
        Position = UDim2.new(0, 0, 0, 24),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Right Side: Input Box
    local rightSide = Instance.new("Frame")
    rightSide.BackgroundTransparency = 1
    rightSide.Size = UDim2.new(0.5, -5, 1, 0)
    rightSide.Position = UDim2.new(0.5, 5, 0, 0)
    rightSide.Parent = headerContainer
    
    -- ✅ Input Frame tetep punya background (interactable element)
    local inputFrame = Utils:CreateGlassFrame(rightSide, {
        Color = Theme.Colors.SurfaceLight,
        Transparency = 0.1,
        Size = UDim2.new(1, 0, 0, Theme.GetResponsiveSize(36, 38, 40)),
        Position = UDim2.new(0, 0, 0.5, -Theme.GetResponsiveSize(18, 19, 20)),
        AnchorPoint = Vector2.new(0, 0.5),
        CornerRadius = Theme.Sizes.CornerRadiusSmall,
        StrokeColor = Theme.Colors.Border,
        StrokeTransparency = 0.5
    })
    
    local textBox = Instance.new("TextBox")
    textBox.BackgroundTransparency = 1
    textBox.Size = UDim2.new(1, -20, 1, 0)
    textBox.Position = UDim2.new(0, 10, 0, 0)
    textBox.Font = Theme.Fonts.Secondary
    textBox.TextSize = Theme.GetResponsiveSize(12, 13, 14)
    textBox.TextColor3 = Theme.Colors.TextPrimary
    textBox.PlaceholderText = placeholder
    textBox.PlaceholderColor3 = Theme.Colors.TextTertiary
    textBox.Text = default
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.ClearTextOnFocus = false
    textBox.ZIndex = 5
    textBox.Parent = inputFrame
    
    textBox.Focused:Connect(function()
        Animator:Tween(inputFrame, {
            BackgroundColor3 = Theme.Colors.Surface,
            StrokeColor = Theme.Colors.AccentPrimary,
            StrokeTransparency = 0.2
        }, Theme.Animations.Fast)
    end)
    
    textBox.FocusLost:Connect(function()
        Animator:Tween(inputFrame, {
            BackgroundColor3 = Theme.Colors.SurfaceLight,
            StrokeColor = Theme.Colors.Border,
            StrokeTransparency = 0.5
        }, Theme.Animations.Fast)
        callback(textBox.Text)
    end)
    
    return container, textBox
end


function Components:CreateLabel(parent, config)
    config = config or {}
    local title = config.Title or "Label"
    local subtitle = config.Subtitle
    
    -- ✅ Container TRANSPARAN
    local container = Utils:CreateGlassFrame(parent, {
        Color = Theme.Colors.Surface,
        Transparency = 1, -- ✅ FULLY TRANSPARENT (dulu: Theme.Transparency.Glass + 0.1)
        Size = UDim2.new(1, 0, 0, subtitle and Theme.GetResponsiveSize(50, 55, 60) or Theme.GetResponsiveSize(35, 38, 40)),
        CornerRadius = Theme.Sizes.CornerRadiusSmall,
        StrokeColor = Theme.Colors.Border,
        StrokeTransparency = 0.8
    })
    
    Utils:CreatePadding(container, Theme.Sizes.Padding)
    
    Utils:CreateText(container, title, {
        Font = Theme.Fonts.Primary,
        TextSize = Theme.GetResponsiveSize(13, 14, 15),
        TextColor = Theme.Colors.TextPrimary,
        Position = UDim2.new(0, 0, 0, subtitle and Theme.GetResponsiveSize(4, 5, 6) or 0),
        TextYAlignment = subtitle and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,
        TextScaled = IsMobile
    })
    
    if subtitle then
        Utils:CreateText(container, subtitle, {
            Font = Theme.Fonts.Secondary,
            TextSize = Theme.GetResponsiveSize(10, 11, 12),
            TextColor = Theme.Colors.TextSecondary,
            Position = UDim2.new(0, 0, 0, Theme.GetResponsiveSize(22, 25, 28)),
            TextYAlignment = Enum.TextYAlignment.Top,
            TextScaled = IsMobile
        })
    end
    
    return container
end

function Components:CreateSection(parent, title)
    local container = Instance.new("Frame")
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, Theme.GetResponsiveSize(25, 28, 30))
    container.Parent = parent
    
    Utils:CreateText(container, title, {
        Font = Theme.Fonts.Primary,
        TextSize = Theme.GetResponsiveSize(14, 15, 16),
        TextColor = Theme.Colors.AccentPrimary,
        Size = UDim2.new(1, 0, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Bottom
    })
    
    local divider = Instance.new("Frame")
    divider.BackgroundColor3 = Theme.Colors.AccentPrimary
    divider.BackgroundTransparency = 0.7
    divider.BorderSizePixel = 0
    divider.Size = UDim2.new(1, 0, 0, 1)
    divider.Position = UDim2.new(0, 0, 1, -2)
    divider.Parent = container
    
    return container
end

-- ========================================
-- NUMERIC INPUT COMPONENT untuk VyperUI V4.0
-- Layout: Title/Subtitle di KIRI, Input di KANAN
-- FREE INPUT: Bisa ketik angka bebas (0.87, 1.34, dst)
-- ========================================

function Components:CreateNumericInput(parent, config)
    config = config or {}
    local title = config.Title or "Numeric Input"
    local subtitle = config.Subtitle
    local min = config.Min or 0
    local max = config.Max or 100
    local default = config.Default or 0
    local increment = config.Increment or 1
    local decimalPlaces = config.DecimalPlaces or 0
    local suffix = config.Suffix or ""
    local callback = config.Callback or function() end
    
    -- Clamp default value
    local value = math.clamp(default, min, max)
    
    -- Format number dengan decimal places
    local function formatNumber(num)
        if decimalPlaces == 0 then
            return tostring(math.floor(num))
        else
            return string.format("%." .. decimalPlaces .. "f", num)
        end
    end
    
    -- 🧱 Container utama (BACKGROUND TRANSPARAN PENUH)
    local container = Utils:CreateGlassFrame(parent, {
        Color = Theme.Colors.Surface,
        Transparency = 1, -- ✅ FULLY TRANSPARENT
        Size = UDim2.new(1, 0, 0, subtitle and Theme.GetResponsiveSize(60, 65, 70) or Theme.Sizes.ButtonHeight),
        CornerRadius = Theme.Sizes.CornerRadiusSmall,
        StrokeColor = Theme.Colors.Border,
        StrokeTransparency = 0.7
    })
    
    Utils:CreatePadding(container, Theme.Sizes.Padding)
    
    -- LEFT SIDE: Text Container (Title + Subtitle)
    local textContainer = Instance.new("Frame")
    textContainer.BackgroundTransparency = 1
    textContainer.Size = UDim2.new(1, -Theme.GetResponsiveSize(130, 145, 160), 1, 0)
    textContainer.Position = UDim2.new(0, 0, 0, 0)
    textContainer.Parent = container
    
    -- Title Label
    Utils:CreateText(textContainer, title, {
        Font = Theme.Fonts.Primary,
        TextSize = Theme.GetResponsiveSize(13, 14, 15),
        TextColor = Theme.Colors.TextPrimary,
        Position = UDim2.new(0, 0, 0, subtitle and Theme.GetResponsiveSize(6, 7, 8) or 0),
        TextYAlignment = subtitle and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,
        Size = UDim2.new(1, 0, 1, 0),
        TextScaled = IsMobile
    })
    
    -- Subtitle Label
    if subtitle then
        Utils:CreateText(textContainer, subtitle, {
            Font = Theme.Fonts.Secondary,
            TextSize = Theme.GetResponsiveSize(10, 11, 12),
            TextColor = Theme.Colors.TextSecondary,
            Position = UDim2.new(0, 0, 0, Theme.GetResponsiveSize(26, 28, 32)),
            TextYAlignment = Enum.TextYAlignment.Top,
            Size = UDim2.new(1, 0, 1, 0),
            TextScaled = IsMobile
        })
    end
    
    -- RIGHT SIDE: Input Container (Buttons + TextBox)
    local inputWidth = Theme.GetResponsiveSize(150, 165, 180)
    local inputHeight = Theme.GetResponsiveSize(34, 38, 42)
    
    local inputContainer = Instance.new("Frame")
    inputContainer.BackgroundTransparency = 1
    inputContainer.Size = UDim2.new(0, inputWidth, 0, inputHeight)
    inputContainer.Position = UDim2.new(1, -inputWidth, 0.5, -inputHeight/2)
    inputContainer.Parent = container
    
    local buttonWidth = Theme.GetResponsiveSize(32, 35, 38)
    local spacing = Theme.GetResponsiveSize(4, 5, 6)
    
    -- Decrement Button (-) - TRANSPARAN
    local decrementBtn = Utils:CreateGlassFrame(inputContainer, {
        Color = Theme.Colors.AccentPrimary,
        Transparency = 1, -- ✅ FULLY TRANSPARENT
        Size = UDim2.new(0, buttonWidth, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        CornerRadius = Theme.Sizes.CornerRadiusSmall,
        StrokeColor = Theme.Colors.AccentPrimary,
        StrokeTransparency = 0.5
    })
    
    Utils:CreateText(decrementBtn, "−", {
        Font = Theme.Fonts.Primary,
        TextSize = Theme.GetResponsiveSize(16, 18, 20),
        TextColor = Theme.Colors.TextPrimary,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center
    })
    
    -- Input Frame (Middle) - TRANSPARAN
    local middleWidth = inputWidth - (buttonWidth * 2 + spacing * 2)
    
    local inputFrame = Utils:CreateGlassFrame(inputContainer, {
        Color = Theme.Colors.SurfaceLight,
        Transparency = 1, -- ✅ FULLY TRANSPARENT
        Size = UDim2.new(0, middleWidth, 1, 0),
        Position = UDim2.new(0, buttonWidth + spacing, 0, 0),
        CornerRadius = Theme.Sizes.CornerRadiusSmall,
        StrokeColor = Theme.Colors.AccentPrimary,
        StrokeTransparency = 0.8
    })
    
    Utils:CreatePadding(inputFrame, {
        Left = Theme.GetResponsiveSize(4, 5, 6),
        Right = Theme.GetResponsiveSize(4, 5, 6),
        Top = 0,
        Bottom = 0
    })
    
    -- TextBox untuk input manual
    local textBox = Instance.new("TextBox")
    textBox.BackgroundTransparency = 1
    textBox.Size = UDim2.new(1, suffix ~= "" and -Theme.GetResponsiveSize(18, 20, 22) or 0, 1, 0)
    textBox.Font = Theme.Fonts.Primary
    textBox.TextSize = Theme.GetResponsiveSize(12, 13, 14)
    textBox.TextColor3 = Theme.Colors.TextPrimary
    textBox.PlaceholderText = formatNumber(value)
    textBox.PlaceholderColor3 = Theme.Colors.TextTertiary
    textBox.Text = formatNumber(value)
    textBox.TextXAlignment = Enum.TextXAlignment.Center
    textBox.TextYAlignment = Enum.TextYAlignment.Center
    textBox.ClearTextOnFocus = false
    textBox.ZIndex = 5
    textBox.Parent = inputFrame
    
    -- Suffix Label (jika ada)
    local suffixLabel
    if suffix ~= "" then
        suffixLabel = Utils:CreateText(inputFrame, suffix, {
            Font = Theme.Fonts.Secondary,
            TextSize = Theme.GetResponsiveSize(10, 11, 12),
            TextColor = Theme.Colors.TextSecondary,
            Position = UDim2.new(1, -Theme.GetResponsiveSize(18, 20, 22), 0, 0),
            Size = UDim2.new(0, Theme.GetResponsiveSize(18, 20, 22), 1, 0),
            TextXAlignment = Enum.TextXAlignment.Right,
            TextYAlignment = Enum.TextYAlignment.Center
        })
    end
    
    -- Increment Button (+) - TRANSPARAN
    local incrementBtn = Utils:CreateGlassFrame(inputContainer, {
        Color = Theme.Colors.AccentPrimary,
        Transparency = 1, -- ✅ FULLY TRANSPARENT
        Size = UDim2.new(0, buttonWidth, 1, 0),
        Position = UDim2.new(1, -buttonWidth, 0, 0),
        CornerRadius = Theme.Sizes.CornerRadiusSmall,
        StrokeColor = Theme.Colors.AccentPrimary,
        StrokeTransparency = 0.5
    })
    
    Utils:CreateText(incrementBtn, "+", {
        Font = Theme.Fonts.Primary,
        TextSize = Theme.GetResponsiveSize(16, 18, 20),
        TextColor = Theme.Colors.TextPrimary,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center
    })
    
    -- Update value function (FREE INPUT VERSION)
    local function updateValue(newValue, useIncrement)
        newValue = tonumber(newValue) or value
        newValue = math.clamp(newValue, min, max)
        
        -- Jika dari button +/-, round ke increment
        -- Jika manual input, bebas (sesuai decimal places)
        if useIncrement then
            local steps = math.floor((newValue - min) / increment + 0.5)
            newValue = min + (steps * increment)
        end
        
        -- Round to decimal places
        local multiplier = 10 ^ decimalPlaces
        newValue = math.floor(newValue * multiplier + 0.5) / multiplier
        
        value = newValue
        textBox.Text = formatNumber(value)
        callback(value)
    end
    
    -- Decrement Button Click
    local decrementClickBtn = Instance.new("TextButton")
    decrementClickBtn.Size = UDim2.new(1, 0, 1, 0)
    decrementClickBtn.BackgroundTransparency = 1
    decrementClickBtn.Text = ""
    decrementClickBtn.ZIndex = 10
    decrementClickBtn.Parent = decrementBtn
    
    decrementClickBtn.MouseButton1Click:Connect(function()
        local newValue = value - increment
        updateValue(newValue, true)
        Animator:Bounce(decrementBtn, 0.9)
        
        pcall(function()
            local pos = Vector2.new(decrementBtn.AbsoluteSize.X / 2, decrementBtn.AbsoluteSize.Y / 2)
            Animator:Ripple(decrementBtn, pos, Theme.Colors.NeonCyan)
        end)
    end)
    
    -- Increment Button Click
    local incrementClickBtn = Instance.new("TextButton")
    incrementClickBtn.Size = UDim2.new(1, 0, 1, 0)
    incrementClickBtn.BackgroundTransparency = 1
    incrementClickBtn.Text = ""
    incrementClickBtn.ZIndex = 10
    incrementClickBtn.Parent = incrementBtn
    
    incrementClickBtn.MouseButton1Click:Connect(function()
        local newValue = value + increment
        updateValue(newValue, true)
        Animator:Bounce(incrementBtn, 0.9)
        
        pcall(function()
            local pos = Vector2.new(incrementBtn.AbsoluteSize.X / 2, incrementBtn.AbsoluteSize.Y / 2)
            Animator:Ripple(incrementBtn, pos, Theme.Colors.NeonPink)
        end)
    end)
    
    -- TextBox Manual Input (FREE - TANPA increment)
    textBox.FocusLost:Connect(function()
        updateValue(textBox.Text, false)
        
        local stroke = inputFrame:FindFirstChildOfClass("UIStroke")
        if stroke then
            Animator:Tween(stroke, {Transparency = 0.8, Color = Theme.Colors.AccentPrimary}, Theme.Animations.Fast)
        end
    end)
    
    textBox.Focused:Connect(function()
        -- Highlight stroke saat focus
        local stroke = inputFrame:FindFirstChildOfClass("UIStroke")
        if stroke then
            Animator:Tween(stroke, {Transparency = 0.3, Color = Theme.Colors.NeonCyan}, Theme.Animations.Fast)
        end
    end)
    
    -- 🌈 Hover Effects (Desktop only) - ANIMASI BORDER AJA
    if not IsMobile then
        -- Decrement button hover
        decrementClickBtn.MouseEnter:Connect(function()
            local stroke = decrementBtn:FindFirstChildOfClass("UIStroke")
            if stroke then
                Animator:Tween(stroke, {Transparency = 0.2, Color = Theme.Colors.NeonCyan}, Theme.Animations.Fast)
            end
        end)
        
        decrementClickBtn.MouseLeave:Connect(function()
            local stroke = decrementBtn:FindFirstChildOfClass("UIStroke")
            if stroke then
                Animator:Tween(stroke, {Transparency = 0.5, Color = Theme.Colors.AccentPrimary}, Theme.Animations.Fast)
            end
        end)
        
        -- Increment button hover
        incrementClickBtn.MouseEnter:Connect(function()
            local stroke = incrementBtn:FindFirstChildOfClass("UIStroke")
            if stroke then
                Animator:Tween(stroke, {Transparency = 0.2, Color = Theme.Colors.NeonPink}, Theme.Animations.Fast)
            end
        end)
        
        incrementClickBtn.MouseLeave:Connect(function()
            local stroke = incrementBtn:FindFirstChildOfClass("UIStroke")
            if stroke then
                Animator:Tween(stroke, {Transparency = 0.5, Color = Theme.Colors.AccentPrimary}, Theme.Animations.Fast)
            end
        end)
        
        -- Container hover - BORDER AJA
        local containerStroke = container:FindFirstChildOfClass("UIStroke")
        if containerStroke then
            local hoverConnection, leaveConnection
            
            hoverConnection = container.MouseEnter:Connect(function()
                Animator:Tween(containerStroke, {Transparency = 0.3, Color = Theme.Colors.AccentPrimary}, Theme.Animations.Fast)
            end)
            
            leaveConnection = container.MouseLeave:Connect(function()
                Animator:Tween(containerStroke, {Transparency = 0.7, Color = Theme.Colors.Border}, Theme.Animations.Fast)
            end)
        end
    end
    
    return container
end

-- ========================================
-- COLLAPSIBLE SECTION V2.0 - VyperUI V4.0
-- Ultra-Modern Glassmorphic Accordion
-- Fully Compatible with VyperUI Neon Theme
-- ========================================

function Components:CreateCollapsibleSection(parent, config)
    config = config or {}
    local title = config.Title or "Section"
    local defaultExpanded = config.DefaultExpanded or false
    local accentColor = config.AccentColor or Theme.Colors.AccentPrimary
    
    local isExpanded = defaultExpanded
    local headerHeight = Theme.GetResponsiveSize(48, 52, 56)
    
    -- ========== MAIN CONTAINER (BACKGROUND TRANSPARAN PENUH) ==========
    local sectionContainer = Utils:CreateGlassFrame(parent, {
        Color = Theme.Colors.GlassMid,
        Transparency = 1, -- ✅ FULLY TRANSPARENT
        Size = UDim2.new(1, 0, 0, headerHeight),
        CornerRadius = Theme.Sizes.CornerRadius,
        StrokeColor = accentColor,
        StrokeTransparency = 0.7
    })
    sectionContainer.Name = "CollapsibleSection_" .. title
    sectionContainer.ClipsDescendants = false
    
    -- ========== HEADER AREA ==========
    local headerArea = Instance.new("Frame")
    headerArea.Name = "HeaderArea"
    headerArea.BackgroundTransparency = 1
    headerArea.Size = UDim2.new(1, 0, 0, headerHeight)
    headerArea.Parent = sectionContainer
    
    Utils:CreatePadding(headerArea, {
        Left = Theme.Sizes.Padding,
        Right = Theme.Sizes.Padding,
        Top = Theme.Sizes.PaddingSmall,
        Bottom = Theme.Sizes.PaddingSmall
    })
    
    -- ========== ARROW ICON ==========
    local arrowIcon = Utils:CreateIcon(headerArea, "▶", {
        Size = Theme.GetResponsiveSize(14, 16, 18),
        Color = accentColor,
        Position = UDim2.new(0, 0, 0.5, -Theme.GetResponsiveSize(7, 8, 9))
    })
    arrowIcon.Name = "ArrowIcon"
    arrowIcon.Rotation = defaultExpanded and 90 or 0
    
    -- ========== TITLE TEXT ==========
    local titleLabel = Utils:CreateText(headerArea, title, {
        Font = Theme.Fonts.Primary,
        TextSize = Theme.GetResponsiveSize(13, 14, 15),
        TextColor = Theme.Colors.TextPrimary,
        Position = UDim2.new(0, Theme.GetResponsiveSize(28, 32, 36), 0, 0),
        Size = UDim2.new(1, -Theme.GetResponsiveSize(56, 64, 72), 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center
    })
    
    -- ========== ITEM COUNTER BADGE (TRANSPARAN) ==========
    local itemBadge = Utils:CreateGlassFrame(headerArea, {
        Color = accentColor,
        Transparency = 1, -- ✅ FULLY TRANSPARENT
        Size = UDim2.new(0, Theme.GetResponsiveSize(28, 30, 32), 0, Theme.GetResponsiveSize(22, 24, 26)),
        Position = UDim2.new(1, -Theme.GetResponsiveSize(34, 38, 42), 0.5, -Theme.GetResponsiveSize(11, 12, 13)),
        CornerRadius = Theme.GetResponsiveSize(11, 12, 13),
        StrokeColor = accentColor,
        StrokeTransparency = 0.4
    })
    itemBadge.Name = "ItemBadge"
    itemBadge.Visible = false
    
    local badgeText = Utils:CreateText(itemBadge, "0", {
        Font = Theme.Fonts.Primary,
        TextSize = Theme.GetResponsiveSize(10, 11, 12),
        TextColor = Theme.Colors.TextPrimary,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center
    })
    badgeText.Name = "BadgeCount"
    
    -- ========== HEADER BUTTON ==========
    local headerButton = Instance.new("TextButton")
    headerButton.Size = UDim2.new(1, 0, 1, 0)
    headerButton.BackgroundTransparency = 1
    headerButton.Text = ""
    headerButton.ZIndex = 10
    headerButton.Parent = headerArea
    
    -- ========== CONTENT WRAPPER (DALAM CONTAINER YANG SAMA) ==========
    local contentWrapper = Instance.new("Frame")
    contentWrapper.Name = "ContentWrapper"
    contentWrapper.BackgroundTransparency = 1
    contentWrapper.Size = UDim2.new(1, 0, 0, 0)
    contentWrapper.Position = UDim2.new(0, 0, 0, headerHeight)
    contentWrapper.ClipsDescendants = true
    contentWrapper.Visible = defaultExpanded
    contentWrapper.Parent = sectionContainer
    
    -- ========== SCROLLING FRAME ==========
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = "ContentFrame"
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.Size = UDim2.new(1, -Theme.Sizes.Padding * 2, 1, -Theme.Sizes.Padding)
    contentFrame.Position = UDim2.new(0, Theme.Sizes.Padding, 0, 0)
    contentFrame.ScrollBarThickness = 3
    contentFrame.ScrollBarImageColor3 = accentColor
    contentFrame.ScrollBarImageTransparency = 0.5
    contentFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentFrame.ZIndex = 5
    contentFrame.Parent = contentWrapper
    
    -- List Layout
    local contentList = Utils:CreateListLayout(contentFrame, {
        Padding = Theme.Sizes.Spacing,
        HorizontalAlignment = Enum.HorizontalAlignment.Left
    })
    
    Utils:CreatePadding(contentFrame, {
        Left = Theme.Sizes.PaddingSmall,
        Right = Theme.Sizes.PaddingSmall,
        Top = Theme.Sizes.PaddingSmall,
        Bottom = Theme.Sizes.PaddingSmall
    })
    
    -- ========== DIVIDER LINE (PEMISAH HEADER & CONTENT) ==========
    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.BackgroundColor3 = accentColor
    divider.BackgroundTransparency = 0.8
    divider.BorderSizePixel = 0
    divider.Size = UDim2.new(1, -Theme.Sizes.Padding * 2, 0, 1)
    divider.Position = UDim2.new(0, Theme.Sizes.Padding, 0, headerHeight - 1)
    divider.Visible = defaultExpanded
    divider.Parent = sectionContainer
    
    -- ========== ITEM COUNTER ==========
    local function updateItemBadge()
        local itemCount = #contentFrame:GetChildren() - 2
        if itemCount > 0 then
            badgeText.Text = tostring(itemCount)
            itemBadge.Visible = true
        else
            itemBadge.Visible = false
        end
    end
    
    contentFrame.ChildAdded:Connect(updateItemBadge)
    contentFrame.ChildRemoved:Connect(updateItemBadge)
    
    -- ========== TOGGLE ANIMATION (SATU CONTAINER MEMANJANG) ==========
    local function toggleSection()
        isExpanded = not isExpanded
        
        -- Arrow rotation
        Animator:Tween(arrowIcon, {
            Rotation = isExpanded and 90 or 0
        }, Theme.Animations.Normal, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        if isExpanded then
            -- EXPAND - Container memanjang ke bawah
            contentWrapper.Visible = true
            divider.Visible = true
            
            task.wait(0.05)
            
            -- Calculate content height
            local contentCanvasHeight = contentList.AbsoluteContentSize.Y 
                + (Theme.Sizes.PaddingSmall * 2) 
                + Theme.Sizes.Padding
            
            local maxHeight = Theme.GetResponsiveSize(280, 320, 360)
            local displayHeight = math.min(contentCanvasHeight, maxHeight)
            
            -- Expand content wrapper
            Animator:Tween(contentWrapper, {
                Size = UDim2.new(1, 0, 0, displayHeight)
            }, Theme.Animations.Normal, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            
            -- Expand MAIN container (seamless)
            local totalHeight = headerHeight + displayHeight
            Animator:Tween(sectionContainer, {
                Size = UDim2.new(1, 0, 0, totalHeight)
            }, Theme.Animations.Normal, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        else
            -- COLLAPSE - Container menyusut
            divider.Visible = false
            
            Animator:Tween(contentWrapper, {
                Size = UDim2.new(1, 0, 0, 0)
            }, Theme.Animations.Normal, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function()
                contentWrapper.Visible = false
            end)
            
            Animator:Tween(sectionContainer, {
                Size = UDim2.new(1, 0, 0, headerHeight)
            }, Theme.Animations.Normal, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        end
    end
    
    -- ========== CLICK HANDLER ==========
    headerButton.MouseButton1Click:Connect(toggleSection)
    
    -- 🌈 HOVER - ANIMASI BORDER AJA (BACKGROUND TETEP TRANSPARAN)
    if not IsMobile then
        local stroke = sectionContainer:FindFirstChildOfClass("UIStroke")
        if stroke then
            headerButton.MouseEnter:Connect(function()
                Animator:Tween(stroke, {
                    Transparency = 0.3,
                    Color = accentColor
                }, Theme.Animations.Fast)
            end)
            
            headerButton.MouseLeave:Connect(function()
                Animator:Tween(stroke, {
                    Transparency = 0.7,
                    Color = accentColor
                }, Theme.Animations.Fast)
            end)
        end
    end
    
    -- ========== AUTO-EXPAND IF DEFAULT ==========
    if defaultExpanded then
        task.defer(function()
            task.wait(0.15)
            
            local contentCanvasHeight = contentList.AbsoluteContentSize.Y 
                + (Theme.Sizes.PaddingSmall * 2) 
                + Theme.Sizes.Padding
            
            local maxHeight = Theme.GetResponsiveSize(280, 320, 360)
            local displayHeight = math.min(contentCanvasHeight, maxHeight)
            
            contentWrapper.Size = UDim2.new(1, 0, 0, displayHeight)
            
            local totalHeight = headerHeight + displayHeight
            sectionContainer.Size = UDim2.new(1, 0, 0, totalHeight)
        end)
    end

    return contentFrame
end




function Components:CreateTextParagraph(parent, config)
    config = config or {}
    local title = config.Title or "Information"
    local content = config.Content or "No content provided"
    local lines = config.Lines or {} -- Array of lines untuk multi-line
    
    -- Auto height calculation based on content
    local lineHeight = Theme.GetResponsiveSize(18, 19, 20)
    local numLines = #lines > 0 and #lines or 1
    local contentHeight = (numLines * lineHeight) + Theme.GetResponsiveSize(10, 12, 14)
    local totalHeight = Theme.GetResponsiveSize(40, 42, 44) + contentHeight
    
    -- 🧱 Main Container (BACKGROUND TRANSPARAN PENUH)
    local container = Utils:CreateGlassFrame(parent, {
        Color = Theme.Colors.Surface,
        Transparency = 1, -- ✅ FULLY TRANSPARENT
        Size = UDim2.new(1, 0, 0, totalHeight),
        CornerRadius = Theme.Sizes.CornerRadiusSmall,
        StrokeColor = Theme.Colors.Border,
        StrokeTransparency = 0.7
    })
    
    Utils:CreatePadding(container, Theme.Sizes.Padding)
    
    -- Title Section
    local titleLabel = Utils:CreateText(container, title, {
        Font = Theme.Fonts.Primary,
        TextSize = Theme.GetResponsiveSize(14, 15, 16),
        TextColor = Theme.Colors.TextPrimary,
        Size = UDim2.new(1, 0, 0, 22),
        Position = UDim2.new(0, 0, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Content Container (Scrollable for long text)
    local contentContainer = Instance.new("ScrollingFrame")
    contentContainer.BackgroundTransparency = 1
    contentContainer.Size = UDim2.new(1, 0, 1, -28)
    contentContainer.Position = UDim2.new(0, 0, 0, 28)
    contentContainer.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
    contentContainer.ScrollBarThickness = 4
    contentContainer.ScrollBarImageColor3 = Theme.Colors.AccentPrimary
    contentContainer.BorderSizePixel = 0
    contentContainer.Parent = container
    
    -- If using Lines array (for multiple lines)
    if #lines > 0 then
        for i, line in ipairs(lines) do
            local lineLabel = Utils:CreateText(contentContainer, line, {
                Font = Theme.Fonts.Secondary,
                TextSize = Theme.GetResponsiveSize(12, 13, 14),
                TextColor = Theme.Colors.TextSecondary,
                Size = UDim2.new(1, -10, 0, lineHeight),
                Position = UDim2.new(0, 0, 0, (i - 1) * lineHeight),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top
            })
        end
    else
        -- Single content text
        local contentLabel = Utils:CreateText(contentContainer, content, {
            Font = Theme.Fonts.Secondary,
            TextSize = Theme.GetResponsiveSize(12, 13, 14),
            TextColor = Theme.Colors.TextSecondary,
            Size = UDim2.new(1, -10, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true
        })
    end
    
    -- 🌈 Hover effect (Desktop only) - ANIMASI BORDER AJA
    if not IsMobile then
        local stroke = container:FindFirstChildOfClass("UIStroke")
        if stroke then
            local hoverConnection, leaveConnection
            
            hoverConnection = container.MouseEnter:Connect(function()
                Animator:Tween(stroke, {
                    Transparency = 0.3,
                    Color = Theme.Colors.AccentPrimary
                }, Theme.Animations.Fast)
            end)
            
            leaveConnection = container.MouseLeave:Connect(function()
                Animator:Tween(stroke, {
                    Transparency = 0.7,
                    Color = Theme.Colors.Border
                }, Theme.Animations.Fast)
            end)
        end
    end
    
    return container
end

function Components:CreateMultiDropdown(parent, config)
    config = config or {}
    local title = config.Title or "Multi Dropdown"
    local subtitle = config.Subtitle
    local options = config.Options or {"Option 1", "Option 2", "Option 3"}
    local default = config.Default or {} -- Array of selected options
    local callback = config.Callback or function() end

    local closedHeight = subtitle and Theme.GetResponsiveSize(85,90,95) or Theme.GetResponsiveSize(70,75,80)
    local optionHeight = Theme.GetResponsiveSize(42,46,50)
    local maxVisible = 5

    local expandedHeight = math.min(#options, maxVisible) * optionHeight + 10
    local scrollHeight = #options > maxVisible and (maxVisible * optionHeight + 10) or (#options * optionHeight + 10)

    -- Selected items tracking
    local selectedItems = {}
    for _, item in ipairs(default) do
        selectedItems[item] = true
    end

    -- Container utama TRANSPARAN
    local container = Utils:CreateGlassFrame(parent, {
        Color = Theme.Colors.Surface,
        Transparency = 1,
        Size = UDim2.new(1, 0, 0, closedHeight),
        CornerRadius = Theme.Sizes.CornerRadiusSmall,
        StrokeColor = Theme.Colors.AccentPrimary,
        StrokeTransparency = 0.7,
        ClipsDescendants = true,
    })
    Utils:CreatePadding(container, Theme.Sizes.PaddingSmall)

    Utils:CreateText(container, title, {
        Font = Theme.Fonts.Primary,
        TextSize = Theme.GetResponsiveSize(14,15,16),
        TextColor = Theme.Colors.TextPrimary,
        TextYAlignment = Enum.TextYAlignment.Top
    })
    
    if subtitle then
        Utils:CreateText(container, subtitle, {
            Font = Theme.Fonts.Secondary,
            TextSize = Theme.GetResponsiveSize(11,12,13),
            TextColor = Theme.Colors.TextSecondary,
            Position = UDim2.new(0,0,0,Theme.GetResponsiveSize(26,28,30)),
            TextYAlignment = Enum.TextYAlignment.Top
        })
    end

    -- Helper function to get display text
    local function GetDisplayText()
        local selected = {}
        for item, isSelected in pairs(selectedItems) do
            if isSelected then
                table.insert(selected, item)
            end
        end
        
        if #selected == 0 then
            return "Select options..."
        elseif #selected == 1 then
            return selected[1]
        elseif #selected == 2 then
            return selected[1] .. ", " .. selected[2]
        else
            return selected[1] .. ", " .. selected[2] .. " (+" .. (#selected - 2) .. ")"
        end
    end

    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Size = UDim2.new(1,-10,0,Theme.GetResponsiveSize(34,38,42))
    dropdownButton.Position = UDim2.new(0,0,0,Theme.GetResponsiveSize(42,46,50))
    dropdownButton.BackgroundTransparency = 1
    dropdownButton.Text = GetDisplayText()
    dropdownButton.TextColor3 = Theme.Colors.TextPrimary
    dropdownButton.Font = Theme.Fonts.Primary
    dropdownButton.TextSize = Theme.GetResponsiveSize(14,15,16)
    dropdownButton.TextXAlignment = Enum.TextXAlignment.Left
    dropdownButton.ZIndex = 10
    dropdownButton.Parent = container

    local arrow = Instance.new("TextLabel")
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.Font = Enum.Font.GothamBold
    arrow.TextColor3 = Theme.Colors.NeonCyan
    arrow.TextSize = Theme.GetResponsiveSize(16,18,20)
    arrow.AnchorPoint = Vector2.new(1,0.5)
    arrow.Position = UDim2.new(1,-8,0.5,0)
    arrow.ZIndex = 11
    arrow.Parent = dropdownButton

    -- Dropdown frame
    local dropdownFrame = Instance.new("ScrollingFrame")
    dropdownFrame.Active = true
    dropdownFrame.ScrollBarThickness = 6
    dropdownFrame.ScrollBarImageColor3 = Theme.Colors.NeonCyan
    dropdownFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    dropdownFrame.CanvasSize = UDim2.new(0,0,0,0)
    dropdownFrame.BackgroundColor3 = Theme.Colors.GlassDark
    dropdownFrame.BackgroundTransparency = 0.15
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.Visible = false
    dropdownFrame.Size = UDim2.new(1,0,0,0)
    dropdownFrame.Position = UDim2.new(0,0,0,Theme.GetResponsiveSize(78,84,90))
    dropdownFrame.ZIndex = 9
    dropdownFrame.Parent = container

    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, Theme.Sizes.CornerRadiusSmall)
    dropdownCorner.Parent = dropdownFrame

    local dropdownStroke = Instance.new("UIStroke")
    dropdownStroke.Color = Theme.Colors.NeonCyan
    dropdownStroke.Thickness = 1
    dropdownStroke.Transparency = 0.5
    dropdownStroke.Parent = dropdownFrame

    local uiList = Instance.new("UIListLayout")
    uiList.Parent = dropdownFrame
    uiList.Padding = UDim.new(0,0)

    local dropdownPadding = Instance.new("UIPadding")
    dropdownPadding.PaddingBottom = UDim.new(0, 8)
    dropdownPadding.Parent = dropdownFrame

    local function RenderOptions(newOptions)
        for _, child in ipairs(dropdownFrame:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("Frame") then
                if child.Name:match("^Option") or child.Name == "Separator" then
                    child:Destroy()
                end
            end
        end

        for i, option in ipairs(newOptions) do
            local optionContainer = Instance.new("Frame")
            optionContainer.Name = "Option_" .. i
            optionContainer.BackgroundTransparency = 1
            optionContainer.Size = UDim2.new(1,0,0,optionHeight)
            optionContainer.ZIndex = 12
            optionContainer.Parent = dropdownFrame

            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1,-12,1,-4)
            optBtn.Position = UDim2.new(0,6,0,2)
            optBtn.BackgroundColor3 = Theme.Colors.Surface
            optBtn.BackgroundTransparency = 0.9
            optBtn.BorderSizePixel = 0
            optBtn.Text = ""
            optBtn.ZIndex = 13
            optBtn.Parent = optionContainer

            local optCorner = Instance.new("UICorner")
            optCorner.CornerRadius = UDim.new(0, Theme.Sizes.CornerRadiusSmall)
            optCorner.Parent = optBtn

            -- Checkbox instead of checkmark
            local checkbox = Instance.new("Frame")
            checkbox.BackgroundColor3 = Theme.Colors.Surface
            checkbox.BackgroundTransparency = 0.3
            checkbox.BorderSizePixel = 0
            checkbox.Size = UDim2.new(0,Theme.GetResponsiveSize(20,22,24),0,Theme.GetResponsiveSize(20,22,24))
            checkbox.Position = UDim2.new(0,Theme.GetResponsiveSize(8,10,12),0.5,0)
            checkbox.AnchorPoint = Vector2.new(0,0.5)
            checkbox.ZIndex = 15
            checkbox.Parent = optBtn

            local checkboxCorner = Instance.new("UICorner")
            checkboxCorner.CornerRadius = UDim.new(0, 4)
            checkboxCorner.Parent = checkbox

            local checkboxStroke = Instance.new("UIStroke")
            checkboxStroke.Color = selectedItems[option] and Theme.Colors.NeonCyan or Theme.Colors.Border
            checkboxStroke.Thickness = 2
            checkboxStroke.Transparency = 0.3
            checkboxStroke.Parent = checkbox

            local checkmark = Instance.new("TextLabel")
            checkmark.BackgroundTransparency = 1
            checkmark.Text = "✓"
            checkmark.Font = Enum.Font.GothamBold
            checkmark.TextColor3 = Theme.Colors.NeonCyan
            checkmark.TextSize = Theme.GetResponsiveSize(14,16,18)
            checkmark.Size = UDim2.new(1,0,1,0)
            checkmark.TextXAlignment = Enum.TextXAlignment.Center
            checkmark.TextYAlignment = Enum.TextYAlignment.Center
            checkmark.Visible = selectedItems[option] or false
            checkmark.ZIndex = 16
            checkmark.Parent = checkbox

            local optText = Instance.new("TextLabel")
            optText.BackgroundTransparency = 1
            optText.Text = option
            optText.Font = Theme.Fonts.Primary
            optText.TextSize = Theme.GetResponsiveSize(13,14,15)
            optText.TextColor3 = selectedItems[option] and Theme.Colors.NeonCyan or Theme.Colors.TextPrimary
            optText.Size = UDim2.new(1,-Theme.GetResponsiveSize(44,48,52),1,0)
            optText.Position = UDim2.new(0,Theme.GetResponsiveSize(40,44,48),0,0)
            optText.TextXAlignment = Enum.TextXAlignment.Left
            optText.TextYAlignment = Enum.TextYAlignment.Center
            optText.ZIndex = 14
            optText.Parent = optBtn

            optBtn.MouseEnter:Connect(function()
                TweenService:Create(optBtn, TweenInfo.new(0.2), {
                    BackgroundTransparency = 0.5,
                    BackgroundColor3 = Theme.Colors.AccentPrimary
                }):Play()
            end)
            
            optBtn.MouseLeave:Connect(function()
                TweenService:Create(optBtn, TweenInfo.new(0.2), {
                    BackgroundTransparency = 0.9,
                    BackgroundColor3 = Theme.Colors.Surface
                }):Play()
            end)

            optBtn.MouseButton1Click:Connect(function()
                -- Toggle selection
                selectedItems[option] = not selectedItems[option]
                
                -- Update checkbox visual
                checkmark.Visible = selectedItems[option]
                TweenService:Create(checkboxStroke, TweenInfo.new(0.2), {
                    Color = selectedItems[option] and Theme.Colors.NeonCyan or Theme.Colors.Border
                }):Play()
                TweenService:Create(optText, TweenInfo.new(0.2), {
                    TextColor3 = selectedItems[option] and Theme.Colors.NeonCyan or Theme.Colors.TextPrimary
                }):Play()

                if selectedItems[option] then
                    TweenService:Create(checkbox, TweenInfo.new(0.2), {
                        BackgroundColor3 = Theme.Colors.NeonCyan,
                        BackgroundTransparency = 0.7
                    }):Play()
                else
                    TweenService:Create(checkbox, TweenInfo.new(0.2), {
                        BackgroundColor3 = Theme.Colors.Surface,
                        BackgroundTransparency = 0.3
                    }):Play()
                end

                Animator:Bounce(checkbox, 0.9)

                -- Update display text
                dropdownButton.Text = GetDisplayText()

                -- Get all selected items as array
                local selected = {}
                for item, isSelected in pairs(selectedItems) do
                    if isSelected then
                        table.insert(selected, item)
                    end
                end

                -- Call callback with array of selected items
                callback(selected)
            end)

            if i < #newOptions then
                local separator = Instance.new("Frame")
                separator.Name = "Separator"
                separator.BackgroundColor3 = Theme.Colors.Border
                separator.BackgroundTransparency = 0.7
                separator.BorderSizePixel = 0
                separator.Size = UDim2.new(1,-24,0,1)
                separator.Position = UDim2.new(0,12,1,-1)
                separator.ZIndex = 12
                separator.Parent = optionContainer
            end
        end

        scrollHeight = #newOptions > maxVisible and (maxVisible * optionHeight + 10) or (#newOptions * optionHeight + 10)
    end

    RenderOptions(options)

    dropdownButton.MouseButton1Click:Connect(function()
        if dropdownFrame.Visible then
            TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(1,0,0,closedHeight)
            }):Play()
            TweenService:Create(dropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(1,0,0,0)
            }):Play()
            TweenService:Create(arrow, TweenInfo.new(0.2), {
                Rotation = 0,
                TextColor3 = Theme.Colors.NeonCyan
            }):Play()
            
            task.wait(0.3)
            dropdownFrame.Visible = false
        else
            dropdownFrame.Visible = true
            TweenService:Create(arrow, TweenInfo.new(0.2), {
                Rotation = 180,
                TextColor3 = Theme.Colors.NeonPink
            }):Play()
            TweenService:Create(container, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(1,0,0,closedHeight + scrollHeight + 12)
            }):Play()
            TweenService:Create(dropdownFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(1,0,0,scrollHeight)
            }):Play()
            
            TweenService:Create(dropdownStroke, TweenInfo.new(0.3), {
                Transparency = 0.3
            }):Play()
        end
    end)

    return {
        Container = container,
        
        UpdateOptions = function(self, newOptions, newDefault)
            options = newOptions or options
            
            if newDefault then
                selectedItems = {}
                for _, item in ipairs(newDefault) do
                    selectedItems[item] = true
                end
            end
            
            dropdownButton.Text = GetDisplayText()
            RenderOptions(options)
        end,

        GetSelected = function(self)
            local selected = {}
            for item, isSelected in pairs(selectedItems) do
                if isSelected then
                    table.insert(selected, item)
                end
            end
            return selected
        end,

        SetSelected = function(self, items)
            selectedItems = {}
            for _, item in ipairs(items) do
                selectedItems[item] = true
            end
            dropdownButton.Text = GetDisplayText()
            RenderOptions(options)
        end,

        ClearSelection = function(self)
            selectedItems = {}
            dropdownButton.Text = GetDisplayText()
            RenderOptions(options)
        end,
        
        Destroy = function(self)
            container:Destroy()
        end
    }
end

-- ========================================
-- ADD TO VyperUI MAIN LIBRARY
-- ========================================


-- ========================================
-- MAIN LIBRARY V4.0
-- ========================================

local VyperUI = {}

function VyperUI:CreateWindow(config)
    return Window.new(config)
end

function VyperUI:CreateButton(parent, config)
    return Components:CreateButton(parent, config)
end

function VyperUI:CreateToggle(parent, config)
    return Components:CreateToggle(parent, config)
end

function VyperUI:CreateDropdown(parent, config)
    return Components:CreateDropdown(parent, config)
end



function VyperUI:CreateSlider(parent, config)
    return Components:CreateSlider(parent, config)
end

function VyperUI:CreateTextBox(parent, config)
    return Components:CreateTextBox(parent, config)
end

function VyperUI:CreateLabel(parent, config)
    return Components:CreateLabel(parent, config)
end

function VyperUI:CreateSection(parent, title)
    return Components:CreateSection(parent, title)
end


function VyperUI:CreateNumericInput(parent, config)
    return Components:CreateNumericInput(parent, config)
end

function VyperUI:CreateCollapsibleSection(parent, config)
    return Components:CreateCollapsibleSection(parent, config)
end

function VyperUI:CreateTextParagraph(parent, config)
    return Components:CreateTextParagraph(parent, config)
end

function VyperUI:CreateMultiDropdown(parent, config)
    return Components:CreateMultiDropdown(parent, config)
end

getgenv().VyperUI = VyperUI
_G.VyperUI = VyperUI

print([[
═══════════════════════════════════════════════════════════════
  ██╗   ██╗██╗   ██╗██████╗ ███████╗██████╗     ██╗   ██╗██╗  ██╗
  ██║   ██║╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗    ██║   ██║██║  ██║
  ██║   ██║ ╚████╔╝ ██████╔╝█████╗  ██████╔╝    ██║   ██║███████║
  ╚██╗ ██╔╝  ╚██╔╝  ██╔═══╝ ██╔══╝  ██╔══██╗    ██║   ██║╚════██║
   ╚████╔╝    ██║   ██║     ███████╗██║  ██║    ╚██████╔╝     ██║
    ╚═══╝     ╚═╝   ╚═╝     ╚══════╝╚═╝  ╚═╝     ╚═════╝      ╚═╝
                                                                   
  VyperUI V4.0 FINAL - Delta Executor Edition
  ✅ Library loaded successfully!
  
  ✨ Features:
  ✓ 100% Responsive Design
  ✓ Hide/Show Toggle Button (Topbar center)
  ✓ Collapsible Sidebar (Slide animation)
  ✓ Minimize to Draggable Logo (Bottom left)
  ✓ Smooth Animations (Spring, fade, bounce, slide)
  ✓ Delta Executor Compatible
  
  📝 Usage:
  local Window = VyperUI:CreateWindow({Title = "My UI"})
  local Tab = Window:CreateTab({Title = "Home", Icon = "🏠"})
  VyperUI:CreateButton(Tab, {Title = "Button", Callback = function() end})
  
  Author: yeremiaginting059
  Version: 4.0.0 - FINAL RELEASE
═══════════════════════════════════════════════════════════════
]])

return VyperUI
