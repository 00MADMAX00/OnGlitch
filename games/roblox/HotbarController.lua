-- Disable Roblox's default backpack GUI
game:GetService('StarterGui'):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

local uis         = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local cas         = game:GetService("ContextActionService")
local player      = game.Players.LocalPlayer
local char        = workspace:WaitForChild(player.Name)
local bp          = player.Backpack
local hum         = char:WaitForChild("Humanoid")
local frame       = script.Parent.Slot
local template    = frame.Template

--------------------------------------------------------------------------------
-- Load ItemConfigurations
--------------------------------------------------------------------------------
local ItemsTable = nil
pcall(function()
	local modules = ReplicatedStorage:WaitForChild("Modules", 5)
	if modules then
		local ic = modules:WaitForChild("ItemConfigurations", 5)
		if ic then
			local data = require(ic)
			if data and type(data) == "table" then
				if data.Items and type(data.Items) == "table" then
					ItemsTable = data.Items
				else
					for _, v in pairs(data) do
						if type(v) == "table" and v.ImageId then
							ItemsTable = data
							break
						end
					end
				end
			end
		end
	end
end)

local OLD_TO_NEW = {
	["Normal"]  = "Fallout",
	["Gold"]    = "Amberveil",
	["Golden"]  = "Amberveil",
	["Diamond"] = "Moonstone",
	["Ruby"]    = "Red Hollow",
	["Neon"]    = "Toxic",
	["Rainbow"] = "Rainbow",
}

local OLD_PREFIXES_SORTED = {}
for oldP in pairs(OLD_TO_NEW) do
	if oldP ~= "Normal" then
		table.insert(OLD_PREFIXES_SORTED, oldP)
	end
end
table.sort(OLD_PREFIXES_SORTED, function(a, b) return #a > #b end)

local function stripPrefix(toolName)
	for _, prefix in ipairs(OLD_PREFIXES_SORTED) do
		if toolName:sub(1, #prefix + 1) == prefix .. " " then
			return toolName:sub(#prefix + 2), prefix
		end
	end
	return toolName, "Normal"
end

local function getDisplayName(toolName)
	local baseName, oldPrefix = stripPrefix(toolName)
	local newPrefix = OLD_TO_NEW[oldPrefix or "Normal"] or "Fallout"
	return newPrefix .. " " .. baseName
end

local function lookupImageId(toolName)
	if not ItemsTable then return nil end
	if ItemsTable[toolName] and ItemsTable[toolName].ImageId then
		return ItemsTable[toolName].ImageId
	end
	local baseName = stripPrefix(toolName)
	if ItemsTable[baseName] and ItemsTable[baseName].ImageId then
		return ItemsTable[baseName].ImageId
	end
	return nil
end

--------------------------------------------------------------------------------
-- Rarity gradient colours
--------------------------------------------------------------------------------
local RARITY_GRADIENTS = {
	["Common"]    = { Color3.fromRGB(80,  80,  80),   Color3.fromRGB(40,  40,  40) },
	["Uncommon"]  = { Color3.fromRGB(60,  140, 60),   Color3.fromRGB(30,  80,  30) },
	["Rare"]      = { Color3.fromRGB(50,  100, 200),  Color3.fromRGB(25,  50,  120) },
	["Epic"]      = { Color3.fromRGB(150, 50,  200),  Color3.fromRGB(80,  20,  120) },
	["Legendary"] = { Color3.fromRGB(220, 160, 30),   Color3.fromRGB(140, 90,  10) },
	["Mythical"]  = { Color3.fromRGB(220, 40,  40),   Color3.fromRGB(130, 15,  15) },
	["Secret"]    = { Color3.fromRGB(255, 100, 200),  Color3.fromRGB(160, 40,  120) },
	["Rainbow"]   = { Color3.fromRGB(255, 80,  80),   Color3.fromRGB(80,  80,  255) },
}
local DEFAULT_GRADIENT = { Color3.fromRGB(60, 60, 60), Color3.fromRGB(30, 30, 30) }

local function getRarityForTool(toolName)
	if not ItemsTable then return nil end
	if ItemsTable[toolName] and ItemsTable[toolName].Rarity then
		return ItemsTable[toolName].Rarity
	end
	local baseName = stripPrefix(toolName)
	if ItemsTable[baseName] and ItemsTable[baseName].Rarity then
		return ItemsTable[baseName].Rarity
	end
	return nil
end

local function applyGradient(icon, toolName)
	local existing = icon:FindFirstChild("_SlotGradient")
	if existing then existing:Destroy() end

	local rarity  = getRarityForTool(toolName)
	local colors  = RARITY_GRADIENTS[rarity] or DEFAULT_GRADIENT
	local gradient = Instance.new("UIGradient")
	gradient.Name     = "_SlotGradient"
	gradient.Color    = ColorSequence.new(colors[1], colors[2])
	gradient.Rotation = 90
	gradient.Parent   = icon

	icon.BackgroundTransparency = 0
	icon.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
end

--------------------------------------------------------------------------------
-- Responsive hotbar sizing
-- Considers both screen width AND height so nothing overflows on landscape
-- mobile, Z Fold folded/unfolded, or any small viewport.
--------------------------------------------------------------------------------
local BASE_ICON_SIZE     = template.Size.X.Offset
local PADDING            = 6
local MAX_HOTBAR_WIDTH_RATIO = 0.92

local function getResponsiveIconSize(numSlots)
	local vp  = workspace.CurrentCamera.ViewportSize
	local vw, vh = vp.X, vp.Y

	-- How large can each slot be if we want all slots to fit within 92 % of width?
	local maxByWidth  = math.floor(
		(vw * MAX_HOTBAR_WIDTH_RATIO - (numSlots - 1) * PADDING) / numSlots
	)
	-- Keep icons at most 9 % of screen height (critical for landscape/Z Fold)
	local maxByHeight = math.floor(vh * 0.09)
	-- Never grow beyond the template's original design size
	local size = math.min(maxByWidth, maxByHeight, BASE_ICON_SIZE)
	return math.max(size, 24)   -- hard floor so slots are always tappable
end

--------------------------------------------------------------------------------
-- Hotbar state
--------------------------------------------------------------------------------
local equipped   = 0
local unequipped = 0.3
frame.Visible    = true

local equippedScale     = 1.15
local normalScale       = 1
local animationTime     = 0.3
local animationEasing   = Enum.EasingStyle.Back
local animationDirection = Enum.EasingDirection.Out

local selectedEmptySlot       = nil
local unequippedStrokeColor   = Color3.fromRGB(60,  60,  60)
local equippedStrokeColor     = Color3.fromRGB(180, 180, 180)

local function isSignTool(tool)
	if not tool then return false end
	if tool.Name == "Sign" then return true end
	local number = tonumber(tool.Name:match("^Sign(%d+)$"))
	return number and number <= 30
end

local inputKeys = {
	["One"]   = {txt = "1"}, ["Two"]   = {txt = "2"}, ["Three"] = {txt = "3"},
	["Four"]  = {txt = "4"}, ["Five"]  = {txt = "5"}, ["Six"]   = {txt = "6"},
	["Seven"] = {txt = "7"}, ["Eight"] = {txt = "8"}, ["Nine"]  = {txt = "9"},
}
local inputOrder = {
	inputKeys["One"], inputKeys["Two"], inputKeys["Three"], inputKeys["Four"],
	inputKeys["Five"], inputKeys["Six"], inputKeys["Seven"], inputKeys["Eight"],
	inputKeys["Nine"],
}

local function animateSlotScale(slot, targetScale, currentIconSize)
	if not slot then return end
	local info  = TweenInfo.new(animationTime, animationEasing, animationDirection)
	local tween = tweenService:Create(slot, info, {
		Size = UDim2.new(0, currentIconSize * targetScale, 0, currentIconSize * targetScale)
	})
	tween:Play()
end

local adjust  -- forward declaration
local function handleEquip(tool, slotNumber)
	if tool then
		if tool.Parent ~= char then
			hum:EquipTool(tool)
			selectedEmptySlot = nil
		else
			hum:UnequipTools()
		end
	else
		hum:UnequipTools()
		if selectedEmptySlot == slotNumber then
			selectedEmptySlot = nil
		else
			selectedEmptySlot = slotNumber
		end
	end
	adjust()
end

local function create()
	for i = 1, #inputOrder do
		local value = inputOrder[i]
		local clone  = template:Clone()
		clone.Parent   = frame
		clone.Name     = value["txt"]
		clone.Visible  = false
		clone.BackgroundTransparency = 0
		clone.BackgroundColor3       = Color3.fromRGB(255, 255, 255)

		if clone:FindFirstChild("Label") then clone.Label:Destroy() end

		local corner = clone:FindFirstChildOfClass("UICorner")
		if not corner then
			corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 8)
			corner.Parent = clone
		end

		local uiStroke = Instance.new("UIStroke")
		uiStroke.Parent          = clone
		uiStroke.Thickness        = 2
		uiStroke.ApplyStrokeMode  = Enum.ApplyStrokeMode.Border
		uiStroke.Color            = unequippedStrokeColor

		clone.Tool.MouseButton1Down:Connect(function()
			for _, val in pairs(inputKeys) do
				if val["txt"] == clone.Name then
					handleEquip(val["tool"], tonumber(clone.Name))
					break
				end
			end
		end)
	end
	template:Destroy()
end

local function start()
	for _, tool in ipairs(bp:GetChildren()) do
		if tool:IsA("Tool") and not isSignTool(tool) then
			for j = 1, #inputOrder do
				if not inputOrder[j]["tool"] then
					inputOrder[j]["tool"] = tool
					break
				end
			end
		end
	end
	create()
end

adjust = function()
	local visibleSlots = {}
	for i = 1, #inputOrder do
		local value = inputOrder[i]
		local tool  = value["tool"]
		local icon  = frame:FindFirstChild(value["txt"])
		if not icon then continue end
		if tool then
			icon.Visible = true
			table.insert(visibleSlots, {icon = icon, tool = tool})
		else
			icon.Visible = false
		end
	end

	local numSlots = #visibleSlots
	if numSlots == 0 then
		frame.Visible = false
		return
	end
	frame.Visible = true

	local currentIconSize = getResponsiveIconSize(numSlots)
	local totalWidth      = numSlots * currentIconSize + (numSlots - 1) * PADDING
	local startX          = -totalWidth / 2 + currentIconSize / 2

	for i, entry in ipairs(visibleSlots) do
		local icon = entry.icon
		local tool = entry.tool

		local imageToUse = tool.TextureId or ""
		local lookedUp   = lookupImageId(tool.Name)
		if lookedUp then imageToUse = lookedUp end
		icon.Tool.Image = imageToUse

		if icon:FindFirstChild("ToolName") then
			icon.ToolName.Text    = getDisplayName(tool.Name)
			icon.ToolName.Visible = (imageToUse == "")
		end

		applyGradient(icon, tool.Name)

		local stroke = icon:FindFirstChildOfClass("UIStroke")
		if tool.Parent == char then
			icon.ImageTransparency = equipped
			if stroke then stroke.Color = equippedStrokeColor;  stroke.Thickness = 3 end
			animateSlotScale(icon, equippedScale, currentIconSize)
		else
			icon.ImageTransparency = unequipped
			if stroke then stroke.Color = unequippedStrokeColor; stroke.Thickness = 2 end
			animateSlotScale(icon, normalScale, currentIconSize)
		end

		icon.Size        = UDim2.new(0, currentIconSize, 0, currentIconSize)
		icon.Position    = UDim2.new(0.5, startX + (i - 1) * (currentIconSize + PADDING), 1, -(currentIconSize - 39))
		icon.AnchorPoint = Vector2.new(0.5, 0.5)
	end
end

--------------------------------------------------------------------------------
-- Custom Backpack Panel
-- Opens when player presses ` (Backquote) or taps the mobile bag button.
-- Shows every item in bp + char, allows equip/unequip.
-- The default Roblox backpack GUI stays disabled at all times.
--------------------------------------------------------------------------------
local backpackOpen  = false
local backpackRoot  = nil   -- the overlay Frame

-- Derive the ScreenGui so we can parent new UI to it
local function getScreenGui()
	local node = script.Parent
	while node and not node:IsA("ScreenGui") do
		node = node.Parent
	end
	return node or script.Parent
end

-- Calculate a good icon size for the backpack grid
local function getBpIconSize()
	local vp  = workspace.CurrentCamera.ViewportSize
	local vw  = vp.X
	-- Aim for the panel to fill ~88 % of screen width, with 8-px gaps
	local panelW  = math.min(vw * 0.88, 560)
	local cols    = math.max(3, math.floor(panelW / 110))
	local gap     = 8
	local size    = math.floor((panelW - (cols + 1) * gap) / cols)
	return math.clamp(size, 44, 96), cols, panelW
end

local function buildBackpackPanel()
	local sg         = getScreenGui()
	local vp         = workspace.CurrentCamera.ViewportSize
	local vw, vh     = vp.X, vp.Y
	local iconSz, cols, panelW = getBpIconSize()
	local panelH     = math.min(vh * 0.72, 520)

	-- Semi-transparent full-screen overlay (captures clicks outside panel)
	local overlay = Instance.new("Frame")
	overlay.Name                 = "BpOverlay"
	overlay.Size                 = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundColor3     = Color3.fromRGB(0, 0, 0)
	overlay.BackgroundTransparency = 0.45
	overlay.ZIndex               = 20
	overlay.Parent               = sg

	-- Centred panel
	local panel = Instance.new("Frame")
	panel.Name                 = "BpPanel"
	panel.Size                 = UDim2.new(0, panelW, 0, panelH)
	panel.Position             = UDim2.new(0.5, -panelW / 2, 0.5, -panelH / 2)
	panel.BackgroundColor3     = Color3.fromRGB(18, 18, 28)
	panel.BackgroundTransparency = 0
	panel.BorderSizePixel      = 0
	panel.ZIndex               = 21
	panel.Parent               = sg
	Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)
	local panelStroke = Instance.new("UIStroke", panel)
	panelStroke.Color     = Color3.fromRGB(80, 80, 130)
	panelStroke.Thickness = 2

	-- Title bar
	local titleH  = 44
	local titleBar = Instance.new("Frame")
	titleBar.Size              = UDim2.new(1, 0, 0, titleH)
	titleBar.BackgroundColor3  = Color3.fromRGB(28, 28, 46)
	titleBar.BorderSizePixel   = 0
	titleBar.ZIndex            = 22
	titleBar.Parent            = panel
	-- Rounded top, flat bottom
	local tc = Instance.new("UICorner", titleBar)
	tc.CornerRadius = UDim.new(0, 14)
	local titleFix = Instance.new("Frame", titleBar)   -- covers bottom-rounded corners
	titleFix.Size              = UDim2.new(1, 0, 0, 14)
	titleFix.Position          = UDim2.new(0, 0, 1, -14)
	titleFix.BackgroundColor3  = Color3.fromRGB(28, 28, 46)
	titleFix.BorderSizePixel   = 0
	titleFix.ZIndex            = 22

	local titleLbl = Instance.new("TextLabel", titleBar)
	titleLbl.Size              = UDim2.new(1, -50, 1, 0)
	titleLbl.Position          = UDim2.new(0, 14, 0, 0)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text              = "Backpack"
	titleLbl.TextColor3        = Color3.fromRGB(210, 210, 255)
	titleLbl.TextSize          = 18
	titleLbl.Font              = Enum.Font.GothamBold
	titleLbl.TextXAlignment    = Enum.TextXAlignment.Left
	titleLbl.ZIndex            = 23

	local closeBtn = Instance.new("TextButton", titleBar)
	closeBtn.Size              = UDim2.new(0, 30, 0, 30)
	closeBtn.Position          = UDim2.new(1, -38, 0.5, -15)
	closeBtn.BackgroundColor3  = Color3.fromRGB(180, 50, 50)
	closeBtn.Text              = "✕"
	closeBtn.TextColor3        = Color3.fromRGB(255, 255, 255)
	closeBtn.TextSize          = 14
	closeBtn.Font              = Enum.Font.GothamBold
	closeBtn.ZIndex            = 23
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

	-- Scrollable grid
	local scroll = Instance.new("ScrollingFrame", panel)
	scroll.Name                  = "BpScroll"
	scroll.Size                  = UDim2.new(1, -16, 1, -(titleH + 10))
	scroll.Position              = UDim2.new(0, 8, 0, titleH + 6)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel        = 0
	scroll.ScrollBarThickness     = 5
	scroll.ScrollBarImageColor3   = Color3.fromRGB(100, 100, 180)
	scroll.CanvasSize             = UDim2.new(0, 0, 0, 0)
	scroll.AutomaticCanvasSize    = Enum.AutomaticSize.Y
	scroll.ZIndex                 = 22

	local grid = Instance.new("UIGridLayout", scroll)
	grid.CellSize    = UDim2.new(0, iconSz, 0, iconSz)
	grid.CellPadding = UDim2.new(0, 8, 0, 8)
	grid.SortOrder   = Enum.SortOrder.LayoutOrder

	local pad = Instance.new("UIPadding", scroll)
	pad.PaddingLeft   = UDim.new(0, 8)
	pad.PaddingTop    = UDim.new(0, 8)
	pad.PaddingRight  = UDim.new(0, 8)
	pad.PaddingBottom = UDim.new(0, 8)

	-- Prevent overlay clicks from registering when the user clicks inside the panel
	panel.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1
			or inp.UserInputType == Enum.UserInputType.Touch then
			inp:Handled = true
		end
	end)

	-- Clicking the overlay (outside the panel) closes backpack
	overlay.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1
			or inp.UserInputType == Enum.UserInputType.Touch then
			if not inp.Handled then
				closeBackpack()
			end
		end
	end)
	closeBtn.MouseButton1Down:Connect(function() closeBackpack() end)

	-- Populate items helper (called on open and after equip/unequip)
	local function populate()
		for _, child in ipairs(scroll:GetChildren()) do
			if child:IsA("ImageButton") then child:Destroy() end
		end

		-- Collect all tools: backpack + currently equipped
		local allTools = {}
		for _, t in ipairs(bp:GetChildren()) do
			if t:IsA("Tool") and not isSignTool(t) then table.insert(allTools, t) end
		end
		for _, t in ipairs(char:GetChildren()) do
			if t:IsA("Tool") and not isSignTool(t) then table.insert(allTools, t) end
		end

		for _, tool in ipairs(allTools) do
			local btn = Instance.new("ImageButton")
			btn.Size                 = UDim2.new(0, iconSz, 0, iconSz)
			btn.BackgroundColor3     = Color3.fromRGB(255, 255, 255)
			btn.BackgroundTransparency = 0
			btn.ZIndex               = 23
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

			-- Image
			local img = tool.TextureId or ""
			local lu  = lookupImageId(tool.Name)
			if lu then img = lu end
			btn.Image = img

			-- Rarity gradient background
			local rarity = getRarityForTool(tool.Name)
			local gColors = RARITY_GRADIENTS[rarity] or DEFAULT_GRADIENT
			local g = Instance.new("UIGradient", btn)
			g.Color    = ColorSequence.new(gColors[1], gColors[2])
			g.Rotation = 90

			-- Stroke (brighter when equipped)
			local sk = Instance.new("UIStroke", btn)
			sk.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			if tool.Parent == char then
				sk.Color     = equippedStrokeColor
				sk.Thickness = 3
			else
				sk.Color     = unequippedStrokeColor
				sk.Thickness = 2
			end

			-- Item name label at bottom of icon
			local lbl = Instance.new("TextLabel", btn)
			lbl.Size                 = UDim2.new(1, 0, 0, math.max(14, math.floor(iconSz * 0.2)))
			lbl.Position             = UDim2.new(0, 0, 1, -math.max(14, math.floor(iconSz * 0.2)))
			lbl.BackgroundColor3     = Color3.fromRGB(0, 0, 0)
			lbl.BackgroundTransparency = 0.35
			lbl.TextColor3           = Color3.fromRGB(255, 255, 255)
			lbl.Text                 = getDisplayName(tool.Name)
			lbl.TextScaled           = true
			lbl.Font                 = Enum.Font.GothamBold
			lbl.ZIndex               = 24
			Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 4)

			-- Equip / unequip on tap
			btn.MouseButton1Down:Connect(function()
				if tool.Parent == char then
					hum:UnequipTools()
				else
					hum:EquipTool(tool)
				end
				adjust()
				task.wait(0.05)
				populate()  -- refresh equipped highlights
			end)

			btn.Parent = scroll
		end
	end

	populate()
	backpackRoot = overlay
end

function closeBackpack()
	if not backpackOpen then return end
	backpackOpen = false
	if backpackRoot then
		backpackRoot:Destroy()
		backpackRoot = nil
	end
	-- Show hotbar again when backpack closes
	frame.Visible = true
end

local function openBackpack()
	if backpackOpen then return end
	backpackOpen = true
	buildBackpackPanel()
end

local function toggleBackpack()
	if backpackOpen then closeBackpack() else openBackpack() end
end

-- Bind the backpack toggle to Backquote (` key, same slot as default Roblox)
-- ContextActionService also adds a mobile on-screen button automatically.
local BACKPACK_ACTION = "ToggleCustomBackpack"
cas:BindActionAtPriority(
	BACKPACK_ACTION,
	function(_, inputState)
		if inputState == Enum.UserInputState.Begin then
			toggleBackpack()
		end
		return Enum.ContextActionResult.Sink  -- prevent other handlers seeing this
	end,
	true,   -- createTouchButton – shows a bag icon on mobile
	Enum.ContextActionPriority.High.Value,
	Enum.KeyCode.Backquote,
	Enum.KeyCode.BackSlash  -- fallback for some keyboard layouts
)

-- Style the mobile touch button
task.defer(function()
	cas:SetTitle(BACKPACK_ACTION, "Bag")
	cas:SetImage(BACKPACK_ACTION, "rbxasset://textures/ui/TopBar/inventoryOn.png")
end)

--------------------------------------------------------------------------------
-- Keyboard hotbar shortcuts (1-9)
--------------------------------------------------------------------------------
local function onKeyPress(inputObject)
	if uis:GetFocusedTextBox() then return end
	local value = inputKeys[inputObject.KeyCode.Name]
	if value then
		handleEquip(value["tool"], tonumber(value["txt"]))
	end
end

--------------------------------------------------------------------------------
-- Backpack / char item tracking
--------------------------------------------------------------------------------
local function handleAddition(adding)
	if adding:IsA("Tool") and not isSignTool(adding) then
		local new = true
		for _, value in pairs(inputKeys) do
			if value["tool"] == adding then new = false; break end
		end
		if new then
			for i = 1, #inputOrder do
				if not inputOrder[i]["tool"] then
					inputOrder[i]["tool"] = adding
					break
				end
			end
		end
		adjust()
	end
end

local function handleRemoval(removing)
	if removing:IsA("Tool") then
		if removing.Parent ~= char and removing.Parent ~= bp then
			for i = 1, #inputOrder do
				if inputOrder[i]["tool"] == removing then
					inputOrder[i]["tool"] = nil
					break
				end
			end
		end
		adjust()
	end
end

--------------------------------------------------------------------------------
-- Viewport-resize: re-layout hotbar
--------------------------------------------------------------------------------
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
	adjust()
end)

--------------------------------------------------------------------------------
-- Wire everything up
--------------------------------------------------------------------------------
uis.InputBegan:Connect(onKeyPress)
char.ChildAdded:Connect(handleAddition)
char.ChildRemoved:Connect(handleRemoval)
bp.ChildAdded:Connect(handleAddition)
bp.ChildRemoved:Connect(handleRemoval)

start()
adjust()
