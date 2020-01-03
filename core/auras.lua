--get the addon namespace
local addon, ns = ...
auras = {}

local auras = CreateFrame("frame")
auras:RegisterEvent("ADDON_LOADED")
auras:SetScript("OnEvent", function(self,event)
	--backdrop
end)

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

 ---------------------------------------
  -- FUNCTIONS
 ---------------------------------------

--apply aura frame texture func
local function applySkin(b, color)
	if not b then return end
	--button name
	local u = b.unit
	local name = b:GetName()
	if (name:match("Debuff")) then
		b.debuff = true
	else
		b.buff = true
	end

	local colors = color
	if uuidb.targetframe.colortargett then
		if UnitIsConnected(u) and UnitIsPlayer(u) then
			colors = RAID_CLASS_COLORS[select(2, UnitClass(u))]
		else
			local red,green,_ = UnitSelectionColor(u)
			if (red == 0) then
        	    colors = { r = 0, g = 1, b = 0}
        	elseif (green == 0) then
        	    colors = { r = 1, g = 0, b = 0}
        	else
        	    colors = { r = 1, g = 1, b = 0}
        	end
		end
	elseif uuidb.general.customcolor or uuidb.general.classcolorframesor then
		colors = uuidb.general.customcolorval
	else
		colors = uuidb.auras.color
	end

	if b and b.styled then
		b.bg:SetBackdropBorderColor(colors.r, colors.g, colors.b, colors.a)
	end

	if not b or (b and b.styled) then return end
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
	back:SetBackdropBorderColor(colors.r, colors.g, colors.b, colors.a)
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
	--if (UnitIsConnected(border.unit)) and uuidb.targetframe.colortargett then
	--	UberUI.general:ClassColored(border, border.unit)
	--else
	--end
	b.border = border
	--shadow
	local back = CreateFrame("Frame", nil, b.parent)
	back:SetPoint("TOPLEFT", b, "TOPLEFT", -4, 4)
	back:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 4, -4)
	back:SetFrameLevel(frame:GetFrameLevel() - 1)
	back:SetBackdrop(backdrop)
	back:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
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

function auras:ReworkAllColors(color)
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

UberUI.auras = auras