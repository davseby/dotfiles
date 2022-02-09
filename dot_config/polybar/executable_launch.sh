#!/bin/bash

# Close all polybar instances.
killall -q polybar

# Wait for those instances to shut down.
while pgrep -u $UID -x polybar >/dev/null; do sleep; done

# Launch main polybar.
polybar primary &

# Launch secondary polybar on all monitors that are not DP-2.
for m in $(xrandr -q | grep " connected" | cut -d" " -f1); do
	if [ $m != "DP-2" ]
	then
		MONITOR=$m polybar secondary &
	fi
done
