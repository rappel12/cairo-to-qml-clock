#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QUrl>

int main(int argc, char *argv[])
{
    qputenv("QML_XHR_ALLOW_FILE_READ", "1");

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
