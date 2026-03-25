# Cairo-to-QML Clock Port

## Status (as of March 22, 2026)
- Frameless transparent window
- 30 themes organized in folder-based structure (see Theme Structure below)
- Theme-aware hand colors with automatic color correction on startup
- Smooth sweep second hand (16ms timer) — improved over original cairo-clock
- Right-click menu: Properties, Info, Quit
- Properties dialog with size presets (small/medium/large/extra large/custom)
- Custom size entry via editable spinboxes
- Folder selector ComboBox (favorites/bundled/custom) for theme browsing
- Show seconds toggle
- Show date toggle (European format DD/MM)
- Keep on top toggle
- Implement 24-hour mode for -24 themes
- Animation smoothness slider (3 levels)
- Sticks to every workspace
- Position/size/theme/settings memory (QtCore Settings)
- Draggable
- Developed with AI assistance as a learning project
- GPL v2 licensed (see LICENSE file)

## Advantages over original cairo-clock 0.3.4
- Runs on modern Linux (Qt6, no deprecated libglade2 dependency)
- Smoother second hand sweep
- Reliable keep-on-top behavior

## Dependencies
- Qt 6.8.2 (qt6-declarative-dev, qt6-declarative-dev-tools)
- qml-qt6
- Runner symlink: /usr/local/bin/qml -> /usr/lib/qt6/bin/qml

## Installation

### Debian/Ubuntu/MX Linux (.deb)
sudo dpkg -i cairo-qml-clock_0.1.0.deb

### Fedora (.rpm)
sudo dnf install cairo-qml-clock-0.1.0-1.fc43.noarch.rpm

### PCLinuxOS (.rpm)
sudo rpm -i cairo-qml-clock-0.1.0-1.fc43.noarch.rpm
Note: Built on Fedora 43 - fc43 label is cosmetic only

## Run
~/Projects/cairo-to-qml-clock/cairo-qml-clock.sh

## Theme Structure
Themes are organized into three subfolders:

themes/
  favorites/         - curated selection from bundled and custom (default folder)
    Anticko/
    glassybest/
    OldGold/
    Plain-Clock-Roman-Numerals/
    railway2/
    Rauland/
    Rauland-vintage/
    Rhythm/
    street-clock/
    wood/

  bundled/           - original cairo-clock themes, unmodified
    antique/
    default/
    default-24/
    fdo/
    funky/
    glassy/
    gremlin/
    gremlin-24/
    ipulse/
    ipulse-24/
    quartz-24/
    radium/
    radium-24/
    silvia/
    silvia-24/
    simple/
    simple-24/
    siemens/
    tango/
    zen/

  custom/            - locally created themes (empty, reserved for future use)

Each theme folder contains 12 SVG files + theme.conf

## Known Issues
- SVG hand files have embedded PNGs with offset pivot points
  making native SVG hand rotation unreliable
- Current solution: Canvas-drawn hands over SVG face layers
- Keep on top may have a brief delay activating on some window managers

## Next Steps


