-- CINEMATIC MONSTER CAMERA (VERTICAL ORBIT UPGRADE)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

--------------------------------------------------
-- MOUSE CONTROL
--------------------------------------------------
local yaw, pitch, zoomOffset = 0, 0, 0

UIS.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		yaw -= input.Delta.X * 0.002
		pitch -= input.Delta.Y * 0.002
		pitch = math.clamp(pitch, -0.7, 0.7)
	elseif input.UserInputType == Enum.UserInputType.MouseWheel then
		zoomOffset += input.Position.Z * 6
		zoomOffset = math.clamp(zoomOffset, -160, 160)
	end
end)

--------------------------------------------------
-- MONSTER DETECT
--------------------------------------------------
local function getMonster()
	local best, dist = nil, math.huge
	for _,m in pairs(workspace:GetChildren()) do
		if m:IsA("Model") and m.PrimaryPart then
			local d = (m.PrimaryPart.Position - hrp.Position).Magnitude
			if d < 180 and d < dist then
				best = m
				dist = d
			end
		end
	end

	if not best then
		return {
			center = hrp.Position + Vector3.new(0,40,0),
			size = 120,
			forward = Vector3.new(0,0,-1)
		}
	end

	local cf, size = best:GetBoundingBox()
	return {
		center = cf.Position,
		size = size.Magnitude,
		forward = cf.LookVector
	}
end

--------------------------------------------------
-- UI
--------------------------------------------------
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,250,0,90)
frame.Position = UDim2.new(0.02,0,0.5,-45)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "CINEMATIC MODE"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local minimized = false
local function setMin(v)
	minimized = v
	frame.Visible = not v
end

--------------------------------------------------
-- CORE GUI
--------------------------------------------------
local lockCore = false
RunService.RenderStepped:Connect(function()
	if lockCore then
		for _,t in pairs({
			Enum.CoreGuiType.Backpack,
			Enum.CoreGuiType.Chat,
			Enum.CoreGuiType.PlayerList,
			Enum.CoreGuiType.Health
		}) do
			pcall(function()
				StarterGui:SetCoreGuiEnabled(t,false)
			end)
		end
	end
end)

local function hideCore() lockCore = true end
local function showCore()
	lockCore = false
	for _,t in pairs({
		Enum.CoreGuiType.Backpack,
		Enum.CoreGuiType.Chat,
		Enum.CoreGuiType.PlayerList,
		Enum.CoreGuiType.Health
	}) do
		pcall(function()
			StarterGui:SetCoreGuiEnabled(t,true)
		end)
	end
end

--------------------------------------------------
-- FX
--------------------------------------------------
local dof, cc
local function fxOn()
	dof = Instance.new("DepthOfFieldEffect",Lighting)
	dof.FocusDistance = 200
	dof.InFocusRadius = 100
	dof.FarIntensity = 0.4

	cc = Instance.new("ColorCorrectionEffect",Lighting)
	cc.Contrast = 0.35
	cc.Saturation = -0.1
	cc.TintColor = Color3.fromRGB(220,235,255)
end

local function fxOff()
	if dof then dof:Destroy() dof=nil end
	if cc then cc:Destroy() cc=nil end
end

--------------------------------------------------
-- CINEMATIC ENGINE
--------------------------------------------------
local playing, loopMode = false, false
local seq, idx, t = {}, 1, 0
local fromPos, toPos, dur

local function build(mode)
	local m = getMonster()
	local d = m.size * 1.35
	local right = m.forward:Cross(Vector3.new(0,1,0)).Unit

	-- vertical arc values
	local high = Vector3.new(0, d*0.9, 0)
	local mid  = Vector3.new(0, d*0.55, 0)
	local low  = Vector3.new(0, d*0.25, 0)

	if mode == 1 then
		seq = {
			{m.center - m.forward*d + high, 8},   -- atas depan
			{m.center + right*d + mid, 8},        -- samping tengah
			{m.center + m.forward*d + low, 8},    -- bawah belakang
			{m.center - right*d + mid, 8},        -- samping naik
			{m.center - m.forward*d*1.4 + high, 10}
		}
	else
		seq = {
			{m.center - m.forward*d + high, 10},
			{m.center + right*d + mid, 10},
			{m.center + m.forward*d + low, 10},
			{m.center - right*d + mid, 10}
		}
	end
end

local function start(mode)
	if playing then return end
	playing = true
	loopMode = (mode==2)

	hideCore()
	fxOn()
	setMin(true)

	camera.CameraType = Enum.CameraType.Scriptable
	yaw, pitch, zoomOffset = 0, 0, 0

	build(mode)
	idx, t = 1, 0
	fromPos = camera.CFrame.Position
	toPos = seq[1][1]
	dur = seq[1][2]
end

--------------------------------------------------
-- CAMERA UPDATE
--------------------------------------------------
RunService:BindToRenderStep("CineCam", Enum.RenderPriority.Camera.Value+1, function(dt)
	if not playing then return end

	t += dt/dur
	if t > 1 then t = 1 end
	local smooth = math.sin(t*math.pi*0.5)

	local pos = fromPos:Lerp(toPos, smooth)
	local focus = getMonster().center + Vector3.new(0, getMonster().size*0.3, 0)

	camera.CFrame =
		CFrame.new(pos, focus)
		* CFrame.Angles(pitch, yaw, 0)
		* CFrame.new(0,0,zoomOffset)

	if t >= 1 then
		idx += 1
		if seq[idx] then
			fromPos = camera.CFrame.Position
			toPos = seq[idx][1]
			dur = seq[idx][2]
			t = 0
		elseif loopMode then
			idx = 1
			fromPos = camera.CFrame.Position
			toPos = seq[1][1]
			dur = seq[1][2]
			t = 0
		else
			playing = false
			camera.CameraType = Enum.CameraType.Custom
			fxOff()
			showCore()
			setMin(true)
		end
	end
end)

--------------------------------------------------
-- RESET & INPUT
--------------------------------------------------
local function resetAll()
	playing = false
	camera.CameraType = Enum.CameraType.Custom
	fxOff()
	showCore()
	setMin(true)
end

UIS.InputBegan:Connect(function(i,gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.KeypadOne then
		start(1)
	elseif i.KeyCode == Enum.KeyCode.KeypadTwo then
		start(2)
	elseif i.KeyCode == Enum.KeyCode.KeypadPlus then
		resetAll()
	elseif i.KeyCode == Enum.KeyCode.KeypadZero then
		setMin(not minimized)
	end
end)
