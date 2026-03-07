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

    property string themePath: "/home/rick/Projects/cairo-to-qml-clock/themes/Anticko/"
    property color handColor: "#3a2a1a"
    property color secondColor: "#8b0000"
    property bool stayOnTop: true
    property int smoothness: 3
    property bool showSeconds: true

    flags: stayOnTop ? Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.Tool
                     : Qt.FramelessWindowHint | Qt.Tool
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
    }
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
            root.hours   = now.getHours() % 12
            root.minutes = now.getMinutes()
            root.seconds = now.getSeconds() + now.getMilliseconds() / 1000
            canvas.requestPaint()
        }
    }

   MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        property point lastPos
         onPressed: function(mouse) {
            if (mouse.button === Qt.RightButton) {
                contextMenu.popup()
            } else {
                lastPos = Qt.point(mouseX, mouseY)
            }
        }
        onPositionChanged: {
            if (pressedButtons & Qt.LeftButton) {
                root.x += mouseX - lastPos.x
                root.y += mouseY - lastPos.y
            }
        }
    }

    Menu {
        id: contextMenu
        MenuItem { text: "Properties"; onTriggered: propWindow.show() }
        MenuItem { text: "Info"; onTriggered: infoWindow.show() }
        MenuSeparator {}
        MenuItem { text: "Quit"; onTriggered: Qt.quit() }
    }

    Item {
        anchors.fill: parent

        Image { anchors.fill: parent; source: themePath + "clock-drop-shadow.svg"; smooth: true; sourceSize: Qt.size(root.width, root.height) }
        Image { anchors.fill: parent; source: themePath + "clock-face.svg"; smooth: true; sourceSize: Qt.size(root.width, root.height) }
        Image { anchors.fill: parent; source: themePath + "clock-face-shadow.svg"; smooth: true; sourceSize: Qt.size(root.width, root.height) }
        Image { anchors.fill: parent; source: themePath + "clock-marks.svg"; smooth: true; sourceSize: Qt.size(root.width, root.height) }
        Image { anchors.fill: parent; source: themePath + "clock-frame.svg"; smooth: true; sourceSize: Qt.size(root.width, root.height) }

        Canvas {
            id: canvas
            anchors.fill: parent

            onPaint: {
                var ctx = getContext("2d")
                var cx = width / 2
                var cy = height / 2
                var r = Math.min(width, height) / 2

                ctx.clearRect(0, 0, width, height)

                var hr = ((root.hours * 30) + (root.minutes * 0.5)) * Math.PI / 180 - Math.PI / 2
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
            }
        }

        Image { anchors.fill: parent; source: themePath + "clock-glass.svg"; smooth: true; sourceSize: Qt.size(root.width, root.height) }
    }
PropertiesDialog {
        id: propWindow
        clockRoot: root
    }
 InfoDialog {
        id: infoWindow
    }
}
