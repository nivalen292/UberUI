local addon, ns = ...
local minimap = {}

minimap=CreateFrame("frame")
minimap:RegisterEvent("PLAYER_LOGIN")
minimap:SetScript("OnEvent", function(self, event)
	if not (IsAddOnLoaded("SexyMap")) then
		self:ReworkAllColor()
		self:Other()
	end
end)

function minimap:Color(color)
	if uuidb.general.customcolor then
		color = uuidb.general.customcolorval
	else
		color = uuidb.minimap.color
	end
	MinimapBorder:SetTexture(uuidb.minimap.texture)
	for _,v in pairs({
		MinimapBorder,
		MiniMapMailBorder,
		QueueStatusMinimapButtonBorder,
		select(1, TimeManagerClockButton:GetRegions()),
    }) do
		v:SetVertexColor(color.r, color.g, color.b, color.a)
	end
	select(2, TimeManagerClockButton:GetRegions()):SetVertexColor(1,1,1)
end

function minimap:GarrisonBtn(color)
	if uuidb.general.customcolor then
		color = uuidb.general.customcolorval
	else
		color = uuidb.minimap.color
	end
	hooksecurefunc("GarrisonLandingPageMinimapButton_UpdateIcon", function(self)
		self:GetNormalTexture():SetTexture(nil)
		self:GetPushedTexture():SetTexture(nil)
		if not gb then
			gb = CreateFrame("Frame", nil, GarrisonLandingPageMinimapButton)
			gb:SetFrameLevel(GarrisonLandingPageMinimapButton:GetFrameLevel() - 1)
			gb:SetPoint("CENTER", 0, 0)
			gb:SetSize(36,36)
			gb.icon = gb:CreateTexture(nil, "ARTWORK")
			gb.icon:SetPoint("CENTER", 0, 0)
			gb.icon:SetSize(36,36)
	
			gb.border = CreateFrame("Frame", nil, gb)
			gb.border:SetFrameLevel(gb:GetFrameLevel() + 1)
			gb.border:SetAllPoints()
			gb.border.texture = gb.border:CreateTexture(nil, "ARTWORK")
			gb.border.texture:SetTexture("Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-Ring")
			gb.border.textuer:SetVertexColor(color.r, color.g, color.b, color.a)
			gb.border.texture:SetPoint("CENTER", 1, -2)
			gb.border.texture:SetSize(45,45)
		end
		if (C_Garrison.GetLandingPageGarrisonType() == 2) then
			if select(1,UnitFactionGroup("player")) == "Alliance" then	
				SetPortraitToTexture(gb.icon, select(3,GetSpellInfo(61573)))
			elseif select(1,UnitFactionGroup("player")) == "Horde" then
				SetPortraitToTexture(gb.icon, select(3,GetSpellInfo(61574)))
			end
		else
			local t = CLASS_ICON_TCOORDS[select(2,UnitClass("player"))]
              	gb.icon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
              	gb.icon:SetTexCoord(unpack(t))
		end
	end)
end

function minimap:Other()
  	MinimapBorderTop:Hide()
	MinimapZoomIn:Hide()
	MinimapZoomOut:Hide()
	MiniMapWorldMapButton:Hide()
	MinimapZoneText:SetPoint("CENTER", Minimap, 0, 80)
	GameTimeFrame:Hide()
	GameTimeFrame:UnregisterAllEvents()
	GameTimeFrame.Show = kill
	MiniMapTracking:Hide()
	MiniMapTracking.Show = kill
	MiniMapTracking:UnregisterAllEvents()
	Minimap:EnableMouseWheel(true)
	Minimap:SetScript("OnMouseWheel", function(self, z)
		local c = Minimap:GetZoom()
		if(z > 0 and c < 5) then
			Minimap:SetZoom(c + 1)
		elseif(z < 0 and c > 0) then
			Minimap:SetZoom(c - 1)
		end
	end)
	Minimap:SetScript("OnMouseUp", function(self, btn)
		if btn == "RightButton" then
			_G.GameTimeFrame:Click()
		elseif btn == "MiddleButton" then
			_G.ToggleDropDownMenu(1, nil, _G.MiniMapTrackingDropDown, self)
		else
			_G.Minimap_OnClick(self)
		end
	end)
end

function minimap:ReworkAllColor(color)
	if not (color) then
		color = uuidb.minimap.color
	end
	self:Color(color)
	self:GarrisonBtn(color)
end

UberUI.minimap = minimap