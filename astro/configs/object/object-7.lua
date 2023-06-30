local ID = ID

Object.register{
  id = ID,
  name = 'Warp',

  drawObject = function(object)    
    love.graphics.setColor(0.9, 0, 0.85, 1)
    love.graphics.rectangle('line', object.xenter, object.yenter, object.widthenter, object.heightenter)

    love.graphics.setColor(0, 0.1, 0.9, 1)
    love.graphics.rectangle('line', object.xexit, object.yexit, object.widthexit, object.heightexit)
    
    love.graphics.setColor(1, 1, 1, 1)
  end
}