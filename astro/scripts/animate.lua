local animate = {}



function animate.updateItem(item)
  local conf = item.config

  if conf.disableanimation then return end

  if conf.animationsync then
    local t = Misc.frames()
    item.frametimer = 0
    item.frame = math.ceil(t/conf.framespeed)%conf.frames + 1
  else
    item.frametimer = item.frametimer - 1
    if item.frametimer <= 0 then
      item.frametimer = conf.framespeed
      item.frame = item.frame + 1
      if item.frame > conf.frames then
        item.frame = 1
      end
    end
  end
end



return animate