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

    FocusFrame.TargetFrameContainer.FrameTexture:SetVertexColor(dc.r, dc.g, dc.b, dc.a);
    FocusFrameSpellBar.Border:SetVertexColor(dc.r, dc.g, dc.b, dc.a);

    TargetFrameToT.FrameTexture:SetVertexColor(dc.r, dc.g, dc.b, dc.a);
    FocusFrameToT.FrameTexture:SetVertexColor(dc.r, dc.g, dc.b, dc.a);

    if (uuidb.general.hiderepcolor) then
        TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor:Hide();
    else
        TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor:Show();
    end
end

function targetframes:HealthBarColor()
    local tfhb = TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBar;
    if (uuidb.general.classcolorhealth and UnitIsPlayer("target")) then
        local classColor = RAID_CLASS_COLORS[select(2, UnitClass("target"))];
        tfhb:SetStatusBarDesaturated(true);
        tfhb:SetStatusBarColor(classColor.r, classColor.g, classColor.b, classColor.a);
    else
        tfhb:SetStatusBarDesaturated(false);
        tfhb:SetStatusBarColor(0, 1, 0, 1);
    end

    if (uuidb.general.classcolorhealth and UnitIsPlayer("focus")) then
        local classColor = RAID_CLASS_COLORS[select(2, UnitClass("focus"))];
        FocusFrame.TargetFrameContent.TargetFrameContentMain.HealthBar:SetStatusBarDesaturated(true);
        FocusFrame.TargetFrameContent.TargetFrameContentMain.HealthBar:SetStatusBarColor(classColor.r, classColor.g,
            classColor.b, classColor.a);
    else
        FocusFrame.TargetFrameContent.TargetFrameContentMain.HealthBar:SetStatusBarDesaturated(false);
        FocusFrame.TargetFrameContent.TargetFrameContentMain.HealthBar:SetStatusBarColor(0, 1, 0, 1);
    end

    if (uuidb.general.classcolorhealth and UnitIsPlayer("targettarget")) then
        local classColor = RAID_CLASS_COLORS[select(2, UnitClass("targettarget"))];
        TargetFrameToT.HealthBar:SetStatusBarDesaturated(true);
        TargetFrameToT.HealthBar:SetStatusBarColor(classColor.r, classColor.g, classColor.b, classColor.a);
    else
        TargetFrameToT.HealthBar:SetStatusBarDesaturated(false);
        TargetFrameToT.HealthBar:SetStatusBarColor(0, 1, 0, 1);
    end
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

        FocusFrame.TargetFrameContent.TargetFrameContentMain.HealthBar:SetStatusBarTexture(texture);
        FocusFrame.TargetFrameContent.TargetFrameContentMain.MyHealPredictionBar:SetTexture(texture);
        FocusFrame.TargetFrameContent.TargetFrameContentMain.OtherHealPredictionBar:SetTexture(texture);
        FocusFrame.TargetFrameContent.TargetFrameContentMain.TotalAbsorbBar:SetTexture(texture);
        FocusFrame.TargetFrameContent.TargetFrameContentMain.TotalAbsorbBar:SetVertexColor(.6, .9, .9, 1);

        TargetFrameToT.HealthBar:SetStatusBarTexture(texture);

        FocusFrameToT.HealthBar:SetStatusBarTexture(texture);

        -- Color bar accordingly
        -- https://wowpedia.fandom.com/wiki/API_UnitPowerDisplayMod
        local targetPowerType = UnitPowerType("target");
        if (targetPowerType < 4) then
            TargetFrame.TargetFrameContent.TargetFrameContentMain.ManaBar:SetStatusBarTexture(texture);
            local pc = PowerBarColor[targetPowerType];
            TargetFrame.TargetFrameContent.TargetFrameContentMain.ManaBar:SetStatusBarColor(pc.r, pc.g, pc.b);
        end

        local focusPowerType = UnitPowerType("focus");
        if (focusPowerType < 4) then
            FocusFrame.TargetFrameContent.TargetFrameContentMain.ManaBar:SetStatusBarTexture(texture);
            local pc = PowerBarColor[focusPowerType];
            FocusFrame.TargetFrameContent.TargetFrameContentMain.ManaBar:SetStatusBarColor(pc.r, pc.g, pc.b);
        end

        local totPowerType = UnitPowerType("targettarget");
        if (totPowerType < 4) then
            TargetFrameToT.ManaBar:SetStatusBarTexture(texture);
            local pc = PowerBarColor[totPowerType];
            TargetFrameToT.ManaBar:SetStatusBarColor(pc.r, pc.g, pc.b);
        end

        local focusTotPowerType = UnitPowerType("focustarget");
        if (focusTotPowerType < 4) then
            FocusFrameToT.ManaBar:SetStatusBarTexture(texture);
            local pc = PowerBarColor[focusTotPowerType];
            FocusFrameToT.ManaBar:SetStatusBarColor(pc.r, pc.g, pc.b);
        end
    else
        local texture = uuidb.statusbars.Minimalist;
        targetFrame.HealAbsorbBar:SetTexture(texture);
        targetFrame.MyHealPredictionBar:SetTexture(texture);
        targetFrame.OtherHealPredictionBar:SetTexture(texture);
        targetFrame.TotalAbsorbBar:SetTexture(texture);
        targetFrame.TotalAbsorbBar:SetVertexColor(.7, .9, .9, 1);

        FocusFrame.TargetFrameContent.TargetFrameContentMain.HealthBar:SetStatusBarTexture(texture);
        FocusFrame.TargetFrameContent.TargetFrameContentMain.MyHealPredictionBar:SetTexture(texture);
        FocusFrame.TargetFrameContent.TargetFrameContentMain.OtherHealPredictionBar:SetTexture(texture);
        FocusFrame.TargetFrameContent.TargetFrameContentMain.TotalAbsorbBar:SetTexture(texture);
        FocusFrame.TargetFrameContent.TargetFrameContentMain.TotalAbsorbBar:SetVertexColor(.6, .9, .9, 1);
    end
end

function targetframes:PvPIcon(unhide)
    local pvpIcon = TargetFrame.TargetFrameContent.TargetFrameContentContextual.PvpIcon;
    local prestigePortrait = TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait;
    local prestigeBadge = TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge;
    local dc = uuidb.general.darkencolor;
    if (uuidb.general.hidehonor) then
        prestigePortrait:Hide();
        prestigeBadge:Hide();
        pvpIcon:Hide();
    else
        prestigePortrait:SetVertexColor(dc.r, dc.g, dc.b, dc.a);
    end

    if (unhide and UnitIsPVP("target")) then
        prestigePortrait:Show();
        prestigeBadge:Show();
        pvpIcon:Show();
    end
end

UberUI.targetframes = targetframes
