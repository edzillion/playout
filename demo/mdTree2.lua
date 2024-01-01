import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx <const> = playdate.graphics

import "../playout.lua"

local mdTree = {}
-- private methods
local mdTreeMethods = {}

function mdTreeMethods.createTree(self, ui)
  local box = ui.box
  local image = ui.image
  local text = ui.text

  return box({
    maxWidth = 400,
    backgroundColor = gfx.kColorWhite,
    direction = playout.Vertical,
    vAlign = playout.kAlignStretch,
    scroll = 1,
    padding = 10
  }, {
    box({ style = self.styles.header1 }, { text("HEADING 1") }),
    box({ style = self.styles.blockquote }, { 
      text("This is a blockquote, it is inheriting it's style from it's parent Box"),
      text(""),
      text(
        "This is a further blockquote, merged into the same parent as the previous two.2222222222 2222 2222222222222222434543 5343 63543 54 35 654543 3"
      )
    }),
    box({ style = self.styles.header3 }, { text("HEADING 3") }),
    box({ style = self.styles.paragraph }, { text(
      "Detailed prior planning is essential in potential survival situations. Including survival considerations in mission planning will enhance your chances of survival if an emergency occurs. For example, if your job requires that you work in a small, enclosed area that limits what you can carry on your person, plan where you can put your rucksack or your load-bearing equipment (LBE). **Put it where it will not prevent you from getting out of the area quickly, yet where it is readily accessible.**"
    ) })
  }
  )
end

function mdTreeMethods:build()
  -- build tree
  self.tree = playout.tree:build(self, self.createTree)
  self.tree:computeTabIndex()
  
  local treeImg  = self.tree:draw()
  self.treeSprite     = gfx.sprite.new(treeImg)
  local treeRect  = self.treeSprite:getBoundsRect()
  local anchor   = getRectAnchor(treeRect, playout.kAnchorTopLeft)

  self.treeSprite:moveTo(-anchor.x, -anchor.y)
  self.treeSprite:add()
end

-- frame callback
function mdTreeMethods:update(crankChange, crankOffset)
  if crankChange ~= 0 then
    local treePosition = { x = self.treeSprite.x, y = self.treeSprite.y }
    if self.tree.scrollTarget then
      if self.tree.scrollTarget.properties.direction == playout.kDirectionHorizontal then
        treePosition.x = (self.treeSprite.width / 2) + crankOffset
      else
        treePosition.y = (self.treeSprite.height / 2) + crankOffset
      end
    end

    self.treeSprite:moveTo(treePosition.x, treePosition.y)
  end
  self.treeSprite:update()

  playdate.timer.updateTimers()
  playdate.drawFPS()
end

mdTree.new = function(styles)
  local mdt = {
    styles = styles,
    tree = nil,
    treeSprite = nil
  }
  local t = setmetatable(mdt, { __index = mdTreeMethods })
  t:build()
  return t
end

return mdTree
