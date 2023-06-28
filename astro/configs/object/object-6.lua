local ID = ID

Object.register{
  id = ID,
  name = 'Section',

  drawObject = function(object)    
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle('line', object.x, object.y, object.width, object.height)
    
    love.graphics.setColor(1, 1, 1, 1)
  end
}