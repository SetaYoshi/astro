local ID = ID

local r, g, b, a = love.math.colorFromBytes(48, 0, 0, 255)

local conf = Background.register{
  id = ID,
  name = 'SMB3 Pipes',
  fillcolor = {r, g, b, a}
}

Background.registerLayer(conf, {
  name = 'Pipes',

  ytype = 'scroll',
  yloop = true,
  yscroll = 0.5,

  xscroll = 0.5,
})