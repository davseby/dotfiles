#!/bin/bash

# Close all polybar instances
killall -q polybar

# Wait for those instances to shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep; done

# Launch new polybar
polybar primary &

if [ $(xrandr -q | grep " connected" | wc -l) -eq 2 ]
then
	polybar secondary &
fi
