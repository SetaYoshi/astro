local lib = {}

local max = math.max 


local commList = {}
local key_mt = {}


function key_mt.__index(t, k)
  if k == "up" then
    return not t.state 
  elseif k == "down" then
    return t.state
  elseif k == "pressed" or k == "press" then
    return t.timer == 1
  elseif k == "released" or k == "release" then
    return t.timer == -1
  elseif k == "downtime" then
    return max(0, t.timer)
  elseif k == "uptime" then
    return max(0, -t.timer)
  else
    return rawget(t, k)
  end
end


local function updateCommKey(keyNames)
  for _, name in ipairs(keyNames) do
    if love.keyboard.isDown(name) then return true end
  end
  return false
end

local function updateKeyTimer(timer, state, prevstate)
  if state then
    return (prevstate and timer + 1) or 1
  else
    return (not prevstate and timer - 1) or -1
  end
end

local function updateComm(comm)
  for _, key in pairs(comm.keys) do
    key.prevstate = key.state
    key.state = updateCommKey(key.values)
    key.timer = updateKeyTimer(key.timer, key.state, key.prevstate)
  end
end

function lib.register(name, data)
  local comm = {}
  
  table.insert(commList, name)

  comm._active = true
  comm._update = updateComm

  comm.keys = {}
  for keyName, values in pairs(data) do
    if type(values) == 'string' then
      values = {values}
    end

    local key = {state = false, prevstate = false, timer = -2, values = values}
    setmetatable(key, key_mt)

    comm.keys[keyName] = key
    comm[keyName] = key
  end

  lib[name] = comm

  return comm
end


function lib.update()
  for _, commName in ipairs(commList) do
    if lib[commName]._active then lib[commName]:_update() end
  end
end

return lib