local old_type = type
function type(x)
  local oldtype = old_type(x)
  local mt = getmetatable(x)
  if oldtype == "table" and mt and mt.__name then
    return mt.__name
  end
  return oldtype
end

function toboolean(x, zeroisfalse)
  if zeroisfalse and x == 0 then return false end
  if x then return true end
  return false
end

local old_tostring = tostring
function tostring(x)
  if type(x) == 'table' then
    local s = "{\n"
    for k, v in pairs(x) do
      s = s..tostring(k)..": "..old_tostring(v).."\n"
    end
    return s.."}"
  else
    return old_tostring(x)
  end
end


local Misc = {}

function Misc.default(...)
  local t = {...}
  for i = 1, table.max(table.keys(t)) do
    local v = t[i]
    if v ~= nil then
      return v
    end
  end
end


local function trypath(path)
  return toboolean(love.filesystem.getInfo(path, 'file'))
end

local file_exists = love.filesystem.exists
function Misc.resolvePath(...)
  for _, path in ipairs({...}) do

      local path1 = "astro/"..path  -- Look in root folder 
      if trypath(path1) then return path1 end

      -- local path2 = "astro/games/"..levelpath..path  -- Look in level folder  
      -- if trypath(path2) then return path2 end

  end
end


function Misc.resolveLevelPath(...)
  for _, path in pairs({...}) do
    for _, extension in ipairs({'', '.star'}) do

      local path1 = "astro/games/"..path..extension  -- Look in root folder 
      if trypath(path1) then return path1 end
      
      -- local path2 = levelpath..path..extension  -- Look in level folder  
      -- if trypath(path2) then return path2 end

      local path3 = path..extension  -- Look anywhere else
      if trypath(path3) then return path3 end

    end
  end
end

function Misc.getItemType(path)
  local info = love.filesystem.getInfo(path)
  if info then return info.type end
end

function Misc.resolveFontPath(...)
  for _, path in pairs({...}) do
    for _, extension in ipairs({'', '.ttf'}) do

      local path1 = "astro/"..path..extension  -- Look in root folder 
      if trypath(path1) then return path1 end
      
      -- local path2 = levelpath..path..extension  -- Look in level folder  
      -- if trypath(path2) then return path2 end

      -- local path3 = levelpath.."graphics/"..path..extension  -- Look in graphics folder in level folder  
      -- if trypath(path3) then return path3 end

      local path4 = "astro/font/"..path..extension  -- Look in root graphics folder  
      if trypath(path4) then return path4 end

    end
  end
end

function Misc.resolveImagePath(...)
  for _, path in pairs({...}) do
    for _, extension in ipairs({'', '.png'}) do

      local path1 = "astro/"..path..extension  -- Look in root folder 
      if trypath(path1) then return path1 end
      
      -- local path2 = levelpath..path..extension  -- Look in level folder  
      -- if trypath(path2) then return path2 end

      -- local path3 = levelpath.."graphics/"..path..extension  -- Look in graphics folder in level folder  
      -- if trypath(path3) then return path3 end

      local path4 = "astro/graphics/"..path..extension  -- Look in root graphics folder  
      if trypath(path4) then return path4 end

    end
  end
end

function Misc.resolveAudioPath(...)
  for _, path in pairs({...}) do
    for _, extension in ipairs({'', '.mp3', '.ogg', '.wav'}) do

      local path1 = "astro/"..path..extension  -- Look by given path 
      if trypath(path1) then return path1 end
      
      -- local path2 = levelpath..path..".png"   -- Look in level folder  
      -- if trypath(path2) then return path2 end

      -- local path3 = levelpath.."sounds/"..path..extension  -- Look in sounds folder in level folder  
      -- if trypath(path3) then return path3 end

      local path4 = "astro/sounds/"..path..extension  -- Look in root sounds folder  
      if trypath(path4) then return path4 end
    end
  end
end

function Misc.getItems(path, folderfilter, filefilter)
  local list = love.filesystem.getDirectoryItems(dir)

  folderfilter = folderfilter or function() return true end
  filefilter   = filefilter   or function() return true end
  
  local folders = {}
  local files = {}
  
  for _, item in ipairs(list) do
    local info = love.filesystem.getInfo(dir.."/"..item)

    if info.type == 'directory' and folderfilter(item, info) then
      table.insert(folders, item)
    elseif info.type == 'file' and filefilter(item, info) then
      table.insert(files, item)
    end
  end
  
  return table.multiInsert(folders, files)
end

function Misc.getFiles(path, filter)
  local list = love.filesystem.getDirectoryItems(dir)

  filter = filter or function() return true end

  local files = {}
  
  for _, item in ipairs(list) do
    local info = love.filesystem.getInfo(dir.."/"..item)

    if info.type == 'file' and filter(item, info) then
      table.insert(files, item)
    end
  end
  
  return files
end

function Misc.getFolders(path, filter)
  local list = love.filesystem.getDirectoryItems(dir)
  
  filter = filter or function() return true end
  
  local folders = {}
  
  for _, item in ipairs(list) do
    local info = love.filesystem.getInfo(dir.."/"..item)
    
    if info.type == 'directory' and filter(item, info) then
      table.insert(folders, item)
    end
  end
  
  return folders
end

function Misc.newImage(...)
  local path = Misc.resolveImagePath(...)
  if path then
    return love.graphics.newImage(path)
  end
end

function Misc.collRectPoint(x1, y1, w1, h1, x2, y2)
  return x2 > x1 and x2 < x1 + w1 and y2 > y1 and y2 < y1 + h1
end

function Misc.collRectRect(x1, y1, w1, h1, x2, y2, w2, h2)
  return x1 < (x2 + w2) and (x1 + w1) > x2 and y1 < (y2 + h2) and (y1 + h1) > y2 
end

function Misc.popup(...) 
  local s = ""
  for k, v in ipairs({...}) do
    s = s..tostring(v).."\n"
  end
  return love.window.showMessageBox("Pop-up", s) 
end

function Misc.print(text, x, y)
  love.graphics.print(tostring(text), x, y)
end

function Misc.draw(img, x, y, args)
  args = args or {}
  local data = args 

  data.x = x
  data.y = y

  if args.xanchor then
    data.xoffset = args.xanchor*img:getWidth()
  end
  if args.yanchor then
    data.yoffset = args.yanchor*img:getHeight()
  end
  if args.scale then
    data.xscale, data.yscale = data.scale, data.scale
  end

  love.graphics.draw(img, data.x, data.y, data.rotation, data.xscale, data.yscale, data.xoffset, data.yoffset, data.xshear, data.yshear)
end


local uptime = 0
function Misc.frames()
  return uptime
end

function Misc.update(dt)
  uptime = uptime + 1
  p(uptime)
end

function Misc.updateAnimation(item)
  local conf = item.config

  item.frametimer = item.frametimer - 1
  if item.frametimer < 0 then
    item.frametimer = conf.framespeed
    item.frame = item.frame + 1
    if item.frame > conf.frames then
      item.frame = 1
    end
  end

end
  
Engine.registerEvent('update', Misc.update)


return Misc