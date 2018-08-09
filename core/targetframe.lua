local addon, ns = ...
local uui_TargetFrame

--[[
	Local Variables
]]--
local class = UnitClass("player")
local classcolor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]


local uui_TargetFrame = CreateFrame("frame")
uui_TargetFrame:RegisterEvent("ADDON_LOADED")
uui_TargetFrame:SetScript("OnEvent", function(self, event)
	if not (IsAddOnLoaded("EasyFrames")) then
		if uuidb.targetframe.largehealth then
			hooksecurefunc("TargetFrame_CheckClassification", uui_TargetFrameStyleTargetFrame)
		end
	end
end)

function uui_TargetFrameStyleTargetFrame(self, forceNormalTexture)
	if uuidb.targetframe.largehealth then
		local frametexture = uuidb.textures.targetframebig
		self.deadText:ClearAllPoints()
		self.deadText:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0)
		self.levelText:SetPoint("RIGHT", self.healthbar, "BOTTOMRIGHT", 63, 10)
		self.nameBackground:Hide()
		self.Background:SetSize(119, 42)
		self.manabar.pauseUpdates = false
		self.manabar:Show()
		self.name:Hide()
		TargetFrame:SetScale(uuidb.targetframe.scale)
		TextStatusBar_UpdateTextString(self.manabar)
		self.threatIndicator:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Flash")
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

		--target frame options
		--show/hide name
		if uuidb.targetframe.name then
			self.name:ClearAllPoints()
			self.name:SetPoint("LEFT", self, 15, 36)
		end


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
	else
		local frametexture = uuidb.textures.targetframe
	end

	-- get color in use
	if uuidb.general.customcolor then
		color = uuidb.general.customcolorval
	else
		color = uuidb.targetframe.color
	end

	-- style frames accordingly
	local classification = UnitClassification(self.unit)
	if ( classification == "minus" ) then
		self.borderTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Minus");
		self.borderTexture:SetVertexColor(color.r, color.g, color.b, color.a)
		self.nameBackground:Hide();
		self.manabar.pauseUpdates = true;
		self.manabar:Hide();
		self.manabar.TextString:Hide();
		self.manabar.LeftText:Hide();
		self.manabar.RightText:Hide();
		forceNormalTexture = true;
	elseif ( classification == "worldboss" or classification == "elite" ) then
		self.borderTexture:SetTexture(frametexture.elite)
		self.borderTexture:SetVertexColor(color.r, color.g, color.b, color.a)
	elseif ( classification == "rareelite" ) then
		self.borderTexture:SetTexture(frametexture.rareelite)
		self.borderTexture:SetVertexColor(color.r, color.g, color.b, color.a)
	elseif ( classification == "rare" ) then
		self.borderTexture:SetTexture(frametexture.rare)
		self.borderTexture:SetVertexColor(color.r, color.g, color.b, color.a)
	else
		self.borderTexture:SetTexture(frametexture.targetingframe)
		self.borderTexture:SetVertexColor(color.r, color.g, color.b, color.a)
	end
end

function uui_TargetFrame_Frames(color)
	for _,v in pairs({
		TargetFrameToTTextureFrameTexture,
		Boss1TargetFrameTextureFrameTexture,
		Boss2TargetFrameTextureFrameTexture,
		Boss3TargetFrameTextureFrameTexture,
		Boss4TargetFrameTextureFrameTexture,
		Boss5TargetFrameTextureFrameTexture,
		Boss1TargetFrameSpellBar.Border,
		Boss2TargetFrameSpellBar.Border,
		Boss3TargetFrameSpellBar.Border,
		Boss4TargetFrameSpellBar.Border,
		Boss5TargetFrameSpellBar.Border,
		TargetFrameSpellBar.Border,
		FocusFrameSpellBar.Border,
		FocusFrameTextureFrameTexture, 
		FocusFrameToTTextureFrameTexture,
	}) do
		v:SetVertexColor(color.r, color.g, color.b, color.a)
	end
	TargetFrameSpellBar.Border:SetTexture("Interface\\AddOns\\Uber UI\\textures\\castingbar-small")
end

function uui_TargetFrame_ReworkAllColor(color)
	if not (IsAddOnLoaded("EasyFrames")) then
		if not (color) then
			color = uuidb.targetframe.color
		end
	
		uui_TargetFrame_Frames(color)
	
		if uuidb.targetframe.largehealth then
			hooksecurefunc("TargetFrame_CheckClassification", uui_TargetFrameStyleTargetFrame)
		end
	end
end