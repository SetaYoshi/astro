-- This file is used as the default if any value is left blank
-- You can use this file to see what are all the global config values
-- Some blocks may have additional custom config values

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
  return 'Default GFX'
end)



-- Texture size 
config:prop('texturewidth', function(config)
  return 32
end)

config:prop('textureheight', function(config)
  return 32
end)



-- Animation
config:prop('disableanimation', function(config)
  return false
end)

config:prop('variants', function(config) 
  return math.floor(config.texture:getWidth()/config.texturewidth) 
end, 'texture', 'texturewidth')

config:prop('frames', function(config)
  return math.floor(config.texture:getHeight()/config.textureheight)
end, 'texture', 'textureheight')

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
  return false
end)

config:prop('animationsync', function(config)
  return true
end)



-- Default Movement
config:prop('xspeed', function(config)
  return 0
end)

config:prop('yspeed', function(config) 
  return 0
end)

config:prop('anglespeed', function(config)
  return 0
end)

config:prop('xacceleration', function(config)
  return 0
end)

config:prop('yacceleration', function(config) 
  return 0
end)

config:prop('angleacceleration', function(config)
  return 0
end)

config:prop('xdamp', function(config)
  return 1
end)

config:prop('ydamp', function(config) 
  return 1
end)

config:prop('angledamp', function(config)
  return 1
end)

config:prop('xspeedmax', function(config) 
  return 10
end)

config:prop('yspeedmax', function(config) 
  return 10
end)

config:prop('anglespeedmax', function(config)
  return 10
end)



-- Texture
config:prop('filepath', function(config) 
  return Misc.resolveImagePath("vfx-"..config.id, "vfx/vfx-"..config.id, "vfx-0", "vfx/vfx-0") 
end, 'id')

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
config:prop('life', function(config) 
  return -30  -- When > 0, then after x frames. When 0, then after one animation. When < 0, then it despawns after x frames offscreen
end)


config:ai('vfxucreate', function(config) 
  return function(vfx) end
end)

config:ai('vfxupdate', function(config) 
  return function(vfx, dt) end
end)

config:ai('vfxdraw', function(config)
  return function(vfx) end
end)

