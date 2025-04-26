pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root
    signal notification(object: Notification)

    property alias tracked: server.trackedNotifications
    property int toastsCount: server.trackedNotifications.values.length
    property bool dndStatus: false
    property bool isDashboardOpen: false

    property string icon: {
        if (root.toastsCount > 0) {
            if (root.dndStatus) {
                return Quickshell.iconPath("notification-active")
            } 
            else {
                return Quickshell.iconPath("notification-active")
            }
        } 
        else {
            if (root.dndStatus) {
                return Quickshell.iconPath("notification-disabled")
            }
            else {
                return Quickshell.iconPath("notification-inactive")
            }
        }
    }
    NotificationServer {
        id: server
        actionsSupported: true
        actionIconsSupported: true
        imageSupported: true
        keepOnReload: true
        bodySupported: true
        persistenceSupported: true
        // extraHints: ["action-icons","urgency","image-path","desktop-entry","inline-reply"]
        onNotification: notification => {
            //must track for notification actions to work
            notification.tracked = true
            if (!root.dndStatus && !root.isDashboardOpen) {
                root.notification(notification)
            }
        }
    }
}
