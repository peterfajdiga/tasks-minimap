import QtQuick 6.0
import QtQuick.Layouts 6.0
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.taskmanager as TaskManager
import "./utils.js" as Utils

PlasmoidItem {
    id: root

    anchors.fill: parent
    Layout.minimumWidth: childrenRect.width

    preferredRepresentation: fullRepresentation
    Plasmoid.constraintHints: Plasmoid.CanFillArea

    readonly property bool showMinimized: true
    readonly property color taskBgColor: Utils.colorAlpha(Kirigami.Theme.textColor, 0.2)
    readonly property color taskBgColorFocused: Kirigami.Theme.highlightColor
    readonly property color taskBgColorHovered: Qt.tint(taskBgColorFocused, taskBgColor)

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
                            width: parent.width
                            Layout.fillHeight: true

                            onReleased: {
                                switch (mouse.button) {
                                    case Qt.LeftButton: {
                                        tasksModel.requestActivate(modelData.tasksManagerIndex);
                                        break;
                                    }
                                    case Qt.MiddleButton: {
                                        tasksModel.requestClose(modelData.tasksManagerIndex);
                                        break;
                                    }
                                    case Qt.RightButton: {
                                        if (!modelData.IsMinimized) {
                                            tasksModel.requestToggleMinimized(modelData.tasksManagerIndex);
                                        }
                                        break;
                                    }
                                }
                            }

                            Rectangle {
                                width: parent.width
                                height: parent.height

                                color: hoverHandler.hovered ? taskBgColorHovered :
                                    modelData.IsMinimized ? "transparent" :
                                    modelData.IsActive ? taskBgColorFocused :
                                    taskBgColor
                                opacity: modelData.IsMinimized ? 0.33 : 1.0

                                Kirigami.Icon {
                                    anchors.centerIn: parent
                                    width: parent.width
                                    height: Math.round(parent.height * 0.75)
                                    source: modelData.decoration
                                    roundToIconSize: height >= 16
                                }
                            }

                            HoverHandler {
                                id: hoverHandler
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
        screenGeometry: screenGeometry
        groupMode: TaskManager.TasksModel.GroupDisabled
        filterByVirtualDesktop: true
    }

    TaskManager.VirtualDesktopInfo {
        id: virtualDesktopInfo
    }
}
