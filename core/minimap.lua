local addon, ns = ...
local minimap = {}

minimap = CreateFrame("Frame")
minimap:RegisterEvent("PLAYER_LOGIN")
minimap:SetScript("OnEvent", function(self, event)
    if not (IsAddOnLoaded("SexyMap")) then
    end
    minimap:Color()
end)

function minimap:Color()
    MinimapCompassTexture:SetVertexColor(.4, .4, .4, 1)
end

UberUI.minimap = minimap
