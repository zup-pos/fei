local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local URLS = {
    "https://raw.githubusercontent.com/zup-pos/fei/refs/heads/main/feitian.txt",
    "https://raw.githubusercontent.com/zup-pos/fei/refs/heads/main/绘制与吸附.txt",
}
local NAMES = { "多功能", "绘制" }

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

-- 两个独立的状态锁：[1] 锁脚本一，[2] 锁脚本二
local loadingStates = { [1] = false, [2] = false }

local function new(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local gui = new("ScreenGui", {
    Name = "QuickLoader", ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, playerGui)

local panel = new("Frame", {
    Size = UDim2.new(0, 260, 0, 320),
    Position = UDim2.new(0.65, -130, 0, 0),
    BackgroundColor3 = Color3.fromRGB(25, 25, 32),
    BorderSizePixel = 0, Active = true,
}, gui)
new("UICorner", { CornerRadius = UDim.new(0, 10) }, panel)
new("UIStroke", { Color = Color3.fromRGB(70,70,100), Thickness = 1.5, Transparency = 0.2 }, panel)

local titleBar = new("Frame", {
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundColor3 = Color3.fromRGB(45, 45, 65),
    BorderSizePixel = 0,
}, panel)
new("UICorner", { CornerRadius = UDim.new(0, 10) }, titleBar)
new("Frame", {
    Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 1, -10),
    BackgroundColor3 = Color3.fromRGB(45, 45, 65), BorderSizePixel = 0,
}, titleBar)
new("TextLabel", {
    Size = UDim2.new(1, -40, 1, 0), Position = UDim2.new(0, 12, 0, 0),
    BackgroundTransparency = 1, Text = "⚡ 速启动加载器",
    TextColor3 = Color3.fromRGB(230, 230, 255), Font = Enum.Font.GothamBold,
    TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
}, titleBar)

local minBtn = new("TextButton", {
    Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(1, -26, 0, 4),
    BackgroundColor3 = Color3.fromRGB(90, 90, 130),
    Text = "—", TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamBold, TextSize = 14, AutoButtonColor = false,
}, titleBar)
new("UICorner", { CornerRadius = UDim.new(0, 4) }, minBtn)

local btnRow = new("Frame", {
    Size = UDim2.new(1, -16, 0, 46), Position = UDim2.new(0, 8, 0, 38),
    BackgroundTransparency = 1,
}, panel)
new("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder,
}, btnRow)

new("TextLabel", {
    Size = UDim2.new(1, -16, 0, 18), Position = UDim2.new(0, 8, 0, 92),
    BackgroundTransparency = 1, Text = "📋 运行日志",
    TextColor3 = Color3.fromRGB(180, 180, 220),
    Font = Enum.Font.GothamBold, TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
}, panel)

local logFrame = new("Frame", {
    Size = UDim2.new(1, -16, 1, -118), Position = UDim2.new(0, 8, 0, 110),
    BackgroundColor3 = Color3.fromRGB(15, 15, 20), BorderSizePixel = 0,
}, panel)
new("UICorner", { CornerRadius = UDim.new(0, 6) }, logFrame)

local logScroll = new("ScrollingFrame", {
    Size = UDim2.new(1, -8, 1, -8), Position = UDim2.new(0, 4, 0, 4),
    BackgroundTransparency = 1, BorderSizePixel = 0,
    ScrollBarThickness = 4, ScrollBarImageColor3 = Color3.fromRGB(90, 90, 130),
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, logFrame)
new("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder }, logScroll)

local COLORS = {
    info = Color3.fromRGB(180,180,220), success = Color3.fromRGB(100,230,120),
    error = Color3.fromRGB(255,100,100), warn = Color3.fromRGB(255,200,100),
    race = Color3.fromRGB(140,180,255), cache = Color3.fromRGB(255, 220, 100)
}

local function log(msg, level, prefix)
    prefix = prefix and ("["..prefix.."] ") or ""
    logCount = logCount + 1
    if logCount > MAX_LOG_LINES then
        local oldest = logScroll:FindFirstChildWhichIsA("TextLabel")
        if oldest then oldest:Destroy() end
    end

    new("TextLabel", {
        Size = UDim2.new(1, -4, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text = "[" .. os.date("%H:%M:%S") .. "] " .. prefix .. msg,
        TextColor3 = COLORS[level] or COLORS.info,
        Font = Enum.Font.Code, TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true,
    }, logScroll)
    
    task.defer(function()
        logScroll.CanvasPosition = Vector2.new(0, logScroll.AbsoluteCanvasSize.Y)
    end)
    print("[速启动] " .. prefix .. msg)
end

local function buildUrl(mirror, url)
    if mirror[2] == nil then
        return url:gsub("raw%.githubusercontent%.com", "raw.gitmirror.com")
    end
    return string.format(mirror[2], url)
end

local function raceDownload(url, prefix)
    if lastBestMirror and (os.clock() - lastBestTime <= CACHE_TIMEOUT) then
        log("⚡ 命中缓存: " .. lastBestMirror[1], "cache", prefix)
        local fullUrl = buildUrl(lastBestMirror, url)
        local t0 = os.clock()
        local ok, data = pcall(function() return game:HttpGet(fullUrl, true) end)
        
        if ok and data and #data >= MIN_SIZE then
            lastBestTime = os.clock()
            return { name = lastBestMirror[1].."(缓存)", data = data, elapsed = os.clock() - t0 }
        else
            log("✕ 缓存失效，重新测速...", "warn", prefix)
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
    if not winner then return nil, "节点未响应" end
    return winner
end

local function loadScript(index)
    -- 检查当前脚本是否已经在加载中
    if loadingStates[index] then
        log("该脚本正在加载，请等待...", "warn", NAMES[index])
        return
    end
    
    -- 上锁
    loadingStates[index] = true
    
    local targetBtn = btnRow:FindFirstChild(tostring(index)) 
    local origText = "🚀 " .. NAMES[index]
    
    -- 视觉反馈：变灰、显示加载中、禁止点击
    if targetBtn then 
        targetBtn.Active = false
        targetBtn.TextTransparency = 0.5 
        targetBtn.Text = "⏳ 加载中"
    end

    local prefix = NAMES[index]
    log("━━━ 开始加载 ━━━", "info", prefix)

    local winner, err = raceDownload(URLS[index], prefix)
    if not winner then
        log(err or "竞速失败", "error", prefix)
        loadingStates[index] = false -- 解锁
        if targetBtn then 
            targetBtn.Active = true
            targetBtn.TextTransparency = 0 
            targetBtn.Text = origText
        end
        return
    end

    log("编译执行中...", "info", prefix)
    local fn, compileErr = loadstring(winner.data)
    if not fn then
        log("编译失败: " .. tostring(compileErr), "error", prefix)
        loadingStates[index] = false -- 解锁
        if targetBtn then 
            targetBtn.Active = true
            targetBtn.TextTransparency = 0 
            targetBtn.Text = origText
        end
        return
    end

    local ok, execErr = pcall(fn)
    if not ok then
        log("执行出错: " .. tostring(execErr), "error", prefix)
    else
        log(string.format("🎉 加载成功！(%s, %.2fs)", winner.name, winner.elapsed), "success", prefix)
    end
    
    loadingStates[index] = false -- 解锁
    if targetBtn then 
        targetBtn.Active = true
        targetBtn.TextTransparency = 0 
        targetBtn.Text = origText
    end
end

local function makeBtn(text, color, order, onClick)
    local b = new("TextButton", {
        Size = UDim2.new(1/3, -4, 1, 0),
        BackgroundColor3 = color,
        Text = text, TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.GothamBold, TextSize = 12,
        AutoButtonColor = false, LayoutOrder = order,
        Name = tostring(order),
    }, btnRow)
    new("UICorner", { CornerRadius = UDim.new(0, 6) }, b)
    b.MouseButton1Click:Connect(onClick)
end

makeBtn("🚀 " .. NAMES[1], Color3.fromRGB(60,140,220), 1, function()
    task.spawn(loadScript, 1)
end)
makeBtn("🚀 " .. NAMES[2], Color3.fromRGB(60,180,120), 2, function()
    task.spawn(loadScript, 2)
end)
makeBtn("❌ 退出", Color3.fromRGB(190,70,70), 3, function()
    log("正在退出...", "warn")
    task.wait(0.3)
    if gui.Parent then gui:Destroy() end
end)

local dragging, dragStart, startPos = false, nil, nil
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = Vector2.new(input.Position.X, input.Position.Y)
        startPos = panel.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement
    and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local d = Vector2.new(input.Position.X, input.Position.Y) - dragStart
    panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                               startPos.Y.Scale, startPos.Y.Offset + d.Y)
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local minimized, savedSize = false, panel.Size
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        savedSize = panel.Size
        panel.Size = UDim2.new(0, 260, 0, 30)
        btnRow.Visible = false
        logFrame.Visible = false
        minBtn.Text = "□"
    else
        panel.Size = savedSize
        btnRow.Visible = true
        logFrame.Visible = true
        minBtn.Text = "—"
    end
end)

log("加载器已就绪（独立防冲突）", "success")