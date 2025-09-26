#!/bin/bash

# Get the power consumption (energy rate in watts)
battery_info=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0)
power=$(echo "$battery_info" | grep "energy-rate" | awk '{print $2}')

# If you need to handle AC power or multiple batteries, you can modify accordingly.

# Print the power consumption with a label
echo "$power W"

