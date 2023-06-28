local Engine = {}

local engine_mode = LoadingMethod.type

-- === CREATE THE ENGINE === --
_G.Engine = Engine

require("base.build")
require("base.events")
require("base.configs")
require("base.gclass")

-- === LOAD IN THE CLASS EXTENSIONS === --
require("base.class.table")
require("base.class.string")
require("base.class.math")

-- === LOAD IN ALL THE GAME CLASSES === --
_G.Misc       = require("base.class.misc")

_G.Camera     = require("base.class.camera")
_G.Controller = require("base.class.controller")
_G.Section    = require("base.class.section")

_G.Background = require("base.class.background")
_G.BGO        = require("base.class.bgo")
_G.Block      = require("base.class.block")
_G.EFX        = require("base.class.efx")
_G.Player     = require("base.class.player")
_G.NPC        = require("base.class.npc")
_G.Object     = require("base.class.object")
_G.SFX        = require("base.class.sfx")
_G.VFX        = require("base.class.vfx")
_G.Warp       = require("base.class.warp")
_G.Zone       = require("base.class.zone")

-- === LOAD IN THE PHYSICS SYSTEM === --
_G.Bump       = require("bump")
_G.World      = Bump.newWorld(16)

love.physics.setMeter(16)


-- DEBUG STUFF
_G.p  = Misc.print
_G.pp = Misc.popup

require("profiler")



function Engine.mode()
  return engine_mode
end

-- Save all the classes
local className_MAP = {}
for _, class in ipairs({Background, BGO, Block, Camera, Controller, EFX, NPC, Player, Section, SFX, VFX, Warp, Zone}) do
  className_MAP[class.name] = class
end
function Engine.class(name)
  return className_MAP[name]
end




return Engine