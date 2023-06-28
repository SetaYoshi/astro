local Camera = {}

-- ==========================
-- =====   CLASS DATA   =====
-- ==========================
Camera.name = 'Camera'

Camera.MAX_AMOUNT = 32

local List = {}
local class_mt = {__type = "camera"}
local max_idx = 0

function Camera.list()
  local out = {}
  for i = 1, #List do
    table.insert(out, List[i])
  end
  return out
end

function Camera.get(idx)
  return List[idx]
end

function Camera.create(x, y, data)
  if type(x) == 'table' and not y then
    data = x
  else
    data = data or {}
    data.x, data.y = x, y
  end

  max_idx = max_idx + 1

  local camera = {}

  camera.x = Misc.default(data.x, 0)
  camera.y = Misc.default(data.y, 0)

  camera.isFollowing = data.follow

TEMP_SCREEN_W=800
TEMP_SCREEN_H=600

  camera.width = Misc.default(data.width, data.widthscreen, TEMP_SCREEN_W)
  camera.height = Misc.default(data.height, data.heightscreen, TEMP_SCREEN_H)
  
  camera.xscreen = Misc.default(data.xscreen, 0)
  camera.yscreen = Misc.default(data.yscreen, 0)

  camera.widthscreen = Misc.default(data.widthscreen, camera.width, TEMP_SCREEN_W)
  camera.heightscreen = Misc.default(data.heightscreen, camera.height, TEMP_SCREEN_H)

  --  camera.idx = IDK_HOW_TO_DO_THIS
  
  camera.render = Camera.render
  camera.follow = Camera.follow
  camera.getScenePos = Camera.getScenePos

  table.insert(List, camera)

  return camera
end

function Camera.getScenePos(camera, x, y)
  return camera.x + camera.width*(x - camera.xscreen)/camera.widthscreen, camera.y + camera.height*(y - camera.yscreen)/camera.heightscreen
end

function Camera.follow(camera, object)
  camera.isFollowing = object
  camera.section = object.section
end

function Camera.unfollow(camera)
  camera.isFollowing = nil
end

function Camera.render(camera)
  local sx, sy, sw, sh = love.graphics.getScissor()
  
  love.graphics.push()

  love.graphics.translate(camera.xscreen, camera.yscreen)
  love.graphics.scale(camera.widthscreen/camera.width, camera.heightscreen/camera.height)
  love.graphics.translate(-camera.x, -camera.y)

  love.graphics.setScissor(camera.xscreen, camera.yscreen, camera.widthscreen, camera.heightscreen)
  
  
  Background.scenedraw(camera)
  Section.scenedraw(camera)
  BGO.scenedraw(camera)
  Block.scenedraw(camera)
  NPC.scenedraw(camera)
  Player.scenedraw(camera)
  VFX.scenedraw(camera)
  Warp.scenedraw(camera)
  Zone.scenedraw(camera)
  Object.scenedraw(camera)

  Engine.callEvent('scenedraw', camera)
  

  love.graphics.pop()
  
  love.graphics.setScissor(sx, sy, sw, sh)
end

function Camera.update()
  for idx, camera in ipairs(List) do
    local follow = camera.follow
    local section = Section(1)

    if camera.isFollowing then
      camera.x = (camera.isFollowing.x + 0.5*camera.isFollowing.width) - 0.5*camera.width
      camera.y = (camera.isFollowing.y + camera.isFollowing.height) - 0.5*camera.height
    end
    
    if not camera.noBounds and section then
      camera.x = math.clamp(section.x, section.x + section.width - camera.width, camera.x)
      camera.y = math.clamp(section.y, section.y + section.height - camera.height, camera.y)
    end
  end
end

function Camera.draw()
  for idx, camera in ipairs(List) do
    camera:render()
  end
end

setmetatable(Camera, {__call = function(t, ...) return Camera.get(...) end})

return Camera

