json = require ('src.du.dkjson')
require 'src.du.Helpers'
require 'src.du.AxisCommand'
require 'src.du.Navigator'
require 'src.du.database'
require 'src.du.cpml.sgui'
require 'src.du.pl.init'

require 'src.builtin.antigravitygeneratorunit'
require 'src.builtin.atmofuelcontainer'
require 'src.builtin.atmosphericengine'
require 'src.builtin.controlunit'
require 'src.builtin.coreunit'
require 'src.builtin.counterunit'
require 'src.builtin.databankunit'
require 'src.builtin.detectionzoneunit'
require 'src.builtin.doorunit'
require 'src.builtin.element'
require 'src.builtin.emitterunit'
require 'src.builtin.engine'
require 'src.builtin.firework'
require 'src.builtin.forcefieldunit'
require 'src.builtin.gyrounit'
require 'src.builtin.hovercraft'
require 'src.builtin.industryunit'
require 'src.builtin.itemcontainer'
require 'src.builtin.landinggearunit'
require 'src.builtin.laserdetectorunit'
require 'src.builtin.laseremitterunit'
require 'src.builtin.library'
require 'src.builtin.lightunit'
require 'src.builtin.manualbuttonunit'
require 'src.builtin.manualswitchunit'
require 'src.builtin.pressuretileunit'
require 'src.builtin.radarunit'
require 'src.builtin.radarpvpunit'
require 'src.builtin.receiverunit'
require 'src.builtin.rocketengine'
require 'src.builtin.rocketfuelcontainer'
require 'src.builtin.screenunit'
require 'src.builtin.spaceengine'
require 'src.builtin.spacefuelcontainer'
require 'src.builtin.system'
require 'src.builtin.telemeterunit'
require 'src.builtin.verticalbooster'
require 'src.builtin.warpdriveunit'
require 'src.builtin.weaponunit'

databank = DataBankUnit -- Oddly this appears to be the class name used for slots...

-- Commonly-defined items
unit = ControlUnit
library = Library
system = System

currentGroundAltitudeStabilization = 0

--
-- BEGIN DU-generated Prologue
--
-- category panel display helpers
_autoconf = {}
_autoconf.panels = {}
_autoconf.panels_size = 0
_autoconf.displayCategoryPanel = function(elements, size, title, type, widgetPerData)
    widgetPerData = widgetPerData or false -- default to one widget for all data
    if size > 0 then
        local panel = system.createWidgetPanel(title)
        local widget
        if not widgetPerData then
            widget = system.createWidget(panel, type)
        end
        for i = 1, size do
            if widgetPerData then
                widget = system.createWidget(panel, type)
            end
            system.addDataToWidget(elements[i].getDataId(), widget)
        end
        _autoconf.panels_size = _autoconf.panels_size + 1
        _autoconf.panels[_autoconf.panels_size] = panel
    end
end
_autoconf.hideCategoryPanels = function()
    for i=1,_autoconf.panels_size do
        system.destroyWidgetPanel(_autoconf.panels[i])
    end
end

-- 
-- END DU-generated Prologue
--

-- This is a localization macro replaced by DU at script load time
function L_TEXT(lid, default)
end