#!/bin/bash

# Extract the exports because the minifier will eat them.
grep "\-- export:" ButtonHUD.lua | sed -e 's/^[ \t]*/        /' -e 's/-- export:/--export:/' > ButtonHUD.exports
VERSION_NUMBER=`grep "VERSION_NUMBER = .*" ButtonHUD.lua | sed -E "s/\s*VERSION_NUMBER = (.*)/\1/"`

sed "/-- export:/d" ButtonHUD.lua > ButtonHUD.extracted.lua

# Minify the lua
if "$1" == "true"; then
    node_modules/.bin/luamin --file ButtonHUD.extracted.lua > ButtonHUD.min.lua
else
    cp ButtonHUD.extracted.lua ButtonHUD.min.lua
fi

# Wrap in AutoConf
lua wrap.lua --handle-errors --output yaml --name "ButtonsHud - Dimencia and Archaegeo v$VERSION_NUMBER (Minified)" ButtonHUD.min.lua ButtonHUD.wrapped.conf --slots core:class=CoreUnit radar:class=RadarPVPUnit,select=manual antigrav:class=AntiGravityGeneratorUnit warpdrive:class=WarpDriveUnit gyro:class=GyroUnit weapon:class=WeaponUnit,select=manual dbHud:class=databank vBooster:class=VerticalBooster hover:class=Hovercraft door:class=DoorUnit,select=manual forcefield:class=ForceFieldUnit,select=manual atmofueltank:class=AtmoFuelContainer,select=manual spacefueltank:class=SpaceFuelContainer,select=manual rocketfueltank:class=RocketFuelContainer,select=manual

# Re-insert the exports
sed '/script={}/e cat ButtonHUD.exports' ButtonHUD.wrapped.conf > ButtonHUD.conf

# Fix up minified L_TEXTs which requires a space after the comma
sed -i -E 's/L_TEXT\(("[^"]*"),("[^"]*")\)/L_TEXT(\1, \2)/g' ButtonHUD.conf