import QtQuick 2.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.private.pager 2.0

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
                    anchors.centerIn: parent
                    Repeater {
                        model: TasksModel
                        Rectangle {
                            width: 16; height: 16
                            border.width: 1
                            color: "orange"
                            PlasmaCore.IconItem {
                                anchors.centerIn: parent
                                source: model.decoration
                                height: parent.height
                                width: parent.width
                            }
                        }
                    }
                }
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
