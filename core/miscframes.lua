local addon, ns = ...
local misc = {}


local misc = CreateFrame("frame")
misc:RegisterEvent("PLAYER_ENTERING_WORLD")
misc:RegisterEvent("GROUP_ROSTER_UPDATE")
misc:RegisterEvent("RAID_ROSTER_UPDATE")
misc:RegisterEvent("PLAYER_LEAVE_COMBAT")
misc:SetScript("OnEvent", function(self,event)
	if (event == "PLAYER_ENTERING_WORLD") then
		self:pvpicons()
		if not (IsAddOnLoaded("VuhDo")) then
			RaidColor()
			hooksecurefunc("CompactRaidFrameContainer_LayoutFrames", RaidColor)
		end
	end
	misc:ExtraBars()
	if not (IsAddOnLoaded("VuhDo")) then
		RaidColor()
	end
end)

function misc:NameplateTexture()
	hooksecurefunc("CompactUnitFrame_UpdateHealthColor", function(frame)
		if not frame:IsForbidden() and frame.healthBar ~= nil then
			if uuidb.general.bartexture ~= "Blizzard" then
				local texture = uuidb.textures.statusbars[uuidb.general.bartexture]
				local striped = uuidb.textures.statusbars.Striped
				frame.healthBar:SetStatusBarTexture(texture)
				frame.myHealPrediction:SetTexture(texture)
				frame.otherHealPrediction:SetTexture(texture)
				frame.totalAbsorb:SetTexture(striped)
				frame.totalAbsorb:SetVertexColor(.6, .9, .9, 1)
				if frame.castBar ~= nil then
					frame.castBar:SetStatusBarTexture(texture)
				end
			end
		end
	end)
end

function misc:ExtraBars()
	local texture = uuidb.textures.statusbars[uuidb.general.bartexture]
	if uuidb.general.bartexture ~= "Blizzard" then
		local st = { StatusTrackingBarManager:GetChildren() }
		for _,s in pairs(st) do
		   for k,v in pairs(s) do
		      if k == "StatusBar" then
		         v:SetStatusBarTexture(texture)
		      end
		   end
		end
		for _,v in pairs({
			CastingBarFrame,
			TargetFrameSpellBar,
			FocusFrameSpellBar,
			ClassNameplateManaBarFrame,
			}) do
			v:SetStatusBarTexture(texture)
		end
		ClassNameplateManaBarFrame.ManaCostPredictionBar:SetTexture(texture)
	end	
end

function RaidColor(color)
	erf = IsAddOnLoaded("EnhancedRaidFrames")
	--CompactRaidFrameContainer_LayoutFrames(self);
	if not (color) and uuidb.general.customcolor or uuidb.general.classcolorframes then
		color = uuidb.general.customcolorval
	else
		color = uuidb.playerframe.color
	end

	local texture = uuidb.textures.statusbars[uuidb.general.bartexture]
	for g = 1, NUM_RAID_GROUPS do
		local group = _G["CompactRaidGroup"..g.."BorderFrame"]
		if group then
			for _, region in pairs({group:GetRegions()}) do
				if region:IsObjectType("Texture") then
					region:SetVertexColor(color.r, color.g, color.b, color.a)
				end
			end
		end
		for m = 1, 5 do
			local frame = _G["CompactRaidGroup"..g.."Member"..m]
			if frame and uuidb.miscframes.raidgroupcolor then
				if not erf then
					for _, region in pairs({frame:GetRegions()}) do
						if region:GetName():find("Border") then
							region:SetVertexColor(color.r, color.g, color.b, color.a)
						end
					end
				end
				if uuidb.general.bartexture ~= "Blizzard" and uuidb.miscframes.texraidframes then
					frame.healthBar:SetStatusBarTexture(texture)
					frame.powerBar:SetStatusBarTexture(texture)
				end
			end
			local frame = _G["CompactRaidFrame"..m]
			if frame and uuidb.miscframes.raidsinglecolor then
				for _, region in pairs({frame:GetRegions()}) do
					if not erf then
						if region:GetName():find("Border") then
							region:SetVertexColor(color.r, color.g, color.b, color.a)
						end
					end
				end
				if uuidb.general.bartexture ~= "Blizzard" and uuidb.miscframes.texraidframes then
					frame.healthBar:SetStatusBarTexture(texture)
					frame.powerBar:SetStatusBarTexture(texture)
				end
			end
		end
		if CompactPartyFrameBorderFrame then
   			for _,region in pairs({CompactPartyFrameBorderFrame:GetRegions()}) do
   			   region:SetVertexColor(color.r, color.g, color.b, color.a)
   			end
		end
	end
	for _, region in pairs({CompactRaidFrameContainerBorderFrame:GetRegions()}) do
		if region:IsObjectType("Texture") then
			region:SetVertexColor(color.r, color.g, color.b, color.a)
		end
	end
	for _, region in pairs({CompactRaidFrameManager:GetRegions()}) do
		if region:IsObjectType("Texture") then
			region:SetVertexColor(color.r, color.g, color.b, color.a)
		end
	end
	for _, region in pairs({CompactRaidFrameManagerContainerResizeFrame:GetRegions()}) do
		if region:IsObjectType("Border") then
			region:SetVertexColor(color.r, color.g, color.b, color.a)
		end
	end
	CompactRaidFrameManagerToggleButton:SetNormalTexture("Interface\\AddOns\\Uber UI\\textures\\raid\\RaidPanel-Toggle")
end

function misc:PartyColor(color)
	local partyframes = {
		PartyMemberFrame1Texture, 
		PartyMemberFrame2Texture, 
		PartyMemberFrame3Texture, 
		PartyMemberFrame4Texture,
		PartyMemberFrame1PetFrameTexture, 
		PartyMemberFrame2PetFrameTexture, 
		PartyMemberFrame3PetFrameTexture,
		PartyMemberFrame4PetFrameTexture,
	}
	for _,v in pairs(partyframes) do
		--if (UnitIsConnected(v.unit)) and uuidb.miscframes.partycolort then
		--	uui_General_ClassColored(v, v.unit)
		--else
			v:SetVertexColor(color.r, color.g, color.b, color.a)
		--end
	end
	for i=1,4 do 
		_G["PartyMemberFrame"..i.."PVPIcon"]:SetAlpha(0)
		_G["PartyMemberFrame"..i.."NotPresentIcon"]:Hide()
		_G["PartyMemberFrame"..i.."NotPresentIcon"].Show = function() end
	end
end

function misc:TooltipColor(color)
	hooksecurefunc("GameTooltip_ShowCompareItem", function(self, anchorFrame)
		if (self) then
			local shoppingTooltip1, shoppingTooltip2 = unpack(self.shoppingTooltips)
			shoppingTooltip1:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
			shoppingTooltip2:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
		end
	end)
	hooksecurefunc("SharedTooltip_SetBackdropStyle", function(self, style)
		self:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
	end)
end

local hcount = 0
function misc:pvpicons(color)

	if uuidb.general.customcolor or uuidb.general.classcolorframes then
		color = uuidb.general.customcolorval
	else
		color = uuidb.playerframe.color
	end

	if uuidb.miscframes.pvpicons and hcount > 0 then
		PlayerPrestigeBadge:SetAlpha(1)
		PlayerPrestigePortrait:SetAlpha(1)
		TargetFrameTextureFramePrestigeBadge:SetAlpha(1)
		TargetFrameTextureFramePrestigePortrait:SetAlpha(1)
		FocusFrameTextureFramePrestigeBadge:SetAlpha(1)
		FocusFrameTextureFramePrestigePortrait:SetAlpha(1)
		PlayerPrestigePortrait:SetVertexColor(color.r, color.g, color.b, color.a)
	elseif uuidb.miscframes.pvpicons then
		PlayerPrestigeBadge:SetAlpha(1)
		PlayerPrestigePortrait:SetAlpha(1)
		TargetFrameTextureFramePrestigeBadge:SetAlpha(1)
		TargetFrameTextureFramePrestigePortrait:SetAlpha(1)
		FocusFrameTextureFramePrestigeBadge:SetAlpha(1)
		FocusFrameTextureFramePrestigePortrait:SetAlpha(1)
		PlayerPrestigePortrait:SetVertexColor(color.r, color.g, color.b, color.a)
		hcount = hcount + 1
		hooksecurefunc("PlayerFrame_UpdatePvPStatus", function(color)
			if uuidb.general.customcolor or uuidb.general.classcolorframes then
				color = uuidb.general.customcolorval
			else
				color = uuidb.playerframe.color
			end

			if uuidb.miscframes.pvpicons then
				PlayerPrestigeBadge:SetAlpha(1)
				PlayerPrestigePortrait:SetAlpha(1)
				PlayerPrestigePortrait:SetTexture(uuidb.textures.other.prestige)
				if select(2, UnitFactionGroup("player")) == "Horde" then
					PlayerPrestigePortrait:SetTexCoord(0.000976562, 0.0498047, 0.869141, 0.970703)
				else
					PlayerPrestigePortrait:SetTexCoord(0.000976562, 0.0498047, 0.763672, 0.865234)
				end
				PlayerPrestigePortrait:SetVertexColor(color.r, color.g, color.b, color.a)
			end
		end)
	else
		PlayerPrestigeBadge:SetAlpha(0)
		PlayerPrestigePortrait:SetAlpha(0)
		TargetFrameTextureFramePrestigeBadge:SetAlpha(0)
		TargetFrameTextureFramePrestigePortrait:SetAlpha(0)
		FocusFrameTextureFramePrestigeBadge:SetAlpha(0)
		FocusFrameTextureFramePrestigePortrait:SetAlpha(0)
	end
end

function misc:ReworkAllColor(color)
	if not (color) then
		color = uuidb.miscframes.misccolor
	end
	self:NameplateTexture()
	self:ExtraBars()
	self:pvpicons(color)
	self:PartyColor(color)
	self:TooltipColor(color)
	RaidColor(color)
end

UberUI.misc = misc