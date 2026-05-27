import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: infoDialog
    title: "About Cairo QML Clock"
    property string appVersion: ""
    width: 300
    height: col.implicitHeight + 70
    minimumWidth: 300
    minimumHeight: height
    flags: Qt.Window
    modality: Qt.NonModal

    ColumnLayout {
        id: col
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 40
        width: parent.width - 40
        spacing: 10

        Label {
            text: "Cairo QML Clock"
            font.bold: true
            font.pointSize: 16
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            text: "Version " + appVersion
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            text: "A cairo-clock replacement\nbuilt with Qt6 QML"
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            text: "© 2025-2026 Rick Appel"
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            text: "Based on cairo-clock 0.3.4\nby Mirco \"MacSlow\" Müller"
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            text: "Released under GPL v2"
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            text: "Developed with AI assistance"
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }

        Button {
            text: "Close"
            Layout.alignment: Qt.AlignHCenter
            onClicked: infoDialog.close()
        }
    }
}
