local Object = {}

-- ==========================
-- =====   CLASS DATA   =====
-- ==========================
Object.name = 'Object'

Object.MAX_ID = 7
Object.MAX_AMOUNT = 999999


local List = {}
local class_mt = {__type = "object"}

local Name_MAP = {}

Object.config = {}
local config = Object.config

local permIDMax = 0




function Object.list()
  local out = {}
  for i = 1, #List do
    table.insert(out, List[i])
  end
  return out
end


function Object.get(idx)
  return List[idx]
end


function Object.register(conf)
  Name_MAP[conf.name] = conf.id
  config[conf.id] = Engine.config(Object, conf)
  return config[conf.id]
end


function Object.create(objID, data)
  if type(objID) == 'table' and not x then
    data = table.deepclone(objID)
  else
    data = table.deepclone(data)
    data.objID = objID
  end

  if data.objName then
    data.objID = Name_MAP[data.objName]
  elseif type(data.objID) == 'string' then
    data.objID = Name_MAP[data.objID]
  end

  local object = table.deepclone(data)

  permIDMax = permIDMax + 1
  object.permID = permIDMax
  
  
  local configList = Engine.class(config[data.objID].name).config
  if configList then 
    object.config = configList[data.id]
  end



  --- Methods ---
  object.render = Object.render
  object.remove = Object.remove


  local addToList = true

  if object.objID == 2 then
    object.id = object.id or 1
    for _, o in ipairs(Object.list()) do
      if o.objID == 2 and o.idx == object.idx then
        object = o
        object.x, object.y = data.x, data.y
        addToList = false
        break
      end
    end
  end

  if addToList then
    if object.objID ~= 7 then
      local w, h = object.width, object.height
      if object.config then
        w, h = w or object.config.e_texturewidth, h or object.config.e_textureheight
      end
      w, h = w or 32, h or 32
      World:add(object, object.x, object.y, w, h)
    end
    table.insert(List, object)
  end

  return object
end

function Object.remove(object)
  for k, o in ipairs(Object.list()) do
    if o.permID == object.permID then
      table.remove(List, k)
      break
    end
  end
end

function Object.render(object)
  if object.objName then
    object.objID = Name_MAP[object.objName]
  elseif type(object.objID) == 'string' then
    object.objID = Name_MAP[object.objID]
  end

  local conf = config[object.objID]
  conf.drawObject(object)
end


function Object.update(dt)
  -- for idx, object in ipairs(Object.list()) do

  -- end
end

function Object.scenedraw(camera)
  for idx, object in ipairs(Object.list()) do
    object:render()

    if object.objID ~= 7 then
    local x,y,w,h = World:getRect(object)
    love.graphics.rectangle('line', x, y, w, h)
    end

  end
end


setmetatable(Object, {__call = function(t, ...) return Object.get(...) end})

return Object

