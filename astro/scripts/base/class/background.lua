local Background = {}

-- ==========================
-- =====   CLASS DATA   =====
-- ==========================
Background.name = 'Background'

Background.MAX_ID = 100
Background.MAX_AMOUNT = 9999

local List = {}
local class_mt = {__type = "background"}



Background.config = {}
local config = Background.config




function Background.list()
  local out = {}
  for i = 1, #List do
    table.insert(out, List[i])
  end
  return out
end


function Background.get(idx)
  return List[idx]
end


function Background.register(conf)
  conf.name = Misc.default(conf.name, config[0].name)
  conf.layers = {}
  
  config[conf.id] = conf

  return config[conf.id]
end

function Background.registerLayer(conf, layer)
  layer.idx, id = (#conf.layers + 1), conf.id
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
    
    layer.config = conf.layers[idx]

    layer.variant = Misc.default(1)

    layer.frame = Misc.default(1)
    layer.frametimer = Misc.default(layer.config.framespeed, 8)
  
    layer.color = Misc.default(layer.config.color, {1, 1, 1, 1})

    layer.x, layer.y = 0, 0
    layer.xamount, layer.yamount = 1, 1
    
    background.layers[idx] = layer
  end
  
  --- Methods ---
  background.render = Background.render
  background.attach = Background.attach


  table.insert(List, background)

  return background
end



function Background.render(background)
  for idx = 1, #background.layers do
    local layer = background.layers[idx]
    local conf = layer.config

    love.graphics.setColor(conf.color)

    for i = 1, layer.xamount do
      for j = 1, layer.yamount do
        love.graphics.draw(conf.texture, conf.quads[layer.variant][layer.frame], layer.x + conf.texturewidth*(i - 1), layer.y + conf.textureheight*(j - 1))
      end
    end
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

      layer.frametimer = layer.frametimer - 1
      if layer.frametimer < 0 then
        layer.frametimer = conf.framespeed
        layer.frame = layer.frame + 1
        if layer.frame > conf.frames then
          layer.frame = 1
        end
      end

    end

    -- background.config.backgroundupdate(background, dt)

  end
end

function Background.scenedraw(camera)
  for _, background in ipairs(Background.list()) do
    for idx, layer in ipairs(background.layers) do
      local conf = layer.config
      -- if background.section.idx == camera.section.idx then

      if conf.xtype == 'bound' then
        layer.x = camera.x + (camera.width - conf.texturewidth)*(layer.box.x - camera.x)/(camera.width - layer.box.width)
      elseif conf.xtype == 'scroll' then
        layer.x = camera.x - ((conf.xscroll*(camera.x - layer.box.x) + conf.xspeed*Misc.frames()) % conf.texturewidth)
      end
      
      if conf.ytype == 'bound' then
        layer.y = camera.y + (camera.height - conf.textureheight)*(layer.box.y - camera.y)/(camera.height - layer.box.height)
      elseif conf.ytype == 'scroll' then
        layer.y = camera.y - ((conf.yscroll*(camera.y - layer.box.y) + conf.yspeed*Misc.frames()) % conf.textureheight)
      end
      
      layer.xamount = ((conf.xloop and conf.xtype == 'scroll') and math.ceil(camera.width/conf.texturewidth) + 1) or 1
      layer.yamount = ((conf.yloop and conf.ytype == 'scroll') and math.ceil(camera.height/conf.textureheight) + 1) or 1
      
      love.graphics.setColor(conf.fillcolor[1], conf.fillcolor[2], conf.fillcolor[3], conf.fillcolor[4])
      love.graphics.rectangle('fill', camera.x, camera.y, camera.width, camera.height)
      background:render(camera)

      -- conf.backgrounddraw(background)
      -- end
    end
  end
end


setmetatable(Background, {__call = function(t, ...) return Background.get(...) end})

return Background

