--[[--------------------------------------------------------------------
	Uber UI
	Darkens default UI
	Maintained by Uberlicious
----------------------------------------------------------------------]]

local addon, ns = ...
uuiopt = {}

local SOUND_OFF = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF
local SOUND_ON = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON

local classcolor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]

local Options = CreateFrame("Frame", "UberUI-Options", InterfaceOptionsFramePanelContainer)
Options.name = GetAddOnMetadata(addon, "Title") or addon
InterfaceOptions_AddCategory(Options)

function uuiopt:ShowOptions()
    InterfaceOptionsFrame_OpenToCategory(Options)
end

Options:Hide()
Options:SetScript("OnShow", function(self)
    local Title = self:CreateFontString("$parentTitle", "ARTWORK", "GameFontNormalHuge")
    Title:SetPoint("TOPLEFT", 16, -16)
    Title:SetText(self.name)

    local SubText = self:CreateFontString("$parentSubText", "ARTWORK", "GameFontHighlightSmall")
    SubText:SetPoint("TOPLEFT", Title, "BOTTOMLEFT", 0, -8)
    SubText:SetPoint("RIGHT", -32, 0)
    SubText:SetHeight(32)
    SubText:SetJustifyH("LEFT")
    SubText:SetJustifyV("TOP")
    SubText:SetText("Darkens and modifies the default blizzard UI.")

    local GeneralCat = self:CreateFontString("$parentGeneralCat", "ARTWORK", "GameFontNormalLarge")
    GeneralCat:SetPoint("TOPLEFT", SubText, "BOTTOMLEFT", 0, -8)
    GeneralCat:SetPoint("RIGHT", -32, 0)
    GeneralCat:SetHeight(32)
    GeneralCat:SetJustifyH("LEFT")
    GeneralCat:SetJustifyV("TOP")
    GeneralCat:SetText("General")

    local Reload = CreateFrame("Button", "$parentReload", self, "UIPanelButtonTemplate")
    Reload:SetPoint("TOPRIGHT", SettingsPanel.CloseButton.Middle, "TOPRIGHT", -15, 50)
    Reload:SetWidth(100)
    Reload:SetHeight(25)
    Reload:SetText("Save & Reload")
    Reload:SetScript("OnClick", function(self, button, down)
        Options:Hide();
        ReloadUI();
    end)

    local Darkness = CreateFrame("Slider", "$parentDarkness", self, "OptionsSliderTemplate")
    Darkness:SetPoint("TOPLEFT", GeneralCat, "BOTTOMLEFT", 0, 2);
    Darkness.Text:SetText("Dark Level");
    Darkness.tooltipText = "Adjust how dark you want the frames";
    _G[Darkness:GetName() .. 'Low']:SetText('Dark');
    _G[Darkness:GetName() .. 'High']:SetText('Light');
    _G[Darkness:GetName() .. 'Text']:SetText("Darkness: " .. uuidb.general.darkencolor.r * 100);
    Darkness:SetWidth(100);
    Darkness:SetHeight(20);
    Darkness:SetMinMaxValues(0, 100);
    Darkness:SetValueStep(5);
    Darkness:SetObeyStepOnDrag(true);
    Darkness:SetValue(uuidb.general.darkencolor.r * 100);
    Darkness:SetOrientation('HORIZONTAL');
    Darkness:SetScript("OnValueChanged", function(self)
        local value = self:GetValue();
        _G[Darkness:GetName() .. 'Text']:SetText("Darkness: " .. value);
        local percent = value / 100;
        uuidb.general.darkencolor.r = percent;
        uuidb.general.darkencolor.g = percent;
        uuidb.general.darkencolor.b = percent;
        UberUI.misc:AllFramesColor()
    end)

    --Bar Texture Option
    local BarTextures = CreateFrame("frame", "$parentBarTextures", self, "UIDropDownMenuTemplate")
    BarTextures:SetPoint("LEFT", Darkness, "RIGHT", 180, 0)
    BarTextures.text = BarTextures:CreateFontString(nil, nil, "GameFontHighlight")
    BarTextures.text:SetPoint("LEFT", BarTextures, "RIGHT", -15, 24)
    BarTextures.text:SetText("Bar Textures (requires reload when reverting to Blizzard)")
    BarTextures.tooltipText = "Changing and reverting to Blizzard requires a reload"
    function BarTextures:SetValue(value)
        local texture = value;
        uuidb.general.texture = texture;
        UIDropDownMenu_SetText(BarTextures, uuidb.general.texture);
        UberUI.misc:AllFramesHealthManaTexture();
    end

    UIDropDownMenu_SetText(BarTextures, uuidb.general.texture)
    UIDropDownMenu_Initialize(BarTextures, function(self, tex)
        local info = UIDropDownMenu_CreateInfo()
        info.func = self.SetValue
        info.text, info.arg1 = "Blizzard", "Blizzard"
        UIDropDownMenu_AddButton(info)
        info.text, info.arg1 = "Minimalist", "Minimalist"
        UIDropDownMenu_AddButton(info)
        info.text, info.arg1 = "Ace", "Ace"
        UIDropDownMenu_AddButton(info)
        info.text, info.arg1 = "Aluminum", "Aluminum"
        UIDropDownMenu_AddButton(info)
        info.text, info.arg1 = "Banto", "Banto"
        UIDropDownMenu_AddButton(info)
        info.text, info.arg1 = "Charcoal", "Charcoal"
        UIDropDownMenu_AddButton(info)
        info.text, info.arg1 = "Glaze", "Glaze"
        UIDropDownMenu_AddButton(info)
        info.text, info.arg1 = "Litestep", "Litestep"
        UIDropDownMenu_AddButton(info)
        info.text, info.arg1 = "Otravi", "Otravi"
        UIDropDownMenu_AddButton(info)
        info.text, info.arg1 = "Perl", "Perl"
        UIDropDownMenu_AddButton(info)
        info.text, info.arg1 = "Smooth", "Smooth"
        UIDropDownMenu_AddButton(info)
        info.text, info.arg1 = "Striped", "Striped"
        UIDropDownMenu_AddButton(info)
        info.text, info.arg1 = "Swag", "Swag"
        UIDropDownMenu_AddButton(info)
        info.text, info.arg1 = "Flat", "Flat"
        UIDropDownMenu_AddButton(info)
    end)

    local ClassColorHealth = CreateFrame("CheckButton", "$parentClassColorHealth", self,
        "InterfaceOptionsCheckButtonTemplate")
    ClassColorHealth:SetPoint("TOPLEFT", Darkness, "BOTTOMLEFT", 0, -24)
    ClassColorHealth.Text:SetText("Class Color Unit Health")
    ClassColorHealth.tooltipText = "Changes Frame Health to units class color. (disable requires reload)"
    ClassColorHealth:SetScript("OnClick", function(this)
        local checked = not not this:GetChecked()
        PlaySound(checked and SOUND_ON or SOUND_OFF)
        uuidb.general.classcolorhealth = checked
        if uuidb.general.classcolorhealth then
            DEFAULT_CHAT_FRAME:AddMessage("Class Colors Enabled", 0, 1, 0)
            UberUI.misc:AllFramesHealthColor()
        else
            DEFAULT_CHAT_FRAME:AddMessage("Class Colors Disabled", 1, 0, 0)
            UberUI.misc:AllFramesHealthColor()
        end
    end)

    local ArenaNumbers = CreateFrame("CheckButton", "$parentArenaNumbers", self,
        "InterfaceOptionsCheckButtonTemplate")
    ArenaNumbers:SetPoint("TOPLEFT", ClassColorHealth, "BOTTOMLEFT", 0, -12)
    ArenaNumbers.Text:SetText("Arena Nameplate Numbers")
    ArenaNumbers.tooltipText = "Use arena target number (1,2,3) instead of names on nameplate in arenas"
    ArenaNumbers:SetScript("OnClick", function(this)
        local checked = not not this:GetChecked()
        PlaySound(checked and SOUND_ON or SOUND_OFF)
        uuidb.general.arenanumbers = checked;
        UberUI.arenaframes:NameplateNumbers();
    end)

    local HideArenaFrames = CreateFrame("CheckButton", "$parentHideArenaFrames", self,
        "InterfaceOptionsCheckButtonTemplate")
    HideArenaFrames:SetPoint("TOPLEFT", ArenaNumbers, "BOTTOMLEFT", 0, -12)
    HideArenaFrames.Text:SetText("Hide Arena Frames")
    HideArenaFrames.tooltipText = "Completely hide default blizzard arena frames"
    HideArenaFrames:SetScript("OnClick", function(this)
        local checked = not not this:GetChecked()
        PlaySound(checked and SOUND_ON or SOUND_OFF)
        uuidb.general.hidearenaframes = checked;
        UberUI.arenaframes:HideArena();
    end)

    function self:refresh()
        ClassColorHealth:SetChecked(uuidb.general.classcolorhealth)
        ArenaNumbers:SetChecked(uuidb.general.arenanumbers)
    end

    self:refresh()
    self:SetScript("OnShow", nil)
end)
