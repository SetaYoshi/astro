local ID = ID

local r, g, b, a = love.math.colorFromBytes(104, 152, 248, 255)

local conf = Background.register{
  id = ID,
  name = 'SMB3 Clouds',
  fillcolor = {r, g, b, a}
}

Background.registerLayer(conf, {
  name = 'Clouds',

  xscroll = 0.25,
})