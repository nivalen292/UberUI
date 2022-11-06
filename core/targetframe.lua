local addon, ns = ...
local targetframes = {}

--[[
	Local Variables
]] --
local targetframes = CreateFrame("frame")
targetframes:RegisterEvent("ADDON_LOADED")
targetframes:RegisterEvent("PLAYER_LOGIN")
targetframes:RegisterEvent("PLAYER_ENTERING_WORLD")
targetframes:RegisterEvent("PLAYER_TARGET_CHANGED")
targetframes:RegisterEvent("PLAYER_FOCUS_CHANGED")
targetframes:RegisterEvent("UNIT_TARGET")
targetframes:SetScript("OnEvent", function(self, event)
    targetframes:Color();
    targetframes:HealthBarColor();
    targetframes:HealthManaBarTexture();
    targetframes:PvPIcon();
end)

function targetframes:Color()
    local dc = uuidb.general.darkencolor;
    TargetFrame.TargetFrameContainer.FrameTexture:SetVertexColor(dc.r, dc.g, dc.b, dc.a);
    TargetFrameSpellBar.Border:SetVertexColor(dc.r, dc.g, dc.b, dc.a);
    TargetFrameToT.FrameTexture:SetVertexColor(dc.r, dc.g, dc.b, dc.a);

    if (uuidb.general.hiderepcolor) then
        TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor:Hide();
    else
        TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor:Show();
    end
end

function targetframes:HealthBarColor()
    local healthBar = TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBar;
    UberUI.general:SetHealthColor(healthBar, "target", uuidb.targetframes);

    local healthBar = TargetFrameToT.HealthBar;
    UberUI.general:SetHealthColor(healthBar, "targettarget", uuidb.targetframes);
end

function targetframes:HealthManaBarTexture()
    local targetFrame = TargetFrame.TargetFrameContent.TargetFrameContentMain;
    if (uuidb.general.texture ~= "Blizzard") then
        local texture = uuidb.statusbars[uuidb.general.texture];
        TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBar:SetStatusBarTexture(texture);
        targetFrame.MyHealPredictionBar:SetTexture(texture);
        targetFrame.OtherHealPredictionBar:SetTexture(texture);
        targetFrame.TotalAbsorbBar:SetTexture(texture);
        targetFrame.TotalAbsorbBar:SetVertexColor(.7, .9, .9, 1);
        TargetFrameToT.HealthBar:SetStatusBarTexture(texture);

        -- Color bar accordingly
        -- https://wowpedia.fandom.com/wiki/API_UnitPowerDisplayMod
        local targetPowerType = UnitPowerType("target");
        if (targetPowerType < 4) then
            TargetFrame.TargetFrameContent.TargetFrameContentMain.ManaBar:SetStatusBarTexture(texture);
            local pc = PowerBarColor[targetPowerType];
            TargetFrame.TargetFrameContent.TargetFrameContentMain.ManaBar:SetStatusBarColor(pc.r, pc.g, pc.b);
        end

        local totPowerType = UnitPowerType("targettarget");
        if (totPowerType < 4) then
            TargetFrameToT.ManaBar:SetStatusBarTexture(texture);
            local pc = PowerBarColor[totPowerType];
            TargetFrameToT.ManaBar:SetStatusBarColor(pc.r, pc.g, pc.b);
        end
    else
        local texture = uuidb.statusbars.Minimalist;
        targetFrame.HealAbsorbBar:SetTexture(texture);
        targetFrame.MyHealPredictionBar:SetTexture(texture);
        targetFrame.OtherHealPredictionBar:SetTexture(texture);
        targetFrame.TotalAbsorbBar:SetTexture(texture);
        targetFrame.TotalAbsorbBar:SetVertexColor(.7, .9, .9, 1);
    end
end

function targetframes:PvPIcon()
    UberUI.general:PvPIcon(TargetFrame.TargetFrameContent.TargetFrameContentContextual);
    -- local pvpIcon = TargetFrame.TargetFrameContent.TargetFrameContentContextual.PvpIcon;
    -- local prestigePortrait = TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait;
    -- local prestigeBadge = TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge;
    -- local dc = uuidb.general.darkencolor;
    -- if (uuidb.general.hidehonor) then
    --     prestigePortrait:SetAlpha(0);
    --     prestigeBadge:SetAlpha(0);
    --     pvpIcon:SetAlpha(0);
    -- else
    --     prestigePortrait:SetAlpha(1);
    --     prestigeBadge:SetAlpha(1);
    --     pvpIcon:SetAlpha(1);
    --     prestigePortrait:SetVertexColor(dc.r, dc.g, dc.b, dc.a);
    -- end
end

UberUI.targetframes = targetframes
