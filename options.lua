--[[--------------------------------------------------------------------
	Lorti UI
	Darkens default UI
	Maintained by Uberlicious
----------------------------------------------------------------------]]

local addon, ns = ...

local SOUND_OFF = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF
local SOUND_ON = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON

local Options = CreateFrame("Frame", "LortiUI-DevOptions", InterfaceOptionsFramePanelContainer)
Options.name = GetAddOnMetadata(addon, "Title") or addon
InterfaceOptions_AddCategory(Options)

function ns.ShowOptions()
	InterfaceOptionsFrame_OpenToCategory(Options)
end

Options:Hide()
Options:SetScript("OnShow", function(self)
	local Title = self:CreateFontString("$parentTitle", "ARTWORK", "GameFontNormalLarge")
	Title:SetPoint("TOPLEFT", 16, -16)
	Title:SetText(self.name)

	local SubText = self:CreateFontString("$parentSubText", "ARTWORK", "GameFontHighlightSmall")
	SubText:SetPoint("TOPLEFT", Title, "BOTTOMLEFT", 0, -8)
	SubText:SetPoint("RIGHT", -32, 0)
	SubText:SetHeight(32)
	SubText:SetJustifyH("LEFT")
	SubText:SetJustifyV("TOP")
	SubText:SetText("Darkens the default blizzard UI. Note: All options currently require /reload to update")

	local Gryphon = CreateFrame("CheckButton", "$parentGryphon", self, "InterfaceOptionsCheckButtonTemplate")
	Gryphon:SetPoint("TOPLEFT", SubText, "BOTTOMLEFT", 0, -12)
	Gryphon.Text:SetText("Show Gryphons")
	Gryphon.tooltipText = "Shows the gryphons on the sides of actionbars. (Requires Reload)"
	Gryphon:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		UberuiDB.Gryphon = checked
	end)

	local Hotkey = CreateFrame("CheckButton", "$parentHotkey", self, "InterfaceOptionsCheckButtonTemplate")
	Hotkey:SetPoint("TOPLEFT", Gryphon, "BOTTOMLEFT", 0, -12)
	Hotkey.Text:SetText("Show Hotkeys")
	Hotkey.tooltipText = "Shows the Hotkeys on the actionbar buttons. (Requires Reload)"
	Hotkey:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		UberuiDB.Hotkey = checked
	end)

	local Macroname = CreateFrame("CheckButton", "$parentMacroname", self, "InterfaceOptionsCheckButtonTemplate")
	Macroname:SetPoint("TOPLEFT", Hotkey, "BOTTOMLEFT", 0, -12)
	Macroname.Text:SetText("Show Macronames")
	Macroname.tooltipText = "Shows the Macronames on the actionbar buttons. (Requires Reload)"
	Macroname:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		UberuiDB.Macroname = checked
	end)


	function self:refresh()
		Gryphon:SetChecked(UberuiDB.Gryphon)
		Hotkey:SetChecked(UberuiDB.Hotkey)
		Macroname:SetChecked(UberuiDB.Macroname)
	end

	self:refresh()
	self:SetScript("OnShow", nil)
end)