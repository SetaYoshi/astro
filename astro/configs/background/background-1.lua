local ID = ID

local r, g, b, a = love.math.colorFromBytes(104, 152, 248, 255)

local conf = Background.register{
  id = ID,
  name = 'SMB3 Blocks',
  fillcolor = {r, g, b, a}
}

Background.registerLayer(conf, {
  name = 'Blocks',
  
  xscroll = 0.5,

  ytype = 'scroll',
  yscroll = 1,
})

Background.registerLayer(conf, {
  name = 'Clouds',

  xscroll = 0.25,

  ytype = 'scroll',
  yoffset = 500,
  yscroll = 1,
})