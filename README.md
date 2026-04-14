# Cairo-to-QML Clock Port

## Status (as of April 10, 2026)
- Frameless transparent window
- 30 themes organized in folder-based structure (see Theme Structure below)- Theme-aware hand colors with automatic color correction on startup
- Smooth sweep second hand (16ms timer) — improved over original cairo-clock
- Right-click menu: Properties, Info, Quit
- Properties dialog with size presets (small/medium/large/extra large/custom)
- Custom size entry via editable spinboxes
- Folder selector ComboBox (favorites/bundled/custom) for theme browsing
- Show seconds toggle
- Show date toggle (European format DD/MM)
- Keep on top toggle (X11 only)
- 24-hour mode for -24 themes
- Animation smoothness slider (3 levels)
- Sticks to every workspace (X11 only)
- Position/size/theme/settings memory (QtCore Settings)
- Draggable on both X11 and Wayland
- Auto-detects Wayland vs X11 session at runtime
- Hides from taskbar on X11 (Qt.Tool flag)
- Developed with AI assistance as a learning project
- GPL v2 licensed (see LICENSE file)

## Advantages over original cairo-clock 0.3.4
- Runs on modern Linux (Qt6, no deprecated libglade2 dependency)
- Smoother second hand sweep
- Reliable keep-on-top behavior (X11)
- Wayland compatible with smooth dragging

## Dependencies
- Qt6 qml runtime (see distro-specific notes below)
- wmctrl
- xdotool
- picom (recommended for transparency on Fluxbox/Openbox)

## Installation
```bash
git clone https://github.com/rappel12/cairo-to-qml-clock.git
cd cairo-to-qml-clock
```

### Debian/Ubuntu/MX Linux
```bash
sudo apt install qml-qt6 wmctrl xdotool
```

### Fedora
```bash
sudo dnf install qt6-qtdeclarative-devel wmctrl xdotool
```

### PCLinuxOS
```bash
sudo rpm -i cairo-qml-clock-0.1.0-1.fc43.noarch.rpm
```
Note: RPM package available — fc43 label is cosmetic only

## Run
```bash
QML_XHR_ALLOW_FILE_READ=1 /usr/lib64/qt6/bin/qml main.qml
```

Qt6 qml path varies by package manager:
- RPM-based (Fedora, PCLinuxOS, openSUSE): `/usr/lib64/qt6/bin/qml`
- DEB-based (Debian, Ubuntu, MX Linux): `/usr/lib/qt6/bin/qml`

## Fluxbox/Openbox Notes
Picom is required for window transparency. Add to `~/.fluxbox/startup` before `exec fluxbox`:
```bash
picom --backend glx -c --shadow-opacity 0 &
bash -c 'cd /home/USER/cairo-to-qml-clock && QML_XHR_ALLOW_FILE_READ=1 /usr/lib/qt6/bin/qml main.qml' &
```

## Theme Structure
Themes are organized into three subfolders:
themes/
favorites/         - curated selection from bundled and custom (default folder)
bundled/           - original cairo-clock themes, unmodified
custom/            - locally created themes (empty, reserved for future use)


Each theme folder contains 12 SVG files + theme.conf

## Known Issues
- SVG hand files have embedded PNGs with offset pivot points
  making native SVG hand rotation unreliable
- Current solution: Canvas-drawn hands over SVG face layers
- Keep on top and sticky workspace require X11 — not available on Wayland
- Taskbar hiding (Qt.Tool) works on X11 only
- Ubuntu 24.04 ships Qt 6.4 which lacks QtCore Settings module —
  upgrade to Ubuntu 24.10+ recommended
