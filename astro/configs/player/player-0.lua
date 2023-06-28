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
  return 'Default Player'
end)


config:prop('width', function(config) 
  return 32
end)

config:prop('height', function(config) 
  return 32
end)


-- Physics Behavior
config:prop('disablephysics', function(config) 
  return false
end)

config:prop('enablejumping', function(config) 
  return true
end)

config:prop('enablerunning', function(config) 
  return true
end)

config:prop('enablesliding', function(config) 
  return true
end)

config:prop('enablespinjumping', function(config) 
  return true
end)

config:prop('enablewalljumping', function(config) 
  return true
end)

config:prop('enablegroundpound', function(config) 
  return true
end)



config:prop('gravity', function(config) 
  return 0.4
end)

config:prop('maxfallspeed', function(config) 
  return 12
end)

config:prop('jumpheight', function(config) 
  return 20
end)

config:prop('stompheight', function(config) 
  return 20
end)

config:prop('walljumpheight', function(config) 
  return 10
end)

config:prop('walkspeed', function(config) 
  return 3
end)

config:prop('runspeed', function(config) 
  return 6
end)

config:prop('coyotetimer', function(config) 
  return 30
end)

config:prop('friction', function(config) 
  return 0.1
end)

config:prop('walkAccelerateX', function(config) 
  return 0.14
end)



-- Texture
config:prop('filepath', function(config) 
  return Misc.resolveImagePath("player-"..config.id, "player/player-"..config.id, "player-0", "player/player-0") 
end, 'id')

config:prop('texture', function(config) 
  return love.graphics.newImage(config.filepath) 
end, 'filepath')

config:prop('quads', function(config)
  return love.graphics.newQuad(0, 0, config.width, config.height, config.texture)
end, 'texture', 'width', 'height')

config:prop('color', function(config)
  return {1, 1, 1, 1}
end)

-- AI
config:ai('playercreate', function(config) 
  return function(player, dt) end
end)

config:ai('playerupdate', function(config) 
  return function(player, dt) end
end)

config:ai('playerdraw', function(config)
  return function(player) end
end)
