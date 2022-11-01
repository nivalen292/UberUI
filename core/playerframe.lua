local addon, ns = ...
local playerframes = {}

local class = UnitClass("player")
local classcolor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
local defaultTex = PlayerFrameHealthBar:GetStatusBarTexture()

playerframes = CreateFrame("frame")
playerframes:RegisterEvent("ADDON_LOADED")
playerframes:RegisterEvent("PLAYER_LOGIN")
playerframes:RegisterEvent("PLAYER_ENTERING_WORLD")
playerframes:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
playerframes:RegisterEvent("ACTIONBAR_UPDATE_STATE")
playerframes:RegisterEvent("PVP_WORLDSTATE_UPDATE")
playerframes:RegisterEvent("UNIT_ENTERED_VEHICLE")
playerframes:RegisterEvent("UNIT_EXITED_VEHICLE")
playerframes:SetScript("OnEvent", function(self)
    playerframes:Color();
    playerframes:HealthBarColor();
    playerframes:HealthManaBarTexture();
end)

function playerframes:Color()
    local dc = uuidb.general.darkencolor;
    PlayerFrame.PlayerFrameContainer.FrameTexture:SetVertexColor(dc.r, dc.g, dc.b, dc.a);
    PlayerCastingBarFrame.Border:SetVertexColor(dc.r, dc.g, dc.b, dc.a);
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigePortrait:SetVertexColor(dc.r, dc.g, dc.b, dc.a);

    self:ColorTotems();
    self:ColorHolyPower();
    self:ColorComboPoints();
end

function playerframes:HealthBarColor()
    if uuidb.general.classcolorhealth then
        PlayerFrameHealthBar:SetStatusBarDesaturated(true);
        PlayerFrameHealthBar:SetStatusBarColor(classcolor.r, classcolor.g, classcolor.b, classcolor.a);
    else
        PlayerFrameHealthBar:SetStatusBarDesaturated(false);
        PlayerFrameHealthBar:SetStatusBarColor(0, 1, 0, 1);
    end
end

function playerframes:HealthManaBarTexture()
    if (uuidb.general.texture ~= "Blizzard") then
        local texture = uuidb.statusbars[uuidb.general.texture];
        PlayerFrameHealthBar:SetStatusBarTexture(texture);

        local playerPowerType = UnitPowerType("player");
        if (playerPowerType < 4) then
            PlayerFrameManaBar:SetStatusBarTexture(texture);
            local pc = PowerBarColor[playerPowerType];
            PlayerFrameManaBar:SetStatusBarColor(pc.r, pc.g, pc.b);
        end
    end
end

function playerframes:ColorTotems()
    local dc = uuidb.general.darkencolor;
    for _, totems in pairs({ TotemFrame:GetChildren() }) do
        for _, items in pairs({ totems:GetChildren() }) do
            if (items:GetChildren() == nil) then
                for _, reg in pairs({ items:GetRegions() }) do
                    reg:SetVertexColor(dc.r, dc.g, dc.b, dc.a)
                end

            end
        end
    end
end

function playerframes:ColorHolyPower()
    local dc = uuidb.general.darkencolor;
    PaladinPowerBarFrameBG:SetVertexColor(dc.r, dc.g, dc.b, dc.a);
    PaladinPowerBarFrameBankBG:SetVertexColor(dc.r, dc.g, dc.b, dc.a);
end

function playerframes:ColorComboPoints()
    local dc = uuidb.general.darkencolor;
    for _, cp in pairs({ ComboPointPlayerFrame:GetChildren() }) do
        cp.PointOff:SetVertexColor(dc.r, dc.g, dc.b, dc.a);
    end
end

UberUI.playerframes = playerframes
