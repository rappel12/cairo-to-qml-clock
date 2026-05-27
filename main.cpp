#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QWindow>
#include <QDir>
#include <QFile>
#include <QStandardPaths>
#include <QUrl>
#include <QObject>
#include "config.h"

#include <X11/Xlib.h>
#include <X11/Xatom.h>

class X11Helper : public QObject {
    Q_OBJECT
public:
    explicit X11Helper(QObject *parent = nullptr) : QObject(parent) {}

    // Call once after first frame: replaces _KDE_NET_WM_WINDOW_TYPE_OVERRIDE
    // with _NET_WM_WINDOW_TYPE_NORMAL so KWin stops treating us as always-on-top.
    Q_INVOKABLE void fixWindowType() {
        WId wid = mainWinId();
        if (!wid) return;
        Display *dpy = XOpenDisplay(nullptr);
        if (!dpy) return;
        Atom wmType = XInternAtom(dpy, "_NET_WM_WINDOW_TYPE", False);
        Atom normal  = XInternAtom(dpy, "_NET_WM_WINDOW_TYPE_NORMAL", False);
        XChangeProperty(dpy, (Window)wid, wmType, XA_ATOM, 32, PropModeReplace,
                        (unsigned char *)&normal, 1);
        XFlush(dpy);
        XCloseDisplay(dpy);
    }

    // Send _NET_WM_STATE client message to root window — no hide/show needed.
    Q_INVOKABLE void setStayOnTop(bool onTop) {
        WId wid = mainWinId();
        if (!wid) return;
        Display *dpy = XOpenDisplay(nullptr);
        if (!dpy) return;
        Atom wmState = XInternAtom(dpy, "_NET_WM_STATE", False);
        Atom above   = XInternAtom(dpy, "_NET_WM_STATE_ABOVE", False);

        XEvent ev = {};
        ev.xclient.type         = ClientMessage;
        ev.xclient.display      = dpy;
        ev.xclient.window       = (Window)wid;
        ev.xclient.message_type = wmState;
        ev.xclient.format       = 32;
        ev.xclient.data.l[0]    = onTop ? 1 : 0;  // _NET_WM_STATE_ADD / _REMOVE
        ev.xclient.data.l[1]    = (long)above;
        ev.xclient.data.l[2]    = 0;
        ev.xclient.data.l[3]    = 1;               // source: normal application
        ev.xclient.data.l[4]    = 0;

        XSendEvent(dpy, DefaultRootWindow(dpy), False,
                   SubstructureNotifyMask | SubstructureRedirectMask, &ev);
        XFlush(dpy);
        XCloseDisplay(dpy);
    }

private:
    static WId mainWinId() {
        for (QWindow *w : QGuiApplication::topLevelWindows())
            if (w->title() == QLatin1String("Cairo Clock"))
                return w->winId();
        return 0;
    }
};

// Xlib defines Bool, Status, None as macros which break QMetaType names in MOC output
#undef Bool
#undef Status
#undef None

#include "main.moc"

int main(int argc, char *argv[])
{
    qputenv("QML_XHR_ALLOW_FILE_READ", "1");
    qputenv("QT_STYLE_OVERRIDE",          "Fusion");
    qputenv("QT_QUICK_CONTROLS_STYLE",    "Fusion");
    // Suppress KWin server-side decorations on Wayland (no-op on X11)
    qputenv("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1");
    // On Wayland sessions with XWayland, use XCB: Xlib calls require an X display
    if (!qgetenv("WAYLAND_DISPLAY").isEmpty() && !qgetenv("DISPLAY").isEmpty())
        qputenv("QT_QPA_PLATFORM", "xcb");

    QGuiApplication app(argc, argv);
    app.setApplicationVersion(APP_VERSION);

    // One-time migration: copy legacy "Qml Runtime" settings to the new location.
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

    X11Helper x11helper;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("x11helper", &x11helper);
    engine.load(QUrl(QStringLiteral("file://" QML_MAIN_PATH)));
    if (engine.rootObjects().isEmpty())
        return -1;
    return app.exec();
}
