Databank = require('src.builtin.element')

-- Clear the data bank
function Databank.clear()
end

-- Returns all the keys in the data bank
function Databank.getNbKeys()
end

-- Returns 1 if the key is present in the data bank, 0 otherwise
function Databank.hasKey(key)
end

-- Stores a string value at the given key
function Databank.setStringValue(key,val)
end

-- Returns value stored in the given key as a string
function Databank.getStringValue(key)
end

-- Stores an integer value at the given key
function Databank.setIntValue(key,val)
end

-- Returns value stored in the given key as an integer
function Databank.getIntValue(key)
end

-- Stores a floating number value at the given key
function Databank.setFloatValue(key,val)
end

-- Returns value stored in the given key as a floating number
function Databank.getFloatValue(key)
end