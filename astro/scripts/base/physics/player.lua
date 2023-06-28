local function check_block_collision(player, cols)
  local list = {bottom = {}, top = {}, left = {}, right = {}}

  for _, col in ipairs(cols) do
    if type(col.other) == 'Block' then
      local normal = col.normal
      if     normal.x == 0  and normal.y == -1 then
        table.insert(list.bottom, col)
      elseif normal.x == 0  and normal.y == 1  then
        table.insert(list.top, col)
      elseif normal.x == 1  and normal.y == 0  then
        table.insert(list.left, col)
      elseif normal.x == -1 and normal.y == 0  then
        table.insert(list.right, col)
      end
    end
  end

  return list
end

local function check_warp_collision(player, cols)
  local out = {}
  for _, col in ipairs(cols) do
      if type(col.other) == 'Warp' then
        table.insert(out, col.other)
      end
  end

  return out
end

local function check_zone_collision(player, cols)
  local out = {}
  for _, col in ipairs(cols) do
      if type(col.other) == 'Zone' then
        table.insert(out, col.other)
      end
  end

  return out
end

local function physics(player)

  local conf = player.config
  local keys = player.keys
  

  
  -- Increase jump height when running
  if player.isStanding then
    if math.abs(player.xspeed) >= conf.runspeed then
      player.jumpHeight = 15
    else
      player.jumpHeight = 10
    end
  end
  
  -- Running
  if keys.run.down then
    player.maxAccelerateX = conf.runspeed
  else
    player.maxAccelerateX = conf.walkspeed
  end

  -- HORIZONTAL MOVEMENT
  if keys.left.down then
    -- player.facing = 1
    if player.xspeed > player.maxAccelerateX * -1 then
        player.xspeed = player.xspeed - conf.walkAccelerateX
    end
    if player.xspeed > 0 then
        player.xspeed = player.xspeed - conf.friction
    end

  elseif keys.right.down then
    -- player.facing = 0
    if player.xspeed < player.maxAccelerateX then
        player.xspeed = player.xspeed + conf.walkAccelerateX
    end
    if player.xspeed < 0 then
        player.xspeed = player.xspeed + conf.friction
    end


  -- HORIZONTAL NO MOVE
  else
    if player.isStanding then
      local sign = math.sign(player.xspeed)
      if math.abs(player.xspeed) > 0 then
        if math.abs(player.xspeed) < conf.friction then
          player.xspeed = 0
        else
          player.xspeed = player.xspeed - sign*conf.friction
        end
      end
    end
  end
  

  -- Jump
  if keys.jump.pressed then
    if player.isStanding or (player.isInAirTimer < conf.coyotetimer and player.yspeed >= 0) and keys.jump.pressed or true then
      player.yspeed = player.yspeed - 8
      EFX.create(1)
    else
      if player.jumpHeight > 0 and player.yspeed < 0 then
        player.jumpHeight = player.jumpHeight - 1
        player.yspeed = player.yspeed - conf.gravity
      end
    end
  else
    if not player.isStanding then
      player.jumpHeight = 0
    end
  end
  
  
  -- Gravity
  if player.yspeed < conf.maxfallspeed then
    player.yspeed = math.min(conf.maxfallspeed, player.yspeed + conf.gravity)
  end
  
  -- Collision physics
  World:update(player, player.x, player.y, player.width, player.height)
    

  local xactual, yactual, cols, len = World:move(player, player.x + player.xspeed, player.y + player.yspeed, function(item, other)
    -- pp(type(other))
    if     type(other) == 'Block' then return 'slide'
    elseif type(other) == 'Zone'  then return 'cross'
    elseif type(other) == 'Warp'  then return 'cross'
    end
  end)
  player.x, player.y = xactual, yactual

  if len then
    -- WARP COLLISION
      local warp_List = check_warp_collision(player, cols)

      for _, warp in ipairs(Warp.array) do
        if table.ifind(warp_List, warp) then
          -- make sure warp.contactPlayers has player
          local found = table.ifind(warp.contactPlayers, player)
          if not found then
            table.insert(warp.contactPlayers, player)
          end
        else
          -- make sure warp.contactPlayers does not has player
          local found = table.ifind(warp.contactPlayers, player)
          if found then
            table.remove(warp.contactPlayers, found)
          end
        end
      end


      for i = #player.contactWarps, 1, -1 do
        player.contactWarps[i] = nil
      end
      for i = 1, #warp_List do
        player.contactWarps[i] = warp_List[i]
      end


    -- ZONE COLLISION
      local zone_List = check_zone_collision(player, cols)

      for _, zone in ipairs(Zone.array) do
        if table.ifind(zone_List, zone) then
          -- make sure zone.contactPlayers has player
          local found = table.ifind(zone.contactPlayers, player)
          if not found then
            table.insert(zone.contactPlayers, player)
          end
        else
          -- make sure zone.contactPlayers does not has player
          local found = table.ifind(zone.contactPlayers, player)
          if found then
            table.remove(zone.contactPlayers, found)
          end
        end
      end


      for i = #player.contactZones, 1, -1 do
        player.contactZones[i] = nil
      end
      for i = 1, #warp_List do
        player.contactZones[i] = zone_List[i]
      end



    -- BLOCK COLLISION
      local block_dirList = check_block_collision(player, cols)

      -- Collision checking
      if #block_dirList.bottom > 0 then  -- Floor touched
        local col = block_dirList.bottom[1]
        -- Set player to standing
        player.yspeed = 0

        player.isStanding = true
        player.isStandingObj = col.other
        player.isStandingTimer = player.isStandingTimer + 1

        player.isInAir = false
        player.isInAirTimer = 0
    
        col.other.color = {1, 0, 0, 1}
      else
        player.isStanding = false
        player.isStandingTimer = 0

        player.isInAir = true
        player.isInAirTimer = player.isInAirTimer + 1
      end
        
      if #block_dirList.top > 0 then  -- Ceiling touched
        local col = block_dirList.top[1]
        player.yspeed = 0
    
        col.other.color = {0, 1, 0, 1}
      end

      if #block_dirList.left > 0 then  -- Left wall touched
        local col = block_dirList.left[1]
        player.xspeed = 0
        col.other.color = {1, 0, 1, 1}
      end

      if #block_dirList.right > 0 then  -- Right wall touched
        local col = block_dirList.right[1]
        player.xspeed = 0

        col.other.color = {0, 1, 1, 1}
      end
  end
end


return physics
