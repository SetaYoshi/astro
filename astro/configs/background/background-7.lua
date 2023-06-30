local ID = ID

local r, g, b, a = love.math.colorFromBytes(0, 80, 192, 255)

local conf = Background.register{
  id = ID,
  name = 'SMB3 Underwater',
  fillcolor = {r, g, b, a}
}

Background.registerLayer(conf, {
  name = 'Reef',

  xscroll = 0.35,
})