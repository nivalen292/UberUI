local addon, ns = ...
local raidframes = {}

local hookRaid = false;

raidframes = CreateFrame("Frame");
raidframes:RegisterEvent("ADDON_LOADED");
raidframes:RegisterEvent("PLAYER_ENTERING_WORLD");
raidframes:RegisterEvent("RAID_ROSTER_UPDATE");
raidframes:RegisterEvent("PLAYER_REGEN_ENABLED");
raidframes:SetScript("OnEvent", function(self, event)
    -- raidframes:HealthManaBarTexture();
    if (event == "PLAYER_REGEN_ENABLED" and IsInRaid()) then
        raidframes:HealthManaBarTexture()
    elseif (event ~= "PLAYER_REGEN_ENABLED") then
        raidframes:HealthManaBarTexture()
    end
    raidframes:AddHooks();
end)

function raidframes:HealthManaBarTexture()
    local dc = uuidb.general.darkencolor;
    local texture = uuidb.general.raidbartextures and uuidb.statusbars[uuidb.general.raidbartexture] or
        uuidb.statusbars[uuidb.general.texture];
    for i = 1, 8 do
        local group = _G["CompactRaidGroup" .. i];
        if (group ~= nil) then
            for _, borderSection in pairs({ group.borderFrame:GetRegions() }) do
                borderSection:SetVertexColor(dc.r, dc.g, dc.b, dc.a);
            end
            for m = 1, MEMBERS_PER_RAID_GROUP do
                local member = _G[group:GetName() .. "Member" .. m];
                UberUI.cuf.default(member)
            end
        end
    end
end

function raidframes:AddHooks()
    -- hook to  make sure raid gets textured on show event

    -- if (hookRaid == false) then
    --     CompactRaidFrameManager.container:HookScript("OnShow", function(self)
    --         raidframes:HealthManaBarTexture();
    --     end)
    --     hookRaid = true;
    -- end
end

UberUI.raidframes = raidframes;
