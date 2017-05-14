#!/usr/bin/env bash

if pgrep -f urxvt_scratchpad;
then
    :
else
    /usr/bin/tmux new -s amos -d
    urxvt -name urxvt_scratchpad -e /usr/bin/tmux new -A -s amos &
    sleep 0.25
fi

{ read -r width; read -r height; } < <(i3-msg -t get_workspaces | jq -r 'map(select(.focused))[0].rect["width","height"]')
o=$width
width=$((width/2 - 7))
height=$((height-8))

i3-msg [instance="^urxvt_scratchpad"] scratchpad show
if [ "$1" -eq 1 ]
then
    i3-msg [con_id="__focused__" instance="^urxvt_scratchpad"] move position $((width + 7)) 22, resize set $width $height
elif [ "$1" -eq 2 ]
then
    i3-msg [con_id="__focused__" instance="^urxvt_scratchpad"] move position 2 22, resize set $width $height
else
    i3-msg [con_id="__focused__" instance="^urxvt_scratchpad"] move position 2 22, resize set $o $height
fi
