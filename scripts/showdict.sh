#!/usr/bin/env bash

if pgrep -f stardict;
then
    :
else
    urxvt -name stardict -e sdcv &
    sleep 0.25
fi

i3-msg [instance="^stardict"] scratchpad show

{ read -r width; read -r height; } < <(i3-msg -t get_workspaces | jq -r 'map(select(.focused))[0].rect["width","height"]')
x=$((width/3 - 7))
y=$((height/3))
width=$((width/3 - 7))
height=$((height/2 - 7))

i3-msg [con_id="__focused__" instance="^stardict"] move position $x $y
i3-msg [con_id="__focused__" instance="^stardict"] resize set $width $height
