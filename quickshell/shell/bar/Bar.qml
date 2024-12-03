import QtQuick.Layouts
import Quickshell
import "systray" as SysTray
import "audio" as Audio
import "workspaces" as Workspaces
import "root:Components" as Components
import QtQuick
import QtQuick.Controls
BarContainment {

    id: root
    // property bool isSoleBar: Quickshell.screens.length == 1;

    LazyLoader {
        activeAsync: audio.openMixer
        Audio.Mixer {
            id: popup
            window: root
            isVisible: true
        }
    }

    ColumnLayout {
        id: top
        anchors {
            right: parent.right
            left: parent.left
            top: parent.top
        }
        Workspaces.Indicator {
            bar: root
            Layout.fillWidth: true
            wsBaseIndex: 1;
            // hideWhenEmpty: isSoleBar
        }
    }

    ColumnLayout {
        id: bottom
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
