local ID = ID

Object.register{
  id = ID,
  name = 'Block',

  drawObject = function(object)
    local conf = Block.config[object.id]

    love.graphics.draw(conf.e_texture, conf.e_quads[object.variant], object.x, object.y)
  end
}