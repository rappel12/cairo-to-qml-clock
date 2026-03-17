# Cairo-to-QML Clock Port

## Status (as of March 11, 2026)
- Frameless transparent window
- 29 themes: 10 custom (C_ prefix), 18 original cairo-clock, 1 reserved (glassy)
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
  C_Anticko/                    - 12 SVG files + theme.conf
  C_glassybest/                 - 12 SVG files + theme.conf
  C_Plain-Clock-Roman-Numerals/ - 12 SVG files + theme.conf
  C_railway2/                   - 12 SVG files + theme.conf
  C_Rauland/                    - 12 SVG files + theme.conf
  C_Rauland-vintage/            - 12 SVG files + theme.conf
  C_Rhythm/                     - 12 SVG files + theme.conf
  C_siemens/                    - 12 SVG files + theme.conf
  C_street-clock/               - 12 SVG files + theme.conf
  C_wood/                       - 12 SVG files + theme.conf
  glassy/                       - reserved for original cairo-clock theme (to be added)
  antique/                      - original cairo-clock theme
  default/                      - original cairo-clock theme
  default-24/                   - original cairo-clock theme (24h)
  fdo/                          - original cairo-clock theme
  funky/                        - original cairo-clock theme
  gremlin/                      - original cairo-clock theme
  gremlin-24/                   - original cairo-clock theme (24h)
  ipulse/                       - original cairo-clock theme
  ipulse-24/                    - original cairo-clock theme (24h)
  quartz-24/                    - original cairo-clock theme (24h)
  radium/                       - original cairo-clock theme
  radium-24/                    - original cairo-clock theme (24h)
  silvia/                       - original cairo-clock theme
  silvia-24/                    - original cairo-clock theme (24h)
  simple/                       - original cairo-clock theme
  simple-24/                    - original cairo-clock theme (24h)
  tango/                        - original cairo-clock theme
  zen/                          - original cairo-clock theme

## Known Issues
- SVG hand files have embedded PNGs with offset pivot points
  making native SVG hand rotation unreliable
- Current solution: Canvas-drawn hands over SVG face layers
- Properties dialog theme dropdown always displays C_Anticko at top
- showDate checkbox state not pre-populated when Properties opens

## Next Steps
1. Implement "stick to every workspace" behavior
2. Package as .deb/.rpm
3. Make GitHub repository public
4. Implement 24-hour mode for -24 themes
