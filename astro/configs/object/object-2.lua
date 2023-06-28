local ID = ID

local gx_defaultplayer = Misc.newImage("menu-playerstart", "menu/menu-playerstart")

local gx_playerstart = {
  Misc.newImage("menu-playerstart-1", "menu/menu-playerstart-1"),
  Misc.newImage("menu-playerstart-2", "menu/menu-playerstart-2"),
  Misc.newImage("menu-playerstart-3", "menu/menu-playerstart-3"),
  Misc.newImage("menu-playerstart-4", "menu/menu-playerstart-4"),
}

Object.register{
  id = ID,
  name = 'Player',

  drawObject = function(object)
    local texture = gx_playerstart[object.idx] 

    if texture then
      love.graphics.draw(texture, object.x, object.y)
    else
      love.graphics.draw(gx_defaultplayer, object.x, object.y)
      love.graphics.print(object.idx, object.x + 0.5*gx_defaultplayer:getWidth() - 8, object.y - 16)
    end
  end
}