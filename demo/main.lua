local gfx <const> = playdate.graphics
local MDTree = import 'mdTree'

import "../playout.lua"
 
-- The speed of scrolling via the crank
local CRANK_SCROLL_SPEED <const> = 1.2
-- The current speed modifier for the crank
local crankSpeedModifier = 1
-- The crank offset from before skipScrollTicks was set
local previousCrankOffset = 0
-- The number of ticks to skip modulating the scroll offset
local skipScrollTicks = 0
-- The scroll offset
local offset = 0;

local crankChange = 0

local currentPage

local ctrldFontFamily = {
  [playdate.graphics.font.kVariantNormal] = 'fonts/ctrld/ctrld-fixed-16',
  [playdate.graphics.font.kVariantBold] = 'fonts/ctrld/ctrld-fixed-16b',
  [playdate.graphics.font.kVariantItalic] = 'fonts/ctrld/ctrld-fixed-16i'
}


local scientificaFontFamily = {
  [playdate.graphics.font.kVariantNormal] = 'fonts/scientifica/scientifica-11',
  [playdate.graphics.font.kVariantBold] = 'fonts/scientifica/scientificaBold-11',
  [playdate.graphics.font.kVariantItalic] = 'fonts/scientifica/scientificaItalic-11'
}

local roobertFontFamily = {
  [playdate.graphics.font.kVariantNormal] = 'fonts/roobert/Roobert-11-Medium',
  [playdate.graphics.font.kVariantBold] = 'fonts/roobert/Roobert-11-Bold',
  [playdate.graphics.font.kVariantItalic] = 'fonts/roobert/Roobert-11-Medium-Halved'
}

local UWttyp0FontFamily = {
  [playdate.graphics.font.kVariantNormal] = 'fonts/UW-ttyp0/UW-ttyp0',
  [playdate.graphics.font.kVariantBold] = 'fonts/UW-ttyp0/UW-ttyp0-Bold',
  [playdate.graphics.font.kVariantItalic] = 'fonts/UW-ttyp0/UW-ttyp0-Italic'
}

local leggieFontFamily = {
  [playdate.graphics.font.kVariantNormal] = 'fonts/leggie/leggie-18',
  [playdate.graphics.font.kVariantBold] = 'fonts/leggie/leggie-18b',
  [playdate.graphics.font.kVariantItalic] = 'fonts/leggie/leggie-18bi'
}

local styles = {
  Header1 = {
    padding = 12,
    backgroundColor = gfx.kColorBlack,
    backgroundAlpha = 7 / 8,
    borderLeft = 2,
    font = gfx.font.new('fonts/emerald_20')
  },

  Header3 = {
    padding = 12,
    backgroundColor = gfx.kColorBlack,
    backgroundAlpha = 7 / 8,
    border = 2,
    font = gfx.font.new('fonts/emerald_17')
  },

  BlockQuote = {
    paddingLeft = 25,
    backgroundColor = gfx.kColorWhite,
    borderLeft = 10,
    borderBottom = 2,
    borderTop = 6,
    borderRight = 4,
    --fontFamily = playdate.graphics.font.newFamily(ctrldFontFamily)
  },

  Para = {
    spacing = 12,
    paddingTop = 16,
    paddingLeft = 20,
    --fontFamily = playdate.graphics.font.newFamily(ctrldFontFamily)
  },

  Root = {
    maxWidth = 400,
    backgroundColor = gfx.kColorWhite,
    direction = playout.Vertical,
    vAlign = playout.kAlignStretch,
    scroll = 1,
    padding = 10,
    spacing = 10
  }
}

local inputHandlers = {
  cranked = function(change, acceleratedChange)
    crankChange = change
    if skipScrollTicks > 0 then
      skipScrollTicks = skipScrollTicks - 1
      offset = offset - previousCrankOffset
    else
      offset = offset - change * CRANK_SCROLL_SPEED * crankSpeedModifier
      previousCrankOffset = change * CRANK_SCROLL_SPEED * crankSpeedModifier
    end
    -- print('offset', offset)
  end
}




function setup()
  playdate.inputHandlers.push(inputHandlers)
  
  local json_file = playdate.file.open('planning_pandoc.json', playdate.file.kFileRead)
  local json_table = json.decodeFile(json_file)

  currentPage = MDTree.new(styles, json_table)
  -- currentPage:build()
end

-- frame callback
function playdate.update()
  currentPage:update(crankChange, offset)
end

-- local json_file = playdate.file.open('file.json', playdate.file.kFileWrite)
-- json.encodeToFile(json_file,true, page_table)

setup()
