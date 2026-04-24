#!/bin/bash

CURRENT=$(powerprofilesctl get)

case $CURRENT in
  performance)
    powerprofilesctl set balanced
    ;;
  balanced)
    powerprofilesctl set power-saver
    ;;
  power-saver)
    powerprofilesctl set performance
    ;;
esac

# Get updated state AFTER switching
NEW=$(powerprofilesctl get)

# Map icons (optional but cleaner UX)
case $NEW in
  performance)
    ICON="⚡"
    MSG="Performance Mode"
    ;;
  balanced)
    ICON="🔋"
    MSG="Balanced Mode"
    ;;
  power-saver)
    ICON="🌱"
    MSG="Power Saver Mode"
    ;;
esac

# Send notification
notify-send "Power Profile Changed" "$ICON $MSG"