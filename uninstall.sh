#!/bin/bash

BINDIR=/usr/local/bin
LIBDIR=/usr/local/share/midi
INITDIR=/etc/init.d
UDEVDIR=/etc/udev/rules.d

if `grep -q midi-user /etc/passwd`; then
    echo "Remove non-privileged user for MIDI bridge"
    userdel -r midi-user
fi

echo "Remove program and support scripts from $BINDIR"

rm -f $BINDIR/midi_bridge_connect
rm -f $BINDIR/midi_bridge_disconnect

echo "Remove Python modules from $LIBDIR"
rm -rf $LIBDIR

echo "Remove udev rules from $UDEVDIR and refresh system"

rm -f $UDEVDIR/50-midi-usb.rules
rm -f $UDEVDIR/60-midi-bluetooth.rules

udevadm control --reload

echo "Done!"
