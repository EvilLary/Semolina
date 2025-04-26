import QtQuick
import QtQuick.Controls
import org.kde.plasma.emoji
import "../Libs"
import "../Components"

Rectangle {
    id: content
    color: Config.colors.background
    radius:Config.globalRadius
    TabBar {
        id: tabbar
        model: [
            //"", //history
            "",
            "", //faces
            "", //people
            "", //animals
            "󰉚", //food
            "", //activites
            "󰒕", //objects
            "󰇧", //travel
            "", //flags
            "󱔁", //symbols
        ]
        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
            margins: 8
        }
        activeIndex: 1
        height: 45
        textSize: 18
        onActiveIndexChanged: {
            switch(activeIndex) {
                case 0:
                    content.pageReplace("");
                    break;
                ;;
                case 1:
                    content.pageReplace("Smileys and Emotion");
                    break;
                ;;
                case 2:
                    content.pageReplace("People and Body");
                    break;
                ;;
                case 3:
                    content.pageReplace("Animals and Nature");
                    break;
                ;;
                case 4:
                    content.pageReplace("Food and Drink");
                    break;
                ;;
                case 5:
                    content.pageReplace("Activities");
                    break;
                ;;
                case 6:
                    content.pageReplace("Objects");
                    break;
                ;;
                case 7:
                    content.pageReplace("Travel and Places");
                    break;
                ;;
                case 8:
                    content.pageReplace("Flags");
                    break;
                ;;
                case 9:
                    content.pageReplace("Symbols");
                    break;
                ;;
            }
        }
    }

    EmojiModel {
        id: emoji
    }
    //RecentEmojiModel {
    //    id: recentEmojiModel
    //}
    Rectangle {
        anchors {
            bottom: parent.bottom
            right: parent.right
            left: parent.left
            top: tabbar.bottom
            margins: 8
        }
        color: Config.colors.altBackground
        radius: Config.globalRadius
        clip: true
        StackView {
            id: stackView
            anchors.fill: parent
            anchors.margins: 10
            initialItem: EmojiPage {
                category: "Smileys and Emotion"
                emojis: emoji
            }
        }
    }

    function pageReplace(category: string): void {
        stackView.replace("./EmojiPage.qml",{
            emojis: emoji,
            category: category,
        })
    }
}
