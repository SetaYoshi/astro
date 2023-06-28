local Section = {}

-- ==========================
-- =====   CLASS DATA   =====
-- ==========================
Section.name = 'Section'

Section.MAX_AMOUNT = 32

local List = {}
local class_mt = {__type = "section"}
local permIDMax = 0

function Section.list()
  local out = {}
  for i = 1, #List do
    table.insert(out, List[i])
  end
  return out
end

function Section.get(idx)
  return List[idx]
end

function Section.getFromCoords(x, y, w, h)
  local data = {}

  if type(x) == 'table' then
    data = x
  else
    data.x, data.y, data.width, data.height = x, y, w, h
  end
  
  for i = 1, permIDMax do
    local section = Section(i)
    if data.width and data.height then
      if Misc.collRectRect(section.x, section.y, section.width, section.height, data.x, data.y, data.width, data.height) then
        return true
      end
    else
      if Misc.collRectRect(section.x, section.y, section.width, section.height, data.x, data.y) then
        return true
      end
    end
  end
end

function Section.create(x, y, width, height, data)
  if type(x) == 'table' and not y then
    data = x
  else
    data = data or {}
    data.x, data.y, data.width, data.height = x, y, width, height
  end

  local section = {}

  permIDMax = permIDMax + 1
  section.permID = permIDMax

  section.x = data.x
  section.y = data.y

  section.width = Misc.default(data.width, TEMP_SCREEN_W)
  section.height = Misc.default(data.height, TEMP_SCREEN_H)
  
  section.idx = section.permID -- IDK_HOW_TO_DO_THIS
  
  section.render = Section.render

  if data.background then
    background.box = section
  end

  table.insert(List, section)

  return section
end

function Section.render(section)
  love.graphics.setColor(1, 0, 0, 1)
  love.graphics.rectangle('line', section.x, section.y, section.width, section.height)
  love.graphics.setColor(1, 1, 1, 1)
end

function Section.scenedraw(camera)
  for i = 1, permIDMax do
    Section(i):render()
  end
end

setmetatable(Section, {__call = function(t, ...) return Section.get(...) end})

return Section

