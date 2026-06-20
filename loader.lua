-- ======================================================
-- 👑 Houfil - LOADER (AUTH & LAUNCHER)
-- ======================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local targetGui = pcall(function() return CoreGui.Name end) and CoreGui or player:WaitForChild("PlayerGui")
if targetGui:FindFirstChild("HoufilLoader") then targetGui.HoufilLoader:Destroy() end

-- /!\ METTRE L'IP DE TON VPS / BOT ICI /!\
local API_URL = "http://145.239.69.111:20350/api/auth"

local screenGui = Instance.new("ScreenGui", targetGui)
screenGui.Name = "HoufilLoader"
screenGui.DisplayOrder = 1000

local mainFrame = Instance.new("CanvasGroup", screenGui)
mainFrame.Size = UDim2.new(0, 450, 0, 280)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 16, 20)
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(45, 45, 50)

local titleLbl = Instance.new("TextLabel", mainFrame)
titleLbl.Size = UDim2.new(1, 0, 0, 50); titleLbl.Position = UDim2.new(0, 0, 0, 20)
titleLbl.BackgroundTransparency = 1; titleLbl.Text = "Houfil Authentication"
titleLbl.Font = Enum.Font.GothamBold; titleLbl.TextSize = 24; titleLbl.TextColor3 = Color3.fromRGB(0, 120, 255)

local statusLbl = Instance.new("TextLabel", mainFrame)
statusLbl.Size = UDim2.new(1, 0, 0, 20); statusLbl.Position = UDim2.new(0, 0, 0, 65)
statusLbl.BackgroundTransparency = 1; statusLbl.Text = "Please enter your key to continue."
statusLbl.Font = Enum.Font.GothamMedium; statusLbl.TextSize = 14; statusLbl.TextColor3 = Color3.fromRGB(150, 150, 160)

local keyContainer = Instance.new("Frame", mainFrame)
keyContainer.Size = UDim2.new(1, 0, 1, -90); keyContainer.Position = UDim2.new(0, 0, 0, 90)
keyContainer.BackgroundTransparency = 1

local keyBoxBg = Instance.new("Frame", keyContainer)
keyBoxBg.Size = UDim2.new(0, 350, 0, 45); keyBoxBg.Position = UDim2.new(0.5, -175, 0, 20)
keyBoxBg.BackgroundColor3 = Color3.fromRGB(25, 26, 30)
Instance.new("UICorner", keyBoxBg).CornerRadius = UDim.new(0, 8)

local keyBox = Instance.new("TextBox", keyBoxBg)
keyBox.Size = UDim2.new(1, -20, 1, 0); keyBox.Position = UDim2.new(0, 10, 0, 0)
keyBox.BackgroundTransparency = 1; keyBox.PlaceholderText = "Enter your key..."
keyBox.Text = ""; keyBox.Font = Enum.Font.GothamMedium; keyBox.TextSize = 14; keyBox.TextColor3 = Color3.fromRGB(250, 250, 250)

local verifyBtn = Instance.new("TextButton", keyContainer)
verifyBtn.Size = UDim2.new(0, 165, 0, 40); verifyBtn.Position = UDim2.new(0.5, -82.5, 0, 85)
verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
verifyBtn.Text = "Verify Key"; verifyBtn.Font = Enum.Font.GothamBold; verifyBtn.TextSize = 14; verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", verifyBtn).CornerRadius = UDim.new(0, 8)

local launcherContainer = Instance.new("Frame", mainFrame)
launcherContainer.Size = UDim2.new(1, 0, 1, -90); launcherContainer.Position = UDim2.new(1, 0, 0, 90)
launcherContainer.BackgroundTransparency = 1; launcherContainer.Visible = false

local gridLayout = Instance.new("UIGridLayout", launcherContainer)
gridLayout.CellSize = UDim2.new(0, 170, 0, 50); gridLayout.CellPadding = UDim2.new(0, 10, 0, 10); gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function CreateGameTile(name, scriptUrl)
    local btn = Instance.new("TextButton", launcherContainer)
    btn.BackgroundColor3 = Color3.fromRGB(25, 26, 30); btn.Text = name
    btn.Font = Enum.Font.GothamBold; btn.TextSize = 13; btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        statusLbl.Text = "Loading " .. name .. "..."
        statusLbl.TextColor3 = Color3.fromRGB(0, 255, 100)
        TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {GroupTransparency = 1}):Play()
        task.wait(0.6)
        screenGui:Destroy()
        
        -- Lancement du script
        local s, r = pcall(function() return game:HttpGet(scriptUrl, true) end)
        if s and r then loadstring(r)() else warn("Failed to load script.") end
    end)
end

-- TES JEUX ICI
CreateGameTile("+1 Vitesse (Evasion)", "https://raw.githubusercontent.com/TON_GITHUB/Houfil/main/script/Vitesse.lua")
CreateGameTile("Houfil Dev Engine", "https://raw.githubusercontent.com/TON_GITHUB/Houfil/main/script/DevEngine.lua")

verifyBtn.MouseButton1Click:Connect(function()
    if keyBox.Text == "" then return end
    statusLbl.Text = "Checking key..."; statusLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    
    task.spawn(function()
        local requestFunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request
        if not requestFunc then
            statusLbl.Text = "Executor not supported."; statusLbl.TextColor3 = Color3.fromRGB(255, 80, 80)
            return
        end
        
        local bodyData = HttpService:JSONEncode({key = keyBox.Text, roblox_id = tostring(player.UserId)})
        
        local response = requestFunc({
            Url = API_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = bodyData
        })
        
        if response.StatusCode == 200 then
            local data = HttpService:JSONDecode(response.Body)
            if data.success then
                statusLbl.Text = "Successfully Authenticated!"
                statusLbl.TextColor3 = Color3.fromRGB(0, 255, 100)
                
                -- SAUVEGARDE DU TOKEN
                getgenv().Houfil_Session_Token = data.session_token
                
                task.wait(0.8)
                launcherContainer.Visible = true
                titleLbl.Text = "Houfil Launcher"
                statusLbl.Text = "Select your game."
                TweenService:Create(keyContainer, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(-1, 0, 0, 90)}):Play()
                TweenService:Create(launcherContainer, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 90)}):Play()
            else
                statusLbl.Text = data.message; statusLbl.TextColor3 = Color3.fromRGB(255, 80, 80)
            end
        else
            statusLbl.Text = "API Offline or Error " .. tostring(response.StatusCode)
            statusLbl.TextColor3 = Color3.fromRGB(255, 80, 80)
            if response.Body then
                pcall(function()
                    local errData = HttpService:JSONDecode(response.Body)
                    if errData.message then statusLbl.Text = errData.message end
                end)
            end
        end
    end)
end)
