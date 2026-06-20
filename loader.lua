-- ======================================================
-- 👑 Houfil - LOADER (AUTH & LAUNCHER)
-- Premium DA | Themed | Game Cards | Animations
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
-- 1. CONFIGURATION & THEMES
-- ==========================================
local API_URL = "http://145.239.69.111:20350/api/auth"

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

if readfile and isfile and isfile(ConfigFileName) then
    pcall(function()
        local data = HttpService:JSONDecode(readfile(ConfigFileName))
        for k,v in pairs(data) do CurrentSettings[k] = v end
    end)
end

local getAsset = getcustomasset or getsynasset
local Fonts = { ["Gotham"] = Enum.Font.GothamBold, ["Code"] = Enum.Font.Code, ["SciFi"] = Enum.Font.Michroma, ["Nunito"] = Enum.Font.Nunito, ["Ubuntu"] = Enum.Font.Ubuntu, ["Oswald"] = Enum.Font.Oswald }
local FontScales = { ["Chillax"] = 1.25, ["Code"] = 1.1, ["SciFi"] = 1.05 }

local function getFont(fontName)
    if fontName == "Chillax" and getAsset and isfile and isfile("Chillax-Bold.otf") then
        local s, f = pcall(function() local font = Font.new(getAsset("Chillax-Bold.otf")); font.Weight = Enum.FontWeight.Bold return font end)
        if s and f then return f end
    end
    return Fonts[fontName] or Enum.Font.GothamBold
end

local function PlaySound(type)
    if not CurrentSettings.UISounds then return end
    local sound = Instance.new("Sound", SoundService)
    if type == "Hover" then sound.SoundId = "rbxassetid://6895086153"; sound.Volume = 0.2
    elseif type == "Click" then sound.SoundId = "rbxassetid://6895050306"; sound.Volume = 0.4; sound.Pitch = 1.1
    elseif type == "Open" then sound.SoundId = "rbxassetid://6895079853"; sound.Volume = 0.5
    elseif type == "Close" then sound.SoundId = "rbxassetid://6895079853"; sound.Volume = 0.4; sound.Pitch = 0.8
    elseif type == "Error" then sound.SoundId = "rbxassetid://6895079853"; sound.Volume = 0.5; sound.Pitch = 0.6 end
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 1)
end

local function AnimateClick(obj)
    task.spawn(function()
        local ripple = Instance.new("Frame")
        ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ripple.BackgroundTransparency = 0.6
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.ZIndex = obj.ZIndex + 1
        Instance.new("UICorner", ripple).CornerRadius = UDim.new(1, 0)
        obj.ClipsDescendants = true
        ripple.Parent = obj
        local maxSize = math.max(obj.AbsoluteSize.X, obj.AbsoluteSize.Y) * 1.5
        local tw = TweenService:Create(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, maxSize, 0, maxSize), BackgroundTransparency = 1})
        tw:Play(); tw.Completed:Wait(); ripple:Destroy()
    end)
    TweenService:Create(obj, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(obj.Size.X.Scale, obj.Size.X.Offset - 2, obj.Size.Y.Scale, obj.Size.Y.Offset - 2)}):Play()
    task.wait(0.1)
    TweenService:Create(obj, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(obj.Size.X.Scale, obj.Size.X.Offset + 2, obj.Size.Y.Scale, obj.Size.Y.Offset + 2)}):Play()
end

-- ==========================================
-- 2. CONSTRUCTION DE L'UI (LOADER)
-- ==========================================
local screenGui = Instance.new("ScreenGui", targetGui)
screenGui.Name = "HoufilLoader"
screenGui.DisplayOrder = 1000

local mainFrame = Instance.new("CanvasGroup", screenGui)
mainFrame.Size = UDim2.new(0, 520, 0, 360)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BorderSizePixel = 0
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
mainFrame:SetAttribute("BgRole", "Main")
mainFrame.GroupTransparency = 1 
local uiScale = Instance.new("UIScale", mainFrame); uiScale.Scale = 0.5

-- Brillance Title
local titleLbl = Instance.new("TextLabel", mainFrame)
titleLbl.Size = UDim2.new(1, 0, 0, 40); titleLbl.Position = UDim2.new(0, 0, 0, 25)
titleLbl.BackgroundTransparency = 1; titleLbl.Text = "HOUFIL PREMIUM"
titleLbl.TextXAlignment = Enum.TextXAlignment.Center
titleLbl:SetAttribute("TextRole", "Accent"); titleLbl:SetAttribute("BaseTextSize", 26)

local shineGrad = Instance.new("UIGradient", titleLbl)
shineGrad.Rotation = 45; shineGrad.Offset = Vector2.new(-1, 0)
shineGrad.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1) })
task.spawn(function() while task.wait(3) do shineGrad.Offset = Vector2.new(-1, 0); TweenService:Create(shineGrad, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {Offset = Vector2.new(1, 0)}):Play() end end)

local statusLbl = Instance.new("TextLabel", mainFrame)
statusLbl.Size = UDim2.new(1, 0, 0, 20); statusLbl.Position = UDim2.new(0, 0, 0, 65)
statusLbl.BackgroundTransparency = 1; statusLbl.Text = "Please authenticate to access the hub."
statusLbl:SetAttribute("TextRole", "TextDim"); statusLbl:SetAttribute("BaseTextSize", 14)

-- FOOTER (ULTRA COMPLET)
local footer = Instance.new("Frame", mainFrame)
footer.Size = UDim2.new(1, 0, 0, 30); footer.Position = UDim2.new(0, 0, 1, -30)
footer.BackgroundTransparency = 1

local versionLbl = Instance.new("TextLabel", footer)
versionLbl.Size = UDim2.new(0, 100, 1, 0); versionLbl.Position = UDim2.new(0, 15, 0, 0)
versionLbl.BackgroundTransparency = 1; versionLbl.Text = "V0.0.1"
versionLbl.TextXAlignment = Enum.TextXAlignment.Left
versionLbl:SetAttribute("TextRole", "TextDim"); versionLbl:SetAttribute("BaseTextSize", 12)

local linksLbl = Instance.new("TextLabel", footer)
linksLbl.Size = UDim2.new(0, 250, 1, 0); linksLbl.Position = UDim2.new(1, -265, 0, 0)
linksLbl.BackgroundTransparency = 1; linksLbl.Text = "houfil.fr  |  discord.gg/houfil"
linksLbl.TextXAlignment = Enum.TextXAlignment.Right
linksLbl:SetAttribute("TextRole", "Accent"); linksLbl:SetAttribute("BaseTextSize", 12)

-- CONTENEUR 1 : KEY SYSTEM
local keyContainer = Instance.new("Frame", mainFrame)
keyContainer.Size = UDim2.new(1, 0, 1, -120); keyContainer.Position = UDim2.new(0, 0, 0, 90)
keyContainer.BackgroundTransparency = 1

local keyBoxBg = Instance.new("Frame", keyContainer)
keyBoxBg.Size = UDim2.new(0, 340, 0, 45); keyBoxBg.Position = UDim2.new(0.5, -170, 0, 30)
keyBoxBg:SetAttribute("BgRole", "Elem")
Instance.new("UICorner", keyBoxBg).CornerRadius = UDim.new(0, 8)
local keyStroke = Instance.new("UIStroke", keyBoxBg); keyStroke.Thickness = 1.5; keyStroke:SetAttribute("StrokeRole", "Dim")

local keyIcon = Instance.new("ImageLabel", keyBoxBg)
keyIcon.Size = UDim2.new(0, 20, 0, 20); keyIcon.Position = UDim2.new(0, 12, 0.5, -10)
keyIcon.BackgroundTransparency = 1; keyIcon.Image = "rbxassetid://7734068321"
keyIcon:SetAttribute("ImageRole", "TextDim")

local keyBox = Instance.new("TextBox", keyBoxBg)
keyBox.Size = UDim2.new(1, -45, 1, 0); keyBox.Position = UDim2.new(0, 40, 0, 0)
keyBox.BackgroundTransparency = 1; keyBox.PlaceholderText = "Enter your license key..."
keyBox.Text = ""; keyBox.TextXAlignment = Enum.TextXAlignment.Left
keyBox:SetAttribute("TextRole", "Text"); keyBox:SetAttribute("BaseTextSize", 14)

local verifyBtn = Instance.new("TextButton", keyContainer)
verifyBtn.Size = UDim2.new(0, 165, 0, 42); verifyBtn.Position = UDim2.new(0.5, -170, 0, 95)
verifyBtn.Text = "Verify Key"
verifyBtn:SetAttribute("BgRole", "AccentBg"); verifyBtn:SetAttribute("TextRole", "Main"); verifyBtn:SetAttribute("BaseTextSize", 14)
Instance.new("UICorner", verifyBtn).CornerRadius = UDim.new(0, 8)

local getKeyBtn = Instance.new("TextButton", keyContainer)
getKeyBtn.Size = UDim2.new(0, 165, 0, 42); getKeyBtn.Position = UDim2.new(0.5, 5, 0, 95)
getKeyBtn.Text = "Get Key"
getKeyBtn:SetAttribute("BgRole", "Elem"); getKeyBtn:SetAttribute("TextRole", "Text"); getKeyBtn:SetAttribute("BaseTextSize", 14)
Instance.new("UICorner", getKeyBtn).CornerRadius = UDim.new(0, 8)
local getStroke = Instance.new("UIStroke", getKeyBtn); getStroke.Thickness = 1; getStroke:SetAttribute("StrokeRole", "Dim")

verifyBtn.MouseEnter:Connect(function() PlaySound("Hover"); TweenService:Create(verifyBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 169, 0, 46), Position = UDim2.new(0.5, -172, 0, 93)}):Play() end)
verifyBtn.MouseLeave:Connect(function() TweenService:Create(verifyBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 165, 0, 42), Position = UDim2.new(0.5, -170, 0, 95)}):Play() end)

getKeyBtn.MouseEnter:Connect(function() PlaySound("Hover"); TweenService:Create(getKeyBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 169, 0, 46), Position = UDim2.new(0.5, 3, 0, 93)}):Play() end)
getKeyBtn.MouseLeave:Connect(function() TweenService:Create(getKeyBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 165, 0, 42), Position = UDim2.new(0.5, 5, 0, 95)}):Play() end)

-- CONTENEUR 2 : LAUNCHER (JEUX)
local launcherContainer = Instance.new("ScrollingFrame", mainFrame)
launcherContainer.Size = UDim2.new(1, -20, 1, -120); launcherContainer.Position = UDim2.new(1, 0, 0, 90)
launcherContainer.BackgroundTransparency = 1; launcherContainer.ScrollBarThickness = 2
launcherContainer.Visible = false

local gridLayout = Instance.new("UIGridLayout", launcherContainer)
gridLayout.CellSize = UDim2.new(0, 230, 0, 110); gridLayout.CellPadding = UDim2.new(0, 15, 0, 15); gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
gridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() launcherContainer.CanvasSize = UDim2.new(0, 0, 0, gridLayout.AbsoluteContentSize.Y + 20) end)

local function CreateGameTile(name, imageId, scriptUrl)
    local card = Instance.new("TextButton", launcherContainer)
    card.Text = ""; card:SetAttribute("BgRole", "Elem")
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
    local cardStroke = Instance.new("UIStroke", card); cardStroke.Thickness = 1.5; cardStroke:SetAttribute("StrokeRole", "Dim")
    
    local img = Instance.new("ImageLabel", card)
    img.Size = UDim2.new(1, 0, 0.7, 0); img.Position = UDim2.new(0, 0, 0, 0)
    img.BackgroundTransparency = 1; img.ScaleType = Enum.ScaleType.Crop
    img.Image = imageId
    Instance.new("UICorner", img).CornerRadius = UDim.new(0, 10)
    
    -- Cache les coins du bas de l'image pour un effet propre
    local imgFix = Instance.new("Frame", img)
    imgFix.Size = UDim2.new(1, 0, 0, 10); imgFix.Position = UDim2.new(0, 0, 1, -10)
    imgFix.BorderSizePixel = 0; imgFix.BackgroundTransparency = 1
    
    local grad = Instance.new("UIGradient", img)
    grad.Rotation = 90; grad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0.8)})
    
    local title = Instance.new("TextLabel", card)
    title.Size = UDim2.new(1, -20, 0.3, 0); title.Position = UDim2.new(0, 10, 0.7, 0)
    title.BackgroundTransparency = 1; title.Text = name; title.TextXAlignment = Enum.TextXAlignment.Left
    title:SetAttribute("TextRole", "Text"); title:SetAttribute("BaseTextSize", 14)
    
    card.MouseEnter:Connect(function() PlaySound("Hover"); TweenService:Create(cardStroke, TweenInfo.new(0.3), {Color = Themes[CurrentSettings.Theme].Accent}):Play() end)
    card.MouseLeave:Connect(function() TweenService:Create(cardStroke, TweenInfo.new(0.3), {Color = Themes[CurrentSettings.Theme].TextDim}):Play() end)
    
    card.MouseButton1Click:Connect(function()
        PlaySound("Open"); AnimateClick(card)
        statusLbl.Text = "Loading " .. name .. "..."
        statusLbl.TextColor3 = Color3.fromRGB(0, 255, 150)
        TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {GroupTransparency = 1, Position = UDim2.new(0.5, 0, 0.55, 0)}):Play()
        TweenService:Create(uiScale, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Scale = 0.5}):Play()
        task.wait(0.6)
        screenGui:Destroy()
        
        -- Execution sécurisée
        local s, r = pcall(function() return game:HttpGet(scriptUrl, true) end)
        if s and r then loadstring(r)() else warn("Houfil: Failed to load script.") end
    end)
end

-- ==========================================
-- 3. GESTION DU THÈME
-- ==========================================
local function ApplyTheme()
    pcall(function()
        local t = Themes[CurrentSettings.Theme] or Themes["Obsidian"]
        local f = getFont(CurrentSettings.Font)
        local offset = tonumber(CurrentSettings.TextSizeOffset) or 1
        local fScale = FontScales[CurrentSettings.Font] or 1
        
        local opacity = tonumber(CurrentSettings.Opacity) or 0.40
        mainFrame.BackgroundColor3 = t.Main
        mainFrame.BackgroundTransparency = opacity

        for _, obj in ipairs(screenGui:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                if typeof(f) == "Font" then obj.FontFace = f else obj.Font = f end
                local bSize = obj:GetAttribute("BaseTextSize")
                if bSize then obj.TextSize = (math.floor(tonumber(bSize) * fScale) + offset) end
                
                local txtRole = obj:GetAttribute("TextRole")
                if txtRole == "Text" then obj.TextColor3 = t.Text elseif txtRole == "TextDim" then obj.TextColor3 = t.TextDim elseif txtRole == "Accent" then obj.TextColor3 = t.Accent elseif txtRole == "Main" then obj.TextColor3 = t.Main end
            end
            
            if obj:IsA("GuiObject") then
                local bgRole = obj:GetAttribute("BgRole")
                if bgRole == "Main" then obj.BackgroundColor3 = t.Main; obj.BackgroundTransparency = opacity elseif bgRole == "Elem" then obj.BackgroundColor3 = t.Elem; obj.BackgroundTransparency = opacity elseif bgRole == "AccentBg" then obj.BackgroundColor3 = t.Accent; obj.BackgroundTransparency = 0 end
            end
            
            if obj:IsA("UIStroke") then
                local strokeRole = obj:GetAttribute("StrokeRole")
                if strokeRole == "Dim" then obj.Color = t.TextDim end
            end
            
            if obj:IsA("ImageLabel") and obj:GetAttribute("ImageRole") == "TextDim" then
                obj.ImageColor3 = t.TextDim
            end
        end
    end)
end
ApplyTheme()

-- ==========================================
-- 4. LOGIQUE API & BOUTONS
-- ==========================================
verifyBtn.MouseButton1Click:Connect(function()
    PlaySound("Click"); AnimateClick(verifyBtn)
    if keyBox.Text == "" then return end
    
    statusLbl.Text = "Checking key connection..."
    statusLbl.TextColor3 = Themes[CurrentSettings.Theme].TextDim
    
    task.spawn(function()
        local requestFunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request
        if not requestFunc then
            statusLbl.Text = "Executor not supported."; statusLbl.TextColor3 = Color3.fromRGB(255, 80, 80)
            PlaySound("Error")
            return
        end
        
        local bodyData = HttpService:JSONEncode({key = keyBox.Text, roblox_id = tostring(player.UserId)})
        
        local success, response = pcall(function()
            return requestFunc({
                Url = API_URL, Method = "POST",
                Headers = {["Content-Type"] = "application/json"}, Body = bodyData
            })
        end)
        
        if success and response and response.StatusCode == 200 then
            local data = HttpService:JSONDecode(response.Body)
            if data.success then
                statusLbl.Text = "Successfully Authenticated!"
                statusLbl.TextColor3 = Color3.fromRGB(0, 255, 100)
                PlaySound("Success")
                
                -- SAUVEGARDE DU TOKEN POUR LE BYPASS
                getgenv().Houfil_Session_Token = data.session_token
                
                task.wait(0.8)
                launcherContainer.Visible = true
                titleLbl.Text = "HOUFIL LAUNCHER"
                statusLbl.Text = "Select an experience to inject."
                statusLbl.TextColor3 = Themes[CurrentSettings.Theme].TextDim
                
                TweenService:Create(keyContainer, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(-1, 0, 0, 90)}):Play()
                TweenService:Create(launcherContainer, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 10, 0, 90)}):Play()
                
                -- CHARGEMENT DES JEUX APRES AUTH (Remplacer les ID des images au besoin)
                local baseUrl = "https://raw.githubusercontent.com/CaverUser/Houfil/main/scripts/"
                CreateGameTile("+1 Vitesse (Speed)", "rbxassetid://15264627447", baseUrl .. "SpeedKeyboard.lua")
                CreateGameTile("Houfil Dev Engine", "rbxassetid://14234551109", baseUrl .. "Developer.lua")
            else
                statusLbl.Text = data.message; statusLbl.TextColor3 = Color3.fromRGB(255, 80, 80); PlaySound("Error")
            end
        else
            statusLbl.Text = "API Server is offline or unreachable."
            statusLbl.TextColor3 = Color3.fromRGB(255, 80, 80); PlaySound("Error")
        end
    end)
end)

getKeyBtn.MouseButton1Click:Connect(function()
    PlaySound("Click"); AnimateClick(getKeyBtn)
    statusLbl.Text = "Link copied to clipboard!"
    statusLbl.TextColor3 = Themes[CurrentSettings.Theme].Accent
    if setclipboard then setclipboard("https://houfil.fr") end
    task.wait(2)
    if statusLbl.Text == "Link copied to clipboard!" then
        statusLbl.Text = "Please authenticate to access the hub."
        statusLbl.TextColor3 = Themes[CurrentSettings.Theme].TextDim
    end
end)

-- ==========================================
-- 5. ANIMATIONS GLOBALES (OPEN/CLOSE)
-- ==========================================
local isMenuOpen = true
local function ToggleLoader()
    isMenuOpen = not isMenuOpen
    if isMenuOpen then
        mainFrame.Visible = true; PlaySound("Open")
        uiScale.Scale = 0.4
        mainFrame.Position = UDim2.new(0.5, 0, 0.5, 50)
        TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.5, 0), GroupTransparency = 0}):Play()
        TweenService:Create(uiScale, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
    else
        PlaySound("Close")
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, 0.5, 50), GroupTransparency = 1})
        TweenService:Create(uiScale, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Scale = 0.6}):Play()
        tween:Play()
        tween.Completed:Once(function() if not isMenuOpen then mainFrame.Visible = false end end)
    end
end

-- Keybind Insert
UIS.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == (Enum.KeyCode[CurrentSettings.ToggleKey] or Enum.KeyCode.Insert) then
        ToggleLoader()
    end
end)

-- Dragging logic
local dragS, dragP, startP
titleLbl.InputBegan:Connect(function(input) 
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragS = true; dragP = input.Position; startP = mainFrame.Position end 
end)
UIS.InputChanged:Connect(function(input) 
    if dragS and input.UserInputType == Enum.UserInputType.MouseMovement then 
        local delta = input.Position - dragP
        mainFrame.Position = UDim2.new(startP.X.Scale, startP.X.Offset + delta.X, startP.Y.Scale, startP.Y.Offset + delta.Y) 
    end 
end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragS = false end end)

-- Initial Startup Animation
ToggleLoader()
