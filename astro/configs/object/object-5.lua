local ID = ID

Object.register{
  id = ID,
  name = 'BGO',

  drawObject = function(object)
    local conf = BGO.config[object.id]

    love.graphics.draw(conf.e_texture, conf.e_quads[object.variant], object.x, object.y)
  end
}