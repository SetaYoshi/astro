local comm = require("commander")
local mode

local gx_up = love.graphics.newImage(Misc.resolveImagePath('menu/menu-up'))
local gx_uph = love.graphics.newImage(Misc.resolveImagePath('menu/menu-up-h'))

local gx_down = love.graphics.newImage(Misc.resolveImagePath('menu/menu-down'))
local gx_downh = love.graphics.newImage(Misc.resolveImagePath('menu/menu-down-h'))

local gx_left = love.graphics.newImage(Misc.resolveImagePath('menu/menu-left'))
local gx_lefth = love.graphics.newImage(Misc.resolveImagePath('menu/menu-left-h'))

local gx_right = love.graphics.newImage(Misc.resolveImagePath('menu/menu-right'))
local gx_righth = love.graphics.newImage(Misc.resolveImagePath('menu/menu-right-h'))

local gx_logo = love.graphics.newImage(Misc.resolveImagePath('menu/menu-logo'))


local function getDirList(dir)
  dir = "astro/games"..dir
  local list = love.filesystem.getDirectoryItems(dir)
  local folders = {}
  local levels = {}
  
  for _, item in ipairs(list) do
    local path = dir.."/"..item
    local info = love.filesystem.getInfo(path)
    if info.type == 'directory' then
      table.insert(folders, item)
    elseif info.type == 'file' and string.endsWith(path..item, '.star') then
      table.insert(levels, item)
    end
  end
  
  return table.multiInsert(folders, levels)
end


local comm_ui = comm.register("mainmenu", {
  up      = {"up"},
  left    = {"left"},
  down    = {"down"},
  right   = {"right"},
  confirm = {"z", "space", "return", "kpenter"},
  back    = {"a", "escape", "backspace"},
})



local dir = {}

local list = {}
list.items = {}
list.func = {}

list.maxlines = 8
list.history = {}

list.option = 1
list.listoffset = 0
list.arrowoffset = 0

function list.move(n, wrap)
  maxarrowoffset = math.min(list.maxlines, #list.items) - 1
  maxlistoffset = math.max(0, #list.items - list.maxlines)
  
  if list.arrowoffset == 0 and list.listoffset == 0 and  n < 0 then
    if not wrap then return end

    list.arrowoffset = maxarrowoffset
    list.listoffset = maxlistoffset
  elseif list.arrowoffset == maxarrowoffset and list.listoffset == maxlistoffset and n > 0 then
    if not wrap then return end

    list.arrowoffset = 0
    list.listoffset = 0
  else
    local newarrowoffset = list.arrowoffset + n
    list.arrowoffset = math.clamp(0, maxarrowoffset, newarrowoffset)
    if newarrowoffset ~= list.arrowoffset then
      list.listoffset = math.clamp(0, maxlistoffset, list.listoffset + newarrowoffset - list.arrowoffset)
    end
  end

  SFX.new('menu-move')
  list.option = list.arrowoffset + list.listoffset + 1
  
end

function list.newMenu(text, func, back)
  table.insert(list.history, {list.items, list.func, list.listoffset, list.arrowoffset, list.back})
  list.option = 1
  list.arrowoffset = 0
  list.listoffset = 0
  list.items = text
  list.func = func
  list.back = back
end

function list.backMenu()
  if #list.history == 1 then return end

  local opt = list.history[#list.history]

  if list.back then
    list.back()
  end
  
  list.items = opt[1]
  list.func = opt[2]
  list.listoffset = opt[3]
  list.arrowoffset = opt[4]
  list.back = opt[5]

  list.history[#list.history] = nil

  list.option = list.listoffset + list.arrowoffset + 1
end

local main_text = {}
local main_func = {}

local optn_text = {}
local optn_func = {}

local file_func

-- ============================== --
--              MAIN              --
-- ============================== --

main_text[1] = "Play"
main_func[1] = function() mode = 'play';   list.newMenu(getDirList(""), file_func, file_back) end

main_text[2] = "Create"
main_func[2] = function() mode = 'create'; list.newMenu(getDirList(""), file_func, file_back) end

main_text[3] = "Options"
main_func[3] = function() list.newMenu(optn_text, optn_func) end

main_text[4] = "Credits"
main_func[4] = nil

main_text[5] = "Exit"
main_func[5] = love.event.quit




-- =============================== --
--             OPTIONS             --
-- =============================== --


optn_text[1] = "Controls"
optn_func[1] = nil

optn_text[2] = "Audio"
optn_func[2] = nil

optn_text[3] = "Video"
optn_func[3] = nil



-- =============================== --
--             CREDITS             --
-- =============================== --


-- ============================== --
--              FILE              --
-- ============================== --
function file_func(n)
  local path = table.concat(dir, "/").."/"..list.items[n]

  local info = love.filesystem.getInfo("astro/games/"..path)
  if info then
    if info.type == 'file' then
      if mode == 'play' then
        Engine.loadLevel(path)
      elseif mode == 'create' then
        love.window.maximize()
        Engine.editLevel(path)
      end
    elseif info.type == 'directory' then
      table.insert(dir, list.items[n])
      list.newMenu(getDirList(path), file_func, file_back)
    end
  end
end

function file_back(n)
  dir[#dir] = nil
end





-- ============================== --
--              AAAA              --
-- ============================== --


local function load()
  list.newMenu(main_text, main_func)
end

local function update(dt)
  if comm_ui.up.press then
    list.move(-1, true)
  elseif comm_ui.up.downtime > 20 and (comm_ui.up.downtime % 5) == 0 then
    list.move(-1)
  end
  if comm_ui.down.press then
    list.move(1, true)
  elseif comm_ui.down.downtime > 20 and (comm_ui.down.downtime % 5) == 0 then
    list.move(1)
  end
  if comm_ui.confirm.pressed then
    SFX.new('menu-select')
    if type(list.func) == 'function' then
      list.func(list.option)
    else
      list.func[list.option]()
    end
  end
  if comm_ui.back.pressed then
    SFX.new('menu-select')
    list.backMenu()
  end
end



local function draw()
  local width, height = love.graphics.getDimensions()

  Misc.draw(gx_logo, 0.5*width, (1/6)*height + 0.5*gx_logo:getHeight()*0.1, {scale = 0.1, xanchor = 0.5, yanchor = 0.5, rotation = 0.05*math.pi*math.sin(0.5*love.timer.getTime( ))})

  local xlist = width*0.35
  local ylist = (1/6)*height + gx_logo:getHeight()*0.1 + 32
  love.graphics.draw(gx_right, xlist, ylist + 32*list.arrowoffset)

  for i = 1, math.min(#list.items, list.maxlines) do
    local item = list.items[list.listoffset + i]
    love.graphics.print(item, xlist + 32, ylist + 32*(i - 1))
  end

  local text = "Created by SetaYoshi"
  local textWidth  = love.graphics.getFont():getWidth(text)
  love.graphics.print(text, 0.5*width, height - 32, 0, 1, 1, 0.5*textWidth, 0)
end

function resize(width, height)
  list.maxlines = math.floor(((11/12)*height - (1/6)*height - gx_logo:getHeight()*0.1 - 32)/32)
end

Engine.registerEvent('load', load)
Engine.registerEvent('update', update)
Engine.registerEvent('draw', draw)
Engine.registerEvent('resize', resize)

