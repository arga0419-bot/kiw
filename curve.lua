-- LocalScript untuk Roblox (Simpan di StarterPlayerScripts atau jalankan via Executor)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- PENGATURAN ULTRA MAKSIMAL (Lengkungan Paling Jauh & Tajam)
local curveEnabled = false
local smoothness = 0.02      -- Super cepat (hampir instan membanting)
local tiltAmount = 0.65      -- Kemiringan layar (Roll) sangat ekstrem
local arcStrength = 0.70     -- Jarak lengkungan melebar (arc) dibuat maksimal
local overshoot = 0.35       -- Efek pantulan kejut saat pertama kali dibelokkan

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraCurveGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Tombol Utama (PC Ultra Curve)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "CurveToggle"
ToggleButton.Size = UDim2.new(0, 180, 0, 40)
ToggleButton.Position = UDim2.new(0.5, -90, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 24, 45)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "PC Ultra Curve: OFF"
ToggleButton.TextSize = 14
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleButton

-- Tombol Sembunyikan/Tampilkan Menu (Hide Button)
local HideButton = Instance.new("TextButton")
HideButton.Name = "HideButton"
HideButton.Size = UDim2.new(0, 35, 0, 35)
HideButton.Position = UDim2.new(0.5, 95, 0, 12)
HideButton.BackgroundColor3 = Color3.fromRGB(50, 40, 70)
HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HideButton.Text = "👁"
HideButton.TextSize = 16
HideButton.Font = Enum.Font.GothamBold
HideButton.Parent = ScreenGui

local HideCorner = Instance.new("UICorner")
HideCorner.CornerRadius = UDim.new(1, 0)
HideCorner.Parent = HideButton

local menuVisible = true
HideButton.MouseButton1Click:Connect(function()
	menuVisible = not menuVisible
	ToggleButton.Visible = menuVisible
	if menuVisible then
		HideButton.Text = "👁"
		HideButton.BackgroundColor3 = Color3.fromRGB(50, 40, 70)
	else
		HideButton.Text = "👁‍🗨"
		HideButton.BackgroundColor3 = Color3.fromRGB(100, 40, 40)
	end
end)

ToggleButton.MouseButton1Click:Connect(function()
	curveEnabled = not curveEnabled
	if curveEnabled then
		ToggleButton.Text = "PC Ultra Curve: ON"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 150)
	else
		ToggleButton.Text = "PC Ultra Curve: OFF"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 24, 45)
	end
end)

-- Variabel Perhitungan Ultra Curve
local currentCamCFrame = camera.CFrame
local lastLookVector = camera.CFrame.LookVector
local arcVelocity = Vector3.new(0, 0, 0)

RunService.RenderStepped:Connect(function(dt)
	local targetCFrame = camera.CFrame
	
	if not curveEnabled then
		currentCamCFrame = targetCFrame
		lastLookVector = targetCFrame.LookVector
		arcVelocity = Vector3.new(0, 0, 0)
		return
	end
	
	local currentLook = targetCFrame.LookVector
	local rightVector = targetCFrame.RightVector
	local turnDot = currentLook:Dot(lastLookVector)
	local sideDot = currentLook:Dot(rightVector)
	
	local tiltFactor = 0
	
	-- Deteksi belokan dengan ambang batas (threshold) yang sangat sensitif
	if turnDot < 0.98 then 
		tiltFactor = sideDot * tiltAmount
		-- Menembakkan kekuatan arc secara maksimal + efek kejut (overshoot)
		arcVelocity = arcVelocity + (rightVector * (sideDot * arcStrength)) + (currentLook * overshoot)
	end
	
	-- Peredaman diperlambat agar efek "membantingnya" berasa jauh dan melayang lama
	arcVelocity = arcVelocity:Lerp(Vector3.new(0, 0, 0), 0.06)
	
	-- Transisi kamera super cepat (hampir instan menyentak)
	currentCamCFrame = currentCamCFrame:Lerp(targetCFrame, smoothness)
	
	-- Menerapkan hasil banting ekstrem ke kamera
	camera.CFrame = (currentCamCFrame + arcVelocity) * CFrame.Angles(0, 0, tiltFactor)
	
	lastLookVector = currentLook
end)
