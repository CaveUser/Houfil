-- ======================================================
-- 👑 Houfil - DEV ENGINE (PREMIUM & SAAS)
-- Pixel-Perfect UI | Ground Path Visuals | Smart Bypass
-- ======================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera
local targetGui = pcall(function() return CoreGui.Name end) and CoreGui or player:WaitForChild("PlayerGui")

if targetGui:FindFirstChild("HoufilPremium") then targetGui.HoufilPremium:Destroy() end
if targetGui:FindFirstChild("HoufilOverlay") then targetGui.HoufilOverlay:Destroy() end
if targetGui:FindFirstChild("HoufilEditorVisuals") then targetGui.HoufilEditorVisuals:Destroy() end

-- ==========================================
-- 1. CONFIGURATION & VARIABLES
-- ==========================================
local ConfigFileName = "Houfil_Dev_Settings.json"
local CurrentSettings = {
    Theme = "Obsidian", Font = "Chillax", Opacity = 0.40, TextSizeOffset = 1, MenuSize = 100, 
    UISounds = true, SoundPack = "None", ToggleKey = "Insert"
}

local Themes = {
    ["None"]       = { Accent = Color3.fromRGB(255, 255, 255), Main = Color3.fromRGB(15, 16, 20), Side = Color3.fromRGB(10, 11, 14), Elem = Color3.fromRGB(25, 26, 30), Text = Color3.fromRGB(250,250,250), TextDim = Color3.fromRGB(150,150,160) },
    ["White"]      = { Accent = Color3.fromRGB(0, 120, 255),   Main = Color3.fromRGB(245, 245, 245), Side = Color3.fromRGB(230, 230, 230), Elem = Color3.fromRGB(255, 255, 255), Text = Color3.fromRGB(20, 20, 20), TextDim = Color3.fromRGB(100, 100, 100) },
    ["Black"]      = { Accent = Color3.fromRGB(240, 240, 240), Main = Color3.fromRGB(12, 12, 12),    Side = Color3.fromRGB(8, 8, 8),    Elem = Color3.fromRGB(18, 18, 18),    Text = Color3.fromRGB(240, 240, 240), TextDim = Color3.fromRGB(140, 140, 140) },
    ["Diamond"]    = { Accent = Color3.fromRGB(0, 200, 255),   Main = Color3.fromRGB(10, 15, 25),    Side = Color3.fromRGB(5, 10, 15),  Elem = Color3.fromRGB(15, 22, 35),    Text = Color3.fromRGB(240, 250, 255), TextDim = Color3.fromRGB(100, 150, 200) },
    ["Sakura"]     = { Accent = Color3.fromRGB(220, 90, 130),  Main = Color3.fromRGB(250, 242, 245), Side = Color3.fromRGB(242, 230, 235), Elem = Color3.fromRGB(255, 248, 250), Text = Color3.fromRGB(140, 50, 80),   TextDim = Color3.fromRGB(180, 100, 120) },
    ["Emerald"]    = { Accent = Color3.fromRGB(80, 255, 150),  Main = Color3.fromRGB(12, 25, 18),    Side = Color3.fromRGB(8, 18, 12),  Elem = Color3.fromRGB(18, 35, 25),    Text = Color3.fromRGB(200, 255, 220), TextDim = Color3.fromRGB(120, 180, 140) },
    ["Forest"]     = { Accent = Color3.fromRGB(50, 160, 80),   Main = Color3.fromRGB(8, 15, 10),     Side = Color3.fromRGB(5, 10, 8),   Elem = Color3.fromRGB(12, 22, 15),    Text = Color3.fromRGB(180, 220, 190), TextDim = Color3.fromRGB(100, 140, 110) },
    ["Ruby"]       = { Accent = Color3.fromRGB(255, 80, 80),   Main = Color3.fromRGB(25, 12, 12),    Side = Color3.fromRGB(18, 8, 8),   Elem = Color3.fromRGB(35, 18, 18),    Text = Color3.fromRGB(255, 220, 220), TextDim = Color3.fromRGB(180, 120, 120) },
    ["Blood"]      = { Accent = Color3.fromRGB(180, 20, 20),   Main = Color3.fromRGB(12, 4, 4),      Side = Color3.fromRGB(8, 2, 2),    Elem = Color3.fromRGB(18, 6, 6),      Text = Color3.fromRGB(220, 160, 160), TextDim = Color3.fromRGB(140, 80, 80) },
    ["Obsidian"]   = { Accent = Color3.fromRGB(160, 100, 255), Main = Color3.fromRGB(12, 10, 18),    Side = Color3.fromRGB(8, 6, 12),   Elem = Color3.fromRGB(18, 15, 25),    Text = Color3.fromRGB(230, 220, 255), TextDim = Color3.fromRGB(140, 120, 180) },
    ["Banania"]    = { Accent = Color3.fromRGB(255, 200, 60),  Main = Color3.fromRGB(22, 20, 12),    Side = Color3.fromRGB(15, 13, 8),  Elem = Color3.fromRGB(30, 28, 18),    Text = Color3.fromRGB(255, 245, 200), TextDim = Color3.fromRGB(180, 160, 120) },
    ["Sand"]       = { Accent = Color3.fromRGB(180, 120, 70),  Main = Color3.fromRGB(240, 230, 215), Side = Color3.fromRGB(225, 215, 195), Elem = Color3.fromRGB(245, 240, 225), Text = Color3.fromRGB(90, 60, 40),    TextDim = Color3.fromRGB(140, 110, 90) }
}
local ThemeNames = {"White", "Black", "None", "Diamond", "Sakura", "Emerald", "Forest", "Ruby", "Blood", "Obsidian", "Banania", "Sand"}
local SoundPacks = {"None", "Slime", "Phone", "Keyboards"}

local function SaveSettings()
    if writefile then pcall(function() writefile(ConfigFileName, HttpService:JSONEncode(CurrentSettings)) end) end
end
local function LoadSettings()
    if readfile and isfile and isfile(ConfigFileName) then
        pcall(function()
            local data = HttpService:JSONDecode(readfile(ConfigFileName))
            for k,v in pairs(data) do CurrentSettings[k] = v end
        end)
    end
end
LoadSettings()

local UIConfig = { WindowSize = UDim2.new(0, 760, 0, 520), ToggleKey = Enum.KeyCode[CurrentSettings.ToggleKey] or Enum.KeyCode.Insert }
local currentScale = (tonumber(CurrentSettings.MenuSize) or 100) / 100
local savedMenuPosition = UDim2.new(0.5, 0, 0.5, 0) 

-- Variables Globales Back-end
local walkSpeedEnabled, walkSpeedValue = false, 50
local flyEnabled, flySpeedValue = false, 50
local infJumpEnabled, doubleJumpEnabled, canDoubleJump, noClipEnabled = false, false, false, false
local speedConn, flyConn, noClipConn
local isBindingAny = false
local globalTpSpeed = 150

-- ==========================================
-- 1.5 ASSET DOWNLOADER & FONT SYSTEM
-- ==========================================
local getAsset = getcustomasset or getsynasset

local function downloadAsset(fileName, url)
    task.spawn(function()
        if not isfile or not isfile(fileName) then
            local s, r = pcall(function() return game:HttpGet(url) end)
            if s and r and writefile then writefile(fileName, r) end
        end
    end)
end

downloadAsset("Houfil_Slime.mp3", "https://raw.githubusercontent.com/CaveUser/Houfil/Sounds/slime.mp3")
downloadAsset("Houfil_Phone.mp3", "https://raw.githubusercontent.com/CaveUser/Houfil/Sounds/phone.mp3")
downloadAsset("Houfil_Keyboards.mp3", "https://raw.githubusercontent.com/CaveUser/Houfil/Sounds/keyboards.mp3")
downloadAsset("HoufilLogo.png", "https://i.goopics.net/4esrds.png")
downloadAsset("Chillax-Bold.otf", "https://raw.githubusercontent.com/CaveUser/Chillax/main/Fonts/OTF/Chillax-Bold.otf")

local Fonts = {
    ["Gotham"] = Enum.Font.GothamBold, ["Code"] = Enum.Font.Code, ["SciFi"] = Enum.Font.Michroma, ["Nunito"] = Enum.Font.Nunito,
    ["Ubuntu"] = Enum.Font.Ubuntu, ["Oswald"] = Enum.Font.Oswald
}
local FontNames = {"Gotham", "Chillax", "Code", "SciFi", "Nunito", "Ubuntu", "Oswald"}
local FontScales = { ["Chillax"] = 1.25, ["Code"] = 1.1, ["SciFi"] = 1.05 }

local function getFont(fontName)
    if fontName == "Chillax" then
        if getAsset and isfile and isfile("Chillax-Bold.otf") then
            local s, font = pcall(function() 
                local f = Font.new(getAsset("Chillax-Bold.otf"))
                f.Weight = Enum.FontWeight.Bold 
                return f
            end)
            if s and font then return font end
        end
        return Enum.Font.GothamBold
    end
    return Fonts[fontName] or Enum.Font.GothamBold
end

local function PlaySound(type)
    if not CurrentSettings.UISounds then return end
    local sound = Instance.new("Sound", SoundService)
    local duration = 0.7
    
    if type == "Hover" then
        sound.SoundId = "rbxassetid://6895086153"; sound.Volume = 0.2
    elseif type == "Click" then
        if CurrentSettings.SoundPack == "Slime" and getAsset and isfile and isfile("Houfil_Slime.mp3") then
            sound.SoundId = getAsset("Houfil_Slime.mp3"); sound.Volume = 0.3; duration = 0.6
        elseif CurrentSettings.SoundPack == "Phone" and getAsset and isfile and isfile("Houfil_Phone.mp3") then
            sound.SoundId = getAsset("Houfil_Phone.mp3"); sound.Volume = 0.8; duration = 0.5
        elseif CurrentSettings.SoundPack == "Keyboards" and getAsset and isfile and isfile("Houfil_Keyboards.mp3") then
            sound.SoundId = getAsset("Houfil_Keyboards.mp3"); sound.Volume = 0.8; duration = 0.7
        else
            sound.SoundId = "rbxassetid://6895050306"; sound.Volume = 0.4; sound.Pitch = 1.1
        end
    elseif type == "Open" then
        sound.SoundId = "rbxassetid://6895079853"; sound.Volume = 0.5
    elseif type == "Close" then
        sound.SoundId = "rbxassetid://6895079853"; sound.Volume = 0.4; sound.Pitch = 0.8
    end
    
    sound:Play()
    game:GetService("Debris"):AddItem(sound, duration)
end

local function AnimateClick(guiObject)
    task.spawn(function()
        local mouseLoc = UIS:GetMouseLocation()
        local x = mouseLoc.X - guiObject.AbsolutePosition.X
        local y = mouseLoc.Y - guiObject.AbsolutePosition.Y - 36 
        
        local ripple = Instance.new("Frame")
        ripple.Name = "Ripple"
        ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ripple.BackgroundTransparency = 0.6
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        ripple.Position = UDim2.new(0, x, 0, y)
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.ZIndex = guiObject.ZIndex + 1
        Instance.new("UICorner", ripple).CornerRadius = UDim.new(1, 0)
        
        guiObject.ClipsDescendants = true
        ripple.Parent = guiObject
        
        local maxSize = math.max(guiObject.AbsoluteSize.X, guiObject.AbsoluteSize.Y) * 1.5
        local tw = TweenService:Create(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, maxSize, 0, maxSize),
            BackgroundTransparency = 1
        })
        tw:Play()
        tw.Completed:Wait()
        ripple:Destroy()
    end)

    TweenService:Create(guiObject, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(guiObject.Size.X.Scale, guiObject.Size.X.Offset - 4, guiObject.Size.Y.Scale, guiObject.Size.Y.Offset - 4)}):Play()
    task.wait(0.1)
    TweenService:Create(guiObject, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(guiObject.Size.X.Scale, guiObject.Size.X.Offset + 4, guiObject.Size.Y.Scale, guiObject.Size.Y.Offset + 4)}):Play()
end

-- ==========================================
-- 2. DEV BACK-END LOGIC (Editor, Pathing, Self)
-- ==========================================

-- A. SELF EXPLOITS
local function updateSpeed()
    if speedConn then speedConn:Disconnect() end
    if walkSpeedEnabled then 
        speedConn = RunService.RenderStepped:Connect(function(deltaTime) 
            local char = player.Character; local hum = char and char:FindFirstChild("Humanoid"); local root = char and char:FindFirstChild("HumanoidRootPart")
            if char and hum and root and hum.Health > 0 then
                if hum.MoveDirection.Magnitude > 0 then
                    local extraSpeed = walkSpeedValue - hum.WalkSpeed
                    if extraSpeed > 0 then
                        local moveVector = hum.MoveDirection * (extraSpeed * deltaTime)
                        local rayParams = RaycastParams.new(); rayParams.FilterDescendantsInstances = {char}; rayParams.FilterType = Enum.RaycastFilterType.Exclude
                        local rayResult = workspace:Raycast(root.Position, moveVector * 1.5, rayParams)
                        if not rayResult then root.CFrame = root.CFrame + moveVector end
                    end
                end
            end 
        end)
    else 
        if player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.WalkSpeed = 16 end 
    end
end

UIS.JumpRequest:Connect(function() 
    if not player.Character or not player.Character:FindFirstChild("Humanoid") then return end
    local hum = player.Character.Humanoid
    if infJumpEnabled then hum:ChangeState(Enum.HumanoidStateType.Jumping)
    elseif doubleJumpEnabled then
        if hum:GetState() == Enum.HumanoidStateType.Freefall and canDoubleJump then
            canDoubleJump = false
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local state = player.Character.Humanoid:GetState()
        if state == Enum.HumanoidStateType.Landed or state == Enum.HumanoidStateType.Running then canDoubleJump = true end
    end
end)

local function enableNoClip()
    if noClipConn then noClipConn:Disconnect() end
    noClipConn = RunService.Stepped:Connect(function() 
        if player.Character then 
            for _, p in ipairs(player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end 
        end 
    end)
end

local function disableNoClip()
    if noClipConn then noClipConn:Disconnect() noClipConn = nil end
    if player.Character then 
        for _, p in ipairs(player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end 
    end
end

local function toggleFly()
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    local hum = char:FindFirstChild("Humanoid")

    if not flyEnabled then 
        if hum then hum.PlatformStand = false end
        root.Anchored = false
        return 
    end

    if hum then hum.PlatformStand = true end
    root.Anchored = true 

    flyConn = RunService.RenderStepped:Connect(function(deltaTime)
        local dir = Vector3.zero
        local cf = camera.CFrame
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cf.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cf.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cf.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cf.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.E) then dir += Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.Q) then dir -= Vector3.new(0, 1, 0) end
        if dir.Magnitude > 0 then
            dir = dir.Unit
            root.CFrame = root.CFrame + (dir * (flySpeedValue * deltaTime))
        end
    end)
end

local function GetFullPath(instance)
    local path = instance.Name
    local current = instance.Parent
    while current and current ~= game do
        path = current.Name .. "." .. path
        current = current.Parent
    end
    return path
end

-- ==========================================
-- B. MAP EDITOR 2.0 (YIELD SHIELD PRO)
-- ==========================================
local isEditingMap = false
local mapEditorConn = nil
local clickSelectConn = nil
local selectedPart = nil
local deletedPartsCache = {}
local deletedPathsExport = {}

local ui_infoName, ui_infoPath, ui_infoClass
local editorGui = Instance.new("Folder", CoreGui)
editorGui.Name = "HoufilEditorVisuals"

local hoverBox = Instance.new("SelectionBox")
hoverBox.Color3 = Color3.new(1, 1, 1)
hoverBox.LineThickness = 0.03
hoverBox.Parent = editorGui

local selectBox = Instance.new("SelectionBox")
selectBox.Color3 = Themes[CurrentSettings.Theme].Accent
selectBox.LineThickness = 0.1
selectBox.Parent = editorGui

local function updateEditorUI()
    if not ui_infoName or not ui_infoPath or not ui_infoClass then return end
    if not selectedPart then
        ui_infoName.Text = "No part selected"
        ui_infoPath.Text = "..."
        ui_infoClass.Text = "..."
        return
    end
    ui_infoName.Text = selectedPart.Name
    ui_infoPath.Text = GetFullPath(selectedPart)
    ui_infoClass.Text = selectedPart.ClassName
end

local function toggleMapEditor(state)
    isEditingMap = state
    if state then
        mapEditorConn = RunService.RenderStepped:Connect(function()
            if not isEditingMap then return end
            local target = mouse.Target
            if target and not target:IsDescendantOf(player.Character) and target.Parent ~= workspace.CurrentCamera then
                hoverBox.Adornee = target
            else
                hoverBox.Adornee = nil
            end
        end)
        
        clickSelectConn = mouse.Button1Down:Connect(function()
            if not isEditingMap then return end
            local mouseLoc = UIS:GetMouseLocation()
            local guis = player.PlayerGui:GetGuiObjectsAtPosition(mouseLoc.X, mouseLoc.Y)
            for _, gui in ipairs(guis) do if gui:IsDescendantOf(targetGui) then return end end

            local target = mouse.Target
            if target and not target:IsDescendantOf(player.Character) and target.Parent ~= workspace.CurrentCamera then
                selectedPart = target
                selectBox.Adornee = selectedPart
                updateEditorUI()
                PlaySound("Click")
            else
                selectedPart = nil
                selectBox.Adornee = nil
                updateEditorUI()
            end
        end)
    else
        if mapEditorConn then mapEditorConn:Disconnect(); mapEditorConn = nil end
        if clickSelectConn then clickSelectConn:Disconnect(); clickSelectConn = nil end
        hoverBox.Adornee = nil
        selectBox.Adornee = nil
        selectedPart = nil
        updateEditorUI()
    end
end

local function deleteSelected()
    if selectedPart then
        local pathStr = GetFullPath(selectedPart)
        table.insert(deletedPathsExport, pathStr)
        table.insert(deletedPartsCache, {part = selectedPart, parent = selectedPart.Parent, path = pathStr, cf = selectedPart.CFrame})
        selectedPart.Parent = nil 
        selectedPart = nil
        selectBox.Adornee = nil
        hoverBox.Adornee = nil
        updateEditorUI()
        PlaySound("Hover")
    end
end

local function undoLastDelete()
    if #deletedPartsCache > 0 then
        local lastDeleted = table.remove(deletedPartsCache, #deletedPartsCache)
        if lastDeleted and lastDeleted.part then
            lastDeleted.part.Parent = lastDeleted.parent
            lastDeleted.part.CFrame = lastDeleted.cf
            for i, p in ipairs(deletedPathsExport) do
                if p == lastDeleted.path then table.remove(deletedPathsExport, i) break end
            end
            PlaySound("Click")
        end
    end
end

local function exportDeletedParts()
    if writefile then
        pcall(function() 
            writefile("Houfil_DeletedParts.json", HttpService:JSONEncode(deletedPathsExport))
            PlaySound("Open")
        end)
    end
end

local function tpToSelected()
    if selectedPart and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = selectedPart.CFrame + Vector3.new(0, (selectedPart.Size.Y/2) + 3, 0)
        PlaySound("Open")
    end
end

local function bringSelected()
    if selectedPart and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        selectedPart.CFrame = player.Character.HumanoidRootPart.CFrame + (player.Character.HumanoidRootPart.CFrame.LookVector * 5)
        PlaySound("Hover")
    end
end

local function moveSelected(axis, amount)
    if selectedPart then
        local moveVec = Vector3.new(axis == "X" and amount or 0, axis == "Y" and amount or 0, axis == "Z" and amount or 0)
        selectedPart.CFrame = selectedPart.CFrame + moveVec
    end
end

-- ==========================================
-- C. Path Tracker (SMART ANTI-SPIKE & FLOOR ALIGN)
-- ==========================================
local isRecordingPath = false
local isPlayingPath = false
local pathPoints = {}
local pathVisualsFolder = Instance.new("Folder", workspace)
pathVisualsFolder.Name = "Houfil_PathVisuals"

local recordConn = nil
local lastRecordedPos = nil
local recordDistance = 3 

local function drawLine(pos1, pos2)
    -- Ajustement au sol (-2.5 studs depuis le centre du joueur)
    local offset = Vector3.new(0, 2.5, 0)
    local p1 = pos1 - offset
    local p2 = pos2 - offset

    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
    part.Material = Enum.Material.Neon
    part.Color = Color3.fromRGB(0, 255, 150)
    part.Size = Vector3.new(0.2, 0.2, (p1 - p2).Magnitude)
    part.CFrame = CFrame.lookAt(p1, p2) * CFrame.new(0, 0, -part.Size.Z / 2)
    part.Parent = pathVisualsFolder
end

local function togglePathRecording(state)
    isRecordingPath = state
    if state then
        if recordConn then recordConn:Disconnect() end
        lastRecordedPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position
        
        recordConn = RunService.Heartbeat:Connect(function()
            if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
            local currentPos = player.Character.HumanoidRootPart.Position
            
            if lastRecordedPos then
                local dist = (currentPos - lastRecordedPos).Magnitude
                if dist > 80 then
                    isRecordingPath = false
                    if recordConn then recordConn:Disconnect(); recordConn = nil end
                    PlaySound("Close")
                    return
                elseif dist >= recordDistance then
                    table.insert(pathPoints, player.Character.HumanoidRootPart.CFrame)
                    drawLine(lastRecordedPos, currentPos)
                    lastRecordedPos = currentPos
                end
            else
                table.insert(pathPoints, player.Character.HumanoidRootPart.CFrame)
                lastRecordedPos = currentPos
            end
        end)
    else
        if recordConn then recordConn:Disconnect(); recordConn = nil end
    end
end

local function clearPath()
    pathPoints = {}
    pathVisualsFolder:ClearAllChildren()
    PlaySound("Hover")
end

local function playPath(tpSpeed)
    if isPlayingPath or #pathPoints == 0 then return end
    isPlayingPath = true
    task.spawn(function()
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then isPlayingPath = false; return end

        for _, p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end

        for i, targetCFrame in ipairs(pathPoints) do
            if not isPlayingPath then break end
            
            if i == #pathPoints then
                root.CFrame = targetCFrame * CFrame.new(0, 3, 0)
                for _, p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end
                if char:FindFirstChild("Humanoid") then char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
                task.wait(0.5)
                break
            end
            
            local reached = false
            while isPlayingPath and root and root.Parent and not reached do
                local dt = RunService.Heartbeat:Wait()
                local dist = (targetCFrame.Position - root.Position).Magnitude
                if dist < 2 then reached = true else
                    local dir = (targetCFrame.Position - root.Position).Unit
                    root.CFrame = root.CFrame + (dir * (tpSpeed * dt))
                    root.Velocity = Vector3.zero
                    root.RotVelocity = Vector3.zero
                end
            end
        end

        for _, p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end
        isPlayingPath = false
        PlaySound("Open")
    end)
end

local function stopPlayingPath()
    isPlayingPath = false
end

local function savePathToFile(filename)
    if not writefile then return end
    local saveTable = {}
    for i, cf in ipairs(pathPoints) do table.insert(saveTable, {cf.X, cf.Y, cf.Z, cf.Pitch, cf.Yaw, cf.Roll}) end
    pcall(function() writefile(filename .. ".json", HttpService:JSONEncode(saveTable)) end)
    PlaySound("Click")
end

-- D. Purge & Unload System
local function purgeAllFiles()
    local filesToPurge = {ConfigFileName, "Houfil_DeletedParts.json"}
    for _, file in ipairs(filesToPurge) do
        if isfile and isfile(file) and delfile then pcall(function() delfile(file) end) end
    end
    PlaySound("Close")
end

local function CompletelyUnload()
    isEditingMap = false
    isRecordingPath = false
    isPlayingPath = false
    walkSpeedEnabled = false
    flyEnabled = false
    noClipEnabled = false

    if speedConn then speedConn:Disconnect() end
    if flyConn then flyConn:Disconnect() end
    if noClipConn then noClipConn:Disconnect() end
    if mapEditorConn then mapEditorConn:Disconnect() end
    if clickSelectConn then clickSelectConn:Disconnect() end
    if recordConn then recordConn:Disconnect() end
    
    pcall(function()
        local char = player.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then root.Anchored = false end
            local hum = char:FindFirstChild("Humanoid")
            if hum then hum.PlatformStand = false end
            for _, p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end
        end
    end)
    
    pcall(function()
        if editorGui then editorGui:Destroy() end
        if pathVisualsFolder then pathVisualsFolder:Destroy() end
        if targetGui:FindFirstChild("HoufilPremium") then targetGui.HoufilPremium:Destroy() end 
        if targetGui:FindFirstChild("HoufilOverlay") then targetGui.HoufilOverlay:Destroy() end
    end)
    PlaySound("Close")
end

-- ==========================================
-- 3. MOTEUR UI (ANIMATIONS MEGA & SAAS)
-- ==========================================
local screenGui = Instance.new("ScreenGui", targetGui); screenGui.Name = "HoufilDevEngine"; screenGui.DisplayOrder = 100 

local mainFrame = Instance.new("CanvasGroup", screenGui); mainFrame.Size = UIConfig.WindowSize; mainFrame.Position = savedMenuPosition; mainFrame.AnchorPoint = Vector2.new(0.5, 0.5); mainFrame.BorderSizePixel = 0; mainFrame:SetAttribute("BgRole", "Main")
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
mainFrame.GroupTransparency = 1 
mainFrame.Visible = false
local uiScale = Instance.new("UIScale", mainFrame); uiScale.Scale = 0.5

local sidebar = Instance.new("Frame", mainFrame); sidebar.Size = UDim2.new(0, 200, 1, 0); sidebar.BorderSizePixel = 0; sidebar:SetAttribute("BgRole", "Side"); Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 12)

local logoBtn = Instance.new("TextButton", sidebar); logoBtn.Size = UDim2.new(0, 40, 0, 40); logoBtn.Position = UDim2.new(0, 15, 0, 15); logoBtn.BackgroundTransparency = 1; logoBtn.Text = ""
local logoImg = Instance.new("ImageLabel", logoBtn); logoImg.Size = UDim2.new(1, 0, 1, 0); logoImg.BackgroundTransparency = 1; logoImg.ScaleType = Enum.ScaleType.Fit
task.spawn(function()
    task.wait(1)
    if getAsset and isfile and isfile("HoufilLogo.png") then logoImg.Image = getAsset("HoufilLogo.png") else logoImg.Image = "rbxassetid://10629237000" end
end)
logoBtn.MouseEnter:Connect(function() PlaySound("Hover"); TweenService:Create(logoImg, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Rotation = 15}):Play() end)
logoBtn.MouseLeave:Connect(function() TweenService:Create(logoImg, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Rotation = 0}):Play() end)

local hubName = Instance.new("TextLabel", sidebar); hubName.Size = UDim2.new(1, -80, 0, 40); hubName.Position = UDim2.new(0, 65, 0, 15); hubName.BackgroundTransparency = 1; hubName.Text = "Houfil Dev"; hubName:SetAttribute("TextRole", "Text"); hubName:SetAttribute("BaseTextSize", 20); hubName.TextXAlignment = Enum.TextXAlignment.Left

local shineLbl = Instance.new("TextLabel", hubName); shineLbl.Size = UDim2.new(1, 0, 1, 0); shineLbl.BackgroundTransparency = 1; shineLbl.Text = "Houfil Dev"; shineLbl.TextXAlignment = Enum.TextXAlignment.Left; shineLbl.ZIndex = 2
local shineGrad = Instance.new("UIGradient", shineLbl); shineGrad.Rotation = 45; shineGrad.Offset = Vector2.new(-1, 0)
shineGrad.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1) })
task.spawn(function() while task.wait(3) do shineGrad.Offset = Vector2.new(-1, 0); TweenService:Create(shineGrad, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {Offset = Vector2.new(1, 0)}):Play() end end)

local navList = Instance.new("ScrollingFrame", sidebar); navList.Size = UDim2.new(1, 0, 1, -125); navList.Position = UDim2.new(0, 0, 0, 125); navList.BackgroundTransparency = 1; navList.ScrollBarThickness = 0
local navLayout = Instance.new("UIListLayout", navList); navLayout.Padding = UDim.new(0, 6); navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local container = Instance.new("Frame", mainFrame); container.Size = UDim2.new(1, -220, 1, 0); container.Position = UDim2.new(0, 220, 0, 0); container.BackgroundTransparency = 1

local topBar = Instance.new("Frame", container); topBar.Size = UDim2.new(1, 0, 0, 60); topBar.BackgroundTransparency = 1
local activeTabName = Instance.new("TextLabel", topBar); activeTabName.Size = UDim2.new(0, 150, 1, 0); activeTabName.Position = UDim2.new(0, 0, 0, 0); activeTabName.BackgroundTransparency = 1; activeTabName.Text = "Home"; activeTabName:SetAttribute("TextRole", "Text"); activeTabName:SetAttribute("BaseTextSize", 26); activeTabName.TextXAlignment = Enum.TextXAlignment.Left

local searchFrame = Instance.new("Frame", topBar); searchFrame.Size = UDim2.new(0, 180, 0, 36); searchFrame.Position = UDim2.new(0.5, -90, 0.5, -18); searchFrame:SetAttribute("BgRole", "Elem"); Instance.new("UICorner", searchFrame).CornerRadius = UDim.new(0, 8)
local searchIcon = Instance.new("ImageLabel", searchFrame); searchIcon.Size = UDim2.new(0, 16, 0, 16); searchIcon.Position = UDim2.new(0, 10, 0.5, -8); searchIcon.Image = "rbxassetid://7733654492"; searchIcon.BackgroundTransparency = 1; searchIcon:SetAttribute("IconRole", "Search")
local searchBox = Instance.new("TextBox", searchFrame); searchBox.Size = UDim2.new(1, -35, 1, 0); searchBox.Position = UDim2.new(0, 30, 0, 0); searchBox.BackgroundTransparency = 1; searchBox.PlaceholderText = "Search..."; searchBox.Text = ""; searchBox:SetAttribute("TextRole", "Text"); searchBox:SetAttribute("BaseTextSize", 13); searchBox.TextXAlignment = Enum.TextXAlignment.Left

local profileFrame = Instance.new("Frame", topBar); profileFrame.Size = UDim2.new(0, 150, 1, 0); profileFrame.Position = UDim2.new(1, -160, 0, 0); profileFrame.BackgroundTransparency = 1
local avatarImg = Instance.new("ImageLabel", profileFrame); avatarImg.Size = UDim2.new(0, 34, 0, 34); avatarImg.Position = UDim2.new(1, -34, 0.5, -17); Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0); avatarImg.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
local nameLbl = Instance.new("TextLabel", profileFrame); nameLbl.Size = UDim2.new(1, -45, 0, 20); nameLbl.Position = UDim2.new(0, 0, 0, 10); nameLbl.BackgroundTransparency = 1; nameLbl.Text = player.DisplayName; nameLbl.TextXAlignment = Enum.TextXAlignment.Right; nameLbl:SetAttribute("TextRole", "Text"); nameLbl:SetAttribute("BaseTextSize", 14)
local pingLbl = Instance.new("TextLabel", profileFrame); pingLbl.Size = UDim2.new(1, -45, 0, 15); pingLbl.Position = UDim2.new(0, 0, 0, 32); pingLbl.BackgroundTransparency = 1; pingLbl.Text = "0 ms"; pingLbl.TextXAlignment = Enum.TextXAlignment.Right; pingLbl:SetAttribute("TextRole", "Accent"); pingLbl:SetAttribute("BaseTextSize", 11)

task.spawn(function()
    while task.wait(1) do
        pcall(function() pingLbl.Text = math.floor(player:GetNetworkPing() * 1000) .. " ms" end)
    end
end)

local versionLbl = Instance.new("TextLabel", mainFrame); versionLbl.Size = UDim2.new(0, 300, 0, 20); versionLbl.Position = UDim2.new(1, -15, 1, -10); versionLbl.AnchorPoint = Vector2.new(1, 1); versionLbl.BackgroundTransparency = 1; versionLbl.Text = "V.3.5.0 | Aligned Edition"; versionLbl.TextXAlignment = Enum.TextXAlignment.Right; versionLbl:SetAttribute("TextRole", "TextDim"); versionLbl:SetAttribute("BaseTextSize", 11)

local function ApplyTheme()
    pcall(function()
        local t = Themes[CurrentSettings.Theme] or Themes["Obsidian"]
        local f = getFont(CurrentSettings.Font)
        local offset = tonumber(CurrentSettings.TextSizeOffset) or 1
        local fScale = FontScales[CurrentSettings.Font] or 1
        currentScale = (tonumber(CurrentSettings.MenuSize) or 100) / 100

        local opacity = tonumber(CurrentSettings.Opacity) or 0.40

        mainFrame.Size = UDim2.new(0, 760 * currentScale, 0, 520 * currentScale)
        mainFrame.BackgroundColor3 = t.Main
        sidebar.BackgroundColor3 = t.Side
        sidebar.BackgroundTransparency = opacity
        selectBox.Color3 = t.Accent
        
        if typeof(f) == "Font" then shineLbl.FontFace = f else shineLbl.Font = f end
        shineLbl.TextSize = (math.floor(20 * fScale) + offset) * currentScale
        shineLbl.TextColor3 = t.Accent

        for _, obj in ipairs(screenGui:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                if obj ~= shineLbl then
                    if typeof(f) == "Font" then obj.FontFace = f else obj.Font = f end
                    local bSize = obj:GetAttribute("BaseTextSize")
                    if bSize then obj.TextSize = (math.floor(tonumber(bSize) * fScale) + offset) * currentScale end
                end
            end

            if obj:IsA("GuiObject") then
                local txtRole = obj:GetAttribute("TextRole")
                if txtRole == "Text" then obj.TextColor3 = t.Text elseif txtRole == "TextDim" then obj.TextColor3 = t.TextDim elseif txtRole == "Accent" then obj.TextColor3 = t.Accent elseif txtRole == "Main" then obj.TextColor3 = t.Main end
                
                local bgRole = obj:GetAttribute("BgRole")
                if bgRole == "Main" then obj.BackgroundColor3 = t.Main; obj.BackgroundTransparency = opacity elseif bgRole == "Side" then obj.BackgroundColor3 = t.Side; obj.BackgroundTransparency = opacity elseif bgRole == "Elem" then obj.BackgroundColor3 = t.Elem; obj.BackgroundTransparency = opacity elseif bgRole == "AccentBg" then obj.BackgroundColor3 = t.Accent; obj.BackgroundTransparency = 0 
                elseif bgRole == "TogglePill" then obj.BackgroundColor3 = obj:GetAttribute("ToggleState") and t.Accent or t.TextDim; obj.BackgroundTransparency = 0 
                elseif bgRole == "TabBtn" then obj.BackgroundTransparency = obj:GetAttribute("IsActive") and opacity or 1 if obj:GetAttribute("IsActive") then obj.BackgroundColor3 = t.Elem end end
            end
            
            if obj:IsA("ImageLabel") then
                if obj.Parent and obj.Parent:GetAttribute("BgRole") == "TabBtn" then obj.ImageColor3 = t.Text
                elseif obj:GetAttribute("IconRole") == "Search" then obj.ImageColor3 = t.TextDim end
            end
        end
    end)
end

local isMenuOpen = false
local function ToggleMenu(state)
    isMenuOpen = state
    if state then
        mainFrame.Visible = true; PlaySound("Open")
        uiScale.Scale = 0.4
        mainFrame.Position = UDim2.new(savedMenuPosition.X.Scale, savedMenuPosition.X.Offset, savedMenuPosition.Y.Scale, savedMenuPosition.Y.Offset + 100)
        TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = savedMenuPosition, GroupTransparency = 0}):Play()
        TweenService:Create(uiScale, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
    else
        PlaySound("Close")
        local targetPos = UDim2.new(savedMenuPosition.X.Scale, savedMenuPosition.X.Offset, savedMenuPosition.Y.Scale, savedMenuPosition.Y.Offset + 60)
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Position = targetPos, GroupTransparency = 1})
        TweenService:Create(uiScale, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Scale = 0.6}):Play()
        tween:Play()
        tween.Completed:Once(function() if not isMenuOpen then mainFrame.Visible = false end end)
    end
end

-- UI FACTORY FUNCTIONS
local Pages, currentTab, tabFunctions = {}, nil, {} 

local function AddHoverAnim(btn)
    btn.MouseEnter:Connect(function() PlaySound("Hover"); TweenService:Create(btn, TweenInfo.new(0.2), {Size = UDim2.new(btn.Size.X.Scale, btn.Size.X.Offset + 2, btn.Size.Y.Scale, btn.Size.Y.Offset)}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {Size = UDim2.new(btn.Size.X.Scale, btn.Size.X.Offset - 2, btn.Size.Y.Scale, btn.Size.Y.Offset)}):Play() end)
end

local function CreateTab(name, iconId)
    local btn = Instance.new("TextButton", navList); btn.Size = UDim2.new(1, -30, 0, 40); btn.BackgroundTransparency = 1; btn.Text = ""; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10); btn:SetAttribute("BgRole", "TabBtn"); btn:SetAttribute("IsActive", false)
    local icon = Instance.new("ImageLabel", btn); icon.Size = UDim2.new(0, 18, 0, 18); icon.Position = UDim2.new(0, 10, 0.5, -9); icon.Image = "rbxassetid://"..iconId; icon.BackgroundTransparency = 1
    local lbl = Instance.new("TextLabel", btn); lbl.Size = UDim2.new(1, -45, 1, 0); lbl.Position = UDim2.new(0, 35, 0, 0); lbl.BackgroundTransparency = 1; lbl.Text = name; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl:SetAttribute("TextRole", "TextDim"); lbl:SetAttribute("BaseTextSize", 16)
    
    local page = Instance.new("ScrollingFrame", container); page.Size = UDim2.new(1, 0, 1, -70); page.Position = UDim2.new(0, 0, 0, 70); page.BackgroundTransparency = 1; page.ScrollBarThickness = 2; page.Visible = false; local pageLayout = Instance.new("UIListLayout", page); pageLayout.Padding = UDim.new(0, 10)
    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20) end)
    Pages[name] = page

    local function activate()
        if currentTab and currentTab.btn == btn then return end
        PlaySound("Click"); AnimateClick(btn)
        for n, p in pairs(Pages) do 
            if n == name then
                p.Visible = true; p.Position = UDim2.new(0, 30, 0, 70)
                TweenService:Create(p, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 70)}):Play()
            else p.Visible = false end
        end
        if currentTab then currentTab.btn:SetAttribute("IsActive", false); currentTab.lbl:SetAttribute("TextRole", "TextDim") end
        btn:SetAttribute("IsActive", true); lbl:SetAttribute("TextRole", "Text"); activeTabName.Text = name; currentTab = {btn = btn, lbl = lbl, page = page}; ApplyTheme()
    end
    tabFunctions[name] = activate; btn.MouseButton1Click:Connect(activate)
    AddHoverAnim(btn)
    return page
end

logoBtn.MouseButton1Click:Connect(function() PlaySound("Click"); if tabFunctions["Home"] then tabFunctions["Home"]() end end)

local function CreateSection(page, text, defaultOpen)
    local section = Instance.new("Frame", page); section.Size = UDim2.new(1, -10, 0, 45); section.ClipsDescendants = true; section:SetAttribute("BgRole", "Elem"); section:SetAttribute("IsSection", true); Instance.new("UICorner", section).CornerRadius = UDim.new(0, 10)
    local btn = Instance.new("TextButton", section); btn.Size = UDim2.new(1, 0, 0, 45); btn.BackgroundTransparency = 1; btn.Text = ""
    local lbl = Instance.new("TextLabel", btn); lbl.Size = UDim2.new(1, -30, 1, 0); lbl.Position = UDim2.new(0, 15, 0, 0); lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl:SetAttribute("TextRole", "Text"); lbl:SetAttribute("BaseTextSize", 16)
    local icon = Instance.new("TextLabel", btn); icon.Size = UDim2.new(0, 20, 1, 0); icon.Position = UDim2.new(1, -25, 0, 0); icon.BackgroundTransparency = 1; icon.Text = defaultOpen and "▼" or "▶"; icon:SetAttribute("TextRole", "TextDim"); icon:SetAttribute("BaseTextSize", 14)
    
    local content = Instance.new("Frame", section); content.Name = "ContentFrame"; content.Size = UDim2.new(1, 0, 0, 0); content.Position = UDim2.new(0, 0, 0, 45); content.BackgroundTransparency = 1; local layout = Instance.new("UIListLayout", content); layout.Padding = UDim.new(0, 5); layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local isOpen = defaultOpen == true
    local function updateSize()
        if isOpen then
            local cHeight = layout.AbsoluteContentSize.Y + 15 
            TweenService:Create(section, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, -10, 0, 45 + cHeight)}):Play()
            content.Size = UDim2.new(1, 0, 0, cHeight)
        else
            TweenService:Create(section, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, -10, 0, 45)}):Play()
        end
    end
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() if isOpen then updateSize() end end)
    btn.MouseButton1Click:Connect(function() PlaySound("Click"); isOpen = not isOpen; icon.Text = isOpen and "▼" or "▶"; updateSize(); task.delay(0.3, function() if currentTab then local mL = currentTab.page:FindFirstChildOfClass("UIListLayout"); if mL then currentTab.page.CanvasSize = UDim2.new(0, 0, 0, mL.AbsoluteContentSize.Y + 20) end end end) end)
    task.delay(0.1, function() if defaultOpen then updateSize() end end)
    return content
end

local function CreateRow(page, height)
    local row = Instance.new("Frame", page); row.Size = UDim2.new(1, -10, 0, height or 45); row.BackgroundTransparency = 1; row:SetAttribute("IsRow", true)
    return row
end

local function CreateParagraph(page, text)
    local row = CreateRow(page, 50)
    local lbl = Instance.new("TextLabel", row); lbl.Size = UDim2.new(1, -20, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0); lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.TextWrapped = true; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl:SetAttribute("TextRole", "TextDim"); lbl:SetAttribute("BaseTextSize", 13)
    return lbl
end

-- Nouveau widget avec de meilleures proportions (0.4 / 0.55) pour alignement parfait
local function CreateInfoRow(page, text, defaultVal)
    local row = CreateRow(page, 45)
    local lbl = Instance.new("TextLabel", row); lbl.Size = UDim2.new(0.4, 0, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0); lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl:SetAttribute("TextRole", "TextDim"); lbl:SetAttribute("BaseTextSize", 14)
    local valBg = Instance.new("Frame", row); valBg.Size = UDim2.new(0.55, 0, 0, 32); valBg.Position = UDim2.new(1, -10, 0.5, -16); valBg.AnchorPoint = Vector2.new(1, 0); valBg:SetAttribute("BgRole", "Main"); Instance.new("UICorner", valBg).CornerRadius = UDim.new(0, 8)
    local valLbl = Instance.new("TextLabel", valBg); valLbl.Size = UDim2.new(1, -20, 1, 0); valLbl.Position = UDim2.new(0, 10, 0, 0); valLbl.BackgroundTransparency = 1; valLbl.Text = tostring(defaultVal); valLbl.TextTruncate = Enum.TextTruncate.AtEnd; valLbl.TextXAlignment = Enum.TextXAlignment.Left; valLbl:SetAttribute("TextRole", "Accent"); valLbl:SetAttribute("BaseTextSize", 12)
    return valLbl
end

local function CreateInput(page, text, placeholder, default, callback)
    local row = CreateRow(page, 45)
    local lbl = Instance.new("TextLabel", row); lbl.Size = UDim2.new(0.4, 0, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0); lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl:SetAttribute("TextRole", "TextDim"); lbl:SetAttribute("BaseTextSize", 14)
    local inputBg = Instance.new("Frame", row); inputBg.Size = UDim2.new(0.55, 0, 0, 32); inputBg.Position = UDim2.new(1, -10, 0.5, -16); inputBg.AnchorPoint = Vector2.new(1, 0); inputBg:SetAttribute("BgRole", "Main"); Instance.new("UICorner", inputBg).CornerRadius = UDim.new(0, 8)
    local box = Instance.new("TextBox", inputBg); box.Size = UDim2.new(1, -20, 1, 0); box.Position = UDim2.new(0, 10, 0, 0); box.BackgroundTransparency = 1; box.Text = tostring(default); box.PlaceholderText = placeholder; box.TextTruncate = Enum.TextTruncate.AtEnd; box.TextXAlignment = Enum.TextXAlignment.Left; box:SetAttribute("TextRole", "Accent"); box:SetAttribute("BaseTextSize", 12)
    box.FocusLost:Connect(function() PlaySound("Click"); if callback then callback(box.Text) end end)
    return box
end

local function CreateToggle(page, text, default, callback)
    local row = CreateRow(page, 45); local state = default
    local lbl = Instance.new("TextLabel", row); lbl.Size = UDim2.new(0.7, 0, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0); lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl:SetAttribute("TextRole", "TextDim"); lbl:SetAttribute("BaseTextSize", 14)
    local btn = Instance.new("TextButton", row); btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1; btn.Text = ""
    local pill = Instance.new("Frame", row); pill.Size = UDim2.new(0, 42, 0, 22); pill.Position = UDim2.new(1, -52, 0.5, -11); pill:SetAttribute("BgRole", "TogglePill"); pill:SetAttribute("ToggleState", state); Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
    local circle = Instance.new("Frame", pill); circle.Size = UDim2.new(0, 16, 0, 16); circle.Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8); circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    
    btn.MouseEnter:Connect(function() PlaySound("Hover") end)
    btn.MouseButton1Click:Connect(function() PlaySound("Click"); AnimateClick(pill); state = not state; pill:SetAttribute("ToggleState", state); TweenService:Create(circle, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}):Play(); ApplyTheme(); callback(state) end)
    return function(newState) state = newState; pill:SetAttribute("ToggleState", state); TweenService:Create(circle, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}):Play(); ApplyTheme() end
end

local function CreateSlider(page, text, min, max, default, callback)
    local row = CreateRow(page, 55)
    local lbl = Instance.new("TextLabel", row); lbl.Size = UDim2.new(0.5, 0, 0, 25); lbl.Position = UDim2.new(0, 10, 0, 5); lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl:SetAttribute("TextRole", "TextDim"); lbl:SetAttribute("BaseTextSize", 14)
    local valLbl = Instance.new("TextLabel", row); valLbl.Size = UDim2.new(0.4, 0, 0, 25); valLbl.Position = UDim2.new(1, -50, 0, 5); valLbl.BackgroundTransparency = 1; valLbl.Text = tostring(default); valLbl.TextXAlignment = Enum.TextXAlignment.Right; valLbl:SetAttribute("TextRole", "Accent"); valLbl:SetAttribute("BaseTextSize", 13)
    local sliderBg = Instance.new("TextButton", row); sliderBg.Size = UDim2.new(1, -20, 0, 6); sliderBg.Position = UDim2.new(0, 10, 0, 35); sliderBg.Text = ""; sliderBg:SetAttribute("BgRole", "Main"); Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", sliderBg); fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0); fill:SetAttribute("BgRole", "AccentBg"); Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local dragging = false
    local function update()
        local pos = math.clamp((UIS:GetMouseLocation().X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + ((max - min) * pos))
        TweenService:Create(fill, TweenInfo.new(0.1), {Size = UDim2.new(pos, 0, 1, 0)}):Play(); valLbl.Text = tostring(val); callback(val)
    end
    sliderBg.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; PlaySound("Click"); AnimateClick(sliderBg) end end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    RunService.RenderStepped:Connect(function() if dragging then update() end end)
end

local function CreateButton(page, text, callback)
    local row = CreateRow(page, 45)
    local btn = Instance.new("TextButton", row); btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1; btn.Text = text; btn:SetAttribute("TextRole", "Accent"); btn:SetAttribute("BaseTextSize", 15)
    btn.MouseEnter:Connect(function() PlaySound("Hover"); TweenService:Create(btn, TweenInfo.new(0.2), {TextSize = 16}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {TextSize = 15}):Play() end)
    btn.MouseButton1Click:Connect(function() PlaySound("Click"); AnimateClick(btn); if callback then callback() end end)
end

local function CreateKeybind(page, text, defaultKey, callback)
    local row = CreateRow(page, 45); local currentKey = defaultKey
    local lbl = Instance.new("TextLabel", row); lbl.Size = UDim2.new(0.4, 0, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0); lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl:SetAttribute("TextRole", "TextDim"); lbl:SetAttribute("BaseTextSize", 14)
    local btn = Instance.new("TextButton", row); btn.Size = UDim2.new(0.55, 0, 0, 32); btn.Position = UDim2.new(1, -10, 0.5, -16); btn.AnchorPoint = Vector2.new(1, 0); btn:SetAttribute("BgRole", "Main"); btn.Text = currentKey.Name; btn:SetAttribute("TextRole", "Text"); btn:SetAttribute("BaseTextSize", 12); Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local isBinding = false
    btn.MouseButton1Click:Connect(function() PlaySound("Click"); AnimateClick(btn); isBinding = true; isBindingAny = true; btn.Text = "Press Key..."; btn:SetAttribute("TextRole", "Accent"); ApplyTheme() end)
    UIS.InputBegan:Connect(function(input)
        if isBinding and input.UserInputType == Enum.UserInputType.Keyboard then
            currentKey = input.KeyCode; btn.Text = currentKey.Name; btn:SetAttribute("TextRole", "Text"); isBinding = false; task.wait(0.1); isBindingAny = false; ApplyTheme(); PlaySound("Click")
            if callback then callback(currentKey) end
        end
    end)
end

local function CreateDropdown(page, text, options, default, callback)
    local current = default or options[1]
    local row = CreateRow(page, 45); row.ClipsDescendants = true
    local lbl = Instance.new("TextLabel", row); lbl.Size = UDim2.new(0.4, 0, 0, 45); lbl.Position = UDim2.new(0, 10, 0, 0); lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl:SetAttribute("TextRole", "TextDim"); lbl:SetAttribute("BaseTextSize", 14)
    local btn = Instance.new("TextButton", row); btn.Size = UDim2.new(0.55, 0, 0, 32); btn.Position = UDim2.new(1, -10, 0, 6); btn.AnchorPoint = Vector2.new(1, 0); btn.Text = ""; btn:SetAttribute("BgRole", "Main"); Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local valTxt = Instance.new("TextLabel", btn); valTxt.Size = UDim2.new(1, -30, 1, 0); valTxt.Position = UDim2.new(0, 10, 0, 0); valTxt.BackgroundTransparency = 1; valTxt.TextXAlignment = Enum.TextXAlignment.Left; valTxt:SetAttribute("TextRole", "Text"); valTxt:SetAttribute("BaseTextSize", 13)
    local icon = Instance.new("TextLabel", btn); icon.Size = UDim2.new(0, 20, 1, 0); icon.Position = UDim2.new(1, -20, 0, 0); icon.BackgroundTransparency = 1; icon.Text = "▼"; icon:SetAttribute("TextRole", "TextDim"); icon:SetAttribute("BaseTextSize", 11)
    local list = Instance.new("Frame", row); list.Size = UDim2.new(1, -20, 0, 0); list.Position = UDim2.new(0, 10, 0, 50); list.BackgroundTransparency = 1; local layout = Instance.new("UIListLayout", list); layout.Padding = UDim.new(0, 5)
    local open = false
    
    local function updateSize() TweenService:Create(row, TweenInfo.new(0.2), {Size = UDim2.new(1, -10, 0, open and (layout.AbsoluteContentSize.Y + 60) or 45)}):Play() end
    btn.MouseEnter:Connect(function() PlaySound("Hover") end)
    btn.MouseButton1Click:Connect(function() PlaySound("Click"); AnimateClick(btn); open = not open; icon.Text = open and "▲" or "▼"; updateSize() end)
    
    local DropdownAPI = {}
    function DropdownAPI:Refresh(newOptions)
        for _, child in ipairs(list:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
        current = newOptions[1] or ""; valTxt.Text = tostring(current); if callback then callback(current) end
        for _, opt in ipairs(newOptions) do
            local oBtn = Instance.new("TextButton", list); oBtn.Size = UDim2.new(1, 0, 0, 28); oBtn.Text = "  " .. opt; oBtn.TextXAlignment = Enum.TextXAlignment.Left; oBtn:SetAttribute("BgRole", "Main"); Instance.new("UICorner", oBtn).CornerRadius = UDim.new(0, 6); oBtn:SetAttribute("TextRole", "Text"); oBtn:SetAttribute("BaseTextSize", 13)
            oBtn.MouseEnter:Connect(function() PlaySound("Hover") end)
            oBtn.MouseButton1Click:Connect(function() PlaySound("Click"); current = opt; valTxt.Text = opt; open = false; icon.Text = "▼"; updateSize(); ApplyTheme(); if callback then callback(opt) end end)
        end
        if open then updateSize() end; ApplyTheme() 
    end
    DropdownAPI:Refresh(options)
    if default and table.find(options, default) then valTxt.Text = tostring(default); if callback then callback(default) end end
    return DropdownAPI
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local filter = string.lower(searchBox.Text)
    if currentTab then
        for _, section in ipairs(currentTab.page:GetChildren()) do
            if section:GetAttribute("IsSection") then
                local hasVisibleRow = false; local secBtn = section:FindFirstChildOfClass("TextButton"); local secTitleLabel = secBtn and secBtn:FindFirstChildOfClass("TextLabel")
                local titleMatches = secTitleLabel and string.find(string.lower(secTitleLabel.Text), filter) ~= nil
                for _, row in ipairs(section:GetDescendants()) do
                    if row:GetAttribute("IsRow") then
                        local label = row:FindFirstChildOfClass("TextLabel")
                        if label then
                            local rowMatches = string.find(string.lower(label.Text), filter) ~= nil
                            if filter == "" or titleMatches or rowMatches then row.Visible = true; hasVisibleRow = true else row.Visible = false end
                        end
                    end
                end
                section.Visible = filter == "" or titleMatches or hasVisibleRow
            end
        end
        local pageLayout = currentTab.page:FindFirstChildOfClass("UIListLayout")
        if pageLayout then currentTab.page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20) end
    end
end)

-- ==========================================
-- 4. BUILDING THE DEV MENU
-- ==========================================
local pgHome       = CreateTab("Home", "7733799795")
local pgMapEdit    = CreateTab("Map Editor", "7733917120")
local pgTracker    = CreateTab("Path Tracker", "7733954760")
local pgSelf       = CreateTab("Local Player", "7734068321")
local pgSettingsUI = CreateTab("Settings UI", "7734068321")
local pgSettings   = CreateTab("Settings", "7733964719")

-- --- HOME ---
local secWelcome = CreateSection(pgHome, "Welcome to Dev Engine", true)
local welcomeTxt = CreateParagraph(secWelcome, "Welcome to Houfil Dev Engine.\nAdvanced Map Editing & Pathfinding Tools.")
task.spawn(function() while task.wait(1.5) do TweenService:Create(welcomeTxt, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true), {TextTransparency = 0.4}):Play(); task.wait(1.5) end end)
CreateButton(CreateSection(pgHome, "Discord", true), "Copy Discord Link", function() if setclipboard then setclipboard("https://discord.gg/w3Dr9VzjS6") end end)

-- --- MAP EDITOR (ADVANCED) ---
local secEditorConfig = CreateSection(pgMapEdit, "Editor Controls", true)
CreateToggle(secEditorConfig, "Enable Advanced Editor", false, function(v) toggleMapEditor(v) end)

local secInfo = CreateSection(pgMapEdit, "Selection Info", true)
ui_infoName = CreateInfoRow(secInfo, "Name", "No part selected")
ui_infoClass = CreateInfoRow(secInfo, "Class", "...")
ui_infoPath = CreateInfoRow(secInfo, "Path", "...")

local secActions = CreateSection(pgMapEdit, "Actions", true)
CreateButton(secActions, "Copy Name", function() if selectedPart and setclipboard then setclipboard(selectedPart.Name); PlaySound("Success") end end)
CreateButton(secActions, "Copy Full Path", function() if selectedPart and setclipboard then setclipboard(GetFullPath(selectedPart)); PlaySound("Success") end end)
CreateButton(secActions, "Delete Part", function() deleteSelected() end)
CreateButton(secActions, "Undo Last Delete", function() undoLastDelete() end)
CreateButton(secActions, "Export Deleted Parts", function() exportDeletedParts() end)
CreateButton(secActions, "Bring Part to Me", function() bringSelected() end)
CreateButton(secActions, "Teleport to Part", function() tpToSelected() end)

local secTransform = CreateSection(pgMapEdit, "Transform (Move)", false)
local moveAmount = 5
CreateSlider(secTransform, "Move Step (Studs)", 1, 50, 5, function(v) moveAmount = v end)

local gridContainer = CreateRow(secTransform, 90)
local gridLayout = Instance.new("UIGridLayout", gridContainer); gridLayout.CellSize = UDim2.new(0, 80, 0, 35); gridLayout.CellPadding = UDim2.new(0, 5, 0, 5); gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
local axes = {
    {"+X", "X", 1}, {"-X", "X", -1},
    {"+Y", "Y", 1}, {"-Y", "Y", -1},
    {"+Z", "Z", 1}, {"-Z", "Z", -1}
}
for _, axisData in ipairs(axes) do
    local btn = Instance.new("TextButton", gridContainer); btn.Text = "Move " .. axisData[1]; btn:SetAttribute("BgRole", "Main"); btn:SetAttribute("TextRole", "Accent"); btn:SetAttribute("BaseTextSize", 12); Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function() PlaySound("Click"); AnimateClick(btn); moveSelected(axisData[2], moveAmount * axisData[3]) end)
end

-- --- PATH TRACKER ---
local secPath = CreateSection(pgTracker, "Path Recording", true)
CreateParagraph(secPath, "Records your movement. Visual trace aligns with the floor.")
CreateSlider(secPath, "Record Distance (Studs)", 1, 15, 3, function(v) recordDistance = v end)
CreateToggle(secPath, "Start Recording Path", false, function(v) togglePathRecording(v) end)
CreateButton(secPath, "Clear Current Path", function() clearPath() end)

local secPlayPath = CreateSection(pgTracker, "Path Execution", true)
CreateSlider(secPlayPath, "Playback Speed", 50, 300, 150, function(v) globalTpSpeed = v end)
CreateButton(secPlayPath, "Play Path (Smart Bypass)", function() playPath(globalTpSpeed) end)
CreateButton(secPlayPath, "Stop Playback", function() stopPlayingPath() end)

local secSavePath = CreateSection(pgTracker, "Save & Load", false)
local saveName = "MyCustomPath"
CreateInput(secSavePath, "Path File Name", "Enter name...", saveName, function(v) saveName = v end)
CreateButton(secSavePath, "Save Path to JSON", function() savePathToFile(saveName) end)

-- --- LOCAL PLAYER / EXPLOITS ---
local secPlayer = CreateSection(pgSelf, "Local Player Modification", true)
CreateSlider(secPlayer, "WalkSpeed (CFrame)", 16, 250, 50, function(v) walkSpeedValue = v; updateSpeed() end)
CreateToggle(secPlayer, "Enable WalkSpeed", false, function(v) walkSpeedEnabled = v; updateSpeed() end)
CreateToggle(secPlayer, "Infinite Jump", false, function(v) infJumpEnabled = v end)
CreateToggle(secPlayer, "Double Jump", false, function(v) doubleJumpEnabled = v end)

local secExploits = CreateSection(pgSelf, "Exploits (For Pathing)", true)
CreateSlider(secExploits, "Fly Speed", 10, 300, 50, function(v) flySpeedValue = v end)
CreateToggle(secExploits, "Fly Mode (Bypass)", false, function(v) flyEnabled = v; toggleFly() end)
CreateToggle(secExploits, "No Clip", false, function(v) noClipEnabled = v; if v then enableNoClip() else disableNoClip() end end)

-- --- SETTINGS UI ---
local secTheme = CreateSection(pgSettingsUI, "Theme", true)
CreateDropdown(secTheme, "Select Theme", ThemeNames, CurrentSettings.Theme, function(v) CurrentSettings.Theme = v; SaveSettings(); ApplyTheme() end)

local secAudio = CreateSection(pgSettingsUI, "Audio", true)
CreateToggle(secAudio, "UI Sounds Enabled", CurrentSettings.UISounds, function(v) CurrentSettings.UISounds = v; SaveSettings() end)
CreateDropdown(secAudio, "Sound Pack", SoundPacks, CurrentSettings.SoundPack, function(v) CurrentSettings.SoundPack = v; SaveSettings() end)

local secCustom = CreateSection(pgSettingsUI, "Customization", false)
CreateSlider(secCustom, "Menu Size (%)", 70, 150, tonumber(CurrentSettings.MenuSize) or 100, function(v) CurrentSettings.MenuSize = v; SaveSettings(); ApplyTheme() end)
CreateSlider(secCustom, "Glass Opacity", 10, 100, CurrentSettings.Opacity * 100, function(v) CurrentSettings.Opacity = v/100; SaveSettings(); ApplyTheme() end)
CreateDropdown(secCustom, "Select Font", FontNames, CurrentSettings.Font, function(v) CurrentSettings.Font = v; SaveSettings(); ApplyTheme() end)

-- --- SETTINGS ---
local secSystem = CreateSection(pgSettings, "System Settings", true)
CreateKeybind(secSystem, "Toggle UI Key", UIConfig.ToggleKey, function(newKey) CurrentSettings.ToggleKey = newKey.Name; UIConfig.ToggleKey = newKey; SaveSettings() end)
CreateButton(secSystem, "Rejoin Server", function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, player) end)
CreateButton(secSystem, "Server Hop", function()
    pcall(function()
        local Http = game:GetService("HttpService"); local TPS = game:GetService("TeleportService")
        local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local function ListServers(cursor) return Http:JSONDecode(game:HttpGet(Api .. ((cursor and "&cursor="..cursor) or ""))) end
        local Server, Next; repeat local Servers = ListServers(Next); Server = Servers.data[math.random(1, #Servers.data)]; Next = Servers.nextPageCursor until Server.playing < Server.maxPlayers and Server.id ~= game.JobId
        TPS:TeleportToPlaceInstance(game.PlaceId, Server.id, player)
    end)
end)
CreateButton(secSystem, "Purge All Files (Reset)", function() purgeAllFiles() end)
CreateButton(secSystem, "Unload Interface", function() CompletelyUnload() end)

-- Toggle & Dragging
local dragS, dragP, startP
local topDrag = Instance.new("TextButton", mainFrame); topDrag.Size = UDim2.new(1,0,0,60); topDrag.BackgroundTransparency = 1; topDrag.Text = ""
topDrag.InputBegan:Connect(function(input) 
    if input.UserInputType == Enum.UserInputType.MouseButton1 then 
        dragS = true; dragP = input.Position; startP = mainFrame.Position 
    end 
end)
UIS.InputChanged:Connect(function(input) 
    if dragS and input.UserInputType == Enum.UserInputType.MouseMovement then 
        local delta = input.Position - dragP
        mainFrame.Position = UDim2.new(startP.X.Scale, startP.X.Offset + delta.X, startP.Y.Scale, startP.Y.Offset + delta.Y) 
    end 
end)
UIS.InputEnded:Connect(function(input) 
    if input.UserInputType == Enum.UserInputType.MouseButton1 then 
        dragS = false
        savedMenuPosition = mainFrame.Position 
    end 
end)

UIS.InputBegan:Connect(function(input, gp) 
    if not gp and input.KeyCode == UIConfig.ToggleKey and not isBindingAny then ToggleMenu(not isMenuOpen) end 
end)

ApplyTheme()
if tabFunctions["Home"] then tabFunctions["Home"]() end
ToggleMenu(true)
