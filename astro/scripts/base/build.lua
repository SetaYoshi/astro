local nativefs = require("nativefs")

-- =============== --
-- === LOADING === --
-- =============== --

local encode = {
  BGO = function(bgo)
    return bgo.id..", "..bgo.variant..", "..bgo.x..", "..bgo.y
  end,

  Block = function(block)
    return block.id..", "..block.variant..", "..block.x..", "..block.y
  end,

  NPC = function(npc)
    return npc.id..", "..npc.variant..", "..npc.x..", "..npc.y
  end,

  Player = function(player)
    return player.idx..", "..player.id..", "..player.x..", "..player.y
  end,

  Section = function(section)
    return section.idx..", "..section.x..", "..section.y..", "..section.width..", "..section.height
  end,

  Warp = function(warp)
    return warp.idx..", "..warp.id..", "..warp.xenter..", "..warp.yenter..", "..warp.widthenter..", "..warp.heightenter..", "..warp.xexit..", "..warp.yexit..", "..warp.widthexit..", "..warp.heightexit
  end,

  Zone = function(zone)
    return zone.id..", "..zone.x..", "..zone.y..", "..zone.width..", "..zone.height
  end,
}

local decode = {
  BGO = function(dec)
    return {id = tonumber(dec[1]), variant = tonumber(dec[2]), x = tonumber(dec[3]), y = tonumber(dec[4])}
  end,

  Block = function(dec)
    return {id = tonumber(dec[1]), variant = tonumber(dec[2]), x = tonumber(dec[3]), y = tonumber(dec[4])}
  end,

  NPC = function(dec)
    return {id = tonumber(dec[1]), variant = tonumber(dec[2]), x = tonumber(dec[3]), y = tonumber(dec[4])}
  end,

  Player = function(dec)
    return {idx = tonumber(dec[1]), id = tonumber(dec[2]), x = tonumber(dec[3]), y = tonumber(dec[4])}
  end,

  Section = function(dec)
    return {idx = tonumber(dec[1]), x = tonumber(dec[2]), y = tonumber(dec[3]), width = tonumber(dec[4]), height = tonumber(dec[5])}
  end,

  Warp = function(dec)
    return {idx = tonumber(dec[1]), id = tonumber(dec[2]), xenter = tonumber(dec[3]), yenter = tonumber(dec[4]), widthenter = tonumber(dec[5]), heightenter = tonumber(dec[6]), xexit = tonumber(dec[7]), yexit = tonumber(dec[8]), widthexit = tonumber(dec[9]), heightexit = tonumber(dec[10])}
  end,

  Zone = function(dec)
    return {id = tonumber(dec[1]), x = tonumber(dec[2]), y = tonumber(dec[3]), width = tonumber(dec[4]), height = tonumber(dec[5])}
  end,
}

function Engine.build(path)
  local contents = love.filesystem.read("astro/games/"..path)
  
  for line, text in ipairs(string.split(contents, "\n")) do
    local dec = string.split(text, ",")
    if dec[2] then
      local type = dec[1]
      table.remove(dec, 1)
      
      local obj = decode[type](dec)
      Engine.class(type).create(obj)
    end
  end

  local playercount = math.max(1, math.min(4, Player.amount()))
  local w, h = love.graphics.getWidth(), love.graphics.getHeight()
  if playercount > 1 then
    w = w/2
  end
  if playercount > 2 then
    h = h/2
  end
  for i = 1, playercount do
    local camera = Camera.create{widthscreen = w, heightscreen = h, xscreen = ((i - 1)%2)*(w), yscreen = math.floor((i - 1)/2)*h}
    camera:follow(Player(i))
  end
end

function Engine.editorBuild(path)
  local contents = love.filesystem.read("astro/games/"..path)
  
  for line, text in ipairs(string.split(contents, "\n")) do
    local dec = string.split(text, ",")
    if dec[2] then
      local type = dec[1]
      table.remove(dec, 1)
      
      local obj = decode[type](dec)
      Object.create(type, obj)
    end
  end
end

function Engine.saveLevel(path)  
  local file = ""
  for idx, object in ipairs(Object.list()) do
    local type = Object.config[object.objID].name
    local enc = type..", "..encode[type](object)
    file = file..enc.."\n"
  end
  
  local success, message = nativefs.write("games/"..path, file)
end

local reloadFunc

local function real_editLevel(path)
  RESET()
end

local function real_loadLevel(path)
  RESET()
end

local function real_loadMainMenu()
  RESET()
end


function Engine.editLevel(path)
  _G.LoadingMethod = {type = 'edit', path = path, func = real_editLevel, reset = true}
end

function Engine.loadLevel(path)
  _G.LoadingMethod = {type = 'level', path = path, func = real_loadLevel, reset = true}
end

function Engine.loadMainMenu()
  _G.LoadingMethod = {type = 'mainmenu', func = real_loadMainMenu, reset = true}
end
