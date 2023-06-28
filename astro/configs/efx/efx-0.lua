-- This file is used as the default if any value is left blank
-- You can use this file to see what are all the global config values
-- Some efxs may have additional custom config values

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
  return 'Default EFX'
end)



config:prop('disabled', function(config)
  return false
end)


-- AI
config:ai('efxcreate', function(config) 
  return function(efx) end
end)

config:ai('efxupdate', function(config) 
  return function(efx, dt) end
end)

config:ai('efxdraw', function(config)
  return function(efx) end
end)

