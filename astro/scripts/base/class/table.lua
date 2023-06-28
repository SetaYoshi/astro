function table.iclone(t)
  local copy = {}
  for k, v in ipairs(t) do
    copy[k] = v
   end

  return copy
end

function table.clone(t)
  local copy = {}
  for k, v in pairs(t) do
    copy[k] = v
   end

  return copy
end

function table.ideepclone(t)
  local copy = {}
  for k,v in ipairs(t) do
    if(type(v) == "table") then
      copy[k] = table.deepclone(v)
    else
      copy[k] = v
    end
  end
  setmetatable(copy, getmetatable(t))
  return copy
end

function table.deepclone(t)
  local copy = {}
  for k, v in pairs(t) do
    if(type(v) == "table") then
      copy[k] = table.deepclone(v)
    else
      copy[k] = v
    end
  end
  setmetatable(copy, getmetatable(t))
  return copy
end
  
function table.keys(t)
  local keys = {}
  for key in pairs(t) do
    table.insert(keys, key)
  end
  return keys
end

function table.ifind(t, v)
  for i = 1, #t do
    if t[i] == v then
      return i
    end
  end
end

function table.ishare(t1, t2)
  for i = 1, #t1 do
    for j = 1, #t2 do
      pp('a')
      if t1[i] == t2[j] then
        return true
      end
    end
  end
end

function table.multiInsert(t1, t2) 
  for _, v in ipairs(t2) do
    table.insert(t1, v)
  end
  return t1
end

function table.max(t)
  local max
  for k, v in pairs(t) do
    if not max or v > max then
      max = v
    end
  end
  return max
end