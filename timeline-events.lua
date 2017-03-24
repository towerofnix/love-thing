
local Events = {}

Events.template = {}

function Events.template:run ()
  --[[

    Called when the event is run, regardless of progression-direction.
    (That is, if going backwards and ending up on this event, the run method
    will still be called.)

  ]]
end

function Events.template:runForwards ()
  --[[

    Called when the event is run, but only if we ended up on this event by
    going forwards. Generally, state-changing should happen here.

    This is called before run.

  ]]
end

function Events.template:runBackwards ()
  --[[

    Called when the function is run, but only if we ended up on this event by
    going backwards.

    This is called before run.

  ]]
end

function Events.template:update ()
  --[[

    Called on every LÖVE update. If this returns false, the event will be
    considered not done, and the timeline will not continue to the next event.

  ]]

  return true
end

function Events.template:gotKeypressed (key, scancode, isRepeat)
  --[[

    Called when the LÖVE window gets keyboard data.

  ]]
end

function Events:createTemplateEvent ()
  local event = {}

  function get (table, key)
    return Events.template[key]
  end

  setmetatable(event, {__index = get})

  return event
end

function Events:waitFrames (o)
  --[[

    Quick example event that waits for a number of frames to be finished
    before continuing.

  ]]

  local event = Events:createTemplateEvent()

  local framesToWait = 0

  function event:run ()
    framesToWait = o.frames
  end

  function event:update ()
    if framesToWait <= 0 then
      return true
    else
      framesToWait = framesToWait - 1
      return false
    end
  end

  return event
end

function Events:waitForInput ()
  --[[

    Example event that waits for the user to input a key from the keyboard
    before continuing.

  ]]

  local event = Events:createTemplateEvent()

  local gotInput = false

  function event:run ()
    gotInput = false
  end

  function event:update ()
    return gotInput
  end

  function event:gotKeypressed ()
    gotInput = true
  end

  return event
end

function Events:dialog (o)
  local event = Events:createTemplateEvent()

  local gotContinue = false

  function event:run ()
    gotContinue = false
    o.dialog:setText(o.dialog, o.text)

    if o.actor then
      o.dialog:setActor(o.dialog, o.actor)
    else
      o.dialog:setActor(o.dialog, nil)
    end
  end

  function event:update ()
    if not o.dialog.isDone then
      o.dialog:update(o.dialog)
    end

    return o.dialog.isDone and gotContinue
  end

  function event:gotKeypressed (key)
    if key == "space" then
      gotContinue = true
    end
  end

  return event
end

function Events:pose (o)
  local oldPose = nil

  local event = Events:createTemplateEvent()

  function event:runForwards()
    oldPose = o.actor.pose
    o.actor:setPose(o.actor, love.graphics.newImage(o.file))
  end

  function event:restore()
    o.actor:setPose(o.actor, oldPose)
  end

  return event
end

return Events
