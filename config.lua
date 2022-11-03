-- // Uber UI
-- // Uberlicious - 2018

-----------------------------
-- INIT
-----------------------------

--get the addon namespace
local addon, ns = ...
UberUI = {}
uuidb = {}
local config = {};

local classcolor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
-----------------------------
-- DEFAULTS
-----------------------------

--generate a holder for the config data
local UberUI = CreateFrame("Frame")
UberUI:SetScript("OnEvent", function(self, event, ...) return self[event] and self[event](self, ...) end)
UberUI:RegisterEvent("ADDON_LOADED")
UberUI:RegisterEvent("PLAYER_LOGIN")
UberUI:RegisterEvent("PLAYER_LOGOUT")

local defaults = {
    statusbars = {
        Blizzard    = "Interface\\AddOns\\Uber UI\\textures\\statusbars\\nameplate",
        BlizzardOld = "Interface\\AddOns\\Uber UI\\textures\\statusbars\\blizzard",
        Minimalist  = "Interface\\AddOns\\Uber UI\\textures\\statusbars\\Minimalist",
        Ace         = "Interface\\AddOns\\Uber UI\\textures\\statusbars\\Ace",
        Aluminum    = "Interface\\AddOns\\Uber UI\\textures\\statusbars\\Aluminum",
        Banto       = "Interface\\AddOns\\Uber UI\\textures\\statusbars\\banto",
        Charcoal    = "Interface\\AddOns\\Uber UI\\textures\\statusbars\\Charcoal",
        Glaze       = "Interface\\AddOns\\Uber UI\\textures\\statusbars\\glaze",
        Litestep    = "Interface\\AddOns\\Uber UI\\textures\\statusbars\\LiteStep",
        Otravi      = "Interface\\AddOns\\Uber UI\\textures\\statusbars\\otravi",
        Perl        = "Interface\\AddOns\\Uber UI\\textures\\statusbars\\perl",
        Smooth      = "Interface\\AddOns\\Uber UI\\textures\\statusbars\\smooth",
        Striped     = "Interface\\AddOns\\Uber UI\\textures\\statusbars\\striped",
        Swag        = "Interface\\AddOns\\Uber UI\\textures\\statusbars\\swag",
        Flat        = "Interface\\AddOns\\Uber UI\\textures\\statusbars\\flat",
    },
    general = {
        classcolorhealth = true;
        darkencolor      = { r = .4, g = .4, b = .4, a = 1 };
        texture          = "Blizzard";
        arenanumbers     = true;
        hidearenaframes  = false;
        border           = "Interface\\AddOns\\Uber UI\\textures\\border";
        hidehotkeys      = false;
        hidemacros       = false;
        hidehonor        = false;
        hiderepcolor     = true;
    }
}

function UberUI:ADDON_LOADED()
    local function initDB(def, tbl, saved)
        if type(def) ~= "table" then return {} end
        if type(tbl) ~= "table" then tbl = {} end
        if type(saved) ~= "table" then saved = {} end
        for k, v in pairs(def) do
            if type(v) == "table" then
                tbl[k] = initDB(v, tbl[k], saved[k])
            elseif type(tbl[k]) ~= "table" and saved[k] ~= nil then -- If saved value exists use it
                tbl[k] = saved[k]
            elseif type(tbl[k]) ~= "table" and saved[k] == nil then -- If saved value does not exist use default
                tbl[k] = v
            end
        end
        return tbl
    end

    uuidb = initDB(defaults, uuidb, UberuiDB)
end

function UberUI:PLAYER_LOGOUT()
    local function updateSave(def, tbl, saved)
        if type(def) ~= "table" then return {} end
        if type(tbl) ~= "table" then tbl = {} end
        if type(saved) ~= "table" then saved = {} end
        for k, v in pairs(tbl) do
            if type(v) == "table" then
                saved[k] = updateSave(def[k], v, saved[k])
            elseif type(saved[k]) ~= "table" and v ~= def[k] then -- If temp value does not equal the default, save it
                saved[k] = v
            elseif type(saved[k]) ~= "table" and v == def[k] and saved[k] ~= def[k] then -- Unset saved value if temp == default and saved value exists
                saved[k] = nil
            elseif type(saved[k]) ~= "table" and saved[k] == def[k] then -- Cleanup if save value happens to == default
                saved[k] = nil
            end
        end
        return saved
    end

    UberuiDB = updateSave(defaults, uuidb, UberuiDB)

    local function cleanupSave(saved)
        for k, v in pairs(saved) do
            if type(v) == "table" and next(v) then
                cleanupSave(v)
            elseif type(v) == "table" and not next(v) then
                saved[k] = nil
            end
        end
        return saved
    end

    UberuiDB = cleanupSave(UberuiDB)
end

-----------------------------
-- SLASH COMMAND
-----------------------------

SlashCmdList.UBERUI = function(msg)
    msg = msg:lower()
    if msg == "options" then
        uuiopt:ShowOptions()
    else
        InterfaceOptionsFrame_OpenToCategory(addon)
        InterfaceOptionsFrame_OpenToCategory(addon)
    end
end
SLASH_UBERUI1 = "/uui"
Slash_UBERUI2 = "/uberui"
