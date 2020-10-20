IndustryUnit = require('src.builtin.element')

-- Start the production and it will run unless it is stopped or the input resources run out
function IndustryUnit.start()
end

-- Start maintaining the specified quantity. Resumes production when the quantity in the output
-- container is too low, and pauses production when it is equal or higher.
function IndustryUnit.startAndMaintain(qty)
end

-- Start the production of numBatches and then stop.
function IndustryUnit.batchStart(numBatches)
end

-- End the job and stop. Production keeps going until it is complete, then it switches to
-- "STOPPED" status. If the output container is full, then it switches to "JAMMED"
function IndustryUnit.softStop()
end

-- Stop production immediately. The resources are given back to the input container. If there is not enough
-- room in the input containers, production stoppage is skipped if alowingredientloss is set to 0,
-- or ingredients are lost if set to 1
function IndustryUnit.hardStop(allowIngredientLoss)
end

-- Get the status of the industry
function IndustryUnit.getStatus()
end

-- Get the count of completed cycles since the player started the unit
function IndustryUnit.getCycleCountSinceStartup()
end

-- Get the efficiency of the industry
function IndustryUnit.getEfficiency()
end

-- Get the time elapsed in seconds since the player started the unit for the latest time
function IndustryUnit.getUptime()
end

return IndustryUnit