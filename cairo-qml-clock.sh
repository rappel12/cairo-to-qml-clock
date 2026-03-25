#!/bin/bash
QML=/usr/bin/qml
if [ ! -f "$QML" ]; then
    QML=/usr/lib64/qt6/bin/qml
fi
if [ ! -f "$QML" ]; then
    QML=$(find /usr -name "qml" -type f 2>/dev/null | head -1)
fi
QML_XHR_ALLOW_FILE_READ=1 $QML /usr/share/cairo-qml-clock/main.qml &
sleep 1
wmctrl -r "Cairo Clock" -b add,sticky
xdotool search --name "Cairo Clock" set_desktop_for_window 0xffffffff
wait
