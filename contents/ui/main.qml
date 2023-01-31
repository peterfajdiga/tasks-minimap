import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.taskmanager 0.1 as TaskManager
import "./utils.js" as Utils

MouseArea {
    id: root

    anchors.fill: parent
    Layout.fillWidth: true
    Layout.fillHeight: true

    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation
    Plasmoid.constraintHints: PlasmaCore.Types.CanFillArea

    readonly property bool showMinimized: true
    readonly property color taskBgColor: Utils.colorAlpha(PlasmaCore.ColorScope.textColor, 0.2)
    readonly property color taskBgColorFocused: PlasmaCore.ColorScope.highlightColor

    Row {
        id: tasksContainer

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        spacing: 2

        property var taskGroups: []

        Repeater {
            model: parent.taskGroups

            Rectangle {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: height

                color: "transparent"

                ColumnLayout {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    spacing: 2

                    Repeater {
                        model: modelData

                        MouseArea {
                            width: parent.parent.width
                            Layout.fillHeight: true

                            onReleased: {
                                if (mouse.button === Qt.LeftButton) {
                                    tasksModel.requestActivate(modelData.tasksManagerIndex);
                                }
                            }

                            Rectangle {
                                width: parent.width
                                height: parent.height

                                color: modelData.IsMinimized ? "transparent" : modelData.IsActive ? taskBgColorFocused : taskBgColor
                                opacity: modelData.IsMinimized ? 0.33 : 1.0

                                PlasmaCore.IconItem {
                                    anchors.centerIn: parent
                                    width: parent.width
                                    height: Math.round(parent.height * 0.75)
                                    source: modelData.decoration
                                    roundToIconSize: height >= 16
                                }
                            }
                        }
                    }
                }
            }
        }

        Connections {
            target: tasksModel
            function onDataChanged(a, b, c) {
                refreshDelayer.restart();
            }
            function onRowsRemoved() {
                refreshDelayer.restart();
            }
        }

        Timer {
            id: refreshDelayer
            interval: 100
            onTriggered: {
                Utils.updateTasks(tasksModel, tasksContainer);
            }
        }
    }

    TaskManager.TasksModel {
        id: tasksModel

        virtualDesktop: virtualDesktopInfo.currentDesktop
        screenGeometry: Plasmoid.screenGeometry
        groupMode: TaskManager.TasksModel.GroupDisabled
        filterByVirtualDesktop: true
    }

    TaskManager.VirtualDesktopInfo {
        id: virtualDesktopInfo
    }
}
