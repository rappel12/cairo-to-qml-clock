#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QUrl>

int main(int argc, char *argv[])
{
    qputenv("QML_XHR_ALLOW_FILE_READ", "1");

    // On non-KDE desktops use the GTK3 platform theme (reads system fonts/colors)
    // and Adwaita widget style — both are bundled in the KDE Platform runtime.
    const QByteArray desktop = qgetenv("XDG_CURRENT_DESKTOP").toLower();
    if (!desktop.contains("kde") && !desktop.contains("plasma")) {
        qputenv("QT_QPA_PLATFORMTHEME", "gtk3");
        qputenv("QT_STYLE_OVERRIDE",    "adwaita");
    }

    QGuiApplication app(argc, argv);
    // Keep these matching the old qml runner so existing settings files are preserved
    app.setApplicationName("Qml Runtime");
    app.setOrganizationName("QtProject");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("file:///app/share/cairo-qml-clock/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
