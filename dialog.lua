
local Dialog = {}

local fontFile = "font/Comfortaa-Regular.ttf"
local speechFont = love.graphics.newFont(fontFile, 32)
local labelFont = love.graphics.newFont(fontFile, 24)

function Dialog:init (self)
  self.text = ""
  self.displayText = ""
  self.index = 0
  self.isDone = true
  self.actor = nil
  self.color = { 128, 128, 128 }

  self.transitionActor = nil
  self.transitionActorAnim = 1

  self.lastActor = nil
end

function Dialog:setText (self, text)
  self.text = text
  self.displayText = ""
  self.index = 0
  self.isDone = false
end

-- [nil -> Median]
-- [Median -> Beleth]

-- nil == median? nil -> median
-- median == median?
-- beleth == median? median -> beleth

function Dialog:setActor (self, actor)
  if not (actor == self.lastActor) then
    self.transitionActorAnim = 0
    self.oldActor = self.actor

    self.lastActor = actor
    self.actor = actor
  end
end

function Dialog:update (self)
  if self.index <= string.len(self.text) then
    self.displayText = (self.displayText ..
      string.sub(self.text, self.index, self.index))
    self.index = self.index + 1
  else
    self.isDone = true
  end
end

function Dialog:interpolateColor (self, color)
  self.color[1] = self.color[1] + 0.1 * (color[1] - self.color[1])
  self.color[2] = self.color[2] + 0.1 * (color[2] - self.color[2])
  self.color[3] = self.color[3] + 0.1 * (color[3] - self.color[3])
end

function Dialog:draw (self)
  local height = 180
  local top = love.graphics.getHeight() - height
  local width = love.graphics.getWidth()

  if self.actor then
    self:interpolateColor(self, self.actor.color)
  else
    self:interpolateColor(self, {128, 128, 128})
  end

  love.graphics.setColor(self.color[1], self.color[2], self.color[3], 128)

  love.graphics.rectangle("fill", 0, top, width, height)
  love.graphics.line(0, top, width, top)

  love.graphics.setColor(255, 255, 255)
  love.graphics.setFont(speechFont)
  love.graphics.print(self.displayText, 40, top + 40)

  function drawActorLabel(actor, transition)
    local labelWidth = 240
    local labelHeight = 40
    local labelTop = top - labelHeight
    local labelLeft = 0
    local labelDrawTop = labelTop + labelHeight * transition

    love.graphics.stencil(function ()
      love.graphics.rectangle("fill",
        labelLeft, labelTop, labelWidth, labelHeight)
    end)

    love.graphics.setStencilTest("greater", 0)

    local color = self.actor.color
    love.graphics.setColor(color[1], color[2], color[3], 200)
    love.graphics.rectangle("fill",
      labelLeft, labelDrawTop, labelWidth, labelHeight)

    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(labelFont)
    love.graphics.print(self.actor.name, labelLeft + 20, labelDrawTop + 7)

    love.graphics.setStencilTest()
  end

  if self.oldActor then
    drawActorLabel(self.oldActor, self.transitionActorAnim)
  end

  if self.actor then
    drawActorLabel(self.actor, 1 - self.transitionActorAnim)
  end

  if self.transitionActorAnim < 1 then
    self.transitionActorAnim = self.transitionActorAnim + 0.25 * (
      1 - self.transitionActorAnim)

    if self.transitionActorAnim >= 1 then
      self.transitionActorAnim = 1
    end
  end
end

return Dialog
