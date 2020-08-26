local addon, ns = ...
local misc = {}


local misc = CreateFrame("frame")
misc:RegisterEvent("PLAYER_ENTERING_WORLD")
misc:RegisterEvent("GROUP_ROSTER_UPDATE")
misc:RegisterEvent("RAID_ROSTER_UPDATE")
misc:RegisterEvent("PLAYER_LEAVE_COMBAT")
misc:RegisterEvent("PLAYER_FOCUS_CHANGED")
misc:SetScript("OnEvent", function(self,event)
	if (event == "PLAYER_ENTERING_WORLD") then
		self:pvpicons()
		if not (IsAddOnLoaded("VuhDo")) then
			RaidColor()
			hooksecurefunc("CompactRaidFrameContainer_LayoutFrames", RaidColor)
		end
	end
	if (event == "PLAYER_FOCUS_CHANGED") then
		self:FocusFrame()
	end
	misc:ExtraBars()
	if not (IsAddOnLoaded("VuhDo")) then
		RaidColor()
	end
end)

function misc:FocusFrame()
	if UnitExists('focus') then
		local u = 'focus'
		if uuidb.targetframe.colortargett == ("All") then
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
		else
			colors = uuidb.auras.color
		end
		FocusFrameSpellBar.Border:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
		FocusFrameTextureFramePrestigePortrait:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
	end
end

local nthook = false
function misc:NameplateTexture()
	if nthook then return end
	hooksecurefunc("CompactUnitFrame_UpdateHealthColor", function(frame)
		if not frame:IsForbidden() and frame.healthBar ~= nil then
			if uuidb.general.bartexture ~= "Blizzard" then
				local texture = uuidb.textures.statusbars[uuidb.general.bartexture]
				frame.healthBar:SetStatusBarTexture(texture)
				frame.myHealPrediction:SetTexture(texture)
				frame.otherHealPrediction:SetTexture(texture)
				frame.totalAbsorb:SetTexture(texture)
				frame.totalAbsorb:SetVertexColor(.6, .9, .9, 1)
				if frame.castBar ~= nil then
					frame.castBar:SetStatusBarTexture(texture)
					frame.castBar.Flash:SetTexture(texture)
				end
			end
		end
	end)
	nthook = true
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
		GameTooltipStatusBarTexture:SetTexture(texture)
	end	
end

local crfhook = false
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
				if not _G["crg"..g.."m"..m] then
					_G["crg"..g.."m"..m] = CreateFrame("Frame", "CompactRaidGroup"..g.."Member"..m.."RoleIconBorder", _G["CompactRaidGroup"..g.."Member"..m.."RoleIcon"]:GetParent())
					_G["crg"..g.."m"..m]:SetPoint(_G["CompactRaidGroup"..g.."Member"..m.."RoleIcon"]:GetPoint())
					_G["crg"..g.."m"..m]:SetSize(_G["CompactRaidGroup"..g.."Member"..m.."RoleIcon"]:GetSize())
					_G["crg"..g.."m"..m].texture = _G["crg"..g.."m"..m]:CreateTexture()
					_G["crg"..g.."m"..m].texture:SetPoint(_G["CompactRaidGroup"..g.."Member"..m.."RoleIcon"]:GetPoint())
					_G["crg"..g.."m"..m].texture:SetTexture("Interface\\AddOns\\Uber UI\\textures\\ui-portraitroles")
					_G["crg"..g.."m"..m].texture:SetSize(_G["CompactRaidGroup"..g.."Member"..m.."RoleIcon"]:GetSize())
					_G["crg"..g.."m"..m].texture:SetTexCoord(0, 0.296875, 0.015625, 0.3125)
					_G["crg"..g.."m"..m].texture:SetVertexColor(color)
				else
					_G["crg"..g.."m"..m].texture:SetSize(_G["CompactRaidGroup"..g.."Member"..m.."RoleIcon"]:GetSize())
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
				if not _G["crf"..m] then
					_G["crf"..m] = CreateFrame("Frame", "CompactRaidFrame"..m.."RoleIconBorder", _G["CompactRaidFrame"..m.."RoleIcon"]:GetParent())
					_G["crf"..m]:SetPoint(_G["CompactRaidFrame"..m.."RoleIcon"]:GetPoint())
					_G["crf"..m]:SetSize(_G["CompactRaidFrame"..m.."RoleIcon"]:GetSize())
					_G["crf"..m].texture = _G["crf"..m]:CreateTexture()
					_G["crf"..m].texture:SetPoint(_G["CompactRaidFrame"..m.."RoleIcon"]:GetPoint())
					_G["crf"..m].texture:SetTexture("Interface\\AddOns\\Uber UI\\textures\\ui-portraitroles")
					_G["crf"..m].texture:SetSize(_G["CompactRaidFrame"..m.."RoleIcon"]:GetSize())
					_G["crf"..m].texture:SetTexCoord(0, 0.296875, 0.015625, 0.3125)
					_G["crf"..m].texture:SetVertexColor(color)
				else
					_G["crf"..m].texture:SetSize(_G["CompactRaidFrame"..m.."RoleIcon"]:GetSize())
				end
				if uuidb.general.bartexture ~= "Blizzard" and uuidb.miscframes.texraidframes then
					frame.healthBar:SetStatusBarTexture(texture)
					frame.powerBar:SetStatusBarTexture(texture)
				end
			end
			local frame = _G["CompactPartyFrameMember"..m]
			if frame and uuidb.miscframes.raidsinglecolor then
				for _, region in pairs({frame:GetRegions()}) do
					if not erf then
						if region:GetName():find("Border") then
							region:SetVertexColor(color.r, color.g, color.b, color.a)
						end
					end
				end
				if not _G["cpf"..m] then
					_G["cpf"..m] = CreateFrame("Frame", "CompactPartyFrame"..m.."RoleIconBorder", _G["CompactPartyFrameMember"..m.."RoleIcon"]:GetParent())
					_G["cpf"..m]:SetPoint(_G["CompactPartyFrameMember"..m.."RoleIcon"]:GetPoint())
					_G["cpf"..m]:SetSize(_G["CompactPartyFrameMember"..m.."RoleIcon"]:GetSize())
					_G["cpf"..m].texture = _G["cpf"..m]:CreateTexture()
					_G["cpf"..m].texture:SetPoint(_G["CompactPartyFrameMember"..m.."RoleIcon"]:GetPoint())
					_G["cpf"..m].texture:SetTexture("Interface\\AddOns\\Uber UI\\textures\\ui-portraitroles")
					_G["cpf"..m].texture:SetSize(_G["CompactPartyFrameMember"..m.."RoleIcon"]:GetSize())
					_G["cpf"..m].texture:SetTexCoord(0, 0.296875, 0.015625, 0.3125)
					_G["cpf"..m].texture:SetVertexColor(color)
				else
					_G["cpf"..m].texture:SetSize(_G["CompactPartyFrameMember"..m.."RoleIcon"]:GetSize())
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
	if crfhook then return end
	crfhook = true
	hooksecurefunc("CompactRaidFrameContainer_TryUpdate", function(self)
		if not (color) and uuidb.general.customcolor or uuidb.general.classcolorframes then
			color = uuidb.general.customcolorval
		else
			color = uuidb.playerframe.color
		end
		RaidColor(color)
	end)
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
	if uuidb.general.customcolor or uuidb.general.classcolorframes then
		color = uuidb.general.customcolorval
	else
		color = uuidb.playerframe.color
	end
	for i=1,4 do 
		_G["PartyMemberFrame"..i.."PVPIcon"]:SetAlpha(0)
		_G["PartyMemberFrame"..i.."NotPresentIcon"].texture:SetVertexColor(color)
		if not _G["pa"..i.."ri"] then
			_G["pa"..i.."ri"] = CreateFrame("Frame", "PartyMemberFrame"..i.."RoleIconBorder", _G["PartyMemberFrame"..i.."RoleIcon"]:GetParent())
			_G["pa"..i.."ri"]:SetPoint(_G["PartyMemberFrame"..i.."RoleIcon"]:GetPoint())
			_G["pa"..i.."ri"]:SetSize(_G["PartyMemberFrame"..i.."RoleIcon"]:GetSize())
			_G["pa"..i.."ri"].texture = _G["pa"..i.."ri"]:CreateTexture()
			_G["pa"..i.."ri"].texture:SetPoint(_G["PartyMemberFrame"..i.."RoleIcon"]:GetPoint())
			_G["pa"..i.."ri"].texture:SetTexture("Interface\\AddOns\\Uber UI\\textures\\ui-portraitroles")
			_G["pa"..i.."ri"].texture:SetSize(_G["PartyMemberFrame"..i.."RoleIcon"]:GetSize())
			_G["pa"..i.."ri"].texture:SetTexCoord(0, 0.296875, 0.015625, 0.3125)
			_G["pa"..i.."ri"].texture:SetVertexColor(color)
		end
	end
end

local tthookset = false
function misc:TooltipColor(color)
	if tthookset then return end
	hooksecurefunc("GameTooltip_ShowCompareItem", function(self, anchorFrame)
		if uuidb.general.customcolor or uuidb.general.classcolorframes then
			color = uuidb.general.customcolorval
		else
			color = uuidb.playerframe.color
		end
		if (self) then
			local shoppingTooltip1, shoppingTooltip2 = unpack(self.shoppingTooltips)
			shoppingTooltip1:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
			shoppingTooltip2:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
		end
	end)
	hooksecurefunc("SharedTooltip_SetBackdropStyle", function(self, style)
		if uuidb.general.customcolor or uuidb.general.classcolorframes then
			color = uuidb.general.customcolorval
		else
			color = uuidb.playerframe.color
		end
		self:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
	end)
	tthookset = true
end

function misc:FocusName()
	if not uuidb.focusframe.nameinside then
		FocusFrameTextureFrameName:SetPoint('CENTER', 'FocusFrameTextureFrame', 'CENTER', -50, 34)
	else
		FocusFrameTextureFrameName:SetPoint('CENTER', 'FocusFrameTextureFrame', 'CENTER', -50, 19)
	end
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
	if not uuidb.focusframe.nameinside then
		self:FocusName()
	end
	RaidColor(color)
end

UberUI.misc = misc