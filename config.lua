
-- // Uber UI
-- // Uberlicious - 2018

-----------------------------
-- INIT
-----------------------------

--get the addon namespace
local addon, ns = ...
uuidb = {}

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
  textures = {
    buttons = {
      normal            = "Interface\\AddOns\\Uber UI\\textures\\gloss",
      light             = "Interface\\AddOns\\Uber UI\\textures\\glosslight",
      flash             = "Interface\\AddOns\\Uber UI\\textures\\flash",
      hover             = "Interface\\AddOns\\Uber UI\\textures\\hover",
      pushed            = "Interface\\AddOns\\Uber UI\\textures\\pushed",
      checked           = "Interface\\AddOns\\Uber UI\\textures\\checked",
      equipped          = "Interface\\AddOns\\Uber UI\\textures\\gloss_grey",
      buttonback        = "Interface\\AddOns\\Uber UI\\textures\\button_backgroundlight",
      buttonbackflat    = "Interface\\AddOns\\Uber UI\\textures\\button_background_flat",
      outer_shadow      = "Interface\\AddOns\\Uber UI\\textures\\outer_shadow",
    },
    targetframebig = {
      targetingframe    = "Interface\\AddOns\\Uber UI\\textures\\target\\targetingframebig",
      elite             = "Interface\\Addons\\Uber UI\\textures\\target\\elitebig",
      rareelite         = "Interface\\Addons\\Uber UI\\textures\\target\\rare-elitebig",
      rare              = "Interface\\AddOns\\Uber UI\\textures\\target\\rarebig",
    },
    targetframe = {
      targetingframe    = "Interface\\AddOns\\Uber UI\\textures\\target\\targetingframe",
      elite             = "Interface\\Addons\\Uber UI\\textures\\target\\elite",
      rareelite         = "Interface\\Addons\\Uber UI\\textures\\target\\rare-elite",
      rare              = "Interface\\AddOns\\Uber UI\\textures\\target\\rare",
    },
    other = {
      smalltarget       = "Interface\\AddOns\\Uber UI\\textures\\target\\smalltargetingframe",
      party             = "Interface\\AddOns\\Uber UI\\textures\\partyframe",
      tot               = "Interface\\AddOns\\Uber UI\\textures\\target\\targetoftargetframe",
    },
  },
  general = {
    classcolorhealth  = true,
    classcolorframes  = false,
    customcolor       = false,
    customcolorval    = {r = classcolor.r, g = classcolor.g, b = classcolor.b, a = 1},
    font              = STANDARD_TEXT_FONT,
    pvpicons          = false,
  },
  mainmenu = {
    gryphon           = true,
    microbuttonbar    = true,
    mainbarcolor      = {r = .1, g = .1, b =.1, a = 1},
    gryphcolor        = {r = .15, g = .15, b = .15, a = 1}
  },
  playerframe = {
    largehealth       = true,
    scale             = 1.2,
    color             = {r = .05, g = .05, b =.05, a = 1},
    name              = false
  },
  targetframe = {
    largehealth       = true,
    scale             = 1.2,
    color             = {r = .05, g = .05, b =.05, a = 1},
    name              = true,
    colortargett      = false,
    colorfocust       = false,
    colortott         = false,
  },
  minimap = {
    color             = {r = .05, g = .05, b =.05, a = 1},
  },
  buffdebuff = {
    oneletterabbrev   = true,
    tooltipscale      = 1.2,
    buffsanddebuffs   = false,
    buff = {
      pos               = {a1 = "TOPRIGHT", af = "Minimap", a2 = "TOPLEFT", x = -35, y = 0 },
      gap               = 30,
      locked            = true,
      rowspacing        = 10,
      colspacing        = 7,
      buttonsperrow     = 10,
      button = {
        size            = 28,
      },
      icon = {
        padding         = -2,
      },
      border = {
        texture         = "Interface\\AddOns\\Uber UI\\textures\\gloss",
        color           = {r = .04, g = .35, b = .35, a = 1},
      },
      background = {
        show            = true,
        edgefile        = "Interface\\AddOns\\Uber UI\\textures\\outer_shadow",
        color           = {r = 0, g = 0, b = 0, a = .9},
        inset           = 6,
        padding         = 4,
      },
      duration = {
        font            = STANDARD_TEXT_FONT,
        size            = 11,
        pos             = {a1 = "BOTTOM", x = 0, y = 0}
      },
      count = {
        font            = STANDARD_TEXT_FONT,
        size            = 11,
        pos             = {a1 = "TOPRIGHT", x = 0, y = 0}
      },
    },
    debuff = {
      pos               = {a1 = "TOPRIGHT", af = "Minimap", a2 = "TOPLEFT", x = -35, y = 0 },
      gap               = 30,
      locked            = true,
      rowspacing        = 10,
      colspacing        = 7,
      buttonsperrow     = 10,
      button = {
        size            = 28,
      },
      icon = {
        padding         = -2,
      },
      border = {
        texture         = "Interface\\AddOns\\Uber UI\\textures\\gloss",
        color           = {r = .04, g = .35, b = .35, a = 1},
      },
      background = {
        show            = true,
        edgefile        = "Interface\\AddOns\\Uber UI\\textures\\outer_shadow",
        color           = {r = 0, g = 0, b = 0, a = .9},
        inset           = 6,
        padding         = 4,
      },
      duration = {
        font            = STANDARD_TEXT_FONT,
        size            = 11,
        pos             = {a1 = "BOTTOM", x = 0, y = 0}
      },
      count = {
        font            = STANDARD_TEXT_FONT,
        size            = 11,
        pos             = {a1 = "TOPRIGHT", x = 0, y = 0}
      },
    },
  },
  auras = {
    edgefile            = "Interface\\AddOns\\Uber UI\\textures\\outer_shadow",
    tile                = false,
    tilesize            = 32,
    edgesize            = 4,
    insets              = {l = 4, r = 4, t = 4, b = 4},
    color               = {r = .4, g = .35, b = .35, a = 1},
  },
  actionbars = {
    showbg              = true,
    showshadow          = true,
    useflatbackground   = false,
    backgroundcolor     = {r = .2, g = .2, b = .2, a = .3},
    shadowcolor         = {r = 0, g = 0, b = 0, a = .9},
    bagiconcolor        = {r = 0.4, g = 0.35, b = 0.35, a = 1},
    inset               = 5,
    color = {
      normal            = {r = .37, g = .3, b = .3, a = 1},
      equipped          = {r = .1, g = .5, b = .1, a = 1},
    },
    hotkeys = {
      show              = true,
      fontsize          = 12,
      pos1              = {a1 = "TOPRIGHT", x = 0, y = 0},
      pos2              = {a1 = "TOPLEFT", x = 0, y = 0},
    },
    macroname = {
      show              = true,
      fontsize          = 12,
      pos1              = {a1 = "BOTTOMLEFT", x = 0, y = 0},
      pos2              = {a1 = "BOTTOMRIGHT", x = 0, y = 0},
    },
    count = {
      show              = true,
      fontsize          = 12,
      pos               = {a1 = "TOPRIGHT", x = 0, y = 0},
    },
    cooldown = {
      spacing           = 0,
    }
  },
  miscframes = {
    partycolort         = false,
    raidgroupcolor      = true,
    raidsinglecolor     = true,
    arenaframescolor    = {r = .05, g = .05, b = .05, a = 1},
    misccolor           = {r = .05, g = .05, b = .05, a = 1},
  },
}

function UberUI:ADDON_LOADED()
   local function initDB(def, tbl, saved)
      if type(def) ~= "table" then return {} end
      if type(tbl) ~= "table" then tbl = {} end
      if type(saved) ~= "table" then saved = {} end
      for k,v in pairs(def) do
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
   --self:UnregisterEvent("ADDON_LOADED")
end

function UberUI:PLAYER_LOGOUT()
  local function updateSave(def, tbl, saved)
    if type(def) ~= "table" then return {} end
    if type(tbl) ~= "table" then tbl = {} end
    if type(saved) ~= "table" then saved = {} end
    for k,v in pairs(tbl) do
      if type(v) == "table" then
        saved[k] = updateSave(def[k], v, saved[k])
      elseif type(saved[k]) ~= type(v) and v ~= def[k] then -- If temp value does not equal the default, save it
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
end

  -----------------------------
  -- CONFIG
  -----------------------------

-- action bars settings
--  cfg.textures = {
--    normal            = "Interface\\AddOns\\Uber UI\\textures\\gloss",
--    light             = "Interface\\AddOns\\Uber UI\\textures\\glosslight",
--    flash             = "Interface\\AddOns\\Uber UI\\textures\\flash",
--    hover             = "Interface\\AddOns\\Uber UI\\textures\\hover",
--    pushed            = "Interface\\AddOns\\Uber UI\\textures\\pushed",
--    checked           = "Interface\\AddOns\\Uber UI\\textures\\checked",
--    equipped          = "Interface\\AddOns\\Uber UI\\textures\\gloss_grey",
--    buttonback        = "Interface\\AddOns\\Uber UI\\textures\\button_backgroundlight",
--    buttonbackflat    = "Interface\\AddOns\\Uber UI\\textures\\button_background_flat",
--    outer_shadow      = "Interface\\AddOns\\Uber UI\\textures\\outer_shadow",
--  }
--
--  cfg.targetframebig  = {
--    targetingframe    = "Interface\\AddOns\\Uber UI\\textures\\target\\targetingframebig",
--    elite             = "Interface\\Addons\\Uber UI\\textures\\target\\elitebig",
--    rareelite         = "Interface\\Addons\\Uber UI\\textures\\target\\rare-elitebig",
--    rare              = "Interface\\AddOns\\Uber UI\\textures\\target\\rarebig",
--}
--
--  cfg.targetframe = {
--    targetingframe    = "Interface\\AddOns\\Uber UI\\textures\\target\\targetingframe",
--    elite             = "Interface\\Addons\\Uber UI\\textures\\target\\elite",
--    rareelite         = "Interface\\Addons\\Uber UI\\textures\\target\\rare-elite",
--    rare              = "Interface\\AddOns\\Uber UI\\textures\\target\\rare",
--}
--cfg.background = {
--  showbg            = true,  --show an background image?
--  showshadow        = true,   --show an outer shadow?
--  useflatbackground = false,  --true uses plain flat color instead
--  backgroundcolor   = { r = 0.2, g = 0.2, b = 0.2, a = 0.3},
--  shadowcolor       = { r = 0, g = 0, b = 0, a = 0.9},
--  classcolored      = true,
--  inset             = 5,
--}

--cfg.color = {
--  normal            = { r = 0.37, g = 0.3, b = 0.3, },
--  equipped          = { r = 0.1, g = 0.5, b = 0.1, },
--  classcolored      = true,
--}

--cfg.hotkeys = {
--  show            = true,
--  fontsize        = 12,
--  pos1             = { a1 = "TOPRIGHT", x = 0, y = 0 },
--  pos2             = { a1 = "TOPLEFT", x = 0, y = 0 }, --important! two points are needed to make the hotkeyname be inside of the button
--}

--cfg.macroname = {
--  show            = false,
--  fontsize        = 12,
--  pos1             = { a1 = "BOTTOMLEFT", x = 0, y = 0 },
--  pos2             = { a1 = "BOTTOMRIGHT", x = 0, y = 0 }, --important! two points are needed to make the macroname be inside of the button
--}

--cfg.itemcount = {
--  show            = true,
--  fontsize        = 12,
--  pos1             = { a1 = "BOTTOMRIGHT", x = 0, y = 0 },
--}

--cfg.cooldown = {
--  spacing         = 0,
--}

--cfg.font = STANDARD_TEXT_FONT

----adjust the oneletter abbrev?
--cfg.adjustOneletterAbbrev = true
--
----scale of the consolidated tooltip
--cfg.consolidatedTooltipScale = 1.2
--
----combine buff and debuff frame - should buffs and debuffs be displayed in one single frame?
----if you disable this it is intended that you unlock the buff and debuffs and move them apart!
--cfg.combineBuffsAndDebuffs = false

-- buff frame settings

--cfg.buffFrame = {
--  pos             = { a1 = "TOPRIGHT", af = "Minimap", a2 = "TOPLEFT", x = -35, y = 0 },
--  gap             = 30, --gap between buff and debuff rows
--  userplaced      = true, --want to place the bar somewhere else?
--  rowSpacing      = 10,
--  colSpacing      = 7,
--  buttonsPerRow   = 10,
--  button = {
--    size              = 28,
--  },
--  icon = {
--    padding           = -2,
--  },
--  border = {
--    texture           = "Interface\\AddOns\\Uber UI\\textures\\gloss",
--    color             = { r = 0.4, g = 0.35, b = 0.35, },
--    classcolored      = false,
--  },
--  background = {
--    show              = true,   --show backdrop
--    edgeFile          = "Interface\\AddOns\\Uber UI\\textures\\outer_shadow",
--    color             = { r = 0, g = 0, b = 0, a = 0.9},
--    classcolored      = true,
--    inset             = 6,
--    padding           = 4,
--  },
--  duration = {
--    font              = STANDARD_TEXT_FONT,
--    size              = 11,
--    pos               = { a1 = "BOTTOM", x = 0, y = 0 },
--  },
--  count = {
--    font              = STANDARD_TEXT_FONT,
--    size              = 11,
--    pos               = { a1 = "TOPRIGHT", x = 0, y = 0 },
--  },
--}
--
-- debuff frame settings

--cfg.debuffFrame = {    pos             = { a1 = "TOPRIGHT", af = "Minimap", a2 = "TOPLEFT", x = -35, y = -85 },
--  gap             = 10, --gap between buff and debuff rows
--  userplaced      = true, --want to place the bar somewhere else?
--  rowSpacing      = 10,
--  colSpacing      = 7,
--  buttonsPerRow   = 10,
--  button = {
--    size              = 28,
--  },
--  icon = {
--    padding           = -2,
--  },
--  border = {
--    texture           = "Interface\\AddOns\\Uber UI\\textures\\gloss",
--    color             = { r = 0.4, g = 0.35, b = 0.35, },
--    classcolored      = false,
--  },
--  background = {
--    show              = true,   --show backdrop
--    edgeFile          = "Interface\\AddOns\\Uber UI\\textures\\outer_shadow",
--    color             = { r = 0, g = 0, b = 0, a = 0.9},
--    classcolored      = true,
--    inset             = 6,
--    padding           = 4,
--  },
--  duration = {
--    font              = STANDARD_TEXT_FONT,
--    size              = 11,
--    pos               = { a1 = "BOTTOM", x = 0, y = 0 },
--  },
--  count = {
--    font              = STANDARD_TEXT_FONT,
--    size              = 11,
--    pos               = { a1 = "TOPRIGHT", x = 0, y = 0 },
--  },
--}

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