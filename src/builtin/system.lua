System = require('src.builtin.element')
-- Return the current key bound to the given action. Useful to display tips.
function System.getActionKeyName(actionName)
end

-- Control the display of the ontrol unit custom screen, where you can define customized display information
-- in HTML.
-- Note that this function is disabled if the player is not running the script explicitly.
function System.showScreen(state)
end

-- Set the content of the control unit custom screen with some HTML code
-- Note that this function is disabled if the player is not running the script explicitly.
function System.setScreen(content)
end

-- Create an empty panel
-- Note that this function is disabled if the player is not running the script explicitly.
function System.createWidgetPanel(label)
end

-- Destroy the panel
-- Note that this function is disabled if the player is not running the script explicitly.
function System.destroyWidgetPanel(panelId)
end

-- Create an empty widget and add it to a panel.
-- Note that this function is disabled if the player is not running the script explicitly.
function System.createWidget(panelId, type)
end

-- Destriy the widget.
-- Note that this function is disabled if the player is not running the script explicitly.
function System.destroyWidget(widgetId)
end

-- Create data
-- Note that this function is disabled if the player is not running the script explicitly.
function System.createData(dataJson)
end
-- destroy data
-- Note that this function is disabled if the player is not running the script explicitly.
function System.destroyData(dataId)
end

-- Update data
-- Note that this function is disabled if the player is not running the script explicitly.
function System.updateData(dataId, dataJson)
end

-- Add data to a widget
-- Note that this function is disabled if the player is not running the script explicitly.
function System.addDataToWidget(dataId, widgetId)
end

-- Remove data from a widget
-- Note that this function is disabled if the player is not running the script explicitly.
function System.removeDataFromWidget(dataId, widgetId)
end

-- Return the current value of the mouse wheel

function System.getMouseWheel()
end

-- Return the current value of the mouse delta X

function System.getMouseDeltaX()
end

-- Return the current value of the mouse delta Y

function System.getMouseDeltaY()
end

-- Return the current value of the mouse pos X

function System.getMousePosX()
end

-- Return the current value of the mouse pos Y

function System.getMousePosY()
end

-- Returns the current value of the mouse wheel.
-- Range: (0,1)
function System.getThrottleInputFromMouseWheel()
end

-- Returns the mouse input for the ship control action (forward/backward)
-- Range: (-1,1)
function System.getControlDeviceForwardInput()
end

-- Returns the mouse input for the ship control action (yaw right/left)
-- Range: (-1,1)
function System.getControlDeviceYawInput()
end

-- Returns the mouse input for the ship control action (right/left)
function System.getControlDeviceLeftRightInput()
end

-- Lock or unlock the mouse free look
-- Note that this function is disabled if the player is not running the script explicitly.
function System.lockView(state)
end

-- Returns the lock state of the mouse free look

function System.isViewLocked()
end

-- Freezes the character, liberating the associated movement keys to be used by the script.
-- Note that this function is disabled if the player is not running the script explicitly.
function System.freeze(state)
end

-- Returns the frozen status of the character
function System.isFrozen()
end

-- Return the current time since the arrival of the Arkship
function System.getTime()
end

-- Return the delta time of action updates (to use in action loop)
function System.getActionUpdateDeltaTime()
end

-- Return the name of the given player, if in range of visibility.
function System.getPlayerName(id)
end

-- Return the world position of the given player, if in range of visibility.
function System.getPlayerWorldPos(id)
end

-- Print a message to the lua console
function System.print(msg)
end

return System