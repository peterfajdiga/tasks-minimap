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

    Row {
        id: tasksContainer

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        property var taskItems: []

        Connections {
            target: tasksModel
            function onDataChanged(a, b, c) {
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

    Component {
        id: taskComponent

        Rectangle {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: height

            color: model.IsActive ? PlasmaCore.ColorScope.highlightColor : "transparent"
            opacity: model.IsMinimized ? 0.33 : 1.0

            property var model

            PlasmaCore.IconItem {
                anchors.centerIn: parent
                width: height
                height: Math.round(parent.height * 0.8)
                source: parent.model.decoration
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
