local lg = love.graphics
local lm = love.mouse

local modules = (...):gsub('%.[^%.]+$', '') .. '.'
local baseNode = require(modules .. 'baseNode')
local utils = require(modules .. 'utils')

local quad = baseNode:extend('quad')

function quad:constructor()
  quad.super.constructor(self)
  self.w, self.h = 34, 34
  self.image_w, self.image_h = self.sw, self.sh
  self.quad = love.graphics.newQuad(self.sx, self.sy, self.sw, self.sh, self.image)
  self.keepAspectRatio = true
end

function quad:draw()
  if self.image then
    local _, fgc = self:getLayerColors()
    lg.setColor(1, 1, 1, 1)
    local sx, sy
    local x = self.x
    local y = self.y
    sx = self.w / self.sw
    sy = self.h / self.sh

    if self.keepAspectRatio then
      sx = 32/math.max(self.sw, self.sh)
      sy = sx

      if self.align == utils.alignments.LEFT then
        x = self.x
      end
      if self.align == utils.alignments.RIGHT then
        x = self.w - self.sw * sx
      end
    end

    if self.keepOriginalSize then
      x = self.x + self.w / 2 - self.sw / 2
      y = self.y + self.h / 2 - self.sh / 2
      sx, sy = 1, 1
    end

    if not self.enabled then
      lg.setShader(utils.disabledImgShader)
    end

    lg.setColor(0.4, 0.4, 0.4, 1)
    love.graphics.rectangle('fill', math.floor(x), math.floor(y), 34, 34)

    lg.setColor(1, 1, 1, 1)
    lg.draw(self.image, self.quad, math.floor(x) + 1, math.floor(y) + 1, 0, sx, sy)

    if not self.enabled then
      lg.setShader()
    end
  end
end

return quad
