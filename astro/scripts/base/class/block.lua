local Block = Engine.newItemClass{
  name = 'Block',
  MAX_ID = 100,
  MAX_AMOUNT = 9999,

  methods = {"render", "remove"}
}

local animate = require('animate')

local array = Block.array
local config = Block.config

function Block.create(id, x, y, data)
  local block = {}

  if type(id) == 'table' and not x then
    data = id
  else
    data = data or {}
    data.id, data.x, data.y = id, x, y
  end

  local conf = config[data.id]
  
    
  block.config = conf
  block.permID = Block.newPermID()
  
  --- Properties ---
  block.id = data.id
  block.x = data.x
  block.y = data.y
  block.width = Misc.default(data.width, conf.width)
  block.height = Misc.default(data.height, conf.height)

  block.variant = Misc.default(data.variant, 1)
  
  block.frame = Misc.default(data.frame, 1)
  block.frametimer = conf.framespeed
  block.color = Misc.default(data.color, conf.color)
  
  World:add(block, block.x, block.y, block.width, block.height)

  
  for _, methodname in ipairs(Block.methods) do
    block[methodname] = Block[methodname]
  end


  Block.add(block)

  conf.blockcreate(block)
  Engine.callEvent('blockcreate', block)

  setmetatable(block, Block.mt)

  return block
end

function Block.remove(item)
  Block.sub(item)
end

function Block.render(block)
  love.graphics.setColor(block.color)
  love.graphics.draw(block.config.texture, block.config.quads[block.variant][block.frame], block.x, block.y)
end


function Block.update(dt)
  for _, block in ipairs(array) do
    block.color = {1, 1, 1, 1}
  end

  for _, block in ipairs(array) do
    local conf = block.config

    animate.updateItem(block)

    conf.blockupdate(block, dt)
  end
end

function Block.scenedraw(camera)
  for _, block in ipairs(array) do
    local conf = block.config

    if not conf.disablerender then
      block:render()
    end
    
    conf.blockdraw(block)
  end

  love.graphics.setColor(1, 1, 1, 1)
end



return Block

