--[[
  TODO:

  BIG BOY STUFF:
  Implement a idx property to every class
    - Needs to update properly even after item creation and death

  Custom collision system
    - Should allow for boxes, slopes, and circular slopes.
    - Needs to alllow for one way collision 

  Custom UI Lib
    - All UI Libs are bad except for the one you made yourself ;)

]] 


-- Set the true directory
local nativefs = require("nativefs")
nativefs.setWorkingDirectory(love.filesystem.getSource( ).."/astro/")

-- This decides what to do after each reload
LoadingMethod = LoadingMethod or {type = 'mainmenu'}


-- === LOAD IN THE ENGINEWORKS === --
require("base.engineworks")