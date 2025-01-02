#!/usr/bin/env bash

# TODO: Do this for the laptop too so external speakers don't break the script.
CARD=$(aplay -l | grep 'Sound BlasterX G6' | cut -d' ' -f 2 | tr -d ':')

amixer -c $CARD -q set "PCM Capture Source" "External Mic"
amixer -c $CARD -q sset "Input Gain Control" 100
