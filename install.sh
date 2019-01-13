#!/bin/bash

BINDIR=/usr/local/bin
LIBDIR=/usr/local/share/midi
INITDIR=/etc/init.d
UDEVDIR=/etc/udev/rules.d

if ! `grep -q midi-user /etc/passwd`; then
    echo "Create non-privileged user for MIDI bridge"
    useradd -m -s /bin/false -G plugdev,audio midi-user
else
    echo "midi user already exists"
fi

echo "Copy program and support scripts to $BINDIR"

if [ -f "$BINDIR/midi_bridge_connect" ]; then
    echo "Not overwriting existing midi_bridge_connect"
else
    cp -f midi_bridge_connect $BINDIR
    chmod 0755 $BINDIR/midi_bridge_connect
    chown root:root $BINDIR/midi_bridge_connect
fi

cp -f midi_bridge_stop $BINDIR
chmod 0755 $BINDIR/midi_bridge_disconnect
chown root:root $BINDIR/midi_bridge_disconnect

echo "Copy Python modules and parameter files to $LIBDIR"
[ -d $LIBDIR ] || mkdir -p $LIBDIR
cp -f *.py $LIBDIR

chown -R root:root $LIBDIR/*

echo "Copy udev rules to $UDEVDIR and refresh system"

if [ -f "$UDEVDIR/50-midi-usb.rules" ]; then
    echo "Not overwriting existing 50-midi-usb.rules"
else
    cp -f 50-midi-usb.rules $UDEVDIR
    chmod 0644 $UDEVDIR/50-midi-usb.rules
    chown root:root $UDEVDIR/50-midi-usb.rules
fi

if [ -f "$UDEVDIR/60-midi-bluetooth.rules" ]; then
    echo "Not overwriting existing 60-midi-bluetooth.rules"
else
    cp -f 60-midi-bluetooth.rules $UDEVDIR
    chmod 0644 $UDEVDIR/60-midi-bluetooth.rules
    chown root:root $UDEVDIR/60-midi-bluetooth.rules
fi

udevadm control --reload

echo "Done!"
