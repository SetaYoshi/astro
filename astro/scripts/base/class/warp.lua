local Warp = Engine.newItemClass{
  name = 'Warp',
  MAX_ID = 100,
  MAX_AMOUNT = 128,

  methods = {"render", "remove"}
}

local array = Warp.array
local config = Warp.config

function Warp.create(id, xenter, yenter, xexit, yexit, data)
  local warp = {}

  if type(id) == 'table' and not xenter then
    data = id
  else
    data = data or {}
    data.id, data.xenter, data.yenter, data.xexit, data.yexit = id, xenter, yenter, xexit, yexit
  end

  local conf = config[data.id]

  
  warp.config = conf
  warp.permID = VFX.newPermID()
  
  
  --- Properties ---
  warp.id = data.id

  warp.xenter = data.xenter
  warp.yenter = data.yenter

  warp.xexit = data.xexit
  warp.yexit = data.yexit


  warp.widthenter = Misc.default(data.widthenter, data.width, conf.width)
  warp.heightenter = Misc.default(data.heightenter, data.height, conf.height)

  warp.widthexit = Misc.default(data.widthexit, data.width, conf.width)
  warp.heightexit = Misc.default(data.heightexit, data.height, conf.height)

  warp.contactPlayers = {}

  
  World:add(warp, warp.xenter, warp.yenter, warp.widthenter, warp.heightenter)

    
  for _, methodname in ipairs(Warp.methods) do
    warp[methodname] = Warp[methodname]
  end

  Warp.add(warp)

  conf.warpcreate(warp)
  Engine.callEvent('warpcreate', warp)

  setmetatable(warp, Warp.mt)

  return warp
end

function Warp.remove(item)
  Warp.sub(item)
end


function Warp.render(warp)
  love.graphics.setColor(0.9, 0, 0.85, 1)
  love.graphics.rectangle('line', warp.xenter, warp.yenter, warp.widthenter, warp.heightenter)

  love.graphics.setColor(0, 0.1, 0.9, 1)
  love.graphics.rectangle('line', warp.xexit, warp.yexit, warp.widthexit, warp.heightexit)
  
  
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print(tostring(warp.permID), warp.xenter + 2, warp.yenter + 2)
  love.graphics.print(tostring(warp.permID), warp.xexit + 2, warp.yexit + 2)
end


function Warp.update(dt)
  for _, warp in ipairs(array) do
    local conf = warp.config

    for _, player in ipairs(warp.contactPlayers) do
      conf.warpcontactplayer(warp, player)
      Engine.callEvent(warpcontactplayer, warp, player)
    end

    conf.warpupdate(warp, dt)
  end
end

function Warp.scenedraw(camera)
  for _, warp in ipairs(array) do
    local conf = warp.config

    warp:render()
    
    conf.warpdraw(warp)
  end
end


return Warp

