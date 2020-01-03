local addon, ns = ...
local targetframes = {}

--[[
	Local Variables
]]--
local class = UnitClass("player")
local classcolor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]


local targetframes = CreateFrame("frame")
targetframes:RegisterEvent("ADDON_LOADED")
targetframes:SetScript("OnEvent", function(self, event)
	if not (IsAddOnLoaded("EasyFrames")) then
		if uuidb.targetframe.largehealth then
			hooksecurefunc("TargetFrame_CheckClassification", uui_TargetFrameStyleTargetFrame)
		end
	end
	if uuidb.targetframe.colortargett then
		self:ClassColorTargetEnable()
	end
end)

function uui_TargetFrameStyleTargetFrame(self, forceNormalTexture)
	local classification = UnitClassification(self.unit)
	if uuidb.targetframe.largehealth then
		local frametexture = uuidb.textures.targetframebig
		self.deadText:ClearAllPoints()
		self.deadText:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0)
		self.levelText:SetPoint("RIGHT", self.healthbar, "BOTTOMRIGHT", 63, 10)
		self.nameBackground:Hide()
		self.Background:SetSize(119, 42)
		self.manabar.pauseUpdates = false
		self.manabar:Show()
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

		if uuidb.miscframes.pvpicons and UnitIsPVP("target") then
			TargetFrameTextureFramePVPIcon:SetAlpha(1)
			TargetFrameTextureFramePVPIcon:Show()
			if select(2, UnitFactionGroup("target")) == "Horde" then
				TargetFrameTextureFramePVPIcon:SetTexture(uuidb.textures.other.pvphorde)
			else
				TargetFrameTextureFramePVPIcon:SetTexture(uuidb.textures.other.pvpally)
			end
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
		frametexture = uuidb.textures.targetframe
	end

	-- get color in use
	if uuidb.general.customcolor or uuidb.general.classcolorframes then
		colors = uuidb.general.customcolorval
	else
		colors = uuidb.targetframe.color
	end

	-- style frames accordingly
	local classification = UnitClassification(self.unit)
	if ( classification == "minus" ) then
		if uuidb.targetframe.colortargett and not UnitIsPlayer(self.unit) then
			local red,green,_ = UnitSelectionColor(self.unit)
			if (red == 0) then
        	    colors = { r = 0, g = 1, b = 0}
        	elseif (green == 0) then
        	    colors = { r = 1, g = 0, b = 0}
        	else
        	    colors = { r = 1, g = 1, b = 0}
        	end
        end
        if uuidb.targetframe.largehealth then
			self.borderTexture:SetTexture(frametexture.targetingframe);
			self.threatIndicator:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Flash")
			self.threatIndicator:SetSize(242.00001525879, 93.00022888184)
			self.threatIndicator:SetTexCoord(0,0,0,0.181640625,0.9453125,0,0.9453125,0.181640625)
		end
		self.borderTexture:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
		self.nameBackground:Hide();
		self.manabar.pauseUpdates = true;
		self.manabar:Hide();
		self.manabar.TextString:Hide();
		self.manabar.LeftText:Hide();
		self.manabar.RightText:Hide();
		forceNormalTexture = true;
	elseif ( classification == "worldboss" or classification == "elite" ) then
		self.borderTexture:SetTexture(frametexture.elite)
		if uuidb.targetframe.colortargett then
			colors = {r = 164/255, g = 143/255, b = 57/255}
			TargetFrameSpellBar.Border:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
		end
		self.borderTexture:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
	elseif ( classification == "rareelite" ) then
		self.borderTexture:SetTexture(frametexture.rareelite)
		if uuidb.targetframe.colortargett then
			colors = {r = 65/255, g = 66/255, b = 73/255}
			TargetFrameSpellBar.Border:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
		end
		self.borderTexture:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
	elseif ( classification == "rare" ) then
		self.borderTexture:SetTexture(frametexture.rare)
		if uuidb.targetframe.colortargett then
			colors = {r = 173/255, g = 166/255, b = 156/255}
			TargetFrameSpellBar.Border:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
		end
		self.borderTexture:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
	else
		if UnitIsPlayer(self.unit) and uuidb.targetframe.colortargett then
			colors = RAID_CLASS_COLORS[select(2, UnitClass(self.unit))]
			TargetFrameSpellBar.Border:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
		elseif uuidb.targetframe.colortargett and not UnitIsPlayer(self.unit) then
			local red,green,_ = UnitSelectionColor(self.unit)
			if (red == 0) then
        	    colors = { r = 0, g = 1, b = 0}
        	elseif (green == 0) then
        	    colors = { r = 1, g = 0, b = 0}
        	else
        	    colors = { r = 1, g = 1, b = 0}
        	end
           	TargetFrameSpellBar.Border:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
		end
		self.borderTexture:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
		self.borderTexture:SetTexture(frametexture.targetingframe)
	end
end

function targetframes:ClassColorTargetEnable()
	hooksecurefunc("TargetofTarget_Update", self.PLAYER_TARGET_CHANGED)

end

function targetframes:PLAYER_TARGET_CHANGED()
	local colors
	if UnitIsConnected("targettarget") and uuidb.targetframe.colortargett then
		if UnitIsPlayer("targettarget") then
			colors = RAID_CLASS_COLORS[select(2, UnitClass("targettarget"))]
		else
			local red,green,_ = UnitSelectionColor("targettarget")
			if (red == 0) then
        	    colors = { r = 0, g = 1, b = 0}
        	elseif (green == 0) then
        	    colors = { r = 1, g = 0, b = 0}
        	else
        	    colors = { r = 1, g = 1, b = 0}
        	end
		end
		TargetFrameToTTextureFrameTexture:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
	end
end

function targetframes:Name()
	if uuidb.targetframe.name and uuidb.targetframe.largehealth then
		TargetFrameTextureFrameName:ClearAllPoints()
		TargetFrameTextureFrameName:SetPoint("CENTER", TargetFrameTextureFrame, "CENTER", -50, 36)
		TargetFrameTextureFrameName:Show()
	elseif uuidb.targetframe.name then
		TargetFrameTextureFrameName:Show()
	else
		TargetFrameTextureFrameName:Hide()
	end
end

function targetframes:Scale(value)
	TargetFrame:SetScale(value)
end

function targetframes:Frames(color)
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

function targetframes:ReworkAllColor(color)
	if not (IsAddOnLoaded("EasyFrames")) then
		if not (color) then
			color = uuidb.targetframe.color
		end

		self:Name()
		self:Scale(uuidb.targetframe.scale)
		self:Frames(color)
		uui_TargetFrameStyleTargetFrame(TargetFrame, color
			)

		hooksecurefunc("TargetFrame_CheckClassification", uui_TargetFrameStyleTargetFrame)
	end
end

UberUI.targetframes = targetframes