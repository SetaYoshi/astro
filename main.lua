-- NEW REQUIRE PATH
love.filesystem.setRequirePath( "astro/?.lua;" .. "astro/?/init.lua;" .. "astro/scripts/?.lua;" .. "astro/scripts/?/init.lua;".. love.filesystem.getRequirePath( ))


-- NEW REQUIRE FUNCTION
local loadedPackages = {}
local old_require = require
function require(lib)
  local x = old_require(lib)
  if lib ~= 'ffi' and lib ~= 'bit' then
    loadedPackages[lib] = x
  end
  return x
end


-- WHEN GAME CRASHES, CALL THIS FUNCTION
function RESET()
  local lome = table.clone(_G.LoadingMethod)
  Engine.resetEvents()

  for libname in pairs(loadedPackages) do
    package.loaded[libname] = nil
  end

  _G.LoadingMethod = lome
  _G.LoadingMethod.reset = false

  INIT()
  love.load()
end


-- IS THIS A GOOD WAY TO RESET A LEVEL IF LUA CODE CRASHES?
-- I REALLY DONT KNOW. IF THERE IS A BETTER WAY, PLEASE LET ME KNOW!!! :-)
function SAFE(name, func)
  love[name] = function(...)
    local args = {...}
    
    -- Method 1
    func(unpack(args))

    -- Method 2
    -- success, chunk = pcall(function() func(unpack(args)) end)
    -- if not success then
    --   love.window.showMessageBox("ERROR", tostring(chunk))
    --   RESET()
    -- end

  end
end


-- LOAD THE ENGINE
function INIT()

  -- === IN THEORY...THIS SHOULD NEVER BREAK === --

  -- Method 1
  require("astro")

  -- Method 2
  -- success, chunk = pcall(function() require("astro") end)
  -- if not success then
  --   love.window.showMessageBox("ERROR", tostring(chunk))
  --   RESET()
  --   return
  -- end
  
  -- =========================================== --

end


-- LET'S MAKE IT HAPPEN!!!
INIT()

