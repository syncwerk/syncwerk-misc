#!/bin/bash
# Workaround for
# OS X El Capitan
# 10.11.6
# Syncwerk App 5.1.4

killall syncwerk-app
killall syncwerk-daemon
killall ccnet

/Applications/Syncwerk\ Client.app/Contents/MacOS/syncwerk-app &
