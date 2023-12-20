local treeModule = import 'treeModule'

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


local inputHandlers = {
  cranked = function(change, acceleratedChange)
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
  treeModule.setup()
end

-- frame callback
function playdate.update()
  treeModule.update(offset)
end

setup()
