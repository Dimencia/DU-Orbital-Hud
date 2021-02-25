HeadlightGroundHeight = 150 --export: (Default: 150) Controls altitude to turn on/off Headlights. Turns off above value

local navBlinkSwitch = nil
local navLightSwitch = nil
local headLightSwitch = nil

function SetupChecks()
    if switch then 
        for _, v in pairs(switch) do
            local eID = v.getId()
            local name = core.getElementNameById(eID)
            if (name == "navBlinkSwitch") then
                navBlinkSwitch = v
            elseif (name == "navLightSwitch") then
                navLightSwitch = v
            elseif (name == "headLightSwitch") then
                headLightSwitch = v
            else
                v.toggle()
            end
        end
    end    
    
end

function script.onStart()
    beginSetup = coroutine.create(function()
        if navLightSwitch ~= nil then
            navLightSwitch.activate()
        end
        if headLightSwitch ~= nil then
            headLightSwitch.activate()
        end
    end)
end

function script.onStop()
    if navLightSwitch ~= nil then
        navLightSwitch.deactivate()
    end
end

function script.onTick(timerId)
    if timerId == "tenthSecond" then
        if navBlinkSwitch ~= nil then
            navBlinkSwitch.deactivate()
        end
    elseif timerId == "oneSecond" then
        if navBlinkSwitch ~= nil then
            navBlinkSwitch.activate()
        end
    elseif timerId == "apTick" then
        if headLightSwitch ~= nil then
            local groundHeight = core.getAltitude()
            if groundHeight < HeadlightGroundHeight then
                headLightSwitch.activate()
            else
                headLightSwitch.deactivate()
            end
        end
    end
end