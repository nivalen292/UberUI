
--get the addon namespace
local addon, ns = ...
uui_Buffs = {}

uui_Buffs = CreateFrame("frame")
uui_Buffs:RegisterEvent("PLAYER_LOGIN")
uui_Buffs:SetScript("OnEvent", function(self)

  buff = uuidb.buffdebuff.buff
  debuff = uuidb.buffdebuff.debuff

  --rewrite the oneletter shortcuts
  if uuidb.buffdebuff.oneletterabrev then
    HOUR_ONELETTER_ABBR = "%dh"
    DAY_ONELETTER_ABBR = "%dd"
    MINUTE_ONELETTER_ABBR = "%dm"
    SECOND_ONELETTER_ABBR = "%ds"
  end

  --backdrop debuff
  local backdropDebuff = {
    bgFile = nil,
    edgeFile = debuff.background.edgeFile,
    tile = false,
    tileSize = 32,
    edgeSize = debuff.background.inset,
    insets = {
      left = debuff.background.inset,
      right = debuff.background.inset,
      top = debuff.background.inset,
      bottom = debuff.background.inset,
    },
  }

  --backdrop buff
  local backdropBuff = {
    bgFile = nil,
    edgeFile = buff.background.edgeFile,
    tile = false,
    tileSize = 32,
    edgeSize = buff.background.inset,
    insets = {
      left = buff.background.inset,
      right = buff.background.inset,
      top = buff.background.inset,
      bottom = buff.background.inset,
    },
  }

  local bf = CreateFrame("Frame", "rBFS_BuffDragFrame", UIParent)
  bf:SetSize(buff.button.size,buff.button.size)
  bf:SetPoint(buff.pos.a1,buff.pos.af,buff.pos.a2,buff.pos.x,buff.pos.y)

  if not uuidb.combineBuffsAndDebuffs then
    local df = CreateFrame("Frame", "rBFS_DebuffDragFrame", UIParent)
    df:SetSize(debuff.button.size,debuff.button.size)
    df:SetPoint(debuff.pos.a1,debuff.pos.af,debuff.pos.a2,debuff.pos.x,debuff.pos.y)
  end

  --temp enchant stuff
  applySkin(TempEnchant1)
  applySkin(TempEnchant2)
  applySkin(TempEnchant3)

  --position the temp enchant buttons
  TempEnchant1:ClearAllPoints()
  TempEnchant1:SetPoint("TOPRIGHT", rBFS_BuffDragFrame, "TOPRIGHT", 0, 0) --button will be repositioned later in case temp enchant and consolidated buffs are both available
  TempEnchant2:ClearAllPoints()
  TempEnchant2:SetPoint("TOPRIGHT", TempEnchant1, "TOPLEFT", -buff.colSpacing, 0)
  TempEnchant3:ClearAllPoints()
  TempEnchant3:SetPoint("TOPRIGHT", TempEnchant2, "TOPLEFT", -buff.colSpacing, 0)

  --hook Blizzard functions
  hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", function()
    updateAllBuffAnchors()
    end)
  hooksecurefunc("DebuffButton_UpdateAnchors", function()
    updateDebuffAnchors()
    end)

end)

local ceil, min, max = ceil, min, max
local ShouldShowConsolidatedBuffFrame = ShouldShowConsolidatedBuffFrame

local buffFrameHeight = 0

---------------------------------------
-- FUNCTIONS
---------------------------------------

--apply aura frame texture func
local function applySkin(b)
  if not b or (b and b.styled) then return end
  --button name
  local name = b:GetName()
  --check the button type
  local tempenchant, consolidated, debuff, buff = false, false, false, false
  if (name:match("TempEnchant")) then
    tempenchant = true
  elseif (name:match("Consolidated")) then
    consolidated = true
  elseif (name:match("Debuff")) then
    debuff = true
  else
    buff = true
  end
  --get cfg and backdrop
  local backdrop
  if debuff then
    uui = debuff
    backdrop = backdropDebuff
  else
    uui = buff
    backdrop = backdropBuff
  end

  --check class coloring options
  if uuidb.general.customcolor then
    bordercolor = uuidb.general.customcolorval
    backgroundcolor = uuidb.general.customcolorval
  else
    bordercolor = uui.border.color
    backgroundcolor = uui.border.color
  end

  --button
  b:SetSize(uui.button.size, uui.button.size)

  --icon
  local icon = _G[name.."Icon"]
  if consolidated then
    if select(1,UnitFactionGroup("player")) == "Alliance" then
      icon:SetTexture(select(3,GetSpellInfo(61573)))
    elseif select(1,UnitFactionGroup("player")) == "Horde" then
      icon:SetTexture(select(3,GetSpellInfo(61574)))
    end
  end
  icon:SetTexCoord(0.1,0.9,0.1,0.9)
  icon:ClearAllPoints()
  icon:SetPoint("TOPLEFT", b, "TOPLEFT", -uui.icon.padding, uui.icon.padding)
  icon:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", uui.icon.padding, -uui.icon.padding)
  icon:SetDrawLayer("BACKGROUND",-8)
  b.icon = icon

  --border
  local border = _G[name.."Border"] or b:CreateTexture(name.."Border", "BACKGROUND", nil, -7)
  border:SetTexture(uui.border.texture)
  border:SetTexCoord(0,1,0,1)
  border:SetDrawLayer("BACKGROUND",-7)
  if tempenchant then
    border:SetVertexColor(0.7,0,1)
  elseif not debuff then
    border:SetVertexColor(bordercolor.r, bordercolor.g, bordercolor.b, bordercolor.a)
  end
  border:ClearAllPoints()
  border:SetAllPoints(b)
  b.border = border

  --duration
  b.duration:SetFont(uui.duration.font, uui.duration.size, "THINOUTLINE")
  b.duration:ClearAllPoints()
  b.duration:SetPoint(uui.duration.pos.a1,uui.duration.pos.x,uui.duration.pos.y)

  --count
  b.count:SetFont(uui.count.font, uui.count.size, "THINOUTLINE")
  b.count:ClearAllPoints()
  b.count:SetPoint(uui.count.pos.a1,uui.count.pos.x,uui.count.pos.y)

  --shadow
  if uui.background.show then
    local back = CreateFrame("Frame", nil, b)
    back:SetPoint("TOPLEFT", b, "TOPLEFT", -uui.background.padding, uui.background.padding)
    back:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", uui.background.padding, -uui.background.padding)
    back:SetFrameLevel(b:GetFrameLevel() - 1)
    back:SetBackdrop(backdrop)
    back:SetBackdropBorderColor(backgroundcolor)
    b.bg = back
  end

  --set button styled variable
  b.styled = true
end

--update debuff anchors
local function updateDebuffAnchors(buttonName,index)
  print(buttonName)
  local button = _G[buttonName..index]
  if not button then return end
  --apply skin
  if not button.styled then applySkin(button) end
  --position button
  button:ClearAllPoints()
  if index == 1 then
    --debuffs and buffs are not combined anchor the debuffs to its own frame
    button:SetPoint("TOPRIGHT", rBFS_DebuffDragFrame, "TOPRIGHT", 0, 0)      
  elseif index > 1 and mod(index, debuff.buttonsPerRow) == 1 then
    button:SetPoint("TOPRIGHT", _G[buttonName..(index-debuff.buttonsPerRow)], "BOTTOMRIGHT", 0, -debuff.rowSpacing)
  else
    button:SetPoint("TOPRIGHT", _G[buttonName..(index-1)], "TOPLEFT", -debuff.colSpacing, 0)
  end
end

--update buff anchors
local function updateAllBuffAnchors()
  --variables
  local buttonName  = "BuffButton"
  local numEnchants = BuffFrame.numEnchants
  local numBuffs    = BUFF_ACTUAL_DISPLAY
  local offset      = numEnchants
  local realIndex, previousButton, aboveButton
  --position the tempenchant button depending on the consolidated button status
    TempEnchant1:ClearAllPoints()
    TempEnchant1:SetPoint("TOPRIGHT", rBFS_BuffDragFrame, "TOPRIGHT", 0, 0)

  --calculate the previous button in case tempenchant or consolidated buff are loaded
  if BuffFrame.numEnchants > 0 then
    previousButton = _G["TempEnchant"..numEnchants]
  end

  --calculate the above button in case tempenchant or consolidated buff are loaded
  if numEnchants > 0 then
    aboveButton = TempEnchant1
  end

  --loop on all active buff buttons
  local buffCounter = 0
  for index = 1, numBuffs do
    local button = _G[buttonName..index]
    if not button then return end
    if not button.consolidated then
      buffCounter = buffCounter + 1
      --apply skin
      if not button.styled then applySkin(button) end
      --position button
      button:ClearAllPoints()
      realIndex = buffCounter+offset
      if realIndex == 1 then
        button:SetPoint("TOPRIGHT", rBFS_BuffDragFrame, "TOPRIGHT", 0, 0)
        aboveButton = button
      elseif realIndex > 1 and mod(realIndex, buff.buttonsPerRow) == 1 then
        button:SetPoint("TOPRIGHT", aboveButton, "BOTTOMRIGHT", 0, -buff.rowSpacing)
        aboveButton = button
      else
        button:SetPoint("TOPRIGHT", previousButton, "TOPLEFT", -buff.colSpacing, 0)
      end
      previousButton = button

    end
  end
  --calculate the height of the buff rows for the debuff frame calculation later
  local rows = ceil((buffCounter+offset)/buff.buttonsPerRow)
  local height = buff.button.size*rows + buff.rowSpacing*rows + buff.gap*min(1,rows)
  buffFrameHeight = height
  --make sure the debuff frames update the position asap
end

function uui_Buffs_ReworkAllColor()
  updateDebuffAnchors()
  updateAllBuffAnchors()
end