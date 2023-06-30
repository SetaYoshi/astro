local VFX = Engine.newItemClass{
  name = 'VFX',
  MAX_ID = 100,
  MAX_AMOUNT = 128,

  methods = {"render", "remove"}
}

local animate = require("animate")

local array = VFX.array
local config = VFX.config

local propsFromConfig = {
  'priority', 'opacity', 'xscale', 'yscale', 'color', 
  'xspeed', 'yspeed', 'anglespeed',
  'xacceleration', 'yacceleration', 'angleacceleration',
  'xdamp', 'ydamp', 'angledamp', 
  'xspeedmax', 'yspeedmax', 'anglespeedmax',
  'life'
}

function VFX.create(id, x, y, data)
  local vfx = {}

  if type(id) == 'table' and not x then
    data = id
  else
    data = data or {}
    data.id, data.x, data.y = id, x, y
  end
  
  local conf = config[data.id]

  vfx.config = conf
  vfx.permID = VFX.newPermID()
  
  -- Properties --
  for _, propName in ipairs(propsFromConfig) do
    vfx[propName] = Misc.default(data[propName], conf[propName])
  end
  
  vfx.x = x
  vfx.y = y
  vfx.angle = Misc.default(data.angle, 0)
  
  vfx.variant = Misc.default(data.variant, 1)
  vfx.frame = Misc.default(data.frame, 1)
  vfx.frametimer = Misc.default(data.frametimer, 1)
  
  
  --- Methods ---
  for _, methodname in ipairs(VFX.methods) do
    vfx[methodname] = vfx[methodname]
  end

  VFX.add(vfx)

  conf.vfxcreate(vfx)
  Engine.callEvent('vfxcreate', vfx)

  setmetatable(vfx, VFX.mt)

  return vfx
end

function VFX.remove(item)
  VFX.sub(item)
end

local function TEMP_ON_SCREEN(vfx)
  if vfx.y > 0 and vfx.y < 600 then
    return true
  end
end

function VFX.render(vfx)
  love.graphics.setColor(vfx.color)
  love.graphics.draw(vfx.config.texture, vfx.config.quads[vfx.variant][vfx.frame], vfx.x, vfx.y)
end


function VFX.update(dt)
  for i = #array, 1, -1 do
    local vfx = array[i]

    local conf = vfx.config

    local killEffect

    local old_frame = vfx.frame
    animate.updateItem(vfx)
    if old_frame == conf.frames and vfx.frame == 1 and vfx.life == 0 then
      killEffect = true
    end


    vfx.x,      vfx.y      = vfx.x + vfx.xspeed,    vfx.y + vfx.yspeed
    vfx.xspeed, vfx.yspeed = vfx.xspeed*vfx.xdamp + vfx.xacceleration, vfx.yspeed*vfx.ydamp + vfx.yacceleration

    vfx.angle      = vfx.angle + vfx.anglespeed
    vfx.anglespeed = vfx.anglespeed*vfx.angledamp + vfx.angleacceleration


    if vfx.xspeedmax ~= -1 then
      vfx.xspeed = math.clamp(-vfx.xspeedmax, vfx.xspeedmax, vfx.xspeed)
    end
    if vfx.yspeedmax ~= -1 then
      vfx.yspeed = math.clamp(-vfx.yspeedmax, vfx.yspeedmax, vfx.yspeed)
    end
    if vfx.anglespeedmax ~= -1 then
      vfx.anglespeed = math.clamp(-vfx.anglespeedmax, vfx.anglespeedmax, vfx.anglespeed)
    end

    if vfx.life > 0 then
      vfx.life = vfx.life - 1
      killEffect = (vfx.life == 0)
    elseif vfx.life < 0 then
      -- vfx.hitcoll.x, vfx.hitcoll.y = vfx.x, vfx.y
      if not TEMP_ON_SCREEN(vfx) then
        vfx.life = vfx.life + 1
        killEffect = (vfx.life == 0)
      end
    end

    if killEffect then
      vfx:remove()
    else
      conf.vfxupdate(vfx, dt)
    end
  end
end

function VFX.scenedraw(camera)
  for _, vfx in ipairs(array) do
    local conf = vfx.config

    if not conf.disablerender then
      vfx:render()
    end

    conf.vfxdraw(vfx)
  end

  love.graphics.setColor(1, 1, 1, 1)
end



return VFX

