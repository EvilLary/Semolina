pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Io

Singleton {
    id: root

    property string targetID

    property list<var> texts: []
    property list<var> images: []
    property bool ready: false
    Process {
        id: cliphist
        manageLifetime: true
        command: ["/home/spicy/Documents/git/cliphist/cliphist", "list"]
        stdout: SplitParser {
            onRead: data => {
                const [id,content,imagePath] = data.split(`\t`)
                if (imagePath == undefined) {
                    root.texts.push({"id":id,"content":content})
                } else {
                    root.images.push({"id":id,"content":content,"image":imagePath})
                }

                ////Well truns out that copying an existing item in cliphist changes its id :)
                ////if (!root.recordedIds.includes(id)) {

                ////    root.recordedIds.push(id)
                ////    const clipData = data.slice(seperatorIndex,).trim()
                ////    const [entryContent,imagePath] = clipData.split("::/?[image]]-]")

                ////    if (imagePath == undefined) {
                ////        root.texts.push({"image": imagePath,"id": id,"content": entryContent})
                ////    } else {
                ////        root.images.push({"image": imagePath,"id": id,"content": entryContent})
                ////    }
                ////}

                // OK, I don't know any other solution to get image paths
                //const seperatorIndex = data.indexOf("\t")
                //const id = data.slice(0,seperatorIndex)
                //const clipData = data.slice(seperatorIndex,).trim()
                //const [entryContent,imagePath] = clipData.split("::/?[image]]-]")
                //if (imagePath == undefined) {
                //    root.texts.push({"image": imagePath,"id": id,"content": entryContent})
                //} else {
                //    root.images.push({"image": imagePath,"id": id,"content": entryContent})
                //}
            }
        }
        onExited: root.ready = true
    }
    Process {
        id: removeGrbg
        command: ["sh","-c","rm -rf /run/user/1000/cliphist"]
        onExited: cliphist.running = true
    }
    Process {
        id: cliphistWipe
        command: ["sh","-c",'cliphist wipe']
    }
    Process {
        id: deleteQuery
        command: ['sh','-c',`echo ${root.targetID} | cliphist delete`]
        onExited: root.targetID = ""
    }
    Process {
        id: copy
        manageLifetime: true
        command: ["sh","-c",`cliphist decode ${root.targetID} | wl-copy`]
        onExited: root.targetID = ""
    }
    function deleteItem(targetID: string): void {
        root.targetID = targetID
        deleteQuery.running = true
    }
    function copyItem(targetID: string): void {
        root.targetID = targetID
        copy.running = true
    }
    function getClipboardData(): void {
        root.ready = false
        root.texts = []
        root.images = []
        removeGrbg.running = true
    }
    function wipeCliphist(): void {
        cliphistWipe.running = true
    }
}
