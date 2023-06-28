local Controller = {}

-- ==========================
-- =====   CLASS DATA   =====
-- ==========================
Controller.name = 'Controller'

Controller.MAX_AMOUNT = 9999

local List = {}
local class_mt = {__type = "controller"}
local max_idx = 0

local comm = require("commander")

function Controller.get(idx)
  return List[idx]
end

function Controller.create(controls, data)
  if type(id) == 'table' and not x then
    data = id
  else
    data = data or {}
    data.controls = controls
  end

  max_idx = max_idx + 1

  local controller = comm.register("controller_"..max_idx, data.controls)
  
  -- controller.idx = IDK_HOW_TO_DO_THIS
  
  if max_idx < Player.MAX_AMOUNT then
    local player = Player(max_idx)
    if player then
      player.keys = controller.keys
    end
  end
  
  table.insert(List, controller)

  return controller
end

function Controller.enabled(controller, enable)
  comm["controller_"..controller.idx]._enabled = bool(enable)
end


setmetatable(Controller, {__call = function(t, ...) return Controller.get(...) end})

return Controller

