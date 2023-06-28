
local function createDefaultConfig(class)
  local t = {}

  class.config[0] = {_props = {}, _ais = {}}

  t.prop = function(T, name, func, ...)
    local req = {...} or {}

    table.insert(class.config[0]._props, name)
    class.config[0][name] = {func = func, req = req}
  end

  t.ai = function(T, name, func, ...)
    table.insert(class.config[0]._ais, name)
    class.config[0][name] = {func = func, req = {}}
  end

  return t
end



local function loadthisconfig(class, name, id)
  local filename = name.."-"..id..".lua"
  local filepath = Misc.resolvePath(filename, name.."/"..filename, "configs/"..name.."/"..filename)

  _G.ID = id
  if filepath then
    require(filepath:sub(1, -5), true)
  else
    class.register{id = id, name = ''}
  end
end

function Engine.loadConfigs(class)
  _G.config = createDefaultConfig(class)
  loadthisconfig(class, class.name, 0)
  _G.config = nil

  for i = 1, class.MAX_ID do
    loadthisconfig(class, class.name, i)
  end

  _G.ID = nil
end

local function loadloadprop(config, name, default)
  if config[name] ~= nil then return end

  if not default[name] then
    Misc.popup('Invalid Config', name)
  end
  local func, req = default[name].func, default[name].req

  for _, v in ipairs(req) do
    loadloadprop(config, v, default)
  end
  
  config[name] = func(config)
end

function Engine.config(class, config)
  for _, name in ipairs(class.config[0]._props) do
    loadloadprop(config, name, class.config[0])
  end
  for _, name in ipairs(class.config[0]._ais) do
    loadloadprop(config, name, class.config[0])
  end

  config.isValid = config.name and config.name ~= ''

  return config
end
