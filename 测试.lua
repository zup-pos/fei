-- Gui to Lua
-- Version: 6.9.3 (修复触摸事件 + 自适应UI)

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
local stepSize = 2
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
local thirdPersonEnabled = false
local originalCameraType = nil
local originalCameraSubject = nil

-- 自由视角相关
local freeCamEnabled = false
local freeCamOffset = Vector3.new(0, 5, 10)
local freeCamConnection = nil
local originalFreeCamType = nil

-- 自由视角触摸相关（手动维护触摸点）
local touchPoints = {}                 -- 当前触摸点列表 { [fingerId] = Vector2 }
local rotateStartPos = nil              -- 单指旋转起始位置
local initialAngles = nil               -- 初始偏移向量的角度 {yaw, pitch}
local initialPinchDist = nil             -- 双指初始距离
local initialOffsetMag = nil             -- 初始偏移长度
local pinchConnection = nil              -- 触摸移动连接
local touchEndedConnection = nil         -- 触摸结束连接

-- 自由视角自定义参数
local freeCamSensitivity = 0.005
local freeCamMinDist = 1
local freeCamMaxDist = 50

-- 有效Humanoid状态列表
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

-- ==================== 自由视角控制 ====================
local function applyFreeCam(enable)
    local camera = workspace.CurrentCamera
    if not camera then return end

    if enable then
        if originalFreeCamType == nil then
            originalFreeCamType = camera.CameraType
        end
        camera.CameraType = Enum.CameraType.Scriptable

        if freeCamConnection then freeCamConnection:Disconnect() end
        freeCamConnection = RunService.RenderStepped:Connect(function()
            local char = player.Character
            if not char then return end
            local rootPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
            if not rootPart then return end
            local camPos = rootPart.Position + freeCamOffset
            camera.CFrame = CFrame.lookAt(camPos, rootPart.Position)
        end)

        -- 检查触摸点是否在UI区域内
        local function isPointInUI(pos)
            if not Frame or not Frame.Visible then return false end
            local absPos = Frame.AbsolutePosition
            local absSize = Frame.AbsoluteSize
            return pos.X >= absPos.X and pos.X <= absPos.X + absSize.X
               and pos.Y >= absPos.Y and pos.Y <= absPos.Y + absSize.Y
        end

        -- 触摸处理函数（由事件驱动）
        local function handleTouch()
            -- 获取当前所有触摸点
            local points = {}
            for fingerId, pos in pairs(touchPoints) do
                table.insert(points, {Position = pos})
            end
            table.sort(points, function(a,b) return a.Position.Magnitude < b.Position.Magnitude end) -- 简单排序

            -- 过滤UI区域：只要有一个点在UI内就忽略全部
            local anyInUI = false
            for _, point in ipairs(points) do
                if isPointInUI(point.Position) then
                    anyInUI = true
                    break
                end
            end
            if anyInUI then
                rotateStartPos = nil
                initialAngles = nil
                initialPinchDist = nil
                initialOffsetMag = nil
                return
            end

            local count = #points
            if count == 1 then
                local pos = points[1].Position
                if not rotateStartPos then
                    rotateStartPos = pos
                    local offset = freeCamOffset
                    local dist = offset.Magnitude
                    if dist > 0 then
                        local dir = offset.Unit
                        local yaw = math.atan2(dir.X, dir.Z)
                        local pitch = math.asin(dir.Y)
                        initialAngles = { yaw = yaw, pitch = pitch }
                        initialOffsetMag = dist
                    else
                        initialAngles = { yaw = 0, pitch = 0 }
                        initialOffsetMag = 0
                    end
                else
                    local delta = pos - rotateStartPos
                    local yawDelta = delta.X * freeCamSensitivity
                    local pitchDelta = -delta.Y * freeCamSensitivity

                    local newYaw = initialAngles.yaw + yawDelta
                    local maxPitch = math.pi/2 - 0.1
                    local newPitch = clamp(initialAngles.pitch + pitchDelta, -maxPitch, maxPitch)

                    local dist = initialOffsetMag
                    local dir = Vector3.new(
                        math.sin(newYaw) * math.cos(newPitch),
                        math.sin(newPitch),
                        math.cos(newYaw) * math.cos(newPitch)
                    )
                    freeCamOffset = dir * dist
                end
            elseif count == 2 then
                local p1 = points[1].Position
                local p2 = points[2].Position
                local currentDist = (p2 - p1).Magnitude

                if not initialPinchDist then
                    initialPinchDist = currentDist
                    initialOffsetMag = freeCamOffset.Magnitude
                else
                    local scale = currentDist / initialPinchDist
                    local newMag = clamp(initialOffsetMag * scale, freeCamMinDist, freeCamMaxDist)
                    if freeCamOffset.Magnitude > 0 then
                        freeCamOffset = freeCamOffset.Unit * newMag
                    end
                end
                rotateStartPos = nil
                initialAngles = nil
            else
                rotateStartPos = nil
                initialAngles = nil
                initialPinchDist = nil
                initialOffsetMag = nil
            end
        end

        -- 连接触摸事件
        if not pinchConnection then
            pinchConnection = UserInputService.TouchMoved:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                local fingerId = input.UserInputType == Enum.UserInputType.Touch and input.KeyCode or nil
                if fingerId then
                    touchPoints[fingerId] = input.Position
                end
                handleTouch()
            end)
        end
        if not touchEndedConnection then
            touchEndedConnection = UserInputService.TouchEnded:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                local fingerId = input.UserInputType == Enum.UserInputType.Touch and input.KeyCode or nil
                if fingerId then
                    touchPoints[fingerId] = nil
                end
                handleTouch()
                if next(touchPoints) == nil then
                    rotateStartPos = nil
                    initialAngles = nil
                    initialPinchDist = nil
                    initialOffsetMag = nil
                end
            end)
        end
        -- 触摸开始时也要记录
        UserInputService.TouchStarted:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            local fingerId = input.UserInputType == Enum.UserInputType.Touch and input.KeyCode or nil
            if fingerId then
                touchPoints[fingerId] = input.Position
            end
            handleTouch()
        end)
    else
        if freeCamConnection then
            freeCamConnection:Disconnect()
            freeCamConnection = nil
        end
        if pinchConnection then
            pinchConnection:Disconnect()
            pinchConnection = nil
        end
        if touchEndedConnection then
            touchEndedConnection:Disconnect()
            touchEndedConnection = nil
        end
        touchPoints = {}
        rotateStartPos = nil
        initialAngles = nil
        initialPinchDist = nil
        initialOffsetMag = nil

        if originalFreeCamType then
            camera.CameraType = originalFreeCamType
            originalFreeCamType = nil
        else
            camera.CameraType = Enum.CameraType.Custom
        end
    end
end

local function setFreeCamOffset(x, y, z)
    freeCamOffset = Vector3.new(x, y, z)
    if freeCamEnabled then
        applyFreeCam(true)
    end
end

local function setFreeCamDistance(dist)
    if freeCamOffset.Magnitude == 0 then
        freeCamOffset = Vector3.new(0, 5, 10)
    end
    local dir = freeCamOffset.Unit
    freeCamOffset = dir * clamp(dist, freeCamMinDist, freeCamMaxDist)
    if freeCamEnabled then
        applyFreeCam(true)
    end
end

local function resetFreeCamOffset()
    freeCamOffset = Vector3.new(0, 5, 10)
    if freeCamEnabled then
        applyFreeCam(true)
    end
end

-- ==================== 第三人称相机控制 ====================
local function applyThirdPerson(enable)
    local camera = workspace.CurrentCamera
    if not camera then return end

    if enable then
        if originalCameraType == nil then
            originalCameraType = camera.CameraType
            originalCameraSubject = camera.CameraSubject
        end
        camera.CameraType = Enum.CameraType.Follow
        if player.Character then
            local hum = player.Character:FindFirstChildWhichIsA("Humanoid")
            if hum then
                camera.CameraSubject = hum
            end
        end
    else
        if originalCameraType then
            camera.CameraType = originalCameraType
            camera.CameraSubject = originalCameraSubject
        else
            camera.CameraType = Enum.CameraType.Custom
            camera.CameraSubject = nil
        end
    end
end

-- 角色重生处理
local function onCharacterAdded(char)
    task.wait(0.7)
    if thirdPersonEnabled then
        applyThirdPerson(true)
    end
    if freeCamEnabled then
        applyFreeCam(true)
    end
    if isFlying then
        isFlying = false
        onof.Text = "飞天(关闭)"
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if hum then
            for _, state in ipairs(VALID_HUMANOD_STATES) do
                pcall(function() hum:SetStateEnabled(state, true) end)
            end
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics); hum.PlatformStand = false end)
        end
        char.Animate.Disabled = false
        stopTpwalking()
    end
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

-- ==================== 输入对话框（支持第三个按钮） ====================
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

-- ==================== 通用菜单创建函数（支持滚动）====================
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

-- ==================== 相机设置对话框（自适应小屏幕）====================
local function showCameraSettings()
    local screenSize = getScreenSize()
    local dialogWidth = math.min(400, screenSize.X * 0.85)  -- 小屏时宽度自适应
    local dialogHeight = math.min(600, screenSize.Y * 0.8)  -- 高度不超过屏幕80%

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
    titleLabel.Text = "相机设置"
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 20
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center

    -- 创建一个滚动框架，以便内容过多时可以滚动
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Parent = bg
    scrollingFrame.Size = UDim2.new(1, -20, 1, -80)  -- 减去标题和底部按钮区域
    scrollingFrame.Position = UDim2.new(0, 10, 0, 50)
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 540)  -- 预设内容总高度
    scrollingFrame.ScrollBarThickness = 8
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollingEnabled = true
    scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 150)

    local container = Instance.new("Frame")
    container.Parent = scrollingFrame
    container.Size = UDim2.new(1, 0, 0, 540)
    container.BackgroundTransparency = 1
    container.Position = UDim2.new(0, 0, 0, 0)

    -- 开关按钮
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Parent = container
    toggleBtn.Size = UDim2.new(1, -20, 0, 40)
    toggleBtn.Position = UDim2.new(0, 10, 0, 10)
    toggleBtn.BackgroundColor3 = freeCamEnabled and Color3.fromRGB(0,150,0) or Color3.fromRGB(150,0,0)
    toggleBtn.Text = freeCamEnabled and "自由视角: 开启" or "自由视角: 关闭"
    toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 16
    toggleBtn.AutoButtonColor = true
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.Parent = toggleBtn
    toggleCorner.CornerRadius = UDim.new(0, 6)

    -- 坐标输入
    local coordLabel = Instance.new("TextLabel")
    coordLabel.Parent = container
    coordLabel.Size = UDim2.new(1, -20, 0, 30)
    coordLabel.Position = UDim2.new(0, 10, 0, 60)
    coordLabel.BackgroundTransparency = 1
    coordLabel.Text = "偏移坐标 X, Y, Z"
    coordLabel.TextColor3 = Color3.new(1, 1, 1)
    coordLabel.Font = Enum.Font.Gotham
    coordLabel.TextSize = 14
    coordLabel.TextXAlignment = Enum.TextXAlignment.Left

    local inputWidth = (dialogWidth - 80) / 3
    local xBox = Instance.new("TextBox")
    xBox.Parent = container
    xBox.Size = UDim2.new(0, inputWidth, 0, 35)
    xBox.Position = UDim2.new(0, 10, 0, 95)
    xBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    xBox.TextColor3 = Color3.new(1, 1, 1)
    xBox.PlaceholderText = "X"
    xBox.Text = tostring(freeCamOffset.X)
    xBox.Font = Enum.Font.Gotham
    xBox.TextSize = 14
    xBox.ClearTextOnFocus = false

    local yBox = Instance.new("TextBox")
    yBox.Parent = container
    yBox.Size = UDim2.new(0, inputWidth, 0, 35)
    yBox.Position = UDim2.new(0, 20 + inputWidth, 0, 95)
    yBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    yBox.TextColor3 = Color3.new(1, 1, 1)
    yBox.PlaceholderText = "Y"
    yBox.Text = tostring(freeCamOffset.Y)
    yBox.Font = Enum.Font.Gotham
    yBox.TextSize = 14
    yBox.ClearTextOnFocus = false

    local zBox = Instance.new("TextBox")
    zBox.Parent = container
    zBox.Size = UDim2.new(0, inputWidth, 0, 35)
    zBox.Position = UDim2.new(0, 30 + 2*inputWidth, 0, 95)
    zBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    zBox.TextColor3 = Color3.new(1, 1, 1)
    zBox.PlaceholderText = "Z"
    zBox.Text = tostring(freeCamOffset.Z)
    zBox.Font = Enum.Font.Gotham
    zBox.TextSize = 14
    zBox.ClearTextOnFocus = false

    -- 距离输入
    local distLabel = Instance.new("TextLabel")
    distLabel.Parent = container
    distLabel.Size = UDim2.new(1, -20, 0, 30)
    distLabel.Position = UDim2.new(0, 10, 0, 145)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "距离 (保持方向)"
    distLabel.TextColor3 = Color3.new(1, 1, 1)
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextSize = 14
    distLabel.TextXAlignment = Enum.TextXAlignment.Left

    local distBox = Instance.new("TextBox")
    distBox.Parent = container
    distBox.Size = UDim2.new(0, 100, 0, 35)
    distBox.Position = UDim2.new(0, 10, 0, 175)
    distBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    distBox.TextColor3 = Color3.new(1, 1, 1)
    distBox.PlaceholderText = "距离"
    distBox.Text = tostring(math.floor(freeCamOffset.Magnitude * 100) / 100)
    distBox.Font = Enum.Font.Gotham
    distBox.TextSize = 14
    distBox.ClearTextOnFocus = false

    -- 灵敏度滑块
    local sensLabel = Instance.new("TextLabel")
    sensLabel.Parent = container
    sensLabel.Size = UDim2.new(1, -20, 0, 30)
    sensLabel.Position = UDim2.new(0, 10, 0, 225)
    sensLabel.BackgroundTransparency = 1
    sensLabel.Text = "滑动灵敏度: " .. string.format("%.3f", freeCamSensitivity)
    sensLabel.TextColor3 = Color3.new(1, 1, 1)
    sensLabel.Font = Enum.Font.Gotham
    sensLabel.TextSize = 14
    sensLabel.TextXAlignment = Enum.TextXAlignment.Left

    local sensSlider = Instance.new("Frame")
    sensSlider.Parent = container
    sensSlider.Size = UDim2.new(0, 200, 0, 30)
    sensSlider.Position = UDim2.new(0, 10, 0, 255)
    sensSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sensSlider.BorderSizePixel = 0
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.Parent = sensSlider
    sliderCorner.CornerRadius = UDim.new(0, 4)

    local sliderButton = Instance.new("TextButton")
    sliderButton.Parent = sensSlider
    sliderButton.Size = UDim2.new(0, 20, 1, 0)
    sliderButton.Position = UDim2.new(freeCamSensitivity / 0.01, 0, 0, 0)
    sliderButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    sliderButton.Text = ""
    sliderButton.AutoButtonColor = false
    local sliderButtonCorner = Instance.new("UICorner")
    sliderButtonCorner.Parent = sliderButton
    sliderButtonCorner.CornerRadius = UDim.new(0, 4)

    local sensValueBox = Instance.new("TextBox")
    sensValueBox.Parent = container
    sensValueBox.Size = UDim2.new(0, 80, 0, 35)
    sensValueBox.Position = UDim2.new(0, 220, 0, 250)
    sensValueBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sensValueBox.TextColor3 = Color3.new(1, 1, 1)
    sensValueBox.Text = string.format("%.3f", freeCamSensitivity)
    sensValueBox.Font = Enum.Font.Gotham
    sensValueBox.TextSize = 14
    sensValueBox.ClearTextOnFocus = false
    local sensValueCorner = Instance.new("UICorner")
    sensValueCorner.Parent = sensValueBox
    sensValueCorner.CornerRadius = UDim.new(0, 4)

    -- 最小距离输入
    local minDistLabel = Instance.new("TextLabel")
    minDistLabel.Parent = container
    minDistLabel.Size = UDim2.new(0, 100, 0, 30)
    minDistLabel.Position = UDim2.new(0, 10, 0, 305)
    minDistLabel.BackgroundTransparency = 1
    minDistLabel.Text = "最小距离"
    minDistLabel.TextColor3 = Color3.new(1, 1, 1)
    minDistLabel.Font = Enum.Font.Gotham
    minDistLabel.TextSize = 14
    minDistLabel.TextXAlignment = Enum.TextXAlignment.Left

    local minDistBox = Instance.new("TextBox")
    minDistBox.Parent = container
    minDistBox.Size = UDim2.new(0, 80, 0, 35)
    minDistBox.Position = UDim2.new(0, 10, 0, 335)
    minDistBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    minDistBox.TextColor3 = Color3.new(1, 1, 1)
    minDistBox.Text = tostring(freeCamMinDist)
    minDistBox.Font = Enum.Font.Gotham
    minDistBox.TextSize = 14
    minDistBox.ClearTextOnFocus = false
    local minDistCorner = Instance.new("UICorner")
    minDistCorner.Parent = minDistBox
    minDistCorner.CornerRadius = UDim.new(0, 4)

    -- 最大距离输入
    local maxDistLabel = Instance.new("TextLabel")
    maxDistLabel.Parent = container
    maxDistLabel.Size = UDim2.new(0, 100, 0, 30)
    maxDistLabel.Position = UDim2.new(0, 120, 0, 305)
    maxDistLabel.BackgroundTransparency = 1
    maxDistLabel.Text = "最大距离"
    maxDistLabel.TextColor3 = Color3.new(1, 1, 1)
    maxDistLabel.Font = Enum.Font.Gotham
    maxDistLabel.TextSize = 14
    maxDistLabel.TextXAlignment = Enum.TextXAlignment.Left

    local maxDistBox = Instance.new("TextBox")
    maxDistBox.Parent = container
    maxDistBox.Size = UDim2.new(0, 80, 0, 35)
    maxDistBox.Position = UDim2.new(0, 120, 0, 335)
    maxDistBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    maxDistBox.TextColor3 = Color3.new(1, 1, 1)
    maxDistBox.Text = tostring(freeCamMaxDist)
    maxDistBox.Font = Enum.Font.Gotham
    maxDistBox.TextSize = 14
    maxDistBox.ClearTextOnFocus = false
    local maxDistCorner = Instance.new("UICorner")
    maxDistCorner.Parent = maxDistBox
    maxDistCorner.CornerRadius = UDim.new(0, 4)

    -- 重置按钮和关闭按钮放在容器底部，但为了滚动，将其放在容器内
    local resetBtn = Instance.new("TextButton")
    resetBtn.Parent = container
    resetBtn.Size = UDim2.new(0, 120, 0, 40)
    resetBtn.Position = UDim2.new(0, 10, 0, 400)
    resetBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    resetBtn.Text = "重置默认"
    resetBtn.TextColor3 = Color3.new(1, 1, 1)
    resetBtn.Font = Enum.Font.GothamBold
    resetBtn.TextSize = 14
    resetBtn.AutoButtonColor = true
    local resetCorner = Instance.new("UICorner")
    resetCorner.Parent = resetBtn
    resetCorner.CornerRadius = UDim.new(0, 6)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = container
    closeBtn.Size = UDim2.new(0, 120, 0, 40)
    closeBtn.Position = UDim2.new(1, -130, 0, 400)
    closeBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    closeBtn.Text = "关闭"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.AutoButtonColor = true
    local closeCorner = Instance.new("UICorner")
    closeCorner.Parent = closeBtn
    closeCorner.CornerRadius = UDim.new(0, 6)

    -- 更新画布大小以适应内容
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 470)

    -- 功能函数：更新偏移
    local function updateOffsetFromInputs()
        local x = tonumber(xBox.Text)
        local y = tonumber(yBox.Text)
        local z = tonumber(zBox.Text)
        if x and y and z then
            setFreeCamOffset(x, y, z)
            distBox.Text = tostring(math.floor(freeCamOffset.Magnitude * 100) / 100)
        else
            tanchuangxiaoxi("请输入有效的数字", "错误")
        end
    end

    local function updateDistFromInput()
        local d = tonumber(distBox.Text)
        if d and d > 0 then
            setFreeCamDistance(d)
            xBox.Text = tostring(freeCamOffset.X)
            yBox.Text = tostring(freeCamOffset.Y)
            zBox.Text = tostring(freeCamOffset.Z)
        else
            tanchuangxiaoxi("请输入大于0的距离", "错误")
        end
    end

    local function updateSensitivityFromSlider()
        local sliderWidth = sensSlider.AbsoluteSize.X - sliderButton.AbsoluteSize.X
        if sliderWidth <= 0 then return end
        local posX = sliderButton.AbsolutePosition.X - sensSlider.AbsolutePosition.X
        local ratio = clamp(posX / sliderWidth, 0, 1)
        freeCamSensitivity = ratio * 0.01
        sensLabel.Text = "滑动灵敏度: " .. string.format("%.3f", freeCamSensitivity)
        sensValueBox.Text = string.format("%.3f", freeCamSensitivity)
    end

    -- 开关按钮点击
    toggleBtn.MouseButton1Click:Connect(function()
        freeCamEnabled = not freeCamEnabled
        applyFreeCam(freeCamEnabled)
        toggleBtn.BackgroundColor3 = freeCamEnabled and Color3.fromRGB(0,150,0) or Color3.fromRGB(150,0,0)
        toggleBtn.Text = freeCamEnabled and "自由视角: 开启" or "自由视角: 关闭"
        tanchuangxiaoxi(freeCamEnabled and "已开启自由视角" or "已关闭自由视角", "相机")
    end)

    -- 坐标输入框回车或失去焦点时应用
    local function onCoordEnter()
        updateOffsetFromInputs()
    end
    xBox.FocusLost:Connect(onCoordEnter)
    yBox.FocusLost:Connect(onCoordEnter)
    zBox.FocusLost:Connect(onCoordEnter)

    -- 距离框回车或失去焦点时应用
    distBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            updateDistFromInput()
        end
    end)

    -- 灵敏度滑块拖动
    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            local dragConn
            dragConn = UserInputService.InputChanged:Connect(function()
                updateSensitivityFromSlider()
            end)
            local releaseConn
            releaseConn = UserInputService.InputEnded:Connect(function(endedInput)
                if endedInput == input then
                    dragConn:Disconnect()
                    releaseConn:Disconnect()
                end
            end)
        end
    end)

    sensValueBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local val = tonumber(sensValueBox.Text)
            if val and val >= 0 and val <= 0.01 then
                freeCamSensitivity = val
                sensLabel.Text = "滑动灵敏度: " .. string.format("%.3f", freeCamSensitivity)
                local sliderWidth = sensSlider.AbsoluteSize.X - sliderButton.AbsoluteSize.X
                if sliderWidth > 0 then
                    local newX = (freeCamSensitivity / 0.01) * sliderWidth
                    sliderButton.Position = UDim2.new(0, newX, 0, 0)
                end
            else
                tanchuangxiaoxi("请输入0~0.01之间的数字", "错误")
                sensValueBox.Text = string.format("%.3f", freeCamSensitivity)
            end
        end
    end)

    -- 最小距离
    minDistBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local val = tonumber(minDistBox.Text)
            if val and val > 0 and val < freeCamMaxDist then
                freeCamMinDist = val
                if freeCamEnabled then
                    if freeCamOffset.Magnitude < freeCamMinDist then
                        setFreeCamDistance(freeCamMinDist)
                        xBox.Text = tostring(freeCamOffset.X)
                        yBox.Text = tostring(freeCamOffset.Y)
                        zBox.Text = tostring(freeCamOffset.Z)
                        distBox.Text = tostring(math.floor(freeCamOffset.Magnitude * 100) / 100)
                    end
                end
            else
                tanchuangxiaoxi("最小距离必须小于最大距离且大于0", "错误")
                minDistBox.Text = tostring(freeCamMinDist)
            end
        end
    end)

    -- 最大距离
    maxDistBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local val = tonumber(maxDistBox.Text)
            if val and val > freeCamMinDist then
                freeCamMaxDist = val
                if freeCamEnabled then
                    if freeCamOffset.Magnitude > freeCamMaxDist then
                        setFreeCamDistance(freeCamMaxDist)
                        xBox.Text = tostring(freeCamOffset.X)
                        yBox.Text = tostring(freeCamOffset.Y)
                        zBox.Text = tostring(freeCamOffset.Z)
                        distBox.Text = tostring(math.floor(freeCamOffset.Magnitude * 100) / 100)
                    end
                end
            else
                tanchuangxiaoxi("最大距离必须大于最小距离", "错误")
                maxDistBox.Text = tostring(freeCamMaxDist)
            end
        end
    end)

    -- 重置按钮
    resetBtn.MouseButton1Click:Connect(function()
        resetFreeCamOffset()
        xBox.Text = tostring(freeCamOffset.X)
        yBox.Text = tostring(freeCamOffset.Y)
        zBox.Text = tostring(freeCamOffset.Z)
        distBox.Text = tostring(math.floor(freeCamOffset.Magnitude * 100) / 100)
        tanchuangxiaoxi("相机偏移已重置为默认", "相机")
    end)

    -- 关闭按钮
    closeBtn.MouseButton1Click:Connect(function()
        dialog:Destroy()
    end)
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
        table.insert(buttons, {
            text = mode .. (mode == currentMode and " ✓" or ""),
            callback = function(menu)
                menu:Destroy()
                callback(mode)
            end
        })
    end
    createMenu("选择飞行模式", buttons, nil)
end

local function showMoveModeSelection(currentMode, callback)
    local buttons = {}
    for _, mode in ipairs(MOVE_MODES) do
        table.insert(buttons, {
            text = mode .. (mode == currentMode and " ✓" or ""),
            callback = function(menu)
                menu:Destroy()
                callback(mode)
            end
        })
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
                    "版本 6.9.3 更新内容：",
                    "",
                    "1. 修复触摸错误：改用 TouchStarted/TouchMoved/TouchEnded",
                    "2. 优化UI自适应：小屏幕可滚动，不再溢出",
                    "3. 相机设置对话框完全适配不同尺寸",
                    "",
                    "功能介绍：",
                    "- 上升/下降（或前移/后移/左移/右移）：单击移动，长按连续",
                    "- 加速/减速：单击调速度，长按连续（支持小数，最小0.1）",
                    "- 速度标签：单击设倍率（带飞行模式菜单），长按设步长（带移动模式菜单）",
                    "- 飞天开关：开启/关闭飞行，支持方向选择",
                    "- 隐藏按钮：单击折叠UI，长按打开菜单",
                    "- 音量键控制：可在设置中开启/关闭，减隐藏、加显示",
                    "- 自由视角：开启后可用单指旋转、双指缩放",
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
                    "🔹 加速/减速：单击速度+1/-1，长按连续（支持小数，最小0.1）",
                    "🔹 速度标签：单击设倍率（带飞行模式菜单），长按设步长（带移动模式菜单）",
                    "🔹 飞天开关：开启/关闭飞行，支持方向选择",
                    "🔹 隐藏按钮：单击折叠UI，长按打开菜单",
                    "🔹 UI按钮：纯标签，无功能",
                    "🔹 自由视角：开启后可用单指旋转、双指缩放",
                    "   可在相机设置中调节灵敏度、最小/最大距离",
                    "",
                    "⚙️ 菜单功能：",
                    "- 查看公告：显示更新日志",
                    "- 功能介绍：本页面",
                    "- 设置：调整弹窗透明度、",
                    "  启用音量键隐藏、",
                    "  设置屏幕尺寸、",
                    "  长按速度、",
                    "  上升/下降模式、",
                    "  飞行方向模式、",
                    "  相机设置（自由视角）",
                    "- 结束脚本：彻底停止",
                    "",
                    "音量键隐藏：",
                    "启用后，按音量减隐藏UI，",
                    "音量加显示"
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
                            text = "⬆️ 上升/下降模式: " .. moveMode,
                            callback = function(parentMenu)
                                createMenu("选择移动模式", {
                                    { text = "角色上下" .. (moveMode == "角色上下" and " ✓" or ""), callback = function(choiceMenu)
                                        moveMode = "角色上下"; updateButtonText()
                                        tanchuangxiaoxi("上升/下降模式已切换至: 角色上下", "模式切换")
                                        choiceMenu:Destroy(); parentMenu:Destroy(); createSettingMenu()
                                    end },
                                    { text = "角色前后" .. (moveMode == "角色前后" and " ✓" or ""), callback = function(choiceMenu)
                                        moveMode = "角色前后"; updateButtonText()
                                        tanchuangxiaoxi("上升/下降模式已切换至: 角色前后", "模式切换")
                                        choiceMenu:Destroy(); parentMenu:Destroy(); createSettingMenu()
                                    end },
                                    { text = "角色左右" .. (moveMode == "角色左右" and " ✓" or ""), callback = function(choiceMenu)
                                        moveMode = "角色左右"; updateButtonText()
                                        tanchuangxiaoxi("上升/下降模式已切换至: 角色左右", "模式切换")
                                        choiceMenu:Destroy(); parentMenu:Destroy(); createSettingMenu()
                                    end },
                                    { text = "屏幕上下" .. (moveMode == "屏幕上下" and " ✓" or ""), callback = function(choiceMenu)
                                        moveMode = "屏幕上下"; updateButtonText()
                                        tanchuangxiaoxi("上升/下降模式已切换至: 屏幕上下", "模式切换")
                                        choiceMenu:Destroy(); parentMenu:Destroy(); createSettingMenu()
                                    end },
                                    { text = "屏幕前后" .. (moveMode == "屏幕前后" and " ✓" or ""), callback = function(choiceMenu)
                                        moveMode = "屏幕前后"; updateButtonText()
                                        tanchuangxiaoxi("上升/下降模式已切换至: 屏幕前后", "模式切换")
                                        choiceMenu:Destroy(); parentMenu:Destroy(); createSettingMenu()
                                    end },
                                    { text = "屏幕左右" .. (moveMode == "屏幕左右" and " ✓" or ""), callback = function(choiceMenu)
                                        moveMode = "屏幕左右"; updateButtonText()
                                        tanchuangxiaoxi("上升/下降模式已切换至: 屏幕左右", "模式切换")
                                        choiceMenu:Destroy(); parentMenu:Destroy(); createSettingMenu()
                                    end },
                                    { text = "水平上下" .. (moveMode == "水平上下" and " ✓" or ""), callback = function(choiceMenu)
                                        moveMode = "水平上下"; updateButtonText()
                                        tanchuangxiaoxi("上升/下降模式已切换至: 水平上下", "模式切换")
                                        choiceMenu:Destroy(); parentMenu:Destroy(); createSettingMenu()
                                    end },
                                    { text = "水平前后(屏幕)" .. (moveMode == "水平前后(屏幕)" and " ✓" or ""), callback = function(choiceMenu)
                                        moveMode = "水平前后(屏幕)"; updateButtonText()
                                        tanchuangxiaoxi("上升/下降模式已切换至: 水平前后(屏幕)", "模式切换")
                                        choiceMenu:Destroy(); parentMenu:Destroy(); createSettingMenu()
                                    end },
                                    { text = "水平左右(屏幕)" .. (moveMode == "水平左右(屏幕)" and " ✓" or ""), callback = function(choiceMenu)
                                        moveMode = "水平左右(屏幕)"; updateButtonText()
                                        tanchuangxiaoxi("上升/下降模式已切换至: 水平左右(屏幕)", "模式切换")
                                        choiceMenu:Destroy(); parentMenu:Destroy(); createSettingMenu()
                                    end },
                                }, nil)
                            end
                        },
                        {
                            text = "✈️ 飞行方向模式: " .. flyMode,
                            callback = function(parentMenu)
                                createMenu("选择飞行模式", {
                                    { text = "屏幕" .. (flyMode == "屏幕" and " ✓" or ""), callback = function(choiceMenu)
                                        flyMode = "屏幕"
                                        tanchuangxiaoxi("飞行方向模式已切换至: 屏幕", "模式切换")
                                        choiceMenu:Destroy(); parentMenu:Destroy(); createSettingMenu()
                                    end },
                                    { text = "悬空" .. (flyMode == "悬空" and " ✓" or ""), callback = function(choiceMenu)
                                        flyMode = "悬空"
                                        tanchuangxiaoxi("飞行方向模式已切换至: 悬空", "模式切换")
                                        choiceMenu:Destroy(); parentMenu:Destroy(); createSettingMenu()
                                    end },
                                    { text = "绝对锁高" .. (flyMode == "绝对锁高" and " ✓" or ""), callback = function(choiceMenu)
                                        flyMode = "绝对锁高"
                                        tanchuangxiaoxi("飞行方向模式已切换至: 绝对锁高", "模式切换")
                                        choiceMenu:Destroy(); parentMenu:Destroy(); createSettingMenu()
                                    end },
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
                        -- 第三人称视角开关（保留但可能无效）
                        {
                            text = thirdPersonEnabled and "👁️ 第三人称视角: 开启" or "👁️ 第三人称视角: 关闭",
                            callback = function(parentMenu)
                                thirdPersonEnabled = not thirdPersonEnabled
                                applyThirdPerson(thirdPersonEnabled)
                                tanchuangxiaoxi(thirdPersonEnabled and "已开启第三人称视角" or "已关闭第三人称视角", "视角设置")
                                parentMenu:Destroy()
                                createSettingMenu()
                            end
                        },
                        -- 相机设置（自由视角）
                        {
                            text = "📷 相机设置",
                            callback = function(parentMenu)
                                showCameraSettings()
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
                    { text = "确认", callback = function(confirmMenu)
                        confirmMenu:Destroy()
                        isFlying = false
                        tpwalking = false
                        applyThirdPerson(false)
                        applyFreeCam(false)
                        if main and main.Parent then main:Destroy() end
                        if miniWindow and miniWindow.Parent then miniWindow:Destroy(); miniWindow = nil end
                        for _, notif in ipairs(notifs) do if notif.sg and notif.sg.Parent then notif.sg:Destroy() end end
                        notifs = {}; readyQueue = {}
                    end },
                    { text = "取消", callback = function(confirmMenu) confirmMenu:Destroy() end }
                }, nil)
            end
        }
    }, nil)
end

-- ==================== TP Walk 相关 ====================
local function stopTpwalking() tpwalking = false end

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

-- ==================== 飞天开关 ====================
onof.MouseButton1Click:Connect(function()
    if isFlying then
        isFlying = false
        onof.Text = "飞天(关闭)"
        stopTpwalking()
        tanchuangxiaoxi("已关闭飞天", "飞天")

        local char = player.Character
        if char then
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if hum then
                for _, state in ipairs(VALID_HUMANOD_STATES) do
                    pcall(function() hum:SetStateEnabled(state, true) end)
                end
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics); hum.PlatformStand = false end)
            end
            char.Animate.Disabled = false
        end
    else
        isFlying = true
        onof.Text = "飞天(开启)"
        stopTpwalking()
        tanchuangxiaoxi("已开启飞天", "飞天")

        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if not hum then return end

        char.Animate.Disabled = true
        for _, track in ipairs(hum:GetPlayingAnimationTracks()) do track:AdjustSpeed(0) end

        for _, state in ipairs(VALID_HUMANOD_STATES) do
            pcall(function() hum:SetStateEnabled(state, false) end)
        end
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Swimming); hum.PlatformStand = true end)

        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
        if not torso then return end
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

        bg:Destroy()
        bv:Destroy()

        if isFlying then
            isFlying = false
            onof.Text = "飞天(关闭)"
            stopTpwalking()
            local charNow = player.Character
            if charNow then
                local humNow = charNow:FindFirstChildWhichIsA("Humanoid")
                if humNow then
                    for _, state in ipairs(VALID_HUMANOD_STATES) do
                        pcall(function() humNow:SetStateEnabled(state, true) end)
                    end
                    pcall(function() humNow:ChangeState(Enum.HumanoidStateType.RunningNoPhysics); humNow.PlatformStand = false end)
                end
                charNow.Animate.Disabled = false
            end
        end
    end
end)

-- ==================== 辅助函数：根据当前模式获取移动向量 ====================
local function getMoveVector(dir, rootPart)
    local step = dir * stepSize
    if moveMode == "角色上下" then
        return rootPart.CFrame.UpVector * step
    elseif moveMode == "角色前后" then
        return rootPart.CFrame.LookVector * step
    elseif moveMode == "角色左右" then
        return -rootPart.CFrame.RightVector * step
    elseif moveMode == "屏幕上下" then
        local camera = workspace.CurrentCamera
        if camera then return camera.CFrame.UpVector * step end
    elseif moveMode == "屏幕前后" then
        local camera = workspace.CurrentCamera
        if camera then return camera.CFrame.LookVector * step end
    elseif moveMode == "屏幕左右" then
        local camera = workspace.CurrentCamera
        if camera then return -camera.CFrame.RightVector * step end
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
                return Vector3.new(0,0,0)
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
                return Vector3.new(0,0,0)
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
            rootPart.CFrame = rootPart.CFrame + getMoveVector(1, rootPart)
        end
        longPressTask = task.delay(0.3, function() if holding then startLongPress() end end)
    end)
    local function stopPress()
        if holding then
            holding = false
            if longPressTask then task.cancel(longPressTask); longPressTask = nil end
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
            rootPart.CFrame = rootPart.CFrame + getMoveVector(-1, rootPart)
        end
        longPressTask = task.delay(0.3, function() if holding then startLongPress() end end)
    end)
    local function stopPress()
        if holding then
            holding = false
            if longPressTask then task.cancel(longPressTask); longPressTask = nil end
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
            speeds = speeds + 1
            speed.Text = tostring(speeds)
            task.wait(interval)
            interval = math.max(0.001, interval * 0.9)
        end
    end
    plus.MouseButton1Down:Connect(function()
        if holding then return end
        holding = true
        speeds = speeds + 1
        speed.Text = tostring(speeds)
        longPressTask = task.delay(0.3, function() if holding then startLongPress() end end)
    end)
    local function stopPress()
        if holding then
            holding = false
            if longPressTask then task.cancel(longPressTask); longPressTask = nil end
        end
    end
    plus.MouseButton1Up:Connect(stopPress)
    plus.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            stopPress()
        end
    end)
end

-- 减速按钮（修复负数问题）
do
    local holding = false
    local longPressTask = nil
    local MIN_SPEED = 0.1

    local function decreaseSpeed()
        if speeds > 1 then
            speeds = speeds - 1
        elseif speeds > MIN_SPEED then
            speeds = MIN_SPEED
        else
            speed.Text = "已达最小速度"
            task.wait(1)
            speed.Text = tostring(speeds)
            return false
        end
        speed.Text = tostring(speeds)
        return true
    end

    local function startLongPress()
        if not holding then return end
        local interval = longPressSpeed
        while holding do
            if not decreaseSpeed() then break end
            task.wait(interval)
            interval = math.max(0.001, interval * 0.9)
        end
    end

    mine.MouseButton1Down:Connect(function()
        if holding then return end
        holding = true
        decreaseSpeed()
        longPressTask = task.delay(0.3, function()
            if holding then startLongPress() end
        end)
    end)

    local function stopPress()
        if holding then
            holding = false
            if longPressTask then task.cancel(longPressTask); longPressTask = nil end
        end
    end

    mine.MouseButton1Up:Connect(stopPress)
    mine.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            stopPress()
        end
    end)
end

-- 速度标签
do
    local holding = false
    local longPressTask = nil

    speed.MouseButton1Down:Connect(function()
        if holding then return end
        holding = true
        longPressTask = task.delay(0.3, function()
            if holding then
                showInputDialog("设置上升/下降步长", tostring(stepSize), function(newStep)
                    stepSize = newStep
                    tanchuangxiaoxi("步长已设为 " .. tostring(newStep), "步长设置")
                end, {
                    text = "移动模式: " .. moveMode,
                    callback = function(btn)
                        showMoveModeSelection(moveMode, function(newMode)
                            moveMode = newMode
                            btn.Text = "移动模式: " .. moveMode
                            updateButtonText()
                            tanchuangxiaoxi("移动模式已切换至: " .. moveMode, "快捷设置")
                        end)
                    end
                })
                holding = false
                longPressTask = nil
            end
        end)
    end)

    local function onRelease()
        if holding then
            if longPressTask then task.cancel(longPressTask); longPressTask = nil end
            showInputDialog("设置速度倍率", tostring(speeds), function(newSpeed)
                speeds = newSpeed
                speed.Text = tostring(speeds)
                tanchuangxiaoxi("速度倍率已设为 " .. tostring(newSpeed), "速度设置")
            end, {
                text = "飞行模式: " .. flyMode,
                callback = function(btn)
                    showFlyModeSelection(flyMode, function(newMode)
                        flyMode = newMode
                        btn.Text = "飞行模式: " .. flyMode
                        tanchuangxiaoxi("飞行模式已切换至: " .. flyMode, "快捷设置")
                    end)
                end
            })
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
            if longPressTask then task.cancel(longPressTask); longPressTask = nil end
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

-- ==================== 清理 ====================
main.Destroying:Connect(function()
    applyThirdPerson(false)
    applyFreeCam(false)
    if miniWindow then
        miniWindow:Destroy()
        miniWindow = nil
    end
end)

updateButtonText()