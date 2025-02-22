#!/bin/bash

# Get the current sink name
sink_name=$(pactl info | grep "Default Sink" | awk -F": " '{print $2}' | awk -F"." '{print $2}')

# Get the current volume of the default sink
volume_percentage=$(pactl list sinks | grep -A 15 "$sink_name" | grep "Volume:" | head -n 1 | awk -F"/" '{print $2}' | sed 's/\s\+//g')

# Output the results
echo "$sink_name $volume_percentage"
