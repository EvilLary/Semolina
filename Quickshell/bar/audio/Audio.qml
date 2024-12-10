import Quickshell.Services.Pipewire
import "root:Components"

Widget {

    required property PwNode node;
    required property string icon;

    iconSource: icon

    onRightClick: root.openMixer= !root.openMixer
    onLeftClick: node.audio.muted = !node.audio.muted
    onScrollUp: if (node.audio.volume < 1 )  { node.audio.muted = false ,node.audio.volume += 0.05 }
    onScrollDown: node.audio.muted = false ,node.audio.volume -= 0.05

}
