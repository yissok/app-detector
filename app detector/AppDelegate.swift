import SwiftUI

#if os(macOS)
class AppDelegate: NSObject, NSApplicationDelegate {


    func applicationWillFinishLaunching(_ notification: Notification) {
        print("start")
        
        let center = NSWorkspace.shared.notificationCenter
        center.addObserver(forName: NSWorkspace.didTerminateApplicationNotification,
                            object: nil,
                             queue: OperationQueue.main) { (notification: Notification) in
                                if let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication {
                                    if app.bundleIdentifier == "com.github.atom" {
                                        print("Atom terminated")
                                    }
                                }
        }
    }
}
#endif
