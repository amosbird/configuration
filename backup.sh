#!/usr/bin/env bash

shopt -s extglob
cp -r ~/.weechat/!(logs) weechat/
tar czf weechat.tar.gz weechat
rm weechat.tar.gz.gpg
gpg --recipient amosbird@gmail.com --encrypt weechat.tar.gz
rm weechat.tar.gz
