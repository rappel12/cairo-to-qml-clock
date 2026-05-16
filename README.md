# Cairo-to-QML Clock

A modern reimplementation of MacSlow's cairo-clock using Qt6 QML. Runs on 
modern Linux without deprecated dependencies.

Developed by Rick Appel with AI assistance as a learning project. GPL v2 licensed.

## Features

- Frameless transparent window
- 30 themes organized in folder-based structure (favorites/bundled/custom)
- Theme-aware hand colors with automatic color correction on startup
- Smooth sweep second hand (16ms timer) — improved over original cairo-clock
- Right-click menu: Properties, Info, Quit (dismisses on click-outside on both X11 and Wayland)
- Properties dialog with size presets (small/medium/large/extra large/custom)
- Custom size entry via editable spinboxes
- Folder selector for theme browsing (favorites/bundled/custom)
- Show seconds toggle
- Show date toggle (European format DD/MM)
- Keep on top toggle
- 24-hour mode for -24 themes
- Animation smoothness slider (3 levels)
- Sticks to every workspace (X11 and Wayland sessions with XWayland)
- Position/size/theme/settings memory
- Draggable on both X11 and Wayland
- Properties and Info dialogs movable on Wayland
- Auto-detects Wayland vs X11 session at runtime
- Hides from taskbar on X11

## Advantages over cairo-clock 0.3.4

- Runs on modern Linux (Qt6, no deprecated libglade2 dependency)
- Smoother second hand sweep
- Reliable keep-on-top behavior
- Wayland compatible with smooth dragging and all-workspace sticking (requires XWayland)

## Installation

### Easy Install (Recommended)

Download the latest packages from the
[v0.1.1 release](https://github.com/rappel12/cairo-to-qml-clock/releases/tag/v0.1.1).

**Debian/MX Linux/Ubuntu**
sudo dpkg -i cairo-qml-clock_0.1.0-1_all.deb
sudo apt-get install -f

**Fedora/PCLinuxOS**
sudo rpm -i cairo-qml-clock-0.1.0-1.noarch.rpm

The `.deb` package automatically installs all dependencies. The RPM package
is compatible with Fedora, PCLinuxOS, and other RPM-based distros. The `fc43`
label in the filename is cosmetic only and does not affect compatibility.

**Flatpak (all distros)**
```
flatpak install cairo-qml-clock.flatpak
flatpak run io.github.rappel12.CairoQmlClock
```
The Flatpak is fully self-contained — no Qt6 or other dependencies needed on the host system.
The KDE Platform runtime (installed automatically) provides everything required.

### Build from Source
git clone https://github.com/rappel12/cairo-to-qml-clock.git
cd cairo-to-qml-clock
sudo apt install devscripts debhelper
dpkg-buildpackage -us -uc -b
sudo dpkg -i ../cairo-qml-clock_0.1.0-1_all.deb

### Manual Run (without installing)
QML_XHR_ALLOW_FILE_READ=1 /usr/lib/qt6/bin/qml main.qml

Qt6 qml path varies by distro:
- RPM-based (Fedora, PCLinuxOS, openSUSE): `/usr/lib64/qt6/bin/qml`
- DEB-based (Debian, Ubuntu, MX Linux): `/usr/lib/qt6/bin/qml`

## Dependencies

- `qml-qt6` — Qt6 QML runtime
- `picom` — recommended for transparency on Fluxbox/Openbox
- Flatpak requires `org.kde.Platform//6.9` runtime (installed automatically from Flathub)

## Fluxbox/Openbox Notes

Picom is required for window transparency. Add to `~/.fluxbox/startup`
before `exec fluxbox`:
picom --backend glx -c --shadow-opacity 0 &

## Theme Structure

Themes are organized into three subfolders under `themes/`:

- `favorites/` — curated selection (default folder)
- `bundled/` — original cairo-clock themes, unmodified
- `custom/` — reserved for user-created themes

Each theme folder contains 12 SVG files plus a `theme.conf` file.

## Known Issues

- SVG hand files have embedded PNGs with offset pivot points making native
  SVG hand rotation unreliable. Current solution: Canvas-drawn hands over
  SVG face layers.
- Taskbar hiding works on X11 only.
- Context menu uses a custom QML implementation rather than a native menu widget, required for reliable dismiss behavior on Wayland.
- Ubuntu 24.04 ships Qt 6.4 which lacks the QtCore Settings module —
  upgrade to Ubuntu 24.10 or later is recommended.

## Wayland Notes

The clock works on Wayland sessions. All-workspace sticking requires XWayland
to be present (both `WAYLAND_DISPLAY` and `DISPLAY` set), which is the case on
all major desktops — GNOME, Cinnamon, KDE, XFCE — when XWayland is enabled.

On **pure Wayland** sessions with XWayland explicitly disabled, the clock runs
normally but is confined to the workspace it was launched on. This is a Wayland
compositor limitation: there is no standard Wayland protocol for pinning a
window to all workspaces.

On **KDE Plasma Wayland**, the clock uses the native Wayland path (no XWayland
required) and workspace behavior is managed by KWin.
