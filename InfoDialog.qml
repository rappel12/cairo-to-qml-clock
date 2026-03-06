import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: infoDialog
    title: "About Cairo QML Clock"
    width: 300
    height: 250
    minimumWidth: 300
    minimumHeight: 250
    flags: Qt.Dialog
    modality: Qt.NonModal

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 10

        Label {
            text: "Cairo QML Clock"
            font.bold: true
            font.pointSize: 16
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            text: "Version 0.1.0"
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            text: "A cairo-clock replacement\nbuilt with Qt6 QML"
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            text: "© 2026 Rick"
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            text: "Based on cairo-clock 0.3.4\nby Mirco \"MacSlow\" Müller"
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
