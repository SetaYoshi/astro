local ID = ID

local r, g, b, a = love.math.colorFromBytes(248, 176, 40, 255)

local conf = Background.register{
  id = ID,
  name = 'SMB3 Toad House',
  fillcolor = {r, g, b, a}
}

Background.registerLayer(conf, {
  name = 'Wall',

  xscroll = 0.5,

  ytype = 'scroll',
  yscroll = 1,
  yalign = 'top'
})
