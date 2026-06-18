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
[v0.2.8 release](https://github.com/rappel12/cairo-to-qml-clock/releases/tag/v0.2.8).

**Debian/MX Linux/Ubuntu (amd64)**
sudo dpkg -i cairo-qml-clock_0.2.8-1_amd64.deb
sudo apt-get install -f

**Raspberry Pi 5 / ARM64 (Debian/Ubuntu-based)**
sudo dpkg -i cairo-qml-clock_0.2.8-1_arm64.deb
sudo apt-get install -f

**Fedora/PCLinuxOS**
sudo rpm -i cairo-qml-clock-0.2.8-1.x86_64.rpm

The `.deb` package automatically installs all dependencies. The RPM package
is compatible with Fedora, PCLinuxOS, and other RPM-based distros. 

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
sudo dpkg -i ../cairo-qml-clock_0.2.8-1_<arch>.deb

### Manual Run (without installing)
QML_XHR_ALLOW_FILE_READ=1 /usr/lib/qt6/bin/qml main.qml

Qt6 qml path varies by distro:
- RPM-based (Fedora, PCLinuxOS, openSUSE): `/usr/lib64/qt6/bin/qml`
- DEB-based (Debian, Ubuntu, MX Linux): `/usr/lib/qt6/bin/qml`

## Dependencies

- `qml-qt6` — Qt6 QML runtime
- `picom` — recommended for transparency on Fluxbox/Openbox
- Flatpak requires `org.kde.Platform//6.9` runtime (installed automatically from Flathub)

## Raspberry Pi / ARM64

Successfully built and running on Raspberry Pi 5 (8GB) with Armbian 26.5,
based on Ubuntu 26.04 LTS (Resolute Raccoon), kernel 7.0, KDE Plasma 6.

### Easy Install on Raspberry Pi 5

A prebuilt arm64 `.deb` is available on the
[v0.2.8 release page](https://github.com/rappel12/cairo-to-qml-clock/releases/tag/v0.2.8):

    sudo dpkg -i cairo-qml-clock_0.2.8-1_arm64.deb
    sudo apt-get install -f

### Build from source on Raspberry Pi 5

Install build dependencies:

    sudo apt install cmake build-essential qt6-base-dev qt6-declarative-dev libx11-dev qml-qt6

Then build and install as described in "Build from Source" above:

    git clone https://github.com/rappel12/cairo-to-qml-clock.git
    cd cairo-to-qml-clock
    mkdir build && cd build
    cmake ..
    make -j4
    sudo make install
    cairo-qml-clock

Qt 6.10.2 (the version available in Armbian 26.5 repos) builds and runs
the full application, including the X11Helper C++ component for
frameless window, drag, and always-on-top — all confirmed working.

### Autostart on Pi (KDE Plasma)

Create ~/.config/autostart/cairo-qml-clock.desktop:

    [Desktop Entry]
    Type=Application
    Name=Cairo QML Clock
    Exec=/usr/local/bin/cairo-qml-clock
    Terminal=false
    X-GNOME-Autostart-enabled=true

### Raspberry Pi 4

Not yet tested. The Pi 4 has less GPU capability than the Pi 5; results
may vary, particularly with multiple themes or larger clock sizes.

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
- Properties dialog text may appear gray on GTK-based desktops (Cinnamon, XFCE, etc.) due to Qt6/GTK theme    integration. Switching to the Adwaita GTK theme resolves this.

## Wayland Notes

The clock works on Wayland sessions. All-workspace sticking requires XWayland
to be present (both `WAYLAND_DISPLAY` and `DISPLAY` set), which is the case on
all major desktops — GNOME, Cinnamon, KDE, XFCE — when XWayland is enabled.

On **KDE Plasma Wayland**, the clock uses the native Wayland path (no XWayland
required) and workspace behavior is managed by KWin.

On **pure Wayland** sessions with XWayland explicitly disabled, the clock runs
normally but is confined to the workspace it was launched on. This is a Wayland
compositor limitation: there is no standard Wayland protocol for pinning a
window to all workspaces.

## Issue #6 — Scene Graph Refactor: Architectural Constraint

**Read this before writing any code for Issue #6.**

The SVG hand files contain embedded PNGs with offset pivot points. All pivot
compensation currently lives in the Canvas JavaScript:

    ctx.save()
    ctx.translate(cx, cy)
    ctx.rotate(angle)
    ctx.drawImage(handImage, ...)
    ctx.restore()

ThemeImage.qml has no knowledge of clock geometry. It handles image loading,
fallback, and sizing only. Do not modify ThemeImage.qml for this refactor.

**Required before writing any refactor code:**

1. Examine the actual pivot offset values in the current Canvas code.
2. Propose a QML Rotation transform strategy that correctly replicates the
   pivot behavior for each hand (hour, minute, second).
3. Confirm that ThemeImage.qml requires no changes.
4. Get that design approved before touching main.qml.

Do not assume that applying `rotation:` natively to a ThemeImage will behave
correctly. It will rotate around the image center, not the clock's center pin.

