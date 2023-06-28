-- This file is used as the default if any value is left blank
-- You can use this file to see what are all the global config values
-- Some warps may have additional custom config values

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
  return 'Default Warp'
end)


config:prop('width', function(config)
  return 32
end)

config:prop('height', function(config)
  return 32
end)



-- AI

config:ai('warpcreate', function(config) 
  return function(warp, dt) end
end)

config:ai('warpupdate', function(config) 
  return function(warp, dt) end
end)

config:ai('warpdraw', function(config)
  return function(warp) end
end)

config:ai('warpcontactplayer', function(config) 
  return function(warp, player) end
end)
