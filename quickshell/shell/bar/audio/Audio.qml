import Quickshell.Services.Pipewire
import ".."
import "root:./Services"
import Quickshell
import QtQuick
Widget {
    // id: root

    required property PwNode node;
    required property string icon;

    iconSource: icon
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onClicked: mouse => {
        if (mouse.button == Qt.LeftButton) {
            node.audio.muted = !node.audio.muted
        } else if (mouse.button == Qt.RightButton) {
            root.openMixer= !root.openMixer
        }
    }
    onWheel: wheel => {
        var wheelDelta = 0
        const delta = (wheel.angleDelta.y || -wheel.angleDelta.x) * (wheel.inverted ? -1 : 1)
        wheelDelta += delta;
        while (wheelDelta >= 120) {
            wheelDelta -= 120;
            if (node.audio.volume >= 1) {
                return
            }
            node.audio.muted = false
            node.audio.volume  +=  0.025
        }
        while (wheelDelta <= -120) {
            wheelDelta += 120;
            // isMuted = false
            node.audio.volume -=  0.025
        }
    }
}
