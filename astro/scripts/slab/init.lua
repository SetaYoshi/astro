--[[

MIT License

Copyright (c) 2019-2021 Love2D Community <love2d.org>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

--]]

-- Global path used in all modules in this library
SLAB_PATH = ...

local Slab = require(SLAB_PATH .. '.API')

local function load(args)
	Slab.Initialize(args, true)
end

local function update(dt)
	Slab.Update(dt)
end

local function draw()
	Slab.Draw()
end

local function _quit()
	Slab.OnQuit()
end

local function _keypressed(key, scancode, isrepeat)
	Slab.OnKeyPressed(key, scancode, isrepeat)
end

local function _keyreleased(key, scancode)
	Slab.OnKeyReleased(key, scancode)
end

local function _textinput(text)
	Slab.OnTextInput(text)
end

local function _wheelmoved(x, y)
	Slab.OnWheelMoved(x, y)
end

local function _mousemoved(x, y, dx, dy, istouch)
	Slab.OnMouseMoved(x, y, dx, dy, istouch)
end

local function _mousepressed(x, y, button, istouch, presses)
	Slab.OnMousePressed(x, y, button, istouch, presses)
end

local function _mousereleased(x, y, button, istouch, presses)
	Slab.OnMouseReleased( x, y, button, istouch, presses)
end

Engine.registerEvent('load', load)
Engine.registerEvent('update', update)
Engine.registerEvent('draw', draw)

Engine.registerEvent('quit', _quit)
Engine.registerEvent('keypressed', _keypressed)
Engine.registerEvent('keyreleased', _keyreleased)
Engine.registerEvent('textinput', _textinput)
Engine.registerEvent('mousemoved', _mousemoved)
Engine.registerEvent('mousepressed', _mousepressed)
Engine.registerEvent('mousereleased', _mousereleased)
-- Engine.registerEvent('wheelmoved', _wheelmoved)

return Slab
