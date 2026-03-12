# Cairo-to-QML Clock Port

## Status (as of March 11, 2026)
- Frameless transparent window
- 10 themes: Anticko, Glassy, Glassybest, Railway2, Rauland, Rauland-vintage, Rhythm, Siemens, Wood, Street-clock
- Theme-aware hand colors with automatic color correction on startup
- Smooth sweep second hand (16ms timer) — improved over original cairo-clock
- Right-click menu: Properties, Info, Quit
- Properties dialog with size presets (small/medium/large/extra large/custom)
- Custom size entry via editable spinboxes
- Show seconds toggle
- Show date toggle (European format DD/MM)
- Keep on top toggle
- Animation smoothness slider (3 levels)
- Position/size/theme/settings memory (QtCore Settings)
- Draggable
- Developed with AI assistance as a learning project

## Advantages over original cairo-clock 0.3.4
- Runs on modern Linux (Qt6, no deprecated libglade2 dependency)
- Smoother second hand sweep
- Reliable keep-on-top behavior

## Dependencies
- Qt 6.8.2 (qt6-declarative-dev, qt6-declarative-dev-tools)
- qml-qt6
- Runner symlink: /usr/local/bin/qml -> /usr/lib/qt6/bin/qml

## Run
cd ~/Projects/cairo-to-qml-clock
qml main.qml

## Theme Structure
themes/
  Anticko/        - 12 SVG files + theme.conf
  glassy/         - 12 SVG files + theme.conf
  glassybest/     - 12 SVG files + theme.conf
  railway2/       - 12 SVG files + theme.conf
  Rauland/        - 12 SVG files + theme.conf
  Rauland-vintage/ - 12 SVG files + theme.conf
  Rhythm/         - 12 SVG files + theme.conf
  siemens/        - 12 SVG files + theme.conf
  wood/           - 12 SVG files + theme.conf
  street-clock/   - 12 SVG files + theme.conf

## Known Issues
- SVG hand files have embedded PNGs with offset pivot points
  making native SVG hand rotation unreliable
- Current solution: Canvas-drawn hands over SVG face layers
- Properties dialog theme dropdown always displays Anticko at top
- showDate checkbox state not pre-populated when Properties opens

## Next Steps
1. Stick to every workspace
2. Info dialog (Credits, License)
3. Add original cairo-clock themes
4. Rename custom themes with C_ prefix
5. Package as .deb/.rpm
6. Publish to GitHub (public)
