--// UNIFIED MOD MENU - ESP SKELETON + HEAD + AIMLOCK + AUTOSHOT
--// Shift Direito abre o menu
--// Todos os mods originais preservados

local UIS = game:GetService("UserInputService")
local PS = game:GetService("Players")
local RS = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LP = PS.LocalPlayer
local Mouse = LP:GetMouse()

--// ESTADOS DO MODMENU
local modStates = {
    Skeleton = false,
    HeadESP = false,
    Aimlock = false,
    Autoshot = false
}

--// BINDS ORIGINAIS
local binds = {
    Aimlock = Enum.KeyCode.LeftAlt,
    Autoshot = Enum.KeyCode.X
}

--// UI PROFISSIONAL
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModMenuUI"
ScreenGui.Parent = game:GetService("CoreGui")

--// JANELA PRINCIPAL
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 240, 0, 195)
Frame.Position = UDim2.new(0.5, -120, 0.5, -90)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Visible = false
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

--// SOMBRA
local Shadow = Instance.new("ImageLabel")
Shadow.Size = UDim2.new(1, 20, 1, 20)
Shadow.Position = UDim2.new(0, -10, 0, -10)
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageColor3 = Color3.new(0, 0, 0)
Shadow.ImageTransparency = 0.7
Shadow.BackgroundTransparency = 1
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
Shadow.Parent = Frame

--// TÍTULO
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "MOD MENU v1.0             by корн штф"
Title.TextColor3 = Color3.fromRGB(0, 255, 170)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Frame

--// CONTAINER DOS TOGGLES
local ToggleContainer = Instance.new("Frame")
ToggleContainer.Size = UDim2.new(1, -20, 1, -45)
ToggleContainer.Position = UDim2.new(0, 10, 0, 35)
ToggleContainer.BackgroundTransparency = 1
ToggleContainer.Parent = Frame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ToggleContainer

--// FUNÇÃO SWITCH ANIMADO
local function createToggle(name, bind)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 30)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.LayoutOrder = 1
    toggleFrame.Parent = ToggleContainer

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name .. (bind and " (" .. bind.Name .. ")" or "")
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame

    --// SWITCH
    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 50, 0, 24)
    switch.Position = UDim2.new(1, -50, 0.5, -12)
    switch.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    switch.BorderSizePixel = 0
    switch.Text = ""
    switch.AutoButtonColor = false
    switch.Parent = toggleFrame

    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(0, 12)
    switchCorner.Parent = switch

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = UDim2.new(0, 2, 0.5, -10)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    knob.Parent = switch

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0, 10)
    knobCorner.Parent = knob

    switch.MouseButton1Click:Connect(function()
        modStates[name] = not modStates[name]
        local enabled = modStates[name]
        switch.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 170) or Color3.fromRGB(60, 60, 60)
        knob:TweenPosition(
            enabled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.15,
            true
        )
        updateActiveList()
    end)
end

createToggle("Skeleton", nil)
createToggle("HeadESP", nil)
createToggle("Aimlock", binds.Aimlock)
createToggle("Autoshot", binds.Autoshot)

--// LISTA LATERAL DIREITA (compacta)
local activeList = Instance.new("Frame")
activeList.Size = UDim2.new(0, 110, 0, 110)
activeList.Position = UDim2.new(1, -125, 0.5, -55)
activeList.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
activeList.BorderSizePixel = 0
activeList.BackgroundTransparency = 0.4
activeList.Visible = false
activeList.Parent = ScreenGui

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 8)
listCorner.Parent = activeList

local listLabel = Instance.new("TextLabel")
listLabel.Size = UDim2.new(1, -20, 1, -20)
listLabel.Position = UDim2.new(0, 5, 0, 5)
listLabel.BackgroundTransparency = 1
listLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
listLabel.Font = Enum.Font.SourceSansBold
listLabel.TextSize = 13
listLabel.TextWrapped = true
listLabel.TextYAlignment = Enum.TextYAlignment.Top
listLabel.Parent = activeList

local function updateActiveList()
    local t = {}
    for name, state in pairs(modStates) do
        if state then
            table.insert(t, name:upper())
        end
    end
    listLabel.Text = table.concat(t, "\n")
    activeList.Visible = #t > 0
end

--// LISTA LATERAL DIREITA – fixada verticalmente no centro, colada à borda direita
local activeList = Instance.new("Frame")
activeList.Name = "ActiveList"
activeList.Size = UDim2.new(0, 120, 0, 120)
activeList.AnchorPoint = Vector2.new(1, 0.5)
activeList.Position = UDim2.new(1, 0, 0.5, 0)
activeList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
activeList.BackgroundTransparency = 0.3
activeList.BorderSizePixel = 0
activeList.Visible = false
activeList.Parent = ScreenGui

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 10)
listCorner.Parent = activeList

local listLabel = Instance.new("TextLabel")
listLabel.Name = "ListLabel"
listLabel.Size = UDim2.new(1, -10, 1, -10) -- padding interno de 5 px
listLabel.Position = UDim2.new(0, 5, 0, 5)
listLabel.BackgroundTransparency = 1
listLabel.TextColor3 = Color3.new(1, 1, 1)
listLabel.Font = Enum.Font.SourceSansBold
listLabel.TextSize = 14
listLabel.TextWrapped = true
listLabel.TextYAlignment = Enum.TextYAlignment.Top
listLabel.Parent = activeList

local function updateActiveList()
    local t = {}
    for name, state in pairs(modStates) do
        if state then
            table.insert(t, name:upper())
        end
    end
    if #t == 0 then
        listLabel.Text = ""
        activeList.Visible = false
    else
        listLabel.Text = table.concat(t, "\n")
        activeList.Visible = true
    end
end

--// TOGGLE MENU
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        Frame.Visible = not Frame.Visible
    end
end)

--// ESP SKELETON
local cache = {}
local bonesDef = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"}
}

local function get(part)
    return part and part.Position
end

local function newBone()
    local l = Drawing.new("Line")
    l.Thickness = 2
    l.Color = Color3.new(1,0,0)
    l.ZIndex = 1
    return l
end

local function clearBones(p)
    if cache[p] then
        for _,l in ipairs(cache[p]) do l:Remove() end
        cache[p]=nil
    end
end

local function buildBones(p)
    clearBones(p)
    if not p.Character then return end
    cache[p]={}
    for _ in ipairs(bonesDef) do
        table.insert(cache[p],newBone())
    end
end

--// ESP HEAD
local dots = {}
local function head(plr)
    return plr.Character and plr.Character:FindFirstChild("Head")
end

local function newDot()
    local d = Drawing.new("Circle")
    d.Color = Color3.new(1,1,1)
    d.Radius = 4
    d.Filled = false
    d.Thickness = 1
    d.ZIndex = 1
    return d
end

local function clearDot(p)
    if dots[p] then
        dots[p]:Remove()
        dots[p] = nil
    end
end

local function buildDot(p)
    clearDot(p)
    if p ~= LP then
        dots[p] = newDot()
    end
end

--// AIMLOCK
local aimlockON = false
local TARGET = nil
local FOV = 120
local FOV_STEP = 10
local FOV_CIRCLE = Drawing.new("Circle")
FOV_CIRCLE.Color = Color3.new(1,1,1)
FOV_CIRCLE.Thickness = 1
FOV_CIRCLE.NumSides = 32
FOV_CIRCLE.Visible = false
FOV_CIRCLE.Radius = FOV
FOV_CIRCLE.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
FOV_CIRCLE.Filled = false

--// AUTOSHOT
local autoshotActive = false
local autoshotFOV = 120
local autoshotSTEP = 10
local autoshotCircle = Drawing.new("Circle")
autoshotCircle.Color = Color3.fromRGB(150,150,150)
autoshotCircle.Thickness = 1
autoshotCircle.NumSides = 32
autoshotCircle.Radius = autoshotFOV
autoshotCircle.Filled = false
autoshotCircle.Visible = false
autoshotCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

local function visible(part)
    local origin = Camera.CFrame.Position
    local dir = (part.Position - origin).Unit * 500
    local hit = workspace:FindPartOnRayWithIgnoreList(Ray.new(origin, dir), {Camera, LP.Character})
    return hit and hit:IsDescendantOf(part.Parent)
end

local function shoot()
    mouse1press()
    mouse1release()
end

--// INPUT HANDLERS
UIS.InputBegan:Connect(function(i,g)
    if g then return end
    if i.KeyCode == binds.Aimlock and modStates.Aimlock then
        aimlockON = not aimlockON
        FOV_CIRCLE.Visible = aimlockON
        if not aimlockON then TARGET = nil end
    elseif i.KeyCode == Enum.KeyCode.Up and modStates.Aimlock then
        FOV = math.min(FOV + FOV_STEP, 600)
        FOV_CIRCLE.Radius = FOV
    elseif i.KeyCode == Enum.KeyCode.Down and modStates.Aimlock then
        FOV = math.max(FOV - FOV_STEP, 20)
        FOV_CIRCLE.Radius = FOV
    elseif i.KeyCode == binds.Autoshot and modStates.Autoshot then
        autoshotActive = not autoshotActive
        autoshotCircle.Visible = autoshotActive
    elseif i.KeyCode == Enum.KeyCode.Minus and modStates.Autoshot then
        autoshotFOV = math.max(autoshotFOV - autoshotSTEP, 10)
        autoshotCircle.Radius = autoshotFOV
    elseif i.KeyCode == Enum.KeyCode.Equals and modStates.Autoshot then
        autoshotFOV = math.min(autoshotFOV + autoshotSTEP, 600)
        autoshotCircle.Radius = autoshotFOV
    end
end)

--// RENDER LOOP
RS.RenderStepped:Connect(function()
    -- Skeleton
    if modStates.Skeleton then
        for pl,bones in pairs(cache) do
            local char=pl.Character
            local idx=1
            for _,pair in ipairs(bonesDef) do
                local bone=bones[idx]
                local p1=get(char and char:FindFirstChild(pair[1]))
                local p2=get(char and char:FindFirstChild(pair[2]))
                if p1 and p2 then
                    local v1,on1=Camera:WorldToViewportPoint(p1)
                    local v2,on2=Camera:WorldToViewportPoint(p2)
                    bone.From=Vector2.new(v1.X,v1.Y)
                    bone.To=Vector2.new(v2.X,v2.Y)
                    bone.Visible=(on1 or on2)
                else
                    bone.Visible=false
                end
                idx+=1
            end
        end
    else
        for _,bones in pairs(cache) do
            for _,b in ipairs(bones) do b.Visible=false end
        end
    end

    -- Head ESP
    if modStates.HeadESP then
        for pl, dot in pairs(dots) do
            local h = head(pl)
            if h then
                local screen, onScreen = Camera:WorldToViewportPoint(h.Position)
                dot.Visible = onScreen
                dot.Position = Vector2.new(screen.X, screen.Y)
            else
                dot.Visible = false
            end
        end
    else
        for _,d in pairs(dots) do d.Visible=false end
    end

    -- Aimlock
    if modStates.Aimlock then
        FOV_CIRCLE.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        if aimlockON then
            if not TARGET or not head(TARGET) then
                local near, bestDist = nil, math.huge
                local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                for _,p in ipairs(PS:GetPlayers()) do
                    if p == LP then continue end
                    local h = head(p)
                    if h then
                        local screen = Camera:WorldToViewportPoint(h.Position)
                        local dist2D = (Vector2.new(screen.X, screen.Y) - center).Magnitude
                        if dist2D <= FOV and dist2D < bestDist then
                            near, bestDist = p, dist2D
                        end
                    end
                end
                TARGET = near
            end
            local h = head(TARGET)
            if h then
                local pos = Camera:WorldToScreenPoint(h.Position)
                mousemoverel(pos.X - Mouse.X, pos.Y - Mouse.Y)
            end
        end
    else
        FOV_CIRCLE.Visible = false
    end

    -- Autoshot
    if modStates.Autoshot then
        autoshotCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        if autoshotActive then
            local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
            local closestHead, bestDist
            for _,p in ipairs(PS:GetPlayers()) do
                if p == LP then continue end
                local h = head(p)
                if h then
                    local scr = Camera:WorldToViewportPoint(h.Position)
                    local d = (Vector2.new(scr.X, scr.Y) - center).Magnitude
                    if d <= autoshotFOV and (not bestDist or d < bestDist) then
                        closestHead, bestDist = h, d
                    end
                end
            end
            if closestHead and visible(closestHead) then
                shoot()
            end
        end
    else
        autoshotCircle.Visible = false
    end
end)

--// PLAYER HOOKS
PS.PlayerAdded:Connect(function(p)
    if modStates.Skeleton then buildBones(p) end
    if modStates.HeadESP then buildDot(p) end
end)

PS.PlayerRemoving:Connect(function(p)
    clearBones(p)
    clearDot(p)
end)

LP.CharacterAdded:Connect(function()
    wait(.3)
    for _,p in ipairs(PS:GetPlayers()) do
        if p ~= LP then
            if modStates.Skeleton then buildBones(p) end
            if modStates.HeadESP then buildDot(p) end
        end
    end
end)

--// INICIALIZAÇÃO
for _,p in ipairs(PS:GetPlayers()) do
    if p ~= LP then
        buildBones(p)
        buildDot(p)
    end
end

updateActiveList()


