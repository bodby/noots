#!/usr/bin/env bash

CARD=$(aplay -l | grep 'HDA Analog' | cut -d' ' -f 2 | tr -d ':' | head -n 1)

amixer -c $CARD set Speaker unmute
