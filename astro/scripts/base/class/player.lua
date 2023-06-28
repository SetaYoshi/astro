local Player = Engine.newItemClass{
  name = 'Player',
  MAX_ID = 100,
  MAX_AMOUNT = 128,

  methods = {"render", "remove", "harm", "kill", "physics"}
}

Player.physics = require("base.physics.player")

local array = Player.array
local config = Player.config

function Player.create(id, x, y, data)
  local player = {}

  if type(id) == 'table' and not x then
    data = id
  else
    data = data or {}
    data.id, data.x, data.y = id, x, y
  end

  local conf = config[data.id]
  

  player.config = conf
  player.permID = Player.newPermID()

  --- Properties ---
  local controller = Controller(idx) or Controller(1)
  if controller then
   player.keys = controller.keys
  end
  
  player.x = data.x
  player.y = data.y
  
  player.width = Misc.default(data.width, conf.width)
  player.height = Misc.default(data.height, conf.height)

  player.id = Misc.default(data.id, 1)
  player.powerup = Misc.default(data.powerup, 'none')
  
  player.xspeed = Misc.default(data.xspeed, 0)
  player.yspeed = Misc.default(data.yspeed, 0)

  player.isStanding = false
  player.isStandingObj = nil
  player.isStandingTimer = 0

  player.isInAir = false
  player.isInAirTimer = 0

  player.section = Section.getFromCoords(player)
  player.color = Misc.default(data.color, conf.color)

  player.contactWarps = {}
  player.contactZones = {}

  World:add(player, player.x, player.y, player.width, player.height)
  
  
  for _, methodname in ipairs(Player.methods) do
    player[methodname] = Player[methodname]
  end
  
  Player.add(player)

  conf.playercreate(player)
  Engine.callEvent('playercreate', player)

  setmetatable(player, Player.mt)

  return player
end

function Player.remove(item)
  Player.sub(item)
end

function Player.harm(player)

  Engine.callEvent('playerharm', player)
end

function Player.kill(player)

  Engine.callEvent('playerdeath', player)
end

function Player.render(player)
  player.color = {1, 1, 1, 1}
  love.graphics.setColor(player.color)
  love.graphics.draw(player.config.texture, player.config.quads, player.x, player.y)
end

function Player.update()
  for _, player in ipairs(array) do
    local conf = player.config

    if not conf.disablephysics then
      player:physics()
    end

    conf.playerupdate(player)

    if player.keys.special.pressed then
      Engine.loadLevel('levels/test.star')
    end
  end
end

function Player.scenedraw(camera)
  for _, player in ipairs(array) do
    local conf = player.config

    if not conf.disablerender then
      player:render()
    end
    
    conf.playerdraw(player)
  end
  
  love.graphics.setColor(1, 1, 1, 1)
end



return Player