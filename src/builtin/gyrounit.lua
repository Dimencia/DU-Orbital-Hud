GyroUnit = require('src.builtin.element')

-- Selects this gyro as the main gyro used for ship orientation 
function GyroUnit.activate()
end

-- Deselects this gyro as the main gyro used for ship orientation, using the core unit instead 
function GyroUnit.deactivate()
end

--Toggle the activation state of the gyro 
function GyroUnit.toggle()
end

-- Returns the activation state of the gyro 
function GyroUnit.getState()
end

-- The up vector of the gyro unit in local coordinates
function GyroUnit.localUp()
end

-- The forward vector of the gyro unit in local coordinates
function GyroUnit.localForward()
end

-- The right vector of the gyro unit in local coordinates
function GyroUnit.localRight()
end

-- The up vector of the gyro unit in world coordinates
function GyroUnit.worldUp()
end

-- The forward vector of the gyro unit in world coordinates
function GyroUnit.worldForward()
end

-- The right vector of the gyro unit in world coordinates
function GyroUnit.worldRight()
end

-- The pitch value relative to the gyro orientation and local gravity.
function GyroUnit.getPitch()
end

-- The roll value relative to the gyro orientation and the local gravity.
function GyroUnit.getRoll()
end
