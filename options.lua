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
	SubText:SetText(GetAddOnMetadata(addon, "Notes"))

	local Gryphon = CreateFrame("CheckButton", "$parentGryphons", self, "InterfaceOptionsCheckButtonTemplate")
	Gryphon:SetPoint("TOPLEFT", SubText, "BOTTOMLEFT", 0, -12)
	Gryphon.Text:SetText("Show Gryphons")
	Gryphon.tooltipText = "Shows the gryphons on the sides of actionbars. (Requires Reload)"
	Gryphon:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		UberuiDB.Gryphon = checked
	end)

	function self:refresh()
		Gryphon:SetChecked(UberuiDB.Gryphon)
	end

	self:refresh()
	self:SetScript("OnShow", nil)
end)