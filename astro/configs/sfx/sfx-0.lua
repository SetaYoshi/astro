-- This file is used as the default if any value is left blank
-- You can use this file to see what are all the global config values
-- Some sfx may have additional custom config values

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
  return 'Default SFX'
end)

config:prop('filepath', function(config) 
  return Misc.resolveAudioPath("sfx-"..config.id, "sfx-0") 
end, 'id')


config:ai('sfxcreate', function(config) 
  return function(sfx) end
end)

config:ai('sfxupdate', function(config) 
  return function(sfx, dt) end
end)

config:ai('sfxdraw', function(config) 
  return function(sfx) end
end)