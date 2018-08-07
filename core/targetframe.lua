local addon, ns = ...
local uui_TargetFrame
local tar = uuidb.targetframe

--[[
	Local Variables
]]--
local class = UnitClass("player")
local classcolor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]


local uui_TargetFrame = CreateFrame("frame")
uui_TargetFrame:RegisterEvent("ADDON_LOADED")
uui_TargetFrame:SetScript("OnEvent", function(self, event)
	if not (IsAddOnLoaded("EasyFrames")) then
		if uuidb.general.largehealth then
			self:StyleTargetFrame()
		end
	end
end)

function uui_TargetFrame:StyleTargetFrame(self, forceNormalTexture)
	self.deadText:ClearAllPoints()
	self.deadText:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0)
	self.levelText:SetPoint("RIGHT", self.healthbar, "BOTTOMRIGHT", 63, 10)
	self.nameBackground:Hide()
	self.Background:SetSize(119, 42)
	self.manabar.pauseUpdates = false
	self.manabar:Show()
	TextStatusBar_UpdateTextString(self.manabar)
	self.threatIndicator:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Flash")
	self.name:SetPoint("LEFT", self, 15, 36)
	self.healthbar:SetSize(119, 29)
	self.healthbar:ClearAllPoints()
	self.healthbar:SetPoint("TOPLEFT", 5, -24)
	self.healthbar.LeftText:ClearAllPoints()
	self.healthbar.LeftText:SetPoint("LEFT", self.healthbar, "LEFT", 8, 0)
	self.healthbar.RightText:ClearAllPoints()
	self.healthbar.RightText:SetPoint("RIGHT", self.healthbar, "RIGHT", -5, 0)
	self.healthbar.TextString:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0)
	self.manabar:ClearAllPoints()
	self.manabar:SetPoint("TOPLEFT", 5, -52)
	self.manabar:SetSize(119, 13)
	self.manabar.LeftText:ClearAllPoints()
	self.manabar.LeftText:SetPoint("LEFT", self.manabar, "LEFT", 8, 0)
	self.manabar.RightText:ClearAllPoints()
	self.manabar.RightText:SetPoint("RIGHT", self.manabar, "RIGHT", -5, 0)
	self.manabar.TextString:SetPoint("CENTER", self.manabar, "CENTER", 0, 0)

	--TargetOfTarget
	TargetFrameToTHealthBar:ClearAllPoints()
	TargetFrameToTHealthBar:SetPoint("TOPLEFT", 44, -15)
	TargetFrameToTHealthBar:SetHeight(8)
	TargetFrameToTManaBar:ClearAllPoints()
	TargetFrameToTManaBar:SetPoint("TOPLEFT", 44, -24)
	TargetFrameToTManaBar:SetHeight(5)
	FocusFrameToTHealthBar:ClearAllPoints()
	FocusFrameToTHealthBar:SetPoint("TOPLEFT", 45, -15)
	FocusFrameToTHealthBar:SetHeight(8)
	FocusFrameToTManaBar:ClearAllPoints()
	FocusFrameToTManaBar:SetPoint("TOPLEFT", 45, -25)
	FocusFrameToTManaBar:SetHeight(3)
	FocusFrameToT.deadText:SetWidth(0.01)
end

function uui_TargetFrame_TargetType()
	-- get frame style
	if tar.largehealth then
		frametexture = uuidb.textures.targetframebig
	else
		frametexture = uuidb.textures.targetframe
	end

	-- get color in use
	if uuidb.general.customcolor then
		color = uuidb.general.customcolorval
	else
		color = tar.color
	end

	-- style frames accordingly
	local classification = UnitClassification(self.unit)
	if ( classification == "minus" ) then
		self.borderTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Minus");
		self.borderTexture:SetVertexColor(color)
		self.nameBackground:Hide();
		self.manabar.pauseUpdates = true;
		self.manabar:Hide();
		self.manabar.TextString:Hide();
		self.manabar.LeftText:Hide();
		self.manabar.RightText:Hide();
		forceNormalTexture = true;
	elseif ( classification == "worldboss" or classification == "elite" ) then
		self.borderTexture:SetTexture(frametexture.elite)
		self.borderTexture:SetVertexColor(color)
	elseif ( classification == "rareelite" ) then
		self.borderTexture:SetTexture(frametexture.rareelite)
		self.borderTexture:SetVertexColor(color)
	elseif ( classification == "rare" ) then
		self.borderTexture:SetTexture(frametexture.rare)
		self.borderTexture:SetVertexColor(color)
	else
		self.borderTexture:SetTexture(frametexture.targetingframe)
		self.borderTexture:SetVertexColor(color)
	end
end