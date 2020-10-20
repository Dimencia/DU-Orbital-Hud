Element = {}

-- Show the element
function Element.show()
end

-- Hide the element widget in the in-game widget stack
function Element.hide()
end

-- Get element data as json string
function Element.getData()
end

-- Get element data id
function Element.getDataId()
end

-- get widget type compatible with the element data
function Element.getWidgetType()
end

-- the element integrity between 0 and 100
function Element.getIntegrity()
end

-- The element current hitpoints (0 = destroyed)
function Element.getHitPoints()
end

-- The elements maximum hit points when it's fully functional
function Element.getMaxHitPoints()
end

-- A construct unique ID for the element
function Element.getId()
end

-- The mass of the element
function Element.getMass()
end

-- The class of the element
function Element.getElementClass()
end

-- Set the value of a signal in the specified IN plug of the element standard plug names are composed with the following syntax => direction-type-index where:
-- 'direction' can be IN or OUT, 
-- 'type' is one of the following => ITEM, FUEL, ELECTRICITY, SIGNAL, HEAT, FLUID, CONTROL
-- 'index' is a number between 0 and the total number of plugs of the given type in the given direction.
-- Some plugs have special names like "on" or "off" for the manual switch unit, just check in-game for the plug names if you have a doubt.
function Element.setSignalIn(plug, state) 
end

-- Return the value of a signal in the specified IN plug of the element. Standard plug names are composed with the following syntax => direction-type-index where:
-- 'direction' can be IN or OUT
-- 'type' is one of the following => ITEM, FUEL, ELECTRICITY, SIGNAL, HEAT, FLUID, CONTROL
-- 'index' is a number between 0 and the total number of plugs of the given type in the given direction.
-- Some plugs have special names like "on" or "off" for the manual switch unit, just check in-game for the plug names if you have a doubt.
function Element.getSignalIn(plug)
end

-- Return the value of a signal in the specified OUT plug of the element standard plug names are composed with the following syntax => direction-type-index where:
-- 'direction' can be IN or OUT
-- 'type' is one of the following => ITEM, FUEL, ELECTRICITY, SIGNAL, HEAT, FLUID, CONTROL
-- 'index' is a number between 0 and the total number of plugs of the given type in the given direction.
-- Some plugs have special names like "on" or "off" for the manual switch unit, just check in-game for the plug names if you have a doubt.
function Element.getSignalOut(plug)
end

return Element