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
	local Title = self:CreateFontString("$parentTitle", "ARTWORK", "GameFontNormalLarge")
	Title:SetPoint("TOPLEFT", 16, -16)
	Title:SetText(self.name)

	local SubText = self:CreateFontString("$parentSubText", "ARTWORK", "GameFontHighlightSmall")
	SubText:SetPoint("TOPLEFT", Title, "BOTTOMLEFT", 0, -8)
	SubText:SetPoint("RIGHT", -32, 0)
	SubText:SetHeight(32)
	SubText:SetJustifyH("LEFT")
	SubText:SetJustifyV("TOP")
	SubText:SetText("Darkens the default blizzard UI.")

	local Reload = CreateFrame("Button", "$parentReload" , self, "UIPanelButtonTemplate")
	Reload:SetPoint("TOPRIGHT", InterfaceOptionsFrameCancel, "TOPRIGHT", -15, 50)
	Reload:SetWidth(100)
	Reload:SetHeight(25)
	Reload:SetText("Save & Reload")

	Reload:SetScript(
		"OnClick",
		function(self, button, down)
			Options:Hide()
			ReloadUI()
		end
	)

	local Gryphon = CreateFrame("CheckButton", "$parentGryphon", self, "InterfaceOptionsCheckButtonTemplate")
	Gryphon:SetPoint("TOPLEFT", SubText, "BOTTOMLEFT", 0, -12)
	Gryphon.Text:SetText("Show Gryphons")
	Gryphon.tooltipText = "Shows the gryphons on the sides of actionbars."
	Gryphon:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		uuidb.mainmenu.gryphon = checked
		if uuidb.general.customcolor then
			uui_General_MainMenuColor(uuidb.general.customcolorval)
		else
			uui_General_MainMenuColor()
		end
	end)

	local Hotkey = CreateFrame("CheckButton", "$parentHotkey", self, "InterfaceOptionsCheckButtonTemplate")
	Hotkey:SetPoint("TOPLEFT", Gryphon, "BOTTOMLEFT", 0, -12)
	Hotkey.Text:SetText("Show Hotkeys")
	Hotkey.tooltipText = "Shows the Hotkeys on the actionbar buttons."
	Hotkey:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		uuidb.actionbars.hotkey.show = checked
		uui_ActionBars_ReworkAllColors()
	end)

	local Macroname = CreateFrame("CheckButton", "$parentMacroname", self, "InterfaceOptionsCheckButtonTemplate")
	Macroname:SetPoint("TOPLEFT", Hotkey, "BOTTOMLEFT", 0, -12)
	Macroname.Text:SetText("Show Macronames")
	Macroname.tooltipText = "Shows the Macronames on the actionbar buttons."
	Macroname:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		uuidb.actionbars.macroname.show = checked
		uui_ActionBars_ReworkAllColors()
	end)

	local BigFrames = CreateFrame("CheckButton", "$parentBigFrames", self, "InterfaceOptionsCheckButtonTemplate")
	BigFrames:SetPoint("TOPLEFT", Macroname, "BOTTOMLEFT", 0, -12)
	BigFrames.Text:SetText("Big Player / Target Frame")
	BigFrames.tooltipText = "Makes UI Health Bars Larger"
	BigFrames:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		uuidb.playerframe.scale = checked
		if (uuidb.playerframe.scale == 1.2) then
			uuidb.playerframe.scale = 1
			uuidb.targetframe.scale = 1
			uui_General_ColorAllFrames()
		else
			uuidb.playerframe.scale = 1.2
			uuidb.targetframe.scale = 1.2
			uui_General_ColorAllFrames()
		end
	end)

	local LargeHealth = CreateFrame("CheckButton", "$parentLargeHealth", self, "InterfaceOptionsCheckButtonTemplate")
	LargeHealth:SetPoint("TOPLEFT", BigFrames, "BOTTOMLEFT", 0, -12)
	LargeHealth.Text:SetText("Enlarge Health Bars")
	LargeHealth.tooltipText = "Makes UI Health Bars Larger"
	LargeHealth:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		uuidb.playerframe.largehealth = checked
		if uuidb.general.customcolor then
			uui_PlayerFrame_ReworkAllColor(uuidb.general.customcolorval)
		else
			uui_PlayerFrame_ReworkAllColor()
		end
	end)

	local ClassColorFrames = CreateFrame("CheckButton", "$parentClassColorFrames", self, "InterfaceOptionsCheckButtonTemplate")
	ClassColorFrames:SetPoint("TOPLEFT", LargeHealth, "BOTTOMLEFT", 0, -12)
	ClassColorFrames.Text:SetText("Class Color Unitframes")
	ClassColorFrames.tooltipText = "Changes UI from dark to your class color. (requires reload)"
	ClassColorFrames:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		uuidb.general.customcolor = checked
		if UberuiDB.ClassColorFrames then
			DEFAULT_CHAT_FRAME:AddMessage("Class Colors Enabled", 0, 1, 0)
		else
			DEFAULT_CHAT_FRAME:AddMessage("Class Colors Disabled", 1, 0, 0)
		end
		uui_General_ColorAllFrames()
	end)

	local ClassColorHealth = CreateFrame("CheckButton", "$parentClassColorHealth", self, "InterfaceOptionsCheckButtonTemplate")
	ClassColorHealth:SetPoint("TOPLEFT", ClassColorFrames, "BOTTOMLEFT", 0, -12)
	ClassColorHealth.Text:SetText("Class Color Unit Health")
	ClassColorHealth.tooltipText = "Changes Frame Health to units class color. (disable requires reload)"
	ClassColorHealth:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		uuidb.general.classcolorhealth = checked
		if uuidb.general.classcolorhealth then
			DEFAULT_CHAT_FRAME:AddMessage("Class Colors Enabled", 0, 1, 0)
		else
			DEFAULT_CHAT_FRAME:AddMessage("Class Colors Disabled", 1, 0, 0)
		end
		uui_General_ColorAllFrames()
	end)

	local MicroButtonBagBar = CreateFrame("CheckButton", "$parentMicroButtonBagBar", self, "InterfaceOptionsCheckButtonTemplate")
	MicroButtonBagBar:SetPoint("TOPLEFT", ClassColorHealth, "BOTTOMLEFT", 0, -12)
	MicroButtonBagBar.Text:SetText("MicroButtonBagBar Hide")
	MicroButtonBagBar.tooltipText = "Enable / Disable the Bag Bar Menu in the lower right corner."
	MicroButtonBagBar:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		uuidb.mainmenu.microbuttonbar = checked
		uui_General_MicroBar()
	end)

	local Pvpicons = CreateFrame("CheckButton", "$parentPvpicons", self, "InterfaceOptionsCheckButtonTemplate")
	Pvpicons:SetPoint("TOPLEFT", MicroButtonBagBar, "BOTTOMLEFT", 0, -12)
	Pvpicons.Text:SetText("Toggle PVP Icons")
	Pvpicons.tooltipText = "Toggles showing of the Player / Target PVP icons. (will not be colored)"
	Pvpicons:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		uuidb.general.pvpicons = checked
		uui_Misc_pvpicons()
	end)

	local TargetName = CreateFrame("CheckButton", "$parentTargetName", self, "InterfaceOptionsCheckButtonTemplate")
	TargetName:SetPoint("TOPLEFT", Pvpicons, "BOTTOMLEFT", 0, -12)
	TargetName.Text:SetText("Toggle Target Name")
	TargetName.tooltipText = "Toggles showing of target name."
	TargetName:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		uuidb.targetframe.name = checked
		if uuidb.general.customcolor then
			uui_TargetFrame_ReworkAllColor(uuidb.customcolorval)
		else
			uui_TargetFrame_ReworkAllColor()
		end
	end)


	function self:refresh()
		Gryphon:SetChecked(uuidb.mainmenu.gryphon)
		Hotkey:SetChecked(uuidb.actionbars.hotkey.show)
		Macroname:SetChecked(uuidb.actionbars.macroname.show)
		LargeHealth:SetChecked(uuidb.playerframe.largehealth)
		ClassColorFrames:SetChecked((uuidb.general.customcolor and (uuidb.general.customcolorval == default.general.customcolorval)))
		ClassColorHealth:SetChecked(uuidb.general.classcolorhealth)
		BigFrames:SetChecked((uuidb.playerframe.scale == 1.2))
		MicroButtonBagBar:SetChecked(uuidb.mainmenu.microbuttonbar)
		Pvpicons:SetChecked(uuidb.general.pvpicons)
		TargetName:SetChecked(uuidb.targetframe.name)
	end

	self:refresh()
	self:SetScript("OnShow", nil)
end)
