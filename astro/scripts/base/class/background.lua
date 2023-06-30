local Background = Engine.newItemClass{
  name = 'Background',
  MAX_ID = 100,
  MAX_AMOUNT = 9999,

  methods = {"render", "remove", "attach"}
}

local animate = require("animate")

Background.permIDMaxLayer = 0

local array = Background.array
local config = Background.config


function Background.register(conf)
  conf.name = Misc.default(conf.name, config[0].name)

  conf.fillcolor = Misc.default(conf.fillcolor, {1, 1, 1, 1})

  conf.backgroundcreate = Misc.default(conf.backgroundcreate, function() end)
  conf.backgroundupdate = Misc.default(conf.backgroundupdate, function() end)
  conf.backgrounddraw = Misc.default(conf.backgrounddraw, function() end)

  conf.layers = {}
  
  config[conf.id] = conf

  return config[conf.id]
end

function Background.registerLayer(conf, layer)
  Background.permIDMaxLayer = Background.permIDMaxLayer + 1

  layer.idx, layer.permID, id = (#conf.layers + 1), Background.permIDMaxLayer, conf.id
  layer = Engine.config(Background, layer)
  conf.layers[layer.idx] = layer
  return layer
end

function Background.create(id, section, data)
  if type(id) == 'table' and not section then
    data = id
  else
    data = data or {}
    data.id, data.section = id, section
  end

  local background = {}
  local conf = config[data.id]
  
  --- Config ---
  background.config = conf
  -- background.idx = IDK_HOW_TO_DO_THIS 
  
  --- Properties ---
  background.id = data.id
  -- background.section = data.section or 1

  
  background.layers = {}
  for idx = 1, #conf.layers do
    local layer = {}
    
    layer.idx = idx
    layer.config = conf.layers[idx]

    layer.variant = Misc.default(1)

    layer.frame = Misc.default(1)
    layer.frametimer = Misc.default(layer.config.framespeed, 8)
  
    layer.color = Misc.default(layer.config.color, {1, 1, 1, 1})

    layer.x, layer.y = 0, 0
    layer.xamount, layer.yamount = 1, 1
    
    background.layers[idx] = layer
  end
  
  for _, methodname in ipairs(Background.methods) do
    background[methodname] = Background[methodname]
  end


  Background.add(background)

  conf.backgroundcreate(background)
  Engine.callEvent('backgroundcreate', background)

  setmetatable(background, Background.mt)

  return background
end

function Background.remove(item)
  Background.sub(item)
end

function Background.renderLayer(layer)
  local conf = layer.config
  
  love.graphics.setColor(conf.color)
  
  for i = 1, layer.xamount do
    for j = 1, layer.yamount do
      love.graphics.draw(conf.texture, conf.quads[layer.variant][layer.frame], layer.x + conf.texturewidth*(i - 1) + conf.xoffset, layer.y + conf.textureheight*(j - 1) - conf.yoffset)
    end
  end
end

function Background.render(background)
  for idx = 1, #background.layers do
    Background.renderLayer(background.layers[idx])
  end
end

function Background.attach(background, box)
  for idx, layer in ipairs(background.layers) do
    layer.box = box
  end
end

function Background.update(dt)
  for idx, background in ipairs(Background.list()) do
    
    for idx, layer in ipairs(background.layers) do
      local conf = layer.config

      animate.updateItem(layer)
    end

    background.config.backgroundupdate(background, dt)
  end
end


local function x_update(camera, layer)
  local conf = layer.config
  
  if conf.xtype == 'bound' then
    layer.x = camera.x + (camera.width - conf.texturewidth)*(layer.box.x - camera.x)/(camera.width - layer.box.width)
  elseif conf.xtype == 'scroll' then
    local xmove = conf.xscroll*(camera.x - layer.box.x) + conf.xspeed*Misc.frames()
    if conf.xloop then
      xmove = xmove % conf.texturewidth
    end
    layer.x = camera.x - xmove
  end
    
  layer.xamount = ((conf.xloop and conf.xtype == 'scroll') and math.ceil(camera.width/conf.texturewidth) + 1) or 1
end

local function y_update(camera, layer)
  local conf = layer.config
  
  if conf.ytype == 'bound' then
    layer.y = camera.y + (camera.height - conf.textureheight)*(layer.box.y - camera.y)/(camera.height - layer.box.height)
  elseif conf.ytype == 'scroll' then
    local ymove 
    if conf.yalign == 'top' then
      ymove = conf.yscroll*(camera.y - layer.box.y) + conf.yspeed*Misc.frames()
    elseif conf.yalign == 'bottom' then
      ymove = conf.yscroll*((camera.y + camera.height) - (layer.box.y + layer.box.height)) + conf.yspeed*Misc.frames()
    end
    
    if conf.yloop then
      ymove = ymove % conf.textureheight
    end
  
    if conf.yalign == 'top' then
      layer.y = camera.y - ymove 
    elseif conf.yalign == 'bottom' then
      layer.y = (camera.y + camera.height) - ymove - conf.textureheight
    end
  end
  
  layer.yamount = ((conf.yloop and conf.ytype == 'scroll') and math.ceil(camera.height/conf.textureheight) + 1) or 1
end


function Background.scenedraw(camera)
  for _, background in ipairs(Background.list()) do
    for idx, layer in ipairs(background.layers) do
      -- if background.section.idx == camera.section.idx then

      x_update(camera, layer)
      y_update(camera, layer)

      love.graphics.setColor(background.config.fillcolor)
      love.graphics.rectangle('fill', camera.x, camera.y, camera.width, camera.height)
      background:render(camera)

      background.config.backgrounddraw(background)
    end
  end
end



return Background

