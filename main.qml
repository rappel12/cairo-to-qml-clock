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

    property string themePath: "/home/rick/Projects/cairo-to-qml-clock/themes/C_Anticko/"
    property color handColor: "#3a2a1a"
    property color secondColor: "#8b0000"
    property bool stayOnTop: true
    property int smoothness: 3
    property bool showSeconds: true
    property bool showDate: false

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
        property alias showDate: root.showDate      
    }
function getHandColor(path) {
    var handColors = {
        "C_Anticko": "#3a2a1a", "glassy": "#ffffff", "C_glassybest": "#2a5a2a",
        "C_Plain-Clock-Roman-Numerals": "#000000",
        "C_railway2": "#f0e68c", "C_Rauland": "#000000", "C_Rauland-vintage": "#000000",
        "C_Rhythm": "#ffffff", "C_siemens": "#000000", "C_wood": "#3a2a1a",
        "C_street-clock": "#000000",
        "antique": "#000000", "default": "#282d30", "default-24": "#282d30",
		"fdo": "#000000", "funky": "#00ff00", "gremlin": "#d76565",
		"gremlin-24": "#d76565", "ipulse": "#282d30", "ipulse-24": "#282d30",
		"quartz-24": "#000000", "radium": "#000000", "radium-24": "#000000",
		"silvia": "#000000", "silvia-24": "#000000", "simple": "#000000",
		"simple-24": "#000000", "tango": "#000000", "zen": "#724338"
    }
    var secondColors = {
        "C_Anticko": "#8b0000", "glassy": "#ff4444", "C_glassybest": "#cc0000",
        "C_Plain-Clock-Roman-Numerals": "#ff0000",
        "C_railway2": "#ff4444", "C_Rauland": "#ff0000", "C_Rauland-vintage": "#ff0000",
        "C_Rhythm": "#ff4444", "C_siemens": "#ff0000", "C_wood": "#8b0000",
        "C_street-clock": "#ff0000",
        "antique": "#ff0000", "default": "#ff0000", "default-24": "#ff0000",
		"fdo": "#ff0000", "funky": "#00ff00", "gremlin": "#ff0000",
		"gremlin-24": "#ff0000", "ipulse": "#ff0000", "ipulse-24": "#ff0000",
		"quartz-24": "#ff0000", "radium": "#ff0000", "radium-24": "#ff0000",
		"silvia": "#ff0000", "silvia-24": "#ff0000", "simple": "#ff0000",
		"simple-24": "#ff0000", "tango": "#ff0000", "zen": "#ff0000"
    }
}

    Component.onCompleted: getHandColor(root.themePath) 
   
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
