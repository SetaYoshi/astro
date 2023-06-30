local events = {}

local comm = require("commander")

--[[
  load
  !exit

  baseupdates
  update
  postupdate

  basedraw
  scenedraw
  draw


  playerrun
  playerjump
  playerharm
  playerdeath

  npccreate
  !npcharm
  !npcdeath

  vfxcreate
  vfxdeath

  sfxcreate

  blockcreate
  blockdeath

  warpcontact
  warpenter

  !zonecontact

]]



function Engine.registerEvent(name, func)
  events[name] = events[name] or {}
  table.insert(events[name], func)
end

function Engine.callEvent(name, ...)
  if not events[name] then return end
  for _, func in ipairs(events[name]) do
    func(...)
  end
end

function Engine.resetEvents()
  for k in pairs(events) do
    events[k] = {}
  end
end

-- === THESE HANDLES ARE SPECIAL BECAUSE THEY HAVE CUSTOM CODE BUILT-IN === --
-- === LOAD, UPDATE, DRAW === --

function Engine.load(arg, unfilteredArg)
  Engine.loadConfigs(Background)
  Engine.loadConfigs(BGO)
  Engine.loadConfigs(Block)
  Engine.loadConfigs(EFX)
  Engine.loadConfigs(Player)
  Engine.loadConfigs(NPC)
  Engine.loadConfigs(Object)
  Engine.loadConfigs(SFX)
  Engine.loadConfigs(VFX)
  Engine.loadConfigs(Warp)
  Engine.loadConfigs(Zone)

  -- Create the controllers
  Controller.create({
    up      = "up",
    left    = "left",
    down    = "down",
    right   = "right",
    run     = "a",
    jump    = "z",
    altrun  = "s",
    altjump = "x",
    pause   = {"return", "escape"},
    special = {"rshift", "lshift", "space"},
  })
  
  -- Spawn in the game objects
  if LoadingMethod.type == 'mainmenu' then
    require("base.mainmenu")
  elseif LoadingMethod.type == 'level' then
    Engine.build(LoadingMethod.path)

    -- require() -- path to init file


    local background = Background.create(14)
    background:attach(Section(1))
    
  elseif LoadingMethod.type == 'edit' then
    Engine.editorBuild(LoadingMethod.path)
    require("base.editor")
  end

  -- Finally lib-based loads
  Engine.callEvent('load')


  -- local console = require("console")

end

function Engine.update(dt)
  -- First update the inputs
  comm.update(dt)

  -- Then all the classes in this order. These have their own custom per-object update
  Background.update(dt)
  BGO.update(dt)
  Block.update(dt)
  NPC.update(dt)
  Player.update(dt)
  VFX.update(dt)
  Zone.update(dt)
  Camera.update(dt)
  Warp.update(dt)
  Object.update(dt)

  -- Then lib-based updates
  Engine.callEvent('update', dt)
  
  -- Finally do on postupdate
  Engine.callEvent('postupdate', dt)

end

function Engine.draw()
  -- Render all the game objects. These have their own custom per-object draw
  love.graphics.push()
  Camera.draw()

  
  -- Then draw the hud on top
  
  -- Then lib-based draws
  Engine.callEvent('draw')
  love.graphics.pop()

  if LoadingMethod.reset then
    LoadingMethod.func(LoadingMethod.path)
  end
end

SAFE('load',   Engine.load)
SAFE('update', Engine.update)
SAFE('draw',   Engine.draw)


-- === THEN DO THE OTHER HANDLES === --
local handleList = {
  -- General
  'errhandler', 'lowmemory', 'quit', 'threaderror',

  -- Window
  'directorydropped', 'displayrotated', 'filedropped', 'focus', 'mousefocus', 'resize', 'visible',

  -- Keyboard
  'keypressed', 'keyreleased', 'textedited', 'textinput',

  -- Mouse 
  'mousemoved', 'mousepressed', 'mousereleased', 'wheelmoved',

  -- Joystick
  'gamepadaxis', 'gamepadpressed', 'gamepadreleased', 'joystickadded', 'joystickaxis', 'joystickhat', 'joystickpressed', 'joystickreleased', 'joystickremoved',

  -- Touch
  'touchmoved', 'touchpressed', 'touchreleased',
}

for _, handleName in ipairs(handleList) do
  events[handleName] = {}
  SAFE(handleName, function(...)
    Engine.callEvent(handleName, ...)
  end)
end