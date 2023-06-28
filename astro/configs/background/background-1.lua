local ID = ID

local conf = Background.register{
  id = ID,
  name = 'Test',
}

Background.registerLayer(conf, {
  name = 'Blocks',
  
  xspeed = 0.5,

  ytype = 'scroll',
  yspeed = 0,
})

Background.registerLayer(conf, {
  name = 'Sky',

  xspeed = 0.25,

  ytype = 'scroll',
  yoffset = 500,
  yspeed = 0,
})