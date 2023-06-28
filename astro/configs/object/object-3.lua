local ID = ID

Object.register{
  id = ID,
  name = 'Zone',

  drawObject = function(object)
    local color = Zone.config[object.id].color
    local _, _, _, a = love.graphics.getColor()
    local w, h = object.width or 32, object.height or 32
    
    love.graphics.setColor(color[1], color[2], color[3], 0.1*a)
    love.graphics.rectangle('fill', object.x, object.y, w, h)
    
    love.graphics.setColor(color[1], color[2], color[3], a)
    love.graphics.rectangle('line', object.x, object.y, w, h)
    
    love.graphics.setColor(1, 1, 1, 1)
  end
}