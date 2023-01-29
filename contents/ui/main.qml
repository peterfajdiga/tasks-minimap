import QtQuick 2.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.private.pager 2.0
import "./utils.js" as Utils

MouseArea {
    id: root

    Row {
        Repeater {
            model: pagerModel
            Rectangle {
                visible: index === pagerModel.currentPage
                width: 160; height: 40
                border.width: 1
                color: "yellow"
                Row {
                    id: tasksContainer
                    anchors.centerIn: parent
                    property var taskItems: []
                    Connections {
                        target: TasksModel
                        function onDataChanged(a, b, c) {
                            refreshDelayer.restart();
                        }
                    }
                    Timer {
                        id: refreshDelayer
                        interval: 100
                        onTriggered: {
                            Utils.updateTasks(TasksModel, tasksContainer);
                        }
                    }
                }
            }
        }
    }

    Component {
        id: taskComponent
        Rectangle {
            property var model
            width: 16; height: 16
            border.width: 1
            color: "orange"
            PlasmaCore.IconItem {
                anchors.centerIn: parent
                source: parent.model.decoration
                height: parent.height
                width: parent.width
            }
        }
    }

    PagerModel {
        id: pagerModel

        enabled: root.visible

        showDesktop: false

        showOnlyCurrentScreen: false // TODO: Plasmoid.configuration.showOnlyCurrentScreen
        screenGeometry: Plasmoid.screenGeometry

        pagerType: PagerModel.VirtualDesktops
    }
}
