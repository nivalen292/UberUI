local addon, ns = ...
local misc = {}


local misc = CreateFrame("frame")
misc:RegisterEvent("ADDON_LOADED")
misc:RegisterEvent("GROUP_ROSTER_UPDATE")
misc:RegisterEvent("PLAYER_LEAVE_COMBAT")
misc:SetScript("OnEvent", function(self,event)

end)


function misc:RaidColor(color)
	for g = 1, NUM_RAID_GROUPS do
		local group = _G["CompactRaidGroup"..g.."BorderFrame"]
		if group then
			for _, region in pairs({group:GetRegions()}) do
				if region:IsObjectType("Texture") then
					region:SetVertexColor(color.r, color.b, color.g, color.a)
				end
			end
		end
		for m = 1, 5 do
			local frame = _G["CompactRaidGroup"..g.."Member"..m]
			if frame and uuidb.miscframes.raidgroupcolor then
				for _, region in pairs({frame:GetRegions()}) do
					if region:GetName():find("Border") then
						region:SetVertexColor(color.r, color.b, color.g, color.a)
					end
				end
			end
			local frame = _G["CompactRaidFrame"..m]
			if frame and uuidb.miscframes.raidsinglecolor then
				for _, region in pairs({frame:GetRegions()}) do
					if region:GetName():find("Border") then
						region:SetVertexColor(color.r, color.b, color.g, color.a)
					end
				end
			end
		end
		if CompactPartyFrameBorderFrame then
   			for _,region in pairs({CompactPartyFrameBorderFrame:GetRegions()}) do
   			   region:SetVertexColor(color.r,color.b,color.g,color.a)
   			end
		end
	end
	for _, region in pairs({CompactRaidFrameContainerBorderFrame:GetRegions()}) do
		if region:IsObjectType("Texture") then
			region:SetVertexColor(color.r, color.b, color.g, color.a)
		end
	end
	for _, region in pairs({CompactRaidFrameManager:GetRegions()}) do
		if region:IsObjectType("Texture") then
			region:SetVertexColor(color.r, color.b, color.g, color.a)
		end
	end
	for _, region in pairs({CompactRaidFrameManagerContainerResizeFrame:GetRegions()}) do
		if region:IsObjectType("Border") then
			region:SetVertexColor(color.r, color.b, color.g, color.a)
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
			v:SetVertexColor(color.r, color.b, color.g, color.a)
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
			shoppingTooltip1:SetBackdropBorderColor(color.r, color.b, color.g, color.a)
			shoppingTooltip2:SetBackdropBorderColor(color.r, color.b, color.g, color.a)
		end
	end)
	hooksecurefunc("GameTooltip_SetBackdropStyle", function(self, style)
		self:SetBackdropBorderColor(color.r, color.b, color.g, color.a)
	end)
end

function misc:pvpicons()
	for i,v in pairs({
		PlayerPVPIcon,
		TargetFrameTextureFramePVPIcon,
		FocusFrameTextureFramePVPIcon,
	}) do
		if not UberuiDB.pvpicons then
			v:SetAlpha(0)
		else
			v:SetVertexColor(.75,.75,.75,1)
		end
	end
end

function misc:ReworkAllColor(color)
	if not (color) then
		color = uuidb.miscframes.misccolor
	end

	self:RaidColor(color)
	self:PartyColor(color)
	self:TooltipColor(color)
end

UberUI.misc = misc