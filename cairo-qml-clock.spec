Name:           cairo-qml-clock
Version:        0.2.4
Release:        1%{?dist}
Summary:        A cairo-clock replacement built with Qt6 QML
License:        GPLv2
URL:            https://github.com/rappel12/cairo-to-qml-clock
Source0:        %{name}-%{version}.tar.gz
Requires:       qt6-qtdeclarative
BuildRequires:  cmake
BuildRequires:  gcc-c++
BuildRequires:  qt6-qtbase-devel
BuildRequires:  qt6-qtdeclarative-devel
%description
A modern reimplementation of MacSlow's cairo-clock using Qt6 QML.
Runs on modern Linux systems without deprecated dependencies.
Features smooth sweep second hand, multiple themes, and sticky workspace support.
%prep
%setup -q -n cairo-to-qml-clock-main
%build
cmake -B build \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release
cmake --build build
%install
DESTDIR=%{buildroot} cmake --install build

%files
/usr/share/applications/io.github.rappel12.CairoQmlClock.desktop
/usr/share/icons/hicolor/128x128/apps/io.github.rappel12.CairoQmlClock.png
/usr/share/metainfo/io.github.rappel12.CairoQmlClock.metainfo.xml
/usr/bin/cairo-qml-clock
/usr/share/cairo-qml-clock/

%changelog
* Sun May 24 2026 Rick Appel <rappel12@gmail.com> - 0.2.4-1
- Force Fusion style on all desktops — fixes ComboBox preset display under Breeze
- Reduce Properties dialog height
- Compiled binary replaces shell script launcher
* Sun May 18 2026 Rick Appel <rappel12@gmail.com> - 0.2.0-1
- Wayland fixes: context menu dismiss, dialog sizing, all-workspace visibility
- GTK appearance improvements for non-KDE desktops
- Updated app ID to io.github.rappel12.CairoQmlClock
* Thu May 15 2026 Rick Appel <rappel12@gmail.com> - 0.1.0-1
- Fix: Properties and Info dialogs now movable on KDE Plasma 6 Wayland
- Fix: Right-click context menu dismisses on click-outside on X11 and Wayland
* Tue Mar 24 2026 Rick Appel <rappel12@gmail.com> - 0.1.0-1
- Initial release
