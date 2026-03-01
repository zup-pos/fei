-- Gui to Lua
-- Version: 7.7.1 (新增透视模式)

-- ==================== 实例创建 ====================
local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local up = Instance.new("TextButton")
local plus = Instance.new("TextButton")
local uiLabel = Instance.new("TextLabel")
local hide = Instance.new("TextButton")
local down = Instance.new("TextButton")
local mine = Instance.new("TextButton")
local speed = Instance.new("TextButton")
local onof = Instance.new("TextButton")

-- ==================== 属性设置 ====================
main.Name = "main"
main.Parent = game.CoreGui
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
Frame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
Frame.Size = UDim2.new(0, 190, 0, 56)
Frame.Active = true
Frame.Draggable = true

up.Name = "up"
up.Parent = Frame
up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
up.Position = UDim2.new(0, 0, 0, 0)
up.Size = UDim2.new(0, 44, 0, 28)
up.Font = Enum.Font.SourceSans
up.Text = "上升"
up.TextColor3 = Color3.fromRGB(0, 0, 0)
up.TextScaled = true
up.TextSize = 14.000

plus.Name = "plus"
plus.Parent = Frame
plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
plus.Position = UDim2.new(0, 44, 0, 0)
plus.Size = UDim2.new(0, 44, 0, 28)
plus.Font = Enum.Font.SourceSans
plus.Text = "加速"
plus.TextColor3 = Color3.fromRGB(0, 0, 0)
plus.TextScaled = true
plus.TextSize = 14.000

uiLabel.Name = "uiLabel"
uiLabel.Parent = Frame
uiLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
uiLabel.Position = UDim2.new(0, 88, 0, 0)
uiLabel.Size = UDim2.new(0, 44, 0, 28)
uiLabel.Font = Enum.Font.SourceSans
uiLabel.Text = "UI"
uiLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
uiLabel.TextScaled = true
uiLabel.TextSize = 14.000

hide.Name = "hide"
hide.Parent = Frame
hide.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
hide.Position = UDim2.new(0, 132, 0, 0)
hide.Size = UDim2.new(0, 58, 0, 28)
hide.Font = Enum.Font.SourceSans
hide.Text = "隐藏/设置"
hide.TextColor3 = Color3.fromRGB(0, 0, 0)
hide.TextScaled = true
hide.TextSize = 14.000

down.Name = "down"
down.Parent = Frame
down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
down.Position = UDim2.new(0, 0, 0, 28)
down.Size = UDim2.new(0, 44, 0, 28)
down.Font = Enum.Font.SourceSans
down.Text = "下降"
down.TextColor3 = Color3.fromRGB(0, 0, 0)
down.TextScaled = true
down.TextSize = 14.000

mine.Name = "mine"
mine.Parent = Frame
mine.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
mine.Position = UDim2.new(0, 44, 0, 28)
mine.Size = UDim2.new(0, 44, 0, 28)
mine.Font = Enum.Font.SourceSans
mine.Text = "减速"
mine.TextColor3 = Color3.fromRGB(0, 0, 0)
mine.TextScaled = true
mine.TextSize = 14.000

speed.Name = "speed"
speed.Parent = Frame
speed.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
speed.Position = UDim2.new(0, 88, 0, 28)
speed.Size = UDim2.new(0, 44, 0, 28)
speed.Font = Enum.Font.SourceSans
speed.Text = "1"
speed.TextColor3 = Color3.fromRGB(0, 0, 0)
speed.TextScaled = true
speed.TextSize = 14.000
speed.AutoButtonColor = false

onof.Name = "onof"
onof.Parent = Frame
onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
onof.Position = UDim2.new(0, 132, 0, 28)
onof.Size = UDim2.new(0, 58, 0, 28)
onof.Font = Enum.Font.SourceSans
onof.Text = "飞天(关闭)"
onof.TextColor3 = Color3.fromRGB(0, 0, 0)
onof.TextScaled = true
onof.TextSize = 14.000

-- ==================== 服务与玩家 ====================
local player = game:GetService("Players").LocalPlayer
if not player then return end

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local playerGui = player:WaitForChild("PlayerGui")

-- ==================== 全局变量 ====================
local speeds = 1
local moveStep = 2
local incStep = 1
local isFlying = false
local tpwalking = false
local notifs = {}
local spacing, startY = 5, 20
local readyQueue = {}
local popupTransparency = 0.65
local uiVisible = true
local volumeKeyEnabled = false
local volumeKeyConnection = nil
local customWidth = nil
local customHeight = nil
local miniWindow = nil
local longPressSpeed = 0.01
local moveMode = "角色上下"
local flyMode = "屏幕"

-- 模式切换（0=飞天, 1=移速, 2=穿墙, 3=透视）
local modeIndex = 0
local modeNames = { "fly", "speed", "noclip", "nightvision" }
local modeDisplayNames = { "飞天", "移速", "穿墙", "透视" }

local speedModeEnabled = false
local speedModeConnection = nil

-- 移速模式专用变量
local lockedSpeed = 16
local originalSpeed = 16

-- 死亡自动关闭（仅影响飞天/移速）
local autoDisableOnDeath = true

-- ==================== 穿墙相关变量 ====================
local noclipEnabled = false
local noclipMaintainConnection = nil
local originalCollisions = {}

-- ==================== 透视相关变量 ====================
local nightVisionEnabled = false
local nightVisionBrightness = 2.5
local originalLighting = {}
local nightVisionMaintainConnection = nil

-- 递归获取角色所有部件
local function getAllParts(character)
    local parts = {}
    local function scan(instance)
        if instance:IsA("BasePart") then
            table.insert(parts, instance)
        end
        for _, child in ipairs(instance:GetChildren()) do
            scan(child)
        end
    end
    scan(character)
    return parts
end

-- 保存原始碰撞状态
local function saveOriginalCollisions(character)
    local parts = getAllParts(character)
    for _, part in ipairs(parts) do
        originalCollisions[part] = {
            CanCollide = part.CanCollide,
            CollisionGroup = part.CollisionGroup
        }
    end
end

-- 恢复原始碰撞状态
local function restoreOriginalCollisions()
    for part, data in pairs(originalCollisions) do
        if part and part.Parent then
            part.CanCollide = data.CanCollide
            pcall(function()
                part.CollisionGroup = data.CollisionGroup
            end)
        end
    end
    originalCollisions = {}
end

-- 应用穿墙属性
local function applyNoclip()
    local character = player.Character
    if not character then return end
    local parts = getAllParts(character)
    for _, part in ipairs(parts) do
        part.CanCollide = false
        pcall(function()
            part.CollisionGroup = "Ghost"
        end)
    end
end

-- 开启穿墙
local function enableNoclip()
    if not player.Character then return end
    if next(originalCollisions) == nil then
        saveOriginalCollisions(player.Character)
    end
    applyNoclip()
    if noclipMaintainConnection then
        noclipMaintainConnection:Disconnect()
    end
    noclipMaintainConnection = RunService.Heartbeat:Connect(function()
        if noclipEnabled and player.Character then
            applyNoclip()
            -- 不倒翁逻辑：穿墙开启且飞天关闭时保持角色直立（不改变朝向）
            if not isFlying then
                local char = player.Character
                if char then
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if root then
                        -- 获取当前朝向（水平方向）
                        local look = root.CFrame.LookVector
                        local flatLook = Vector3.new(look.X, 0, look.Z)
                        if flatLook.Magnitude > 0.01 then
                            flatLook = flatLook.Unit
                        else
                            flatLook = Vector3.new(0, 0, 1) -- 默认朝前
                        end
                        -- 设置新CFrame：位置不变，面向水平方向，Y轴向上
                        root.CFrame = CFrame.lookAt(root.Position, root.Position + flatLook)
                    end
                end
            end
        end
    end)
    noclipEnabled = true
end

-- 关闭穿墙
local function disableNoclip()
    if noclipMaintainConnection then
        noclipMaintainConnection:Disconnect()
        noclipMaintainConnection = nil
    end
    restoreOriginalCollisions()
    noclipEnabled = false
end

-- ==================== 有效Humanoid状态 ====================
local VALID_HUMANOD_STATES = {
    Enum.HumanoidStateType.Running,
    Enum.HumanoidStateType.RunningNoPhysics,
    Enum.HumanoidStateType.Climbing,
    Enum.HumanoidStateType.StrafingNoPhysics,
    Enum.HumanoidStateType.Ragdoll,
    Enum.HumanoidStateType.GettingUp,
    Enum.HumanoidStateType.Jumping,
    Enum.HumanoidStateType.FallingDown,
    Enum.HumanoidStateType.Seated,
    Enum.HumanoidStateType.PlatformStanding,
    Enum.HumanoidStateType.Dead,
    Enum.HumanoidStateType.Physics,
    Enum.HumanoidStateType.Swimming,
    Enum.HumanoidStateType.Freefall,
    Enum.HumanoidStateType.Landed,
}

local MOVE_MODES = {
    "角色上下", "角色前后", "角色左右",
    "屏幕上下", "屏幕前后", "屏幕左右",
    "水平上下", "水平前后(屏幕)", "水平左右(屏幕)"
}

local FLY_MODES = { "屏幕", "悬空", "绝对锁高" }

-- ==================== 辅助函数 ====================
local function clamp(val, min, max)
    return math.max(min, math.min(max, val))
end

local function getScreenSize()
    if customWidth and customHeight then
        return Vector2.new(customWidth, customHeight)
    end
    local camera = workspace.CurrentCamera
    if camera and camera.ViewportSize then
        return camera.ViewportSize
    else
        return Vector2.new(1920, 1080)
    end
end

local function updateButtonText()
    if moveMode == "角色上下" or moveMode == "屏幕上下" or moveMode == "水平上下" then
        up.Text = "上升"
        down.Text = "下降"
    elseif moveMode == "角色前后" or moveMode == "屏幕前后" or moveMode == "水平前后(屏幕)" then
        up.Text = "前移"
        down.Text = "后移"
    elseif moveMode == "角色左右" or moveMode == "屏幕左右" or moveMode == "水平左右(屏幕)" then
        up.Text = "左移"
        down.Text = "右移"
    else
        up.Text = "上升"
        down.Text = "下降"
    end
end

-- 更新主按钮文字
local function updateMainButtonText()
    local modeName = modeDisplayNames[modeIndex + 1]
    local state = false
    if modeIndex == 0 then
        state = isFlying
    elseif modeIndex == 1 then
        state = speedModeEnabled
    elseif modeIndex == 2 then
        state = noclipEnabled
    elseif modeIndex == 3 then
        state = nightVisionEnabled
    end
    onof.Text = modeName .. (state and "(开启)" or "(关闭)")
end

-- 更新速度标签文字
local function updateSpeedButtonText()
    if modeIndex == 0 then
        speed.Text = tostring(speeds)
    elseif modeIndex == 1 then
        if speedModeEnabled then
            speed.Text = string.format("%.1f", lockedSpeed)
        else
            local char = player.Character
            if char then
                local hum = char:FindFirstChildWhichIsA("Humanoid")
                if hum then
                    speed.Text = string.format("%.1f", hum.WalkSpeed)
                else
                    speed.Text = "0.0"
                end
            else
                speed.Text = "0.0"
            end
        end
    elseif modeIndex == 2 then
        speed.Text = noclipEnabled and "开启" or "关闭"
    elseif modeIndex == 3 then
        speed.Text = string.format("%.2f", nightVisionBrightness)
    end
end

-- ==================== TP Walk ====================
local function stopTpwalking()
    tpwalking = false
end

local function startTpwalking()
    if tpwalking then return end
    tpwalking = true
    task.spawn(function()
        local hb = RunService.Heartbeat
        while tpwalking do
            hb:Wait()
            local chr = player.Character
            if chr then
                local hum = chr:FindFirstChildWhichIsA("Humanoid")
                if hum and hum.MoveDirection.Magnitude > 0 then
                    chr:TranslateBy(hum.MoveDirection * speeds)
                end
            end
        end
    end)
end

-- ==================== 飞天辅助函数 ====================
local function removeFly()
    if _G._flyData then
        pcall(function() _G._flyData.bg:Destroy() end)
        pcall(function() _G._flyData.bv:Destroy() end)
        _G._flyData = nil
    end
end

local function applyFly()
    local char = player.Character
    if not char then return false end
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if not hum then return false end

    char.Animate.Disabled = true
    for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
        track:AdjustSpeed(0)
    end

    for _, state in ipairs(VALID_HUMANOD_STATES) do
        pcall(function() hum:SetStateEnabled(state, false) end)
    end
    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Swimming); hum.PlatformStand = true end)

    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
    if not torso then return false end

    local startY = torso.Position.Y

    local bg = Instance.new("BodyGyro")
    bg.P = 9e4
    bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.CFrame = torso.CFrame
    bg.Parent = torso

    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(0, 0.1, 0)
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Parent = torso

    _G._flyData = { bg = bg, bv = bv, torso = torso, startY = startY }

    task.spawn(function()
        while isFlying and player.Character and hum and hum.Parent and hum.Health > 0 do
            RunService.Heartbeat:Wait()
            local camera = workspace.CurrentCamera
            if camera then
                local moveDir = hum.MoveDirection
                local maxspeed = 50 * speeds

                if flyMode == "屏幕" then
                    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                    bv.Velocity = (moveDir.Magnitude > 0) and (moveDir * maxspeed) or Vector3.new(0,0,0)
                    bg.CFrame = camera.CFrame
                elseif flyMode == "悬空" then
                    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                    moveDir = Vector3.new(moveDir.X, 0, moveDir.Z)
                    bv.Velocity = (moveDir.Magnitude > 0) and (moveDir.Unit * maxspeed) or Vector3.new(0,0,0)
                    bg.CFrame = camera.CFrame
                elseif flyMode == "绝对锁高" then
                    bv.MaxForce = Vector3.new(9e9, 0, 9e9)
                    moveDir = Vector3.new(moveDir.X, 0, moveDir.Z)
                    bv.Velocity = (moveDir.Magnitude > 0) and (moveDir.Unit * maxspeed) or Vector3.new(0,0,0)
                    bg.CFrame = camera.CFrame
                    local pos = torso.Position
                    torso.CFrame = CFrame.new(pos.X, startY, pos.Z) * (torso.CFrame - torso.Position)
                end
            end
        end
        removeFly()
    end)
    return true
end

-- ==================== 统一飞天关闭后重置角色 ====================
local function resetHumanoidAfterFly()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if not hum then return end

    for _, state in ipairs(VALID_HUMANOD_STATES) do
        pcall(function() hum:SetStateEnabled(state, true) end)
    end

    hum.PlatformStand = false
    hum.AutoRotate = true

    hum:ChangeState(Enum.HumanoidStateType.Freefall)
    hum:ChangeState(Enum.HumanoidStateType.Running)

    char.Animate.Disabled = false
end

-- ==================== 强制关闭移速（独立函数）====================
local function forceDisableSpeedMode()
    if speedModeEnabled then
        if speedModeConnection then
            speedModeConnection:Disconnect()
            speedModeConnection = nil
        end
        local char = player.Character
        if char then
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if hum then
                pcall(function() hum.WalkSpeed = originalSpeed end)
            end
        end
        lockedSpeed = originalSpeed
        speedModeEnabled = false
        task.wait()
    end
end

-- ==================== 强制关闭飞天（独立函数）====================
local function forceDisableFly()
    if isFlying then
        removeFly()
        resetHumanoidAfterFly()
        stopTpwalking()
        isFlying = false
        task.wait()
    end
end

-- ==================== 飞天开关 ====================
local function toggleFly(enable)
    if enable then
        forceDisableSpeedMode()
        if isFlying then return end
        isFlying = true
        updateMainButtonText()
        stopTpwalking()
        tanchuangxiaoxi("已开启飞天", "飞天")
        applyFly()
    else
        if not isFlying then return end
        isFlying = false
        updateMainButtonText()
        stopTpwalking()
        tanchuangxiaoxi("已关闭飞天", "飞天")
        removeFly()
        resetHumanoidAfterFly()
    end
    updateSpeedButtonText()
end

-- ==================== 移速模式 ====================
local function applySpeedMode(enable)
    if enable then
        forceDisableFly()

        local char = player.Character
        if char then
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if hum then
                originalSpeed = hum.WalkSpeed
            else
                originalSpeed = 16
            end
        else
            originalSpeed = 16
        end
        if originalSpeed <= 0 then originalSpeed = 16 end

        lockedSpeed = originalSpeed

        if speedModeConnection then
            speedModeConnection:Disconnect()
        end
        speedModeConnection = RunService.Heartbeat:Connect(function()
            if not speedModeEnabled then return end
            local char = player.Character
            if char then
                local hum = char:FindFirstChildWhichIsA("Humanoid")
                if hum then
                    pcall(function() hum.WalkSpeed = lockedSpeed end)
                end
            end
        end)

        speedModeEnabled = true
        tanchuangxiaoxi("已开启移速模式，当前速度: " .. string.format("%.1f", lockedSpeed), "移速模式")
    else
        if speedModeConnection then
            speedModeConnection:Disconnect()
            speedModeConnection = nil
        end
        local char = player.Character
        if char then
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if hum then
                pcall(function() hum.WalkSpeed = originalSpeed end)
            end
        end
        lockedSpeed = originalSpeed
        speedModeEnabled = false
        tanchuangxiaoxi("已关闭移速模式", "移速模式")
    end
    updateMainButtonText()
    updateSpeedButtonText()
end

-- ==================== 透视功能 ====================

-- 保存原始照明值
local function saveOriginalLighting()
    local Lighting = game:GetService("Lighting")
    originalLighting = {
        Brightness = Lighting.Brightness,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        ColorShift_Bottom = Lighting.ColorShift_Bottom,
        ColorShift_Top = Lighting.ColorShift_Top,
        FogEnd = Lighting.FogEnd,
        FogStart = Lighting.FogStart,
        GlobalShadows = Lighting.GlobalShadows,
    }
end

-- 恢复原始照明
local function restoreLighting()
    local Lighting = game:GetService("Lighting")
    for prop, val in pairs(originalLighting) do
        pcall(function() Lighting[prop] = val end)
    end
end

-- 应用透视效果
local function applyNightVision()
    local Lighting = game:GetService("Lighting")
    Lighting.Brightness = nightVisionBrightness
    Lighting.Ambient = Color3.new(1, 1, 1)
    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
    Lighting.ColorShift_Top = Color3.new(1, 1, 1)
    Lighting.FogEnd = 100000
    Lighting.FogStart = 0
    Lighting.GlobalShadows = false
end

-- 开启透视
local function enableNightVision()
    if nightVisionEnabled then return end
    saveOriginalLighting()
    applyNightVision()
    -- 启动维护循环
    if nightVisionMaintainConnection then
        nightVisionMaintainConnection:Disconnect()
    end
    nightVisionMaintainConnection = RunService.Heartbeat:Connect(function()
        if nightVisionEnabled then
            applyNightVision()
        end
    end)
    nightVisionEnabled = true
    tanchuangxiaoxi("已开启透视", "透视")
end

-- 关闭透视
local function disableNightVision()
    if not nightVisionEnabled then return end
    if nightVisionMaintainConnection then
        nightVisionMaintainConnection:Disconnect()
        nightVisionMaintainConnection = nil
    end
    restoreLighting()
    nightVisionEnabled = false
    tanchuangxiaoxi("已关闭透视", "透视")
end

-- 自定义亮度对话框（包含输入框和滑块，范围 0.01~100）
local function showBrightnessDialog()
    local screenSize = getScreenSize()
    local dialogWidth = math.min(400, screenSize.X * 0.6)
    local dialogHeight = 250

    local dialog = Instance.new("ScreenGui")
    dialog.Parent = playerGui
    dialog.IgnoreGuiInset = true
    dialog.ResetOnSpawn = false

    local bg = Instance.new("Frame")
    bg.Parent = dialog
    bg.Size = UDim2.new(0, dialogWidth, 0, dialogHeight)
    bg.Position = UDim2.new(0.5, -dialogWidth/2, 0.5, -dialogHeight/2)
    bg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    bg.BackgroundTransparency = 0.2
    bg.BorderSizePixel = 0
    bg.Active = true

    local corner = Instance.new("UICorner")
    corner.Parent = bg
    corner.CornerRadius = UDim.new(0, 8)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = bg
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "设置透视亮度"
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center

    -- 输入框
    local textBox = Instance.new("TextBox")
    textBox.Parent = bg
    textBox.Size = UDim2.new(0.6, 0, 0, 40)
    textBox.Position = UDim2.new(0.2, 0, 0, 50)
    textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    textBox.TextColor3 = Color3.new(1, 1, 1)
    textBox.PlaceholderText = "亮度 (0.01~100)"  -- 提示改为 100
    textBox.Text = string.format("%.2f", nightVisionBrightness)
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 14
    textBox.ClearTextOnFocus = false  -- 不自动清空

    local line = Instance.new("Frame")
    line.Parent = textBox
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 1, 0)
    line.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    line.BorderSizePixel = 0

    -- 滑块轨道
    local sliderBg = Instance.new("Frame")
    sliderBg.Parent = bg
    sliderBg.Size = UDim2.new(0.8, 0, 0, 4)
    sliderBg.Position = UDim2.new(0.1, 0, 0, 120)
    sliderBg.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 2)
    sliderCorner.Parent = sliderBg

    -- 滑块按钮
    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0, 20, 0, 20)
    local minBright = 0.01
    local maxBright = 100  -- 改为 100
    local percent = (nightVisionBrightness - minBright) / (maxBright - minBright)
    knob.Position = UDim2.new(percent, -10, 0, -8)
    knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    knob.Text = ""
    knob.Parent = sliderBg
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local dragging = false
    knob.MouseButton1Down:Connect(function()
        dragging = true
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local conn
    conn = RunService.RenderStepped:Connect(function()
        if dragging then
            local mousePos = UserInputService:GetMouseLocation()
            local absPos = sliderBg.AbsolutePosition
            local absSize = sliderBg.AbsoluteSize.X
            local relX = math.clamp(mousePos.X - absPos.X, 0, absSize)
            local percent = relX / absSize
            knob.Position = UDim2.new(percent, -10, 0, -8)
            local newBrightness = minBright + percent * (maxBright - minBright)
            newBrightness = math.floor(newBrightness * 100) / 100  -- 保留两位小数
            textBox.Text = string.format("%.2f", newBrightness)
        end
    end)

    textBox.FocusLost:Connect(function()
        local num = tonumber(textBox.Text)
        if num then
            num = math.clamp(num, minBright, maxBright)
            num = math.floor(num * 100) / 100
            textBox.Text = string.format("%.2f", num)
            local newPercent = (num - minBright) / (maxBright - minBright)
            knob.Position = UDim2.new(newPercent, -10, 0, -8)
        else
            textBox.Text = string.format("%.2f", nightVisionBrightness)
        end
    end)

    local buttonFrame = Instance.new("Frame")
    buttonFrame.Parent = bg
    buttonFrame.Size = UDim2.new(1, -20, 0, 40)
    buttonFrame.Position = UDim2.new(0, 10, 1, -50)
    buttonFrame.BackgroundTransparency = 1

    local cancelBtn = Instance.new("TextButton")
    cancelBtn.Parent = buttonFrame
    cancelBtn.Size = UDim2.new(0.4, -5, 1, 0)
    cancelBtn.Position = UDim2.new(0.1, 0, 0, 0)
    cancelBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    cancelBtn.Text = "取消"
    cancelBtn.TextColor3 = Color3.new(1, 1, 1)
    cancelBtn.Font = Enum.Font.GothamBold
    cancelBtn.TextSize = 14
    local cancelCorner = Instance.new("UICorner")
    cancelCorner.CornerRadius = UDim.new(0, 6)
    cancelCorner.Parent = cancelBtn

    local confirmBtn = Instance.new("TextButton")
    confirmBtn.Parent = buttonFrame
    confirmBtn.Size = UDim2.new(0.4, -5, 1, 0)
    confirmBtn.Position = UDim2.new(0.5, 5, 0, 0)
    confirmBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    confirmBtn.Text = "确认"
    confirmBtn.TextColor3 = Color3.new(1, 1, 1)
    confirmBtn.Font = Enum.Font.GothamBold
    confirmBtn.TextSize = 14
    local confirmCorner = Instance.new("UICorner")
    confirmCorner.CornerRadius = UDim.new(0, 6)
    confirmCorner.Parent = confirmBtn

    cancelBtn.MouseButton1Click:Connect(function()
        conn:Disconnect()
        dialog:Destroy()
    end)

    confirmBtn.MouseButton1Click:Connect(function()
        local num = tonumber(textBox.Text)
        if num then
            num = math.clamp(num, minBright, maxBright)
            num = math.floor(num * 100) / 100
            nightVisionBrightness = num
            if nightVisionEnabled then
                applyNightVision()
            end
            tanchuangxiaoxi("透视亮度已设为 " .. tostring(num), "亮度设置")
        end
        conn:Disconnect()
        dialog:Destroy()
    end)
end

-- ==================== 角色重生处理 ====================
local function onCharacterAdded(char)
    task.wait(0.7)
    char.Animate.Disabled = false

    if autoDisableOnDeath then
        if isFlying then
            isFlying = false
            updateMainButtonText()
            removeFly()
            resetHumanoidAfterFly()
        end
        if speedModeEnabled then
            speedModeEnabled = false
            if speedModeConnection then
                speedModeConnection:Disconnect()
                speedModeConnection = nil
            end
        end
    else
        if isFlying then
            task.spawn(function()
                task.wait(0.5)
                if isFlying and player.Character then
                    removeFly()
                    applyFly()
                end
            end)
        end
        if speedModeEnabled then
            applySpeedMode(true)
        end
    end

    if noclipEnabled then
        originalCollisions = {}
        enableNoclip()
    end

    if nightVisionEnabled then
        enableNightVision()
    end

    stopTpwalking()
    updateSpeedButtonText()
end

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then onCharacterAdded(player.Character) end

-- ==================== 紧凑弹窗系统 ====================
local function reposition()
    local y = startY
    for _, n in ipairs(notifs) do
        local f = n.frame
        TweenService:Create(f, TweenInfo.new(0.2), {Position = UDim2.new(1, -f.Size.X.Offset - 10, 0, y)}):Play()
        y = y + n.height + spacing
    end
end

local function remove(f)
    for i, n in ipairs(notifs) do
        if n.frame == f then
            table.remove(notifs, i)
            break
        end
    end
end

local function processReady()
    while #readyQueue > 0 do
        local n = table.remove(readyQueue, 1)
        if n and n.frame and n.frame.Parent then
            local f, sg = n.frame, n.sg
            local fadeOut = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            local t1 = TweenService:Create(f, fadeOut, {BackgroundTransparency = 1})
            TweenService:Create(n.title, fadeOut, {TextTransparency = 1}):Play()
            TweenService:Create(n.line, fadeOut, {BackgroundTransparency = 1}):Play()
            TweenService:Create(n.msg, fadeOut, {TextTransparency = 1}):Play()
            t1:Play()
            t1.Completed:Wait()
            remove(f)
            sg:Destroy()
        end
    end
    reposition()
end

function tanchuangxiaoxi(msg, title)
    title = title or "弹窗消息"
    msg = msg or "空消息"
    msg = tostring(msg)
    title = tostring(title)

    local padding = 2
    local lineHeight = 2
    local titleFont = Enum.Font.GothamBold
    local msgFont = Enum.Font.Gotham
    local titleSize = 14
    local msgSize = 12
    local bgTransparency = popupTransparency

    local titleSizeVec = TextService:GetTextSize(title, titleSize, titleFont, Vector2.new(1000, 1000))
    local msgSizeVec = TextService:GetTextSize(msg, msgSize, msgFont, Vector2.new(1000, 1000))
    local titleWidth = titleSizeVec.X
    local msgWidth = msgSizeVec.X
    local contentWidth = math.max(titleWidth, msgWidth)
    local frameWidth = contentWidth + 2 * padding
    local titleHeight = titleSizeVec.Y
    local msgHeight = msgSizeVec.Y
    local frameHeight = padding + titleHeight + lineHeight + msgHeight + padding

    local sg = Instance.new("ScreenGui")
    sg.Parent = playerGui
    sg.IgnoreGuiInset = true
    sg.ResetOnSpawn = false

    local f = Instance.new("Frame")
    f.Parent = sg
    f.Size = UDim2.new(0, frameWidth, 0, frameHeight)
    f.Position = UDim2.new(1, -frameWidth - 10, 0, -frameHeight)
    f.BackgroundColor3 = Color3.fromRGB(30,30,30)
    f.BackgroundTransparency = bgTransparency
    f.BorderSizePixel = 0
    f.ClipsDescendants = true

    local corner = Instance.new("UICorner")
    corner.Parent = f
    corner.CornerRadius = UDim.new(0, 6)

    local titleL = Instance.new("TextLabel")
    titleL.Parent = f
    titleL.Size = UDim2.new(0, contentWidth, 0, titleHeight)
    titleL.Position = UDim2.new(0, padding, 0, padding)
    titleL.BackgroundTransparency = 1
    titleL.Text = title
    titleL.TextColor3 = Color3.new(1, 1, 1)
    titleL.Font = titleFont
    titleL.TextSize = titleSize
    titleL.TextXAlignment = Enum.TextXAlignment.Center
    titleL.TextYAlignment = Enum.TextYAlignment.Center
    titleL.TextWrapped = false

    local line = Instance.new("Frame")
    line.Parent = f
    line.Size = UDim2.new(0, contentWidth, 0, lineHeight)
    line.Position = UDim2.new(0, padding, 0, padding + titleHeight)
    line.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    line.BackgroundTransparency = 0.3
    line.BorderSizePixel = 0

    local msgL = Instance.new("TextLabel")
    msgL.Parent = f
    msgL.Size = UDim2.new(0, contentWidth, 0, msgHeight)
    msgL.Position = UDim2.new(0, padding, 0, padding + titleHeight + lineHeight)
    msgL.BackgroundTransparency = 1
    msgL.Text = msg
    msgL.TextColor3 = Color3.fromRGB(220, 220, 220)
    msgL.Font = msgFont
    msgL.TextSize = msgSize
    msgL.TextXAlignment = Enum.TextXAlignment.Center
    msgL.TextYAlignment = Enum.TextYAlignment.Top
    msgL.TextWrapped = false

    local notif = { frame = f, sg = sg, title = titleL, line = line, msg = msgL, height = frameHeight }
    table.insert(notifs, 1, notif)
    reposition()

    task.delay(3, function()
        if notif.frame and notif.frame.Parent then
            table.insert(readyQueue, notif)
            processReady()
        end
    end)
end

-- ==================== 输入对话框 ====================
local function showInputDialog(title, defaultText, callback, extraButton)
    local screenSize = getScreenSize()
    local dialogWidth = math.min(400, screenSize.X * 0.6)
    local dialogHeight = 180

    local dialog = Instance.new("ScreenGui")
    dialog.Parent = playerGui
    dialog.IgnoreGuiInset = true
    dialog.ResetOnSpawn = false

    local bg = Instance.new("Frame")
    bg.Parent = dialog
    bg.Size = UDim2.new(0, dialogWidth, 0, dialogHeight)
    bg.Position = UDim2.new(0.5, -dialogWidth/2, 0.5, -dialogHeight/2)
    bg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    bg.BackgroundTransparency = 0.2
    bg.BorderSizePixel = 0
    bg.Active = true

    local corner = Instance.new("UICorner")
    corner.Parent = bg
    corner.CornerRadius = UDim.new(0, 8)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = bg
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center

    local textBox = Instance.new("TextBox")
    textBox.Parent = bg
    textBox.Size = UDim2.new(1, -40, 0, 40)
    textBox.Position = UDim2.new(0, 20, 0, 50)
    textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    textBox.TextColor3 = Color3.new(1, 1, 1)
    textBox.PlaceholderText = "请输入数字"
    textBox.Text = defaultText
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 14
    textBox.ClearTextOnFocus = false

    local line = Instance.new("Frame")
    line.Parent = textBox
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 1, 0)
    line.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    line.BorderSizePixel = 0

    local buttonFrame = Instance.new("Frame")
    buttonFrame.Parent = bg
    buttonFrame.Size = UDim2.new(1, -20, 0, 40)
    buttonFrame.Position = UDim2.new(0, 10, 1, -50)
    buttonFrame.BackgroundTransparency = 1

    local buttons = {}
    if extraButton then
        local btnWidth = (dialogWidth - 20 - 10) / 3

        local cancel = Instance.new("TextButton")
        cancel.Parent = buttonFrame
        cancel.Size = UDim2.new(0, btnWidth, 1, 0)
        cancel.Position = UDim2.new(0, 0, 0, 0)
        cancel.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        cancel.Text = "取消"
        cancel.TextColor3 = Color3.new(1, 1, 1)
        cancel.Font = Enum.Font.GothamBold
        cancel.TextSize = 14
        table.insert(buttons, cancel)

        local extra = Instance.new("TextButton")
        extra.Parent = buttonFrame
        extra.Size = UDim2.new(0, btnWidth, 1, 0)
        extra.Position = UDim2.new(0, btnWidth + 5, 0, 0)
        extra.BackgroundColor3 = Color3.fromRGB(80, 80, 200)
        extra.Text = extraButton.text
        extra.TextColor3 = Color3.new(1, 1, 1)
        extra.Font = Enum.Font.GothamBold
        extra.TextSize = 14
        extra.TextScaled = true
        table.insert(buttons, extra)

        local confirm = Instance.new("TextButton")
        confirm.Parent = buttonFrame
        confirm.Size = UDim2.new(0, btnWidth, 1, 0)
        confirm.Position = UDim2.new(0, 2*(btnWidth + 5), 0, 0)
        confirm.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        confirm.Text = "确认"
        confirm.TextColor3 = Color3.new(1, 1, 1)
        confirm.Font = Enum.Font.GothamBold
        confirm.TextSize = 14
        table.insert(buttons, confirm)

        extra.MouseButton1Click:Connect(function()
            extraButton.callback(extra)
        end)
    else
        local cancel = Instance.new("TextButton")
        cancel.Parent = buttonFrame
        cancel.Size = UDim2.new(0.5, -5, 1, 0)
        cancel.Position = UDim2.new(0, 0, 0, 0)
        cancel.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        cancel.Text = "取消"
        cancel.TextColor3 = Color3.new(1, 1, 1)
        cancel.Font = Enum.Font.GothamBold
        cancel.TextSize = 14
        table.insert(buttons, cancel)

        local confirm = Instance.new("TextButton")
        confirm.Parent = buttonFrame
        confirm.Size = UDim2.new(0.5, -5, 1, 0)
        confirm.Position = UDim2.new(0.5, 5, 0, 0)
        confirm.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        confirm.Text = "确认"
        confirm.TextColor3 = Color3.new(1, 1, 1)
        confirm.Font = Enum.Font.GothamBold
        confirm.TextSize = 14
        table.insert(buttons, confirm)
    end

    local function close()
        dialog:Destroy()
    end

    for _, btn in ipairs(buttons) do
        if btn.Text == "取消" then
            btn.MouseButton1Click:Connect(close)
        end
    end

    for _, btn in ipairs(buttons) do
        if btn.Text == "确认" then
            btn.MouseButton1Click:Connect(function()
                local input = textBox.Text
                local num = tonumber(input)
                if extraButton then
                    callback(input)
                    close()
                else
                    if num and num > 0 then
                        callback(num)
                        close()
                    else
                        tanchuangxiaoxi("请输入大于0的数字", "输入错误")
                    end
                end
            end)
        end
    end

    return dialog
end

-- ==================== 通用菜单创建函数 ====================
local function createMenu(title, buttons, parentMenu)
    local screenSize = getScreenSize()
    local menuWidth = math.min(350, screenSize.X * 0.8)
    local btnHeight = 40
    local spacing = 5
    local padding = 10
    local titleHeight = 40
    local closeBtnHeight = 40
    local contentHeight = #buttons * btnHeight + (#buttons - 1) * spacing
    
    local totalContentHeight = contentHeight
    local totalHeight = padding + titleHeight + totalContentHeight + padding + closeBtnHeight + padding
    
    local maxHeight = screenSize.Y * 0.8
    local needsScrolling = totalHeight > maxHeight
    
    if needsScrolling then
        totalHeight = maxHeight
        local scrollableHeight = totalHeight - padding - titleHeight - padding - closeBtnHeight - padding
        contentHeight = math.min(contentHeight, scrollableHeight)
    end

    local dialog = Instance.new("ScreenGui")
    dialog.Parent = playerGui
    dialog.IgnoreGuiInset = true
    dialog.ResetOnSpawn = false

    local bg = Instance.new("Frame")
    bg.Parent = dialog
    bg.Size = UDim2.new(0, menuWidth, 0, totalHeight)
    bg.Position = UDim2.new(0.5, -menuWidth/2, 0.5, -totalHeight/2)
    bg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    bg.BackgroundTransparency = 0.2
    bg.BorderSizePixel = 0
    bg.Active = true
    bg.ClipsDescendants = true

    local corner = Instance.new("UICorner")
    corner.Parent = bg
    corner.CornerRadius = UDim.new(0, 8)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = bg
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center

    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Parent = bg
    scrollingFrame.Size = UDim2.new(1, -20, 0, contentHeight)
    scrollingFrame.Position = UDim2.new(0, 10, 0, 40)
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalContentHeight)
    scrollingFrame.ScrollBarThickness = 8
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollingEnabled = needsScrolling
    scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 150)

    local buttonContainer = Instance.new("Frame")
    buttonContainer.Parent = scrollingFrame
    buttonContainer.Size = UDim2.new(1, 0, 0, totalContentHeight)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Position = UDim2.new(0, 0, 0, 0)

    local yPos = 0
    for _, btn in ipairs(buttons) do
        local button = Instance.new("TextButton")
        button.Parent = buttonContainer
        button.Size = UDim2.new(1, -10, 0, btnHeight)
        button.Position = UDim2.new(0, 0, 0, yPos)
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        button.Text = btn.text
        button.TextColor3 = Color3.new(1, 1, 1)
        button.Font = Enum.Font.Gotham
        button.TextSize = 14
        button.TextWrapped = true
        button.AutoButtonColor = true

        local btnCorner = Instance.new("UICorner")
        btnCorner.Parent = button
        btnCorner.CornerRadius = UDim.new(0, 4)

        button.MouseButton1Click:Connect(function()
            if btn.callback then
                btn.callback(dialog)
            end
        end)

        yPos = yPos + btnHeight + spacing
    end

    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = bg
    closeBtn.Size = UDim2.new(1, -20, 0, 35)
    closeBtn.Position = UDim2.new(0, 10, 1, -45)
    closeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    closeBtn.Text = parentMenu and "返回上级" or "关闭"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.TextSize = 14
    closeBtn.AutoButtonColor = true

    local closeCorner = Instance.new("UICorner")
    closeCorner.Parent = closeBtn
    closeCorner.CornerRadius = UDim.new(0, 4)

    closeBtn.MouseButton1Click:Connect(function()
        dialog:Destroy()
        if parentMenu then
            parentMenu()
        end
    end)

    return dialog
end

-- ==================== 音量键隐藏功能 ====================
local function setUIVisible(visible)
    uiVisible = visible
    Frame.Visible = uiVisible
    if miniWindow then
        miniWindow.Visible = uiVisible
    end
    tanchuangxiaoxi(uiVisible and "UI已显示" or "UI已隐藏", "音量键")
end

local function enableVolumeKey()
    local hasVolumeDown = pcall(function() return Enum.KeyCode.VolumeDown end)
    local hasVolumeUp = pcall(function() return Enum.KeyCode.VolumeUp end)
    if not hasVolumeDown or not hasVolumeUp then
        tanchuangxiaoxi("您的设备不支持音量键控制", "提示")
        return
    end

    if volumeKeyEnabled then return end
    volumeKeyConnection = UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.VolumeDown then
            setUIVisible(false)
        elseif input.KeyCode == Enum.KeyCode.VolumeUp then
            setUIVisible(true)
        end
    end)
    volumeKeyEnabled = true
    tanchuangxiaoxi("音量键控制已启用：减隐藏，加显示", "设置")
end

local function disableVolumeKey()
    if not volumeKeyEnabled then return end
    if volumeKeyConnection then
        volumeKeyConnection:Disconnect()
        volumeKeyConnection = nil
    end
    volumeKeyEnabled = false
    tanchuangxiaoxi("音量键控制已禁用", "设置")
end

-- ==================== 快捷模式选择菜单 ====================
local function showFlyModeSelection(currentMode, callback)
    local buttons = {}
    for _, mode in ipairs(FLY_MODES) do
        table.insert(buttons, { text = mode .. (mode == currentMode and " ✓" or ""), callback = function(menu) menu:Destroy(); callback(mode) end })
    end
    createMenu("选择飞行模式", buttons, nil)
end

local function showMoveModeSelection(currentMode, callback)
    local buttons = {}
    for _, mode in ipairs(MOVE_MODES) do
        table.insert(buttons, { text = mode .. (mode == currentMode and " ✓" or ""), callback = function(menu) menu:Destroy(); callback(mode) end })
    end
    createMenu("选择移动模式", buttons, nil)
end

-- ==================== 主菜单显示函数 ====================
local function showMainMenu()
    createMenu("UI菜单", {
        {
            text = "📢 查看公告",
            callback = function(menu)
                menu:Destroy()
                local screenSize = getScreenSize()
                local dialogWidth = math.min(450, screenSize.X * 0.8)
                local dialogHeight = math.min(500, screenSize.Y * 0.8)

                local dialog = Instance.new("ScreenGui")
                dialog.Parent = playerGui
                dialog.IgnoreGuiInset = true
                dialog.ResetOnSpawn = false

                local bg = Instance.new("Frame")
                bg.Parent = dialog
                bg.Size = UDim2.new(0, dialogWidth, 0, dialogHeight)
                bg.Position = UDim2.new(0.5, -dialogWidth/2, 0.5, -dialogHeight/2)
                bg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                bg.BackgroundTransparency = 0.2
                bg.BorderSizePixel = 0
                bg.Active = true
                bg.ClipsDescendants = true

                local corner = Instance.new("UICorner")
                corner.Parent = bg
                corner.CornerRadius = UDim.new(0, 8)

                local titleLabel = Instance.new("TextLabel")
                titleLabel.Parent = bg
                titleLabel.Size = UDim2.new(1, -20, 0, 40)
                titleLabel.Position = UDim2.new(0, 10, 0, 10)
                titleLabel.BackgroundTransparency = 1
                titleLabel.Text = "更新日志"
                titleLabel.TextColor3 = Color3.new(1, 1, 1)
                titleLabel.Font = Enum.Font.GothamBold
                titleLabel.TextSize = 20
                titleLabel.TextXAlignment = Enum.TextXAlignment.Center

                local scrollingFrame = Instance.new("ScrollingFrame")
                scrollingFrame.Parent = bg
                scrollingFrame.Size = UDim2.new(1, -20, 0, dialogHeight - 100)
                scrollingFrame.Position = UDim2.new(0, 10, 0, 60)
                scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
                scrollingFrame.ScrollBarThickness = 8
                scrollingFrame.BackgroundTransparency = 1
                scrollingFrame.BorderSizePixel = 0
                scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 150)

                local lines = {
                    "版本 7.7.1 更新内容：",
                    "",
                    "1. 修复移速模式关闭时速度不刷新的问题",
                    "2. 现在移速模式关闭时会实时显示实际速度",
                    "3. 加速/减速按钮在移速模式关闭时仍然调整锁定速度",
                    "4. 优化界面显示",
                    "5. 新增独立穿墙功能（长按主按钮切换）",
                    "6. 新增透视模式（长按主按钮第4次）",
                    "",
                    "功能介绍：",
                    "- 上升/下降（或前移/后移/左移/右移）：单击移动，长按连续",
                    "- 加速/减速：单击调速度，长按连续",
                    "- 速度标签：单击可手动设置当前值（飞天倍率/移速锁定/透视亮度），长按可设置上升/下降步长",
                    "- 主按钮：长按切换飞天/移速/穿墙/透视模式，单击开关当前模式",
                    "- 隐藏按钮：单击折叠UI，长按打开菜单",
                    "- 音量键控制：可在设置中开启/关闭",
                    "- 死亡自动关闭：可控制角色死后是否自动停用当前模式（仅影响飞天/移速）",
                    "- 穿墙：独立开关，不受死亡自动关闭影响，重生后自动恢复",
                    "- 透视：独立开关，可调节亮度（1~5），重生后自动恢复",
                    "",
                    "自定义屏幕尺寸：",
                    "如自动检测不准确，可手动设置屏幕宽高",
                    "",
                    "感谢使用！"
                }

                local contentContainer = Instance.new("Frame")
                contentContainer.Parent = scrollingFrame
                contentContainer.Size = UDim2.new(1, -10, 0, 0)
                contentContainer.BackgroundTransparency = 1
                contentContainer.Position = UDim2.new(0, 0, 0, 0)

                local yPos = 0
                local lineHeight = 20
                local lineSpacing = 2

                for _, lineText in ipairs(lines) do
                    local lineLabel = Instance.new("TextLabel")
                    lineLabel.Parent = contentContainer
                    lineLabel.Size = UDim2.new(1, 0, 0, lineHeight)
                    lineLabel.Position = UDim2.new(0, 0, 0, yPos)
                    lineLabel.BackgroundTransparency = 1
                    lineLabel.Text = lineText
                    lineLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                    lineLabel.Font = Enum.Font.Gotham
                    lineLabel.TextSize = 14
                    lineLabel.TextXAlignment = Enum.TextXAlignment.Left
                    lineLabel.TextYAlignment = Enum.TextYAlignment.Top
                    lineLabel.TextWrapped = false
                    
                    yPos = yPos + lineHeight + lineSpacing
                end

                contentContainer.Size = UDim2.new(1, -10, 0, yPos - lineSpacing)
                scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, contentContainer.Size.Y.Offset + 10)

                local backBtn = Instance.new("TextButton")
                backBtn.Parent = bg
                backBtn.Size = UDim2.new(1, -40, 0, 40)
                backBtn.Position = UDim2.new(0, 20, 1, -50)
                backBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                backBtn.Text = "返回"
                backBtn.TextColor3 = Color3.new(1, 1, 1)
                backBtn.Font = Enum.Font.GothamBold
                backBtn.TextSize = 16
                backBtn.AutoButtonColor = true

                local backCorner = Instance.new("UICorner")
                backCorner.Parent = backBtn
                backCorner.CornerRadius = UDim.new(0, 8)

                backBtn.MouseButton1Click:Connect(function()
                    dialog:Destroy()
                    showMainMenu()
                end)
            end
        },
        {
            text = "📖 功能介绍",
            callback = function(menu)
                menu:Destroy()
                local screenSize = getScreenSize()
                local dialogWidth = math.min(400, screenSize.X * 0.8)
                local dialogHeight = math.min(450, screenSize.Y * 0.8)

                local dialog = Instance.new("ScreenGui")
                dialog.Parent = playerGui
                dialog.IgnoreGuiInset = true
                dialog.ResetOnSpawn = false

                local bg = Instance.new("Frame")
                bg.Parent = dialog
                bg.Size = UDim2.new(0, dialogWidth, 0, dialogHeight)
                bg.Position = UDim2.new(0.5, -dialogWidth/2, 0.5, -dialogHeight/2)
                bg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                bg.BackgroundTransparency = 0.2
                bg.BorderSizePixel = 0
                bg.Active = true
                bg.ClipsDescendants = true

                local corner = Instance.new("UICorner")
                corner.Parent = bg
                corner.CornerRadius = UDim.new(0, 8)

                local titleLabel = Instance.new("TextLabel")
                titleLabel.Parent = bg
                titleLabel.Size = UDim2.new(1, -20, 0, 40)
                titleLabel.Position = UDim2.new(0, 10, 0, 10)
                titleLabel.BackgroundTransparency = 1
                titleLabel.Text = "功能介绍"
                titleLabel.TextColor3 = Color3.new(1, 1, 1)
                titleLabel.Font = Enum.Font.GothamBold
                titleLabel.TextSize = 20
                titleLabel.TextXAlignment = Enum.TextXAlignment.Center

                local scrollingFrame = Instance.new("ScrollingFrame")
                scrollingFrame.Parent = bg
                scrollingFrame.Size = UDim2.new(1, -20, 0, dialogHeight - 100)
                scrollingFrame.Position = UDim2.new(0, 10, 0, 60)
                scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
                scrollingFrame.ScrollBarThickness = 8
                scrollingFrame.BackgroundTransparency = 1
                scrollingFrame.BorderSizePixel = 0
                scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 150)

                local lines = {
                    "🔹 上升/下降（或前移/后移/左移/右移）：单击移动，长按连续",
                    "   可切换多种方向模式（共9种）：",
                    "   - 角色上下：沿角色自身向上方向",
                    "   - 角色前后：基于角色朝向的前后",
                    "   - 角色左右：基于角色朝向的左右",
                    "   - 屏幕上下：基于相机上下方向",
                    "   - 屏幕前后：基于相机前后方向",
                    "   - 屏幕左右：基于相机左右方向",
                    "   - 水平上下：世界Y轴（纯垂直）",
                    "   - 水平前后(屏幕)：基于相机前方的水平方向",
                    "   - 水平左右(屏幕)：基于相机右方的水平方向",
                    "🔹 加速/减速：单击调速度，长按连续",
                    "   - 飞天模式：调整倍率，每次增减 incStep（可在设置中调整）",
                    "   - 移速模式：调整锁定速度，每次增减 incStep",
                    "🔹 速度标签：",
                    "   - 飞天/移速/透视模式下单击可手动设置当前值（倍率/锁定速度/亮度）",
                    "   - 长按：设置上升/下降的移动步长，并可切换移动模式",
                    "🔹 主按钮：长按切换飞天/移速/穿墙/透视模式，单击开关当前模式",
                    "🔹 隐藏按钮：单击折叠UI，长按打开菜单",
                    "🔹 死亡自动关闭：可控制角色死后是否自动停用当前模式（仅影响飞天/移速）",
                    "🔹 穿墙：独立开关，不受死亡自动关闭影响，重生后自动恢复",
                    "🔹 透视：独立开关，可调节亮度（1~5），重生后自动恢复",
                    "",
                    "⚙️ 菜单功能：",
                    "- 查看公告：显示更新日志",
                    "- 功能介绍：本页面",
                    "- 设置：调整弹窗透明度、",
                    "  启用音量键隐藏、",
                    "  设置屏幕尺寸、",
                    "  调整增长量（加速/减速步长）、",
                    "  上升/下降模式、",
                    "  飞行方向模式、",
                    "  死亡自动关闭",
                    "- 结束脚本：彻底停止",
                    "",
                    "音量键隐藏：",
                    "启用后，按音量减隐藏UI，音量加显示"
                }

                local contentContainer = Instance.new("Frame")
                contentContainer.Parent = scrollingFrame
                contentContainer.Size = UDim2.new(1, -10, 0, 0)
                contentContainer.BackgroundTransparency = 1
                contentContainer.Position = UDim2.new(0, 0, 0, 0)

                local yPos = 0
                local lineHeight = 20
                local lineSpacing = 2

                for _, lineText in ipairs(lines) do
                    local lineLabel = Instance.new("TextLabel")
                    lineLabel.Parent = contentContainer
                    lineLabel.Size = UDim2.new(1, 0, 0, lineHeight)
                    lineLabel.Position = UDim2.new(0, 0, 0, yPos)
                    lineLabel.BackgroundTransparency = 1
                    lineLabel.Text = lineText
                    lineLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                    lineLabel.Font = Enum.Font.Gotham
                    lineLabel.TextSize = 14
                    lineLabel.TextXAlignment = Enum.TextXAlignment.Left
                    lineLabel.TextYAlignment = Enum.TextYAlignment.Top
                    lineLabel.TextWrapped = false
                    
                    yPos = yPos + lineHeight + lineSpacing
                end

                contentContainer.Size = UDim2.new(1, -10, 0, yPos - lineSpacing)
                scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, contentContainer.Size.Y.Offset + 10)

                local backBtn = Instance.new("TextButton")
                backBtn.Parent = bg
                backBtn.Size = UDim2.new(1, -40, 0, 40)
                backBtn.Position = UDim2.new(0, 20, 1, -50)
                backBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                backBtn.Text = "返回"
                backBtn.TextColor3 = Color3.new(1, 1, 1)
                backBtn.Font = Enum.Font.GothamBold
                backBtn.TextSize = 16
                backBtn.AutoButtonColor = true

                local backCorner = Instance.new("UICorner")
                backCorner.Parent = backBtn
                backCorner.CornerRadius = UDim.new(0, 8)

                backBtn.MouseButton1Click:Connect(function()
                    dialog:Destroy()
                    showMainMenu()
                end)
            end
        },
        {
            text = "⚙️ 设置",
            callback = function(menu)
                menu:Destroy()
                local function createSettingMenu()
                    createMenu("设置", {
                        {
                            text = "🔆 调整弹窗透明度",
                            callback = function(subMenu)
                                showInputDialog("输入透明度 (0-1)", tostring(popupTransparency), function(val)
                                    if val >= 0 and val <= 1 then
                                        popupTransparency = val
                                        tanchuangxiaoxi("弹窗透明度已设为 " .. val, "设置")
                                    else
                                        tanchuangxiaoxi("请输入0到1之间的数字", "错误")
                                    end
                                end)
                            end
                        },
                        {
                            text = volumeKeyEnabled and "🔊 音量键隐藏: 开启" or "🔊 音量键隐藏: 关闭",
                            callback = function(subMenu)
                                if volumeKeyEnabled then
                                    disableVolumeKey()
                                else
                                    enableVolumeKey()
                                end
                                subMenu:Destroy()
                                createSettingMenu()
                            end
                        },
                        {
                            text = "⚡ 长按速度",
                            callback = function(subMenu)
                                showInputDialog("输入长按初始间隔 (秒，大于0)", tostring(longPressSpeed), function(val)
                                    if val and val > 0 then
                                        longPressSpeed = val
                                        tanchuangxiaoxi("长按速度已设为 " .. val .. " 秒", "设置")
                                    else
                                        tanchuangxiaoxi("请输入大于0的数字", "错误")
                                    end
                                end)
                            end
                        },
                        {
                            text = "📈 调整增长量 (当前: " .. incStep .. ")",
                            callback = function(subMenu)
                                showInputDialog("输入增长量（加速/减速步长）", tostring(incStep), function(val)
                                    if val and val > 0 then
                                        incStep = val
                                        tanchuangxiaoxi("增长量已设为 " .. val, "设置")
                                        subMenu:Destroy()
                                        createSettingMenu()
                                    else
                                        tanchuangxiaoxi("请输入大于0的数字", "错误")
                                    end
                                end)
                            end
                        },
                        {
                            text = "⬆️ 上升/下降模式: " .. moveMode,
                            callback = function(parentMenu)
                                createMenu("选择移动模式", {
                                    {
                                        text = "角色上下" .. (moveMode == "角色上下" and " ✓" or ""),
                                        callback = function(choiceMenu)
                                            moveMode = "角色上下"
                                            updateButtonText()
                                            tanchuangxiaoxi("上升/下降模式已切换至: 角色上下", "模式切换")
                                            choiceMenu:Destroy()
                                            parentMenu:Destroy()
                                            createSettingMenu()
                                        end
                                    },
                                    {
                                        text = "角色前后" .. (moveMode == "角色前后" and " ✓" or ""),
                                        callback = function(choiceMenu)
                                            moveMode = "角色前后"
                                            updateButtonText()
                                            tanchuangxiaoxi("上升/下降模式已切换至: 角色前后", "模式切换")
                                            choiceMenu:Destroy()
                                            parentMenu:Destroy()
                                            createSettingMenu()
                                        end
                                    },
                                    {
                                        text = "角色左右" .. (moveMode == "角色左右" and " ✓" or ""),
                                        callback = function(choiceMenu)
                                            moveMode = "角色左右"
                                            updateButtonText()
                                            tanchuangxiaoxi("上升/下降模式已切换至: 角色左右", "模式切换")
                                            choiceMenu:Destroy()
                                            parentMenu:Destroy()
                                            createSettingMenu()
                                        end
                                    },
                                    {
                                        text = "屏幕上下" .. (moveMode == "屏幕上下" and " ✓" or ""),
                                        callback = function(choiceMenu)
                                            moveMode = "屏幕上下"
                                            updateButtonText()
                                            tanchuangxiaoxi("上升/下降模式已切换至: 屏幕上下", "模式切换")
                                            choiceMenu:Destroy()
                                            parentMenu:Destroy()
                                            createSettingMenu()
                                        end
                                    },
                                    {
                                        text = "屏幕前后" .. (moveMode == "屏幕前后" and " ✓" or ""),
                                        callback = function(choiceMenu)
                                            moveMode = "屏幕前后"
                                            updateButtonText()
                                            tanchuangxiaoxi("上升/下降模式已切换至: 屏幕前后", "模式切换")
                                            choiceMenu:Destroy()
                                            parentMenu:Destroy()
                                            createSettingMenu()
                                        end
                                    },
                                    {
                                        text = "屏幕左右" .. (moveMode == "屏幕左右" and " ✓" or ""),
                                        callback = function(choiceMenu)
                                            moveMode = "屏幕左右"
                                            updateButtonText()
                                            tanchuangxiaoxi("上升/下降模式已切换至: 屏幕左右", "模式切换")
                                            choiceMenu:Destroy()
                                            parentMenu:Destroy()
                                            createSettingMenu()
                                        end
                                    },
                                    {
                                        text = "水平上下" .. (moveMode == "水平上下" and " ✓" or ""),
                                        callback = function(choiceMenu)
                                            moveMode = "水平上下"
                                            updateButtonText()
                                            tanchuangxiaoxi("上升/下降模式已切换至: 水平上下", "模式切换")
                                            choiceMenu:Destroy()
                                            parentMenu:Destroy()
                                            createSettingMenu()
                                        end
                                    },
                                    {
                                        text = "水平前后(屏幕)" .. (moveMode == "水平前后(屏幕)" and " ✓" or ""),
                                        callback = function(choiceMenu)
                                            moveMode = "水平前后(屏幕)"
                                            updateButtonText()
                                            tanchuangxiaoxi("上升/下降模式已切换至: 水平前后(屏幕)", "模式切换")
                                            choiceMenu:Destroy()
                                            parentMenu:Destroy()
                                            createSettingMenu()
                                        end
                                    },
                                    {
                                        text = "水平左右(屏幕)" .. (moveMode == "水平左右(屏幕)" and " ✓" or ""),
                                        callback = function(choiceMenu)
                                            moveMode = "水平左右(屏幕)"
                                            updateButtonText()
                                            tanchuangxiaoxi("上升/下降模式已切换至: 水平左右(屏幕)", "模式切换")
                                            choiceMenu:Destroy()
                                            parentMenu:Destroy()
                                            createSettingMenu()
                                        end
                                    },
                                }, nil)
                            end
                        },
                        {
                            text = "✈️ 飞行方向模式: " .. flyMode,
                            callback = function(parentMenu)
                                createMenu("选择飞行模式", {
                                    {
                                        text = "屏幕" .. (flyMode == "屏幕" and " ✓" or ""),
                                        callback = function(choiceMenu)
                                            flyMode = "屏幕"
                                            tanchuangxiaoxi("飞行方向模式已切换至: 屏幕", "模式切换")
                                            choiceMenu:Destroy()
                                            parentMenu:Destroy()
                                            createSettingMenu()
                                        end
                                    },
                                    {
                                        text = "悬空" .. (flyMode == "悬空" and " ✓" or ""),
                                        callback = function(choiceMenu)
                                            flyMode = "悬空"
                                            tanchuangxiaoxi("飞行方向模式已切换至: 悬空", "模式切换")
                                            choiceMenu:Destroy()
                                            parentMenu:Destroy()
                                            createSettingMenu()
                                        end
                                    },
                                    {
                                        text = "绝对锁高" .. (flyMode == "绝对锁高" and " ✓" or ""),
                                        callback = function(choiceMenu)
                                            flyMode = "绝对锁高"
                                            tanchuangxiaoxi("飞行方向模式已切换至: 绝对锁高", "模式切换")
                                            choiceMenu:Destroy()
                                            parentMenu:Destroy()
                                            createSettingMenu()
                                        end
                                    },
                                }, nil)
                            end
                        },
                        {
                            text = "📏 设置屏幕宽度",
                            callback = function(subMenu)
                                showInputDialog("输入屏幕宽度（像素）", tostring(customWidth or getScreenSize().X), function(val)
                                    if val and val > 0 then
                                        customWidth = val
                                        tanchuangxiaoxi("屏幕宽度已设为 " .. val, "自定义尺寸")
                                    else
                                        tanchuangxiaoxi("请输入大于0的数字", "错误")
                                    end
                                end)
                            end
                        },
                        {
                            text = "📏 设置屏幕高度",
                            callback = function(subMenu)
                                showInputDialog("输入屏幕高度（像素）", tostring(customHeight or getScreenSize().Y), function(val)
                                    if val and val > 0 then
                                        customHeight = val
                                        tanchuangxiaoxi("屏幕高度已设为 " .. val, "自定义尺寸")
                                    else
                                        tanchuangxiaoxi("请输入大于0的数字", "错误")
                                    end
                                end)
                            end
                        },
                        {
                            text = "🔄 重置为自动检测",
                            callback = function(subMenu)
                                customWidth = nil
                                customHeight = nil
                                tanchuangxiaoxi("已恢复自动检测屏幕尺寸", "自定义尺寸")
                            end
                        },
                        {
                            text = autoDisableOnDeath and "☠️ 死亡自动关闭: 开启" or "☠️ 死亡自动关闭: 关闭",
                            callback = function(parentMenu)
                                autoDisableOnDeath = not autoDisableOnDeath
                                tanchuangxiaoxi(autoDisableOnDeath and "死亡后自动关闭已开启" or "死亡后自动关闭已关闭", "设置")
                                parentMenu:Destroy()
                                createSettingMenu()
                            end
                        },
                    }, showMainMenu)
                end
                createSettingMenu()
            end
        },
        {
            text = "❌ 结束脚本",
            callback = function(menu)
                menu:Destroy()
                createMenu("确认结束？", {
                    {
                        text = "确认",
                        callback = function(confirmMenu)
                            confirmMenu:Destroy()
                            isFlying = false
                            tpwalking = false
                            speedModeEnabled = false
                            if speedModeConnection then
                                speedModeConnection:Disconnect()
                                speedModeConnection = nil
                            end
                            removeFly()
                            disableNoclip()
                            disableNightVision()
                            if main and main.Parent then
                                main:Destroy()
                            end
                            if miniWindow and miniWindow.Parent then
                                miniWindow:Destroy()
                                miniWindow = nil
                            end
                            for _, notif in ipairs(notifs) do
                                if notif.sg and notif.sg.Parent then
                                    notif.sg:Destroy()
                                end
                            end
                            notifs = {}
                            readyQueue = {}
                        end
                    },
                    {
                        text = "取消",
                        callback = function(confirmMenu)
                            confirmMenu:Destroy()
                        end
                    }
                }, nil)
            end
        }
    }, nil)
end

-- ==================== 辅助函数：根据当前模式获取移动向量 ====================
local function getMoveVector(dir, rootPart)
    local step = dir * moveStep
    if moveMode == "角色上下" then
        return rootPart.CFrame.UpVector * step
    elseif moveMode == "角色前后" then
        return rootPart.CFrame.LookVector * step
    elseif moveMode == "角色左右" then
        return -rootPart.CFrame.RightVector * step
    elseif moveMode == "屏幕上下" then
        local camera = workspace.CurrentCamera
        if camera then
            return camera.CFrame.UpVector * step
        end
    elseif moveMode == "屏幕前后" then
        local camera = workspace.CurrentCamera
        if camera then
            return camera.CFrame.LookVector * step
        end
    elseif moveMode == "屏幕左右" then
        local camera = workspace.CurrentCamera
        if camera then
            return -camera.CFrame.RightVector * step
        end
    elseif moveMode == "水平上下" then
        return Vector3.new(0, step, 0)
    elseif moveMode == "水平前后(屏幕)" then
        local camera = workspace.CurrentCamera
        if camera then
            local look = camera.CFrame.LookVector
            local horizontal = Vector3.new(look.X, 0, look.Z)
            if horizontal.Magnitude > 0 then
                return horizontal.Unit * step
            else
                return Vector3.new(0, 0, 0)
            end
        end
    elseif moveMode == "水平左右(屏幕)" then
        local camera = workspace.CurrentCamera
        if camera then
            local right = camera.CFrame.RightVector
            local horizontal = Vector3.new(right.X, 0, right.Z)
            if horizontal.Magnitude > 0 then
                return horizontal.Unit * step
            else
                return Vector3.new(0, 0, 0)
            end
        end
    end
    return Vector3.new()
end

-- ==================== 按钮长按逻辑 ====================
-- 上升按钮
do
    local holding = false
    local longPressTask = nil

    local function startLongPress()
        if not holding then return end
        local interval = longPressSpeed
        while holding do
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local rootPart = char.HumanoidRootPart
                local delta = getMoveVector(1, rootPart)
                rootPart.CFrame = rootPart.CFrame + delta
            end
            task.wait(interval)
            interval = math.max(0.001, interval * 0.9)
        end
    end

    up.MouseButton1Down:Connect(function()
        if holding then return end
        holding = true
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local rootPart = char.HumanoidRootPart
            local delta = getMoveVector(1, rootPart)
            rootPart.CFrame = rootPart.CFrame + delta
        end
        longPressTask = task.delay(0.3, function()
            if holding then
                startLongPress()
            end
        end)
    end)

    local function stopPress()
        if holding then
            holding = false
            if longPressTask then
                task.cancel(longPressTask)
                longPressTask = nil
            end
        end
    end

    up.MouseButton1Up:Connect(stopPress)
    up.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            stopPress()
        end
    end)
end

-- 下降按钮
do
    local holding = false
    local longPressTask = nil

    local function startLongPress()
        if not holding then return end
        local interval = longPressSpeed
        while holding do
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local rootPart = char.HumanoidRootPart
                local delta = getMoveVector(-1, rootPart)
                rootPart.CFrame = rootPart.CFrame + delta
            end
            task.wait(interval)
            interval = math.max(0.001, interval * 0.9)
        end
    end

    down.MouseButton1Down:Connect(function()
        if holding then return end
        holding = true
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local rootPart = char.HumanoidRootPart
            local delta = getMoveVector(-1, rootPart)
            rootPart.CFrame = rootPart.CFrame + delta
        end
        longPressTask = task.delay(0.3, function()
            if holding then
                startLongPress()
            end
        end)
    end)

    local function stopPress()
        if holding then
            holding = false
            if longPressTask then
                task.cancel(longPressTask)
                longPressTask = nil
            end
        end
    end

    down.MouseButton1Up:Connect(stopPress)
    down.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            stopPress()
        end
    end)
end

-- 加速按钮
do
    local holding = false
    local longPressTask = nil

    local function startLongPress()
        if not holding then return end
        local interval = longPressSpeed
        while holding do
            if modeIndex == 0 then
                speeds = speeds + incStep
                speed.Text = tostring(speeds)
            elseif modeIndex == 1 and speedModeEnabled then
                lockedSpeed = lockedSpeed + incStep
            end
            task.wait(interval)
            interval = math.max(0.001, interval * 0.9)
        end
    end

    plus.MouseButton1Down:Connect(function()
        if holding then return end
        -- 移速模式未开启时禁止操作
        if modeIndex == 1 and not speedModeEnabled then
            return
        end
        holding = true
        if modeIndex == 0 then
            speeds = speeds + incStep
            speed.Text = tostring(speeds)
        elseif modeIndex == 1 then
            lockedSpeed = lockedSpeed + incStep
        end
        longPressTask = task.delay(0.3, function()
            if holding then
                startLongPress()
            end
        end)
    end)

    local function stopPress()
        if holding then
            holding = false
            if longPressTask then
                task.cancel(longPressTask)
                longPressTask = nil
            end
        end
    end

    plus.MouseButton1Up:Connect(stopPress)
    plus.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            stopPress()
        end
    end)
end

-- 减速按钮
do
    local holding = false
    local longPressTask = nil
    local MIN_SPEED = 0.1
    local MIN_LOCKED = 0.1

    local function decreaseFlySpeed()
        local current = tonumber(speeds) or 0
        if current > incStep then
            current = current - incStep
        elseif current > MIN_SPEED then
            current = MIN_SPEED
        else
            speed.Text = "已达最小速度"
            task.wait(1)
            speed.Text = tostring(speeds)
            return false
        end
        speeds = current
        speed.Text = tostring(speeds)
        return true
    end

    local function decreaseLockedSpeed()
        if lockedSpeed > incStep then
            lockedSpeed = lockedSpeed - incStep
        elseif lockedSpeed > MIN_LOCKED then
            lockedSpeed = MIN_LOCKED
        else
            speed.Text = "已达最小速度"
            task.wait(1)
            speed.Text = string.format("%.1f", lockedSpeed)
            return false
        end
        return true
    end

    local function startLongPress()
        if not holding then return end
        local interval = longPressSpeed
        while holding do
            local success = false
            if modeIndex == 0 then
                success = decreaseFlySpeed()
            elseif modeIndex == 1 and speedModeEnabled then
                success = decreaseLockedSpeed()
            end
            if not success then break end
            task.wait(interval)
            interval = math.max(0.001, interval * 0.9)
        end
    end

    mine.MouseButton1Down:Connect(function()
        if holding then return end
        -- 移速模式未开启时禁止操作
        if modeIndex == 1 and not speedModeEnabled then
            return
        end
        holding = true
        if modeIndex == 0 then
            decreaseFlySpeed()
        elseif modeIndex == 1 then
            decreaseLockedSpeed()
        end
        longPressTask = task.delay(0.3, function()
            if holding then
                startLongPress()
            end
        end)
    end)

    local function stopPress()
        if holding then
            holding = false
            if longPressTask then
                task.cancel(longPressTask)
                longPressTask = nil
            end
        end
    end

    mine.MouseButton1Up:Connect(stopPress)
    mine.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            stopPress()
        end
    end)
end

-- 速度标签（长按设置移动步长，单击设置速度值）
do
    local holding = false
    local longPressTask = nil

    speed.MouseButton1Down:Connect(function()
        if holding then return end
        holding = true

        longPressTask = task.delay(0.3, function()
            if holding then
                showInputDialog(
                    "设置移动步长（上升/下降距离）",
                    tostring(moveStep),
                    function(input)
                        local num = tonumber(input)
                        if num and num > 0 then
                            moveStep = num
                            tanchuangxiaoxi("移动步长已设为 " .. tostring(num), "步长设置")
                        else
                            tanchuangxiaoxi("请输入大于0的数字", "错误")
                        end
                    end,
                    {
                        text = "移动模式: " .. moveMode,
                        callback = function(btn)
                            showMoveModeSelection(moveMode, function(newMode)
                                moveMode = newMode
                                btn.Text = "移动模式: " .. moveMode
                                updateButtonText()
                                tanchuangxiaoxi("移动模式已切换至: " .. newMode, "快捷设置")
                            end)
                        end
                    }
                )
                holding = false
                longPressTask = nil
            end
        end)
    end)

    local function onRelease()
        if holding then
            if longPressTask then
                task.cancel(longPressTask)
                longPressTask = nil
            end
            if modeIndex == 0 then
                showInputDialog(
                    "设置速度倍率",
                    tostring(speeds),
                    function(input)
                        local num = tonumber(input)
                        if num and num > 0 then
                            speeds = num
                            speed.Text = tostring(speeds)
                            tanchuangxiaoxi("速度倍率已设为 " .. tostring(num), "速度设置")
                        else
                            tanchuangxiaoxi("请输入大于0的数字", "错误")
                        end
                    end,
                    {
                        text = "飞行模式: " .. flyMode,
                        callback = function(btn)
                            showFlyModeSelection(flyMode, function(newMode)
                                flyMode = newMode
                                btn.Text = "飞行模式: " .. flyMode
                                tanchuangxiaoxi("飞行模式已切换至: " .. flyMode, "快捷设置")
                            end)
                        end
                    }
                )
            elseif modeIndex == 1 and speedModeEnabled then
                showInputDialog(
                    "设置锁定速度",
                    string.format("%.1f", lockedSpeed),
                    function(input)
                        local num = tonumber(input)
                        if num and num > 0 then
                            lockedSpeed = num
                            tanchuangxiaoxi("锁定速度已设为 " .. tostring(num), "速度设置")
                        else
                            tanchuangxiaoxi("请输入大于0的数字", "错误")
                        end
                    end,
                    {
                        text = "飞行模式: " .. flyMode,
                        callback = function(btn)
                            showFlyModeSelection(flyMode, function(newMode)
                                flyMode = newMode
                                btn.Text = "飞行模式: " .. flyMode
                                tanchuangxiaoxi("飞行模式已切换至: " .. flyMode, "快捷设置")
                            end)
                        end
                    }
                )
            elseif modeIndex == 3 then
                showBrightnessDialog()
            end
            holding = false
        end
    end

    speed.MouseButton1Up:Connect(onRelease)
    speed.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            onRelease()
        end
    end)
end

-- ==================== 主按钮长按/单击逻辑 ====================
do
    local holding = false
    local longPressTask = nil
    local isLongPress = false

    onof.MouseButton1Down:Connect(function()
        if holding then return end
        holding = true
        isLongPress = false

        longPressTask = task.delay(0.3, function()
            if holding then
                isLongPress = true
                modeIndex = (modeIndex + 1) % 4  -- 改为4个模式循环
                updateMainButtonText()
                updateSpeedButtonText()
                tanchuangxiaoxi("已切换至" .. modeDisplayNames[modeIndex + 1] .. "模式", "模式切换")
                holding = false
                longPressTask = nil
            end
        end)
    end)

    local function onUp()
        if holding then
            if longPressTask then
                task.cancel(longPressTask)
                longPressTask = nil
            end
            if not isLongPress then
                if modeIndex == 0 then
                    toggleFly(not isFlying)
                elseif modeIndex == 1 then
                    speedModeEnabled = not speedModeEnabled
                    applySpeedMode(speedModeEnabled)
                elseif modeIndex == 2 then
                    if noclipEnabled then
                        disableNoclip()
                    else
                        enableNoclip()
                    end
                    updateMainButtonText()
                    updateSpeedButtonText()
                elseif modeIndex == 3 then
                    if nightVisionEnabled then
                        disableNightVision()
                    else
                        enableNightVision()
                    end
                    updateMainButtonText()
                    updateSpeedButtonText()
                end
            end
            holding = false
        end
    end

    onof.MouseButton1Up:Connect(onUp)
    onof.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            onUp()
        end
    end)
end

-- 隐藏按钮
do
    local holding = false
    local longPressTask = nil
    local isLongPress = false

    hide.MouseButton1Down:Connect(function()
        if holding then return end
        holding = true
        isLongPress = false

        longPressTask = task.delay(0.3, function()
            if holding then
                isLongPress = true
                showMainMenu()
                holding = false
                longPressTask = nil
            end
        end)
    end)

    local function onUp()
        if holding then
            if longPressTask then
                task.cancel(longPressTask)
                longPressTask = nil
            end
            if not isLongPress then
                local absPos = hide.AbsolutePosition
                Frame.Visible = false

                local mini = Instance.new("Frame")
                mini.Name = "MiniUI"
                mini.Parent = main
                mini.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
                mini.BorderColor3 = Color3.fromRGB(103, 221, 213)
                mini.Size = UDim2.new(0, 58, 0, 28)
                mini.Position = UDim2.fromOffset(absPos.X, absPos.Y)
                mini.Active = true

                local miniBtn = Instance.new("TextButton")
                miniBtn.Name = "MiniButton"
                miniBtn.Parent = mini
                miniBtn.Size = UDim2.new(1, 0, 1, 0)
                miniBtn.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
                miniBtn.Text = "UI"
                miniBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
                miniBtn.TextScaled = true
                miniBtn.Font = Enum.Font.SourceSans
                miniBtn.Active = true

                local dragStart, winStart, dragging = nil, nil, false
                local pressId = nil
                local MOVE_THRESHOLD = 10

                miniBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragStart = Vector2.new(input.Position.X, input.Position.Y)
                        winStart = mini.AbsolutePosition
                        dragging = false
                        pressId = input.KeyCode or input.UserInputType
                    end
                end)

                miniBtn.InputChanged:Connect(function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragStart then
                        local current = Vector2.new(input.Position.X, input.Position.Y)
                        local delta = current - dragStart
                        if not dragging and delta.Magnitude > MOVE_THRESHOLD then
                            dragging = true
                        end
                        if dragging then
                            local newPos = winStart + delta
                            mini.Position = UDim2.fromOffset(newPos.X, newPos.Y)
                        end
                    end
                end)

                miniBtn.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        if pressId and not dragging then
                            local miniPos = mini.AbsolutePosition
                            local screenSize = getScreenSize()
                            local newX = miniPos.X - 132
                            local newY = miniPos.Y
                            newX = clamp(newX, 0, screenSize.X - 190)
                            newY = clamp(newY, 0, screenSize.Y - 56)
                            Frame.Position = UDim2.fromOffset(newX, newY)
                            Frame.Visible = true
                            mini:Destroy()
                            miniWindow = nil
                        end
                        dragStart = nil
                        winStart = nil
                        dragging = false
                        pressId = nil
                    end
                end)

                miniWindow = mini
            end
            holding = false
        end
    end

    hide.MouseButton1Up:Connect(onUp)
    hide.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            onUp()
        end
    end)
end

-- ==================== 实时更新速度显示 ====================
RunService.Heartbeat:Connect(function()
    updateSpeedButtonText()
end)

-- ==================== 清理 ====================
main.Destroying:Connect(function()
    if speedModeConnection then
        speedModeConnection:Disconnect()
        speedModeConnection = nil
    end
    removeFly()
    disableNoclip()
    if nightVisionMaintainConnection then
        nightVisionMaintainConnection:Disconnect()
        nightVisionMaintainConnection = nil
    end
    if nightVisionEnabled then
        restoreLighting()
    end
    if miniWindow then
        miniWindow:Destroy()
        miniWindow = nil
    end
end)

-- 初始化按钮文本
updateButtonText()
updateMainButtonText()
updateSpeedButtonText()