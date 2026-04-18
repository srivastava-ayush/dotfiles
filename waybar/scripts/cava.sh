#!/bin/bash

while read -r line; do
  IFS=';' read -ra values <<< "$line"

  bars=""
  for i in "${values[@]}"; do
    case $i in
      0) bars+="▁";;
      1) bars+="▂";;
      2) bars+="▃";;
      3) bars+="▄";;
      4) bars+="▅";;
      5) bars+="▆";;
      6) bars+="▇";;
      7) bars+="█";;
    esac
  done

  echo "$bars"
done < /tmp/cava.fifo