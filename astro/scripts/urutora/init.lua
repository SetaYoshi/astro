local lg = love.graphics
local lm = love.mouse

local modules = (...) and (...):gsub('%.init$', '') .. "." or ""
local urutora = require('urutora.urutora.urutora')
local utils = require('urutora.urutora.utils')

local xxx=0
function urutora.create(x, y, w, h)
  xxx=xxx+1
  local u = urutora:new()
  u.xxx=xxx
  u.canvas = lg.newCanvas(w, h)

  function u.doResizeStuff(W, H, x, y, w, h)  
    u.csx = math.floor(W/u.canvas:getWidth())
    u.csx = u.csx < 1 and 1 or u.csx
    u.csy = u.csx
    
    if math.floor(u.canvas:getHeight() * u.csy) > H then
      u.csy = math.floor(H/u.canvas:getHeight())
      u.csy = u.csy < 1 and 1 or u.csy
      u.csx = u.csy
    end
    
    u.canvas = lg.newCanvas(w, h)
    u.canvas:setFilter('nearest', 'nearest')
  
    u.canvasX, u.canvasY = x, y
    lg.setCanvas({u.canvas, stencil = true })
    u.setDimensions(u.canvasX, u.canvasY, u.csx, u.csy)
    lg.setCanvas()
  end
  
  u.doResizeStuff(love.graphics.getWidth(), love.graphics.getHeight(), x, y, w, h)
  
  function u.love_mousepressed(x, y, button) u:pressed(x, y, button) end
  function u.love_mousemoved(x, y, dx, dy) u:moved(x, y, dx, dy) end
  function u.love_mousereleased(x, y, button) u:released(x, y) end
  function u.love_textinput(text) u:textinput(text) end
  function u.love_keypressed(k, scancode, isrepeat) u:keypressed(k, scancode, isrepeat) end
  function u.love_wheelmoved(x, y) u:wheelmoved(x, y) end

  function u.love_update(dt) 
    lg.setCanvas({u.canvas, stencil = true })
    utils.x, utils.y = u.canvasX, u.canvasY
    utils.sx, utils.sy = u.csx, u.csy
    u:update(dt, u.xxx) 
    lg.setCanvas()
  end
  function u.love_draw() 
    lg.setCanvas({u.canvas, stencil = true })
    
    u.drawBg() -- spinning squares
    
    u:draw()
    
    lg.setColor(1, 1, 1)
    lg.setCanvas()
    lg.draw(u.canvas, math.floor(u.canvasX), math.floor(u.canvasY), 0, u.csx, u.csy)
  end
  
  -- if xxx == 1 then
  Engine.registerEvent('mousepressed', u.love_mousepressed)
  Engine.registerEvent('mousemoved', u.love_mousemoved)
  Engine.registerEvent('mousereleased', u.love_mousereleased)
  Engine.registerEvent('textinput', u.love_textinput)
  Engine.registerEvent('keypressed', u.love_keypressed)
  Engine.registerEvent('wheelmoved', u.love_wheelmoved)
  Engine.registerEvent('update', u.love_update)
  Engine.registerEvent('draw', u.love_draw)
  -- end

  return u
end

return urutora