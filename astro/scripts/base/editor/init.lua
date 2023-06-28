local Editor = {}

local comm = require("commander")
local layout = require("base.editor.layout")

local comm_ui = comm.register("editor", {
  up      = {"up"},
  left    = {"left"},
  down    = {"down"},
  right   = {"right"},
  confirm = {"return", "kpenter"},
  exit    = {"escape"},
  coords  = {"lalt"},
})

local settings = {
  snapgrid = true,
  snapgridsize = 32,

  zonetype = 1,
  zoom = 1,
  cursor = {mode = 'select'},
}

local toolbox
local toolboxWidth = 204
local toolboxHeight = love.graphics.getHeight()

local iconbelt
local iconbeltWidth = love.graphics.getWidth() - toolboxWidth
local iconbeltHeight = 34

local toolboxMode = 'block'

local itemListBlock 
local itemListNPC
local itemListBGO

local canvas

require 'urutora.fonts'

local lg = love.graphics
local lm = love.mouse

local urutora = require('urutora')

local camera = Camera.create{
  noBounds = true,
  xscreen = 0, yscreen = iconbeltHeight,
  widthscreen = iconbeltWidth, heightscreen = love.graphics.getHeight() - iconbeltHeight,
}



local bar = urutora.create(0, 0, iconbeltWidth, iconbeltHeight)
bar.setDefaultFont(proggyTiny)
local pane = urutora.create(love.graphics.getWidth() - toolboxWidth, 0, toolboxWidth, toolboxHeight)
pane.setDefaultFont(proggyTiny)



local gx_cursor = Misc.newImage('menu-cursor', 'menu/menu-cursor')
local gx_menuBG = Misc.newImage('menu-toolbox-background', 'menu/menu-toolbox-background')

local gx_icon_newfile  = Misc.newImage('menu-newfile', 'menu/menu-newfile')
local gx_icon_savefile = Misc.newImage('menu-savefile', 'menu/menu-savefile')
local gx_icon_openfile = Misc.newImage('menu-openfile', 'menu/menu-openfile')

local gx_icon_select = Misc.newImage('menu-select', 'menu/menu-select')
local gx_icon_erase = Misc.newImage('menu-erase', 'menu/menu-erase')

local gx_icon_undo = Misc.newImage('menu-undo', 'menu/menu-undo')
local gx_icon_redo = Misc.newImage('menu-redo', 'menu/menu-redo')

local gx_icon_gridsize = Misc.newImage('menu-gridsize', 'menu/menu-gridsize')

local gx_icon_player1 = Misc.newImage('menu-playerstart-1', 'menu/menu-playerstart-1')
local gx_icon_player2 = Misc.newImage('menu-playerstart-2', 'menu/menu-playerstart-2')
local gx_icon_player3 = Misc.newImage('menu-playerstart-3', 'menu/menu-playerstart-3')
local gx_icon_player4 = Misc.newImage('menu-playerstart-4', 'menu/menu-playerstart-4')

local gx_icon_zone = Misc.newImage('menu-zone', 'menu/menu-zone')
local gx_icon_section = Misc.newImage('menu-section', 'menu/menu-section')


local bgRotation = 0
gx_menuBG:setFilter('nearest', 'nearest')


local function initIconBelt()
  local zones = {}
  local zoneMAP = {}
  for i = 1, Zone.MAX_ID do
    if Zone.config[i].isValid then
      table.insert(zones, Zone.config[i].name)
      zoneMAP[Zone.config[i].name] = Zone.config[i]
    end
  end

  local iconbelt = bar.panel({
    debug = false,
    rows = 1, cols = 40,
    w = iconbeltWidth, h = iconbeltHeight,
    cellWidth = 34, cellHeight = 34,
    tag = 'iconbelt'
  })

  :colspanAt(1, 20, 2)

  :addAt(1, 1, bar.image({image = gx_icon_newfile }):action(function(evt) pp("Not implemented yet") end))
  :addAt(1, 2, bar.image({image = gx_icon_savefile}):action(function(evt) Engine.saveLevel('levels/test.star') end))
  :addAt(1, 3, bar.image({image = gx_icon_openfile}):action(function(evt) Engine.loadMainMenu() end))

  :addAt(1, 5, bar.image({image = gx_icon_select}):action(function(evt) settings.cursor.mode = 'select' end))
  :addAt(1, 6, bar.image({image = gx_icon_erase}):action(function(evt) settings.cursor.mode = 'eraser' end))

  :addAt(1, 8, bar.image({image = gx_icon_undo}):action(function(evt) pp("Not implemented yet") end))
  :addAt(1, 9, bar.image({image = gx_icon_redo}):action(function(evt) pp("Not implemented yet") end))

  :addAt(1, 11, bar.image({image = gx_icon_gridsize}):action(function(evt)
    settings.snapgrid = not settings.snapgrid
  end))

  :addAt(1, 12, bar.text({text = tostring(settings.snapgridsize)}):action(function(evt) 
    settings.snapgridsize = tonumber(evt.value.newText) or settings.snapgridsize
    evt.value.newText = settings.snapgridsize
  end))

  :addAt(1, 14, bar.image({image = gx_icon_player1}):action(function(evt) 
    settings.cursor.objName = 'Player'
    settings.cursor.id = 1
    settings.cursor.idx = 1
  end))
  :addAt(1, 15, bar.image({image = gx_icon_player2}):action(function(evt) 
    settings.cursor.objName = 'Player'
    settings.cursor.id = 1
    settings.cursor.idx = 2
  end))
  :addAt(1, 16, bar.image({image = gx_icon_player3}):action(function(evt) 
    settings.cursor.objName = 'Player'
    settings.cursor.id = 1
    settings.cursor.idx = 3
  end))
  :addAt(1, 17, bar.image({image = gx_icon_player4}):action(function(evt) 
    settings.cursor.objName = 'Player'
    settings.cursor.id = 1
    settings.cursor.idx = 4
  end))

  :addAt(1, 19, bar.image({image = gx_icon_zone}):action(function(evt) 
    settings.cursor.objName = 'Zone'
    settings.cursor.id = settings.cursor.id or 1
  end))
  :addAt(1, 20, bar.multi({items = zones}):action(function(evt) 
    settings.cursor.id = evt.index
  end))

  :addAt(1, 22, bar.image({image = gx_icon_section}):action(function(evt) pp('c') end))
  :addAt(1, 23, bar.multi({items = { '1', '2', '3', '4', '5'}}):action(function(evt) pp('c') end))

  return iconbelt
end


local function initToolBox()
  local toolbox = pane.panel({
    debug = false,
    rows = 20, cols = 3,
    w = toolboxWidth, h = toolboxHeight,
    cellWidth = 34, cellHeight = 34,
    tag = 'toolbox'
  })

  :colspanAt(1, 1, 3)
  :colspanAt(3, 1, 3)

  :rowspanAt(3, 1, 18)
  
  :addAt(1, 1, pane.label({text = 'Toolbox'}))

  :addAt(2, 1, pane.button({text = 'Blocks'}):action(function(evt) toolbox:addAt(3, 1, itemListBlock) end))
  :addAt(2, 2, pane.button({text = 'NPCs'  }):action(function(evt) toolbox:addAt(3, 1, itemListNPC  ) end))
  :addAt(2, 3, pane.button({text = 'BGOs'  }):action(function(evt) toolbox:addAt(3, 1, itemListBGO  ) end))

  return toolbox
end

local function registerItem(class, itemList, row, column, id, variant, conf)
  local quad = pane.quad({
    image = conf.e_texture,
    sx = conf.e_xtexture + conf.e_texturewidth*(variant - 1),
    sy = conf.e_ytexture,
    sw = conf.e_texturewidth,
    sh = conf.e_textureheight,
    tag = class.name..'-'..id.."-"..variant
  })
  
  quad:action(function(evt)
    settings.cursor.objName = class.name
    settings.cursor.id = id
    settings.cursor.variant = variant
  end)
  
  itemList:addAt(row, column, quad)
end

local function initItemList(classname)
  local itemList = pane.panel({
    debug = false,
    rows = 18, cols = 6,
    cellWidth = 34, cellHeight = 34,
    scrollSpeed = 1/10,
    tag = 'itembox'.."-"..classname
  })

  for k, v in ipairs(layout[classname]) do
    local classname, id, variant = v[1], v[2], v[3]
    if id ~= 0 then
      local class = Engine.class(classname)
      local conf = class.config[id]
    
      local row = math.ceil(k/6)
      local column = (k - 1) % 6 + 1
      registerItem(class, itemList, row, column, id, variant, conf)
    end
  end

  return itemList
end





local function load()
  -- Hide cursor
  lm.setCursor(lm.newCursor(love.image.newImageData(1, 1)))
  
  toolbox = initToolBox()
  iconbelt = initIconBelt()
  
  itemListBlock = initItemList('Block')
  itemListNPC   = initItemList('NPC')
  itemListBGO   = initItemList('BGO')
 
  toolbox:addAt(3, 1, itemListBlock)

  bar:add(iconbelt)
  pane:add(toolbox)

  -- pane:setStyle({ font = proggySquare })
end


local function update(dt)  
  bgRotation = (bgRotation + dt * 5) % 360
  
  if comm_ui.exit.pressed then Engine.editLevel('levels/test.star') end

  if comm_ui.left.down then
    camera.x = camera.x - 5
  end
  if comm_ui.right.down then
    camera.x = camera.x + 5
  end
  if comm_ui.up.down then
    camera.y = camera.y - 5
  end
  if comm_ui.down.down then
    camera.y = camera.y + 5
  end
  
end

function pane.drawBg()
  lg.clear({0.2, 0.1, 0.3})
  lg.draw(gx_menuBG,
    pane.canvas:getWidth() / 2,
    pane.canvas:getHeight() / 2,
    math.rad(bgRotation),
    pane.canvas:getWidth() / gx_menuBG:getWidth() * 3,
    pane.canvas:getHeight() / gx_menuBG:getHeight() * 3,
    gx_menuBG:getWidth() / 2,
    gx_menuBG:getHeight() / 2
  )
end

function bar.drawBg()
  lg.clear({0.1, 0.1, 0.1})
end


local function adjustCursor()
  return camera:getScenePos(love.mouse.getX(), love.mouse.getY())
end

local function adjustGridCursor(xoffset, yoffset)
  local x, y = adjustCursor()

  if xoffset then
    x = x + xoffset
  end

  if yoffset then
    y = y + yoffset
  end

  local gridsize = (settings.snapgrid and settings.snapgridsize) or 1

  return math.floor(x/gridsize)*gridsize, math.floor(y/gridsize)*gridsize
end



local function drawCursor()
  if settings.cursor.objName then
    local x, y = adjustGridCursor()

    love.graphics.setColor(1, 1, 1, 0.8 + 0.2*math.sin(1.8*love.timer.getTime()))

    if settings.cursor.realx then
      x, y = settings.cursor.realx, settings.cursor.realy
    end

    settings.cursor.x, settings.cursor.y = x, y
    Object.render(settings.cursor)
  end
end


local function isCursorInsideCamera()
  local x, y = love.mouse.getX(), love.mouse.getY()
  return Misc.collRectPoint(camera.xscreen, camera.yscreen, camera.widthscreen, camera.heightscreen, x, y)
end


local function draw()
  -- lg.print('FPS: ' .. love.timer.getFPS())
  local x, y = love.mouse.getX(), love.mouse.getY()

  if lm.isDown(1) then
    lg.setColor(1, 0, 0)
  end

  lg.draw(gx_cursor, math.floor(x), math.floor(y))
  lg.setColor(1, 1, 1)
  
  if isCursorInsideCamera() and comm_ui.coords.downtime > 30 then
    local sceneX, sceneY = adjustCursor()
    p(sceneX.."x"..sceneY, x, y + 18)
  end
end



local function mousepressed(x, y, button)
  if isCursorInsideCamera() then
    if button == 3 then
      settings.cursor.camscroll = true
    elseif settings.cursor.mode == 'select' then
      if settings.cursor.objName then
        local x, y = adjustGridCursor()
        settings.cursor.x, settings.cursor.y = x, y
    
        if button == 1 then
          if settings.cursor.objName == 'Zone' then
            settings.cursor.rectpressx = x
            settings.cursor.rectpressy = y
          else
            Object.create(settings.cursor)
          end
        elseif button == 2 then
          settings.cursor.objName = nil
        end
      else
        local x, y = adjustCursor()

        local items, len = World:queryPoint(x, y)
        if len > 0 then
          local item = items[1]
          
          settings.cursor.dragObject = item
          settings.cursor.dragdx, settings.cursor.dragdy = item.x - x, item.y - y
        end
      end
    elseif settings.cursor.mode == 'eraser' then
      local x, y = adjustCursor()
      
      local items, len = World:queryPoint(x, y)
      if len > 0 then
        local item = items[1]
        
        item:remove()
      end
    end

  end
end

local function mousemoved(x, y, dx, dy, istouch)
  if settings.cursor.rectpressx then
    local x, y = adjustGridCursor()

    local realx, realy = settings.cursor.rectpressx, settings.cursor.rectpressy

    settings.cursor.width = math.abs(settings.cursor.rectpressx - x)
    settings.cursor.height = math.abs(settings.cursor.rectpressy - y)

    if settings.cursor.rectpressx > x then
      realx = x
    end
    if settings.cursor.rectpressy > y then
      realy = y
    end

    settings.cursor.realx, settings.cursor.realy = realx, realy
  elseif settings.cursor.camscroll then
    camera.x = camera.x - dx
    camera.y = camera.y - dy
  elseif settings.cursor.dragObject then
    local x, y = adjustCursor()
    settings.cursor.dragObject.x, settings.cursor.dragObject.y = x + settings.cursor.dragdx, y + settings.cursor.dragdy
  end
end

local function mousereleased(x, y, button, istouch, presses)
  if settings.cursor.rectpressx then
    x, y = adjustGridCursor()
    local realx, realy = settings.cursor.rectpressx, settings.cursor.rectpressy

    settings.cursor.width = math.abs(settings.cursor.rectpressx - x)
    settings.cursor.height = math.abs(settings.cursor.rectpressy - y)
    
    if settings.cursor.rectpressx > x then
      realx = x
    end
    if settings.cursor.rectpressy > y then
      realy = y
    end

    settings.cursor.x, settings.cursor.y = realx, realy
    Object.create(settings.cursor)


    settings.cursor.rectpressx = nil
    settings.cursor.rectpressy = nil
    settings.cursor.width = nil
    settings.cursor.height = nil
    settings.cursor.realx, settings.cursor.realy = nil, nil
  elseif settings.cursor.camscroll then
    settings.cursor.camscroll = nil


  elseif settings.cursor.dragObject then
    
    local x, y = adjustGridCursor(settings.cursor.dragdx, settings.cursor.dragdy)
    settings.cursor.dragObject.x, settings.cursor.dragObject.y = x, y

    World:update(settings.cursor.dragObject, settings.cursor.dragObject.x, settings.cursor.dragObject.y)
    settings.cursor.dragObject = nil
  end
end

local function wheelmoved(x, y)
  if isCursorInsideCamera() then
    settings.zoom = settings.zoom - 0.1*y
    camera.width, camera.height = settings.zoom*camera.widthscreen, settings.zoom*camera.heightscreen
  end
end

local function resize(w, h)
  local toolboxHeight = h
  local iconbeltWidth = w - toolboxWidth
  pane.doResizeStuff(w, h, w - toolboxWidth, 0, toolboxWidth, toolboxHeight)
  bar.doResizeStuff(w, h, 0, 0, iconbeltWidth, iconbeltHeight)
end


Engine.registerEvent('load', load)
Engine.registerEvent('update', update)
Engine.registerEvent('draw', draw)
Engine.registerEvent('mousepressed', mousepressed)
Engine.registerEvent('mousemoved', mousemoved)
Engine.registerEvent('mousereleased', mousereleased)
Engine.registerEvent('wheelmoved', wheelmoved)
Engine.registerEvent('keypressed', keypressed)
Engine.registerEvent('resize', resize)
Engine.registerEvent('scenedraw', drawCursor)

return Editor
