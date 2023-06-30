local ID = ID

local r, g, b, a = love.math.colorFromBytes(24, 0, 0, 255)

local conf = Background.register{
  id = ID,
  name = 'SMB3 Underground',
  fillcolor = {r, g, b, a}
}

Background.registerLayer(conf, {
  name = 'Cave',

  xscroll = 0.5,
})