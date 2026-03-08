import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.folderlistmodel

Window {
    id: propDialog
    title: "Cairo QML Clock - Properties"
    width: 420
    height: 750
    minimumWidth: 320
    minimumHeight: 750
    flags: Qt.Dialog
    modality: Qt.NonModal

    // Properties passed in from main.qml
    property var clockRoot: null

    GridLayout {
        anchors.fill: parent
        anchors.margins: 8
        columns: 2
        rowSpacing: 4
        columnSpacing: 4

        // --- Startup Size ---
        Label { text: "Startup Size"; font.bold: true; Layout.columnSpan: 2 }

      Label { text: "Width:"; enabled: sizePreset.currentIndex === 4 }
        SpinBox {
            id: widthBox
            from: 100; to: 600; value: clockRoot ? clockRoot.width : 250
            enabled: sizePreset.currentIndex === 4
            editable: true
        }

        Label { text: "Height:"; enabled: sizePreset.currentIndex === 4 }
        SpinBox {
            id: heightBox
            from: 100; to: 600; value: clockRoot ? clockRoot.height : 250
            enabled: sizePreset.currentIndex === 4
            editable: true
        }

        // --- Size Presets ---
        Label { text: "Preset:" }
        ComboBox {
            id: sizePreset
            Layout.fillWidth: true
            model: ["small (150x150)", "medium (250x250)", "large (350x350)", "extra large (450x450)", "custom"]
            onActivated: {
                if (currentIndex === 0) { widthBox.value = 150; heightBox.value = 150 }
                else if (currentIndex === 1) { widthBox.value = 250; heightBox.value = 250 }
                else if (currentIndex === 2) { widthBox.value = 350; heightBox.value = 350 }
                else if (currentIndex === 3) { widthBox.value = 450; heightBox.value = 450 }
            }
        } 

        // --- Theme ---
        Label { text: "Theme"; font.bold: true; Layout.columnSpan: 2 }

        Label { text: "Theme:" }
        ComboBox {
            id: themeBox
            Layout.fillWidth: true
            model: {
                var names = []
                for (var i = 0; i < themeListModel.count; i++)
                    names.push(themeListModel.get(i, "fileName"))
                return names
            }
            onVisibleChanged: {
                if (visible && clockRoot) {
                    syncTimer.start()
                }
            }
        }

        FolderListModel {
            id: themeListModel
            folder: "file:///home/rick/Projects/cairo-to-qml-clock/themes"
            showFiles: false
            showDirs: true
            showDotAndDotDot: false
            sortField: FolderListModel.Name
        }

    Timer {
        id: syncTimer
        interval: 150
        repeat: false
        onTriggered: {
            if (clockRoot) {
                var path = clockRoot.themePath
                for (var i = 0; i < themeBox.model.length; i++) {
                    if (path.toLowerCase().indexOf(themeBox.model[i].toLowerCase()) >= 0) {
                        themeBox.currentIndex = i
                        break
                    }
                }
            }
        }
    }

        // --- Display Options ---
        Label { text: "Display Options"; font.bold: true; Layout.columnSpan: 2 }

        CheckBox { id: showSecondsBox; text: "Show seconds"; checked: true; Layout.columnSpan: 2 }
        CheckBox { id: showDate; text: "Show date"; checked: false; Layout.columnSpan: 2 }
        CheckBox { id: keepOnTop; text: "Keep on top"; checked: clockRoot ? clockRoot.stayOnTop : true; Layout.columnSpan: 2 }
        CheckBox { id: appearTaskbar; text: "Appear in taskbar"; checked: false; Layout.columnSpan: 2 }
        CheckBox { id: stickWorkspace; text: "Stick to every workspace"; checked: false; Layout.columnSpan: 2 }
        CheckBox { id: use24h; text: "Use 24h mode"; checked: false; Layout.columnSpan: 2 }

        // --- Animation Smoothness ---
        Label { text: "Animation Smoothness"; font.bold: true; Layout.columnSpan: 2 }

        Label { text: "Rough" }
        Label { text: "Smooth"; Layout.alignment: Qt.AlignRight }

        Slider {
            id: smoothSlider
            Layout.columnSpan: 2
            Layout.fillWidth: true
            from: 1; to: 3; value: 3
            stepSize: 1
        }

        // --- Buttons ---
        Button {
            text: "Close"
            Layout.alignment: Qt.AlignLeft
            onClicked: propDialog.close()
        }
        Button {
            text: "Apply"
            Layout.alignment: Qt.AlignRight
            onClicked: {
                if (clockRoot) {
                    clockRoot.width = widthBox.value
                    clockRoot.height = heightBox.value
                    var selected = themeBox.model[themeBox.currentIndex]
                    if (selected) {
                        clockRoot.themePath = "/home/rick/Projects/cairo-to-qml-clock/themes/" + selected + "/"
                        var handColors = {
                            "Anticko":         "#3a2a1a",
                            "glassy":          "#ffffff",
                            "glassybest":      "#2a5a2a",
                            "railway2":        "#f0e68c",
                            "Rauland":         "#000000",
                            "Rauland-vintage": "#000000",
                            "Rhythm":          "#ffffff",
                            "siemens":         "#000000",
                            "wood":            "#3a2a1a",
							"street-clock":    "#000000"
                            
                        }
                        var secondColors = {
                            "Anticko":         "#8b0000",
                            "glassy":          "#ff4444",
                            "glassybest":      "#cc0000",
                            "railway2":        "#ff4444",
                            "Rauland":         "#ff0000",
                            "Rauland-vintage": "#ff0000",
                            "Rhythm":          "#ff4444",
                            "siemens":         "#ff0000",
                            "wood":            "#8b0000",
							"street-clock":    "#ff0000"
                        }
                        clockRoot.handColor = handColors[selected] || "#000000"
                        clockRoot.secondColor = secondColors[selected] || "#ff0000"
                    }
                    clockRoot.stayOnTop = keepOnTop.checked
                    clockRoot.smoothness = smoothSlider.value
                    clockRoot.showSeconds = showSecondsBox.checked
                }
                propDialog.close()
            }
        }
    }
}
