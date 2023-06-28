local Zone = Engine.newItemClass{
  name = 'Zone',
  MAX_ID = 100,
  MAX_AMOUNT = 128,

  methods = {"render", "remove"}
}


local array = Zone.array
local config = Zone.config


function Zone.create(id, x, y, width, height, data)
  local zone = {}

  if type(id) == 'table' and not x then
    data = id
  else
    data = data or {}
    data.id, data.x, data.y, data.width, data.height = id, x, y, width, height
  end

  local conf = config[data.id]

  zone.config = conf
  zone.permID = Zone.newPermID()
  
  --- Properties ---
  zone.id = data.id
  
  zone.x = data.x
  zone.y = data.y
  zone.width = data.width
  zone.height = data.height

  zone.frame = Misc.default(data.frame, 1)
  zone.frametimer = conf.framespeed

  zone.contactPlayers = {}
    
  World:add(zone, zone.x, zone.y, zone.width, zone.height)

  for _, methodname in ipairs(Zone.methods) do
    zone[methodname] = Zone[methodname]
  end
  

  Zone.add(zone)

  conf.zonecreate(zone)
  Engine.callEvent('zonecreate', zone)

  setmetatable(zone, Zone.mt)

  return zone
end

function Zone.remove(item)
  Zone.sub(item)
end

function Zone.render(zone)
  local color = zone.config.color
  love.graphics.setColor(color[1], color[2], color[3], 0.2)
  love.graphics.rectangle('fill', zone.x, zone.y, zone.width, zone.height)
  
  love.graphics.setColor(color[1], color[2], color[3], 1)
  love.graphics.rectangle('line', zone.x, zone.y, zone.width, zone.height)
  
  love.graphics.setColor(1, 1, 1, 1)
end

function Zone.update()
  for _, zone in ipairs(array) do
    local conf = zone.config

    for _, player in ipairs(zone.contactPlayers) do
      conf.zonecontactplayer(zone, player)
      Engine.callEvent(zonecontactplayer, zone, player)
    end

    conf.zoneupdate(zone, dt)
  end
end

function Zone.scenedraw(camera)
  for _, zone in ipairs(array) do
    local conf = zone.config
    
    zone:render()

    conf.zonedraw(zone)
  end
end



return Zone

