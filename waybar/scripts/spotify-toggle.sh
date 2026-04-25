#!/bin/bash

if ! pgrep -x spotify >/dev/null; then
    spotify &
  
fi

hyprctl dispatch togglespecialworkspace one