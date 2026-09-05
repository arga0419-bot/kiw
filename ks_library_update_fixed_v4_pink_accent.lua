-- 3. SCRIPT UTAMA
local function MainScript()
    -- LOAD
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local CollectionService = game:GetService("CollectionService")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local SkillCheckRemote = Remotes:WaitForChild("Generator"):WaitForChild("SkillCheckResultEvent")
local FlashlightFolder = Remotes:FindFirstChild("Items") and Remotes.Items:FindFirstChild("Flashlight")
local GotBlindedRemote = FlashlightFolder and FlashlightFolder:FindFirstChild("GotBlinded")
local InfiniteLungeEnabled = false

MoonwalkEnabled = false
BypassGenEnabled = false
BypassGenMode = "Manual Repair"
RepairAnimTrack = nil
ProcessedGens = {}
AutoRepairEnabled = false
AutoRepairThread = nil
AutoCurrentPoint = nil
AutoCurrentGenModel = nil
LastFireTime = 0
AutoFireInterval = 0.5
local TouchID        = 8822
local ActionPath     = "Survivor-mob.Controls.action.check"

isAimingFlash = false
FOVEnabled = false
TargetFOV = 90
GodMode = false
NoSlowdownEnabled = false
BypassGateEnabled = false
FleeKillerEnabled = false
FleeDistance = 40
FleeCooldown = 0

-- Variabel untuk Auto Skill Check
HeartbeatConnection = nil
VisibilityConnection = nil
currentTarget = nil

-- Variabel untuk Speed Boost
SpeedEnabled = false
SpeedAmount = 0.02
SpeedInputEnabled = false
SpeedInputValue = 0.1
SpeedInputConnection = nil

-- Variabel untuk Performance
FullBright = false
NoFog = false
NoShadow = false
TimeOfDayValue = 14

autoVaultEnabled = false
autoPalletSlideEnabled = false
lastActionTime = 0
COOLDOWN = 1.5


-- Variabel untuk Emote
EmoteEnabled = false
SelectedAnim = nil
SelectedSound = nil
currentTrack = nil
currentSound = nil

-- ===== HOOK COUNTER =====
local HookData = {}
local HookESPEnabled = false

-- Variabel ConfigData untuk skill check
ConfigData = {
    Surv_SkillFrequency = 10,
    Surv_SkillSpeed = 1
}

-- ==================== OPTIMIZED CACHE SYSTEM ====================
local Cache = { Visibility = {}, Generators = {}, Pallets = {}, Hooks = {}, Gates = {}, Windows = {}, SCPs = {} }


local Tuning = {
    Colors = { 
        SCP = Color3.fromRGB(255, 0, 255),
        Player = Color3.fromRGB(57, 255, 20),
        Killer = Color3.fromRGB(255, 40, 40),
        Generator = Color3.fromRGB(255, 255, 0),
        GeneratorDone = Color3.fromRGB(0, 255, 0),
        Pallet = Color3.fromRGB(255, 128, 0),
        Hook = Color3.fromRGB(255, 105, 180),
        Gate = Color3.fromRGB(0, 255, 255),
        Window = Color3.fromRGB(0, 200, 255)
    }
}

isAimbotHolding = false
lockedTarget = nil

-- [ VARIABEL AUTO PARRY & SILENT AIM ]
local Config = {
    Surv_AutoParry = false,
    Surv_ParrySafety = false,
    Surv_ParryAggressive = false,
    Surv_ParryCircle = true,
    Surv_ParryRadius = 15,
    Surv_ParryFace = 0.7,
    Ignored_Skills_List = {},
    Surv_VaultSpeed = 13,
    Surv_Perks = false,
    LockAim = false,
    Surv_PerfectVault = false,
    Killer_3rdPerson = false,
    Surv_Aimbot_Enabled = false,
    Surv_Aimbot_ShowFOV = true,
    Surv_Aimbot_Radius = 150,
    Surv_Aimbot_MaxDist = 300,
    Surv_Aimbot_Smoothness = 0.5,
    Surv_Aimbot_Predict = 0.01,
    Killer_Aimbot_Enabled = false,
    Killer_Aimbot_MaxDist = 12,
    Killer_Aimbot_Smoothness = 0.5,
    Misc_FakeName = false,
    Surv_AutoCrouch = false,
    Surv_CrouchV = false,
    InstantTPGate = false,
    GateClientModule = nil,
    oldGateNew = nil,
    oldGateCanUse = nil,
    HitSoundEnabled = false,
    HitSoundVolume = 1.0,
    HitSoundId = "rbxassetid://106225491596534",
    HitSoundCooldown = 0.3,
    HitSoundLastTime = 0,
    ESP_Master = false, ESP_Player = false, ESP_Outline = false, ESP_Name = false, ESP_GeneratorName = true, ESP_Distance = false, ESP_Killer = false, ESP_ItemIcon = false,
    ESP_Generator = false, ESP_Pallet = false, ESP_Hook = false, ESP_KillerWarn = false, ESP_Gate = false, ESP_Window = false, ESP_SCP = false
}

-- ==================== FAKE PERKS ====================
local FakePerks = {
    QuickRecoveryEnabled = false,
    PerfectLandingEnabled = false,
    FlowstateEnabled = false,
    
    PerkCooldown = 10,
    
    boostActive = false,
    perfectLandingBoostActive = false,
    fsOnCooldown = false,
    
    lastQRTime = 0,
    lastPLTime = 0,
    lastFSTime = 0,
    
    qrConnection = nil,
    plConnection = nil,
    fsConnection = nil,
    fsAnimConnection = nil,
}

local Crosshair = {
    Enabled   = false,
    Size      = 8,
    Thickness = 2,
    Color     = Color3.fromRGB(255, 255, 0),
    Style     = "Dot",
    OffsetX   = 0,
    OffsetY   = 0
}

local Connections = {
SkillHeartbeat = nil,
Stalk         = nil
}

local Auto = {
    SkillCheck       = false,
    SkillCheckMode   = "Legit",
}
-- Di bagian variabel (sekitar baris 30-60)
local Killer = {
BypassLeap = false,
    AntiBlind = false
}

local AutoStalk = {
    Enabled    = false,
    StalkRange = 150,
    Target     = nil
}

local AimConfig = {
    Aim_Silent = false,
    Pistol_BlockKnocked = false,
    Flash_Silent = false,
    Flash_YOffset = 1.5,
    LockAim = false,
    Pistol_Target = "Survivor",
    Pistol_FOVMode = false,
    Pistol_ShowFOV = false,
    Pistol_FOV = 150,
    Aim_SilentVeil = false,
    Aim_SilentVeilV2 = false,
    Veil_ShowFOV = true,
    SpearSmart_enable = false,
    Veil_FOV = 150,
    SPEAR_Speed = 165,
    SPEAR_Gravity = workspace.Gravity * 0.5,
    SPEAR_MaxDist = 200,
    Veil_LeadMultiplier = 1.4,
    AIM_Auto = false,
    AIM_TargetPart = "Torso",
    Killer_InfAbyssal = false
}

-- ===== VEIL VARIABLES =====
local isChargingSpear = false
local isAttackCooldown = false
local isFiringSpear = false   -- ← TAMBAH (untuk V2 biar tidak double)

local function IsVeilSilentOn()
    return AimConfig.Aim_SilentVeil or AimConfig.Aim_SilentVeilV2
end

-- ===== VEIL VISUAL =====
local veilTargetHighlight = Instance.new("Highlight")
veilTargetHighlight.Name = "VD_VeilTarget"
veilTargetHighlight.FillColor = Color3.fromRGB(255, 0, 0)
veilTargetHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
veilTargetHighlight.FillTransparency = 0.5
veilTargetHighlight.OutlineTransparency = 0

-- ===== VEIL VISUAL =====
local VeilTrackerEnabled = false

-- ===== SPEAR INTERCEPTOR =====
local SpearInterceptorHooked = false

local State = { 
    ParryCooldown = false,
    ParryCooldownTime = 60,
    busy                = false,
    created             = false,
    LastCrosshairStyle  = nil,
    AutoParryAdornment = nil,
    ThirdPersonConn = nil,
    SpooferConns = {},
    ItemESPs = {}
}
local CachedInstnScript = nil

local VALID_PARRY_IDS = {
    ["122812055447896"] = "Veil lunge",
    ["133963973694098"] = "Mayers Basic",
    ["117042998468241"] = "Mayers lunge",
    ["135002183282873"] = "cure lunge",
    ["121216847022485"] = "cure Basic",
    ["132817836308238"] = "Jeff Basic",
    ["129784271201071"] = "Jeff lunge",
    ["82666958311998"] = "Jeff Frenzy",
    ["78432063483146"] = "Abyssal Basic",
    ["118907603246885"] = "Abyssal lunge",
    ["139369275981139"] = "Jason Basic",
    ["110355011987939"] = "Jason lunge",
    ["111920872708571"] = "Masked Basic",
    ["105374834496520"] = "Masked lunge",
    ["138720291317243"] = "Masked Tony",
    ["106871536134254"] = "Masked Alex",
    ["130593238885843"] = "Masked Cobra",
    ["115244153053858"] = "Masked Cobra lunge",
    ["74968262036854"] = "Hidden Basic",
    ["113255068724446"] = "Hidden lunge",
    ["98163597193511"] = "Hidden S1",
    ["80411309607666"] = "Abyssal S1"
}

-- ===== ANTI AUTO PARRY - VARIABEL =====
AntiAutoParryEnabled = false
local ParryAnimList = {}
for id, _ in pairs(VALID_PARRY_IDS) do
    table.insert(ParryAnimList, id)
end

local CrosshairDrawings = {}

local Attached = {}
local armParts = {
    ["Left Arm"] = true, ["Right Arm"] = true,
    ["LeftHand"] = true, ["RightHand"] = true,
    ["LeftLowerArm"] = true, ["RightLowerArm"] = true,
    ["LeftUpperArm"] = true, ["RightUpperArm"] = true
}

local VD = getgenv().VD or {}
getgenv().VD = VD
VD.KILLER_SilentAimFlask = false
VD.KILLER_FlaskLaser      = false

getgenv().NEX_CureFlaskLaserThread = nil
getgenv().NEX_CureFlaskLaserPart   = nil

-- ===== INFINITE FRENZY =====
local VD = getgenv().VD or {}
getgenv().VD = VD
VD.KILLER_InfFrenzy = false

getgenv().NEX_JeffCooldownBypassThread = nil

-- ===== INFINITE PURSUIT JASON =====
VD.KILLER_InfPursuit = false
local InfPursuitThread = nil

-- ==================== AUTO DODGE VEIL (hemat local) ====================
local DodgeVeil = {
    Attached = {},
    lastTime = 0,
    Cooldown = 0.1,
    Distance = 6,
}

DodgeVeil.Trigger = function()
    if tick() - DodgeVeil.lastTime < DodgeVeil.Cooldown then return end
    DodgeVeil.lastTime = tick()

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local side = (math.random() > 0.5) and 1 or -1
    local offset = hrp.CFrame.RightVector * side * DodgeVeil.Distance
    hrp.CFrame = CFrame.new(hrp.Position + offset) * (hrp.CFrame - hrp.CFrame.Position)
end

DodgeVeil.Attach = function(kChar)
    if not kChar or DodgeVeil.Attached[kChar] then return end
    DodgeVeil.Attached[kChar] = true

    local humanoid = kChar:WaitForChild("Humanoid", 5)
    if not humanoid then return end

    local animator = humanoid:FindFirstChildOfClass("Animator") or humanoid:WaitForChild("Animator", 5)
    if not animator then return end

    local childAddedConn
    childAddedConn = humanoid.ChildAdded:Connect(function(child)
        if child:IsA("Animator") then
            DodgeVeil.Attached[kChar] = nil
            if childAddedConn then childAddedConn:Disconnect() end
            DodgeVeil.Attach(kChar)
        end
    end)

    kChar.AncestryChanged:Connect(function(_, parent)
        if not parent then
            DodgeVeil.Attached[kChar] = nil
            if childAddedConn then childAddedConn:Disconnect() end
        end
    end)

    animator.AnimationPlayed:Connect(function(track)
        if not Config.Surv_CrouchV then return end

        local animId = track.Animation and track.Animation.AnimationId or ""
        local id = animId:match("%d+")
        if id ~= "86266790353635" and id ~= "93136435416899" then return end

        local myChar = LocalPlayer.Character
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local kHRP = kChar:FindFirstChild("HumanoidRootPart")
        if not (myHRP and kHRP) then return end
        if (myHRP.Position - kHRP.Position).Magnitude > 100 then return end

        local flatDelta = Vector3.new(myHRP.Position.X - kHRP.Position.X, 0, myHRP.Position.Z - kHRP.Position.Z)
        if flatDelta.Magnitude <= 0 then return end

        local kLookFlat = Vector3.new(kHRP.CFrame.LookVector.X, 0, kHRP.CFrame.LookVector.Z)
        if kLookFlat.Magnitude <= 0.001 then return end

        if kLookFlat.Unit:Dot(flatDelta.Unit) >= 0.7 then
            DodgeVeil.Trigger()
        end
    end)
end

DodgeVeil.TryAttach = function(p)
    if p ~= LocalPlayer and p.Team and p.Team.Name == "Killer" and p.Character then
        DodgeVeil.Attach(p.Character)
    end
end

DodgeVeil.Setup = function(p)
    if p == LocalPlayer then return end
    p.CharacterAdded:Connect(function() DodgeVeil.TryAttach(p) end)
    p:GetPropertyChangedSignal("Team"):Connect(function() DodgeVeil.TryAttach(p) end)
    if p.Character then DodgeVeil.TryAttach(p) end
end

for _, p in ipairs(Players:GetPlayers()) do
    DodgeVeil.Setup(p)
end
Players.PlayerAdded:Connect(DodgeVeil.Setup)

function enableSpoofer() 
    if not Config.Misc_FakeName then return end
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not PlayerGui then return end
    
    function applySpooferToObj(obj)
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            function updateText()
                if not Config.Misc_FakeName then return end
                local currentText = obj.Text
                local changed = false

                if not obj:GetAttribute("OriginalText") then
                    obj:SetAttribute("OriginalText", currentText)
                end

                for _, player in ipairs(Players:GetPlayers()) do
                    if string.find(currentText, player.Name) or string.find(currentText, player.DisplayName) then
                        currentText = string.gsub(currentText, player.Name, "PANDU")
                        currentText = string.gsub(currentText, player.DisplayName, "PANDU")
                        changed = true
                    end
                end
                
                if changed and obj.Text ~= currentText then
                    obj.Text = currentText
                end
            end

            updateText()
            local conn = obj:GetPropertyChangedSignal("Text"):Connect(updateText)
            table.insert(State.SpooferConns, conn)
            
        elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
            function updateImage()
                if not Config.Misc_FakeName then return end
                local currentImg = obj.Image
                local changed = false

                for _, player in ipairs(Players:GetPlayers()) do
                    if string.find(currentImg, tostring(player.UserId)) then
                        if not obj:GetAttribute("OriginalImage") then
                            obj:SetAttribute("OriginalImage", currentImg)
                        end
                        changed = true
                        break 
                    end
                end

                if changed and obj.Image ~= "rbxassetid://94380161420025" then
                    obj.Image = "rbxassetid://94380161420025"
                end
            end

            updateImage() 
            local conn = obj:GetPropertyChangedSignal("Image"):Connect(updateImage)
            table.insert(State.SpooferConns, conn)
        end
    end
    
    for _, obj in ipairs(PlayerGui:GetDescendants()) do applySpooferToObj(obj) end
    local conn = PlayerGui.DescendantAdded:Connect(function(obj) task.defer(function() applySpooferToObj(obj) end) end)
    table.insert(State.SpooferConns, conn) 
end

function disableSpoofer() 
    for _, conn in ipairs(State.SpooferConns) do 
        if conn.Connected then conn:Disconnect() end 
    end
    table.clear(State.SpooferConns) 
    
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if PlayerGui then
        for _, obj in ipairs(PlayerGui:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                local oriText = obj:GetAttribute("OriginalText")
                if oriText then
                    obj.Text = oriText
                    obj:SetAttribute("OriginalText", nil)
                end
            elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                local oriImage = obj:GetAttribute("OriginalImage")
                if oriImage then
                    obj.Image = oriImage
                    obj:SetAttribute("OriginalImage", nil)
                end
            end
        end
    end
end
function IsSafeToParry(char)
    if not Config.Surv_ParrySafety then return true end
    if not char then return false end
    
    local interactObj = char:FindFirstChild("CheckInterractable")
    
    if interactObj then
        if interactObj:GetAttribute("isVaulting") == true then return false end
        if interactObj:GetAttribute("isRepairing") == true then return false end
        if interactObj:GetAttribute("isUnhooking") == true then return false end
        if interactObj:GetAttribute("isHealing") == true then return false end
        if interactObj:GetAttribute("isSliding") == true then return false end
    end
    
    return true 
end

function TriggerCrouch()
    pcall(function()
        local b = LocalPlayer:FindFirstChild("PlayerGui")

        for segment in string.gmatch("Survivor-mob.Controls.crouch.icon", "[^%.]+") do
            if b then
                b = b:FindFirstChild(segment)
            end
        end

        if b and b:IsA("GuiObject") and b.Visible and b.Parent and b.Parent:IsA("GuiButton") then
            local btn = b.Parent

            if UserInputService.TouchEnabled and type(firesignal) == "function" then
                firesignal(btn.MouseButton1Click)
                task.wait(1.4)
                firesignal(btn.MouseButton1Click)
            else
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
                task.wait(1.4)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
            end
        else
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
            task.wait(1.4)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
        end
    end)
end
function GetRole()
    if not LocalPlayer.Team then return "Unknown" end
    local name = LocalPlayer.Team.Name
    if name == "Killer" then return "Killer"
    elseif name == "Survivors" then return "Survivor"
    else return "Spectator" end
end
function IsSurvivor(p) return p and p.Team and p.Team.Name == "Survivors" end
function IsKiller(p) return p and p.Team and p.Team.Name == "Killer" end
function IsDowned(char)
    if not char then return false end
    return char:GetAttribute("Knocked") == true or char:GetAttribute("IsHooked") == true
end

function GetDistance(pos) 
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return math.huge end
    return (pos - root.Position).Magnitude 
end

local function getRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

-- ============================================
-- ===== INSTANT TP GATE =====
-- ============================================

pcall(function()
    Config.GateClientModule = require(game:GetService("ReplicatedStorage").Modules.Items.GateClient)
end)

local function setAllGateDuration(duration)
    for _, obj in getgc(true) do
        if typeof(obj) == "table" and rawget(obj, "gateDuration") and rawget(obj, "gateRemote") then
            rawset(obj, "gateDuration", duration)
        end
    end
end

local function applyHooks()
    if not Config.GateClientModule then return end

    if not Config.oldGateNew then
        Config.oldGateNew = Config.GateClientModule.new
        Config.GateClientModule.new = function(...)
            local obj = Config.oldGateNew(...)
            if Config.InstantTPGate then
                obj.gateDuration = 0
            end
            return obj
        end
    end

    if not Config.oldGateCanUse then
        Config.oldGateCanUse = Config.GateClientModule.CanUse
        Config.GateClientModule.CanUse = function(self)
            if Config.InstantTPGate then
                if self.isSilenced or self.isBuffering then
                    return false
                end
                return os.clock() - self.lastUse >= self.currentCooldown
            end
            return Config.oldGateCanUse(self)
        end
    end
end

local function removeHooks()
    if not Config.GateClientModule then return end

    if Config.oldGateNew then
        Config.GateClientModule.new = Config.oldGateNew
        Config.oldGateNew = nil
    end
    if Config.oldGateCanUse then
        Config.GateClientModule.CanUse = Config.oldGateCanUse
        Config.oldGateCanUse = nil
    end
end

-- ==================== HOOK COUNTER FUNCTIONS ====================

function UpdateHookData()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Team and plr.Team.Name == "Survivors" then
            local hookCount = plr:GetAttribute("HookCount") or 0
            HookData[plr.Name] = hookCount
        end
    end
end

-- ==================== HOOK ESP FUNCTIONS ====================

function CreateHookESP(parent, hookCount)
    if not HookESPEnabled then return end
    
    local espName = "HookESP_" .. parent.Name
    local existing = parent:FindFirstChild(espName)
    if existing then existing:Destroy() end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = espName
    billboard.Parent = parent
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 60, 0, 18)
    billboard.StudsOffset = Vector3.new(0, 5.5, 0)  -- Di ATAS ESP name (offset 3.5)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextScaled = true
    label.Text = string.format("Hooked %d", hookCount)
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = billboard
    
    -- Warna berdasarkan jumlah hook
    if hookCount >= 3 then
        label.TextColor3 = Color3.fromRGB(255, 50, 50)   -- Merah (bahaya)
    elseif hookCount >= 2 then
        label.TextColor3 = Color3.fromRGB(255, 200, 50) -- Kuning
    else
        label.TextColor3 = Color3.fromRGB(200, 200, 200) -- Putih
    end
    
    -- Stroke biar lebih jelas
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 0, 0)
    stroke.Thickness = 2
    stroke.Transparency = 0.5
    stroke.Parent = label
end

function UpdateHookESP()
    if not HookESPEnabled then return end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local isKiller = IsKiller(p)
            if not isKiller then
                local hookCount = HookData[p.Name] or p:GetAttribute("HookCount") or 0
                CreateHookESP(p.Character, hookCount)
            end
        end
    end
end

function ClearHookESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            for _, child in pairs(p.Character:GetChildren()) do
                if string.match(child.Name, "^HookESP_") then
                    child:Destroy()
                end
            end
        end
    end
end

function SetupHookDetection()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            plr:GetAttributeChangedSignal("HookCount"):Connect(function()
                HookData[plr.Name] = plr:GetAttribute("HookCount") or 0
                if HookESPEnabled then
                    UpdateHookESP()
                end
            end)
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr:GetAttributeChangedSignal("HookCount"):Connect(function()
        HookData[plr.Name] = plr:GetAttribute("HookCount") or 0
        if HookESPEnabled then
            UpdateHookESP()
        end
    end)
end)

task.spawn(function()
    task.wait(2)
    SetupHookDetection()
end)

-- ===== HOOK ESP UPDATE LOOP =====
task.spawn(function()
    while true do
        task.wait(1)
        if HookESPEnabled then
            UpdateHookData()
            UpdateHookESP()
        else
            ClearHookESP()
        end
    end
end)

-- ==================== HIT SOUND EFFECT FUNCTIONS ====================

function PlayHitSound()
    if not Config.HitSoundEnabled then return end
    
    local now = tick()
    if now - Config.HitSoundLastTime < Config.HitSoundCooldown then return end
    Config.HitSoundLastTime = now
    
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = Config.HitSoundId
        sound.Volume = Config.HitSoundVolume
        sound.PlayOnRemove = true
        sound.Parent = workspace.CurrentCamera or workspace
        sound:Play()
        
        task.delay(sound.TimeLength + 0.1, function()
            if sound and sound.Parent then
                sound:Destroy()
            end
        end)
    end)
end

-- ==================== AUTO RUN MOBILE (FIX CROUCH BUG) ====================
getgenv().AutoRunMobileEnabled = false
local AutoRunMobileThread = nil

local function GetMobileSprintButton()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end
    local mob = pg:FindFirstChild("Survivor-mob")
    if not mob then return nil end
    local controls = mob:FindFirstChild("Controls")
    if not controls then return nil end
    local sprint = controls:FindFirstChild("sprint")
    if not sprint then return nil end

    if sprint:IsA("GuiButton") then return sprint end
    local icon = sprint:FindFirstChild("icon")
    if icon and icon:IsA("GuiButton") then return icon end
    if icon and icon.Parent and icon.Parent:IsA("GuiButton") then return icon.Parent end
    if sprint.Parent and sprint.Parent:IsA("GuiButton") then return sprint.Parent end
    return sprint
end

local function PressSprint()
    local btn = GetMobileSprintButton()
    if not btn then return false end
    pcall(function()
        if type(firesignal) == "function" then
            firesignal(btn.MouseButton1Click)
            firesignal(btn.MouseButton1Down)
            task.wait(0.04)
            firesignal(btn.MouseButton1Up)
        else
            local pos = btn.AbsolutePosition
            local size = btn.AbsoluteSize
            local inset = GuiService:GetGuiInset()
            local x = pos.X + size.X / 2 + inset.X
            local y = pos.Y + size.Y / 2 + inset.Y
            local id = 9901
            VirtualInputManager:SendTouchEvent(id, 0, x, y)
            task.wait(0.04)
            VirtualInputManager:SendTouchEvent(id, 2, x, y)
        end
    end)
    return true
end

local function IsMoving()
    local char = LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end

    if hum.MoveDirection.Magnitude > 0.12 then
        return true
    end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local v = hrp.AssemblyLinearVelocity
        local horizontal = Vector3.new(v.X, 0, v.Z).Magnitude
        if horizontal > 1.5 then
            return true
        end
    end
    return false
end

local function IsCrouching()
    local char = LocalPlayer.Character
    if not char then return false end
    return char:GetAttribute("Crouching") == true
        or char:GetAttribute("Crouchingserver") == true
end

local function IsActuallySprinting()
    local char = LocalPlayer.Character
    if not char then return false end
    return char:GetAttribute("Sprinting") == true
        or char:GetAttribute("IsRunning") == true
end

local function StartAutoRunMobile()
    if AutoRunMobileThread then return end

    AutoRunMobileThread = task.spawn(function()
        while getgenv().AutoRunMobileEnabled do
            local moving = IsMoving()
            local crouching = IsCrouching()
            local sprinting = IsActuallySprinting()

            if crouching then
                -- saat crouch: pastikan sprint mati, jangan sentuh lagi
                if sprinting then
                    PressSprint()
                end
            else
                if moving and not sprinting then
                    -- gerak + belum sprint → nyalakan
                    PressSprint()
                elseif not moving and sprinting then
                    -- diam + masih sprint → matikan
                    PressSprint()
                end
            end

            task.wait(0.12)
        end

        -- fitur OFF → pastikan sprint mati
        if IsActuallySprinting() then
            PressSprint()
        end
        AutoRunMobileThread = nil
    end)
end

local function StopAutoRunMobile()
    getgenv().AutoRunMobileEnabled = false
end

-- ==================== AUTO SKILL CHECK ====================

if not State then State = {} end
State.RandomMode_IsNormal = false

local function ks()
    task.spawn(function()
        local GlobalRemotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 10)
        local killerPerks = GlobalRemotes and GlobalRemotes:WaitForChild("KillerPerks", 5)
        local kingscourge = killerPerks and killerPerks:WaitForChild("kingscourge", 5)
        local kingScourgeStart = kingscourge and kingscourge:WaitForChild("KingScourgeStart", 5)
        
        if kingScourgeStart then
            kingScourgeStart.OnClientEvent:Connect(function()
                if Auto.SkillCheckMode == "Random" then
                    State.RandomMode_IsNormal = true
                end
            end)
        end
    end)
end
ks()

local function GetActionTarget()
    local current = PlayerGui
    if not current then return nil end
    
    local mob = current:FindFirstChild("Survivor-mob")
    if not mob then return nil end
    
    local controls = mob:FindFirstChild("Controls")
    if not controls then return nil end
    
    return controls:FindFirstChild("action") or controls:FindFirstChild("check")
end

local function TriggerSkillCheck()
    local btn = GetActionTarget()
    
    if btn and btn:IsA("GuiObject") and btn.Visible then
        if type(firesignal) == "function" then
            pcall(function()
                firesignal(btn.MouseButton1Down)
                task.wait(0.005)
                firesignal(btn.MouseButton1Up)
            end)
            return true
        end
    end
    
    if btn and btn:IsA("GuiObject") and btn.Visible then
        pcall(function()
            local pos = btn.AbsolutePosition
            local size = btn.AbsoluteSize
            local inset = GuiService:GetGuiInset()
            local touchId = 8822 + math.random(1, 9999)
            VirtualInputManager:SendTouchEvent(touchId, 0, pos.X + size.X/2 + inset.X, pos.Y + size.Y/2 + inset.Y)
            task.wait(0.005)
            VirtualInputManager:SendTouchEvent(touchId, 2, pos.X + size.X/2 + inset.X, pos.Y + size.Y/2 + inset.Y)
        end)
        return true
    end
    
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        task.wait(0.005)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end)
    
    return true
end

local function startSkillCheck()
    if Connections.SkillHeartbeat then Connections.SkillHeartbeat:Disconnect() end
    
    Connections.SkillHeartbeat = RunService.Heartbeat:Connect(function()
        if not Auto.SkillCheck or State.busy then return end
        
        local prompt = PlayerGui:FindFirstChild("SkillCheckPromptGui")
        if not prompt then return end
        
        local check = prompt:FindFirstChild("Check")
        -- Jika UI Skill Check hilang/tertutup, reset mode Random kembali ke Instant
        if not check or not check.Visible then 
            State.RandomMode_IsNormal = false
            return 
        end
        
        local line = check:FindFirstChild("Line")
        local goal = check:FindFirstChild("Goal")
        if not line or not goal then return end

        local isInstant = Auto.SkillCheckMode == "Instant" or (Auto.SkillCheckMode == "Random" and not State.RandomMode_IsNormal)

        if isInstant then
            line.Rotation = goal.Rotation + 109
            
            State.busy = true
            State.busyTime = tick()
            
            task.spawn(function()
                TriggerSkillCheck()
                task.wait(0.05)
                State.busy = false
            end)
        else
            local isNormal = Auto.SkillCheckMode == "Normal" or (Auto.SkillCheckMode == "Random" and State.RandomMode_IsNormal)
            
            local lr = line.Rotation % 360
            local gr = goal.Rotation % 360
            
            local startRange, endRange
            if isNormal then
                startRange = (gr + 116) % 360
                endRange = (gr + 140) % 360
            else -- Legit Mode
                startRange = (gr + 102) % 360
                endRange = (gr + 116) % 360
            end
            
            local inZone = false
            if startRange > endRange then
                inZone = (lr >= startRange or lr <= endRange)
            else
                inZone = (lr >= startRange and lr <= endRange)
            end
             
            if inZone then
                State.busy = true
                task.spawn(function()
                    TriggerSkillCheck()
                    task.wait(0.05)
                    State.busy = false
                end)
            end
        end
    end)
end

-- AUTO STALK
local function getClosestSurvivorForStalk()
    local root = getRoot()
    if not root then return nil end
    local closest, shortest = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 30 then
                local dist = (hrp.Position - root.Position).Magnitude
                if dist <= AutoStalk.StalkRange and dist < shortest then
                    shortest = dist; closest = plr
                end
            end
        end
    end
    return closest
end

function getTargetPartObject(char)
    if AimConfig.AIM_TargetPart == "Head" then 
        return char:FindFirstChild("Head")
    elseif AimConfig.AIM_TargetPart == "Root" or AimConfig.AIM_TargetPart == "HumanoidRootPart" then 
        return char:FindFirstChild("HumanoidRootPart")
    else 
        return char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart") 
    end
end

function getClosestSurvivor()
    local myChar = player.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local closestFovDist = AimConfig.Veil_FOV
    local closestTarget = nil
    local cam = workspace.CurrentCamera
    local centerScreen = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Team and p.Team.Name == "Survivors" and p.Character then
            local char = p.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local targetPart = getTargetPartObject(char)
            if hum and hum.Health > 0 and targetPart then
                local dist3D = (targetPart.Position - myRoot.Position).Magnitude
                if dist3D <= AimConfig.SPEAR_MaxDist then
                    local screenPos, onScreen = cam:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local targetPos2D = Vector2.new(screenPos.X, screenPos.Y)
                        local dist2D = (targetPos2D - centerScreen).Magnitude
                        if dist2D <= closestFovDist then
                            closestFovDist = dist2D
                            closestTarget = targetPart
                        end
                    end
                end
            end
        end
    end
    return closestTarget
end

-- ==================== FAKE PERKS FUNCTIONS ====================

local function IsSurvivorFake()
    return LocalPlayer.Team and LocalPlayer.Team.Name == "Survivors"
end

local function isSlowVaulting(char)
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then return false end

    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
        if track.Animation and string.find(tostring(track.Animation.AnimationId), "126081405469607") then
            return true
        end
    end
    return false
end

-- ===== QUICK RECOVERY =====
local function applyQuickRecovery(char)
    if not FakePerks.QuickRecoveryEnabled then return end
    if not IsSurvivorFake() then return end
    if FakePerks.boostActive then return end
    if (tick() - FakePerks.lastQRTime) < FakePerks.PerkCooldown then return end

    FakePerks.boostActive = true
    FakePerks.lastQRTime = tick()
    local startTime = tick()

    task.spawn(function()
        while FakePerks.QuickRecoveryEnabled and (tick() - startTime) < 3 do
            if char and char.Parent then
                char:SetAttribute("speedboost", 1.4)
            end
            task.wait()
        end

        if char and char.Parent then
            char:SetAttribute("speedboost", 1)
        end
        FakePerks.boostActive = false
    end)
end

local function setupQuickRecovery(char)
    if FakePerks.qrConnection then
        FakePerks.qrConnection:Disconnect()
        FakePerks.qrConnection = nil
    end

    if not char then return end

    FakePerks.qrConnection = char:GetAttributeChangedSignal("isvaulting"):Connect(function()
        if char:GetAttribute("isvaulting") == true then
            task.spawn(function()
                task.wait(0.05)

                local isSlow = isSlowVaulting(char)
                if not isSlow then
                    task.wait(0.05)
                    isSlow = isSlowVaulting(char)
                end

                if not isSlow and char:GetAttribute("isvaulting") == true then
                    applyQuickRecovery(char)
                end
            end)
        end
    end)
end

function FakePerks.ToggleQuickRecovery(value)
    FakePerks.QuickRecoveryEnabled = value
    
    if value and LocalPlayer.Character then
        setupQuickRecovery(LocalPlayer.Character)
    elseif not value and FakePerks.qrConnection then
        FakePerks.qrConnection:Disconnect()
        FakePerks.qrConnection = nil
    end
    
    Library:Notify({ 
        Title = "Fake Quick Recovery", 
        Description = value and "AKTIF" or "NONAKTIF", 
        Time = 2 
    })
end

-- ===== PERFECT LANDING =====
local function applyPerfectLanding(char)
    if not FakePerks.PerfectLandingEnabled then return end
    if not IsSurvivorFake() then return end
    if FakePerks.perfectLandingBoostActive then return end
    if (tick() - FakePerks.lastPLTime) < FakePerks.PerkCooldown then return end

    FakePerks.perfectLandingBoostActive = true
    FakePerks.lastPLTime = tick()
    local startTime = tick()

    task.spawn(function()
        while FakePerks.perfectLandingBoostActive and (tick() - startTime) < 3 do
            if char and char.Parent then
                char:SetAttribute("speedboost", 1.4)
            end
            task.wait()
        end

        if char and char.Parent then
            char:SetAttribute("speedboost", 1)
        end
        FakePerks.perfectLandingBoostActive = false
    end)
end

local function setupPerfectLanding(char)
    if FakePerks.plConnection then
        FakePerks.plConnection:Disconnect()
        FakePerks.plConnection = nil
    end

    if not char then return end

    FakePerks.plConnection = char:GetAttributeChangedSignal("speedboost"):Connect(function()
        if not IsSurvivorFake() then return end

        local currentBoost = char:GetAttribute("speedboost")
        if currentBoost == 0.625 then
            applyPerfectLanding(char)
        end
    end)
end

function FakePerks.TogglePerfectLanding(value)
    FakePerks.PerfectLandingEnabled = value

    if value then
        if LocalPlayer.Character then
            setupPerfectLanding(LocalPlayer.Character)
        end
    else
        if FakePerks.plConnection then
            FakePerks.plConnection:Disconnect()
            FakePerks.plConnection = nil
        end

        if FakePerks.perfectLandingBoostActive and LocalPlayer.Character then
            LocalPlayer.Character:SetAttribute("speedboost", 1)
            FakePerks.perfectLandingBoostActive = false
        end
    end

    Library:Notify({ 
        Title = "Fake Perfect Landing", 
        Description = value and "AKTIF" or "NONAKTIF", 
        Time = 2 
    })
end

-- ===== FLOWSTATE =====
local function tryApplyFlowstate(char)
    if not FakePerks.FlowstateEnabled then return end
    if not char or not char.Parent then return end
    if not IsSurvivorFake() then return end
    if FakePerks.fsOnCooldown then return end
    if (tick() - FakePerks.lastFSTime) < FakePerks.PerkCooldown then return end

    char:SetAttribute("Flowstate", true)
end

local function setupFlowstate(char)
    if FakePerks.fsConnection then
        FakePerks.fsConnection:Disconnect()
        FakePerks.fsConnection = nil
    end
    if FakePerks.fsAnimConnection then
        FakePerks.fsAnimConnection:Disconnect()
        FakePerks.fsAnimConnection = nil
    end

    if not char then return end

    local humanoid = char:WaitForChild("Humanoid", 3)
    if not humanoid then return end

    local animator = humanoid:WaitForChild("Animator", 3)
    if not animator then return end

    FakePerks.fsAnimConnection = animator.AnimationPlayed:Connect(function(track)
        if not track.Animation then return end
        if track.Animation.AnimationId ~= "rbxassetid://136962284480779" then return end

        local stoppedConn
        stoppedConn = track.Stopped:Connect(function()
            if stoppedConn then
                stoppedConn:Disconnect()
            end

            FakePerks.lastFSTime = tick()
            FakePerks.fsOnCooldown = true

            if char and char.Parent then
                char:SetAttribute("Flowstate", false)
            end

            task.delay(FakePerks.PerkCooldown, function()
                FakePerks.fsOnCooldown = false

                if FakePerks.FlowstateEnabled and char and char.Parent then
                    char:SetAttribute("Flowstate", true) 
                end
            end)
        end)
    end)

    FakePerks.fsConnection = char:GetAttributeChangedSignal("Flowstate"):Connect(function()
        if not FakePerks.FlowstateEnabled then return end
        if not IsSurvivorFake() then return end

        local current = char:GetAttribute("Flowstate")

        if current == true then
            if FakePerks.fsOnCooldown or (tick() - FakePerks.lastFSTime) < FakePerks.PerkCooldown then
                char:SetAttribute("Flowstate", false)
            end
        elseif current == false then
            if not FakePerks.fsOnCooldown and (tick() - FakePerks.lastFSTime) >= FakePerks.PerkCooldown then
                char:SetAttribute("Flowstate", true)
            end
        end
    end)

    task.wait(0.5)
    if FakePerks.FlowstateEnabled and char and char.Parent then
        char:SetAttribute("Flowstate", true)
    end
end

function FakePerks.ToggleFlowstate(value)
    FakePerks.FlowstateEnabled = value

    if value then
        if LocalPlayer.Character then
            setupFlowstate(LocalPlayer.Character)
        end
    else
        if FakePerks.fsConnection then
            FakePerks.fsConnection:Disconnect()
            FakePerks.fsConnection = nil
        end
        if FakePerks.fsAnimConnection then
            FakePerks.fsAnimConnection:Disconnect()
            FakePerks.fsAnimConnection = nil
        end

        if LocalPlayer.Character then
            LocalPlayer.Character:SetAttribute("Flowstate", false)
        end
    end

    Library:Notify({ 
        Title = "Fake Flowstate", 
        Description = value and "AKTIF" or "NONAKTIF", 
        Time = 2 
    })
end

-- ===== SETUP CHARACTER =====
local function onCharacterAddedFake(char)
    task.wait(0.5)

    if FakePerks.QuickRecoveryEnabled then
        setupQuickRecovery(char)
    end

    if FakePerks.PerfectLandingEnabled then
        setupPerfectLanding(char)
    end

    if FakePerks.FlowstateEnabled then
        setupFlowstate(char)
    end
end

-- ===== INITIALIZATION =====
if LocalPlayer.Character then
    onCharacterAddedFake(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(onCharacterAddedFake)

local function startAutoStalk()
    if Connections.Stalk then return end
    Connections.Stalk = RunService.Heartbeat:Connect(function()
        if not AutoStalk.Enabled then return end
        local target = getClosestSurvivorForStalk()
        if not target or not target.Character then return end
        local stalkEvent = ReplicatedStorage:FindFirstChild("Remotes", true)
            and ReplicatedStorage.Remotes:FindFirstChild("Killers", true)
            and ReplicatedStorage.Remotes.Killers:FindFirstChild("Stalker", true)
            and ReplicatedStorage.Remotes.Killers.Stalker:FindFirstChild("StartStalking")
        if stalkEvent then pcall(function() stalkEvent:FireServer(target) end) end
    end)
end

local function stopAutoStalk()
    if Connections.Stalk then Connections.Stalk:Disconnect(); Connections.Stalk = nil end
end

local function teleportToFinishLine()
    local root = getRoot()
    if not root then return end
    local found = nil
    for _, obj in ipairs(workspace:GetDescendants()) do
        if string.lower(obj.Name) == "fininshline" and obj:IsA("BasePart") then
            found = obj; break
        end
    end
    if not found then warn("fininshline not found"); return end
    root.CFrame = found.CFrame + Vector3.new(0, 5, 0)
end

-- KORLESS 
local KorlessMorph = {
    Enabled = false
}

local function ApplyKorless()
    local plr = game.Players.LocalPlayer

    local function Morph()
        repeat task.wait()
        until plr.Character
            and plr.Character:FindFirstChild("HumanoidRootPart")
            and plr.Character:FindFirstChild("Right Leg")

        task.wait(0.1)
        local char = plr.Character

        pcall(function()
            char.Head.Transparency = 1

            local face = char.Head:FindFirstChild("face")
            if face then
                face:Destroy()
            end

            char["Right Leg"].Transparency = 1

            local mesh = Instance.new("MeshPart")
            mesh.Name = "KorlessHead"
            mesh.Size = Vector3.new(1.05, 1.05, 1.05)
            mesh.CanCollide = false
            mesh.MeshId = "rbxassetid://902942096"
            mesh.TextureID = "rbxassetid://902843398"
            mesh.CFrame = char["Right Leg"].CFrame * CFrame.new(0,0.5,0)
            mesh.Parent = char

            local weld = Instance.new("WeldConstraint")
            weld.Part0 = char["Right Leg"]
            weld.Part1 = mesh
            weld.Parent = mesh
        end)
    end

    Morph()

    if KorlessMorph.Connection then
        KorlessMorph.Connection:Disconnect()
    end

    KorlessMorph.Connection = plr.CharacterAdded:Connect(function()
        task.wait(1)
        Morph()
    end)
end

-- ==================== CROSSHAIR ====================
local CrosshairGui = nil
local CrosshairElements = {}

local function clearCrosshair()
    if CrosshairGui then
        CrosshairGui:Destroy()
        CrosshairGui = nil
    end
    CrosshairElements = {}
    State.created = false
    State.LastCrosshairStyle = nil
end

local function drawCrosshair()
    if not Crosshair.Enabled then
        if CrosshairGui then
            CrosshairGui.Enabled = false
        end
        return
    end

    if CrosshairGui then
        CrosshairGui.Enabled = true
    end

    if State.LastCrosshairStyle ~= Crosshair.Style or not CrosshairGui then
        clearCrosshair()
        State.LastCrosshairStyle = Crosshair.Style
    end

    if not State.created then
        State.created = true

        CrosshairGui = Instance.new("ScreenGui")
        CrosshairGui.Name = "CrosshairUI"
        CrosshairGui.IgnoreGuiInset = true
        CrosshairGui.ResetOnSpawn = false
        CrosshairGui.DisplayOrder = 999
        CrosshairGui.Parent = CoreGui

        local function createLine(size, pos)
            local frame = Instance.new("Frame")
            frame.BackgroundColor3 = Crosshair.Color
            frame.BorderSizePixel = 0
            frame.AnchorPoint = Vector2.new(0.5, 0.5)
            frame.Size = size
            frame.Position = pos
            frame.Parent = CrosshairGui
            return frame
        end

        local centerPos = UDim2.new(0.5, Crosshair.OffsetX, 0.5, Crosshair.OffsetY)

        if Crosshair.Style == "Plus" then
            CrosshairElements[1] = createLine(
                UDim2.new(0, Crosshair.Size * 2, 0, Crosshair.Thickness),
                centerPos
            )
            CrosshairElements[2] = createLine(
                UDim2.new(0, Crosshair.Thickness, 0, Crosshair.Size * 2),
                centerPos
            )

        elseif Crosshair.Style == "Dot" then
            local dot = Instance.new("Frame")
            dot.BackgroundColor3 = Crosshair.Color
            dot.BorderSizePixel = 0
            dot.AnchorPoint = Vector2.new(0.5, 0.5)
            dot.Size = UDim2.new(0, Crosshair.Size, 0, Crosshair.Size)
            dot.Position = centerPos
            Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
            dot.Parent = CrosshairGui
            CrosshairElements[1] = dot

        elseif Crosshair.Style == "Circle" then
            local circle = Instance.new("Frame")
            circle.BackgroundTransparency = 1
            circle.BorderSizePixel = 0
            circle.AnchorPoint = Vector2.new(0.5, 0.5)
            circle.Size = UDim2.new(0, Crosshair.Size * 2, 0, Crosshair.Size * 2)
            circle.Position = centerPos
            circle.Parent = CrosshairGui

            local stroke = Instance.new("UIStroke")
            stroke.Color = Crosshair.Color
            stroke.Thickness = Crosshair.Thickness
            stroke.Parent = circle

            Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
            CrosshairElements[1] = circle
        end
    end

    local centerPos = UDim2.new(0.5, Crosshair.OffsetX, 0.5, Crosshair.OffsetY)

    if Crosshair.Style == "Plus" then
        if CrosshairElements[1] then
            CrosshairElements[1].Size = UDim2.new(0, Crosshair.Size * 2, 0, Crosshair.Thickness)
            CrosshairElements[1].Position = centerPos
            CrosshairElements[1].BackgroundColor3 = Crosshair.Color
        end
        if CrosshairElements[2] then
            CrosshairElements[2].Size = UDim2.new(0, Crosshair.Thickness, 0, Crosshair.Size * 2)
            CrosshairElements[2].Position = centerPos
            CrosshairElements[2].BackgroundColor3 = Crosshair.Color
        end

    elseif Crosshair.Style == "Dot" then
        if CrosshairElements[1] then
            CrosshairElements[1].Size = UDim2.new(0, Crosshair.Size, 0, Crosshair.Size)
            CrosshairElements[1].Position = centerPos
            CrosshairElements[1].BackgroundColor3 = Crosshair.Color
        end

    elseif Crosshair.Style == "Circle" then
        if CrosshairElements[1] then
            CrosshairElements[1].Size = UDim2.new(0, Crosshair.Size * 2, 0, Crosshair.Size * 2)
            CrosshairElements[1].Position = centerPos
            local stroke = CrosshairElements[1]:FindFirstChildOfClass("UIStroke")
            if stroke then
                stroke.Color = Crosshair.Color
                stroke.Thickness = Crosshair.Thickness
            end
        end
    end
end

-- ==================== MAP SCANNER ====================
local lastScanTime = 0

function ScanMap()
    if tick() - lastScanTime < 2 then return end
    lastScanTime = tick()
    
    table.clear(Cache.Generators)
    table.clear(Cache.Windows)
    table.clear(Cache.Pallets)
    table.clear(Cache.Hooks)
    table.clear(Cache.Gates)
    table.clear(Cache.SCPs)
    
    local mapFolder = workspace:FindFirstChild("Map") or workspace
    local descendants = mapFolder:GetDescendants()
    for i, v in ipairs(descendants) do
        if i % 200 == 0 then task.wait() end
        if v:IsA("Model") then
            local name = string.lower(v.Name)
            if name == "generator" then 
                local p = v:FindFirstChildWhichIsA("BasePart")
                if p then table.insert(Cache.Generators, {model=v, part=p}) end
            elseif name == "hook" and v:FindFirstChild("HookPoint") then 
                table.insert(Cache.Hooks, v)
            elseif name == "gate" and v:FindFirstChild("ExitLever") then
                table.insert(Cache.Gates, v)
            elseif name == "window" then 
                table.insert(Cache.Windows, v)
            end
        elseif v:IsA("BasePart") and v.Name == "PrimaryPartPallet" then
            local modelUtamaPallet = v.Parent
            if modelUtamaPallet and not table.find(Cache.Pallets, modelUtamaPallet) then
                table.insert(Cache.Pallets, modelUtamaPallet)
            end
        end
    end

    local workspaceDescendants = workspace:GetDescendants()
    for i, v in ipairs(workspaceDescendants) do
        if i % 200 == 0 then task.wait() end
        if v:IsA("Model") and string.match(string.lower(v.Name), "^scp") then
            if not table.find(Cache.SCPs, v) then
                table.insert(Cache.SCPs, v)
            end
        end
    end
end


local ItemsFolder = ReplicatedStorage:WaitForChild("Items", 5)
function extractAssetId(str)
    return tostring(str):match("%d+")
end

function getItemIcon(itemName)
    if not ItemsFolder then return nil end
    local item = ItemsFolder:FindFirstChild(itemName)
    if not item then return nil end
    local tex
    pcall(function() tex = item.Texture or item.Image end)
    if tex and tex ~= "" then
        local id = extractAssetId(tex)
        if id then return ("rbxthumb://type=Asset&id=%s&w=420&h=420"):format(id) end
    end
    return nil
end
function CreateModernESP(parent, idName, config)
    local billboard = parent:FindFirstChild(idName)
    
    if not billboard then 
        billboard = Instance.new("BillboardGui")
        billboard.Name = idName
        billboard.Parent = parent
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 200, 0, 25)
        
        local yOffset = config.offsetY or 3.5
        billboard.StudsOffset = Vector3.new(0, yOffset, 0) 
        
        local box = Instance.new("Frame")
        box.Name = "Box"
        box.AutomaticSize = Enum.AutomaticSize.X 
        box.Size = UDim2.new(0, 0, 0, 15)
        box.Position = UDim2.new(0.5, 0, 0, 0) 
        box.AnchorPoint = Vector2.new(0.5, 0)
        box.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        box.BackgroundTransparency = 0 
        box.BorderSizePixel = 0
        box.ZIndex = 2
        box.Parent = billboard
        
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 3)
        
        local boxGradient = Instance.new("UIGradient")
        boxGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.15, 0.35),
            NumberSequenceKeypoint.new(0.85, 0.35),
            NumberSequenceKeypoint.new(1, 1)
        })
        boxGradient.Parent = box
        
        local padding = Instance.new("UIPadding", box)
        padding.PaddingLeft = UDim.new(0, 8)
        padding.PaddingRight = UDim.new(0, 8)
        
        local layout = Instance.new("UIListLayout", box)
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.VerticalAlignment = Enum.VerticalAlignment.Center
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.Padding = UDim.new(0, 3) 
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        
        local icon = Instance.new("ImageLabel", box)
        icon.Name = "Icon"
        icon.Size = UDim2.new(0, 12, 0, 12)
        icon.BackgroundTransparency = 1
        icon.ZIndex = 3
        icon.LayoutOrder = 1
        icon.Visible = false
        
        local txt = Instance.new("TextLabel", box)
        txt.Name = "Text"
        txt.AutomaticSize = Enum.AutomaticSize.X
        txt.Size = UDim2.new(0, 0, 1, 0)
        txt.BackgroundTransparency = 1
        txt.Font = Enum.Font.GothamMedium 
        txt.TextSize = 10 
        txt.ZIndex = 3
        txt.LayoutOrder = 2
        txt.RichText = true
        txt.TextXAlignment = Enum.TextXAlignment.Center
        txt.TextYAlignment = Enum.TextYAlignment.Center

        local line = Instance.new("Frame")
        line.Name = "Line"
        line.Size = UDim2.new(0, 1, 0, 10) 
        line.Position = UDim2.new(0.5, 0, 0, 15) 
        line.AnchorPoint = Vector2.new(0.5, 0) 
        line.BorderSizePixel = 0
        line.ZIndex = 1
        line.Parent = billboard 

        local lineGradient = Instance.new("UIGradient")
        lineGradient.Rotation = 90
        lineGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1) 
        })
        lineGradient.Parent = line
    end
    
    billboard.Line.BackgroundColor3 = config.color
    
    local iconLabel = billboard.Box:FindFirstChild("Icon")
    if config.icon and config.icon ~= "" then
        if iconLabel then
            iconLabel.Image = config.icon
            iconLabel.Visible = true
        end
    else
        if iconLabel then
            iconLabel.Visible = false
        end    end
    
    local hexColor = string.format("#%02X%02X%02X", config.color.R * 255, config.color.G * 255, config.color.B * 255)
    
    if config.distance then
        billboard.Box.Text.Text = string.format("<font color='#FFFFFF'>%s</font> <font color='%s'>[%dm]</font>", config.name, hexColor, config.distance)
    elseif config.subtext then
        billboard.Box.Text.Text = string.format("<font color='#FFFFFF'>%s</font> <font color='%s'>%s</font>", config.name, hexColor, config.subtext)
    else
        billboard.Box.Text.Text = string.format("<font color='#FFFFFF'>%s</font>", config.name)
    end
end
-- ==================== CORE ESP LOGIC ====================
function ClearESP(tipe) 
    if tipe == "Player" then 
        for _, p in pairs(Players:GetPlayers()) do 
            if p.Character then 
                if p.Character:FindFirstChild("PEH") then p.Character.PEH:Destroy() end
                if p.Character:FindFirstChild("PE_Text") then p.Character.PE_Text:Destroy() end 
            end 
        end 
    elseif tipe == "Killer" then 
        for _, p in pairs(Players:GetPlayers()) do 
            if p.Character then 
                if p.Character:FindFirstChild("KEH") then p.Character.KEH:Destroy() end
                if p.Character:FindFirstChild("KE_Text") then p.Character.KE_Text:Destroy() end 
            end 
        end 
    elseif tipe == "Generator" then 
        for _, v in pairs(Cache.Generators) do 
            if v.model and v.model.Parent then 
                if v.model:FindFirstChild("GEH") then v.model.GEH:Destroy() end
                if v.model:FindFirstChild("GE_Text") then v.model.GE_Text:Destroy() end 
            end 
        end 
    elseif tipe == "Pallet" then 
        for _, v in pairs(Cache.Pallets) do 
            if v and v.Parent then 
                if v:FindFirstChild("PalletEH") then v.PalletEH:Destroy() end 
            end 
        end
    elseif tipe == "Hook" then 
        for _, v in pairs(Cache.Hooks) do 
            if v and v.Parent then 
                if v:FindFirstChild("HookEH") then v.HookEH:Destroy() end
            end 
        end
    elseif tipe == "Window" then 
        for _, v in pairs(Cache.Windows) do 
            if v and v.Parent then 
                if v:FindFirstChild("WindowEH") then v.WindowEH:Destroy() end
            end 
        end
    elseif tipe == "Gate" then 
        for _, v in pairs(Cache.Gates) do 
            if v and v.Parent then 
                if v:FindFirstChild("GateEH") then v.GateEH:Destroy() end
            end 
        end
    elseif tipe == "SCP" then 
        for _, v in pairs(Cache.SCPs) do 
            if v and v.Parent then 
                if v:FindFirstChild("SCPEH") then v.SCPEH:Destroy() end
            end 
        end
    end 
end

function ClearAllESP() 
    ClearESP("Player") 
    ClearESP("Killer") 
    ClearESP("Generator") 
    ClearESP("Pallet") 
    ClearESP("Hook") 
    ClearESP("Gate") 
    ClearESP("SCP") 
    ClearESP("Window")
    ClearHookESP()  -- ← TAMBAHKAN INI
end

function UpdatePlayerESP()
    if not Config.ESP_Master then return end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    
    if Config.ESP_KillerWarn and myHRP and GetRole() == "Survivor" then
        local warn = myHRP:FindFirstChild("KillerWarn")
        local closestDist = math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and IsKiller(p) and p.Character then
                local kHrp = p.Character:FindFirstChild("HumanoidRootPart")
                if kHrp then
                    local dist = (kHrp.Position - myHRP.Position).Magnitude
                    if dist < closestDist then closestDist = dist end
                end
            end
        end
        if closestDist <= 80 then
            if not warn then
                warn = Instance.new("BillboardGui")
                warn.Name = "KillerWarn"
                warn.Size = UDim2.new(0, 30, 0, 30)
                warn.AlwaysOnTop = true
                warn.StudsOffset = Vector3.new(0, 4, 0)
                warn.Parent = myHRP
                local txt = Instance.new("TextLabel")
                txt.Name = "WarnText"
                txt.Size = UDim2.new(1,0,1,0)
                txt.BackgroundTransparency = 1
                txt.TextScaled = true
                txt.TextStrokeTransparency = 0
                txt.Font = Enum.Font.GothamBlack
                txt.Parent = warn
            end
            local txt = warn:FindFirstChild("WarnText")
            if txt then
                if closestDist <= 40 then
                    txt.Text = "!!"
                    txt.TextColor3 = Color3.fromRGB(255, 0, 0) 
                else
                    txt.Text = "!"
                    txt.TextColor3 = Color3.fromRGB(255, 255, 0) 
                end
            end
        else
            if warn then warn:Destroy() end
        end
    else
        local warn = myHRP and myHRP:FindFirstChild("KillerWarn")
        if warn then warn:Destroy() end
    end
    
    if Config.ESP_Player or Config.ESP_Killer then
        for _, p in pairs(Players:GetPlayers()) do 
            if p ~= LocalPlayer and p.Character then
                local killerStatus = IsKiller(p)
                local root = p.Character:FindFirstChild("Head")
                if root and ((not killerStatus and Config.ESP_Player) or (killerStatus and Config.ESP_Killer)) then
                    local distance = myHRP and math.floor((root.Position - myHRP.Position).Magnitude) or 0
                    local col = killerStatus and Tuning.Colors.Killer or Tuning.Colors.Player
                    local hName = killerStatus and "KEH" or "PEH"
                    local tName = killerStatus and "KE_Text" or "PE_Text"
                    
                    local highlight = p.Character:FindFirstChild(hName)
                    if not highlight then 
                        highlight = Instance.new("Highlight")
                        highlight.Name = hName
                        highlight.Parent = p.Character 
                    end
                    highlight.FillColor = col
                    highlight.OutlineColor = col
                    highlight.FillTransparency = Config.ESP_Outline and 1 or 0.5
                    highlight.OutlineTransparency = 0
                    
                    if Config.ESP_Name then
    local equippedIcon = nil

    if Config.ESP_ItemIcon and not killerStatus then
        local equippedName = p:GetAttribute("EquippedItem")
        if equippedName and equippedName ~= "" then
            equippedIcon = getItemIcon(equippedName)
        end
    end

    CreateModernESP(p.Character, tName, {
        name = p.Name,
        distance = Config.ESP_Distance and distance or nil,
        color = col,
        icon = equippedIcon
    })
else
    local old = p.Character:FindFirstChild(tName)
    if old then old:Destroy() end
end
                end
            end 
        end
    end
end

function UpdateSCPESP()
    if not Config.ESP_Master then return end
    if Config.ESP_SCP then
        for _, obj in ipairs(Cache.SCPs) do
            if obj and obj.Parent then
                local hum = obj:FindFirstChildOfClass("Humanoid")
                local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso") or obj.PrimaryPart
                
                if hum and root and hum.Health > 0 and math.floor(hum.WalkSpeed) == 9 then
                    local col = Tuning.Colors.SCP
                    local highlight = obj:FindFirstChild("SCPEH")
                    if not highlight then 
                        highlight = Instance.new("Highlight")
                        highlight.Name = "SCPEH"
                        highlight.Parent = obj 
                    end
                    highlight.FillColor = col
                    highlight.OutlineColor = col
                    highlight.FillTransparency = Config.ESP_Outline and 1 or 0.5
                    highlight.OutlineTransparency = 0
                else
                    local h = obj:FindFirstChild("SCPEH")
                    if h then h:Destroy() end
                end
            end
        end
    else
        ClearESP("SCP")
    end
end

function UpdateStaticESP()
    if not Config.ESP_Master then return end
    if Config.ESP_Generator then
    for i, vData in pairs(Cache.Generators) do 
        local v = vData.model
        if v and v.Parent then
            local progress = math.floor(v:GetAttribute("RepairProgress") or 0)
            local col = (progress >= 100) and Tuning.Colors.GeneratorDone or Tuning.Colors.Generator
            
            local h = v:FindFirstChild("GEH")
            if not h then 
                h = Instance.new("Highlight")
                h.Name = "GEH"
                h.Parent = v 
            end
            h.FillColor = col
            h.OutlineColor = col
            h.FillTransparency = Config.ESP_Outline and 1 or 0.5
            h.OutlineTransparency = 0
            
            if Config.ESP_GeneratorName then
                local displayName = "GEN"
                local displaySubtext = ""
                
                if progress >= 100 then
                    displaySubtext = "DONE 100%"
                else
                    displaySubtext = string.format("%d%%", progress)
                end
                
                CreateModernESP(v, "GE_Text", {
                    name = displayName,
                    subtext = displaySubtext,
                    color = col,
                    icon = nil
                })
            else
                local oldText = v:FindFirstChild("GE_Text")
                if oldText then oldText:Destroy() end
            end
        end
    end
end
    if Config.ESP_Pallet then
        for _, v in pairs(Cache.Pallets) do
            if v and v.Parent then
                local h = v:FindFirstChild("PalletEH")
                if not h then 
                    h = Instance.new("Highlight")
                    h.Name = "PalletEH"
                    h.Parent = v
                end
                h.Adornee = v 
                h.FillColor = Tuning.Colors.Pallet
                h.OutlineColor = Tuning.Colors.Pallet
                h.FillTransparency = Config.ESP_Outline and 1 or 0.5
                h.OutlineTransparency = 0
            end
        end
    end
    if Config.ESP_Window then
        for i, v in ipairs(Cache.Windows) do 
            if v and v.Parent then
                local targetPart = v:FindFirstChild("Bottom") or v:FindFirstChildWhichIsA("BasePart")
                if targetPart then
                    local h = v:FindFirstChild("WindowEH")
                    if not h then 
                        h = Instance.new("BoxHandleAdornment")
                        h.Name = "WindowEH"
                        h.Parent = v 
                        h.AlwaysOnTop = true
                        h.ZIndex = 5
                    end
                    h.Adornee = targetPart
                    h.Size = targetPart.Size
                    h.Color3 = Tuning.Colors.Window
                    h.Transparency = Config.ESP_Outline and 0.8 or 0.4
                end
            end 
        end
    end
    if Config.ESP_Hook then
        for i, v in ipairs(Cache.Hooks) do 
            if v and v.Parent then
                local h = v:FindFirstChild("HookEH")
                if not h then 
                    h = Instance.new("Highlight")
                    h.Name = "HookEH"
                    h.Parent = v 
                end
                h.FillColor = Tuning.Colors.Hook
                h.OutlineColor = Tuning.Colors.Hook
                h.FillTransparency = Config.ESP_Outline and 1 or 0.5
                h.OutlineTransparency = 0
            end 
        end
    end
    if Config.ESP_Gate then
        for i, v in ipairs(Cache.Gates) do 
            if v and v.Parent then
                local h = v:FindFirstChild("GateEH")
                if not h then 
                    h = Instance.new("Highlight")
                    h.Name = "GateEH"
                    h.Parent = v 
                end
                    h.Adornee = v
                h.FillColor = Tuning.Colors.Gate
                h.OutlineColor = Tuning.Colors.Gate
                h.FillTransparency = Config.ESP_Outline and 1 or 0.5
                h.OutlineTransparency = 0
            end 
        end
    end
end

-- ==================== AUTO SCAN MAP ====================

function ForceRefreshMap()
    ScanMap()
    
    if Config.ESP_Master then
        ClearAllESP()
        task.wait(0.1)
        UpdatePlayerESP()
        UpdateSCPESP()
        UpdateStaticESP()
    end
    
    pcall(function()
        local genCount = #Cache.Generators or 0
        local palletCount = #Cache.Pallets or 0
        if Library and Library.Notify then
        end
    end)
end

-- ===== LAYER 1: SCAN PERTAMA KALI =====
task.spawn(function()
    task.wait(2)
    ScanMap()
    pcall(function()
    end)
end)

-- ===== LAYER 2: SCAN SAAT RESPAWN =====
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1.5)
    ScanMap()
    
    if Config.ESP_Master then
        task.spawn(function()
            task.wait(0.5)
            ClearAllESP()
            task.wait(0.2)
            UpdatePlayerESP()
            UpdateSCPESP()
            UpdateStaticESP()
        end)
    end
end)

-- ===== LAYER 3: SCAN SAAT MAP BERUBAH =====
workspace.ChildAdded:Connect(function(child)
    if child.Name == "Map" then
        task.wait(1)
        ScanMap()
    end
end)

-- ===== LAYER 4: SCAN PERIODIK =====
task.spawn(function()
    while true do
        task.wait(40)
        if Config.ESP_Master or AutoPalletEnabled then
            ScanMap()
            if Config.ESP_Master then
                pcall(UpdateStaticESP)
                pcall(UpdatePlayerESP)
                pcall(UpdateSCPESP)
            end
        end
    end
end)

-- ===== LAYER 5: PANTAU WORKSPACE CHANGES =====
local mapCheckConn = nil
local lastMapCheck = 0

mapCheckConn = RunService.Heartbeat:Connect(function()
    local now = tick()
    if now - lastMapCheck <3 then return end
    lastMapCheck = now
    
    local map = workspace:FindFirstChild("Map")
    if map then
        local childCount = #map:GetChildren()
        if not getgenv()._lastMapChildCount then
            getgenv()._lastMapChildCount = childCount
        elseif getgenv()._lastMapChildCount ~= childCount then
            getgenv()._lastMapChildCount = childCount
            task.spawn(function()
                task.wait(0.5)
                ScanMap()
            end)
        end
    else
        getgenv()._lastMapChildCount = nil
    end
end)

pcall(function()
    game:BindToClose(function()
        if mapCheckConn then mapCheckConn:Disconnect() end
    end)
end)


if CoreGui:FindFirstChild("FOVCircleGui_Standalone") then 
    CoreGui:FindFirstChild("FOVCircleGui_Standalone"):Destroy() 
end

local FOVGui = Instance.new("ScreenGui")
FOVGui.Name = "FOVCircleGui_Standalone"
FOVGui.Parent = CoreGui
FOVGui.ResetOnSpawn = false
FOVGui.IgnoreGuiInset = true

local FOVFrame = Instance.new("Frame")
FOVFrame.BackgroundTransparency = 1
FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FOVFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVFrame.Visible = false
FOVFrame.Parent = FOVGui

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVFrame

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = Color3.fromRGB(0, 255, 100)
FOVStroke.Thickness = 1.5
FOVStroke.Parent = FOVFrame

local VeilFOVFrame = Instance.new("Frame")
VeilFOVFrame.BackgroundTransparency = 1
VeilFOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
VeilFOVFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
VeilFOVFrame.Visible = false
VeilFOVFrame.Parent = FOVGui
Instance.new("UICorner", VeilFOVFrame).CornerRadius = UDim.new(1, 0)
local VeilFOVStroke = Instance.new("UIStroke", VeilFOVFrame)
VeilFOVStroke.Color = Color3.fromRGB(0, 255, 100)
VeilFOVStroke.Thickness = 1.5

-- ===== VEIL TRACKER =====
local VeilTrackerGui = Instance.new("ScreenGui")
VeilTrackerGui.Name = "VeilTrackerGui"
VeilTrackerGui.IgnoreGuiInset = true
VeilTrackerGui.ResetOnSpawn = false
VeilTrackerGui.Parent = CoreGui

-- Garis hijau (snapline)
local VeilTrackerLine = Instance.new("Frame")
VeilTrackerLine.Name = "Line"
VeilTrackerLine.AnchorPoint = Vector2.new(0.5, 0.5)
VeilTrackerLine.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
VeilTrackerLine.BackgroundTransparency = 0.2
VeilTrackerLine.BorderSizePixel = 0
VeilTrackerLine.Visible = false
VeilTrackerLine.Parent = VeilTrackerGui

-- Circle di target (BillboardGui = sama stabil Highlight)
local function makeVeilBillboard()
    local bb = Instance.new("BillboardGui")
    bb.Name = "VeilTrackerBillboard"
    bb.Size = UDim2.fromOffset(14, 14)
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.MaxDistance = 500

    local ring = Instance.new("Frame")
    ring.AnchorPoint = Vector2.new(0.5, 0.5)
    ring.Position = UDim2.fromScale(0.5, 0.5)
    ring.Size = UDim2.fromScale(1, 1)
    ring.BackgroundTransparency = 1
    ring.Parent = bb
    Instance.new("UICorner", ring).CornerRadius = UDim.new(1, 0)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 255, 100)
    stroke.Thickness = 1
    stroke.Transparency = 0.1
    stroke.Parent = ring

    return bb
end

local currentVeilBillboard = nil

function getBestAimbotTarget()
    local bestTarget = nil
    local myRole = GetRole()
    
    local shortestFovDist = Config.Surv_Aimbot_Radius
    local shortest3DDist = math.huge
    local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local isValidTarget = false
            
            if myRole == "Survivor" and Config.Surv_Aimbot_Enabled and IsKiller(p) then
                isValidTarget = true
            elseif myRole == "Killer" and Config.Killer_Aimbot_Enabled and not IsKiller(p) then
                local hum = p.Character:FindFirstChild("Humanoid")
                if hum and hum.Health > 0 and not IsDowned(p.Character) then
                    isValidTarget = true
                end
            end
            
            if isValidTarget then 
                local hrp = p.Character.HumanoidRootPart
                local dist3D = GetDistance(hrp.Position)
                
                if myRole == "Survivor" and dist3D <= Config.Surv_Aimbot_MaxDist then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then 
                        local targetPos2D = Vector2.new(screenPos.X, screenPos.Y)
                        local dist2D = (targetPos2D - centerScreen).Magnitude
                        if dist2D < shortestFovDist then 
                            shortestFovDist = dist2D
                            bestTarget = hrp 
                        end 
                    end
                    
                elseif myRole == "Killer" and dist3D <= Config.Killer_Aimbot_MaxDist then
                    if dist3D < shortest3DDist then 
                        shortest3DDist = dist3D
                        bestTarget = hrp
                    end
                end
            end
        end
    end
    return bestTarget
end

function GetKillerUI()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return nil end
    for _, gui in pairs(playerGui:GetChildren()) do
        if string.sub(gui.Name, -4) == "-mob" and gui.Name ~= "Survivor-mob" then
            return gui
        end
    end
    return nil
end

local currentTouchInput = nil
local isHoldingAbyssal = false
local currentTouchAbyssalInput = nil
function FireAbyssalSkill()
    if GetRole() ~= "Killer" then return end
    local selectedKillerObj = LocalPlayer:FindFirstChild("SelectedKiller")
    local killerName = selectedKillerObj and selectedKillerObj.Value or LocalPlayer:GetAttribute("SelectedKiller")
    
    if string.find(string.lower(tostring(killerName)), "abyss") then
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.Killers.Abysswalker.corrupt:FireServer()
        end)
    end
end
function StartInfiniteAbyssal()
    if isHoldingAbyssal then return end
    isHoldingAbyssal = true
    
    task.spawn(function()
        while isHoldingAbyssal and Config.Killer_InfAbyssal and GetRole() == "Killer" do
            FireAbyssalSkill()
            task.wait(0.5)
        end
    end)
end

function StopInfiniteAbyssal()
    isHoldingAbyssal = false
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    local isTouch = (input.UserInputType == Enum.UserInputType.Touch)
    local myRole = GetRole()
    
    if Config.Killer_InfAbyssal and input.KeyCode == Enum.KeyCode.Q then
        StartInfiniteAbyssal()
    end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if gameProcessedEvent then return end 
        
        if myRole == "Killer" and Config.Killer_Aimbot_Enabled then
            lockedAimbotTarget = getBestAimbotTarget()
            if lockedAimbotTarget then 
                isAimbotHolding = true 
            end
        end
    end
    
    if isTouch then
    if Config.Killer_InfAbyssal then
            local killerUI = GetKillerUI()
            local move1Btn = killerUI and killerUI:FindFirstChild("Controls") and killerUI.Controls:FindFirstChild("move2")
            
            if move1Btn and move1Btn.Visible then
                local pos = input.Position
                local absPos = move1Btn.AbsolutePosition
                local absSize = move1Btn.AbsoluteSize
                
                if pos.X >= absPos.X and pos.X <= (absPos.X + absSize.X) and pos.Y >= absPos.Y and pos.Y <= (absPos.Y + absSize.Y) then
                    StartInfiniteAbyssal()
                    currentTouchAbyssalInput = input
                end
            end
        end
        if myRole == "Killer" and Config.Killer_Aimbot_Enabled then
            local killerUI = GetKillerUI()
            local attackBtn = killerUI and killerUI:FindFirstChild("Controls") and killerUI.Controls:FindFirstChild("attack")
            
            if attackBtn and attackBtn.Visible then
                local pos = input.Position
                local absPos = attackBtn.AbsolutePosition
                local absSize = attackBtn.AbsoluteSize
                
                if pos.X >= absPos.X and pos.X <= (absPos.X + absSize.X) and pos.Y >= absPos.Y and pos.Y <= (absPos.Y + absSize.Y) then
                    lockedAimbotTarget = getBestAimbotTarget()
                    if lockedAimbotTarget then 
                        isAimbotHolding = true 
                        currentTouchInput = input
                    end
                end
            end
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
    local isTouchEnd = (input.UserInputType == Enum.UserInputType.Touch)
    if input.KeyCode == Enum.KeyCode.Q then
        StopInfiniteAbyssal()
    end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isAimbotHolding = false
        lockedAimbotTarget = nil
    end
    if isTouchEnd and input == currentTouchAbyssalInput then
        StopInfiniteAbyssal()
        currentTouchAbyssalInput = nil
    end
    if isTouchEnd and input == currentTouchInput then
        isAimbotHolding = false
        lockedAimbotTarget = nil
        currentTouchInput = nil
    end
end)

-- ==================== SILENT AIM INPUT HANDLER ====================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    local isTouch = (input.UserInputType == Enum.UserInputType.Touch)
    
    if gameProcessed and not isTouch then return end 
    
    local char = player.Character
    local isSpearMode = char and char:GetAttribute("spearmode") == true

    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        if AimConfig.Aim_Silent then 
            isChargingPistol = true 
            lockedTarget = getPistolTarget()
        end
        if AimConfig.Flash_Silent then
            isAimingFlash = true
        end
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
        if AimConfig.Aim_Silent and isChargingPistol then 
            executeSilentAimFire() 
        end
        
        if IsVeilSilentOn() and isSpearMode then 
    isChargingSpear = true 
end
    elseif isTouch then
        if (AimConfig.Aim_Silent or AimConfig.Flash_Silent) then
            local playerGui = player:FindFirstChild("PlayerGui")
            if playerGui then
                local survivorMob = playerGui:FindFirstChild("Survivor-mob")
                if survivorMob then
                    local controls = survivorMob:FindFirstChild("Controls")
                    if controls then
                        local targetBtn = controls:FindFirstChild("Gui-mob") 
                        if targetBtn and targetBtn.Visible then
                            local pos = input.Position
                            local absPos = targetBtn.AbsolutePosition
                            local absSize = targetBtn.AbsoluteSize
                            
                            if pos.X >= absPos.X and pos.X <= (absPos.X + absSize.X) and pos.Y >= absPos.Y and pos.Y <= (absPos.Y + absSize.Y) then
                                
                                if AimConfig.Aim_Silent then
                                    isChargingPistol = true
                                    currentTouchInput = input
                                    lockedTarget = getPistolTarget()
                                end

                                if AimConfig.Flash_Silent then
                                    isAimingFlash = true
                                    currentTouchInput = input -- Simpan input jari ini
                                end
                                
                            end
                        end
                    end
                end
            end
        end
        
        if IsVeilSilentOn() and isSpearMode then
            local playerGui = player:FindFirstChild("PlayerGui")
            if playerGui then
                local slasherMob = playerGui:FindFirstChild("Slasher-mob")
                if slasherMob then
                    local controls = slasherMob:FindFirstChild("Controls")
                    if controls then
                        local attackBtn = controls:FindFirstChild("attack")
                        if attackBtn and attackBtn.Visible then
                            local pos = input.Position
                            local absPos = attackBtn.AbsolutePosition
                            local absSize = attackBtn.AbsoluteSize
                            if pos.X >= absPos.X and pos.X <= (absPos.X + absSize.X) and pos.Y >= absPos.Y and pos.Y <= (absPos.Y + absSize.Y) then
                                isChargingSpear = true
                                currentTouchInput = input
                            end
                        end
                    end
                end
            end
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    local isTouchEnd = (input.UserInputType == Enum.UserInputType.Touch)
    
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        if isChargingPistol then 
            isChargingPistol = false 
            lockedTarget = nil
        end
        if isAimingFlash then
            isAimingFlash = false
        end
    end

    if isChargingSpear and (input == currentTouchInput or input.UserInputType == Enum.UserInputType.MouseButton1) then
        isChargingSpear = false
        if currentTouchInput == input then currentTouchInput = nil end
        
        if isAttackCooldown then return end
        isAttackCooldown = true
        task.delay(2, function() isAttackCooldown = false end)
        
        local myChar = LocalPlayer.Character
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local startPart = myChar and (myChar:FindFirstChild("Head") or myHRP)
        
        if startPart and myHRP then
            local isSpecial = myChar:GetAttribute("special") == true
            local startPos = Config.SpearSmart_enable and myHRP.Position or startPart.Position
            
            -- Jika menggunakan SmartPredict, kecepatan tombak otomatis menyesuaikan status Special
            local currentSpearSpeed = Config.SpearSmart_enable and (isSpecial and 165 or 142.5) or AimConfig.SPEAR_Speed
            
            local targetPart = getClosestSurvivor()
            local aimDirection
            
            if targetPart then
                local targetHRP = targetPart:IsA("Model") and targetPart:FindFirstChild("HumanoidRootPart") or targetPart
                local targetPos = targetHRP.Position
                local targetVel = Vector3.new(0, 0, 0)
                
                -- Kalkulasi kecepatan target yang lebih akurat (menggabungkan MoveDirection & Velocity)
                local targetHum = targetPart.Parent and targetPart.Parent:FindFirstChildOfClass("Humanoid")
                if targetHum and targetHum.MoveDirection.Magnitude > 0 then
                    targetVel = targetHum.MoveDirection * targetHum.WalkSpeed
                elseif targetHRP:IsA("BasePart") then
                    targetVel = targetHRP.AssemblyLinearVelocity
                end
                
                targetVel = Vector3.new(targetVel.X, 0, targetVel.Z) 
                
                local distance = (targetPos - startPos).Magnitude
                local timeToHit = distance / currentSpearSpeed 
                
                if Config.SpearSmart_enable then
    -- Mode Kalkulasi Smart Predict (Akurasi Tinggi)
    local spearGravity = workspace.Gravity * 0.5 
    local leadMultiplier = AimConfig.Veil_LeadMultiplier  -- <-- PAKAI DARI SLIDER
    local predictedPos = targetPos + (targetVel * (timeToHit * leadMultiplier))
    
    local dropCompensation = 0.5 * spearGravity * (timeToHit ^ 2)
    local finalAimPos = predictedPos + Vector3.new(0, dropCompensation - 1.5, 0)
    
    aimDirection = (finalAimPos - startPos).Unit
                else
                    -- Mode Kalkulasi Default (Memakai Settingan AimConfig)
                    local dynamicPrediction = math.clamp(distance / 50, 0.1, 4.0)
                    local predictedPos = targetPos + (targetVel * (timeToHit * dynamicPrediction))
                    local distanceMultiplier = math.clamp(distance / 100, 1, 2.5)
                    
                    local autoGravity = math.max(0, distance - 8)
                    local gravity = AimConfig.AIM_Auto and autoGravity or AimConfig.SPEAR_Gravity
                    
                    local dropCompensation = 0.5 * gravity * (timeToHit ^ 2) * distanceMultiplier
                    local finalAimPos = predictedPos + Vector3.new(0, dropCompensation, 0)
                    
                    aimDirection = (finalAimPos - startPos).Unit
                end
            else
                -- Jika tidak ada target, tembak lurus sesuai arah kamera
                aimDirection = Camera.CFrame.LookVector
            end
            
            -- V1 saja yang fire manual
            -- V1 saja yang fire manual
            if AimConfig.Aim_SilentVeil then
                pcall(function()
                    ReplicatedStorage.Remotes.Killers.Veil.Spearthrow:FireServer(aimDirection, currentSpearSpeed, startPos)
                end)
            end
            -- Kalau V2: tidak fire di sini
        end   -- ← nutup if startPart and myHRP
    end       -- ← nutup if isChargingSpear
    
    if isTouchEnd and input == currentTouchInput then
        if isChargingPistol then
            isChargingPistol = false
            currentTouchInput = nil
            executeSilentAimFire()
            lockedTarget = nil
        end
        if isAimingFlash then
            isAimingFlash = false
            currentTouchInput = nil
        end
    end
end)

-- ==================== BYPASS GENERATOR ====================
local RepairEvent = game:GetService("ReplicatedStorage").Remotes.Generator.RepairEvent
local GenCache = {}
local GenCacheTimer = 0
function GetAllGenerators()
    local now = tick()
    if now - GenCacheTimer < 5 then return GenCache end
    GenCache = {}
    GenCacheTimer = now
    local mapFolder = workspace:FindFirstChild("Map")
    if not mapFolder then return GenCache end
    pcall(function()
        for _, v in pairs(mapFolder:GetDescendants()) do
            if not v:IsA("Model") then continue end
            if v.Name ~= "Generator" then continue end
            local isRealGen = v:GetAttribute("RepairProgress") ~= nil
                or v:GetAttribute("kickcount") ~= nil
                or v:GetAttribute("ProgressRepair") ~= nil
            if not isRealGen then continue end
            table.insert(GenCache, v)
        end
    end)
    return GenCache
end

PlayRepairAnim = function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local animator = hum and hum:FindFirstChildOfClass("Animator")
    if not animator then return end
    if RepairAnimTrack and RepairAnimTrack.IsPlaying then return end
    pcall(function()
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://92960319113695"
        RepairAnimTrack = animator:LoadAnimation(anim)
        RepairAnimTrack.Priority = Enum.AnimationPriority.Action
        RepairAnimTrack:Play()
    end)
end
 
StopRepairAnim = function()
    if RepairAnimTrack and RepairAnimTrack.IsPlaying then
        pcall(function() RepairAnimTrack:Stop() end)
    end
    RepairAnimTrack = nil
end

GetGeneratorPoints = function(genModel)
    local points = {}
    pcall(function()
        for _, obj in pairs(genModel:GetChildren()) do
            if obj.Name:find("GeneratorPoint") and obj:IsA("BasePart") then
                table.insert(points, obj)
            end
        end
    end)
    return points
end

StopAutoRepair = function()
    StopRepairAnim()
    local pointToStop = AutoCurrentPoint
    AutoCurrentPoint = nil
    if pointToStop then
        pcall(function() RepairEvent:FireServer(pointToStop, false) end)
    end
end

StartAutoRepairLoop = function(genModel)
    AutoCurrentGenModel = genModel

    if AutoRepairThread then
        task.cancel(AutoRepairThread)
        AutoRepairThread = nil
    end
    StopAutoRepair()

    AutoRepairThread = task.spawn(function()
        while AutoRepairEnabled and BypassGenEnabled do
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then task.wait(0.1) continue end

            local foundPoint = nil
            for _, gen in pairs(GetAllGenerators()) do
                for _, point in pairs(GetGeneratorPoints(gen)) do
                    if (hrp.Position - point.Position).Magnitude <= 5 then
                        foundPoint = point
                        break
                    end
                end
                if foundPoint then break end
            end

            if foundPoint then
                AutoCurrentPoint = foundPoint
                local now = tick()
                if now - LastFireTime >= AutoFireInterval then
                    PlayRepairAnim()
                    pcall(function() RepairEvent:FireServer(foundPoint, true) end)
                    LastFireTime = now
                end
            else
                if AutoCurrentPoint then
                    StopAutoRepair()
                    AutoRepairEnabled = false

                    if AutoCurrentGenModel then
                        ProcessedGens[AutoCurrentGenModel] = nil
                        AutoCurrentGenModel = nil                    end
                    break
                end
            end

            task.wait(0.1)
        end
        StopAutoRepair()
    end)
end

waitForRepairing = function(point, timeout)
    local start = tick()
    while tick() - start < (timeout or 1) do
        if point:GetAttribute("IsRepairing") == true then
            return true
        end
        task.wait(0.05)
    end
    return false
end

local BypassToggleValue = false

function RecreateBypassButton()
    local oldUI = CoreGui:FindFirstChild("BypassGenUI")
    if oldUI then oldUI:Destroy() end

    BypassUI = Instance.new("ScreenGui")
    BypassUI.Name = "BypassGenUI"
    BypassUI.ResetOnSpawn = false
    BypassUI.IgnoreGuiInset = true
    BypassUI.Parent = CoreGui

    BypassButton = Instance.new("ImageButton")
    BypassButton.Name = "BypassGenButton"
    BypassButton.Size = UDim2.new(0, 55, 0, 55)
    BypassButton.Position = UDim2.new(0.88, 0, 0.55, 0)
    BypassButton.AnchorPoint = Vector2.new(0.5, 0.5)
    BypassButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    BypassButton.BackgroundTransparency = 0.15
    BypassButton.AutoButtonColor = true
    BypassButton.Visible = false
    BypassButton.ZIndex = 10
    BypassButton.Parent = BypassUI

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = BypassButton

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Thickness = 1.5
    UIStroke.Transparency = 0.4
    UIStroke.Parent = BypassButton

    local BypassLabel = Instance.new("TextLabel")
    BypassLabel.Size = UDim2.new(1, 0, 1, 0)
    BypassLabel.BackgroundTransparency = 1
    BypassLabel.Text = "GEN"
    BypassLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    BypassLabel.TextScaled = true
    BypassLabel.Font = Enum.Font.GothamBold
    BypassLabel.ZIndex = 11
    BypassLabel.Parent = BypassButton

    BypassButton.Visible = BypassToggleValue and UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end
RecreateBypassButton()

DoMultiRepairPlain = function(targetPoint)
    local genModel = targetPoint.Parent
    if ProcessedGens[genModel] then return end

    ProcessedGens[genModel] = true

    local allPoints = GetGeneratorPoints(genModel)
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then ProcessedGens[genModel] = nil return end

    local originalCFrame = hrp.CFrame
    local ok = pcall(function()
        for _, point in pairs(allPoints) do
            if point ~= targetPoint and point.Parent then
                hrp.Anchored = true
                hrp.CFrame = point.CFrame
                task.wait(0.15)

                pcall(function() RepairEvent:FireServer(point, true) end)

                if not waitForRepairing(point, 0.8) then
                    pcall(function() RepairEvent:FireServer(point, false) end)
                    task.wait(0.1)
                    hrp.CFrame = point.CFrame
                    task.wait(0.15)
                    pcall(function() RepairEvent:FireServer(point, true) end)
                    waitForRepairing(point, 0.5)
                end

                hrp.Anchored = false
                task.wait(0.05)
            end
        end
    end)

    pcall(function()
        if hrp and hrp.Parent then
            hrp.Anchored = false
            hrp.CFrame = originalCFrame
        end
    end)

    task.wait(0.1)
    if BypassGenMode == "Manual Repair" then
        pcall(function() RepairEvent:FireServer(targetPoint, false) end)
    elseif BypassGenMode == "Auto Repair" then
        AutoRepairEnabled = true
        StartAutoRepairLoop(genModel)
    end
end

BypassButton.MouseButton1Click:Connect(function()
    if not BypassGenEnabled then return end

    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local bestPoint, bestDist = nil, math.huge
    for _, gen in pairs(GetAllGenerators()) do
        for _, point in pairs(GetGeneratorPoints(gen)) do
            local d = (hrp.Position - point.Position).Magnitude
            if d < bestDist then
                bestDist = d
                bestPoint = point
            end
        end
    end

    if bestPoint and bestDist <= 8 then
        DoMultiRepairPlain(bestPoint)
    else
        if notif then notif("Ga deket generator manapun!") end
    end
end)

isGeneratorPromptVisible = function()
    local ok, frame = pcall(function()
        return LocalPlayer.PlayerGui.pcprompts.Frame.GeneratorRepair
    end)
    return ok and frame and frame.Visible
end

getNearestGenPoint = function()
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local bestPoint, bestDist = nil, math.huge
    for _, gen in pairs(GetAllGenerators()) do
        for _, point in pairs(GetGeneratorPoints(gen)) do
            local d = (hrp.Position - point.Position).Magnitude
            if d < bestDist then
                bestDist = d
                bestPoint = point
            end
        end
    end
    return bestPoint, bestDist
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    if not BypassGenEnabled then return end
    if not isGeneratorPromptVisible() then return end

    local bestPoint, bestDist = getNearestGenPoint()
    if not bestPoint or bestDist > 8 then return end

    local genModel = bestPoint.Parent

    if ProcessedGens[genModel] then
        return
    end

    DoMultiRepairPlain(bestPoint)
end)

startProcessedGensWatcher = function()
    task.spawn(function()
        while true do
            task.wait(2)
            local character = LocalPlayer.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end

            for genModel in pairs(ProcessedGens) do
                if not genModel or not genModel.Parent then
                    ProcessedGens[genModel] = nil
                    continue
                end

                local points = GetGeneratorPoints(genModel)
                local nearAny = false
                for _, point in pairs(points) do
                    if point.Parent and (hrp.Position - point.Position).Magnitude <= 10 then
                        nearAny = true
                        break
                    end
                end

                if not nearAny then
                    ProcessedGens[genModel] = nil
                end
            end
        end
    end)
end

startProcessedGensWatcher()

-- ==========================================
-- RE-CREATE MOONWALK BUTTON
-- ==========================================
function RecreateMoonwalkButton()
    local oldUI = CoreGui:FindFirstChild("MoonwalkUI")
    if oldUI then oldUI:Destroy() end

    MoonwalkUI = Instance.new("ScreenGui")
    MoonwalkUI.Name = "MoonwalkUI"
    MoonwalkUI.ResetOnSpawn = false
    MoonwalkUI.IgnoreGuiInset = true
    MoonwalkUI.Parent = CoreGui

    MoonwalkButton = Instance.new("ImageButton")
    MoonwalkButton.Name = "MoonwalkButton"
    MoonwalkButton.Size = UDim2.new(0, 55, 0, 55)
    MoonwalkButton.Position = UDim2.new(0.88, 0, 0.48, 0)
    MoonwalkButton.AnchorPoint = Vector2.new(0.5, 0.5)
    MoonwalkButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    MoonwalkButton.BackgroundTransparency = 0.15
    MoonwalkButton.AutoButtonColor = true
    MoonwalkButton.Visible = MoonwalkButtonVisible
    MoonwalkButton.ZIndex = 10
    MoonwalkButton.Parent = MoonwalkUI

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = MoonwalkButton

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(255, 200, 50)
    UIStroke.Thickness = 1.5
    UIStroke.Transparency = 0.4
    UIStroke.Parent = MoonwalkButton

    local MoonwalkLabel = Instance.new("TextLabel")
    MoonwalkLabel.Name = "MoonwalkLabel"
    MoonwalkLabel.Size = UDim2.new(1, 0, 1, 0)
    MoonwalkLabel.BackgroundTransparency = 1
    MoonwalkLabel.Text = "🌙 OFF"
    MoonwalkLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    MoonwalkLabel.TextScaled = true
    MoonwalkLabel.Font = Enum.Font.GothamBold
    MoonwalkLabel.ZIndex = 11
    MoonwalkLabel.Parent = MoonwalkButton

    MoonwalkButton.MouseButton1Click:Connect(function()
        ToggleMoonwalk()
    end)

    UpdateMoonwalkStatus()
end

task.spawn(function()
    task.wait(1)
    RecreateMoonwalkButton()
    print("✅ Moonwalk button created!")
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    RecreateMoonwalkButton()
    if MoonwalkEnabled then
        setMoonwalk(true)
    end
end)

-- ==================== AUTO PARRY SENSOR ====================
function tapMobileParryButton()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return end

    local survivorMob = playerGui:FindFirstChild("Survivor-mob")
    local parryBtn = survivorMob
        and survivorMob:FindFirstChild("Controls")
        and survivorMob.Controls:FindFirstChild("Gui-mob")

    if parryBtn and parryBtn.Visible then
        if firesignal then
            pcall(function()
                firesignal(parryBtn.MouseButton1Down)
                task.wait(0.01)
                firesignal(parryBtn.MouseButton1Up)
            end)
        end
    else
        pcall(function()
            if mouse2click then
                mouse2click()
                return
            end
            if mouse2press and mouse2release then
                mouse2press()
                task.wait(0.01)
                mouse2release()
                return
            end
            if MouseButton2Click then
                MouseButton2Click()
                return
            end
            VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
            task.wait(0.01)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
        end)
    end
end

function ExecuteParry()
    if State.ParryCooldown then return end
    pcall(function()
        local parryRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"):FindFirstChild("Items"):FindFirstChild("Parrying Dagger"):FindFirstChild("parry")
        if parryRemote then
            for i = 1, 10 do parryRemote:FireServer() end
        end
        task.spawn(tapMobileParryButton)
    end)
end
function ListenToParryResult()
    task.spawn(function()
        local remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 5)
        local dagger = remotes and remotes:WaitForChild("Items", 5):WaitForChild("Parrying Dagger", 5)
        local parryResultRemote = dagger and dagger:WaitForChild("parryResult", 5)
        
        if parryResultRemote then
            parryResultRemote.OnClientEvent:Connect(function(arg1, arg2)
                local cdDur = tonumber(arg2) or ((arg1 == true) and 90 or 60)
                State.ParryCooldown = true
                if State.ParryCooldownThread then task.cancel(State.ParryCooldownThread) end
                State.ParryCooldownThread = task.delay(cdDur, function()
                    State.ParryCooldown = false
                end)
            end)
        end
    end)
end
ListenToParryResult()

function AttachParrySensor(kChar)
    if not kChar or Attached[kChar] then return end
    Attached[kChar] = true
    local humanoid = kChar:FindFirstChild("Humanoid")
    if not humanoid then
        humanoid = kChar:WaitForChild("Humanoid", 5)
        if not humanoid then return end
    end
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = humanoid:WaitForChild("Animator", 5)
        if not animator then return end
    end

    humanoid.ChildAdded:Connect(function(child)
        if child:IsA("Animator") then
            Attached[kChar] = nil
            AttachParrySensor(kChar)
        end
    end)

    kChar.AncestryChanged:Connect(function(_, parent)
        if not parent then
            Attached[kChar] = nil
        end
    end)

    animator.AnimationPlayed:Connect(function(track)
        local animId = track.Animation and track.Animation.AnimationId or ""
        local id = animId:match("%d+")
        local attackName = VALID_PARRY_IDS[id]
        if not attackName then return end
        if id == "80411309607666" and Config.Surv_AutoCrouch then
            local myChar = LocalPlayer.Character
            if IsDowned(myChar) then return end
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local kHRP = kChar:FindFirstChild("HumanoidRootPart")
            if myHRP and kHRP then
                local dist = (myHRP.Position - kHRP.Position).Magnitude
                if dist <= 40 then
                    TriggerCrouch()
                end
            end
            return 
        end
        
        if not Config.Surv_AutoParry then return end
        if State.ParryCooldown then return end 
        if Config.Ignored_Skills_List and Config.Ignored_Skills_List[attackName] then return end

        local myChar = LocalPlayer.Character
        if IsDowned(myChar) or not IsSafeToParry(myChar) then return end
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local kHRP = kChar:FindFirstChild("HumanoidRootPart")
        if not myHRP or not kHRP then return end
        
        local delta = myHRP.Position - kHRP.Position
        local startDistance = delta.Magnitude

        if Config.Surv_ParryAggressive then
            local aggressiveRadius = 12
            local detectionRadius = Config.Surv_ParryRadius + 5
            if startDistance > detectionRadius then return end
            if startDistance <= aggressiveRadius then
                ExecuteParry()
            else
                local tracker
                local startTime = os.clock()
                tracker = RunService.Heartbeat:Connect(function()
                    if os.clock() - startTime >= 1.5 or State.ParryCooldown or not myHRP or not kHRP or IsDowned(myChar) then
                        if tracker then tracker:Disconnect() end
                        return
                    end
                    local currentDist = (myHRP.Position - kHRP.Position).Magnitude
                    if currentDist <= aggressiveRadius then
                        ExecuteParry()
                        if tracker then tracker:Disconnect() end
                    end
                end)
            end
        else
            if startDistance > Config.Surv_ParryRadius then return end
            local myPosFlat = Vector3.new(myHRP.Position.X, 0, myHRP.Position.Z)
            local kPosFlat = Vector3.new(kHRP.Position.X, 0, kHRP.Position.Z)
            local flatDelta = myPosFlat - kPosFlat
            if flatDelta.Magnitude > 0 then
                local flatDirection = flatDelta.Unit
                local kLookFlat = Vector3.new(kHRP.CFrame.LookVector.X, 0, kHRP.CFrame.LookVector.Z).Unit
                local isFacing = kLookFlat:Dot(flatDirection)
                if isFacing < Config.Surv_ParryFace then return end
            end
            ExecuteParry()
        end
    end)
end

function TryAttach(p)
    if p ~= player and IsKiller(p) and p.Character then 
        AttachParrySensor(p.Character) 
    end
end

function SetupPlayer(p)
    if p == player then return end
    p.CharacterAdded:Connect(function() TryAttach(p) end)
    p:GetPropertyChangedSignal("Team"):Connect(function() TryAttach(p) end)
    if p.Character then TryAttach(p) end
end

-- ==================== PERFORMANCE FUNCTIONS ====================
function ApplyFullBright()
    if FullBright then
        Lighting.Brightness = 5
        Lighting.ClockTime = TimeOfDayValue
        Lighting.FogEnd = 100000
        Lighting.Ambient = Color3.fromRGB(255,255,255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
    end
end

function ApplyNoFog()
    if NoFog then
        Lighting.FogStart = 0
        Lighting.FogEnd = 100000
        Lighting.FogColor = Color3.fromRGB(255,255,255)
        local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
        if atmosphere then
            atmosphere.Density = 0
            atmosphere.Offset = 0
            atmosphere.Glare = 0
            atmosphere.Haze = 0
        end
    end
end

function ApplyNoShadow()
    Lighting.GlobalShadows = not NoShadow
end

function ReapplyPerformance()
    task.wait(1)
    ApplyFullBright()
    ApplyNoFog()
    ApplyNoShadow()
end

local function StartLeapBypass()
    Connections.LeapBypass = task.spawn(function()
        local leapFunction, m2Function
        for _, v in pairs(getgc(true)) do
            if type(v) == "function" and islclosure(v) then
                local info = debug.getinfo(v)
                if info.name == "tryActivate" then leapFunction = v end
                if info.name == "playM2Animation" then m2Function = v end
                if leapFunction and m2Function then break end
            end
        end
        if not leapFunction and not m2Function then
            warn("Function tidak ditemukan.") return
        end
        while task.wait(0.1) do
            if not Killer.BypassLeap then break end
            for _, fn in pairs({leapFunction, m2Function}) do
                if fn then
                    for i, val in pairs(debug.getupvalues(fn)) do
                        if type(val) == "boolean" and val == true then
                            debug.setupvalue(fn, i, false)
                        end
                    end
                end
            end
        end
    end)
end

-- ==================== EMOTE FUNCTIONS ====================
function PlayEmote()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    if currentTrack then currentTrack:Stop() end
    if currentSound then currentSound:Destroy() end
    if SelectedAnim then
        local anim = Instance.new("Animation")
        anim.AnimationId = SelectedAnim
        currentTrack = hum:LoadAnimation(anim)
        currentTrack.Looped = true
        currentTrack:Play()
    end
    if SelectedSound then
        currentSound = Instance.new("Sound")
        currentSound.SoundId = SelectedSound
        currentSound.Looped = true
        currentSound.Volume = 2
        currentSound.Parent = hrp
        currentSound:Play()
    end
end

function StopEmote()
    if currentTrack then currentTrack:Stop() end
    if currentSound then currentSound:Destroy() end
end

-- ==================== SPEED BOOST FUNCTIONS ====================
function startSpeedInputMode()
    print("✅ Speed Input aktif (via main RenderStepped)")
end

function stopSpeedInputMode()
    if SpeedInputConnection then
        SpeedInputConnection:Disconnect()
        SpeedInputConnection = nil
    end
end

-- ==================== MOONWALK ====================
local renderLoop = nil
MoonwalkButtonVisible = false

local function terminateMovement()
    if renderLoop then
        renderLoop:Disconnect()
        renderLoop = nil
    end

    local entity = LocalPlayer.Character
    local controller = entity and entity:FindFirstChildOfClass("Humanoid")
    if controller then
        controller.AutoRotate = true
    end
end

local function initializeMovement()
    terminateMovement()
    local entity = LocalPlayer.Character
    local rootPart = entity and entity:FindFirstChild("HumanoidRootPart")
    local controller = entity and entity:FindFirstChildOfClass("Humanoid")
    if not rootPart or not controller then return end

    controller.AutoRotate = false
    stateManager = true
    print("✅ Moonwalk aktif (via main RenderStepped)")
end

local function setMoonwalk(v)
    stateManager = v
    if v then 
        initializeMovement() 
    else 
        terminateMovement() 
    end
end

function UpdateMoonwalkStatus()
    if not MoonwalkButton then return end
    
    local label = MoonwalkButton:FindFirstChild("MoonwalkLabel")
    
    if MoonwalkEnabled then
        MoonwalkButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        MoonwalkButton.BackgroundTransparency = 0.1
        MoonwalkButton.ZIndex = 10
        
        if label then
            label.Text = "MOON"
            label.TextColor3 = Color3.fromRGB(0, 255, 100)
        end
    else
        MoonwalkButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        MoonwalkButton.BackgroundTransparency = 0.15
        MoonwalkButton.ZIndex = 10
        
        if label then
            label.Text = "MOON"
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end
end

function ToggleMoonwalk()
    MoonwalkEnabled = not MoonwalkEnabled
    setMoonwalk(MoonwalkEnabled)
    UpdateMoonwalkStatus()
    
    if MoonwalkEnabled then
        Library:Notify({ Title = "Moonwalk", Description = "ON", Time = 2 })
    else
        Library:Notify({ Title = "Moonwalk", Description = "OFF", Time = 2 })
    end
end

function SetMoonwalkButtonVisible(visible)
    MoonwalkButtonVisible = visible
    if MoonwalkButton then
        MoonwalkButton.Visible = visible
    end
    
    if not visible and MoonwalkEnabled then
        MoonwalkEnabled = false
        setMoonwalk(false)
        UpdateMoonwalkStatus()
    end
end

function UpdateMoonwalkVisibility()
    if MoonwalkButton then
        MoonwalkButton.Visible = MoonwalkEnabled
    end
end

-- ==================== BYPASS GATE ====================
function gatherGates()
    local gates = {}

    local map = workspace:FindFirstChild("Map")
    if not map then
        warn("Map not found")
        return gates
    end

    for _, obj in pairs(map:GetDescendants()) do
        if obj.Name == "Gate" then
            table.insert(gates, obj)
        end
    end

    return gates
end

function setBypassGate(state)
    BypassGateEnabled = state

    local gates = gatherGates()

    for _, gate in pairs(gates) do
        local leftGate = gate:FindFirstChild("LeftGate")
        local rightGate = gate:FindFirstChild("RightGate")

        local leftEnd =
            gate:FindFirstChild("LeftGate-end") or
            gate:FindFirstChild("LeftGate-end2")

        local rightEnd =
            gate:FindFirstChild("RightGate-end") or
            gate:FindFirstChild("RightGate-end2")

        local box = gate:FindFirstChild("Box")

        if state then
            if leftGate then
                leftGate.Transparency = 1
                leftGate.CanCollide = false
            end

            if rightGate then
                rightGate.Transparency = 1
                rightGate.CanCollide = false
            end

            if leftEnd then
                leftEnd.Transparency = 0
            end

            if rightEnd then
                rightEnd.Transparency = 0
            end

            if box then
                box.CanCollide = false
            end

        else
            if leftGate then
                leftGate.Transparency = 0
                leftGate.CanCollide = true
            end

            if rightGate then
                rightGate.Transparency = 0
                rightGate.CanCollide = true
            end

            if leftEnd then
                leftEnd.Transparency = 1
            end

            if rightEnd then
                rightEnd.Transparency = 1
            end

            if box then
                box.CanCollide = true
            end
        end
    end
end

-- ===== FLEE KILLER FUNCTIONS =====
function GetNearestKiller()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then
        return nil, math.huge
    end

    local nearestKiller = nil
    local nearestDistance = math.huge

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player
        and plr.Team
        and plr.Team.Name == "Killer"
        and plr.Character
        and plr.Character:FindFirstChild("HumanoidRootPart") then

            local dist = (plr.Character.HumanoidRootPart.Position - root.Position).Magnitude

            if dist < nearestDistance then
                nearestDistance = dist
                nearestKiller = plr
            end
        end
    end

    return nearestKiller, nearestDistance
end

function FleeKiller()
    if not FleeKillerEnabled then
        return
    end

    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then
        return
    end

    local killer, distance = GetNearestKiller()

    if not killer or distance > FleeDistance then
        return
    end

    if tick() - FleeCooldown < 3 then
        return
    end

    local killerRoot = killer.Character and killer.Character:FindFirstChild("HumanoidRootPart")
    if not killerRoot then
        return
    end

    local direction = (root.Position - killerRoot.Position).Unit
    local safePosition = root.Position + direction * 80

    root.CFrame = CFrame.new(safePosition)

    FleeCooldown = tick()
end

-- ==================== INFINITE LUNGE ====================
function EnableInfiniteLunge()
    InfiniteLungeEnabled = true
    local char = player.Character
    if char then
        char:SetAttribute("lungeboost", 999)
    end
    Library:Notify({ Title = "Infinite Lunge", Description = "✅ AKTIF (999x)", Time = 3 })
end

function DisableInfiniteLunge()
    InfiniteLungeEnabled = false
    local char = player.Character
    if char then
        char:SetAttribute("lungeboost", 1)
    end
    Library:Notify({ Title = "Infinite Lunge", Description = "Nonaktif", Time = 3 })
end

player.CharacterAdded:Connect(function(newChar)
    task.wait(0.8)
    if InfiniteLungeEnabled and newChar then
        newChar:SetAttribute("lungeboost", 999)
    end
end)

-- ==================== AUTO DROP PALLET ====================
AutoPalletEnabled = false
AutoPalletSafety = true
AutoPalletDistance = 10

local _lastPalletDrop = 0
local _usedPallets = {}
local _lastPalletScan = 0
local _autoPalletConn = nil

function GetKillerRoot()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if plr.Team and plr.Team.Name == "Survivors" then continue end
        
        local char = plr.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then return root end
        end
    end
    return nil
end

function IsSafeToDropPallet(char)
    if not AutoPalletSafety then return true end
    if not char then return false end
    
    if char:GetAttribute("Knocked") == true then return false end
    if char:GetAttribute("IsCarried") == true then return false end
    if char:GetAttribute("IsHooked") == true then return false end
    
    local interact = char:FindFirstChild("CheckInterractable")
    if interact then
        if interact:GetAttribute("isVaulting") == true then return false end
        if interact:GetAttribute("isRepairing") == true then return false end
        if interact:GetAttribute("isUnhooking") == true then return false end
        if interact:GetAttribute("isHealing") == true then return false end
        if interact:GetAttribute("isSliding") == true then return false end
        if interact:GetAttribute("isCarrying") == true then return false end
    end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health <= 0 then return false end
    
    return true
end

function FindNearestPallet(myRoot)
    local bestPallet = nil
    local bestDist = AutoPalletDistance
    
    for _, pallet in ipairs(Cache.Pallets or {}) do
        if not pallet or not pallet.Parent then continue end
        if _usedPallets[pallet] then continue end
        
        local refPart = pallet:FindFirstChild("PrimaryPartPallet") 
            or pallet:FindFirstChild("PalletPoint")
            or pallet:FindFirstChild("PalletPointSlide")
            or pallet:FindFirstChildWhichIsA("BasePart")
        
        if not refPart then continue end
        
        local ok, pos = pcall(function() return refPart.Position end)
        if not ok or not pos then continue end
        
        local dist = (myRoot.Position - pos).Magnitude
        if dist < bestDist then
            bestDist = dist
            bestPallet = pallet
        end
    end
    
    return bestPallet
end

function DropPallet(pallet)
    if not pallet then return false end
    
    local target = pallet:FindFirstChild("PalletPointSlide")
        or pallet:FindFirstChild("PalletPoint")
        or pallet:FindFirstChildWhichIsA("BasePart")
    
    if not target then return false end
    
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local dropEvent = remotes and remotes:FindFirstChild("Pallet") 
        and remotes.Pallet:FindFirstChild("PalletDropEvent")
    
    if dropEvent then
        pcall(function()
            dropEvent:FireServer(target)
        end)
        _usedPallets[pallet] = true
        _lastPalletDrop = tick()
        return true
    end
    return false
end

function StartAutoPallet()
    if _autoPalletConn then return end
    
    _autoPalletConn = task.spawn(function()
        while AutoPalletEnabled do
            task.wait(0.3)
            
            if GetRole() ~= "Survivor" then continue end
            if tick() - _lastPalletDrop < 2.5 then continue end
            
            pcall(function()
                local char = LocalPlayer.Character
                local myRoot = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                
                if not myRoot or not hum or hum.Health <= 0 then return end
                if not IsSafeToDropPallet(char) then return end
                
                local killerRoot = GetKillerRoot()
                if not killerRoot then return end
                
                local distToKiller = (myRoot.Position - killerRoot.Position).Magnitude
                if distToKiller > AutoPalletDistance then return end
                
                local pallet = FindNearestPallet(myRoot)
                if pallet then
                    DropPallet(pallet)
                end
            end)
        end
    end)
end

function StopAutoPallet()
    if _autoPalletConn then
        task.cancel(_autoPalletConn)
        _autoPalletConn = nil
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    _usedPallets = {}
    _lastPalletDrop = 0
end)

-- ==================== OPTIMIZED MAIN RENDERSTEPPED LOOP ====================
-- HANYA UNTUK YANG MEMBUTUHKAN RESPON PER-FRAME (AIMBOT, SKILL CHECK, CROSSHAIR, FOV)
-- ============================================================

local lastAimbotUpdate = 0
local lastSkillCheckUpdate = 0

RunService.RenderStepped:Connect(function()
    local char = player.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    
    local currentTime = tick()
    
    -- ===== CROSSHAIR (VISUAL, PER-FRAME) =====
    drawCrosshair()
    
    -- ===== AIMBOT SURVIVOR (PER-FRAME, TANPA DELAY) =====
    if Config.Surv_Aimbot_Enabled then
        local myRole = GetRole()
        if myRole == "Survivor" then
            local target = getBestAimbotTarget()
            if target then
                local targetPos = target.Position
                local dist = GetDistance(targetPos)
                
                if dist < 100 then 
                    local distanceDiff = 100 - dist
                    local rightOffset = distanceDiff * Config.Surv_Aimbot_Predict
                    targetPos = targetPos + (Camera.CFrame.RightVector * rightOffset) 
                end
                
                local goalCameraCFrame = CFrame.new(Camera.CFrame.Position, targetPos)
                Camera.CFrame = Camera.CFrame:Lerp(goalCameraCFrame, Config.Surv_Aimbot_Smoothness)
                
                local goalHrpCFrame = CFrame.new(hrp.Position, Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z))
                hrp.CFrame = hrp.CFrame:Lerp(goalHrpCFrame, Config.Surv_Aimbot_Smoothness)
            end
        end
    end
   
    
    -- ===== AIMBOT KILLER (PER-FRAME, TANPA DELAY) =====
    if Config.Killer_Aimbot_Enabled and isAimbotHolding then
        local myRole = GetRole()
        if myRole == "Killer" then
            if lockedAimbotTarget then
                local targetChar = lockedAimbotTarget.Parent
                local targetHum = targetChar and targetChar:FindFirstChild("Humanoid")
                
                if not targetHum or targetHum.Health <= 0 or IsDowned(targetChar) then
                    lockedAimbotTarget = getBestAimbotTarget()
                end

                if lockedAimbotTarget then
                    local targetPos = lockedAimbotTarget.Position
                    if GetDistance(targetPos) > Config.Killer_Aimbot_MaxDist then
                        lockedAimbotTarget = getBestAimbotTarget()
                    else
                        local goalCameraCFrame = CFrame.new(Camera.CFrame.Position, targetPos)
                        Camera.CFrame = Camera.CFrame:Lerp(goalCameraCFrame, Config.Killer_Aimbot_Smoothness)
                        
                        local goalHrpCFrame = CFrame.new(hrp.Position, Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z))
                        hrp.CFrame = hrp.CFrame:Lerp(goalHrpCFrame, Config.Killer_Aimbot_Smoothness)
                    end
                end
            else
                lockedAimbotTarget = nil
            end
        end
    end
    
    -- Silent Aim FOV Circles (Veil)
local isSpearMode = char and char:GetAttribute("spearmode") == true
    if IsVeilSilentOn() and AimConfig.Veil_ShowFOV and isSpearMode then
        VeilFOVFrame.Visible = true
        VeilFOVFrame.Size = UDim2.new(0, AimConfig.Veil_FOV * 2, 0, AimConfig.Veil_FOV * 2)
    else
        VeilFOVFrame.Visible = false
    end

-- ===== VEIL TARGET + TRACKER =====
do
    local cam = workspace.CurrentCamera
    local canShow = IsVeilSilentOn() and isSpearMode and cam

    if canShow then
        local targetPart = getClosestSurvivor()

        if targetPart and targetPart.Parent then
            veilTargetHighlight.Parent = targetPart.Parent

            if VeilTrackerEnabled then
                if not currentVeilBillboard or currentVeilBillboard.Parent ~= targetPart then
                    if currentVeilBillboard then currentVeilBillboard:Destroy() end
                    currentVeilBillboard = makeVeilBillboard()
                    currentVeilBillboard.Adornee = targetPart
                    currentVeilBillboard.Parent = targetPart
                end

                local sp, onScreen = cam:WorldToViewportPoint(targetPart.Position)
                if onScreen and sp.Z > 0 then
                    local vp = cam.ViewportSize
                    local fromX = vp.X * 0.5
                    local fromY = vp.Y
                    local toX, toY = sp.X, sp.Y
                    local dx, dy = toX - fromX, toY - fromY
                    local length = math.sqrt(dx * dx + dy * dy)

                    VeilTrackerLine.Size = UDim2.fromOffset(math.max(length, 1), 1)
                    VeilTrackerLine.Position = UDim2.fromOffset((fromX + toX) * 0.5, (fromY + toY) * 0.5)
                    VeilTrackerLine.Rotation = math.deg(math.atan2(dy, dx))
                    VeilTrackerLine.Visible = true
                else
                    VeilTrackerLine.Visible = false
                end
            else
                if currentVeilBillboard then
                    currentVeilBillboard:Destroy()
                    currentVeilBillboard = nil
                end
                VeilTrackerLine.Visible = false
            end
        else
            veilTargetHighlight.Parent = nil
            if currentVeilBillboard then
                currentVeilBillboard:Destroy()
                currentVeilBillboard = nil
            end
            VeilTrackerLine.Visible = false
        end
    else
        veilTargetHighlight.Parent = nil
        if currentVeilBillboard then
            currentVeilBillboard:Destroy()
            currentVeilBillboard = nil
        end
        VeilTrackerLine.Visible = false
    end
end
    
    -- ===== FLASH SILENT AIM (PER-FRAME) =====
    if isAimingFlash and AimConfig.Flash_Silent then
        local targetPart = getKillerTargetForFlash()
        if targetPart then
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local targetPos = targetPart.Position + Vector3.new(0, AimConfig.Flash_YOffset, 0)
            
            local cam = workspace.CurrentCamera
            cam.CFrame = cam.CFrame:Lerp(CFrame.lookAt(cam.CFrame.Position, targetPos), 0.5)
            
            if myHRP then
                local goalHrp = CFrame.lookAt(myHRP.Position, Vector3.new(targetPos.X, myHRP.Position.Y, targetPos.Z))
                myHRP.CFrame = myHRP.CFrame:Lerp(goalHrp, 0.5)
            end
        end
    end
    
        -- ===== MOONWALK (0.05s, cukup) =====
    if MoonwalkEnabled then
        local viewPort = workspace.CurrentCamera
        if viewPort then
            local facingVector = viewPort.CFrame.LookVector
            local sideVector = viewPort.CFrame.RightVector
            local normalizedLook = Vector3.new(facingVector.X, 0, facingVector.Z)
            local normalizedRight = Vector3.new(sideVector.X, 0, sideVector.Z)
            
            if normalizedLook.Magnitude > 0.001 then normalizedLook = normalizedLook.Unit end
            if normalizedRight.Magnitude > 0.001 then normalizedRight = normalizedRight.Unit end
            
            local wavePattern = math.sin(currentTime * 35)
            local computedAngle = math.rad(30 * wavePattern)
            local rotatedLook = CFrame.Angles(0, computedAngle, 0) * normalizedLook
            
            hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + rotatedLook)
            
            local backwardVector = -normalizedLook * 1.2
            local sidewaysVector = normalizedRight * (wavePattern * 1.05)
            hum:Move(backwardVector + sidewaysVector, false)
        end
    end
    
    
    -- ===== SKILL CHECK (PER-FRAME, TANPA DELAY) =====
    if Auto.SkillCheck and not State.busy then
        local prompt = PlayerGui:FindFirstChild("SkillCheckPromptGui")
        if prompt then
            local check = prompt:FindFirstChild("Check")
            if check and check.Visible then
                local line = check:FindFirstChild("Line")
                local goal = check:FindFirstChild("Goal")
                if line and goal then
                    if Auto.SkillCheckMode == "Instant" then
                        line.Rotation = goal.Rotation + 109
                        State.busy = true
                        task.spawn(function()
                            TriggerSkillCheck()
                            task.wait(0.05)
                            State.busy = false
                        end)
                    else
                        local lr = line.Rotation % 360
                        local gr = goal.Rotation % 360
                        local startRange = (gr + 102) % 360
                        local endRange = (gr + 116) % 360
                        if Auto.SkillCheckMode == "Normal" then
                            startRange = (gr + 116) % 360
                            endRange = (gr + 140) % 360
                        else
                            startRange = (gr + 102) % 360
                            endRange = (gr + 116) % 360
                        end
                        local inZone = false
                        if startRange > endRange then
                            inZone = (lr >= startRange or lr <= endRange)
                        else
                            inZone = (lr >= startRange and lr <= endRange)
                        end
                         
                        if inZone then
                            State.busy = true
                            task.spawn(function()
                                TriggerSkillCheck()
                                task.wait(0.05)
                                State.busy = false
                            end)
                        end
                    end
                end
            end
        end
    end
end)

-- ==================== HEARTBEAT LOOP (UNTUK YANG TIDAK PER-FRAME) ====================
local lastEspUpdate = 0
local lastNoSlowdown = 0
local lastFleeTime = 0
local lastMoonwalkUpdate = 0
local lastSpeedUpdate = 0

RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    
    local currentTime = tick()
    
    -- ===== SPEED INPUT (0.05s, cukup) =====
    if SpeedInputEnabled then
        local moveDir = hum.MoveDirection
        if moveDir.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (moveDir * SpeedInputValue)
        end
    end
    
    -- ===== SPEED BOOST (0.05s, cukup) =====
    if SpeedEnabled then
        local moveDir = hum.MoveDirection
        if moveDir.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (moveDir * SpeedAmount)
        end
    end
    
    -- ===== GOD MODE (0.05s, cukup) =====
    if GodMode and hum and hum.Health < hum.MaxHealth then
        hum.Health = hum.MaxHealth
    end
    
    -- ===== FOV (0.05s, cukup) =====
    if FOVEnabled and Camera then
        Camera.FieldOfView = TargetFOV
    end
    
    -- ===== FLEE KILLER (0.3 DETIK) =====
    if FleeKillerEnabled and currentTime - lastFleeTime >= 0.3 then
        lastFleeTime = currentTime
        FleeKiller()
    end
    
    -- ===== AUTO PARRY CIRCLE (0.05s, cukup) =====
    if Config.Surv_ParryCircle and Config.Surv_AutoParry and hrp then
        if not State.AutoParryAdornment or State.AutoParryAdornment.Parent ~= hrp then
            if State.AutoParryAdornment then State.AutoParryAdornment:Destroy() end
            State.AutoParryAdornment = Instance.new("CylinderHandleAdornment")
            State.AutoParryAdornment.Name = "AutoParryCircleESP"
            State.AutoParryAdornment.Height = 0.05
            State.AutoParryAdornment.Transparency = 0.3
            State.AutoParryAdornment.Adornee = hrp
            State.AutoParryAdornment.Parent = hrp
            State.AutoParryAdornment.ZIndex = 0
            State.AutoParryAdornment.AlwaysOnTop = false
        end
        local cR = Config.Surv_ParryRadius
        State.AutoParryAdornment.Radius = cR
        State.AutoParryAdornment.InnerRadius = math.max(0.1, cR - 0.15)
        State.AutoParryAdornment.CFrame = CFrame.new(0, -3, 0) * CFrame.Angles(math.rad(90), 0, 0)
        if State.ParryCooldown then
            State.AutoParryAdornment.Color3 = Color3.fromRGB(255, 128, 0)
        elseif Config.Surv_ParryAggressive then
            State.AutoParryAdornment.Color3 = Color3.fromRGB(255, 0, 0)
        else
            State.AutoParryAdornment.Color3 = Color3.fromRGB(0, 255, 255)
        end
    elseif State.AutoParryAdornment then
        State.AutoParryAdornment:Destroy()
        State.AutoParryAdornment = nil
    end
    
    -- ===== NO SLOWDOWN (0.3 DETIK) =====
    if NoSlowdownEnabled and currentTime - lastNoSlowdown >= 0.3 then
        lastNoSlowdown = currentTime
        if char then
            local hum2 = char:FindFirstChildOfClass("Humanoid")
            if hum2 and GetRole() == "Killer" and hum2.WalkSpeed < 16 then
                hum2.WalkSpeed = 16
            end
        end
    end
    
    -- ===== ESP UPDATE (5 DETIK) =====
    if Config.ESP_Master and currentTime - lastEspUpdate >= 5 then
        lastEspUpdate = currentTime
        
        if Config.ESP_Player or Config.ESP_Killer or Config.ESP_Name or Config.ESP_ItemIcon or Config.ESP_KillerWarn then
            UpdatePlayerESP()
        end
        if Config.ESP_SCP then
            UpdateSCPESP()
        end
        if Config.ESP_Generator or Config.ESP_Pallet or Config.ESP_Hook or Config.ESP_Gate or Config.ESP_Window then
            UpdateStaticESP()
        end
    end
end)

-- ==================== AUTO PARRY CUSTOM GUI ====================
local AutoParryCustom = {
    Gui = nil,
    IsActive = false,
    GuiVisible = false,
}

local function UpdateCustomParryGUI(isOn)
    if not AutoParryCustom.Gui then return end
    local frame = AutoParryCustom.Gui:FindFirstChild("Frame")
    if not frame then return end
    local btn = frame:FindFirstChild("ActionButton")
    local stroke = frame:FindFirstChild("UIStroke")
    if isOn then
        if btn then
            btn.Text = "PARRY [ON]"
            btn.TextColor3 = Color3.fromRGB(180, 255, 180)
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        end
        if stroke then stroke.Color = Color3.fromRGB(100, 200, 100) end
    else
        if btn then
            btn.Text = "PARRY [OFF]"
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        end
        if stroke then stroke.Color = Color3.fromRGB(90, 90, 95) end
    end
end

local function ToggleParryStatus()
    Config.Surv_AutoParry = not Config.Surv_AutoParry
    AutoParryCustom.IsActive = Config.Surv_AutoParry
    UpdateCustomParryGUI(Config.Surv_AutoParry)
    pcall(function()
        if Toggles and Toggles.AutoParryKey then Toggles.AutoParryKey:SetValue(Config.Surv_AutoParry) end
    end)
    pcall(function()
        if Toggles and Toggles.AutoParry then Toggles.AutoParry:SetValue(Config.Surv_AutoParry) end
    end)
    Library:Notify({ Title = "Auto Parry", Description = Config.Surv_AutoParry and "Aktif" or "Nonaktif", Time = 2 })
end

local function CreateCustomParryGUI()
    if AutoParryCustom.Gui then
        AutoParryCustom.Gui:Destroy()
        AutoParryCustom.Gui = nil
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "AutoParryCustomGui"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = CoreGui
    gui.Enabled = false
    AutoParryCustom.Gui = gui
    AutoParryCustom.GuiVisible = false

    local frame = Instance.new("Frame")
    frame.Name = "Frame"
    frame.Parent = gui
    frame.Size = UDim2.fromOffset(110, 36)
    frame.Position = UDim2.fromScale(0.85, 0.35)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    frame.BackgroundTransparency = 0.1
    frame.Active = true
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke")
    stroke.Name = "UIStroke"
    stroke.Parent = frame
    stroke.Color = Color3.fromRGB(90, 90, 95)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.2

    local button = Instance.new("TextButton")
    button.Name = "ActionButton"
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Text = "PARRY [OFF]"
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 12
    button.TextColor3 = Color3.fromRGB(200, 200, 200)
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Parent = frame
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

    local dragging, dragMoved, canDrag = false, false, false
    local dragStart, startPos, holdThread = nil, nil, nil
    local DRAG_THRESHOLD, HOLD_TIME = 18, 0.18

    local function update(input)
        if not dragging or not canDrag or not dragStart or not startPos then return end
        local delta = input.Position - dragStart
        if not dragMoved and (math.abs(delta.X) > DRAG_THRESHOLD or math.abs(delta.Y) > DRAG_THRESHOLD) then
            dragMoved = true
        end
        if dragMoved then
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end

    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragMoved = false
            canDrag = false
            dragStart = input.Position
            startPos = frame.Position
            if holdThread then task.cancel(holdThread) holdThread = nil end
            holdThread = task.delay(HOLD_TIME, function()
                if dragging then canDrag = true end
            end)
        end
    end)

    button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if holdThread then task.cancel(holdThread) holdThread = nil end
            if dragging and not dragMoved then
                ToggleParryStatus()
            end
            dragging = false
            dragMoved = false
            canDrag = false
            dragStart = nil
            startPos = nil
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and canDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)

    if AutoParryCustom._statusConn then AutoParryCustom._statusConn:Disconnect() end
    AutoParryCustom._statusConn = RunService.Heartbeat:Connect(function()
        if not AutoParryCustom.Gui or not AutoParryCustom.Gui.Parent then
            if AutoParryCustom._statusConn then
                AutoParryCustom._statusConn:Disconnect()
                AutoParryCustom._statusConn = nil
            end
            return
        end
        if AutoParryCustom.IsActive ~= Config.Surv_AutoParry then
            AutoParryCustom.IsActive = Config.Surv_AutoParry
            UpdateCustomParryGUI(Config.Surv_AutoParry)
        end
    end)
end

player.CharacterAdded:Connect(function()
    task.wait(1)
    if AutoParryCustom.GuiVisible and AutoParryCustom.Gui then
        AutoParryCustom.Gui.Enabled = true
        UpdateCustomParryGUI(Config.Surv_AutoParry)
    end
end)

task.spawn(function()
    task.wait(1.5)
    AutoParryCustom.IsActive = false
    AutoParryCustom.GuiVisible = false
    CreateCustomParryGUI()
end)

-- ==================== INVISIBILITY CUSTOM GUI ====================
local InvisCustom = {
    Gui = nil,
    IsActive = false,
    GuiVisible = false,
}

local Invisible = nil
local InvisibleLoading = false

local function LoadInvisible()
    if Invisible then return true end
    if InvisibleLoading then return false end
    InvisibleLoading = true
    task.spawn(function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/GrexXMeng/Mengs/main/Invisibility"))()
        end)
        task.wait(1.2)
        if _G.MengHub and _G.MengHub.Invisible then
            Invisible = _G.MengHub.Invisible
            print("Invisibility loaded")
            pcall(function()
                if Library then Library:Notify({ Title = "Invisibility", Description = "Ready!", Time = 2 }) end
            end)
        else
            warn("Gagal load Invisibility:", tostring(err))
            pcall(function()
                if Library then Library:Notify({ Title = "Invisibility", Description = "Gagal load script!", Time = 3 }) end
            end)
        end
        InvisibleLoading = false
    end)
    return false
end

task.spawn(function()
    task.wait(2)
    LoadInvisible()
end)

local function UpdateCustomInvisGUI(isOn)
    if not InvisCustom.Gui then return end
    local frame = InvisCustom.Gui:FindFirstChild("Frame")
    if not frame then return end
    local btn = frame:FindFirstChild("ActionButton")
    local stroke = frame:FindFirstChild("UIStroke")
    if isOn then
        if btn then
            btn.Text = "INVIS [ON]"
            btn.TextColor3 = Color3.fromRGB(180, 255, 180)
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        end
        if stroke then stroke.Color = Color3.fromRGB(100, 200, 100) end
    else
        if btn then
            btn.Text = "INVIS [OFF]"
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        end
        if stroke then stroke.Color = Color3.fromRGB(90, 90, 95) end
    end
end

local function ToggleInvisStatus()
    if not Invisible then
        if InvisibleLoading then
            Library:Notify({ Title = "Invisibility", Description = "Masih loading...", Time = 2 })
            return
        end
        Library:Notify({ Title = "Invisibility", Description = "Loading...", Time = 2 })
        LoadInvisible()
        task.wait(1.5)
        if not Invisible then
            Library:Notify({ Title = "Invisibility", Description = "Gagal load. Coba lagi.", Time = 3 })
            return
        end
    end
    InvisCustom.IsActive = not InvisCustom.IsActive
    if InvisCustom.IsActive then
        pcall(function() Invisible.enable() end)
    else
        pcall(function() Invisible.disable() end)
    end
    UpdateCustomInvisGUI(InvisCustom.IsActive)
    pcall(function()
        if Toggles and Toggles.Invis_Gacor then Toggles.Invis_Gacor:SetValue(InvisCustom.IsActive) end
    end)
    Library:Notify({ Title = "Invisibility", Description = InvisCustom.IsActive and "Aktif" or "Nonaktif", Time = 2 })
end

local function CreateCustomInvisGUI()
    if InvisCustom.Gui then
        InvisCustom.Gui:Destroy()
        InvisCustom.Gui = nil
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "InvisCustomGui"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = CoreGui
    gui.Enabled = false
    InvisCustom.Gui = gui
    InvisCustom.GuiVisible = false

    local frame = Instance.new("Frame")
    frame.Name = "Frame"
    frame.Parent = gui
    frame.Size = UDim2.fromOffset(110, 36)
    frame.Position = UDim2.fromScale(0.85, 0.42)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    frame.BackgroundTransparency = 0.1
    frame.Active = true
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke")
    stroke.Name = "UIStroke"
    stroke.Parent = frame
    stroke.Color = Color3.fromRGB(90, 90, 95)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.2

    local button = Instance.new("TextButton")
    button.Name = "ActionButton"
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Text = "INVIS [OFF]"
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 12
    button.TextColor3 = Color3.fromRGB(200, 200, 200)
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Parent = frame
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

    local dragging, dragMoved, canDrag = false, false, false
    local dragStart, startPos, holdThread = nil, nil, nil
    local DRAG_THRESHOLD, HOLD_TIME = 18, 0.18

    local function update(input)
        if not dragging or not canDrag or not dragStart or not startPos then return end
        local delta = input.Position - dragStart
        if not dragMoved and (math.abs(delta.X) > DRAG_THRESHOLD or math.abs(delta.Y) > DRAG_THRESHOLD) then
            dragMoved = true
        end
        if dragMoved then
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end

    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragMoved = false
            canDrag = false
            dragStart = input.Position
            startPos = frame.Position
            if holdThread then task.cancel(holdThread) holdThread = nil end
            holdThread = task.delay(HOLD_TIME, function()
                if dragging then canDrag = true end
            end)
        end
    end)

    button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if holdThread then task.cancel(holdThread) holdThread = nil end
            if dragging and not dragMoved then
                ToggleInvisStatus()
            end
            dragging = false
            dragMoved = false
            canDrag = false
            dragStart = nil
            startPos = nil
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and canDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

task.spawn(function()
    task.wait(1.5)
    CreateCustomInvisGUI()
end)

-- ==================== OBSIDIAN UI SETUP ====================
local repo = "https://raw.githubusercontent.com/kezodxyz/KezodX/refs/heads/main/"
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/arga0419-bot/kiw/refs/heads/main/library_both_logo.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

-- Purple color scheme
Library.Scheme.AccentColor     = Color3.fromRGB(255, 105, 180)
Library.Scheme.BackgroundColor = Color3.fromRGB(15, 15, 20)
Library.Scheme.MainColor       = Color3.fromRGB(25, 25, 25)
Library.Scheme.OutlineColor    = Color3.fromRGB(255, 255, 255)
Library.Scheme.FontColor       = Color3.fromRGB(220, 210, 255)

local Window = Library:CreateWindow({
    Title = "Pandu Hub",
    Footer = 'YOUTUBE | https://youtube.com/@leenztzy',
    Icon = "94380161420025",
    IconSize = UDim2.fromOffset(50, 50),
    NotifySide = "Right",
    EnableSidebarResize = true,
    EnableCompacting = true,
    SidebarCompacted = true,
    Size = UDim2.fromOffset(450, 1000),
    CornerRadius = 20,
    AutoShow = true,
})

local TabsUI = {
    Main = Window:AddTab("Pandu", "house"),
    Survivor = Window:AddTab("Survivor", "users"),
    Killer = Window:AddTab("Killer", "swords"),
    Esp = Window:AddTab("ESP", "eye"),
    Teleport = Window:AddTab("Teleport", "map-pin"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

--== Function
MinPlayers, MaxPlayers = 1, 6
autoReconnect = true

function ServerHop()
    local placeId = game.PlaceId
    local servers, cursor = {}, ""
    repeat
        local url = "https://games.roblox.com/v1/games/" ..
            placeId .. "/servers/Public?sortOrder=Asc&limit=100" .. (cursor ~= "" and "&cursor=" .. cursor or "")
        local success, result = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
        if success and result and result.data then
            for _, server in ipairs(result.data) do
                if server.id ~= game.JobId and server.playing >= MinPlayers and server.playing <= MaxPlayers and server.playing < server.maxPlayers then
                    table.insert(servers, server)
                end
            end
            cursor = result.nextPageCursor
        else
            break
        end
    until not cursor or #servers > 0

    if #servers > 0 then
        local target = servers[math.random(#servers)]
        Library:Notify({
            Title = "Server Found",
            Description = string.format("Players: %d/%d", target.playing,
                target.maxPlayers),
            Time = 3
        })
        task.wait(0.3)
        TeleportService:TeleportToPlaceInstance(placeId, target.id, LocalPlayer)
    else
        Library:Notify({ Title = "No Server", Description = "Try Again", Time = 3 })
    end
end

LocalPlayer.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.Failed and autoReconnect then
        task.wait(3)
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
end)

--== UI

local ServerGroup = TabsUI.Main:AddLeftGroupbox("Server Tools", "server")

do
    local skipEndscreen = false
    ServerGroup:AddToggle("EndScreen", {
    Text = "Skip Endscreen",
        Default = false,
        Callback = function(v)
            skipEndscreen = v
        end
    })

    task.spawn(function()
        while true do
            if skipEndscreen then
                pcall(function()
                    local map = workspace:FindFirstChild("Map")
                    if map then
                        local endscreenFolder = map:FindFirstChild("endscreen", true)
                        if endscreenFolder then
                            for _, obj in ipairs(endscreenFolder:GetDescendants()) do
                                if obj:IsA("LocalScript") then
                                    obj.Disabled = true
                                end
                            end
                            endscreenFolder:Destroy()
                        end
                    end

                    local resultGui = PlayerGui.Results
                    local frameResult = resultGui.Frame
                    local continueBtn = frameResult.Close

                    if resultGui then
                        if frameResult.Visible and continueBtn.Visible then
                            pcall(function() firesignal(continueBtn.MouseButton1Click) end)
                        end
                    end
                end)
            end
            task.wait(1)
        end
    end)
end

ServerGroup:AddInput("MinPlayersInput", {
    Default = "1",
    Text = "Min Players",
    Numeric = true,
    Callback = function(v)
        MinPlayers = math.clamp(math.floor(tonumber(v) or 1), 0, 50)
    end
})

ServerGroup:AddInput("MaxPlayersInput", {
    Default = "6",
    Text = "Max Players",
    Numeric = true,
    Callback = function(v)
        MaxPlayers = math.clamp(math.floor(tonumber(v) or 5), MinPlayers, 50)
    end
})

ServerGroup:AddButton({
    Text = "Hop Server",
    Func = function() ServerHop() end
})

ServerGroup:AddButton({
    Text = "Rejoin Server",
    Func = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})

-- ==================== TAB MAIN ====================
local AgilityGroup = TabsUI.Main:AddLeftGroupbox("Movement", "shoe")
AgilityGroup:AddToggle("AutoVault", {
    Text = "Auto Vault",
    Default = false,
    Callback = function(v)
        autoVaultEnabled = v
    end
})

-- ==================== AUTO VAULT + AUTO PALLET SLIDE (PROMPT) ====================
task.spawn(function()
    while true do
        task.wait(0.1)
        if UserInputService.TouchEnabled then continue end
        if tick() - lastActionTime < COOLDOWN then continue end

        local wantVault = autoVaultEnabled
        local wantSlide = autoPalletSlideEnabled
        if not wantVault and not wantSlide then continue end

        local pcPrompts = PlayerGui:FindFirstChild("pcprompts")
        local frame = pcPrompts and pcPrompts:FindFirstChild("Frame")
        if not frame then continue end

        local vaultGui = frame:FindFirstChild("VaultPromptGui")
        local slideGui = frame:FindFirstChild("PalletSlidePromptGui")

        local vaultVisible = vaultGui and vaultGui.Visible
        local slideVisible = slideGui and slideGui.Visible

        if (wantVault and vaultVisible) or (wantSlide and slideVisible) then
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            task.wait(0.01)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
            lastActionTime = tick()
        end
    end
end)

local function setupMobileVault()
    if not UserInputService.TouchEnabled then return end

    local mobileGui = PlayerGui:FindFirstChild("Survivor-mob") or PlayerGui:WaitForChild("Survivor-mob", 8)
    if not mobileGui then return end

    local controls = mobileGui:FindFirstChild("Controls") or mobileGui:WaitForChild("Controls", 5)
    local action = controls and (controls:FindFirstChild("action") or controls:WaitForChild("action", 5))
    if not action then return end

    local allowedNames = {
        vault = true,
        palletvault = true,
        palletslide = true,
        slide = true,
    }

    local function connectLabel(child)
        if not (child:IsA("ImageLabel") or child:IsA("ImageButton")) then return end
        local name = child.Name:lower()
        if not allowedNames[name] then return end

        child:GetPropertyChangedSignal("Visible"):Connect(function()
            if not child.Visible then return end
            if tick() - lastActionTime < COOLDOWN then return end

            local isVault = name:find("vault") and not name:find("pallet")
            local isSlide = name:find("pallet") or name:find("slide")

            if (isVault and autoVaultEnabled) or (isSlide and autoPalletSlideEnabled) then
                pcall(function()
                    firesignal(action.MouseButton1Down)
                    task.wait(0.01)
                    firesignal(action.MouseButton1Up)
                end)
                lastActionTime = tick()
            end
        end)
    end

    for _, child in pairs(action:GetChildren()) do
        connectLabel(child)
    end
    action.ChildAdded:Connect(function(child)
        task.wait()
        connectLabel(child)
    end)
end

task.spawn(setupMobileVault)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(2)
    setupMobileVault()
end)

PlayerGui.ChildAdded:Connect(function(child)
    if child.Name == "Survivor-mob" then
        task.wait(1)
        setupMobileVault()
    end
end)

AgilityGroup:AddToggle("AutoPalletSlide", {
    Text = "Auto Pallet Slide",
    Default = false,
    Callback = function(v)
        autoPalletSlideEnabled = v
    end
})

getgenv().AutoRunEnabled = false
AgilityGroup:AddToggle("AutoRunPC", {
    Text = "Auto Run [PC]",
    Default = false,
    Callback = function(Value)
        getgenv().AutoRunEnabled = Value
        if Value then
            task.spawn(function()
                while getgenv().AutoRunEnabled do
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, LocalPlayer:GetMouse())
                    task.wait(0.1)
                end
            end)
        else
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, LocalPlayer:GetMouse())
        end
    end
})

AgilityGroup:AddToggle("AutoRunMobile", {
    Text = "Auto Run [Mobile]",
    Default = false,
    Callback = function(Value)
        getgenv().AutoRunMobileEnabled = Value
        if Value then
            StartAutoRunMobile()
            Library:Notify({ Title = "Auto Run Mobile", Description = "ON", Time = 2 })
        else
            StopAutoRunMobile()
            Library:Notify({ Title = "Auto Run Mobile", Description = "OFF", Time = 2 })
        end
    end
})

AgilityGroup:AddToggle("SpeedBoost", {
    Text = "Enable Speed Boost",
    Default = false,
    Callback = function(Value)
        SpeedEnabled = Value
    end,
})

AgilityGroup:AddSlider("SpeedAmount", {
    Text = "Speed Boost Value",
    Default = 0.02,
    Min = 0.01,
    Max = 3,
    Rounding = 2,
    Callback = function(Value)
        SpeedAmount = Value
    end,
})
AgilityGroup:AddToggle("Surv_Perks", {
    Text = "Fast vault",
    Default = false,
    Callback = function(Value)
        Config.Surv_Perks = Value
        if not Value and LocalPlayer.Character and GetRole() ~= "Killer" then
            LocalPlayer.Character:SetAttribute("vaultspeed", 1)
        end
    end
}):AddKeyPicker("Surv_PerksKey", {
    Default = "None",
    SyncToggleState = true,
    Mode = "Toggle",
    Text = "Toggle Vault Speed",
    NoUI = false
})
AgilityGroup:AddSlider("Surv_VaultSlider", { Text = "Vault Speed", Min = 10, Max = 20, Default = 13, Rounding = 1, Callback = function(Value) Config.Surv_VaultSpeed = Value / 10 end })

AgilityGroup:AddInput("SpeedInputValue", {
    Text = "Speed Value (Input Mode)",
    Tooltip = "Masukkan angka kecepatan (contoh: 1.5, 2, 3)",
    Default = "0.1",
    Placeholder = "0.1",
    Numeric = true,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            SpeedInputValue = num
            Library:Notify({ Title = "Speed", Description = "Kecepatan diubah ke " .. num, Time = 2 })
        end
    end,
})

AgilityGroup:AddToggle("SpeedInputMode", {
    Text = "Enable Speed Boost (Input Mode)",
    Tooltip = "Aktifkan speed boost dengan kecepatan di atas",
    Default = false,
    Callback = function(Value)
        SpeedInputEnabled = Value
        if Value then
            startSpeedInputMode()
            Library:Notify({ Title = "Speed Input", Description = "Speed Boost aktif! (" .. SpeedInputValue .. ")", Time = 3 })
        else
            stopSpeedInputMode()
            Library:Notify({ Title = "Speed Input", Description = "Speed Boost dimatikan", Time = 2 })
        end
    end,
})

-- Player Emote
local EmoteGroup = TabsUI.Main:AddLeftGroupbox("Player Emote", "smile")

EmoteGroup:AddToggle("EmoteEnabled", {
    Text = "Aktifkan Emote",
    Default = false,
    Callback = function(Value)
        EmoteEnabled = Value
        if Value then 
            PlayEmote() 
        else 
            StopEmote() 
        end
    end,
})

EmoteGroup:AddDropdown("EmoteSelect", {
    Values = {
        "Friday Night",
        "WarCry",
        "24 Hour Cinderella",
        "Applause",
        "Arm Swing",
        "Backflip",
        "California Girls",
        "Christmas Spirit",
        "Floating Rest",
        "Ghoul",
        "Griddy",
        "Kyoufuu",
        "OnePlays",
        "Vulnerable"
    },

    Default = "Friday Night",
    Text = "Pilih Emote",

    Callback = function(Value)

        if Value == "Friday Night" then
            SelectedAnim = "rbxassetid://83229063951016"
            SelectedSound = "rbxassetid://85355610204255"
            
         elseif Value == "WarCry" then
            SelectedAnim = "rbxassetid://82600868380136"
            SelectedSound = "rbxassetid://120101930689931"

        elseif Value == "24 Hour Cinderella" then 
            SelectedAnim = "rbxassetid://137195203725366" 
            SelectedSound = "rbxassetid://121099446613414"

        elseif Value == "Applause" then 
            SelectedAnim = "rbxassetid://96328361165090" 
            SelectedSound = "rbxassetid://115490787020749"

        elseif Value == "Arm Swing" then 
            SelectedAnim = "rbxassetid://80552139463944" 
            SelectedSound = "rbxassetid://74216458932348"

        elseif Value == "Backflip" then 
            SelectedAnim = "rbxassetid://74705617908505" 
            SelectedSound = nil

        elseif Value == "California Girls" then 
            SelectedAnim = "rbxassetid://123552803041504" 
            SelectedSound = "rbxassetid://87899327891544"

        elseif Value == "Christmas Spirit" then 
            SelectedAnim = "rbxassetid://137859761110514" 
            SelectedSound = nil

        elseif Value == "Floating Rest" then 
            SelectedAnim = "rbxassetid://114593021219597" 
            SelectedSound = nil

        elseif Value == "Ghoul" then 
            SelectedAnim = "rbxassetid://130415594909401" 
            SelectedSound = "rbxassetid://123004139176580"

        elseif Value == "Griddy" then 
            SelectedAnim = "rbxassetid://75586690784894" 
            SelectedSound = nil

        elseif Value == "Kyoufuu" then 
            SelectedAnim = "rbxassetid://137322894494527" 
            SelectedSound = "rbxassetid://129064643026442"

        elseif Value == "OnePlays" then
            SelectedAnim = "rbxassetid://140625405103474"
            SelectedSound = "rbxassetid://94749073728335"

        elseif Value == "Vulnerable" then
            SelectedAnim = "rbxassetid://121773684313913"
            SelectedSound = "rbxassetid://135265751184744"
        end

        if EmoteEnabled then
            PlayEmote()
        end
    end,
})

-- ==================== FAKE PERKS UI ====================
local FakePerksGroup = TabsUI.Main:AddRightGroupbox("Fake Perks", "sparkles")

FakePerksGroup:AddToggle("FakeQuickRecovery", {
    Text = "Fake Quick Recovery",
    Tooltip = "Speed boost 1.4x selama 3 detik setelah vault cepat",
    Default = false,
    Callback = function(Value)
        FakePerks.ToggleQuickRecovery(Value)
    end
}):AddKeyPicker("FakeQuickRecoveryKey", {
    Default = "None",
    Text = "Keybind Quick Recovery",
    Mode = "Toggle",
    Callback = function(Value)
        FakePerks.ToggleQuickRecovery(Value)
        if Toggles.FakeQuickRecovery then
            Toggles.FakeQuickRecovery:SetValue(Value)
        end
    end
})

FakePerksGroup:AddToggle("FakePerfectLanding", {
    Text = "Fake Perfect Landing",
    Tooltip = "Speed boost 1.4x selama 3 detik setelah landing",
    Default = false,
    Callback = function(Value)
        FakePerks.TogglePerfectLanding(Value)
    end
}):AddKeyPicker("FakePerfectLandingKey", {
    Default = "None",
    Text = "Keybind Perfect Landing",
    Mode = "Toggle",
    Callback = function(Value)
        FakePerks.TogglePerfectLanding(Value)
        if Toggles.FakePerfectLanding then
            Toggles.FakePerfectLanding:SetValue(Value)
        end
    end
})

FakePerksGroup:AddToggle("FakeFlowstate", {
    Text = "Fake Flowstate",
    Tooltip = "Flowstate unlimited dengan cooldown realistis",
    Default = false,
    Callback = function(Value)
        FakePerks.ToggleFlowstate(Value)
    end
}):AddKeyPicker("FakeFlowstateKey", {
    Default = "None",
    Text = "Keybind Flowstate",
    Mode = "Toggle",
    Callback = function(Value)
        FakePerks.ToggleFlowstate(Value)
        if Toggles.FakeFlowstate then
            Toggles.FakeFlowstate:SetValue(Value)
        end
    end
})

FakePerksGroup:AddSlider("FakePerksDelay", {
    Text = "Perks Cooldown (detik)",
    Tooltip = "Cooldown antar trigger perk",
    Default = 10,
    Min = 0,
    Max = 180,
    Rounding = 1,
    Callback = function(Value)
        FakePerks.PerkCooldown = Value
        
        if FakePerks.FlowstateEnabled and LocalPlayer.Character then
            local char = LocalPlayer.Character
            char:SetAttribute("Flowstate", true)
            FakePerks.fsOnCooldown = false
            FakePerks.lastFSTime = tick()
        end
    end
})

local  SpoofGroup = TabsUI.Main:AddRightGroupbox("Sreamer Mode", "eye")
    SpoofGroup:AddToggle("Misc_FakeName", {
    Text = "Hide Name",
    Default = false,
    Callback = function(Value)
        Config.Misc_FakeName = Value
        if Value then enableSpoofer() else disableSpoofer() end
    end,
}):AddKeyPicker("FakeNameKey", {
    Default = "None",
    Text = "Hide Name Key",
    Mode = "Toggle",
    Callback = function(Value)
        Config.Misc_FakeName = Value
        if Value then enableSpoofer() else disableSpoofer() end
    end,
})

    local  BinGroup = TabsUI.Main:AddRightGroupbox("Keybind Open/Close UI", "keyboard")
    BinGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
    BinGroup:AddToggle("LockMenu", { Default = true, Text = "Lock Gui", Callback = function(value) Library.CantDragForced = value end})
    Library.ToggleKeybind = Options.MenuKeybind 
    Library.ShowToggleFrameInKeybinds = true 
    BinGroup:AddButton("Unload script", function() Library:Unload() end)
  
  local  UnivGroup = TabsUI.Main:AddRightGroupbox("Utility", "sliders-horizontal")  
  UnivGroup:AddToggle("Invis_Gacor", {
    Text = "Invisibility [OP]",
    Default = false,
    Callback = function(Value)
        if not Invisible then
            LoadInvisible()
            task.wait(1.5)
            if not Invisible then
                Library:Notify({ Title = "Invisibility", Description = "Not Ready Yet!", Time = 2 })
                return
            end
        end

        if Value then
            pcall(function() Invisible.enable() end)
            InvisCustom.IsActive = true
            UpdateCustomInvisGUI(true)
            Library:Notify({ Title = "Invisibility", Description = "Aktif!", Time = 2 })
        else
            pcall(function() Invisible.disable() end)
            InvisCustom.IsActive = false
            UpdateCustomInvisGUI(false)
            Library:Notify({ Title = "Invisibility", Description = "Nonaktif!", Time = 2 })
        end
    end
}):AddKeyPicker("Invis_GacorKey", {
    Default = "None",
    Text = "Invisibility Key",
    Mode = "Toggle",
    SyncToggleState = true,
    Callback = function(Value)
        if not Invisible then
            LoadInvisible()
            task.wait(1.5)
            if not Invisible then
                Library:Notify({ Title = "Invisibility", Description = "Not Ready Yet!", Time = 2 })
                return
            end
        end

        if Value then
            pcall(function() Invisible.enable() end)
            InvisCustom.IsActive = true
            UpdateCustomInvisGUI(true)
            if Toggles and Toggles.Invis_Gacor then
                Toggles.Invis_Gacor:SetValue(true)
            end
            Library:Notify({ Title = "Invisibility", Description = "Aktif!", Time = 2 })
        else
            pcall(function() Invisible.disable() end)
            InvisCustom.IsActive = false
            UpdateCustomInvisGUI(false)
            if Toggles and Toggles.Invis_Gacor then
                Toggles.Invis_Gacor:SetValue(false)
            end
            Library:Notify({ Title = "Invisibility", Description = "Nonaktif!", Time = 2 })
        end
    end
})

UnivGroup:AddToggle("CustomInvisToggle", {
    Text = "Invisibility GUI",
    Default = false,
    Callback = function(Value)
        if Value then
            if not InvisCustom.Gui then
                CreateCustomInvisGUI()
            end
            InvisCustom.Gui.Enabled = true
            InvisCustom.GuiVisible = true
            UpdateCustomInvisGUI(InvisCustom.IsActive)
            Library:Notify({ Title = "Invis GUI", Description = "Gui Loaded", Time = 2 })
        else
            if InvisCustom.IsActive and Invisible then
                InvisCustom.IsActive = false
                pcall(function() Invisible.disable() end)
                pcall(function()
                    if Toggles and Toggles.Invis_Gacor then
                        Toggles.Invis_Gacor:SetValue(false)
                    end
                end)
            end
            if InvisCustom.Gui then
                InvisCustom.Gui.Enabled = false
                InvisCustom.GuiVisible = false
            end
            Library:Notify({ Title = "Invis GUI", Description = "Gui Destroyed", Time = 2 })
        end
    end
})


UnivGroup:AddToggle("MoonwalkToggle", {
    Text = "Show Moonwalk Button",
    Tooltip = "Tampilkan button Moonwalk di layar (pencet button untuk aktif)",
    Default = false,
    Callback = function(Value)
        SetMoonwalkButtonVisible(Value)
        
        if Value then
            Library:Notify({ Title = "Moonwalk", Description = "Button muncul! Tekan untuk aktif", Time = 3 })
        else
            Library:Notify({ Title = "Moonwalk", Description = "Button disembunyikan", Time = 2 })
        end
    end
})

UnivGroup:AddToggle("MoonwalkPCToggle", {
    Text = "Moonwalk [PC]",
    Default = false,
    Callback = function(Value)
        MoonwalkEnabled = Value
        if Value then
            Library:Notify({ Title = "Moonwalk PC", Description = "AKTIF", Time = 2 })
        else
            Library:Notify({ Title = "Moonwalk PC", Description = "NONAKTIF", Time = 2 })
        end
    end
}):AddKeyPicker("MoonwalkPCKey", {
    Default = "None",
    Text = "Keybind Moonwalk",
    Mode = "Toggle",
    Callback = function(Value)
        MoonwalkEnabled = Value
        if Toggles.MoonwalkPCToggle then
            Toggles.MoonwalkPCToggle:SetValue(Value)
        end
        if Value then
            Library:Notify({ Title = "Moonwalk PC", Description = "AKTIF", Time = 2 })
        else
            Library:Notify({ Title = "Moonwalk PC", Description = "NONAKTIF", Time = 2 })
        end
    end
})

UnivGroup:AddButton({
    Text = "Copy Avatar",
    Func = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://pastefy.app/GLUw5pDk/raw"))()
        end)
        if success then
            Library:Notify({ Title = "Copy ava", Description = "Copy ava berhasil dimuat!", Time = 3 })
        else
            Library:Notify({ Title = "Error", Description = "Gagal memuat Copy ava!", Time = 3 })
        end
    end
})

UnivGroup:AddButton({
    Text = "Moonwalk v old",
    Func = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://pastebin.com/raw/JWr0bW8u"))()
        end)
        if success then
            Library:Notify({ Title = "Moonwalk", Description = "GUI Moonwalk berhasil dimuat!", Time = 3 })
        else
            Library:Notify({ Title = "Error", Description = "Gagal memuat Moonwalk!", Time = 3 })
        end
    end
})

UnivGroup:AddButton({
    Text = "Fake Generator GUI",
    Func = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://pastefy.app/cjJ9sNKl/raw"))()
        end)
        if success then
            Library:Notify({ Title = "Fake Generator", Description = "GUI Fake Generator berhasil dimuat!", Time = 3 })
        else
            Library:Notify({ Title = "Error", Description = "Gagal memuat Fake Generator!", Time = 3 })
        end
    end
})

UnivGroup:AddButton({
    Text = "Fly GUI",
    Func = function()
        local found = false
        for _, v in pairs(game.CoreGui:GetChildren()) do
            if v.Name:lower():find("fly") then found = true end
        end        if not found then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
            Library:Notify({ Title = "Fly", Description = "Fly GUI Dimuat", Time = 3 })
        else
            Library:Notify({ Title = "Fly", Description = "Fly GUI terbuka", Time = 3 })
        end
    end
})
  
  local SusR6Group = TabsUI.Main:AddRightGroupbox("Troll Player", "skull")
  
  SusR6Group:AddButton({
    Text = "Tools Jerk",
    Func = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))()
        end)
        if success then
            Library:Notify({ Title = "Tools Jerk", Description = "Tools Jerk berhasil dimuat!", Time = 3 })
        else
            Library:Notify({ Title = "Error", Description = "Gagal memuat Tools Jerk", Time = 3 })
        end
    end
})

 
local SharedTarget = nil
local sharedPlayerList = {}

local function UpdateSharedPlayerList()
    sharedPlayerList = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(sharedPlayerList, plr.Name)
        end
    end
    table.sort(sharedPlayerList)
end
UpdateSharedPlayerList()

SusR6Group:AddDropdown("SharedTargetDropdown", {
    Text = "Pilih Target (Shared)",
    Values = sharedPlayerList,
    Default = "None",
    Multi = false,
    Callback = function(Value)
        if Value and Value ~= "None" then
            SharedTarget = Players:FindFirstChild(Value)
        else
            SharedTarget = nil
        end
    end
})

SusR6Group:AddButton({
    Text = "Refresh Target List",
    Func = function()
        UpdateSharedPlayerList()
        Options.SharedTargetDropdown:SetValues(sharedPlayerList)
        Library:Notify({Title = "Target", Description = "Daftar player di-refresh!", Time = 2})
    end
})

-- ==================== SUS R6 ====================
SusR6Enabled = false
susAnimTrack = nil
susCoroutine = nil

SusR6Group:AddToggle("SusR6Toggle", {
    Text = "Di Ew Player",
    Default = false,
    Callback = function(Value)
        SusR6Enabled = Value
        if Value then
            if not SharedTarget then
                Library:Notify({Title = "Sus R6", Description = "Pilih target dulu!", Time = 3})
                Toggles.SusR6Toggle:SetValue(false)
                return
            end

            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local anim = Instance.new("Animation")
                anim.AnimationId = "rbxassetid://189854234"
                susAnimTrack = humanoid:LoadAnimation(anim)
                susAnimTrack:Play()
            end

            susCoroutine = coroutine.wrap(function()
                while SusR6Enabled and SharedTarget and SharedTarget.Character do
                    local targetHRP = SharedTarget.Character:FindFirstChild("HumanoidRootPart")
                    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if targetHRP and myHRP then
                        local forward = targetHRP.CFrame * CFrame.new(0, 0, -2.5)
                        local backward = targetHRP.CFrame * CFrame.new(0, 0, -1.3)
                        TweenService:Create(myHRP, TweenInfo.new(0.15), {CFrame = forward}):Play()
                        task.wait(0.15)
                        TweenService:Create(myHRP, TweenInfo.new(0.15), {CFrame = backward}):Play()
                        task.wait(0.15)
                    else
                        break
                    end
                end
            end)()
        else
            if susAnimTrack then susAnimTrack:Stop() end
            susAnimTrack = nil
            susCoroutine = nil
        end
    end
})

-- ==================== GET SUCKED ====================
GetSuckedEnabled = false
suckedAttachmentLoop = nil
suckedAnimTrack = nil
local originalGravity = workspace.Gravity

SusR6Group:AddToggle("GetSuckedToggle", {
    Text = "Ew Player",
    Default = false,
    Callback = function(Value)
        GetSuckedEnabled = Value
        if Value then
            if not SharedTarget then
                Library:Notify({Title = "Get Sucked", Description = "Pilih target dulu!", Time = 3})
                Toggles.GetSuckedToggle:SetValue(false)
                return
            end

            local localChar = LocalPlayer.Character
            local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")
            local targetHRP = SharedTarget.Character and SharedTarget.Character:FindFirstChild("HumanoidRootPart")

            if localHRP and targetHRP then
                originalGravity = workspace.Gravity
                workspace.Gravity = 0

                spawn(function()
                    while GetSuckedEnabled and localHRP.Position.Y <= 44 do
                        localHRP.CFrame = localHRP.CFrame * CFrame.new(0, 1.5, 0)
                        task.wait()
                    end
                end)

                task.wait(1)

                suckedAttachmentLoop = RunService.Stepped:Connect(function()
                    if localHRP and targetHRP then
                        localHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -1.1) * CFrame.Angles(0, math.pi, 0)
                        localHRP.Velocity = Vector3.new(0, 0, 0)
                    end
                end)

                local anim = Instance.new("Animation")
                anim.AnimationId = "rbxassetid://148840371"
                local hum = localChar:FindFirstChildOfClass("Humanoid")
                if hum then
                    suckedAnimTrack = hum:LoadAnimation(anim)
                    suckedAnimTrack:Play()
                    suckedAnimTrack:AdjustSpeed(3)
                end
            end
        else
            workspace.Gravity = originalGravity
            if suckedAttachmentLoop then suckedAttachmentLoop:Disconnect() end
            if suckedAnimTrack then suckedAnimTrack:Stop() end
            suckedAttachmentLoop = nil
            suckedAnimTrack = nil
        end
    end
})

local CrosshairBox = TabsUI.Main:AddRightGroupbox("Crosshair", "crosshair")

local CrosshairToggle = CrosshairBox:AddCheckbox("CrosshairEnabled", {
    Text = "Enable Crosshair", 
    Default = false,
    Callback = function(v) 
        Crosshair.Enabled = v
        if not v then 
            clearCrosshair() 
        end
    end
})

CrosshairToggle:AddColorPicker("CrosshairColor", {
    Default = Color3.fromRGB(255, 255, 0), 
    Title = "Crosshair Color", 
    Transparency = 0,
    Callback = function(color) 
        Crosshair.Color = color 
    end
})

CrosshairBox:AddDropdown("Style", {
    Values = {"Plus", "Dot", "Circle"}, 
    Default = 2, 
    Multi = false, 
    Text = "Style",
    Callback = function(v) 
        Crosshair.Style = v
        clearCrosshair()
        State.created = false
    end
})

CrosshairBox:AddSlider("CrosshairSize", {
    Text = "Size", 
    Default = 8, 
    Min = 2, 
    Max = 30, 
    Rounding = 0,
    Callback = function(v) 
        Crosshair.Size = v 
    end
})

CrosshairBox:AddSlider("CrosshairThickness", {
    Text = "Thickness", 
    Default = 2, 
    Min = 1, 
    Max = 5, 
    Rounding = 0,
    Callback = function(v) 
        Crosshair.Thickness = v 
    end
})

CrosshairBox:AddSlider("CrosshairPosX", {
    Text = "Position X", 
    Default = 0, 
    Min = -100, 
    Max = 100, 
    Rounding = 0,
    Callback = function(v) 
        Crosshair.OffsetX = v 
    end
})

CrosshairBox:AddSlider("CrosshairPosY", {
    Text = "Position Y", 
    Default = 0, 
    Min = -100, 
    Max = 100, 
    Rounding = 0,
    Callback = function(v) 
        Crosshair.OffsetY = v 
    end
})

-- Auto Parry
local ParryGroup = TabsUI.Survivor:AddLeftGroupbox("Ability", "swords")

ParryGroup:AddToggle("Skill", {
    Text = "Auto Skill Check", Default = false,
    Callback = function(v) Auto.SkillCheck = v; if v then startSkillCheck() end end
}):AddKeyPicker("SkillCheckKey", {
    Default = "None",
    Text = "Toggle Skill Check",
    SyncToggleState = true,
    Mode = "Toggle",
    NoUI = false
})
ParryGroup:AddDropdown("SkillCheckModeDropdown", {
    Values = {"Legit", "Instant", "Normal", "Random"}, 
    Default = 1, 
    Multi = false, 
    Text = "Skill Check Mode",
    Callback = function(v) 
        Auto.SkillCheckMode = v 
    end
})

ParryGroup:AddSlider("SkillFrequency", {
    Text = "Skill Check Frequency",
    Tooltip = "Atur frekuensi munculnya skill check",
    Default = 10,
    Min = 1,
    Max = 50,
    Rounding = 0,
    Callback = function(Value)
        ConfigData.Surv_SkillFrequency = Value
    end,
})

ParryGroup:AddSlider("SkillSpeed", {
    Text = "Skill Check Speed",
    Tooltip = "Atur kecepatan putaran skill check (1-30, 10 = Normal)",
    Default = 10,
    Min = 1,
    Max = 30,
    Rounding = 1,
    Callback = function(Value)
        ConfigData.Surv_SkillSpeed = Value / 10
    end,
})

ParryGroup:AddDropdown("BypassGenModeSelect", {
        Values = { "Manual Repair", "Auto Repair" },
        Default = "Manual Repair",
        Callback = function(Value)
            BypassGenMode = Value
        end,
    })
ParryGroup:AddToggle("BypassGen", {
    Text = "Gen Boost (Multi-Repair)",
    Tooltip = "Memperbaiki generator dengan cepat tanpa terdeteksi",
    Default = false,
    Callback = function(Value)
        BypassToggleValue = Value
        BypassGenEnabled = Value
        BypassButton.Visible = Value and UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
        if not Value then
            ProcessedGens = {}
            AutoRepairEnabled = false
            AutoCurrentGenModel = nil
            if AutoRepairThread then
                task.cancel(AutoRepairThread)
                AutoRepairThread = nil
            end
            StopAutoRepair()
        end
    end,
})

ParryGroup:AddToggle("Surv_AutoCrouch", {
    Text = "Auto Crouch (Dodge S1)",
    Tooltip = "Otomatis jongkok saat Abyssal menggunakan S1",
    Default = false,
    Callback = function(Value)
        Config.Surv_AutoCrouch = Value
    end,
})

ParryGroup:AddToggle("Surv_CrouchV", {
    Text = "Auto Dodge Veil",
    Default = false,
    Callback = function(v)
        Config.Surv_CrouchV = v
        Library:Notify({
            Title = "Pandu Hub",
            Description = "Auto Dodge Veil: " .. (v and "ON" or "OFF"),
            Time = 2
        })
    end
})

ParryGroup:AddToggle("InstantTPGate", {
    Text = "Instant TP Gate",
    Tooltip = "Teleport ke gate secara instan tanpa delay",
    Default = false,
    Callback = function(Value)
        Config.InstantTPGate = Value
        Library:Notify({ 
            Title = "Instant TP Gate", 
            Description = Value and "✅ Aktif" or "❌ Nonaktif", 
            Time = 2 
        })

        if Value then
            setAllGateDuration(0)
            applyHooks()
        else
            setAllGateDuration(1.5)
            removeHooks()
        end
    end
}):AddKeyPicker("InstantTPGateKey", {
    Default = "None",
    Text = "Instant TP Gate Key",
    Mode = "Toggle",
    Callback = function(Value)
        Config.InstantTPGate = Value
        if Toggles.InstantTPGate then
            Toggles.InstantTPGate:SetValue(Value)
        end
        
        if Value then
            setAllGateDuration(0)
            applyHooks()
        else
            setAllGateDuration(1.5)
            removeHooks()
        end
    end
})

-- ==================== UNLIMITED VAULT ====================
local UnlimitedVaultEnabled = false

function EnableUnlimitedVault()
    if UnlimitedVaultEnabled then return end
    UnlimitedVaultEnabled = true
    
    if _G.UnlimitedVaultConn then
        _G.UnlimitedVaultConn:Disconnect()
    end
    
    for _, v in ipairs(CollectionService:GetTagged("Blocked")) do
        CollectionService:RemoveTag(v, "Blocked")
    end
    
    _G.UnlimitedVaultConn = CollectionService:GetInstanceAddedSignal("Blocked"):Connect(function(instance)
        CollectionService:RemoveTag(instance, "Blocked")
    end)
    
    Library:Notify({ 
        Title = "Unlimited Vault", 
        Description = "Aktif", 
        Time = 3 
    })
end

function DisableUnlimitedVault()
    UnlimitedVaultEnabled = false
    
    if _G.UnlimitedVaultConn then
        _G.UnlimitedVaultConn:Disconnect()
        _G.UnlimitedVaultConn = nil
    end
    
    Library:Notify({ 
        Title = "Unlimited Vault", 
        Description = "Nonaktif", 
        Time = 2 
    })
end

ParryGroup:AddToggle("UnlimitedVault", {
    Text = "Unlimited Vault",
    Tooltip = "Vault/ lompat jendela tanpa batas (tanpa cooldown)",
    Default = false,
    Callback = function(Value)
        if Value then
            EnableUnlimitedVault()
        else
            DisableUnlimitedVault()
        end
    end
}):AddKeyPicker("UnlimitedVaultKey", {
    Default = "None",
    Text = "Keybind Unlimited Vault",
    Mode = "Toggle",
    Callback = function(Value)
        if Value then
            EnableUnlimitedVault()
        else
            DisableUnlimitedVault()
        end
    end,
})

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if UnlimitedVaultEnabled then
        for _, v in ipairs(CollectionService:GetTagged("Blocked")) do
            CollectionService:RemoveTag(v, "Blocked")
        end
    end
end)

ParryGroup:AddToggle("Surv_PerfectVault", {
    Text = "Anti Slow Vault",
    Tooltip = "Mencegah perlambatan saat vault (perfect vault)",
    Default = false,
    Callback = function(Value)
        Config.Surv_PerfectVault = Value
        if Value then
            Library:Notify({ Title = "Anti Slow Vault", Description = "On", Time = 2 })
        else
            Library:Notify({ Title = "Anti Slow Vault", Description = "Off", Time = 2 })
        end
    end
}):AddKeyPicker("PerfectVaultKey", {
    Default = "None",
    Text = "Toggle Anti Slow Vault",
    Mode = "Toggle",
    SyncToggleState = true,
    Callback = function(Value)
        Config.Surv_PerfectVault = Value
        if Value then
            Library:Notify({ Title = "Anti Slow Vault", Description = "On", Time = 2 })
        else
            Library:Notify({ Title = "Anti Slow Vault", Description = "Off", Time = 2 })
        end
    end
})

-- ==================== FLOWSTATE NO CD ====================
local fastVaultEnabled = false
local fastVaultConn = nil
local flowstateCharAddedConn = nil

function setupFlowstateCharacter(char)
    if not char then return end
    
    char:SetAttribute("Flowstate", true)
    
    if fastVaultConn then
        fastVaultConn:Disconnect()
        fastVaultConn = nil
    end
    
    fastVaultConn = char:GetAttributeChangedSignal("Flowstate"):Connect(function()
        if not fastVaultEnabled then return end
        if char:GetAttribute("Flowstate") == false then
            task.wait(0.05)
            char:SetAttribute("Flowstate", true)
        end
    end)
end

ParryGroup:AddToggle("FlowState", {
    Text = "Flowstate No CD",
    Default = false,
    Callback = function(Value)
        fastVaultEnabled = Value
        
        if fastVaultConn then
            fastVaultConn:Disconnect()
            fastVaultConn = nil
        end
        
        if flowstateCharAddedConn then
            flowstateCharAddedConn:Disconnect()
            flowstateCharAddedConn = nil
        end
        
        if not Value then
            local char = LocalPlayer.Character
            if char then
                char:SetAttribute("Flowstate", false)
            end
            return
        end
        
        setupFlowstateCharacter(LocalPlayer.Character)
        
        flowstateCharAddedConn = LocalPlayer.CharacterAdded:Connect(function(char)
            if not fastVaultEnabled then return end
            task.wait(1)
            setupFlowstateCharacter(char)
        end)
    end,
}):AddKeyPicker("FlowStateKey", {
    Default = "None",
    Text = "Keybind Flowstate No CD",
    Mode = "Toggle",
    Callback = function(Value)
        Toggles.FlowState:SetValue(Value)
    end,
})

local NoFallEnabled = false
local FallEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Mechanics"):WaitForChild("Fall")

local rawMT = getrawmetatable(game)
local oldNamecall = rawMT.__namecall
setreadonly(rawMT, false)

rawMT.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if NoFallEnabled and self == FallEvent and (method == "FireServer" or method == "fireServer") then
        args[1] = 0 
        return oldNamecall(self, unpack(args))
    end

    return oldNamecall(self, ...)
end)

setreadonly(rawMT, true)

ParryGroup:AddToggle("NoFall", {
    Text = "No Fall Damage",
    Default = false,
    Callback = function(state)
        NoFallEnabled = state
    end
})

ParryGroup:AddToggle("BypassGate", {
    Text = "Bypass Exite Gate",
    Tooltip = "Tembus gate tanpa collision",
    Default = false,
    Callback = function(Value)
        setBypassGate(Value)

        if Value then
            Library:Notify({
                Title = "Bypass Exite Gate",
                Description = "Gate bypass aktif!",
                Time = 3
            })
        else
            Library:Notify({
                Title = "Bypass Exite Gate",
                Description = "Gate bypass dimatikan!",
                Time = 3
            })
        end
    end,
})

local isAutoHealActive = false
local healAnimListener = nil

local function suppressHealingAnimation()
    if healAnimListener then return end
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then return end

    healAnimListener = animator.AnimationPlayed:Connect(function(activeTrack)
        if activeTrack.Animation and activeTrack.Animation.AnimationId:find("95836365038528") then
            activeTrack:Stop(0)
        end
    end)
end

local function restoreHealingAnimation()
    if healAnimListener then
        pcall(function() healAnimListener:Disconnect() end)
        healAnimListener = nil
    end
end

-- Looping langsung tanpa fungsi terpisah
task.spawn(function()
    while true do
        task.wait(3)
        if isAutoHealActive then
            if LocalPlayer.Team.Name ~= "Killer" then
                local character = LocalPlayer.Character
                if character then
                    local interactState = character:FindFirstChild("CheckInterractable")
                    local rootPart = character:FindFirstChild("HumanoidRootPart")
                    local humanoid = character:FindFirstChildOfClass("Humanoid")

                    local isBusy = false
                    if interactState then
                        if interactState:GetAttribute("isVaulting") 
                        or interactState:GetAttribute("isRepairing") 
                        or interactState:GetAttribute("isUnhooking") 
                        or interactState:GetAttribute("isHealing") 
                        or interactState:GetAttribute("isSliding") then
                            isBusy = true
                        end
                    end

                    if not isBusy and rootPart and humanoid and humanoid.Health < humanoid.MaxHealth then
                        pcall(function()
                            local remoteService = ReplicatedStorage:FindFirstChild("Remotes")
                            if remoteService and remoteService:FindFirstChild("Healing") then
                                remoteService.Healing.HealEvent:FireServer(rootPart, true)
                            end
                        end)
                    end
                end
            end
        end
    end
end)

LocalPlayer.CharacterRemoving:Connect(function()
    restoreHealingAnimation()
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(5)
    if isAutoHealActive then
        suppressHealingAnimation()
    end
end)


ParryGroup:AddToggle("SelfHeal", {
    Text = "Self Heal",
    Default = false,
    Callback = function(state)
        if GetRole() == "Killer" then
            Library:Notify("Kamu harus Survivor!")
            Toggles.SelfHeal:SetValue(false)
            return
        end
        
        isAutoHealActive = state
        if state then
            suppressHealingAnimation()
            Library:Notify("Self Heal: ENABLED (Tanpa Animasi)")
        else
            restoreHealingAnimation()
            Library:Notify("Self Heal: DISABLED")
        end
    end
}):AddKeyPicker("SelfHealKey", {
    Default = "None",
    Text = "Keybind Self Heal",
    Mode = "Toggle",
    SyncToggleState = true,
    Callback = function(Value)
        if GetRole() == "Killer" then
            Library:Notify("Kamu harus Survivor!")
            return
        end
        
        isAutoHealActive = Value
        if Value then
            suppressHealingAnimation()
            if Toggles.SelfHeal then Toggles.SelfHeal:SetValue(true) end
            Library:Notify("Self Heal: ENABLED (Tanpa Animasi)")
        else
            restoreHealingAnimation()
            if Toggles.SelfHeal then Toggles.SelfHeal:SetValue(false) end
            Library:Notify("Self Heal: DISABLED")
        end
    end
})

ParryGroup:AddToggle("GodMode", {
    Text = "Anti Knockdown",
    Tooltip = "Ga bisa mati (semi god)",
    Default = false,
    Callback = function(Value)
        GodMode = Value
    end,
})

ParryGroup:AddToggle("FleeKiller", {
    Text = "Flee Killer",
    Tooltip = "Teleport saat killer terlalu dekat",
    Default = false,

    Callback = function(Value)
        FleeKillerEnabled = Value
    end,
})

ParryGroup:AddSlider("FleeDistance", {
    Text = "Flee Distance",
    Tooltip = "Jarak trigger teleport",
    Default = 40,
    Min = 15,
    Max = 80,
    Rounding = 0,

    Callback = function(Value)
        FleeDistance = Value
    end,
})

ParryGroup:AddButton({
    Text = "Apply Korless",
    Callback = function()
        ApplyKorless()
        Library:Notify({
            Title = "PANDU",
            Description = "Korless Morph Applied",
            Time = 3
        })
    end
})

ParryGroup:AddButton({Text = "instan escape", Func = function() teleportToFinishLine() end})

ParryGroup:AddDivider()

ParryGroup:AddToggle("AutoParry", {
    Text = "Auto Parry",
    Default = false,
    Callback = function(Value)
        Config.Surv_AutoParry = Value
    end,
}):AddKeyPicker("AutoParryKey", {
    Default = "None",
    Text = "Auto Parry Key",
    Mode = "Toggle",
    Callback = function(Value)
        Config.Surv_AutoParry = Value
    end,
})

ParryGroup:AddToggle("CustomParryToggle", {
    Text = "Auto Parry GUI",
    Default = false,
    Callback = function(Value)
        if Value then
            if not AutoParryCustom.Gui then
                CreateCustomParryGUI()
            end
            AutoParryCustom.Gui.Enabled = true
            AutoParryCustom.GuiVisible = true
            UpdateCustomParryGUI(Config.Surv_AutoParry)
            Library:Notify({ Title = "Auto Parry GUI", Description = "Gui Loaded", Time = 2 })
        else
            if Config.Surv_AutoParry then
                Config.Surv_AutoParry = false
                AutoParryCustom.IsActive = false
                if Toggles.AutoParryKey then
                    Toggles.AutoParryKey:SetValue(false)
                end
                if Toggles.AutoParry then
                    Toggles.AutoParry:SetValue(false)
                end
            end
            if AutoParryCustom.Gui then
                AutoParryCustom.Gui.Enabled = false
                AutoParryCustom.GuiVisible = false
            end
            Library:Notify({ Title = "Auto Parry GUI", Description = "Distory Gui", Time = 2 })
        end
    end
})

ParryGroup:AddCheckbox("Surv_ParrySafety", { Text = "Safety Parry", Default = false, Callback = function(Value) Config.Surv_ParrySafety = Value end })

ParryGroup:AddToggle("ParryAggressive", {
    Text = "Aggressive Mode",
    Tooltip = "Langsung parry tanpa peduli face direction",
    Default = false,
    Callback = function(Value)
        Config.Surv_ParryAggressive = Value
    end,
})

ParryGroup:AddToggle("ParryCircle", {
    Text = "ESP Range Circle",
    Tooltip = "Tampilkan radius jarak parry di karakter",
    Default = true,
    Callback = function(Value)
        Config.Surv_ParryCircle = Value
    end,
})

ParryGroup:AddSlider("ParryRadius", {
    Text = "Parry Radius",
    Tooltip = "Jarak maksimal parry bereaksi",
    Default = 15,
    Min = 5,
    Max = 25,
    Rounding = 0,
    Callback = function(Value)
        Config.Surv_ParryRadius = Value
    end,
})

ParryGroup:AddSlider("ParryFace", {
    Text = "Face Sensitivity",
    Tooltip = "Sensitivitas arah pandang (1-10)",
    Default = 7,
    Min = -10,
    Max = 10,
    Rounding = 0,
    Callback = function(Value)
        Config.Surv_ParryFace = Value / 10
    end,
})

ParryGroup:AddDropdown("IgnoreSkills", {
    Values = { "Hidden S1", "Abyssal S1" },
    Default = {},
    Multi = true,
    Text = "Abaikan skill tertentu",
    Tooltip = "Abaikan skill tertentu",
    Callback = function(Value)
        local parsed = {}
        for k, v in pairs(Value) do
            if type(k) == "string" and v then 
                parsed[k] = true
            elseif type(v) == "string" then 
                parsed[v] = true 
            end
        end
        Config.Ignored_Skills_List = parsed
    end,
})

ParryGroup:AddDivider()

ParryGroup:AddButton({
    Text = "Fake Parry GUI",
    Func = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://pastefy.app/tz2VGaIN/raw"))()
        end)
        if success then
            Library:Notify({ Title = "Fake Parry", Description = "GUI Fake Parry berhasil dimuat!", Time = 3 })
        else
            Library:Notify({ Title = "Error", Description = "Gagal memuat Fake Parry GUI!", Time = 3 })
        end
    end
})
-- ==================== AUTO PALLET UI ====================
local PalletGroup = TabsUI.Survivor:AddLeftGroupbox("Auto Pallet", "table")

PalletGroup:AddButton({
    Text = "Drop All Pallet",
    Func = function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local dropEvent = remotes and remotes:FindFirstChild("Pallet") 
            and remotes.Pallet:FindFirstChild("PalletDropEvent")
        
        local palletGroups = {}
        function refreshPalletCache()
            palletGroups = {}

            local map = workspace:FindFirstChild("Map")
            if not map then return end

            for _, descendant in ipairs(map:GetDescendants()) do
                if descendant.Name == "PalletPoint" and descendant:IsA("BasePart") then
                    local palletModel = descendant:FindFirstAncestorWhichIsA("Model")
                    if palletModel then
                        if not palletGroups[palletModel] then
                            palletGroups[palletModel] = {}
                        end
                        table.insert(palletGroups[palletModel], descendant)
                    end
                end
            end
        end
        
        refreshPalletCache()
        
        local count = 0
        for palletModel, points in pairs(palletGroups) do
            for _, point in ipairs(points) do
                pcall(function()
                    dropEvent:FireServer(point)
                    count = count + 1
                end)
            end
        end
    end
})

PalletGroup:AddToggle("AutoPallet", {
    Text = "Auto Drop Pallet",
    Default = false,
    Callback = function(Value)
        AutoPalletEnabled = Value
        if Value then 
            StartAutoPallet() 
            Library:Notify({ Title = "Auto Pallet", Description = "AKTIF", Time = 2 })
        else 
            StopAutoPallet() 
            Library:Notify({ Title = "Auto Pallet", Description = "NONAKTIF", Time = 2 })
        end
    end,
}):AddKeyPicker("AutoPalletKey", {
    Default = "None",
    Text = "Auto Pallet Key",
    Mode = "Toggle",
    Callback = function(Value)
        AutoPalletEnabled = Value
        if Value then StartAutoPallet() else StopAutoPallet() end
    end,
})

PalletGroup:AddCheckbox("AutoPalletSafety", {
    Text = "Safety Pallet",
    Tooltip = "Cegah drop pallet saat down/carry/hook (biar aman)",
    Default = true,
    Callback = function(Value)
        AutoPalletSafety = Value
    end,
})

PalletGroup:AddSlider("AutoPalletDist", {
    Text = "Trigger Distance",
    Default = 10,
    Min = 8,
    Max = 30,
    Rounding = 0,
    Callback = function(Value)
        AutoPalletDistance = Value
    end,
})

do 
    local function getToFEvent()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local items = remotes and remotes:FindFirstChild("Items")
    local tof = items and items:FindFirstChild("Twist of Fate")
    return tof and tof:FindFirstChild("Fire")
end

    local silentAimToFV1 = false   -- V1 = hold (script lama)
    local silentAimToFV2 = false   -- V2 = tap

local function IsToFSilentOn()
    return silentAimToFV1 or silentAimToFV2
end
    local laserEnabled = true
    local wallcheckEnabled = false
    local isAiming = false
    local Connection = nil
    local LaserBeam = nil
    local silentAimGui = nil
    local targetMode = "Killer"
    local savedUIPos = UDim2.new(0.5, -120, 0, 110)
    
    local velocityCache = {}
    local PREDICT_SETTINGS = {
    PredictionEfficiency = 0.85, 
    LerpSmoothness = 0.4,
    EnableJitter = false,
    MaxJitterStuds = 0,
}

    function getGunObject()
        local char = LocalPlayer.Character
        if not char then return nil end
        local baseToF = char:FindFirstChild("Twist of Fate", true)
        if not baseToF then return nil end
        local rightArm = baseToF:FindFirstChild("Right Arm")
        if rightArm then
            local gunPart = rightArm:FindFirstChild("gun")
            if gunPart then return gunPart end
            local emperorGun = rightArm:FindFirstChild("EmperorGun")
            if emperorGun then return emperorGun end
        end
        return baseToF
    end

    function isTargetVisible(originPos, torsoPos, targetCharacter)
        local direction = torsoPos - originPos
        local distance = direction.Magnitude
        if distance < 0.1 then return true end

        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude

        local excludeList = {}
        local localChar = LocalPlayer.Character
        if localChar then
            table.insert(excludeList, localChar)
        end
        if targetCharacter and targetCharacter ~= localChar then
            table.insert(excludeList, targetCharacter)
        end
        if LaserBeam then
            table.insert(excludeList, LaserBeam)
        end

        rayParams.FilterDescendantsInstances = excludeList

        local result = workspace:Raycast(originPos, direction.Unit * distance, rayParams)
        return result == nil
    end

    local SCPCache = {}
    local SCPCacheTimer = 0
    
    function GetSCPs()
        if tick() - SCPCacheTimer < 0.5 then return SCPCache end
            
        local newTargets = {}
        local mapFolder = workspace:FindFirstChild("Map")
        
        if mapFolder then
            for _, container in pairs(mapFolder:GetDescendants()) do
                if container:IsA("Model") then
                    local attributes = container:GetAttributes()
                    
                    if container:GetAttribute("CorpseCreated0492") or next(attributes) ~= nil then
                        local root = container:FindFirstChild("HumanoidRootPart")
                        if root then 
                            table.insert(newTargets, root) 
                        end
                    end
                end
            end
        end
        
        SCPCache = newTargets
        SCPCacheTimer = tick()
        return SCPCache
    end
    
    local function getTargetVelocity(targetCharacter)
    local rootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
    if not rootPart then return Vector3.zero end

    local currentPos = rootPart.Position
    local cached = velocityCache[targetCharacter]
    
    if cached then
        local timeDelta = tick() - cached.time
        if timeDelta > 0.001 and timeDelta < 0.1 then
            local rawVel = (currentPos - cached.pos) / timeDelta
            local smoothVel = cached.vel:Lerp(rawVel, PREDICT_SETTINGS.LerpSmoothness)
            velocityCache[targetCharacter] = {
                pos = currentPos,
                vel = smoothVel,
                time = tick()
            }
            return smoothVel
        end
    end

    velocityCache[targetCharacter] = {
        pos = currentPos,
        vel = rootPart.Velocity,
        time = tick()
    }
    return rootPart.Velocity
end

local function GetPredictedToFPosition(originPos, targetPart, targetCharacter, bulletSpeed)
    bulletSpeed = bulletSpeed or 500
    local targetPos = targetPart.Position

    local distance = (targetPos - originPos).Magnitude
    if distance < 8 then
        return targetPos
    end

    local targetVel = getTargetVelocity(targetCharacter)
    local relativePos = targetPos - originPos

    local a = targetVel:Dot(targetVel) - (bulletSpeed * bulletSpeed)
    local b = 2 * relativePos:Dot(targetVel)
    local c = relativePos:Dot(relativePos)

    local t = nil
    if math.abs(a) < 0.01 then
        if math.abs(b) > 0.01 then t = -c / b end
    else
        local discriminant = b * b - 4 * a * c
        if discriminant >= 0 then
            local sqrtD = math.sqrt(discriminant)
            local t1 = (-b - sqrtD) / (2 * a)
            local t2 = (-b + sqrtD) / (2 * a)
            if t1 > 0.001 then t = t1 elseif t2 > 0.001 then t = t2 end
        end
    end

    local finalPredictedPos = targetPos
    if t then
        local nerfedVelocity = targetVel * PREDICT_SETTINGS.PredictionEfficiency
        finalPredictedPos = targetPos + (nerfedVelocity * t)

        if PREDICT_SETTINGS.EnableJitter then
            local jitter = Vector3.new(
                (math.random() - 0.5) * PREDICT_SETTINGS.MaxJitterStuds,
                (math.random() - 0.5) * (PREDICT_SETTINGS.MaxJitterStuds / 2),
                (math.random() - 0.5) * PREDICT_SETTINGS.MaxJitterStuds
            )
            finalPredictedPos = finalPredictedPos + jitter
        end
    end

    return finalPredictedPos
end

    function getTargetPosition()
        local cam = workspace.CurrentCamera
        local gunObj = getGunObject()
        local char = LocalPlayer.Character
        if not (gunObj and char) then return nil, nil, nil, nil end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil, nil, nil, nil end

        local myPos = hrp.Position
        local originPos
        if char:GetAttribute("IsCarried") then
            originPos = char.HumanoidRootPart.Position + (char.HumanoidRootPart.CFrame.LookVector * 2)
        else
            pcall(function()
                originPos = gunObj:IsA("BasePart") and gunObj.Position 
                            or gunObj:FindFirstChildOfClass("BasePart") and gunObj:FindFirstChildOfClass("BasePart").Position
            end)
            originPos = originPos or Vector3.new(myPos.X, myPos.Y + 1.5, myPos.Z)
        end

        local function predictTarget(targetPart, targetCharacter)
    local targetPos = targetPart.Position
    
    if wallcheckEnabled and not isTargetVisible(originPos, targetPos, targetCharacter) then
        return nil, nil, nil, nil
    end

    local gunObj = getGunObject()
    local checkOriginPos = originPos
    
    pcall(function()
        if gunObj and gunObj:IsA("BasePart") then
            checkOriginPos = gunObj.Position
        elseif gunObj then
            local part = gunObj:FindFirstChildOfClass("BasePart")
            if part then checkOriginPos = part.Position end
        end
    end)

    local distance = (targetPos - checkOriginPos).Magnitude
    if distance < 8 then
        return (targetPos - checkOriginPos).Unit, gunObj, checkOriginPos, targetPos
    end

    if not silentAimPredict then
        return (targetPos - checkOriginPos).Unit, gunObj, checkOriginPos, targetPos
    end

    local predictedPos = GetPredictedToFPosition(checkOriginPos, targetPart, targetCharacter, 500)

    return (predictedPos - checkOriginPos).Unit, gunObj, checkOriginPos, predictedPos
end

        if targetMode == "Killer" then
            local closestTorso = nil
            local closestChar = nil
            local shortestDist = math.huge
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local isKiller = player.Team and player.Team.Name == "Killer"
                    if isKiller and player.Character then
                        local torso = player.Character:FindFirstChild("Torso")
                        if torso then
                            local dist = (myPos - torso.Position).Magnitude
                            if dist < shortestDist then
                                shortestDist = dist
                                closestTorso = torso
                                closestChar = player.Character
                            end
                        end
                    end
                end
            end
            if not closestTorso then return nil, nil, nil, nil end
            return predictTarget(closestTorso, closestChar)

        elseif targetMode == "Survivors" then
            local bestTorso = nil
            local bestChar = nil
            local bestDot = -math.huge
            local cam = workspace.CurrentCamera
            local camLook = cam.CFrame.LookVector

            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Team and player.Team.Name == "Survivors" and player.Character then
                    local torso = player.Character:FindFirstChild("Torso")
                    
                    if torso then
                        local dirToTarget = (torso.Position - cam.CFrame.Position).Unit
                        local dot = camLook:Dot(dirToTarget)
                        
                        if dot > 0.5 and dot > bestDot then
                            bestDot = dot
                            bestTorso = torso
                            bestChar = player.Character
                        end
                    end
                end
            end
            if not bestTorso then return nil, nil, nil, nil end
            return predictTarget(bestTorso, bestChar)

        elseif targetMode == "Zombie" then
            local targets = GetSCPs()
            local bestPart = nil
            local bestDot = -math.huge
            local cam = workspace.CurrentCamera
            local camLook = cam.CFrame.LookVector

            for _, root in ipairs(targets) do
                if root and root.Parent then
                    local dirToTarget = (root.Position - cam.CFrame.Position).Unit
                    local dot = camLook:Dot(dirToTarget)
                    
                    if dot > 0.5 and dot > bestDot then
                        bestDot = dot
                        bestPart = root
                    end
                end
            end
            if not bestPart then return nil, nil, nil, nil end
            return predictTarget(bestPart, bestPart.Parent)
        end

        return nil, nil, nil, nil
    end

    function updateLaser(originPos, targetPos)
        if not LaserBeam then
            LaserBeam = Instance.new("Part")
            LaserBeam.Name = "ToFLaser"
            LaserBeam.Anchored = true
            LaserBeam.CanCollide = false
            LaserBeam.CanTouch = false
            LaserBeam.CastShadow = false
            LaserBeam.Material = Enum.Material.Neon
            LaserBeam.Color = Color3.fromRGB(255, 50, 50)
            LaserBeam.Parent = workspace
        end
        local dist = (targetPos - originPos).Magnitude
        LaserBeam.Size = Vector3.new(0.05, 0.05, dist)
        LaserBeam.CFrame = CFrame.new((originPos + targetPos) / 2, targetPos)
        LaserBeam.Transparency = 0
    end

    function clearLaser()
        if LaserBeam then
            LaserBeam:Destroy()
            LaserBeam = nil
        end
    end

    function doShoot()
    if not IsToFSilentOn() then return end
    -- V1: wajib sedang aim (hold)
    if silentAimToFV1 and not silentAimToFV2 then
        if not isAiming then return end
    end
    -- V2: boleh pure tap (isAiming opsional)
        
        local char = LocalPlayer.Character
        if char then
            if AimConfig.Pistol_BlockKnocked and IsDowned(char) then
                return
            end
        end
        
        local targetDirection, gunObject, originPos, targetPos = getTargetPosition()
        if not (targetDirection and gunObject and targetPos and originPos) then return end
        
        local ToFEvent = getToFEvent()
        if not ToFEvent then return end
        
        local freshDirection = (targetPos - originPos).Unit
        pcall(function()
            ToFEvent:FireServer(gunObject, freshDirection)
        end)
    end

    function startConnection()
        if Connection then return end
        Connection = RunService.Heartbeat:Connect(function()
            if isAiming and IsToFSilentOn() then
                local targetDirection, gunObject, originPos, targetPos = getTargetPosition()
                if targetDirection and gunObject and targetPos then
                    pcall(function()
                        local char = LocalPlayer.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        if hrp and not char:GetAttribute("IsCarried") then
                            hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z))
                        end
                    end)
                    
                    if AimConfig.LockAim then
                        local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, targetPos)
                        Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 0.15)
                    end

                    if laserEnabled and originPos and targetPos then
                        updateLaser(originPos, targetPos)
                    end
                else
                    if LaserBeam then LaserBeam.Transparency = 1 end
                end
            else
                if LaserBeam then LaserBeam.Transparency = 1 end
            end
        end)
    end

    function stopConnection()
        if Connection then
            Connection:Disconnect()
            Connection = nil
        end
        clearLaser()
    end

    local targetGuiRef = nil
    local targetKeyConn = nil

    local MODES = {
        { internal = "Killer",    display = "Killer (K)",   activeColor = Color3.fromRGB(180, 45, 45),  activeTxt = Color3.fromRGB(255, 180, 180) },
        { internal = "Survivors", display = "Survivors (J)", activeColor = Color3.fromRGB(25, 80, 150),  activeTxt = Color3.fromRGB(160, 210, 255) },
        { internal = "Zombie",    display = "Zombie (L)",    activeColor = Color3.fromRGB(120, 80, 10),  activeTxt = Color3.fromRGB(255, 210, 100) },
    }

    function createTargetSelectorUI()
    local cg = CoreGui
    if not cg then return end

    if targetGuiRef and targetGuiRef.Parent then return end

    local old = cg:FindFirstChild("ToFTargetSelector")
    if old then old:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "ToFTargetSelector"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = cg

    local frame = Instance.new("Frame")
    frame.Name = "Main"
    frame.Size = UDim2.new(0, 240, 0, 58)
    frame.Position = savedUIPos 
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(55, 55, 55)
    stroke.Thickness = 0.8

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 22)
    header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    header.BorderSizePixel = 0
    header.Parent = frame
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 10)

    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 10)
    headerFix.Position = UDim2.new(0, 0, 1, -10)
    headerFix.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    headerFix.BorderSizePixel = 0
    headerFix.Parent = header

    local headerDiv = Instance.new("Frame")
    headerDiv.Size = UDim2.new(1, 0, 0, 1)
    headerDiv.Position = UDim2.new(0, 0, 1, -1)
    headerDiv.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    headerDiv.BorderSizePixel = 0
    headerDiv.Parent = header

    local dragArea = Instance.new("Frame")
    dragArea.Size = UDim2.new(1, -30, 1, 0)
    dragArea.BackgroundTransparency = 1
    dragArea.Parent = header

    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 24, 1, 0)
    minimizeBtn.Position = UDim2.new(1, -26, 0, 0)
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.Text = "−"
    minimizeBtn.TextColor3 = Color3.fromRGB(120, 120, 120)
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.TextSize = 14
    minimizeBtn.TextXAlignment = Enum.TextXAlignment.Center
    minimizeBtn.TextYAlignment = Enum.TextYAlignment.Center
    minimizeBtn.Parent = header

    local headerLbl = Instance.new("TextLabel")
    headerLbl.Size = UDim2.new(1, -30, 1, 0)
    headerLbl.Position = UDim2.new(0, 0, 0, 0)
    headerLbl.BackgroundTransparency = 1
    headerLbl.Text = "TARGET MODE TWIST OF FATE"
    headerLbl.TextColor3 = Color3.fromRGB(120, 120, 120)
    headerLbl.Font = Enum.Font.GothamBold
    headerLbl.TextSize = 9
    headerLbl.TextXAlignment = Enum.TextXAlignment.Center
    headerLbl.Parent = header

    local btnContainer = Instance.new("Frame")
    btnContainer.Size = UDim2.new(1, -16, 0, 26)
    btnContainer.Position = UDim2.new(0, 8, 0, 26)
    btnContainer.BackgroundTransparency = 1
    btnContainer.Parent = frame

    local layout = Instance.new("UIListLayout", btnContainer)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)

    local btnRefs = {}
    local isMinimized = false

    function updateButtons()
        for _, m in ipairs(MODES) do
            local btn = btnRefs[m.internal]
            if btn then
                if m.internal == targetMode then
                    btn.BackgroundColor3 = m.activeColor
                    btn.TextColor3 = m.activeTxt
                else
                    btn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                    btn.TextColor3 = Color3.fromRGB(130, 130, 130)
                end
            end
        end
    end

    function toggleMinimize()
        isMinimized = not isMinimized
        
        if isMinimized then
            minimizeBtn.Text = "+"
            btnContainer.Visible = false
            frame.Size = UDim2.new(0, 240, 0, 22)
        else
            minimizeBtn.Text = "−"
            btnContainer.Visible = true
            frame.Size = UDim2.new(0, 240, 0, 58)
        end
    end

    minimizeBtn.MouseButton1Click:Connect(toggleMinimize)

    for i, m in ipairs(MODES) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 70, 1, 0)
        btn.BorderSizePixel = 0
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.Text = m.display
        btn.LayoutOrder = i
        btn.Parent = btnContainer
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        btn.MouseButton1Click:Connect(function()
            targetMode = m.internal
            updateButtons()
        end)

        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                targetMode = m.internal
                updateButtons()
            end
        end)

        btnRefs[m.internal] = btn
    end

    updateButtons()

    local dragging = false
    local dragStart, startPos

    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragStart = input.Position
            startPos = frame.Position
            dragging = true
        end
    end)

    dragArea.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            frame.Position = newPos
            savedUIPos = newPos 
        end
    end)

    -- ===== GANTI DARI SINI =====
    if targetKeyConn then
        targetKeyConn:Disconnect()
        targetKeyConn = nil
    end

    targetKeyConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not IsToFSilentOn() then return end
        if gameProcessed or input.UserInputType ~= Enum.UserInputType.Keyboard then return end

        local newMode = nil
        if input.KeyCode == Enum.KeyCode.K then
            newMode = "Killer"
            Library:Notify({Title="Target Mode", Description="Killer", Time=1})
        elseif input.KeyCode == Enum.KeyCode.J then
            newMode = "Survivors"
            Library:Notify({Title="Target Mode", Description="Survivors", Time=1})
        elseif input.KeyCode == Enum.KeyCode.L then
            newMode = "Zombie"
            Library:Notify({Title="Target Mode", Description="Zombie", Time=1})
        end

        if newMode and newMode ~= targetMode then
            targetMode = newMode

            for modeName, btn in pairs(btnRefs) do
                if btn and btn.Parent then
                    local isActive = (modeName == targetMode)
                    for _, m in ipairs(MODES) do
                        if m.internal == modeName then
                            btn.BackgroundColor3 = isActive and m.activeColor or Color3.fromRGB(38, 38, 38)
                            btn.TextColor3 = isActive and m.activeTxt or Color3.fromRGB(130, 130, 130)
                            break
                        end
                    end
                end
            end
        end
    end)
    -- ===== SAMPAI SINI =====

    targetGuiRef = gui
end

function destroyTargetSelectorUI()
    -- ===== GANTI ISI JADI INI =====
    if targetKeyConn then
        targetKeyConn:Disconnect()
        targetKeyConn = nil
    end
    if targetGuiRef then
        targetGuiRef:Destroy()
        targetGuiRef = nil
    end
    -- ===== SAMPAI SINI =====
end

    local PistolGroup = TabsUI.Survivor:AddRightGroupbox("Silent Aim (Pistol)", "crosshair")

    PistolGroup:AddToggle("SilentAimToFV1", {
    Text = "Silent ToF V1 (Hold)",
    Default = false,
    Callback = function(Value)
        silentAimToFV1 = Value
        if Value then
            createTargetSelectorUI()
            startConnection()
        else
            if not IsToFSilentOn() then
                destroyTargetSelectorUI()
                stopConnection()
            end
        end
        Library:Notify({ Title = "Silent ToF V1", Description = Value and "ON (Hold)" or "OFF", Time = 2 })
    end,
}):AddKeyPicker("SilentAimToFV1Key", {
    Default = "None",
    Text = "ToF V1 Key",
    Mode = "Toggle",
    Callback = function(Value)
        silentAimToFV1 = Value
        if Toggles.SilentAimToFV1 then Toggles.SilentAimToFV1:SetValue(Value) end
        if Value then
            createTargetSelectorUI()
            startConnection()
        else
            if not IsToFSilentOn() then
                destroyTargetSelectorUI()
                stopConnection()
            end
        end
    end,
})

PistolGroup:AddToggle("SilentAimToFV2", {
    Text = "Silent ToF V2 (Tap)",
    Default = false,
    Callback = function(Value)
        silentAimToFV2 = Value
        if Value then
            createTargetSelectorUI()
            startConnection()
        else
            if not IsToFSilentOn() then
                destroyTargetSelectorUI()
                stopConnection()
            end
        end
        Library:Notify({ Title = "Silent ToF V2", Description = Value and "ON (Tap)" or "OFF", Time = 2 })
    end,
}):AddKeyPicker("SilentAimToFV2Key", {
    Default = "None",
    Text = "ToF V2 Key",
    Mode = "Toggle",
    Callback = function(Value)
        silentAimToFV2 = Value
        if Toggles.SilentAimToFV2 then Toggles.SilentAimToFV2:SetValue(Value) end
        if Value then
            createTargetSelectorUI()
            startConnection()
        else
            if not IsToFSilentOn() then
                destroyTargetSelectorUI()
                stopConnection()
            end
        end
    end,
})
    
    PistolGroup:AddToggle("Predict", {
    Text = "Predict Aim ToF",
    Default = false,
    Premium = true,
    Callback = function(v)
        silentAimPredict = v
        Library:Notify("auto predict aim: " ..(v and "enabled" or "disabled"))
    end
})

    PistolGroup:AddCheckbox("Pistol_BlockKnocked", { 
        Text = "Block aim Knocked", 
        Default = false,
        Callback = function(Value) 
            AimConfig.Pistol_BlockKnocked = Value 
        end 
        })

-- ==================== BLOCK PELURU ====================
local BulletBlockConfig = {
    Enabled = false
}

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall

setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
    if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
        
        if self and self.Name == "Fire" then
            local parent = self.Parent
            if parent and parent.Name == "Twist of Fate" then
                if BulletBlockConfig.Enabled then
                    return nil
                end
            end
        end
        
        if Killer.AntiBlind and GotBlindedRemote and self == GotBlindedRemote then
            local isKiller = LocalPlayer.Team and LocalPlayer.Team.Name == "Killer"
            if isKiller then
                return nil
            end
        end
        
    end
    
    -- ===== INFINITE FRENZY =====
if VD.KILLER_InfFrenzy and method == "FireServer" then
    local ok, name = pcall(function() return self.Name end)
    if ok and (name == "Deactivatefromclient" or name == "PowerDoneDeactivating") then
        return nil  -- blokir, jangan dikirim ke server
    end
end

if VD.KILLER_InfPursuit and method == "FireServer" then
    local ok, name = pcall(function() return self.Name end)
    if ok and name == "Pursuit" then
        local args = {...}
        if #args > 0 and args[1] == false then
            return nil  -- Block matiin Pursuit!
        end
    end
end
    
    if VD.KILLER_SilentAimFlask and method == "FireServer" then
    local ok, name = pcall(function() return self.Name end)
    if ok and name == "ThrowFlask" then
        local args = {...}
        local closest = nil
        local minDst  = math.huge
        local lp      = game:GetService("Players").LocalPlayer
        local myPos   = lp.Character
            and lp.Character:FindFirstChild("HumanoidRootPart")
            and lp.Character.HumanoidRootPart.Position

        if myPos then
            for _, v in pairs(game:GetService("Players"):GetPlayers()) do
                if v ~= lp
                and v.Character
                and v.Character:FindFirstChild("HumanoidRootPart")
                and not v.Character:GetAttribute("IsKiller") then
                    local dst = (v.Character.HumanoidRootPart.Position - myPos).Magnitude
                    if dst < minDst then
                        minDst  = dst
                        closest = v
                    end
                end
            end
        end

        if closest then
            local targetPos = closest.Character.HumanoidRootPart.Position
            -- args[1] = LookVector, args[2] = OriginPosition
            if args[2] and typeof(args[2]) == "Vector3" then
                args[1] = (targetPos - args[2]).Unit
            end
            setnamecallmethod(method)
            return oldNamecall(self, unpack(args))  -- ✅ BENAR!
        end
    end
end
    
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

PistolGroup:AddCheckbox("BlockPeluruToggle", {
    Text = "Block Aim (TOF)",
    Default = false,
    Callback = function(value)
        BulletBlockConfig.Enabled = value
        if value then
            Library:Notify({
                Title = "Block Peluru",
                Description = "AKTIF - Peluru TIDAK akan keluar",
                Time = 4
            })
        else
            Library:Notify({
                Title = "Block Peluru",
                Description = "Nonaktif - Peluru normal kembali",
                Time = 3
            })
        end
    end,
})
    PistolGroup:AddToggle("FlashAim", {
        Text = "Silent Aim (flash)",
        Default = false,
        Callback = function(Value)
            AimConfig.Flash_Silent = Value
        end,
    }):AddKeyPicker("SilentFlashKey", {
        Default = "None",
        Text = "Silent Aim Key",
        Mode = "Toggle",
        Callback = function(Value)
            AimConfig.Flash_Silent = Value
        end,
    })
    PistolGroup:AddSlider("FlashAimOffset", {
        Text = "Flash Head Offset (Y)",
        Tooltip = "Atur posisi bidikan (0 = Badan, 1.5 = Kepala, 8 = Atas Kepala)",
        Default = 8,
        Min = 1,
        Max = 15,
        Rounding = 1,
        Callback = function(Value)
            AimConfig.Flash_YOffset = Value
        end,
    })
    PistolGroup:AddToggle("LockAim", {
    Text = "Lock Aim (Twist Of fate)",
    Tooltip = "Lock aim untuk item Pistol",
    Default = false,
    Callback = function(Value)
        AimConfig.LockAim = Value
    end,
})
    PistolGroup:AddToggle("WallCheckToggle", {
        Text = "Wallcheck",
        Default = false,
        Callback = function(Value)
            wallcheckEnabled = Value
        end,
    })
    PistolGroup:AddToggle("LaserToggle", {
        Text = "Enable Laser Effect",
        Default = true,
        Callback = function(Value)
            laserEnabled = Value
            if not Value then clearLaser() end
        end
    })

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if not IsToFSilentOn() then return end

    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        -- V1: hold RMB = aim
        if silentAimToFV1 then
            isAiming = true
        end
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
        if silentAimToFV2 then
            -- V2: tap LMB langsung tembak
            isAiming = true
            doShoot()
        elseif silentAimToFV1 then
            -- V1: LMB cuma tembak kalau lagi hold RMB
            doShoot()
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        if silentAimToFV1 then
            isAiming = false
            if LaserBeam then LaserBeam.Transparency = 1 end
        end
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
        if silentAimToFV2 then
            isAiming = false
            if LaserBeam then LaserBeam.Transparency = 1 end
        end
    end
end)

    function setupMobileButton()
        local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not playerGui then return end
        local survivorMob = playerGui:FindFirstChild("Survivor-mob")
        if not survivorMob then
            playerGui.ChildAdded:Connect(function(child)
                if child.Name == "Survivor-mob" then task.wait(0.2) setupMobileButton() end
            end)
            return
        end
        local controls = survivorMob:FindFirstChild("Controls")
        if not controls then
            survivorMob.ChildAdded:Connect(function(child)
                if child.Name == "Controls" then task.wait(0.2) setupMobileButton() end
            end)
            return
        end
        local guiMobButton = controls:FindFirstChild("Gui-mob")
        if not guiMobButton then return end

        guiMobButton.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType ~= Enum.UserInputType.Touch
    and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
        return
    end
    if not IsToFSilentOn() then return end

    if silentAimToFV2 then
        -- V2: tap = langsung tembak
        isAiming = true
        doShoot()
    elseif silentAimToFV1 then
        -- V1: hold = aim saja
        isAiming = true
    end
end)

guiMobButton.InputEnded:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.Touch
    and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
        return
    end
    if not IsToFSilentOn() then return end

    if silentAimToFV1 then
        -- V1: lepas = tembak
        doShoot()
    end
    -- V2: sudah tembak di Began, di sini cuma stop aim
    isAiming = false
    if LaserBeam then LaserBeam.Transparency = 1 end
end)
end

    task.wait(0.5)
    setupMobileButton()

    task.wait(0.5)
    setupMobileButton()

    LocalPlayer.CharacterAdded:Connect(function()
        clearLaser()
        velocityCache = {}
        SCPCache = {}
        SCPCacheTimer = 0
        isAiming = false

        task.wait(1)
        setupMobileButton()

          if IsToFSilentOn() then
            stopConnection()
            startConnection()
            createTargetSelectorUI()
        end
    end)
    
    PlayerGui.ChildRemoved:Connect(function(child)
        if not IsToFSilentOn() then return end
        task.wait(0.5)
        if not IsToFSilentOn() then return end

        if child.Name == "ToFTargetSelector" then
            createTargetSelectorUI()
        end
    end)
end

local SurvivorMainGroup = TabsUI.Survivor:AddRightGroupbox("Aimbot Survivor", "target")

SurvivorMainGroup:AddToggle("Surv_Aimbot_Enabled", { Text = "Enable Aimbot", Default = false, Callback = function(Value) Config.Surv_Aimbot_Enabled = Value end })
SurvivorMainGroup:AddCheckbox("Surv_Aimbot_ShowFOV", { Text = "Show FOV Circle", Default = true, Callback = function(Value) Config.Surv_Aimbot_ShowFOV = Value end })
SurvivorMainGroup:AddSlider("Surv_Aimbot_Radius", { Text = "FOV Circle Radius", Min = 50, Max = 500, Default = 150, Rounding = 0, Callback = function(Value) Config.Surv_Aimbot_Radius = Value end })
SurvivorMainGroup:AddSlider("Surv_Aimbot_MaxDist", { Text = "Max Distance", Min = 50, Max = 1000, Default = 300, Rounding = 0, Callback = function(Value) Config.Surv_Aimbot_MaxDist = Value end })
SurvivorMainGroup:AddSlider("Surv_Aimbot_Smoothness", { Text = "Aimbot Smoothness", Min = 1, Max = 10, Default = 5, Rounding = 1, Callback = function(Value) Config.Surv_Aimbot_Smoothness = Value / 10 end })
SurvivorMainGroup:AddInput("Surv_Aimbot_Predict", { Text = "Predict Aim Offset", Default = "0.01", Numeric = true, Placeholder = "misal: 0.05", Callback = function(Value) local num = tonumber(Value); if num then Config.Surv_Aimbot_Predict = num end end })

-- Camera Settings
local CameraGroup = TabsUI.Survivor:AddRightGroupbox("Camera Settings", "camera")

CameraGroup:AddToggle("InfinityZoom", {
    Text = "Infinity Zoom Out",
    Tooltip = "Zoom Out tanpa batas",
    Default = false,
    Callback = function(Value)
        if Value then
            player.CameraMaxZoomDistance = math.huge
            player.CameraMinZoomDistance = 0
        else
            player.CameraMaxZoomDistance = 12
            player.CameraMinZoomDistance = 0.5
        end
    end,
})

CameraGroup:AddToggle("CameraFOV", {
    Text = "Camera FOV",
    Tooltip = "Atur jarak pandang kamera",
    Default = false,
    Callback = function(Value)
        FOVEnabled = Value
        local cam = workspace.CurrentCamera
        if cam then
            if Value then
                cam.FieldOfView = TargetFOV
            else
                cam.FieldOfView = 70
            end
        end
    end,
})

CameraGroup:AddSlider("FOVValue", {
    Text = "FOV Value",
    Default = 90,
    Min = 60,
    Max = 120,
    Rounding = 0,
    Callback = function(Value)
        TargetFOV = Value
        if FOVEnabled then
            local cam = workspace.CurrentCamera
            if cam then
                cam.FieldOfView = Value
            end
        end
    end,
})

-- ==================== TAB KILLER ====================
local KillerCombatGroup = TabsUI.Killer:AddLeftGroupbox("Ability", "swords")

KillerCombatGroup:AddToggle("Killer_Aimbot_Enabled", { Text = "Enable Aimbot", Default = false, Callback = function(Value) Config.Killer_Aimbot_Enabled = Value end })
KillerCombatGroup:AddSlider("Killer_Aimbot_MaxDist", { Text = "Melee Lock Distance", Min = 5, Max = 30, Default = 12, Rounding = 0, Callback = function(Value) Config.Killer_Aimbot_MaxDist = Value end })
KillerCombatGroup:AddSlider("Killer_Aimbot_Smoothness", { Text = "Aimbot Smoothness", Min = 1, Max = 10, Default = 5, Rounding = 1, Callback = function(Value) Config.Killer_Aimbot_Smoothness = Value / 10 end })

KillerCombatGroup:AddToggle("AntiAutoParry", {
    Text = "Counter Auto Parry",
    Tooltip = "Memainkan animasi random buat ngelabui auto parry",
    Default = false,
    Callback = function(Value)
        AntiAutoParryEnabled = Value
        Library:Notify({ 
            Title = "Anti Auto Parry", 
            Description = Value and "AKTIF!" or "NONAKTIF", 
            Time = 2 
        })
    end,
}):AddKeyPicker("AntiAutoParryKey", {
    Default = "None",
    Text = "Toggle Anti Auto Parry",
    Mode = "Toggle",
    Callback = function(Value)
        AntiAutoParryEnabled = Value
    end,
})

KillerCombatGroup:AddToggle("AntiBlindToggle", {
    Text = "Anti Blind (Flashlight)",
    Tooltip = "Mencegah killer terkena blind dari senter survivor",
    Default = false,
    Callback = function(Value)
        Killer.AntiBlind = Value
        if Value then
            Library:Notify({ 
                Title = "Anti Blind", 
                Description = "Aktif - Immune dari flashlight", 
                Time = 3 
            })
        else
            Library:Notify({ 
                Title = "Anti Blind", 
                Description = "Nonaktif", 
                Time = 2 
            })
        end
    end
})

KillerCombatGroup:AddToggle("NoSlowdown", {
    Text = "No Slowdown killer",
    Tooltip = "Hilangkan slowdown saat menyerang (Killer Only)",
    Default = false,
    Callback = function(Value)
        NoSlowdownEnabled = Value
        if Value then
            Library:Notify({ 
                Title = "No Slowdown", 
                Description = "AKTIF - WalkSpeed dikunci", 
                Time = 3 
            })
        else
            Library:Notify({ 
                Title = "No Slowdown", 
                Description = "DIMATIKAN", 
                Time = 2 
            })
        end
    end,
}):AddKeyPicker("NoSlowdownKey", {
    Default = "None",
    Text = "No Slowdown Keybind",
    Mode = "Toggle",
    Callback = function(Value)
        NoSlowdownEnabled = Value
    end,
})

KillerCombatGroup:AddToggle("InfiniteLunge", {
    Text = "Infinite Lunge",
    Tooltip = "Lunge tanpa batas (Killer Only)",
    Default = false,
    Callback = function(Value)
        if Value then
            EnableInfiniteLunge()
        else
            DisableInfiniteLunge()
        end
    end,
}):AddKeyPicker("InfiniteLungeKey", {
    Default = "F9",
    Text = "Infinite Lunge Key",
    Mode = "Toggle",
    Callback = function(Value)
        if Value then
            EnableInfiniteLunge()
        else
            DisableInfiniteLunge()
        end
    end,
})


KillerCombatGroup:AddToggle("BypassLeapCooldown", {
    Text = "Skill Hidden No CD", Default = false,
    Callback = function(v)
        Killer.BypassLeap = v
        if v then StartLeapBypass() end
    end
})

KillerCombatGroup:AddToggle("InfFrenzy", {
    Text = "Infinite Frenzy (Jeff)",
    Tooltip = "Frenzy tanpa cooldown / unlimited",
    Default = false,
    Callback = function(Value)
        VD.KILLER_InfFrenzy = Value
        if Value then
            pcall(NEX_StartJeffCooldownBypass)
            Library:Notify({ Title = "Infinite Frenzy", Description = "AKTIF", Time = 2 })
        else
            pcall(NEX_StopJeffCooldownBypass)
            Library:Notify({ Title = "Infinite Frenzy", Description = "NONAKTIF", Time = 2 })
        end
    end
}):AddKeyPicker("InfFrenzyKey", {
    Default = "None",
    Text = "Infinite Frenzy Key",
    Mode = "Toggle",
    Callback = function(Value)
        VD.KILLER_InfFrenzy = Value
        if Value then
            pcall(NEX_StartJeffCooldownBypass)
        else
            pcall(NEX_StopJeffCooldownBypass)
        end
        if Toggles.InfFrenzy then
            Toggles.InfFrenzy:SetValue(Value)
        end
    end
})

-- ===== INFINITE PURSUIT JASON =====
KillerCombatGroup:AddToggle("InfPursuitJason", {
    Text = "Infinite Pursuit (Jason)",
    Tooltip = "Pursuit tanpa cooldown / unlimited",
    Default = false,
    Callback = function(Value)
        VD.KILLER_InfPursuit = Value
        if Value then
            NEX_StartJasonPursuitBypass()
            Library:Notify({ Title = "Infinite Pursuit", Description = "AKTIF!", Time = 2 })
        else
            NEX_StopJasonPursuitBypass()
            Library:Notify({ Title = "Infinite Pursuit", Description = "NONAKTIF!", Time = 2 })
        end
    end
}):AddKeyPicker("InfPursuitJasonKey", {
    Default = "None",
    Text = "Infinite Pursuit Key",
    Mode = "Toggle",
    Callback = function(Value)
        VD.KILLER_InfPursuit = Value
        if Value then
            NEX_StartJasonPursuitBypass()
        else
            NEX_StopJasonPursuitBypass()
        end
        if Toggles.InfPursuitJason then
            Toggles.InfPursuitJason:SetValue(Value)
        end
    end
})

KillerCombatGroup:AddToggle("AutoStalk", {
    Text = "Auto Stalk", Default = false,
    Callback = function(v)
        AutoStalk.Enabled = v
        if v then startAutoStalk() else stopAutoStalk() end
    end
})

KillerCombatGroup:AddToggle("Killer_InfAbyssal", { 
        Text = "Infinite corrupt Abyssal", 
        Default = false, 
        Callback = function(Value) 
            Config.Killer_InfAbyssal = Value 
        end 
    })
    
    KillerCombatGroup:AddButton({
    Text = "Aim Lock Hidden",
    Func = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://pastefy.app/2MD1ZoBY/raw"))()
        end)
        if success then
            Library:Notify({ Title = "Aim Lock", Description = "Aim Lock berhasil dimuat!", Time = 3 })
        else
            Library:Notify({ Title = "Error", Description = "Gagal memuat Aim Lock!", Time = 3 })
        end
    end
})

KillerCombatGroup:AddButton({
    Text = "Aim Lock Toggle",
    Func = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://pastefy.app/5zsm8N7G/raw"))()
        end)
        if success then
            Library:Notify({ Title = "Aim Lock", Description = "Aim Lock berhasil dimuat!", Time = 3 })
        else
            Library:Notify({ Title = "Error", Description = "Gagal memuat Aim Lock!", Time = 3 })
        end
    end
})

KillerCombatGroup:AddButton({
    Text = "Open Mask Selector GUI",
    Func = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://pastefy.app/nJrAelfC/raw"))()
        end)
        if success then
            Library:Notify({ Title = "Mask Selector", Description = "GUI Mask Selector berhasil dimuat!", Time = 3 })
        else
            Library:Notify({ Title = "Error", Description = "Gagal memuat Mask Selector!", Time = 3 })
        end
    end
})

local VeilGroup = TabsUI.Killer:AddRightGroupbox("Silent Aim (Veil Spear)", "arrow-right")

VeilGroup:AddToggle("SilentAimVeil", {
    Text = "Silent Veil V1",
    Default = false,
    Callback = function(Value)
        AimConfig.Aim_SilentVeil = Value
    end,
}):AddKeyPicker("SilentAimVeilKey", {
    Default = "None",
    Text = "Veil Aim Key",
    Mode = "Toggle",
    Callback = function(Value)
        AimConfig.Aim_SilentVeil = Value
    end,
})

VeilGroup:AddToggle("SilentAimVeilV2", {
    Text = "Silent Veil V2",
    Default = false,
    Callback = function(Value)
        AimConfig.Aim_SilentVeilV2 = Value
        Library:Notify({
            Title = "Silent Veil V2",
            Description = Value and "ON (No Double)" or "OFF",
            Time = 2
        })
    end,
}):AddKeyPicker("SilentAimVeilV2Key", {
    Default = "None",
    Text = "Veil V2 Key",
    Mode = "Toggle",
    Callback = function(Value)
        AimConfig.Aim_SilentVeilV2 = Value
        if Toggles.SilentAimVeilV2 then
            Toggles.SilentAimVeilV2:SetValue(Value)
        end
    end,
})

VeilGroup:AddToggle("PAimVeil", {
    Text = "Auto Predict",
    Default = false,
    Callback = function(Value)
        Config.SpearSmart_enable = Value
    end,
}):AddKeyPicker("SilentAimVeilKey", {
    Default = "None",
    Text = "Veil Aim Key",
    Mode = "Toggle",
    Callback = function(Value)
        AimConfig.Aim_SilentVeil = Value
    end,
})

VeilGroup:AddSlider("Veil_LeadMultiplier", {
    Text = "Lead Multiplier",
    Tooltip = "Semakin tinggi, semakin agresif prediksi gerakan target",
    Min = 0.5,
    Max = 5,
    Default = 1.4,
    Rounding = 1,
    Callback = function(Value)
        AimConfig.Veil_LeadMultiplier = Value
    end,
})

VeilGroup:AddSlider("Veil_SpearSpeed", { Text = "Spear Speed", Min = 50, Max = 200, Default = 165, Rounding = 0, Callback = function(Value) AimConfig.SPEAR_Speed = Value end })
VeilGroup:AddSlider("Veil_SpearGravity", { Text = "Spear Gravity", Min = 0, Max = 200, Default = 103, Rounding = 0, Callback = function(Value) AimConfig.SPEAR_Gravity = Value end })

VeilGroup:AddToggle("VeilTracker", {
    Text = "ESP Tracker Target",
    Default = false,
    Callback = function(Value)
        VeilTrackerEnabled = Value
        if not Value then
            VeilTrackerLine.Visible = false
            if currentVeilBillboard then
                currentVeilBillboard:Destroy()
                currentVeilBillboard = nil
            end
        end
    end,
})


VeilGroup:AddToggle("VeilShowFOV", {
    Text = "Show Veil FOV",
    Default = true,
    Callback = function(Value)
        AimConfig.Veil_ShowFOV = Value
    end,
})

VeilGroup:AddSlider("VeilFOV", {
    Text = "Veil FOV Radius",
    Default = 150,
    Min = 50,
    Max = 500,
    Rounding = 0,
    Callback = function(Value)
        AimConfig.Veil_FOV = Value
    end,
})
       

local FlaskGroup = TabsUI.Killer:AddRightGroupbox("Silent Aim Flask (Cure)", "arrow-right")

-- Toggle Silent Aim Flask + Key Picker
FlaskGroup:AddToggle("AimFlask", {
    Text = "Silent Aim Flask (Cure)",
    Default = false,
    Callback = function(v)
        VD.KILLER_SilentAimFlask = v
        Library:Notify({ 
            Title = "Silent Aim Flask", 
            Description = v and "AKTIF" or "NONAKTIF", 
            Time = 2 
        })
    end
}):AddKeyPicker("AimFlaskKey", {
    Default = "None",
    Text = "Silent Aim Flask Key",
    Mode = "Toggle",
    Callback = function(Value)
        VD.KILLER_SilentAimFlask = Value
        if Toggles.AimFlask then
            Toggles.AimFlask:SetValue(Value)
        end
        Library:Notify({ 
            Title = "Silent Aim Flask", 
            Description = Value and "AKTIF" or "NONAKTIF", 
            Time = 2 
        })
    end
})

-- Toggle Flask Laser + Key Picker
FlaskGroup:AddToggle("Laser", {
    Text = "Enable Laser",
    Tooltip = "Muncul saat tombol flask di-hold",
    Default = false,
    Callback = function(v)
        VD.KILLER_FlaskLaser = v
        if v then
            pcall(NEX_StartCureFlaskLaser)
            Library:Notify({ Title = "Flask Laser", Description = "AKTIF - Laser merah", Time = 2 })
        else
            if getgenv().NEX_CureFlaskLaserThread then
                getgenv().NEX_CureFlaskLaserThread:Disconnect()
                getgenv().NEX_CureFlaskLaserThread = nil
            end
            if getgenv().NEX_CureFlaskLaserPart then
                pcall(function() getgenv().NEX_CureFlaskLaserPart:Destroy() end)
                getgenv().NEX_CureFlaskLaserPart = nil
            end
            Library:Notify({ Title = "Flask Laser", Description = "NONAKTIF", Time = 2 })
        end
    end
})

local AntiilopGroup = TabsUI.Killer:AddRightGroupbox("Anti Looping", "skull")   
    AntiilopGroup:AddToggle("AntiLooping", {
    Text = "Block Vault & Pallets",
        Default = false,
        Keybind = true,
        Callback = function(v)
            _G.BlockPalletEnabled = v

            if not v then
                local VaultCompleteEvent = game:GetService("ReplicatedStorage").Remotes.Window.VaultCompleteEvent
                local PalletCompleteEvent = game:GetService("ReplicatedStorage").Remotes.Pallet.PalletSlideCompleteEvent
                local map = workspace:FindFirstChild("Map")
                if map then
                    for _, obj in pairs(map:GetDescendants()) do
                        if obj.Name == "VaultPointInUse" then
                            pcall(function() VaultCompleteEvent:FireServer(obj.Parent, false) end)
                        elseif obj.Name == "PalletPointSlideInUse" then
                            pcall(function() PalletCompleteEvent:FireServer(obj.Parent, false) end)
                        end
                    end
                end
                return
            end

            local VaultEvent = game:GetService("ReplicatedStorage").Remotes.Window.VaultEvent
            local PalletEvent = game:GetService("ReplicatedStorage").Remotes.Pallet.PalletSlideEvent

            local map = workspace:FindFirstChild("Map")
            if map then
                for _, trigger in pairs(map:GetDescendants()) do
                    if trigger.Name == "VaultTrigger" then
                        pcall(function() VaultEvent:FireServer(trigger, true) end)
                    end
                    if trigger.Name == "PalletPointSlide" and trigger:IsA("BasePart") then
                        pcall(function() PalletEvent:FireServer(trigger, true) end)
                    end
                end
            end

            task.spawn(function()
                local map = workspace:FindFirstChild("Map")
                if not map then return end

                local connections = {}

                function watchPallet(obj)
                    if obj:IsA("BasePart") and obj.Name == "PalletPoint" then
                        local conn = obj:GetPropertyChangedSignal("Name"):Connect(function()
                            if not _G.BlockPalletEnabled then return end
                            if obj.Name == "PalletPointSlide" then
                                task.wait(0.1)
                                pcall(function()
                                    PalletEvent:FireServer(obj, true)
                                end)
                            end
                        end)
                        table.insert(connections, conn)
                    end
                end

                for _, obj in pairs(map:GetDescendants()) do
                    watchPallet(obj)
                end

                local addConn = map.DescendantAdded:Connect(function(obj)
                    watchPallet(obj)
                end)
                table.insert(connections, addConn)

                while _G.BlockPalletEnabled do task.wait(0.5) end
                for _, c in pairs(connections) do c:Disconnect() end
                connections = {}
            end)

            Library:Notify({ Title = "Anti Looping", Description = "✅ Aktif!", Time = 2 })
        end,
}):AddKeyPicker("AntiLoopingKey", {
    Default = "None",
    Text = "Keybind Block Vault & Pallets",
    Mode = "Toggle",
    Callback = function(Value)
        Toggles.AntiLooping:SetValue(Value)
    end,
})

local KillerCamGroup = TabsUI.Killer:AddRightGroupbox("Camera Setting", "camera")

KillerCamGroup:AddToggle("KillerThirdPerson", {
    Text = "Third Person (Killer)",
    Tooltip = "Mengubah posisi kamera ke belakang karakter",
    Default = false,
    Callback = function(Value)
        local isPlayerKiller = (player.Team and player.Team.Name == "Killer")
        
        if Value and not isPlayerKiller then
            Library:Notify({ Title = "Akses Ditolak", Description = "Fitur ini khusus Killer!", Time = 3 })
            return
        end

        Config.Killer_3rdPerson = Value
        
        -- Matikan fitur
        if not Value then
            if State.ThirdPersonConn then
                State.ThirdPersonConn:Disconnect()
                State.ThirdPersonConn = nil
            end
            
            -- Reset kamera
            if isPlayerKiller then
                player.CameraMode = Enum.CameraMode.LockFirstPerson
                player.CameraMinZoomDistance = 0.5
                player.CameraMaxZoomDistance = 0.5
            else
                player.CameraMode = Enum.CameraMode.Classic
                player.CameraMinZoomDistance = 0.5
                player.CameraMaxZoomDistance = 128
            end
            
            -- Reset transparency semua objek
            ResetAllTransparency()
            
            -- Reset transparency karakter
            if player.Character then
                ResetCharacterTransparency(false) -- false = reset ke normal
            end
        else
            -- Aktifkan fitur
            player.CameraMode = Enum.CameraMode.Classic
            player.CameraMinZoomDistance = 7
            player.CameraMaxZoomDistance = 128
            
            -- Hapus koneksi lama jika ada
            if State.ThirdPersonConn then
                State.ThirdPersonConn:Disconnect()
                State.ThirdPersonConn = nil
            end
            
            State.ThirdPersonConn = RunService.RenderStepped:Connect(function()
                if not Config.Killer_3rdPerson then return end
                
                -- Cek kembali apakah masih Killer
                if player.Team and player.Team.Name ~= "Killer" then
                    -- Matikan fitur otomatis jika bukan Killer
                    Config.Killer_3rdPerson = false
                    if State.ThirdPersonConn then
                        State.ThirdPersonConn:Disconnect()
                        State.ThirdPersonConn = nil
                    end
                    return
                end
                
                -- Set kamera setiap frame
                player.CameraMode = Enum.CameraMode.Classic
                player.CameraMinZoomDistance = 7
                player.CameraMaxZoomDistance = 128
                
                -- Set transparency untuk semua objek selain karakter player
                SetWorldTransparency(1) -- 1 = transparan
                
                -- Set transparency untuk karakter player (visible)
                if player.Character then
                    SetCharacterTransparency(player.Character, 0) -- 0 = visible
                end
            end)
        end
    end,
})

-- Fungsi helper untuk reset semua transparency
function ResetAllTransparency()
    for _, obj in pairs(Camera:GetChildren()) do
        if obj ~= player.Character then
            for _, part in pairs(obj:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    pcall(function()
                        part.LocalTransparencyModifier = 0
                        part.Transparency = 0
                    end)
                end
            end
        end
    end
end

-- Fungsi helper untuk set transparency dunia
function SetWorldTransparency(transparency)
    for _, obj in pairs(Camera:GetChildren()) do
        if obj ~= player.Character then
            for _, part in pairs(obj:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    pcall(function()
                        part.LocalTransparencyModifier = transparency
                        part.Transparency = transparency
                    end)
                end
            end
        end
    end
end

-- Fungsi helper untuk set transparency karakter
function SetCharacterTransparency(character, transparency)
    if not character then return end
    
    for _, obj in pairs(character:GetChildren()) do
        -- Handle Hat
        if obj.Name == "Hat" then
            for _, child in pairs(obj:GetDescendants()) do
                if child:IsA("BasePart") or child:IsA("Decal") then
                    pcall(function()
                        child.LocalTransparencyModifier = transparency
                        child.Transparency = transparency
                    end)
                end
            end
        end
        
        -- Handle Arm parts
        if obj:IsA("BasePart") and armParts and armParts[obj.Name] then
            pcall(function()
                obj.LocalTransparencyModifier = transparency
                obj.Transparency = transparency
            end)
        end
        
        -- Handle Weapon
        if isWeapon and isWeapon(obj) then
            local descendants = obj:IsA("BasePart") and {obj} or obj:GetDescendants()
            for _, child in pairs(descendants) do
                if child:IsA("BasePart") or child:IsA("Decal") then
                    pcall(function()
                        child.LocalTransparencyModifier = transparency
                        child.Transparency = transparency
                    end)
                end
            end
        end
    end
end

-- Fungsi helper untuk reset karakter
function ResetCharacterTransparency(isKiller)
    if not player.Character then return end
    
    local transparency = 0 -- Default visible
    if isKiller then
        -- Untuk killer, beberapa part tetap transparan
        for _, obj in pairs(player.Character:GetChildren()) do
            if obj.Name == "Hat" then
                for _, child in pairs(obj:GetDescendants()) do
                    if child:IsA("BasePart") or child:IsA("Decal") then
                        pcall(function()
                            child.LocalTransparencyModifier = 1
                            child.Transparency = 1
                        end)
                    end
                end
            end
            if obj:IsA("BasePart") and armParts and armParts[obj.Name] then
                pcall(function()
                    obj.LocalTransparencyModifier = 1
                    obj.Transparency = 1
                end)
            end
            if isWeapon and isWeapon(obj) then
                local descendants = obj:IsA("BasePart") and {obj} or obj:GetDescendants()
                for _, child in pairs(descendants) do
                    if child:IsA("BasePart") or child:IsA("Decal") then
                        pcall(function()
                            child.LocalTransparencyModifier = 1
                            child.Transparency = 1
                        end)
                    end
                end
            end
        end
    else
        -- Reset semua ke visible
        SetCharacterTransparency(player.Character, 0)
    end
end

-- ==================== TAB ESP ====================
local EspGroup = TabsUI.Esp:AddLeftGroupbox("ESP Players", "user")

EspGroup:AddToggle("ESP_Master", { 
    Text = "Enable Esp", Default = false, 
    Callback = function(Value) 
        Config.ESP_Master = Value
        if Value then 
            ForceRefreshMap()
        else 
            ClearAllESP() 
        end 
    end 
})

EspGroup:AddCheckbox("ESP_Player", { Text = "Player", Default = false, Callback = function(Value) Config.ESP_Player = Value; if Config.ESP_Master then if not Value then ClearESP("Player") else ScanMap() end end end }):AddColorPicker("Color_Player", { Default = Tuning.Colors.Player, Title = "Player Color", Callback = function(Value) Tuning.Colors.Player = Value end })

EspGroup:AddCheckbox("ESP_Killer", { Text = "Killer", Default = false, Callback = function(Value) Config.ESP_Killer = Value; if Config.ESP_Master then if not Value then ClearESP("Killer") else ScanMap() end end end }):AddColorPicker("Color_Killer", { Default = Tuning.Colors.Killer, Title = "Killer Color", Callback = function(Value) Tuning.Colors.Killer = Value end })

EspGroup:AddCheckbox("ESP_Outline", { Text = "Mode Outline (Fill transparan)", Default = false, Callback = function(Value) Config.ESP_Outline = Value end })

EspGroup:AddCheckbox("HookESP", {
    Text = "Show Hook Count",
    Tooltip = "Tampilkan jumlah hook di ATAS kepala survivor",
    Default = false,
    Callback = function(Value)
        HookESPEnabled = Value
        if Value then
            UpdateHookData()
            Library:Notify({ 
                Title = "Hook ESP", 
                Description = "Aktif", 
                Time = 2 
            })
        else
            ClearHookESP()
            Library:Notify({ 
                Title = "Hook ESP", 
                Description = "Nonaktif", 
                Time = 2 
            })
        end
    end
})

EspGroup:AddCheckbox("ESP_Name", { 
    Text = "Esp Name", Default = false, 
    Callback = function(Value) 
        Config.ESP_Name = Value; if Value then ScanMap() else ClearAllESP() end 
    end 
})

EspGroup:AddCheckbox("ESP_Distance", { 
    Text = "Esp Distance", Default = false, 
    Callback = function(Value) 
        Config.ESP_Distance = Value
        if Config.ESP_Master then UpdatePlayerESP() end
    end 
})

EspGroup:AddCheckbox("ESP_SCP", { Text = "SCP / Zombie", Default = false, Callback = function(Value) Config.ESP_SCP = Value; if Config.ESP_Master then if not Value then ClearESP("SCP") else ScanMap() end end end }):AddColorPicker("Color_SCP", { Default = Tuning.Colors.SCP, Title = "SCP Color", Callback = function(Value) Tuning.Colors.SCP = Value end })

EspGroup:AddCheckbox("ESP_ItemIcon", { 
    Text = "Esp Item Icon", Default = false, 
    Callback = function(Value) 
        Config.ESP_ItemIcon = Value
        if Config.ESP_Master then UpdatePlayerESP() end
    end 
})

EspGroup:AddCheckbox("ESP_KillerWarn", { 
    Text = "Killer Warn", Default = false, 
    Callback = function(Value) 
        Config.ESP_KillerWarn = Value 
        if not Value then
            local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if myHRP and myHRP:FindFirstChild("KillerWarn") then
                myHRP.KillerWarn:Destroy()
            end
        end
    end 
})

local EspColorGroup = TabsUI.Esp:AddLeftGroupbox("ESP Maps", "map")

EspColorGroup:AddCheckbox("ESP_Generator", { Text = "Generator", Default = false, Callback = function(Value) Config.ESP_Generator = Value; if Config.ESP_Master then if not Value then ClearESP("Generator") else ScanMap() end end end }):AddColorPicker("Color_Generator", { Default = Tuning.Colors.Generator, Title = "Generator Color", Callback = function(Value) Tuning.Colors.Generator = Value end })

EspColorGroup:AddCheckbox("ESP_GeneratorName", { 
    Text = "Gen Name & Progress", 
    Default = true, 
    Callback = function(Value) 
        Config.ESP_GeneratorName = Value
        if Config.ESP_Master then 
            ScanMap() 
        end 
    end 
})

EspColorGroup:AddCheckbox("ESP_Pallet", { Text = "Pallet", Default = false, Callback = function(Value) Config.ESP_Pallet = Value; if Config.ESP_Master then if not Value then ClearESP("Pallet") else ScanMap() end end end }):AddColorPicker("Color_Pallet", { Default = Tuning.Colors.Pallet, Title = "Pallet Color", Callback = function(Value) Tuning.Colors.Pallet = Value end })

EspColorGroup:AddCheckbox("ESP_Window", { Text = "Window / Vault", Default = false, Callback = function(Value) Config.ESP_Window = Value; if Config.ESP_Master then if not Value then ClearESP("Window") else ScanMap() end end end }):AddColorPicker("Color_Window", { Default = Tuning.Colors.Window, Title = "Window Color", Callback = function(Value) Tuning.Colors.Window = Value end })

EspColorGroup:AddCheckbox("ESP_Hook", { Text = "Hook", Default = false, Callback = function(Value) Config.ESP_Hook = Value; if Config.ESP_Master then if not Value then ClearESP("Hook") else ScanMap() end end end }):AddColorPicker("Color_Hook", { Default = Tuning.Colors.Hook, Title = "Hook Color", Callback = function(Value) Tuning.Colors.Hook = Value end })

EspColorGroup:AddCheckbox("ESP_Gate", { Text = "Exit Gate", Default = false, Callback = function(Value) Config.ESP_Gate = Value; if Config.ESP_Master then if not Value then ClearESP("Gate") else ScanMap() end end end }):AddColorPicker("Color_Gate", { Default = Tuning.Colors.Gate, Title = "Gate Color", Callback = function(Value) Tuning.Colors.Gate = Value end })

-- ==================== NEXT KILLER DISPLAY ====================
local nextKillerEnabled = false
local IndicatorGui = nil

function SetupNextKillerIndicator()
    if IndicatorGui then IndicatorGui:Destroy() end
    IndicatorGui = Instance.new("ScreenGui")
    IndicatorGui.Name = "NextKillerIndicator"
    IndicatorGui.ResetOnSpawn = false
    IndicatorGui.Parent = player:WaitForChild("PlayerGui")
end

function StartNextKiller()
    if IndicatorGui then return end
    SetupNextKillerIndicator()

    task.spawn(function()
        while nextKillerEnabled and IndicatorGui do
            local label = IndicatorGui:FindFirstChild("NextKillerDisplay")
            if not label then
                label = Instance.new("TextLabel")
                label.Name = "NextKillerDisplay"
                label.Size = UDim2.new(0, 150, 0, 22)
                label.Position = UDim2.new(0.5, 0, 0, 10)
                label.AnchorPoint = Vector2.new(0.5, 0)
                label.BackgroundTransparency = 0.15
                label.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
                label.TextColor3 = Color3.fromRGB(220, 220, 230)
                label.Font = Enum.Font.GothamMedium
                label.TextSize = 11
                label.RichText = true
                label.Parent = IndicatorGui

                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 6)
                corner.Parent = label

                local stroke = Instance.new("UIStroke")
                stroke.Thickness = 1
                stroke.Color = Color3.fromRGB(60, 60, 70)
                stroke.Transparency = 0.3
                stroke.Parent = label
            end

            local playersList = Players:GetPlayers()
            table.sort(playersList, function(a, b)
                local aAllow = a:GetAttribute("AllowKiller") or false
                local bAllow = b:GetAttribute("AllowKiller") or false
                if aAllow ~= bAllow then return aAllow end
                return (a:GetAttribute("KillerChance") or 0) > (b:GetAttribute("KillerChance") or 0)
            end)

            local nextKiller = playersList[1]
            if nextKiller then
                local name = (nextKiller == player) and "<font color='#ff5555'>KAMU</font>" or nextKiller.Name
                label.Text = "Next Killer: " .. name
            else
                label.Text = "Next Killer: <font color='#888888'>Waiting...</font>"
            end

            task.wait(1.5)
        end
    end)
end

function StopNextKiller()
    if IndicatorGui then
        IndicatorGui:Destroy()
        IndicatorGui = nil
    end
end

-- ==================== TOGGLE DI ESP TAB ====================
local NextKillerGroup = TabsUI.Esp:AddRightGroupbox("Info Player", "info")

local DraggableLabel = Library:AddDraggableLabel("Pandu Hub")
WatermarkEnabled = false
WatermarkConnection = nil

function StartWatermark()
    if WatermarkConnection then 
        WatermarkConnection:Disconnect() 
        WatermarkConnection = nil
    end
    
    if not DraggableLabel then return end

    local FrameTimer = tick()
    local FrameCounter = 0
    local FPS = 60

    WatermarkConnection = game:GetService('RunService').Heartbeat:Connect(function()
        if not WatermarkEnabled then
            if WatermarkConnection then
                WatermarkConnection:Disconnect()
                WatermarkConnection = nil
            end
            if DraggableLabel then
                DraggableLabel:SetVisible(false)
            end
            return
        end
        
        FrameCounter = FrameCounter + 1

        if (tick() - FrameTimer) >= 1 then
            FPS = FrameCounter
            FrameTimer = tick()
            FrameCounter = 0
        end

        local ping = math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue() or 0)
        DraggableLabel:SetText(('Pandu | %s fps | %s ms'):format(math.floor(FPS), ping))
        DraggableLabel:SetVisible(true)
    end)
end

function StopWatermark()
    WatermarkEnabled = false
    
    if WatermarkConnection then
        WatermarkConnection:Disconnect()
        WatermarkConnection = nil
    end
    
    if DraggableLabel then
        DraggableLabel:SetVisible(false)
    end
end

NextKillerGroup:AddToggle("WatermarkToggle", {
    Text = "Enable FPS + Ping Display",
    Default = false,
    Tooltip = "Tampilkan FPS dan Ping",
    Callback = function(Value)
        WatermarkEnabled = Value
        if Value then
            StartWatermark()
            Library:Notify({ Title = "Watermark", Description = "AKTIF", Time = 2 })
        else
            StopWatermark()
            Library:Notify({ Title = "Watermark", Description = "NONAKTIF", Time = 2 })
        end
    end
})

task.spawn(function()
    task.wait(0.5)
    StopWatermark()
end)

NextKillerGroup:AddToggle("NextKillerToggle", {
    Text = "Next Killer Display",
    Default = false,
    Tooltip = "Menampilkan prediksi killer selanjutnya di layar",
    Callback = function(Value)
        nextKillerEnabled = Value
        if Value then
            StartNextKiller()
        else
            StopNextKiller()
        end
    end
})

NextKillerGroup:AddToggle("NextMapToggle", {
    Text = "Next Map Prediction",
    Default = false,
    Tooltip = "Menampilkan prediksi map selanjutnya di detik 00.15",
    Callback = function(v)
        getgenv().MapPredictEnabled = v

        local CoreGui = game:GetService("CoreGui")

        function cleanMapGui()
            if CoreGui:FindFirstChild("MapPredictUI") then
                CoreGui.MapPredictUI:Destroy()
            end
        end

        function buildMapGui()
    if CoreGui:FindFirstChild("MapPredictUI") then return CoreGui.MapPredictUI end

    local gui = Instance.new("ScreenGui")
    gui.Name = "MapPredictUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = CoreGui

    local frame = Instance.new("Frame", gui)
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 200, 0, 32)
    frame.Position = UDim2.new(0.5, 0, 0, 108)
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    frame.BackgroundTransparency = 0.35
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(0, 180, 255)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.4

    local badge = Instance.new("TextLabel", frame)
    badge.Name = "Badge"
    badge.Size = UDim2.new(0, 30, 0, 12)
    badge.Position = UDim2.new(0, 6, 0, 4)
    badge.BackgroundColor3 = Color3.fromRGB(0, 140, 220)
    badge.BackgroundTransparency = 0.2
    badge.BorderSizePixel = 0
    badge.Text = "MAP"
    badge.Font = Enum.Font.GothamBold
    badge.TextSize = 8
    badge.TextColor3 = Color3.fromRGB(255, 255, 255)
    badge.ZIndex = 2
    Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 4)

    local mapLabel = Instance.new("TextLabel", frame)
    mapLabel.Name = "MapName"
    mapLabel.Size = UDim2.new(1, -18, 0, 16)
    mapLabel.Position = UDim2.new(0, 9, 0, 2)
    mapLabel.Text = "Scanning..."
    mapLabel.Font = Enum.Font.GothamBold
    mapLabel.TextSize = 11.5
    mapLabel.TextColor3 = Color3.fromRGB(230, 230, 255)
    mapLabel.BackgroundTransparency = 1
    mapLabel.TextXAlignment = Enum.TextXAlignment.Right
    mapLabel.RichText = true

    local statusLabel = Instance.new("TextLabel", frame)
    statusLabel.Name = "MapStatus"
    statusLabel.Size = UDim2.new(1, -18, 0, 12)
    statusLabel.Position = UDim2.new(0, 9, 0, 18)
    statusLabel.Text = "Status: —"
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = 9.5
    statusLabel.TextColor3 = Color3.fromRGB(120, 180, 255)
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextXAlignment = Enum.TextXAlignment.Right

    return gui
end

        function detectMap()
            local map = workspace:FindFirstChild("Map")
            if not map then return nil end

            if map:FindFirstChild("random shakes") or map:FindFirstChild("SCP-173 Room") or map:FindFirstChild("SCP-205 Room") then
                return "Site 68"
            elseif map:FindFirstChild("HooksMeat") then
                return "BLOODBATH! Club"
            elseif map:FindFirstChild("Gate") and map.Gate:FindFirstChild("vfx") then
                return "Firelink Shrine"
            elseif map:FindFirstChild("Bldg_Addon_RooftopUnit_A") or map:FindFirstChild("Rooftop") then
                return "Mercy Hospital Rooftop"
            elseif map:FindFirstChild("White Armored Car") then
                return "Mount Massive Asylum"
            elseif map:FindFirstChild("Dumbster") then
                return "The Bay Harbor"
            elseif map:FindFirstChild("water pump") then
                return "Valdelobos Village"
            elseif map:FindFirstChild("LargeBoulder01") then
                return "Woodview Cabin"
            end

            return nil
        end

        if v then
            task.spawn(function()
                local lastMap = nil
                local lastMapExists = false

                while getgenv().MapPredictEnabled do
                    local gui = buildMapGui()
                    local mainFrame = gui:FindFirstChild("MainFrame")

                    local isSpectator = false
                    pcall(function() isSpectator = (LocalPlayer.Team and LocalPlayer.Team.Name == "Spectator") end)
                    gui.Enabled = isSpectator

                    if isSpectator and mainFrame then
                        local map = workspace:FindFirstChild("Map")
                        local mapExists = map ~= nil
                        local detectedMap = detectMap()

                        if lastMapExists and not mapExists then
                            mainFrame.MapName.Text = "Map: " .. (lastMap or "Unknown")
                            mainFrame.MapStatus.Text = "Status: Setting up..."
                            mainFrame.MapStatus.TextColor3 = Color3.fromRGB(255, 200, 50)
                        elseif mapExists and detectedMap then
                            lastMap = detectedMap
                            mainFrame.MapName.Text = "Map: " .. detectedMap
                            mainFrame.MapStatus.Text = "Status: Lobby"
                            mainFrame.MapStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
                        elseif mapExists and not detectedMap then
                            mainFrame.MapName.Text = "Map: Unknown"
                            mainFrame.MapStatus.Text = "Status: Lobby"
                            mainFrame.MapStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
                        else
                            mainFrame.MapName.Text = "Map: —"
                            mainFrame.MapStatus.Text = "Status: Lobby"
                            mainFrame.MapStatus.TextColor3 = Color3.fromRGB(160, 160, 160)
                        end

                        lastMapExists = mapExists
                    end

                    task.wait(0.5)
                end

                cleanMapGui()
            end)
        else
            cleanMapGui()
        end
    end
})

-- ==================== NEXT KILLER PERKS DISPLAY ====================
local KillerPerksEnabled = false
local KillerPerksGui = nil
local KillerPerksMinimized = false

function CreateKillerPerksGUI()
    if KillerPerksGui then 
        pcall(function() KillerPerksGui:Destroy() end)
        KillerPerksGui = nil
    end
    
    if not KillerPerksEnabled then return end
    
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
    local Workspace = game:GetService("Workspace")
    local LocalPlayer = Players.LocalPlayer
    
    local function getGuiParent()
        local ok, parent = pcall(function()
            return CoreGui
        end)
        if ok and parent then return parent end
        return LocalPlayer:WaitForChild("PlayerGui")
    end
    
    local function escapeRichText(text)
        text = tostring(text or "")
        text = text:gsub("&", "&amp;")
        text = text:gsub("<", "&lt;")
        text = text:gsub(">", "&gt;")
        return text
    end
    
    local function parseWorkspacePerkName(name)
        name = tostring(name or "")
        local perkName, level = name:match("^(.+)%s+(%d+)$")
        if not perkName then return nil end
        
        perkName = perkName:gsub("^%s+", ""):gsub("%s+$", "")
        if perkName == "" then return nil end
        
        local excluded = {
            head = true, torso = true, humanoid = true, humanoidrootpart = true,
            ["left arm"] = true, ["right arm"] = true,
            ["left leg"] = true, ["right leg"] = true,
        }
        
        if excluded[perkName:lower()] then return nil end
        return perkName, level
    end
    
    local function getKillerPlayer()
        for _, player in ipairs(Players:GetPlayers()) do
            local teamName = player.Team and player.Team.Name
            if teamName and teamName:lower():find("killer") then
                return player
            end
        end
        return nil
    end
    
    local function readPerksFromWorkspace(killer)
        if not killer then return {} end
        
        local char = killer.Character
            or Workspace:FindFirstChild(killer.Name)
            or Workspace:FindFirstChild(killer.DisplayName)
        
        if not char then return {} end
        
        local result = {}
        local seen = {}
        
        for _, child in ipairs(char:GetChildren()) do
            local perkName, level = parseWorkspacePerkName(child.Name)
            if perkName and not seen[perkName] then
                seen[perkName] = true
                table.insert(result, {
                    Name = perkName,
                    Level = level,
                })
            end
        end
        
        table.sort(result, function(a, b)
            return tostring(a.Name) < tostring(b.Name)
        end)
        
        return result
    end
    
    local function buildText()
        local killer = getKillerPlayer()
        local killerName = killer and (killer.DisplayName or killer.Name) or "Unknown"
        local perks = readPerksFromWorkspace(killer)
        
        if #perks == 0 then
            for _, player in ipairs(Players:GetPlayers()) do
                local candidate = readPerksFromWorkspace(player)
                if #candidate > 0 then
                    killer = player
                    killerName = player.DisplayName or player.Name
                    perks = candidate
                    break
                end
            end
        end
        
        local lines = {
            'Killer Perks [<font color="rgb(255,80,80)">' .. escapeRichText(killerName) .. '</font>]',
        }
        
        if #perks == 0 then
            table.insert(lines, '<font color="rgb(200,200,200)">- Waiting for perk data...</font>')
        else
            for i = 1, math.min(#perks, 4) do
                local perk = perks[i]
                local levelText = perk.Level and (" lvl " .. tostring(perk.Level)) or ""
                table.insert(lines, '<font color="rgb(200,200,200)">- ' .. escapeRichText(perk.Name .. levelText) .. '</font>')
            end
        end
        
        return table.concat(lines, "\n"), #perks
    end
    
    local sg = Instance.new("ScreenGui")
    sg.Name = "NEX_KillerPerksGui"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    
    local holder = Instance.new("Frame")
    holder.Name = "Holder"
    holder.Size = UDim2.new(0, 180, 0, 85)
    holder.Position = UDim2.new(0.08, 0, 0.22, 0)
    holder.BackgroundTransparency = 1
    holder.Active = true
    holder.Parent = sg
    
    local panel = Instance.new("Frame")
    panel.Name = "Panel"
    panel.Size = UDim2.new(1, 0, 1, 0)
    panel.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    panel.BackgroundTransparency = 0.15
    panel.BorderSizePixel = 0
    panel.Parent = holder
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 60, 70)
    stroke.Thickness = 1
    stroke.Transparency = 0.3
    stroke.Parent = panel
    
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 24)
    header.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    header.BorderSizePixel = 0
    header.Parent = panel
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 6)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Position = UDim2.new(0, 8, 0, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamSemibold
    title.Text = "Killer Perks Info"
    title.TextColor3 = Color3.fromRGB(220, 220, 230)
    title.TextSize = 11
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    local function makeButton(text, x, color)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 26, 0, 16)
        btn.Position = UDim2.new(1, x, 0, 4)
        btn.BackgroundColor3 = color or Color3.fromRGB(25, 25, 30)
        btn.BorderSizePixel = 0
        btn.Font = Enum.Font.GothamMedium
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(200, 200, 210)
        btn.TextSize = 9
        btn.Parent = header
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
        return btn
    end
    
    local minimizeBtn = makeButton("Minimize", -54, Color3.fromRGB(30, 30, 40))
    local closeBtn = makeButton("Close", -28, Color3.fromRGB(40, 25, 25))
    
    local label = Instance.new("TextLabel")
    label.Name = "KillerPerksText"
    label.Size = UDim2.new(1, -14, 1, -32)
    label.Position = UDim2.new(0, 8, 0, 28)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamMedium
    label.RichText = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.TextColor3 = Color3.fromRGB(220, 220, 230)
    label.TextSize = 11
    label.TextWrapped = false
    label.Parent = panel
    
    minimizeBtn.MouseButton1Click:Connect(function()
        KillerPerksMinimized = not KillerPerksMinimized
        label.Visible = not KillerPerksMinimized
        minimizeBtn.Text = KillerPerksMinimized and "Show" or "Minimize"
        holder.Size = KillerPerksMinimized and UDim2.new(0, 180, 0, 24) or UDim2.new(0, 180, 0, 85)
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        KillerPerksEnabled = false
        if KillerPerksGui then
            pcall(function() KillerPerksGui:Destroy() end)
            KillerPerksGui = nil
        end
        if Toggles.KillerPerksToggle then
    Toggles.KillerPerksToggle:SetValue(false)
end
    end)
    
    local dragging = false
    local dragStart, startPos
    
    holder.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = holder.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if not dragging or not dragStart or not startPos then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local delta = input.Position - dragStart
        holder.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end)
    
    sg.Parent = getGuiParent()
    KillerPerksGui = sg
    
    task.spawn(function()
        while KillerPerksEnabled and KillerPerksGui do
            if not KillerPerksMinimized then
                local text, count = buildText()
                label.Text = text
                local rows = math.max(2, math.min(count + 1, 5))
                holder.Size = UDim2.new(0, 180, 0, math.max(65, 28 + rows * 15))
            end
            task.wait(1)
        end
    end)
end

-- ==================== STUN INDICATOR ====================
local ShowStun = false
local StunData = {}
local StunSetupDone = false

local function SetupStun(char)
    if not char or StunData[char] then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local old = hrp:FindFirstChild("StunUI")
    if old then old:Destroy() end
    
    local bill = Instance.new("BillboardGui")
    bill.Name = "StunUI"
    bill.Adornee = hrp
    bill.AlwaysOnTop = true
    bill.Size = UDim2.new(0, 150, 0, 40)
    bill.StudsOffsetWorldSpace = Vector3.new(0, 4.5, 0)
    bill.ResetOnSpawn = false
    bill.Parent = hrp
    bill.Enabled = false
    
    local txt = Instance.new("TextLabel", bill)
    txt.Size = UDim2.new(1, 0, 0, 18)
    txt.Position = UDim2.new(0, 0, 0, 0)
    txt.BackgroundTransparency = 1
    txt.Text = "⚡ STUNNED"
    txt.TextColor3 = Color3.fromRGB(255, 200, 50)
    txt.TextScaled = true
    txt.Font = Enum.Font.GothamBold
    
    local bg = Instance.new("Frame", bill)
    bg.Size = UDim2.new(1, 0, 0, 6)
    bg.Position = UDim2.new(0, 0, 0, 22)
    bg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    bg.BackgroundTransparency = 0.3
    bg.BorderSizePixel = 0
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 3)
    
    local fill = Instance.new("Frame", bg)
    fill.Size = UDim2.new(1, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 3)
    
    StunData[char] = {
        bill = bill,
        fill = fill,
        timer = nil,
        duration = 2.2,
        startTime = 0
    }
    
    local function OnStun()
    if Config.HitSoundEnabled then
        PlayHitSound()
    end
    
    local data = StunData[char]
    if not data then return end
    
    data.bill.Enabled = true
    data.duration = 2.2
    data.startTime = tick()
    
    if data.timer then task.cancel(data.timer) end
    
    data.timer = task.spawn(function()
        while data.bill and data.bill.Enabled do
            local elapsed = tick() - data.startTime
            local progress = 1 - (elapsed / data.duration)
            
            if progress <= 0 then
                data.bill.Enabled = false
                break
            end
            
            data.fill.Size = UDim2.new(progress, 0, 1, 0)
            
            if progress > 0.5 then
                data.fill.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
            elseif progress > 0.2 then
                data.fill.BackgroundColor3 = Color3.fromRGB(255, 150, 30)
            else
                data.fill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            end
            
            task.wait(0.05)
        end
    end)
end
    
    char:GetAttributeChangedSignal("IsStunned"):Connect(function()
        if char:GetAttribute("IsStunned") == true then
            OnStun()
        end
    end)
    
    char:GetAttributeChangedSignal("Immobile"):Connect(function()
        if char:GetAttribute("Immobile") == true then
            OnStun()
        end
    end)
    
    local checkConn
    checkConn = RunService.Heartbeat:Connect(function()
        if not ShowStun then 
            if checkConn then checkConn:Disconnect() end
            return 
        end
        if not char or not char.Parent then
            if checkConn then checkConn:Disconnect() end
            return
        end
        if char:GetAttribute("IsStunned") == true or char:GetAttribute("Immobile") == true then
            local data = StunData[char]
            if data and not data.bill.Enabled then
                OnStun()
            end
        end
    end)
end

local function CleanupStun(char)
    local data = StunData[char]
    if data then
        if data.timer then task.cancel(data.timer) end
        if data.bill then data.bill:Destroy() end
        StunData[char] = nil
    end
end

local function SetupAllStun()
    if not ShowStun then return end
    
    for _, p in ipairs(Players:GetPlayers()) do
        if IsKiller(p) and p.Character then
            SetupStun(p.Character)
        end
    end
end

Players.PlayerAdded:Connect(function(p)
    if not ShowStun then return end
    
    p.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if ShowStun and IsKiller(p) then
            SetupStun(char)
            print("✅ Stun setup untuk killer baru: " .. p.Name)
        end
    end)
    
    task.wait(0.5)
    if ShowStun and IsKiller(p) and p.Character then
        SetupStun(p.Character)
    end
end)

Players.PlayerAdded:Connect(function(p)
    p:GetPropertyChangedSignal("Team"):Connect(function()
        if not ShowStun then return end
        task.wait(0.5)
        if IsKiller(p) and p.Character then
            CleanupStun(p.Character)
            task.wait(0.1)
            SetupStun(p.Character)
            print("✅ Stun re-setup untuk killer ganti team: " .. p.Name)
        end
    end)
end)

Players.PlayerAdded:Connect(function(p)
    task.wait(0.5)
    if ShowStun then
        SetupAllStun()
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1.5)
    if ShowStun then
        SetupAllStun()
        print("🔄 Stun re-setup setelah respawn")
    end
end)

task.spawn(function()
    while true do
        task.wait(5)
        if ShowStun then
            for _, p in ipairs(Players:GetPlayers()) do
                if IsKiller(p) and p.Character then
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local bill = hrp:FindFirstChild("StunUI")
                        if not bill then
                            SetupStun(p.Character)
                            print("🔄 Stun re-applied for: " .. p.Name)
                        end
                    end
                end
            end
        end
    end
end)

NextKillerGroup:AddToggle("ShowStun", {
    Text = "Killer Stun Indicator",
    Default = false,
    Callback = function(Value)
        ShowStun = Value
        
        if Value then
            for char, _ in pairs(StunData) do
                CleanupStun(char)
            end
            StunData = {}
            
            task.wait(0.5)
            SetupAllStun()
            print("✅ Stun Indicator AKTIF - Auto re-apply aktif!")
            Library:Notify({ 
                Title = "Stun Indicator", 
                Description = "Aktif", 
                Time = 3 
            })
        else
            for char, _ in pairs(StunData) do
                CleanupStun(char)
            end
            StunData = {}
            print("❌ Stun Indicator dimatikan")
            Library:Notify({ 
                Title = "Stun Indicator", 
                Description = "Nonaktif", 
                Time = 2 
            })
        end
    end
})

NextKillerGroup:AddToggle("HitSoundToggle", {
    Text = "Enable Hit Sound Effect",
    Tooltip = "Memutar suara 'Ahhh' saat berhasil stun killer",
    Default = false,
    Callback = function(Value)
        Config.HitSoundEnabled = Value
        if Value then
            Library:Notify({ 
                Title = "Hit Sound", 
                Description = "AKTIF - Sound akan diputar saat stun", 
                Time = 3 
            })
        else
            Library:Notify({ 
                Title = "Hit Sound", 
                Description = "NONAKTIF", 
                Time = 2 
            })
        end
    end
})

NextKillerGroup:AddToggle("KillerPerksToggle", {
    Text = "Killer Perks Display",
    Default = false,
    Tooltip = "Menampilkan perk killer yang sedang digunakan",
    Callback = function(Value)
        KillerPerksEnabled = Value
        if Value then
            CreateKillerPerksGUI()
        else
            if KillerPerksGui then
                pcall(function() KillerPerksGui:Destroy() end)
                KillerPerksGui = nil
            end
        end
    end
})

-- ==================== SPECTATOR INFO ====================
spectatorEnabled = false
SpectatorGui = nil
SpectatorLabel = nil

function CreateSpectatorUI()
    if SpectatorGui then SpectatorGui:Destroy() end
    
    SpectatorGui = Instance.new("ScreenGui")
    SpectatorGui.Name = "SpectatorCounter"
    SpectatorGui.ResetOnSpawn = false
    SpectatorGui.Parent = player:WaitForChild("PlayerGui")
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainBox"
    mainFrame.AnchorPoint = Vector2.new(0.5, 1)
    mainFrame.Position = UDim2.new(0.5, 0, 0, -10)
    mainFrame.Size = UDim2.new(0, 68, 0, 22)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    mainFrame.BackgroundTransparency = 0.25
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = SpectatorGui
    
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)
    
    local gradient = Instance.new("UIGradient")
    gradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(0.3,0.4), NumberSequenceKeypoint.new(1,1)})
    gradient.Parent = mainFrame
    
    local layout = Instance.new("UIListLayout", mainFrame)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 6)
    
    local eye = Instance.new("ImageLabel", mainFrame)
    eye.Size = UDim2.new(0,15,0,15)
    eye.BackgroundTransparency = 1
    eye.Image = "rbxassetid://13321848320"
    eye.ImageColor3 = Color3.fromRGB(180,180,255)
    
    SpectatorLabel = Instance.new("TextLabel", mainFrame)
    SpectatorLabel.BackgroundTransparency = 1
    SpectatorLabel.Font = Enum.Font.GothamMedium
    SpectatorLabel.Text = "0"
    SpectatorLabel.TextColor3 = Color3.fromRGB(240,240,240)
    SpectatorLabel.TextSize = 13
    SpectatorLabel.AutomaticSize = Enum.AutomaticSize.X
end

function UpdateSpectatorCount()
    if not spectatorEnabled or not SpectatorLabel then return end
    
    local count = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Team and p.Team.Name == "Spectator" then
            count += 1
        end
    end
    
    SpectatorLabel.Text = tostring(count)
    
    local frame = SpectatorGui and SpectatorGui:FindFirstChild("MainBox")
    if frame then
        frame.Size = UDim2.new(0, 55 + (count >= 10 and 8 or 0) + (count >= 100 and 8 or 0), 0, 22)
    end
end

function StartSpectatorInfo()
    if spectatorEnabled then return end
    spectatorEnabled = true
    CreateSpectatorUI()
    UpdateSpectatorCount()
    
    task.spawn(function()
        while spectatorEnabled do
            UpdateSpectatorCount()
            task.wait(1.2)
        end
    end)
    
    Library:Notify({ Title = "Spectator Info", Description = "✅ Display aktif di pojok atas", Time = 3 })
end

function StopSpectatorInfo()
    spectatorEnabled = false
    if SpectatorGui then
        SpectatorGui:Destroy()
        SpectatorGui = nil
        SpectatorLabel = nil
    end
    Library:Notify({ Title = "Spectator Info", Description = "Display dimatikan", Time = 2 })
end

NextKillerGroup:AddToggle("SpectatorToggle", {
    Text = "Enable Spectator Counter",
    Default = false,
    Tooltip = "Menampilkan jumlah player yang sedang jadi Spectator",
    Callback = function(Value)
        if Value then
            StartSpectatorInfo()
        else
            StopSpectatorInfo()
        end
    end
})

NextKillerGroup:AddButton({
    Text = "Refresh Count",
    Func = function()
        if spectatorEnabled then
            UpdateSpectatorCount()
        end
    end
})

-- Performance Settings
local PerfGroup = TabsUI.Esp:AddRightGroupbox("World Effects", "sun")

PerfGroup:AddToggle("FullBright", {
    Text = "Full Bright",
    Tooltip = "Bikin map jadi terang biar lebih jelas",
    Default = false,
    Callback = function(Value)
        FullBright = Value
        if Value then
            ApplyFullBright()
            Library:Notify({ Title = "Full Bright", Description = "Full Bright aktif!", Time = 3 })
        else
            Lighting.Brightness = 1
            Lighting.ClockTime = 14
            Lighting.Ambient = Color3.fromRGB(128,128,128)
            Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
            Library:Notify({ Title = "Full Bright", Description = "Full Bright dimatikan", Time = 3 })
        end
    end,
})

PerfGroup:AddSlider("TimeOfDay", {
    Text = "Time Of Day",
    Tooltip = "Atur waktu di game",
    Default = 14,
    Min = 0,
    Max = 24,
    Rounding = 0,
    Callback = function(Value)
        TimeOfDayValue = Value
        if FullBright then Lighting.ClockTime = Value end
    end,
})

PerfGroup:AddToggle("NoFog", {
    Text = "No Fog",
    Tooltip = "Hapus kabut biar map lebih jelas",
    Default = false,
    Callback = function(Value)
        NoFog = Value
        if Value then
            ApplyNoFog()
            Library:Notify({ Title = "No Fog", Description = "Kabut berhasil dihilangkan!", Time = 3 })
        else
            Lighting.FogStart = 0
            Lighting.FogEnd = 1000
            local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
            if atmosphere then atmosphere.Density = 0.35 end
            Library:Notify({ Title = "No Fog", Description = "No Fog dimatikan", Time = 3 })
        end
    end,
})

PerfGroup:AddToggle("NoShadow", {
    Text = "No Shadow",
    Tooltip = "Matikan shadow",
    Default = false,
    Callback = function(Value)
        NoShadow = Value
        ApplyNoShadow()
        Library:Notify({ Title = "No Shadow", Description = Value and "Shadow berhasil dihapus!" or "Shadow dikembalikan normal", Time = 3 })
    end,
})

local FPSCapValue = 60
local FPSCapEnabled = false

local function SetFPS(Value)
    FPSCapValue = Value
    if FPSCapEnabled then
        setfpscap(Value)
        Library:Notify({ 
            Title = "FPS Cap", 
            Description = " " .. Value .. " FPS", 
            Time = 1 
        })
    end
end

PerfGroup:AddToggle("FPSCapToggle", {
    Text = "Enable FPS Cap",
    Tooltip = "Aktifkan pembatas FPS",
    Default = false,
    Callback = function(Value)
        FPSCapEnabled = Value
        if Value then
            setfpscap(FPSCapValue)
            Library:Notify({ 
                Title = "FPS Cap", 
                Description = "" .. FPSCapValue .. " FPS", 
                Time = 2 
            })
        else
            setfpscap(0)
            Library:Notify({ 
                Title = "FPS Cap", 
                Description = "Nonaktif", 
                Time = 2 
            })
        end
    end
}):AddKeyPicker("FPSCapKey", {
    Default = "None",
    Text = "Keybind FPS Cap",
    Mode = "Toggle",
    Callback = function(Value)
        FPSCapEnabled = Value
        if Value then
            setfpscap(FPSCapValue)
        else
            setfpscap(0)
        end
        if Options.FPSCapToggle then
            Options.FPSCapToggle:SetValue(Value)
        end
    end
})

PerfGroup:AddSlider("FPSCapSlider", {
    Text = "FPS Limit",
    Min = 1,
    Max = 4000,
    Default = 60,
    Color = Color3.fromRGB(0, 200, 255),
    Callback = function(Value)
        SetFPS(Value)
    end
})

PerfGroup:AddButton({
    Text = "Reset to 60 FPS",
    Func = function()
        SetFPS(60)
        if Options.FPSCapSlider then
            Options.FPSCapSlider:SetValue(60)
        end
        Library:Notify({ 
            Title = "FPS Cap", 
            Description = "Reset ke 60 FPS", 
            Time = 2 
        })
    end
})

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(2)
    if FPSCapEnabled then
        setfpscap(FPSCapValue)
    end
end)

-- ==================== TAB TELEPORT ====================
local TeleportPlayerGroup = TabsUI.Teleport:AddLeftGroupbox("Teleport Players", "users")

local selectedPlayer = nil
local playerList = {}
local PlayerDropdown = nil

function UpdatePlayerList()
    playerList = {}
    for _, plr in pairs(Players:GetPlayers()) do 
        if plr ~= player and plr.Character then
            table.insert(playerList, plr.Name) 
        end 
    end
    table.sort(playerList)
end
UpdatePlayerList()

PlayerDropdown = TeleportPlayerGroup:AddDropdown("PlayerDropdown", {
    Values = playerList,
    Default = "",
    Text = "Pilih Player",
    Tooltip = "TP ke player yang di pilih",
    Callback = function(Value)
        selectedPlayer = Value
    end,
})

TeleportPlayerGroup:AddButton({
    Text = "Refresh Player",
    Func = function()
        UpdatePlayerList()
        
        if PlayerDropdown then
            PlayerDropdown:SetValues(playerList)
        end
        
        Library:Notify({ 
            Title = "Teleport", 
            Description = "List player direfresh! (" .. #playerList .. " player)", 
            Time = 3 
        })
    end,
})

TeleportPlayerGroup:AddButton({
    Text = "Teleport ke player yang dipilih",
    Func = function()
        if not selectedPlayer or selectedPlayer == "" then
            Library:Notify({ Title = "Error", Description = "Pilih pemain terlebih dulu!", Time = 3 })
            return
        end
        local target = Players:FindFirstChild(selectedPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
            end
        end
    end,
})

function TeleportToPart(part)
    if not part then return end
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local offset = Vector3.new(0, 3, 0)
        if part:IsA("BasePart") then
            hrp.CFrame = part.CFrame + offset
        elseif part:IsA("Model") then
            local p = part:FindFirstChildWhichIsA("BasePart")
            if p then hrp.CFrame = p.CFrame + offset end
        end
        Library:Notify({Title = "Teleport", Description = "Berhasil!", Time = 1})
    end
end

local TeleportMapGroup = TabsUI.Teleport:AddRightGroupbox("Teleport Maps", "map")

genIndex = 1
hookIndex = 1
gateIndex = 1
palletIndex = 1
windowIndex = 1

function TeleportToGenerator()
    if #Cache.Generators == 0 then ScanMap() end
    if genIndex > #Cache.Generators then genIndex = 1 end
    
    local genData = Cache.Generators[genIndex]
    if genData and genData.part then
        TeleportToPart(genData.part)
        Library:Notify({Title = "TP Generator", Description = "Generator " .. genIndex, Time = 1.2})
    else
        Library:Notify({Title = "TP Generator", Description = "Generator tidak ditemukan!", Time = 2})
    end
    genIndex = genIndex + 1
end

TeleportMapGroup:AddButton({
    Text = "TP Generator",
    Func = TeleportToGenerator
})

TeleportMapGroup:AddLabel("Keybind TP Gen"):AddKeyPicker("Key_TPGen", { 
    Default = "I",
    SyncToggleState = false, 
    Mode = "Toggle", 
    Text = "Teleport ke Generator", 
    NoUI = false 
})

Options.Key_TPGen:OnClick(function()
    TeleportToGenerator()
end)

TeleportMapGroup:AddButton({
    Text = "TP Hook (Loop)",
    Func = function()
        if #Cache.Hooks == 0 then ScanMap() end
        if hookIndex > #Cache.Hooks then hookIndex = 1 end
        local v = Cache.Hooks[hookIndex]
        local part = v and (v:FindFirstChild("HookPoint") or v:FindFirstChildWhichIsA("BasePart"))
        if part then TeleportToPart(part) end
        hookIndex = hookIndex + 1
    end,
})

TeleportMapGroup:AddButton({
    Text = "TP Gate (Loop)",
    Func = function()
        if #Cache.Gates == 0 then ScanMap() end
        if gateIndex > #Cache.Gates then gateIndex = 1 end
        local v = Cache.Gates[gateIndex]
        local part = v and v:FindFirstChildWhichIsA("BasePart")
        if part then TeleportToPart(part) end
        gateIndex = gateIndex + 1
    end,
})

TeleportMapGroup:AddButton({
    Text = "TP Pallet (Loop)",
    Func = function()
        if #Cache.Pallets == 0 then ScanMap() end
        if palletIndex > #Cache.Pallets then palletIndex = 1 end
        local v = Cache.Pallets[palletIndex]
        local part = v and (v:FindFirstChild("PrimaryPartPallet") or v:FindFirstChildWhichIsA("BasePart"))
        if part then TeleportToPart(part) end
        palletIndex = palletIndex + 1
    end,
})

TeleportMapGroup:AddButton({
    Text = "TP Window (Loop)",
    Func = function()
        if #Cache.Windows == 0 then ScanMap() end
        if windowIndex > #Cache.Windows then windowIndex = 1 end
        local v = Cache.Windows[windowIndex]
        local part = v and (v:FindFirstChild("Bottom") or v:FindFirstChildWhichIsA("BasePart"))
        if part then TeleportToPart(part) end
        windowIndex = windowIndex + 1
    end,
})

TeleportMapGroup:AddButton({
    Text = "Refresh Map",
    Func = function()
        ForceRefreshMap()
    end,
})

LocalPlayer.CharacterAdded:Connect(function()
    if HeartbeatConnection then HeartbeatConnection:Disconnect() end
    if VisibilityConnection then VisibilityConnection:Disconnect() end
    task.wait(1.2)
    ReapplyPerformance()
    
    task.wait(1)
    ScanMap()
    genIndex, hookIndex, gateIndex, palletIndex, windowIndex = 1,1,1,1,1
    
    if Config.ESP_Master then
        task.spawn(function()
            task.wait(1)
            ForceRefreshMap()
        end)
    end
    if Config.Surv_InstanSkillCheck then
        task.spawn(function()
            local char = LocalPlayer.Character
            local genScript = char:WaitForChild("Skillcheck-gen", 3)
            local playerScript = char:WaitForChild("Skillcheck-player", 3)
            if genScript then genScript.Disabled = true end
            if playerScript then playerScript.Disabled = true end
        end)
    end
end)

for _, p in pairs(Players:GetPlayers()) do 
    SetupPlayer(p) 
end
Players.PlayerAdded:Connect(SetupPlayer)

task.spawn(function()
    while true do 
        task.wait(5) 
        for _, p in pairs(Players:GetPlayers()) do 
            TryAttach(p) 
        end 
    end
end)

-- Cursor Mode
local CursorEnabled = false
local CursorConnection

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightAlt then
        CursorEnabled = not CursorEnabled
        if CursorEnabled then
            UserInputService.MouseIconEnabled = true
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            if CursorConnection then CursorConnection:Disconnect() end
            CursorConnection = RunService.RenderStepped:Connect(function()
                if UserInputService.MouseBehavior ~= Enum.MouseBehavior.Default then
                    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                end
                if not UserInputService.MouseIconEnabled then
                    UserInputService.MouseIconEnabled = true
                end
            end)
        else
            if CursorConnection then CursorConnection:Disconnect() end
            CursorConnection = nil
            UserInputService.MouseIconEnabled = false
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        end
    end
end)

function getKillerTargetForFlash()
    local bestTarget = nil
    local closestDist = math.huge
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    
    if not myHRP then return nil end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and IsKiller(p) and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")

            if hum and hum.Health > 0 and hrp and not IsDowned(p.Character) then
                local dist = (hrp.Position - myHRP.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    bestTarget = hrp 
                end
            end
        end
    end
    
    return bestTarget
end

function NEX_UpdateCureFlaskLaser()
    local char = game:GetService("Players").LocalPlayer.Character
    if not char then return end

    local targetPos  = nil
    local originPos  = nil
    local closest    = nil
    local minDst     = math.huge
    local hrp        = char:FindFirstChild("HumanoidRootPart")

    if hrp then
        local hand = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
        originPos  = hand and hand.Position or hrp.Position

        for _, v in pairs(game:GetService("Players"):GetPlayers()) do
            if v ~= game:GetService("Players").LocalPlayer
            and v.Character
            and v.Character:FindFirstChild("HumanoidRootPart")
            and not v.Character:GetAttribute("IsKiller") then
                local dst = (v.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if dst < minDst then
                    minDst  = dst
                    closest = v
                end
            end
        end
    end

    if closest then
        targetPos = closest.Character.HumanoidRootPart.Position
    end

    -- Cek apakah sedang charge/hold flask
    local actionActive = false
    for _, child in pairs(char:GetChildren()) do
        if child:IsA("LocalScript") and child:GetAttribute("action") == true then
            actionActive = true
            break
        end
    end

    if originPos and targetPos and actionActive then
        -- Buat part laser kalau belum ada
        if not getgenv().NEX_CureFlaskLaserPart then
            local laser        = Instance.new("Part")
            laser.Name         = "FlaskSilentAimLaser"
            laser.Anchored     = true
            laser.CanCollide   = false
            laser.CanTouch     = false
            laser.CastShadow   = false
            laser.Material     = Enum.Material.Neon
            laser.Color        = Color3.fromRGB(255, 50, 50)
            laser.Transparency = 0
            laser.Parent       = workspace
            getgenv().NEX_CureFlaskLaserPart = laser
        end

        local dist = (targetPos - originPos).Magnitude
        if dist > 0.1 then
            local laser  = getgenv().NEX_CureFlaskLaserPart
            laser.Size   = Vector3.new(0.16, 0.16, dist)
            laser.CFrame = CFrame.new((originPos + targetPos) / 2, targetPos)
            laser.Transparency = 0
        end
    else
        -- Sembunyikan laser kalau tidak sedang charge
        if getgenv().NEX_CureFlaskLaserPart then
            getgenv().NEX_CureFlaskLaserPart.Transparency = 1
        end
    end
end


-- [4] FUNGSI START LASER
function NEX_StartCureFlaskLaser()
    if getgenv().NEX_CureFlaskLaserThread then return end
    getgenv().NEX_CureFlaskLaserThread = game:GetService("RunService").RenderStepped:Connect(function()
        if not VD.KILLER_FlaskLaser then
            if getgenv().NEX_CureFlaskLaserPart then
                pcall(function() getgenv().NEX_CureFlaskLaserPart:Destroy() end)
                getgenv().NEX_CureFlaskLaserPart = nil
            end
            if getgenv().NEX_CureFlaskLaserThread then
                getgenv().NEX_CureFlaskLaserThread:Disconnect()
                getgenv().NEX_CureFlaskLaserThread = nil
            end
            return
        end
        pcall(NEX_UpdateCureFlaskLaser)
    end)
end

-- ==================== INFINITE FRENZY ====================
function NEX_StartJeffCooldownBypass()
    if getgenv().NEX_JeffCooldownBypassThread then return end
    getgenv().NEX_JeffCooldownBypassThread = task.spawn(function()
        local player = LocalPlayer

        while VD.KILLER_InfFrenzy do
            pcall(function()
                local char = player.Character
                if char and char:GetAttribute("Frenzy") ~= true then
                    char:SetAttribute("Frenzy", true)
                end
            end)
            task.wait(0.1)
        end

        getgenv().NEX_JeffCooldownBypassThread = nil
    end)
end

function NEX_StopJeffCooldownBypass()
    pcall(function()
        local char = LocalPlayer.Character
        if char and char:GetAttribute("Frenzy") == true then
            char:SetAttribute("Frenzy", false)

            local killer = ReplicatedStorage:FindFirstChild("Remotes")
                and ReplicatedStorage.Remotes:FindFirstChild("Killers")
                and ReplicatedStorage.Remotes.Killers:FindFirstChild("Killer")
            if killer then
                local deact = killer:FindFirstChild("Deactivatefromclient")
                if deact then
                    deact:FireServer()
                end
            end
        end
    end)
end

-- ===== INFINITE PURSUIT JASON =====
function NEX_StartJasonPursuitBypass()
    if InfPursuitThread then return end
    InfPursuitThread = task.spawn(function()
        local player = LocalPlayer

        while VD.KILLER_InfPursuit do
            pcall(function()
                local char = player.Character
                if char and char:GetAttribute("Pursuit") ~= true then
                    char:SetAttribute("Pursuit", true)
                end
            end)
            task.wait(0.1)
        end

        InfPursuitThread = nil
    end)
end

function NEX_StopJasonPursuitBypass()
    pcall(function()
        local char = LocalPlayer.Character
        if char and char:GetAttribute("Pursuit") == true then
            char:SetAttribute("Pursuit", false)

            local jason = ReplicatedStorage:FindFirstChild("Remotes")
                and ReplicatedStorage.Remotes:FindFirstChild("Killers")
                and ReplicatedStorage.Remotes.Killers:FindFirstChild("Jason")
            if jason then
                local deact = jason:FindFirstChild("Deactivatefromclient")
                if deact then
                    deact:FireServer()
                end
            end
        end
    end)
end

-- ===== INFINITE LAKE MIST JASON =====
function NEX_StartJasonLakeMistBypass()
    if InfLakeMistThread then return end
    InfLakeMistThread = task.spawn(function()
        local player = LocalPlayer

        while VD.KILLER_InfLakeMist do
            pcall(function()
                local char = player.Character
                if char then
                    -- CUKUP SET ATTRIBUTE AJA!
                    if char:GetAttribute("LakeMist") ~= true then
                        char:SetAttribute("LakeMist", true)
                    end
                    
                    if char:GetAttribute("speedboost") ~= 1 then
                        char:SetAttribute("speedboost", 1)
                    end
                end
            end)
            task.wait(0.1)
        end

        InfLakeMistThread = nil
    end)
end

function NEX_StopJasonLakeMistBypass()
    VD.KILLER_InfLakeMist = false

    if InfLakeMistThread then
        task.cancel(InfLakeMistThread)
        InfLakeMistThread = nil
    end

    pcall(function()
        local char = LocalPlayer.Character
        if char then
            char:SetAttribute("LakeMist", false)
            char:SetAttribute("speedboost", 1) -- normal, bukan 0.5
        end
    end)
end


-- ===== ANTI AUTO PARRY - LOOP =====
task.spawn(function()
    while true do
        task.wait(0.5)
        if not AntiAutoParryEnabled then continue end
        
        local char = LocalPlayer.Character
        if not char then continue end
        
        local myRoot = char:FindFirstChild("HumanoidRootPart")
        if not myRoot then continue end
        
        local near = false
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Team and p.Team.Name == "Survivors" then
                local r = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                if r and (myRoot.Position - r.Position).Magnitude <= 15 then
                    near = true
                    break
                end
            end
        end
        
        if near then
            local randomId = ParryAnimList[math.random(1, #ParryAnimList)]
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://" .. randomId
            
            local hum = char:FindFirstChildOfClass("Humanoid")
            local animator = hum and hum:FindFirstChildOfClass("Animator")
            
            if animator then
                local track = animator:LoadAnimation(anim)
                track:Play()
                track:AdjustWeight(0)
                task.wait(0.05)
                track:Stop()
                anim:Destroy()
            end
        end
    end
end)

task.spawn(function()
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end

    local SurvivorAnimationsController = nil
    local maxAttempts = 10
    local attempts = 0

    while not SurvivorAnimationsController and attempts < maxAttempts do
        attempts = attempts + 1
        local success, result = pcall(function()
            local Modules = ReplicatedStorage:WaitForChild("Modules", 5)
            if not Modules then return nil end
            
            local Survivors = Modules:WaitForChild("Survivors", 5)
            if not Survivors then return nil end
            
            local Controller = Survivors:WaitForChild("SurvivorAnimationsController", 5)
            if not Controller then return nil end
            
            return require(Controller)
        end)

        if success and result then
            SurvivorAnimationsController = result
        else
            task.wait(1)
        end
    end

    if not SurvivorAnimationsController then
        return 
    end

    local original_isFacingStraightEnough = SurvivorAnimationsController._isFacingStraightEnough
    SurvivorAnimationsController._isFacingStraightEnough = function(self, part1, part2, maxAngle)
        if Config.Surv_PerfectVault then
            self.characterspeed = 20
            return true, 0 
        end
        return original_isFacingStraightEnough(self, part1, part2, maxAngle)
    end

    local original_onVaultAnimation = SurvivorAnimationsController._onVaultAnimation
    SurvivorAnimationsController._onVaultAnimation = function(self, vaultPoint, isSprinting)
        if Config.Surv_PerfectVault then
            return original_onVaultAnimation(self, vaultPoint, true)
        end
        return original_onVaultAnimation(self, vaultPoint, isSprinting)
    end
end)

function setupSpearInterceptor()
    if SpearInterceptorHooked then return end

    if not getrawmetatable or not setreadonly then
        warn("[SpearInterceptor]: Executor tidak support getrawmetatable atau setreadonly.")
        return
    end

    local Spearthrow = nil
    pcall(function()
        Spearthrow = ReplicatedStorage.Remotes.Killers.Veil.Spearthrow
    end)

    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldNamecall = mt.__namecall

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()

        if method == "FireServer"
            and not checkcaller()
            and typeof(self) == "Instance"
            and self.ClassName == "RemoteEvent"
            and self.Name == "Spearthrow"
        then
            -- ===== V1: cuma blok fire asli (fire manual di InputEnded) =====
            if AimConfig.Aim_SilentVeil and not AimConfig.Aim_SilentVeilV2 then
                return nil
            end

            -- ===== V2: intercept + redirect (tanpa double) =====
            -- ===== V2: intercept + redirect (tanpa double) =====
            if AimConfig.Aim_SilentVeilV2 and not isFiringSpear then
                local lookVec, speed, originPos = ...
                speed = speed or AimConfig.SPEAR_Speed or 165

                local myChar = LocalPlayer.Character
                local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
                local startPart = myChar and (myChar:FindFirstChild("Head") or myHRP)

                local isSpecial = myChar and myChar:GetAttribute("special") == true
                -- samakan speed dengan V1
                if Config.SpearSmart_enable then
                    speed = isSpecial and 165 or 142.5
                else
                    speed = AimConfig.SPEAR_Speed or 165
                end

                originPos = originPos or (Config.SpearSmart_enable and myHRP and myHRP.Position)
                    or (startPart and startPart.Position)

                local bestDir = lookVec
                local targetPart = getClosestSurvivor()

                if targetPart and originPos then
                    local targetHRP = targetPart:IsA("Model") and targetPart:FindFirstChild("HumanoidRootPart") or targetPart
                    local targetPos = targetHRP.Position
                    local targetVel = Vector3.new(0, 0, 0)

                    local targetHum = targetPart.Parent and targetPart.Parent:FindFirstChildOfClass("Humanoid")
                    if targetHum and targetHum.MoveDirection.Magnitude > 0 then
                        targetVel = targetHum.MoveDirection * targetHum.WalkSpeed
                    elseif targetHRP:IsA("BasePart") then
                        targetVel = targetHRP.AssemblyLinearVelocity
                    end
                    targetVel = Vector3.new(targetVel.X, 0, targetVel.Z)

                    local distance = (targetPos - originPos).Magnitude
                    local timeToHit = distance / math.max(speed, 1)

                    if Config.SpearSmart_enable then
                        -- Predict ON → sama persis V1 Smart
                        local leadMultiplier = AimConfig.Veil_LeadMultiplier or 1.4
                        local predictedPos = targetPos + (targetVel * (timeToHit * leadMultiplier))
                        local spearGravity = workspace.Gravity * 0.5
                        local drop = 0.5 * spearGravity * (timeToHit * timeToHit)
                        local finalAimPos = predictedPos + Vector3.new(0, drop - 1.5, 0)
                        bestDir = (finalAimPos - originPos).Unit
                    else
                        -- Predict OFF → tetap ke target (bukan lurus kamera)
                        -- rumus default V1
                        local dynamicPrediction = math.clamp(distance / 50, 0.1, 4.0)
                        local predictedPos = targetPos + (targetVel * (timeToHit * dynamicPrediction))
                        local distanceMultiplier = math.clamp(distance / 100, 1, 2.5)

                        local autoGravity = math.max(0, distance - 8)
                        local gravity = AimConfig.AIM_Auto and autoGravity or (AimConfig.SPEAR_Gravity or workspace.Gravity * 0.5)

                        local drop = 0.5 * gravity * (timeToHit * timeToHit) * distanceMultiplier
                        local finalAimPos = predictedPos + Vector3.new(0, drop, 0)
                        bestDir = (finalAimPos - originPos).Unit
                    end
                end

                isFiringSpear = true
                pcall(function()
                    if Spearthrow then
                        Spearthrow:FireServer(bestDir, speed, originPos)
                    else
                        self:FireServer(bestDir, speed, originPos)
                    end
                end)
                isFiringSpear = false
                return
            end
        end

        return oldNamecall(self, ...)
    end)

    setreadonly(mt, true)
    SpearInterceptorHooked = true
end

setupSpearInterceptor()
Library.CantDragForced = true
-- ==================== UI SETTINGS & SAVE MANAGER ====================
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("Pandu")
SaveManager:SetFolder("Pandu/FullFeature")
SaveManager:BuildConfigSection(TabsUI["UI Settings"])
ThemeManager:ApplyToTab(TabsUI["UI Settings"])
SaveManager:LoadAutoloadConfig()
Library:Notify({ Title = "Pandu Hub", Description = "Berhasil Dimuat!", Time = 3 })
end

-- Jalankan script utama tanpa Key System
MainScript()
