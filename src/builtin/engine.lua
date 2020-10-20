Engine = require('src.builtin.element')

-- Start the engine at full power (works only when run inside a cockpit or under remote control) 
function Engine.activate()
end

-- Stops the engine (works only when run inside a cockpit or under remote control) 
function Engine.deactivate()
end

-- Toggle the state of the engine 
function Engine.toggle()
end

-- Returns the activation state of the engine
function Engine.getState()
end

-- Set the engine thrust between 0 and max thrust
function Engine.setThrust(thrust)
end

-- Returns the maximal thrust the engine can deliver in principle, under optimal conditions.
-- Note that the actual max thrust will most of th etime be less than maxThrustBase
function Engine.getMaxThrustBase()
end

-- Returns the maximal thrust the engine can deliver at the moment, which might depend on various
-- conditions like atmospheric density, obstruction, orientation, etc. The actual thrust will be anything
-- below this maxThrust, which defines the current max capability of the engine.
function Engine.getCurrentMaxThrust()
end

-- Returns the minimal thrust the engine can deliver at the moment (can be more than zero),
-- which will depend on various conditions like atmospheric density, obstruction, orientation, etc.
-- Most of the time, this will be 0 but it can be greater than 0, particularly for ailerons, in which case
-- the actual thrust will be at least equal to minThrust.
function Engine.getCurrentMinThrust()
end

-- Returns the ratio between the current MaxThrust and the base MaxThrust
function Engine.getMaxThrustEfficiency()
end

-- Returns the current thrust level of the engine
function Engine.getThrust()
end

-- Returns the engine torque axis in world coordinates
function Engine.torqueAxis()
end

-- Returns the engine thrust direction un world coordinates
function Engine.thrustAxis()
end

-- Returns the distance to the first object detected in the direction of the thrust 
function Engine.getDistanceToObstacle()
end

-- is the engine out of fuel?
function Engine.isOutOfFuel()
end

-- Is the engine linked to a broken fuel tank?
function Engine.hasBrokenFuelTank()
end

-- The engine rate of fuel consumption per newton delivered per second
function Engine.getCurrentFuelRate()
end

-- Returns the ratio between the current fuel rate and the theoretical noninal fuel rate
function Engine.getFuelRateEfficiency()
end

-- The time needed for the engine to reach 50% of its maximal thrust
-- (all engines do not instantly reach the thrust that is set for them, but they can take time to "warm up" to the final value) 
function Engine.getT50()
end

-- If the engine exhaust is obstructed by some element or voxel material, it will stop working
-- or may work randomly in an instable way and you should probably fix your design
function Engine.isObstructed()
end

-- Returns the obstruction ratio of the engine exhaust by elements and voxels.
-- The more obstructed the engine is, the less properly it will work. Try to
-- fix your design if this is the case. 
function Engine.getObstructionFactor()
end

-- Tags of the engine
function Engine.getTags()
end

-- Set the tags of the engine
-- @param tags
function Engine.setTags(tags)
end

-- The current rate of fuel consumption in m^3/s
function Engine.getFuelConsumption()
end
