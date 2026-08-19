#!/bin/bash

NAME="server"

echo "$NAME"
echo '$NAME'
echo "Server: $NAME"

DISK_USAGE=85
THRESHOLD=80

if [ "$DISK_USAGE" -gt "$THRESHOLD" ]; then
	echo "Warning: Disk usage is High"
else
	echo "OK: Disk usage is Normal"
fi

