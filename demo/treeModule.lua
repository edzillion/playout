import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx <const> = playdate.graphics

import "playout.lua"

local treeModule = {}

local tree
local treeSprite
local pagePadding = 10


local header1 = {
  padding = 12,
  backgroundColor = gfx.kColorBlack,
  backgroundAlpha = 7 / 8,
  border = 2,
  font = gfx.font.new('fonts/diamond_20')
}

local header3 = {
  padding = 12,
  backgroundColor = gfx.kColorBlack,
  backgroundAlpha = 7 / 8,
  border = 2,
  font = gfx.font.new('fonts/diamond_12')
}

local blockquote = {
  paddingLeft = 25,
  backgroundColor = gfx.kColorWhite,
  borderLeft = 10,
  borderBottom = 2,
  borderTop = 6,
  borderRight = 4,
  font = gfx.font.new('fonts/sapphire_14')
}

local paragraph = {
  spacing = 12,
  paddingTop = 16,
  paddingLeft = 20,
  font = gfx.font.new('fonts/sapphire_19')
}



local function createTree(ui)
  local box = ui.box
  local image = ui.image
  local text = ui.text

  return box({
    maxWidth = 380,
    backgroundColor = gfx.kColorWhite,
    border = 2,
    direction = playout.Vertical,
    vAlign = playout.kAlignStretch,
    shadow = 8,
    shadowAlpha = 1 / 3,
    scroll = 1,
    padding = 10
  }, {
    box({ style = header1 }, { text("PLANNING") }),
    box({ style = blockquote }, { text(
      "Survival planning is nothing more than realizing something could happen that would put you in a survival situation and, with that in mind, taking steps to increase your chances of survival."
    ),
      text(""),
      text(
        "Preparation means preparing yourself and your survival kit for those contingencies that you have in your plan. Prepare yourself by making sure your immunizations and dental work are up-to-date. Break in your boots and make sure that the boots have good soles and water-repellent properties. Study the area, climate, terrain, and indigenous methods of food and water procurement. You should continuously assess data, even after the plan is made, to update the plan as necessary and give you the greatest possible chance of survival. Another example of preparation is finding the emergency exits on an aircraft when you board it for a flight. **Practice things that you have planned with the items in your survival kit - get to know your gear. Checking ensures that items work and that you know how to use them.** Build a fire in the rain so you know that when it is critical to get warm, you can do it. Review the medical items in your kit and have instructions printed on their use so that even in times of stress, you will not make life-threatening errors."
      )
    }),
    box({ style = header3 }, { text("IMPORTANCE OF PLANNING") }),
    box({ style = paragraph }, { text(
      "Detailed prior planning is essential in potential survival situations. Including survival considerations in mission planning will enhance your chances of survival if an emergency occurs. For example, if your job requires that you work in a small, enclosed area that limits what you can carry on your person, plan where you can put your rucksack or your load-bearing equipment (LBE). **Put it where it will not prevent you from getting out of the area quickly, yet where it is readily accessible.**"
    )})
  }    
  )
end

treeModule.setup = function()
  -- setup tree
  tree = playout.tree:build(createTree)
  tree:computeTabIndex()
  local treeImg  = tree:draw()
  treeSprite     = gfx.sprite.new(treeImg)
  local treeRect = treeSprite:getBoundsRect()
  local anchor   = getRectAnchor(treeRect, playout.kAnchorTopLeft)

  treeSprite:moveTo(-anchor.x + pagePadding, -anchor.y + pagePadding)
  treeSprite:add()
end

-- frame callback
treeModule.update = function(crankOffset)
  local treePosition = { x = treeSprite.x, y = treeSprite.y }
  if tree.scrollTarget then
    if tree.scrollTarget.properties.direction == playout.kDirectionHorizontal then
      treePosition.x = (treeSprite.width / 2) + crankOffset + pagePadding
    else
      treePosition.y = (treeSprite.height / 2) + crankOffset + pagePadding
    end
  end

  treeSprite:moveTo(treePosition.x, treePosition.y)
  treeSprite:update()


  playdate.timer.updateTimers()
  playdate.drawFPS()
end

return treeModule
