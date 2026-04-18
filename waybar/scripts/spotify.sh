#!/bin/bash

player="spotify"

status=$(playerctl -p $player status 2>/dev/null)

if [ "$status" = "Playing" ] || [ "$status" = "Paused" ]; then
  artist=$(playerctl -p $player metadata artist)
  title=$(playerctl -p $player metadata title)

  echo "$artist - $title"
else
  echo "No music"
fi