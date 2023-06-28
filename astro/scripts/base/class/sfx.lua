local SFX = Engine.newItemClass{
  name = 'SFX',
  MAX_ID = 100,
  MAX_AMOUNT = 9999,

  methods = {"play"}
}

local array = SFX.array
local config = SFX.config

local newSource = love.audio.newSource

function SFX.create(id, data)
  local sfx = {}

  if type(id) == 'table' and not data then
    data = id
  else
    data = data or {}
    data.id = id
  end

  if type(data.id) == 'string' then
    data.id = SFX.NAME_MAP[data.id]
  end

  local conf = config[data.id]


  sfx.config = conf
  sfx.permID = SFX.newPermID()

  --- Properties ---
  sfx.id = data.id
  sfx.source = newSource(conf.filepath, 'static')
  
  --- Methods ---
  for _, methodname in ipairs(SFX.methods) do
    sfx[methodname] = SFX[methodname]
  end
  

  SFX.add(sfx)

  conf.sfxcreate(sfx)
  Engine.callEvent('sfxcreate', sfx)

  setmetatable(sfx, SFX.mt)

  return sfx
end

function SFX.remove(item)
  SFX.sub(item)
end

function SFX.new(id)
  local sfx = SFX.create(id)
  sfx:play()
end

function SFX.play(sfx)
  love.audio.play(sfx.source)
end

return SFX

