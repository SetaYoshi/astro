local BGO = Engine.newItemClass{
  name = 'BGO',
  MAX_ID = 100,
  MAX_AMOUNT = 9999,

  methods = {"render", "remove"}
}

local animate = require("animate")

local array = BGO.array
local config = BGO.config

function BGO.create(id, x, y, data)
  local bgo = {}

  if type(id) == 'table' and not x then
    data = id
  else
    data = data or {}
    data.id, data.x, data.y = id, x, y
  end

  local conf = config[data.id]
  
  bgo.config = conf
  bgo.permID = BGO.newPermID()
  
  --- Properties ---
  bgo.id = data.id
  bgo.x = data.x
  bgo.y = data.y
  bgo.variant = Misc.default(data.variant, 1)

  bgo.frame = Misc.default(data.frame, 1)
  bgo.frametimer = conf.framespeed
  bgo.color = Misc.default(data.color, conf.color)
  
  
  for _, methodname in ipairs(BGO.methods) do
    bgo[methodname] = BGO[methodname]
  end

  BGO.add(bgo)

  conf.bgocreate(bgo)
  Engine.callEvent('bgocreate', bgo)

  setmetatable(bgo, BGO.mt)

  return bgo
end

function BGO.remove(item)
  BGO.sub(item)
end

function BGO.render(bgo)
  love.graphics.setColor(bgo.color)
  love.graphics.draw(bgo.config.texture, bgo.config.quads[bgo.variant][bgo.frame], bgo.x, bgo.y)
end


function BGO.update(dt)
  for _, bgo in ipairs(array) do
    local conf = bgo.config

    animate.updateItem(bgo)

    conf.bgoupdate(bgo, dt)
  end
end

function BGO.scenedraw(camera)
  for _, bgo in ipairs(array) do
    local conf = bgo.config

    if not conf.disablerender then
      bgo:render()
    end

    conf.bgodraw(bgo)
  end

  love.graphics.setColor(1, 1, 1, 1)
end

return BGO

