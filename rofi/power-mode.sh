#!/bin/bash

PROFILE=$(powerprofilesctl get)

# ---------- MAIN ----------
if [[ -z "$1" ]]; then


    # ---- POWER MODE ----
    
    [[ "$PROFILE" == "performance" ]] && echo "● Performance" || echo "○ Performance"
    [[ "$PROFILE" == "balanced" ]] && echo "● Balanced" || echo "○ Balanced"
    [[ "$PROFILE" == "power-saver" ]] && echo "● Power Saver" || echo "○ Power Saver"
    
    # ---- SESSION ----
    echo "󰌾  Lock"
   

    exit 0
fi

# ---------- ACTION ----------
case "$1" in
    *Performance*) powerprofilesctl set performance ;;
    *Balanced*) powerprofilesctl set balanced ;;
    *Saver*) powerprofilesctl set power-saver ;;

    *Lock*) hyprlock ;;
esac

pkill rofi