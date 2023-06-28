-- This file is used as the default if any value is left blank
-- You can use this file to see what are all the global config values
-- Some npcs may have additional custom config values

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
  return 'Default NPC'
end)


-- Hitbox Size
config:prop('width', function(config)
  return 32
end)

config:prop('height', function(config)
  return 32
end)



-- Texture size (default to hitbox)
config:prop('texturewidth', function(config)
  return config.width
end, 'width')

config:prop('textureheight', function(config)
  return config.height
end, 'height')



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

config:prop('color', function(config)
  return {1, 1, 1, 1}
end)

config:prop('animationsync', function(config)
  return true
end)



-- Texture
config:prop('filepath', function(config) 
  return Misc.resolveImagePath("npc-"..ID, "npc/npc-"..ID,  "npc-0", "npc/npc-0") 
end)

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
  return Misc.resolveImagePath("npc-"..config.id.."-e", "npc/npc-"..config.id.."-e", "npc-"..config.id, "npc/npc-"..config.id, "npc-0", "npc/npc-0") or config.filepath
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
config:ai('npccreate', function(config) 
  return function(npc) end
end)

config:ai('npcupdate', function(config) 
  return function(npc, dt) end
end)

config:ai('npcdraw', function(config)
  return function(npc) end
end)

