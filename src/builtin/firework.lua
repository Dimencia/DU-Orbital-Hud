Firework = require('src.builtin.element')

-- Fire the firework
function Firework.activate()
end
-- Set the delay before the launched fireworks explodes. Max = 5s
function Firework.setExplosionDelay(time)
end

-- Set the speed at which the firework will be launched in m/s (impacts its altitude, depending on local
-- gravity) Max = 200 m/s
function Firework.setLaunchSpeed(speed)
end

-- Set the type of the launched firework
-- type: 0=BALL, 1=PALMTREE, 2=RING, 3=SHOWER 
function Firework.setType(type)
end
-- Set the color of the launched firework
-- color: 0=BLUE, 1=GOLD, 2=GREEN, 3=PURPLE, 4=RED, 5=SILVER 
function Firework.setColor(color)
end
