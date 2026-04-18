Name:           cairo-qml-clock
Version:        0.1.0
Release:        1%{?dist}
Summary:        A cairo-clock replacement built with Qt6 QML

License:        GPLv2
URL:            https://github.com/rappel12/cairo-to-qml-clock
Source0:        %{name}-%{version}.tar.gz

Requires:       qt6-qtdeclarative-devel
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
QML=/usr/lib64/qt6/bin/qml
QML_XHR_ALLOW_FILE_READ=1 $QML /usr/share/cairo-qml-clock/main.qml &

sleep 1
wmctrl -r "Cairo Clock" -b add,sticky
xdotool search --name "Cairo Clock" set_desktop_for_window 0xffffffff
wait
SCRIPT
chmod +x %{buildroot}/usr/bin/cairo-qml-clock
sed -i 's|#!/usr/bin/bash|#!/bin/bash|' %{buildroot}/usr/bin/cairo-qml-clock

mkdir -p %{buildroot}/usr/share/icons/hicolor/128x128/apps
cp cairo-qml-clock.png %{buildroot}/usr/share/icons/hicolor/128x128/apps/
mkdir -p %{buildroot}/usr/share/metainfo
cp cairo-qml-clock.metainfo.xml %{buildroot}/usr/share/metainfo/
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
/usr/share/metainfo/cairo-qml-clock.metainfo.xml
/usr/share/icons/hicolor/128x128/apps/cairo-qml-clock.png

%post
sed -i 's|#!/usr/bin/bash|#!/bin/bash|' /usr/bin/cairo-qml-clock

%changelog
* Mon Mar 24 2026 Rick Appel <> - 0.1.0-1
- Initial release
