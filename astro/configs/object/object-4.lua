local ID = ID

Object.register{
  id = ID,
  name = 'NPC',

  drawObject = function(object)
    local conf = NPC.config[object.id]

    love.graphics.draw(conf.e_texture, conf.e_quads[object.variant], object.x, object.y)
  end
}