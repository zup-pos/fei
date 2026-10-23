local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 清理旧UI
local oldGui = playerGui:FindFirstChild("QuickLoader")
if oldGui then oldGui:Destroy() end

local SCRIPT_LIST = {
    { name = "多功能脚本", url = "https://raw.githubusercontent.com/zup-pos/fei/refs/heads/main/feitian.txt" },
    { name = "绘制与吸附", url = "https://raw.githubusercontent.com/zup-pos/fei/refs/heads/main/绘制与吸附.txt" },
}

local MIRRORS = {
    { "主(gh-proxy)",       "https://gh-proxy.org/%s" },
    { "备1(githubproxy)",   "https://githubproxy.cc/%s" },
    { "备2(ghproxy)",       "https://ghproxy.net/%s" },
    { "备3(raw.gitmirror)", nil },
    { "备4(raw.ihtw)",      "https://raw.ihtw.moe/%s" },
    { "备5(gh.llkk.cc)",    "https://gh.llkk.cc/%s" },
    { "直连",               "%s" },
}

local TIMEOUT = 8
local MIN_SIZE = 100
local MAX_LOG_LINES = 80
local CACHE_TIMEOUT = 10

local lastBestMirror = nil
local lastBestTime = 0
local logCount = 0
local testing = false
local scriptStatus = {}

local function new(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local gui = new("ScreenGui", { Name = "QuickLoader", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling }, playerGui)

-- 主面板
local panel = new("Frame", { 
    Size = UDim2.new(0, 280, 0, 360), 
    Position = UDim2.new(0.65, -140, 0, 60), 
    BackgroundColor3 = Color3.fromRGB(30, 30, 38), 
    BorderSizePixel = 0, 
    Active = true,
    ClipsDescendants = true
}, gui)
new("UICorner", { CornerRadius = UDim.new(0, 12) }, panel)

-- 模拟阴影效果
local shadow = new("ImageLabel", {
    Size = UDim2.new(1, 40, 1, 40),
    Position = UDim2.new(0.5, -20, 0.5, -20),
    BackgroundTransparency = 1,
    Image = "rbxassetid://1316045217",
    ImageColor3 = Color3.new(0, 0, 0),
    ImageTransparency = 0.6,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(10, 10, 118, 118),
    ZIndex = -1
}, panel)
shadow.Parent = gui
-- 绑定阴影位置
panel:GetPropertyChangedSignal("Position"):Connect(function()
    shadow.Position = UDim2.new(panel.Position.X.Scale, panel.Position.X.Offset - 20, panel.Position.Y.Scale, panel.Position.Y.Offset - 20)
end)
shadow.Position = UDim2.new(panel.Position.X.Scale, panel.Position.X.Offset - 20, panel.Position.Y.Scale, panel.Position.Y.Offset - 20)

new("UIStroke", { Color = Color3.fromRGB(80, 80, 100), Thickness = 1, Transparency = 0.5 }, panel)

-- 标题栏
local titleBar = new("Frame", { Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Color3.fromRGB(38, 38, 48), BorderSizePixel = 0 }, panel)
new("UICorner", { CornerRadius = UDim.new(0, 12) }, titleBar)
new("Frame", { Size = UDim2.new(1, 0, 0, 15), Position = UDim2.new(0, 0, 1, -15), BackgroundColor3 = Color3.fromRGB(38, 38, 48), BorderSizePixel = 0 }, titleBar)

new("TextLabel", { 
    Size = UDim2.new(1, -40, 1, 0), 
    Position = UDim2.new(0, 16, 0, 0), 
    BackgroundTransparency = 1, 
    Text = "⚡ 速启动中心", 
    TextColor3 = Color3.fromRGB(240, 240, 255), 
    Font = Enum.Font.GothamBold, 
    TextSize = 14, 
    TextXAlignment = Enum.TextXAlignment.Left 
}, titleBar)

local minBtn = new("TextButton", { 
    Size = UDim2.new(0, 24, 0, 24), 
    Position = UDim2.new(1, -32, 0.5, -12), 
    BackgroundColor3 = Color3.fromRGB(255, 95, 86), 
    Text = "×", 
    TextColor3 = Color3.fromRGB(150, 50, 50), 
    Font = Enum.Font.GothamBold, 
    TextSize = 16, 
    AutoButtonColor = false 
}, titleBar)
new("UICorner", { CornerRadius = UDim.new(0, 6) }, minBtn)

-- 按钮行
local btnRow = new("Frame", { Size = UDim2.new(1, -24, 0, 42), Position = UDim2.new(0, 12, 0, 48), BackgroundTransparency = 1 }, panel)
new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, btnRow)

-- 日志区
new("TextLabel", { Size = UDim2.new(1, -24, 0, 18), Position = UDim2.new(0, 12, 0, 98), BackgroundTransparency = 1, Text = "运行日志", TextColor3 = Color3.fromRGB(140, 140, 160), Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left }, panel)

local logFrame = new("Frame", { Size = UDim2.new(1, -24, 1, -158), Position = UDim2.new(0, 12, 0, 118), BackgroundColor3 = Color3.fromRGB(20, 20, 26), BorderSizePixel = 0 }, panel)
new("UICorner", { CornerRadius = UDim.new(0, 8) }, logFrame)
new("UIStroke", { Color = Color3.fromRGB(50, 50, 60), Thickness = 1 }, logFrame)

local logScroll = new("ScrollingFrame", { Size = UDim2.new(1, -10, 1, -10), Position = UDim2.new(0, 5, 0, 5), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120), CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y }, logFrame)
new("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }, logScroll)
new("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4) }, logScroll)

-- 抽屉式选择菜单
local selectorPanel = new("Frame", { Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(35, 35, 45), BorderSizePixel = 0, Visible = false, ZIndex = 10 }, panel)
new("UICorner", { CornerRadius = UDim.new(0, 12) }, selectorPanel)
new("UIStroke", { Color = Color3.fromRGB(80, 80, 100), Thickness = 1 }, selectorPanel)

local selTitle = new("TextLabel", { Size = UDim2.new(1, -50, 0, 36), Position = UDim2.new(0, 16, 0, 0), BackgroundTransparency = 1, Text = "选择要加载的脚本", TextColor3 = Color3.fromRGB(220, 220, 230), Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 11 }, selectorPanel)
local closeSelBtn = new("TextButton", { Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(1, -36, 0, 6), BackgroundColor3 = Color3.fromRGB(60, 60, 80), Text = "▼", TextColor3 = Color3.fromRGB(200, 200, 220), Font = Enum.Font.GothamBold, TextSize = 12, AutoButtonColor = false, ZIndex = 11 }, selectorPanel)
new("UICorner", { CornerRadius = UDim.new(0, 6) }, closeSelBtn)

local selList = new("ScrollingFrame", { Size = UDim2.new(1, -24, 0, 140), Position = UDim2.new(0, 12, 0, 40), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120), CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 11 }, selectorPanel)
new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, selList)

-- 抽屉动画
local isDrawerOpen = false
local function toggleDrawer(open)
    isDrawerOpen = open
    selectorPanel.Visible = true
    local targetSize = open and UDim2.new(1, 0, 0, 180) or UDim2.new(1, 0, 0, 0)
    local targetPos = open and UDim2.new(0, 0, 1, -180) or UDim2.new(0, 0, 1, 0)
    TweenService:Create(selectorPanel, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = targetSize, Position = targetPos }):Play()
    if not open then
        task.delay(0.25, function() if not isDrawerOpen then selectorPanel.Visible = false end end)
    end
end
closeSelBtn.MouseButton1Click:Connect(function() toggleDrawer(false) end)

-- 日志系统
local COLORS = {
    info = Color3.fromRGB(180,180,220), success = Color3.fromRGB(100,230,120),
    error = Color3.fromRGB(255,110,110), warn = Color3.fromRGB(255,200,100),
    race = Color3.fromRGB(140,180,255), cache = Color3.fromRGB(255, 220, 100)
}

local function log(msg, level, prefix)
    prefix = prefix and ("["..prefix.."] ") or ""
    logCount = logCount + 1
    if logCount > MAX_LOG_LINES then
        local oldest = logScroll:FindFirstChildWhichIsA("TextLabel")
        if oldest then oldest:Destroy() end
    end
    
    local row = new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = -logCount }, logScroll)
    
    local timeLbl = new("TextLabel", { Size = UDim2.new(0, 50, 0, 16), BackgroundTransparency = 1, Text = os.date("%H:%M:%S"), TextColor3 = Color3.fromRGB(100, 100, 120), Font = Enum.Font.Code, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left }, row)
    
    local msgLbl = new("TextLabel", { Size = UDim2.new(1, -55, 0, 0), Position = UDim2.new(0, 55, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Text = prefix .. msg, TextColor3 = COLORS[level] or COLORS.info, Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true }, row)
    
    task.defer(function() logScroll.CanvasPosition = Vector2.new(0, logScroll.AbsoluteCanvasSize.Y) end)
    print("[速启动] " .. prefix .. msg)
end

-- 核心逻辑
local function buildUrl(mirror, url)
    if mirror[2] == nil then return url:gsub("raw%.githubusercontent%.com", "raw.gitmirror.com") end
    return string.format(mirror[2], url)
end

local function doSpeedTest()
    if testing then return end
    testing = true
    local targetBtn = btnRow:FindFirstChild("btn1")
    if targetBtn then targetBtn.Text = "⏳ 测速中"; targetBtn.Active = false; targetBtn.TextColor3 = Color3.fromRGB(150,150,150) end

    log("开始全量并发测速...", "info", "测速")
    local results, pending = {}, #MIRRORS
    local testUrl = SCRIPT_LIST[1].url

    task.spawn(function()
        for i, m in ipairs(MIRRORS) do
            local name = m[1]
            local fullUrl = buildUrl(m, testUrl)
            task.spawn(function()
                local t0 = os.clock()
                local ok, data = pcall(function() return game:HttpGet(fullUrl, true) end)
                local elapsed = os.clock() - t0
                if ok and data and #data >= MIN_SIZE then
                    results[i] = { name = name, ok = true, time = elapsed, mirror = m }
                else
                    results[i] = { name = name, ok = false, time = elapsed }
                end
                pending = pending - 1
            end)
        end

        local deadline = os.clock() + TIMEOUT
        while pending > 0 and os.clock() < deadline do task.wait(0.05) end

        local validResults = {}
        for i, res in pairs(results) do
            table.insert(validResults, res or { name = MIRRORS[i][1], ok = false, time = TIMEOUT })
        end
        table.sort(validResults, function(a, b)
            if a.ok and not b.ok then return true end
            if not a.ok and b.ok then return false end
            return a.time < b.time
        end)

        local best = validResults[1]
        if best and best.ok then
            lastBestMirror = best.mirror
            lastBestTime = os.clock()
            local listText = "\n"
            for i, res in ipairs(validResults) do
                local icon = (i == 1) and "🏆 " or "🔸 "
                local timeStr = res.ok and (math.floor(res.time * 1000) .. "ms") or "超时"
                listText = listText .. string.format("%s%s (%s)\n", icon, res.name, timeStr)
            end
            log("测速完毕:" .. listText, "success", "测速")
        else
            log("所有节点不可用", "error", "测速")
            lastBestMirror = nil
        end

        testing = false
        if targetBtn then targetBtn.Text = "⚡ 测速"; targetBtn.Active = true; targetBtn.TextColor3 = Color3.fromRGB(255,255,255) end
    end)
end

local function raceDownload(url, prefix)
    if lastBestMirror and (os.clock() - lastBestTime <= CACHE_TIMEOUT) then
        log("命中缓存: " .. lastBestMirror[1], "cache", prefix)
        local fullUrl = buildUrl(lastBestMirror, url)
        local t0 = os.clock()
        local ok, data = pcall(function() return game:HttpGet(fullUrl, true) end)
        if ok and data and #data >= MIN_SIZE then
            lastBestTime = os.clock()
            return { name = lastBestMirror[1].."(缓存)", data = data, elapsed = os.clock() - t0 }
        else
            log("缓存失效，重新测速", "warn", prefix)
            lastBestMirror = nil
        end
    end

    local winner, done = nil, false
    local deadline = os.clock() + TIMEOUT

    for _, m in ipairs(MIRRORS) do
        local name = m[1]
        local fullUrl = buildUrl(m, url)
        task.spawn(function()
            local t0 = os.clock()
            local ok, data = pcall(function() return game:HttpGet(fullUrl, true) end)
            if done then return end
            if ok and data and #data >= MIN_SIZE then
                done = true
                winner = { name = name, data = data, elapsed = os.clock() - t0 }
                lastBestMirror = m
                lastBestTime = os.clock()
                log(string.format("🏆 %s (%.2fs)", name, winner.elapsed), "race", prefix)
            end
        end)
    end

    while not done and os.clock() < deadline do task.wait(0.05) end
    return winner or nil, winner and nil or "节点未响应"
end

local function resetBtnState(url, name)
    local b = selList:FindFirstChild(url)
    if b then
        b.Active = true
        b.TextTransparency = 0
        b.Text = "🚀 " .. name
        b.BackgroundColor3 = Color3.fromRGB(60, 140, 220)
    end
end

local function loadScript(scriptInfo)
    local url, name = scriptInfo.url, scriptInfo.name
    if scriptStatus[url] == "loading" then log("正在加载，请等待...", "warn", name) return end
    if scriptStatus[url] == "loaded" then log("该脚本已加载", "warn", name) return end
    
    scriptStatus[url] = "loading"
    toggleDrawer(false)

    local targetBtn = selList:FindFirstChild(url) 
    if targetBtn then targetBtn.Active = false; targetBtn.TextTransparency = 0.5; targetBtn.Text = "⏳ 加载中"; targetBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100) end

    log("开始加载...", "info", name)
    local winner, err = raceDownload(url, name)
    if not winner then
        log(err or "竞速失败", "error", name)
        scriptStatus[url] = "error"
        resetBtnState(url, name)
        return
    end

    local fn, compileErr = loadstring(winner.data)
    if not fn then
        log("编译失败: " .. tostring(compileErr), "error", name)
        scriptStatus[url] = "error"
        resetBtnState(url, name)
        return
    end

    local ok, execErr = pcall(fn)
    if not ok then
        log("执行出错: " .. tostring(execErr), "error", name)
        scriptStatus[url] = "error"
        resetBtnState(url, name)
    else
        log(string.format("🎉 加载成功！(%s, %.2fs)", winner.name, winner.elapsed), "success", name)
        scriptStatus[url] = "loaded" 
        if targetBtn then targetBtn.Active = false; targetBtn.TextTransparency = 0.5; targetBtn.Text = "✅ 已加载"; targetBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 80) end
    end
end

-- 按钮生成器
local function makeMainBtn(text, color, order, name)
    local b = new("TextButton", { 
        Size = UDim2.new(1/3, -6, 1, 0), 
        BackgroundColor3 = color, 
        Text = text, 
        TextColor3 = Color3.fromRGB(255,255,255), 
        Font = Enum.Font.GothamBold, 
        TextSize = 12, 
        AutoButtonColor = false, 
        LayoutOrder = order, 
        Name = name 
    }, btnRow)
    new("UICorner", { CornerRadius = UDim.new(0, 8) }, b)
    return b
end

local btnTest = makeMainBtn("⚡ 测速", Color3.fromRGB(200, 150, 50), 1, "btn1")
local btnSelect = makeMainBtn("📜 脚本", Color3.fromRGB(60, 180, 120), 2, "btn2")
local btnExit = makeMainBtn("❌ 退出", Color3.fromRGB(220, 80, 80), 3, "btn3")

-- 按钮点击动画
local function bindClickAnim(btn)
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(btn.Size.X.Scale, btn.Size.X.Offset + 4, btn.Size.Y.Scale, btn.Size.Y.Offset - 2)}):Play()
    end)
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1/3, -6, 1, 0)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1/3, -6, 1, 0)}):Play()
    end)
end
bindClickAnim(btnTest); bindClickAnim(btnSelect); bindClickAnim(btnExit)

btnTest.MouseButton1Click:Connect(function() task.spawn(doSpeedTest) end)
btnSelect.MouseButton1Click:Connect(function() toggleDrawer(not isDrawerOpen) end)
btnExit.MouseButton1Click:Connect(function() 
    log("正在退出...", "warn")
    task.wait(0.2)
    if gui.Parent then gui:Destroy() end 
end)

for i, scriptInfo in ipairs(SCRIPT_LIST) do
    local btn = new("TextButton", { Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Color3.fromRGB(50, 120, 200), Text = "🚀 " .. scriptInfo.name, TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 12, AutoButtonColor = false, LayoutOrder = i, Name = scriptInfo.url, ZIndex = 12 }, selList)
    new("UICorner", { CornerRadius = UDim.new(0, 6) }, btn)
    btn.MouseButton1Click:Connect(function() task.spawn(loadScript, scriptInfo) end)
end

-- 拖动逻辑（极其严格，防止多指干扰）
local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then return end
        dragging = true
        dragInput = input
        dragStart = Vector2.new(input.Position.X, input.Position.Y)
        startPos = panel.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if not dragging then return end
    if input ~= dragInput then return end -- 严格锁定第一根手指
    local d = Vector2.new(input.Position.X, input.Position.Y) - dragStart
    panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    shadow.Position = UDim2.new(panel.Position.X.Scale, panel.Position.X.Offset - 20, panel.Position.Y.Scale, panel.Position.Y.Offset - 20)
end)

UIS.InputEnded:Connect(function(input)
    if input ~= dragInput then return end
    dragging = false
    dragInput = nil
end)

-- 最小化逻辑
local minimized, savedSize = false, panel.Size
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        savedSize = panel.Size
        TweenService:Create(panel, TweenInfo.new(0.2), {Size = UDim2.new(0, 280, 0, 40)}):Play()
        btnRow.Visible = false
        logFrame.Visible = false
        logScroll.Visible = false
        selectorPanel.Visible = false
        minBtn.Text = "□"
        minBtn.BackgroundColor3 = Color3.fromRGB(90, 90, 130)
    else
        TweenService:Create(panel, TweenInfo.new(0.2), {Size = savedSize}):Play()
        btnRow.Visible = true
        logFrame.Visible = true
        logScroll.Visible = true
        minBtn.Text = "×"
        minBtn.BackgroundColor3 = Color3.fromRGB(255, 95, 86)
    end
end)

log("系统已就绪 (Pro Max UI)", "success")
log("请点击「脚本」按钮选择加载", "info")