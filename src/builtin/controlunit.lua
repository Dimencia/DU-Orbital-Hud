ControlUnit = require('src.builtin.element')

-- Stops the control units Lua code and exits. Warning: calling this might cause your ship to fall from the sky,
-- use it with care. It is typically used in the coding of emergency control unit scripts to stop control once
-- the ECU thinks that the ship has safely landed.
function ControlUnit.exit() 
end

-- Set up a timer with a given tag ID in a given period. This will start to trigger the 'tick' event with 
-- the corresponding ID as an argument, to help you identify what is ticking, and when.
function ControlUnit.setTimer(timerTagId, period)
end

-- Stop the timer with the given ID
function ControlUnit.stopTimer(timerTagId)
end

-- Returns the local atmosphere density, between 0 and 1
function ControlUnit.getAtmosphereDensity()
end

-- Returns the closest planet influence, between 0 and 1
function ControlUnit.getClosestPlanetInfluence()
end

-- Return the relative position (in world coordinates) of the player currently running the control unit
function ControlUnit.getMasterPlayerRelativePosition()
end

-- Return the ID of the player currently running the control unit
function ControlUnit.getMasterPlayerId()
end

-- Automatically assign the engines within the taglist to result in the given acceleration and 
-- angular acceleration provided. Can only be called within the system.flush event. If engines 
-- designated by the tags are not capable of producing the desired command, setEngineCommand 
-- will try to do its best to approximate it.
function ControlUnit.setEngineCommand(taglist, acceleration, angularAcceleration, keepForceCollinearity, keepTorqueCollinearity, priority1SubTags, priority2SubTags, priority3SubTags, toleranceRatioToStopCommand)
end

-- Force the thrust value for all the engines within the tag list
function ControlUnit.setEngineThrust(taglist, thrust)
end

-- Set the value of throttle in the cockpit, which will be displayed in the cockpit widget when flying
function ControlUnit.setAxisCommandValue(axis, commandValue)
end

-- Get the value of throttle in the cockpit
function ControlUnit.getAxisCommandValue(axis)
end

-- Set the properties of an axis command These properties will be used to display the command in UI
function ControlUnit.setupAxisCommandProperties(axis, commandType)
end

-- Get the current master mode in use. The mode is set by clicking the UI button or using the associated keybinding
function ControlUnit.getControlMasterModeId()
end

-- Cancel the current master mode in used
function ControlUnit.cancelCurrentControlMasterMode()
end

-- Check landing gear status
function ControlUnit.isAnyLandingGearExtended()
end

-- Extend/activate/drop the landing gears
function ControlUnit.extendLandingGears()
end

-- Retract/deactivate the landing gears
function ControlUnit.retractLandingGears()
end

-- Check if a mouse control scheme is selected
function ControlUnit.isMouseControlActivated()
end

-- Check if the mouse control direct scheme is selected
function ControlUnit.isMouseDirectControlActivated()
end

-- Check if the mouse control virtual joystick scheme is selected
function ControlUnit.isMouseVirtualJoystickActivated()
end

-- Check lights status
function ControlUnit.isAnyHeadlightSwitchedOn()
end

-- Switch on the lights
function ControlUnit.switchOnHeadlights()
end

-- Switch off the lights
function ControlUnit.switchOffHeadlights()
end

-- Check if the construct is remote controlled
function ControlUnit.isRemoteControlled()
end

-- The ground engines will stabilize to this altitude within their limits.
-- The stabilization will be done by adjusting thrust to never go over the target altitude.
-- This includes VerticalBooster and HoverEngine
function ControlUnit.activateGroundEngineAltitudeStabilization(targetAltitude)
end

-- Return the ground engines stabilization altitude
function ControlUnit.getSurfaceEngineAltitudeStabilization()
end

-- The ground engines will behave like regular engine.
-- This includes VerticalBooster and HoverEngine
function ControlUnit.deactivateGroundEngineAltitudeStabilization()
end

-- Returns ground engine stabilization altitude capabilities (lower and upper ranges)
function ControlUnit.computeGroundEngineAltitudeStabilizationCapabilities()
end

-- Return the current throttle value
function ControlUnit.getThrottle()
end