local NPC = Engine.newItemClass{
  name = 'NPC',
  MAX_ID = 100,
  MAX_AMOUNT = 9999,

  methods = {"render", "remove"}
}

local animate = require("animate")

local array = NPC.array
local config = NPC.config

function NPC.create(id, x, y, data)
  local npc = {}

  if type(id) == 'table' and not x then
    data = id
  else
    data = data or {}
    data.id, data.x, data.y = id, x, y
  end

  local conf = config[data.id]
  

  npc.config = conf
  npc.permID = NPC.newPermID()

  --- Properties ---
  npc.id = data.id
  npc.x = data.x
  npc.y = data.y

  npc.variant = Misc.default(data.variant, 1)

  npc.frame = Misc.default(data.frame, 1)
  npc.frametimer = conf.framespeed
  npc.color = Misc.default(data.color, conf.color)


  for _, methodname in ipairs(NPC.methods) do
    npc[methodname] = NPC[methodname]
  end


  NPC.add(npc)

  conf.npccreate(npc)
  Engine.callEvent('npccreate', npc)

  setmetatable(npc, NPC.mt)

  return npc
end

function NPC.remove(item)
  NPC.sub(item)
end

function NPC.render(npc)
  love.graphics.setColor(npc.color)
  love.graphics.draw(npc.config.texture, npc.config.quads[npc.variant][npc.frame], npc.x, npc.y)
end


function NPC.update()
  for _, npc in ipairs(array) do
    local conf = npc.config

    animate.updateItem(npc)

    conf.npcupdate(npc, dt)
  end
end

function NPC.scenedraw(camera)
  for _, npc in ipairs(array) do
    local conf = npc.config

    if not conf.disablerender then
      npc:render()
    end

    if conf.draw then
      conf.npcdraw(npc)
    end
  end
end


setmetatable(NPC, {__call = function(t, ...) return NPC.get(...) end})

return NPC

