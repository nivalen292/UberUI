--get the addon namespace
local addon, ns = ...
uui_Auras = {}

local uui_Auras = CreateFrame("frame")
uui_Auras:RegisterEvent("ADDON_LOADED")
uui_Auras:SetScript("OnEvent", function(self,event)
	initlocals()
	uui_Auras_ReworkAllColors()
end)

local function initlocals()
	--backdrop
	local backdrop = {
		bgFile = nil,
		edgeFile = "Interface\\AddOns\\Uber UI\\textures\\outer_shadow",
		tile = false,
		tileSize = 32,
		edgeSize = 4,
		insets = {
			left = 4,
			right = 4,
			top = 4,
			bottom = 4,
		},
	}
end

 ---------------------------------------
  -- FUNCTIONS
 ---------------------------------------

--apply aura frame texture func
local function applySkin(b, color)
	if not b or (b and b.styled) then return end
	--button name
	local name = b:GetName()
	if (name:match("Debuff")) then
		b.debuff = true
	else
		b.buff = true
	end
	--icon
	local icon = _G[name.."Icon"]
	icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	icon:SetDrawLayer("BACKGROUND",-8)
	b.icon = icon
	--border
	local border = _G[name.."Border"] or b:CreateTexture(name.."Border", "BACKGROUND", nil, -7)
	border:SetTexture("Interface\\AddOns\\Uber UI\\textures\\gloss")
	border:SetTexCoord(0, 1, 0, 1)
	border:SetDrawLayer("BACKGROUND",- 7)
	if b.buff then
		if (UnitIsConnected(border.unit)) and uuidb.targetframe.colortargett then
			uui_General_ClassColored(border, border.unit)
		else
			border:SetVertexColor(color.r, color.g, color.b, color.a)
		end
	end
	border:ClearAllPoints()
	border:SetPoint("TOPLEFT", b, "TOPLEFT", -1, 1)
	border:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 1, -1)
	b.border = border
	--shadow
	local back = CreateFrame("Frame", nil, b)
	back:SetPoint("TOPLEFT", b, "TOPLEFT", -4, 4)
	back:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 4, -4)
	back:SetFrameLevel(b:GetFrameLevel() - 1)
	back:SetBackdrop(backdrop)
	back:SetBackdropBorderColor(0, 0, 0, 0.9)
	b.bg = back
	--set button styled variable
	b.styled = true
end

--apply castbar texture

local function applycastSkin(b, color)
	if not b or (b and b.styled) then return end
	-- parent
	if b == TargetFrameSpellBar.Icon then
		b.parent = TargetFrameSpellBar
	else
		b.parent = FocusFrameSpellBar
	end

	-- frame
	frame = CreateFrame("Frame", nil, b.parent)
	--icon
	b:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	--border
	local border = frame:CreateTexture(nil, "BACKGROUND")
	border:SetTexture("Interface\\AddOns\\Uber UI\\textures\\gloss")
	border:SetTexCoord(0, 1, 0, 1)
	border:SetDrawLayer("BACKGROUND",- 7)
	border:ClearAllPoints()
	border:SetPoint("TOPLEFT", b, "TOPLEFT", -1, 1)
	border:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 1, -1)
	--border color
	if (UnitIsConnected(border.unit)) and uuidb.targetframe.colortargett then
		uui_General_ClassColored(border, border.unit)
	else
		border:SetVertexColor(color.r, color.g, color.b, color.a)
	end
	b.border = border
	--shadow
	local back = CreateFrame("Frame", nil, b.parent)
	back:SetPoint("TOPLEFT", b, "TOPLEFT", -4, 4)
	back:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 4, -4)
	back:SetFrameLevel(frame:GetFrameLevel() - 1)
	back:SetBackdrop(backdrop)
	back:SetBackdropBorderColor(0, 0, 0, 0.9)
	b.bg = back
	--set button styled variable
	b.styled = true
end

total = 0
uui_Auras_Timer = CreateFrame("frame")
uui_Auras_Timer:SetScript("OnEvent", UpdateTimer)
-- setting timer for castbar icons
function UpdateTimer(self, elapsed)
	total = total + elapsed
	if TargetFrameSpellBar.Icon then 
		applycastSkin(TargetFrameSpellBar.Icon)
	end
	if FocusFrameSpellBar.Icon then
		applycastSkin(FocusFrameSpellBar.Icon)
	end
	if TargetFrameSpellBar.Icon.styled and FocusFrameSpellBar.Icon.styled then
		uui_Auras_Timer:SetScript("OnUpdate", nil)
	end
end

function uui_Auras_ReworkAllColors(color)
	if not (color) then
		color = uuidb.auras.color
	end
	hooksecurefunc("TargetFrame_UpdateAuras", function(self)
		for i = 1, MAX_TARGET_BUFFS do
			b = _G["TargetFrameBuff"..i]
			applySkin(b, color)
		end
		for i = 1, MAX_TARGET_DEBUFFS do
			b = _G["TargetFrameDebuff"..i]
			applySkin(b, color)
		end
		for i = 1, MAX_TARGET_BUFFS do
			b = _G["FocusFrameBuff"..i]
			applySkin(b, color)
		end
		for i = 1, MAX_TARGET_DEBUFFS do
			b = _G["FocusFrameDebuff"..i]
			applySkin(b, color)
		end
	end)
end