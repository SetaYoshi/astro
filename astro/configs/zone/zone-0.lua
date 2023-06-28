-- This file is used as the default if any value is left blank
-- You can use this file to see what are all the global config values
-- Some zones may have additional custom config values

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
  return 'Default Zone'
end)







-- Editor
config:prop('color', function(config) 
  return {1, 1, 1}
end)


-- AI
config:ai('zonecreate', function(config) 
  return function(zone) end
end)

config:ai('zoneupdate', function(config) 
  return function(zone, dt) end
end)

config:ai('zonedraw', function(config)
  return function(zone) end
end)

config:ai('zonecontactplayer', function(config)
  return function(zone, player) end
end)
