import QtQuick

Image {
    anchors.fill: parent
    smooth: true
    sourceSize: Qt.size(parent.width, parent.height)

    property string filename: ""
    source: root.themePath + filename

    onStatusChanged: {
        if (status === Image.Error) {
            console.warn("Theme image missing, falling back to radium: " + source)
            root.themePath = root.fallbackTheme
        }
    }
}
