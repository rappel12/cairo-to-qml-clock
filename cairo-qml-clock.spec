Name:           cairo-qml-clock
Version:        0.1.0
Release:        1%{?dist}
Summary:        A cairo-clock replacement built with Qt6 QML

License:        GPLv2
URL:            https://github.com/rappel12/cairo-to-qml-clock
Source0:        %{name}-%{version}.tar.gz

Requires:       qt6-qtdeclarative
Requires:       wmctrl
Requires:       xdotool

BuildArch:      noarch
%global __brp_mangle_shebangs_exclude_from cairo-qml-clock

%description
A modern reimplementation of MacSlow's cairo-clock using Qt6 QML.
Runs on modern Linux systems without deprecated dependencies.
Features smooth sweep second hand, multiple themes, and sticky workspace support.

%prep
%setup -q -n cairo-to-qml-clock-main

%install
mkdir -p %{buildroot}/usr/share/cairo-qml-clock
mkdir -p %{buildroot}/usr/bin
mkdir -p %{buildroot}/usr/share/applications
mkdir -p %{buildroot}/usr/share/pixmaps

cp main.qml %{buildroot}/usr/share/cairo-qml-clock/
cp InfoDialog.qml %{buildroot}/usr/share/cairo-qml-clock/
cp PropertiesDialog.qml %{buildroot}/usr/share/cairo-qml-clock/
cp -r themes %{buildroot}/usr/share/cairo-qml-clock/

cat > %{buildroot}/usr/bin/cairo-qml-clock << 'SCRIPT'
#! /bin/bash
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
SCRIPT
chmod +x %{buildroot}/usr/bin/cairo-qml-clock
sed -i 's|#!/usr/bin/bash|#!/bin/bash|' %{buildroot}/usr/bin/cairo-qml-clock

cat > %{buildroot}/usr/share/applications/cairo-qml-clock.desktop << 'DESKTOP'
[Desktop Entry]
Name=Cairo QML Clock
Comment=A cairo-clock replacement built with Qt6 QML
Exec=cairo-qml-clock
Icon=cairo-qml-clock
Type=Application
Categories=Utility;Clock;
StartupNotify=false
DESKTOP

%files
/usr/share/cairo-qml-clock/
/usr/bin/cairo-qml-clock
/usr/share/applications/cairo-qml-clock.desktop

%post
sed -i 's|#!/usr/bin/bash|#!/bin/bash|' /usr/bin/cairo-qml-clock

%changelog
* Mon Mar 24 2026 Rick Appel <> - 0.1.0-1
- Initial release
