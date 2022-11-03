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

local Options = CreateFrame("Frame", "UberUIOptions", InterfaceOptionsFramePanelContainer)
Options.name = GetAddOnMetadata(addon, "Title") or addon
InterfaceOptions_AddCategory(Options)

function uuiopt:ShowOptions()
    InterfaceOptionsFrame_OpenToCategory(Options)
end

Options:Hide()
Options:SetScript("OnShow", function(self)
    local SettingsList = CreateFrame("Frame", "UberUI", Options, "SettingsListTemplate")
    SettingsList:SetAllPoints();
    SettingsList.Header.Title:SetText("Uber UI")
    SettingsList.Header.DefaultsButton.Text:SetText("Reload UI");
    SettingsList.ScrollBox:SetScrollTargetOffset(10);
    SettingsList.Header.DefaultsButton:SetScript("OnClick", function()
        Options:Hide();
        ReloadUI();
    end)

    local scrollTarget = SettingsList.ScrollBox.ScrollTarget;
    scrollTarget:SetPoint("TOPLEFT", SettingsList.ScrollBox, "TOPLEFT", 0, -10);
    scrollTarget:SetPoint("TOPRIGHT", SettingsList.ScrollBox, "TOPRIGHT", 0, -10);

    local Darkness = CreateFrame("Frame", nil, scrollTarget, "SettingsSliderControlTemplate")
    local text = "Set your desired level of darkness"
    local val = (uuidb.general.darkencolor.r * 100)
    Darkness:SetPoint("TOPLEFT", scrollTarget, "TOPLEFT", 0, 0);
    Darkness:SetPoint("TOPRIGHT", scrollTarget, "TOPRIGHT", 0, 0);
    Darkness.Text:SetText("Darkness Level");
    Darkness.Text:SetPoint("LEFT", Darkness, "LEFT", 37, 0);
    Darkness.Text:SetPoint("RIGHT", Darkness, "CENTER", -85, 0);
    Darkness.Tooltip:SetPoint("TOPLEFT", Darkness, "TOPLEFT", 0, 0);
    Darkness.Tooltip:SetPoint("BOTTOMRIGHT", Darkness, "BOTTOM", -80, 0);
    Darkness.Tooltip.tooltipText = text;
    Darkness.SliderWithSteppers:Init(val, 0, 100, 20);
    Darkness.SliderWithSteppers.RightText:Show();
    Darkness.SliderWithSteppers.RightText:SetText(val);
    Darkness.SliderWithSteppers.Slider.tooltipText = text;
    Darkness.SliderWithSteppers.Slider:HookScript("OnValueChanged", function(self, value)
        self:GetParent().RightText:SetText(value)
        local percent = value / 100;
        uuidb.general.darkencolor.r = percent;
        uuidb.general.darkencolor.g = percent;
        uuidb.general.darkencolor.b = percent;
        UberUI.misc:AllFramesColor()
    end)

    local BarTexture = CreateFrame("Frame", nil, scrollTarget, "SettingsTextDropDownControlTemplate")
    local text = "Set your desired status bar texture for health & mana bars"
    BarTexture:SetPoint("TOPLEFT", scrollTarget, "TOPLEFT", 0, -35);
    BarTexture:SetPoint("TOPRIGHT", scrollTarget, "TOPRIGHT", 0, -35);
    BarTexture.Text:SetText("Status Bar Texture");
    BarTexture.Text:SetPoint("LEFT", BarTexture, "LEFT", 37, 0);
    BarTexture.Text:SetPoint("RIGHT", BarTexture, "CENTER", -85, 0);
    BarTexture.Tooltip:SetPoint("TOPLEFT", BarTexture, "TOPLEFT", 0, 0);
    BarTexture.Tooltip:SetPoint("BOTTOMRIGHT", BarTexture, "BOTTOM", -80, 0);
    BarTexture.Tooltip.tooltipText = text;
    BarTexture.DropDown.Button.tooltipText = text;
    BarTexture.DropDown.Button.selections = {}
    for i in pairs(uuidb.statusbars) do
        tinsert(BarTexture.DropDown.Button.selections, { value = "" .. i, tooltip = nil, label = "" .. i })
    end
    BarTexture.DropDown.Button.selectedIndex = 1;
    BarTexture.DropDown.Button:UpdatePopout();
    BarTexture:SetValue(uuidb.general.texture);
    hooksecurefunc(BarTexture.DropDown.Button, "SetSelectedIndex", function(self, index)
        local val = self.selections[index].value;
        uuidb.general.texture = val;
        UberUI.misc:AllFramesHealthManaTexture();
    end)

    local ClassColorHealth = CreateFrame("CheckButton", nil, scrollTarget, "SettingsCheckBoxControlTemplate")
    local text = "Class Color all health bar textures";
    ClassColorHealth:SetPoint("TOPLEFT", scrollTarget, "TOPLEFT", 0, -70);
    ClassColorHealth:SetPoint("TOPRIGHT", scrollTarget, "TOPRIGHT", 0, -70);
    ClassColorHealth.Text:SetText("Class Color Health Bars");
    ClassColorHealth.Text:SetPoint("LEFT", ClassColorHealth, "LEFT", 37, 0);
    ClassColorHealth.Text:SetPoint("RIGHT", ClassColorHealth, "CENTER", -85, 0);
    ClassColorHealth.Tooltip:SetPoint("TOPLEFT", ClassColorHealth, "TOPLEFT", 0, 0);
    ClassColorHealth.Tooltip:SetPoint("BOTTOMRIGHT", ClassColorHealth, "BOTTOM", -80, 0);
    ClassColorHealth.Tooltip.tooltipText = text;
    ClassColorHealth.CheckBox.tooltipText = text;
    ClassColorHealth.CheckBox:SetScript("OnClick", function(self, value, down)
        uuidb.general.classcolorhealth = not uuidb.general.classcolorhealth;
        UberUI.misc:AllFramesHealthColor();
    end)

    local ArenaNameplateNumbers = CreateFrame("CheckButton", nil, scrollTarget, "SettingsCheckBoxControlTemplate")
    local text = "Change name on arena nameplate frames to target number";
    ArenaNameplateNumbers:SetPoint("TOPLEFT", scrollTarget, "TOPLEFT", 0, -105);
    ArenaNameplateNumbers:SetPoint("TOPRIGHT", scrollTarget, "TOPRIGHT", 0, -105);
    ArenaNameplateNumbers.Text:SetText("Arena Nameplate Numbers");
    ArenaNameplateNumbers.Text:SetPoint("LEFT", ArenaNameplateNumbers, "LEFT", 37, 0);
    ArenaNameplateNumbers.Text:SetPoint("RIGHT", ArenaNameplateNumbers, "CENTER", -85, 0);
    ArenaNameplateNumbers.Tooltip:SetPoint("TOPLEFT", ArenaNameplateNumbers, "TOPLEFT", 0, 0);
    ArenaNameplateNumbers.Tooltip:SetPoint("BOTTOMRIGHT", ArenaNameplateNumbers, "BOTTOM", -80, 0);
    ArenaNameplateNumbers.Tooltip.tooltipText = text;
    ArenaNameplateNumbers.CheckBox.tooltipText = text;
    ArenaNameplateNumbers.CheckBox:SetScript("OnClick", function(self, value, down)
        uuidb.general.arenanumbers = not uuidb.general.arenanumbers;
        UberUI.arenaframes:NameplateNumbers();
    end)

    local HideArenaFrames = CreateFrame("CheckButton", nil, scrollTarget, "SettingsCheckBoxControlTemplate")
    local text = "Force hide default blizzard arena frames";
    HideArenaFrames:SetPoint("TOPLEFT", scrollTarget, "TOPLEFT", 0, -140);
    HideArenaFrames:SetPoint("TOPRIGHT", scrollTarget, "TOPRIGHT", 0, -140);
    HideArenaFrames.Text:SetText("Hide Arena Frames");
    HideArenaFrames.Text:SetPoint("LEFT", HideArenaFrames, "LEFT", 37, 0);
    HideArenaFrames.Text:SetPoint("RIGHT", HideArenaFrames, "CENTER", -85, 0);
    HideArenaFrames.Tooltip:SetPoint("TOPLEFT", HideArenaFrames, "TOPLEFT", 0, 0);
    HideArenaFrames.Tooltip:SetPoint("BOTTOMRIGHT", HideArenaFrames, "BOTTOM", -80, 0);
    HideArenaFrames.Tooltip.tooltipText = text;
    HideArenaFrames.CheckBox.tooltipText = text;
    HideArenaFrames.CheckBox:SetScript("OnClick", function(self, value, down)
        uuidb.general.hidearenaframes = not uuidb.general.hidearenaframes;
        UberUI.arenaframes:HideArena();
    end)

    local HideHotKeys = CreateFrame("CheckButton", nil, scrollTarget, "SettingsCheckBoxControlTemplate")
    local text = "Hide hotkey text on actionbars";
    HideHotKeys:SetPoint("TOPLEFT", scrollTarget, "TOPLEFT", 0, -175);
    HideHotKeys:SetPoint("TOPRIGHT", scrollTarget, "TOPRIGHT", 0, -175);
    HideHotKeys.Text:SetText("Hide HotKey Text");
    HideHotKeys.Text:SetPoint("LEFT", HideHotKeys, "LEFT", 37, 0);
    HideHotKeys.Text:SetPoint("RIGHT", HideHotKeys, "CENTER", -85, 0);
    HideHotKeys.Tooltip:SetPoint("TOPLEFT", HideHotKeys, "TOPLEFT", 0, 0);
    HideHotKeys.Tooltip:SetPoint("BOTTOMRIGHT", HideHotKeys, "BOTTOM", -80, 0);
    HideHotKeys.Tooltip.tooltipText = text;
    HideHotKeys.CheckBox.tooltipText = text;
    HideHotKeys.CheckBox:SetScript("OnClick", function(self, value, down)
        uuidb.general.hidehotkeys = not uuidb.general.hidehotkeys;
        UberUI.actionbars:Color();
    end)

    local HideMacros = CreateFrame("CheckButton", nil, scrollTarget, "SettingsCheckBoxControlTemplate")
    local text = "Hide macro text on actionbars";
    HideMacros:SetPoint("TOPLEFT", scrollTarget, "TOPLEFT", 0, -210);
    HideMacros:SetPoint("TOPRIGHT", scrollTarget, "TOPRIGHT", 0, -210);
    HideMacros.Text:SetText("Hide Macro Text");
    HideMacros.Text:SetPoint("LEFT", HideMacros, "LEFT", 37, 0);
    HideMacros.Text:SetPoint("RIGHT", HideMacros, "CENTER", -85, 0);
    HideMacros.Tooltip:SetPoint("TOPLEFT", HideMacros, "TOPLEFT", 0, 0);
    HideMacros.Tooltip:SetPoint("BOTTOMRIGHT", HideMacros, "BOTTOM", -80, 0);
    HideMacros.Tooltip.tooltipText = text;
    HideMacros.CheckBox.tooltipText = text;
    HideMacros.CheckBox:SetScript("OnClick", function(self, value, down)
        uuidb.general.hidemacros = not uuidb.general.hidemacros;
        UberUI.actionbars:Color();
    end)

    local HideHonor = CreateFrame("CheckButton", nil, scrollTarget, "SettingsCheckBoxControlTemplate")
    local text = "Force hide player / target honor icons even in pvp";
    HideHonor:SetPoint("TOPLEFT", scrollTarget, "TOPLEFT", 0, -245);
    HideHonor:SetPoint("TOPRIGHT", scrollTarget, "TOPRIGHT", 0, -245);
    HideHonor.Text:SetText("Hide Honor Icons");
    HideHonor.Text:SetPoint("LEFT", HideHonor, "LEFT", 37, 0);
    HideHonor.Text:SetPoint("RIGHT", HideHonor, "CENTER", -85, 0);
    HideHonor.Tooltip:SetPoint("TOPLEFT", HideHonor, "TOPLEFT", 0, 0);
    HideHonor.Tooltip:SetPoint("BOTTOMRIGHT", HideHonor, "BOTTOM", -80, 0);
    HideHonor.Tooltip.tooltipText = text;
    HideHonor.CheckBox.tooltipText = text;
    HideHonor.CheckBox:SetScript("OnClick", function(self, value, down)
        uuidb.general.hidehonor = not uuidb.general.hidehonor;
        if (uuidb.general.hidehonor) then
            UberUI.playerframes:PvPIcon();
            UberUI.targetframes:PvPIcon();
        else
            UberUI.playerframes:PvPIcon(true);
            UberUI.targetframes:PvPIcon(true);
        end
    end)

    local HideRepColor = CreateFrame("CheckButton", nil, scrollTarget, "SettingsCheckBoxControlTemplate")
    local text = "Hide colored bar at the top of the target frame";
    HideRepColor:SetPoint("TOPLEFT", scrollTarget, "TOPLEFT", 0, -280);
    HideRepColor:SetPoint("TOPRIGHT", scrollTarget, "TOPRIGHT", 0, -280);
    HideRepColor.Text:SetText("Hide Target Reputation Color");
    HideRepColor.Text:SetPoint("LEFT", HideRepColor, "LEFT", 37, 0);
    HideRepColor.Text:SetPoint("RIGHT", HideRepColor, "CENTER", -85, 0);
    HideRepColor.Tooltip:SetPoint("TOPLEFT", HideRepColor, "TOPLEFT", 0, 0);
    HideRepColor.Tooltip:SetPoint("BOTTOMRIGHT", HideRepColor, "BOTTOM", -80, 0);
    HideRepColor.Tooltip.tooltipText = text;
    HideRepColor.CheckBox.tooltipText = text;
    HideRepColor.CheckBox:SetScript("OnClick", function(self, value, down)
        uuidb.general.hiderepcolor = not uuidb.general.hiderepcolor;
        UberUI.targetframes:Color();
    end)

    function self:refresh()
        ClassColorHealth:SetValue(uuidb.general.classcolorhealth);
        ArenaNameplateNumbers:SetValue(uuidb.general.arenanumbers);
        HideArenaFrames:SetValue(uuidb.general.hidearenaframes);
        HideHotKeys:SetValue(uuidb.general.hidehotkeys)
        HideMacros:SetValue(uuidb.general.hidemacros)
        HideHonor:SetValue(uuidb.general.hidehonor)
        HideRepColor:SetValue(uuidb.general.hiderepcolor)
    end

    self:refresh()
    self:SetScript("OnShow", nil)
end)
