#!/usr/bin/env bash

rsync -a --exclude='logs' ~/.weechat .
tar czf weechat.tar.gz .weechat
rm weechat.tar.gz.gpg
gpg --recipient amosbird@gmail.com --encrypt weechat.tar.gz
rm weechat.tar.gz
rm -rf .weechat

cp ~/.config/sxhkd/sxhkdrc .
cp ~/.i3/config i3config
cp ~/.xprofile .
cp ~/.Xresources .
cp ~/.Xmodmap .
cp ~/urxvt-perls/osc-xterm-clipboard .

mkdir -p scripts
rsync -a ~/scripts/ scripts/
