-- ======================================================
-- 👑 Houfil - LOADER (AUTH & LAUNCHER) V0.0.1
-- Compact UI | Floating Cards | Auto-Login | Fixed Startup
-- ======================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local targetGui = pcall(function() return CoreGui.Name end) and CoreGui or player:WaitForChild("PlayerGui")

if targetGui:FindFirstChild("HoufilLoader") then targetGui.HoufilLoader:Destroy() end

-- ==========================================
-- 1. CONFIGURATION & FONCTIONS
-- ==========================================
local API_URL = "http://145.239.69.111:20350/api/auth"
local KeySaveFile = "Houfil_SavedKey.txt"

-- Thème sombre par défaut
local Theme = {
    Accent = Color3.fromRGB(0, 120, 255),
    Main = Color3.fromRGB(15, 16, 20),
    Elem = Color3.fromRGB(25, 26, 30),
    Text = Color3.fromRGB(250, 250, 250),
    TextDim = Color3.fromRGB(150, 150, 160)
}

local getAsset = getcustomasset or getsynasset

local function downloadAsset(fileName, url)
    if not isfile or not isfile(fileName) then
        pcall(function()
            local r = game:HttpGet(url)
            if writefile then writefile(fileName, r) end
        end)
    end
    if getAsset and isfile and isfile(fileName) then
        return getAsset(fileName)
    end
    return ""
end

-- Téléchargement des images des jeux en arrière-plan
local ImgSpeed = downloadAsset("Houfil_SpeedImg.png", "https://i.goopics.net/bbbieo.png")
local ImgPrivate = downloadAsset("Houfil_PrivateImg.png", "https://i.goopics.net/xa6nbd.png")

local function PlaySound(type)
    local sound = Instance.new("Sound", SoundService)
    if type == "Hover" then sound.SoundId = "rbxassetid://6895086153"; sound.Volume = 0.2
    elseif type == "Click" then sound.SoundId = "rbxassetid://6895050306"; sound.Volume = 0.4; sound.Pitch = 1.1
    elseif type == "Open" then sound.SoundId = "rbxassetid://6895079853"; sound.Volume = 0.5
    elseif type == "Close" then sound.SoundId = "rbxassetid://6895079853"; sound.Volume = 0.4; sound.Pitch = 0.8
    elseif type == "Error" then sound.SoundId = "rbxassetid://6895079853"; sound.Volume = 0.5; sound.Pitch = 0.6 end
    sound:Play(); game:GetService("Debris"):AddItem(sound, 1)
end

local function AnimateClick(obj)
    TweenService:Create(obj, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(obj.Size.X.Scale, obj.Size.X.Offset - 2, obj.Size.Y.Scale, obj.Size.Y.Offset - 2)}):Play()
    task.wait(0.1)
    TweenService:Create(obj, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(obj.Size.X.Scale, obj.Size.X.Offset + 2, obj.Size.Y.Scale, obj.Size.Y.Offset + 2)}):Play()
end

-- ==========================================
-- 2. CONSTRUCTION DE L'UI (COMPACTE)
-- ==========================================
local screenGui = Instance.new("ScreenGui", targetGui)
screenGui.Name = "HoufilLoader"
screenGui.DisplayOrder = 1000

local mainFrame = Instance.new("CanvasGroup", screenGui)
mainFrame.Size = UDim2.new(0, 440, 0, 260) 
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Theme.Main
mainFrame.BackgroundTransparency = 0.2 
mainFrame.BorderSizePixel = 0
mainFrame.GroupTransparency = 1 
mainFrame.Visible = false -- Masqué par défaut (le Toggle l'affichera)
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(45, 45, 50)
local uiScale = Instance.new("UIScale", mainFrame); uiScale.Scale = 0.5

-- Brillance Title (Ralentie)
local titleLbl = Instance.new("TextLabel", mainFrame)
titleLbl.Size = UDim2.new(1, 0, 0, 40); titleLbl.Position = UDim2.new(0, 0, 0, 15)
titleLbl.BackgroundTransparency = 1; titleLbl.Text = "HOUFIL KEY"
titleLbl.Font = Enum.Font.GothamBold; titleLbl.TextSize = 22; titleLbl.TextColor3 = Theme.Accent

local shineGrad = Instance.new("UIGradient", titleLbl)
shineGrad.Rotation = 45; shineGrad.Offset = Vector2.new(-1, 0)
shineGrad.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1) })
task.spawn(function() 
    while task.wait(5) do 
        shineGrad.Offset = Vector2.new(-1, 0)
        TweenService:Create(shineGrad, TweenInfo.new(2.5, Enum.EasingStyle.Linear), {Offset = Vector2.new(1, 0)}):Play() 
    end 
end)

local statusLbl = Instance.new("TextLabel", mainFrame)
statusLbl.Size = UDim2.new(1, 0, 0, 20); statusLbl.Position = UDim2.new(0, 0, 0, 50)
statusLbl.BackgroundTransparency = 1; statusLbl.Text = "Please authenticate to access the hub."
statusLbl.Font = Enum.Font.GothamMedium; statusLbl.TextSize = 13; statusLbl.TextColor3 = Theme.TextDim

-- FOOTER
local footer = Instance.new("Frame", mainFrame)
footer.Size = UDim2.new(1, 0, 0, 30); footer.Position = UDim2.new(0, 0, 1, -30)
footer.BackgroundTransparency = 1

local versionLbl = Instance.new("TextLabel", footer)
versionLbl.Size = UDim2.new(0, 100, 1, 0); versionLbl.Position = UDim2.new(0, 15, 0, 0)
versionLbl.BackgroundTransparency = 1; versionLbl.Text = "V0.0.1"
versionLbl.Font = Enum.Font.GothamBold; versionLbl.TextSize = 11; versionLbl.TextColor3 = Theme.TextDim; versionLbl.TextXAlignment = Enum.TextXAlignment.Left

local linksLbl = Instance.new("TextLabel", footer)
linksLbl.Size = UDim2.new(0, 250, 1, 0); linksLbl.Position = UDim2.new(1, -265, 0, 0)
linksLbl.BackgroundTransparency = 1; linksLbl.Text = "houfil.fr  |  discord.gg/houfil"
linksLbl.Font = Enum.Font.GothamMedium; linksLbl.TextSize = 11; linksLbl.TextColor3 = Theme.Accent; linksLbl.TextXAlignment = Enum.TextXAlignment.Right

-- ==========================================
-- CONTENEUR 1 : KEY SYSTEM
-- ==========================================
local keyContainer = Instance.new("Frame", mainFrame)
keyContainer.Size = UDim2.new(1, 0, 1, -100); keyContainer.Position = UDim2.new(0, 0, 0, 80)
keyContainer.BackgroundTransparency = 1

local keyBoxBg = Instance.new("Frame", keyContainer)
keyBoxBg.Size = UDim2.new(0, 300, 0, 40); keyBoxBg.Position = UDim2.new(0.5, -150, 0, 20)
keyBoxBg.BackgroundColor3 = Theme.Elem
Instance.new("UICorner", keyBoxBg).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", keyBoxBg).Color = Color3.fromRGB(45, 45, 50)

local keyBox = Instance.new("TextBox", keyBoxBg)
keyBox.Size = UDim2.new(1, -20, 1, 0); keyBox.Position = UDim2.new(0, 10, 0, 0)
keyBox.BackgroundTransparency = 1; keyBox.PlaceholderText = "Enter your license key..."
keyBox.Text = ""; keyBox.Font = Enum.Font.GothamMedium; keyBox.TextSize = 13; keyBox.TextColor3 = Theme.Text; keyBox.TextXAlignment = Enum.TextXAlignment.Center
keyBox.ClearTextOnFocus = false

local verifyBtn = Instance.new("TextButton", keyContainer)
verifyBtn.Size = UDim2.new(0, 145, 0, 38); verifyBtn.Position = UDim2.new(0.5, -150, 0, 75)
verifyBtn.BackgroundColor3 = Theme.Accent
verifyBtn.Text = "Verify Key"; verifyBtn.Font = Enum.Font.GothamBold; verifyBtn.TextSize = 13; verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", verifyBtn).CornerRadius = UDim.new(0, 6)

local getKeyBtn = Instance.new("TextButton", keyContainer)
getKeyBtn.Size = UDim2.new(0, 145, 0, 38); getKeyBtn.Position = UDim2.new(0.5, 5, 0, 75)
getKeyBtn.BackgroundColor3 = Theme.Elem
getKeyBtn.Text = "Get Key"; getKeyBtn.Font = Enum.Font.GothamBold; getKeyBtn.TextSize = 13; getKeyBtn.TextColor3 = Theme.Text
Instance.new("UICorner", getKeyBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", getKeyBtn).Color = Color3.fromRGB(45, 45, 50)

-- ==========================================
-- CONTENEUR 2 : LAUNCHER (JEUX FLOTTANTS)
-- ==========================================
local launcherContainer = Instance.new("ScrollingFrame", mainFrame)
launcherContainer.Size = UDim2.new(1, -20, 1, -110); launcherContainer.Position = UDim2.new(1, 0, 0, 75)
launcherContainer.BackgroundTransparency = 1; launcherContainer.ScrollBarThickness = 0
launcherContainer.Visible = false

local gridLayout = Instance.new("UIGridLayout", launcherContainer)
gridLayout.CellSize = UDim2.new(0, 185, 0, 120) 
gridLayout.CellPadding = UDim2.new(0, 15, 0, 15)
gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local floatOffset = 0
local function CreateGameTile(name, imageAsset, scriptUrl)
    local cell = Instance.new("Frame", launcherContainer)
    cell.BackgroundTransparency = 1
    
    local card = Instance.new("TextButton", cell)
    card.Size = UDim2.new(1, 0, 1, 0); card.Position = UDim2.new(0, 0, 0, 0)
    card.Text = ""; card.BackgroundColor3 = Theme.Elem
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
    local cardStroke = Instance.new("UIStroke", card); cardStroke.Color = Color3.fromRGB(45, 45, 50)
    
    local img = Instance.new("ImageLabel", card)
    img.Size = UDim2.new(1, 0, 0.65, 0); img.Position = UDim2.new(0, 0, 0, 0)
    img.BackgroundTransparency = 1; img.ScaleType = Enum.ScaleType.Crop
    img.Image = imageAsset ~= "" and imageAsset or "rbxassetid://10629237000"
    Instance.new("UICorner", img).CornerRadius = UDim.new(0, 10)
    
    local imgFix = Instance.new("Frame", img)
    imgFix.Size = UDim2.new(1, 0, 0, 10); imgFix.Position = UDim2.new(0, 0, 1, -10)
    imgFix.BorderSizePixel = 0; imgFix.BackgroundColor3 = Theme.Elem
    
    local grad = Instance.new("UIGradient", imgFix)
    grad.Rotation = 270; grad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
    
    local title = Instance.new("TextLabel", card)
    title.Size = UDim2.new(1, -10, 0.35, 0); title.Position = UDim2.new(0, 5, 0.65, 0)
    title.BackgroundTransparency = 1; title.Text = name; title.TextXAlignment = Enum.TextXAlignment.Center
    title.Font = Enum.Font.GothamBold; title.TextSize = 12; title.TextColor3 = Theme.Text; title.TextWrapped = true
    
    -- Animation Flottante
    floatOffset = floatOffset + 0.5
    local floatTween = TweenService:Create(card, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Position = UDim2.new(0, 0, 0, -6)})
    task.delay(floatOffset, function() floatTween:Play() end)
    
    card.MouseEnter:Connect(function() PlaySound("Hover"); TweenService:Create(cardStroke, TweenInfo.new(0.3), {Color = Theme.Accent}):Play() end)
    card.MouseLeave:Connect(function() TweenService:Create(cardStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(45, 45, 50)}):Play() end)
    
    card.MouseButton1Click:Connect(function()
        PlaySound("Open"); AnimateClick(card)
        statusLbl.Text = "Loading " .. name .. "..."
        statusLbl.TextColor3 = Color3.fromRGB(0, 255, 150)
        TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {GroupTransparency = 1, Position = UDim2.new(0.5, 0, 0.55, 0)}):Play()
        TweenService:Create(uiScale, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Scale = 0.5}):Play()
        task.wait(0.6)
        screenGui:Destroy()
        
        -- Lancement sécurisé
        local s, r = pcall(function() return game:HttpGet(scriptUrl, true) end)
        if s and r then loadstring(r)() else warn("Houfil: Failed to load script.") end
    end)
end

-- ==========================================
-- 3. LOGIQUE D'AUTHENTIFICATION & SAUVEGARDE
-- ==========================================
local function VerifyKeyProcess(keyToVerify)
    statusLbl.Text = "Authenticating..."; statusLbl.TextColor3 = Theme.TextDim
    
    task.spawn(function()
        local requestFunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request
        if not requestFunc then
            statusLbl.Text = "Executor not supported."; statusLbl.TextColor3 = Color3.fromRGB(255, 80, 80); PlaySound("Error")
            return
        end
        
        local bodyData = HttpService:JSONEncode({key = keyToVerify, roblox_id = tostring(player.UserId)})
        local success, response = pcall(function() return requestFunc({ Url = API_URL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = bodyData }) end)
        
        if success and response and response.StatusCode == 200 then
            local data = HttpService:JSONDecode(response.Body)
            if data.success then
                statusLbl.Text = "Successfully Authenticated!"
                statusLbl.TextColor3 = Color3.fromRGB(0, 255, 100)
                PlaySound("Success")
                
                -- SAUVEGARDE DE LA CLÉ LOCALEMENT
                if writefile then pcall(function() writefile(KeySaveFile, keyToVerify) end) end
                
                -- SAUVEGARDE DU TOKEN POUR LE JEU FINAL
                getgenv().Houfil_Session_Token = data.session_token
                
                task.wait(0.8)
                launcherContainer.Visible = true
                titleLbl.Text = "HOUFIL LAUNCHER"
                statusLbl.Text = "Select an experience to inject."
                statusLbl.TextColor3 = Theme.TextDim
                
                TweenService:Create(keyContainer, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(-1, 0, 0, 80)}):Play()
                TweenService:Create(launcherContainer, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 10, 0, 75)}):Play()
                
                -- CHARGEMENT DES CARTES DE JEU
                local baseUrl = "https://raw.githubusercontent.com/CaveUser/Houfil/main/Script/"
                CreateGameTile("+1 Speed Keyboard Escape", ImgSpeed, baseUrl .. "SpeedKeyBoard.lua")
                CreateGameTile("Houfil Private", ImgPrivate, baseUrl .. "HoufilPrivate.lua")
            else
                -- Clé invalide ou expirée : On la supprime des fichiers si elle existait
                if isfile and isfile(KeySaveFile) and delfile then pcall(function() delfile(KeySaveFile) end) end
                statusLbl.Text = data.message; statusLbl.TextColor3 = Color3.fromRGB(255, 80, 80); PlaySound("Error")
            end
        else
            statusLbl.Text = "API Server is offline or unreachable."
            statusLbl.TextColor3 = Color3.fromRGB(255, 80, 80); PlaySound("Error")
        end
    end)
end

verifyBtn.MouseButton1Click:Connect(function()
    if keyBox.Text ~= "" then
        PlaySound("Click"); AnimateClick(verifyBtn)
        VerifyKeyProcess(keyBox.Text)
    end
end)

getKeyBtn.MouseButton1Click:Connect(function()
    PlaySound("Click"); AnimateClick(getKeyBtn)
    statusLbl.Text = "Link copied to clipboard!"
    statusLbl.TextColor3 = Theme.Accent
    if setclipboard then setclipboard("https://houfil.fr") end
    task.wait(2)
    if statusLbl.Text == "Link copied to clipboard!" then
        statusLbl.Text = "Please authenticate to access the hub."
        statusLbl.TextColor3 = Theme.TextDim
    end
end)

-- ==========================================
-- 4. ANIMATIONS & AUTO-LOGIN
-- ==========================================
local isMenuOpen = false -- CORRIGÉ : L'UI commence bien masquée et fermée
local function ToggleLoader()
    isMenuOpen = not isMenuOpen
    if isMenuOpen then
        mainFrame.Visible = true; PlaySound("Open")
        uiScale.Scale = 0.4; mainFrame.Position = UDim2.new(0.5, 0, 0.5, 50)
        TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.5, 0), GroupTransparency = 0}):Play()
        TweenService:Create(uiScale, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
    else
        PlaySound("Close")
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, 0.5, 50), GroupTransparency = 1})
        TweenService:Create(uiScale, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Scale = 0.6}):Play()
        tween:Play(); tween.Completed:Once(function() if not isMenuOpen then mainFrame.Visible = false end end)
    end
end

UIS.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.Insert then ToggleLoader() end
end)

local dragS, dragP, startP
titleLbl.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragS = true; dragP = input.Position; startP = mainFrame.Position end end)
UIS.InputChanged:Connect(function(input) if dragS and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragP; mainFrame.Position = UDim2.new(startP.X.Scale, startP.X.Offset + delta.X, startP.Y.Scale, startP.Y.Offset + delta.Y) end end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragS = false end end)

-- Animation d'apparition au lancement
ToggleLoader()

-- Vérification de l'Auto-Login (Sauvegarde)
task.spawn(function()
    task.wait(0.8) -- Petit délai pour laisser l'animation se finir proprement
    if readfile and isfile and isfile(KeySaveFile) then
        pcall(function()
            local savedKey = readfile(KeySaveFile)
            if savedKey and savedKey ~= "" then
                keyBox.Text = savedKey
                VerifyKeyProcess(savedKey)
            end
        end)
    end
end)
