#!/usr/bin/env bash

rsync -a --exclude='logs' ~/.weechat .
tar czf weechat.tar.gz .weechat
rm weechat.tar.gz.gpg
gpg --recipient amosbird@gmail.com --encrypt weechat.tar.gz
rm weechat.tar.gz

rsync -a --exclude='Cache' --exclude='Media Cache' --exclude='Local Storage' ~/.config/vivaldi .
tar czf vivaldi.tar.gz vivaldi
rm vivaldi.tar.gz.gpg
gpg --recipient amosbird@gmail.com --encrypt vivaldi.tar.gz
rm vivaldi.tar.gz
rm -rf vivaldi
rm -rf .weechat
