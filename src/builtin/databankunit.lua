DataBankUnit = require('src.builtin.element')

-- Clear the data bank
function DataBankUnit.clear()
end

-- Returns all the keys in the data bank
function DataBankUnit.getNbKeys()
end

-- Returns 1 if the key is present in the data bank, 0 otherwise
function DataBankUnit.hasKey(key)
end

-- Stores a string value at the given key
function DataBankUnit.setStringValue(key,val)
end

-- Returns value stored in the given key as a string
function DataBankUnit.getStringValue(key)
end

-- Stores an integer value at the given key
function DataBankUnit.setIntValue(key,val)
end

-- Returns value stored in the given key as an integer
function DataBankUnit.getIntValue(key)
end

-- Stores a floating number value at the given key
function DataBankUnit.setFloatValue(key,val)
end

-- Returns value stored in the given key as a floating number
function DataBankUnit.getFloatValue(key)
end

return DataBankUnit