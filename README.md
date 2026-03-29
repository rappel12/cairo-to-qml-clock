# Cairo-to-QML Clock Port

## Status (as of March 27, 2026)
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
- 24-hour mode for -24 themes
- Animation smoothness slider (3 levels)
- Sticks to every workspace (X11 only)
- Position/size/theme/settings memory (QtCore Settings)
- Draggable on both X11 and Wayland
- Developed with AI assistance as a learning project
- GPL v2 licensed (see LICENSE file)

## Advantages over original cairo-clock 0.3.4
- Runs on modern Linux (Qt6, no deprecated libglade2 dependency)
- Smoother second hand sweep
- Reliable keep-on-top behavior
- Wayland compatible

## Dependencies
- Qt6 (`/usr/lib64/qt6/bin/qml`)
- wmctrl
- xdotool

## Installation

### Fedora (.rpm)
```bash
sudo dnf install cairo-qml-clock-0.1.0-1.fc43.noarch.rpm
```

### PCLinuxOS (.rpm)
```bash
sudo rpm -i cairo-qml-clock-0.1.0-1.fc43.noarch.rpm
```
Note: Built on Fedora 43 - fc43 label is cosmetic only

### Debian/Ubuntu/MX Linux (.deb)
```bash
sudo dpkg -i cairo-qml-clock_0.1.0.deb
```

## Run
```bash
cairo-qml-clock
```

## Theme Structure
Themes are organized into three subfolders:
```
themes/
  favorites/         - curated selection from bundled and custom (default folder)
  bundled/           - original cairo-clock themes, unmodified
  custom/            - locally created themes (empty, reserved for future use)
```

Each theme folder contains 12 SVG files + theme.conf

## Known Issues
- SVG hand files have embedded PNGs with offset pivot points
  making native SVG hand rotation unreliable
- Current solution: Canvas-drawn hands over SVG face layers
- Keep on top may have a brief delay activating on some window managers
- Sticky workspace uses wmctrl/xdotool — works on X11 only, not Wayland
