local EFX = Engine.newItemClass{
  name = 'EFX',
  MAX_ID = 999,
  MAX_AMOUNT = 9999,

  methods = {"remove"}
}

local array = EFX.array
local config = EFX.config

function EFX.create(id, args, data)
  local efx = {}

  if type(id) == 'table' and not args then
    data = id
  else
    data = data or {}
    data.id, data.args = id, args
  end

  local conf = config[data.id]
  
  if conf.disabled then return end

  efx.config = conf
  efx.permID = EFX.newPermID()
  
  --- Properties ---
  efx.id = data.id
  efx.args = data.args
  
  
  for _, methodname in ipairs(EFX.methods) do
    efx[methodname] = EFX[methodname]
  end

  EFX.add(efx)

  conf.efxcreate(efx)
  Engine.callEvent('efxcreate', efx)

  setmetatable(efx, EFX.mt)

  return efx
end

function EFX.remove(item)
  EFX.sub(item)
end


function EFX.update(dt)
  for _, efx in ipairs(array) do
    local conf = efx.config

    conf.efxupdate(efx, dt)
  end
end

function EFX.scenedraw(camera)
  for _, efx in ipairs(array) do
    local conf = efx.config

    conf.efxdraw(efx)
  end

  love.graphics.setColor(1, 1, 1, 1)
end

return EFX

