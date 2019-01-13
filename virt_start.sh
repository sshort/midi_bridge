#!/bin/bash

# For testing.  Starts bridge on a virtual port so test 
# program can connect.
#
# On recent Linux systems, the listen port is called:
# "RtMidiIn Client:VIRT_PORT 131:0"
#

./midi_bridge_app \
    VIRT_PORT 2 \
    "midi:midi MIDI 1 20:0" 1 \
    preset.data \
    virt
