---------------------------------------
-- VARIABLES
---------------------------------------

--get the addon namespace
local addon, ns = ...
local actionbars = {}

local classcolor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
local class = UnitClass("player")
local dominos = IsAddOnLoaded("Dominos")
local bartender4 = IsAddOnLoaded("Bartender4")


local actionbars = CreateFrame("frame")
actionbars:RegisterEvent("ADDON_LOADED")
actionbars:SetScript("OnEvent", function(self, event)
    self:Color();
end)

function actionbars:Color()
    local dc = uuidb.general.darkencolor;
    for i = 1, 12 do
        _G["ActionButton" .. i .. "NormalTexture"]:SetVertexColor(dc.r, dc.g, dc.b, dc.a);
        _G["ActionButton" .. i].RightDivider:SetVertexColor(dc.r, dc.g, dc.b, dc.a);
        _G["MultiBarBottomLeftButton" .. i .. "NormalTexture"]:SetVertexColor(dc.r, dc.g, dc.b, dc.a);
        _G["MultiBarBottomRightButton" .. i .. "NormalTexture"]:SetVertexColor(dc.r, dc.g, dc.b, dc.a);
        _G["MultiBarRightButton" .. i .. "NormalTexture"]:SetVertexColor(dc.r, dc.g, dc.b, dc.a);
        _G["MultiBarLeftButton" .. i .. "NormalTexture"]:SetVertexColor(dc.r, dc.g, dc.b, dc.a);
        _G["MultiBar5Button" .. i .. "NormalTexture"]:SetVertexColor(dc.r, dc.g, dc.b, dc.a);
        _G["MultiBar6Button" .. i .. "NormalTexture"]:SetVertexColor(dc.r, dc.g, dc.b, dc.a);
        _G["MultiBar7Button" .. i .. "NormalTexture"]:SetVertexColor(dc.r, dc.g, dc.b, dc.a);
    end

    for i = 1, 10 do
        _G["StanceButton" .. i .. "NormalTexture"]:SetVertexColor(dc.r, dc.g, dc.b, dc.a);
    end

    for _, border in pairs({ MainMenuBar.BorderArt:GetRegions() }) do
        border:SetVertexColor(dc.r, dc.g, dc.b, dc.a);
    end
end

UberUI.actionbars = actionbars
