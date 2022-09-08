local addon, ns = ...
local playerframes = {}

playerframes = CreateFrame("frame")
playerframes:RegisterEvent("ADDON_LOADED")
playerframes:RegisterEvent("PLAYER_LOGIN")
playerframes:RegisterEvent("PLAYER_ENTERING_WORLD")
playerframes:RegisterEvent("UNIT_ENTERED_VEHICLE")
playerframes:RegisterEvent("UNIT_EXITED_VEHICLE")
playerframes:SetScript("OnEvent", function(self, event, unitTarget, showVehicleFrame)
    if not
        (
        (IsAddOnLoaded("EasyFrames")) or (IsAddOnLoaded("Shadowed Unit Frames")) or
            (IsAddOnLoaded("PitBull Unit Frames 4.0")) or (IsAddOnLoaded("X-Perl UnitFrames"))) then
    end

end)

local function MiscFrames(color)
    PlayerFrame.PlayerFrameContainer.FrameTexture:SetVertexColor(.4, .4, .4, 1)
end

local pcount = 0

function uui_playerframes_LargeHealth(color)

end

function playerframes:Scale(value)
    if (PlayerFrame:GetScale() ~= value) then
        PlayerFrame:SetScale(value)
    end
end

function playerframes:ReworkAllColor(color)
    if not
        (
        (IsAddOnLoaded("EasyFrames")) or (IsAddOnLoaded("Shadowed Unit Frames")) or
            (IsAddOnLoaded("PitBull Unit Frames 4.0")) or (IsAddOnLoaded("X-Perl UnitFrames"))) then

        --enable large health style
        if uuidb.playerframe.largehealth then
            uui_playerframes_LargeHealth(color)
        end
        MiscFrames(color)
    end
end

UberUI.playerframes = playerframes
