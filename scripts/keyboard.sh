#!/usr/bin/env bash

sudo systemd-hwdb update
sudo udevadm trigger
xmodemap ~/.Xmodmap
