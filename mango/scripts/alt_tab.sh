#!/bin/env bash

PIDFILE="/tmp/alt_tab_mango.pid"

if [ -f "$PIDFILE" ]; then
    mmsg dispatch focusstack, prev
    kill "$(cat "$PIDFILE")" 2>/dev/null
fi
echo $$ > "$PIDFILE"
mmsg dispatch zoom
sleep "$1"
rm -f "$PIDFILE"