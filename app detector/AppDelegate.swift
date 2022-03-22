import SwiftUI
import Foundation
import AppKit

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
                                        do {
                                            var a:String = try! safeShell("echo \"aaaaaoaooaoaao\"")
//                                            print(a)
                                            a = try! safeShell("""
cd /Users/andrea/Documents/PROGETTI/GIT/the-daily-daily
git add .
git commit -m "auto commit swift"
git push origin main
""")
//                                            print(a)
                                            a = try! safeShell("""
git --version
""")
                                            print(a)
                                        }
                                    }
                                }
        }
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(functionOne), userInfo: nil, repeats: false)

    }
    

    @objc func functionOne () {
        print("hiding")
        NSApplication.shared.hide(nil)
    }
}
#endif

func safeShell(_ command: String) throws -> String {
    let task = Process()
    let pipe = Pipe()
    
    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.executableURL = URL(fileURLWithPath: "/bin/zsh") //<--updated

    try task.run() //<--updated
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    
    return output
}

// Example usage:

