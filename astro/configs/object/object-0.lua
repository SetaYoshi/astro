-- This file is used as the default if any value is left blank
-- You can use this file to see what are all the global config values
-- Some objects may have additional custom config values

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
  return 'Default Object'
end)




config:ai('drawObject', function(config)
  return function() end
end)

