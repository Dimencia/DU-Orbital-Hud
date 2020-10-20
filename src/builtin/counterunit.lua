CounterUnit = require('src.builtin.element')

-- Returns the rank of the currently active OUT plug 
function CounterUnit.getCounterState()
end

-- Moves the counter one step further (equivalent to signal received on the IN plug) 
function CounterUnit.next()
end

return CounterUnit