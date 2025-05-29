import QtQuick
import Quickshell.Io

QtObject {
    id: root

    signal close()
    property list<var> texts
    property list<var> images
    property string status: ""
    property bool ready: false
    readonly property Process cliphist: Process {
        id: cliphist
        command: ["/home/spicy/Documents/git/cliphist/cliphist", "-preview-width", "100","list"]
        stdout: SplitParser {
            onRead: data => {
                const [id,content,imagePath] = data.split(`\t`)
                if (imagePath === undefined) {
                    root.texts.push({"id":id,"content":content})
                } else {
                    root.images.push({"id":id,"content":content,"image":imagePath})
                }
            }
        }
        onExited: root.ready = true
    }
    readonly property Process cmd: Process {
        id: cmd
    }
    readonly property Process grbg: Process {
        id: removeGrbg
        command: ["sh","-c","rm -rf /run/user/1000/cliphist"]
        onExited: cliphist.running = true
    }
    function deleteItem(id: string): void {
        cmd.command = ['sh','-c',`echo ${id} | cliphist delete`]
        cmd.startDetached()
    }
    function copyItem(id: string): void {
        cmd.command = ["sh","-c",`cliphist decode ${id} | wl-copy`]
        cmd.startDetached()
        root.close()
    }
    function getClipboardData(): void {
        // root.status = "loading"
        root.ready = false
        root.texts = []
        root.images = []
        removeGrbg.running = true
    }
    function wipeCliphist(): void {
        cmd.command = ["cliphist", "wipe"]
        cmd.startDetached()
        root.close()
    }
}
