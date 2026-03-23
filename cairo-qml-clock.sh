#!/bin/bash
cd ~/Projects/cairo-to-qml-clock
QML_XHR_ALLOW_FILE_READ=1 qml main.qml &
sleep 1
wmctrl -r "Cairo Clock" -b add,sticky
wait
