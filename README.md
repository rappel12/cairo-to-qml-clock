nano ~/Projects/cairo-to-qml-clock/README.md
```

```
# Cairo-to-QML Clock Port

## Status (as of March 3, 2026)
- Frameless transparent window
- 8 themes: Anticko, Glassy, Glassybest, Railway2, Rauland, Rauland-vintage, Rhythm, Siemens
- Theme-aware hand colors
- Smooth sweep second hand (16ms timer)
- Right-click menu: theme switch, resize, quit
- Position/size/theme memory (QtCore Settings)
- Autostart on login (all DEs)
- Draggable



## Dependencies
- Qt 6.8.2 (qt6-declarative-dev, qt6-declarative-dev-tools)
- qml-qt6, qmlscene-qt6
- Runner symlink: /usr/local/bin/qml -> /usr/lib/qt6/bin/qml
- python3-pip, numpy, pillow (for theme preprocessing)

## Run
cd ~/Projects/cairo-to-qml-clock
qml main.qml

## Theme Structure
themes/
  Anticko/     - 12 SVG files + theme.conf
  glassybest/  - 12 SVG files + theme.conf

## Known Issues
- SVG hand files have embedded PNGs with offset pivot points
  making native SVG hand rotation unreliable
- Current solution: Canvas-drawn hands over SVG face layers
- Hand SVGs preprocessed by python script (pivot correction attempted)

## Next Steps
1. Properties dialog (match cairo-clock)
2. Show seconds toggle
3. 24h mode toggle
4. GitHub setup
5. Package as .deb/.rpm
