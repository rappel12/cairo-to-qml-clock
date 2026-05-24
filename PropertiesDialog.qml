import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.folderlistmodel

Window {
    id: propDialog
    title: "Cairo QML Clock - Properties"
    width: 420
    height: 600
    minimumWidth: 320
    minimumHeight: 400
    flags: Qt.Window
    modality: Qt.NonModal

    // Properties passed in from main.qml
    property QtObject clockRoot: null

    readonly property int presetIndex: {
        if (!clockRoot) return 4
        var w = Math.round(clockRoot.width)
        if      (w === 150) return 0
        else if (w === 250) return 1
        else if (w === 350) return 2
        else if (w === 450) return 3
        else                return 4
    }

    ScrollView {
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true

        GridLayout {
            width: parent.width
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
                currentIndex: propDialog.presetIndex
                onActivated: {
                    if (currentIndex === 0) { widthBox.value = 150; heightBox.value = 150 }
                    else if (currentIndex === 1) { widthBox.value = 250; heightBox.value = 250 }
                    else if (currentIndex === 2) { widthBox.value = 350; heightBox.value = 350 }
                    else if (currentIndex === 3) { widthBox.value = 450; heightBox.value = 450 }
                }
            }

            // --- Theme ---
            Label { text: "Theme"; font.bold: true; Layout.columnSpan: 2 }

            Label { text: "Folder:" }
            ComboBox {
                id: folderBox
                Layout.fillWidth: true
                model: ["favorites", "bundled", "custom"]
                onActivated: {
                    themeListModel.folder = "file://" + clockRoot.appDir + "themes/" + model[currentIndex]
                }
            }

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
                        var path = clockRoot.themePath
                        var folders = ["favorites", "bundled", "custom"]
                        var detectedIdx = 0
                        for (var i = 0; i < folders.length; i++) {
                            if (path.indexOf("/themes/" + folders[i] + "/") >= 0) {
                                detectedIdx = i
                                break
                            }
                        }
                        if (folderBox.currentIndex !== detectedIdx) {
                            folderBox.currentIndex = detectedIdx
                            themeListModel.folder = "file://" + clockRoot.appDir + "themes/" + folders[detectedIdx]
                            // syncTimer fires via themeListModel.onStatusChanged when model reloads
                        } else {
                            syncTimer.start()
                        }
                    }
                }
            }

            FolderListModel {
                id: themeListModel
                folder: "file://" + clockRoot.appDir + "themes/favorites"
                showFiles: false
                showDirs: true
                showDotAndDotDot: false
                sortField: FolderListModel.Name
                onStatusChanged: {
                    if (status === FolderListModel.Ready && clockRoot) {
                        syncTimer.start()
                    }
                }
            }

            Timer {
                id: syncTimer
                interval: 500
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

            CheckBox { id: showSecondsBox; text: "Show seconds"; checked: clockRoot ? clockRoot.showSeconds : true; Layout.columnSpan: 2 }
            CheckBox { id: showDate; text: "Show date"; checked: clockRoot ? clockRoot.showDate : false; Layout.columnSpan: 2 }
            CheckBox { id: keepOnTop; text: "Keep on top"; checked: clockRoot ? clockRoot.stayOnTop : true; Layout.columnSpan: 2 }
            CheckBox { id: use24hBox; text: "Use 24h mode"; checked: clockRoot ? clockRoot.use24h : false; Layout.columnSpan: 2 }

            Label {
                text: "Sticks to every workspace (always on)"
                Layout.columnSpan: 2
                Layout.fillWidth: true
                opacity: 0.6
                wrapMode: Text.WordWrap
            }

            // --- Animation Smoothness ---
            Label { text: "Animation Smoothness"; font.bold: true; Layout.columnSpan: 2 }

            Label { text: "Rough" }
            Label { text: "Smooth"; Layout.alignment: Qt.AlignRight }

            Slider {
                id: smoothSlider
                Layout.columnSpan: 2
                Layout.fillWidth: true
                from: 1; to: 3; value: clockRoot ? clockRoot.smoothness : 3
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
                        var selectedFolder = folderBox.model[folderBox.currentIndex]
                        var selectedTheme = themeBox.model[themeBox.currentIndex]
                        if (selectedTheme) {
                            var fullPath = clockRoot.appDir + "themes/" + selectedFolder + "/" + selectedTheme + "/"
                            clockRoot.themePath = fullPath
                            var xhr = new XMLHttpRequest()
                            xhr.open("GET", "file://" + fullPath + "theme.conf", true)
                            xhr.onreadystatechange = function() {
                                if (xhr.readyState === XMLHttpRequest.DONE) {
                                    var handColor = "#000000"
                                    var secondColor = "#ff0000"
                                    if (xhr.status === 0 || xhr.status === 200) {
                                        var lines = xhr.responseText.split("\n")
                                        for (var i = 0; i < lines.length; i++) {
                                            var line = lines[i].trim()
                                            if (line.startsWith("hand-color="))
                                                handColor = line.split("=")[1].trim()
                                            if (line.startsWith("second-color="))
                                                secondColor = line.split("=")[1].trim()
                                        }
                                    }
                                    clockRoot.handColor = handColor
                                    clockRoot.secondColor = secondColor
                                }
                            }
                            xhr.send()
                        }
                        clockRoot.stayOnTop = keepOnTop.checked
                        clockRoot.smoothness = smoothSlider.value
                        clockRoot.showSeconds = showSecondsBox.checked
                        clockRoot.showDate = showDate.checked
                        clockRoot.use24h = use24hBox.checked
                    }
                }
            }
        }
    }
}
