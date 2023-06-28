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
  return 'Default BGO'
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
  return Misc.resolveImagePath("bgo-"..config.id, "bgo/bgo-"..config.id, "bgo-0", "bgo/bgo-0") 
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


-- Editor
config:prop('e_filepath', function(config) 
  return Misc.resolveImagePath("bgo-"..config.id.."-e", "bgo/bgo-"..config.id.."-e") or config.filepath
end, 'id', 'filepath')

config:prop('e_texture', function(config) 
  return love.graphics.newImage(config.e_filepath) 
end, 'e_filepath')

config:prop('e_xtexture', function(config) 
  return 0
end)

config:prop('e_ytexture', function(config)
  return 0
end)

config:prop('e_texturewidth', function(config) 
  return config.texturewidth
end, 'texturewidth')

config:prop('e_textureheight', function(config) 
  return config.textureheight
end, 'textureheight')

config:prop('e_quads', function(config)
  local quads = {}
  for i = 1, config.variants do
    quads[i] = love.graphics.newQuad(config.e_xtexture + config.e_texturewidth*(i - 1), config.e_ytexture, config.e_texturewidth, config.e_textureheight, config.e_texture)
  end
  return quads
end, 'e_xtexture', 'e_ytexture', 'e_texturewidth', 'e_textureheight', 'e_texture')


-- AI
config:ai('bgocreate', function(config) 
  return function(bgo) end
end)

config:ai('bgoupdate', function(config) 
  return function(bgo, dt) end
end)

config:ai('bgodraw', function(config)
  return function(bgo) end
end)

