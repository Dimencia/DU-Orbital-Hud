#!/bin/bash
# We expect this file to be run from the <repo>/scripts directory
LUA_SRC=../src/ButtonHUD.lua
CONF_DST=../ButtonHUD.conf
mkdir -p work

# Extract the exports because the minifier will eat them.
grep "\-- \?export:" $LUA_SRC | sed -e 's/^[ \t]*/        /' -e 's/-- export:/--export:/' > work/ButtonHUD.exports
VERSION_NUMBER=`grep "VERSION_NUMBER = .*" $LUA_SRC | sed -E "s/\s*VERSION_NUMBER = (.*)/\1/"`

sed "/-- \?export:/d;/require 'src.slots'/d" $LUA_SRC > work/ButtonHUD.extracted.lua

# Minify the lua
if "$1" == "true"; then
    node_modules/.bin/luamin --file work/ButtonHUD.extracted.lua > work/ButtonHUD.min.lua
else
    cp work/ButtonHUD.extracted.lua work/ButtonHUD.min.lua
fi

# Wrap in AutoConf
lua wrap.lua --handle-errors --output yaml --name "ButtonsHud - Dimencia and Archaegeo v$VERSION_NUMBER (Minified)" work/ButtonHUD.min.lua work/ButtonHUD.wrapped.conf --slots core:class=CoreUnit radar:class=RadarPVPUnit,select=manual antigrav:class=AntiGravityGeneratorUnit warpdrive:class=WarpDriveUnit gyro:class=GyroUnit weapon:class=WeaponUnit,select=manual dbHud:class=databank vBooster:class=VerticalBooster hover:class=Hovercraft door:class=DoorUnit,select=manual forcefield:class=ForceFieldUnit,select=manual atmofueltank:class=AtmoFuelContainer,select=manual spacefueltank:class=SpaceFuelContainer,select=manual rocketfueltank:class=RocketFuelContainer,select=manual

# Re-insert the exports
sed '/script={}/e cat work/ButtonHUD.exports' work/ButtonHUD.wrapped.conf > $CONF_DST

# Fix up minified L_TEXTs which requires a space after the comma
sed -i -E 's/L_TEXT\(("[^"]*"),("[^"]*")\)/L_TEXT(\1, \2)/g' $CONF_DST

rm work/*