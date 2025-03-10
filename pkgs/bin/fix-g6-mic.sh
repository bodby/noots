#!/usr/bin/env bash

CARD=$(aplay -l | grep 'Sound BlasterX G6' | cut -d' ' -f 2 | tr -d ':')

amixer -c "$CARD" -q set "PCM Capture Source" "External Mic"

return 0