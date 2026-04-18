#!/bin/bash

CHOICE=$(printf "performance\nbalanced\npower-saver" | wofi --dmenu --prompt "Power Profile")

case $CHOICE in
  performance) powerprofilesctl set performance ;;
  balanced) powerprofilesctl set balanced ;;
  power-saver) powerprofilesctl set power-saver ;;
esac

