local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

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

-- 完美像素级拖动，杜绝乱飞
local function makeDraggable(targetFrame, dragHandle)
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragInput = input
            dragStart = Vector2.new(input.Position.X, input.Position.Y)
            startPos = targetFrame.AbsolutePosition
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if not dragging or input ~= dragInput then return end
        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
        local vp = workspace.CurrentCamera.ViewportSize
        local fSize = targetFrame.AbsoluteSize
        
        local newX = startPos.X + delta.X
        local newY = startPos.Y + delta.Y
        
        newX = math.clamp(newX, 0, math.max(0, vp.X - fSize.X))
        newY = math.clamp(newY, 0, math.max(0, vp.Y - fSize.Y))
        
        targetFrame.Position = UDim2.fromOffset(newX, newY)
    end)
    
    UIS.InputEnded:Connect(function(input)
        if input == dragInput then
            dragging = false
            dragInput = nil
        end
    end)
end

local gui = new("ScreenGui", { 
    Name = "QuickLoader", 
    ResetOnSpawn = false, 
    IgnoreGuiInset = true, 
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling 
}, playerGui)

local vp = workspace.CurrentCamera.ViewportSize

-- ================= 1. 主面板 =================
local panel = new("Frame", { 
    Size = UDim2.new(0, 280, 0, 340), 
    Position = UDim2.fromOffset(vp.X - 290, 10), 
    BackgroundColor3 = Color3.fromRGB(30, 30, 38), 
    BorderSizePixel = 0, 
    Active = true, 
    ClipsDescendants = true, 
    ZIndex = 10
}, gui)
new("UICorner", { CornerRadius = UDim.new(0, 12) }, panel)
new("UIStroke", { Color = Color3.fromRGB(80, 80, 100), Thickness = 1, Transparency = 0.5 }, panel)

local titleBar = new("Frame", { Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Color3.fromRGB(38, 38, 48), BorderSizePixel = 0, ZIndex = 11 }, panel)
new("UICorner", { CornerRadius = UDim.new(0, 12) }, titleBar)
new("Frame", { Size = UDim2.new(1, 0, 0, 15), Position = UDim2.new(0, 0, 1, -15), BackgroundColor3 = Color3.fromRGB(38, 38, 48), BorderSizePixel = 0, ZIndex = 11 }, titleBar)
new("TextLabel", { Size = UDim2.new(1, -40, 1, 0), Position = UDim2.new(0, 16, 0, 0), BackgroundTransparency = 1, Text = "⚡ 速启动中心", TextColor3 = Color3.fromRGB(240, 240, 255), Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 12 }, titleBar)

local minBtn = new("TextButton", { Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(1, -32, 0.5, -12), BackgroundColor3 = Color3.fromRGB(255, 95, 86), Text = "×", TextColor3 = Color3.fromRGB(150, 50, 50), Font = Enum.Font.GothamBold, TextSize = 16, AutoButtonColor = false, ZIndex = 12 }, titleBar)
new("UICorner", { CornerRadius = UDim.new(0, 6) }, minBtn)

makeDraggable(panel, titleBar)

local contentContainer = new("Frame", { Size = UDim2.new(1, 0, 1, -40), Position = UDim2.new(0, 0, 0, 40), BackgroundTransparency = 1, ZIndex = 11 }, panel)

local btnRow = new("Frame", { Size = UDim2.new(1, -24, 0, 42), Position = UDim2.new(0, 12, 0, 8), BackgroundTransparency = 1, ZIndex = 11 }, contentContainer)
new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, btnRow)

new("TextLabel", { Size = UDim2.new(1, -24, 0, 18), Position = UDim2.new(0, 12, 0, 58), BackgroundTransparency = 1, Text = "运行日志", TextColor3 = Color3.fromRGB(140, 140, 160), Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 11 }, contentContainer)

local logFrame = new("Frame", { Size = UDim2.new(1, -24, 1, -86), Position = UDim2.new(0, 12, 0, 78), BackgroundColor3 = Color3.fromRGB(20, 20, 26), BorderSizePixel = 0, ZIndex = 11 }, contentContainer)
new("UICorner", { CornerRadius = UDim.new(0, 8) }, logFrame)
new("UIStroke", { Color = Color3.fromRGB(50, 50, 60), Thickness = 1 }, logFrame)

local logScroll = new("ScrollingFrame", { Size = UDim2.new(1, -10, 1, -10), Position = UDim2.new(0, 5, 0, 5), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120), CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 12 }, logFrame)
new("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }, logScroll)
new("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4) }, logScroll)

-- ================= 2. 弹窗（无遮罩，独立悬浮） =================
local popup = new("Frame", { 
    Size = UDim2.new(0, 240, 0, 220), 
    Position = UDim2.fromOffset(vp.X / 2 - 120, vp.Y / 2 - 110), -- 绝对居中
    BackgroundColor3 = Color3.fromRGB(35, 35, 45), 
    BorderSizePixel = 0, 
    Visible = false,
    ZIndex = 20
}, gui)
new("UICorner", { CornerRadius = UDim.new(0, 12) }, popup)
new("UIStroke", { Color = Color3.fromRGB(100, 100, 130), Thickness = 1.5 }, popup)

local popTitleBar = new("Frame", { Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = Color3.fromRGB(45, 45, 55), BorderSizePixel = 0, ZIndex = 21 }, popup)
new("UICorner", { CornerRadius = UDim.new(0, 12) }, popTitleBar)
new("Frame", { Size = UDim2.new(1, 0, 0, 12), Position = UDim2.new(0, 0, 1, -12), BackgroundColor3 = Color3.fromRGB(45, 45, 55), BorderSizePixel = 0, ZIndex = 21 }, popTitleBar)

new("TextLabel", { Size = UDim2.new(1, -50, 1, 0), Position = UDim2.new(0, 16, 0, 0), BackgroundTransparency = 1, Text = "📜 选择脚本", TextColor3 = Color3.fromRGB(220, 220, 230), Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 22 }, popTitleBar)

local closePopBtn = new("TextButton", { Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(1, -32, 0.5, -12), BackgroundColor3 = Color3.fromRGB(90, 90, 110), Text = "✕", TextColor3 = Color3.fromRGB(200, 200, 220), Font = Enum.Font.GothamBold, TextSize = 12, AutoButtonColor = false, ZIndex = 22 }, popTitleBar)
new("UICorner", { CornerRadius = UDim.new(0, 6) }, closePopBtn)

makeDraggable(popup, popTitleBar)

local selList = new("ScrollingFrame", { Size = UDim2.new(1, -20, 1, -46), Position = UDim2.new(0, 10, 0, 40), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120), CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 22 }, popup)
new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, selList)

local function togglePopup(show)
    local target = show
    if target == nil then target = not popup.Visible end
    popup.Visible = target
    if target then
        popup.Position = UDim2.fromOffset(vp.X / 2 - 120, vp.Y / 2 - 110)
    end
end
closePopBtn.MouseButton1Click:Connect(function() togglePopup(false) end)

-- ================= 3. 核心逻辑 =================
local COLORS = {
    info = Color3.fromRGB(180,180,220), success = Color3.fromRGB(100,230,120),
    error = Color3.fromRGB(255,110,110), warn = Color3.fromRGB(255,200,100),
    race = Color3.fromRGB(140,180,255), cache = Color3.fromRGB(255, 220, 100)
}

local function log(msg, level, prefix)
    prefix = prefix and ("["..prefix.."] ") or ""
    logCount = logCount + 1
    if logCount > MAX_LOG_LINES then
        local oldest = logScroll:FindFirstChildWhichIsA("Frame")
        if oldest then oldest:Destroy() end
    end
    local row = new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = -logCount, ZIndex = 12 }, logScroll)
    new("TextLabel", { Size = UDim2.new(0, 50, 0, 16), BackgroundTransparency = 1, Text = os.date("%H:%M:%S"), TextColor3 = Color3.fromRGB(100, 100, 120), Font = Enum.Font.Code, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 13 }, row)
    new("TextLabel", { Size = UDim2.new(1, -55, 0, 0), Position = UDim2.new(0, 55, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Text = prefix .. msg, TextColor3 = COLORS[level] or COLORS.info, Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, ZIndex = 13 }, row)
    task.defer(function() logScroll.CanvasPosition = Vector2.new(0, logScroll.AbsoluteCanvasSize.Y) end)
    print("[速启动] " .. prefix .. msg)
end

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
            task.spawn(function()
                local t0 = os.clock()
                local ok, data = pcall(function() return game:HttpGet(buildUrl(m, testUrl), true) end)
                if ok and data and #data >= MIN_SIZE then
                    results[i] = { name = m[1], ok = true, time = os.clock() - t0, mirror = m }
                else
                    results[i] = { name = m[1], ok = false, time = os.clock() - t0 }
                end
                pending = pending - 1
            end)
        end

        local deadline = os.clock() + TIMEOUT
        while pending > 0 and os.clock() < deadline do task.wait(0.05) end

        local validResults = {}
        for i, res in pairs(results) do table.insert(validResults, res or { name = MIRRORS[i][1], ok = false, time = TIMEOUT }) end
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
                listText = listText .. string.format("%s%s (%s)\n", icon, res.name, res.ok and (math.floor(res.time * 1000).."ms") or "超时")
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
        local t0 = os.clock()
        local ok, data = pcall(function() return game:HttpGet(buildUrl(lastBestMirror, url), true) end)
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
        task.spawn(function()
            local t0 = os.clock()
            local ok, data = pcall(function() return game:HttpGet(buildUrl(m, url), true) end)
            if done then return end
            if ok and data and #data >= MIN_SIZE then
                done = true
                winner = { name = m[1], data = data, elapsed = os.clock() - t0 }
                lastBestMirror = m
                lastBestTime = os.clock()
                log(string.format("🏆 %s (%.2fs)", m[1], winner.elapsed), "race", prefix)
            end
        end)
    end

    while not done and os.clock() < deadline do task.wait(0.05) end
    return winner or nil, winner and nil or "节点未响应"
end

local function resetBtnState(url, name)
    local b = selList:FindFirstChild(url)
    if b then
        b.Active = true; b.TextTransparency = 0; b.Text = "🚀 " .. name; b.BackgroundColor3 = Color3.fromRGB(60, 140, 220)
    end
end

local function loadScript(scriptInfo)
    local url, name = scriptInfo.url, scriptInfo.name
    if scriptStatus[url] == "loading" then log("正在加载，请等待...", "warn", name) return end
    if scriptStatus[url] == "loaded" then log("该脚本已加载", "warn", name) return end
    
    scriptStatus[url] = "loading"
    togglePopup(false)

    local targetBtn = selList:FindFirstChild(url) 
    if targetBtn then targetBtn.Active = false; targetBtn.TextTransparency = 0.5; targetBtn.Text = "⏳ 加载中"; targetBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100) end

    log("开始加载...", "info", name)
    local winner, err = raceDownload(url, name)
    if not winner then
        log(err or "竞速失败", "error", name); scriptStatus[url] = "error"; resetBtnState(url, name); return
    end

    local fn, compileErr = loadstring(winner.data)
    if not fn then
        log("编译失败: " .. tostring(compileErr), "error", name); scriptStatus[url] = "error"; resetBtnState(url, name); return
    end

    local ok, execErr = pcall(fn)
    if not ok then
        log("执行出错: " .. tostring(execErr), "error", name); scriptStatus[url] = "error"; resetBtnState(url, name)
    else
        log(string.format("🎉 加载成功！(%s, %.2fs)", winner.name, winner.elapsed), "success", name)
        scriptStatus[url] = "loaded" 
        if targetBtn then targetBtn.Active = false; targetBtn.TextTransparency = 0.5; targetBtn.Text = "✅ 已加载"; targetBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 80) end
    end
end

local function makeMainBtn(text, color, order, name)
    local b = new("TextButton", { Size = UDim2.new(1/3, -6, 1, 0), BackgroundColor3 = color, Text = text, TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 12, AutoButtonColor = false, LayoutOrder = order, Name = name, ZIndex = 12 }, btnRow)
    new("UICorner", { CornerRadius = UDim.new(0, 8) }, b)
    return b
end

local btnTest = makeMainBtn("⚡ 测速", Color3.fromRGB(200, 150, 50), 1, "btn1")
local btnSelect = makeMainBtn("📜 脚本", Color3.fromRGB(60, 180, 120), 2, "btn2")
local btnExit = makeMainBtn("❌ 退出", Color3.fromRGB(220, 80, 80), 3, "btn3")

btnTest.MouseButton1Click:Connect(function() task.spawn(doSpeedTest) end)
btnSelect.MouseButton1Click:Connect(function() togglePopup() end)
btnExit.MouseButton1Click:Connect(function() log("正在退出...", "warn"); task.wait(0.2); if gui.Parent then gui:Destroy() end end)

for i, scriptInfo in ipairs(SCRIPT_LIST) do
    local btn = new("TextButton", { Size = UDim2.new(1, 0, 0, 42), BackgroundColor3 = Color3.fromRGB(50, 120, 200), Text = "🚀 " .. scriptInfo.name, TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 13, AutoButtonColor = false, LayoutOrder = i, Name = scriptInfo.url, ZIndex = 22 }, selList)
    new("UICorner", { CornerRadius = UDim.new(0, 6) }, btn)
    btn.MouseButton1Click:Connect(function() task.spawn(loadScript, scriptInfo) end)
end

local minimized, savedSize = false, panel.Size
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        savedSize = panel.Size
        contentContainer.Visible = false
        panel.Size = UDim2.new(0, 280, 0, 40)
        togglePopup(false)
        minBtn.Text = "□"; minBtn.BackgroundColor3 = Color3.fromRGB(90, 90, 130)
    else
        panel.Size = savedSize
        contentContainer.Visible = true
        minBtn.Text = "×"; minBtn.BackgroundColor3 = Color3.fromRGB(255, 95, 86)
    end
end)

log("系统已就绪", "success")