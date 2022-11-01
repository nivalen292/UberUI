local addon, ns = ...
local misc = {}


local misc = CreateFrame("frame")
misc:RegisterEvent("PLAYER_ENTERING_WORLD")
misc:RegisterEvent("GROUP_ROSTER_UPDATE")
misc:RegisterEvent("RAID_ROSTER_UPDATE")
misc:RegisterEvent("PLAYER_LEAVE_COMBAT")
misc:RegisterEvent("PLAYER_FOCUS_CHANGED")
misc:SetScript("OnEvent", function(self, event)
    misc:NameplateTexture();
    misc:EndCaps();
    misc:StatusTrackingBars();
end)

local nthook = false
function misc:NameplateTexture()
    local texture = uuidb.statusbars[uuidb.general.texture];
    if nthook then return end
    hooksecurefunc("CompactUnitFrame_UpdateHealthColor", function(frame)
        if not frame:IsForbidden() and frame.healthBar ~= nil and
            not
            (frame:GetName() ~= nil and (frame:GetName():find("CompactRaid") or frame:GetName():find("CompactParty"))) then
            local texture = uuidb.statusbars[uuidb.general.texture];
            frame.healthBar:SetStatusBarTexture(texture);
            frame.healthBar:SetStatusBarDesaturated(true);
            frame.myHealPrediction:SetTexture(texture);
            frame.otherHealPrediction:SetTexture(texture);
            frame.totalAbsorb:SetTexture(texture);
            frame.totalAbsorb:SetVertexColor(.6, .9, .9, 1);
        end
    end)
    ClassNameplateManaBarFrame:SetStatusBarTexture(texture);
    ClassNameplateManaBarFrame:SetStatusBarDesaturated(true);
    nthook = true
end

function misc:EndCaps()
    local dc = uuidb.general.darkencolor;
    MainMenuBar.EndCaps.RightEndCap:SetVertexColor(dc.r, dc.g, dc.b, dc.a);
    MainMenuBar.EndCaps.LeftEndCap:SetVertexColor(dc.r, dc.g, dc.b, dc.a);
end

function misc:StatusTrackingBars()
    StatusTrackingBarManager.BottomBarFrameTexture:SetVertexColor(.4, .4, .4, 1);
    StatusTrackingBarManager.TopBarFrameTexture:SetVertexColor(.4, .4, .4, 1)
end

function misc:AllFramesColor()
    self:EndCaps();
    UberUI.playerframes:Color();
    UberUI.targetframes:Color();
    UberUI.minimap:Color();
    UberUI.actionbars:Color();
end

function misc:AllFramesHealthColor()
    UberUI.playerframes:HealthBarColor();
    UberUI.targetframes:HealthBarColor();
end

function misc:AllFramesHealthManaTexture()
    UberUI.playerframes:HealthManaBarTexture();
    UberUI.targetframes:HealthManaBarTexture();
    UberUI.partyframes:HealthManaBarTexture();
end

UberUI.misc = misc
