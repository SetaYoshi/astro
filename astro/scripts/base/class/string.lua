function string.startsWith(str, start)
  return str:sub(1, #start) == start
end

function string.endsWith(str, ending)
  return ending == "" or str:sub(-#ending) == ending
end

-- Stolen from SMBX2
function string.split(s, p, exclude, plain)
  if exclude == nil then exclude = false end
  if plain == nil then plain = true end
  
  local t = {}
  local i = 0
   
  if #s <= 1 then
    return {s}
  end
   
  while true do
    local ls, le = s:find(p, i, plain)	--find next split pattern
    if (ls ~= nil) then
      table.insert(t, string.sub(s, i, le - 1))
      i = ls + 1
      if exclude then
        i = le + 1
      end
    else
      table.insert(t, string.sub(s, i))
      break
    end
  end
  
  return t;
end