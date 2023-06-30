local ID = ID

local r, g, b, a = love.math.colorFromBytes(48, 0, 0, 255)

local conf = Background.register{
  id = ID,
  name = 'SMB3 Dungeon',
  fillcolor = {r, g, b, a}
}

Background.registerLayer(conf, {
  name = 'Dungeon',

  xscroll = 0.5,
})