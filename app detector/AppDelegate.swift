import SwiftUI
import Foundation
import AppKit

#if os(macOS)
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var lastChecked:Int = 0
    
    let source = """
                  delay 1
                  
                  tell application "Day One"
                      
                      activate
                      
                  end tell

                  delay 1

                  tell application "System Events"
                      
                      tell process "Day One"
                          
                          click menu item "JSON" of menu 1 of menu item "Export" of menu "File" of menu bar 1
                          delay 1
                          tell application "System Events" to key code 36 #return
                          delay 1
                          tell application "System Events" to key code 36 #return
                          
                      end tell
                      
                  end tell

                  tell application "Day One"
                      
                      quit
                      
                  end tell
                  """
        
     func applescript() -> Void {
            if let script = NSAppleScript(source: source) {
                var error: NSDictionary?
                script.executeAndReturnError(&error)
                if let err = error {
                    print(err)
                }
            }
        }
    
    func unzipMoveRemove() -> Void {
        do {
            let a:String = try! safeShell("""
cd /Users/andrea/Desktop
unzip "$(ls *-*-*_*-*-*.zip | sort -V | tail -n1)"
mv -f The\\ Daily\\ Daily.json /Users/andrea/Documents/PROGETTI/GIT/the-daily-daily/The\\ Daily\\ Daily.json
rm "$(ls *-*-*_*-*-*.zip | sort -V | tail -n1)"
""")
            print(a)
        }
    }
    
    func pushChanges() -> Void {
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

    func applicationWillFinishLaunching(_ notification: Notification) {
        
        
        print("start")
        
        let center = NSWorkspace.shared.notificationCenter
        center.addObserver(forName: NSWorkspace.didTerminateApplicationNotification,
                            object: nil,
                             queue: OperationQueue.main) { (notification: Notification) in
                                if let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication {
                                    if app.bundleIdentifier == "com.bloombuilt.dayone-mac" {
                                        let date = Date()
                                        let epoch = date.timeIntervalSince1970
                                        let intdate:Int = Int(epoch)
                                        print(intdate)
                                        if intdate-self.lastChecked>10 {
                                            print("Day One terminated")
                                            self.applescript()
                                            print("as doeneeeee   - - - - - - - - = = ==  = = ")
                                            self.unzipMoveRemove()
                                            self.lastChecked=intdate
                                            self.pushChanges()
                                        }
                                    }
                                    if app.bundleIdentifier == "com.github.atom" {
                                        print("Atom terminated")
                                        self.pushChanges()
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


