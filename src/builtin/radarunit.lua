RadarUnit = require('src.builtin.element')

-- Returns the current range of the radar 
function RadarUnit.getRange()
end

-- Returns the list of construct IDs currently detected in the range 
function RadarUnit.getEntries()
end

-- Return the player id of the owner of the given construct, if in range 
function RadarUnit.getConstructOwner(id)
end

-- Return the size of the bounding box of the given construct, if in range 
function RadarUnit.getConstructSize(id)
end

-- Return the type of the given construct 
function RadarUnit.getConstructType(id)
end

-- Return the world coordinates of the given construct, if in range 
function RadarUnit.getConstructWorldPos(id)
end

-- Return the world coordinates of the given construct's speed, if in range 
function RadarUnit.getConstructWorldVelocity(id)
end

-- Return the world coordinates of the given construct's acceleration, if in range 
function RadarUnit.getConstructWorldAcceleration(id)
end

-- Return the radar local coordinates of the given construct, if in range 
function RadarUnit.getConstructPos(id)
end

-- Return the radar local coordinates of the given construct's speed, if in range 
function RadarUnit.getConstructVelocity(id)
end

-- Return the radar local coordinates of the acceleration of the given construct, if in range 
function RadarUnit.getConstructAcceleration(id)
end

-- Return the name of the given construct, if defined 
function RadarUnit.getConstructName(id)
end

return RadarUnit
