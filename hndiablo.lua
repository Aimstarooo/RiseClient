-- // --- SERVICES & CORE VARIABLES --- //
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Remove duplicates
if CoreGui:FindFirstChild("RiseClientHub") then
    CoreGui.RiseClientHub:Destroy()
end
if CoreGui:FindFirstChild("RiseClientNotif") then
    CoreGui.RiseClientNotif:Destroy()
end
if CoreGui:FindFirstChild("RiseClientWatermark") then
    CoreGui.RiseClientWatermark:Destroy()
end

-- // --- THEME CONFIGURATION --- //
local currentTheme = {
    Accent = Color3.fromRGB(130, 60, 210),       -- Default Professional Purple
    Sidebar = Color3.fromRGB(18, 18, 22),
    TopBar = Color3.fromRGB(22, 22, 26),
    MainBg = Color3.fromRGB(14, 14, 18),
    ButtonBg = Color3.fromRGB(26, 26, 32),
    ButtonHover = Color3.fromRGB(36, 36, 44),
    TextActive = Color3.fromRGB(255, 255, 255),
    TextInactive = Color3.fromRGB(160, 160, 175)
}

local ToggleKey = Enum.KeyCode.Insert
local isListeningForKey = false

-- // --- WATERMARK (FPS / PING HUD) --- //
local WatermarkGui = Instance.new("ScreenGui")
WatermarkGui.Name = "RiseClientWatermark"
WatermarkGui.ResetOnSpawn = false
WatermarkGui.Enabled = true
pcall(function() WatermarkGui.Parent = CoreGui end)
if not WatermarkGui.Parent then WatermarkGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local WatermarkFrame = Instance.new("Frame")
WatermarkFrame.Parent = WatermarkGui
WatermarkFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
WatermarkFrame.BorderSizePixel = 0
WatermarkFrame.Position = UDim2.new(0, 20, 0, 20)
WatermarkFrame.Size = UDim2.new(0, 230, 0, 30)

local WmCorner = Instance.new("UICorner") WmCorner.CornerRadius = UDim.new(0, 6) WmCorner.Parent = WatermarkFrame
local WmStroke = Instance.new("UIStroke") WmStroke.Parent = WatermarkFrame WmStroke.Color = Color3.fromRGB(35, 35, 45)

local WmText = Instance.new("TextLabel")
WmText.Parent = WatermarkFrame
WmText.BackgroundTransparency = 1
WmText.Size = UDim2.new(1, 0, 1, 0)
WmText.Font = Enum.Font.GothamSemibold
WmText.TextSize = 11
WmText.TextColor3 = Color3.fromRGB(220, 220, 230)

local frameCount = 0
local lastTick = tick()
local currentFPS = 60

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - lastTick >= 1 then
        currentFPS = frameCount
        frameCount = 0
        lastTick = tick()
    end
    local success, pingVal = pcall(function()
        return math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    end)
    local ping = success and pingVal or 0
    WmText.Text = "  HnDiabloCircus - RiseClient  |  " .. currentFPS .. " FPS  |  " .. ping .. "ms"
end)


-- // --- NOTIFICATION SYSTEM --- //
local NotifScreenGui = Instance.new("ScreenGui")
NotifScreenGui.Name = "RiseClientNotif"
NotifScreenGui.ResetOnSpawn = false
pcall(function() NotifScreenGui.Parent = CoreGui end)
if not NotifScreenGui.Parent then NotifScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local NotificationContainer = Instance.new("Frame")
NotificationContainer.Name = "Container"
NotificationContainer.Parent = NotifScreenGui
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.Position = UDim2.new(1, -290, 0, 20)
NotificationContainer.Size = UDim2.new(0, 270, 1, -40)

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.Parent = NotificationContainer
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
NotifLayout.Padding = UDim.new(0, 10)

local function SendNotification(title, message, customColor)
    local accent = customColor or currentTheme.Accent
    
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Parent = NotificationContainer
    NotifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Size = UDim2.new(1, 0, 0, 60)
    NotifFrame.Position = UDim2.new(1, 50, 0, 0)
    NotifFrame.ClipsDescendants = true

    local Corner = Instance.new("UICorner") Corner.CornerRadius = UDim.new(0, 6) Corner.Parent = NotifFrame

    local AccentBar = Instance.new("Frame")
    AccentBar.Name = "AccentBar"
    AccentBar.Parent = NotifFrame
    AccentBar.BackgroundColor3 = accent
    AccentBar.BorderSizePixel = 0
    AccentBar.Size = UDim2.new(0, 3, 1, 0)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = NotifFrame
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0, 8)
    TitleLabel.Size = UDim2.new(1, -20, 0, 20)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
    TitleLabel.TextSize = 12
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local DescLabel = Instance.new("TextLabel")
    DescLabel.Parent = NotifFrame
    DescLabel.BackgroundTransparency = 1
    DescLabel.Position = UDim2.new(0, 15, 0, 28)
    DescLabel.Size = UDim2.new(1, -20, 0, 25)
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.Text = message
    DescLabel.TextColor3 = Color3.fromRGB(150, 150, 165)
    DescLabel.TextSize = 11
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.TextWrapped = true

    TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()

    task.spawn(function()
        task.wait(3.5)
        local outTween = TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 50, 0, 0),
            BackgroundTransparency = 1
        })
        outTween:Play()
        outTween.Completed:Wait()
        NotifFrame:Destroy()
    end)
end


-- // --- MAIN SCREEN GUI --- //
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RiseClientHub"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end


-- // --- MAIN HUB WINDOW (VISIBLE ON START) --- //
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = currentTheme.MainBg
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -180)
MainFrame.Size = UDim2.new(0, 560, 0, 360)
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner") MainCorner.CornerRadius = UDim.new(0, 8) MainCorner.Parent = MainFrame
local MainStroke = Instance.new("UIStroke") MainStroke.Parent = MainFrame MainStroke.Color = Color3.fromRGB(40, 40, 50) MainStroke.Thickness = 1


-- // --- SIDEBAR PANEL --- //
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Parent = MainFrame
Sidebar.BackgroundColor3 = currentTheme.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Size = UDim2.new(0, 170, 1, 0)

local SidebarCorner = Instance.new("UICorner") SidebarCorner.CornerRadius = UDim.new(0, 8) SidebarCorner.Parent = Sidebar
local SidebarFix = Instance.new("Frame") SidebarFix.Parent = Sidebar SidebarFix.BackgroundColor3 = currentTheme.Sidebar SidebarFix.BorderSizePixel = 0 SidebarFix.Position = UDim2.new(1, -8, 0, 0) SidebarFix.Size = UDim2.new(0, 8, 1, 0)


-- // --- USER PROFILE CONTAINER --- //
local UserProfileContainer = Instance.new("Frame")
UserProfileContainer.Parent = Sidebar
UserProfileContainer.BackgroundTransparency = 1
UserProfileContainer.Position = UDim2.new(0, 12, 0, 12)
UserProfileContainer.Size = UDim2.new(1, -24, 0, 42)

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Parent = UserProfileContainer
AvatarImage.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
AvatarImage.BorderSizePixel = 0
AvatarImage.Size = UDim2.new(0, 38, 0, 38)
AvatarImage.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

local AvatarCorner = Instance.new("UICorner") AvatarCorner.CornerRadius = UDim.new(1, 0) AvatarCorner.Parent = AvatarImage

local NameLabel = Instance.new("TextLabel")
NameLabel.Parent = UserProfileContainer
NameLabel.BackgroundTransparency = 1
NameLabel.Position = UDim2.new(0, 46, 0, 1)
NameLabel.Size = UDim2.new(1, -46, 0, 18)
NameLabel.Font = Enum.Font.GothamBold
NameLabel.Text = LocalPlayer.Name
NameLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
NameLabel.TextSize = 11
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.TextTruncate = Enum.TextTruncate.AtEnd

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = UserProfileContainer
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 46, 0, 19)
StatusLabel.Size = UDim2.new(1, -46, 0, 16)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Authorized [VIP]"
StatusLabel.TextColor3 = Color3.fromRGB(50, 200, 100)
StatusLabel.TextSize = 10
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left


-- // --- CATEGORY TABS --- //
local TabsContainer = Instance.new("Frame")
TabsContainer.Parent = Sidebar
TabsContainer.BackgroundTransparency = 1
TabsContainer.Position = UDim2.new(0, 10, 0, 68)
TabsContainer.Size = UDim2.new(1, -20, 1, -78)

local TabsLayout = Instance.new("UIListLayout")
TabsLayout.Parent = TabsContainer
TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabsLayout.Padding = UDim.new(0, 5)
TabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local tabButtons = {}

local function createCategoryBtn(name, order)
    local btn = Instance.new("TextButton")
    btn.Parent = TabsContainer
    btn.BackgroundColor3 = currentTheme.ButtonBg
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = "   " .. name
    btn.TextColor3 = currentTheme.TextInactive
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.LayoutOrder = order
    
    local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 6) corner.Parent = btn
    table.insert(tabButtons, btn)
    return btn
end

local MainTabBtn = createCategoryBtn("Main & Exploits", 1)
local VisualsTabBtn = createCategoryBtn("Visuals & ESP", 2)
local InfoTabBtn = createCategoryBtn("License & Info", 3)
local SettingsTabBtn = createCategoryBtn("Settings", 4)


-- // --- TOP BAR --- //
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = currentTheme.TopBar
TopBar.BorderSizePixel = 0
TopBar.Position = UDim2.new(0, 170, 0, 0)
TopBar.Size = UDim2.new(1, -170, 0, 38)

local TopBarCorner = Instance.new("UICorner") TopBarCorner.CornerRadius = UDim.new(0, 8) TopBarCorner.Parent = TopBar
local TopBarFix = Instance.new("Frame") TopBarFix.Parent = TopBar TopBarFix.BackgroundColor3 = currentTheme.TopBar TopBarFix.BorderSizePixel = 0 TopBarFix.Position = UDim2.new(1, -8, 0, 0) TopBarFix.Size = UDim2.new(0, 8, 1, 0)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TopBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Size = UDim2.new(0.6, 0, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "RiseClient"
TitleLabel.TextColor3 = Color3.fromRGB(230, 230, 235)
TitleLabel.TextSize = 12
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Unexecute Button (✕)
local UnexecuteBtn = Instance.new("TextButton")
UnexecuteBtn.Parent = TopBar
UnexecuteBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
UnexecuteBtn.Position = UDim2.new(1, -30, 0.5, -10)
UnexecuteBtn.Size = UDim2.new(0, 20, 0, 20)
UnexecuteBtn.Font = Enum.Font.GothamBold
UnexecuteBtn.Text = "✕"
UnexecuteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
UnexecuteBtn.TextSize = 10

local CloseCorner = Instance.new("UICorner") CloseCorner.CornerRadius = UDim.new(0, 4) CloseCorner.Parent = UnexecuteBtn

-- Minimize Button (-)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Parent = TopBar
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
MinimizeBtn.Position = UDim2.new(1, -56, 0.5, -10)
MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "─"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 10

local MinCorner = Instance.new("UICorner") MinCorner.CornerRadius = UDim.new(0, 4) MinCorner.Parent = MinimizeBtn


-- // --- PAGES CONTAINER --- //
local PagesContainer = Instance.new("Frame")
PagesContainer.Parent = MainFrame
PagesContainer.BackgroundTransparency = 1
PagesContainer.Position = UDim2.new(0, 180, 0, 48)
PagesContainer.Size = UDim2.new(1, -190, 1, -58)

-- Page 1: Main Exploits
local MainTabPage = Instance.new("ScrollingFrame")
MainTabPage.Parent = PagesContainer
MainTabPage.BackgroundTransparency = 1
MainTabPage.BorderSizePixel = 0
MainTabPage.Size = UDim2.new(1, 0, 1, 0)
MainTabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
MainTabPage.ScrollBarThickness = 3
MainTabPage.Visible = true

local MainLayout = Instance.new("UIListLayout")
MainLayout.Parent = MainTabPage
MainLayout.SortOrder = Enum.SortOrder.LayoutOrder
MainLayout.Padding = UDim.new(0, 6)

-- Page 2: Visuals & ESP
local VisualsTabPage = Instance.new("ScrollingFrame")
VisualsTabPage.Parent = PagesContainer
VisualsTabPage.BackgroundTransparency = 1
VisualsTabPage.BorderSizePixel = 0
VisualsTabPage.Size = UDim2.new(1, 0, 1, 0)
VisualsTabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
VisualsTabPage.ScrollBarThickness = 3
VisualsTabPage.Visible = false

local VisualsLayout = Instance.new("UIListLayout")
VisualsLayout.Parent = VisualsTabPage
VisualsLayout.SortOrder = Enum.SortOrder.LayoutOrder
VisualsLayout.Padding = UDim.new(0, 6)

-- Page 3: Info / License
local InfoPage = Instance.new("Frame")
InfoPage.Parent = PagesContainer
InfoPage.BackgroundTransparency = 1
InfoPage.Size = UDim2.new(1, 0, 1, 0)
InfoPage.Visible = false

local InfoBox = Instance.new("TextLabel")
InfoBox.Parent = InfoPage
InfoBox.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
InfoBox.Size = UDim2.new(1, 0, 1, -8)
InfoBox.Font = Enum.Font.Gotham
InfoBox.Text = "═══════════════════════════════\n             LICENSE & SYSTEM INFO\n═══════════════════════════════\n\n• License Status: Active\n• Build Version: v1.0-Release\n• Developer Framework: Rise\n• User Account: " .. LocalPlayer.Name .. "\n• User ID: " .. LocalPlayer.UserId .. "\n\nAll rights reserved for RiseClient. Unauthorized distribution is prohibited."
InfoBox.TextColor3 = Color3.fromRGB(190, 190, 205)
InfoBox.TextSize = 11
InfoBox.TextWrapped = true

local InfoBoxCorner = Instance.new("UICorner") InfoBoxCorner.CornerRadius = UDim.new(0, 6) InfoBoxCorner.Parent = InfoBox
local InfoStroke = Instance.new("UIStroke") InfoStroke.Parent = InfoBox InfoStroke.Color = Color3.fromRGB(35, 35, 45) InfoStroke.Thickness = 1


-- Page 4: Settings
local SettingsPage = Instance.new("ScrollingFrame")
SettingsPage.Parent = PagesContainer
SettingsPage.BackgroundTransparency = 1
SettingsPage.BorderSizePixel = 0
SettingsPage.Size = UDim2.new(1, 0, 1, 0)
SettingsPage.CanvasSize = UDim2.new(0, 0, 0, 130)
SettingsPage.ScrollBarThickness = 3
SettingsPage.Visible = false

local SettingsLayout = Instance.new("UIListLayout")
SettingsLayout.Parent = SettingsPage
SettingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
SettingsLayout.Padding = UDim.new(0, 8)

-- Setting 1: Keybind
local KeybindContainer = Instance.new("Frame")
KeybindContainer.Parent = SettingsPage
KeybindContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
KeybindContainer.Size = UDim2.new(1, 0, 0, 42)

local KeyC = Instance.new("UICorner") KeyC.CornerRadius = UDim.new(0, 6) KeyC.Parent = KeybindContainer
local KeyStroke = Instance.new("UIStroke") KeyStroke.Parent = KeybindContainer KeyStroke.Color = Color3.fromRGB(35, 35, 45)

local KeyLabel = Instance.new("TextLabel")
KeyLabel.Parent = KeybindContainer
KeyLabel.BackgroundTransparency = 1
KeyLabel.Position = UDim2.new(0, 12, 0, 0)
KeyLabel.Size = UDim2.new(0.6, 0, 1, 0)
KeyLabel.Font = Enum.Font.GothamSemibold
KeyLabel.Text = "Interface Toggle Key"
KeyLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
KeyLabel.TextSize = 11
KeyLabel.TextXAlignment = Enum.TextXAlignment.Left

local KeyBtn = Instance.new("TextButton")
KeyBtn.Parent = KeybindContainer
KeyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
KeyBtn.Position = UDim2.new(1, -110, 0.5, -14)
KeyBtn.Size = UDim2.new(0, 100, 0, 28)
KeyBtn.Font = Enum.Font.GothamBold
KeyBtn.Text = ToggleKey.Name
KeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBtn.TextSize = 10

local KeyBtnC = Instance.new("UICorner") KeyBtnC.CornerRadius = UDim.new(0, 4) KeyBtnC.Parent = KeyBtn

KeyBtn.MouseButton1Click:Connect(function()
    isListeningForKey = true
    KeyBtn.Text = "Press any key..."
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if isListeningForKey then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            ToggleKey = input.KeyCode
            KeyBtn.Text = ToggleKey.Name
            isListeningForKey = false
            SendNotification("Settings", "Toggle key updated to: " .. ToggleKey.Name, currentTheme.Accent)
        end
    elseif not gp and input.KeyCode == ToggleKey then
        MainFrame.Visible = not MainFrame.Visible
    end
end)


-- Setting 2: Themes
local ThemeContainer = Instance.new("Frame")
ThemeContainer.Parent = SettingsPage
ThemeContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
ThemeContainer.Size = UDim2.new(1, 0, 0, 42)

local ThemeC = Instance.new("UICorner") ThemeC.CornerRadius = UDim.new(0, 6) ThemeC.Parent = ThemeContainer
local ThemeStroke = Instance.new("UIStroke") ThemeStroke.Parent = ThemeContainer ThemeStroke.Color = Color3.fromRGB(35, 35, 45)

local ThemeLabel = Instance.new("TextLabel")
ThemeLabel.Parent = ThemeContainer
ThemeLabel.BackgroundTransparency = 1
ThemeLabel.Position = UDim2.new(0, 12, 0, 0)
ThemeLabel.Size = UDim2.new(0.5, 0, 1, 0)
ThemeLabel.Font = Enum.Font.GothamSemibold
ThemeLabel.Text = "Interface Theme"
ThemeLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
ThemeLabel.TextSize = 11
ThemeLabel.TextXAlignment = Enum.TextXAlignment.Left

local refreshThemeUI

local function createThemeBtn(color, offset)
    local btn = Instance.new("TextButton")
    btn.Parent = ThemeContainer
    btn.BackgroundColor3 = color
    btn.Position = UDim2.new(1, offset, 0.5, -11)
    btn.Size = UDim2.new(0, 26, 0, 22)
    btn.Text = ""
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 4) c.Parent = btn
    return btn
end

local ThemePurple = createThemeBtn(Color3.fromRGB(130, 60, 210), -36)
local ThemeBlue = createThemeBtn(Color3.fromRGB(0, 122, 255), -68)
local ThemeGreen = createThemeBtn(Color3.fromRGB(40, 180, 99), -100)
local ThemeRed = createThemeBtn(Color3.fromRGB(231, 76, 60), -132)

local activeToggleButtons = {}

local function applyTheme(newAccent)
    currentTheme.Accent = newAccent
    refreshThemeUI()
    SendNotification("Theme Engine", "Theme updated successfully.", newAccent)
end

ThemePurple.MouseButton1Click:Connect(function() applyTheme(Color3.fromRGB(130, 60, 210)) end)
ThemeBlue.MouseButton1Click:Connect(function() applyTheme(Color3.fromRGB(0, 122, 255)) end)
ThemeGreen.MouseButton1Click:Connect(function() applyTheme(Color3.fromRGB(40, 180, 99)) end)
ThemeRed.MouseButton1Click:Connect(function() applyTheme(Color3.fromRGB(231, 76, 60)) end)


-- // --- TAB SWITCHING SYSTEM --- //
local function switchTab(activeBtn, targetPage)
    MainTabPage.Visible = false
    VisualsTabPage.Visible = false
    InfoPage.Visible = false
    SettingsPage.Visible = false
    
    targetPage.Visible = true
    
    for _, btn in ipairs(tabButtons) do
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = currentTheme.ButtonBg}):Play()
        btn.TextColor3 = currentTheme.TextInactive
    end
    
    TweenService:Create(activeBtn, TweenInfo.new(0.2), {BackgroundColor3 = currentTheme.Accent}):Play()
    activeBtn.TextColor3 = currentTheme.TextActive
end

MainTabBtn.MouseButton1Click:Connect(function() switchTab(MainTabBtn, MainTabPage) end)
VisualsTabBtn.MouseButton1Click:Connect(function() switchTab(VisualsTabBtn, VisualsTabPage) end)
InfoTabBtn.MouseButton1Click:Connect(function() switchTab(InfoTabBtn, InfoPage) end)
SettingsTabBtn.MouseButton1Click:Connect(function() switchTab(SettingsTabBtn, SettingsPage) end)

MainTabBtn.BackgroundColor3 = currentTheme.Accent
MainTabBtn.TextColor3 = currentTheme.TextActive

refreshThemeUI = function()
    for btn, stateStore in pairs(activeToggleButtons) do
        if stateStore.State then
            btn.BackgroundColor3 = currentTheme.Accent
        end
    end
end


-- // --- UI BUILDERS (BUTTON, INPUT, TOGGLE) --- //
local function addButton(parent, name, icon, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = currentTheme.ButtonBg
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = "   " .. icon .. "   " .. name
    btn.TextColor3 = Color3.fromRGB(230, 230, 235)
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 6) c.Parent = btn
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = currentTheme.ButtonHover}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = currentTheme.ButtonBg}):Play()
    end)
    
    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = currentTheme.Accent}):Play()
        task.wait(0.15)
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = currentTheme.ButtonHover}):Play()
        pcall(callback)
    end)
    
    parent.CanvasSize = UDim2.new(0, 0, 0, parent:FindFirstChildOfClass("UIListLayout").AbsoluteContentSize.Y + 8)
end

local function addToggle(parent, name, icon, callback)
    local isEnabled = false
    
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = currentTheme.ButtonBg
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = "   " .. icon .. "   " .. name .. "  [OFF]"
    btn.TextColor3 = currentTheme.TextInactive
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 6) c.Parent = btn
    
    local stateStore = {State = false}
    activeToggleButtons[btn] = stateStore
    
    btn.MouseEnter:Connect(function()
        if not isEnabled then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = currentTheme.ButtonHover}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if not isEnabled then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = currentTheme.ButtonBg}):Play()
        end
    end)
    
    btn.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        stateStore.State = isEnabled
        
        if isEnabled then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = currentTheme.Accent}):Play()
            btn.TextColor3 = currentTheme.TextActive
            btn.Text = "   " .. icon .. "   " .. name .. "  [ON]"
        else
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = currentTheme.ButtonBg}):Play()
            btn.TextColor3 = currentTheme.TextInactive
            btn.Text = "   " .. icon .. "   " .. name .. "  [OFF]"
        end
        
        pcall(function() callback(isEnabled) end)
    end)
    
    parent.CanvasSize = UDim2.new(0, 0, 0, parent:FindFirstChildOfClass("UIListLayout").AbsoluteContentSize.Y + 8)
end

local function addInput(parent, name, placeholder, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = currentTheme.ButtonBg
    frame.Size = UDim2.new(1, 0, 0, 45)
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 6) c.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Font = Enum.Font.GothamSemibold
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220, 220, 230)
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local box = Instance.new("TextBox")
    box.Parent = frame
    box.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    box.Position = UDim2.new(1, -150, 0.5, -14)
    box.Size = UDim2.new(0, 140, 0, 28)
    box.Font = Enum.Font.Gotham
    box.PlaceholderText = placeholder
    box.Text = ""
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextSize = 11
    local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 4) bc.Parent = box
    
    box.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            pcall(function() callback(box.Text) end)
        end
    end)
    
    parent.CanvasSize = UDim2.new(0, 0, 0, parent:FindFirstChildOfClass("UIListLayout").AbsoluteContentSize.Y + 8)
end


-- // --- ORIGINAL SCRIPTS LOGIC (HnDiabloCircus) --- //

-- 1. Give Items
addButton(MainTabPage, "Give KeyBasement & Crowbar [Glitched]", "🕸️", function()
    local player = game.Players.LocalPlayer
    local backpack = player:WaitForChild("Backpack")
    local replicated = game:GetService("ReplicatedStorage")
    local folder = replicated:WaitForChild("ItemFolder")

    local function giveItem(name)
        local item = folder:FindFirstChild(name)
        if item then
            local clone = item:Clone()
            clone.Parent = backpack
            SendNotification("Item Giver", "Added Item: " .. name, Color3.fromRGB(60, 200, 100))
        else
            SendNotification("Item Giver", "Error For Adding: " .. name, Color3.fromRGB(200, 50, 50))
        end
    end

    giveItem("KeyBasement")
    giveItem("Crowbar")
end)

-- 2. Votes Inputs
addInput(MainTabPage, "Text Vote Normal Set", "Set value", function(zzz)
    pcall(function()
        game.ReplicatedStorage.Votes.Normal.Value = zzz
        SendNotification("Votes", "Normal vote set to: " .. zzz, currentTheme.Accent)
    end)
end)

addInput(MainTabPage, "Text Vote Double Set", "Set value", function(xxx)
    pcall(function()
        game.ReplicatedStorage.Votes.Double.Value = xxx
        SendNotification("Votes", "Double vote set to: " .. xxx, currentTheme.Accent)
    end)
end)

-- 3. FOV 120
addButton(MainTabPage, "Set FOV to 120", "👀", function()
    Workspace.Camera.FieldOfView = 120
    SendNotification("Camera", "FOV set to 120", currentTheme.Accent)
end)

-- 4. Open Neighbor Doors
addButton(MainTabPage, "Open Neighbor Doors", "🚪", function()
    pcall(function()
        Workspace:WaitForChild("Puzzle"):WaitForChild("House"):WaitForChild("Basics"):WaitForChild("Door"):WaitForChild("Door_Double"):WaitForChild("Door_Left"):WaitForChild("Interact"):FireServer()
        Workspace:WaitForChild("Puzzle"):WaitForChild("House"):WaitForChild("Basics"):WaitForChild("Door"):WaitForChild("Door_Double"):WaitForChild("Door_Right"):WaitForChild("Interact"):FireServer()
        SendNotification("Interaction", "Opened neighbor doors successfully!", Color3.fromRGB(60, 200, 100))
    end)
end)

-- 5. AutoFarm (Neighbor)
_G.LoopCatch = false
addToggle(MainTabPage, "AutoFarm [Must be Neighbor]", "👨‍🌾", function(Value)
    _G.LoopCatch = Value
    if Value then
        task.spawn(function()
            while _G.LoopCatch do
                local targetPlayer = nil
                local minDist = math.huge
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            targetPlayer = p
                        end
                    end
                end
                
                if targetPlayer and targetPlayer.Character then
                    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local myChar = LocalPlayer.Character
                    if targetRoot and myChar then
                        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
                        local soundsFolder = myRoot and myRoot:FindFirstChild("Sounds")
                        local catchSound = soundsFolder and soundsFolder:FindFirstChild("Catch")
                        if catchSound then
                            pcall(function()
                                Workspace:WaitForChild("NeighborScripts"):WaitForChild("Catch"):FireServer(targetRoot, catchSound)
                            end)
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
        SendNotification("AutoFarm", "AutoFarm activated!", Color3.fromRGB(60, 200, 100))
    else
        SendNotification("AutoFarm", "AutoFarm deactivated.", Color3.fromRGB(200, 50, 50))
    end
end)


-- // --- VISUALS & ESP LOGIC --- //

local ESP_Enabled = false
local itemNames = {
    ["KeyPlayer"] = true, ["KeyRR"] = true, ["Keycard"] = true, ["KeyCar"] = true,
    ["KeyBasement"] = true, ["Hammer"] = true, ["Crowbar"] = true, ["Magnet"] = true,
    ["Shovel"] = true, ["KeyPlayerAngry"] = true, ["HammerAngry"] = true, ["Box"] = true,
    ["JackHammer"] = true, ["Television"] = true
}

local trackedItems = {}
local espCache = {}

local function getOrCreateESP(object, name)
    if espCache[object] then 
        return espCache[object].Box, espCache[object].Billboard
    end

    local box = Instance.new("BoxHandleAdornment")
    box.Color3 = Color3.fromRGB(0, 255, 100)
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Transparency = 0.4
    box.Visible = false
    box.Parent = CoreGui

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 140, 0, 35)
    billboard.AlwaysOnTop = true
    billboard.ExtentsOffset = Vector3.new(0, 2, 0)
    billboard.Enabled = false
    billboard.Parent = CoreGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(0, 255, 100)
    label.TextStrokeTransparency = 0.6
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.TextSize = 15
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard

    espCache[object] = { Box = box, Billboard = billboard }
    return box, billboard
end

local function checkAndTrack(obj)
    if itemNames[obj.Name] then
        local targetPart = nil
        if obj:IsA("BasePart") then
            targetPart = obj
        else
            targetPart = obj:FindFirstChild("Handle") or obj:FindFirstChild("Screen") or obj:FindFirstChildWhichIsA("BasePart", true)
        end
        if targetPart and not trackedItems[obj] then
            trackedItems[obj] = targetPart
        end
    end
end

local function initialScan()
    local descendants = Workspace:GetDescendants()
    for i, obj in ipairs(descendants) do
        checkAndTrack(obj)
        if i % 200 == 0 then task.wait() end
    end
end

Workspace.DescendantAdded:Connect(function(obj) checkAndTrack(obj) end)
Workspace.DescendantRemoving:Connect(function(obj)
    if trackedItems[obj] then
        if espCache[obj] then
            espCache[obj].Box:Destroy()
            espCache[obj].Billboard:Destroy()
            espCache[obj] = nil
        end
        trackedItems[obj] = nil
    end
end)

task.spawn(initialScan)

RunService.RenderStepped:Connect(function()
    for obj, targetPart in pairs(trackedItems) do
        if obj and targetPart and targetPart.Parent and obj:IsDescendantOf(Workspace) then
            local box, billboard = getOrCreateESP(obj, obj.Name)
            if ESP_Enabled then
                box.Adornee = targetPart
                box.Size = targetPart.Size + Vector3.new(0.2, 0.2, 0.2)
                box.Visible = true
                billboard.Adornee = targetPart
                billboard.Enabled = true
            else
                box.Visible = false
                billboard.Enabled = false
            end
        else
            if espCache[obj] then
                espCache[obj].Box.Visible = false
                espCache[obj].Billboard.Enabled = false
            end
        end
    end
end)

-- Items ESP Toggle
addToggle(VisualsTabPage, "Items ESP (Objects/Keys)", "📦", function(Value)
    ESP_Enabled = Value
    if not Value then
        for _, visual in pairs(espCache) do
            visual.Box.Visible = false
            visual.Billboard.Enabled = false
        end
        SendNotification("Visuals", "Items ESP disabled.", Color3.fromRGB(200, 50, 50))
    else
        SendNotification("Visuals", "Items ESP enabled.", Color3.fromRGB(60, 200, 100))
    end
end)

-- Neighbor ESP Logic
local espEnabledNeighbor = false
local espHighlight = nil

local function updateNeighborESP()
    local neighbor = Workspace:FindFirstChild("Players") 
        and Workspace.Players:FindFirstChild("Neighbors") 
        and Workspace.Players.Neighbors:FindFirstChild("Neighbor")

    if espEnabledNeighbor and neighbor then
        if not espHighlight or not espHighlight:IsDescendantOf(game) then
            espHighlight = Instance.new("Highlight")
            espHighlight.Name = "NeighborESP"
            espHighlight.FillColor = Color3.fromRGB(255, 255, 0)
            espHighlight.FillTransparency = 0.5 
            espHighlight.OutlineColor = Color3.fromRGB(0, 0, 255)
            espHighlight.OutlineTransparency = 0 
            espHighlight.Parent = neighbor
        end
    else
        if espHighlight then
            espHighlight:Destroy()
            espHighlight = nil
        end
    end
end

task.spawn(function()
    while task.wait(1) do
        pcall(updateNeighborESP)
    end
end)

addToggle(VisualsTabPage, "Neighbor ESP", "🏘️", function(Value)
    espEnabledNeighbor = Value
    updateNeighborESP()
    if Value then
        SendNotification("Visuals", "Neighbor ESP enabled.", Color3.fromRGB(60, 200, 100))
    else
        SendNotification("Visuals", "Neighbor ESP disabled.", Color3.fromRGB(200, 50, 50))
    end
end)


-- // --- STARTUP ANIMATION --- //
MainFrame.Size = UDim2.new(0, 0, 0, 0)
local openTween = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 560, 0, 360)
})
openTween:Play()


-- // --- MINIMIZE LOGIC --- //
local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local targetSize = isMinimized and UDim2.new(0, 560, 0, 38) or UDim2.new(0, 560, 0, 360)
    
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = targetSize
    }):Play()
    
    Sidebar.Visible = not isMinimized
    PagesContainer.Visible = not isMinimized
    MinimizeBtn.Text = isMinimized and "+" or "─"
end)


-- // --- UNEXECUTE --- //
UnexecuteBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    WatermarkGui:Destroy()
    NotifScreenGui:Destroy()
end)

SendNotification("SpyNotify", "🕷️SpyHub🕷️ Loaded successfully inside Rise Client!", currentTheme.Accent)