import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.taskmanager 0.1 as TaskManager
import "./utils.js" as Utils

MouseArea {
    id: root

    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation
    Layout.fillWidth: true
    Layout.fillHeight: true

    readonly property bool showMinimized: true

    Row {
        id: tasksContainer

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        property var tasks: []

        Repeater {
            model: parent.tasks

            Rectangle {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: height

                color: modelData.IsActive ? PlasmaCore.ColorScope.highlightColor : "transparent"
                opacity: modelData.IsMinimized ? 0.33 : 1.0

                PlasmaCore.IconItem {
                    anchors.centerIn: parent
                    width: height
                    height: Math.round(parent.height * 0.8)
                    source: modelData.decoration
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
