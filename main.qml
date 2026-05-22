import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtCore

Window {
    id: root
    width: 300
    height: 300
    visible: true
    color: "transparent"
    title: "Cairo Clock"

	
	property string appDir: Qt.resolvedUrl(".").toString().replace("file://", "")
    property string themePath: appDir + "themes/favorites/Anticko/"
    property string fallbackTheme: appDir + "themes/bundled/radium/"
    property color handColor: "#3a2a1a"
    property color secondColor: "#8b0000"
    property bool stayOnTop: true
    property int smoothness: 3
    property bool showSeconds: true
    property bool showDate: false
    property bool use24h: false
    property bool isWayland: Qt.platform.pluginName === "wayland"
    // BypassWindowManagerHint = override_redirect: WM-unmanaged, appears on all workspaces.
    // Wayland (KDE) keeps normal WM window; everything else uses bypass.
    flags: isWayland
        ? (stayOnTop ? Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.Window
                     : Qt.FramelessWindowHint | Qt.Window)
        : Qt.FramelessWindowHint | Qt.BypassWindowManagerHint

    property point _dragPressScreen
    property point _dragWindowOrigin
    property bool _wmDrag: false
   Settings {
        id: settings    
        property alias x: root.x
        property alias y: root.y
        property alias width: root.width
        property alias height: root.height
        property alias themePath: root.themePath
        property alias handColor: root.handColor
        property alias secondColor: root.secondColor
        property alias stayOnTop: root.stayOnTop
        property alias smoothness: root.smoothness
        property alias showSeconds: root.showSeconds
        property alias showDate: root.showDate
        property alias use24h: root.use24h
    }

    function getHandColor(path) {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", "file://" + path + "theme.conf", true)
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 0 || xhr.status === 200) {
                    var lines = xhr.responseText.split("\n")
                    for (var i = 0; i < lines.length; i++) {
                        var line = lines[i].trim()
                        if (line.startsWith("hand-color=")) {
                            root.handColor = line.split("=")[1].trim()
                        }
                        if (line.startsWith("second-color=")) {
                            root.secondColor = line.split("=")[1].trim()
                        }
                    }
                } else {
                    root.handColor = "#000000"
                    root.secondColor = "#ff0000"
                }
            }
        }
        xhr.send()
    }
    Component.onCompleted: getHandColor(root.themePath)
    onActiveChanged: if (!active) contextMenu.visible = false

   
    property int hours: 0
    property int minutes: 0
    property real seconds: 0

    Timer {
        interval: root.smoothness === 1 ? 500 : root.smoothness === 2 ? 100 : 16
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            var now = new Date()
            root.hours = root.use24h ? now.getHours() : now.getHours() % 12
            root.minutes = now.getMinutes()
            root.seconds = now.getSeconds() + now.getMilliseconds() / 1000
            canvas.requestPaint()
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onPressed: function(mouse) {
            if (mouse.button === Qt.RightButton)
                contextMenu.show(mouseX, mouseY)
            else {
                _wmDrag = root.isWayland && root.startSystemMove()
                if (!_wmDrag) {
                    var g = mapToGlobal(mouse.x, mouse.y)
                    root._dragPressScreen = Qt.point(g.x, g.y)
                    root._dragWindowOrigin = Qt.point(root.x, root.y)
                }
            }
        }
        onPositionChanged: function(mouse) {
            if ((mouse.buttons & Qt.LeftButton) && !_wmDrag) {
                var g = mapToGlobal(mouse.x, mouse.y)
                root.x = root._dragWindowOrigin.x + (g.x - root._dragPressScreen.x)
                root.y = root._dragWindowOrigin.y + (g.y - root._dragPressScreen.y)
            }
        }
    }

    // Transparent full-window overlay — catches clicks outside the menu
    MouseArea {
        anchors.fill: parent
        visible: contextMenu.visible
        z: 10
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onPressed: function(mouse) {
            contextMenu.visible = false
            if (mouse.button === Qt.RightButton)
                contextMenu.show(mouseX, mouseY)
        }
    }

    Rectangle {
        id: contextMenu
        visible: false
        z: 11
        width: 160
        height: menuCol.implicitHeight + 8
        color: palette.window
        border.color: palette.mid
        border.width: 1

        function show(px, py) {
            x = Math.min(px, root.width - width)
            y = Math.min(py, root.height - height)
            visible = true
        }

        Column {
            id: menuCol
            anchors { left: parent.left; right: parent.right; top: parent.top; margins: 4 }
            ItemDelegate { width: parent.width; text: "Properties"; onClicked: { contextMenu.visible = false; propWindow.show() } }
            ItemDelegate { width: parent.width; text: "Info";       onClicked: { contextMenu.visible = false; infoWindow.show() } }
            Rectangle    { width: parent.width; height: 1; color: palette.mid; opacity: 0.5 }
            ItemDelegate { width: parent.width; text: "Quit";       onClicked: Qt.quit() }
        }
    }

    Item {
        anchors.fill: parent

        ThemeImage { filename: "clock-drop-shadow.svg" }
        ThemeImage { filename: "clock-face.svg" }
        ThemeImage { filename: "clock-face-shadow.svg" }
        ThemeImage { filename: "clock-marks.svg" }
        ThemeImage { filename: "clock-frame.svg" }

        Canvas {
            id: canvas
            anchors.fill: parent

            onPaint: {
                var ctx = getContext("2d")
                var cx = width / 2
                var cy = height / 2
                var r = Math.min(width, height) / 2

                ctx.clearRect(0, 0, width, height)

                var hr = (root.use24h ? (root.hours * 15 + root.minutes * 0.25) : (root.hours * 30 + root.minutes * 0.5)) * Math.PI / 180 - Math.PI / 2
                ctx.beginPath()
                ctx.moveTo(cx, cy)
                ctx.lineTo(cx + Math.cos(hr) * r * 0.5, cy + Math.sin(hr) * r * 0.5)
                ctx.strokeStyle = root.handColor
                ctx.lineWidth = 6
                ctx.lineCap = "round"
                ctx.stroke()

                var mn = (root.minutes * 6) * Math.PI / 180 - Math.PI / 2
                ctx.beginPath()
                ctx.moveTo(cx, cy)
                ctx.lineTo(cx + Math.cos(mn) * r * 0.72, cy + Math.sin(mn) * r * 0.72)
                ctx.strokeStyle = root.handColor
                ctx.lineWidth = 4
                ctx.lineCap = "round"
                ctx.stroke()

                if (root.showSeconds) {
                    var sc = (root.seconds * 6) * Math.PI / 180 - Math.PI / 2
                    ctx.beginPath()
                    ctx.moveTo(cx, cy)
                    ctx.lineTo(cx + Math.cos(sc) * r * 0.82, cy + Math.sin(sc) * r * 0.82)
                    ctx.strokeStyle = root.secondColor
                    ctx.lineWidth = 1.5
                    ctx.lineCap = "round"
                    ctx.stroke()
                    ctx.beginPath()
                    ctx.arc(cx, cy, 4, 0, Math.PI * 2)
                    ctx.fillStyle = root.secondColor
                    ctx.fill()
                } 
                if (root.showDate) {
                    var now = new Date()
                    var day = now.getDate()
                    var month = now.getMonth() + 1
                    var dateStr = day + "/" + month
                    ctx.font = "bold " + Math.round(r * 0.15) + "px sans-serif"
                    ctx.fillStyle = root.secondColor
                    ctx.textAlign = "center"
                    ctx.fillText(dateStr, cx, cy + r * 0.35)
                }
            }
        }

        ThemeImage { filename: "clock-glass.svg" }
    }

PropertiesDialog {
        id: propWindow
        clockRoot: root
    }
 InfoDialog {
        id: infoWindow
    }
}
