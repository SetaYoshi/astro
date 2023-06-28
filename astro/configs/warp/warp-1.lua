local ID = ID

Warp.register{
  id = ID,
  name = 'Teleport',

  warpcontactplayer = function(warp, player)
    local offsetx, offsety = warp.xenter - player.x, warp.yenter - player.y
    player.x, player.y = warp.xexit - offsetx, warp.yexit - offsety
  end
}