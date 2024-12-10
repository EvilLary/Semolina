import QtQuick.Layouts
import Quickshell
import "systray" as SysTray
import "audio" as Audio
import "workspaces" as Workspaces
import QtQuick

BarContainment {

    id: root

    LazyLoader {
        active: audio.openMixer
        Audio.Mixer {
            id: popup
            window: root
            isVisible: true
        }
    }

    ColumnLayout {
        id: topWidgets
        anchors {
            right: parent.right
            left: parent.left
            top: parent.top
        }
        Workspaces.Indicator2 {
            bar: root
            Layout.fillWidth: true
            wsBaseIndex: 1;
        }
    }

    ColumnLayout {
        id: centerWidgets
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        // TODO MPRIS
    }
    ColumnLayout {
        id: bottomWidgets
        spacing: 5
        anchors {
            right: parent.right
            left: parent.left
            bottom: parent.bottom
        }
        SysTray.List {
            id: sysTray
            Layout.fillWidth: true
        }
        Audio.Indicator {
            id: audio
            Layout.fillWidth: true
        }
        ClockWidget {
            Layout.fillWidth: true
        }
    }
}
