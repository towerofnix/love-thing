
local Actor = {}

function Actor:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o, self:init(o)
end

function Actor:init (self)
  self.x = -120
  self.y = 40
end

function Actor:setPosition (self, x, y)
  -- The position that the actor image is drawn on the screen.
  self.x = x
  self.y = y
end

function Actor:setPose (self, image)
  -- The actor image that is drawn to the screen.

  self.oldPose = self.pose
  self.oldPoseX = 0
  self.newPoseX = 120
  self.oldPoseGhost = 0

  self.pose = image
end

function Actor:draw (self)
  if self.oldPose then
    local ghost = (255 / 100 * self.oldPoseGhost)

    love.graphics.setColor(255, 255, 255, 255 - ghost)
    love.graphics.draw(self.oldPose, self.x + self.oldPoseX, self.y)

    love.graphics.setColor(255, 255, 255, ghost)
    love.graphics.draw(self.pose, self.x + self.newPoseX, self.y)

    love.graphics.setColor(255, 255, 255)


    self.oldPoseX = self.oldPoseX + 0.05 * (-180 - self.oldPoseX)
    self.newPoseX = self.newPoseX + 0.4 * (0 - self.newPoseX)
    self.oldPoseGhost = self.oldPoseGhost + 10

    if self.oldPoseGhost >= 100 then
      self.oldPose = nil
    end
  else
    love.graphics.draw(self.pose, self.x, self.y)
  end
end

return Actor