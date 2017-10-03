#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Get monitor information
connected_monitors=($(xrandr --query | grep " connected" | cut -d" " -f1))
primary_monitor=($(xrandr --query | grep " connected primary" | cut -d" " -f1))

# If no primary, default to first
if [ -z "$primary_monitor" ]
then
  primary_monitor=${connected_monitors[0]}
fi

# Loop through each monitor
for m in $connected_monitors
do

  # Choose the bar
  [[ "$m" -eq "$primary_monitor" ]] && bar="primary" || bar="others"
  
  # Bring up the bar
  MONITOR=$m polybar --reload $bar &

done
