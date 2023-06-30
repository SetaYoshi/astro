-- This file is used as the default if any value is left blank
-- You can use this file to see what are all the global config values
-- Some backgrounds may have additional custom config values

--[[
  USAGE:
  config:prop(name, function(config) , ...)
    name: Name of property
    function(config): Function that must return the value, config is the config. Use this if the default is dependent on other config values
    ...: varargin of other values required to find this one
]]-- 

-- Meta Properties (REQUIRED)
config:prop('id', function(config)
  return ID
end)

config:prop('name', function(config)
  return 'Default Background'
end)


-- Texture size 
config:prop('texturewidth', function(config)
  return math.floor(config.texture:getWidth()/config.variants)
end, 'texture', 'variants')

config:prop('textureheight', function(config)
  return math.floor(config.texture:getHeight()/config.frames)
end, 'texture', 'frames')



-- Animation
config:prop('disableanimation', function(config)
  return false
end)

config:prop('variants', function(config) 
  return 1
end)

config:prop('frames', function(config)
  return 1
end)

config:prop('framespeed', function(config)
  return 8
end)

config:prop('priority', function(config)
  return 0
end)

config:prop('opacity', function(config)
  return 1
end)

config:prop('xscale', function(config)
  return 1
end)

config:prop('yscale', function(config)
  return 1
end)

config:prop('color', function(config)
  return {1, 1, 1, 1}
end)


-- Behavior

config:prop('xtype', function(config)
  return 'scroll'
end)

config:prop('ytype', function(config)
  return 'bound'
end)

config:prop('xloop', function(config)
  return true
end)

config:prop('yloop', function(config)
  return false
end)

config:prop('xscroll', function(config)
  return 0.5
end)

config:prop('yscroll', function(config)
  return 0.5
end)

config:prop('xspeed', function(config)
  return 0
end)

config:prop('yspeed', function(config)
  return 0
end)

config:prop('xoffset', function(config)
  return 0
end)

config:prop('yoffset', function(config)
  return 0
end)


-- Texture
config:prop('fillcolor', function(config) 
  return {0, 0, 0, 1}
end)

config:prop('filepath', function(config) 
  return Misc.resolveImagePath("background-"..config.id.."-"..config.idx, "background/background-"..config.id.."-"..config.idx, "background-0", "background/background-0") 
end, 'id', 'idx')

config:prop('texture', function(config) 
  return love.graphics.newImage(config.filepath) 
end, 'filepath')

config:prop('quads', function(config)
  local quads = {}
  for i = 1, config.variants do
    quads[i] = {}
    for j = 1, config.frames do
      quads[i][j] = love.graphics.newQuad(config.texturewidth*(i - 1), config.textureheight*(j - 1), config.texturewidth, config.textureheight, config.texture)
    end
  end
  return quads
end, 'texture', 'variants', 'frames', 'texturewidth', 'textureheight')




-- AI
config:ai('backgroundcreate', function(config) 
  return function(background) end
end)

config:ai('backgroundupdate', function(config) 
  return function(background, dt) end
end)

config:ai('backgrounddraw', function(config)
  return function(background) end
end)

