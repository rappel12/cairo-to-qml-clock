#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDir>
#include <QFile>
#include <QStandardPaths>
#include <QUrl>
#include "config.h"

int main(int argc, char *argv[])
{
    qputenv("QML_XHR_ALLOW_FILE_READ", "1");

    // On non-KDE desktops use the GTK3 platform theme (reads system fonts/colors)
    // and Adwaita widget style — both are bundled in the KDE Platform runtime.
    const QByteArray desktop = qgetenv("XDG_CURRENT_DESKTOP").toLower();
    qputenv("QT_STYLE_OVERRIDE",    "Fusion");
    if (!desktop.contains("kde") && !desktop.contains("plasma")) {
        qputenv("QT_QPA_PLATFORMTHEME", "gtk3");

        // On Wayland with XWayland available, use XCB so Qt.Tool appears on all workspaces
        if (!qgetenv("WAYLAND_DISPLAY").isEmpty() && !qgetenv("DISPLAY").isEmpty())
            qputenv("QT_QPA_PLATFORM", "xcb");
    }

    QGuiApplication app(argc, argv);
    app.setApplicationVersion(APP_VERSION);

    // One-time migration: copy legacy "Qml Runtime" settings to the new location.
    // Uses QStandardPaths so the paths are correct under both Flatpak
    // (XDG_CONFIG_HOME → ~/.var/app/.../config/) and native installs (~/.config/).
    const QString configBase = QStandardPaths::writableLocation(QStandardPaths::GenericConfigLocation);
    const QString oldConf = configBase + "/QtProject/Qml Runtime.conf";
    const QString newDir  = configBase + "/io.github.rappel12";
    const QString newConf = newDir + "/CairoQmlClock.conf";
    if (QFile::exists(oldConf) && !QFile::exists(newConf)) {
        QDir().mkpath(newDir);
        QFile::copy(oldConf, newConf);
    }

    app.setApplicationName("CairoQmlClock");
    app.setOrganizationName("io.github.rappel12");
    app.setDesktopFileName("io.github.rappel12.CairoQmlClock");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("file://" QML_MAIN_PATH)));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
