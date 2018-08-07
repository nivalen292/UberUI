local addon, ns = ...
local uui_Misc

	hooksecurefunc("PetFrame_Update", function(self, override)
		  if ( (not PlayerFrame.animating or UnitInVehicle("player") or UnitisDead("player")) or (override) ) then
  			  if ( UnitIsVisible(self.unit) and PetUsesPetFrame() and not PlayerFrame.vehicleHidesPet ) then
  			    if ( self:IsShown() ) then
  			      UnitFrame_Update(self);
  			    else
  			      self:Show();
  			    end
  			    --self.flashState = 1;
  			    --self.flashTimer = PET_FLASH_ON_TIME;
  			    if ( UnitPowerMax(self.unit) == 0 ) then
  			      PetFrameTexture:SetTexture("Interface\\AddOns\\Uber UI\\textures\\target\\smalltargetingframe-nomana");
  			      PetFrameManaBarText:Hide();
  			    else
  			      PetFrameTexture:SetTexture("Interface\\AddOns\\Uber UI\\textures\\target\\smalltargetingframe");
  			    end
  			    PetAttackModeTexture:Hide();
 			
  			    RefreshDebuffs(self, self.unit, nil, nil, true);
  			  else
  			    self:Hide();
  			  end
  			end
		end)

		function ColorRaid()
		for g = 1, NUM_RAID_GROUPS do
			local group = _G["CompactRaidGroup"..g.."BorderFrame"]
			if group then
				for _, region in pairs({group:GetRegions()}) do
					if region:IsObjectType("Texture") then
						if UberuiDB.ClassColorFrames then
							region:SetVertexColor(classcolor.r, classcolor.g, classcolor.b)
						else
							region:SetVertexColor(.05, .05, .05)
						end
					end
				end
			end
			for m = 1, 5 do
				local frame = _G["CompactRaidGroup"..g.."Member"..m]
				if frame then
					groupcolored = true
					for _, region in pairs({frame:GetRegions()}) do
						if region:GetName():find("Border") then
							if UberuiDB.ClassColorFrames then
								region:SetVertexColor(classcolor.r, classcolor.g, classcolor.b)
							else
								region:SetVertexColor(.05, .05, .05)
							end
						end
					end
				end
				local frame = _G["CompactRaidFrame"..m]
				if frame then
					singlecolored = true
					for _, region in pairs({frame:GetRegions()}) do
						if region:GetName():find("Border") then
							if UberuiDB.ClassColorFrames then
								region:SetVertexColor(classcolor.r, classcolor.g, classcolor.b)
							else
								region:SetVertexColor(.05, .05, .05)
							end
						end
					end
				end
			end
		end
		for _, region in pairs({CompactRaidFrameContainerBorderFrame:GetRegions()}) do
			if region:IsObjectType("Texture") then
				if UberuiDB.ClassColorFrames then
					region:SetVertexColor(classcolor.r, classcolor.g, classcolor.b)
				else
					region:SetVertexColor(.05, .05, .05)
				end
			end
		end
	end
	
	CF:SetScript("OnEvent", function(self, event)
		ColorRaid()
		CF:SetScript("OnUpdate", function()
			if CompactRaidGroup1 and not groupcolored == true then
				ColorRaid()
			end
			if CompactRaidFrame1 and not singlecolored == true then
				ColorRaid()
			end
		end)
	end)