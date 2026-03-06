#!/bin/bash
echo "=== Cairo-to-QML Clock File Status ==="
echo ""
echo "Line counts (should all match):"
wc -l ~/Projects/cairo-to-qml-clock/main.qml \
       ~/Projects/cairo-to-qml-clock/main.qml.bak \
       ~/Projects/cairo-to-qml-clock/main.qml.txt \
       ~/Dropbox/Computer/cairo-to-qml-clock/main.qml
echo ""
echo "Dates and sizes:"
ls -la ~/Projects/cairo-to-qml-clock/main.qml \
       ~/Projects/cairo-to-qml-clock/main.qml.bak \
       ~/Projects/cairo-to-qml-clock/main.qml.txt \
       ~/Dropbox/Computer/cairo-to-qml-clock/main.qml
echo ""
echo "Themes in project:"
ls ~/Projects/cairo-to-qml-clock/themes/
echo ""
echo "Themes in Dropbox backup:"
ls ~/Dropbox/Computer/cairo-to-qml-clock/themes/
